Return-Path: <kvm+bounces-62026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DDE4C32DCD
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 21:03:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DDD0C1894158
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 20:03:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8BD4301471;
	Tue,  4 Nov 2025 20:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="W8XREZvu"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FE42EA479
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 20:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762286424; cv=none; b=osSFWDlTldfvVQB1tuTUiITp1wVtcAj8QxAjjirk16+4oMJLj3Tl7EW7AfAhbSSU2nIO8j5jpxwouGlBiesrK+TP1S1PtPc7cumoNbekg79poQP/R1ahtHSaJCc8d5QzqYquyCFMTUAradsWVZSRBEiM/0TEm+MarkLZZt2aQiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762286424; c=relaxed/simple;
	bh=1iz/wfIOnrGoI4T/LYuSh2kNTKOiBkvYwHQ63PG6rW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btllJpdiYuR9Kp2IsJSXVzvn7D3C3E8khC9LUcUxfv2ovibSKudPu6/vnEDnDaoNM42RH8xvyJtLpW1vMYji9HRpgrW+QP1LjDU1kncDvJo/Q4N1+d+ooAWQun1fSMBW56/IDZUZiWGwEqwIQBatcc+1wdA9mbn/0RZ9iv3zOWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=W8XREZvu; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762286419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ud0O6WO/i+2mt2AsVx42pR3Yn1Qyh4ZT9ZTHkz5AX3s=;
	b=W8XREZvuW2ylSWm0YzPH7r7JiU9+UtMEWNOrH/5vFfIH2lOJ4Af/IsbvzPqqMVRuZsBwG0
	DQZ2e5netaZGYUyVJHxsJXZbfQDy+pQFHT0q38Wk9tK6PJpuNyFIG3c1jQddf+VZphuGsr
	kUMJdePwDnlguJfwwJ2xNqee8sTvBm8=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 08/11] KVM: nSVM: Restrict mapping VMCB12 on nested VMRUN
Date: Tue,  4 Nov 2025 19:59:46 +0000
Message-ID: <20251104195949.3528411-9-yosry.ahmed@linux.dev>
In-Reply-To: <20251104195949.3528411-1-yosry.ahmed@linux.dev>
References: <20251104195949.3528411-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

All accesses to the VMCB12 in the guest memory are limited to
nested_svm_vmrun(). However, the VMCB12 remains mapped until the end of
the function execution. Unmapping right after the consistency checks is
possible, but it becomes easy-ish to introduce bugs where 'vmcb12' is
used after being unmapped.

Move all accesses to the VMCB12 into a new helper,
nested_svm_vmrun_read_vmcb12(),  that maps the VMCB12,
caches the needed fields, performs consistency checks, and unmaps it.
This limits the scope of the VMCB12 mapping appropriately. It also
slightly simplifies the cleanup path of nested_svm_vmrun().

nested_svm_vmrun_read_vmcb12() returns -1 if the consistency checks
fail, maintaining the current behavior of skipping the instructions and
unmapping the VMCB12 (although in the opposite order).

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 59 ++++++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 901f6dc12b09f..8d5165df52f57 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1012,12 +1012,39 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa, bool from_vmrun)
 	return 0;
 }
 
+static int nested_svm_vmrun_read_vmcb12(struct kvm_vcpu *vcpu, u64 vmcb12_gpa)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct kvm_host_map map;
+	struct vmcb *vmcb12;
+	int ret;
+
+	ret = kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map);
+	if (ret)
+		return ret;
+
+	vmcb12 = map.hva;
+
+	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
+	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
+
+	if (!nested_vmcb_check_save(vcpu) ||
+	    !nested_vmcb_check_controls(vcpu)) {
+		vmcb12->control.exit_code    = SVM_EXIT_ERR;
+		vmcb12->control.exit_code_hi = 0;
+		vmcb12->control.exit_info_1  = 0;
+		vmcb12->control.exit_info_2  = 0;
+		ret = -1;
+	}
+
+	kvm_vcpu_unmap(vcpu, &map);
+	return ret;
+}
+
 int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	int ret;
-	struct vmcb *vmcb12;
-	struct kvm_host_map map;
 	u64 vmcb12_gpa;
 	struct vmcb *vmcb01 = svm->vmcb01.ptr;
 
@@ -1038,8 +1065,11 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 		return ret;
 	}
 
+	if (WARN_ON_ONCE(!svm->nested.initialized))
+		return -EINVAL;
+
 	vmcb12_gpa = svm->vmcb->save.rax;
-	ret = kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map);
+	ret = nested_svm_vmrun_read_vmcb12(vcpu, vmcb12_gpa);
 	if (ret == -EINVAL) {
 		kvm_inject_gp(vcpu, 0);
 		return 1;
@@ -1049,23 +1079,6 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 
 	ret = kvm_skip_emulated_instruction(vcpu);
 
-	vmcb12 = map.hva;
-
-	if (WARN_ON_ONCE(!svm->nested.initialized))
-		return -EINVAL;
-
-	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
-	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
-
-	if (!nested_vmcb_check_save(vcpu) ||
-	    !nested_vmcb_check_controls(vcpu)) {
-		vmcb12->control.exit_code    = SVM_EXIT_ERR;
-		vmcb12->control.exit_code_hi = 0;
-		vmcb12->control.exit_info_1  = 0;
-		vmcb12->control.exit_info_2  = 0;
-		goto out;
-	}
-
 	/*
 	 * Since vmcb01 is not in use, we can use it to store some of the L1
 	 * state.
@@ -1085,7 +1098,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 		goto out_exit_err;
 
 	if (nested_svm_merge_msrpm(vcpu))
-		goto out;
+		return ret;
 
 out_exit_err:
 	svm->nested.nested_run_pending = 0;
@@ -1098,10 +1111,6 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	svm->vmcb->control.exit_info_2  = 0;
 
 	nested_svm_vmexit(svm);
-
-out:
-	kvm_vcpu_unmap(vcpu, &map);
-
 	return ret;
 }
 
-- 
2.51.2.1026.g39e6a42477-goog


