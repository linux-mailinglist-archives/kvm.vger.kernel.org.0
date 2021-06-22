Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEB03AFE6B
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 09:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhFVHzZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 03:55:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25559 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229695AbhFVHzW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 03:55:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624348386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8tI7JnYAlumcTRQyeWMixyCFJlu3ZV8q4DT07YGcuyk=;
        b=add39fsS+HZpxmOReld4Br27OO9haSSey2GOLXovnzsLKLALy2pskEI8h9SB13UZeY7VkF
        TU9xCFUDF2Tit++rke/Vo43vlYVnVbs6xqDM8OqcenjcdV54S+fkI28m1fpklSfyXWt5r+
        PoYY4ccUU0BRo/mj6ZwExSxmVgLTSNg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-nYNHUVu2NuCWN1Lok0eBAQ-1; Tue, 22 Jun 2021 03:53:05 -0400
X-MC-Unique: nYNHUVu2NuCWN1Lok0eBAQ-1
Received: by mail-wr1-f72.google.com with SMTP id v9-20020a5d4a490000b029011a86baa40cso4908908wrs.7
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 00:53:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8tI7JnYAlumcTRQyeWMixyCFJlu3ZV8q4DT07YGcuyk=;
        b=rqJhMhHCZgd+BJm6WoMW6krNAFSNZ5NtjsZ4CO1HJHEkT7RvY74zLj3qs++z7LH+0i
         aaDyGWqzrNRk9D6kvwTcctqEIG1lbjXt6JABIet52OnHwCylRbGLv0bAildUxMlyH0Zk
         p3uB/6ZR4Xy556OFer8AR5VqLECa3SzTM6aosFauwwVmhbboVuf8howzGl6roKkz4Tsn
         2mQC3AhESGhI6ZZ+Ihge78bQvFCSFWlMaDg9ItS7XiHBCgNtRdPFlhEu7A/XXz9WhPPU
         thy9S3hFbKLif9YQRzWCBMQkH7Bx6GRuRrAIp0d2hzCguyPdb1MW8Kh8QAL0BZI6crir
         GGoQ==
X-Gm-Message-State: AOAM530/SOZBkWROyUc7hGxxAppjGmxFxCu8nIuAy3bCVoJu8OnGVqyj
        oiQDuCvtnkvr41fW+5OSpnJt9WuistTNhrZXAWfPzhWhzbdjJqU+ROhokAH+IadTZuftgDCAdu4
        SO6VM7p+mJg1T
X-Received: by 2002:a05:600c:4fd0:: with SMTP id o16mr3073835wmq.50.1624348383977;
        Tue, 22 Jun 2021 00:53:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFLf02yziUJo/c8kKCR55md2Oz+1XvqvkiGRyD6czV3gKp2o5a2j4sbIWvRngksiy+DFlgyg==
X-Received: by 2002:a05:600c:4fd0:: with SMTP id o16mr3073810wmq.50.1624348383757;
        Tue, 22 Jun 2021 00:53:03 -0700 (PDT)
Received: from thuth.remote.csb (pd9575f2f.dip0.t-ipconnect.de. [217.87.95.47])
        by smtp.gmail.com with ESMTPSA id p8sm1521922wmi.46.2021.06.22.00.53.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 00:53:03 -0700 (PDT)
Subject: Re: [PATCH] KVM: s390: get rid of register asm usage
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20210621140356.1210771-1-hca@linux.ibm.com>
 <7edaf85c-810b-e0f9-5977-6e89270f0709@redhat.com>
 <ef34e1df-b56d-8123-60c7-e56d00cd01ca@de.ibm.com>
 <67653df1-1a9e-c406-c45c-f30b69a2ee8a@redhat.com>
 <b537af91-87a5-a1f7-343b-5b36b72d57a0@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <fcee5e74-efe3-f0eb-feac-d50f7ec4a0c8@redhat.com>
Date:   Tue, 22 Jun 2021 09:53:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <b537af91-87a5-a1f7-343b-5b36b72d57a0@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/2021 09.50, Christian Borntraeger wrote:
> 
> 
> On 22.06.21 09:46, Thomas Huth wrote:
>> On 22/06/2021 09.43, Christian Borntraeger wrote:
>>>
>>>
>>> On 22.06.21 09:36, Thomas Huth wrote:
>>>> On 21/06/2021 16.03, Heiko Carstens wrote:
>>>>> Using register asm statements has been proven to be very error prone,
>>>>> especially when using code instrumentation where gcc may add function
>>>>> calls, which clobbers register contents in an unexpected way.
>>>>>
>>>>> Therefore get rid of register asm statements in kvm code, even though
>>>>> there is currently nothing wrong with them. This way we know for sure
>>>>> that this bug class won't be introduced here.
>>>>>
>>>>> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
>>>>> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
>>>>> ---
>>>>>   arch/s390/kvm/kvm-s390.c | 18 +++++++++---------
>>>>>   1 file changed, 9 insertions(+), 9 deletions(-)
>>>>>
>>>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>>>> index 1296fc10f80c..4b7b24f07790 100644
>>>>> --- a/arch/s390/kvm/kvm-s390.c
>>>>> +++ b/arch/s390/kvm/kvm-s390.c
>>>>> @@ -329,31 +329,31 @@ static void allow_cpu_feat(unsigned long nr)
>>>>>   static inline int plo_test_bit(unsigned char nr)
>>>>>   {
>>>>> -    register unsigned long r0 asm("0") = (unsigned long) nr | 0x100;
>>>>> +    unsigned long function = (unsigned long) nr | 0x100;
>>>>>       int cc;
>>>>>       asm volatile(
>>>>> +        "    lgr    0,%[function]\n"
>>>>>           /* Parameter registers are ignored for "test bit" */
>>>>>           "    plo    0,0,0,0(0)\n"
>>>>>           "    ipm    %0\n"
>>>>>           "    srl    %0,28\n"
>>>>>           : "=d" (cc)
>>>>> -        : "d" (r0)
>>>>> -        : "cc");
>>>>> +        : [function] "d" (function)
>>>>> +        : "cc", "0");
>>>>>       return cc == 0;
>>>>>   }
>>>>>   static __always_inline void __insn32_query(unsigned int opcode, u8 
>>>>> *query)
>>>>>   {
>>>>> -    register unsigned long r0 asm("0") = 0;    /* query function */
>>>>> -    register unsigned long r1 asm("1") = (unsigned long) query;
>>>>> -
>>>>>       asm volatile(
>>>>> -        /* Parameter regs are ignored */
>>>>> +        "    lghi    0,0\n"
>>>>> +        "    lgr    1,%[query]\n"
>>>>> +        /* Parameter registers are ignored */
>>>>>           "    .insn    rrf,%[opc] << 16,2,4,6,0\n"
>>>>>           :
>>>>> -        : "d" (r0), "a" (r1), [opc] "i" (opcode)
>>>>> -        : "cc", "memory");
>>>>> +        : [query] "d" ((unsigned long)query), [opc] "i" (opcode)
>>>>
>>>> Wouldn't it be better to keep the "a" constraint instead of "d" to avoid 
>>>> that the compiler ever passes the "query" value in r0 ?
>>>> Otherwise the query value might get trashed if it is passed in r0...
>>>
>>> I first thought the same, but if you look closely the value is only used 
>>> by the lgr, to load
>>> the value finally into r1. So d is correct as lgr can take all registers.
>>
>> But what about the "lghi    0,0" right in front of it? ... I've got the 
>> feeling that I'm missing something here...
> 
> It does load an immediate value of 0 into register 0. Are you afraid of an 
> early clobber if
> gcc decides to use r0 for query?

Right, that was my concern. It's a "static __always_inline" function, so can 
we be sure that query is still always located in a register that is reserved 
for parameters (i.e. >= r2) ?

  Thomas


