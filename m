Return-Path: <kvm+bounces-68142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A33B8D220B9
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 02:39:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 08647304F178
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 01:39:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C75A92566D3;
	Thu, 15 Jan 2026 01:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NHTuHtsG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA48C7260A
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 01:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768441157; cv=none; b=sTYaxwhPaV9NQO2d0CwikJRl98xelzuu8cpNk+TGX+E6Lth8O6l33mqz8MUrsy3kBDNzVOGFP7Fpuw0P+fN/fyKqxl6vTqjnlMizyXkN0m3pvlIOAaDwbYdYwUMQaspwmEUlkw/J2U72PUYExYTo+SsMavJyfLo9IEBopS/hEQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768441157; c=relaxed/simple;
	bh=eBLrHGFOYj94x3BnSsJy+OUuRBpwUKYytD7vMbj1svo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MWgZSeSdVbByrscNp1Z9jRKPYAUx8rupbTAcwQAW6PGItixXWUKJjcHa4TrOC08nktauokLf0gND0FIH3QyIvYDX4tpB0POGcQKEmZlcqiRhzBHFQkY8UtgpkO+JGZNvogi75yYolq2k48QlxbXXzZWUjcw973njysdg+TrreYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NHTuHtsG; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a08cbeb87eso4021255ad.3
        for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 17:39:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768441155; x=1769045955; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=84nMa7tneVDTL4Try1pD5llzHh0psiq+AUE0j44ev30=;
        b=NHTuHtsGOx/AC/lC6dp57CMpape7Sx9H51J4+HudlR06ki8JTCvxyUHEk16nRvfKdP
         e0rZicSc9ry6cXR2BsMWNhfJeZjWiwDp3ahrzAWZPgRDtfHF1rYP5KeFFGoUD5c7+hxE
         N8vCpFbPckpibsqIkLr7aZXeLVDT36KN4+M3MoEEgY61LaMFPn2aq3zZYfogxLIjCDLG
         RlpTCoAprOzHWOMuC6+TICpbvEhlW1F5Om6uaud4JKUokY2ImW6Xs2bquWn3yQlUbOUK
         Dvy+C0usCuPXse4/xrHjvfVjw0qg+rNXCxrDNhZGHryrVQW4I0Q6iicdOJYFXUCIx1Lq
         rVNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768441155; x=1769045955;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=84nMa7tneVDTL4Try1pD5llzHh0psiq+AUE0j44ev30=;
        b=jYfoHL9wtyllls922+D2Jwv3Mf5wsY6eTbXT+Ud1uom9F3mGSJLkaWmyIp/+eBiVPZ
         31+78vZmMFkjSKtZB8MUiw3WsdH1aJRevqg9SRNU+tp4MZBHJ2pQo8a9wxgiJecX1A8S
         pQtByoU3b7a/nfflBpo3SNN4X0B+fRKrAK6gbdNdmaV+zmXyOG+RFfb4DGwG62y71Oww
         3n4xGKJLnylgfgl7OuLiRmCtX6JRXsQPrkIxm2XKiHi7D2LzzilTlvIvHBQrix1oetnO
         EWa5MS7CH1FaWiJnE0DTrpi70378GUXvhKAbyeAdSul5PTG8rNfUbnp1+xuYP9o5FHyY
         P17w==
X-Forwarded-Encrypted: i=1; AJvYcCX7kAOUZIIzSK96dHxJaE5YJax0yxRCBtf3hySx/gXtp9JuY78fzH0wLGm1coLq8XtdenM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXhzwQ8AQk4bygHnMpt8NCQ3tbQO/FzaoMqidVVJFYU+tbZYwv
	FAWYkcwGerFvMFFXJMQfNoDedUqyOEDqWuAVD5ed4tgU2dmvqJlkOovl2U0NCDFicls7HDZfvrU
	l148FJA==
X-Received: from plblo16.prod.google.com ([2002:a17:903:4350:b0:29e:ebb4:3936])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d4d0:b0:295:8a21:155a
 with SMTP id d9443c01a7336-2a599e34da4mr43546945ad.35.1768441155088; Wed, 14
 Jan 2026 17:39:15 -0800 (PST)
Date: Wed, 14 Jan 2026 17:39:13 -0800
In-Reply-To: <jmacawbcdorwi2y5ulh2l2mdpeulx5sj7qvjehvnhaa5cgdcs3@2tljlprwtl27>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260112174535.3132800-1-chengkev@google.com> <20260112174535.3132800-2-chengkev@google.com>
 <jmacawbcdorwi2y5ulh2l2mdpeulx5sj7qvjehvnhaa5cgdcs3@2tljlprwtl27>
Message-ID: <aWhFQcNa8SKd679a@google.com>
Subject: Re: [PATCH V2 1/5] KVM: SVM: Move STGI and CLGI intercept handling
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Kevin Cheng <chengkev@google.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 12, 2026, Yosry Ahmed wrote:
> On Mon, Jan 12, 2026 at 05:45:31PM +0000, Kevin Cheng wrote:
> > Similar to VMLOAD/VMSAVE intercept handling, move the STGI/CLGI
> > intercept handling to svm_recalc_instruction_intercepts().
> > ---
> >  arch/x86/kvm/svm/svm.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 24d59ccfa40d9..6373a25d85479 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -1010,6 +1010,11 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
> >  			svm_clr_intercept(svm, INTERCEPT_VMSAVE);
> >  			svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
> >  		}
> > +
> > +		if (vgif) {
> > +			svm_clr_intercept(svm, INTERCEPT_STGI);
> 
> Could this cause a problem with NMI window tracking?

Yes.

> svm_enable_nmi_window() sets INTERCEPT_STGI to detect when NMIs are
> enabled, and it's later cleared by svm_set_gif(). If we recalc
> intercepts in between we will clear the intercept here and miss NMI
> enablement.
> 
> We could move the logic to set/clear INTERCEPT_STGI for NMI window
> tracking here as well, but then we'll need to recalc intercepts in
> svm_enable_nmi_window() and svm_set_gif(), which could be expensive.
> 
> The alternative is perhaps setting a flag when INTERCEPT_STGI is set in
> svm_enable_nmi_window() and avoid clearing the intercept here if the
> flag is set.
> 
> Not sure what's the best way forward here.

First things first, the changelog needs to state _why_ the code is being moved.
"To be like VMLOAD/VMSAVE" doesn't suffice, because my initial answer was going
to be "well just don't move the code" (I already forgot the context of v1).

But moving the code is needed to fix the missing #UD in "Recalc instructions
intercepts when EFER.SVME is toggled".

As for how to fix this, a few ideas:

 1. Set KVM_REQ_EVENT to force KVM to re-evulate all events.  kvm_check_and_inject_events()
    will see the pending NMI and/or SMI, that the NMI/SMI is not allowed, and
    re-call enable_{nmi,smi}_window().

 2. Manually check for pending+blocked NMI/SMIs.

 3. Combine parts of #1 and #2.  Set KVM_REQ_EVENT, but only if there's a pending
    NMI or SMI.

 4. Add flags to vcpu_svm to explicitly track if a vCPU has an NMI/SMI window,
    similar to what we're planning on doing for IRQs[*], and use that to more
    confidently do the right thing when recomputing intercepts.

I don't love any of those ideas.  Ah, at least not until I poke around KVM.  In
svm_set_gif() there's already this:

		if (svm->vcpu.arch.smi_pending ||
		    svm->vcpu.arch.nmi_pending ||
		    kvm_cpu_has_injectable_intr(&svm->vcpu) ||
		    kvm_apic_has_pending_init_or_sipi(&svm->vcpu))
			kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);

So I think it makes sense to bundle that into a helper, e.g. (no idea what to
call it)

static bool svm_think_of_a_good_name(struct kvm_vcpu *vcpu)
{
	if (svm->vcpu.arch.smi_pending ||
	    svm->vcpu.arch.nmi_pending ||
	    kvm_cpu_has_injectable_intr(&svm->vcpu) ||
	    kvm_apic_has_pending_init_or_sipi(&svm->vcpu))
		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
}

And then call that from svm_recalc_instruction_intercepts().  That implements #3
in a fairly maintainable way (we'll hopefully notice sooner than later if we break
svm_set_gif()).

https://lore.kernel.org/all/26732815475bf1c5ba672bc3b1785265f1a994e6.1752819570.git.naveen@kernel.org

> > +			svm_clr_intercept(svm, INTERCEPT_CLGI);
> > +		}
> >  	}
> >  }
> >  
> > @@ -1147,11 +1152,8 @@ static void init_vmcb(struct kvm_vcpu *vcpu, bool init_event)
> >  	if (vnmi)
> >  		svm->vmcb->control.int_ctl |= V_NMI_ENABLE_MASK;
> >  
> > -	if (vgif) {
> > -		svm_clr_intercept(svm, INTERCEPT_STGI);
> > -		svm_clr_intercept(svm, INTERCEPT_CLGI);
> > +	if (vgif)
> >  		svm->vmcb->control.int_ctl |= V_GIF_ENABLE_MASK;
> > -	}
> >  
> >  	if (vcpu->kvm->arch.bus_lock_detection_enabled)
> >  		svm_set_intercept(svm, INTERCEPT_BUSLOCK);
> > -- 
> > 2.52.0.457.g6b5491de43-goog
> > 

