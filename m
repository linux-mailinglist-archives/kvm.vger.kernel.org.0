Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0EBA4556F7
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 09:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244560AbhKRIbL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 03:31:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53341 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244222AbhKRIbJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 03:31:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637224089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hzi11vxccDMxIfWUmOoPxIy1topnV1535jdgyTCSjDs=;
        b=I3H3IskO1hqJ0qO3gq5vz+1IKpPTP0pWE4ZSFXvC2ofbG2YtV6oicMtfbRVauHof8pBPf1
        qIRl5aq4r9iKdQdUEcW2yY5TKL4F0P0LapPnxfNqj8QT2FOxRR17vzX83J47qCubnRezn1
        QWcgDnNYg6050+/WtW1E/tDiy460SuA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516-NtgqGbP0PeyhWdbEvOdwIA-1; Thu, 18 Nov 2021 03:28:06 -0500
X-MC-Unique: NtgqGbP0PeyhWdbEvOdwIA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DA39802EDA;
        Thu, 18 Nov 2021 08:28:04 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 368521048129;
        Thu, 18 Nov 2021 08:27:52 +0000 (UTC)
Message-ID: <b63bdf51-84c1-6a59-8e17-eb374843575c@redhat.com>
Date:   Thu, 18 Nov 2021 09:27:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 10/15] KVM: x86/mmu: Propagate memslot const qualifier
Content-Language: en-US
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>
References: <20211115234603.2908381-1-bgardon@google.com>
 <20211115234603.2908381-11-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211115234603.2908381-11-bgardon@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/21 00:45, Ben Gardon wrote:
> In preparation for implementing in-place hugepage promotion, various
> functions will need to be called from zap_collapsible_spte_range, which
> has the const qualifier on its memslot argument. Propagate the const
> qualifier to the various functions which will be needed. This just serves
> to simplify the following patch.
> 
> No functional change intended.
> 
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>   arch/x86/include/asm/kvm_page_track.h |  4 ++--
>   arch/x86/kvm/mmu/mmu.c                |  2 +-
>   arch/x86/kvm/mmu/mmu_internal.h       |  2 +-
>   arch/x86/kvm/mmu/page_track.c         |  4 ++--
>   arch/x86/kvm/mmu/spte.c               |  2 +-
>   arch/x86/kvm/mmu/spte.h               |  2 +-
>   include/linux/kvm_host.h              | 10 +++++-----
>   virt/kvm/kvm_main.c                   | 12 ++++++------
>   8 files changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
> index e99a30a4d38b..eb186bc57f6a 100644
> --- a/arch/x86/include/asm/kvm_page_track.h
> +++ b/arch/x86/include/asm/kvm_page_track.h
> @@ -64,8 +64,8 @@ void kvm_slot_page_track_remove_page(struct kvm *kvm,
>   				     struct kvm_memory_slot *slot, gfn_t gfn,
>   				     enum kvm_page_track_mode mode);
>   bool kvm_slot_page_track_is_active(struct kvm *kvm,
> -				   struct kvm_memory_slot *slot, gfn_t gfn,
> -				   enum kvm_page_track_mode mode);
> +				   const struct kvm_memory_slot *slot,
> +				   gfn_t gfn, enum kvm_page_track_mode mode);
>   
>   void
>   kvm_page_track_register_notifier(struct kvm *kvm,
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index fdf0f15ab19d..ef7a84422463 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2576,7 +2576,7 @@ static void kvm_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>    * were marked unsync (or if there is no shadow page), -EPERM if the SPTE must
>    * be write-protected.
>    */
> -int mmu_try_to_unsync_pages(struct kvm *kvm, struct kvm_memory_slot *slot,
> +int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
>   			    gfn_t gfn, bool can_unsync, bool prefetch)
>   {
>   	struct kvm_mmu_page *sp;
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 1073d10cce91..6563cce9c438 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -118,7 +118,7 @@ static inline bool kvm_vcpu_ad_need_write_protect(struct kvm_vcpu *vcpu)
>   	       kvm_x86_ops.cpu_dirty_log_size;
>   }
>   
> -int mmu_try_to_unsync_pages(struct kvm *kvm, struct kvm_memory_slot *slot,
> +int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
>   			    gfn_t gfn, bool can_unsync, bool prefetch);
>   
>   void kvm_mmu_gfn_disallow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
> diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> index 35c221d5f6ce..68eb1fb548b6 100644
> --- a/arch/x86/kvm/mmu/page_track.c
> +++ b/arch/x86/kvm/mmu/page_track.c
> @@ -174,8 +174,8 @@ EXPORT_SYMBOL_GPL(kvm_slot_page_track_remove_page);
>    * check if the corresponding access on the specified guest page is tracked.
>    */
>   bool kvm_slot_page_track_is_active(struct kvm *kvm,
> -				   struct kvm_memory_slot *slot, gfn_t gfn,
> -				   enum kvm_page_track_mode mode)
> +				   const struct kvm_memory_slot *slot,
> +				   gfn_t gfn, enum kvm_page_track_mode mode)
>   {
>   	int index;
>   
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index d98723b14cec..7be41d2dbb02 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -90,7 +90,7 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
>   }
>   
>   bool make_spte(struct kvm *kvm, struct kvm_mmu_page *sp,
> -	       struct kvm_memory_slot *slot, unsigned int pte_access,
> +	       const struct kvm_memory_slot *slot, unsigned int pte_access,
>   	       gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool prefetch,
>   	       bool can_unsync, bool host_writable, bool ad_need_write_protect,
>   	       u64 mt_mask, struct rsvd_bits_validate *shadow_zero_check,
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 5bb055688080..d7598506fbad 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -330,7 +330,7 @@ static inline u64 get_mmio_spte_generation(u64 spte)
>   }
>   
>   bool make_spte(struct kvm *kvm, struct kvm_mmu_page *sp,
> -	       struct kvm_memory_slot *slot, unsigned int pte_access,
> +	       const struct kvm_memory_slot *slot, unsigned int pte_access,
>   	       gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool prefetch,
>   	       bool can_unsync, bool host_writable, bool ad_need_write_protect,
>   	       u64 mt_mask, struct rsvd_bits_validate *shadow_zero_check,
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 60a35d9fe259..675da38fac7f 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -435,7 +435,7 @@ struct kvm_memory_slot {
>   	u16 as_id;
>   };
>   
> -static inline bool kvm_slot_dirty_track_enabled(struct kvm_memory_slot *slot)
> +static inline bool kvm_slot_dirty_track_enabled(const struct kvm_memory_slot *slot)
>   {
>   	return slot->flags & KVM_MEM_LOG_DIRTY_PAGES;
>   }
> @@ -855,9 +855,9 @@ void kvm_set_page_accessed(struct page *page);
>   kvm_pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn);
>   kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
>   		      bool *writable);
> -kvm_pfn_t gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn);
> -kvm_pfn_t gfn_to_pfn_memslot_atomic(struct kvm_memory_slot *slot, gfn_t gfn);
> -kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
> +kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn);
> +kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gfn_t gfn);
> +kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
>   			       bool atomic, bool *async, bool write_fault,
>   			       bool *writable, hva_t *hva);
>   
> @@ -934,7 +934,7 @@ struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
>   bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
>   bool kvm_vcpu_is_visible_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
>   unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn);
> -void mark_page_dirty_in_slot(struct kvm *kvm, struct kvm_memory_slot *memslot, gfn_t gfn);
> +void mark_page_dirty_in_slot(struct kvm *kvm, const struct kvm_memory_slot *memslot, gfn_t gfn);
>   void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
>   
>   struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 3f6d450355f0..6dbf8cba1900 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2138,12 +2138,12 @@ unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn)
>   	return size;
>   }
>   
> -static bool memslot_is_readonly(struct kvm_memory_slot *slot)
> +static bool memslot_is_readonly(const struct kvm_memory_slot *slot)
>   {
>   	return slot->flags & KVM_MEM_READONLY;
>   }
>   
> -static unsigned long __gfn_to_hva_many(struct kvm_memory_slot *slot, gfn_t gfn,
> +static unsigned long __gfn_to_hva_many(const struct kvm_memory_slot *slot, gfn_t gfn,
>   				       gfn_t *nr_pages, bool write)
>   {
>   	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
> @@ -2438,7 +2438,7 @@ static kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
>   	return pfn;
>   }
>   
> -kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn,
> +kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
>   			       bool atomic, bool *async, bool write_fault,
>   			       bool *writable, hva_t *hva)
>   {
> @@ -2478,13 +2478,13 @@ kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
>   }
>   EXPORT_SYMBOL_GPL(gfn_to_pfn_prot);
>   
> -kvm_pfn_t gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
> +kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn)
>   {
>   	return __gfn_to_pfn_memslot(slot, gfn, false, NULL, true, NULL, NULL);
>   }
>   EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot);
>   
> -kvm_pfn_t gfn_to_pfn_memslot_atomic(struct kvm_memory_slot *slot, gfn_t gfn)
> +kvm_pfn_t gfn_to_pfn_memslot_atomic(const struct kvm_memory_slot *slot, gfn_t gfn)
>   {
>   	return __gfn_to_pfn_memslot(slot, gfn, true, NULL, true, NULL, NULL);
>   }
> @@ -3079,7 +3079,7 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
>   EXPORT_SYMBOL_GPL(kvm_clear_guest);
>   
>   void mark_page_dirty_in_slot(struct kvm *kvm,
> -			     struct kvm_memory_slot *memslot,
> +			     const struct kvm_memory_slot *memslot,
>   		 	     gfn_t gfn)
>   {
>   	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
> 

Queued, thanks.

Paolo

