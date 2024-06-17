Return-Path: <kvm+bounces-19803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B999390B7D0
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 19:22:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8D411B2D720
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 16:51:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2E0D29414;
	Mon, 17 Jun 2024 16:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="By4oB/es"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B09C15A493
	for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 16:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718643067; cv=none; b=T6YqvpTJE/bQkWa/hdTtRRCp7maqrR06UApLJbZM5PhWKOGCygfzzFAncbLtxypemBVWQqtIYk6xGbCvs1/+renP1N7M/T+HEMpPC30LOtdg7p/YMGWRgdPuSgyYQFZSsqCF1faSKoG9IYFGh9LbEvwei5asqREUEsWrdvCJfxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718643067; c=relaxed/simple;
	bh=49SkQcuHIP5rsZXNPEEeMHqjHmxLyEaoEHFajG29aWY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bB/IHRJiYQ0EJPkobFhSuY7gsOkx5+GQyGKknPs5QUWrzr8dVRYTLHfsKPkjIAhpkm/nfUnjKZYGOXtmFHwDj+aKsw7RkwgcVgxJx8f3ZD2HIdYzqpcL333wfezcuYqEaPKoc2+kkl4JLWuKcriVNRUwgya52haI4UFdzL/T2P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=By4oB/es; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4405dffca81so1701cf.1
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 09:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718643064; x=1719247864; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=txeYGZbAulYQnRze5h20s5tFWK2wdS382ItpdGZVmi0=;
        b=By4oB/esToXvdTWKIXZXUTADLYoU2icqPnmyzHtEm8Ey5yt3O7GWymoCKTAvcgaagI
         ohLEKDgPL0gKq9Wm7QaY+vaQKaz7suywCeW7xfcMqMvLTwFTEX6Se0N+spOmi4iLAqKI
         uTU8C8SJW4ctDpMDcUx5rmsg3DLccR8gn091PtewkaJnAsxrBSt0ULXV9gbE7GTtUBPk
         97Wo9BoUH9oy2i0jY1eiZaoD0i7kIk+R7xA+RYQnYiT4LPLtQ35VuqZ9hQZjxWG6lJAE
         AEwqssrvy+p36vNxLtuM5kTIwPF5ZCj4c6ilGV8BHsRdYzLgmPs7AjcezV+SPFxabGNj
         DjHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718643064; x=1719247864;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=txeYGZbAulYQnRze5h20s5tFWK2wdS382ItpdGZVmi0=;
        b=rioG4wzxinB12RkEZlsRyGuPcK7aB3tI6LUl4tEblI9sRoxHEMFSLzT2FXPoyoPbXE
         MTa0OlkGSFXLbdDxGSig9RmS0H+8//noP1gzhnpQkGhot7R44Bv49pc+DgMw11r/IVqo
         krz8ddP3MGLGw4KJSD/4gtRC9gL+SCkbXSbo0uPQ33vCwjVgGVJVBtz6CHVvL5050cyv
         hxRE7uuhd1aqdPFxgNfpQHpu1mkBTySI6N47MEO1it4OhtaVrWMuRjO4N0UdMlToZbgg
         Idcf3vfTvbCFn3nPUXEh2k7m50+Fm5UpWBIaRFFAdeEFFMo1SD9b9DaENvBs6z1WpOYk
         EgAA==
X-Forwarded-Encrypted: i=1; AJvYcCVXypjs+NtyAolZqHlfdguquwUB0taLAlZieARidoeu8enVJVzhJRgS2NmTF3wMZG2gxHQldvqu6pxdynJZHfYFwThD
X-Gm-Message-State: AOJu0YzVB5JN2zI6ip96rjiRGeXgCbd8YJXEptR6btddzjQyPkJMxYsR
	2Mh5nKrbW58P01d2zJ1Rz0iAB/CFMNhn+ikeiyzUkP2XJFaY2C78NjZLjlOxzlK7ZzaJUJ/8vB3
	wmd95FYb4Jcfv95ChIUHB5oTrWapi17hyAX2j
X-Google-Smtp-Source: AGHT+IFZ9WgzL02erlLgT4OACUR5uu/+x7DQfx8/7vgEmwC6CTrUFy/B1nVWq1p2P76roeiS4xwSGANQ9yKvyy4Xp+Q=
X-Received: by 2002:a05:622a:20c:b0:43e:3833:c5e3 with SMTP id
 d75a77b69052e-44350a5e557mr5052471cf.11.1718643063774; Mon, 17 Jun 2024
 09:51:03 -0700 (PDT)
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
 <ZmxsCwu4uP1lGsWz@google.com> <CADrL8HVDZ+m_-jUCaXf_DWJ92N30oqS=_9wNZwRvoSp5fo7asg@mail.gmail.com>
 <ZmzPoW7K5GIitQ8B@google.com>
In-Reply-To: <ZmzPoW7K5GIitQ8B@google.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 17 Jun 2024 09:50:26 -0700
Message-ID: <CADrL8HW3rZ5xgbyGa+FXk50QQzF4B1=sYL8zhBepj6tg0EiHYA@mail.gmail.com>
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

On Fri, Jun 14, 2024 at 4:17=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Jun 14, 2024, James Houghton wrote:
> > On Fri, Jun 14, 2024 at 9:13=E2=80=AFAM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > On Thu, Jun 13, 2024, James Houghton wrote:
> > > > I wonder if this still makes sense if whether or not an MMU is "fas=
t"
> > > > is determined by how contended some lock(s) are at the time.
> > >
> > > No.  Just because a lock wasn't contended on the initial aging doesn'=
t mean it
> > > won't be contended on the next round.  E.g. when using KVM x86's shad=
ow MMU, which
> > > takes mmu_lock for write for all operations, an aging operation could=
 get lucky
> > > and sneak in while mmu_lock happened to be free, but then get stuck b=
ehind a large
> > > queue of operations.
> > >
> > > The fast-ness needs to be predictable and all but guaranteed, i.e. lo=
ckless or in
> > > an MMU that takes mmu_lock for read in all but the most rare paths.
> >
> > Aging and look-around themselves only use the fast-only notifiers, so
> > they won't ever wait on a lock (well... provided KVM is written like
> > that, which I think is a given).
>
> Regarding aging, is that actually the behavior that we want?  I thought t=
he plan
> is to have the initial test look at all MMUs, i.e. be potentially slow, b=
ut only
> do the lookaround if it can be fast.  IIUC, that was Yu's intent (and pee=
king back
> at v2, that is indeed the case, unless I'm misreading the code).

I believe what I said is correct. There are three separate things going on =
here:

1. Aging (when we hit the low watermark, scan PTEs to find young pages)
2. Eviction (pick a page to evict; if it is definitely not young, evict it)
3. Look-around (upon finding a page is young upon attempted eviction,
check adjacent pages if they are young too)

(1) and (3) both use the fast-only notifier, (2) does not. In v2[1],
this is true, as in the (1) and (3) paths, the notifier being called
is the test_clear_young() notifier with the bitmap present. If the
bitmap is present, the shadow MMU is not consulted.

For (2), there is an mmu_notifier_clear_young() with no bitmap called
in should_look_around(), just like in this v5. (2) is the only one
that needs to use the slow notifier; the (1) and (3) are best-effort
attempts to improve the decision for which pages to evict.

[1]: https://lore.kernel.org/linux-mm/20230526234435.662652-11-yuzhao@googl=
e.com/

>
> If KVM _never_ consults shadow (nested TDP) MMUs, then a VM running an L2=
 will
> end up with hot pages (used by L2) swapped out.

The shadow MMU is consulted at eviction time -- only at eviction time.
So pages used by L2 won't be swapped out unless they're still cold at
eviction time.

In my (and Yu's) head, not being able to do aging for nested TDP is ok
because running nested VMs is much more rare than running non-nested
VMs. And in the non-nested case, being able to do aging is a strict
improvement over what we have now.

We could look into being able to do aging with the shadow MMU, but I
don't think that should necessarily block this series.

> Or are you saying that the "test" could be slow, but not "clear"?  That's=
 also
> suboptimal, because any pages accessed by L2 will always appear hot.

No. I hope what I said above makes sense.

> > should_look_around() will use the slow notifier because it (despite its=
 name)
> > is responsible for accurately determining if a page is young lest we ev=
ict a
> > young page.
> >
> > So in this case where "fast" means "lock not contended for now",
>
> No.  In KVM, "fast" needs to be a property of the MMU, not a reflection o=
f system
> state at some random snapshot in time.

Ok, that's fine with me.

> > I don't think it's necessarily wrong for MGLRU to attempt to find young
> > pages, even if sometimes it will bail out because a lock is contended/h=
eld
>
> lru_gen_look_around() skips lookaround if something else is waiting on th=
e page
> table lock, but that is a far cry from what KVM would be doing.  (a) the =
PTL is
> already held, and (b) it is scoped precisely to the range being processed=
.  Not
> looking around makes sense because there's a high probability of the PTEs=
 in
> question being modified by a different task, i.e. of the look around bein=
g a
> waste of time.
>
> In KVM, mmu_lock is not yet held, so KVM would need to use try-lock to av=
oid
> waiting, and would need to bail from the middle of the aging walk if a di=
fferent
> task contends mmu_lock.
>
> I agree that's not "wrong", but in part because mmu_lock is scoped to the=
 entire
> VM, it risks ending up with semi-random, hard to debug behavior.  E.g. a =
user
> could see intermittent "failures" that come and go based on seemingly unr=
elated
> behavior in KVM.  And implementing the "bail" behavior in the shadow MMU =
would
> require non-trivial changes.

This is a great point, thanks Sean. I won't send any patches that make
other architectures trylock() for the fast notifier.

>
> In other words, I would very strongly prefer that the shadow MMU be all o=
r nothing,
> i.e. is either part of look-around or isn't.  And if nested TDP doesn't f=
air well
> with MGLRU, then we (or whoever cares) can spend the time+effort to make =
it work
> with fast-aging.
>
> Ooh!  Actually, after fiddling a bit to see how feasible fast-aging in th=
e shadow
> MMU would be, I'm pretty sure we can do straight there for nested TDP.  O=
r rather,
> I suspect/hope we can get close enough for an initial merge, which would =
allow
> aging_is_fast to be a property of the mmu_notifier, i.e. would simplify t=
hings
> because KVM wouldn't need to communicate MMU_NOTIFY_WAS_FAST for each not=
ification.
>
> Walking KVM's rmaps requires mmu_lock because adding/removing rmap entrie=
s is done
> in such a way that a lockless walk would be painfully complex.  But if th=
ere is
> exactly _one_ rmap entry for a gfn, then slot->arch.rmap[...] points dire=
ctly at
> that one SPTE.  And with nested TDP, unless L1 is doing something uncommo=
n, e.g.
> mapping the same page into multiple L2s, that overwhelming vast majority =
of rmaps
> have only one entry.  That's not the case for legacy shadow paging becaus=
e kernels
> almost always map a pfn using multiple virtual addresses, e.g. Linux's di=
rect map
> along with any userspace mappings.
>
> E.g. with a QEMU+KVM setup running Linux as L2, in my setup, only one gfn=
 has
> multiple rmap entries (IIRC, it's from QEMU remapping BIOS into low memor=
y during
> boot).
>
> So, if we bifurcate aging behavior based on whether or not the TDP MMU is=
 enabled,
> then whether or not aging is fast is constant (after KVM loads).  Rougly,=
 the KVM
> side of things would be the below, plus a bunch of conversions to WRITE_O=
NCE() to
> ensure a stable rmap value (KVM already plays nice with lockless accesses=
 to SPTEs,
> thanks to the fast page fault path).
>
> If KVM adds an rmap entry after the READ_ONCE(), then functionally all is=
 still
> well because the original SPTE pointer is still valid.  If the rmap entry=
 is
> removed, then KVM just needs to ensure the owning page table isn't freed.=
  That
> could be done either with a cmpxchg() (KVM zaps leafs SPTE before freeing=
 page
> tables, and the rmap stuff doesn't actually walk upper level entries), or=
 by
> enhancing the shadow MMU's lockless walk logic to allow lockless walks fr=
om
> non-vCPU tasks.
>
> And in the (hopefully) unlikely scenario someone has a use case where L1 =
maps a
> gfn into multiple L2s (or aliases in bizarre ways), then we can tackle ma=
king the
> nested TDP shadow MMU rmap walks always lockless.
>
> E.g. again very roughly, if we went with the latter:
>
> @@ -1629,22 +1629,45 @@ static void rmap_add(struct kvm_vcpu *vcpu, const=
 struct kvm_memory_slot *slot,
>         __rmap_add(vcpu->kvm, cache, slot, spte, gfn, access);
>  }
>
> +static __always_inline bool kvm_handle_gfn_range_lockless(struct kvm *kv=
m,
> +                                                         struct kvm_gfn_=
range *range,
> +                                                         typedefme handl=
er)
> +{
> +       gfn_t gfn;
> +       int level;
> +       u64 *spte;
> +       bool ret;
> +
> +       walk_shadow_page_lockless_begin(???);
> +
> +       for (gfn =3D range->start; gfn < range->end; gfn++) {
> +               for (level =3D PG_LEVEL_4K; level <=3D KVM_MAX_HUGEPAGE_L=
EVEL; level++) {
> +                       spte =3D (void *)READ_ONCE(gfn_to_rmap(gfn, level=
, range->slot)->val);
> +
> +                       /* Skip the gfn if there are multiple SPTEs. */
> +                       if ((unsigned long)spte & 1)
> +                               continue;
> +
> +                       ret |=3D handler(spte);
> +               }
> +       }
> +
> +       walk_shadow_page_lockless_end(???);
> +}
> +
>  static int __kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range,
>                          bool fast_only)
>  {
>         bool young =3D false;
>
> -       if (kvm_memslots_have_rmaps(kvm)) {
> -               if (fast_only)
> -                       return -1;
> -
> -               write_lock(&kvm->mmu_lock);
> -               young =3D kvm_handle_gfn_range(kvm, range, kvm_age_rmap);
> -               write_unlock(&kvm->mmu_lock);
> -       }
> -
> -       if (tdp_mmu_enabled)
> +       if (tdp_mmu_enabled) {
>                 young |=3D kvm_tdp_mmu_age_gfn_range(kvm, range);
> +               young |=3D kvm_handle_gfn_range_lockless(kvm, range, kvm_=
age_rmap_fast);
> +       } else if (!fast_only) {
> +               write_lock(&kvm->mmu_lock);
> +               young =3D kvm_handle_gfn_range(kvm, range, kvm_age_rmap);
> +               write_unlock(&kvm->mmu_lock);
> +       }
>
>         return (int)young;
>  }

Hmm, interesting. I need to spend a little bit more time digesting this.

Would you like to see this included in v6? (It'd be nice to avoid the
WAS_FAST stuff....) Should we leave it for a later series? I haven't
formed my own opinion yet.

> > for a few or even a majority of the pages. Not doing look-around is the=
 same
> > as doing look-around and finding that no pages are young.
>
> No, because the former is deterministic and predictable, the latter is no=
t.

Fair enough. I just meant in terms of the end result.

> > Anyway, I don't think this bit is really all that important unless we
> > can demonstrate that KVM participating like this actually results in a
> > measurable win.
>
> Participating like what?  You've lost me a bit.  Are we talking past each=
 other?

Participating in aging and look-around by trylock()ing instead of
being lockless.

All I meant was: it's not important to try to figure out how to get
this non-deterministic trylock()-based "fast" notifier implementation
to work, because I'm not actually suggesting we actually do this.
There was some suggestion previously to make arm64 work like this (in
lieu of a lockless implementation), but I'd need to actually verify
that this performs/behaves well before actually sending a patch.

> What I am saying is that we do this (note that this is slightly different=
 than
> an earlier sketch; I botched the ordering of spin_is_contend() in that on=
e, and
> didn't account for the page being young in the primary MMU).
>
>         if (pte_young(ptep_get(pte)))
>                 young =3D 1 | MMU_NOTIFY_WAS_FAST;
>
>         young |=3D ptep_clear_young_notify(vma, addr, pte);
>         if (!young)
>                 return false;
>
>         if (!(young & MMU_NOTIFY_WAS_FAST))
>                 return true;
>
>         if (spin_is_contended(pvmw->ptl))
>                 return false;
>
>         /* exclude special VMAs containing anon pages from COW */
>         if (vma->vm_flags & VM_SPECIAL)
>                 return false;

SGTM. I think we're on the same page here.

