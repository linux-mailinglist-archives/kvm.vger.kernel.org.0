Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D525790949
	for <lists+kvm@lfdr.de>; Sat,  2 Sep 2023 21:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbjIBTFd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Sep 2023 15:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbjIBTFc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 Sep 2023 15:05:32 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A4F19E
        for <kvm@vger.kernel.org>; Sat,  2 Sep 2023 12:05:29 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-68a3082c771so84545b3a.0
        for <kvm@vger.kernel.org>; Sat, 02 Sep 2023 12:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693681529; x=1694286329; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fgHX9G8hIFePOGK4IWlT79IiiHuOLjZPapqA5MG5p2A=;
        b=t/xp9Za1gkqNtrkpzUCz3qg8gUm+TY4RLm65j4Zj5J00rnjDbg6CHSJCM2cu7caMy5
         5q4n3gRbVjZHkyUQOhBVETqMG8oztojFcNorB6G8eSSxsWlZZU2qNgL11oU3M90NsQBG
         CUH6b55lqZMIuPCekHu+3K/nnkDVfqZw461ZNgvFVsx1yHIdiSM2uHXoAdFmdK392kgL
         At5ZbCIDnVxxzI/3Sme0r4sxC1AxJ0OrPJ1VJQVrTMiJYn5nkqvlwA2d3KUIcuNZupH4
         ouitoaXH0UJPu/H6KUzLjD2yo+n6ZZ/sUkI5/DDS70IN7H/jGYuIAi1Upe77O3pLQoCH
         y5HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693681529; x=1694286329;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fgHX9G8hIFePOGK4IWlT79IiiHuOLjZPapqA5MG5p2A=;
        b=iryTE0rwZPtpggaSLsD6/jOE5KVr1MvAcXM7qD6IBjMOB7q/PzbnJIjjQACkBgtEX4
         ao1j8TvHGX6FT2Y6f/JhliZl1VHR9yMZe/c2jFhv548tm4hsCe4RrOmw0jwOPP7DuRqT
         /FWEKslIyvyM8OJSPet3iUPkY/I6VVhT+xsiydF/F1aQ6UpGU3q0I/vjwaJKhm7aDzCL
         p9MgYpycEV6TYbYwevLW5/1QM5ZtgNmbnCa1j8pvgquxo42YTCG3aLSrXIc6HnwOfbop
         XqGxbS5eO/aCM8Ur+hokEQbne79JpuTUQNZIZokEkaZt/xa+SI9ktGnrcMMR2rmSLZjw
         x3iA==
X-Gm-Message-State: AOJu0Yx/CHclzpCMybaKCCEUWIOE8nD7Kz+Be9vZFRSRuomakSQqTwv7
        0fx1IivUUFaV+T+FfZDqS5dwRA==
X-Google-Smtp-Source: AGHT+IE888TmDqU5vyhYTQT81h8kvdoG6anMljKybJyqboaEAXEMeesn9v9nCjsOjXMaQbiF+4/X0Q==
X-Received: by 2002:a05:6a00:b4a:b0:68a:5651:b53e with SMTP id p10-20020a056a000b4a00b0068a5651b53emr6900248pfo.10.1693681528568;
        Sat, 02 Sep 2023 12:05:28 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id e22-20020aa78256000000b0068c676f1df7sm4842488pfn.57.2023.09.02.12.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Sep 2023 12:05:27 -0700 (PDT)
Date:   Sat, 2 Sep 2023 19:05:23 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Like Xu <likexu@tencent.com>, Roman Kagan <rkagan@amazon.de>,
        Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>
Subject: Re: [PATCH 1/2] KVM: x86: Synthesize at most one PMI per VM-exit
Message-ID: <ZPOHc1o5rHGV3mK7@google.com>
References: <20230901185646.2823254-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230901185646.2823254-1-jmattson@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 01, 2023, Jim Mattson wrote:
> When the irq_work callback, kvm_pmi_trigger_fn(), is invoked during a
> VM-exit that also invokes __kvm_perf_overflow() as a result of
> instruction emulation, kvm_pmu_deliver_pmi() will be called twice
> before the next VM-entry.
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
Tested-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 -
>  arch/x86/kvm/pmu.c              | 27 +--------------------------
>  arch/x86/kvm/x86.c              |  3 +++
>  3 files changed, 4 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3bc146dfd38d..f6b9e3ae08bf 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -528,7 +528,6 @@ struct kvm_pmu {
>  	u64 raw_event_mask;
>  	struct kvm_pmc gp_counters[KVM_INTEL_PMC_MAX_GENERIC];
>  	struct kvm_pmc fixed_counters[KVM_PMC_MAX_FIXED];
> -	struct irq_work irq_work;
>  
>  	/*
>  	 * Overlay the bitmap with a 64-bit atomic so that all bits can be
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index bf653df86112..0c117cd24077 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -93,14 +93,6 @@ void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops)
>  #undef __KVM_X86_PMU_OP
>  }
>  
> -static void kvm_pmi_trigger_fn(struct irq_work *irq_work)
> -{
> -	struct kvm_pmu *pmu = container_of(irq_work, struct kvm_pmu, irq_work);
> -	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
> -
> -	kvm_pmu_deliver_pmi(vcpu);
> -}
> -
>  static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
>  {
>  	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> @@ -124,20 +116,7 @@ static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
>  		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
>  	}
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
>  		kvm_make_request(KVM_REQ_PMI, pmc->vcpu);
>  }
>  
> @@ -677,9 +656,6 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
>  
>  void kvm_pmu_reset(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> -
> -	irq_work_sync(&pmu->irq_work);
>  	static_call(kvm_x86_pmu_reset)(vcpu);
>  }
>  
> @@ -689,7 +665,6 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
>  
>  	memset(pmu, 0, sizeof(*pmu));
>  	static_call(kvm_x86_pmu_init)(vcpu);
> -	init_irq_work(&pmu->irq_work, kvm_pmi_trigger_fn);
>  	pmu->event_count = 0;
>  	pmu->need_cleanup = false;
>  	kvm_pmu_refresh(vcpu);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c381770bcbf1..0732c09fbd2d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12841,6 +12841,9 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
>  		return true;
>  #endif
>  
> +	if (kvm_test_request(KVM_REQ_PMI, vcpu))
> +		return true;
> +
>  	if (kvm_arch_interrupt_allowed(vcpu) &&
>  	    (kvm_cpu_has_interrupt(vcpu) ||
>  	    kvm_guest_apic_has_interrupt(vcpu)))
> -- 
> 2.42.0.283.g2d96d420d3-goog
> 
