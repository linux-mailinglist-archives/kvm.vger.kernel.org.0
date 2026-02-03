Return-Path: <kvm+bounces-70075-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KA8xKatPgmmBSAMAu9opvQ
	(envelope-from <kvm+bounces-70075-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 20:42:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 08C68DE35B
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 20:42:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 33CF130AE14F
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 19:42:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E739366573;
	Tue,  3 Feb 2026 19:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gF5hYgwM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE95F211A14
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 19:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770147725; cv=none; b=Ne1vEqfsRpHXSjTx6yZgliIdcTQkB8wPLROmRG+4e5R3Wuo9ZxWMIjrLzGztes9lWh/wguraxTzHPymeiUKBml4WCX/aWyaNJBP1aJPBCSZKzOHzjIvwPTD6oLVjjQStOEhQLtXgnlLWwrTGiPx/B8VsJ5FHVdLRCBtYkHX+SlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770147725; c=relaxed/simple;
	bh=gl+vbBBdDHvSmulNw5qfHcmZq0V+8I0GloPD+vdrIXM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=n8i0c09GkyxDyAZf2qsc69Hfd9x/m6vKGgTPA/hN4BNJGLn7XABtb8vLNVf//H4pbglAzNIq27NL+oPyEsTFZPyl85B4+amkrYKmCydlgF1KVx9EtUug4ZINhwCPL56Ap8t2nRGWqeX71krCh/dtmILbypEsNTrrfGzLQKQ2xGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gF5hYgwM; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c6136af8e06so3749903a12.1
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 11:42:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770147723; x=1770752523; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W8QLL06dNWZHp4eObORBJxliw+Nahv5NgK4eaS7VWhU=;
        b=gF5hYgwMS7NeaZvtLqnQ141IxNAIW21el3zmUVlmQn4BAaCVEeF4PujE9PgBeCPKTP
         irbMI+ohyoCMrJ1WJqolrILtHUhQTRLrrgedRHBmL7rO7CS7XOx9xJPR1/R+4x7lhgoY
         eV46wJr+gqxF+voJ8te2UfEuX3CKhti5KE0pmgiadKOUWRCutPz6yr7gIun6WRTJCUo/
         RA0AR/2zCKL3cg6PFqkkP5rAbwCqAw9RNxQaaopbe/JX31+SCYdq+lcAzMzYOE86L4QV
         OpqsJzCiR/gNNmsNiYf7X6Fel+VKkc7gbJkWA9Ux5e7Rv5fw4nc3WQKQgdCddUjRXPlB
         QI/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770147723; x=1770752523;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W8QLL06dNWZHp4eObORBJxliw+Nahv5NgK4eaS7VWhU=;
        b=sb+gHgBBpNtzvweaYuDmFjkGngUraMN+CPi+OsCdN+mr9jZ9X4mtrPoQIZMrLftwRT
         d2DV7SPVTwbyJJpzPjCOppeKAtKbX15JrrTVrqatJpYLlORzuhBNWCClLVkgNC+93EP7
         yt0gVkms1JTVjg5n3X0HekHyAtEE3HpoV7hp8UOWS/8wu0KoZVk1FfrOuv4mlEyAVxkh
         pkDuMkE2BJFIyD0LatrzdM11+x1A8K06W98tQHxDB/56rPejGngT922GGsK3Lz3qAEyi
         d9TPjce/n8htuG9EUtbstBZEiCs8HabZj5lj22YKjG7E43MTI2/xXJrpkjlFlCROXtAq
         Ih0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXzb59oMXHQ+I1Ou30XrWk7FgzCp/0cZU4/rHyqwnUygc6MvZZPVoQvh4KHjHM9GQ4aRlQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3uITJyENQejGUU+Jj7QYWxoZWwyIxZ4w92TcRTKro7cELC4hi
	vKiw9SPvZuBkhisQVxUpMTEXjOn44nul9HLFQyLDeGBsHLXXQLe8dgMnqSIu4jzxr5htACQrN+Z
	I2BQIQQ==
X-Received: from pgng22.prod.google.com ([2002:a63:3756:0:b0:c61:3234:9245])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:1805:b0:38e:87b7:5f88
 with SMTP id adf61e73a8af0-3937210bb2emr519523637.27.1770147723378; Tue, 03
 Feb 2026 11:42:03 -0800 (PST)
Date: Tue, 3 Feb 2026 11:42:01 -0800
In-Reply-To: <uas6znyp5a5m3sclpy2xn4bynxy7mhvooc5s6joonc6p3rwsx5@4jgpgnpkcgv5>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260203011320.1314791-1-yosry.ahmed@linux.dev>
 <aYIebtv3nNnsqUiZ@google.com> <i4xpbma5acebgissizta7abydnwdn2hbdhgqxnb5gyxsjnx6q7@5ayraj5trdtl>
 <aYI4d0zPw3K5BedW@google.com> <uas6znyp5a5m3sclpy2xn4bynxy7mhvooc5s6joonc6p3rwsx5@4jgpgnpkcgv5>
Message-ID: <aYJPiVICpb3R6Cj_@google.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70075-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 08C68DE35B
X-Rspamd-Action: no action

On Tue, Feb 03, 2026, Yosry Ahmed wrote:
> On Tue, Feb 03, 2026 at 10:03:35AM -0800, Sean Christopherson wrote:
> > On Tue, Feb 03, 2026, Yosry Ahmed wrote:
> > > On Tue, Feb 03, 2026 at 08:12:30AM -0800, Sean Christopherson wrote:
> > > > On Tue, Feb 03, 2026, Yosry Ahmed wrote:
> > > > 		/*
> > > > 		 * If L2 is active, defer delivery of the payload until the
> > > > 		 * exception is actually injected to avoid clobbering state if
> > > > 		 * L1 wants to intercept the exception (the architectural state
> > > > 		 * is NOT updated if the exeption is morphed to a VM-Exit).
> > > > 		 */
> > > 
> > > It's not only about exceptions being morphed to a VM-Exit though, is it?
> > > KVM should not update the payload (e.g. CR2) if a #PF is pending but was
> > > not injected, because from L1's perspective CR2 was updated but
> > > exit_int_info won't reflect a #PF. Right?
> > 
> > Right, but that's got nothing to do with L2 being active.  Take nested completely
> > out of the picture, and the above statement holds true as well.  "If a #PF is
> > pending but was not injected, then the guest shouldn't see a change in CR2".
> 
> Right, but it is still related to nested in a way. Ignore the exception
> morphing to a VM-Exit, the case I am refering to is specifically
> exit_int_info on SVM. IIUC, if there's an injected (but not intercepted)
> exception when doing a nested VM-Exit, we have to propagate that to L1
> (in nested_save_pending_event_to_vmcb12()), such that it can re-inject
> that exception.

Ugh, that's a poor choice of name for nested_save_pending_event_to_vmcb12().

As defined by kvm_queued_exception, that's not a *pending* event, it's an
*injected* event.  In that case, the payload *should* have been delivered (to CR2
or DR6) because that exception has already occurred (been "detected" in the SDM's
weird wording).  The VM-Exit is not happening *before* the #PF, it's happening
after the #PF is "detected", while the #PF is being vectored.

From a virtualization perspective, any other implementation is basically unworkable,
as it would require the host to gain control after an exception is successfully
vectored.  I.e. the absense of any mechanisms to support that effectively confirms
that the CPU writes CR2 before attempting to deliver the exception to software.

> So what I was referring to is, if we write CR2 for a pending exception
> to L2, and then exit to L1, L1 would perceive a chance in CR2 without an
> ongoing #PF in exit_int_info. I believe the equivalent VMX function is
> vmcs12_save_pending_event().

Also poorly named :-/

> All that to say, we should not deliver the payload of an exception to L2
> before it's actually injected.

As above, those helpers deal with exceptions that have already been injected by
KVM.

> > > It would actually be great to drop the is_guest_mode() check here but
> > > leave the call, because the ordering problem between KVM_VCPU_SET_EVENTS
> > > and KVM_SET_SREGS goes away, and I *think* we can drop the
> > > kvm_deliver_exception_payload() call in
> > > kvm_vcpu_ioctl_x86_get_vcpu_events().
> > >
> > > The only problem would be CR2 getting updated without a fault being
> > > reflected in the vmcb12's exit_int_info AFAICT.
> > 
> > No, that particular case is a non-issue, because the code immediately above has
> > already verified that KVM will *not* morph the #PF to a nested VM-Exit.  Note,
> > the "queue:" path is just for non-contributory exceptions and doesn't change the
> > VM-Exit change anyways.
> 
> What I meant was not stuffing the #PF into the VMCB/VMCS because it's
> intercepted, but the #PF being stuffed into exit_int_info or
> idt_vectoring_info.
> 
> If we drop the guest mode check here, we could end up with CR2 updated
> and a #PF not reflected in exit_int_info/idt_vectoring_info (assuming
> #PF is not intercepted).

No, because once {svm,vmx}_inject_exception() have been reach, KVM has fully
committed to delivering the exception to the guest.  If KVM cancels KVM_RUN, e.g.
because of a pending signal from userspace to initiate save/restore, KVM calls
kvm_x86_ops.cancel_injection() so that vendor code can move the to-be-injected
exception from the VMCS/VMCB back to vcpu->arch.exception.  Note that
kvm_requeue_exception() (a) sets injected=true and (b) deliberately doesn't
track any payload, because the payload has already been delivered.

If VM-Enter is executed and a non-nested VM-Exit occurs, then hardware saves the
in-progress exception in VMCB.exit_int_info/VMCS.idt_vectoring_info, and KVM
moves the exception back to vcpu->arch.exception via vmx_complete_interrupts()
and svm_complete_interrupts() (which are also used for cancelling injection,
because the logic is identical, only the VMCS/VMCB source differs).

For nested VM-Exit, KVM needs to emulate that behavior.  The exception has already
been "detected" by KVM, and the payload has already been delivered, but a VM-Exit
was encountered while vectoring the exception to software.

E.g. if a guest #PF occurs while the guest stack is at the bottom of a page, such
that the first N pushes will hit page X, and the last M pushes will hit page X-1,
and the write to page X-1 hits a #NPF / EPT Violation, then L1 will (and should!)
see an updated CR2, with the first N pushes to vector the exception resident in
page X.

> > So, with all of that in mind, I believe the best we can do is fully defer delivery
> > of the exception until it's actually injected, and then apply the quirk to the
> > relevant GET APIs.
> 
> I think this should work. I can test it for the nested case, the way I
> could reproduce the problem (with a VMM that does KVM_GET_SREGS before
> KVM_GET_VCPU_EVENTS, but does not use KVM_CAP_EXCEPTION_PAYLOAD) is by
> intercepting and re-injecting all #PFs from L2, and then repeatedly
> doing save+restore while L2 is doing some heavy lifting (building GCC).
> This generates a lot of #PF exceptions to be saved+restored, and we
> eventually get a segfault because of corrupted CR2 in L2.
> 
> Removing the is_guest_mode() check in kvm_multiple_exception() fixes it
> by prematurely delivering the payload when it's queued. I think your fix
> will also work by prematurely delivering the payload at save time. This
> is actually more corect because at restore time the exception will
> become injected and treated as such (e.g. shows up in exit_int_info).
> 
> Do you intend to send a patch? Or should I send it out (separate from
> the current one) with you as the author?

I'll send a patch for this, there's a lot of historical information I want to
capture.

Can you send a v2 for _this_ patch, without the comment change?

