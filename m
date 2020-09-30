Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D20027E0D6
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 08:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725798AbgI3GGO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 02:06:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:23395 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725320AbgI3GGO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 02:06:14 -0400
IronPort-SDR: w1DrSPKsq8VDkeZtf5gixn+hI187cSqSjawLptXFt3GhvO1F20i7kXLtyur89J6Dz3dqmrEGPe
 glDUlAjiBv3Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="163233545"
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="163233545"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 23:06:13 -0700
IronPort-SDR: QP+J2yUGCGYoqPssStcB6IJv3h9hobsiEz2vsBAKhzQs+4lEnrS83qHreuArXvXPMaVRm3K8UE
 60er+Hfhn3pg==
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="495767075"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 23:06:12 -0700
Date:   Tue, 29 Sep 2020 23:06:11 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH 04/22] kvm: mmu: Allocate and free TDP MMU roots
Message-ID: <20200930060610.GA29659@linux.intel.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-5-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925212302.3979661-5-bgardon@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 25, 2020 at 02:22:44PM -0700, Ben Gardon wrote:
  static u64 __read_mostly shadow_nx_mask;
> @@ -3597,10 +3592,14 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
>  	if (!VALID_PAGE(*root_hpa))
>  		return;
>  
> -	sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
> -	--sp->root_count;
> -	if (!sp->root_count && sp->role.invalid)
> -		kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
> +	if (is_tdp_mmu_root(kvm, *root_hpa)) {
> +		kvm_tdp_mmu_put_root_hpa(kvm, *root_hpa);
> +	} else {
> +		sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
> +		--sp->root_count;
> +		if (!sp->root_count && sp->role.invalid)
> +			kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);

Hmm, I see that future patches use put_tdp_mmu_root()/get_tdp_mmu_root(),
but the code itself isn't specific to the TDP MMU.  Even if this ends up
being the only non-TDP user of get/put, I think it'd be worth making them
common helpers, e.g.

	sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
	if (mmu_put_root(sp) {
		if (is_tdp_mmu(...))
			kvm_tdp_mmu_free_root(kvm, sp);
		else if (sp->role.invalid)
			kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
	}

> +	}
>  
>  	*root_hpa = INVALID_PAGE;
>  }
> @@ -3691,7 +3690,13 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
>  	unsigned i;
>  
>  	if (shadow_root_level >= PT64_ROOT_4LEVEL) {
> -		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level, true);
> +		if (vcpu->kvm->arch.tdp_mmu_enabled) {

I believe this will break 32-bit NPT.  Or at a minimum, look weird.  It'd
be better to explicitly disable the TDP MMU on 32-bit KVM, then this becomes

	if (vcpu->kvm->arch.tdp_mmu_enabled) {

	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {

	} else {

	}

> +			root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
> +		} else {
> +			root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level,
> +					      true);
> +		}

May not matter in the end, but the braces aren't needed.

> +
>  		if (!VALID_PAGE(root))
>  			return -ENOSPC;
>  		vcpu->arch.mmu->root_hpa = root;
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 65bb110847858..530b7d893c7b3 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -41,8 +41,12 @@ struct kvm_mmu_page {
>  
>  	/* Number of writes since the last time traversal visited this page.  */
>  	atomic_t write_flooding_count;
> +
> +	bool tdp_mmu_page;
>  };
>  
> +extern struct kmem_cache *mmu_page_header_cache;
> +
>  static inline struct kvm_mmu_page *to_shadow_page(hpa_t shadow_page)
>  {
>  	struct page *page = pfn_to_page(shadow_page >> PAGE_SHIFT);
> @@ -69,6 +73,11 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
>  	(((address) >> PT64_LEVEL_SHIFT(level)) & ((1 << PT64_LEVEL_BITS) - 1))
>  #define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
>  
> +#define ACC_EXEC_MASK    1
> +#define ACC_WRITE_MASK   PT_WRITABLE_MASK
> +#define ACC_USER_MASK    PT_USER_MASK
> +#define ACC_ALL          (ACC_EXEC_MASK | ACC_WRITE_MASK | ACC_USER_MASK)
> +
>  /* Functions for interpreting SPTEs */
>  kvm_pfn_t spte_to_pfn(u64 pte);
>  bool is_mmio_spte(u64 spte);
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 8241e18c111e6..cdca829e42040 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1,5 +1,7 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  
> +#include "mmu.h"
> +#include "mmu_internal.h"
>  #include "tdp_mmu.h"
>  
>  static bool __read_mostly tdp_mmu_enabled = true;
> @@ -25,10 +27,165 @@ void kvm_mmu_init_tdp_mmu(struct kvm *kvm)
>  
>  	/* This should not be changed for the lifetime of the VM. */
>  	kvm->arch.tdp_mmu_enabled = true;
> +
> +	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
>  }
>  
>  void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
>  {
>  	if (!kvm->arch.tdp_mmu_enabled)
>  		return;
> +
> +	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
> +}
> +
> +#define for_each_tdp_mmu_root(_kvm, _root)			    \
> +	list_for_each_entry(_root, &_kvm->arch.tdp_mmu_roots, link)
> +
> +bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
> +{
> +	struct kvm_mmu_page *root;
> +
> +	if (!kvm->arch.tdp_mmu_enabled)
> +		return false;
> +
> +	root = to_shadow_page(hpa);
> +
> +	if (WARN_ON(!root))
> +		return false;
> +
> +	return root->tdp_mmu_page;

Why all the extra checks?

> +}
> +
> +static void free_tdp_mmu_root(struct kvm *kvm, struct kvm_mmu_page *root)
> +{
> +	lockdep_assert_held(&kvm->mmu_lock);
> +
> +	WARN_ON(root->root_count);
> +	WARN_ON(!root->tdp_mmu_page);
> +
> +	list_del(&root->link);
> +
> +	free_page((unsigned long)root->spt);
> +	kmem_cache_free(mmu_page_header_cache, root);
> +}
> +
> +static void put_tdp_mmu_root(struct kvm *kvm, struct kvm_mmu_page *root)
> +{
> +	lockdep_assert_held(&kvm->mmu_lock);
> +
> +	root->root_count--;
> +	if (!root->root_count)
> +		free_tdp_mmu_root(kvm, root);
> +}
> +
> +static void get_tdp_mmu_root(struct kvm *kvm, struct kvm_mmu_page *root)
> +{
> +	lockdep_assert_held(&kvm->mmu_lock);
> +	WARN_ON(!root->root_count);
> +
> +	root->root_count++;
> +}
> +
> +void kvm_tdp_mmu_put_root_hpa(struct kvm *kvm, hpa_t root_hpa)
> +{
> +	struct kvm_mmu_page *root;
> +
> +	root = to_shadow_page(root_hpa);
> +
> +	if (WARN_ON(!root))
> +		return;
> +
> +	put_tdp_mmu_root(kvm, root);
> +}
> +
> +static struct kvm_mmu_page *find_tdp_mmu_root_with_role(
> +		struct kvm *kvm, union kvm_mmu_page_role role)
> +{
> +	struct kvm_mmu_page *root;
> +
> +	lockdep_assert_held(&kvm->mmu_lock);
> +	for_each_tdp_mmu_root(kvm, root) {
> +		WARN_ON(!root->root_count);
> +
> +		if (root->role.word == role.word)
> +			return root;
> +	}
> +
> +	return NULL;
> +}
> +
> +static struct kvm_mmu_page *alloc_tdp_mmu_root(struct kvm_vcpu *vcpu,
> +					       union kvm_mmu_page_role role)
> +{
> +	struct kvm_mmu_page *new_root;
> +	struct kvm_mmu_page *root;
> +
> +	new_root = kvm_mmu_memory_cache_alloc(
> +			&vcpu->arch.mmu_page_header_cache);
> +	new_root->spt = kvm_mmu_memory_cache_alloc(
> +			&vcpu->arch.mmu_shadow_page_cache);
> +	set_page_private(virt_to_page(new_root->spt), (unsigned long)new_root);
> +
> +	new_root->role.word = role.word;
> +	new_root->root_count = 1;
> +	new_root->gfn = 0;
> +	new_root->tdp_mmu_page = true;
> +
> +	spin_lock(&vcpu->kvm->mmu_lock);
> +
> +	/* Check that no matching root exists before adding this one. */
> +	root = find_tdp_mmu_root_with_role(vcpu->kvm, role);
> +	if (root) {
> +		get_tdp_mmu_root(vcpu->kvm, root);
> +		spin_unlock(&vcpu->kvm->mmu_lock);

Hrm, I'm not a big fan of dropping locks in the middle of functions, but the
alternatives aren't great.  :-/  Best I can come up with is

	if (root)
		get_tdp_mmu_root()
	else
		list_add();

	spin_unlock();

	if (root) {
		free_page()
		kmem_cache_free()
	} else {
		root = new_root;
	}

	return root;

Not sure that's any better.

> +		free_page((unsigned long)new_root->spt);
> +		kmem_cache_free(mmu_page_header_cache, new_root);
> +		return root;
> +	}
> +
> +	list_add(&new_root->link, &vcpu->kvm->arch.tdp_mmu_roots);
> +	spin_unlock(&vcpu->kvm->mmu_lock);
> +
> +	return new_root;
> +}
> +
> +static struct kvm_mmu_page *get_tdp_mmu_vcpu_root(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_mmu_page *root;
> +	union kvm_mmu_page_role role;
> +
> +	role = vcpu->arch.mmu->mmu_role.base;
> +	role.level = vcpu->arch.mmu->shadow_root_level;
> +	role.direct = true;
> +	role.gpte_is_8_bytes = true;
> +	role.access = ACC_ALL;
> +
> +	spin_lock(&vcpu->kvm->mmu_lock);
> +
> +	/* Search for an already allocated root with the same role. */
> +	root = find_tdp_mmu_root_with_role(vcpu->kvm, role);
> +	if (root) {
> +		get_tdp_mmu_root(vcpu->kvm, root);
> +		spin_unlock(&vcpu->kvm->mmu_lock);

Rather than manually unlock and return, this can be

	if (root)
		get_tdp_mmju_root();

	spin_unlock()

	if (!root)
		root = alloc_tdp_mmu_root();

	return root;

You could also add a helper to do the "get" along with the "find".  Not sure
if that's worth the code.
	
> +		return root;
> +	}
> +
> +	spin_unlock(&vcpu->kvm->mmu_lock);
> +
> +	/* If there is no appropriate root, allocate one. */
> +	root = alloc_tdp_mmu_root(vcpu, role);
> +
> +	return root;
> +}
> +
> +hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_mmu_page *root;
> +
> +	root = get_tdp_mmu_vcpu_root(vcpu);
> +	if (!root)
> +		return INVALID_PAGE;
> +
> +	return __pa(root->spt);
>  }
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index dd3764f5a9aa3..9274debffeaa1 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -7,4 +7,9 @@
>  
>  void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
>  void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
> +
> +bool is_tdp_mmu_root(struct kvm *kvm, hpa_t root);
> +hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
> +void kvm_tdp_mmu_put_root_hpa(struct kvm *kvm, hpa_t root_hpa);
> +
>  #endif /* __KVM_X86_MMU_TDP_MMU_H */
> -- 
> 2.28.0.709.gb0816b6eb0-goog
> 
