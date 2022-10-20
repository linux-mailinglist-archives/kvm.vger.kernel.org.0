Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C17DC605847
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 09:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbiJTHUL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 03:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbiJTHUC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 03:20:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFCDA15A1A
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 00:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666250397;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d9HqOzVsB8T4yggWYl1bqige06n7AwLzVreZ+LrEySM=;
        b=KzWb2GdqCw9t6whQCncjrTJ9pC6Gb2HBe7EpSnkOjwQaSyhAcR8aPHbavrnxdaq5OtGFUq
        y4praoinjLI7y2Ycfhx/VU6ioWwyl5vaEQfM0IidH/5k3XpxHKHWqmHEu26JZvw54+pH2p
        EkodJhJOPsOGLlBN3C9AHT8U46wY1VA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-339--4tmXxcVONmOztGz3krQ0w-1; Thu, 20 Oct 2022 03:19:54 -0400
X-MC-Unique: -4tmXxcVONmOztGz3krQ0w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDD051C068C9;
        Thu, 20 Oct 2022 07:19:53 +0000 (UTC)
Received: from [10.64.54.70] (vpn2-54-70.bne.redhat.com [10.64.54.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A5A1EC15BA5;
        Thu, 20 Oct 2022 07:19:45 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 4/6] KVM: selftests: memslot_perf_test: Support variable
 guest page size
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
        zhenyzha@redhat.com, shan.gavin@gmail.com, kvmarm@lists.linux.dev,
        pbonzini@redhat.com, shuah@kernel.org,
        kvmarm@lists.cs.columbia.edu, ajones@ventanamicro.com
References: <20221014071914.227134-1-gshan@redhat.com>
 <20221014071914.227134-5-gshan@redhat.com>
 <3eecebca-a526-d10a-02d3-496ce919d577@maciej.szmigiero.name>
 <bd5df92c-6870-8053-0b35-a2ad993970bd@redhat.com>
 <da2b7db0-509a-c9e0-c36b-6487a265a779@redhat.com>
 <a1a8664c-4d06-89e7-8cfa-b730969bb841@maciej.szmigiero.name>
 <5bfbe050-a654-8400-e1f1-dcfa4dba13e6@redhat.com>
 <a45cfcc9-0255-14f0-30a5-18d6efaad0d4@maciej.szmigiero.name>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <001d6b60-dc05-370d-5cb3-9f8f855089c3@redhat.com>
Date:   Thu, 20 Oct 2022 15:19:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <a45cfcc9-0255-14f0-30a5-18d6efaad0d4@maciej.szmigiero.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/20/22 4:18 AM, Maciej S. Szmigiero wrote:
> On 19.10.2022 02:26, Gavin Shan wrote:
>> On 10/18/22 11:56 PM, Maciej S. Szmigiero wrote:
>>> On 18.10.2022 02:51, Gavin Shan wrote:
>>>> On 10/18/22 8:46 AM, Gavin Shan wrote:
>>>>> On 10/18/22 5:31 AM, Maciej S. Szmigiero wrote:
>>>>>> On 14.10.2022 09:19, Gavin Shan wrote:
>>>>>>> The test case is obviously broken on aarch64 because non-4KB guest
>>>>>>> page size is supported. The guest page size on aarch64 could be 4KB,
>>>>>>> 16KB or 64KB.
>>>>>>>
>>>>>>> This supports variable guest page size, mostly for aarch64.
>>>>>>>
>>>>>>>    - The host determines the guest page size when virtual machine is
>>>>>>>      created. The value is also passed to guest through the synchronization
>>>>>>>      area.
>>>>>>>
>>>>>>>    - The number of guest pages are unknown until the virtual machine
>>>>>>>      is to be created. So all the related macros are dropped. Instead,
>>>>>>>      their values are dynamically calculated based on the guest page
>>>>>>>      size.
>>>>>>>
>>>>>>>    - The static checks on memory sizes and pages becomes dependent
>>>>>>>      on guest page size, which is unknown until the virtual machine
>>>>>>>      is about to be created. So all the static checks are converted
>>>>>>>      to dynamic checks, done in check_memory_sizes().
>>>>>>>
>>>>>>>    - As the address passed to madvise() should be aligned to host page,
>>>>>>>      the size of page chunk is automatically selected, other than one
>>>>>>>      page.
>>>>>>>
>>>>>>>    - All other changes included in this patch are almost mechanical
>>>>>>>      replacing '4096' with 'guest_page_size'.
>>>>>>>
>>>>>>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>>>>>>> ---
>>>>>>>   .../testing/selftests/kvm/memslot_perf_test.c | 191 +++++++++++-------
>>>>>>>   1 file changed, 115 insertions(+), 76 deletions(-)
>>>>>>>
>>>>>>> diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
>>>>>>> index d5aa9148f96f..d587bd952ff9 100644
>>>>>>> --- a/tools/testing/selftests/kvm/memslot_perf_test.c
>>>>>>> +++ b/tools/testing/selftests/kvm/memslot_perf_test.c
>>> (...)
>>>>>>> @@ -77,8 +61,7 @@ static_assert(MEM_TEST_UNMAP_SIZE_PAGES %
>>>>>>>    * for the total size of 25 pages.
>>>>>>>    * Hence, the maximum size here is 50 pages.
>>>>>>>    */
>>>>>>> -#define MEM_TEST_MOVE_SIZE_PAGES    (50)
>>>>>>> -#define MEM_TEST_MOVE_SIZE        (MEM_TEST_MOVE_SIZE_PAGES * 4096)
>>>>>>> +#define MEM_TEST_MOVE_SIZE        0x32000
>>>>>>
>>>>>> The above number seems less readable than an explicit value of 50 pages.
>>>>>>
>>>>>> In addition to that, it's 50 pages only with 4k page size, so at least
>>>>>> the comment above needs to be updated to reflect this fact.
>>>>>>
>>>>>
>>>>> Yeah, I will change the comments like below in next revision.
>>>>>
>>>>>   /*
>>>>>    * When running this test with 32k memslots, actually 32763 excluding
>>>>>    * the reserved memory slot 0, the memory for each slot is 0x4000 bytes.
>>>>>    * The last slot contains 0x19000 bytes memory. Hence, the maximum size
>>>>>    * here is 0x32000 bytes.
>>>>>    */
>>>>>
>>>>
>>>> I will replace those numbers with readable ones like below :)
>>>>
>>>> /*
>>>>   * When running this test with 32k memslots, actually 32763 excluding
>>>>   * the reserved memory slot 0, the memory for each slot is 16KB. The
>>>>   * last slot contains 100KB memory with the remaining 84KB. Hence,
>>>>   * the maximum size is double of that (200KB)
>>>>   */
>>>
>>> Still, these numbers are for x86, which has KVM_INTERNAL_MEM_SLOTS
>>> defined as 3.
>>>
>>> As far as I can see aarch64 has KVM_INTERNAL_MEM_SLOTS equal to 0, so
>>> this arch has 32766 slot available for the test memory.
>>>
>>> Quick calculations show that this will result in 112 KiB of memory in
>>> the last slot for 4 KiB page size (while for 64 KiB page size the
>>> maximum slot count for this test is 8192 anyway - not counting slot 0).
>>>
>>
>> It seems your calculation had (512MB+64KB), instead of (512MB+4KB).
>> In this particular patch, we still have (512MB+4KB). How about to change
>> like below in this patch. In next patch, it's adjusted accordingly after
>> we have (512MB+64KB).
> 
> My review comment above referred to the final MEM_SIZE value after the
> whole series, so 512 MiB + 64 KiB.
> 
> I placed that review comment on patch 4 since it's the only patch in this
> series that modified the code comment about MEM_TEST_MOVE_SIZE.
> 
>>
>> (1) In this patch, the comment is changed to as below
>>
>>      /*
>>       * We have different number of memory slots, excluding the reserved
>>       * memory slot 0, on various architectures and configurations. The
>>       * memory size in this test is calculated by doubling the maximal
>>       * memory size in last memory slot, with alignment to the largest
>>       * supported page size (64KB).
>>       *
>>       * architecture   slots    memory-per-slot    memory-on-last-slot
>>       * --------------------------------------------------------------
>>       * x86-4KB        32763    16KB               100KB
>>       * arm64-4KB      32766    16KB               52KB
>>       * arm64-64KB     8192     64KB               64KB
>>       */
>>      #define MEM_TEST_MOVE_SIZE    0x40000           /* 256KB */
>>
>> (2) In the next patch, where we have (512MB+64KB) after the various
>>      memory sizes are consolidated, It is adjusted accordingly as below.
>>
>>      /*
>>       * We have different number of memory slots, excluding the reserved
>>       * memory slot 0, on various architectures and configurations. The
>>       * memory size in this test is calculated by doubling the maximal
>>       * memory size in last memory slot, with alignment to the largest
>>       * supported page size (64KB).
>>       *
>>       * architecture   slots    memory-per-slot    memory-on-last-slot
>>       * --------------------------------------------------------------
>>       * x86-4KB        32763    16KB               160KB
>>       * arm64-4KB      32766    16KB               112KB
>>       * arm64-64KB     8192     64KB               128KB
>>       */
>>      #define MEM_TEST_MOVE_SIZE    0x50000           /* 320KB */
> 
> Now MEM_TEST_MOVE_SIZE is too high for arm64-4KB and arm64-64KB cases
> (it needs 160 KiB in the last slot but has less available in these two
> cases).
> 
> Using a test size of 192 KiB instead seems like a small difference
> from the original size of 200 KiB, while still being aligned to
> 64 KiB.
> 
> The move benchmarks runtime difference on x86-4KB with this size
> (compared to sizes of 200 KiB and 320 KiB) seems to be negligible.
> 
> Since it's an odd number of 64 KiB pages (3) the code that halves
> this number of pages will need to be adjusted to operate on raw
> sizes instead.
> 
> I can see a single block of code that will need such adjustment:
>> if (lastpages < move_pages / 2) {
>>         *maxslots = 0;
>>         return false;
>> } 
> 
> Similar remark goes for the case (1) above, where you'll probably need
> to use 64 KiB test area size (it's only an intermediate form of code
> before the final patch changes this value so it's fine if it doesn't
> perform as well as the final form of the code).
> 

Maciej, all your comments make sense to me. It really took me some times
to do the calculation. I just posted v3 to address all your comments.
Hopefully, there is nothing missed. Please go ahead to review v3 directly
when you get a chance.

    v3: https://lore.kernel.org/kvmarm/20221020071209.559062-1-gshan@redhat.com/T/#t

In v3, the comments about MEM_TEST_MOVE_SIZE is fixed in PATCH[v3 4/6],
but it's 64KB. In PATCH[v3 5/6], it's fixed up to 192KB and memory size
is used for the comparison in test_memslot_move_prepare().

Thanks,
Gavin


