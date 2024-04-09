Return-Path: <kvm+bounces-13944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D24489CFE6
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 03:37:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F7DE1C23C17
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 01:37:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 501F3F9CD;
	Tue,  9 Apr 2024 01:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uu4HvniB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB50E8BE8
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 01:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712626655; cv=none; b=c/2Mq+HIp2fvNGRK7ZvuNdEvuSLKyTrMlZ9NADfffrRv49AoNrc3MQ1eRJA5AuTySTaRAqAGoW/j25e9P86bIijeCEQaMvBU914QoNuTsJMa9QqnkeYUXq0ue1uOYvqvZbukQ6wZNysrW2u4ZMo04fVF5N5jlRjQMXGtn7PmaEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712626655; c=relaxed/simple;
	bh=BaSg7ch3d2lz1UPLvkxJNOW7XPlVJW6QBboYvJclAi0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PLQDQb+zkJ6TOTggW/cenJO49iA7VDCWMoMNN0o7A3cyFIEQFI8IIov5Ob5rsELNBtA4yiKQ5fPf1sEaOsvR4IlNsHnfoy3MATzCrlMDCgQ4Oe44O1uZNHk8GHNZxeAi8DGdwTc0uC4i80hl89rm8gXrl7J2HVGBymcVQGnN+l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uu4HvniB; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1e0b5e55778so38741785ad.3
        for <kvm@vger.kernel.org>; Mon, 08 Apr 2024 18:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712626653; x=1713231453; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pTnXG7YvYzmRGdsTsIToSlQ51H4VFsJL7wKMPVx2EDM=;
        b=uu4HvniBTFSS7+BwzaIEKokOmCBsYE7aV3j5k3abu0jCFNjM6FU4LFgDP2F+ZQzmmD
         fguzlsEMPyrDisOK+GGKfpKTyt4T30sbbrbbyQOyedu3On0RJfoIcXa31bhBH/gADzR5
         OhgCqaR7gIsz/LqC6ilnip9PzkT0uQ6+5n+X9v5e/G4Y1ucWzJLFKmrpzgDyzRaeO6U1
         c/jfTb0mnnZS4HQ+Ej0AsM0zklm1PrAiKDqdSfPAJWLNCOLMpMVv+8VSpATxueam1VDN
         st9dvHpJdwO/wkLPfm9i6xMmDkNk1e3P8FDpL6G46dNWLe0N/xWPXyt6D5UynPtOVKlu
         ibFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712626653; x=1713231453;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pTnXG7YvYzmRGdsTsIToSlQ51H4VFsJL7wKMPVx2EDM=;
        b=r2Xn6w9n62J7ojOWnTX0q3J666n0As64GKJNtNEcD4Jk0b2/5czEBez/LzIyLHKUOP
         tqsAeIqDR1MQ9pcpqWxDNKh2AXjsLAn2NChGosm4Zo0E5Zcf0l6bJjb70wX4lF98CNuu
         RW73cw65CUqBR++U45qX5xE0b7t0oYrrlPXYWr/tRAXl7/7/e5L+/4TKWdj9yqyfXqx8
         1gCh8xDdwA4DzTADeziz4vuXXiwEXHTC6p28tCz86CqfANo8Rv2vXtVzHAt0QqGNA+mI
         HUgHbfGsJpgOT+KeeLQPULsV8UmX7dpZzJBdCguga5CjWEiWDEyyRSzrJf9uV5AKLdkJ
         WM+A==
X-Forwarded-Encrypted: i=1; AJvYcCWA/NrMwqyUK0N7T2e3wVpIcVd43WGCUyg+Ge15KySjT94ZaMl1i4JN/fvZv/KgHgsgjUtwPtOqAjzaq+RNkVRnhm9M
X-Gm-Message-State: AOJu0YzT+3Bf0dy+CcN8ApC3zn0Yaz1iLKvH7qTETd/a0y1f3l/ENVIg
	Iba3FXA/d1B2t/Ke9ZU/pRrgtdSaW2Jfdnm+skFVAdKCiL8+Mj/9AXZwtL3j4vn8UaVWdSjd+cn
	Eeg==
X-Google-Smtp-Source: AGHT+IHz67h1hmRwe9KXBRLMyq3Gzn7HhjiIHEg9/DPuUSctMPB71xN043N2itoO/43t2nfaG4/U84FiJ60=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:230b:b0:1e4:4056:b969 with SMTP id
 d11-20020a170903230b00b001e44056b969mr274362plh.10.1712626653272; Mon, 08 Apr
 2024 18:37:33 -0700 (PDT)
Date: Mon, 8 Apr 2024 18:37:31 -0700
In-Reply-To: <957b26d18ba7db611ed6582366066667267d10b8.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240405165844.1018872-1-seanjc@google.com> <73b40363-1063-4cb3-b744-9c90bae900b5@intel.com>
 <ZhQZYzkDPMxXe2RN@google.com> <a17c6f2a3b3fc6953eb64a0c181b947e28bb1de9.camel@intel.com>
 <ZhQ8UCf40UeGyfE_@google.com> <5faaeaa7bc66dbc4ea86a64ef8e8f9b22fd22ef4.camel@intel.com>
 <ZhRxWxRLbnrqwQYw@google.com> <957b26d18ba7db611ed6582366066667267d10b8.camel@intel.com>
Message-ID: <ZhSb28hHoyJ55-ga@google.com>
Subject: Re: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "davidskidmore@google.com" <davidskidmore@google.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"srutherford@google.com" <srutherford@google.com>, "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Wei W Wang <wei.w.wang@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 08, 2024, Rick P Edgecombe wrote:
> On Mon, 2024-04-08 at 15:36 -0700, Sean Christopherson wrote:
> > > Currently the values for the directly settable CPUID leafs come via a=
 TDX
> > > specific init VM userspace API.
> >=20
> > Is guest.MAXPHYADDR one of those?=C2=A0 If so, use that.
>=20
> No it is not configurable. I'm looking into make it configurable, but it =
is not
> likely to happen before we were hoping to get basic support upstream.

Yeah, love me some hardware defined software.

> An alternative would be to have the KVM API peak at the value, and then
> discard it (not pass the leaf value to the TDX module). Not ideal.

Heh, I typed up this idea before reading ahead.  This has my vote.  Unless =
I'm
misreading where things are headed, using guest.MAXPHYADDR to communicate w=
hat
is essentially GPAW to the guest is about to become the de facto standard.

At that point, KVM can basically treat the current TDX module behavior as a=
n
erratum, i.e. discarding guest.MAXPHYADDR becomes a workaround for a "CPU" =
bug,
not some goofy KVM quirk.

> Or have a dedicated GPAW field and expose the concept to userspace like
> Xiaoyao was talking about.

I'd prefer not to.  As above, it's not KVM's fault that the TDX module can'=
t move
fast enough to adapt.

> > > So should we look at making the TDX side follow a
> > > KVM_GET_SUPPORTED_CPUID/KVM_SET_CPUID pattern for feature enablement?=
 Or am
> > > I
> > > misreading general guidance out of this specific suggestion around GP=
AW?=20
> >=20
> > No?=C2=A0 Where I was going with that, is _if_ vCPUs can be created (in=
 KVM) before
> > the GPAW is set (in the TDX module), then using vCPU0's guest.MAXPHYADD=
R tokkk
> > compute the desired GPAW may be the least awful solution, all things
> > considered.
>=20
> Sorry, I was trying to uplevel the conversation to be about the general c=
oncept
> of matching TD configuration to CPUID bits. Let me try to articulate the =
problem
> a little better.
>=20
> Today, KVM=E2=80=99s KVM_GET_SUPPORTED_CPUID is a way to specify which fe=
atures are
> virtualizable by KVM. Communicating this via CPUID leaf values works for =
the
> most part, because CPUID is already designed to communicate which feature=
s are
> supported. But TDX has a different language to communicate which features=
 are
> supported. That is special fields that are passed when creating a VM: XFA=
M
> (matching XCR0 features) and ATTRIBUTES (TDX specific flags for MSR based
> features like PKS, etc). So compared to KVM_GET_SUPPORTED_CPUID/KVM_SET_C=
PUID,
> the TDX module instead accepts only a few CPUID bits to be set directly b=
y the
> VMM, and sets other CPUID leafs to match the configured features via XFAM=
 and
> ATTRIBUTES.
>=20
> There are also some bits/features that have fixed values. Which leafs are=
 fixed
> and what the values are isn't something provided by any current TDX modul=
e API.
> Instead they are only known via documentation, which is subject to change=
. The
> queryable information is limited to communicating which bits are directly
> configurable.=20

As I said in PUCK (and recorded in the notes), the fixed values should be p=
rovided
in a data format that is easily consumed by C code, so that KVM can report =
that
to userspace with

> So the current interface won't allow us to perfectly match the
> KVM_GET_SUPPORTED_CPUID/KVM_SET_CPUID. Even excluding the vm-scoped vs vc=
pu-
> scoped differences. However, we could try to match the general design a
> little better.

No, don't try to match KVM_GET_SUPPORTED_CPUID, it's a terrible API that no=
 one
likes.  The only reason we haven't replaced is because no one has come up w=
ith a
universally better idea.  For feature flags, communicating what KVM support=
s is
straightforward, mostly.  But for things like topology, communicating exact=
ly what
KVM "supports" is much more difficult.

The TDX fixed bits are very different.  It's the TDX module, and thus KVM, =
saying
"here are the bits that you _must_ set to these exact values".

> Here we were discussing making gpaw configurable via a dedicated named fi=
eld,
> but the suggestion is to instead include it in CPUID bits. The current AP=
I takes
> ATTRIBUTES as a dedicated field too. But there actually are CPUID bits fo=
r some
> of those features. Those CPUID bits are controlled instead via the associ=
ated
> ATTRIBUTES. So we could expose such features via CPUID as well. Userspace=
 would
> for example, pass the PKS CPUID bit in, and KVM would see it and configur=
e PKS
> via the ATTRIBUTES bit.
>=20
> So what I was looking to understand is, what is the enthusiasm for genera=
lly
> continuing to use CPUID has the main method for specifying which features=
 should
> be enabled/virtualized, if we can't match the existing
> KVM_GET_SUPPORTED_CPUID/KVM_SET_CPUID APIs. Is the hope just to make user=
space's
> code more unified between TDX and normal VMs?

I need to look at the TDX code more to form an (updated) opinion.  IIRC, my=
 opinion
from four years ago was to use ATTRIBUTES and then force CPUID to match.  W=
hether
or not that's still my preferred approach probably depends on how many, and=
 what,
things are shoved into attributes.

