Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B3E30401E
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 15:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392685AbhAZOWX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 09:22:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50198 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405512AbhAZOPw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 09:15:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611670463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mkYJgccn/z7hy1ePkMnR/5smC+AZZcHpvTFxrxDkSNU=;
        b=QwUUHUcbeSiGzsKMyhvYXxJyjFqoXOzb5Yejh8OoKItQi+cAYYk15rI+arlaz1KVzp4Rf0
        dJZCwtnoDwom9Wm/bzMQeU9tZI7osuq5RA5GKJpOAz47m2CkqQHkOpInAEuZwq9kX6ToZG
        FV53YLJ8FAjfUsxhNbE4I22C3m74iJw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-9bYqOo-yOjW7Hxzq5Z1tWQ-1; Tue, 26 Jan 2021 09:14:21 -0500
X-MC-Unique: 9bYqOo-yOjW7Hxzq5Z1tWQ-1
Received: by mail-ed1-f71.google.com with SMTP id j12so9394962edq.10
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 06:14:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mkYJgccn/z7hy1ePkMnR/5smC+AZZcHpvTFxrxDkSNU=;
        b=pnPIKIwm3f9VRw7oHM1L7OtDbgu08kGI7pe2tUjTliKFQUVJFDhnKXY9ln5Ab8k3wP
         pgCDYOPBTQG9bcYvVZST4VJ7tTzelxSdm8BtXiv658ckLlUfGPwHs7fa8C74qaHNlOmz
         MRJUdkMVNuIqUtPDw7gvOx+2ftoxWCDgw/irJwCC4qr27fSaJQqJ4ykVEiIe2m7+viDl
         UIFbfjM03MO4VXQ8pZGF3KwMKIJHB4Pigi0kLS2NmpHwigj8BIuBNOeYqOhuxBhH8eal
         Osa9/2dJdFYHwrFsHtvmeWwGk9bqPWznqMIGOyRLiiqarvjfSzost2LRqwsfmsehFHsl
         fnUQ==
X-Gm-Message-State: AOAM532GWg8PgmU2jsUa3Q0hxPSSDocg/5f+v4xCwyek6g36GyLhDqVy
        Uqejvu5PmT09WU66acnawD2HNvAZ3/3fkmN6F51awb/ig8wwfzdKXGYBkQ0OuAaoUsk3znhoyWj
        p29kF52TVehhu
X-Received: by 2002:a17:906:796:: with SMTP id l22mr3616215ejc.247.1611670460041;
        Tue, 26 Jan 2021 06:14:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwkxnTqREDfh1bdGSipEr+24o8IlvB2ibHXTuznrfuQ8ea8f4Gj4WU55TPyxDDGrLil+doZYw==
X-Received: by 2002:a17:906:796:: with SMTP id l22mr3616196ejc.247.1611670459875;
        Tue, 26 Jan 2021 06:14:19 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g14sm12643662edm.31.2021.01.26.06.14.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 06:14:18 -0800 (PST)
Subject: Re: [PATCH 10/24] kvm: x86/mmu: Factor out handle disconnected pt
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
References: <20210112181041.356734-1-bgardon@google.com>
 <20210112181041.356734-11-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <47e0b040-f9de-376d-80a3-75b5680a7b85@redhat.com>
Date:   Tue, 26 Jan 2021 15:14:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210112181041.356734-11-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/01/21 19:10, Ben Gardon wrote:
> Factor out the code to handle a disconnected subtree of the TDP paging
> structure from the code to handle the change to an individual SPTE.
> Future commits will build on this to allow asynchronous page freeing.
> 
> No functional change intended.
> 
> Reviewed-by: Peter Feiner <pfeiner@google.com>
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>   arch/x86/kvm/mmu/tdp_mmu.c | 75 +++++++++++++++++++++++---------------
>   1 file changed, 46 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 55df596696c7..e8f35cd46b4c 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -234,6 +234,49 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
>   	}
>   }
>   
> +/**
> + * handle_disconnected_tdp_mmu_page - handle a pt removed from the TDP structure
> + *
> + * @kvm: kvm instance
> + * @pt: the page removed from the paging structure
> + *
> + * Given a page table that has been removed from the TDP paging structure,
> + * iterates through the page table to clear SPTEs and free child page tables.
> + */
> +static void handle_disconnected_tdp_mmu_page(struct kvm *kvm, u64 *pt)
> +{
> +	struct kvm_mmu_page *sp;
> +	gfn_t gfn;
> +	int level;
> +	u64 old_child_spte;
> +	int i;
> +
> +	sp = sptep_to_sp(pt);
> +	gfn = sp->gfn;
> +	level = sp->role.level;
> +
> +	trace_kvm_mmu_prepare_zap_page(sp);
> +
> +	list_del(&sp->link);
> +
> +	if (sp->lpage_disallowed)
> +		unaccount_huge_nx_page(kvm, sp);
> +
> +	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
> +		old_child_spte = READ_ONCE(*(pt + i));
> +		WRITE_ONCE(*(pt + i), 0);
> +		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp),
> +			gfn + (i * KVM_PAGES_PER_HPAGE(level - 1)),
> +			old_child_spte, 0, level - 1);
> +	}
> +
> +	kvm_flush_remote_tlbs_with_address(kvm, gfn,
> +					   KVM_PAGES_PER_HPAGE(level));
> +
> +	free_page((unsigned long)pt);
> +	kmem_cache_free(mmu_page_header_cache, sp);
> +}
> +
>   /**
>    * handle_changed_spte - handle bookkeeping associated with an SPTE change
>    * @kvm: kvm instance
> @@ -254,10 +297,6 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>   	bool was_leaf = was_present && is_last_spte(old_spte, level);
>   	bool is_leaf = is_present && is_last_spte(new_spte, level);
>   	bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
> -	u64 *pt;
> -	struct kvm_mmu_page *sp;
> -	u64 old_child_spte;
> -	int i;
>   
>   	WARN_ON(level > PT64_ROOT_MAX_LEVEL);
>   	WARN_ON(level < PG_LEVEL_4K);
> @@ -321,31 +360,9 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>   	 * Recursively handle child PTs if the change removed a subtree from
>   	 * the paging structure.
>   	 */
> -	if (was_present && !was_leaf && (pfn_changed || !is_present)) {
> -		pt = spte_to_child_pt(old_spte, level);
> -		sp = sptep_to_sp(pt);
> -
> -		trace_kvm_mmu_prepare_zap_page(sp);
> -
> -		list_del(&sp->link);
> -
> -		if (sp->lpage_disallowed)
> -			unaccount_huge_nx_page(kvm, sp);
> -
> -		for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
> -			old_child_spte = READ_ONCE(*(pt + i));
> -			WRITE_ONCE(*(pt + i), 0);
> -			handle_changed_spte(kvm, as_id,
> -				gfn + (i * KVM_PAGES_PER_HPAGE(level - 1)),
> -				old_child_spte, 0, level - 1);
> -		}
> -
> -		kvm_flush_remote_tlbs_with_address(kvm, gfn,
> -						   KVM_PAGES_PER_HPAGE(level));
> -
> -		free_page((unsigned long)pt);
> -		kmem_cache_free(mmu_page_header_cache, sp);
> -	}
> +	if (was_present && !was_leaf && (pfn_changed || !is_present))
> +		handle_disconnected_tdp_mmu_page(kvm,
> +				spte_to_child_pt(old_spte, level));
>   }
>   
>   static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> 

Queued, thanks.

Paolo

