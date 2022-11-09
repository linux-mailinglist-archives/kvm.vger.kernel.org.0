Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44700622EB0
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 16:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbiKIPFz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 10:05:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231812AbiKIPFw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 10:05:52 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188431A214;
        Wed,  9 Nov 2022 07:05:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668006352; x=1699542352;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=V7ERcWjZOjI3SNP1Ma6RVphh3Q0hvX/kotbHalxpBmo=;
  b=eZQ+QaIH3DMlnEFvO1y9vfvAV/S1DqhRJ2MWmk9eZHj3xLirC0H6465M
   1fDJOiTOYQ5gWjOD6b5invo7iHz/WJjV2UOEndB4gjkuJLJ/hZTHO/a1E
   Jv9v6y/ObHRAoow2LD5wcxB+KKARokzPj6q0YNtRlGATZpUITG+VdH6G9
   NTCb+WY9NC0hGEDhJE/ybPKZjGG9MxNuM4zvXBYr9GROKZKumGldW3qOY
   BOOEqpLTNcluJ+GGD0GVx6RLHeHeTT8+UhTy/mw8vr7nv3e5qavsevVmL
   a/g5t95J1DKyK/urQ+0E4EcIGYALiPf7Xw2JEuW2fc3CF2mK0ygR46lnz
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="309708933"
X-IronPort-AV: E=Sophos;i="5.96,150,1665471600"; 
   d="scan'208";a="309708933"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 07:05:51 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="639221289"
X-IronPort-AV: E=Sophos;i="5.96,150,1665471600"; 
   d="scan'208";a="639221289"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.255.30.64]) ([10.255.30.64])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 07:05:48 -0800
Message-ID: <b49d953a-61f0-e466-90d2-713e25dff770@linux.intel.com>
Date:   Wed, 9 Nov 2022 23:05:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v10 062/108] KVM: x86/tdp_mmu: implement MapGPA hypercall
 for TDX
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <73ef2bdcdf8ec88bbec9d3780484cecda7a21e6f.1667110240.git.isaku.yamahata@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <73ef2bdcdf8ec88bbec9d3780484cecda7a21e6f.1667110240.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/30/2022 2:23 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> The TDX Guest-Hypervisor communication interface(GHCI) specification
> defines MapGPA hypercall for guest TD to request the host VMM to map given
> GPA range as private or shared.
>
> It means the guest TD uses the GPA as shared (or private).  The GPA
> won't be used as private (or shared).  VMM should enforce GPA usage. VMM
> doesn't have to map the GPA on the hypercall request.
>
> - Zap the aliased region.
>    If shared (or private) GPA is requested, zap private (or shared) GPA
>    (modulo shared bit).
> - Record the request GPA is shared (or private) by kvm.mem_attr_array.
> - Don't map GPA. The GPA is mapped on the next EPT violation.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/mmu.h         |  5 ++++
>   arch/x86/kvm/mmu/mmu.c     | 60 ++++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/mmu/tdp_mmu.c | 35 ++++++++++++++++++++++
>   arch/x86/kvm/mmu/tdp_mmu.h |  3 ++
>   4 files changed, 103 insertions(+)
>
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index e2a0dfbee56d..e1641fa5a862 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -219,6 +219,11 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
>   
>   int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
>   
> +int __kvm_mmu_map_gpa(struct kvm *kvm, gfn_t *startp, gfn_t end,
> +		      bool map_private);
> +int kvm_mmu_map_gpa(struct kvm_vcpu *vcpu, gfn_t *startp, gfn_t end,
> +		    bool map_private);
> +
>   int kvm_mmu_post_init_vm(struct kvm *kvm);
>   void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
>   
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 168c84c99de3..37b378bf60df 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6778,6 +6778,66 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
>   	}
>   }
>   
> +int __kvm_mmu_map_gpa(struct kvm *kvm, gfn_t *startp, gfn_t end,
> +		      bool map_private)
> +{
> +	gfn_t start = *startp;
> +	int attr;
> +	int ret;
> +
> +	if (!kvm_gfn_shared_mask(kvm))
> +		return -EOPNOTSUPP;
> +
> +	attr = map_private ? KVM_MEM_ATTR_PRIVATE : KVM_MEM_ATTR_SHARED;
> +	start = start & ~kvm_gfn_shared_mask(kvm);
> +	end = end & ~kvm_gfn_shared_mask(kvm);
> +
> +	/*
> +	 * To make the following kvm_vm_set_mem_attr() success within spinlock
> +	 * without memory allocation.
> +	 */
> +	ret = kvm_vm_reserve_mem_attr(kvm, start, end);
> +	if (ret)
> +		return ret;
> +
> +	write_lock(&kvm->mmu_lock);
> +	if (is_tdp_mmu_enabled(kvm)) {

How about moving the condition test to the beginning of the function to 
make the code simpler?


> +		gfn_t s = start;
> +
> +		ret = kvm_tdp_mmu_map_gpa(kvm, &s, end, map_private);
> +		if (!ret) {
> +			KVM_BUG_ON(kvm_vm_set_mem_attr(kvm, attr, start, end), kvm);
> +		} else if (ret == -EAGAIN) {
> +			KVM_BUG_ON(kvm_vm_set_mem_attr(kvm, attr, start, s), kvm);
> +			start = s;
> +		}
> +	} else {
> +		ret = -EOPNOTSUPP;
> +	}
> +	write_unlock(&kvm->mmu_lock);
> +
> +	if (ret == -EAGAIN) {
> +		if (map_private)
> +			*startp = kvm_gfn_private(kvm, start);
> +		else
> +			*startp = kvm_gfn_shared(kvm, start);
> +	}
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(__kvm_mmu_map_gpa);
> +
> +int kvm_mmu_map_gpa(struct kvm_vcpu *vcpu, gfn_t *startp, gfn_t end,
> +		    bool map_private)
> +{
> +	struct kvm_mmu *mmu = vcpu->arch.mmu;
> +
> +	if (!VALID_PAGE(mmu->root.hpa) || !VALID_PAGE(mmu->private_root_hpa))
> +		return -EINVAL;
> +
> +	return __kvm_mmu_map_gpa(vcpu->kvm, startp, end, map_private);
> +}
> +EXPORT_SYMBOL_GPL(kvm_mmu_map_gpa);
> +
>   static unsigned long
>   mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
>   {
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 4b207ce83ffe..d3bab382ceaa 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -2156,6 +2156,41 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
>   	return spte_set;
>   }
>   
> +int kvm_tdp_mmu_map_gpa(struct kvm *kvm,
> +			gfn_t *startp, gfn_t end, bool map_private)
> +{
> +	struct kvm_mmu_page *root;
> +	gfn_t start = *startp;
> +	bool flush = false;
> +	int i;
> +
> +	lockdep_assert_held_write(&kvm->mmu_lock);
> +	KVM_BUG_ON(start & kvm_gfn_shared_mask(kvm), kvm);
> +	KVM_BUG_ON(end & kvm_gfn_shared_mask(kvm), kvm);
> +
> +	kvm_mmu_invalidate_begin(kvm, start, end);
> +	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> +		for_each_tdp_mmu_root_yield_safe(kvm, root, i) {
> +			if (is_private_sp(root) == map_private)
> +				continue;
> +
> +			/*
> +			 * TODO: If necessary, return to the caller with -EAGAIN
> +			 * instead of yield-and-resume within
> +			 * tdp_mmu_zap_leafs().
> +			 */
> +			flush = tdp_mmu_zap_leafs(kvm, root, start, end,
> +						  /*can_yield=*/true, flush,
> +						  /*zap_private=*/is_private_sp(root));
> +		}
> +	}
> +	if (flush)
> +		kvm_flush_remote_tlbs_with_address(kvm, start, end - start);
> +	kvm_mmu_invalidate_end(kvm, start, end);
> +
> +	return 0;
> +}
> +
>   /*
>    * Return the level of the lowest level SPTE added to sptes.
>    * That SPTE may be non-present.
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index 695175c921a5..cb13bc1c3679 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -51,6 +51,9 @@ void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
>   				      gfn_t start, gfn_t end,
>   				      int target_level, bool shared);
>   
> +int kvm_tdp_mmu_map_gpa(struct kvm *kvm,
> +			gfn_t *startp, gfn_t end, bool map_private);

Sugguest to add some description about the function to avoid confusion, 
since the function name is quite generic but the usage is highly related 
to TDX.


> +
>   static inline void kvm_tdp_mmu_walk_lockless_begin(void)
>   {
>   	rcu_read_lock();
