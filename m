Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C13966096C
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 23:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbjAFWVF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 17:21:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbjAFWVD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 17:21:03 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0404C7DE26;
        Fri,  6 Jan 2023 14:21:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673043663; x=1704579663;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fsHOPPQFiulqGu7o78qgPixVmSbGcMUL81E6/CjfVe4=;
  b=PAEGPmbaz3hq7KEx+K+xpiPe3dvHM1v6r/SLBL3YWaBu5o2YqhogsAWw
   F9o2jfggjQAhXv/7dR6TTD+oXTQPSTZ1gIREwNGbG86392/uZmr76vAs1
   S+PIgWwUvnipPPQAto27AnIPY9Z4h56ZS04c9iKpcC5oQ8Wxcny9o2E10
   HyXbeS6w6OWg/+/GXnEJmuqzc+nsL0VwMPriZCD5PrCDXR5IiHJwx8h7H
   6ARaJQDLYnm3AVZqMn5LgJUu7o0cM8/1YGTXlyuq3Dwk2YN1OGDB3spAh
   +2NTbPxKSI9ZLFkbr/3kDn/40xlSrtwi4Aetx55GOjSerm/9VwsmTAaO+
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="310370554"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="310370554"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 14:21:02 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="606025616"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="606025616"
Received: from xiangyuy-mobl.amr.corp.intel.com (HELO [10.212.251.186]) ([10.212.251.186])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 14:21:01 -0800
Message-ID: <e1a55f50-efc0-5098-1a2d-f0eaa0b51a82@intel.com>
Date:   Fri, 6 Jan 2023 14:21:01 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v8 12/16] x86/virt/tdx: Designate the global KeyID and
 configure the TDX module
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
 <d7b01f396908da796644e58298a34c1f8a140be7.1670566861.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <d7b01f396908da796644e58298a34c1f8a140be7.1670566861.git.kai.huang@intel.com>
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
> After a list of "TD Memory Regions" (TDMRs) has been constructed to
> cover all TDX-usable memory regions, the next step is to pick up a TDX
> private KeyID as the "global KeyID" (which protects, i.e. TDX module's
> metadata), and configure it to the TDX module along with the TDMRs.

For whatever reason, whenever I see "i.e." in a changelog, it's usually
going off the rails.  This is no exception.  Let's also get rid of the
passive voice:

	The next step After constructing a list of "TD Memory Regions"
	(TDMRs) to cover all TDX-usable memory regions is to designate a
	TDX private KeyID as the "global KeyID".  This KeyID is used by
	the TDX module for mapping things like the PAMT and other TDX
	metadata.  This KeyID is passed to the TDX module at the same
	time as the TDMRs.

> To keep things simple, just use the first TDX KeyID as the global KeyID.




> ---
>  arch/x86/virt/vmx/tdx/tdx.c | 41 +++++++++++++++++++++++++++++++++++--
>  arch/x86/virt/vmx/tdx/tdx.h |  2 ++
>  2 files changed, 41 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 620b35e2a61b..ab961443fed5 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -916,6 +916,36 @@ static int construct_tdmrs(struct list_head *tmb_list,
>  	return ret;
>  }
>  
> +static int config_tdx_module(struct tdmr_info_list *tdmr_list, u64 global_keyid)
> +{
> +	u64 *tdmr_pa_array, *p;
> +	size_t array_sz;
> +	int i, ret;
> +
> +	/*
> +	 * TDMRs are passed to the TDX module via an array of physical
> +	 * addresses of each TDMR.  The array itself has alignment
> +	 * requirement.
> +	 */
> +	array_sz = tdmr_list->nr_tdmrs * sizeof(u64) +
> +		TDMR_INFO_PA_ARRAY_ALIGNMENT - 1;

One other way of doing this which might be a wee bit less messy:

	array_sz = roundup_pow_of_two(array_sz);
	if (array_sz < TDMR_INFO_PA_ARRAY_ALIGNMENT)
		array_sz = TDMR_INFO_PA_ARRAY_ALIGNMENT;

Since that keeps 'array_sz' at a power-of-two, then kzalloc() will give
you all the alignment you need, except if the array is too small, in
which case you can just bloat it to the alignment requirement.

This would get rid of the PTR_ALIGN() below too.

Your choice.  What you have works too.

> +	p = kzalloc(array_sz, GFP_KERNEL);
> +	if (!p)
> +		return -ENOMEM;
> +
> +	tdmr_pa_array = PTR_ALIGN(p, TDMR_INFO_PA_ARRAY_ALIGNMENT);
> +	for (i = 0; i < tdmr_list->nr_tdmrs; i++)
> +		tdmr_pa_array[i] = __pa(tdmr_entry(tdmr_list, i));
> +
> +	ret = seamcall(TDH_SYS_CONFIG, __pa(tdmr_pa_array), tdmr_list->nr_tdmrs,
> +				global_keyid, 0, NULL, NULL);
> +
> +	/* Free the array as it is not required anymore. */
> +	kfree(p);
> +
> +	return ret;
> +}
> +
>  static int init_tdx_module(void)
>  {
>  	/*
> @@ -960,17 +990,24 @@ static int init_tdx_module(void)
>  	if (ret)
>  		goto out_free_tdmrs;
>  
> +	/*
> +	 * Use the first private KeyID as the global KeyID, and pass
> +	 * it along with the TDMRs to the TDX module.
> +	 */
> +	ret = config_tdx_module(&tdmr_list, tdx_keyid_start);
> +	if (ret)
> +		goto out_free_pamts;

This is "consuming" tdx_keyid_start.  Does it need to get incremented
since the first guest can't use this KeyID now?

>  	/*
>  	 * TODO:
>  	 *
> -	 *  - Pick up one TDX private KeyID as the global KeyID.
> -	 *  - Configure the TDMRs and the global KeyID to the TDX module.
>  	 *  - Configure the global KeyID on all packages.
>  	 *  - Initialize all TDMRs.
>  	 *
>  	 *  Return error before all steps are done.
>  	 */
>  	ret = -EINVAL;
> +out_free_pamts:
>  	if (ret)
>  		tdmrs_free_pamt_all(&tdmr_list);
>  	else
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index d0c762f1a94c..4d2edd477480 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -20,6 +20,7 @@
>   * TDX module SEAMCALL leaf functions
>   */
>  #define TDH_SYS_INFO		32
> +#define TDH_SYS_CONFIG		45
>  
>  struct cmr_info {
>  	u64	base;
> @@ -96,6 +97,7 @@ struct tdmr_reserved_area {
>  } __packed;
>  
>  #define TDMR_INFO_ALIGNMENT	512
> +#define TDMR_INFO_PA_ARRAY_ALIGNMENT	512
>  
>  struct tdmr_info {
>  	u64 base;

