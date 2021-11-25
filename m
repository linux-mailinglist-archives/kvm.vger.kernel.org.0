Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE8D45D3DD
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 05:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237996AbhKYEYP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 23:24:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:34834 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238211AbhKYEWJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Nov 2021 23:22:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637813939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1fqU39dED2qlRuJQ5y9Cv0wjsRIVNN7ti/VU1j4R6ig=;
        b=EioYb/z8rN8BQm3IgkJJ6TlPZ4xzTTiA3UufEHSM94uo745MibEanU1P+xRZWoZ5eCHnC7
        tF6BnuSFRCMPfKhsErcEWEGE1ldrRkhZvIqZMDlJVzFheOxhZqeE8YB3dQpPQ60sJSnDAr
        mY/7oIbtqGBSrIJArYxbSVaLm3RMFps=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-81-yJFVKfW3Orm3MdZauvwi5Q-1; Wed, 24 Nov 2021 23:18:57 -0500
X-MC-Unique: yJFVKfW3Orm3MdZauvwi5Q-1
Received: by mail-pj1-f72.google.com with SMTP id x6-20020a17090a6c0600b001a724a5696cso2585344pjj.6
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 20:18:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1fqU39dED2qlRuJQ5y9Cv0wjsRIVNN7ti/VU1j4R6ig=;
        b=gy221mlW0BgQXIgW2Hg/aXA8dvnktMF7V9HrRQjXO1SDFMpdG+CfF2XJczlt4lFYQ9
         T45VYn0q3uqitr9jYcwgnz2tkguUFpoj0Yq1T7hrSuQBh/Bfw2fg77roiAVeSF9pUMDG
         MGutTCuB1Aaj345cvU0ZiCoDtsXgp4LLByRVwBaRYdClR2dCXwt3Xyp3K+ZTY7iqZNwc
         /IQzlKKYwLEWkP77askTkFPHmR4Oqtfd6nX3LBqgxY72uKsbwITZjav4NLI+D0y07ZcT
         qbfschoRMYqw5N07qMw4EnzmSrlwVyzrl7d5T+UioabVFuqFaM6X56Ns6R+ZoJd23a7d
         kfWw==
X-Gm-Message-State: AOAM531KIhA6aTSciMMmDN8N7qxxbwDg/T4P7FddfVEtgWrK6DCRoIhG
        pE7UbVzpn3ZKJe80VuwgFDctZPdUnb+vrjtRIWnRL6oB26qpMPIbuCLlsHbLXqKUkj/JcPMBNvG
        7kTq4ixBVI5i/
X-Received: by 2002:a63:7c2:: with SMTP id 185mr13916246pgh.406.1637813934782;
        Wed, 24 Nov 2021 20:18:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwpSDP+7QIYtdhR5abUmEScVhI5NGYueeIt2u1f+jPPHQ9xVyw9uKsmDeflcrB8465BVYWbQQ==
X-Received: by 2002:a63:7c2:: with SMTP id 185mr13916219pgh.406.1637813934436;
        Wed, 24 Nov 2021 20:18:54 -0800 (PST)
Received: from xz-m1.local ([94.177.118.150])
        by smtp.gmail.com with ESMTPSA id t4sm1316242pfq.163.2021.11.24.20.18.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 20:18:53 -0800 (PST)
Date:   Thu, 25 Nov 2021 12:18:45 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
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
Subject: Re: [PATCH 15/15] KVM: x86/mmu: Promote pages in-place when
 disabling dirty logging
Message-ID: <YZ8OpQmB/8k3/Maj@xz-m1.local>
References: <20211115234603.2908381-1-bgardon@google.com>
 <20211115234603.2908381-16-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211115234603.2908381-16-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Ben,

On Mon, Nov 15, 2021 at 03:46:03PM -0800, Ben Gardon wrote:
> When disabling dirty logging, the TDP MMU currently zaps each leaf entry
> mapping memory in the relevant memslot. This is very slow. Doing the zaps
> under the mmu read lock requires a TLB flush for every zap and the
> zapping causes a storm of ETP/NPT violations.
> 
> Instead of zapping, replace the split large pages with large page
> mappings directly. While this sort of operation has historically only
> been done in the vCPU page fault handler context, refactorings earlier
> in this series and the relative simplicity of the TDP MMU make it
> possible here as well.

Thanks for this patch, it looks very useful.

I've got a few comments below, but before that I've also got one off-topic
question too; it'll be great if you can help answer.

When I was looking into how the old code recovers the huge pages I found that
we'll leave the full-zero pgtable page there until the next page fault, then I
_think_ it'll be released only until the __handle_changed_spte() when we're
dropping the old spte (handle_removed_tdp_mmu_page).

As comment above handle_removed_tdp_mmu_page() showed, at this point IIUC
current thread should have exclusive ownership of this orphaned and abandoned
pgtable page, then why in handle_removed_tdp_mmu_page() we still need all the
atomic operations and REMOVED_SPTE tricks to protect from concurrent access?
Since that's cmpxchg-ed out of the old pgtable, what can be accessing it
besides the current thread?

> 
> Running the dirty_log_perf_test on an Intel Skylake with 96 vCPUs and 1G
> of memory per vCPU, this reduces the time required to disable dirty
> logging from over 45 seconds to just over 1 second. It also avoids
> provoking page faults, improving vCPU performance while disabling
> dirty logging.
> 
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c          |  2 +-
>  arch/x86/kvm/mmu/mmu_internal.h |  4 ++
>  arch/x86/kvm/mmu/tdp_mmu.c      | 69 ++++++++++++++++++++++++++++++++-
>  3 files changed, 72 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index ef7a84422463..add724aa9e8c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4449,7 +4449,7 @@ static inline bool boot_cpu_is_amd(void)
>   * the direct page table on host, use as much mmu features as
>   * possible, however, kvm currently does not do execution-protection.
>   */
> -static void
> +void
>  build_tdp_shadow_zero_bits_mask(struct rsvd_bits_validate *shadow_zero_check,
>  				int shadow_root_level)
>  {
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 6563cce9c438..84d439432acf 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -161,4 +161,8 @@ void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
>  void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
>  void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
>  
> +void
> +build_tdp_shadow_zero_bits_mask(struct rsvd_bits_validate *shadow_zero_check,
> +				int shadow_root_level);
> +
>  #endif /* __KVM_X86_MMU_INTERNAL_H */
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 43c7834b4f0a..b15c8cd11cf9 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1361,6 +1361,66 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
>  		clear_dirty_pt_masked(kvm, root, gfn, mask, wrprot);
>  }
>  
> +static void try_promote_lpage(struct kvm *kvm,
> +			      const struct kvm_memory_slot *slot,
> +			      struct tdp_iter *iter)
> +{
> +	struct kvm_mmu_page *sp = sptep_to_sp(iter->sptep);
> +	struct rsvd_bits_validate shadow_zero_check;
> +	/*
> +	 * Since the TDP  MMU doesn't manage nested PTs, there's no need to
> +	 * write protect for a nested VM when PML is in use.
> +	 */
> +	bool ad_need_write_protect = false;

Shall we just pass in "false" in make_spte() and just move the comment there?

> +	bool map_writable;
> +	kvm_pfn_t pfn;
> +	u64 new_spte;
> +	u64 mt_mask;
> +
> +	/*
> +	 * If addresses are being invalidated, don't do in-place promotion to
> +	 * avoid accidentally mapping an invalidated address.
> +	 */
> +	if (unlikely(kvm->mmu_notifier_count))
> +		return;
> +
> +	pfn = __gfn_to_pfn_memslot(slot, iter->gfn, true, NULL, true,
> +				   &map_writable, NULL);

Should we better check pfn validity and bail out otherwise?  E.g. for atomic I
think we can also get KVM_PFN_ERR_FAULT when fast-gup failed somehow.

> +
> +	/*
> +	 * Can't reconstitute an lpage if the consituent pages can't be
> +	 * mapped higher.
> +	 */
> +	if (iter->level > kvm_mmu_max_mapping_level(kvm, slot, iter->gfn,
> +						    pfn, PG_LEVEL_NUM))
> +		return;
> +
> +	build_tdp_shadow_zero_bits_mask(&shadow_zero_check, iter->root_level);
> +
> +	/*
> +	 * In some cases, a vCPU pointer is required to get the MT mask,
> +	 * however in most cases it can be generated without one. If a
> +	 * vCPU pointer is needed kvm_x86_try_get_mt_mask will fail.
> +	 * In that case, bail on in-place promotion.
> +	 */
> +	if (unlikely(!static_call(kvm_x86_try_get_mt_mask)(kvm, iter->gfn,
> +							   kvm_is_mmio_pfn(pfn),
> +							   &mt_mask)))
> +		return;
> +
> +	make_spte(kvm, sp, slot, ACC_ALL, iter->gfn, pfn, 0, false, true,
> +		  map_writable, ad_need_write_protect, mt_mask,
> +		  &shadow_zero_check, &new_spte);
> +
> +	tdp_mmu_set_spte_atomic(kvm, iter, new_spte);
> +
> +	/*
> +	 * Re-read the SPTE to avoid recursing into one of the removed child
> +	 * page tables.
> +	 */
> +	iter->old_spte = READ_ONCE(*rcu_dereference(iter->sptep));

Is this redundant since it seems the iterator logic handles this already, I'm
reading try_step_down() here:

	/*
	 * Reread the SPTE before stepping down to avoid traversing into page
	 * tables that are no longer linked from this entry.
	 */
	iter->old_spte = READ_ONCE(*rcu_dereference(iter->sptep));

The rest looks good to me, thanks.

> +}
> +
>  /*
>   * Clear leaf entries which could be replaced by large mappings, for
>   * GFNs within the slot.
> @@ -1381,9 +1441,14 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
>  		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
>  			continue;
>  
> -		if (!is_shadow_present_pte(iter.old_spte) ||
> -		    !is_last_spte(iter.old_spte, iter.level))
> +		if (!is_shadow_present_pte(iter.old_spte))
> +			continue;
> +
> +		/* Try to promote the constitutent pages to an lpage. */
> +		if (!is_last_spte(iter.old_spte, iter.level)) {
> +			try_promote_lpage(kvm, slot, &iter);
>  			continue;
> +		}
>  
>  		pfn = spte_to_pfn(iter.old_spte);
>  		if (kvm_is_reserved_pfn(pfn) ||
> -- 
> 2.34.0.rc1.387.gb447b232ab-goog
> 

-- 
Peter Xu

