Return-Path: <kvm+bounces-62629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 892C7C49983
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 23:35:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E37F718860DB
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 22:34:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7675337BB4;
	Mon, 10 Nov 2025 22:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aLTbydnd"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A36346FB2
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 22:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762813802; cv=none; b=b7brBg6yt0KCCyh70Y6TuPt78OCK/oNOsag1V4sg1pFe4YXmldx+d/zl//+mG7Y3simFBiIJdgZclGJWeQp4HG1wJok0h7zHbw9rIOQTQ1RVOSQji/tRMcIA5d5RsmsJXnJGAxHWlNTWm8aM/RKnxKTiKzY0KfCDeY05ajYKJS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762813802; c=relaxed/simple;
	bh=kZLGhdUqKziP6wJo1TK4s2e4k+8TAd9mui2sIZ1T0qY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iiibRt/8phaVDLFnB1Sg6CS5yFAUpsIDtqqSOtz9FBVsCu3HiY6jfCdO7UgxKMuy3kzpfMVzExaEDI8VnCv2Dk8yDune3nOYqVmRvUh4YOG69avqlSXPIYWED1L9/YHnW93IZhAdwyV+PJwgDi80bqHzwtPhcOqX8x8cVAc+Kfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aLTbydnd; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762813798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7JW+Xtx3ikg89gAAbE+q15fKd9gDpo0qaghJYGfsrC8=;
	b=aLTbydndnCcCg/o3XJY19Fs68ss+e46QxMPlmXcr5lOZbUnB2iFb11wfUa4iRO0Xd6XmsJ
	AXEUFyajr0Os6sNsoAcQQNpRi031kYT6fJGjRH/KMO0Ck1sPPRZtbfl105lUNg0c9O64EQ
	cosx476VX3iknBTmybESrW+jrzGjkDU=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v2 10/13] KVM: nSVM: Restrict mapping VMCB12 on nested VMRUN
Date: Mon, 10 Nov 2025 22:29:19 +0000
Message-ID: <20251110222922.613224-11-yosry.ahmed@linux.dev>
In-Reply-To: <20251110222922.613224-1-yosry.ahmed@linux.dev>
References: <20251110222922.613224-1-yosry.ahmed@linux.dev>
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
index ddcd545ec1c3c..a48668c36a191 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1023,12 +1023,39 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa, bool from_vmrun)
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
 
@@ -1049,8 +1076,11 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
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
@@ -1060,23 +1090,6 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 
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
@@ -1096,7 +1109,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 		goto out_exit_err;
 
 	if (nested_svm_merge_msrpm(vcpu))
-		goto out;
+		return ret;
 
 out_exit_err:
 	svm->nested.nested_run_pending = 0;
@@ -1109,10 +1122,6 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	svm->vmcb->control.exit_info_2  = 0;
 
 	nested_svm_vmexit(svm);
-
-out:
-	kvm_vcpu_unmap(vcpu, &map);
-
 	return ret;
 }
 
-- 
2.51.2.1041.gc1ab5b90ca-goog


