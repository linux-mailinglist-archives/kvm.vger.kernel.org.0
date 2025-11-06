Return-Path: <kvm+bounces-62143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D06FC38AE2
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 02:18:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 826E44E6182
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 01:17:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 744131EA7DF;
	Thu,  6 Nov 2025 01:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G/o1Qivt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290281E1E00
	for <kvm@vger.kernel.org>; Thu,  6 Nov 2025 01:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762391861; cv=none; b=YzxJpRUfNgMdiYqln1CDU5iPgu6lv9x6BBiEzDSCp0SX26++PidLYNrYUOa6gGaYZwxsw1YR0dXBiIlPvvtBZaNx1+tPhBOFglWrEIVlGJKNyuNbXSXbmLmjbIBZAEaLWeJbftW6hsm89kDcD/e/QxsxnTuzJuHprXwPrFzhaYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762391861; c=relaxed/simple;
	bh=Hzj1ZOFFQ4qr1T6DF895OmWTOiISdOtvvMO9Bpns6oY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pzWaUayt5iMIZQeRzdHvkeVvDe9KK4gouFxXkHr1Tv5X/wVpo5s7TngwrsgjPrtzWeApWlFCBRb7QCkDbhimnxZrtsJ9/Q0PEsW9uSAVgBSzlXLnAMS+WWvJ9KFwUMgFOJveCQo6NBF5mCkXxPsRs/SkQ4F6EaniJLneNP8pZok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G/o1Qivt; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-290e4fade70so6312815ad.2
        for <kvm@vger.kernel.org>; Wed, 05 Nov 2025 17:17:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762391859; x=1762996659; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=egaTeKmZH3MsiQ77iEGjmrF6q7qSzEANy/mqeCP2/Vc=;
        b=G/o1QivtW3JTIiurzjRiO/XrcdyRn8fkSS1ahahxi0KLU9Bda+PuS6vIr6lE8zmork
         UdzfpW1uZn7BUZge4/yrXZPqvm1BQIJSB26Fk6TDw9elpslcupPLKaRxn1ryoMvrNbRb
         7F8vRnOTvNOs+7oX9ZMF2TtLcacTmfCzCi/sWf2QaiM1JBeGdzK4DFPXPK1MVsbgaLP9
         AtgtlblEiSaCgqn4nBfl8MahCffUXHkhQg6nK++GU5bptzw4QbfidXqg2B8SPMNnd5gx
         kMDmtRyWQNayheENla7Udl70IOr+OM7GXxAZi26a+CPNQP8PVvLzr5HhAFq2DjjSE2dG
         Ev+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762391859; x=1762996659;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=egaTeKmZH3MsiQ77iEGjmrF6q7qSzEANy/mqeCP2/Vc=;
        b=KwbjK4WAGHnIA6T6k+8wB2CksT6BC9rQjzgOnptfzFmjeWY3LFMouNrNX71gXZp5ti
         z7oPznWxGeW1Pu2FVAOSZPesCjN9H/aNiQYdISQ0ywuymsGlMBojhuMfrxVWuO4D7SRa
         WMb7cL6WERiuIfh4cfwVnKC4giiTc0FJHE1MRnXs50jujHedcmW5ZNKUSZpj9Bsgh730
         dt3ZERbH8c9lAu6bIasIHRWu+t4ODJOChu6635U2JcYT7i9p0xrGO4nDAufJgbSG/+KA
         YUCxd5NYO1YMU0o57pJ/mnLwfIdVW5RUZqLbMFdqjroM9HkLslV8EyYD/V/E2hRRA9em
         prlw==
X-Forwarded-Encrypted: i=1; AJvYcCXnBZsS7ciwtzwC2z9Zg0wPWx/BTCJSSpcrPF3JO1gw+1rUdBrSpFMLUT9qbNMaxJx1BGM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxv40zYqAoMK8Blr6pDMLO/wmW8c74gBTTZmUkIeIoxO5UQBqFb
	eA107u+PAtW8SZvgRnsexMuAv8OrmYeuyMX/xKaTHrBz24rc9CR5FLqCvWUBQOG6u7sOfu+a1YB
	T9NkjJA==
X-Google-Smtp-Source: AGHT+IHVPj0WcRyhI6XY8LQgNPorSmO1GHRvggSCMVCTSuZdoZz6/QBmbxzOoBGxVdWnViygH6yaaEdhx04=
X-Received: from pjbnl18.prod.google.com ([2002:a17:90b:3852:b0:341:8ac7:27a9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:18c:b0:295:613f:3d63
 with SMTP id d9443c01a7336-2962ad870e7mr69798685ad.37.1762391859583; Wed, 05
 Nov 2025 17:17:39 -0800 (PST)
Date: Wed, 5 Nov 2025 17:17:38 -0800
In-Reply-To: <heahqrdiujkusb42hir3qbejwnc6svspt3owwtat345myquny4@5ebkzc6mt2y3>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251104195949.3528411-1-yosry.ahmed@linux.dev>
 <20251104195949.3528411-4-yosry.ahmed@linux.dev> <aQub_AbP6l6BJlB2@google.com>
 <heahqrdiujkusb42hir3qbejwnc6svspt3owwtat345myquny4@5ebkzc6mt2y3>
Message-ID: <aQv3Ml60dVpQ-fvz@google.com>
Subject: Re: [PATCH 03/11] KVM: nSVM: Add missing consistency check for event_inj
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 05, 2025, Yosry Ahmed wrote:
> On Wed, Nov 05, 2025 at 10:48:28AM -0800, Sean Christopherson wrote:
> > On Tue, Nov 04, 2025, Yosry Ahmed wrote:
> > > According to the APM Volume #2, 15.20 (24593=E2=80=94Rev. 3.42=E2=80=
=94March 2024):
> > >=20
> > >   VMRUN exits with VMEXIT_INVALID error code if either:
> > >   =E2=80=A2 Reserved values of TYPE have been specified, or
> > >   =E2=80=A2 TYPE =3D 3 (exception) has been specified with a vector t=
hat does not
> > >     correspond to an exception (this includes vector 2, which is an N=
MI,
> > >     not an exception).
> > >=20
> > > Add the missing consistency checks to KVM. For the second point, inje=
ct
> > > VMEXIT_INVALID if the vector is anything but the vectors defined by t=
he
> > > APM for exceptions. Reserved vectors are also considered invalid, whi=
ch
> > > matches the HW behavior.
> >=20
> > Ugh.  Strictly speaking, that means KVM needs to match the capabilities=
 of the
> > virtual CPU.  E.g. if the virtual CPU predates SEV-ES, then #VC should =
be reserved
> > from the guest's perspective.
> >=20
> > > Vector 9 (i.e. #CSO) is considered invalid because it is reserved on =
modern
> > > CPUs, and according to LLMs no CPUs exist supporting SVM and producin=
g #CSOs.
> > >=20
> > > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > ---
> > >  arch/x86/include/asm/svm.h |  5 +++++
> > >  arch/x86/kvm/svm/nested.c  | 33 +++++++++++++++++++++++++++++++++
> > >  2 files changed, 38 insertions(+)
> > >=20
> > > diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> > > index e69b6d0dedcf0..3a9441a8954f3 100644
> > > --- a/arch/x86/include/asm/svm.h
> > > +++ b/arch/x86/include/asm/svm.h
> > > @@ -633,6 +633,11 @@ static inline void __unused_size_checks(void)
> > >  #define SVM_EVTINJ_VALID (1 << 31)
> > >  #define SVM_EVTINJ_VALID_ERR (1 << 11)
> > > =20
> > > +/* Only valid exceptions (and not NMIs) are allowed for SVM_EVTINJ_T=
YPE_EXEPT */
> > > +#define SVM_EVNTINJ_INVALID_EXEPTS (NMI_VECTOR | BIT_ULL(9) | BIT_UL=
L(15) | \
> > > +				    BIT_ULL(20) | GENMASK_ULL(27, 22) | \
> > > +				    BIT_ULL(31))
> >=20
> > As above, hardcoding this won't work.  E.g. if a VM is migrated from a =
CPU where
> > vector X is reserved to a CPU where vector X is valid, then the VM will=
 observe
> > a change in behavior.=20
> >=20
> > Even if we're ok being overly permissive today (e.g. by taking an errat=
um), this
> > will create problems in the future when one of the reserved vectors is =
defined,
> > at which point we'll end up changing guest-visible behavior (and will h=
ave to
> > take another erratum, or maybe define the erratum to be that KVM straig=
ht up
> > doesn't enforce this correctly?)
> >=20
> > And if we do throw in the towel and don't try to enforce this, we'll st=
ill want
> > a safeguard against this becoming stale, e.g. when KVM adds support for=
 new
> > feature XYZ that comes with a new vector.
> >=20
> > Off the cuff, the best idea I have is to define the positive set of vec=
tors
> > somewhere common with a static assert, and then invert that.  E.g. mayb=
e something
> > shared with kvm_trace_sym_exc()?
>=20
> Do you mean define the positive set of vectors dynamically based on the
> vCPU caps? Like a helper returning a dynamic bitmask instead of
> SVM_EVNTINJ_INVALID_EXEPTS?

Ya, that would be option #1, though I'm not entirely sure it's a good optio=
n.
The validity of vectors aren't architecturally tied to the existince of any
particular feature, at least not explicitly.  For the "newer" vectors, i.e.=
 the
ones that we can treat as conditionally valid, it's pretty obvious which fe=
atures
they "belong" to, but even then I hesitate to draw connections, e.g. on the=
 off
chance that some weird hypervisor checks Family/Model/Stepping or something=
.

> If we'll reuse that for kvm_trace_sym_exc() it will need more work, but
> I don't see why we need a dynamic list for kvm_trace_sym_exc().

Sorry, this is for option #2.  Hardcode the set of vectors that KVM allows =
(to
prevent L1 from throwing pure garbage at hardware), but otherwise defer to =
the
CPU to enforce the reserved vectors.

Hrm, but option #2 just delays the inevitable, e.g. we'll be stuck once aga=
in
when KVM supports some new vector, in which case we'll have to change guest
visible behavior _again_, or bite the bullet and do option #1.

So I guess do option #1 straight away and hope nothing breaks?  Maybe hardc=
ode
everything as supported except #CP (SHSTK) and #VC (SEV-ES)?

> So my best guess is that I didn't really understand your suggestion :)

