Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50CBA10F3A3
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 00:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbfLBXyi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 18:54:38 -0500
Received: from mga06.intel.com ([134.134.136.31]:13384 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbfLBXyh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 18:54:37 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Dec 2019 15:54:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,270,1571727600"; 
   d="scan'208";a="218480852"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 02 Dec 2019 15:54:36 -0800
Date:   Mon, 2 Dec 2019 15:54:36 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [RFC PATCH 11/28] kvm: mmu: Optimize for freeing direct MMU PTs
 on teardown
Message-ID: <20191202235436.GI8120@linux.intel.com>
References: <20190926231824.149014-1-bgardon@google.com>
 <20190926231824.149014-12-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926231824.149014-12-bgardon@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 26, 2019 at 04:18:07PM -0700, Ben Gardon wrote:
> Waiting for a TLB flush and an RCU grace priod before freeing page table
> memory grants safety in steady state operation, however these
> protections are not always necessary. On VM teardown, only one thread is
> operating on the paging structures and no vCPUs are running. As a result
> a fast path can be added to the disconnected page table handler which
> frees the memory immediately. Add the fast path and use it when tearing
> down VMs.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---

...

> @@ -1849,13 +1863,20 @@ static void handle_disconnected_pt(struct kvm *kvm, int as_id,
>  		 * try to map in an entry there or try to free any child page
>  		 * table the entry might have pointed to.
>  		 */
> -		mark_pte_disconnected(kvm, as_id, gfn, &pt[i], level);
> +		mark_pte_disconnected(kvm, as_id, gfn, &pt[i], level,
> +				      vm_teardown);
>  
>  		gfn += KVM_PAGES_PER_HPAGE(level);
>  	}
>  
> -	page = pfn_to_page(pfn);
> -	direct_mmu_disconnected_pt_list_add(kvm, page);
> +	if (vm_teardown) {
> +		BUG_ON(atomic_read(&kvm->online_vcpus) != 0);

BUG() isn't justified here, e.g.

	if (vm_teardown && !WARN_ON_ONCE(atomic_read(&kvm->online_vcpus)))

> +		cond_resched();
> +		free_page((unsigned long)pt);
> +	} else {
> +		page = pfn_to_page(pfn);
> +		direct_mmu_disconnected_pt_list_add(kvm, page);
> +	}
>  }
>  
>  /**
> @@ -1866,6 +1887,8 @@ static void handle_disconnected_pt(struct kvm *kvm, int as_id,
>   * @old_pte: The value of the PTE before the atomic compare / exchange
>   * @new_pte: The value of the PTE after the atomic compare / exchange
>   * @level: the level of the PT the PTE is part of in the paging structure
> + * @vm_teardown: all vCPUs are paused and the VM is being torn down. Yield and
> + *	free child page table memory immediately.
>   *
>   * Handle bookkeeping that might result from the modification of a PTE.
>   * This function should be called in the same RCU read critical section as the
> @@ -1874,7 +1897,8 @@ static void handle_disconnected_pt(struct kvm *kvm, int as_id,
>   * setting the dirty bit on a pte.
>   */
>  static void handle_changed_pte(struct kvm *kvm, int as_id, gfn_t gfn,
> -			       u64 old_pte, u64 new_pte, int level)
> +			       u64 old_pte, u64 new_pte, int level,
> +			       bool vm_teardown)
>  {
>  	bool was_present = is_present_direct_pte(old_pte);
>  	bool is_present = is_present_direct_pte(new_pte);
> @@ -1920,7 +1944,7 @@ static void handle_changed_pte(struct kvm *kvm, int as_id, gfn_t gfn,
>  		 * pointed to must be freed.
>  		 */
>  		handle_disconnected_pt(kvm, as_id, gfn, spte_to_pfn(old_pte),
> -				       child_level);
> +				       child_level, vm_teardown);
>  	}
>  }
>  
> @@ -5932,7 +5956,7 @@ static void kvm_mmu_uninit_direct_mmu(struct kvm *kvm)
>  	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
>  		handle_disconnected_pt(kvm, i, 0,
>  			(kvm_pfn_t)(kvm->arch.direct_root_hpa[i] >> PAGE_SHIFT),
> -			PT64_ROOT_4LEVEL);
> +			PT64_ROOT_4LEVEL, true);
>  }
>  
>  /* The return value indicates if tlb flush on all vcpus is needed. */
> -- 
> 2.23.0.444.g18eeb5a265-goog
> 
