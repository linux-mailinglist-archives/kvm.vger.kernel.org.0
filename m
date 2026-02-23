Return-Path: <kvm+bounces-71474-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IDXhMuB2nGlfIAQAu9opvQ
	(envelope-from <kvm+bounces-71474-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:48:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 0306E17907D
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:48:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 88B60303D7F7
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 15:47:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0DFE30ACE6;
	Mon, 23 Feb 2026 15:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LPyVv/Ar"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24CB303C93;
	Mon, 23 Feb 2026 15:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771861614; cv=none; b=dogEETzlO9YiazhdD1Vgf+C/c4wIri7ddKac+l2Myasb+tcLwNjtoYDOHCTaDeD0qCMsIcSNEwEFcaO8mNyIyark1Dt/oacRPbDCzng1dcnPgDHtmLFGiGXAlOm0DXgWD0om32d9ktPkKZv2bvXOsZl1qMNA7P1beT1/2xTpK1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771861614; c=relaxed/simple;
	bh=9Z3qvPLjIfA4xmLgP5BOB9tiL0sSsppjvHrWM3gcbrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MRafO1//Pb3h/wzRf1biafOXRY0hooS2CH7CZ3pMQnRRj82Wn85F/H3B2Hs2pr8ep3b9iAcQNOlXbt93Ml8zrzoaDZwpwxa6LC85cCqwVJRB9rBvo8wQ6+B2Pyy4uB8lrn8twC10pZZwDklllsHXEo8ie6aGw9No/V5q4pnDjR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LPyVv/Ar; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B3BC19424;
	Mon, 23 Feb 2026 15:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771861613;
	bh=9Z3qvPLjIfA4xmLgP5BOB9tiL0sSsppjvHrWM3gcbrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LPyVv/ArCOEdL8W+xcwtlqVcMNFXHAPaJQUzsijgX1PRUZUqOHlY3krVFGIl8sTeT
	 4fjIEijq2E3w6VBg2ESbQCNafUg78DCTN39Va+NSk1ByXnif7GI0jXZ78Jh1z8Jgi1
	 HeP6ilFsaO87FWXMZCTVOuTXNymYS9EoIVwPiSQvubwcU8nim3E2Av33cyQvQPHPGg
	 08+wHPocsijTGFflzaXZQra+xhXVuJjiRjRBp+K7x0eI66JfwypDzAityjB04nVg9+
	 kkB7pLNoI9MDHJqCF5eLbuqr86LBPG0aZv425g599aqrZakRiTsq0JqmRANGjPOEJh
	 n9FOX6qCBf50Q==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v1 3/4] KVM: nSVM: Delay setting soft IRQ RIP tracking fields until vCPU run
Date: Mon, 23 Feb 2026 15:46:35 +0000
Message-ID: <20260223154636.116671-4-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
In-Reply-To: <20260223154636.116671-1-yosry@kernel.org>
References: <20260223154636.116671-1-yosry@kernel.org>
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
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71474-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 0306E17907D
X-Rspamd-Action: no action

In the save+restore path, when restoring nested state, the values of RIP
and CS base passed into nested_vmcb02_prepare_control() are mostly
incorrect.  They are both pulled from the vmcb02. For CS base, the value
is only correct if system regs are restored before nested state. The
value of RIP is whatever the vCPU had in vmcb02 before restoring nested
state (zero on a freshly created vCPU).

Instead, take a similar approach to NextRIP, and delay initializing the
RIP tracking fields until shortly before the vCPU is run, to make sure
the most up-to-date values of RIP and CS base are used regardless of
KVM_SET_SREGS, KVM_SET_REGS, and KVM_SET_NESTED_STATE's relative
ordering.

Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE")
CC: stable@vger.kernel.org
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 17 ++++++++---------
 arch/x86/kvm/svm/svm.c    | 10 ++++++++++
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index b7c80aeaebab3..0547fd2810a3a 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -741,9 +741,7 @@ static bool is_evtinj_nmi(u32 evtinj)
 	return type == SVM_EVTINJ_TYPE_NMI;
 }
 
-static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
-					  unsigned long vmcb12_rip,
-					  unsigned long vmcb12_csbase)
+static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 {
 	u32 int_ctl_vmcb01_bits = V_INTR_MASKING_MASK;
 	u32 int_ctl_vmcb12_bits = V_TPR_MASK | V_IRQ_INJECTION_BITS_MASK;
@@ -855,14 +853,15 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 		vmcb02->control.next_rip = svm->nested.ctl.next_rip;
 
 	svm->nmi_l1_to_l2 = is_evtinj_nmi(vmcb02->control.event_inj);
+
+	/*
+	 * soft_int_csbase, soft_int_old_rip, and soft_int_next_rip (if L1
+	 * doesn't have NRIPS)  are initialized later, before the vCPU is run.
+	 */
 	if (is_evtinj_soft(vmcb02->control.event_inj)) {
 		svm->soft_int_injected = true;
-		svm->soft_int_csbase = vmcb12_csbase;
-		svm->soft_int_old_rip = vmcb12_rip;
 		if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
 			svm->soft_int_next_rip = svm->nested.ctl.next_rip;
-		else
-			svm->soft_int_next_rip = vmcb12_rip;
 	}
 
 	/* LBR_CTL_ENABLE_MASK is controlled by svm_update_lbrv() */
@@ -960,7 +959,7 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 	nested_svm_copy_common_state(svm->vmcb01.ptr, svm->nested.vmcb02.ptr);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
-	nested_vmcb02_prepare_control(svm, vmcb12->save.rip, vmcb12->save.cs.base);
+	nested_vmcb02_prepare_control(svm);
 	nested_vmcb02_prepare_save(svm, vmcb12);
 
 	ret = nested_svm_load_cr3(&svm->vcpu, svm->nested.save.cr3,
@@ -1905,7 +1904,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	nested_copy_vmcb_control_to_cache(svm, ctl);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
-	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip, svm->vmcb->save.cs.base);
+	nested_vmcb02_prepare_control(svm);
 
 	/*
 	 * While the nested guest CR3 is already checked and set by
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e084b9688f556..37f3b031b3a76 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1424,11 +1424,21 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	 * This is done here (as opposed to when preparing vmcb02) to use the
 	 * most up-to-date value of RIP regardless of the order of restoring
 	 * registers and nested state in the vCPU save+restore path.
+	 *
+	 * Simiarly, initialize svm->soft_int_* fields here to use the most
+	 * up-to-date values of RIP and CS base, regardless of restore order.
 	 */
 	if (is_guest_mode(vcpu) && svm->nested.nested_run_pending) {
 		if (boot_cpu_has(X86_FEATURE_NRIPS) &&
 		    !guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
 			svm->vmcb->control.next_rip = kvm_rip_read(vcpu);
+
+		if (svm->soft_int_injected) {
+			svm->soft_int_csbase = svm->vmcb->save.cs.base;
+			svm->soft_int_old_rip = kvm_rip_read(vcpu);
+			if (!guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
+				svm->soft_int_next_rip = kvm_rip_read(vcpu);
+		}
 	}
 
 	svm->guest_state_loaded = true;
-- 
2.53.0.345.g96ddfc5eaa-goog


