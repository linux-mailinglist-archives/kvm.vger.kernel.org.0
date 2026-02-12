Return-Path: <kvm+bounces-71022-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uCncGfRdjmmdBwEAu9opvQ
	(envelope-from <kvm+bounces-71022-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 00:10:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BEE7E131AAA
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 00:10:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 20D403182ABC
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 23:08:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0BE335E55B;
	Thu, 12 Feb 2026 23:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="P7w5SE72"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA23E3376A9
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 23:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770937706; cv=none; b=DMkC8WXJM1ZvY31hlf4/nnVRtHx+IyiL7owfQGAP24xBAeHPCH38+RFYxE7LLEgNHIyAgtgBkhibyThz77ORA9mvMlWazsv4UNJnVVGEPOrO+41gIBM2u3Al2Nq8t/z/WvGxLcaDhDdeGVWczF7NqUlnCgW5Eq+gtSwOe+4ygfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770937706; c=relaxed/simple;
	bh=rX2Oi31usLIlskT+HFF+rdeWcZqC2SD2sO4VNem1jf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HID9CubhlayUosQM9qDg6l4QFLfEFielT4jXOa9n1vAl5MhkWL1tXX0v3T1dabJdY5QjtJqgGzjfmE5UNMaHWJ8TVMLVkq7Ypyzxu5M1uYiSxJxu3lOhwso6FDimHMpjI99FbxkWWoIYW3ZHl3Jd1ft9hzaC4H/Lsd891rKfVv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=P7w5SE72; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770937701;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bRQktyz1OWXBe0KR8az0RWyUUDXfQ1olq/zdmRsnwZg=;
	b=P7w5SE72XnOAQB+33lRf5Zg+GSsI7ciIXES1PagK33oTGg+Vk7TphZ3oyDWyLiMEYCZN5e
	P4NKR2bojMB/l6DHFz01KWGMCH7mvVsbnwx663j7nbszNYGrMRFlTe18GiKuBdoRTV91bx
	xjzX2FgsqTkF8X5vTKhKXBhbmMejwlY=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [RFC PATCH 3/5] KVM: nSVM: Move updating NextRIP and soft IRQ RIPs into a helper
Date: Thu, 12 Feb 2026 23:07:49 +0000
Message-ID: <20260212230751.1871720-4-yosry.ahmed@linux.dev>
In-Reply-To: <20260212230751.1871720-1-yosry.ahmed@linux.dev>
References: <20260212230751.1871720-1-yosry.ahmed@linux.dev>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71022-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[linux.dev:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:mid,linux.dev:dkim,linux.dev:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BEE7E131AAA
X-Rspamd-Action: no action

Move the logic for updating NextRIP and soft interrupt tracking fields
out of nested_vmcb02_prepare_control() into a helper, in preparation for
re-using the same logic to fixup the RIPs during save/restore.

No functional change intended.

CC: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 64 +++++++++++++++++++++++----------------
 arch/x86/kvm/svm/svm.h    |  2 ++
 2 files changed, 40 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index aec17c80ed73..af7a0113f269 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -741,6 +741,43 @@ static bool is_evtinj_nmi(u32 evtinj)
 	return type == SVM_EVTINJ_TYPE_NMI;
 }
 
+void nested_vmcb02_prepare_rips(struct kvm_vcpu *vcpu, unsigned long csbase,
+				unsigned long rip)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (WARN_ON_ONCE(svm->vmcb != svm->nested.vmcb02.ptr))
+		return;
+
+	/*
+	 * NextRIP is consumed on VMRUN as the return address pushed on the
+	 * stack for injected soft exceptions/interrupts.  If nrips is exposed
+	 * to L1, take it verbatim.
+	 *
+	 * If nrips is supported in hardware but not exposed to L1, stuff the
+	 * actual L2 RIP to emulate what a nrips=0 CPU would do (L1 is
+	 * responsible for advancing RIP prior to injecting the event). This is
+	 * only the case for the first L2 run after VMRUN. After that (e.g.
+	 * during save/restore), NextRIP is updated by the CPU and/or KVM, and
+	 * the value of the L2 RIP should not be used.
+	 */
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS) || !svm->nested.nested_run_pending)
+		svm->vmcb->control.next_rip    = svm->nested.ctl.next_rip;
+	else if (boot_cpu_has(X86_FEATURE_NRIPS))
+		svm->vmcb->control.next_rip    = rip;
+
+	if (!is_evtinj_soft(svm->nested.ctl.event_inj))
+		return;
+
+	svm->soft_int_injected = true;
+	svm->soft_int_csbase = csbase;
+	svm->soft_int_old_rip = rip;
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
+		svm->soft_int_next_rip = svm->nested.ctl.next_rip;
+	else
+		svm->soft_int_next_rip = rip;
+}
+
 static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 					  unsigned long vmcb12_rip,
 					  unsigned long vmcb12_csbase)
@@ -843,33 +880,8 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	vmcb02->control.event_inj           = svm->nested.ctl.event_inj;
 	vmcb02->control.event_inj_err       = svm->nested.ctl.event_inj_err;
 
-	/*
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
-	 */
-	if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS) || !svm->nested.nested_run_pending)
-		vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
-	else if (boot_cpu_has(X86_FEATURE_NRIPS))
-		vmcb02->control.next_rip    = vmcb12_rip;
-
 	svm->nmi_l1_to_l2 = is_evtinj_nmi(vmcb02->control.event_inj);
-	if (is_evtinj_soft(vmcb02->control.event_inj)) {
-		svm->soft_int_injected = true;
-		svm->soft_int_csbase = vmcb12_csbase;
-		svm->soft_int_old_rip = vmcb12_rip;
-		if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
-			svm->soft_int_next_rip = svm->nested.ctl.next_rip;
-		else
-			svm->soft_int_next_rip = vmcb12_rip;
-	}
+	nested_vmcb02_prepare_rips(vcpu, vmcb12_csbase, vmcb12_rip);
 
 	/* LBR_CTL_ENABLE_MASK is controlled by svm_update_lbrv() */
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index ebd7b36b1ceb..057281dda487 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -809,6 +809,8 @@ void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
 void nested_sync_control_from_vmcb02(struct vcpu_svm *svm);
 void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm);
 void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb);
+void nested_vmcb02_prepare_rips(struct kvm_vcpu *vcpu, unsigned long csbase,
+				unsigned long rip);
 
 extern struct kvm_x86_nested_ops svm_nested_ops;
 
-- 
2.53.0.273.g2a3d683680-goog


