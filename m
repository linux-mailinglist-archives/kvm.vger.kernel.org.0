Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63CC8202F54
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 06:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgFVEo6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 00:44:58 -0400
Received: from mga06.intel.com ([134.134.136.31]:64218 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbgFVEo5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 00:44:57 -0400
IronPort-SDR: bF0imqC8u05mzA/rpqaI10FDYKUz/pmAcmNb1t1Ql/GV6WhY7hjZDn9VVymfjZYugo5Zo7BKGE
 Q4oNv3IQKgYA==
X-IronPort-AV: E=McAfee;i="6000,8403,9659"; a="205138185"
X-IronPort-AV: E=Sophos;i="5.75,265,1589266800"; 
   d="scan'208";a="205138185"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2020 21:44:56 -0700
IronPort-SDR: vCWH0oe+na0FV6JfIxtG9ZBwEOXyjp8DjsCP1HaZ0jw/FDlrXcDG9EBfdd5Rtb5O53B5YfoHuN
 3l4FYD6HJ/qQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,265,1589266800"; 
   d="scan'208";a="292737569"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.127])
  by orsmga002.jf.intel.com with ESMTP; 21 Jun 2020 21:44:53 -0700
Date:   Mon, 22 Jun 2020 12:44:53 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Mohammed Gamal <mgamal@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, thomas.lendacky@amd.com,
        babu.moger@amd.com
Subject: Re: [PATCH v2 01/11] KVM: x86: Add helper functions for illegal GPA
 checking and page fault injection
Message-ID: <20200622044453.6t5ssz6hwvnaujwf@yy-desk-7060>
References: <20200619153925.79106-1-mgamal@redhat.com>
 <20200619153925.79106-2-mgamal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619153925.79106-2-mgamal@redhat.com>
User-Agent: NeoMutt/20171215
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 19, 2020 at 05:39:15PM +0200, Mohammed Gamal wrote:
> This patch adds two helper functions that will be used to support virtualizing
> MAXPHYADDR in both kvm-intel.ko and kvm.ko.
> 
> kvm_fixup_and_inject_pf_error() injects a page fault for a user-specified GVA,
> while kvm_mmu_is_illegal_gpa() checks whether a GPA exceeds vCPU address limits.
> 
> Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu.h |  6 ++++++
>  arch/x86/kvm/x86.c | 21 +++++++++++++++++++++
>  arch/x86/kvm/x86.h |  1 +
>  3 files changed, 28 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 0ad06bfe2c2c..555237dfb91c 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -4,6 +4,7 @@
>  
>  #include <linux/kvm_host.h>
>  #include "kvm_cache_regs.h"
> +#include "cpuid.h"
>  
>  #define PT64_PT_BITS 9
>  #define PT64_ENT_PER_PAGE (1 << PT64_PT_BITS)
> @@ -158,6 +159,11 @@ static inline bool is_write_protection(struct kvm_vcpu *vcpu)
>  	return kvm_read_cr0_bits(vcpu, X86_CR0_WP);
>  }
>  
> +static inline bool kvm_mmu_is_illegal_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
> +{
> +        return (gpa >= BIT_ULL(cpuid_maxphyaddr(vcpu)));
> +}
> +
>  /*
>   * Check if a given access (described through the I/D, W/R and U/S bits of a
>   * page fault error code pfec) causes a permission fault with the given PTE
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 00c88c2f34e4..ac8642e890b1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10693,6 +10693,27 @@ u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(kvm_spec_ctrl_valid_bits);
>  
> +void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_code)
> +{
> +	struct x86_exception fault;
> +
> +	if (!(error_code & PFERR_PRESENT_MASK) ||
> +	    vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, error_code, &fault) != UNMAPPED_GVA) {
> +		/*
> +		 * If vcpu->arch.walk_mmu->gva_to_gpa succeeded, the page
> +		 * tables probably do not match the TLB.  Just proceed
> +		 * with the error code that the processor gave.
> +		 */
> +		fault.vector = PF_VECTOR;
> +		fault.error_code_valid = true;
> +		fault.error_code = error_code;
> +		fault.nested_page_fault = false;
> +		fault.address = gva;
> +	}
> +	vcpu->arch.walk_mmu->inject_page_fault(vcpu, &fault);

Should this "vcpu->arch.walk_mmu->inject_page_fault(vcpu, &fault)" inside the last brace?
Otherwise an uninitialized fault variable will be passed to the walk_mmu->inject_page_fault.

> +}
> +EXPORT_SYMBOL_GPL(kvm_fixup_and_inject_pf_error);
> +
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 6eb62e97e59f..239ae0f3e40b 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -272,6 +272,7 @@ int kvm_mtrr_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata);
>  bool kvm_mtrr_check_gfn_range_consistency(struct kvm_vcpu *vcpu, gfn_t gfn,
>  					  int page_num);
>  bool kvm_vector_hashing_enabled(void);
> +void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_code);
>  int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  			    int emulation_type, void *insn, int insn_len);
>  fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
> -- 
> 2.26.2
> 
