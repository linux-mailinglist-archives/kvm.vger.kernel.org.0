Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249B6375DAB
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 01:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbhEFXr4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 19:47:56 -0400
Received: from mga12.intel.com ([192.55.52.136]:25761 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233048AbhEFXr4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 19:47:56 -0400
IronPort-SDR: h2Tsndpztda0VmI9TeR1aYdbrQSulasFBBTjTdZYZ82HGTAW/4SuDIo7SRt67tWHU+8j9mh657
 YSaI0eJvNMFg==
X-IronPort-AV: E=McAfee;i="6200,9189,9976"; a="178166102"
X-IronPort-AV: E=Sophos;i="5.82,279,1613462400"; 
   d="scan'208";a="178166102"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2021 16:46:57 -0700
IronPort-SDR: Lew9EehpDHGmCbcU+0aSa4w7SXOpb6uF2TXSmc+emD8e9VSTfM9nZ89IURw2ZtsoCW6ex30Tqb
 UNeuk+VNZKBg==
X-IronPort-AV: E=Sophos;i="5.82,279,1613462400"; 
   d="scan'208";a="622645850"
Received: from jasonbai-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.141.48])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2021 16:46:54 -0700
Message-ID: <6e9c2f0b6e36342ee4955178a92fa34c47c6de99.camel@intel.com>
Subject: Re: [PATCH v2 3/3] KVM: x86/mmu: Fix TDP MMU page table level
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, bgardon@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
Date:   Fri, 07 May 2021 11:46:52 +1200
In-Reply-To: <d689dc6f19fc92d3db64065377df2eb48c09f07b.1620343751.git.kai.huang@intel.com>
References: <cover.1620343751.git.kai.huang@intel.com>
         <d689dc6f19fc92d3db64065377df2eb48c09f07b.1620343751.git.kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0 (3.40.0-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Oops, this patch has a merge conflict with latest kvm/queue due to patch 
ff76d506030da ("KVM: x86/mmu: Avoid unnecessary page table allocation in
kvm_tdp_mmu_map()), but it is very easy to resolve.

Sorry that I forgot to git pull before sending those :)

On Fri, 2021-05-07 at 11:34 +1200, Kai Huang wrote:
> TDP MMU iterator's level is identical to page table's actual level.  For
> instance, for the last level page table (whose entry points to one 4K
> page), iter->level is 1 (PG_LEVEL_4K), and in case of 5 level paging,
> the iter->level is mmu->shadow_root_level, which is 5.  However, struct
> kvm_mmu_page's level currently is not set correctly when it is allocated
> in kvm_tdp_mmu_map().  When iterator hits non-present SPTE and needs to
> allocate a new child page table, currently iter->level, which is the
> level of the page table where the non-present SPTE belongs to, is used.
> This results in struct kvm_mmu_page's level always having its parent's
> level (excpet root table's level, which is initialized explicitly using
> mmu->shadow_root_level).
> 
> This is kinda wrong, and not consistent with existing non TDP MMU code.
> Fortuantely sp->role.level is only used in handle_removed_tdp_mmu_page()
> and kvm_tdp_mmu_zap_sp(), and they are already aware of this and behave
> correctly.  However to make it consistent with legacy MMU code (and fix
> the issue that both root page table and its child page table have
> shadow_root_level), use iter->level - 1 in kvm_tdp_mmu_map(), and change
> handle_removed_tdp_mmu_page() and kvm_tdp_mmu_zap_sp() accordingly.
> 
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 8 ++++----
>  arch/x86/kvm/mmu/tdp_mmu.h | 2 +-
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index c389d20418e3..a1db99d10680 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -335,7 +335,7 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
>  
> 
>  	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
>  		sptep = rcu_dereference(pt) + i;
> -		gfn = base_gfn + (i * KVM_PAGES_PER_HPAGE(level - 1));
> +		gfn = base_gfn + i * KVM_PAGES_PER_HPAGE(level);
>  
> 
>  		if (shared) {
>  			/*
> @@ -377,12 +377,12 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
>  			WRITE_ONCE(*sptep, REMOVED_SPTE);
>  		}
>  		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
> -				    old_child_spte, REMOVED_SPTE, level - 1,
> +				    old_child_spte, REMOVED_SPTE, level,
>  				    shared);
>  	}
>  
> 
>  	kvm_flush_remote_tlbs_with_address(kvm, gfn,
> -					   KVM_PAGES_PER_HPAGE(level));
> +					   KVM_PAGES_PER_HPAGE(level + 1));
>  
> 
>  	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
>  }
> @@ -1013,7 +1013,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>  		}
>  
> 
>  		if (!is_shadow_present_pte(iter.old_spte)) {
> -			sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level);
> +			sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level - 1);
>  			child_pt = sp->spt;
>  
> 
>  			new_spte = make_nonleaf_spte(child_pt,
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index 5fdf63090451..7f9974c5d0b4 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -31,7 +31,7 @@ static inline bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id,
>  }
>  static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>  {
> -	gfn_t end = sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level);
> +	gfn_t end = sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level + 1);
>  
> 
>  	/*
>  	 * Don't allow yielding, as the caller may have a flush pending.  Note,


