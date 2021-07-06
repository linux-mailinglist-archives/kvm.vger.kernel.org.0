Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 635763BD490
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 14:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238932AbhGFMOT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 08:14:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21666 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238270AbhGFL7P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 07:59:15 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 166BY0cp145616;
        Tue, 6 Jul 2021 07:56:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=gkLeR13YxhYrgL4g74DrTzLLScBKEIu6g8/xpzgKjLk=;
 b=j+H+xyNmF3EC3IaH+Z2hJdRgu1I4DvdP+lx7J8HPk3vTuWNzsm8tiIhGLdDfI9hc145Y
 8MJ0DXOdmYBcGx2JiA4EzxFeC8o01LKGpj76zvmSNxOv6zt7E53hPaOqsmPMh3WL00qv
 V85QDuVZzEjYnKQUABXu5e+O1Fd07WJGFTUefpxqzoW+6QXR7MAswmdsId9fGXay92tD
 9LhxnvzdKHyTl2ZUMp3f9dtZHEcRaCBRQbbGNY0Ju6xB7VXL1DNfv2aI1cnw20HA9925
 ngTWYGWJyxblZd1nrcmNJtMXhU3eiKh1WRIlKI7/w6sChbVcGxfClMITfj62b1hfqW3f rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mn8ejuev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 07:56:34 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 166BZJFZ153218;
        Tue, 6 Jul 2021 07:56:34 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mn8ejued-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 07:56:33 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 166BrgmJ017146;
        Tue, 6 Jul 2021 11:56:32 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 39jfh88npa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 11:56:31 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 166BuSdS30736734
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Jul 2021 11:56:28 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AFA5C4204B;
        Tue,  6 Jul 2021 11:56:28 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB9FA4203F;
        Tue,  6 Jul 2021 11:56:27 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.59.107])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Jul 2021 11:56:27 +0000 (GMT)
Subject: Re: [PATCH] KVM: s390: Enable specification exception interpretation
To:     Cornelia Huck <cohuck@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        "open list:KERNEL VIRTUAL MACHINE for s390 (KVM/s390)" 
        <kvm@vger.kernel.org>,
        "open list:S390" <linux-s390@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20210706114714.3936825-1-scgl@linux.ibm.com>
 <87k0m3hd7h.fsf@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <194128c1-8886-5b8b-2249-5ec58b8e7adb@de.ibm.com>
Date:   Tue, 6 Jul 2021 13:56:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87k0m3hd7h.fsf@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: V6HInOxZM1vGFMPqZz6fMyWexx0GtlcK
X-Proofpoint-GUID: vLYuAiXOLm4-i88ytUi1aRGxCzE46Md9
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-06_06:2021-07-02,2021-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 clxscore=1015 impostorscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107060057
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06.07.21 13:52, Cornelia Huck wrote:
> On Tue, Jul 06 2021, Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
> 
>> When this feature is enabled the hardware is free to interpret
>> specification exceptions generated by the guest, instead of causing
>> program interruption interceptions.
>>
>> This benefits (test) programs that generate a lot of specification
>> exceptions (roughly 4x increase in exceptions/sec).
>>
>> Interceptions will occur as before if ICTL_PINT is set,
>> i.e. if guest debug is enabled.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> ---
>> I'll additionally send kvm-unit-tests for testing this feature.
>>
>>   arch/s390/include/asm/kvm_host.h | 1 +
>>   arch/s390/kvm/kvm-s390.c         | 2 ++
>>   arch/s390/kvm/vsie.c             | 2 ++
>>   3 files changed, 5 insertions(+)
> 
> (...)
> 
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index b655a7d82bf0..aadd589a3755 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -3200,6 +3200,8 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
>>   		vcpu->arch.sie_block->ecb |= ECB_SRSI;
>>   	if (test_kvm_facility(vcpu->kvm, 73))
>>   		vcpu->arch.sie_block->ecb |= ECB_TE;
>> +	if (!kvm_is_ucontrol(vcpu->kvm))
>> +		vcpu->arch.sie_block->ecb |= ECB_SPECI;
> 
> Does this exist for any hardware version (i.e. not guarded by a cpu
> feature?)

Not for all hardware versions, but also no indication. The architecture
says that the HW is free to do this or not. (which makes the vsie code
simpler).
> 
>>   
>>   	if (test_kvm_facility(vcpu->kvm, 8) && vcpu->kvm->arch.use_pfmfi)
>>   		vcpu->arch.sie_block->ecb2 |= ECB2_PFMFI;
> 
