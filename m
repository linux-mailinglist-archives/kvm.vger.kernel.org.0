Return-Path: <kvm+bounces-23261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 605339484EC
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 23:36:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8394A1C20A78
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 21:36:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88CC016D338;
	Mon,  5 Aug 2024 21:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="foK7udw6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFD357323
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 21:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722893756; cv=none; b=FPqBC3I3PjKs3E1Awsye99PIzMx3jyPjatxYqaTsDE3uitO5bFuSyJuH45jf0Mhe2cei+9+3wAPAxgP0eJmEWfKDMxUShY7oZnNB+1aY+nNyBFQCyqVUwpyFDTGCuL1h3f0U50qjk2/1c5cMn6QJPasLZvdg5ZyE4G94Qv5FDVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722893756; c=relaxed/simple;
	bh=u4ywBlsRL0BxaT3cYq2Z2kIJTx4MW2c/ESHGD59dVq8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JUr1CFebKA9InMesGMMG2q2z3fMtH7HKGr1AI5fgEFZpdnD8Av8niFib+Fco5RAclfvwTPkVAGKAUNIW/1CElBVD4DdTOYHh8XPxTsZe/9ZUgJuN2gzbnJe2WIOwp59tdRz6FiPfrlfi0VHCncS13bq1iCCuVPZoI0/9CFc1BJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=foK7udw6; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7a30753fe30so8506766a12.3
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 14:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722893755; x=1723498555; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7zEougPEyu/XsP7BiNYzpW05XehPP1UwCYeavBIksYY=;
        b=foK7udw6/eXCG0b3mNVvBvRdmlHZacwzmElavHqAKxFpVhuD63LWWL5LfF8mDpoLig
         taGxtnetywrBDA5U3/j4m4ucuDENqt1GCUyUD3eWcgTPkXVoOCrXgSoNocmnP5biig8h
         nEyS7AuPo9Fxqqy946F6m5cWpSOXQyeTMaQ4FPJZ0nWM5hAoz/VmuIR2lX0H0w8a0Zyo
         3mHWUfpsX6SblLvZPCZYMmVveVA8dgpNxI25YunPbTfAWFRsjHzjGR0dURSFQjfMSiBW
         dRJxScTppTQoKgTY882BHNUB8aNdYynJmHpRDdEtwgkExyp6d0izEyOitJlSOZKy4W/w
         3mPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722893755; x=1723498555;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7zEougPEyu/XsP7BiNYzpW05XehPP1UwCYeavBIksYY=;
        b=Qt+upUoaML9aeTrIrnLe/Ijef/FvChE54VQvkIs8+olC1crJWHa10vZglNO1WvdJkV
         NeS+yNRs+0BCMPUWb1e+wf88DGiCxoLpHEhMRVgZv6MKiIemvWMfTEn+2MGkh8+aCE1/
         zXRMWrV7kVzJPL8vvHWtkoxhuX/8yvHt2wVnFMJrddtTmVuGswVU/HRqHsg5r3tfBqVw
         ERQUeVvSV8BGl8n9rVOL+/404dHQjSw2wka1IbfqUbViVo/imy+/5nezIzgZSnTVn0iA
         0N7GdCwX8EPeVS9bcs7RSdw6V9trqggeEFMQNdEPqM1LW0zg3qq1ZcNEyxwhdMSECgc5
         /ghQ==
X-Forwarded-Encrypted: i=1; AJvYcCWtahK5Uz7gbGDhCe9IZXwZw/6sK/GYF8b5+o/tV7xiUEf1o93SJzBogkFu4ELvBDXZJeuroYD6ubhxYAob3fWPOzfs
X-Gm-Message-State: AOJu0YyGNyvPAcwHAotpuDFZd5bRTw63FTKqt8aJEIGBGGmnmDKF2hzj
	ZqeWh7ETJSEAhPwN3phbdTgvh0s5g4xH001miPRVoAb1Z/eYeIuCwFURZoE0x7dadXR1ZUYr66t
	ExQ==
X-Google-Smtp-Source: AGHT+IHOyNGBl0lTxCv1pGrwQOW9eslx0DzywsCu/KV//UKtHQ2KhGiXtjHiSMZdzddUzk4dGaKgMyPOW3Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:bd4a:0:b0:785:e3e:38d3 with SMTP id
 41be03b00d2f7-7b74853d441mr28660a12.7.1722893754549; Mon, 05 Aug 2024
 14:35:54 -0700 (PDT)
Date: Mon, 5 Aug 2024 14:35:53 -0700
In-Reply-To: <ffa76b1b62c5cd2001f5f313009376e131bc2817.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com> <20240517173926.965351-25-seanjc@google.com>
 <20d3017a8dd54b345104bf2e5cb888a22a1e0a53.camel@redhat.com>
 <ZoxaOqvXzTH6O64D@google.com> <31cf77d34fc49735e6dff57344a0e532e028a975.camel@redhat.com>
 <ZqQybtNkhSVZDOTu@google.com> <ffa76b1b62c5cd2001f5f313009376e131bc2817.camel@redhat.com>
Message-ID: <ZrFFua_7kWKBESbe@google.com>
Subject: Re: [PATCH v2 24/49] KVM: x86: #undef SPEC_CTRL_SSBD in cpuid.c to
 avoid macro collisions
From: Sean Christopherson <seanjc@google.com>
To: mlevitsk@redhat.com
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

+Boris

On Mon, Aug 05, 2024, mlevitsk@redhat.com wrote:
> =D0=A3 =D0=BF=D1=82, 2024-07-26 =D1=83 16:34 -0700, Sean Christopherson =
=D0=BF=D0=B8=D1=88=D0=B5:
> > > On Wed, Jul 24, 2024, Maxim Levitsky wrote:
> > > > > On Mon, 2024-07-08 at 14:29 -0700, Sean Christopherson wrote:
> > > > > > > On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> > > > > > > > > Maybe we should instead rename the SPEC_CTRL_SSBD to
> > > > > > > > > 'MSR_IA32_SPEC_CTRL_SSBD' and together with it, other fie=
lds of this msr.=C2=A0 It
> > > > > > > > > seems that at least some msrs in this file do this.
> > > > > > >=20
> > > > > > > Yeah, the #undef hack is quite ugly.=C2=A0 But I didn't (and =
still don't) want to
> > > > > > > introduce all the renaming churn in the middle of this alread=
y too-big series,
> > > > > > > especially since it would require touching quite a bit of cod=
e outside of KVM.
> > > > >=20
> > > > > > >=20
> > > > > > > I'm also not sure that's the right thing to do; I kinda feel =
like KVM is the one
> > > > > > > that's being silly here.
> > > > >=20
> > > > > I don't think that KVM is silly here. I think that hardware defin=
itions like
> > > > > MSRs, register names, register bit fields, etc, *must* come with =
a unique
> > > > > prefix, it's not an issue of breaking some deeply nested macro, b=
ut rather an
> > > > > issue of readability.
> > >=20
> > > For the MSR names themselves, yes, I agree 100%.=C2=A0 But for the bi=
ts and mask, I
> > > disagree.=C2=A0 It's simply too verbose, especially given that in the=
 vast majority
> > > of cases simply looking at the surrounding code will provide enough c=
ontext to
> > > glean an understanding of what's going on.
>=20
> I am not that sure about this, especially if someone by mistake uses a fl=
ag
> that belong to one MSR, in some unrelated place. Verbose code is rarely a=
 bad thing.
>=20
>=20
> > > =C2=A0 E.g. even for SPEC_CTRL_SSBD, where
> > > there's an absurd amount of magic and layering, looking at the #defin=
e makes
> > > it fairly obvious that it belongs to MSR_IA32_SPEC_CTRL.
> > >=20
> > > And for us x86 folks, who obviously look at this code far more often =
than non-x86
> > > folks, I find it valuable to know that a bit/mask is exactly that, an=
d _not_ an
> > > MSR index.=C2=A0 E.g. VMX_BASIC_TRUE_CTLS is a good example, where re=
naming that to
> > > MSR_VMX_BASIC_TRUE_CTLS would make it look too much like MSR_IA32_VMX=
_TRUE_ENTRY_CTLS
> > > and all the other "true" VMX MSRs.
> > >=20
> > > > > SPEC_CTRL_SSBD for example won't mean much to someone who only kn=
ows ARM, while
> > > > > MSR_SPEC_CTRL_SSBD, or even better IA32_MSR_SPEC_CTRL_SSBD, lets =
you instantly know
> > > > > that this is a MSR, and anyone with even a bit of x86 knowledge s=
hould at least have
> > > > > heard about what a MSR is.
> > > > >=20
> > > > > In regard to X86_FEATURE_INTEL_SSBD, I don't oppose this idea, be=
cause we have
> > > > > X86_FEATURE_AMD_SSBD, but in general I do oppose the idea of addi=
ng 'INTEL' prefix,
> > >=20
> > > Ya, those are my feelings exactly.=C2=A0 And in this case, since we a=
lready have an
> > > AMD variant, I think it's actually a net positive to add an INTEL var=
iant so that
> > > it's clear that Intel and AMD ended up defining separate CPUID to enu=
merate the
> > > same basic info.
> > >=20
> > > > > because it sets a not that good precedent, because most of the fe=
atures on x86
> > > > > are first done by Intel, but then are also implemented by AMD, an=
d thus an intel-only
> > > > > feature name can stick after it becomes a general x86 feature.
> > > > >=20
> > > > > IN case of X86_FEATURE_INTEL_SSBD, we already have sadly differen=
t CPUID bits for
> > > > > each vendor (although I wonder if AMD also sets the X86_FEATURE_I=
NTEL_SSBD).
> > > > >=20
> > > > > I vote to rename 'SPEC_CTRL_SSBD', it can be done as a standalone=
 patch, and can
> > > > > be accepted right now, even before this patch series is accepted.
> > >=20
> > > If we go that route, then we also need to rename nearly ever bit/mask=
 definition
> > > in msr-index.h, otherwise SPEC_CTRL_* will be the odd ones out.=C2=A0=
 And as above, I
> > > don't think this is the right direction.
>=20
> Honestly not really. If you look carefully at the file, many bits are alr=
eady defined
> in the way I suggest, for example:
>=20
> MSR_PLATFORM_INFO_CPUID_FAULT_BIT
> MSR_IA32_POWER_CTL_BIT_EE
> MSR_INTEGRITY_CAPS_ARRAY_BIST_BIT
> MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT

Heh, I know there are some bits that have an "MSR" prefix, hence "nearly ev=
ery".

> This file has all kind of names for both msrs and flags. There is not muc=
h
> order, so renaming the bit definitions of IA32_SPEC_CTRL won't increase t=
he
> level of disorder in this file IMHO.

It depends on what direction msr-index.h is headed.  If the long-term prefe=
rence
is to have bits/masks namespaced with only their associated MSR name, i.e. =
no
explicit MSR_, then renaming the bits is counter-productive.

I added Boris, who I believe was the most opinionated about the MSR bit nam=
es,
i.e. who can most likely give us the closest thing to an authoritative answ=
er as
to the preferred style.

Boris, we're debating about the best way to solve a weird collision between=
:

  #define SPEC_CTRL_SSBD

and

  #define X86_FEATURE_SPEC_CTRL_SSBD

KVM wants to use its CPUID macros to essentially do:

  #define F(name) (X86_FEATURE_##name)

as a shorthand for X86_FEATURE_SPEC_CTRL_SSBD, but that can cause build fai=
lures
depending on how KVM's macros are layered.  E.g. SPEC_CTRL_SSBD can get res=
olved
to its value prior to token concatentation and result in KVM effectively ge=
nerating
X86_FEATURE_BIT(SPEC_CTRL_SSBD_SHIFT).

One of the proposed solutions is to rename all of the SPEC_CTRL_* bit defin=
itions
to add a MSR_ prefix, e.g. to generate MSR_SPEC_CTRL_SSBD and avoid the con=
flict.
My recollection from the IA32_FEATURE_CONTROL rework a few years back is th=
at you
wanted to prioritize shorter names over having everything namespaced with M=
SR_,
i.e. that this approach is a non-starter.

