Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2B73AFE25
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 09:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhFVHpo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 03:45:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61828 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229677AbhFVHpn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 03:45:43 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15M7XgQq017099;
        Tue, 22 Jun 2021 03:43:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=0EYK4igm3Kg06EEtTZ6SzXbbWAUCsbpv0MyHjMqLzVM=;
 b=foa0VyElwo7KfTjn4YRvrVXsHcIKz8v8f10lOON2CwY/AYpo4Kod5UdpFVSR3EkG3U+b
 /Z7NlxGgDXSwlb6sisExD6p8fYYjutZnIX+H+ZjeneSXkSs7qLbfqIu9bEx8FYB0hdMq
 CiYqTCEnjGwXUtknRLhQmsxaOYmp2lGJiXj3JIC757NQBjuiN9eqxSn17ZoclIEe+Xxv
 qBYig6XgjsR9eIAfbOymFiA/UVwYD/XMVTPmTu02xCGIcqu3jQrzoQJDZk3wMHAEO3w2
 uADY1RO1Cbh2E5TJL+cmP+bspk2cBGJaF0vO1hKAqshwVPD64JnCWZWe9fNJJ2837GWC AA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39bahp9s1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 03:43:27 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15M7Xo1k017575;
        Tue, 22 Jun 2021 03:43:27 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39bahp9s0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 03:43:27 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15M7hPH1023794;
        Tue, 22 Jun 2021 07:43:25 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3997uh99c2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 07:43:25 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15M7hM8P30146922
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 07:43:23 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D079BA4062;
        Tue, 22 Jun 2021 07:43:22 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F03AA405F;
        Tue, 22 Jun 2021 07:43:22 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.47.225])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Jun 2021 07:43:22 +0000 (GMT)
Subject: Re: [PATCH] KVM: s390: get rid of register asm usage
To:     Thomas Huth <thuth@redhat.com>, Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20210621140356.1210771-1-hca@linux.ibm.com>
 <7edaf85c-810b-e0f9-5977-6e89270f0709@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <ef34e1df-b56d-8123-60c7-e56d00cd01ca@de.ibm.com>
Date:   Tue, 22 Jun 2021 09:43:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <7edaf85c-810b-e0f9-5977-6e89270f0709@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wyxNkgUyrHErHPLawgHplsGavK6UDSz9
X-Proofpoint-GUID: MLL5Grot3te0TanmZsuiBFGTnohS_llA
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-22_04:2021-06-21,2021-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 malwarescore=0 impostorscore=0 mlxscore=0 clxscore=1015 spamscore=0
 mlxlogscore=999 phishscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106220046
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22.06.21 09:36, Thomas Huth wrote:
> On 21/06/2021 16.03, Heiko Carstens wrote:
>> Using register asm statements has been proven to be very error prone,
>> especially when using code instrumentation where gcc may add function
>> calls, which clobbers register contents in an unexpected way.
>>
>> Therefore get rid of register asm statements in kvm code, even though
>> there is currently nothing wrong with them. This way we know for sure
>> that this bug class won't be introduced here.
>>
>> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
>> ---
>>   arch/s390/kvm/kvm-s390.c | 18 +++++++++---------
>>   1 file changed, 9 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 1296fc10f80c..4b7b24f07790 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -329,31 +329,31 @@ static void allow_cpu_feat(unsigned long nr)
>>   static inline int plo_test_bit(unsigned char nr)
>>   {
>> -    register unsigned long r0 asm("0") = (unsigned long) nr | 0x100;
>> +    unsigned long function = (unsigned long) nr | 0x100;
>>       int cc;
>>       asm volatile(
>> +        "    lgr    0,%[function]\n"
>>           /* Parameter registers are ignored for "test bit" */
>>           "    plo    0,0,0,0(0)\n"
>>           "    ipm    %0\n"
>>           "    srl    %0,28\n"
>>           : "=d" (cc)
>> -        : "d" (r0)
>> -        : "cc");
>> +        : [function] "d" (function)
>> +        : "cc", "0");
>>       return cc == 0;
>>   }
>>   static __always_inline void __insn32_query(unsigned int opcode, u8 *query)
>>   {
>> -    register unsigned long r0 asm("0") = 0;    /* query function */
>> -    register unsigned long r1 asm("1") = (unsigned long) query;
>> -
>>       asm volatile(
>> -        /* Parameter regs are ignored */
>> +        "    lghi    0,0\n"
>> +        "    lgr    1,%[query]\n"
>> +        /* Parameter registers are ignored */
>>           "    .insn    rrf,%[opc] << 16,2,4,6,0\n"
>>           :
>> -        : "d" (r0), "a" (r1), [opc] "i" (opcode)
>> -        : "cc", "memory");
>> +        : [query] "d" ((unsigned long)query), [opc] "i" (opcode)
> 
> Wouldn't it be better to keep the "a" constraint instead of "d" to avoid that the compiler ever passes the "query" value in r0 ?
> Otherwise the query value might get trashed if it is passed in r0...

I first thought the same, but if you look closely the value is only used by the lgr, to load
the value finally into r1. So d is correct as lgr can take all registers.
