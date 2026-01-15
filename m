Return-Path: <kvm+bounces-68135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BF260D22011
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 02:22:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7074530A9295
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 01:16:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93BB72F83AE;
	Thu, 15 Jan 2026 01:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qUgFLV2r"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B4D277C81
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 01:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768439654; cv=none; b=a7hhxll6xDleuiyGa1Cw2RQDiZg4Ftf/gxmJ1hO7OjBcy91pG7R/25oGtxW8rUx2aevKKjcJ6/0ynimeydpRwYPn9UhXafONwoXYslXurh9NsXnaViVC1n0nAJsrJcD3EbsCWvWLDknf4kakcBCh5FAKprSbdk0QF7dyWkfqQxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768439654; c=relaxed/simple;
	bh=Qlu3Lp54f4zFWXD5cf4zC5yJctkRtLqm+EfogPn9oaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0bAQzJvd48N+9lpxdiGfQ3xcHvPGVD74JWfv66NnWU6sMZdPB49iBy6VxLynV4tFCGx2saXH1vSNC42P8mtrzeqk0eZmCE/3+voqDlWiQf6aFpHMcczBi4XQ5lOnYiKmEzcpTAmbHK1/7MYUuXAAVzTlQmaTL+M5Wi+dEoLeHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qUgFLV2r; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768439649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AP1xGvQmyw2BkX2nyvuRJpthBoydAPRLydd8FnGb970=;
	b=qUgFLV2rfN8FQvuqAxEyNeoCsDBwWD4PNDf/mFrtR7JZCJDDwx0mvY7MOmqWz+Ex+m8vQB
	vytmCx/8iXvVUyeyn3LCdc57pAwX2+eWx64g0ljzZ64jizqouhi2y6Na6LTzRT7xvruuPH
	KtZVaZYqSTn/YsfkvlcEGE+ptzzUy+A=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v4 24/26] KVM: nSVM: Restrict mapping VMCB12 on nested VMRUN
Date: Thu, 15 Jan 2026 01:13:10 +0000
Message-ID: <20260115011312.3675857-25-yosry.ahmed@linux.dev>
In-Reply-To: <20260115011312.3675857-1-yosry.ahmed@linux.dev>
References: <20260115011312.3675857-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

All accesses to the VMCB12 in the guest memory on nested VMRUN are
limited to nested_svm_vmrun() and nested_svm_failed_vmrun(). However,
the VMCB12 remains mapped throughout nested_svm_vmrun().  Mapping and
unmapping around usages is possible, but it becomes easy-ish to
introduce bugs where 'vmcb12' is used after being unmapped.

Move reading the VMCB12 and copying to cache from nested_svm_vmrun()
into a new helper, nested_svm_copy_vmcb12_to_cache(),  that maps the
VMCB12, caches the needed fields, and unmaps it. Use
kvm_vcpu_map_readonly() as only reading the VMCB12 is needed.

Similarly, move mapping the VMCB12 on VMRUN failure into
nested_svm_failed_vmrun(). Inject a triple fault if the mapping fails,
similar to nested_svm_vmexit().

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 55 ++++++++++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 7209bbe19548..ffb741f401d0 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1106,25 +1106,57 @@ static void __nested_svm_vmexit(struct vcpu_svm *svm, struct vmcb *vmcb12)
 		kvm_queue_exception(vcpu, DB_VECTOR);
 }
 
-static void nested_svm_failed_vmrun(struct vcpu_svm *svm, struct vmcb *vmcb12)
+static void nested_svm_failed_vmrun(struct vcpu_svm *svm, u64 vmcb12_gpa)
 {
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct kvm_host_map map;
+	struct vmcb *vmcb12;
+	int r;
+
 	WARN_ON(svm->vmcb == svm->nested.vmcb02.ptr);
 
 	leave_guest_mode(vcpu);
 
+	r = kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map);
+	if (r) {
+		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+		return;
+	}
+
+	vmcb12 = map.hva;
 	vmcb12->control.exit_code = SVM_EXIT_ERR;
 	vmcb12->control.exit_code_hi = -1u;
 	vmcb12->control.exit_info_1 = 0;
 	vmcb12->control.exit_info_2 = 0;
 	__nested_svm_vmexit(svm, vmcb12);
+
+	kvm_vcpu_unmap(vcpu, &map);
+}
+
+static int nested_svm_copy_vmcb12_to_cache(struct kvm_vcpu *vcpu, u64 vmcb12_gpa)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct kvm_host_map map;
+	struct vmcb *vmcb12;
+	int r;
+
+	r = kvm_vcpu_map_readonly(vcpu, gpa_to_gfn(vmcb12_gpa), &map);
+	if (r)
+		return r;
+
+	vmcb12 = map.hva;
+
+	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
+	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
+
+	kvm_vcpu_unmap(vcpu, &map);
+	return 0;
 }
 
 int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	int ret;
-	struct vmcb *vmcb12;
-	struct kvm_host_map map;
 	u64 vmcb12_gpa;
 	struct vmcb *vmcb01 = svm->vmcb01.ptr;
 
@@ -1145,22 +1177,17 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 		return ret;
 	}
 
+	if (WARN_ON_ONCE(!svm->nested.initialized))
+		return -EINVAL;
+
 	vmcb12_gpa = svm->vmcb->save.rax;
-	if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map)) {
+	if (nested_svm_copy_vmcb12_to_cache(vcpu, vmcb12_gpa)) {
 		kvm_inject_gp(vcpu, 0);
 		return 1;
 	}
 
 	ret = kvm_skip_emulated_instruction(vcpu);
 
-	vmcb12 = map.hva;
-
-	if (WARN_ON_ONCE(!svm->nested.initialized))
-		return -EINVAL;
-
-	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
-	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
-
 	/*
 	 * Since vmcb01 is not in use, we can use it to store some of the L1
 	 * state.
@@ -1181,11 +1208,9 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 		svm->nmi_l1_to_l2 = false;
 		svm->soft_int_injected = false;
 
-		nested_svm_failed_vmrun(svm, vmcb12);
+		nested_svm_failed_vmrun(svm, vmcb12_gpa);
 	}
 
-	kvm_vcpu_unmap(vcpu, &map);
-
 	return ret;
 }
 
-- 
2.52.0.457.g6b5491de43-goog


