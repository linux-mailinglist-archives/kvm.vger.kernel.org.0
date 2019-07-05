Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC24960502
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 13:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbfGELEo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 07:04:44 -0400
Received: from foss.arm.com ([217.140.110.172]:36134 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726116AbfGELEo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 07:04:44 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C01A72B;
        Fri,  5 Jul 2019 04:04:43 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 18DA23F703;
        Fri,  5 Jul 2019 04:04:42 -0700 (PDT)
Date:   Fri, 5 Jul 2019 12:04:41 +0100
From:   Dave Martin <Dave.Martin@arm.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Will Deacon <will@kernel.org>,
        Julien Thierry <Julien.Thierry@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH kvmtool 2/2] Add detach feature
Message-ID: <20190705110438.GC2790@e103592.cambridge.arm.com>
References: <20190705095914.151056-1-andre.przywara@arm.com>
 <20190705095914.151056-3-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190705095914.151056-3-andre.przywara@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 05, 2019 at 10:59:14AM +0100, Andre Przywara wrote:
> At the moment a kvmtool process started on a terminal has no way of
> detaching from the terminal without killing the guest. Existing
> workarounds are starting kvmtool in a screen/tmux session or using a
> pseudoterminal (--tty 0), both of which have to be done upon guest
> creation.
> 
> Introduce a terminal command to create a pseudoterminal during the
> guest's runtime and redirect the console output to that. This will be
> triggered by typing the letter 'd' after the kvmtool escape sequence
> (default Ctrl+a). This also daemonises kvmtool, so gives back the shell
> prompt, and the user can log out without affecting the guest.
> 
> Naively daemonising kvmtool at that point doesn't work, though, as the
> fork() doesn't inherit the threads, so they keep running in the
> grandparent process and would be killed by its exit.
> The trick used here is to do the double fork() already right at the
> beginning of kvmtool's runtime, before spawning the first thread.
> We then don't end the parent and grandparent processes yet, instead let
> them block until the user actually requests the detach.
> This will let all the threads be created in the grandchild process, but
> keeps kvmtool still attached to the terminal until the user requests a
> detach.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  builtin-run.c     |  3 ++
>  include/kvm/kvm.h |  2 ++
>  term.c            | 91 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 96 insertions(+)
> 
> diff --git a/builtin-run.c b/builtin-run.c
> index f8dc6c72..fa391419 100644
> --- a/builtin-run.c
> +++ b/builtin-run.c
> @@ -592,6 +592,9 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
>  		}
>  	}
>  
> +	/* Fork twice already now to create the threads in the right process. */
> +	kvm__prepare_daemonize();
> +
>  	if (!kvm->cfg.guest_name) {
>  		if (kvm->cfg.custom_rootfs) {
>  			kvm->cfg.guest_name = kvm->cfg.custom_rootfs_name;
> diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
> index 7a738183..801f9474 100644
> --- a/include/kvm/kvm.h
> +++ b/include/kvm/kvm.h
> @@ -90,6 +90,8 @@ struct kvm {
>  void kvm__set_dir(const char *fmt, ...);
>  const char *kvm__get_dir(void);
>  
> +int kvm__prepare_daemonize(void);
> +
>  int kvm__init(struct kvm *kvm);
>  struct kvm *kvm__new(void);
>  int kvm__recommended_cpus(struct kvm *kvm);
> diff --git a/term.c b/term.c
> index 7fbd98c6..df8328f8 100644
> --- a/term.c
> +++ b/term.c
> @@ -22,6 +22,7 @@ static struct termios	orig_term;
>  
>  static int term_fds[TERM_MAX_DEVS][2];
>  
> +static int daemon_fd;
>  static int inotify_fd;
>  
>  static pthread_t term_poll_thread;
> @@ -29,6 +30,92 @@ static pthread_t term_poll_thread;
>  /* ctrl-a is used for escape */
>  #define term_escape_char	0x01
>  
> +/* This needs to be called *before* we create any threads. */
> +int kvm__prepare_daemonize(void)
> +{
> +	pid_t pid;
> +	char dummy;
> +	int child_pipe[2], parent_pipe[2];
> +
> +	if (pipe(parent_pipe))
> +		return -1;
> +
> +	pid = fork();
> +	if (pid < 0)
> +		return pid;
> +	if (pid > 0) {			/* parent process */
> +
> +		close(parent_pipe[1]);
> +
> +		/* Block until we are told to exit. */
> +		if (read(parent_pipe[0], &dummy, 1) != 1)
> +			perror("reading exit pipe");
> +
> +		exit(0);

Can we have the child write some status value instead?

Right now, if the child goes wrong after forking we will just exit with
status 0 regardless.

Instead, we could have the child send us the exit status... or if
the child disappears we'll just get EOF and can return failure
appropriately.

Also, how does the invoker kill the guest now that kvmtool has exited?

> +	}
> +
> +	close(parent_pipe[0]);
> +	if (pipe(child_pipe))
> +		return -1;
> +	daemon_fd = child_pipe[1];
> +
> +	/* Become a session leader. */
> +	setsid();
> +	pid = fork();
> +	if (pid > 0) {
> +		close(child_pipe[1]);
> +
> +		/* Block until we are told to exit. */
> +		if (read(child_pipe[0], &dummy, 1) != 1)
> +			perror("reading child exit pipe");
> +
> +		if (write(parent_pipe[1], &dummy, 1) != 1)
> +			pr_warning("could not kill daemon's parent");
> +
> +		exit(0);
> +	}
> +	close(child_pipe[0]);
> +	close(parent_pipe[1]);

Why do we need to fork twice?  The extra process seems redundant.

> +
> +	/* Only the grandchild returns here, to do the actual work. */
> +	return 0;
> +}
> +
> +static void term_set_tty(int term);
> +
> +static void detach_terminal(int term)
> +{
> +	char dummy = 0;
> +
> +	/* Detaching only make sense if we use the process' terminal. */
> +	if (term_fds[term][TERM_FD_IN] != STDIN_FILENO)
> +		return;
> +
> +	/* Clean up just this terminal, leave the others alone. */
> +	tcsetattr(term_fds[term][TERM_FD_IN], TCSANOW, &orig_term);
> +
> +	/* Redirect this terminal to a PTY */
> +	term_set_tty(term);
> +
> +	/*
> +	 * Replace STDIN/STDOUT with this new PTY. This will automatically
> +	 * transfer all the other serial terminals over.
> +	 */
> +	dup2(term_fds[term][TERM_FD_IN], STDIN_FILENO);
> +	dup2(term_fds[term][TERM_FD_OUT], STDOUT_FILENO);

Output to a pty master before the slave is opened just disappears.
Possibly it would be useful to buffer it somewhere.

I wonder whether it would make sense to redirect to a notional dummy
terminal (which might or might not buffer output), and start talking to
a pty or socket only once opened by a client.

> +
> +	/* Tell the (waiting) child process to exit now. */
> +	if (write(daemon_fd, &dummy, 1) != 1)
> +		pr_warning("could not kill daemon's parent");
> +
> +	/* To not hog the current directory unnecessarily. */
> +	if (chdir("/"))
> +		perror("changing to root directory");
> +	umask(0);
> +
> +	close(STDERR_FILENO);
> +}
> +

[...]

Cheers
---Dave
