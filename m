Return-Path: <kvm+bounces-37288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EAEBA2816D
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 02:44:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1ED023A92D2
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 01:43:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C94E2288C5;
	Wed,  5 Feb 2025 01:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X4fn+Se+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4ED227BB8
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 01:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738719699; cv=none; b=uI8CUcbbUL2zAJwxwOi09hGHRfDo4ajFFNdWpEpuxd8eIa6qS4/UUkx7+1siWzLiON3GjRK3PhsGc9rs7fcg3CCxrmY1DlsQLSg8UddjCf7Da5kXGfbKvA5Zc6K4B3Fe/W7dopxESu1wIa+CPuKRCFbWOgSo3Y/6W7Zn1ow0fNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738719699; c=relaxed/simple;
	bh=Tb2WaHEHFwzAs4T1sx5XIMYGRmP6vmWFLXZFt6q5Swk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=vAu02kM5aoThT8OZ1kIJd6pJNb19gRGkuqTAdJeTUsIVGqKRQ/3jJ2goR0EmOPsaZ7bzGUDHVdCqS2lkO2OHXgMURETaacVW+7QbCbYrY6cHvEPBUTGQCuq6Eh9VhIr/nR9rY/gU5PE+U0GFWhgILPc/jOSKzwwPpvWn2vK2tbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X4fn+Se+; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-21f078fc592so30836875ad.1
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 17:41:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738719697; x=1739324497; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aMcwH0dfJdlpEM9pbdRVBP81ygSQBPCgeU60/Kv7+9A=;
        b=X4fn+Se+BKkh3ywXSko76Gn5GNPwi1tXrjJCn4dlX81f6rGZcZvAjmyfb1tGbrSWwb
         56VtEDu/l7R0F+Rt+oOy31Q6UWvH7hRDgspUcT53S/ZaNEdFT0wubsYw0kezBry8692c
         MN745JAgbWp5TU2oxgqz6wxkvbanjaRaZsaCiCEtPi+fmL1VowOuAUAVEGg3JLKmiL0j
         S2zQVu3U2LMYcivbD2gKDAmI6uvy1XauoIng+Jll4TZQz3nIX85HiizCxwEElDYnMLcO
         qdDIuA5U8wA6wEgcigxqksTtg8JnZmpOvZF8m0LgqjRZVSpJ/PHlexYnnrKkeYAUS3LO
         1Bjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738719697; x=1739324497;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aMcwH0dfJdlpEM9pbdRVBP81ygSQBPCgeU60/Kv7+9A=;
        b=IbsxyedRZueSPGF4K/udSkX/Sq8UfJZnCyneWLJokHAKkSTeS8rQ0qVJn0Wufr0I6Q
         QRSIZJTVij0b8yVU/5b3oMK2dfX2AHyI5ICLRRyu7JQDbthc27qHMlQwl1cbdOvPPPDj
         02/iEwrQdRq9fmJaP7IVAg3s7KVYKQPIMf8nBs6KareeSlaFWhmYHxUXZN16C/T3VtYB
         /Ccw/WH63y7wpe6yAk9UTl/z6t6YBN5PbUgSJQbR9FJ3BxVZnx5poS4QP5Yx4M0Td1Ez
         mjlCuFnPLd4lB+8EF1Y8P3cOuI5yEERq7exTomQdVKfd2nKhPrx15DQRSdDcsR4UmIUm
         xtow==
X-Forwarded-Encrypted: i=1; AJvYcCWtUg3HJVo3AhnKoC67B+nQtgul42etmRuvfAxGvZbQ9aLzugkVECXmDy3fHDrnhbEo5BM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyV477tqFukm+ocaMPA4e1XZnz8LVBppfubKA1jFiwaDptj/htq
	M+nTNC7FP8JCgEs1bP5FkHaULWX5if9ehMB5nlMfc38BtY4yhmVUYD/NZxZHE7UmGk4Mni6ymLX
	EpA==
X-Google-Smtp-Source: AGHT+IGWTQgbxegWAxVPtwHAdbzjMrSnpovALW55MZwtzCV4YyX0l80BYBIxbu8boYEJ6RSMxrj2MH0Ki/E=
X-Received: from pfbhm14.prod.google.com ([2002:a05:6a00:670e:b0:725:ceac:b484])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:9e46:b0:1ed:a565:f80e
 with SMTP id adf61e73a8af0-1ede88367e0mr1652080637.14.1738719696957; Tue, 04
 Feb 2025 17:41:36 -0800 (PST)
Date: Tue, 4 Feb 2025 17:41:35 -0800
In-Reply-To: <2c9ffa51b82b4ae75e803d5b30bf74eda9350686.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1738595289.git.naveen@kernel.org> <405a98c2f21b9fe73eddbc35c80b60d6523db70c.1738595289.git.naveen@kernel.org>
 <Z6EOxxZA9XLdXvrA@google.com> <60cef3e4-8e94-4cf1-92ae-34089e78a82d@redhat.com>
 <Z6FVaLOsPqmAPNWu@google.com> <0e4bd3004d97b145037c36c785c19e97b6995d42.camel@redhat.com>
 <Z6JoInXNntIoHLQ8@google.com> <2c9ffa51b82b4ae75e803d5b30bf74eda9350686.camel@redhat.com>
Message-ID: <Z6LBz69oVI5qUGFW@google.com>
Subject: Re: [PATCH 3/3] KVM: x86: Decouple APICv activation state from apicv_inhibit_reasons
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "Naveen N Rao (AMD)" <naveen@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 04, 2025, Maxim Levitsky wrote:
> On Tue, 2025-02-04 at 11:18 -0800, Sean Christopherson wrote:
> > On Mon, Feb 03, 2025, Maxim Levitsky wrote:
> > @@ -3219,20 +3228,6 @@ static int interrupt_window_interception(struct kvm_vcpu *vcpu)
> >  	kvm_make_request(KVM_REQ_EVENT, vcpu);
> >  	svm_clear_vintr(to_svm(vcpu));
> >  
> > -	/*
> > -	 * If not running nested, for AVIC, the only reason to end up here is ExtINTs.
> > -	 * In this case AVIC was temporarily disabled for
> > -	 * requesting the IRQ window and we have to re-enable it.
> > -	 *
> > -	 * If running nested, still remove the VM wide AVIC inhibit to
> > -	 * support case in which the interrupt window was requested when the
> > -	 * vCPU was not running nested.
> > -
> > -	 * All vCPUs which run still run nested, will remain to have their
> > -	 * AVIC still inhibited due to per-cpu AVIC inhibition.
> > -	 */
> 
> Please keep these comment that explain why inhibit has to be cleared here,

Ya, I'll make sure there are good comments that capture everything before posting
anything.

> and the code as well.
> 
> The reason is that IRQ window can be requested before nested entry, which
> will lead to VM wide inhibit, and the interrupt window can happen while
> nested because nested hypervisor can opt to not intercept interrupts. If that
> happens, the AVIC will remain inhibited forever.

Ah, because the svm_clear_vintr() triggered by enter_svm_guest_mode()'s

	svm_set_gif(svm, true);

will occur in_guest_mode() == true.  But doesn't that bug exist today?  Clearing
the inhibit relies on interrupt_window_interception() being reached, and so if
the ExtInt is injected into L2, KVM will never reach interrupt_window_interception().

KVM will evaluate pending events in that case:

		    svm->vcpu.arch.nmi_pending ||
		    kvm_cpu_has_injectable_intr(&svm->vcpu) ||
		    kvm_apic_has_pending_init_or_sipi(&svm->vcpu))
			kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);

but the nested pending VMRUN will block events and not get to the point where
KVM enables an IRQ window:

		r = can_inject ? kvm_x86_call(interrupt_allowed)(vcpu, true) :
				 -EBUSY;
		if (r < 0)
			goto out; <======= Taken for nested VMRUN pending
		if (r) {
			int irq = kvm_cpu_get_interrupt(vcpu);

			if (!WARN_ON_ONCE(irq == -1)) {
				kvm_queue_interrupt(vcpu, irq, false);
				kvm_x86_call(inject_irq)(vcpu, false);
				WARN_ON(kvm_x86_call(interrupt_allowed)(vcpu, true) < 0);
			}
		}
		if (kvm_cpu_has_injectable_intr(vcpu))
			kvm_x86_call(enable_irq_window)(vcpu);

and if L2 has IRQs enabled, the subsequent KVM_REQ_EVENT processing after the
immediate exit will inject into L2, without re-opening a window and thus without
triggering interrupt_window_interception().

Ha!  I was going to suggest hooking svm_leave_nested(), and lo and behold KVM
already does that for KVM_REQ_APICV_UPDATE to ensure it has an up-to-date view
of the inhibits.

After much staring, I suspect the reason KVM hooks interrupt_window_interception()
and not svm_clear_vintr() is to avoid thrashing the inhibit and thus the VM-wide
lock/state on nested entry/exit, e.g. on a typical:

	gif=0 => VMRUN => gif=1 => #VMEXIT => gif=0

sequence, KVM would clear the inhibit while running L2, and then re-enable the
inhibit when control transers back to L1.  But that doesn't gel with this comment
in interrupt_window_interception():

	* If running nested, still remove the VM wide AVIC inhibit to
	* support case in which the interrupt window was requested when the
	* vCPU was not running nested.

That code/comment exists specifically for the case where L1 is not intercepting
IRQs, and so KVM is effectively using V_IRQ in vmcb02 to detect interrupt windows
for L1 IRQs.

If L1 _is_ intercepting IRQs, then interrupt_window_interception() will never be
reached while L2 is active, because the only reason KVM would set the V_IRQ intercept
in vmcb02 would be on behalf of L1, i.e. because of vmcs12.  svm_clear_vintr()
always operates on (at least) vmcb01, and VMRUN unconditionally sets GIF=1, which
means that enter_svm_guest_mode() will always do svm_clear_vintr() via
svm_set_gif(svm, true).  I.e. KVM will keep the VM-wide inhibit set until control
transfers back to L1 *and* an interrupt window is triggered.

Even the "L1 doesn't intercept IRQs" case is incongruous, because if IRQs are
enabled in L2 at the time of VMRUN, KVM will immediately inject L1's ExtINT into
L2 without taking an interrupt window #VMEXIT.

I don't see a perfect solution.  Barring a rather absurd number of checks, KVM
will inevitably leave the VM-wide inhibit in place while running L2, or KVM will
risk thrashing the VM-wide inhibit across VMRUN.

/facepalm

It's still not perfect, but the obvious-in-hindsight answer is to clear the
IRQ window inhibit when KVM actually injects an interrupt and there's no longer
a injectable interrupt.

That optimizes all the paths: if L1 isn't intercept IRQs, KVM will drop the
inhibit as soon as an interrupt is injected into L2.  If L1 is intercepting IRQs,
KVM will keep the inhibit until the IRQ is injected into L2.  Unless I'm missing
something, the inhibit itself should prevent an injectable IRQ from disappearing,
i.e. AVIC won't be left inhibited.

So this for the SVM changes?

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7640a84e554a..2a5cf7029b26 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3219,20 +3219,6 @@ static int interrupt_window_interception(struct kvm_vcpu *vcpu)
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 	svm_clear_vintr(to_svm(vcpu));
 
-	/*
-	 * If not running nested, for AVIC, the only reason to end up here is ExtINTs.
-	 * In this case AVIC was temporarily disabled for
-	 * requesting the IRQ window and we have to re-enable it.
-	 *
-	 * If running nested, still remove the VM wide AVIC inhibit to
-	 * support case in which the interrupt window was requested when the
-	 * vCPU was not running nested.
-
-	 * All vCPUs which run still run nested, will remain to have their
-	 * AVIC still inhibited due to per-cpu AVIC inhibition.
-	 */
-	kvm_clear_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_IRQWIN);
-
 	++vcpu->stat.irq_window_exits;
 	return 1;
 }
@@ -3670,6 +3656,23 @@ static void svm_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 type;
 
+	/*
+	 * If AVIC was inhibited in order to detect an IRQ window, and there's
+	 * no other injectable interrupts pending or L2 is active (see below),
+	 * then drop the inhibit as the window has served its purpose.
+	 *
+	 * If L2 is active, this path is reachable if L1 is not intercepting
+	 * IRQs, i.e. if KVM is injecting L1 IRQs into L2.  AVIC is locally
+	 * inhibited while L2 is active; drop the VM-wide inhibit to optimize
+	 * the case in which the interrupt window was requested while L1 was
+	 * active (the vCPU was not running nested).
+	 */
+	if (svm->avic_irq_window &&
+	    (!kvm_cpu_has_injectable_intr(vcpu) || is_guest_mode(vcpu))) {
+		svm->avic_irq_window = false;
+		kvm_dec_apicv_irq_window(svm->vcpu.kvm);
+	}
+
 	if (vcpu->arch.interrupt.soft) {
 		if (svm_update_soft_interrupt_rip(vcpu))
 			return;
@@ -3881,17 +3884,28 @@ static void svm_enable_irq_window(struct kvm_vcpu *vcpu)
 	 */
 	if (vgif || gif_set(svm)) {
 		/*
-		 * IRQ window is not needed when AVIC is enabled,
-		 * unless we have pending ExtINT since it cannot be injected
-		 * via AVIC. In such case, KVM needs to temporarily disable AVIC,
-		 * and fallback to injecting IRQ via V_IRQ.
+		 * KVM only enables IRQ windows when AVIC is enabled if there's
+		 * pending ExtINT since it cannot be injected via AVIC (ExtINT
+		 * bypasses the local APIC).  V_IRQ is ignored by hardware when
+		 * AVIC is enabled, and so KVM needs to temporarily disable
+		 * AVIC in order to detect when it's ok to inject the ExtINT.
 		 *
-		 * If running nested, AVIC is already locally inhibited
-		 * on this vCPU, therefore there is no need to request
-		 * the VM wide AVIC inhibition.
+		 * If running nested, AVIC is already locally inhibited on this
+		 * vCPU (L2 vCPUs use a different MMU that never maps the AVIC
+		 * backing page), therefore there is no need to increment the
+		 * VM-wide AVIC inhibit.  KVM will re-evaluate events when the
+		 * vCPU exits to L1 and enable an IRQ window if the ExtINT is
+		 * still pending.
+		 *
+		 * Note, the IRQ window inhibit needs to be updated even if
+		 * AVIC is inhibited for a different reason, as KVM needs to
+		 * keep AVIC inhibited if the other reason is cleared and there
+		 * is still an injectable interrupt pending.
 		 */
-		if (!is_guest_mode(vcpu))
-			kvm_set_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_IRQWIN);
+		if (enable_apicv && !svm->avic_irq_window && !is_guest_mode(vcpu)) {
+			svm->avic_irq_window = true;
+			kvm_inc_apicv_irq_window(vcpu->kvm);
+		}
 
 		svm_set_vintr(svm);
 	}

