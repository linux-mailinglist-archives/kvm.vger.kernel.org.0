Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8BAACBE82
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 17:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389557AbfJDPGO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 11:06:14 -0400
Received: from foss.arm.com ([217.140.110.172]:47756 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388802AbfJDPGO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 11:06:14 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7A15D1597;
        Fri,  4 Oct 2019 08:06:13 -0700 (PDT)
Received: from localhost (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F09A63F68E;
        Fri,  4 Oct 2019 08:06:12 -0700 (PDT)
Date:   Fri, 4 Oct 2019 16:06:11 +0100
From:   Andrew Murray <andrew.murray@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH] KVM: arm64: pmu: Fix cycle counter truncation on counter
 stop
Message-ID: <20191004150611.GU42880@e119886-lin.cambridge.arm.com>
References: <20191003172400.21157-1-maz@kernel.org>
 <20191004085554.GQ42880@e119886-lin.cambridge.arm.com>
 <20191004110829.63f397de@why>
 <20191004141005.GT42880@e119886-lin.cambridge.arm.com>
 <86ftk8efm6.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ftk8efm6.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 04, 2019 at 03:42:57PM +0100, Marc Zyngier wrote:
> On Fri, 04 Oct 2019 15:10:06 +0100,
> Andrew Murray <andrew.murray@arm.com> wrote:
> > 
> > On Fri, Oct 04, 2019 at 11:08:29AM +0100, Marc Zyngier wrote:
> > > On Fri, 4 Oct 2019 09:55:55 +0100
> > > Andrew Murray <andrew.murray@arm.com> wrote:
> > > 
> > > > On Thu, Oct 03, 2019 at 06:24:00PM +0100, Marc Zyngier wrote:
> > > > > When a counter is disabled, its value is sampled before the event
> > > > > is being disabled, and the value written back in the shadow register.
> > > > > 
> > > > > In that process, the value gets truncated to 32bit, which is adequate  
> > > > 
> > > > Doh, that shouldn't have happened.
> > > > 
> > > > > for any counter but the cycle counter, which can be configured to
> > > > > hold a 64bit value. This obviously results in a corrupted counter,
> > > > > and things like "perf record -e cycles" not working at all when
> > > > > run in a guest...
> > > > > 
> > > > > Make the truncation conditional on the counter not being 64bit.
> > > > > 
> > > > > Fixes: 80f393a23be6 ("KVM: arm/arm64: Support chained PMU counters")
> > > > > Cc: Andrew Murray <andrew.murray@arm.com>
> > > > > Reported-by: Julien Thierry Julien Thierry <julien.thierry.kdev@gmail.com>
> > > > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > > > ---
> > > > >  virt/kvm/arm/pmu.c | 4 +++-
> > > > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> > > > > index 362a01886bab..d716aef2bae9 100644
> > > > > --- a/virt/kvm/arm/pmu.c
> > > > > +++ b/virt/kvm/arm/pmu.c
> > > > > @@ -206,9 +206,11 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
> > > > >  		__vcpu_sys_reg(vcpu, reg) = lower_32_bits(counter);
> > > > >  		__vcpu_sys_reg(vcpu, reg + 1) = upper_32_bits(counter);
> > > > >  	} else {
> > > > > +		if (!kvm_pmu_idx_is_64bit(vcpu, pmc->idx))
> > > > > +			counter = lower_32_bits(counter);
> > > > >  		reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
> > > > >  		       ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
> > > > > -		__vcpu_sys_reg(vcpu, reg) = lower_32_bits(counter);
> > > > > +		__vcpu_sys_reg(vcpu, reg) = counter;  
> > > > 
> > > > The other uses of lower_32_bits look OK to me.
> > > > 
> > > > Reviewed-by: Andrew Murray <andrew.murray@arm.com>
> > > > 
> > > > As a side note, I'm not convinced that the implementation (or perhaps the
> > > > use of) kvm_pmu_idx_is_64bit is correct:
> > > > 
> > > > static bool kvm_pmu_idx_is_64bit(struct kvm_vcpu *vcpu, u64 select_idx)
> > > > {
> > > >         return (select_idx == ARMV8_PMU_CYCLE_IDX &&
> > > >                 __vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_LC);
> > > > }
> > > > 
> > > > We shouldn't truncate the value of a cycle counter to 32 bits just because
> > > > _PMCR_LC is unset. We should only be interested in _PMCR_LC when setting
> > > > the sample_period.
> > > 
> > > That's a good point. The ARMv8 ARM says:
> > > 
> > > "Long cycle counter enable. Determines when unsigned overflow is
> > > recorded by the cycle counter overflow bit."
> > > 
> > > which doesn't say anything about the counter being truncated one way or
> > > another.
> > > 
> > > > If you agree this is wrong, I'll spin a change.
> > > 
> > > I still think kvm_pmu_idx_is_64bit() correct, and would be easily
> > > extended to supporting the ARMv8.5-PMU extension. However, it'd be
> > > better to just detect the cycle counter in the current patch rather
> > > than relying on the above helper:
> > 
> > I guess at present kvm_pmu_idx_is_64bit has the meaning "does the counter
> > have a 64 bit overflow". (And we check for the CYCLE_IDX because at
> > present thats the only thing that *can* have a 64bit overflow.)
> 
> Exactly. The function is badly named, but hey, we'll live with it
> until we refactor this further.
> 
> > > diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> > > index d716aef2bae9..90a90d8f7280 100644
> > > --- a/virt/kvm/arm/pmu.c
> > > +++ b/virt/kvm/arm/pmu.c
> > > @@ -206,7 +206,7 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
> > >  		__vcpu_sys_reg(vcpu, reg) = lower_32_bits(counter);
> > >  		__vcpu_sys_reg(vcpu, reg + 1) = upper_32_bits(counter);
> > >  	} else {
> > > -		if (!kvm_pmu_idx_is_64bit(vcpu, pmc->idx))
> > > +		if (pmc->idx != ARMV8_PMU_CYCLE_IDX)
> > >  			counter = lower_32_bits(counter);
> > >  		reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
> > >  		       ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
> > > 
> > 
> > That looks fine to me.
> 
> I've now revamped that code further, as having an if() and a
> conditional expression that check the same this is a bit... meh. The
> result is more invasive, but far more readable [1].

That looks OK to be (b9195ff).

Thanks,

Andrew Murray

> 
> > > As for revamping the rest of the code, that's 5.5 material.
> > 
> > The only other change required would be as follows:
> > 
> > diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> > index 362a01886bab..2435119b8524 100644
> > --- a/virt/kvm/arm/pmu.c
> > +++ b/virt/kvm/arm/pmu.c
> > @@ -147,7 +147,7 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
> >             kvm_pmu_idx_is_high_counter(select_idx))
> >                 counter = upper_32_bits(counter);
> >  
> > -       else if (!kvm_pmu_idx_is_64bit(vcpu, select_idx))
> > +       else if (select_idx != ARMV8_PMU_CYCLE_IDX)
> >                 counter = lower_32_bits(counter);
> >  
> >         return counter;
> 
> Yeah, I wondered about that one. I've folded that in the patch.
> 
> > > > Though unsetting _PMCR_LC is deprecated so I can't imagine this causes any
> > > > issue.
> > > 
> > > Deprecated, yes. Disallowed, no. We'll have to support this as long as
> > > we have 32bit capable stuff in the wild. But we could at least start
> > > with correctly emulating the setting of the LC bit, see below.
> > > 
> > > Thanks,
> > > 
> > > 	M.
> > > 
> > > From c421c17ae1e9c90db4b73bd25485580833321f4b Mon Sep 17 00:00:00 2001
> > > From: Marc Zyngier <maz@kernel.org>
> > > Date: Fri, 4 Oct 2019 11:03:09 +0100
> > > Subject: [PATCH] arm64: KVM: Handle PMCR_EL0.LC as RES1 on pure AArch64
> > >  systems
> > > 
> > > Of PMCR_EL0.LC, the ARMv8 ARM says:
> > > 
> > > 	"In an AArch64 only implementation, this field is RES 1."
> > > 
> > > So be it.
> > > 
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kvm/sys_regs.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > > 
> > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > index 2071260a275b..46822afc57e0 100644
> > > --- a/arch/arm64/kvm/sys_regs.c
> > > +++ b/arch/arm64/kvm/sys_regs.c
> > > @@ -632,6 +632,8 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> > >  	 */
> > >  	val = ((pmcr & ~ARMV8_PMU_PMCR_MASK)
> > >  	       | (ARMV8_PMU_PMCR_MASK & 0xdecafbad)) & (~ARMV8_PMU_PMCR_E);
> > > +	if (!system_supports_32bit_el0())
> > > +		val |= ARMV8_PMU_PMCR_LC;
> > >  	__vcpu_sys_reg(vcpu, r->reg) = val;
> > >  }
> > >  
> > > @@ -682,6 +684,8 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> > >  		val = __vcpu_sys_reg(vcpu, PMCR_EL0);
> > >  		val &= ~ARMV8_PMU_PMCR_MASK;
> > >  		val |= p->regval & ARMV8_PMU_PMCR_MASK;
> > > +		if (!system_supports_32bit_el0())
> > > +			val |= ARMV8_PMU_PMCR_LC;
> > >  		__vcpu_sys_reg(vcpu, PMCR_EL0) = val;
> > >  		kvm_pmu_handle_pmcr(vcpu, val);
> > >  		kvm_vcpu_pmu_restore_guest(vcpu);
> > 
> > This looks good to me.
> > 
> > Reviewed-by: Andrew Murray <andrew.murray@arm.com>
> 
> Thanks,
> 
> 	M.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/commit/?h=next&id=b9195ff4accaa46ad5ed95435a3a69fdb7506ceb
> 
> -- 
> Jazz is not dead, it just smells funny.
