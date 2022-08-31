Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9891F5A7B94
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 12:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiHaKnq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 06:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbiHaKnj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 06:43:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07323C877D
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 03:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661942615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XEnoteWaPcXVcCaT4ktnvKCklJJhM9Jf54qMIwHsBEA=;
        b=cqxvpRLTxJR0+rS/V94Z+4bLVemZVgGef06w7u73v0Wxua4djZhC890zqUL8Mx8umRei8E
        BBs061mro5bjwL8yKuBlXdI/jT4pwlujYuMpVIwSekFVRH47eDO/YPMhxRTCS018X2stO2
        vR6Ll8GVKwovMkI6mVDygP9nMcm76iw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-o0AgAB6sNE-xnu6bNiyYag-1; Wed, 31 Aug 2022 06:43:31 -0400
X-MC-Unique: o0AgAB6sNE-xnu6bNiyYag-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD1E038164CF;
        Wed, 31 Aug 2022 10:43:29 +0000 (UTC)
Received: from starship (unknown [10.40.194.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D86C2166B26;
        Wed, 31 Aug 2022 10:43:27 +0000 (UTC)
Message-ID: <c86151790ab014f18adc64fc4c6a7e4d9e45299f.camel@redhat.com>
Subject: Re: [PATCH v2 1/3] KVM: x86: Hyper-V invariant TSC control
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 31 Aug 2022 13:43:26 +0300
In-Reply-To: <20220831085009.1627523-2-vkuznets@redhat.com>
References: <20220831085009.1627523-1-vkuznets@redhat.com>
         <20220831085009.1627523-2-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-31 at 10:50 +0200, Vitaly Kuznetsov wrote:
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

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/cpuid.c            |  7 +++++++
>  arch/x86/kvm/hyperv.c           | 19 +++++++++++++++++++
>  arch/x86/kvm/hyperv.h           | 15 +++++++++++++++
>  arch/x86/kvm/x86.c              |  4 +++-
>  5 files changed, 45 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 2c96c43c313a..9098187e13aa 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1021,6 +1021,7 @@ struct kvm_hv {
>  	u64 hv_reenlightenment_control;
>  	u64 hv_tsc_emulation_control;
>  	u64 hv_tsc_emulation_status;
> +	u64 hv_invtsc;
>  
>  	/* How many vCPUs have VP index != vCPU index */
>  	atomic_t num_mismatched_vp_indexes;
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 75dcf7a72605..8ccd45fd66a9 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1444,6 +1444,13 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>  			    (data & TSX_CTRL_CPUID_CLEAR))
>  				*ebx &= ~(F(RTM) | F(HLE));
>  		}
> +		/*
> +		 * Filter out invariant TSC (CPUID.80000007H:EDX[8]) for Hyper-V
> +		 * guests if needed.
> +		 */
> +		if (function == 0x80000007 && kvm_hv_invtsc_filtered(vcpu))
> +			*edx &= ~(1 << 8);
> +
>  	} else {
>  		*eax = *ebx = *ecx = *edx = 0;
>  		/*
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index ed804447589c..df90cd7501b9 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -991,6 +991,7 @@ static bool kvm_hv_msr_partition_wide(u32 msr)
>  	case HV_X64_MSR_REENLIGHTENMENT_CONTROL:
>  	case HV_X64_MSR_TSC_EMULATION_CONTROL:
>  	case HV_X64_MSR_TSC_EMULATION_STATUS:
> +	case HV_X64_MSR_TSC_INVARIANT_CONTROL:
>  	case HV_X64_MSR_SYNDBG_OPTIONS:
>  	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
>  		r = true;
> @@ -1275,6 +1276,9 @@ static bool hv_check_msr_access(struct kvm_vcpu_hv *hv_vcpu, u32 msr)
>  	case HV_X64_MSR_TSC_EMULATION_STATUS:
>  		return hv_vcpu->cpuid_cache.features_eax &
>  			HV_ACCESS_REENLIGHTENMENT;
> +	case HV_X64_MSR_TSC_INVARIANT_CONTROL:
> +		return hv_vcpu->cpuid_cache.features_eax &
> +			HV_ACCESS_TSC_INVARIANT;
>  	case HV_X64_MSR_CRASH_P0 ... HV_X64_MSR_CRASH_P4:
>  	case HV_X64_MSR_CRASH_CTL:
>  		return hv_vcpu->cpuid_cache.features_edx &
> @@ -1402,6 +1406,17 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
>  		if (!host)
>  			return 1;
>  		break;
> +	case HV_X64_MSR_TSC_INVARIANT_CONTROL:
> +		/* Only bit 0 is supported */
> +		if (data & ~BIT_ULL(0))
> +			return 1;
> +
> +		/* The feature can't be disabled from the guest */
> +		if (!host && hv->hv_invtsc && !data)
> +			return 1;
> +
> +		hv->hv_invtsc = data;
> +		break;
>  	case HV_X64_MSR_SYNDBG_OPTIONS:
>  	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
>  		return syndbg_set_msr(vcpu, msr, data, host);
> @@ -1577,6 +1592,9 @@ static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
>  	case HV_X64_MSR_TSC_EMULATION_STATUS:
>  		data = hv->hv_tsc_emulation_status;
>  		break;
> +	case HV_X64_MSR_TSC_INVARIANT_CONTROL:
> +		data = hv->hv_invtsc;
> +		break;
>  	case HV_X64_MSR_SYNDBG_OPTIONS:
>  	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
>  		return syndbg_get_msr(vcpu, msr, pdata, host);
> @@ -2497,6 +2515,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  			ent->eax |= HV_MSR_REFERENCE_TSC_AVAILABLE;
>  			ent->eax |= HV_ACCESS_FREQUENCY_MSRS;
>  			ent->eax |= HV_ACCESS_REENLIGHTENMENT;
> +			ent->eax |= HV_ACCESS_TSC_INVARIANT;
>  
>  			ent->ebx |= HV_POST_MESSAGES;
>  			ent->ebx |= HV_SIGNAL_EVENTS;
> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> index da2737f2a956..1a6316ab55eb 100644
> --- a/arch/x86/kvm/hyperv.h
> +++ b/arch/x86/kvm/hyperv.h
> @@ -133,6 +133,21 @@ static inline bool kvm_hv_has_stimer_pending(struct kvm_vcpu *vcpu)
>  			     HV_SYNIC_STIMER_COUNT);
>  }
>  
> +/*
> + * With HV_ACCESS_TSC_INVARIANT feature, invariant TSC (CPUID.80000007H:EDX[8])
> + * is only observed after HV_X64_MSR_TSC_INVARIANT_CONTROL was written to.
> + */
> +static inline bool kvm_hv_invtsc_filtered(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> +	struct kvm_hv *hv = to_kvm_hv(vcpu->kvm);
> +
> +	if (hv_vcpu && hv_vcpu->cpuid_cache.features_eax & HV_ACCESS_TSC_INVARIANT)
> +		return !hv->hv_invtsc;
> +
> +	return false;
> +}
> +
>  void kvm_hv_process_stimers(struct kvm_vcpu *vcpu);
>  
>  void kvm_hv_setup_tsc_page(struct kvm *kvm,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d7374d768296..ad429800f9b5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1471,7 +1471,7 @@ static const u32 emulated_msrs_all[] = {
>  	HV_X64_MSR_STIMER0_CONFIG,
>  	HV_X64_MSR_VP_ASSIST_PAGE,
>  	HV_X64_MSR_REENLIGHTENMENT_CONTROL, HV_X64_MSR_TSC_EMULATION_CONTROL,
> -	HV_X64_MSR_TSC_EMULATION_STATUS,
> +	HV_X64_MSR_TSC_EMULATION_STATUS, HV_X64_MSR_TSC_INVARIANT_CONTROL,
>  	HV_X64_MSR_SYNDBG_OPTIONS,
>  	HV_X64_MSR_SYNDBG_CONTROL, HV_X64_MSR_SYNDBG_STATUS,
>  	HV_X64_MSR_SYNDBG_SEND_BUFFER, HV_X64_MSR_SYNDBG_RECV_BUFFER,
> @@ -3777,6 +3777,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case HV_X64_MSR_REENLIGHTENMENT_CONTROL:
>  	case HV_X64_MSR_TSC_EMULATION_CONTROL:
>  	case HV_X64_MSR_TSC_EMULATION_STATUS:
> +	case HV_X64_MSR_TSC_INVARIANT_CONTROL:
>  		return kvm_hv_set_msr_common(vcpu, msr, data,
>  					     msr_info->host_initiated);
>  	case MSR_IA32_BBL_CR_CTL3:
> @@ -4147,6 +4148,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case HV_X64_MSR_REENLIGHTENMENT_CONTROL:
>  	case HV_X64_MSR_TSC_EMULATION_CONTROL:
>  	case HV_X64_MSR_TSC_EMULATION_STATUS:
> +	case HV_X64_MSR_TSC_INVARIANT_CONTROL:
>  		return kvm_hv_get_msr_common(vcpu,
>  					     msr_info->index, &msr_info->data,
>  					     msr_info->host_initiated);


