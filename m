Return-Path: <kvm+bounces-71021-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cD9YDPJdjmmdBwEAu9opvQ
	(envelope-from <kvm+bounces-71021-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 00:10:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 81DCB131AA1
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 00:10:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EFCA931814B7
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 23:08:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7DE635E558;
	Thu, 12 Feb 2026 23:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="w0hL4t1W"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7925135E522
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 23:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770937706; cv=none; b=mKnG7Pxaz8d1RmgGTq3GcS/rhPskWwTKF2M6tOw4yfHiuIWGPkqLbvwwuwwST/nkUXfaCFoNH06d1zHM7klbd6o6+DevrQzSu3oVdvWlx8v+JWZ2r+mMN4V2m3Jfmrj+iGjLI79MBZo8L9rgMPd3BYr9WH/E8emFBjQ4kF0Ut70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770937706; c=relaxed/simple;
	bh=QvCQhbaKFsPu61SMIC48+FImwnhjQHq0q3yxVCOyg1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ma/XIYnYNWQFg2Ib32bfSuKuJWszeZGYDjWpy/SoV1mcR3cQzpohIU6VZX3JJN81dz/tNyRJWm0tt344Ix6BWLZV/7cuNT2UlKxt4ViN+U7ZQSsMX+xXZBp0Ke9/wiLFRGYzG8iTjdIFHCIuSXmcDIKgNnGUHI18RhiCxsvNS4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=w0hL4t1W; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770937702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Aea0BoA8HcYLsHpQYiRS3wr3b9yRtg1pHhwr45NJjRA=;
	b=w0hL4t1WXLmK73m7S21kg8sG2GwxIuonzAHp+N0Q3pNUfmkaAE7yefuza+/JH6gSXgtOTa
	1XZgeJRrJYbOSE4xrL1BH+yQH6DChYBqlhADGqRf3ELmWOzOE90igaeHmgL2kr7sPuMwT2
	dAmYyjvaKw0MJH3cbA4Unqfq3xer0h8=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [RFC PATCH 4/5] KVM: SVM: Recalculate nested RIPs after restoring REGS/SREGS
Date: Thu, 12 Feb 2026 23:07:50 +0000
Message-ID: <20260212230751.1871720-5-yosry.ahmed@linux.dev>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71021-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:mid,linux.dev:dkim,linux.dev:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 81DCB131AA1
X-Rspamd-Action: no action

In the save/restore path, if KVM_SET_NESTED_STATE is performed before
restoring REGS and/or SREGS , the values of CS and RIP used to
initialize the vmcb02's NextRIP and soft interrupt tracking RIPs are
incorrect.

Recalculate them up after CS is set, or REGS are restored. This is only
needed when a nested run is pending during restore. After L2 runs for
the first time, any soft interrupts injected by L1 are already delivered
or tracked by KVM separately for re-injection, so the CS and RIP values
are no longer relevant.

If KVM_SET_NESTED_STATE is performed after both REGS and SREGS are
restored, it will just overwrite the fields.

Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE")
CC: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/svm/nested.c          |  4 +++-
 arch/x86/kvm/svm/svm.c             | 21 +++++++++++++++++++++
 arch/x86/kvm/x86.c                 |  2 ++
 5 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index de709fb5bd76..7221517ea3e6 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -54,6 +54,7 @@ KVM_X86_OP(cache_reg)
 KVM_X86_OP(get_rflags)
 KVM_X86_OP(set_rflags)
 KVM_X86_OP(get_if_flag)
+KVM_X86_OP_OPTIONAL(post_user_set_regs)
 KVM_X86_OP(flush_tlb_all)
 KVM_X86_OP(flush_tlb_current)
 #if IS_ENABLED(CONFIG_HYPERV)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ff07c45e3c73..feadd9579159 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1789,6 +1789,7 @@ struct kvm_x86_ops {
 	unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
 	void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
 	bool (*get_if_flag)(struct kvm_vcpu *vcpu);
+	void (*post_user_set_regs)(struct kvm_vcpu *vcpu);
 
 	void (*flush_tlb_all)(struct kvm_vcpu *vcpu);
 	void (*flush_tlb_current)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index af7a0113f269..22680aa31c28 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -766,7 +766,9 @@ void nested_vmcb02_prepare_rips(struct kvm_vcpu *vcpu, unsigned long csbase,
 	else if (boot_cpu_has(X86_FEATURE_NRIPS))
 		svm->vmcb->control.next_rip    = rip;
 
-	if (!is_evtinj_soft(svm->nested.ctl.event_inj))
+	/* L1's injected events should be cleared after the first run of L2 */
+	if (!is_evtinj_soft(svm->nested.ctl.event_inj) ||
+	    WARN_ON_ONCE(!svm->nested.nested_run_pending))
 		return;
 
 	svm->soft_int_injected = true;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8f8bc863e214..5729da2b300d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1477,6 +1477,24 @@ static bool svm_get_if_flag(struct kvm_vcpu *vcpu)
 		: kvm_get_rflags(vcpu) & X86_EFLAGS_IF;
 }
 
+static void svm_fixup_nested_rips(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	/*
+	 * In the save/restore path, if nested state is restored before
+	 * RIP or CS, then fixing up the vmcb02 (and soft IRQ tracking) is
+	 * needed. This is only the case if a nested run is pending (i.e. L2
+	 * is yet to run after L1's VMRUN). Otherwise, any soft IRQ injected by
+	 * L1 should have been delivered to L2 or is being tracked separately by
+	 * KVM for re-injection. Similarly, NextRIP would have already been
+	 * updated by the CPU and/or KVM.
+	 */
+	if (svm->nested.nested_run_pending)
+		nested_vmcb02_prepare_rips(vcpu, svm->vmcb->save.cs.base,
+					   kvm_rip_read(vcpu));
+}
+
 static void svm_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 {
 	kvm_register_mark_available(vcpu, reg);
@@ -1826,6 +1844,8 @@ static void svm_set_segment(struct kvm_vcpu *vcpu,
 	if (seg == VCPU_SREG_SS)
 		/* This is symmetric with svm_get_segment() */
 		svm->vmcb->save.cpl = (var->dpl & 3);
+	else if (seg == VCPU_SREG_CS)
+		svm_fixup_nested_rips(vcpu);
 
 	vmcb_mark_dirty(svm->vmcb, VMCB_SEG);
 }
@@ -5172,6 +5192,7 @@ struct kvm_x86_ops svm_x86_ops __initdata = {
 	.get_rflags = svm_get_rflags,
 	.set_rflags = svm_set_rflags,
 	.get_if_flag = svm_get_if_flag,
+	.post_user_set_regs = svm_fixup_nested_rips,
 
 	.flush_tlb_all = svm_flush_tlb_all,
 	.flush_tlb_current = svm_flush_tlb_current,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index db3f393192d9..35fe1d337273 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12112,6 +12112,8 @@ static void __set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	kvm_rip_write(vcpu, regs->rip);
 	kvm_set_rflags(vcpu, regs->rflags | X86_EFLAGS_FIXED);
 
+	kvm_x86_call(post_user_set_regs)(vcpu);
+
 	vcpu->arch.exception.pending = false;
 	vcpu->arch.exception_vmexit.pending = false;
 
-- 
2.53.0.273.g2a3d683680-goog


