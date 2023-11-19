Return-Path: <kvm+bounces-2015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAF7E7F0814
	for <lists+kvm@lfdr.de>; Sun, 19 Nov 2023 18:22:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57046280D75
	for <lists+kvm@lfdr.de>; Sun, 19 Nov 2023 17:22:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F117F1804D;
	Sun, 19 Nov 2023 17:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BftdGh39"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68837C0
	for <kvm@vger.kernel.org>; Sun, 19 Nov 2023 09:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700414529;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0yDy6R/jKLaZg6IRZkgBkMJE63LDhRf6vUwxU51PW9o=;
	b=BftdGh393SIkx4AncL2Q7liwyH0g1HAwxzLdyjo65uL5A5QGlKN1gVEXfrmT5ZmaQXf7lv
	jZhHTOmLrnI6nhSdpqA/lgXLZF0P1Ia/kMWjn1wdPGjBQpdYzNkR40QMDoFzad7CLkcTRE
	0krAHudK8PSZMTUw1avK/oghS5FsiTE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-260-6XFmT_sKMG2zoITr-VKV2Q-1; Sun, 19 Nov 2023 12:22:07 -0500
X-MC-Unique: 6XFmT_sKMG2zoITr-VKV2Q-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-32fd8da34fbso1695969f8f.1
        for <kvm@vger.kernel.org>; Sun, 19 Nov 2023 09:22:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700414526; x=1701019326;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0yDy6R/jKLaZg6IRZkgBkMJE63LDhRf6vUwxU51PW9o=;
        b=QLNy9Zx2iJ9iSGP4F1cBBRXjqcP433cVlUYGa4zujK83zrpDpN/9e1ygXdwisDcwIx
         LN+dQa9xaYtI8ZnbP+0PYfzEhHKcEijkt8mnBD+bJLpWBiU4G30N80yPGeTWYk5YHbb7
         i62Pcu4n2PZIxswDnU5l1bh/NYd4Ti4yElzCSEtk7eAx62u1nx//3uUkz1haKQOvW5V8
         85/9Zba8DgOQtJP5Y0uF1TJD2x6Kc0RxBsJRVhuIqlpAZiH78iVGsnJaVESxaggjeFGW
         haBaYOk6zk8y8lkt30gL2JY5hWGuYdSW+y/DH+FWQ1lPjeZltQtlzj3ZbCC43FS2uQIq
         I8Tw==
X-Gm-Message-State: AOJu0YzzXRFfT4kaJA3M5t4azDpx3YZaK+F+DZ0P5dlPILy09SUWKJeG
	lcjDuYl+BrYlTJ0WzXO4wYVFCCUs02QyvR00+gQe3I5cMgY5UJ04Tlbx4lBkDJYOMuSysmDAbtD
	uQg9AxIREfzFT
X-Received: by 2002:adf:e503:0:b0:331:6a43:5abe with SMTP id j3-20020adfe503000000b003316a435abemr3005406wrm.62.1700414525758;
        Sun, 19 Nov 2023 09:22:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHbuluwlJG/ixP8hr1VhFDj9LNtMTbHc+68CQKrBP1cSPqNELmbTDZsnOpoZqHTo9td/gQcsA==
X-Received: by 2002:adf:e503:0:b0:331:6a43:5abe with SMTP id j3-20020adfe503000000b003316a435abemr3005384wrm.62.1700414525342;
        Sun, 19 Nov 2023 09:22:05 -0800 (PST)
Received: from starship ([77.137.131.4])
        by smtp.gmail.com with ESMTPSA id s13-20020a5d6a8d000000b0032fbe5b1e45sm8482069wru.61.2023.11.19.09.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Nov 2023 09:22:04 -0800 (PST)
Message-ID: <c38adc1dc0a7df1c902b8ffbc82076d6da527e2a.camel@redhat.com>
Subject: Re: [PATCH 2/9] KVM: x86: Replace guts of "goverened" features with
 comprehensive cpu_caps
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 19 Nov 2023 19:22:03 +0200
In-Reply-To: <20231110235528.1561679-3-seanjc@google.com>
References: <20231110235528.1561679-1-seanjc@google.com>
	 <20231110235528.1561679-3-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2023-11-10 at 15:55 -0800, Sean Christopherson wrote:
> Replace the internals of the governed features framework with a more
> comprehensive "guest CPU capabilities" implementation, i.e. with a guest
> version of kvm_cpu_caps.  Keep the skeleton of governed features around
> for now as vmx_adjust_sec_exec_control() relies on detecting governed
> features to do the right thing for XSAVES, and switching all guest feature
> queries to guest_cpu_cap_has() requires subtle and non-trivial changes,
> i.e. is best done as a standalone change.
> 
> Tracking *all* guest capabilities that KVM cares will allow excising the
> poorly named "governed features" framework, and effectively optimizes all
> KVM queries of guest capabilities, i.e. doesn't require making a
> subjective decision as to whether or not a feature is worth "governing",
> and doesn't require adding the code to do so.
> 
> The cost of tracking all features is currently 92 bytes per vCPU on 64-bit
> kernels: 100 bytes for cpu_caps versus 8 bytes for governed_features.
> That cost is well worth paying even if the only benefit was eliminating
> the "governed features" terminology.  And practically speaking, the real
> cost is zero unless those 92 bytes pushes the size of vcpu_vmx or vcpu_svm
> into a new order-N allocation, and if that happens there are better ways
> to reduce the footprint of kvm_vcpu_arch, e.g. making the PMU and/or MTRR
> state separate allocations.
> 
> Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 40 ++++++++++++++++++++-------------
>  arch/x86/kvm/cpuid.c            |  4 +---
>  arch/x86/kvm/cpuid.h            | 14 ++++++------
>  arch/x86/kvm/reverse_cpuid.h    | 15 -------------
>  4 files changed, 32 insertions(+), 41 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d7036982332e..1d43dd5fdea7 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -722,6 +722,22 @@ struct kvm_queued_exception {
>  	bool has_payload;
>  };
>  
> +/*
> + * Hardware-defined CPUID leafs that are either scattered by the kernel or are
> + * unknown to the kernel, but need to be directly used by KVM.  Note, these
> + * word values conflict with the kernel's "bug" caps, but KVM doesn't use those.
> + */
> +enum kvm_only_cpuid_leafs {
> +	CPUID_12_EAX	 = NCAPINTS,
> +	CPUID_7_1_EDX,
> +	CPUID_8000_0007_EDX,
> +	CPUID_8000_0022_EAX,
> +	NR_KVM_CPU_CAPS,
> +
> +	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
> +};
> +
> +
>  struct kvm_vcpu_arch {
>  	/*
>  	 * rip and regs accesses must go through
> @@ -840,23 +856,15 @@ struct kvm_vcpu_arch {
>  	struct kvm_hypervisor_cpuid kvm_cpuid;
>  
>  	/*
> -	 * FIXME: Drop this macro and use KVM_NR_GOVERNED_FEATURES directly
> -	 * when "struct kvm_vcpu_arch" is no longer defined in an
> -	 * arch/x86/include/asm header.  The max is mostly arbitrary, i.e.
> -	 * can be increased as necessary.
> +	 * Track the effective guest capabilities, i.e. the features the vCPU
> +	 * is allowed to use.  Typically, but not always, features can be used
> +	 * by the guest if and only if both KVM and userspace want to expose
> +	 * the feature to the guest.  A common exception is for virtualization
> +	 * holes, i.e. when KVM can't prevent the guest from using a feature,
> +	 * in which case the vCPU "has" the feature regardless of what KVM or
> +	 * userspace desires.
>  	 */
> -#define KVM_MAX_NR_GOVERNED_FEATURES BITS_PER_LONG
> -
> -	/*
> -	 * Track whether or not the guest is allowed to use features that are
> -	 * governed by KVM, where "governed" means KVM needs to manage state
> -	 * and/or explicitly enable the feature in hardware.  Typically, but
> -	 * not always, governed features can be used by the guest if and only
> -	 * if both KVM and userspace want to expose the feature to the guest.
> -	 */
> -	struct {
> -		DECLARE_BITMAP(enabled, KVM_MAX_NR_GOVERNED_FEATURES);
> -	} governed_features;
> +	u32 cpu_caps[NR_KVM_CPU_CAPS];

Won't it be better to call this 'effective_cpu_caps' or something like that,
to put emphasis on the fact that these are not exactly the cpu caps that userspace wants.
Although probably any name will still be somewhat confusing.

>  
>  	u64 reserved_gpa_bits;
>  	int maxphyaddr;
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 4f464187b063..4bf3c2d4dc7c 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -327,9 +327,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	struct kvm_cpuid_entry2 *best;
>  	bool allow_gbpages;
>  
> -	BUILD_BUG_ON(KVM_NR_GOVERNED_FEATURES > KVM_MAX_NR_GOVERNED_FEATURES);
> -	bitmap_zero(vcpu->arch.governed_features.enabled,
> -		    KVM_MAX_NR_GOVERNED_FEATURES);
> +	memset(vcpu->arch.cpu_caps, 0, sizeof(vcpu->arch.cpu_caps));
>  
>  	/*
>  	 * If TDP is enabled, let the guest use GBPAGES if they're supported in
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index 245416ffa34c..9f18c4395b71 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -255,12 +255,12 @@ static __always_inline bool kvm_is_governed_feature(unsigned int x86_feature)
>  }
>  
>  static __always_inline void guest_cpu_cap_set(struct kvm_vcpu *vcpu,
> -						     unsigned int x86_feature)
> +					      unsigned int x86_feature)
>  {
> -	BUILD_BUG_ON(!kvm_is_governed_feature(x86_feature));
> +	unsigned int x86_leaf = __feature_leaf(x86_feature);
>  
> -	__set_bit(kvm_governed_feature_index(x86_feature),
> -		  vcpu->arch.governed_features.enabled);
> +	reverse_cpuid_check(x86_leaf);
> +	vcpu->arch.cpu_caps[x86_leaf] |= __feature_bit(x86_feature);
>  }
>  
>  static __always_inline void guest_cpu_cap_check_and_set(struct kvm_vcpu *vcpu,
> @@ -273,10 +273,10 @@ static __always_inline void guest_cpu_cap_check_and_set(struct kvm_vcpu *vcpu,
>  static __always_inline bool guest_cpu_cap_has(struct kvm_vcpu *vcpu,
>  					      unsigned int x86_feature)
>  {
> -	BUILD_BUG_ON(!kvm_is_governed_feature(x86_feature));
> +	unsigned int x86_leaf = __feature_leaf(x86_feature);
>  
> -	return test_bit(kvm_governed_feature_index(x86_feature),
> -			vcpu->arch.governed_features.enabled);
> +	reverse_cpuid_check(x86_leaf);
> +	return vcpu->arch.cpu_caps[x86_leaf] & __feature_bit(x86_feature);
>  }

It might make sense to think about extracting the common code between
kvm_cpu_cap* and guest_cpu_cap*.

The whole notion of reverse cpuid, KVM only leaves, and other nice things
that it has is already very confusing, but as I understand there is
no better way of doing it.
But there must be a way to avoid at least duplicating this logic.

Also speaking of this logic, it would be nice to document it.
E.g for 'kvm_only_cpuid_leafs' it would be nice to have an explanation
for each entry on why it is needed.


Just curious: I wonder why Intel called them leaves?
CPUID leaves are just table entries, I don't see any tree there.

Finally isn't plural of "leaf" is "leaves"?

>  
>  #endif
> diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
> index b81650678375..4b658491e8f8 100644
> --- a/arch/x86/kvm/reverse_cpuid.h
> +++ b/arch/x86/kvm/reverse_cpuid.h
> @@ -6,21 +6,6 @@
>  #include <asm/cpufeature.h>
>  #include <asm/cpufeatures.h>
>  
> -/*
> - * Hardware-defined CPUID leafs that are either scattered by the kernel or are
> - * unknown to the kernel, but need to be directly used by KVM.  Note, these
> - * word values conflict with the kernel's "bug" caps, but KVM doesn't use those.
> - */
> -enum kvm_only_cpuid_leafs {
> -	CPUID_12_EAX	 = NCAPINTS,
> -	CPUID_7_1_EDX,
> -	CPUID_8000_0007_EDX,
> -	CPUID_8000_0022_EAX,
> -	NR_KVM_CPU_CAPS,
> -
> -	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
> -};
> -
>  /*
>   * Define a KVM-only feature flag.
>   *

Best regards,
	Maxim Levitsky




