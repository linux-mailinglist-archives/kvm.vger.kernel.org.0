Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11C827EED5
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 18:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731193AbgI3QTd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 12:19:33 -0400
Received: from mga05.intel.com ([192.55.52.43]:64644 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbgI3QTd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 12:19:33 -0400
IronPort-SDR: mOZd7KleMWX1bWkYpmxHerA/bGtKYtk99CN90aQ6XBtj2hS2Oa+ZFfrumUaVWqCQimlpUHy2Qd
 ABtbL4aQKWRw==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="247209205"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="247209205"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 09:19:32 -0700
IronPort-SDR: lQy4sSjZBrZDO0a9o6LdwCZ21ZukBxqKhZBO5e7oLF/nV7J5z3SgDsfiSxErnPIZO12UbAtp32
 +PVk782tYz/A==
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="350718946"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 09:19:31 -0700
Date:   Wed, 30 Sep 2020 09:19:30 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH 09/22] kvm: mmu: Remove disallowed_hugepage_adjust
 shadow_walk_iterator arg
Message-ID: <20200930161929.GC32672@linux.intel.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-10-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925212302.3979661-10-bgardon@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 25, 2020 at 02:22:49PM -0700, Ben Gardon wrote:
> In order to avoid creating executable hugepages in the TDP MMU PF
> handler, remove the dependency between disallowed_hugepage_adjust and
> the shadow_walk_iterator. This will open the function up to being used
> by the TDP MMU PF handler in a future patch.
> 
> Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
> machine. This series introduced no new failures.
> 
> This series can be viewed in Gerrit at:
> 	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c         | 17 +++++++++--------
>  arch/x86/kvm/mmu/paging_tmpl.h |  3 ++-
>  2 files changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6344e7863a0f5..f6e6fc9959c04 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3295,13 +3295,12 @@ static int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
>  	return level;
>  }
>  
> -static void disallowed_hugepage_adjust(struct kvm_shadow_walk_iterator it,
> -				       gfn_t gfn, kvm_pfn_t *pfnp, int *levelp)
> +static void disallowed_hugepage_adjust(u64 spte, gfn_t gfn, int cur_level,
> +					kvm_pfn_t *pfnp, int *goal_levelp)
>  {
> -	int level = *levelp;
> -	u64 spte = *it.sptep;
> +	int goal_level = *goal_levelp;

More bikeshedding...  Can we keep 'level' and 'levelp' instead of prepending
'goal_'?  I get the intent, but goal_level isn't necessarily accurate as the
original requested level (referred to as req_level in the caller in kvm/queue)
may be different than goal_level, i.e. this helper may have already decremented
the level.  IMO it's more accurate/correct to keep the plain 'level'.

> -	if (it.level == level && level > PG_LEVEL_4K &&
> +	if (cur_level == goal_level && goal_level > PG_LEVEL_4K &&
>  	    is_nx_huge_page_enabled() &&
>  	    is_shadow_present_pte(spte) &&
>  	    !is_large_pte(spte)) {
> @@ -3312,9 +3311,10 @@ static void disallowed_hugepage_adjust(struct kvm_shadow_walk_iterator it,
>  		 * patching back for them into pfn the next 9 bits of
>  		 * the address.
>  		 */
> -		u64 page_mask = KVM_PAGES_PER_HPAGE(level) - KVM_PAGES_PER_HPAGE(level - 1);
> +		u64 page_mask = KVM_PAGES_PER_HPAGE(goal_level) -
> +				KVM_PAGES_PER_HPAGE(goal_level - 1);
>  		*pfnp |= gfn & page_mask;
> -		(*levelp)--;
> +		(*goal_levelp)--;
>  	}
>  }
>  
> @@ -3339,7 +3339,8 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, int write,
>  		 * We cannot overwrite existing page tables with an NX
>  		 * large page, as the leaf could be executable.
>  		 */
> -		disallowed_hugepage_adjust(it, gfn, &pfn, &level);
> +		disallowed_hugepage_adjust(*it.sptep, gfn, it.level,
> +					   &pfn, &level);
>  
>  		base_gfn = gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
>  		if (it.level == level)
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 4dd6b1e5b8cf7..6a8666cb0d24b 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -690,7 +690,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
>  		 * We cannot overwrite existing page tables with an NX
>  		 * large page, as the leaf could be executable.
>  		 */
> -		disallowed_hugepage_adjust(it, gw->gfn, &pfn, &hlevel);
> +		disallowed_hugepage_adjust(*it.sptep, gw->gfn, it.level,
> +					   &pfn, &hlevel);
>  
>  		base_gfn = gw->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
>  		if (it.level == hlevel)
> -- 
> 2.28.0.709.gb0816b6eb0-goog
> 
