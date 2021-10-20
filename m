Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C344344E9
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 08:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhJTGGG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 02:06:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50532 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229591AbhJTGGC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 02:06:02 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19K5lNl0007601;
        Wed, 20 Oct 2021 02:03:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=KQEWgGGDVaiGHqNLT+Oq5+RQlUlQQ177dp0T2ad8Ln4=;
 b=q7zx0NWV5zfUc4effwqsez+g14MQfUmDAba108XBFC+Jljb6V4TzAtbPCWMHek2nL6yr
 iGx0wiOx69CW/+ohhAxZtlQTmZ9VnkChTypVijekKNxQZSg+IVXMtngN4lyxWifEqcIu
 cg8wRx9BBzaayObdoDmcZEg+BQuGlZjLUcSXEeu/z0FXQJWXoV6c4IVR/on9MTH4M8Vo
 HW9fxJM3oVbeoO5aKS/CvR2qMh2C1+hidZEuHUzmUY1aY9MCvHIzp5uv6zyFgxsjONU2
 qZe7WPgfF2DI9HM1DF4fTQ1OV2cc8xNx5TimKna5Lti+Us2nEpogk5O78aU5AA81T+18 Xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3btd978929-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 02:03:47 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19K5pCwB022374;
        Wed, 20 Oct 2021 02:03:47 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3btd97891m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 02:03:47 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19K5wMAD030287;
        Wed, 20 Oct 2021 06:03:45 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3bqp0k6nv3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 06:03:45 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19K5vn7J62259542
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 05:57:49 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26CB111C054;
        Wed, 20 Oct 2021 06:03:42 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82F8711C069;
        Wed, 20 Oct 2021 06:03:41 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown [9.171.54.36])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Oct 2021 06:03:41 +0000 (GMT)
Subject: Re: [PATCH 1/3] KVM: s390: clear kicked_mask before sleeping again
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>, farman@linux.ibm.com,
        kvm@vger.kernel.org
References: <20211019175401.3757927-1-pasic@linux.ibm.com>
 <20211019175401.3757927-2-pasic@linux.ibm.com>
 <20211020073515.3ad4c377@p-imbrenda>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <1641267f-3a23-aba1-ab50-6f7c15e44528@de.ibm.com>
Date:   Wed, 20 Oct 2021 08:03:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211020073515.3ad4c377@p-imbrenda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: KeEnzLwe8yti7d9FIebmk5PddruKH9J4
X-Proofpoint-ORIG-GUID: 3ICHAfukUS_BuvceCNhfNFX67Xk1ObDq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-20_02,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110200032
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 20.10.21 um 07:35 schrieb Claudio Imbrenda:
> On Tue, 19 Oct 2021 19:53:59 +0200
> Halil Pasic <pasic@linux.ibm.com> wrote:
> 
>> The idea behind kicked mask is that we should not re-kick a vcpu that
>> is already in the "kick" process, i.e. that was kicked and is
>> is about to be dispatched if certain conditions are met.
>>
>> The problem with the current implementation is, that it assumes the
>> kicked vcpu is going to enter SIE shortly. But under certain
>> circumstances, the vcpu we just kicked will be deemed non-runnable and
>> will remain in wait state. This can happen, if the interrupt(s) this
>> vcpu got kicked to deal with got already cleared (because the interrupts
>> got delivered to another vcpu). In this case kvm_arch_vcpu_runnable()
>> would return false, and the vcpu would remain in kvm_vcpu_block(),
>> but this time with its kicked_mask bit set. So next time around we
>> wouldn't kick the vcpu form __airqs_kick_single_vcpu(), but would assume
>> that we just kicked it.
>>
>> Let us make sure the kicked_mask is cleared before we give up on
>> re-dispatching the vcpu.
>>
>> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
>> Reported-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> Fixes: 9f30f6216378 ("KVM: s390: add gib_alert_irq_handler()")
>> ---
>>   arch/s390/kvm/kvm-s390.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 6a6dd5e1daf6..1c97493d21e1 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -3363,6 +3363,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>>   
>>   int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
>>   {
>> +	clear_bit(vcpu->vcpu_idx, vcpu->kvm->arch.gisa_int.kicked_mask);
> 
> so, you unconditionally clear the flag, before knowing if the vCPU is
> runnable?
> 
> from your description I would have expected to only clear the bit if
> the vCPU is not runnable.
> 
> would things break if we were to try to kick the vCPU again after
> clearing the bit, but before dispatching it?

The whole logic is just an optimization to avoid unnecessary wakeups.
When the bit is set a wakup might be omitted.
I prefer to do an unneeded wakeup over not doing a wakeup so I think
over-clearing is safer.
In fact, getting rid of this micro-optimization would be a valid
alternative.
> 
>>   	return kvm_s390_vcpu_has_irq(vcpu, 0);
>>   }
>>   
> 
