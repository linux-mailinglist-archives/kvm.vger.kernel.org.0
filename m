Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3935603AF
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 11:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728315AbfGEJ7W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 05:59:22 -0400
Received: from foss.arm.com ([217.140.110.172]:34690 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728240AbfGEJ7V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 05:59:21 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C2F7B14FF;
        Fri,  5 Jul 2019 02:59:20 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 024143F246;
        Fri,  5 Jul 2019 02:59:19 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry@arm.com>
Cc:     kvm@vger.kernel.org, Dave Martin <dave.martin@arm.com>
Subject: [PATCH kvmtool 1/2] term: Avoid busy loop with unconnected pseudoterminals
Date:   Fri,  5 Jul 2019 10:59:13 +0100
Message-Id: <20190705095914.151056-2-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190705095914.151056-1-andre.przywara@arm.com>
References: <20190705095914.151056-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently when kvmtool is creating a pseudoterminal (--tty x), the
terminal thread will consume 100% of its CPU time as long as no slave
is connected to the other end. This is due to the fact that poll()
unconditonally sets the POLLHUP bit in revents and returns immediately,
regardless of the events we are querying for.

There does not seem to be a solution to this with just poll() alone.
Using the TIOCPKT ioctl sounds promising, but doesn't help either,
as poll still detects the HUP condition.

So apart from chickening out with some poll() timeout tricks, inotify
seems to be the way to go:
Each time poll() returns with the POLLHUP bit set, we disable this
file descriptor in the poll() array and rely on the inotify IN_OPEN
watch to fire on the slave end of the pseudoterminal. We then enable the
file descriptor again.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 term.c | 48 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 45 insertions(+), 3 deletions(-)

diff --git a/term.c b/term.c
index b8a70fe2..7fbd98c6 100644
--- a/term.c
+++ b/term.c
@@ -7,6 +7,7 @@
 #include <signal.h>
 #include <pty.h>
 #include <utmp.h>
+#include <sys/inotify.h>
 
 #include "kvm/read-write.h"
 #include "kvm/term.h"
@@ -21,6 +22,8 @@ static struct termios	orig_term;
 
 static int term_fds[TERM_MAX_DEVS][2];
 
+static int inotify_fd;
+
 static pthread_t term_poll_thread;
 
 /* ctrl-a is used for escape */
@@ -100,7 +103,7 @@ bool term_readable(int term)
 
 static void *term_poll_thread_loop(void *param)
 {
-	struct pollfd fds[TERM_MAX_DEVS];
+	struct pollfd fds[TERM_MAX_DEVS + 1];
 	struct kvm *kvm = (struct kvm *) param;
 	int i;
 
@@ -111,11 +114,42 @@ static void *term_poll_thread_loop(void *param)
 		fds[i].events = POLLIN;
 		fds[i].revents = 0;
 	}
+	fds[i].fd = inotify_fd;
+	fds[i].events = POLLIN;
+	fds[i].revents = 0;
 
 	while (1) {
+		int i;
+
 		/* Poll with infinite timeout */
-		if(poll(fds, TERM_MAX_DEVS, -1) < 1)
+		if(poll(fds, TERM_MAX_DEVS + 1, -1) < 1)
 			break;
+
+		for (i = 0; i < TERM_MAX_DEVS; i++) {
+			/*
+			 * Check for unconnected pseudoterminals. They will
+			 * make poll() return immediately, so we have to
+			 * disable those fds and rely on inotify to tell us
+			 * when the slave side gets opened.
+			 */
+			if (fds[i].revents == POLLHUP)
+				fds[i].fd = ~fds[i].fd;
+		}
+		if (fds[TERM_MAX_DEVS].revents) {	/* inotify fd */
+			struct inotify_event event;
+
+			/*
+			 * Just enable all fds that we previously disabled,
+			 * still unconnected ones will be disabled again on
+			 * the next poll() call.
+			 */
+			for (i = 0; i < TERM_MAX_DEVS; i++)
+				if (fds[i].fd < 0)
+					fds[i].fd = ~fds[i].fd;
+			/* Consume at least one inotify event. */
+			i = read(inotify_fd, &event, sizeof(event));
+		}
+
 		kvm__arch_read_term(kvm);
 	}
 
@@ -154,7 +188,11 @@ static void term_set_tty(int term)
 
 	close(slave);
 
-	pr_info("Assigned terminal %d to pty %s\n", term, new_pty);
+	pr_info("Assigned terminal %d to pty %s", term, new_pty);
+
+	if (!inotify_fd)
+		inotify_fd = inotify_init();
+	inotify_add_watch(inotify_fd, new_pty, IN_OPEN);
 
 	term_fds[term][TERM_FD_IN] = term_fds[term][TERM_FD_OUT] = master;
 }
@@ -194,6 +232,10 @@ static int term_init(struct kvm *kvm)
 	term.c_lflag &= ~(ICANON | ECHO | ISIG);
 	tcsetattr(STDIN_FILENO, TCSANOW, &term);
 
+	if (!inotify_fd)
+		inotify_fd = inotify_init();
+	if (inotify_fd < 0)
+		die("Unable to initialise inotify\n");
 
 	/* Use our own blocking thread to read stdin, don't require a tick */
 	if(pthread_create(&term_poll_thread, NULL, term_poll_thread_loop,kvm))
-- 
2.17.1

