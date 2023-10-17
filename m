Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21037CCA5E
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 20:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344066AbjJQSI7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 14:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234891AbjJQSI6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 14:08:58 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 302B190;
        Tue, 17 Oct 2023 11:08:56 -0700 (PDT)
Received: from [192.168.4.26] (unknown [47.186.13.91])
        by linux.microsoft.com (Postfix) with ESMTPSA id D7CD520B74C0;
        Tue, 17 Oct 2023 11:08:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D7CD520B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1697566135;
        bh=NvMLHFub5RqmwlTRrKAUpbaqyKFGOPEO1aUbNfXtibk=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=Dg6z3WIAsikWdJ5JYDib/5orzmxLG7FfdddMhGnQb2WDKtAlvVEonusFHHds/U6x2
         gChzgrVbb8Mqh4ehGGNzLTW1D92G800MTwlA9BraTayqtt69R+FMkcGt2GgurOoKJ+
         gkJ5iINocZdX2dCZrIPk0j5lhnD9Kow8og+Q++fM=
Message-ID: <76917285-d9b1-48af-ac5f-49c2d327e729@linux.microsoft.com>
Date:   Tue, 17 Oct 2023 13:08:53 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 00/10] mm/prmem: Implement the
 Persistent-Across-Kexec memory feature (prmem)
To:     Alexander Graf <graf@amazon.de>, gregkh@linuxfoundation.org,
        pbonzini@redhat.com, rppt@kernel.org, jgowans@amazon.com,
        arnd@arndb.de, keescook@chromium.org,
        stanislav.kinsburskii@gmail.com, anthony.yznaga@oracle.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        jamorris@linux.microsoft.com,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        kvm <kvm@vger.kernel.org>
References: <1b1bc25eb87355b91fcde1de7c2f93f38abb2bf9>
 <20231016233215.13090-1-madvenka@linux.microsoft.com>
 <8f9d81a8-1071-43ca-98cd-e9c1eab8e014@amazon.de>
Content-Language: en-US
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
In-Reply-To: <8f9d81a8-1071-43ca-98cd-e9c1eab8e014@amazon.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-17.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,SPF_HELO_PASS,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Alex,

Thanks a lot for your comments!

On 10/17/23 03:31, Alexander Graf wrote:
> Hey Madhavan!
> 
> This patch set looks super exciting - thanks a lot for putting it together. We've been poking at a very similar direction for a while as well and will discuss the fundamental problem of how to persist kernel metadata across kexec at LPC:
> 
>   https://lpc.events/event/17/contributions/1485/
> 
> It would be great to have you in the room as well then.
> 

Yes. I am planning to attend. But I am attending virtually as I am not able to travel.

> Some more comments inline.
> 
> On 17.10.23 01:32, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> Introduction
>> ============
>>
>> This feature can be used to persist kernel and user data across kexec reboots
>> in RAM for various uses. E.g., persisting:
>>
>>          - cached data. E.g., database caches.
>>          - state. E.g., KVM guest states.
>>          - historical information since the last cold boot. E.g., events, logs
>>            and journals.
>>          - measurements for integrity checks on the next boot.
>>          - driver data.
>>          - IOMMU mappings.
>>          - MMIO config information.
>>
>> This is useful on systems where there is no non-volatile storage or
>> non-volatile storage is too small or too slow.
> 
> 
> This is useful in more situations. We for example need it to do a kexec while a virtual machine is in suspended state, but has IOMMU mappings intact (Live Update). For that, we need to ensure DMA can still reach the VM memory and that everything gets reassembled identically and without interruptions on the receiving end.
> 
> 

I see.

>> The following sections describe the implementation.
>>
>> I have enhanced the ram disk block device driver to provide persistent ram
>> disks on which any filesystem can be created. This is for persisting user data.
>> I have also implemented DAX support for the persistent ram disks.
> 
> 
> This is probably the least interesting of the enablements, right? You can already today reserve RAM on boot as DAX block device and use it for that purpose.
> 

Yes. pmem provides that functionality.

There are a few differences though. However, I don't have a good feel for how important these differences are to users. May be, they are not very significant. E.g,

	- pmem regions need some setup using the ndctl command.
	- IIUC, one needs to specify a starting address and a size for a pmem region. Having to specify a starting address may make it somewhat less flexible from a configuration point of view.
	- In the case of pmem, the entire range of memory is set aside. In the case of the prmem persistent ram disk, pages are allocated as needed. So, persistent memory is shared among multiple
	  consumers more flexibly.

Also Greg H. wanted to see a filesystem based use case to be presented for persistent memory so we can see how it all comes together. I am working on prmemfs (a special FS tailored for persistence). But that will take some time. So, I wanted to present this ram disk use case as a more flexible alternative to pmem.

But you are right. They are equivalent for all practical purposes.

> 
>> I am also working on making ZRAM persistent.
>>
>> I have also briefly discussed the following use cases:
>>
>>          - Persisting IOMMU mappings
>>          - Remembering DMA pages
>>          - Reserving pages that encounter memory errors
>>          - Remembering IMA measurements for integrity checks
>>          - Remembering MMIO config info
>>          - Implementing prmemfs (special filesystem tailored for persistence)
>>
>> Allocate metadata
>> =================
>>
>> Define a metadata structure to store all persistent memory related information.
>> The metadata fits into one page. On a cold boot, allocate and initialize the
>> metadata page.
>>
>> Allocate data
>> =============
>>
>> On a cold boot, allocate some memory for storing persistent data. Call it
>> persistent memory. Specify the size in a command line parameter:
>>
>>          prmem=size[KMG][,max_size[KMG]]
>>
>>          size            Initial amount of memory allocated to prmem during boot
>>          max_size        Maximum amount of memory that can be allocated to prmem
>>
>> When the initial memory is exhaused via allocations, expand prmem dynamically
>> up to max_size. Expansion is done by allocating from the buddy allocator.
>> Record all allocations in the metadata.
> 
> 
> I don't understand why we need a separate allocator. Why can't we just use normal Linux allocations and serialize their location for handover? We would obviously still need to find a large contiguous piece of memory for the target kernel to bootstrap itself into until it can read which pages it can and can not use, but we can do that allocation in the source environment using CMA, no?
> 
> What I'm trying to say is: I think we're better off separating the handover mechanism from the allocation mechanism. If we can implement handover without a new allocator, we can use it for simple things with a slight runtime penalty. To accelerate the handover then, we can later add a compacting allocator that can use the handover mechanism we already built to persist itself.
> 
> 
> 
> I have a WIP branch where I'm toying with such a handover mechanism that uses device tree to serialize/deserialize state. By standardizing the property naming, we can in the receiving kernel mark all persistent allocations as reserved and then slowly either free them again or mark them as in-use one by one:
> 
> https://github.com/agraf/linux/commit/fd5736a21d549a9a86c178c91acb29ed7f364f42
> 
> I used ftrace as example payload to persist: With the handover mechanism in place, we serialize/deserialize ftrace ring buffer metadata and are thus able to read traces of the previous system after kexec. This way, you can for example profile the kexec exit path.
> 
> It's not even in RFC state yet, there are a few things where I would need a couple days to think hard about data structures, layouts and other problems :). But I believe from the patch you get the idea.
> 
> One such user of kho could be a new allocator like prmem and each subsystem's serialization code could choose to rely on the prmem subsystem to persist data instead of doing it themselves. That way you get a very non-intrusive enablement path for kexec handover, easily amendable data structures that can change compatibly over time as well as the ability to recreate ephemeral data structure based on persistent information - which will be necessary to persist VFIO containers.
> 

OK. I will study your changes and your comments. I will send my feedback as well.

Thanks again!

Madhavan

> 
> Alex
> 
> 
> 
> 
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
> 
> 
