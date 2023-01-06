Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605D4660646
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 19:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235541AbjAFSS2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 13:18:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235638AbjAFSS0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 13:18:26 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF21273E00;
        Fri,  6 Jan 2023 10:18:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673029104; x=1704565104;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8RsSGmntUbelvavRBP1w2DS+4Yl8+okwt7S+8oN3aS4=;
  b=jJfZB9xV5owNueAUlXvPCfxtSqIGCVnBIN7GY5I6ZEw3octCQPV9BDfb
   FxbHeXGcmNrLalP4go++njaO0ypEpowecgskkuk8tN0YH2XheKJF2ea0t
   mGew+082dYUR/unZWogZCLUOstLwRIkHm4xRt4AlyMER8E6wK5fuchkSr
   pnbsCOyo3qI+oPuirvXRvXoYm89Su0QZGIvu/FI2clAQdzVDPSfyI5qeh
   bv06X7wzDUeO/36JT3rVXEP/lQwKlXdWe9wYx1LqQZPCncd/ksxFI9Uf0
   PubwvTKS+HGhogrVSnRZWZxFHqk30rf/znY5Mzy+IcJHFLR75aYNUtrlY
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="306045763"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="306045763"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 10:18:23 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="984741869"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="984741869"
Received: from xiangyuy-mobl.amr.corp.intel.com (HELO [10.212.251.186]) ([10.212.251.186])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 10:18:22 -0800
Message-ID: <e7b682a1-abdf-ce73-f262-8b7ce946e78e@intel.com>
Date:   Fri, 6 Jan 2023 10:18:22 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v8 07/16] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
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
 <8aab33a7db7a408beb403950e21f693b0b0f1f2b.1670566861.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <8aab33a7db7a408beb403950e21f693b0b0f1f2b.1670566861.git.kai.huang@intel.com>
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
> As a step of initializing the TDX module, the kernel needs to tell the
> TDX module which memory regions can be used by the TDX module as TDX
> guest memory.
> 
> TDX reports a list of "Convertible Memory Region" (CMR) to tell the
> kernel which memory is TDX compatible.  The kernel needs to build a list
> of memory regions (out of CMRs) as "TDX-usable" memory and pass them to
> the TDX module.  Once this is done, those "TDX-usable" memory regions
> are fixed during module's lifetime.
> 
> The initial support of TDX guests will only allocate TDX guest memory
> from the global page allocator.  To keep things simple, just make sure
> all pages in the page allocator are TDX memory.

It's hard to tell what "The initial support of TDX guests" means.  I
*think* you mean "this series".  But, we try not to say "this blah" too
much, so just say this:

	To keep things simple, assume that all TDX-protected memory will
	comes page allocator.  Make sure all pages in the page allocator
	*are* TDX-usable memory.

> To guarantee that, stash off the memblock memory regions at the time of
> initializing the TDX module as TDX's own usable memory regions, and in
> the meantime, register a TDX memory notifier to reject to online any new
> memory in memory hotplug.

First, this is a run-on sentence.  Second, it isn't really clear what
memblocks have to do with this or why you need to stash them off.
Please explain.

> This approach works as in practice all boot-time present DIMMs are TDX
> convertible memory.  However, if any non-TDX-convertible memory has been
> hot-added (i.e. CXL memory via kmem driver) before initializing the TDX
> module, the module initialization will fail.

I really don't know what this is trying to say.

*How* and *why* does this module initialization failure occur?  How do
you implement it and why is it necessary?

> This can also be enhanced in the future, i.e. by allowing adding non-TDX
> memory to a separate NUMA node.  In this case, the "TDX-capable" nodes
> and the "non-TDX-capable" nodes can co-exist, but the kernel/userspace
> needs to guarantee memory pages for TDX guests are always allocated from
> the "TDX-capable" nodes.

Why does it need to be enhanced?  What's the problem?

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
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 216fee7144ee..3a841a77fda4 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -1174,6 +1174,8 @@ void __init setup_arch(char **cmdline_p)
>  	 *
>  	 * Moreover, on machines with SandyBridge graphics or in setups that use
>  	 * crashkernel the entire 1M is reserved anyway.
> +	 *
> +	 * Note the host kernel TDX also requires the first 1MB being reserved.
>  	 */
>  	reserve_real_mode();
>  
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 6fe505c32599..f010402f443d 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -13,6 +13,13 @@
>  #include <linux/errno.h>
>  #include <linux/printk.h>
>  #include <linux/mutex.h>
> +#include <linux/list.h>
> +#include <linux/slab.h>
> +#include <linux/memblock.h>
> +#include <linux/memory.h>
> +#include <linux/minmax.h>
> +#include <linux/sizes.h>
> +#include <linux/pfn.h>
>  #include <asm/pgtable_types.h>
>  #include <asm/msr.h>
>  #include <asm/tdx.h>
> @@ -25,6 +32,12 @@ enum tdx_module_status_t {
>  	TDX_MODULE_ERROR
>  };
>  
> +struct tdx_memblock {
> +	struct list_head list;
> +	unsigned long start_pfn;
> +	unsigned long end_pfn;
> +};
> +
>  static u32 tdx_keyid_start __ro_after_init;
>  static u32 nr_tdx_keyids __ro_after_init;
>  
> @@ -32,6 +45,9 @@ static enum tdx_module_status_t tdx_module_status;
>  /* Prevent concurrent attempts on TDX detection and initialization */
>  static DEFINE_MUTEX(tdx_module_lock);
>  
> +/* All TDX-usable memory regions */
> +static LIST_HEAD(tdx_memlist);
> +
>  /*
>   * tdx_keyid_start and nr_tdx_keyids indicate that TDX is uninitialized.
>   * This is used in TDX initialization error paths to take it from
> @@ -69,6 +85,50 @@ static int __init record_keyid_partitioning(void)
>  	return 0;
>  }
>  
> +static bool is_tdx_memory(unsigned long start_pfn, unsigned long end_pfn)
> +{
> +	struct tdx_memblock *tmb;
> +
> +	/* Empty list means TDX isn't enabled. */
> +	if (list_empty(&tdx_memlist))
> +		return true;
> +
> +	list_for_each_entry(tmb, &tdx_memlist, list) {
> +		/*
> +		 * The new range is TDX memory if it is fully covered by
> +		 * any TDX memory block.
> +		 *
> +		 * Note TDX memory blocks are originated from memblock
> +		 * memory regions, which can only be contiguous when two
> +		 * regions have different NUMA nodes or flags.  Therefore
> +		 * the new range cannot cross multiple TDX memory blocks.
> +		 */
> +		if (start_pfn >= tmb->start_pfn && end_pfn <= tmb->end_pfn)
> +			return true;
> +	}
> +	return false;
> +}

I don't really like that comment.  It should first state its behavior
and assumptions, like:

	This check assumes that the start_pfn<->end_pfn range does not
	cross multiple tdx_memlist entries.

Only then should it describe why that is OK:

	A single memory hotplug even across mutliple memblocks (from
	which tdx_memlist entries are derived) is impossible.  ... then
	actually explain



> +static int tdx_memory_notifier(struct notifier_block *nb, unsigned long action,
> +			       void *v)
> +{
> +	struct memory_notify *mn = v;
> +
> +	if (action != MEM_GOING_ONLINE)
> +		return NOTIFY_OK;
> +
> +	/*
> +	 * Not all memory is compatible with TDX.  Reject
> +	 * to online any incompatible memory.
> +	 */

This comment isn't quite right either.  There might actually be totally
TDX *compatible* memory here.  It just wasn't configured for use with TDX.

Shouldn't this be something more like:

	/*
	 * The TDX memory configuration is static and can not be
	 * changed.  Reject onlining any memory which is outside
	 * of the static configuration whether it supports TDX or not.
	 */

> +	return is_tdx_memory(mn->start_pfn, mn->start_pfn + mn->nr_pages) ?
> +		NOTIFY_OK : NOTIFY_BAD;
> +}
> +
> +static struct notifier_block tdx_memory_nb = {
> +	.notifier_call = tdx_memory_notifier,
> +};
> +
>  static int __init tdx_init(void)
>  {
>  	int err;
> @@ -89,6 +149,13 @@ static int __init tdx_init(void)
>  		goto no_tdx;
>  	}
>  
> +	err = register_memory_notifier(&tdx_memory_nb);
> +	if (err) {
> +		pr_info("initialization failed: register_memory_notifier() failed (%d)\n",
> +				err);
> +		goto no_tdx;
> +	}
> +
>  	return 0;
>  no_tdx:
>  	clear_tdx();
> @@ -209,6 +276,77 @@ static int tdx_get_sysinfo(struct tdsysinfo_struct *sysinfo,
>  	return 0;
>  }
>  
> +/*
> + * Add a memory region as a TDX memory block.  The caller must make sure
> + * all memory regions are added in address ascending order and don't
> + * overlap.
> + */
> +static int add_tdx_memblock(struct list_head *tmb_list, unsigned long start_pfn,
> +			    unsigned long end_pfn)
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
> +
> +	list_add_tail(&tmb->list, tmb_list);
> +	return 0;
> +}
> +
> +static void free_tdx_memlist(struct list_head *tmb_list)
> +{
> +	while (!list_empty(tmb_list)) {
> +		struct tdx_memblock *tmb = list_first_entry(tmb_list,
> +				struct tdx_memblock, list);
> +
> +		list_del(&tmb->list);
> +		kfree(tmb);
> +	}
> +}

'tdx_memlist' is written only once at boot and then is read-only, right?

It might be nice to mention that so that the lack of locking doesn't
look problematic.

> +/*
> + * Ensure that all memblock memory regions are convertible to TDX
> + * memory.  Once this has been established, stash the memblock
> + * ranges off in a secondary structure because memblock is modified
> + * in memory hotplug while TDX memory regions are fixed.
> + */

Ahh, that's why we need to "shadow" the memblocks.  Can you add a
sentence on this to the changelog, please?

> +static int build_tdx_memlist(struct list_head *tmb_list)
> +{
> +	unsigned long start_pfn, end_pfn;
> +	int i, ret;
> +
> +	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
> +		/*
> +		 * The first 1MB is not reported as TDX convertible memory.
> +		 * Although the first 1MB is always reserved and won't end up
> +		 * to the page allocator, it is still in memblock's memory
> +		 * regions.  Skip them manually to exclude them as TDX memory.
> +		 */
> +		start_pfn = max(start_pfn, PHYS_PFN(SZ_1M));
> +		if (start_pfn >= end_pfn)
> +			continue;
> +
> +		/*
> +		 * Add the memory regions as TDX memory.  The regions in
> +		 * memblock has already guaranteed they are in address
> +		 * ascending order and don't overlap.
> +		 */
> +		ret = add_tdx_memblock(tmb_list, start_pfn, end_pfn);
> +		if (ret)
> +			goto err;
> +	}
> +
> +	return 0;
> +err:
> +	free_tdx_memlist(tmb_list);
> +	return ret;
> +}
> +
>  static int init_tdx_module(void)
>  {
>  	/*
> @@ -226,10 +364,25 @@ static int init_tdx_module(void)
>  	if (ret)
>  		goto out;
>  
> +	/*
> +	 * The initial support of TDX guests only allocates memory from
> +	 * the global page allocator.  To keep things simple, just make
> +	 * sure all pages in the page allocator are TDX memory.

I didn't like this in the changelog either.  Try to make this "timeless"
rather than refer to what the support is today.  I gave you example text
above.

> +	 * Build the list of "TDX-usable" memory regions which cover all
> +	 * pages in the page allocator to guarantee that.  Do it while
> +	 * holding mem_hotplug_lock read-lock as the memory hotplug code
> +	 * path reads the @tdx_memlist to reject any new memory.
> +	 */
> +	get_online_mems();

Oh, it actually uses the memory hotplug locking for list protection.
That's at least a bit subtle.  Please document that somewhere in the
functions that actually manipulate the list.

I think it's also worth saying something here about the high-level
effects of what's going on:

	Take a snapshot of the memory configuration (memblocks).  This
	snapshot will be used to enable TDX support for *this* memory
	configuration only.  Use a memory hotplug notifier to ensure
	that no other RAM can be added outside of this configuration.

That's it, right?

> +	ret = build_tdx_memlist(&tdx_memlist);
> +	if (ret)
> +		goto out;
> +
>  	/*
>  	 * TODO:
>  	 *
> -	 *  - Build the list of TDX-usable memory regions.
>  	 *  - Construct a list of TDMRs to cover all TDX-usable memory
>  	 *    regions.
>  	 *  - Pick up one TDX private KeyID as the global KeyID.
> @@ -241,6 +394,11 @@ static int init_tdx_module(void)
>  	 */
>  	ret = -EINVAL;
>  out:
> +	/*
> +	 * @tdx_memlist is written here and read at memory hotplug time.
> +	 * Lock out memory hotplug code while building it.
> +	 */
> +	put_online_mems();
>  	return ret;
>  }

You would also be wise to have the folks who do a lot of memory hotplug
work today look at this sooner rather than later.  I _think_ what you
have here is OK, but I'm really rusty on the code itself.

