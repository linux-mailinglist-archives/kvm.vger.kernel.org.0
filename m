Return-Path: <kvm+bounces-70814-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6BxpFLfIi2kwbAAAu9opvQ
	(envelope-from <kvm+bounces-70814-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 01:09:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CE4681203A9
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 01:09:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9984630557DF
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 00:09:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3EB51427A;
	Wed, 11 Feb 2026 00:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VXLdUAYV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5CF1FC8
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 00:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770768555; cv=none; b=d3hA99w170vwyBQAOYtQNjkQmwNTkEvwRg6LOHJF3Y+AUHwE0ZPJVFaBQd5eu7p2CWm01+qtadYPfG0/cbDw+jRh3RAPSoYh7qETqB7tmIpzcrxPYgDta6n3LQTGuANJmbPwMb5brpgk5RzkVgzHrTktxENJky9pxCdq1olcfNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770768555; c=relaxed/simple;
	bh=VMRGazPTLTcwKF21VG5B6p+oJVF9pwEE/p215VYQItk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fS/pSWxqxTq0Rcql10JHyCWsoVjFA5HZvUGXLemZWGUYZQ7TgE9TAFJMkWRzx3ky4CXWT2vu59P1PkxNpGPTJpS7Zicxb6tuaP02ThVh1D0fD7Jx49w3Kwl+/WNqBagdWultyta3SPQp2AfcFUGFQTDIX2KfvGOL9j2eSf4GY3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VXLdUAYV; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-81f48cec0ccso5653241b3a.0
        for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 16:09:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770768553; x=1771373353; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=w2fRs8crS9fOJGsOa5fG7r9GR4L1iAYavcsR08Hvs4w=;
        b=VXLdUAYVU8goA2oW5Ame2za12nMJxhZarkHu+H6xRuPlixGr2YuNJgPrVMogJePNUA
         lerQ8cD7RAq/8MafCrdf9p5cuNdnXXaa1jQaPxnlGVt09RB+nMODo7ya6CTbhdAmk+W9
         5ViDMbvb7xazEjB+li45RmQIm8N5trqY3P/ytnTV+vBsLhxZCvSFqov0m/xsog0/uhPS
         5m9NFHSPVX5hLjhvZh5WHF2PDcJJCE0P7Qm5a2v6JPaQK/pY7ftZN9xc9fTMlLIH0Akq
         LRWLUIdjeJm1pwxHo6Scn8HVdWSeM+Dp1h84iu81LZHuIieFHg7T9cYPqdMatahVvpT1
         aOUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770768553; x=1771373353;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w2fRs8crS9fOJGsOa5fG7r9GR4L1iAYavcsR08Hvs4w=;
        b=qBaqrHbwJBBaTwZYVu4mOVk+Fryjl/1lpgZq7TLQ1/m+1oi5mnhHl2F4KBRR56cX1W
         FtE4kIuDztVyn58NKAVSiz9lumNAivoDewXGxBgqjLmB8a1/6LxeaN3hHGgCUSmDPVTe
         x9nuCdPVHeKN9lhPvo/X0R2yfinbnaYjLvGts1GCklIMpaf5AjwyYTj1oQ9uomqgU0jt
         MrkrQE/1l+9nQH2GC2W2BvmZSmtRy7r5hP5cGtF85pMF6iZG0g6FVCNK+saIIAGx0xAt
         kv8rQfjS/ffvENN24JySeRvtemDaVDqfD+O1Rosm/zUXzW1qraZdCtP+Z/HZoiAvdZ42
         VSWw==
X-Forwarded-Encrypted: i=1; AJvYcCUrOLoEeOZlsOWCp73qaNdI/YnEGSLPQJY/4NJWLPNSXOsW3aD/4E/n6sRd5IZUV82Qea4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMf8YpIU6EWrmgvLTv1jsBXiZ7ylS4UP14HGjazholaBhpWUez
	At8i0ntQJ2+RuY8+uEn9zVG/n0zJFOkHy3DJzbmkLUAhLWscGkEeyWvNAEQj194gdJGR5mlkJXF
	M/NlATg==
X-Received: from pfn9.prod.google.com ([2002:a05:6a00:a209:b0:821:8690:e783])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:10c3:b0:81f:9a5b:e8fc
 with SMTP id d2e1a72fcca58-8249fdce3a7mr39456b3a.54.1770768552951; Tue, 10
 Feb 2026 16:09:12 -0800 (PST)
Date: Tue, 10 Feb 2026 16:09:11 -0800
In-Reply-To: <ck57mmdt5phh64cadoqxylw5q2b72ffmabmlzmpphaf27lbtxw@4kscovf6ahve>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260210005449.3125133-1-yosry.ahmed@linux.dev>
 <20260210005449.3125133-2-yosry.ahmed@linux.dev> <aYqOkvHs3L-AX-CG@google.com>
 <4g25s35ty23lx2je4aknn6dg4ohviqhkbvvel4wkc4chhgp6af@kbqz3lnezo3j>
 <aYuE8xQdE5pQrmUs@google.com> <ck57mmdt5phh64cadoqxylw5q2b72ffmabmlzmpphaf27lbtxw@4kscovf6ahve>
Message-ID: <aYvIpwjsJ50Ns4ho@google.com>
Subject: Re: [PATCH 1/4] KVM: nSVM: Sync next_rip to cached vmcb12 after VMRUN
 of L2
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70814-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CE4681203A9
X-Rspamd-Action: no action

On Tue, Feb 10, 2026, Yosry Ahmed wrote:
> On Tue, Feb 10, 2026 at 11:20:19AM -0800, Sean Christopherson wrote:
> > > > Actually, I take that back, I have no idea how this code works.  How does e.g.
> > > > exit_info_1 not get clobbered on save/restore?
> > > 
> > > I *think* KVM always sets the error_code and exit_info_* fields before
> > > synthesizing a #VMEXIT to L1, usually right before calling
> > > nested_svm_vmeit(), so no chance for save/restore in between.
> > 
> > Ugh, right, KVM generally doesn't recognize signals until after invoking the exit
> > handler.  Actually, even that isn't the key, it's that this flaw only affects
> > "in/out" fields, as you note above.  Heh, and even that probably isn't entirely
> > precise, as it's really "in/out fields that KVM consumes while running L2 are
> > buggy".  E.g. in this case, nested_vmcb02_prepare_control() pulls next_rip for
> > vmcb02 from the cache.
> > 
> > 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
> > 		vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
> > 	else if (boot_cpu_has(X86_FEATURE_NRIPS))
> > 		vmcb02->control.next_rip    = vmcb12_rip;
> 
> Hmm I thin a pure "out" field would be affected if it's consumed by KVM
> later on, after save+restore is possible, right?

True.

> Do you mean that it just happens that the currently affected fields are
> "in/out" fields? Or is there a reason why pure "out" fields cannot be
> affected? AFAICT, these fields are lost after save+restore.

I was essentially assuming KVM wouldn't ever consume pure out fields from the
cache.


> > > > In other words, AFAICT, nested.ctl.int_ctl is special in that KVM needs it to be
> > > > up-to-date at all times, *and* it needs to copied back to vmcb12 (or userspace).
> > > 
> > > Hmm actually looking at nested.ctl.int_ctl, I don't think it's that special.
> > > Most KVM usages are checking "in" bits, i.e. whether some features (e.g.
> > > vGIF) are enabled or not.
> > >
> > > The "out" bits seem to only be consumed by svm_clear_vintr(), and I
> > > think this can be worked around.
> > 
> > OMG that code makes my head hurt.  Isn't that code just this?
> > 
> > 	/*
> > 	 * Drop int_ctl fields related to VINTR injection.  If L2 is active,
> > 	 * restore the virtual IRQ flag and its vector from vmcb12 now that KVM
> > 	 * is done usurping virtual IRQs for its own purposes.
> > 	 */
> > 	svm->vmcb01.ptr->control.int_ctl &= ~V_IRQ_INJECTION_BITS_MASK;
> > 
> > 	if (is_guest_mode(&svm->vcpu)) {
> > 		svm->vmcb->control.int_ctl = (svm->vmcb->control.int_ctl & ~V_IRQ_MASK) |
> > 					     (svm->nested.ctl.int_ctl & V_IRQ_MASK);
> 
> Also V_INTR_PRIO_MASK, I think?

Ugh, yes.  And I think V_IGN_TPR as well?  I can't tell if that's a bug or not.
It looks like a bug.  AFAICT, svm_set_vintr() uses whatever V_IGN_TPR_MASK value
happens to be in vmcb02.  I don't see how that can be desirable.

> But otherwise yeah I think that's what the function is doing
> more-or-less.
> 
> > 		svm->vmcb->control.int_vector = svm->nested.ctl.int_vector;
> > 	} else {
> > 		WARN_ON_ONCE(svm->vmcb != svm->vmcb01.ptr);
> > 	}
> > 
> > 	svm_clr_intercept(svm, INTERCEPT_VINTR);
> > 	vmcb_mark_dirty(svm->vmcb, VMCB_INTR);
> > 
> > > So maybe we don't really need to keep it up-to-date in the cache at all
> > > times.
> > 
> > Yeah, IMO that approach is unnecessarily convoluted.  The actual logic isn't all
> > that complex, all of the complexity comes from juggling state between the cache
> > and vmcb02 just so that the cache can be authoritative.  Given that we failed
> > miserably in actually making the cache authoritative, e.g. see the nested #VMEXIT
> > flow, I think we should kill the entire concept and instead maintain an *exact*
> 
> When you say *exact* snapshot, do you mean move all the sanitizing logic
> recently introduced in __nested_copy_vmcb_control_to_cache() (by Kevin
> and myself) to sanitize vmcb02 instead?

Oh, no, not _that_ exact.  More "unchanged after emulated VMRUN"

> That would be annoying. For example, for the intercepts, sanitizing
> vmcb02 (but not vmcb12) means that we need to also add checks in the
> exit path (i.e. in nested_svm_intercept() or even
> vmcb12_is_intercept()), as vmcb12 could have illegal intercepts.
> 
> > snapshot of vmcb12's controls, and then make vmcb02 authoritative.  We'll still
> > need the logic in nested_sync_control_from_vmcb02() to updated int_ctl on save
> > or #VMEXIT if KVM is still intercepting VINTR for its own purposes, but at least
> > the code will be contained.
> 
> Yeah. We should leave it out of the vmcb12 cache though.

+1

> > Then to make it all but impossible to re-introduce this mess, do something like
> > this so that someone would have to go way out of their way to try and modify the
> > cache.
> > 
> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index ebd7b36b1ceb..2de6305be9ce 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -199,14 +199,13 @@ struct svm_nested_state {
> >          * we cannot inject a nested vmexit yet.  */
> >         bool nested_run_pending;
> >  
> > -       /* cache for control fields of the guest */
> > -       struct vmcb_ctrl_area_cached ctl;
> > -
> >         /*
> > -        * Note: this struct is not kept up-to-date while L2 runs; it is only
> > -        * valid within nested_svm_vmrun.
> > +        * An opaque, read-only cache of vmcb12 controls, used to query L1's
> > +        * controls while running L2, e.g. to route intercepts appropriately.
> > +        * All reads are routed through accessors to make it all but impossible
> > +        * for KVM to clobber its snapshot of vmcb12.
> >          */
> > -       struct vmcb_save_area_cached save;
> 
> Is dropping the cached save area intentional?

Yes, I think we should try to drop it.  Assuming the comment is correct and it
really only 

> We can drop it and make it a local vaiable in nested_svm_vmrun(), and
> plumb it all the way down. But it could be too big for the stack.

It's 48 bytes, there's no way that's too big.

> Allocating it every time isn't nice either.

> Do you mean to also make it opaque?

I'd prefer to drop it.

> > +       u8 __vmcb12_ctrl[sizeof(struct vmcb_ctrl_area_cached)];
> 
> We have a lot of accesses to svm->nested.ctl, so we'll need a lot of
> clutter to cast the field in all of these places.
> 
> Maybe we add a read-only accessor that returns a pointer to a constant
> struct?

That's what I said :-D

	* All reads are routed through accessors to make it all but impossible
	* for KVM to clobber its snapshot of vmcb12.

There might be a lot of helpers, but I bet it's less than nVMX has for vmcs12.

> >         bool initialized;
> > 
> > > > Part of me wants to remove these two fields entirely:
> > > > 
> > > > 	/* cache for control fields of the guest */
> > > > 	struct vmcb_ctrl_area_cached ctl;
> > > > 
> > > > 	/*
> > > > 	 * Note: this struct is not kept up-to-date while L2 runs; it is only
> > > > 	 * valid within nested_svm_vmrun.
> > > > 	 */
> > > > 	struct vmcb_save_area_cached save;
> > > > 
> > > > and instead use "full" caches only for the duration of nested_svm_vmrun().  Or
> > > > hell, just copy the entire vmcb12 and throw the cached structures in the garbage.
> > > > But that'll probably end in a game of whack-a-mole as things get moved back in.
> > > 
> > > Yeah, KVM needs to keep some of the fields around :/
> > 
> > For me, that's totally fine.  As above, the problem I see is that there is no
> > single source of truth, i.e. that the authoritative state is spread across vmcb02
> > and the cache.
> > 
> > > > So rather than do something totally drastic, I think we should kill
> > > > nested_copy_vmcb_cache_to_control() and replace it with a "save control" flow.
> > > > And then have it share code as much code as possible with nested_svm_vmexit(),
> > > > and fixup nested_svm_vmexit() to not pull from svm->nested.ctl unnecessarily.
> > > > Which, again AFICT, is pretty much limited to int_ctl: either vmcb02 is
> > > > authoritative, or KVM shouldn't be updating vmcb12, and so only the "save control"
> > > > for KVM_GET_NESTED_STATE needs to copy from the cache to the migrated vmcb12.
> > > 
> > > I think this works if we draw a clear extinction between "in","out", and
> > > "in/out" fields, which is not great because some fields (like int_ctl)
> > > have different directions for different bits :/
> > > 
> > > But if we do draw that distinction, and have helpers that copy fields
> > > based on direction, things become more intuitive:
> > > 
> > > During nested VMRUN, we use the "in" and "in/out" fields from cached
> > > vmcb12 to construct vmcb02 through nested_vmcb02_prepare_control().
> > > 
> > > During save, we save "in" fields from the cached vmcb12, "out" and
> > > "in/out" fields from vmcb02.
> > > 
> > > During restore, we use the "in" and "in/out" fields from the restored
> > > payload to construct vmcb02 through nested_vmcb02_prepare_control(), AND
> > > update the "out" fields as well from the payload.
> > 
> > Why the last part?  If L2 is active, then the pure "out" fields are guaranteed
> > to be written on nested #VMEXIT.  Anything else simply can't work.
> 
> I think it just so happens that all pure "out" fields are consumed by
> KVM before save+restore is possible, but it is possible for an "out"
> field to be used by KVM at a later point, or copied from vmcb02 to
> vmcb12 during nested #VMEXIT (e.g. if KVM exits to L1 directly after
> save+restore, before running L2).

Ya.

> next_rip and int_state fall in this bucket, it just happens to also be
> an "in" field.
> 
> For example, if support for decode assists is added, there will be cases
> where KVM just copies insn_bytes from vmcb02 to vmcb12 on nested
> #VMEXIT. If insn_bytes is lost on save+restore, and KVM immediately
> exits to L1 after restore, insn_bytes is lost.
> 
> So we need to also save+restore pure "out" fields, which we do not do
> today.

Hmm, strictly speaking, no.  We'd be fixing a bug that doesn't exist, yet.  But
the word yet...

> > > During synthesized #VMEXIT, we save the "out" and "in/out" fields from
> > > vmcb02 (shared part with save/restore).
> > 
> > Yeah, that all works.  We could also treat save() as an extension of #VMEXIT, but
> > that could make KVM_GET_NESTED_STATE non-idempotent (which might already be the
> > case for VMX?).  I.e. we could sync vmcb02 to vmcb12 (cache), and then copy that
> > to userspace.
> 
> I think this will require adding more fields to the cache, but wait, we
> already have a lot of "out" fields there but I don't think they are
> being used at all..
> 
> Anyway, this may make things simpler. Instead of pulling different
> fields from either cached vmcb12 and vmcb02, we always combine them
> first. I will keep that in mind.
> 
> > 
> > > The save/restore changes would need a flag to avoid restoring garbage
> > > from an older KVM.
> > 
> > I don't follow.  I was thinking we'd only change how KVM maintains authoritative
> > state while runnign L2, i.e. not make any changes (other than fixes) to the
> > serialized state for save/restore.
> 
> I thought we're not currently saving "out" fields at all, but
> apparently we are, we just do not use them in svm_set_nested_state(). So
> we probably do not need a flag. Even if some fields are not currently
> copied, I assume KVM restoring garbage from an older KVM is no worse
> than having uninitialized garbage :)

Heh, yep.

> I think this will be annoying when new fields are added, like
> insn_bytes. Perhaps at some point we move to just serializing the entire
> combined vmcb02/vmcb12 control area and add a flag for that.

If we do it now, can we avoid the flag?

