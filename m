Return-Path: <kvm+bounces-66030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E09C8CBFA65
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 21:04:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7F748306CF69
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 20:01:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 388D0322B76;
	Mon, 15 Dec 2025 19:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="q33jTxAm"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2FFE258ECC
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 19:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765827016; cv=none; b=MGTR5Uhc5L3C8r2i+q0ekITDfD0gysdDROQ9J8T130KCZIC7we1LyO8fAptgiBTTnlzrM4/fFZ6i4gi8km3V1U2kT60w2N1Uwxymc+kpqJYiANvxCRCUT8lO4IQnnuYMJBADzUfvhTqOdLXUrAXdVN003BVxeYZr2sJxWNXH9l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765827016; c=relaxed/simple;
	bh=+pVBRx1FdkGjkALw/hyiDSO13RCRJ0JAoSEoYNUB914=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0pYANusvwd1msvdeLKah55BqgHc3Sx0y60lhVIyiHWeL4cqyl5fOamx4TCTXKsaByfeOZpfPEe/hUGZSwS3SNFQdu3Sa9JjuBuZNIJ5Q4IjEu/JkUXRzE5oE25ywLJlIZcWfRPDH6PdVjO3FpQsc9z6JUOT4V+0kdL+xH/hZq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=q33jTxAm; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765827013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BhOM4DpFIjFD+SkOvwScA5aGiF3lzB/RoBG97GokPFc=;
	b=q33jTxAmgXYnEcKL5x2teoXhwfRmKxsLTQSH7Ii0GRfKf19aBkE3TsaLrHntM9LjwlMXaN
	64ACmVQW+Um7lRh7/iqzkq6vU1d3lzz91YJnkAGpyGfIj6jMysDgJhQsUkeo62nemBcqUp
	plTdQ0q14LG7MsBvqZBYun9jO2kEX+s=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 24/26] KVM: nSVM: Restrict mapping VMCB12 on nested VMRUN
Date: Mon, 15 Dec 2025 19:27:19 +0000
Message-ID: <20251215192722.3654335-26-yosry.ahmed@linux.dev>
In-Reply-To: <20251215192722.3654335-1-yosry.ahmed@linux.dev>
References: <20251215192722.3654335-1-yosry.ahmed@linux.dev>
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
index 48ba34d8b713..d33a2a27efe5 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1055,23 +1055,55 @@ static void __nested_svm_vmexit(struct vcpu_svm *svm, struct vmcb *vmcb12)
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
 
@@ -1092,22 +1124,17 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
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
@@ -1128,11 +1155,9 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
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
2.52.0.239.gd5f0c6e74e-goog


