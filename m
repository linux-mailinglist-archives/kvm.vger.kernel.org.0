Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 475F966073C
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 20:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235798AbjAFTgf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 14:36:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235745AbjAFTgd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 14:36:33 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C5262F1;
        Fri,  6 Jan 2023 11:36:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673033792; x=1704569792;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JKQwhg3SKN3PwT6OwIBONjP4dNuxovJ0f2FMLC1fPXY=;
  b=D1J740NLI5kA6NVxgZwHuCuAkSghTZ35rLerR1Rx65bZ39t0M103srEH
   r22UMNya9gvorRhMabqPVO9YqUksO/wuAKrjiCsPuT1F6L8yJJqF0lf11
   SIX/gaSfd3SaQQYwr5M4Z+NVoM7S6Z513IK6zI9xwnUAjLuT52FOhi6a9
   ey7+RSo27IJDFQ37DHs9Xyv/Fmqx14E8okwvWKPq+vu8wDoANms8Z3pmC
   cWdFUQ3Ryv70ycSIebMI9Lkelym42y4PphGNJTAIwK//mk6iYm6P6TnxK
   XnQIjt8yq7JxrbBuWn+sq84owFxlfv9lTKQeTBOEZC+KIla8IQpZUpJR4
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="323791777"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="323791777"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 11:36:32 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="686563906"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="686563906"
Received: from xiangyuy-mobl.amr.corp.intel.com (HELO [10.212.251.186]) ([10.212.251.186])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 11:36:31 -0800
Message-ID: <725de6e9-e468-48ef-3bae-1e8a1b7ef0f7@intel.com>
Date:   Fri, 6 Jan 2023 11:36:31 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v8 09/16] x86/virt/tdx: Fill out TDMRs to cover all TDX
 memory regions
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, peterz@infradead.org, tglx@linutronix.de,
        seanjc@google.com, pbonzini@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1670566861.git.kai.huang@intel.com>
 <6f9c0bc1074501fa2431bde73bdea57279bf0085.1670566861.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <6f9c0bc1074501fa2431bde73bdea57279bf0085.1670566861.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/22 22:52, Kai Huang wrote:
> Start to transit out the "multi-steps" to construct a list of "TD Memory
> Regions" (TDMRs) to cover all TDX-usable memory regions.
> 
> The kernel configures TDX-usable memory regions by passing a list of
> TDMRs "TD Memory Regions" (TDMRs) to the TDX module.  Each TDMR contains
> the information of the base/size of a memory region, the base/size of the
> associated Physical Address Metadata Table (PAMT) and a list of reserved
> areas in the region.
> 
> Do the first step to fill out a number of TDMRs to cover all TDX memory
> regions.  To keep it simple, always try to use one TDMR for each memory
> region.  As the first step only set up the base/size for each TDMR.
> 
> Each TDMR must be 1G aligned and the size must be in 1G granularity.
> This implies that one TDMR could cover multiple memory regions.  If a
> memory region spans the 1GB boundary and the former part is already
> covered by the previous TDMR, just use a new TDMR for the remaining
> part.
> 
> TDX only supports a limited number of TDMRs.  Disable TDX if all TDMRs
> are consumed but there is more memory region to cover.

This could probably use some discussion of why it is not being
future-proofed.  Maybe:

	There are fancier things that could be done like trying to merge
	adjacent TDMRs.  This would allow more pathological memory
	layouts to be supported.  But, current systems are not even
	close to exhausting the existing TDMR resources in practice.
	For now, keep it simple.

> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index d36ac72ef299..5b1de0200c6b 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -407,6 +407,90 @@ static void free_tdmr_list(struct tdmr_info_list *tdmr_list)
>  			tdmr_list->max_tdmrs * tdmr_list->tdmr_sz);
>  }
>  
> +/* Get the TDMR from the list at the given index. */
> +static struct tdmr_info *tdmr_entry(struct tdmr_info_list *tdmr_list,
> +				    int idx)
> +{
> +	return (struct tdmr_info *)((unsigned long)tdmr_list->first_tdmr +
> +			tdmr_list->tdmr_sz * idx);
> +}

I think that's more complicated and has more casting than necessary.
This looks nicer:

	int tdmr_info_offset = tdmr_list->tdmr_sz * idx;

	return (void *)tdmr_list->first_tdmr + tdmr_info_offset;

Also, it might even be worth keeping ->first_tdmr as a void*.  It isn't
a real C array and keeping it as void* would keep anyone from doing:

	tdmr_foo = tdmr_list->first_tdmr[foo];

> +#define TDMR_ALIGNMENT		BIT_ULL(30)
> +#define TDMR_PFN_ALIGNMENT	(TDMR_ALIGNMENT >> PAGE_SHIFT)
> +#define TDMR_ALIGN_DOWN(_addr)	ALIGN_DOWN((_addr), TDMR_ALIGNMENT)
> +#define TDMR_ALIGN_UP(_addr)	ALIGN((_addr), TDMR_ALIGNMENT)
> +
> +static inline u64 tdmr_end(struct tdmr_info *tdmr)
> +{
> +	return tdmr->base + tdmr->size;
> +}
> +
> +/*
> + * Take the memory referenced in @tmb_list and populate the
> + * preallocated @tdmr_list, following all the special alignment
> + * and size rules for TDMR.
> + */
> +static int fill_out_tdmrs(struct list_head *tmb_list,
> +			  struct tdmr_info_list *tdmr_list)
> +{
> +	struct tdx_memblock *tmb;
> +	int tdmr_idx = 0;
> +
> +	/*
> +	 * Loop over TDX memory regions and fill out TDMRs to cover them.
> +	 * To keep it simple, always try to use one TDMR to cover one
> +	 * memory region.
> +	 *
> +	 * In practice TDX1.0 supports 64 TDMRs, which is big enough to
> +	 * cover all memory regions in reality if the admin doesn't use
> +	 * 'memmap' to create a bunch of discrete memory regions.  When
> +	 * there's a real problem, enhancement can be done to merge TDMRs
> +	 * to reduce the final number of TDMRs.
> +	 */
> +	list_for_each_entry(tmb, tmb_list, list) {
> +		struct tdmr_info *tdmr = tdmr_entry(tdmr_list, tdmr_idx);
> +		u64 start, end;
> +
> +		start = TDMR_ALIGN_DOWN(PFN_PHYS(tmb->start_pfn));
> +		end   = TDMR_ALIGN_UP(PFN_PHYS(tmb->end_pfn));
> +
> +		/*
> +		 * A valid size indicates the current TDMR has already
> +		 * been filled out to cover the previous memory region(s).
> +		 */
> +		if (tdmr->size) {
> +			/*
> +			 * Loop to the next if the current memory region
> +			 * has already been fully covered.
> +			 */
> +			if (end <= tdmr_end(tdmr))
> +				continue;
> +
> +			/* Otherwise, skip the already covered part. */
> +			if (start < tdmr_end(tdmr))
> +				start = tdmr_end(tdmr);
> +
> +			/*
> +			 * Create a new TDMR to cover the current memory
> +			 * region, or the remaining part of it.
> +			 */
> +			tdmr_idx++;
> +			if (tdmr_idx >= tdmr_list->max_tdmrs)
> +				return -E2BIG;
> +
> +			tdmr = tdmr_entry(tdmr_list, tdmr_idx);
> +		}
> +
> +		tdmr->base = start;
> +		tdmr->size = end - start;
> +	}
> +
> +	/* @tdmr_idx is always the index of last valid TDMR. */
> +	tdmr_list->nr_tdmrs = tdmr_idx + 1;
> +
> +	return 0;
> +}
> +
>  /*
>   * Construct a list of TDMRs on the preallocated space in @tdmr_list
>   * to cover all TDX memory regions in @tmb_list based on the TDX module
> @@ -416,16 +500,23 @@ static int construct_tdmrs(struct list_head *tmb_list,
>  			   struct tdmr_info_list *tdmr_list,
>  			   struct tdsysinfo_struct *sysinfo)
>  {
> +	int ret;
> +
> +	ret = fill_out_tdmrs(tmb_list, tdmr_list);
> +	if (ret)
> +		goto err;
> +
>  	/*
>  	 * TODO:
>  	 *
> -	 *  - Fill out TDMRs to cover all TDX memory regions.
>  	 *  - Allocate and set up PAMTs for each TDMR.
>  	 *  - Designate reserved areas for each TDMR.
>  	 *
>  	 * Return -EINVAL until constructing TDMRs is done
>  	 */
> -	return -EINVAL;
> +	ret = -EINVAL;
> +err:
> +	return ret;
>  }
>  
>  static int init_tdx_module(void)

Otherwise this actually looks fine.
