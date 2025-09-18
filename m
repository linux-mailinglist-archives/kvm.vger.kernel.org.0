Return-Path: <kvm+bounces-57960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BEA6B82976
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 03:57:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08E424A5167
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 01:57:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23C6923A562;
	Thu, 18 Sep 2025 01:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IweHNEZu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732CB5223;
	Thu, 18 Sep 2025 01:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758160643; cv=none; b=ktqFZhYnThv5ATMvCZJr/nsd5LLn88UWaEfjEXJkbHmyj1jT3fYQ60TcQCqHViaYZ84v7c8Y4hF0qcRPstqvBS+OUs2bkINeH90DsZ3IKFkzjcJWxBmDMSdZpFyT0bEuiOdUeMxuEAR39nYg1y3egxuWuDI3qtu8Yhf9b2BIQ/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758160643; c=relaxed/simple;
	bh=D4MoqKxaW7oV2rJO7jvZR9LWbvj1O22cRIsTYFgqCHE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ol8UWRQyyWc/Q5aa3dZJg3grZGstNNlDngDLxosranh6xVGsRL7grRXeB1vJgRsSbEUpTp4nWpGeJ9W9lehG1zKHxNF0cVUX/eAqgT9LKEgQSD6lRVFRhMEkRQo/lZv71Hmyl2F0p08mwUmdn4snw5cjA9i36VnE4nQehdAIhkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IweHNEZu; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758160642; x=1789696642;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=D4MoqKxaW7oV2rJO7jvZR9LWbvj1O22cRIsTYFgqCHE=;
  b=IweHNEZuInzTEjBV2FP02CzwTWsDAc4iMwePYJ1GEcWaoGPJD9KJjSNu
   /5jysDZLPcdOAv/BLdp0fzGgA+Z4Ghc+xtExWgxu2JLInD3VTphqqfgmm
   bVO7lAfLgGhvxaH3wSPQM8sz9kYNu7SN/TpeFJm1Bv1w5Xb3JA+R9s23+
   mbb3aPLvKEWFHotziGIjdVpsZuWXive+4DTZD9mGRN3QmnnxklWMmu812
   sVFR0/lp0ktOLObTIJGCOnPphyBooBJeJAUHH5qnjU/Unvu3a3LJt9Wv5
   kHSEVHJM9KlULPID30ixrsGLz3IITTh2ttGCfhUvIja0PNOn4Bxv5tEdg
   Q==;
X-CSE-ConnectionGUID: sOtmPk7zRKqVTLj/10YR3A==
X-CSE-MsgGUID: 0TPDOnAgQQKy5HOWJ/zwOQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11556"; a="59700222"
X-IronPort-AV: E=Sophos;i="6.18,273,1751266800"; 
   d="scan'208";a="59700222"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 18:57:21 -0700
X-CSE-ConnectionGUID: 0P750mH/S/u70o+qs3ubuw==
X-CSE-MsgGUID: KXuVzuhLRbmPN8ZgM30pNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,273,1751266800"; 
   d="scan'208";a="180684541"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 18:57:18 -0700
Message-ID: <d3459026-c935-4738-8b28-49492e88e113@linux.intel.com>
Date: Thu, 18 Sep 2025 09:57:16 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 19/41] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-20-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250912232319.429659-20-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/13/2025 7:22 AM, Sean Christopherson wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
>
> Expose CET features to guest if KVM/host can support them, clear CPUID
> feature bits if KVM/host cannot support.
>
> Set CPUID feature bits so that CET features are available in guest CPUID.
> Add CR4.CET bit support in order to allow guest set CET master control
> bit.
>
> Disable KVM CET feature if unrestricted_guest is unsupported/disabled as
> KVM does not support emulating CET.
>
> The CET load-bits in VM_ENTRY/VM_EXIT control fields should be set to make
> guest CET xstates isolated from host's.
>
> On platforms with VMX_BASIC[bit56] == 0, inject #CP at VMX entry with error
> code will fail, and if VMX_BASIC[bit56] == 1, #CP injection with or without
> error code is allowed. Disable CET feature bits if the MSR bit is cleared
> so that nested VMM can inject #CP if and only if VMX_BASIC[bit56] == 1.
>
> Don't expose CET feature if either of {U,S}_CET xstate bits is cleared
> in host XSS or if XSAVES isn't supported.
>
> CET MSRs are reset to 0s after RESET, power-up and INIT, clear guest CET
> xsave-area fields so that guest CET MSRs are reset to 0s after the events.
>
> Meanwhile explicitly disable SHSTK and IBT for SVM because CET KVM enabling
> for SVM is not ready.
>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

One nit below.

[...]
> 			\
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 15f208c44cbd..c78acab2ff3f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -226,7 +226,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
>    * PT via guest XSTATE would clobber perf state), i.e. KVM doesn't support
>    * IA32_XSS[bit 8] (guests can/must use RDMSR/WRMSR to save/restore PT MSRs).
>    */
> -#define KVM_SUPPORTED_XSS     0
> +#define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_USER | \
> +				 XFEATURE_MASK_CET_KERNEL)

Since XFEATURE_MASK_CET_USER and XFEATURE_MASK_CET_KERNEL are always checked or
set together, does it make sense to use a macro for the two bits?

>   
>   bool __read_mostly allow_smaller_maxphyaddr = 0;
>   EXPORT_SYMBOL_GPL(allow_smaller_maxphyaddr);
> @@ -10080,6 +10081,20 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>   	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
>   		kvm_caps.supported_xss = 0;
>   
> +	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
> +	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
> +		kvm_caps.supported_xss &= ~(XFEATURE_MASK_CET_USER |
> +					    XFEATURE_MASK_CET_KERNEL);
> +
> +	if ((kvm_caps.supported_xss & (XFEATURE_MASK_CET_USER |
> +	     XFEATURE_MASK_CET_KERNEL)) !=
> +	    (XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)) {
> +		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
> +		kvm_cpu_cap_clear(X86_FEATURE_IBT);
> +		kvm_caps.supported_xss &= ~(XFEATURE_MASK_CET_USER |
> +					    XFEATURE_MASK_CET_KERNEL);
> +	}
> +
>   	if (kvm_caps.has_tsc_control) {
>   		/*
>   		 * Make sure the user can only configure tsc_khz values that
> @@ -12735,10 +12750,11 @@ static void kvm_xstate_reset(struct kvm_vcpu *vcpu, bool init_event)
>   	/*
>   	 * On INIT, only select XSTATE components are zeroed, most components
>   	 * are unchanged.  Currently, the only components that are zeroed and
> -	 * supported by KVM are MPX related.
> +	 * supported by KVM are MPX and CET related.
>   	 */
>   	xfeatures_mask = (kvm_caps.supported_xcr0 | kvm_caps.supported_xss) &
> -			 (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
> +			 (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR |
> +			  XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL);
>   	if (!xfeatures_mask)
>   		return;
>   
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 65cbd454c4f1..f3dc77f006f9 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -680,6 +680,9 @@ static inline bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>   		__reserved_bits |= X86_CR4_PCIDE;       \
>   	if (!__cpu_has(__c, X86_FEATURE_LAM))           \
>   		__reserved_bits |= X86_CR4_LAM_SUP;     \
> +	if (!__cpu_has(__c, X86_FEATURE_SHSTK) &&       \
> +	    !__cpu_has(__c, X86_FEATURE_IBT))           \
> +		__reserved_bits |= X86_CR4_CET;         \
>   	__reserved_bits;                                \
>   })
>   


