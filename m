Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C46E9662BB9
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 17:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235285AbjAIQwd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 11:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237060AbjAIQwC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 11:52:02 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CE03D9C2;
        Mon,  9 Jan 2023 08:51:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673283084; x=1704819084;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZucqOk+67Amc2gmLvmM/sbP9UykF6LcnNs8CXy0bFGQ=;
  b=JFhFVnxL7ZCGSgQrMarjhC+HctoYMxeRPadHvtlrdywB59QkmRzbGJKi
   LhWLKHSkQkH1q2n1by80xu6fLIi4agRkFvNRUODsCyosMX5nStbpEClGH
   FdJPGgpKIkXxcU2a2jdy/50+vyeCjkFnYWDbdf8Hre+XgbHXdiBA3STUN
   YJmXXKUH8jmlLdgWgbnjr/dpNmWoLPZB6C5q/RkXlSFtkdgKrieNTrALH
   HI4OWY/38Xd1PIJtxHB6fRXUoLEUvYrOAPUOpmNwu7FJWDkoX5tO9oqzA
   lck+AHbcCcQDgY28lALZA11l599H4gAmyP6zvGoF3tDT1CMDScfVriI/z
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="306438461"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="306438461"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 08:51:23 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="780747840"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="780747840"
Received: from swapnadi-mobl2.amr.corp.intel.com (HELO [10.209.29.117]) ([10.209.29.117])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 08:51:21 -0800
Message-ID: <e02fd75d-e9d4-15f1-eb9c-31cf3cc9ddc1@intel.com>
Date:   Mon, 9 Jan 2023 08:51:20 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v8 07/16] x86/virt/tdx: Use all system memory when
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
        "tglx@linutronix.de" <tglx@linutronix.de>,
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
References: <cover.1670566861.git.kai.huang@intel.com>
 <8aab33a7db7a408beb403950e21f693b0b0f1f2b.1670566861.git.kai.huang@intel.com>
 <e7b682a1-abdf-ce73-f262-8b7ce946e78e@intel.com>
 <bc11552572428c3b29b67852b062c387ecd7be45.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <bc11552572428c3b29b67852b062c387ecd7be45.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/9/23 03:48, Huang, Kai wrote:
...
>>>>> This approach works as in practice all boot-time present DIMMs are TDX
>>>>> convertible memory.  However, if any non-TDX-convertible memory has been
>>>>> hot-added (i.e. CXL memory via kmem driver) before initializing the TDX
>>>>> module, the module initialization will fail.
>>>
>>> I really don't know what this is trying to say.
> 
> My intention is to explain and call out that such design (use all memory regions
> in memblock at the time of module initialization) works in practice, as long as
> non-CMR memory hasn't been added via memory hotplug.
> 
> Not sure if it is necessary, but I was thinking it may help reviewer to judge
> whether such design is acceptable.

This is yet another case where you've mechanically described the "what",
but left out the implications or the underlying basis "why".

I'd take a more methodical approach to describe what is going on here.
List the steps that must occur, or at least *one* example of those steps
and how they intereact with the code in this patch.  Then, explain the
fallout.

I also don't think it's quite right to call out "CXL memory via kmem
driver".  If the CXL memory was "System RAM", it should get covered by a
CMR and TDMR.  The kmem driver can still go wild with it.

>>> *How* and *why* does this module initialization failure occur?
> 
> If we pass any non-CMR memory to the TDX module, the SEAMCALL (TDH.SYS.CONFIG)
> will fail.

I'm frankly lost now.  Please go back and try to explain this better.
Let me know if you want to iterate on this faster than resending this
series five more times.  I've got some ideas.

>>>>> This can also be enhanced in the future, i.e. by allowing adding non-TDX
>>>>> memory to a separate NUMA node.  In this case, the "TDX-capable" nodes
>>>>> and the "non-TDX-capable" nodes can co-exist, but the kernel/userspace
>>>>> needs to guarantee memory pages for TDX guests are always allocated from
>>>>> the "TDX-capable" nodes.
>>>
>>> Why does it need to be enhanced?  What's the problem?
> 
> The problem is after TDX module initialization, no more memory can be hot-added
> to the page allocator.
> 
> Kirill suggested this may not be ideal. With the existing NUMA ABIs we can
> actually have both TDX-capable and non-TDX-capable NUMA nodes online. We can
> bind TDX workloads to TDX-capable nodes while other non-TDX workloads can
> utilize all memory.
> 
> But probably it is not necessarily to call out in the changelog?

Let's say that we add this TDX-compatible-node ABI in the future.  What
will old code do that doesn't know about this ABI?

...
>>>>> +       list_for_each_entry(tmb, &tdx_memlist, list) {
>>>>> +               /*
>>>>> +                * The new range is TDX memory if it is fully covered by
>>>>> +                * any TDX memory block.
>>>>> +                *
>>>>> +                * Note TDX memory blocks are originated from memblock
>>>>> +                * memory regions, which can only be contiguous when two
>>>>> +                * regions have different NUMA nodes or flags.  Therefore
>>>>> +                * the new range cannot cross multiple TDX memory blocks.
>>>>> +                */
>>>>> +               if (start_pfn >= tmb->start_pfn && end_pfn <= tmb->end_pfn)
>>>>> +                       return true;
>>>>> +       }
>>>>> +       return false;
>>>>> +}
>>>
>>> I don't really like that comment.  It should first state its behavior
>>> and assumptions, like:
>>>
>>>     This check assumes that the start_pfn<->end_pfn range does not
>>>     cross multiple tdx_memlist entries.
>>>
>>> Only then should it describe why that is OK:
>>>
>>>     A single memory hotplug even across mutliple memblocks (from
>>>     which tdx_memlist entries are derived) is impossible.  ... then
>>>     actually explain
>>>
> 
> How about below?
> 
>         /*
>          * This check assumes that the start_pfn<->end_pfn range does not cross
>          * multiple tdx_memlist entries. A single memory hotplug event across
>          * multiple memblocks (from which tdx_memlist entries are derived) is
>          * impossible. That means start_pfn<->end_pfn range cannot exceed a
>          * tdx_memlist entry, and the new range is TDX memory if it is fully
>          * covered by any tdx_memlist entry.
>          */

I was hoping you would actually explain why it is impossible.

Is there something fundamental that keeps a memory area that spans two
nodes from being removed and then a new area added that is comprised of
a single node?

Boot time:

	| memblock  |  memblock |
	<--Node=0--> <--Node=1-->

Funky hotplug... nothing to see here, then:

	<--------Node=2-------->

I would believe that there is no current bare-metal TDX system that has
an implementation like this.  But, the comments above speak like it's
fundamentally impossible.  That should be clarified.

In other words, that comment talks about memblock attributes as being
the core underlying reason that that simplified check is OK.  Is that
it, or is it really the reduced hotplug feature set on TDX systems?


...
>>>>> +        * Build the list of "TDX-usable" memory regions which cover all
>>>>> +        * pages in the page allocator to guarantee that.  Do it while
>>>>> +        * holding mem_hotplug_lock read-lock as the memory hotplug code
>>>>> +        * path reads the @tdx_memlist to reject any new memory.
>>>>> +        */
>>>>> +       get_online_mems();
>>>
>>> Oh, it actually uses the memory hotplug locking for list protection.
>>> That's at least a bit subtle.  Please document that somewhere in the
>>> functions that actually manipulate the list.
> 
> add_tdx_memblock() and free_tdx_memlist() eventually calls list_add_tail() and
> list_del() to manipulate the list, but they actually takes 'struct list_head
> *tmb_list' as argument. 'tdx_memlist' is passed to build_tdx_memlist() as input.
> 
> Do you mean document the locking around the implementation of add_tdx_memblock()
> and free_tdx_memlist()?
> 
> Or should we just mention it around the 'tdx_memlist' variable?
> 
> /* All TDX-usable memory regions. Protected by memory hotplug locking. */
> static LIST_HEAD(tdx_memlist);

I don't think I'd hate it being in all three spots.  Also "protected by
memory hotplug locking" is pretty generic.  Please be more specific.

>>> I think it's also worth saying something here about the high-level
>>> effects of what's going on:
>>>
>>>     Take a snapshot of the memory configuration (memblocks).  This
>>>     snapshot will be used to enable TDX support for *this* memory
>>>     configuration only.  Use a memory hotplug notifier to ensure
>>>     that no other RAM can be added outside of this configuration.
>>>
>>> That's it, right?
> 
> Yes. I'll somehow include above into the comment around get_online_mems().
> 
> But should I move "Use a memory hotplug notifier ..." part to:
> 
>         err = register_memory_notifier(&tdx_memory_nb);
> 
> because this is where we actually use the memory hotplug notifier?

I actually want that snippet in the changelog.

>>>>> +       ret = build_tdx_memlist(&tdx_memlist);
>>>>> +       if (ret)
>>>>> +               goto out;
>>>>> +
>>>>>         /*
>>>>>          * TODO:
>>>>>          *
>>>>> -        *  - Build the list of TDX-usable memory regions.
>>>>>          *  - Construct a list of TDMRs to cover all TDX-usable memory
>>>>>          *    regions.
>>>>>          *  - Pick up one TDX private KeyID as the global KeyID.
>>>>> @@ -241,6 +394,11 @@ static int init_tdx_module(void)
>>>>>          */
>>>>>         ret = -EINVAL;
>>>>>  out:
>>>>> +       /*
>>>>> +        * @tdx_memlist is written here and read at memory hotplug time.
>>>>> +        * Lock out memory hotplug code while building it.
>>>>> +        */
>>>>> +       put_online_mems();
>>>>>         return ret;
>>>>>  }
>>>
>>> You would also be wise to have the folks who do a lot of memory hotplug
>>> work today look at this sooner rather than later.  I _think_ what you
>>> have here is OK, but I'm really rusty on the code itself.
>>>
> 
> Thanks for advice. Will do.
> 

