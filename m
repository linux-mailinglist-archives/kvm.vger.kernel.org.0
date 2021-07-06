Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2D53BD498
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 14:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343536AbhGFMOb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 08:14:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49020 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240413AbhGFMFb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 08:05:31 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 166BX2Sn106333;
        Tue, 6 Jul 2021 08:02:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=NXMdCkMgA33HuT+2agyePyQ+fT/a6X6lPI3oa21I3gA=;
 b=k2N+uYnH2bvkI8DKYgy7RIBLQqbrKvPXfVFBrxVZL+XZ0UsQ6o8r714QyaS3WKRs+5CA
 RBUx1OJfJur3wzWVa394UVLr91fX5Z+ehFhB5q9cfn2VCHdDze+aBx61BXtPcemoYe/Y
 yxoNUCaug7NNO0lMStM7lTHbvB80M9pOiRLC4urUbwMHuFn+SCvdoWpamkvKi2qvIaPc
 7zt9wWCROanAzU7Pvb+Urz1DhLVuGLh+M61Nh9yh6hSraqI70NC4WaXsLk/15r6bRwyI
 n5ZaoKUlfNOpzNRMQbCChxomJa8ipPq3YppK/0KLHP2M4Qn1bXK63kg+w+ur25vHlgrF Rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mk51ejtj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 08:02:52 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 166BX2oE106289;
        Tue, 6 Jul 2021 08:02:51 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mk51ejrb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 08:02:51 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 166C2aNp003579;
        Tue, 6 Jul 2021 12:02:49 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 39jfh8s7xx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 12:02:49 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 166C2kfc34013592
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Jul 2021 12:02:46 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30F2342054;
        Tue,  6 Jul 2021 12:02:46 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C00F42049;
        Tue,  6 Jul 2021 12:02:45 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.59.107])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Jul 2021 12:02:45 +0000 (GMT)
Subject: Re: [PATCH] KVM: s390: Enable specification exception interpretation
To:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        "open list:KERNEL VIRTUAL MACHINE for s390 (KVM/s390)" 
        <kvm@vger.kernel.org>,
        "open list:S390" <linux-s390@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20210706114714.3936825-1-scgl@linux.ibm.com>
 <87k0m3hd7h.fsf@redhat.com> <194128c1-8886-5b8b-2249-5ec58b8e7adb@de.ibm.com>
 <be78ce5d-92e4-36bd-aa28-e32db0342a44@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <45690e80-5c7c-1e11-99d5-c0d1482755ad@de.ibm.com>
Date:   Tue, 6 Jul 2021 14:02:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <be78ce5d-92e4-36bd-aa28-e32db0342a44@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: c2tgzHEfCztvcrjwQLr8eDVlPfvWx8xZ
X-Proofpoint-GUID: iCHuPW6M_aJ-0TGdJpErHSbbr7ZeoUI4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-06_06:2021-07-02,2021-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 priorityscore=1501
 clxscore=1015 phishscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107060057
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06.07.21 13:59, David Hildenbrand wrote:
> On 06.07.21 13:56, Christian Borntraeger wrote:
>>
>>
>> On 06.07.21 13:52, Cornelia Huck wrote:
>>> On Tue, Jul 06 2021, Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
>>>
>>>> When this feature is enabled the hardware is free to interpret
>>>> specification exceptions generated by the guest, instead of causing
>>>> program interruption interceptions.
>>>>
>>>> This benefits (test) programs that generate a lot of specification
>>>> exceptions (roughly 4x increase in exceptions/sec).
>>>>
>>>> Interceptions will occur as before if ICTL_PINT is set,
>>>> i.e. if guest debug is enabled.
>>>>
>>>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>>>> ---
>>>> I'll additionally send kvm-unit-tests for testing this feature.
>>>>
>>>>    arch/s390/include/asm/kvm_host.h | 1 +
>>>>    arch/s390/kvm/kvm-s390.c         | 2 ++
>>>>    arch/s390/kvm/vsie.c             | 2 ++
>>>>    3 files changed, 5 insertions(+)
>>>
>>> (...)
>>>
>>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>>> index b655a7d82bf0..aadd589a3755 100644
>>>> --- a/arch/s390/kvm/kvm-s390.c
>>>> +++ b/arch/s390/kvm/kvm-s390.c
>>>> @@ -3200,6 +3200,8 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
>>>>            vcpu->arch.sie_block->ecb |= ECB_SRSI;
>>>>        if (test_kvm_facility(vcpu->kvm, 73))
>>>>            vcpu->arch.sie_block->ecb |= ECB_TE;
>>>> +    if (!kvm_is_ucontrol(vcpu->kvm))
>>>> +        vcpu->arch.sie_block->ecb |= ECB_SPECI;
>>>
>>> Does this exist for any hardware version (i.e. not guarded by a cpu
>>> feature?)
>>
>> Not for all hardware versions, but also no indication. The architecture
>> says that the HW is free to do this or not. (which makes the vsie code
>> simpler).
> 
> I remember the architecture said at some point to never set undefined bits - and this bit is undefined on older HW generations. I might be wrong, though.

I can confirm that this bit will be ignored on older machines. The notion of
never setting undefined bits comes from "you never know what this bit will
change in future machines". Now we know :-)
