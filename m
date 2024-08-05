Return-Path: <kvm+bounces-23244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 11AE694801C
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 19:15:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 93BAF1F22185
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 17:15:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 195F815ECC9;
	Mon,  5 Aug 2024 17:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4pzluJLz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF7C155351
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 17:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722878094; cv=none; b=BzB5fYCUglkKME1mwE918jjJHTDMRmC1FpPY4zkP5tiWl7gsy74Jx1ECyuqJM2GXAlm+c+37cf0xpwBPsnPPNkeCoYEXtQhWjxwE/D4DWG9zJSxZ/MLMe+EZ2XQSlv9em8154dVKB7Cn/mHeQSeVNXML/Toa2REYeI6Qj5UKPSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722878094; c=relaxed/simple;
	bh=Mw+Irj5W4G0McjSAZ0h70Mh/77qaTYmCz8c4+fPwtzE=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=JTv7drrgUmRphhhfOInTd4WBDrp+vCAl4JlqgQwJ3rV0r853nd+5z/Yb51mAFaThBdLn4EcvMsKt2EeScphbkPHqIhMop/F7dc2jckZnk/itSIGHs9htunx1GYWlt0oagAHg4RL8K3x0GeBDtUHSijqNXBh2dvaSv/kxjjvs9E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4pzluJLz; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-65b985bb059so223055787b3.2
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 10:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722878091; x=1723482891; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8BQzKusmbkBsKadVmpz8rBLriYOIPAEaMXZWFCukOU4=;
        b=4pzluJLzCdpqetxL7NIiI4vSXTDAQBW2+CChxm06hJsW6G1uFP26YcQCdTkTQXI+c5
         AvPSJmP1rvpe31pNZZi6zloNuMi64emCgchOBAbeoNVv1Dn0zo/Co5anruYc6gLAyr0l
         yJurPuhavC2pzLKs+1ululAHl5kinhZmnupr1erx8cWWU2bepbD6th1xkSlck3tmyLx6
         xLihM5a9p++MLkpmaE3MyXWubwSaxhia9VuiMZ+Xf0W11EOxyjrc0pOuqT9UpPDdo9mp
         UP8pYcd8YjSbNVDg5c2LL3zCqMbQBh8mnNYpOt6HaTErP/ly1X6TXG7nYSUsmzmhXA4j
         eyMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722878091; x=1723482891;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8BQzKusmbkBsKadVmpz8rBLriYOIPAEaMXZWFCukOU4=;
        b=B+R77Bt3UvDydRvkxo4UTUvzeoeixWVa5laBygJOI+h31aQWDtT/3Y+96oXoI011dn
         2Ygjo4eYai86Ul0N4m0LhjPUM3hpZaAZFygo88eFeUudML4AumLpaiAas3J/Kb9mkJv9
         Dv87CoTdvp1OZDLcjQqy+xSNp4hvFEwXznwTH/qe9L3Uwx/hHl3T6hqMtIwLxTGd60Li
         hRK8LUB54fxlMMggxzGTyZI95Oi2cgclugk5tt73JuoeHuFDYWgbbemz+Znp/x9DvNoA
         T5cPbwY3qvdMVGthKIctjfkXcHkQ+LWkyRFyjRDx9EZUnnu2t6OWDN7UadK/6EZeutev
         meBA==
X-Gm-Message-State: AOJu0Yx2IyHdS2ZYxV/7LH2HdYHbUHgQtsfgFRzwCk/RRukb4MKDfxI3
	leNzsaRAN49+xGEKNUsZom0t0CbQaFU7/b6WIpDGZCy75WGxen6vsOYGnjn7uzuXWQjDzncnRra
	6XNoyjaIrdp1CY0owQZtQjA==
X-Google-Smtp-Source: AGHT+IHo9MyT37hyr05KIDU8qMvyGuyveSowz9yenDp6BzulynEStWda5OSovvLwH92Q8aoAjhV8J4U3hx6M2mp9IQ==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:13f8])
 (user=ackerleytng job=sendgmr) by 2002:a05:6902:2b12:b0:e03:6556:9fb5 with
 SMTP id 3f1490d57ef6-e0bde481682mr266959276.11.1722878091228; Mon, 05 Aug
 2024 10:14:51 -0700 (PDT)
Date: Mon, 05 Aug 2024 17:14:49 +0000
In-Reply-To: <20240801090117.3841080-3-tabba@google.com> (message from Fuad
 Tabba on Thu,  1 Aug 2024 10:01:09 +0100)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqzcymmevsm.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH v2 02/10] KVM: Add restricted support for mapping
 guestmem by the host
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
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Fuad Tabba <tabba@google.com> writes:

> Add support for mmap() and fault() for guest_memfd in the host.
> The ability to fault in a guest page is contingent on that page
> being shared with the host. To track this, this patch adds a new
> xarray to each guest_memfd object, which tracks the mappability
> of guest frames.
>
> The guest_memfd PRIVATE memory attribute is not used for two
> reasons. First because it reflects the userspace expectation for
> that memory location, and therefore can be toggled by userspace.

Thank you for clarifying why the PRIVATE memory attribute cannot be
used. I think that having the attributes with guest_memfd is a good
idea.

Since faultability is a property of the memory contents, shouldn't
faultability be stored on the inode rather than the file?

> The second is, although each guest_memfd file has a 1:1 binding
> with a KVM instance, the plan is to allow multiple files per
> inode, e.g. to allow intra-host migration to a new KVM instance,
> without destroying guest_memfd.

I think you also alluded to the concept of inodes vs files above.

To store the xarray on the inode, we would probably have to make
guest_memfd use its own mount so that we can use .evict_inode() from
struct address_space_operations to clean up the inode neatly, perhaps
the way it was done in guest_memfd v12 [1].

This RFC to enable intra-host migration [2] was built with the version
of guest_memfd that used its own mount. IIUC, the gmem struct stored on
the file is meant to be the binding between struct kvm and the memory
contents [3], so the gmem struct won't be transferred and a new gmem
struct will be created.

>
> This new feature is gated with a new configuration option,
> CONFIG_KVM_PRIVATE_MEM_MAPPABLE.
>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  include/linux/kvm_host.h |  61 ++++++++++++++++++++
>  virt/kvm/Kconfig         |   4 ++
>  virt/kvm/guest_memfd.c   | 110 +++++++++++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c      | 122 +++++++++++++++++++++++++++++++++++++++
>  4 files changed, 297 insertions(+)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 43a157f8171a..ab1344327e57 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2452,4 +2452,65 @@ static inline int kvm_gmem_get_pfn_locked(struct kvm *kvm,
>  }
>  #endif /* CONFIG_KVM_PRIVATE_MEM */
>
> +#ifdef CONFIG_KVM_PRIVATE_MEM_MAPPABLE
> +bool kvm_gmem_is_mappable(struct kvm *kvm, gfn_t gfn, gfn_t end);
> +bool kvm_gmem_is_mapped(struct kvm *kvm, gfn_t start, gfn_t end);
> +int kvm_gmem_set_mappable(struct kvm *kvm, gfn_t start, gfn_t end);

How will kvm_gmem_is_mapped() and kvm_gmem_set_mappable() be used?

> +int kvm_gmem_clear_mappable(struct kvm *kvm, gfn_t start, gfn_t end);
> +int kvm_slot_gmem_toggle_mappable(struct kvm_memory_slot *slot, gfn_t start,
> +				  gfn_t end, bool is_mappable);
> +int kvm_slot_gmem_set_mappable(struct kvm_memory_slot *slot, gfn_t start,
> +			       gfn_t end);
> +int kvm_slot_gmem_clear_mappable(struct kvm_memory_slot *slot, gfn_t start,
> +				 gfn_t end);
> +bool kvm_slot_gmem_is_mappable(struct kvm_memory_slot *slot, gfn_t gfn);
> +#else
> +static inline bool kvm_gmem_is_mappable(struct kvm *kvm, gfn_t gfn, gfn_t end)
> +{
> +	WARN_ON_ONCE(1);
> +	return false;
> +}
> +static inline bool kvm_gmem_is_mapped(struct kvm *kvm, gfn_t start, gfn_t end)
> +{
> +	WARN_ON_ONCE(1);
> +	return false;
> +}
> +static inline int kvm_gmem_set_mappable(struct kvm *kvm, gfn_t start, gfn_t end)
> +{
> +	WARN_ON_ONCE(1);
> +	return -EINVAL;
> +}
> +static inline int kvm_gmem_clear_mappable(struct kvm *kvm, gfn_t start,
> +					  gfn_t end)
> +{
> +	WARN_ON_ONCE(1);
> +	return -EINVAL;
> +}
> +static inline int kvm_slot_gmem_toggle_mappable(struct kvm_memory_slot *slot,
> +						gfn_t start, gfn_t end,
> +						bool is_mappable)
> +{
> +	WARN_ON_ONCE(1);
> +	return -EINVAL;
> +}
> +static inline int kvm_slot_gmem_set_mappable(struct kvm_memory_slot *slot,
> +					     gfn_t start, gfn_t end)
> +{
> +	WARN_ON_ONCE(1);
> +	return -EINVAL;
> +}
> +static inline int kvm_slot_gmem_clear_mappable(struct kvm_memory_slot *slot,
> +					       gfn_t start, gfn_t end)
> +{
> +	WARN_ON_ONCE(1);
> +	return -EINVAL;
> +}
> +static inline bool kvm_slot_gmem_is_mappable(struct kvm_memory_slot *slot,
> +					     gfn_t gfn)
> +{
> +	WARN_ON_ONCE(1);
> +	return false;
> +}
> +#endif /* CONFIG_KVM_PRIVATE_MEM_MAPPABLE */
> +
>  #endif
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 29b73eedfe74..a3970c5eca7b 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -109,3 +109,7 @@ config KVM_GENERIC_PRIVATE_MEM
>         select KVM_GENERIC_MEMORY_ATTRIBUTES
>         select KVM_PRIVATE_MEM
>         bool
> +
> +config KVM_PRIVATE_MEM_MAPPABLE
> +       select KVM_PRIVATE_MEM
> +       bool
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index f3f4334a9ccb..0a1f266a16f9 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -11,6 +11,9 @@ struct kvm_gmem {
>  	struct kvm *kvm;
>  	struct xarray bindings;
>  	struct list_head entry;
> +#ifdef CONFIG_KVM_PRIVATE_MEM_MAPPABLE
> +	struct xarray unmappable_gfns;
> +#endif
>  };
>
>  static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
> @@ -230,6 +233,11 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
>  	mutex_unlock(&kvm->slots_lock);
>
>  	xa_destroy(&gmem->bindings);
> +
> +#ifdef CONFIG_KVM_PRIVATE_MEM_MAPPABLE
> +	xa_destroy(&gmem->unmappable_gfns);
> +#endif
> +
>  	kfree(gmem);
>
>  	kvm_put_kvm(kvm);
> @@ -248,7 +256,105 @@ static inline struct file *kvm_gmem_get_file(struct kvm_memory_slot *slot)
>  	return get_file_active(&slot->gmem.file);
>  }
>
> +#ifdef CONFIG_KVM_PRIVATE_MEM_MAPPABLE
> +int kvm_slot_gmem_toggle_mappable(struct kvm_memory_slot *slot, gfn_t start,
> +				  gfn_t end, bool is_mappable)
> +{
> +	struct kvm_gmem *gmem = slot->gmem.file->private_data;
> +	void *xval = is_mappable ? NULL : xa_mk_value(true);

IIUC storing stuff in the xarray takes memory, so if we want to save
memory, we should minimize entries in the xarray. For pKVM, do you
expect more mappable, or more unmappable gfns?

For TDX most of the memory will be private, so we expect fewer mappable
gfns, and we'd prefer "entry in xarray == mappable".

> +	void *r;
> +
> +	r = xa_store_range(&gmem->unmappable_gfns, start, end - 1, xval, GFP_KERNEL);
> +
> +	return xa_err(r);
> +}
> +
> +int kvm_slot_gmem_set_mappable(struct kvm_memory_slot *slot, gfn_t start, gfn_t end)
> +{
> +	return kvm_slot_gmem_toggle_mappable(slot, start, end, true);
> +}
> +
> +int kvm_slot_gmem_clear_mappable(struct kvm_memory_slot *slot, gfn_t start, gfn_t end)
> +{
> +	return kvm_slot_gmem_toggle_mappable(slot, start, end, false);
> +}
> +
> +bool kvm_slot_gmem_is_mappable(struct kvm_memory_slot *slot, gfn_t gfn)
> +{
> +	struct kvm_gmem *gmem = slot->gmem.file->private_data;
> +	unsigned long _gfn = gfn;
> +
> +	return !xa_find(&gmem->unmappable_gfns, &_gfn, ULONG_MAX, XA_PRESENT);
> +}
> +
> +static bool kvm_gmem_isfaultable(struct vm_fault *vmf)
> +{
> +	struct kvm_gmem *gmem = vmf->vma->vm_file->private_data;
> +	struct inode *inode = file_inode(vmf->vma->vm_file);
> +	pgoff_t pgoff = vmf->pgoff;
> +	struct kvm_memory_slot *slot;
> +	unsigned long index;
> +	bool r = true;
> +
> +	filemap_invalidate_lock(inode->i_mapping);
> +
> +	xa_for_each_range(&gmem->bindings, index, slot, pgoff, pgoff) {
> +		pgoff_t base_gfn = slot->base_gfn;
> +		pgoff_t gfn_pgoff = slot->gmem.pgoff;
> +		pgoff_t gfn = base_gfn + max(gfn_pgoff, pgoff) - gfn_pgoff;
> +
> +		if (!kvm_slot_gmem_is_mappable(slot, gfn)) {
> +			r = false;
> +			break;
> +		}
> +	}
> +
> +	filemap_invalidate_unlock(inode->i_mapping);
> +
> +	return r;
> +}
> +
> +static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
> +{
> +	struct folio *folio;
> +
> +	folio = kvm_gmem_get_folio(file_inode(vmf->vma->vm_file), vmf->pgoff);
> +	if (!folio)
> +		return VM_FAULT_SIGBUS;
> +
> +	if (!kvm_gmem_isfaultable(vmf)) {
> +		folio_unlock(folio);
> +		folio_put(folio);
> +		return VM_FAULT_SIGBUS;
> +	}
> +
> +	vmf->page = folio_file_page(folio, vmf->pgoff);
> +	return VM_FAULT_LOCKED;
> +}
> +
> +static const struct vm_operations_struct kvm_gmem_vm_ops = {
> +	.fault = kvm_gmem_fault,
> +};
> +
> +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
> +	    (VM_SHARED | VM_MAYSHARE)) {
> +		return -EINVAL;
> +	}
> +
> +	file_accessed(file);
> +	vm_flags_set(vma, VM_DONTDUMP);
> +	vma->vm_ops = &kvm_gmem_vm_ops;
> +
> +	return 0;
> +}
> +#else
> +#define kvm_gmem_mmap NULL
> +#endif /* CONFIG_KVM_PRIVATE_MEM_MAPPABLE */
> +
>  static struct file_operations kvm_gmem_fops = {
> +	.mmap		= kvm_gmem_mmap,
>  	.open		= generic_file_open,
>  	.release	= kvm_gmem_release,
>  	.fallocate	= kvm_gmem_fallocate,
> @@ -369,6 +475,10 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>  	xa_init(&gmem->bindings);
>  	list_add(&gmem->entry, &inode->i_mapping->i_private_list);
>
> +#ifdef CONFIG_KVM_PRIVATE_MEM_MAPPABLE
> +	xa_init(&gmem->unmappable_gfns);
> +#endif
> +
>  	fd_install(fd, file);
>  	return fd;
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 1192942aef91..f4b4498d4de6 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3265,6 +3265,128 @@ static int next_segment(unsigned long len, int offset)
>  		return len;
>  }
>
> +#ifdef CONFIG_KVM_PRIVATE_MEM_MAPPABLE
> +static bool __kvm_gmem_is_mappable(struct kvm *kvm, gfn_t start, gfn_t end)
> +{
> +	struct kvm_memslot_iter iter;
> +
> +	lockdep_assert_held(&kvm->slots_lock);
> +
> +	kvm_for_each_memslot_in_gfn_range(&iter, kvm_memslots(kvm), start, end) {
> +		struct kvm_memory_slot *memslot = iter.slot;
> +		gfn_t gfn_start, gfn_end, i;
> +
> +		gfn_start = max(start, memslot->base_gfn);
> +		gfn_end = min(end, memslot->base_gfn + memslot->npages);
> +		if (WARN_ON_ONCE(gfn_start >= gfn_end))
> +			continue;
> +
> +		for (i = gfn_start; i < gfn_end; i++) {
> +			if (!kvm_slot_gmem_is_mappable(memslot, i))
> +				return false;
> +		}
> +	}
> +
> +	return true;
> +}
> +
> +bool kvm_gmem_is_mappable(struct kvm *kvm, gfn_t start, gfn_t end)
> +{
> +	bool r;
> +
> +	mutex_lock(&kvm->slots_lock);
> +	r = __kvm_gmem_is_mappable(kvm, start, end);
> +	mutex_unlock(&kvm->slots_lock);
> +
> +	return r;
> +}
> +
> +static bool __kvm_gmem_is_mapped(struct kvm *kvm, gfn_t start, gfn_t end)
> +{
> +	struct kvm_memslot_iter iter;
> +
> +	lockdep_assert_held(&kvm->slots_lock);
> +
> +	kvm_for_each_memslot_in_gfn_range(&iter, kvm_memslots(kvm), start, end) {
> +		struct kvm_memory_slot *memslot = iter.slot;
> +		gfn_t gfn_start, gfn_end, i;
> +
> +		gfn_start = max(start, memslot->base_gfn);
> +		gfn_end = min(end, memslot->base_gfn + memslot->npages);
> +		if (WARN_ON_ONCE(gfn_start >= gfn_end))
> +			continue;
> +
> +		for (i = gfn_start; i < gfn_end; i++) {
> +			struct page *page;
> +			bool is_mapped;
> +			kvm_pfn_t pfn;
> +
> +			if (WARN_ON_ONCE(kvm_gmem_get_pfn_locked(kvm, memslot, i, &pfn, NULL)))
> +				continue;
> +
> +			page = pfn_to_page(pfn);
> +			is_mapped = page_mapped(page) || page_maybe_dma_pinned(page);
> +			unlock_page(page);
> +			put_page(page);
> +
> +			if (is_mapped)
> +				return true;
> +		}
> +	}
> +
> +	return false;
> +}
> +
> +bool kvm_gmem_is_mapped(struct kvm *kvm, gfn_t start, gfn_t end)
> +{
> +	bool r;
> +
> +	mutex_lock(&kvm->slots_lock);
> +	r = __kvm_gmem_is_mapped(kvm, start, end);
> +	mutex_unlock(&kvm->slots_lock);
> +
> +	return r;
> +}
> +
> +static int kvm_gmem_toggle_mappable(struct kvm *kvm, gfn_t start, gfn_t end,
> +				    bool is_mappable)
> +{
> +	struct kvm_memslot_iter iter;
> +	int r = 0;
> +
> +	mutex_lock(&kvm->slots_lock);
> +
> +	kvm_for_each_memslot_in_gfn_range(&iter, kvm_memslots(kvm), start, end) {
> +		struct kvm_memory_slot *memslot = iter.slot;
> +		gfn_t gfn_start, gfn_end;
> +
> +		gfn_start = max(start, memslot->base_gfn);
> +		gfn_end = min(end, memslot->base_gfn + memslot->npages);
> +		if (WARN_ON_ONCE(start >= end))
> +			continue;
> +
> +		r = kvm_slot_gmem_toggle_mappable(memslot, gfn_start, gfn_end, is_mappable);
> +		if (WARN_ON_ONCE(r))
> +			break;
> +	}
> +
> +	mutex_unlock(&kvm->slots_lock);
> +
> +	return r;
> +}
> +
> +int kvm_gmem_set_mappable(struct kvm *kvm, gfn_t start, gfn_t end)
> +{
> +	return kvm_gmem_toggle_mappable(kvm, start, end, true);
> +}
> +
> +int kvm_gmem_clear_mappable(struct kvm *kvm, gfn_t start, gfn_t end)
> +{
> +	return kvm_gmem_toggle_mappable(kvm, start, end, false);
> +}
> +
> +#endif /* CONFIG_KVM_PRIVATE_MEM_MAPPABLE */
> +
>  /* Copy @len bytes from guest memory at '(@gfn * PAGE_SIZE) + @offset' to @data */
>  static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
>  				 void *data, int offset, int len)

[1] https://lore.kernel.org/all/20230914015531.1419405-15-seanjc@google.com/
[2] https://lore.kernel.org/all/cover.1691446946.git.ackerleytng@google.com/T/
[3] https://lore.kernel.org/all/ZQOmcc969s90DwNz@google.com/

