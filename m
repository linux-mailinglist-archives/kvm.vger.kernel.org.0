Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7D246A50C0
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 02:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbjB1Bbi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 20:31:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjB1Bbh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 20:31:37 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9685546A6
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 17:31:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677547895; x=1709083895;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Bj32I2zAx6+PHeK2dScNijceSDn4ytHmW8zFPbZVOCE=;
  b=KCWEYEztSnLp9gXKsyACr9/okOsUO3AOXLh/WK5QrEVzODmZgQIpts5G
   cej7elVX5yhzrczDICVWCAOOiYue7um0eYNA787WdFHGpWhnx8e5B/0TI
   0SefnSWA5yFXZTJekHxQCQxmR0FEL32Xt0oySjpwSZ00yIZhauol68YbG
   Ste/oylyALAQ6Zq13DlW+xB6cbBj7RNht3Qo6k9zl8RFmmgp3l28xUVPZ
   2qxHsYk1TuBaFxWCaDaRPTwfBskgBeErdRvjFuPLpHUOAt3/tA7ii4P5w
   qeg1Ozu0LpaPdWfAy8y8itFfgm8Y6LKBohZ30heZCkUpgGOU+385U5NHv
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="317820490"
X-IronPort-AV: E=Sophos;i="5.98,220,1673942400"; 
   d="scan'208";a="317820490"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 17:31:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="706389138"
X-IronPort-AV: E=Sophos;i="5.98,220,1673942400"; 
   d="scan'208";a="706389138"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga001.jf.intel.com with ESMTP; 27 Feb 2023 17:31:31 -0800
Date:   Tue, 28 Feb 2023 09:31:31 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com,
        aravind.retnakaran@nutanix.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v8 2/3] KVM: x86: Dirty quota-based throttling of vcpus
Message-ID: <20230228013131.o4xw3ikacrgyjc52@yy-desk-7060>
References: <20230225204758.17726-1-shivam.kumar1@nutanix.com>
 <20230225204758.17726-3-shivam.kumar1@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230225204758.17726-3-shivam.kumar1@nutanix.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 25, 2023 at 08:47:59PM +0000, Shivam Kumar wrote:
> Call update_dirty_quota whenever a page is marked dirty with
> appropriate arch-specific page size. Process the KVM request
> KVM_REQ_DIRTY_QUOTA_EXIT (raised by update_dirty_quota) to exit to
> userspace with exit reason KVM_EXIT_DIRTY_QUOTA_EXHAUSTED.
>
> Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
> Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
> Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
> Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
> Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
> ---
>  arch/x86/kvm/Kconfig       |  1 +
>  arch/x86/kvm/mmu/mmu.c     |  8 +++++++-
>  arch/x86/kvm/mmu/spte.c    |  3 +++
>  arch/x86/kvm/mmu/tdp_mmu.c |  3 +++
>  arch/x86/kvm/vmx/vmx.c     |  5 +++++
>  arch/x86/kvm/x86.c         | 16 ++++++++++++++++
>  arch/x86/kvm/xen.c         | 12 +++++++++++-
>  7 files changed, 46 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 8e578311ca9d..8621a9512572 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -48,6 +48,7 @@ config KVM
>  	select KVM_VFIO
>  	select SRCU
>  	select INTERVAL_TREE
> +	select HAVE_KVM_DIRTY_QUOTA
>  	select HAVE_KVM_PM_NOTIFIER if PM
>  	select KVM_GENERIC_HARDWARE_ENABLING
>  	help
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c8ebe542c565..e0c8348ecdf1 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3323,8 +3323,14 @@ fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>  	if (!try_cmpxchg64(sptep, &old_spte, new_spte))
>  		return false;
>
> -	if (is_writable_pte(new_spte) && !is_writable_pte(old_spte))
> +	if (is_writable_pte(new_spte) && !is_writable_pte(old_spte)) {
> +#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
> +		struct kvm_mmu_page *sp = sptep_to_sp(sptep);
> +
> +		update_dirty_quota(vcpu->kvm, (1L << SPTE_LEVEL_SHIFT(sp->role.level)));
> +#endif
>  		mark_page_dirty_in_slot(vcpu->kvm, fault->slot, fault->gfn);

Possible to call update_dirty_quota() from mark_page_dirty_in_slot() ?
Then other Architectures can be covered yet.

> +	}
>
>  	return true;
>  }
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index c15bfca3ed15..15f4f1d97ce9 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -243,6 +243,9 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  	if ((spte & PT_WRITABLE_MASK) && kvm_slot_dirty_track_enabled(slot)) {
>  		/* Enforced by kvm_mmu_hugepage_adjust. */
>  		WARN_ON(level > PG_LEVEL_4K);
> +#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
> +		update_dirty_quota(vcpu->kvm, (1L << SPTE_LEVEL_SHIFT(level)));
> +#endif
>  		mark_page_dirty_in_slot(vcpu->kvm, slot, gfn);
>  	}
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 7c25dbf32ecc..4bf98e96343d 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -358,6 +358,9 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
>
>  	if ((!is_writable_pte(old_spte) || pfn_changed) &&
>  	    is_writable_pte(new_spte)) {
> +#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
> +		update_dirty_quota(kvm, (1L << SPTE_LEVEL_SHIFT(level)));
> +#endif
>  		slot = __gfn_to_memslot(__kvm_memslots(kvm, as_id), gfn);
>  		mark_page_dirty_in_slot(kvm, slot, gfn);
>  	}
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index bcac3efcde41..da4c6342a647 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5861,6 +5861,11 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
>  		 */
>  		if (__xfer_to_guest_mode_work_pending())
>  			return 1;
> +
> +#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
> +		if (kvm_test_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu))
> +			return 1;
> +#endif
>  	}
>
>  	return 1;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7713420abab0..1733be829197 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3092,6 +3092,9 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
>
>  	guest_hv_clock->version = ++vcpu->hv_clock.version;
>
> +#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
> +	update_dirty_quota(v->kvm, PAGE_SIZE);
> +#endif
>  	mark_page_dirty_in_slot(v->kvm, gpc->memslot, gpc->gpa >> PAGE_SHIFT);
>  	read_unlock_irqrestore(&gpc->lock, flags);
>
> @@ -3566,6 +3569,9 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
>   out:
>  	user_access_end();
>   dirty:
> +#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
> +	update_dirty_quota(vcpu->kvm, PAGE_SIZE);
> +#endif
>  	mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(ghc->gpa));
>  }
>
> @@ -4815,6 +4821,9 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
>  	if (!copy_to_user_nofault(&st->preempted, &preempted, sizeof(preempted)))
>  		vcpu->arch.st.preempted = KVM_VCPU_PREEMPTED;
>
> +#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
> +	update_dirty_quota(vcpu->kvm, PAGE_SIZE);
> +#endif
>  	mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(ghc->gpa));
>  }
>
> @@ -10514,6 +10523,13 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  			r = 0;
>  			goto out;
>  		}
> +#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
> +		if (kvm_check_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu)) {
> +			vcpu->run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
> +			r = 0;
> +			goto out;
> +		}
> +#endif
>
>  		/*
>  		 * KVM_REQ_HV_STIMER has to be processed after
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 40edf4d1974c..00a3ac438539 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -435,9 +435,16 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
>
>  	read_unlock_irqrestore(&gpc1->lock, flags);
>
> +#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
> +	update_dirty_quota(v->kvm, PAGE_SIZE);
> +#endif
>  	mark_page_dirty_in_slot(v->kvm, gpc1->memslot, gpc1->gpa >> PAGE_SHIFT);
> -	if (user_len2)
> +	if (user_len2) {
> +#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
> +		update_dirty_quota(v->kvm, PAGE_SIZE);
> +#endif
>  		mark_page_dirty_in_slot(v->kvm, gpc2->memslot, gpc2->gpa >> PAGE_SHIFT);
> +	}
>  }
>
>  void kvm_xen_update_runstate(struct kvm_vcpu *v, int state)
> @@ -549,6 +556,9 @@ void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
>  	if (v->arch.xen.upcall_vector)
>  		kvm_xen_inject_vcpu_vector(v);
>
> +#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
> +	update_dirty_quota(v->kvm, PAGE_SIZE);
> +#endif
>  	mark_page_dirty_in_slot(v->kvm, gpc->memslot, gpc->gpa >> PAGE_SHIFT);
>  }
>
> --
> 2.22.3
>
