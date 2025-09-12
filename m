Return-Path: <kvm+bounces-57482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B0C5B55A68
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:38:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AB8EFBA32AC
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 23:33:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F2262E718E;
	Fri, 12 Sep 2025 23:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UzdDs0Up"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A35E2E7BD1
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 23:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719477; cv=none; b=RS2endYHWCY0EbSoji8NM1FuOciX/e6jv/wB1GdD4q2GOedm77JrJWTJoujdY4OMc/Q1atrPyn4LdKXheruVsf/GL8UhEc4/RJKTW0D+WNsnfL8Y87umh9V6bfsrAuahWDxGwjwrOJmR3ki9s6cRn/zj9ysGtps9aM935CFedQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719477; c=relaxed/simple;
	bh=2wjGULkmS/6PwRSQm8osqaxXFXmRY0fiL5uBUNzOoGg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZmLpDT3XqG2+nd7zXy+u6uhwTgRBoDUXQ5hVOnv0YQ9ZwbaoNLL7bBmQQl3NRdQRPIbGpdBLL+CfPvVCgIyslh0asnDqzluj1jQx2OY1iheCcRmnZ2K7Qow9r4UPa6RfMMb1bib70WRqFOevsvMP4w/dD3FJLQuoWAQIXXHeb7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UzdDs0Up; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b54ac2658acso1040686a12.1
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 16:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757719475; x=1758324275; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zRTuC+/aMJy18zeUD9dpYx1dSaF5QGiJuAN55i0w7BI=;
        b=UzdDs0Uptb+D/xhaHbru0ON/EqdbgltGXbOqHkt7Zx08pQ9NGx0afOyZAhunYC3i2i
         jQFrUj4O2lvox1CrS+VcRgoOPmTU8sdx4jT48DE6h/LbxuCrdeDe6EXWLfJ2x4MTB6fo
         D73irkEBgoiyTel/sLT1UIXVj+idVGAjCW/TlxQ5N5DhX/UJDUVZkrP8X/XesTUJz9Po
         wUhfJaEta91YpduGThwT/nulg41bIt73IZtIQrWSoSoVhgE9xgiM0pxyir06TM75wjTJ
         F46mK4xCEiEZrXWZjcLlJuttrnhisxOgSqj44ie4jKaLeMgUxeXsfl9v3ErszLU9kXqc
         +0CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719475; x=1758324275;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zRTuC+/aMJy18zeUD9dpYx1dSaF5QGiJuAN55i0w7BI=;
        b=lcx+uNL2arXjNfXx/ISvF9xyy0tOsaGQWvbm4yGOIU7jFXhuXa+hNCXsyuBAGpS6aZ
         7KwEQedF+cp1qUixA/c2CkXTa0Rw89qcOi3j3BHqOK6YkzAfcFu3pQ3Qa9VmN36KckWy
         K3blaT69GbeCxkVBuuVU7MT75BZw2gsiBtJ6kdJS7ZLpSKmTfx4THKwPrByakTWYxIdy
         I9J+PUWhZK0P9uCvJq444k8xpHGIRaV9cwe4h282LLvAGMzBTe4nCWXN1u9vbtw/1EEr
         HvFxA5Y1npF/9fmoCy2AGS7KfXs1a4SmNpFVDMKrWX61ofjyrc+LgGlvbEsAZK0w2WhY
         Wt2g==
X-Gm-Message-State: AOJu0Yxvv5/ctRtkvMz0/Eo/uO3RoKInqA39r7M6sUTGDmemtgPP+Jub
	US+++EwkxU4pUu6XlWjs2m/pBl3cxLAImolx5QJTDpKvnMolQuFWANiyBq0U90EcdglEuGTStRk
	STPpPSQ==
X-Google-Smtp-Source: AGHT+IGsu99kW011YxagBqZtOacoDUyKS0gh7c2D27eBAO6VPWe3gQBMghuflC0M7c+1GCHeLayGgWXbLRo=
X-Received: from pgha19.prod.google.com ([2002:a63:d413:0:b0:b54:ace3:bd08])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7d9f:b0:249:9c7a:7702
 with SMTP id adf61e73a8af0-2602c243603mr6351072637.36.1757719474660; Fri, 12
 Sep 2025 16:24:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Sep 2025 16:23:17 -0700
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912232319.429659-40-seanjc@google.com>
Subject: [PATCH v15 39/41] KVM: selftests: Add coverate for KVM-defined
 registers in MSRs test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Add test coverage for the KVM-defined GUEST_SSP "register" in the MSRs
test.  While _KVM's_ goal is to not tie the uAPI of KVM-defined registers
to any particular internal implementation, i.e. to not commit in uAPI to
handling GUEST_SSP as an MSR, treating GUEST_SSP as an MSR for testing
purposes is a-ok and is a naturally fit given the semantics of SSP.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86/msrs_test.c | 97 ++++++++++++++++++++-
 1 file changed, 94 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/msrs_test.c b/tools/testing/selftests/kvm/x86/msrs_test.c
index 53e155ba15d4..6a956cfe0c65 100644
--- a/tools/testing/selftests/kvm/x86/msrs_test.c
+++ b/tools/testing/selftests/kvm/x86/msrs_test.c
@@ -17,9 +17,10 @@ struct kvm_msr {
 	const u64 write_val;
 	const u64 rsvd_val;
 	const u32 index;
+	const bool is_kvm_defined;
 };
 
-#define ____MSR_TEST(msr, str, val, rsvd, reset, feat, f2)		\
+#define ____MSR_TEST(msr, str, val, rsvd, reset, feat, f2, is_kvm)	\
 {									\
 	.index = msr,							\
 	.name = str,							\
@@ -28,10 +29,11 @@ struct kvm_msr {
 	.reset_val = reset,						\
 	.feature = X86_FEATURE_ ##feat,					\
 	.feature2 = X86_FEATURE_ ##f2,					\
+	.is_kvm_defined = is_kvm,					\
 }
 
 #define __MSR_TEST(msr, str, val, rsvd, reset, feat)			\
-	____MSR_TEST(msr, str, val, rsvd, reset, feat, feat)
+	____MSR_TEST(msr, str, val, rsvd, reset, feat, feat, false)
 
 #define MSR_TEST_NON_ZERO(msr, val, rsvd, reset, feat)			\
 	__MSR_TEST(msr, #msr, val, rsvd, reset, feat)
@@ -40,7 +42,7 @@ struct kvm_msr {
 	__MSR_TEST(msr, #msr, val, rsvd, 0, feat)
 
 #define MSR_TEST2(msr, val, rsvd, feat, f2)				\
-	____MSR_TEST(msr, #msr, val, rsvd, 0, feat, f2)
+	____MSR_TEST(msr, #msr, val, rsvd, 0, feat, f2, false)
 
 /*
  * Note, use a page aligned value for the canonical value so that the value
@@ -51,6 +53,9 @@ static const u64 canonical_val = 0x123456789000ull;
 #define MSR_TEST_CANONICAL(msr, feat)					\
 	__MSR_TEST(msr, #msr, canonical_val, NONCANONICAL, 0, feat)
 
+#define MSR_TEST_KVM(msr, val, rsvd, feat)				\
+	____MSR_TEST(KVM_REG_ ##msr, #msr, val, rsvd, 0, feat, feat, true)
+
 /*
  * The main struct must be scoped to a function due to the use of structures to
  * define features.  For the global structure, allocate enough space for the
@@ -156,6 +161,83 @@ static void guest_main(void)
 static bool has_one_reg;
 static bool use_one_reg;
 
+#define KVM_X86_MAX_NR_REGS	1
+
+static bool vcpu_has_reg(struct kvm_vcpu *vcpu, u64 reg)
+{
+	struct {
+		struct kvm_reg_list list;
+		u64 regs[KVM_X86_MAX_NR_REGS];
+	} regs = {};
+	int r, i;
+
+	/*
+	 * If KVM_GET_REG_LIST succeeds with n=0, i.e. there are no supported
+	 * regs, then the vCPU obviously doesn't support the reg.
+	 */
+	r = __vcpu_ioctl(vcpu, KVM_GET_REG_LIST, &regs.list.n);
+	if (!r)
+		return false;
+
+	TEST_ASSERT_EQ(errno, E2BIG);
+
+	/*
+	 * KVM x86 is expected to support enumerating a relative small number
+	 * of regs.  The majority of registers supported by KVM_{G,S}ET_ONE_REG
+	 * are enumerated via other ioctls, e.g. KVM_GET_MSR_INDEX_LIST.  For
+	 * simplicity, hardcode the maximum number of regs and manually update
+	 * the test as necessary.
+	 */
+	TEST_ASSERT(regs.list.n <= KVM_X86_MAX_NR_REGS,
+		    "KVM reports %llu regs, test expects at most %u regs, stale test?",
+		    regs.list.n, KVM_X86_MAX_NR_REGS);
+
+	vcpu_ioctl(vcpu, KVM_GET_REG_LIST, &regs.list.n);
+	for (i = 0; i < regs.list.n; i++) {
+		if (regs.regs[i] == reg)
+			return true;
+	}
+
+	return false;
+}
+
+static void host_test_kvm_reg(struct kvm_vcpu *vcpu)
+{
+	bool has_reg = vcpu_cpuid_has(vcpu, msrs[idx].feature);
+	u64 reset_val = msrs[idx].reset_val;
+	u64 write_val = msrs[idx].write_val;
+	u64 rsvd_val = msrs[idx].rsvd_val;
+	u32 reg = msrs[idx].index;
+	u64 val;
+	int r;
+
+	if (!use_one_reg)
+		return;
+
+	TEST_ASSERT_EQ(vcpu_has_reg(vcpu, KVM_X86_REG_KVM(reg)), has_reg);
+
+	if (!has_reg) {
+		r = __vcpu_get_reg(vcpu, KVM_X86_REG_KVM(reg), &val);
+		TEST_ASSERT(r && errno == EINVAL,
+			    "Expected failure on get_reg(0x%x)", reg);
+		rsvd_val = 0;
+		goto out;
+	}
+
+	val = vcpu_get_reg(vcpu, KVM_X86_REG_KVM(reg));
+	TEST_ASSERT(val == reset_val, "Wanted 0x%lx from get_reg(0x%x), got 0x%lx",
+		    reset_val, reg, val);
+
+	vcpu_set_reg(vcpu, KVM_X86_REG_KVM(reg), write_val);
+	val = vcpu_get_reg(vcpu, KVM_X86_REG_KVM(reg));
+	TEST_ASSERT(val == write_val, "Wanted 0x%lx from get_reg(0x%x), got 0x%lx",
+		    write_val, reg, val);
+
+out:
+	r = __vcpu_set_reg(vcpu, KVM_X86_REG_KVM(reg), rsvd_val);
+	TEST_ASSERT(r, "Expected failure on set_reg(0x%x, 0x%lx)", reg, rsvd_val);
+}
+
 static void host_test_msr(struct kvm_vcpu *vcpu, u64 guest_val)
 {
 	u64 reset_val = msrs[idx].reset_val;
@@ -265,6 +347,8 @@ static void test_msrs(void)
 		MSR_TEST(MSR_IA32_PL2_SSP, canonical_val, canonical_val | 1, SHSTK),
 		MSR_TEST_CANONICAL(MSR_IA32_PL3_SSP, SHSTK),
 		MSR_TEST(MSR_IA32_PL3_SSP, canonical_val, canonical_val | 1, SHSTK),
+
+		MSR_TEST_KVM(GUEST_SSP, canonical_val, NONCANONICAL, SHSTK),
 	};
 
 	const struct kvm_x86_cpu_feature feat_none = X86_FEATURE_NONE;
@@ -280,6 +364,7 @@ static void test_msrs(void)
 	const int NR_VCPUS = 3;
 	struct kvm_vcpu *vcpus[NR_VCPUS];
 	struct kvm_vm *vm;
+	int i;
 
 	kvm_static_assert(sizeof(__msrs) <= sizeof(msrs));
 	kvm_static_assert(ARRAY_SIZE(__msrs) <= ARRAY_SIZE(msrs));
@@ -307,6 +392,12 @@ static void test_msrs(void)
 	}
 
 	for (idx = 0; idx < ARRAY_SIZE(__msrs); idx++) {
+		if (msrs[idx].is_kvm_defined) {
+			for (i = 0; i < NR_VCPUS; i++)
+				host_test_kvm_reg(vcpus[i]);
+			continue;
+		}
+
 		sync_global_to_guest(vm, idx);
 
 		vcpus_run(vcpus, NR_VCPUS);
-- 
2.51.0.384.g4c02a37b29-goog


