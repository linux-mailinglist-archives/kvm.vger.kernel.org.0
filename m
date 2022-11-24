Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D17C636F0C
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 01:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiKXAmW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 19:42:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiKXAmV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 19:42:21 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE845B70CF;
        Wed, 23 Nov 2022 16:42:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669250540; x=1700786540;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rwf2kOewvRWuB3KO93AmVzqlch5DrL4wzyL2Tt+r8ro=;
  b=kxQYCIqiehVuVh9xDHn81PuJos+FokHxv/1iiORLYeyUdIvSHB1MTEb5
   S1VT25Ja6a+wjpfcBmNdUgKKmHv5TlrEJsP6ECmUeM9VASIWCmxXhYpqy
   Z4BCcHajOQkG3I5QIX3pRbt8W+0gIdF5k5NK3zLKtpgNqHarmUaAtt9yb
   UCCwxiU47t4stWFIfyklqROPYJ+V/x/1lp2cZNTU0dcIhdLAOJ8QxlLR/
   xZVkqzfPnIgD52AH13OQkWiMmIil89ZnSD3Vkj5O/jrmuRmUpHffqbxNz
   ed5rfVm6GG7Z/WyBUcQ+Qs+vP5CZ1GxO0QH6T0gSnriqVQVVc6g6QTABx
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="341074056"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="341074056"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 16:42:20 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="784436506"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="784436506"
Received: from vcbudden-mobl3.amr.corp.intel.com (HELO [10.212.129.67]) ([10.212.129.67])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 16:42:19 -0800
Message-ID: <4e19a7e1-9088-21d6-d521-a76c340d8179@intel.com>
Date:   Wed, 23 Nov 2022 16:42:17 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 18/20] x86/virt/tdx: Initialize all TDMRs
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
 <2337c8e9086a006aaa2c4b99caf478420d1fc640.1668988357.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <2337c8e9086a006aaa2c4b99caf478420d1fc640.1668988357.git.kai.huang@intel.com>
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
> Initialize TDMRs via TDH.SYS.TDMR.INIT as the last step to complete the
> TDX initialization.
> 
> All TDMRs need to be initialized using TDH.SYS.TDMR.INIT SEAMCALL before
> the memory pages can be used by the TDX module.  The time to initialize
> TDMR is proportional to the size of the TDMR because TDH.SYS.TDMR.INIT
> internally initializes the PAMT entries using the global KeyID.
> 
> To avoid long latency caused in one SEAMCALL, TDH.SYS.TDMR.INIT only
> initializes an (implementation-specific) subset of PAMT entries of one
> TDMR in one invocation.  The caller needs to call TDH.SYS.TDMR.INIT
> iteratively until all PAMT entries of the given TDMR are initialized.
> 
> TDH.SYS.TDMR.INITs can run concurrently on multiple CPUs as long as they
> are initializing different TDMRs.  To keep it simple, just initialize
> all TDMRs one by one.  On a 2-socket machine with 2.2G CPUs and 64GB
> memory, each TDH.SYS.TDMR.INIT roughly takes couple of microseconds on
> average, and it takes roughly dozens of milliseconds to complete the
> initialization of all TDMRs while system is idle.

Any chance you could say TDH.SYS.TDMR.INIT a few more times in there? ;)

Seriously, please try to trim that down.  If you talk about the
implementation in detail in the code comments, don't cover it in detail
in the changelog too.

Also, this is a momentous patch, right?  It's the last piece.  Maybe
worth calling that out.

> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 99d1be5941a7..9bcdb30b7a80 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -1066,6 +1066,65 @@ static int config_global_keyid(void)
>  	return seamcall_on_each_package_serialized(&sc);
>  }
>  
> +/* Initialize one TDMR */

Does this comment add value?  Even if it does, it is better than naming
the dang function init_one_tdmr()?

> +static int init_tdmr(struct tdmr_info *tdmr)
> +{
> +	u64 next;
> +
> +	/*
> +	 * Initializing PAMT entries might be time-consuming (in
> +	 * proportion to the size of the requested TDMR).  To avoid long
> +	 * latency in one SEAMCALL, TDH.SYS.TDMR.INIT only initializes
> +	 * an (implementation-defined) subset of PAMT entries in one
> +	 * invocation.
> +	 *
> +	 * Call TDH.SYS.TDMR.INIT iteratively until all PAMT entries
> +	 * of the requested TDMR are initialized (if next-to-initialize
> +	 * address matches the end address of the TDMR).
> +	 */

The PAMT discussion here is, IMNHO silly.  If this were about
initializing PAMT's then it should be renamed init_pamts() and the
SEAMCALL should be called PAMT_INIT or soemthing.  It's not, and the ABI
is built around the TDMR and *its* addresses.

Let's chop this comment down:

	/*
	 * Initializing a TDMR can be time consuming.  To avoid long
	 * SEAMCALLs, the TDX module may only initialize a part of the
	 * TDMR in each call.
	 */

Talk about the looping logic in the loop.

> +	do {
> +		struct tdx_module_output out;
> +		int ret;
> +
> +		ret = seamcall(TDH_SYS_TDMR_INIT, tdmr->base, 0, 0, 0, NULL,
> +				&out);
> +		if (ret)
> +			return ret;
> +		/*
> +		 * RDX contains 'next-to-initialize' address if
> +		 * TDH.SYS.TDMR.INT succeeded.
> +		 */
> +		next = out.rdx;
> +		/* Allow scheduling when needed */

That comment is a wee bit superfluous, don't you think?

> +		cond_resched();

		/* Keep making SEAMCALLs until the TDMR is done */

> +	} while (next < tdmr->base + tdmr->size);
> +
> +	return 0;
> +}
> +
> +/* Initialize all TDMRs */

Does this comment add value?

> +static int init_tdmrs(struct tdmr_info *tdmr_array, int tdmr_num)
> +{
> +	int i;
> +
> +	/*
> +	 * Initialize TDMRs one-by-one for simplicity, though the TDX
> +	 * architecture does allow different TDMRs to be initialized in
> +	 * parallel on multiple CPUs.  Parallel initialization could
> +	 * be added later when the time spent in the serialized scheme
> +	 * becomes a real concern.
> +	 */

Trim down the comment:

	/*
	 * This operation is costly.  It can be parallelized,
	 * but keep it simple for now.
	 */

> +	for (i = 0; i < tdmr_num; i++) {
> +		int ret;
> +
> +		ret = init_tdmr(tdmr_array_entry(tdmr_array, i));
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * Detect and initialize the TDX module.
>   *
> @@ -1172,11 +1231,11 @@ static int init_tdx_module(void)
>  	if (ret)
>  		goto out_free_pamts;
>  
> -	/*
> -	 * Return -EINVAL until all steps of TDX module initialization
> -	 * process are done.
> -	 */
> -	ret = -EINVAL;
> +	/* Initialize TDMRs to complete the TDX module initialization */
> +	ret = init_tdmrs(tdmr_array, tdmr_num);
> +	if (ret)
> +		goto out_free_pamts;
> +
>  out_free_pamts:
>  	if (ret) {
>  		/*
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index 768d097412ab..891691b1ea50 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -19,6 +19,7 @@
>  #define TDH_SYS_INFO		32
>  #define TDH_SYS_INIT		33
>  #define TDH_SYS_LP_INIT		35
> +#define TDH_SYS_TDMR_INIT	36
>  #define TDH_SYS_LP_SHUTDOWN	44
>  #define TDH_SYS_CONFIG		45
>  

