Return-Path: <kvm+bounces-20596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5865891A2FA
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 11:49:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0EA3C281C99
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 09:49:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D29E713AD3F;
	Thu, 27 Jun 2024 09:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AIJRj863"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83ED77A15B;
	Thu, 27 Jun 2024 09:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719481762; cv=none; b=o6ih6IgrRdpmRX04xXLJlVOQXzobxEUMA/fmLsEaaFuaN69L4DeHip1F+tpVH2/Yvn2JNrJzVeA62y4clVAYghls2lZz9qMim1YjCEKBdEDMyFu0GepUejmUZ/4upvXebl0jQ81dCJB8Vtr3UJuPp9Fl7Kp00t7ikdLqZ3iXUWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719481762; c=relaxed/simple;
	bh=aQtWfrtfGgmL5wJkGyCNAIw5WLS3WPoroF1CxF213d4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PrG1og461CqJtNEQ4wU0gmkT18Bais9lVYd1CUqx5R0WdLqeZAQKTBJAKabffdUiA9ivgPh+IgopOt7HKW+8NJwv19LM0n4FMi4Tkv+heS5fLEr9tCMX0xRTetWYqSqGB8HtrARrCoN/dZF9aD0JYErgG8ZqDkwS7o+1cBopJsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=AIJRj863; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45R6Qppl031214;
	Thu, 27 Jun 2024 09:49:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=pp1; bh=T
	JPjUncunkzAUrVSlwH3PO+R63uR8R5FoVLHo2Xn0+8=; b=AIJRj863r6CkOl83E
	Agw+lQXpNs5Dy5/rhiIjLklBXoH7awn4olSr5jdQxnFOtzdlTozZ6qGKoNz/cyx5
	yYBvwHQjn9U1IB33S9kkXtvbrhWdYEKpSBXmZ6tJPsvCg5D/RSRB3Xj5LEo+IB+w
	8xMjfVAd7BB11NKMcYktpzW/3/nylEMVgy/11bNiVTM6DUIK9l4lQkF4BxCAkHCb
	9qVaF7ZI938kqte+oZOmrcbTO3TqlOg9nTnlJQJvZz8m+KkhsuFkni5+1Wq1XOz+
	x0O/a7I+VntWObQm1iBmDpY3uRHLg4GtNB9kaCIZCh1ImT2vkGZm4wE5iZw/k2x3
	DtD8A==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4010n2gu3q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 09:49:18 +0000 (GMT)
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45R9nHoD025025;
	Thu, 27 Jun 2024 09:49:17 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4010n2gu3n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 09:49:17 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45R8PxTS000616;
	Thu, 27 Jun 2024 09:49:17 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yxaen9xpv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 09:49:16 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45R9nBev33096250
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Jun 2024 09:49:13 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2BC0520043;
	Thu, 27 Jun 2024 09:49:11 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9975120040;
	Thu, 27 Jun 2024 09:49:10 +0000 (GMT)
Received: from [9.179.9.187] (unknown [9.179.9.187])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 27 Jun 2024 09:49:10 +0000 (GMT)
Message-ID: <7fe74791-757b-49d0-bbae-1e8e721ca040@linux.ibm.com>
Date: Thu, 27 Jun 2024 11:49:10 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] KVM: s390: fix LPSWEY handling
To: Thomas Huth <thuth@redhat.com>, KVM <kvm@vger.kernel.org>
Cc: Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390
 <linux-s390@vger.kernel.org>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
References: <20240627090520.4667-1-borntraeger@linux.ibm.com>
 <121e78f1-ca4f-46a1-a5ac-26d1928a5921@redhat.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <121e78f1-ca4f-46a1-a5ac-26d1928a5921@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yQcr7sSFezbTYMvdhnTuJhOaWWP_mR1Q
X-Proofpoint-GUID: 1Kn7BzaK494PAqgxvF6BRetJuecBzwjH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-27_05,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 mlxscore=0
 priorityscore=1501 suspectscore=0 mlxlogscore=999 malwarescore=0
 spamscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2406140001 definitions=main-2406270070

Am 27.06.24 um 11:44 schrieb Thomas Huth:
> On 27/06/2024 11.05, Christian Borntraeger wrote:
>> in rare cases, e.g. for injecting a machine check we do intercept all
>> load PSW instructions via ICTL_LPSW. With facility 193 a new variant
>> LPSWEY was added. KVM needs to handle that as well.
>>
>> Fixes: a3efa8429266 ("KVM: s390: gen_facilities: allow facilities 165, 193, 194 and 196")
>> Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>> Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/kvm_host.h |  1 +
>>   arch/s390/kvm/kvm-s390.c         |  1 +
>>   arch/s390/kvm/kvm-s390.h         | 16 ++++++++++++++++
>>   arch/s390/kvm/priv.c             | 32 ++++++++++++++++++++++++++++++++
>>   4 files changed, 50 insertions(+)
>>
>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
>> index 95990461888f..9281063636a7 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -427,6 +427,7 @@ struct kvm_vcpu_stat {
>>       u64 instruction_io_other;
>>       u64 instruction_lpsw;
>>       u64 instruction_lpswe;
>> +    u64 instruction_lpswey;
>>       u64 instruction_pfmf;
>>       u64 instruction_ptff;
>>       u64 instruction_sck;
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 50b77b759042..8e04c7f0c90c 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -132,6 +132,7 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>>       STATS_DESC_COUNTER(VCPU, instruction_io_other),
>>       STATS_DESC_COUNTER(VCPU, instruction_lpsw),
>>       STATS_DESC_COUNTER(VCPU, instruction_lpswe),
>> +    STATS_DESC_COUNTER(VCPU, instruction_lpswey),
>>       STATS_DESC_COUNTER(VCPU, instruction_pfmf),
>>       STATS_DESC_COUNTER(VCPU, instruction_ptff),
>>       STATS_DESC_COUNTER(VCPU, instruction_sck),
>> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
>> index 111eb5c74784..c61966cae121 100644
>> --- a/arch/s390/kvm/kvm-s390.h
>> +++ b/arch/s390/kvm/kvm-s390.h
>> @@ -138,6 +138,22 @@ static inline u64 kvm_s390_get_base_disp_s(struct kvm_vcpu *vcpu, u8 *ar)
>>       return (base2 ? vcpu->run->s.regs.gprs[base2] : 0) + disp2;
>>   }
>> +static inline u64 kvm_s390_get_base_disp_siy(struct kvm_vcpu *vcpu, u8 *ar)
>> +{
>> +    u32 base1 = vcpu->arch.sie_block->ipb >> 28;
>> +    u32 disp1 = ((vcpu->arch.sie_block->ipb & 0x0fff0000) >> 16) +
>> +            ((vcpu->arch.sie_block->ipb & 0xff00) << 4);
>> +
>> +    /* The displacement is a 20bit _SIGNED_ value */
>> +    if (disp1 & 0x80000)
>> +        disp1+=0xfff00000;
>> +
>> +    if (ar)
>> +        *ar = base1;
>> +
>> +    return (base1 ? vcpu->run->s.regs.gprs[base1] : 0) + (long)(int)disp1;
>> +}
>> +
>>   static inline void kvm_s390_get_base_disp_sse(struct kvm_vcpu *vcpu,
>>                             u64 *address1, u64 *address2,
>>                             u8 *ar_b1, u8 *ar_b2)
>> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
>> index 1be19cc9d73c..1a49b89706f8 100644
>> --- a/arch/s390/kvm/priv.c
>> +++ b/arch/s390/kvm/priv.c
>> @@ -797,6 +797,36 @@ static int handle_lpswe(struct kvm_vcpu *vcpu)
>>       return 0;
>>   }
>> +static int handle_lpswey(struct kvm_vcpu *vcpu)
>> +{
>> +    psw_t new_psw;
>> +    u64 addr;
>> +    int rc;
>> +    u8 ar;
>> +
>> +    vcpu->stat.instruction_lpswey++;
>> +
>> +    if (!test_kvm_facility(vcpu->kvm, 193))
>> +        return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);
>> +
>> +    if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
>> +        return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
>> +
>> +    addr = kvm_s390_get_base_disp_siy(vcpu, &ar);
>> +    if (addr & 7)
>> +        return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
>> +
>> +    rc = read_guest(vcpu, addr, ar, &new_psw, sizeof(new_psw));
>> +    if (rc)
>> +        return kvm_s390_inject_prog_cond(vcpu, rc);
> 
> Quoting the Principles of Operations:
> 
> "If the storage-key-removal facility is installed, a spe-
> cial-operation exception is recognized if the key value
> in bits 8-11 of the storage operand is nonzero."
> 
> Do we need to have such a check here, too?

We do not yet implement the storage key removal facility in KVM as far as
I can see. Only secure execution does that but there we do not have lpswe
intercepts. But yes, if we are going to implement this for normal guests
we need to have a look, also for LPSW(E)

