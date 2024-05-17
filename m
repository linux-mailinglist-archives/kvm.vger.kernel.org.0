Return-Path: <kvm+bounces-17698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E0D708C8BAE
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:53:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29E001F2599F
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:53:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE185159565;
	Fri, 17 May 2024 17:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FI/ggLwt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E93158DA5
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967674; cv=none; b=ofso+6eWYQAP+qGraoI+ZFDBp3izUt9nmGRJAkh4LA0PiHES0ZLF9Q+x4Ryg1ZfYLS/EJ6Kiqw07yeCkraARI3QBnzfVx41PxdHucRPI8+RjXRy6aGZ7+ircgDYhiHKEpVYAQcWfMOZRgBBAKWzxZCcS4Ybkapl2IaIQhYXBqjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967674; c=relaxed/simple;
	bh=cZtqTezZQUhHXO2aWbsrVlXD0P7m9tFrzH1syXZcicA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bSm2egTFYw/zgUQsODpOnJTizY/k6qlosw05zh+YkKVNX2PI+z05jYRMgNc/eKlhUmGVKypmU1B75mS1tP3lqGT0niC9Awlt/L9gIrJe/w4r0UHQUI9pYiob2ioqmCHfDet2oodaHlTYa9oyMGS53K8vlDPcocrEcq9gjHSAm1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FI/ggLwt; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6f452eb2035so9134572b3a.0
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967671; x=1716572471; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fTqxgJFr4qCRmF5YRzH52uvxfr8wyfb6rGA7szxrb20=;
        b=FI/ggLwtFKEt1LMRiebrBrSJfhXalKVQymsQvouNDHSaJWRhHi1MrkPSTfPxhLCtuq
         L7U1UoQg402XPCCai0/ek0BeTbW9Xo0evALQVyER2dNNCEiP3WDQ5gyZeEcyQ92A777q
         B6hFNO5fHGOJjLCFVGzVgP2Prxs5gZuu+ep+zLswIz3fjt3MGfjVw2u50q1Vy3dOutH3
         Cbqit1C2IZwH0VY/2TziFvQNoxd9XVL1+awfY0YVojjkEi7BAL2s1UTwYkJvs08LmDsO
         FK+RPSqHkSgPjn0sUsIjii/HKNAEOkQoReD1vBQ/7gKx9dU69sWWIJpltoi9YYryOYfK
         Haig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967671; x=1716572471;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fTqxgJFr4qCRmF5YRzH52uvxfr8wyfb6rGA7szxrb20=;
        b=ecx4hhmZ+L6RTtDRyOqqbS674UgEnfdC0yUOU4vZ15zIgeP7knIOYA4GwiW/mCCGxK
         pvUc3ZfrQNSBnYoHxQifVfUb0DWTeN9TDV0q6kJRjIeWbAfYQf0DbyrQ4oWZrO7dGDQF
         8/peNegjoIay9NPFcce7VKcrFHcc5pCA/qg9Po3TyQc8WS30w0nFaqlf2iO36I2m1juy
         Sp6H69LbGt6lS0vg9uQrO6g1IKsbDjneoNX4g5MHbDskonqDpf/FstOZ1m6+QkhpGaUr
         3Kaq6zP6/E25H/tFYqqNylfy33B8Xc3C4yQhLUwtDbkNf6rMOQWbjTNm59H9PyDIKKcS
         7mgw==
X-Gm-Message-State: AOJu0Yyd5PL3D7f+JRPTbmFckwq1Ovluo7n6/rByyfZCvov5AxlfX7ck
	UDoWsMN8XRGuSt07OOXwUjWXEO+DTL7D6EUZ3MVgrVXaRRzi057s6FmP1N27P05SSI+CpZty/cU
	8xQ==
X-Google-Smtp-Source: AGHT+IEPeayz0ATUimGCCShRm85Owm2nD1WNDR6RFPdzli+AJVPkmqehO68JdTd3mxsk52x07sTjtkrECAU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:17a4:b0:6ea:b073:bf40 with SMTP id
 d2e1a72fcca58-6f4e03374bemr1037257b3a.4.1715967670712; Fri, 17 May 2024
 10:41:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:39:23 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-47-seanjc@google.com>
Subject: [PATCH v2 46/49] KVM: x86: Replace (almost) all guest CPUID feature
 queries with cpu_caps
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Switch all queries (except XSAVES) of guest features from guest CPUID to
guest capabilities, i.e. replace all calls to guest_cpuid_has() with calls
to guest_cpu_cap_has().

Keep guest_cpuid_has() around for XSAVES, but subsume its helper
guest_cpuid_get_register() and add a compile-time assertion to prevent
using guest_cpuid_has() for any other feature.  Add yet another comment
for XSAVE to explain why KVM is allowed to query its raw guest CPUID.

Opportunistically drop the unused guest_cpuid_clear(), as there should be
no circumstance in which KVM needs to _clear_ a guest CPUID feature now
that everything is tracked via cpu_caps.  E.g. KVM may need to _change_
a feature to emulate dynamic CPUID flags, but KVM should never need to
clear a feature in guest CPUID to prevent it from being used by the guest.

Delete the last remnants of the governed features framework, as the lone
holdout was vmx_adjust_secondary_exec_control()'s divergent behavior for
governed vs. ungoverned features.

Note, replacing guest_cpuid_has() checks with guest_cpu_cap_has() when
computing reserved CR4 bits is a nop when viewed as a whole, as KVM's
capabilities are already incorporated into the calculation, i.e. if a
feature is present in guest CPUID but unsupported by KVM, its CR4 bit
was already being marked as reserved, checking guest_cpu_cap_has() simply
double-stamps that it's a reserved bit.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c             |  4 +-
 arch/x86/kvm/cpuid.h             | 74 +++++++++++---------------------
 arch/x86/kvm/governed_features.h | 22 ----------
 arch/x86/kvm/hyperv.c            |  2 +-
 arch/x86/kvm/lapic.c             |  2 +-
 arch/x86/kvm/mtrr.c              |  2 +-
 arch/x86/kvm/smm.c               | 10 ++---
 arch/x86/kvm/svm/pmu.c           |  8 ++--
 arch/x86/kvm/svm/sev.c           |  4 +-
 arch/x86/kvm/svm/svm.c           | 20 ++++-----
 arch/x86/kvm/vmx/hyperv.h        |  2 +-
 arch/x86/kvm/vmx/nested.c        | 12 +++---
 arch/x86/kvm/vmx/pmu_intel.c     |  4 +-
 arch/x86/kvm/vmx/sgx.c           | 14 +++---
 arch/x86/kvm/vmx/vmx.c           | 47 ++++++++++----------
 arch/x86/kvm/x86.c               | 64 +++++++++++++--------------
 16 files changed, 121 insertions(+), 170 deletions(-)
 delete mode 100644 arch/x86/kvm/governed_features.h

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 1424a9d4eb17..0130e0677387 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -463,7 +463,7 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	 * and can install smaller shadow pages if the host lacks 1GiB support.
 	 */
 	allow_gbpages = tdp_enabled ? boot_cpu_has(X86_FEATURE_GBPAGES) :
-				      guest_cpuid_has(vcpu, X86_FEATURE_GBPAGES);
+				      guest_cpu_cap_has(vcpu, X86_FEATURE_GBPAGES);
 	guest_cpu_cap_change(vcpu, X86_FEATURE_GBPAGES, allow_gbpages);
 
 	best = kvm_find_cpuid_entry(vcpu, 1);
@@ -488,7 +488,7 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 #define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
 	vcpu->arch.cr4_guest_rsvd_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_) |
-					 __cr4_reserved_bits(guest_cpuid_has, vcpu);
+					 __cr4_reserved_bits(guest_cpu_cap_has, vcpu);
 #undef __kvm_cpu_cap_has
 
 	kvm_hv_set_cpuid(vcpu, kvm_cpuid_has_hyperv(vcpu));
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 7be56fa62342..0bf3bddd0e29 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -67,41 +67,38 @@ static __always_inline void cpuid_entry_override(struct kvm_cpuid_entry2 *entry,
 	*reg = kvm_cpu_caps[leaf];
 }
 
-static __always_inline u32 *guest_cpuid_get_register(struct kvm_vcpu *vcpu,
-						     unsigned int x86_feature)
+static __always_inline bool guest_cpuid_has(struct kvm_vcpu *vcpu,
+					    unsigned int x86_feature)
 {
 	const struct cpuid_reg cpuid = x86_feature_cpuid(x86_feature);
 	struct kvm_cpuid_entry2 *entry;
+	u32 *reg;
+
+	/*
+	 * XSAVES is a special snowflake.  Due to lack of a dedicated intercept
+	 * on SVM, KVM must assume that XSAVES (and thus XRSTORS) is usable by
+	 * the guest if the host supports XSAVES and *XSAVE* is exposed to the
+	 * guest.  Although the guest can read/write XSS via XSAVES/XRSTORS, to
+	 * minimize the virtualization hole, KVM rejects attempts to read/write
+	 * XSS via RDMSR/WRMSR.  To make that work, KVM needs to check the raw
+	 * guest CPUID, not KVM's view of guest capabilities.
+	 *
+	 * For all other features, guest capabilities are accurate.  Expand
+	 * this allowlist with extreme vigilance.
+	 */
+	BUILD_BUG_ON(x86_feature != X86_FEATURE_XSAVES);
 
 	entry = kvm_find_cpuid_entry_index(vcpu, cpuid.function, cpuid.index);
 	if (!entry)
 		return NULL;
 
-	return __cpuid_entry_get_reg(entry, cpuid.reg);
-}
-
-static __always_inline bool guest_cpuid_has(struct kvm_vcpu *vcpu,
-					    unsigned int x86_feature)
-{
-	u32 *reg;
-
-	reg = guest_cpuid_get_register(vcpu, x86_feature);
+	reg = __cpuid_entry_get_reg(entry, cpuid.reg);
 	if (!reg)
 		return false;
 
 	return *reg & __feature_bit(x86_feature);
 }
 
-static __always_inline void guest_cpuid_clear(struct kvm_vcpu *vcpu,
-					      unsigned int x86_feature)
-{
-	u32 *reg;
-
-	reg = guest_cpuid_get_register(vcpu, x86_feature);
-	if (reg)
-		*reg &= ~__feature_bit(x86_feature);
-}
-
 static inline bool guest_cpuid_is_amd_or_hygon(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
@@ -220,27 +217,6 @@ static __always_inline bool guest_pv_has(struct kvm_vcpu *vcpu,
 	return vcpu->arch.pv_cpuid.features & (1u << kvm_feature);
 }
 
-enum kvm_governed_features {
-#define KVM_GOVERNED_FEATURE(x) KVM_GOVERNED_##x,
-#include "governed_features.h"
-	KVM_NR_GOVERNED_FEATURES
-};
-
-static __always_inline int kvm_governed_feature_index(unsigned int x86_feature)
-{
-	switch (x86_feature) {
-#define KVM_GOVERNED_FEATURE(x) case x: return KVM_GOVERNED_##x;
-#include "governed_features.h"
-	default:
-		return -1;
-	}
-}
-
-static __always_inline bool kvm_is_governed_feature(unsigned int x86_feature)
-{
-	return kvm_governed_feature_index(x86_feature) >= 0;
-}
-
 static __always_inline void guest_cpu_cap_set(struct kvm_vcpu *vcpu,
 					      unsigned int x86_feature)
 {
@@ -288,17 +264,17 @@ static inline bool kvm_vcpu_is_legal_cr3(struct kvm_vcpu *vcpu, unsigned long cr
 
 static inline bool guest_has_spec_ctrl_msr(struct kvm_vcpu *vcpu)
 {
-	return (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
-		guest_cpuid_has(vcpu, X86_FEATURE_AMD_STIBP) ||
-		guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) ||
-		guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD));
+	return (guest_cpu_cap_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
+		guest_cpu_cap_has(vcpu, X86_FEATURE_AMD_STIBP) ||
+		guest_cpu_cap_has(vcpu, X86_FEATURE_AMD_IBRS) ||
+		guest_cpu_cap_has(vcpu, X86_FEATURE_AMD_SSBD));
 }
 
 static inline bool guest_has_pred_cmd_msr(struct kvm_vcpu *vcpu)
 {
-	return (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
-		guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBPB) ||
-		guest_cpuid_has(vcpu, X86_FEATURE_SBPB));
+	return (guest_cpu_cap_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
+		guest_cpu_cap_has(vcpu, X86_FEATURE_AMD_IBPB) ||
+		guest_cpu_cap_has(vcpu, X86_FEATURE_SBPB));
 }
 
 #endif
diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
deleted file mode 100644
index ad463b1ed4e4..000000000000
--- a/arch/x86/kvm/governed_features.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#if !defined(KVM_GOVERNED_FEATURE) || defined(KVM_GOVERNED_X86_FEATURE)
-BUILD_BUG()
-#endif
-
-#define KVM_GOVERNED_X86_FEATURE(x) KVM_GOVERNED_FEATURE(X86_FEATURE_##x)
-
-KVM_GOVERNED_X86_FEATURE(GBPAGES)
-KVM_GOVERNED_X86_FEATURE(XSAVES)
-KVM_GOVERNED_X86_FEATURE(VMX)
-KVM_GOVERNED_X86_FEATURE(NRIPS)
-KVM_GOVERNED_X86_FEATURE(TSCRATEMSR)
-KVM_GOVERNED_X86_FEATURE(V_VMSAVE_VMLOAD)
-KVM_GOVERNED_X86_FEATURE(LBRV)
-KVM_GOVERNED_X86_FEATURE(PAUSEFILTER)
-KVM_GOVERNED_X86_FEATURE(PFTHRESHOLD)
-KVM_GOVERNED_X86_FEATURE(VGIF)
-KVM_GOVERNED_X86_FEATURE(VNMI)
-KVM_GOVERNED_X86_FEATURE(LAM)
-
-#undef KVM_GOVERNED_X86_FEATURE
-#undef KVM_GOVERNED_FEATURE
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 8a47f8541eab..4971b60a1882 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1352,7 +1352,7 @@ static void __kvm_hv_xsaves_xsavec_maybe_warn(struct kvm_vcpu *vcpu)
 		return;
 
 	if (guest_cpuid_has(vcpu, X86_FEATURE_XSAVES) ||
-	    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVEC))
+	    !guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVEC))
 		return;
 
 	pr_notice_ratelimited("Booting SMP Windows KVM VM with !XSAVES && XSAVEC. "
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index ebf41023be38..37a2ecee3d75 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -590,7 +590,7 @@ void kvm_apic_set_version(struct kvm_vcpu *vcpu)
 	 * version first and level-triggered interrupts never get EOIed in
 	 * IOAPIC.
 	 */
-	if (guest_cpuid_has(vcpu, X86_FEATURE_X2APIC) &&
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_X2APIC) &&
 	    !ioapic_in_kernel(vcpu->kvm))
 		v |= APIC_LVR_DIRECTED_EOI;
 	kvm_lapic_set_reg(apic, APIC_LVR, v);
diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index a67c28a56417..9e8cb38ae1db 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -128,7 +128,7 @@ static u8 mtrr_disabled_type(struct kvm_vcpu *vcpu)
 	 * enable MTRRs and it is obviously undesirable to run the
 	 * guest entirely with UC memory and we use WB.
 	 */
-	if (guest_cpuid_has(vcpu, X86_FEATURE_MTRR))
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_MTRR))
 		return MTRR_TYPE_UNCACHABLE;
 	else
 		return MTRR_TYPE_WRBACK;
diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
index d06d43d8d2aa..9144b28789df 100644
--- a/arch/x86/kvm/smm.c
+++ b/arch/x86/kvm/smm.c
@@ -283,7 +283,7 @@ void enter_smm(struct kvm_vcpu *vcpu)
 	memset(smram.bytes, 0, sizeof(smram.bytes));
 
 #ifdef CONFIG_X86_64
-	if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_LM))
 		enter_smm_save_state_64(vcpu, &smram.smram64);
 	else
 #endif
@@ -353,7 +353,7 @@ void enter_smm(struct kvm_vcpu *vcpu)
 	kvm_set_segment(vcpu, &ds, VCPU_SREG_SS);
 
 #ifdef CONFIG_X86_64
-	if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_LM))
 		if (static_call(kvm_x86_set_efer)(vcpu, 0))
 			goto error;
 #endif
@@ -586,7 +586,7 @@ int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
 	 * supports long mode.
 	 */
 #ifdef CONFIG_X86_64
-	if (guest_cpuid_has(vcpu, X86_FEATURE_LM)) {
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_LM)) {
 		struct kvm_segment cs_desc;
 		unsigned long cr4;
 
@@ -609,7 +609,7 @@ int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
 		kvm_set_cr0(vcpu, cr0 & ~(X86_CR0_PG | X86_CR0_PE));
 
 #ifdef CONFIG_X86_64
-	if (guest_cpuid_has(vcpu, X86_FEATURE_LM)) {
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_LM)) {
 		unsigned long cr4, efer;
 
 		/* Clear CR4.PAE before clearing EFER.LME. */
@@ -632,7 +632,7 @@ int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
 		return X86EMUL_UNHANDLEABLE;
 
 #ifdef CONFIG_X86_64
-	if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_LM))
 		return rsm_load_state_64(ctxt, &smram.smram64);
 	else
 #endif
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index dfcc38bd97d3..4a4be2da1345 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -46,7 +46,7 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
 
 	switch (msr) {
 	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
-		if (!guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE))
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_PERFCTR_CORE))
 			return NULL;
 		/*
 		 * Each PMU counter has a pair of CTL and CTR MSRs. CTLn
@@ -109,7 +109,7 @@ static bool amd_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_K7_EVNTSEL0 ... MSR_K7_PERFCTR3:
 		return pmu->version > 0;
 	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
-		return guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE);
+		return guest_cpu_cap_has(vcpu, X86_FEATURE_PERFCTR_CORE);
 	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
 	case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
 	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
@@ -179,7 +179,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 	union cpuid_0x80000022_ebx ebx;
 
 	pmu->version = 1;
-	if (guest_cpuid_has(vcpu, X86_FEATURE_PERFMON_V2)) {
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_PERFMON_V2)) {
 		pmu->version = 2;
 		/*
 		 * Note, PERFMON_V2 is also in 0x80000022.0x0, i.e. the guest
@@ -189,7 +189,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 			     x86_feature_cpuid(X86_FEATURE_PERFMON_V2).index);
 		ebx.full = kvm_find_cpuid_entry_index(vcpu, 0x80000022, 0)->ebx;
 		pmu->nr_arch_gp_counters = ebx.split.num_core_pmc;
-	} else if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE)) {
+	} else if (guest_cpu_cap_has(vcpu, X86_FEATURE_PERFCTR_CORE)) {
 		pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS_CORE;
 	} else {
 		pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7640dedc2ddc..1004280599b4 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4399,8 +4399,8 @@ static void sev_es_vcpu_after_set_cpuid(struct vcpu_svm *svm)
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
 	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX)) {
-		bool v_tsc_aux = guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) ||
-				 guest_cpuid_has(vcpu, X86_FEATURE_RDPID);
+		bool v_tsc_aux = guest_cpu_cap_has(vcpu, X86_FEATURE_RDTSCP) ||
+				 guest_cpu_cap_has(vcpu, X86_FEATURE_RDPID);
 
 		set_msr_interception(vcpu, svm->msrpm, MSR_TSC_AUX, v_tsc_aux, v_tsc_aux);
 	}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 946a75771946..06770b60c0ba 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1178,14 +1178,14 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu,
 	 */
 	if (kvm_cpu_cap_has(X86_FEATURE_INVPCID)) {
 		if (!npt_enabled ||
-		    !guest_cpuid_has(&svm->vcpu, X86_FEATURE_INVPCID))
+		    !guest_cpu_cap_has(&svm->vcpu, X86_FEATURE_INVPCID))
 			svm_set_intercept(svm, INTERCEPT_INVPCID);
 		else
 			svm_clr_intercept(svm, INTERCEPT_INVPCID);
 	}
 
 	if (kvm_cpu_cap_has(X86_FEATURE_RDTSCP)) {
-		if (guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
+		if (guest_cpu_cap_has(vcpu, X86_FEATURE_RDTSCP))
 			svm_clr_intercept(svm, INTERCEPT_RDTSCP);
 		else
 			svm_set_intercept(svm, INTERCEPT_RDTSCP);
@@ -2911,7 +2911,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_AMD64_VIRT_SPEC_CTRL:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_VIRT_SSBD))
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_VIRT_SSBD))
 			return 1;
 
 		msr_info->data = svm->virt_spec_ctrl;
@@ -3058,7 +3058,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		break;
 	case MSR_AMD64_VIRT_SPEC_CTRL:
 		if (!msr->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_VIRT_SSBD))
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_VIRT_SSBD))
 			return 1;
 
 		if (data & ~SPEC_CTRL_SSBD)
@@ -3230,7 +3230,7 @@ static int invpcid_interception(struct kvm_vcpu *vcpu)
 	unsigned long type;
 	gva_t gva;
 
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_INVPCID)) {
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_INVPCID)) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
 		return 1;
 	}
@@ -4342,7 +4342,7 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	guest_cpu_cap_change(vcpu, X86_FEATURE_XSAVES,
 			     boot_cpu_has(X86_FEATURE_XSAVE) &&
 			     boot_cpu_has(X86_FEATURE_XSAVES) &&
-			     guest_cpuid_has(vcpu, X86_FEATURE_XSAVE));
+			     guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVE));
 
 	/*
 	 * Intercept VMLOAD if the vCPU mode is Intel in order to emulate that
@@ -4360,7 +4360,7 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	if (boot_cpu_has(X86_FEATURE_FLUSH_L1D))
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_FLUSH_CMD, 0,
-				     !!guest_cpuid_has(vcpu, X86_FEATURE_FLUSH_L1D));
+				     !!guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D));
 
 	if (sev_guest(vcpu->kvm))
 		sev_vcpu_after_set_cpuid(svm);
@@ -4617,7 +4617,7 @@ static int svm_enter_smm(struct kvm_vcpu *vcpu, union kvm_smram *smram)
 	 * responsible for ensuring nested SVM and SMIs are mutually exclusive.
 	 */
 
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_LM))
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_LM))
 		return 1;
 
 	smram->smram64.svm_guest_flag = 1;
@@ -4664,14 +4664,14 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram)
 
 	const struct kvm_smram_state_64 *smram64 = &smram->smram64;
 
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_LM))
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_LM))
 		return 0;
 
 	/* Non-zero if SMI arrived while vCPU was in guest mode. */
 	if (!smram64->svm_guest_flag)
 		return 0;
 
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_SVM))
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SVM))
 		return 1;
 
 	if (!(smram64->efer & EFER_SVME))
diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
index a87407412615..11a339009781 100644
--- a/arch/x86/kvm/vmx/hyperv.h
+++ b/arch/x86/kvm/vmx/hyperv.h
@@ -42,7 +42,7 @@ static inline struct hv_enlightened_vmcs *nested_vmx_evmcs(struct vcpu_vmx *vmx)
 	return vmx->nested.hv_evmcs;
 }
 
-static inline bool guest_cpuid_has_evmcs(struct kvm_vcpu *vcpu)
+static inline bool guest_cpu_cap_has_evmcs(struct kvm_vcpu *vcpu)
 {
 	/*
 	 * eVMCS is exposed to the guest if Hyper-V is enabled in CPUID and
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index fb7eec29681d..fcba0061083d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -259,7 +259,7 @@ static bool nested_evmcs_handle_vmclear(struct kvm_vcpu *vcpu, gpa_t vmptr)
 	 * state. It is possible that the area will stay mapped as
 	 * vmx->nested.hv_evmcs but this shouldn't be a problem.
 	 */
-	if (!guest_cpuid_has_evmcs(vcpu) ||
+	if (!guest_cpu_cap_has_evmcs(vcpu) ||
 	    !evmptr_is_valid(nested_get_evmptr(vcpu)))
 		return false;
 
@@ -2061,7 +2061,7 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
 	bool evmcs_gpa_changed = false;
 	u64 evmcs_gpa;
 
-	if (likely(!guest_cpuid_has_evmcs(vcpu)))
+	if (likely(!guest_cpu_cap_has_evmcs(vcpu)))
 		return EVMPTRLD_DISABLED;
 
 	evmcs_gpa = nested_get_evmptr(vcpu);
@@ -2947,7 +2947,7 @@ static int nested_vmx_check_controls(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 #ifdef CONFIG_KVM_HYPERV
-	if (guest_cpuid_has_evmcs(vcpu))
+	if (guest_cpu_cap_has_evmcs(vcpu))
 		return nested_evmcs_check_controls(vmcs12);
 #endif
 
@@ -3231,7 +3231,7 @@ static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu)
 	 * L2 was running), map it here to make sure vmcs12 changes are
 	 * properly reflected.
 	 */
-	if (guest_cpuid_has_evmcs(vcpu) &&
+	if (guest_cpu_cap_has_evmcs(vcpu) &&
 	    vmx->nested.hv_evmcs_vmptr == EVMPTR_MAP_PENDING) {
 		enum nested_evmptrld_status evmptrld_status =
 			nested_vmx_handle_enlightened_vmptrld(vcpu, false);
@@ -4882,7 +4882,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 	 * doesn't isolate different VMCSs, i.e. in this case, doesn't provide
 	 * separate modes for L2 vs L1.
 	 */
-	if (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SPEC_CTRL))
 		indirect_branch_prediction_barrier();
 
 	/* Update any VMCS fields that might have changed while L2 ran */
@@ -6152,7 +6152,7 @@ static bool nested_vmx_exit_handled_encls(struct kvm_vcpu *vcpu,
 {
 	u32 encls_leaf;
 
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_SGX) ||
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SGX) ||
 	    !nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENCLS_EXITING))
 		return false;
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index be40474de6e4..a739defa6796 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -110,7 +110,7 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 
 static inline u64 vcpu_get_perf_capabilities(struct kvm_vcpu *vcpu)
 {
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_PDCM))
 		return 0;
 
 	return vcpu->arch.perf_capabilities;
@@ -160,7 +160,7 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 		ret = vcpu_get_perf_capabilities(vcpu) & PERF_CAP_PEBS_FORMAT;
 		break;
 	case MSR_IA32_DS_AREA:
-		ret = guest_cpuid_has(vcpu, X86_FEATURE_DS);
+		ret = guest_cpu_cap_has(vcpu, X86_FEATURE_DS);
 		break;
 	case MSR_PEBS_DATA_CFG:
 		perf_capabilities = vcpu_get_perf_capabilities(vcpu);
diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index 6fef01e0536e..f57f072a16f6 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -123,7 +123,7 @@ static int sgx_inject_fault(struct kvm_vcpu *vcpu, gva_t gva, int trapnr)
 	 * likely than a bad userspace address.
 	 */
 	if ((trapnr == PF_VECTOR || !boot_cpu_has(X86_FEATURE_SGX2)) &&
-	    guest_cpuid_has(vcpu, X86_FEATURE_SGX2)) {
+	    guest_cpu_cap_has(vcpu, X86_FEATURE_SGX2)) {
 		memset(&ex, 0, sizeof(ex));
 		ex.vector = PF_VECTOR;
 		ex.error_code = PFERR_PRESENT_MASK | PFERR_WRITE_MASK |
@@ -366,7 +366,7 @@ static inline bool encls_leaf_enabled_in_guest(struct kvm_vcpu *vcpu, u32 leaf)
 		return true;
 
 	if (leaf >= EAUG && leaf <= EMODT)
-		return guest_cpuid_has(vcpu, X86_FEATURE_SGX2);
+		return guest_cpu_cap_has(vcpu, X86_FEATURE_SGX2);
 
 	return false;
 }
@@ -382,8 +382,8 @@ int handle_encls(struct kvm_vcpu *vcpu)
 {
 	u32 leaf = (u32)kvm_rax_read(vcpu);
 
-	if (!enable_sgx || !guest_cpuid_has(vcpu, X86_FEATURE_SGX) ||
-	    !guest_cpuid_has(vcpu, X86_FEATURE_SGX1)) {
+	if (!enable_sgx || !guest_cpu_cap_has(vcpu, X86_FEATURE_SGX) ||
+	    !guest_cpu_cap_has(vcpu, X86_FEATURE_SGX1)) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
 	} else if (!encls_leaf_enabled_in_guest(vcpu, leaf) ||
 		   !sgx_enabled_in_guest_bios(vcpu) || !is_paging(vcpu)) {
@@ -480,15 +480,15 @@ void vmx_write_encls_bitmap(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 	if (!cpu_has_vmx_encls_vmexit())
 		return;
 
-	if (guest_cpuid_has(vcpu, X86_FEATURE_SGX) &&
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SGX) &&
 	    sgx_enabled_in_guest_bios(vcpu)) {
-		if (guest_cpuid_has(vcpu, X86_FEATURE_SGX1)) {
+		if (guest_cpu_cap_has(vcpu, X86_FEATURE_SGX1)) {
 			bitmap &= ~GENMASK_ULL(ETRACK, ECREATE);
 			if (sgx_intercept_encls_ecreate(vcpu))
 				bitmap |= (1 << ECREATE);
 		}
 
-		if (guest_cpuid_has(vcpu, X86_FEATURE_SGX2))
+		if (guest_cpu_cap_has(vcpu, X86_FEATURE_SGX2))
 			bitmap &= ~GENMASK_ULL(EMODT, EAUG);
 
 		/*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 653c4b68ec7f..741961a1edcc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1874,8 +1874,8 @@ static void vmx_setup_uret_msrs(struct vcpu_vmx *vmx)
 	vmx_setup_uret_msr(vmx, MSR_EFER, update_transition_efer(vmx));
 
 	vmx_setup_uret_msr(vmx, MSR_TSC_AUX,
-			   guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP) ||
-			   guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDPID));
+			   guest_cpu_cap_has(&vmx->vcpu, X86_FEATURE_RDTSCP) ||
+			   guest_cpu_cap_has(&vmx->vcpu, X86_FEATURE_RDPID));
 
 	/*
 	 * hle=0, rtm=0, tsx_ctrl=1 can be found with some combinations of new
@@ -2028,7 +2028,7 @@ int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_BNDCFGS:
 		if (!kvm_mpx_supported() ||
 		    (!msr_info->host_initiated &&
-		     !guest_cpuid_has(vcpu, X86_FEATURE_MPX)))
+		     !guest_cpu_cap_has(vcpu, X86_FEATURE_MPX)))
 			return 1;
 		msr_info->data = vmcs_read64(GUEST_BNDCFGS);
 		break;
@@ -2044,7 +2044,7 @@ int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_SGXLEPUBKEYHASH0 ... MSR_IA32_SGXLEPUBKEYHASH3:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_SGX_LC))
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_SGX_LC))
 			return 1;
 		msr_info->data = to_vmx(vcpu)->msr_ia32_sgxlepubkeyhash
 			[msr_info->index - MSR_IA32_SGXLEPUBKEYHASH0];
@@ -2063,7 +2063,7 @@ int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 * sanity checking and refuse to boot. Filter all unsupported
 		 * features out.
 		 */
-		if (!msr_info->host_initiated && guest_cpuid_has_evmcs(vcpu))
+		if (!msr_info->host_initiated && guest_cpu_cap_has_evmcs(vcpu))
 			nested_evmcs_filter_control_msr(vcpu, msr_info->index,
 							&msr_info->data);
 #endif
@@ -2133,7 +2133,7 @@ static u64 nested_vmx_truncate_sysenter_addr(struct kvm_vcpu *vcpu,
 						    u64 data)
 {
 #ifdef CONFIG_X86_64
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_LM))
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_LM))
 		return (u32)data;
 #endif
 	return (unsigned long)data;
@@ -2144,7 +2144,7 @@ static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated
 	u64 debugctl = 0;
 
 	if (boot_cpu_has(X86_FEATURE_BUS_LOCK_DETECT) &&
-	    (host_initiated || guest_cpuid_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT)))
+	    (host_initiated || guest_cpu_cap_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT)))
 		debugctl |= DEBUGCTLMSR_BUS_LOCK_DETECT;
 
 	if ((kvm_caps.supported_perf_cap & PMU_CAP_LBR_FMT) &&
@@ -2248,7 +2248,7 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_BNDCFGS:
 		if (!kvm_mpx_supported() ||
 		    (!msr_info->host_initiated &&
-		     !guest_cpuid_has(vcpu, X86_FEATURE_MPX)))
+		     !guest_cpu_cap_has(vcpu, X86_FEATURE_MPX)))
 			return 1;
 		if (is_noncanonical_address(data & PAGE_MASK, vcpu) ||
 		    (data & MSR_IA32_BNDCFGS_RSVD))
@@ -2350,7 +2350,7 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 * behavior, but it's close enough.
 		 */
 		if (!msr_info->host_initiated &&
-		    (!guest_cpuid_has(vcpu, X86_FEATURE_SGX_LC) ||
+		    (!guest_cpu_cap_has(vcpu, X86_FEATURE_SGX_LC) ||
 		    ((vmx->msr_ia32_feature_control & FEAT_CTL_LOCKED) &&
 		    !(vmx->msr_ia32_feature_control & FEAT_CTL_SGX_LC_ENABLED))))
 			return 1;
@@ -2436,9 +2436,9 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			if ((data & PERF_CAP_PEBS_MASK) !=
 			    (kvm_caps.supported_perf_cap & PERF_CAP_PEBS_MASK))
 				return 1;
-			if (!guest_cpuid_has(vcpu, X86_FEATURE_DS))
+			if (!guest_cpu_cap_has(vcpu, X86_FEATURE_DS))
 				return 1;
-			if (!guest_cpuid_has(vcpu, X86_FEATURE_DTES64))
+			if (!guest_cpu_cap_has(vcpu, X86_FEATURE_DTES64))
 				return 1;
 			if (!cpuid_model_is_consistent(vcpu))
 				return 1;
@@ -4570,10 +4570,7 @@ vmx_adjust_secondary_exec_control(struct vcpu_vmx *vmx, u32 *exec_control,
 	bool __enabled;										\
 												\
 	if (cpu_has_vmx_##name()) {								\
-		if (kvm_is_governed_feature(X86_FEATURE_##feat_name))				\
-			__enabled = guest_cpu_cap_has(__vcpu, X86_FEATURE_##feat_name);		\
-		else										\
-			__enabled = guest_cpuid_has(__vcpu, X86_FEATURE_##feat_name);		\
+		__enabled = guest_cpu_cap_has(__vcpu, X86_FEATURE_##feat_name);			\
 		vmx_adjust_secondary_exec_control(vmx, exec_control, SECONDARY_EXEC_##ctrl_name,\
 						  __enabled, exiting);				\
 	}											\
@@ -4649,8 +4646,8 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 	 */
 	if (cpu_has_vmx_rdtscp()) {
 		bool rdpid_or_rdtscp_enabled =
-			guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) ||
-			guest_cpuid_has(vcpu, X86_FEATURE_RDPID);
+			guest_cpu_cap_has(vcpu, X86_FEATURE_RDTSCP) ||
+			guest_cpu_cap_has(vcpu, X86_FEATURE_RDPID);
 
 		vmx_adjust_secondary_exec_control(vmx, &exec_control,
 						  SECONDARY_EXEC_ENABLE_RDTSCP,
@@ -5956,7 +5953,7 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
 	} operand;
 	int gpr_index;
 
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_INVPCID)) {
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_INVPCID)) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
 		return 1;
 	}
@@ -7837,7 +7834,7 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	 * set if and only if XSAVE is supported.
 	 */
 	if (!boot_cpu_has(X86_FEATURE_XSAVE) ||
-	    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVE))
+	    !guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVE))
 		guest_cpu_cap_clear(vcpu, X86_FEATURE_XSAVES);
 
 	vmx_setup_uret_msrs(vmx);
@@ -7859,21 +7856,21 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		nested_vmx_cr_fixed1_bits_update(vcpu);
 
 	if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&
-			guest_cpuid_has(vcpu, X86_FEATURE_INTEL_PT))
+			guest_cpu_cap_has(vcpu, X86_FEATURE_INTEL_PT))
 		update_intel_pt_cfg(vcpu);
 
 	if (boot_cpu_has(X86_FEATURE_RTM)) {
 		struct vmx_uret_msr *msr;
 		msr = vmx_find_uret_msr(vmx, MSR_IA32_TSX_CTRL);
 		if (msr) {
-			bool enabled = guest_cpuid_has(vcpu, X86_FEATURE_RTM);
+			bool enabled = guest_cpu_cap_has(vcpu, X86_FEATURE_RTM);
 			vmx_set_guest_uret_msr(vmx, msr, enabled ? 0 : TSX_CTRL_RTM_DISABLE);
 		}
 	}
 
 	if (kvm_cpu_cap_has(X86_FEATURE_XFD))
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_XFD_ERR, MSR_TYPE_R,
-					  !guest_cpuid_has(vcpu, X86_FEATURE_XFD));
+					  !guest_cpu_cap_has(vcpu, X86_FEATURE_XFD));
 
 	if (boot_cpu_has(X86_FEATURE_IBPB))
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PRED_CMD, MSR_TYPE_W,
@@ -7881,17 +7878,17 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	if (boot_cpu_has(X86_FEATURE_FLUSH_L1D))
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W,
-					  !guest_cpuid_has(vcpu, X86_FEATURE_FLUSH_L1D));
+					  !guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D));
 
 	set_cr4_guest_host_mask(vmx);
 
 	vmx_write_encls_bitmap(vcpu, NULL);
-	if (guest_cpuid_has(vcpu, X86_FEATURE_SGX))
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SGX))
 		vmx->msr_ia32_feature_control_valid_bits |= FEAT_CTL_SGX_ENABLED;
 	else
 		vmx->msr_ia32_feature_control_valid_bits &= ~FEAT_CTL_SGX_ENABLED;
 
-	if (guest_cpuid_has(vcpu, X86_FEATURE_SGX_LC))
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SGX_LC))
 		vmx->msr_ia32_feature_control_valid_bits |=
 			FEAT_CTL_SGX_LC_ENABLED;
 	else
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4ca9651b3f43..5aa7581802f7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -488,7 +488,7 @@ int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	enum lapic_mode old_mode = kvm_get_apic_mode(vcpu);
 	enum lapic_mode new_mode = kvm_apic_mode(msr_info->data);
 	u64 reserved_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu) | 0x2ff |
-		(guest_cpuid_has(vcpu, X86_FEATURE_X2APIC) ? 0 : X2APIC_ENABLE);
+		(guest_cpu_cap_has(vcpu, X86_FEATURE_X2APIC) ? 0 : X2APIC_ENABLE);
 
 	if ((msr_info->data & reserved_bits) != 0 || new_mode == LAPIC_MODE_INVALID)
 		return 1;
@@ -1351,10 +1351,10 @@ static u64 kvm_dr6_fixed(struct kvm_vcpu *vcpu)
 {
 	u64 fixed = DR6_FIXED_1;
 
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_RTM))
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_RTM))
 		fixed |= DR6_RTM;
 
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT))
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT))
 		fixed |= DR6_BUS_LOCK;
 	return fixed;
 }
@@ -1708,20 +1708,20 @@ static int do_get_msr_feature(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 
 static bool __kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
-	if (efer & EFER_AUTOIBRS && !guest_cpuid_has(vcpu, X86_FEATURE_AUTOIBRS))
+	if (efer & EFER_AUTOIBRS && !guest_cpu_cap_has(vcpu, X86_FEATURE_AUTOIBRS))
 		return false;
 
-	if (efer & EFER_FFXSR && !guest_cpuid_has(vcpu, X86_FEATURE_FXSR_OPT))
+	if (efer & EFER_FFXSR && !guest_cpu_cap_has(vcpu, X86_FEATURE_FXSR_OPT))
 		return false;
 
-	if (efer & EFER_SVME && !guest_cpuid_has(vcpu, X86_FEATURE_SVM))
+	if (efer & EFER_SVME && !guest_cpu_cap_has(vcpu, X86_FEATURE_SVM))
 		return false;
 
 	if (efer & (EFER_LME | EFER_LMA) &&
-	    !guest_cpuid_has(vcpu, X86_FEATURE_LM))
+	    !guest_cpu_cap_has(vcpu, X86_FEATURE_LM))
 		return false;
 
-	if (efer & EFER_NX && !guest_cpuid_has(vcpu, X86_FEATURE_NX))
+	if (efer & EFER_NX && !guest_cpu_cap_has(vcpu, X86_FEATURE_NX))
 		return false;
 
 	return true;
@@ -1863,8 +1863,8 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 			return 1;
 
 		if (!host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_RDTSCP) &&
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_RDPID))
 			return 1;
 
 		/*
@@ -1920,8 +1920,8 @@ int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
 			return 1;
 
 		if (!host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_RDTSCP) &&
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_RDPID))
 			return 1;
 		break;
 	}
@@ -2113,7 +2113,7 @@ EXPORT_SYMBOL_GPL(kvm_handle_invalid_op);
 static int kvm_emulate_monitor_mwait(struct kvm_vcpu *vcpu, const char *insn)
 {
 	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS) &&
-	    !guest_cpuid_has(vcpu, X86_FEATURE_MWAIT))
+	    !guest_cpu_cap_has(vcpu, X86_FEATURE_MWAIT))
 		return kvm_handle_invalid_op(vcpu);
 
 	pr_warn_once("%s instruction emulated as NOP!\n", insn);
@@ -3820,11 +3820,11 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			if ((!guest_has_pred_cmd_msr(vcpu)))
 				return 1;
 
-			if (!guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
-			    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBPB))
+			if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
+			    !guest_cpu_cap_has(vcpu, X86_FEATURE_AMD_IBPB))
 				reserved_bits |= PRED_CMD_IBPB;
 
-			if (!guest_cpuid_has(vcpu, X86_FEATURE_SBPB))
+			if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SBPB))
 				reserved_bits |= PRED_CMD_SBPB;
 		}
 
@@ -3845,7 +3845,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	}
 	case MSR_IA32_FLUSH_CMD:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_FLUSH_L1D))
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D))
 			return 1;
 
 		if (!boot_cpu_has(X86_FEATURE_FLUSH_L1D) || (data & ~L1D_FLUSH))
@@ -3896,7 +3896,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		kvm_set_lapic_tscdeadline_msr(vcpu, data);
 		break;
 	case MSR_IA32_TSC_ADJUST:
-		if (guest_cpuid_has(vcpu, X86_FEATURE_TSC_ADJUST)) {
+		if (guest_cpu_cap_has(vcpu, X86_FEATURE_TSC_ADJUST)) {
 			if (!msr_info->host_initiated) {
 				s64 adj = data - vcpu->arch.ia32_tsc_adjust_msr;
 				adjust_tsc_offset_guest(vcpu, adj);
@@ -3923,7 +3923,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT) &&
 		    ((old_val ^ data)  & MSR_IA32_MISC_ENABLE_MWAIT)) {
-			if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
+			if (!guest_cpu_cap_has(vcpu, X86_FEATURE_XMM3))
 				return 1;
 			vcpu->arch.ia32_misc_enable_msr = data;
 			kvm_update_cpuid_runtime(vcpu);
@@ -4100,12 +4100,12 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		kvm_pr_unimpl_wrmsr(vcpu, msr, data);
 		break;
 	case MSR_AMD64_OSVW_ID_LENGTH:
-		if (!guest_cpuid_has(vcpu, X86_FEATURE_OSVW))
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_OSVW))
 			return 1;
 		vcpu->arch.osvw.length = data;
 		break;
 	case MSR_AMD64_OSVW_STATUS:
-		if (!guest_cpuid_has(vcpu, X86_FEATURE_OSVW))
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_OSVW))
 			return 1;
 		vcpu->arch.osvw.status = data;
 		break;
@@ -4126,7 +4126,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 #ifdef CONFIG_X86_64
 	case MSR_IA32_XFD:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_XFD))
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_XFD))
 			return 1;
 
 		if (data & ~kvm_guest_supported_xfd(vcpu))
@@ -4136,7 +4136,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_XFD_ERR:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_XFD))
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_XFD))
 			return 1;
 
 		if (data & ~kvm_guest_supported_xfd(vcpu))
@@ -4260,13 +4260,13 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_ARCH_CAPABILITIES:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_ARCH_CAPABILITIES))
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_ARCH_CAPABILITIES))
 			return 1;
 		msr_info->data = vcpu->arch.arch_capabilities;
 		break;
 	case MSR_IA32_PERF_CAPABILITIES:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_PDCM))
 			return 1;
 		msr_info->data = vcpu->arch.perf_capabilities;
 		break;
@@ -4467,12 +4467,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = 0xbe702111;
 		break;
 	case MSR_AMD64_OSVW_ID_LENGTH:
-		if (!guest_cpuid_has(vcpu, X86_FEATURE_OSVW))
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_OSVW))
 			return 1;
 		msr_info->data = vcpu->arch.osvw.length;
 		break;
 	case MSR_AMD64_OSVW_STATUS:
-		if (!guest_cpuid_has(vcpu, X86_FEATURE_OSVW))
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_OSVW))
 			return 1;
 		msr_info->data = vcpu->arch.osvw.status;
 		break;
@@ -4491,14 +4491,14 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 #ifdef CONFIG_X86_64
 	case MSR_IA32_XFD:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_XFD))
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_XFD))
 			return 1;
 
 		msr_info->data = vcpu->arch.guest_fpu.fpstate->xfd;
 		break;
 	case MSR_IA32_XFD_ERR:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_XFD))
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_XFD))
 			return 1;
 
 		msr_info->data = vcpu->arch.guest_fpu.xfd_err;
@@ -8508,17 +8508,17 @@ static bool emulator_get_cpuid(struct x86_emulate_ctxt *ctxt,
 
 static bool emulator_guest_has_movbe(struct x86_emulate_ctxt *ctxt)
 {
-	return guest_cpuid_has(emul_to_vcpu(ctxt), X86_FEATURE_MOVBE);
+	return guest_cpu_cap_has(emul_to_vcpu(ctxt), X86_FEATURE_MOVBE);
 }
 
 static bool emulator_guest_has_fxsr(struct x86_emulate_ctxt *ctxt)
 {
-	return guest_cpuid_has(emul_to_vcpu(ctxt), X86_FEATURE_FXSR);
+	return guest_cpu_cap_has(emul_to_vcpu(ctxt), X86_FEATURE_FXSR);
 }
 
 static bool emulator_guest_has_rdpid(struct x86_emulate_ctxt *ctxt)
 {
-	return guest_cpuid_has(emul_to_vcpu(ctxt), X86_FEATURE_RDPID);
+	return guest_cpu_cap_has(emul_to_vcpu(ctxt), X86_FEATURE_RDPID);
 }
 
 static ulong emulator_read_gpr(struct x86_emulate_ctxt *ctxt, unsigned reg)
-- 
2.45.0.215.g3402c0e53f-goog


