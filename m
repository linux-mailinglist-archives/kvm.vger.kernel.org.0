Return-Path: <kvm+bounces-21516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE48192FD25
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:06:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D24EE1C231C7
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 15:06:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6465A172BDE;
	Fri, 12 Jul 2024 15:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q8oTn/vo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E06171E74
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 15:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720796806; cv=none; b=O6+2UPsKR8KCMvbopYLsr2ZA/rrDwCjYmoM0BnzR46vJU8A3vddlgWMoqPwhlTbP46W1nGGcobM8uvaEz3hmTWYA1XEdWB7rUAtmvaeJ/iUb4YrwQfPsscMobVz7q1tuI9FW0FJfW9Lk/zc9zTfd9MxuaP0vDOar11M5y8ELAr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720796806; c=relaxed/simple;
	bh=IRMr7qGL1jXVji2zM5H94uxxDduKUZFIvjlx9E9l6rI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FqTrk2rjb5dX5mmPSANNwW+DaT2nKW06OW4nFwhNfS+BeY0HID90z5RpvQuli1pbPySNQTASa6XPVxmK6NelH644C1qq5NW9E4sT1DRRRAtU+jaWs+w2AMAsqtiYgEkGVpP64q7tU77/hWlpwa4Vp4mOw5V8E8U/Zjy6AVF4yBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q8oTn/vo; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fb0d545c60so17109795ad.2
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 08:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720796804; x=1721401604; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZWyWnNJQfLis8OltmFTp+D+i2eRVmZlaO2glliGRcpM=;
        b=Q8oTn/voHhU1nR6xhOLR9ObopibWX7Wp1OVlm+AaD1ehuzWBJEbCse0G8m6wPAWKIV
         5G6zTtXc04mR1PfAPfcV60J5+/1zpGER+zKT+VoYGrST4kYw9Pn1ZG2kHqbU8gpEGs6S
         93szTtxfQYYCDHPJTcfLKQ81BIixkSKn22w0L/LxPLsZbRFDl29CjwMx8BrOS4zFwcbD
         XjFP7T2OrGyLOpgP0oMWtmzU993VRnX8zmP5YM9en7aAtXkli9XkimUWLJ0Aw1VBYpFI
         Cf5xaoouSrw2Chg7lCCsrNbgS/JsDCItP7eq4VVc7gwn+/l0SbgxJS7GCdAXYUJGP4Le
         3p+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720796804; x=1721401604;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZWyWnNJQfLis8OltmFTp+D+i2eRVmZlaO2glliGRcpM=;
        b=C12zllJG5jeykciOqvR9VbtY4lcSCR/Ih5aVcBrhu8CACZe1MF7/aDpXM57NOIwmUi
         XHVc0u4kWhOQDjjeC6rC0b5RrDOHaymtSInSUaMrybBxN2SWe/cpN2IBo0fXfoot0q3K
         P0UsonsIHu/Y2FPz7TZMW0dHtjmEuDSF+7htPYOjtdzu7IUL6pcm++eHp1aaPSm0noet
         AduOGPzYH+nmKCMzchWfJsmNU8Am7eeYIe70AJxlpET0c83Aug4UizvfuYWo2yNfnZVB
         NFXYFgp7WNufFD/AoiSxpjmp1vbzWhDv6jdG79d7VuIQqTkx1hVv0mMnyY5htgflUpvQ
         TcRw==
X-Forwarded-Encrypted: i=1; AJvYcCXdBpXDm3xH36Ke0xaL4SikUjS7fdSXSvUS5dCFXdk+9bEKwIYiVj3fmkP3kgZNzaoYV+LDXxUV3VQFrvGNzgVG+Zl1
X-Gm-Message-State: AOJu0YxF2ry5IpPq7h0IMiJ7ydItR8SDOEW0D8WQq9ZUHVJs6og63u1j
	MZTqHGL+NKB4/LthOYzaR54ylWJ+jRnsTWOUCR/+bjpqXDXdiUnEmfBcRLO5WFbRlCqajbeGgAd
	f+g==
X-Google-Smtp-Source: AGHT+IGDfGxGyoOOVJXHRxv/7+Ukhncjw5VneesB3o9h2h6VbTln8g5EPSE4uE3ENM6QWIp1Ic1twbCkqos=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ec8b:b0:1fb:415d:81c5 with SMTP id
 d9443c01a7336-1fbb6eb7039mr251225ad.8.1720796804378; Fri, 12 Jul 2024
 08:06:44 -0700 (PDT)
Date: Fri, 12 Jul 2024 08:06:42 -0700
In-Reply-To: <CADrL8HW4PLTeC9Gq3Fd43-idjzOw8mXOzzG_RP1TYVoGp1_g+g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CADrL8HUW2q79F0FsEjhGW0ujij6+FfCqas5UpQp27Epfjc94Nw@mail.gmail.com>
 <ZmxsCwu4uP1lGsWz@google.com> <CADrL8HVDZ+m_-jUCaXf_DWJ92N30oqS=_9wNZwRvoSp5fo7asg@mail.gmail.com>
 <ZmzPoW7K5GIitQ8B@google.com> <CADrL8HW3rZ5xgbyGa+FXk50QQzF4B1=sYL8zhBepj6tg0EiHYA@mail.gmail.com>
 <ZnCCZ5gQnA3zMQtv@google.com> <CADrL8HW=kCLoWBwoiSOCd8WHFvBdWaguZ2ureo4eFy9D67+owg@mail.gmail.com>
 <CADrL8HUv6T4baOi=VTFV6ZA=Oyn3dEc6Hp9rXXH0imeYkwUhew@mail.gmail.com>
 <Zo137P7BFSxAutL2@google.com> <CADrL8HW4PLTeC9Gq3Fd43-idjzOw8mXOzzG_RP1TYVoGp1_g+g@mail.gmail.com>
Message-ID: <ZpFGYvCAQWhldWJZ@google.com>
Subject: Re: [PATCH v5 4/9] mm: Add test_clear_young_fast_only MMU notifier
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Yu Zhao <yuzhao@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 10, 2024, James Houghton wrote:
> On Tue, Jul 9, 2024 at 10:49=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Mon, Jul 08, 2024, James Houghton wrote:
> > > On Fri, Jun 28, 2024 at 7:38=E2=80=AFPM James Houghton <jthoughton@go=
ogle.com> wrote:
> > > >
> > > > On Mon, Jun 17, 2024 at 11:37=E2=80=AFAM Sean Christopherson <seanj=
c@google.com> wrote:
> > > I still don't think we should get rid of the WAS_FAST stuff.
> >
> > I do :-)
> >
> > > The assumption that the L1 VM will almost never share pages between L=
2
> > > VMs is questionable. The real question becomes: do we care to have
> > > accurate age information for this case? I think so.
> >
> > I think you're conflating two different things.  WAS_FAST isn't about a=
ccuracy,
> > it's about supporting lookaround in conditionally fast secondary MMUs.
> >
> > Accuracy only comes into play when we're talking about the last-minute =
check,
> > which, IIUC, has nothing to do with WAS_FAST because any potential look=
around has
> > already been performed.
>=20
> Sorry, I thought you meant: have the MMU notifier only ever be
> lockless (when tdp_mmu_enabled), and just return a potentially wrong
> result in the unlikely case that L1 is sharing pages between L2s.
>=20
> I think it's totally fine to just drop WAS_FAST. So then we can either
> do look-around (1) always, or (2) only when there is a secondary MMU
> with has_fast_aging. (2) is pretty simple, I'll just do that.
>=20
> We can add some shadow MMU lockless support later to make the
> look-around not as useless for the nested TDP case.

...

> > Adding the locking isn't actually all that difficult, with the *huge* c=
aveat that
> > the below patch is compile-tested only.  The vast majority of the churn=
 is to make
> > it so existing code ignores the new KVM_RMAP_LOCKED bit.
>=20
> This is very interesting, thanks for laying out how this could be
> done. I don't want to hold this series up on getting the details of
> the shadow MMU lockless walk exactly right. :)

...

> 1. Drop the WAS_FAST complexity.
> 2. Add a function like mm_has_fast_aging_notifiers(), use that to
> determine if we should be doing look-around.

I would prefer a flag over a function.  Long-term, if my pseudo-lockless rm=
ap
idea pans out, KVM can set the flag during VM creation.  Until then, KVM ca=
n set
the flag during creation and then toggle it in (un)account_shadowed().  Rac=
es
will be possible, but they should be extremely rare and quite benign, all t=
hings
considered.

