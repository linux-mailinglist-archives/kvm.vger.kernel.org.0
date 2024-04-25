Return-Path: <kvm+bounces-15995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D6B38B2D49
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 00:53:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 115041F21F10
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 22:53:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E5A2155A43;
	Thu, 25 Apr 2024 22:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PqsFt8yq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A9920315
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 22:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714085597; cv=none; b=T1pmDx/5dJLbsJDc1LJNGbSqcGvEy86l+P/le1rvS+gqBo9ukKddcggUrnOBaqMtByR1MoyLZHzNjNT28wY7Dz6k0rZQnCa9XJzmrdgULPrhqXr8lxXpqOOIj32euhHJD/RKd8QI5i6ymmkGIcY/zRNi8ad1wO1lbzY8afyjEF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714085597; c=relaxed/simple;
	bh=0qEnKzNWHJcEIaoKmJDY/qGRcRmSBpmNsHxGlNysR1E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bQP9rqg5Z73BtWgeeGrH78sB/4oT5mRDmuNuexIMtgETxHNKZKgqYpA/nifevc7yj3GyOB6qmUa/+8atLcUFExLmb6MiJoIBEwpNgVIWJAh4W385rAZMkR6augCbC+0MG1T4POpHe3G8lVapuJ6sCBQiMq4l/gVts4bJiIWBlX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PqsFt8yq; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-de45d0b7ffaso3130353276.2
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 15:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714085595; x=1714690395; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=00KgqiWT/087c0mlwmHa+NPrJGAP63yURtt2wxC0jsI=;
        b=PqsFt8yqi5dTOZVBRlfi2m1wjP35Bu50X67axys9UPLwe26aHIE81uBGyU6Reogd1w
         p/Q1D28t2D0+rKLciassHqwPE5aGguwLrFNTqyachCWfoJz9vHCR9MNjKRq1q2ou8Miu
         oLo0JweflDZ3GRwqygDFoA9Ye8SSzXQbOlL74d1N+qah4zHWJealpR+TJ1X0ylObqXS5
         DhTiIKPyp8A/dOCGMCSlniqbv/LfTlVjNctWGJvaamLwaDDqwEryCrZjdJ1GFfCJOQWV
         vWN3W5J30FxBMdpxN2bQMUSm/xbEo2gZ5tKbM22gafCKfVaNPBD3Y7wJW4yYik+ffMd1
         V8AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714085595; x=1714690395;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=00KgqiWT/087c0mlwmHa+NPrJGAP63yURtt2wxC0jsI=;
        b=pS9M9Z01IvwamFKdwqLlq+mTYtqwx76/M2SgaA3E/Y57cHtc6V6Yz5uXnOXPBXsdOa
         2VUNNxsVDfhsMd8+ux3OLKDQOej0e7JYaQ35+IhUoNUsbW+tYsPzLezS0mOAUqLv11Z4
         fT9qjKiB4BFPwo+D/AHvS5hyi2T6hfOhwNZ/hUaaxVBWy2HqTJM8UOrvCdsKAjEdOkRJ
         2TIhgjBQR3Z3xKHrBH2LIzmi31VbpA0kPLbCSQSwF9ryrBeLqPRsI9DhCMrHBgcFuPsC
         HyrDrU2ORcQ4U/rgGgNCi4wNORTp3rxlfNFY7clRS/FuTAfcczDntYyHYWOl/V68OttL
         TTWg==
X-Forwarded-Encrypted: i=1; AJvYcCUrNT0iFzgHqgWfJrhaZg8No0TZDlB77ySiY6Adc47tlW3UA1XMa1RrZ2Jb47lykDD7fbcjQxkBQBoE12zBi/naXQVH
X-Gm-Message-State: AOJu0YwC5jWU14Go3CzdPZ8Np7H93OIlF1TQkF0KziF6rIvMZHCDtKK4
	2WTnlTM3yKPkS7eI07lHyuBg8PJGfkzUADUy0VNjTAGPD/KvKd8BZpqjGa2tfga4AdhMip9cHtd
	k+g==
X-Google-Smtp-Source: AGHT+IGOMiS1k5HK+cV9oyeTNccaLQ+DagjPu7jILD1bHLJwTZUihKZ1APqEkaP38iQ7pz1cJZfqn+zDjHc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:154b:b0:de4:7a4b:903 with SMTP id
 r11-20020a056902154b00b00de47a4b0903mr125184ybu.3.1714085595137; Thu, 25 Apr
 2024 15:53:15 -0700 (PDT)
Date: Thu, 25 Apr 2024 15:53:13 -0700
In-Reply-To: <5bde4c96c26c6af1699f1922ea176daac61ab279.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <f9f1da5dc94ad6b776490008dceee5963b451cda.camel@intel.com>
 <baec691c-cb3f-4b0b-96d2-cbbe82276ccb@intel.com> <bd6a294eaa0e39c2c5749657e0d98f07320b9159.camel@intel.com>
 <ZiqL4G-d8fk0Rb-c@google.com> <7856925dde37b841568619e41070ea6fd2ff1bbb.camel@intel.com>
 <ZirNfel6-9RcusQC@google.com> <5bde4c96c26c6af1699f1922ea176daac61ab279.camel@intel.com>
Message-ID: <Zire2UuF9lR2cmnQ@google.com>
Subject: Re: [RFC] TDX module configurability of 0x80000008
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 25, 2024, Rick P Edgecombe wrote:
> On Thu, 2024-04-25 at 14:39 -0700, Sean Christopherson wrote:
> > On Thu, Apr 25, 2024, Rick P Edgecombe wrote:
> > > On Thu, 2024-04-25 at 09:59 -0700, Sean Christopherson wrote:
> > > > > accessing a GPA beyond [23:16] is similar to accessing a GPA with=
 no
> > > > > memslot.
> > > >=20
> > > > No, it's not.=C2=A0 A GPA without a memslot has *very* well-defined
> > > > semantics in KVM, and KVM can provide those semantics for all
> > > > guest-legal GPAs regardless of hardware EPT/NPT support.
> > >=20
> > > Sorry, not following. Are we expecting there to be memslots above the=
 guest
> > > maxpa 23:16? If there are no memslots in that region, it seems exactl=
y like
> > > accessing a GPA with no memslots. What is the difference between befo=
re and
> > > after the introduction of guest MAXPA? (there will be normal VMs and =
TDX
> > > differences of course).
> >=20
> > If there are no memslots, nothing from a functional perspectives, just =
a
> > very slight increase in latency.=C2=A0 Pre-TDX, KVM can always emulate =
in
> > reponse to an EPT violation on an unmappable GPA.=C2=A0 I.e. as long as=
 there is
> > no memslot, KVM doesn't *need* to create SPTEs, and so whether or not a=
 GPA
> > is mappable is completely irrelevant.
>=20
> Right, although there are gaps in emulation that could fail. If the emula=
tion
> succeeds and there is an MMIO exit targeting a totally unknown GPA, then =
I guess
> it's up to userspace to decide what to do.
>=20
> KVM's done its job.

Yep.

> But userspace still has to handle it. It can, but I was under the impress=
ion
> it didn't (maybe bad assumption).

I'm pretty sure QEMU handles accesses to non-existent MMIO with PCI abort s=
emantics,
i.e. ignores writes and returns all FFs for reads.

> > > Also, it adds complexity for cases where KVM maps GPAs above guest ma=
xpa
> > > anyway.
> >=20
> > That should be disallowed.=C2=A0 If KVM tries to map an address that it=
 told the
> > guest was impossible to map, then the TDX module should throw an error.
>=20
> Hmm. I'll mention this, but I don't see why KVM needs the TDX module to f=
ilter
> it. It seems in the range of userspace being allowed to create nonsense
> configurations that only hurt its own guest.

Because the whole point of TDX is to protect the guest from the bad, naught=
y host?

> If we think the TDX module should do it, then maybe we should have KVM sa=
nity
> filter these out today in preparation.

Nope.  KVM isn't in the guest's TCB, TDX is.  KVM's stance is that userspac=
e is
responsible for providing a sane vCPU model, because defining what is "sane=
" is
extremely difficult unless the definition is super prescriptive, a la TDX.=
=20

E.g. letting the host map something that TDX's spec says will cause #VE wou=
ld
create a novel attack surface.

