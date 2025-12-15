Return-Path: <kvm+bounces-66003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CCEFCBF894
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 20:25:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 42106301AD02
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 19:25:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9030332D43E;
	Mon, 15 Dec 2025 19:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y8XV+4CK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325AD30F80D
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 19:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765826715; cv=none; b=Pkepp2q39AX7EMxEAdZPMTUe3LFK2S6stWDWc3ofdKG8mQm74LQ+Y8axHTeioBJTzKz6BNtMutMjf5lk+tP0vN0M+8kwRluY1ybWrWLG4oWSqXduK1TwmoJom0cxNd366HgOt2lTx2mljYf5ipgKd52OAsW5tnQoHL0Yll5aRb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765826715; c=relaxed/simple;
	bh=0fclIdqUBdcgpzQEYAw1obUVgdqABAf6E/xc732decE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=A08QzPVak2GCNo+sZY4ar4Em2W9C+wTmz+cYQjLUyhn2V6Z+YcVGPES5ZZ5tM+4SJM7vUTA/xMrFQ+OYIUAADVkMNtn+IOvca9bIv6j1V2EpfnXhfmnMsclBJOHvGOTKQoGLT4+B8s9A/hLaLbv5/A5i89JaJmvi+LofJF88kKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y8XV+4CK; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-341616a6fb7so4071305a91.0
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 11:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765826713; x=1766431513; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Mw6Udw3xyK1jm/MjliE0wzhu/i34l1ZJcAQTPaQhsRI=;
        b=y8XV+4CKQxMphxp5mLir0ABNnrcr+PvrC5/8fd87UF5iKBvjo8T8zduDDD7EvIOGeH
         fuV6MumL9Np0lcq4RvBw5VmiXDTpp2G3czpyxvd8l9Eb06x1lGBo+FiS7+PD+n8T4acG
         W+cfcbFk8zvhWjyr6dQ/ulxcbQD0EtbyO5AakzRaMMSutKqanD6zdk8+m8nj2g5CRa5/
         XMoQNenSrGgD4WogqtHzw8QtRdA1VeSs+DOx3skyMfjdDGBWqvvbrQviYVPFMAhMKrSE
         1KWVqZ5EWk74CDMtNfdjoCVRTI42tw0gLX9PFMPIfCxNszbf4LFxP6efzMiuBnRbwzp8
         +5+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765826713; x=1766431513;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Mw6Udw3xyK1jm/MjliE0wzhu/i34l1ZJcAQTPaQhsRI=;
        b=L2rBOFLMB6PUuMIbekVj8AjqV2d5k3J2Yi+qBK8HP4v6505OU87BXtWNRUtNBlcc87
         KEqsFt8vcskjXtVwm01OmUxB9Mqrc/m821AOCDNVzKZPp+TBrjvf50oHbwzgmd7Cy6Ff
         IB3MYL+LrRuNMmZ+BpmparY51dkV+pQoYxP3UABzHCyUsztaWI67mfu0eKRxQRqZJD30
         Auq5JlLIE2/Iml2En84gnWeRoFgxw8JtJxDU3uuHTkUVB2uyTj5a8mBiEmAbQvs2Yo+6
         X80MLxn8dk75r6ixnM8C2Ir1OqLelZ4WPzwpSAWvE0OdjmP+Jjcqu8QbrA4uDidwxE10
         hZpA==
X-Forwarded-Encrypted: i=1; AJvYcCWAiXvEoynDY3cG8e+OW93nI23iZ/nD5MtuZzk5FaxgWc+dvKxzOsjOZmazmbfhU6sZ9aU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyd86AvMavjH1booubRuIVknkf8Wl/I14gOLRlOHSfsGv1QzPur
	ANyc5ygxRUHNjMCcgBuJp85hYuveOZ1Pg2WqeUDsSFP5oNgSN60I1zPoCiDdZzzeD7UXtEp0rKO
	YbyWnGsdBk9HJOQ==
X-Google-Smtp-Source: AGHT+IF8cbot5VvfqnTdcWU2OcVUgi1UF8pxXBKRfLH98glNSAmpbF3+jx0uZnw2NfwLVz7aAFOxE9M4KwwQ7A==
X-Received: from pjtl21.prod.google.com ([2002:a17:90a:c595:b0:34a:bcb2:43ba])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1d04:b0:336:b60f:3936 with SMTP id 98e67ed59e1d1-34abd7be51cmr12086930a91.12.1765826713447;
 Mon, 15 Dec 2025 11:25:13 -0800 (PST)
Date: Mon, 15 Dec 2025 19:25:10 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251215192510.2300816-1-chengkev@google.com>
Subject: [PATCH v3] KVM: SVM: Don't allow L1 intercepts for instructions not advertised
From: Kevin Cheng <chengkev@google.com>
To: seanjc@google.com, pbonzini@redhat.com
Cc: jmattson@google.com, yosry.ahmed@linux.dev, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"

If a feature is not advertised in the guest's CPUID, prevent L1 from
intercepting the unsupported instructions by clearing the corresponding
intercept in KVM's cached vmcb12.

When an L2 guest executes an instruction that is not advertised to L1,
we expect a #UD exception to be injected by L0. However, the nested svm
exit handler first checks if the instruction intercept is set in vmcb12,
and if so, synthesizes an exit from L2 to L1 instead of a #UD exception.
If a feature is not advertised, the L1 intercept should be ignored.

While creating KVM's cached vmcb12, sanitize the intercepts for
instructions that are not advertised in the guest CPUID. This
effectively ignores the L1 intercept on nested vm exit handling. It also
ignores the L1 intercept when computing the intercepts in vmcb02, so if
L0 (for some reason) does not intercept the instruction, KVM won't
intercept it at all.

Signed-off-by: Kevin Cheng <chengkev@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
v2 -> v3:
  - Edit commit message

v2: https://lore.kernel.org/all/20251215160710.1768474-1-chengkev@google.com/

 arch/x86/kvm/svm/nested.c | 19 +++++++++++++++++++
 arch/x86/kvm/svm/svm.h    | 35 +++++++++++++++++++++++++++--------
 2 files changed, 46 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index c81005b245222..5ffc12a315ec7 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -403,6 +403,19 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu)
 	return __nested_vmcb_check_controls(vcpu, ctl);
 }

+/*
+ * If a feature is not advertised to L1, clear the corresponding vmcb12
+ * intercept.
+ */
+#define __nested_svm_sanitize_intercept(__vcpu, __control, fname, iname)	\
+do {										\
+	if (!guest_cpu_cap_has(__vcpu, X86_FEATURE_##fname))			\
+		vmcb12_clr_intercept(__control, INTERCEPT_##iname);		\
+} while (0)
+
+#define nested_svm_sanitize_intercept(__vcpu, __control, name)			\
+	__nested_svm_sanitize_intercept(__vcpu, __control, name, name)
+
 static
 void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 					 struct vmcb_ctrl_area_cached *to,
@@ -413,6 +426,12 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 	for (i = 0; i < MAX_INTERCEPT; i++)
 		to->intercepts[i] = from->intercepts[i];

+	__nested_svm_sanitize_intercept(vcpu, to, XSAVE, XSETBV);
+	nested_svm_sanitize_intercept(vcpu, to, INVPCID);
+	nested_svm_sanitize_intercept(vcpu, to, RDTSCP);
+	nested_svm_sanitize_intercept(vcpu, to, SKINIT);
+	nested_svm_sanitize_intercept(vcpu, to, RDPRU);
+
 	to->iopm_base_pa        = from->iopm_base_pa;
 	to->msrpm_base_pa       = from->msrpm_base_pa;
 	to->tsc_offset          = from->tsc_offset;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9e151dbdef25d..7a8c92c4de2fb 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -434,28 +434,47 @@ static __always_inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
  */
 #define SVM_REGS_LAZY_LOAD_SET	(1 << VCPU_EXREG_PDPTR)

-static inline void vmcb_set_intercept(struct vmcb_control_area *control, u32 bit)
+static inline void __vmcb_set_intercept(unsigned long *intercepts, u32 bit)
 {
 	WARN_ON_ONCE(bit >= 32 * MAX_INTERCEPT);
-	__set_bit(bit, (unsigned long *)&control->intercepts);
+	__set_bit(bit, intercepts);
 }

-static inline void vmcb_clr_intercept(struct vmcb_control_area *control, u32 bit)
+static inline void __vmcb_clr_intercept(unsigned long *intercepts, u32 bit)
 {
 	WARN_ON_ONCE(bit >= 32 * MAX_INTERCEPT);
-	__clear_bit(bit, (unsigned long *)&control->intercepts);
+	__clear_bit(bit, intercepts);
 }

-static inline bool vmcb_is_intercept(struct vmcb_control_area *control, u32 bit)
+static inline bool __vmcb_is_intercept(unsigned long *intercepts, u32 bit)
 {
 	WARN_ON_ONCE(bit >= 32 * MAX_INTERCEPT);
-	return test_bit(bit, (unsigned long *)&control->intercepts);
+	return test_bit(bit, intercepts);
+}
+
+static inline void vmcb_set_intercept(struct vmcb_control_area *control, u32 bit)
+{
+	__vmcb_set_intercept((unsigned long *)&control->intercepts, bit);
+}
+
+static inline void vmcb_clr_intercept(struct vmcb_control_area *control, u32 bit)
+{
+	__vmcb_clr_intercept((unsigned long *)&control->intercepts, bit);
+}
+
+static inline bool vmcb_is_intercept(struct vmcb_control_area *control, u32 bit)
+{
+	return __vmcb_is_intercept((unsigned long *)&control->intercepts, bit);
+}
+
+static inline void vmcb12_clr_intercept(struct vmcb_ctrl_area_cached *control, u32 bit)
+{
+	__vmcb_clr_intercept((unsigned long *)&control->intercepts, bit);
 }

 static inline bool vmcb12_is_intercept(struct vmcb_ctrl_area_cached *control, u32 bit)
 {
-	WARN_ON_ONCE(bit >= 32 * MAX_INTERCEPT);
-	return test_bit(bit, (unsigned long *)&control->intercepts);
+	return __vmcb_is_intercept((unsigned long *)&control->intercepts, bit);
 }

 static inline void set_exception_intercept(struct vcpu_svm *svm, u32 bit)
--
2.52.0.239.gd5f0c6e74e-goog


