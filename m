Return-Path: <kvm+bounces-71473-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kB0hO792nGlfIAQAu9opvQ
	(envelope-from <kvm+bounces-71473-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:48:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F34417905C
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:48:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E61DA3038EDE
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 15:47:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33A6E306B37;
	Mon, 23 Feb 2026 15:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qhC9e6r7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664E83016E3;
	Mon, 23 Feb 2026 15:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771861613; cv=none; b=T/TXnyE5LGABBa9OYeVwsEvxbnBthEGt1C9EuSbSgPiqCn2ySpEpus7P73psJ3sEqyOQ+ohvOy/Fy6LcQ/1uJWr68IIRJMFrHHmQlk6A/J8i3XfQ0PzhsqWXiWeZLyy4ChkOxvAjdui8r7ryot6hc9tafDrPJ/U5ofUngDi46Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771861613; c=relaxed/simple;
	bh=Y8Pg+7XWSPNEVqmUOFpomAns4n3+klMSUO/2YgFvnrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ie+YlcqQkc8QrmsPn5WP4lgKM0TyvzcNVVDmlkGqKM5oCtimhvlO6wWDZVuVuj7slf8/v4kSbljoGKoh1qNM8w9oFdf4R+uO4P8FNvc2523TtAX2ftQR7mkCnNFywVAwTaiKAstlUljcOr8CuQ3mXKQGKME37WG6EINe/+FH/mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qhC9e6r7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10927C116D0;
	Mon, 23 Feb 2026 15:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771861613;
	bh=Y8Pg+7XWSPNEVqmUOFpomAns4n3+klMSUO/2YgFvnrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qhC9e6r7/d5ZvG5BB3XR7ZQ1ovydzLa34VsxX3guTF04RxLkyKZLkiyOKHYeonqFX
	 W3u0qR0thD16FAIThP2OqPcYbk7syWeezyRwSXMITLAH239DCIpuqrYQMAg7oEmuOj
	 Hv8oEe3qqCLrg4iwfWVIZ6vz2QVXcXOjmom1yoQMhk4KrOQ0wsLfQDHRLZ+kVKOseZ
	 Fzb//EkilZOfoN3RK+CqEryj3kDTSDgKNDG1cXq8fDm9UFoqYLgel1PvKRXz+qBwF7
	 GUpWfIkBZKU06tHNzpDgIBZICOzmJEuxYPVsZyri+xRS2NuaeDf0mAkhyPEOpjstqE
	 +5KYBG02s5Cow==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v1 2/4] KVM: nSVM: Delay stuffing L2's current RIP into NextRIP until vCPU run
Date: Mon, 23 Feb 2026 15:46:34 +0000
Message-ID: <20260223154636.116671-3-yosry@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71473-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 0F34417905C
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
 arch/x86/kvm/svm/svm.c    | 18 ++++++++++++++++++
 2 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index a82e6f0472ca7..b7c80aeaebab3 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -844,24 +844,15 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
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
index 8f8bc863e2143..e084b9688f556 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1413,6 +1413,24 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 		sd->bp_spec_reduce_set = true;
 		msr_set_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
 	}
+
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
 	svm->guest_state_loaded = true;
 }
 
-- 
2.53.0.345.g96ddfc5eaa-goog


