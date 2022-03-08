Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 614434D1C2E
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 16:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347952AbiCHPqD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 10:46:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347950AbiCHPqC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 10:46:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9A60F4EF71
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 07:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646754304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rdA4w8LbTfbO/8LxgUmZLL43yin3Uqz8drWsfnOkw8I=;
        b=SHCKpmMkajH65vWod+dm7758KGWZPobyMFgZabiCG3N4p0eJkb7HtiYfLvCppl2n9xCYeL
        7QsovI/7N5LGGZrbAoH3dwkhoIUbet1RpTh8JMsP53gq+v8VfxH8QPClwpn61z5ipo8ACX
        YymLyJJpUyiPIa1BgLqD5ODpQaaQVLc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-36-UlMye97PNe-RDw0fMHr6ow-1; Tue, 08 Mar 2022 10:45:03 -0500
X-MC-Unique: UlMye97PNe-RDw0fMHr6ow-1
Received: by mail-ed1-f69.google.com with SMTP id r9-20020a05640251c900b00412d54ea618so10759075edd.3
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 07:45:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rdA4w8LbTfbO/8LxgUmZLL43yin3Uqz8drWsfnOkw8I=;
        b=ivkHnrOIkJUbBrfjsa/L5WJwvb8Tf1beYN8nwF1nThKb9rrxHx7vcOm/B2hrYK32Kl
         HeHVxCPi2IbAjkPv3vtGB1T1qN1sM75dN42Emt5lkjYAOueznBkY7NaAu2Hs0/goyV4H
         qrFoq0NBEL5EOqGTRyvMcUC5v3PQo+08dwnc9/Xqvld2vjDAMEVbjkiDrDr9H2RBvpJQ
         SxD4fBTRJpiSQmnZ0bAagODaU2c6ZA4yyUd0CXTlLU6H93Dafkf3qSMEfIi/B+nEH3oB
         FqVXZA59/iGqV9HlUtQta9ZX4kPNg+JJHCB4/+lXI8up64THKLjZD8awotINMHGewmaq
         Wi9A==
X-Gm-Message-State: AOAM532VwsZQPtMkRH4TCsDXoLMPjq8axqIUvF96WglhNNUax+dfijxv
        Fu4cykkdPR1kjaH4KAgG8dWErxMNQ4sAveiWuU0jDu4UewJg7dVutKGNNA/AkJS18vjyPUydto9
        bOnbyM8EpCMmr
X-Received: by 2002:a05:6402:34cb:b0:415:b974:ec5c with SMTP id w11-20020a05640234cb00b00415b974ec5cmr16934661edc.329.1646754301859;
        Tue, 08 Mar 2022 07:45:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwzz7vuMiPhx/8NdpijYL8yY3/JJVoTDhwfwDxx5+soMln9pTYwH5wrycK39T1sjL4S27EwmQ==
X-Received: by 2002:a05:6402:34cb:b0:415:b974:ec5c with SMTP id w11-20020a05640234cb00b00415b974ec5cmr16934643edc.329.1646754301651;
        Tue, 08 Mar 2022 07:45:01 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id a1-20020aa7d901000000b00416217c99bcsm5022166edr.65.2022.03.08.07.44.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 07:45:00 -0800 (PST)
Message-ID: <87df0676-2f43-939e-2869-72f70c733915@redhat.com>
Date:   Tue, 8 Mar 2022 16:44:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] KVM: x86/pmu: Use different raw event masks for AMD and
 Intel
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        like.xu.linux@gmail.com
References: <20220308012452.3468611-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220308012452.3468611-1-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/8/22 02:24, Jim Mattson wrote:
> The third nybble of AMD's event select overlaps with Intel's IN_TX and
> IN_TXCP bits. Therefore, we can't use AMD64_RAW_EVENT_MASK on Intel
> platforms that support TSX.
> 
> Declare a raw_event_mask in the kvm_pmu structure, initialize it in
> the vendor-specific pmu_refresh() functions, and use that mask for
> PERF_TYPE_RAW configurations in reprogram_gp_counter().
> 
> Fixes: 710c47651431 ("KVM: x86/pmu: Use AMD64_RAW_EVENT_MASK for PERF_TYPE_RAW")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 1 +
>   arch/x86/kvm/pmu.c              | 3 ++-
>   arch/x86/kvm/svm/pmu.c          | 1 +
>   arch/x86/kvm/vmx/pmu_intel.c    | 1 +
>   4 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index c45ab8b5c37f..cacd27c1aa19 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -510,6 +510,7 @@ struct kvm_pmu {
>   	u64 global_ctrl_mask;
>   	u64 global_ovf_ctrl_mask;
>   	u64 reserved_bits;
> +	u64 raw_event_mask;
>   	u8 version;
>   	struct kvm_pmc gp_counters[INTEL_PMC_MAX_GENERIC];
>   	struct kvm_pmc fixed_counters[INTEL_PMC_MAX_FIXED];
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index b1a02993782b..902b6d700215 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -185,6 +185,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
>   	u32 type = PERF_TYPE_RAW;
>   	struct kvm *kvm = pmc->vcpu->kvm;
>   	struct kvm_pmu_event_filter *filter;
> +	struct kvm_pmu *pmu = vcpu_to_pmu(pmc->vcpu);
>   	bool allow_event = true;
>   
>   	if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
> @@ -221,7 +222,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
>   	}
>   
>   	if (type == PERF_TYPE_RAW)
> -		config = eventsel & AMD64_RAW_EVENT_MASK;
> +		config = eventsel & pmu->raw_event_mask;
>   
>   	if (pmc->current_config == eventsel && pmc_resume_counter(pmc))
>   		return;
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index 886e8ac5cfaa..24eb935b6f85 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -282,6 +282,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
>   
>   	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << 48) - 1;
>   	pmu->reserved_bits = 0xfffffff000280000ull;
> +	pmu->raw_event_mask = AMD64_RAW_EVENT_MASK;
>   	pmu->version = 1;
>   	/* not applicable to AMD; but clean them to prevent any fall out */
>   	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 4e5b1eeeb77c..da71160a50d6 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -485,6 +485,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>   	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
>   	pmu->version = 0;
>   	pmu->reserved_bits = 0xffffffff00200000ull;
> +	pmu->raw_event_mask = X86_RAW_EVENT_MASK;
>   
>   	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
>   	if (!entry || !vcpu->kvm->arch.enable_pmu)

Queued, thanks.

Paolo

