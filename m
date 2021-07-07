Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76CB03BE603
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 11:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbhGGJ6F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 05:58:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11194 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230150AbhGGJ6F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 05:58:05 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1679ZCtk189338;
        Wed, 7 Jul 2021 05:55:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=jDXQsTaa+lxcNJEXAJ8od+lGjnZDTHZfKWbXITHOyPI=;
 b=TYTIOcKcPYsspDqZCVOLHwzSUOe2rSHoG+xYt6dpWKFDVsu/Cn8/q7pnZ/0WgEXhIT1r
 fti+FEcNep76korOdGvLQF7zuQrUw3hNmGR6TTb2SEWoDaZ+nTTbEA6D3T9K4dOIWkt4
 xYpR8Moac6t+3l2pQjhFKNfcuiDcp++iQ9fWlBpUJGRnyreA5qz5/6zIgjVLRG3Syb03
 co9n1uPPjTIMgZ9z3WP4izKKOocuuLQjUQXOl8ER42d1D/34jXK6ppJ0u92TYXpDHdaZ
 c+KKJ9gDnOLcXeiMxY3uAH4ClhlF5VWduYj4nIEpLIlw/7egAVKIR1qQg5K418ZcdN0j 1g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mm669hb2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 05:55:24 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1679aa6p193816;
        Wed, 7 Jul 2021 05:55:23 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mm669haj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 05:55:23 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1679rSKV011996;
        Wed, 7 Jul 2021 09:55:22 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 39jfh8sp73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 09:55:21 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1679rODZ12124602
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Jul 2021 09:53:24 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4DF9AE05A;
        Wed,  7 Jul 2021 09:55:18 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51BECAE053;
        Wed,  7 Jul 2021 09:55:18 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.25.185])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  7 Jul 2021 09:55:18 +0000 (GMT)
Subject: Re: [PATCH] KVM: s390: Enable specification exception interpretation
To:     Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
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
 <05430c91-6a84-0fc9-0af4-89f408eb691f@de.ibm.com> <87lf6ifqs5.fsf@redhat.com>
From:   Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>
Message-ID: <243a5476-153f-8d4b-7e0a-bb291010a3bd@linux.vnet.ibm.com>
Date:   Wed, 7 Jul 2021 11:55:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87lf6ifqs5.fsf@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uX1jevWFui0MdAnn8XqlFxNbqbqOAZ8E
X-Proofpoint-ORIG-GUID: y_RZqFGtdW5l7W9Dhia6sOx50M6SrVrE
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-07_05:2021-07-06,2021-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107070056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/7/21 10:54 AM, Cornelia Huck wrote:

[...]

> 
>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>> index b655a7d82bf0..aadd589a3755 100644
>>> --- a/arch/s390/kvm/kvm-s390.c
>>> +++ b/arch/s390/kvm/kvm-s390.c
>>> @@ -3200,6 +3200,8 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
>>>   		vcpu->arch.sie_block->ecb |= ECB_SRSI;
>>>   	if (test_kvm_facility(vcpu->kvm, 73))
>>>   		vcpu->arch.sie_block->ecb |= ECB_TE;
> 
> Maybe add
> 
> /* no facility bit, but safe as the hardware may ignore it */
> 
> or something like that, so that we don't stumble over that in the future?

Well, the hardware being allowed to ignore the bit makes its introduction
without an indication forward compatible because it does not require vSIE to be adapted.
The reserved bits are implicitly set to 0 which means new features are disabled
by default and one observes all the interception one expects.

Maybe this:

/* no facility bit, can opt in because we do not need
   to observe specification exception intercepts */

?

> 
>>> +	if (!kvm_is_ucontrol(vcpu->kvm))
>>> +		vcpu->arch.sie_block->ecb |= ECB_SPECI;
>>>
>>>   	if (test_kvm_facility(vcpu->kvm, 8) && vcpu->kvm->arch.use_pfmfi)
>>>   		vcpu->arch.sie_block->ecb2 |= ECB2_PFMFI;
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 

