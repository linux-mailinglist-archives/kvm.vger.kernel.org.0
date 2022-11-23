Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5E9636E7E
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 00:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbiKWXjZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 18:39:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiKWXjX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 18:39:23 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73212DAD39;
        Wed, 23 Nov 2022 15:39:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669246761; x=1700782761;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NbNzIvJel5W7dEOjelcpJ9WyJAs1Bi0d1O8jBfYAwTs=;
  b=nlFFdy7p40A3JnQU53MtMU/YBAwLyF8WGHjHEWJNgwzuwkKgzCpFic+O
   SNJMFiY7eie9CUb5ww9AY+rArbdErTTuK1DmSKGwpq2+L7NskMEspp2uq
   A3n8lKbFw7sN4l+Oq06MMfpOWtS3972wmYSmqc00+Z0h4k2KyuYloM/u+
   YL61atCMcj4Woqz9u/HlEbE32AgHdHPCpFuyXa9V5x4PSMva4tSULvo/W
   yJRTMSUBBSsPieqxLJlzbvZ46Ef6Vs9lAEdmdym3q1Uw0Bu7AXzHvjnZH
   OgOb0TexmLzp1whkKoxXMRug8oIuhrnsgIdDcwkB0qv41P8BcDn0Ro9X3
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="315330094"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="315330094"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 15:39:21 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="674887505"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="674887505"
Received: from vcbudden-mobl3.amr.corp.intel.com (HELO [10.212.129.67]) ([10.212.129.67])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 15:39:20 -0800
Message-ID: <5526fedd-fa54-0ad2-f356-94b167e6e290@intel.com>
Date:   Wed, 23 Nov 2022 15:39:19 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 14/20] x86/virt/tdx: Set up reserved areas for all
 TDMRs
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
 <5a5644e691134dc72c5e3fb0fc22fa40d4aa0b34.1668988357.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <5a5644e691134dc72c5e3fb0fc22fa40d4aa0b34.1668988357.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +static int tdmr_set_up_memory_hole_rsvd_areas(struct tdmr_info *tdmr,
> +					      int *rsvd_idx)
> +{

This needs a comment.

This is another case where it's confusing to be passing around 'struct
tdmr_info *'.  Is this *A* TDMR or an array?


/*
 * Go through tdx_memlist to find holes between memory areas.  If any of
 * those holes fall within @tdmr, set up a TDMR reserved area to cover
 * the hole.
 */
static int tdmr_populate_rsvd_holes(struct list_head *tdx_memlist,
				    struct tdmr_info *tdmr,
				    int *rsvd_idx)

> +	struct tdx_memblock *tmb;
> +	u64 prev_end;
> +	int ret;
> +
> +	/* Mark holes between memory regions as reserved */
> +	prev_end = tdmr_start(tdmr);

I'm having a hard time following this, especially the mixing of
semantics between 'prev_end' both pointing to tdmr and to tmb addresses.

Here, 'prev_end' logically represents the last address which we know has
been handled.  All of the holes in the addresses below it have been
dealt with.  It is safe to set here to tdmr_start() because this
function call is uniquely tasked with setting up reserved areas in
'tdmr'.  So, it can safely consider any holes before tdmr_start(tdmr) as
being handled.

But, dang, there's a lot of complexity there.

First, the:

	/* Mark holes between memory regions as reserved */

comment is misleading.  It has *ZILCH* to do with the "prev_end =
tdmr_start(tdmr);" assignment.

This at least needs:

   /* Start looking for reserved blocks at the beginning of the TDMR: */
   prev_end = tdmr_start(tdmr);

but I also get the feeling that 'prev_end' is a crummy variable name.  I
don't have any better suggestions at the moment.

> +	list_for_each_entry(tmb, &tdx_memlist, list) {
> +		u64 start, end;
> +
> +		start = tmb->start_pfn << PAGE_SHIFT;
> +		end = tmb->end_pfn << PAGE_SHIFT;
> +

More alignment opportunities:

		start = tmb->start_pfn << PAGE_SHIFT;
		end   = tmb->end_pfn   << PAGE_SHIFT;


> +		/* Break if this region is after the TDMR */
> +		if (start >= tdmr_end(tdmr))
> +			break;
> +
> +		/* Exclude regions before this TDMR */
> +		if (end < tdmr_start(tdmr))
> +			continue;
> +
> +		/*
> +		 * Skip if no hole exists before this region. "<=" is
> +		 * used because one memory region might span two TDMRs
> +		 * (when the previous TDMR covers part of this region).
> +		 * In this case the start address of this region is
> +		 * smaller than the start address of the second TDMR.
> +		 *
> +		 * Update the prev_end to the end of this region where
> +		 * the possible memory hole starts.
> +		 */

Can't this just be:

		/*
		 * Skip over memory areas that
		 * have already been dealt with.
		 */

> +		if (start <= prev_end) {
> +			prev_end = end;
> +			continue;
> +		}
> +
> +		/* Add the hole before this region */
> +		ret = tdmr_add_rsvd_area(tdmr, rsvd_idx, prev_end,
> +				start - prev_end);
> +		if (ret)
> +			return ret;
> +
> +		prev_end = end;
> +	}
> +
> +	/* Add the hole after the last region if it exists. */
> +	if (prev_end < tdmr_end(tdmr)) {
> +		ret = tdmr_add_rsvd_area(tdmr, rsvd_idx, prev_end,
> +				tdmr_end(tdmr) - prev_end);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int tdmr_set_up_pamt_rsvd_areas(struct tdmr_info *tdmr, int *rsvd_idx,
> +				       struct tdmr_info *tdmr_array,
> +				       int tdmr_num)
> +{
> +	int i, ret;
> +
> +	/*
> +	 * If any PAMT overlaps with this TDMR, the overlapping part
> +	 * must also be put to the reserved area too.  Walk over all
> +	 * TDMRs to find out those overlapping PAMTs and put them to
> +	 * reserved areas.
> +	 */
> +	for (i = 0; i < tdmr_num; i++) {
> +		struct tdmr_info *tmp = tdmr_array_entry(tdmr_array, i);
> +		unsigned long pamt_start_pfn, pamt_npages;
> +		u64 pamt_start, pamt_end;
> +
> +		tdmr_get_pamt(tmp, &pamt_start_pfn, &pamt_npages);
> +		/* Each TDMR must already have PAMT allocated */
> +		WARN_ON_ONCE(!pamt_npages || !pamt_start_pfn);
> +
> +		pamt_start = pamt_start_pfn << PAGE_SHIFT;
> +		pamt_end = pamt_start + (pamt_npages << PAGE_SHIFT);
> +
> +		/* Skip PAMTs outside of the given TDMR */
> +		if ((pamt_end <= tdmr_start(tdmr)) ||
> +				(pamt_start >= tdmr_end(tdmr)))
> +			continue;
> +
> +		/* Only mark the part within the TDMR as reserved */
> +		if (pamt_start < tdmr_start(tdmr))
> +			pamt_start = tdmr_start(tdmr);
> +		if (pamt_end > tdmr_end(tdmr))
> +			pamt_end = tdmr_end(tdmr);
> +
> +		ret = tdmr_add_rsvd_area(tdmr, rsvd_idx, pamt_start,
> +				pamt_end - pamt_start);
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
> +	/* Reserved areas cannot overlap.  The caller should guarantee. */
> +	WARN_ON_ONCE(1);
> +	return -1;
> +}
> +
> +/* Set up reserved areas for a TDMR, including memory holes and PAMTs */
> +static int tdmr_set_up_rsvd_areas(struct tdmr_info *tdmr,
> +				  struct tdmr_info *tdmr_array,
> +				  int tdmr_num)
> +{
> +	int ret, rsvd_idx = 0;
> +
> +	/* Put all memory holes within the TDMR into reserved areas */
> +	ret = tdmr_set_up_memory_hole_rsvd_areas(tdmr, &rsvd_idx);
> +	if (ret)
> +		return ret;
> +
> +	/* Put all (overlapping) PAMTs within the TDMR into reserved areas */
> +	ret = tdmr_set_up_pamt_rsvd_areas(tdmr, &rsvd_idx, tdmr_array, tdmr_num);
> +	if (ret)
> +		return ret;
> +
> +	/* TDX requires reserved areas listed in address ascending order */
> +	sort(tdmr->reserved_areas, rsvd_idx, sizeof(struct tdmr_reserved_area),
> +			rsvd_area_cmp_func, NULL);

Ugh, and I guess we don't know where the PAMTs will be ordered with
respect to holes, so sorting is the easiest way to do this.

<snip>
