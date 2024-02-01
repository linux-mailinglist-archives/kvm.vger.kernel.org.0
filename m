Return-Path: <kvm+bounces-7663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FC428450BA
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 06:32:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4652128BE3E
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 05:32:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1C5E3CF4E;
	Thu,  1 Feb 2024 05:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aHhSqsFj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077883C48D;
	Thu,  1 Feb 2024 05:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706765548; cv=none; b=hcs1lhr/RIucd1vyJz9zfdilgYJ3SDmWPVt0uAL5Z5j55IZL7wj6SKJO4LMhXi1D05M4oM3voUgEVhBTiNqxNiSeAyW6P1h+n/qLEVODW8kzS/AfYkrKvGUVsH4BdP/n7FBwP7kUuYR73eBmjv4LmuR03n4322/jjNBrKR0eKuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706765548; c=relaxed/simple;
	bh=Fa5/UvlMsHAjzZZribGcNm9FV3I5qa09T2F62x3/RdI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ewd6mRTaRWp7W7PYUKcbnSrQuIL/axk14E4cDrWE/z1cqjYmQodxpFnCbsO6//AJNfIXyN9ZUo6AeI7bHVhLG4KIGn9FtIlOtc2GB+wygc10Re4P3+fwJvYemdggTYiBoiXiXvr/gJv8sHM9HJOEdbPmrshnxD+Y6mS5H0RjMi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aHhSqsFj; arc=none smtp.client-ip=192.55.52.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706765546; x=1738301546;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Fa5/UvlMsHAjzZZribGcNm9FV3I5qa09T2F62x3/RdI=;
  b=aHhSqsFjgTpNFn/oCKBHXHTqR/3oRaAQwxzfN+WD0q6GMjTgJfC+UVj/
   xsDqgSzOm91OxiE0Tf/aVz9DhlqbmzGejY187cGdLXfyh4w2JvqjqGUyq
   x4IdKeNNG0jSY1ZOnkdemcmGjpdmL2hKhtuDGQkwYiWKbXjRj4JJ9G/D1
   SSriZXlcUJZwnAqzBRmxS5A0EVMtJvfaG/GzDiW/Inl0w/lcKvEGYGezG
   JBcHo4YusP5Y57usviZPbgFQXy6m4iGBgHhZhJirylYuJVDU//meLULBK
   saYS2BmigfCVcbJLf3Unbewu7gEESGlIkV3yMCbAXlprrn7mlEesWM6Tg
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="434979726"
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="434979726"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2024 21:32:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="822824594"
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="822824594"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga001.jf.intel.com with ESMTP; 31 Jan 2024 21:32:20 -0800
Date: Thu, 1 Feb 2024 13:32:19 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
Subject: Re: [PATCH v18 020/121] x86/virt/tdx: Get system-wide info about TDX
 module on initialization
Message-ID: <20240201053219.4kvwhuz27dsicfu3@yy-desk-7060>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <d82142369de93661bdb57b8819a409694cede56e.1705965634.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d82142369de93661bdb57b8819a409694cede56e.1705965634.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215

On Mon, Jan 22, 2024 at 03:52:56PM -0800, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> TDX KVM needs system-wide information about the TDX module, store it in
> struct tdx_info.
>
> TODO: Once TDX host patch series introduces a framework to read TDX meta
> data, convert the code to it.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> Change v18:
> - Newly Added
> ---
>  arch/x86/include/uapi/asm/kvm.h | 11 +++++
>  arch/x86/kvm/vmx/main.c         |  9 +++-
>  arch/x86/kvm/vmx/tdx.c          | 79 ++++++++++++++++++++++++++++++++-
>  arch/x86/kvm/vmx/x86_ops.h      |  2 +
>  4 files changed, 99 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index aa7a56a47564..45b2c2304491 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -567,4 +567,15 @@ struct kvm_pmu_event_filter {
>  #define KVM_X86_TDX_VM		2
>  #define KVM_X86_SNP_VM		3
>
> +#define KVM_TDX_CPUID_NO_SUBLEAF	((__u32)-1)
> +
> +struct kvm_tdx_cpuid_config {
> +	__u32 leaf;
> +	__u32 sub_leaf;
> +	__u32 eax;
> +	__u32 ebx;
> +	__u32 ecx;
> +	__u32 edx;
> +};
> +
>  #endif /* _ASM_X86_KVM_H */
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 62236bde3779..f181620b2922 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -47,6 +47,13 @@ static __init int vt_hardware_setup(void)
>  	return 0;
>  }
>
> +static void vt_hardware_unsetup(void)
> +{
> +	if (enable_tdx)
> +		tdx_hardware_unsetup();
> +	vmx_hardware_unsetup();
> +}
> +
>  static int vt_vm_init(struct kvm *kvm)
>  {
>  	if (is_td(kvm))
> @@ -69,7 +76,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>
>  	.check_processor_compatibility = vmx_check_processor_compat,
>
> -	.hardware_unsetup = vmx_hardware_unsetup,
> +	.hardware_unsetup = vt_hardware_unsetup,
>
>  	.hardware_enable = vt_hardware_enable,
>  	.hardware_disable = vmx_hardware_disable,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 1608bdf2381d..55399136b680 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -67,7 +67,7 @@ static size_t tdx_md_element_size(u64 fid)
>  	}
>  }
>
> -int tdx_md_read(struct tdx_md_map *maps, int nr_maps)
> +static int tdx_md_read(struct tdx_md_map *maps, int nr_maps)
>  {
>  	struct tdx_md_map *m;
>  	int ret, i;
> @@ -85,9 +85,39 @@ int tdx_md_read(struct tdx_md_map *maps, int nr_maps)
>  	return 0;
>  }
>
> +struct tdx_info {
> +	u64 attributes_fixed0;
> +	u64 attributes_fixed1;
> +	u64 xfam_fixed0;
> +	u64 xfam_fixed1;
> +
> +	u16 num_cpuid_config;
> +	/* This must the last member. */
> +	DECLARE_FLEX_ARRAY(struct kvm_tdx_cpuid_config, cpuid_configs);
> +};
> +
> +/* Info about the TDX module. */
> +static struct tdx_info *tdx_info;
> +
>  static int __init tdx_module_setup(void)
>  {
> +	u16 num_cpuid_config;
>  	int ret;
> +	u32 i;
> +
> +	struct tdx_md_map mds[] = {
> +		TDX_MD_MAP(NUM_CPUID_CONFIG, &num_cpuid_config),
> +	};
> +
> +#define TDX_INFO_MAP(_field_id, _member)			\
> +	TD_SYSINFO_MAP(_field_id, struct tdx_info, _member)
> +
> +	struct tdx_metadata_field_mapping tdx_info_md[] = {
> +		TDX_INFO_MAP(ATTRS_FIXED0, attributes_fixed0),
> +		TDX_INFO_MAP(ATTRS_FIXED1, attributes_fixed1),
> +		TDX_INFO_MAP(XFAM_FIXED0, xfam_fixed0),
> +		TDX_INFO_MAP(XFAM_FIXED1, xfam_fixed1),
> +	};
>
>  	ret = tdx_enable();
>  	if (ret) {
> @@ -95,7 +125,49 @@ static int __init tdx_module_setup(void)
>  		return ret;
>  	}
>
> +	ret = tdx_md_read(mds, ARRAY_SIZE(mds));
> +	if (ret)
> +		return ret;
> +
> +	tdx_info = kzalloc(sizeof(*tdx_info) +
> +			   sizeof(*tdx_info->cpuid_configs) * num_cpuid_config,
> +			   GFP_KERNEL);
> +	if (!tdx_info)
> +		return -ENOMEM;
> +	tdx_info->num_cpuid_config = num_cpuid_config;
> +
> +	ret = tdx_sys_metadata_read(tdx_info_md, ARRAY_SIZE(tdx_info_md), tdx_info);
> +	if (ret)
> +		return ret;

"goto error_sys_rd" as below to free the tdx_info ?

> +
> +	for (i = 0; i < num_cpuid_config; i++) {
> +		struct kvm_tdx_cpuid_config *c = &tdx_info->cpuid_configs[i];
> +		u64 leaf, eax_ebx, ecx_edx;
> +		struct tdx_md_map cpuids[] = {
> +			TDX_MD_MAP(CPUID_CONFIG_LEAVES + i, &leaf),
> +			TDX_MD_MAP(CPUID_CONFIG_VALUES + i * 2, &eax_ebx),
> +			TDX_MD_MAP(CPUID_CONFIG_VALUES + i * 2 + 1, &ecx_edx),
> +		};
> +
> +		ret = tdx_md_read(cpuids, ARRAY_SIZE(cpuids));
> +		if (ret)
> +			goto error_sys_rd;
> +
> +		c->leaf = (u32)leaf;
> +		c->sub_leaf = leaf >> 32;
> +		c->eax = (u32)eax_ebx;
> +		c->ebx = eax_ebx >> 32;
> +		c->ecx = (u32)ecx_edx;
> +		c->edx = ecx_edx >> 32;
> +	}
> +
>  	return 0;
> +
> +error_sys_rd:
> +	ret = -EIO;
> +	/* kfree() accepts NULL. */
> +	kfree(tdx_info);
> +	return ret;
>  }
>
>  bool tdx_is_vm_type_supported(unsigned long type)
> @@ -163,3 +235,8 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
>  out:
>  	return r;
>  }
> +
> +void tdx_hardware_unsetup(void)
> +{
> +	kfree(tdx_info);
> +}
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 5da7a5fd91cb..9523087ae355 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -136,9 +136,11 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
>
>  #ifdef CONFIG_INTEL_TDX_HOST
>  int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
> +void tdx_hardware_unsetup(void);
>  bool tdx_is_vm_type_supported(unsigned long type);
>  #else
>  static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -EOPNOTSUPP; }
> +static inline void tdx_hardware_unsetup(void) {}
>  static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
>  #endif
>
> --
> 2.25.1
>
>

