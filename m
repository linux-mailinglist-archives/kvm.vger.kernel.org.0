Return-Path: <kvm+bounces-71691-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6Ei1FMwonmn5TgQAu9opvQ
	(envelope-from <kvm+bounces-71691-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:40:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C4EF718D7CB
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:40:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8776D31562A5
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 22:35:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7B1636C0DA;
	Tue, 24 Feb 2026 22:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DawznD1v"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18EF364055;
	Tue, 24 Feb 2026 22:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771972467; cv=none; b=tEPh/iEMHdjVBTt072fVoK0W/kag2CU4/nhkXwQrv/AVSlkBfM/tCZg9Kxwrbr8RlrKEVImJ8rX42O9DGg64CJu28KkBUdYf+g/MnLak4RyAIdWsluRSHyjUNig9SJ6hKx4xKdprOPkco9Z3oWZu4uefz1M1r/sBAvuVjeVnIIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771972467; c=relaxed/simple;
	bh=o/TTK+emy1Ox83p7KmqZovyUmvrbAaSzPmRDbdTnp2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SA7BDGClVJgurNc5wTAE6mF+sXIscCE710Kz8lNYI8kxlWTy+nfWF0YuFVAxag+/rjEoE26i/4uIEtL2B9EZfRtG/cqpkGUUlG8h0wu3FZKboPeZQB5Ukx8j7i/mbQlKueOeZ0r2cGgWGtSg9puWLX0aw1T03W2KHhyOXgHXJr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DawznD1v; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400A1C19424;
	Tue, 24 Feb 2026 22:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771972467;
	bh=o/TTK+emy1Ox83p7KmqZovyUmvrbAaSzPmRDbdTnp2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DawznD1vy7DDMbtllzrFMkP3Ex4oFSEWM0+iMdrDkcyo5hHZg/Z+zlcxbBdSNxM3p
	 8TPqdqvibXZcNwegJJEINUGQx9p76SPXm9g4yirevW9eIT5IRvYiW5OD0moAmYz29h
	 98crEt64+/wpZzdffDQDXMP6ud/dwcVDWxfDdLhds11O3Rqz7/sbNqDcxvrf2wsEhs
	 B6hKZ9L4ucvnuauhJimDb/C1h1IeEMric6ltV4TgLHfJO8N5XpFfRcyg33GDyASRu8
	 oCLDrp9OblmliOKXXQ7ASIEeUUhfzaR4AjeJ1jbP1HOrdVw0HDoOVxQhdSTt2dH303
	 yE+KrZDU2/YuQ==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v6 15/31] KVM: nSVM: Refactor minimal #VMEXIT handling out of nested_svm_vmexit()
Date: Tue, 24 Feb 2026 22:33:49 +0000
Message-ID: <20260224223405.3270433-16-yosry@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71691-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C4EF718D7CB
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
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 54 ++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 13d1276940330..a6e8c0d26c64e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -979,6 +979,33 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
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
+
+	if (nested_svm_load_cr3(vcpu, vmcb01->save.cr3, false, true))
+		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
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
@@ -1187,7 +1214,6 @@ void nested_svm_vmexit(struct vcpu_svm *svm)
 
 	/* Exit Guest-Mode */
 	leave_guest_mode(vcpu);
-	svm->nested.vmcb12_gpa = 0;
 	WARN_ON_ONCE(svm->nested.nested_run_pending);
 
 	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
@@ -1260,13 +1286,6 @@ void nested_svm_vmexit(struct vcpu_svm *svm)
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
@@ -1279,8 +1298,6 @@ void nested_svm_vmexit(struct vcpu_svm *svm)
 		svm_write_tsc_multiplier(vcpu);
 	}
 
-	svm->nested.ctl.nested_cr3 = 0;
-
 	/*
 	 * Restore processor state that had been saved in vmcb01
 	 */
@@ -1297,11 +1314,6 @@ void nested_svm_vmexit(struct vcpu_svm *svm)
 
 	nested_svm_transition_tlb_flush(vcpu);
 
-	nested_svm_uninit_mmu_context(vcpu);
-
-	if (nested_svm_load_cr3(vcpu, vmcb01->save.cr3, false, true))
-		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
-
 	/*
 	 * Drop what we picked up for L2 via svm_complete_interrupts() so it
 	 * doesn't end up in L1.
@@ -1310,21 +1322,15 @@ void nested_svm_vmexit(struct vcpu_svm *svm)
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
+	/* After clearing exceptions as it may need to queue an exception */
+	__nested_svm_vmexit(svm);
 }
 
 static void nested_svm_triple_fault(struct kvm_vcpu *vcpu)
-- 
2.53.0.414.gf7e9f6c205-goog


