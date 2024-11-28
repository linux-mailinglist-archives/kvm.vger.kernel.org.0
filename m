Return-Path: <kvm+bounces-32681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A53129DB102
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:42:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EB1F4B258A7
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:42:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 512791B6D09;
	Thu, 28 Nov 2024 01:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pra0+OPq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122311B2195
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757726; cv=none; b=srCvkrhytoY0OtOkp6AXbg+Xj30JpxYZlhxKjJoj+mIR0te7mA/PJ37jQeJ+kIUfRdhP9/CJOE7TUM2VzPhNKBeq+f3kyejRHSEEzzW8Aowv2nR4gc/MqVzy1XYZXoMioOXW5ThEVoGCn1VEgE0/ZDMUaRD5rtgKmYwEY/DCIi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757726; c=relaxed/simple;
	bh=CSENd+XJitOiA9fbDXgViErMh/qoyOHlWd7MfoxvW/o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FPZst6jRSh5g4fjQHspZBLQISaNNAJY8wxRBItBMSW2ZMVP3W1OIYiaqi0WpruEMN6/d9VT4yoh2sUIzNUj1o9DYZGjUqsdpsBpzhK88yYd03iEZzXVYXSQIxNErDgBmQJdyuq5cY2o3Avx3/kuYNQADZYdxb3uImglNhWgyUqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pra0+OPq; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7250863ae6dso409592b3a.0
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757724; x=1733362524; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=UvbZ1B4Wr5O7Bri/mKSYkZd6PGU5NXNueTFlSlg6Lwk=;
        b=pra0+OPqe7F+FUBMLxMqufrFvp7WhQnU/TKKxIvVAUVMnJWincFdZR4zwPivqYiguo
         B8jMKEIVahknr6anEmQA3GKOJDq1sfc0umn6oKzarqoi9TD5MtmGdlzWxiC1FQocI71M
         SVxwIx8vMCGaJp1cZmH6NirYYsNa3/DT8vkc+EuVzTiHB7Q13lvjAi163t/CU6V/4B2Q
         z4288UJvHBq6XTfngryItmQ13Pk7/kXyno7NZtdMWivxtcRPAjBz3sw9XKbXzmXsVvPC
         y6UpYpZIOigmJQUjSlAgmJv7u7xdH9f1h4QhXlgdBqJYZabOcjYczdp5l/W0ENNKwaMy
         kgQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757724; x=1733362524;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UvbZ1B4Wr5O7Bri/mKSYkZd6PGU5NXNueTFlSlg6Lwk=;
        b=wc0zGEo0BJ8vQcJxh/NMMOPFFPRy36zFsumkjuKkucEnv4wBKeDqplI+3qD5qDgZIj
         DhRH4pTEK/JBbPKFN8u3JF/74qW7gq7yzqebR8Xvji0P3hY0jN3FDcc47Ck0/xqeVR2X
         2x4XOzxXvIE0DAjRFMcCWB/vEeDxMew+42x31NA58sP25F4tPCQ16S/ovArD7j5LsVRl
         iSugH4yjyUKY80Xkj1M0zzyc8RKEm+J1CvQZsYUj/kUFpQV/7EnIsmag/CJup6rdmHUV
         AXLmfxPPmP7aaALfgk/C8rxYkoTfrp5LMwNEqkwSs6/HZGNM4lOssXmEPI78xrxqHjab
         /aLg==
X-Gm-Message-State: AOJu0Yz3miilGNZbgVeMisk6/1x8Vzsn6zFWg9GrepDRm3ITwZm45M4b
	ho0icmH6byOCg3TCmHHzO/JoQ2rbvk3SOZgn0bnYhrMi0hlrSyBYlZiwnNgZqX7YaEbEV9jF4tN
	7ww==
X-Google-Smtp-Source: AGHT+IHV9QmwuyRwYzciUV69VGm2dPXe4apxZvap0v2Nd6+2Be40FvYNy0RfWRQ/vYVt+tU6vHkhOz+mjxg=
X-Received: from pfat12.prod.google.com ([2002:a05:6a00:aa0c:b0:724:eb4b:cd8f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3cc9:b0:724:e80a:330
 with SMTP id d2e1a72fcca58-7252ffd85d9mr8200174b3a.5.1732757724495; Wed, 27
 Nov 2024 17:35:24 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:57 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-31-seanjc@google.com>
Subject: [PATCH v3 30/57] KVM: x86: Add a macro to init CPUID features that
 KVM emulates in software
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

Now that kvm_cpu_cap_init() is a macro with its own scope, add EMUL_F() to
OR-in features that KVM emulates in software, i.e. that don't depend on
the feature being available in hardware.  The contained scope
of kvm_cpu_cap_init() allows using a local variable to track the set of
emulated leaves, which in addition to avoiding confusing and/or
unnecessary variables, helps prevent misuse of EMUL_F().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 9bf324aa5fae..83b29c5a0498 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -611,6 +611,7 @@ do {									\
 	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);	\
 	const u32 __maybe_unused kvm_cpu_cap_init_in_progress = leaf;	\
 	u32 kvm_cpu_cap_passthrough = 0;				\
+	u32 kvm_cpu_cap_emulated = 0;					\
 									\
 	if (leaf < NCAPINTS)						\
 		kvm_cpu_caps[leaf] &= (mask);				\
@@ -619,6 +620,7 @@ do {									\
 									\
 	kvm_cpu_caps[leaf] |= kvm_cpu_cap_passthrough;			\
 	kvm_cpu_caps[leaf] &= raw_cpuid_get(cpuid);			\
+	kvm_cpu_caps[leaf] |= kvm_cpu_cap_emulated;			\
 } while (0)
 
 /*
@@ -654,6 +656,16 @@ do {									\
 	(IS_ENABLED(CONFIG_X86_64) ? F(name) : 0);		\
 })
 
+/*
+ * Emulated Feature - For features that KVM emulates in software irrespective
+ * of host CPU/kernel support.
+ */
+#define EMULATED_F(name)					\
+({								\
+	kvm_cpu_cap_emulated |= F(name);			\
+	F(name);						\
+})
+
 /*
  * Passthrough Feature - For features that KVM supports based purely on raw
  * hardware CPUID, i.e. that KVM virtualizes even if the host kernel doesn't
@@ -715,7 +727,7 @@ void kvm_set_cpu_caps(void)
 		0 /* Reserved, DCA */ |
 		F(XMM4_1) |
 		F(XMM4_2) |
-		F(X2APIC) |
+		EMULATED_F(X2APIC) |
 		F(MOVBE) |
 		F(POPCNT) |
 		0 /* Reserved*/ |
@@ -726,8 +738,6 @@ void kvm_set_cpu_caps(void)
 		F(F16C) |
 		F(RDRAND)
 	);
-	/* KVM emulates x2apic in software irrespective of host support. */
-	kvm_cpu_cap_set(X86_FEATURE_X2APIC);
 
 	kvm_cpu_cap_init(CPUID_1_EDX,
 		F(FPU) |
@@ -761,6 +771,7 @@ void kvm_set_cpu_caps(void)
 
 	kvm_cpu_cap_init(CPUID_7_0_EBX,
 		F(FSGSBASE) |
+		EMULATED_F(TSC_ADJUST) |
 		F(SGX) |
 		F(BMI1) |
 		F(HLE) |
@@ -823,7 +834,7 @@ void kvm_set_cpu_caps(void)
 		F(AVX512_4FMAPS) |
 		F(SPEC_CTRL) |
 		F(SPEC_CTRL_SSBD) |
-		F(ARCH_CAPABILITIES) |
+		EMULATED_F(ARCH_CAPABILITIES) |
 		F(INTEL_STIBP) |
 		F(MD_CLEAR) |
 		F(AVX512_VP2INTERSECT) |
@@ -837,10 +848,6 @@ void kvm_set_cpu_caps(void)
 		F(FLUSH_L1D)
 	);
 
-	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
-	kvm_cpu_cap_set(X86_FEATURE_TSC_ADJUST);
-	kvm_cpu_cap_set(X86_FEATURE_ARCH_CAPABILITIES);
-
 	if (boot_cpu_has(X86_FEATURE_AMD_IBPB_RET) &&
 	    boot_cpu_has(X86_FEATURE_AMD_IBPB) &&
 	    boot_cpu_has(X86_FEATURE_AMD_IBRS))
@@ -1026,6 +1033,7 @@ void kvm_set_cpu_caps(void)
 		0 /* SmmPgCfgLock */ |
 		F(NULL_SEL_CLR_BASE) |
 		F(AUTOIBRS) |
+		EMULATED_F(NO_SMM_CTL_MSR) |
 		0 /* PrefetchCtlMsr */ |
 		F(WRMSR_XX_BASE_NS)
 	);
@@ -1052,7 +1060,6 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_LFENCE_RDTSC);
 	if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
 		kvm_cpu_cap_set(X86_FEATURE_NULL_SEL_CLR_BASE);
-	kvm_cpu_cap_set(X86_FEATURE_NO_SMM_CTL_MSR);
 
 	kvm_cpu_cap_init(CPUID_C000_0001_EDX,
 		F(XSTORE) |
@@ -1087,6 +1094,7 @@ EXPORT_SYMBOL_GPL(kvm_set_cpu_caps);
 #undef F
 #undef SF
 #undef X86_64_F
+#undef EMULATED_F
 #undef PASSTHROUGH_F
 #undef ALIASED_1_EDX_F
 
-- 
2.47.0.338.g60cca15819-goog


