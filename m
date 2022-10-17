Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8424B601DBF
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 01:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiJQXjk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 19:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbiJQXjj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 19:39:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1C119018
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 16:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666049976;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WwpNKvZ1k9hvxd4EsdsmzQsZ3dK8aE102L/H4wxIMmw=;
        b=VbjiL5rU8YUk9772tsDeQ7qcM3lHstnZUkA870QbMe/+lz0Er6X6mFBd6zVMKHWLXUJSaT
        9wC2EeGNp0ZAjUj/ejG3UQ0M06+YmV38bkhuXgY4a7vsO0RHA3h1qX3ksLjPs8fByd1mKr
        kYoJWh195QFYTggsEXV6m5/biEwt42E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-nxcmOr-ONWiUw7eVpjW6dw-1; Mon, 17 Oct 2022 19:39:33 -0400
X-MC-Unique: nxcmOr-ONWiUw7eVpjW6dw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 62BD985A583;
        Mon, 17 Oct 2022 23:39:32 +0000 (UTC)
Received: from [10.64.54.70] (vpn2-54-70.bne.redhat.com [10.64.54.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A55D111D795;
        Mon, 17 Oct 2022 23:39:26 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 5/6] KVM: selftests: memslot_perf_test: Consolidate memory
 sizes
To:     Sean Christopherson <seanjc@google.com>
Cc:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        ajones@ventanamicro.com, pbonzini@redhat.com, maz@kernel.org,
        shuah@kernel.org, oliver.upton@linux.dev, peterx@redhat.com,
        ricarkol@google.com, zhenyzha@redhat.com, shan.gavin@gmail.com
References: <20221014071914.227134-1-gshan@redhat.com>
 <20221014071914.227134-6-gshan@redhat.com>
 <cebafa0d-a2dc-c3f7-64c8-2637a254e3d0@maciej.szmigiero.name>
 <Y03ScGUUCA1KwlLF@google.com>
 <9781c88f-06f9-4d17-8fa6-3cd82a739ccb@redhat.com>
 <93529fb7-f558-cc5f-d5bd-7923eb4b492c@maciej.szmigiero.name>
 <fd6287fc-c56f-4c08-0885-8ab32fdfeb7e@redhat.com>
 <Y03l+kwGxNW1Icp/@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <c1442e8f-e86e-abee-fb4e-6f4a95697d17@redhat.com>
Date:   Tue, 18 Oct 2022 07:39:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Y03l+kwGxNW1Icp/@google.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/18/22 7:32 AM, Sean Christopherson wrote:
> On Tue, Oct 18, 2022, Gavin Shan wrote:
>> On 10/18/22 6:56 AM, Maciej S. Szmigiero wrote:
>>> On 18.10.2022 00:51, Gavin Shan wrote:
>>>> On 10/18/22 6:08 AM, Sean Christopherson wrote:
>>>>> On Mon, Oct 17, 2022, Maciej S. Szmigiero wrote:
>>>>>>> +#define MEM_EXTRA_SIZE        0x10000
>>>>>>
>>>>>> Also, an expression like "(64 << 10)" is more readable than a "1"
>>>>>> with a tail of zeroes (it's easy to add one zero too many or be one
>>>>>> zero short).
>>>>>
>>>>> +1 to not open coding raw numbers.
>>>>>
>>>>> I think it's high time KVM selftests add #defines for the common sizes, e.g. SIZE_4KB,
>>>>> 16KB, 64K, 2MB, 1GB, etc...
>>>>>
>>>>> Alternatively (or in addition), just #define 1KB, 1MB, 1GB, and 1TB, and then do
>>>>> math off of those.
>>>>>
>>>>
>>>> Ok. I will have one separate patch to define those sizes in kvm_util_base.h,
>>>> right after '#define NSEC_PER_SEC 1000000000L'. Sean, could you let me know
>>>> if it looks good to you?
>>>>
>>>>       #define KB         (1UL << 10)
>>>>       #define MB         (1UL << 20)
>>>>       #define GB         (1UL << 30)
>>>>       #define TB         (1UL << 40)
> 
> Any objection to prefixing these with SIZE_ as well?  IMO it's worth burning the
> extra five characters to make it all but impossible to misinterpret code.
> 

'SIZE_' prefix works for me either.

>>>>       /* Base page and huge page size */
>>>>       #define SIZE_4KB   (  4 * KB)
>>>>       #define SIZE_16KB  ( 16 * KB)
>>>>       #define SIZE_64KB  ( 64 * KB)
>>>>       #define SIZE_2MB   (  2 * MB)
>>>>       #define SIZE_32MB  ( 32 * MB)
>>>>       #define SIZE_512MB (512 * MB)
>>>>       #define SIZE_1GB   (  1 * GB)
>>>>       #define SIZE_16GB  ( 16 * GB)
>>>
>>> FYI, QEMU uses KiB, MiB, GiB, etc., see [1].
>>>
>>
>> Right. I checked QEMU's definitions and it makes sense to use
>> KiB, MiB, GiB, TiB. I don't think we need PiB and EiB because
>> our tests don't use that large memory.
> 
> Ha!  I had typed out KiB, etc... but then thought, "nah, I'm being silly".  KiB
> and friends work for me.
> 

Thanks for your confirm, Sean.

Thanks,
Gavin

