Return-Path: <kvm+bounces-68125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DD03AD21F96
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 02:17:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 458F030907D4
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 01:14:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B354329ACF7;
	Thu, 15 Jan 2026 01:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kH2a+5Wk"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFF923D297
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 01:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768439640; cv=none; b=uCuuHaQf5R4kRSrnxgTlaWle0XSHr9HaAQyAok/JJNs6eoketqnzWK+Ygy2ERULyVysjPi46468Q3176Yd2Z+iw9MeaHld+msYeLP5QoZF+m6d/0LT5aPtldkD4DrwWtoThpWPtOjh5FX4J8bVaQ7tjBKjfOJYrYf3kxdawvqXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768439640; c=relaxed/simple;
	bh=UkTB7/LqH/pyyGJdD2ZNakL2HnEOMm7V0uLGwDf8qjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZdeaBK/TZzeEjmfMOKuIwjaaH6IFm9AlH3ckEeHF7o846052eYSVJn971k//DeRfX74AZoe7z6lSR9UN0znUc28mN7OuSp4GDVhIR7JTHXotrV+ZC+qdoXylaLPlgOHRKLkWSCugDa2ste8XCfP6JRqnjuVOLoB0A0H96h5g3kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kH2a+5Wk; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768439628;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jBZGK/DUsBaWT2N5OHFROUf2AuDR00qURUYy9nlXgrA=;
	b=kH2a+5Wk8lavW9jlY1bV8X39gV1Bw6Zy26gDvN0pga1sT1YNQZHX0liQVaA4yPlkP0aQPp
	7VEAvYhiCIeVVRsgxSQifUlbyghRrSmntoXqs5OJ53ry/GRjsP9LnEKlN9oeM4zIVmcI01
	/9P7EHAJSVmdKWx6lzH+1EhAaB+rp+E=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v4 12/26] KVM: nSVM: Refactor minimal #VMEXIT handling out of nested_svm_vmexit()
Date: Thu, 15 Jan 2026 01:12:58 +0000
Message-ID: <20260115011312.3675857-13-yosry.ahmed@linux.dev>
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

In preparation for having a separate minimal #VMEXIT path for handling
failed VMRUNs, move the minimal logic out of nested_svm_vmexit() into a
helper.

This includes clearing the GIF, handling single-stepping on VMRUN, and a
few data structure cleanups.  Basically, everything that is required by
the architecture (or KVM) on a #VMEXIT where L2 never actually ran.

Additionally move uninitializing the nested MMU and reloading host CR3
to the new helper. It is not required at this point, but following
changes will require it.

No functional change intended.

Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 61 ++++++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index f108f6fae5bc..53ae761b50e2 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -978,6 +978,34 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 	return 0;
 }
 
+static void __nested_svm_vmexit(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb01 = svm->vmcb01.ptr;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+
+	svm->nested.vmcb12_gpa = 0;
+	svm->nested.ctl.nested_cr3 = 0;
+
+	/* GIF is cleared on #VMEXIT, no event can be injected in L1 */
+	svm_set_gif(svm, false);
+	vmcb01->control.exit_int_info = 0;
+
+	nested_svm_uninit_mmu_context(vcpu);
+	if (nested_svm_load_cr3(vcpu, vmcb01->save.cr3, false, true)) {
+		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+		return;
+	}
+
+	/*
+	 * If we are here following the completion of a VMRUN that
+	 * is being single-stepped, queue the pending #DB intercept
+	 * right now so that it an be accounted for before we execute
+	 * L1's next instruction.
+	 */
+	if (unlikely(vmcb01->save.rflags & X86_EFLAGS_TF))
+		kvm_queue_exception(vcpu, DB_VECTOR);
+}
+
 int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -1127,8 +1155,6 @@ void nested_svm_vmexit(struct vcpu_svm *svm)
 	/* in case we halted in L2 */
 	kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
 
-	svm->nested.vmcb12_gpa = 0;
-
 	if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map)) {
 		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 		return;
@@ -1246,13 +1272,6 @@ void nested_svm_vmexit(struct vcpu_svm *svm)
 		}
 	}
 
-	/*
-	 * On vmexit the  GIF is set to false and
-	 * no event can be injected in L1.
-	 */
-	svm_set_gif(svm, false);
-	vmcb01->control.exit_int_info = 0;
-
 	svm->vcpu.arch.tsc_offset = svm->vcpu.arch.l1_tsc_offset;
 	if (vmcb01->control.tsc_offset != svm->vcpu.arch.tsc_offset) {
 		vmcb01->control.tsc_offset = svm->vcpu.arch.tsc_offset;
@@ -1265,8 +1284,6 @@ void nested_svm_vmexit(struct vcpu_svm *svm)
 		svm_write_tsc_multiplier(vcpu);
 	}
 
-	svm->nested.ctl.nested_cr3 = 0;
-
 	/*
 	 * Restore processor state that had been saved in vmcb01
 	 */
@@ -1292,13 +1309,6 @@ void nested_svm_vmexit(struct vcpu_svm *svm)
 
 	nested_svm_transition_tlb_flush(vcpu);
 
-	nested_svm_uninit_mmu_context(vcpu);
-
-	if (nested_svm_load_cr3(vcpu, vmcb01->save.cr3, false, true)) {
-		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
-		return;
-	}
-
 	/*
 	 * Drop what we picked up for L2 via svm_complete_interrupts() so it
 	 * doesn't end up in L1.
@@ -1307,21 +1317,18 @@ void nested_svm_vmexit(struct vcpu_svm *svm)
 	kvm_clear_exception_queue(vcpu);
 	kvm_clear_interrupt_queue(vcpu);
 
-	/*
-	 * If we are here following the completion of a VMRUN that
-	 * is being single-stepped, queue the pending #DB intercept
-	 * right now so that it an be accounted for before we execute
-	 * L1's next instruction.
-	 */
-	if (unlikely(vmcb01->save.rflags & X86_EFLAGS_TF))
-		kvm_queue_exception(&(svm->vcpu), DB_VECTOR);
-
 	/*
 	 * Un-inhibit the AVIC right away, so that other vCPUs can start
 	 * to benefit from it right away.
 	 */
 	if (kvm_apicv_activated(vcpu->kvm))
 		__kvm_vcpu_update_apicv(vcpu);
+
+	/*
+	 * Potentially queues an exception, so it needs to be after
+	 * kvm_clear_exception_queue() is called above.
+	 */
+	__nested_svm_vmexit(svm);
 }
 
 static void nested_svm_triple_fault(struct kvm_vcpu *vcpu)
-- 
2.52.0.457.g6b5491de43-goog


