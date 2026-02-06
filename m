Return-Path: <kvm+bounces-70491-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UOtLI5k9hmnzLAQAu9opvQ
	(envelope-from <kvm+bounces-70491-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 20:14:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 09BA0102880
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 20:14:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 379C130993BC
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 19:10:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2A9843D4FD;
	Fri,  6 Feb 2026 19:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KCyDsvnf"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B7942E00D
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 19:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770404972; cv=none; b=gAauzcE+f7zbQj6pc1LpcVffjLNs1dz52jOUxZJQ1Q4x1lBgNV3E5bhKlPoz8DFqXUzwSi8NeTxem1YvVs+Cj7LnEUYMFByPlVct9Xfy9tjs5AK9GhjepC0G2qE1IweLw5q0DMd9ZhTFUT9Kbk9diZdy1YT1n5ouKFw/t4DcrM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770404972; c=relaxed/simple;
	bh=iHRA+CY3G4sfkkjtab8WHpN/rU+K6k4ITce+YB/0thQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJj6zdxtQZbnCE59Hx4Y+rZ0A0NH3/ftVarhdCqnSoaHIWzGowInFMK6wiygSwS9+R68aQZwNaUMcEYPHz3vnElkIsvm/QciJp9XVTdsNw/DQfKh+eu4dXGH/KcSw5ll+DzQGLc5Ud6QhqN9N46VO8tJAhBVRaWSisC1OW/t9BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KCyDsvnf; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770404970;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5F/2K7Th5J9MsJE8ZyTAj5AnPleeJatK++yTTaOysm8=;
	b=KCyDsvnf7kkaocwaUwznotSB7h8GUdWWH6alrYHAyKPUtrSOick1p/HSufsG74mLaXHtB2
	MsWD7FojC3Q0LevHDiCZD7AmOD7J4ngUJlVglabQx2tRb49F7CQ8EPRG5c7stuTTYqs/QH
	0db80kGF7lvM6Rqvsu02nVL3XG8ptlU=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v5 13/26] KVM: nSVM: Refactor minimal #VMEXIT handling out of nested_svm_vmexit()
Date: Fri,  6 Feb 2026 19:08:38 +0000
Message-ID: <20260206190851.860662-14-yosry.ahmed@linux.dev>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70491-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.997];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 09BA0102880
X-Rspamd-Action: no action

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
index 77cb98e39fb3..a852508d7419 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -974,6 +974,34 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
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
@@ -1121,8 +1149,6 @@ void nested_svm_vmexit(struct vcpu_svm *svm)
 	/* in case we halted in L2 */
 	kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
 
-	svm->nested.vmcb12_gpa = 0;
-
 	if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map)) {
 		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 		return;
@@ -1239,13 +1265,6 @@ void nested_svm_vmexit(struct vcpu_svm *svm)
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
@@ -1258,8 +1277,6 @@ void nested_svm_vmexit(struct vcpu_svm *svm)
 		svm_write_tsc_multiplier(vcpu);
 	}
 
-	svm->nested.ctl.nested_cr3 = 0;
-
 	/*
 	 * Restore processor state that had been saved in vmcb01
 	 */
@@ -1285,13 +1302,6 @@ void nested_svm_vmexit(struct vcpu_svm *svm)
 
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
@@ -1300,21 +1310,18 @@ void nested_svm_vmexit(struct vcpu_svm *svm)
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
2.53.0.rc2.204.g2597b5adb4-goog


