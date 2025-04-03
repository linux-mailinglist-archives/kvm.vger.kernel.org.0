Return-Path: <kvm+bounces-42557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7F5AA79F7E
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 11:05:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3428E172557
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 09:04:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19BE02512D3;
	Thu,  3 Apr 2025 08:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IACeMM4g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB8624E4C7
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 08:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743670772; cv=none; b=s0B9XM2uSWd5/ETe1TVzrchvVDvCqXZNU4WAP8SPV3w2bJF4GNTgAKY/t6kkaSeMZ+0YHsvdASg3GYfXDvNw0+rBXqckn3l+Klh+jYJ4Y/SSiA5047BAWUgFshFDbiCbBrCwZzV6S820Ariu2bDYCgvzPQkRgc2ur/337xhFEw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743670772; c=relaxed/simple;
	bh=ch+pSItB/xuhADS4zbhHTg9xox4VIEihqZTrIAxihdU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rRfuesgAf5xdmgTHJ4PCnIgdZdZ8kBmeQw22xul/V/KAckJoEP6VDSzn/Mn0J1s69A/H2k3dLhlfm5cKM2KpLdA4k9YIqawvegVTeuE8STFVQJDyzakZhkX1uE+zn7jiOqnys9YcBDBlBJ/ZE0ajZHbZg6Y9G1XsDCpgLkXLCIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IACeMM4g; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-47681dba807so442691cf.1
        for <kvm@vger.kernel.org>; Thu, 03 Apr 2025 01:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743670765; x=1744275565; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/eBVlASVIyKFmwO5dXZRhoAmxT/OvE9XEsr81sBmw+M=;
        b=IACeMM4g7m16bWwIu2G7Cl8TAILGj307GDo81WfJy3v0POe94MdggzuZfzThI1Kz/N
         bswE5PCfcJuGwNfFH3/bP6R8hJexVaOlYpn1jyH4Cod6sdUiyShnP86xEahDFZMtSiDc
         s+T+0ATKEe80E/KYax5Lp4/kB2VqRdg55UuQNyk3Cf0AcG2c4L0iN+uMRghoz/efwnsB
         rL7UWSM2PghAk4ktcf8vWzbXWUmUWWVDYy6HnxQOnUHk+99ALz3ewrAr1lZ1gxBHI8MS
         ws9+psvcyfsip6zV3XRevCUEY86m8PrvtVIktzGpSezM+Ps21YjsPWXjVvhFVIAYcUPw
         10pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743670765; x=1744275565;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/eBVlASVIyKFmwO5dXZRhoAmxT/OvE9XEsr81sBmw+M=;
        b=AZr4qZGiBf7/+Gdr5pvqDo3+tpdzyBmeXt+dJO9D66+ETycbMlImWYXPsXBB/DiFjW
         M6wLX5YdxFWUK11VqQQ3tCi3a4Ov81rEMlhAG37V7hQhfZBLFPiyLI18x8yBZgf2IRDc
         OaqVxAlZuRAXUEtBiSz1cWyNDjiSZhqVhkfw0Sc2zPfJ1eJFhQ6OSkoM4jkKxZaquGGl
         ICE74LmnlxWeFm36dCpDCJptEEQAZVPX/0rZggDcQ0lG75H4pUOqbvh3K3z74H7GVuzC
         TumZWRHmyFUT4zNADpcd77ucVDsHe97hLFmku8H+pbybkM2OVOR8zBrNIkOYChluKZ6c
         4ENQ==
X-Gm-Message-State: AOJu0YyZ8MO15hS6Fx+gX4RfwNMDSCMCFh2YztEHR+PpfwQ21mZGrjko
	rrknSHxzB7i12FidOmEqzWihOJHJ9Tdi7wRqH0jozFTb6coAeUhbU/qKTcGQ5k9yIrKah6t7QWQ
	6pff4Gf1Iwe5GB6Zv6wu3FB6aqjlpL+wcVxIe
X-Gm-Gg: ASbGncscjDKhBoXUmkTqTLsiaVZnxCImXDbGxL3srY9pECb4sFFRLWSRgqSuZK1FUHj
	lrNDPpYzuAj8ouAUPmv0uGoNF4b9gOsmbs7S+eTMPQXUTgppWck8bxTYlbuBi6U3iVrmd4kt8Rp
	0vPYK0jQzVFC173XBBy4gmxv63Jg==
X-Google-Smtp-Source: AGHT+IEXU+qJqOsCdpb0t4Vh+4R23HPF9NYftWqFNYfIb8gTrhd4BM7gfNMK62jS+OVlyJOUYowmFojvVPudGofbU74=
X-Received: by 2002:a05:622a:c7:b0:466:8887:6751 with SMTP id
 d75a77b69052e-4791953c680mr2650091cf.23.1743670764671; Thu, 03 Apr 2025
 01:59:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250328153133.3504118-5-tabba@google.com> <diqzsemqm8fb.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqzsemqm8fb.fsf@ackerleytng-ctop.c.googlers.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 3 Apr 2025 09:58:47 +0100
X-Gm-Features: ATxdqUF17-bMoezskxlqxe7ZJksMoIfd89AXLMP45nEDSfGr6_4NDi8p_3vJubM
Message-ID: <CA+EHjTx3E8k8ndPx-OJXGdTS2fZRuC+pCqymsTkmvYB6FumT=w@mail.gmail.com>
Subject: Re: [PATCH v7 4/7] KVM: guest_memfd: Folio sharing states and
 functions that manage their transition
To: Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com, 
	pankaj.gupta@amd.com
Content-Type: text/plain; charset="UTF-8"

Hi Ackerley,

On Thu, 3 Apr 2025 at 00:48, Ackerley Tng <ackerleytng@google.com> wrote:
>
> Fuad Tabba <tabba@google.com> writes:
>
> > To allow in-place sharing of guest_memfd folios with the host,
> > guest_memfd needs to track their sharing state, because mapping of
> > shared folios will only be allowed where it safe to access these folios.
> > It is safe to map and access these folios when explicitly shared with
> > the host, or potentially if not yet exposed to the guest (e.g., at
> > initialization).
> >
> > This patch introduces sharing states for guest_memfd folios as well as
> > the functions that manage transitioning between those states.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  include/linux/kvm_host.h |  39 +++++++-
> >  virt/kvm/guest_memfd.c   | 208 ++++++++++++++++++++++++++++++++++++---
> >  virt/kvm/kvm_main.c      |  62 ++++++++++++
> >  3 files changed, 295 insertions(+), 14 deletions(-)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index bc73d7426363..bf82faf16c53 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -2600,7 +2600,44 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
> >  #endif
> >
> >  #ifdef CONFIG_KVM_GMEM_SHARED_MEM
> > +int kvm_gmem_set_shared(struct kvm *kvm, gfn_t start, gfn_t end);
> > +int kvm_gmem_clear_shared(struct kvm *kvm, gfn_t start, gfn_t end);
> > +int kvm_gmem_slot_set_shared(struct kvm_memory_slot *slot, gfn_t start,
> > +                          gfn_t end);
> > +int kvm_gmem_slot_clear_shared(struct kvm_memory_slot *slot, gfn_t start,
> > +                            gfn_t end);
> > +bool kvm_gmem_slot_is_guest_shared(struct kvm_memory_slot *slot, gfn_t gfn);
> >  void kvm_gmem_handle_folio_put(struct folio *folio);
> > -#endif
> > +#else
> > +static inline int kvm_gmem_set_shared(struct kvm *kvm, gfn_t start, gfn_t end)
> > +{
> > +     WARN_ON_ONCE(1);
> > +     return -EINVAL;
> > +}
> > +static inline int kvm_gmem_clear_shared(struct kvm *kvm, gfn_t start,
> > +                                     gfn_t end)
> > +{
> > +     WARN_ON_ONCE(1);
> > +     return -EINVAL;
> > +}
> > +static inline int kvm_gmem_slot_set_shared(struct kvm_memory_slot *slot,
> > +                                        gfn_t start, gfn_t end)
> > +{
> > +     WARN_ON_ONCE(1);
> > +     return -EINVAL;
> > +}
> > +static inline int kvm_gmem_slot_clear_shared(struct kvm_memory_slot *slot,
> > +                                          gfn_t start, gfn_t end)
> > +{
> > +     WARN_ON_ONCE(1);
> > +     return -EINVAL;
> > +}
> > +static inline bool kvm_gmem_slot_is_guest_shared(struct kvm_memory_slot *slot,
> > +                                              gfn_t gfn)
> > +{
> > +     WARN_ON_ONCE(1);
> > +     return false;
> > +}
> > +#endif /* CONFIG_KVM_GMEM_SHARED_MEM */
> >
> >  #endif
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index cde16ed3b230..3b4d724084a8 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -29,14 +29,6 @@ static struct kvm_gmem_inode_private *kvm_gmem_private(struct inode *inode)
> >       return inode->i_mapping->i_private_data;
> >  }
> >
> > -#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> > -void kvm_gmem_handle_folio_put(struct folio *folio)
> > -{
> > -     WARN_ONCE(1, "A placeholder that shouldn't trigger. Work in progress.");
> > -}
> > -EXPORT_SYMBOL_GPL(kvm_gmem_handle_folio_put);
> > -#endif /* CONFIG_KVM_GMEM_SHARED_MEM */
> > -
> >  /**
> >   * folio_file_pfn - like folio_file_page, but return a pfn.
> >   * @folio: The folio which contains this index.
> > @@ -389,22 +381,211 @@ static void kvm_gmem_init_mount(void)
> >  }
> >
> >  #ifdef CONFIG_KVM_GMEM_SHARED_MEM
> > -static bool kvm_gmem_offset_is_shared(struct file *file, pgoff_t index)
> > +/*
> > + * An enum of the valid folio sharing states:
> > + * Bit 0: set if not shared with the guest (guest cannot fault it in)
> > + * Bit 1: set if not shared with the host (host cannot fault it in)
> > + */
> > +enum folio_shareability {
> > +     KVM_GMEM_ALL_SHARED     = 0b00, /* Shared with the host and the guest. */
> > +     KVM_GMEM_GUEST_SHARED   = 0b10, /* Shared only with the guest. */
> > +     KVM_GMEM_NONE_SHARED    = 0b11, /* Not shared, transient state. */
> > +};
> > +
> > +static int kvm_gmem_offset_set_shared(struct inode *inode, pgoff_t index)
> >  {
> > -     struct kvm_gmem *gmem = file->private_data;
> > +     struct xarray *shared_offsets = &kvm_gmem_private(inode)->shared_offsets;
> > +     rwlock_t *offsets_lock = &kvm_gmem_private(inode)->offsets_lock;
> > +     void *xval = xa_mk_value(KVM_GMEM_ALL_SHARED);
> > +
> > +     lockdep_assert_held_write(offsets_lock);
> > +
> > +     return xa_err(xa_store(shared_offsets, index, xval, GFP_KERNEL));
> > +}
> > +
> > +/*
> > + * Marks the range [start, end) as shared with both the host and the guest.
> > + * Called when guest shares memory with the host.
> > + */
> > +static int kvm_gmem_offset_range_set_shared(struct inode *inode,
> > +                                         pgoff_t start, pgoff_t end)
> > +{
> > +     rwlock_t *offsets_lock = &kvm_gmem_private(inode)->offsets_lock;
> > +     pgoff_t i;
> > +     int r = 0;
> > +
> > +     write_lock(offsets_lock);
> > +     for (i = start; i < end; i++) {
> > +             r = kvm_gmem_offset_set_shared(inode, i);
> > +             if (WARN_ON_ONCE(r))
> > +                     break;
> > +     }
> > +     write_unlock(offsets_lock);
> > +
> > +     return r;
> > +}
> > +
> > +static int kvm_gmem_offset_clear_shared(struct inode *inode, pgoff_t index)
> > +{
> > +     struct xarray *shared_offsets = &kvm_gmem_private(inode)->shared_offsets;
> > +     rwlock_t *offsets_lock = &kvm_gmem_private(inode)->offsets_lock;
> > +     void *xval_guest = xa_mk_value(KVM_GMEM_GUEST_SHARED);
> > +     void *xval_none = xa_mk_value(KVM_GMEM_NONE_SHARED);
> > +     struct folio *folio;
> > +     int refcount;
> > +     int r;
> > +
> > +     lockdep_assert_held_write(offsets_lock);
> > +
> > +     folio = filemap_lock_folio(inode->i_mapping, index);
> > +     if (!IS_ERR(folio)) {
> > +             /* +1 references are expected because of filemap_lock_folio(). */
> > +             refcount = folio_nr_pages(folio) + 1;
> > +     } else {
> > +             r = PTR_ERR(folio);
> > +             if (WARN_ON_ONCE(r != -ENOENT))
> > +                     return r;
> > +
> > +             folio = NULL;
> > +     }
> > +
> > +     if (!folio || folio_ref_freeze(folio, refcount)) {
> > +             /*
> > +              * No outstanding references: transition to guest shared.
> > +              */
> > +             r = xa_err(xa_store(shared_offsets, index, xval_guest, GFP_KERNEL));
> > +
> > +             if (folio)
> > +                     folio_ref_unfreeze(folio, refcount);
> > +     } else {
> > +             /*
> > +              * Outstanding references: the folio cannot be faulted in by
> > +              * anyone until they're dropped.
> > +              */
> > +             r = xa_err(xa_store(shared_offsets, index, xval_none, GFP_KERNEL));
>
> Once we do this on elevated refcounts, truncate needs to be updated to
> handle the case where some folio is still in a KVM_GMEM_NONE_SHARED
> state.
>
> When a folio is found in a KVM_GMEM_NONE_SHARED state, the shareability
> should be fast-forwarded to KVM_GMEM_GUEST_SHARED, and the filemap's
> refcounts restored.  The folio can then be truncated from the filemap as
> usual (which will drop the filemap's refcounts)

Ack.

Thanks,
/fuad


> > +     }
> > +
> > +     if (folio) {
> > +             folio_unlock(folio);
> > +             folio_put(folio);
> > +     }
> > +
> > +     return r;
> > +}
> >
> > +/*
> > + * Marks the range [start, end) as not shared with the host. If the host doesn't
> > + * have any references to a particular folio, then that folio is marked as
> > + * shared with the guest.
> > + *
> > + * However, if the host still has references to the folio, then the folio is
> > + * marked and not shared with anyone. Marking it as not shared allows draining
> > + * all references from the host, and ensures that the hypervisor does not
> > + * transition the folio to private, since the host still might access it.
> > + *
> > + * Called when guest unshares memory with the host.
> > + */
> > +static int kvm_gmem_offset_range_clear_shared(struct inode *inode,
> > +                                           pgoff_t start, pgoff_t end)
> > +{
> > +     rwlock_t *offsets_lock = &kvm_gmem_private(inode)->offsets_lock;
> > +     pgoff_t i;
> > +     int r = 0;
> > +
> > +     write_lock(offsets_lock);
> > +     for (i = start; i < end; i++) {
> > +             r = kvm_gmem_offset_clear_shared(inode, i);
> > +             if (WARN_ON_ONCE(r))
> > +                     break;
> > +     }
> > +     write_unlock(offsets_lock);
> > +
> > +     return r;
> > +}
> > +
> > +void kvm_gmem_handle_folio_put(struct folio *folio)
> > +{
> > +     WARN_ONCE(1, "A placeholder that shouldn't trigger. Work in progress.");
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_gmem_handle_folio_put);
> > +
> > +/*
> > + * Returns true if the folio is shared with the host and the guest.
> > + *
> > + * Must be called with the offsets_lock lock held.
> > + */
> > +static bool kvm_gmem_offset_is_shared(struct inode *inode, pgoff_t index)
> > +{
> > +     struct xarray *shared_offsets = &kvm_gmem_private(inode)->shared_offsets;
> > +     rwlock_t *offsets_lock = &kvm_gmem_private(inode)->offsets_lock;
> > +     unsigned long r;
> > +
> > +     lockdep_assert_held(offsets_lock);
> >
> > -     /* For now, VMs that support shared memory share all their memory. */
> > -     return kvm_arch_gmem_supports_shared_mem(gmem->kvm);
> > +     r = xa_to_value(xa_load(shared_offsets, index));
> > +
> > +     return r == KVM_GMEM_ALL_SHARED;
> > +}
> > +
> > +/*
> > + * Returns true if the folio is shared with the guest (not transitioning).
> > + *
> > + * Must be called with the offsets_lock lock held.
> > + */
> > +static bool kvm_gmem_offset_is_guest_shared(struct inode *inode, pgoff_t index)
> > +{
> > +     struct xarray *shared_offsets = &kvm_gmem_private(inode)->shared_offsets;
> > +     rwlock_t *offsets_lock = &kvm_gmem_private(inode)->offsets_lock;
> > +     unsigned long r;
> > +
> > +     lockdep_assert_held(offsets_lock);
> > +
> > +     r = xa_to_value(xa_load(shared_offsets, index));
> > +
> > +     return (r == KVM_GMEM_ALL_SHARED || r == KVM_GMEM_GUEST_SHARED);
> > +}
> > +
> > +int kvm_gmem_slot_set_shared(struct kvm_memory_slot *slot, gfn_t start, gfn_t end)
> > +{
> > +     struct inode *inode = file_inode(READ_ONCE(slot->gmem.file));
> > +     pgoff_t start_off = slot->gmem.pgoff + start - slot->base_gfn;
> > +     pgoff_t end_off = start_off + end - start;
> > +
> > +     return kvm_gmem_offset_range_set_shared(inode, start_off, end_off);
> > +}
> > +
> > +int kvm_gmem_slot_clear_shared(struct kvm_memory_slot *slot, gfn_t start, gfn_t end)
> > +{
> > +     struct inode *inode = file_inode(READ_ONCE(slot->gmem.file));
> > +     pgoff_t start_off = slot->gmem.pgoff + start - slot->base_gfn;
> > +     pgoff_t end_off = start_off + end - start;
> > +
> > +     return kvm_gmem_offset_range_clear_shared(inode, start_off, end_off);
> > +}
> > +
> > +bool kvm_gmem_slot_is_guest_shared(struct kvm_memory_slot *slot, gfn_t gfn)
> > +{
> > +     struct inode *inode = file_inode(READ_ONCE(slot->gmem.file));
> > +     rwlock_t *offsets_lock = &kvm_gmem_private(inode)->offsets_lock;
> > +     unsigned long pgoff = slot->gmem.pgoff + gfn - slot->base_gfn;
> > +     bool r;
> > +
> > +     read_lock(offsets_lock);
> > +     r = kvm_gmem_offset_is_guest_shared(inode, pgoff);
> > +     read_unlock(offsets_lock);
> > +
> > +     return r;
> >  }
> >
> >  static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
> >  {
> >       struct inode *inode = file_inode(vmf->vma->vm_file);
> > +     rwlock_t *offsets_lock = &kvm_gmem_private(inode)->offsets_lock;
> >       struct folio *folio;
> >       vm_fault_t ret = VM_FAULT_LOCKED;
> >
> >       filemap_invalidate_lock_shared(inode->i_mapping);
> > +     read_lock(offsets_lock);
> >
> >       folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> >       if (IS_ERR(folio)) {
> > @@ -423,7 +604,7 @@ static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
> >               goto out_folio;
> >       }
> >
> > -     if (!kvm_gmem_offset_is_shared(vmf->vma->vm_file, vmf->pgoff)) {
> > +     if (!kvm_gmem_offset_is_shared(inode, vmf->pgoff)) {
> >               ret = VM_FAULT_SIGBUS;
> >               goto out_folio;
> >       }
> > @@ -457,6 +638,7 @@ static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
> >       }
> >
> >  out_filemap:
> > +     read_unlock(offsets_lock);
> >       filemap_invalidate_unlock_shared(inode->i_mapping);
> >
> >       return ret;
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 3e40acb9f5c0..90762252381c 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -3091,6 +3091,68 @@ static int next_segment(unsigned long len, int offset)
> >               return len;
> >  }
> >
> > +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> > +int kvm_gmem_set_shared(struct kvm *kvm, gfn_t start, gfn_t end)
> > +{
> > +     struct kvm_memslot_iter iter;
> > +     int r = 0;
> > +
> > +     mutex_lock(&kvm->slots_lock);
> > +
> > +     kvm_for_each_memslot_in_gfn_range(&iter, kvm_memslots(kvm), start, end) {
> > +             struct kvm_memory_slot *memslot = iter.slot;
> > +             gfn_t gfn_start, gfn_end;
> > +
> > +             if (!kvm_slot_can_be_private(memslot))
> > +                     continue;
> > +
> > +             gfn_start = max(start, memslot->base_gfn);
> > +             gfn_end = min(end, memslot->base_gfn + memslot->npages);
> > +             if (WARN_ON_ONCE(start >= end))
> > +                     continue;
> > +
> > +             r = kvm_gmem_slot_set_shared(memslot, gfn_start, gfn_end);
> > +             if (WARN_ON_ONCE(r))
> > +                     break;
> > +     }
> > +
> > +     mutex_unlock(&kvm->slots_lock);
> > +
> > +     return r;
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_gmem_set_shared);
> > +
> > +int kvm_gmem_clear_shared(struct kvm *kvm, gfn_t start, gfn_t end)
> > +{
> > +     struct kvm_memslot_iter iter;
> > +     int r = 0;
> > +
> > +     mutex_lock(&kvm->slots_lock);
> > +
> > +     kvm_for_each_memslot_in_gfn_range(&iter, kvm_memslots(kvm), start, end) {
> > +             struct kvm_memory_slot *memslot = iter.slot;
> > +             gfn_t gfn_start, gfn_end;
> > +
> > +             if (!kvm_slot_can_be_private(memslot))
> > +                     continue;
> > +
> > +             gfn_start = max(start, memslot->base_gfn);
> > +             gfn_end = min(end, memslot->base_gfn + memslot->npages);
> > +             if (WARN_ON_ONCE(start >= end))
> > +                     continue;
> > +
> > +             r = kvm_gmem_slot_clear_shared(memslot, gfn_start, gfn_end);
> > +             if (WARN_ON_ONCE(r))
> > +                     break;
> > +     }
> > +
> > +     mutex_unlock(&kvm->slots_lock);
> > +
> > +     return r;
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_gmem_clear_shared);
> > +#endif /* CONFIG_KVM_GMEM_SHARED_MEM */
> > +
> >  /* Copy @len bytes from guest memory at '(@gfn * PAGE_SIZE) + @offset' to @data */
> >  static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
> >                                void *data, int offset, int len)

