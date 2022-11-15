Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00DFF628E1F
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 01:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237168AbiKOAQ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 19:16:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237386AbiKOAQ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 19:16:56 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA8301CFD7
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 16:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668471415; x=1700007415;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rDfSMmItk9UMZqplOr9m3YpZG0wjl3AjvLPoyl7fl10=;
  b=jNkBna7nhm4lzW/FOF8HQOamz5WAa7EfJDVK3if/UlmM3J30tpC4/2Vs
   a6MErKhKbH7h53XIf3kmI5jnzh6Qm1s6GZSedqkwoZSe5tj63v5/+2n1P
   WZgJIkvbd1/IttesfsMtmjImcwLm0shVgmCTiLzd/Erh+ND2bRXb0TaRD
   eH9UKhzQzlCT88yqGNEsFZ/8rHzAv7NwBMMaLBGhl3bF90h5ldyuIFjH5
   4kIx99oVG9D6WaFJKyrinnZZJpNu07tYbpCXNBPvobcEfEsl3+RbxhhB/
   jBm0NYR63IDJkI6wXnvRTZHAnjlgGTrtBf3Hj4rnh0kY4LkQNiRLJxc12
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="295481066"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="295481066"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 16:16:55 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="763699055"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="763699055"
Received: from yjiang5-mobl.amr.corp.intel.com (HELO localhost) ([10.212.78.37])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 16:16:54 -0800
Date:   Mon, 14 Nov 2022 16:16:52 -0800
From:   Yunhong Jiang <yunhong.jiang@linux.intel.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v7 2/4] KVM: x86: Dirty quota-based throttling of vcpus
Message-ID: <20221115001652.GB7867@yjiang5-mobl.amr.corp.intel.com>
References: <20221113170507.208810-1-shivam.kumar1@nutanix.com>
 <20221113170507.208810-3-shivam.kumar1@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221113170507.208810-3-shivam.kumar1@nutanix.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 13, 2022 at 05:05:08PM +0000, Shivam Kumar wrote:
> Exit to userspace whenever the dirty quota is exhausted (i.e. dirty count
> equals/exceeds dirty quota) to request more dirty quota.
> 
> Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
> Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
> Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
> Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
> Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
> ---
>  arch/x86/kvm/mmu/spte.c |  4 ++--
>  arch/x86/kvm/vmx/vmx.c  |  3 +++
>  arch/x86/kvm/x86.c      | 28 ++++++++++++++++++++++++++++
>  3 files changed, 33 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 2e08b2a45361..c0ed35abbf2d 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -228,9 +228,9 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  		  "spte = 0x%llx, level = %d, rsvd bits = 0x%llx", spte, level,
>  		  get_rsvd_bits(&vcpu->arch.mmu->shadow_zero_check, spte, level));
>  
> -	if ((spte & PT_WRITABLE_MASK) && kvm_slot_dirty_track_enabled(slot)) {
> +	if (spte & PT_WRITABLE_MASK) {
>  		/* Enforced by kvm_mmu_hugepage_adjust. */
> -		WARN_ON(level > PG_LEVEL_4K);
> +		WARN_ON(level > PG_LEVEL_4K && kvm_slot_dirty_track_enabled(slot));
>  		mark_page_dirty_in_slot(vcpu->kvm, slot, gfn);
>  	}
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 63247c57c72c..cc130999eddf 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5745,6 +5745,9 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
>  		 */
>  		if (__xfer_to_guest_mode_work_pending())
>  			return 1;
> +
> +		if (kvm_test_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu))
> +			return 1;
Any reason for this check? Is this quota related to the invalid
guest state? Sorry if I missed anything here.

>  	}
>  
>  	return 1;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ecea83f0da49..1a960fbb51f4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10494,6 +10494,30 @@ void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(__kvm_request_immediate_exit);
>  
> +static inline bool kvm_check_dirty_quota_request(struct kvm_vcpu *vcpu)
> +{
> +#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
> +	struct kvm_run *run;
> +
> +	if (kvm_check_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu)) {
> +		run = vcpu->run;
> +		run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
> +		run->dirty_quota_exit.count = vcpu->stat.generic.pages_dirtied;
> +		run->dirty_quota_exit.quota = READ_ONCE(run->dirty_quota);
> +
> +		/*
> +		 * Re-check the quota and exit if and only if the vCPU still
> +		 * exceeds its quota.  If userspace increases (or disables
> +		 * entirely) the quota, then no exit is required as KVM is
> +		 * still honoring its ABI, e.g. userspace won't even be aware
> +		 * that KVM temporarily detected an exhausted quota.
> +		 */
> +		return run->dirty_quota_exit.count >= run->dirty_quota_exit.quota;
Would it be better to check before updating the vcpu->run?
