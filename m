Return-Path: <kvm+bounces-22267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D285293C86E
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 20:40:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 023111C20E68
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 18:40:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5722A47A5C;
	Thu, 25 Jul 2024 18:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2smGu/ua"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FF91F959
	for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 18:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721932800; cv=none; b=lHMWxEduFk7o1lQD1u+VEQGHL63wSkDonZ9r3wU7v6Xc3id25JK0BwWelOkCedWqvH3MlT/7d09eK23DU1IE58EdXVeKXkJl4mJC6Y380cLiMMq5V/5HqV2lLLNevndW4Ez3NmE4fRIUa4AjijvjPN8sOj3NUSDOybFqqi7rp94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721932800; c=relaxed/simple;
	bh=WV08LEf4bDRtKKeq/kZAer9dZV/w6G8SDrDNBdS8n1Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gcskWsIZ8UONB+ia47Kl/XPV2aNHYSSLq9KsLWHYcJ3i57BAqKL7f1/DCG3NnOfGPKdk4Z5ksBbHTmI8ZziVJ5pxtcGzUEo3DgCGsJMukTO1tyaTsWL231XqZELg1F5O4RXbIn6Yz1cSFiJtYnFy2u3fSNGAPGyx32iIsRD5350=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2smGu/ua; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e05e3938a37so2141188276.2
        for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 11:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721932798; x=1722537598; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GwCAZddYEjH9DUsa6iY70uKfyWAm6I3s9GplHDbIC+w=;
        b=2smGu/uas2F2G60QzhNg/KumIceNLh2qYaQ5WL9FGxzokRvRhXYjNzZw77doPxbSzM
         bVqhc267VyQgwrBeKZJR9tlXF+N4GskypghhPc9XuPiL1FMG85h1G+zuuIaOWzvfPGnw
         fwOdxRGAaCAntSvDzlGBehhD0GMeIRTQzsffbLn6/L9it782Jh8nrf/3aDvyFFsXmZ23
         VjlOrbRYqVXiH+TRfdP31YRsFOuI5ANdh2HpKT/PhtO5ZjoU4wJY+4m2UUMa8/BL3BB7
         01gtTy55qzLBLBP+vLXkQWLAk1IIKB1JhAH6Kx4XuwO0C6UNlBmpwBqKftMc4OcoAp1B
         RlWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721932798; x=1722537598;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GwCAZddYEjH9DUsa6iY70uKfyWAm6I3s9GplHDbIC+w=;
        b=B+yrZjWFxGjWR5nGJJwBXwOyzMFkDN2LMKQZIpmwFJQMN2djbDcxCAexSUscpZAwlH
         MrbhgJO+76LHhfJgfnBmV0TyEUtL7U0qXTAFcbtofkiyI791KtqERkpCwnbnLbUUV49q
         ZCfYY6bidDihQoW7aOkCQ6jpz8s0Nv+pfYEqjqfqzrnLMyP9KLav3NBT3XGiEOwN/jFd
         MxE3XavUP+SCKKGFw9xz5syZJsloWOLi7hBYWUUPBfRFNPVde/RZpfgHz/9JQQMDsBme
         1YqI0bxflsYRnEoAWSIi8UTPz7vMzEF6iqxOqEX1974FI3Yf92Xx8nONF1aZ420lsyma
         m+Gg==
X-Forwarded-Encrypted: i=1; AJvYcCWxLLA73Gb2tTSBwi7/GYOYcU70AzCwiJjNsrTstvpGak7vtY5Hdb2pI6UsqVTJvZLEYyq/NoHKht0pbadma5K/6Ccw
X-Gm-Message-State: AOJu0YxLSR2DjQZd3a0zijR6KkfwjNFyo7IFWljE7Rpb26zZGhNGIYLd
	HbKf7h8hyjcTwuM4YPNwnZYwQ7sXKvbnAl2VdYjuScW6ZjFREsTinelgVqB9T4BlOHOg/MvlGRg
	Txw==
X-Google-Smtp-Source: AGHT+IFmEKfwoHPY40fYkrASMt2VpBBuIZlemRTch5cWlOFScrcRLFVqpg5dBToDA9x6VGRunb0Ymep93CM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:72d:b0:e03:62dc:63de with SMTP id
 3f1490d57ef6-e0b2ca7170fmr36479276.6.1721932797957; Thu, 25 Jul 2024 11:39:57
 -0700 (PDT)
Date: Thu, 25 Jul 2024 11:39:56 -0700
In-Reply-To: <3da2be9507058a15578b5f736bc179dc3b5e970f.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com> <20240517173926.965351-23-seanjc@google.com>
 <43ef06aca700528d956c8f51101715df86f32a91.camel@redhat.com>
 <ZoxVa55MIbAz-WnM@google.com> <3da2be9507058a15578b5f736bc179dc3b5e970f.camel@redhat.com>
Message-ID: <ZqKb_JJlUED5JUHP@google.com>
Subject: Re: [PATCH v2 22/49] KVM: x86: Add a macro to precisely handle
 aliased 0x1.EDX CPUID features
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 24, 2024, Maxim Levitsky wrote:
> On Mon, 2024-07-08 at 14:08 -0700, Sean Christopherson wrote:
> > On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> > > On Fri, 2024-05-17 at 10:38 -0700, Sean Christopherson wrote:
> > > > Add a macro to precisely handle CPUID features that AMD duplicated from
> > > > CPUID.0x1.EDX into CPUID.0x8000_0001.EDX.  This will allow adding an
> > > > assert that all features passed to kvm_cpu_cap_init() match the word being
> > > > processed, e.g. to prevent passing a feature from CPUID 0x7 to CPUID 0x1.
> > > > 
> > > > Because the kernel simply reuses the X86_FEATURE_* definitions from
> > > > CPUID.0x1.EDX, KVM's use of the aliased features would result in false
> > > > positives from such an assert.
> > > > 
> > > > No functional change intended.
> > > > 
> > > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > > ---
> > > >  arch/x86/kvm/cpuid.c | 24 +++++++++++++++++-------
> > > >  1 file changed, 17 insertions(+), 7 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > > > index 5e3b97d06374..f2bd2f5c4ea3 100644
> > > > --- a/arch/x86/kvm/cpuid.c
> > > > +++ b/arch/x86/kvm/cpuid.c
> > > > @@ -88,6 +88,16 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
> > > >  	F(name);						\
> > > >  })
> > > >  
> > > > +/*
> > > > + * Aliased Features - For features in 0x8000_0001.EDX that are duplicates of
> > > > + * identical 0x1.EDX features, and thus are aliased from 0x1 to 0x8000_0001.
> > > > + */
> > > > +#define AF(name)								\
> > > > +({										\
> > > > +	BUILD_BUG_ON(__feature_leaf(X86_FEATURE_##name) != CPUID_1_EDX);	\
> > > > +	feature_bit(name);							\
> > > > +})
> > > > +
> > > >  /*
> > > >   * Magic value used by KVM when querying userspace-provided CPUID entries and
> > > >   * doesn't care about the CPIUD index because the index of the function in
> > > > @@ -758,13 +768,13 @@ void kvm_set_cpu_caps(void)
> > > >  	);
> > > >  
> > > >  	kvm_cpu_cap_init(CPUID_8000_0001_EDX,
> > > > -		F(FPU) | F(VME) | F(DE) | F(PSE) |
> > > > -		F(TSC) | F(MSR) | F(PAE) | F(MCE) |
> > > > -		F(CX8) | F(APIC) | 0 /* Reserved */ | F(SYSCALL) |
> > > > -		F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
> > > > -		F(PAT) | F(PSE36) | 0 /* Reserved */ |
> > > > -		F(NX) | 0 /* Reserved */ | F(MMXEXT) | F(MMX) |
> > > > -		F(FXSR) | F(FXSR_OPT) | X86_64_F(GBPAGES) | F(RDTSCP) |
> > > > +		AF(FPU) | AF(VME) | AF(DE) | AF(PSE) |
> > > > +		AF(TSC) | AF(MSR) | AF(PAE) | AF(MCE) |
> > > > +		AF(CX8) | AF(APIC) | 0 /* Reserved */ | F(SYSCALL) |
> > > > +		AF(MTRR) | AF(PGE) | AF(MCA) | AF(CMOV) |
> > > > +		AF(PAT) | AF(PSE36) | 0 /* Reserved */ |
> > > > +		F(NX) | 0 /* Reserved */ | F(MMXEXT) | AF(MMX) |
> > > > +		AF(FXSR) | F(FXSR_OPT) | X86_64_F(GBPAGES) | F(RDTSCP) |
> > > >  		0 /* Reserved */ | X86_64_F(LM) | F(3DNOWEXT) | F(3DNOW)
> > > >  	);
> > > >  
> > > 
> > > Hi,
> > > 
> > > What if we defined the aliased features instead.
> > > Something like this:
> > > 
> > > #define __X86_FEATURE_8000_0001_ALIAS(feature) \
> > > 	(feature + (CPUID_8000_0001_EDX - CPUID_1_EDX) * 32)
> > > 
> > > #define KVM_X86_FEATURE_FPU_ALIAS	__X86_FEATURE_8000_0001_ALIAS(KVM_X86_FEATURE_FPU)
> > > #define KVM_X86_FEATURE_VME_ALIAS	__X86_FEATURE_8000_0001_ALIAS(KVM_X86_FEATURE_VME)
> > > 
> > > And then just use for example the 'F(FPU_ALIAS)' in the CPUID_8000_0001_EDX
> > 
> > At first glance, I really liked this idea, but after working through the
> > ramifications, I think I prefer "converting" the flag when passing it to
> > kvm_cpu_cap_init().  In-place conversion makes it all but impossible for KVM to
> > check the alias, e.g. via guest_cpu_cap_has(), especially since the AF() macro
> > doesn't set the bits in kvm_known_cpu_caps (if/when a non-hacky validation of
> > usage becomes reality).
> 
> Could you elaborate on this as well?
> 
> My suggestion was that we can just treat aliases as completely independent
> and dummy features, say KVM_X86_FEATURE_FPU_ALIAS, and pass them as is to the
> guest, which means that if an alias is present in host cpuid, it appears in
> kvm caps, and thus qemu can then set it in guest cpuid.
> 
> I don't think that we need any special treatment for them if you look at it
> this way.  If you don't agree, can you give me an example?

KVM doesn't honor the aliases beyond telling userspace they can be set (see below
for all the aliased features that KVM _should_ be checking).  The APM clearly
states that the features are the same as their CPUID.0x1 counterparts, but Intel
CPUs don't support the aliases.  So, as you also note below, I think we could
unequivocally say that enumerating the aliases but not the "real" features is a
bogus CPUID model, but we can't say the opposite, i.e. the real features can
exists without the aliases.

And that means that KVM must never query the aliases, e.g. should never do
guest_cpu_cap_has(KVM_X86_FEATURE_FPU_ALIAS), because the result is essentially
meaningless.  It's a small thing, but if KVM_X86_FEATURE_FPU_ALIAS simply doesn't
exist, i.e. we do in-place conversion, then it's impossible to feed the aliases
into things like guest_cpu_cap_has().

Heh, on a related topic, __cr4_reserved_bits() fails to account for any of the
aliased features.  Unless I'm missing something, VME, DE, TSC, PSE, PAE, PGE and
MCE, all need to be handled in __cr4_reserved_bits().  Amusingly, 
nested_vmx_cr_fixed1_bits_update() handles the aliased legacy features.  I don't
see any reason for nested_vmx_cr_fixed1_bits_update() to manually query guest
CPUID, it should be able to use cr4_guest_rsvd_bits verbatim.

> > Side topic, if it's not already documented somewhere else, kvm/x86/cpuid.rst
> > should call out that KVM only honors the features in CPUID.0x1, i.e. that setting
> > aliased bits in CPUID.0x8000_0001 is supported if and only if the bit(s) is also
> > set in CPUID.0x1.
> 
> To be honest if KVM enforces this, such enforcement can be removed IMHO:

There's no enforcement, and as above I agree that this would be a bogus CPUID
model.  I was thinking that it could be helpful to document that KVM never checks
the aliases, but on second though, it's probably unnecessary because the APM does
say

  Same as CPUID Fn0000_0001_EDX[...]

for all the bits, i.e. setting the aliases without the real bits is an
architectural violation.

