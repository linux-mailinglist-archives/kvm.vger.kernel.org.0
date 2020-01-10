Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6125B1375C8
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 19:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbgAJSFA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 13:05:00 -0500
Received: from mga11.intel.com ([192.55.52.93]:40298 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728557AbgAJSFA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 13:05:00 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jan 2020 10:04:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,417,1571727600"; 
   d="scan'208";a="231632187"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 10 Jan 2020 10:04:59 -0800
Date:   Fri, 10 Jan 2020 10:04:59 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com
Subject: Re: [RESEND PATCH v10 06/10] vmx: spp: Set up SPP paging table at
 vmentry/vmexit
Message-ID: <20200110180458.GG21485@linux.intel.com>
References: <20200102061319.10077-1-weijiang.yang@intel.com>
 <20200102061319.10077-7-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200102061319.10077-7-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 02, 2020 at 02:13:15PM +0800, Yang Weijiang wrote:
> @@ -3585,7 +3602,30 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
>  		if ((error_code & PFERR_WRITE_MASK) &&
>  		    spte_can_locklessly_be_made_writable(spte))
>  		{
> -			new_spte |= PT_WRITABLE_MASK;
> +			/*
> +			 * Record write protect fault caused by
> +			 * Sub-page Protection, let VMI decide
> +			 * the next step.
> +			 */
> +			if (spte & PT_SPP_MASK) {
> +				int len = kvm_x86_ops->get_inst_len(vcpu);

There's got to be a better way to handle SPP exits than adding a helper
to retrieve the instruction length.

> +
> +				fault_handled = true;
> +				vcpu->run->exit_reason = KVM_EXIT_SPP;
> +				vcpu->run->spp.addr = gva;
> +				vcpu->run->spp.ins_len = len;

s/ins_len/insn_len to be consistent with other KVM nomenclature.

> +				trace_kvm_spp_induced_page_fault(vcpu,
> +								 gva,
> +								 len);
> +				break;
> +			}
> +
> +			if (was_spp_armed(new_spte)) {
> +				restore_spp_bit(&new_spte);
> +				spp_protected = true;
> +			} else {
> +				new_spte |= PT_WRITABLE_MASK;
> +			}
>  
>  			/*
>  			 * Do not fix write-permission on the large spte.  Since

...

> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 24e4e1c47f42..97d862c79124 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -200,7 +200,6 @@ static const struct {
>  	[VMENTER_L1D_FLUSH_EPT_DISABLED] = {"EPT disabled", false},
>  	[VMENTER_L1D_FLUSH_NOT_REQUIRED] = {"not required", false},
>  };
> -

Spurious whitepsace.

>  #define L1D_CACHE_ORDER 4
>  static void *vmx_l1d_flush_pages;
>  
> @@ -2999,6 +2998,7 @@ void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>  	bool update_guest_cr3 = true;
>  	unsigned long guest_cr3;
>  	u64 eptp;
> +	u64 spptp;
>  
>  	guest_cr3 = cr3;
>  	if (enable_ept) {
> @@ -3027,6 +3027,12 @@ void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>  
>  	if (update_guest_cr3)
>  		vmcs_writel(GUEST_CR3, guest_cr3);
> +
> +	if (kvm->arch.spp_active && VALID_PAGE(vcpu->kvm->arch.sppt_root)) {
> +		spptp = construct_spptp(vcpu->kvm->arch.sppt_root);
> +		vmcs_write64(SPPT_POINTER, spptp);
> +		vmx_flush_tlb(vcpu, true);

Why is SPP so special that it gets to force TLB flushes?

> +	}
>  }
>  
>  int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
> @@ -5361,6 +5367,74 @@ static int handle_monitor_trap(struct kvm_vcpu *vcpu)
>  	return 1;
>  }
>  
> +int handle_spp(struct kvm_vcpu *vcpu)

Can be static.

> +{
> +	unsigned long exit_qualification;
> +	struct kvm_memory_slot *slot;
> +	gpa_t gpa;
> +	gfn_t gfn;
> +
> +	exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
> +
> +	/*
> +	 * SPP VM exit happened while executing iret from NMI,
> +	 * "blocked by NMI" bit has to be set before next VM entry.
> +	 * There are errata that may cause this bit to not be set:
> +	 * AAK134, BY25.
> +	 */
> +	if (!(to_vmx(vcpu)->idt_vectoring_info & VECTORING_INFO_VALID_MASK) &&
> +	    (exit_qualification & SPPT_INTR_INFO_UNBLOCK_NMI))
> +		vmcs_set_bits(GUEST_INTERRUPTIBILITY_INFO,
> +			      GUEST_INTR_STATE_NMI);
> +
> +	vcpu->arch.exit_qualification = exit_qualification;

	if (WARN_ON(!(exit_qualification & SPPT_INDUCED_EXIT_TYPE)))
		goto out_err;

	<handle spp exit>

	return 1;

out_err:
	vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
	vcpu->run->hw.hardware_exit_reason = EXIT_REASON_SPP;
	return 0;

> +	if (exit_qualification & SPPT_INDUCED_EXIT_TYPE) {
> +		int page_num = KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL);

The compiler is probably clever enough to make these constants, but if
this logic is a fundamental property of SPP then it should be defined as
a macro somewhere.

> +		u32 *access;
> +		gfn_t gfn_max;
> +
> +		/*
> +		 * SPPT missing
> +		 * We don't set SPP write access for the corresponding
> +		 * GPA, if we haven't setup, we need to construct
> +		 * SPP table here.
> +		 */
> +		gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
> +		gfn = gpa >> PAGE_SHIFT;

gpa_to_gfn()

> +		trace_kvm_spp_induced_exit(vcpu, gpa, exit_qualification);
> +		/*
> +		 * In level 1 of SPPT, there's no PRESENT bit, all data is
> +		 * regarded as permission vector, so need to check from
> +		 * level 2 to set up the vector if target page is protected.
> +		 */
> +		spin_lock(&vcpu->kvm->mmu_lock);
> +		gfn &= ~(page_num - 1);



> +		gfn_max = gfn + page_num - 1;

s/gfn_max/gfn_end

> +		for (; gfn <= gfn_max; gfn++) {

My preference would be to do:
		gfn_end = gfn + page_num;

		for ( ; gfn < gfn_end; gfn++)

> +			slot = gfn_to_memslot(vcpu->kvm, gfn);
> +			if (!slot)
> +				continue;
> +			access = gfn_to_subpage_wp_info(slot, gfn);
> +			if (access && *access != FULL_SPP_ACCESS)
> +				kvm_spp_setup_structure(vcpu,
> +							*access,
> +							gfn);
> +		}
> +		spin_unlock(&vcpu->kvm->mmu_lock);
> +		return 1;
> +	}
> +	/*
> +	 * SPPT Misconfig
> +	 * This is probably caused by some mis-configuration in SPPT
> +	 * entries, cannot handle it here, escalate the fault to
> +	 * emulator.
> +	 */
> +	WARN_ON(1);
> +	vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
> +	vcpu->run->hw.hardware_exit_reason = EXIT_REASON_SPP;
> +	return 0;
> +}
> +
>  static int handle_monitor(struct kvm_vcpu *vcpu)
>  {
>  	printk_once(KERN_WARNING "kvm: MONITOR instruction emulated as NOP!\n");
> @@ -5575,6 +5649,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
>  	[EXIT_REASON_INVVPID]                 = handle_vmx_instruction,
>  	[EXIT_REASON_RDRAND]                  = handle_invalid_op,
>  	[EXIT_REASON_RDSEED]                  = handle_invalid_op,
> +	[EXIT_REASON_SPP]                     = handle_spp,
>  	[EXIT_REASON_PML_FULL]		      = handle_pml_full,
>  	[EXIT_REASON_INVPCID]                 = handle_invpcid,
>  	[EXIT_REASON_VMFUNC]		      = handle_vmx_instruction,
> @@ -5807,6 +5882,9 @@ void dump_vmcs(void)
>  		pr_err("PostedIntrVec = 0x%02x\n", vmcs_read16(POSTED_INTR_NV));
>  	if ((secondary_exec_control & SECONDARY_EXEC_ENABLE_EPT))
>  		pr_err("EPT pointer = 0x%016llx\n", vmcs_read64(EPT_POINTER));
> +	if ((secondary_exec_control & SECONDARY_EXEC_ENABLE_SPP))
> +		pr_err("SPPT pointer = 0x%016llx\n", vmcs_read64(SPPT_POINTER));
> +
>  	n = vmcs_read32(CR3_TARGET_COUNT);
>  	for (i = 0; i + 1 < n; i += 4)
>  		pr_err("CR3 target%u=%016lx target%u=%016lx\n",
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fb7da000ceaf..a9d7fc21dad6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9782,6 +9782,7 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
>  	}
>  
>  	kvm_page_track_free_memslot(free, dont);
> +	kvm_spp_free_memslot(free, dont);
>  }
>  
>  int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
> @@ -10406,3 +10407,6 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_pml_full);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_pi_irte_update);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_unaccelerated_access);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_incomplete_ipi);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_spp_set_subpages);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_spp_induced_exit);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_spp_induced_page_fault);
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 09e5e8e6e6dd..c0f3162ee46a 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -244,6 +244,7 @@ struct kvm_hyperv_exit {
>  #define KVM_EXIT_IOAPIC_EOI       26
>  #define KVM_EXIT_HYPERV           27
>  #define KVM_EXIT_ARM_NISV         28
> +#define KVM_EXIT_SPP              29
>  
>  /* For KVM_EXIT_INTERNAL_ERROR */
>  /* Emulate instruction failed. */
> @@ -401,6 +402,11 @@ struct kvm_run {
>  		struct {
>  			__u8 vector;
>  		} eoi;
> +		/* KVM_EXIT_SPP */
> +		struct {
> +			__u64 addr;
> +			__u8 ins_len;
> +		} spp;
>  		/* KVM_EXIT_HYPERV */
>  		struct kvm_hyperv_exit hyperv;
>  		/* KVM_EXIT_ARM_NISV */
> -- 
> 2.17.2
> 
