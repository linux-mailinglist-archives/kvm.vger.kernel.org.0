Return-Path: <kvm+bounces-32708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A2BD9DB135
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:50:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A44C282547
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:49:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75213137775;
	Thu, 28 Nov 2024 01:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pIh47QtV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E3C1D0BA7
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757774; cv=none; b=HSflaTSSY5LnBi737AQ8sAwTAo9gKv+wE2xZSgjYhkJz+AHeaQuq5li1Vl7cL/h598ONqS2uSxSm5IWKCouk0rFupmMRJ9ItJmD3RIZIPfaEDsG/2obOC1C7OWJVccLs6qKmxs96xRqsws5R/ydsVfqDXJEPzSY/7oWJdbycsHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757774; c=relaxed/simple;
	bh=QXiVgofEOC5+d++0Hy4KZ0nFVeGh7HhLS1QnnQ4HPG4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ui3wrQGwFTSJ9Xz/rgrODS7rEvLnaEqrE3WcjZbjI0W69hU1at/W0k9JcR0BM0al2erlF8vWH8m5gt4TjbEDnOJ6PSvkT1l1Pm5/oWx+e9vTfLn1wW4Z7CwIJEu3D8za3j0YsYm+1uLJRxtB5otCnBAhdILe7kexGzs+yRVD1qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pIh47QtV; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ee0c9962daso354791a91.2
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:36:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757772; x=1733362572; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=N92yrd6ibiwhVGbWmDI81B5t5iE79c6CGTpBzLJ/PUk=;
        b=pIh47QtVAjxvAJgs6gV/0pR6h4+YVoM48qIJhN4cW9JZmYydxa4d78eImWbywenmZJ
         fSf++T4WMhEKpNtQTqlO4EKFYfJ9ZMIIcSBQMWJM/CZUbp6peLL225S+NTH8130Vq1P0
         H3iLpaO274lNWDTa0IZh7zmxSTt6hAYHXBBaozBxjzokNu3kg4cOawbaVLLe+5/6DRZ/
         eRS0eBWT2WQW2VLP/PIGN0Ae35FWRAsh/6YDpPSyaE5xSRhf+ckYEm2JdftI9FRFVpv1
         FPWVoKG3PgEeKXR2wgVMilgCHC7Hg0GEkacDUXKRzWEoZ4b874QblSceaLvU9lKtOM3Q
         EZpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757772; x=1733362572;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N92yrd6ibiwhVGbWmDI81B5t5iE79c6CGTpBzLJ/PUk=;
        b=kPxYQ8JLimJvkGKoWxzmYAeLQJjzI9Gr4I99E6q3k32ZFOovBLmRtLBgAbVduHdiBr
         SM+0UWf/tWSf9TxjxCjC4esBuJe9QCtUL26EoDfRfctQvHzEWL4M7N2hv/PX0cWsvlxC
         oRkxBK7YlTTQ+pp2N3N4ZfsUNsqzX/LIEyS3ghnAJyW6Nf7JDcv0M2pPSAL5SFcOsdpm
         +ZT3BN0LxXHmd0XFshMh9DN/OoUY3DK9NcKRk1+UV0AGzot6wYYee2qNH0+rk65UnZPW
         VcJ8gf1iQ+JRJLG1wqR+FbBfW0wf8ReWUl5fCxNUKs9jdtuBSEbytSVqdvuw4/rIx3Ia
         VvyA==
X-Gm-Message-State: AOJu0YzP92yEZyFHrptgbh/mILdT7g/oCJDxQzgyZgD3be8lk78D16dB
	bvqQDfPOAyV3tqJet7VAEF7ixD9VJfLCN/5PXOZoM04IP+bD/jeujIQArqewPMyyjgJMMrhp0rQ
	bKA==
X-Google-Smtp-Source: AGHT+IE3Ubt1FJBmHBFQWyCuDufvC5sJ8LXxeLht2Ljbx9QzWGCJryzyyFiqCqmLPS9zT8CasW3yTn2BNow=
X-Received: from pjbsb15.prod.google.com ([2002:a17:90b:50cf:b0:2eb:12d7:fedd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:54c4:b0:2ea:3f34:f18f
 with SMTP id 98e67ed59e1d1-2ee08ecd358mr6548081a91.19.1732757771755; Wed, 27
 Nov 2024 17:36:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:34:24 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-58-seanjc@google.com>
Subject: [PATCH v3 57/57] KVM: x86: Use only local variables (no bitmask) to
 init kvm_cpu_caps
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

Refactor the kvm_cpu_cap_init() macro magic to collect supported features
in a local variable instead of passing them to the macro as a "mask".  As
pointed out by Maxim, relying on macros to "return" a value and set local
variables is surprising, as the bitwise-OR logic suggests the macros are
pure, i.e. have no side effects.

Ideally, the feature initializers would have zero side effects, e.g. would
take local variables as params, but there isn't a sane way to do so
without either sacrificing the various compile-time assertions (basically
a non-starter), or passing at least one variable, e.g. a struct, to each
macro usage (adds a lot of noise and boilerplate code).

Opportunistically force callers to emit a trailing comma by intentionally
omitting a semicolon after invoking the feature initializers.  Forcing a
trailing comma isotales futures changes to a single line, i.e. doesn't
cause churn for unrelated features/lines when adding/removing/modifying a
feature.

No functional change intended.

Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 541 ++++++++++++++++++++++---------------------
 1 file changed, 273 insertions(+), 268 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index e03154b9833f..572dfa7e206e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -661,7 +661,7 @@ static __always_inline u32 raw_cpuid_get(struct cpuid_reg cpuid)
  * capabilities as well as raw CPUID.  For KVM-defined leafs, consult only raw
  * CPUID, as KVM is the one and only authority (in the kernel).
  */
-#define kvm_cpu_cap_init(leaf, mask)					\
+#define kvm_cpu_cap_init(leaf, feature_initializers...)			\
 do {									\
 	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);	\
 	const u32 __maybe_unused kvm_cpu_cap_init_in_progress = leaf;	\
@@ -669,8 +669,11 @@ do {									\
 	u32 kvm_cpu_cap_passthrough = 0;				\
 	u32 kvm_cpu_cap_synthesized = 0;				\
 	u32 kvm_cpu_cap_emulated = 0;					\
+	u32 kvm_cpu_cap_features = 0;					\
 									\
-	kvm_cpu_caps[leaf] = (mask);					\
+	feature_initializers						\
+									\
+	kvm_cpu_caps[leaf] = kvm_cpu_cap_features;			\
 									\
 	if (leaf < NCAPINTS)						\
 		kvm_cpu_caps[leaf] &= kernel_cpu_caps[leaf];		\
@@ -696,7 +699,7 @@ do {									\
 #define F(name)							\
 ({								\
 	KVM_VALIDATE_CPU_CAP_USAGE(name);			\
-	feature_bit(name);					\
+	kvm_cpu_cap_features |= feature_bit(name);		\
 })
 
 /* Scattered Flag - For features that are scattered by cpufeatures.h. */
@@ -704,14 +707,16 @@ do {									\
 ({								\
 	BUILD_BUG_ON(X86_FEATURE_##name >= MAX_CPU_FEATURES);	\
 	KVM_VALIDATE_CPU_CAP_USAGE(name);			\
-	(boot_cpu_has(X86_FEATURE_##name) ? F(name) : 0);	\
+	if (boot_cpu_has(X86_FEATURE_##name))			\
+		F(name);					\
 })
 
 /* Features that KVM supports only on 64-bit kernels. */
 #define X86_64_F(name)						\
 ({								\
 	KVM_VALIDATE_CPU_CAP_USAGE(name);			\
-	(IS_ENABLED(CONFIG_X86_64) ? F(name) : 0);		\
+	if (IS_ENABLED(CONFIG_X86_64))				\
+		F(name);					\
 })
 
 /*
@@ -720,7 +725,7 @@ do {									\
  */
 #define EMULATED_F(name)					\
 ({								\
-	kvm_cpu_cap_emulated |= F(name);			\
+	kvm_cpu_cap_emulated |= feature_bit(name);		\
 	F(name);						\
 })
 
@@ -731,7 +736,7 @@ do {									\
  */
 #define SYNTHESIZED_F(name)					\
 ({								\
-	kvm_cpu_cap_synthesized |= F(name);			\
+	kvm_cpu_cap_synthesized |= feature_bit(name);		\
 	F(name);						\
 })
 
@@ -743,7 +748,7 @@ do {									\
  */
 #define PASSTHROUGH_F(name)					\
 ({								\
-	kvm_cpu_cap_passthrough |= F(name);			\
+	kvm_cpu_cap_passthrough |= feature_bit(name);		\
 	F(name);						\
 })
 
@@ -755,7 +760,7 @@ do {									\
 ({										\
 	BUILD_BUG_ON(__feature_leaf(X86_FEATURE_##name) != CPUID_1_EDX);	\
 	BUILD_BUG_ON(kvm_cpu_cap_init_in_progress != CPUID_8000_0001_EDX);	\
-	feature_bit(name);							\
+	kvm_cpu_cap_features |= feature_bit(name);				\
 })
 
 /*
@@ -765,7 +770,6 @@ do {									\
 #define VENDOR_F(name)						\
 ({								\
 	KVM_VALIDATE_CPU_CAP_USAGE(name);			\
-	0;							\
 })
 
 /*
@@ -775,7 +779,6 @@ do {									\
 #define RUNTIME_F(name)						\
 ({								\
 	KVM_VALIDATE_CPU_CAP_USAGE(name);			\
-	0;							\
 })
 
 /*
@@ -795,126 +798,128 @@ void kvm_set_cpu_caps(void)
 		     sizeof(boot_cpu_data.x86_capability));
 
 	kvm_cpu_cap_init(CPUID_1_ECX,
-		F(XMM3) |
-		F(PCLMULQDQ) |
-		VENDOR_F(DTES64) |
+		F(XMM3),
+		F(PCLMULQDQ),
+		VENDOR_F(DTES64),
 		/*
 		 * NOTE: MONITOR (and MWAIT) are emulated as NOP, but *not*
 		 * advertised to guests via CPUID!  MWAIT is also technically a
 		 * runtime flag thanks to IA32_MISC_ENABLES; mark it as such so
 		 * that KVM is aware that it's a known, unadvertised flag.
 		 */
-		RUNTIME_F(MWAIT) |
-		VENDOR_F(VMX) |
-		0 /* DS-CPL, SMX, EST */ |
-		0 /* TM2 */ |
-		F(SSSE3) |
-		0 /* CNXT-ID */ |
-		0 /* Reserved */ |
-		F(FMA) |
-		F(CX16) |
-		0 /* xTPR Update */ |
-		F(PDCM) |
-		F(PCID) |
-		0 /* Reserved, DCA */ |
-		F(XMM4_1) |
-		F(XMM4_2) |
-		EMULATED_F(X2APIC) |
-		F(MOVBE) |
-		F(POPCNT) |
-		EMULATED_F(TSC_DEADLINE_TIMER) |
-		F(AES) |
-		F(XSAVE) |
-		RUNTIME_F(OSXSAVE) |
-		F(AVX) |
-		F(F16C) |
-		F(RDRAND) |
-		EMULATED_F(HYPERVISOR)
+		RUNTIME_F(MWAIT),
+		/* DS-CPL */
+		VENDOR_F(VMX),
+		/* SMX, EST */
+		/* TM2 */
+		F(SSSE3),
+		/* CNXT-ID */
+		/* Reserved */
+		F(FMA),
+		F(CX16),
+		/* xTPR Update */
+		F(PDCM),
+		F(PCID),
+		/* Reserved, DCA */
+		F(XMM4_1),
+		F(XMM4_2),
+		EMULATED_F(X2APIC),
+		F(MOVBE),
+		F(POPCNT),
+		EMULATED_F(TSC_DEADLINE_TIMER),
+		F(AES),
+		F(XSAVE),
+		RUNTIME_F(OSXSAVE),
+		F(AVX),
+		F(F16C),
+		F(RDRAND),
+		EMULATED_F(HYPERVISOR),
 	);
 
 	kvm_cpu_cap_init(CPUID_1_EDX,
-		F(FPU) |
-		F(VME) |
-		F(DE) |
-		F(PSE) |
-		F(TSC) |
-		F(MSR) |
-		F(PAE) |
-		F(MCE) |
-		F(CX8) |
-		F(APIC) |
-		0 /* Reserved */ |
-		F(SEP) |
-		F(MTRR) |
-		F(PGE) |
-		F(MCA) |
-		F(CMOV) |
-		F(PAT) |
-		F(PSE36) |
-		0 /* PSN */ |
-		F(CLFLUSH) |
-		0 /* Reserved */ |
-		VENDOR_F(DS) |
-		0 /* ACPI */ |
-		F(MMX) |
-		F(FXSR) |
-		F(XMM) |
-		F(XMM2) |
-		F(SELFSNOOP) |
-		0 /* HTT, TM, Reserved, PBE */
+		F(FPU),
+		F(VME),
+		F(DE),
+		F(PSE),
+		F(TSC),
+		F(MSR),
+		F(PAE),
+		F(MCE),
+		F(CX8),
+		F(APIC),
+		/* Reserved */
+		F(SEP),
+		F(MTRR),
+		F(PGE),
+		F(MCA),
+		F(CMOV),
+		F(PAT),
+		F(PSE36),
+		/* PSN */
+		F(CLFLUSH),
+		/* Reserved */
+		VENDOR_F(DS),
+		/* ACPI */
+		F(MMX),
+		F(FXSR),
+		F(XMM),
+		F(XMM2),
+		F(SELFSNOOP),
+		/* HTT, TM, Reserved, PBE */
 	);
 
 	kvm_cpu_cap_init(CPUID_7_0_EBX,
-		F(FSGSBASE) |
-		EMULATED_F(TSC_ADJUST) |
-		F(SGX) |
-		F(BMI1) |
-		F(HLE) |
-		F(AVX2) |
-		F(FDP_EXCPTN_ONLY) |
-		F(SMEP) |
-		F(BMI2) |
-		F(ERMS) |
-		F(INVPCID) |
-		F(RTM) |
-		F(ZERO_FCS_FDS) |
-		VENDOR_F(MPX) |
-		F(AVX512F) |
-		F(AVX512DQ) |
-		F(RDSEED) |
-		F(ADX) |
-		F(SMAP) |
-		F(AVX512IFMA) |
-		F(CLFLUSHOPT) |
-		F(CLWB) |
-		VENDOR_F(INTEL_PT) |
-		F(AVX512PF) |
-		F(AVX512ER) |
-		F(AVX512CD) |
-		F(SHA_NI) |
-		F(AVX512BW) |
-		F(AVX512VL));
+		F(FSGSBASE),
+		EMULATED_F(TSC_ADJUST),
+		F(SGX),
+		F(BMI1),
+		F(HLE),
+		F(AVX2),
+		F(FDP_EXCPTN_ONLY),
+		F(SMEP),
+		F(BMI2),
+		F(ERMS),
+		F(INVPCID),
+		F(RTM),
+		F(ZERO_FCS_FDS),
+		VENDOR_F(MPX),
+		F(AVX512F),
+		F(AVX512DQ),
+		F(RDSEED),
+		F(ADX),
+		F(SMAP),
+		F(AVX512IFMA),
+		F(CLFLUSHOPT),
+		F(CLWB),
+		VENDOR_F(INTEL_PT),
+		F(AVX512PF),
+		F(AVX512ER),
+		F(AVX512CD),
+		F(SHA_NI),
+		F(AVX512BW),
+		F(AVX512VL),
+	);
 
 	kvm_cpu_cap_init(CPUID_7_ECX,
-		F(AVX512VBMI) |
-		PASSTHROUGH_F(LA57) |
-		F(PKU) |
-		RUNTIME_F(OSPKE) |
-		F(RDPID) |
-		F(AVX512_VPOPCNTDQ) |
-		F(UMIP) |
-		F(AVX512_VBMI2) |
-		F(GFNI) |
-		F(VAES) |
-		F(VPCLMULQDQ) |
-		F(AVX512_VNNI) |
-		F(AVX512_BITALG) |
-		F(CLDEMOTE) |
-		F(MOVDIRI) |
-		F(MOVDIR64B) |
-		VENDOR_F(WAITPKG) |
-		F(SGX_LC) |
-		F(BUS_LOCK_DETECT)
+		F(AVX512VBMI),
+		PASSTHROUGH_F(LA57),
+		F(PKU),
+		RUNTIME_F(OSPKE),
+		F(RDPID),
+		F(AVX512_VPOPCNTDQ),
+		F(UMIP),
+		F(AVX512_VBMI2),
+		F(GFNI),
+		F(VAES),
+		F(VPCLMULQDQ),
+		F(AVX512_VNNI),
+		F(AVX512_BITALG),
+		F(CLDEMOTE),
+		F(MOVDIRI),
+		F(MOVDIR64B),
+		VENDOR_F(WAITPKG),
+		F(SGX_LC),
+		F(BUS_LOCK_DETECT),
 	);
 
 	/*
@@ -925,22 +930,22 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_clear(X86_FEATURE_PKU);
 
 	kvm_cpu_cap_init(CPUID_7_EDX,
-		F(AVX512_4VNNIW) |
-		F(AVX512_4FMAPS) |
-		F(SPEC_CTRL) |
-		F(SPEC_CTRL_SSBD) |
-		EMULATED_F(ARCH_CAPABILITIES) |
-		F(INTEL_STIBP) |
-		F(MD_CLEAR) |
-		F(AVX512_VP2INTERSECT) |
-		F(FSRM) |
-		F(SERIALIZE) |
-		F(TSXLDTRK) |
-		F(AVX512_FP16) |
-		F(AMX_TILE) |
-		F(AMX_INT8) |
-		F(AMX_BF16) |
-		F(FLUSH_L1D)
+		F(AVX512_4VNNIW),
+		F(AVX512_4FMAPS),
+		F(SPEC_CTRL),
+		F(SPEC_CTRL_SSBD),
+		EMULATED_F(ARCH_CAPABILITIES),
+		F(INTEL_STIBP),
+		F(MD_CLEAR),
+		F(AVX512_VP2INTERSECT),
+		F(FSRM),
+		F(SERIALIZE),
+		F(TSXLDTRK),
+		F(AVX512_FP16),
+		F(AMX_TILE),
+		F(AMX_INT8),
+		F(AMX_BF16),
+		F(FLUSH_L1D),
 	);
 
 	if (boot_cpu_has(X86_FEATURE_AMD_IBPB_RET) &&
@@ -953,132 +958,132 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
 
 	kvm_cpu_cap_init(CPUID_7_1_EAX,
-		F(SHA512) |
-		F(SM3) |
-		F(SM4) |
-		F(AVX_VNNI) |
-		F(AVX512_BF16) |
-		F(CMPCCXADD) |
-		F(FZRM) |
-		F(FSRS) |
-		F(FSRC) |
-		F(AMX_FP16) |
-		F(AVX_IFMA) |
-		F(LAM)
+		F(SHA512),
+		F(SM3),
+		F(SM4),
+		F(AVX_VNNI),
+		F(AVX512_BF16),
+		F(CMPCCXADD),
+		F(FZRM),
+		F(FSRS),
+		F(FSRC),
+		F(AMX_FP16),
+		F(AVX_IFMA),
+		F(LAM),
 	);
 
 	kvm_cpu_cap_init(CPUID_7_1_EDX,
-		F(AVX_VNNI_INT8) |
-		F(AVX_NE_CONVERT) |
-		F(AMX_COMPLEX) |
-		F(AVX_VNNI_INT16) |
-		F(PREFETCHITI) |
-		F(AVX10)
+		F(AVX_VNNI_INT8),
+		F(AVX_NE_CONVERT),
+		F(AMX_COMPLEX),
+		F(AVX_VNNI_INT16),
+		F(PREFETCHITI),
+		F(AVX10),
 	);
 
 	kvm_cpu_cap_init(CPUID_7_2_EDX,
-		F(INTEL_PSFD) |
-		F(IPRED_CTRL) |
-		F(RRSBA_CTRL) |
-		F(DDPD_U) |
-		F(BHI_CTRL) |
-		F(MCDT_NO)
+		F(INTEL_PSFD),
+		F(IPRED_CTRL),
+		F(RRSBA_CTRL),
+		F(DDPD_U),
+		F(BHI_CTRL),
+		F(MCDT_NO),
 	);
 
 	kvm_cpu_cap_init(CPUID_D_1_EAX,
-		F(XSAVEOPT) |
-		F(XSAVEC) |
-		F(XGETBV1) |
-		F(XSAVES) |
-		X86_64_F(XFD)
+		F(XSAVEOPT),
+		F(XSAVEC),
+		F(XGETBV1),
+		F(XSAVES),
+		X86_64_F(XFD),
 	);
 
 	kvm_cpu_cap_init(CPUID_12_EAX,
-		SCATTERED_F(SGX1) |
-		SCATTERED_F(SGX2) |
-		SCATTERED_F(SGX_EDECCSSA)
+		SCATTERED_F(SGX1),
+		SCATTERED_F(SGX2),
+		SCATTERED_F(SGX_EDECCSSA),
 	);
 
 	kvm_cpu_cap_init(CPUID_24_0_EBX,
-		F(AVX10_128) |
-		F(AVX10_256) |
-		F(AVX10_512)
+		F(AVX10_128),
+		F(AVX10_256),
+		F(AVX10_512),
 	);
 
 	kvm_cpu_cap_init(CPUID_8000_0001_ECX,
-		F(LAHF_LM) |
-		F(CMP_LEGACY) |
-		VENDOR_F(SVM) |
-		0 /* ExtApicSpace */ |
-		F(CR8_LEGACY) |
-		F(ABM) |
-		F(SSE4A) |
-		F(MISALIGNSSE) |
-		F(3DNOWPREFETCH) |
-		F(OSVW) |
-		0 /* IBS */ |
-		F(XOP) |
-		0 /* SKINIT, WDT, LWP */ |
-		F(FMA4) |
-		F(TBM) |
-		F(TOPOEXT) |
-		VENDOR_F(PERFCTR_CORE)
+		F(LAHF_LM),
+		F(CMP_LEGACY),
+		VENDOR_F(SVM),
+		/* ExtApicSpace */
+		F(CR8_LEGACY),
+		F(ABM),
+		F(SSE4A),
+		F(MISALIGNSSE),
+		F(3DNOWPREFETCH),
+		F(OSVW),
+		/* IBS */
+		F(XOP),
+		/* SKINIT, WDT, LWP */
+		F(FMA4),
+		F(TBM),
+		F(TOPOEXT),
+		VENDOR_F(PERFCTR_CORE),
 	);
 
 	kvm_cpu_cap_init(CPUID_8000_0001_EDX,
-		ALIASED_1_EDX_F(FPU) |
-		ALIASED_1_EDX_F(VME) |
-		ALIASED_1_EDX_F(DE) |
-		ALIASED_1_EDX_F(PSE) |
-		ALIASED_1_EDX_F(TSC) |
-		ALIASED_1_EDX_F(MSR) |
-		ALIASED_1_EDX_F(PAE) |
-		ALIASED_1_EDX_F(MCE) |
-		ALIASED_1_EDX_F(CX8) |
-		ALIASED_1_EDX_F(APIC) |
-		0 /* Reserved */ |
-		F(SYSCALL) |
-		ALIASED_1_EDX_F(MTRR) |
-		ALIASED_1_EDX_F(PGE) |
-		ALIASED_1_EDX_F(MCA) |
-		ALIASED_1_EDX_F(CMOV) |
-		ALIASED_1_EDX_F(PAT) |
-		ALIASED_1_EDX_F(PSE36) |
-		0 /* Reserved */ |
-		F(NX) |
-		0 /* Reserved */ |
-		F(MMXEXT) |
-		ALIASED_1_EDX_F(MMX) |
-		ALIASED_1_EDX_F(FXSR) |
-		F(FXSR_OPT) |
-		X86_64_F(GBPAGES) |
-		F(RDTSCP) |
-		0 /* Reserved */ |
-		X86_64_F(LM) |
-		F(3DNOWEXT) |
-		F(3DNOW)
+		ALIASED_1_EDX_F(FPU),
+		ALIASED_1_EDX_F(VME),
+		ALIASED_1_EDX_F(DE),
+		ALIASED_1_EDX_F(PSE),
+		ALIASED_1_EDX_F(TSC),
+		ALIASED_1_EDX_F(MSR),
+		ALIASED_1_EDX_F(PAE),
+		ALIASED_1_EDX_F(MCE),
+		ALIASED_1_EDX_F(CX8),
+		ALIASED_1_EDX_F(APIC),
+		/* Reserved */
+		F(SYSCALL),
+		ALIASED_1_EDX_F(MTRR),
+		ALIASED_1_EDX_F(PGE),
+		ALIASED_1_EDX_F(MCA),
+		ALIASED_1_EDX_F(CMOV),
+		ALIASED_1_EDX_F(PAT),
+		ALIASED_1_EDX_F(PSE36),
+		/* Reserved */
+		F(NX),
+		/* Reserved */
+		F(MMXEXT),
+		ALIASED_1_EDX_F(MMX),
+		ALIASED_1_EDX_F(FXSR),
+		F(FXSR_OPT),
+		X86_64_F(GBPAGES),
+		F(RDTSCP),
+		/* Reserved */
+		X86_64_F(LM),
+		F(3DNOWEXT),
+		F(3DNOW),
 	);
 
 	if (!tdp_enabled && IS_ENABLED(CONFIG_X86_64))
 		kvm_cpu_cap_set(X86_FEATURE_GBPAGES);
 
 	kvm_cpu_cap_init(CPUID_8000_0007_EDX,
-		SCATTERED_F(CONSTANT_TSC)
+		SCATTERED_F(CONSTANT_TSC),
 	);
 
 	kvm_cpu_cap_init(CPUID_8000_0008_EBX,
-		F(CLZERO) |
-		F(XSAVEERPTR) |
-		F(WBNOINVD) |
-		F(AMD_IBPB) |
-		F(AMD_IBRS) |
-		F(AMD_SSBD) |
-		F(VIRT_SSBD) |
-		F(AMD_SSB_NO) |
-		F(AMD_STIBP) |
-		F(AMD_STIBP_ALWAYS_ON) |
-		F(AMD_PSFD) |
-		F(AMD_IBPB_RET)
+		F(CLZERO),
+		F(XSAVEERPTR),
+		F(WBNOINVD),
+		F(AMD_IBPB),
+		F(AMD_IBRS),
+		F(AMD_SSBD),
+		F(VIRT_SSBD),
+		F(AMD_SSB_NO),
+		F(AMD_STIBP),
+		F(AMD_STIBP_ALWAYS_ON),
+		F(AMD_PSFD),
+		F(AMD_IBPB_RET),
 	);
 
 	/*
@@ -1110,30 +1115,30 @@ void kvm_set_cpu_caps(void)
 
 	/* All SVM features required additional vendor module enabling. */
 	kvm_cpu_cap_init(CPUID_8000_000A_EDX,
-		VENDOR_F(NPT) |
-		VENDOR_F(VMCBCLEAN) |
-		VENDOR_F(FLUSHBYASID) |
-		VENDOR_F(NRIPS) |
-		VENDOR_F(TSCRATEMSR) |
-		VENDOR_F(V_VMSAVE_VMLOAD) |
-		VENDOR_F(LBRV) |
-		VENDOR_F(PAUSEFILTER) |
-		VENDOR_F(PFTHRESHOLD) |
-		VENDOR_F(VGIF) |
-		VENDOR_F(VNMI) |
-		VENDOR_F(SVME_ADDR_CHK)
+		VENDOR_F(NPT),
+		VENDOR_F(VMCBCLEAN),
+		VENDOR_F(FLUSHBYASID),
+		VENDOR_F(NRIPS),
+		VENDOR_F(TSCRATEMSR),
+		VENDOR_F(V_VMSAVE_VMLOAD),
+		VENDOR_F(LBRV),
+		VENDOR_F(PAUSEFILTER),
+		VENDOR_F(PFTHRESHOLD),
+		VENDOR_F(VGIF),
+		VENDOR_F(VNMI),
+		VENDOR_F(SVME_ADDR_CHK),
 	);
 
 	kvm_cpu_cap_init(CPUID_8000_001F_EAX,
-		VENDOR_F(SME) |
-		VENDOR_F(SEV) |
-		0 /* VM_PAGE_FLUSH */ |
-		VENDOR_F(SEV_ES) |
-		F(SME_COHERENT)
+		VENDOR_F(SME),
+		VENDOR_F(SEV),
+		/* VM_PAGE_FLUSH */
+		VENDOR_F(SEV_ES),
+		F(SME_COHERENT),
 	);
 
 	kvm_cpu_cap_init(CPUID_8000_0021_EAX,
-		F(NO_NESTED_DATA_BP) |
+		F(NO_NESTED_DATA_BP),
 		/*
 		 * Synthesize "LFENCE is serializing" into the AMD-defined entry
 		 * in KVM's supported CPUID, i.e. if the feature is reported as
@@ -1144,36 +1149,36 @@ void kvm_set_cpu_caps(void)
 		 * CPUID will drop the flags, and reporting support in AMD's
 		 * leaf can make it easier for userspace to detect the feature.
 		 */
-		SYNTHESIZED_F(LFENCE_RDTSC) |
-		0 /* SmmPgCfgLock */ |
-		F(NULL_SEL_CLR_BASE) |
-		F(AUTOIBRS) |
-		EMULATED_F(NO_SMM_CTL_MSR) |
-		0 /* PrefetchCtlMsr */ |
-		F(WRMSR_XX_BASE_NS) |
-		SYNTHESIZED_F(SBPB) |
-		SYNTHESIZED_F(IBPB_BRTYPE) |
-		SYNTHESIZED_F(SRSO_NO)
+		SYNTHESIZED_F(LFENCE_RDTSC),
+		/* SmmPgCfgLock */
+		F(NULL_SEL_CLR_BASE),
+		F(AUTOIBRS),
+		EMULATED_F(NO_SMM_CTL_MSR),
+		/* PrefetchCtlMsr */
+		F(WRMSR_XX_BASE_NS),
+		SYNTHESIZED_F(SBPB),
+		SYNTHESIZED_F(IBPB_BRTYPE),
+		SYNTHESIZED_F(SRSO_NO),
 	);
 
 	kvm_cpu_cap_init(CPUID_8000_0022_EAX,
-		F(PERFMON_V2)
+		F(PERFMON_V2),
 	);
 
 	if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
 		kvm_cpu_cap_set(X86_FEATURE_NULL_SEL_CLR_BASE);
 
 	kvm_cpu_cap_init(CPUID_C000_0001_EDX,
-		F(XSTORE) |
-		F(XSTORE_EN) |
-		F(XCRYPT) |
-		F(XCRYPT_EN) |
-		F(ACE2) |
-		F(ACE2_EN) |
-		F(PHE) |
-		F(PHE_EN) |
-		F(PMM) |
-		F(PMM_EN)
+		F(XSTORE),
+		F(XSTORE_EN),
+		F(XCRYPT),
+		F(XCRYPT_EN),
+		F(ACE2),
+		F(ACE2_EN),
+		F(PHE),
+		F(PHE_EN),
+		F(PMM),
+		F(PMM_EN),
 	);
 
 	/*
-- 
2.47.0.338.g60cca15819-goog


