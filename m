Return-Path: <kvm+bounces-37425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EAD5A29F6D
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 04:37:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 70F851888ABF
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 03:37:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61632158525;
	Thu,  6 Feb 2025 03:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TIoK3YLg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0901527B4
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 03:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738813030; cv=none; b=tGIKM5+QCWky0JXlIclnfiODfnjEXIxkc+rA2VbTlCFpN/h2xXJD4QfD6/6jScKeyNBR4v9yGl5clo644TQBUgqM7n+IytAyA6Mk4K2kPVQoRRH3xkGP3fiV4pH0UxhxXEv1PHwpFwwogste3EMzO7DxBP+2iD6VQDUPoA/SNwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738813030; c=relaxed/simple;
	bh=SKWn6TXEXhmMjKUHcZeCx7dEpDbAaVJ346qu9arIhzE=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=pxXV7jWrjO4+1SBW5jUR5YFBY0nCUuZJRM863Kjpl8qvCFAOLzC+pymyxDq3Ugn3XMXoCjlHOjmyzi2PMTenQaI1vZyxeqIiIcan0KozpPCN7lS2wKYxXzpYoQv0Pl5UKx8d6uTXwtixvBAGa9vpDNkXdrWpcm0kMiwKAXtQIZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TIoK3YLg; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f83e54432dso1335110a91.2
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2025 19:37:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738813028; x=1739417828; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pRUcWLN38Aa0aZPGEebbNawOjCOpEyDG26hlfVRLOOs=;
        b=TIoK3YLgkIpV5LRIYkMo38XfHPKPWbN5JHACNKXvMCxmHiO3Wm+9+uUdlmx8tU6rgy
         QT6I/OyipKvQK2YgkQ/WKQQaOSv65HVMrdWc5huoCxJ2HQxCYcA8qcyrzcTaBqj296Wz
         fHjC4Ccjm+bU7nD+DKH8EKxwOj4wDwgA4xljalvljNMlvfD+BLwm++cCJgHZaH35BkTY
         U5OYl+NXy4COg12AeOZXDLoflQHVbYWrrpgm9fmoON/1ZW1XKnTJLMvlG8X2w2dRxCyH
         MurV/eD4fpN/ywNuaKy/b/ET21Nu59b6F8YeTs0LvQwtJGIdLSW3KUG3K2MK4RQWLR+6
         211Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738813028; x=1739417828;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pRUcWLN38Aa0aZPGEebbNawOjCOpEyDG26hlfVRLOOs=;
        b=TV/Q9Lq/Dgy4FIP/LM7oniUKOGDmIDT2/z0dzWN8CsrrXtDk6WksAhGz6HDlrQk/jF
         EtibA+0lOTWSYR9NaPt8NPdmJfDryYVaSZ9WZwn5Bj8GCFZvRrkFaMp9MY4KOFL1xA6X
         9cUxeiVMYbPEYeWhKAflKrVuEfPMT8sXF7+pQkQ1YrLLxd37Ytwv/Qt0FL0aohS26Wbr
         ff4TA/RG0FynU/fLgXS8eonV6dP2pTBsSxLwJLRG8coyhbbw0KsrW/8Wu5n5NVNWEOsC
         768wM7dH0+R0uROaW7fEokPtlSqAxebLNbZmZoI2mX2ReNCV2900eqvbAlqconl1Ig/a
         Ns9A==
X-Gm-Message-State: AOJu0YzuE3ioz+zzdd9Qs9YOI/fvRhwmXVoqk5EjSnGeamh6lGwTG6XG
	KDTp5RWkvnqyZ9cbd0IFWPtBcVf8mQNwcqF/3j1Wx8LzEsllEduMEM3Bv7Od7P4q3p/Z1pCa8ul
	DE3le5JJQ233h3LFmlF+9zw==
X-Google-Smtp-Source: AGHT+IGhY4/pV+4mHiEaSq+to1TSQKDTUBZjG4PDt5LI9mDx6rl17K7kwWvRj+1UQyTkxkdUhDnW93d4pfLlxxgdZA==
X-Received: from pjl7.prod.google.com ([2002:a17:90b:2f87:b0:2f9:d5f9:128f])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:d44b:b0:2ee:c9b6:c267 with SMTP id 98e67ed59e1d1-2f9e075da23mr8852501a91.9.1738813028145;
 Wed, 05 Feb 2025 19:37:08 -0800 (PST)
Date: Thu, 06 Feb 2025 03:37:06 +0000
In-Reply-To: <20250117163001.2326672-7-tabba@google.com> (message from Fuad
 Tabba on Fri, 17 Jan 2025 16:29:52 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqz1pwbspzx.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH v5 06/15] KVM: guest_memfd: Handle final folio_put()
 of guestmem pages
From: Ackerley Tng <ackerleytng@google.com>
To: Fuad Tabba <tabba@google.com>
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
	jthoughton@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Fuad Tabba <tabba@google.com> writes:

> Before transitioning a guest_memfd folio to unshared, thereby
> disallowing access by the host and allowing the hypervisor to
> transition its view of the guest page as private, we need to be
> sure that the host doesn't have any references to the folio.
>
> This patch introduces a new type for guest_memfd folios, and uses
> that to register a callback that informs the guest_memfd
> subsystem when the last reference is dropped, therefore knowing
> that the host doesn't have any remaining references.
>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
> The function kvm_slot_gmem_register_callback() isn't used in this
> series. It will be used later in code that performs unsharing of
> memory. I have tested it with pKVM, based on downstream code [*].
> It's included in this RFC since it demonstrates the plan to
> handle unsharing of private folios.
>
> [*] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/guestmem-6.13-v5-pkvm
> ---
>  include/linux/kvm_host.h   |  11 +++
>  include/linux/page-flags.h |   7 ++
>  mm/debug.c                 |   1 +
>  mm/swap.c                  |   4 +
>  virt/kvm/guest_memfd.c     | 145 +++++++++++++++++++++++++++++++++++++
>  5 files changed, 168 insertions(+)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 84aa7908a5dd..63e6d6dd98b3 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2574,6 +2574,8 @@ int kvm_slot_gmem_clear_mappable(struct kvm_memory_slot *slot, gfn_t start,
>  				 gfn_t end);
>  bool kvm_slot_gmem_is_mappable(struct kvm_memory_slot *slot, gfn_t gfn);
>  bool kvm_slot_gmem_is_guest_mappable(struct kvm_memory_slot *slot, gfn_t gfn);
> +int kvm_slot_gmem_register_callback(struct kvm_memory_slot *slot, gfn_t gfn);
> +void kvm_gmem_handle_folio_put(struct folio *folio);
>  #else
>  static inline bool kvm_gmem_is_mappable(struct kvm *kvm, gfn_t gfn, gfn_t end)
>  {
> @@ -2615,6 +2617,15 @@ static inline bool kvm_slot_gmem_is_guest_mappable(struct kvm_memory_slot *slot,
>  	WARN_ON_ONCE(1);
>  	return false;
>  }
> +static inline int kvm_slot_gmem_register_callback(struct kvm_memory_slot *slot, gfn_t gfn)
> +{
> +	WARN_ON_ONCE(1);
> +	return -EINVAL;
> +}
> +static inline void kvm_gmem_handle_folio_put(struct folio *folio)
> +{
> +	WARN_ON_ONCE(1);
> +}
>  #endif /* CONFIG_KVM_GMEM_MAPPABLE */
>  
>  #endif
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 6615f2f59144..bab3cac1f93b 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -942,6 +942,7 @@ enum pagetype {
>  	PGTY_slab	= 0xf5,
>  	PGTY_zsmalloc	= 0xf6,
>  	PGTY_unaccepted	= 0xf7,
> +	PGTY_guestmem	= 0xf8,
>  
>  	PGTY_mapcount_underflow = 0xff
>  };
> @@ -1091,6 +1092,12 @@ FOLIO_TYPE_OPS(hugetlb, hugetlb)
>  FOLIO_TEST_FLAG_FALSE(hugetlb)
>  #endif
>  
> +#ifdef CONFIG_KVM_GMEM_MAPPABLE
> +FOLIO_TYPE_OPS(guestmem, guestmem)
> +#else
> +FOLIO_TEST_FLAG_FALSE(guestmem)
> +#endif
> +
>  PAGE_TYPE_OPS(Zsmalloc, zsmalloc, zsmalloc)
>  
>  /*
> diff --git a/mm/debug.c b/mm/debug.c
> index 95b6ab809c0e..db93be385ed9 100644
> --- a/mm/debug.c
> +++ b/mm/debug.c
> @@ -56,6 +56,7 @@ static const char *page_type_names[] = {
>  	DEF_PAGETYPE_NAME(table),
>  	DEF_PAGETYPE_NAME(buddy),
>  	DEF_PAGETYPE_NAME(unaccepted),
> +	DEF_PAGETYPE_NAME(guestmem),
>  };
>  
>  static const char *page_type_name(unsigned int page_type)
> diff --git a/mm/swap.c b/mm/swap.c
> index 6f01b56bce13..15220eaabc86 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -37,6 +37,7 @@
>  #include <linux/page_idle.h>
>  #include <linux/local_lock.h>
>  #include <linux/buffer_head.h>
> +#include <linux/kvm_host.h>
>  
>  #include "internal.h"
>  
> @@ -103,6 +104,9 @@ static void free_typed_folio(struct folio *folio)
>  	case PGTY_offline:
>  		/* Nothing to do, it's offline. */
>  		return;
> +	case PGTY_guestmem:
> +		kvm_gmem_handle_folio_put(folio);
> +		return;
>  	default:
>  		WARN_ON_ONCE(1);
>  	}
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index d1c192927cf7..722afd9f8742 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -387,6 +387,28 @@ enum folio_mappability {
>  	KVM_GMEM_NONE_MAPPABLE	= 0b11, /* Not mappable, transient state. */
>  };
>  
> +/*
> + * Unregisters the __folio_put() callback from the folio.
> + *
> + * Restores a folio's refcount after all pending references have been released,
> + * and removes the folio type, thereby removing the callback. Now the folio can
> + * be freed normaly once all actual references have been dropped.
> + *
> + * Must be called with the filemap (inode->i_mapping) invalidate_lock held.
> + * Must also have exclusive access to the folio: folio must be either locked, or
> + * gmem holds the only reference.
> + */
> +static void __kvm_gmem_restore_pending_folio(struct folio *folio)
> +{
> +	if (WARN_ON_ONCE(folio_mapped(folio) || !folio_test_guestmem(folio)))
> +		return;
> +
> +	WARN_ON_ONCE(!folio_test_locked(folio) && folio_ref_count(folio) > 1);
> +
> +	__folio_clear_guestmem(folio);
> +	folio_ref_add(folio, folio_nr_pages(folio));
> +}
> +
>  /*
>   * Marks the range [start, end) as mappable by both the host and the guest.
>   * Usually called when guest shares memory with the host.
> @@ -400,7 +422,31 @@ static int gmem_set_mappable(struct inode *inode, pgoff_t start, pgoff_t end)
>  
>  	filemap_invalidate_lock(inode->i_mapping);
>  	for (i = start; i < end; i++) {
> +		struct folio *folio = NULL;
> +
> +		/*
> +		 * If the folio is NONE_MAPPABLE, it indicates that it is
> +		 * transitioning to private (GUEST_MAPPABLE). Transition it to
> +		 * shared (ALL_MAPPABLE) immediately, and remove the callback.
> +		 */
> +		if (xa_to_value(xa_load(mappable_offsets, i)) == KVM_GMEM_NONE_MAPPABLE) {
> +			folio = filemap_lock_folio(inode->i_mapping, i);
> +			if (WARN_ON_ONCE(IS_ERR(folio))) {
> +				r = PTR_ERR(folio);
> +				break;
> +			}
> +
> +			if (folio_test_guestmem(folio))
> +				__kvm_gmem_restore_pending_folio(folio);
> +		}
> +
>  		r = xa_err(xa_store(mappable_offsets, i, xval, GFP_KERNEL));
> +
> +		if (folio) {
> +			folio_unlock(folio);
> +			folio_put(folio);
> +		}
> +
>  		if (r)
>  			break;
>  	}
> @@ -473,6 +519,105 @@ static int gmem_clear_mappable(struct inode *inode, pgoff_t start, pgoff_t end)
>  	return r;
>  }
>

I think one of these functions to restore mappability needs to be called
to restore the refcounts on truncation. Without doing this, the
refcounts on the folios at truncation time would only be the
transient/speculative ones, and truncating will take off the filemap
refcounts which were already taken off to set up the folio_put()
callback.

Should mappability can be restored according to
GUEST_MEMFD_FLAG_INIT_MAPPABLE? Or should mappability of NONE be
restored to GUEST and mappability of ALL left as ALL?

> +/*
> + * Registers a callback to __folio_put(), so that gmem knows that the host does
> + * not have any references to the folio. It does that by setting the folio type
> + * to guestmem.
> + *
> + * Returns 0 if the host doesn't have any references, or -EAGAIN if the host
> + * has references, and the callback has been registered.
> + *
> + * Must be called with the following locks held:
> + * - filemap (inode->i_mapping) invalidate_lock
> + * - folio lock
> + */
> +static int __gmem_register_callback(struct folio *folio, struct inode *inode, pgoff_t idx)
> +{
> +	struct xarray *mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
> +	void *xval_guest = xa_mk_value(KVM_GMEM_GUEST_MAPPABLE);
> +	int refcount;
> +
> +	rwsem_assert_held_write_nolockdep(&inode->i_mapping->invalidate_lock);
> +	WARN_ON_ONCE(!folio_test_locked(folio));
> +
> +	if (folio_mapped(folio) || folio_test_guestmem(folio))
> +		return -EAGAIN;
> +
> +	/* Register a callback first. */
> +	__folio_set_guestmem(folio);
> +
> +	/*
> +	 * Check for references after setting the type to guestmem, to guard
> +	 * against potential races with the refcount being decremented later.
> +	 *
> +	 * At least one reference is expected because the folio is locked.
> +	 */
> +
> +	refcount = folio_ref_sub_return(folio, folio_nr_pages(folio));
> +	if (refcount == 1) {
> +		int r;
> +
> +		/* refcount isn't elevated, it's now faultable by the guest. */
> +		r = WARN_ON_ONCE(xa_err(xa_store(mappable_offsets, idx, xval_guest, GFP_KERNEL)));
> +		if (!r)
> +			__kvm_gmem_restore_pending_folio(folio);
> +
> +		return r;
> +	}
> +
> +	return -EAGAIN;
> +}
> +
> +int kvm_slot_gmem_register_callback(struct kvm_memory_slot *slot, gfn_t gfn)
> +{
> +	unsigned long pgoff = slot->gmem.pgoff + gfn - slot->base_gfn;
> +	struct inode *inode = file_inode(slot->gmem.file);
> +	struct folio *folio;
> +	int r;
> +
> +	filemap_invalidate_lock(inode->i_mapping);
> +
> +	folio = filemap_lock_folio(inode->i_mapping, pgoff);
> +	if (WARN_ON_ONCE(IS_ERR(folio))) {
> +		r = PTR_ERR(folio);
> +		goto out;
> +	}
> +
> +	r = __gmem_register_callback(folio, inode, pgoff);
> +
> +	folio_unlock(folio);
> +	folio_put(folio);
> +out:
> +	filemap_invalidate_unlock(inode->i_mapping);
> +
> +	return r;
> +}
> +
> +/*
> + * Callback function for __folio_put(), i.e., called when all references by the
> + * host to the folio have been dropped. This allows gmem to transition the state
> + * of the folio to mappable by the guest, and allows the hypervisor to continue
> + * transitioning its state to private, since the host cannot attempt to access
> + * it anymore.
> + */
> +void kvm_gmem_handle_folio_put(struct folio *folio)
> +{
> +	struct xarray *mappable_offsets;
> +	struct inode *inode;
> +	pgoff_t index;
> +	void *xval;
> +
> +	inode = folio->mapping->host;
> +	index = folio->index;
> +	mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
> +	xval = xa_mk_value(KVM_GMEM_GUEST_MAPPABLE);
> +
> +	filemap_invalidate_lock(inode->i_mapping);
> +	__kvm_gmem_restore_pending_folio(folio);
> +	WARN_ON_ONCE(xa_err(xa_store(mappable_offsets, index, xval, GFP_KERNEL)));
> +	filemap_invalidate_unlock(inode->i_mapping);
> +}
> +
>  static bool gmem_is_mappable(struct inode *inode, pgoff_t pgoff)
>  {
>  	struct xarray *mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;

