Return-Path: <kvm+bounces-1645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E5C817EACB0
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 10:12:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7BDD01F233E2
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 09:12:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF9AA168B1;
	Tue, 14 Nov 2023 09:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="abp/PJws"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B469416403
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 09:12:18 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05DBAFA;
	Tue, 14 Nov 2023 01:12:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699953138; x=1731489138;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=x/uDVrG5M/HDXqdiwuRXkGmBYGt4nwjnv3V8VjCtkmM=;
  b=abp/PJws1T6ndX8rk34qN44g7NECh48kgsgrkoEM24QH1CI61tNkysfD
   Af0yGBmsGsID8DvxlIH2nvXr37nVNuCJ1XllaqG6wPdk3wSmAzVF5ONHM
   B2dSLRM7i8gGH4/zMKr4N1phkZ37wTFmojY2Ke0ZlKxdtg4P9rk67JFmu
   5ZNVL43oDboduaXCR+rSNv6ChZm7yV5PYNyCnZT4EX0WorhlFGuI03EAe
   4Z9T9ScDYhVBJFwhw3qGPwmNhGq6f8xJFTDs5jN8ViM8PKgF8nCDfFxH3
   a0NLtxn5ztpNplgRnKHVop71RNOVAYtb87aHv+tw4jHFxhWjGpEQe8an2
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10893"; a="9255397"
X-IronPort-AV: E=Sophos;i="6.03,301,1694761200"; 
   d="scan'208";a="9255397"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 01:12:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10893"; a="741036676"
X-IronPort-AV: E=Sophos;i="6.03,301,1694761200"; 
   d="scan'208";a="741036676"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.2.39]) ([10.238.2.39])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 01:12:15 -0800
Message-ID: <b8dae758-ece1-44bd-87b2-122c772c3f07@linux.intel.com>
Date: Tue, 14 Nov 2023 17:12:12 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/9] KVM: x86: Replace guts of "goverened" features with
 comprehensive cpu_caps
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
References: <20231110235528.1561679-1-seanjc@google.com>
 <20231110235528.1561679-3-seanjc@google.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20231110235528.1561679-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/11/2023 7:55 AM, Sean Christopherson wrote:
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
Nit: one typo in the short log, "goverened" -> "governed"

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/include/asm/kvm_host.h | 40 ++++++++++++++++++++-------------
>   arch/x86/kvm/cpuid.c            |  4 +---
>   arch/x86/kvm/cpuid.h            | 14 ++++++------
>   arch/x86/kvm/reverse_cpuid.h    | 15 -------------
>   4 files changed, 32 insertions(+), 41 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d7036982332e..1d43dd5fdea7 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -722,6 +722,22 @@ struct kvm_queued_exception {
>   	bool has_payload;
>   };
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
>   struct kvm_vcpu_arch {
>   	/*
>   	 * rip and regs accesses must go through
> @@ -840,23 +856,15 @@ struct kvm_vcpu_arch {
>   	struct kvm_hypervisor_cpuid kvm_cpuid;
>   
>   	/*
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
>   	 */
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
>   
>   	u64 reserved_gpa_bits;
>   	int maxphyaddr;
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 4f464187b063..4bf3c2d4dc7c 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -327,9 +327,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   	struct kvm_cpuid_entry2 *best;
>   	bool allow_gbpages;
>   
> -	BUILD_BUG_ON(KVM_NR_GOVERNED_FEATURES > KVM_MAX_NR_GOVERNED_FEATURES);
> -	bitmap_zero(vcpu->arch.governed_features.enabled,
> -		    KVM_MAX_NR_GOVERNED_FEATURES);
> +	memset(vcpu->arch.cpu_caps, 0, sizeof(vcpu->arch.cpu_caps));
>   
>   	/*
>   	 * If TDP is enabled, let the guest use GBPAGES if they're supported in
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index 245416ffa34c..9f18c4395b71 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -255,12 +255,12 @@ static __always_inline bool kvm_is_governed_feature(unsigned int x86_feature)
>   }
>   
>   static __always_inline void guest_cpu_cap_set(struct kvm_vcpu *vcpu,
> -						     unsigned int x86_feature)
> +					      unsigned int x86_feature)
>   {
> -	BUILD_BUG_ON(!kvm_is_governed_feature(x86_feature));
> +	unsigned int x86_leaf = __feature_leaf(x86_feature);
>   
> -	__set_bit(kvm_governed_feature_index(x86_feature),
> -		  vcpu->arch.governed_features.enabled);
> +	reverse_cpuid_check(x86_leaf);
> +	vcpu->arch.cpu_caps[x86_leaf] |= __feature_bit(x86_feature);
>   }
>   
>   static __always_inline void guest_cpu_cap_check_and_set(struct kvm_vcpu *vcpu,
> @@ -273,10 +273,10 @@ static __always_inline void guest_cpu_cap_check_and_set(struct kvm_vcpu *vcpu,
>   static __always_inline bool guest_cpu_cap_has(struct kvm_vcpu *vcpu,
>   					      unsigned int x86_feature)
>   {
> -	BUILD_BUG_ON(!kvm_is_governed_feature(x86_feature));
> +	unsigned int x86_leaf = __feature_leaf(x86_feature);
>   
> -	return test_bit(kvm_governed_feature_index(x86_feature),
> -			vcpu->arch.governed_features.enabled);
> +	reverse_cpuid_check(x86_leaf);
> +	return vcpu->arch.cpu_caps[x86_leaf] & __feature_bit(x86_feature);
>   }
>   
>   #endif
> diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
> index b81650678375..4b658491e8f8 100644
> --- a/arch/x86/kvm/reverse_cpuid.h
> +++ b/arch/x86/kvm/reverse_cpuid.h
> @@ -6,21 +6,6 @@
>   #include <asm/cpufeature.h>
>   #include <asm/cpufeatures.h>
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
>   /*
>    * Define a KVM-only feature flag.
>    *


