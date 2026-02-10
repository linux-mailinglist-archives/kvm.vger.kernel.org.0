Return-Path: <kvm+bounces-70768-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AHbrG0dci2mYUAAAu9opvQ
	(envelope-from <kvm+bounces-70768-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 17:26:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C23A711D25F
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 17:26:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A6C4F3051D0B
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:26:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48897389E07;
	Tue, 10 Feb 2026 16:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="M3jyYGUF"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D3F38885B
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 16:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770740773; cv=none; b=DKtX/i+S7jale4xoyH6K4daMgjQYck9vpkGr9CLaY2G83JYjhXsAdPPr8ZADfc9b9igTJ/GxNq/uZ1+ROHboAVz71F6Fs7GMuMbwTUgopgqNwVLfdvm0O4yWD6Ao7ipJLpjS6kUqVQEytfUp8H2osv7lSPHMm31UpVPwMjFdU7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770740773; c=relaxed/simple;
	bh=IRtNdHJUYXvudf2IbFhxByVidZ3yhKOJyab21cQnVN0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aMRqqL6Hn+5203ewdSMviA/PYUxK/7Dxj6uBo8bFHZ3Kit466+z01KuPrMjsPlCdeO1Klhf8JEVJqr+03mgv22fNfOds6kN4SYg9IKFYYBxcpFhHTHvRe3AN0I5shqs1WcXS5PqDOLe2aUhK1Mp4Kw+xWdS7Wj+QEpIRqtcyyrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=M3jyYGUF; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 10 Feb 2026 16:25:45 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770740759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pX2jQUgUQMkczRIpbux/k20EVOaSPs5F20Z5EnM9clw=;
	b=M3jyYGUFes3lHUjECO0bwxqgAhLgjLFmmzfvyJjmV7LtAZ9pCvm1tASWdnkMOMUpLlGz6h
	fm3kQCfMXZ/ZNQUSYTJf03Gtpf0QaO6pkaAF5nPu+YT8Kx4Qk8Dhm+hbTzH8jHHoYBRC2h
	M8uykBhB7fGuqXBQsqenlUU/kq8v6zU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/4] KVM: nSVM: Sync next_rip to cached vmcb12 after
 VMRUN of L2
Message-ID: <4g25s35ty23lx2je4aknn6dg4ohviqhkbvvel4wkc4chhgp6af@kbqz3lnezo3j>
References: <20260210005449.3125133-1-yosry.ahmed@linux.dev>
 <20260210005449.3125133-2-yosry.ahmed@linux.dev>
 <aYqOkvHs3L-AX-CG@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYqOkvHs3L-AX-CG@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70768-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,linux.dev:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C23A711D25F
X-Rspamd-Action: no action

On Mon, Feb 09, 2026 at 05:49:06PM -0800, Sean Christopherson wrote:
> On Tue, Feb 10, 2026, Yosry Ahmed wrote:
> > After VMRUN in guest mode, nested_sync_control_from_vmcb02() syncs
> > fields written by the CPU from vmcb02 to the cached vmcb12. This is
> > because the cached vmcb12 is used as the authoritative copy of some of
> > the controls, and is the payload when saving/restoring nested state.
> > 
> > next_rip is also written by the CPU (in some cases) after VMRUN, but is
> > not sync'd to cached vmcb12. As a result, it is corrupted after
> > save/restore (replaced by the original value written by L1 on nested
> > VMRUN). This could cause problems for both KVM (e.g. when injecting a
> > soft IRQ) or L1 (e.g. when using next_rip to advance RIP after emulating
> > an instruction).
> > 
> > Fix this by sync'ing next_rip in nested_sync_control_from_vmcb02(). Move
> > the call to nested_sync_control_from_vmcb02() (and the entire
> > is_guest_mode() block) after svm_complete_interrupts(), as it may update
> > next_rip in vmcb02.
> 
> I'll give you one guess as to what I would say about bundling changes.  AFAICT,
> there is _zero_ reason to move the call nested_sync_control_from_vmcb02() in a
> patch tagged for stable@.

I generally agree with your previous feedback about combining changes,
but I think I disagree for this specific instance. I did actually have
two separate changes: one to move the call to
nested_sync_control_from_vmcb02() (still tagged for stable@), and one to
add next_rip.

However, I found myself explaining a lot of the next_rip context in the
commit log of moving nested_sync_control_from_vmcb02(), to explain why
it specifically needed to go after svm_complete_interrupts(). Also, I
had to add the comment above the call to
nested_sync_control_from_vmcb02() in the patch adding next_rip to it.

Looking at both patches, it made more sense to combine them given their
tight connection and simplicity. The history is clearer when the move,
comment, and next_rip addition are bundled.

Or..

Did you mean to have a patch that just copied next_rip outside of
nested_sync_control_from_vmcb02(), after svm_complete_interrupts(), for
stable@, and then clean it up on top? Eh, not a big fan of that either
because the current patch is simple enough for stable@ imo.

> 
> > Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE")
> > CC: stable@vger.kernel.org
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  arch/x86/kvm/svm/nested.c |  6 ++++--
> >  arch/x86/kvm/svm/svm.c    | 26 +++++++++++++++-----------
> >  2 files changed, 19 insertions(+), 13 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index de90b104a0dd..70086ba6497f 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -519,8 +519,10 @@ void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
> >  void nested_sync_control_from_vmcb02(struct vcpu_svm *svm)
> >  {
> >  	u32 mask;
> > -	svm->nested.ctl.event_inj      = svm->vmcb->control.event_inj;
> > -	svm->nested.ctl.event_inj_err  = svm->vmcb->control.event_inj_err;
> > +
> > +	svm->nested.ctl.event_inj	= svm->vmcb->control.event_inj;
> > +	svm->nested.ctl.event_inj_err	= svm->vmcb->control.event_inj_err;
> > +	svm->nested.ctl.next_rip	= svm->vmcb->control.next_rip;
> 
> This is all a mess (the existing code).  nested_svm_vmexit() does this:
> 
> 	vmcb12->control.int_state         = vmcb02->control.int_state;
> 	vmcb12->control.exit_code         = vmcb02->control.exit_code;
> 	vmcb12->control.exit_info_1       = vmcb02->control.exit_info_1;
> 	vmcb12->control.exit_info_2       = vmcb02->control.exit_info_2;
> 
> 	if (!svm_is_vmrun_failure(vmcb12->control.exit_code))
> 		nested_save_pending_event_to_vmcb12(svm, vmcb12);
> 
> 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
> 		vmcb12->control.next_rip  = vmcb02->control.next_rip;
> 
> 	vmcb12->control.int_ctl           = svm->nested.ctl.int_ctl;
> 	vmcb12->control.event_inj         = svm->nested.ctl.event_inj;
> 	vmcb12->control.event_inj_err     = svm->nested.ctl.event_inj_err;
> 
> but then svm_get_nested_state(), by way of nested_copy_vmcb_cache_to_control(),
> pulls everything from the cached fields.  Which probably only works because the
> only fields that are pulled from vmcb02 nested_svm_vmexit() are never modified
> by the CPU.

Yeah I think that's the key. The main distinction is whether fields
are"in", "out" or "in/out" fields. I wish those were more clearly
separated by the APM. More below.

> 
> Actually, I take that back, I have no idea how this code works.  How does e.g.
> exit_info_1 not get clobbered on save/restore?

I *think* KVM always sets the error_code and exit_info_* fields before
synthesizing a #VMEXIT to L1, usually right before calling
nested_svm_vmeit(), so no chance for save/restore in between.

I think generally, most "out" fields are consumed by KVM before
userspace can save/restore, hence them getting lost on save/restore is
fine?

It's still probably worse than we think, I see
svm->nested.ctl.bus_lock_rip is not saved/restored, because it's not
part of the VMCB. So in
svm_set_nested_state()->nested_vmcb02_prepare_control() we end up
comparing garbage to garbage (because vmcb02->save.rip is also wrong):

	if (vmcb02->save.rip && (svm->nested.ctl.bus_lock_rip == vmcb02->save.rip))
		vmcb02->control.bus_lock_counter = 1;
	else
		vmcb02->control.bus_lock_counter = 0;

> 
> In other words, AFAICT, nested.ctl.int_ctl is special in that KVM needs it to be
> up-to-date at all times, *and* it needs to copied back to vmcb12 (or userspace).

Hmm actually looking at nested.ctl.int_ctl, I don't think it's that
special. Most KVM usages are checking "in" bits, i.e. whether some
features (e.g. vGIF) are enabled or not.

The "out" bits seem to only be consumed by svm_clear_vintr(), and I
think this can be worked around.

So maybe we don't really need to keep it up-to-date in the cache at all
times.

> 
> Part of me wants to remove these two fields entirely:
> 
> 	/* cache for control fields of the guest */
> 	struct vmcb_ctrl_area_cached ctl;
> 
> 	/*
> 	 * Note: this struct is not kept up-to-date while L2 runs; it is only
> 	 * valid within nested_svm_vmrun.
> 	 */
> 	struct vmcb_save_area_cached save;
> 
> and instead use "full" caches only for the duration of nested_svm_vmrun().  Or
> hell, just copy the entire vmcb12 and throw the cached structures in the garbage.
> But that'll probably end in a game of whack-a-mole as things get moved back in.

Yeah, KVM needs to keep some of the fields around :/

> 
> So rather than do something totally drastic, I think we should kill
> nested_copy_vmcb_cache_to_control() and replace it with a "save control" flow.
> And then have it share code as much code as possible with nested_svm_vmexit(),
> and fixup nested_svm_vmexit() to not pull from svm->nested.ctl unnecessarily.
> Which, again AFICT, is pretty much limited to int_ctl: either vmcb02 is
> authoritative, or KVM shouldn't be updating vmcb12, and so only the "save control"
> for KVM_GET_NESTED_STATE needs to copy from the cache to the migrated vmcb12.

I think this works if we draw a clear extinction between "in","out", and
"in/out" fields, which is not great because some fields (like int_ctl)
have different directions for different bits :/

But if we do draw that distinction, and have helpers that copy fields
based on direction, things become more intuitive:

During nested VMRUN, we use the "in" and "in/out" fields from cached
vmcb12 to construct vmcb02 through nested_vmcb02_prepare_control().

During save, we save "in" fields from the cached vmcb12, "out" and
"in/out" fields from vmcb02.

During restore, we use the "in" and "in/out" fields from the restored
payload to construct vmcb02 through nested_vmcb02_prepare_control(), AND
update the "out" fields as well from the payload.

During synthesized #VMEXIT, we save the "out" and "in/out" fields from
vmcb02 (shared part with save/restore).

The save/restore changes would need a flag to avoid restoring garbage
from an older KVM. It's also probably not as straightforward as I am
making it out to be. For example, "in/out" fields may not be reflected
as-is from vmcb12 to vmcb02, so if we save+restore with
nested_run_pending, we end up creating vmcb02 on the destination from
what we put in vmcb02 in the source, not vmcb12, which may or may not be
the right thing to do.

This is probably a heavier lift than we think it is, or maybe it's
simpler once I start coding it :)

> 
> That'll probably end up a bit fat for a stable@ patch, so we could do a gross
> one-off fix for this issue, and then do cleanups on top.

Honestly, I'd rather keep the existing patch for stable@. It's not that
complicated, and downstream trees that take it don't have to live with
the FIXME code.

The heavier lift to clean this up can be done separately, or I can send
a new version with the first 2 patches in the beginning for stable@ and
the cleanups on top, depends on how we decide to implement this.

> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 5f0136dbdde6..cd5664c65a00 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4435,6 +4435,16 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
>  
>         svm_complete_interrupts(vcpu);
>  
> +       /*
> +        * Update the cache after completing interrupts to get an accurate
> +        * NextRIP, e.g. when re-injecting a soft interrupt.
> +        *
> +        * FIXME: Rework svm_get_nested_state() to not pull data from the
> +        *        cache (except for maybe int_ctl).
> +        */
> +       if (is_guest_mode(vcpu))
> +               svm->nested.ctl.next_rip = svm->vmcb->control.next_rip;
> +
>         return svm_exit_handlers_fastpath(vcpu);
>  }
>  
> >  	/* Only a few fields of int_ctl are written by the processor.  */
> >  	mask = V_IRQ_MASK | V_TPR_MASK;
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 5f0136dbdde6..6d8d4d19455e 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -4399,17 +4399,6 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
> >  	sync_cr8_to_lapic(vcpu);
> >  
> >  	svm->next_rip = 0;
> > -	if (is_guest_mode(vcpu)) {
> > -		nested_sync_control_from_vmcb02(svm);
> > -
> > -		/* Track VMRUNs that have made past consistency checking */
> > -		if (svm->nested.nested_run_pending &&
> > -		    !svm_is_vmrun_failure(svm->vmcb->control.exit_code))
> > -                        ++vcpu->stat.nested_run;
> > -
> > -		svm->nested.nested_run_pending = 0;
> > -	}
> > -
> >  	svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
> >  
> >  	/*
> > @@ -4435,6 +4424,21 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
> >  
> >  	svm_complete_interrupts(vcpu);
> >  
> > +	/*
> > +	 * svm_complete_interrupts() may update svm->vmcb->control.next_rip,
> > +	 * which is sync'd by nested_sync_control_from_vmcb02() below.
> 
> Please try to avoid referencing functions and fields in comments.  History has
> shown that they almost always become stale.

Generally agree, but in this case I am referencing the calls right above
and right below, and it's probably clearer to mention the ordering
constraint directly with their names.

That being said, if you feel strongly I can probably do sth like your
suggestion above:

	/*
	 * Only sync fields from vmcb02 to cache after completing
	 * interrupts, as NextRIP may be updated (e.g. when re-injecting a
	 * soft interrupt).
	 */

> 
> > +	 */
> > +	if (is_guest_mode(vcpu)) {
> > +		nested_sync_control_from_vmcb02(svm);
> > +
> > +		/* Track VMRUNs that have made past consistency checking */
> > +		if (svm->nested.nested_run_pending &&
> > +		    !svm_is_vmrun_failure(svm->vmcb->control.exit_code))
> > +			++vcpu->stat.nested_run;
> > +
> > +		svm->nested.nested_run_pending = 0;
> > +	}
> > +
> >  	return svm_exit_handlers_fastpath(vcpu);
> >  }
> >  
> > 
> > base-commit: e944fe2c09f405a2e2d147145c9b470084bc4c9a
> > -- 
> > 2.53.0.rc2.204.g2597b5adb4-goog
> > 

