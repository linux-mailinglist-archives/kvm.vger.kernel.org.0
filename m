Return-Path: <kvm+bounces-71692-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iMlkDSQpnmn5TgQAu9opvQ
	(envelope-from <kvm+bounces-71692-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:41:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 82E7118D8EA
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:41:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4FA9430A3CD7
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 22:35:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2503036D4E0;
	Tue, 24 Feb 2026 22:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pjWsy2Cx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A14364EBA;
	Tue, 24 Feb 2026 22:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771972468; cv=none; b=om0ZB90YsJEinpMUBdsMf/a6Dx0osfA1BUsdlZ11r2OiH/0T9bUwGaRahQv/BqcxXuZV+LCedEtgzmUU87hMdK8PWXBrRO5AerUntHQYlGB8MuqjryMLrwNwZetXlLuEDgLjNTPjJjQfM1Z5FGuvssmsrzWvjZK1c7XImSy5/2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771972468; c=relaxed/simple;
	bh=/00Jh19cVwrJ78qvAoBT86Jj00pLMsKnQxm14ypB3gQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6bAVeU/B/ZoDqJjIt1rL8m1Y0MC8LUYcKP3N8XAw+9VCYtnI9H8H1byWpMXZGGQaLSbnt8sSYClznRxLBlHeLdPJwpRhSCGHDx/5K6LANmVvLymKPX8EFjHv/7hEGzL413jUuIH9esaAAnvNUL9tvrvgzxcTUnonkl3hNAL0fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pjWsy2Cx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A94C19423;
	Tue, 24 Feb 2026 22:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771972467;
	bh=/00Jh19cVwrJ78qvAoBT86Jj00pLMsKnQxm14ypB3gQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pjWsy2Cx0pC+N6bmpiokhtQfYlfnjXS02u1bITWqgN8swGgNg3XRW28c2UTwGmdeU
	 AFp2cfq+fcYWZIVeSeJyC2SqMzM1qVxq5YxAAuNvDmcq7pghJontty53cx2jsJkUpI
	 xrdHfWKO3r5C73zQ4Zk0M30ImMIf+SkbWJhJQjNyY/tyc+6Q5WYLJzuhgOZn2ALXWE
	 FU6J4GQgAOvnBC3IeMSPIKF/KMMHnCsgDJsu0YAyCulLAYlYeUnTnu50DzxKP4+caK
	 D7Qx75uL2hmfJkL3qKxj4g9yLMxOXOp9c2x1DEsdhqhvYSTHmSQG9K+ZtwAsYwEJkO
	 sjsW+TWXac0tw==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v6 16/31] KVM: nSVM: Unify handling of VMRUN failures with proper cleanup
Date: Tue, 24 Feb 2026 22:33:50 +0000
Message-ID: <20260224223405.3270433-17-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
In-Reply-To: <20260224223405.3270433-1-yosry@kernel.org>
References: <20260224223405.3270433-1-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71692-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 82E7118D8EA
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
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 66 +++++++++++++++++++++++++--------------
 1 file changed, 42 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index a6e8c0d26c64e..2c5878cbb3940 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -939,22 +939,19 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
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
@@ -966,6 +963,17 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
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
 
@@ -984,6 +992,8 @@ static void __nested_svm_vmexit(struct vcpu_svm *svm)
 	struct vmcb *vmcb01 = svm->vmcb01.ptr;
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
+	WARN_ON_ONCE(is_guest_mode(vcpu));
+
 	svm->nested.vmcb12_gpa = 0;
 	svm->nested.ctl.nested_cr3 = 0;
 
@@ -1006,6 +1016,20 @@ static void __nested_svm_vmexit(struct vcpu_svm *svm)
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
@@ -1048,14 +1072,6 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
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
@@ -1076,14 +1092,9 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
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
@@ -1241,6 +1252,13 @@ void nested_svm_vmexit(struct vcpu_svm *svm)
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
@@ -1912,9 +1930,6 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	if (nested_npt_enabled(svm))
 		nested_svm_init_mmu_context(vcpu);
 
-	svm_switch_vmcb(svm, &svm->nested.vmcb02);
-	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip, svm->vmcb->save.cs.base);
-
 	/*
 	 * While the nested guest CR3 is already checked and set by
 	 * KVM_SET_SREGS, it was set when nested state was yet loaded,
@@ -1926,6 +1941,9 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	if (ret)
 		goto out_free;
 
+	svm_switch_vmcb(svm, &svm->nested.vmcb02);
+	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip, svm->vmcb->save.cs.base);
+
 	svm->nested.force_msr_bitmap_recalc = true;
 
 	kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
-- 
2.53.0.414.gf7e9f6c205-goog


