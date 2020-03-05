Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F51317A910
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 16:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgCEPlb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 10:41:31 -0500
Received: from mga06.intel.com ([134.134.136.31]:41163 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbgCEPlb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 10:41:31 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 07:41:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,518,1574150400"; 
   d="scan'208";a="413555891"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 05 Mar 2020 07:41:30 -0800
Date:   Thu, 5 Mar 2020 07:41:30 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86: VMX: untangle VMXON revision_id setting
 when using eVMCS
Message-ID: <20200305154130.GB11500@linux.intel.com>
References: <20200305100123.1013667-1-vkuznets@redhat.com>
 <20200305100123.1013667-3-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305100123.1013667-3-vkuznets@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 05, 2020 at 11:01:23AM +0100, Vitaly Kuznetsov wrote:
> As stated in alloc_vmxon_regions(), VMXON region needs to be tagged with
> revision id from MSR_IA32_VMX_BASIC even in case of eVMCS. The logic to
> do so is not very straightforward: first, we set
> hdr.revision_id = KVM_EVMCS_VERSION in alloc_vmcs_cpu() just to reset it
> back to vmcs_config.revision_id in alloc_vmxon_regions(). Simplify this by
> introducing 'enum vmx_area_type' parameter to what is now known as
> alloc_vmx_area_cpu().

I'd strongly prefer to keep the alloc_vmcs_cpu() name and call the new enum
"vmcs_type".  The discrepancy could be resolved by a comment above the
VMXON_REGION usage, e.g.

		/* The VMXON region is really just a special type of VMCS. */
		vmcs = alloc_vmcs_cpu(VMXON_REGION, cpu, GFP_KERNEL);

> No functional change intended.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 31 +++++++++++++------------------
>  arch/x86/kvm/vmx/vmx.h | 12 +++++++++---
>  2 files changed, 22 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index dab19e4e5f2b..4ee19fb35cde 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2554,7 +2554,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  	return 0;
>  }
>  
> -struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags)
> +struct vmcs *alloc_vmx_area_cpu(enum vmx_area_type type, int cpu, gfp_t flags)
>  {
>  	int node = cpu_to_node(cpu);
>  	struct page *pages;
> @@ -2566,13 +2566,21 @@ struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags)
>  	vmcs = page_address(pages);
>  	memset(vmcs, 0, vmcs_config.size);
>  
> -	/* KVM supports Enlightened VMCS v1 only */
> -	if (static_branch_unlikely(&enable_evmcs))
> +	/*
> +	 * When eVMCS is enabled, vmcs->revision_id needs to be set to the
> +	 * supported eVMCS version (KVM_EVMCS_VERSION) instead of revision_id
> +	 * reported by MSR_IA32_VMX_BASIC.
> +	 *
> +	 * However, even though not explicitly documented by TLFS, VMXArea
> +	 * passed as VMXON argument should still be marked with revision_id
> +	 * reported by physical CPU.
> +	 */
> +	if (type != VMXON_REGION && static_branch_unlikely(&enable_evmcs))
>  		vmcs->hdr.revision_id = KVM_EVMCS_VERSION;
>  	else
>  		vmcs->hdr.revision_id = vmcs_config.revision_id;
>  
> -	if (shadow)
> +	if (type == SHADOW_VMCS_REGION)
>  		vmcs->hdr.shadow_vmcs = 1;
>  	return vmcs;
>  }
> @@ -2652,25 +2660,12 @@ static __init int alloc_vmxon_regions(void)
>  	for_each_possible_cpu(cpu) {
>  		struct vmcs *vmcs;
>  
> -		vmcs = alloc_vmcs_cpu(false, cpu, GFP_KERNEL);
> +		vmcs = alloc_vmx_area_cpu(VMXON_REGION, cpu, GFP_KERNEL);
>  		if (!vmcs) {
>  			free_vmxon_regions();
>  			return -ENOMEM;
>  		}
>  
> -		/*
> -		 * When eVMCS is enabled, alloc_vmcs_cpu() sets
> -		 * vmcs->revision_id to KVM_EVMCS_VERSION instead of
> -		 * revision_id reported by MSR_IA32_VMX_BASIC.
> -		 *
> -		 * However, even though not explicitly documented by
> -		 * TLFS, VMXArea passed as VMXON argument should
> -		 * still be marked with revision_id reported by
> -		 * physical CPU.
> -		 */
> -		if (static_branch_unlikely(&enable_evmcs))
> -			vmcs->hdr.revision_id = vmcs_config.revision_id;
> -
>  		per_cpu(vmxarea, cpu) = vmcs;
>  	}
>  	return 0;
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index e64da06c7009..7bdac5a50432 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -489,7 +489,13 @@ static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
>  	return &(to_vmx(vcpu)->pi_desc);
>  }
>  
> -struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags);
> +enum vmx_area_type {
> +	VMXON_REGION,
> +	VMCS_REGION,
> +	SHADOW_VMCS_REGION,
> +};
> +
> +struct vmcs *alloc_vmx_area_cpu(enum vmx_area_type type, int cpu, gfp_t flags);
>  void free_vmcs(struct vmcs *vmcs);
>  int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);
>  void free_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);
> @@ -498,8 +504,8 @@ void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs);
>  
>  static inline struct vmcs *alloc_vmcs(bool shadow)
>  {
> -	return alloc_vmcs_cpu(shadow, raw_smp_processor_id(),
> -			      GFP_KERNEL_ACCOUNT);
> +	return alloc_vmx_area_cpu(shadow ? SHADOW_VMCS_REGION : VMCS_REGION,
> +				  raw_smp_processor_id(), GFP_KERNEL_ACCOUNT);
>  }
>  
>  u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa);
> -- 
> 2.24.1
> 
