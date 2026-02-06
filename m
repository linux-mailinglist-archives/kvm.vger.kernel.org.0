Return-Path: <kvm+bounces-70502-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wFwyEKM9hmnzLAQAu9opvQ
	(envelope-from <kvm+bounces-70502-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 20:14:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C1AB310289D
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 20:14:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D4DC33025D08
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 19:12:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF7E44418D9;
	Fri,  6 Feb 2026 19:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NApjlN/g"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA91C4418CA
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 19:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770404991; cv=none; b=rE+3A9CoMCq+Yo0D9hvc1p2IjJyc6n6FyUZYpyToO0oeLGxit7LFaCnPn810zPY4mFiWv5j1ZiwYOHMzw2B+NqO+CdPDCEs2l8+tq/W9YF1fZ67NGMU4jvk4rtClkPqB5q6khvrCyKF01g0m0x4KuLqL0PXWtdDrhlwhjxgLnJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770404991; c=relaxed/simple;
	bh=tChEFl18ibAzaJ2GEzMTWsWRSgUzH5SqTZHdeomPuqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7HSO5uQhMSrQt6GCLe0oY8dBYJAHxuDgmf/GdEDth3PuZ0mWLDH/36BcOPBdvr7j4w63nWvRFDmS1JZfO4Ft6+zKXVfFx3E+V98CYPkOJyvWphGgbKfKjAtUiUPTyoqpM8bgb1+ltXr4VegyT3rbpgA3NZ7Zcm9IavXYRexJV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NApjlN/g; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770404989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ogj2BvymrjP7EHk/aTikaXPciJhAL1YMt9xpscARaOc=;
	b=NApjlN/g4iu2vmC3mVXQ9kED1ZA00hE/9PL1K4n0pNqyysf1X6dKzzaWhn8MUir80BLGbP
	xOeGtC8zeJt9mleG1tbQRnVzPH5O3nQn6UD6UquVm8an1rDZFRCnOFGPQAIee3HTN/E3PD
	ggH3kA2/IK+QCoAAAAjllRFzUpQHGT4=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v5 24/26] KVM: nSVM: Restrict mapping VMCB12 on nested VMRUN
Date: Fri,  6 Feb 2026 19:08:49 +0000
Message-ID: <20260206190851.860662-25-yosry.ahmed@linux.dev>
In-Reply-To: <20260206190851.860662-1-yosry.ahmed@linux.dev>
References: <20260206190851.860662-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70502-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	NEURAL_HAM(-0.00)[-0.996];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: C1AB310289D
X-Rspamd-Action: no action

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
 arch/x86/kvm/svm/nested.c | 53 ++++++++++++++++++++++++++++-----------
 1 file changed, 38 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index b1f3e9df2cd5..0a7bb01f5404 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1102,26 +1102,56 @@ static void __nested_svm_vmexit(struct vcpu_svm *svm, struct vmcb *vmcb12)
 		kvm_queue_exception(vcpu, DB_VECTOR);
 }
 
-static void nested_svm_vmrun_error_vmexit(struct kvm_vcpu *vcpu, struct vmcb *vmcb12)
+static void nested_svm_vmrun_error_vmexit(struct kvm_vcpu *vcpu, u64 vmcb12_gpa)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	struct kvm_host_map map;
+	struct vmcb *vmcb12;
+	int r;
 
 	WARN_ON_ONCE(svm->vmcb == svm->nested.vmcb02.ptr);
 
 	leave_guest_mode(vcpu);
 
+	r = kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map);
+	if (r) {
+		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+		return;
+	}
+
+	vmcb12 = map.hva;
 	vmcb12->control.exit_code = SVM_EXIT_ERR;
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
 
@@ -1142,22 +1172,17 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
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
@@ -1178,11 +1203,9 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 		svm->nmi_l1_to_l2 = false;
 		svm->soft_int_injected = false;
 
-		nested_svm_vmrun_error_vmexit(vcpu, vmcb12);
+		nested_svm_vmrun_error_vmexit(vcpu, vmcb12_gpa);
 	}
 
-	kvm_vcpu_unmap(vcpu, &map);
-
 	return ret;
 }
 
-- 
2.53.0.rc2.204.g2597b5adb4-goog


