Return-Path: <kvm+bounces-52072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DA8AFB00FA4
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 01:30:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B9A0F1CA45C5
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 23:30:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0F802FE31D;
	Thu, 10 Jul 2025 23:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OgkIYTwp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758DC2FE312
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 23:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752190205; cv=none; b=k+U4Po4Bp3hc0jrLyFj/0EelvevjBSDoRBWHmVqqp34MBXcFWMIl8V3J1B/MBDK7twMpE3wZSGUDKWxUcB/SGArAI0uwdDbP1fKALvl0chp1RRCIN+lDWm393i8Zu12MEvE0HVAOHAimTwdjSoeGvqKM8ftzcYCP9JkxoPli7vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752190205; c=relaxed/simple;
	bh=lWSxQC+mZHEIoIyoDecPCialQZOrZSmV71ZeqWCgh/A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X9yvOfogmh3sOmGQDO0OvIMTNzYSf5i0FsMPD2zDq2GHzBzrG+Mk/lOZ1CQHN0xy9U6l3kXDfFWCBLR06FHcXQhMK9mmutUM/wFKdXfjyDL8pMfomwiYyU7V2z2H/S6seBzZ2N1xMR0ZW+P/oUHupLMn2Px/24fo4tgcHgSRDPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OgkIYTwp; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31366819969so1578243a91.0
        for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 16:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752190203; x=1752795003; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gpaQNg0EAttnSt1tZe1QyO5hwkZRG1Zrg+3cZk9+Uow=;
        b=OgkIYTwp6RTJOIzDvozDeAsY988z0kVVDqimM1GvhX9oNYXYFJtRME9bq7A6xw0Rpu
         w3OYQcljAsitFYxyRgnAUR0Kjx9x/7+ZezWPNz+vkX7rWj2pgpBwa0VwEg8O5TOeAnNJ
         xgyoFKkR5kbJVBg4JAYMMoujOsZIWoBq+3NbpaYpXXGIdZoz+tKOGj82Mt6u1XOZIDkI
         8ows01Fxh7Hiz1q+J9o6CH7MFtkUZJLY9jgVG0o/li25RZEcQtlJ/1hHgNSXYEDdX5XU
         LpL1Sw2iTdA0tBihGojr8dRaHJL3dLC7rdSce42kREf3ro5Aku5FiChgIBlPtS/CZ5eX
         znzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752190203; x=1752795003;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gpaQNg0EAttnSt1tZe1QyO5hwkZRG1Zrg+3cZk9+Uow=;
        b=dPNZgbkGDTdjYPjPWwVlHEGOfAjafH3oQOTWcfiWVixbuXNcAZo/iR17KO4sxnIbfY
         RmFSfjiX34/+GWjZw1wyk/ZwxuE1S8SyC34aK9+1AcLooYg7w6uRU5c0PwzACg5J8exo
         w1gQ7Zr3KwOys3cjTA3nOU4bEgNN+X2WjLtoMulQ9SEQ3LUmwWKji82vqaW2INa43+YV
         IlGCiZ6ZMMfD3/xRASZgwIqHQbyyFdzdRzkikEyc6TWcIERihrdxNwF0FwvEvirF66o8
         lu6Po0+IFOJUHuVvhihwMq7r02VAudQujcM+RR6hyzBVCUgkWQ0WPbZKBmfFi9+Dyuvg
         eiRA==
X-Forwarded-Encrypted: i=1; AJvYcCWhEk5VL1yyYzf3oCJHFBMFFVs3uG/hfTOamEuVuDcnaWvtM70CGIh9nyKBgKWtsCqeltI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxCSnShixqYB5Zq/xHsLw9vPAU+vsJsmHB3CukR8Jk1DWkOFDC
	q++BIuk0X/ZJuduDXRpBwFQXnjdtWCDo9UXFIn/4RpDM5QVHifhAci4Abs2z8mwld1BX2o/mkaf
	iMK3sWg==
X-Google-Smtp-Source: AGHT+IFaHKKkvy/nJE02T4Biz0oWOWXUd3GO2Ig/PxkIMk1hQa4zYkyK8uIuHEyUQ1cykiiDBME244h+mp0=
X-Received: from pjj11.prod.google.com ([2002:a17:90b:554b:b0:312:1dae:6bf0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:dfc7:b0:2ee:6d08:7936
 with SMTP id 98e67ed59e1d1-31c50e17884mr164171a91.20.1752190202320; Thu, 10
 Jul 2025 16:30:02 -0700 (PDT)
Date: Thu, 10 Jul 2025 16:30:00 -0700
In-Reply-To: <99ca91cd-4363-42b8-bcac-5710684c6d92@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250707101029.927906-1-nikunj@amd.com> <20250707101029.927906-3-nikunj@amd.com>
 <aG0tFvoEXzUqRjnC@google.com> <63f08c9e-b228-4282-bd08-454ccdf53ecf@amd.com>
 <aG5oTKtWWqhwoFlI@google.com> <85h5zkuxa2.fsf@amd.com> <aG--DjX1r4RK3lFC@google.com>
 <99ca91cd-4363-42b8-bcac-5710684c6d92@amd.com>
Message-ID: <aHBM-LfEW7FXOjhO@google.com>
Subject: Re: [PATCH v8 2/2] KVM: SVM: Enable Secure TSC for SNP guests
From: Sean Christopherson <seanjc@google.com>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: bp@alien8.de, pbonzini@redhat.com, kvm@vger.kernel.org, 
	thomas.lendacky@amd.com, santosh.shukla@amd.com, isaku.yamahata@intel.com, 
	vaishali.thakkar@suse.com, kai.huang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 10, 2025, Nikunj A. Dadhania wrote:
> On 7/10/2025 6:50 PM, Sean Christopherson wrote:
> > On Thu, Jul 10, 2025, Nikunj A Dadhania wrote:
> >> Sean Christopherson <seanjc@google.com> writes:
> >>> Because there's zero point in not intercepting writes, and KVM shouldn't do
> >>> things for no reason as doing so tends to confuse readers.  E.g. I reacted to
> >>> this because I didn't read the changelog first, and was surprised that the guest
> >>> could adjust its TSC frequency (which it obviously can't, but that's what the
> >>> code implies to me).
> >>>
> >>
> >> Agree to your point that MSR read-only and having a MSR_TYPE_RW
> >> creates a special case. I can change this to MSR_TYPE_R. The only thing
> >> which looks inefficient to me is the path to generate the #GP when the
> >> MSR interception is enabled.
> >>
> >> AFAIU, the GUEST_TSC_FREQ write handling for SEV-SNP guest:
> >>
> >> sev_handle_vmgexit()
> >> -> msr_interception()
> >>   -> kvm_set_msr_common()
> >>      -> kvm_emulate_wrmsr()
> >>         -> kvm_set_msr_with_filter()
> >>         -> svm_complete_emulated_msr() will inject the #GP
> >>
> >> With MSR interception disabled: vCPU will directly generate #GP
> > 
> > Yes, but no well-behaved guest will ever write the MSR, and if a guest does
> > manage to generate a WRMSR, the guest is beyond hosed if it affects performance.
> > 
> >>>>    The guest vCPU handles it appropriately when interception is disabled.
> >>>>
> >>>> 2) Guest does not expect GUEST_TSC_FREQ MSR to be intercepted(read or write), guest 
> >>>>    will terminate if GUEST_TSC_FREQ MSR is intercepted by the hypervisor:
> >>>
> >>> But it's read-only, the guest shouldn't be writing.  If the vCPU handles #GPs
> >>> appropriately, then it should have no problem handling #VCs on bad writes.
> >>>
> >>>> 38cc6495cdec x86/sev: Prevent GUEST_TSC_FREQ MSR interception for Secure TSC enabled guests
> >>>
> >>> That's a guest bug, it shouldn't be complaining about the host
> >>> intercepting writes.
> >>
> >> The code was written with a perspective that host should not be
> >> intercepting GUEST_TSC_FREQ, as it is a guest-only MSR.
> > 
> > It's fine to panic on a _read_, I'm saying the guest shouldn't panic on a write,
> > because the guest shouldn't be writing in the first place.
> 
> Agree, and the with the below change the write to GUEST_TSC_FREQ will be ignored.
> 
> Should I send a patch with your authorship/signed-off-by ?

Sure, that'd be wonderful!

Signed-off-by: Sean Christopherson <seanjc@google.com>

> > diff --git a/arch/x86/coco/sev/vc-handle.c b/arch/x86/coco/sev/vc-handle.c
> > index 0989d98da130..353647339a79 100644
> > --- a/arch/x86/coco/sev/vc-handle.c
> > +++ b/arch/x86/coco/sev/vc-handle.c
> > @@ -369,24 +369,21 @@ static enum es_result __vc_handle_secure_tsc_msrs(struct pt_regs *regs, bool wri
> >         u64 tsc;
> >  
> >         /*
> > -        * GUEST_TSC_FREQ should not be intercepted when Secure TSC is enabled.
> > -        * Terminate the SNP guest when the interception is enabled.
> > +        * Writing to MSR_IA32_TSC can cause subsequent reads of the TSC to
> > +        * return undefined values, and GUEST_TSC_FREQ is read-only.  Ignore
> > +        * all writes, but WARN to log the kernel bug.
> > +        */
> > +       if (WARN_ON_ONCE(write))
> > +               return ES_OK;
> > +
> > +       /*
> > +        * GUEST_TSC_FREQ should be not be intercepted when Secure TSC is
> > +        * enabled. Terminate the SNP guest when the interception is enabled.
> >          */
> >         if (regs->cx == MSR_AMD64_GUEST_TSC_FREQ)
> >                 return ES_VMM_ERROR;
> >  
> > -       /*
> > -        * Writes: Writing to MSR_IA32_TSC can cause subsequent reads of the TSC
> > -        *         to return undefined values, so ignore all writes.
> > -        *
> > -        * Reads: Reads of MSR_IA32_TSC should return the current TSC value, use
> > -        *        the value returned by rdtsc_ordered().
> > -        */
> > -       if (write) {
> > -               WARN_ONCE(1, "TSC MSR writes are verboten!\n");
> > -               return ES_OK;
> > -       }
> > -
> > +       /* Reads of MSR_IA32_TSC should return the current TSC value. */
> >         tsc = rdtsc_ordered();
> >         regs->ax = lower_32_bits(tsc);
> >         regs->dx = upper_32_bits(tsc);
> 
> Regards,
> Nikunj

