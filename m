Return-Path: <kvm+bounces-22205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A3B193B91A
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 00:22:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4476B281F65
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 22:22:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64DD913C9B8;
	Wed, 24 Jul 2024 22:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x/hxo5Y9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C3A13A412
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 22:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721859728; cv=none; b=juS0U1eYW1u5V1JLnbS8xD2h8bjLTJuz8ZTH7M0uwMZnzb/fqG1t3nUEsThhzfRaBYEyGxwMBzARazKWOIU/BI6zgVId2OBoitpCFI0PVaae2hEJGCLthbWEiXjC/8YGtLtyZMGcOqaXtWHUYokup3CAxG6YohfwdzLuPk8A6eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721859728; c=relaxed/simple;
	bh=HO70v1wVuk9cV8UBu2qM9/e2WQcXL4uaOw5r3/JI/yo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N35ttAGpXCEKUDIYQJaVGvl3nzHOlsPTrjsJKJO4XIneGl9VcgvjLWJQJRiP4LTNPV5MdOsG2U5/l9EwffVQZaqoQAo5G1542nDqs0OALsEB7vY/v3xwspNkOLPAQrp7TjCCK+JJKFhGbiytHWJas7yxnDncsr55gjTqx50G1CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x/hxo5Y9; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70d3420a5deso330735b3a.0
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 15:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721859726; x=1722464526; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BSXodmqyj7dN5XSDdHGVyrjY78PJw8o/FgiOhCgOSi4=;
        b=x/hxo5Y9e63HTnESDd5omqi3+B9rjwYyZDFp7cL7Dt2OmjspsHL0tLZuq0HYpcS7zT
         JN1Wjh1L8YQ/FXJkY3jkYD4s6LhJivlEv6NyeZ8cH2KjVPYMc78H4sqyVI/vEYhhEp84
         4tGDAF2hzWT7FfNutQVSc9ARyU41wkLXRsl+reL2U9Juct0r6q5QJ0xvs3DRFsE3zJz5
         TP/EQCJRyIcvFI32+KBV9Y1GCZ+zeZxw/SHJyjR5T7VvNNuZ06i4xou0Y6Fbq8Q1Md0n
         JiPOU7jfsZUH3DBylJdadgi+wrWXNez0cXn4rhTTe4NDmF36D9oFtxsvQy7L8G7AhrKq
         VpJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721859726; x=1722464526;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BSXodmqyj7dN5XSDdHGVyrjY78PJw8o/FgiOhCgOSi4=;
        b=FJRDg4dlCEa5+GpqgWTihheI2SCo3S93pC+2+vH5flSuKlTvxb8OGK6vuYc0wP/QFx
         f1uzRJZlM2ET/OIwYLXyw4szFEQlFVT9LyQnaH5XzMSkG1GqFyXoLq3GY0OTrXb8n+RD
         jtixLueB1ESYhKMZsI03VfeOcXILqaRDkmcjx1AqGWM5f1ErXg4ZugmHWRLxRqMuxOh2
         eW9yrSxml5Ggya4LjXgu5WPsa2mmH1O1f0mwyNLzHEOATnF9tJlF0qrfZdf4MuLvwV58
         XbbjAGRgjYZ9yOe59yt3+yZYovJqpBvD90Wus/XOEs1+4Ao+L5jMQzYXnmDtPcUkV1sW
         Gh5A==
X-Forwarded-Encrypted: i=1; AJvYcCWMou1uTV4ONmVIZe518BsPBNOYdygZEKKC1N3fB4tn9kXBH5+yN/8NNWbQMJyCyqawra5m74ua7x4I9nbNLfDxHcFM
X-Gm-Message-State: AOJu0Yx4nClf3OR5n/uTDFhON37K3xv62d5QYbe7N53vNS5VRVQ+bvsJ
	P/8zIMGsz8E2Qo1xi7+YMDg9vpb2JrGFfyEZstIGRW8VXLcoISvXPPTfEG5jM6xpV8poNAIMI4b
	iuw==
X-Google-Smtp-Source: AGHT+IFx8NDS8rneFygVIvUCKfuvpKeVACKRAZBW8jsZyC6tI5K3N4xJ+ztSNrNFbJRaBlt9/8Uyiim5YtY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:8594:b0:70d:fba:c51c with SMTP id
 d2e1a72fcca58-70eaa9311ecmr31575b3a.3.1721859726144; Wed, 24 Jul 2024
 15:22:06 -0700 (PDT)
Date: Wed, 24 Jul 2024 15:22:04 -0700
In-Reply-To: <CALMp9eQspMVnkuhkVCjsGoY7C-9W2--MPYN5LZWM1Zfv7QMrpQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240625235554.2576349-1-jmattson@google.com> <CALMp9eSTsGaAcEKkJ+=vWD4aHC3e_iOA8nnwWhGQdfBj_nj3-A@mail.gmail.com>
 <323bf4cc39f3e4dd3b95e0e25de35a7c0c2e9d2d.camel@redhat.com>
 <CALMp9eRmL_7xdK11dsC-yapd29d+6121tWu7sdLnTmHiEEBsdA@mail.gmail.com>
 <ZqFYIPw5XSmsdF_K@google.com> <CALMp9eQspMVnkuhkVCjsGoY7C-9W2--MPYN5LZWM1Zfv7QMrpQ@mail.gmail.com>
Message-ID: <ZqF-jCMDOfaGUz1Y@google.com>
Subject: Re: [PATCH v2] KVM: x86: Complain about an attempt to change the APIC
 base address
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 24, 2024, Jim Mattson wrote:
> On Wed, Jul 24, 2024 at 12:38=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > On Wed, Jul 24, 2024, Jim Mattson wrote:
> > > On Wed, Jul 24, 2024 at 11:13=E2=80=AFAM Maxim Levitsky <mlevitsk@red=
hat.com> wrote:
> > > > What if we introduce a new KVM capability, say CAP_DISABLE_UNSUPPOR=
TED_FEATURES,
> > > > and when enabled, outright crash the guest when it attempts things =
like
> > > > changing APIC base, APIC IDs, and other unsupported things like tha=
t?
> > > >
> > > > Then we can make qemu set it by default, and if users have to use a=
n
> > > > unsupported feature, they could always add a qemu flag that will di=
sable
> > > > this capability.
> > >
> > > Alternatively, why not devise a way to inform userspace that the gues=
t
> > > has exercised an unsupported feature? Unless you're a hobbyist workin=
g on
> > > your desktop, kernel messages are a *terrible* mechanism for communic=
ating
> > > with the end user.
> >
> > A per-vCPU/VM stat would suffice in most cases, e.g. similar to the pro=
posed
> > auto-EOI stat[*].  But I honestly don't see the point for APIC base rel=
ocation
> > and changing x2APIC IDs.  We _know_ these things don't work.  Having a =
flag might
> > save a bit of triage when debugging a guest issue, but I fail to see wh=
at userspace
> > would do with the information outside of a debug scenario.
>=20
> I would argue that insider knowledge about what does and doesn't work
> isn't particularly helpful to the end user.
>=20
> A non-standard flag isn't particularly helpful either. Nor is a kernel
> log message. Perhaps these solutions are fine for hobbyists, but they
> are not useful in an enterprise environment

I don't disagree, but at the same time, I don't think it's unreasonable to =
expect
an enterprise environment to be aware of KVM's _documented_ errata (see bel=
ow).
Of course, this one ain't documented...

> If a guest OS tries to change the APIC base address, and KVM silently
> ignores it, the guest is unlikely to get very far. Imagine what would
> happen if the guest tried to change GS_BASE, and KVM silently ignored
> it.
>=20
> Maybe KVM should return KVM_INTERNAL_ERROR_EMULATION if the guest
> attempts to relocate the APIC base--even without a new "pedantic"
> flag. What is the point in trying to continue without relocation?

I'm definitely not opposed to this, though there's a non-zero risk would be=
 killing
a weird-but-functional guest, e.g. if it "relocates" the APIC base on its w=
ay to
enabling x2APIC.   Maybe a quirk is warranted for this one in particular?  =
(where
disabling the quirk triggers KVM_INTERNAL_ERROR_EMULATION).

> > And for APIC base relocation, userspace already has the ability to dete=
ct this
> > unuspported behavior.  Trap writes to MSR_IA32_APICBASE via MSR filteri=
ng, then
> > reflect the value back into KVM.  Performance would suck, but writes to
> > MSR_IA32_APICBASE should be very rare, especially if the host forces x2=
APIC via
> > guest firmware.
>=20
> This "unsupported behavior" should at least be documented somewhere.

Ya, Documentation/virt/kvm/x86/errata.rst has a few things, but we need to =
keep
building it out.

