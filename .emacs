(setq custom-file "~/.emacs.d/custom.el") (load custom-file)

(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/twittering-mode")
(add-to-list 'load-path "~/.emacs.d/ljupdate")
(add-to-list 'load-path "~/.emacs.d/emacs-jabber")
(add-to-list 'load-path "~/.emacs.d/org-mode/lisp")
(add-to-list 'load-path "~/.emacs.d/icicles")

(setq load-path (cons (expand-file-name "~/.emacs.d/gnus/lisp") load-path))
(require 'gnus-load)

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil t)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (end-of-buffer)
    (eval-print-last-sexp)))

(el-get 'sync)


(load "~/.emacs.d/custom.el")

(setq confirm-kill-emacs 'yes-or-no-p)          ; Confirm quit

;;(setq package-archives '(("ELPA" . "http://tromey.com/elpa/") 
;;                         ("gnu" . "http://elpa.gnu.org/packages/")
;;			 ("marmalade" . "http://marmalade-repo.org/packages/")))


;;; no tabs please, we're British
(setq-default indent-tabs-mode nil)

;; mic-paren mode
;(require 'mic-paren)
;(paren-activate)

;; general config
(setq visible-bell 1)                   ; visual rather than audible bell
(setq inhibit-startup-message t)        ; Do without annoying startup msg.
(tool-bar-mode -1)                      ; turn off toolbar
(menu-bar-mode -1)
(scroll-bar-mode -1)

(windmove-default-keybindings)
(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>") 'shrink-window)
(global-set-key (kbd "S-C-<up>") 'enlarge-window)

;;; set the font size
(set-face-attribute 'default nil :height 100)

;; confluence.el
;;(require 'confluence)
;;(setq confluence-url "https://wiki.openmarket.com/rpc/xmlrpc")

(require 'uniquify)

(require 'term)
;; some term customisations
(custom-set-variables
 '(comint-scroll-to-bottom-on-input t)  ; always insert at the bottom
 '(comint-scroll-to-bottom-on-output t) ; always add output at the bottom
 '(comint-scroll-show-maximum-output t) ; scroll to show max possible output
 '(comint-completion-autolist t)        ; show completion list when ambiguous
 '(comint-input-ignoredups t)           ; no duplicates in command history
 '(comint-completion-addsuffix t)       ; insert space/slash after file completion
 )

(defun visit-term ()
  "If the current buffer is:
     1) a running ansi-term named *ansi-term*, rename it.
     2) a stopped ansi-term, kill it and create a new one.
     3) a non ansi-term, go to an already running ansi-term
        or start a new one while killing a defunt one"
  (interactive)
  (let ((is-term (string= "term-mode" major-mode))
        (is-running (term-check-proc (buffer-name)))
        (anon-term (get-buffer "*terminal*")))
    (if is-term
        (if is-running
              (rename-buffer (concat "term:" (replace-regexp-in-string 
					      "/home/tristan"
					      "~"
                                              (substring (pwd) 9))))
              (if anon-term
                  (switch-to-buffer "*terminal*")
                (multi-term))
          (kill-buffer (buffer-name))
          (multi-term))
      (if anon-term
          (if (term-check-proc "*terminal*")
              (switch-to-buffer "*terminal*")
            (kill-buffer "*terminal*")
            (multi-term))
        (multi-term)))))
(global-set-key (kbd "<f2>") 'visit-term)

(global-set-key (kbd "C-<f2>") 'multi-term)

(setq term-default-bg-color nil)
(setq ansi-term-color-vector [unspecified "black" "red3" "lime green" "yellow3" "DeepSkyBlue3" "magenta3" "cyan3" "white"])

(define-key term-raw-map (kbd "C-<left>") 'term-send-backward-word)
(define-key term-raw-map (kbd "C-<right>") 'term-send-forward-word)
(define-key term-raw-map (kbd "C-<backspace>") 'term-send-backward-kill-word)

(global-set-key (kbd "C-c r") 'rename-buffer)
(defun switch-to-gateways ()
  (interactive)
  (switch-to-buffer "#gateways@lifejacket"))
(global-set-key (kbd "C-c g") 'switch-to-gateways)

(require 'multi-term)
(setq multi-term-program "/bin/zsh")

;(display-time-mode 1)
;(setq display-time-24hr-format 't)

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))

(eval-after-load 'rcirc '(require 'rcirc-color))
(eval-after-load 'rcirc '(require 'rcirc-controls))
(eval-after-load 'rcirc '(require 'rcirc-notify))
(add-hook 'rcirc-mode-hook 
	  (lambda () 
	    (hl-line-mode 1)))

(add-hook 'rcirc-mode-hook
	  (lambda ()
	    (rcirc-track-minor-mode 1)))

(setq rcirc-buffer-maximum-lines 1000)

; adjust line length based on window size
(add-hook 'window-configuration-change-hook
          '(lambda ()
             (setq rcirc-fill-column (- (window-width) 2))))

;; twiterring-mode
(require 'twittering-mode)

(setq twittering-use-master-password t)

(add-hook 'twittering-mode-hook
	  (lambda ()
	    (twittering-icon-mode)))

(define-key twittering-mode-map (kbd "R") 'twittering-reply-to-user)


;; lj-update
;(require 'ljupdate)

;; haskell-mode
(load "~/.emacs.d/haskell-mode/haskell-site-file")


;;;;; org-mode config
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-log-done t) ;; log when TODO -> DONE

;; Make windmove work in org-mode:
(add-hook 'org-shiftup-final-hook 'windmove-up)
(add-hook 'org-shiftleft-final-hook 'windmove-left)
(add-hook 'org-shiftdown-final-hook 'windmove-down)
(add-hook 'org-shiftright-final-hook 'windmove-right)


;;; w3m
(setq w3m-default-display-inline-images t)
(setq w3m-use-favicon t)
(setq w3m-show-graphic-icons-in-header-line t)
(setq w3m-use-cookies t)

;;;; git svn mode in magit
(require 'magit-svn)

(global-set-key "\C-cm" 'magit-status)

(load-theme 'solarized)

;; paredit
(define-key paredit-mode-map (kbd "{") 'paredit-open-curly)
(define-key paredit-mode-map (kbd "}") 'paredit-close-curly)
