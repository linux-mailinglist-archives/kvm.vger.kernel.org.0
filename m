Return-Path: <kvm+bounces-59276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD205BAFF21
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 12:00:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51C9917DD49
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 10:00:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDCDD29BDA2;
	Wed,  1 Oct 2025 10:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zhjssJQy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ADC5270EDE
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 10:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759312835; cv=none; b=KiMiyTXkEaPGlqVKOTOoQcHsDZ+mwsMB0z7r+CZqMy2KhHYq2kKHNy4PfWDyoazZeIGk2wpeFFl9esf6HSRFByH7WjQ0LMnC/AsQRUhC2KFxo5h+zP9b7IHC0q2ZYfKTYOyu44ROcqYNu0n/jEXRxIwP8KXpsSbwqS0Mk8hx+lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759312835; c=relaxed/simple;
	bh=H3TDODa/l/wiO8Ra9Ela4YtRq8a5diFpTSoqQipaUhQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BxnYZm6wz8pTYE3bGCaHlh8Roj1n81CdIJjwPEQgaOiFcteeRjKGlqrvrJVgF/csSVqKVM0bv7cAGHL0Z6zD68c6yQlgtgeIJNXYkc34wwE4BtwVXwcEzFUM01IuXTqYspSGu+D+knGou0TCyHnLtXqB9HDgUoYupPQTbCs0Sb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zhjssJQy; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3307af9b55eso6059044a91.2
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 03:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759312832; x=1759917632; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nE/kAPloyk+vIitKqvItd7cTOgaxobjI+8lPWSREex4=;
        b=zhjssJQyMlJ3IXLfp8dy3F5yD6LfrDMaPAFM8vudMoBb31P7yYybm7f3pRJEEN7gED
         XYB0aLySqAWEzEecfpPJwupgDQdceaHB42oE0uHcnBHfrfxc9bsNDo6NeLujh78DMTuR
         iu06fNS193bRkdy436nhbN5dasAOjYYo0tdUrBlbHj7L3KiyUTMMVu5NoOTkRzT5qXAk
         BxKkoK8XkGKh4W4SdFcjZsh3sVkPE9BQ05y3DW4msawCCNGHXjlNaRXzqXY7f65RUttX
         wKfo5bQaWnyzhGhvD8GivgndxQtqXeCqJZK7OglHZUIqxYoiAgORQbOlXyNF84ZkGCMH
         pM2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759312832; x=1759917632;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nE/kAPloyk+vIitKqvItd7cTOgaxobjI+8lPWSREex4=;
        b=GGKa0YhWdqC5tcrxiZDLJPBAxm4Iim7MVXfQBqrm+EiUqvW7f5fHR14QBXC02zartc
         ruVUrbOyIIatHvHgCrUWQB4E35GDUQ5KRuo5dSndOdiDSSKNZ9LswUGpfjf5/MKRMVT9
         WmadMcbkoG3NyeJ+EZizNKVDNlUwLq4ry89Bi9jbBOyvON7+KXw4ErS4jGv4oJjqSwbs
         E7ldsDeJYY8CDTEfZCPRWn+EGvNyX/wmlhcaY29CspRS6yvjjb5JpX9Df7fLpY++HmKB
         6+I3ArWQ6FDGGNWEnA6NPOEcGTq56pBU255HvgvMbJsjzZmtuQ/ge3cvKFebAfRSpHCg
         LMBg==
X-Gm-Message-State: AOJu0Yz5ZvPxQ25QsPnPpBdCuXUrSoWjw6n3Ui61GIrX2ekLy70ZZwgz
	BN+VwOaKebVpjEW0eLFE5fAtiEcqp4eIHWG2OsEAj6zPNEhsK94223ZqgRe/n1xsZGBOSz7pAMI
	c1NjSu9vy3JHebyv/4IvtX8hu/g==
X-Google-Smtp-Source: AGHT+IEqSr8kTQUFBD7R6EE0q+2GCBiFIJAcxUWGdcy5F1b5JeOAUPNVzgyE8ySwzEClSamwyt7lcH+mVn3rvlmfIQ==
X-Received: from pjbmt19.prod.google.com ([2002:a17:90b:2313:b0:32b:35fb:187f])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1c04:b0:32b:d8af:b636 with SMTP id 98e67ed59e1d1-339a6f3cd4bmr2802820a91.19.1759312832562;
 Wed, 01 Oct 2025 03:00:32 -0700 (PDT)
Date: Wed, 01 Oct 2025 10:00:31 +0000
In-Reply-To: <aNxqYMqtBKll-TgV@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <b784326e9ccae6a08388f1bf39db70a2204bdc51.1747264138.git.ackerleytng@google.com>
 <aNxqYMqtBKll-TgV@google.com>
Message-ID: <diqzbjmrt000.fsf@google.com>
Subject: Re: [RFC PATCH v2 02/51] KVM: guest_memfd: Introduce and use
 shareability to guard faulting
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Fuad Tabba <tabba@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Michael Roth <michael.roth@amd.com>, 
	Ira Weiny <ira.weiny@intel.com>, Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, David Hildenbrand <david@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> Trimmed the Cc substantially as I doubt non-gmem/KVM folks will be excited about
> thread necromancy.
>
> On Wed, May 14, 2025, Ackerley Tng wrote:
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index 86f74ce7f12a..f609337ae1c2 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -6408,6 +6408,11 @@ belonging to the slot via its userspace_addr.
>>  The use of GUEST_MEMFD_FLAG_SUPPORT_SHARED will not be allowed for CoCo VMs.
>>  This is validated when the guest_memfd instance is bound to the VM.
>>  
>> +If the capability KVM_CAP_GMEM_CONVERSIONS is supported, then the 'flags' field
>> +supports GUEST_MEMFD_FLAG_INIT_PRIVATE.  Setting GUEST_MEMFD_FLAG_INIT_PRIVATE
>> +will initialize the memory for the guest_memfd as guest-only and not faultable
>> +by the host.
>
> Whatever documentation we add should land at the same time as the collateral.
> KVM_CAP_GMEM_CONVERSIONS literally doesn't exist at this time.
>

Thanks, will keep this in mind for next time.

>> @@ -17,6 +18,24 @@ struct kvm_gmem {
>>  	struct list_head entry;
>>  };
>>  
>> +struct kvm_gmem_inode_private {
>> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
>> +	struct maple_tree shareability;
>> +#endif
>> +};
>> +
>> +enum shareability {
>> +	SHAREABILITY_GUEST = 1,	/* Only the guest can map (fault) folios in this range. */
>> +	SHAREABILITY_ALL = 2,	/* Both guest and host can fault folios in this range. */
>> +};
>
> Rather than define new values and new KVM uAPI, I think we should instead simply
> support KVM_SET_MEMORY_ATTRIBUTES.  We'll probably need a new CAP, as I'm not sure
> supporting KVM_CHECK_EXTENSION+KVM_CAP_MEMORY_ATTRIBUTES on a gmem fd would be a
> good idea (e.g. trying to do KVM_CAP_GUEST_MEMFD_FLAGS on a gmem fd doesn't work
> because the whole point is to get flags _before_ creating the gmem instance).  But
> adding e.g. KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES is easy enough.
>

I've read this a few times and I'm a bit confused, so just making sure:
you are suggesting that we reuse the KVM_SET_MEMORY_ATTRIBUTES ioctl as
a guest_memfd (not a VM) ioctl and still store private/shared state
within guest_memfd, right?

I think fundamentally the introduction of the guest_memfd ioctls was
motivated by how private/shared state is a property of memory and not a
property of the VM. (IIRC you were the one to most succinctly phrase it
this way on one of the guest_memfd biweeklies.) So I hope you don't mean
to revert to doing conversions through a VM ioctl.

> But for specifying PRIVATE vs. SHARED, I don't see any reason to define new uAPI.
> I also don't want an entirely new set of terms in KVM to describe the same things.
> PRIVATE and SHARED are far from perfect, but they're better than https://xkcd.com/927.
> And if we ever want to let userspace restrict RWX protections in gmem, we'll have
> a ready-made way to do so.  
>

Would like to understand more about RWX protections: is the use case to
let userspace specify that certain ranges of guest memory are to be
mapped into stage 2 page tables without executable permissions?

Is there a further use case to let the guest specify that userspace must
not mmap() some ranges as executable?

For guest_memfd the userspace mapping permissions are already defined
by userspace and so unless guest_memfd must enforce something on behalf
of the guest, there shouldn't be anything more that guest_memfd should
track with respect to RWX permissions.

> Internally, that let's us do some fun things in KVM.  E.g. if we make the "disable
> legacy per-VM memory attributes" a read-only module param, then we can wire up a
> static_call() for kvm_get_memory_attributes() and then kvm_mem_is_private() will
> Just Work.
>
>   static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
>   {
> 	return static_call(__kvm_get_memory_attributes)(kvm, gfn);
>   }
>
>   static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>   {
> 	return kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
>   }
>
> That might trigger some additional surgery if/when we want to support RWX
> protections on a per-VM basis _and_ a per-gmem basic, but I suspect such churn
> would pale in comparison to the overall support needed for RWX protections.
>

RWX protections are more of a VM-level property, if I understood the use
case correctly that some gfn ranges are to be marked non-executable by
userspace. Setting RWX within guest_memfd would be kind of awkward since
userspace must first translate GFN to offset, then set it using the
offset within guest_memfd. Hence I think it's okay to have RWX stuff go
through the regular KVM_SET_MEMORY_ATTRIBUTES *VM* ioctl and have it
tracked in mem_attr_array.

I'd prefer not to have the module param choose between the use of
mem_attr_array and guest_memfd conversion in case we need both
mem_attr_array to support other stuff in future while supporting
conversions.

> The kvm_memory_attributes structure is compatible, all that's needed AFAICT is a
> union to clarify it's a pgoff instead of an address when used for guest_memfd.
>
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 52f6000ab020..e0d8255ac8d2 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1590,7 +1590,10 @@ struct kvm_stats_desc {
>  #define KVM_SET_MEMORY_ATTRIBUTES              _IOW(KVMIO,  0xd2, struct kvm_memory_attributes)
>  
>  struct kvm_memory_attributes {
> -       __u64 address;
> +       union {
> +               __u64 address;
> +               __u64 offset;
> +       };
>         __u64 size;
>         __u64 attributes;
>         __u64 flags;
>

struct kvm_memory_attributes doesn't have room for reporting the offset
at which conversion failed (error_offset in the new struct). How do we
handle this? Do we reuse the flags field, or do we not report
error_offset?

>> +static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index);
>> +
>> +static struct kvm_gmem_inode_private *kvm_gmem_private(struct inode *inode)
>> +{
>> +	return inode->i_mapping->i_private_data;
>
> This is a hilarious bad helper.  Everyone and their mother is going to think
> about "private vs. shared" when they see kvm_gmem_private(), at least on the x86
> side.
>

Totally missed this interpretation of private, lol. Too many
interpretations of private: MAP_PRIVATE, CoCo's private vs shared, and
i_private_data.

> What's even more absurd is that the only "final" usage of the helper is to
> free/destroy the inode:
>
>   $ git grep kvm_gmem_private
>   virt/kvm/guest_memfd.c:static struct kvm_gmem_inode_private *kvm_gmem_private(struct inode *inode)
>   virt/kvm/guest_memfd.c: return kvm_gmem_private(inode)->allocator_ops;
>   virt/kvm/guest_memfd.c: return kvm_gmem_private(inode)->allocator_private;
>   virt/kvm/guest_memfd.c: mt = &kvm_gmem_private(inode)->shareability;
>   virt/kvm/guest_memfd.c: mt = &kvm_gmem_private(inode)->shareability;
>   virt/kvm/guest_memfd.c: mt = &kvm_gmem_private(inode)->shareability;
>   virt/kvm/guest_memfd.c: mt = &kvm_gmem_private(inode)->shareability;
>   virt/kvm/guest_memfd.c: struct kvm_gmem_inode_private *private = kvm_gmem_private(inode);
>   virt/kvm/guest_memfd.c: struct kvm_gmem_inode_private *private = kvm_gmem_private(inode);
>
> And in that case, using a wrapper is counter-productive, just reference
> inode->i_mapping->i_private_data directly so that readeres don't have to jump
> through a useless layer.
>
> Luckily, "struct kvm_gmem_inode_private" no longer needs to exist, now that
> Shivank's NUMA policy series wraps the vfs_inode with a gmem_inode, and can be
> retrieved via GMEM_I().  FWIW, before looking that series, I was going to suggest
> something like to_gmem(), but I definitely think we should follow filesystems
> convention, not KVM vCPU/VM convention.
>

I'll align with the wrapper struct to align with filesystems conventions then.

>>   * folio_file_pfn - like folio_file_page, but return a pfn.
>>   * @folio: The folio which contains this index.
>> @@ -29,6 +48,58 @@ static inline kvm_pfn_t folio_file_pfn(struct folio *folio, pgoff_t index)
>>  	return folio_pfn(folio) + (index & (folio_nr_pages(folio) - 1));
>>  }
>>  
>> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
>> +
>> +static int kvm_gmem_shareability_setup(struct kvm_gmem_inode_private *private,
>> +				      loff_t size, u64 flags)
>> +{
>> +	enum shareability m;
>> +	pgoff_t last;
>> +
>> +	last = (size >> PAGE_SHIFT) - 1;
>> +	m = flags & GUEST_MEMFD_FLAG_INIT_PRIVATE ? SHAREABILITY_GUEST :
>> +						    SHAREABILITY_ALL;
>> +	return mtree_store_range(&private->shareability, 0, last, xa_mk_value(m),
>> +				 GFP_KERNEL);
>> +}
>> +
>> +static enum shareability kvm_gmem_shareability_get(struct inode *inode,
>> +						 pgoff_t index)
>> +{
>> +	struct maple_tree *mt;
>> +	void *entry;
>> +
>> +	mt = &kvm_gmem_private(inode)->shareability;
>> +	entry = mtree_load(mt, index);
>> +	WARN(!entry,
>
> WARN_ON_ONCE(), otherwise we risk escalating a per-VM problem into a system-wide
> DoS.
>

Will take note for next time.

>> +	     "Shareability should always be defined for all indices in inode.");
>> +
>> +	return xa_to_value(entry);
>> +}
>> +
>> +static struct folio *kvm_gmem_get_shared_folio(struct inode *inode, pgoff_t index)
>> +{
>> +	if (kvm_gmem_shareability_get(inode, index) != SHAREABILITY_ALL)
>> +		return ERR_PTR(-EACCES);
>> +
>> +	return kvm_gmem_get_folio(inode, index);
>
> Please don't add 1-3 line helpers with one caller and very little hope of gaining
> additional users, especially in guest_memfd where "shared" and "private" have
> multiple meanings, and so things like "get_shared_folio" are inherently ambiguous.
>
> I'm pretty sure a lot of this stems from CONFIG_KVM_GMEM_SHARED_MEM, which AFAICT
> simply won't exist.  But just in case this is a Google3 pattern... 
>

Will take note for next time.

>> +}
>> +
>> +#else
>> +
>> +static int kvm_gmem_shareability_setup(struct maple_tree *mt, loff_t size, u64 flags)
>> +{
>> +	return 0;
>> +}
>> +
>> +static inline struct folio *kvm_gmem_get_shared_folio(struct inode *inode, pgoff_t index)
>> +{
>> +	WARN_ONCE("Unexpected call to get shared folio.")
>> +	return NULL;
>> +}
>> +
>> +#endif /* CONFIG_KVM_GMEM_SHARED_MEM */
>> +
>>  static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>>  				    pgoff_t index, struct folio *folio)
>>  {
>> @@ -333,7 +404,7 @@ static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
>>  
>>  	filemap_invalidate_lock_shared(inode->i_mapping);
>>  
>> -	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
>> +	folio = kvm_gmem_get_shared_folio(inode, vmf->pgoff);
>
> I am fairly certain there's a TOCTOU bug here.  AFAICT, nothing prevents the
> underlying memory from being converted from shared=>private after checking that
> the page is SHARED.
>

Conversions take the filemap_invalidate_lock() too, along with
allocations, truncations.

Because the filemap_invalidate_lock() might be reused for other
fs-specific operations, I didn't do the mt_set_external_lock() thing to
lock at a low level to avoid nested locking or special maple tree code
to avoid taking the lock on other paths.

> The locking rules for the maple_tree are also undocumented and haphazard.  I think
> we can kill several birds with one stone by protecting the attributes with
> invalidate_lock.  A bonus with using invalidate_lock is that it's a sleepable
> lock, not a spinlock.  I don't think there's anything that would immediately
> benefit?  But if we wanted to populate the tree on-demand (versus pre-filling
> all possible pages), then it'd be easier to handle things like allocations in a
> race free manner.
>
> 	/*
> 	 * Protect the attributes with the invalidation lock, which will always
> 	 * be held on conversions
> 	 */
> 	mt_init_flags(&gi->attributes, MT_FLAGS_LOCK_EXTERN);
> 	mt_set_external_lock(&gi->attributes,
> 			     &inode->i_mapping->invalidate_lock);


