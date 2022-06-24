Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D292855A206
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 21:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbiFXTlL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 15:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiFXTlL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 15:41:11 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CDC782680;
        Fri, 24 Jun 2022 12:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656099670; x=1687635670;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EGMll+FcW4PCgMly7MVLNqS1RLpL7xmW8ZjMIODiH0Q=;
  b=M7mm3t19o2NV95ruV2UVQE6HIBQqDqMvhb0zuXV/5eVSpOghYWQZAk8L
   QA008hLnofyyHl5RkXbdmuNBOySbHGuFhRYonGmsySXjjgetovh2sq17V
   xii4eWFIUQaC94nRr2EhLCPmak//qAIhFr49rS1JIqF7pyb3HF3/FmI8Y
   NvfDJxC6fD31IxB1UUQEmfhRvhrHoTaSBT4i97u1E+RTjFi/Wh9k3dD5W
   WN+JYdrR9P+Z/+O5ZI2QdowO5+lT4QRDNoHQVe5rGIUHnywFJHlB0AqDP
   nn31+x6Z6vTxsgYDNBsfo+tCdli2jShNefN181wbUFq3GL8ag8scFPq6Q
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10388"; a="345075469"
X-IronPort-AV: E=Sophos;i="5.92,220,1650956400"; 
   d="scan'208";a="345075469"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 12:41:05 -0700
X-IronPort-AV: E=Sophos;i="5.92,220,1650956400"; 
   d="scan'208";a="731444419"
Received: from mdedeogl-mobl.amr.corp.intel.com (HELO [10.209.126.186]) ([10.209.126.186])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 12:41:04 -0700
Message-ID: <20d63398-928f-0c6f-47ec-8e225c049ad8@intel.com>
Date:   Fri, 24 Jun 2022 12:40:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v5 12/22] x86/virt/tdx: Convert all memory regions in
 memblock to TDX memory
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
References: <cover.1655894131.git.kai.huang@intel.com>
 <8288396be7fedd10521a28531e138579594d757a.1655894131.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <8288396be7fedd10521a28531e138579594d757a.1655894131.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/22/22 04:17, Kai Huang wrote:
...
> Also, explicitly exclude memory regions below first 1MB as TDX memory
> because those regions may not be reported as convertible memory.  This
> is OK as the first 1MB is always reserved during kernel boot and won't
> end up to the page allocator.

Are you sure?  I wasn't for a few minutes until I found reserve_real_mode()

Could we point to that in this changelog, please?

> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index efa830853e98..4988a91d5283 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1974,6 +1974,7 @@ config INTEL_TDX_HOST
>  	depends on X86_64
>  	depends on KVM_INTEL
>  	select ARCH_HAS_CC_PLATFORM
> +	select ARCH_KEEP_MEMBLOCK
>  	help
>  	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
>  	  host and certain physical attacks.  This option enables necessary TDX
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 1bc97756bc0d..2b20d4a7a62b 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -15,6 +15,8 @@
>  #include <linux/cpumask.h>
>  #include <linux/smp.h>
>  #include <linux/atomic.h>
> +#include <linux/sizes.h>
> +#include <linux/memblock.h>
>  #include <asm/cpufeatures.h>
>  #include <asm/cpufeature.h>
>  #include <asm/msr-index.h>
> @@ -338,6 +340,91 @@ static int tdx_get_sysinfo(struct tdsysinfo_struct *tdsysinfo,
>  	return check_cmrs(cmr_array, actual_cmr_num);
>  }
>  
> +/*
> + * Skip the memory region below 1MB.  Return true if the entire
> + * region is skipped.  Otherwise, the updated range is returned.
> + */
> +static bool pfn_range_skip_lowmem(unsigned long *p_start_pfn,
> +				  unsigned long *p_end_pfn)
> +{
> +	u64 start, end;
> +
> +	start = *p_start_pfn << PAGE_SHIFT;
> +	end = *p_end_pfn << PAGE_SHIFT;
> +
> +	if (start < SZ_1M)
> +		start = SZ_1M;
> +
> +	if (start >= end)
> +		return true;
> +
> +	*p_start_pfn = (start >> PAGE_SHIFT);
> +
> +	return false;
> +}
> +
> +/*
> + * Walks over all memblock memory regions that are intended to be
> + * converted to TDX memory.  Essentially, it is all memblock memory
> + * regions excluding the low memory below 1MB.
> + *
> + * This is because on some TDX platforms the low memory below 1MB is
> + * not included in CMRs.  Excluding the low 1MB can still guarantee
> + * that the pages managed by the page allocator are always TDX memory,
> + * as the low 1MB is reserved during kernel boot and won't end up to
> + * the ZONE_DMA (see reserve_real_mode()).
> + */
> +#define memblock_for_each_tdx_mem_pfn_range(i, p_start, p_end, p_nid)	\
> +	for_each_mem_pfn_range(i, MAX_NUMNODES, p_start, p_end, p_nid)	\
> +		if (!pfn_range_skip_lowmem(p_start, p_end))

Let's summarize where we are at this point:

1. All RAM is described in memblocks
2. Some memblocks are reserved and some are free
3. The lower 1MB is marked reserved
4. for_each_mem_pfn_range() walks all reserved and free memblocks, so we
   have to exclude the lower 1MB as a special case.

That seems superficially rather ridiculous.  Shouldn't we just pick a
memblock iterator that skips the 1MB?  Surely there is such a thing.
Or, should we be doing something different with the 1MB in the memblock
structure?

> +/* Check whether first range is the subrange of the second */
> +static bool is_subrange(u64 r1_start, u64 r1_end, u64 r2_start, u64 r2_end)
> +{
> +	return r1_start >= r2_start && r1_end <= r2_end;
> +}
> +
> +/* Check whether address range is covered by any CMR or not. */
> +static bool range_covered_by_cmr(struct cmr_info *cmr_array, int cmr_num,
> +				 u64 start, u64 end)
> +{
> +	int i;
> +
> +	for (i = 0; i < cmr_num; i++) {
> +		struct cmr_info *cmr = &cmr_array[i];
> +
> +		if (is_subrange(start, end, cmr->base, cmr->base + cmr->size))
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
> +/*
> + * Check whether all memory regions in memblock are TDX convertible
> + * memory.  Return 0 if all memory regions are convertible, or error.
> + */
> +static int check_memblock_tdx_convertible(void)
> +{
> +	unsigned long start_pfn, end_pfn;
> +	int i;
> +
> +	memblock_for_each_tdx_mem_pfn_range(i, &start_pfn, &end_pfn, NULL) {
> +		u64 start, end;
> +
> +		start = start_pfn << PAGE_SHIFT;
> +		end = end_pfn << PAGE_SHIFT;
> +		if (!range_covered_by_cmr(tdx_cmr_array, tdx_cmr_num, start,
> +					end)) {
> +			pr_err("[0x%llx, 0x%llx) is not fully convertible memory\n",
> +					start, end);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * Detect and initialize the TDX module.
>   *
> @@ -371,6 +458,19 @@ static int init_tdx_module(void)
>  	if (ret)
>  		goto out;
>  
> +	/*
> +	 * To avoid having to modify the page allocator to distinguish
> +	 * TDX and non-TDX memory allocation, convert all memory regions
> +	 * in memblock to TDX memory to make sure all pages managed by
> +	 * the page allocator are TDX memory.
> +	 *
> +	 * Sanity check all memory regions are fully covered by CMRs to
> +	 * make sure they are truly convertible.
> +	 */
> +	ret = check_memblock_tdx_convertible();
> +	if (ret)
> +		goto out;
> +
>  	/*
>  	 * Return -EINVAL until all steps of TDX module initialization
>  	 * process are done.

