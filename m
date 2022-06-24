Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC7F55A262
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 22:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbiFXUN5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 16:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiFXUN4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 16:13:56 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A66E62C14;
        Fri, 24 Jun 2022 13:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656101635; x=1687637635;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=a/9AYP0CqpJEejZf5BLz9HoLGj03WYq3WJOtUzm0mmg=;
  b=buv7vja3YdD3/912M0xWjlgK39o0EdLvkXl5u4XzqLOSwBdbm4ZPH+h3
   8g/QY4LvdZsiFTBuVBKg1l8lPOoo8Q1unBch8i+WAvEsW71JbOU5iLLcI
   bqRW/aDGyD61v7jwexrdfJ6mmivauY2oEiBcA1M71lFA40LGsWeA5kNc/
   e5Eun6cdamSgbFKVZy3jw6lldMszoI3PzSziHhAMvlXDCmR3UB+fjgv/N
   yiW0Nq1lh7oYlQ3ExQCgaPDLVLliEtsD6kX85CELoxWbw1PlBVWzRroCZ
   rqexsAvWTXOXkh6sBGbZNgbvCxmTMZI6wWMct6n030ksTgUu/NZqYZefV
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10388"; a="279846348"
X-IronPort-AV: E=Sophos;i="5.92,220,1650956400"; 
   d="scan'208";a="279846348"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 13:13:55 -0700
X-IronPort-AV: E=Sophos;i="5.92,220,1650956400"; 
   d="scan'208";a="731454987"
Received: from mdedeogl-mobl.amr.corp.intel.com (HELO [10.209.126.186]) ([10.209.126.186])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 13:13:53 -0700
Message-ID: <e72703b0-767a-ec88-7cb6-f95a3564d823@intel.com>
Date:   Fri, 24 Jun 2022 13:13:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v5 15/22] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
References: <cover.1655894131.git.kai.huang@intel.com>
 <c504a8acd06dc455050c25e2a4cc70aef5eb9358.1655894131.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <c504a8acd06dc455050c25e2a4cc70aef5eb9358.1655894131.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 4988a91d5283..ec496e96d120 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1973,6 +1973,7 @@ config INTEL_TDX_HOST
>  	depends on CPU_SUP_INTEL
>  	depends on X86_64
>  	depends on KVM_INTEL
> +	depends on CONTIG_ALLOC
>  	select ARCH_HAS_CC_PLATFORM
>  	select ARCH_KEEP_MEMBLOCK
>  	help
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index fd9f449b5395..36260dd7e69f 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -558,6 +558,196 @@ static int create_tdmrs(struct tdmr_info *tdmr_array, int *tdmr_num)
>  	return 0;
>  }
>  
> +/* Page sizes supported by TDX */
> +enum tdx_page_sz {
> +	TDX_PG_4K,
> +	TDX_PG_2M,
> +	TDX_PG_1G,
> +	TDX_PG_MAX,
> +};

Are these the same constants as the magic numbers in Kirill's
try_accept_one()?

> +/*
> + * Calculate PAMT size given a TDMR and a page size.  The returned
> + * PAMT size is always aligned up to 4K page boundary.
> + */
> +static unsigned long tdmr_get_pamt_sz(struct tdmr_info *tdmr,
> +				      enum tdx_page_sz pgsz)
> +{
> +	unsigned long pamt_sz;
> +	int pamt_entry_nr;

'nr_pamt_entries', please.

> +	switch (pgsz) {
> +	case TDX_PG_4K:
> +		pamt_entry_nr = tdmr->size >> PAGE_SHIFT;
> +		break;
> +	case TDX_PG_2M:
> +		pamt_entry_nr = tdmr->size >> PMD_SHIFT;
> +		break;
> +	case TDX_PG_1G:
> +		pamt_entry_nr = tdmr->size >> PUD_SHIFT;
> +		break;
> +	default:
> +		WARN_ON_ONCE(1);
> +		return 0;
> +	}
> +
> +	pamt_sz = pamt_entry_nr * tdx_sysinfo.pamt_entry_size;
> +	/* TDX requires PAMT size must be 4K aligned */
> +	pamt_sz = ALIGN(pamt_sz, PAGE_SIZE);
> +
> +	return pamt_sz;
> +}
> +
> +/*
> + * Pick a NUMA node on which to allocate this TDMR's metadata.
> + *
> + * This is imprecise since TDMRs are 1G aligned and NUMA nodes might
> + * not be.  If the TDMR covers more than one node, just use the _first_
> + * one.  This can lead to small areas of off-node metadata for some
> + * memory.
> + */
> +static int tdmr_get_nid(struct tdmr_info *tdmr)
> +{
> +	unsigned long start_pfn, end_pfn;
> +	int i, nid;
> +
> +	/* Find the first memory region covered by the TDMR */
> +	memblock_for_each_tdx_mem_pfn_range(i, &start_pfn, &end_pfn, &nid) {
> +		if (end_pfn > (tdmr_start(tdmr) >> PAGE_SHIFT))
> +			return nid;
> +	}
> +
> +	/*
> +	 * No memory region found for this TDMR.  It cannot happen since
> +	 * when one TDMR is created, it must cover at least one (or
> +	 * partial) memory region.
> +	 */
> +	WARN_ON_ONCE(1);
> +	return 0;
> +}

You should really describe what you are doing.  At first glance "return
0;" looks like "declare success".  How about something like this?

	/*
	 * Fall back to allocating the TDMR from node 0 when no memblock
	 * can be found.  This should never happen since TDMRs originate
	 * from the memblocks.
	 */

Does that miss any of the points you were trying to make?

> +static int tdmr_set_up_pamt(struct tdmr_info *tdmr)
> +{
> +	unsigned long pamt_base[TDX_PG_MAX];
> +	unsigned long pamt_size[TDX_PG_MAX];
> +	unsigned long tdmr_pamt_base;
> +	unsigned long tdmr_pamt_size;
> +	enum tdx_page_sz pgsz;
> +	struct page *pamt;
> +	int nid;
> +
> +	nid = tdmr_get_nid(tdmr);
> +
> +	/*
> +	 * Calculate the PAMT size for each TDX supported page size
> +	 * and the total PAMT size.
> +	 */
> +	tdmr_pamt_size = 0;
> +	for (pgsz = TDX_PG_4K; pgsz < TDX_PG_MAX; pgsz++) {
> +		pamt_size[pgsz] = tdmr_get_pamt_sz(tdmr, pgsz);
> +		tdmr_pamt_size += pamt_size[pgsz];
> +	}
> +
> +	/*
> +	 * Allocate one chunk of physically contiguous memory for all
> +	 * PAMTs.  This helps minimize the PAMT's use of reserved areas
> +	 * in overlapped TDMRs.
> +	 */
> +	pamt = alloc_contig_pages(tdmr_pamt_size >> PAGE_SHIFT, GFP_KERNEL,
> +			nid, &node_online_map);
> +	if (!pamt)
> +		return -ENOMEM;

I'm not sure it's worth mentioning, but this doesn't really need to be
GFP_KERNEL.  __GFP_HIGHMEM would actually be just fine.  But,
considering that this is 64-bit only, that's just a technicality.

> +	/* Calculate PAMT base and size for all supported page sizes. */

That comment isn't doing much good.  If you say anything here it should be:

	/*
	 * Break the contiguous allocation back up into
	 * the individual PAMTs for each page size:
	 */

Also, this is *not* "calculating size".  That's done above.

> +	tdmr_pamt_base = page_to_pfn(pamt) << PAGE_SHIFT;
> +	for (pgsz = TDX_PG_4K; pgsz < TDX_PG_MAX; pgsz++) {
> +		pamt_base[pgsz] = tdmr_pamt_base;
> +		tdmr_pamt_base += pamt_size[pgsz];
> +	}
> +
> +	tdmr->pamt_4k_base = pamt_base[TDX_PG_4K];
> +	tdmr->pamt_4k_size = pamt_size[TDX_PG_4K];
> +	tdmr->pamt_2m_base = pamt_base[TDX_PG_2M];
> +	tdmr->pamt_2m_size = pamt_size[TDX_PG_2M];
> +	tdmr->pamt_1g_base = pamt_base[TDX_PG_1G];
> +	tdmr->pamt_1g_size = pamt_size[TDX_PG_1G];
> +
> +	return 0;
> +}
>
> +static void tdmr_get_pamt(struct tdmr_info *tdmr, unsigned long *pamt_pfn,
> +			  unsigned long *pamt_npages)
> +{
> +	unsigned long pamt_base, pamt_sz;
> +
> +	/*
> +	 * The PAMT was allocated in one contiguous unit.  The 4K PAMT
> +	 * should always point to the beginning of that allocation.
> +	 */
> +	pamt_base = tdmr->pamt_4k_base;
> +	pamt_sz = tdmr->pamt_4k_size + tdmr->pamt_2m_size + tdmr->pamt_1g_size;
> +
> +	*pamt_pfn = pamt_base >> PAGE_SHIFT;
> +	*pamt_npages = pamt_sz >> PAGE_SHIFT;
> +}
> +
> +static void tdmr_free_pamt(struct tdmr_info *tdmr)
> +{
> +	unsigned long pamt_pfn, pamt_npages;
> +
> +	tdmr_get_pamt(tdmr, &pamt_pfn, &pamt_npages);
> +
> +	/* Do nothing if PAMT hasn't been allocated for this TDMR */
> +	if (!pamt_npages)
> +		return;
> +
> +	if (WARN_ON_ONCE(!pamt_pfn))
> +		return;
> +
> +	free_contig_range(pamt_pfn, pamt_npages);
> +}
> +
> +static void tdmrs_free_pamt_all(struct tdmr_info *tdmr_array, int tdmr_num)
> +{
> +	int i;
> +
> +	for (i = 0; i < tdmr_num; i++)
> +		tdmr_free_pamt(tdmr_array_entry(tdmr_array, i));
> +}
> +
> +/* Allocate and set up PAMTs for all TDMRs */
> +static int tdmrs_set_up_pamt_all(struct tdmr_info *tdmr_array, int tdmr_num)
> +{
> +	int i, ret = 0;
> +
> +	for (i = 0; i < tdmr_num; i++) {
> +		ret = tdmr_set_up_pamt(tdmr_array_entry(tdmr_array, i));
> +		if (ret)
> +			goto err;
> +	}
> +
> +	return 0;
> +err:
> +	tdmrs_free_pamt_all(tdmr_array, tdmr_num);
> +	return ret;
> +}
> +
> +static unsigned long tdmrs_get_pamt_pages(struct tdmr_info *tdmr_array,
> +					  int tdmr_num)

"get" is for refcounting.  tdmrs_count_pamt_pages() would be preferable.

> +{
> +	unsigned long pamt_npages = 0;
> +	int i;
> +
> +	for (i = 0; i < tdmr_num; i++) {
> +		unsigned long pfn, npages;
> +
> +		tdmr_get_pamt(tdmr_array_entry(tdmr_array, i), &pfn, &npages);
> +		pamt_npages += npages;
> +	}
> +
> +	return pamt_npages;
> +}
> +
>  /*
>   * Construct an array of TDMRs to cover all memory regions in memblock.
>   * This makes sure all pages managed by the page allocator are TDX
> @@ -572,8 +762,13 @@ static int construct_tdmrs_memeblock(struct tdmr_info *tdmr_array,
>  	if (ret)
>  		goto err;
>  
> +	ret = tdmrs_set_up_pamt_all(tdmr_array, *tdmr_num);
> +	if (ret)
> +		goto err;
> +
>  	/* Return -EINVAL until constructing TDMRs is done */
>  	ret = -EINVAL;
> +	tdmrs_free_pamt_all(tdmr_array, *tdmr_num);
>  err:
>  	return ret;
>  }
> @@ -644,6 +839,11 @@ static int init_tdx_module(void)
>  	 * process are done.
>  	 */
>  	ret = -EINVAL;
> +	if (ret)
> +		tdmrs_free_pamt_all(tdmr_array, tdmr_num);
> +	else
> +		pr_info("%lu pages allocated for PAMT.\n",
> +				tdmrs_get_pamt_pages(tdmr_array, tdmr_num));
>  out_free_tdmrs:
>  	/*
>  	 * The array of TDMRs is freed no matter the initialization is

The rest looks OK.
