Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4F7622C3E
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 14:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiKINSP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 08:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiKINSN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 08:18:13 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19FB8220C4;
        Wed,  9 Nov 2022 05:18:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667999893; x=1699535893;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=md/np00PaOJL3QdAu/5OiBToW4uMd2uRiGDqq+hYEec=;
  b=Mvno1wVRizjrKsaJSCCAKItZNrGvL4lCBnl+vPCex50sojfh1iWejX4h
   Ij6kMjmoFbpy3IzqBoCZ2q0j44TFkjE/WQNrMjJ1T8Pm4eiPQ7rzV0Ubu
   6++iPv2kyNsN68ziVdL97a4xs+tPmMyl3AniXKbpDuT/pryQHOJfLAzF3
   iERzRLimQnS4oJqnsc5LBdjAN87I7MWpfQfdmcZr7TDD6G9awxo2XSJ6u
   01WH8mqM5g3A8ANNBUYoVujzG9lNFHN6v/xg6kgSNPnc7GIajo1Nnk/Db
   NZtUGy4s07ZITurgZQOZcA2LDTK4My2430/R7+MjcI2pU1EIQ42CrzbFu
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="397266012"
X-IronPort-AV: E=Sophos;i="5.96,150,1665471600"; 
   d="scan'208";a="397266012"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 05:18:12 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="811629031"
X-IronPort-AV: E=Sophos;i="5.96,150,1665471600"; 
   d="scan'208";a="811629031"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.255.30.64]) ([10.255.30.64])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 05:18:08 -0800
Message-ID: <2aa68393-a91b-5d21-8e6a-bd22076e9177@linux.intel.com>
Date:   Wed, 9 Nov 2022 21:18:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v10 060/108] KVM: Add functions to set GFN to private or
 shared
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <c834432220f04c39a8dfa6ac3838446e6c06c9e9.1667110240.git.isaku.yamahata@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <c834432220f04c39a8dfa6ac3838446e6c06c9e9.1667110240.git.isaku.yamahata@intel.com>
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
> TDX KVM support needs to track whether GFN is private or shared.  Introduce
> functions to set whether GFN is private or shared and pre-allocate memory
> for xarray.
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   include/linux/kvm_host.h | 11 ++++++
>   virt/kvm/kvm_main.c      | 74 ++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 85 insertions(+)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index a0b64308d240..fac07886ab39 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2307,9 +2307,20 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
>   #define KVM_MEM_ATTR_PRIVATE	0x0002
>   
>   #ifdef __KVM_HAVE_ARCH_UPDATE_MEM_ATTR
> +/* memory attr on [start, end) */
> +int kvm_vm_reserve_mem_attr(struct kvm *kvm, gfn_t start, gfn_t end);
> +int kvm_vm_set_mem_attr(struct kvm *kvm, int attr, gfn_t start, gfn_t end);
>   void kvm_arch_update_mem_attr(struct kvm *kvm, struct kvm_memory_slot *slot,
>   			      unsigned int attr, gfn_t start, gfn_t end);
>   #else
> +static inline int kvm_vm_reserve_mem_attr(struct kvm *kvm, gfn_t start, gfn_t end)
> +{
> +	return -EOPNOTSUPP;
> +}
> +static inline int kvm_vm_set_mem_attr(struct kvm *kvm, int attr, gfn_t start, gfn_t end)
> +{
> +	return -EOPNOTSUPP;
> +}
>   static inline void kvm_arch_update_mem_attr(struct kvm *kvm,
>   					    struct kvm_memory_slot *slot,
>   					    unsigned int attr,
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 9f82b03a8118..f0e77b65939b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1121,6 +1121,80 @@ static inline void kvm_restrictedmem_unregister(struct kvm_memory_slot *slot)
>   					  &slot->notifier);
>   }
>   
> +/*
> + * Reserve memory for [start, end) so that the next set oepration won't fail
> + * with -ENOMEM.
> + */
> +int kvm_vm_reserve_mem_attr(struct kvm *kvm, gfn_t start, gfn_t end)
> +{
> +	int r = 0;
> +	gfn_t gfn;
> +
> +	xa_lock(&kvm->mem_attr_array);
> +	for (gfn = start; gfn < end; gfn++) {
> +		r = __xa_insert(&kvm->mem_attr_array, gfn, NULL, GFP_KERNEL_ACCOUNT);
> +		if (r == -EBUSY)
> +			r = 0;
> +		if (r)
> +			break;
> +	}
> +	xa_unlock(&kvm->mem_attr_array);
> +
> +	return r;
> +}
> +EXPORT_SYMBOL_GPL(kvm_vm_reserve_mem_attr);
> +
> +/* Set memory attr for [start, end) */
> +int kvm_vm_set_mem_attr(struct kvm *kvm, int attr, gfn_t start, gfn_t end)
> +{
> +	void *entry;
> +	gfn_t gfn;
> +	int r;
> +	int i;
> +
> +	/* By default, the entry is private. */
> +	switch (attr) {
> +	case KVM_MEM_ATTR_PRIVATE:
> +		entry = NULL;
> +		break;
> +	case KVM_MEM_ATTR_SHARED:
> +		entry = xa_mk_value(KVM_MEM_ATTR_SHARED);
> +		break;
> +	default:
> +		WARN_ON_ONCE(1);
> +		return -EINVAL;
> +	}
> +
> +	WARN_ON_ONCE(start >= end);
> +	for (gfn = start; gfn < end; gfn++) {
> +		r = xa_err(xa_store(&kvm->mem_attr_array, gfn, entry,
> +				    GFP_KERNEL_ACCOUNT));
> +		if (r)
> +			break;
> +	}
> +	if (start >= gfn)
> +		return r;
> +
> +	end = gfn;
> +	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> +		struct kvm_memslot_iter iter;
> +		struct kvm_memory_slot *slot;
> +		struct kvm_memslots *slots;
> +
> +		slots = __kvm_memslots(kvm, i);
> +		kvm_for_each_memslot_in_gfn_range(&iter, slots, start, end) {
> +			gfn_t s = max(start, slot->base_gfn);
> +			gfn_t e = min(end, slot->base_gfn + slot->npages);

slot is not inited.


> +
> +			WARN_ON_ONCE(s >= e);
> +			kvm_arch_update_mem_attr(kvm, slot, attr, s, e);
> +		}
> +	}
> +
> +	return r;
> +}
> +EXPORT_SYMBOL_GPL(kvm_vm_set_mem_attr);
> +
>   #else /* !CONFIG_HAVE_KVM_RESTRICTED_MEM */
>   
>   static inline void kvm_restrictedmem_register(struct kvm_memory_slot *slot)
