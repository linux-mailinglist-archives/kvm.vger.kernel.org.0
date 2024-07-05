Return-Path: <kvm+bounces-20988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AC397927FBA
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 03:24:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 620F2284474
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 01:24:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B47ACF505;
	Fri,  5 Jul 2024 01:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N+QGxfgA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2759CF50F
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 01:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720142653; cv=none; b=CtWZNpNBnjPfnM9ymqfYKxdBMqBHtqFEZZLW14ph3aqH+JJQ3FaHxRNcx5JgFHW/CB0jtsvQZO5DsWSWDhHj16xONn9TmSi9C2IYlnx66ZRrFJ+qFGG3V5Qesw94+ddOuELpYkEwlI+JxxaqlO69EhWwu64a1U9X4AJ/fXEwfrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720142653; c=relaxed/simple;
	bh=w9puIpS8VMB+MS2zX5V9H6c+crpLlqBpagbnHiU+0kI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JxdRCIJZUHPE2PQIe9xajAcLdz/0+bCSbLoOahPE+zHZbMyr3FXZnAEMo8uMUgKCOUz6YMiuDT8HsgsaOUoJ6j9mofI6t5axmAKaOOuqEigH5qatonnIpqcPidoolb3/A8hhVRZZBRtG6tS3Us9YcLzB7spZcAy1hc/SvVNk5Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N+QGxfgA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720142651;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HWUJkQMzumL4n+pm05+tGpHfPd7avCXbI9PCl2jnQIY=;
	b=N+QGxfgAXZxGEDoEqICpqNSPueN17GjNvPPfUsDq0TMo1PcV/fPZEChqBuR/lvhBr6JBkm
	rkv7/ZnldVKGIiWXSebLC8IK9bKjXZ20O39WXRI8uvOg2d/5CFAJLEBgdvFmDPTutpMypH
	asNmRXFIXKOUthob05HdCdnBNR+ZsyE=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-WUogcsKLO5imwgGk2Ai0mw-1; Thu, 04 Jul 2024 21:24:09 -0400
X-MC-Unique: WUogcsKLO5imwgGk2Ai0mw-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-79d16df6a2bso128455085a.2
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 18:24:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720142649; x=1720747449;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HWUJkQMzumL4n+pm05+tGpHfPd7avCXbI9PCl2jnQIY=;
        b=T6ft2FbwyFegIv8imnyQWVFkFPpQN5CusUEeLStmBNpN9FIv/ceEx9FGjWbdNVrxac
         aL2pDU8gCYV3Qla0Pn9GUr18zQEroUMcfQh1wPPq4pbsudAZOmcJHq1DCJcTkxLblbty
         4QQavQT/52qI+Ey74BgoBopsYTzknptG5YEU8MTTJSUbDMlKZq3EW1xq5G8hyTgGfFVm
         lXX1+b1Fjk1tdq87OmYPN+KrP1VM49FAtcjLTj7mP+KATOZ7evJMascgiNzG401c/87v
         BPKapcbqK+YGbWdbsfcKCfvfxK+ZnLqnKhaWJHAckiK8EfAwq+u5XygAHDKoNYDMUihc
         fSMg==
X-Gm-Message-State: AOJu0YxVMzcw5tBEh6LhFCFDa8A6fqLy0kh/9oLPo72QhtQP7c3ihp6x
	jQV4e81KSFK7yUbobkYDsznT1BFbrzmB+oq6DTJ9fxwrkjFNCeIL+Q9cq6SEYZ6oxWVyYEkAIDK
	aFRcuCv+hLgNLL8PIY5eU5yYbl+I7IgHJnZOwK01Y6rnLU4r1Ew==
X-Received: by 2002:a05:620a:72a5:b0:797:b88e:f321 with SMTP id af79cd13be357-79eee1dfae6mr356786685a.46.1720142649110;
        Thu, 04 Jul 2024 18:24:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG/rH69IVRg6SdAubr8nZ1Vgt6Lj6nCNDF6X5dUK86EQ21eO2yd8XTpgsp7/1C1ANHMurllew==
X-Received: by 2002:a05:620a:72a5:b0:797:b88e:f321 with SMTP id af79cd13be357-79eee1dfae6mr356784085a.46.1720142648624;
        Thu, 04 Jul 2024 18:24:08 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79d69302057sm727709085a.100.2024.07.04.18.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 18:24:08 -0700 (PDT)
Message-ID: <01ec3aeb03b5b56299205eafae0062fba237255a.camel@redhat.com>
Subject: Re: [PATCH v2 20/49] KVM: x86: Rename kvm_cpu_cap_mask() to
 kvm_cpu_cap_init()
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 21:24:07 -0400
In-Reply-To: <20240517173926.965351-21-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-21-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2024-05-17 at 10:38 -0700, Sean Christopherson wrote:
> Rename kvm_cpu_cap_mask() to kvm_cpu_cap_init() in anticipation of merging
> it with kvm_cpu_cap_init_kvm_defined(), and in anticipation of _setting_
> bits in the helper (a future commit will play macro games to set emulated
> feature flags via kvm_cpu_cap_init()).
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 36 ++++++++++++++++++------------------
>  1 file changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index a802c09b50ab..5a4d6138c4f1 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -74,7 +74,7 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
>   * Raw Feature - For features that KVM supports based purely on raw host CPUID,
>   * i.e. that KVM virtualizes even if the host kernel doesn't use the feature.
>   * Simply force set the feature in KVM's capabilities, raw CPUID support will
> - * be factored in by kvm_cpu_cap_mask().
> + * be factored in by __kvm_cpu_cap_mask().
>   */
>  #define RAW_F(name)						\
>  ({								\
> @@ -619,7 +619,7 @@ static __always_inline void __kvm_cpu_cap_mask(unsigned int leaf)
>  static __always_inline
>  void kvm_cpu_cap_init_kvm_defined(enum kvm_only_cpuid_leafs leaf, u32 mask)
>  {
> -	/* Use kvm_cpu_cap_mask for leafs that aren't KVM-only. */
> +	/* Use kvm_cpu_cap_init for leafs that aren't KVM-only. */
>  	BUILD_BUG_ON(leaf < NCAPINTS);
>  
>  	kvm_cpu_caps[leaf] = mask;
> @@ -627,7 +627,7 @@ void kvm_cpu_cap_init_kvm_defined(enum kvm_only_cpuid_leafs leaf, u32 mask)
>  	__kvm_cpu_cap_mask(leaf);
>  }
>  
> -static __always_inline void kvm_cpu_cap_mask(enum cpuid_leafs leaf, u32 mask)
> +static __always_inline void kvm_cpu_cap_init(enum cpuid_leafs leaf, u32 mask)
>  {
>  	/* Use kvm_cpu_cap_init_kvm_defined for KVM-only leafs. */
>  	BUILD_BUG_ON(leaf >= NCAPINTS);
> @@ -656,7 +656,7 @@ void kvm_set_cpu_caps(void)
>  	memcpy(&kvm_cpu_caps, &boot_cpu_data.x86_capability,
>  	       sizeof(kvm_cpu_caps) - (NKVMCAPINTS * sizeof(*kvm_cpu_caps)));
>  
> -	kvm_cpu_cap_mask(CPUID_1_ECX,
> +	kvm_cpu_cap_init(CPUID_1_ECX,
>  		/*
>  		 * NOTE: MONITOR (and MWAIT) are emulated as NOP, but *not*
>  		 * advertised to guests via CPUID!
> @@ -673,7 +673,7 @@ void kvm_set_cpu_caps(void)
>  	/* KVM emulates x2apic in software irrespective of host support. */
>  	kvm_cpu_cap_set(X86_FEATURE_X2APIC);
>  
> -	kvm_cpu_cap_mask(CPUID_1_EDX,
> +	kvm_cpu_cap_init(CPUID_1_EDX,
>  		F(FPU) | F(VME) | F(DE) | F(PSE) |
>  		F(TSC) | F(MSR) | F(PAE) | F(MCE) |
>  		F(CX8) | F(APIC) | 0 /* Reserved */ | F(SEP) |
> @@ -684,7 +684,7 @@ void kvm_set_cpu_caps(void)
>  		0 /* HTT, TM, Reserved, PBE */
>  	);
>  
> -	kvm_cpu_cap_mask(CPUID_7_0_EBX,
> +	kvm_cpu_cap_init(CPUID_7_0_EBX,
>  		F(FSGSBASE) | F(SGX) | F(BMI1) | F(HLE) | F(AVX2) |
>  		F(FDP_EXCPTN_ONLY) | F(SMEP) | F(BMI2) | F(ERMS) | F(INVPCID) |
>  		F(RTM) | F(ZERO_FCS_FDS) | 0 /*MPX*/ | F(AVX512F) |
> @@ -693,7 +693,7 @@ void kvm_set_cpu_caps(void)
>  		F(AVX512ER) | F(AVX512CD) | F(SHA_NI) | F(AVX512BW) |
>  		F(AVX512VL));
>  
> -	kvm_cpu_cap_mask(CPUID_7_ECX,
> +	kvm_cpu_cap_init(CPUID_7_ECX,
>  		F(AVX512VBMI) | RAW_F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
>  		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
>  		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
> @@ -708,7 +708,7 @@ void kvm_set_cpu_caps(void)
>  	if (!tdp_enabled || !boot_cpu_has(X86_FEATURE_OSPKE))
>  		kvm_cpu_cap_clear(X86_FEATURE_PKU);
>  
> -	kvm_cpu_cap_mask(CPUID_7_EDX,
> +	kvm_cpu_cap_init(CPUID_7_EDX,
>  		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
>  		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
>  		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
> @@ -727,7 +727,7 @@ void kvm_set_cpu_caps(void)
>  	if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
>  		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
>  
> -	kvm_cpu_cap_mask(CPUID_7_1_EAX,
> +	kvm_cpu_cap_init(CPUID_7_1_EAX,
>  		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) |
>  		F(FZRM) | F(FSRS) | F(FSRC) |
>  		F(AMX_FP16) | F(AVX_IFMA) | F(LAM)
> @@ -743,7 +743,7 @@ void kvm_set_cpu_caps(void)
>  		F(BHI_CTRL) | F(MCDT_NO)
>  	);
>  
> -	kvm_cpu_cap_mask(CPUID_D_1_EAX,
> +	kvm_cpu_cap_init(CPUID_D_1_EAX,
>  		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES) | f_xfd
>  	);
>  
> @@ -751,7 +751,7 @@ void kvm_set_cpu_caps(void)
>  		SF(SGX1) | SF(SGX2) | SF(SGX_EDECCSSA)
>  	);
>  
> -	kvm_cpu_cap_mask(CPUID_8000_0001_ECX,
> +	kvm_cpu_cap_init(CPUID_8000_0001_ECX,
>  		F(LAHF_LM) | F(CMP_LEGACY) | 0 /*SVM*/ | 0 /* ExtApicSpace */ |
>  		F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
>  		F(3DNOWPREFETCH) | F(OSVW) | 0 /* IBS */ | F(XOP) |
> @@ -759,7 +759,7 @@ void kvm_set_cpu_caps(void)
>  		F(TOPOEXT) | 0 /* PERFCTR_CORE */
>  	);
>  
> -	kvm_cpu_cap_mask(CPUID_8000_0001_EDX,
> +	kvm_cpu_cap_init(CPUID_8000_0001_EDX,
>  		F(FPU) | F(VME) | F(DE) | F(PSE) |
>  		F(TSC) | F(MSR) | F(PAE) | F(MCE) |
>  		F(CX8) | F(APIC) | 0 /* Reserved */ | F(SYSCALL) |
> @@ -777,7 +777,7 @@ void kvm_set_cpu_caps(void)
>  		SF(CONSTANT_TSC)
>  	);
>  
> -	kvm_cpu_cap_mask(CPUID_8000_0008_EBX,
> +	kvm_cpu_cap_init(CPUID_8000_0008_EBX,
>  		F(CLZERO) | F(XSAVEERPTR) |
>  		F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
>  		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON) |
> @@ -811,13 +811,13 @@ void kvm_set_cpu_caps(void)
>  	 * Hide all SVM features by default, SVM will set the cap bits for
>  	 * features it emulates and/or exposes for L1.
>  	 */
> -	kvm_cpu_cap_mask(CPUID_8000_000A_EDX, 0);
> +	kvm_cpu_cap_init(CPUID_8000_000A_EDX, 0);
>  
> -	kvm_cpu_cap_mask(CPUID_8000_001F_EAX,
> +	kvm_cpu_cap_init(CPUID_8000_001F_EAX,
>  		0 /* SME */ | 0 /* SEV */ | 0 /* VM_PAGE_FLUSH */ | 0 /* SEV_ES */ |
>  		F(SME_COHERENT));
>  
> -	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
> +	kvm_cpu_cap_init(CPUID_8000_0021_EAX,
>  		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
>  		F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | 0 /* PrefetchCtlMsr */ |
>  		F(WRMSR_XX_BASE_NS)
> @@ -837,7 +837,7 @@ void kvm_set_cpu_caps(void)
>  	 * kernel.  LFENCE_RDTSC was a Linux-defined synthetic feature long
>  	 * before AMD joined the bandwagon, e.g. LFENCE is serializing on most
>  	 * CPUs that support SSE2.  On CPUs that don't support AMD's leaf,
> -	 * kvm_cpu_cap_mask() will unfortunately drop the flag due to ANDing
> +	 * kvm_cpu_cap_init() will unfortunately drop the flag due to ANDing
>  	 * the mask with the raw host CPUID, and reporting support in AMD's
>  	 * leaf can make it easier for userspace to detect the feature.
>  	 */
> @@ -847,7 +847,7 @@ void kvm_set_cpu_caps(void)
>  		kvm_cpu_cap_set(X86_FEATURE_NULL_SEL_CLR_BASE);
>  	kvm_cpu_cap_set(X86_FEATURE_NO_SMM_CTL_MSR);
>  
> -	kvm_cpu_cap_mask(CPUID_C000_0001_EDX,
> +	kvm_cpu_cap_init(CPUID_C000_0001_EDX,
>  		F(XSTORE) | F(XSTORE_EN) | F(XCRYPT) | F(XCRYPT_EN) |
>  		F(ACE2) | F(ACE2_EN) | F(PHE) | F(PHE_EN) |
>  		F(PMM) | F(PMM_EN)

Hi,

Not really sure if we need this patch, I see that this patch helped
with renaming things, but IMHO it can be squashed with the relevant patches.

But anyway,

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


