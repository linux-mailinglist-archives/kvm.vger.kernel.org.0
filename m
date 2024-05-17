Return-Path: <kvm+bounces-17672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FC108C8B70
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:46:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47162289826
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:46:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14F2C14E2E1;
	Fri, 17 May 2024 17:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vl8EV0QB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97B014B953
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967624; cv=none; b=RB6HxroaBiYRH/hGTJSFYBD7aPaxhphRIGjnNsiQmOHK7jYPxza+dEliBN96P6W7ilBAo7QfxNlw6s52a4YhQpPr/XPHjP/2ZcYmrfimNnCHFpiX1vFhponiA6wZXpjgAuJSDSu9odfKzJtehXuwwugBfjWIUraWA3Kp/vn5NJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967624; c=relaxed/simple;
	bh=6hq41gtk1Pj0wLH+o0Np31/aebxJnq6BX/7eraPEjj8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KffwdziQacdgJsHOJnt7tlbF7kM4etuTek+Sw7YedqoEF9eKLmZ8IsSFlBRfv/SVbyX+VDSxQd4IxWvcZeRBJye8SUYubLCQdcINeW3RWz/bmc0yz9D+Okr/a0ZfBL0K7Qp85qg+SRZVlwkmdYLN7UfFX234Zu1xENjqgOoWkt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vl8EV0QB; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-658b03ebe58so2312072a12.3
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967622; x=1716572422; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hnSx2cVkIAJFaLNy+y92FOfzJJRMl4049YLj6l59NXo=;
        b=Vl8EV0QB4uZfyWUK7ov7oLtzRM+5g/PXgEoviro3QYlqIN5mgYEAEoQBwJ850DA/Y0
         TPyq75xPMSe5InWQro/Z9n7DRQ48Zm6ew4k4+TKdAF+ovDXWrEz3SPTMoJcU/F41hU3G
         5uZaZKHfiT/mJDfQZovTVUjwmB6R+RAvlul7pHgyOJ119WKfg6ulhaP7TIpG9xIR8J4J
         YDttTF1yc0kX49U6oz44bVVLGucjKLnzRCAo822qdy3xF+g/jlzKcKLzak1+/eQY3ip0
         4htBmmXaAJ92tBWP7pRRiUDM/DttBMRpCZEXjkpFyCrpSGJ21RdgzR/szKHHL7onSu/N
         1koA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967622; x=1716572422;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hnSx2cVkIAJFaLNy+y92FOfzJJRMl4049YLj6l59NXo=;
        b=MAYcmmu6LBgrXIPUXKwexhknDS/D1dx0Yl22cNZWbvUarwbA4DdUZfD1P13crY5Ve4
         C5iG09H84ZLNIqKdDzIApLlTsOprqCsvU3fajUuF9hdoaLMn+z5wNS0lxy8HuWootUwR
         56dJCFkwJiQaPA55qjaVXOi46YTj64/F1gBynArbcRe3+nLb9B08nodnotVU+eXjsz6T
         nBowGL0yifPj+uYeHr5coOR3HgCxXLAVI3tipcpQngMcyIspVYAka16ZsMo7EqDppHNx
         Y3EhYbczJeUwEcz09vux4Ry0bEKd2ehL+ljMz3Ky4Wsop03uDljMog4kECQe6/H/jMZT
         xmpg==
X-Gm-Message-State: AOJu0YyJ0sUpzumoCjSrJ65PT1Yh0flG7GoQcA2l/BEF2NTAT6p+h8lp
	dRHp1ZHTsbVAeEDS/cmbCr65PsX7eaI+pylMAKtVR4aSieyCUzaFT25NBi8owv6TbWpjCdkDux5
	DcQ==
X-Google-Smtp-Source: AGHT+IHZXvvylqsl9vQUTjP4LjyNSs72daRn0Xw8GvyvMd5DcuYgM1TCNtD/A0L2xR/DSJgNzff85j4KaZ8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:90c9:0:b0:659:237f:ed1a with SMTP id
 41be03b00d2f7-659237fed5amr13907a12.7.1715967622162; Fri, 17 May 2024
 10:40:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:38:57 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-21-seanjc@google.com>
Subject: [PATCH v2 20/49] KVM: x86: Rename kvm_cpu_cap_mask() to kvm_cpu_cap_init()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Rename kvm_cpu_cap_mask() to kvm_cpu_cap_init() in anticipation of merging
it with kvm_cpu_cap_init_kvm_defined(), and in anticipation of _setting_
bits in the helper (a future commit will play macro games to set emulated
feature flags via kvm_cpu_cap_init()).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index a802c09b50ab..5a4d6138c4f1 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -74,7 +74,7 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
  * Raw Feature - For features that KVM supports based purely on raw host CPUID,
  * i.e. that KVM virtualizes even if the host kernel doesn't use the feature.
  * Simply force set the feature in KVM's capabilities, raw CPUID support will
- * be factored in by kvm_cpu_cap_mask().
+ * be factored in by __kvm_cpu_cap_mask().
  */
 #define RAW_F(name)						\
 ({								\
@@ -619,7 +619,7 @@ static __always_inline void __kvm_cpu_cap_mask(unsigned int leaf)
 static __always_inline
 void kvm_cpu_cap_init_kvm_defined(enum kvm_only_cpuid_leafs leaf, u32 mask)
 {
-	/* Use kvm_cpu_cap_mask for leafs that aren't KVM-only. */
+	/* Use kvm_cpu_cap_init for leafs that aren't KVM-only. */
 	BUILD_BUG_ON(leaf < NCAPINTS);
 
 	kvm_cpu_caps[leaf] = mask;
@@ -627,7 +627,7 @@ void kvm_cpu_cap_init_kvm_defined(enum kvm_only_cpuid_leafs leaf, u32 mask)
 	__kvm_cpu_cap_mask(leaf);
 }
 
-static __always_inline void kvm_cpu_cap_mask(enum cpuid_leafs leaf, u32 mask)
+static __always_inline void kvm_cpu_cap_init(enum cpuid_leafs leaf, u32 mask)
 {
 	/* Use kvm_cpu_cap_init_kvm_defined for KVM-only leafs. */
 	BUILD_BUG_ON(leaf >= NCAPINTS);
@@ -656,7 +656,7 @@ void kvm_set_cpu_caps(void)
 	memcpy(&kvm_cpu_caps, &boot_cpu_data.x86_capability,
 	       sizeof(kvm_cpu_caps) - (NKVMCAPINTS * sizeof(*kvm_cpu_caps)));
 
-	kvm_cpu_cap_mask(CPUID_1_ECX,
+	kvm_cpu_cap_init(CPUID_1_ECX,
 		/*
 		 * NOTE: MONITOR (and MWAIT) are emulated as NOP, but *not*
 		 * advertised to guests via CPUID!
@@ -673,7 +673,7 @@ void kvm_set_cpu_caps(void)
 	/* KVM emulates x2apic in software irrespective of host support. */
 	kvm_cpu_cap_set(X86_FEATURE_X2APIC);
 
-	kvm_cpu_cap_mask(CPUID_1_EDX,
+	kvm_cpu_cap_init(CPUID_1_EDX,
 		F(FPU) | F(VME) | F(DE) | F(PSE) |
 		F(TSC) | F(MSR) | F(PAE) | F(MCE) |
 		F(CX8) | F(APIC) | 0 /* Reserved */ | F(SEP) |
@@ -684,7 +684,7 @@ void kvm_set_cpu_caps(void)
 		0 /* HTT, TM, Reserved, PBE */
 	);
 
-	kvm_cpu_cap_mask(CPUID_7_0_EBX,
+	kvm_cpu_cap_init(CPUID_7_0_EBX,
 		F(FSGSBASE) | F(SGX) | F(BMI1) | F(HLE) | F(AVX2) |
 		F(FDP_EXCPTN_ONLY) | F(SMEP) | F(BMI2) | F(ERMS) | F(INVPCID) |
 		F(RTM) | F(ZERO_FCS_FDS) | 0 /*MPX*/ | F(AVX512F) |
@@ -693,7 +693,7 @@ void kvm_set_cpu_caps(void)
 		F(AVX512ER) | F(AVX512CD) | F(SHA_NI) | F(AVX512BW) |
 		F(AVX512VL));
 
-	kvm_cpu_cap_mask(CPUID_7_ECX,
+	kvm_cpu_cap_init(CPUID_7_ECX,
 		F(AVX512VBMI) | RAW_F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
 		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
 		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
@@ -708,7 +708,7 @@ void kvm_set_cpu_caps(void)
 	if (!tdp_enabled || !boot_cpu_has(X86_FEATURE_OSPKE))
 		kvm_cpu_cap_clear(X86_FEATURE_PKU);
 
-	kvm_cpu_cap_mask(CPUID_7_EDX,
+	kvm_cpu_cap_init(CPUID_7_EDX,
 		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
 		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
 		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
@@ -727,7 +727,7 @@ void kvm_set_cpu_caps(void)
 	if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
 		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
 
-	kvm_cpu_cap_mask(CPUID_7_1_EAX,
+	kvm_cpu_cap_init(CPUID_7_1_EAX,
 		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) |
 		F(FZRM) | F(FSRS) | F(FSRC) |
 		F(AMX_FP16) | F(AVX_IFMA) | F(LAM)
@@ -743,7 +743,7 @@ void kvm_set_cpu_caps(void)
 		F(BHI_CTRL) | F(MCDT_NO)
 	);
 
-	kvm_cpu_cap_mask(CPUID_D_1_EAX,
+	kvm_cpu_cap_init(CPUID_D_1_EAX,
 		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES) | f_xfd
 	);
 
@@ -751,7 +751,7 @@ void kvm_set_cpu_caps(void)
 		SF(SGX1) | SF(SGX2) | SF(SGX_EDECCSSA)
 	);
 
-	kvm_cpu_cap_mask(CPUID_8000_0001_ECX,
+	kvm_cpu_cap_init(CPUID_8000_0001_ECX,
 		F(LAHF_LM) | F(CMP_LEGACY) | 0 /*SVM*/ | 0 /* ExtApicSpace */ |
 		F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
 		F(3DNOWPREFETCH) | F(OSVW) | 0 /* IBS */ | F(XOP) |
@@ -759,7 +759,7 @@ void kvm_set_cpu_caps(void)
 		F(TOPOEXT) | 0 /* PERFCTR_CORE */
 	);
 
-	kvm_cpu_cap_mask(CPUID_8000_0001_EDX,
+	kvm_cpu_cap_init(CPUID_8000_0001_EDX,
 		F(FPU) | F(VME) | F(DE) | F(PSE) |
 		F(TSC) | F(MSR) | F(PAE) | F(MCE) |
 		F(CX8) | F(APIC) | 0 /* Reserved */ | F(SYSCALL) |
@@ -777,7 +777,7 @@ void kvm_set_cpu_caps(void)
 		SF(CONSTANT_TSC)
 	);
 
-	kvm_cpu_cap_mask(CPUID_8000_0008_EBX,
+	kvm_cpu_cap_init(CPUID_8000_0008_EBX,
 		F(CLZERO) | F(XSAVEERPTR) |
 		F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
 		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON) |
@@ -811,13 +811,13 @@ void kvm_set_cpu_caps(void)
 	 * Hide all SVM features by default, SVM will set the cap bits for
 	 * features it emulates and/or exposes for L1.
 	 */
-	kvm_cpu_cap_mask(CPUID_8000_000A_EDX, 0);
+	kvm_cpu_cap_init(CPUID_8000_000A_EDX, 0);
 
-	kvm_cpu_cap_mask(CPUID_8000_001F_EAX,
+	kvm_cpu_cap_init(CPUID_8000_001F_EAX,
 		0 /* SME */ | 0 /* SEV */ | 0 /* VM_PAGE_FLUSH */ | 0 /* SEV_ES */ |
 		F(SME_COHERENT));
 
-	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
+	kvm_cpu_cap_init(CPUID_8000_0021_EAX,
 		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
 		F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | 0 /* PrefetchCtlMsr */ |
 		F(WRMSR_XX_BASE_NS)
@@ -837,7 +837,7 @@ void kvm_set_cpu_caps(void)
 	 * kernel.  LFENCE_RDTSC was a Linux-defined synthetic feature long
 	 * before AMD joined the bandwagon, e.g. LFENCE is serializing on most
 	 * CPUs that support SSE2.  On CPUs that don't support AMD's leaf,
-	 * kvm_cpu_cap_mask() will unfortunately drop the flag due to ANDing
+	 * kvm_cpu_cap_init() will unfortunately drop the flag due to ANDing
 	 * the mask with the raw host CPUID, and reporting support in AMD's
 	 * leaf can make it easier for userspace to detect the feature.
 	 */
@@ -847,7 +847,7 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_NULL_SEL_CLR_BASE);
 	kvm_cpu_cap_set(X86_FEATURE_NO_SMM_CTL_MSR);
 
-	kvm_cpu_cap_mask(CPUID_C000_0001_EDX,
+	kvm_cpu_cap_init(CPUID_C000_0001_EDX,
 		F(XSTORE) | F(XSTORE_EN) | F(XCRYPT) | F(XCRYPT_EN) |
 		F(ACE2) | F(ACE2_EN) | F(PHE) | F(PHE_EN) |
 		F(PMM) | F(PMM_EN)
-- 
2.45.0.215.g3402c0e53f-goog


