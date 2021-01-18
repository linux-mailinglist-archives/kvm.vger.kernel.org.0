Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958CA2FA25D
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 15:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404877AbhARN57 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 08:57:59 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12868 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392535AbhARN5w (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 08:57:52 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10IDVuGN154794;
        Mon, 18 Jan 2021 08:57:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=xUzBdR8bLGutaF8FkGM/57AcgwS9Ensyi1qUyqLcYmQ=;
 b=TA8xPBDrY2arHkVo+yPhExTgWU6S6nNCew7gA1tgSetUDZ4n4sxsl/We8WlyU7gWAxRu
 sy6HRtWDagYsmOkumswSI9uqNOunEGxa7Kg51c565LzIEwYapCH8e4asMY5UAcC5ubKg
 Sl8eMWZoDwRm0Bjq/OBJet1rFNt5DDCZhZL3kSG/NYUmtTExDsSzOTjRpdRAF4W0JN+L
 +8pbVeycGxMfUqcCTvpYZaJ+NP/5QWpwEyuh4dwd/n4Z9eKur9S//chknl3/z0u9udCj
 qOCRitI17BdodK1wEpI/MwXOIDAO8xZ9vcn6uOotEeUklOEqUIW/4FcEwraBrTCNLnQZ KQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 365abqac3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jan 2021 08:57:10 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10IDW9G6155981;
        Mon, 18 Jan 2021 08:57:10 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 365abqac30-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jan 2021 08:57:10 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10IDlDM4007303;
        Mon, 18 Jan 2021 13:57:08 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 363qdh93dq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jan 2021 13:57:08 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10IDuxkZ31261126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Jan 2021 13:56:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52E614C04A;
        Mon, 18 Jan 2021 13:57:05 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9847E4C040;
        Mon, 18 Jan 2021 13:57:04 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.2.167])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 18 Jan 2021 13:57:04 +0000 (GMT)
Subject: Re: [PATCH 1/1] KVM: s390: diag9c forwarding
To:     Janosch Frank <frankja@linux.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
References: <20210118131739.7272-1-borntraeger@de.ibm.com>
 <20210118131739.7272-2-borntraeger@de.ibm.com>
 <db1d2a6e-1947-321b-bdc2-019eee5780f4@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <5c0ca08a-d284-dc7b-3d32-c8fbc86a361f@de.ibm.com>
Date:   Mon, 18 Jan 2021 14:57:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <db1d2a6e-1947-321b-bdc2-019eee5780f4@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-18_11:2021-01-18,2021-01-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 clxscore=1015 impostorscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101180077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 18.01.21 14:45, Janosch Frank wrote:
> On 1/18/21 2:17 PM, Christian Borntraeger wrote:
>> From: Pierre Morel <pmorel@linux.ibm.com>
>>
>> When we receive intercept a DIAG_9C from the guest we verify
>> that the target real CPU associated with the virtual CPU
>> designated by the guest is running and if not we forward the
>> DIAG_9C to the target real CPU.
>>
>> To avoid a diag9c storm we allow a maximal rate of diag9c forwarding.
>>
>> The rate is calculated as a count per second defined as a
>> new parameter of the s390 kvm module: diag9c_forwarding_hz .
>>
>> The default value is to not forward diag9c.
> 
> Before Conny starts yelling I'll do it myself:
> Documentation
> 
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> ---
>>  arch/s390/include/asm/kvm_host.h |  1 +
>>  arch/s390/include/asm/smp.h      |  1 +
>>  arch/s390/kernel/smp.c           |  1 +
>>  arch/s390/kvm/diag.c             | 31 ++++++++++++++++++++++++++++---
>>  arch/s390/kvm/kvm-s390.c         |  6 ++++++
>>  arch/s390/kvm/kvm-s390.h         |  8 ++++++++
>>  6 files changed, 45 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
>> index 74f9a036bab2..98ae55f79620 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -455,6 +455,7 @@ struct kvm_vcpu_stat {
>>  	u64 diagnose_44;
>>  	u64 diagnose_9c;
>>  	u64 diagnose_9c_ignored;
>> +	u64 diagnose_9c_forward;
>>  	u64 diagnose_258;
>>  	u64 diagnose_308;
>>  	u64 diagnose_500;
>> diff --git a/arch/s390/include/asm/smp.h b/arch/s390/include/asm/smp.h
>> index 01e360004481..e317fd4866c1 100644
>> --- a/arch/s390/include/asm/smp.h
>> +++ b/arch/s390/include/asm/smp.h
>> @@ -63,5 +63,6 @@ extern void __noreturn cpu_die(void);
>>  extern void __cpu_die(unsigned int cpu);
>>  extern int __cpu_disable(void);
>>  extern void schedule_mcck_handler(void);
>> +void notrace smp_yield_cpu(int cpu);
>>  
>>  #endif /* __ASM_SMP_H */
>> diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
>> index c5abbb94ac6e..32622e9c15f0 100644
>> --- a/arch/s390/kernel/smp.c
>> +++ b/arch/s390/kernel/smp.c
>> @@ -422,6 +422,7 @@ void notrace smp_yield_cpu(int cpu)
>>  	asm volatile("diag %0,0,0x9c"
>>  		     : : "d" (pcpu_devices[cpu].address));
>>  }
>> +EXPORT_SYMBOL(smp_yield_cpu);
>>  
>>  /*
>>   * Send cpus emergency shutdown signal. This gives the cpus the
>> diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
>> index 5b8ec1c447e1..fc1ec4aa81ed 100644
>> --- a/arch/s390/kvm/diag.c
>> +++ b/arch/s390/kvm/diag.c
>> @@ -150,6 +150,19 @@ static int __diag_time_slice_end(struct kvm_vcpu *vcpu)
>>  	return 0;
>>  }
>>  
>> +static unsigned int forward_cnt;
> 
> This is not per CPU, so we could have one CPU making forwards impossible
> for all others, right? Would this be a possible improvement or doesn't
> that happen in real world workloads?
> 
> The code looks ok to me but smp is absolutely not my field of expertise.
> 
>> +static unsigned long cur_slice;
>> +
>> +static int diag9c_forwarding_overrun(void)
>> +{
>> +	/* Reset the count on a new slice */
>> +	if (time_after(jiffies, cur_slice)) {
>> +		cur_slice = jiffies;
>> +		forward_cnt = diag9c_forwarding_hz / HZ;
>> +	}
>> +	return forward_cnt-- ? 1 : 0;
>> +}
>> +
>>  static int __diag_time_slice_end_directed(struct kvm_vcpu *vcpu)
>>  {
>>  	struct kvm_vcpu *tcpu;
>> @@ -167,9 +180,21 @@ static int __diag_time_slice_end_directed(struct kvm_vcpu *vcpu)
>>  	if (!tcpu)
>>  		goto no_yield;
>>  
>> -	/* target already running */
>> -	if (READ_ONCE(tcpu->cpu) >= 0)
>> -		goto no_yield;
>> +	/* target VCPU already running */
>> +	if (READ_ONCE(tcpu->cpu) >= 0) {
>> +		if (!diag9c_forwarding_hz || diag9c_forwarding_overrun())
>> +			goto no_yield;
>> +
>> +		/* target CPU already running */
>> +		if (!vcpu_is_preempted(tcpu->cpu))
>> +			goto no_yield;
>> +		smp_yield_cpu(tcpu->cpu);
> 
> This is a pure cpu yield while before we yielded to the process of the
> vcpu. Do we also want to prod the task of the VCPU we want to yield to

No we did not yielded to the process. This case is for vcpu already
running according to the host scheduler (which would result in an no-op).
See the "before hunk". it contains goto no_yield.

Instead we now check if our host CPU was potentially scheduled by the upper
layer hypervisor (e.g. LPAR) and then we ask that to also yield.

> before waking up the host cpu? Or do we expect the VCPU task to be the
> first thing that's picked up by the host cpu?

