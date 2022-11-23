Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7B28636D66
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 23:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiKWWmB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 17:42:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiKWWmA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 17:42:00 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541DD922C4;
        Wed, 23 Nov 2022 14:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669243319; x=1700779319;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BpnpEgX2wZ8HmD5N1qRAVq/FSn4sdV6C0PbBh5mJEm8=;
  b=hep6AugMHRVwKzUuiOJ8wwtfIsZxQZEdINYc0qvCp48umZHLdLJOKUQP
   ZSO7/QAs2iYFnjwak1OpzAEF9ELhmDHOqeJQSZQUIIp1tHGWZu1DUgHAV
   wmdtezh6WNmwN5tXVu2xMXwRjtJBW+lMjVQdXIFQg3tF3BcD7+2YVLM9g
   XfNwDp64cRXFcZoTHAWvGa94Lyjqk1n5CdeLq6eb8LZcG4aDD4xwABEHs
   PTI9Zxa7kk3nBqY/TE08SO8413KE1Pn7XfwMcU56vLN7JNj8DybQu9R52
   PO5q4s+9HEnrGbdgHJqTIrsRspP8UtxGS7Ak6cNA/aPVd4jpcm66Xyx70
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="378429807"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="378429807"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 14:41:58 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="971025756"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="971025756"
Received: from vcbudden-mobl3.amr.corp.intel.com (HELO [10.212.129.67]) ([10.212.129.67])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 14:41:56 -0800
Message-ID: <d84ad1d2-83f9-dab5-5639-8d71f382e3ff@intel.com>
Date:   Wed, 23 Nov 2022 14:41:55 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 12/20] x86/virt/tdx: Create TDMRs to cover all TDX
 memory regions
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, peterz@infradead.org, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1668988357.git.kai.huang@intel.com>
 <4db59b4a87f0309c29e61a79892b9fa6645754a8.1668988357.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <4db59b4a87f0309c29e61a79892b9fa6645754a8.1668988357.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/20/22 16:26, Kai Huang wrote:
> The kernel configures TDX-usable memory regions by passing an array of
> "TD Memory Regions" (TDMRs) to the TDX module.  Each TDMR contains the
> information of the base/size of a memory region, the base/size of the
> associated Physical Address Metadata Table (PAMT) and a list of reserved
> areas in the region.
> 
> Create a number of TDMRs to cover all TDX memory regions.  To keep it
> simple, always try to create one TDMR for each memory region.  As the
> first step only set up the base/size for each TDMR.
> 
> Each TDMR must be 1G aligned and the size must be in 1G granularity.
> This implies that one TDMR could cover multiple memory regions.  If a
> memory region spans the 1GB boundary and the former part is already
> covered by the previous TDMR, just create a new TDMR for the remaining
> part.
> 
> TDX only supports a limited number of TDMRs.  Disable TDX if all TDMRs
> are consumed but there is more memory region to cover.

Good changelog.  This patch is doing *one* thing.

>  arch/x86/virt/vmx/tdx/tdx.c | 104 +++++++++++++++++++++++++++++++++++-
>  1 file changed, 103 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 26048c6b0170..57b448de59a0 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -445,6 +445,24 @@ static int build_tdx_memory(void)
>  	return ret;
>  }
>  
> +/* TDMR must be 1gb aligned */
> +#define TDMR_ALIGNMENT		BIT_ULL(30)
> +#define TDMR_PFN_ALIGNMENT	(TDMR_ALIGNMENT >> PAGE_SHIFT)
> +
> +/* Align up and down the address to TDMR boundary */
> +#define TDMR_ALIGN_DOWN(_addr)	ALIGN_DOWN((_addr), TDMR_ALIGNMENT)
> +#define TDMR_ALIGN_UP(_addr)	ALIGN((_addr), TDMR_ALIGNMENT)
> +
> +static inline u64 tdmr_start(struct tdmr_info *tdmr)
> +{
> +	return tdmr->base;
> +}

I'm always skeptical that it's a good idea to take this in code:

	tdmr->base

and make it this:

	tdmr_start(tdmr)

because the helper is *LESS* compact than the open-coded form!  I hope
I'm proven wrong.

> +static inline u64 tdmr_end(struct tdmr_info *tdmr)
> +{
> +	return tdmr->base + tdmr->size;
> +}
> +
>  /* Calculate the actual TDMR_INFO size */
>  static inline int cal_tdmr_size(void)
>  {
> @@ -492,14 +510,98 @@ static struct tdmr_info *alloc_tdmr_array(int *array_sz)
>  	return alloc_pages_exact(*array_sz, GFP_KERNEL | __GFP_ZERO);
>  }
>  
> +static struct tdmr_info *tdmr_array_entry(struct tdmr_info *tdmr_array,
> +					  int idx)
> +{
> +	return (struct tdmr_info *)((unsigned long)tdmr_array +
> +			cal_tdmr_size() * idx);
> +}

FWIW, I think it's probably a bad idea to have 'struct tdmr_info *'
types floating around since:

	tmdr_info_array[0]

works, but:

	tmdr_info_array[1]

will blow up in your face.  It would almost make sense to have

struct tdmr_info_list {
	struct tdmr_info *first_tdmr;
}

and then pass around pointers to the 'struct tdmr_info_list'.  Maybe
that's overkill, but it is kinda silly to call something an array if []
doesn't work on it.

> +/*
> + * Create TDMRs to cover all TDX memory regions.  The actual number
> + * of TDMRs is set to @tdmr_num.
> + */
> +static int create_tdmrs(struct tdmr_info *tdmr_array, int *tdmr_num)
> +{
> +	struct tdx_memblock *tmb;
> +	int tdmr_idx = 0;
> +
> +	/*
> +	 * Loop over TDX memory regions and create TDMRs to cover them.
> +	 * To keep it simple, always try to use one TDMR to cover
> +	 * one memory region.
> +	 */

This seems like it might tend to under-utilize TDMRs.  I'm sure this is
done for simplicity, but is it OK?  Why is it OK?  How are you sure this
won't bite us later?

> +	list_for_each_entry(tmb, &tdx_memlist, list) {
> +		struct tdmr_info *tdmr;
> +		u64 start, end;
> +
> +		tdmr = tdmr_array_entry(tdmr_array, tdmr_idx);
> +		start = TDMR_ALIGN_DOWN(tmb->start_pfn << PAGE_SHIFT);
> +		end = TDMR_ALIGN_UP(tmb->end_pfn << PAGE_SHIFT);

Nit: a little vertical alignment can make this much more readable:

		start = TDMR_ALIGN_DOWN(tmb->start_pfn << PAGE_SHIFT);
		end   = TDMR_ALIGN_UP  (tmb->end_pfn   << PAGE_SHIFT);

> +
> +		/*
> +		 * If the current TDMR's size hasn't been initialized,
> +		 * it is a new TDMR to cover the new memory region.
> +		 * Otherwise, the current TDMR has already covered the
> +		 * previous memory region.  In the latter case, check
> +		 * whether the current memory region has been fully or
> +		 * partially covered by the current TDMR, since TDMR is
> +		 * 1G aligned.
> +		 */

Again, we have a comment over a if() block that describes what the
individual steps in the block do.  *Plus* each individual step is
*ALREADY* commented.  What purpose does this comment serve?

> +		if (tdmr->size) {
> +			/*
> +			 * Loop to the next memory region if the current
> +			 * block has already been fully covered by the
> +			 * current TDMR.
> +			 */
> +			if (end <= tdmr_end(tdmr))
> +				continue;
> +
> +			/*
> +			 * If part of the current memory region has
> +			 * already been covered by the current TDMR,
> +			 * skip the already covered part.
> +			 */
> +			if (start < tdmr_end(tdmr))
> +				start = tdmr_end(tdmr);
> +
> +			/*
> +			 * Create a new TDMR to cover the current memory
> +			 * region, or the remaining part of it.
> +			 */
> +			tdmr_idx++;
> +			if (tdmr_idx >= tdx_sysinfo.max_tdmrs)
> +				return -E2BIG;
> +
> +			tdmr = tdmr_array_entry(tdmr_array, tdmr_idx);
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
> +}

Seems like a positive return value could be the number of populated
TDMRs.  That would get rid of the int* argument.

>  /*
>   * Construct an array of TDMRs to cover all TDX memory ranges.
>   * The actual number of TDMRs is kept to @tdmr_num.
>   */

OK, so something else allocated the 'tdmr_array' and it's being passed
in here to fill it out.  "construct" and "create" are both near synonyms
for "allocate", which isn't even being done here.

We want something here that will make it clear that this function is
taking an already populated list of TDMRs and filling it out.
"fill_tmdrs()" seems like it might be a better choice.

This is also a place where better words can help.  If the function is
called "construct", then there's *ZERO* value in using the same word in
the comment.  Using a word that is a close synonym but that can contrast
it with something different would be really nice, say:

This is also a place where the calling convention can be used to add
clarity.  If you implicitly use a global variable, you have to explain
that.  But, if you pass *in* a variable, it's a lot more clear.

Take this, for instance:

/*
 * Take the memory referenced in @tdx_memlist and populate the
 * preallocated @tmdr_array, following all the special alignment
 * and size rules for TDMR.
 */
static int fill_out_tdmrs(struct list_head *tdx_memlist,
			  struct tdmr_info *tdmr_array)
{
...

That's 100% crystal clear about what's going on.  You know what the
inputs are and the outputs.  You also know why this is even necessary.
It's implied a bit, but it's because TDMRs have special rules about
size/alignment and tdx_memlists do not.

>  static int construct_tdmrs(struct tdmr_info *tdmr_array, int *tdmr_num)
>  {
> +	int ret;
> +
> +	ret = create_tdmrs(tdmr_array, tdmr_num);
> +	if (ret)
> +		goto err;
> +
>  	/* Return -EINVAL until constructing TDMRs is done */
> -	return -EINVAL;
> +	ret = -EINVAL;
> +err:
> +	return ret;
>  }
>  
>  /*

