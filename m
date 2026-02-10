Return-Path: <kvm+bounces-70806-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SC/IHzCvi2nmYQAAu9opvQ
	(envelope-from <kvm+bounces-70806-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 23:20:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 939F311FB9E
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 23:20:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DB88830579F2
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 22:19:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30B9E2FD689;
	Tue, 10 Feb 2026 22:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mX4J+sHT"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6D8339857
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 22:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770761973; cv=none; b=p2scyQyc+xMLGiySQFgTCR7k9h9zAb6JuyQvVF0QxSGm4B+9RJQLvMRIDjr1o3Fl6C/3R6GUVjiCQF4Zc7z4Uy9d1ag35fRY9Lf6yRGrmtx1TwvLsnhairwG/Q/NT0Mn4kyjMXwRPd6EsML6kUJIaxdHd/WXDt3eGkDtunMSp0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770761973; c=relaxed/simple;
	bh=K9uMrUbRxVC4mq4o5CGIXn2AHfwXsiA4zEikAnuV3YY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KjgkYzPGvL9DOrRYThqqo/9BxvyDAIHhCyzTtpng2hMXUeyGMFYtRShrprRRBATtDsjI/onGRngelaQ7mjOQWlJBeiZf/flhAlRUldwbryrZR4gauB99dmJTlTZoOWS9gRIsHYEV6G82k/tPvF6UCgPY6K7SR7YTi4GpFuy7QMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mX4J+sHT; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 10 Feb 2026 22:19:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770761968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HbI+Syg14mFnON84SxIlDgQrFOCi8ITvz+lEYGTWK14=;
	b=mX4J+sHTjONtNYZoIxEl8nZAXDLuaPR65anQPVJF3+9yDJXcVX/R88MLzZLotpkNZa3WBp
	LEIsvqiVDXBbhjoGehWMtow2WFqVB7B99Y+tqYQs8MiqBf5vL2Tszma1Z9ynEcAmPct3CP
	xhnaLlO08+t+dHYNLledZ9HgSziVDs0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/4] KVM: nSVM: Sync next_rip to cached vmcb12 after
 VMRUN of L2
Message-ID: <ck57mmdt5phh64cadoqxylw5q2b72ffmabmlzmpphaf27lbtxw@4kscovf6ahve>
References: <20260210005449.3125133-1-yosry.ahmed@linux.dev>
 <20260210005449.3125133-2-yosry.ahmed@linux.dev>
 <aYqOkvHs3L-AX-CG@google.com>
 <4g25s35ty23lx2je4aknn6dg4ohviqhkbvvel4wkc4chhgp6af@kbqz3lnezo3j>
 <aYuE8xQdE5pQrmUs@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYuE8xQdE5pQrmUs@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70806-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 939F311FB9E
X-Rspamd-Action: no action

On Tue, Feb 10, 2026 at 11:20:19AM -0800, Sean Christopherson wrote:
> On Tue, Feb 10, 2026, Yosry Ahmed wrote:
> > On Mon, Feb 09, 2026 at 05:49:06PM -0800, Sean Christopherson wrote:
> > > On Tue, Feb 10, 2026, Yosry Ahmed wrote:
> > > > After VMRUN in guest mode, nested_sync_control_from_vmcb02() syncs
> > > > fields written by the CPU from vmcb02 to the cached vmcb12. This is
> > > > because the cached vmcb12 is used as the authoritative copy of some of
> > > > the controls, and is the payload when saving/restoring nested state.
> > > > 
> > > > next_rip is also written by the CPU (in some cases) after VMRUN, but is
> > > > not sync'd to cached vmcb12. As a result, it is corrupted after
> > > > save/restore (replaced by the original value written by L1 on nested
> > > > VMRUN). This could cause problems for both KVM (e.g. when injecting a
> > > > soft IRQ) or L1 (e.g. when using next_rip to advance RIP after emulating
> > > > an instruction).
> > > > 
> > > > Fix this by sync'ing next_rip in nested_sync_control_from_vmcb02(). Move
> > > > the call to nested_sync_control_from_vmcb02() (and the entire
> > > > is_guest_mode() block) after svm_complete_interrupts(), as it may update
> > > > next_rip in vmcb02.
> > > 
> > > I'll give you one guess as to what I would say about bundling changes.  AFAICT,
> > > there is _zero_ reason to move the call nested_sync_control_from_vmcb02() in a
> > > patch tagged for stable@.
> > 
> > I generally agree with your previous feedback about combining changes,
> > but I think I disagree for this specific instance. I did actually have
> > two separate changes: one to move the call to
> > nested_sync_control_from_vmcb02() (still tagged for stable@), and one to
> > add next_rip.
> > 
> > However, I found myself explaining a lot of the next_rip context in the
> > commit log of moving nested_sync_control_from_vmcb02(), to explain why
> > it specifically needed to go after svm_complete_interrupts().
> 
> And?  That's kinda the whole point of changelogs.  I'm also not seeing an onerous
> amount of documentation, e.g.
> 
>   KVM: SVM: Sync control from vmcb02 on #VMEXIT after completing interrupts
> 
>   Refresh KVM's cache of VMCB control fields, which is a weird combination
>   of original vmcb12 data and current vmcb02 data, after completing
>   interrupts and exceptions so that a future fix can refresh next_rip
>   without dropping the next_rip updates made for completing soft interrupts.
>   
> > Also, I had to add the comment above the call to
> > nested_sync_control_from_vmcb02() in the patch adding next_rip to it.
> > 
> > Looking at both patches, it made more sense to combine them given their
> > tight connection and simplicity. The history is clearer when the move,
> > comment, and next_rip addition are bundled.
> > 
> > Or..
> > 
> > Did you mean to have a patch that just copied next_rip outside of
> > nested_sync_control_from_vmcb02(), after svm_complete_interrupts(), for
> > stable@, and then clean it up on top? Eh, not a big fan of that either
> > because the current patch is simple enough for stable@ imo.
> 
> My objection to bundling is that it subtly requires guarnteeing that none of the
> fields updated by nested_sync_control_from_vmcb02() are consumed between its
> current location and the new location.  That alone warrants a changelog.  I.e.
> it's as much that there's _zero_ analysis in the current changelog as to the
> safety, as it is that the movement is bundled together.

Now that I agree this, I should have included more details about why
it's safe to move the call later. But that feedback is irrelevant to
splitting the commit imo.

Anyway, we'll probably drop the code movement.

> 
> > > > Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE")
> > > > CC: stable@vger.kernel.org
> > > > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > > ---
> > > >  arch/x86/kvm/svm/nested.c |  6 ++++--
> > > >  arch/x86/kvm/svm/svm.c    | 26 +++++++++++++++-----------
> > > >  2 files changed, 19 insertions(+), 13 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > > > index de90b104a0dd..70086ba6497f 100644
> > > > --- a/arch/x86/kvm/svm/nested.c
> > > > +++ b/arch/x86/kvm/svm/nested.c
> > > > @@ -519,8 +519,10 @@ void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
> > > >  void nested_sync_control_from_vmcb02(struct vcpu_svm *svm)
> > > >  {
> > > >  	u32 mask;
> > > > -	svm->nested.ctl.event_inj      = svm->vmcb->control.event_inj;
> > > > -	svm->nested.ctl.event_inj_err  = svm->vmcb->control.event_inj_err;
> > > > +
> > > > +	svm->nested.ctl.event_inj	= svm->vmcb->control.event_inj;
> > > > +	svm->nested.ctl.event_inj_err	= svm->vmcb->control.event_inj_err;
> > > > +	svm->nested.ctl.next_rip	= svm->vmcb->control.next_rip;
> > > 
> > > This is all a mess (the existing code).  nested_svm_vmexit() does this:
> > > 
> > > 	vmcb12->control.int_state         = vmcb02->control.int_state;
> > > 	vmcb12->control.exit_code         = vmcb02->control.exit_code;
> > > 	vmcb12->control.exit_info_1       = vmcb02->control.exit_info_1;
> > > 	vmcb12->control.exit_info_2       = vmcb02->control.exit_info_2;
> > > 
> > > 	if (!svm_is_vmrun_failure(vmcb12->control.exit_code))
> > > 		nested_save_pending_event_to_vmcb12(svm, vmcb12);
> > > 
> > > 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
> > > 		vmcb12->control.next_rip  = vmcb02->control.next_rip;
> > > 
> > > 	vmcb12->control.int_ctl           = svm->nested.ctl.int_ctl;
> > > 	vmcb12->control.event_inj         = svm->nested.ctl.event_inj;
> > > 	vmcb12->control.event_inj_err     = svm->nested.ctl.event_inj_err;
> > > 
> > > but then svm_get_nested_state(), by way of nested_copy_vmcb_cache_to_control(),
> > > pulls everything from the cached fields.  Which probably only works because the
> > > only fields that are pulled from vmcb02 nested_svm_vmexit() are never modified
> > > by the CPU.
> > 
> > Yeah I think that's the key. The main distinction is whether fields
> > are"in", "out" or "in/out" fields. I wish those were more clearly
> > separated by the APM. More below.
> > 
> > > 
> > > Actually, I take that back, I have no idea how this code works.  How does e.g.
> > > exit_info_1 not get clobbered on save/restore?
> > 
> > I *think* KVM always sets the error_code and exit_info_* fields before
> > synthesizing a #VMEXIT to L1, usually right before calling
> > nested_svm_vmeit(), so no chance for save/restore in between.
> 
> Ugh, right, KVM generally doesn't recognize signals until after invoking the exit
> handler.  Actually, even that isn't the key, it's that this flaw only affects
> "in/out" fields, as you note above.  Heh, and even that probably isn't entirely
> precise, as it's really "in/out fields that KVM consumes while running L2 are
> buggy".  E.g. in this case, nested_vmcb02_prepare_control() pulls next_rip for
> vmcb02 from the cache.
> 
> 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
> 		vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
> 	else if (boot_cpu_has(X86_FEATURE_NRIPS))
> 		vmcb02->control.next_rip    = vmcb12_rip;

Hmm I thin a pure "out" field would be affected if it's consumed by KVM
later on, after save+restore is possible, right?

Do you mean that it just happens that the currently affected fields are
"in/out" fields? Or is there a reason why pure "out" fields cannot be
affected? AFAICT, these fields are lost after save+restore.

> 
> > I think generally, most "out" fields are consumed by KVM before userspace can
> > save/restore, hence them getting lost on save/restore is fine?
> 
> Yep.
> 
> > It's still probably worse than we think, I see
> > svm->nested.ctl.bus_lock_rip is not saved/restored, because it's not
> > part of the VMCB. So in
> > svm_set_nested_state()->nested_vmcb02_prepare_control() we end up
> > comparing garbage to garbage (because vmcb02->save.rip is also wrong):
> > 
> > 	if (vmcb02->save.rip && (svm->nested.ctl.bus_lock_rip == vmcb02->save.rip))
> > 		vmcb02->control.bus_lock_counter = 1;
> > 	else
> > 		vmcb02->control.bus_lock_counter = 0;
> 
> Let's ignore this one.  It's overall a non-issue, and we're already planning on
> moving it out of the control cache.
> 
> > > In other words, AFAICT, nested.ctl.int_ctl is special in that KVM needs it to be
> > > up-to-date at all times, *and* it needs to copied back to vmcb12 (or userspace).
> > 
> > Hmm actually looking at nested.ctl.int_ctl, I don't think it's that special.
> > Most KVM usages are checking "in" bits, i.e. whether some features (e.g.
> > vGIF) are enabled or not.
> >
> > The "out" bits seem to only be consumed by svm_clear_vintr(), and I
> > think this can be worked around.
> 
> OMG that code makes my head hurt.  Isn't that code just this?
> 
> 	/*
> 	 * Drop int_ctl fields related to VINTR injection.  If L2 is active,
> 	 * restore the virtual IRQ flag and its vector from vmcb12 now that KVM
> 	 * is done usurping virtual IRQs for its own purposes.
> 	 */
> 	svm->vmcb01.ptr->control.int_ctl &= ~V_IRQ_INJECTION_BITS_MASK;
> 
> 	if (is_guest_mode(&svm->vcpu)) {
> 		svm->vmcb->control.int_ctl = (svm->vmcb->control.int_ctl & ~V_IRQ_MASK) |
> 					     (svm->nested.ctl.int_ctl & V_IRQ_MASK);

Also V_INTR_PRIO_MASK, I think?

But otherwise yeah I think that's what the function is doing
more-or-less.

> 		svm->vmcb->control.int_vector = svm->nested.ctl.int_vector;
> 	} else {
> 		WARN_ON_ONCE(svm->vmcb != svm->vmcb01.ptr);
> 	}
> 
> 	svm_clr_intercept(svm, INTERCEPT_VINTR);
> 	vmcb_mark_dirty(svm->vmcb, VMCB_INTR);
> 
> > So maybe we don't really need to keep it up-to-date in the cache at all
> > times.
> 
> Yeah, IMO that approach is unnecessarily convoluted.  The actual logic isn't all
> that complex, all of the complexity comes from juggling state between the cache
> and vmcb02 just so that the cache can be authoritative.  Given that we failed
> miserably in actually making the cache authoritative, e.g. see the nested #VMEXIT
> flow, I think we should kill the entire concept and instead maintain an *exact*

When you say *exact* snapshot, do you mean move all the sanitizing logic
recently introduced in __nested_copy_vmcb_control_to_cache() (by Kevin
and myself) to sanitize vmcb02 instead?

That would be annoying. For example, for the intercepts, sanitizing
vmcb02 (but not vmcb12) means that we need to also add checks in the
exit path (i.e. in nested_svm_intercept() or even
vmcb12_is_intercept()), as vmcb12 could have illegal intercepts.

> snapshot of vmcb12's controls, and then make vmcb02 authoritative.  We'll still
> need the logic in nested_sync_control_from_vmcb02() to updated int_ctl on save
> or #VMEXIT if KVM is still intercepting VINTR for its own purposes, but at least
> the code will be contained.

Yeah. We should leave it out of the vmcb12 cache though.

> 
> Then to make it all but impossible to re-introduce this mess, do something like
> this so that someone would have to go way out of their way to try and modify the
> cache.
> 
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index ebd7b36b1ceb..2de6305be9ce 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -199,14 +199,13 @@ struct svm_nested_state {
>          * we cannot inject a nested vmexit yet.  */
>         bool nested_run_pending;
>  
> -       /* cache for control fields of the guest */
> -       struct vmcb_ctrl_area_cached ctl;
> -
>         /*
> -        * Note: this struct is not kept up-to-date while L2 runs; it is only
> -        * valid within nested_svm_vmrun.
> +        * An opaque, read-only cache of vmcb12 controls, used to query L1's
> +        * controls while running L2, e.g. to route intercepts appropriately.
> +        * All reads are routed through accessors to make it all but impossible
> +        * for KVM to clobber its snapshot of vmcb12.
>          */
> -       struct vmcb_save_area_cached save;

Is dropping the cached save area intentional?

We can drop it and make it a local vaiable in nested_svm_vmrun(), and
plumb it all the way down. But it could be too big for the stack.
Allocating it every time isn't nice either.

Do you mean to also make it opaque?

> +       u8 __vmcb12_ctrl[sizeof(struct vmcb_ctrl_area_cached)];

We have a lot of accesses to svm->nested.ctl, so we'll need a lot of
clutter to cast the field in all of these places.

Maybe we add a read-only accessor that returns a pointer to a constant
struct?

>  
>         bool initialized;
> 
> > > Part of me wants to remove these two fields entirely:
> > > 
> > > 	/* cache for control fields of the guest */
> > > 	struct vmcb_ctrl_area_cached ctl;
> > > 
> > > 	/*
> > > 	 * Note: this struct is not kept up-to-date while L2 runs; it is only
> > > 	 * valid within nested_svm_vmrun.
> > > 	 */
> > > 	struct vmcb_save_area_cached save;
> > > 
> > > and instead use "full" caches only for the duration of nested_svm_vmrun().  Or
> > > hell, just copy the entire vmcb12 and throw the cached structures in the garbage.
> > > But that'll probably end in a game of whack-a-mole as things get moved back in.
> > 
> > Yeah, KVM needs to keep some of the fields around :/
> 
> For me, that's totally fine.  As above, the problem I see is that there is no
> single source of truth, i.e. that the authoritative state is spread across vmcb02
> and the cache.
> 
> > > So rather than do something totally drastic, I think we should kill
> > > nested_copy_vmcb_cache_to_control() and replace it with a "save control" flow.
> > > And then have it share code as much code as possible with nested_svm_vmexit(),
> > > and fixup nested_svm_vmexit() to not pull from svm->nested.ctl unnecessarily.
> > > Which, again AFICT, is pretty much limited to int_ctl: either vmcb02 is
> > > authoritative, or KVM shouldn't be updating vmcb12, and so only the "save control"
> > > for KVM_GET_NESTED_STATE needs to copy from the cache to the migrated vmcb12.
> > 
> > I think this works if we draw a clear extinction between "in","out", and
> > "in/out" fields, which is not great because some fields (like int_ctl)
> > have different directions for different bits :/
> > 
> > But if we do draw that distinction, and have helpers that copy fields
> > based on direction, things become more intuitive:
> > 
> > During nested VMRUN, we use the "in" and "in/out" fields from cached
> > vmcb12 to construct vmcb02 through nested_vmcb02_prepare_control().
> > 
> > During save, we save "in" fields from the cached vmcb12, "out" and
> > "in/out" fields from vmcb02.
> > 
> > During restore, we use the "in" and "in/out" fields from the restored
> > payload to construct vmcb02 through nested_vmcb02_prepare_control(), AND
> > update the "out" fields as well from the payload.
> 
> Why the last part?  If L2 is active, then the pure "out" fields are guaranteed
> to be written on nested #VMEXIT.  Anything else simply can't work.

I think it just so happens that all pure "out" fields are consumed by
KVM before save+restore is possible, but it is possible for an "out"
field to be used by KVM at a later point, or copied from vmcb02 to
vmcb12 during nested #VMEXIT (e.g. if KVM exits to L1 directly after
save+restore, before running L2).

next_rip and int_state fall in this bucket, it just happens to also be
an "in" field.

For example, if support for decode assists is added, there will be cases
where KVM just copies insn_bytes from vmcb02 to vmcb12 on nested
#VMEXIT. If insn_bytes is lost on save+restore, and KVM immediately
exits to L1 after restore, insn_bytes is lost.

So we need to also save+restore pure "out" fields, which we do not do
today.

> 
> > During synthesized #VMEXIT, we save the "out" and "in/out" fields from
> > vmcb02 (shared part with save/restore).
> 
> Yeah, that all works.  We could also treat save() as an extension of #VMEXIT, but
> that could make KVM_GET_NESTED_STATE non-idempotent (which might already be the
> case for VMX?).  I.e. we could sync vmcb02 to vmcb12 (cache), and then copy that
> to userspace.

I think this will require adding more fields to the cache, but wait, we
already have a lot of "out" fields there but I don't think they are
being used at all..

Anyway, this may make things simpler. Instead of pulling different
fields from either cached vmcb12 and vmcb02, we always combine them
first. I will keep that in mind.

> 
> > The save/restore changes would need a flag to avoid restoring garbage
> > from an older KVM.
> 
> I don't follow.  I was thinking we'd only change how KVM maintains authoritative
> state while runnign L2, i.e. not make any changes (other than fixes) to the
> serialized state for save/restore.

I thought we're not currently saving "out" fields at all, but
apparently we are, we just do not use them in svm_set_nested_state(). So
we probably do not need a flag. Even if some fields are not currently
copied, I assume KVM restoring garbage from an older KVM is no worse
than having uninitialized garbage :)

I think this will be annoying when new fields are added, like
insn_bytes. Perhaps at some point we move to just serializing the entire
combined vmcb02/vmcb12 control area and add a flag for that.

> 
> > It's also probably not as straightforward as I am making it out to be. For
> > example, "in/out" fields may not be reflected as-is from vmcb12 to vmcb02, so
> > if we save+restore with nested_run_pending, we end up creating vmcb02 on the
> > destination from what we put in vmcb02 in the source, not vmcb12, which may
> > or may not be the right thing to do.
> 
> If that's a problem, we've already messed up.  Because we _must_ get that right
> for nested #VMEXIT, i.e. KVM _must_ be able to extract the pieces of vmcb02 that
> belong to L1 vs. L0.  At a glance, it seems very doable to writ the code so that
> it's shareable between #VMEXIT and save().
> 
> > This is probably a heavier lift than we think it is, or maybe it's
> > simpler once I start coding it :)
> 
> Maybe?  It's certainly not trivial, but I don't think it's terribly complex either,
> at least not what I have in mind.
> 
> > > That'll probably end up a bit fat for a stable@ patch, so we could do a gross
> > > one-off fix for this issue, and then do cleanups on top.
> > 
> > Honestly, I'd rather keep the existing patch for stable@. It's not that
> > complicated, and downstream trees that take it don't have to live with
> > the FIXME code.
> 
> I'd rather omit the FIXME than move the nested_sync_control_from_vmcb02() call.
> Because it's entirely possible that the code movement will apply cleanly to an
> older kernel, but semantically be broken due something in-between consuming
> int_ctl.  The odds of that happening are low, but I don't want to have to audit
> every LTS kernel (or set up others to fail).

That's fair, but I will keep the FIXME. My problem was not the comment,
it was sync'ing that one field outside of
nested_sync_control_from_vmcb02().

> 
> > The heavier lift to clean this up can be done separately,
> 
> Yes, for sure.
> 
> > or I can send a new version with the first 2 patches in the beginning for
> > stable@ and the cleanups on top, depends on how we decide to implement this.
> 
> As above, my preference is to throw in a super minimal fix for next_rip, and then
> commit ourselves to removing nested_sync_control_from_vmcb02() sooner or later.

I will send a v2 with the FIXME fix for next_rip, I assume the int_state
fix in nested_sync_control_from_vmcb02() is fine.

Hopefully I will find time in the coming weeks to work on the broader
cleanup.

> 
> > > > @@ -4435,6 +4424,21 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
> > > >  
> > > >  	svm_complete_interrupts(vcpu);
> > > >  
> > > > +	/*
> > > > +	 * svm_complete_interrupts() may update svm->vmcb->control.next_rip,
> > > > +	 * which is sync'd by nested_sync_control_from_vmcb02() below.
> > > 
> > > Please try to avoid referencing functions and fields in comments.  History has
> > > shown that they almost always become stale.
> > 
> > Generally agree, but in this case I am referencing the calls right above
> > and right below, and it's probably clearer to mention the ordering
> > constraint directly with their names.
> > 
> > That being said, if you feel strongly
> 
> I do.  I appreciate that it requires more effort to write comments that don't
> reference functions/variables/fields, and that it can be downright annoying, but
> we've had far too many orphaned comments over the years.

Ack, will use your FIXME wording as-is.

