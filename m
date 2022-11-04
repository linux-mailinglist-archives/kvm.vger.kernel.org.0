Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E73E4618F64
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 05:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbiKDEGR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 00:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiKDEGM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 00:06:12 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC7F20F50;
        Thu,  3 Nov 2022 21:06:07 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N3Rqs42W0zHvSv;
        Fri,  4 Nov 2022 12:05:45 +0800 (CST)
Received: from [10.67.110.108] (10.67.110.108) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 4 Nov 2022 12:06:05 +0800
Message-ID: <025f1f44-54fa-cc01-96e3-bf0b33d27365@huawei.com>
Date:   Fri, 4 Nov 2022 12:06:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 2/2] KVM: x86: Fix a typo about the usage of kvcalloc()
To:     Paolo Bonzini <pbonzini@redhat.com>, <seanjc@google.com>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <dave.hansen@linux.intel.com>, <hpa@zytor.com>
CC:     <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>
References: <20221103011749.139262-1-liaochang1@huawei.com>
 <5374345c-7973-6a3c-d559-73bf4ac15079@redhat.com>
From:   "liaochang (A)" <liaochang1@huawei.com>
In-Reply-To: <5374345c-7973-6a3c-d559-73bf4ac15079@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.110.108]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2022/11/3 21:39, Paolo Bonzini 写道:
> On 11/3/22 02:17, Liao Chang wrote:
>> Swap the 1st and 2nd arguments to be consistent with the usage of
>> kvcalloc().
>>
>> Fixes: c9b8fecddb5b ("KVM: use kvcalloc for array allocations")
>> Signed-off-by: Liao Chang<liaochang1@huawei.com>
>> ---
>>   arch/x86/kvm/cpuid.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 7065462378e2..b33c18b142c2 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -1331,7 +1331,7 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
>>       if (sanity_check_entries(entries, cpuid->nent, type))
>>           return -EINVAL;
>>   -    array.entries = kvcalloc(sizeof(struct kvm_cpuid_entry2), cpuid->nent, GFP_KERNEL);
>> +    array.entries = kvcalloc(cpuid->nent, sizeof(struct kvm_cpuid_entry2), GFP_KERNEL);
>>       if (!array.entries)
>>           return -ENOMEM;
>>   
> 
> It doesn't make any difference, but scripts/checkpatch.pl checks it so
> let's fix the sole occurrence in KVM.
> 
> However, please send a patch to scripts/checkpatch.pl to include calloc(),
> kvmalloc_array and kvcalloc() in the matched functions:
> 
> # check for alloc argument mismatch
>                 if ($line =~ /\b((?:devm_)?(?:kcalloc|kmalloc_array))\s*\(\s*sizeof\b/) {
>                         WARN("ALLOC_ARRAY_ARGS",
>                              "$1 uses number as first arg, sizeof is generally wrong\n" . $herecurr);
>                 }

I ready send a patch to enhance the checking for array allocator family,
please check out patch "checkpatch: Add check for array allocator family argument order".

Thanks.

> 
> 
> Paolo
> 
> 
> .

-- 
BR,
Liao, Chang
