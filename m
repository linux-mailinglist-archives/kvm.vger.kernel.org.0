Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99CA234C28
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 22:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgGaUZE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 16:25:04 -0400
Received: from mga18.intel.com ([134.134.136.126]:29686 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726588AbgGaUZE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 16:25:04 -0400
IronPort-SDR: lRHE3f0Saxdk8DcZbVBa/xFPUJBHcnCDV/Af238BgZyG/H7XkR087cTMRBSa4kamCANBOhh+ux
 PjnwHCKvUKdw==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="139420048"
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="139420048"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 13:25:03 -0700
IronPort-SDR: eSVROF7/ITfPz9P1nRaVavTL4fDgNT3xlIAn2YSMXXCpxJ1553tW67eqvBhZXGzZYhLuD9hRiz
 lZSktHOdYwPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="323345291"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga002.fm.intel.com with ESMTP; 31 Jul 2020 13:25:02 -0700
Date:   Fri, 31 Jul 2020 13:25:02 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     eric van tassell <Eric.VanTassell@amd.com>
Cc:     kvm@vger.kernel.org, bp@alien8.de, hpa@zytor.com, mingo@redhat.com,
        jmattson@google.com, joro@8bytes.org, pbonzini@redhat.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org, evantass@amd.com
Subject: Re: [Patch 2/4] KVM:SVM: Introduce set_spte_notify support
Message-ID: <20200731202502.GG31451@linux.intel.com>
References: <20200724235448.106142-1-Eric.VanTassell@amd.com>
 <20200724235448.106142-3-Eric.VanTassell@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724235448.106142-3-Eric.VanTassell@amd.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 24, 2020 at 06:54:46PM -0500, eric van tassell wrote:
> Improve SEV guest startup time from O(n) to a constant by deferring
> guest page pinning until the pages are used to satisfy nested page faults.
> 
> Implement the code to do the pinning (sev_get_page) and the notifier
> sev_set_spte_notify().
> 
> Track the pinned pages with xarray so they can be released during guest
> termination.

I like that SEV is trying to be a better citizen, but this is trading one
hack for another.

  - KVM goes through a lot of effort to ensure page faults don't need to
    allocate memory, and this throws all that effort out the window.

  - Tracking all gfns in a separate database (from the MMU) is wasteful.

  - Having to wait to free pinned memory until the VM is destroyed is less
    than ideal.

More thoughts in the next patch.

> Signed-off-by: eric van tassell <Eric.VanTassell@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 71 ++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c |  2 ++
>  arch/x86/kvm/svm/svm.h |  3 ++
>  3 files changed, 76 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index f7f1f4ecf08e..040ae4aa7c5a 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -184,6 +184,8 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	sev->asid = asid;
>  	INIT_LIST_HEAD(&sev->regions_list);
>  
> +	xa_init(&sev->pages_xarray);
> +
>  	return 0;
>  
>  e_free:
> @@ -415,6 +417,42 @@ static unsigned long get_num_contig_pages(unsigned long idx,
>  	return pages;
>  }
>  
> +static int sev_get_page(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct xarray *xa = &sev->pages_xarray;
> +	struct page *page = pfn_to_page(pfn);
> +	int ret;
> +
> +	/* store page at index = gfn */
> +	ret = xa_insert(xa, gfn, page, GFP_ATOMIC);
> +	if (ret == -EBUSY) {
> +		/*
> +		 * If xa_insert returned -EBUSY, the  gfn was already associated
> +		 * with a struct page *.
> +		 */
> +		struct page *cur_page;
> +
> +		cur_page = xa_load(xa, gfn);
> +		/* If cur_page == page, no change is needed, so return 0 */
> +		if (cur_page == page)
> +			return 0;
> +
> +		/* Release the page that was stored at index = gfn */
> +		put_page(cur_page);
> +
> +		/* Return result of attempting to store page at index = gfn */
> +		ret = xa_err(xa_store(xa, gfn, page, GFP_ATOMIC));
> +	}
> +
> +	if (ret)
> +		return ret;
> +
> +	get_page(page);
> +
> +	return 0;
> +}
> +
>  static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
>  	unsigned long vaddr, vaddr_end, next_vaddr, npages, pages, size, i;
> @@ -1085,6 +1123,8 @@ void sev_vm_destroy(struct kvm *kvm)
>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>  	struct list_head *head = &sev->regions_list;
>  	struct list_head *pos, *q;
> +	XA_STATE(xas, &sev->pages_xarray, 0);
> +	struct page *xa_page;
>  
>  	if (!sev_guest(kvm))
>  		return;
> @@ -1109,6 +1149,12 @@ void sev_vm_destroy(struct kvm *kvm)
>  		}
>  	}
>  
> +	/* Release each pinned page that SEV tracked in sev->pages_xarray. */
> +	xas_for_each(&xas, xa_page, ULONG_MAX) {
> +		put_page(xa_page);
> +	}
> +	xa_destroy(&sev->pages_xarray);
> +
>  	mutex_unlock(&kvm->lock);
>  
>  	sev_unbind_asid(kvm, sev->handle);
> @@ -1193,3 +1239,28 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
>  	svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
>  	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
>  }
> +
> +int sev_set_spte_notify(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn,
> +			int level, bool mmio, u64 *spte)
> +{
> +	int rc;
> +
> +	if (!sev_guest(vcpu->kvm))
> +		return 0;
> +
> +	/* MMIO page contains the unencrypted data, no need to lock this page */
> +	if (mmio)

Rather than make this a generic set_spte() notify hook, I think it makes
more sense to specifying have it be a "pin_spte" style hook.  That way the
caller can skip mmio PFNs as well as flows that can't possibly be relevant
to SEV, e.g. the sync_page() flow.

> +		return 0;
> +
> +	rc = sev_get_page(vcpu->kvm, gfn, pfn);
> +	if (rc)
> +		return rc;
> +
> +	/*
> +	 * Flush any cached lines of the page being added since "ownership" of
> +	 * it will be transferred from the host to an encrypted guest.
> +	 */
> +	clflush_cache_range(__va(pfn << PAGE_SHIFT), page_level_size(level));
> +
> +	return 0;
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 535ad311ad02..9b304c761a99 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4130,6 +4130,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
>  
>  	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
> +
> +	.set_spte_notify = sev_set_spte_notify,
>  };
>  
>  static struct kvm_x86_init_ops svm_init_ops __initdata = {
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 121b198b51e9..8a5c01516c89 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -65,6 +65,7 @@ struct kvm_sev_info {
>  	int fd;			/* SEV device fd */
>  	unsigned long pages_locked; /* Number of pages locked */
>  	struct list_head regions_list;  /* List of registered regions */
> +	struct xarray pages_xarray; /* List of PFN locked */
>  };
>  
>  struct kvm_svm {
> @@ -488,5 +489,7 @@ int svm_unregister_enc_region(struct kvm *kvm,
>  void pre_sev_run(struct vcpu_svm *svm, int cpu);
>  int __init sev_hardware_setup(void);
>  void sev_hardware_teardown(void);
> +int sev_set_spte_notify(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn,
> +			int level, bool mmio, u64 *spte);
>  
>  #endif
> -- 
> 2.17.1
> 
