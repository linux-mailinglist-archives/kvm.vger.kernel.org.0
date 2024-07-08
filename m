Return-Path: <kvm+bounces-21116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BD1092A834
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 19:31:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2613282813
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 17:31:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 029FA1487EB;
	Mon,  8 Jul 2024 17:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jBgdMop1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E58313E409
	for <kvm@vger.kernel.org>; Mon,  8 Jul 2024 17:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720459891; cv=none; b=nNRb1JtLc4izAI/xuhbsYQ87vqR3Rz5pIrd+uqvZjc32n3/aeZZUIdfX5cZL8AE9wIB3UTEnwGpX3D4b0ZqCbo/oSqhBc9C8W88D/138Llja1JX02DIbTcIykya6SejHGSVV14EK9YmF0UFpUi10+1s6fGerCfkffRdEyiXB0wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720459891; c=relaxed/simple;
	bh=k9PprvhII+V2/Bcah8BJRQ16KGDnAgfpyXIiDAbDvTw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L0wbrbRhsEn9SS8ZJUQJQr9Z5nuX3AT0CHm/H7/EmmkWQDpLI5F9LBqkatO3wxSW9EIdNgpCXEjaPO9vvGOw5ilr9aIP7WpAaxJd6i5i5OjA2j/IeMslpF+DE7NqWrELjz9KSXpaTRrON/y87VbzSfUFIcJ01eYfBZnffu+8JsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jBgdMop1; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-447dabd9562so25311cf.0
        for <kvm@vger.kernel.org>; Mon, 08 Jul 2024 10:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720459888; x=1721064688; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h5OvAknooFUouRttjkgdHPkXhVCuYFumFzAfg7hgFY0=;
        b=jBgdMop1DJNQhCLVO37WkE7ne/GMHNFKcr4WKshJxlKV0YGhHTKt6ylyDRKT9fn6pC
         w234/vaxpas21YBMkVY4mbo9IJiG8ef1sVVHZzR2qMs2ZpYdAdDOtz85zsDY0ttezhF7
         URF6Gbnaeu02iN5CB+ImdtYtAYr3s2suJNHahsC0CekOJ4hLhm4tUkLmlzZwnj1hBnG7
         U/jevXb41qwEld6ckOT1lQo/tSulIRzMpED6s74iGiyq+eHlJm1KmdboTxWZinxOYuUk
         nHHCGNNtsHmVaQf1JM/t5wweBbxGBZJAPgx0iyr0GPC5PlIE++qtbKeXhuau12xRczDA
         pFBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720459888; x=1721064688;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h5OvAknooFUouRttjkgdHPkXhVCuYFumFzAfg7hgFY0=;
        b=t39A+j6PNNNUy1LJgAk99oYSBLTUacwWbeUX8W8ZVG9yF1Kxn4jXeTdCwIvnf4qb9Q
         prYmBfL9hRxHjE9TU+L8Hpgrpt6o4Z5nFiH45DA4KgxzbDFtpmMiL2R58rs6mcKIxGSZ
         YzApkWXM0MGqTv6AuVoPTVMpuFYQCjo45uSHA6V7Lzf+AAHAOwmcyFJxnUN3FV7p/uKk
         kLVRksGnd4okUex3BMZU+XBMPcxdvuWAYgjc7VqRe8OlR8Dsx9T4J/cI5iYujAuH7Xvf
         1xSoD11XF7JBVyOJe0eyp8EAJXsZUYs4kJCMOD0rP9TlQsofYNa1Plb7gF+KYBt+9Ueq
         yYJQ==
X-Forwarded-Encrypted: i=1; AJvYcCWx1BUNo+KkM0db/Jml7RP3u9xKHrF9kma9jBitEm01GujrXeG1GwPcBIVAPnF97btjzSCqFXBsFH0c0NA9Mi6ZGd8T
X-Gm-Message-State: AOJu0YyNtYKeQnrkUvWRzT71fcyOyeQeXuELlJ4CegnXgJWYgxc2QgwA
	Tu5k/5YENm58cl/V8XTp8zD/CCIo6IeFnw44u0FWds+pWDh43gy5y4YgTImLY4sXagATfMzp8ID
	do/rL5mgfREOcrIGaGV+9GqYbPH1M2TQmwf+6
X-Google-Smtp-Source: AGHT+IH8n9BydNeekHTCqWhs8VlQPK1NNwxivhVTaYxOA+WSOHKqEde44rSbHv1zl8p/7A2Rz9umCfoVyqc4houcpcU=
X-Received: by 2002:ac8:554f:0:b0:447:f44d:d0ed with SMTP id
 d75a77b69052e-447fbc7904bmr5181cf.1.1720459888197; Mon, 08 Jul 2024 10:31:28
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240611002145.2078921-1-jthoughton@google.com>
 <20240611002145.2078921-9-jthoughton@google.com> <CAOUHufb2f_EwHY5LQ59k7Nh7aS1-ZbOKtkoysb8BtxRNRFMypQ@mail.gmail.com>
In-Reply-To: <CAOUHufb2f_EwHY5LQ59k7Nh7aS1-ZbOKtkoysb8BtxRNRFMypQ@mail.gmail.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 8 Jul 2024 10:30:51 -0700
Message-ID: <CADrL8HUJaG=O+jBVvXGVjJOriev9vxkZ6n27ekc5Pxv5D+fbcg@mail.gmail.com>
Subject: Re: [PATCH v5 8/9] mm: multi-gen LRU: Have secondary MMUs participate
 in aging
To: Yu Zhao <yuzhao@google.com>
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

On Fri, Jul 5, 2024 at 11:36=E2=80=AFAM Yu Zhao <yuzhao@google.com> wrote:
>
> On Mon, Jun 10, 2024 at 6:22=E2=80=AFPM James Houghton <jthoughton@google=
.com> wrote:
> >
> > Secondary MMUs are currently consulted for access/age information at
> > eviction time, but before then, we don't get accurate age information.
> > That is, pages that are mostly accessed through a secondary MMU (like
> > guest memory, used by KVM) will always just proceed down to the oldest
> > generation, and then at eviction time, if KVM reports the page to be
> > young, the page will be activated/promoted back to the youngest
> > generation.
> >
> > The added feature bit (0x8), if disabled, will make MGLRU behave as if
> > there are no secondary MMUs subscribed to MMU notifiers except at
> > eviction time.
> >
> > Implement aging with the new mmu_notifier_test_clear_young_fast_only()
> > notifier. For architectures that do not support this notifier, this
> > becomes a no-op. For architectures that do implement it, it should be
> > fast enough to make aging worth it.
> >
> > Suggested-by: Yu Zhao <yuzhao@google.com>
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
> >
> > Notes:
> >     should_look_around() can sometimes use two notifiers now instead of=
 one.
> >
> >     This simply comes from restricting myself from not changing
> >     mmu_notifier_clear_young() to return more than just "young or not".
> >
> >     I could change mmu_notifier_clear_young() (and
> >     mmu_notifier_test_young()) to return if it was fast or not. At that
> >     point, I could just as well combine all the notifiers into one noti=
fier,
> >     like what was in v2 and v3.
> >
> >  Documentation/admin-guide/mm/multigen_lru.rst |   6 +-
> >  include/linux/mmzone.h                        |   6 +-
> >  mm/rmap.c                                     |   9 +-
> >  mm/vmscan.c                                   | 185 ++++++++++++++----
> >  4 files changed, 164 insertions(+), 42 deletions(-)
>
> ...
>
> >  static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned l=
ong end,
> >                            struct mm_walk *args)
> >  {
> > @@ -3357,8 +3416,9 @@ static bool walk_pte_range(pmd_t *pmd, unsigned l=
ong start, unsigned long end,
> >         struct pglist_data *pgdat =3D lruvec_pgdat(walk->lruvec);
> >         DEFINE_MAX_SEQ(walk->lruvec);
> >         int old_gen, new_gen =3D lru_gen_from_seq(max_seq);
> > +       struct mm_struct *mm =3D args->mm;
> >
> > -       pte =3D pte_offset_map_nolock(args->mm, pmd, start & PMD_MASK, =
&ptl);
> > +       pte =3D pte_offset_map_nolock(mm, pmd, start & PMD_MASK, &ptl);
> >         if (!pte)
> >                 return false;
> >         if (!spin_trylock(ptl)) {
> > @@ -3376,11 +3436,12 @@ static bool walk_pte_range(pmd_t *pmd, unsigned=
 long start, unsigned long end,
> >                 total++;
> >                 walk->mm_stats[MM_LEAF_TOTAL]++;
> >
> > -               pfn =3D get_pte_pfn(ptent, args->vma, addr);
> > +               pfn =3D get_pte_pfn(ptent, args->vma, addr, pgdat);
> >                 if (pfn =3D=3D -1)
> >                         continue;
> >
> > -               if (!pte_young(ptent)) {
> > +               if (!pte_young(ptent) &&
> > +                   !lru_gen_notifier_test_young(mm, addr)) {
> >                         walk->mm_stats[MM_LEAF_OLD]++;
> >                         continue;
> >                 }
> > @@ -3389,8 +3450,9 @@ static bool walk_pte_range(pmd_t *pmd, unsigned l=
ong start, unsigned long end,
> >                 if (!folio)
> >                         continue;
> >
> > -               if (!ptep_test_and_clear_young(args->vma, addr, pte + i=
))
> > -                       VM_WARN_ON_ONCE(true);
> > +               lru_gen_notifier_clear_young(mm, addr, addr + PAGE_SIZE=
);
> > +               if (pte_young(ptent))
> > +                       ptep_test_and_clear_young(args->vma, addr, pte =
+ i);
> >
> >                 young++;
> >                 walk->mm_stats[MM_LEAF_YOUNG]++;
>
>
> There are two ways to structure the test conditions in walk_pte_range():
> 1. a single pass into the MMU notifier (combine test/clear) which
> causes a cache miss from get_pfn_page() if the page is NOT young.
> 2. two passes into the MMU notifier (separate test/clear) if the page
> is young, which does NOT cause a cache miss if the page is NOT young.
>
> v2 can batch up to 64 PTEs, i.e., it only goes into the MMU notifier
> twice every 64 PTEs, and therefore the second option is a clear win.
>
> But you are doing twice per PTE. So what's the rationale behind going
> with the second option? Was the first option considered?

Hi Yu,

I didn't consider changing this from your v2[1]. Thanks for bringing it up.

The only real change I have made is that I reordered the
(!test_spte_young() && !pte_young()) to what it is now (!pte_young()
&& !lru_gen_notifier_test_young()) because pte_young() can be
evaluated much faster.

I am happy to change the initial test_young() notifier to a
clear_young() (and drop the later clear_young(). In fact, I think I
should. Making the condition (!pte_young() &&
!lru_gen_notifier_clear_young()) makes sense to me. This returns the
same result as if it were !lru_gen_notifier_test_young() instead,
there is no need for a second clear_young(), and we don't call
get_pfn_folio() on pages that are not young.

WDYT? Have I misunderstood your comment?

Also, I take it your comment was not just about walk_pte_range() but
about the similar bits in lru_gen_look_around() as well, so I'll make
whatever changes we agree on there too (or maybe factor out the common
bits).

[1]: https://lore.kernel.org/kvmarm/20230526234435.662652-11-yuzhao@google.=
com/

> In addition, what about the non-lockless cases? Would this change make
> them worse by grabbing the MMU lock twice per PTE?

That's a good point. Yes I think calling the notifier twice here would
indeed exacerbate problems with a non-lockless notifier.

Thanks!

