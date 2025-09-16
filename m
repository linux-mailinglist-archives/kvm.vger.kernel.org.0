Return-Path: <kvm+bounces-57688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D9D38B58F26
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 09:30:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A01037A543A
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 07:28:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 496F42E62BE;
	Tue, 16 Sep 2025 07:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KW8pnfPS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD244265CAB;
	Tue, 16 Sep 2025 07:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758007793; cv=none; b=nf0HUBfRPJnCLpUOs49iLuGHDc8kI24lWZF49vtyQ8IarX6SqP9nBqjH3r8+wvCdPRjp+NjFAiv+eEbd2SGEg4mdQTccOpKyfTCpunmp9hM8aRVPAqXv6xn64U57Tx56qx2uZVmgk/OzyX57WpsccO5fpNmYJDLildkArvImcTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758007793; c=relaxed/simple;
	bh=HrOKQiR3bEpVk5GWzPd51WjZ1NZgcpzRgRAI6aH28Ns=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sKV6Dd59P64sw21pt8tDHL1i+EZJSk0YjkPtzQzGT9rrb6pmp1mLXmCQCcpmOBdDtSZYX3eJN/pjZv/z0idnqt2MWrR4HMP7VNWeN0iGy+JomsFzfCc4LuakMyhgHhjbo+F/ZDeavjtSHCFnVzpJNsuwkiFwQvqPfPlhs3Umb7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KW8pnfPS; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758007792; x=1789543792;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HrOKQiR3bEpVk5GWzPd51WjZ1NZgcpzRgRAI6aH28Ns=;
  b=KW8pnfPSJ2M+0Bhs5nbhfzoPnjbLtnQ+ztw+pBUbVjEwNo9MrCNjV6x2
   gBSkBZLSf7ZWih1Y8Pt0PxjSoL4ptS+DZ6gdJhGKp8XBzwrcy1xKopYkt
   eNPZvYvW2iNsCVwURMgkdgjYDF3Aifq4t8aHPljwgvbtyzv8a41ElaaZn
   zlk9DXlnxibxO31zPsJh/J5coRWcBcFevK8/aWYI6JjPlc25RP3dhP5rD
   oJmdFj+pKGSsTyKRmcWIz3ASrTutFuzTQf7Z0jM8vCz5g8Rlw31uMa7SU
   3Uir13YPPxFGubKzgtXsHxlTTiGmm3VTuaDxrmsGloh62BTu3XhV14iDi
   w==;
X-CSE-ConnectionGUID: aTxIiEtcRWe7pjvRO9pZ7Q==
X-CSE-MsgGUID: 2nlRnq9bTgWSQGFsylfFmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11554"; a="71377416"
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="71377416"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 00:29:52 -0700
X-CSE-ConnectionGUID: HtfF+2IwQ/Sen2PJxRwR4g==
X-CSE-MsgGUID: mGD1XDcEQVqGj5m6ts6N5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="175277666"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 00:29:48 -0700
Message-ID: <20edc765-d6af-403d-be6e-6f4647c84959@linux.intel.com>
Date: Tue, 16 Sep 2025 15:29:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 08/41] KVM: x86: Initialize kvm_caps.supported_xss
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-9-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250912232319.429659-9-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/13/2025 7:22 AM, Sean Christopherson wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
>
> Set original kvm_caps.supported_xss to (host_xss & KVM_SUPPORTED_XSS) if
> XSAVES is supported. host_xss contains the host supported xstate feature
> bits for thread FPU context switch, KVM_SUPPORTED_XSS includes all KVM
> enabled XSS feature bits, the resulting value represents the supervisor
> xstates that are available to guest and are backed by host FPU framework
> for swapping {guest,host} XSAVE-managed registers/MSRs.
>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> [sean: relocate and enhance comment about PT / XSS[8] ]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/kvm/x86.c | 23 +++++++++++++++--------
>   1 file changed, 15 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 519d58b82f7f..c5e38d6943fe 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -217,6 +217,14 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
>   				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
>   				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
>   
> +/*
> + * Note, KVM supports exposing PT to the guest, but does not support context
> + * switching PT via XSTATE (KVM's PT virtualization relies on perf; swapping
> + * PT via guest XSTATE would clobber perf state), i.e. KVM doesn't support
> + * IA32_XSS[bit 8] (guests can/must use RDMSR/WRMSR to save/restore PT MSRs).
> + */
> +#define KVM_SUPPORTED_XSS     0
> +
>   bool __read_mostly allow_smaller_maxphyaddr = 0;
>   EXPORT_SYMBOL_GPL(allow_smaller_maxphyaddr);
>   
> @@ -3986,11 +3994,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   	case MSR_IA32_XSS:
>   		if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
>   			return KVM_MSR_RET_UNSUPPORTED;
> -		/*
> -		 * KVM supports exposing PT to the guest, but does not support
> -		 * IA32_XSS[bit 8]. Guests have to use RDMSR/WRMSR rather than
> -		 * XSAVES/XRSTORS to save/restore PT MSRs.
> -		 */
> +
>   		if (data & ~vcpu->arch.guest_supported_xss)
>   			return 1;
>   		if (vcpu->arch.ia32_xss == data)
> @@ -9818,14 +9822,17 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>   		kvm_host.xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
>   		kvm_caps.supported_xcr0 = kvm_host.xcr0 & KVM_SUPPORTED_XCR0;
>   	}
> +
> +	if (boot_cpu_has(X86_FEATURE_XSAVES)) {
> +		rdmsrq(MSR_IA32_XSS, kvm_host.xss);
> +		kvm_caps.supported_xss = kvm_host.xss & KVM_SUPPORTED_XSS;
> +	}
> +
>   	kvm_caps.supported_quirks = KVM_X86_VALID_QUIRKS;
>   	kvm_caps.inapplicable_quirks = KVM_X86_CONDITIONAL_QUIRKS;
>   
>   	rdmsrq_safe(MSR_EFER, &kvm_host.efer);
>   
> -	if (boot_cpu_has(X86_FEATURE_XSAVES))
> -		rdmsrq(MSR_IA32_XSS, kvm_host.xss);
> -
>   	kvm_init_pmu_capability(ops->pmu_ops);
>   
>   	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))


