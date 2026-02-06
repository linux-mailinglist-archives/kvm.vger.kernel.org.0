Return-Path: <kvm+bounces-70492-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aBOfDbI9hmnzLAQAu9opvQ
	(envelope-from <kvm+bounces-70492-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 20:14:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id EA1A41028AB
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 20:14:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 38FFB30558E3
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 19:10:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9887343D51C;
	Fri,  6 Feb 2026 19:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gYWX9Ki9"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58E143D503
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 19:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770404973; cv=none; b=pDgH/PvpIduleGA53OBtCGN4LX8zukjm5tkm0ZZjypeyQfojIGFPesy8z9GY9SeOwAJPb5LAfrDOw7N7yUOjrQ+gMjbTrc87B0Ht8NktKY1BpAgUg3CfHh9oWhh1nUsf5e9L/KzpvB4QYO2zzoWIvRSPcsf2jpNB/sc1FhCfnjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770404973; c=relaxed/simple;
	bh=qfymSp5sdM5UdXIapZ0krZEloaywrLeuhrSrgLX05Tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o8VGvsYbjpujrMoGEB3ATLCTuJFQx7hjOMpcLKdS+W55t1Ri+uaFnGhbxfHlrZn0RBY+SW/RYs4QPCw96VgsU7b7SsePs+WppvZh1zvykmGRDZEmvHr6U6XYMFMdcfzIvmaogSMuILT6MVO0LyNA2/m1QvcK7WRr0uNhOeaR9oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gYWX9Ki9; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770404972;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A61MjfomSxxuJgw3g4fkU+eGDEdvm0za4xW5Q7zFG64=;
	b=gYWX9Ki9iMCvKkkGqBgqTl36povFos+FqtRT0t177HxzSTDBDYwVlf8d5B4G47YzcIp4Xk
	+Zf2hlCKwG0dmYlKGCeBltS8E/69J+9RzP5jjIMS0eRLcFDwcaHwD9kLO+ZJ3wOlD7+gsP
	ccXg19xy0+Ba8Vo3pEXd/h46QVpTlD8=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v5 14/26] KVM: nSVM: Unify handling of VMRUN failures with proper cleanup
Date: Fri,  6 Feb 2026 19:08:39 +0000
Message-ID: <20260206190851.860662-15-yosry.ahmed@linux.dev>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70492-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	NEURAL_HAM(-0.00)[-0.996];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: EA1A41028AB
X-Rspamd-Action: no action

There are currently two possible causes of VMRUN failures emulated by
KVM:

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

2) Failure to load L2's CR3 or merge the MSR bitmaps. In this case, a
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
 arch/x86/kvm/svm/nested.c | 66 +++++++++++++++++++++++++--------------
 1 file changed, 42 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index a852508d7419..918f6a6eaf56 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -934,22 +934,19 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
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
@@ -961,6 +958,17 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 			return ret;
 	}
 
+	/*
+	 * Any VMRUN failure needs to happen before this point, such that the
+	 * nested #VMEXIT is injected properly by nested_svm_vmrun_error_vmexit().
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
 
@@ -979,6 +987,8 @@ static void __nested_svm_vmexit(struct vcpu_svm *svm)
 	struct vmcb *vmcb01 = svm->vmcb01.ptr;
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
+	WARN_ON_ONCE(is_guest_mode(vcpu));
+
 	svm->nested.vmcb12_gpa = 0;
 	svm->nested.ctl.nested_cr3 = 0;
 
@@ -1002,6 +1012,20 @@ static void __nested_svm_vmexit(struct vcpu_svm *svm)
 		kvm_queue_exception(vcpu, DB_VECTOR);
 }
 
+static void nested_svm_vmrun_error_vmexit(struct kvm_vcpu *vcpu, struct vmcb *vmcb12)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	WARN_ON_ONCE(svm->vmcb == svm->nested.vmcb02.ptr);
+
+	leave_guest_mode(vcpu);
+
+	vmcb12->control.exit_code = SVM_EXIT_ERR;
+	vmcb12->control.exit_info_1 = 0;
+	vmcb12->control.exit_info_2 = 0;
+	__nested_svm_vmexit(svm);
+}
+
 int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -1044,14 +1068,6 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
 	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
 
-	if (!nested_vmcb_check_save(vcpu, &svm->nested.save) ||
-	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {
-		vmcb12->control.exit_code    = SVM_EXIT_ERR;
-		vmcb12->control.exit_info_1  = 0;
-		vmcb12->control.exit_info_2  = 0;
-		goto out;
-	}
-
 	/*
 	 * Since vmcb01 is not in use, we can use it to store some of the L1
 	 * state.
@@ -1072,14 +1088,9 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 		svm->nmi_l1_to_l2 = false;
 		svm->soft_int_injected = false;
 
-		svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
-		svm->vmcb->control.exit_info_1  = 0;
-		svm->vmcb->control.exit_info_2  = 0;
-
-		nested_svm_vmexit(svm);
+		nested_svm_vmrun_error_vmexit(vcpu, vmcb12);
 	}
 
-out:
 	kvm_vcpu_unmap(vcpu, &map);
 
 	return ret;
@@ -1217,6 +1228,13 @@ void nested_svm_vmexit(struct vcpu_svm *svm)
 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_ERAPS))
 		vmcb01->control.erap_ctl |= ERAP_CONTROL_CLEAR_RAP;
 
+	/*
+	 * nested_svm_vmexit() is intended for use only when KVM is synthesizing
+	 * a #VMEXIT after a successful nested VMRUN.  All VMRUN consistency
+	 * checks must be performed before loading guest state, and so should
+	 * use __nested_svm_vmexit().
+	 */
+	WARN_ON_ONCE(svm->vmcb != svm->nested.vmcb02.ptr);
 	svm_switch_vmcb(svm, &svm->vmcb01);
 
 	/*
@@ -1903,9 +1921,6 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	if (nested_npt_enabled(svm))
 		nested_svm_init_mmu_context(vcpu);
 
-	svm_switch_vmcb(svm, &svm->nested.vmcb02);
-	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip, svm->vmcb->save.cs.base);
-
 	/*
 	 * While the nested guest CR3 is already checked and set by
 	 * KVM_SET_SREGS, it was set when nested state was yet loaded,
@@ -1917,6 +1932,9 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	if (ret)
 		goto out_free;
 
+	svm_switch_vmcb(svm, &svm->nested.vmcb02);
+	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip, svm->vmcb->save.cs.base);
+
 	svm->nested.force_msr_bitmap_recalc = true;
 
 	kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
-- 
2.53.0.rc2.204.g2597b5adb4-goog


