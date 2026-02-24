Return-Path: <kvm+bounces-71685-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4OAjEa8nnmn5TgQAu9opvQ
	(envelope-from <kvm+bounces-71685-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:35:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 15E6918D67A
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:35:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D58EF30764A7
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 22:34:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 369B9361653;
	Tue, 24 Feb 2026 22:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VpPESNg4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3462334B1A3;
	Tue, 24 Feb 2026 22:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771972465; cv=none; b=sOtXRoK6Am1xr7e6ohkNeDoYElAz3itdGBRSq4a7MEugQeuZrws+hwK6ohvPFR3bTfJLYt/lMWj0pRlUg2par1NnaIxZAL6ib/2kTYP6aNAmc5ZNp1blnTTEJstOUH62t2NpWJLez5mSdgxqFa+oJEeB6qzHoyGO3xtSnWhVE64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771972465; c=relaxed/simple;
	bh=mGtF0Nz4GONPYrQId/2sXtHw9VAke+w2/SaOhrC75C8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EhwXwvZDs8DKBGn1z/h3WLD+5rRaHPsKkN3zbtWPqHtt1gM7k6J/JcAg00u/aTlXRt53Jl2KNZhimI5jf0tgDq9kOLbv5rlTg25fDjcriZ85KFcsH/KDJpPlYsvHBLCkeGZnIy3M45PZorHW9Hd2CLGAtnjy0mGgJCyPU2T+zjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VpPESNg4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF243C2BCB2;
	Tue, 24 Feb 2026 22:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771972465;
	bh=mGtF0Nz4GONPYrQId/2sXtHw9VAke+w2/SaOhrC75C8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VpPESNg4eCdQDirTNQcFeP8vHfGs5k86JQxMBNIr1PzFl8sytWiUKaWr1vHYzf0v1
	 9mylC27l7qdBJKUeOKqQgQNQNKxIgMfrHM2E1XY43fdKR4vlhLyMwfvkYrBuB7Rd/n
	 3uP8JkmhxyHqAvPVqIKAkaGY3FrthmKpDFbJDOFAfFZ8J3xjO+tKjvmlbrleomK0lD
	 ro2uTqpRTclzynclJ/xCv4tFj7psJR6bJ/iPEHudS1EeTyqgCNyEgd3+G8uh/cawrS
	 LiGhRZpKzVHG2V4/IAqog8Xd9Xcw0A4iUxuLfN6gYHKtTvuss9uIm76e5oNalcKD+J
	 BeZzgX63bkauw==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v6 09/31] KVM: nSVM: Triple fault if restore host CR3 fails on nested #VMEXIT
Date: Tue, 24 Feb 2026 22:33:43 +0000
Message-ID: <20260224223405.3270433-10-yosry@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71685-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 15E6918D67A
X-Rspamd-Action: no action

If loading L1's CR3 fails on a nested #VMEXIT, nested_svm_vmexit()
returns an error code that is ignored by most callers, and continues to
run L1 with corrupted state. A sane recovery is not possible in this
case, and HW behavior is to cause a shutdown. Inject a triple fault
,nstead, and do not return early from nested_svm_vmexit(). Continue
cleaning up the vCPU state (e.g. clear pending exceptions), to handle
the failure as gracefully as possible.

From the APM:
	Upon #VMEXIT, the processor performs the following actions in
	order to return to the host execution context:

	...
	if (illegal host state loaded, or exception while loading
	    host state)
		shutdown
	else
		execute first host instruction following the VMRUN

Remove the return value of nested_svm_vmexit(), which is mostly
unchecked anyway.

Fixes: d82aaef9c88a ("KVM: nSVM: use nested_svm_load_cr3() on guest->host switch")
CC: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 10 +++-------
 arch/x86/kvm/svm/svm.c    | 11 ++---------
 arch/x86/kvm/svm/svm.h    |  6 +++---
 3 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 280d0fccd1971..d734cd5eef5e7 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1191,12 +1191,11 @@ static int nested_svm_vmexit_update_vmcb12(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-int nested_svm_vmexit(struct vcpu_svm *svm)
+void nested_svm_vmexit(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	struct vmcb *vmcb01 = svm->vmcb01.ptr;
 	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
-	int rc;
 
 	if (nested_svm_vmexit_update_vmcb12(vcpu))
 		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
@@ -1315,9 +1314,8 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	nested_svm_uninit_mmu_context(vcpu);
 
-	rc = nested_svm_load_cr3(vcpu, vmcb01->save.cr3, false, true);
-	if (rc)
-		return 1;
+	if (nested_svm_load_cr3(vcpu, vmcb01->save.cr3, false, true))
+		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 
 	/*
 	 * Drop what we picked up for L2 via svm_complete_interrupts() so it
@@ -1342,8 +1340,6 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	 */
 	if (kvm_apicv_activated(vcpu->kvm))
 		__kvm_vcpu_update_apicv(vcpu);
-
-	return 0;
 }
 
 static void nested_svm_triple_fault(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cb53174583a26..1b31b033d79b0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2234,13 +2234,9 @@ static int emulate_svm_instr(struct kvm_vcpu *vcpu, int opcode)
 		[SVM_INSTR_VMSAVE] = vmsave_interception,
 	};
 	struct vcpu_svm *svm = to_svm(vcpu);
-	int ret;
 
 	if (is_guest_mode(vcpu)) {
-		/* Returns '1' or -errno on failure, '0' on success. */
-		ret = nested_svm_simple_vmexit(svm, guest_mode_exit_codes[opcode]);
-		if (ret)
-			return ret;
+		nested_svm_simple_vmexit(svm, guest_mode_exit_codes[opcode]);
 		return 1;
 	}
 	return svm_instr_handlers[opcode](vcpu);
@@ -4796,7 +4792,6 @@ static int svm_enter_smm(struct kvm_vcpu *vcpu, union kvm_smram *smram)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_host_map map_save;
-	int ret;
 
 	if (!is_guest_mode(vcpu))
 		return 0;
@@ -4816,9 +4811,7 @@ static int svm_enter_smm(struct kvm_vcpu *vcpu, union kvm_smram *smram)
 	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
 	svm->vmcb->save.rip = vcpu->arch.regs[VCPU_REGS_RIP];
 
-	ret = nested_svm_simple_vmexit(svm, SVM_EXIT_SW);
-	if (ret)
-		return ret;
+	nested_svm_simple_vmexit(svm, SVM_EXIT_SW);
 
 	/*
 	 * KVM uses VMCB01 to store L1 host state while L2 runs but
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 44d767cd1d25a..7629cb37c9302 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -793,14 +793,14 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu);
 void svm_copy_vmrun_state(struct vmcb_save_area *to_save,
 			  struct vmcb_save_area *from_save);
 void svm_copy_vmloadsave_state(struct vmcb *to_vmcb, struct vmcb *from_vmcb);
-int nested_svm_vmexit(struct vcpu_svm *svm);
+void nested_svm_vmexit(struct vcpu_svm *svm);
 
-static inline int nested_svm_simple_vmexit(struct vcpu_svm *svm, u32 exit_code)
+static inline void nested_svm_simple_vmexit(struct vcpu_svm *svm, u32 exit_code)
 {
 	svm->vmcb->control.exit_code	= exit_code;
 	svm->vmcb->control.exit_info_1	= 0;
 	svm->vmcb->control.exit_info_2	= 0;
-	return nested_svm_vmexit(svm);
+	nested_svm_vmexit(svm);
 }
 
 int nested_svm_exit_handled(struct vcpu_svm *svm);
-- 
2.53.0.414.gf7e9f6c205-goog


