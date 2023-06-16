Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 533E6732926
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 09:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245443AbjFPHqZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 03:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245581AbjFPHqL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 03:46:11 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966AF297A;
        Fri, 16 Jun 2023 00:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686901556; x=1718437556;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2ap/OG37AUIM5SSj5+ylnzRSMSzektdaWhhsT69IsNU=;
  b=MKZsAm9aEMGjzI67C6oXR9RaYlhl/X5VghyKIVLszA9EsMhGk0IJAPDR
   BzJYSUZTlqzM66sBiBvtRJS6uVaa0g9XYvB2bm6nCx2Lfv4oKhrx/x3H9
   Mhj57Ss9YkpWPAfEwEJX02E+MsbsyDGDNNtq+bFUmfwsqwHgMgIzS0Amq
   mcf1Em8MQ+K2BfvNkBDbg7k4LcG34FdE74nAxskadwnr95eIzl6nnmU4n
   RzUp5Gnk++SjZdjj5+MTuh3gk6HDyLm1rjBIamsp2JzHyAkwpz8ywD6lE
   Hh0wltInjqxLGRTq2xndc62Rf1uWjcOpiJJ3R0qhO/0FmjMKKSiWJVSJM
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="348864784"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="348864784"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 00:45:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="782809809"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="782809809"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga004.fm.intel.com with ESMTP; 16 Jun 2023 00:45:51 -0700
Date:   Fri, 16 Jun 2023 15:45:50 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, chao.gao@intel.com,
        kai.huang@intel.com, robert.hoo.linux@gmail.com
Subject: Re: [PATCH v3 09/11] KVM: x86/mmu: serialize vCPUs to zap gfn when
 guest MTRRs are honored
Message-ID: <20230616074550.g2ikzbni2rjy7dfw@yy-desk-7060>
References: <20230616023101.7019-1-yan.y.zhao@intel.com>
 <20230616023945.7570-1-yan.y.zhao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616023945.7570-1-yan.y.zhao@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 16, 2023 at 10:39:45AM +0800, Yan Zhao wrote:
> Serialize concurrent and repeated calls of kvm_zap_gfn_range() from every
> vCPU for CR0.CD toggles and MTRR updates when guest MTRRs are honored.
>
> During guest boot-up, if guest MTRRs are honored by TDP, TDP zaps are
> triggered several times by each vCPU for CR0.CD toggles and MTRRs updates.
> This will take unexpected longer CPU cycles because of the contention of
> kvm->mmu_lock.
>
> Therefore, introduce a mtrr_zap_list to remove duplicated zap and an atomic
> mtrr_zapping to allow only one vCPU to do the real zap work at one time.
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |   4 +
>  arch/x86/kvm/mtrr.c             | 141 +++++++++++++++++++++++++++++++-
>  arch/x86/kvm/x86.c              |   2 +-
>  arch/x86/kvm/x86.h              |   1 +
>  4 files changed, 146 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 28bd38303d70..8da1517a1513 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1444,6 +1444,10 @@ struct kvm_arch {
>  	 */
>  #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
>  	struct kvm_mmu_memory_cache split_desc_cache;
> +
> +	struct list_head mtrr_zap_list;
> +	spinlock_t mtrr_zap_list_lock;
> +	atomic_t mtrr_zapping;
>  };
>
>  struct kvm_vm_stat {
> diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
> index b35dd0bc9cad..688748e3a4d2 100644
> --- a/arch/x86/kvm/mtrr.c
> +++ b/arch/x86/kvm/mtrr.c
> @@ -25,6 +25,8 @@
>  #define IA32_MTRR_DEF_TYPE_FE		(1ULL << 10)
>  #define IA32_MTRR_DEF_TYPE_TYPE_MASK	(0xff)
>
> +static void kvm_mtrr_zap_gfn_range(struct kvm_vcpu *vcpu,
> +				   gfn_t gfn_start, gfn_t gfn_end);
>  static bool is_mtrr_base_msr(unsigned int msr)
>  {
>  	/* MTRR base MSRs use even numbers, masks use odd numbers. */
> @@ -341,7 +343,7 @@ static void update_mtrr(struct kvm_vcpu *vcpu, u32 msr)
>  		var_mtrr_range(var_mtrr_msr_to_range(vcpu, msr), &start, &end);
>  	}
>
> -	kvm_zap_gfn_range(vcpu->kvm, gpa_to_gfn(start), gpa_to_gfn(end));
> +	kvm_mtrr_zap_gfn_range(vcpu, gpa_to_gfn(start), gpa_to_gfn(end));
>  }
>
>  static bool var_mtrr_range_is_valid(struct kvm_mtrr_range *range)
> @@ -437,6 +439,11 @@ int kvm_mtrr_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
>  void kvm_vcpu_mtrr_init(struct kvm_vcpu *vcpu)
>  {
>  	INIT_LIST_HEAD(&vcpu->arch.mtrr_state.head);
> +
> +	if (vcpu->vcpu_id == 0) {
> +		spin_lock_init(&vcpu->kvm->arch.mtrr_zap_list_lock);
> +		INIT_LIST_HEAD(&vcpu->kvm->arch.mtrr_zap_list);
> +	}
>  }
>
>  struct mtrr_iter {
> @@ -740,3 +747,135 @@ void kvm_mtrr_get_cd_memory_type(struct kvm_vcpu *vcpu, u8 *type, bool *ipat)
>  	}
>  }
>  EXPORT_SYMBOL_GPL(kvm_mtrr_get_cd_memory_type);
> +
> +struct mtrr_zap_range {
> +	gfn_t start;
> +	/* end is exclusive */
> +	gfn_t end;
> +	struct list_head node;
> +};
> +
> +static void kvm_clear_mtrr_zap_list(struct kvm *kvm)
> +{
> +	struct list_head *head = &kvm->arch.mtrr_zap_list;
> +	struct mtrr_zap_range *tmp, *n;
> +
> +	spin_lock(&kvm->arch.mtrr_zap_list_lock);
> +	list_for_each_entry_safe(tmp, n, head, node) {
> +		list_del(&tmp->node);
> +		kfree(tmp);
> +	}
> +	spin_unlock(&kvm->arch.mtrr_zap_list_lock);
> +}
> +
> +/*
> + * Add @range into kvm->arch.mtrr_zap_list and sort the list in
> + * "length" ascending + "start" descending order, so that
> + * ranges consuming more zap cycles can be dequeued later and their
> + * chances of being found duplicated are increased.
> + */
> +static void kvm_add_mtrr_zap_list(struct kvm *kvm, struct mtrr_zap_range *range)
> +{
> +	struct list_head *head = &kvm->arch.mtrr_zap_list;
> +	u64 len = range->end - range->start;
> +	struct mtrr_zap_range *cur, *n;
> +	bool added = false;
> +
> +	spin_lock(&kvm->arch.mtrr_zap_list_lock);
> +
> +	if (list_empty(head)) {
> +		list_add(&range->node, head);
> +		spin_unlock(&kvm->arch.mtrr_zap_list_lock);
> +		return;
> +	}
> +
> +	list_for_each_entry_safe(cur, n, head, node) {
> +		u64 cur_len = cur->end - cur->start;
> +
> +		if (len < cur_len)
> +			break;
> +
> +		if (len > cur_len)
> +			continue;
> +
> +		if (range->start > cur->start)
> +			break;
> +
> +		if (range->start < cur->start)
> +			continue;
> +
> +		/* equal len & start, no need to add */
> +		added = true;

Possible/worth to ignore the range already covered
by queued range ?

> +		kfree(range);
> +		break;
> +	}
> +
> +	if (!added)
> +		list_add_tail(&range->node, &cur->node);
> +
> +	spin_unlock(&kvm->arch.mtrr_zap_list_lock);
> +}
> +
> +static void kvm_zap_mtrr_zap_list(struct kvm *kvm)
> +{
> +	struct list_head *head = &kvm->arch.mtrr_zap_list;
> +	struct mtrr_zap_range *cur = NULL;
> +
> +	spin_lock(&kvm->arch.mtrr_zap_list_lock);
> +
> +	while (!list_empty(head)) {
> +		u64 start, end;
> +
> +		cur = list_first_entry(head, typeof(*cur), node);
> +		start = cur->start;
> +		end = cur->end;
> +		list_del(&cur->node);
> +		kfree(cur);
> +		spin_unlock(&kvm->arch.mtrr_zap_list_lock);
> +
> +		kvm_zap_gfn_range(kvm, start, end);
> +
> +		spin_lock(&kvm->arch.mtrr_zap_list_lock);
> +	}
> +
> +	spin_unlock(&kvm->arch.mtrr_zap_list_lock);
> +}
> +
> +static void kvm_zap_or_wait_mtrr_zap_list(struct kvm *kvm)
> +{
> +	if (atomic_cmpxchg_acquire(&kvm->arch.mtrr_zapping, 0, 1) == 0) {
> +		kvm_zap_mtrr_zap_list(kvm);
> +		atomic_set_release(&kvm->arch.mtrr_zapping, 0);
> +		return;
> +	}
> +
> +	while (atomic_read(&kvm->arch.mtrr_zapping))
> +		cpu_relax();
> +}
> +
> +static void kvm_mtrr_zap_gfn_range(struct kvm_vcpu *vcpu,
> +				   gfn_t gfn_start, gfn_t gfn_end)
> +{
> +	struct mtrr_zap_range *range;
> +
> +	range = kmalloc(sizeof(*range), GFP_KERNEL_ACCOUNT);
> +	if (!range)
> +		goto fail;
> +
> +	range->start = gfn_start;
> +	range->end = gfn_end;
> +
> +	kvm_add_mtrr_zap_list(vcpu->kvm, range);
> +
> +	kvm_zap_or_wait_mtrr_zap_list(vcpu->kvm);
> +	return;
> +
> +fail:
> +	kvm_clear_mtrr_zap_list(vcpu->kvm);

A very small chance race condition that incorrectly
clear the queued ranges which have not been zapped by another thread ?
Like below:

Thread A                         |  Thread B
kvm_add_mtrr_zap_list()          |
                                 |  kvm_clear_mtrr_zap_list()
kvm_zap_or_wait_mtrr_zap_list()  |

Call kvm_clear_mtrr_zap_list() here looks unnecessary, other
threads(B here) who put thing in the queue will take care them well.

> +	kvm_zap_gfn_range(vcpu->kvm, gfn_start, gfn_end);
> +}
> +
> +void kvm_zap_gfn_range_on_cd_toggle(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_mtrr_zap_gfn_range(vcpu, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
> +}
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 32cc8bfaa5f1..74aac14a3c0b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -943,7 +943,7 @@ void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned lon
>
>  	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
>  	    kvm_mmu_honors_guest_mtrrs(vcpu->kvm))
> -		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);

>  }
>  EXPORT_SYMBOL_GPL(kvm_post_set_cr0);
>
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 9781b4b32d68..be946aba2bf0 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -314,6 +314,7 @@ int kvm_mtrr_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata);
>  bool kvm_mtrr_check_gfn_range_consistency(struct kvm_vcpu *vcpu, gfn_t gfn,
>  					  int page_num);
>  void kvm_mtrr_get_cd_memory_type(struct kvm_vcpu *vcpu, u8 *type, bool *ipat);
> +void kvm_zap_gfn_range_on_cd_toggle(struct kvm_vcpu *vcpu);
>  bool kvm_vector_hashing_enabled(void);
>  void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_code);
>  int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
> --
> 2.17.1
>
