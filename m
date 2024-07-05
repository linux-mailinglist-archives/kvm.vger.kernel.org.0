Return-Path: <kvm+bounces-21048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 89A44928D91
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 20:36:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A370E1C2135F
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 18:36:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8154E169AD0;
	Fri,  5 Jul 2024 18:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wXnBafB0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2239E1442E8
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 18:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720204570; cv=none; b=Hj5P5tDZmTx2saJHwbWz8jrcdpZKAde7sWUA+9BOu1wgDeXfnLRR6wSpceynSFVNxd4+JhYl6ek7kREq2Sz/b8XKlfmP/tEiOTyNqnIrEngg7iZvnNgPjKwb0HzWLQ3eXw3jXV0f/ekO85wDPFYXm/mSVqMHErYHUtvy/Wz2sn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720204570; c=relaxed/simple;
	bh=65iIWMAt6zV/VEHbbCp9GEindBQ8yteBfTDw7ROSbSM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cAkdA5MHcrXGszAECB9ePYYBphgg94vuzB+H2Yav3+se+hGrVjV3IaaVTvDTnn+OR8RqfJNnN9b5Vng+SrnsDdoPsIzAnoLbZGr34OOz4nnP3T1wi3NtWFNAncbx99GpkHifUG90khf7pTz96NE++Qlk1J6rxp0tsiPie0zQh40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wXnBafB0; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-447dabd9562so193841cf.0
        for <kvm@vger.kernel.org>; Fri, 05 Jul 2024 11:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720204568; x=1720809368; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yoy/TMejpXli2qc8prUN620bWwV2Ki2Pjep6mdKl7Uo=;
        b=wXnBafB0zeyUP7fylP86IKvHGLTxcoNJiwgvOr2g6snQQpxcTbXQcsZzJjdXdGPV9a
         KiiULpdFNGC7kGHqUtBagmBLPc1YwM7/l5/Q7cZwDqTAzz4DU/tlWJydhzB3YmHDi/pp
         pggFqGFAtHoYDSRf/HrcJzf1WMKsa/Bb6zWy0r7F8wV/Z4fJ3bNITBfJFAxZlohsFHQC
         v+msoWZqrencP2maAj4TpLRqsgI/amM/F6dTixL3xl56QznVKUgQcKNKRWtkd6E/RYmF
         GVaBjcleIKK6HoVf6qsoGcBgiE1CzvD2WZSdqFsdtFy4A+mwLXoXQbndJjuMf3j1hPcg
         Raow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720204568; x=1720809368;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yoy/TMejpXli2qc8prUN620bWwV2Ki2Pjep6mdKl7Uo=;
        b=eN0f9p1nZhfhxfWuFnZCSeiib6ni46UaehxSZn11r0255wI3CLhD36KyFjjXhQxeLM
         I0ck24CX4mt0j2z5aJHukgZ1hSYPdFyVyDgJDRwMw9YEFXg8cRbTb1vjvQiWyGhcpJ2z
         Yn63BZNxG+C00aUeLfiWZa0Q1swpm+q393MgRrSk4cIzfW5IEcYY39KCsiGnMv0FDGyY
         k8uZ54wgHPTRZG33xBO5W7uv4FIdbzdb0zpvthwLv+Au/yHnA9uGeEBDT61b5KTSi9dM
         XuimOuw4230JX+JCAVGOJF0QvpQxz1ZnhFGs62ryYd0l0L4SrIz5vTGW8sylxZNUDmtg
         amtg==
X-Forwarded-Encrypted: i=1; AJvYcCVVWLHqglJvDhgQYJyjOlb2w3TlTi3eb5U2SR8FD4NIKGWyUFhgn7IJpbfId356n3+qcOEFHMmCCMIlwutc15pfOIBt
X-Gm-Message-State: AOJu0YxdfNoU/CwCRi8wAU9I+qzxWtxZpNGLy3jKObhHLUiSnNehnG7R
	WY2Pkqw1RxGolMAMztPYx3caG0M6UrXBAWk2a6KzMtA1AFkBCdUotumCXfzyLY2AsC3qF9uJbyA
	voD0jaLWwxEsYiYhAhdjgEf4fNXm07Vt51we0
X-Google-Smtp-Source: AGHT+IGnfZ2i6vZIamne8x/WQHaBe69PdvzYLEPHrKS7jax7pkFgeRZaSsCa2L5NvM2TqQ2LDJG/8RSWDD12RqGBZ9E=
X-Received: by 2002:ac8:4f43:0:b0:443:1cdd:7859 with SMTP id
 d75a77b69052e-447c8fa4056mr5386091cf.12.1720204567891; Fri, 05 Jul 2024
 11:36:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240611002145.2078921-1-jthoughton@google.com> <20240611002145.2078921-9-jthoughton@google.com>
In-Reply-To: <20240611002145.2078921-9-jthoughton@google.com>
From: Yu Zhao <yuzhao@google.com>
Date: Fri, 5 Jul 2024 12:35:29 -0600
Message-ID: <CAOUHufb2f_EwHY5LQ59k7Nh7aS1-ZbOKtkoysb8BtxRNRFMypQ@mail.gmail.com>
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

On Mon, Jun 10, 2024 at 6:22=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
>
> Secondary MMUs are currently consulted for access/age information at
> eviction time, but before then, we don't get accurate age information.
> That is, pages that are mostly accessed through a secondary MMU (like
> guest memory, used by KVM) will always just proceed down to the oldest
> generation, and then at eviction time, if KVM reports the page to be
> young, the page will be activated/promoted back to the youngest
> generation.
>
> The added feature bit (0x8), if disabled, will make MGLRU behave as if
> there are no secondary MMUs subscribed to MMU notifiers except at
> eviction time.
>
> Implement aging with the new mmu_notifier_test_clear_young_fast_only()
> notifier. For architectures that do not support this notifier, this
> becomes a no-op. For architectures that do implement it, it should be
> fast enough to make aging worth it.
>
> Suggested-by: Yu Zhao <yuzhao@google.com>
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
>
> Notes:
>     should_look_around() can sometimes use two notifiers now instead of o=
ne.
>
>     This simply comes from restricting myself from not changing
>     mmu_notifier_clear_young() to return more than just "young or not".
>
>     I could change mmu_notifier_clear_young() (and
>     mmu_notifier_test_young()) to return if it was fast or not. At that
>     point, I could just as well combine all the notifiers into one notifi=
er,
>     like what was in v2 and v3.
>
>  Documentation/admin-guide/mm/multigen_lru.rst |   6 +-
>  include/linux/mmzone.h                        |   6 +-
>  mm/rmap.c                                     |   9 +-
>  mm/vmscan.c                                   | 185 ++++++++++++++----
>  4 files changed, 164 insertions(+), 42 deletions(-)

...

>  static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned lon=
g end,
>                            struct mm_walk *args)
>  {
> @@ -3357,8 +3416,9 @@ static bool walk_pte_range(pmd_t *pmd, unsigned lon=
g start, unsigned long end,
>         struct pglist_data *pgdat =3D lruvec_pgdat(walk->lruvec);
>         DEFINE_MAX_SEQ(walk->lruvec);
>         int old_gen, new_gen =3D lru_gen_from_seq(max_seq);
> +       struct mm_struct *mm =3D args->mm;
>
> -       pte =3D pte_offset_map_nolock(args->mm, pmd, start & PMD_MASK, &p=
tl);
> +       pte =3D pte_offset_map_nolock(mm, pmd, start & PMD_MASK, &ptl);
>         if (!pte)
>                 return false;
>         if (!spin_trylock(ptl)) {
> @@ -3376,11 +3436,12 @@ static bool walk_pte_range(pmd_t *pmd, unsigned l=
ong start, unsigned long end,
>                 total++;
>                 walk->mm_stats[MM_LEAF_TOTAL]++;
>
> -               pfn =3D get_pte_pfn(ptent, args->vma, addr);
> +               pfn =3D get_pte_pfn(ptent, args->vma, addr, pgdat);
>                 if (pfn =3D=3D -1)
>                         continue;
>
> -               if (!pte_young(ptent)) {
> +               if (!pte_young(ptent) &&
> +                   !lru_gen_notifier_test_young(mm, addr)) {
>                         walk->mm_stats[MM_LEAF_OLD]++;
>                         continue;
>                 }
> @@ -3389,8 +3450,9 @@ static bool walk_pte_range(pmd_t *pmd, unsigned lon=
g start, unsigned long end,
>                 if (!folio)
>                         continue;
>
> -               if (!ptep_test_and_clear_young(args->vma, addr, pte + i))
> -                       VM_WARN_ON_ONCE(true);
> +               lru_gen_notifier_clear_young(mm, addr, addr + PAGE_SIZE);
> +               if (pte_young(ptent))
> +                       ptep_test_and_clear_young(args->vma, addr, pte + =
i);
>
>                 young++;
>                 walk->mm_stats[MM_LEAF_YOUNG]++;


There are two ways to structure the test conditions in walk_pte_range():
1. a single pass into the MMU notifier (combine test/clear) which
causes a cache miss from get_pfn_page() if the page is NOT young.
2. two passes into the MMU notifier (separate test/clear) if the page
is young, which does NOT cause a cache miss if the page is NOT young.

v2 can batch up to 64 PTEs, i.e., it only goes into the MMU notifier
twice every 64 PTEs, and therefore the second option is a clear win.

But you are doing twice per PTE. So what's the rationale behind going
with the second option? Was the first option considered?

In addition, what about the non-lockless cases? Would this change make
them worse by grabbing the MMU lock twice per PTE?

