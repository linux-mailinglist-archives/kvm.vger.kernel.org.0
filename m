Return-Path: <kvm+bounces-3666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 522C98068CE
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 08:41:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF295281E85
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 07:41:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E11418034;
	Wed,  6 Dec 2023 07:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eED6W0Pu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C2E4C08;
	Tue,  5 Dec 2023 23:40:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701848456; x=1733384456;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UDgmIRtUsBAgmMXNIRnY0EUz/W1VHjpSomUlz5Ts1so=;
  b=eED6W0Puu3Nn8122MX5cfDwbCBi9mjlU0YEo8Se8TV0C+NgQkTjZqmlA
   zCCO+iCCNwW3a0ghPK74wQI/bND88JR1/pfHXLZRBDzxTG6TPsKb6nMrO
   mBYgvrfCOvEwgPo2kZ3zEm4B1T5MT2ua3AUcDKlZB2iIen2Rsow37N342
   yOBPDr0VAEMtDkMlAhhf2gWX3zuzp8+1AyEI47LbrrtMjBF691jqT2NRA
   8/T0H22UYo7sTVZzpbs+4tAKbVOEk3Na/iJGs9soLINSSAbZubPj2N6cs
   IB5K/a7oP+sZ9x/WuaBpShQxPmcnyhiumCVeQ6G+FgaFYTzAnkY4LDSL4
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="7371826"
X-IronPort-AV: E=Sophos;i="6.04,254,1695711600"; 
   d="scan'208";a="7371826"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 23:40:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="720992106"
X-IronPort-AV: E=Sophos;i="6.04,254,1695711600"; 
   d="scan'208";a="720992106"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.126]) ([10.238.10.126])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 23:40:51 -0800
Message-ID: <fecfdbc0-eede-4ed5-a433-ce20fe78a862@linux.intel.com>
Date: Wed, 6 Dec 2023 15:40:48 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 016/116] x86/virt/tdx: Add a helper function to return
 system wide info about TDX module
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>,
 Kai Huang <kai.huang@intel.com>, Zhi Wang <zhi.wang.linux@gmail.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1699368322.git.isaku.yamahata@intel.com>
 <9069af111a000d8e67d94ffbda8ea82756cc9d36.1699368322.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <9069af111a000d8e67d94ffbda8ea82756cc9d36.1699368322.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/7/2023 10:55 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> TDX KVM needs system-wide information about the TDX module, struct
> tdsysinfo_struct.  Add a helper function tdx_get_sysinfo() to return it
> instead of KVM getting it with various error checks.  Make KVM call the
> function and stash the info.  Move out the struct definition about it to
> common place arch/x86/include/asm/tdx.h.

Why add tdx_get_sysinfo() to arch/x86/virt/vmx/tdx/tdx.c?
Seems throughout the whole patchset, tdx_get_sysinfo() is only called inside
arch/x86/kvm/vmx/tdx.c, even no need to add the helper API since it can be
reference in arch/x86/kvm/vmx/tdx.c directly?


>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/tdx.h  | 59 +++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/tdx.c      | 15 +++++++++-
>   arch/x86/virt/vmx/tdx/tdx.c | 20 +++++++++++--
>   arch/x86/virt/vmx/tdx/tdx.h | 51 --------------------------------
>   4 files changed, 91 insertions(+), 54 deletions(-)
>
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 3b648f290af3..276bdae47738 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -109,6 +109,62 @@ static inline u64 sc_retry(sc_func_t func, u64 fn,
>   #define seamcall_ret(_fn, _args)	sc_retry(__seamcall_ret, (_fn), (_args))
>   #define seamcall_saved_ret(_fn, _args)	sc_retry(__seamcall_saved_ret, (_fn), (_args))
>   
> +struct tdx_cpuid_config {
> +	__struct_group(tdx_cpuid_config_leaf, leaf_sub_leaf, __packed,
> +		u32 leaf;
> +		u32 sub_leaf;
> +	);
> +	__struct_group(tdx_cpuid_config_value, value, __packed,
> +		u32 eax;
> +		u32 ebx;
> +		u32 ecx;
> +		u32 edx;
> +	);
> +} __packed;
> +
> +#define TDSYSINFO_STRUCT_SIZE		1024
> +#define TDSYSINFO_STRUCT_ALIGNMENT	1024
> +
> +/*
> + * The size of this structure itself is flexible.  The actual structure
> + * passed to TDH.SYS.INFO must be padded to TDSYSINFO_STRUCT_SIZE bytes
> + * and TDSYSINFO_STRUCT_ALIGNMENT bytes aligned.
> + */
> +struct tdsysinfo_struct {
> +	/* TDX-SEAM Module Info */
> +	u32	attributes;
> +	u32	vendor_id;
> +	u32	build_date;
> +	u16	build_num;
> +	u16	minor_version;
> +	u16	major_version;
> +	u8	reserved0[14];
> +	/* Memory Info */
> +	u16	max_tdmrs;
> +	u16	max_reserved_per_tdmr;
> +	u16	pamt_entry_size;
> +	u8	reserved1[10];
> +	/* Control Struct Info */
> +	u16	tdcs_base_size;
> +	u8	reserved2[2];
> +	u16	tdvps_base_size;
> +	u8	tdvps_xfam_dependent_size;
> +	u8	reserved3[9];
> +	/* TD Capabilities */
> +	u64	attributes_fixed0;
> +	u64	attributes_fixed1;
> +	u64	xfam_fixed0;
> +	u64	xfam_fixed1;
> +	u8	reserved4[32];
> +	u32	num_cpuid_config;
> +	/*
> +	 * The actual number of CPUID_CONFIG depends on above
> +	 * 'num_cpuid_config'.
> +	 */
> +	DECLARE_FLEX_ARRAY(struct tdx_cpuid_config, cpuid_configs);
> +} __packed;
> +
> +const struct tdsysinfo_struct *tdx_get_sysinfo(void);
>   bool platform_tdx_enabled(void);
>   int tdx_cpu_enable(void);
>   int tdx_enable(void);
> @@ -137,6 +193,9 @@ static inline u64 __seamcall_saved_ret(u64 fn, struct tdx_module_args *args)
>   {
>   	return TDX_SEAMCALL_UD;
>   }
> +
> +struct tdsysinfo_struct;
> +static inline const struct tdsysinfo_struct *tdx_get_sysinfo(void) { return NULL; }
>   static inline bool platform_tdx_enabled(void) { return false; }
>   static inline int tdx_cpu_enable(void) { return -ENODEV; }
>   static inline int tdx_enable(void)  { return -ENODEV; }
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 9d3f593eacb8..b0e3409da5a8 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -11,9 +11,18 @@
>   #undef pr_fmt
>   #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>   
> +#define TDX_MAX_NR_CPUID_CONFIGS					\
> +	((TDSYSINFO_STRUCT_SIZE -					\
> +		offsetof(struct tdsysinfo_struct, cpuid_configs))	\
> +		/ sizeof(struct tdx_cpuid_config))
> +
>   static int __init tdx_module_setup(void)
>   {
> -	int ret;
> +	const struct tdsysinfo_struct *tdsysinfo;
> +	int ret = 0;
> +
> +	BUILD_BUG_ON(sizeof(*tdsysinfo) > TDSYSINFO_STRUCT_SIZE);
> +	BUILD_BUG_ON(TDX_MAX_NR_CPUID_CONFIGS != 37);
>   
>   	ret = tdx_enable();
>   	if (ret) {
> @@ -21,6 +30,10 @@ static int __init tdx_module_setup(void)
>   		return ret;
>   	}
>   
> +	/* Sanitary check just in case. */
> +	tdsysinfo = tdx_get_sysinfo();
> +	WARN_ON(tdsysinfo->num_cpuid_config > TDX_MAX_NR_CPUID_CONFIGS);
> +
>   	return 0;
>   }
>   
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index c01cbfc81fbb..9942804cf62f 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -265,6 +265,20 @@ static int get_tdx_sysinfo(struct tdsysinfo_struct *tdsysinfo,
>   	return 0;
>   }
>   
> +static struct tdsysinfo_struct *tdsysinfo;
> +
> +const struct tdsysinfo_struct *tdx_get_sysinfo(void)
> +{
> +	const struct tdsysinfo_struct *r = NULL;
> +
> +	mutex_lock(&tdx_module_lock);
> +	if (tdx_module_status == TDX_MODULE_INITIALIZED)
> +		r = tdsysinfo;
> +	mutex_unlock(&tdx_module_lock);
> +	return r;
> +}
> +EXPORT_SYMBOL_GPL(tdx_get_sysinfo);
> +
>   /*
>    * Add a memory region as a TDX memory block.  The caller must make sure
>    * all memory regions are added in address ascending order and don't
> @@ -1090,7 +1104,6 @@ static int init_tdmrs(struct tdmr_info_list *tdmr_list)
>   
>   static int init_tdx_module(void)
>   {
> -	struct tdsysinfo_struct *tdsysinfo;
>   	struct cmr_info *cmr_array;
>   	int tdsysinfo_size;
>   	int cmr_array_size;
> @@ -1181,7 +1194,10 @@ static int init_tdx_module(void)
>   	 * For now both @sysinfo and @cmr_array are only used during
>   	 * module initialization, so always free them.
>   	 */
> -	kfree(tdsysinfo);
> +	if (ret) {
> +		kfree(tdsysinfo);
> +		tdsysinfo = NULL;
> +	}
>   	kfree(cmr_array);
>   	return ret;
>   
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index 5bcbfc2fc466..c37a54cff1fa 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -36,57 +36,6 @@ struct cmr_info {
>   #define MAX_CMRS	32
>   #define CMR_INFO_ARRAY_ALIGNMENT	512
>   
> -struct cpuid_config {
> -	u32	leaf;
> -	u32	sub_leaf;
> -	u32	eax;
> -	u32	ebx;
> -	u32	ecx;
> -	u32	edx;
> -} __packed;
> -
> -#define TDSYSINFO_STRUCT_SIZE		1024
> -#define TDSYSINFO_STRUCT_ALIGNMENT	1024
> -
> -/*
> - * The size of this structure itself is flexible.  The actual structure
> - * passed to TDH.SYS.INFO must be padded to TDSYSINFO_STRUCT_SIZE bytes
> - * and TDSYSINFO_STRUCT_ALIGNMENT bytes aligned.
> - */
> -struct tdsysinfo_struct {
> -	/* TDX-SEAM Module Info */
> -	u32	attributes;
> -	u32	vendor_id;
> -	u32	build_date;
> -	u16	build_num;
> -	u16	minor_version;
> -	u16	major_version;
> -	u8	reserved0[14];
> -	/* Memory Info */
> -	u16	max_tdmrs;
> -	u16	max_reserved_per_tdmr;
> -	u16	pamt_entry_size;
> -	u8	reserved1[10];
> -	/* Control Struct Info */
> -	u16	tdcs_base_size;
> -	u8	reserved2[2];
> -	u16	tdvps_base_size;
> -	u8	tdvps_xfam_dependent_size;
> -	u8	reserved3[9];
> -	/* TD Capabilities */
> -	u64	attributes_fixed0;
> -	u64	attributes_fixed1;
> -	u64	xfam_fixed0;
> -	u64	xfam_fixed1;
> -	u8	reserved4[32];
> -	u32	num_cpuid_config;
> -	/*
> -	 * The actual number of CPUID_CONFIG depends on above
> -	 * 'num_cpuid_config'.
> -	 */
> -	DECLARE_FLEX_ARRAY(struct cpuid_config, cpuid_configs);
> -} __packed;
> -
>   struct tdmr_reserved_area {
>   	u64 offset;
>   	u64 size;


