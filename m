Return-Path: <kvm+bounces-51553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B82DAF8842
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:45:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D3C5D7A2090
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 06:43:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FDAE262FD5;
	Fri,  4 Jul 2025 06:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dALAezeL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A407261390;
	Fri,  4 Jul 2025 06:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751611493; cv=none; b=FVW/k5b4jlm3Q+X0S+XlMNUKhQTf08XF9Qa8nlZIbfE8mStSio2K32U6Ipy37bhBa5AYBtzUYr9n0/nmqj5OH9PROHQn17zEJ9xKc4LxHmbm1trS7n8rjyGP6lIUEPjsqxox0SlhB82HvnNvNtCNQSZyiGKgyAxhei6RsPn6P9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751611493; c=relaxed/simple;
	bh=8IQ37h5TXXF1C+woobvlhVUbpfhPJ5+C+KPaQxKBjjU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AseA2N+opNVABaCuRaOfxuF4oRf/8uZgQ+KMyDISPl/XcdJzCNRuZFCubR8rgj5iLGWbBW8BWWHPI1A4D1Xylt8nf17HGKdu3N2A7X1FB5/CQehC3ZA0FHafk9OZxYzEh4Mkj/Eb8HaeoZUpIl+/oKGAblxH8xfnyrkgQy5vxpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dALAezeL; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751611492; x=1783147492;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8IQ37h5TXXF1C+woobvlhVUbpfhPJ5+C+KPaQxKBjjU=;
  b=dALAezeLU9sUlO1GRJO5VMq2tjA39Ktw4boPr6YIbeWD083DO89hXNF5
   AuKbMViJPtP5LMmzpH0Q9niay8WqWBGnNBwVPRrc+qW3fmm8YyJ22sCsO
   EyPu9pdpf05w4zPvEp38gy7Ojp6t+PhNWPD4+nGEffJ4SpJEpTGe+n0BN
   sSxibTENULQieaJja3AYp6WKMHB7DhUfB+BZIkPP/lZKksjn4ei19GdUi
   28WpXqaCu5MLcGb5y3SqHW5o/I9xEDAcY/4OXd818XFMQW5kG9T5pj2Vg
   XHBuXItcLYEWpUmNip5yUwUoS/XVYVPKW7+8mYqA3jDK7NmMXy9sFpSLY
   g==;
X-CSE-ConnectionGUID: fiwYUa3ZQfKfPPFST0rBHw==
X-CSE-MsgGUID: Xr7hKNL0T/W2WeU5XR5aGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="65394063"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="65394063"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 23:44:52 -0700
X-CSE-ConnectionGUID: P1iO+7Z7TiSckT655hlnXA==
X-CSE-MsgGUID: vBWrhnhiRROPjP0Dpxd1PQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="158602617"
Received: from qliang3-mobl3.ccr.corp.intel.com (HELO [10.124.240.2]) ([10.124.240.2])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 23:44:47 -0700
Message-ID: <cb995757-55cb-467b-bce9-31245eee0837@linux.intel.com>
Date: Fri, 4 Jul 2025 14:44:44 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 1/2] x86/tdx: Eliminate duplicate code in
 tdx_clear_page()
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, pbonzini@redhat.com,
 seanjc@google.com, vannapurve@google.com, Tony Luck <tony.luck@intel.com>,
 Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, x86@kernel.org, H Peter Anvin
 <hpa@zytor.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, kirill.shutemov@linux.intel.com,
 kai.huang@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, isaku.yamahata@intel.com,
 yan.y.zhao@intel.com, chao.gao@intel.com
References: <20250703153712.155600-1-adrian.hunter@intel.com>
 <20250703153712.155600-2-adrian.hunter@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250703153712.155600-2-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/3/2025 11:37 PM, Adrian Hunter wrote:
> tdx_clear_page() and reset_tdx_pages() duplicate the TDX page clearing
> logic.  Rename reset_tdx_pages() to tdx_quirk_reset_paddr() and use it
> in place of tdx_clear_page().
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>
>
> Changes in V2:
>
> 	Rename reset_tdx_pages() to tdx_quirk_reset_paddr()
> 	Call tdx_quirk_reset_paddr() directly
>
>
>   arch/x86/include/asm/tdx.h  |  2 ++
>   arch/x86/kvm/vmx/tdx.c      | 25 +++----------------------
>   arch/x86/virt/vmx/tdx/tdx.c |  5 +++--
>   3 files changed, 8 insertions(+), 24 deletions(-)
>
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 7ddef3a69866..f66328404724 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -131,6 +131,8 @@ int tdx_guest_keyid_alloc(void);
>   u32 tdx_get_nr_guest_keyids(void);
>   void tdx_guest_keyid_free(unsigned int keyid);
>   
> +void tdx_quirk_reset_paddr(unsigned long base, unsigned long size);
> +
>   struct tdx_td {
>   	/* TD root structure: */
>   	struct page *tdr_page;
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index a08e7055d1db..031e36665757 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -276,25 +276,6 @@ static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
>   	vcpu->cpu = -1;
>   }
>   
> -static void tdx_clear_page(struct page *page)
> -{
> -	const void *zero_page = (const void *) page_to_virt(ZERO_PAGE(0));
> -	void *dest = page_to_virt(page);
> -	unsigned long i;
> -
> -	/*
> -	 * The page could have been poisoned.  MOVDIR64B also clears
> -	 * the poison bit so the kernel can safely use the page again.
> -	 */
> -	for (i = 0; i < PAGE_SIZE; i += 64)
> -		movdir64b(dest + i, zero_page);
> -	/*
> -	 * MOVDIR64B store uses WC buffer.  Prevent following memory reads
> -	 * from seeing potentially poisoned cache.
> -	 */
> -	__mb();
> -}
> -
>   static void tdx_no_vcpus_enter_start(struct kvm *kvm)
>   {
>   	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> @@ -340,7 +321,7 @@ static int tdx_reclaim_page(struct page *page)
>   
>   	r = __tdx_reclaim_page(page);
>   	if (!r)
> -		tdx_clear_page(page);
> +		tdx_quirk_reset_paddr(page_to_phys(page), PAGE_SIZE);
>   	return r;
>   }
>   
> @@ -589,7 +570,7 @@ static void tdx_reclaim_td_control_pages(struct kvm *kvm)
>   		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
>   		return;
>   	}
> -	tdx_clear_page(kvm_tdx->td.tdr_page);
> +	tdx_quirk_reset_paddr(page_to_phys(kvm_tdx->td.tdr_page), PAGE_SIZE);
>   
>   	__free_page(kvm_tdx->td.tdr_page);
>   	kvm_tdx->td.tdr_page = NULL;
> @@ -1689,7 +1670,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
>   		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
>   		return -EIO;
>   	}
> -	tdx_clear_page(page);
> +	tdx_quirk_reset_paddr(page_to_phys(page), PAGE_SIZE);
>   	tdx_unpin(kvm, page);
>   	return 0;
>   }
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index c7a9a087ccaf..14d93ed05bd2 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -637,7 +637,7 @@ static int tdmrs_set_up_pamt_all(struct tdmr_info_list *tdmr_list,
>    * clear these pages.  Note this function doesn't flush cache of
>    * these TDX private pages.  The caller should make sure of that.
>    */
> -static void reset_tdx_pages(unsigned long base, unsigned long size)
> +void tdx_quirk_reset_paddr(unsigned long base, unsigned long size)
>   {
>   	const void *zero_page = (const void *)page_address(ZERO_PAGE(0));
>   	unsigned long phys, end;
> @@ -653,10 +653,11 @@ static void reset_tdx_pages(unsigned long base, unsigned long size)
>   	 */
>   	mb();
>   }
> +EXPORT_SYMBOL_GPL(tdx_quirk_reset_paddr);
>   
>   static void tdmr_reset_pamt(struct tdmr_info *tdmr)
>   {
> -	tdmr_do_pamt_func(tdmr, reset_tdx_pages);
> +	tdmr_do_pamt_func(tdmr, tdx_quirk_reset_paddr);
>   }
>   
>   static void tdmrs_reset_pamt_all(struct tdmr_info_list *tdmr_list)


