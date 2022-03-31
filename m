Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDA244ED25E
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 06:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbiCaESy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 00:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbiCaES2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 00:18:28 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B279A185958;
        Wed, 30 Mar 2022 21:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648699505; x=1680235505;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FkLKjF9yc6i0+3dBxoVynuN9myC6clq7eWtCrJIDA2k=;
  b=YT4XyPCJwdrhWmfoETTC8pisSpDehLNBkiaDu0KWgMNRPvWenCCck20O
   LuC53Fb9eDFOU3/X8YoF+8FjIH6ffNGtA4LPKOXhzpK+rHBmqf/s85mUl
   0t7E6T8jr8QecgchALSLb3oQdXSmB6Q41Mlt3aBzAEI5GIfrjNyzF6CL/
   K1RGafI5eMAWYxAjfdxtsPRfjQDVjdhCs7/7UUAW78iWB8WdZy1Qrro1v
   A06XWUMtkCG1hemZW/IfM3Pd9T4DpNUTaD7/4bD52y0HARXpkZf+PWaQG
   3bbj3IpdBf+k4OtmLaJeYygDkxDUqa44Wxd/q4zYU9npY6eF1f7EHUka5
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="320406326"
X-IronPort-AV: E=Sophos;i="5.90,224,1643702400"; 
   d="scan'208";a="320406326"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2022 20:31:14 -0700
X-IronPort-AV: E=Sophos;i="5.90,224,1643702400"; 
   d="scan'208";a="650114022"
Received: from dhathawa-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.53.226])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2022 20:31:12 -0700
Message-ID: <36aac3cb7c7447db6454ee396e25eea3bad378e6.camel@intel.com>
Subject: Re: [RFC PATCH v5 008/104] KVM: TDX: Add a function to initialize
 TDX module
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Thu, 31 Mar 2022 16:31:10 +1300
In-Reply-To: <b92217283fa96b85e9a683ca3fcf1b368cf8d1c4.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
         <b92217283fa96b85e9a683ca3fcf1b368cf8d1c4.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-03-04 at 11:48 -0800, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Memory used for TDX is encrypted with an encryption key.  An encryption key
> is assigned to guest TD, and TDX memory is encrypted.  VMM calculates Trust
> Domain Memory Range (TDMR), a range of memory pages that can hold TDX
> memory encrypted with an encryption key.  VMM allocates memory regions for
> Physical Address Metadata Table (PAMT) which the TDX module uses to track
> page states. Used for TDX memory, assigned to which guest TD, etc.  VMM
> gives PAMT regions to the TDX module and initializes it which is also
> encrypted.

Not sure why above are related to this patch.  Perhaps you can just say TDX
module is detected and initialized on demand via tdx_detect() and tdx_init().

> 
> TDX requires more initialization steps in addition to VMX.  As a
> preparation step, check if the CPU feature is available and enable VMX
> because the TDX module API requires VMX to be enabled to be functional.

Those are not reflected in this patch either.

> The next step is basic platform initialization.  Check if TDX module API is
> available, call system-wide initialization API (TDH.SYS.INIT), and call LP
> initialization API (TDH.SYS.LP.INIT).  Lastly, get system-wide
> parameters (TDH.SYS.INFO), allocate PAMT for TDX module to track page
> states (TDH.SYS.CONFIG), configure encryption key (TDH.SYS.KEY.CONFIG), and
> initialize PAMT (TDH.SYS.TDMR.INIT).

Again, not sure why those are related.

> 
> A TDX host patch series implements those details and it provides APIs,
> seamrr_enabled() to check if CPU feature is available, init_tdx() to
> initialize the TDX module, tdx_get_tdsysinfo() to get TDX system
> parameters.

init_tdx() -> tdx_init().

"A TDX host patch series" should not be in the formal commit message, I suppose.

> 
> Add a wrapper function to initialize the TDX module and get system-wide
> parameters via those APIs.  Because TDX requires VMX enabled, It will be
> called on-demand when the first guest TD is created via x86 KVM init_vm
> callback.

Why not just merge this patch with the change where you implement the init_vm
callback?  Then you can just declare this patch as "detect and initialize TDX
module when first VM is created", or something like that..

> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/vmx/tdx.c | 89 ++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/tdx.h |  4 ++
>  2 files changed, 93 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 8ed3ec342e28..8adc87ad1807 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -13,9 +13,98 @@
>  static bool __read_mostly enable_tdx = true;
>  module_param_named(tdx, enable_tdx, bool, 0644);
>  
> +#define TDX_MAX_NR_CPUID_CONFIGS					\
> +	((sizeof(struct tdsysinfo_struct) -				\
> +		offsetof(struct tdsysinfo_struct, cpuid_configs))	\
> +		/ sizeof(struct tdx_cpuid_config))
> +
> +struct tdx_capabilities {
> +	u8 tdcs_nr_pages;
> +	u8 tdvpx_nr_pages;
> +
> +	u64 attrs_fixed0;
> +	u64 attrs_fixed1;
> +	u64 xfam_fixed0;
> +	u64 xfam_fixed1;
> +
> +	u32 nr_cpuid_configs;
> +	struct tdx_cpuid_config cpuid_configs[TDX_MAX_NR_CPUID_CONFIGS];
> +};
> +
> +/* Capabilities of KVM + the TDX module. */
> +struct tdx_capabilities tdx_caps;
> +
>  static u64 hkid_mask __ro_after_init;
>  static u8 hkid_start_pos __ro_after_init;

The two seems are not used in this patch.

Please make sure each patch can compile w/o warning.

>  
> +static int __tdx_module_setup(void)
> +{
> +	const struct tdsysinfo_struct *tdsysinfo;
> +	int ret = 0;
> +
> +	BUILD_BUG_ON(sizeof(*tdsysinfo) != 1024);
> +	BUILD_BUG_ON(TDX_MAX_NR_CPUID_CONFIGS != 37);
> +
> +	ret = tdx_detect();
> +	if (ret) {
> +		pr_info("Failed to detect TDX module.\n");
> +		return ret;
> +	}
> +
> +	ret = tdx_init();
> +	if (ret) {
> +		pr_info("Failed to initialize TDX module.\n");
> +		return ret;
> +	}
> +
> +	tdsysinfo = tdx_get_sysinfo();
> +	if (tdx_caps.nr_cpuid_configs > TDX_MAX_NR_CPUID_CONFIGS)
> +		return -EIO;
> +
> +	tdx_caps = (struct tdx_capabilities) {
> +		.tdcs_nr_pages = tdsysinfo->tdcs_base_size / PAGE_SIZE,
> +		/*
> +		 * TDVPS = TDVPR(4K page) + TDVPX(multiple 4K pages).
> +		 * -1 for TDVPR.
> +		 */
> +		.tdvpx_nr_pages = tdsysinfo->tdvps_base_size / PAGE_SIZE - 1,
> +		.attrs_fixed0 = tdsysinfo->attributes_fixed0,
> +		.attrs_fixed1 = tdsysinfo->attributes_fixed1,
> +		.xfam_fixed0 =	tdsysinfo->xfam_fixed0,
> +		.xfam_fixed1 = tdsysinfo->xfam_fixed1,
> +		.nr_cpuid_configs = tdsysinfo->num_cpuid_config,
> +	};
> +	if (!memcpy(tdx_caps.cpuid_configs, tdsysinfo->cpuid_configs,
> +			tdsysinfo->num_cpuid_config *
> +			sizeof(struct tdx_cpuid_config)))
> +		return -EIO;
> +
> +	return 0;
> +}
> +
> +int tdx_module_setup(void)
> +{
> +	static DEFINE_MUTEX(tdx_init_lock);
> +	static bool __read_mostly tdx_module_initialized;
> +	int ret = 0;
> +
> +	mutex_lock(&tdx_init_lock);

It took me a while to figure out why this mutex is needed.  Please see my above
suggestion to merge this patch to the change that implements init_vm() callback.

> +
> +	if (!tdx_module_initialized) {
> +		if (enable_tdx) {
> +			ret = __tdx_module_setup();

I think you can move tdx_detect() and tdx_init() out of your mutex.  They are
internally protected by mutex.

> +			if (ret)
> +				enable_tdx = false;
> +			else
> +				tdx_module_initialized = true;
> +		} else
> +			ret = -EOPNOTSUPP;
> +	}
> +
> +	mutex_unlock(&tdx_init_lock);
> +	return ret;
> +}
> +
>  static int __init __tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
>  {
>  	u32 max_pa;
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index daf6bfc6502a..d448e019602c 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -3,6 +3,8 @@
>  #define __KVM_X86_TDX_H
>  
>  #ifdef CONFIG_INTEL_TDX_HOST
> +int tdx_module_setup(void);
> +
>  struct kvm_tdx {
>  	struct kvm kvm;
>  };
> @@ -35,6 +37,8 @@ static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu)
>  	return container_of(vcpu, struct vcpu_tdx, vcpu);
>  }
>  #else
> +static inline int tdx_module_setup(void) { return -ENODEV; };
> +
>  struct kvm_tdx;
>  struct vcpu_tdx;
>  

