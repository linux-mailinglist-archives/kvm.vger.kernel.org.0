Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC2AB603053
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 17:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbiJRP4l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 11:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiJRP4k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 11:56:40 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1598414011;
        Tue, 18 Oct 2022 08:56:38 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1okoxF-0006rH-E8; Tue, 18 Oct 2022 17:56:33 +0200
Message-ID: <a1a8664c-4d06-89e7-8cfa-b730969bb841@maciej.szmigiero.name>
Date:   Tue, 18 Oct 2022 17:56:27 +0200
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
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 4/6] KVM: selftests: memslot_perf_test: Support variable
 guest page size
In-Reply-To: <da2b7db0-509a-c9e0-c36b-6487a265a779@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18.10.2022 02:51, Gavin Shan wrote:
> On 10/18/22 8:46 AM, Gavin Shan wrote:
>> On 10/18/22 5:31 AM, Maciej S. Szmigiero wrote:
>>> On 14.10.2022 09:19, Gavin Shan wrote:
>>>> The test case is obviously broken on aarch64 because non-4KB guest
>>>> page size is supported. The guest page size on aarch64 could be 4KB,
>>>> 16KB or 64KB.
>>>>
>>>> This supports variable guest page size, mostly for aarch64.
>>>>
>>>>    - The host determines the guest page size when virtual machine is
>>>>      created. The value is also passed to guest through the synchronization
>>>>      area.
>>>>
>>>>    - The number of guest pages are unknown until the virtual machine
>>>>      is to be created. So all the related macros are dropped. Instead,
>>>>      their values are dynamically calculated based on the guest page
>>>>      size.
>>>>
>>>>    - The static checks on memory sizes and pages becomes dependent
>>>>      on guest page size, which is unknown until the virtual machine
>>>>      is about to be created. So all the static checks are converted
>>>>      to dynamic checks, done in check_memory_sizes().
>>>>
>>>>    - As the address passed to madvise() should be aligned to host page,
>>>>      the size of page chunk is automatically selected, other than one
>>>>      page.
>>>>
>>>>    - All other changes included in this patch are almost mechanical
>>>>      replacing '4096' with 'guest_page_size'.
>>>>
>>>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>>>> ---
>>>>   .../testing/selftests/kvm/memslot_perf_test.c | 191 +++++++++++-------
>>>>   1 file changed, 115 insertions(+), 76 deletions(-)
>>>>
>>>> diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
>>>> index d5aa9148f96f..d587bd952ff9 100644
>>>> --- a/tools/testing/selftests/kvm/memslot_perf_test.c
>>>> +++ b/tools/testing/selftests/kvm/memslot_perf_test.c
(...)
>>>> @@ -77,8 +61,7 @@ static_assert(MEM_TEST_UNMAP_SIZE_PAGES %
>>>>    * for the total size of 25 pages.
>>>>    * Hence, the maximum size here is 50 pages.
>>>>    */
>>>> -#define MEM_TEST_MOVE_SIZE_PAGES    (50)
>>>> -#define MEM_TEST_MOVE_SIZE        (MEM_TEST_MOVE_SIZE_PAGES * 4096)
>>>> +#define MEM_TEST_MOVE_SIZE        0x32000
>>>
>>> The above number seems less readable than an explicit value of 50 pages.
>>>
>>> In addition to that, it's 50 pages only with 4k page size, so at least
>>> the comment above needs to be updated to reflect this fact.
>>>
>>
>> Yeah, I will change the comments like below in next revision.
>>
>>   /*
>>    * When running this test with 32k memslots, actually 32763 excluding
>>    * the reserved memory slot 0, the memory for each slot is 0x4000 bytes.
>>    * The last slot contains 0x19000 bytes memory. Hence, the maximum size
>>    * here is 0x32000 bytes.
>>    */
>>
> 
> I will replace those numbers with readable ones like below :)
> 
> /*
>   * When running this test with 32k memslots, actually 32763 excluding
>   * the reserved memory slot 0, the memory for each slot is 16KB. The
>   * last slot contains 100KB memory with the remaining 84KB. Hence,
>   * the maximum size is double of that (200KB)
>   */

Still, these numbers are for x86, which has KVM_INTERNAL_MEM_SLOTS
defined as 3.

As far as I can see aarch64 has KVM_INTERNAL_MEM_SLOTS equal to 0, so
this arch has 32766 slot available for the test memory.

Quick calculations show that this will result in 112 KiB of memory in
the last slot for 4 KiB page size (while for 64 KiB page size the
maximum slot count for this test is 8192 anyway - not counting slot 0).

> Thanks,
> Gavin
> 

Thanks,
Maciej

