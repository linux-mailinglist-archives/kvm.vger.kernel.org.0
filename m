Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12457D3EA7
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2019 13:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbfJKLll (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Oct 2019 07:41:41 -0400
Received: from foss.arm.com ([217.140.110.172]:57646 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727243AbfJKLll (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Oct 2019 07:41:41 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 20A2228;
        Fri, 11 Oct 2019 04:41:41 -0700 (PDT)
Received: from localhost (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8B1D03F703;
        Fri, 11 Oct 2019 04:41:40 -0700 (PDT)
Date:   Fri, 11 Oct 2019 12:41:38 +0100
From:   Andrew Murray <andrew.murray@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v2 5/5] KVM: arm64: pmu: Reset sample period on overflow
 handling
Message-ID: <20191011114138.GP42880@e119886-lin.cambridge.arm.com>
References: <20191008160128.8872-1-maz@kernel.org>
 <20191008160128.8872-6-maz@kernel.org>
 <20191008224221.GK42880@e119886-lin.cambridge.arm.com>
 <20191011122848.748da6f6@why>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011122848.748da6f6@why>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 11, 2019 at 12:28:48PM +0100, Marc Zyngier wrote:
> On Tue, 8 Oct 2019 23:42:22 +0100
> Andrew Murray <andrew.murray@arm.com> wrote:
> 
> > On Tue, Oct 08, 2019 at 05:01:28PM +0100, Marc Zyngier wrote:
> > > The PMU emulation code uses the perf event sample period to trigger
> > > the overflow detection. This works fine  for the *first* overflow
> > > handling, but results in a huge number of interrupts on the host,
> > > unrelated to the number of interrupts handled in the guest (a x20
> > > factor is pretty common for the cycle counter). On a slow system
> > > (such as a SW model), this can result in the guest only making
> > > forward progress at a glacial pace.
> > > 
> > > It turns out that the clue is in the name. The sample period is
> > > exactly that: a period. And once the an overflow has occured,
> > > the following period should be the full width of the associated
> > > counter, instead of whatever the guest had initially programed.
> > > 
> > > Reset the sample period to the architected value in the overflow
> > > handler, which now results in a number of host interrupts that is
> > > much closer to the number of interrupts in the guest.
> > > 
> > > Fixes: b02386eb7dac ("arm64: KVM: Add PMU overflow interrupt routing")
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  virt/kvm/arm/pmu.c | 15 +++++++++++++++
> > >  1 file changed, 15 insertions(+)
> > > 
> > > diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> > > index 25a483a04beb..8b524d74c68a 100644
> > > --- a/virt/kvm/arm/pmu.c
> > > +++ b/virt/kvm/arm/pmu.c
> > > @@ -442,6 +442,20 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
> > >  	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
> > >  	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
> > >  	int idx = pmc->idx;
> > > +	u64 period;
> > > +
> > > +	/*
> > > +	 * Reset the sample period to the architectural limit,
> > > +	 * i.e. the point where the counter overflows.
> > > +	 */
> > > +	period = -(local64_read(&pmc->perf_event->count));
> > > +
> > > +	if (!kvm_pmu_idx_is_64bit(vcpu, pmc->idx))
> > > +		period &= GENMASK(31, 0);
> > > +
> > > +	local64_set(&pmc->perf_event->hw.period_left, 0);
> > > +	pmc->perf_event->attr.sample_period = period;
> > > +	pmc->perf_event->hw.sample_period = period;  
> > 
> > I believe that above, you are reducing the period by the amount period_left
> > would have been - they cancel each other out.
> 
> That's not what I see happening, having put some traces:
> 
>  kvm_pmu_perf_overflow: count = 308 left = 129
>  kvm_pmu_perf_overflow: count = 409 left = 47
>  kvm_pmu_perf_overflow: count = 585 left = 223
>  kvm_pmu_perf_overflow: count = 775 left = 413
>  kvm_pmu_perf_overflow: count = 1368 left = 986
>  kvm_pmu_perf_overflow: count = 2086 left = 1716
>  kvm_pmu_perf_overflow: count = 958 left = 584
>  kvm_pmu_perf_overflow: count = 1907 left = 1551
>  kvm_pmu_perf_overflow: count = 7292 left = 6932

Indeed.

> 
> although I've now moved the stop/start calls inside the overflow
> handler so that I don't have to mess with the PMU backend.
> 
> > Given that kvm_pmu_perf_overflow is now always called between a
> > cpu_pmu->pmu.stop and a cpu_pmu->pmu.start, it means armpmu_event_update
> > has been called prior to this function, and armpmu_event_set_period will
> > be called after...
> > 
> > Therefore, I think the above could be reduced to:
> > 
> > +	/*
> > +	 * Reset the sample period to the architectural limit,
> > +	 * i.e. the point where the counter overflows.
> > +	 */
> > +	u64 period = GENMASK(63, 0);
> > +	if (!kvm_pmu_idx_is_64bit(vcpu, pmc->idx))
> > +		period = GENMASK(31, 0);
> > +
> > +	pmc->perf_event->attr.sample_period = period;
> > +	pmc->perf_event->hw.sample_period = period;
> > 
> > This is because armpmu_event_set_period takes into account the overflow
> > and the counter wrapping via the "if (unlikely(left <= 0)) {" block.
> 
> I think that's an oversimplification. As shown above, the counter has
> moved forward, and there is a delta to be accounted for.
> 

Yeah, I probably need to spend more time understanding this...

> > Though this code confuses me easily, so I may be talking rubbish.
> 
> Same here! ;-)
> 
> > 
> > >  
> > >  	__vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(idx);
> > >  
> > > @@ -557,6 +571,7 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
> > >  	attr.exclude_host = 1; /* Don't count host events */
> > >  	attr.config = (pmc->idx == ARMV8_PMU_CYCLE_IDX) ?
> > >  		ARMV8_PMUV3_PERFCTR_CPU_CYCLES : eventsel;
> > > +	attr.config1 = PERF_ATTR_CFG1_RELOAD_EVENT;  
> > 
> > I'm not sure that this flag, or patch 4 is really needed. As the perf
> > events created by KVM are pinned to the task and exclude_(host,hv) are set -
> > I think the perf event is not active at this point. Therefore if you change
> > the sample period, you can wait until the perf event gets scheduled back in
> > (when you return to the guest) where it's call to pmu.start will result in
> > armpmu_event_set_period being called. In other words the pmu.start and
> > pmu.stop you add in patch 4 is effectively being done for you by perf when
> > the KVM task is switched out.
> > 
> > I'd be interested to see if the following works:
> > 
> > +	WARN_ON(pmc->perf_event->state == PERF_EVENT_STATE_ACTIVE)
> > +
> > +	/*
> > +	 * Reset the sample period to the architectural limit,
> > +	 * i.e. the point where the counter overflows.
> > +	 */
> > +	u64 period = GENMASK(63, 0);
> > +	if (!kvm_pmu_idx_is_64bit(vcpu, pmc->idx))
> > +		period = GENMASK(31, 0);
> > +
> > +	pmc->perf_event->attr.sample_period = period;
> > +	pmc->perf_event->hw.sample_period = period;
> > 
> > >  
> > >  	counter = kvm_pmu_get_pair_counter_value(vcpu, pmc);
> > >    
> 
> The warning fires, which is expected: for event to be inactive, you
> need to have the vcpu being scheduled out. When the PMU interrupt
> fires, it is bound to preempt the vcpu itself, and the event is of
> course still active.

That makes sense. That also provides a justification for stopping and
starting the PMU.

> 
> > What about ARM 32 bit support for this?
> 
> What about it? 32bit KVM/arm doesn't support the PMU at all.

Thanks for the clarification.

Andrew Murray

> A 32bit
> guest on a 64bit host could use the PMU just fine (it is just that
> 32bit Linux doesn't have a PMUv3 driver -- I had patches for that, but
> they never made it upstream).
> 
> Thanks,
> 
> 	M.
> -- 
> Jazz is not dead. It just smells funny...
