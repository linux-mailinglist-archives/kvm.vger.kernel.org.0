Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4F98138C9C
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 09:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728778AbgAMIGc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 03:06:32 -0500
Received: from mga17.intel.com ([192.55.52.151]:63779 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728682AbgAMIGc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 03:06:32 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jan 2020 00:06:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,428,1571727600"; 
   d="scan'208";a="224905087"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by orsmga006.jf.intel.com with ESMTP; 13 Jan 2020 00:06:29 -0800
Date:   Mon, 13 Jan 2020 16:10:50 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com,
        alazar@bitdefender.com, edwin.zhai@intel.com
Subject: Re: [RESEND PATCH v10 06/10] vmx: spp: Set up SPP paging table at
 vmentry/vmexit
Message-ID: <20200113081050.GF12253@local-michael-cet-test.sh.intel.com>
References: <20200102061319.10077-1-weijiang.yang@intel.com>
 <20200102061319.10077-7-weijiang.yang@intel.com>
 <20200110180458.GG21485@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110180458.GG21485@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 10, 2020 at 10:04:59AM -0800, Sean Christopherson wrote:
> On Thu, Jan 02, 2020 at 02:13:15PM +0800, Yang Weijiang wrote:
> > @@ -3585,7 +3602,30 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
> >  		if ((error_code & PFERR_WRITE_MASK) &&
> >  		    spte_can_locklessly_be_made_writable(spte))
> >  		{
> > -			new_spte |= PT_WRITABLE_MASK;
> > +			/*
> > +			 * Record write protect fault caused by
> > +			 * Sub-page Protection, let VMI decide
> > +			 * the next step.
> > +			 */
> > +			if (spte & PT_SPP_MASK) {
> > +				int len = kvm_x86_ops->get_inst_len(vcpu);
> 
> There's got to be a better way to handle SPP exits than adding a helper
> to retrieve the instruction length.
>
The fault instruction was skipped by kvm_skip_emulated_instruction()
before, but Paolo suggested leave the re-do or skip option to user-space
to make it flexible for write protection or write tracking, so return
length to user-space.

> > +
> > +				fault_handled = true;
> > +				vcpu->run->exit_reason = KVM_EXIT_SPP;
> > +				vcpu->run->spp.addr = gva;
> > +				vcpu->run->spp.ins_len = len;
> 
> s/ins_len/insn_len to be consistent with other KVM nomenclature.
> 
OK.

> > +				trace_kvm_spp_induced_page_fault(vcpu,
> > +								 gva,
> > +								 len);
> > +				break;
> > +			}
> > +
> > +			if (was_spp_armed(new_spte)) {
> > +				restore_spp_bit(&new_spte);
> > +				spp_protected = true;
> > +			} else {
> > +				new_spte |= PT_WRITABLE_MASK;
> > +			}
> >  
> >  			/*
> >  			 * Do not fix write-permission on the large spte.  Since
> 
> ...
> 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 24e4e1c47f42..97d862c79124 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -200,7 +200,6 @@ static const struct {
> >  	[VMENTER_L1D_FLUSH_EPT_DISABLED] = {"EPT disabled", false},
> >  	[VMENTER_L1D_FLUSH_NOT_REQUIRED] = {"not required", false},
> >  };
> > -
> 
> Spurious whitepsace.
>
OK.

> >  #define L1D_CACHE_ORDER 4
> >  static void *vmx_l1d_flush_pages;
> >  
> > @@ -2999,6 +2998,7 @@ void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> >  	bool update_guest_cr3 = true;
> >  	unsigned long guest_cr3;
> >  	u64 eptp;
> > +	u64 spptp;
> >  
> >  	guest_cr3 = cr3;
> >  	if (enable_ept) {
> > @@ -3027,6 +3027,12 @@ void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> >  
> >  	if (update_guest_cr3)
> >  		vmcs_writel(GUEST_CR3, guest_cr3);
> > +
> > +	if (kvm->arch.spp_active && VALID_PAGE(vcpu->kvm->arch.sppt_root)) {
> > +		spptp = construct_spptp(vcpu->kvm->arch.sppt_root);
> > +		vmcs_write64(SPPT_POINTER, spptp);
> > +		vmx_flush_tlb(vcpu, true);
> 
> Why is SPP so special that it gets to force TLB flushes?
I double checked the code, there's a call to vmx_flush_tlb() in
mmu_load(), so it's unnecessary here, thank you!

> > +	}
> >  }
> >  
> >  int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
> > @@ -5361,6 +5367,74 @@ static int handle_monitor_trap(struct kvm_vcpu *vcpu)
> >  	return 1;
> >  }
> >  
> > +int handle_spp(struct kvm_vcpu *vcpu)
> 
> Can be static.
>
Thanks!

> > +{
> > +	unsigned long exit_qualification;
> > +	struct kvm_memory_slot *slot;
> > +	gpa_t gpa;
> > +	gfn_t gfn;
> > +
> > +	exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
> > +
> > +	/*
> > +	 * SPP VM exit happened while executing iret from NMI,
> > +	 * "blocked by NMI" bit has to be set before next VM entry.
> > +	 * There are errata that may cause this bit to not be set:
> > +	 * AAK134, BY25.
> > +	 */
> > +	if (!(to_vmx(vcpu)->idt_vectoring_info & VECTORING_INFO_VALID_MASK) &&
> > +	    (exit_qualification & SPPT_INTR_INFO_UNBLOCK_NMI))
> > +		vmcs_set_bits(GUEST_INTERRUPTIBILITY_INFO,
> > +			      GUEST_INTR_STATE_NMI);
> > +
> > +	vcpu->arch.exit_qualification = exit_qualification;
> 
> 	if (WARN_ON(!(exit_qualification & SPPT_INDUCED_EXIT_TYPE)))
> 		goto out_err;
> 
> 	<handle spp exit>
> 
> 	return 1;
> 
> out_err:
> 	vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
> 	vcpu->run->hw.hardware_exit_reason = EXIT_REASON_SPP;
> 	return 0;
>
Sure, will change it.

> > +	if (exit_qualification & SPPT_INDUCED_EXIT_TYPE) {
> > +		int page_num = KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL);
> 
> The compiler is probably clever enough to make these constants, but if
> this logic is a fundamental property of SPP then it should be defined as
> a macro somewhere.
>
OK, will change it.

> > +		u32 *access;
> > +		gfn_t gfn_max;
> > +
> > +		/*
> > +		 * SPPT missing
> > +		 * We don't set SPP write access for the corresponding
> > +		 * GPA, if we haven't setup, we need to construct
> > +		 * SPP table here.
> > +		 */
> > +		gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
> > +		gfn = gpa >> PAGE_SHIFT;
> 
> gpa_to_gfn()
>
OK.

> > +		trace_kvm_spp_induced_exit(vcpu, gpa, exit_qualification);
> > +		/*
> > +		 * In level 1 of SPPT, there's no PRESENT bit, all data is
> > +		 * regarded as permission vector, so need to check from
> > +		 * level 2 to set up the vector if target page is protected.
> > +		 */
> > +		spin_lock(&vcpu->kvm->mmu_lock);
> > +		gfn &= ~(page_num - 1);
> 
> 
> 
> > +		gfn_max = gfn + page_num - 1;
> 
> s/gfn_max/gfn_end
OK.

> 
> > +		for (; gfn <= gfn_max; gfn++) {
> 
> My preference would be to do:
> 		gfn_end = gfn + page_num;
> 
> 		for ( ; gfn < gfn_end; gfn++)
>
Thank you!
> > +			slot = gfn_to_memslot(vcpu->kvm, gfn);

