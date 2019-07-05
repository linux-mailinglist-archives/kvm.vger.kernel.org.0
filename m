Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94840603B1
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 11:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbfGEJ72 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 05:59:28 -0400
Received: from foss.arm.com ([217.140.110.172]:34696 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727990AbfGEJ7W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 05:59:22 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C2C751509;
        Fri,  5 Jul 2019 02:59:21 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 021053F246;
        Fri,  5 Jul 2019 02:59:20 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry@arm.com>
Cc:     kvm@vger.kernel.org, Dave Martin <dave.martin@arm.com>
Subject: [PATCH kvmtool 2/2] Add detach feature
Date:   Fri,  5 Jul 2019 10:59:14 +0100
Message-Id: <20190705095914.151056-3-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190705095914.151056-1-andre.przywara@arm.com>
References: <20190705095914.151056-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At the moment a kvmtool process started on a terminal has no way of
detaching from the terminal without killing the guest. Existing
workarounds are starting kvmtool in a screen/tmux session or using a
pseudoterminal (--tty 0), both of which have to be done upon guest
creation.

Introduce a terminal command to create a pseudoterminal during the
guest's runtime and redirect the console output to that. This will be
triggered by typing the letter 'd' after the kvmtool escape sequence
(default Ctrl+a). This also daemonises kvmtool, so gives back the shell
prompt, and the user can log out without affecting the guest.

Naively daemonising kvmtool at that point doesn't work, though, as the
fork() doesn't inherit the threads, so they keep running in the
grandparent process and would be killed by its exit.
The trick used here is to do the double fork() already right at the
beginning of kvmtool's runtime, before spawning the first thread.
We then don't end the parent and grandparent processes yet, instead let
them block until the user actually requests the detach.
This will let all the threads be created in the grandchild process, but
keeps kvmtool still attached to the terminal until the user requests a
detach.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 builtin-run.c     |  3 ++
 include/kvm/kvm.h |  2 ++
 term.c            | 91 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 96 insertions(+)

diff --git a/builtin-run.c b/builtin-run.c
index f8dc6c72..fa391419 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -592,6 +592,9 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
 		}
 	}
 
+	/* Fork twice already now to create the threads in the right process. */
+	kvm__prepare_daemonize();
+
 	if (!kvm->cfg.guest_name) {
 		if (kvm->cfg.custom_rootfs) {
 			kvm->cfg.guest_name = kvm->cfg.custom_rootfs_name;
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 7a738183..801f9474 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -90,6 +90,8 @@ struct kvm {
 void kvm__set_dir(const char *fmt, ...);
 const char *kvm__get_dir(void);
 
+int kvm__prepare_daemonize(void);
+
 int kvm__init(struct kvm *kvm);
 struct kvm *kvm__new(void);
 int kvm__recommended_cpus(struct kvm *kvm);
diff --git a/term.c b/term.c
index 7fbd98c6..df8328f8 100644
--- a/term.c
+++ b/term.c
@@ -22,6 +22,7 @@ static struct termios	orig_term;
 
 static int term_fds[TERM_MAX_DEVS][2];
 
+static int daemon_fd;
 static int inotify_fd;
 
 static pthread_t term_poll_thread;
@@ -29,6 +30,92 @@ static pthread_t term_poll_thread;
 /* ctrl-a is used for escape */
 #define term_escape_char	0x01
 
+/* This needs to be called *before* we create any threads. */
+int kvm__prepare_daemonize(void)
+{
+	pid_t pid;
+	char dummy;
+	int child_pipe[2], parent_pipe[2];
+
+	if (pipe(parent_pipe))
+		return -1;
+
+	pid = fork();
+	if (pid < 0)
+		return pid;
+	if (pid > 0) {			/* parent process */
+
+		close(parent_pipe[1]);
+
+		/* Block until we are told to exit. */
+		if (read(parent_pipe[0], &dummy, 1) != 1)
+			perror("reading exit pipe");
+
+		exit(0);
+	}
+
+	close(parent_pipe[0]);
+	if (pipe(child_pipe))
+		return -1;
+	daemon_fd = child_pipe[1];
+
+	/* Become a session leader. */
+	setsid();
+	pid = fork();
+	if (pid > 0) {
+		close(child_pipe[1]);
+
+		/* Block until we are told to exit. */
+		if (read(child_pipe[0], &dummy, 1) != 1)
+			perror("reading child exit pipe");
+
+		if (write(parent_pipe[1], &dummy, 1) != 1)
+			pr_warning("could not kill daemon's parent");
+
+		exit(0);
+	}
+	close(child_pipe[0]);
+	close(parent_pipe[1]);
+
+	/* Only the grandchild returns here, to do the actual work. */
+	return 0;
+}
+
+static void term_set_tty(int term);
+
+static void detach_terminal(int term)
+{
+	char dummy = 0;
+
+	/* Detaching only make sense if we use the process' terminal. */
+	if (term_fds[term][TERM_FD_IN] != STDIN_FILENO)
+		return;
+
+	/* Clean up just this terminal, leave the others alone. */
+	tcsetattr(term_fds[term][TERM_FD_IN], TCSANOW, &orig_term);
+
+	/* Redirect this terminal to a PTY */
+	term_set_tty(term);
+
+	/*
+	 * Replace STDIN/STDOUT with this new PTY. This will automatically
+	 * transfer all the other serial terminals over.
+	 */
+	dup2(term_fds[term][TERM_FD_IN], STDIN_FILENO);
+	dup2(term_fds[term][TERM_FD_OUT], STDOUT_FILENO);
+
+	/* Tell the (waiting) child process to exit now. */
+	if (write(daemon_fd, &dummy, 1) != 1)
+		pr_warning("could not kill daemon's parent");
+
+	/* To not hog the current directory unnecessarily. */
+	if (chdir("/"))
+		perror("changing to root directory");
+	umask(0);
+
+	close(STDERR_FILENO);
+}
+
 int term_getc(struct kvm *kvm, int term)
 {
 	static bool term_got_escape = false;
@@ -41,6 +128,10 @@ int term_getc(struct kvm *kvm, int term)
 		term_got_escape = false;
 		if (c == 'x')
 			kvm__reboot(kvm);
+		if (c == 'd') {
+			detach_terminal(term);
+			return -1;
+		}
 		if (c == term_escape_char)
 			return c;
 	}
-- 
2.17.1

