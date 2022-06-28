Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D054B55D96B
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243821AbiF1Dxh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 23:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236892AbiF1Dxg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 23:53:36 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051E127B02;
        Mon, 27 Jun 2022 20:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656388415; x=1687924415;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=erYTiBffzoQJGOZdjIsl/+DskBeAVIhiFBi030yW1nE=;
  b=hBiL4tSi3NKqn/5JAE9AMd6D4oNlYqAyjseOk+5aS5KkwGbF14Oc+VyB
   YHXrq0MsmrXznjd9KyBnAb298WLu+zOnLA9XIsYFBbRKmMOtrijKJ4w0z
   ABo2F3qCGJWSMfWR4UihHpyZ79eEr98ZbCZ3hHpvaIKXd0Su+9up/bFF+
   doCOto1JGdBTJGap73vykCWtW6Wd1O8QPLCqEEeh74VQv7MvvCoWFghX8
   F9HHbXI/TnyUMKCktH2Fy+fVm+pCAiil7fhb/h3+CX3OeAucAtwBlM1Xw
   10JX74NZf7Ezsu1ZVu4HxuiVfPurh+xLnxhf2iPPi/BKjb9a0f4UR6oiU
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="280385810"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="280385810"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 20:53:34 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="564925348"
Received: from eachuh-x1-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.72.164])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 20:53:33 -0700
Message-ID: <46acf87f3980a6f709e191cfc10ff4be78e23553.camel@intel.com>
Subject: Re: [PATCH v7 008/102] KVM: x86: Refactor KVM VMX module init/exit
 functions
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>
Date:   Tue, 28 Jun 2022 15:53:31 +1200
In-Reply-To: <b8761fc945630d6f264ff22a388d286394a2904f.1656366338.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <b8761fc945630d6f264ff22a388d286394a2904f.1656366338.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>=20
> Currently, KVM VMX module initialization/exit functions are a single
> function each.  Refactor KVM VMX module initialization functions into KVM
> common part and VMX part so that TDX specific part can be added cleanly.
> Opportunistically refactor module exit function as well.
>=20
> The current module initialization flow is, 1.) calculate the sizes of VMX
> kvm structure and VMX vcpu structure, 2.) hyper-v specific initialization
> 3.) report those sizes to the KVM common layer and KVM common
> initialization, and 4.) VMX specific system-wide initialization.
>=20
> Refactor the KVM VMX module initialization function into functions with a
> wrapper function to separate VMX logic in vmx.c from a file, main.c, comm=
on
> among VMX and TDX.  We have a wrapper function, "vt_init() {vmx kvm/vcpu
> size calculation; hv_vp_assist_page_init(); kvm_init(); vmx_init(); }" in
> main.c, and hv_vp_assist_page_init() and vmx_init() in vmx.c.
> hv_vp_assist_page_init() initializes hyper-v specific assist pages,
> kvm_init() does system-wide initialization of the KVM common layer, and
> vmx_init() does system-wide VMX initialization.
>=20
> The KVM architecture common layer allocates struct kvm with reported size
> for architecture-specific code.  The KVM VMX module defines its structure
> as struct vmx_kvm { struct kvm; VMX specific members;} and uses it as
> struct vmx kvm.  Similar for vcpu structure. TDX KVM patches will define
> TDX specific kvm and vcpu structures, add tdx_pre_kvm_init() to report th=
e
> sizes of them to the KVM common layer.
>=20
> The current module exit function is also a single function, a combination
> of VMX specific logic and common KVM logic.  Refactor it into VMX specifi=
c
> logic and KVM common logic.  This is just refactoring to keep the VMX
> specific logic in vmx.c from main.c.

This patch, coupled with the patch:

	KVM: VMX: Move out vmx_x86_ops to 'main.c' to wrap VMX and TDX

Basically provides an infrastructure to support both VMX and TDX.  Why we c=
annot
merge them into one patch?  What's the benefit of splitting them?

At least, why the two patches cannot be put together closely?

>=20
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/vmx/main.c    |  38 +++++++++++++
>  arch/x86/kvm/vmx/vmx.c     | 106 ++++++++++++++++++-------------------
>  arch/x86/kvm/vmx/x86_ops.h |   6 +++
>  3 files changed, 95 insertions(+), 55 deletions(-)
>=20
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index fabf5f22c94f..371dad728166 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -169,3 +169,41 @@ struct kvm_x86_init_ops vt_init_ops __initdata =3D {
>  	.runtime_ops =3D &vt_x86_ops,
>  	.pmu_ops =3D &intel_pmu_ops,
>  };
> +
> +static int __init vt_init(void)
> +{
> +	unsigned int vcpu_size, vcpu_align;
> +	int r;
> +
> +	vt_x86_ops.vm_size =3D sizeof(struct kvm_vmx);
> +	vcpu_size =3D sizeof(struct vcpu_vmx);
> +	vcpu_align =3D __alignof__(struct vcpu_vmx);
> +
> +	hv_vp_assist_page_init();
> +	vmx_init_early();
> +
> +	r =3D kvm_init(&vt_init_ops, vcpu_size, vcpu_align, THIS_MODULE);
> +	if (r)
> +		goto err_vmx_post_exit;
> +
> +	r =3D vmx_init();
> +	if (r)
> +		goto err_kvm_exit;
> +
> +	return 0;
> +
> +err_kvm_exit:
> +	kvm_exit();
> +err_vmx_post_exit:
> +	hv_vp_assist_page_exit();
> +	return r;
> +}
> +module_init(vt_init);
> +
> +static void vt_exit(void)
> +{
> +	vmx_exit();
> +	kvm_exit();
> +	hv_vp_assist_page_exit();
> +}
> +module_exit(vt_exit);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 286947c00638..b30d73d28e75 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8181,15 +8181,45 @@ static void vmx_cleanup_l1d_flush(void)
>  	l1tf_vmx_mitigation =3D VMENTER_L1D_FLUSH_AUTO;
>  }
> =20
> -static void vmx_exit(void)
> +void __init hv_vp_assist_page_init(void)
>  {
> -#ifdef CONFIG_KEXEC_CORE
> -	RCU_INIT_POINTER(crash_vmclear_loaded_vmcss, NULL);
> -	synchronize_rcu();
> -#endif
> +#if IS_ENABLED(CONFIG_HYPERV)
> +	/*
> +	 * Enlightened VMCS usage should be recommended and the host needs
> +	 * to support eVMCS v1 or above. We can also disable eVMCS support
> +	 * with module parameter.
> +	 */
> +	if (enlightened_vmcs &&
> +	    ms_hyperv.hints & HV_X64_ENLIGHTENED_VMCS_RECOMMENDED &&
> +	    (ms_hyperv.nested_features & HV_X64_ENLIGHTENED_VMCS_VERSION) >=3D
> +	    KVM_EVMCS_VERSION) {
> +		int cpu;
> +
> +		/* Check that we have assist pages on all online CPUs */
> +		for_each_online_cpu(cpu) {
> +			if (!hv_get_vp_assist_page(cpu)) {
> +				enlightened_vmcs =3D false;
> +				break;
> +			}
> +		}
> =20
> -	kvm_exit();
> +		if (enlightened_vmcs) {
> +			pr_info("KVM: vmx: using Hyper-V Enlightened VMCS\n");
> +			static_branch_enable(&enable_evmcs);
> +		}
> +
> +		if (ms_hyperv.nested_features & HV_X64_NESTED_DIRECT_FLUSH)
> +			vt_x86_ops.enable_direct_tlbflush
> +				=3D hv_enable_direct_tlbflush;
> =20
> +	} else {
> +		enlightened_vmcs =3D false;
> +	}
> +#endif
> +}
> +
> +void hv_vp_assist_page_exit(void)
> +{
>  #if IS_ENABLED(CONFIG_HYPERV)
>  	if (static_branch_unlikely(&enable_evmcs)) {
>  		int cpu;
> @@ -8213,14 +8243,10 @@ static void vmx_exit(void)
>  		static_branch_disable(&enable_evmcs);
>  	}
>  #endif
> -	vmx_cleanup_l1d_flush();
> -
> -	allow_smaller_maxphyaddr =3D false;
>  }
> -module_exit(vmx_exit);
> =20
>  /* initialize before kvm_init() so that hardware_enable/disable() can wo=
rk. */
> -static void __init vmx_init_early(void)
> +void __init vmx_init_early(void)
>  {
>  	int cpu;
> =20
> @@ -8228,49 +8254,10 @@ static void __init vmx_init_early(void)
>  		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
>  }
> =20
> -static int __init vmx_init(void)
> +int __init vmx_init(void)
>  {
>  	int r, cpu;
> =20
> -#if IS_ENABLED(CONFIG_HYPERV)
> -	/*
> -	 * Enlightened VMCS usage should be recommended and the host needs
> -	 * to support eVMCS v1 or above. We can also disable eVMCS support
> -	 * with module parameter.
> -	 */
> -	if (enlightened_vmcs &&
> -	    ms_hyperv.hints & HV_X64_ENLIGHTENED_VMCS_RECOMMENDED &&
> -	    (ms_hyperv.nested_features & HV_X64_ENLIGHTENED_VMCS_VERSION) >=3D
> -	    KVM_EVMCS_VERSION) {
> -
> -		/* Check that we have assist pages on all online CPUs */
> -		for_each_online_cpu(cpu) {
> -			if (!hv_get_vp_assist_page(cpu)) {
> -				enlightened_vmcs =3D false;
> -				break;
> -			}
> -		}
> -
> -		if (enlightened_vmcs) {
> -			pr_info("KVM: vmx: using Hyper-V Enlightened VMCS\n");
> -			static_branch_enable(&enable_evmcs);
> -		}
> -
> -		if (ms_hyperv.nested_features & HV_X64_NESTED_DIRECT_FLUSH)
> -			vt_x86_ops.enable_direct_tlbflush
> -				=3D hv_enable_direct_tlbflush;
> -
> -	} else {
> -		enlightened_vmcs =3D false;
> -	}
> -#endif
> -
> -	vmx_init_early();
> -	r =3D kvm_init(&vt_init_ops, sizeof(struct vcpu_vmx),
> -		__alignof__(struct vcpu_vmx), THIS_MODULE);
> -	if (r)
> -		return r;
> -
>  	/*
>  	 * Must be called after kvm_init() so enable_ept is properly set
>  	 * up. Hand the parameter mitigation value in which was stored in
> @@ -8279,10 +8266,8 @@ static int __init vmx_init(void)
>  	 * mitigation mode.
>  	 */
>  	r =3D vmx_setup_l1d_flush(vmentry_l1d_flush_param);
> -	if (r) {
> -		vmx_exit();
> +	if (r)
>  		return r;
> -	}
> =20
>  	for_each_possible_cpu(cpu)
>  		pi_init_cpu(cpu);
> @@ -8303,4 +8288,15 @@ static int __init vmx_init(void)
> =20
>  	return 0;
>  }
> -module_init(vmx_init);
> +
> +void vmx_exit(void)
> +{
> +#ifdef CONFIG_KEXEC_CORE
> +	RCU_INIT_POINTER(crash_vmclear_loaded_vmcss, NULL);
> +	synchronize_rcu();
> +#endif
> +
> +	vmx_cleanup_l1d_flush();
> +
> +	allow_smaller_maxphyaddr =3D false;
> +}
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 0a5967a91e26..2abead2f60f7 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -8,6 +8,12 @@
> =20
>  #include "x86.h"
> =20
> +void __init hv_vp_assist_page_init(void);
> +void hv_vp_assist_page_exit(void);
> +void __init vmx_init_early(void);
> +int __init vmx_init(void);
> +void vmx_exit(void);
> +
>  __init int vmx_cpu_has_kvm_support(void);
>  __init int vmx_disabled_by_bios(void);
>  __init int vmx_hardware_setup(void);

