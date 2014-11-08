#lang racket

;;; Ett enkelt frågesport-spel
;;; För att köra igång:
;;; (frågesport)
;;; Om svaret är en sträng (text), svara med citat-tecken runt svaret
;;; Exempel:
;;; "Detta är ett svar"

;; En samling uppgifter
(define databasen '(("Vad heter språket detta programmet är skrivet i?" "Racket")
                    ("Vad het Racket förut?" "PLT Scheme")
                    ("Är Scheme en Lisp-dialekt?" #t)
                    ("Vilket år upptäcktes Lisp?" 1958)
                    ("Finns det coolare språk än Lisp?" #f)))

;; Givet en uppgift, returnera frågan som text
(define frågetext 
  (lambda (uppgift)
    (car uppgift)))

;; Givet en uppgift, returnera svaret
(define svar
  (lambda (uppgift)
    (car (cdr uppgift))))

;; Returnera uppgift nummer nr i databasen
(define hämta-uppgift
  (lambda (nr)
    (list-ref databasen nr)))

;; Returnera true om användarens svar accepteras/är rätt
;; Olika typer av svar jämförs med olika procedurer
;; Gör inte skillnad på små och stora bokstäver
(define jämför-svar
  (lambda (användarens-svar rätt-svar)
    (let ((jämförelseprocedur
           (cond ((string? rätt-svar) string-ci=?)
                 ((number? rätt-svar) =)
                 ((and (boolean? rätt-svar) (string? användarens-svar))
                  (lambda (anv rätt) ; låt #t betyda "ja" och #f betyda "nej"
                    (string-ci=? anv (if rätt "ja" "nej"))))
                 (else eq?))))
      (jämförelseprocedur användarens-svar rätt-svar))))

(define presentera-uppgift
  (lambda (uppgift)
    (printf "Fråga:~%")
    (printf "~s~%" (frågetext uppgift))))
    
(define hämta-användarens-svar
  (lambda ()
    (printf "Skriv ditt svar:~%")
    (read)))

;; Väljer ut tillfällig uppgift från databasen
;; Presenterar den för användaren
;; Avslutar och returnerar poängsumman om användaren skrev quit
;; Kollar annars om svaret var rätt och spelar igen
(define spela
  (lambda (poäng)
    (let ((uppgift (hämta-uppgift (random (length databasen)))))
      (presentera-uppgift uppgift)
      (let ((svaret (hämta-användarens-svar)))
        (printf "Du svarade ~s~%" svaret)
        (cond ((eq? svaret 'quit) (printf "Hejdå!~%") poäng)
              ((jämför-svar svaret (svar uppgift)) (printf "Du hade rätt! 1 poäng!~%") (spela (+ poäng 1)))
              (else (printf "Ooops! Du hade fel~%") (spela poäng)))))))

;; Skriver ut välkomstmeddelande och instruktioner
;; Initierar poängsumman till 0
(define frågesport
  (lambda ()
    (printf "Hej och välkommen!~%")
    (printf "För att avsluta, skriv quit~%")
    (printf "Låt spelet börja!~%")
    (printf "Du fick ~a poäng" (spela 0))))