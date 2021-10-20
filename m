Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E79AD434845
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 11:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhJTJur (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 05:50:47 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25964 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230063AbhJTJup (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 05:50:45 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19K8IW5f009771;
        Wed, 20 Oct 2021 05:48:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=soYY09EUFrDujntjpPn0PsbT4kBFy6Una/EANqQW50I=;
 b=iaE2qnfOchTQjIQRqN6bHfHIcXNqsUy5MdWYmRwBM7+Xr82RXqaOj4cF2Y19j77uwEUU
 4aNN5Ph/NxaQmgW1YIfskj5DdLF7uTnYRn8l0xm1UFj7+1aaO5cvld5usHdZGr6neELV
 oU5C/JJEhKMh/cadB+tGNtOLrI13MtLc2VkuD2rxgcGFh3K82FZV/7xxvgSUeE2TeTP3
 CVPhmnlWXF2m0UZypiwJXxkOkubaF0rHEhNtv/FjBtX8WNxlNpJleV+6LfhOEsUspMbs
 I1rldJvlTGpuAyA1UWkyFPzteB7I/DetsZiS8qEcoq+adMuhAT/TnwDiza0V+RoDrM5B PA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3btffvhpe1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 05:48:30 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19K9jxv5033873;
        Wed, 20 Oct 2021 05:48:30 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3btffvhpdd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 05:48:30 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19K9lZE0032550;
        Wed, 20 Oct 2021 09:48:28 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3bqp0k32d5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 09:48:28 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19K9mPom54722882
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 09:48:25 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23E075204F;
        Wed, 20 Oct 2021 09:48:25 +0000 (GMT)
Received: from ant.fritz.box (unknown [9.145.151.144])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id D270652054;
        Wed, 20 Oct 2021 09:48:22 +0000 (GMT)
Subject: Re: [PATCH 3/3] KVM: s390: clear kicked_mask if not idle after set
To:     Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
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
From:   Michael Mueller <mimu@linux.ibm.com>
Message-ID: <8cb919e7-e7ab-5ec1-591e-43f95f140d7b@linux.ibm.com>
Date:   Wed, 20 Oct 2021 11:48:22 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211019175401.3757927-4-pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QEXXbydsESuWQoRbwAxad_Ts84B3Ius1
X-Proofpoint-ORIG-GUID: CiV25v5kfdpp4lbT7B80K1cSc4WqYwUv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-20_04,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015 spamscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110200054
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 19.10.21 19:54, Halil Pasic wrote:
> The idea behind kicked mask is that we should not re-kick a vcpu
> from __airqs_kick_single_vcpu() that is already in the middle of
> being kicked by the same function.
> 
> If however the vcpu that was idle before when the idle_mask was
> examined, is not idle any more after the kicked_mask is set, that
> means that we don't need to kick, and that we need to clear the
> bit we just set because we may be beyond the point where it would
> get cleared in the wake-up process. Since the time window is short,
> this is probably more a theoretical than a practical thing: the race
> window is small.
> 
> To get things harmonized let us also move the clear from vcpu_pre_run()
> to __unset_cpu_idle().
> 
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> Fixes: 9f30f6216378 ("KVM: s390: add gib_alert_irq_handler()")

Before releasing something like this, where none of us is sure if
it really saves cpu cost, I'd prefer to run some measurement with
the whole kicked_mask logic removed and to compare the number of
vcpu wake ups with the number of interrupts to be processed by
the gib alert mechanism in a slightly over committed host while
driving with Matthews test load.

A similar run can be done with this code.

> ---
>   arch/s390/kvm/interrupt.c | 7 ++++++-
>   arch/s390/kvm/kvm-s390.c  | 2 --
>   2 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 2245f4b8d362..3c80a2237ef5 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -426,6 +426,7 @@ static void __unset_cpu_idle(struct kvm_vcpu *vcpu)
>   {
>   	kvm_s390_clear_cpuflags(vcpu, CPUSTAT_WAIT);
>   	clear_bit(vcpu->vcpu_idx, vcpu->kvm->arch.idle_mask);
> +	clear_bit(vcpu->vcpu_idx, vcpu->kvm->arch.gisa_int.kicked_mask);
>   }
>   
>   static void __reset_intercept_indicators(struct kvm_vcpu *vcpu)
> @@ -3064,7 +3065,11 @@ static void __airqs_kick_single_vcpu(struct kvm *kvm, u8 deliverable_mask)
>   			/* lately kicked but not yet running */
>   			if (test_and_set_bit(vcpu_idx, gi->kicked_mask))
>   				return;
> -			kvm_s390_vcpu_wakeup(vcpu);
> +			/* if meanwhile not idle: clear  and don't kick */
> +			if (test_bit(vcpu_idx, kvm->arch.idle_mask))
> +				kvm_s390_vcpu_wakeup(vcpu);
> +			else
> +				clear_bit(vcpu_idx, gi->kicked_mask);
>   			return;
>   		}
>   	}
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 1c97493d21e1..6b779ef9f5fb 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4067,8 +4067,6 @@ static int vcpu_pre_run(struct kvm_vcpu *vcpu)
>   		kvm_s390_patch_guest_per_regs(vcpu);
>   	}
>   
> -	clear_bit(vcpu->vcpu_idx, vcpu->kvm->arch.gisa_int.kicked_mask);
> -
>   	vcpu->arch.sie_block->icptcode = 0;
>   	cpuflags = atomic_read(&vcpu->arch.sie_block->cpuflags);
>   	VCPU_EVENT(vcpu, 6, "entering sie flags %x", cpuflags);
> 
