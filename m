Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A88563AFEAF
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 10:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbhFVIGk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 04:06:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49289 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229807AbhFVIGj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 04:06:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624349064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MjeXPHu/4UDH7ZPmnA9R3lgnej3JwJud2wr6WbqhTls=;
        b=cs41D6g8WM/T4CyUMi2GElgnhuyHvwS07/AigqUwAhbVL/nG+Hzi8S52XsnvcJMqFY/m8Z
        i0+QD6N5aW0ebI+eN7fBMgRsQqUH0swXet6lXr5EWcDC+AmTUEpveF3eppRmu45gT5pWe9
        76M4d29z+CrGGPAnJIaba8XTlZ6vNrU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-UDTCF0haOKqE1kVO4Hwn9Q-1; Tue, 22 Jun 2021 04:04:22 -0400
X-MC-Unique: UDTCF0haOKqE1kVO4Hwn9Q-1
Received: by mail-wm1-f72.google.com with SMTP id s15-20020a7bc38f0000b02901dbb76fabe9so979250wmj.4
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 01:04:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MjeXPHu/4UDH7ZPmnA9R3lgnej3JwJud2wr6WbqhTls=;
        b=VWbOynEUYU2hOqgehGLgZiIhTR3Oyfnv786vO6J9cyKpP4q7Zb3hWjVVaGFXSPxV2w
         haCtKhHmmGZqLCHX+ewiwN6j+gJFoRek08gNeqwCbLptxjpWrIVNbz35R2O4nqdsxlw4
         FAeSVDqrdYtlXmGbyhstIbDa6gwATfNc0MBdUKZQkQes3X7EY9ty/pcjuHdbcP4UBOb1
         nM3BV28ybHqICZa56m60DhEFii8/z9IiYT7gUZg2AwxQfYTT8tIX6uxbBLf8GFCFa7O2
         cCYJw+pkxNXQI5VoqY7RpEyEJ/znXqJvooTJYVKdhVQ0FziEYly9cwpMwsw7QVszqIli
         YNrg==
X-Gm-Message-State: AOAM530jW6NwVX249sEXwS/ZrEaGnesGVyt40DOChgIl4nV/BxrnWexe
        QkIc0oNStkW7RiadHaRfHz38edb3H3SI6RiU6V8b6OHIdS8P/0cxADq3UnsHmPwv6Ie8nspw+3d
        r7+v9TojXGvtB
X-Received: by 2002:a5d:6c65:: with SMTP id r5mr3017438wrz.339.1624349061275;
        Tue, 22 Jun 2021 01:04:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzP2X/sZQGxlaQWDDJPAzf130gZnIwkW/gBhndKOL1M4X1zpFcyW3GSC7MTxOzii1AEVqwhLQ==
X-Received: by 2002:a5d:6c65:: with SMTP id r5mr3017414wrz.339.1624349061051;
        Tue, 22 Jun 2021 01:04:21 -0700 (PDT)
Received: from thuth.remote.csb (pd9575f2f.dip0.t-ipconnect.de. [217.87.95.47])
        by smtp.gmail.com with ESMTPSA id c13sm20717808wrb.5.2021.06.22.01.04.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 01:04:20 -0700 (PDT)
Subject: Re: [PATCH] KVM: s390: get rid of register asm usage
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        Andreas Krebbel <krebbel@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20210621140356.1210771-1-hca@linux.ibm.com>
 <7edaf85c-810b-e0f9-5977-6e89270f0709@redhat.com>
 <ef34e1df-b56d-8123-60c7-e56d00cd01ca@de.ibm.com>
 <67653df1-1a9e-c406-c45c-f30b69a2ee8a@redhat.com>
 <b537af91-87a5-a1f7-343b-5b36b72d57a0@de.ibm.com>
 <fcee5e74-efe3-f0eb-feac-d50f7ec4a0c8@redhat.com>
 <1b8583e7-a39d-10ca-982f-d513b3f9016a@de.ibm.com>
 <facc1000-e8dc-c373-5db0-1ca5c25c6bb8@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <98cd63e6-25c9-52e7-fc3c-fc994db6a262@redhat.com>
Date:   Tue, 22 Jun 2021 10:04:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <facc1000-e8dc-c373-5db0-1ca5c25c6bb8@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/2021 10.00, Christian Borntraeger wrote:
> 
> 
> On 22.06.21 09:57, Christian Borntraeger wrote:
>>
>>
>> On 22.06.21 09:53, Thomas Huth wrote:
>>> On 22/06/2021 09.50, Christian Borntraeger wrote:
>>>>
>>>>
>>>> On 22.06.21 09:46, Thomas Huth wrote:
>>>>> On 22/06/2021 09.43, Christian Borntraeger wrote:
>>>>>>
>>>>>>
>>>>>> On 22.06.21 09:36, Thomas Huth wrote:
>>>>>>> On 21/06/2021 16.03, Heiko Carstens wrote:
>>>>>>>> Using register asm statements has been proven to be very error prone,
>>>>>>>> especially when using code instrumentation where gcc may add function
>>>>>>>> calls, which clobbers register contents in an unexpected way.
>>>>>>>>
>>>>>>>> Therefore get rid of register asm statements in kvm code, even though
>>>>>>>> there is currently nothing wrong with them. This way we know for sure
>>>>>>>> that this bug class won't be introduced here.
>>>>>>>>
>>>>>>>> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
>>>>>>>> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
>>>>>>>> ---
>>>>>>>>   arch/s390/kvm/kvm-s390.c | 18 +++++++++---------
>>>>>>>>   1 file changed, 9 insertions(+), 9 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>>>>>>> index 1296fc10f80c..4b7b24f07790 100644
>>>>>>>> --- a/arch/s390/kvm/kvm-s390.c
>>>>>>>> +++ b/arch/s390/kvm/kvm-s390.c
>>>>>>>> @@ -329,31 +329,31 @@ static void allow_cpu_feat(unsigned long nr)
>>>>>>>>   static inline int plo_test_bit(unsigned char nr)
>>>>>>>>   {
>>>>>>>> -    register unsigned long r0 asm("0") = (unsigned long) nr | 0x100;
>>>>>>>> +    unsigned long function = (unsigned long) nr | 0x100;
>>>>>>>>       int cc;
>>>>>>>>       asm volatile(
>>>>>>>> +        "    lgr    0,%[function]\n"
>>>>>>>>           /* Parameter registers are ignored for "test bit" */
>>>>>>>>           "    plo    0,0,0,0(0)\n"
>>>>>>>>           "    ipm    %0\n"
>>>>>>>>           "    srl    %0,28\n"
>>>>>>>>           : "=d" (cc)
>>>>>>>> -        : "d" (r0)
>>>>>>>> -        : "cc");
>>>>>>>> +        : [function] "d" (function)
>>>>>>>> +        : "cc", "0");
>>>>>>>>       return cc == 0;
>>>>>>>>   }
>>>>>>>>   static __always_inline void __insn32_query(unsigned int opcode, u8 
>>>>>>>> *query)
>>>>>>>>   {
>>>>>>>> -    register unsigned long r0 asm("0") = 0;    /* query function */
>>>>>>>> -    register unsigned long r1 asm("1") = (unsigned long) query;
>>>>>>>> -
>>>>>>>>       asm volatile(
>>>>>>>> -        /* Parameter regs are ignored */
>>>>>>>> +        "    lghi    0,0\n"
>>>>>>>> +        "    lgr    1,%[query]\n"
>>>>>>>> +        /* Parameter registers are ignored */
>>>>>>>>           "    .insn    rrf,%[opc] << 16,2,4,6,0\n"
>>>>>>>>           :
>>>>>>>> -        : "d" (r0), "a" (r1), [opc] "i" (opcode)
>>>>>>>> -        : "cc", "memory");
>>>>>>>> +        : [query] "d" ((unsigned long)query), [opc] "i" (opcode)
>>          : "cc", "memory", "0", "1");
>>>>>>>
>>>>>>> Wouldn't it be better to keep the "a" constraint instead of "d" to 
>>>>>>> avoid that the compiler ever passes the "query" value in r0 ?
>>>>>>> Otherwise the query value might get trashed if it is passed in r0...
>>>>>>
>>>>>> I first thought the same, but if you look closely the value is only 
>>>>>> used by the lgr, to load
>>>>>> the value finally into r1. So d is correct as lgr can take all registers.
>>>>>
>>>>> But what about the "lghi    0,0" right in front of it? ... I've got the 
>>>>> feeling that I'm missing something here...
>>>>
>>>> It does load an immediate value of 0 into register 0. Are you afraid of 
>>>> an early clobber if
>>>> gcc decides to use r0 for query?
>>>
>>> Right, that was my concern. It's a "static __always_inline" function, so 
>>> can we be sure that query is still always located in a register that is 
>>> reserved for parameters (i.e. >= r2) ?
>>
>> Adding Andreas. I know that gcc provides the early clobber "&" if an 
>> output is written before all imputs are used.
>> but in this case it is not an output but a clobbered register.
>> The clobber list contains 0 and 1, so I guess gcc will never use those as 
>> input register.
>> Andreas, is that correct?
>>
>>
>> PS: Of course switching both instructions does not hurt
> 
> Answering myself:
> 
> https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html#Clobbers-and-Scratch-Registers 
> 
> When the compiler selects which registers to use to represent input and 
> output operands, it does not use any of the clobbered registers. As a 
> result, clobbered registers are available for any use in the assembler code.

Ah, ok, TIL, thanks, then it is fine as it is. Feel free to add my 
Reviewed-by without any further modifications.

  Thomas

