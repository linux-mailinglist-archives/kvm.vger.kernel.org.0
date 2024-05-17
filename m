Return-Path: <kvm+bounces-17678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EDF328C8B7C
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:48:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D4901C20B77
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:48:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A4B713E889;
	Fri, 17 May 2024 17:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rHqiOYdp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261CA152189
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967635; cv=none; b=DE1xFeHOOk3GiqrEqV5eJj5UCxob3i/k1lm9Q90X1nV3MZAbitdyVJ8hGjQeaWybCHRFeQDXlDX9c/dB8k7YoPXqIZ5vPwak8mVyjSU3Pv4eyrul+b9GAr8RcFpiqlriZqHYNwNvrW8eRkHmwjVHoIXwg0/Rh5TM23rix6lgiP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967635; c=relaxed/simple;
	bh=oxejklLlbBEENy3IfZNQJ8hlgrGXAQmHeztU44XlEA4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AFXlGIHZc99LwAFM5sei6RoJtOC2ElRCM0ITkvFRJvayMlQKgnpMwB56rvdkhP1wRrm2zuhnbkldDjPXy0Nv062Ff6rH669RhpbkH5SmtN9bq3QGJx9ouIgN0QHqg8pTE9Nv040zNOLs4TPfmDLbrVmfg6aInN+QCsv/aMaAJOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rHqiOYdp; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-df1cfa720aaso5479434276.2
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967633; x=1716572433; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IIpzTjnpYWvr4z4L+FkXXo9hR1khs/BwnW5TGVqv/IQ=;
        b=rHqiOYdpjW6Lwf3LFpflpCO//4QrXb0oRLwNT1VG9kmvFlr+BzVQdGNJyARlNoWgS3
         lmfSqI5jQrasik/h3zrJyvI0/awwKhl0KlzY6JDD1pJLkhS5+SoYG7G9L9qxilotphac
         J3zWUMHP9rqvNytL8R3EN5E4kYmYL29EtJqawyyV2xtNNkvLScVloEJHqrf+KPCpd6fH
         gLnru4I4/YlekCs3co+ETL3kZ1chp4+zkUTqYVReCKA/toZJsTwERVs0AfZ1+Nn9wBXX
         m7KYGUrDL2o7XplkQSpGrJwKQ4o80yZSNaM9KXR2PS0Ozhh3OeqGoDhljYW76DBLooVV
         DN4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967633; x=1716572433;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IIpzTjnpYWvr4z4L+FkXXo9hR1khs/BwnW5TGVqv/IQ=;
        b=g0K2ubI0G33SBikDbXAsmF5Rl3ReExM/WXlaZKRIt3gA7y95jPa564X40z5RjxW7VE
         1l9+XkS4p1l0jibkBMdd1RNf1aEAzg5jQ0tfLGjZWZxbrSmNW/7cKFf4O28EoSKXI37U
         m0o20ly+H7F/+0GFGe5FuedvpK5EUDEkhFd4NR9ljm0NFyIK25LaRCFD4iA/dLNaTUdP
         cQdacux+9R9raDaCB8TOuxFDlzNDC0298kVNWTTjVgnoYEFtWik6apA8qjw+0sio4LNy
         4ehKizwORnB/6TUkgh1blZaye8pJpnGlgmgHFn092PJohb8WJyBtyKx/nNoCtmAkYIoh
         BTTA==
X-Gm-Message-State: AOJu0YxWapralALR/xT+8qZ2a7pzGvYW3t4cIMclePUyYjKWEP3jN/Iu
	d9OJKsvBij9iy70y3Ze4qVuauV6vcuXMKBtjJke/3yKvR7Z/86BcYUe5ukpYCHPMRkfwfKljphu
	WOA==
X-Google-Smtp-Source: AGHT+IHcMIoOJ01ehqIHGlvwd0sggE3znPLNKcQXWO67WrF3qyfm+l3LvlnPUSRXbx688hga9I6i/VG+rfQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:70a:b0:dee:615c:ac3a with SMTP id
 3f1490d57ef6-dee615cb53fmr1728101276.5.1715967633201; Fri, 17 May 2024
 10:40:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:39:03 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-27-seanjc@google.com>
Subject: [PATCH v2 26/49] KVM: x86: Add a macro to init CPUID features that
 KVM emulates in software
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
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
 arch/x86/kvm/cpuid.c | 36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 1064e4d68718..33e3e77de1b7 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -94,6 +94,16 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
 	F(name);						\
 })
 
+/*
+ * Emulated Feature - For features that KVM emulates in software irrespective
+ * of host CPU/kernel support.
+ */
+#define EMUL_F(name)						\
+({								\
+	kvm_cpu_cap_emulated |= F(name);			\
+	F(name);						\
+})
+
 /*
  * Aliased Features - For features in 0x8000_0001.EDX that are duplicates of
  * identical 0x1.EDX features, and thus are aliased from 0x1 to 0x8000_0001.
@@ -649,6 +659,7 @@ do {									\
 do {									\
 	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);	\
 	const u32 __maybe_unused kvm_cpu_cap_init_in_progress = leaf;	\
+	u32 kvm_cpu_cap_emulated = 0;					\
 									\
 	if (leaf < NCAPINTS)						\
 		kvm_cpu_caps[leaf] &= (mask);				\
@@ -656,6 +667,7 @@ do {									\
 		kvm_cpu_caps[leaf] = (mask);				\
 									\
 	kvm_cpu_caps[leaf] &= raw_cpuid_get(cpuid);			\
+	kvm_cpu_caps[leaf] |= kvm_cpu_cap_emulated;			\
 } while (0)
 
 /*
@@ -684,12 +696,10 @@ void kvm_set_cpu_caps(void)
 		0 /* TM2 */ | F(SSSE3) | 0 /* CNXT-ID */ | 0 /* Reserved */ |
 		F(FMA) | F(CX16) | 0 /* xTPR Update */ | F(PDCM) |
 		F(PCID) | 0 /* Reserved, DCA */ | F(XMM4_1) |
-		F(XMM4_2) | F(X2APIC) | F(MOVBE) | F(POPCNT) |
+		F(XMM4_2) | EMUL_F(X2APIC) | F(MOVBE) | F(POPCNT) |
 		0 /* Reserved*/ | F(AES) | F(XSAVE) | 0 /* OSXSAVE */ | F(AVX) |
 		F(F16C) | F(RDRAND)
 	);
-	/* KVM emulates x2apic in software irrespective of host support. */
-	kvm_cpu_cap_set(X86_FEATURE_X2APIC);
 
 	kvm_cpu_cap_init(CPUID_1_EDX,
 		F(FPU) | F(VME) | F(DE) | F(PSE) |
@@ -703,13 +713,13 @@ void kvm_set_cpu_caps(void)
 	);
 
 	kvm_cpu_cap_init(CPUID_7_0_EBX,
-		F(FSGSBASE) | F(SGX) | F(BMI1) | F(HLE) | F(AVX2) |
-		F(FDP_EXCPTN_ONLY) | F(SMEP) | F(BMI2) | F(ERMS) | F(INVPCID) |
-		F(RTM) | F(ZERO_FCS_FDS) | 0 /*MPX*/ | F(AVX512F) |
-		F(AVX512DQ) | F(RDSEED) | F(ADX) | F(SMAP) | F(AVX512IFMA) |
-		F(CLFLUSHOPT) | F(CLWB) | 0 /*INTEL_PT*/ | F(AVX512PF) |
-		F(AVX512ER) | F(AVX512CD) | F(SHA_NI) | F(AVX512BW) |
-		F(AVX512VL));
+		F(FSGSBASE) | EMUL_F(TSC_ADJUST) | F(SGX) | F(BMI1) | F(HLE) |
+		F(AVX2) | F(FDP_EXCPTN_ONLY) | F(SMEP) | F(BMI2) | F(ERMS) |
+		F(INVPCID) | F(RTM) | F(ZERO_FCS_FDS) | 0 /*MPX*/ |
+		F(AVX512F) | F(AVX512DQ) | F(RDSEED) | F(ADX) | F(SMAP) |
+		F(AVX512IFMA) | F(CLFLUSHOPT) | F(CLWB) | 0 /*INTEL_PT*/ |
+		F(AVX512PF) | F(AVX512ER) | F(AVX512CD) | F(SHA_NI) |
+		F(AVX512BW) | F(AVX512VL));
 
 	kvm_cpu_cap_init(CPUID_7_ECX,
 		F(AVX512VBMI) | RAW_F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
@@ -728,16 +738,12 @@ void kvm_set_cpu_caps(void)
 
 	kvm_cpu_cap_init(CPUID_7_EDX,
 		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
-		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
+		F(SPEC_CTRL_SSBD) | EMUL_F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
 		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
 		F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16) |
 		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16) | F(FLUSH_L1D)
 	);
 
-	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
-	kvm_cpu_cap_set(X86_FEATURE_TSC_ADJUST);
-	kvm_cpu_cap_set(X86_FEATURE_ARCH_CAPABILITIES);
-
 	if (boot_cpu_has(X86_FEATURE_IBPB) && boot_cpu_has(X86_FEATURE_IBRS))
 		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL);
 	if (boot_cpu_has(X86_FEATURE_STIBP))
-- 
2.45.0.215.g3402c0e53f-goog


