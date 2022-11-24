Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E44B2636FC0
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 02:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiKXBWx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 20:22:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiKXBWv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 20:22:51 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42E814085;
        Wed, 23 Nov 2022 17:22:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669252969; x=1700788969;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ov3gM6ZCCwhqNTBhpitoJjBicObjEBGL3cMa2vU9CU0=;
  b=V9qrmKDKxTdDEWZolOrxJ4CjdlNAwp8TXQwzeICJhaGkUl/XTel4LadF
   vOv/Xc69l4Mu/0WEid8YK1SypSftgb7/SW5A8PEu0wuO2PlxfNE1t7aB0
   CkQsE5ctgCzwfbMmIbjgZiRvlmJhTiQdoF8WoXxGnRN2lazHhcFecXG0C
   /noWKi9dR+nZ3uA1X1/81AuL/bgRW1EwBolWExBfU5+u5Syzu0brt7g9d
   qp+Zh+jWnsEZkarsXmeiVu3sjv1DDqBeco+RuQpAQBydMgiX3/1nOWb3X
   BkhUnyuZnN0kitBUwk2CQGNR2eXvIVGAx8CCXsaIQNGxEe1pvmAe93W3+
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="315343015"
X-IronPort-AV: E=Sophos;i="5.96,189,1665471600"; 
   d="scan'208";a="315343015"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 17:22:49 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="592722554"
X-IronPort-AV: E=Sophos;i="5.96,189,1665471600"; 
   d="scan'208";a="592722554"
Received: from vcbudden-mobl3.amr.corp.intel.com (HELO [10.212.129.67]) ([10.212.129.67])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 17:22:48 -0800
Message-ID: <8e6803f5-bec6-843d-f3c4-75006ffd0d2f@intel.com>
Date:   Wed, 23 Nov 2022 17:22:48 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 10/20] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
 <9b545148275b14a8c7edef1157f8ec44dc8116ee.1668988357.git.kai.huang@intel.com>
 <eb8d0f69-7ada-a358-46ea-da15a3aeac93@intel.com>
 <a937612630e149faea2552deab5ea81a836bbd4f.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <a937612630e149faea2552deab5ea81a836bbd4f.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/23/22 17:04, Huang, Kai wrote:
> On Tue, 2022-11-22 at 16:21 -0800, Dave Hansen wrote:
>>> +struct tdx_memblock {
>>> +   struct list_head list;
>>> +   unsigned long start_pfn;
>>> +   unsigned long end_pfn;
>>> +   int nid;
>>> +};
>>
>> Why does the nid matter?
> 
> It is used to find the node for the PAMT allocation for a given TDMR.

... which is in this patch?

You can't just plop unused and unmentioned nuggets in the code.  Remove
it until it is needed.


>>> +/* Check whether the given pfn range is covered by any CMR or not. */
>>> +static bool pfn_range_covered_by_cmr(unsigned long start_pfn,
>>> +                                unsigned long end_pfn)
>>> +{
>>> +   int i;
>>> +
>>> +   for (i = 0; i < tdx_cmr_num; i++) {
>>> +           struct cmr_info *cmr = &tdx_cmr_array[i];
>>> +           unsigned long cmr_start_pfn;
>>> +           unsigned long cmr_end_pfn;
>>> +
>>> +           cmr_start_pfn = cmr->base >> PAGE_SHIFT;
>>> +           cmr_end_pfn = (cmr->base + cmr->size) >> PAGE_SHIFT;
>>> +
>>> +           if (start_pfn >= cmr_start_pfn && end_pfn <= cmr_end_pfn)
>>> +                   return true;
>>> +   }
>>
>> What if the pfn range overlaps two CMRs?  It will never pass any
>> individual overlap test and will return false.
> 
> We can only return true if the two CMRs are contiguous.
> 
> I cannot think out a reason that a reasonable BIOS could generate contiguous
> CMRs.

Because it can?

We don't just try and randomly assign what we think is reasonable or
not.  First and foremost, we need to ask whether the configuration in
question is allowed by the spec.

Would it be a *valid* thing to have two adjacent CMRs?  Does the TDX
module spec disallow it?

> Perhaps one reason is two contiguous NUMA nodes?  For this case, memblock
> has made sure no memory region could cross NUMA nodes, so the start_pfn/end_pfn
> here should always be within one node.  Perhaps we can add a comment for this
> case?

<cough> numa=off <cough>

> Anyway I am not sure whether it is worth to consider "contiguous CMRs" case.

I am sure.  You need to consider it.

>>> + * and don't overlap.
>>> + */
>>> +static int add_tdx_memblock(unsigned long start_pfn, unsigned long end_pfn,
>>> +                       int nid)
>>> +{
>>> +   struct tdx_memblock *tmb;
>>> +
>>> +   tmb = kmalloc(sizeof(*tmb), GFP_KERNEL);
>>> +   if (!tmb)
>>> +           return -ENOMEM;
>>> +
>>> +   INIT_LIST_HEAD(&tmb->list);
>>> +   tmb->start_pfn = start_pfn;
>>> +   tmb->end_pfn = end_pfn;
>>> +   tmb->nid = nid;
>>> +
>>> +   list_add_tail(&tmb->list, &tdx_memlist);
>>> +   return 0;
>>> +}
>>> +
>>> +static void free_tdx_memory(void)
>>
>> This is named a bit too generically.  How about free_tdx_memlist() or
>> something?
> 
> Will use free_tdx_memlist().  Do you want to also change build_tdx_memory() to
> build_tdx_memlist()?

Does it build a memlist?

>>> +{
>>> +   while (!list_empty(&tdx_memlist)) {
>>> +           struct tdx_memblock *tmb = list_first_entry(&tdx_memlist,
>>> +                           struct tdx_memblock, list);
>>> +
>>> +           list_del(&tmb->list);
>>> +           kfree(tmb);
>>> +   }
>>> +}
>>> +
>>> +/*
>>> + * Add all memblock memory regions to the @tdx_memlist as TDX memory.
>>> + * Must be called when get_online_mems() is called by the caller.
>>> + */
>>
>> Again, this explains the "what", but not the "why".
>>
>> /*
>>  * Ensure that all memblock memory regions are convertible to TDX
>>  * memory.  Once this has been established, stash the memblock
>>  * ranges off in a secondary structure because $REASONS.
>>  */
>>
>> Which makes me wonder: Why do you even need a secondary structure here?
>> What's wrong with the memblocks themselves?
> 
> One reason is the new region has already been added to memblock before calling
> arch_add_memory(), so we cannot compare the new region against memblock.
> 
> The other  reason is memblock is updated in memory hotplug so it really isn't a
> set of *fixed* memory regions, which TDX requires.  Having TDX's own tdx_memlist
> can support such case: after module initialization, some memory can be hot-
> removed and then hot-added again, because the hot-added range will be covered by
> @tdx_memlist.

OK, that's fair enough.  Memblocks change and we don't lock out changes
to memblocks.  But, the TDX setup is based on memblocks at one point in
time, so we effectively need to know what their state was at that point
in time.

>>> +static int build_tdx_memory(void)
>>> +{
>>> +   unsigned long start_pfn, end_pfn;
>>> +   int i, nid, ret;
>>> +
>>> +   for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
>>> +           /*
>>> +            * The first 1MB may not be reported as TDX convertible
>>> +            * memory.  Manually exclude them as TDX memory.
>>
>> I don't like the "may not" here very much.
>>
>>> +            * This is fine as the first 1MB is already reserved in
>>> +            * reserve_real_mode() and won't end up to ZONE_DMA as
>>> +            * free page anyway.
>>
>>                        ^ free pages
>>
>>> +            */
>>
>> This way too wishy washy.  The TDX module may or may not...  Then, it
>> doesn't matter since reserve_real_mode() does it anyway...
>>
>> Then it goes and adds code to skip it!
>>
>>> +           start_pfn = max(start_pfn, (unsigned long)SZ_1M >> PAGE_SHIFT);
>>> +           if (start_pfn >= end_pfn)
>>> +                   continue;
>>
>>
>> Please just put a dang stake in the ground.  If the other code deals
>> with this, then explain *why* more is needed here.
> 
> How about adding below before the 'for_each_mem_pfn_range()' loop:
> 
>         /*
>          * Some reserved pages in memblock (i.e. kernel init code/data) are
>          * freed to the page allocator directly.  Use for_each_mem_pfn_range()
>          * instead of for_each_free_mem_range() to make sure all pages in the
>          * page allocator are covered as TDX memory.
>          */
> 
> It explains why to use for_each_mem_pfn_range().

I actually wasn't asking about the for_each_mem_pfn_range() use.

> And here before skipping first 1MB, we add below:
> 
>                 /*
>                  * The first 1MB is not reported as TDX covertible memory.
>                  * Although the first 1MB is always reserved and won't end up
>                  * to the page allocator, it is still in memblock's memory
>                  * regions.  Skip them manually to exclude them as TDX memory.
>                  */

That looks OK, with the spelling fixed.

>>> +           /* Verify memory is truly TDX convertible memory */
>>> +           if (!pfn_range_covered_by_cmr(start_pfn, end_pfn)) {
>>> +                   pr_info("Memory region [0x%lx, 0x%lx) is not TDX convertible memorry.\n",
>>> +                                   start_pfn << PAGE_SHIFT,
>>> +                                   end_pfn << PAGE_SHIFT);
>>> +                   return -EINVAL;
>>
>> ... no 'goto err'?  This leaks all the previous add_tdx_memblock()
>> structures, right?
> 
> Right.  It's a leftover from the old code.  Will fix.
> 
>>
>>> +           }
>>> +
>>> +           /*
>>> +            * Add the memory regions as TDX memory.  The regions in
>>> +            * memblock has already guaranteed they are in address
>>> +            * ascending order and don't overlap.
>>> +            */
>>> +           ret = add_tdx_memblock(start_pfn, end_pfn, nid);
>>> +           if (ret)
>>> +                   goto err;
>>> +   }
>>> +
>>> +   return 0;
>>> +err:
>>> +   free_tdx_memory();
>>> +   return ret;
>>> +}
>>> +
>>>  /*
>>>   * Detect and initialize the TDX module.
>>>   *
>>> @@ -357,12 +473,56 @@ static int init_tdx_module(void)
>>>     if (ret)
>>>             goto out;
>>>
>>> +   /*
>>> +    * All memory regions that can be used by the TDX module must be
>>> +    * passed to the TDX module during the module initialization.
>>> +    * Once this is done, all "TDX-usable" memory regions are fixed
>>> +    * during module's runtime.
>>> +    *
>>> +    * The initial support of TDX guests only allocates memory from
>>> +    * the global page allocator.  To keep things simple, for now
>>> +    * just make sure all pages in the page allocator are TDX memory.
>>> +    *
>>> +    * To achieve this, use all system memory in the core-mm at the
>>> +    * time of initializing the TDX module as TDX memory, and at the
>>> +    * meantime, reject any new memory in memory hot-add.
>>> +    *
>>> +    * This works as in practice, all boot-time present DIMM is TDX
>>> +    * convertible memory.  However if any new memory is hot-added
>>> +    * before initializing the TDX module, the initialization will
>>> +    * fail due to that memory is not covered by CMR.
>>> +    *
>>> +    * This can be enhanced in the future, i.e. by allowing adding or
>>> +    * onlining non-TDX memory to a separate node, in which case the
>>> +    * "TDX-capable" nodes and the "non-TDX-capable" nodes can exist
>>> +    * together -- the userspace/kernel just needs to make sure pages
>>> +    * for TDX guests must come from those "TDX-capable" nodes.
>>> +    *
>>> +    * Build the list of TDX memory regions as mentioned above so
>>> +    * they can be passed to the TDX module later.
>>> +    */
>>
>> This is msotly Documentation/, not a code comment.  Please clean it up.
> 
> Will try to clean up.
> 
>>
>>> +   get_online_mems();
>>> +
>>> +   ret = build_tdx_memory();
>>> +   if (ret)
>>> +           goto out;
>>>     /*
>>>      * Return -EINVAL until all steps of TDX module initialization
>>>      * process are done.
>>>      */
>>>     ret = -EINVAL;
>>>  out:
>>> +   /*
>>> +    * Memory hotplug checks the hot-added memory region against the
>>> +    * @tdx_memlist to see if the region is TDX memory.
>>> +    *
>>> +    * Do put_online_mems() here to make sure any modification to
>>> +    * @tdx_memlist is done while holding the memory hotplug read
>>> +    * lock, so that the memory hotplug path can just check the
>>> +    * @tdx_memlist w/o holding the @tdx_module_lock which may cause
>>> +    * deadlock.
>>> +    */
>>
>> I'm honestly not following any of that.
> 
> How about:
> 
>         /*
>          * Make sure tdx_cc_memory_compatible() either sees a fixed set of
>          * memory regions in @tdx_memlist, or an empty list.
>          */

That's a comment for the lock side, not the unlock side.  It should be:

	/*
	 * @tdx_memlist is written here and read at memory hotplug time.
	 * Lock out memory hotplug code while building it.
	 */

>>> +   put_online_mems();
>>>     return ret;
>>>  }
>>>
>>> @@ -485,3 +645,26 @@ int tdx_enable(void)
>>>     return ret;
>>>  }
>>>  EXPORT_SYMBOL_GPL(tdx_enable);
>>> +
>>> +/*
>>> + * Check whether the given range is TDX memory.  Must be called between
>>> + * mem_hotplug_begin()/mem_hotplug_done().
>>> + */
>>> +bool tdx_cc_memory_compatible(unsigned long start_pfn, unsigned long end_pfn)
>>> +{
>>> +   struct tdx_memblock *tmb;
>>> +
>>> +   /* Empty list means TDX isn't enabled successfully */
>>> +   if (list_empty(&tdx_memlist))
>>> +           return true;
>>> +
>>> +   list_for_each_entry(tmb, &tdx_memlist, list) {
>>> +           /*
>>> +            * The new range is TDX memory if it is fully covered
>>> +            * by any TDX memory block.
>>> +            */
>>> +           if (start_pfn >= tmb->start_pfn && end_pfn <= tmb->end_pfn)
>>> +                   return true;
>>
>> Same bug.  What if the start/end_pfn range is covered by more than one
>> tdx_memblock?
> 
> We may want to return true if tdx_memblocks are contiguous.
> 
> However I don't think this will happen?
> 
> tdx_memblock is from memblock, and when two memory regions in memblock are
> contiguous, they must have different node, or flags.
> 
> My understanding is the hot-added memory region here cannot across NUMA nodes,
> nor have different flags,  correct?

I'm not sure what flags are in this context.

