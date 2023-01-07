Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC5A660AB5
	for <lists+kvm@lfdr.de>; Sat,  7 Jan 2023 01:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbjAGARq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 19:17:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjAGARo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 19:17:44 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780D27A392;
        Fri,  6 Jan 2023 16:17:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673050662; x=1704586662;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mfxUCnVszE/gHGtsaclofwX82ZTIGkhFDTZ/pk93hdE=;
  b=S0b2e7yB4WkVoHA4F+MeiqQ/pMbXhtch2JpYfq5PVpOcc12Illdh2oxc
   ATN50LesUPMcYuF99crKJC8KSO7cxdf2nVtIaZE8h798V/prxWul3MNWR
   PkT3hpZsRh+A9ernula4IF3pJFp3s1Dg6DTZtEs6XdYOPnnGC3M9Zs14M
   FSL3I4d/77fTYxCNcl8JlnPDdJvgeCIydvKspQccUQc5G2t15dMWV8uYI
   N8urSxKdnOZ3n1csRH3CNGRDg+AzBRjga4bdJWatQiV0CHr+0EXu+jjLC
   CoPuPUKZ5mzgKeMpUK+wcJxvlh21l0VlOlYZK/qvCaW4dY5Vg1I9khx5o
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="306112558"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="306112558"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 16:17:34 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="798441217"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="798441217"
Received: from xiangyuy-mobl.amr.corp.intel.com (HELO [10.212.251.186]) ([10.212.251.186])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 16:17:32 -0800
Message-ID: <8e46f932-8ec9-0621-4423-e6233747b231@intel.com>
Date:   Fri, 6 Jan 2023 16:17:32 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v8 14/16] x86/virt/tdx: Initialize all TDMRs
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
 <16d47f9611d53c0f07a4af2b5739ed83e41b6e48.1670566861.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <16d47f9611d53c0f07a4af2b5739ed83e41b6e48.1670566861.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/22 22:52, Kai Huang wrote:
> After the global KeyID has been configured on all packages, initialize
> all TDMRs to make all TDX-usable memory regions that are passed to the
> TDX module become usable.
> 
> This is the last step of initializing the TDX module.
> 
> Initializing different TDMRs can be parallelized.  For now to keep it
> simple, just initialize all TDMRs one by one.  It can be enhanced in the
> future.

The changelog probably also needs a note about this being a long process
and also at least touching on *why* it takes so long.

> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 4c779e8412f1..8b7314f19df2 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -1006,6 +1006,55 @@ static int config_global_keyid(void)
>  	return ret;
>  }
>  
> +static int init_tdmr(struct tdmr_info *tdmr)
> +{
> +	u64 next;
> +
> +	/*
> +	 * Initializing a TDMR can be time consuming.  To avoid long
> +	 * SEAMCALLs, the TDX module may only initialize a part of the
> +	 * TDMR in each call.
> +	 */
> +	do {
> +		struct tdx_module_output out;
> +		int ret;
> +
> +		/* All 0's are unused parameters, they mean nothing. */
> +		ret = seamcall(TDH_SYS_TDMR_INIT, tdmr->base, 0, 0, 0, NULL,
> +				&out);
> +		if (ret)
> +			return ret;
> +		/*
> +		 * RDX contains 'next-to-initialize' address if
> +		 * TDH.SYS.TDMR.INT succeeded.

This reads strangely.  "Success" to me really is different from "partial
success".  Sure, partial success is also not an error, *but* this can be
explained better.  How about:

		 * RDX contains 'next-to-initialize' address if
		 * TDH.SYS.TDMR.INT did not fully complete and should
		 * be retried.


> +		 */
> +		next = out.rdx;
> +		cond_resched();
> +		/* Keep making SEAMCALLs until the TDMR is done */
> +	} while (next < tdmr->base + tdmr->size);
> +
> +	return 0;
> +}
> +
> +static int init_tdmrs(struct tdmr_info_list *tdmr_list)
> +{
> +	int i;
> +
> +	/*
> +	 * This operation is costly.  It can be parallelized,
> +	 * but keep it simple for now.
> +	 */
> +	for (i = 0; i < tdmr_list->nr_tdmrs; i++) {
> +		int ret;
> +
> +		ret = init_tdmr(tdmr_entry(tdmr_list, i));
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
>  static int init_tdx_module(void)
>  {
>  	/*
> @@ -1076,14 +1125,10 @@ static int init_tdx_module(void)
>  	if (ret)
>  		goto out_free_pamts;
>  
> -	/*
> -	 * TODO:
> -	 *
> -	 *  - Initialize all TDMRs.
> -	 *
> -	 *  Return error before all steps are done.
> -	 */
> -	ret = -EINVAL;
> +	/* Initialize TDMRs to complete the TDX module initialization */
> +	ret = init_tdmrs(&tdmr_list);
> +	if (ret)
> +		goto out_free_pamts;
>  out_free_pamts:
>  	if (ret) {
>  		/*
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index f5c12a2543d4..163c4876dee4 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -21,6 +21,7 @@
>   */
>  #define TDH_SYS_KEY_CONFIG	31
>  #define TDH_SYS_INFO		32
> +#define TDH_SYS_TDMR_INIT	36
>  #define TDH_SYS_CONFIG		45
>  
>  struct cmr_info {

