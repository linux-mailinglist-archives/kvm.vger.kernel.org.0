Return-Path: <kvm+bounces-37385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E393FA298F2
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 19:26:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9AB5D7A237C
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 18:25:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25BFA214A6A;
	Wed,  5 Feb 2025 18:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bSgJm9po"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F143214807
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 18:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738779883; cv=none; b=pSVJMA5sSGvD1fXL6x7hM1lMGbCYYdOfCUMrF4E1jweHXQxB1qjdvP/7vqCSOClRFqRDK19U1ufh5mfp3/r4uHpzy1KSjUWaDsFnD2ZO9+F0VeXexhzFxBTIw1hzHeJlotPC49gRLnUR5XsT7LaXyaw5QWhFDo6mx09DzKvQT2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738779883; c=relaxed/simple;
	bh=3TYqX4BFP2U6TMLgJgMdg5nWWzFi+RBdInLSw9YpA9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZWYbJPIA0zfkx46jwyAP5YTG8ISqeOlBpIA+WeDf1fU8VcmcSUcoBputqE4cxJa25kNBOKWLQjwnge+Xvn6RsB/DhElwSc5glhPOdFvctCeBLAOM2YB/XoFiJga/w4355OfYSxs3C8KfphODvPgQWrW8BMGVEO1IKnB/8fQMUow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bSgJm9po; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738779876;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k/M4ph76ynZ139V+HDMXT5ZDD/lLnaQbCHrkiu67TFc=;
	b=bSgJm9poGibDaSCn0OBneCA2AEMaZVtnqWrQoFq4Z+g7BAysGff0CIi5ysd4f0KXXd4fGi
	ciwhn8mtaJBAQi9yZoIlL48FnYfyb9ZhbZ9cWMRHoOKd442IXeAjvpms9fko27W9eswvky
	nr4qZ7QrMu3uYow7JwIBkuKVmTTEPps=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 09/13] KVM: nSVM: Handle nested TLB flush requests through TLB_CONTROL
Date: Wed,  5 Feb 2025 18:23:58 +0000
Message-ID: <20250205182402.2147495-10-yosry.ahmed@linux.dev>
In-Reply-To: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Handle L1's requests to flush L2's TLB through the TLB_CONTROL field of
VMCB12. This is currently redundant because a full flush is executed on
every nested transition, but is a step towards removing that.

TLB_CONTROL_FLUSH_ALL_ASID flushes all ASIDs from L1's perspective,
including its own, so do a guest TLB flush on both transitions. Never
propagate TLB_CONTROL_FLUSH_ALL_ASID from the guest to the actual VMCB,
as this gives the guest the power to flush the entire physical TLB
(including translations for the host and other VMs).

For other cases, the TLB flush is only done when entering L2. The nested
NPT MMU is also sync'd because TLB_CONTROL also flushes NPT
guest-physical mappings.

All TLB_CONTROL values can be handled by KVM regardless of FLUSHBYASID
support on the underlying CPU, so keep advertising FLUSHBYASID to the
guest unconditionally.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 42 ++++++++++++++++++++++++++++++++-------
 arch/x86/kvm/svm/svm.c    |  6 +++---
 2 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 0735177b95a1d..e2c59eb2907e8 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -484,19 +484,36 @@ static void nested_save_pending_event_to_vmcb12(struct vcpu_svm *svm,
 
 static void nested_svm_entry_tlb_flush(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
+
 	/* Handle pending Hyper-V TLB flush requests */
 	kvm_hv_nested_transtion_tlb_flush(vcpu, npt_enabled);
 
+	/*
+	 * If L1 requested a TLB flush for L2, flush L2's TLB on nested entry
+	 * and sync the nested NPT MMU, as TLB_CONTROL also flushes NPT
+	 * guest-physical mappings. We technically only need to flush guest_mode
+	 * page tables.
+	 *
+	 * KVM_REQ_TLB_FLUSH_GUEST will flush L2's ASID even if the underlying
+	 * CPU does not support FLUSHBYASID (by assigning a new ASID), so we
+	 * can handle all TLB_CONTROL values from L1 regardless.
+	 *
+	 * Note that TLB_CONTROL_FLUSH_ASID_LOCAL is handled exactly like
+	 * TLB_CONTROL_FLUSH_ASID. We can technically flush less TLB entries,
+	 * but this would require significantly more complexity.
+	 */
+	if (svm->nested.ctl.tlb_ctl != TLB_CONTROL_DO_NOTHING) {
+		if (nested_npt_enabled(svm))
+			kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
+		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
+	}
+
 	/*
 	 * TODO: optimize unconditional TLB flush/MMU sync.  A partial list of
 	 * things to fix before this can be conditional:
 	 *
-	 *  - Honor L1's request to flush an ASID on nested VMRUN
-	 *  - Sync nested NPT MMU on VMRUN that flushes L2's ASID[*]
 	 *  - Don't crush a pending TLB flush in vmcb02 on nested VMRUN
-	 *
-	 * [*] Unlike nested EPT, SVM's ASID management can invalidate nested
-	 *     NPT guest-physical mappings on VMRUN.
 	 */
 	kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
 	kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
@@ -504,9 +521,18 @@ static void nested_svm_entry_tlb_flush(struct kvm_vcpu *vcpu)
 
 static void nested_svm_exit_tlb_flush(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
+
 	/* Handle pending Hyper-V TLB flush requests */
 	kvm_hv_nested_transtion_tlb_flush(vcpu, npt_enabled);
 
+	/*
+	 * If L1 had requested a full TLB flush when entering L2, also flush its
+	 * TLB entries when exiting back to L1.
+	 */
+	if (svm->nested.ctl.tlb_ctl == TLB_CONTROL_FLUSH_ALL_ASID)
+		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
+
 	/* See nested_svm_entry_tlb_flush() */
 	kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
 	kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
@@ -825,7 +851,8 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 	nested_svm_copy_common_state(svm->vmcb01.ptr, svm->nested.vmcb02.ptr);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
-	nested_vmcb02_prepare_control(svm, vmcb12->save.rip, vmcb12->save.cs.base);
+	nested_vmcb02_prepare_control(svm, vmcb12->save.rip,
+				      vmcb12->save.cs.base);
 	nested_vmcb02_prepare_save(svm, vmcb12);
 
 	ret = nested_svm_load_cr3(&svm->vcpu, svm->nested.save.cr3,
@@ -1764,7 +1791,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	nested_copy_vmcb_control_to_cache(svm, ctl);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
-	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip, svm->vmcb->save.cs.base);
+	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip,
+				      svm->vmcb->save.cs.base);
 
 	/*
 	 * While the nested guest CR3 is already checked and set by
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8342c7eadbba8..5e7b1c9bfa605 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5242,9 +5242,9 @@ static __init void svm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_VMCBCLEAN);
 
 		/*
-		 * KVM currently flushes TLBs on *every* nested SVM transition,
-		 * and so for all intents and purposes KVM supports flushing by
-		 * ASID, i.e. KVM is guaranteed to honor every L1 ASID flush.
+		 * KVM currently handles all TLB_CONTROL values set by L1, even
+		 * if the underlying CPU does not. See
+		 * nested_svm_transition_tlb_flush().
 		 */
 		kvm_cpu_cap_set(X86_FEATURE_FLUSHBYASID);
 
-- 
2.48.1.362.g079036d154-goog


