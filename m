Return-Path: <kvm+bounces-32673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 42D3E9DB0F2
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:40:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0308D2811CC
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:40:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 534CF19DF8D;
	Thu, 28 Nov 2024 01:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OBaSTyxz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F216019ADB0
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757713; cv=none; b=r4ms2+cvtEnJ5W+EKJeupZiHb731a7EeF4yTxV/F7i4yg/1KrYEnwlNP6+1BNqsfJFaZ+12tIRrBmJXTdR9DO0mfskA+9LwPCchR9R7ryJTJJ2Ui2CmNnYOYh9tznGt4tafk4YF5L1vti3/u5T5tM2WjbY8cIUFWSJNRZVidAck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757713; c=relaxed/simple;
	bh=seDlWAgaw351ZxlqRBGal9NJH4Rs+9UMeeH8rzIVrU8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aDu9qyFSjWfoBXQE33e6+05ke1c+TXOPjI45PT8hbvKMhBvhOftkAOL2yMkR3Jv86HgMktKexFSFc5p0klM30Aybdu4mJ/zLb6ecKqnu4zV2EhsTDkge4X2BscdudPSLrB4iB0lXnoBvWyYId3CAUof3mDH+PXmJFpXvg0Pn8dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OBaSTyxz; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ea2dd29d16so345447a91.0
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757710; x=1733362510; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YKeQqfQm6Ijzea2XkvtvAsPalXlucbBmc84Ws6ehmPM=;
        b=OBaSTyxzmcBI+54I7uAkE+vzUA+7QDHby6Pk5K6875+2aK5XQJEGYgiJ0JecWIbvS5
         kiK9+n3Eq5xccLll5Gijmm1ifw8kdlykMhW+WJJVofcfBWsTsHxfUlAHrswq9eIbQnHI
         GGIpr4H+4rLsAMCoVZNRNojg/eQs80bYijteEXHDvQDQnSL8hi6wEXX3ZuQ7CHSkuri0
         IqL+oRFYyPF1UE98oUEdWls50oBnuUB2Ujqu+sLERPgkYcAgq01irZ8d/KHVDYHSrBnh
         FmQ7hoZVfAnQis4pt/BmbFpppFt8BcaCKICGcKKALKmepFQF650Xv0+98s1499bFUEnd
         fynQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757710; x=1733362510;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YKeQqfQm6Ijzea2XkvtvAsPalXlucbBmc84Ws6ehmPM=;
        b=Rwv/UE2xLwj0Am97vzjrRy7aSsbppAh6nXmc1mlcHK0XAvW2kB/n9RNosKOtWK6S20
         PLDNxO5Nzi5uiAiEOmhbtYWaL98PVqM0OyXRYgqlPaLVL8CnUX1/JgB1sLnwrWKasmSn
         WPPzKQthXLgBCc0wHHlbcp8x0fQs0Xi1Zg3rwMxB3TPONa6py3K0HiSpZGloAK78/+GT
         63gU0amPIRdo7VsanI3fCb6hjBodd8mmmuDqLYZSA60HHzcuq3srcPWOXRmNRWIF2hHR
         77yPjnpllkh8g+ritcKJRJysKCsfEwIYpblp96UnOxNw9VdlleKFX4yqp+hAkbduhMBd
         RGkQ==
X-Gm-Message-State: AOJu0YyLH53Vja7eYyYz5FxxsOoz6DjKW/rg2e8VbP49YjfLBtiW5kam
	QInBkmb+Q99mVN2zeQVBbldpVCcht8LdnVXipoOI9x116iS9RrzStIoNQUYLxf9Qf6GtX6No2XD
	2LA==
X-Google-Smtp-Source: AGHT+IEAKDv4Kqf9/0cMqKIOwPUSkZfoWa3P1o8BkHtA6oDGTCOvnfbmr+zhciKsFfTD9XyQy1tWw5DCFvs=
X-Received: from pjbpv18.prod.google.com ([2002:a17:90b:3c92:b0:2ea:4139:e72d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:38c5:b0:2ea:5823:c150
 with SMTP id 98e67ed59e1d1-2ee097bbec2mr6731674a91.30.1732757710458; Wed, 27
 Nov 2024 17:35:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:49 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-23-seanjc@google.com>
Subject: [PATCH v3 22/57] KVM: x86: Unpack F() CPUID feature flag macros to
 one flag per line of code
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>
Cc: kvm@vger.kernel.org, linux-sgx@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Refactor kvm_set_cpu_caps() to express each supported (or not) feature
flag on a separate line, modulo a handful of cases where KVM does not, and
likely will not, support a sequence of flags.  This will allow adding
fancier macros with longer, more descriptive names without resulting in
absurd line lengths and/or weird code.  Isolating each flag also makes it
far easier to review changes, reduces code conflicts, and generally makes
it easier to resolve conflicts.  Lastly, it allows co-locating comments
for notable flags, e.g. MONITOR, precisely with the relevant flag.

No functional change intended.

Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 295 +++++++++++++++++++++++++++++++++----------
 1 file changed, 231 insertions(+), 64 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index c7fb6b764075..00b5b1a2a66f 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -662,48 +662,121 @@ void kvm_set_cpu_caps(void)
 	       sizeof(kvm_cpu_caps) - (NKVMCAPINTS * sizeof(*kvm_cpu_caps)));
 
 	kvm_cpu_cap_mask(CPUID_1_ECX,
+		F(XMM3) |
+		F(PCLMULQDQ) |
+		0 /* DTES64 */ |
 		/*
 		 * NOTE: MONITOR (and MWAIT) are emulated as NOP, but *not*
 		 * advertised to guests via CPUID!
 		 */
-		F(XMM3) | F(PCLMULQDQ) | 0 /* DTES64, MONITOR */ |
+		0 /* MONITOR */ |
 		0 /* DS-CPL, VMX, SMX, EST */ |
-		0 /* TM2 */ | F(SSSE3) | 0 /* CNXT-ID */ | 0 /* Reserved */ |
-		F(FMA) | F(CX16) | 0 /* xTPR Update */ | F(PDCM) |
-		F(PCID) | 0 /* Reserved, DCA */ | F(XMM4_1) |
-		F(XMM4_2) | F(X2APIC) | F(MOVBE) | F(POPCNT) |
-		0 /* Reserved*/ | F(AES) | F(XSAVE) | 0 /* OSXSAVE */ | F(AVX) |
-		F(F16C) | F(RDRAND)
+		0 /* TM2 */ |
+		F(SSSE3) |
+		0 /* CNXT-ID */ |
+		0 /* Reserved */ |
+		F(FMA) |
+		F(CX16) |
+		0 /* xTPR Update */ |
+		F(PDCM) |
+		F(PCID) |
+		0 /* Reserved, DCA */ |
+		F(XMM4_1) |
+		F(XMM4_2) |
+		F(X2APIC) |
+		F(MOVBE) |
+		F(POPCNT) |
+		0 /* Reserved*/ |
+		F(AES) |
+		F(XSAVE) |
+		0 /* OSXSAVE */ |
+		F(AVX) |
+		F(F16C) |
+		F(RDRAND)
 	);
 	/* KVM emulates x2apic in software irrespective of host support. */
 	kvm_cpu_cap_set(X86_FEATURE_X2APIC);
 
 	kvm_cpu_cap_mask(CPUID_1_EDX,
-		F(FPU) | F(VME) | F(DE) | F(PSE) |
-		F(TSC) | F(MSR) | F(PAE) | F(MCE) |
-		F(CX8) | F(APIC) | 0 /* Reserved */ | F(SEP) |
-		F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
-		F(PAT) | F(PSE36) | 0 /* PSN */ | F(CLFLUSH) |
-		0 /* Reserved, DS, ACPI */ | F(MMX) |
-		F(FXSR) | F(XMM) | F(XMM2) | F(SELFSNOOP) |
+		F(FPU) |
+		F(VME) |
+		F(DE) |
+		F(PSE) |
+		F(TSC) |
+		F(MSR) |
+		F(PAE) |
+		F(MCE) |
+		F(CX8) |
+		F(APIC) |
+		0 /* Reserved */ |
+		F(SEP) |
+		F(MTRR) |
+		F(PGE) |
+		F(MCA) |
+		F(CMOV) |
+		F(PAT) |
+		F(PSE36) |
+		0 /* PSN */ |
+		F(CLFLUSH) |
+		0 /* Reserved, DS, ACPI */ |
+		F(MMX) |
+		F(FXSR) |
+		F(XMM) |
+		F(XMM2) |
+		F(SELFSNOOP) |
 		0 /* HTT, TM, Reserved, PBE */
 	);
 
 	kvm_cpu_cap_mask(CPUID_7_0_EBX,
-		F(FSGSBASE) | F(SGX) | F(BMI1) | F(HLE) | F(AVX2) |
-		F(FDP_EXCPTN_ONLY) | F(SMEP) | F(BMI2) | F(ERMS) | F(INVPCID) |
-		F(RTM) | F(ZERO_FCS_FDS) | 0 /*MPX*/ | F(AVX512F) |
-		F(AVX512DQ) | F(RDSEED) | F(ADX) | F(SMAP) | F(AVX512IFMA) |
-		F(CLFLUSHOPT) | F(CLWB) | 0 /*INTEL_PT*/ | F(AVX512PF) |
-		F(AVX512ER) | F(AVX512CD) | F(SHA_NI) | F(AVX512BW) |
+		F(FSGSBASE) |
+		F(SGX) |
+		F(BMI1) |
+		F(HLE) |
+		F(AVX2) |
+		F(FDP_EXCPTN_ONLY) |
+		F(SMEP) |
+		F(BMI2) |
+		F(ERMS) |
+		F(INVPCID) |
+		F(RTM) |
+		F(ZERO_FCS_FDS) |
+		0 /*MPX*/ |
+		F(AVX512F) |
+		F(AVX512DQ) |
+		F(RDSEED) |
+		F(ADX) |
+		F(SMAP) |
+		F(AVX512IFMA) |
+		F(CLFLUSHOPT) |
+		F(CLWB) |
+		0 /*INTEL_PT*/ |
+		F(AVX512PF) |
+		F(AVX512ER) |
+		F(AVX512CD) |
+		F(SHA_NI) |
+		F(AVX512BW) |
 		F(AVX512VL));
 
 	kvm_cpu_cap_mask(CPUID_7_ECX,
-		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
-		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
-		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
-		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
-		F(SGX_LC) | F(BUS_LOCK_DETECT)
+		F(AVX512VBMI) |
+		F(LA57) |
+		F(PKU) |
+		0 /*OSPKE*/ |
+		F(RDPID) |
+		F(AVX512_VPOPCNTDQ) |
+		F(UMIP) |
+		F(AVX512_VBMI2) |
+		F(GFNI) |
+		F(VAES) |
+		F(VPCLMULQDQ) |
+		F(AVX512_VNNI) |
+		F(AVX512_BITALG) |
+		F(CLDEMOTE) |
+		F(MOVDIRI) |
+		F(MOVDIR64B) |
+		0 /*WAITPKG*/ |
+		F(SGX_LC) |
+		F(BUS_LOCK_DETECT)
 	);
 	/* Set LA57 based on hardware capability. */
 	if (cpuid_ecx(7) & feature_bit(LA57))
@@ -717,11 +790,22 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_clear(X86_FEATURE_PKU);
 
 	kvm_cpu_cap_mask(CPUID_7_EDX,
-		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
-		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
-		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
-		F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16) |
-		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16) | F(FLUSH_L1D)
+		F(AVX512_4VNNIW) |
+		F(AVX512_4FMAPS) |
+		F(SPEC_CTRL) |
+		F(SPEC_CTRL_SSBD) |
+		F(ARCH_CAPABILITIES) |
+		F(INTEL_STIBP) |
+		F(MD_CLEAR) |
+		F(AVX512_VP2INTERSECT) |
+		F(FSRM) |
+		F(SERIALIZE) |
+		F(TSXLDTRK) |
+		F(AVX512_FP16) |
+		F(AMX_TILE) |
+		F(AMX_INT8) |
+		F(AMX_BF16) |
+		F(FLUSH_L1D)
 	);
 
 	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
@@ -738,50 +822,110 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
 
 	kvm_cpu_cap_mask(CPUID_7_1_EAX,
-		F(SHA512) | F(SM3) | F(SM4) | F(AVX_VNNI) | F(AVX512_BF16) |
-		F(CMPCCXADD) | F(FZRM) | F(FSRS) | F(FSRC) | F(AMX_FP16) |
-		F(AVX_IFMA) | F(LAM)
+		F(SHA512) |
+		F(SM3) |
+		F(SM4) |
+		F(AVX_VNNI) |
+		F(AVX512_BF16) |
+		F(CMPCCXADD) |
+		F(FZRM) |
+		F(FSRS) |
+		F(FSRC) |
+		F(AMX_FP16) |
+		F(AVX_IFMA) |
+		F(LAM)
 	);
 
 	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
-		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT) | F(AMX_COMPLEX) |
-		F(AVX_VNNI_INT16) | F(PREFETCHITI) | F(AVX10)
+		F(AVX_VNNI_INT8) |
+		F(AVX_NE_CONVERT) |
+		F(AMX_COMPLEX) |
+		F(AVX_VNNI_INT16) |
+		F(PREFETCHITI) |
+		F(AVX10)
 	);
 
 	kvm_cpu_cap_init_kvm_defined(CPUID_7_2_EDX,
-		F(INTEL_PSFD) | F(IPRED_CTRL) | F(RRSBA_CTRL) | F(DDPD_U) |
-		F(BHI_CTRL) | F(MCDT_NO)
+		F(INTEL_PSFD) |
+		F(IPRED_CTRL) |
+		F(RRSBA_CTRL) |
+		F(DDPD_U) |
+		F(BHI_CTRL) |
+		F(MCDT_NO)
 	);
 
 	kvm_cpu_cap_mask(CPUID_D_1_EAX,
-		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES) | f_xfd
+		F(XSAVEOPT) |
+		F(XSAVEC) |
+		F(XGETBV1) |
+		F(XSAVES) |
+		f_xfd
 	);
 
 	kvm_cpu_cap_init_kvm_defined(CPUID_12_EAX,
-		SF(SGX1) | SF(SGX2) | SF(SGX_EDECCSSA)
+		SF(SGX1) |
+		SF(SGX2) |
+		SF(SGX_EDECCSSA)
 	);
 
 	kvm_cpu_cap_init_kvm_defined(CPUID_24_0_EBX,
-		F(AVX10_128) | F(AVX10_256) | F(AVX10_512)
+		F(AVX10_128) |
+		F(AVX10_256) |
+		F(AVX10_512)
 	);
 
 	kvm_cpu_cap_mask(CPUID_8000_0001_ECX,
-		F(LAHF_LM) | F(CMP_LEGACY) | 0 /*SVM*/ | 0 /* ExtApicSpace */ |
-		F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
-		F(3DNOWPREFETCH) | F(OSVW) | 0 /* IBS */ | F(XOP) |
-		0 /* SKINIT, WDT, LWP */ | F(FMA4) | F(TBM) |
-		F(TOPOEXT) | 0 /* PERFCTR_CORE */
+		F(LAHF_LM) |
+		F(CMP_LEGACY) |
+		0 /*SVM*/ |
+		0 /* ExtApicSpace */ |
+		F(CR8_LEGACY) |
+		F(ABM) |
+		F(SSE4A) |
+		F(MISALIGNSSE) |
+		F(3DNOWPREFETCH) |
+		F(OSVW) |
+		0 /* IBS */ |
+		F(XOP) |
+		0 /* SKINIT, WDT, LWP */ |
+		F(FMA4) |
+		F(TBM) |
+		F(TOPOEXT) |
+		0 /* PERFCTR_CORE */
 	);
 
 	kvm_cpu_cap_mask(CPUID_8000_0001_EDX,
-		F(FPU) | F(VME) | F(DE) | F(PSE) |
-		F(TSC) | F(MSR) | F(PAE) | F(MCE) |
-		F(CX8) | F(APIC) | 0 /* Reserved */ | F(SYSCALL) |
-		F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
-		F(PAT) | F(PSE36) | 0 /* Reserved */ |
-		F(NX) | 0 /* Reserved */ | F(MMXEXT) | F(MMX) |
-		F(FXSR) | F(FXSR_OPT) | f_gbpages | F(RDTSCP) |
-		0 /* Reserved */ | f_lm | F(3DNOWEXT) | F(3DNOW)
+		F(FPU) |
+		F(VME) |
+		F(DE) |
+		F(PSE) |
+		F(TSC) |
+		F(MSR) |
+		F(PAE) |
+		F(MCE) |
+		F(CX8) |
+		F(APIC) |
+		0 /* Reserved */ |
+		F(SYSCALL) |
+		F(MTRR) |
+		F(PGE) |
+		F(MCA) |
+		F(CMOV) |
+		F(PAT) |
+		F(PSE36) |
+		0 /* Reserved */ |
+		F(NX) |
+		0 /* Reserved */ |
+		F(MMXEXT) |
+		F(MMX) |
+		F(FXSR) |
+		F(FXSR_OPT) |
+		f_gbpages |
+		F(RDTSCP) |
+		0 /* Reserved */ |
+		f_lm |
+		F(3DNOWEXT) |
+		F(3DNOW)
 	);
 
 	if (!tdp_enabled && IS_ENABLED(CONFIG_X86_64))
@@ -792,10 +936,18 @@ void kvm_set_cpu_caps(void)
 	);
 
 	kvm_cpu_cap_mask(CPUID_8000_0008_EBX,
-		F(CLZERO) | F(XSAVEERPTR) |
-		F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
-		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON) |
-		F(AMD_PSFD) | F(AMD_IBPB_RET)
+		F(CLZERO) |
+		F(XSAVEERPTR) |
+		F(WBNOINVD) |
+		F(AMD_IBPB) |
+		F(AMD_IBRS) |
+		F(AMD_SSBD) |
+		F(VIRT_SSBD) |
+		F(AMD_SSB_NO) |
+		F(AMD_STIBP) |
+		F(AMD_STIBP_ALWAYS_ON) |
+		F(AMD_PSFD) |
+		F(AMD_IBPB_RET)
 	);
 
 	/*
@@ -832,12 +984,20 @@ void kvm_set_cpu_caps(void)
 	kvm_cpu_cap_mask(CPUID_8000_000A_EDX, 0);
 
 	kvm_cpu_cap_mask(CPUID_8000_001F_EAX,
-		0 /* SME */ | 0 /* SEV */ | 0 /* VM_PAGE_FLUSH */ | 0 /* SEV_ES */ |
-		F(SME_COHERENT));
+		0 /* SME */ |
+		0 /* SEV */ |
+		0 /* VM_PAGE_FLUSH */ |
+		0 /* SEV_ES */ |
+		F(SME_COHERENT)
+	);
 
 	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
-		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
-		F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | 0 /* PrefetchCtlMsr */ |
+		F(NO_NESTED_DATA_BP) |
+		F(LFENCE_RDTSC) |
+		0 /* SmmPgCfgLock */ |
+		F(NULL_SEL_CLR_BASE) |
+		F(AUTOIBRS) |
+		0 /* PrefetchCtlMsr */ |
 		F(WRMSR_XX_BASE_NS)
 	);
 
@@ -866,9 +1026,16 @@ void kvm_set_cpu_caps(void)
 	kvm_cpu_cap_set(X86_FEATURE_NO_SMM_CTL_MSR);
 
 	kvm_cpu_cap_mask(CPUID_C000_0001_EDX,
-		F(XSTORE) | F(XSTORE_EN) | F(XCRYPT) | F(XCRYPT_EN) |
-		F(ACE2) | F(ACE2_EN) | F(PHE) | F(PHE_EN) |
-		F(PMM) | F(PMM_EN)
+		F(XSTORE) |
+		F(XSTORE_EN) |
+		F(XCRYPT) |
+		F(XCRYPT_EN) |
+		F(ACE2) |
+		F(ACE2_EN) |
+		F(PHE) |
+		F(PHE_EN) |
+		F(PMM) |
+		F(PMM_EN)
 	);
 
 	/*
-- 
2.47.0.338.g60cca15819-goog


