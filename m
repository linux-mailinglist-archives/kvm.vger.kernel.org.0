Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D089069577B
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 04:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbjBNDbh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 22:31:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjBNDbf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 22:31:35 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0753212F15;
        Mon, 13 Feb 2023 19:31:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676345494; x=1707881494;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=h8vSEunUCkIDLpchxypoFi6ckHDJGlGkbWFQNf1sOXo=;
  b=gv/8CpRrzRDE/2yiPqEV3VVHM6bikiN1lrlIxzy3bP2h+t5Cn0xcj/an
   l9z/PlGBodr46SDlyVx1PiqsdGQIPUZeuqg75JIqkxHG/ZFvzfldKuJrV
   SPV5G2FWy0JZf0bia+YQ1Gusd1UA9xqXD92h9wWSBM5UQBjAbWGoszw+f
   IgjiSQ67FMa9l/AkLeNUgn81ZUsRUggW/5QihNQkMUX0WRXHE8d2tnWj+
   R1QsXvffmmMD6TkPf59RPLhv45M76GQfT/riSnrLggdVeaNj1+BAJ3NRu
   6e0w9NJn4gIYAnetc9UXg3rE3oN8po7RGersH+HSu5wXu5H7gaCuCGGMo
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="319098001"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="319098001"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 19:31:33 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="792964531"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="792964531"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.238.208.55])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 19:31:27 -0800
From:   "Huang, Ying" <ying.huang@intel.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-mm@kvack.org>, <dave.hansen@intel.com>,
        <peterz@infradead.org>, <tglx@linutronix.de>, <seanjc@google.com>,
        <pbonzini@redhat.com>, <dan.j.williams@intel.com>,
        <rafael.j.wysocki@intel.com>, <kirill.shutemov@linux.intel.com>,
        <reinette.chatre@intel.com>, <len.brown@intel.com>,
        <tony.luck@intel.com>, <ak@linux.intel.com>,
        <isaku.yamahata@intel.com>, <chao.gao@intel.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>, <david@redhat.com>,
        <bagasdotme@gmail.com>, <sagis@google.com>, <imammedo@redhat.com>
Subject: Re: [PATCH v9 09/18] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
References: <cover.1676286526.git.kai.huang@intel.com>
        <d7696a456000a37d0059a885c8b197915773980a.1676286526.git.kai.huang@intel.com>
Date:   Tue, 14 Feb 2023 11:30:29 +0800
In-Reply-To: <d7696a456000a37d0059a885c8b197915773980a.1676286526.git.kai.huang@intel.com>
        (Kai Huang's message of "Tue, 14 Feb 2023 00:59:16 +1300")
Message-ID: <871qmsappm.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kai Huang <kai.huang@intel.com> writes:

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
> To keep things simple, assume that all TDX-protected memory will come
> from the page allocator.  Make sure all pages in the page allocator
> *are* TDX-usable memory.
>
> As TDX-usable memory is a fixed configuration, take a snapshot of the
> memory configuration from memblocks at the time of module initialization
> (memblocks are modified on memory hotplug).  This snapshot is used to
> enable TDX support for *this* memory configuration only.  Use a memory
> hotplug notifier to ensure that no other RAM can be added outside of
> this configuration.
>
> This approach requires all memblock memory regions at the time of module
> initialization to be TDX convertible memory to work, otherwise module
> initialization will fail in a later SEAMCALL when passing those regions
> to the module.  This approach works when all boot-time "system RAM" are
> TDX convertible memory, and no non-TDX-convertible memory is hot-added
> to the core-mm before module initialization.
>
> For instance, on the first generation of TDX machines, both CXL memory
> and NVDIMM are not TDX convertible memory.  Using kmem driver to hot-add
> any CXL memory or NVDIMM to the core-mm before module initialization
> will result in module fail to initialize.  The SEAMCALL error code will
> be available in the dmesg to help user to understand the failure.
>
> Signed-off-by: Kai Huang <kai.huang@intel.com>

Looks good to me!  Thanks!

Reviewed-by: "Huang, Ying" <ying.huang@intel.com>

> ---
>
> v8 -> v9:
>  - Replace "The initial support ..." with timeless sentence in both
>    changelog and comments(Dave).
>  - Fix run-on sentence in changelog, and senstence to explain why to
>    stash off memblock (Dave).
>  - Tried to improve why to choose this approach and how it work in
>    changelog based on Dave's suggestion.
>  - Many other comments enhancement (Dave).
>
> v7 -> v8:
>  - Trimed down changelog (Dave).
>  - Changed to use PHYS_PFN() and PFN_PHYS() throughout this series
>    (Ying).
>  - Moved memory hotplug handling from add_arch_memory() to
>    memory_notifier (Dan/David).
>  - Removed 'nid' from 'struct tdx_memblock' to later patch (Dave).
>  - {build|free}_tdx_memory() -> {build|}free_tdx_memlist() (Dave).
>  - Removed pfn_covered_by_cmr() check as no code to trim CMRs now.
>  - Improve the comment around first 1MB (Dave).
>  - Added a comment around reserve_real_mode() to point out TDX code
>    relies on first 1MB being reserved (Ying).
>  - Added comment to explain why the new online memory range cannot
>    cross multiple TDX memory blocks (Dave).
>  - Improved other comments (Dave).
>
> ---
>  arch/x86/Kconfig            |   1 +
>  arch/x86/kernel/setup.c     |   2 +
>  arch/x86/virt/vmx/tdx/tdx.c | 159 +++++++++++++++++++++++++++++++++++-
>  arch/x86/virt/vmx/tdx/tdx.h |   6 ++
>  4 files changed, 167 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 6dd5d5586099..f23bc540778a 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1958,6 +1958,7 @@ config INTEL_TDX_HOST
>  	depends on X86_64
>  	depends on KVM_INTEL
>  	depends on X86_X2APIC
> +	select ARCH_KEEP_MEMBLOCK
>  	help
>  	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
>  	  host and certain physical attacks.  This option enables necessary TDX
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 88188549647c..a8a119a9b48c 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -1165,6 +1165,8 @@ void __init setup_arch(char **cmdline_p)
>  	 *
>  	 * Moreover, on machines with SandyBridge graphics or in setups that use
>  	 * crashkernel the entire 1M is reserved anyway.
> +	 *
> +	 * Note the host kernel TDX also requires the first 1MB being reserved.
>  	 */
>  	x86_platform.realmode_reserve();
>  
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index ae8e59294b46..5101b636a9b0 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -15,6 +15,13 @@
>  #include <linux/mutex.h>
>  #include <linux/cpumask.h>
>  #include <linux/cpu.h>
> +#include <linux/list.h>
> +#include <linux/slab.h>
> +#include <linux/memblock.h>
> +#include <linux/memory.h>
> +#include <linux/minmax.h>
> +#include <linux/sizes.h>
> +#include <linux/pfn.h>
>  #include <asm/msr-index.h>
>  #include <asm/msr.h>
>  #include <asm/page.h>
> @@ -33,6 +40,9 @@ static DEFINE_MUTEX(tdx_module_lock);
>  static cpumask_t __cpu_tdx_mask;
>  static cpumask_t *cpu_tdx_mask = &__cpu_tdx_mask;
>  
> +/* All TDX-usable memory regions.  Protected by mem_hotplug_lock. */
> +static LIST_HEAD(tdx_memlist);
> +
>  /*
>   * Use tdx_global_keyid to indicate that TDX is uninitialized.
>   * This is used in TDX initialization error paths to take it from
> @@ -71,6 +81,51 @@ static int __init record_keyid_partitioning(u32 *tdx_keyid_start,
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
> +	/*
> +	 * This check assumes that the start_pfn<->end_pfn range does not
> +	 * cross multiple @tdx_memlist entries.  A single memory online
> +	 * event across multiple memblocks (from which @tdx_memlist
> +	 * entries are derived at the time of module initialization) is
> +	 * not possible.  This is because memory offline/online is done
> +	 * on granularity of 'struct memory_block', and the hotpluggable
> +	 * memory region (one memblock) must be multiple of memory_block.
> +	 */
> +	list_for_each_entry(tmb, &tdx_memlist, list) {
> +		if (start_pfn >= tmb->start_pfn && end_pfn <= tmb->end_pfn)
> +			return true;
> +	}
> +	return false;
> +}
> +
> +static int tdx_memory_notifier(struct notifier_block *nb, unsigned long action,
> +			       void *v)
> +{
> +	struct memory_notify *mn = v;
> +
> +	if (action != MEM_GOING_ONLINE)
> +		return NOTIFY_OK;
> +
> +	/*
> +	 * The TDX memory configuration is static and can not be
> +	 * changed.  Reject onlining any memory which is outside of
> +	 * the static configuration whether it supports TDX or not.
> +	 */
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
>  	u32 tdx_keyid_start, nr_tdx_keyids;
> @@ -101,6 +156,13 @@ static int __init tdx_init(void)
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
>  	tdx_guest_keyid_start = tdx_keyid_start;
>  	tdx_nr_guest_keyids = nr_tdx_keyids;
>  
> @@ -288,6 +350,79 @@ static int tdx_get_sysinfo(struct tdsysinfo_struct *sysinfo,
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
> +	/* @tmb_list is protected by mem_hotplug_lock */
> +	list_add_tail(&tmb->list, tmb_list);
> +	return 0;
> +}
> +
> +static void free_tdx_memlist(struct list_head *tmb_list)
> +{
> +	/* @tmb_list is protected by mem_hotplug_lock */
> +	while (!list_empty(tmb_list)) {
> +		struct tdx_memblock *tmb = list_first_entry(tmb_list,
> +				struct tdx_memblock, list);
> +
> +		list_del(&tmb->list);
> +		kfree(tmb);
> +	}
> +}
> +
> +/*
> + * Ensure that all memblock memory regions are convertible to TDX
> + * memory.  Once this has been established, stash the memblock
> + * ranges off in a secondary structure because memblock is modified
> + * in memory hotplug while TDX memory regions are fixed.
> + */
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
>  	static DECLARE_PADDED_STRUCT(tdsysinfo_struct, tdsysinfo,
> @@ -326,10 +461,25 @@ static int init_tdx_module(void)
>  	if (ret)
>  		goto out;
>  
> +	/*
> +	 * To keep things simple, assume that all TDX-protected memory
> +	 * will come from the page allocator.  Make sure all pages in the
> +	 * page allocator are TDX-usable memory.
> +	 *
> +	 * Build the list of "TDX-usable" memory regions which cover all
> +	 * pages in the page allocator to guarantee that.  Do it while
> +	 * holding mem_hotplug_lock read-lock as the memory hotplug code
> +	 * path reads the @tdx_memlist to reject any new memory.
> +	 */
> +	get_online_mems();
> +
> +	ret = build_tdx_memlist(&tdx_memlist);
> +	if (ret)
> +		goto out;
> +
>  	/*
>  	 * TODO:
>  	 *
> -	 *  - Build the list of TDX-usable memory regions.
>  	 *  - Construct a list of "TD Memory Regions" (TDMRs) to cover
>  	 *    all TDX-usable memory regions.
>  	 *  - Configure the TDMRs and the global KeyID to the TDX module.
> @@ -340,6 +490,12 @@ static int init_tdx_module(void)
>  	 */
>  	ret = -EINVAL;
>  out:
> +	/*
> +	 * @tdx_memlist is written here and read at memory hotplug time.
> +	 * Lock out memory hotplug code while building it.
> +	 */
> +	put_online_mems();
> +
>  	/*
>  	 * Clear @cpu_tdx_mask if module initialization fails before
>  	 * CPU hotplug is re-enabled.  tdx_cpu_online() uses it to check
> @@ -382,6 +538,7 @@ static void disable_tdx_module(void)
>  	 * init_tdx_module().  Remove this comment after
>  	 * all steps are done.
>  	 */
> +	free_tdx_memlist(&tdx_memlist);
>  	cpumask_clear(cpu_tdx_mask);
>  }
>  
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index e32d9920b3a7..edb1d697347f 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -112,6 +112,12 @@ enum tdx_module_status_t {
>  	TDX_MODULE_ERROR
>  };
>  
> +struct tdx_memblock {
> +	struct list_head list;
> +	unsigned long start_pfn;
> +	unsigned long end_pfn;
> +};
> +
>  struct tdx_module_output;
>  u64 __seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
>  	       struct tdx_module_output *out);
