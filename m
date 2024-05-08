Return-Path: <kvm+bounces-17027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B4FBA8C012F
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 17:42:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B86B1F277B3
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 15:42:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5685127E28;
	Wed,  8 May 2024 15:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SgHt48bT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7511272B5
	for <kvm@vger.kernel.org>; Wed,  8 May 2024 15:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715182935; cv=none; b=tPAkME8CvHYrFLnPMJ9arozh+RaDa2BwIybjyZjJ0OCcnle+ceo4qGssd9kX4rOpIyAF9a74dxaQLOpHWMjMqTnC44vUxwnOtpvBVwTU6YA1D7fUytFCUVtpKkFM01yEYJkxZu8bhm/dBsW0KW6U+hMooberfsk9xA8mtDaSYfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715182935; c=relaxed/simple;
	bh=9ynvT10YkZCIy6TTWzwD4yvcGsUePB5gaKna/jJ5l7g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k+Foslq2QF+umP9axo6236zkPknWLZ4B4MHPMfwhBpu4Ikrshtcj7Ip4MrhnX6v4NnJaRpmCWqglGJQADu+shBAKn0JXMJCnCL2akme3zC3ig1RXK/o6RLdY+2VrxlT4d3R/yEqcIk8dFXDwJS8ZGLVzJoBPVvr2fUqdmAQeElE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SgHt48bT; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1ec3e871624so45730955ad.2
        for <kvm@vger.kernel.org>; Wed, 08 May 2024 08:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715182933; x=1715787733; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bo9VuQdvRcAtI083NJ7d1OylnQTQZ5tXraNuKux1iG8=;
        b=SgHt48bT7+2IjScyI9LiKQwM4oEJRHjKI0JP6uupFdKoPBBXb2hDkBquX9AiH1p4YN
         QB8QwJphISDKVjlHn3BZe2BFPfYg4BVfN1f/OVB5iMcOQ68fg++cYlDDuUEyXengkWt0
         j6KKiziiBY4o/Df5MyDesA8Hn3IiyBA3pLx5GeQ3Ck7nENOVItxyEx0nk5opgkwji/tZ
         aseAPCLkqyHQsgRoRNgvKoeU+JnSBvCyDIL2Y+24YjBaHYm/pgmK74C/0AqTbP7nhxWV
         26gETxUnjzbYUO4mWNQHjWe/O3xnq6NtbWGZZvnF68WuXLlprlD36JiOG5jBK0RUI8XT
         iO7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715182933; x=1715787733;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Bo9VuQdvRcAtI083NJ7d1OylnQTQZ5tXraNuKux1iG8=;
        b=CrrNRpUiHyfd52C5jOdPiKmSPGc219EZbiUsoZBhwV7c5FnZZ1g47y3J46enRA/P+h
         wSMtwGA4rR914SPIlxZaLZPhe5fy0Dawu2Rk9hJ6N8ZsnACZrh4g457DJ6g5d8IU/iIi
         WgsBO1UB2LrYezWQddLz4+b5xAlvsdeicXTwUHEk/ec+Eliyl2c3tgL9PP7q0xpvkpmd
         9mj3i6dn2AnWpOvTmIJ0VK2HPqVdnkCLnWLfkB1ilKCBG6IERVkPCnIR5AagHu2dtAcf
         cncP2++6g7cak1ZK5CAXCCjJJFcxfm4F3bUOwVghvKW8vJk4XcAQE4x9MOWa28o2c6vy
         h73g==
X-Forwarded-Encrypted: i=1; AJvYcCX3fMPINvUJ5gLALlBQmdPSNpN0NJkDsR5NuULyeZ2/SEBhHEzplb+n1OPGKObRDCpToGDWlx6G72w6bfrZiwSvHWXA
X-Gm-Message-State: AOJu0YwsAOVKOiZSRafaqZwuKohMvEsD41BrJa00qed7VdKPcpd2ZShJ
	IE1KSKR3s+PNsIAbVzscveTHyOz5P6y1Zc9D+7rW934ysLK6j0SgMdghK8NTUGu9BrIa+b9oHbj
	G9Q==
X-Google-Smtp-Source: AGHT+IGAbz30cO17DzD7X/ezI4pW0Tsw2vNLBMXmYH9my/4n9d5zl3nBTRJjTRzgWuPF+Ihvv4LKcsY3B1k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ea0c:b0:1e2:118f:e587 with SMTP id
 d9443c01a7336-1eeb0594e5dmr900165ad.13.1715182932746; Wed, 08 May 2024
 08:42:12 -0700 (PDT)
Date: Wed, 8 May 2024 08:42:11 -0700
In-Reply-To: <CALMp9eSK-B91vdGZsbbgMitCNuBgBz=s67=PiPLCDxEzhFAb=w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240411205911.1684763-1-jmattson@google.com> <CAA0tLEor+Sqn6YjYdJWEs5+b9uPdaqQwDPChh1YEGWBi2NAAAw@mail.gmail.com>
 <CALMp9eSBNjSXgsbhau-c68Ow_YoLvWBK6oUc1v1DqSfmDskmhg@mail.gmail.com> <CALMp9eSK-B91vdGZsbbgMitCNuBgBz=s67=PiPLCDxEzhFAb=w@mail.gmail.com>
Message-ID: <ZjudUw7Bi7RWqRes@google.com>
Subject: Re: [PATCH] KVM: x86: AMD's IBPB is not equivalent to Intel's IBPB
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Venkatesh Srinivas <venkateshs@chromium.org>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 07, 2024, Jim Mattson wrote:
> On Thu, Apr 11, 2024 at 7:57=E2=80=AFPM Jim Mattson <jmattson@google.com>=
 wrote:
> >
> > On Thu, Apr 11, 2024 at 6:32=E2=80=AFPM Venkatesh Srinivas
> > <venkateshs@chromium.org> wrote:
> > >
> > > On Thu, Apr 11, 2024 at 1:59=E2=80=AFPM Jim Mattson <jmattson@google.=
com> wrote:
> > > >
> > > > From Intel's documention [1], "CPUID.(EAX=3D07H,ECX=3D0):EDX[26]
> > > > enumerates support for indirect branch restricted speculation (IBRS=
)
> > > > and the indirect branch predictor barrier (IBPB)." Further, from [2=
],
> > > > "Software that executed before the IBPB command cannot control the
> > > > predicted targets of indirect branches (4) executed after the comma=
nd
> > > > on the same logical processor," where footnote 4 reads, "Note that
> > > > indirect branches include near call indirect, near jump indirect an=
d
> > > > near return instructions. Because it includes near returns, it foll=
ows
> > > > that **RSB entries created before an IBPB command cannot control th=
e
> > > > predicted targets of returns executed after the command on the same
> > > > logical processor.**" [emphasis mine]
> > > >
> > > > On the other hand, AMD's "IBPB may not prevent return branch
> > > > predictions from being specified by pre-IBPB branch targets" [3].
> > > >
> > > > Since Linux sets the synthetic feature bit, X86_FEATURE_IBPB, on AM=
D
> > > > CPUs that implement the weaker version of IBPB, it is incorrect to
> > > > infer from this and X86_FEATURE_IBRS that the CPU supports the
> > > > stronger version of IBPB indicated by CPUID.(EAX=3D07H,ECX=3D0):EDX=
[26].
> > >
> > > AMD's IBPB does apply to RET predictions if Fn8000_0008_EBX[IBPB_RET]=
 =3D 1.
> > > Spot checking, Zen4 sets that bit; and the bulletin doesn't apply the=
re.
> >
> > So, with a definition of X86_FEATURE_AMD_IBPB_RET, this could be:
> >
> >        if (boot_cpu_has(X86_FEATURE_AMD_IBPB_RET) &&
> > boot_cpu_has(X86_FEATURE_IBRS))
> >                kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL);
> >
> > And, in the other direction,
> >
> >     if (boot_cpu_has(X86_FEATURE_SPEC_CTRL))
> >         kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB_RET);
> >
> > But, perhaps all of this cross-vendor equivalence logic belongs in user=
 space.
>=20
> In case it wasn't clear, I contend that any cross-vendor equivalence
> logic *does* belong in userspace.
>=20
> Thoughts?

Maybe?  I generally like punting these sorts of things to userspace, but as
evidenced by this patch, all of these mitigation "features" are such a goda=
wful
mess that I don't have a problem with KVM doing the heavy lifting.

E.g. I suspect that having KVM enumerate both vendor's bits makes it much e=
asier
for QEMU to support pre-defined uarch models while still retaining sanity c=
hecks
that the features being enumerated to the guest are indeed supported by the=
 host.

