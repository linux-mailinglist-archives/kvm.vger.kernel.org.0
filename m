Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F035816AC9C
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 18:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbgBXRFr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 12:05:47 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53483 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727259AbgBXRFq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 12:05:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582563945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=APSdrhGv5raplzY6i75KWcyOo+Dgfm4GE5GDcIoP7hg=;
        b=YHFndL2brV1KIoi2gdYwchm6zejN/FX7ARpabi483I4DrSjPyXu0i6QgGHeiTh6SpuUZq0
        d/bCOoO4M0QUH8Heh22vYJIcLLwitgLA6lQHzTvTBMhvSusqg5CQYG8f7UPVEaGZ8scgFQ
        t+iM2BG3oOqkFKxAkt6B4EX3N/m4TdA=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-cF6tQdBqPsadpUfOXqU9tQ-1; Mon, 24 Feb 2020 12:05:42 -0500
X-MC-Unique: cF6tQdBqPsadpUfOXqU9tQ-1
Received: by mail-qk1-f197.google.com with SMTP id o22so11337144qko.2
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 09:05:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=APSdrhGv5raplzY6i75KWcyOo+Dgfm4GE5GDcIoP7hg=;
        b=hTJAhMkOTDNmwciy0b68RYf50k1DwZHfUr7fLHdX1Xj72cDwZAIqd48KooaT4ZgA4m
         p+tOhupA1KSYqfdO+2i8pQ3feQryJmGI2yvNS6/YHVqRG8b28iLbefk+NC0kD5fLUNJy
         IZiCaMPJxkkrr6k9f2fzc78PF9lqjVRqTphBqNIthmCjNdRKkWXjzj8wvGNnCHETcdBU
         e43PCyEfvFgsKTl5AaF+Z0g7qSZpMJdtSc6ygmUooWc21XT8bP2RvZmX+DV7BGU2FPOW
         91toAr3i6lq+F1fFL29PPMDwdBTRhiOI2NslGwHuV6+uQQZ9JwyVduwcGKhFCm1iaxgq
         viMg==
X-Gm-Message-State: APjAAAVqa1HWaeoKioou2MhSDMY6ehRnhHPzd3N454pBw8xFhw9v/g7N
        MqI1aMFuaxMgdUkyIGVEvW47GWqAEl8U1iqb9WRNcuMsdMin3I0Mj8TMvwfPNrAL6KNPHfY0qq1
        vnTiyXpiRLt5P
X-Received: by 2002:a37:a00e:: with SMTP id j14mr9635223qke.464.1582563941537;
        Mon, 24 Feb 2020 09:05:41 -0800 (PST)
X-Google-Smtp-Source: APXvYqzOhco545pi1Mc1TmwoFaZrnSVHVQG6JDOG70N9dneMzGk6ijHALjxEfTtSJQ1GJohn0W5o9A==
X-Received: by 2002:a37:a00e:: with SMTP id j14mr9635173qke.464.1582563941060;
        Mon, 24 Feb 2020 09:05:41 -0800 (PST)
Received: from xz-x1 ([104.156.64.75])
        by smtp.gmail.com with ESMTPSA id g62sm6058811qkd.25.2020.02.24.09.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 09:05:39 -0800 (PST)
Date:   Mon, 24 Feb 2020 12:05:38 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Jay Zhou <jianjay.zhou@huawei.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wangxinxin.wang@huawei.com,
        weidong.huang@huawei.com, liu.jinsong@huawei.com
Subject: Re: [PATCH v3] KVM: x86: enable dirty log gradually in small chunks
Message-ID: <20200224170538.GH37727@xz-x1>
References: <20200224032558.2728-1-jianjay.zhou@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200224032558.2728-1-jianjay.zhou@huawei.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 24, 2020 at 11:25:58AM +0800, Jay Zhou wrote:
> It could take kvm->mmu_lock for an extended period of time when
> enabling dirty log for the first time. The main cost is to clear
> all the D-bits of last level SPTEs. This situation can benefit from
> manual dirty log protect as well, which can reduce the mmu_lock
> time taken. The sequence is like this:
> 
> 1. Initialize all the bits of the dirty bitmap to 1 when enabling
>    dirty log for the first time
> 2. Only write protect the huge pages
> 3. KVM_GET_DIRTY_LOG returns the dirty bitmap info
> 4. KVM_CLEAR_DIRTY_LOG will clear D-bit for each of the leaf level
>    SPTEs gradually in small chunks
> 
> Under the Intel(R) Xeon(R) Gold 6152 CPU @ 2.10GHz environment,
> I did some tests with a 128G windows VM and counted the time taken
> of memory_global_dirty_log_start, here is the numbers:
> 
> VM Size        Before    After optimization
> 128G           460ms     10ms
> 
> Signed-off-by: Jay Zhou <jianjay.zhou@huawei.com>
> ---
> v3:
>   * add kvm_manual_dirty_log_init_set helper, add testcase on top and
>     keep old behavior for KVM_MEM_READONLY [Peter]
>   * tweak logic at enabling KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 [Sean, Peter]
> 
> v2:
>   * add new bit to KVM_ENABLE_CAP for KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 [Paolo]
>   * support non-PML path [Peter]
>   * delete the unnecessary ifdef and make the initialization of bitmap
>     more clear [Sean]
>   * document the new bits and tweak the testcase
> 
>  Documentation/virt/kvm/api.rst  | 16 +++++++++++++---
>  arch/x86/include/asm/kvm_host.h |  3 ++-
>  arch/x86/kvm/mmu/mmu.c          |  7 ++++---
>  arch/x86/kvm/vmx/vmx.c          |  3 ++-
>  arch/x86/kvm/x86.c              | 18 +++++++++++++++---
>  include/linux/kvm_host.h        |  9 ++++++++-
>  virt/kvm/kvm_main.c             | 30 +++++++++++++++++++++++-------
>  7 files changed, 67 insertions(+), 19 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 97a72a5..807fcd7 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5704,10 +5704,20 @@ and injected exceptions.
>  :Architectures: x86, arm, arm64, mips
>  :Parameters: args[0] whether feature should be enabled or not
>  
> -With this capability enabled, KVM_GET_DIRTY_LOG will not automatically
> -clear and write-protect all pages that are returned as dirty.
> +Valid flags are::
> +
> +  #define KVM_DIRTY_LOG_MANUAL_PROTECT2 (1 << 0)
> +  #define KVM_DIRTY_LOG_INITIALLY_SET (1 << 1)

I think I mis-read previously on the old version so my comment was
misleading.  If this is the sub-capability within
KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2, then I don't think we need to have
the ending "2" any more.  How about:

  KVM_MANUAL_PROTECT_ENABLE
  KVM_MANUAL_PROTECT_INIT_ALL_SET

?

Sorry about that.

> +
> +With KVM_DIRTY_LOG_MANUAL_PROTECT2 set, KVM_GET_DIRTY_LOG will not
> +automatically clear and write-protect all pages that are returned as dirty.
>  Rather, userspace will have to do this operation separately using
>  KVM_CLEAR_DIRTY_LOG.
> +With KVM_DIRTY_LOG_INITIALLY_SET set, all the bits of the dirty bitmap
> +will be initialized to 1 when created, dirty logging will be enabled
> +gradually in small chunks using KVM_CLEAR_DIRTY_LOG.  However, the
> +KVM_DIRTY_LOG_INITIALLY_SET depends on KVM_DIRTY_LOG_MANUAL_PROTECT2,
> +it can not be set individually and supports x86 only for now.
>  
>  At the cost of a slightly more complicated operation, this provides better
>  scalability and responsiveness for two reasons.  First,
> @@ -5716,7 +5726,7 @@ than requiring to sync a full memslot; this ensures that KVM does not
>  take spinlocks for an extended period of time.  Second, in some cases a
>  large amount of time can pass between a call to KVM_GET_DIRTY_LOG and
>  userspace actually using the data in the page.  Pages can be modified
> -during this time, which is inefficint for both the guest and userspace:
> +during this time, which is inefficient for both the guest and userspace:
>  the guest will incur a higher penalty due to write protection faults,
>  while userspace can see false reports of dirty pages.  Manual reprotection
>  helps reducing this time, improving guest performance and reducing the
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 40a0c0f..a90630c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1312,7 +1312,8 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
>  
>  void kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
>  void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
> -				      struct kvm_memory_slot *memslot);
> +				      struct kvm_memory_slot *memslot,
> +				      int start_level);
>  void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
>  				   const struct kvm_memory_slot *memslot);
>  void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 87e9ba2..a4e70eb 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5860,13 +5860,14 @@ static bool slot_rmap_write_protect(struct kvm *kvm,
>  }
>  
>  void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
> -				      struct kvm_memory_slot *memslot)
> +				      struct kvm_memory_slot *memslot,
> +				      int start_level)
>  {
>  	bool flush;
>  
>  	spin_lock(&kvm->mmu_lock);
> -	flush = slot_handle_all_level(kvm, memslot, slot_rmap_write_protect,
> -				      false);
> +	flush = slot_handle_level(kvm, memslot, slot_rmap_write_protect,
> +				start_level, PT_MAX_HUGEPAGE_LEVEL, false);
>  	spin_unlock(&kvm->mmu_lock);
>  
>  	/*
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 3be25ec..0deb8c3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7201,7 +7201,8 @@ static void vmx_sched_in(struct kvm_vcpu *vcpu, int cpu)
>  static void vmx_slot_enable_log_dirty(struct kvm *kvm,
>  				     struct kvm_memory_slot *slot)
>  {
> -	kvm_mmu_slot_leaf_clear_dirty(kvm, slot);
> +	if (!kvm_manual_dirty_log_init_set(kvm))
> +		kvm_mmu_slot_leaf_clear_dirty(kvm, slot);
>  	kvm_mmu_slot_largepage_remove_write_access(kvm, slot);
>  }
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fb5d64e..f816940 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9956,7 +9956,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
>  {
>  	/* Still write protect RO slot */
>  	if (new->flags & KVM_MEM_READONLY) {
> -		kvm_mmu_slot_remove_write_access(kvm, new);
> +		kvm_mmu_slot_remove_write_access(kvm, new, PT_PAGE_TABLE_LEVEL);
>  		return;
>  	}
>  
> @@ -9993,8 +9993,20 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
>  	if (new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
>  		if (kvm_x86_ops->slot_enable_log_dirty)
>  			kvm_x86_ops->slot_enable_log_dirty(kvm, new);
> -		else
> -			kvm_mmu_slot_remove_write_access(kvm, new);
> +		else {
> +			int level = kvm_manual_dirty_log_init_set(kvm) ?
> +				PT_DIRECTORY_LEVEL : PT_PAGE_TABLE_LEVEL;
> +
> +			/*
> +			 * If we're with initial-all-set, we don't need
> +			 * to write protect any small page because
> +			 * they're reported as dirty already.  However
> +			 * we still need to write-protect huge pages
> +			 * so that the page split can happen lazily on
> +			 * the first write to the huge page.
> +			 */
> +			kvm_mmu_slot_remove_write_access(kvm, new, level);
> +		}
>  	} else {
>  		if (kvm_x86_ops->slot_disable_log_dirty)
>  			kvm_x86_ops->slot_disable_log_dirty(kvm, new);
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index e89eb67..80ada94 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -360,6 +360,13 @@ static inline unsigned long *kvm_second_dirty_bitmap(struct kvm_memory_slot *mem
>  	return memslot->dirty_bitmap + len / sizeof(*memslot->dirty_bitmap);
>  }
>  
> +#define KVM_DIRTY_LOG_MANUAL_PROTECT2 (1 << 0)
> +#define KVM_DIRTY_LOG_INITIALLY_SET (1 << 1)
> +#define KVM_DIRTY_LOG_MANUAL_CAPS (KVM_DIRTY_LOG_MANUAL_PROTECT2 | \
> +				KVM_DIRTY_LOG_INITIALLY_SET)
> +
> +bool kvm_manual_dirty_log_init_set(struct kvm *kvm);
> +
>  struct kvm_s390_adapter_int {
>  	u64 ind_addr;
>  	u64 summary_addr;
> @@ -493,7 +500,7 @@ struct kvm {
>  #endif
>  	long tlbs_dirty;
>  	struct list_head devices;
> -	bool manual_dirty_log_protect;
> +	u64 manual_dirty_log_protect;
>  	struct dentry *debugfs_dentry;
>  	struct kvm_stat_data **debugfs_stat_data;
>  	struct srcu_struct srcu;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 70f03ce..0ffb804 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -858,11 +858,17 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
>  	return 0;
>  }
>  
> +bool kvm_manual_dirty_log_init_set(struct kvm *kvm)
> +{
> +	return kvm->manual_dirty_log_protect & KVM_DIRTY_LOG_INITIALLY_SET;
> +}

Nit: this can be put into kvm_host.h as inlined.

> +EXPORT_SYMBOL_GPL(kvm_manual_dirty_log_init_set);
> +
>  /*
>   * Allocation size is twice as large as the actual dirty bitmap size.
>   * See x86's kvm_vm_ioctl_get_dirty_log() why this is needed.
>   */
> -static int kvm_create_dirty_bitmap(struct kvm_memory_slot *memslot)
> +static int kvm_alloc_dirty_bitmap(struct kvm_memory_slot *memslot)
>  {
>  	unsigned long dirty_bytes = 2 * kvm_dirty_bitmap_bytes(memslot);
>  
> @@ -1094,8 +1100,11 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  
>  	/* Allocate page dirty bitmap if needed */
>  	if ((new.flags & KVM_MEM_LOG_DIRTY_PAGES) && !new.dirty_bitmap) {
> -		if (kvm_create_dirty_bitmap(&new) < 0)
> +		if (kvm_alloc_dirty_bitmap(&new))
>  			goto out_free;
> +
> +		if (kvm_manual_dirty_log_init_set(kvm))
> +			bitmap_set(new.dirty_bitmap, 0, new.npages);
>  	}
>  
>  	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
> @@ -3310,9 +3319,6 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>  	case KVM_CAP_IOEVENTFD_ANY_LENGTH:
>  	case KVM_CAP_CHECK_EXTENSION_VM:
>  	case KVM_CAP_ENABLE_CAP_VM:
> -#ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
> -	case KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2:
> -#endif
>  		return 1;
>  #ifdef CONFIG_KVM_MMIO
>  	case KVM_CAP_COALESCED_MMIO:
> @@ -3320,6 +3326,10 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>  	case KVM_CAP_COALESCED_PIO:
>  		return 1;
>  #endif
> +#ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
> +	case KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2:
> +		return KVM_DIRTY_LOG_MANUAL_CAPS;

We probably can only return the new feature bit when with CONFIG_X86?

> +#endif
>  #ifdef CONFIG_HAVE_KVM_IRQ_ROUTING
>  	case KVM_CAP_IRQ_ROUTING:
>  		return KVM_MAX_IRQ_ROUTES;
> @@ -3347,11 +3357,17 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
>  {
>  	switch (cap->cap) {
>  #ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
> -	case KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2:
> -		if (cap->flags || (cap->args[0] & ~1))
> +	case KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2: {
> +		u64 allowed_options = KVM_DIRTY_LOG_MANUAL_PROTECT2;
> +
> +		if (cap->args[0] & KVM_DIRTY_LOG_MANUAL_PROTECT2)
> +			allowed_options |= KVM_DIRTY_LOG_INITIALLY_SET;

Same here to check against CONFIG_X86?

> +
> +		if (cap->flags || (cap->args[0] & ~allowed_options))
>  			return -EINVAL;
>  		kvm->manual_dirty_log_protect = cap->args[0];
>  		return 0;
> +	}
>  #endif
>  	default:
>  		return kvm_vm_ioctl_enable_cap(kvm, cap);
> -- 
> 1.8.3.1
> 
> 

Thanks,

-- 
Peter Xu

