Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4FA3397E9
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 23:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731366AbfFGVjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 17:39:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37856 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731339AbfFGVjJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 17:39:09 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C9EEEF74CF;
        Fri,  7 Jun 2019 21:39:08 +0000 (UTC)
Received: from amt.cnet (ovpn-112-16.gru2.redhat.com [10.97.112.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AFFD85D9D6;
        Fri,  7 Jun 2019 21:39:05 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 8E95B105157;
        Fri,  7 Jun 2019 17:20:56 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x57KKqZ4021562;
        Fri, 7 Jun 2019 17:20:52 -0300
Date:   Fri, 7 Jun 2019 17:20:47 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     kvm-devel <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <kernellwp@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Raslan KarimAllah <karahmed@amazon.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [patch 1/3] drivers/cpuidle: add cpuidle-haltpoll driver
Message-ID: <20190607202044.GA5542@amt.cnet>
References: <20190603225242.289109849@amt.cnet>
 <20190603225254.212931277@amt.cnet>
 <20190606175103.GD28785@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606175103.GD28785@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Fri, 07 Jun 2019 21:39:08 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andrea,

On Thu, Jun 06, 2019 at 01:51:03PM -0400, Andrea Arcangeli wrote:
> Hello,
> 
> On Mon, Jun 03, 2019 at 07:52:43PM -0300, Marcelo Tosatti wrote:
> > +unsigned int guest_halt_poll_ns = 200000;
> > +module_param(guest_halt_poll_ns, uint, 0644);
> > +
> > +/* division factor to shrink halt_poll_ns */
> > +unsigned int guest_halt_poll_shrink = 2;
> > +module_param(guest_halt_poll_shrink, uint, 0644);
> > +
> > +/* multiplication factor to grow per-cpu halt_poll_ns */
> > +unsigned int guest_halt_poll_grow = 2;
> > +module_param(guest_halt_poll_grow, uint, 0644);
> > +
> > +/* value in ns to start growing per-cpu halt_poll_ns */
> > +unsigned int guest_halt_poll_grow_start = 10000;
> > +module_param(guest_halt_poll_grow_start, uint, 0644);
> > +
> > +/* value in ns to start growing per-cpu halt_poll_ns */
> > +bool guest_halt_poll_allow_shrink = true;
> > +module_param(guest_halt_poll_allow_shrink, bool, 0644);
> 
> These variables can all be static. They also should be __read_mostly
> to be sure not to unnecessarily hit false sharing while going idle.

Fixed.

> 
> > +		while (!need_resched()) {
> > +			cpu_relax();
> > +			now = ktime_get();
> > +
> > +			if (!ktime_before(now, end_spin)) {
> > +				do_halt = 1;
> > +				break;
> > +			}
> > +		}
> 
> On skylake pause takes ~75 cycles with ple_gap=0 (and Marcelo found it
> takes 6 cycles with pause loop exiting enabled but that shall be fixed
> in the CPU and we can ignore it).

Right, that is a generic problem.

> So we could call ktime_get() only once every 100 times or more and
> we'd be still accurate down to at least 1usec.
> 
> Ideally we'd like a ktime_try_get() that will break the seqcount loop
> if read_seqcount_retry fails. Something like below pseudocode:
> 
> #define KTIME_ERR ((ktime_t) { .tv64 = 0 })
> 
> ktime_t ktime_try_get(void)
> {
> 	[..]
> 	seq = read_seqcount_begin(&timekeeper_seq);
> 	secs = tk->xtime_sec + tk->wall_to_monotonic.tv_sec;
> 	nsecs = timekeeping_get_ns(&tk->tkr_mono) +
> 		tk->wall_to_monotonic.tv_nsec;
> 	if (unlikely(read_seqcount_retry(&timekeeper_seq, seq)))
> 		return KTIME_ERR;
> 	[..]
> }
> 
> If it ktime_try_get() fails we keep calling it at every iteration of
> the loop, when finally it succeeds we call it again only after 100
> pause instructions or more. So we continue polling need_resched()
> while we wait timerkeeper_seq to be released (and hopefully by looping
> 100 times or more we'll reduce the frequency when we find
> timekeeper_seq locked).
> 
> All we care is to react to need_resched ASAP and to have a resolution
> of the order of 1usec for the spin time.
> 
> If 100 is too wired a new module parameter in __read_mostly section
> configured to 100 or more by default, sounds preferable than hitting
> every 75nsec on the timekeeper_seq seqcount cacheline.

I'll switch to the cheaper sched_clock as suggested by Peter. 

Thanks!

> 
> I doubt it'd make any measurable difference with a few vcpus, but with
> hundred of host CPUs and vcpus perhaps it's worth it.
> 
> This of course can be done later once the patch is merged and if it's
> confirmed the above makes sense in practice and not just in theory. I
> wouldn't want to delay the merging for a possible micro optimization.
> 
> Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
> 
> Thanks,
> Andrea
