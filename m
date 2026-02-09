Return-Path: <kvm+bounces-70591-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WGopMr62iWlLBAUAu9opvQ
	(envelope-from <kvm+bounces-70591-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 11:28:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3130310E294
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 11:28:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 459D13024128
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 10:27:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DAD2366DC6;
	Mon,  9 Feb 2026 10:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bBjkcjlE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7351E30F547;
	Mon,  9 Feb 2026 10:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770632848; cv=none; b=dGZwdM2piV+MpBMMFaxhq97+jKpq+9uTltfRmKdMUztBqPqBzWPkPrndXTuZPKQOZ60mm/H+BEmL9M+vPm3nGTAFs7USV41pLvwicZUOSjd8eN4r0aq8bfSFr2ca5xADaQDpPNC6uoZLoCMPtsIqEgiohHIEKNwNBl8vnjGSoEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770632848; c=relaxed/simple;
	bh=65CFyMKHT1SSZJ/ePteP8Ph+oXMUwR+XmES5SE7hF8g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LfniYEqyi8O0e1xlWyVUI4fKNOgHgE+prCVO/fLjPvoMjI6Sf8toRLQb46Lrfp+zUOtFPGvZppB2Ha46TM65mWWUddTIC/OpBm90DkVDGGx5NTw/OmFe3iT+G7QSEnIGaQyFKizZqzbPzsr9s9NC1LgcjY0myPyrVxa3fRcP4Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bBjkcjlE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D319C116C6;
	Mon,  9 Feb 2026 10:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770632848;
	bh=65CFyMKHT1SSZJ/ePteP8Ph+oXMUwR+XmES5SE7hF8g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bBjkcjlE8X1tOmApHpqMF3m3NJQ7vvclkI0UsAdHzGxP+Iq3rwlyMWF42765S61Oq
	 WhzNWjiO4FF5V3oqG5tA4ru1cXGJkr5JayBvC/SNugtlihGc2RMxeRLR1XOSalbOaV
	 DAFyXZEI0BJVaWHdvKeHwKvKBr3uw0Vh0SYGNT5cHETQaayqieuV17D9qgdIWML+q+
	 M9SsWzbHRKxF33iVYXDY/lo0jL5q2xUyiD31jjUMvde6R7BA7I+Y9xrBOBT36Lmh7C
	 EggJ6OC/e4oFwtQxnITUR2s2WgFMJg6zgE5b1Z8N+7p9DObMCjan5Ex/ZiAiughZoY
	 pL+TEuBs6616Q==
Date: Mon, 9 Feb 2026 15:53:01 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	"Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH 1/2] KVM: SVM: Initialize AVIC VMCB fields if AVIC is
 enabled with in-kernel APIC
Message-ID: <aYmvWLjNaJ5fbOcO@blrnaveerao1>
References: <20260203190711.458413-1-seanjc@google.com>
 <20260203190711.458413-2-seanjc@google.com>
 <aYXvp1S7lg2sq4AS@blrnaveerao1>
 <aYYwOTSIJsdafEvJ@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYYwOTSIJsdafEvJ@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70591-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[naveen@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3130310E294
X-Rspamd-Action: no action

On Fri, Feb 06, 2026 at 10:17:29AM -0800, Sean Christopherson wrote:
> On Fri, Feb 06, 2026, Naveen N Rao wrote:
> > On Tue, Feb 03, 2026 at 11:07:09AM -0800, Sean Christopherson wrote:
> > > Initialize all per-vCPU AVIC control fields in the VMCB if AVIC is enabled
> > > in KVM and the VM has an in-kernel local APIC, i.e. if it's _possible_ the
> > > vCPU could activate AVIC at any point in its lifecycle.  Configuring the
> > > VMCB if and only if AVIC is active "works" purely because of optimizations
> > > in kvm_create_lapic() to speculatively set apicv_active if AVIC is enabled
> > > *and* to defer updates until the first KVM_RUN.  In quotes because KVM
> > 
> > I think it will be good to clarify that two issues are being addressed 
> > here (it wasn't clear to me to begin with):
> > - One, described above, is about calling into avic_init_vmcb() 
> >   regardless of the vCPU APICv status.
> > - Two, described below is about using the vCPU APICv status for init and 
> >   not consulting the VM-level APICv inhibit status.
> 
> Yeah, I was worried the changelog didn't capture the second one well, but I was
> struggling to come up with wording.  How about this as a penultimate paragraph?
> 
>   Note!  Use the vCPU's current APICv status when initializing the VMCB,
>   not the VM-level inhibit status.  The state of the VMCB *must* be kept
>   consistent with the vCPU's APICv status at all times (KVM elides updates
>   that are supposed be nops).  If the vCPU's APICv status isn't up-to-date
>   with the VM-level status, then there is guaranteed to be a pending
>   KVM_REQ_APICV_UPDATE, i.e. KVM will sync the vCPU with the VM before
>   entering the guest.

LGTM.

>  
> > > likely won't do the right thing if kvm_apicv_activated() is false, i.e. if
> > > a vCPU is created while APICv is inhibited at the VM level for whatever
> > > reason.  E.g. if the inhibit is *removed* before KVM_REQ_APICV_UPDATE is
> > > handled in KVM_RUN, then __kvm_vcpu_update_apicv() will elide calls to
> > > vendor code due to seeing "apicv_active == activate".
> > >
> > > Cleaning up the initialization code will also allow fixing a bug where KVM
> > > incorrectly leaves CR8 interception enabled when AVIC is activated without
> > > creating a mess with respect to whether AVIC is activated or not.
> > > 
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > 
> > Any reason not to add a Fixes: tag?
> 
> Purely that I couldn't pin down exactly what commit(s) to blame.  Well, that's a
> bit of a lie.  If I'm being 100% truthful, I got as far as commit 67034bb9dd5e
> and decided I didn't care enough to spend the effort to figure out whether or not
> that commit was truly to blame :-)
> 
> > It looks like the below commits are to blame, but those are really old so I
> > understand if you don't think this is useful:
> > Fixes: 67034bb9dd5e ("KVM: SVM: Add irqchip_split() checks before enabling AVIC")
> > Fixes: 6c3e4422dd20 ("svm: Add support for dynamic APICv")
> 
> LGTM, I'll tack them on.
> 
> > Other than that:
> > Reviewed-by: Naveen N Rao (AMD) <naveen@kernel.org>
> 
> Thanks!  (Seriously, I really appreciate the in-depth reviews)

Glad to hear that!

> 
> > > ---
> > >  arch/x86/kvm/svm/avic.c | 2 +-
> > >  arch/x86/kvm/svm/svm.c  | 2 +-
> > >  2 files changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > > index f92214b1a938..44e07c27b190 100644
> > > --- a/arch/x86/kvm/svm/avic.c
> > > +++ b/arch/x86/kvm/svm/avic.c
> > > @@ -368,7 +368,7 @@ void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
> > >  	vmcb->control.avic_physical_id = __sme_set(__pa(kvm_svm->avic_physical_id_table));
> > >  	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE;
> > >  
> > > -	if (kvm_apicv_activated(svm->vcpu.kvm))
> > > +	if (kvm_vcpu_apicv_active(&svm->vcpu))
> > >  		avic_activate_vmcb(svm);
> > >  	else
> > >  		avic_deactivate_vmcb(svm);
> > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > index 5f0136dbdde6..e8313fdc5465 100644
> > > --- a/arch/x86/kvm/svm/svm.c
> > > +++ b/arch/x86/kvm/svm/svm.c
> > > @@ -1189,7 +1189,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu, bool init_event)
> > >  	if (guest_cpu_cap_has(vcpu, X86_FEATURE_ERAPS))
> > >  		svm->vmcb->control.erap_ctl |= ERAP_CONTROL_ALLOW_LARGER_RAP;
> > >  
> > > -	if (kvm_vcpu_apicv_active(vcpu))
> > > +	if (enable_apicv && irqchip_in_kernel(vcpu->kvm))
> > >  		avic_init_vmcb(svm, vmcb);
> > 
> > Doesn't have to be done as part of this series, but I'm wondering if it 
> > makes sense to turn this into a helper to clarify the intent and to make 
> > it more obvious:
> 
> Hmm, yeah, though my only hesitation is the name.  For whatever reason, "possible"
> makes me think "is APICv possible *right now*" (ignoring that I wrote exactly that
> in the changelog).
> 
> What if we go with kvm_can_use_apicv()?  That would align with vmx_can_use_ipiv()
> and vmx_can_use_vtd_pi(), which are pretty much identical in concept.

Yes, that's better. I'll use that and post it as a subsequent cleanup, 
unless you want to pick it up rightaway.


Thanks!
- Naveen


