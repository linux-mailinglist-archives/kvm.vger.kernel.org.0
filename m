Return-Path: <kvm+bounces-66020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id B7CF6CBF957
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 20:42:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8F0A6301B24D
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 19:42:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26374330B04;
	Mon, 15 Dec 2025 19:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ixKmQ+ne"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955C032FA24
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 19:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765826956; cv=none; b=k/b57NMCJxnw9t4O7U85kHx+cVIGTtrcexst6sfg7vVno1Cd3mfpbL0p04LDsoQ7iGpDy4ApXk7TiCIjFP14RCEZKGvPhEeSI/QeH7Q81VgpPjIqHgvGpDN/rrJKzTCslKQZd0H7h/cSWAcA2g29GySNuXTm55pzNGoX16vnWxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765826956; c=relaxed/simple;
	bh=vqmGtyNcxZBUMmzKTGuhJCdCvmt1hUpklV+9z4JMl2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rctWiJIbKu8siHv81sbaxFPgxbH6Ygez+Ov2G3aYWPCtcdk56SuVRt0ARdkMzIhqUI4k9sImg3SHNn+jw2zy05Kzo+aFU+kysqJ82DwZO54nMJDZ/qzJhwrmJnLJI4qmBNHKRcDIH1PVqMQjV13OUZQAzI5MngRn+SyqCACp2No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ixKmQ+ne; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765826946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tGC+3I5jdDiVSdip2yon18Xgyc7ruVlajqlB/AAYT/0=;
	b=ixKmQ+neE0WHZlXSgpOlFrcv2U/YEMm2Y/eNi0QRIMx2HILg3XFrF2YywYFKuVrG13Cw7G
	k7DDSh+Z7uVZaUkOBCwDPQhBDeKwNwanq+b5WOf89TO/mo0Iwxh/Bd7wW5p1F377TPIyQB
	3efAh/5wm1LWNVm0+TvbOABByBUWQD4=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v3 14/26] KVM: nSVM: Clear EVENTINJ field in VMCB12 on nested #VMEXIT
Date: Mon, 15 Dec 2025 19:27:09 +0000
Message-ID: <20251215192722.3654335-16-yosry.ahmed@linux.dev>
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

According to the APM, from the reference of the VMRUN instruction:

	Upon #VMEXIT, the processor performs the following actions in
	order to return to the host execution context:
	...
	clear EVENTINJ field in VMCB

KVM correctly cleared EVENTINJ (i.e. event_inj and event_inj_err) on
nested #VMEXIT before commit 2d8a42be0e2b ("KVM: nSVM: synchronize VMCB
controls updated by the processor on every vmexit"). That commit made
sure the fields are synchronized between VMCB02 and KVM's cached VMCB12
on every L2->L0 #VMEXIT, such that they are serialized correctly on
save/restore.

However, the commit also incorrectly copied the fields from KVM's cached
VMCB12 to L1's VMCB12 on nested #VMEXIT. Go back to clearing the fields,
and so in __nested_svm_vmexit() instead of nested_svm_vmexit(), such
that it also applies to #VMEXITs caused by a failed VMRUN.

Fixes: 2d8a42be0e2b ("KVM: nSVM: synchronize VMCB controls updated by the processor on every vmexit")
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 632e941febaf..b4074e674c9d 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -937,7 +937,7 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 	return 0;
 }
 
-static void __nested_svm_vmexit(struct vcpu_svm *svm)
+static void __nested_svm_vmexit(struct vcpu_svm *svm, struct vmcb *vmcb12)
 {
 	struct vmcb *vmcb01 = svm->vmcb01.ptr;
 	struct kvm_vcpu *vcpu = &svm->vcpu;
@@ -949,6 +949,10 @@ static void __nested_svm_vmexit(struct vcpu_svm *svm)
 	svm_set_gif(svm, false);
 	vmcb01->control.exit_int_info = 0;
 
+	/* event_inj is cleared on #VMEXIT */
+	vmcb12->control.event_inj = 0;
+	vmcb12->control.event_inj_err = 0;
+
 	nested_svm_uninit_mmu_context(vcpu);
 	if (nested_svm_load_cr3(vcpu, vmcb01->save.cr3, false, true)) {
 		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
@@ -973,7 +977,7 @@ static void nested_svm_failed_vmrun(struct vcpu_svm *svm, struct vmcb *vmcb12)
 	vmcb12->control.exit_code_hi = -1u;
 	vmcb12->control.exit_info_1 = 0;
 	vmcb12->control.exit_info_2 = 0;
-	__nested_svm_vmexit(svm);
+	__nested_svm_vmexit(svm, vmcb12);
 }
 
 int nested_svm_vmrun(struct kvm_vcpu *vcpu)
@@ -1156,8 +1160,6 @@ void nested_svm_vmexit(struct vcpu_svm *svm)
 		vmcb12->control.next_rip  = vmcb02->control.next_rip;
 
 	vmcb12->control.int_ctl           = svm->nested.ctl.int_ctl;
-	vmcb12->control.event_inj         = svm->nested.ctl.event_inj;
-	vmcb12->control.event_inj_err     = svm->nested.ctl.event_inj_err;
 
 	if (!kvm_pause_in_guest(vcpu->kvm)) {
 		vmcb01->control.pause_filter_count = vmcb02->control.pause_filter_count;
@@ -1259,8 +1261,6 @@ void nested_svm_vmexit(struct vcpu_svm *svm)
 				       vmcb12->control.exit_int_info_err,
 				       KVM_ISA_SVM);
 
-	kvm_vcpu_unmap(vcpu, &map);
-
 	nested_svm_transition_tlb_flush(vcpu);
 
 	/*
@@ -1282,7 +1282,9 @@ void nested_svm_vmexit(struct vcpu_svm *svm)
 	 * Potentially queues an exception, so it needs to be after
 	 * kvm_clear_exception_queue() is called above.
 	 */
-	__nested_svm_vmexit(svm);
+	__nested_svm_vmexit(svm, vmcb12);
+
+	kvm_vcpu_unmap(vcpu, &map);
 }
 
 static void nested_svm_triple_fault(struct kvm_vcpu *vcpu)
-- 
2.52.0.239.gd5f0c6e74e-goog


