Return-Path: <kvm+bounces-59229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A99A3BAECAF
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 01:40:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B74AA7ACA3A
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 23:38:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 285CB2D2385;
	Tue, 30 Sep 2025 23:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o4BPb1Eq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954223FF1
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 23:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759275620; cv=none; b=X60M1D5c3VMugPE+LhW6RnpAJEEE9lJ1VSy8+Btx5UA+PJpnocyxrnmaH1/UhGpYsevbcDoqrpUK4TQq1OQgpNBuF56Rf4rj5v6r9cSB4iZw3ZJ8uHu9HI9iOEEqyX4WNy60rRjpOarA3cYjD9uSgUSbM6mNwVf7X8OrHbk2em4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759275620; c=relaxed/simple;
	bh=StwPnBIUSMSFegQ863nDgybAMWqQBBLSuebLfakUqz4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MtxZrZSeqrxVOFYw0xoHotDpEJYqOucble/8O1SF0jaed6paSzddjqsYJo9KYCBmste8c7JcW1Tuxvmx9iTLCwXs7DZoeNG/qBhACV1nvn/+l5eTI1hihKyXkPDj4AsVyxKh45R9yrzmijl+MSGleM/lMyQ0iDuA90wb/yloG4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o4BPb1Eq; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ee4998c50so5734532a91.3
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 16:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759275618; x=1759880418; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xm/RBBtgnyJT6LVVzMbxzLMA7Ui8E/Kvsc3SFAo9v44=;
        b=o4BPb1EqbXCHl8aI4HTEDy8zuf8Cv8XVsp6rWLlj3RKC04LEJI9+YYc4LM2KsA80Be
         gpHEJALjchBwCm+S32gGnFH4DRGhzuLBQb5CyLxRrODzUnKpdkrw7N1vHIQgRTsYX4+j
         XnnDxcyjkbQXYCjpz/oT3INIOX5nsFDAhjW8zfFhMsrOVkMIHov4noVoVhlXxFhRruTE
         DV51R/bRt75V3NwfuccprbIBN7/Yr8BMwHOApovQjsjGzMxg5LVp4W3uto+jcl6yFCcv
         b9NGVJJut7Q9ASx3I8k2znQs49wXFghifE4rXvEztQSGvNTnNgdAoeEvEvQt/t4LuIRk
         Jnqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759275618; x=1759880418;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xm/RBBtgnyJT6LVVzMbxzLMA7Ui8E/Kvsc3SFAo9v44=;
        b=HbBVPLGJj9LqbOsedD9scRn2GbTvXodzwzumZAnn7tljbwma8z8dWK7l7ZDEjGcaSd
         +8qek4uyqVhBV5nzfzJcr7Nold8Fk3V/ygCzqJ4XudXEmXRQ6GB6hZ51ZxUSzM9Op+xJ
         MYIIhH1vGdxBl+LA0BDZ3PvGlHP2IiMx2qynKUYe7Xw+CphBrV1eowP0+zE/pic7u9PQ
         nwWwRbT0OjzX7mpyWpeALKdtAYphJTSI1tLuVBJdIxUx6S5tDioAFhxxGBvaYra7rbSm
         XUCyDDFBz2q6ig0T2jlia4Gdv6ydPkvmI2ObOnSD/KDiDdSS4rugCJsP7uCXcK5BKcuA
         npVA==
X-Gm-Message-State: AOJu0Yzg2oXlJxB7qftlqbkk9O/0bETi0zJwt9mcVjUPbXmWOy1tc99h
	jjOr6nsYK2w42Jfs9b0jGFkyJ/2DoJlHeK7cuqbmY4EQB1MTT3XsNcuHk4O57DZ3ncQSX1vuEZB
	ihCe3rA==
X-Google-Smtp-Source: AGHT+IG1z1pktD2SPLEM02kCuS94B4e/h+OQF2dnTNOyub+/4QpLhwWdDJaxJSvpjl1nBImjz7byfGgeGcc=
X-Received: from pjbei17.prod.google.com ([2002:a17:90a:e551:b0:32b:95bb:dbc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3a81:b0:32e:87f6:f5a6
 with SMTP id 98e67ed59e1d1-339a6d796bbmr1590614a91.0.1759275617867; Tue, 30
 Sep 2025 16:40:17 -0700 (PDT)
Date: Tue, 30 Sep 2025 16:40:16 -0700
In-Reply-To: <b784326e9ccae6a08388f1bf39db70a2204bdc51.1747264138.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <b784326e9ccae6a08388f1bf39db70a2204bdc51.1747264138.git.ackerleytng@google.com>
Message-ID: <aNxqYMqtBKll-TgV@google.com>
Subject: Re: [RFC PATCH v2 02/51] KVM: guest_memfd: Introduce and use
 shareability to guard faulting
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Fuad Tabba <tabba@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Michael Roth <michael.roth@amd.com>, 
	Ira Weiny <ira.weiny@intel.com>, Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, David Hildenbrand <david@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

Trimmed the Cc substantially as I doubt non-gmem/KVM folks will be excited about
thread necromancy.

On Wed, May 14, 2025, Ackerley Tng wrote:
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 86f74ce7f12a..f609337ae1c2 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6408,6 +6408,11 @@ belonging to the slot via its userspace_addr.
>  The use of GUEST_MEMFD_FLAG_SUPPORT_SHARED will not be allowed for CoCo VMs.
>  This is validated when the guest_memfd instance is bound to the VM.
>  
> +If the capability KVM_CAP_GMEM_CONVERSIONS is supported, then the 'flags' field
> +supports GUEST_MEMFD_FLAG_INIT_PRIVATE.  Setting GUEST_MEMFD_FLAG_INIT_PRIVATE
> +will initialize the memory for the guest_memfd as guest-only and not faultable
> +by the host.

Whatever documentation we add should land at the same time as the collateral.
KVM_CAP_GMEM_CONVERSIONS literally doesn't exist at this time.

> @@ -17,6 +18,24 @@ struct kvm_gmem {
>  	struct list_head entry;
>  };
>  
> +struct kvm_gmem_inode_private {
> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> +	struct maple_tree shareability;
> +#endif
> +};
> +
> +enum shareability {
> +	SHAREABILITY_GUEST = 1,	/* Only the guest can map (fault) folios in this range. */
> +	SHAREABILITY_ALL = 2,	/* Both guest and host can fault folios in this range. */
> +};

Rather than define new values and new KVM uAPI, I think we should instead simply
support KVM_SET_MEMORY_ATTRIBUTES.  We'll probably need a new CAP, as I'm not sure
supporting KVM_CHECK_EXTENSION+KVM_CAP_MEMORY_ATTRIBUTES on a gmem fd would be a
good idea (e.g. trying to do KVM_CAP_GUEST_MEMFD_FLAGS on a gmem fd doesn't work
because the whole point is to get flags _before_ creating the gmem instance).  But
adding e.g. KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES is easy enough.

But for specifying PRIVATE vs. SHARED, I don't see any reason to define new uAPI.
I also don't want an entirely new set of terms in KVM to describe the same things.
PRIVATE and SHARED are far from perfect, but they're better than https://xkcd.com/927.
And if we ever want to let userspace restrict RWX protections in gmem, we'll have
a ready-made way to do so.  

Internally, that let's us do some fun things in KVM.  E.g. if we make the "disable
legacy per-VM memory attributes" a read-only module param, then we can wire up a
static_call() for kvm_get_memory_attributes() and then kvm_mem_is_private() will
Just Work.

  static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
  {
	return static_call(__kvm_get_memory_attributes)(kvm, gfn);
  }

  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
  {
	return kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
  }

That might trigger some additional surgery if/when we want to support RWX
protections on a per-VM basis _and_ a per-gmem basic, but I suspect such churn
would pale in comparison to the overall support needed for RWX protections.

The kvm_memory_attributes structure is compatible, all that's needed AFAICT is a
union to clarify it's a pgoff instead of an address when used for guest_memfd.

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 52f6000ab020..e0d8255ac8d2 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1590,7 +1590,10 @@ struct kvm_stats_desc {
 #define KVM_SET_MEMORY_ATTRIBUTES              _IOW(KVMIO,  0xd2, struct kvm_memory_attributes)
 
 struct kvm_memory_attributes {
-       __u64 address;
+       union {
+               __u64 address;
+               __u64 offset;
+       };
        __u64 size;
        __u64 attributes;
        __u64 flags;

> +static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index);
> +
> +static struct kvm_gmem_inode_private *kvm_gmem_private(struct inode *inode)
> +{
> +	return inode->i_mapping->i_private_data;

This is a hilarious bad helper.  Everyone and their mother is going to think
about "private vs. shared" when they see kvm_gmem_private(), at least on the x86
side.

What's even more absurd is that the only "final" usage of the helper is to
free/destroy the inode:

  $ git grep kvm_gmem_private
  virt/kvm/guest_memfd.c:static struct kvm_gmem_inode_private *kvm_gmem_private(struct inode *inode)
  virt/kvm/guest_memfd.c: return kvm_gmem_private(inode)->allocator_ops;
  virt/kvm/guest_memfd.c: return kvm_gmem_private(inode)->allocator_private;
  virt/kvm/guest_memfd.c: mt = &kvm_gmem_private(inode)->shareability;
  virt/kvm/guest_memfd.c: mt = &kvm_gmem_private(inode)->shareability;
  virt/kvm/guest_memfd.c: mt = &kvm_gmem_private(inode)->shareability;
  virt/kvm/guest_memfd.c: mt = &kvm_gmem_private(inode)->shareability;
  virt/kvm/guest_memfd.c: struct kvm_gmem_inode_private *private = kvm_gmem_private(inode);
  virt/kvm/guest_memfd.c: struct kvm_gmem_inode_private *private = kvm_gmem_private(inode);

And in that case, using a wrapper is counter-productive, just reference
inode->i_mapping->i_private_data directly so that readeres don't have to jump
through a useless layer.

Luckily, "struct kvm_gmem_inode_private" no longer needs to exist, now that
Shivank's NUMA policy series wraps the vfs_inode with a gmem_inode, and can be
retrieved via GMEM_I().  FWIW, before looking that series, I was going to suggest
something like to_gmem(), but I definitely think we should follow filesystems
convention, not KVM vCPU/VM convention.

>   * folio_file_pfn - like folio_file_page, but return a pfn.
>   * @folio: The folio which contains this index.
> @@ -29,6 +48,58 @@ static inline kvm_pfn_t folio_file_pfn(struct folio *folio, pgoff_t index)
>  	return folio_pfn(folio) + (index & (folio_nr_pages(folio) - 1));
>  }
>  
> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> +
> +static int kvm_gmem_shareability_setup(struct kvm_gmem_inode_private *private,
> +				      loff_t size, u64 flags)
> +{
> +	enum shareability m;
> +	pgoff_t last;
> +
> +	last = (size >> PAGE_SHIFT) - 1;
> +	m = flags & GUEST_MEMFD_FLAG_INIT_PRIVATE ? SHAREABILITY_GUEST :
> +						    SHAREABILITY_ALL;
> +	return mtree_store_range(&private->shareability, 0, last, xa_mk_value(m),
> +				 GFP_KERNEL);
> +}
> +
> +static enum shareability kvm_gmem_shareability_get(struct inode *inode,
> +						 pgoff_t index)
> +{
> +	struct maple_tree *mt;
> +	void *entry;
> +
> +	mt = &kvm_gmem_private(inode)->shareability;
> +	entry = mtree_load(mt, index);
> +	WARN(!entry,

WARN_ON_ONCE(), otherwise we risk escalating a per-VM problem into a system-wide
DoS.

> +	     "Shareability should always be defined for all indices in inode.");
> +
> +	return xa_to_value(entry);
> +}
> +
> +static struct folio *kvm_gmem_get_shared_folio(struct inode *inode, pgoff_t index)
> +{
> +	if (kvm_gmem_shareability_get(inode, index) != SHAREABILITY_ALL)
> +		return ERR_PTR(-EACCES);
> +
> +	return kvm_gmem_get_folio(inode, index);

Please don't add 1-3 line helpers with one caller and very little hope of gaining
additional users, especially in guest_memfd where "shared" and "private" have
multiple meanings, and so things like "get_shared_folio" are inherently ambiguous.

I'm pretty sure a lot of this stems from CONFIG_KVM_GMEM_SHARED_MEM, which AFAICT
simply won't exist.  But just in case this is a Google3 pattern... 

> +}
> +
> +#else
> +
> +static int kvm_gmem_shareability_setup(struct maple_tree *mt, loff_t size, u64 flags)
> +{
> +	return 0;
> +}
> +
> +static inline struct folio *kvm_gmem_get_shared_folio(struct inode *inode, pgoff_t index)
> +{
> +	WARN_ONCE("Unexpected call to get shared folio.")
> +	return NULL;
> +}
> +
> +#endif /* CONFIG_KVM_GMEM_SHARED_MEM */
> +
>  static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>  				    pgoff_t index, struct folio *folio)
>  {
> @@ -333,7 +404,7 @@ static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
>  
>  	filemap_invalidate_lock_shared(inode->i_mapping);
>  
> -	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> +	folio = kvm_gmem_get_shared_folio(inode, vmf->pgoff);

I am fairly certain there's a TOCTOU bug here.  AFAICT, nothing prevents the
underlying memory from being converted from shared=>private after checking that
the page is SHARED.

The locking rules for the maple_tree are also undocumented and haphazard.  I think
we can kill several birds with one stone by protecting the attributes with
invalidate_lock.  A bonus with using invalidate_lock is that it's a sleepable
lock, not a spinlock.  I don't think there's anything that would immediately
benefit?  But if we wanted to populate the tree on-demand (versus pre-filling
all possible pages), then it'd be easier to handle things like allocations in a
race free manner.

	/*
	 * Protect the attributes with the invalidation lock, which will always
	 * be held on conversions
	 */
	mt_init_flags(&gi->attributes, MT_FLAGS_LOCK_EXTERN);
	mt_set_external_lock(&gi->attributes,
			     &inode->i_mapping->invalidate_lock);

