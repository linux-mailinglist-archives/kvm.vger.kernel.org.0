Return-Path: <kvm+bounces-25423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DD1CB96540B
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 02:35:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D2B31C2215A
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 00:35:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D0304A32;
	Fri, 30 Aug 2024 00:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RWpeC0tI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9000B20EB
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 00:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724978140; cv=none; b=HB58FNeYS+bNcFqjgvKREe493JZXyYDY5X1ZOqV1xvT9lDTXCDcjhBDQfzoYsqMJsV90VKiCFZdMGCHKOeFpjhKmjrZz2C6iG5SarbjfrblYfu2E4d4HXSf0D4iEPAeFQrI+3jYGpw43D9e3oVz3kv9e1MlbZ2KsD/Rspg7Oagk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724978140; c=relaxed/simple;
	bh=naxGprowjEdjnmJ251fm+t/J3r2TO8+VD4wY+E/O1Ws=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=in+mhpWr8lzerZB5r0DXC3Gkq+t8y5ge2MZv1M3FaKZ3ZPyC7JmWGZsxkbNbUeioxtXUmZtLx1XOI9NTRlDuF0uRVnylJTILnx0IBGRe9YpCOjvRy53iLjUlkJ2mioJ6LWLXib0odxHhHoMuVYwyvLMHQOm4JkBO59rN90ub2WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RWpeC0tI; arc=none smtp.client-ip=209.85.219.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-e1659e9a982so1294309276.1
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 17:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724978137; x=1725582937; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+TNka9vd5JXf53shoZJCdocIPoVkda4RXWlcGSY44+M=;
        b=RWpeC0tItDzd1SjuEK1LeoSkHzXBgcZ1ngTqS5L7Ic8TT0XQ+I/bo9pqtwfMR3lO75
         CS1WUkK8JRjvMl4pBnDPmmVfkOCjeRv7DNcXwLNEvBpBRj8nyly+L/SJ5OdaDvLsh5sz
         jf1QRUZe9VrhXuq8lXw/3yRQdf0ndhS0CJfDIi2QJJxw6vYjQc6Ww+v+92r4tm8urIlc
         HrbLgZXJvDM99uA/QkkRe96mnLtlcg3fbXKqBZh/R7RzhwixN9UNV/SnTf4QadDm5APi
         bbRn9nnOz9rKv3ZEDn9I0Hie8K5ILVvldcstKQv8c4FTyuAmCsj/Db8PVuKTPFoACm/p
         eqxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724978137; x=1725582937;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+TNka9vd5JXf53shoZJCdocIPoVkda4RXWlcGSY44+M=;
        b=pxE8+uJzEyw6pDSPjNz6FoSiI4w+mugg3CquZryWew01Mp5C6qZPQKEXNIKrqjxyxS
         9dGQZglMaoOgalTtYBoHUmBYYVWeApSw7P1OUVrEqgGGWQli5yQ0o6AgAk2E8TPDHEav
         kueLPMdv0os1wr9UJ79/oTxIzo9vdAfMrLEPEUWujDa/RzU2XxR7FQZ8+8DyxT0s9h64
         SP21mDEwfHZzctf6hTpyD0Mw7aHqWNkzTzPIxeoSiMWfAkRx/3+qQTBctuNio6TDlNIX
         Vu21CVoBlulcaxCk3wob4EuOXJ/NTN7xwvQz90hJSq5XqasODZiuGH9F1PBfQ2ckfH0w
         zAYg==
X-Forwarded-Encrypted: i=1; AJvYcCWoEE438nm+1Yj1cCoJzhv7dfBv16EJx9D26ePlfW7zsiu0YwPg3lNxaPIEMJFIeGWeFr8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYp7vGb+vXvu6XHOwQNeajQ7cne3wOCl5izyIzxz9rXbG1RQoV
	GIrC95J14qTYotywg4+oDXb3gTAtVE4+NWj/uIDOrRPNj8W3a+jn5FG+5Jl48+VnGZQa7dnXF+9
	dsyt2xI82MdCYI5a0uNKrZvuaGv+1ot2vRT9W
X-Google-Smtp-Source: AGHT+IHGGoRCfmvp4fUpMCFvBy1BBzHFHrDm0larnXWV+XPd8x/YAfZRmgba0cFiXNndcnOr0sPomBSZ5ocJlkYWUy4=
X-Received: by 2002:a05:6902:1584:b0:e16:6c41:1601 with SMTP id
 3f1490d57ef6-e1a7a15de23mr625233276.33.1724978137240; Thu, 29 Aug 2024
 17:35:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-3-jthoughton@google.com> <Zr_3Vohvzt0KmFiN@google.com>
In-Reply-To: <Zr_3Vohvzt0KmFiN@google.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 29 Aug 2024 17:35:01 -0700
Message-ID: <CADrL8HWQqVm5VbNnR6iMEZF17+nuO_Y25m6uuScCBVSE_YCTdg@mail.gmail.com>
Subject: Re: [PATCH v6 02/11] KVM: x86: Relax locking for kvm_test_age_gfn and kvm_age_gfn
To: Sean Christopherson <seanjc@google.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 16, 2024 at 6:05=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, Jul 24, 2024, James Houghton wrote:
> > Walk the TDP MMU in an RCU read-side critical section.
>
> ...without holding mmu_lock, while doing xxx.  There are a lot of TDP MMU=
 walks,
> pand they all need RCU protection.

Added "without holding mmu_lock when harvesting and potentially
updating age information on sptes".

> > This requires a way to do RCU-safe walking of the tdp_mmu_roots; do thi=
s with
> > a new macro. The PTE modifications are now done atomically, and
> > kvm_tdp_mmu_spte_need_atomic_write() has been updated to account for th=
e fact
> > that kvm_age_gfn can now lockless update the accessed bit and the R/X b=
its).
> >
> > If the cmpxchg for marking the spte for access tracking fails, we simpl=
y
> > retry if the spte is still a leaf PTE. If it isn't, we return false
> > to continue the walk.
>
> Please avoid pronouns.  E.g. s/we/KVM (and adjust grammar as needed), so =
that
> it's clear what actor in particular is doing the retry.

Fixed. Though, I have also changed this to reflect the change in the
retry logic I've made, given your other comment.

> > Harvesting age information from the shadow MMU is still done while
> > holding the MMU write lock.
> >
> > Suggested-by: Yu Zhao <yuzhao@google.com>
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  1 +
> >  arch/x86/kvm/Kconfig            |  1 +
> >  arch/x86/kvm/mmu/mmu.c          | 10 ++++-
> >  arch/x86/kvm/mmu/tdp_iter.h     | 27 +++++++------
> >  arch/x86/kvm/mmu/tdp_mmu.c      | 67 +++++++++++++++++++++++++--------
> >  5 files changed, 77 insertions(+), 29 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> > index 950a03e0181e..096988262005 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1456,6 +1456,7 @@ struct kvm_arch {
> >        * tdp_mmu_page set.
> >        *
> >        * For reads, this list is protected by:
> > +      *      RCU alone or
> >        *      the MMU lock in read mode + RCU or
> >        *      the MMU lock in write mode
> >        *
> > diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> > index 4287a8071a3a..6ac43074c5e9 100644
> > --- a/arch/x86/kvm/Kconfig
> > +++ b/arch/x86/kvm/Kconfig
> > @@ -23,6 +23,7 @@ config KVM
> >       depends on X86_LOCAL_APIC
> >       select KVM_COMMON
> >       select KVM_GENERIC_MMU_NOTIFIER
> > +     select KVM_MMU_NOTIFIER_YOUNG_LOCKLESS
> >       select HAVE_KVM_IRQCHIP
> >       select HAVE_KVM_PFNCACHE
> >       select HAVE_KVM_DIRTY_RING_TSO
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 901be9e420a4..7b93ce8f0680 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1633,8 +1633,11 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn=
_range *range)
> >  {
> >       bool young =3D false;
> >
> > -     if (kvm_memslots_have_rmaps(kvm))
> > +     if (kvm_memslots_have_rmaps(kvm)) {
> > +             write_lock(&kvm->mmu_lock);
> >               young =3D kvm_handle_gfn_range(kvm, range, kvm_age_rmap);
> > +             write_unlock(&kvm->mmu_lock);
> > +     }
> >
> >       if (tdp_mmu_enabled)
> >               young |=3D kvm_tdp_mmu_age_gfn_range(kvm, range);
> > @@ -1646,8 +1649,11 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kv=
m_gfn_range *range)
> >  {
> >       bool young =3D false;
> >
> > -     if (kvm_memslots_have_rmaps(kvm))
> > +     if (kvm_memslots_have_rmaps(kvm)) {
> > +             write_lock(&kvm->mmu_lock);
> >               young =3D kvm_handle_gfn_range(kvm, range, kvm_test_age_r=
map);
> > +             write_unlock(&kvm->mmu_lock);
> > +     }
> >
> >       if (tdp_mmu_enabled)
> >               young |=3D kvm_tdp_mmu_test_age_gfn(kvm, range);
> > diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
> > index 2880fd392e0c..510936a8455a 100644
> > --- a/arch/x86/kvm/mmu/tdp_iter.h
> > +++ b/arch/x86/kvm/mmu/tdp_iter.h
> > @@ -25,6 +25,13 @@ static inline u64 kvm_tdp_mmu_write_spte_atomic(tdp_=
ptep_t sptep, u64 new_spte)
> >       return xchg(rcu_dereference(sptep), new_spte);
> >  }
> >
> > +static inline u64 tdp_mmu_clear_spte_bits_atomic(tdp_ptep_t sptep, u64=
 mask)
> > +{
> > +     atomic64_t *sptep_atomic =3D (atomic64_t *)rcu_dereference(sptep)=
;
> > +
> > +     return (u64)atomic64_fetch_and(~mask, sptep_atomic);
> > +}
> > +
> >  static inline void __kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 new_=
spte)
> >  {
> >       KVM_MMU_WARN_ON(is_ept_ve_possible(new_spte));
> > @@ -32,10 +39,11 @@ static inline void __kvm_tdp_mmu_write_spte(tdp_pte=
p_t sptep, u64 new_spte)
> >  }
> >
> >  /*
> > - * SPTEs must be modified atomically if they are shadow-present, leaf
> > - * SPTEs, and have volatile bits, i.e. has bits that can be set outsid=
e
> > - * of mmu_lock.  The Writable bit can be set by KVM's fast page fault
> > - * handler, and Accessed and Dirty bits can be set by the CPU.
> > + * SPTEs must be modified atomically if they have bits that can be set=
 outside
> > + * of the mmu_lock. This can happen for any shadow-present leaf SPTEs,=
 as the
> > + * Writable bit can be set by KVM's fast page fault handler, the Acces=
sed and
> > + * Dirty bits can be set by the CPU, and the Accessed and R/X bits can=
 be
> > + * cleared by age_gfn_range.
> >   *
> >   * Note, non-leaf SPTEs do have Accessed bits and those bits are
> >   * technically volatile, but KVM doesn't consume the Accessed bit of
> > @@ -46,8 +54,7 @@ static inline void __kvm_tdp_mmu_write_spte(tdp_ptep_=
t sptep, u64 new_spte)
> >  static inline bool kvm_tdp_mmu_spte_need_atomic_write(u64 old_spte, in=
t level)
> >  {
> >       return is_shadow_present_pte(old_spte) &&
> > -            is_last_spte(old_spte, level) &&
> > -            spte_has_volatile_bits(old_spte);
> > +            is_last_spte(old_spte, level);
> >  }
> >
> >  static inline u64 kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 old_spt=
e,
> > @@ -63,12 +70,8 @@ static inline u64 kvm_tdp_mmu_write_spte(tdp_ptep_t =
sptep, u64 old_spte,
> >  static inline u64 tdp_mmu_clear_spte_bits(tdp_ptep_t sptep, u64 old_sp=
te,
> >                                         u64 mask, int level)
> >  {
> > -     atomic64_t *sptep_atomic;
> > -
> > -     if (kvm_tdp_mmu_spte_need_atomic_write(old_spte, level)) {
> > -             sptep_atomic =3D (atomic64_t *)rcu_dereference(sptep);
> > -             return (u64)atomic64_fetch_and(~mask, sptep_atomic);
> > -     }
> > +     if (kvm_tdp_mmu_spte_need_atomic_write(old_spte, level))
> > +             return tdp_mmu_clear_spte_bits_atomic(sptep, mask);
> >
> >       __kvm_tdp_mmu_write_spte(sptep, old_spte & ~mask);
> >       return old_spte;
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index c7dc49ee7388..3f13b2db53de 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -29,6 +29,11 @@ static __always_inline bool kvm_lockdep_assert_mmu_l=
ock_held(struct kvm *kvm,
> >
> >       return true;
> >  }
> > +static __always_inline bool kvm_lockdep_assert_rcu_read_lock_held(void=
)
> > +{
> > +     WARN_ON_ONCE(!rcu_read_lock_held());
> > +     return true;
> > +}
>
> I doubt KVM needs a manual WARN, the RCU deference stuff should yell loud=
ly if
> something is missing an rcu_read_lock().

You're right -- removed.

> >  void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
> >  {
> > @@ -178,6 +183,15 @@ static struct kvm_mmu_page *tdp_mmu_next_root(stru=
ct kvm *kvm,
> >                    ((_only_valid) && (_root)->role.invalid))) {        =
       \
> >               } else
> >
> > +/*
> > + * Iterate over all TDP MMU roots in an RCU read-side critical section=
.
> > + */
> > +#define for_each_tdp_mmu_root_rcu(_kvm, _root, _as_id)                =
               \
> > +     list_for_each_entry_rcu(_root, &_kvm->arch.tdp_mmu_roots, link)  =
       \
>
> This should just process valid roots:
>
> https://lore.kernel.org/all/20240801183453.57199-7-seanjc@google.com

Thanks! I've added `|| (_root)->role.invalid)` to the below
conditional expression, and I've renamed the macro to
for_each_valid_tdp_mmu_root_rcu.

> > +             if (kvm_lockdep_assert_rcu_read_lock_held() &&           =
       \
> > +                 (_as_id >=3D 0 && kvm_mmu_page_as_id(_root) !=3D _as_=
id)) {     \
> > +             } else
> > +
> >  #define for_each_tdp_mmu_root(_kvm, _root, _as_id)                   \
> >       __for_each_tdp_mmu_root(_kvm, _root, _as_id, false)
> >
> > @@ -1224,6 +1238,27 @@ static __always_inline bool kvm_tdp_mmu_handle_g=
fn(struct kvm *kvm,
> >       return ret;
> >  }
> >
> > +static __always_inline bool kvm_tdp_mmu_handle_gfn_lockless(
> > +             struct kvm *kvm,
> > +             struct kvm_gfn_range *range,
> > +             tdp_handler_t handler)
>
> Please burn all the Google3 from your brain, and code ;-)

I indented this way to avoid going past the 80 character limit. I've
adjusted it to be more like the other functions in this file.

Perhaps I should put `static __always_inline bool` on its own line?

>
> > +     struct kvm_mmu_page *root;
> > +     struct tdp_iter iter;
> > +     bool ret =3D false;
> > +
> > +     rcu_read_lock();
> > +
> > +     for_each_tdp_mmu_root_rcu(kvm, root, range->slot->as_id) {
> > +             tdp_root_for_each_leaf_pte(iter, root, range->start, rang=
e->end)
> > +                     ret |=3D handler(kvm, &iter, range);
> > +     }
> > +
> > +     rcu_read_unlock();
> > +
> > +     return ret;
> > +}
> > +
> >  /*
> >   * Mark the SPTEs range of GFNs [start, end) unaccessed and return non=
-zero
> >   * if any of the GFNs in the range have been accessed.
> > @@ -1237,28 +1272,30 @@ static bool age_gfn_range(struct kvm *kvm, stru=
ct tdp_iter *iter,
> >  {
> >       u64 new_spte;
> >
> > +retry:
> >       /* If we have a non-accessed entry we don't need to change the pt=
e. */
> >       if (!is_accessed_spte(iter->old_spte))
> >               return false;
> >
> >       if (spte_ad_enabled(iter->old_spte)) {
> > -             iter->old_spte =3D tdp_mmu_clear_spte_bits(iter->sptep,
> > -                                                      iter->old_spte,
> > -                                                      shadow_accessed_=
mask,
> > -                                                      iter->level);
> > +             iter->old_spte =3D tdp_mmu_clear_spte_bits_atomic(iter->s=
ptep,
> > +                                             shadow_accessed_mask);
> >               new_spte =3D iter->old_spte & ~shadow_accessed_mask;
> >       } else {
> > -             /*
> > -              * Capture the dirty status of the page, so that it doesn=
't get
> > -              * lost when the SPTE is marked for access tracking.
> > -              */
> > +             new_spte =3D mark_spte_for_access_track(iter->old_spte);
> > +             if (__tdp_mmu_set_spte_atomic(iter, new_spte)) {
> > +                     /*
> > +                      * The cmpxchg failed. If the spte is still a
> > +                      * last-level spte, we can safely retry.
> > +                      */
> > +                     if (is_shadow_present_pte(iter->old_spte) &&
> > +                         is_last_spte(iter->old_spte, iter->level))
> > +                             goto retry;
>
> Do we have a feel for how often conflicts actually happen?  I.e. is it wo=
rth
> retrying and having to worry about infinite loops, however improbable the=
y may
> be?

I'm not sure how common this is. I think it's probably better not to
retry actually. If the cmpxchg fails, this spte is probably young
anyway, so I can just `return true` instead of potentially retrying.
This is all best-effort anyway.

