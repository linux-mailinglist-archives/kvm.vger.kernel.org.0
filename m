Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0566645E1
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 17:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238653AbjAJQT0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 11:19:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238834AbjAJQTP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 11:19:15 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F936E42B;
        Tue, 10 Jan 2023 08:18:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673367528; x=1704903528;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HzAV4h4PwTOTMezU8bvkGgKpyYb8PNekRFDWu1NI97I=;
  b=KvfghNC29qm/LS9KMsWr1imY1TthHjzbVvzSXOUF3ok+wQdRuhXZnDjJ
   LVvkL7Ot3F+x4YTz03fZdXvOk1f+7cajnGtXeE6A9U0YWSXFwi3mPMic5
   t0whrDC8UsxlT09v5wm2WorsZYCJnch7GElZChnE1rRCYZKTwOfKrHWv/
   DzbsCjvBOu49ShQXRbqoF962d40dc32dqZhoeRG2poLHw4pd6ZdJk0h0i
   lycx92MkPO6Q8bJ3p+bqy35VD3iqcvagZ0KxhO839BrYfp20TUn3+sEWH
   C1m96k9i4g77Dhs4wM8q6cp7a9tWgSAJTbHodX3qcoPepxi3ZIGwUgHZe
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="320874904"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="320874904"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 08:18:48 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="725596337"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="725596337"
Received: from svenka7-mobl1.amr.corp.intel.com (HELO [10.209.63.27]) ([10.209.63.27])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 08:18:47 -0800
Message-ID: <16f23950-2a27-29de-c0b4-e5f2d927c8b4@intel.com>
Date:   Tue, 10 Jan 2023 08:18:46 -0800
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
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
 <8aab33a7db7a408beb403950e21f693b0b0f1f2b.1670566861.git.kai.huang@intel.com>
 <e7b682a1-abdf-ce73-f262-8b7ce946e78e@intel.com>
 <bc11552572428c3b29b67852b062c387ecd7be45.camel@intel.com>
 <e02fd75d-e9d4-15f1-eb9c-31cf3cc9ddc1@intel.com>
 <a5d4de8b074b6d1a34bd3d424c5c4f0d677ec15f.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <a5d4de8b074b6d1a34bd3d424c5c4f0d677ec15f.camel@intel.com>
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

On 1/10/23 04:09, Huang, Kai wrote:
> On Mon, 2023-01-09 at 08:51 -0800, Dave Hansen wrote:
>> On 1/9/23 03:48, Huang, Kai wrote:
>>>>>>> This can also be enhanced in the future, i.e. by allowing adding non-TDX
>>>>>>> memory to a separate NUMA node.  In this case, the "TDX-capable" nodes
>>>>>>> and the "non-TDX-capable" nodes can co-exist, but the kernel/userspace
>>>>>>> needs to guarantee memory pages for TDX guests are always allocated from
>>>>>>> the "TDX-capable" nodes.
>>>>>
>>>>> Why does it need to be enhanced?  What's the problem?
>>>
>>> The problem is after TDX module initialization, no more memory can be hot-added
>>> to the page allocator.
>>>
>>> Kirill suggested this may not be ideal. With the existing NUMA ABIs we can
>>> actually have both TDX-capable and non-TDX-capable NUMA nodes online. We can
>>> bind TDX workloads to TDX-capable nodes while other non-TDX workloads can
>>> utilize all memory.
>>>
>>> But probably it is not necessarily to call out in the changelog?
>>
>> Let's say that we add this TDX-compatible-node ABI in the future.  What
>> will old code do that doesn't know about this ABI?
> 
> Right.  The old app will break w/o knowing the new ABI.  One resolution, I
> think, is we don't introduce new userspace ABI, but hide "TDX-capable" and "non-
> TDX-capable" nodes in the kernel, and let kernel to enforce always allocating
> TDX guest memory from those "TDX-capable" nodes.

That doesn't actually hide all of the behavior from users.  Let's say
they do:

	numactl --membind=6 qemu-kvm ...

In other words, take all of this guest's memory and put it on node 6.
There lots of free memory on node 6 which is TDX-*IN*compatible.  Then,
they make it a TDX guest:

	numactl --membind=6 qemu-kvm -tdx ...

What happens?  Does the kernel silently ignore the --membind=6?  Or does
it return -ENOMEM somewhere and confuse the user who has *LOTS* of free
memory on node 6.

In other words, I don't think the kernel can just enforce this
internally and hide it from userspace.

>> Is there something fundamental that keeps a memory area that spans two
>> nodes from being removed and then a new area added that is comprised of
>> a single node?
>> Boot time:
>>
>> 	| memblock  |  memblock |
>> 	<--Node=0--> <--Node=1-->
>>
>> Funky hotplug... nothing to see here, then:
>>
>> 	<--------Node=2-------->
> 
> I must have missed something, but how can this happen?
> 
> I had memory that this cannot happen because the BIOS always allocates address
> ranges for all NUMA nodes during machine boot.  Those address ranges don't
> necessarily need to have DIMM fully populated but they don't change during
> machine's runtime.

Is your memory correct?  Is there evidence, or requirements in any
specification to support your memory?

