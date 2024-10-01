Return-Path: <kvm+bounces-27732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 42B8998B363
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 07:04:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F34DB283F79
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 05:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 866941BF327;
	Tue,  1 Oct 2024 05:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="ZOcNA0vH"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B261BBBC4;
	Tue,  1 Oct 2024 05:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727758940; cv=none; b=qYIeyjU51Zg+o6zxCXDH3Q4z4xZRXxPXYqVWPAn0q7TPmeT3vXO7WKSWlqHr7mfCvRQyfLl8SYKMGVuhEpPHgAbQdUkjPk0dWArtsYbpYHpn1K7aOKGCIsqe5AwzDivUte8b8oCd9bvw329GmiZ2jYYVe13iA3kT5/H92PFQwVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727758940; c=relaxed/simple;
	bh=8YNK9wXy2zsLnEngVFVHxby7YzuTWyx2Tg67i8WAOIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=suJdcmtyWeN2nrDXkbZQghe4cO+npdfzIOYag551MC61CTI7lfw7B7mmmbxGMz+8XsEJU1JS6nrkflIagBvV5EjQXyZbj4vLoVapu7e6gJ3MuQhykz7DARbDQDQpqdCP0huDqc7nQoddeXVNvVVA3VX0Nv1fS321d0FM4s2ndUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=ZOcNA0vH; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 49151A7Q3643828
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 30 Sep 2024 22:01:16 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 49151A7Q3643828
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024091601; t=1727758877;
	bh=oe8kgmrnvG5dIiA9spE8kuU3AD62wgZ4OuqY/m2GFl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZOcNA0vHDvW3+FaN4G+KG7d8cCsW738HcbPHSYVgcMKYkYJokcbpNA61t2RLhuORr
	 HTaHVyXBhqCxGGwgtOdR/Zaa4TP/wAOcQK4UsccT6UJuYtRxikvPZiwll18oYi0iaV
	 xoA3hgEdpJh+gkTGkaZ45GG1C1Stoyk2KhRIcNzURCawu+6EbNN2UFEIbrfVyn8of9
	 8c1trLP6gmutHHuC/SpaYz9zNordD2C4nzfHAEZOGp/8xgXn8MhwYbun/QPMN9wq1F
	 90qZSxvYSlJ9OOomqUE/NuHUjclKWcS3u6ZQHPSsCJNVV9JnfQuqlz+bbYpCjgqTXl
	 F9xxnp5NMrWTQ==
From: "Xin Li (Intel)" <xin@zytor.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, xin@zytor.com
Subject: [PATCH v3 01/27] KVM: x86: Use a dedicated flow for queueing re-injected exceptions
Date: Mon, 30 Sep 2024 22:00:44 -0700
Message-ID: <20241001050110.3643764-2-xin@zytor.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241001050110.3643764-1-xin@zytor.com>
References: <20241001050110.3643764-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

Open code the filling of vcpu->arch.exception in kvm_requeue_exception()
instead of bouncing through kvm_multiple_exception(), as re-injection
doesn't actually share that much code with "normal" injection, e.g. the
VM-Exit interception check, payload delivery, and nested exception code
is all bypassed as those flows only apply during initial injection.

When FRED comes along, the special casing will only get worse, as FRED
explicitly tracks nested exceptions and essentially delivers the payload
on the stack frame, i.e. re-injection will need more inputs, and normal
injection will have yet more code that needs to be bypassed when KVM is
re-injecting an exception.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  4 +-
 arch/x86/kvm/svm/svm.c          | 15 +++---
 arch/x86/kvm/vmx/vmx.c          | 16 +++---
 arch/x86/kvm/x86.c              | 89 ++++++++++++++++-----------------
 4 files changed, 63 insertions(+), 61 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6d9f763a7bb9..43b08d12cb32 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2112,8 +2112,8 @@ int kvm_emulate_rdpmc(struct kvm_vcpu *vcpu);
 void kvm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr);
 void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_queue_exception_p(struct kvm_vcpu *vcpu, unsigned nr, unsigned long payload);
-void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned nr);
-void kvm_requeue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
+void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned int nr,
+			   bool has_error_code, u32 error_code);
 void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault);
 void kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
 				    struct x86_exception *fault);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9df3e1e5ae81..d9e2568bcd54 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4112,20 +4112,23 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
 		vcpu->arch.nmi_injected = true;
 		svm->nmi_l1_to_l2 = nmi_l1_to_l2;
 		break;
-	case SVM_EXITINTINFO_TYPE_EXEPT:
+	case SVM_EXITINTINFO_TYPE_EXEPT: {
+		u32 error_code = 0;
+
 		/*
 		 * Never re-inject a #VC exception.
 		 */
 		if (vector == X86_TRAP_VC)
 			break;
 
-		if (exitintinfo & SVM_EXITINTINFO_VALID_ERR) {
-			u32 err = svm->vmcb->control.exit_int_info_err;
-			kvm_requeue_exception_e(vcpu, vector, err);
+		if (exitintinfo & SVM_EXITINTINFO_VALID_ERR)
+			error_code = svm->vmcb->control.exit_int_info_err;
 
-		} else
-			kvm_requeue_exception(vcpu, vector);
+		kvm_requeue_exception(vcpu, vector,
+				      exitintinfo & SVM_EXITINTINFO_VALID_ERR,
+				      error_code);
 		break;
+	}
 	case SVM_EXITINTINFO_TYPE_INTR:
 		kvm_queue_interrupt(vcpu, vector, false);
 		break;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1a4438358c5e..6a93f5edbc0d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7136,13 +7136,17 @@ static void __vmx_complete_interrupts(struct kvm_vcpu *vcpu,
 	case INTR_TYPE_SOFT_EXCEPTION:
 		vcpu->arch.event_exit_inst_len = vmcs_read32(instr_len_field);
 		fallthrough;
-	case INTR_TYPE_HARD_EXCEPTION:
-		if (idt_vectoring_info & VECTORING_INFO_DELIVER_CODE_MASK) {
-			u32 err = vmcs_read32(error_code_field);
-			kvm_requeue_exception_e(vcpu, vector, err);
-		} else
-			kvm_requeue_exception(vcpu, vector);
+	case INTR_TYPE_HARD_EXCEPTION: {
+		u32 error_code = 0;
+
+		if (idt_vectoring_info & VECTORING_INFO_DELIVER_CODE_MASK)
+			error_code = vmcs_read32(error_code_field);
+
+		kvm_requeue_exception(vcpu, vector,
+				      idt_vectoring_info & VECTORING_INFO_DELIVER_CODE_MASK,
+				      error_code);
 		break;
+	}
 	case INTR_TYPE_SOFT_INTR:
 		vcpu->arch.event_exit_inst_len = vmcs_read32(instr_len_field);
 		fallthrough;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 83fe0a78146f..e8de9f4734a6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -833,9 +833,9 @@ static void kvm_queue_exception_vmexit(struct kvm_vcpu *vcpu, unsigned int vecto
 	ex->payload = payload;
 }
 
-static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
-		unsigned nr, bool has_error, u32 error_code,
-	        bool has_payload, unsigned long payload, bool reinject)
+static void kvm_multiple_exception(struct kvm_vcpu *vcpu, unsigned int nr,
+				   bool has_error, u32 error_code,
+				   bool has_payload, unsigned long payload)
 {
 	u32 prev_nr;
 	int class1, class2;
@@ -843,13 +843,10 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 
 	/*
-	 * If the exception is destined for L2 and isn't being reinjected,
-	 * morph it to a VM-Exit if L1 wants to intercept the exception.  A
-	 * previously injected exception is not checked because it was checked
-	 * when it was original queued, and re-checking is incorrect if _L1_
-	 * injected the exception, in which case it's exempt from interception.
+	 * If the exception is destined for L2, morph it to a VM-Exit if L1
+	 * wants to intercept the exception.
 	 */
-	if (!reinject && is_guest_mode(vcpu) &&
+	if (is_guest_mode(vcpu) &&
 	    kvm_x86_ops.nested_ops->is_exception_vmexit(vcpu, nr, error_code)) {
 		kvm_queue_exception_vmexit(vcpu, nr, has_error, error_code,
 					   has_payload, payload);
@@ -858,28 +855,9 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 
 	if (!vcpu->arch.exception.pending && !vcpu->arch.exception.injected) {
 	queue:
-		if (reinject) {
-			/*
-			 * On VM-Entry, an exception can be pending if and only
-			 * if event injection was blocked by nested_run_pending.
-			 * In that case, however, vcpu_enter_guest() requests an
-			 * immediate exit, and the guest shouldn't proceed far
-			 * enough to need reinjection.
-			 */
-			WARN_ON_ONCE(kvm_is_exception_pending(vcpu));
-			vcpu->arch.exception.injected = true;
-			if (WARN_ON_ONCE(has_payload)) {
-				/*
-				 * A reinjected event has already
-				 * delivered its payload.
-				 */
-				has_payload = false;
-				payload = 0;
-			}
-		} else {
-			vcpu->arch.exception.pending = true;
-			vcpu->arch.exception.injected = false;
-		}
+		vcpu->arch.exception.pending = true;
+		vcpu->arch.exception.injected = false;
+
 		vcpu->arch.exception.has_error_code = has_error;
 		vcpu->arch.exception.vector = nr;
 		vcpu->arch.exception.error_code = error_code;
@@ -920,29 +898,52 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 
 void kvm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr)
 {
-	kvm_multiple_exception(vcpu, nr, false, 0, false, 0, false);
+	kvm_multiple_exception(vcpu, nr, false, 0, false, 0);
 }
 EXPORT_SYMBOL_GPL(kvm_queue_exception);
 
-void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned nr)
-{
-	kvm_multiple_exception(vcpu, nr, false, 0, false, 0, true);
-}
-EXPORT_SYMBOL_GPL(kvm_requeue_exception);
 
 void kvm_queue_exception_p(struct kvm_vcpu *vcpu, unsigned nr,
 			   unsigned long payload)
 {
-	kvm_multiple_exception(vcpu, nr, false, 0, true, payload, false);
+	kvm_multiple_exception(vcpu, nr, false, 0, true, payload);
 }
 EXPORT_SYMBOL_GPL(kvm_queue_exception_p);
 
 static void kvm_queue_exception_e_p(struct kvm_vcpu *vcpu, unsigned nr,
 				    u32 error_code, unsigned long payload)
 {
-	kvm_multiple_exception(vcpu, nr, true, error_code,
-			       true, payload, false);
+	kvm_multiple_exception(vcpu, nr, true, error_code, true, payload);
+}
+
+void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned int nr,
+			   bool has_error_code, u32 error_code)
+{
+
+	/*
+	 * On VM-Entry, an exception can be pending if and only if event
+	 * injection was blocked by nested_run_pending.  In that case, however,
+	 * vcpu_enter_guest() requests an immediate exit, and the guest
+	 * shouldn't proceed far enough to need reinjection.
+	 */
+	WARN_ON_ONCE(kvm_is_exception_pending(vcpu));
+
+	/*
+	 * Do not check for interception when injecting an event for L2, as the
+	 * exception was checked for intercept when it was original queued, and
+	 * re-checking is incorrect if _L1_ injected the exception, in which
+	 * case it's exempt from interception.
+	 */
+	kvm_make_request(KVM_REQ_EVENT, vcpu);
+
+	vcpu->arch.exception.injected = true;
+	vcpu->arch.exception.has_error_code = has_error_code;
+	vcpu->arch.exception.vector = nr;
+	vcpu->arch.exception.error_code = error_code;
+	vcpu->arch.exception.has_payload = false;
+	vcpu->arch.exception.payload = 0;
 }
+EXPORT_SYMBOL_GPL(kvm_requeue_exception);
 
 int kvm_complete_insn_gp(struct kvm_vcpu *vcpu, int err)
 {
@@ -1013,16 +1014,10 @@ void kvm_inject_nmi(struct kvm_vcpu *vcpu)
 
 void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code)
 {
-	kvm_multiple_exception(vcpu, nr, true, error_code, false, 0, false);
+	kvm_multiple_exception(vcpu, nr, true, error_code, false, 0);
 }
 EXPORT_SYMBOL_GPL(kvm_queue_exception_e);
 
-void kvm_requeue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code)
-{
-	kvm_multiple_exception(vcpu, nr, true, error_code, false, 0, true);
-}
-EXPORT_SYMBOL_GPL(kvm_requeue_exception_e);
-
 /*
  * Checks if cpl <= required_cpl; if true, return true.  Otherwise queue
  * a #GP and return false.
-- 
2.46.2


