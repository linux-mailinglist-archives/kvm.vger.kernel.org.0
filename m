Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25420373140
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 22:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbhEDUOJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 16:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbhEDUOC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 16:14:02 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65508C061574
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 13:13:06 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id p17so5933183plf.12
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 13:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hOpr5X5iLUsxQXZMfgFtFQv/OPJaI291sQPjBVYL6i4=;
        b=qjyvmlpGQP5Uyw4BFXCTRuaCPMBPrTNd6RKSeKxciqdRz3ek0UeoVOP4X7Gns7xbOK
         NiiEgRKp6Yi68+g0d7L+hE2maO66CrmPO6igUJSUvbSagSQvZZnbqA02K6AeiQWtTIFR
         5OiCHldYWl0fj0bfppGp9WVJLxxuOotzbbzUt8KwikHRd5twDZMeXYBuD/4jN+b1sG7D
         K8L008O3d/b4JV7XI5gBT9VdIqz7jfpoV7YWYDeOGTjfEb4hF3yCdjySDn+FK1SqEWEW
         oqkVJHzWk2wr10/X/Oy9htxYknp91nC6gy066Ie+rOBCqyXM+/63fqljO1stMtf3T2jN
         Pccw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hOpr5X5iLUsxQXZMfgFtFQv/OPJaI291sQPjBVYL6i4=;
        b=gAKWja4IGc+S1lJn47iGuTSDLZHLcWCbY0lMGIJXmP6y3PMJAnpXWDYod1IY8VyqP9
         HMTOGghrszKMbZDBq90Mg0pGu0Fz5zHtBWiUVuP5tmXwcjoPV3K9zzzMs6IEed6TZD6k
         B+AaJ2Ynxs85gJaKeYsX9GXXRb1X9E8UorBlNAaAlSUcBlSxIbPn8H7HLtMChA0Q7G6r
         //v9jhpvexNT/Yqj+aEp5L0EsVClco4F7HgZyZtGXvUQqpxUSpoQtAYl8B74amGoA0w0
         /O/fRcGeEC9myjZJKyWnqg1hg1M/1bFhYC/zsW7/I2oXP3HxukSf3ex77T0qaYskR6wn
         Y1EQ==
X-Gm-Message-State: AOAM53350attgCpB5cb2InpkX2xMoPI9v1JNo/c62i84orohpls6EarM
        A0y2/9ULYzoDUQ+P66WBxGZZSg==
X-Google-Smtp-Source: ABdhPJzZlpmByhkmegFWPDJejjwukrIiTVDPdra8aVzO6A1dV9z/mY4C3DyvcX/IXw8Jyd5TeU80IA==
X-Received: by 2002:a17:902:9893:b029:ee:e8a8:688c with SMTP id s19-20020a1709029893b02900eee8a8688cmr7097120plp.84.1620159185570;
        Tue, 04 May 2021 13:13:05 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id md21sm5168152pjb.3.2021.05.04.13.13.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 13:13:04 -0700 (PDT)
Date:   Tue, 4 May 2021 20:13:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH v2 7/7] KVM: x86/mmu: Lazily allocate memslot rmaps
Message-ID: <YJGqzZ/8CS8mSx2c@google.com>
References: <20210429211833.3361994-1-bgardon@google.com>
 <20210429211833.3361994-8-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210429211833.3361994-8-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 29, 2021, Ben Gardon wrote:
> If the TDP MMU is in use, wait to allocate the rmaps until the shadow
> MMU is actually used. (i.e. a nested VM is launched.) This saves memory
> equal to 0.2% of guest memory in cases where the TDP MMU is used and
> there are no nested guests involved.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 11 +++++++
>  arch/x86/kvm/mmu/mmu.c          | 21 +++++++++++--
>  arch/x86/kvm/mmu/mmu_internal.h |  2 +-
>  arch/x86/kvm/x86.c              | 54 ++++++++++++++++++++++++++++++---
>  4 files changed, 80 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3900dcf2439e..b8633ed00a6a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1124,6 +1124,15 @@ struct kvm_arch {
>  #endif /* CONFIG_X86_64 */
>  
>  	bool shadow_mmu_active;
> +
> +	/*
> +	 * If set, the rmap should be allocated for any newly created or
> +	 * modified memslots. If allocating rmaps lazily, this may be set
> +	 * before the rmaps are allocated for existing memslots, but
> +	 * shadow_mmu_active will not be set until after the rmaps are fully
> +	 * allocated.
> +	 */
> +	bool alloc_memslot_rmaps;

Maybe "need_rmaps" or "need_memslot_rmaps"?

>  };
>  
>  struct kvm_vm_stat {
> @@ -1855,4 +1864,6 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
>  
>  int kvm_cpu_dirty_log_size(void);
>  
> +int alloc_all_memslots_rmaps(struct kvm *kvm);
> +
>  #endif /* _ASM_X86_KVM_HOST_H */
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e252af46f205..b2a6585bd978 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3125,9 +3125,17 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  	return ret;
>  }
>  
> -void activate_shadow_mmu(struct kvm *kvm)
> +int activate_shadow_mmu(struct kvm *kvm)
>  {
> +	int r;
> +
> +	r = alloc_all_memslots_rmaps(kvm);
> +	if (r)
> +		return r;
> +
>  kvm->arch.shadow_mmu_active = true;

If shadow_mmu_active goes away, so does this helper.

> +
> +	return 0;
>  }
>  
>  static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
> @@ -3300,7 +3308,9 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  		}
>  	}
>  
> -	activate_shadow_mmu(vcpu->kvm);
> +	r = activate_shadow_mmu(vcpu->kvm);
> +	if (r)
> +		return r;
>  
>  	write_lock(&vcpu->kvm->mmu_lock);
>  	r = make_mmu_pages_available(vcpu);
> @@ -5491,7 +5501,12 @@ void kvm_mmu_init_vm(struct kvm *kvm)
>  	struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
>  
>  	if (!kvm_mmu_init_tdp_mmu(kvm))
> -		activate_shadow_mmu(kvm);
> +		/*
> +		 * No memslots can have been allocated at this point.
> +		 * activate_shadow_mmu won't actually need to allocate
> +		 * rmaps, so it cannot fail.
> +		 */
> +		WARN_ON(activate_shadow_mmu(kvm));

This is where I really don't like calling the full flow.  VM init is already
special, I don't see any harm in open coding the setting of the flag.  This also
provides a good place to document that the smp_store/load business is unnecessary
since there can't be users.

>  	node->track_write = kvm_mmu_pte_write;
>  	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
> -static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
> +int alloc_memslots_rmaps(struct kvm *kvm, struct kvm_memslots *slots)
> +{
> +	struct kvm_memory_slot *slot;
> +	int r = 0;
> +
> +	kvm_for_each_memslot(slot, slots) {
> +		r = alloc_memslot_rmap(kvm, slot, slot->npages);
> +		if (r)
> +			break;
> +	}
> +	return r;
> +}

Just open code this in the caller, it's literally one line of code and the
indentation isn't bad.

> +
> +int alloc_all_memslots_rmaps(struct kvm *kvm)
> +{
> +	struct kvm_memslots *slots;
> +	int r = 0;
> +	int i;
> +
> +	mutex_lock(&kvm->slots_arch_lock);
> +	kvm->arch.alloc_memslot_rmaps = true;
> +
> +	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> +		slots = __kvm_memslots(kvm, i);
> +		r = alloc_memslots_rmaps(kvm, slots);
> +		if (r)

It'd be easier just to destroy the rmaps on failure and then do:

	if (kvm->arch.needs_memslots_rmaps)
		return;

	mutex_lock(&kvm->slots_arch_lock);

	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
		kvm_for_each_memslot(slot, __kvm_memslots(kvm, i)) {
			r = alloc_memslot_rmap(kvm, slot, slot->npages);
				break;
		}
	}

	if (!r)
		smp_store_release(kvm->arch.needs_memslots_rmaps, true);
	else
		kvm_free_rmaps(kvm);
	mutex_unlock(&kvm->slots_arch_lock);


and make alloc_memslot_rmap() a pure allocator (no checks on whether it should
actually do allocations), i.e. push the check to the memslot flow:

static int kvm_alloc_memslot_metadata(struct kvm *kvm,
				      struct kvm_memory_slot *slot,
				      unsigned long npages)
{
	int i;
	int r;

	/*
	 * Clear out the previous array pointers for the KVM_MR_MOVE case.  The
	 * old arrays will be freed by __kvm_set_memory_region() if installing
	 * the new memslot is successful.
	 */
	memset(&slot->arch, 0, sizeof(slot->arch));

	if (kvm->arch.needs_memslots_rmaps) {
		r = alloc_memslot_rmap(kvm, slot, npages);
		if (r)
			return r;
	}


With that, there's no need for the separate shadow_mmu_active flag, and you can
do s/activate_shadow_mmu/kvm_activate_rmaps or so.


> +			break;
> +	}
> +	mutex_unlock(&kvm->slots_arch_lock);
> +	return r;
> +}
> +
> +static int kvm_alloc_memslot_metadata(struct kvm *kvm,
> +				      struct kvm_memory_slot *slot,
>  				      unsigned long npages)
>  {
>  	int i;
> @@ -10881,7 +10927,7 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
>  	 */
>  	memset(&slot->arch, 0, sizeof(slot->arch));
>  
> -	r = alloc_memslot_rmap(slot, npages);
> +	r = alloc_memslot_rmap(kvm, slot, npages);
>  	if (r)
>  		return r;
>  
> @@ -10954,7 +11000,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  				enum kvm_mr_change change)
>  {
>  	if (change == KVM_MR_CREATE || change == KVM_MR_MOVE)
> -		return kvm_alloc_memslot_metadata(memslot,
> +		return kvm_alloc_memslot_metadata(kvm, memslot,
>  						  mem->memory_size >> PAGE_SHIFT);
>  	return 0;
>  }
> -- 
> 2.31.1.527.g47e6f16901-goog
> 
