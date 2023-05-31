Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60C9571736C
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 03:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbjEaB5h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 21:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbjEaB5f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 21:57:35 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F032911C;
        Tue, 30 May 2023 18:57:33 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-4f3af42459bso859245e87.0;
        Tue, 30 May 2023 18:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685498252; x=1688090252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mNk9epbfw2E0bCWUiRhLRgjA8mzougkQVZm8zfp2x7g=;
        b=DLt93/YcckCwnwHCdRvhmYTXuZMLmvp3Lp1yanpi8s/Ttps2yMBvraKGJ5riwlgTN9
         HzbsPDW86mb8FRVot4NEDBfd2/xLX/KrhoQwxLZsXmaLGM/uM+cWDcIgZn1uqIaledLH
         Mgkp9eW2Tb3MYj4toaJgs6CA/aO4IEbQEok950DpSp6fCd6D6LCK3Est7jhx2pNbVnTL
         yqSzazQtnD/T8ii3Q+E3FkqJ/Hfs42hXYHKWUrgbHx+AzdEvhaflOW4kwAlml31TG5Pi
         5J8ul8omtVgnXcxUdiAd0e3zJKo0srehMz7ROyLn82nBunOp1nu2HVGap2KqZx8wUNmx
         Wh/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685498252; x=1688090252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mNk9epbfw2E0bCWUiRhLRgjA8mzougkQVZm8zfp2x7g=;
        b=fRCNhrkPX1IvrdjS906AP9yYT+qRAcyqQD3w4wvzExZuWHOxJoyFG+2MUpWZ6Z0D6N
         UBI4+M7etazYTT8woPc9N4tJZqPYWx6RBv6KAD6VdsuAQq8iUS3Jmxfroh2cP4mLUArB
         sKe4HDdLWB6xIGz/T8kDPRWo2kDsdaOtUlM8Ws/b1dhsUMV/zyNFe87486dhTG9knwLT
         rsqsCXiJGmewj1MKZ6Eliayay7XBFL+YcGnkNC3TABwXKtO+20x0R+dGNL2NDsNT353Z
         gstYOPO4v2D3+HcPO/T6CcHnJkim9wSvi3QwdaGxUc8050s9WrVYK8ogrLsq+nMzZ14p
         h4lA==
X-Gm-Message-State: AC+VfDz5M00WL/A5UT9CJ5ow4skZHbcBTcNQFzRT2E9xEKmnia72q7dA
        NqeqI+G0pUxFEKqRGp5InrA=
X-Google-Smtp-Source: ACHHUZ5m+OZVSwkqcc+5m/LL1yN3luOc9Sp/KVEEpST+opo9OJPrVjy8yJQK7NRKy0DBwZNWMTH0Nw==
X-Received: by 2002:ac2:4187:0:b0:4ef:ed0f:c604 with SMTP id z7-20020ac24187000000b004efed0fc604mr331382lfh.2.1685498251858;
        Tue, 30 May 2023 18:57:31 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id w9-20020a05651204c900b004eefdd8b37fsm512446lfq.194.2023.05.30.18.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 18:57:31 -0700 (PDT)
Date:   Wed, 31 May 2023 09:57:18 +0800
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>, chen.bo@intel.com
Subject: Re: [PATCH v14 003/113] KVM: x86/vmx: Refactor KVM VMX module
 init/exit functions
Message-ID: <20230531093950.00007e7d.zhi.wang.linux@gmail.com>
In-Reply-To: <4ef61085333e97e0ae48c3d7603042b9801e3608.1685333727.git.isaku.yamahata@intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
 <4ef61085333e97e0ae48c3d7603042b9801e3608.1685333727.git.isaku.yamahata@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 28 May 2023 21:18:45 -0700
isaku.yamahata@intel.com wrote:

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
>  arch/x86/kvm/vmx/main.c    | 50 +++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/vmx.c     | 54 +++++---------------------------------
>  arch/x86/kvm/vmx/x86_ops.h | 13 ++++++++-
>  3 files changed, 68 insertions(+), 49 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index a59559ff140e..791ee271393d 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -165,3 +165,53 @@ struct kvm_x86_init_ops vt_init_ops __initdata = {
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
> +	vcpu_size = sizeof(struct vcpu_vmx);
> +	vcpu_align = __alignof__(struct vcpu_vmx);
> +	r = kvm_init(vcpu_size, vcpu_align, THIS_MODULE);
> +	if (r)
> +		goto err_kvm_init;
> +
> +	return 0;
> +
---------------------------------
> +err_kvm_init:
> +	vmx_exit();
> +err_vmx_init:
> +	kvm_x86_vendor_exit();
> +	return r;
> +}
> +module_init(vt_init);
> +
----------------------------------
> +static void vt_exit(void)
> +{
> +	kvm_exit();
> +	kvm_x86_vendor_exit();
> +	vmx_exit();
----------------------------------

It seems the exiting sequences above are a little bit different with
each other (PS: It is not a prob introduced in this patch):

vmx_exit()
kvm_x86_vendor_exit()
....

and

...
kvm_x86_vnedor_exit()
vmx_exit()

I was wondering which one should be correct. Literally, the exiting
sequence would be in reversing order of the initialization sequence.

> +}
> +module_exit(vt_exit);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index ed7bf8fc55a8..9e4def64495b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -554,7 +554,7 @@ static int hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> -static __init void hv_init_evmcs(void)
> +__init void hv_init_evmcs(void)
>  {
>  	int cpu;
>  
> @@ -590,7 +590,7 @@ static __init void hv_init_evmcs(void)
>  	}
>  }
>  
> -static void hv_reset_evmcs(void)
> +void hv_reset_evmcs(void)
>  {
>  	struct hv_vp_assist_page *vp_ap;
>  
> @@ -614,10 +614,6 @@ static void hv_reset_evmcs(void)
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
> @@ -2715,7 +2711,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
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
> @@ -8448,21 +8422,5 @@ static int __init vmx_init(void)
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

