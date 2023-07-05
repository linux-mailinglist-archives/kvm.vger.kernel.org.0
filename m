Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAF2747C6A
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 07:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjGEF3t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 01:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjGEF3s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 01:29:48 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5C9DE;
        Tue,  4 Jul 2023 22:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688534987; x=1720070987;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AyKcQrliDllULwiD50FRYbNd0YEXrFU3UGNmWEeCtCQ=;
  b=nY7iws/+hz8Yfuup6JdnxlCNICEIzI+4s7EufLTcRvWqSNvlkGpkfai8
   SMfJ8ARlbHeHsrATo+A++GzRK/cOy2ZdugxxC1tKBZijzYhP9jzsD5i2J
   NQ3xHmp3rZDiBk8519kB9uiHvhZ2hSNl3zCmWuXGfUHFErvfBucKAYcPq
   sAsP+0kP6BiG9CCSaaeCDydY3B81Y7WXs+71o5RC+pHSXsMGzXOwH4Wgj
   ++liTfdz2n6GiN3AR1JPEG9gsGTZV/HBj+ps2NWdnNXdL8D6bofEBbk5C
   JoYqofdHOzF/HastATI6X05TE9ZHGJ7Uwfm4cF3tFpQVVqxOSvq4bMwwN
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10761"; a="365819943"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="365819943"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2023 22:29:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10761"; a="719107288"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="719107288"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga002.jf.intel.com with ESMTP; 04 Jul 2023 22:29:39 -0700
Date:   Wed, 5 Jul 2023 13:29:38 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v12 13/22] x86/virt/tdx: Designate reserved areas for all
 TDMRs
Message-ID: <20230705052938.g5igtdcbklfd7bkp@yy-desk-7060>
References: <cover.1687784645.git.kai.huang@intel.com>
 <932971243b1b842a59d3fb2b6506823bd732db18.1687784645.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <932971243b1b842a59d3fb2b6506823bd732db18.1687784645.git.kai.huang@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023 at 02:12:43AM +1200, Kai Huang wrote:
> As the last step of constructing TDMRs, populate reserved areas for all
> TDMRs.  For each TDMR, put all memory holes within this TDMR to the
> reserved areas.  And for all PAMTs which overlap with this TDMR, put
> all the overlapping parts to reserved areas too.

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>
> v11 -> v12:
>  - Code change due to tdmr_get_pamt() change from returning pfn/npages to
>    base/size
>  - Added Kirill's tag
>
> v10 -> v11:
>  - No update
>
> v9 -> v10:
>  - No change.
>
> v8 -> v9:
>  - Added comment around 'tdmr_add_rsvd_area()' to point out it doesn't do
>    optimization to save reserved areas. (Dave).
>
> v7 -> v8: (Dave)
>  - "set_up" -> "populate" in function name change (Dave).
>  - Improved comment suggested by Dave.
>  - Other changes due to 'struct tdmr_info_list'.
>
> v6 -> v7:
>  - No change.
>
> v5 -> v6:
>  - Rebase due to using 'tdx_memblock' instead of memblock.
>  - Split tdmr_set_up_rsvd_areas() into two functions to handle memory
>    hole and PAMT respectively.
>  - Added Isaku's Reviewed-by.
>
>
> ---
>  arch/x86/virt/vmx/tdx/tdx.c | 217 ++++++++++++++++++++++++++++++++++--
>  1 file changed, 209 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index fd5417577f26..2bcace5cb25c 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -25,6 +25,7 @@
>  #include <linux/sizes.h>
>  #include <linux/pfn.h>
>  #include <linux/align.h>
> +#include <linux/sort.h>
>  #include <asm/msr-index.h>
>  #include <asm/msr.h>
>  #include <asm/archrandom.h>
> @@ -634,6 +635,207 @@ static unsigned long tdmrs_count_pamt_kb(struct tdmr_info_list *tdmr_list)
>  	return pamt_size / 1024;
>  }
>
> +static int tdmr_add_rsvd_area(struct tdmr_info *tdmr, int *p_idx, u64 addr,
> +			      u64 size, u16 max_reserved_per_tdmr)
> +{
> +	struct tdmr_reserved_area *rsvd_areas = tdmr->reserved_areas;
> +	int idx = *p_idx;
> +
> +	/* Reserved area must be 4K aligned in offset and size */
> +	if (WARN_ON(addr & ~PAGE_MASK || size & ~PAGE_MASK))
> +		return -EINVAL;
> +
> +	if (idx >= max_reserved_per_tdmr) {
> +		pr_warn("initialization failed: TDMR [0x%llx, 0x%llx): reserved areas exhausted.\n",
> +				tdmr->base, tdmr_end(tdmr));
> +		return -ENOSPC;
> +	}
> +
> +	/*
> +	 * Consume one reserved area per call.  Make no effort to
> +	 * optimize or reduce the number of reserved areas which are
> +	 * consumed by contiguous reserved areas, for instance.
> +	 */
> +	rsvd_areas[idx].offset = addr - tdmr->base;
> +	rsvd_areas[idx].size = size;
> +
> +	*p_idx = idx + 1;
> +
> +	return 0;
> +}
> +
> +/*
> + * Go through @tmb_list to find holes between memory areas.  If any of
> + * those holes fall within @tdmr, set up a TDMR reserved area to cover
> + * the hole.
> + */
> +static int tdmr_populate_rsvd_holes(struct list_head *tmb_list,
> +				    struct tdmr_info *tdmr,
> +				    int *rsvd_idx,
> +				    u16 max_reserved_per_tdmr)
> +{
> +	struct tdx_memblock *tmb;
> +	u64 prev_end;
> +	int ret;
> +
> +	/*
> +	 * Start looking for reserved blocks at the
> +	 * beginning of the TDMR.
> +	 */
> +	prev_end = tdmr->base;
> +	list_for_each_entry(tmb, tmb_list, list) {
> +		u64 start, end;
> +
> +		start = PFN_PHYS(tmb->start_pfn);
> +		end   = PFN_PHYS(tmb->end_pfn);
> +
> +		/* Break if this region is after the TDMR */
> +		if (start >= tdmr_end(tdmr))
> +			break;
> +
> +		/* Exclude regions before this TDMR */
> +		if (end < tdmr->base)
> +			continue;
> +
> +		/*
> +		 * Skip over memory areas that
> +		 * have already been dealt with.
> +		 */
> +		if (start <= prev_end) {
> +			prev_end = end;
> +			continue;
> +		}
> +
> +		/* Add the hole before this region */
> +		ret = tdmr_add_rsvd_area(tdmr, rsvd_idx, prev_end,
> +				start - prev_end,
> +				max_reserved_per_tdmr);
> +		if (ret)
> +			return ret;
> +
> +		prev_end = end;
> +	}
> +
> +	/* Add the hole after the last region if it exists. */
> +	if (prev_end < tdmr_end(tdmr)) {
> +		ret = tdmr_add_rsvd_area(tdmr, rsvd_idx, prev_end,
> +				tdmr_end(tdmr) - prev_end,
> +				max_reserved_per_tdmr);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Go through @tdmr_list to find all PAMTs.  If any of those PAMTs
> + * overlaps with @tdmr, set up a TDMR reserved area to cover the
> + * overlapping part.
> + */
> +static int tdmr_populate_rsvd_pamts(struct tdmr_info_list *tdmr_list,
> +				    struct tdmr_info *tdmr,
> +				    int *rsvd_idx,
> +				    u16 max_reserved_per_tdmr)
> +{
> +	int i, ret;
> +
> +	for (i = 0; i < tdmr_list->nr_consumed_tdmrs; i++) {
> +		struct tdmr_info *tmp = tdmr_entry(tdmr_list, i);
> +		unsigned long pamt_base, pamt_size, pamt_end;
> +
> +		tdmr_get_pamt(tmp, &pamt_base, &pamt_size);
> +		/* Each TDMR must already have PAMT allocated */
> +		WARN_ON_ONCE(!pamt_size|| !pamt_base);
> +
> +		pamt_end = pamt_base + pamt_size;
> +		/* Skip PAMTs outside of the given TDMR */
> +		if ((pamt_end <= tdmr->base) ||
> +				(pamt_base >= tdmr_end(tdmr)))
> +			continue;
> +
> +		/* Only mark the part within the TDMR as reserved */
> +		if (pamt_base < tdmr->base)
> +			pamt_base = tdmr->base;
> +		if (pamt_end > tdmr_end(tdmr))
> +			pamt_end = tdmr_end(tdmr);
> +
> +		ret = tdmr_add_rsvd_area(tdmr, rsvd_idx, pamt_base,
> +				pamt_end - pamt_base,
> +				max_reserved_per_tdmr);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +/* Compare function called by sort() for TDMR reserved areas */
> +static int rsvd_area_cmp_func(const void *a, const void *b)
> +{
> +	struct tdmr_reserved_area *r1 = (struct tdmr_reserved_area *)a;
> +	struct tdmr_reserved_area *r2 = (struct tdmr_reserved_area *)b;
> +
> +	if (r1->offset + r1->size <= r2->offset)
> +		return -1;
> +	if (r1->offset >= r2->offset + r2->size)
> +		return 1;
> +
> +	/* Reserved areas cannot overlap.  The caller must guarantee. */
> +	WARN_ON_ONCE(1);
> +	return -1;
> +}
> +
> +/*
> + * Populate reserved areas for the given @tdmr, including memory holes
> + * (via @tmb_list) and PAMTs (via @tdmr_list).
> + */
> +static int tdmr_populate_rsvd_areas(struct tdmr_info *tdmr,
> +				    struct list_head *tmb_list,
> +				    struct tdmr_info_list *tdmr_list,
> +				    u16 max_reserved_per_tdmr)
> +{
> +	int ret, rsvd_idx = 0;
> +
> +	ret = tdmr_populate_rsvd_holes(tmb_list, tdmr, &rsvd_idx,
> +			max_reserved_per_tdmr);
> +	if (ret)
> +		return ret;
> +
> +	ret = tdmr_populate_rsvd_pamts(tdmr_list, tdmr, &rsvd_idx,
> +			max_reserved_per_tdmr);
> +	if (ret)
> +		return ret;
> +
> +	/* TDX requires reserved areas listed in address ascending order */
> +	sort(tdmr->reserved_areas, rsvd_idx, sizeof(struct tdmr_reserved_area),
> +			rsvd_area_cmp_func, NULL);
> +
> +	return 0;
> +}
> +
> +/*
> + * Populate reserved areas for all TDMRs in @tdmr_list, including memory
> + * holes (via @tmb_list) and PAMTs.
> + */
> +static int tdmrs_populate_rsvd_areas_all(struct tdmr_info_list *tdmr_list,
> +					 struct list_head *tmb_list,
> +					 u16 max_reserved_per_tdmr)
> +{
> +	int i;
> +
> +	for (i = 0; i < tdmr_list->nr_consumed_tdmrs; i++) {
> +		int ret;
> +
> +		ret = tdmr_populate_rsvd_areas(tdmr_entry(tdmr_list, i),
> +				tmb_list, tdmr_list, max_reserved_per_tdmr);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * Construct a list of TDMRs on the preallocated space in @tdmr_list
>   * to cover all TDX memory regions in @tmb_list based on the TDX module
> @@ -653,14 +855,13 @@ static int construct_tdmrs(struct list_head *tmb_list,
>  			sysinfo->pamt_entry_size);
>  	if (ret)
>  		return ret;
> -	/*
> -	 * TODO:
> -	 *
> -	 *  - Designate reserved areas for each TDMR.
> -	 *
> -	 * Return -EINVAL until constructing TDMRs is done
> -	 */
> -	return -EINVAL;
> +
> +	ret = tdmrs_populate_rsvd_areas_all(tdmr_list, tmb_list,
> +			sysinfo->max_reserved_per_tdmr);
> +	if (ret)
> +		tdmrs_free_pamt_all(tdmr_list);
> +
> +	return ret;
>  }
>
>  static int init_tdx_module(void)
> --
> 2.40.1
>
