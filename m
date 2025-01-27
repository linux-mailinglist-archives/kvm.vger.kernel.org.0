Return-Path: <kvm+bounces-36679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 74634A1DCEE
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 20:51:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E1B01886503
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 19:51:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96558194A67;
	Mon, 27 Jan 2025 19:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t/YxTpLW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6C017E
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 19:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738007463; cv=none; b=VvaSbON8L/HPI8kiBYBPsnV+PtIpIhEVvWwjcAtxr/9PABd0RdlexBXtRlVLuw1/vmOEFayjkd0lGrW/A1bXP+Z+9zntoFUA1z5fDKoMFc64cUtBMKK1y/jVSJCMKVBt1Ghddk9P9ApfcollvK9Vd6yEpgS5V7XBX868btEbiYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738007463; c=relaxed/simple;
	bh=nxQi1ss3upUEjzGLSm5+ZO9GjlFG3W0/xVGaWs0a16M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LJWx46kSYG1E4ydKxsg5wkscxOfHXIiIJuHFNiXmPy6Sj116iy6CuGQQZrcKhmJCXmhLtNU/TwakQIWABAb8C2Sl8svgp+/gK020Sm1vjtor//NfejLDV9jXYFGQcrL7uOii9ZEJwCuzZrzaffh3Ri9Y3EgifFbBF1MEQdWkbsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t/YxTpLW; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e53a5ff2233so8702481276.3
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 11:51:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738007461; x=1738612261; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VR9sqn4GxBtXmStYfka169NPIclgHFITZrcvdcePS/Q=;
        b=t/YxTpLW5Bx626wr1SRgi1m8y3/ICloSjtUZp7cod9RGsnjJXxT0Uo5sF15lnYZnHU
         WBOLhp0Ztl+KMjJEQVEPX0EPbiC5mmBjj1GIdlWZDpwV9yJ2+yd1LetY8HMOprnR3f83
         BaxIWy8m3fqW4g2/9E5Ga1THtOA2jme/crrEog0F/Glmp8h1kvNaHJaoM2IC8YVvPnDu
         11UkykT6C7l0Vg1k0+RbigxsbD2j7kNvtKLpBNb6obyt/HhI/3itEbsHVQUczRv5OEFm
         2C6SgzO3lX13fHM2++3Vnhu9+xBIl+M74015QdmkpOwjUKGK5cYC8DOIKeM3NSk77ZEM
         V5RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738007461; x=1738612261;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VR9sqn4GxBtXmStYfka169NPIclgHFITZrcvdcePS/Q=;
        b=bcF480w+c2YHFNkCyGNq2ITmdy76Is0NtB4m6Nnz9JaLizGBF824ftpkdYiQ7mEqOE
         6yqBkvA34nGI1qPmvtlvf1rN8KutH/RlVicgCTdIH5ncm3z2tSIVA+5oVkHCSSCfs2CS
         ZpJwo+I9MfveYOPer/tY90uRsytYojYNsVJO65DvXAInZny465dTVPgDtNt12e9YCdVJ
         s+MfawyXtP7qw8jL9i7OsmRL81/3BtsX07GTJZzF1af74r41g6LvbMk2ttq5DrZT4aKP
         tyrRdr+vPPfwh/pnCXuKdp6GOOXQpiN7xITQkiMV00mtJaE8yWRNqB2sn6hwEVa02tRn
         xvbQ==
X-Forwarded-Encrypted: i=1; AJvYcCVmOsKRRY2zj7wkdH/KkWSV8Odoa+ok0kcLxlh7QnSrC0/05P63n/MTClReetYYySGwvXY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJ8D3ME3cDqyaP5AwKX9scOOW7qdz7qKfS2UwCCmfDJ/NowRHZ
	x5SnifLSXCfEwOtE+cQkOWyHuY+i49+fZw6B6oDHRVPEXUs0NQ6qoYjJwIkihJArqylGBKf+dh4
	bjuQqOlaOXNohplxj50YhfLEF+H0G5XuJMRnR
X-Gm-Gg: ASbGncvJxLcgvH+pdpizTKBE7DBBW4XWjv5wdQ+dP9Kn7VQEy06Fnaw5zfI54ocLFRM
	E5mWRjfJ+gOEstqlWk7y8vbIerKh8Xg7zOolMMawf5tpNUvWXJQ2y4z2NzwzuaoG2PzjpTnGlH2
	tWKG+nVzR6JQU7H2aGzZ4pd/cNT4s=
X-Google-Smtp-Source: AGHT+IGDDtzmV5hPl3ymm0ZuJlT9T6DI3qjEKWkH1/ITxu+VTdaLFGFdSFqAwGtMMhCp7E5QuZCyfcfgK0gQH2DRITY=
X-Received: by 2002:a05:690c:9a13:b0:6ee:6c7d:4888 with SMTP id
 00721157ae682-6f6eb68b298mr306989937b3.22.1738007460876; Mon, 27 Jan 2025
 11:51:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105184333.2305744-1-jthoughton@google.com>
 <20241105184333.2305744-2-jthoughton@google.com> <Z4GcF4sIJHfEAEDg@google.com>
In-Reply-To: <Z4GcF4sIJHfEAEDg@google.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 27 Jan 2025 11:50:25 -0800
X-Gm-Features: AWEUYZnT5t2ZS28h7lxhUz9VCmM7PeZ9RqzoLwW5mllwJ8yj2HTafy4Y8DcREx0
Message-ID: <CADrL8HVWsJ8swSNPvvqfNF0fspt5wZBScPZCcfL7GPh5c2HabA@mail.gmail.com>
Subject: Re: [PATCH v8 01/11] KVM: Remove kvm_handle_hva_range helper functions
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 10, 2025 at 2:15=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Nov 05, 2024, James Houghton wrote:
> > kvm_handle_hva_range is only used by the young notifiers. In a later
> > patch, it will be even further tied to the young notifiers. Instead of
> > renaming kvm_handle_hva_range to something like
>
> When referencing functions, include parantheses so its super obvious that=
 the
> symbol is a function(), e.g. kvm_handle_hva_range(), kvm_handle_hva_range=
_young(),
> etc.

Thanks Sean, I think I've fixed up all the cases now.

>
> > kvm_handle_hva_range_young, simply remove kvm_handle_hva_range. This
> > seems slightly more readable,
>
> I disagree, quite strongly in fact.  The amount of duplication makes it h=
arder
> to see the differences between the three aging flow, and the fewer instan=
ces of
> this pattern:
>
>         return kvm_handle_hva_range(kvm, &range).ret;
>
> the better.  I added the tuple return as a way to avoid an out-param (whi=
ch I
> still think is a good tradeoff), but there's definitely a cost to it.
>
> > though there is slightly more code duplication.
>
> Heh, you have a different definition of "slightly".  The total lines of c=
ode may
> be close to a wash, but at the end of the series there's ~10 lines of cod=
e that
> is nearly identical in three different places.
>
> My vote is for this:

I applied this patch verbatim as a replacement for the original one.

Since [1], the "refactor" in this original patch makes much less sense. Tha=
nks!

[1]: commit 28f8b61a69b5c ("KVM: Allow arch code to elide TLB flushes
when aging a young page")


> ---
>  virt/kvm/kvm_main.c | 27 +++++++++++++--------------
>  1 file changed, 13 insertions(+), 14 deletions(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index de2c11dae231..bf4670e9fcc6 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -551,8 +551,8 @@ static void kvm_null_fn(void)
>              node;                                                       =
    \
>              node =3D interval_tree_iter_next(node, start, last))      \
>
> -static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *k=
vm,
> -                                                          const struct k=
vm_mmu_notifier_range *range)
> +static __always_inline kvm_mn_ret_t kvm_handle_hva_range(struct kvm *kvm=
,
> +                                                        const struct kvm=
_mmu_notifier_range *range)
>  {
>         struct kvm_mmu_notifier_return r =3D {
>                 .ret =3D false,
> @@ -628,7 +628,7 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_=
range(struct kvm *kvm,
>         return r;
>  }
>
> -static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
> +static __always_inline int kvm_age_hva_range(struct mmu_notifier *mn,
>                                                 unsigned long start,
>                                                 unsigned long end,
>                                                 gfn_handler_t handler,
> @@ -647,10 +647,10 @@ static __always_inline int kvm_handle_hva_range(str=
uct mmu_notifier *mn,
>         return __kvm_handle_hva_range(kvm, &range).ret;
>  }
>
> -static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_noti=
fier *mn,
> -                                                        unsigned long st=
art,
> -                                                        unsigned long en=
d,
> -                                                        gfn_handler_t ha=
ndler)
> +static __always_inline int kvm_age_hva_range_no_flush(struct mmu_notifie=
r *mn,
> +                                                     unsigned long start=
,
> +                                                     unsigned long end,
> +                                                     gfn_handler_t handl=
er)
>  {
>         return kvm_handle_hva_range(mn, start, end, handler, false);
>  }
> @@ -747,7 +747,7 @@ static int kvm_mmu_notifier_invalidate_range_start(st=
ruct mmu_notifier *mn,
>          * that guest memory has been reclaimed.  This needs to be done *=
after*
>          * dropping mmu_lock, as x86's reclaim path is slooooow.
>          */
> -       if (__kvm_handle_hva_range(kvm, &hva_range).found_memslot)
> +       if (kvm_handle_hva_range(kvm, &hva_range).found_memslot)
>                 kvm_arch_guest_memory_reclaimed(kvm);
>
>         return 0;
> @@ -793,7 +793,7 @@ static void kvm_mmu_notifier_invalidate_range_end(str=
uct mmu_notifier *mn,
>         };
>         bool wake;
>
> -       __kvm_handle_hva_range(kvm, &hva_range);
> +       kvm_handle_hva_range(kvm, &hva_range);
>
>         /* Pairs with the increment in range_start(). */
>         spin_lock(&kvm->mn_invalidate_lock);
> @@ -817,8 +817,8 @@ static int kvm_mmu_notifier_clear_flush_young(struct =
mmu_notifier *mn,
>  {
>         trace_kvm_age_hva(start, end);
>
> -       return kvm_handle_hva_range(mn, start, end, kvm_age_gfn,
> -                                   !IS_ENABLED(CONFIG_KVM_ELIDE_TLB_FLUS=
H_IF_YOUNG));
> +       return kvm_age_hva_range(mn, start, end, kvm_age_gfn,
> +                                !IS_ENABLED(CONFIG_KVM_ELIDE_TLB_FLUSH_I=
F_YOUNG));
>  }
>
>  static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
> @@ -841,7 +841,7 @@ static int kvm_mmu_notifier_clear_young(struct mmu_no=
tifier *mn,
>          * cadence. If we find this inaccurate, we might come up with a
>          * more sophisticated heuristic later.
>          */
> -       return kvm_handle_hva_range_no_flush(mn, start, end, kvm_age_gfn)=
;
> +       return kvm_age_hva_range_no_flush(mn, start, end, kvm_age_gfn);
>  }
>
>  static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
> @@ -850,8 +850,7 @@ static int kvm_mmu_notifier_test_young(struct mmu_not=
ifier *mn,
>  {
>         trace_kvm_test_age_hva(address);
>
> -       return kvm_handle_hva_range_no_flush(mn, address, address + 1,
> -                                            kvm_test_age_gfn);
> +       return kvm_age_hva_range_no_flush(mn, address, address + 1, kvm_t=
est_age_gfn);
>  }
>
>  static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
>
> base-commit: 2d5faa6a8402435d6332e8e8f3c3f18cca382d83
> --

