Return-Path: <kvm+bounces-70493-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SFpeLA0+hmnzLAQAu9opvQ
	(envelope-from <kvm+bounces-70493-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 20:16:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BF26102924
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 20:16:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3EC3B30C6A7E
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 19:10:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5319943DA43;
	Fri,  6 Feb 2026 19:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="L3/uBPc2"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F66343D503
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 19:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770404975; cv=none; b=N4TY0Q7qwxl79roSnutCIlswOupOnl7S5hmOeMZrpCZ1fdKFhApTWs/cr4arcphEBnY5+OsW/izgJBlFH+pqFObxtqL1zGFTbjR2Pwyztz1FV2cpEVgykmrz/m6p56/vM2bDeeoR41XvxwIl9fNqoqtjO9T6FmIhBbIbSBMdEzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770404975; c=relaxed/simple;
	bh=2GCFQgDIIXc/4F8yoRTg5mJZlXIwfwKXQX8YO7VOUEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s0aGc+zOGulIqGtk5HqwnrjbAoAEpVEc5jBzJSGnz9C56VVPcmVqZBtH4jB/DOmKDctWbfr+d5PHS6+H4G+TQz0YZYmSKtnjaPPX0QeDHuRJ7zZXGGQxO7NyCTC3JfVpKHPM4XiJwyWKYXkwmH0vAxFdTXZUpX0vo4dLD1FWUGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=L3/uBPc2; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770404973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iK+en+N3Sh3Cz5P9nnp8aY0rKVsI9XKonHalz8PlHgA=;
	b=L3/uBPc2nVHFs3EYCLKt03ZD5Dg1VB8G++tKvueTGgC/JbkdGYq2Knrr4SaflXTPJ082iM
	CLXGJnATsmGKIPJamXyvhTTKm4jFjP6Zu4RL/GgYdSFhgS6CYoi1cRLsYGRSkDj7EfHaE8
	7ahOPYlLBK1a0TxGpyj1FVZLGx09YWE=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v5 15/26] KVM: nSVM: Clear EVENTINJ field in VMCB12 on nested #VMEXIT
Date: Fri,  6 Feb 2026 19:08:40 +0000
Message-ID: <20260206190851.860662-16-yosry.ahmed@linux.dev>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70493-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 2BF26102924
X-Rspamd-Action: no action

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
index 918f6a6eaf56..2f43b70930a8 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -982,7 +982,7 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 	return 0;
 }
 
-static void __nested_svm_vmexit(struct vcpu_svm *svm)
+static void __nested_svm_vmexit(struct vcpu_svm *svm, struct vmcb *vmcb12)
 {
 	struct vmcb *vmcb01 = svm->vmcb01.ptr;
 	struct kvm_vcpu *vcpu = &svm->vcpu;
@@ -996,6 +996,10 @@ static void __nested_svm_vmexit(struct vcpu_svm *svm)
 	svm_set_gif(svm, false);
 	vmcb01->control.exit_int_info = 0;
 
+	/* event_inj is cleared on #VMEXIT */
+	vmcb12->control.event_inj = 0;
+	vmcb12->control.event_inj_err = 0;
+
 	nested_svm_uninit_mmu_context(vcpu);
 	if (nested_svm_load_cr3(vcpu, vmcb01->save.cr3, false, true)) {
 		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
@@ -1023,7 +1027,7 @@ static void nested_svm_vmrun_error_vmexit(struct kvm_vcpu *vcpu, struct vmcb *vm
 	vmcb12->control.exit_code = SVM_EXIT_ERR;
 	vmcb12->control.exit_info_1 = 0;
 	vmcb12->control.exit_info_2 = 0;
-	__nested_svm_vmexit(svm);
+	__nested_svm_vmexit(svm, vmcb12);
 }
 
 int nested_svm_vmrun(struct kvm_vcpu *vcpu)
@@ -1205,8 +1209,6 @@ void nested_svm_vmexit(struct vcpu_svm *svm)
 		vmcb12->control.next_rip  = vmcb02->control.next_rip;
 
 	vmcb12->control.int_ctl           = svm->nested.ctl.int_ctl;
-	vmcb12->control.event_inj         = svm->nested.ctl.event_inj;
-	vmcb12->control.event_inj_err     = svm->nested.ctl.event_inj_err;
 
 	if (!kvm_pause_in_guest(vcpu->kvm)) {
 		vmcb01->control.pause_filter_count = vmcb02->control.pause_filter_count;
@@ -1316,8 +1318,6 @@ void nested_svm_vmexit(struct vcpu_svm *svm)
 				       vmcb12->control.exit_int_info_err,
 				       KVM_ISA_SVM);
 
-	kvm_vcpu_unmap(vcpu, &map);
-
 	nested_svm_transition_tlb_flush(vcpu);
 
 	/*
@@ -1339,7 +1339,9 @@ void nested_svm_vmexit(struct vcpu_svm *svm)
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
2.53.0.rc2.204.g2597b5adb4-goog


