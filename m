Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39B2770D12A
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 04:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbjEWCYF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 22:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjEWCYD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 22:24:03 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57F1CA;
        Mon, 22 May 2023 19:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684808641; x=1716344641;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VtoVt99kVwI5w/Wx4fG+hHvFzF1Q/pSRnjgaGb5NgZw=;
  b=CeLT5oDIJ/O85mm4rQgjBsA8SbyHU9wI1TGr7Qr3FOX0GqlsSgruBREv
   ZV1PuVn1QbCympCeOW6/yTnfh3mdFTBgDVSBPVTIwr5ubSykmSIN08OhR
   Lo2sEVAcs2cImfPpKeQgeAHzySlSd2Vbf5Xoa5S7JVn+BC2V+6JRddJF0
   VuI+FNiUmNLF0m8Teil8lbLlEUJrnmx3GN1DUw6ctFloQ7lpVX6AIz+pX
   q2zglTILXqYUL2eWKeYX2ZHy7hBeilsMX+8OsVvESpZs6BevkwtLZsZE8
   d4+5AFg1pWqufRrbPwlTDVRL5vFsttu23sKbQXNu/9gUjdHNgFgco2q+K
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="439457670"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="439457670"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 19:24:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="848080658"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="848080658"
Received: from qianwen-mobl1.ccr.corp.intel.com (HELO [10.238.5.200]) ([10.238.5.200])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 19:23:58 -0700
Message-ID: <676b2b3e-b836-4b55-9772-eb6c6db82542@intel.com>
Date:   Tue, 23 May 2023 10:23:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v13 002/113] KVM: x86/vmx: Refactor KVM VMX module
 init/exit functions
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <e4d32af22f0a540c62fffaa17fe478a723e109ea.1678643052.git.isaku.yamahata@intel.com>
Content-Language: en-US
From:   "Wen, Qian" <qian.wen@intel.com>
In-Reply-To: <e4d32af22f0a540c62fffaa17fe478a723e109ea.1678643052.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/13/2023 1:55 AM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Currently, KVM VMX module initialization/exit functions are a single
> function each.  Refactor KVM VMX module initialization functions into KVM
> common part and VMX part so that TDX specific part can be added cleanly.
> Opportunistically refactor module exit function as well.
> 
> The current module initialization flow is,
> 0.) Check if VMX is supported,
> 1.) hyper-v specific initialization,
> 2.) system-wide x86 specific and vendor specific initialization,
> 3.) Final VMX specific system-wide initialization,
> 4.) calculate the sizes of VMX kvm structure and VMX vcpu structure,
> 5.) report those sizes to the KVM common layer and KVM common
>     initialization
> 
> Refactor the KVM VMX module initialization function into functions with a
> wrapper function to separate VMX logic in vmx.c from a file, main.c, common
> among VMX and TDX.  Introduce a wrapper function for vmx_init().
> 
> The KVM architecture common layer allocates struct kvm with reported size
> for architecture-specific code.  The KVM VMX module defines its structure
> as struct vmx_kvm { struct kvm; VMX specific members;} and uses it as
> struct vmx kvm.  Similar for vcpu structure. TDX KVM patches will define
> TDX specific kvm and vcpu structures.
> 
> The current module exit function is also a single function, a combination
> of VMX specific logic and common KVM logic.  Refactor it into VMX specific
> logic and KVM common logic.  This is just refactoring to keep the VMX
> specific logic in vmx.c from main.c.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/vmx/main.c    | 51 +++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/vmx.c     | 54 +++++---------------------------------
>  arch/x86/kvm/vmx/x86_ops.h | 13 ++++++++-
>  3 files changed, 69 insertions(+), 49 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index a59559ff140e..3f49e8e38b6b 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -165,3 +165,54 @@ struct kvm_x86_init_ops vt_init_ops __initdata = {
>  	.runtime_ops = &vt_x86_ops,
>  	.pmu_ops = &intel_pmu_ops,
>  };
> +
> +static int __init vt_init(void)
> +{
> +	unsigned int vcpu_size, vcpu_align;
> +	int r;
> +
> +	if (!kvm_is_vmx_supported())
> +		return -EOPNOTSUPP;
> +
> +	/*
> +	 * Note, hv_init_evmcs() touches only VMX knobs, i.e. there's nothing
> +	 * to unwind if a later step fails.
> +	 */
> +	hv_init_evmcs();
> +
> +	r = kvm_x86_vendor_init(&vt_init_ops);
> +	if (r)
> +		return r;
> +
> +	r = vmx_init();
> +	if (r)
> +		goto err_vmx_init;
> +
> +	/*
> +	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
> +	 * exposed to userspace!
> +	 */
> +	vt_x86_ops.vm_size = sizeof(struct kvm_vmx);

nit: why initialize vm_size again? I noticed that it has already been assigned a value when create vt_x86_ops.

+struct kvm_x86_ops vt_x86_ops __initdata = {
...
+	.vm_size = sizeof(struct kvm_vmx),
+	.vm_init = vmx_vm_init,


> +	vcpu_size = sizeof(struct vcpu_vmx);
> +	vcpu_align = __alignof__(struct vcpu_vmx);
> +	r = kvm_init(vcpu_size, vcpu_align, THIS_MODULE);
> +	if (r)
> +		goto err_kvm_init;
> +
> +	return 0;
> +
> +err_kvm_init:
> +	vmx_exit();
> +err_vmx_init:
> +	kvm_x86_vendor_exit();
> +	return r;
> +}
> +module_init(vt_init);
> +
> +static void vt_exit(void)
> +{
> +	kvm_exit();
> +	kvm_x86_vendor_exit();
> +	vmx_exit();
> +}
> +module_exit(vt_exit);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 47a9a647ae3a..3bbd07412f00 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -553,7 +553,7 @@ static int hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> -static __init void hv_init_evmcs(void)
> +__init void hv_init_evmcs(void)
>  {
>  	int cpu;
>  
> @@ -589,7 +589,7 @@ static __init void hv_init_evmcs(void)
>  	}
>  }
>  
> -static void hv_reset_evmcs(void)
> +void hv_reset_evmcs(void)
>  {
>  	struct hv_vp_assist_page *vp_ap;
>  
> @@ -613,10 +613,6 @@ static void hv_reset_evmcs(void)
>  	vp_ap->current_nested_vmcs = 0;
>  	vp_ap->enlighten_vmentry = 0;
>  }
> -
> -#else /* IS_ENABLED(CONFIG_HYPERV) */
> -static void hv_init_evmcs(void) {}
> -static void hv_reset_evmcs(void) {}
>  #endif /* IS_ENABLED(CONFIG_HYPERV) */
>  
>  /*
> @@ -2741,7 +2737,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  	return 0;
>  }
>  
> -static bool kvm_is_vmx_supported(void)
> +bool kvm_is_vmx_supported(void)
>  {
>  	int cpu = raw_smp_processor_id();
>  
> @@ -8381,7 +8377,7 @@ static void vmx_cleanup_l1d_flush(void)
>  	l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_AUTO;
>  }
>  
> -static void __vmx_exit(void)
> +void vmx_exit(void)
>  {
>  	allow_smaller_maxphyaddr = false;
>  
> @@ -8392,32 +8388,10 @@ static void __vmx_exit(void)
>  	vmx_cleanup_l1d_flush();
>  }
>  
> -static void vmx_exit(void)
> -{
> -	kvm_exit();
> -	kvm_x86_vendor_exit();
> -
> -	__vmx_exit();
> -}
> -module_exit(vmx_exit);
> -
> -static int __init vmx_init(void)
> +int __init vmx_init(void)
>  {
>  	int r, cpu;
>  
> -	if (!kvm_is_vmx_supported())
> -		return -EOPNOTSUPP;
> -
> -	/*
> -	 * Note, hv_init_evmcs() touches only VMX knobs, i.e. there's nothing
> -	 * to unwind if a later step fails.
> -	 */
> -	hv_init_evmcs();
> -
> -	r = kvm_x86_vendor_init(&vt_init_ops);
> -	if (r)
> -		return r;
> -
>  	/*
>  	 * Must be called after common x86 init so enable_ept is properly set
>  	 * up. Hand the parameter mitigation value in which was stored in
> @@ -8427,7 +8401,7 @@ static int __init vmx_init(void)
>  	 */
>  	r = vmx_setup_l1d_flush(vmentry_l1d_flush_param);
>  	if (r)
> -		goto err_l1d_flush;
> +		return r;
>  
>  	vmx_setup_fb_clear_ctrl();
>  
> @@ -8451,21 +8425,5 @@ static int __init vmx_init(void)
>  	if (!enable_ept)
>  		allow_smaller_maxphyaddr = true;
>  
> -	/*
> -	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
> -	 * exposed to userspace!
> -	 */
> -	r = kvm_init(sizeof(struct vcpu_vmx), __alignof__(struct vcpu_vmx),
> -		     THIS_MODULE);
> -	if (r)
> -		goto err_kvm_init;
> -
>  	return 0;
> -
> -err_kvm_init:
> -	__vmx_exit();
> -err_l1d_flush:
> -	kvm_x86_vendor_exit();
> -	return r;
>  }
> -module_init(vmx_init);
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index e9ec4d259ff5..051b5c4b5c2f 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -8,11 +8,22 @@
>  
>  #include "x86.h"
>  
> -__init int vmx_hardware_setup(void);
> +#if IS_ENABLED(CONFIG_HYPERV)
> +__init void hv_init_evmcs(void);
> +void hv_reset_evmcs(void);
> +#else /* IS_ENABLED(CONFIG_HYPERV) */
> +static inline void hv_init_evmcs(void) {}
> +static inline void hv_reset_evmcs(void) {}
> +#endif /* IS_ENABLED(CONFIG_HYPERV) */
> +
> +bool kvm_is_vmx_supported(void);
> +int __init vmx_init(void);
> +void vmx_exit(void);
>  
>  extern struct kvm_x86_ops vt_x86_ops __initdata;
>  extern struct kvm_x86_init_ops vt_init_ops __initdata;
>  
> +__init int vmx_hardware_setup(void);
>  void vmx_hardware_unsetup(void);
>  int vmx_check_processor_compat(void);
>  int vmx_hardware_enable(void);
