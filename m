Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D37D513918
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 17:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349703AbiD1P6F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 11:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349667AbiD1P55 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 11:57:57 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C6AB8990;
        Thu, 28 Apr 2022 08:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651161281; x=1682697281;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=y2WRmsQXcd3xlyIXkddtSdg2cP/2JpuMmU3NcHXZDL4=;
  b=mx1IgZWhgsg0VdAC4hLARauakiCo4FxY0i91bbiabrMx7YM8sVL65gKU
   xOr2LDAuljSQz3c2qH207WmY9ACvwU1nkYJRuXGCHPjNxLKqb69rSdj9q
   mFj9mBTe9Fabp/3WtzmFyCylAsb6MqDFkJt/Pr2FzWmQ/iM1I53lYZuH2
   5nfKmWbSP4oee/I3XudfSdXyvo1PrktcHRGpDtIZa8uvTx7Nq+tVMwEtL
   a+L+BC14vpd+qcbCG9czNiCBJlbW8PuRtaj9HmrcsrsXrMJYBKvnNJLNh
   9gboskS4OjOipbCMRks7I+BFeucXIXzfBG+w0Aq6HRb4MgRaiHkbO32vT
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="266147508"
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="266147508"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 08:54:40 -0700
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="559741839"
Received: from mpoursae-mobl2.amr.corp.intel.com (HELO [10.212.0.84]) ([10.212.0.84])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 08:54:39 -0700
Message-ID: <37ba3fa2-06a1-9fd1-a158-d56d2453b30c@intel.com>
Date:   Thu, 28 Apr 2022 08:54:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 11/21] x86/virt/tdx: Choose to use all system RAM as
 TDX memory
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
 <dee8fb1cc2ab79cf80d4718405069715b0d51235.1649219184.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <dee8fb1cc2ab79cf80d4718405069715b0d51235.1649219184.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/5/22 21:49, Kai Huang wrote:
> As one step of initializing the TDX module, the memory regions that the
> TDX module can use must be configured to it via an array of 'TD Memory

"can use must be"?

> Regions' (TDMR).  The kernel is responsible for choosing which memory
> regions to be used as TDX memory and building the array of TDMRs to
> cover those memory regions.
> 
> The first generation of TDX-capable platforms basically guarantees all
> system RAM regions during machine boot are Convertible Memory Regions
> (excluding the memory below 1MB) and can be used by TDX.  The memory
> pages allocated to TD guests can be any pages managed by the page
> allocator.  To avoid having to modify the page allocator to distinguish
> TDX and non-TDX memory allocation, adopt a simple policy to use all
> system RAM regions as TDX memory.  The low 1MB pages are excluded from
> TDX memory since they are not in CMRs in some platforms (those pages are
> reserved at boot time and won't be managed by page allocator anyway).
> 
> This policy could be revised later if future TDX generations break
> the guarantee or when the size of the metadata (~1/256th of the size of
> the TDX usable memory) becomes a concern.  At that time a CMR-aware
> page allocator may be necessary.

Remember that you have basically three or four short sentences to get a
reviewer's attention.  There's a lot of noise in that changelog.  Can
you trim it down or at least make the first bit less jargon-packed and
more readable?

> Also, on the first generation of TDX-capable machine, the system RAM
> ranges discovered during boot time are all memory regions that kernel
> can use during its runtime.  This is because the first generation of TDX
> architecturally doesn't support ACPI memory hotplug 

"Architecturally" usually means: written down and agreed to by hardware
and software alike.  Is this truly written down somewhere?  I don't
recall seeing it in the architecture documents.

I fear this is almost the _opposite_ of architecture: it's basically a
fortunate coincidence.

> (CMRs are generated
> during machine boot and are static during machine's runtime).  Also, the
> first generation of TDX-capable platform doesn't support TDX and ACPI
> memory hotplug at the same time on a single machine.  Another case of
> memory hotplug is user may use NVDIMM as system RAM via kmem driver.
> But the first generation of TDX-capable machine doesn't support TDX and
> NVDIMM simultaneously, therefore in practice it cannot happen.  One
> special case is user may use 'memmap' kernel command line to reserve
> part of system RAM as x86 legacy PMEMs, and user can theoretically add
> them as system RAM via kmem driver.  This can be resolved by always
> treating legacy PMEMs as TDX memory.

Again, there's a ton of noise here.  I'm struggling to get the point.

> Implement a helper to loop over all RAM entries in e820 table to find
> all system RAM ranges, as a preparation to covert all of them to TDX
> memory.  Use 'e820_table', rather than 'e820_table_firmware' to honor
> 'mem' and 'memmap' command lines. 

*How* does this honor them?  For instance, if I do mem=4G, will the TDX
code limit itself to converting 4GB for TDX?

> Following e820__memblock_setup(),
> both E820_TYPE_RAM and E820_TYPE_RESERVED_KERN types are treated as TDX
> memory, and contiguous ranges in the same NUMA node are merged together.

Again, you're just rehashing the code's logic in English.  That's not
what a changelog is for.

> One difference is, as mentioned above, x86 legacy PMEMs (E820_TYPE_PRAM)
> are also always treated as TDX memory.  They are underneath RAM, and
> they could be used as TD guest memory.  Always including them as TDX
> memory also avoids having to modify memory hotplug code to handle adding
> them as system RAM via kmem driver.

I think you can replace virtually this entire changelog with the following:

	Consider a wide variety of e820 entries as RAM.  This ensures
	that any RAM that might *possibly* end up being used for TDX is
	fully converted.  If the selection here was more conservative,
	it might lead to errors adding memory to TDX guests at runtime
	which would be very hard to handle.

> To begin with, sanity check all memory regions found in e820 are fully
> covered by any CMR and can be used as TDX memory.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>  arch/x86/Kconfig            |   1 +
>  arch/x86/virt/vmx/tdx/tdx.c | 228 +++++++++++++++++++++++++++++++++++-
>  2 files changed, 228 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 9113bf09f358..7414625b938f 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1972,6 +1972,7 @@ config INTEL_TDX_HOST
>  	default n
>  	depends on CPU_SUP_INTEL
>  	depends on X86_64
> +	select NUMA_KEEP_MEMINFO if NUMA
>  	help
>  	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
>  	  host and certain physical attacks.  This option enables necessary TDX

*This* NUMA_KEEP_MEMINFO thing is exactly what you should talk about in
the changelog.  Add a sentence telling us why it is needed, or add a
good comment.

> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index ec27350d53c1..6b0c51aaa7f2 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -14,11 +14,13 @@
>  #include <linux/smp.h>
>  #include <linux/atomic.h>
>  #include <linux/slab.h>
> +#include <linux/math.h>
>  #include <asm/msr-index.h>
>  #include <asm/msr.h>
>  #include <asm/cpufeature.h>
>  #include <asm/cpufeatures.h>
>  #include <asm/virtext.h>
> +#include <asm/e820/api.h>
>  #include <asm/tdx.h>
>  #include "tdx.h"
>  
> @@ -595,6 +597,222 @@ static int tdx_get_sysinfo(void)
>  	return sanitize_cmrs(tdx_cmr_array, cmr_num);
>  }
>  
> +/* Check whether one e820 entry is RAM and could be used as TDX memory */
> +static bool e820_entry_is_ram(struct e820_entry *entry)

It's not "is RAM" it's "might be used for TDX".

> +{
> +	/*
> +	 * Besides E820_TYPE_RAM, E820_TYPE_RESERVED_KERN type entries
> +	 * are also treated as TDX memory as they are also added to
> +	 * memblock.memory in e820__memblock_setup().

"are also treated" is really passive language.  Make it imperative voice:

	Treat E820_TYPE_RESERVED_KERN entries as possible TDX memory in
	addition to E820_TYPE_RAM.

I'm also not sure I buy the argument about E820_TYPE_RESERVED_KERN.  I
don't understand the implications of it being added to memblock.memory.

> +	 * E820_TYPE_SOFT_RESERVED type entries are excluded as they are
> +	 * marked as reserved and are not later freed to page allocator
> +	 * (only part of kernel image, initrd, etc are freed to page
> +	 * allocator).

Again, not "are excluded".  Make it: "Exclude E820_TYPE_SOFT_RESERVED
type entries ..."

Let's also look at the comments for E820_TYPE_SOFT_RESERVED:

>         /*
>          * Special-purpose memory is indicated to the system via the
>          * EFI_MEMORY_SP attribute. Define an e820 translation of this
>          * memory type for the purpose of reserving this range and
>          * marking it with the IORES_DESC_SOFT_RESERVED designation.
>          */
>         E820_TYPE_SOFT_RESERVED = 0xefffffff,

What makes you think this can never be freed back into the page allocator?


> +	 * Also unconditionally treat x86 legacy PMEMs (E820_TYPE_PRAM)
> +	 * as TDX memory since they are RAM underneath, and could be used
> +	 * as TD guest memory.
> +	 */
> +	return (entry->type == E820_TYPE_RAM) ||
> +		(entry->type == E820_TYPE_RESERVED_KERN) ||
> +		(entry->type == E820_TYPE_PRAM);
> +}

I really dislike how you did this.

Imagine it was:

	/* Plain old RAM, obviously needs TDX protection: */
	if (entry->type == E820_TYPE_RAM)
		return true;
	
	/*
	 * Talk specifically about E820_TYPE_RESERVED_KERN ...
	 */
	if (entry->type == E820_TYPE_RESERVED_KERN)
		return true;

See how that actually puts the comment close to the code that is
relevant to the comment?  It's way better than one massive, rambling
comment that isn't obviously connected to one of the code lines that
follows.

> +/*
> + * The low memory below 1MB is not covered by CMRs on some TDX platforms.
> + * In practice, this range cannot be used for guest memory because it is
> + * not managed by the page allocator due to boot-time reservation.  Just
> + * skip the low 1MB so this range won't be treated as TDX memory.

I'm going to steal a tglx term: word salad.  This patch set is full of
word salad.

If, in practice, this memory couldn't be used for TDX guests, we
wouldn't need to do anything here.  So, what's this code doing?

Are you saying that under no circumstances can memory <1MB get stuck in
ZONE_DMA and might end up getting used as TDX memory?

> + * Return true if the e820 entry is completely skipped, in which case
> + * caller should ignore this entry.  Otherwise the actual memory range
> + * after skipping the low 1MB is returned via @start and @end.
> + */
> +static bool e820_entry_skip_lowmem(struct e820_entry *entry, u64 *start,
> +				   u64 *end)
> +{
> +	u64 _start = entry->addr;
> +	u64 _end = entry->addr + entry->size;
> +
> +	if (_start < SZ_1M)
> +		_start = SZ_1M;
> +
> +	*start = _start;
> +	*end = _end;
> +
> +	return _start >= _end;
> +}

I see (barely) how this is excluding the lower 1MB from being used

> +/*
> + * Trim away non-page-aligned memory at the beginning and the end for a
> + * given region.  Return true when there are still pages remaining after
> + * trimming, and the trimmed region is returned via @start and @end.
> + */
> +static bool e820_entry_trim(u64 *start, u64 *end)
> +{
> +	u64 s, e;
> +
> +	s = round_up(*start, PAGE_SIZE);
> +	e = round_down(*end, PAGE_SIZE);
> +
> +	if (s >= e)
> +		return false;
> +
> +	*start = s;
> +	*end = e;
> +
> +	return true;
> +}
> +
> +/*
> + * Get the next memory region (excluding low 1MB) in e820.  @idx points
> + * to the entry to start to walk with.  Multiple memory regions in the
> + * same NUMA node that are contiguous are merged together (following
> + * e820__memblock_setup()).  The merged range is returned via @start and
> + * @end.  After return, @idx points to the next entry of the last RAM
> + * entry that has been walked, or table->nr_entries (indicating all
> + * entries in the e820 table have been walked).
> + */
> +static void e820_next_mem(struct e820_table *table, int *idx, u64 *start,
> +			  u64 *end)
> +{
> +	u64 rs, re;

Please give these real variable names.

> +	int rnid, i;
> +
> +again:
> +	rs = re = 0;
> +	for (i = *idx; i < table->nr_entries; i++) {
> +		struct e820_entry *entry = &table->entries[i];
> +		u64 s, e;
> +		int nid;
> +
> +		if (!e820_entry_is_ram(entry))
> +			continue;
> +
> +		if (e820_entry_skip_lowmem(entry, &s, &e))
> +			continue;
> +
> +		/*
> +		 * Found the first RAM entry.  Record it and keep
> +		 * looping to find other RAM entries that can be
> +		 * merged.
> +		 */
> +		if (!rs) {
> +			rs = s;
> +			re = e;
> +			rnid = phys_to_target_node(rs);
> +			if (WARN_ON_ONCE(rnid == NUMA_NO_NODE))
> +				rnid = 0;
> +			continue;
> +		}
> +
> +		/*
> +		 * Try to merge with previous RAM entry.  E820 entries
> +		 * are not necessarily page aligned.  For instance, the
> +		 * setup_data elements in boot_params are marked as
> +		 * E820_TYPE_RESERVED_KERN, and they may not be page
> +		 * aligned.  In e820__memblock_setup() all adjancent

							     ^ adjacent

Kai, please make sure to fire up your editor's spell checker.  My mail
client has one, so I'll catch all of these.  You might as well do it too.
		
> +		 * memory regions within the same NUMA node are merged to
> +		 * a single one, and the non-page-aligned parts (at the
> +		 * beginning and the end) are trimmed.  Follow the same
> +		 * rule here.
> +		 */
> +		nid = phys_to_target_node(s);
> +		if (WARN_ON_ONCE(nid == NUMA_NO_NODE))
> +			nid = 0;
> +		if ((nid == rnid) && (s == re)) {
> +			/* Merge with previous range and update the end */
> +			re = e;
> +			continue;
> +		}
> +
> +		/*
> +		 * Stop if current entry cannot be merged with previous
> +		 * one (or more) entries.
> +		 */
> +		break;
> +	}
> +
> +	/*
> +	 * @i is either the RAM entry that cannot be merged with previous
> +	 * one (or more) entries, or table->nr_entries.
> +	 */
> +	*idx = i;
> +	/*
> +	 * Trim non-page-aligned parts of [@rs, @re), which is either a
> +	 * valid memory region, or empty.  If there's nothing left after
> +	 * trimming and there are still entries that have not been
> +	 * walked, continue to walk.
> +	 */
> +	if (!e820_entry_trim(&rs, &re) && i < table->nr_entries)
> +		goto again;
> +
> +	*start = rs;
> +	*end = re;
> +}
> +
> +/*
> + * Helper to loop all e820 RAM entries with low 1MB excluded
> + * in a given e820 table.
> + */
> +#define _e820_for_each_mem(_table, _i, _start, _end)				\
> +	for ((_i) = 0, e820_next_mem((_table), &(_i), &(_start), &(_end));	\
> +		(_start) < (_end);						\
> +		e820_next_mem((_table), &(_i), &(_start), &(_end)))
> +
> +/*
> + * Helper to loop all e820 RAM entries with low 1MB excluded
> + * in kernel modified 'e820_table' to honor 'mem' and 'memmap' kernel
> + * command lines.
> + */
> +#define e820_for_each_mem(_i, _start, _end)	\
> +	_e820_for_each_mem(e820_table, _i, _start, _end)

This effectively adds a bunch of private, well-hidden e820 munging.  I'm
a bit surprised that this is all added code and doesn't reuse or
refactor a single line of the existing e820 code.

Also, this needs to throw away memory. But, it's happening much later in
boot, like when the first TD is launched.  Isn't this too late for e820
changes to affect what goes into the page allocator?

> +/* Check whether first range is the subrange of the second */
> +static bool is_subrange(u64 r1_start, u64 r1_end, u64 r2_start, u64 r2_end)
> +{
> +	return (r1_start >= r2_start && r1_end <= r2_end) ? true : false;
> +}

Why is this bothering with the ?: form?

Won't this:

	return (r1_start >= r2_start && r1_end <= r2_end);

do *precisely* the same thing?


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
> +/* Sanity check whether all e820 RAM entries are fully covered by CMRs. */
> +static int e820_check_against_cmrs(void)
> +{
> +	u64 start, end;
> +	int i;
> +
> +	/*
> +	 * Loop over e820_table to find all RAM entries and check
> +	 * whether they are all fully covered by any CMR.
> +	 */
> +	e820_for_each_mem(i, start, end) {
> +		if (!range_covered_by_cmr(tdx_cmr_array, tdx_cmr_num,
> +					start, end)) {
> +			pr_err("[0x%llx, 0x%llx) is not fully convertible memory\n",
> +					start, end);
> +			return -EFAULT;
> +		}
> +	}
> +
> +	return 0;
> +}

This is actively going out and modifying the e820, right?  That isn't
obvious at all.
