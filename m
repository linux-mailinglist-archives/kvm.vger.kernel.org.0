Return-Path: <kvm+bounces-11799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17AD287BF8B
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 16:06:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2A2E285EAC
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 15:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 184D971745;
	Thu, 14 Mar 2024 15:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JCcUsB/K"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A546FE08;
	Thu, 14 Mar 2024 15:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710428777; cv=none; b=jfkcIjFeeFl9ALvYu4gmZldgZFQ6IxLXtwDMqsD6uE8eAYjlbcy9PufI5EJ+ZXbHGKIU5TkkOld3ho+nJ5hxQEKFA7GKfDYlm5D1rHQMFeqX6iSXJgc4Tx+A/7ZZyL0OV/6sMHKlbbpTsnyIsaxeKo31plZXmq5C0tZWITUuogY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710428777; c=relaxed/simple;
	bh=ZuryJEA4MrfGOrrFtpSqLW+M7/c52/V/aoCMMRKyq9Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c8RUQnsGRUxVF2osMesO9R+gNVN9itXh+pbbQMNF1pnppgnwXFZhWD5B0NGDl13RnhcFnQJNCrQ2o6+7yc3AfjwF6rmZ26bf4jKrQbDDBBJqT/waFjLGHY0BtYXXpaPSw8R860nEZZz0TfynsaELsUqQ+MSWKzAZazqyawWG134=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JCcUsB/K; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710428775; x=1741964775;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZuryJEA4MrfGOrrFtpSqLW+M7/c52/V/aoCMMRKyq9Q=;
  b=JCcUsB/KVlJifnJHYAkqjhvGPHx+0OrvIJ2otix1AimHeXMhEWNjOWOL
   D5QaXhVVusHuKFohUi69LETbwPkTxKavvzx8jCtZKTf9QGSlw/kusjz6K
   lDAun7sWMXoDlbzJEupZdeL+fpUCniMczozfEcGuKxXLuHGU0LINtdymt
   on4ErtGKR1Rd1woCPzll3BrEjg+uNJe69AnFG4IOPmOQmF+QLgbMf8/4p
   RxdFH7SGoRZHm3/EIMOrWP4OGEDch4gOynKbPml6KPAmSgbSDY8jJIokI
   dhSrwsHZZvflt79+J0T0EkT6yLIvdYrDJWjgyNhsqRVf1PKlh64MOjN8H
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11012"; a="5188535"
X-IronPort-AV: E=Sophos;i="6.07,125,1708416000"; 
   d="scan'208";a="5188535"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 08:06:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,125,1708416000"; 
   d="scan'208";a="49741711"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.242.47]) ([10.124.242.47])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 08:06:11 -0700
Message-ID: <8d994e9c-8fec-44d4-8d45-a01bf5b9b657@linux.intel.com>
Date: Thu, 14 Mar 2024 23:06:09 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 034/130] KVM: TDX: Get system-wide info about TDX
 module on initialization
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <eaa2c1e23971f058e5921681b0b84d7ea7d38dc1.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <eaa2c1e23971f058e5921681b0b84d7ea7d38dc1.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/26/2024 4:25 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> TDX KVM needs system-wide information about the TDX module, store it in
> struct tdx_info.

Nit: Maybe you can add some description about hardware_unsetup()?

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> v19:
> - Added features0
> - Use tdx_sys_metadata_read()
> - Fix error recovery path by Yuan
>
> Change v18:
> - Newly Added
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/uapi/asm/kvm.h | 11 +++++
>   arch/x86/kvm/vmx/main.c         |  9 +++-
>   arch/x86/kvm/vmx/tdx.c          | 80 ++++++++++++++++++++++++++++++++-
>   arch/x86/kvm/vmx/x86_ops.h      |  2 +
>   4 files changed, 100 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index aa7a56a47564..45b2c2304491 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -567,4 +567,15 @@ struct kvm_pmu_event_filter {
>   #define KVM_X86_TDX_VM		2
>   #define KVM_X86_SNP_VM		3
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
>   #endif /* _ASM_X86_KVM_H */
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index fa19682b366c..a948a6959ac7 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -32,6 +32,13 @@ static __init int vt_hardware_setup(void)
>   	return 0;
>   }
>   
> +static void vt_hardware_unsetup(void)
> +{
> +	if (enable_tdx)
> +		tdx_hardware_unsetup();
> +	vmx_hardware_unsetup();
> +}
> +
>   static int vt_vm_init(struct kvm *kvm)
>   {
>   	if (is_td(kvm))
> @@ -54,7 +61,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   
>   	.check_processor_compatibility = vmx_check_processor_compat,
>   
> -	.hardware_unsetup = vmx_hardware_unsetup,
> +	.hardware_unsetup = vt_hardware_unsetup,
>   
>   	/* TDX cpu enablement is done by tdx_hardware_setup(). */
>   	.hardware_enable = vmx_hardware_enable,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index dce21f675155..5edfb99abb89 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -40,6 +40,21 @@ static void __used tdx_guest_keyid_free(int keyid)
>   	ida_free(&tdx_guest_keyid_pool, keyid);
>   }
>   
> +struct tdx_info {
> +	u64 features0;
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
>   #define TDX_MD_MAP(_fid, _ptr)			\
>   	{ .fid = MD_FIELD_ID_##_fid,		\
>   	  .ptr = (_ptr), }
> @@ -66,7 +81,7 @@ static size_t tdx_md_element_size(u64 fid)
>   	}
>   }
>   
> -static int __used tdx_md_read(struct tdx_md_map *maps, int nr_maps)
> +static int tdx_md_read(struct tdx_md_map *maps, int nr_maps)
>   {
>   	struct tdx_md_map *m;
>   	int ret, i;
> @@ -84,9 +99,26 @@ static int __used tdx_md_read(struct tdx_md_map *maps, int nr_maps)
>   	return 0;
>   }
>   
> +#define TDX_INFO_MAP(_field_id, _member)			\
> +	TD_SYSINFO_MAP(_field_id, struct tdx_info, _member)
> +
>   static int __init tdx_module_setup(void)
>   {
> +	u16 num_cpuid_config;
>   	int ret;
> +	u32 i;
> +
> +	struct tdx_md_map mds[] = {
> +		TDX_MD_MAP(NUM_CPUID_CONFIG, &num_cpuid_config),
> +	};
> +
> +	struct tdx_metadata_field_mapping fields[] = {
> +		TDX_INFO_MAP(FEATURES0, features0),
> +		TDX_INFO_MAP(ATTRS_FIXED0, attributes_fixed0),
> +		TDX_INFO_MAP(ATTRS_FIXED1, attributes_fixed1),
> +		TDX_INFO_MAP(XFAM_FIXED0, xfam_fixed0),
> +		TDX_INFO_MAP(XFAM_FIXED1, xfam_fixed1),
> +	};
>   
>   	ret = tdx_enable();
>   	if (ret) {
> @@ -94,7 +126,48 @@ static int __init tdx_module_setup(void)
>   		return ret;
>   	}
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
> +	ret = tdx_sys_metadata_read(fields, ARRAY_SIZE(fields), tdx_info);
> +	if (ret)
> +		goto error_out;
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
> +			goto error_out;
> +
> +		c->leaf = (u32)leaf;
> +		c->sub_leaf = leaf >> 32;
> +		c->eax = (u32)eax_ebx;
> +		c->ebx = eax_ebx >> 32;
> +		c->ecx = (u32)ecx_edx;
> +		c->edx = ecx_edx >> 32;
> +	}
> +
>   	return 0;
> +
> +error_out:
> +	/* kfree() accepts NULL. */
> +	kfree(tdx_info);
> +	return ret;
>   }
>   
>   bool tdx_is_vm_type_supported(unsigned long type)
> @@ -162,3 +235,8 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
>   out:
>   	return r;
>   }
> +
> +void tdx_hardware_unsetup(void)
> +{
> +	kfree(tdx_info);
> +}
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index f4da88a228d0..e8cb4ae81cf1 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -136,9 +136,11 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
>   
>   #ifdef CONFIG_INTEL_TDX_HOST
>   int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
> +void tdx_hardware_unsetup(void);
>   bool tdx_is_vm_type_supported(unsigned long type);
>   #else
>   static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -EOPNOTSUPP; }
> +static inline void tdx_hardware_unsetup(void) {}
>   static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
>   #endif
>   


