Return-Path: <kvm+bounces-34213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DEE59F8FE3
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 11:10:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5946816EECB
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 10:09:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD7641BDAB9;
	Fri, 20 Dec 2024 10:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ibYXOT9/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC111A4E98
	for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 10:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734689355; cv=none; b=o9w3emnc1nfSTLgEDrHCYdFoN/Fcy5HAloBT7B9m+6MzbhSv3o4BVGrN6FjetfnqgBlRw1RGr+dbXbqfa+uOCkwthYx53fxFomQSPOXw/QTG1Cfz5fzg8ATriCPuCcSlRlZ2iFKRziLzODr5na3HaMtKWKqSCu6uwGzzCqu5Tb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734689355; c=relaxed/simple;
	bh=IB6FHsk3Xm+GeSuW+0WXa2lkacYErwdfZjrWm4ZV8u4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=RpoaH2ERPGTMF+cF1u0vA78p0mQpLaLSgNKA+zhGJvS4U1/EtSQHFEnzEWUrByp2ZgIjf0KW5RR4uI79ehIiHnT20iouNWgWjtlO2kxzvsra6cTuPasumEZdljUYe9kdh1LLokn0N82otIweXqMyU79EjCqUksbVON1JmyJ6Kxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ibYXOT9/; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BK86K9p015003;
	Fri, 20 Dec 2024 10:09:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=nMdyxI
	EkJNSMVafNUrLqG/+Yar2sykICvboSXIyw+JE=; b=ibYXOT9/t1MpmPZfRPTTmQ
	QoD5NtCsnUepgmu7doU1EX5Ur5oprD+n7xyon+5KaprDhH4zi5Q+jDYlAVEyugL2
	EK0fDB1mAlCyUykC6h+HFV/9s6p23qpWlHbQhvy2Kha235oMn1pN4305MFxTSCEX
	DjepJc0Hu7HyALhgjLk4NVeuoF1V4qgx4NpPw4L/ynMjABpmeTIWnWy23Gh8SeZs
	yljo+7MDcGg84dKsAUapbIZU2U4JcxJLcBqBH7jWCoP28fJ87ebFlYeJaqqJ6r2I
	LDVA58EhUPkTVqdAZvAVQ2rlE+tl1LTRR0ka3QWddP3v3MvA253niMfZnEoUpnyg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43n4s2rgxs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Dec 2024 10:09:00 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4BKA7ET3019850;
	Fri, 20 Dec 2024 10:09:00 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43n4s2rgxp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Dec 2024 10:08:59 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4BK6NAeo011256;
	Fri, 20 Dec 2024 10:08:59 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 43hpjkhcph-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Dec 2024 10:08:59 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4BKA8wb864487868
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Dec 2024 10:08:59 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CECE158055;
	Fri, 20 Dec 2024 10:08:58 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B973D58043;
	Fri, 20 Dec 2024 10:08:54 +0000 (GMT)
Received: from [9.124.215.200] (unknown [9.124.215.200])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 20 Dec 2024 10:08:54 +0000 (GMT)
Message-ID: <792752e6-9f56-4230-a637-58f38724f07f@linux.ibm.com>
Date: Fri, 20 Dec 2024 15:38:52 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/2] ppc: spapr: Enable 2nd DAWR on Power10 pSeries
 machine
From: Harsh Prateek Bora <harshpb@linux.ibm.com>
To: Shivaprasad G Bhat <sbhat@linux.ibm.com>, danielhb413@gmail.com,
        qemu-ppc@nongnu.org, david@gibson.dropbear.id.au, clg@kaod.org,
        npiggin@gmail.com, groug@kaod.org
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <170679876639.188422.11634974895844092362.stgit@ltc-boston1.aus.stglabs.ibm.com>
 <170679878985.188422.6745903342602285494.stgit@ltc-boston1.aus.stglabs.ibm.com>
 <5c0bf4e1-ada7-4f81-9ac4-57b997324659@linux.ibm.com>
Content-Language: en-US
In-Reply-To: <5c0bf4e1-ada7-4f81-9ac4-57b997324659@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NJ0JZPzChdDorYJWcX9808hWX9gNoDh9
X-Proofpoint-GUID: v5-TzkRePaPN6hiQ1ckTmoHSC2MWwgRk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxlogscore=936 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412200082

Typo corrected below.

On 12/20/24 15:27, Harsh Prateek Bora wrote:
> Hi Shiva,
> 
> On 2/1/24 20:16, Shivaprasad G Bhat wrote:
>> As per the PAPR, bit 0 of byte 64 in pa-features property
>> indicates availability of 2nd DAWR registers. i.e. If this bit is set, 
>> 2nd
>> DAWR is present, otherwise not. Use KVM_CAP_PPC_DAWR1 capability to find
>> whether kvm supports 2nd DAWR or not. If it's supported, allow user to 
>> set
>> the pa-feature bit in guest DT using cap-dawr1 machine capability.
>>
>> Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
>> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
>> ---
>>   hw/ppc/spapr.c         |    7 ++++++-
>>   hw/ppc/spapr_caps.c    |   36 ++++++++++++++++++++++++++++++++++++
>>   hw/ppc/spapr_hcall.c   |   25 ++++++++++++++++---------
>>   include/hw/ppc/spapr.h |    6 +++++-
>>   target/ppc/kvm.c       |   12 ++++++++++++
>>   target/ppc/kvm_ppc.h   |   12 ++++++++++++
>>   6 files changed, 87 insertions(+), 11 deletions(-)
>>
> 
> <snipped>
> 
>> diff --git a/hw/ppc/spapr_hcall.c b/hw/ppc/spapr_hcall.c
>> index fcefd1d1c7..34c1c77c95 100644
>> --- a/hw/ppc/spapr_hcall.c
>> +++ b/hw/ppc/spapr_hcall.c
>> @@ -814,11 +814,12 @@ static target_ulong 
>> h_set_mode_resource_set_ciabr(PowerPCCPU *cpu,
>>       return H_SUCCESS;
>>   }
>> -static target_ulong h_set_mode_resource_set_dawr0(PowerPCCPU *cpu,
>> -                                                  SpaprMachineState 
>> *spapr,
>> -                                                  target_ulong mflags,
>> -                                                  target_ulong value1,
>> -                                                  target_ulong value2)
>> +static target_ulong h_set_mode_resource_set_dawr(PowerPCCPU *cpu,
>> +                                                     
>> SpaprMachineState *spapr,
>> +                                                     target_ulong 
>> mflags,
>> +                                                     target_ulong 
>> resource,
>> +                                                     target_ulong 
>> value1,
>> +                                                     target_ulong 
>> value2)
>>   {
>>       CPUPPCState *env = &cpu->env;
>> @@ -831,8 +832,13 @@ static target_ulong 
>> h_set_mode_resource_set_dawr0(PowerPCCPU *cpu,
>>           return H_P4;
>>       }
>> -    ppc_store_dawr0(env, value1);
>> -    ppc_store_dawrx0(env, value2);
>> +    if (resource == H_SET_MODE_RESOURCE_SET_DAWR0) {
>> +        ppc_store_dawr0(env, value1);
>> +        ppc_store_dawrx0(env, value2);
>> +    } else {
> 
> Should we explicitly check here for resource == 
> H_SET_MODE_RESOURCE_SET_DAWR1 ? 

Copy paste error corrected. Was referring to _DAWR1 here.

> 
>> +        ppc_store_dawr1(env, value1);
>> +        ppc_store_dawrx1(env, value2);
> 
> and then do an else g_assert_not_reached() ?
> 
> With suggested changes after addressing other review comments from 
> Nick/David:
> 
> Reviewed-by: Harsh Prateek Bora <harshpb@linux.ibm.com>
> 
>> +    }
>>       return H_SUCCESS;
>>   }
>> @@ -911,8 +917,9 @@ static target_ulong h_set_mode(PowerPCCPU *cpu, 
>> SpaprMachineState *spapr,
>>                                               args[3]);
>>           break;
>>       case H_SET_MODE_RESOURCE_SET_DAWR0:
>> -        ret = h_set_mode_resource_set_dawr0(cpu, spapr, args[0], 
>> args[2],
>> -                                            args[3]);
>> +    case H_SET_MODE_RESOURCE_SET_DAWR1:
>> +        ret = h_set_mode_resource_set_dawr(cpu, spapr, args[0], args[1],
>> +                                           args[2], args[3]);
>>           break;
>>       case H_SET_MODE_RESOURCE_LE:
>>           ret = h_set_mode_resource_le(cpu, spapr, args[0], args[2], 
>> args[3]);
>> diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
>> index e91791a1a9..2b13c9a00e 100644
>> --- a/include/hw/ppc/spapr.h
>> +++ b/include/hw/ppc/spapr.h
>> @@ -80,8 +80,10 @@ typedef enum {
>>   #define SPAPR_CAP_RPT_INVALIDATE        0x0B
>>   /* Support for AIL modes */
>>   #define SPAPR_CAP_AIL_MODE_3            0x0C
>> +/* DAWR1 */
>> +#define SPAPR_CAP_DAWR1                 0x0D
>>   /* Num Caps */
>> -#define SPAPR_CAP_NUM                   (SPAPR_CAP_AIL_MODE_3 + 1)
>> +#define SPAPR_CAP_NUM                   (SPAPR_CAP_DAWR1 + 1)
>>   /*
>>    * Capability Values
>> @@ -403,6 +405,7 @@ struct SpaprMachineState {
>>   #define H_SET_MODE_RESOURCE_SET_DAWR0           2
>>   #define H_SET_MODE_RESOURCE_ADDR_TRANS_MODE     3
>>   #define H_SET_MODE_RESOURCE_LE                  4
>> +#define H_SET_MODE_RESOURCE_SET_DAWR1           5
>>   /* Flags for H_SET_MODE_RESOURCE_LE */
>>   #define H_SET_MODE_ENDIAN_BIG    0
>> @@ -986,6 +989,7 @@ extern const VMStateDescription 
>> vmstate_spapr_cap_ccf_assist;
>>   extern const VMStateDescription vmstate_spapr_cap_fwnmi;
>>   extern const VMStateDescription vmstate_spapr_cap_rpt_invalidate;
>>   extern const VMStateDescription vmstate_spapr_wdt;
>> +extern const VMStateDescription vmstate_spapr_cap_dawr1;
>>   static inline uint8_t spapr_get_cap(SpaprMachineState *spapr, int cap)
>>   {
>> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
>> index 26fa9d0575..3d8a8f35b6 100644
>> --- a/target/ppc/kvm.c
>> +++ b/target/ppc/kvm.c
>> @@ -89,6 +89,7 @@ static int cap_large_decr;
>>   static int cap_fwnmi;
>>   static int cap_rpt_invalidate;
>>   static int cap_ail_mode_3;
>> +static int cap_dawr1;
>>   static uint32_t debug_inst_opcode;
>> @@ -143,6 +144,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>>       cap_ppc_nested_kvm_hv = kvm_vm_check_extension(s, 
>> KVM_CAP_PPC_NESTED_HV);
>>       cap_large_decr = kvmppc_get_dec_bits();
>>       cap_fwnmi = kvm_vm_check_extension(s, KVM_CAP_PPC_FWNMI);
>> +    cap_dawr1 = kvm_vm_check_extension(s, KVM_CAP_PPC_DAWR1);
>>       /*
>>        * Note: setting it to false because there is not such capability
>>        * in KVM at this moment.
>> @@ -2109,6 +2111,16 @@ int kvmppc_set_fwnmi(PowerPCCPU *cpu)
>>       return kvm_vcpu_enable_cap(cs, KVM_CAP_PPC_FWNMI, 0);
>>   }
>> +bool kvmppc_has_cap_dawr1(void)
>> +{
>> +    return !!cap_dawr1;
>> +}
>> +
>> +int kvmppc_set_cap_dawr1(int enable)
>> +{
>> +    return kvm_vm_enable_cap(kvm_state, KVM_CAP_PPC_DAWR1, 0, enable);
>> +}
>> +
>>   int kvmppc_smt_threads(void)
>>   {
>>       return cap_ppc_smt ? cap_ppc_smt : 1;
>> diff --git a/target/ppc/kvm_ppc.h b/target/ppc/kvm_ppc.h
>> index 1975fb5ee6..493d6bb477 100644
>> --- a/target/ppc/kvm_ppc.h
>> +++ b/target/ppc/kvm_ppc.h
>> @@ -68,6 +68,8 @@ bool kvmppc_has_cap_htm(void);
>>   bool kvmppc_has_cap_mmu_radix(void);
>>   bool kvmppc_has_cap_mmu_hash_v3(void);
>>   bool kvmppc_has_cap_xive(void);
>> +bool kvmppc_has_cap_dawr1(void);
>> +int kvmppc_set_cap_dawr1(int enable);
>>   int kvmppc_get_cap_safe_cache(void);
>>   int kvmppc_get_cap_safe_bounds_check(void);
>>   int kvmppc_get_cap_safe_indirect_branch(void);
>> @@ -377,6 +379,16 @@ static inline bool kvmppc_has_cap_xive(void)
>>       return false;
>>   }
>> +static inline bool kvmppc_has_cap_dawr1(void)
>> +{
>> +    return false;
>> +}
>> +
>> +static inline int kvmppc_set_cap_dawr1(int enable)
>> +{
>> +    abort();
>> +}
>> +
>>   static inline int kvmppc_get_cap_safe_cache(void)
>>   {
>>       return 0;
>>
>>
>>
> 

