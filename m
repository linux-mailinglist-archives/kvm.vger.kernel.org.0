Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7BA660512B
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 22:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbiJSUSy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 16:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiJSUSw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 16:18:52 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0631A0C2F;
        Wed, 19 Oct 2022 13:18:49 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1olFWW-0003EF-DJ; Wed, 19 Oct 2022 22:18:44 +0200
Message-ID: <a45cfcc9-0255-14f0-30a5-18d6efaad0d4@maciej.szmigiero.name>
Date:   Wed, 19 Oct 2022 22:18:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Content-Language: en-US, pl-PL
To:     Gavin Shan <gshan@redhat.com>
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
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 4/6] KVM: selftests: memslot_perf_test: Support variable
 guest page size
In-Reply-To: <5bfbe050-a654-8400-e1f1-dcfa4dba13e6@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19.10.2022 02:26, Gavin Shan wrote:
> On 10/18/22 11:56 PM, Maciej S. Szmigiero wrote:
>> On 18.10.2022 02:51, Gavin Shan wrote:
>>> On 10/18/22 8:46 AM, Gavin Shan wrote:
>>>> On 10/18/22 5:31 AM, Maciej S. Szmigiero wrote:
>>>>> On 14.10.2022 09:19, Gavin Shan wrote:
>>>>>> The test case is obviously broken on aarch64 because non-4KB guest
>>>>>> page size is supported. The guest page size on aarch64 could be 4KB,
>>>>>> 16KB or 64KB.
>>>>>>
>>>>>> This supports variable guest page size, mostly for aarch64.
>>>>>>
>>>>>>    - The host determines the guest page size when virtual machine is
>>>>>>      created. The value is also passed to guest through the synchronization
>>>>>>      area.
>>>>>>
>>>>>>    - The number of guest pages are unknown until the virtual machine
>>>>>>      is to be created. So all the related macros are dropped. Instead,
>>>>>>      their values are dynamically calculated based on the guest page
>>>>>>      size.
>>>>>>
>>>>>>    - The static checks on memory sizes and pages becomes dependent
>>>>>>      on guest page size, which is unknown until the virtual machine
>>>>>>      is about to be created. So all the static checks are converted
>>>>>>      to dynamic checks, done in check_memory_sizes().
>>>>>>
>>>>>>    - As the address passed to madvise() should be aligned to host page,
>>>>>>      the size of page chunk is automatically selected, other than one
>>>>>>      page.
>>>>>>
>>>>>>    - All other changes included in this patch are almost mechanical
>>>>>>      replacing '4096' with 'guest_page_size'.
>>>>>>
>>>>>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>>>>>> ---
>>>>>>   .../testing/selftests/kvm/memslot_perf_test.c | 191 +++++++++++-------
>>>>>>   1 file changed, 115 insertions(+), 76 deletions(-)
>>>>>>
>>>>>> diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
>>>>>> index d5aa9148f96f..d587bd952ff9 100644
>>>>>> --- a/tools/testing/selftests/kvm/memslot_perf_test.c
>>>>>> +++ b/tools/testing/selftests/kvm/memslot_perf_test.c
>> (...)
>>>>>> @@ -77,8 +61,7 @@ static_assert(MEM_TEST_UNMAP_SIZE_PAGES %
>>>>>>    * for the total size of 25 pages.
>>>>>>    * Hence, the maximum size here is 50 pages.
>>>>>>    */
>>>>>> -#define MEM_TEST_MOVE_SIZE_PAGES    (50)
>>>>>> -#define MEM_TEST_MOVE_SIZE        (MEM_TEST_MOVE_SIZE_PAGES * 4096)
>>>>>> +#define MEM_TEST_MOVE_SIZE        0x32000
>>>>>
>>>>> The above number seems less readable than an explicit value of 50 pages.
>>>>>
>>>>> In addition to that, it's 50 pages only with 4k page size, so at least
>>>>> the comment above needs to be updated to reflect this fact.
>>>>>
>>>>
>>>> Yeah, I will change the comments like below in next revision.
>>>>
>>>>   /*
>>>>    * When running this test with 32k memslots, actually 32763 excluding
>>>>    * the reserved memory slot 0, the memory for each slot is 0x4000 bytes.
>>>>    * The last slot contains 0x19000 bytes memory. Hence, the maximum size
>>>>    * here is 0x32000 bytes.
>>>>    */
>>>>
>>>
>>> I will replace those numbers with readable ones like below :)
>>>
>>> /*
>>>   * When running this test with 32k memslots, actually 32763 excluding
>>>   * the reserved memory slot 0, the memory for each slot is 16KB. The
>>>   * last slot contains 100KB memory with the remaining 84KB. Hence,
>>>   * the maximum size is double of that (200KB)
>>>   */
>>
>> Still, these numbers are for x86, which has KVM_INTERNAL_MEM_SLOTS
>> defined as 3.
>>
>> As far as I can see aarch64 has KVM_INTERNAL_MEM_SLOTS equal to 0, so
>> this arch has 32766 slot available for the test memory.
>>
>> Quick calculations show that this will result in 112 KiB of memory in
>> the last slot for 4 KiB page size (while for 64 KiB page size the
>> maximum slot count for this test is 8192 anyway - not counting slot 0).
>>
> 
> It seems your calculation had (512MB+64KB), instead of (512MB+4KB).
> In this particular patch, we still have (512MB+4KB). How about to change
> like below in this patch. In next patch, it's adjusted accordingly after
> we have (512MB+64KB).

My review comment above referred to the final MEM_SIZE value after the
whole series, so 512 MiB + 64 KiB.

I placed that review comment on patch 4 since it's the only patch in this
series that modified the code comment about MEM_TEST_MOVE_SIZE.

> 
> (1) In this patch, the comment is changed to as below
> 
>      /*
>       * We have different number of memory slots, excluding the reserved
>       * memory slot 0, on various architectures and configurations. The
>       * memory size in this test is calculated by doubling the maximal
>       * memory size in last memory slot, with alignment to the largest
>       * supported page size (64KB).
>       *
>       * architecture   slots    memory-per-slot    memory-on-last-slot
>       * --------------------------------------------------------------
>       * x86-4KB        32763    16KB               100KB
>       * arm64-4KB      32766    16KB               52KB
>       * arm64-64KB     8192     64KB               64KB
>       */
>      #define MEM_TEST_MOVE_SIZE    0x40000           /* 256KB */
>
> (2) In the next patch, where we have (512MB+64KB) after the various
>      memory sizes are consolidated, It is adjusted accordingly as below.
> 
>      /*
>       * We have different number of memory slots, excluding the reserved
>       * memory slot 0, on various architectures and configurations. The
>       * memory size in this test is calculated by doubling the maximal
>       * memory size in last memory slot, with alignment to the largest
>       * supported page size (64KB).
>       *
>       * architecture   slots    memory-per-slot    memory-on-last-slot
>       * --------------------------------------------------------------
>       * x86-4KB        32763    16KB               160KB
>       * arm64-4KB      32766    16KB               112KB
>       * arm64-64KB     8192     64KB               128KB
>       */
>      #define MEM_TEST_MOVE_SIZE    0x50000           /* 320KB */

Now MEM_TEST_MOVE_SIZE is too high for arm64-4KB and arm64-64KB cases
(it needs 160 KiB in the last slot but has less available in these two
cases).

Using a test size of 192 KiB instead seems like a small difference
from the original size of 200 KiB, while still being aligned to
64 KiB.

The move benchmarks runtime difference on x86-4KB with this size
(compared to sizes of 200 KiB and 320 KiB) seems to be negligible.

Since it's an odd number of 64 KiB pages (3) the code that halves
this number of pages will need to be adjusted to operate on raw
sizes instead.

I can see a single block of code that will need such adjustment:
> if (lastpages < move_pages / 2) {
>         *maxslots = 0;
>         return false;
> }   

Similar remark goes for the case (1) above, where you'll probably need
to use 64 KiB test area size (it's only an intermediate form of code
before the final patch changes this value so it's fine if it doesn't
perform as well as the final form of the code).

> Thanks,
> Gavin
> 

Thanks,
Maciej

