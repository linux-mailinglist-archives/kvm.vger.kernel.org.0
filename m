Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2189F2FF44A
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 20:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbhAUTXq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 14:23:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbhAUTXf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jan 2021 14:23:35 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5EEC061756
        for <kvm@vger.kernel.org>; Thu, 21 Jan 2021 11:22:52 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id r4so1821195pls.11
        for <kvm@vger.kernel.org>; Thu, 21 Jan 2021 11:22:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zKsHotGXgvprTlpljGXGLKdBrcmy/Fn0NltUb7fu5lk=;
        b=SR2Vs6lWfpe+LZrVSZg2Qh6+dPYcXM7skWkPE19rhLYayubSvW2MJBuuOAi+3nEP0u
         8ddD1sSNbCmHC/v64EYVwWyZ1AQj4CnB7HgiKfDoGmwzUs0qv4t4xvL9SdEzQZSs8Xv2
         RF+zP+x+IUuKB5/cWknemRDVXgDGr7Y52YtUT49a3GLr/6sMlBye/Nmltb1CG4Oxuwe0
         DMc1U0Aag7z7o2P29pdis2xXWSvoB2Nu2sWcJrU33BdnO/cKRH5zmsO/BskWDjwvXgMk
         6Vlf0m9cP7yTs4S3YGbO+glVFdYoSEc1Bd5MCqXh5CIOHnQSaXUJwVYzGkvEUHmbldpw
         hQSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zKsHotGXgvprTlpljGXGLKdBrcmy/Fn0NltUb7fu5lk=;
        b=WArjDYLqtrr2djTzKerclRtZnLewEAF0ogsNTP/4nBDL6ac98H1KM0qVTfsIyrA2LI
         FYabbyUBzIQHlohoe4qoSZd4iRlZCIEzYBc/KpDzgtoHU16YBUZ9eskQv8jhbGvNI9qz
         XjgL+86X2X5rwj2IMrPCnjYJ+bKKmUB8soOq+PXnTPM+AyyTWKx5WdUpl0evEU0CmpBI
         Wv7b7ZuspQie6wA7HkpC9pWsjshRYOKpbDjqU+DdIinoVGQSoj01/7SvCJfXPH9/MWHl
         F2krC8olI5rww+opBDYm3WY9V/fSM2VBzGrgra8HD5SBZX+G+5S0ltHNQWf07uqstJvz
         LsOg==
X-Gm-Message-State: AOAM533asaARUd9Y8ehRXM0uPrWzs22thM55egP/PQs9dSurKhkiYD5F
        7KGDIHLbXWw9gXNh5GN+t2LfN7sw9LMd9Q==
X-Google-Smtp-Source: ABdhPJz10HdM3ZLqhQf++MXK/auC7Itc6QN3487igCFrBclxhRG0eOX6nOYMQ8tGJd/GDL3UDPaODw==
X-Received: by 2002:a17:90a:6643:: with SMTP id f3mr999802pjm.33.1611256972123;
        Thu, 21 Jan 2021 11:22:52 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id x8sm3218020pjf.55.2021.01.21.11.22.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 11:22:51 -0800 (PST)
Date:   Thu, 21 Jan 2021 11:22:44 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH 19/24] kvm: x86/mmu: Protect tdp_mmu_pages with a lock
Message-ID: <YAnUhCocizx97FWL@google.com>
References: <20210112181041.356734-1-bgardon@google.com>
 <20210112181041.356734-20-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112181041.356734-20-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021, Ben Gardon wrote:
> Add a lock to protect the data structures that track the page table
> memory used by the TDP MMU. In order to handle multiple TDP MMU
> operations in parallel, pages of PT memory must be added and removed
> without the exclusive protection of the MMU lock. A new lock to protect
> the list(s) of in-use pages will cause some serialization, but only on
> non-leaf page table entries, so the lock is not expected to be very
> contended.
> 
> Reviewed-by: Peter Feiner <pfeiner@google.com>
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 15 ++++++++
>  arch/x86/kvm/mmu/tdp_mmu.c      | 67 +++++++++++++++++++++++++++++----
>  2 files changed, 74 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 92d5340842c8..f8dccb27c722 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1034,6 +1034,21 @@ struct kvm_arch {
>  	 * tdp_mmu_page set and a root_count of 0.
>  	 */
>  	struct list_head tdp_mmu_pages;
> +
> +	/*
> +	 * Protects accesses to the following fields when the MMU lock is
> +	 * not held exclusively:
> +	 *  - tdp_mmu_pages (above)
> +	 *  - the link field of struct kvm_mmu_pages used by the TDP MMU
> +	 *    when they are part of tdp_mmu_pages (but not when they are part
> +	 *    of the tdp_mmu_free_list or tdp_mmu_disconnected_list)

Neither tdp_mmu_free_list nor tdp_mmu_disconnected_list exists.

> +	 *  - lpage_disallowed_mmu_pages
> +	 *  - the lpage_disallowed_link field of struct kvm_mmu_pages used
> +	 *    by the TDP MMU
> +	 *  May be acquired under the MMU lock in read mode or non-overlapping
> +	 *  with the MMU lock.
> +	 */
> +	spinlock_t tdp_mmu_pages_lock;
>  };
>  
>  struct kvm_vm_stat {
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 8b61bdb391a0..264594947c3b 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -33,6 +33,7 @@ void kvm_mmu_init_tdp_mmu(struct kvm *kvm)
>  	kvm->arch.tdp_mmu_enabled = true;
>  
>  	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
> +	spin_lock_init(&kvm->arch.tdp_mmu_pages_lock);
>  	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_pages);
>  }
>  
> @@ -262,6 +263,58 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
>  	}
>  }
>  
> +/**
> + * tdp_mmu_link_page - Add a new page to the list of pages used by the TDP MMU
> + *
> + * @kvm: kvm instance
> + * @sp: the new page
> + * @atomic: This operation is not running under the exclusive use of the MMU
> + *	    lock and the operation must be atomic with respect to ther threads
> + *	    that might be adding or removing pages.
> + * @account_nx: This page replaces a NX large page and should be marked for
> + *		eventual reclaim.
> + */
> +static void tdp_mmu_link_page(struct kvm *kvm, struct kvm_mmu_page *sp,
> +			      bool atomic, bool account_nx)
> +{
> +	if (atomic)

This is unnecessary, there is exactly one caller and it is always "atomic".

Assuming some of this code lives on (see below), I'd prefer a different name
than "atomic".  Writing the SPTE is atomic (though even that is a bit of a lie,
e.g. tdp_mmu_zap_spte_atomic() is very much not atomic), but all the other
operations are the exact opposite of atomic.

Maybe change it from a bool to an enum with READ/WRITE_LOCKED or something?

> +		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> +	else
> +		kvm_mmu_lock_assert_held_exclusive(kvm);
> +
> +	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
> +	if (account_nx)
> +		account_huge_nx_page(kvm, sp);
> +
> +	if (atomic)
> +		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> +}
> +
> +/**
> + * tdp_mmu_unlink_page - Remove page from the list of pages used by the TDP MMU
> + *
> + * @kvm: kvm instance
> + * @sp: the page to be removed
> + * @atomic: This operation is not running under the exclusive use of the MMU
> + *	    lock and the operation must be atomic with respect to ther threads
> + *	    that might be adding or removing pages.
> + */
> +static void tdp_mmu_unlink_page(struct kvm *kvm, struct kvm_mmu_page *sp,
> +				bool atomic)
> +{
> +	if (atomic)

Summarizing an off-list discussion with Ben:

This path isn't reachable in this series, which means all the RCU stuff is more
or less untestable.  Only the page fault path modifies the MMU while hold a read
lock, and it can't zap non-leaf shadow pages (only zaps large SPTEs and installs
new SPs).

The intent is to convert other zap-happy paths to a read lock, notably
kvm_mmu_zap_collapsible_sptes() and kvm_recover_nx_lpages().  Ben will include
patches to convert at least one of those in the next version of this series so
that there is justification and coverage for the RCU-deferred freeing.

> +		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> +	else
> +		kvm_mmu_lock_assert_held_exclusive(kvm);
> +	list_del(&sp->link);
> +	if (sp->lpage_disallowed)
> +		unaccount_huge_nx_page(kvm, sp);
> +
> +	if (atomic)
> +		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> +}
> +
>  /**
>   * handle_disconnected_tdp_mmu_page - handle a pt removed from the TDP structure
>   *
