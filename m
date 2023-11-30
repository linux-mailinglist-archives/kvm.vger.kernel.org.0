Return-Path: <kvm+bounces-2985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EF50F7FF89E
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 18:43:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABE692817F9
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 17:43:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53DF15813E;
	Thu, 30 Nov 2023 17:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V8KE4XxJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E3510FF
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 09:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701366193;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7eitlarlwhMxm0lW+w9tSXOARC6Bn5ryc9RJgB/kwkE=;
	b=V8KE4XxJN+0MHxGdx7tc9TuoYRGbhHPalAI2U46gk/Weg/ARIwVxDspVqW1NIQx3c5RUx6
	hPolo8stiliMnlJvHeIMfLNGXmi4ZuO3XLmHxFF8uWIGiQP9GmsuGYHpHyHmxEoIHrDrSE
	4oY8LLcqHJg6ma33PO2oef7Z7T/CPF4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-ktuY7eaoN0awwYDDswSKaQ-1; Thu, 30 Nov 2023 12:43:11 -0500
X-MC-Unique: ktuY7eaoN0awwYDDswSKaQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-40b4096abc8so9188815e9.0
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 09:43:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701366190; x=1701970990;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7eitlarlwhMxm0lW+w9tSXOARC6Bn5ryc9RJgB/kwkE=;
        b=QnWIf8RmsbBmroIjsKfCiTTu/i96jOrqYXmoy91dPY2awde3PMr3roreBvhNm/3ZVg
         vED6E/6nIQAKYPf0qYvPEGMwYbYY1eXN2pe37aJYbigtH45YE9LpAzCKFj4cJix+m1QB
         v4Xddt7zU6yp4zeVs9UXj6RuXoNMXaORJ0mHDADoWVAvqR06aUUSwsYyeF8mRNqFG+5m
         mAqe8Li+R+lQ9qejFShb09AWlS9M150ksangQhEDCEaQ3O4xN+khmW47L5RGDRO6gorf
         Pt8MqT9vCl4ikrgibe9Wuk8XvjT+OUNf/dMsentvyGPEjIaUiYIgH61LEc2jXfTKT0xn
         CeKA==
X-Gm-Message-State: AOJu0Yz5ITmI8wMF6DGlg3NwwqYoNOHBeOt1WZqoE5k5dYgUh2joSJs3
	xtFHYDm/j+MOd5lK3NfY8rXwRT6XVYMn6mhgYOcn0JVNyE/kMN0dGc5b9Wf8boyAX6qKD05a8au
	FBSKPt9scpYJq
X-Received: by 2002:a05:6512:62:b0:50b:c0bb:b48b with SMTP id i2-20020a056512006200b0050bc0bbb48bmr18032lfo.43.1701365881105;
        Thu, 30 Nov 2023 09:38:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFmaqf02q2LGwnzMqG0KjaMy2J1+za+mBLnUKCC2fDN9U5JRT2w+c9ihZ+W3Sq9h9dsalb0/w==
X-Received: by 2002:a05:6512:62:b0:50b:c0bb:b48b with SMTP id i2-20020a056512006200b0050bc0bbb48bmr17514lfo.43.1701365869643;
        Thu, 30 Nov 2023 09:37:49 -0800 (PST)
Received: from starship ([5.28.147.32])
        by smtp.gmail.com with ESMTPSA id f20-20020a05651232d400b0050bc9731ed6sm213486lfg.276.2023.11.30.09.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 09:37:49 -0800 (PST)
Message-ID: <f86f12b69c1c1ca9f5172e7340c0253d4533fbc1.camel@redhat.com>
Subject: Re: [PATCH v7 13/26] KVM: x86: Refresh CPUID on write to guest
 MSR_IA32_XSS
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, dave.hansen@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, chao.gao@intel.com, rick.p.edgecombe@intel.com, 
	john.allen@amd.com, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Date: Thu, 30 Nov 2023 19:37:46 +0200
In-Reply-To: <20231124055330.138870-14-weijiang.yang@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-14-weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
> Update CPUID.(EAX=0DH,ECX=1).EBX to reflect current required xstate size
> due to XSS MSR modification.
> CPUID(EAX=0DH,ECX=1).EBX reports the required storage size of all enabled
> xstate features in (XCR0 | IA32_XSS). The CPUID value can be used by guest
> before allocate sufficient xsave buffer.
> 
> Note, KVM does not yet support any XSS based features, i.e. supported_xss
> is guaranteed to be zero at this time.
> 
> Opportunistically modify XSS write access logic as:
> If XSAVES is not enabled in the guest CPUID, forbid setting IA32_XSS msr
> to anything but 0, even if the write is host initiated.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  3 ++-
>  arch/x86/kvm/cpuid.c            | 15 ++++++++++++++-
>  arch/x86/kvm/x86.c              | 16 ++++++++++++----
>  3 files changed, 28 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 499bd42e3a32..f536102f1eca 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -756,7 +756,6 @@ struct kvm_vcpu_arch {
>  	bool at_instruction_boundary;
>  	bool tpr_access_reporting;
>  	bool xfd_no_write_intercept;
> -	u64 ia32_xss;
>  	u64 microcode_version;
>  	u64 arch_capabilities;
>  	u64 perf_capabilities;
> @@ -812,6 +811,8 @@ struct kvm_vcpu_arch {
>  
>  	u64 xcr0;
>  	u64 guest_supported_xcr0;
> +	u64 guest_supported_xss;
> +	u64 ia32_xss;
>  
>  	struct kvm_pio_request pio;
>  	void *pio_data;
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 0351e311168a..1d9843b34196 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -275,7 +275,8 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
>  	best = cpuid_entry2_find(entries, nent, 0xD, 1);
>  	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
>  		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
> -		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
> +		best->ebx = xstate_required_size(vcpu->arch.xcr0 |
> +						 vcpu->arch.ia32_xss, true);
>  
>  	best = __kvm_find_kvm_cpuid_features(vcpu, entries, nent);
>  	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
> @@ -312,6 +313,17 @@ static u64 vcpu_get_supported_xcr0(struct kvm_vcpu *vcpu)
>  	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
>  }
>  
> +static u64 vcpu_get_supported_xss(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_cpuid_entry2 *best;
> +
> +	best = kvm_find_cpuid_entry_index(vcpu, 0xd, 1);
> +	if (!best)
> +		return 0;
> +
> +	return (best->ecx | ((u64)best->edx << 32)) & kvm_caps.supported_xss;
> +}
> +
>  static bool kvm_cpuid_has_hyperv(struct kvm_cpuid_entry2 *entries, int nent)
>  {
>  	struct kvm_cpuid_entry2 *entry;
> @@ -358,6 +370,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	}
>  
>  	vcpu->arch.guest_supported_xcr0 = vcpu_get_supported_xcr0(vcpu);
> +	vcpu->arch.guest_supported_xss = vcpu_get_supported_xss(vcpu);
>  
>  	kvm_update_pv_runtime(vcpu);
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f7d4cc61bc55..649a100ffd25 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3901,20 +3901,28 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			vcpu->arch.ia32_tsc_adjust_msr += adj;
>  		}
>  		break;
> -	case MSR_IA32_XSS:
> -		if (!msr_info->host_initiated &&
> -		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
> +	case MSR_IA32_XSS: {
> +		/*
> +		 * If KVM reported support of XSS MSR, even guest CPUID doesn't
> +		 * support XSAVES, still allow userspace to set default value(0)
> +		 * to this MSR.
> +		 */
> +		if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVES) &&
> +		    !(msr_info->host_initiated && data == 0))
>  			return 1;
>  		/*
>  		 * KVM supports exposing PT to the guest, but does not support
>  		 * IA32_XSS[bit 8]. Guests have to use RDMSR/WRMSR rather than
>  		 * XSAVES/XRSTORS to save/restore PT MSRs.
>  		 */
> -		if (data & ~kvm_caps.supported_xss)
> +		if (data & ~vcpu->arch.guest_supported_xss)
>  			return 1;
> +		if (vcpu->arch.ia32_xss == data)
> +			break;
>  		vcpu->arch.ia32_xss = data;
>  		kvm_update_cpuid_runtime(vcpu);
>  		break;
> +	}
>  	case MSR_SMI_COUNT:
>  		if (!msr_info->host_initiated)
>  			return 1;

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky



