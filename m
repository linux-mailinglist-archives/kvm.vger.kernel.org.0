Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF5E30D8E7
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 12:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234275AbhBCLk2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 06:40:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27922 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234250AbhBCLkV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 06:40:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612352333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fyt/1j+ufqlbvMO8Cb0k5HgIBjZWY9LFMD9ai2A1eVM=;
        b=JGd6Itv3CaUHfPVDJ4zcBie2rFE4eRIYoax5+hMleqd683DHrOJonlzfXs6ZZAHkRldh5o
        K48CfTgFQ0N7i6UEPk5QFTxucmczYSwjHcTcCSvTPypVP6tnFRtm6FhT5bzc9ZEq5aBCMj
        Txd7FGrNdUFdkx6ULgvYJ0Okq3jbsVQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-E3980iTuNQy5JWMP-anACg-1; Wed, 03 Feb 2021 06:38:51 -0500
X-MC-Unique: E3980iTuNQy5JWMP-anACg-1
Received: by mail-ed1-f69.google.com with SMTP id w14so3786519edv.6
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 03:38:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fyt/1j+ufqlbvMO8Cb0k5HgIBjZWY9LFMD9ai2A1eVM=;
        b=a2Wt7O3xU1kFns5v3lcu4nTWgOeOYS2eH0NVjw6UZFqKINqfQbXXRbwWWPwK7rZrbd
         E8UVS6G4CjKJ/t6q3X3tXUSYWOwyFTGbuxw3P+kKNwQJzq+cEK14+si6XjZR6uZ8xpBU
         yeD8qvWiBOsuymE9Fy9LAiWewLVHatLsp3UflZhrdoxWjLDFhWMwEAvaVF/zM9peRo2v
         rnki/JuMRkv8K4UTPY57X7OGVP6HlfUIdm6p2sSoI5Z77tPsaVmRdzP18k7Tz341qw9J
         o+ZHzBKfjRqk7t2rYOP6k57GD+aqpF+FWK2mQ4G1W0KWuKHgZJFzINwG23r4EE56LLTV
         Zhag==
X-Gm-Message-State: AOAM533ywHzxoC4XXG00iTs3K38pF2bb2EESUeAvSdL0Esb65Drv6RMk
        UMmnyWYtjI00XP9NyCcKNxDaEucpkWjTfDRD62YnKrUyW+AEuwDXv1qcp0vrLCrIkkNEDUeiGJp
        gxxmyb3D6KCYv
X-Received: by 2002:aa7:d6c2:: with SMTP id x2mr2432753edr.225.1612352329985;
        Wed, 03 Feb 2021 03:38:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJySe8fY8EB8TI+A5pKdxx529xqLfM8+1X0HgPpcOJfv6q8T9TZGcIIXMeJXt26YU+Tu/jiFOA==
X-Received: by 2002:aa7:d6c2:: with SMTP id x2mr2432734edr.225.1612352329723;
        Wed, 03 Feb 2021 03:38:49 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h12sm719987edb.16.2021.02.03.03.38.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 03:38:48 -0800 (PST)
Subject: Re: [PATCH v2 26/28] KVM: x86/mmu: Allow enabling / disabling dirty
 logging under MMU read lock
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20210202185734.1680553-1-bgardon@google.com>
 <20210202185734.1680553-27-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b0829378-6991-4f59-273d-db58057d7cb8@redhat.com>
Date:   Wed, 3 Feb 2021 12:38:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210202185734.1680553-27-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/02/21 19:57, Ben Gardon wrote:
> To reduce lock contention and interference with page fault handlers,
> allow the TDP MMU functions which enable and disable dirty logging
> to operate under the MMU read lock.
> 
> 
> Extend dirty logging enable disable functions read lock-ness
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c     | 14 +++---
>   arch/x86/kvm/mmu/tdp_mmu.c | 93 ++++++++++++++++++++++++++++++--------
>   arch/x86/kvm/mmu/tdp_mmu.h |  2 +-
>   3 files changed, 84 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e3cf868be6bd..6ba2a72d4330 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5638,9 +5638,10 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
>   
>   	write_lock(&kvm->mmu_lock);
>   	flush = slot_handle_leaf(kvm, memslot, __rmap_clear_dirty, false);
> +	write_unlock(&kvm->mmu_lock);
> +
>   	if (kvm->arch.tdp_mmu_enabled)
>   		flush |= kvm_tdp_mmu_clear_dirty_slot(kvm, memslot);
> -	write_unlock(&kvm->mmu_lock);
>   
>   	/*
>   	 * It's also safe to flush TLBs out of mmu lock here as currently this
> @@ -5661,9 +5662,10 @@ void kvm_mmu_slot_largepage_remove_write_access(struct kvm *kvm,
>   	write_lock(&kvm->mmu_lock);
>   	flush = slot_handle_large_level(kvm, memslot, slot_rmap_write_protect,
>   					false);
> +	write_unlock(&kvm->mmu_lock);
> +
>   	if (kvm->arch.tdp_mmu_enabled)
>   		flush |= kvm_tdp_mmu_wrprot_slot(kvm, memslot, PG_LEVEL_2M);
> -	write_unlock(&kvm->mmu_lock);
>   
>   	if (flush)
>   		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
> @@ -5677,12 +5679,12 @@ void kvm_mmu_slot_set_dirty(struct kvm *kvm,
>   
>   	write_lock(&kvm->mmu_lock);
>   	flush = slot_handle_all_level(kvm, memslot, __rmap_set_dirty, false);
> -	if (kvm->arch.tdp_mmu_enabled)
> -		flush |= kvm_tdp_mmu_slot_set_dirty(kvm, memslot);
> -	write_unlock(&kvm->mmu_lock);
> -
>   	if (flush)
>   		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
> +	write_unlock(&kvm->mmu_lock);
> +
> +	if (kvm->arch.tdp_mmu_enabled)
> +		kvm_tdp_mmu_slot_set_dirty(kvm, memslot);
>   }
>   EXPORT_SYMBOL_GPL(kvm_mmu_slot_set_dirty);
>   
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index cfe66b8d39fa..6093926a6bc5 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -553,18 +553,22 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>   }
>   
>   /*
> - * tdp_mmu_set_spte_atomic - Set a TDP MMU SPTE atomically and handle the
> + * __tdp_mmu_set_spte_atomic - Set a TDP MMU SPTE atomically and handle the
>    * associated bookkeeping
>    *
>    * @kvm: kvm instance
>    * @iter: a tdp_iter instance currently on the SPTE that should be set
>    * @new_spte: The value the SPTE should be set to
> + * @record_dirty_log: Record the page as dirty in the dirty bitmap if
> + *		      appropriate for the change being made. Should be set
> + *		      unless performing certain dirty logging operations.
> + *		      Leaving record_dirty_log unset in that case prevents page
> + *		      writes from being double counted.
>    * Returns: true if the SPTE was set, false if it was not. If false is returned,
>    *	    this function will have no side-effects.
>    */
> -static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
> -					   struct tdp_iter *iter,
> -					   u64 new_spte)
> +static inline bool __tdp_mmu_set_spte_atomic(struct kvm *kvm,
> +		struct tdp_iter *iter, u64 new_spte, bool record_dirty_log)

Instead of adding the bool argument, just name this 
tdp_mmu_set_spte_atomic_no_dirty_log...

>   {
>   	u64 *root_pt = tdp_iter_root_pt(iter);
>   	struct kvm_mmu_page *root = sptep_to_sp(root_pt);
> @@ -583,12 +587,31 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
>   		      new_spte) != iter->old_spte)
>   		return false;
>   
> -	handle_changed_spte(kvm, as_id, iter->gfn, iter->old_spte, new_spte,
> -			    iter->level, true);
> +	__handle_changed_spte(kvm, as_id, iter->gfn, iter->old_spte, new_spte,
> +			      iter->level, true);
> +	handle_changed_spte_acc_track(iter->old_spte, new_spte, iter->level);
> +	if (record_dirty_log)
> +		handle_changed_spte_dirty_log(kvm, as_id, iter->gfn,
> +					      iter->old_spte, new_spte,
> +					      iter->level);

... and tdp_mmu_set_spte_atomic becomes

	if (!tdp_mmu_set_spte_atomic_no_dirty_log(kvm, iter, new_spte))
		return false;

	handle_changed_spte_dirty_log(kvm, as_id, iter->gfn,
				      iter->old_spte, new_spte,
				      iter->level);
	return true;


> @@ -1301,7 +1344,8 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
>   	int root_as_id;
>   	bool spte_set = false;
>   
> -	for_each_tdp_mmu_root_yield_safe(kvm, root, false) {
> +	read_lock(&kvm->mmu_lock);
> +	for_each_tdp_mmu_root_yield_safe(kvm, root, true) {
>   		root_as_id = kvm_mmu_page_as_id(root);
>   		if (root_as_id != slot->as_id)
>   			continue;
> @@ -1309,6 +1353,7 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
>   		spte_set |= clear_dirty_gfn_range(kvm, root, slot->base_gfn,
>   				slot->base_gfn + slot->npages);
>   	}
> +	read_unlock(&kvm->mmu_lock);

Same remark as before.

>   	return spte_set;
>   }
> @@ -1397,7 +1442,8 @@ static bool set_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>   	rcu_read_lock();
>   
>   	tdp_root_for_each_pte(iter, root, start, end) {
> -		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, false))
> +retry:
> +		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
>   			continue;
>   
>   		if (!is_shadow_present_pte(iter.old_spte) ||
> @@ -1406,7 +1452,14 @@ static bool set_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>   
>   		new_spte = iter.old_spte | shadow_dirty_mask;
>   
> -		tdp_mmu_set_spte(kvm, &iter, new_spte);
> +		if (!tdp_mmu_set_spte_atomic(kvm, &iter, new_spte)) {
> +			/*
> +			 * The iter must explicitly re-read the SPTE because
> +			 * the atomic cmpxchg failed.
> +			 */
> +			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
> +			goto retry;
> +		}
>   		spte_set = true;

Yep, looks like that spte_set assignment should not have been removed. :)

>   	}
>   
> @@ -1417,15 +1470,15 @@ static bool set_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>   /*
>    * Set the dirty status of all the SPTEs mapping GFNs in the memslot. This is
>    * only used for PML, and so will involve setting the dirty bit on each SPTE.
> - * Returns true if an SPTE has been changed and the TLBs need to be flushed.
>    */
> -bool kvm_tdp_mmu_slot_set_dirty(struct kvm *kvm, struct kvm_memory_slot *slot)
> +void kvm_tdp_mmu_slot_set_dirty(struct kvm *kvm, struct kvm_memory_slot *slot)
>   {
>   	struct kvm_mmu_page *root;
>   	int root_as_id;
>   	bool spte_set = false;
>   
> -	for_each_tdp_mmu_root_yield_safe(kvm, root, false) {
> +	read_lock(&kvm->mmu_lock);

And again here.

Paolo

> +	for_each_tdp_mmu_root_yield_safe(kvm, root, true) {
>   		root_as_id = kvm_mmu_page_as_id(root);
>   		if (root_as_id != slot->as_id)
>   			continue;
> @@ -1433,7 +1486,11 @@ bool kvm_tdp_mmu_slot_set_dirty(struct kvm *kvm, struct kvm_memory_slot *slot)
>   		spte_set |= set_dirty_gfn_range(kvm, root, slot->base_gfn,
>   				slot->base_gfn + slot->npages);
>   	}
> -	return spte_set;
> +
> +	if (spte_set)
> +		kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> +
> +	read_unlock(&kvm->mmu_lock);
>   }
>   
>   /*
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index 10ada884270b..848b41b20985 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -38,7 +38,7 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
>   				       struct kvm_memory_slot *slot,
>   				       gfn_t gfn, unsigned long mask,
>   				       bool wrprot);
> -bool kvm_tdp_mmu_slot_set_dirty(struct kvm *kvm, struct kvm_memory_slot *slot);
> +void kvm_tdp_mmu_slot_set_dirty(struct kvm *kvm, struct kvm_memory_slot *slot);
>   void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
>   				       const struct kvm_memory_slot *slot);
>   
> 

