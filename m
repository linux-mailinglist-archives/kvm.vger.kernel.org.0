Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82CAC70FFF4
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 23:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233142AbjEXVXj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 17:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231890AbjEXVXh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 17:23:37 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55487E47
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 14:23:32 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1ae3f6df2bfso4757125ad.1
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 14:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684963412; x=1687555412;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JEC6s7mxrmJW/qJXvSUfSppcL9dTMu3PeI1H7wdJu4o=;
        b=kUFLMfq/EU/JxYWEoNpgfdV32zEogT/IVEPIdwmuuhVeDqn0/Rhquhj0wBlX8kzhbX
         M+xC6R2ifCPK9ID49FHEsHDGO1bn0OWib+2nblUbJxZGBF7ivplJc3A7GVRHYgEWswbX
         VawzPj/sgZEhlVV4e0x2Swe/cASalC/oxXH+zJp7u0UMeX/FiepejkRis/QNiKZ84HWT
         f32k59t++Bjnka1+8FjPhq4fzYRA8/Nir84Qyo6XI06NrAZ458D34s1DuL4JQ4pKcaal
         3Ylqv/u2nBlm/adLYBeTVtSafnmMGtFmN98B6aLdxOyOOa18W6vZH7hnzGGQWZo+kZJI
         zttw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684963412; x=1687555412;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JEC6s7mxrmJW/qJXvSUfSppcL9dTMu3PeI1H7wdJu4o=;
        b=EnRugRcvok5Z/EYiZQA/3HH444SSFq3c+opype1g08yS3fL0vJ+0naCfrHtFqcCiEW
         6cQ0aBGAYTpfLbrwxDtO+XSwmBeLC9IDm8rkAKoYhWJVJI3vYa06XLGyOnN2y1URMKNX
         15oVzMMUncUlZdD0SWZPi0mL3jgBi1JtPOnW168eKjhfj1N4CdwzDtauFn9xPiL1t9+K
         l9JGUFTytdw2pmmitFCbn5OTqfzulSHccqIbctsPJmE3sCxOMEdLTakG+rBFjvncaAz4
         vrtvAa3q28ZHbmFAL/hGgFfDeXoCIbNA4U5DExO8UzM5sLHtbg1h/lKiY1qjFB9DQx2x
         aXBQ==
X-Gm-Message-State: AC+VfDyAeQa8Qz9+/LDzNTtBTUp8oMIC3IwV0GJbRy557HDpOqNHxabE
        wx590FhbaMYMCv820EhJcPEVg14EEhM=
X-Google-Smtp-Source: ACHHUZ5TwSJv84NMm6TKmquWZFOBFb9xnIuIGMkoQC/5kxFbkxekPZjSnZuTvEsWUYK1+mmYKgMBcxtlOck=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e0c5:b0:1ae:739a:5242 with SMTP id
 e5-20020a170902e0c500b001ae739a5242mr4551730pla.0.1684963411811; Wed, 24 May
 2023 14:23:31 -0700 (PDT)
Date:   Wed, 24 May 2023 14:23:30 -0700
In-Reply-To: <20230310105346.12302-6-likexu@tencent.com>
Mime-Version: 1.0
References: <20230310105346.12302-1-likexu@tencent.com> <20230310105346.12302-6-likexu@tencent.com>
Message-ID: <ZG6AUjci2J9WpT2z@google.com>
Subject: Re: [PATCH 5/5] KVM: x86/pmu: Hide guest counter updates from the
 VMRUN instruction
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 10, 2023, Like Xu wrote:
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index adb92fc4d7c9..d6fcbf233cb3 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -561,6 +561,10 @@ struct kvm_pmu {
>  	 */
>  	u64 host_cross_mapped_mask;
>  
> +	/* Flags to track any HW quirks that need to be fixed by vPMU. */
> +	u64 quirk_flags;
> +	DECLARE_BITMAP(hide_vmrun_pmc_idx, X86_PMC_IDX_MAX);

Since it sounds like AMD isn't changing the behavior, let's forego the quirk and
just hardcode the fixup.

> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 2a0504732966..315dca021d57 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -254,6 +254,7 @@ static void pmc_pause_counter(struct kvm_pmc *pmc)
>  	counter += perf_event_pause(pmc->perf_event, true);
>  	pmc->counter = counter & pmc_bitmask(pmc);
>  	pmc->is_paused = true;
> +	kvm_mark_pmc_is_quirky(pmc);
>  }
>  
>  static bool pmc_resume_counter(struct kvm_pmc *pmc)
> @@ -822,6 +823,19 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
>  	return r;
>  }
>  
> +static inline bool event_is_branch_instruction(struct kvm_pmc *pmc)

How about pmc_is_counting_branches()?  The "event" itself isn't a branch
instruction.

> +{
> +	return eventsel_match_perf_hw_id(pmc, PERF_COUNT_HW_INSTRUCTIONS) ||
> +		eventsel_match_perf_hw_id(pmc,
> +					  PERF_COUNT_HW_BRANCH_INSTRUCTIONS);

Let this poke out.

> +}
> +
> +static inline bool quirky_pmc_will_count_vmrun(struct kvm_pmc *pmc)
> +{
> +	return event_is_branch_instruction(pmc) && event_is_allowed(pmc) &&
> +		!static_call(kvm_x86_get_cpl)(pmc->vcpu);
> +}
> +
>  void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> @@ -837,6 +851,10 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
>  
>  		reprogram_counter(pmc);
>  		kvm_pmu_handle_pmc_overflow(pmc);
> +
> +		if (vcpu_has_pmu_quirks(vcpu) &&
> +		    quirky_pmc_will_count_vmrun(pmc))
> +			set_bit(pmc->idx, pmu->hide_vmrun_pmc_idx);

Doesn't this need to adjust the count _before_ handling overflow?  I.e. isn't it
possible for the bogus counts to cause bogus overflow?

> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index a47b579667c6..30f6f58f4c38 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -18,6 +18,9 @@
>  #define VMWARE_BACKDOOR_PMC_REAL_TIME		0x10001
>  #define VMWARE_BACKDOOR_PMC_APPARENT_TIME	0x10002
>  
> +#define X86_PMU_COUNT_VMRUN	BIT_ULL(0)
> +#define X86_PMU_QUIRKS_MASK	X86_PMU_COUNT_VMRUN
> +
>  struct kvm_pmu_ops {
>  	bool (*hw_event_available)(struct kvm_pmc *pmc);
>  	bool (*pmc_is_enabled)(struct kvm_pmc *pmc);
> @@ -54,14 +57,33 @@ static inline void kvm_pmu_request_counter_reprogram(struct kvm_pmc *pmc)
>  	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
>  }
>  
> +static inline bool vcpu_has_pmu_quirks(struct kvm_vcpu *vcpu)
> +{
> +	return vcpu_to_pmu(vcpu)->quirk_flags & X86_PMU_QUIRKS_MASK;
> +}
> +
> +/*
> + * The time to mark pmc is when the accumulation value returned
> + * by perf API based on a HW counter has just taken effect.
> + */
> +static inline void kvm_mark_pmc_is_quirky(struct kvm_pmc *pmc)
> +{
> +	if (!vcpu_has_pmu_quirks(pmc->vcpu))
> +		return;
> +
> +	kvm_pmu_request_counter_reprogram(pmc);
> +}
> +
>  static inline u64 pmc_read_counter(struct kvm_pmc *pmc)
>  {
>  	u64 counter, enabled, running;
>  
>  	counter = pmc->counter;
> -	if (pmc->perf_event && !pmc->is_paused)
> +	if (pmc->perf_event && !pmc->is_paused) {
>  		counter += perf_event_read_value(pmc->perf_event,
>  						 &enabled, &running);
> +		kvm_mark_pmc_is_quirky(pmc);
> +	}
>  	/* FIXME: Scaling needed? */
>  	return counter & pmc_bitmask(pmc);
>  }
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index 5fa939e411d8..130991a97f22 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -187,6 +187,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
>  	pmu->nr_arch_fixed_counters = 0;
>  	pmu->global_status = 0;
>  	bitmap_set(pmu->all_valid_pmc_idx, 0, pmu->nr_arch_gp_counters);
> +	pmu->quirk_flags |= X86_PMU_COUNT_VMRUN;
>  }
>  
>  static void amd_pmu_init(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index f41d96e638ef..f6b33d172481 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3919,6 +3919,31 @@ static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
>  	return EXIT_FASTPATH_NONE;
>  }
>  
> +static void pmu_hide_vmrun(struct kvm_vcpu *vcpu)

This needs to be noinstr.

> +{
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +	struct kvm_pmc *pmc;
> +	unsigned int i;
> +
> +	for_each_set_bit(i, pmu->hide_vmrun_pmc_idx, X86_PMC_IDX_MAX) {
> +		clear_bit(i, pmu->hide_vmrun_pmc_idx);

Clearing the bit will hide only the first VMRUN after the guest attempts to read
the counter, no?  The fixup needs to apply to every VMRUN that is executed after
the PMC is programmed.  Or am I misreading the patch?

> +
> +		/* AMD doesn't have fixed counters at now. */
> +		if (i >= pmu->nr_arch_gp_counters)
> +			continue;
> +
> +		/*
> +		 * The prerequisite for fixing HW quirks is that there is indeed
> +		 * HW working and perf has no chance to retrieve the counter.

I don't follow the "perf has no chance to retrieve the counter" part.

> +		 */
> +		pmc = &pmu->gp_counters[i];
> +		if (!pmc->perf_event || pmc->perf_event->hw.idx < 0)
> +			continue;
> +
> +		pmc->counter--;
> +	}
> +}
> +
>  static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_intercepted)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -3986,6 +4011,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>  
>  	kvm_wait_lapic_expire(vcpu);
>  
> +	if (vcpu->kvm->arch.enable_pmu && vcpu_has_pmu_quirks(vcpu))
> +		pmu_hide_vmrun(vcpu);
> +
>  	/*
>  	 * If this vCPU has touched SPEC_CTRL, restore the guest's value if
>  	 * it's non-zero. Since vmentry is serialising on affected CPUs, there
> -- 
> 2.39.2
> 
