Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75BD12951EA
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 19:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438461AbgJUR7j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 13:59:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:36564 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391484AbgJUR7i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 13:59:38 -0400
IronPort-SDR: b1kNW4n2MmYoogQ58rPm4cbDLJie/PkwMu2TqFNWa3ymyo9U7aREKHLaJgqwiFw89460TmXuyt
 VFefypTe1dHg==
X-IronPort-AV: E=McAfee;i="6000,8403,9780"; a="185078294"
X-IronPort-AV: E=Sophos;i="5.77,401,1596524400"; 
   d="scan'208";a="185078294"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 10:59:38 -0700
IronPort-SDR: M1X2/Q4NORS2/pe6ohTAXWSUEUhr2K+e/HgqGAqcQXdnjUJNX5bdfYZuzXbCmsmgm8AcPypDgl
 DgnnallRxBVg==
X-IronPort-AV: E=Sophos;i="5.77,401,1596524400"; 
   d="scan'208";a="359587284"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 10:59:37 -0700
Date:   Wed, 21 Oct 2020 10:59:36 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 10/10] KVM: VMX: Track PGD instead of EPTP for
 paravirt Hyper-V TLB flush
Message-ID: <20201021175935.GE14155@linux.intel.com>
References: <20201020215613.8972-1-sean.j.christopherson@intel.com>
 <20201020215613.8972-11-sean.j.christopherson@intel.com>
 <87imb34p9b.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87imb34p9b.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 21, 2020 at 04:39:28PM +0200, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index e0fea09a6e42..89019e6476b3 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -478,18 +478,13 @@ static int kvm_fill_hv_flush_list_func(struct hv_guest_mapping_flush_list *flush
> >  			range->pages);
> >  }
> >  
> > -static inline int hv_remote_flush_eptp(u64 eptp, struct kvm_tlb_range *range)
> > +static inline int hv_remote_flush_pgd(u64 pgd, struct kvm_tlb_range *range)
> >  {
> > -	/*
> > -	 * FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE hypercall needs address
> > -	 * of the base of EPT PML4 table, strip off EPT configuration
> > -	 * information.
> > -	 */
> >  	if (range)
> > -		return hyperv_flush_guest_mapping_range(eptp & PAGE_MASK,
> > +		return hyperv_flush_guest_mapping_range(pgd,
> >  				kvm_fill_hv_flush_list_func, (void *)range);
> >  	else
> > -		return hyperv_flush_guest_mapping(eptp & PAGE_MASK);
> > +		return hyperv_flush_guest_mapping(pgd);
> >  }
> 
> (I'm probably missing something, please bear with me -- this is the last
> patch of the series after all :-) but PGD which comes from
> kvm_mmu_load_pgd() has PCID bits encoded and you're dropping
> '&PAGE_MASK' here ...

...

> > @@ -564,17 +559,17 @@ static int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
> >  
> >  #endif /* IS_ENABLED(CONFIG_HYPERV) */
> >  
> > -static void hv_load_mmu_eptp(struct kvm_vcpu *vcpu, u64 eptp)
> > +static void hv_load_mmu_pgd(struct kvm_vcpu *vcpu, u64 pgd)
> >  {
> >  #if IS_ENABLED(CONFIG_HYPERV)
> >  	struct kvm_vmx *kvm_vmx = to_kvm_vmx(vcpu->kvm);
> >  
> >  	if (kvm_x86_ops.tlb_remote_flush == hv_remote_flush_tlb) {
> > -		spin_lock(&kvm_vmx->ept_pointer_lock);
> > -		to_vmx(vcpu)->ept_pointer = eptp;
> > -		if (eptp != kvm_vmx->hv_tlb_eptp)
> > -			kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
> > -		spin_unlock(&kvm_vmx->ept_pointer_lock);
> > +		spin_lock(&kvm_vmx->hv_tlb_pgd_lock);
> > +		to_vmx(vcpu)->hv_tlb_pgd = pgd;
> > +		if (pgd != kvm_vmx->hv_tlb_pgd)
> > +			kvm_vmx->hv_tlb_pgd = INVALID_PAGE;
> > +		spin_unlock(&kvm_vmx->hv_tlb_pgd_lock);
> >  	}
> >  #endif
> >  }
> > @@ -3059,7 +3054,7 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd,
> >  		eptp = construct_eptp(vcpu, pgd, pgd_level);
> >  		vmcs_write64(EPT_POINTER, eptp);
> >  
> > -		hv_load_mmu_eptp(vcpu, eptp);
> > +		hv_load_mmu_pgd(vcpu, pgd);
> 
> ... and not adding it here. (construct_eptp() seems to drop PCID bits
> but add its own stuff). Is this on purpose?

No, I completely forgot KVM crams the PCID bits into pgd.  I'll think I'll add
a patch to rework .load_mmu_pgd() to move the PCID bits to a separate param,
and change construct_eptp() to do WARN_ON_ONCE(pgd & ~PAGE_MASK).

Actually, I think it makes more sense to have VMX and SVM, grab the PCID via
kvm_get_active_pcid(vcpu) when necessary.  For EPTP, getting the PCID bits may
unnecessarily read CR3 from the VMCS.

Ugh, which brings up another issue.  I'm pretty sure the "vmcs01.GUEST_CR3 is
already up-to-date" is dead code:

		if (!enable_unrestricted_guest && !is_paging(vcpu))
			guest_cr3 = to_kvm_vmx(kvm)->ept_identity_map_addr;
		else if (test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
			guest_cr3 = vcpu->arch.cr3;
		else /* vmcs01.GUEST_CR3 is already up-to-date. */
			update_guest_cr3 = false;
		vmx_ept_load_pdptrs(vcpu);

The sole caller of .load_mmu_pgd() always invokes kvm_get_active_pcid(), which
in turn always does kvm_read_cr3(), i.e. CR3 will always be available.

So yeah, I think moving kvm_get_active_pcid() in VMX/SVM is the right approach.
I'll rename "pgd" to "root_hpa" and "pgd_level" to "root_level" so that we
don't end up with inconsistencies, e.g. where pgd may or may not contain PCID
bits.

Nice catch!
