Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662195748CC
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 11:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238272AbiGNJ06 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 05:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237928AbiGNJ03 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 05:26:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C174255B4
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 02:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657790722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PjyxPDoAfnGHvLQ9oi2iH0nJfF4BvIMD++QLiGPQ/R0=;
        b=AuxLkj4s2c3tn4L8F4/qO4WOw7lFe+7KQC0N1FjaH1qwH7Mu+vOcaZoH7qG5hYvJkIHlUD
        HAxO5pqpdpcP1UU4Mc5fRIUOsrHSP5EOx0N8LdlSsbE6GHpZmp+EaDa/LHiMpSWxYFOYmN
        lJE1gv8Rvh4V6FyoYPlBjttEBJNNk+E=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-38-SCIaIoY5M9GNVFoVLYVixA-1; Thu, 14 Jul 2022 05:25:21 -0400
X-MC-Unique: SCIaIoY5M9GNVFoVLYVixA-1
Received: by mail-wr1-f72.google.com with SMTP id n10-20020a5d6b8a000000b0021da91e4a64so404001wrx.8
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 02:25:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=PjyxPDoAfnGHvLQ9oi2iH0nJfF4BvIMD++QLiGPQ/R0=;
        b=IWRXRBYi19Q4OHAabthAB/vTiH9CEzSrLjkWzbIO6S3MQqcV2II2Ou+yGoPDGd5XD4
         zC2FzhNYE7LMS7l98maeVmK795p56aJM/JUoJzriQbGEHkiSkUhNzcu2652G4a7QdEba
         E/tL4GoN5NJTN298aIpCAZhVKESbTHx1yNL94DzJ3qEf6UvwA7YzXPu1TJv8Asp8r/rM
         yOufc/OUdOZ6a8NOTqDPLnYFlDk5MndVUPrMLwc0HOGqqEqSMTTxIgAK+MRztubRaIl8
         k1xN/CEt/v4Z1tGB7Pq0fuayXyr0usxkpX1hBSbk/qtR/ITq6pVkKEWNV1uG15wpxmDt
         nGvQ==
X-Gm-Message-State: AJIora+NnGKuNVSsHxhhALsd0Gv9fZP0mLoP17vFnYVxXVHQWzfr9XlC
        WTAqm+/SN2li2R2epIa9WY3ClF0jYMxHHJZFtQhEkbuAbnL4TVkh4zSqxW0zuRvA/rzqZ1zYnFa
        fTwqrgMS2UNBS
X-Received: by 2002:a05:600c:4e8f:b0:3a1:8b21:ebbc with SMTP id f15-20020a05600c4e8f00b003a18b21ebbcmr8170750wmq.149.1657790720230;
        Thu, 14 Jul 2022 02:25:20 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sDWa8M97C7iUgKy7ob02lo7HXopDQcslI8WX/Nv6bE77svQ5nWRf23KjxkgEGoAyTYxyc6aw==
X-Received: by 2002:a05:600c:4e8f:b0:3a1:8b21:ebbc with SMTP id f15-20020a05600c4e8f00b003a18b21ebbcmr8170731wmq.149.1657790719957;
        Thu, 14 Jul 2022 02:25:19 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id v130-20020a1cac88000000b003a046549a85sm4852696wme.37.2022.07.14.02.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 02:25:19 -0700 (PDT)
Message-ID: <399f335a97f5e46a339f906290e0c90de3613fe9.camel@redhat.com>
Subject: Re: [PATCH 1/3] KVM: x86: Hyper-V invariant TSC control
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Date:   Thu, 14 Jul 2022 12:25:17 +0300
In-Reply-To: <20220713150532.1012466-2-vkuznets@redhat.com>
References: <20220713150532.1012466-1-vkuznets@redhat.com>
         <20220713150532.1012466-2-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-07-13 at 17:05 +0200, Vitaly Kuznetsov wrote:
> Normally, genuine Hyper-V doesn't expose architectural invariant TSC
> (CPUID.80000007H:EDX[8]) to its guests by default. A special PV MSR
> (HV_X64_MSR_TSC_INVARIANT_CONTROL, 0x40000118) and corresponding CPUID
> feature bit (CPUID.0x40000003.EAX[15]) were introduced. When bit 0 of the
> PV MSR is set, invariant TSC bit starts to show up in CPUID. When the
> feature is exposed to Hyper-V guests, reenlightenment becomes unneeded.
> 
> Add the feature to KVM. Keep CPUID output intact when the feature
> wasn't exposed to L1 and implement the required logic for hiding
> invariant TSC when the feature was exposed and invariant TSC control
> MSR wasn't written to. Copy genuine Hyper-V behavior and forbid to
> disable the feature once it was enabled.
> 
> For the reference, for linux guests, support for the feature was added
> in commit dce7cd62754b ("x86/hyperv: Allow guests to enable InvariantTSC").
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/cpuid.c            |  7 +++++++
>  arch/x86/kvm/hyperv.c           | 19 +++++++++++++++++++
>  arch/x86/kvm/hyperv.h           | 15 +++++++++++++++
>  arch/x86/kvm/x86.c              |  4 +++-
>  5 files changed, 45 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index de5a149d0971..88553f0b524c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1022,6 +1022,7 @@ struct kvm_hv {
>         u64 hv_reenlightenment_control;
>         u64 hv_tsc_emulation_control;
>         u64 hv_tsc_emulation_status;
> +       u64 hv_invtsc;
>  
>         /* How many vCPUs have VP index != vCPU index */
>         atomic_t num_mismatched_vp_indexes;
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index d47222ab8e6e..788df2eb1ec4 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1404,6 +1404,13 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>                             (data & TSX_CTRL_CPUID_CLEAR))
>                                 *ebx &= ~(F(RTM) | F(HLE));
>                 }

Tiny nitpick: Maybe add a bit longer comment about this thing, like that guest needs to opt-in
to see invtsc when it has the HV feature exposed to it, 
I don't have a strong preference about this though.

> +               /*
> +                * Filter out invariant TSC (CPUID.80000007H:EDX[8]) for Hyper-V
> +                * guests if needed.
> +                */
> +               if (function == 0x80000007 && kvm_hv_invtsc_filtered(vcpu))
> +                       *edx &= ~(1 << 8);

> +
>         } else {
>                 *eax = *ebx = *ecx = *edx = 0;
>                 /*
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index e2e95a6fccfd..0d8e6526a839 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -991,6 +991,7 @@ static bool kvm_hv_msr_partition_wide(u32 msr)
>         case HV_X64_MSR_REENLIGHTENMENT_CONTROL:
>         case HV_X64_MSR_TSC_EMULATION_CONTROL:
>         case HV_X64_MSR_TSC_EMULATION_STATUS:
> +       case HV_X64_MSR_TSC_INVARIANT_CONTROL:
>         case HV_X64_MSR_SYNDBG_OPTIONS:
>         case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
>                 r = true;
> @@ -1275,6 +1276,9 @@ static bool hv_check_msr_access(struct kvm_vcpu_hv *hv_vcpu, u32 msr)
>         case HV_X64_MSR_TSC_EMULATION_STATUS:
>                 return hv_vcpu->cpuid_cache.features_eax &
>                         HV_ACCESS_REENLIGHTENMENT;
> +       case HV_X64_MSR_TSC_INVARIANT_CONTROL:
> +               return hv_vcpu->cpuid_cache.features_eax &
> +                       HV_ACCESS_TSC_INVARIANT;
>         case HV_X64_MSR_CRASH_P0 ... HV_X64_MSR_CRASH_P4:
>         case HV_X64_MSR_CRASH_CTL:
>                 return hv_vcpu->cpuid_cache.features_edx &
> @@ -1402,6 +1406,17 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
>                 if (!host)
>                         return 1;
>                 break;
> +       case HV_X64_MSR_TSC_INVARIANT_CONTROL:
> +               /* Only bit 0 is supported */
> +               if (data & ~BIT_ULL(0))
> +                       return 1;
> +
> +               /* The feature can't be disabled from the guest */
> +               if (!host && hv->hv_invtsc && !data)
> +                       return 1;

The unit test in patch 3 claims, that this msr should #GP when 'invtsc'
aka bit 8 of edx of leaf 0x80000007 is not enabled by the hypervisor in the guest cpuid.

Yet, looking at the code I think that this msr read/write access only depends on
the 'new' cpuid bit, aka the HV_ACCESS_TSC_INVARIANT, thus this msr will 'work'
but do nothing if 'invtsc' is not exposed (it will then not turn it on).



> +
> +               hv->hv_invtsc = data;
> +               break;
>         case HV_X64_MSR_SYNDBG_OPTIONS:
>         case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
>                 return syndbg_set_msr(vcpu, msr, data, host);
> @@ -1577,6 +1592,9 @@ static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
>         case HV_X64_MSR_TSC_EMULATION_STATUS:
>                 data = hv->hv_tsc_emulation_status;
>                 break;
> +       case HV_X64_MSR_TSC_INVARIANT_CONTROL:
> +               data = hv->hv_invtsc;
> +               break;
>         case HV_X64_MSR_SYNDBG_OPTIONS:
>         case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
>                 return syndbg_get_msr(vcpu, msr, pdata, host);
> @@ -2497,6 +2515,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>                         ent->eax |= HV_MSR_REFERENCE_TSC_AVAILABLE;
>                         ent->eax |= HV_ACCESS_FREQUENCY_MSRS;
>                         ent->eax |= HV_ACCESS_REENLIGHTENMENT;
> +                       ent->eax |= HV_ACCESS_TSC_INVARIANT;
>  
>                         ent->ebx |= HV_POST_MESSAGES;
>                         ent->ebx |= HV_SIGNAL_EVENTS;
> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> index da2737f2a956..1a6316ab55eb 100644
> --- a/arch/x86/kvm/hyperv.h
> +++ b/arch/x86/kvm/hyperv.h
> @@ -133,6 +133,21 @@ static inline bool kvm_hv_has_stimer_pending(struct kvm_vcpu *vcpu)
>                              HV_SYNIC_STIMER_COUNT);
>  }
>  
> +/*
> + * With HV_ACCESS_TSC_INVARIANT feature, invariant TSC (CPUID.80000007H:EDX[8])
> + * is only observed after HV_X64_MSR_TSC_INVARIANT_CONTROL was written to.
> + */
> +static inline bool kvm_hv_invtsc_filtered(struct kvm_vcpu *vcpu)
> +{
> +       struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> +       struct kvm_hv *hv = to_kvm_hv(vcpu->kvm);
> +
> +       if (hv_vcpu && hv_vcpu->cpuid_cache.features_eax & HV_ACCESS_TSC_INVARIANT)
> +               return !hv->hv_invtsc;
> +
> +       return false;
> +}
> +
>  void kvm_hv_process_stimers(struct kvm_vcpu *vcpu);
>  
>  void kvm_hv_setup_tsc_page(struct kvm *kvm,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 567d13405445..322e0a544823 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1466,7 +1466,7 @@ static const u32 emulated_msrs_all[] = {
>         HV_X64_MSR_STIMER0_CONFIG,
>         HV_X64_MSR_VP_ASSIST_PAGE,
>         HV_X64_MSR_REENLIGHTENMENT_CONTROL, HV_X64_MSR_TSC_EMULATION_CONTROL,
> -       HV_X64_MSR_TSC_EMULATION_STATUS,
> +       HV_X64_MSR_TSC_EMULATION_STATUS, HV_X64_MSR_TSC_INVARIANT_CONTROL,
>         HV_X64_MSR_SYNDBG_OPTIONS,
>         HV_X64_MSR_SYNDBG_CONTROL, HV_X64_MSR_SYNDBG_STATUS,
>         HV_X64_MSR_SYNDBG_SEND_BUFFER, HV_X64_MSR_SYNDBG_RECV_BUFFER,
> @@ -3769,6 +3769,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>         case HV_X64_MSR_REENLIGHTENMENT_CONTROL:
>         case HV_X64_MSR_TSC_EMULATION_CONTROL:
>         case HV_X64_MSR_TSC_EMULATION_STATUS:
> +       case HV_X64_MSR_TSC_INVARIANT_CONTROL:
>                 return kvm_hv_set_msr_common(vcpu, msr, data,
>                                              msr_info->host_initiated);
>         case MSR_IA32_BBL_CR_CTL3:
> @@ -4139,6 +4140,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>         case HV_X64_MSR_REENLIGHTENMENT_CONTROL:
>         case HV_X64_MSR_TSC_EMULATION_CONTROL:
>         case HV_X64_MSR_TSC_EMULATION_STATUS:
> +       case HV_X64_MSR_TSC_INVARIANT_CONTROL:
>                 return kvm_hv_get_msr_common(vcpu,
>                                              msr_info->index, &msr_info->data,
>                                              msr_info->host_initiated);


Beware that this new msr also will need to be migrated by qemu, 
when the feature is added to qemu -
I had my own share of fun with AMD's TSC ratio msr when I implemented it
(had to fix it twice in qemu :( ...)

Best regards,
	Maxim Levitrsky

