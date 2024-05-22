Return-Path: <kvm+bounces-17926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D4C58CBB22
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 08:23:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32D88281DA7
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 06:23:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9017278C8E;
	Wed, 22 May 2024 06:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mAQqnmaF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B603018B1A;
	Wed, 22 May 2024 06:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716359003; cv=none; b=kCuw7F/7gp3+uSKnfFRI4UWeDF54O2oIFezVF+sbppmdHmxNj3EE3cBnhqClUuU3ZzZ/xUUWsRVoUm+8rFJkFrpYPak8ggOwq8X25vwneNUWxj9S/6cJq5ZcgpBXAko6jOUWnyN23s/jIFtYGJ1qAXuunme7VVpuNqfvhKufovQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716359003; c=relaxed/simple;
	bh=gL+jDYOFb6oMDjEJ9oFeSQH2k0FsJz1AF0qKezKEZ2w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GmaZfdFwJtXV4eFJY2zZ89ICUAcgjGCxVLhjP+jiG/Fse2U6RrWR2qzr2hczbKvtOVA+2WRwbjjBwswE9WtG1j1jW7KwUCvRoFsPaqxFbEi6klZu1SETuocEAkLIRhsKwpbHbsURmaWeiU2Ns84njDQD9WIEhAN+jPbbA4DMDY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mAQqnmaF; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716359002; x=1747895002;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gL+jDYOFb6oMDjEJ9oFeSQH2k0FsJz1AF0qKezKEZ2w=;
  b=mAQqnmaFoFCabrMNkh0NNG8xFhw5VAYHt0giHxWYY1M8Q4BOzTxmQSLS
   +3nViOTAn2UDXxv6qfBcgpWbNunX9WmpJwBZpVWggNOjseI1zofFPhuQt
   b7mWJxKuYmy9UQl9aDMrUxrvAjy95UdVCSx0pfHlz+89Mst12CMWaolzj
   +I/fGIklS6RDYNCiPAcHsFlflvRhSxZJrig14YIPasOn31NqxDZ8Q8H6f
   zMHWA819asJA6yP70lwXwpQm0UwhjmFxNXHBKP4rFPjkg6xIcKAdYLgRO
   Psdb3iyprnrtvawPyNYABndFobmTPSvI/2M/jnf+60gxz3RAyFH98wrOh
   A==;
X-CSE-ConnectionGUID: 5xGDgxvYRZmXTldy5A6y/Q==
X-CSE-MsgGUID: xIING5cNQmOAZGXX3J3lsQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11079"; a="15538594"
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="15538594"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 23:23:21 -0700
X-CSE-ConnectionGUID: QhaGxeTAQv+nYr5q2jXWTQ==
X-CSE-MsgGUID: oR0oQIlkSb+9aT578bh+kA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="37655218"
Received: from unknown (HELO [10.238.8.173]) ([10.238.8.173])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 23:23:18 -0700
Message-ID: <7ed7f3b7-4970-4723-8969-6452aed41b01@linux.intel.com>
Date: Wed, 22 May 2024 14:23:16 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 20/49] KVM: x86: Rename kvm_cpu_cap_mask() to
 kvm_cpu_cap_init()
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
 Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>,
 Yang Weijiang <weijiang.yang@intel.com>,
 Robert Hoo <robert.hoo.linux@gmail.com>
References: <20240517173926.965351-1-seanjc@google.com>
 <20240517173926.965351-21-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240517173926.965351-21-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/18/2024 1:38 AM, Sean Christopherson wrote:
> Rename kvm_cpu_cap_mask() to kvm_cpu_cap_init() in anticipation of merging
> it with kvm_cpu_cap_init_kvm_defined(), and in anticipation of _setting_
> bits in the helper (a future commit will play macro games to set emulated
> feature flags via kvm_cpu_cap_init()).
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/cpuid.c | 36 ++++++++++++++++++------------------
>   1 file changed, 18 insertions(+), 18 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index a802c09b50ab..5a4d6138c4f1 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -74,7 +74,7 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
>    * Raw Feature - For features that KVM supports based purely on raw host CPUID,
>    * i.e. that KVM virtualizes even if the host kernel doesn't use the feature.
>    * Simply force set the feature in KVM's capabilities, raw CPUID support will
> - * be factored in by kvm_cpu_cap_mask().
> + * be factored in by __kvm_cpu_cap_mask().

kvm_cpu_cap_init()?


>    */
>   #define RAW_F(name)						\
>   ({								\
> @@ -619,7 +619,7 @@ static __always_inline void __kvm_cpu_cap_mask(unsigned int leaf)
>   static __always_inline
>   void kvm_cpu_cap_init_kvm_defined(enum kvm_only_cpuid_leafs leaf, u32 mask)
>   {
> -	/* Use kvm_cpu_cap_mask for leafs that aren't KVM-only. */
> +	/* Use kvm_cpu_cap_init for leafs that aren't KVM-only. */
>   	BUILD_BUG_ON(leaf < NCAPINTS);
>   
>   	kvm_cpu_caps[leaf] = mask;
> @@ -627,7 +627,7 @@ void kvm_cpu_cap_init_kvm_defined(enum kvm_only_cpuid_leafs leaf, u32 mask)
>   	__kvm_cpu_cap_mask(leaf);
>   }
>   
> -static __always_inline void kvm_cpu_cap_mask(enum cpuid_leafs leaf, u32 mask)
> +static __always_inline void kvm_cpu_cap_init(enum cpuid_leafs leaf, u32 mask)
>   {
>   	/* Use kvm_cpu_cap_init_kvm_defined for KVM-only leafs. */
>   	BUILD_BUG_ON(leaf >= NCAPINTS);
> @@ -656,7 +656,7 @@ void kvm_set_cpu_caps(void)
>   	memcpy(&kvm_cpu_caps, &boot_cpu_data.x86_capability,
>   	       sizeof(kvm_cpu_caps) - (NKVMCAPINTS * sizeof(*kvm_cpu_caps)));
>   
> -	kvm_cpu_cap_mask(CPUID_1_ECX,
> +	kvm_cpu_cap_init(CPUID_1_ECX,
>   		/*
>   		 * NOTE: MONITOR (and MWAIT) are emulated as NOP, but *not*
>   		 * advertised to guests via CPUID!
> @@ -673,7 +673,7 @@ void kvm_set_cpu_caps(void)
>   	/* KVM emulates x2apic in software irrespective of host support. */
>   	kvm_cpu_cap_set(X86_FEATURE_X2APIC);
>   
> -	kvm_cpu_cap_mask(CPUID_1_EDX,
> +	kvm_cpu_cap_init(CPUID_1_EDX,
>   		F(FPU) | F(VME) | F(DE) | F(PSE) |
>   		F(TSC) | F(MSR) | F(PAE) | F(MCE) |
>   		F(CX8) | F(APIC) | 0 /* Reserved */ | F(SEP) |
> @@ -684,7 +684,7 @@ void kvm_set_cpu_caps(void)
>   		0 /* HTT, TM, Reserved, PBE */
>   	);
>   
> -	kvm_cpu_cap_mask(CPUID_7_0_EBX,
> +	kvm_cpu_cap_init(CPUID_7_0_EBX,
>   		F(FSGSBASE) | F(SGX) | F(BMI1) | F(HLE) | F(AVX2) |
>   		F(FDP_EXCPTN_ONLY) | F(SMEP) | F(BMI2) | F(ERMS) | F(INVPCID) |
>   		F(RTM) | F(ZERO_FCS_FDS) | 0 /*MPX*/ | F(AVX512F) |
> @@ -693,7 +693,7 @@ void kvm_set_cpu_caps(void)
>   		F(AVX512ER) | F(AVX512CD) | F(SHA_NI) | F(AVX512BW) |
>   		F(AVX512VL));
>   
> -	kvm_cpu_cap_mask(CPUID_7_ECX,
> +	kvm_cpu_cap_init(CPUID_7_ECX,
>   		F(AVX512VBMI) | RAW_F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
>   		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
>   		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
> @@ -708,7 +708,7 @@ void kvm_set_cpu_caps(void)
>   	if (!tdp_enabled || !boot_cpu_has(X86_FEATURE_OSPKE))
>   		kvm_cpu_cap_clear(X86_FEATURE_PKU);
>   
> -	kvm_cpu_cap_mask(CPUID_7_EDX,
> +	kvm_cpu_cap_init(CPUID_7_EDX,
>   		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
>   		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
>   		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
> @@ -727,7 +727,7 @@ void kvm_set_cpu_caps(void)
>   	if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
>   		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
>   
> -	kvm_cpu_cap_mask(CPUID_7_1_EAX,
> +	kvm_cpu_cap_init(CPUID_7_1_EAX,
>   		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) |
>   		F(FZRM) | F(FSRS) | F(FSRC) |
>   		F(AMX_FP16) | F(AVX_IFMA) | F(LAM)
> @@ -743,7 +743,7 @@ void kvm_set_cpu_caps(void)
>   		F(BHI_CTRL) | F(MCDT_NO)
>   	);
>   
> -	kvm_cpu_cap_mask(CPUID_D_1_EAX,
> +	kvm_cpu_cap_init(CPUID_D_1_EAX,
>   		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES) | f_xfd
>   	);
>   
> @@ -751,7 +751,7 @@ void kvm_set_cpu_caps(void)
>   		SF(SGX1) | SF(SGX2) | SF(SGX_EDECCSSA)
>   	);
>   
> -	kvm_cpu_cap_mask(CPUID_8000_0001_ECX,
> +	kvm_cpu_cap_init(CPUID_8000_0001_ECX,
>   		F(LAHF_LM) | F(CMP_LEGACY) | 0 /*SVM*/ | 0 /* ExtApicSpace */ |
>   		F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
>   		F(3DNOWPREFETCH) | F(OSVW) | 0 /* IBS */ | F(XOP) |
> @@ -759,7 +759,7 @@ void kvm_set_cpu_caps(void)
>   		F(TOPOEXT) | 0 /* PERFCTR_CORE */
>   	);
>   
> -	kvm_cpu_cap_mask(CPUID_8000_0001_EDX,
> +	kvm_cpu_cap_init(CPUID_8000_0001_EDX,
>   		F(FPU) | F(VME) | F(DE) | F(PSE) |
>   		F(TSC) | F(MSR) | F(PAE) | F(MCE) |
>   		F(CX8) | F(APIC) | 0 /* Reserved */ | F(SYSCALL) |
> @@ -777,7 +777,7 @@ void kvm_set_cpu_caps(void)
>   		SF(CONSTANT_TSC)
>   	);
>   
> -	kvm_cpu_cap_mask(CPUID_8000_0008_EBX,
> +	kvm_cpu_cap_init(CPUID_8000_0008_EBX,
>   		F(CLZERO) | F(XSAVEERPTR) |
>   		F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
>   		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON) |
> @@ -811,13 +811,13 @@ void kvm_set_cpu_caps(void)
>   	 * Hide all SVM features by default, SVM will set the cap bits for
>   	 * features it emulates and/or exposes for L1.
>   	 */
> -	kvm_cpu_cap_mask(CPUID_8000_000A_EDX, 0);
> +	kvm_cpu_cap_init(CPUID_8000_000A_EDX, 0);
>   
> -	kvm_cpu_cap_mask(CPUID_8000_001F_EAX,
> +	kvm_cpu_cap_init(CPUID_8000_001F_EAX,
>   		0 /* SME */ | 0 /* SEV */ | 0 /* VM_PAGE_FLUSH */ | 0 /* SEV_ES */ |
>   		F(SME_COHERENT));
>   
> -	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
> +	kvm_cpu_cap_init(CPUID_8000_0021_EAX,
>   		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
>   		F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | 0 /* PrefetchCtlMsr */ |
>   		F(WRMSR_XX_BASE_NS)
> @@ -837,7 +837,7 @@ void kvm_set_cpu_caps(void)
>   	 * kernel.  LFENCE_RDTSC was a Linux-defined synthetic feature long
>   	 * before AMD joined the bandwagon, e.g. LFENCE is serializing on most
>   	 * CPUs that support SSE2.  On CPUs that don't support AMD's leaf,
> -	 * kvm_cpu_cap_mask() will unfortunately drop the flag due to ANDing
> +	 * kvm_cpu_cap_init() will unfortunately drop the flag due to ANDing
>   	 * the mask with the raw host CPUID, and reporting support in AMD's
>   	 * leaf can make it easier for userspace to detect the feature.
>   	 */
> @@ -847,7 +847,7 @@ void kvm_set_cpu_caps(void)
>   		kvm_cpu_cap_set(X86_FEATURE_NULL_SEL_CLR_BASE);
>   	kvm_cpu_cap_set(X86_FEATURE_NO_SMM_CTL_MSR);
>   
> -	kvm_cpu_cap_mask(CPUID_C000_0001_EDX,
> +	kvm_cpu_cap_init(CPUID_C000_0001_EDX,
>   		F(XSTORE) | F(XSTORE_EN) | F(XCRYPT) | F(XCRYPT_EN) |
>   		F(ACE2) | F(ACE2_EN) | F(PHE) | F(PHE_EN) |
>   		F(PMM) | F(PMM_EN)


