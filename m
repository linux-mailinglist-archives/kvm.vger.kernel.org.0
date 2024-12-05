Return-Path: <kvm+bounces-33110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 93CEA9E4F06
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 08:58:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A7332833FD
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 07:58:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E56991C3308;
	Thu,  5 Dec 2024 07:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JzNy7hDj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CF61C07C0;
	Thu,  5 Dec 2024 07:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733385478; cv=none; b=D/jbz1ymBm6EQ5X9lsVDO+1cnfbU1iX8T/grbgWgWCcsWlyJKagbuGRSf6Iz7fSZIFyO7xxynUCKJ4D9yoFMS5aWTjVl2IHHHcre0RJhuzVGnEgcXCRK95y7J5IJCWlKRlgj7O0r8U5oJ099WRb3R9/eR4hZ2xHYgbFYZ78YHx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733385478; c=relaxed/simple;
	bh=uSg/bKSfO3eT91O/43MYGhR9yGuKLhFP26XP6tdrvvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ABQpv8q/9fiDhXutFqKuh5WfmYNxtAr0/Q/AVVrKA4U4wtRz7u/0kRaJ7ks0J0ZGGu6fDI7dtGSHztDcMK8PZ9kD+idu6kkDEXML2SjYIEqf4b3S9+gdd5Gi0SKzQIqD93FxzW2qkRh1AJyTBkq/HzUzY1d4hQegiHOGuHjI1y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JzNy7hDj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBE1C4CED1;
	Thu,  5 Dec 2024 07:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733385477;
	bh=uSg/bKSfO3eT91O/43MYGhR9yGuKLhFP26XP6tdrvvU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JzNy7hDj8yY2NKW/uvISgo3NyxjO5tVuz9ugbFYNzkQfy3Jc07JeH3iFdxKdfhbIn
	 Gs/DgdTpri/fG+tYQuzRGCSnAZsUMiTYX0IFB5XsAAS9Q4+iP1SMD9P5lq/pdweH4y
	 xH59t/A4HWQPKx6IXoYrtQGY5va/K9fYZ5c+M7u0T4jY0BudHV5nEELfQIfrTLMnmm
	 6UyC8sSBc38He6D6wSmTiyXbOiPcxIMIuT/hlbZr40n/bhxEegN1wxzTyURvEXXhcT
	 ctNs0wdcfwYa3sys0zSE5LdNI7ekWciGjI2EbYVmf9lpjoZmNsqXxQyP5XmEpeihLJ
	 KK1KmMgaXWcDg==
Date: Thu, 5 Dec 2024 09:57:38 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Kai Huang <kai.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
	dave.hansen@intel.com, kirill.shutemov@linux.intel.com,
	peterz@infradead.org, tony.luck@intel.com, tglx@linutronix.de,
	bp@alien8.de, mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, rafael@kernel.org, david@redhat.com,
	dan.j.williams@intel.com, len.brown@intel.com, ak@linux.intel.com,
	isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
	bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v15 08/23] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Message-ID: <Z1Fc8g47vfpz9EVW@kernel.org>
References: <cover.1699527082.git.kai.huang@intel.com>
 <87e19d1931e33bfaece5b79602cfbd517df891f1.1699527082.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87e19d1931e33bfaece5b79602cfbd517df891f1.1699527082.git.kai.huang@intel.com>

Hi,

I've been auditing for_each_mem_pfn_range() users and it's usage in TDX is
dubious for me.

On Fri, Nov 10, 2023 at 12:55:45AM +1300, Kai Huang wrote:
> 
> As TDX-usable memory is a fixed configuration, take a snapshot of the
> memory configuration from memblocks at the time of module initialization
> (memblocks are modified on memory hotplug).  This snapshot is used to

AFAUI this could happen long after free_initmem() which discards all
memblock data on x86.

> enable TDX support for *this* memory configuration only.  Use a memory
> hotplug notifier to ensure that no other RAM can be added outside of
> this configuration.
 
...

> +/*
> + * Ensure that all memblock memory regions are convertible to TDX
> + * memory.  Once this has been established, stash the memblock
> + * ranges off in a secondary structure because memblock is modified
> + * in memory hotplug while TDX memory regions are fixed.
> + */
> +static int build_tdx_memlist(struct list_head *tmb_list)
> +{
> +	unsigned long start_pfn, end_pfn;
> +	int i, ret;
> +
> +	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {

Unles ARCH_KEEP_MEMBLOCK is defined this won't work after free_initmem()

> +		/*
> +		 * The first 1MB is not reported as TDX convertible memory.
> +		 * Although the first 1MB is always reserved and won't end up
> +		 * to the page allocator, it is still in memblock's memory
> +		 * regions.  Skip them manually to exclude them as TDX memory.
> +		 */
> +		start_pfn = max(start_pfn, PHYS_PFN(SZ_1M));
> +		if (start_pfn >= end_pfn)
> +			continue;
> +
> +		/*
> +		 * Add the memory regions as TDX memory.  The regions in
> +		 * memblock has already guaranteed they are in address
> +		 * ascending order and don't overlap.
> +		 */
> +		ret = add_tdx_memblock(tmb_list, start_pfn, end_pfn);
> +		if (ret)
> +			goto err;
> +	}
> +
> +	return 0;
> +err:
> +	free_tdx_memlist(tmb_list);
> +	return ret;
> +}
> +
>  static int init_tdx_module(void)
>  {
> +	int ret;
> +
> +	/*
> +	 * To keep things simple, assume that all TDX-protected memory
> +	 * will come from the page allocator.  Make sure all pages in the
> +	 * page allocator are TDX-usable memory.
> +	 *
> +	 * Build the list of "TDX-usable" memory regions which cover all
> +	 * pages in the page allocator to guarantee that.  Do it while
> +	 * holding mem_hotplug_lock read-lock as the memory hotplug code
> +	 * path reads the @tdx_memlist to reject any new memory.
> +	 */
> +	get_online_mems();
> +
> +	ret = build_tdx_memlist(&tdx_memlist);
> +	if (ret)
> +		goto out_put_tdxmem;
> +
>  	/*
>  	 * TODO:
>  	 *
> -	 *  - Build the list of TDX-usable memory regions.
>  	 *  - Get TDX module "TD Memory Region" (TDMR) global metadata.
>  	 *  - Construct a list of TDMRs to cover all TDX-usable memory
>  	 *    regions.
> @@ -168,7 +267,14 @@ static int init_tdx_module(void)
>  	 *
>  	 *  Return error before all steps are done.
>  	 */
> -	return -EINVAL;
> +	ret = -EINVAL;
> +out_put_tdxmem:
> +	/*
> +	 * @tdx_memlist is written here and read at memory hotplug time.
> +	 * Lock out memory hotplug code while building it.
> +	 */
> +	put_online_mems();
> +	return ret;
>  }
>  
>  static int __tdx_enable(void)
> @@ -258,6 +364,56 @@ static int __init record_keyid_partitioning(u32 *tdx_keyid_start,
>  	return 0;
>  }
>  
> +static bool is_tdx_memory(unsigned long start_pfn, unsigned long end_pfn)
> +{
> +	struct tdx_memblock *tmb;
> +
> +	/*
> +	 * This check assumes that the start_pfn<->end_pfn range does not
> +	 * cross multiple @tdx_memlist entries.  A single memory online
> +	 * event across multiple memblocks (from which @tdx_memlist
> +	 * entries are derived at the time of module initialization) is
> +	 * not possible.  This is because memory offline/online is done
> +	 * on granularity of 'struct memory_block', and the hotpluggable
> +	 * memory region (one memblock) must be multiple of memory_block.
> +	 */
> +	list_for_each_entry(tmb, &tdx_memlist, list) {
> +		if (start_pfn >= tmb->start_pfn && end_pfn <= tmb->end_pfn)
> +			return true;
> +	}
> +	return false;
> +}
> +
> +static int tdx_memory_notifier(struct notifier_block *nb, unsigned long action,
> +			       void *v)
> +{
> +	struct memory_notify *mn = v;
> +
> +	if (action != MEM_GOING_ONLINE)
> +		return NOTIFY_OK;
> +
> +	/*
> +	 * Empty list means TDX isn't enabled.  Allow any memory
> +	 * to go online.
> +	 */
> +	if (list_empty(&tdx_memlist))
> +		return NOTIFY_OK;
> +
> +	/*
> +	 * The TDX memory configuration is static and can not be
> +	 * changed.  Reject onlining any memory which is outside of
> +	 * the static configuration whether it supports TDX or not.
> +	 */
> +	if (is_tdx_memory(mn->start_pfn, mn->start_pfn + mn->nr_pages))
> +		return NOTIFY_OK;
> +
> +	return NOTIFY_BAD;
> +}
> +
> +static struct notifier_block tdx_memory_nb = {
> +	.notifier_call = tdx_memory_notifier,
> +};
> +
>  static int __init tdx_init(void)
>  {
>  	u32 tdx_keyid_start, nr_tdx_keyids;
> @@ -281,6 +437,13 @@ static int __init tdx_init(void)
>  		return -ENODEV;
>  	}
>  
> +	err = register_memory_notifier(&tdx_memory_nb);
> +	if (err) {
> +		pr_err("initialization failed: register_memory_notifier() failed (%d)\n",
> +				err);
> +		return -ENODEV;
> +	}
> +
>  	/*
>  	 * Just use the first TDX KeyID as the 'global KeyID' and
>  	 * leave the rest for TDX guests.
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index a3c52270df5b..c11e0a7ca664 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -27,4 +27,10 @@ enum tdx_module_status_t {
>  	TDX_MODULE_ERROR
>  };
>  
> +struct tdx_memblock {
> +	struct list_head list;
> +	unsigned long start_pfn;
> +	unsigned long end_pfn;
> +};
> +
>  #endif
> -- 
> 2.41.0
> 

-- 
Sincerely yours,
Mike.

