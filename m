Return-Path: <kvm+bounces-37469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3707BA2A519
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 10:49:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77D3F3A2512
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 09:49:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C52A322652D;
	Thu,  6 Feb 2025 09:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="foyTX8Ju"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7832040B5
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 09:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738835383; cv=none; b=c5mMpPBiiBNT75zX39qbxKDBZF8c5EGOCgh3CdOVwaoNjsr3MnPli7xJMDi2vAeUs4caYSMAPM+af8twNkBkhjC8Aumt9E1vdLq7NNPSQiT8Hld96GC9k5rZgeAFO7mthUVbJsQLpAL8oNpwCwuwxp35VDuyMGbyqxM5uIH8DBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738835383; c=relaxed/simple;
	bh=Tey3Pm/24OpqMv2mAqjb7nG+Py0i5d53tLaznXL9Svo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O334ab8OO8d0c5IMjktygE6EsLCcVcW8yWkyHqJZ5ibmf5rAcHBT3knLzMxHafs1/pbeEJ43F3fxs+U5typx8dVzK0NI24Ie6SC2u83AiFvWhqLuWtYqzI+0tqKSmC9/1gfK7W916phykAIeYmAH4qdyiBNKCKfRe8sX4Ci3an4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=foyTX8Ju; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4679b5c66d0so133991cf.1
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2025 01:49:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738835378; x=1739440178; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vMspzqIoxWrtTD4RwkkteSffyt0ubH7EbrNEdQKzrTo=;
        b=foyTX8JuQVx5tI0FZDqtk7U4KI7p/ii5kfZCNso1pxnRyOpCje2TkIj/f00tSuS3e2
         siVmf4sDjFMIeNk6aG+Sys0qwSXPz5cEo+MgkiKe1sfA0nmCfDmX6bpqTkPetFTe1GaT
         gv215AqNHDlkaNYXpiumBY9P5s3Ur29oLYzK6MscaeAWK7/RBCw8PwZAkyA7uLnR5I3i
         B1HkZDycHPycU05EItv+MrkviFDC5J/Iy91o0FAMmJjPtsoTp4aYUNuwd52yj+ivxJo/
         tKXtzceyr0+XSUgIhfWtm4P5+y0wX8/N+Uh2Xz4fmvIV0jvXCilsAv5Jl5QNcW92YO6A
         +c9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738835378; x=1739440178;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vMspzqIoxWrtTD4RwkkteSffyt0ubH7EbrNEdQKzrTo=;
        b=lO+hiyNXkJ9nKNiNHbSoHdA+jzB+thZtfn+TUQOQLR4ytl2Bhu8jrgx1VZ933eQL+p
         oosBRAL5R1FvHEqjVM3z3kLH9G02ysUZ/VOsUz28iBZQ8SC7bCodMtZt336goirSI+k3
         m5myE31CnS84iD2gAyNKghlhLPYnWCmBvla7PyA/46zh6X/Zhdn4pMc4iB8tRv2MrpCg
         Uj8LtjKDUGuIdbCNPayM/jexOAKaStiG6UWxcefWNUj5916aVAQjPl8Pxja+KDUcai8n
         D8P5pKxTGQE0f4pvD8frjlhGba/6Ut3NA4m99MSx2CQhFxG43FdlwMjtrW0IPKX2a3Rd
         Fgvw==
X-Gm-Message-State: AOJu0YwnmLIK9KS2wHsXP1MJlI87q9GvuXwUtHBBhFneVtiB1UpNtZT+
	1ZXCT8fmVqt0o2ybm+4i4bkYkpYs1VKgKjnsZ6jDtI02hFPKIFTCLFm9hiZuMwK1dV4KdR1IHxP
	LoHZOnF5BOU+dkF8w8T/wSVKKGABc55iHXc9/rcBPNnCnW+IyVL5A
X-Gm-Gg: ASbGncvowSpeubyEqAmExiFEmdXt7ea7BTqTMvNruHTAAK/QLFS15pwC7kcXvZ9XiFH
	jMUWDZ8S8BxCi8YGwuu7jmKzW7ZkMxa1nt4KNcexLvy6R7neGK18Z8JoPLMDtSyu7MwVSpddM4E
	XBH60pV791SPR8mJKqHwr7OJRu5A==
X-Google-Smtp-Source: AGHT+IF1OziUk+ipGo12CI6tiiCpNFjwOsoIlMx9DcEg2iZigJ8C0IOYkeKhQT4+Bk0eAiWiez3G+VPEJSEkIkXyUEI=
X-Received: by 2002:a05:622a:1886:b0:46f:c1ee:3ea3 with SMTP id
 d75a77b69052e-470ffb7145bmr2067291cf.20.1738835378375; Thu, 06 Feb 2025
 01:49:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250117163001.2326672-7-tabba@google.com> <diqz1pwbspzx.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqz1pwbspzx.fsf@ackerleytng-ctop.c.googlers.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 6 Feb 2025 09:49:01 +0000
X-Gm-Features: AWEUYZl0jkM18J4GnKfTjdDFBJWhhPpUXzN0WB2wY9PGEGPv5QogeezgmoZYrM4
Message-ID: <CA+EHjTzRsou4hwbwFTP9ai6pLOpjp-ikVhNx1b4t+nCByC5Pbw@mail.gmail.com>
Subject: Re: [RFC PATCH v5 06/15] KVM: guest_memfd: Handle final folio_put()
 of guestmem pages
To: Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 6 Feb 2025 at 03:37, Ackerley Tng <ackerleytng@google.com> wrote:
>
> Fuad Tabba <tabba@google.com> writes:
>
> > Before transitioning a guest_memfd folio to unshared, thereby
> > disallowing access by the host and allowing the hypervisor to
> > transition its view of the guest page as private, we need to be
> > sure that the host doesn't have any references to the folio.
> >
> > This patch introduces a new type for guest_memfd folios, and uses
> > that to register a callback that informs the guest_memfd
> > subsystem when the last reference is dropped, therefore knowing
> > that the host doesn't have any remaining references.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> > The function kvm_slot_gmem_register_callback() isn't used in this
> > series. It will be used later in code that performs unsharing of
> > memory. I have tested it with pKVM, based on downstream code [*].
> > It's included in this RFC since it demonstrates the plan to
> > handle unsharing of private folios.
> >
> > [*] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/guestmem-6.13-v5-pkvm
> > ---
> >  include/linux/kvm_host.h   |  11 +++
> >  include/linux/page-flags.h |   7 ++
> >  mm/debug.c                 |   1 +
> >  mm/swap.c                  |   4 +
> >  virt/kvm/guest_memfd.c     | 145 +++++++++++++++++++++++++++++++++++++
> >  5 files changed, 168 insertions(+)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 84aa7908a5dd..63e6d6dd98b3 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -2574,6 +2574,8 @@ int kvm_slot_gmem_clear_mappable(struct kvm_memory_slot *slot, gfn_t start,
> >                                gfn_t end);
> >  bool kvm_slot_gmem_is_mappable(struct kvm_memory_slot *slot, gfn_t gfn);
> >  bool kvm_slot_gmem_is_guest_mappable(struct kvm_memory_slot *slot, gfn_t gfn);
> > +int kvm_slot_gmem_register_callback(struct kvm_memory_slot *slot, gfn_t gfn);
> > +void kvm_gmem_handle_folio_put(struct folio *folio);
> >  #else
> >  static inline bool kvm_gmem_is_mappable(struct kvm *kvm, gfn_t gfn, gfn_t end)
> >  {
> > @@ -2615,6 +2617,15 @@ static inline bool kvm_slot_gmem_is_guest_mappable(struct kvm_memory_slot *slot,
> >       WARN_ON_ONCE(1);
> >       return false;
> >  }
> > +static inline int kvm_slot_gmem_register_callback(struct kvm_memory_slot *slot, gfn_t gfn)
> > +{
> > +     WARN_ON_ONCE(1);
> > +     return -EINVAL;
> > +}
> > +static inline void kvm_gmem_handle_folio_put(struct folio *folio)
> > +{
> > +     WARN_ON_ONCE(1);
> > +}
> >  #endif /* CONFIG_KVM_GMEM_MAPPABLE */
> >
> >  #endif
> > diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> > index 6615f2f59144..bab3cac1f93b 100644
> > --- a/include/linux/page-flags.h
> > +++ b/include/linux/page-flags.h
> > @@ -942,6 +942,7 @@ enum pagetype {
> >       PGTY_slab       = 0xf5,
> >       PGTY_zsmalloc   = 0xf6,
> >       PGTY_unaccepted = 0xf7,
> > +     PGTY_guestmem   = 0xf8,
> >
> >       PGTY_mapcount_underflow = 0xff
> >  };
> > @@ -1091,6 +1092,12 @@ FOLIO_TYPE_OPS(hugetlb, hugetlb)
> >  FOLIO_TEST_FLAG_FALSE(hugetlb)
> >  #endif
> >
> > +#ifdef CONFIG_KVM_GMEM_MAPPABLE
> > +FOLIO_TYPE_OPS(guestmem, guestmem)
> > +#else
> > +FOLIO_TEST_FLAG_FALSE(guestmem)
> > +#endif
> > +
> >  PAGE_TYPE_OPS(Zsmalloc, zsmalloc, zsmalloc)
> >
> >  /*
> > diff --git a/mm/debug.c b/mm/debug.c
> > index 95b6ab809c0e..db93be385ed9 100644
> > --- a/mm/debug.c
> > +++ b/mm/debug.c
> > @@ -56,6 +56,7 @@ static const char *page_type_names[] = {
> >       DEF_PAGETYPE_NAME(table),
> >       DEF_PAGETYPE_NAME(buddy),
> >       DEF_PAGETYPE_NAME(unaccepted),
> > +     DEF_PAGETYPE_NAME(guestmem),
> >  };
> >
> >  static const char *page_type_name(unsigned int page_type)
> > diff --git a/mm/swap.c b/mm/swap.c
> > index 6f01b56bce13..15220eaabc86 100644
> > --- a/mm/swap.c
> > +++ b/mm/swap.c
> > @@ -37,6 +37,7 @@
> >  #include <linux/page_idle.h>
> >  #include <linux/local_lock.h>
> >  #include <linux/buffer_head.h>
> > +#include <linux/kvm_host.h>
> >
> >  #include "internal.h"
> >
> > @@ -103,6 +104,9 @@ static void free_typed_folio(struct folio *folio)
> >       case PGTY_offline:
> >               /* Nothing to do, it's offline. */
> >               return;
> > +     case PGTY_guestmem:
> > +             kvm_gmem_handle_folio_put(folio);
> > +             return;
> >       default:
> >               WARN_ON_ONCE(1);
> >       }
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index d1c192927cf7..722afd9f8742 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -387,6 +387,28 @@ enum folio_mappability {
> >       KVM_GMEM_NONE_MAPPABLE  = 0b11, /* Not mappable, transient state. */
> >  };
> >
> > +/*
> > + * Unregisters the __folio_put() callback from the folio.
> > + *
> > + * Restores a folio's refcount after all pending references have been released,
> > + * and removes the folio type, thereby removing the callback. Now the folio can
> > + * be freed normaly once all actual references have been dropped.
> > + *
> > + * Must be called with the filemap (inode->i_mapping) invalidate_lock held.
> > + * Must also have exclusive access to the folio: folio must be either locked, or
> > + * gmem holds the only reference.
> > + */
> > +static void __kvm_gmem_restore_pending_folio(struct folio *folio)
> > +{
> > +     if (WARN_ON_ONCE(folio_mapped(folio) || !folio_test_guestmem(folio)))
> > +             return;
> > +
> > +     WARN_ON_ONCE(!folio_test_locked(folio) && folio_ref_count(folio) > 1);
> > +
> > +     __folio_clear_guestmem(folio);
> > +     folio_ref_add(folio, folio_nr_pages(folio));
> > +}
> > +
> >  /*
> >   * Marks the range [start, end) as mappable by both the host and the guest.
> >   * Usually called when guest shares memory with the host.
> > @@ -400,7 +422,31 @@ static int gmem_set_mappable(struct inode *inode, pgoff_t start, pgoff_t end)
> >
> >       filemap_invalidate_lock(inode->i_mapping);
> >       for (i = start; i < end; i++) {
> > +             struct folio *folio = NULL;
> > +
> > +             /*
> > +              * If the folio is NONE_MAPPABLE, it indicates that it is
> > +              * transitioning to private (GUEST_MAPPABLE). Transition it to
> > +              * shared (ALL_MAPPABLE) immediately, and remove the callback.
> > +              */
> > +             if (xa_to_value(xa_load(mappable_offsets, i)) == KVM_GMEM_NONE_MAPPABLE) {
> > +                     folio = filemap_lock_folio(inode->i_mapping, i);
> > +                     if (WARN_ON_ONCE(IS_ERR(folio))) {
> > +                             r = PTR_ERR(folio);
> > +                             break;
> > +                     }
> > +
> > +                     if (folio_test_guestmem(folio))
> > +                             __kvm_gmem_restore_pending_folio(folio);
> > +             }
> > +
> >               r = xa_err(xa_store(mappable_offsets, i, xval, GFP_KERNEL));
> > +
> > +             if (folio) {
> > +                     folio_unlock(folio);
> > +                     folio_put(folio);
> > +             }
> > +
> >               if (r)
> >                       break;
> >       }
> > @@ -473,6 +519,105 @@ static int gmem_clear_mappable(struct inode *inode, pgoff_t start, pgoff_t end)
> >       return r;
> >  }
> >
>
> I think one of these functions to restore mappability needs to be called
> to restore the refcounts on truncation. Without doing this, the
> refcounts on the folios at truncation time would only be the
> transient/speculative ones, and truncating will take off the filemap
> refcounts which were already taken off to set up the folio_put()
> callback.

Good point.

> Should mappability can be restored according to
> GUEST_MEMFD_FLAG_INIT_MAPPABLE? Or should mappability of NONE be
> restored to GUEST and mappability of ALL left as ALL?

Not sure I follow :)

Thanks,
/fuad

> > +/*
> > + * Registers a callback to __folio_put(), so that gmem knows that the host does
> > + * not have any references to the folio. It does that by setting the folio type
> > + * to guestmem.
> > + *
> > + * Returns 0 if the host doesn't have any references, or -EAGAIN if the host
> > + * has references, and the callback has been registered.
> > + *
> > + * Must be called with the following locks held:
> > + * - filemap (inode->i_mapping) invalidate_lock
> > + * - folio lock
> > + */
> > +static int __gmem_register_callback(struct folio *folio, struct inode *inode, pgoff_t idx)
> > +{
> > +     struct xarray *mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
> > +     void *xval_guest = xa_mk_value(KVM_GMEM_GUEST_MAPPABLE);
> > +     int refcount;
> > +
> > +     rwsem_assert_held_write_nolockdep(&inode->i_mapping->invalidate_lock);
> > +     WARN_ON_ONCE(!folio_test_locked(folio));
> > +
> > +     if (folio_mapped(folio) || folio_test_guestmem(folio))
> > +             return -EAGAIN;
> > +
> > +     /* Register a callback first. */
> > +     __folio_set_guestmem(folio);
> > +
> > +     /*
> > +      * Check for references after setting the type to guestmem, to guard
> > +      * against potential races with the refcount being decremented later.
> > +      *
> > +      * At least one reference is expected because the folio is locked.
> > +      */
> > +
> > +     refcount = folio_ref_sub_return(folio, folio_nr_pages(folio));
> > +     if (refcount == 1) {
> > +             int r;
> > +
> > +             /* refcount isn't elevated, it's now faultable by the guest. */
> > +             r = WARN_ON_ONCE(xa_err(xa_store(mappable_offsets, idx, xval_guest, GFP_KERNEL)));
> > +             if (!r)
> > +                     __kvm_gmem_restore_pending_folio(folio);
> > +
> > +             return r;
> > +     }
> > +
> > +     return -EAGAIN;
> > +}
> > +
> > +int kvm_slot_gmem_register_callback(struct kvm_memory_slot *slot, gfn_t gfn)
> > +{
> > +     unsigned long pgoff = slot->gmem.pgoff + gfn - slot->base_gfn;
> > +     struct inode *inode = file_inode(slot->gmem.file);
> > +     struct folio *folio;
> > +     int r;
> > +
> > +     filemap_invalidate_lock(inode->i_mapping);
> > +
> > +     folio = filemap_lock_folio(inode->i_mapping, pgoff);
> > +     if (WARN_ON_ONCE(IS_ERR(folio))) {
> > +             r = PTR_ERR(folio);
> > +             goto out;
> > +     }
> > +
> > +     r = __gmem_register_callback(folio, inode, pgoff);
> > +
> > +     folio_unlock(folio);
> > +     folio_put(folio);
> > +out:
> > +     filemap_invalidate_unlock(inode->i_mapping);
> > +
> > +     return r;
> > +}
> > +
> > +/*
> > + * Callback function for __folio_put(), i.e., called when all references by the
> > + * host to the folio have been dropped. This allows gmem to transition the state
> > + * of the folio to mappable by the guest, and allows the hypervisor to continue
> > + * transitioning its state to private, since the host cannot attempt to access
> > + * it anymore.
> > + */
> > +void kvm_gmem_handle_folio_put(struct folio *folio)
> > +{
> > +     struct xarray *mappable_offsets;
> > +     struct inode *inode;
> > +     pgoff_t index;
> > +     void *xval;
> > +
> > +     inode = folio->mapping->host;
> > +     index = folio->index;
> > +     mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
> > +     xval = xa_mk_value(KVM_GMEM_GUEST_MAPPABLE);
> > +
> > +     filemap_invalidate_lock(inode->i_mapping);
> > +     __kvm_gmem_restore_pending_folio(folio);
> > +     WARN_ON_ONCE(xa_err(xa_store(mappable_offsets, index, xval, GFP_KERNEL)));
> > +     filemap_invalidate_unlock(inode->i_mapping);
> > +}
> > +
> >  static bool gmem_is_mappable(struct inode *inode, pgoff_t pgoff)
> >  {
> >       struct xarray *mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;

