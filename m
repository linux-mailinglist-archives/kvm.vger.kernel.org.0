Return-Path: <kvm+bounces-21139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3007792AC93
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 01:42:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5AA7C282AD8
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 23:42:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32E1A152DE3;
	Mon,  8 Jul 2024 23:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qLX822zE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CDF6F305
	for <kvm@vger.kernel.org>; Mon,  8 Jul 2024 23:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720482151; cv=none; b=Cg/H2jhfewYOtAUGd0wOqm1VJIUC1qDeisDhqKFoUfcmTrUF+xa6iVKS2UIEoe0DkXea6BBnNzvgOzqnFkj6vFeDbiBch56tByBZnrjraZICfcx+JtwgQTOaIxh3OelBa/CIfkcJf+luYKoJqTwOHIGz4+uSwPtKL0cGoYfL0+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720482151; c=relaxed/simple;
	bh=fXFkuGwJtPDomAOLHssxdyjY3IJRo5Ot7cYvZXhXmlo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JJla39kZoHEJpoEjc3ndDaHUhPfLeiL813Ynd/0/WufDw6HTEWshdcRAXiiW6cBJ/oZA+nvseVIDfRdHMoygl18zbhTmyvh1+jpSB0V5nV0f55f4jrlKPsbckX1V8nIkZcBiapJ51uq0EKp2EC33b0U5dqHK00E+xeeOPsqP68M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qLX822zE; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-447f8aa87bfso165731cf.0
        for <kvm@vger.kernel.org>; Mon, 08 Jul 2024 16:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720482148; x=1721086948; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nM7n3F0up3r61YyqcXWbM5R0i4/2z/TwS0sdB2eyKMU=;
        b=qLX822zEyhHMlRTalWzQlCqVc/P+rTL27UkR4/x9GMkJeZnvaDJSTrP+t4G7sZ5uuP
         679VaqaHaTBkI8oiALiAPts3eo8uGczvFC/+SJLM/fP3Zi1ntgyI/xHjgraeI+HMFuPL
         /cbs71caUk2FvmOychS5clNMw67aCHUpPVYNBTmOkvJL4kyQSlxaqviF4DGlqxBEmnqT
         SOXOL/5PLbAjeDSRddIjB/QzqV9Xpv75qCLaPJ4UhYGGh70y+o3twvtNTGcv/OUvexrL
         C46kFuyKXXxsIq01cvUHQrnj8esU27t63Av39hUqeQGUvlrRXB094DsqbUxdTPMz1r26
         1Qhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720482148; x=1721086948;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nM7n3F0up3r61YyqcXWbM5R0i4/2z/TwS0sdB2eyKMU=;
        b=q4yrZL4ZyCAJMVWg1QRV5feMCj+Smb1j6JZv+tmbBaqWQkRDKPzRul3N5CuDR2vmAT
         ZR2LvLwACxXV4rTb0UXlaHCFEo2LJVYYax7c8VDW4U/YMGZ5Y8bkbtR9wE0dqQq+ayQw
         18xC22WKazZhHNusyWvfIDPqv/kY0XMjATtpW6PzmvirjNtASk4m/Vr+pR071ezWB7D0
         DSacW6c6P7YGuNFzusnl85KEuePaE3qyieICcphwJQvhPtMrznaVAmyBOgtSU+Tgfi/S
         v6fkAnj5M/59WP/n9JLX0kpTtn40/RUk9pqk17+AREL+GMlmUI8bCpTXPL7uXHJ96K87
         A/pQ==
X-Forwarded-Encrypted: i=1; AJvYcCVuOYWvOb9/oK4OfjOlWll6h/zWOE2FWeCd8vFGMKuOqbUsUVyH/6hXnuV2FQ9rcLVPWQbSa8DR1bhGZO8A4OuA6Ko3
X-Gm-Message-State: AOJu0YxFgsYXUCS9IIK0XOh4GlCp+lv0tI4dJcLgQ7FoYXMQu4rU9Icj
	Nvscuj0Ss9UbPwKW7vy47ei5FI3VTYK5H8uR3FnvGO+EXnn8qxXiXgCLeNRsdaGXQaeKujPIFZl
	RBhBCaS2UR/iGrEXfGDB6AQU1aALAUAod5CoQ
X-Google-Smtp-Source: AGHT+IF5waWqD1+AOGNDtNFnA/E3lGLbDiFUJIIuSfBZaHyKwMMyMoyshkPlNYgy3P4wdxcBdGual2ZDEbwUTDImpqE=
X-Received: by 2002:ac8:6742:0:b0:447:e4cb:bf50 with SMTP id
 d75a77b69052e-447fb2f6c08mr1579121cf.8.1720482148269; Mon, 08 Jul 2024
 16:42:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240611002145.2078921-1-jthoughton@google.com>
 <20240611002145.2078921-9-jthoughton@google.com> <CAOUHufb2f_EwHY5LQ59k7Nh7aS1-ZbOKtkoysb8BtxRNRFMypQ@mail.gmail.com>
 <CADrL8HUJaG=O+jBVvXGVjJOriev9vxkZ6n27ekc5Pxv5D+fbcg@mail.gmail.com>
In-Reply-To: <CADrL8HUJaG=O+jBVvXGVjJOriev9vxkZ6n27ekc5Pxv5D+fbcg@mail.gmail.com>
From: Yu Zhao <yuzhao@google.com>
Date: Mon, 8 Jul 2024 17:41:49 -0600
Message-ID: <CAOUHufZ2Vd+Ea5vka20+SCVB446LZEA0mWy=RScN=7AChd869w@mail.gmail.com>
Subject: Re: [PATCH v5 8/9] mm: multi-gen LRU: Have secondary MMUs participate
 in aging
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Morse <james.morse@arm.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Sean Christopherson <seanjc@google.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 8, 2024 at 11:31=E2=80=AFAM James Houghton <jthoughton@google.c=
om> wrote:
>
> On Fri, Jul 5, 2024 at 11:36=E2=80=AFAM Yu Zhao <yuzhao@google.com> wrote=
:
> >
> > On Mon, Jun 10, 2024 at 6:22=E2=80=AFPM James Houghton <jthoughton@goog=
le.com> wrote:
> > >
> > > Secondary MMUs are currently consulted for access/age information at
> > > eviction time, but before then, we don't get accurate age information=
.
> > > That is, pages that are mostly accessed through a secondary MMU (like
> > > guest memory, used by KVM) will always just proceed down to the oldes=
t
> > > generation, and then at eviction time, if KVM reports the page to be
> > > young, the page will be activated/promoted back to the youngest
> > > generation.
> > >
> > > The added feature bit (0x8), if disabled, will make MGLRU behave as i=
f
> > > there are no secondary MMUs subscribed to MMU notifiers except at
> > > eviction time.
> > >
> > > Implement aging with the new mmu_notifier_test_clear_young_fast_only(=
)
> > > notifier. For architectures that do not support this notifier, this
> > > becomes a no-op. For architectures that do implement it, it should be
> > > fast enough to make aging worth it.
> > >
> > > Suggested-by: Yu Zhao <yuzhao@google.com>
> > > Signed-off-by: James Houghton <jthoughton@google.com>
> > > ---
> > >
> > > Notes:
> > >     should_look_around() can sometimes use two notifiers now instead =
of one.
> > >
> > >     This simply comes from restricting myself from not changing
> > >     mmu_notifier_clear_young() to return more than just "young or not=
".
> > >
> > >     I could change mmu_notifier_clear_young() (and
> > >     mmu_notifier_test_young()) to return if it was fast or not. At th=
at
> > >     point, I could just as well combine all the notifiers into one no=
tifier,
> > >     like what was in v2 and v3.
> > >
> > >  Documentation/admin-guide/mm/multigen_lru.rst |   6 +-
> > >  include/linux/mmzone.h                        |   6 +-
> > >  mm/rmap.c                                     |   9 +-
> > >  mm/vmscan.c                                   | 185 ++++++++++++++--=
--
> > >  4 files changed, 164 insertions(+), 42 deletions(-)
> >
> > ...
> >
> > >  static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned=
 long end,
> > >                            struct mm_walk *args)
> > >  {
> > > @@ -3357,8 +3416,9 @@ static bool walk_pte_range(pmd_t *pmd, unsigned=
 long start, unsigned long end,
> > >         struct pglist_data *pgdat =3D lruvec_pgdat(walk->lruvec);
> > >         DEFINE_MAX_SEQ(walk->lruvec);
> > >         int old_gen, new_gen =3D lru_gen_from_seq(max_seq);
> > > +       struct mm_struct *mm =3D args->mm;
> > >
> > > -       pte =3D pte_offset_map_nolock(args->mm, pmd, start & PMD_MASK=
, &ptl);
> > > +       pte =3D pte_offset_map_nolock(mm, pmd, start & PMD_MASK, &ptl=
);
> > >         if (!pte)
> > >                 return false;
> > >         if (!spin_trylock(ptl)) {
> > > @@ -3376,11 +3436,12 @@ static bool walk_pte_range(pmd_t *pmd, unsign=
ed long start, unsigned long end,
> > >                 total++;
> > >                 walk->mm_stats[MM_LEAF_TOTAL]++;
> > >
> > > -               pfn =3D get_pte_pfn(ptent, args->vma, addr);
> > > +               pfn =3D get_pte_pfn(ptent, args->vma, addr, pgdat);
> > >                 if (pfn =3D=3D -1)
> > >                         continue;
> > >
> > > -               if (!pte_young(ptent)) {
> > > +               if (!pte_young(ptent) &&
> > > +                   !lru_gen_notifier_test_young(mm, addr)) {
> > >                         walk->mm_stats[MM_LEAF_OLD]++;
> > >                         continue;
> > >                 }
> > > @@ -3389,8 +3450,9 @@ static bool walk_pte_range(pmd_t *pmd, unsigned=
 long start, unsigned long end,
> > >                 if (!folio)
> > >                         continue;
> > >
> > > -               if (!ptep_test_and_clear_young(args->vma, addr, pte +=
 i))
> > > -                       VM_WARN_ON_ONCE(true);
> > > +               lru_gen_notifier_clear_young(mm, addr, addr + PAGE_SI=
ZE);
> > > +               if (pte_young(ptent))
> > > +                       ptep_test_and_clear_young(args->vma, addr, pt=
e + i);
> > >
> > >                 young++;
> > >                 walk->mm_stats[MM_LEAF_YOUNG]++;
> >
> >
> > There are two ways to structure the test conditions in walk_pte_range()=
:
> > 1. a single pass into the MMU notifier (combine test/clear) which
> > causes a cache miss from get_pfn_page() if the page is NOT young.
> > 2. two passes into the MMU notifier (separate test/clear) if the page
> > is young, which does NOT cause a cache miss if the page is NOT young.
> >
> > v2 can batch up to 64 PTEs, i.e., it only goes into the MMU notifier
> > twice every 64 PTEs, and therefore the second option is a clear win.
> >
> > But you are doing twice per PTE. So what's the rationale behind going
> > with the second option? Was the first option considered?
>
> Hi Yu,
>
> I didn't consider changing this from your v2[1]. Thanks for bringing it u=
p.
>
> The only real change I have made is that I reordered the
> (!test_spte_young() && !pte_young()) to what it is now (!pte_young()
> && !lru_gen_notifier_test_young()) because pte_young() can be
> evaluated much faster.
>
> I am happy to change the initial test_young() notifier to a
> clear_young() (and drop the later clear_young(). In fact, I think I
> should. Making the condition (!pte_young() &&
> !lru_gen_notifier_clear_young()) makes sense to me. This returns the
> same result as if it were !lru_gen_notifier_test_young() instead,
> there is no need for a second clear_young(), and we don't call
> get_pfn_folio() on pages that are not young.

We don't want to do that because we would lose the A-bit for a folio
that's beyond the current reclaim scope, i.e., the cases where
get_pfn_folio() returns NULL (a folio from another memcg, e.g.).

> WDYT? Have I misunderstood your comment?

I hope this is clear enough:

@@ -3395,7 +3395,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned
long start, unsigned long end,
                if (pfn =3D=3D -1)
                        continue;

-               if (!pte_young(ptent)) {
+               if (!pte_young(ptent) && !mm_has_notifiers(args->mm)) {
                        walk->mm_stats[MM_LEAF_OLD]++;
                        continue;
                }
@@ -3404,8 +3404,8 @@ static bool walk_pte_range(pmd_t *pmd, unsigned
long start, unsigned long end,
                if (!folio)
                        continue;

-               if (!ptep_test_and_clear_young(args->vma, addr, pte + i))
-                       VM_WARN_ON_ONCE(true);
+               if (!ptep_clear_young_notify(args->vma, addr, pte + i))
+                       continue;

                young++;
                walk->mm_stats[MM_LEAF_YOUNG]++;

> Also, I take it your comment was not just about walk_pte_range() but
> about the similar bits in lru_gen_look_around() as well, so I'll make
> whatever changes we agree on there too (or maybe factor out the common
> bits).
>
> [1]: https://lore.kernel.org/kvmarm/20230526234435.662652-11-yuzhao@googl=
e.com/
>
> > In addition, what about the non-lockless cases? Would this change make
> > them worse by grabbing the MMU lock twice per PTE?
>
> That's a good point. Yes I think calling the notifier twice here would
> indeed exacerbate problems with a non-lockless notifier.

I think so too, but I haven't verified it. Please do?

