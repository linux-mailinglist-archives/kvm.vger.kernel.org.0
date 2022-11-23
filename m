Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E46BA634B9D
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 01:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234723AbiKWAWC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 19:22:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235243AbiKWAV6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 19:21:58 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58DBC657C7;
        Tue, 22 Nov 2022 16:21:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669162917; x=1700698917;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6HaaNro/fOK4kdlUDg57K0J3XI/rWP0uFyGdLLRKjcg=;
  b=koyMDDgS67UC2QcBwa3HWAjTStttqNFH0i0RdiImcBg9vKWB6WKwHfJ0
   zJ3EAhPZoRHN5qKLwMDtmIz8GA1DmxhnqOrBd5MoRxHovikTe6r8yQaEo
   Cq0Rx11lhbDtMSoj3ig69C6bubKqsTEIUosYoUVS+b7ssMffNENZGcEQl
   kElLNgBr1b3Pq6P5H3amJSY8Ygh+wueAKcPRk5ELPKywOQsqzYfpw+HSX
   uh9CxkXMEwZgwxzYOSyUk42GlINQssNVWVtjwaOHq6UsIMVimBWIWxQv3
   EviWKJof9SJMQMdiOMVCz0KTuOrBAA9YwqENaZc5Z8BJdPFtcVwEmZHGy
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="400237379"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="400237379"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 16:21:43 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="970666461"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="970666461"
Received: from coltsavx-mobl1.amr.corp.intel.com (HELO [10.255.0.114]) ([10.255.0.114])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 16:21:40 -0800
Message-ID: <eb8d0f69-7ada-a358-46ea-da15a3aeac93@intel.com>
Date:   Tue, 22 Nov 2022 16:21:38 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 10/20] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
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
 <9b545148275b14a8c7edef1157f8ec44dc8116ee.1668988357.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <9b545148275b14a8c7edef1157f8ec44dc8116ee.1668988357.git.kai.huang@intel.com>
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
> TDX reports a list of "Convertible Memory Region" (CMR) to indicate all
> memory regions that can possibly be used by the TDX module, but they are
> not automatically usable to the TDX module.  As a step of initializing
> the TDX module, the kernel needs to choose a list of memory regions (out
> from convertible memory regions) that the TDX module can use and pass
> those regions to the TDX module.  Once this is done, those "TDX-usable"
> memory regions are fixed during module's lifetime.  No more TDX-usable
> memory can be added to the TDX module after that.
> 
> The initial support of TDX guests will only allocate TDX guest memory
> from the global page allocator.  To keep things simple, this initial
> implementation simply guarantees all pages in the page allocator are TDX
> memory.  To achieve this, use all system memory in the core-mm at the
> time of initializing the TDX module as TDX memory, and at the meantime,
> refuse to add any non-TDX-memory in the memory hotplug.
> 
> Specifically, walk through all memory regions managed by memblock and
> add them to a global list of "TDX-usable" memory regions, which is a
> fixed list after the module initialization (or empty if initialization
> fails).  To reject non-TDX-memory in memory hotplug, add an additional
> check in arch_add_memory() to check whether the new region is covered by
> any region in the "TDX-usable" memory region list.
> 
> Note this requires all memory regions in memblock are TDX convertible
> memory when initializing the TDX module.  This is true in practice if no
> new memory has been hot-added before initializing the TDX module, since
> in practice all boot-time present DIMM is TDX convertible memory.  If
> any new memory has been hot-added, then initializing the TDX module will
> fail due to that memory region is not covered by CMR.
> 
> This can be enhanced in the future, i.e. by allowing adding non-TDX
> memory to a separate NUMA node.  In this case, the "TDX-capable" nodes
> and the "non-TDX-capable" nodes can co-exist, but the kernel/userspace
> needs to guarantee memory pages for TDX guests are always allocated from
> the "TDX-capable" nodes.
> 
> Note TDX assumes convertible memory is always physically present during
> machine's runtime.  A non-buggy BIOS should never support hot-removal of
> any convertible memory.  This implementation doesn't handle ACPI memory
> removal but depends on the BIOS to behave correctly.

My eyes glazed over about halfway through that.  Can you try to trim it
down a bit, or at least try to summarize it better up front?

> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index dd333b46fafb..b36129183035 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1959,6 +1959,7 @@ config INTEL_TDX_HOST
>  	depends on X86_64
>  	depends on KVM_INTEL
>  	depends on X86_X2APIC
> +	select ARCH_KEEP_MEMBLOCK
>  	help
>  	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
>  	  host and certain physical attacks.  This option enables necessary TDX
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index d688228f3151..71169ecefabf 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -111,9 +111,12 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
>  #ifdef CONFIG_INTEL_TDX_HOST
>  bool platform_tdx_enabled(void);
>  int tdx_enable(void);
> +bool tdx_cc_memory_compatible(unsigned long start_pfn, unsigned long end_pfn);
>  #else	/* !CONFIG_INTEL_TDX_HOST */
>  static inline bool platform_tdx_enabled(void) { return false; }
>  static inline int tdx_enable(void)  { return -ENODEV; }
> +static inline bool tdx_cc_memory_compatible(unsigned long start_pfn,
> +		unsigned long end_pfn) { return true; }
>  #endif	/* CONFIG_INTEL_TDX_HOST */
>  
>  #endif /* !__ASSEMBLY__ */
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 3f040c6e5d13..900341333d7e 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -55,6 +55,7 @@
>  #include <asm/uv/uv.h>
>  #include <asm/setup.h>
>  #include <asm/ftrace.h>
> +#include <asm/tdx.h>
>  
>  #include "mm_internal.h"
>  
> @@ -968,6 +969,15 @@ int arch_add_memory(int nid, u64 start, u64 size,
>  	unsigned long start_pfn = start >> PAGE_SHIFT;
>  	unsigned long nr_pages = size >> PAGE_SHIFT;
>  
> +	/*
> +	 * For now if TDX is enabled, all pages in the page allocator

s/For now//

> +	 * must be TDX memory, which is a fixed set of memory regions
> +	 * that are passed to the TDX module.  Reject the new region
> +	 * if it is not TDX memory to guarantee above is true.
> +	 */
> +	if (!tdx_cc_memory_compatible(start_pfn, start_pfn + nr_pages))
> +		return -EINVAL;

There's a real art to making a right-size comment.  I don't think this
needs to be any more than:

	/*
	 * Not all memory is compatible with TDX.  Reject
	 * the addition of any incomatible memory.
	 */

If you want to write a treatise, do it in Documentation or at the
tdx_cc_memory_compatible() definition.

>  	init_memory_mapping(start, start + size, params->pgprot);
>  
>  	return add_pages(nid, start_pfn, nr_pages, params);
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 43227af25e44..32af86e31c47 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -16,6 +16,11 @@
>  #include <linux/smp.h>
>  #include <linux/atomic.h>
>  #include <linux/align.h>
> +#include <linux/list.h>
> +#include <linux/slab.h>
> +#include <linux/memblock.h>
> +#include <linux/minmax.h>
> +#include <linux/sizes.h>
>  #include <asm/msr-index.h>
>  #include <asm/msr.h>
>  #include <asm/apic.h>
> @@ -34,6 +39,13 @@ enum tdx_module_status_t {
>  	TDX_MODULE_SHUTDOWN,
>  };
>  
> +struct tdx_memblock {
> +	struct list_head list;
> +	unsigned long start_pfn;
> +	unsigned long end_pfn;
> +	int nid;
> +};

Why does the nid matter?

>  static u32 tdx_keyid_start __ro_after_init;
>  static u32 tdx_keyid_num __ro_after_init;
>  
> @@ -46,6 +58,9 @@ static struct tdsysinfo_struct tdx_sysinfo;
>  static struct cmr_info tdx_cmr_array[MAX_CMRS] __aligned(CMR_INFO_ARRAY_ALIGNMENT);
>  static int tdx_cmr_num;
>  
> +/* All TDX-usable memory regions */
> +static LIST_HEAD(tdx_memlist);
> +
>  /*
>   * Detect TDX private KeyIDs to see whether TDX has been enabled by the
>   * BIOS.  Both initializing the TDX module and running TDX guest require
> @@ -329,6 +344,107 @@ static int tdx_get_sysinfo(void)
>  	return trim_empty_cmrs(tdx_cmr_array, &tdx_cmr_num);
>  }
>  
> +/* Check whether the given pfn range is covered by any CMR or not. */
> +static bool pfn_range_covered_by_cmr(unsigned long start_pfn,
> +				     unsigned long end_pfn)
> +{
> +	int i;
> +
> +	for (i = 0; i < tdx_cmr_num; i++) {
> +		struct cmr_info *cmr = &tdx_cmr_array[i];
> +		unsigned long cmr_start_pfn;
> +		unsigned long cmr_end_pfn;
> +
> +		cmr_start_pfn = cmr->base >> PAGE_SHIFT;
> +		cmr_end_pfn = (cmr->base + cmr->size) >> PAGE_SHIFT;
> +
> +		if (start_pfn >= cmr_start_pfn && end_pfn <= cmr_end_pfn)
> +			return true;
> +	}

What if the pfn range overlaps two CMRs?  It will never pass any
individual overlap test and will return false.

> +	return false;
> +}
> +
> +/*
> + * Add a memory region on a given node as a TDX memory block.  The caller
> + * to make sure all memory regions are added in address ascending order

s/to/must/

> + * and don't overlap.
> + */
> +static int add_tdx_memblock(unsigned long start_pfn, unsigned long end_pfn,
> +			    int nid)
> +{
> +	struct tdx_memblock *tmb;
> +
> +	tmb = kmalloc(sizeof(*tmb), GFP_KERNEL);
> +	if (!tmb)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(&tmb->list);
> +	tmb->start_pfn = start_pfn;
> +	tmb->end_pfn = end_pfn;
> +	tmb->nid = nid;
> +
> +	list_add_tail(&tmb->list, &tdx_memlist);
> +	return 0;
> +}
> +
> +static void free_tdx_memory(void)

This is named a bit too generically.  How about free_tdx_memlist() or
something?

> +{
> +	while (!list_empty(&tdx_memlist)) {
> +		struct tdx_memblock *tmb = list_first_entry(&tdx_memlist,
> +				struct tdx_memblock, list);
> +
> +		list_del(&tmb->list);
> +		kfree(tmb);
> +	}
> +}
> +
> +/*
> + * Add all memblock memory regions to the @tdx_memlist as TDX memory.
> + * Must be called when get_online_mems() is called by the caller.
> + */

Again, this explains the "what", but not the "why".

/*
 * Ensure that all memblock memory regions are convertible to TDX
 * memory.  Once this has been established, stash the memblock
 * ranges off in a secondary structure because $REASONS.
 */

Which makes me wonder: Why do you even need a secondary structure here?
What's wrong with the memblocks themselves?

> +static int build_tdx_memory(void)
> +{
> +	unsigned long start_pfn, end_pfn;
> +	int i, nid, ret;
> +
> +	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
> +		/*
> +		 * The first 1MB may not be reported as TDX convertible
> +		 * memory.  Manually exclude them as TDX memory.

I don't like the "may not" here very much.

> +		 * This is fine as the first 1MB is already reserved in
> +		 * reserve_real_mode() and won't end up to ZONE_DMA as
> +		 * free page anyway.

			 ^ free pages

> +		 */

This way too wishy washy.  The TDX module may or may not...  Then, it
doesn't matter since reserve_real_mode() does it anyway...

Then it goes and adds code to skip it!

> +		start_pfn = max(start_pfn, (unsigned long)SZ_1M >> PAGE_SHIFT);
> +		if (start_pfn >= end_pfn)
> +			continue;


Please just put a dang stake in the ground.  If the other code deals
with this, then explain *why* more is needed here.

> +		/* Verify memory is truly TDX convertible memory */
> +		if (!pfn_range_covered_by_cmr(start_pfn, end_pfn)) {
> +			pr_info("Memory region [0x%lx, 0x%lx) is not TDX convertible memorry.\n",
> +					start_pfn << PAGE_SHIFT,
> +					end_pfn << PAGE_SHIFT);
> +			return -EINVAL;

... no 'goto err'?  This leaks all the previous add_tdx_memblock()
structures, right?

> +		}
> +
> +		/*
> +		 * Add the memory regions as TDX memory.  The regions in
> +		 * memblock has already guaranteed they are in address
> +		 * ascending order and don't overlap.
> +		 */
> +		ret = add_tdx_memblock(start_pfn, end_pfn, nid);
> +		if (ret)
> +			goto err;
> +	}
> +
> +	return 0;
> +err:
> +	free_tdx_memory();
> +	return ret;
> +}
> +
>  /*
>   * Detect and initialize the TDX module.
>   *
> @@ -357,12 +473,56 @@ static int init_tdx_module(void)
>  	if (ret)
>  		goto out;
>  
> +	/*
> +	 * All memory regions that can be used by the TDX module must be
> +	 * passed to the TDX module during the module initialization.
> +	 * Once this is done, all "TDX-usable" memory regions are fixed
> +	 * during module's runtime.
> +	 *
> +	 * The initial support of TDX guests only allocates memory from
> +	 * the global page allocator.  To keep things simple, for now
> +	 * just make sure all pages in the page allocator are TDX memory.
> +	 *
> +	 * To achieve this, use all system memory in the core-mm at the
> +	 * time of initializing the TDX module as TDX memory, and at the
> +	 * meantime, reject any new memory in memory hot-add.
> +	 *
> +	 * This works as in practice, all boot-time present DIMM is TDX
> +	 * convertible memory.  However if any new memory is hot-added
> +	 * before initializing the TDX module, the initialization will
> +	 * fail due to that memory is not covered by CMR.
> +	 *
> +	 * This can be enhanced in the future, i.e. by allowing adding or
> +	 * onlining non-TDX memory to a separate node, in which case the
> +	 * "TDX-capable" nodes and the "non-TDX-capable" nodes can exist
> +	 * together -- the userspace/kernel just needs to make sure pages
> +	 * for TDX guests must come from those "TDX-capable" nodes.
> +	 *
> +	 * Build the list of TDX memory regions as mentioned above so
> +	 * they can be passed to the TDX module later.
> +	 */

This is msotly Documentation/, not a code comment.  Please clean it up.

> +	get_online_mems();
> +
> +	ret = build_tdx_memory();
> +	if (ret)
> +		goto out;
>  	/*
>  	 * Return -EINVAL until all steps of TDX module initialization
>  	 * process are done.
>  	 */
>  	ret = -EINVAL;
>  out:
> +	/*
> +	 * Memory hotplug checks the hot-added memory region against the
> +	 * @tdx_memlist to see if the region is TDX memory.
> +	 *
> +	 * Do put_online_mems() here to make sure any modification to
> +	 * @tdx_memlist is done while holding the memory hotplug read
> +	 * lock, so that the memory hotplug path can just check the
> +	 * @tdx_memlist w/o holding the @tdx_module_lock which may cause
> +	 * deadlock.
> +	 */

I'm honestly not following any of that.

> +	put_online_mems();
>  	return ret;
>  }
>  
> @@ -485,3 +645,26 @@ int tdx_enable(void)
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(tdx_enable);
> +
> +/*
> + * Check whether the given range is TDX memory.  Must be called between
> + * mem_hotplug_begin()/mem_hotplug_done().
> + */
> +bool tdx_cc_memory_compatible(unsigned long start_pfn, unsigned long end_pfn)
> +{
> +	struct tdx_memblock *tmb;
> +
> +	/* Empty list means TDX isn't enabled successfully */
> +	if (list_empty(&tdx_memlist))
> +		return true;
> +
> +	list_for_each_entry(tmb, &tdx_memlist, list) {
> +		/*
> +		 * The new range is TDX memory if it is fully covered
> +		 * by any TDX memory block.
> +		 */
> +		if (start_pfn >= tmb->start_pfn && end_pfn <= tmb->end_pfn)
> +			return true;

Same bug.  What if the start/end_pfn range is covered by more than one
tdx_memblock?

> +	}
> +	return false;
> +}

