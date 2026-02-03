Return-Path: <kvm+bounces-70029-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MKZxEkw5gmmVQgMAu9opvQ
	(envelope-from <kvm+bounces-70029-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:07:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A610BDD4FE
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:07:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 15A5E30804FF
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 18:03:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07E0338E5C6;
	Tue,  3 Feb 2026 18:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2/HkZ3/b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9168233E377
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 18:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770141819; cv=none; b=E6Fwpk5A/X+GeeOPlHexYBmOxiw/h4RJ/JgtHSE88hUfH/AbePzfukQmuRFhEiVkpjTqyi5D84B9X+CHFoWVmyMMQmgNazFZnhebFLntV1IljN4Nez+JPDwxLvo89FLBsnXJCnpePOJkMdq4BBo39QOMQnoTOkKvB83GQtaNknI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770141819; c=relaxed/simple;
	bh=pM2rS/12lrlG+2AZ8m3xfZwPCId4Ey85d1MGnj91250=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MWgJl1DwvMAPPf67NOig+AH643hYpRbd8XXQlJNjGNcd4LewUjCxPc24HLenmP53/QXiXORrfaw2Qu5aC0z7hO3Dz1COIk1BnPDDEGnXyOcYeP2O1HfTXZRRUs7moLLN5KEVYT7lfmhbK2akG0kxSlldmJpSKzw1Gcds/dqku7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2/HkZ3/b; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34ec823527eso10895551a91.2
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 10:03:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770141817; x=1770746617; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6XX4eVdJLaAaJXlWOLoKv/kWDfHyar969ebQM03BmoQ=;
        b=2/HkZ3/bBkvSf9OQIzBeIooL8LYGPDMJcqK3F5zP6CSLdutZ2MtD0Xuvj3FoKKeJlb
         q3I98fx1UVUbqMC07t7Fm74soz5S3k8lIiu8Z7tWzwsEqlqvYcgnmUD03x8Wsm9+u59w
         F/1ekuUtn9PUDnHK8up221WSE8oeFNDXUbAl1qCVckUj8QMuzh9xFDpQE//ZYxEEZq5+
         OSh/AuWEQl6hLsirUwA153PJuyYKJ+hN7cLM5JxCIsGDkmkkLqsdMW2s0wOY0/qvyATH
         Q7dr3Nb67bgQeNenqRQyn1dSCCFJOhP8jrk8BMvPxl9bJm8yC/MvaalAgu3S66zp3n+9
         tXSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770141817; x=1770746617;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6XX4eVdJLaAaJXlWOLoKv/kWDfHyar969ebQM03BmoQ=;
        b=bQ9GL+39h0ZjC/fqXyGsLCRAmHv8nI27PqEMGeR1b5Ow4rN//hfWV1sFQdEcTFww90
         l62eKEchBxLa5kpu9ZDl0tTqqe0rYRwFdlW77KQSbwMEXHg1Y60iEWv6ZOMn5Y2Nk8F0
         lGNHBa3Q+U9bsRpQvAWqaIcFMbSuGibMwk7eld7e1zLHv3N0Gs8QUHFjD8c8k/DGeZPy
         UFIdor7607yJjdMI70wOKaqOCl0YGxKIyiMU2m4Ih9Xw+gVfxOkEn8Oc3mBU6yaDY9K6
         BhtRMrvtdGnIlWOp0HOyMeiw+OJk85aRIS3HmrxDWH/ATXz9OFYh8g5IEnUa/yaoKtua
         YiUA==
X-Forwarded-Encrypted: i=1; AJvYcCWTWFlMrW3FV5dXeY+I6gbz8uqsQcCnu77hT4nqAK2pXGKnMGaTWOFs8jxlo9yjvQj6gRU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQFq1mW9X61px9xHN21fQI9rWVjXSwRGZ1DlbIrkMGk1cHC2m2
	QESvua8vTqsRxOTyPYKPUaFNDmbK8ojCC6qOEA0l4L9sh6+VoQvIIJHE7b3rCNhevsDr//g5Tly
	nJXJr1g==
X-Received: from pjsg5.prod.google.com ([2002:a17:90a:7145:b0:352:d19a:6739])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2752:b0:340:ff7d:c26
 with SMTP id 98e67ed59e1d1-354870da124mr148942a91.16.1770141816880; Tue, 03
 Feb 2026 10:03:36 -0800 (PST)
Date: Tue, 3 Feb 2026 10:03:35 -0800
In-Reply-To: <i4xpbma5acebgissizta7abydnwdn2hbdhgqxnb5gyxsjnx6q7@5ayraj5trdtl>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260203011320.1314791-1-yosry.ahmed@linux.dev>
 <aYIebtv3nNnsqUiZ@google.com> <i4xpbma5acebgissizta7abydnwdn2hbdhgqxnb5gyxsjnx6q7@5ayraj5trdtl>
Message-ID: <aYI4d0zPw3K5BedW@google.com>
Subject: Re: [PATCH] KVM: nSVM: Use vcpu->arch.cr2 when updating vmcb12 on
 nested #VMEXIT
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70029-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A610BDD4FE
X-Rspamd-Action: no action

On Tue, Feb 03, 2026, Yosry Ahmed wrote:
> On Tue, Feb 03, 2026 at 08:12:30AM -0800, Sean Christopherson wrote:
> > On Tue, Feb 03, 2026, Yosry Ahmed wrote:
> > 		/*
> > 		 * If L2 is active, defer delivery of the payload until the
> > 		 * exception is actually injected to avoid clobbering state if
> > 		 * L1 wants to intercept the exception (the architectural state
> > 		 * is NOT updated if the exeption is morphed to a VM-Exit).
> > 		 */
> 
> It's not only about exceptions being morphed to a VM-Exit though, is it?
> KVM should not update the payload (e.g. CR2) if a #PF is pending but was
> not injected, because from L1's perspective CR2 was updated but
> exit_int_info won't reflect a #PF. Right?

Right, but that's got nothing to do with L2 being active.  Take nested completely
out of the picture, and the above statement holds true as well.  "If a #PF is
pending but was not injected, then the guest shouldn't see a change in CR2".

> > But thanks to commit 7709aba8f716 ("KVM: x86: Morph pending exceptions to pending
> > VM-Exits at queue time"), KVM already *knows* the exception won't be morphed to a
> > VM-Exit.
> > 
> > Ugh, and I'm pretty sure I botched kvm_vcpu_ioctl_x86_get_vcpu_events() in that
> > commit.  Because invoking kvm_deliver_exception_payload() when the exception was
> > morphed to a VM-Exit is wrong.  Oh, wait, this is the !exception_payload_enabled
> > case.  So never mind, that's simply an unfixable bug, as the second comment alludes
> > to.
> 
> Hmm for the #PF case I think delivering the payload is always wrong if
> it was morphed to a VM-Exit, regardless of exception_payload_enabled,
> because the payload should never reach CR2, right?

Right.

> Spoiler alert, there's another problem there. Even if the exception did
> not morph to a VM-Exit, if userspace already did KVM_GET_SREGS then the
> delivered payload is lost :/
> 
> > 
> > 	/*
> > 	 * KVM's ABI only allows for one exception to be migrated.  Luckily,
> > 	 * the only time there can be two queued exceptions is if there's a
> > 	 * non-exiting _injected_ exception, and a pending exiting exception.
> > 	 * In that case, ignore the VM-Exiting exception as it's an extension
> > 	 * of the injected exception.
> > 	 */
> > 	if (vcpu->arch.exception_vmexit.pending &&
> > 	    !vcpu->arch.exception.pending &&
> > 	    !vcpu->arch.exception.injected)
> > 		ex = &vcpu->arch.exception_vmexit;
> > 	else
> > 		ex = &vcpu->arch.exception;
> > 
> > 	/*
> > 	 * In guest mode, payload delivery should be deferred if the exception
> > 	 * will be intercepted by L1, e.g. KVM should not modifying CR2 if L1
> > 	 * intercepts #PF, ditto for DR6 and #DBs.  If the per-VM capability,
> > 	 * KVM_CAP_EXCEPTION_PAYLOAD, is not set, userspace may or may not
> > 	 * propagate the payload and so it cannot be safely deferred.  Deliver
> > 	 * the payload if the capability hasn't been requested.
> > 	 */
> > 	if (!vcpu->kvm->arch.exception_payload_enabled &&
> > 	    ex->pending && ex->has_payload)
> > 		kvm_deliver_exception_payload(vcpu, ex);
> > 
> > So yeah, I _think_ we could drop the is_guest_mode() check.  However, even better
> > would be to drop this call *entirely*, i.e.
> 
> Hmm I don't think so, because as I mentioned above, KVM shouldn't update
> CR2 until the exception is actually injected, right?

Me confused.  What you're saying is what I'm suggesting: don't update CR2 until
KVM actually stuffs the #PF into the VMCS/VMCB.  Oh, or are you talking about the
first sentence?  If so, strike that from the record, I was wrong (see below).

> It would actually be great to drop the is_guest_mode() check here but
> leave the call, because the ordering problem between KVM_VCPU_SET_EVENTS
> and KVM_SET_SREGS goes away, and I *think* we can drop the
> kvm_deliver_exception_payload() call in
> kvm_vcpu_ioctl_x86_get_vcpu_events().
>
> The only problem would be CR2 getting updated without a fault being
> reflected in the vmcb12's exit_int_info AFAICT.

No, that particular case is a non-issue, because the code immediately above has
already verified that KVM will *not* morph the #PF to a nested VM-Exit.  Note,
the "queue:" path is just for non-contributory exceptions and doesn't change the
VM-Exit change anyways.

	/*
	 * If the exception is destined for L2, morph it to a VM-Exit if L1
	 * wants to intercept the exception.
	 */
	if (is_guest_mode(vcpu) &&
	    kvm_x86_ops.nested_ops->is_exception_vmexit(vcpu, nr, error_code)) {  <====
		kvm_queue_exception_vmexit(vcpu, nr, has_error, error_code,
					   has_payload, payload);
		return;
	}

	if (!vcpu->arch.exception.pending && !vcpu->arch.exception.injected) {
	queue:
		vcpu->arch.exception.pending = true;
		vcpu->arch.exception.injected = false;

		vcpu->arch.exception.has_error_code = has_error;
		vcpu->arch.exception.vector = nr;
		vcpu->arch.exception.error_code = error_code;
		vcpu->arch.exception.has_payload = has_payload;
		vcpu->arch.exception.payload = payload;
		if (!is_guest_mode(vcpu))
			kvm_deliver_exception_payload(vcpu,
						      &vcpu->arch.exception);
		return;
	}

> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index b0112c515584..00a39c95631d 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -864,9 +864,6 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu, unsigned int nr,
> >                 vcpu->arch.exception.error_code = error_code;
> >                 vcpu->arch.exception.has_payload = has_payload;
> >                 vcpu->arch.exception.payload = payload;
> > -               if (!is_guest_mode(vcpu))
> > -                       kvm_deliver_exception_payload(vcpu,
> > -                                                     &vcpu->arch.exception);
> >                 return;
> >         }
> >  
> > Because KVM really shouldn't update CR2 until the excpetion is actually injected
> > (or the state is at risk of being lost because exception_payload_enabled==false).
> > E.g. in the (extremely) unlikely (and probably impossible to configure reliably)
> > scenario that userspace deliberately drops a pending exception, arch state shouldn't
> > be updated.
> 
> I think if we drop it there might be a problem. With
> exception_payload_enabled==false, pending exceptions becomes injected
> after save/restore. If the payload is not delivered here, then after
> restore we have an injected event with no payload.
> 
> I guess the kvm_deliver_exception_payload() call in
> kvm_vcpu_ioctl_x86_get_vcpu_events() is supposed to handle this, but it
> only works if userspace does KVM_GET_SREGS *after* KVM_GET_VCPU_EVENTS.
> Removing the call here will regress VMM's doing KVM_GET_SREGS AFAICT.

Drat, QEMU does KVM_GET_VCPU_EVENTS before KVM_GET_SREGS{,2}, so I was hopeful
we wouldn't actually break anyone, but Firecracker at least gets sregs before
events.  Of course Firecracker is already broken due to not enabling
KVM_CAP_EXCEPTION_PAYLOAD...

Ugh, and it's not just KVM_GET_SREGS, it's also KVM_GET_DEBUGREGS thanks to DR6.

If we're being _super_ pedantic, then delivering the payload anywhere but injection
or KVM_GET_VCPU_EVENTS is "wrong" (well, "more wrong", since any behavior without
KVM_CAP_EXCEPTION_PAYLOAD is inherently wrong).  E.g. very hypothetically, userspace
that saves/restores sregs but not vCPU events would see an unexpected CR2 change.

*sigh*

Ewwwwwwww.  And we *definitely* don't want to drop the is_guest_mode() check,
because nested_vmx_update_pending_dbg() relies on the payload to still be valid.

Ah, right, and that's also why commit a06230b62b89 ("KVM: x86: Deliver exception
payload on KVM_GET_VCPU_EVENTS") from MTF series deferred the update: KVM needs
to keep the #DB pending so that a VM-Exit that occurs before the #DB is injected
gets recorded in vmcs12.

So, with all of that in mind, I believe the best we can do is fully defer delivery
of the exception until it's actually injected, and then apply the quirk to the
relevant GET APIs.

---
 arch/x86/kvm/x86.c | 62 +++++++++++++++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b0112c515584..e000521dfc8b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -864,9 +864,6 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu, unsigned int nr,
 		vcpu->arch.exception.error_code = error_code;
 		vcpu->arch.exception.has_payload = has_payload;
 		vcpu->arch.exception.payload = payload;
-		if (!is_guest_mode(vcpu))
-			kvm_deliver_exception_payload(vcpu,
-						      &vcpu->arch.exception);
 		return;
 	}
 
@@ -5532,18 +5529,8 @@ static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
-					       struct kvm_vcpu_events *events)
+static struct kvm_queued_exception *kvm_get_exception_to_save(struct kvm_vcpu *vcpu)
 {
-	struct kvm_queued_exception *ex;
-
-	process_nmi(vcpu);
-
-#ifdef CONFIG_KVM_SMM
-	if (kvm_check_request(KVM_REQ_SMI, vcpu))
-		process_smi(vcpu);
-#endif
-
 	/*
 	 * KVM's ABI only allows for one exception to be migrated.  Luckily,
 	 * the only time there can be two queued exceptions is if there's a
@@ -5554,21 +5541,46 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 	if (vcpu->arch.exception_vmexit.pending &&
 	    !vcpu->arch.exception.pending &&
 	    !vcpu->arch.exception.injected)
-		ex = &vcpu->arch.exception_vmexit;
-	else
-		ex = &vcpu->arch.exception;
+		return &vcpu->arch.exception_vmexit;
+
+	return &vcpu->arch.exception;
+}
+
+static void kvm_handle_exception_payload_quirk(struct kvm_vcpu *vcpu)
+{
+	struct kvm_queued_exception *ex = kvm_get_exception_to_save(vcpu);
 
 	/*
-	 * In guest mode, payload delivery should be deferred if the exception
-	 * will be intercepted by L1, e.g. KVM should not modifying CR2 if L1
-	 * intercepts #PF, ditto for DR6 and #DBs.  If the per-VM capability,
-	 * KVM_CAP_EXCEPTION_PAYLOAD, is not set, userspace may or may not
-	 * propagate the payload and so it cannot be safely deferred.  Deliver
-	 * the payload if the capability hasn't been requested.
+	 * If KVM_CAP_EXCEPTION_PAYLOAD is disabled, then (prematurely) deliver
+	 * the pending exception payload when userspace saves *any* vCPU state
+	 * that interacts with exception payloads to avoid breaking userspace.
+	 *
+	 * Architecturally, KVM must not deliver an exception payload until the
+	 * exception is actually injected, e.g. to avoid losing pending #DB
+	 * information (which VMX tracks in the VMCS), and to avoid clobbering
+	 * state if the exception is never injected for whatever reason.  But
+	 * if KVM_CAP_EXCEPTION_PAYLOAD isn't enabled, then userspace may or
+	 * may not propagate the payload across save+restore, and so KVM can't
+	 * safely defer delivery of the payload.
 	 */
 	if (!vcpu->kvm->arch.exception_payload_enabled &&
 	    ex->pending && ex->has_payload)
 		kvm_deliver_exception_payload(vcpu, ex);
+}
+
+static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
+					       struct kvm_vcpu_events *events)
+{
+	struct kvm_queued_exception *ex = kvm_get_exception_to_save(vcpu);
+
+	process_nmi(vcpu);
+
+#ifdef CONFIG_KVM_SMM
+	if (kvm_check_request(KVM_REQ_SMI, vcpu))
+		process_smi(vcpu);
+#endif
+
+	kvm_handle_exception_payload_quirk(vcpu);
 
 	memset(events, 0, sizeof(*events));
 
@@ -5747,6 +5759,8 @@ static int kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
 	    vcpu->arch.guest_state_protected)
 		return -EINVAL;
 
+	kvm_handle_exception_payload_quirk(vcpu);
+
 	memset(dbgregs, 0, sizeof(*dbgregs));
 
 	BUILD_BUG_ON(ARRAY_SIZE(vcpu->arch.db) != ARRAY_SIZE(dbgregs->db));
@@ -12123,6 +12137,8 @@ static void __get_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	if (vcpu->arch.guest_state_protected)
 		goto skip_protected_regs;
 
+	kvm_handle_exception_payload_quirk(vcpu);
+
 	kvm_get_segment(vcpu, &sregs->cs, VCPU_SREG_CS);
 	kvm_get_segment(vcpu, &sregs->ds, VCPU_SREG_DS);
 	kvm_get_segment(vcpu, &sregs->es, VCPU_SREG_ES);

base-commit: 55671237401edd1ec59276b852b9361cc170915b
--

