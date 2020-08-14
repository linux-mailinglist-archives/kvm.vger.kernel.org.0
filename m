Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1518F2442C6
	for <lists+kvm@lfdr.de>; Fri, 14 Aug 2020 03:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgHNBkQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 21:40:16 -0400
Received: from mga03.intel.com ([134.134.136.65]:15604 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbgHNBkP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Aug 2020 21:40:15 -0400
IronPort-SDR: sw0LBl4GtSKKiuNby4RfQAjj3KETIgFTrOxaZdumOCQDlYOVJoeyn0JhWr8lu96NCMneLsGupm
 D5vhZaqmFkHQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9712"; a="154309079"
X-IronPort-AV: E=Sophos;i="5.76,310,1592895600"; 
   d="scan'208";a="154309079"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2020 18:40:15 -0700
IronPort-SDR: nn2/a2uT0dfmJs5glicqz7PZfMhJpugjrmgjWvIyz7YuOXGxPzQe/4+tNLDXxM2PX95RhtOOBc
 WiIigei2EWPA==
X-IronPort-AV: E=Sophos;i="5.76,310,1592895600"; 
   d="scan'208";a="470421279"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2020 18:40:15 -0700
Date:   Thu, 13 Aug 2020 18:40:14 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>, Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] KVM: x86: move kvm_vcpu_gfn_to_memslot() out of
 try_async_pf()
Message-ID: <20200814014014.GA4845@linux.intel.com>
References: <20200807141232.402895-1-vkuznets@redhat.com>
 <20200807141232.402895-2-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200807141232.402895-2-vkuznets@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 07, 2020 at 04:12:30PM +0200, Vitaly Kuznetsov wrote:
> No functional change intended. Slot flags will need to be analyzed
> prior to try_async_pf() when KVM_MEM_PCI_HOLE is implemented.

Why?  Wouldn't it be just as easy, and arguably more appropriate, to add
KVM_PFN_ERR_PCI_HOLE and update handle_abornmal_pfn() accordinaly?

> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c         | 14 ++++++++------
>  arch/x86/kvm/mmu/paging_tmpl.h |  7 +++++--
>  2 files changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 862bf418214e..fef6956393f7 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4042,11 +4042,10 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  				  kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch);
>  }
>  
> -static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
> -			 gpa_t cr2_or_gpa, kvm_pfn_t *pfn, bool write,
> -			 bool *writable)
> +static bool try_async_pf(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
> +			 bool prefault, gfn_t gfn, gpa_t cr2_or_gpa,
> +			 kvm_pfn_t *pfn, bool write, bool *writable)
>  {
> -	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
>  	bool async;
>  
>  	/* Don't expose private memslots to L2. */
> @@ -4082,7 +4081,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>  	bool exec = error_code & PFERR_FETCH_MASK;
>  	bool lpage_disallowed = exec && is_nx_huge_page_enabled();
>  	bool map_writable;
> -
> +	struct kvm_memory_slot *slot;
>  	gfn_t gfn = gpa >> PAGE_SHIFT;
>  	unsigned long mmu_seq;
>  	kvm_pfn_t pfn;
> @@ -4104,7 +4103,10 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>  	mmu_seq = vcpu->kvm->mmu_notifier_seq;
>  	smp_rmb();
>  
> -	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, write, &map_writable))
> +	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
> +
> +	if (try_async_pf(vcpu, slot, prefault, gfn, gpa, &pfn, write,
> +			 &map_writable))
>  		return RET_PF_RETRY;
>  
>  	if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, pfn, ACC_ALL, &r))
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 0172a949f6a7..5c6a895f67c3 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -779,6 +779,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
>  	int write_fault = error_code & PFERR_WRITE_MASK;
>  	int user_fault = error_code & PFERR_USER_MASK;
>  	struct guest_walker walker;
> +	struct kvm_memory_slot *slot;
>  	int r;
>  	kvm_pfn_t pfn;
>  	unsigned long mmu_seq;
> @@ -833,8 +834,10 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
>  	mmu_seq = vcpu->kvm->mmu_notifier_seq;
>  	smp_rmb();
>  
> -	if (try_async_pf(vcpu, prefault, walker.gfn, addr, &pfn, write_fault,
> -			 &map_writable))
> +	slot = kvm_vcpu_gfn_to_memslot(vcpu, walker.gfn);
> +
> +	if (try_async_pf(vcpu, slot, prefault, walker.gfn, addr, &pfn,
> +			 write_fault, &map_writable))
>  		return RET_PF_RETRY;
>  
>  	if (handle_abnormal_pfn(vcpu, addr, walker.gfn, pfn, walker.pte_access, &r))
> -- 
> 2.25.4
> 
