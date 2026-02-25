Return-Path: <kvm+bounces-71722-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IMxnFUpKnmnXUQQAu9opvQ
	(envelope-from <kvm+bounces-71722-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:03:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 88BA918E7F9
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:03:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8A788306ED26
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 01:00:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7994428AAEE;
	Wed, 25 Feb 2026 01:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EcWDyfxn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DF7281341;
	Wed, 25 Feb 2026 01:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771981203; cv=none; b=TslAdCpD+2abUWzw9PTS5rLH89ZyuNRrU8q2STxaf3pddxy+Lwp1Mv9WfD3s1Zu3sfV+UtXiOTFLJ4Jtzf53VylnGrR0/PAUJxwz4XtysCosaSInUMWQNt89JKyA3vlUfyO3w4NMJVg5pcfehMiTGZjP7QXz98NyGsrdAXnZjXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771981203; c=relaxed/simple;
	bh=EBI2/8YnpxLRi6IkbJP88GTbYLkwR+A/P5v8Y9wBJHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S6Ot2lOKkJADUe9SZV8ED5AMtgezyE2jBDf2EMSTnnfsX5HT1uCJJgOQUgNEQmbm6f63IPWUk/8zvVTdbLzyO6v3Wi/Con5ObIjBZ58gnRQJnjWua7Pg6mOvoYiFNzabnCKdn5ZkeD1rmmld3IB28ed0eGbY5tfmqluMiJmQe5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EcWDyfxn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8079C2BC86;
	Wed, 25 Feb 2026 01:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771981203;
	bh=EBI2/8YnpxLRi6IkbJP88GTbYLkwR+A/P5v8Y9wBJHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EcWDyfxnDw7YQxEL7+/jf6tA182IkMuyqR+uQ01I3OBTGHSM5OulZB4y+YSIEverf
	 ZFKKe9k7nEYkY8VTF0TRg+kvDmc9GPTg19Vaa01s0CVlPR+aTaeFhvuPmaEmrDQV6V
	 RQVXVLwoYbUkHhBGqrUdxRAUb/zX0FipOLBcb1iriZ6qaL5LzoAzLhFjz7EHGclnHF
	 UI4JuxMdYLE8pRgctScBrgfvgbAWwDnMSkRCtrS/K4CZ3wylN0xARcblYdwrAh6pWb
	 qPo8tnY4nRZVhtUQ884LUXnUDIfH9iNpiQKWyW9qxl43AqJ2Dvy6lmhrLoQCWeNdKk
	 fUL6FAydK/Z7g==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v3 6/8] KVM: nSVM: Delay stuffing L2's current RIP into NextRIP until vCPU run
Date: Wed, 25 Feb 2026 00:59:48 +0000
Message-ID: <20260225005950.3739782-7-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
In-Reply-To: <20260225005950.3739782-1-yosry@kernel.org>
References: <20260225005950.3739782-1-yosry@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71722-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 88BA918E7F9
X-Rspamd-Action: no action

For guests with NRIPS disabled, L1 does not provide NextRIP when running
an L2 with an injected soft interrupt, instead it advances L2's RIP
before running it. KVM uses L2's current RIP as the NextRIP in vmcb02 to
emulate a CPU without NRIPS.

However, in svm_set_nested_state(), the value used for L2's current RIP
comes from vmcb02, which is just whatever the vCPU had in vmcb02 before
restoring nested state (zero on a freshly created vCPU). Passing the
cached RIP value instead (i.e. kvm_rip_read()) would only fix the issue
if registers are restored before nested state.

Instead, split the logic of setting NextRIP in vmcb02. Handle the
'normal' case of initializing vmcb02's NextRIP using NextRIP from vmcb12
(or KVM_GET_NESTED_STATE's payload) in nested_vmcb02_prepare_control().
Delay the special case of stuffing L2's current RIP into vmcb02's
NextRIP until shortly before the vCPU is run, to make sure the most
up-to-date value of RIP is used regardless of KVM_SET_REGS and
KVM_SET_NESTED_STATE's relative ordering.

Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE")
CC: stable@vger.kernel.org
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 25 ++++++++-----------------
 arch/x86/kvm/svm/svm.c    | 17 +++++++++++++++++
 2 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index f3ed1bdbe76c9..dcd4a8eb156f2 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -845,24 +845,15 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	vmcb02->control.event_inj_err       = svm->nested.ctl.event_inj_err;
 
 	/*
-	 * NextRIP is consumed on VMRUN as the return address pushed on the
-	 * stack for injected soft exceptions/interrupts.  If nrips is exposed
-	 * to L1, take it verbatim from vmcb12.
-	 *
-	 * If nrips is supported in hardware but not exposed to L1, stuff the
-	 * actual L2 RIP to emulate what a nrips=0 CPU would do (L1 is
-	 * responsible for advancing RIP prior to injecting the event). This is
-	 * only the case for the first L2 run after VMRUN. After that (e.g.
-	 * during save/restore), NextRIP is updated by the CPU and/or KVM, and
-	 * the value of the L2 RIP from vmcb12 should not be used.
+	 * If nrips is exposed to L1, take NextRIP as-is.  Otherwise, L1
+	 * advances L2's RIP before VMRUN instead of using NextRIP. KVM will
+	 * stuff the current RIP as vmcb02's NextRIP before L2 is run.  After
+	 * the first run of L2 (e.g. after save+restore), NextRIP is updated by
+	 * the CPU and/or KVM and should be used regardless of L1's support.
 	 */
-	if (boot_cpu_has(X86_FEATURE_NRIPS)) {
-		if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS) ||
-		    !svm->nested.nested_run_pending)
-			vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
-		else
-			vmcb02->control.next_rip    = vmcb12_rip;
-	}
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS) ||
+	    !svm->nested.nested_run_pending)
+		vmcb02->control.next_rip = svm->nested.ctl.next_rip;
 
 	svm->nmi_l1_to_l2 = is_evtinj_nmi(vmcb02->control.event_inj);
 	if (is_evtinj_soft(vmcb02->control.event_inj)) {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 07f096758f34f..ded4372f2d499 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3660,6 +3660,23 @@ static int pre_svm_run(struct kvm_vcpu *vcpu)
 	if (svm->current_vmcb->asid_generation != sd->asid_generation)
 		new_asid(svm, sd);
 
+	/*
+	 * If nrips is supported in hardware but not exposed to L1, stuff the
+	 * actual L2 RIP to emulate what a nrips=0 CPU would do (L1 is
+	 * responsible for advancing RIP prior to injecting the event). Once L2
+	 * runs after L1 executes VMRUN, NextRIP is updated by the CPU and/or
+	 * KVM, and this is no longer needed.
+	 *
+	 * This is done here (as opposed to when preparing vmcb02) to use the
+	 * most up-to-date value of RIP regardless of the order of restoring
+	 * registers and nested state in the vCPU save+restore path.
+	 */
+	if (is_guest_mode(vcpu) && svm->nested.nested_run_pending) {
+		if (boot_cpu_has(X86_FEATURE_NRIPS) &&
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
+			svm->vmcb->control.next_rip = kvm_rip_read(vcpu);
+	}
+
 	return 0;
 }
 
-- 
2.53.0.414.gf7e9f6c205-goog


