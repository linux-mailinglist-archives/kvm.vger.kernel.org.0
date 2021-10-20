Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15AB643448F
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 07:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbhJTFQo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 01:16:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63284 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229520AbhJTFQm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 01:16:42 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19K4tMv4001661;
        Wed, 20 Oct 2021 01:14:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3T+6eqNQOKYVvmw+7/AAGoGrfgGTgDgUhcLwRnBZxnE=;
 b=sSG/HUI8SdNVwJ1UTYTLJtYMc9u+bsqXfJkzspTRNqFo89GP8g7Ke6si/QHsGZSM+RMD
 o4Z1Z2UWqdtkzAW/XgplfJE+E+9Df2Oe6YB/gCuIGteislJWnJi4GvfeiyXGZJbpCd7R
 hlGbymx6Jgp/GhJw4Udde9Zr4Zm3ReZNGnFpC1ASUHlhnI0OhdfJUM848/ZijmS20rlN
 C9qS+yakr524OpFqmOBAm21Eq4SQMhSab5uNk1KZFe9Wtk86ap5i05JqOKvSBMMQJXcO
 3gDMi4nHS6L8bdyruYf/PHOrxz7EiPD6G1rQWgcqLCGKEs/7dRJI+KY/g4h47qrBBhSJ xQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bt3an2x0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 01:14:28 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19K486Pg001432;
        Wed, 20 Oct 2021 01:14:28 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bt3an2x07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 01:14:27 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19K57XK7018166;
        Wed, 20 Oct 2021 05:14:25 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3bqpc9nyv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 05:14:25 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19K5EMXr35324292
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 05:14:22 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CDCB11C050;
        Wed, 20 Oct 2021 05:14:22 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94D9E11C04A;
        Wed, 20 Oct 2021 05:14:21 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown [9.171.54.36])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Oct 2021 05:14:21 +0000 (GMT)
Subject: Re: [PATCH 3/3] KVM: s390: clear kicked_mask if not idle after set
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Halil Pasic <pasic@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>, farman@linux.ibm.com,
        kvm@vger.kernel.org
References: <20211019175401.3757927-1-pasic@linux.ibm.com>
 <20211019175401.3757927-4-pasic@linux.ibm.com>
 <c5c84a99-c56a-2232-7574-a6d207d7c11f@de.ibm.com>
Message-ID: <03b33367-ccde-a121-0faf-c347f2c789e2@de.ibm.com>
Date:   Wed, 20 Oct 2021 07:14:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <c5c84a99-c56a-2232-7574-a6d207d7c11f@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7HxqCtvYRHqgc9kufuJXjhn7rIEim9pl
X-Proofpoint-ORIG-GUID: 5lV1u1_KiSb0MgT1q19gKu6VCMIkgiNB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-20_01,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 priorityscore=1501
 adultscore=0 suspectscore=0 impostorscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110200025
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 19.10.21 um 23:35 schrieb Christian Borntraeger:
> 
> 
> Am 19.10.21 um 19:54 schrieb Halil Pasic:
>> The idea behind kicked mask is that we should not re-kick a vcpu
>> from __airqs_kick_single_vcpu() that is already in the middle of
>> being kicked by the same function.
>>
>> If however the vcpu that was idle before when the idle_mask was
>> examined, is not idle any more after the kicked_mask is set, that
>> means that we don't need to kick, and that we need to clear the
>> bit we just set because we may be beyond the point where it would
>> get cleared in the wake-up process. Since the time window is short,
>> this is probably more a theoretical than a practical thing: the race
>> window is small.
>>
>> To get things harmonized let us also move the clear from vcpu_pre_run()
>> to __unset_cpu_idle().
> 
> this part makes sense.
>>
>> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
>> Fixes: 9f30f6216378 ("KVM: s390: add gib_alert_irq_handler()")
>> ---
>>   arch/s390/kvm/interrupt.c | 7 ++++++-
>>   arch/s390/kvm/kvm-s390.c  | 2 --
>>   2 files changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
>> index 2245f4b8d362..3c80a2237ef5 100644
>> --- a/arch/s390/kvm/interrupt.c
>> +++ b/arch/s390/kvm/interrupt.c
>> @@ -426,6 +426,7 @@ static void __unset_cpu_idle(struct kvm_vcpu *vcpu)
>>   {
>>       kvm_s390_clear_cpuflags(vcpu, CPUSTAT_WAIT);
>>       clear_bit(vcpu->vcpu_idx, vcpu->kvm->arch.idle_mask);
>> +    clear_bit(vcpu->vcpu_idx, vcpu->kvm->arch.gisa_int.kicked_mask);
>>   }
>>   static void __reset_intercept_indicators(struct kvm_vcpu *vcpu)
>> @@ -3064,7 +3065,11 @@ static void __airqs_kick_single_vcpu(struct kvm *kvm, u8 deliverable_mask)
>>               /* lately kicked but not yet running */
>>               if (test_and_set_bit(vcpu_idx, gi->kicked_mask))
>>                   return;
>> -            kvm_s390_vcpu_wakeup(vcpu);
>> +            /* if meanwhile not idle: clear  and don't kick */
>> +            if (test_bit(vcpu_idx, kvm->arch.idle_mask))
>> +                kvm_s390_vcpu_wakeup(vcpu);
>> +            else
>> +                clear_bit(vcpu_idx, gi->kicked_mask);
> 
> I think this is now a bug. We should not return but continue in that case, no?

Thinking again about this, it might be ok. If we went from idle to non-idle we
likely were in SIE and the interrupt should have been delivered. But I would rather
wake up too often than too less.
> 
> I think it might be safer to also clear kicked_mask in __set_cpu_idle
>  From a CPUs perspective: We have been running and are on our way to become idle.
> There is no way that someone kicked us for a wakeup. In other words as long as we
> are running, there is no point in kicking us but when going idle we should get rid
> of old kick_mask bit.
> Doesnt this cover your scenario?
> 
> 
>>               return;
>>           }
>>       }
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 1c97493d21e1..6b779ef9f5fb 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -4067,8 +4067,6 @@ static int vcpu_pre_run(struct kvm_vcpu *vcpu)
>>           kvm_s390_patch_guest_per_regs(vcpu);
>>       }
>> -    clear_bit(vcpu->vcpu_idx, vcpu->kvm->arch.gisa_int.kicked_mask);
>> -
>>       vcpu->arch.sie_block->icptcode = 0;
>>       cpuflags = atomic_read(&vcpu->arch.sie_block->cpuflags);
>>       VCPU_EVENT(vcpu, 6, "entering sie flags %x", cpuflags);
>>
