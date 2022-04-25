Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616FA50D744
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 04:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240502AbiDYDBN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Apr 2022 23:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiDYDBK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Apr 2022 23:01:10 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307C58300D;
        Sun, 24 Apr 2022 19:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650855488; x=1682391488;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7zP9c6Hz0+ADerHzpKpE29M8TOXpPgBNwoa4g9n2RUg=;
  b=TzmUn2Mc1ToSYxtkuKjdRcTQR29MKmAp9u98/qonL7RPs4xuyBgvjyIT
   mIEvWKbgl81XaXCW8dZPNmzss/iqRDp75VyzZuzxqauEl1KxsG4L66W+G
   zHV8YVbCJbveHRf28o8D+ACLjCzKHzufobvbHaVYFtTC0Ro3qMRCrylgd
   2BXhBf+D6r4u0GjHhF7g1p47GXo6pIm3OtwPtMTHpAOAXe534WpwTXKtT
   dUOTz9FEH+9YmdZWgp6FpHvUlAsYUUauEhm7QdZ9g/PIrKof/RsBJoda4
   uklt1taVfXZt3xcV0GWqKUGZpJDwOipnD8axcSCL1vWOEsy/tr9Y0vOW/
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10327"; a="245048012"
X-IronPort-AV: E=Sophos;i="5.90,287,1643702400"; 
   d="scan'208";a="245048012"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2022 19:58:07 -0700
X-IronPort-AV: E=Sophos;i="5.90,287,1643702400"; 
   d="scan'208";a="512426692"
Received: from jbapanap-mobl.amr.corp.intel.com (HELO [10.212.136.45]) ([10.212.136.45])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2022 19:58:06 -0700
Message-ID: <8972b2ac-c786-8ff5-74fc-040cd4d81c86@linux.intel.com>
Date:   Sun, 24 Apr 2022 19:58:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH v3 09/21] x86/virt/tdx: Get information about TDX module
 and convertible memory
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com, isaku.yamahata@intel.com
References: <cover.1649219184.git.kai.huang@intel.com>
 <145620795852bf24ba2124a3f8234fd4aaac19d4.1649219184.git.kai.huang@intel.com>
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <145620795852bf24ba2124a3f8234fd4aaac19d4.1649219184.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/5/22 9:49 PM, Kai Huang wrote:
> TDX provides increased levels of memory confidentiality and integrity.
> This requires special hardware support for features like memory
> encryption and storage of memory integrity checksums.  Not all memory
> satisfies these requirements.
> 
> As a result, TDX introduced the concept of a "Convertible Memory Region"
> (CMR).  During boot, the firmware builds a list of all of the memory
> ranges which can provide the TDX security guarantees.  The list of these
> ranges, along with TDX module information, is available to the kernel by
> querying the TDX module via TDH.SYS.INFO SEAMCALL.
> 
> Host kernel can choose whether or not to use all convertible memory
> regions as TDX memory.  Before TDX module is ready to create any TD
> guests, all TDX memory regions that host kernel intends to use must be
> configured to the TDX module, using specific data structures defined by
> TDX architecture.  Constructing those structures requires information of
> both TDX module and the Convertible Memory Regions.  Call TDH.SYS.INFO
> to get this information as preparation to construct those structures.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---

Looks good. Some minor comments.

>   arch/x86/virt/vmx/tdx/tdx.c | 131 ++++++++++++++++++++++++++++++++++++
>   arch/x86/virt/vmx/tdx/tdx.h |  61 +++++++++++++++++
>   2 files changed, 192 insertions(+)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index ef2718423f0f..482e6d858181 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -80,6 +80,11 @@ static DEFINE_MUTEX(tdx_module_lock);
>   
>   static struct p_seamldr_info p_seamldr_info;
>   
> +/* Base address of CMR array needs to be 512 bytes aligned. */
> +static struct cmr_info tdx_cmr_array[MAX_CMRS] __aligned(CMR_INFO_ARRAY_ALIGNMENT);
> +static int tdx_cmr_num;
> +static struct tdsysinfo_struct tdx_sysinfo;
> +
>   static bool __seamrr_enabled(void)
>   {
>   	return (seamrr_mask & SEAMRR_ENABLED_BITS) == SEAMRR_ENABLED_BITS;
> @@ -468,6 +473,127 @@ static int tdx_module_init_cpus(void)
>   	return seamcall_on_each_cpu(&sc);
>   }
>   
> +static inline bool cmr_valid(struct cmr_info *cmr)
> +{
> +	return !!cmr->size;
> +}
> +
> +static void print_cmrs(struct cmr_info *cmr_array, int cmr_num,
> +		       const char *name)
> +{
> +	int i;
> +
> +	for (i = 0; i < cmr_num; i++) {
> +		struct cmr_info *cmr = &cmr_array[i];
> +
> +		pr_info("%s : [0x%llx, 0x%llx)\n", name,
> +				cmr->base, cmr->base + cmr->size);
> +	}

I am not sure if it is ok to print this info by default or pr_debug
would be better. I will let maintainers decide about it.

> +}
> +
> +static int sanitize_cmrs(struct cmr_info *cmr_array, int cmr_num)

Since this function only deals with tdx_cmr_array, why pass it
as argument?

> +{
> +	int i, j;
> +
> +	/*
> +	 * Intel TDX module spec, 20.7.3 CMR_INFO:
> +	 *
> +	 *   TDH.SYS.INFO leaf function returns a MAX_CMRS (32) entry
> +	 *   array of CMR_INFO entries. The CMRs are sorted from the
> +	 *   lowest base address to the highest base address, and they
> +	 *   are non-overlapping.
> +	 *
> +	 * This implies that BIOS may generate invalid empty entries
> +	 * if total CMRs are less than 32.  Skip them manually.
> +	 */
> +	for (i = 0; i < cmr_num; i++) {
> +		struct cmr_info *cmr = &cmr_array[i];
> +		struct cmr_info *prev_cmr = NULL;

Why not keep declarations together at the top of the function?

> +
> +		/* Skip further invalid CMRs */
> +		if (!cmr_valid(cmr))
> +			break;
> +
> +		if (i > 0)
> +			prev_cmr = &cmr_array[i - 1];
> +
> +		/*
> +		 * It is a TDX firmware bug if CMRs are not
> +		 * in address ascending order.
> +		 */
> +		if (prev_cmr && ((prev_cmr->base + prev_cmr->size) >
> +					cmr->base)) {
> +			pr_err("Firmware bug: CMRs not in address ascending order.\n");
> +			return -EFAULT;
> +		}

Since above condition is only true for i > 0 case, why not combine them
together if (i > 0) {...}

> +	}
> +
> +	/*
> +	 * Also a sane BIOS should never generate invalid CMR(s) between
> +	 * two valid CMRs.  Sanity check this and simply return error in
> +	 * this case.
> +	 *
> +	 * By reaching here @i is the index of the first invalid CMR (or
> +	 * cmr_num).  Starting with next entry of @i since it has already
> +	 * been checked.
> +	 */
> +	for (j = i + 1; j < cmr_num; j++)
> +		if (cmr_valid(&cmr_array[j])) {
> +			pr_err("Firmware bug: invalid CMR(s) among valid CMRs.\n");
> +			return -EFAULT;
> +		}
> +
> +	/*
> +	 * Trim all tail invalid empty CMRs.  BIOS should generate at
> +	 * least one valid CMR, otherwise it's a TDX firmware bug.
> +	 */
> +	tdx_cmr_num = i;
> +	if (!tdx_cmr_num) {
> +		pr_err("Firmware bug: No valid CMR.\n");
> +		return -EFAULT;
> +	}
> +
> +	/* Print kernel sanitized CMRs */
> +	print_cmrs(tdx_cmr_array, tdx_cmr_num, "Kernel-sanitized-CMR");
> +
> +	return 0;
> +}
> +


-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
