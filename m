Return-Path: <kvm+bounces-25495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E7E4965F94
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 12:50:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B28ED1F2850E
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 10:50:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65FC3165F05;
	Fri, 30 Aug 2024 10:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gkXtNirF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC93166F28;
	Fri, 30 Aug 2024 10:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725015021; cv=none; b=ltwNeKzDU/NHlMU2A3lLKH4Xd1+fTufipfKtRjP/Ol7jMlMArHW58gAwog5q6u+E2TWsjY8jLqGadxoOiz3ewmtQdPf1jm+LNwS0aF/vBXOgulhSzu+2c/DZuWClkWsSmzJMFAMZXCDGtG/Hiu7DGSPUN8ACBeNuRBwo5t6YEFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725015021; c=relaxed/simple;
	bh=1D5uxIQsk+WoTu2ryhNZDubYo3CCMlZTTdCez9P16yw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BBgEHXCHxsX8OvxGHk+7rDwOZezslUaZuq1nzY6uAim6a2YY4JgZ4T06hu04xPkdqtnpKp+MkurqxrjxTB6iVpu9jGpOii1wiu/8ruRhQLFL52k/y0E6M1gfghJsqaFVelfDsuDKSvK4ojT9tfeABToUkZMSBccnB91HzT7AJdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gkXtNirF; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725015019; x=1756551019;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1D5uxIQsk+WoTu2ryhNZDubYo3CCMlZTTdCez9P16yw=;
  b=gkXtNirFHKPCVSVnBstyqesjbaaESDhHnFilRrAebFq59ry3sp5QpMMa
   XJEzGnItr99tg7UTTe6S0eBsO2BqngZhoFXXOrlHH+BFWPoz7Q7iS/nWl
   r9wMqWKGcqa0WZ9uc0AeJBLJ6rSYJzFYX9NBMF3J7tZzQzHfeYX5TxHRL
   O+SCiDXtCoo+eI/HRsXAIpGnzk1Pct8xwx9hWuZ++Lh6etRpZVngqF++u
   cSzSY7FzuYqiWeV47vmJGx2oszLH7McRJYOJqXWnS50W0ccMBz/3uvTlf
   XyhqwTv7CYY8KqUIiT40Qq2FkETLyA+JPliYrRCxLsEih1EcVq00OEAsH
   A==;
X-CSE-ConnectionGUID: hbvdEGaMRu6qkCRKEl9F2Q==
X-CSE-MsgGUID: OSGDT9+VQqm5LZJULnUKCg==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="35057890"
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="35057890"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 03:50:18 -0700
X-CSE-ConnectionGUID: M1/oNoyoRuWJ1FX26GCWig==
X-CSE-MsgGUID: L4qVWsDVSrGH8ZU0Mwc9qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="94691621"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.245.96.163])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 03:50:12 -0700
Message-ID: <4b30520d-f3fa-4806-9d58-176adb8791a6@intel.com>
Date: Fri, 30 Aug 2024 13:50:06 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/8] x86/virt/tdx: Reduce TDMR's reserved areas by
 using CMRs to find memory holes
To: Kai Huang <kai.huang@intel.com>, dave.hansen@intel.com,
 kirill.shutemov@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
 peterz@infradead.org, mingo@redhat.com, hpa@zytor.com,
 dan.j.williams@intel.com, seanjc@google.com, pbonzini@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, isaku.yamahata@intel.com, chao.gao@intel.com,
 binbin.wu@linux.intel.com
References: <cover.1724741926.git.kai.huang@intel.com>
 <9b55398a1537302fb7135330dba54e79bfabffb1.1724741926.git.kai.huang@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <9b55398a1537302fb7135330dba54e79bfabffb1.1724741926.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/08/24 10:14, Kai Huang wrote:
> A TDX module initialization failure was reported on a Emerald Rapids
> platform:
> 
>   virt/tdx: initialization failed: TDMR [0x0, 0x80000000): reserved areas exhausted.
>   virt/tdx: module initialization failed (-28)
> 
> As part of initializing the TDX module, the kernel informs the TDX
> module of all "TDX-usable memory regions" using an array of TDX defined
> structure "TD Memory Region" (TDMR).  Each TDMR must be in 1GB aligned
> and in 1GB granularity, and all "non-TDX-usable memory holes" within a
> given TDMR must be marked as "reserved areas".  The TDX module reports a
> maximum number of reserved areas that can be supported per TDMR.

The statement:

	... all "non-TDX-usable memory holes" within a
	given TDMR must be marked as "reserved areas".

is not exactly true, which is essentially the basis of this fix.

The relevant requirements are (from the spec):

  Any non-reserved 4KB page within a TDMR must be convertible
  i.e., it must be within a CMR

  Reserved areas within a TDMR need not be within a CMR.

  PAMT areas must not overlap with TDMR non-reserved areas;
  however, they may reside within TDMR reserved areas
  (as long as these are convertible).

> 
> Currently, the kernel finds those "non-TDX-usable memory holes" within a
> given TDMR by walking over a list of "TDX-usable memory regions", which
> essentially reflects the "usable" regions in the e820 table (w/o memory
> hotplug operations precisely, but this is not relevant here).

But including e820 table regions that are not "usable" in the TDMR
reserved areas is not necessary - it is not one of the rules.

What confused me initially was that I did not realize the we already
require that the TDX Module does not touch memory in the TDMR
non-reserved areas not specifically allocated to it.  So it makes no
difference to the TDX Module what the pages that have not been allocated
to it, are used for.

> 
> As shown above, the root cause of this failure is when the kernel tries
> to construct a TDMR to cover address range [0x0, 0x80000000), there
> are too many memory holes within that range and the number of memory
> holes exceeds the maximum number of reserved areas.
> 
> The E820 table of that platform (see [1] below) reflects this: the
> number of memory holes among e820 "usable" entries exceeds 16, which is
> the maximum number of reserved areas TDX module supports in practice.
> 
> === Fix ===
> 
> There are two options to fix this: 1) reduce the number of memory holes
> when constructing a TDMR to save "reserved areas"; 2) reduce the TDMR's
> size to cover fewer memory regions, thus fewer memory holes.

Probably better to try and get rid of this "two options" stuff and focus
on how this is a simple and effective fix.

> 
> Option 1) is possible, and in fact is easier and preferable:
> 
> TDX actually has a concept of "Convertible Memory Regions" (CMRs).  TDX
> reports a list of CMRs that meet TDX's security requirements on memory.
> TDX requires all the "TDX-usable memory regions" that the kernel passes
> to the module via TDMRs, a.k.a, all the "non-reserved regions in TDMRs",
> must be convertible memory.
> 
> In other words, if a memory hole is indeed CMR, then it's not mandatory
> for the kernel to add it to the reserved areas.  By doing so, the number
> of consumed reserved areas can be reduced w/o having any functional
> impact.  The kernel still allocates TDX memory from the page allocator.
> There's no harm if the kernel tells the TDX module some memory regions
> are "TDX-usable" but they will never be allocated by the kernel as TDX
> memory.
> 
> Note this doesn't have any security impact either because the kernel is
> out of TDX's TCB anyway.
> 
> This is feasible because in practice the CMRs just reflect the nature of
> whether the RAM can indeed be used by TDX, thus each CMR tends to be a
> large, uninterrupted range of memory, i.e., unlike the e820 table which
> contains numerous "ACPI *" entries in the first 2G range.  Refer to [2]
> for CMRs reported on the problematic platform using off-tree TDX code.
> 
> So for this particular module initialization failure, the memory holes
> that are within [0x0, 0x80000000) are mostly indeed CMR.  By not adding
> them to the reserved areas, the number of consumed reserved areas for
> the TDMR [0x0, 0x80000000) can be dramatically reduced.
> 
> Option 2) is also theoretically feasible, but it is not desired:
> 
> It requires more complicated logic to handle splitting TDMR into smaller
> ones, which isn't trivial.  There are limitations to splitting TDMR too,
> thus it may not always work: 1) The smallest TDMR is 1GB, and it cannot
> be split any further; 2) This also increases the total number of TDMRs,
> which also has a maximum value limited by the TDX module.
> 
> So, fix this issue by using option 1):
> 
> 1) reading out the CMRs from the TDX module global metadata, and
> 2) changing to find memory holes for a given TDMR based on CMRs, but not
>    based on the list of "TDX-usable memory regions".
> 
> Also dump the CMRs in dmesg.  They are helpful when something goes wrong
> around "constructing the TDMRs and configuring the TDX module with
> them".  Note there are no existing userspace tools that the user can get
> CMRs since they can only be read via SEAMCALL (no CPUID, MSR etc).
> 
> [1] BIOS-E820 table of the problematic platform:
> 
>   BIOS-e820: [mem 0x0000000000000000-0x000000000009efff] usable
>   BIOS-e820: [mem 0x000000000009f000-0x00000000000fffff] reserved
>   BIOS-e820: [mem 0x0000000000100000-0x000000005d168fff] usable
>   BIOS-e820: [mem 0x000000005d169000-0x000000005d22afff] ACPI data
>   BIOS-e820: [mem 0x000000005d22b000-0x000000005d3cefff] usable
>   BIOS-e820: [mem 0x000000005d3cf000-0x000000005d469fff] reserved
>   BIOS-e820: [mem 0x000000005d46a000-0x000000005e5b2fff] usable
>   BIOS-e820: [mem 0x000000005e5b3000-0x000000005e5c2fff] reserved
>   BIOS-e820: [mem 0x000000005e5c3000-0x000000005e5d2fff] usable
>   BIOS-e820: [mem 0x000000005e5d3000-0x000000005e5e4fff] reserved
>   BIOS-e820: [mem 0x000000005e5e5000-0x000000005eb57fff] usable
>   BIOS-e820: [mem 0x000000005eb58000-0x0000000061357fff] ACPI NVS
>   BIOS-e820: [mem 0x0000000061358000-0x000000006172afff] usable
>   BIOS-e820: [mem 0x000000006172b000-0x0000000061794fff] ACPI data
>   BIOS-e820: [mem 0x0000000061795000-0x00000000617fefff] usable
>   BIOS-e820: [mem 0x00000000617ff000-0x0000000061912fff] ACPI data
>   BIOS-e820: [mem 0x0000000061913000-0x0000000061998fff] usable
>   BIOS-e820: [mem 0x0000000061999000-0x00000000619dffff] ACPI data
>   BIOS-e820: [mem 0x00000000619e0000-0x00000000619e1fff] usable
>   BIOS-e820: [mem 0x00000000619e2000-0x00000000619e9fff] reserved
>   BIOS-e820: [mem 0x00000000619ea000-0x0000000061a26fff] usable
>   BIOS-e820: [mem 0x0000000061a27000-0x0000000061baefff] ACPI data
>   BIOS-e820: [mem 0x0000000061baf000-0x00000000623c2fff] usable
>   BIOS-e820: [mem 0x00000000623c3000-0x0000000062471fff] reserved
>   BIOS-e820: [mem 0x0000000062472000-0x0000000062823fff] usable
>   BIOS-e820: [mem 0x0000000062824000-0x0000000063a24fff] reserved
>   BIOS-e820: [mem 0x0000000063a25000-0x0000000063d57fff] usable
>   BIOS-e820: [mem 0x0000000063d58000-0x0000000064157fff] reserved
>   BIOS-e820: [mem 0x0000000064158000-0x0000000064158fff] usable
>   BIOS-e820: [mem 0x0000000064159000-0x0000000064194fff] reserved
>   BIOS-e820: [mem 0x0000000064195000-0x000000006e9cefff] usable
>   BIOS-e820: [mem 0x000000006e9cf000-0x000000006eccefff] reserved
>   BIOS-e820: [mem 0x000000006eccf000-0x000000006f6fefff] ACPI NVS
>   BIOS-e820: [mem 0x000000006f6ff000-0x000000006f7fefff] ACPI data
>   BIOS-e820: [mem 0x000000006f7ff000-0x000000006f7fffff] usable
>   BIOS-e820: [mem 0x000000006f800000-0x000000008fffffff] reserved
>   ......
> 
> [2] Convertible Memory Regions of the problematic platform:
> 
>   virt/tdx: CMR: [0x100000, 0x6f800000)
>   virt/tdx: CMR: [0x100000000, 0x107a000000)
>   virt/tdx: CMR: [0x1080000000, 0x207c000000)
>   virt/tdx: CMR: [0x2080000000, 0x307c000000)
>   virt/tdx: CMR: [0x3080000000, 0x407c000000)
> 
> Fixes: dde3b60d572c9 ("x86/virt/tdx: Designate reserved areas for all TDMRs")
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
> 
> v2 -> v3:
> 
>  - Add the Fixes tag, although this patch depends on previous patches.
>  - CMR_BASE0 -> CMR_BASE(_i), CMR_SIZE0 -> CMR_SIZE(_i) to silence the
>    build-check error.
> 
> v1 -> v2:
>  - Change to walk over CMRs directly to find out memory holes, instead
>    of walking over TDX memory blocks and explicitly check whether a hole
>    is subregion of CMR.  (Chao)
>  - Mention any constant macro definitions in global metadata structures
>    are TDX architectural. (Binbin)
>  - Slightly improve the changelog.
> 
> ---
>  arch/x86/virt/vmx/tdx/tdx.c | 105 ++++++++++++++++++++++++++++++------
>  arch/x86/virt/vmx/tdx/tdx.h |  13 +++++
>  2 files changed, 102 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 0fb673dd43ed..fa335ab1ae92 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -331,6 +331,72 @@ static int get_tdx_sys_info_version(struct tdx_sys_info_version *sysinfo_version
>  	return ret;
>  }
>  
> +/* Update the @sysinfo_cmr->num_cmrs to trim tail empty CMRs */
> +static void trim_empty_tail_cmrs(struct tdx_sys_info_cmr *sysinfo_cmr)
> +{
> +	int i;
> +
> +	for (i = 0; i < sysinfo_cmr->num_cmrs; i++) {
> +		u64 cmr_base = sysinfo_cmr->cmr_base[i];
> +		u64 cmr_size = sysinfo_cmr->cmr_size[i];
> +
> +		if (!cmr_size) {
> +			WARN_ON_ONCE(cmr_base);
> +			break;
> +		}
> +
> +		/* TDX architecture: CMR must be 4KB aligned */
> +		WARN_ON_ONCE(!PAGE_ALIGNED(cmr_base) ||
> +				!PAGE_ALIGNED(cmr_size));
> +	}
> +
> +	sysinfo_cmr->num_cmrs = i;
> +}
> +
> +static int get_tdx_sys_info_cmr(struct tdx_sys_info_cmr *sysinfo_cmr)
> +{
> +	int i, ret = 0;
> +
> +#define TD_SYSINFO_MAP_CMR_INFO(_field_id, _member)	\
> +	TD_SYSINFO_MAP(_field_id, sysinfo_cmr, _member)
> +
> +	TD_SYSINFO_MAP_CMR_INFO(NUM_CMRS, num_cmrs);
> +
> +	if (ret)
> +		return ret;
> +
> +	for (i = 0; i < sysinfo_cmr->num_cmrs; i++) {
> +		TD_SYSINFO_MAP_CMR_INFO(CMR_BASE(i), cmr_base[i]);
> +		TD_SYSINFO_MAP_CMR_INFO(CMR_SIZE(i), cmr_size[i]);
> +	}
> +
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * The TDX module may just report the maximum number of CMRs that
> +	 * TDX architecturally supports as the actual number of CMRs,
> +	 * despite the latter is smaller.  In this case all the tail
> +	 * CMRs will be empty.  Trim them away.
> +	 */
> +	trim_empty_tail_cmrs(sysinfo_cmr);
> +
> +	return 0;
> +}
> +
> +static void print_sys_info_cmr(struct tdx_sys_info_cmr *sysinfo_cmr)
> +{
> +	int i;
> +
> +	for (i = 0; i < sysinfo_cmr->num_cmrs; i++) {
> +		u64 cmr_base = sysinfo_cmr->cmr_base[i];
> +		u64 cmr_size = sysinfo_cmr->cmr_size[i];
> +
> +		pr_info("CMR[%d]: [0x%llx, 0x%llx)\n", i, cmr_base,
> +				cmr_base + cmr_size);
> +	}
> +}
> +
>  static void print_basic_sys_info(struct tdx_sys_info *sysinfo)
>  {
>  	struct tdx_sys_info_features *features = &sysinfo->features;
> @@ -349,6 +415,8 @@ static void print_basic_sys_info(struct tdx_sys_info *sysinfo)
>  			version->major, version->minor,	version->update,
>  			version->internal, version->build_num,
>  			version->build_date, features->tdx_features0);
> +
> +	print_sys_info_cmr(&sysinfo->cmr);
>  }
>  
>  static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
> @@ -379,6 +447,10 @@ static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
>  	if (ret)
>  		return ret;
>  
> +	ret = get_tdx_sys_info_cmr(&sysinfo->cmr);
> +	if (ret)
> +		return ret;
> +
>  	return get_tdx_sys_info_tdmr(&sysinfo->tdmr);
>  }
>  
> @@ -803,29 +875,28 @@ static int tdmr_add_rsvd_area(struct tdmr_info *tdmr, int *p_idx, u64 addr,
>  }
>  
>  /*
> - * Go through @tmb_list to find holes between memory areas.  If any of
> + * Go through all CMRs in @sysinfo_cmr to find memory holes.  If any of
>   * those holes fall within @tdmr, set up a TDMR reserved area to cover
>   * the hole.
>   */
> -static int tdmr_populate_rsvd_holes(struct list_head *tmb_list,
> +static int tdmr_populate_rsvd_holes(struct tdx_sys_info_cmr *sysinfo_cmr,
>  				    struct tdmr_info *tdmr,
>  				    int *rsvd_idx,
>  				    u16 max_reserved_per_tdmr)
>  {
> -	struct tdx_memblock *tmb;
>  	u64 prev_end;
> -	int ret;
> +	int i, ret;
>  
>  	/*
>  	 * Start looking for reserved blocks at the
>  	 * beginning of the TDMR.
>  	 */
>  	prev_end = tdmr->base;
> -	list_for_each_entry(tmb, tmb_list, list) {
> +	for (i = 0; i < sysinfo_cmr->num_cmrs; i++) {
>  		u64 start, end;
>  
> -		start = PFN_PHYS(tmb->start_pfn);
> -		end   = PFN_PHYS(tmb->end_pfn);
> +		start = sysinfo_cmr->cmr_base[i];
> +		end   = start + sysinfo_cmr->cmr_size[i];
>  
>  		/* Break if this region is after the TDMR */
>  		if (start >= tdmr_end(tdmr))
> @@ -926,16 +997,16 @@ static int rsvd_area_cmp_func(const void *a, const void *b)
>  
>  /*
>   * Populate reserved areas for the given @tdmr, including memory holes
> - * (via @tmb_list) and PAMTs (via @tdmr_list).
> + * (via @sysinfo_cmr) and PAMTs (via @tdmr_list).
>   */
>  static int tdmr_populate_rsvd_areas(struct tdmr_info *tdmr,
> -				    struct list_head *tmb_list,
> +				    struct tdx_sys_info_cmr *sysinfo_cmr,
>  				    struct tdmr_info_list *tdmr_list,
>  				    u16 max_reserved_per_tdmr)
>  {
>  	int ret, rsvd_idx = 0;
>  
> -	ret = tdmr_populate_rsvd_holes(tmb_list, tdmr, &rsvd_idx,
> +	ret = tdmr_populate_rsvd_holes(sysinfo_cmr, tdmr, &rsvd_idx,
>  			max_reserved_per_tdmr);
>  	if (ret)
>  		return ret;
> @@ -954,10 +1025,10 @@ static int tdmr_populate_rsvd_areas(struct tdmr_info *tdmr,
>  
>  /*
>   * Populate reserved areas for all TDMRs in @tdmr_list, including memory
> - * holes (via @tmb_list) and PAMTs.
> + * holes (via @sysinfo_cmr) and PAMTs.
>   */
>  static int tdmrs_populate_rsvd_areas_all(struct tdmr_info_list *tdmr_list,
> -					 struct list_head *tmb_list,
> +					 struct tdx_sys_info_cmr *sysinfo_cmr,
>  					 u16 max_reserved_per_tdmr)
>  {
>  	int i;
> @@ -966,7 +1037,7 @@ static int tdmrs_populate_rsvd_areas_all(struct tdmr_info_list *tdmr_list,
>  		int ret;
>  
>  		ret = tdmr_populate_rsvd_areas(tdmr_entry(tdmr_list, i),
> -				tmb_list, tdmr_list, max_reserved_per_tdmr);
> +				sysinfo_cmr, tdmr_list, max_reserved_per_tdmr);
>  		if (ret)
>  			return ret;
>  	}
> @@ -981,7 +1052,8 @@ static int tdmrs_populate_rsvd_areas_all(struct tdmr_info_list *tdmr_list,
>   */
>  static int construct_tdmrs(struct list_head *tmb_list,
>  			   struct tdmr_info_list *tdmr_list,
> -			   struct tdx_sys_info_tdmr *sysinfo_tdmr)
> +			   struct tdx_sys_info_tdmr *sysinfo_tdmr,
> +			   struct tdx_sys_info_cmr *sysinfo_cmr)
>  {
>  	int ret;
>  
> @@ -994,7 +1066,7 @@ static int construct_tdmrs(struct list_head *tmb_list,
>  	if (ret)
>  		return ret;
>  
> -	ret = tdmrs_populate_rsvd_areas_all(tdmr_list, tmb_list,
> +	ret = tdmrs_populate_rsvd_areas_all(tdmr_list, sysinfo_cmr,
>  			sysinfo_tdmr->max_reserved_per_tdmr);
>  	if (ret)
>  		tdmrs_free_pamt_all(tdmr_list);
> @@ -1185,7 +1257,8 @@ static int init_tdx_module(void)
>  		goto err_free_tdxmem;
>  
>  	/* Cover all TDX-usable memory regions in TDMRs */
> -	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, &sysinfo.tdmr);
> +	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, &sysinfo.tdmr,
> +			&sysinfo.cmr);
>  	if (ret)
>  		goto err_free_tdmrs;
>  
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index b422e8517e01..e7bed9e717c7 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -40,6 +40,10 @@
>  #define MD_FIELD_ID_UPDATE_VERSION		0x0800000100000005ULL
>  #define MD_FIELD_ID_INTERNAL_VERSION		0x0800000100000006ULL
>  
> +#define MD_FIELD_ID_NUM_CMRS			0x9000000100000000ULL
> +#define MD_FIELD_ID_CMR_BASE(_i)		(0x9000000300000080ULL + (u16)_i)
> +#define MD_FIELD_ID_CMR_SIZE(_i)		(0x9000000300000100ULL + (u16)_i)
> +
>  #define MD_FIELD_ID_MAX_TDMRS			0x9100000100000008ULL
>  #define MD_FIELD_ID_MAX_RESERVED_PER_TDMR	0x9100000100000009ULL
>  #define MD_FIELD_ID_PAMT_4K_ENTRY_SIZE		0x9100000100000010ULL
> @@ -160,6 +164,14 @@ struct tdx_sys_info_version {
>  	u32 build_date;
>  };
>  
> +/* Class "CMR Info" */
> +#define TDX_MAX_CMRS	32	/* architectural */
> +struct tdx_sys_info_cmr {
> +	u16 num_cmrs;
> +	u64 cmr_base[TDX_MAX_CMRS];
> +	u64 cmr_size[TDX_MAX_CMRS];
> +};
> +
>  /* Class "TDMR info" */
>  struct tdx_sys_info_tdmr {
>  	u16 max_tdmrs;
> @@ -170,6 +182,7 @@ struct tdx_sys_info_tdmr {
>  struct tdx_sys_info {
>  	struct tdx_sys_info_features	features;
>  	struct tdx_sys_info_version	version;
> +	struct tdx_sys_info_cmr		cmr;
>  	struct tdx_sys_info_tdmr	tdmr;
>  };
>  


