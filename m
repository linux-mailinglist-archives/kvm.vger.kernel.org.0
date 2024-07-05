Return-Path: <kvm+bounces-21000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FC88927FFA
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 03:59:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 106FE1F21C72
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 01:59:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 629F7171A4;
	Fri,  5 Jul 2024 01:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D37nZ52Y"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89E428F3
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 01:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720144768; cv=none; b=IE983AUGA8AFwpJwpueeF4VUOgtakV/QTPRhfh7+iFe4woKDZAwhcshWKdQq+ZuTu7XBqsjSFOMYIjyXpCDEs7cJ2GaVynBLFmcfIv5vRX+Kxxmg6NvznDBmbSzD5cESXtVJEFUK6KOskavhd4N6qrKkMYHX/me419drwqxODpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720144768; c=relaxed/simple;
	bh=P+x17QcK16TB+rC0FOa0slgWjBYCB8Oa0A/r8mSwWeo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=a4N8okQpjeS2Bk3PhdgOR++asvaqu8MqdDcdB2oDSS2n/P319LB/H4rya9sRhq8okk7RIEICGMZI3nqhSmQI3vw4u71oijWCRTah4tWdMIkqpEwapSHNNDsxfcy/WPq0tiCzG3nlzcWAFyW66C4aue9XvzWgxxts5WIMe5fNEkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D37nZ52Y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720144765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ywWiOICekOAx+dCgMXpZRql7l3Q+/B/WufxX1KJDlfQ=;
	b=D37nZ52Y0vtVOvAwObt8qnk9StAuEeMxf1iZMb6Mro3EM2zN/Hczh7U5Ebz7TxpuTSKdHR
	E+KNxI/9JtNivK4DUSAdaZG20jUJsmql/h/NulJcA4vILLPd30XjSnjx7ekaXyVwtIXC6u
	egTnNQ3IMctIY2VjEQGJ5PqUyg1tFpg=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-674-pS4zSXBQPkKe3zdOBOyE1Q-1; Thu, 04 Jul 2024 21:59:22 -0400
X-MC-Unique: pS4zSXBQPkKe3zdOBOyE1Q-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6b5ddfea466so13906776d6.3
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 18:59:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720144762; x=1720749562;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ywWiOICekOAx+dCgMXpZRql7l3Q+/B/WufxX1KJDlfQ=;
        b=NujzABPmhtOILSfkucPmRcicxSTGMuNZMOLk5pwg23hiZr0xGifyOLj4NUYzqGQ1X5
         RY3lhx8rFfblEr1LMrm9HfJLCYvbGo3XTDHD+ikBPQ3D63FGbHXNAVg27xdYxClh+lhF
         YQT4Ywy17wcTSnr0wJkPVsSCTQpJTuOWMIj97oOXeSvZNePxF1EvNKV9FYKu+n2jHucY
         0aIRWF7bsdbQI9uZXs9AYy0ytaQ7wcbTox3XmoXiswwUWx7YEVsj6XBfDBb0mGWKX4dK
         wShTG3gIiZqvajFjEw2nvssoop2kKdvqeerIWzgKU2qfJJA+PfxHUn07iJVVgAryUqz3
         ftqg==
X-Gm-Message-State: AOJu0Yw+DsoxVU9v85rmzPTP9O39V4+rvcaeX4Zl8R9mA4RQERAG6q7q
	bIBBwzKQ9qAQKFDiN4INmI86vh63nQ/oS3a+LYZP3eN797D0Dg3vCm/W0QCyw5K28w2vRThpBdA
	Pb2qCwFf5W9M03JZPH4X15m0VkjzTbla6Yw88/VHo6ikLg6Ud/A==
X-Received: by 2002:ad4:5bc7:0:b0:6b5:e77b:b76c with SMTP id 6a1803df08f44-6b5ed273f47mr38677316d6.58.1720144762125;
        Thu, 04 Jul 2024 18:59:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEYDVe42vr9bVRfx185vprKsIMhDKtzKOoKH98FmbaT5UY0VwKm+BwCPDy3yIEevrDuOMdXAA==
X-Received: by 2002:ad4:5bc7:0:b0:6b5:e77b:b76c with SMTP id 6a1803df08f44-6b5ed273f47mr38677116d6.58.1720144761794;
        Thu, 04 Jul 2024 18:59:21 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b59e5f262asm68845456d6.89.2024.07.04.18.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 18:59:21 -0700 (PDT)
Message-ID: <2e0f3fb63c810dd924907bccf9256f6f193b02ec.camel@redhat.com>
Subject: Re: [PATCH v2 26/49] KVM: x86: Add a macro to init CPUID features
 that KVM emulates in software
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 21:59:20 -0400
In-Reply-To: <20240517173926.965351-27-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-27-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2024-05-17 at 10:39 -0700, Sean Christopherson wrote:
> Now that kvm_cpu_cap_init() is a macro with its own scope, add EMUL_F() to
> OR-in features that KVM emulates in software, i.e. that don't depend on
> the feature being available in hardware.  The contained scope
> of kvm_cpu_cap_init() allows using a local variable to track the set of
> emulated leaves, which in addition to avoiding confusing and/or
> unnecessary variables, helps prevent misuse of EMUL_F().
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 36 +++++++++++++++++++++---------------
>  1 file changed, 21 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 1064e4d68718..33e3e77de1b7 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -94,6 +94,16 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
>  	F(name);						\
>  })
>  
> +/*
> + * Emulated Feature - For features that KVM emulates in software irrespective
> + * of host CPU/kernel support.
> + */
> +#define EMUL_F(name)						\
> +({								\
> +	kvm_cpu_cap_emulated |= F(name);			\
> +	F(name);						\
> +})

To me it feels more and more that this patch series doesn't go into the right direction.

How about we just abandon the whole concept of masks and instead just have a list of statements

Pretty much the opposite of the patch series I confess:


#define CAP_PASSTHOUGH		0x01
#define CAP_EMULATED		0x02
#define CAP_AMD_ALIASED		0x04 // for AMD aliased features
#define CAP_SCATTERED		0x08
#define CAP_X86_64		0x10 // supported only on 64 bit hypervisors
...


/* CPUID_1_ECX*/

				/* TMA is not passed though because: xyz*/
kvm_cpu_cap_init(TMA,           0);

kvm_cpu_cap_init(SSSE3,         CAP_PASSTHOUGH);
				/* CNXT_ID is not passed though because: xyz*/
kvm_cpu_cap_init(CNXT_ID,       0);
kvm_cpu_cap_init(RESERVED,      0);
kvm_cpu_cap_init(FMA,           CAP_PASSTHOUGH);
...
				/* KVM always emulates TSC_ADJUST */
kvm_cpu_cap_init(TSC_ADJUST,    CAP_EMULATED | CAP_SCATTERED);

...

/* CPUID_D_1_EAX*/
				/* XFD is disabled on 32 bit systems because: xyz*/
kvm_cpu_cap_init(XFD, 		CAP_PASSTHOUGH | CAP_X86_64)


'kvm_cpu_cap_init' can be a macro if needed to have the compile checks.

There are several advantages to this:

- more readability, plus if needed each statement can be amended with a comment.
- No weird hacks in 'F*' macros, which additionally eventually evaluate into a bit, which is confusing.
  In fact no need to even have them at all.
- No need to verify that bitmask belongs to a feature word.
- Merge friendly - each capability has its own line.

Disadvantages:

- Longer list - IMHO not a problem, since it is very easy to read / search
  and can have as much comments as needed.
  For example this is how the kernel lists the CPUID features and this list IMHO
  is very manageable.

- Slower - kvm_set_cpu_caps is called exactly once per KVM module load, thus
  performance is the last thing I would care about in this function.


Another note about this patch: It is somewhat confusing that EMUL_F just forces a feature in kvm caps,
regardless of CPU support, because KVM also has KVM_GET_EMULATED_CPUID and it has a different meaning.

Users can easily confuse the EMUL_F for something that sets a feature bit in the KVM_GET_EMULATED_CPUID.


Best regards,
	Maxim Levitsky



> +
>  /*
>   * Aliased Features - For features in 0x8000_0001.EDX that are duplicates of
>   * identical 0x1.EDX features, and thus are aliased from 0x1 to 0x8000_0001.
> @@ -649,6 +659,7 @@ do {									\
>  do {									\
>  	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);	\
>  	const u32 __maybe_unused kvm_cpu_cap_init_in_progress = leaf;	\
> +	u32 kvm_cpu_cap_emulated = 0;					\
>  									\
>  	if (leaf < NCAPINTS)						\
>  		kvm_cpu_caps[leaf] &= (mask);				\
> @@ -656,6 +667,7 @@ do {									\
>  		kvm_cpu_caps[leaf] = (mask);				\
>  									\
>  	kvm_cpu_caps[leaf] &= raw_cpuid_get(cpuid);			\
> +	kvm_cpu_caps[leaf] |= kvm_cpu_cap_emulated;			\
>  } while (0)
>  
>  /*
> @@ -684,12 +696,10 @@ void kvm_set_cpu_caps(void)
>  		0 /* TM2 */ | F(SSSE3) | 0 /* CNXT-ID */ | 0 /* Reserved */ |
>  		F(FMA) | F(CX16) | 0 /* xTPR Update */ | F(PDCM) |
>  		F(PCID) | 0 /* Reserved, DCA */ | F(XMM4_1) |
> -		F(XMM4_2) | F(X2APIC) | F(MOVBE) | F(POPCNT) |
> +		F(XMM4_2) | EMUL_F(X2APIC) | F(MOVBE) | F(POPCNT) |
>  		0 /* Reserved*/ | F(AES) | F(XSAVE) | 0 /* OSXSAVE */ | F(AVX) |
>  		F(F16C) | F(RDRAND)
>  	);
> -	/* KVM emulates x2apic in software irrespective of host support. */
> -	kvm_cpu_cap_set(X86_FEATURE_X2APIC);
>  
>  	kvm_cpu_cap_init(CPUID_1_EDX,
>  		F(FPU) | F(VME) | F(DE) | F(PSE) |
> @@ -703,13 +713,13 @@ void kvm_set_cpu_caps(void)
>  	);
>  
>  	kvm_cpu_cap_init(CPUID_7_0_EBX,
> -		F(FSGSBASE) | F(SGX) | F(BMI1) | F(HLE) | F(AVX2) |
> -		F(FDP_EXCPTN_ONLY) | F(SMEP) | F(BMI2) | F(ERMS) | F(INVPCID) |
> -		F(RTM) | F(ZERO_FCS_FDS) | 0 /*MPX*/ | F(AVX512F) |
> -		F(AVX512DQ) | F(RDSEED) | F(ADX) | F(SMAP) | F(AVX512IFMA) |
> -		F(CLFLUSHOPT) | F(CLWB) | 0 /*INTEL_PT*/ | F(AVX512PF) |
> -		F(AVX512ER) | F(AVX512CD) | F(SHA_NI) | F(AVX512BW) |
> -		F(AVX512VL));
> +		F(FSGSBASE) | EMUL_F(TSC_ADJUST) | F(SGX) | F(BMI1) | F(HLE) |
> +		F(AVX2) | F(FDP_EXCPTN_ONLY) | F(SMEP) | F(BMI2) | F(ERMS) |
> +		F(INVPCID) | F(RTM) | F(ZERO_FCS_FDS) | 0 /*MPX*/ |
> +		F(AVX512F) | F(AVX512DQ) | F(RDSEED) | F(ADX) | F(SMAP) |
> +		F(AVX512IFMA) | F(CLFLUSHOPT) | F(CLWB) | 0 /*INTEL_PT*/ |
> +		F(AVX512PF) | F(AVX512ER) | F(AVX512CD) | F(SHA_NI) |
> +		F(AVX512BW) | F(AVX512VL));
>  
>  	kvm_cpu_cap_init(CPUID_7_ECX,
>  		F(AVX512VBMI) | RAW_F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
> @@ -728,16 +738,12 @@ void kvm_set_cpu_caps(void)
>  
>  	kvm_cpu_cap_init(CPUID_7_EDX,
>  		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
> -		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
> +		F(SPEC_CTRL_SSBD) | EMUL_F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
>  		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
>  		F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16) |
>  		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16) | F(FLUSH_L1D)
>  	);
>  
> -	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
> -	kvm_cpu_cap_set(X86_FEATURE_TSC_ADJUST);
> -	kvm_cpu_cap_set(X86_FEATURE_ARCH_CAPABILITIES);
> -
>  	if (boot_cpu_has(X86_FEATURE_IBPB) && boot_cpu_has(X86_FEATURE_IBRS))
>  		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL);
>  	if (boot_cpu_has(X86_FEATURE_STIBP))





