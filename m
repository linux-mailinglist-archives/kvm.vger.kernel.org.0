Return-Path: <kvm+bounces-30362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB00D9B9841
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 20:16:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 191481C218A2
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 19:16:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5C1E156880;
	Fri,  1 Nov 2024 19:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y/OQUvXV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABB21D0483
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 19:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730488502; cv=none; b=H5IA4ueXhaXOY2OLfHvQ+gCRg1oFAzcTJ7//wohNjQ9F6LfiLNOQTzWYhkTJvQ3EZUV7ZxsVRmEt4Fkd5CNKeZrCtq7EUBDiQaEoZMAEZM05GpmEAF6KX6Uhcki8Rn8m/v3HrEKgUHICwDsXfZvIuXOOA0trhQDmc5FLeZYdh6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730488502; c=relaxed/simple;
	bh=8JHdaYM0xXhzHuPv71pVBdeyV3cel6FJgdk6+9WWaVA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fP9b1HsVC9gCiJ2XmDJbhpd3wrTqsIXwtiU+sdT9YFiUEaEjsmb2HzCxyG3cZ2dYRfcFxsO1d3lI0WhVO1pus0ntSby/BjVFqzs1ak+o2QyW4BACbb7xs30I66r0wPTsoWSPsDLYBmWdy3XI1I96QsApgm1IlfI91LGFIN3lrC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y/OQUvXV; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e28fdb4f35fso4291600276.0
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 12:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730488500; x=1731093300; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wVNlWehVR99hr0dhSgfmMBMjHWaw56c/QaGVUiFdMnE=;
        b=y/OQUvXVmBoZpB9GM80tjlwh9YHuL9VajNcnKoRh7V9JIZOhEay3nC0EQHox0n03pL
         ivC95imijxI8qZS9vBuCndliju2eaXvBTzLqSHPdJzWWKkjmnccO81+w7kzZB2TW665I
         ibzXIpCodmYTkjt4e/6qWrcMUd/NJKLD3PEOwuGVJ3Gr3zkCukfLieRWH4uQ02uS4C6y
         evDDJSPAw5ynF7K0MSq5Md6fE/iCmAEvEp855k6lUMiaHpY1ctWBULrj+Aj0WN3aBgZL
         493IG2B8tK5st8XnXlYMz6TClqHwNj9aW5ZxWITwhbC+NOZwu6sJMqtJ6Bem4KwyF7iT
         IDFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730488500; x=1731093300;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wVNlWehVR99hr0dhSgfmMBMjHWaw56c/QaGVUiFdMnE=;
        b=lTVhyvzBu7I6nM5w1nvaZLjGk0PqDsoPQ6vsUucvhxVtGedlan1ckjNk3SOIfnq8NQ
         MOkZi15d2SG9kD7OzOL2PyOtNZCTn0CCpRVs4WRSyJleaP2H8MCHrsBX9VW+Vzuz+E5l
         jD7QaeRD0K3/HzWQu1XIZHPVLrl6xtrN2Vtm/TOV6T2Yk2Fc+4O01a8fjA2tYGYd8nAq
         l/pccSUM863cfB+P0fut+Hhx+rZj+6kJ32yBTg3qd80JU8nFFNvos0EcY6gUmwwm3jCa
         Nf/bAMs7KlEqqrEW8KWs9vcKABuawlck2NVVGbKCdu/rXCmd6nJy7GFXQfXhzNdG+tKv
         0inA==
X-Gm-Message-State: AOJu0YxjHSnn2T8G3dPsskTt7ihvTYRhj4O/2YDEk48u7O7skUVOMJTi
	KJpmTy7cQq0bhpgIM65Ft1vCsHIKbdjOHr3UFvLRE5tVOSQUH52usAt814UdUnLJFyNsJOUvICl
	WYA==
X-Google-Smtp-Source: AGHT+IE0pt6vhmwVNHvx7nlyxdB88wq01HOL2kongx16D3PnuLsTZ3nsV3jgWijzqVurWsp/OrsYYOQXUfE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:8241:0:b0:e29:7cfa:9fbc with SMTP id
 3f1490d57ef6-e30e5b678ffmr4451276.11.1730488500431; Fri, 01 Nov 2024 12:15:00
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  1 Nov 2024 12:14:47 -0700
In-Reply-To: <20241101191447.1807602-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241101191447.1807602-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241101191447.1807602-6-seanjc@google.com>
Subject: [PATCH 5/5] KVM: nVMX: Honor event priority when emulating PI
 delivery during VM-Enter
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"

Move the handling of a nested posted interrupt notification that is
unblocked by nested VM-Enter (unblocks L1 IRQs when ack-on-exit is enabled
by L1) from VM-Enter emulation to vmx_check_nested_events().  To avoid a
pointless forced immediate exit, i.e. to not regress IRQ delivery latency
when a nested posted interrupt is pending at VM-Enter, block processing of
the notification IRQ if and only if KVM must block _all_ events.  Unlike
injected events, KVM doesn't need to actually enter L2 before updating the
vIRR and vmcs02.GUEST_INTR_STATUS, as the resulting L2 IRQ will be blocked
by hardware itself, until VM-Enter to L2 completes.

Note, very strictly speaking, moving the IRQ from L2's PIR to IRR before
entering L2 is still technically wrong.  But, practically speaking, only a
userspace that is deliberately checking KVM_STATE_NESTED_RUN_PENDING
against PIR and IRR can even notice; L2 will see architecturally correct
behavior, as KVM ensure the VM-Enter is finished before doing anything
that would effectively preempt the PIR=>IRR movement.

Reported-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 53 ++++++++++++++++++++++++++++-----------
 1 file changed, 38 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0540faef0c85..0c6c0aeaddc2 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3725,14 +3725,6 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	if (unlikely(status != NVMX_VMENTRY_SUCCESS))
 		goto vmentry_failed;
 
-	/* Emulate processing of posted interrupts on VM-Enter. */
-	if (nested_cpu_has_posted_intr(vmcs12) &&
-	    kvm_apic_has_interrupt(vcpu) == vmx->nested.posted_intr_nv) {
-		vmx->nested.pi_pending = true;
-		kvm_make_request(KVM_REQ_EVENT, vcpu);
-		kvm_apic_clear_irr(vcpu, vmx->nested.posted_intr_nv);
-	}
-
 	/* Hide L1D cache contents from the nested guest.  */
 	vmx->vcpu.arch.l1tf_flush_l1d = true;
 
@@ -4194,13 +4186,25 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	 */
 	bool block_nested_exceptions = vmx->nested.nested_run_pending;
 	/*
-	 * New events (not exceptions) are only recognized at instruction
+	 * Events that don't require injection, i.e. that are virtualized by
+	 * hardware, aren't blocked by a pending VM-Enter as KVM doesn't need
+	 * to regain control in order to deliver the event, and hardware will
+	 * handle event ordering, e.g. with respect to injected exceptions.
+	 *
+	 * But, new events (not exceptions) are only recognized at instruction
 	 * boundaries.  If an event needs reinjection, then KVM is handling a
-	 * VM-Exit that occurred _during_ instruction execution; new events are
-	 * blocked until the instruction completes.
+	 * VM-Exit that occurred _during_ instruction execution; new events,
+	 * irrespective of whether or not they're injected, are blocked until
+	 * the instruction completes.
+	 */
+	bool block_non_injected_events = kvm_event_needs_reinjection(vcpu);
+	/*
+	 * Inject events are blocked by nested VM-Enter, as KVM is responsible
+	 * for managing priority between concurrent events, i.e. KVM needs to
+	 * wait until after VM-Enter completes to deliver injected events.
 	 */
 	bool block_nested_events = block_nested_exceptions ||
-				   kvm_event_needs_reinjection(vcpu);
+				   block_non_injected_events;
 
 	if (lapic_in_kernel(vcpu) &&
 		test_bit(KVM_APIC_INIT, &apic->pending_events)) {
@@ -4312,18 +4316,26 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	if (kvm_cpu_has_interrupt(vcpu) && !vmx_interrupt_blocked(vcpu)) {
 		int irq;
 
-		if (block_nested_events)
-			return -EBUSY;
-		if (!nested_exit_on_intr(vcpu))
+		if (!nested_exit_on_intr(vcpu)) {
+			if (block_nested_events)
+				return -EBUSY;
+
 			goto no_vmexit;
+		}
 
 		if (!nested_exit_intr_ack_set(vcpu)) {
+			if (block_nested_events)
+				return -EBUSY;
+
 			nested_vmx_vmexit(vcpu, EXIT_REASON_EXTERNAL_INTERRUPT, 0, 0);
 			return 0;
 		}
 
 		irq = kvm_cpu_get_extint(vcpu);
 		if (irq != -1) {
+			if (block_nested_events)
+				return -EBUSY;
+
 			nested_vmx_vmexit(vcpu, EXIT_REASON_EXTERNAL_INTERRUPT,
 					  INTR_INFO_VALID_MASK | INTR_TYPE_EXT_INTR | irq, 0);
 			return 0;
@@ -4342,11 +4354,22 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 		 * and enabling posted interrupts requires ACK-on-exit.
 		 */
 		if (irq == vmx->nested.posted_intr_nv) {
+			/*
+			 * Nested posted interrupts are delivered via RVI, i.e.
+			 * aren't injected by KVM, and so can be queued even if
+			 * manual event injection is disallowed.
+			 */
+			if (block_non_injected_events)
+				return -EBUSY;
+
 			vmx->nested.pi_pending = true;
 			kvm_apic_clear_irr(vcpu, irq);
 			goto no_vmexit;
 		}
 
+		if (block_nested_events)
+			return -EBUSY;
+
 		nested_vmx_vmexit(vcpu, EXIT_REASON_EXTERNAL_INTERRUPT,
 				  INTR_INFO_VALID_MASK | INTR_TYPE_EXT_INTR | irq, 0);
 
-- 
2.47.0.163.g1226f6d8fa-goog


