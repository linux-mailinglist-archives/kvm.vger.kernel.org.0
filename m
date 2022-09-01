Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29FD95A8F83
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 09:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233643AbiIAHNO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 03:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233592AbiIAHM6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 03:12:58 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C81E1900;
        Thu,  1 Sep 2022 00:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662016351; x=1693552351;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sQhyHL6hS35prQrSkgLt3XWGUVDUcJl3AOmgN1aiDzY=;
  b=VotLmbBsMCsrt+Q6+51auHFcy4D04AbUhSCR+mgrHlfszkoHlH6N0ugu
   mSm32IRzrBIo69hnECfdlH1I/O/h/clLWrZiAeODoWo+Hwue8izNF/0+i
   ejs71WQ6WZOBv/S7iafI2Ck0QRicFElpOdJM//tz1sGO5UV8IvX1i98HX
   Ooqn5x1c+19TkcqSGhXEch+ioVaoYXF+2uYabDIOg3uf5+7LGR+fpc5Nz
   4e3z9npldEi6sCN0Yy5shElIfiYkYYOl8uyxevCijboUCCdxoxCpIvNIC
   lVtkMPNZm+u/BgkXt+kyFhoku6fsoD0AZsdZwXaPlrzptMwwVs0lQdFFQ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="294376961"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="294376961"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 00:12:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="612385810"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga002.jf.intel.com with ESMTP; 01 Sep 2022 00:12:24 -0700
Date:   Thu, 1 Sep 2022 15:12:23 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: Re: [PATCH v8 039/103] KVM: x86/tdp_mmu: Init role member of struct
 kvm_mmu_page at allocation
Message-ID: <20220901071223.djud2czl3owgris4@yy-desk-7060>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <0a8fa20533048189106f9d0f100acf59602bb502.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a8fa20533048189106f9d0f100acf59602bb502.1659854790.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 07, 2022 at 03:01:24PM -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Refactor tdp_mmu_alloc_sp() and tdp_mmu_init_sp and eliminate
> tdp_mmu_init_child_sp().  Currently tdp_mmu_init_sp() (or
> tdp_mmu_init_child_sp()) sets kvm_mmu_page.role after tdp_mmu_alloc_sp()
> allocating struct kvm_mmu_page and its page table page.  This patch makes
> tdp_mmu_alloc_sp() initialize kvm_mmu_page.role instead of
> tdp_mmu_init_sp().
>
> To handle private page tables, argument of is_private needs to be passed
> down.  Given that already page level is passed down, it would be cumbersome
> to add one more parameter about sp. Instead replace the level argument with
> union kvm_mmu_page_role.  Thus the number of argument won't be increased
> and more info about sp can be passed down.

Please update the description, no level argument is replaced in this
patch.

>
> For private sp, secure page table will be also allocated in addition to
> struct kvm_mmu_page and page table (spt member).  The allocation functions
> (tdp_mmu_alloc_sp() and __tdp_mmu_alloc_sp_for_split()) need to know if the
> allocation is for the conventional page table or private page table.  Pass
> union kvm_mmu_role to those functions and initialize role member of struct
> kvm_mmu_page.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/mmu/tdp_iter.h | 12 ++++++++++
>  arch/x86/kvm/mmu/tdp_mmu.c  | 45 +++++++++++++++++--------------------
>  2 files changed, 32 insertions(+), 25 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
> index f0af385c56e0..9e56a5b1024c 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.h
> +++ b/arch/x86/kvm/mmu/tdp_iter.h
> @@ -115,4 +115,16 @@ void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
>  void tdp_iter_next(struct tdp_iter *iter);
>  void tdp_iter_restart(struct tdp_iter *iter);
>
> +static inline union kvm_mmu_page_role tdp_iter_child_role(struct tdp_iter *iter)
> +{
> +	union kvm_mmu_page_role child_role;
> +	struct kvm_mmu_page *parent_sp;
> +
> +	parent_sp = sptep_to_sp(rcu_dereference(iter->sptep));
> +
> +	child_role = parent_sp->role;
> +	child_role.level--;
> +	return child_role;
> +}
> +
>  #endif /* __KVM_X86_MMU_TDP_ITER_H */
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 90b468a3a1a2..ce69535754ff 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -271,22 +271,28 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
>  		    kvm_mmu_page_as_id(_root) != _as_id) {		\
>  		} else
>
> -static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
> +static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu,
> +					     union kvm_mmu_page_role role)
>  {
>  	struct kvm_mmu_page *sp;
>
>  	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
>  	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> +	sp->role = role;
>
>  	return sp;
>  }
>
>  static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
> -			    gfn_t gfn, union kvm_mmu_page_role role)
> +			    gfn_t gfn)
>  {
>  	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
>
> -	sp->role = role;
> +	/*
> +	 * role must be set before calling this function.  At least role.level
> +	 * is not 0 (PG_LEVEL_NONE).
> +	 */
> +	WARN_ON(!sp->role.word);
>  	sp->gfn = gfn;
>  	sp->ptep = sptep;
>  	sp->tdp_mmu_page = true;
> @@ -294,20 +300,6 @@ static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
>  	trace_kvm_mmu_get_page(sp, true);
>  }
>
> -static void tdp_mmu_init_child_sp(struct kvm_mmu_page *child_sp,
> -				  struct tdp_iter *iter)
> -{
> -	struct kvm_mmu_page *parent_sp;
> -	union kvm_mmu_page_role role;
> -
> -	parent_sp = sptep_to_sp(rcu_dereference(iter->sptep));
> -
> -	role = parent_sp->role;
> -	role.level--;
> -
> -	tdp_mmu_init_sp(child_sp, iter->sptep, iter->gfn, role);
> -}
> -
>  hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
>  {
>  	union kvm_mmu_page_role role = vcpu->arch.mmu->root_role;
> @@ -326,8 +318,8 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
>  			goto out;
>  	}
>
> -	root = tdp_mmu_alloc_sp(vcpu);
> -	tdp_mmu_init_sp(root, NULL, 0, role);
> +	root = tdp_mmu_alloc_sp(vcpu, role);
> +	tdp_mmu_init_sp(root, NULL, 0);
>
>  	refcount_set(&root->tdp_mmu_root_count, 1);
>
> @@ -1154,8 +1146,8 @@ static int tdp_mmu_populate_nonleaf(
>  	WARN_ON(is_shadow_present_pte(iter->old_spte));
>  	WARN_ON(is_removed_spte(iter->old_spte));
>
> -	sp = tdp_mmu_alloc_sp(vcpu);
> -	tdp_mmu_init_child_sp(sp, iter);
> +	sp = tdp_mmu_alloc_sp(vcpu, tdp_iter_child_role(iter));
> +	tdp_mmu_init_sp(sp, iter->sptep, iter->gfn);
>
>  	ret = tdp_mmu_link_sp(vcpu->kvm, iter, sp, account_nx, true);
>  	if (ret)
> @@ -1423,7 +1415,8 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
>  	return spte_set;
>  }
>
> -static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
> +static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(
> +	gfp_t gfp, union kvm_mmu_page_role role)
>  {
>  	struct kvm_mmu_page *sp;
>
> @@ -1433,6 +1426,7 @@ static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
>  	if (!sp)
>  		return NULL;
>
> +	sp->role = role;
>  	sp->spt = (void *)__get_free_page(gfp);
>  	if (!sp->spt) {
>  		kmem_cache_free(mmu_page_header_cache, sp);
> @@ -1446,6 +1440,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
>  						       struct tdp_iter *iter,
>  						       bool shared)
>  {
> +	union kvm_mmu_page_role role = tdp_iter_child_role(iter);
>  	struct kvm_mmu_page *sp;
>
>  	/*
> @@ -1457,7 +1452,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
>  	 * If this allocation fails we drop the lock and retry with reclaim
>  	 * allowed.
>  	 */
> -	sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT);
> +	sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT, role);
>  	if (sp)
>  		return sp;
>
> @@ -1469,7 +1464,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
>  		write_unlock(&kvm->mmu_lock);
>
>  	iter->yielded = true;
> -	sp = __tdp_mmu_alloc_sp_for_split(GFP_KERNEL_ACCOUNT);
> +	sp = __tdp_mmu_alloc_sp_for_split(GFP_KERNEL_ACCOUNT, role);
>
>  	if (shared)
>  		read_lock(&kvm->mmu_lock);
> @@ -1488,7 +1483,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
>  	const int level = iter->level;
>  	int ret, i;
>
> -	tdp_mmu_init_child_sp(sp, iter);
> +	tdp_mmu_init_sp(sp, iter->sptep, iter->gfn);
>
>  	/*
>  	 * No need for atomics when writing to sp->spt since the page table has
> --
> 2.25.1
>
