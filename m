Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C493AFE61
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 09:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhFVHwo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 03:52:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2042 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230377AbhFVHwd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 03:52:33 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15M7Xfo9149727;
        Tue, 22 Jun 2021 03:50:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=oZ2YFKZYILhRlNIk06dtI70vqN13MOl0zKdph1KWA8w=;
 b=KrGWEm26iFSM4QDpGm5RCkJdx1fwjFSA7qveBxXrb1UMSZ8cFu7gguUKIltTOHg/p/hr
 C6If2hDi9TO2WXxNybR24GRYyFvN+m1zQ7ST0O81v9OT4B/nTYm/Ph/iGB5ggdkWs/rC
 dCNNZig37cyrP8H6h76REt9/zYnBm1nFTAKD+Bfpm+yJDGEEQcYWCwbTLd5p/XKp3p8U
 6fz+URYKG7YYEs5DmPaVVhw1TkHgESBwFjTp0tY02VZaKstDfeOz9QqnQt+ad1oBzxum
 zV/pbV1M9JiHTFQ/pvyK/+C664XHyemjDJnC6wgVPU5wwohZgOYXqA6aEg/b8YRuL9Cf bA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39b94q3vn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 03:50:17 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15M7Xi3f149970;
        Tue, 22 Jun 2021 03:50:17 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39b94q3vmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 03:50:17 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15M7mZrV012367;
        Tue, 22 Jun 2021 07:50:15 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3998788psb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 07:50:15 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15M7oC3132309630
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 07:50:12 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79BA8A405F;
        Tue, 22 Jun 2021 07:50:12 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B365A4054;
        Tue, 22 Jun 2021 07:50:12 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.47.225])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Jun 2021 07:50:12 +0000 (GMT)
Subject: Re: [PATCH] KVM: s390: get rid of register asm usage
To:     Thomas Huth <thuth@redhat.com>, Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20210621140356.1210771-1-hca@linux.ibm.com>
 <7edaf85c-810b-e0f9-5977-6e89270f0709@redhat.com>
 <ef34e1df-b56d-8123-60c7-e56d00cd01ca@de.ibm.com>
 <67653df1-1a9e-c406-c45c-f30b69a2ee8a@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <b537af91-87a5-a1f7-343b-5b36b72d57a0@de.ibm.com>
Date:   Tue, 22 Jun 2021 09:50:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <67653df1-1a9e-c406-c45c-f30b69a2ee8a@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: r_A5dU9jWwMhS5O7eFZWJLmky3o7fhVn
X-Proofpoint-ORIG-GUID: 5nVZu8AiYo2pLIC3bBM0U60ha16eUNXR
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-22_04:2021-06-21,2021-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 mlxscore=0 suspectscore=0 phishscore=0 adultscore=0 clxscore=1015
 mlxlogscore=999 spamscore=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106220046
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22.06.21 09:46, Thomas Huth wrote:
> On 22/06/2021 09.43, Christian Borntraeger wrote:
>>
>>
>> On 22.06.21 09:36, Thomas Huth wrote:
>>> On 21/06/2021 16.03, Heiko Carstens wrote:
>>>> Using register asm statements has been proven to be very error prone,
>>>> especially when using code instrumentation where gcc may add function
>>>> calls, which clobbers register contents in an unexpected way.
>>>>
>>>> Therefore get rid of register asm statements in kvm code, even though
>>>> there is currently nothing wrong with them. This way we know for sure
>>>> that this bug class won't be introduced here.
>>>>
>>>> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
>>>> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
>>>> ---
>>>>   arch/s390/kvm/kvm-s390.c | 18 +++++++++---------
>>>>   1 file changed, 9 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>>> index 1296fc10f80c..4b7b24f07790 100644
>>>> --- a/arch/s390/kvm/kvm-s390.c
>>>> +++ b/arch/s390/kvm/kvm-s390.c
>>>> @@ -329,31 +329,31 @@ static void allow_cpu_feat(unsigned long nr)
>>>>   static inline int plo_test_bit(unsigned char nr)
>>>>   {
>>>> -    register unsigned long r0 asm("0") = (unsigned long) nr | 0x100;
>>>> +    unsigned long function = (unsigned long) nr | 0x100;
>>>>       int cc;
>>>>       asm volatile(
>>>> +        "    lgr    0,%[function]\n"
>>>>           /* Parameter registers are ignored for "test bit" */
>>>>           "    plo    0,0,0,0(0)\n"
>>>>           "    ipm    %0\n"
>>>>           "    srl    %0,28\n"
>>>>           : "=d" (cc)
>>>> -        : "d" (r0)
>>>> -        : "cc");
>>>> +        : [function] "d" (function)
>>>> +        : "cc", "0");
>>>>       return cc == 0;
>>>>   }
>>>>   static __always_inline void __insn32_query(unsigned int opcode, u8 *query)
>>>>   {
>>>> -    register unsigned long r0 asm("0") = 0;    /* query function */
>>>> -    register unsigned long r1 asm("1") = (unsigned long) query;
>>>> -
>>>>       asm volatile(
>>>> -        /* Parameter regs are ignored */
>>>> +        "    lghi    0,0\n"
>>>> +        "    lgr    1,%[query]\n"
>>>> +        /* Parameter registers are ignored */
>>>>           "    .insn    rrf,%[opc] << 16,2,4,6,0\n"
>>>>           :
>>>> -        : "d" (r0), "a" (r1), [opc] "i" (opcode)
>>>> -        : "cc", "memory");
>>>> +        : [query] "d" ((unsigned long)query), [opc] "i" (opcode)
>>>
>>> Wouldn't it be better to keep the "a" constraint instead of "d" to avoid that the compiler ever passes the "query" value in r0 ?
>>> Otherwise the query value might get trashed if it is passed in r0...
>>
>> I first thought the same, but if you look closely the value is only used by the lgr, to load
>> the value finally into r1. So d is correct as lgr can take all registers.
> 
> But what about the "lghi    0,0" right in front of it? ... I've got the feeling that I'm missing something here...

It does load an immediate value of 0 into register 0. Are you afraid of an early clobber if
gcc decides to use r0 for query?

> Heiko, maybe you could at least swap the initialization of r0 and r1, then I'd feel a little bit better...
> 
>   Thomas
> 
