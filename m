Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC3B7F7509
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 14:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbfKKNeO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 08:34:14 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28800 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726879AbfKKNeO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Nov 2019 08:34:14 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xABDXPKt137222
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 08:34:13 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w786as8x0-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 08:34:12 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Mon, 11 Nov 2019 13:34:10 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 11 Nov 2019 13:34:09 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xABDY8pi62390344
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 13:34:08 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75B86AE055;
        Mon, 11 Nov 2019 13:34:08 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45145AE045;
        Mon, 11 Nov 2019 13:34:08 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.41])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 11 Nov 2019 13:34:08 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH] s390x: Use loop to save and restore fprs
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com
References: <20191104085533.2892-1-frankja@linux.ibm.com>
 <5dfe4c62-5178-3e9c-b1bb-6814e020078e@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Mon, 11 Nov 2019 14:34:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <5dfe4c62-5178-3e9c-b1bb-6814e020078e@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19111113-0008-0000-0000-0000032E0915
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111113-0009-0000-0000-00004A4D0976
Message-Id: <49b6daa6-f5fd-9ca6-7ffb-ec7c23c5cf92@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-11_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=926 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911110127
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 11/8/19 10:15 AM, Thomas Huth wrote:
> On 04/11/2019 09.55, Janosch Frank wrote:
>> Let's save some lines in the assembly by using a loop to save and
>> restore the fprs.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   s390x/cstart64.S | 38 ++++++--------------------------------
>>   1 file changed, 6 insertions(+), 32 deletions(-)
>>
>> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
>> index 5dc1577..8e2b21e 100644
>> --- a/s390x/cstart64.S
>> +++ b/s390x/cstart64.S
>> @@ -99,44 +99,18 @@ memsetxc:
>>       lctlg    %c0, %c0, 0(%r1)
>>       /* save fprs 0-15 + fpc */
>>       la    %r1, GEN_LC_SW_INT_FPRS
>> -    std    %f0, 0(%r1)
>> -    std    %f1, 8(%r1)
>> -    std    %f2, 16(%r1)
>> -    std    %f3, 24(%r1)
>> -    std    %f4, 32(%r1)
>> -    std    %f5, 40(%r1)
>> -    std    %f6, 48(%r1)
>> -    std    %f7, 56(%r1)
>> -    std    %f8, 64(%r1)
>> -    std    %f9, 72(%r1)
>> -    std    %f10, 80(%r1)
>> -    std    %f11, 88(%r1)
>> -    std    %f12, 96(%r1)
>> -    std    %f13, 104(%r1)
>> -    std    %f14, 112(%r1)
>> -    std    %f15, 120(%r1)
>> +    .irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
>> +    std    \i, \i * 8(%r1)
>> +    .endr
>>       stfpc    GEN_LC_SW_INT_FPC
>>       .endm
>>         .macro RESTORE_REGS
>>       /* restore fprs 0-15 + fpc */
>>       la    %r1, GEN_LC_SW_INT_FPRS
>> -    ld    %f0, 0(%r1)
>> -    ld    %f1, 8(%r1)
>> -    ld    %f2, 16(%r1)
>> -    ld    %f3, 24(%r1)
>> -    ld    %f4, 32(%r1)
>> -    ld    %f5, 40(%r1)
>> -    ld    %f6, 48(%r1)
>> -    ld    %f7, 56(%r1)
>> -    ld    %f8, 64(%r1)
>> -    ld    %f9, 72(%r1)
>> -    ld    %f10, 80(%r1)
>> -    ld    %f11, 88(%r1)
>> -    ld    %f12, 96(%r1)
>> -    ld    %f13, 104(%r1)
>> -    ld    %f14, 112(%r1)
>> -    ld    %f15, 120(%r1)
>> +    .irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
>> +    ld    \i, \i * 8(%r1)
>> +    .endr
>>       lfpc    GEN_LC_SW_INT_FPC
>>       /* restore cr0 */
>>       lctlg    %c0, %c0, GEN_LC_SW_INT_CR0
>>
>
> Produces exactly the same code as before.
>
> Tested-by: Thomas Huth <thuth@redhat.com>
>
Good for me, makes the code smaller ... is better

Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>



-- 
Pierre Morel
IBM Lab Boeblingen

