Return-Path: <kvm+bounces-67821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C1221D14BB1
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 19:21:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8AD5230208D8
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:21:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 469FF387583;
	Mon, 12 Jan 2026 18:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ej8RGT+X"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAE437E313
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 18:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768242065; cv=none; b=cH96B1XLXLGwyUZKa6G0fXsGDSdp/VbYi6SaMvShy8nTz3sO/jbNCnzNZ2j3T/R/S4PCwfuirN7xDCM0P33Rd8jkGxKV9EjqLWx1sMFsZgEZClxQwmeWauCMAu7uVJ9XpiYCC96SH+KjUOd02aXFqMdmxvC4CsA7BBel5HGw/XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768242065; c=relaxed/simple;
	bh=ZP1mn4bHwR4r+xJXujbptyJ8W9fs/jT+5blROmqFZ9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYxEYo/Lf7hsLb/0HdEDxK9VbRpXyK8Jk08G9S34A3LEG7psCduWYxEQaIt2mmSGoHjOOXsLQKHk/bS6sKO/wVC8RIPdIFTuXb/8CBObKcOlVXH04xkuVgHUU5vmUtmqo7W0o1fcIn7SKZQva1CqS6fNXrRyFoTO3UI34i1171I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ej8RGT+X; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768242061;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Du2Y150Cd0hwJwMYNN9fKh2HDvkLWVWAy3LstWCtYd0=;
	b=ej8RGT+XKWGizg8YJY+b6wewqOWgbXcGFLKRby9HgmJs9zQnooxSB4gUpdrmf3txcdQhJm
	NtbNW8WOdJk3xezY6CT49mA9zSIIBJ3CeYlMu/+kpm3JCsD1S4mQ34VUzutOdeHAxgOkkT
	9GhwHjSFztH1WeCkFpMlCotV+nDnV9w=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Kevin Cheng <chengkev@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 1/3] KVM: nSVM: Use intuitive local variables in recalc_intercepts()
Date: Mon, 12 Jan 2026 18:20:20 +0000
Message-ID: <20260112182022.771276-2-yosry.ahmed@linux.dev>
In-Reply-To: <20260112182022.771276-1-yosry.ahmed@linux.dev>
References: <20260112182022.771276-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

recalc_intercepts() currently uses c, h, g as local variables for the
control area of the current VMCB, vmcb01, and (cached) vmcb12.

The current VMCB should always be vmcb02 when recalc_intercepts() is
executed in guest mode. Use vmcb01/vmcb02 local variables instead to
make it clear the function is updating intercepts in vmcb02 based on the
intercepts in vmcb01 and (cached) vmcb12.

Add a WARNING() if the current VMCB is not in fact vmcb02.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index f295a41ec659..2dda52221fd8 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -125,8 +125,7 @@ static bool nested_vmcb_needs_vls_intercept(struct vcpu_svm *svm)
 
 void recalc_intercepts(struct vcpu_svm *svm)
 {
-	struct vmcb_control_area *c, *h;
-	struct vmcb_ctrl_area_cached *g;
+	struct vmcb *vmcb01, *vmcb02;
 	unsigned int i;
 
 	vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
@@ -134,14 +133,14 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	if (!is_guest_mode(&svm->vcpu))
 		return;
 
-	c = &svm->vmcb->control;
-	h = &svm->vmcb01.ptr->control;
-	g = &svm->nested.ctl;
+	vmcb01 = svm->vmcb01.ptr;
+	vmcb02 = svm->nested.vmcb02.ptr;
+	WARN_ON_ONCE(svm->vmcb != vmcb02);
 
 	for (i = 0; i < MAX_INTERCEPT; i++)
-		c->intercepts[i] = h->intercepts[i];
+		vmcb02->control.intercepts[i] = vmcb01->control.intercepts[i];
 
-	if (g->int_ctl & V_INTR_MASKING_MASK) {
+	if (svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK) {
 		/*
 		 * If L2 is active and V_INTR_MASKING is enabled in vmcb12,
 		 * disable intercept of CR8 writes as L2's CR8 does not affect
@@ -152,9 +151,9 @@ void recalc_intercepts(struct vcpu_svm *svm)
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
@@ -162,14 +161,14 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	 * flush feature is enabled.
 	 */
 	if (!nested_svm_l2_tlb_flush_enabled(&svm->vcpu))
-		vmcb_clr_intercept(c, INTERCEPT_VMMCALL);
+		vmcb_clr_intercept(&vmcb02->control, INTERCEPT_VMMCALL);
 
 	for (i = 0; i < MAX_INTERCEPT; i++)
-		c->intercepts[i] |= g->intercepts[i];
+		vmcb02->control.intercepts[i] |= svm->nested.ctl.intercepts[i];
 
 	/* If SMI is not intercepted, ignore guest SMI intercept as well  */
 	if (!intercept_smi)
-		vmcb_clr_intercept(c, INTERCEPT_SMI);
+		vmcb_clr_intercept(&vmcb02->control, INTERCEPT_SMI);
 
 	if (nested_vmcb_needs_vls_intercept(svm)) {
 		/*
@@ -177,10 +176,10 @@ void recalc_intercepts(struct vcpu_svm *svm)
 		 * we must intercept these instructions to correctly
 		 * emulate them in case L1 doesn't intercept them.
 		 */
-		vmcb_set_intercept(c, INTERCEPT_VMLOAD);
-		vmcb_set_intercept(c, INTERCEPT_VMSAVE);
+		vmcb_set_intercept(&vmcb02->control, INTERCEPT_VMLOAD);
+		vmcb_set_intercept(&vmcb02->control, INTERCEPT_VMSAVE);
 	} else {
-		WARN_ON(!(c->virt_ext & VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK));
+		WARN_ON(!(vmcb02->control.virt_ext & VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK));
 	}
 }
 
-- 
2.52.0.457.g6b5491de43-goog


