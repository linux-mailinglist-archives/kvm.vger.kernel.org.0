Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C645A725624
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 09:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239310AbjFGHoI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 03:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238737AbjFGHnk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 03:43:40 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1689335A2;
        Wed,  7 Jun 2023 00:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686123645; x=1717659645;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aMpkuX5Sw5My/OYgeGSE5OKSW09lmjDyiMmDlb2tVMM=;
  b=GV2ltWOznw3OZgdZGox4JvGG8ndt4TemIkMyuC9LgLtA+uWJSs0zP2R7
   HIDbpslxrpXYEc95gof9jIf7jUMuVbn0kwYBKw+297bBl+RKamkC6BcW3
   VgPzGtaVol+pMzfPO8WOoUh7+Rn8kLlwUiN/683v6Hi1TG1G+nmR3JGZR
   SMwut4G3XoyGxDjZp7Njn7H18IY8WjPE4B3ipvXdjrZ9RjCvB+EmrFIuX
   XFbYuXlbpYi1dCd2K0sMwelM5MNUX1+HBDD4Ev9IwPH/e+sMh0zYqtcHP
   GBpZVbdSrlnB565IuPjkHvaYC+RAP4vQ93j97j2MF8qRApUAaianHpG7a
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="420469737"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="420469737"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 00:40:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="659841952"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="659841952"
Received: from sihanche-mobl.ccr.corp.intel.com (HELO localhost) ([10.255.28.83])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 00:40:40 -0700
Date:   Wed, 7 Jun 2023 15:40:37 +0800
From:   yu.c.zhang@linux.intel.com
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH 1/3] KVM: VMX: Retry APIC-access page reload if
 invalidation is in-progress
Message-ID: <20230607073728.vggwcoylibj3cp6s@linux.intel.com>
References: <20230602011518.787006-1-seanjc@google.com>
 <20230602011518.787006-2-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602011518.787006-2-seanjc@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 01, 2023 at 06:15:16PM -0700, Sean Christopherson wrote:
> Re-request an APIC-access page reload if there is a relevant mmu_notifier
> invalidation in-progress when KVM retrieves the backing pfn, i.e. stall
> vCPUs until the backing pfn for the APIC-access page is "officially"
> stable.  Relying on the primary MMU to not make changes after invoking
> ->invalidate_range() works, e.g. any additional changes to a PRESENT PTE
> would also trigger an ->invalidate_range(), but using ->invalidate_range()
> to fudge around KVM not honoring past and in-progress invalidations is a
> bit hacky.
> 
> Honoring invalidations will allow using KVM's standard mmu_notifier hooks
> to detect APIC-access page reloads, which will in turn allow removing
> KVM's implementation of ->invalidate_range() (the APIC-access page case is
> a true one-off).
> 
> Opportunistically add a comment to explain why doing nothing if a memslot
> isn't found is functionally correct.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 50 +++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 45 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 44fb619803b8..59195f0dc7a5 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6708,7 +6708,12 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
>  
>  static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
>  {
> -	struct page *page;
> +	const gfn_t gfn = APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT;
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_memslots *slots = kvm_memslots(kvm);
> +	struct kvm_memory_slot *slot;
> +	unsigned long mmu_seq;
> +	kvm_pfn_t pfn;
>  
>  	/* Defer reload until vmcs01 is the current VMCS. */
>  	if (is_guest_mode(vcpu)) {
> @@ -6720,18 +6725,53 @@ static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
>  	    SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES))
>  		return;
>  
> -	page = gfn_to_page(vcpu->kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
> -	if (is_error_page(page))
> +	/*
> +	 * Grab the memslot so that the hva lookup for the mmu_notifier retry
> +	 * is guaranteed to use the same memslot as the pfn lookup, i.e. rely
> +	 * on the pfn lookup's validation of the memslot to ensure a valid hva
> +	 * is used for the retry check.
> +	 */
> +	slot = id_to_memslot(slots, APIC_ACCESS_PAGE_PRIVATE_MEMSLOT);
> +	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
>  		return;
>  
> -	vmcs_write64(APIC_ACCESS_ADDR, page_to_phys(page));
> +	/*
> +	 * Ensure that the mmu_notifier sequence count is read before KVM
> +	 * retrieves the pfn from the primary MMU.  Note, the memslot is
> +	 * protected by SRCU, not the mmu_notifier.  Pairs with the smp_wmb()
> +	 * in kvm_mmu_invalidate_end().
> +	 */
> +	mmu_seq = kvm->mmu_invalidate_seq;
> +	smp_rmb();
> +
> +	/*
> +	 * No need to retry if the memslot does not exist or is invalid.  KVM
> +	 * controls the APIC-access page memslot, and only deletes the memslot
> +	 * if APICv is permanently inhibited, i.e. the memslot won't reappear.
> +	 */
> +	pfn = gfn_to_pfn_memslot(slot, gfn);
> +	if (is_error_noslot_pfn(pfn))
> +		return;
> +
> +	read_lock(&vcpu->kvm->mmu_lock);
> +	if (mmu_invalidate_retry_hva(kvm, mmu_seq,
> +				     gfn_to_hva_memslot(slot, gfn))) {
> +		kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);

Are the mmu_invalidate_retry_hva() and the following request meant to stall
the vCPU if there's on going invalidation? 

If yes, may I ask how would the vCPU be stalled?

Below are my understandings and confusions about this process. I must have
missed something, waiting to be educated... :) 

When the backing page of APIC access page is to be reclaimed:
1> kvm_mmu_notifier_invalidate_range_start() -> __kvm_handle_hva_range() will
increase the kvm->mmu_invalidate_in_progress and account the start/end of this
page in kvm_mmu_invalidate_begin().
2> And then kvm_unmap_gfn_range() will zap the TDP, and send the request,
KVM_REQ_APIC_PAGE_RELOAD, to all vCPUs.
3> While a vCPU tries to reload the APIC access page before entering the guest,
kvm->mmu_invalidate_in_progress will be checked in mmu_invalidate_retry_hva(),
but it is possible(or is it?) that the kvm->mmu_invalidate_in_progess is still
positive, so KVM_REQ_APIC_PAGE_RELOAD is set again. No reload, and no TLB flush.
4> So what if the vCPU resumes with KVM_REQ_APIC_PAGE_RELOAD & KVM_REQ_TLB_FLUSH
flags being set, yet APIC access page is not reloaded and TLB is not flushed? Or,
will this happen?

One more dumb question - why does KVM not just pin the APIC access page? 

> +		read_unlock(&vcpu->kvm->mmu_lock);
> +		goto out;
> +	}
> +
> +	vmcs_write64(APIC_ACCESS_ADDR, pfn_to_hpa(pfn));
> +	read_unlock(&vcpu->kvm->mmu_lock);
> +
>  	vmx_flush_tlb_current(vcpu);
>  
> +out:
>  	/*
>  	 * Do not pin apic access page in memory, the MMU notifier
>  	 * will call us again if it is migrated or swapped out.
>  	 */
> -	put_page(page);
> +	kvm_release_pfn_clean(pfn);
>  }
>  
>  static void vmx_hwapic_isr_update(int max_isr)
> -- 
> 2.41.0.rc2.161.g9c6817b8e7-goog
> 

B.R.
Yu
