Return-Path: <kvm+bounces-63400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 638A2C6596C
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 18:46:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9E4BD350E80
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 17:35:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB9913112BD;
	Mon, 17 Nov 2025 17:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AksLsWzF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3659030EF76;
	Mon, 17 Nov 2025 17:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763400875; cv=none; b=FZoMqMkkn5UC4iU7BEei36Aez7MRf/nNZ15MDG+QW+yzymMLWmUWOs/HK404oZ4I4nFlN5CpYpPhG7Q5QY8iwQ+Fv/0C5dlXL1jV6LGEur7LYkWaVgLITbLLlc7rf18v57mPUyavjJ3UkoGvi4mG11daF9SNGj7qSyDK1vV6oL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763400875; c=relaxed/simple;
	bh=oeTn00A7A4orN8LyUXiqAvW9aE1W8uyYgcBTVb8y/qA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CP4lN3WxItMgoUigOJCSXaGYIsJ+ImC8nlAAq4ux52cNUKZWIpCjEFHpoe2Rl/aGNnfSBAkd56wGI+vdoEGPGqx+ra3ZUKFOVZYUBSlMi7VTpnR3uyeYvJ+qG2VfJSIZ0uiRSCp3dXgN+6qJEnrbp/L5ONSyDg3CkBWnu2mEFF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AksLsWzF; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763400872; x=1794936872;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=oeTn00A7A4orN8LyUXiqAvW9aE1W8uyYgcBTVb8y/qA=;
  b=AksLsWzFkCBYE3a9UYSeBuI/eQ6KdGm3snzeseOIgaSe+S8xLrrKYVjv
   E9xQ7PABZR62zhvY1G1iWy5IHRcIDWAxif3J764kE1D/30FThmR7iVmOA
   CzuTIUHN81+Qa7UK2QWo0RSqEDOSaBaVoNn0N5vrUhoP9q11A/YoskXVX
   Kk95/zveGCpSzmJLDgyg3hM5EtLXHV3PKWkVRXmJmPzopCjLXR2uLwu8M
   8sSRzNMIlTRqnljdWqNbEHuNEMAIQycypztwdR6MYKrFZb0GywoOquHde
   s70hdAfWFw5lBAh+OHKrJS1zH6ZaF+olP7pB37AzolavOlenFeNkM/uf3
   A==;
X-CSE-ConnectionGUID: +DSRdRO0T3OZHaZ++egvLw==
X-CSE-MsgGUID: zFWmAOfOR/e7Sjp5KrOCjw==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="65447774"
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="65447774"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 09:34:32 -0800
X-CSE-ConnectionGUID: QC+PLg5rTZa5PIalvlKOvg==
X-CSE-MsgGUID: U1rE4C1sRvWNj9E8w3kemg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="213905629"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO [10.125.109.33]) ([10.125.109.33])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 09:34:31 -0800
Message-ID: <cfcfb160-fcd2-4a75-9639-5f7f0894d14b@intel.com>
Date: Mon, 17 Nov 2025 09:34:30 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 08/26] x86/virt/tdx: Add tdx_enable_ext() to enable of
 TDX Module Extensions
To: Xu Yilun <yilun.xu@linux.intel.com>, linux-coco@lists.linux.dev,
 linux-pci@vger.kernel.org
Cc: chao.gao@intel.com, dave.jiang@intel.com, baolu.lu@linux.intel.com,
 yilun.xu@intel.com, zhenzhong.duan@intel.com, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, dave.hansen@linux.intel.com,
 dan.j.williams@intel.com, kas@kernel.org, x86@kernel.org
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
 <20251117022311.2443900-9-yilun.xu@linux.intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20251117022311.2443900-9-yilun.xu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

I really dislike subjects like this. I honestly don't need to know what
the function's name is. The _rest_ of the subject is just words that
don't tell me _anything_ about what this patch does.

In this case, I suspect it's because the patch is doing about 15
discrete things and it's impossible to write a subject that's anything
other than some form of:

	x86/virt/tdx: Implement $FOO by making miscellaneous changes

So it's a symptom of the real disease.

On 11/16/25 18:22, Xu Yilun wrote:
> From: Zhenzhong Duan <zhenzhong.duan@intel.com>
> 
> Add a kAPI tdx_enable_ext() for kernel to enable TDX Module Extensions
> after basic TDX Module initialization.
> 
> The extension initialization uses the new TDH.EXT.MEM.ADD and
> TDX.EXT.INIT seamcalls. TDH.EXT.MEM.ADD add pages to a shared memory
> pool for extensions to consume.

"Shared memory" is an exceedingly unfortunate term to use here. They're
TDX private memory, right?

> The number of pages required is
> published in the MEMORY_POOL_REQUIRED_PAGES field from TDH.SYS.RD. Then
> on TDX.EXT.INIT, the extensions consume from the pool and initialize.

This all seems backwards to me. I don't need to read the ABI names in
the changelog. I *REALLY* don't need to read the TDX documentation names
for them. If *ANYTHING* these names should be trivialy mappable to the
patch that sits below this changelog. They're not.

This changelog _should_ begin:

	Currently, TDX module memory use is relatively static. But, some
	new features (called "TDX Module Extensions") need to use memory
	more dynamically.

How much memory does this consume?

> TDH.EXT.MEM.ADD is the first user of tdx_page_array. It provides pages
> to TDX Module as control (private) pages. A tdx_clflush_page_array()
> helper is introduced to flush shared cache before SEAMCALL, to avoid
> shared cache write back damages these private pages.

First, this talks about "control pages". But I don't know what a control
page is.

Second, these all need to be in imperative voice. Not:

	It provides pages to TDX Module as control (private) pages.

Do this:

	Provide pages to TDX Module as control (private) pages.

> TDH.EXT.MEM.ADD uses HPA_LIST_INFO as parameter so could leverage the
> 'first_entry' field to simplify the interrupted - retry flow. Host
> don't have to care about partial page adding and 'first_entry'.
> 
> Use a new version TDH.SYS.CONFIG for VMM to tell TDX Module which
> optional features (e.g. TDX Connect, and selecting TDX Connect implies
> selecting TDX Module Extensions) to use and let TDX Module update its
> global metadata (e.g. memory_pool_required_pages for TDX Module
> Extensions). So after calling this new version TDH.SYS.CONFIG, VMM
> updates the cached tdx_sysinfo.
> 
> Note that this extension initialization does not impact existing
> in-flight SEAMCALLs that are not implemented by the extension. So only
> the first user of an extension-seamcall needs invoke this helper.

Ahh, so this is another bit of very useful information buried deep in
this changelog.

Extensions consume memory, but they're *optional*.

> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 3a3ea3fa04f2..1eeb77a6790a 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -125,11 +125,13 @@ static __always_inline u64 sc_retry(sc_func_t func, u64 fn,
>  #define seamcall(_fn, _args)		sc_retry(__seamcall, (_fn), (_args))
>  #define seamcall_ret(_fn, _args)	sc_retry(__seamcall_ret, (_fn), (_args))
>  #define seamcall_saved_ret(_fn, _args)	sc_retry(__seamcall_saved_ret, (_fn), (_args))
> +int tdx_enable_ext(void);
>  const char *tdx_dump_mce_info(struct mce *m);
>  
>  /* Bit definitions of TDX_FEATURES0 metadata field */
>  #define TDX_FEATURES0_TDXCONNECT	BIT_ULL(6)
>  #define TDX_FEATURES0_NO_RBP_MOD	BIT_ULL(18)
> +#define TDX_FEATURES0_EXT		BIT_ULL(39)
>  
>  const struct tdx_sys_info *tdx_get_sysinfo(void);
>  
> @@ -223,6 +225,7 @@ u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
>  u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page);
>  #else
>  static inline void tdx_init(void) { }
> +static inline int tdx_enable_ext(void) { return -ENODEV; }
>  static inline u32 tdx_get_nr_guest_keyids(void) { return 0; }
>  static inline const char *tdx_dump_mce_info(struct mce *m) { return NULL; }
>  static inline const struct tdx_sys_info *tdx_get_sysinfo(void) { return NULL; }
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index 4370d3d177f6..b84678165d00 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -46,6 +46,8 @@
>  #define TDH_PHYMEM_PAGE_WBINVD		41
>  #define TDH_VP_WR			43
>  #define TDH_SYS_CONFIG			45
> +#define TDH_EXT_INIT			60
> +#define TDH_EXT_MEM_ADD			61
>  
>  /*
>   * SEAMCALL leaf:
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 9a5c32dc1767..bbf93cad5bf2 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -59,6 +59,9 @@ static LIST_HEAD(tdx_memlist);
>  static struct tdx_sys_info tdx_sysinfo __ro_after_init;
>  static bool tdx_module_initialized __ro_after_init;
>  
> +static DEFINE_MUTEX(tdx_module_ext_lock);
> +static bool tdx_module_ext_initialized;
> +
>  typedef void (*sc_err_func_t)(u64 fn, u64 err, struct tdx_module_args *args);
>  
>  static inline void seamcall_err(u64 fn, u64 err, struct tdx_module_args *args)
> @@ -517,7 +520,7 @@ EXPORT_SYMBOL_GPL(tdx_page_array_ctrl_release);
>  #define HPA_LIST_INFO_PFN		GENMASK_U64(51, 12)
>  #define HPA_LIST_INFO_LAST_ENTRY	GENMASK_U64(63, 55)
>  
> -static u64 __maybe_unused hpa_list_info_assign_raw(struct tdx_page_array *array)
> +static u64 hpa_list_info_assign_raw(struct tdx_page_array *array)
>  {
>  	return FIELD_PREP(HPA_LIST_INFO_FIRST_ENTRY, 0) |
>  	       FIELD_PREP(HPA_LIST_INFO_PFN, page_to_pfn(array->root)) |
> @@ -1251,7 +1254,14 @@ static __init int config_tdx_module(struct tdmr_info_list *tdmr_list,
>  	args.rcx = __pa(tdmr_pa_array);
>  	args.rdx = tdmr_list->nr_consumed_tdmrs;
>  	args.r8 = global_keyid;
> -	ret = seamcall_prerr(TDH_SYS_CONFIG, &args);
> +
> +	if (tdx_sysinfo.features.tdx_features0 & TDX_FEATURES0_TDXCONNECT) {
> +		args.r9 |= TDX_FEATURES0_TDXCONNECT;
> +		args.r11 = ktime_get_real_seconds();
> +		ret = seamcall_prerr(TDH_SYS_CONFIG | (1ULL << TDX_VERSION_SHIFT), &args);
> +	} else {
> +		ret = seamcall_prerr(TDH_SYS_CONFIG, &args);
> +	}

I'm in the first actual hunk of code and I'm lost. I don't have any idea
what the "(1ULL << TDX_VERSION_SHIFT)" is doing.

Also, bifurcating code paths is discouraged. It's much better to not
copy and paste the code and instead name your variables and change
*them* in a single path:

    u64 module_function = TDH_SYS_CONFIG;
    u64 features = 0;
    u64 timestamp = 0;

    if (tdx_sysinfo.features.tdx_features0 & TDX_FEATURES0_TDXCONNECT) {
	features |= TDX_FEATURES0_TDXCONNECT;
	timestamp = ktime_get_real_seconds();
	module_function |= 1ULL << TDX_VERSION_SHIFT;
    }

    ret = seamcall_prerr(module_function, &args);

This would also provide a place to say what the heck is going on with
the whole "(1ULL << TDX_VERSION_SHIFT)" thing. Just hacking it in and
open-coding makes it actually harder to comment and describe it.

>  	/* Free the array as it is not required anymore. */
>  	kfree(tdmr_pa_array);
> @@ -1411,6 +1421,11 @@ static __init int init_tdx_module(void)
>  	if (ret)
>  		goto err_free_pamts;
>  
> +	/* configuration to tdx module may change tdx_sysinfo, update it */
> +	ret = get_tdx_sys_info(&tdx_sysinfo);
> +	if (ret)
> +		goto err_reset_pamts;
> +
>  	/* Config the key of global KeyID on all packages */
>  	ret = config_global_keyid();
>  	if (ret)
> @@ -1488,6 +1503,160 @@ static __init int tdx_enable(void)
>  }
>  subsys_initcall(tdx_enable);
>  
> +static int enable_tdx_ext(void)
> +{

Comments, please. "ext" can mean too many things. What does this do and
why can it fail?

> +	struct tdx_module_args args = {};
> +	u64 r;
> +
> +	if (!tdx_sysinfo.ext.ext_required)
> +		return 0;

Is this an optimization or is it functionally required?

> +	do {
> +		r = seamcall(TDH_EXT_INIT, &args);
> +		cond_resched();
> +	} while (r == TDX_INTERRUPTED_RESUMABLE);
> +
> +	if (r != TDX_SUCCESS)
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +static void tdx_ext_mempool_free(struct tdx_page_array *mempool)
> +{
> +	/*
> +	 * Some pages may have been touched by the TDX module.
> +	 * Flush cache before returning these pages to kernel.
> +	 */
> +	wbinvd_on_all_cpus();
> +	tdx_page_array_free(mempool);
> +}
> +
> +DEFINE_FREE(tdx_ext_mempool_free, struct tdx_page_array *,
> +	    if (!IS_ERR_OR_NULL(_T)) tdx_ext_mempool_free(_T))
> +
> +/*
> + * The TDX module exposes a CLFLUSH_BEFORE_ALLOC bit to specify whether
> + * a CLFLUSH of pages is required before handing them to the TDX module.
> + * Be conservative and make the code simpler by doing the CLFLUSH
> + * unconditionally.
> + */
> +static void tdx_clflush_page(struct page *page)
> +{
> +	clflush_cache_range(page_to_virt(page), PAGE_SIZE);
> +}

arch/x86/virt/vmx/tdx/tdx.c has:

static void tdx_clflush_page(struct page *page)
{
        clflush_cache_range(page_to_virt(page), PAGE_SIZE);
}

Seems odd to see this here.

> +static void tdx_clflush_page_array(struct tdx_page_array *array)
> +{
> +	for (int i = 0; i < array->nents; i++)
> +		tdx_clflush_page(array->pages[array->offset + i]);
> +}
> +
> +static int tdx_ext_mem_add(struct tdx_page_array *mempool)
> +{

I just realized the 'mempool' has nothing to do with 'struct mempool',
which makes this a rather unfortunate naming choice.

> +	struct tdx_module_args args = {
> +		.rcx = hpa_list_info_assign_raw(mempool),
> +	};
> +	u64 r;
> +
> +	tdx_clflush_page_array(mempool);
> +
> +	do {
> +		r = seamcall_ret(TDH_EXT_MEM_ADD, &args);
> +		cond_resched();
> +	} while (r == TDX_INTERRUPTED_RESUMABLE);
> +
> +	if (r != TDX_SUCCESS)
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +static struct tdx_page_array *tdx_ext_mempool_setup(void)
> +{
> +	unsigned int nr_pages, nents, offset = 0;
> +	int ret;
> +
> +	nr_pages = tdx_sysinfo.ext.memory_pool_required_pages;
> +	if (!nr_pages)
> +		return NULL;
> +
> +	struct tdx_page_array *mempool __free(tdx_page_array_free) =
> +		tdx_page_array_alloc(nr_pages);
> +	if (!mempool)
> +		return ERR_PTR(-ENOMEM);
> +
> +	while (1) {
> +		nents = tdx_page_array_fill_root(mempool, offset);

This is really difficult to understand. It's not really filling a
"root", it's populating an array. The structure of the loop is also
rather non-obvious. It's doing:

	while (1) {
		fill(&array);
		tell_tdx_module(&array);
	}

Why can't it be:

	while (1)
		fill(&array);
	while (1)
		tell_tdx_module(&array);

for example?

> +		if (!nents)
> +			break;
> +
> +		ret = tdx_ext_mem_add(mempool);
> +		if (ret)
> +			return ERR_PTR(ret);
> +
> +		offset += nents;
> +	}
> +
> +	return no_free_ptr(mempool);
> +}

This patch is getting waaaaaaaaaaaaaaay too long. I'd say it needs to be
4 or 5 patches, just eyeballing it.

Call be old fashioned, but I suspect the use of __free() here is atually
hurting readability.

> +static int init_tdx_ext(void)
> +{
> +	int ret;
> +
> +	if (!(tdx_sysinfo.features.tdx_features0 & TDX_FEATURES0_EXT))
> +		return -EOPNOTSUPP;
> +
> +	struct tdx_page_array *mempool __free(tdx_ext_mempool_free) =
> +		tdx_ext_mempool_setup();
> +	/* Return NULL is OK, means no need to setup mempool */
> +	if (IS_ERR(mempool))
> +		return PTR_ERR(mempool);

That's a somewhat odd comment to put above an if() that doesn't return NULL.

> +	ret = enable_tdx_ext();
> +	if (ret)
> +		return ret;
> +
> +	/* Extension memory is never reclaimed once assigned */
> +	if (mempool)
> +		tdx_page_array_ctrl_leak(no_free_ptr(mempool));
> +
> +	return 0;
> +}



> +/**
> + * tdx_enable_ext - Enable TDX module extensions.
> + *
> + * This function can be called in parallel by multiple callers.
> + *
> + * Return 0 if TDX module extension is enabled successfully, otherwise error.
> + */
> +int tdx_enable_ext(void)
> +{
> +	int ret;
> +
> +	if (!tdx_module_initialized)
> +		return -ENOENT;
> +
> +	guard(mutex)(&tdx_module_ext_lock);
> +
> +	if (tdx_module_ext_initialized)
> +		return 0;
> +
> +	ret = init_tdx_ext();
> +	if (ret) {
> +		pr_debug("module extension initialization failed (%d)\n", ret);
> +		return ret;
> +	}
> +
> +	pr_debug("module extension initialized\n");
> +	tdx_module_ext_initialized = true;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(tdx_enable_ext);
> +
>  static bool is_pamt_page(unsigned long phys)
>  {
>  	struct tdmr_info_list *tdmr_list = &tdx_tdmr_list;
> @@ -1769,17 +1938,6 @@ static inline u64 tdx_tdr_pa(struct tdx_td *td)
>  	return page_to_phys(td->tdr_page);
>  }
>  
> -/*
> - * The TDX module exposes a CLFLUSH_BEFORE_ALLOC bit to specify whether
> - * a CLFLUSH of pages is required before handing them to the TDX module.
> - * Be conservative and make the code simpler by doing the CLFLUSH
> - * unconditionally.
> - */
> -static void tdx_clflush_page(struct page *page)
> -{
> -	clflush_cache_range(page_to_virt(page), PAGE_SIZE);
> -}

Ahh, here's the code move.

This should be in its own patch.



