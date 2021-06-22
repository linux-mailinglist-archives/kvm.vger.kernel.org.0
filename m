Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C153AFEA1
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 10:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhFVIDc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 04:03:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16900 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230397AbhFVIDT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 04:03:19 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15M7YAwA182069;
        Tue, 22 Jun 2021 04:01:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Oh61P9WUKNjXlBU0KupHEE4eIErnMKu1GAPHBXnhcDY=;
 b=KfJQy0ZLxpKWRGNH1/6EJKSIDCznCLB3QuJfgg+mUnVEBelu/AlFEq8bvrYuA81kspaQ
 FufQ7mdD5DdUk1pK7pdQH5es3V4WYaLxW/GeVA9pk8EC7uia9COKZVYFIPXJ/5e+okm5
 lGaBwjNrJO5BDs6M4AAqSQXSg+5CCUxtd+rqOR2scktcBbWAURVtmVUeRGWPO1eTWMIj
 T0S5YfMGYdLjEyD/r00GVi9x5Qg+We8nwRW4eNwDx6v//tVGy44KPi5glVPDGkwMlZlD
 ObQsvLQOXp9yqqZjIu+ibwdWRNS2iPTOJ+UUMFw7gdPUvHKwFd215KZXvfpV9TjcOV1D Gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39bae3tjrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 04:01:04 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15M7YaH8187029;
        Tue, 22 Jun 2021 04:01:03 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39bae3tjpa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 04:01:03 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15M80vZ8026857;
        Tue, 22 Jun 2021 08:01:00 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3997uhgq9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 08:01:00 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15M80vda25362750
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 08:00:57 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4653CA4068;
        Tue, 22 Jun 2021 08:00:57 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A82ACA4066;
        Tue, 22 Jun 2021 08:00:56 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.47.225])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Jun 2021 08:00:56 +0000 (GMT)
Subject: Re: [PATCH] KVM: s390: get rid of register asm usage
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Thomas Huth <thuth@redhat.com>, Heiko Carstens <hca@linux.ibm.com>,
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
Message-ID: <facc1000-e8dc-c373-5db0-1ca5c25c6bb8@de.ibm.com>
Date:   Tue, 22 Jun 2021 10:00:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <1b8583e7-a39d-10ca-982f-d513b3f9016a@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _Qe9wYTTgekx0NZJcdaYKbGD9ROjKnit
X-Proofpoint-ORIG-GUID: FN0SqjP1jvqmorHrl-_Y4YnBsuXy0njO
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-22_04:2021-06-21,2021-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 mlxlogscore=999 bulkscore=0 impostorscore=0 mlxscore=0 spamscore=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106220046
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22.06.21 09:57, Christian Borntraeger wrote:
> 
> 
> On 22.06.21 09:53, Thomas Huth wrote:
>> On 22/06/2021 09.50, Christian Borntraeger wrote:
>>>
>>>
>>> On 22.06.21 09:46, Thomas Huth wrote:
>>>> On 22/06/2021 09.43, Christian Borntraeger wrote:
>>>>>
>>>>>
>>>>> On 22.06.21 09:36, Thomas Huth wrote:
>>>>>> On 21/06/2021 16.03, Heiko Carstens wrote:
>>>>>>> Using register asm statements has been proven to be very error prone,
>>>>>>> especially when using code instrumentation where gcc may add function
>>>>>>> calls, which clobbers register contents in an unexpected way.
>>>>>>>
>>>>>>> Therefore get rid of register asm statements in kvm code, even though
>>>>>>> there is currently nothing wrong with them. This way we know for sure
>>>>>>> that this bug class won't be introduced here.
>>>>>>>
>>>>>>> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
>>>>>>> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
>>>>>>> ---
>>>>>>>   arch/s390/kvm/kvm-s390.c | 18 +++++++++---------
>>>>>>>   1 file changed, 9 insertions(+), 9 deletions(-)
>>>>>>>
>>>>>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>>>>>> index 1296fc10f80c..4b7b24f07790 100644
>>>>>>> --- a/arch/s390/kvm/kvm-s390.c
>>>>>>> +++ b/arch/s390/kvm/kvm-s390.c
>>>>>>> @@ -329,31 +329,31 @@ static void allow_cpu_feat(unsigned long nr)
>>>>>>>   static inline int plo_test_bit(unsigned char nr)
>>>>>>>   {
>>>>>>> -    register unsigned long r0 asm("0") = (unsigned long) nr | 0x100;
>>>>>>> +    unsigned long function = (unsigned long) nr | 0x100;
>>>>>>>       int cc;
>>>>>>>       asm volatile(
>>>>>>> +        "    lgr    0,%[function]\n"
>>>>>>>           /* Parameter registers are ignored for "test bit" */
>>>>>>>           "    plo    0,0,0,0(0)\n"
>>>>>>>           "    ipm    %0\n"
>>>>>>>           "    srl    %0,28\n"
>>>>>>>           : "=d" (cc)
>>>>>>> -        : "d" (r0)
>>>>>>> -        : "cc");
>>>>>>> +        : [function] "d" (function)
>>>>>>> +        : "cc", "0");
>>>>>>>       return cc == 0;
>>>>>>>   }
>>>>>>>   static __always_inline void __insn32_query(unsigned int opcode, u8 *query)
>>>>>>>   {
>>>>>>> -    register unsigned long r0 asm("0") = 0;    /* query function */
>>>>>>> -    register unsigned long r1 asm("1") = (unsigned long) query;
>>>>>>> -
>>>>>>>       asm volatile(
>>>>>>> -        /* Parameter regs are ignored */
>>>>>>> +        "    lghi    0,0\n"
>>>>>>> +        "    lgr    1,%[query]\n"
>>>>>>> +        /* Parameter registers are ignored */
>>>>>>>           "    .insn    rrf,%[opc] << 16,2,4,6,0\n"
>>>>>>>           :
>>>>>>> -        : "d" (r0), "a" (r1), [opc] "i" (opcode)
>>>>>>> -        : "cc", "memory");
>>>>>>> +        : [query] "d" ((unsigned long)query), [opc] "i" (opcode)
>          : "cc", "memory", "0", "1");
>>>>>>
>>>>>> Wouldn't it be better to keep the "a" constraint instead of "d" to avoid that the compiler ever passes the "query" value in r0 ?
>>>>>> Otherwise the query value might get trashed if it is passed in r0...
>>>>>
>>>>> I first thought the same, but if you look closely the value is only used by the lgr, to load
>>>>> the value finally into r1. So d is correct as lgr can take all registers.
>>>>
>>>> But what about the "lghi    0,0" right in front of it? ... I've got the feeling that I'm missing something here...
>>>
>>> It does load an immediate value of 0 into register 0. Are you afraid of an early clobber if
>>> gcc decides to use r0 for query?
>>
>> Right, that was my concern. It's a "static __always_inline" function, so can we be sure that query is still always located in a register that is reserved for parameters (i.e. >= r2) ?
> 
> Adding Andreas. I know that gcc provides the early clobber "&" if an output is written before all imputs are used.
> but in this case it is not an output but a clobbered register.
> The clobber list contains 0 and 1, so I guess gcc will never use those as input register.
> Andreas, is that correct?
> 
> 
> PS: Of course switching both instructions does not hurt

Answering myself:

https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html#Clobbers-and-Scratch-Registers

When the compiler selects which registers to use to represent input and output operands, it does not use any of the clobbered registers. As a result, clobbered registers are available for any use in the assembler code.
