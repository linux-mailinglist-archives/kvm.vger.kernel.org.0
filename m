Return-Path: <kvm+bounces-70815-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2DkEHAvNi2n7bAAAu9opvQ
	(envelope-from <kvm+bounces-70815-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 01:27:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E5A951204EF
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 01:27:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 565FA30470BD
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 00:27:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 967991F1313;
	Wed, 11 Feb 2026 00:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nHOv2zsE"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C7E1D5146
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 00:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770769671; cv=none; b=jwZDJRX+VK1kqMSEOs+aQUFIn9ZH3avcHI7Is1ZfU7sIe3EUuJcBaljNI/D4Jo+at+wIrSLsKOvR12Bu1Kb+0rzPEomwHP1x9VGtRWZnHGgR8gmexoSLMNUh5SRW1bW9Hlpp0mThVmN+Yah3NcC3dnDNMu3gDw4uIIEx2RfbIXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770769671; c=relaxed/simple;
	bh=IyJ3mchRY7Y2KfTwDrgeA8vewyq3CgYxsmkfTP8yjvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CG5iNJYrThiZJaRaqnhjIhGUtO/v8lDMkMAQzLeOJjvPMkZj0CS+a+7jLMRcsNcjeCJOaDsQ1p3qqDgIEx5U7zwWt+CZNzUzgrJSJa4cSMWRS2U6+uoz6wexqFtR801NwAF5Ag+8IEHEoF4TOUdsC6EnwGIRydd4fs5lySpXhns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nHOv2zsE; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 11 Feb 2026 00:27:42 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770769667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZnfkFILTVEYTXBExT5Rd0G9yYSXnmSE5Hnr/APufnB0=;
	b=nHOv2zsEgfQg5SMgcNRiCWCpdXktqW92cHAtzXLuCMAE5xGakUQ2oH5d4Qh6QyO+odxe3n
	uKGKRTu7Tal+eATcg8Fpv4lneOBZ3WlI/Uhm5FbNxgWDz7c24cZJlPimtcuSJxa2/M0hSc
	HkV+BlsOeqPzuimenalXF6hW6CLRTBw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/4] KVM: nSVM: Sync next_rip to cached vmcb12 after
 VMRUN of L2
Message-ID: <mxn6y6og34ejncnsvdapcoep4ewcnwnheszhwkp2undkqcu5zv@bpmseexuug5z>
References: <20260210005449.3125133-1-yosry.ahmed@linux.dev>
 <20260210005449.3125133-2-yosry.ahmed@linux.dev>
 <aYqOkvHs3L-AX-CG@google.com>
 <4g25s35ty23lx2je4aknn6dg4ohviqhkbvvel4wkc4chhgp6af@kbqz3lnezo3j>
 <aYuE8xQdE5pQrmUs@google.com>
 <ck57mmdt5phh64cadoqxylw5q2b72ffmabmlzmpphaf27lbtxw@4kscovf6ahve>
 <aYvIpwjsJ50Ns4ho@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYvIpwjsJ50Ns4ho@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70815-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E5A951204EF
X-Rspamd-Action: no action

 
> > > > > In other words, AFAICT, nested.ctl.int_ctl is special in that KVM needs it to be
> > > > > up-to-date at all times, *and* it needs to copied back to vmcb12 (or userspace).
> > > > 
> > > > Hmm actually looking at nested.ctl.int_ctl, I don't think it's that special.
> > > > Most KVM usages are checking "in" bits, i.e. whether some features (e.g.
> > > > vGIF) are enabled or not.
> > > >
> > > > The "out" bits seem to only be consumed by svm_clear_vintr(), and I
> > > > think this can be worked around.
> > > 
> > > OMG that code makes my head hurt.  Isn't that code just this?
> > > 
> > > 	/*
> > > 	 * Drop int_ctl fields related to VINTR injection.  If L2 is active,
> > > 	 * restore the virtual IRQ flag and its vector from vmcb12 now that KVM
> > > 	 * is done usurping virtual IRQs for its own purposes.
> > > 	 */
> > > 	svm->vmcb01.ptr->control.int_ctl &= ~V_IRQ_INJECTION_BITS_MASK;
> > > 
> > > 	if (is_guest_mode(&svm->vcpu)) {
> > > 		svm->vmcb->control.int_ctl = (svm->vmcb->control.int_ctl & ~V_IRQ_MASK) |
> > > 					     (svm->nested.ctl.int_ctl & V_IRQ_MASK);
> > 
> > Also V_INTR_PRIO_MASK, I think?
> 
> Ugh, yes.  And I think V_IGN_TPR as well?  I can't tell if that's a bug or not.
> It looks like a bug.  AFAICT, svm_set_vintr() uses whatever V_IGN_TPR_MASK value
> happens to be in vmcb02.  I don't see how that can be desirable.

Yeah I assumed that's not a bug (for some reason), in which case
restoring V_IGN_TPR_MASK is not needed.

> 
> > But otherwise yeah I think that's what the function is doing
> > more-or-less.
> > 
> > > 		svm->vmcb->control.int_vector = svm->nested.ctl.int_vector;
> > > 	} else {
> > > 		WARN_ON_ONCE(svm->vmcb != svm->vmcb01.ptr);
> > > 	}
> > > 
> > > 	svm_clr_intercept(svm, INTERCEPT_VINTR);
> > > 	vmcb_mark_dirty(svm->vmcb, VMCB_INTR);
> > > 
> > > > So maybe we don't really need to keep it up-to-date in the cache at all
> > > > times.
> > > 
> > > Yeah, IMO that approach is unnecessarily convoluted.  The actual logic isn't all
> > > that complex, all of the complexity comes from juggling state between the cache
> > > and vmcb02 just so that the cache can be authoritative.  Given that we failed
> > > miserably in actually making the cache authoritative, e.g. see the nested #VMEXIT
> > > flow, I think we should kill the entire concept and instead maintain an *exact*
> > 
> > When you say *exact* snapshot, do you mean move all the sanitizing logic
> > recently introduced in __nested_copy_vmcb_control_to_cache() (by Kevin
> > and myself) to sanitize vmcb02 instead?
> 
> Oh, no, not _that_ exact.  More "unchanged after emulated VMRUN"

Whew.

> > > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > > index ebd7b36b1ceb..2de6305be9ce 100644
> > > --- a/arch/x86/kvm/svm/svm.h
> > > +++ b/arch/x86/kvm/svm/svm.h
> > > @@ -199,14 +199,13 @@ struct svm_nested_state {
> > >          * we cannot inject a nested vmexit yet.  */
> > >         bool nested_run_pending;
> > >  
> > > -       /* cache for control fields of the guest */
> > > -       struct vmcb_ctrl_area_cached ctl;
> > > -
> > >         /*
> > > -        * Note: this struct is not kept up-to-date while L2 runs; it is only
> > > -        * valid within nested_svm_vmrun.
> > > +        * An opaque, read-only cache of vmcb12 controls, used to query L1's
> > > +        * controls while running L2, e.g. to route intercepts appropriately.
> > > +        * All reads are routed through accessors to make it all but impossible
> > > +        * for KVM to clobber its snapshot of vmcb12.
> > >          */
> > > -       struct vmcb_save_area_cached save;
> > 
> > Is dropping the cached save area intentional?
> 
> Yes, I think we should try to drop it.  Assuming the comment is correct and it
> really only 
> 
> > We can drop it and make it a local vaiable in nested_svm_vmrun(), and
> > plumb it all the way down. But it could be too big for the stack.
> 
> It's 48 bytes, there's no way that's too big.

That's before my hardening series shoved everything in there. It's now
256 bytes, which is not huge, but makes me nervous. Especially that it
may grow more in the future.

> > Allocating it every time isn't nice either.
> 
> > Do you mean to also make it opaque?
> 
> I'd prefer to drop it.

Me too, but I am nervous about putting it on the stack.

> 
> > > +       u8 __vmcb12_ctrl[sizeof(struct vmcb_ctrl_area_cached)];
> > 
> > We have a lot of accesses to svm->nested.ctl, so we'll need a lot of
> > clutter to cast the field in all of these places.
> > 
> > Maybe we add a read-only accessor that returns a pointer to a constant
> > struct?
> 
> That's what I said :-D
> 
> 	* All reads are routed through accessors to make it all but impossible
> 	* for KVM to clobber its snapshot of vmcb12.
> 
> There might be a lot of helpers, but I bet it's less than nVMX has for vmcs12.

Oh I meant instead of having a lot of helpers, have a single helper that
returns it as a pointer to const struct vmcb_ctrl_area_cached? Then all
current users just switch to the helper instead of directly using
svm->nested.ctl.

We can even name it sth more intuitive like svm_cached_vmcb12_control().

> 
> > >         bool initialized;
> > > 
> > > > > Part of me wants to remove these two fields entirely:
> > > > > 
> > > > > 	/* cache for control fields of the guest */
> > > > > 	struct vmcb_ctrl_area_cached ctl;
> > > > > 
> > > > > 	/*
> > > > > 	 * Note: this struct is not kept up-to-date while L2 runs; it is only
> > > > > 	 * valid within nested_svm_vmrun.
> > > > > 	 */
> > > > > 	struct vmcb_save_area_cached save;
> > > > > 
> > > > > and instead use "full" caches only for the duration of nested_svm_vmrun().  Or
> > > > > hell, just copy the entire vmcb12 and throw the cached structures in the garbage.
> > > > > But that'll probably end in a game of whack-a-mole as things get moved back in.
> > > > 
> > > > Yeah, KVM needs to keep some of the fields around :/
> > > 
> > > For me, that's totally fine.  As above, the problem I see is that there is no
> > > single source of truth, i.e. that the authoritative state is spread across vmcb02
> > > and the cache.
> > > 
> > > > > So rather than do something totally drastic, I think we should kill
> > > > > nested_copy_vmcb_cache_to_control() and replace it with a "save control" flow.
> > > > > And then have it share code as much code as possible with nested_svm_vmexit(),
> > > > > and fixup nested_svm_vmexit() to not pull from svm->nested.ctl unnecessarily.
> > > > > Which, again AFICT, is pretty much limited to int_ctl: either vmcb02 is
> > > > > authoritative, or KVM shouldn't be updating vmcb12, and so only the "save control"
> > > > > for KVM_GET_NESTED_STATE needs to copy from the cache to the migrated vmcb12.
> > > > 
> > > > I think this works if we draw a clear extinction between "in","out", and
> > > > "in/out" fields, which is not great because some fields (like int_ctl)
> > > > have different directions for different bits :/
> > > > 
> > > > But if we do draw that distinction, and have helpers that copy fields
> > > > based on direction, things become more intuitive:
> > > > 
> > > > During nested VMRUN, we use the "in" and "in/out" fields from cached
> > > > vmcb12 to construct vmcb02 through nested_vmcb02_prepare_control().
> > > > 
> > > > During save, we save "in" fields from the cached vmcb12, "out" and
> > > > "in/out" fields from vmcb02.
> > > > 
> > > > During restore, we use the "in" and "in/out" fields from the restored
> > > > payload to construct vmcb02 through nested_vmcb02_prepare_control(), AND
> > > > update the "out" fields as well from the payload.
> > > 
> > > Why the last part?  If L2 is active, then the pure "out" fields are guaranteed
> > > to be written on nested #VMEXIT.  Anything else simply can't work.
> > 
> > I think it just so happens that all pure "out" fields are consumed by
> > KVM before save+restore is possible, but it is possible for an "out"
> > field to be used by KVM at a later point, or copied from vmcb02 to
> > vmcb12 during nested #VMEXIT (e.g. if KVM exits to L1 directly after
> > save+restore, before running L2).
> 
> Ya.
> 
> > next_rip and int_state fall in this bucket, it just happens to also be
> > an "in" field.
> > 
> > For example, if support for decode assists is added, there will be cases
> > where KVM just copies insn_bytes from vmcb02 to vmcb12 on nested
> > #VMEXIT. If insn_bytes is lost on save+restore, and KVM immediately
> > exits to L1 after restore, insn_bytes is lost.
> > 
> > So we need to also save+restore pure "out" fields, which we do not do
> > today.
> 
> Hmm, strictly speaking, no.  We'd be fixing a bug that doesn't exist, yet.  But
> the word yet...
> 
> > > > During synthesized #VMEXIT, we save the "out" and "in/out" fields from
> > > > vmcb02 (shared part with save/restore).
> > > 
> > > Yeah, that all works.  We could also treat save() as an extension of #VMEXIT, but
> > > that could make KVM_GET_NESTED_STATE non-idempotent (which might already be the
> > > case for VMX?).  I.e. we could sync vmcb02 to vmcb12 (cache), and then copy that
> > > to userspace.
> > 
> > I think this will require adding more fields to the cache, but wait, we
> > already have a lot of "out" fields there but I don't think they are
> > being used at all..
> > 
> > Anyway, this may make things simpler. Instead of pulling different
> > fields from either cached vmcb12 and vmcb02, we always combine them
> > first. I will keep that in mind.
> > 
> > > 
> > > > The save/restore changes would need a flag to avoid restoring garbage
> > > > from an older KVM.
> > > 
> > > I don't follow.  I was thinking we'd only change how KVM maintains authoritative
> > > state while runnign L2, i.e. not make any changes (other than fixes) to the
> > > serialized state for save/restore.
> > 
> > I thought we're not currently saving "out" fields at all, but
> > apparently we are, we just do not use them in svm_set_nested_state(). So
> > we probably do not need a flag. Even if some fields are not currently
> > copied, I assume KVM restoring garbage from an older KVM is no worse
> > than having uninitialized garbage :)
> 
> Heh, yep.
> 
> > I think this will be annoying when new fields are added, like
> > insn_bytes. Perhaps at some point we move to just serializing the entire
> > combined vmcb02/vmcb12 control area and add a flag for that.
> 
> If we do it now, can we avoid the flag?

I don't think so. Fields like insn_bytes are not currently serialized at
all. The moment we need them, we'll probably need to add a flag, at
which point serializing everything under the flag would probably be the
sane thing to do.

That being said, I don't really know how a KVM that uses insn_bytes
should handle restoring from an older KVM that doesn't serialize it :/

Problem for the future, I guess :)

