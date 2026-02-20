Return-Path: <kvm+bounces-71422-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8IYjH73DmGl/LwMAu9opvQ
	(envelope-from <kvm+bounces-71422-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 21:27:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 13CB716A9F7
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 21:27:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7937A301C157
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 20:27:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2CC02FFFB5;
	Fri, 20 Feb 2026 20:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sa+JN41m"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A672F5A1F;
	Fri, 20 Feb 2026 20:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771619254; cv=none; b=QlP9KqPVQF1tRbM1HBJ0YxuCOMy3qUyT98ZIsYVUsnGGakGw6FtWFojK7zzZX1prk0Op/Bm8LyEE1tLw8iSc62uYJb2FM9daHLnvX30ZCPsghX04hcdHS+/e+G9i4GsuXFi4onb/ah1pp+MdsAaAGLetpycwICMVjARcMoOEqm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771619254; c=relaxed/simple;
	bh=7lNEXLuZksX/WFCUbNtl5q5EkXf/2wudJSw4Qe+xvqo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=anpHXvNhnNUIEWnVR7hn3zxiMbUG9JqjxG05qzKjroTpP0lJkr/EtasII2Af+UZu7NlEW5GmK6N2eJ+spL1bbeFVVxrwg0tmZcdyZB7Nl9oGp5+05nXtsWNq5UHbapBRRhnn4Cu6qyOv4viAVDdrDOGBNf7i8zdsi/G6HHWyjqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sa+JN41m; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 20 Feb 2026 20:27:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771619249;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8biuXJdZcPr+HfpGcCqZ3op2Mr/OtD2K8LWflQpI0zA=;
	b=sa+JN41m8a4FNJPghIEJe8pKF06qIFSqo5WQZydmvJ7Y455t+u0bYtHYcQbuhiRsr6s0yZ
	zEZN4gvhzE6KJ78ycc/OXYuT8dwscWzw/4mpikPg9xZjqSTcG8wQZ2D5wcwR1MwdBI8ppu
	ajyqqCNVRhr3gjdBfBF2TJB1QJdQiSw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [RFC PATCH 4/5] KVM: SVM: Recalculate nested RIPs after
 restoring REGS/SREGS
Message-ID: <unqj7mrl5j2feevcuwfpiurhtzppbdn7b5gimlalvunv3bx25y@5ko7vwgzxxdw>
References: <20260212230751.1871720-1-yosry.ahmed@linux.dev>
 <20260212230751.1871720-5-yosry.ahmed@linux.dev>
 <aZZVqQrQ1iCNJhJJ@google.com>
 <wwa2h5gcb7gfxgmsh3jdwa4d4xurkmgd26dnkwupgzcln3khfu@v3w2w6nf4tq7>
 <aZiUxBRPovFd4nDd@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZiUxBRPovFd4nDd@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71422-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Queue-Id: 13CB716A9F7
X-Rspamd-Action: no action

> > >         svm->nmi_l1_to_l2 = is_evtinj_nmi(vmcb02->control.event_inj);
> > >         if (is_evtinj_soft(vmcb02->control.event_inj)) {
> > >                 svm->soft_int_injected = true;
> > > -               svm->soft_int_csbase = vmcb12_csbase;
> > > -               svm->soft_int_old_rip = vmcb12_rip;
> > > +
> > >                 if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
> > >                         svm->soft_int_next_rip = svm->nested.ctl.next_rip;
> > 
> > Why not move this too?
> 
> For the same reason I think we should keep 
> 
> 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
> 		vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
> 
> where it is.  When NRIPS is exposed to the guest, the incoming nested state is
> the one and only source of truth.  By keeping the code different, we'd effectively
> be documenting that the host.NRIPS+!guest.NRIPS case is the anomaly.

I see, makes sense. I like the fact that we should be able to completely
drop vmcb12_rip and vmcb12_csbase with this (unless we want to start
using it for the bus_lock_rip check), which will also remove the need
for patch 2.

I guess the only hiccup will be patch 1. We'll end up with this code in
nested_vmcb02_prepare_control():

	if boot_cpu_has(X86_FEATURE_NRIPS)) {
		if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS) ||
		    !svm->nested.nested_run_pending)
			vmcb02->control.next_rip = svm->nested.ctl.next_rip;
	}

, and this code pre-VMRUN:

	if boot_cpu_has(X86_FEATURE_NRIPS)) {
		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS) &&
		    svm->nested.nested_run_pending)
			vmcb02->control.next_rip = kvm_rip_read(vcpu);
	}

It seems a bit fragile that the 'if' is somewhere and the 'else' (or the
opposite condition) is somewhere else. They could get out of sync. Maybe
a helper will make this better:

/* Huge comment */
bool nested_svm_use_vmcb12_next_rip(struct kvm_vcpu *vcpu)
{
	return guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS) ||
		!svm->nested.nested_run_pending;
}

or maybe the name makes more sense as the negative:
nested_svm_use_rip_as_next_rip()?

I don't like both names..

Aha! Maybe it's actually better to have the helper set the NextRip
directly?

/* Huge comment */
u64 nested_vmcb02_update_next_rip(struct kvm_vcpu *vcpu)
{
	u64 next_rip;

	if (WARN_ON_ONCE(svm->vmcb != svm->nested.vmcb02.ptr))
		return;

	if (!boot_cpu_has(X86_FEATURE_NRIPS))
		return;

	if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS) ||
	    !svm->nested.nested_run_pending)
	    	next_rip = svm->nested.ctl.next_rip;
	else
		next_rip = kvm_rip_read(vcpu);

	svm->vmcb->control.next_rip = next_rip;
}

Then, we just call this from nested_vmcb02_prepare_control() and
svm_vcpu_run() (with the soft IRQ stuff). In some cases we'll put the
wrong thing in vmcb02 and then fix it up later, but I think that's fine
(that's what the patch is doing anyway).

However, we lose the fact that the whole thing is guarded by
nested_run_pending, so performance in svm_vcpu_run() could suffer. We
could leave it all guarded by nested_run_pending, as
nested_vmcb02_update_next_rip() should do nothing in svm_vcpu_run()
otherwise, but then the caller is depending on implementation details of
the helper.

Maybe just put it in svm_prepare_switch_to_guest() to begin with and not
guard it with nested_run_pending?

> 
> > > -               else
> > > -                       svm->soft_int_next_rip = vmcb12_rip;
> > >         }
> > >  
> > >         /* LBR_CTL_ENABLE_MASK is controlled by svm_update_lbrv() */
> > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > index 8f8bc863e214..358ec940ffc9 100644
> > > --- a/arch/x86/kvm/svm/svm.c
> > > +++ b/arch/x86/kvm/svm/svm.c
> > > @@ -4322,6 +4322,14 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
> > >                 return EXIT_FASTPATH_EXIT_USERSPACE;
> > >         }
> > >  
> > > +       if (is_guest_mode(vcpu) && svm->nested.nested_run_pending &&
> > > +           svm->soft_int_injected) {
> > > +               svm->soft_int_csbase = svm->vmcb->save.cs.base;
> > > +               svm->soft_int_old_rip = kvm_rip_read(vcpu);
> > > +               if (!guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
> > > +                       svm->soft_int_next_rip = kvm_rip_read(vcpu);
> > > +       }
> > > +
> > 
> > I generally dislike adding more is_guest_mode() stuff in svm_vcpu_run(),
> > maybe we can refactor them later to pre-run and post-run nested
> > callbacks? Anyway, not a big deal, definitely an improvement over the
> > current patch assuming we can figure out how to fix next_rip.
> 
> I don't love it either, but I want to (a) avoid unnecessarily overwriting the
> fields, e.g. if KVM never actually does VMRUN and (b) minimize the probability
> of consuming a bad RIP.
> 
> In practice, I would expect the nested_run_pending check to be correctly predicted
> the overwhelming majority of the time, i.e. I don't anticipate performance issues
> due to putting the code in the hot path.
> 
> If we want to try and move the update out of svm_vcpu_run(), then we shouldn't
> need generic pre/post callbacks for nested, svm_prepare_switch_to_guest() is the
> right fit.

I prefer putting it in svm_prepare_switch_to_guest() to begin with,
because it gives us more flexibility (see above).

