Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFFF96DF028
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 11:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjDLJUT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 05:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjDLJUP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 05:20:15 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 80D517AB5
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 02:20:11 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ADC85C14;
        Wed, 12 Apr 2023 02:20:55 -0700 (PDT)
Received: from FVFF77S0Q05N (unknown [10.57.21.3])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 433803F587;
        Wed, 12 Apr 2023 02:20:08 -0700 (PDT)
Date:   Wed, 12 Apr 2023 10:20:05 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2 2/2] KVM: arm64: PMU: Don't overwrite PMUSERENR with
 vcpu loaded
Message-ID: <ZDZ3xbSePtOD3CSX@FVFF77S0Q05N>
References: <20230408034759.2369068-1-reijiw@google.com>
 <20230408034759.2369068-3-reijiw@google.com>
 <ZDUpfnXi/GwFwFV9@FVFF77S0Q05N>
 <20230412051410.emaip77vyak624pu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412051410.emaip77vyak624pu@google.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 11, 2023 at 10:14:10PM -0700, Reiji Watanabe wrote:
> Uh, right, interrupts are not masked during those windows...
> 
> What I am currently considering on this would be disabling
> IRQs while manipulating the register, and introducing a new flag
> to indicate whether the PMUSERENR for the guest EL0 is loaded,
> and having kvm_set_pmuserenr() check the new flag.
> 
> The code would be something like below (local_irq_save/local_irq_restore
> needs to be excluded for NVHE though).
> 
> What do you think ?

I'm happy with that; it doesn't change the arm_pmu side of the interface and it
looks good from a functional perspective.

I'll have to leave it to Marc and Oliver to say whether they're happy with the
KVM side.

Thanks,
Mark.

> 
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -668,6 +668,8 @@ struct kvm_vcpu_arch {
>  /* Software step state is Active-pending */
>  #define DBG_SS_ACTIVE_PENDING	__vcpu_single_flag(sflags, BIT(5))
>  
> +/* PMUSERENR for the guest EL0 is on physical CPU */
> +#define PMUSERENR_ON_CPU	__vcpu_single_flag(sflags, BIT(6))
>  
>  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
>  #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 6718731729fd..57e4f480874a 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -82,12 +82,19 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
>  	 */
>  	if (kvm_arm_support_pmu_v3()) {
>  		struct kvm_cpu_context *hctxt;
> +		unsigned long flags;
>  
>  		write_sysreg(0, pmselr_el0);
>  
>  		hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
> +
> +		local_irq_save(flags);
> +
>  		ctxt_sys_reg(hctxt, PMUSERENR_EL0) = read_sysreg(pmuserenr_el0);
>  		write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
> +		vcpu_set_flag(vcpu, PMUSERENR_ON_CPU);
> +
> +		local_irq_restore(flags);
>  	}
>  
>  	vcpu->arch.mdcr_el2_host = read_sysreg(mdcr_el2);
> @@ -112,9 +119,16 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
>  	write_sysreg(0, hstr_el2);
>  	if (kvm_arm_support_pmu_v3()) {
>  		struct kvm_cpu_context *hctxt;
> +		unsigned long flags;
>  
>  		hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
> +
> +		local_irq_save(flags);
> +
>  		write_sysreg(ctxt_sys_reg(hctxt, PMUSERENR_EL0), pmuserenr_el0);
> +		vcpu_clear_flag(vcpu, PMUSERENR_ON_CPU);
> +
> +		local_irq_restore(flags);
>  	}
>  
>  	if (cpus_have_final_cap(ARM64_SME)) {
> diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
> index 40bb2cb13317..33cd8e1ecbd6 100644
> --- a/arch/arm64/kvm/pmu.c
> +++ b/arch/arm64/kvm/pmu.c
> @@ -221,8 +221,13 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu)
>  bool kvm_set_pmuserenr(u64 val)
>  {
>  	struct kvm_cpu_context *hctxt;
> +	struct kvm_vcpu *vcpu;
>  
> -	if (!kvm_arm_support_pmu_v3() || !has_vhe() || !kvm_get_running_vcpu())
> +	if (!kvm_arm_support_pmu_v3() || !has_vhe())
> +		return false;
> +
> +	vcpu = kvm_get_running_vcpu();
> +	if (!vcpu || !vcpu_get_flag(vcpu, PMUSERENR_ON_CPU))
>  		return false;
>  
>  	hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
> -- 
> 
> Thank you,
> Reiji
> 
> 
> > 
> > Thanks,
> > Mark.
> > 
> > > Suggested-by: Mark Rutland <mark.rutland@arm.com>
> > > Suggested-by: Marc Zyngier <maz@kernel.org>
> > > Fixes: 83a7a4d643d3 ("arm64: perf: Enable PMU counter userspace access for perf event")
> > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > > ---
> > >  arch/arm64/include/asm/kvm_host.h |  5 +++++
> > >  arch/arm64/kernel/perf_event.c    | 21 ++++++++++++++++++---
> > >  arch/arm64/kvm/pmu.c              | 20 ++++++++++++++++++++
> > >  3 files changed, 43 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > index bcd774d74f34..22db2f885c17 100644
> > > --- a/arch/arm64/include/asm/kvm_host.h
> > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > @@ -1028,9 +1028,14 @@ void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu);
> > >  #ifdef CONFIG_KVM
> > >  void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr);
> > >  void kvm_clr_pmu_events(u32 clr);
> > > +bool kvm_set_pmuserenr(u64 val);
> > >  #else
> > >  static inline void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr) {}
> > >  static inline void kvm_clr_pmu_events(u32 clr) {}
> > > +static inline bool kvm_set_pmuserenr(u64 val)
> > > +{
> > > +	return false;
> > > +}
> > >  #endif
> > >  
> > >  void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu);
> > > diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
> > > index dde06c0f97f3..0fffe4c56c28 100644
> > > --- a/arch/arm64/kernel/perf_event.c
> > > +++ b/arch/arm64/kernel/perf_event.c
> > > @@ -741,9 +741,25 @@ static inline u32 armv8pmu_getreset_flags(void)
> > >  	return value;
> > >  }
> > >  
> > > +static void update_pmuserenr(u64 val)
> > > +{
> > > +	lockdep_assert_irqs_disabled();
> > > +
> > > +	/*
> > > +	 * The current pmuserenr value might be the value for the guest.
> > > +	 * If that's the case, have KVM keep tracking of the register value
> > > +	 * for the host EL0 so that KVM can restore it before returning to
> > > +	 * the host EL0. Otherwise, update the register now.
> > > +	 */
> > > +	if (kvm_set_pmuserenr(val))
> > > +		return;
> > > +
> > > +	write_sysreg(val, pmuserenr_el0);
> > > +}
> > > +
> > >  static void armv8pmu_disable_user_access(void)
> > >  {
> > > -	write_sysreg(0, pmuserenr_el0);
> > > +	update_pmuserenr(0);
> > >  }
> > >  
> > >  static void armv8pmu_enable_user_access(struct arm_pmu *cpu_pmu)
> > > @@ -759,8 +775,7 @@ static void armv8pmu_enable_user_access(struct arm_pmu *cpu_pmu)
> > >  			armv8pmu_write_evcntr(i, 0);
> > >  	}
> > >  
> > > -	write_sysreg(0, pmuserenr_el0);
> > > -	write_sysreg(ARMV8_PMU_USERENR_ER | ARMV8_PMU_USERENR_CR, pmuserenr_el0);
> > > +	update_pmuserenr(ARMV8_PMU_USERENR_ER | ARMV8_PMU_USERENR_CR);
> > >  }
> > >  
> > >  static void armv8pmu_enable_event(struct perf_event *event)
> > > diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
> > > index 7887133d15f0..40bb2cb13317 100644
> > > --- a/arch/arm64/kvm/pmu.c
> > > +++ b/arch/arm64/kvm/pmu.c
> > > @@ -209,3 +209,23 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu)
> > >  	kvm_vcpu_pmu_enable_el0(events_host);
> > >  	kvm_vcpu_pmu_disable_el0(events_guest);
> > >  }
> > > +
> > > +/*
> > > + * With VHE, keep track of the PMUSERENR_EL0 value for the host EL0 on
> > > + * the pCPU where vCPU is loaded, since PMUSERENR_EL0 is switched to
> > > + * the value for the guest on vcpu_load().  The value for the host EL0
> > > + * will be restored on vcpu_put(), before returning to the EL0.
> > > + *
> > > + * Return true if KVM takes care of the register. Otherwise return false.
> > > + */
> > > +bool kvm_set_pmuserenr(u64 val)
> > > +{
> > > +	struct kvm_cpu_context *hctxt;
> > > +
> > > +	if (!kvm_arm_support_pmu_v3() || !has_vhe() || !kvm_get_running_vcpu())
> > > +		return false;
> > > +
> > > +	hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
> > > +	ctxt_sys_reg(hctxt, PMUSERENR_EL0) = val;
> > > +	return true;
> > > +}
> > > -- 
> > > 2.40.0.577.gac1e443424-goog
> > > 
> > > 
> 
