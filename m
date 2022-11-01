Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E64D161479C
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 11:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiKAKVf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 06:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiKAKVe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 06:21:34 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A01460FA;
        Tue,  1 Nov 2022 03:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667298093; x=1698834093;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kp/VTQaNp+uoQTfUuEpAJ7NXTuuBRp55w/P2S6kyzvs=;
  b=QGbPBazcVDWNMpdQn4mwmDsthZc+w1JU9TvPedTBD94f0CLiHXqQBO2K
   bZuvTv4f166Tm075GQUyN5mSk/8UmYYpdQtCn4Mwpwsnr/aU8QMWkOR64
   Gbp8ikRq/PKDrG3p/oHGBOwPza41J2T7Q+VRtpNQfgHGvuFvv/PbWRmF6
   aFnswuBr+mqP/4JusF5DTBPJ8x9KH3nvXHIsu04sWzPB443UF16L+g7hA
   wmSAO1Mc2cQ/iSurnt31Cl3BT5tbMwz0aIwYay6iU7MW2f+Lq8ofnv5ZZ
   V7gP2dQ/y+ngZpdHPP6mYwnFsMTQNFZ3gHZBwdyAqvW/HXU2nleOTWbpd
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="289497177"
X-IronPort-AV: E=Sophos;i="5.95,230,1661842800"; 
   d="scan'208";a="289497177"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 03:21:33 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="739284277"
X-IronPort-AV: E=Sophos;i="5.95,230,1661842800"; 
   d="scan'208";a="739284277"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.30.42]) ([10.255.30.42])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 03:21:31 -0700
Message-ID: <36cde6d6-128d-884e-1447-09b08bb5de3d@intel.com>
Date:   Tue, 1 Nov 2022 18:21:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.0
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
Content-Language: en-US
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <c834432220f04c39a8dfa6ac3838446e6c06c9e9.1667110240.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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

slot needs to be set as

			slot = iter.slot;

> +			gfn_t s = max(start, slot->base_gfn);
> +			gfn_t e = min(end, slot->base_gfn + slot->npages);
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

