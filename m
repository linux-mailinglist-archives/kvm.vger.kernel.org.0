Return-Path: <kvm+bounces-53226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 43905B0F256
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 14:32:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E22FE3B2BC6
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 12:31:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 485BA2E54DE;
	Wed, 23 Jul 2025 12:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q0yX1OhK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572FAAD2C;
	Wed, 23 Jul 2025 12:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753273928; cv=none; b=nQM+jBP/XEmIKq0xejpjMoHRVJrhGROjsyi+u7AacX1vQYG/G0cI9pjyUBhaurhYGRTSd4ekiXjqDub/GWDy0N0e+cRShPqIHbij3RD0aZyFA4VlOyy6BMk2UaJFY86GcxkpqaJXunxXgUBq1NqTqmnNG0sy8U9hd9A7V6k3P64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753273928; c=relaxed/simple;
	bh=PuDVb05TEXwkaG4hHcD+GTESkqMV8K9TI7PeeWB3oyM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ocCManB1mSm+1KoT4yoWxOaEbuUuP7a6DFHfT/IaqR7iqXDqAtqZlTBeemj/LCcycWgAj5hCrHVlr2x6qXXZSIwgnN8K1zwoWk7Ag3W2EkVvmawfqXXvBqDzcjx2IKdDHietYcmblSmRULr7zSMIYLezC4dsfLGdoKd7LtamZJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q0yX1OhK; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753273926; x=1784809926;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PuDVb05TEXwkaG4hHcD+GTESkqMV8K9TI7PeeWB3oyM=;
  b=Q0yX1OhKnPeZ9maFIqLNOb2HTdoG/B2R9ZyM6WUPm7c7Kr1CDyT1s8/T
   9gAgihmTp6Lqz3yASmXei71G9AJQf2drXQuTo+CRDOoLsHDckoFUZav4+
   +mKNobPzZrEhHF8PzsYxYv6OnYCl2/xzxKR4v9sgdtEp2G3H0EUHqNLGw
   ETtyhoBnl1H57uO7UnFizR6aRPVH42i/swxT5/RjQtQAodaS6/9I3oj1w
   ZR8c4enULzr+bjVRAA212zvTxbGMpglW/QXxuYHMZ2gxX2tyzQqIYK8n8
   +OB7JTEM3XODJn7ZGWVCBv1s13QoU8QkJ9AgOLmM9JbQL3LO2LdEy/G8g
   A==;
X-CSE-ConnectionGUID: YvjJMgPWTMuyUVta6cy6iQ==
X-CSE-MsgGUID: TKphTStARVKz+yRIkP5zpg==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="66985072"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="66985072"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 05:32:06 -0700
X-CSE-ConnectionGUID: g9AIRwxsTcyXzXZmWTLf7A==
X-CSE-MsgGUID: fGBVMDWyR0Kc1gqV2sn6ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="163983783"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 05:31:59 -0700
Message-ID: <a5bb2763-c28a-4b3e-a252-ebc1cd440e0b@intel.com>
Date: Wed, 23 Jul 2025 20:31:55 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 2/2] x86/tdx: Skip clearing reclaimed pages unless
 X86_BUG_TDX_PW_MCE is present
To: Adrian Hunter <adrian.hunter@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, pbonzini@redhat.com,
 seanjc@google.com, vannapurve@google.com
Cc: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 x86@kernel.org, H Peter Anvin <hpa@zytor.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, rick.p.edgecombe@intel.com, kas@kernel.org,
 kai.huang@intel.com, reinette.chatre@intel.com,
 tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com
References: <20250723120539.122752-1-adrian.hunter@intel.com>
 <20250723120539.122752-3-adrian.hunter@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250723120539.122752-3-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/23/2025 8:05 PM, Adrian Hunter wrote:
> Avoid clearing reclaimed TDX private pages unless the platform is affected
> by the X86_BUG_TDX_PW_MCE erratum. This significantly reduces VM shutdown
> time on unaffected systems.
> 
> Background
> 
> KVM currently clears reclaimed TDX private pages using MOVDIR64B, which:
> 
>     - Clears the TD Owner bit (which identifies TDX private memory) and
>       integrity metadata without triggering integrity violations.
>     - Clears poison from cache lines without consuming it, avoiding MCEs on
>       access (refer TDX Module Base spec. 1348549-006US section 6.5.
>       Handling Machine Check Events during Guest TD Operation).
> 
> The TDX module also uses MOVDIR64B to initialize private pages before use.
> If cache flushing is needed, it sets TDX_FEATURES.CLFLUSH_BEFORE_ALLOC.
> However, KVM currently flushes unconditionally, refer commit 94c477a751c7b
> ("x86/virt/tdx: Add SEAMCALL wrappers to add TD private pages")
> 
> In contrast, when private pages are reclaimed, the TDX Module handles
> flushing via the TDH.PHYMEM.CACHE.WB SEAMCALL.
> 
> Problem
> 
> Clearing all private pages during VM shutdown is costly. For guests
> with a large amount of memory it can take minutes.
> 
> Solution
> 
> TDX Module Base Architecture spec. documents that private pages reclaimed
> from a TD should be initialized using MOVDIR64B, in order to avoid
> integrity violation or TD bit mismatch detection when later being read
> using a shared HKID, refer April 2025 spec. "Page Initialization" in
> section "8.6.2. Platforms not Using ACT: Required Cache Flush and
> Initialization by the Host VMM"
> 
> That is an overstatement and will be clarified in coming versions of the
> spec. In fact, as outlined in "Table 16.2: Non-ACT Platforms Checks on
> Memory" and "Table 16.3: Non-ACT Platforms Checks on Memory Reads in Li
> Mode" in the same spec, there is no issue accessing such reclaimed pages
> using a shared key that does not have integrity enabled. Linux always uses
> KeyID 0 which never has integrity enabled. KeyID 0 is also the TME KeyID
> which disallows integrity, refer "TME Policy/Encryption Algorithm" bit
> description in "Intel Architecture Memory Encryption Technologies" spec
> version 1.6 April 2025. So there is no need to clear pages to avoid
> integrity violations.
> 
> There remains a risk of poison consumption. However, in the context of
> TDX, it is expected that there would be a machine check associated with the
> original poisoning. On some platforms that results in a panic. However
> platforms may support "SEAM_NR" Machine Check capability, in which case
> Linux machine check handler marks the page as poisoned, which prevents it
> from being allocated anymore, refer commit 7911f145de5fe ("x86/mce:
> Implement recovery for errors in TDX/SEAM non-root mode")
> 
> Improvement
> 
> By skipping the clearing step on unaffected platforms, shutdown time
> can improve by up to 40%.
> 
> On platforms with the X86_BUG_TDX_PW_MCE erratum (SPR and EMR), continue
> clearing because these platforms may trigger poison on partial writes to
> previously-private pages, even with KeyID 0, refer commit 1e536e1068970
> ("x86/cpu: Detect TDX partial write machine check erratum")
> 
> Reviewed-by: Kirill A. Shutemov <kas@kernel.org>
> Acked-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
> 
> 
> Changes in V4:
> 
> 	Add TDX Module Base spec. version (Rick)
> 	Add Rick's Rev'd-by
> 
> Changes in V3:
> 
> 	Remove "flush cache" comments (Rick)
> 	Update function comment to better relate to "quirk" naming (Rick)
> 	Add "via MOVDIR64B" to comment (Xiaoyao)
> 	Add Rev'd-by, Ack'd-by tags
> 
> Changes in V2:
> 
> 	Improve the comment
> 
> 
>   arch/x86/virt/vmx/tdx/tdx.c | 10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index fc8d8e444f15..ef22fc2b9af0 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -633,15 +633,19 @@ static int tdmrs_set_up_pamt_all(struct tdmr_info_list *tdmr_list,
>   }
>   
>   /*
> - * Convert TDX private pages back to normal by using MOVDIR64B to
> - * clear these pages.  Note this function doesn't flush cache of
> - * these TDX private pages.  The caller should make sure of that.
> + * Convert TDX private pages back to normal by using MOVDIR64B to clear these
> + * pages. Typically, any write to the page will convert it from TDX private back
> + * to normal kernel memory. Systems with the X86_BUG_TDX_PW_MCE erratum need to
> + * do the conversion explicitly via MOVDIR64B.
>    */
>   static void tdx_quirk_reset_paddr(unsigned long base, unsigned long size)
>   {
>   	const void *zero_page = (const void *)page_address(ZERO_PAGE(0));
>   	unsigned long phys, end;
>   
> +	if (!boot_cpu_has_bug(X86_BUG_TDX_PW_MCE))
> +		return;
> +
>   	end = base + size;
>   	for (phys = base; phys < end; phys += 64)
>   		movdir64b(__va(phys), zero_page);


