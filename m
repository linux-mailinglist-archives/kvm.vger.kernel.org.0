Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3CE8FDB9E
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 11:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbfKOKpF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 05:45:05 -0500
Received: from cloudserver094114.home.pl ([79.96.170.134]:42681 "EHLO
        cloudserver094114.home.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbfKOKpF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 05:45:05 -0500
Received: from 79.184.253.153.ipv4.supernova.orange.pl (79.184.253.153) (HELO kreacher.localnet)
 by serwer1319399.home.pl (79.96.170.134) with SMTP (IdeaSmtpServer 0.83.292)
 id fddc515768e678ae; Fri, 15 Nov 2019 11:45:02 +0100
From:   "Rafael J. Wysocki" <rjw@rjwysocki.net>
To:     Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        rkrcmar@redhat.com, rafael.j.wysocki@intel.com,
        joao.m.martins@oracle.com, mtosatti@redhat.com,
        kvm@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH RESEND v2 3/4] cpuidle-haltpoll: ensure cpu_halt_poll_us in right scope
Date:   Fri, 15 Nov 2019 11:45:01 +0100
Message-ID: <6161954.sKiXg2khOt@kreacher>
In-Reply-To: <1573041302-4904-4-git-send-email-zhenzhong.duan@oracle.com>
References: <1573041302-4904-1-git-send-email-zhenzhong.duan@oracle.com> <1573041302-4904-4-git-send-email-zhenzhong.duan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wednesday, November 6, 2019 12:55:01 PM CET Zhenzhong Duan wrote:
> As user can adjust guest_halt_poll_grow_start and guest_halt_poll_ns
> which leads to cpu_halt_poll_us beyond the two boundaries. This patch
> ensures cpu_halt_poll_us in that scope.
> 
> If guest_halt_poll_shrink is 0, shrink the cpu_halt_poll_us to
> guest_halt_poll_grow_start instead of 0. To disable poll we can set
> guest_halt_poll_ns to 0.
> 
> If user wrongly set guest_halt_poll_grow_start > guest_halt_poll_ns > 0,
> guest_halt_poll_ns take precedency and poll time is a fixed value of
> guest_halt_poll_ns.
> 
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> ---
>  drivers/cpuidle/governors/haltpoll.c | 28 +++++++++++++---------------
>  1 file changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/cpuidle/governors/haltpoll.c b/drivers/cpuidle/governors/haltpoll.c
> index 660859d..4a39df4 100644
> --- a/drivers/cpuidle/governors/haltpoll.c
> +++ b/drivers/cpuidle/governors/haltpoll.c
> @@ -97,32 +97,30 @@ static int haltpoll_select(struct cpuidle_driver *drv,
>  
>  static void adjust_poll_limit(struct cpuidle_device *dev, unsigned int block_us)
>  {
> -	unsigned int val;
> +	unsigned int val = dev->poll_limit_ns;

Not necessary to initialize it here.

>  	u64 block_ns = block_us*NSEC_PER_USEC;
>  
>  	/* Grow cpu_halt_poll_us if
> -	 * cpu_halt_poll_us < block_ns < guest_halt_poll_us
> +	 * cpu_halt_poll_us < block_ns <= guest_halt_poll_us

You could update the comment to say "dev->poll_limit_ns" instead of
"cpu_halt_poll_us" while at it.

>  	 */
> -	if (block_ns > dev->poll_limit_ns && block_ns <= guest_halt_poll_ns) {
> +	if (block_ns > dev->poll_limit_ns && block_ns <= guest_halt_poll_ns &&
> +	    guest_halt_poll_grow)

The "{" brace is still needed as per the coding style and I'm not sure why
to avoid guest_halt_poll_grow equal to zero here?

>  		val = dev->poll_limit_ns * guest_halt_poll_grow;
> -
> -		if (val < guest_halt_poll_grow_start)
> -			val = guest_halt_poll_grow_start;
> -		if (val > guest_halt_poll_ns)
> -			val = guest_halt_poll_ns;
> -
> -		dev->poll_limit_ns = val;
> -	} else if (block_ns > guest_halt_poll_ns &&
> -		   guest_halt_poll_allow_shrink) {
> +	else if (block_ns > guest_halt_poll_ns &&
> +		 guest_halt_poll_allow_shrink) {
>  		unsigned int shrink = guest_halt_poll_shrink;
>  
> -		val = dev->poll_limit_ns;
>  		if (shrink == 0)
> -			val = 0;
> +			val = guest_halt_poll_grow_start;

That's going to be corrected below, so the original code would be fine.

>  		else
>  			val /= shrink;

Here you can do

			val = dev->poll_limit_ns / shrink;

> -		dev->poll_limit_ns = val;
>  	}
> +	if (val < guest_halt_poll_grow_start)
> +		val = guest_halt_poll_grow_start;

Note that guest_halt_poll_grow_start is in us (as per the comment next to its
definition and the initial value).  That is a bug in the original code too,
but anyway.

> +	if (val > guest_halt_poll_ns)
> +		val = guest_halt_poll_ns;
> +
> +	dev->poll_limit_ns = val;
>  }
>  
>  /**
> 




