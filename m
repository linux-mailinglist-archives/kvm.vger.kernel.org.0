Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F11161F5F
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2019 15:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729686AbfGHNNs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jul 2019 09:13:48 -0400
Received: from foss.arm.com ([217.140.110.172]:47728 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726284AbfGHNNr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jul 2019 09:13:47 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 098A02B;
        Mon,  8 Jul 2019 06:13:47 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 55EE63F738;
        Mon,  8 Jul 2019 06:13:46 -0700 (PDT)
Date:   Mon, 8 Jul 2019 14:13:44 +0100
From:   Dave Martin <Dave.Martin@arm.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Will Deacon <will@kernel.org>,
        Julien Thierry <Julien.Thierry@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH kvmtool 1/2] term: Avoid busy loop with unconnected
 pseudoterminals
Message-ID: <20190708131343.GE2790@e103592.cambridge.arm.com>
References: <20190705095914.151056-1-andre.przywara@arm.com>
 <20190705095914.151056-2-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190705095914.151056-2-andre.przywara@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 05, 2019 at 10:59:13AM +0100, Andre Przywara wrote:
> Currently when kvmtool is creating a pseudoterminal (--tty x), the
> terminal thread will consume 100% of its CPU time as long as no slave
> is connected to the other end. This is due to the fact that poll()
> unconditonally sets the POLLHUP bit in revents and returns immediately,
> regardless of the events we are querying for.
> 
> There does not seem to be a solution to this with just poll() alone.
> Using the TIOCPKT ioctl sounds promising, but doesn't help either,
> as poll still detects the HUP condition.

Are you sure?  I couldn't observe this unless I also passed POLLOUT in
events.  poll(2) describes POLLHUP as only applying to writes.

The behaviour of select() though seems to be that once the slave has
been closed for the first time, reading the master fd screams EIO until
the slave is opened again, so you have to fall back to periodically
polling until the EIO goes away.

I'm guessing poll() doesn't provide a reliable way to work around this
either, hence this patch.

> So apart from chickening out with some poll() timeout tricks, inotify
> seems to be the way to go:
> Each time poll() returns with the POLLHUP bit set, we disable this
> file descriptor in the poll() array and rely on the inotify IN_OPEN
> watch to fire on the slave end of the pseudoterminal. We then enable the
> file descriptor again.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  term.c | 48 +++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 45 insertions(+), 3 deletions(-)
> 
> diff --git a/term.c b/term.c
> index b8a70fe2..7fbd98c6 100644
> --- a/term.c
> +++ b/term.c
> @@ -7,6 +7,7 @@
>  #include <signal.h>
>  #include <pty.h>
>  #include <utmp.h>
> +#include <sys/inotify.h>
>  
>  #include "kvm/read-write.h"
>  #include "kvm/term.h"
> @@ -21,6 +22,8 @@ static struct termios	orig_term;
>  
>  static int term_fds[TERM_MAX_DEVS][2];
>  
> +static int inotify_fd;
> +
>  static pthread_t term_poll_thread;
>  
>  /* ctrl-a is used for escape */
> @@ -100,7 +103,7 @@ bool term_readable(int term)
>  
>  static void *term_poll_thread_loop(void *param)
>  {
> -	struct pollfd fds[TERM_MAX_DEVS];
> +	struct pollfd fds[TERM_MAX_DEVS + 1];
>  	struct kvm *kvm = (struct kvm *) param;
>  	int i;
>  
> @@ -111,11 +114,42 @@ static void *term_poll_thread_loop(void *param)
>  		fds[i].events = POLLIN;
>  		fds[i].revents = 0;
>  	}
> +	fds[i].fd = inotify_fd;
> +	fds[i].events = POLLIN;
> +	fds[i].revents = 0;
>  
>  	while (1) {
> +		int i;
> +
>  		/* Poll with infinite timeout */
> -		if(poll(fds, TERM_MAX_DEVS, -1) < 1)
> +		if(poll(fds, TERM_MAX_DEVS + 1, -1) < 1)
>  			break;
> +
> +		for (i = 0; i < TERM_MAX_DEVS; i++) {
> +			/*
> +			 * Check for unconnected pseudoterminals. They will
> +			 * make poll() return immediately, so we have to
> +			 * disable those fds and rely on inotify to tell us
> +			 * when the slave side gets opened.
> +			 */
> +			if (fds[i].revents == POLLHUP)

Should this be & ?  Or is POLLHUP always delivered by itself?

> +				fds[i].fd = ~fds[i].fd;
> +		}
> +		if (fds[TERM_MAX_DEVS].revents) {	/* inotify fd */
> +			struct inotify_event event;
> +
> +			/*
> +			 * Just enable all fds that we previously disabled,
> +			 * still unconnected ones will be disabled again on
> +			 * the next poll() call.
> +			 */
> +			for (i = 0; i < TERM_MAX_DEVS; i++)
> +				if (fds[i].fd < 0)
> +					fds[i].fd = ~fds[i].fd;
> +			/* Consume at least one inotify event. */
> +			i = read(inotify_fd, &event, sizeof(event));

Are there raciness / event loss issues here?

If we just toggle the fds on each open, then opening the slave again
when it is already open will break things, no?  (This is peephole
review, so I may be missing some wider context.)

Also, I'm not sure (actually, I strongly doubt) that anything guarantees
that we see the EIO/POLLHUP for a hung-up slave before the inotify()
notify notification that reopens it.

Maybe I'm being too paranoid (as often the case).

We could try to maintain a counter if we also track IN_CLOSE, but
inotify queue overflows are still a potential problem.

Even if we get this working, we're relying on a bunch of undocumented
behaviour that could drift in future.


I'd like all this to work ... but given that ptys don't appear well
designed to solve this kind of problem, I wonder whether it's really
worth trying to support them?

Sockets OTOH are designed for this use case and support remote access at
no extra cost.

Do we need genuine terminal emulation for something?

[...]

Cheers
---Dave
