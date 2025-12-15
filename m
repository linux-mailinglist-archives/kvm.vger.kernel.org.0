Return-Path: <kvm+bounces-65988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E1DA3CBED9B
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 17:14:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BE2A2302D2A2
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 16:08:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C504B3126A2;
	Mon, 15 Dec 2025 16:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GnaR8ern"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0A430F92F
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 16:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765814879; cv=none; b=KWRlQNGzN/cieZFVjQ1uTUgFajRHZCl3hJfX+w+fBrkze4kT+1clxJ5FtccAjnlHmV6/baC2CICLlD8urlsw6FtkS7lpSjUglwx/y7RBl+ijzdHYUrurp7wPB/KAbT2SE+pOcmurRn2h/8h2F10zpA1LyQ4wbSdpGlwT4NSixJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765814879; c=relaxed/simple;
	bh=+4xe1iZfVRPBR4ECFQsnpb2jSdF83uH/G/fWPnC4mdc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=IoKPplE7BO9ijnoXf91z2KY9iwwYrcGGAzanEaVjPCfWsUxr4wZK2abkF85Odtf1b9rt83rx0poEe+bPdWBwKJ9hrml+2afpDguaPfoU7+VSV92/OTMAEHYf4EhrRBpoqfqZFmpON/QBvIgcyyvOS7pmTsvsfJmQLOn/CtgQ0aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GnaR8ern; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c37b8dc4fso4742167a91.2
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 08:07:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765814877; x=1766419677; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nT6Hj9nZToaeawg9ZdYWdQ6jcdndGyE7PtkODE5scAk=;
        b=GnaR8ernHoVjfegxesvr1+XeGDBfsWivbOlODB3zx+HlYo7OK6PD6O6ztReleFt4HD
         ug9Nwg3o4VyuNW+7ghygms1cisk5hY+TXPSlCuvmT9lf6UOAiVRxlDdZ79msaxEUxSKQ
         ARWGACG9gkE204yXkC/0bVtXcu+C4LxaINhDONYeiC2S9lzxFJSWYibfSBYW6QvJD1UF
         H4KdR+xnFbo3gMgTvZNpj3JxADC2xxnU4qKe0dC69xHotEjqik9lVx89z8Q1DiTIw99f
         tvA7FUbU5xiODcl20vzg8SmkdCNfPDBvEUvKE6gESplziES2w5JihrhCgXNhl4njtJGc
         bzBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765814877; x=1766419677;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nT6Hj9nZToaeawg9ZdYWdQ6jcdndGyE7PtkODE5scAk=;
        b=XWPLEhi1DbuqWcEQ2XHGW/briI6TAJOAK5nGxxyA5Ux6tkGuRUkp4JXSd2EESOLwuH
         L2Jigv8itSwFAzJMchDAO1QT52WzyTJtUDQ/2hJRhfDXe243+ld/pjXDzZi4Wuu/en3N
         t8DjYkPWbaEISzsURAtefnojmECqqeEqaV+Kw1/yJElcjENJ6WEr/NfoTIsrYwb5d8pU
         r5sttdP0t1mXtyEz8xT8TQwqx79iiYBntTzK0vgB+1y5KFpsGOeCBdEJ5vAqzbCc2TWy
         xERE+P6UzlEf+7rJkCLm371k/zfOO++59kUDV1aSof0Jb3QiTFI1qq6DTAbKu0fDsefy
         aY9g==
X-Forwarded-Encrypted: i=1; AJvYcCU7//HK6jx5FOT/OXh6aMbWUTNmsnI01t0I36LUpDqLjwCrVbuovVERCMMSdbCXfAaZlTk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1r6RbTkFQ07G1Ol6r4JoOX/xXVg7dHLBmWk5ZfxImxdsx4OfL
	VVm5QHTrLHRTLkBF63ZsqnPuOzQ4AUXgNt17JDJzHuv+c7F6/rxbDfXhi7rK+Xbqs/XnScmYY62
	1WCj0nIutiuumaQ==
X-Google-Smtp-Source: AGHT+IEqf//9eh5pdB+MFoAFUNCvM/jhTB4BDfBdBVN4ftUfCvlhVZnyPQH5a/T5bNthJjf0rFw3hN3JVZF3IA==
X-Received: from pjbgn5.prod.google.com ([2002:a17:90a:c785:b0:34a:4a21:bc22])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1dc6:b0:33e:1acc:1799 with SMTP id 98e67ed59e1d1-34abd6ccd82mr11243914a91.14.1765814876694;
 Mon, 15 Dec 2025 08:07:56 -0800 (PST)
Date: Mon, 15 Dec 2025 16:07:10 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251215160710.1768474-1-chengkev@google.com>
Subject: [PATCH v2] KVM: SVM: Don't allow L1 intercepts for instructions not advertised
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
effectively ignores the L1 intercept on nested vm exit handling.

Signed-off-by: Kevin Cheng <chengkev@google.com>
---
v1 -> v2:
  - Removed nested_intercept_mask which was a bit mask for nested
    intercepts to ignore.
  - Now sanitizing intercepts every time cached vmcb12 is created
  - New wrappers for vmcb set/clear intercept functions
  - Added macro functions for vmcb12 intercept sanitizing
  - All changes suggested by Sean. Thanks!
  - https://lore.kernel.org/all/20251205070630.4013452-1-chengkev@google.com/

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


