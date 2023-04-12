Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2FB76DEAE1
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 07:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbjDLFOT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 01:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDLFOR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 01:14:17 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68FB61BD9
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 22:14:15 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1a652700c36so92555ad.0
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 22:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681276455; x=1683868455;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/EHKnc9bkAkiSZQscMfllEWVOu0svCFLlXoed3Jbc5I=;
        b=MUpdUBHIyYkZKEC2wLsztPIxWvgaCjCYi4KUm0hRqW3G6QdZnHu9vxDZ5rC7gRuCtE
         984JnshQ7RLMq4xISrahByP4oKEBhRZx59pk2KOD/lCVLY9cWqo2QSOZ7cusVW2UsT9E
         2xUG8uye6MRuT3rwZoGIgyL9KBaslC1MSIAS/x+O2ligidYobmWasVqDmykKzTm4WKmh
         ZBq7dNMReiuY5L+IJjhuOzbKeXVD4HhKmlMFiS3gb3cajzzyFAXGukReFDYyB2F9s7Pn
         /HC9lsQ86vzuc/mLEYO8IRswaNXccYv+dZNc9I2AXYxbDXirP9ph0MIUcuMwQjkDauvF
         azjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681276455; x=1683868455;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/EHKnc9bkAkiSZQscMfllEWVOu0svCFLlXoed3Jbc5I=;
        b=zCOSkv3NOrYXpBu/X/8Da1ogM1LyXHlEmoGxQOCbtfWCQLCJo/kqhcvJjtvctHPKfm
         NfE88IvMBLwGbdbucEOEbjCBUbxMqQQ6p88qnKAFUS8d4J3ZD/mpvDyOc2ssPAE9t97g
         pzLAtvcbf69bl1XOoUHSWpYrzAYRPtoZxkybrFCeD8jl0s1ztVshpf5fWXnaikUkKXXs
         mFA3L5YRH+5/pIYXFCVNsATFYqgYIDa1PdBu8qlsjvlLSuHvLVjo9EtXbkFxx9D0cLvs
         UzMk59Drwj/24GlTvMuL+7m3pZZN1ghSSnA2yJNfMhhzfJuw7mTMRV6NooBUvIasqtE8
         xGsw==
X-Gm-Message-State: AAQBX9eDMH8oa8PRIS3aPYUM7q5QKtBdyJWimA620A0fYDMuI5N8M8bF
        uGTJYID2Byvr48h0u3G8Tn4Ihw==
X-Google-Smtp-Source: AKy350btnbFhxfyQrF5h829VIoeiqZNniw5B7SyT6ffETVvFkjkNoWqA9b703VB2xav3VABt5DlHSA==
X-Received: by 2002:a17:902:9793:b0:1a1:854b:99d3 with SMTP id q19-20020a170902979300b001a1854b99d3mr434904plp.19.1681276454667;
        Tue, 11 Apr 2023 22:14:14 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id i13-20020aa787cd000000b00636c4bd7c8bsm5385764pfo.43.2023.04.11.22.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 22:14:14 -0700 (PDT)
Date:   Tue, 11 Apr 2023 22:14:10 -0700
From:   Reiji Watanabe <reijiw@google.com>
To:     Mark Rutland <mark.rutland@arm.com>
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
Message-ID: <20230412051410.emaip77vyak624pu@google.com>
References: <20230408034759.2369068-1-reijiw@google.com>
 <20230408034759.2369068-3-reijiw@google.com>
 <ZDUpfnXi/GwFwFV9@FVFF77S0Q05N>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDUpfnXi/GwFwFV9@FVFF77S0Q05N>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 11, 2023 at 10:33:50AM +0100, Mark Rutland wrote:
> On Fri, Apr 07, 2023 at 08:47:59PM -0700, Reiji Watanabe wrote:
> > Currently, with VHE, KVM sets ER, CR, SW and EN bits of
> > PMUSERENR_EL0 to 1 on vcpu_load(), and saves and restores
> > the register value for the host on vcpu_load() and vcpu_put().
> > If the value of those bits are cleared on a pCPU with a vCPU
> > loaded (armv8pmu_start() would do that when PMU counters are
> > programmed for the guest), PMU access from the guest EL0 might
> > be trapped to the guest EL1 directly regardless of the current
> > PMUSERENR_EL0 value of the vCPU.
> > 
> > Fix this by not letting armv8pmu_start() overwrite PMUSERENR on
> > the pCPU on which a vCPU is loaded, and instead updating the
> > saved shadow register value for the host, so that the value can
> > be restored on vcpu_put() later.
> 
> I'm happy with the hook in the PMU code, but I think there's still a race
> between an IPI and vcpu_{load,put}() where we can lose an update to
> PMUSERERNR_EL0. I tried to point that out in my final question in:
> 
>   https://lore.kernel.org/all/ZCwzV7ACl21VbLru@FVFF77S0Q05N.cambridge.arm.com/
> 
> ... but I looks like that wasn't all that clear.
> 
> Consider vcpu_load():
> 
> void vcpu_load(struct kvm_vcpu *vcpu)
> {
> 	int cpu = get_cpu();
> 
> 	__this_cpu_write(kvm_running_vcpu, vcpu);
> 	preempt_notifier_register(&vcpu->preempt_notifier);
> 	kvm_arch_vcpu_load(vcpu, cpu);
> 	put_cpu();
> }
> 
> AFAICT that's called with IRQs enabled, and the {get,put}_cpu() calls will only
> disable migration/preemption. After the write to kvm_running_vcpu, the code in
> kvm_set_pmuserenr() will see that there is a running vcpu, and write to the
> host context without updating the real PMUSERENR_EL0 register.
> 
> If we take an IPI and call kvm_set_pmuserenr() after the write to
> kvm_running_vcpu but before kvm_running_vcpu() completes, the call to
> kvm_set_pmuserenr() could update the host context (without updating the real
> PMUSERENR_EL0 value) before __activate_traps_common() saves the host value
> with:
> 
> 	 ctxt_sys_reg(hctxt, PMUSERENR_EL0) = read_sysreg(pmuserenr_el0);
> 
> ... which would discard the write made by kvm_set_pmuserenr().
> 
> Similar can happen in vcpu_put() where an IPI after __deactivate_traps_common()
> but before kvm_running_vcpu is cleared would result in kvm_set_pmuserenr()
> writing to the host context, but this value would never be written into HW.
> 
> Unless I'm missing something (e.g. if interrupts are actually masked during
> those windows), I don't think this is a complete fix as-is.
> 
> I'm not sure if there is a smart fix for that.

Thank you for the comment.

Uh, right, interrupts are not masked during those windows...

What I am currently considering on this would be disabling
IRQs while manipulating the register, and introducing a new flag
to indicate whether the PMUSERENR for the guest EL0 is loaded,
and having kvm_set_pmuserenr() check the new flag.

The code would be something like below (local_irq_save/local_irq_restore
needs to be excluded for NVHE though).

What do you think ?

--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -668,6 +668,8 @@ struct kvm_vcpu_arch {
 /* Software step state is Active-pending */
 #define DBG_SS_ACTIVE_PENDING	__vcpu_single_flag(sflags, BIT(5))
 
+/* PMUSERENR for the guest EL0 is on physical CPU */
+#define PMUSERENR_ON_CPU	__vcpu_single_flag(sflags, BIT(6))
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
 #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 6718731729fd..57e4f480874a 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -82,12 +82,19 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 	 */
 	if (kvm_arm_support_pmu_v3()) {
 		struct kvm_cpu_context *hctxt;
+		unsigned long flags;
 
 		write_sysreg(0, pmselr_el0);
 
 		hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+
+		local_irq_save(flags);
+
 		ctxt_sys_reg(hctxt, PMUSERENR_EL0) = read_sysreg(pmuserenr_el0);
 		write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
+		vcpu_set_flag(vcpu, PMUSERENR_ON_CPU);
+
+		local_irq_restore(flags);
 	}
 
 	vcpu->arch.mdcr_el2_host = read_sysreg(mdcr_el2);
@@ -112,9 +119,16 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
 	write_sysreg(0, hstr_el2);
 	if (kvm_arm_support_pmu_v3()) {
 		struct kvm_cpu_context *hctxt;
+		unsigned long flags;
 
 		hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+
+		local_irq_save(flags);
+
 		write_sysreg(ctxt_sys_reg(hctxt, PMUSERENR_EL0), pmuserenr_el0);
+		vcpu_clear_flag(vcpu, PMUSERENR_ON_CPU);
+
+		local_irq_restore(flags);
 	}
 
 	if (cpus_have_final_cap(ARM64_SME)) {
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 40bb2cb13317..33cd8e1ecbd6 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -221,8 +221,13 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu)
 bool kvm_set_pmuserenr(u64 val)
 {
 	struct kvm_cpu_context *hctxt;
+	struct kvm_vcpu *vcpu;
 
-	if (!kvm_arm_support_pmu_v3() || !has_vhe() || !kvm_get_running_vcpu())
+	if (!kvm_arm_support_pmu_v3() || !has_vhe())
+		return false;
+
+	vcpu = kvm_get_running_vcpu();
+	if (!vcpu || !vcpu_get_flag(vcpu, PMUSERENR_ON_CPU))
 		return false;
 
 	hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
-- 

Thank you,
Reiji


> 
> Thanks,
> Mark.
> 
> > Suggested-by: Mark Rutland <mark.rutland@arm.com>
> > Suggested-by: Marc Zyngier <maz@kernel.org>
> > Fixes: 83a7a4d643d3 ("arm64: perf: Enable PMU counter userspace access for perf event")
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  5 +++++
> >  arch/arm64/kernel/perf_event.c    | 21 ++++++++++++++++++---
> >  arch/arm64/kvm/pmu.c              | 20 ++++++++++++++++++++
> >  3 files changed, 43 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index bcd774d74f34..22db2f885c17 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -1028,9 +1028,14 @@ void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu);
> >  #ifdef CONFIG_KVM
> >  void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr);
> >  void kvm_clr_pmu_events(u32 clr);
> > +bool kvm_set_pmuserenr(u64 val);
> >  #else
> >  static inline void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr) {}
> >  static inline void kvm_clr_pmu_events(u32 clr) {}
> > +static inline bool kvm_set_pmuserenr(u64 val)
> > +{
> > +	return false;
> > +}
> >  #endif
> >  
> >  void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu);
> > diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
> > index dde06c0f97f3..0fffe4c56c28 100644
> > --- a/arch/arm64/kernel/perf_event.c
> > +++ b/arch/arm64/kernel/perf_event.c
> > @@ -741,9 +741,25 @@ static inline u32 armv8pmu_getreset_flags(void)
> >  	return value;
> >  }
> >  
> > +static void update_pmuserenr(u64 val)
> > +{
> > +	lockdep_assert_irqs_disabled();
> > +
> > +	/*
> > +	 * The current pmuserenr value might be the value for the guest.
> > +	 * If that's the case, have KVM keep tracking of the register value
> > +	 * for the host EL0 so that KVM can restore it before returning to
> > +	 * the host EL0. Otherwise, update the register now.
> > +	 */
> > +	if (kvm_set_pmuserenr(val))
> > +		return;
> > +
> > +	write_sysreg(val, pmuserenr_el0);
> > +}
> > +
> >  static void armv8pmu_disable_user_access(void)
> >  {
> > -	write_sysreg(0, pmuserenr_el0);
> > +	update_pmuserenr(0);
> >  }
> >  
> >  static void armv8pmu_enable_user_access(struct arm_pmu *cpu_pmu)
> > @@ -759,8 +775,7 @@ static void armv8pmu_enable_user_access(struct arm_pmu *cpu_pmu)
> >  			armv8pmu_write_evcntr(i, 0);
> >  	}
> >  
> > -	write_sysreg(0, pmuserenr_el0);
> > -	write_sysreg(ARMV8_PMU_USERENR_ER | ARMV8_PMU_USERENR_CR, pmuserenr_el0);
> > +	update_pmuserenr(ARMV8_PMU_USERENR_ER | ARMV8_PMU_USERENR_CR);
> >  }
> >  
> >  static void armv8pmu_enable_event(struct perf_event *event)
> > diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
> > index 7887133d15f0..40bb2cb13317 100644
> > --- a/arch/arm64/kvm/pmu.c
> > +++ b/arch/arm64/kvm/pmu.c
> > @@ -209,3 +209,23 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu)
> >  	kvm_vcpu_pmu_enable_el0(events_host);
> >  	kvm_vcpu_pmu_disable_el0(events_guest);
> >  }
> > +
> > +/*
> > + * With VHE, keep track of the PMUSERENR_EL0 value for the host EL0 on
> > + * the pCPU where vCPU is loaded, since PMUSERENR_EL0 is switched to
> > + * the value for the guest on vcpu_load().  The value for the host EL0
> > + * will be restored on vcpu_put(), before returning to the EL0.
> > + *
> > + * Return true if KVM takes care of the register. Otherwise return false.
> > + */
> > +bool kvm_set_pmuserenr(u64 val)
> > +{
> > +	struct kvm_cpu_context *hctxt;
> > +
> > +	if (!kvm_arm_support_pmu_v3() || !has_vhe() || !kvm_get_running_vcpu())
> > +		return false;
> > +
> > +	hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
> > +	ctxt_sys_reg(hctxt, PMUSERENR_EL0) = val;
> > +	return true;
> > +}
> > -- 
> > 2.40.0.577.gac1e443424-goog
> > 
> > 
