Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFAE37B6C
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 19:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730311AbfFFRvJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 13:51:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47346 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729035AbfFFRvJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 13:51:09 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 559D7307D963;
        Thu,  6 Jun 2019 17:51:08 +0000 (UTC)
Received: from ultra.random (ovpn-120-155.rdu2.redhat.com [10.10.120.155])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B9674108419E;
        Thu,  6 Jun 2019 17:51:05 +0000 (UTC)
Date:   Thu, 6 Jun 2019 13:51:03 -0400
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm-devel <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?iso-8859-1?B?S3LEP23DocU/?= <rkrcmar@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <kernellwp@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Raslan KarimAllah <karahmed@amazon.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [patch 1/3] drivers/cpuidle: add cpuidle-haltpoll driver
Message-ID: <20190606175103.GD28785@redhat.com>
References: <20190603225242.289109849@amt.cnet>
 <20190603225254.212931277@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603225254.212931277@amt.cnet>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 06 Jun 2019 17:51:08 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On Mon, Jun 03, 2019 at 07:52:43PM -0300, Marcelo Tosatti wrote:
> +unsigned int guest_halt_poll_ns = 200000;
> +module_param(guest_halt_poll_ns, uint, 0644);
> +
> +/* division factor to shrink halt_poll_ns */
> +unsigned int guest_halt_poll_shrink = 2;
> +module_param(guest_halt_poll_shrink, uint, 0644);
> +
> +/* multiplication factor to grow per-cpu halt_poll_ns */
> +unsigned int guest_halt_poll_grow = 2;
> +module_param(guest_halt_poll_grow, uint, 0644);
> +
> +/* value in ns to start growing per-cpu halt_poll_ns */
> +unsigned int guest_halt_poll_grow_start = 10000;
> +module_param(guest_halt_poll_grow_start, uint, 0644);
> +
> +/* value in ns to start growing per-cpu halt_poll_ns */
> +bool guest_halt_poll_allow_shrink = true;
> +module_param(guest_halt_poll_allow_shrink, bool, 0644);

These variables can all be static. They also should be __read_mostly
to be sure not to unnecessarily hit false sharing while going idle.

> +		while (!need_resched()) {
> +			cpu_relax();
> +			now = ktime_get();
> +
> +			if (!ktime_before(now, end_spin)) {
> +				do_halt = 1;
> +				break;
> +			}
> +		}

On skylake pause takes ~75 cycles with ple_gap=0 (and Marcelo found it
takes 6 cycles with pause loop exiting enabled but that shall be fixed
in the CPU and we can ignore it).

So we could call ktime_get() only once every 100 times or more and
we'd be still accurate down to at least 1usec.

Ideally we'd like a ktime_try_get() that will break the seqcount loop
if read_seqcount_retry fails. Something like below pseudocode:

#define KTIME_ERR ((ktime_t) { .tv64 = 0 })

ktime_t ktime_try_get(void)
{
	[..]
	seq = read_seqcount_begin(&timekeeper_seq);
	secs = tk->xtime_sec + tk->wall_to_monotonic.tv_sec;
	nsecs = timekeeping_get_ns(&tk->tkr_mono) +
		tk->wall_to_monotonic.tv_nsec;
	if (unlikely(read_seqcount_retry(&timekeeper_seq, seq)))
		return KTIME_ERR;
	[..]
}

If it ktime_try_get() fails we keep calling it at every iteration of
the loop, when finally it succeeds we call it again only after 100
pause instructions or more. So we continue polling need_resched()
while we wait timerkeeper_seq to be released (and hopefully by looping
100 times or more we'll reduce the frequency when we find
timekeeper_seq locked).

All we care is to react to need_resched ASAP and to have a resolution
of the order of 1usec for the spin time.

If 100 is too wired a new module parameter in __read_mostly section
configured to 100 or more by default, sounds preferable than hitting
every 75nsec on the timekeeper_seq seqcount cacheline.

I doubt it'd make any measurable difference with a few vcpus, but with
hundred of host CPUs and vcpus perhaps it's worth it.

This of course can be done later once the patch is merged and if it's
confirmed the above makes sense in practice and not just in theory. I
wouldn't want to delay the merging for a possible micro optimization.

Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>

Thanks,
Andrea
