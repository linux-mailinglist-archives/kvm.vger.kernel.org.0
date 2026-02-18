Return-Path: <kvm+bounces-71291-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gI5GAKFHlmmCdQIAu9opvQ
	(envelope-from <kvm+bounces-71291-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:13:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4693A15AD5F
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:13:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 660A130A0121
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 23:10:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E9BB33B6F5;
	Wed, 18 Feb 2026 23:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FPB5h3Ne"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E8533A9F4
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 23:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771456218; cv=none; b=uCBZXcuTcmGvMc2wi5lJhhzuW22CxrO/NyfrnxUmDBwOSdSfE60x/JdTQmLAxYpottHqYuxAyX6XybzLnrooQq5jdi7Y3L05CXfRkVAyunJ5Z7IdIQEQuDznT1PKd+MQDMzAceX0C+VtS7mczD03Q57MC8OaqGbDyZhCNSSOA0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771456218; c=relaxed/simple;
	bh=6FyplMM1/1R9SGHEATi52jcFIHbZhtgrlM8MlbeHBx0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FtQ4MA+MhNxqBKRlUtcLd3yXXIeZhbxuuYy6DrgjOu1VmYHevEtBgUZwSh6ezaMo390/prSVgqDb7sCHjmjdvHOm6PYf6Ogcwq/eVLnB5/x4RecFMLq916tgAQ1PYFXCfDIOVg+bTB5We9ZSLcgFSPxzLS4vJlz63ihR/g4qm14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FPB5h3Ne; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-354c0234c1fso255465a91.2
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 15:10:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771456211; x=1772061011; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=CwBzC8ApcuV0uoozPZcU/zrvhWxwiR2ykbpvaueWHXY=;
        b=FPB5h3Ne1Wu3a58F+GMnDsHUPKHA0LHBfe5X9pbcl0K6mNNoqe+c8lCeoxrvdo3gx2
         MiKOsoKJksbqsuNnfgJn/W+BLPsfVdGjdhPtIlIMeqB82zXDnLljyuRFstdKrobP2tfL
         vp67Gw4NuU09Pevjrf+yAYP9yAH7NcGH2rpeOMLIiSPatpkof+mMXN2bwK6wQn53EuKq
         IOPmbmvNqJLAmEUdl00eN9p6ZrxxdE6jcVz+uyh7kQ1ywimr2HPBJ+RIeOdIJq/mZG+H
         Zs3/C67qP3L/4YXlxR43w97LvAk0iBb98RzBsSduhnuQIyWBgEdjNoOpOrGIeP5V5hWt
         uwoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771456211; x=1772061011;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CwBzC8ApcuV0uoozPZcU/zrvhWxwiR2ykbpvaueWHXY=;
        b=WIdAbLGODhOOSgQkJkPQX4PRmwcHpkf12iADiclSW3XNOu7ytVLoE9sM3hQjexgSBr
         BEdRKYY5w9Uq4sjwDjrPlviA1BN1rwtf0Yf8CG9/MMVC46+OLrdIKmesG4naw+3n0Z2q
         2osAcsHSKZ4+mT9rnPUvNjbXymCGs35QN2rGpgKajdCRttiE/EsxqDjgXRsx4DlGpk5Q
         Hk9aqzquzPcYTYxgFbSlXMJ6mFpOxbguQMTEeHMO8awePafRsMcvgrNMCag7sfP1g++p
         Vsnxn1ybQbmaIaw/Mxkg5lA4sEG9wpj5Fo1di7yiJJYYFdMfCujQSjjTxQ9aK9+2LYy+
         lQUg==
X-Gm-Message-State: AOJu0YwmguWRi6mIfEKNpXtLA7srnwffS1TsdOIX+bRmQitmHXDsS+1I
	KpOquF3ORCOJfW9JaUXOd/Bg3Go5yYK6ot2hloWTHgKOcHNxo1IkGBVzYIB/ZyMb1NfxVfG64q8
	Oqjin9w==
X-Received: from pjph2.prod.google.com ([2002:a17:90a:9c02:b0:351:c17:c7b9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3cd:b0:356:3ba2:1233
 with SMTP id 98e67ed59e1d1-35844f9bf1dmr8741212a91.22.1771456210724; Wed, 18
 Feb 2026 15:10:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 18 Feb 2026 15:09:55 -0800
In-Reply-To: <20260218230958.2877682-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260218230958.2877682-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <20260218230958.2877682-6-seanjc@google.com>
Subject: [PATCH v2 5/8] KVM: nSVM: Use intuitive local variables in nested_vmcb02_recalc_intercepts()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71291-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.dev:email];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 4693A15AD5F
X-Rspamd-Action: no action

Now that nested_vmcb02_recalc_intercepts() is explicitly scoped to deal
with *only* recalculating vmcb02 intercepts, rename its local variables to
use more intuivite names.  The current "c", "h", and "g" local variables,
for the current VMCB, vmcb01, and (cached) vmcb12 respectively, are short
and sweet, but don't do much to help unfamiliar readers understand what
the code is doing.

Use vmcb12_ctrl/vmcb01/vmcb02/vmcb12_ctrl in lieu of c/h/g to make it clear
the function is updating intercepts in vmcb02 based on the intercepts in
vmcb01 and (cached) vmcb12.

Opportunistically change the existing WARN_ON to a WARN_ON_ONCE so that a
KVM bug doesn't unintentionally DoS the host.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
[sean: use WARN_ON_ONCE, keep local vmcb12 cache as vmcb12_ctrl]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index e8512de5aef7..bda2d6d613c9 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -124,23 +124,20 @@ static bool nested_vmcb_needs_vls_intercept(struct vcpu_svm *svm)
 
 void nested_vmcb02_recalc_intercepts(struct vcpu_svm *svm)
 {
-	struct vmcb_control_area *c, *h;
-	struct vmcb_ctrl_area_cached *g;
+	struct vmcb_ctrl_area_cached *vmcb12_ctrl = &svm->nested.ctl;
+	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
+	struct vmcb *vmcb01 = svm->vmcb01.ptr;
 	unsigned int i;
 
-	if (WARN_ON_ONCE(svm->vmcb != svm->nested.vmcb02.ptr))
+	if (WARN_ON_ONCE(svm->vmcb != vmcb02))
 		return;
 
-	vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
-
-	c = &svm->vmcb->control;
-	h = &svm->vmcb01.ptr->control;
-	g = &svm->nested.ctl;
+	vmcb_mark_dirty(vmcb02, VMCB_INTERCEPTS);
 
 	for (i = 0; i < MAX_INTERCEPT; i++)
-		c->intercepts[i] = h->intercepts[i];
+		vmcb02->control.intercepts[i] = vmcb01->control.intercepts[i];
 
-	if (g->int_ctl & V_INTR_MASKING_MASK) {
+	if (vmcb12_ctrl->int_ctl & V_INTR_MASKING_MASK) {
 		/*
 		 * If L2 is active and V_INTR_MASKING is enabled in vmcb12,
 		 * disable intercept of CR8 writes as L2's CR8 does not affect
@@ -151,9 +148,9 @@ void nested_vmcb02_recalc_intercepts(struct vcpu_svm *svm)
 		 * the effective RFLAGS.IF for L1 interrupts will never be set
 		 * while L2 is running (L2's RFLAGS.IF doesn't affect L1 IRQs).
 		 */
-		vmcb_clr_intercept(c, INTERCEPT_CR8_WRITE);
-		if (!(svm->vmcb01.ptr->save.rflags & X86_EFLAGS_IF))
-			vmcb_clr_intercept(c, INTERCEPT_VINTR);
+		vmcb_clr_intercept(&vmcb02->control, INTERCEPT_CR8_WRITE);
+		if (!(vmcb01->save.rflags & X86_EFLAGS_IF))
+			vmcb_clr_intercept(&vmcb02->control, INTERCEPT_VINTR);
 	}
 
 	/*
@@ -161,14 +158,14 @@ void nested_vmcb02_recalc_intercepts(struct vcpu_svm *svm)
 	 * flush feature is enabled.
 	 */
 	if (!nested_svm_l2_tlb_flush_enabled(&svm->vcpu))
-		vmcb_clr_intercept(c, INTERCEPT_VMMCALL);
+		vmcb_clr_intercept(&vmcb02->control, INTERCEPT_VMMCALL);
 
 	for (i = 0; i < MAX_INTERCEPT; i++)
-		c->intercepts[i] |= g->intercepts[i];
+		vmcb02->control.intercepts[i] |= vmcb12_ctrl->intercepts[i];
 
 	/* If SMI is not intercepted, ignore guest SMI intercept as well  */
 	if (!intercept_smi)
-		vmcb_clr_intercept(c, INTERCEPT_SMI);
+		vmcb_clr_intercept(&vmcb02->control, INTERCEPT_SMI);
 
 	if (nested_vmcb_needs_vls_intercept(svm)) {
 		/*
@@ -176,10 +173,10 @@ void nested_vmcb02_recalc_intercepts(struct vcpu_svm *svm)
 		 * we must intercept these instructions to correctly
 		 * emulate them in case L1 doesn't intercept them.
 		 */
-		vmcb_set_intercept(c, INTERCEPT_VMLOAD);
-		vmcb_set_intercept(c, INTERCEPT_VMSAVE);
+		vmcb_set_intercept(&vmcb02->control, INTERCEPT_VMLOAD);
+		vmcb_set_intercept(&vmcb02->control, INTERCEPT_VMSAVE);
 	} else {
-		WARN_ON(!(c->virt_ext & VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK));
+		WARN_ON_ONCE(!(vmcb02->control.virt_ext & VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK));
 	}
 }
 
-- 
2.53.0.345.g96ddfc5eaa-goog


