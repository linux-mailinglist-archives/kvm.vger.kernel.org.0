Return-Path: <kvm+bounces-70076-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aOWTHmtSgmk8SQMAu9opvQ
	(envelope-from <kvm+bounces-70076-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 20:54:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DD8E7DE481
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 20:54:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A9E5F3062C77
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 19:54:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B619366DB9;
	Tue,  3 Feb 2026 19:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OJiA1RaH"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B815E7261C
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 19:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770148451; cv=none; b=AAIMWu1sfONy8TY1/v/VTlniN6ECjKIvF7OQtIVA2hS/ti56I89jcPUoB48nOMbSDnCCNnMs8iY9eUQDpvuvr1xGjCjjDG8CMOQN49Qv8gsREauXOr0jN6wjsusyorC1KbSHjWppKNflUcd6naGTt0nfunv5PoV4Xb1rYCByUho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770148451; c=relaxed/simple;
	bh=2AQ4LrbB5EqionGXFr+lRlv/NE3OCrCjhsYKz3d2qQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AmaKdGgDL/fa5a8vCkyW+zmJGVCzft/t1t/5hRPPWWwdQybEvDS+e8uZuoscjb7zM0zS8tRq2lwXil3ivFzFo0wWk89fiRnCol7vv/Rc7l+ZiCDTkTcCCgDVUmzrV4rOTsMasRKIytsWFKDIROm4J04wpucIEMVVrUMR8p6X+IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OJiA1RaH; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 3 Feb 2026 19:54:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770148447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VGL+PZ7z0HLz5FwjDOjSOKQvTJwwIAqoqz6rSanvxwo=;
	b=OJiA1RaHf5bUkIN9VDMSI1gn0yJ7CkjstEemaGCYTWO07Uhe+Fby63d9UgefJ40NNWnYm9
	a9AJC15Y8m0aCCMuseabz4MrgZyeuutfRlFeHcINvZ9Rg6zwMGrLAVFGwpWBN6ahnglXYH
	AWwZkrFtfAjDDSpK6cRUQG7EyIiZN9U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nSVM: Use vcpu->arch.cr2 when updating vmcb12 on
 nested #VMEXIT
Message-ID: <fybuz7v4zng2z5xktgqjluweplxx2hrn4j5ar57ea42e4fjwm6@5aemjmv6p4fv>
References: <20260203011320.1314791-1-yosry.ahmed@linux.dev>
 <aYIebtv3nNnsqUiZ@google.com>
 <i4xpbma5acebgissizta7abydnwdn2hbdhgqxnb5gyxsjnx6q7@5ayraj5trdtl>
 <aYI4d0zPw3K5BedW@google.com>
 <uas6znyp5a5m3sclpy2xn4bynxy7mhvooc5s6joonc6p3rwsx5@4jgpgnpkcgv5>
 <aYJPiVICpb3R6Cj_@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYJPiVICpb3R6Cj_@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70076-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[linux.dev:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DD8E7DE481
X-Rspamd-Action: no action

On Tue, Feb 03, 2026 at 11:42:01AM -0800, Sean Christopherson wrote:
> On Tue, Feb 03, 2026, Yosry Ahmed wrote:
> > On Tue, Feb 03, 2026 at 10:03:35AM -0800, Sean Christopherson wrote:
> > > On Tue, Feb 03, 2026, Yosry Ahmed wrote:
> > > > On Tue, Feb 03, 2026 at 08:12:30AM -0800, Sean Christopherson wrote:
> > > > > On Tue, Feb 03, 2026, Yosry Ahmed wrote:
> > > > > 		/*
> > > > > 		 * If L2 is active, defer delivery of the payload until the
> > > > > 		 * exception is actually injected to avoid clobbering state if
> > > > > 		 * L1 wants to intercept the exception (the architectural state
> > > > > 		 * is NOT updated if the exeption is morphed to a VM-Exit).
> > > > > 		 */
> > > > 
> > > > It's not only about exceptions being morphed to a VM-Exit though, is it?
> > > > KVM should not update the payload (e.g. CR2) if a #PF is pending but was
> > > > not injected, because from L1's perspective CR2 was updated but
> > > > exit_int_info won't reflect a #PF. Right?
> > > 
> > > Right, but that's got nothing to do with L2 being active.  Take nested completely
> > > out of the picture, and the above statement holds true as well.  "If a #PF is
> > > pending but was not injected, then the guest shouldn't see a change in CR2".
> > 
> > Right, but it is still related to nested in a way. Ignore the exception
> > morphing to a VM-Exit, the case I am refering to is specifically
> > exit_int_info on SVM. IIUC, if there's an injected (but not intercepted)
> > exception when doing a nested VM-Exit, we have to propagate that to L1
> > (in nested_save_pending_event_to_vmcb12()), such that it can re-inject
> > that exception.
> 
> Ugh, that's a poor choice of name for nested_save_pending_event_to_vmcb12().
> 
> As defined by kvm_queued_exception, that's not a *pending* event, it's an
> *injected* event.  In that case, the payload *should* have been delivered (to CR2
> or DR6) because that exception has already occurred (been "detected" in the SDM's
> weird wording).  The VM-Exit is not happening *before* the #PF, it's happening
> after the #PF is "detected", while the #PF is being vectored.
> 
> From a virtualization perspective, any other implementation is basically unworkable,
> as it would require the host to gain control after an exception is successfully
> vectored.  I.e. the absense of any mechanisms to support that effectively confirms
> that the CPU writes CR2 before attempting to deliver the exception to software.
> 
> > So what I was referring to is, if we write CR2 for a pending exception
> > to L2, and then exit to L1, L1 would perceive a chance in CR2 without an
> > ongoing #PF in exit_int_info. I believe the equivalent VMX function is
> > vmcs12_save_pending_event().
> 
> Also poorly named :-/
> 
> > All that to say, we should not deliver the payload of an exception to L2
> > before it's actually injected.
> 
> As above, those helpers deal with exceptions that have already been injected by
> KVM.
> 
> > > > It would actually be great to drop the is_guest_mode() check here but
> > > > leave the call, because the ordering problem between KVM_VCPU_SET_EVENTS
> > > > and KVM_SET_SREGS goes away, and I *think* we can drop the
> > > > kvm_deliver_exception_payload() call in
> > > > kvm_vcpu_ioctl_x86_get_vcpu_events().
> > > >
> > > > The only problem would be CR2 getting updated without a fault being
> > > > reflected in the vmcb12's exit_int_info AFAICT.
> > > 
> > > No, that particular case is a non-issue, because the code immediately above has
> > > already verified that KVM will *not* morph the #PF to a nested VM-Exit.  Note,
> > > the "queue:" path is just for non-contributory exceptions and doesn't change the
> > > VM-Exit change anyways.
> > 
> > What I meant was not stuffing the #PF into the VMCB/VMCS because it's
> > intercepted, but the #PF being stuffed into exit_int_info or
> > idt_vectoring_info.
> > 
> > If we drop the guest mode check here, we could end up with CR2 updated
> > and a #PF not reflected in exit_int_info/idt_vectoring_info (assuming
> > #PF is not intercepted).
> 
> No, because once {svm,vmx}_inject_exception() have been reach, KVM has fully
> committed to delivering the exception to the guest.  If KVM cancels KVM_RUN, e.g.
> because of a pending signal from userspace to initiate save/restore, KVM calls
> kvm_x86_ops.cancel_injection() so that vendor code can move the to-be-injected
> exception from the VMCS/VMCB back to vcpu->arch.exception.  Note that
> kvm_requeue_exception() (a) sets injected=true and (b) deliberately doesn't
> track any payload, because the payload has already been delivered.
> 
> If VM-Enter is executed and a non-nested VM-Exit occurs, then hardware saves the
> in-progress exception in VMCB.exit_int_info/VMCS.idt_vectoring_info, and KVM
> moves the exception back to vcpu->arch.exception via vmx_complete_interrupts()
> and svm_complete_interrupts() (which are also used for cancelling injection,
> because the logic is identical, only the VMCS/VMCB source differs).
> 
> For nested VM-Exit, KVM needs to emulate that behavior.  The exception has already
> been "detected" by KVM, and the payload has already been delivered, but a VM-Exit
> was encountered while vectoring the exception to software.
> 
> E.g. if a guest #PF occurs while the guest stack is at the bottom of a page, such
> that the first N pushes will hit page X, and the last M pushes will hit page X-1,
> and the write to page X-1 hits a #NPF / EPT Violation, then L1 will (and should!)
> see an updated CR2, with the first N pushes to vector the exception resident in
> page X.

We are not disagreeing, I think I may not have been clear. I agree with
all what you said.

What I was saying is basically delivering the payload for *pending*
exceptions for L2 is wrong (i.e. just removing the is_guest_mode() check
before calling kvm_deliver_exception_payload() in
kvm_multiple_exception()).

Exactly because of everything you said, the exception is not yet
*injected* and is *not* reflected to L1 in
exit_int_info/idt_vectoring_info if it's injection fails.

i.e what I said above:

	 If we drop the guest mode check here, we could end up with CR2
	 updated and a #PF not reflected in
	 exit_int_info/idt_vectoring_info (assuming #PF is not
	 intercepted).

We already established that removing the is_guest_mode() would be wrong,
so all is good here, I am just clarifying that what I meant initially is
that it would be wrong because we would update CR2 without actually
reflecting the #PF in exit_int_info/idt_vectoring_info, not because we
could update CR2 before a #PF intercept (as you mentioned, this part is
handled).

> 
> > > So, with all of that in mind, I believe the best we can do is fully defer delivery
> > > of the exception until it's actually injected, and then apply the quirk to the
> > > relevant GET APIs.
> > 
> > I think this should work. I can test it for the nested case, the way I
> > could reproduce the problem (with a VMM that does KVM_GET_SREGS before
> > KVM_GET_VCPU_EVENTS, but does not use KVM_CAP_EXCEPTION_PAYLOAD) is by
> > intercepting and re-injecting all #PFs from L2, and then repeatedly
> > doing save+restore while L2 is doing some heavy lifting (building GCC).
> > This generates a lot of #PF exceptions to be saved+restored, and we
> > eventually get a segfault because of corrupted CR2 in L2.
> > 
> > Removing the is_guest_mode() check in kvm_multiple_exception() fixes it
> > by prematurely delivering the payload when it's queued. I think your fix
> > will also work by prematurely delivering the payload at save time. This
> > is actually more corect because at restore time the exception will
> > become injected and treated as such (e.g. shows up in exit_int_info).
> > 
> > Do you intend to send a patch? Or should I send it out (separate from
> > the current one) with you as the author?
> 
> I'll send a patch for this, there's a lot of historical information I want to
> capture.

Sounds good, I will test that it fixes the problem of losing the payload
of a nested exception when KVM_GET_SREGS preceeds KVM_GET_VCPU_EVENTS
(without KVM_CAP_EXCEPTION_PAYLOAD). Please CC me when you send it.

> 
> Can you send a v2 for _this_ patch, without the comment change?

Will do so shortly.

