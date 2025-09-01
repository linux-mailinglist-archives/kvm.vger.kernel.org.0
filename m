Return-Path: <kvm+bounces-56430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D9829B3DD1D
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 10:55:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C9C967A200E
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 08:54:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 442CD2FE59E;
	Mon,  1 Sep 2025 08:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LtGSlVCJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7452F2FC00E;
	Mon,  1 Sep 2025 08:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756716941; cv=none; b=VZ9Kvh/RF1ExZ7v9Dht/O0drnX5kJqDrWlAm9i7O4/5Dt9mACHooofQrONXWJ3WpGNAaGCPyU12lB3sYg9fh5NKBk/t5tuwZ+GSl35/4uesqTSb6flkcr5s7RVTbT7fm6gxBYv0JS1dLNmP59pBvCok5BNarAeGOSQyveTOle6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756716941; c=relaxed/simple;
	bh=oIT/eYPvDjnY+eHH14NuFzgF/YsjGlD013NrqBgbRFs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XJy1W4OorT35qUNU/y/UJNk3Y9bdmlI6eFRLG/bRFPe1fA/MR+DW9jMkIchYI9oVqvJq/1HCYKFJwc0pRICTVmZpsWYgdtEPFXLTRDOHqPIDGcxiVJh52GGn+Bvq/MEluxSEOtBFKBzvbqWdXUbjLszIpGihAqklQoK5SZ9JHh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LtGSlVCJ; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756716939; x=1788252939;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=oIT/eYPvDjnY+eHH14NuFzgF/YsjGlD013NrqBgbRFs=;
  b=LtGSlVCJN1auyRMTIOmXXXKnMraYCQsBASjH8I38PuqnJJuzODOtfUcg
   amj3IWRdVXlAmLTrQICvWKFgb1qTkEQL+tWuUte8wXnTXp8oE0Au4ZJvH
   YowSkdJRFvjF32v2dj9m6udW1iSMQnC9xyTvDVP917Iu0Ajwu8ierFfzP
   8kabNDW2mDFovScvSrSDF45YKR1qSekdgDBPOXFrgwrLUaLhlgE5jKNmB
   arO/exAqtfd4XOEO9wDLWbZ06OLsy1CHYbhlGDgRlB71lJOZqbx0AvMFI
   n1K3CKSIhDMPy2kbeqpht9fttA2UqU/k8GpPIjccQnS2VRnoE4kwpMm2h
   A==;
X-CSE-ConnectionGUID: LYJuO2M4QVGRTFoE2AWqLg==
X-CSE-MsgGUID: wC0X1+KFS260g8E7ScpCAw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62800649"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62800649"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 01:55:39 -0700
X-CSE-ConnectionGUID: urilBq50To6FhMMohnQLog==
X-CSE-MsgGUID: pZk/wlNJRdyHMqc/jK/2+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="175332922"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 01:55:33 -0700
Message-ID: <281ae89b-9fc3-4a9b-87f6-26d2a96cde49@linux.intel.com>
Date: Mon, 1 Sep 2025 16:55:30 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 02/23] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com,
 dave.hansen@intel.com, kas@kernel.org, tabba@google.com,
 ackerleytng@google.com, quic_eberman@quicinc.com, michael.roth@amd.com,
 david@redhat.com, vannapurve@google.com, vbabka@suse.cz,
 thomas.lendacky@amd.com, pgonda@google.com, zhiquan1.li@intel.com,
 fan.du@intel.com, jun.miao@intel.com, ira.weiny@intel.com,
 isaku.yamahata@intel.com, xiaoyao.li@intel.com, chao.p.peng@intel.com
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094149.4467-1-yan.y.zhao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250807094149.4467-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/7/2025 5:41 PM, Yan Zhao wrote:
> From: Xiaoyao Li <xiaoyao.li@intel.com>
>
> Introduce SEAMCALL wrapper tdh_mem_page_demote() to invoke the SEAMCALL
> TDH_MEM_PAGE_DEMOTE, which demotes a huge leaf entry to a non-leaf entry
> in the S-EPT.
>
> SEAMCALL TDH_MEM_PAGE_DEMOTE supports the demotion of 2MB or 1GB huge leaf
> entries.
>
> The "gpa" and "level" parameters enable the SEAMCALL TDH_MEM_PAGE_DEMOTE to
> walk the S-EPT for the huge leaf entry that needs to be demoted.
>
> The "page" parameter specifies a 4KB page that will be used in the demotion
> operation to be added as a page table page in the S-EPT.
>
> Invoke tdx_clflush_page() on the 4KB page being added as a page table page.
> This function performs CLFLUSH operations on certain TDX-capable platforms,
> or conservatively on all TDX-capable platforms, to prevent dirty cache
> lines from writing back later and corrupting TD memory.
>
> tdh_mem_page_demote() may fail. Callers can check function return value and
> retrieve extended error info from the function output parameters "ext_err1"
> and "ext_err2". e.g., due to S-EPT walk error or arriving interrupts.
>
> The TDX module has many internal locks. To avoid staying in SEAM mode for
> too long, SEAMCALLs return a BUSY error code to the kernel instead of
> spinning on the locks. Depending on the specific SEAMCALL, the caller may
> need to handle this error in specific ways (e.g., retry). Therefore, return
> the SEAMCALL error code directly to the caller without attempting to handle
> it in the core kernel.
>
> Do not handle TDX_INTERRUPTED_RESTARTABLE because SEAMCALL
> TDH_MEM_PAGE_DEMOTE does not check interrupts (including NMIs) for basic
> TDX (with or without Dynamic PAMT).

The cover letter mentions that there is a new TDX module in planning, which
disables the interrupt checking. I guess TDX module would need to have a
interface to report the change, KVM then decides to enable huge page support or
not for TDs?

>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
> RFC v2:
> - Refine the patch log (Rick).
> - Do not handle TDX_INTERRUPTED_RESTARTABLE as the new TDX modules in
>    planning do not check interrupts for basic TDX.
>
> RFC v1:
> - Rebased and split patch. Updated patch log.
> ---
>   arch/x86/include/asm/tdx.h  |  2 ++
>   arch/x86/virt/vmx/tdx/tdx.c | 20 ++++++++++++++++++++
>   arch/x86/virt/vmx/tdx/tdx.h |  1 +
>   3 files changed, 23 insertions(+)
>
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index f968b736871a..d2cf48e273d5 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -178,6 +178,8 @@ u64 tdh_mng_key_config(struct tdx_td *td);
>   u64 tdh_mng_create(struct tdx_td *td, u16 hkid);
>   u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
>   u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data);
> +u64 tdh_mem_page_demote(struct tdx_td *td, u64 gpa, int level, struct page *page,
> +			u64 *ext_err1, u64 *ext_err2);
>   u64 tdh_mr_extend(struct tdx_td *td, u64 gpa, u64 *ext_err1, u64 *ext_err2);
>   u64 tdh_mr_finalize(struct tdx_td *td);
>   u64 tdh_vp_flush(struct tdx_vp *vp);
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 580f14f64822..d941f083f741 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -1825,6 +1825,26 @@ u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data)
>   }
>   EXPORT_SYMBOL_GPL(tdh_mng_rd);
>   
> +u64 tdh_mem_page_demote(struct tdx_td *td, u64 gpa, int level, struct page *page,

Nit: Is it better to use a var name that clearly tell that the page is used as a
table page?

> +			u64 *ext_err1, u64 *ext_err2)
> +{
> +	struct tdx_module_args args = {
> +		.rcx = gpa | level,
> +		.rdx = tdx_tdr_pa(td),
> +		.r8 = page_to_phys(page),
> +	};
> +	u64 ret;
> +
> +	tdx_clflush_page(page);
> +	ret = seamcall_ret(TDH_MEM_PAGE_DEMOTE, &args);
> +
> +	*ext_err1 = args.rcx;
> +	*ext_err2 = args.rdx;
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(tdh_mem_page_demote);
> +
>   u64 tdh_mr_extend(struct tdx_td *td, u64 gpa, u64 *ext_err1, u64 *ext_err2)
>   {
>   	struct tdx_module_args args = {
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index 096c78a1d438..a6c0fa53ece9 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -24,6 +24,7 @@
>   #define TDH_MNG_KEY_CONFIG		8
>   #define TDH_MNG_CREATE			9
>   #define TDH_MNG_RD			11
> +#define TDH_MEM_PAGE_DEMOTE		15
>   #define TDH_MR_EXTEND			16
>   #define TDH_MR_FINALIZE			17
>   #define TDH_VP_FLUSH			18


