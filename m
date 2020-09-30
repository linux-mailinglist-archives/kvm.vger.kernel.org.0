Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7346F27F127
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 20:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgI3SQE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 14:16:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:12672 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgI3SQE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 14:16:04 -0400
IronPort-SDR: RuYktZGmQN15fYJHBztPBFnyGIfQ2vBGqLJ16bQOqoHEBimkmX8r+0xvSlKeu4+IBxJGy0znkI
 a64Sgm87vpKw==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="180676786"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="180676786"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 11:16:01 -0700
IronPort-SDR: qOtP+Xq8RizWohlHKTgw4QGoMJxFFCizQyysLgd5POdJu7xhZ++9QmVAtLG5XwbKkcq9zNr8k8
 v4Vjzj3WJA8A==
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="345722972"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 11:15:59 -0700
Date:   Wed, 30 Sep 2020 11:15:57 -0700
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
Subject: Re: [PATCH 20/22] kvm: mmu: NX largepage recovery for TDP MMU
Message-ID: <20200930181556.GJ32672@linux.intel.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-21-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925212302.3979661-21-bgardon@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 25, 2020 at 02:23:00PM -0700, Ben Gardon wrote:
> +/*
> + * Clear non-leaf SPTEs and free the page tables they point to, if those SPTEs
> + * exist in order to allow execute access on a region that would otherwise be
> + * mapped as a large page.
> + */
> +void kvm_tdp_mmu_recover_nx_lpages(struct kvm *kvm)
> +{
> +	struct kvm_mmu_page *sp;
> +	bool flush;
> +	int rcu_idx;
> +	unsigned int ratio;
> +	ulong to_zap;
> +	u64 old_spte;
> +
> +	rcu_idx = srcu_read_lock(&kvm->srcu);
> +	spin_lock(&kvm->mmu_lock);
> +
> +	ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
> +	to_zap = ratio ? DIV_ROUND_UP(kvm->stat.nx_lpage_splits, ratio) : 0;

This is broken, and possibly related to Paolo's INIT_LIST_HEAD issue.  The TDP
MMU never increments nx_lpage_splits, it instead has its own counter,
tdp_mmu_lpage_disallowed_page_count.  Unless I'm missing something, to_zap is
guaranteed to be zero and thus this is completely untested.

I don't see any reason for a separate tdp_mmu_lpage_disallowed_page_count,
a single VM can't have both a legacy MMU and a TDP MMU, so it's not like there
will be collisions with other code incrementing nx_lpage_splits.   And the TDP
MMU should be updating stats anyways.

> +
> +	while (to_zap &&
> +	       !list_empty(&kvm->arch.tdp_mmu_lpage_disallowed_pages)) {
> +		/*
> +		 * We use a separate list instead of just using active_mmu_pages
> +		 * because the number of lpage_disallowed pages is expected to
> +		 * be relatively small compared to the total.
> +		 */
> +		sp = list_first_entry(&kvm->arch.tdp_mmu_lpage_disallowed_pages,
> +				      struct kvm_mmu_page,
> +				      lpage_disallowed_link);
> +
> +		old_spte = *sp->parent_sptep;
> +		*sp->parent_sptep = 0;
> +
> +		list_del(&sp->lpage_disallowed_link);
> +		kvm->arch.tdp_mmu_lpage_disallowed_page_count--;
> +
> +		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), sp->gfn,
> +				    old_spte, 0, sp->role.level + 1);
> +
> +		flush = true;
> +
> +		if (!--to_zap || need_resched() ||
> +		    spin_needbreak(&kvm->mmu_lock)) {
> +			flush = false;
> +			kvm_flush_remote_tlbs(kvm);
> +			if (to_zap)
> +				cond_resched_lock(&kvm->mmu_lock);
> +		}
> +	}
> +
> +	if (flush)
> +		kvm_flush_remote_tlbs(kvm);
> +
> +	spin_unlock(&kvm->mmu_lock);
> +	srcu_read_unlock(&kvm->srcu, rcu_idx);
> +}
> +
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index 2ecb047211a6d..45ea2d44545db 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -43,4 +43,6 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
>  
>  bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
>  				   struct kvm_memory_slot *slot, gfn_t gfn);
> +
> +void kvm_tdp_mmu_recover_nx_lpages(struct kvm *kvm);
>  #endif /* __KVM_X86_MMU_TDP_MMU_H */
> -- 
> 2.28.0.709.gb0816b6eb0-goog
> 
