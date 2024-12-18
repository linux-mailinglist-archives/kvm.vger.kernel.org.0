Return-Path: <kvm+bounces-34025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B2EB89F5C23
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 02:15:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CFBDC163B03
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 01:15:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5200435953;
	Wed, 18 Dec 2024 01:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hbpBDTXC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F071F5E6
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 01:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734484532; cv=none; b=lEJgVxm3jxQNP7TI4dJYbfmZzhtdNgYQip95MAXxFdL2nYRDEHkY3ju4ItFs38W40s5uph0IsCA1j+ZLTfRJh+HaeEtiI81mrR4JC1uctxQwwImkNy92hEFTNZxIuWbI1/t9q8+73J+jjsW83ng9n5mm2UsDyxw3YuMjMSI5l5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734484532; c=relaxed/simple;
	bh=cg5m4Yn8xKF7kjEkXzIx+87NZL00c/zqLPKF34nJudI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GZkkqBv6A/oVQRTnmVyKNdZ41cbS7cx/JMYeGpOUhCoCKbuFq/J61UDNWOGcd8ibdJ9E30WbRCukchj1HxJ/wtgp2qoHAXQ/CbcfP+uejiYbeyb0Dw5jdRR11Tkm5lQr64+G3s0wiuYoOwlwq5vxDEk+bvc3DcSKSBRxawGgkiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hbpBDTXC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734484529;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u1dQqcIf6SlIURxsmmuuJ5mwQlxUQiNbm/exJZubZvI=;
	b=hbpBDTXCpbpOAcQG9g1ZE6ZZ2uESIqPiUxJZzR7D8p9+/VtkzLE3w7HgFoE8is0qTv+gin
	WdbU1ufl8Zmd+e03ZCMO2MGqQtk9JCMgJOdV5PiyAHFygkTuCh18Oy9g1dwLYqkT+H4WzG
	HQl4rfIyPN1zP03BQEmv22wTPztIihY=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-Jei9lKwvNb6ONN5mAI4IiA-1; Tue, 17 Dec 2024 20:15:27 -0500
X-MC-Unique: Jei9lKwvNb6ONN5mAI4IiA-1
X-Mimecast-MFC-AGG-ID: Jei9lKwvNb6ONN5mAI4IiA
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-844e9b92401so832877339f.1
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 17:15:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734484527; x=1735089327;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u1dQqcIf6SlIURxsmmuuJ5mwQlxUQiNbm/exJZubZvI=;
        b=OK6xlKLwty0woDl5Q7siTwIcgeAxKGfCVEzOvDuupa72dVF5DBXn0XeeOe3KlVvXDI
         0ycTVNn7I6FLT4HLgOc32WwOxqo4gwp3XrhIPGZyBQV8J5hf/xyV5ag0Emu0Y3cbz/BM
         DLdUyjhfv/kGs7OvbY1ChoeV6PT37WidvxAHLlFTBGXqKoFWuMS+byLytwb5CKG0dTZ8
         YnaFyInBug9LgywlW6ammeflC4+unjRXAOBdX2zBN+lCyYNDgBQxSPNvKq2R+PLBmQnu
         +3vWPXGXQiW/VNGp6dgdz6JEv4etKIypzclGwbJ97OANlZjr2NrbZuu8a2HeQ3pLbAdP
         i1og==
X-Gm-Message-State: AOJu0YzWCP1k9wRxzT4uxVHJwnxdEnqTCIkdQZyAQCRwXpgOmgQAYqDj
	p2H/H/mSFyG51oVWC9WdB4KHYJzLXoASG2+drtOSnjCtCL/JcdWJAJ89nuLZ0Ed+PDHDHvqe39U
	p6aT5MAsD0EpZc63Bm7mZ4OWT/23nr9NU71irH2E/w6KJ9atVVg==
X-Gm-Gg: ASbGncturshdLkOXPT0Q0cmI4I5a5PBeGKXpL84Xuos/HkJ98QiAzR5vLG2DLa+Jhbp
	Ag95H71bIab9VWhuQeeqTc1/RMGfX0/kHXuljhGjscfhjLgC3m3+LgfABjkiF7y3ygl4B4Uj3ZZ
	GkEpELZzu5Vd31IN+7zIbgVO6ETWTSgqgvkrbRqQvJoExvZxiPxrJ+t1fDt1fKF8cHJiRu31+p1
	JuaXyFHya8wEGMk71KyZbTD8Tbg2mJdez/FTdXqN4v9/ZXekHIoZhfq
X-Received: by 2002:a05:6602:3fc1:b0:844:cb1f:bbf5 with SMTP id ca18e2360f4ac-8475860c2e0mr102141639f.15.1734484527028;
        Tue, 17 Dec 2024 17:15:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGfIw1wzMQ/SmXWoHldxrINtmXoJfQdhDCobRyzD+3Ns0TsaYxN1wYEpLmBcicwQg0Y9brFUQ==
X-Received: by 2002:a05:6602:3fc1:b0:844:cb1f:bbf5 with SMTP id ca18e2360f4ac-8475860c2e0mr102138939f.15.1734484526596;
        Tue, 17 Dec 2024 17:15:26 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e5e32a33c2sm1999175173.109.2024.12.17.17.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 17:15:26 -0800 (PST)
Message-ID: <4e346e991e36bf4fbd7411c8f634c8476f8f3d31.camel@redhat.com>
Subject: Re: [PATCH v3 57/57] KVM: x86: Use only local variables (no
 bitmask) to init kvm_cpu_caps
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>, Jarkko
 Sakkinen <jarkko@kernel.org>
Cc: kvm@vger.kernel.org, linux-sgx@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
 Xiaoyao Li <xiaoyao.li@intel.com>, Kechen Lu <kechenl@nvidia.com>, Oliver
 Upton <oliver.upton@linux.dev>,  Binbin Wu <binbin.wu@linux.intel.com>,
 Yang Weijiang <weijiang.yang@intel.com>, Robert Hoo
 <robert.hoo.linux@gmail.com>
Date: Tue, 17 Dec 2024 20:15:24 -0500
In-Reply-To: <20241128013424.4096668-58-seanjc@google.com>
References: <20241128013424.4096668-1-seanjc@google.com>
	 <20241128013424.4096668-58-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2024-11-27 at 17:34 -0800, Sean Christopherson wrote:
> Refactor the kvm_cpu_cap_init() macro magic to collect supported features
> in a local variable instead of passing them to the macro as a "mask".  As
> pointed out by Maxim, relying on macros to "return" a value and set local
> variables is surprising, as the bitwise-OR logic suggests the macros are
> pure, i.e. have no side effects.
> 
> Ideally, the feature initializers would have zero side effects, e.g. would
> take local variables as params, but there isn't a sane way to do so
> without either sacrificing the various compile-time assertions (basically
> a non-starter), or passing at least one variable, e.g. a struct, to each
> macro usage (adds a lot of noise and boilerplate code).
> 
> Opportunistically force callers to emit a trailing comma by intentionally
> omitting a semicolon after invoking the feature initializers.  Forcing a
> trailing comma isotales futures changes to a single line, i.e. doesn't
> cause churn for unrelated features/lines when adding/removing/modifying a
> feature.
> 
> No functional change intended.
> 
> Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 541 ++++++++++++++++++++++---------------------
>  1 file changed, 273 insertions(+), 268 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index e03154b9833f..572dfa7e206e 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -661,7 +661,7 @@ static __always_inline u32 raw_cpuid_get(struct cpuid_reg cpuid)
>   * capabilities as well as raw CPUID.  For KVM-defined leafs, consult only raw
>   * CPUID, as KVM is the one and only authority (in the kernel).
>   */
> -#define kvm_cpu_cap_init(leaf, mask)					\
> +#define kvm_cpu_cap_init(leaf, feature_initializers...)			\
>  do {									\
>  	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);	\
>  	const u32 __maybe_unused kvm_cpu_cap_init_in_progress = leaf;	\
> @@ -669,8 +669,11 @@ do {									\
>  	u32 kvm_cpu_cap_passthrough = 0;				\
>  	u32 kvm_cpu_cap_synthesized = 0;				\
>  	u32 kvm_cpu_cap_emulated = 0;					\
> +	u32 kvm_cpu_cap_features = 0;					\
>  									\
> -	kvm_cpu_caps[leaf] = (mask);					\
> +	feature_initializers						\
> +									\
> +	kvm_cpu_caps[leaf] = kvm_cpu_cap_features;			\
>  									\
>  	if (leaf < NCAPINTS)						\
>  		kvm_cpu_caps[leaf] &= kernel_cpu_caps[leaf];		\
> @@ -696,7 +699,7 @@ do {									\
>  #define F(name)							\
>  ({								\
>  	KVM_VALIDATE_CPU_CAP_USAGE(name);			\
> -	feature_bit(name);					\
> +	kvm_cpu_cap_features |= feature_bit(name);		\
>  })
>  
>  /* Scattered Flag - For features that are scattered by cpufeatures.h. */
> @@ -704,14 +707,16 @@ do {									\
>  ({								\
>  	BUILD_BUG_ON(X86_FEATURE_##name >= MAX_CPU_FEATURES);	\
>  	KVM_VALIDATE_CPU_CAP_USAGE(name);			\
> -	(boot_cpu_has(X86_FEATURE_##name) ? F(name) : 0);	\
> +	if (boot_cpu_has(X86_FEATURE_##name))			\
> +		F(name);					\
>  })
>  
>  /* Features that KVM supports only on 64-bit kernels. */
>  #define X86_64_F(name)						\
>  ({								\
>  	KVM_VALIDATE_CPU_CAP_USAGE(name);			\
> -	(IS_ENABLED(CONFIG_X86_64) ? F(name) : 0);		\
> +	if (IS_ENABLED(CONFIG_X86_64))				\
> +		F(name);					\
>  })
>  
>  /*
> @@ -720,7 +725,7 @@ do {									\
>   */
>  #define EMULATED_F(name)					\
>  ({								\
> -	kvm_cpu_cap_emulated |= F(name);			\
> +	kvm_cpu_cap_emulated |= feature_bit(name);		\
>  	F(name);						\
>  })
>  
> @@ -731,7 +736,7 @@ do {									\
>   */
>  #define SYNTHESIZED_F(name)					\
>  ({								\
> -	kvm_cpu_cap_synthesized |= F(name);			\
> +	kvm_cpu_cap_synthesized |= feature_bit(name);		\
>  	F(name);						\
>  })
>  
> @@ -743,7 +748,7 @@ do {									\
>   */
>  #define PASSTHROUGH_F(name)					\
>  ({								\
> -	kvm_cpu_cap_passthrough |= F(name);			\
> +	kvm_cpu_cap_passthrough |= feature_bit(name);		\
>  	F(name);						\
>  })
>  
> @@ -755,7 +760,7 @@ do {									\
>  ({										\
>  	BUILD_BUG_ON(__feature_leaf(X86_FEATURE_##name) != CPUID_1_EDX);	\
>  	BUILD_BUG_ON(kvm_cpu_cap_init_in_progress != CPUID_8000_0001_EDX);	\
> -	feature_bit(name);							\
> +	kvm_cpu_cap_features |= feature_bit(name);				\
>  })
>  
>  /*
> @@ -765,7 +770,6 @@ do {									\
>  #define VENDOR_F(name)						\
>  ({								\
>  	KVM_VALIDATE_CPU_CAP_USAGE(name);			\
> -	0;							\
>  })
>  
>  /*
> @@ -775,7 +779,6 @@ do {									\
>  #define RUNTIME_F(name)						\
>  ({								\
>  	KVM_VALIDATE_CPU_CAP_USAGE(name);			\
> -	0;							\
>  })
>  
>  /*
> @@ -795,126 +798,128 @@ void kvm_set_cpu_caps(void)
>  		     sizeof(boot_cpu_data.x86_capability));
>  
>  	kvm_cpu_cap_init(CPUID_1_ECX,
> -		F(XMM3) |
> -		F(PCLMULQDQ) |
> -		VENDOR_F(DTES64) |
> +		F(XMM3),
> +		F(PCLMULQDQ),
> +		VENDOR_F(DTES64),
>  		/*
>  		 * NOTE: MONITOR (and MWAIT) are emulated as NOP, but *not*
>  		 * advertised to guests via CPUID!  MWAIT is also technically a
>  		 * runtime flag thanks to IA32_MISC_ENABLES; mark it as such so
>  		 * that KVM is aware that it's a known, unadvertised flag.
>  		 */
> -		RUNTIME_F(MWAIT) |
> -		VENDOR_F(VMX) |
> -		0 /* DS-CPL, SMX, EST */ |
> -		0 /* TM2 */ |
> -		F(SSSE3) |
> -		0 /* CNXT-ID */ |
> -		0 /* Reserved */ |
> -		F(FMA) |
> -		F(CX16) |
> -		0 /* xTPR Update */ |
> -		F(PDCM) |
> -		F(PCID) |
> -		0 /* Reserved, DCA */ |
> -		F(XMM4_1) |
> -		F(XMM4_2) |
> -		EMULATED_F(X2APIC) |
> -		F(MOVBE) |
> -		F(POPCNT) |
> -		EMULATED_F(TSC_DEADLINE_TIMER) |
> -		F(AES) |
> -		F(XSAVE) |
> -		RUNTIME_F(OSXSAVE) |
> -		F(AVX) |
> -		F(F16C) |
> -		F(RDRAND) |
> -		EMULATED_F(HYPERVISOR)
> +		RUNTIME_F(MWAIT),
> +		/* DS-CPL */
> +		VENDOR_F(VMX),
> +		/* SMX, EST */
> +		/* TM2 */
> +		F(SSSE3),
> +		/* CNXT-ID */
> +		/* Reserved */
> +		F(FMA),
> +		F(CX16),
> +		/* xTPR Update */
> +		F(PDCM),
> +		F(PCID),
> +		/* Reserved, DCA */
> +		F(XMM4_1),
> +		F(XMM4_2),
> +		EMULATED_F(X2APIC),
> +		F(MOVBE),
> +		F(POPCNT),
> +		EMULATED_F(TSC_DEADLINE_TIMER),
> +		F(AES),
> +		F(XSAVE),
> +		RUNTIME_F(OSXSAVE),
> +		F(AVX),
> +		F(F16C),
> +		F(RDRAND),
> +		EMULATED_F(HYPERVISOR),
>  	);
>  
>  	kvm_cpu_cap_init(CPUID_1_EDX,
> -		F(FPU) |
> -		F(VME) |
> -		F(DE) |
> -		F(PSE) |
> -		F(TSC) |
> -		F(MSR) |
> -		F(PAE) |
> -		F(MCE) |
> -		F(CX8) |
> -		F(APIC) |
> -		0 /* Reserved */ |
> -		F(SEP) |
> -		F(MTRR) |
> -		F(PGE) |
> -		F(MCA) |
> -		F(CMOV) |
> -		F(PAT) |
> -		F(PSE36) |
> -		0 /* PSN */ |
> -		F(CLFLUSH) |
> -		0 /* Reserved */ |
> -		VENDOR_F(DS) |
> -		0 /* ACPI */ |
> -		F(MMX) |
> -		F(FXSR) |
> -		F(XMM) |
> -		F(XMM2) |
> -		F(SELFSNOOP) |
> -		0 /* HTT, TM, Reserved, PBE */
> +		F(FPU),
> +		F(VME),
> +		F(DE),
> +		F(PSE),
> +		F(TSC),
> +		F(MSR),
> +		F(PAE),
> +		F(MCE),
> +		F(CX8),
> +		F(APIC),
> +		/* Reserved */
> +		F(SEP),
> +		F(MTRR),
> +		F(PGE),
> +		F(MCA),
> +		F(CMOV),
> +		F(PAT),
> +		F(PSE36),
> +		/* PSN */
> +		F(CLFLUSH),
> +		/* Reserved */
> +		VENDOR_F(DS),
> +		/* ACPI */
> +		F(MMX),
> +		F(FXSR),
> +		F(XMM),
> +		F(XMM2),
> +		F(SELFSNOOP),
> +		/* HTT, TM, Reserved, PBE */
>  	);
>  
>  	kvm_cpu_cap_init(CPUID_7_0_EBX,
> -		F(FSGSBASE) |
> -		EMULATED_F(TSC_ADJUST) |
> -		F(SGX) |
> -		F(BMI1) |
> -		F(HLE) |
> -		F(AVX2) |
> -		F(FDP_EXCPTN_ONLY) |
> -		F(SMEP) |
> -		F(BMI2) |
> -		F(ERMS) |
> -		F(INVPCID) |
> -		F(RTM) |
> -		F(ZERO_FCS_FDS) |
> -		VENDOR_F(MPX) |
> -		F(AVX512F) |
> -		F(AVX512DQ) |
> -		F(RDSEED) |
> -		F(ADX) |
> -		F(SMAP) |
> -		F(AVX512IFMA) |
> -		F(CLFLUSHOPT) |
> -		F(CLWB) |
> -		VENDOR_F(INTEL_PT) |
> -		F(AVX512PF) |
> -		F(AVX512ER) |
> -		F(AVX512CD) |
> -		F(SHA_NI) |
> -		F(AVX512BW) |
> -		F(AVX512VL));
> +		F(FSGSBASE),
> +		EMULATED_F(TSC_ADJUST),
> +		F(SGX),
> +		F(BMI1),
> +		F(HLE),
> +		F(AVX2),
> +		F(FDP_EXCPTN_ONLY),
> +		F(SMEP),
> +		F(BMI2),
> +		F(ERMS),
> +		F(INVPCID),
> +		F(RTM),
> +		F(ZERO_FCS_FDS),
> +		VENDOR_F(MPX),
> +		F(AVX512F),
> +		F(AVX512DQ),
> +		F(RDSEED),
> +		F(ADX),
> +		F(SMAP),
> +		F(AVX512IFMA),
> +		F(CLFLUSHOPT),
> +		F(CLWB),
> +		VENDOR_F(INTEL_PT),
> +		F(AVX512PF),
> +		F(AVX512ER),
> +		F(AVX512CD),
> +		F(SHA_NI),
> +		F(AVX512BW),
> +		F(AVX512VL),
> +	);
>  
>  	kvm_cpu_cap_init(CPUID_7_ECX,
> -		F(AVX512VBMI) |
> -		PASSTHROUGH_F(LA57) |
> -		F(PKU) |
> -		RUNTIME_F(OSPKE) |
> -		F(RDPID) |
> -		F(AVX512_VPOPCNTDQ) |
> -		F(UMIP) |
> -		F(AVX512_VBMI2) |
> -		F(GFNI) |
> -		F(VAES) |
> -		F(VPCLMULQDQ) |
> -		F(AVX512_VNNI) |
> -		F(AVX512_BITALG) |
> -		F(CLDEMOTE) |
> -		F(MOVDIRI) |
> -		F(MOVDIR64B) |
> -		VENDOR_F(WAITPKG) |
> -		F(SGX_LC) |
> -		F(BUS_LOCK_DETECT)
> +		F(AVX512VBMI),
> +		PASSTHROUGH_F(LA57),
> +		F(PKU),
> +		RUNTIME_F(OSPKE),
> +		F(RDPID),
> +		F(AVX512_VPOPCNTDQ),
> +		F(UMIP),
> +		F(AVX512_VBMI2),
> +		F(GFNI),
> +		F(VAES),
> +		F(VPCLMULQDQ),
> +		F(AVX512_VNNI),
> +		F(AVX512_BITALG),
> +		F(CLDEMOTE),
> +		F(MOVDIRI),
> +		F(MOVDIR64B),
> +		VENDOR_F(WAITPKG),
> +		F(SGX_LC),
> +		F(BUS_LOCK_DETECT),
>  	);
>  
>  	/*
> @@ -925,22 +930,22 @@ void kvm_set_cpu_caps(void)
>  		kvm_cpu_cap_clear(X86_FEATURE_PKU);
>  
>  	kvm_cpu_cap_init(CPUID_7_EDX,
> -		F(AVX512_4VNNIW) |
> -		F(AVX512_4FMAPS) |
> -		F(SPEC_CTRL) |
> -		F(SPEC_CTRL_SSBD) |
> -		EMULATED_F(ARCH_CAPABILITIES) |
> -		F(INTEL_STIBP) |
> -		F(MD_CLEAR) |
> -		F(AVX512_VP2INTERSECT) |
> -		F(FSRM) |
> -		F(SERIALIZE) |
> -		F(TSXLDTRK) |
> -		F(AVX512_FP16) |
> -		F(AMX_TILE) |
> -		F(AMX_INT8) |
> -		F(AMX_BF16) |
> -		F(FLUSH_L1D)
> +		F(AVX512_4VNNIW),
> +		F(AVX512_4FMAPS),
> +		F(SPEC_CTRL),
> +		F(SPEC_CTRL_SSBD),
> +		EMULATED_F(ARCH_CAPABILITIES),
> +		F(INTEL_STIBP),
> +		F(MD_CLEAR),
> +		F(AVX512_VP2INTERSECT),
> +		F(FSRM),
> +		F(SERIALIZE),
> +		F(TSXLDTRK),
> +		F(AVX512_FP16),
> +		F(AMX_TILE),
> +		F(AMX_INT8),
> +		F(AMX_BF16),
> +		F(FLUSH_L1D),
>  	);
>  
>  	if (boot_cpu_has(X86_FEATURE_AMD_IBPB_RET) &&
> @@ -953,132 +958,132 @@ void kvm_set_cpu_caps(void)
>  		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
>  
>  	kvm_cpu_cap_init(CPUID_7_1_EAX,
> -		F(SHA512) |
> -		F(SM3) |
> -		F(SM4) |
> -		F(AVX_VNNI) |
> -		F(AVX512_BF16) |
> -		F(CMPCCXADD) |
> -		F(FZRM) |
> -		F(FSRS) |
> -		F(FSRC) |
> -		F(AMX_FP16) |
> -		F(AVX_IFMA) |
> -		F(LAM)
> +		F(SHA512),
> +		F(SM3),
> +		F(SM4),
> +		F(AVX_VNNI),
> +		F(AVX512_BF16),
> +		F(CMPCCXADD),
> +		F(FZRM),
> +		F(FSRS),
> +		F(FSRC),
> +		F(AMX_FP16),
> +		F(AVX_IFMA),
> +		F(LAM),
>  	);
>  
>  	kvm_cpu_cap_init(CPUID_7_1_EDX,
> -		F(AVX_VNNI_INT8) |
> -		F(AVX_NE_CONVERT) |
> -		F(AMX_COMPLEX) |
> -		F(AVX_VNNI_INT16) |
> -		F(PREFETCHITI) |
> -		F(AVX10)
> +		F(AVX_VNNI_INT8),
> +		F(AVX_NE_CONVERT),
> +		F(AMX_COMPLEX),
> +		F(AVX_VNNI_INT16),
> +		F(PREFETCHITI),
> +		F(AVX10),
>  	);
>  
>  	kvm_cpu_cap_init(CPUID_7_2_EDX,
> -		F(INTEL_PSFD) |
> -		F(IPRED_CTRL) |
> -		F(RRSBA_CTRL) |
> -		F(DDPD_U) |
> -		F(BHI_CTRL) |
> -		F(MCDT_NO)
> +		F(INTEL_PSFD),
> +		F(IPRED_CTRL),
> +		F(RRSBA_CTRL),
> +		F(DDPD_U),
> +		F(BHI_CTRL),
> +		F(MCDT_NO),
>  	);
>  
>  	kvm_cpu_cap_init(CPUID_D_1_EAX,
> -		F(XSAVEOPT) |
> -		F(XSAVEC) |
> -		F(XGETBV1) |
> -		F(XSAVES) |
> -		X86_64_F(XFD)
> +		F(XSAVEOPT),
> +		F(XSAVEC),
> +		F(XGETBV1),
> +		F(XSAVES),
> +		X86_64_F(XFD),
>  	);
>  
>  	kvm_cpu_cap_init(CPUID_12_EAX,
> -		SCATTERED_F(SGX1) |
> -		SCATTERED_F(SGX2) |
> -		SCATTERED_F(SGX_EDECCSSA)
> +		SCATTERED_F(SGX1),
> +		SCATTERED_F(SGX2),
> +		SCATTERED_F(SGX_EDECCSSA),
>  	);
>  
>  	kvm_cpu_cap_init(CPUID_24_0_EBX,
> -		F(AVX10_128) |
> -		F(AVX10_256) |
> -		F(AVX10_512)
> +		F(AVX10_128),
> +		F(AVX10_256),
> +		F(AVX10_512),
>  	);
>  
>  	kvm_cpu_cap_init(CPUID_8000_0001_ECX,
> -		F(LAHF_LM) |
> -		F(CMP_LEGACY) |
> -		VENDOR_F(SVM) |
> -		0 /* ExtApicSpace */ |
> -		F(CR8_LEGACY) |
> -		F(ABM) |
> -		F(SSE4A) |
> -		F(MISALIGNSSE) |
> -		F(3DNOWPREFETCH) |
> -		F(OSVW) |
> -		0 /* IBS */ |
> -		F(XOP) |
> -		0 /* SKINIT, WDT, LWP */ |
> -		F(FMA4) |
> -		F(TBM) |
> -		F(TOPOEXT) |
> -		VENDOR_F(PERFCTR_CORE)
> +		F(LAHF_LM),
> +		F(CMP_LEGACY),
> +		VENDOR_F(SVM),
> +		/* ExtApicSpace */
> +		F(CR8_LEGACY),
> +		F(ABM),
> +		F(SSE4A),
> +		F(MISALIGNSSE),
> +		F(3DNOWPREFETCH),
> +		F(OSVW),
> +		/* IBS */
> +		F(XOP),
> +		/* SKINIT, WDT, LWP */
> +		F(FMA4),
> +		F(TBM),
> +		F(TOPOEXT),
> +		VENDOR_F(PERFCTR_CORE),
>  	);
>  
>  	kvm_cpu_cap_init(CPUID_8000_0001_EDX,
> -		ALIASED_1_EDX_F(FPU) |
> -		ALIASED_1_EDX_F(VME) |
> -		ALIASED_1_EDX_F(DE) |
> -		ALIASED_1_EDX_F(PSE) |
> -		ALIASED_1_EDX_F(TSC) |
> -		ALIASED_1_EDX_F(MSR) |
> -		ALIASED_1_EDX_F(PAE) |
> -		ALIASED_1_EDX_F(MCE) |
> -		ALIASED_1_EDX_F(CX8) |
> -		ALIASED_1_EDX_F(APIC) |
> -		0 /* Reserved */ |
> -		F(SYSCALL) |
> -		ALIASED_1_EDX_F(MTRR) |
> -		ALIASED_1_EDX_F(PGE) |
> -		ALIASED_1_EDX_F(MCA) |
> -		ALIASED_1_EDX_F(CMOV) |
> -		ALIASED_1_EDX_F(PAT) |
> -		ALIASED_1_EDX_F(PSE36) |
> -		0 /* Reserved */ |
> -		F(NX) |
> -		0 /* Reserved */ |
> -		F(MMXEXT) |
> -		ALIASED_1_EDX_F(MMX) |
> -		ALIASED_1_EDX_F(FXSR) |
> -		F(FXSR_OPT) |
> -		X86_64_F(GBPAGES) |
> -		F(RDTSCP) |
> -		0 /* Reserved */ |
> -		X86_64_F(LM) |
> -		F(3DNOWEXT) |
> -		F(3DNOW)
> +		ALIASED_1_EDX_F(FPU),
> +		ALIASED_1_EDX_F(VME),
> +		ALIASED_1_EDX_F(DE),
> +		ALIASED_1_EDX_F(PSE),
> +		ALIASED_1_EDX_F(TSC),
> +		ALIASED_1_EDX_F(MSR),
> +		ALIASED_1_EDX_F(PAE),
> +		ALIASED_1_EDX_F(MCE),
> +		ALIASED_1_EDX_F(CX8),
> +		ALIASED_1_EDX_F(APIC),
> +		/* Reserved */
> +		F(SYSCALL),
> +		ALIASED_1_EDX_F(MTRR),
> +		ALIASED_1_EDX_F(PGE),
> +		ALIASED_1_EDX_F(MCA),
> +		ALIASED_1_EDX_F(CMOV),
> +		ALIASED_1_EDX_F(PAT),
> +		ALIASED_1_EDX_F(PSE36),
> +		/* Reserved */
> +		F(NX),
> +		/* Reserved */
> +		F(MMXEXT),
> +		ALIASED_1_EDX_F(MMX),
> +		ALIASED_1_EDX_F(FXSR),
> +		F(FXSR_OPT),
> +		X86_64_F(GBPAGES),
> +		F(RDTSCP),
> +		/* Reserved */
> +		X86_64_F(LM),
> +		F(3DNOWEXT),
> +		F(3DNOW),
>  	);
>  
>  	if (!tdp_enabled && IS_ENABLED(CONFIG_X86_64))
>  		kvm_cpu_cap_set(X86_FEATURE_GBPAGES);
>  
>  	kvm_cpu_cap_init(CPUID_8000_0007_EDX,
> -		SCATTERED_F(CONSTANT_TSC)
> +		SCATTERED_F(CONSTANT_TSC),
>  	);
>  
>  	kvm_cpu_cap_init(CPUID_8000_0008_EBX,
> -		F(CLZERO) |
> -		F(XSAVEERPTR) |
> -		F(WBNOINVD) |
> -		F(AMD_IBPB) |
> -		F(AMD_IBRS) |
> -		F(AMD_SSBD) |
> -		F(VIRT_SSBD) |
> -		F(AMD_SSB_NO) |
> -		F(AMD_STIBP) |
> -		F(AMD_STIBP_ALWAYS_ON) |
> -		F(AMD_PSFD) |
> -		F(AMD_IBPB_RET)
> +		F(CLZERO),
> +		F(XSAVEERPTR),
> +		F(WBNOINVD),
> +		F(AMD_IBPB),
> +		F(AMD_IBRS),
> +		F(AMD_SSBD),
> +		F(VIRT_SSBD),
> +		F(AMD_SSB_NO),
> +		F(AMD_STIBP),
> +		F(AMD_STIBP_ALWAYS_ON),
> +		F(AMD_PSFD),
> +		F(AMD_IBPB_RET),
>  	);
>  
>  	/*
> @@ -1110,30 +1115,30 @@ void kvm_set_cpu_caps(void)
>  
>  	/* All SVM features required additional vendor module enabling. */
>  	kvm_cpu_cap_init(CPUID_8000_000A_EDX,
> -		VENDOR_F(NPT) |
> -		VENDOR_F(VMCBCLEAN) |
> -		VENDOR_F(FLUSHBYASID) |
> -		VENDOR_F(NRIPS) |
> -		VENDOR_F(TSCRATEMSR) |
> -		VENDOR_F(V_VMSAVE_VMLOAD) |
> -		VENDOR_F(LBRV) |
> -		VENDOR_F(PAUSEFILTER) |
> -		VENDOR_F(PFTHRESHOLD) |
> -		VENDOR_F(VGIF) |
> -		VENDOR_F(VNMI) |
> -		VENDOR_F(SVME_ADDR_CHK)
> +		VENDOR_F(NPT),
> +		VENDOR_F(VMCBCLEAN),
> +		VENDOR_F(FLUSHBYASID),
> +		VENDOR_F(NRIPS),
> +		VENDOR_F(TSCRATEMSR),
> +		VENDOR_F(V_VMSAVE_VMLOAD),
> +		VENDOR_F(LBRV),
> +		VENDOR_F(PAUSEFILTER),
> +		VENDOR_F(PFTHRESHOLD),
> +		VENDOR_F(VGIF),
> +		VENDOR_F(VNMI),
> +		VENDOR_F(SVME_ADDR_CHK),
>  	);
>  
>  	kvm_cpu_cap_init(CPUID_8000_001F_EAX,
> -		VENDOR_F(SME) |
> -		VENDOR_F(SEV) |
> -		0 /* VM_PAGE_FLUSH */ |
> -		VENDOR_F(SEV_ES) |
> -		F(SME_COHERENT)
> +		VENDOR_F(SME),
> +		VENDOR_F(SEV),
> +		/* VM_PAGE_FLUSH */
> +		VENDOR_F(SEV_ES),
> +		F(SME_COHERENT),
>  	);
>  
>  	kvm_cpu_cap_init(CPUID_8000_0021_EAX,
> -		F(NO_NESTED_DATA_BP) |
> +		F(NO_NESTED_DATA_BP),
>  		/*
>  		 * Synthesize "LFENCE is serializing" into the AMD-defined entry
>  		 * in KVM's supported CPUID, i.e. if the feature is reported as
> @@ -1144,36 +1149,36 @@ void kvm_set_cpu_caps(void)
>  		 * CPUID will drop the flags, and reporting support in AMD's
>  		 * leaf can make it easier for userspace to detect the feature.
>  		 */
> -		SYNTHESIZED_F(LFENCE_RDTSC) |
> -		0 /* SmmPgCfgLock */ |
> -		F(NULL_SEL_CLR_BASE) |
> -		F(AUTOIBRS) |
> -		EMULATED_F(NO_SMM_CTL_MSR) |
> -		0 /* PrefetchCtlMsr */ |
> -		F(WRMSR_XX_BASE_NS) |
> -		SYNTHESIZED_F(SBPB) |
> -		SYNTHESIZED_F(IBPB_BRTYPE) |
> -		SYNTHESIZED_F(SRSO_NO)
> +		SYNTHESIZED_F(LFENCE_RDTSC),
> +		/* SmmPgCfgLock */
> +		F(NULL_SEL_CLR_BASE),
> +		F(AUTOIBRS),
> +		EMULATED_F(NO_SMM_CTL_MSR),
> +		/* PrefetchCtlMsr */
> +		F(WRMSR_XX_BASE_NS),
> +		SYNTHESIZED_F(SBPB),
> +		SYNTHESIZED_F(IBPB_BRTYPE),
> +		SYNTHESIZED_F(SRSO_NO),
>  	);
>  
>  	kvm_cpu_cap_init(CPUID_8000_0022_EAX,
> -		F(PERFMON_V2)
> +		F(PERFMON_V2),
>  	);
>  
>  	if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
>  		kvm_cpu_cap_set(X86_FEATURE_NULL_SEL_CLR_BASE);
>  
>  	kvm_cpu_cap_init(CPUID_C000_0001_EDX,
> -		F(XSTORE) |
> -		F(XSTORE_EN) |
> -		F(XCRYPT) |
> -		F(XCRYPT_EN) |
> -		F(ACE2) |
> -		F(ACE2_EN) |
> -		F(PHE) |
> -		F(PHE_EN) |
> -		F(PMM) |
> -		F(PMM_EN)
> +		F(XSTORE),
> +		F(XSTORE_EN),
> +		F(XCRYPT),
> +		F(XCRYPT_EN),
> +		F(ACE2),
> +		F(ACE2_EN),
> +		F(PHE),
> +		F(PHE_EN),
> +		F(PMM),
> +		F(PMM_EN),
>  	);
>  
>  	/*


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>




