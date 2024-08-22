Return-Path: <kvm+bounces-24845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D949695BE4F
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 20:36:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F19881C22938
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 18:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B62401D0488;
	Thu, 22 Aug 2024 18:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BAGOHin9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFC9EC5
	for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 18:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724351781; cv=none; b=ARjq1QeK7Hr/bmIARmMSAMevWMou1v4LWY8SnOCOOhj+3LSFkL14GSghr6wTWzqtX3QFbfHdymSDQ/hoLi7nF2lgO37CIQ7z0Q0vJvAdrVc1MfWjiDTnxa0Wf7dYVm/nyTTUUJysWYGVG9Sz87KzvxaXFA3Zb6+Gy+2wAe4UENc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724351781; c=relaxed/simple;
	bh=xDy+Kvz2U7NlljIA+VQ1JqesI5HcHA2l/hqIqK608Rg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R/3b3dkKbwUb0HIPM97YoGtCXmh7ES9ECzBbwMOqz8dRxv/pphXceFGG90Q2SdUnAsfe/JQ8YZIG/uX5BkLcJahkHiG3FUS+YUA/DMmYRfwo5skG4Q/9p5VS5wwBJDbbQep16Sp8QjvP/vzuwEYvSsdoQflt2p8YmECu3p89O5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BAGOHin9; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-428e1915e18so8303125e9.1
        for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 11:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724351778; x=1724956578; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mRElqtyOiIYL8sHijuf/R8kIU/ip5LuNHtrzgNlP81c=;
        b=BAGOHin9k+o8Fd76PynwWcEKeYpF5VHSypdpJLjwDHi2le3+lJ8aWT2uI34IpFUFnQ
         s665eStBuREcdZSF2wYNpTYeIZsT464LpzI3ujybNHlGRhs9Fx6cYMgy8fBZNGclfbSz
         xlzn1U6LPPLDFWC8ZPjVNNhrzyEBWp/qtpCoiCfb01hk3hiz3Ly9jLa1gNdRJhGr+XeP
         uK4LSXCRQIHlUZ9TC8VeVtzuTlxfRxWvQaKLd3c1378GdMMhHKyvOWJnKO6X/JP87ug/
         yol9Bh/sNd0L/m5q7WV6VgaX27IFLhyUQDo1DcoFGxhX+6JWjoAdRiIAZYpqFWctOrnd
         fMZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724351778; x=1724956578;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mRElqtyOiIYL8sHijuf/R8kIU/ip5LuNHtrzgNlP81c=;
        b=WmsdHsRYOopdft00JRo/O1Rz0jInkcIw18+UXTR8p302aNEu8cS7bJn/lxPST3hLAb
         0ssP50b2sK34z3LRkGgf0hJ8C7ECoXBv9q9t9fMS/BcrAmIZCRVWKR3LV6BQxkJQqyMk
         4zCr5Koz5xpE1c7cM2bLtwZCKZcr8duUoRF671s31rMOGhLfq7QoOqzLwOOSsL2RyV6W
         FMfVmxrxan81gpZkW/ofGahlLcJg5xKfqFzZf4GJq49cFIsRITdkrDEvmggv3YG0fM78
         3EDevy+Lkxht2+tsXNroeMvUxCwkbyxeYMfhzwqY74OHWaBTR7Qf7dnGx9YvGyHLwzZQ
         e5SA==
X-Forwarded-Encrypted: i=1; AJvYcCUauxFNVMeBIm8GT+3495mvmbT/+PycdyQbYEr4WR08bWXzt1FZ2XGsOqvkjfiW4HtiUFk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxE0Z5tKGBflbCwSh4Yt2KxPWgiNkDWQbMx7/Io8WBGER2NFs/p
	R7v7mWEwRuTw/6ed3pzupqI8zR0NEowurXbKaoWIXqob6n8fAzbdhavUUifuffd293EBT07Znkc
	73zgsUGoGryfivy7L3Xzr9ctFAK3GQgKn2K1J+sO/B9GuO/mK0x5p
X-Google-Smtp-Source: AGHT+IEdKI70eC9WjL7QJWk0FGoU6j7rLuWoZTj2ROzez62ctIB1qTCz9b0nhgQtSN4+RSJl8d9t2N+yEeNr9ZNN1xM=
X-Received: by 2002:a05:6000:e4b:b0:371:890c:9b64 with SMTP id
 ffacd0b85a97d-3730905e387mr1699248f8f.59.1724351777908; Thu, 22 Aug 2024
 11:36:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240805233114.4060019-1-dmatlack@google.com> <20240805233114.4060019-8-dmatlack@google.com>
 <ZsdsOpWnZY47J5sU@google.com>
In-Reply-To: <ZsdsOpWnZY47J5sU@google.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 22 Aug 2024 11:35:49 -0700
Message-ID: <CALzav=d18V=T=QVbOtiLG1Y7rmG-8B31gdjnbrfGkzC2k3FPVQ@mail.gmail.com>
Subject: Re: [PATCH 7/7] KVM: x86/mmu: Recheck SPTE points to a PT during huge
 page recovery
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 22, 2024 at 9:50=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Aug 05, 2024, David Matlack wrote:
> > Recheck the iter.old_spte still points to a page table when recovering
> > huge pages. Since mmu_lock is held for read and tdp_iter_step_up()
> > re-reads iter.sptep, it's possible the SPTE was zapped or recovered by
> > another CPU in between stepping down and back up.
> >
> > This could avoids a useless cmpxchg (and possibly a remote TLB flush) i=
f
> > another CPU is recovering huge SPTEs in parallel (e.g. the NX huge page
> > recovery worker, or vCPUs taking faults on the huge page region).
> >
> > This also makes it clear that tdp_iter_step_up() re-reads the SPTE and
> > thus can see a different value, which is not immediately obvious when
> > reading the code.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 07d5363c9db7..bdc7fd476721 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -1619,6 +1619,17 @@ static void recover_huge_pages_range(struct kvm =
*kvm,
> >               while (max_mapping_level > iter.level)
> >                       tdp_iter_step_up(&iter);
> >
> > +             /*
> > +              * Re-check that iter.old_spte still points to a page tab=
le.
> > +              * Since mmu_lock is held for read and tdp_iter_step_up()
> > +              * re-reads iter.sptep, it's possible the SPTE was zapped=
 or
> > +              * recovered by another CPU in between stepping down and
> > +              * stepping back up.
> > +              */
> > +             if (!is_shadow_present_pte(iter.old_spte) ||
> > +                 is_last_spte(iter.old_spte, iter.level))
> > +                     continue;
>
> This is the part of the step-up logic that I do not like.  Even this chec=
k doesn't
> guarantee that the SPTE that is being replaced is the same non-leaf SPTE =
that was
> used to reach the leaf SPTE.  E.g. in an absurdly theoretical situation, =
the SPTE
> could be zapped and then re-set with another non-leaf SPTE.  Which is fin=
e, but
> only because of several very subtle mechanisms.

I'm not sure why that matters. The only thing that matters is that the
GFN->PFN and permissions cannot change, and that is guaranteed by
holding mmu_lock for read.

At the end of the day, we never actually care about the value of the
SPTE we are replacing. We only care that it's a non-leaf SPTE.

>
> kvm_mmu_max_mapping_level() ensures that there are no write-tracked gfns =
anywhere
> in the huge range, so it's safe to propagate any and all WRITABLE bits.  =
This
> requires knowing/remembering that KVM disallows huge pages when a gfn is =
write-
> tracked, and relies on that never changing (which is a fairly safe bet, b=
ut the
> behavior isn't fully set in stone).
> not set.
>
> And the presence of a shadow-present leaf SPTE ensures there are no in-fl=
ight
> mmu_notifier invalidations, as kvm_mmu_notifier_invalidate_range_start() =
won't
> return until all relevant leaf SPTEs have been zapped.

As you point out in the next paragraph there could be an inflight
invalidate that yielded, no?

>
> And even more subtly, recover_huge_pages_range() can install a huge SPTE =
while
> tdp_mmu_zap_leafs() is running, e.g. if tdp_mmu_zap_leafs() is processing=
 4KiB
> SPTEs because the greater 2MiB page is being unmapped by the primary MMU,=
 and
> tdp_mmu_zap_leafs() yields.   That's again safe only because upon regaini=
ng
> control, tdp_mmu_zap_leafs() will restart at the root and thus observe an=
d zap
> the new huge SPTE.

I agree it's subtle, but only in the sense that the TDP MMU is subtle.
Restarting at the root after dropping mmu_lock is a fundamental
concept in the TDP MMU.

>
> So while I'm pretty sure this logic is functionally ok, its safety is ext=
remely
> dependent on a number of behaviors in KVM.
>
> That said, I can't tell which option I dislike less.  E.g. we could do so=
mething
> like this, where kvm_mmu_name_tbd() grabs the pfn+writable information fr=
om the
> primary MMU's PTE/PMD/PUD.  Ideally, KVM would use GUP, but then KVM woul=
dn't
> be able to create huge SPTEs for non-GUP-able memory, e.g. PFNMAP'd memor=
y.
>
> I don't love this either, primarily because not using GUP makes this yet =
another
> custom flow

Yeah. I don't like having the huge page recovery path needing its own
special way to construct SPTEs from scratch. e.g. I could see this
approach becoming a problem if KVM gains support for R/W/X GFN
attributes.

> i.e. isn't any less tricky than reusing a child SPTE.  It does have
> the advantage of not having to find a shadow-present child though, i.e. i=
s likely
> the most performant option.  I agree that that likely doesn't matter in p=
ractice,
> especially since the raw latency of disabling dirty logging isn't terribl=
y
> important.
>
>         rcu_read_lock();
>
>         for_each_tdp_pte_min_level(iter, root, PG_LEVEL_2M, start, end) {
> retry:
>                 if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
>                         continue;
>
>                 if (iter.level > KVM_MAX_HUGEPAGE_LEVEL ||
>                     !is_shadow_present_pte(iter.old_spte))
>                         continue;
>
>                 /*
>                  * TODO: this should skip to the end of the parent, becau=
se if
>                  * the first SPTE can't be made huger, then no SPTEs at t=
his
>                  * level can be huger.
>                  */
>                 if (is_last_spte(iter.old_spte, iter.level))
>                         continue;
>
>                 /*
>                  * If iter.gfn resides outside of the slot, i.e. the page=
 for
>                  * the current level overlaps but is not contained by the=
 slot,
>                  * then the SPTE can't be made huge.  More importantly, t=
rying
>                  * to query that info from slot->arch.lpage_info will cau=
se an
>                  * out-of-bounds access.
>                  */
>                 if (iter.gfn < start || iter.gfn >=3D end)
>                         continue;
>
>                 if (kvm_mmu_name_tbd(kvm, slot, iter.gfn, &pfn, &writable=
,
>                                      &max_mapping_level))
>                         continue;
>
>                 /*
>                  * If the range is being invalidated, do not install a SP=
TE as
>                  * KVM may have already zapped this specific gfn, e.g. if=
 KVM's
>                  * unmapping has run to completion, but the primary MMU h=
asn't
>                  * zapped its PTEs.  There is no need to check for *past*
>                  * invalidations, because all information is gathered whi=
le
>                  * holding mmu_lock, i.e. it can't have become stale due =
to a
>                  * entire mmu_notifier invalidation sequence completing.
>                  */
>                 if (mmu_invalidate_retry_gfn(kvm, kvm->mmu_invalidate_seq=
, iter.gfn))
>                         continue;
>
>                 /*
>                  * KVM disallows huge pages for write-protected gfns, it =
should
>                  * impossible for make_spte() to encounter such a gfn sin=
ce
>                  * write-protecting a gfn requires holding mmu_lock for w=
rite.
>                  */
>                 flush |=3D __tdp_mmu_map_gfn(...);
>                 WARN_ON_ONCE(r =3D=3D RET_PF_EMULATE);
>         }
>
>         rcu_read_unlock();
>
> Assuming you don't like the above idea (I'm not sure I do), what if inste=
ad of
> doing the step-up, KVM starts a second iteration using the shadow page it=
 wants
> to replace as the root of the walk?
>
> This has the same subtle dependencies on kvm_mmu_max_mapping_level() and =
the
> ordering with respect to an mmu_notifier invalidation, but it at least av=
oids
> having to reason about the correctness of re-reading a SPTE and modifying=
 the
> iteration level within the body of an interation loop.
>
> It should also yield smaller diffs overall, e.g. no revert, no separate c=
ommit
> to recheck the SPTE, etc.  And I believe it's more performant that the st=
ep-up
> approach when there are SPTE that _can't_ be huge, as KVM won't traverse =
down
> into the leafs in that case.

This approach looks good to me. I'll try it out and see if I run into
any issues.

>
> An alternative to the tdp_mmu_iter_needs_reched() logic would be to pass =
in
> &flush, but I think that ends up being more confusing and harder to follo=
w.

Yeah I think that would be more complicated. If we drop mmu_lock then
we need to re-check kvm_mmu_max_mapping_level() and restart at the
root.

>
> static int tdp_mmu_make_huge_spte(struct kvm *kvm, struct tdp_iter *paren=
t,
>                                   u64 *huge_spte)
> {
>         struct kvm_mmu_page *root =3D sptep_to_sp(parent->sptep);
>         gfn_t start =3D parent->gfn;
>         gfn_t end =3D start + ???; /* use parent's level */
>         struct tdp_iter iter;
>
>         tdp_root_for_each_leaf_pte(iter, root, start, end)      {
>                 /*
>                  * Use the parent iterator when checking for forward prog=
ress,
>                  * so that KVM doesn't get stuck due to always yielding w=
hile
>                  * walking child SPTEs.
>                  */
>                 if (tdp_mmu_iter_needs_reched(kvm, parent))
>                         return -EAGAIN;
>
>                 *huge_spte =3D make_huge_spte(kvm, iter.old_spte);
>                 return 0;
>         }
>
>         return -ENOENT;
> }
>
> static void recover_huge_pages_range(struct kvm *kvm,
>                                      struct kvm_mmu_page *root,
>                                      const struct kvm_memory_slot *slot)
> {
>         gfn_t start =3D slot->base_gfn;
>         gfn_t end =3D start + slot->npages;
>         struct tdp_iter iter;
>         int max_mapping_level;
>         bool flush =3D false;
>         u64 huge_spte;
>
>         if (WARN_ON_ONCE(kvm_slot_dirty_track_enabled(slot)))
>                 return;
>
>         rcu_read_lock();
>
>         for_each_tdp_pte_min_level(iter, root, PG_LEVEL_2M, start, end) {
> restart:
>                 if (tdp_mmu_iter_cond_resched(kvm, &iter, flush, true)) {
>                         flush =3D false;
>                         continue;
>                 }
>
>                 if (iter.level > KVM_MAX_HUGEPAGE_LEVEL ||
>                     !is_shadow_present_pte(iter.old_spte))
>                         continue;
>
>                 /*
>                  * If iter.gfn resides outside of the slot, i.e. the page=
 for
>                  * the current level overlaps but is not contained by the=
 slot,
>                  * then the SPTE can't be made huge.  More importantly, t=
rying
>                  * to query that info from slot->arch.lpage_info will cau=
se an
>                  * out-of-bounds access.
>                  */
>                 if (iter.gfn < start || iter.gfn >=3D end)
>                         continue;
>
>                 max_mapping_level =3D kvm_mmu_max_mapping_level(kvm, slot=
, iter.gfn);
>                 if (max_mapping_level < iter.level)
>                         continue;
>
>                 r =3D tdp_mmu_make_huge_spte(kvm, &iter, &huge_spte);
>                 if (r =3D=3D -EAGAIN)
>                         goto restart;
>                 else if (r)
>                         continue;
>
>                 /*
>                  * If setting the SPTE fails, e.g. because it has been mo=
dified
>                  * by a different task, iteration will naturally continue=
 with
>                  * the next SPTE.  Don't bother retrying this SPTE, races=
 are
>                  * uncommon and odds are good the SPTE
>                  */
>                 if (!tdp_mmu_set_spte_atomic(kvm, &iter, huge_spte))
>                         flush =3D true;
>         }
>
>         if (flush)
>                 kvm_flush_remote_tlbs_memslot(kvm, slot);
>
>         rcu_read_unlock();
> }
>
> static inline bool tdp_mmu_iter_needs_reched(struct kvm *kvm,
>                                              struct tdp_iter *iter)
> {
>         /* Ensure forward progress has been made before yielding. */
>         return iter->next_last_level_gfn !=3D iter->yielded_gfn &&
>                (need_resched() || rwlock_needbreak(&kvm->mmu_lock));
>
> }
>
> /*
>  * Yield if the MMU lock is contended or this thread needs to return cont=
rol
>  * to the scheduler.
>  *
>  * If this function should yield and flush is set, it will perform a remo=
te
>  * TLB flush before yielding.
>  *
>  * If this function yields, iter->yielded is set and the caller must skip=
 to
>  * the next iteration, where tdp_iter_next() will reset the tdp_iter's wa=
lk
>  * over the paging structures to allow the iterator to continue its trave=
rsal
>  * from the paging structure root.
>  *
>  * Returns true if this function yielded.
>  */
> static inline bool __must_check tdp_mmu_iter_cond_resched(struct kvm *kvm=
,
>                                                           struct tdp_iter=
 *iter,
>                                                           bool flush, boo=
l shared)
> {
>         WARN_ON_ONCE(iter->yielded);
>
>         if (!tdp_mmu_iter_needs_reched(kvm, iter))
>                 return false;
>
>         if (flush)
>                 kvm_flush_remote_tlbs(kvm);
>
>         rcu_read_unlock();
>
>         if (shared)
>                 cond_resched_rwlock_read(&kvm->mmu_lock);
>         else
>                 cond_resched_rwlock_write(&kvm->mmu_lock);
>
>         rcu_read_lock();
>
>         WARN_ON_ONCE(iter->gfn > iter->next_last_level_gfn);
>
>         iter->yielded =3D true;
>         return true;
> }

