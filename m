Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C633462D04D
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 01:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233637AbiKQA7f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 19:59:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234568AbiKQA7d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 19:59:33 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295166A698
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 16:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668646771; x=1700182771;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Yml6vAiryq2rLd0oJuQAyoAoWv2KE6JoZo7EyhrOtGg=;
  b=QqL7cvbuoXLJnahuiXpfCK+MEDQfluVbK1b2ysIodbCDSvpIvn/FKSuu
   b6n5HNvSm8n+IoUqRZQ8ra5ARbfRjZ4aPKw+XFVdBEPM+PKO4wmaIu7WB
   SBHUkNb4+3RfX6MwTcL375HiTucWB7GWeWHzcYzBe51MBEdHXr9IW/vV+
   JGZzNQoZEc3YUCl7PS/Q5LTBZDRpYH8m1dknkf7otRiIWN7D0CWn7U3iw
   mqSnjAhlbe7omXxlbAOfDaARq5KR9m9nFLWhV+3uc/8N71YxaT4SuQ0md
   c4iuW57yoTOLGi/yTbTebl1JzgIQBAquNZfabNcr9WT6zpfetlMp0DL/l
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="339535484"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="339535484"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 16:59:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="639578775"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="639578775"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga002.jf.intel.com with ESMTP; 16 Nov 2022 16:59:28 -0800
Message-ID: <3f5459350a091e13093691584fd974d2ab86b844.camel@linux.intel.com>
Subject: Re: [PATCH v3 2/2] KVM: x86/mmu: Split huge pages mapped by the TDP
 MMU on fault
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>
Date:   Thu, 17 Nov 2022 08:59:28 +0800
In-Reply-To: <20221109185905.486172-3-dmatlack@google.com>
References: <20221109185905.486172-1-dmatlack@google.com>
         <20221109185905.486172-3-dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-11-09 at 10:59 -0800, David Matlack wrote:
> Now that the TDP MMU has a mechanism to split huge pages, use it in
> the
> fault path when a huge page needs to be replaced with a mapping at a
> lower level.
> 
> This change reduces the negative performance impact of NX HugePages.
> Prior to this change if a vCPU executed from a huge page and NX
> HugePages was enabled, the vCPU would take a fault, zap the huge
> page,
> and mapping the faulting address at 4KiB with execute permissions
> enabled. The rest of the memory would be left *unmapped* and have to
> be
> faulted back in by the guest upon access (read, write, or execute).
> If
> guest is backed by 1GiB, a single execute instruction can zap an
> entire
> GiB of its physical address space.
> 
> For example, it can take a VM longer to execute from its memory than
> to
> populate that memory in the first place:
> 
> $ ./execute_perf_test -s anonymous_hugetlb_1gb -v96
> 
> Populating memory             : 2.748378795s
> Executing from memory         : 2.899670885s
> 
> With this change, such faults split the huge page instead of zapping
> it,
> which avoids the non-present faults on the rest of the huge page:
> 
> $ ./execute_perf_test -s anonymous_hugetlb_1gb -v96
> 
> Populating memory             : 2.729544474s
> Executing from memory         : 0.111965688s   <---
> 
> This change also reduces the performance impact of dirty logging when
> eager_page_split=N. eager_page_split=N (abbreviated "eps=N" below)
> can
> be desirable for read-heavy workloads, as it avoids allocating memory
> to
> split huge pages that are never written and avoids increasing the TLB
> miss cost on reads of those pages.
> 
>              | Config: ept=Y, tdp_mmu=Y, 5% writes           |
>              | Iteration 1 dirty memory time                 |
>              | --------------------------------------------- |
> vCPU Count   | eps=N (Before) | eps=N (After) | eps=Y        |
> ------------ | -------------- | ------------- | ------------ |
> 2            | 0.332305091s   | 0.019615027s  | 0.006108211s |
> 4            | 0.353096020s   | 0.019452131s  | 0.006214670s |
> 8            | 0.453938562s   | 0.019748246s  | 0.006610997s |
> 16           | 0.719095024s   | 0.019972171s  | 0.007757889s |
> 32           | 1.698727124s   | 0.021361615s  | 0.012274432s |
> 64           | 2.630673582s   | 0.031122014s  | 0.016994683s |
> 96           | 3.016535213s   | 0.062608739s  | 0.044760838s |
> 
> Eager page splitting remains beneficial for write-heavy workloads,
> but
> the gap is now reduced.
> 
>              | Config: ept=Y, tdp_mmu=Y, 100% writes         |
>              | Iteration 1 dirty memory time                 |
>              | --------------------------------------------- |
> vCPU Count   | eps=N (Before) | eps=N (After) | eps=Y        |
> ------------ | -------------- | ------------- | ------------ |
> 2            | 0.317710329s   | 0.296204596s  | 0.058689782s |
> 4            | 0.337102375s   | 0.299841017s  | 0.060343076s |
> 8            | 0.386025681s   | 0.297274460s  | 0.060399702s |
> 16           | 0.791462524s   | 0.298942578s  | 0.062508699s |
> 32           | 1.719646014s   | 0.313101996s  | 0.075984855s |
> 64           | 2.527973150s   | 0.455779206s  | 0.079789363s |
> 96           | 2.681123208s   | 0.673778787s  | 0.165386739s |
> 
> Further study is needed to determine if the remaining gap is
> acceptable
> for customer workloads or if eager_page_split=N still requires a-
> priori
> knowledge of the VM workload, especially when considering these costs
> extrapolated out to large VMs with e.g. 416 vCPUs and 12TB RAM.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> Reviewed-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 73 ++++++++++++++++++----------------
> ----
>  1 file changed, 35 insertions(+), 38 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 4e5b3ae824c1..e08596775427 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1146,6 +1146,9 @@ static int tdp_mmu_link_sp(struct kvm *kvm,
> struct tdp_iter *iter,
>  	return 0;
>  }
>  
> +static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter
> *iter,
> +				   struct kvm_mmu_page *sp, bool
> shared);
> +
>  /*
>   * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by
> installing
>   * page tables and SPTEs to translate the faulting guest physical
> address.
> @@ -1171,49 +1174,42 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu,
> struct kvm_page_fault *fault)
>  		if (iter.level == fault->goal_level)
>  			break;
>  
> -		/*
> -		 * If there is an SPTE mapping a large page at a higher
> level
> -		 * than the target, that SPTE must be cleared and
> replaced
> -		 * with a non-leaf SPTE.
> -		 */
> +		/* Step down into the lower level page table if it
> exists. */
>  		if (is_shadow_present_pte(iter.old_spte) &&
> -		    is_large_pte(iter.old_spte)) {
> -			if (tdp_mmu_zap_spte_atomic(vcpu->kvm, &iter))
> -				break;
> +		    !is_large_pte(iter.old_spte))
> +			continue;
>  
> -			/*
> -			 * The iter must explicitly re-read the spte
> here
> -			 * because the new value informs the !present
> -			 * path below.
> -			 */
> -			iter.old_spte =
> kvm_tdp_mmu_read_spte(iter.sptep);
> -		}
> +		/*
> +		 * If SPTE has been frozen by another thread, just give
> up and
> +		 * retry, avoiding unnecessary page table allocation
> and free.
> +		 */
> +		if (is_removed_spte(iter.old_spte))
> +			break;

After break out, it immediately checks is_removed_spte(iter.old_spte)
and return, why not return here directly to avoid duplicated check and
another branch prediction?

	/*
	 * Force the guest to retry the access if the upper level SPTEs
aren't
	 * in place, or if the target leaf SPTE is frozen by another
CPU.
	 */
	if (iter.level != fault->goal_level ||
is_removed_spte(iter.old_spte)) {
		rcu_read_unlock();
		return RET_PF_RETRY;
	}
>  
> -		if (!is_shadow_present_pte(iter.old_spte)) {
> -			/*
> -			 * If SPTE has been frozen by another thread,
> just
> -			 * give up and retry, avoiding unnecessary page
> table
> -			 * allocation and free.
> -			 */
> -			if (is_removed_spte(iter.old_spte))
> -				break;
> +		/*
> +		 * The SPTE is either non-present or points to a huge
> page that
> +		 * needs to be split.
> +		 */
> +		sp = tdp_mmu_alloc_sp(vcpu);
> +		tdp_mmu_init_child_sp(sp, &iter);
>  
> -			sp = tdp_mmu_alloc_sp(vcpu);
> -			tdp_mmu_init_child_sp(sp, &iter);
> +		sp->nx_huge_page_disallowed = fault-
> >huge_page_disallowed;
>  
> -			sp->nx_huge_page_disallowed = fault-
> >huge_page_disallowed;
> +		if (is_shadow_present_pte(iter.old_spte))
> +			ret = tdp_mmu_split_huge_page(kvm, &iter, sp,
> true);
> +		else
> +			ret = tdp_mmu_link_sp(kvm, &iter, sp, true);
>  
> -			if (tdp_mmu_link_sp(kvm, &iter, sp, true)) {
> -				tdp_mmu_free_sp(sp);
> -				break;
> -			}
> +		if (ret) {
> +			tdp_mmu_free_sp(sp);
> +			break;
> +		}
>  
> -			if (fault->huge_page_disallowed &&
> -			    fault->req_level >= iter.level) {
> -				spin_lock(&kvm-
> >arch.tdp_mmu_pages_lock);
> -				track_possible_nx_huge_page(kvm, sp);
> -				spin_unlock(&kvm-
> >arch.tdp_mmu_pages_lock);
> -			}
> +		if (fault->huge_page_disallowed &&
> +		    fault->req_level >= iter.level) {
> +			spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> +			track_possible_nx_huge_page(kvm, sp);
> +			spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
>  		}
>  	}
>  
> @@ -1477,6 +1473,7 @@ static struct kvm_mmu_page
> *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
>  	return sp;
>  }
>  
> +/* Note, the caller is responsible for initializing @sp. */
>  static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter
> *iter,
>  				   struct kvm_mmu_page *sp, bool
> shared)
>  {
> @@ -1484,8 +1481,6 @@ static int tdp_mmu_split_huge_page(struct kvm
> *kvm, struct tdp_iter *iter,
>  	const int level = iter->level;
>  	int ret, i;
>  
> -	tdp_mmu_init_child_sp(sp, iter);
> -
>  	/*
>  	 * No need for atomics when writing to sp->spt since the page
> table has
>  	 * not been linked in yet and thus is not reachable from any
> other CPU.
> @@ -1561,6 +1556,8 @@ static int tdp_mmu_split_huge_pages_root(struct
> kvm *kvm,
>  				continue;
>  		}
>  
> +		tdp_mmu_init_child_sp(sp, &iter);
> +
>  		if (tdp_mmu_split_huge_page(kvm, &iter, sp, shared))
>  			goto retry;
>  

