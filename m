Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38604556F0
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 09:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244573AbhKRI3z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 03:29:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22766 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244585AbhKRI3Z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 03:29:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637223984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MWLA1YzTePDJq3pIVkNmy8dXmzvGKKkiOeMC4Pl3Co8=;
        b=Jfr5awnO8XFjpvH2JJHbRP/y7ZET6+QcMJ95R/PKgbu/tIh51NAYQpe++FaUdOE9rZ8E/5
        n5xwUigwpjhTjmL6cd6RB7UWLQnQda5y1d2cnIdrgw92uhF12EGh+B3frbTcAL4p+n7zHO
        taBRYhiaLBn8x67UakcpOHXwo2R/qQM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-DA3qFCKGObCYuFOHjdkKTA-1; Thu, 18 Nov 2021 03:26:21 -0500
X-MC-Unique: DA3qFCKGObCYuFOHjdkKTA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A146F802C91;
        Thu, 18 Nov 2021 08:26:19 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F963604CC;
        Thu, 18 Nov 2021 08:26:11 +0000 (UTC)
Message-ID: <d5226a55-35d2-dec1-7aef-d4866ccbc6fb@redhat.com>
Date:   Thu, 18 Nov 2021 09:26:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 01/15] KVM: x86/mmu: Remove redundant flushes when
 disabling dirty logging
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
 <20211115234603.2908381-2-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211115234603.2908381-2-bgardon@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/21 00:45, Ben Gardon wrote:
> tdp_mmu_zap_spte_atomic flushes on every zap already, so no need to
> flush again after it's done.
> 
> Reviewed-by: David Matlack <dmatlack@google.com>
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c     |  4 +---
>   arch/x86/kvm/mmu/tdp_mmu.c | 21 ++++++---------------
>   arch/x86/kvm/mmu/tdp_mmu.h |  5 ++---
>   3 files changed, 9 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 354d2ca92df4..baa94acab516 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5870,9 +5870,7 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
>   
>   	if (is_tdp_mmu_enabled(kvm)) {
>   		read_lock(&kvm->mmu_lock);
> -		flush = kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot, flush);
> -		if (flush)
> -			kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> +		kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot);
>   		read_unlock(&kvm->mmu_lock);
>   	}
>   }
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 7c5dd83e52de..b3c78568ae60 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1364,10 +1364,9 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
>    * Clear leaf entries which could be replaced by large mappings, for
>    * GFNs within the slot.
>    */
> -static bool zap_collapsible_spte_range(struct kvm *kvm,
> +static void zap_collapsible_spte_range(struct kvm *kvm,
>   				       struct kvm_mmu_page *root,
> -				       const struct kvm_memory_slot *slot,
> -				       bool flush)
> +				       const struct kvm_memory_slot *slot)
>   {
>   	gfn_t start = slot->base_gfn;
>   	gfn_t end = start + slot->npages;
> @@ -1378,10 +1377,8 @@ static bool zap_collapsible_spte_range(struct kvm *kvm,
>   
>   	tdp_root_for_each_pte(iter, root, start, end) {
>   retry:
> -		if (tdp_mmu_iter_cond_resched(kvm, &iter, flush, true)) {
> -			flush = false;
> +		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
>   			continue;
> -		}
>   
>   		if (!is_shadow_present_pte(iter.old_spte) ||
>   		    !is_last_spte(iter.old_spte, iter.level))
> @@ -1401,30 +1398,24 @@ static bool zap_collapsible_spte_range(struct kvm *kvm,
>   			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
>   			goto retry;
>   		}
> -		flush = true;
>   	}
>   
>   	rcu_read_unlock();
> -
> -	return flush;
>   }
>   
>   /*
>    * Clear non-leaf entries (and free associated page tables) which could
>    * be replaced by large mappings, for GFNs within the slot.
>    */
> -bool kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
> -				       const struct kvm_memory_slot *slot,
> -				       bool flush)
> +void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
> +				       const struct kvm_memory_slot *slot)
>   {
>   	struct kvm_mmu_page *root;
>   
>   	lockdep_assert_held_read(&kvm->mmu_lock);
>   
>   	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
> -		flush = zap_collapsible_spte_range(kvm, root, slot, flush);
> -
> -	return flush;
> +		zap_collapsible_spte_range(kvm, root, slot);
>   }
>   
>   /*
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index 476b133544dd..3899004a5d91 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -64,9 +64,8 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
>   				       struct kvm_memory_slot *slot,
>   				       gfn_t gfn, unsigned long mask,
>   				       bool wrprot);
> -bool kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
> -				       const struct kvm_memory_slot *slot,
> -				       bool flush);
> +void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
> +				       const struct kvm_memory_slot *slot);
>   
>   bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
>   				   struct kvm_memory_slot *slot, gfn_t gfn,
> 

Queued, thanks.

Paolo

