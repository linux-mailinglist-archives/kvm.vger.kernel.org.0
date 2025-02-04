Return-Path: <kvm+bounces-37267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 13CC0A27B09
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 20:19:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B92DD18856A4
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 19:19:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BC7D2147E9;
	Tue,  4 Feb 2025 19:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EglBLY1Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9841016D4E6
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 19:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738696742; cv=none; b=bqpp8EpKkne3x7LK2JJgS14Jx7+qoZdvM4TLEQ4kT9JI3KX4UmUlvGMIPUUqfhlM4RozV9Y9q4dJ/sbwtXscwoRpQR+tPFIM2yj5ZfQ0NHPJ056wPNPekQN5a3+AeGVP+0tMfc4H9Y8NQJpZsswPnpmiIu7CuepyULnwTISKauI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738696742; c=relaxed/simple;
	bh=lOQLHtQj/JlpjsmMUI9tNB9bCywRQo4V2JTymx3Z+1I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WUnR0z82w8GvqkoweQ/R2HFvh7UVb1jjn1IZ/VebnNMzIt9O/+1YbbjywhR3Cgkhd4iaZ89bpgT3ne2dB0gv0uJo84ThVtJxg3FvjitQXX/KrK6A7tnNRLVN7B7BHBCvgObK0EsGivp8RqYXUp4dc1hSlhfBePosG30e1rJhtF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EglBLY1Y; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2166e907b5eso109970735ad.3
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 11:19:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738696740; x=1739301540; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nzxRqpvcvtrbdnuWIOgPz6eoM0dD5NueC1ZNlW4Cw2s=;
        b=EglBLY1YIxP3Swc8/S7CeIFps2fV0CnnIXvYRcTbH/JFU/gJWim96lANgk+8xDkBSj
         NqN7ppaD6yu4pa08sCbVJm+gEWvQBjFJcUGunVwWOI+HFQ9Y4lkpozo9WnTaTKxOX24o
         43jM8SdRKJx83DoZiO53OBZDDbriEJ1p26ItVDPjoChXzLtJuFVsn6HArUNaLAzIK4du
         SIR1a03x3mm6ZL39dhfp/Z1CncKpJjZN3es12BrJ5bbcH31DMsXxomzii3eYt6fDoQvg
         LcKT4gflsIcHF0S17oejGOr8TJI4odubU6VmWNhnjgkR2TCJRdIm8mFpBYTuTP+g1ahS
         vfcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738696740; x=1739301540;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nzxRqpvcvtrbdnuWIOgPz6eoM0dD5NueC1ZNlW4Cw2s=;
        b=t3YSxodLH2dcYBTbh4uc4kVgbHJnWMvHzXLvzL1jPussiJ9Mt4aqpVt9PrUdSMLVSW
         U9B7Zrl4hHm7UjuTSgzPa4ALzUm+6GS3CJ1p9g29u02UADQfIIl2QkF3Ex59ryC4RZ+f
         shUXxebwzAx9+nXX+/1QRAUm8odb9Fk8yuR3bIKLz3YOh09/HZHX1RtqTYd15iRcxX+r
         63GF4mqkCkXQwC/E9INYRZa8jv0bQjMnTGUdKeQYe+pPnI+b4o6WsbVkk93/h2PzzYYA
         3UBhhBL5Z3Qd1F8LM4Lh5tsETYjBI8iDDBSHOnJ8uwsD47nMbZJsRq8w2gXRGYtfMZ6P
         h9fQ==
X-Forwarded-Encrypted: i=1; AJvYcCUhT4W11eGcq49tgye9v4OOcqu9P/RcY189ZGSL3ic4vheEyQyz47dt4/+OE/uXK53MbgY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNN0thOUTcKw7Rfl3Adiile+uXA3E3/3GZ9Pr9uPw+p2WuYYHs
	es+shSTKX1yJRUu5G2KJCegEXPGKZkPnwC6xAUjCJo39kchHbW0SCo3Tj7oIaJsueB3M3GDR9XP
	PSw==
X-Google-Smtp-Source: AGHT+IEi4ni+Mk+VPfa1hVTlI2WFVK+gZGe3078VPe3rvQQIzXG4DD8F1plqdvPf4L2N36WOzBK/v0j2mTs=
X-Received: from pfbhb40.prod.google.com ([2002:a05:6a00:85a8:b0:72d:261f:af23])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6b02:b0:1e1:1d7c:4cff
 with SMTP id adf61e73a8af0-1ed7a6e09a7mr49181477637.37.1738696739842; Tue, 04
 Feb 2025 11:18:59 -0800 (PST)
Date: Tue, 4 Feb 2025 11:18:58 -0800
In-Reply-To: <0e4bd3004d97b145037c36c785c19e97b6995d42.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1738595289.git.naveen@kernel.org> <405a98c2f21b9fe73eddbc35c80b60d6523db70c.1738595289.git.naveen@kernel.org>
 <Z6EOxxZA9XLdXvrA@google.com> <60cef3e4-8e94-4cf1-92ae-34089e78a82d@redhat.com>
 <Z6FVaLOsPqmAPNWu@google.com> <0e4bd3004d97b145037c36c785c19e97b6995d42.camel@redhat.com>
Message-ID: <Z6JoInXNntIoHLQ8@google.com>
Subject: Re: [PATCH 3/3] KVM: x86: Decouple APICv activation state from apicv_inhibit_reasons
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "Naveen N Rao (AMD)" <naveen@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 03, 2025, Maxim Levitsky wrote:
> On Mon, 2025-02-03 at 15:46 -0800, Sean Christopherson wrote:
> > On Mon, Feb 03, 2025, Paolo Bonzini wrote:
> > > On 2/3/25 19:45, Sean Christopherson wrote:
> > > > Unless there's a very, very good reason to support a use case that generates
> > > > ExtInts during boot, but _only_ during boot, and otherwise doesn't have any APICv
> > > > ihibits, I'm leaning towards making SVM's IRQ window inhibit sticky, i.e. never
> > > > clear it.
> > > 
> > > BIOS tends to use PIT, so that may be too much.  With respect to Naveen's report
> > > of contention on apicv_update_lock, I would go with the sticky-bit idea but apply
> > > it to APICV_INHIBIT_REASON_PIT_REINJ.
> > 
> > That won't work, at least not with yet more changes, because KVM creates the
> > in-kernel PIT with reinjection enabled by default.  The stick-bit idea is that
> > if a bit is set and can never be cleared, then there's no need to track new
> > updates.  Since userspace needs to explicitly disable reinjection, the inhibit
> > can't be sticky.
> I confirmed this with a trace, this is indeed the case.
> 
> > 
> > I assume We could fudge around that easily enough by deferring the inhibit until
> > a vCPU is created (or run?), but piggybacking PIT_REINJ won't help the userspace
> > I/O APIC case.
> > 
> > > I don't love adding another inhibit reason but, together, these two should
> > > remove the contention on apicv_update_lock.  Another idea could be to move
> > > IRQWIN to per-vCPU reason but Maxim tells me that it's not so easy.
> 
> I retract this statement, it was based on my knowledge from back when I
> implemented it.
> 
> Looking at the current code again, this should be possible and can be a nice
> cleanup regardless.
> 
> (Or I just might have forgotten the reason that made me think back then that
> this is not worth it, because I do remember well that I wanted to make IRQWIN
> inhibit to be per vcpu)

The complication is the APIC page.  That's not a problem for vCPUs running in L2
because they'll use a different MMU, i.e. a different set of SPTEs that never map
the APIC backing page.  At least, that's how it's supposed to work[*].  ;-)

For IRQWIN, turning off APICv for the current vCPU will leave the APIC SPTEs in
place and so KVM will fail to intercept accesses to the APIC page.  And making
IRQWIN a per-vCPU inhibit won't help performance in the case where there is no
other inhibit, because (a) toggling it on/off requires taking mmu_lock for writing
and doing a remote TLB flush, and (b) unless the guest is doing something bizarre,
only one vCPU will be receiving ExtInt IRQs.  I.e. I don't think trying to make
IRQWIN a pure per-vCPU inhibit is necessary for performance.

After fiddling with a bunch of ideas, I think the best approach to address both
issues is to add a counter for the IRQ window (addresses the per-vCPU aspect of
IRQ windows), set/clear the IRQWIN inhibit according to the counter when *any*
inhibit changes, and then force an immediate update if and only if the count hits
a 0<=>1 transition *and* there is no other inhibit.  That would address the flaw
Naveen found without needing to make PIT_REINJ sticky.

Guarding the count with apicv_update_lock held for read ensures that if there is
a racing change to a different inhibit, that either kvm_inc_or_dec_irq_window_inhibit()
will see no inhibits and go down the slow path, or __kvm_set_or_clear_apicv_inhibit()
will set IRQWIN accordingly.

Compile tested only (and probably needs to be split into multiple patches).  I'll
try to take it for a spin later today.

[*] https://lore.kernel.org/all/20250130010825.220346-1-seanjc@google.com

---
 arch/x86/include/asm/kvm_host.h | 13 ++++++++++
 arch/x86/kvm/svm/svm.c          | 43 +++++++++------------------------
 arch/x86/kvm/svm/svm.h          |  1 +
 arch/x86/kvm/x86.c              | 36 ++++++++++++++++++++++++++-
 4 files changed, 61 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5193c3dfbce1..9e3465e70a0a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1365,6 +1365,7 @@ struct kvm_arch {
 	/* Protects apicv_inhibit_reasons */
 	struct rw_semaphore apicv_update_lock;
 	unsigned long apicv_inhibit_reasons;
+	atomic_t apicv_irq_window;
 
 	gpa_t wall_clock;
 
@@ -2203,6 +2204,18 @@ static inline void kvm_clear_apicv_inhibit(struct kvm *kvm,
 	kvm_set_or_clear_apicv_inhibit(kvm, reason, false);
 }
 
+void kvm_inc_or_dec_irq_window_inhibit(struct kvm *kvm, bool inc);
+
+static inline void kvm_inc_apicv_irq_window(struct kvm *kvm)
+{
+	kvm_inc_or_dec_irq_window_inhibit(kvm, true);
+}
+
+static inline void kvm_dec_apicv_irq_window(struct kvm *kvm)
+{
+	kvm_inc_or_dec_irq_window_inhibit(kvm, false);
+}
+
 unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
 				      unsigned long a0, unsigned long a1,
 				      unsigned long a2, unsigned long a3,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7640a84e554a..668db3bfff3d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1636,9 +1636,13 @@ static void svm_set_vintr(struct vcpu_svm *svm)
 	struct vmcb_control_area *control;
 
 	/*
-	 * The following fields are ignored when AVIC is enabled
+	 * vIRQ is ignored by hardware AVIC is enabled, and so AVIC must be
+	 * inhibited to detect the interrupt window.
 	 */
-	WARN_ON(kvm_vcpu_apicv_activated(&svm->vcpu));
+	if (enable_apicv && !is_guest_mode(&svm->vcpu)) {
+		svm->avic_irq_window = true;
+		kvm_inc_apicv_irq_window(svm->vcpu.kvm);
+	}
 
 	svm_set_intercept(svm, INTERCEPT_VINTR);
 
@@ -1666,6 +1670,11 @@ static void svm_set_vintr(struct vcpu_svm *svm)
 
 static void svm_clear_vintr(struct vcpu_svm *svm)
 {
+	if (svm->avic_irq_window && !is_guest_mode(&svm->vcpu)) {
+		svm->avic_irq_window = false;
+		kvm_dec_apicv_irq_window(svm->vcpu.kvm);
+	}
+
 	svm_clr_intercept(svm, INTERCEPT_VINTR);
 
 	/* Drop int_ctl fields related to VINTR injection.  */
@@ -3219,20 +3228,6 @@ static int interrupt_window_interception(struct kvm_vcpu *vcpu)
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
@@ -3879,22 +3874,8 @@ static void svm_enable_irq_window(struct kvm_vcpu *vcpu)
 	 * enabled, the STGI interception will not occur. Enable the irq
 	 * window under the assumption that the hardware will set the GIF.
 	 */
-	if (vgif || gif_set(svm)) {
-		/*
-		 * IRQ window is not needed when AVIC is enabled,
-		 * unless we have pending ExtINT since it cannot be injected
-		 * via AVIC. In such case, KVM needs to temporarily disable AVIC,
-		 * and fallback to injecting IRQ via V_IRQ.
-		 *
-		 * If running nested, AVIC is already locally inhibited
-		 * on this vCPU, therefore there is no need to request
-		 * the VM wide AVIC inhibition.
-		 */
-		if (!is_guest_mode(vcpu))
-			kvm_set_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_IRQWIN);
-
+	if (vgif || gif_set(svm))
 		svm_set_vintr(svm);
-	}
 }
 
 static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9d7cdb8fbf87..8eefed0a865a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -323,6 +323,7 @@ struct vcpu_svm {
 
 	bool guest_state_loaded;
 
+	bool avic_irq_window;
 	bool x2avic_msrs_intercepted;
 
 	/* Guest GIF value, used when vGIF is not enabled */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b2d9a16fd4d3..7388f4cfe468 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10604,7 +10604,11 @@ void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
 
 	old = new = kvm->arch.apicv_inhibit_reasons;
 
-	set_or_clear_apicv_inhibit(&new, reason, set);
+	if (reason != APICV_INHIBIT_REASON_IRQWIN)
+		set_or_clear_apicv_inhibit(&new, reason, set);
+
+	set_or_clear_apicv_inhibit(&new, APICV_INHIBIT_REASON_IRQWIN,
+				   atomic_read(&kvm->arch.apicv_irq_window));
 
 	if (!!old != !!new) {
 		/*
@@ -10645,6 +10649,36 @@ void kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
 }
 EXPORT_SYMBOL_GPL(kvm_set_or_clear_apicv_inhibit);
 
+void kvm_inc_or_dec_irq_window_inhibit(struct kvm *kvm, bool inc)
+{
+	bool toggle;
+
+	/*
+	 * The IRQ window inhibit has a cyclical dependency of sorts, as KVM
+	 * needs to manually inject IRQs and thus detect interrupt windows if
+	 * APICv is disabled/inhibitied.  To avoid thrashing if the IRQ window
+	 * is being requested because APICv is already inhibited, toggle the
+	 * actual inhibit (and take the lock for write) if and only if there's
+	 * no other inhibit.  KVM evaluates the IRQ window count when _any_
+	 * inhibit changes, i.e. the IRQ window inhibit can be lazily updated
+	 * on the next inhibit change (if one ever occurs).
+	 */
+	down_read(&kvm->arch.apicv_update_lock);
+
+	if (inc)
+		toggle = atomic_inc_return(&kvm->arch.apicv_irq_window) == 1;
+	else
+		toggle = atomic_dec_return(&kvm->arch.apicv_irq_window) == 0;
+
+	toggle = toggle && !(kvm->arch.apicv_inhibit_reasons & ~BIT(APICV_INHIBIT_REASON_IRQWIN));
+
+	up_read(&kvm->arch.apicv_update_lock);
+
+	if (toggle)
+		kvm_set_or_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_IRQWIN, inc);
+}
+EXPORT_SYMBOL_GPL(kvm_inc_or_dec_irq_window_inhibit);
+
 static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
 {
 	if (!kvm_apic_present(vcpu))

base-commit: eb723766b1030a23c38adf2348b7c3d1409d11f0
-- 

