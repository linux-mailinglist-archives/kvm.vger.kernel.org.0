Return-Path: <kvm+bounces-25462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8972C9657ED
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 09:02:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7E18FB222DD
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 07:02:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 983231531EB;
	Fri, 30 Aug 2024 07:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P1jyzfgX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C061915217F;
	Fri, 30 Aug 2024 07:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725001361; cv=none; b=pyyhRS1rF/jfK0qKXQ4i3hv3S7La4hXtgUhdXkmoidDzNmXPEENot7OatOaAR0z0DBht1vZO1QMFJcFvickYeKuOT+2B9zDoj8afTQMSm89+C4r8ECGZ0TrngYsHdDz2yflqOVQUnd6W0n7n0lGM/s2/TXAWOQvKWhl1MLByviA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725001361; c=relaxed/simple;
	bh=9WNmUQd0ZluZwTXvzG/Ock8Gx8mODjUxWmvtZdF8OHw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eQ+6mpBwWm8KyT7LCse07HFN2iF6rnilj8DoCWeq3hKJv3oBMGnvEbDPT4MbroffvSt5eWWN4nYCRcH/XOw9ag41fXn70CIH5v1P+0XJCMirwq7AQXRcIZjFHQTbxkntLQwADZdZhIuYzx5PnWBUn+ULJibsVdkGaWVbv4JKdSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P1jyzfgX; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725001360; x=1756537360;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9WNmUQd0ZluZwTXvzG/Ock8Gx8mODjUxWmvtZdF8OHw=;
  b=P1jyzfgXJvcpgJYqRo6qkdBNyvgz8yCFIkMDVTh5EkDYc0r5zSku9l7R
   ncwmH2l3Xwjf9KZRKt1YKX2wc6uh+La5FyotQG0mSbyJC+y3lrxNM3RoG
   ME+v/7DwOfMm1T8aOf44c4nvqTnd3thDrpevbxrn2kU+0crOTI0whgjIw
   +mA9m5VrCRUQWpZVenQf4MkaMXgQO5EprDSHjyzh5VX9uD5C1tG0k28tP
   ul9W9o2vHAsMVxzeQF/m/y/Myz6B4vqWsW0yjV6i+FSXLR/erFaQKN4be
   2G6TwdFzhvIp1gCzkhPCDC2YeAbdF5Bi/d1x8Oy030Yc/MB19Lymo3TSi
   A==;
X-CSE-ConnectionGUID: 4ErPeiKVRd6lDFknW/RJLA==
X-CSE-MsgGUID: sJgzBvYkRsyqfWyPH2eHGw==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="27426896"
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="27426896"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 00:02:40 -0700
X-CSE-ConnectionGUID: E5LfNkeVSamVsm2I14n/5w==
X-CSE-MsgGUID: OKN98BSuSNK4geOMLBYcnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="64003807"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.245.96.163])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 00:02:31 -0700
Message-ID: <f7f66da8-7698-4511-900e-5e73af01517b@intel.com>
Date: Fri, 30 Aug 2024 10:02:25 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/8] x86/virt/tdx: Start to track all global metadata
 in one structure
To: Kai Huang <kai.huang@intel.com>, dave.hansen@intel.com,
 kirill.shutemov@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
 peterz@infradead.org, mingo@redhat.com, hpa@zytor.com,
 dan.j.williams@intel.com, seanjc@google.com, pbonzini@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, isaku.yamahata@intel.com, chao.gao@intel.com,
 binbin.wu@linux.intel.com
References: <cover.1724741926.git.kai.huang@intel.com>
 <994a0df50534c404d1b243a95067860fc296172a.1724741926.git.kai.huang@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <994a0df50534c404d1b243a95067860fc296172a.1724741926.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/08/24 10:14, Kai Huang wrote:
> The TDX module provides a set of "global metadata fields".  They report

Global Metadata Fields

> things like TDX module version, supported features, and fields related
> to create/run TDX guests and so on.
> 
> Currently the kernel only reads "TD Memory Region" (TDMR) related fields
> for module initialization.  There are immediate needs which require the
> TDX module initialization to read more global metadata including module
> version, supported features and "Convertible Memory Regions" (CMRs).
> 
> Also, KVM will need to read more metadata fields to support baseline TDX
> guests.  In the longer term, other TDX features like TDX Connect (which
> supports assigning trusted IO devices to TDX guest) may also require
> other kernel components such as pci/vt-d to access global metadata.
> 
> To meet all those requirements, the idea is the TDX host core-kernel to
> to provide a centralized, canonical, and read-only structure for the
> global metadata that comes out from the TDX module for all kernel
> components to use.
> 
> As the first step, introduce a new 'struct tdx_sys_info' to track all
> global metadata fields.
> 
> TDX categories global metadata fields into different "Class"es.  E.g.,

"Classes"

> the TDMR related fields are under class "TDMR Info".  Instead of making
> 'struct tdx_sys_info' a plain structure to contain all metadata fields,
> organize them in smaller structures based on the "Class".
> 
> This allows those metadata fields to be used in finer granularity thus
> makes the code more clear.  E.g., the construct_tdmr() can just take the
> structure which contains "TDMR Info" metadata fields.
> 
> Add a new function get_tdx_sys_info() as the placeholder to read all
> metadata fields, and call it at the beginning of init_tdx_module().  For
> now it only calls get_tdx_sys_info_tdmr() to read TDMR related fields.
> 
> Note there is a functional change: get_tdx_sys_info_tdmr() is moved from
> after build_tdx_memlist() to before it, but it is fine to do so.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>

Notwithstanding minor cosmetic tweaks:

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
> 
> v2 -> v3:
>  - Split out the part to rename 'struct tdx_tdmr_sysinfo' to 'struct
>    tdx_sys_info_tdmr'.
> 
> 
> ---
>  arch/x86/virt/vmx/tdx/tdx.c | 19 ++++++++++++-------
>  arch/x86/virt/vmx/tdx/tdx.h | 36 +++++++++++++++++++++++++++++-------
>  2 files changed, 41 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 1cd9035c783f..24eb289c80e8 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -318,6 +318,11 @@ static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
>  	return ret;
>  }
>  
> +static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
> +{
> +	return get_tdx_sys_info_tdmr(&sysinfo->tdmr);
> +}
> +
>  /* Calculate the actual TDMR size */
>  static int tdmr_size_single(u16 max_reserved_per_tdmr)
>  {
> @@ -1090,9 +1095,13 @@ static int init_tdmrs(struct tdmr_info_list *tdmr_list)
>  
>  static int init_tdx_module(void)
>  {
> -	struct tdx_sys_info_tdmr sysinfo_tdmr;
> +	struct tdx_sys_info sysinfo;
>  	int ret;
>  
> +	ret = get_tdx_sys_info(&sysinfo);
> +	if (ret)
> +		return ret;
> +
>  	/*
>  	 * To keep things simple, assume that all TDX-protected memory
>  	 * will come from the page allocator.  Make sure all pages in the
> @@ -1109,17 +1118,13 @@ static int init_tdx_module(void)
>  	if (ret)
>  		goto out_put_tdxmem;
>  
> -	ret = get_tdx_sys_info_tdmr(&sysinfo_tdmr);
> -	if (ret)
> -		goto err_free_tdxmem;
> -
>  	/* Allocate enough space for constructing TDMRs */
> -	ret = alloc_tdmr_list(&tdx_tdmr_list, &sysinfo_tdmr);
> +	ret = alloc_tdmr_list(&tdx_tdmr_list, &sysinfo.tdmr);
>  	if (ret)
>  		goto err_free_tdxmem;
>  
>  	/* Cover all TDX-usable memory regions in TDMRs */
> -	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, &sysinfo_tdmr);
> +	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, &sysinfo.tdmr);
>  	if (ret)
>  		goto err_free_tdmrs;
>  
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index 8aabd03d8bf5..4cddbb035b9f 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -100,13 +100,6 @@ struct tdx_memblock {
>  	int nid;
>  };
>  
> -/* "TDMR info" part of "Global Scope Metadata" for constructing TDMRs */
> -struct tdx_sys_info_tdmr {
> -	u16 max_tdmrs;
> -	u16 max_reserved_per_tdmr;
> -	u16 pamt_entry_size[TDX_PS_NR];
> -};
> -
>  /* Warn if kernel has less than TDMR_NR_WARN TDMRs after allocation */
>  #define TDMR_NR_WARN 4
>  
> @@ -119,4 +112,33 @@ struct tdmr_info_list {
>  	int max_tdmrs;	/* How many 'tdmr_info's are allocated */
>  };
>  
> +/*
> + * Kernel-defined structures to contain "Global Scope Metadata".
> + *
> + * TDX global metadata fields are categorized by "Class"es.  See the

"Classes"

> + * "global_metadata.json" in the "TDX 1.5 ABI Definitions".
> + *
> + * 'struct tdx_sys_info' is the main structure to contain all metadata
> + * used by the kernel.  It contains sub-structures with each reflecting
> + * the "Class" in the 'global_metadata.json'.
> + *
> + * Note the structure name may not exactly follow the name of the
> + * "Class" in the TDX spec, but the comment of that structure always
> + * reflect that.
> + *
> + * Also note not all metadata fields in each class are defined, only
> + * those used by the kernel are.
> + */
> +
> +/* Class "TDMR info" */
> +struct tdx_sys_info_tdmr {
> +	u16 max_tdmrs;
> +	u16 max_reserved_per_tdmr;
> +	u16 pamt_entry_size[TDX_PS_NR];
> +};
> +
> +struct tdx_sys_info {
> +	struct tdx_sys_info_tdmr tdmr;
> +};
> +
>  #endif


