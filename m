Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F24C7937E3
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 11:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235960AbjIFJRu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 05:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236410AbjIFJRr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 05:17:47 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D72CE2
        for <kvm@vger.kernel.org>; Wed,  6 Sep 2023 02:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693991863; x=1725527863;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8N9n63Faforl26vhAR0bnPTWwSXjdT3F373uFhh2Dok=;
  b=g7Ih5qwdRxKGBgjcyAlhmtef0y5sJiT49Up9HFa5fMtFeF/PeqyewhDs
   nxdWt5b3CM3gPxLtFZ+8+Y/Jhb15BSDCIpZ7ta5wxpDvBDFF1TPdZ1vCG
   E7iZ9dnoC67TBOlkPvgWrrskUc/UpE8j7o7Q2B6DQGO3Irnll3F0GFTtC
   OkyxcBgaYmSeIklcvbwHeRmAzfQKo1NNcVWAIciZEP/BeyYInfGyykNf/
   6FgAbTcQSzSnFG5dKT7VbHgpi5l4fzoGNC1Cc5mdG55iiIbNdYPMzTEWw
   n8dSifxHBykO0NvjUPJ1iaiPcO1VGV/WQeE+/V+euTJEnt/RMIdLJbuI8
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10824"; a="375916982"
X-IronPort-AV: E=Sophos;i="6.02,231,1688454000"; 
   d="scan'208";a="375916982"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2023 02:17:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10824"; a="988161058"
X-IronPort-AV: E=Sophos;i="6.02,231,1688454000"; 
   d="scan'208";a="988161058"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.93.20.184]) ([10.93.20.184])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2023 02:17:40 -0700
Message-ID: <8b964afb-4b8e-b8fb-542c-c76487340705@linux.intel.com>
Date:   Wed, 6 Sep 2023 17:17:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH 1/2] KVM: x86: Synthesize at most one PMI per VM-exit
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Like Xu <likexu@tencent.com>, Mingwei Zhang <mizhang@google.com>,
        Roman Kagan <rkagan@amazon.de>,
        Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>
References: <20230901185646.2823254-1-jmattson@google.com>
From:   "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20230901185646.2823254-1-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/2/2023 2:56 AM, Jim Mattson wrote:
> When the irq_work callback, kvm_pmi_trigger_fn(), is invoked during a
> VM-exit that also invokes __kvm_perf_overflow() as a result of
> instruction emulation, kvm_pmu_deliver_pmi() will be called twice
> before the next VM-entry.


Do we have a way to reproduce this spurious NMI error constantly?


>
> That shouldn't be a problem. The local APIC is supposed to
> automatically set the mask flag in LVTPC when it handles a PMI, so the
> second PMI should be inhibited. However, KVM's local APIC emulation
> fails to set the mask flag in LVTPC when it handles a PMI, so two PMIs
> are delivered via the local APIC. In the common case, where LVTPC is
> configured to deliver an NMI, the first NMI is vectored through the
> guest IDT, and the second one is held pending. When the NMI handler
> returns, the second NMI is vectored through the IDT. For Linux guests,
> this results in the "dazed and confused" spurious NMI message.
>
> Though the obvious fix is to set the mask flag in LVTPC when handling
> a PMI, KVM's logic around synthesizing a PMI is unnecessarily
> convoluted.
>
> Remove the irq_work callback for synthesizing a PMI, and all of the
> logic for invoking it. Instead, to prevent a vcpu from leaving C0 with
> a PMI pending, add a check for KVM_REQ_PMI to kvm_vcpu_has_events().
>
> Fixes: 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring instructions")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  1 -
>   arch/x86/kvm/pmu.c              | 27 +--------------------------
>   arch/x86/kvm/x86.c              |  3 +++
>   3 files changed, 4 insertions(+), 27 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3bc146dfd38d..f6b9e3ae08bf 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -528,7 +528,6 @@ struct kvm_pmu {
>   	u64 raw_event_mask;
>   	struct kvm_pmc gp_counters[KVM_INTEL_PMC_MAX_GENERIC];
>   	struct kvm_pmc fixed_counters[KVM_PMC_MAX_FIXED];
> -	struct irq_work irq_work;
>   
>   	/*
>   	 * Overlay the bitmap with a 64-bit atomic so that all bits can be
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index bf653df86112..0c117cd24077 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -93,14 +93,6 @@ void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops)
>   #undef __KVM_X86_PMU_OP
>   }
>   
> -static void kvm_pmi_trigger_fn(struct irq_work *irq_work)
> -{
> -	struct kvm_pmu *pmu = container_of(irq_work, struct kvm_pmu, irq_work);
> -	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
> -
> -	kvm_pmu_deliver_pmi(vcpu);
> -}
> -
>   static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
>   {
>   	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> @@ -124,20 +116,7 @@ static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
>   		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
>   	}
>   
> -	if (!pmc->intr || skip_pmi)
> -		return;
> -
> -	/*
> -	 * Inject PMI. If vcpu was in a guest mode during NMI PMI
> -	 * can be ejected on a guest mode re-entry. Otherwise we can't
> -	 * be sure that vcpu wasn't executing hlt instruction at the
> -	 * time of vmexit and is not going to re-enter guest mode until
> -	 * woken up. So we should wake it, but this is impossible from
> -	 * NMI context. Do it from irq work instead.
> -	 */
> -	if (in_pmi && !kvm_handling_nmi_from_guest(pmc->vcpu))
> -		irq_work_queue(&pmc_to_pmu(pmc)->irq_work);
> -	else
> +	if (pmc->intr && !skip_pmi)
>   		kvm_make_request(KVM_REQ_PMI, pmc->vcpu);
>   }
>   
> @@ -677,9 +656,6 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
>   
>   void kvm_pmu_reset(struct kvm_vcpu *vcpu)
>   {
> -	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> -
> -	irq_work_sync(&pmu->irq_work);
>   	static_call(kvm_x86_pmu_reset)(vcpu);
>   }
>   
> @@ -689,7 +665,6 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
>   
>   	memset(pmu, 0, sizeof(*pmu));
>   	static_call(kvm_x86_pmu_init)(vcpu);
> -	init_irq_work(&pmu->irq_work, kvm_pmi_trigger_fn);
>   	pmu->event_count = 0;
>   	pmu->need_cleanup = false;
>   	kvm_pmu_refresh(vcpu);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c381770bcbf1..0732c09fbd2d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12841,6 +12841,9 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
>   		return true;
>   #endif
>   
> +	if (kvm_test_request(KVM_REQ_PMI, vcpu))
> +		return true;
> +
>   	if (kvm_arch_interrupt_allowed(vcpu) &&
>   	    (kvm_cpu_has_interrupt(vcpu) ||
>   	    kvm_guest_apic_has_interrupt(vcpu)))
