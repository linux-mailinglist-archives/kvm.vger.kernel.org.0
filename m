Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A33EE636CFA
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 23:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiKWWRY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 17:17:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKWWRW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 17:17:22 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B247213D4B;
        Wed, 23 Nov 2022 14:17:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669241841; x=1700777841;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=I/BlkC1P7hgj991AnYqsD9bDqASSBCtl+waBVuIqmhQ=;
  b=NF1T7D5A4MeaiUo6VJttbUN8fyQ82MLlzevZtWb3GeTr8Uy6cpgvOuni
   +kOV/RZ89LN1J9uRxveY/jR2528BPVr5afDqy8KHC/uzxReV+O8LpdWST
   k/2+xB25eyOq7CmwGHZ83VZ4wt+TPHkkBs4aRU8sp8DvBBXiDSxWUvQHW
   iS81qNOUlhA61bmNRWAxLdr7CjxldCOATkNjbJHlbaL3tN4cJYH21pxMW
   oRQ/G23YJI0/rrMaaNkggUNM+eIxnjBPVBvJK9AhitCauYSFXVSbGYXi5
   LPIF/VdzjEb8tqSDZOj3EKtriM4ZNe73iVPBNG+CjgmwNGgGWC5jX0Kfj
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="341055931"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="341055931"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 14:17:21 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="592677293"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="592677293"
Received: from vcbudden-mobl3.amr.corp.intel.com (HELO [10.212.129.67]) ([10.212.129.67])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 14:17:20 -0800
Message-ID: <6d4d429a-ade2-771d-0e4c-788bef45041a@intel.com>
Date:   Wed, 23 Nov 2022 14:17:19 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 11/20] x86/virt/tdx: Add placeholder to construct TDMRs
 to cover all TDX memory regions
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
 <32c1968fe34c8cf3cb834e3a9966cd2a201efc5b.1668988357.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <32c1968fe34c8cf3cb834e3a9966cd2a201efc5b.1668988357.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/20/22 16:26, Kai Huang wrote:
> TDX provides increased levels of memory confidentiality and integrity.
> This requires special hardware support for features like memory
> encryption and storage of memory integrity checksums.  Not all memory
> satisfies these requirements.
> 
> As a result, the TDX introduced the concept of a "Convertible Memory

s/the TDX introduced/TDX introduces/

> Region" (CMR).  During boot, the firmware builds a list of all of the
> memory ranges which can provide the TDX security guarantees.  The list
> of these ranges is available to the kernel by querying the TDX module.
> 
> The TDX architecture needs additional metadata to record things like
> which TD guest "owns" a given page of memory.  This metadata essentially
> serves as the 'struct page' for the TDX module.  The space for this
> metadata is not reserved by the hardware up front and must be allocated
> by the kernel and given to the TDX module.
> 
> Since this metadata consumes space, the VMM can choose whether or not to
> allocate it for a given area of convertible memory.  If it chooses not
> to, the memory cannot receive TDX protections and can not be used by TDX
> guests as private memory.
> 
> For every memory region that the VMM wants to use as TDX memory, it sets
> up a "TD Memory Region" (TDMR).  Each TDMR represents a physically
> contiguous convertible range and must also have its own physically
> contiguous metadata table, referred to as a Physical Address Metadata
> Table (PAMT), to track status for each page in the TDMR range.
> 
> Unlike a CMR, each TDMR requires 1G granularity and alignment.  To
> support physical RAM areas that don't meet those strict requirements,
> each TDMR permits a number of internal "reserved areas" which can be
> placed over memory holes.  If PAMT metadata is placed within a TDMR it
> must be covered by one of these reserved areas.
> 
> Let's summarize the concepts:
> 
>  CMR - Firmware-enumerated physical ranges that support TDX.  CMRs are
>        4K aligned.
> TDMR - Physical address range which is chosen by the kernel to support
>        TDX.  1G granularity and alignment required.  Each TDMR has
>        reserved areas where TDX memory holes and overlapping PAMTs can
>        be put into.

s/put into/represented/

> PAMT - Physically contiguous TDX metadata.  One table for each page size
>        per TDMR.  Roughly 1/256th of TDMR in size.  256G TDMR = ~1G
>        PAMT.
> 
> As one step of initializing the TDX module, the kernel configures
> TDX-usable memory regions by passing an array of TDMRs to the TDX module.
> 
> Constructing the array of TDMRs consists below steps:
> 
> 1) Create TDMRs to cover all memory regions that the TDX module can use;

Slight tweak:

1) Create TDMRs to cover all memory regions that the TDX module will use
   for TD memory

The TDX module "uses" more memory than strictly the TMDR's.

> 2) Allocate and set up PAMT for each TDMR;
> 3) Set up reserved areas for each TDMR.

s/Set up/Designate/

> Add a placeholder to construct TDMRs to do the above steps after all
> TDX memory regions are verified to be truly convertible.  Always free
> TDMRs at the end of the initialization (no matter successful or not)
> as TDMRs are only used during the initialization.

The changelog here actually looks really good to me so far.

> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 32af86e31c47..26048c6b0170 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -445,6 +445,63 @@ static int build_tdx_memory(void)
>  	return ret;
>  }
>  
> +/* Calculate the actual TDMR_INFO size */
> +static inline int cal_tdmr_size(void)

I think we can spare the bytes to add "culate" in the function name so
we don't think these are California TDMRs.

> +{
> +	int tdmr_sz;
> +
> +	/*
> +	 * The actual size of TDMR_INFO depends on the maximum number
> +	 * of reserved areas.
> +	 *
> +	 * Note: for TDX1.0 the max_reserved_per_tdmr is 16, and
> +	 * TDMR_INFO size is aligned up to 512-byte.  Even it is
> +	 * extended in the future, it would be insane if TDMR_INFO
> +	 * becomes larger than 4K.  The tdmr_sz here should never
> +	 * overflow.
> +	 */
> +	tdmr_sz = sizeof(struct tdmr_info);
> +	tdmr_sz += sizeof(struct tdmr_reserved_area) *
> +		   tdx_sysinfo.max_reserved_per_tdmr;

First, I think 'tdx_sysinfo' should probably be a local variable in
init_tdx_module() and have its address passed in here.  Having global
variables always makes it more opaque about who is initializing it.

Second, if this code is making assumptions about
'max_reserved_per_tdmr', then let's actually add assertions or sanity
checks.  For instance:

	if (tdx_sysinfo.max_reserved_per_tdmr > MAX_TDMRS)
		return -1;

or even:

	if (tdmr_sz > PAGE_SIZE)
		return -1;

It does almost no good to just assert what the limits are in a comment.

> +	/*
> +	 * TDX requires each TDMR_INFO to be 512-byte aligned.  Always
> +	 * round up TDMR_INFO size to the 512-byte boundary.
> +	 */

<sigh> More silly comments.

The place to document this is TDMR_INFO_ALIGNMENT.  If anyone wants to
know what the alignment is, exactly, they can look at the definition.
They don't need to be told *TWICE* what TDMR_INFO_ALIGNMENT #defines to
in one comment.

> +	return ALIGN(tdmr_sz, TDMR_INFO_ALIGNMENT);
> +}
> +
> +static struct tdmr_info *alloc_tdmr_array(int *array_sz)
> +{
> +	/*
> +	 * TDX requires each TDMR_INFO to be 512-byte aligned.
> +	 * Use alloc_pages_exact() to allocate all TDMRs at once.
> +	 * Each TDMR_INFO will still be 512-byte aligned since
> +	 * cal_tdmr_size() always returns 512-byte aligned size.
> +	 */

OK, I think you're just trolling me now.  Two *MORE* mentions of the
512-byte alignment?

> +	*array_sz = cal_tdmr_size() * tdx_sysinfo.max_tdmrs;
> +
> +	/*
> +	 * Zero the buffer so 'struct tdmr_info::size' can be
> +	 * used to determine whether a TDMR is valid.
> +	 *
> +	 * Note: for TDX1.0 the max_tdmrs is 64 and TDMR_INFO size
> +	 * is 512-byte.  Even they are extended in the future, it
> +	 * would be insane if the total size exceeds 4MB.
> +	 */
> +	return alloc_pages_exact(*array_sz, GFP_KERNEL | __GFP_ZERO);
> +}

This looks massively over complicated.

Get rid of this function entirely.  Then create:

static int tdmr_array_size(void)
{
	return tdmr_size_single() * tdx_sysinfo.max_tdmrs;
}

The *caller* can do:

	tdmr_array = alloc_pages_exact(tdmr_array_size(),
				       GFP_KERNEL | __GFP_ZERO);
	if (!tdmr_array) {
		...

Then the error path is:

	free_pages_exact(tdmr_array, tdmr_array_size());

Then, there are no size pointers going back and forth.  Easy peasy.  I'm
OK with a little arithmetic being repeated.

> +/*
> + * Construct an array of TDMRs to cover all TDX memory ranges.
> + * The actual number of TDMRs is kept to @tdmr_num.
> + */
> +static int construct_tdmrs(struct tdmr_info *tdmr_array, int *tdmr_num)
> +{
> +	/* Return -EINVAL until constructing TDMRs is done */
> +	return -EINVAL;
> +}
> +
>  /*
>   * Detect and initialize the TDX module.
>   *
> @@ -454,6 +511,9 @@ static int build_tdx_memory(void)
>   */
>  static int init_tdx_module(void)
>  {
> +	struct tdmr_info *tdmr_array;
> +	int tdmr_array_sz;
> +	int tdmr_num;

I tend to write these like:

"tdmr_num" is the number of *a* TDMR.

"nr_tdmrs" is the number of TDMRs.

>  	int ret;
>  
>  	/*
> @@ -506,11 +566,34 @@ static int init_tdx_module(void)
>  	ret = build_tdx_memory();
>  	if (ret)
>  		goto out;
> +
> +	/* Prepare enough space to construct TDMRs */
> +	tdmr_array = alloc_tdmr_array(&tdmr_array_sz);
> +	if (!tdmr_array) {
> +		ret = -ENOMEM;
> +		goto out_free_tdx_mem;
> +	}
> +
> +	/* Construct TDMRs to cover all TDX memory ranges */
> +	ret = construct_tdmrs(tdmr_array, &tdmr_num);
> +	if (ret)
> +		goto out_free_tdmrs;
> +
>  	/*
>  	 * Return -EINVAL until all steps of TDX module initialization
>  	 * process are done.
>  	 */
>  	ret = -EINVAL;
> +out_free_tdmrs:
> +	/*
> +	 * The array of TDMRs is freed no matter the initialization is
> +	 * successful or not.  They are not needed anymore after the
> +	 * module initialization.
> +	 */
> +	free_pages_exact(tdmr_array, tdmr_array_sz);
> +out_free_tdx_mem:
> +	if (ret)
> +		free_tdx_memory();
>  out:
>  	/*
>  	 * Memory hotplug checks the hot-added memory region against the
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index 8e273756098c..a737f2b51474 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -80,6 +80,29 @@ struct tdsysinfo_struct {
>  	};
>  } __packed __aligned(TDSYSINFO_STRUCT_ALIGNMENT);
>  
> +struct tdmr_reserved_area {
> +	u64 offset;
> +	u64 size;
> +} __packed;
> +
> +#define TDMR_INFO_ALIGNMENT	512
> +
> +struct tdmr_info {
> +	u64 base;
> +	u64 size;
> +	u64 pamt_1g_base;
> +	u64 pamt_1g_size;
> +	u64 pamt_2m_base;
> +	u64 pamt_2m_size;
> +	u64 pamt_4k_base;
> +	u64 pamt_4k_size;
> +	/*
> +	 * Actual number of reserved areas depends on
> +	 * 'struct tdsysinfo_struct'::max_reserved_per_tdmr.
> +	 */
> +	struct tdmr_reserved_area reserved_areas[0];
> +} __packed __aligned(TDMR_INFO_ALIGNMENT);
> +
>  /*
>   * Do not put any hardware-defined TDX structure representations below
>   * this comment!

