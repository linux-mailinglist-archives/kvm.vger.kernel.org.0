Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 686465139A8
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 18:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349931AbiD1QZh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 12:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349926AbiD1QZg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 12:25:36 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B6469739;
        Thu, 28 Apr 2022 09:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651162941; x=1682698941;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iOd+jlxVC3IP0tBf3f5BFvwo71ngtvmSrBimJVft37M=;
  b=eShJXL1YVSf9RcGbjncDqJ2FYtJmCS3cnkidGeX36V12CixqPCmvS4so
   iTaqmqJkX9JbMLnb/tUFVQgcKuaZxQ9NhnuROflNP3Jn4pMCCLjR9Isd4
   flW95duGFffbzRY0NjeRGPzDxaen/MVYrvPFFhqs9Y7xeJj5VapLcSN+6
   liaJ7EQb5dAkfkHb9ujs/NvLW2n98elXbU7efQpFSc0N6ckGVxZWMqmaA
   KV5tcJdt1bMfE0/zbJJfHVKlSl9Kbe70HSxXjAJB50Yk3O1paHk1fBF78
   KXpvRmQxvCjDgEsHDAjfRcN1PXSny3PPW5Yj23XGpi4hOgJ95r7F+Wp7f
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="246898467"
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="246898467"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 09:22:21 -0700
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="559754474"
Received: from mpoursae-mobl2.amr.corp.intel.com (HELO [10.212.0.84]) ([10.212.0.84])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 09:22:20 -0700
Message-ID: <fa4d15d5-4690-9e63-f0c9-af4b58e4325c@intel.com>
Date:   Thu, 28 Apr 2022 09:22:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 12/21] x86/virt/tdx: Create TDMRs to cover all system
 RAM
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
References: <cover.1649219184.git.kai.huang@intel.com>
 <6cc984d5c23e06c9c87b4c7342758b29f8c8c022.1649219184.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <6cc984d5c23e06c9c87b4c7342758b29f8c8c022.1649219184.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/5/22 21:49, Kai Huang wrote:
> The kernel configures TDX usable memory regions to the TDX module via
> an array of "TD Memory Region" (TDMR). 

One bit of language that's repeated in these changelogs that I don't
like is "configure ... to".  I think that's a misuse of the word
configure.  I'd say something more like:

	The kernel configures TDX-usable memory regions by passing an
	array of "TD Memory Regions" (TDMRs) to the TDX module.

Could you please take a look over this series and reword those?

> Each TDMR entry (TDMR_INFO)
> contains the information of the base/size of a memory region, the
> base/size of the associated Physical Address Metadata Table (PAMT) and
> a list of reserved areas in the region.
> 
> Create a number of TDMRs according to the verified e820 RAM entries.
> As the first step only set up the base/size information for each TDMR.
> 
> TDMR must be 1G aligned and the size must be in 1G granularity.  This

 ^ Each

> implies that one TDMR could cover multiple e820 RAM entries.  If a RAM
> entry spans the 1GB boundary and the former part is already covered by
> the previous TDMR, just create a new TDMR for the latter part.
> 
> TDX only supports a limited number of TDMRs (currently 64).  Abort the
> TDMR construction process when the number of TDMRs exceeds this
> limitation.

... and what does this *MEAN*?  Is TDX disabled?  Does it throw away the
RAM?  Does it eat puppies?

>  arch/x86/virt/vmx/tdx/tdx.c | 138 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 138 insertions(+)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 6b0c51aaa7f2..82534e70df96 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -54,6 +54,18 @@
>  		((u32)(((_keyid_part) & 0xffffffffull) + 1))
>  #define TDX_KEYID_NUM(_keyid_part)	((u32)((_keyid_part) >> 32))
>  
> +/* TDMR must be 1gb aligned */
> +#define TDMR_ALIGNMENT		BIT_ULL(30)
> +#define TDMR_PFN_ALIGNMENT	(TDMR_ALIGNMENT >> PAGE_SHIFT)
> +
> +/* Align up and down the address to TDMR boundary */
> +#define TDMR_ALIGN_DOWN(_addr)	ALIGN_DOWN((_addr), TDMR_ALIGNMENT)
> +#define TDMR_ALIGN_UP(_addr)	ALIGN((_addr), TDMR_ALIGNMENT)
> +
> +/* TDMR's start and end address */
> +#define TDMR_START(_tdmr)	((_tdmr)->base)
> +#define TDMR_END(_tdmr)		((_tdmr)->base + (_tdmr)->size)

Make these 'static inline's please.  #defines are only for constants or
things that can't use real functions.

>  /*
>   * TDX module status during initialization
>   */
> @@ -813,6 +825,44 @@ static int e820_check_against_cmrs(void)
>  	return 0;
>  }
>  
> +/* The starting offset of reserved areas within TDMR_INFO */
> +#define TDMR_RSVD_START		64

				^ extra whitespace

> +static struct tdmr_info *__alloc_tdmr(void)
> +{
> +	int tdmr_sz;
> +
> +	/*
> +	 * TDMR_INFO's actual size depends on maximum number of reserved
> +	 * areas that one TDMR supports.
> +	 */
> +	tdmr_sz = TDMR_RSVD_START + tdx_sysinfo.max_reserved_per_tdmr *
> +		sizeof(struct tdmr_reserved_area);

You have a structure for this.  I know this because it's the return type
of the function.  You have TDMR_RSVD_START available via the structure
itself.  So, derive that 64 either via:

	sizeof(struct tdmr_info)

or,

	offsetof(struct tdmr_info, reserved_areas);

Which would make things look like this:

	tdmr_base_sz = sizeof(struct tdmr_info);
	tdmr_reserved_area_sz = sizeof(struct tdmr_reserved_area) *
				tdx_sysinfo.max_reserved_per_tdmr;

	tdmr_sz = tdmr_base_sz + tdmr_reserved_area_sz;

Could you explain why on earth you felt the need for the TDMR_RSVD_START
#define?

> +	/*
> +	 * TDX requires TDMR_INFO to be 512 aligned.  Always align up

Again, 512 what?  512 pages?  512 hippos?

> +	 * TDMR_INFO size to 512 so the memory allocated via kzalloc()
> +	 * can meet the alignment requirement.
> +	 */
> +	tdmr_sz = ALIGN(tdmr_sz, TDMR_INFO_ALIGNMENT);
> +
> +	return kzalloc(tdmr_sz, GFP_KERNEL);
> +}
> +
> +/* Create a new TDMR at given index in the TDMR array */
> +static struct tdmr_info *alloc_tdmr(struct tdmr_info **tdmr_array, int idx)
> +{
> +	struct tdmr_info *tdmr;
> +
> +	if (WARN_ON_ONCE(tdmr_array[idx]))
> +		return NULL;
> +
> +	tdmr = __alloc_tdmr();
> +	tdmr_array[idx] = tdmr;
> +
> +	return tdmr;
> +}
> +
>  static void free_tdmrs(struct tdmr_info **tdmr_array, int tdmr_num)
>  {
>  	int i;
> @@ -826,6 +876,89 @@ static void free_tdmrs(struct tdmr_info **tdmr_array, int tdmr_num)
>  	}
>  }
>  
> +/*
> + * Create TDMRs to cover all RAM entries in e820_table.  The created
> + * TDMRs are saved to @tdmr_array and @tdmr_num is set to the actual
> + * number of TDMRs.  All entries in @tdmr_array must be initially NULL.
> + */
> +static int create_tdmrs(struct tdmr_info **tdmr_array, int *tdmr_num)
> +{
> +	struct tdmr_info *tdmr;
> +	u64 start, end;
> +	int i, tdmr_idx;
> +	int ret = 0;
> +
> +	tdmr_idx = 0;
> +	tdmr = alloc_tdmr(tdmr_array, 0);
> +	if (!tdmr)
> +		return -ENOMEM;
> +	/*
> +	 * Loop over all RAM entries in e820 and create TDMRs to cover
> +	 * them.  To keep it simple, always try to use one TDMR to cover
> +	 * one RAM entry.
> +	 */
> +	e820_for_each_mem(i, start, end) {
> +		start = TDMR_ALIGN_DOWN(start);
> +		end = TDMR_ALIGN_UP(end);
			    ^ vertically align those ='s, please.


> +		/*
> +		 * If the current TDMR's size hasn't been initialized, it
> +		 * is a new allocated TDMR to cover the new RAM entry.
> +		 * Otherwise the current TDMR already covers the previous
> +		 * RAM entry.  In the latter case, check whether the
> +		 * current RAM entry has been fully or partially covered
> +		 * by the current TDMR, since TDMR is 1G aligned.
> +		 */
> +		if (tdmr->size) {
> +			/*
> +			 * Loop to next RAM entry if the current entry
> +			 * is already fully covered by the current TDMR.
> +			 */
> +			if (end <= TDMR_END(tdmr))
> +				continue;

This loop is actually pretty well commented and looks OK.  The
TDMR_END() construct even adds to readability.  *BUT*, the

> +			/*
> +			 * If part of current RAM entry has already been
> +			 * covered by current TDMR, skip the already
> +			 * covered part.
> +			 */
> +			if (start < TDMR_END(tdmr))
> +				start = TDMR_END(tdmr);
> +
> +			/*
> +			 * Create a new TDMR to cover the current RAM
> +			 * entry, or the remaining part of it.
> +			 */
> +			tdmr_idx++;
> +			if (tdmr_idx >= tdx_sysinfo.max_tdmrs) {
> +				ret = -E2BIG;
> +				goto err;
> +			}
> +			tdmr = alloc_tdmr(tdmr_array, tdmr_idx);
> +			if (!tdmr) {
> +				ret = -ENOMEM;
> +				goto err;
> +			}

This is a bit verbose for this loop.  Why not just hide the 'max_tdmrs'
inside the alloc_tdmr() function?  That will make this loop smaller and
easier to read.

> +		}
> +
> +		tdmr->base = start;
> +		tdmr->size = end - start;
> +	}
> +
> +	/* @tdmr_idx is always the index of last valid TDMR. */
> +	*tdmr_num = tdmr_idx + 1;
> +
> +	return 0;
> +err:
> +	/*
> +	 * Clean up already allocated TDMRs in case of error.  @tdmr_idx
> +	 * indicates the last TDMR that wasn't created successfully,
> +	 * therefore only needs to free @tdmr_idx TDMRs.
> +	 */
> +	free_tdmrs(tdmr_array, tdmr_idx);
> +	return ret;
> +}
> +
>  static int construct_tdmrs(struct tdmr_info **tdmr_array, int *tdmr_num)
>  {
>  	int ret;
> @@ -834,8 +967,13 @@ static int construct_tdmrs(struct tdmr_info **tdmr_array, int *tdmr_num)
>  	if (ret)
>  		goto err;
>  
> +	ret = create_tdmrs(tdmr_array, tdmr_num);
> +	if (ret)
> +		goto err;
> +
>  	/* Return -EFAULT until constructing TDMRs is done */
>  	ret = -EFAULT;
> +	free_tdmrs(tdmr_array, *tdmr_num);
>  err:
>  	return ret;
>  }

