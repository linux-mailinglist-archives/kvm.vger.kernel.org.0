Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E87CB17AF67
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 21:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgCEUKC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 15:10:02 -0500
Received: from mga18.intel.com ([134.134.136.126]:58402 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726007AbgCEUKC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 15:10:02 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 12:10:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,519,1574150400"; 
   d="scan'208";a="287766600"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Mar 2020 12:10:00 -0800
Date:   Thu, 5 Mar 2020 12:10:00 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] KVM: VMX: untangle VMXON revision_id setting when
 using eVMCS
Message-ID: <20200305201000.GQ11500@linux.intel.com>
References: <20200305183725.28872-1-vkuznets@redhat.com>
 <20200305183725.28872-3-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305183725.28872-3-vkuznets@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 05, 2020 at 07:37:25PM +0100, Vitaly Kuznetsov wrote:
> As stated in alloc_vmxon_regions(), VMXON region needs to be tagged with
> revision id from MSR_IA32_VMX_BASIC even in case of eVMCS. The logic to
> do so is not very straightforward: first, we set
> hdr.revision_id = KVM_EVMCS_VERSION in alloc_vmcs_cpu() just to reset it
> back to vmcs_config.revision_id in alloc_vmxon_regions(). Simplify this by
> introducing 'enum vmcs_type' parameter to alloc_vmcs_cpu().
> 
> No functional change intended.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---

...

> +	 * However, even though not explicitly documented by TLFS, VMXArea
> +	 * passed as VMXON argument should still be marked with revision_id
> +	 * reported by physical CPU.

LOL, nice.


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

> -struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags);
> +enum vmcs_type {
> +	VMXON_REGION,
> +	VMCS_REGION,
> +	SHADOW_VMCS_REGION,
> +};
> +
> +struct vmcs *alloc_vmcs_cpu(enum vmcs_type type, int cpu, gfp_t flags);
>  void free_vmcs(struct vmcs *vmcs);
>  int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);
>  void free_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);
> @@ -498,8 +504,8 @@ void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs);
>  
>  static inline struct vmcs *alloc_vmcs(bool shadow)

I think it'd be cleaner overall to take "enum vmcs_type" in alloc_vmcs().
Then the ternary operator goes away and the callers (all two of 'em) are
self-documenting.  E.g.

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 79c7764c77b1..2c8a0a1386b1 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4566,7 +4566,7 @@ static struct vmcs *alloc_shadow_vmcs(struct kvm_vcpu *vcpu)
        WARN_ON(loaded_vmcs == &vmx->vmcs01 && loaded_vmcs->shadow_vmcs);

        if (!loaded_vmcs->shadow_vmcs) {
-               loaded_vmcs->shadow_vmcs = alloc_vmcs(true);
+               loaded_vmcs->shadow_vmcs = alloc_vmcs(SHADOW_VMCS_REGION);
                if (loaded_vmcs->shadow_vmcs)
                        vmcs_clear(loaded_vmcs->shadow_vmcs);
        }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5bdf6919de83..4634f6d7d55a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2605,7 +2605,7 @@ void free_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)

 int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
 {
-       loaded_vmcs->vmcs = alloc_vmcs(false);
+       loaded_vmcs->vmcs = alloc_vmcs(VMCS_REGION);
        if (!loaded_vmcs->vmcs)
                return -ENOMEM;

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 4c327030bb9c..a5eb92638ac2 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -502,10 +502,10 @@ void free_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);
 void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs);
 void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs);

-static inline struct vmcs *alloc_vmcs(bool shadow)
+static inline struct vmcs *alloc_vmcs(enum vmcs_type type)
 {
-       return alloc_vmcs_cpu(shadow ? SHADOW_VMCS_REGION : VMCS_REGION,
-                             raw_smp_processor_id(), GFP_KERNEL_ACCOUNT);
+       return alloc_vmcs_cpu(type, raw_smp_processor_id(),
+                             GFP_KERNEL_ACCOUNT);
 }

 u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa);



>  {
> -	return alloc_vmcs_cpu(shadow, raw_smp_processor_id(),
> -			      GFP_KERNEL_ACCOUNT);
> +	return alloc_vmcs_cpu(shadow ? SHADOW_VMCS_REGION : VMCS_REGION,
> +			      raw_smp_processor_id(), GFP_KERNEL_ACCOUNT);
>  }
>  
>  u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa);
> -- 
> 2.24.1
> 
