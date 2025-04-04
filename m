Return-Path: <kvm+bounces-42709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CCA60A7C462
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 22:00:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55C203AAE11
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:57:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24C6A22A7E8;
	Fri,  4 Apr 2025 19:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hAxT7ZHf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A299C22A1C5
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795629; cv=none; b=ocM17O/Ei+bPqw/lgUZP8ozWQd4lqa5E2c9pkqImwFIcV99HXESADf+cKv02NMsoadAP1eYvNuV+aPIVKegLBCQ6FxV98Uf85O44yqGR9F7BBREXVDN7UBv/b2G55NjyI2fPUmy+bjeWc1Ko6Iukft3uloM4kbKlamO6OE96Cxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795629; c=relaxed/simple;
	bh=gWYzHGiCCpynm45E+mo9zGhawwFX+0w4rciPYVdijpk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C32L/abrvsFVOF1LPwRpWDzsjSzQLakqeMYLQGv6Muf6hJEhKbtA5laEXVHahJeZnO/M48QepCuk0a+eIxPXgj3wlirgvvokSYlBYDlwc7/I1Go8ovbiYM8e1PemJEwQf4/wMzS1A5/pV3t8lLSiRmyazVTqKxaXoEB6xs/UiSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hAxT7ZHf; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-736a7d0b82fso2991956b3a.1
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795627; x=1744400427; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0lUzTUillvMMJvhugb+YDr3wCuyyvIR5aJ56lReG+IQ=;
        b=hAxT7ZHfmuKQI07JLu9HawDR6cShos1idFMF1aSCFblsa6J+ZYnNV+V7jarW4ggIdm
         OOxbK8PRKWhgDJy7MfGnRpxHHHumBZ5s6+P3EjZ8BjvM3cFvbaXqgnx8wUztouBL8tvt
         v14PVfefzBDX9SB296vJmk61juCce/dBaSYpn09HMmxawKjaACH0jPbjo8mZQGklFywD
         5ltgPSRedAu5SjWT/TfAObnQFukT6NbRMqit1b/DFeiEK35dHNBHjCoP0DoPgq7yx797
         HGymLQeWzqSauWrXzfofnmlsIEBNqjOteYNek2wgoMnlNrapx448EFo3QPoRpqJ2DeML
         B2+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795627; x=1744400427;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0lUzTUillvMMJvhugb+YDr3wCuyyvIR5aJ56lReG+IQ=;
        b=v/kaZ+TmFksK9d5LoDXJMnKFLGQtoP7686r4z9ncxwXLmaLZGAbGJxxeVhoUWZU5O5
         Wxm81kWGSoQwaXsQYUpt9J8r0PQsrsiWxrJgh00jRnGSlgLuWfCjALSXA/nEnk359YRu
         o+t4iScuSJkGZ/9sjj5szAXc33iy4k/ZR9DdVb40DQsS7w+f86fnZwy3fhGLyKqI0YIF
         0oA0cWBYkKKXCqNm41Fj/26Qs2U1RrFmGtQSGG4xgHCFJz8HcBx9/NvYSKVyI490Idd3
         0Toz/B4qhnLTFmEcgiqES2ExTQ/SN8EMc7Dg42JZPLDSkTi44IF+OLOPAHSQhEu4iEVX
         4HxA==
X-Gm-Message-State: AOJu0YwaeCu98FGJptIytQIpHFwcEVH3adAxIxn9VaBuKOlTKcf1HFht
	ln69NjFoQrbzcTzYW0TQaMdfLjXxom1PHzCzggcpjLwmuljSvZCyTQFhyHkBB06GlMN8y7UR9ww
	1iQ==
X-Google-Smtp-Source: AGHT+IFzppEVq+Fwd1V/1T9ksyQMe/xxnCf7osfKT4Gx98SbS26q4xCE/xkKDFomooyIE6RxvAG1qp7KzN4=
X-Received: from pgac11.prod.google.com ([2002:a05:6a02:294b:b0:af9:5602:ea50])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3116:b0:1f5:8c86:5e2f
 with SMTP id adf61e73a8af0-20108188bdemr5973192637.37.1743795626887; Fri, 04
 Apr 2025 12:40:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:38:38 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-24-seanjc@google.com>
Subject: [PATCH 23/67] KVM: VMX: Suppress PI notifications whenever the vCPU
 is put
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Suppress posted interrupt notifications (set PID.SN=1) whenever the vCPU
is put, i.e. unloaded, not just when the vCPU is preempted, as KVM doesn't
do anything in response to a notification IRQ that arrives in the host,
nor does KVM rely on the Outstanding Notification (PID.ON) flag when the
vCPU is unloaded.  And, the cost of scanning the PIR to manually set PID.ON
when loading the vCPU is quite small, especially relative to the cost of
loading (and unloading) a vCPU.

On the flip side, leaving SN clear means a notification for the vCPU will
result in a spurious IRQ for the pCPU, even if vCPU task is scheduled out,
running in userspace, etc.  Even worse, if the pCPU is running a different
vCPU, the spurious IRQ could trigger posted interrupt processing for the
wrong vCPU, which is technically a violation of the architecture, as
setting bits in PIR aren't supposed to be propagated to the vIRR until a
notification IRQ is received.

The saving grace of the current behavior is that hardware sends
notification interrupts if and only if PID.ON=0, i.e. only the first
posted interrupt for a vCPU will trigger a spurious IRQ (for each window
where the vCPU is unloaded).

Ideally, KVM would suppress notifications before enabling IRQs in the
VM-Exit, but KVM relies on PID.ON as an indicator that there is a posted
interrupt pending in PIR, e.g. in vmx_sync_pir_to_irr(), and sadly there
is no way to ask hardware to set PID.ON, but not generate an interrupt.
That could be solved by using pi_has_pending_interrupt() instead of
checking only PID.ON, but it's not at all clear that would be a performance
win, as KVM would end up scanning the entire PIR whenever an interrupt
isn't pending.

And long term, the spurious IRQ window, i.e. where a vCPU is loaded with
IRQs enabled, can effectively be made smaller for hot paths by moving
performance critical VM-Exit handlers into the fastpath, i.e. by never
enabling IRQs for hot path VM-Exits.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 1b6b655a2b8a..00818ca30ee0 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -70,13 +70,10 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 	/*
 	 * If the vCPU wasn't on the wakeup list and wasn't migrated, then the
 	 * full update can be skipped as neither the vector nor the destination
-	 * needs to be changed.
+	 * needs to be changed.  Clear SN even if there is no assigned device,
+	 * again for simplicity.
 	 */
 	if (pi_desc->nv != POSTED_INTR_WAKEUP_VECTOR && vcpu->cpu == cpu) {
-		/*
-		 * Clear SN if it was set due to being preempted.  Again, do
-		 * this even if there is no assigned device for simplicity.
-		 */
 		if (pi_test_and_clear_sn(pi_desc))
 			goto after_clear_sn;
 		return;
@@ -200,15 +197,22 @@ void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
 	if (!vmx_needs_pi_wakeup(vcpu))
 		return;
 
-	if (kvm_vcpu_is_blocking(vcpu) && !vmx_interrupt_blocked(vcpu))
+	/*
+	 * If the vCPU is blocking with IRQs enabled and ISN'T being preempted,
+	 * enable the wakeup handler so that notification IRQ wakes the vCPU as
+	 * expected.  There is no need to enable the wakeup handler if the vCPU
+	 * is preempted between setting its wait state and manually scheduling
+	 * out, as the task is still runnable, i.e. doesn't need a wake event
+	 * from KVM to be scheduled in.
+	 *
+	 * If the wakeup handler isn't being enabled, Suppress Notifications as
+	 * the cost of propagating PIR.IRR to PID.ON is negligible compared to
+	 * the cost of a spurious IRQ, and vCPU put/load is a slow path.
+	 */
+	if (!vcpu->preempted && kvm_vcpu_is_blocking(vcpu) &&
+	    !vmx_interrupt_blocked(vcpu))
 		pi_enable_wakeup_handler(vcpu);
-
-	/*
-	 * Set SN when the vCPU is preempted.  Note, the vCPU can both be seen
-	 * as blocking and preempted, e.g. if it's preempted between setting
-	 * its wait state and manually scheduling out.
-	 */
-	if (vcpu->preempted)
+	else
 		pi_set_sn(pi_desc);
 }
 
-- 
2.49.0.504.g3bcea36a83-goog


