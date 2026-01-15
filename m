Return-Path: <kvm+bounces-68124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id E505ED21F86
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 02:16:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 83DB030188CD
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 01:14:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80B8322D9F7;
	Thu, 15 Jan 2026 01:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vd6e04ms"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712792701C4
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 01:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768439639; cv=none; b=OEDCN3PjnCXOuhXtlhngaUNHQ4wXCC/1EWa2GNzKpBqTk1434VVRgGrehvpyKIvPkZs/O5NW6X7yCPzVb8uiAnrBWP+QEeN/2OFL53GACj7kXOmcOA4b9ydyXYchX/GXJijLMEC6aSD61jL2GBjSVyXsu2EczVf7Xp9mrUvaBds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768439639; c=relaxed/simple;
	bh=DmnQ5TdTjVWminP3Xf33CFReUn/d5NcYrsSTL0v+Us0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQLKmP2W9iPBhUoq5/0vW8hRKMF061Yyv0Ntu4boGFy3VHVPzKRwuvYp9dBakmtZiYMFpI1XA3WTUl9KN++ix1rN9EElJnZ06bBYR1E8f+H+glPxz+PR81ggRU2WlcSAHinSX1joHUn5/pRJwMJQ7wpypBmMA8joMpGBhtYUQSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vd6e04ms; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768439632;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V3xfRFV9ep/SW8LI7/0sQuoQMcHZNc6trK3lXoKTrTE=;
	b=vd6e04msPa01i8xXYRxS0CpG4E35HfrFglavMXAb6mrtvVeywDODs84TxD+uKiB0qIA08P
	cHarIZdRWBsqLRReo7SBUqS6NxWJn9GmfIGK7N+2CbA+CsAC9P2p3LsEwM/PcqdLW6/RAy
	UAsoFI8LcDZmnciZK2j0uMSM4A6/klI=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v4 14/26] KVM: nSVM: Clear EVENTINJ field in VMCB12 on nested #VMEXIT
Date: Thu, 15 Jan 2026 01:13:00 +0000
Message-ID: <20260115011312.3675857-15-yosry.ahmed@linux.dev>
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
index 1dfe5800c98c..704e572324f2 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -986,7 +986,7 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 	return 0;
 }
 
-static void __nested_svm_vmexit(struct vcpu_svm *svm)
+static void __nested_svm_vmexit(struct vcpu_svm *svm, struct vmcb *vmcb12)
 {
 	struct vmcb *vmcb01 = svm->vmcb01.ptr;
 	struct kvm_vcpu *vcpu = &svm->vcpu;
@@ -1000,6 +1000,10 @@ static void __nested_svm_vmexit(struct vcpu_svm *svm)
 	svm_set_gif(svm, false);
 	vmcb01->control.exit_int_info = 0;
 
+	/* event_inj is cleared on #VMEXIT */
+	vmcb12->control.event_inj = 0;
+	vmcb12->control.event_inj_err = 0;
+
 	nested_svm_uninit_mmu_context(vcpu);
 	if (nested_svm_load_cr3(vcpu, vmcb01->save.cr3, false, true)) {
 		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
@@ -1026,7 +1030,7 @@ static void nested_svm_failed_vmrun(struct vcpu_svm *svm, struct vmcb *vmcb12)
 	vmcb12->control.exit_code_hi = -1u;
 	vmcb12->control.exit_info_1 = 0;
 	vmcb12->control.exit_info_2 = 0;
-	__nested_svm_vmexit(svm);
+	__nested_svm_vmexit(svm, vmcb12);
 }
 
 int nested_svm_vmrun(struct kvm_vcpu *vcpu)
@@ -1209,8 +1213,6 @@ void nested_svm_vmexit(struct vcpu_svm *svm)
 		vmcb12->control.next_rip  = vmcb02->control.next_rip;
 
 	vmcb12->control.int_ctl           = svm->nested.ctl.int_ctl;
-	vmcb12->control.event_inj         = svm->nested.ctl.event_inj;
-	vmcb12->control.event_inj_err     = svm->nested.ctl.event_inj_err;
 
 	if (!kvm_pause_in_guest(vcpu->kvm)) {
 		vmcb01->control.pause_filter_count = vmcb02->control.pause_filter_count;
@@ -1315,8 +1317,6 @@ void nested_svm_vmexit(struct vcpu_svm *svm)
 				       vmcb12->control.exit_int_info_err,
 				       KVM_ISA_SVM);
 
-	kvm_vcpu_unmap(vcpu, &map);
-
 	nested_svm_transition_tlb_flush(vcpu);
 
 	/*
@@ -1338,7 +1338,9 @@ void nested_svm_vmexit(struct vcpu_svm *svm)
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
2.52.0.457.g6b5491de43-goog


