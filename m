Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6785F21DFBA
	for <lists+kvm@lfdr.de>; Mon, 13 Jul 2020 20:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgGMScN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 14:32:13 -0400
Received: from mga17.intel.com ([192.55.52.151]:15460 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726309AbgGMScN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jul 2020 14:32:13 -0400
IronPort-SDR: cr1n0HXsnbqysqJb0XcUWxyBrBUFV43u7kvSSRzYLUopiFCL+7drxLC248htVtngFsVexTbtLq
 7lo8iZCIRpuQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="128797910"
X-IronPort-AV: E=Sophos;i="5.75,348,1589266800"; 
   d="scan'208";a="128797910"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 11:32:11 -0700
IronPort-SDR: nNv4yQsTG13946sD97JRYB07qgxtK8h1U4auW/5RyV5GY9aoabgXZt3qDRQErpnLzKQiUa6Ir7
 brnnQAypE2gQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,348,1589266800"; 
   d="scan'208";a="459392333"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga005.jf.intel.com with ESMTP; 13 Jul 2020 11:32:11 -0700
Date:   Mon, 13 Jul 2020 11:32:11 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Mohammed Gamal <mgamal@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Subject: Re: [PATCH v3 7/9] KVM: VMX: Add guest physical address check in EPT
 violation and misconfig
Message-ID: <20200713183211.GD29725@linux.intel.com>
References: <20200710154811.418214-1-mgamal@redhat.com>
 <20200710154811.418214-8-mgamal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710154811.418214-8-mgamal@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 10, 2020 at 05:48:09PM +0200, Mohammed Gamal wrote:
> Check guest physical address against it's maximum physical memory. If
> the guest's physical address exceeds the maximum (i.e. has reserved bits
> set), inject a guest page fault with PFERR_RSVD_MASK set.
> 
> This has to be done both in the EPT violation and page fault paths, as
> there are complications in both cases with respect to the computation
> of the correct error code.
> 
> For EPT violations, unfortunately the only possibility is to emulate,
> because the access type in the exit qualification might refer to an
> access to a paging structure, rather than to the access performed by
> the program.
> 
> Trapping page faults instead is needed in order to correct the error code,
> but the access type can be obtained from the original error code and
> passed to gva_to_gpa.  The corrections required in the error code are
> subtle. For example, imagine that a PTE for a supervisor page has a reserved
> bit set.  On a supervisor-mode access, the EPT violation path would trigger.
> However, on a user-mode access, the processor will not notice the reserved
> bit and not include PFERR_RSVD_MASK in the error code.
> 
> Co-developed-by: Mohammed Gamal <mgamal@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 24 +++++++++++++++++++++---
>  arch/x86/kvm/vmx/vmx.h |  3 ++-
>  2 files changed, 23 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 770b090969fb..de3f436b2d32 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4790,9 +4790,15 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>  
>  	if (is_page_fault(intr_info)) {
>  		cr2 = vmx_get_exit_qual(vcpu);
> -		/* EPT won't cause page fault directly */
> -		WARN_ON_ONCE(!vcpu->arch.apf.host_apf_flags && enable_ept);
> -		return kvm_handle_page_fault(vcpu, error_code, cr2, NULL, 0);
> +		if (enable_ept && !vcpu->arch.apf.host_apf_flags) {
> +			/*
> +			 * EPT will cause page fault only if we need to
> +			 * detect illegal GPAs.
> +			 */

It'd be nice to retain a WARN_ON_ONCE() here, e.g.

			WARN_ON_ONCE(!vmx_need_pf_intercept(vcpu));

This WARN has fired for me when I've botched the nested VM-Exit routing,
debugging a spurious L2 #PF without would be less than fun.

> +			kvm_fixup_and_inject_pf_error(vcpu, cr2, error_code);
> +			return 1;
> +		} else
> +			return kvm_handle_page_fault(vcpu, error_code, cr2, NULL, 0);
>  	}
>  
>  	ex_no = intr_info & INTR_INFO_VECTOR_MASK;
> @@ -5308,6 +5314,18 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
>  	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
>  
>  	vcpu->arch.exit_qualification = exit_qualification;
> +
> +	/*
> +	 * Check that the GPA doesn't exceed physical memory limits, as that is
> +	 * a guest page fault.  We have to emulate the instruction here, because
> +	 * if the illegal address is that of a paging structure, then
> +	 * EPT_VIOLATION_ACC_WRITE bit is set.  Alternatively, if supported we
> +	 * would also use advanced VM-exit information for EPT violations to
> +	 * reconstruct the page fault error code.
> +	 */
> +	if (unlikely(kvm_mmu_is_illegal_gpa(vcpu, gpa)))
> +		return kvm_emulate_instruction(vcpu, 0);
> +
>  	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
>  }
>  
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index b0e5e210f1c1..0d06951e607c 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -11,6 +11,7 @@
>  #include "kvm_cache_regs.h"
>  #include "ops.h"
>  #include "vmcs.h"
> +#include "cpuid.h"
>  
>  extern const u32 vmx_msr_index[];
>  
> @@ -552,7 +553,7 @@ static inline bool vmx_has_waitpkg(struct vcpu_vmx *vmx)
>  
>  static inline bool vmx_need_pf_intercept(struct kvm_vcpu *vcpu)
>  {
> -	return !enable_ept;
> +	return !enable_ept || cpuid_maxphyaddr(vcpu) < boot_cpu_data.x86_phys_bits;
>  }
>  
>  void dump_vmcs(void);
> -- 
> 2.26.2
> 
