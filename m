Return-Path: <kvm+bounces-66019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D5A94CBFA2C
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 21:01:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2E9CE302AF9B
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 20:00:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0689C33B6F2;
	Mon, 15 Dec 2025 19:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WI5PGAOf"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54ED334C2D
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 19:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765826949; cv=none; b=PDJPeX//FKi97ZbEQFjHnp/6182cdQbI02O5vDHbYbAyiXmzZG8KOLjcqXD8OBj7RFkiD+T8NJhWjNk+B9GDLhgCuVaM6+wXjwa/UR7s5XvJu1gpmHoEYrYPGsqTQxOn6ng2fURAjwr85fDgk4pZAId0RRSMqSs3dKMxwT6TmbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765826949; c=relaxed/simple;
	bh=7/838073DVFTFLtPCJ619xws4L5yor+1mgK55Yo/PsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NyFv8+WFrScws2qTtrRdGxHZjtJf4QBGm5NZ1jaNq6D9l0Ndbh5T1YS3HvAAEL/rbEnPr910GVk2kONZkSg+5RKmwaUbMAZCL6bF6JtfyEW2dkSY2KC+e5nhp9LpgSZzje5PDr4kaKVWG+kGIVLdbP+Af/gugeAfceCrQ9EoRAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WI5PGAOf; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765826940;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WESJeyan/qwV1p/PmsZSB8JlH+LDO7XLkMIW+PzprV8=;
	b=WI5PGAOfQNpORoz+5kiO6vngniRRmRwBoc/GBAH/RP4LaFNl5L9JvFjN5MIBMe4VwyMVFk
	fvU050Z3VjUsjPHFqT/POlhaC9bBYQet8viITlBnTMBntk/IQhyK3m0QSHjvXuLBPRpKMq
	NkiOT1OlsO7V/U+ub78C91dlG1bkNww=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v3 13/26] KVM: nSVM: Unify handling of VMRUN failures with proper cleanup
Date: Mon, 15 Dec 2025 19:27:08 +0000
Message-ID: <20251215192722.3654335-15-yosry.ahmed@linux.dev>
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

There are currently two possible causes of VMRUN failures:

1) Consistency checks failures. In this case, KVM updates the exit code
   in the mapped VMCB12 and exits early in nested_svm_vmrun(). This
   causes a few problems:

  A) KVM does not clear the GIF if the early consistency checks fail
     (because nested_svm_vmexit() is not called). Nothing requires
     GIF=0 before a VMRUN, from the APM:

	It is assumed that VMM software cleared GIF some time before
	executing the VMRUN instruction, to ensure an atomic state
	switch.

     So an early #VMEXIT from early consistency checks could leave the
     GIF set.

  B) svm_leave_smm() is missing consistency checks on the newly loaded
     guest state, because the checks aren't performed by
     enter_svm_guest_mode().

2) Faiure to load L2's CR3 or merge the MSR bitmaps. In this case, a
   fully-fledged #VMEXIT injection is performed as VMCB02 is already
   prepared.

Arguably all VMRUN failures should be handled before the VMCB02 is
prepared, but with proper cleanup (e.g. clear the GIF). Move all the
potential failure checks inside enter_svm_guest_mode() before switching
to VMCB02. On failure of any of these checks, nested_svm_vmrun()
synthesizes a minimal #VMEXIT through the new nested_svm_failed_vmrun()
helper.

__nested_svm_vmexit() already performs the necessary cleanup for a
failed VMRUN, including uninitializing the nested MMU and reloading L1's
CR3. This ensures that consistency check failures do proper necessary
cleanup, while other failures do not doo too much cleanup. It also
leaves a unified path for handling VMRUN failures.

Cc: stable@vger.kernel.org
Fixes: 52c65a30a5c6 ("KVM: SVM: Check for nested vmrun intercept before emulating vmrun")
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 58 +++++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 1356bd6383ca..632e941febaf 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -889,22 +889,19 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 				    vmcb12->control.intercepts[INTERCEPT_WORD4],
 				    vmcb12->control.intercepts[INTERCEPT_WORD5]);
 
-
 	svm->nested.vmcb12_gpa = vmcb12_gpa;
 
 	WARN_ON(svm->vmcb == svm->nested.vmcb02.ptr);
 
 	enter_guest_mode(vcpu);
 
+	if (!nested_vmcb_check_save(vcpu, &svm->nested.save) ||
+	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl))
+		return -EINVAL;
+
 	if (nested_npt_enabled(svm))
 		nested_svm_init_mmu_context(vcpu);
 
-	nested_svm_copy_common_state(svm->vmcb01.ptr, svm->nested.vmcb02.ptr);
-
-	svm_switch_vmcb(svm, &svm->nested.vmcb02);
-	nested_vmcb02_prepare_control(svm, vmcb12->save.rip, vmcb12->save.cs.base);
-	nested_vmcb02_prepare_save(svm, vmcb12);
-
 	ret = nested_svm_load_cr3(&svm->vcpu, svm->nested.save.cr3,
 				  nested_npt_enabled(svm), from_vmrun);
 	if (ret)
@@ -916,6 +913,17 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 			return ret;
 	}
 
+	/*
+	 * Any VMRUN failure needs to happen before this point, such that the
+	 * nested #VMEXIT is injected properly by nested_svm_failed_vmrun().
+	 */
+
+	nested_svm_copy_common_state(svm->vmcb01.ptr, svm->nested.vmcb02.ptr);
+
+	svm_switch_vmcb(svm, &svm->nested.vmcb02);
+	nested_vmcb02_prepare_control(svm, vmcb12->save.rip, vmcb12->save.cs.base);
+	nested_vmcb02_prepare_save(svm, vmcb12);
+
 	if (!from_vmrun)
 		kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 
@@ -957,6 +965,17 @@ static void __nested_svm_vmexit(struct vcpu_svm *svm)
 		kvm_queue_exception(vcpu, DB_VECTOR);
 }
 
+static void nested_svm_failed_vmrun(struct vcpu_svm *svm, struct vmcb *vmcb12)
+{
+	WARN_ON(svm->vmcb == svm->nested.vmcb02.ptr);
+
+	vmcb12->control.exit_code = SVM_EXIT_ERR;
+	vmcb12->control.exit_code_hi = -1u;
+	vmcb12->control.exit_info_1 = 0;
+	vmcb12->control.exit_info_2 = 0;
+	__nested_svm_vmexit(svm);
+}
+
 int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -999,15 +1018,6 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
 	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
 
-	if (!nested_vmcb_check_save(vcpu, &svm->nested.save) ||
-	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {
-		vmcb12->control.exit_code    = SVM_EXIT_ERR;
-		vmcb12->control.exit_code_hi = -1u;
-		vmcb12->control.exit_info_1  = 0;
-		vmcb12->control.exit_info_2  = 0;
-		goto out;
-	}
-
 	/*
 	 * Since vmcb01 is not in use, we can use it to store some of the L1
 	 * state.
@@ -1028,15 +1038,9 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 		svm->nmi_l1_to_l2 = false;
 		svm->soft_int_injected = false;
 
-		svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
-		svm->vmcb->control.exit_code_hi = -1u;
-		svm->vmcb->control.exit_info_1  = 0;
-		svm->vmcb->control.exit_info_2  = 0;
-
-		nested_svm_vmexit(svm);
+		nested_svm_failed_vmrun(svm, vmcb12);
 	}
 
-out:
 	kvm_vcpu_unmap(vcpu, &map);
 
 	return ret;
@@ -1172,6 +1176,8 @@ void nested_svm_vmexit(struct vcpu_svm *svm)
 
 	kvm_nested_vmexit_handle_ibrs(vcpu);
 
+	/* VMRUN failures before switching to VMCB02 are handled by nested_svm_failed_vmrun() */
+	WARN_ON_ONCE(svm->vmcb != svm->nested.vmcb02.ptr);
 	svm_switch_vmcb(svm, &svm->vmcb01);
 
 	/*
@@ -1859,9 +1865,6 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	if (nested_npt_enabled(svm))
 		nested_svm_init_mmu_context(vcpu);
 
-	svm_switch_vmcb(svm, &svm->nested.vmcb02);
-	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip, svm->vmcb->save.cs.base);
-
 	/*
 	 * While the nested guest CR3 is already checked and set by
 	 * KVM_SET_SREGS, it was set when nested state was yet loaded,
@@ -1874,6 +1877,9 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	if (WARN_ON_ONCE(ret))
 		goto out_free;
 
+	svm_switch_vmcb(svm, &svm->nested.vmcb02);
+	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip, svm->vmcb->save.cs.base);
+
 	svm->nested.force_msr_bitmap_recalc = true;
 
 	kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
-- 
2.52.0.239.gd5f0c6e74e-goog


