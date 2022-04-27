Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7319B51253B
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 00:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbiD0W1T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 18:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232182AbiD0W1R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 18:27:17 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842432E69C;
        Wed, 27 Apr 2022 15:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651098244; x=1682634244;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=KgvhYzBvbKYkKQMBNMqzHSJ+tzwkX0jj6FKwxER+9jw=;
  b=CxcfpxGBXgCSbNnRWwf7DZndzbXqvQbNLF2IKwfVtInOK3tyCODt9ozo
   axmmUcAuReLE7PQY+1xug/8yEwmDuuarJ+aQTW5lQ3URLOzJJ/FS3XEeD
   Zd21z1OmUzFkGRDC1FV8Ux8Cx1x26URVGvhUFq3vjzWDY0yr/LsXFC64/
   ViBsLxGskpbBpknfd6GGrHEAGMfXzOOW9ZB+bR62sJDAE1IGQmNACPQhm
   j1gsz5+Rwfupn/LUeJSdaDg+SqlX0v/Jyiiluvz/Jf3XKt3nKuluBXJYq
   0YQBTENMvFPBPyw5iIJVgn0pfwFbVUOTJLBjekmAa2Zv+E3yJueNuN16B
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="266250518"
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="266250518"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 15:23:58 -0700
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="513914748"
Received: from lcdaughe-mobl1.amr.corp.intel.com (HELO [10.212.72.252]) ([10.212.72.252])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 15:23:56 -0700
Message-ID: <d69c08da-80fa-2001-bbe8-8c45552e74ae@intel.com>
Date:   Wed, 27 Apr 2022 15:24:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 10/21] x86/virt/tdx: Add placeholder to coveret all
 system RAM as TDX memory
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
 <6230ef28be8c360ab326c8f592acf1964ac065c1.1649219184.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <6230ef28be8c360ab326c8f592acf1964ac065c1.1649219184.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/5/22 21:49, Kai Huang wrote:
> TDX provides increased levels of memory confidentiality and integrity.
> This requires special hardware support for features like memory
> encryption and storage of memory integrity checksums.  Not all memory
> satisfies these requirements.
> 
> As a result, TDX introduced the concept of a "Convertible Memory Region"
> (CMR).  During boot, the firmware builds a list of all of the memory
> ranges which can provide the TDX security guarantees.  The list of these
> ranges, along with TDX module information, is available to the kernel by
> querying the TDX module.
> 
> In order to provide crypto protection to TD guests, the TDX architecture

There's that "crypto protection" thing again.  I'm not really a fan of
the changes made to this changelog since I wrote it. :)

> also needs additional metadata to record things like which TD guest
> "owns" a given page of memory.  This metadata essentially serves as the
> 'struct page' for the TDX module.  The space for this metadata is not
> reserved by the hardware upfront and must be allocated by the kernel

			    ^ "up front"

...
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 482e6d858181..ec27350d53c1 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -13,6 +13,7 @@
>  #include <linux/cpu.h>
>  #include <linux/smp.h>
>  #include <linux/atomic.h>
> +#include <linux/slab.h>
>  #include <asm/msr-index.h>
>  #include <asm/msr.h>
>  #include <asm/cpufeature.h>
> @@ -594,8 +595,29 @@ static int tdx_get_sysinfo(void)
>  	return sanitize_cmrs(tdx_cmr_array, cmr_num);
>  }
>  
> +static void free_tdmrs(struct tdmr_info **tdmr_array, int tdmr_num)
> +{
> +	int i;
> +
> +	for (i = 0; i < tdmr_num; i++) {
> +		struct tdmr_info *tdmr = tdmr_array[i];
> +
> +		/* kfree() works with NULL */
> +		kfree(tdmr);
> +		tdmr_array[i] = NULL;
> +	}
> +}
> +
> +static int construct_tdmrs(struct tdmr_info **tdmr_array, int *tdmr_num)
> +{
> +	/* Return -EFAULT until constructing TDMRs is done */
> +	return -EFAULT;
> +}
> +
>  static int init_tdx_module(void)
>  {
> +	struct tdmr_info **tdmr_array;
> +	int tdmr_num;
>  	int ret;
>  
>  	/* TDX module global initialization */
> @@ -613,11 +635,36 @@ static int init_tdx_module(void)
>  	if (ret)
>  		goto out;
>  
> +	/*
> +	 * Prepare enough space to hold pointers of TDMRs (TDMR_INFO).
> +	 * TDX requires TDMR_INFO being 512 aligned.  Each TDMR is

					 ^ "512-byte aligned"

Right?

> +	 * allocated individually within construct_tdmrs() to meet
> +	 * this requirement.
> +	 */
> +	tdmr_array = kcalloc(tdx_sysinfo.max_tdmrs, sizeof(struct tdmr_info *),
> +			GFP_KERNEL);

Where, exactly is that alignment provided?  A 'struct tdmr_info *' is 8
bytes so a tdx_sysinfo.max_tdmrs=8 kcalloc() would only guarantee
64-byte alignment.

Also, I'm surprised that this is an array of virtual address pointers.
The previous interactions with the TDX module seemed to all take
physical addresses.  How is it that this hardware structure which has
hardware alignment constraints is holding virtual addresses?

> +	if (!tdmr_array) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	/* Construct TDMRs to build TDX memory */
> +	ret = construct_tdmrs(tdmr_array, &tdmr_num);
> +	if (ret)
> +		goto out_free_tdmrs;
> +
>  	/*
>  	 * Return -EFAULT until all steps of TDX module
>  	 * initialization are done.
>  	 */
>  	ret = -EFAULT;

There's the -EFAULT again.  I'd replace these with a better error code.

> +out_free_tdmrs:
> +	/*
> +	 * TDMRs are only used during initializing TDX module.  Always
> +	 * free them no matter the initialization was successful or not.
> +	 */
> +	free_tdmrs(tdmr_array, tdmr_num);
> +	kfree(tdmr_array);
>  out:
>  	return ret;
>  }
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index 2f21c45df6ac..05bf9fe6bd00 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -89,6 +89,29 @@ struct tdsysinfo_struct {
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
>   * P-SEAMLDR SEAMCALL leaf function
>   */

