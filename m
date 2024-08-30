Return-Path: <kvm+bounces-25435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E16EB9655DF
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 05:48:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6CC571F24638
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 03:48:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C81D513BAF1;
	Fri, 30 Aug 2024 03:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="36NA014R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB761474C3
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 03:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724989683; cv=none; b=DrRmJtRksakYyAovyfv9RmCPBUTA9WalaS7SeBH8PhTLsU58FIYl7N0cPiaQz6emIkzxhfErPbssaeHGapOSlVGGhO0hfZxZ1Hk35DEcQN4CtQXrgadtcKykP9T2CaJ7AelunTNXTEHGQUc1FSxEsLv3xxHflDuTuBJVoxwg5LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724989683; c=relaxed/simple;
	bh=8X4cJIJqX+703YojJTQK5ekGonK/y/arTKL/aqKkyEI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lzvuCYoyxicNrKJNKIiHOitBuR/e+mVyXGXvuVM1GTjyJNVCpzVYVLlq279eu4wdjgE2j1TKKlSdzfTSZzSaiyfj5Xc8J/EOxAhPVMt1ZM7QzrxHSG+OEBghvd2zTplrDqPG8vDs5LNW1ctxNtsgakMBaRiajMx5wxv83gtVj8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=36NA014R; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-201f464e3e8so14664055ad.3
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 20:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724989681; x=1725594481; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7oDkTMtkbW8nQHJkC6FNRU/4bZFr8mldBmCcZx8NdnI=;
        b=36NA014R6nPw0VhVy0a82O/PyRygQjCh/NhLfcMYJTf/P8ib5WDcjIH5W64o/L8PNu
         Jn6SUytoX3gR8d9NfYUfub1Jb2mfTYOXGxo6fE2m5IUBAUz7GoaGs1HzhDOlfVzCvAsc
         xn0oHjGpS6poitMkD/YoZtrPSi84jkHGn/qv0tV3FA4EUihYV3A2TV4URBL+AMllBK2j
         N0vyfxRFGBK+yoW4+xczayJ553eLODwPiqJPyQPrmGCcSsBhcwZHfpE8Vvj54uggHscJ
         tZKVRXoAVbGpxcCQdv4weBrux8iLnOZikG2eRTIKkl5+2IX92/5L6EekZmwZWpl1StNa
         mVKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724989681; x=1725594481;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7oDkTMtkbW8nQHJkC6FNRU/4bZFr8mldBmCcZx8NdnI=;
        b=Q9FYAiRVa7w6v2z4sL5NDKlbp2Zvc4ND9oBXkLUEkDa1RieCBKDvZ1rTBzYI9bdn5x
         eTQ9ECT+87V1WMXJLudopxwAhArSdSGknppiD9oQwZYEvmc2W59dfT9SFFqBgI9MrNDF
         QvRZeUtSdjOk3BcQsXh5ga9FowK5bCJxfxqC5sywehaFEQ+2yxUqALWI0wBxXIsKYQDH
         yOssV6RqTIWvxkPU+RcQowPYwjzlW4QmtHvClTsJmVtvQ1Xmspgs2xbA3uVEnG1IeoEX
         PFbbkF+i+UU7THBO49WpVS8pfpnXK0xIU1z7zuvfPGaO655YUuIwtsEkuDj3bZHJsFtG
         H8gQ==
X-Forwarded-Encrypted: i=1; AJvYcCWp6dTeeNGUWkyFZ7w2fdw8TtHqRVY4xx7VbmaZ5wcsZS0fAU+PCGgln3KCx4z99bmWBoo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMqij26E0JHdbYv+Yjo29DWoa7nd+RjSdO6ZbvJZGvMueoG8C/
	h0KSaPUvTWNGfgnzhwULG47kUStVOP9kJ08AXEpCSEuicTSysr5QKRKuwYsFUZXV2LM/P4+Fw0l
	tZQ==
X-Google-Smtp-Source: AGHT+IFuJaHoFSCV5+8BWRf+q8zKeUDxkgIb0cxDbWq2MCPl2PJvwzOB/7AGr0dtEc/kwU7osl3dzfbQCdc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f54c:b0:1ff:4618:36dd with SMTP id
 d9443c01a7336-20527612dc9mr665745ad.1.1724989680602; Thu, 29 Aug 2024
 20:48:00 -0700 (PDT)
Date: Thu, 29 Aug 2024 20:47:59 -0700
In-Reply-To: <CADrL8HWQqVm5VbNnR6iMEZF17+nuO_Y25m6uuScCBVSE_YCTdg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-3-jthoughton@google.com> <Zr_3Vohvzt0KmFiN@google.com>
 <CADrL8HWQqVm5VbNnR6iMEZF17+nuO_Y25m6uuScCBVSE_YCTdg@mail.gmail.com>
Message-ID: <ZtFA79zreVt4GBri@google.com>
Subject: Re: [PATCH v6 02/11] KVM: x86: Relax locking for kvm_test_age_gfn and kvm_age_gfn
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Morse <james.morse@arm.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>, 
	Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 29, 2024, James Houghton wrote:
> On Fri, Aug 16, 2024 at 6:05=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > > +static __always_inline bool kvm_tdp_mmu_handle_gfn_lockless(
> > > +             struct kvm *kvm,
> > > +             struct kvm_gfn_range *range,
> > > +             tdp_handler_t handler)
> >
> > Please burn all the Google3 from your brain, and code ;-)
>=20
> I indented this way to avoid going past the 80 character limit. I've
> adjusted it to be more like the other functions in this file.
>=20
> Perhaps I should put `static __always_inline bool` on its own line?

Noooo. Do not wrap before the function name.  Linus has a nice explanation/=
rant
on this[1].

In this case, I'm pretty sure you can avoid the helper and simply handle al=
l aging
paths in a single API, e.g. similar to what I proposed for the shadow MMU[2=
].

[1] https://lore.kernel.org/all/CAHk-=3DwjoLAYG446ZNHfg=3DGhjSY6nFmuB_wA8fY=
d5iLBNXjo9Bw@mail.gmail.com
[2] https://lore.kernel.org/all/20240809194335.1726916-16-seanjc@google.com

> > >  /*
> > >   * Mark the SPTEs range of GFNs [start, end) unaccessed and return n=
on-zero
> > >   * if any of the GFNs in the range have been accessed.
> > > @@ -1237,28 +1272,30 @@ static bool age_gfn_range(struct kvm *kvm, st=
ruct tdp_iter *iter,
> > >  {
> > >       u64 new_spte;
> > >
> > > +retry:
> > >       /* If we have a non-accessed entry we don't need to change the =
pte. */
> > >       if (!is_accessed_spte(iter->old_spte))
> > >               return false;
> > >
> > >       if (spte_ad_enabled(iter->old_spte)) {
> > > -             iter->old_spte =3D tdp_mmu_clear_spte_bits(iter->sptep,
> > > -                                                      iter->old_spte=
,
> > > -                                                      shadow_accesse=
d_mask,
> > > -                                                      iter->level);
> > > +             iter->old_spte =3D tdp_mmu_clear_spte_bits_atomic(iter-=
>sptep,
> > > +                                             shadow_accessed_mask);
> > >               new_spte =3D iter->old_spte & ~shadow_accessed_mask;
> > >       } else {
> > > -             /*
> > > -              * Capture the dirty status of the page, so that it doe=
sn't get
> > > -              * lost when the SPTE is marked for access tracking.
> > > -              */
> > > +             new_spte =3D mark_spte_for_access_track(iter->old_spte)=
;
> > > +             if (__tdp_mmu_set_spte_atomic(iter, new_spte)) {
> > > +                     /*
> > > +                      * The cmpxchg failed. If the spte is still a
> > > +                      * last-level spte, we can safely retry.
> > > +                      */
> > > +                     if (is_shadow_present_pte(iter->old_spte) &&
> > > +                         is_last_spte(iter->old_spte, iter->level))
> > > +                             goto retry;
> >
> > Do we have a feel for how often conflicts actually happen?  I.e. is it =
worth
> > retrying and having to worry about infinite loops, however improbable t=
hey may
> > be?
>=20
> I'm not sure how common this is. I think it's probably better not to
> retry actually. If the cmpxchg fails, this spte is probably young
> anyway, so I can just `return true` instead of potentially retrying.
> This is all best-effort anyway.

+1

