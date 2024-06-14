Return-Path: <kvm+bounces-19707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 917BB909235
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 20:24:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D17E1F22D90
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 18:24:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33C8F19EEBF;
	Fri, 14 Jun 2024 18:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vHaYLmnf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E3219ADB3
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 18:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718389441; cv=none; b=mmN1WP5k1r52j1/LQ/ByKI3YM9klVQo0oXixanhY3jANzI4audnst5TnTnXykNqPP99/hMd+bBrY1sxZVhXUNluRiXpFzVJvlFzdQo/mHBPXVG8y5QZiOn7LkC1GgMhcMHqybLEaDe1/HVF6m8VnCSBAmF64AG5To8myQupnIAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718389441; c=relaxed/simple;
	bh=zcjF8Xyqocy3s2Ob4L1Ckw1n/AyByxuNgc2fQwpZZjA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R1NQ0b1O346V5uj2MoF57FFJL0yIEIRqYMZRp3HHIr1LjoqDEIO2yHNgvKXm5PrRlzkn0DSppdwrg6+e61fZC0tK5aEedgyJFFu9TSA8Zo8tQLB+eMQzM2ar4MENxAcoW6jk6UY6txxT4oLsp/1xFJUYfoskydGmKG2xsUTmXKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vHaYLmnf; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-44219bacafeso37791cf.1
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 11:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718389438; x=1718994238; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+e1S7VxRmA5wGFSxD1T8KbdKKkr/h73427zkqEMDfd4=;
        b=vHaYLmnfxMNuQT8vUKcjP9wN1n2fnXFsSANNwAoMMf1AObr66qwr3ObJRMa9+GJxBe
         ywiJy78Xi4F/eQ9kE9mhRmI0v9SuSxlTGyPEOUCygu3PPvPOETm/gQhe1x84pYn+RFNi
         7ZrX92LpMOaDELhc7LkiKiXPBHGT9QbUj6kxK2rPwJ+qXbDkZVu37M41gx3aODmNUFNc
         RWt3OY7SbpvEdC+Py31V55rriQZI9m0A8QmrXn/NrjYejOrag1upVvSzUxjg/K/2FQKC
         DfTGORjLlgsaX7fnhj4Jl61uzlkmUk5fWEeJbDaD3lTirYKZqWGDG553xiez89JrN+8m
         LZRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718389438; x=1718994238;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+e1S7VxRmA5wGFSxD1T8KbdKKkr/h73427zkqEMDfd4=;
        b=LWRVnxxyQffbfFmenCAJEEYYKbNZsZVVQ2H8/w34Wy2xdBZwAd3Xu8YYdpwVUvTG83
         1UEDkGXkWePAdYwQGgrV6Lhx15CaMtlpva5jDwV9v9b/v/KlYwB65Jpan/Hqq+GsJVnR
         KAsuMKh7MAiJ/3r5naN0ewIYb69j0hZDiEUqXARn1/KL4D4LEhE/2Hym5w8ujfqbgu9D
         m+vzmBJDzwP0t6QGQWEXm588tNy1FJAq12mRRnIk7wIkOSunNDvGZxhiiALxm6gOPvRn
         rHTxHOH49CZHxTTlxZjMutw628aEK2dnQYDF8NfAyx4l1m2RpGPqZaT1rOjWyzz5AhQg
         KEbw==
X-Forwarded-Encrypted: i=1; AJvYcCUMeGf1vPTvx7ULYehBZBjwLgHnV5tzOVMXvE/QIuqNCF4VpGC7MsQA3VqPFUcvyavEEVgwQxHPrrMtq2UjZduVU+Mw
X-Gm-Message-State: AOJu0Yx6Ml8WTWvEH7LU1SE1JqfV07GLtmC2UjCHlOYZQa9W88XsSo1X
	7BiGqi1mb5lAr++bDYBMiJYM/Nez/PJENxrsEcR3LpcD/+8MpT+t0+RtACnsP+uM4eodABBl9wd
	RDJAHtgIO/0ULIR6vsjCGlKrTL6W4DoJtg9A+
X-Google-Smtp-Source: AGHT+IH+9subwK96UF5eNA7C1xIBVfzLuBaLXzzEgBSMa1vnBDab4AZtlky3wQKAROgOb6aooh80p+OgpnovU+m6mmo=
X-Received: by 2002:ac8:5a08:0:b0:441:630e:110a with SMTP id
 d75a77b69052e-4434f82a2e6mr155091cf.17.1718389438198; Fri, 14 Jun 2024
 11:23:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240611002145.2078921-1-jthoughton@google.com>
 <20240611002145.2078921-5-jthoughton@google.com> <CAOUHufYGqbd45shZkGCpqeTV9wcBDUoo3iw1SKiDeFLmrP0+=w@mail.gmail.com>
 <CADrL8HVHcKSW3hiHzKTit07gzo36jtCZCnM9ZpueyifgNdGggw@mail.gmail.com>
 <ZmioedgEBptNoz91@google.com> <CADrL8HU_FKHTz_6d=xhVLZFDQ_zQo-zdB2rqdpa2CKusa1uo+A@mail.gmail.com>
 <ZmjtEBH42u7NUWRc@google.com> <CADrL8HUW2q79F0FsEjhGW0ujij6+FfCqas5UpQp27Epfjc94Nw@mail.gmail.com>
 <ZmxsCwu4uP1lGsWz@google.com>
In-Reply-To: <ZmxsCwu4uP1lGsWz@google.com>
From: James Houghton <jthoughton@google.com>
Date: Fri, 14 Jun 2024 11:23:21 -0700
Message-ID: <CADrL8HVDZ+m_-jUCaXf_DWJ92N30oqS=_9wNZwRvoSp5fo7asg@mail.gmail.com>
Subject: Re: [PATCH v5 4/9] mm: Add test_clear_young_fast_only MMU notifier
To: Sean Christopherson <seanjc@google.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 14, 2024 at 9:13=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Jun 13, 2024, James Houghton wrote:
> > On Tue, Jun 11, 2024 at 5:34=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > > A flag would also avoid an indirect call and thus a RETPOLINE when CO=
NFIG_RETPOLINE=3Dy,
> > > i.e. would be a minor optimization when KVM doesn't suppport fast agi=
ng.  But that's
> > > probably a pretty unlikely combination, so it's probably not a valid =
argument.
> > >
> > > So, I guess I don't have a strong opinion?
> >
> > (Sorry for the somewhat delayed response... spent some time actually
> > writing what this would look like.)
> >
> > I see what you mean, thanks! So has_fast_aging might be set by KVM if
> > the architecture sets a Kconfig saying that it understands the concept
> > of fast aging, basically what the presence of this v5's
> > test_clear_young_fast_only() indicates.
>
> It would need to be a runtime setting, because KVM x86-64 with tdp_mmu_en=
abled=3Dfalse
> doesn't support fast aging (uses the shadow MMU even for TDP).

I see. I'm not sure if it makes sense to put this in `ops` as you
originally had it then (it seems like a bit of a pain anyway). I could
just make it a member of `struct mmu_notifier` itself.

> > So just to be clear, for test_young(), I intend to have a patch in v6
> > to elide the shadow MMU check if the TDP MMU indicates Accessed. Seems
> > like a pure win; no reason not to include it if we're making logic
> > changes here anyway.
>
> I don't think that's correct.  The initial fast_only=3Dfalse aging should=
 process
> shadow MMUs (nested TDP) and TDP MMUs, otherwise a future fast_only=3Dfal=
se would
> get a false positive on young due to failing to clear the Accessed bit in=
 the
> shadow MMU.  E.g. if page X is accessed by both L1 and L2, then aged, and=
 never
> accessed again, the Accessed bit would still be set in the page tables fo=
r L2.

For clear_young(fast_only=3Dfalse), yeah we need to check and clear
Accessed for both MMUs. But for test_young(fast_only=3Dfalse), I don't
see why we couldn't just return early if the TDP MMU reports young.

> My thought for MMU_NOTIFY_WAS_FAST below (which again is a bad name) is t=
o
> communicate to MGLRU that the page was found to be young in an MMU that s=
upports
> fast aging, i.e. that looking around at other SPTEs is worth doing.

That makes sense; I don't think this little test_young() optimization
affects that.

> > > > > So rather than failing the fast aging, I think what we want is to=
 know if an
> > > > > mmu_notifier found a young SPTE during a fast lookup.  E.g. somet=
hing like this
> > > > > in KVM, where using kvm_has_shadow_mmu_sptes() instead of kvm_mem=
slots_have_rmaps()
> > > > > is an optional optimization to avoid taking mmu_lock for write in=
 paths where a
> > > > > (very rare) false negative is acceptable.
> > > > >
> > > > >   static bool kvm_has_shadow_mmu_sptes(struct kvm *kvm)
> > > > >   {
> > > > >         return !tdp_mmu_enabled || READ_ONCE(kvm->arch.indirect_s=
hadow_pages);
> > > > >   }
> > > > >
> > > > >   static int __kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range =
*range,
> > > > >                          bool fast_only)
> > > > >   {
> > > > >         int young =3D 0;
> > > > >
> > > > >         if (!fast_only && kvm_has_shadow_mmu_sptes(kvm)) {
> > > > >                 write_lock(&kvm->mmu_lock);
> > > > >                 young =3D kvm_handle_gfn_range(kvm, range, kvm_ag=
e_rmap);
> > > > >                 write_unlock(&kvm->mmu_lock);
> > > > >         }
> > > > >
> > > > >         if (tdp_mmu_enabled && kvm_tdp_mmu_age_gfn_range(kvm, ran=
ge))
> > > > >                 young =3D 1 | MMU_NOTIFY_WAS_FAST;
> >
> > The most straightforward way (IMHO) to return something like `1 |
> > MMU_NOTIFY_WAS_FAST` up to the MMU notifier itself is to make
> > gfn_handler_t return int instead of bool.
>
> Hrm, all the options are unpleasant.  Modifying gfn_handler_t to return a=
n int
> will require an absurd amount of churn (all implementations in all archic=
tures),
> and I don't love that the APIs that return true/false to indicate "flush"=
 would
> lose their boolean-ness.
>
> One idea would be to add kvm_mmu_notifier_arg.aging_was_fast or so, and t=
hen
> refactor kvm_handle_hva_range_no_flush() into a dedicated aging helper, a=
nd have
> it morph the KVM-internal flag into an MMU_NOTIFIER flag.  It's not perec=
t either,
> but it requires far less churn and keeps some of the KVM<=3D>mmu_notifer =
details in
> common KVM code.

SGTM. I think this will work. Thanks!

> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 7b9d2633a931..c11a359b6ff5 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -258,6 +258,7 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
>  #ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
>  union kvm_mmu_notifier_arg {
>         unsigned long attributes;
> +       bool aging_was_fast;
>  };
>
>  struct kvm_gfn_range {
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 436ca41f61e5..a936f6bedd97 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -685,10 +685,10 @@ static __always_inline int kvm_handle_hva_range(str=
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
> +static __always_inline int kvm_age_hva_range(struct mmu_notifier *mn,
> +                                            unsigned long start,
> +                                            unsigned long end,
> +                                            bool flush_if_young)
>  {
>         struct kvm *kvm =3D mmu_notifier_to_kvm(mn);
>         const struct kvm_mmu_notifier_range range =3D {
> @@ -696,11 +696,14 @@ static __always_inline int kvm_handle_hva_range_no_=
flush(struct mmu_notifier *mn
>                 .end            =3D end,
>                 .handler        =3D handler,
>                 .on_lock        =3D (void *)kvm_null_fn,
> -               .flush_on_ret   =3D false,
> +               .flush_on_ret   =3D flush_if_young,
>                 .may_block      =3D false,
> +               .aging_was_fast =3D false,
>         };
>
> -       return __kvm_handle_hva_range(kvm, &range).ret;
> +       bool young =3D __kvm_handle_hva_range(kvm, &range).ret;
> +
> +       return (int)young | (range.aging_was_fast ? MMU_NOTIFIER_FAST_AGI=
NG : 0);
>  }
>
>  void kvm_mmu_invalidate_begin(struct kvm *kvm)
> @@ -865,7 +868,7 @@ static int kvm_mmu_notifier_clear_flush_young(struct =
mmu_notifier *mn,
>  {
>         trace_kvm_age_hva(start, end);
>
> -       return kvm_handle_hva_range(mn, start, end, kvm_age_gfn);
> +       return kvm_age_hva_range(mn, start, end, true);
>  }
>
>  static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
> @@ -875,20 +878,7 @@ static int kvm_mmu_notifier_clear_young(struct mmu_n=
otifier *mn,
>  {
>         trace_kvm_age_hva(start, end);
>
> -       /*
> -        * Even though we do not flush TLB, this will still adversely
> -        * affect performance on pre-Haswell Intel EPT, where there is
> -        * no EPT Access Bit to clear so that we have to tear down EPT
> -        * tables instead. If we find this unacceptable, we can always
> -        * add a parameter to kvm_age_hva so that it effectively doesn't
> -        * do anything on clear_young.
> -        *
> -        * Also note that currently we never issue secondary TLB flushes
> -        * from clear_young, leaving this job up to the regular system
> -        * cadence. If we find this inaccurate, we might come up with a
> -        * more sophisticated heuristic later.
> -        */
> -       return kvm_handle_hva_range_no_flush(mn, start, end, kvm_age_gfn)=
;
> +       return kvm_age_hva_range(mn, start, end, false);
>  }
>
>  static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
> @@ -897,8 +887,7 @@ static int kvm_mmu_notifier_test_young(struct mmu_not=
ifier *mn,
>  {
>         trace_kvm_test_age_hva(address);
>
> -       return kvm_handle_hva_range_no_flush(mn, address, address + 1,
> -                                            kvm_test_age_gfn);
> +       return kvm_age_hva_range(mn, address, address + 1, false);
>  }
>
>  static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
>
>
> > > The change, relative to v5, that I am proposing is that MGLRU looks a=
round if
> > > the page was young in _a_ "fast" secondary MMU, whereas v5 looks arou=
nd if and
> > > only if _all_ secondary MMUs are fast.
> > >
> > > In other words, if a fast MMU had a young SPTE, look around _that_ MM=
U, via the
> > > fast_only flag.
> >
> > Oh, yeah, that's a lot more intelligent than what I had. I think I
> > fully understand your suggestion; I guess we'll see in v6. :)
> >
> > I wonder if this still makes sense if whether or not an MMU is "fast"
> > is determined by how contended some lock(s) are at the time.
>
> No.  Just because a lock wasn't contended on the initial aging doesn't me=
an it
> won't be contended on the next round.  E.g. when using KVM x86's shadow M=
MU, which
> takes mmu_lock for write for all operations, an aging operation could get=
 lucky
> and sneak in while mmu_lock happened to be free, but then get stuck behin=
d a large
> queue of operations.
>
> The fast-ness needs to be predictable and all but guaranteed, i.e. lockle=
ss or in
> an MMU that takes mmu_lock for read in all but the most rare paths.

Aging and look-around themselves only use the fast-only notifiers, so
they won't ever wait on a lock (well... provided KVM is written like
that, which I think is a given). should_look_around() will use the
slow notifier because it (despite its name) is responsible for
accurately determining if a page is young lest we evict a young page.

So in this case where "fast" means "lock not contended for now", I
don't think it's necessarily wrong for MGLRU to attempt to find young
pages, even if sometimes it will bail out because a lock is
contended/held for a few or even a majority of the pages. Not doing
look-around is the same as doing look-around and finding that no pages
are young.

Anyway, I don't think this bit is really all that important unless we
can demonstrate that KVM participating like this actually results in a
measurable win.

