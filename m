Return-Path: <kvm+bounces-19486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D4E29059D0
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 19:24:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8DC5AB24954
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 17:24:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61740183062;
	Wed, 12 Jun 2024 17:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ED6QTUpf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1831822D9
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 17:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718213023; cv=none; b=raRoPPjuVROPUs/wq36S7IQOZ72M6M2IKdBohiXUM/+IuLjvv9vVH9O32YKK3Tl/xAvoiGY8PC3f/Pokioh4mrJ3SkiTorNdXK/4YngrKD5yTkEmfgDELkHUjOSsMxCtmksT8iQhbHaKM55VACdsjTPHVA7BITsyVwgQiccSdbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718213023; c=relaxed/simple;
	bh=qvzOGVZF1aFjcNNXoWdAyWZv4lQeSovWWQTrEs6pNdw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z8sz0X2WLLDv8aORh9x0UDqc2jZ2HVuLfAePR9PjjtOm4OenNlE+6u9wZbS9dzDp7vSKosateft6Z6hvG+pr50wYwl/b31LlBfyNUTr5/4uj/v4r1sAgneZVSkTDPrYmaQTn4R5pDxQ8iza4BpodFWaW8WfERtHWTEL8bD6XKHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ED6QTUpf; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dfb0e59ac7cso181587276.0
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 10:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718213020; x=1718817820; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v0uZvClGSP7b0LMzzAPVM0AhM29ZDe2y2D54OZuyJ4o=;
        b=ED6QTUpflG01XxDwADpCTuUCb3My1wmNO1KRIabL/mB6J08kl5ENGX51vmpVHsg6xR
         jFv33Xhk3VXxWTVvpGKAaIotK7Zksj8HAw0XHs6pGvPnVz+1x1dCCWPEFUm/SJy06FLi
         BpuEPZLYakQWef9qNxKBc3A3XsNZbfd6mt7/jBNk0WSx8e0xYM5diG+B74Wd60h/dixp
         Ae7x+VxLhJaqlumRqtc3pPayDW5jcNJHxwn3EmaYD3cAVYZ7BtagZ8ZPWqNrRQf8GGOR
         qUscLQNTNlkm6MS3vd2OpolLDv7GKWif+u6p98TUEVHK9IwK5SEi6mXOlkhAKEmwzS4n
         qyAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718213020; x=1718817820;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=v0uZvClGSP7b0LMzzAPVM0AhM29ZDe2y2D54OZuyJ4o=;
        b=eyZjcKwQzzeJ5KQmq0Kw9tcIZ35fh93IyaRB1C0XOXT+8G7i9Qf4EwhIKXZ6eU+17H
         uXcN3enWTGNqbBt1R/60oGDXetjpE+yKC9KqegvrxSlne/uMfKe4Jktq1U9WIAVLQpoF
         g/mSvw4r+/wjK+axx7JVeZKXeJ9nX+YzLzF8CtJWwHytotKzDm9PICJv+YpmmFD7dXPI
         DQh5J4Ogi83hwM4MuOBn6pG89AjCY/0hZR9SNp3MsG9DGXVhO7gKsMEFszBo0tSu858r
         44bYIYREW4JeHNixNKLRrxTLmfsdxAxoKm8YjROhGFsQZTgkB2IXZhRAfg47bPGq50dn
         5F/g==
X-Forwarded-Encrypted: i=1; AJvYcCXIrwbEaWStwV29lnEEaSpZz2kfgaDOiVcg58Nu9alkviegeWHwJ3gv04EAOsM1jjRjsQImHxvChnBUa6t4nXUzvNCm
X-Gm-Message-State: AOJu0YzsxgMVrRDWvOhb9tmYKNXbK0WOLkv68prwnmsHyln9TSQZE91X
	sXLQiJEcH8YzVSSLmPxkVMWxGCvIfhUKjsIyHKx4i/fAokWR6ulndUQPCAmwYQgrgsD4s7E9Uem
	bHg==
X-Google-Smtp-Source: AGHT+IHsuziTjwu8H3LsGOZG3nq2ECdUkM7fJ/s+9lw1k304/SuAsQ64WUp2lf97WzRuhz9PeWwlSE0Bo58=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:729:b0:dfb:b4e:407a with SMTP id
 3f1490d57ef6-dfe68035fbemr647880276.9.1718213020117; Wed, 12 Jun 2024
 10:23:40 -0700 (PDT)
Date: Wed, 12 Jun 2024 10:23:38 -0700
In-Reply-To: <CAOUHufYCmYNngmS=rOSAQRB0N9ai+mA0aDrB9RopBvPHEK42Ng@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240611002145.2078921-1-jthoughton@google.com>
 <20240611002145.2078921-9-jthoughton@google.com> <ZmnGlpBR91TyI3Lt@google.com>
 <CAOUHufYCmYNngmS=rOSAQRB0N9ai+mA0aDrB9RopBvPHEK42Ng@mail.gmail.com>
Message-ID: <ZmnZmj8iVmcLf8fo@google.com>
Subject: Re: [PATCH v5 8/9] mm: multi-gen LRU: Have secondary MMUs participate
 in aging
From: Sean Christopherson <seanjc@google.com>
To: Yu Zhao <yuzhao@google.com>
Cc: James Houghton <jthoughton@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
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

On Wed, Jun 12, 2024, Yu Zhao wrote:
> On Wed, Jun 12, 2024 at 10:02=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > On Tue, Jun 11, 2024, James Houghton wrote:
> > > diff --git a/mm/rmap.c b/mm/rmap.c
> > > index e8fc5ecb59b2..24a3ff639919 100644
> > > --- a/mm/rmap.c
> > > +++ b/mm/rmap.c
> > > @@ -870,13 +870,10 @@ static bool folio_referenced_one(struct folio *=
folio,
> > >                       continue;
> > >               }
> > >
> > > -             if (pvmw.pte) {
> > > -                     if (lru_gen_enabled() &&
> > > -                         pte_young(ptep_get(pvmw.pte))) {
> > > -                             lru_gen_look_around(&pvmw);
> > > +             if (lru_gen_enabled() && pvmw.pte) {
> > > +                     if (lru_gen_look_around(&pvmw))
> > >                               referenced++;
> > > -                     }
> > > -
> > > +             } else if (pvmw.pte) {
> > >                       if (ptep_clear_flush_young_notify(vma, address,
> > >                                               pvmw.pte))
> > >                               referenced++;
> >
> > Random question not really related to KVM/secondary MMU participation. =
 AFAICT,
> > the MGLRU approach doesn't flush TLBs after aging pages.  How does MGLR=
U mitigate
> > false negatives on pxx_young() due to the CPU not setting Accessed bits=
 because
> > of stale TLB entries?
>=20
> I do think there can be false negatives but we have not been able to
> measure their practical impacts since we disabled the flush on some
> host MMUs long ago (NOT by MGLRU), e.g., on x86 and ppc,
> ptep_clear_flush_young() is just ptep_test_andclear_young().

Aha!  That's what I was missing, I somehow didn't see x86's ptep_clear_flus=
h_young().

That begs the question, why does KVM flush TLBs on architectures that don't=
 need
to?  And since kvm_mmu_notifier_clear_young() explicitly doesn't flush, are=
 there
even any KVM-supported architectures for which the flush is mandatory?

Skipping the flush on KVM x86 seems like a complete no-brainer.

Will, Marc and/or Oliver, what are arm64's requirements in this area?  E.g.=
 I see
that arm64's version of __ptep_clear_flush_young() does TLBI but not DSB.  =
Should
KVM be doing something similar?  Can KVM safely skip even the TBLI?

> theoretical basis is that, given the TLB coverage trend (Figure 1 in
> [1]), when a system is running out of memory, it's unlikely to have
> many long-lived entries in its TLB. IOW, if that system had a stable
> working set (hot memory) that can fit into its TLB, it wouldn't hit
> page reclaim. Again, this is based on the theory (proposition) that
> for most systems, their TLB coverages are much smaller than their
> memory sizes.
>=20
> If/when the above proposition doesn't hold, the next step in the page
> reclaim path, which is to unmap the PTE, will cause a page fault. The
> fault can be minor or major (requires IO), depending on the race
> between the reclaiming and accessing threads. In this case, the
> tradeoff, in a steady state, is between the PF cost of pages we
> shouldn't reclaim and the flush cost of pages we scan. The PF cost is
> higher than the flush cost per page. But we scan many pages and only
> reclaim a few of them; pages we shouldn't reclaim are a (small)
> portion of the latter.
>=20
> [1] https://www.usenix.org/legacy/events/osdi02/tech/full_papers/navarro/=
navarro.pdf

