Return-Path: <kvm+bounces-17701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AA658C8BB4
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:54:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BF001B22592
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:54:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E103915B57C;
	Fri, 17 May 2024 17:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ukssJXsw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6189B15ADA7
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967679; cv=none; b=Sg6uV1Cbu5iQnUSV0tFBAWHFZiAR/hmMxRzVFCfiBkK9gWHSKzuuTsx+1mwgwo9iZeHEHb9ml6Vpd/EDk0/vMa0vaZ3Sxeyo+4LRB09Mlk8B+lTL3JgGmuMQzmj1nVIjh0GnSmbYj35TIWBhbQoy76spenRidZZNOsTvP2z5ijs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967679; c=relaxed/simple;
	bh=ogBZy6UUu78UCr2UIsbUzng6LYItrtbTBlzdnk1vwMc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MEmgbjdodhih9E5rHrhVmF1t3Se48/2iRk3easoXHVBkv/iwPI9op7ikfj+VvmrGaMgMvos6vN/6pyM3i/7FqRkNiWqdult4yAErwgxh2HAx2qIrSaUi532TeFxyo8kgzldnhjYBNGT6NMxW8JHZ+jIwPO+uMoDpa0eNj+02R9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ukssJXsw; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-622ccd54631so114252057b3.0
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967676; x=1716572476; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LFDWSyb3rS2hJ7kj5xBfFmp3h/cskE4uFgprmmgLSHM=;
        b=ukssJXsw7K3ZIlxPQMI0RLEpRTVe/Ryl8UNgym3NjDnBOGYlPwlUEwk1v9jgCLwz3X
         cnrpQ3XfNo20KykzpBR7j6KGSXxB9xBCXtzkDyjqtqQN55Pu4tQkXSzBSY9y2ryusZ2d
         ZynsPBzo8N2sbtQj+KSUfVdR0uQKIvuEUtGwkY0a4NZT2UYLRoZDPg7Q16rfHU8yP0TK
         /vqOXIB0mIvxfzivd8pFgg0UJ5LJTuxERidX0u6ZULipdEecWa9cLUERmwONYEvB4NLA
         xW/f6gPwYOxBUYo+2iSrZ4/6yFazD6vWYIA6yHeHbwO+yYMQPPL2WA2NKfU3FyCs6ca1
         GdEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967676; x=1716572476;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LFDWSyb3rS2hJ7kj5xBfFmp3h/cskE4uFgprmmgLSHM=;
        b=kgQae6dDjLXyqQEb4fnly9/p8udsA35pvn4vACDmivIcjEQrwBznwuLEVOBKgfI656
         /7GO7/znqC8eVhvqbCfkNhb5TOBVqWfwgU90xN/6pN2AwbdKcFfYYiZ9gek6fC7uHphm
         T/52OhNZIRlZ0BUnE8/dNwdzs4EzoOtAfL0uKCJZUl91IKO4TvkJPafdf7uChxNWjohA
         ag0VXmavcofVKWvXS344yfXvXZj7uBHOmfm3QoniO3YdEbYjqf+u+O/ATC3ddQU9H9SQ
         nGUjW5CKdpUl+dTEmtqbUDuf/hQBzov6F20By37/fOp9YyThXKyRLoTVmVU7ZhbKSTcs
         7IJA==
X-Gm-Message-State: AOJu0Yw+vkE99ANeTsJTKVYDpma6Pe1eNIWvLK/qOwQu/Et535AozJDT
	pOyogdXgqNLsPyZL7mZHhxYraOU3gJMJ1lPqzNTtkEWVMz+I4F9ktWOBwLzI3HNBnw+a99Ah43U
	7Jw==
X-Google-Smtp-Source: AGHT+IEqdBFyzUjJT2cVWT8eTCBsUVjR6p2zSLPSbkjj1GmPhTB4oLMDtluQ8Aw+ZLMSpYkIk0R+OR5DdxI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:4b06:b0:61b:e37b:223e with SMTP id
 00721157ae682-622affc65d0mr56160077b3.5.1715967676488; Fri, 17 May 2024
 10:41:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:39:26 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-50-seanjc@google.com>
Subject: [PATCH v2 49/49] *** DO NOT APPLY *** KVM: x86: Verify KVM
 initializes all consumed guest caps
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Assert that all features queried via guest_cpu_cap_has() are known to KVM,
i.e. that KVM doesn't check for a feature that can never actually be set.

This is for demonstration purposes only, as the proper way to enforce this
is to do post-processing at build time (and there are other shortcomings
of this PoC, e.g. it requires all KVM modules to be built-in).

Not-signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c              | 81 +++++++++++++++++++++++--------
 arch/x86/kvm/cpuid.h              | 16 +++++-
 arch/x86/kvm/x86.c                |  2 +
 include/asm-generic/vmlinux.lds.h |  4 ++
 4 files changed, 81 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0e64a6332052..18ded0e682f2 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -37,6 +37,7 @@ u32 kvm_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
 EXPORT_SYMBOL_GPL(kvm_cpu_caps);
 
 static u32 kvm_vmm_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
+static u32 kvm_known_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
 
 u32 xstate_required_size(u64 xstate_bv, bool compacted)
 {
@@ -143,6 +144,26 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
 	0;									\
 })
 
+/*
+ * Vendor Features - For features that KVM supports, but are added in later
+ * because they require additional vendor enabling.
+ */
+#define VEND_F(name)						\
+({								\
+	KVM_VALIDATE_CPU_CAP_USAGE(name);			\
+	0;							\
+})
+
+/*
+ * Operating System Features - For features that KVM dynamically sets/clears at
+ * runtime, e.g. when CR4 changes, but are never advertised to userspace.
+ */
+#define OS_F(name)						\
+({								\
+	KVM_VALIDATE_CPU_CAP_USAGE(name);			\
+	0;							\
+})
+
 /*
  * Magic value used by KVM when querying userspace-provided CPUID entries and
  * doesn't care about the CPIUD index because the index of the function in
@@ -727,6 +748,7 @@ do {									\
 	u32 __leaf = __feature_leaf(X86_FEATURE_##name);		\
 									\
 	BUILD_BUG_ON(__leaf != kvm_cpu_cap_init_in_progress);		\
+	kvm_known_cpu_caps[__leaf] |= feature_bit(name);		\
 } while (0)
 
 /*
@@ -771,14 +793,14 @@ void kvm_set_cpu_caps(void)
 		 * NOTE: MONITOR (and MWAIT) are emulated as NOP, but *not*
 		 * advertised to guests via CPUID!
 		 */
-		F(XMM3) | F(PCLMULQDQ) | 0 /* DTES64 */ | VMM_F(MWAIT) |
-		0 /* DS-CPL, VMX, SMX, EST */ |
+		F(XMM3) | F(PCLMULQDQ) | VEND_F(DTES64) | VMM_F(MWAIT) |
+		VEND_F(VMX) | 0 /* DS-CPL, SMX, EST */ |
 		0 /* TM2 */ | F(SSSE3) | 0 /* CNXT-ID */ | 0 /* Reserved */ |
 		F(FMA) | F(CX16) | 0 /* xTPR Update */ | F(PDCM) |
 		F(PCID) | 0 /* Reserved, DCA */ | F(XMM4_1) |
 		F(XMM4_2) | EMUL_F(X2APIC) | F(MOVBE) | F(POPCNT) |
 		EMUL_F(TSC_DEADLINE_TIMER) | F(AES) | F(XSAVE) |
-		0 /* OSXSAVE */ | F(AVX) | F(F16C) | F(RDRAND) |
+		OS_F(OSXSAVE) | F(AVX) | F(F16C) | F(RDRAND) |
 		EMUL_F(HYPERVISOR)
 	);
 
@@ -788,7 +810,7 @@ void kvm_set_cpu_caps(void)
 		F(CX8) | F(APIC) | 0 /* Reserved */ | F(SEP) |
 		F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
 		F(PAT) | F(PSE36) | 0 /* PSN */ | F(CLFLUSH) |
-		0 /* Reserved, DS, ACPI */ | F(MMX) |
+		0 /* Reserved */ | F(DS) | 0 /* ACPI */ | F(MMX) |
 		F(FXSR) | F(XMM) | F(XMM2) | F(SELFSNOOP) |
 		0 /* HTT, TM, Reserved, PBE */
 	);
@@ -796,17 +818,17 @@ void kvm_set_cpu_caps(void)
 	kvm_cpu_cap_init(CPUID_7_0_EBX,
 		F(FSGSBASE) | EMUL_F(TSC_ADJUST) | F(SGX) | F(BMI1) | F(HLE) |
 		F(AVX2) | F(FDP_EXCPTN_ONLY) | F(SMEP) | F(BMI2) | F(ERMS) |
-		F(INVPCID) | F(RTM) | F(ZERO_FCS_FDS) | 0 /*MPX*/ |
+		F(INVPCID) | F(RTM) | F(ZERO_FCS_FDS) | VEND_F(MPX) |
 		F(AVX512F) | F(AVX512DQ) | F(RDSEED) | F(ADX) | F(SMAP) |
-		F(AVX512IFMA) | F(CLFLUSHOPT) | F(CLWB) | 0 /*INTEL_PT*/ |
+		F(AVX512IFMA) | F(CLFLUSHOPT) | F(CLWB) | VEND_F(INTEL_PT) |
 		F(AVX512PF) | F(AVX512ER) | F(AVX512CD) | F(SHA_NI) |
 		F(AVX512BW) | F(AVX512VL));
 
 	kvm_cpu_cap_init(CPUID_7_ECX,
-		F(AVX512VBMI) | RAW_F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
+		F(AVX512VBMI) | RAW_F(LA57) | F(PKU) | OS_F(OSPKE) | F(RDPID) |
 		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
 		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
-		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
+		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | VEND_F(WAITPKG) |
 		F(SGX_LC) | F(BUS_LOCK_DETECT)
 	);
 
@@ -858,11 +880,11 @@ void kvm_set_cpu_caps(void)
 	);
 
 	kvm_cpu_cap_init(CPUID_8000_0001_ECX,
-		F(LAHF_LM) | F(CMP_LEGACY) | 0 /*SVM*/ | 0 /* ExtApicSpace */ |
+		F(LAHF_LM) | F(CMP_LEGACY) | VEND_F(SVM) | 0 /* ExtApicSpace */ |
 		F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
 		F(3DNOWPREFETCH) | F(OSVW) | 0 /* IBS */ | F(XOP) |
 		0 /* SKINIT, WDT, LWP */ | F(FMA4) | F(TBM) |
-		F(TOPOEXT) | 0 /* PERFCTR_CORE */
+		F(TOPOEXT) | VEND_F(PERFCTR_CORE)
 	);
 
 	kvm_cpu_cap_init(CPUID_8000_0001_EDX,
@@ -905,23 +927,22 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_AMD_SSBD);
 	if (!boot_cpu_has_bug(X86_BUG_SPEC_STORE_BYPASS))
 		kvm_cpu_cap_set(X86_FEATURE_AMD_SSB_NO);
-	/*
-	 * The preference is to use SPEC CTRL MSR instead of the
-	 * VIRT_SPEC MSR.
-	 */
-	if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) &&
-	    !boot_cpu_has(X86_FEATURE_AMD_SSBD))
-		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
 
 	/*
 	 * Hide all SVM features by default, SVM will set the cap bits for
 	 * features it emulates and/or exposes for L1.
 	 */
-	kvm_cpu_cap_init(CPUID_8000_000A_EDX, 0);
+	kvm_cpu_cap_init(CPUID_8000_000A_EDX,
+		VEND_F(VMCBCLEAN) | VEND_F(FLUSHBYASID) | VEND_F(NRIPS) |
+		VEND_F(TSCRATEMSR) | VEND_F(V_VMSAVE_VMLOAD) | VEND_F(LBRV) |
+		VEND_F(PAUSEFILTER) | VEND_F(PFTHRESHOLD) | VEND_F(VGIF) |
+		VEND_F(VNMI) | VEND_F(SVME_ADDR_CHK)
+	);
 
 	kvm_cpu_cap_init(CPUID_8000_001F_EAX,
-		0 /* SME */ | 0 /* SEV */ | 0 /* VM_PAGE_FLUSH */ | 0 /* SEV_ES */ |
-		F(SME_COHERENT));
+		VEND_F(SME) | VEND_F(SEV) | 0 /* VM_PAGE_FLUSH */ | VEND_F(SEV_ES) |
+		F(SME_COHERENT)
+	);
 
 	kvm_cpu_cap_init(CPUID_8000_0021_EAX,
 		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
@@ -977,6 +998,26 @@ EXPORT_SYMBOL_GPL(kvm_set_cpu_caps);
 #undef KVM_VALIDATE_CPU_CAP_USAGE
 #define KVM_VALIDATE_CPU_CAP_USAGE(name)
 
+
+extern unsigned int __start___kvm_features[];
+extern unsigned int __stop___kvm_features[];
+
+void kvm_validate_cpu_caps(void)
+{
+	int i;
+
+	for (i = 0; i < __stop___kvm_features - __start___kvm_features; i++) {
+		u32 feature = __feature_translate(__start___kvm_features[i]);
+		u32 leaf = feature / 32;
+
+		if (kvm_known_cpu_caps[leaf] & BIT(feature & 31))
+			continue;
+
+		pr_warn("Word %u, bit %u (%lx) checked but not supported\n",
+			leaf, feature & 31, BIT(feature & 31));
+	}
+
+}
 struct kvm_cpuid_array {
 	struct kvm_cpuid_entry2 *entries;
 	int maxnent;
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 0bf3bddd0e29..32a86de980c7 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -10,6 +10,7 @@
 
 extern u32 kvm_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
 void kvm_set_cpu_caps(void);
+void kvm_validate_cpu_caps(void);
 
 void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu);
 void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu);
@@ -245,8 +246,8 @@ static __always_inline void guest_cpu_cap_change(struct kvm_vcpu *vcpu,
 		guest_cpu_cap_clear(vcpu, x86_feature);
 }
 
-static __always_inline bool guest_cpu_cap_has(struct kvm_vcpu *vcpu,
-					      unsigned int x86_feature)
+static __always_inline bool __guest_cpu_cap_has(struct kvm_vcpu *vcpu,
+					        unsigned int x86_feature)
 {
 	unsigned int x86_leaf = __feature_leaf(x86_feature);
 
@@ -254,6 +255,17 @@ static __always_inline bool guest_cpu_cap_has(struct kvm_vcpu *vcpu,
 	return vcpu->arch.cpu_caps[x86_leaf] & __feature_bit(x86_feature);
 }
 
+#define guest_cpu_cap_has(vcpu, x86_feature)			\
+({								\
+	asm volatile(						\
+		" .pushsection \"__kvm_features\",\"a\"\n"	\
+		" .balign 4\n"					\
+		" .long " __stringify(x86_feature) " \n"	\
+		" .popsection\n"				\
+	);							\
+	__guest_cpu_cap_has(vcpu, x86_feature);			\
+})
+
 static inline bool kvm_vcpu_is_legal_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_LAM))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5aa7581802f7..f6b7c5c862fb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9790,6 +9790,8 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	if (r != 0)
 		goto out_mmu_exit;
 
+	kvm_validate_cpu_caps();
+
 	kvm_ops_update(ops);
 
 	for_each_online_cpu(cpu) {
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index f7749d0f2562..102fc2a39083 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -533,6 +533,10 @@
 		BOUNDED_SECTION_BY(__modver, ___modver)			\
 	}								\
 									\
+	__kvm_features : AT(ADDR(__kvm_features) - LOAD_OFFSET) {	\
+		BOUNDED_SECTION_BY(__kvm_features, ___kvm_features)	\
+	}								\
+									\
 	KCFI_TRAPS							\
 									\
 	RO_EXCEPTION_TABLE						\
-- 
2.45.0.215.g3402c0e53f-goog


