Return-Path: <kvm+bounces-57323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C97FB533BA
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 15:29:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 11286B62593
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 13:26:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9988326D58;
	Thu, 11 Sep 2025 13:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iLobDg2q"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6741D26980B;
	Thu, 11 Sep 2025 13:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757597270; cv=none; b=Lm1zhDTYlb28IFSSx9LMEr2mttSqHTa/djVLDf90kSi1iIDIFUCdcI5XzeBt7AICYQv2j8Aeh4JKLHEaJpn0DZYqlYjhFKRX8jOtS6kXHg9Z+jfuWxNDzrjqktdhQTR+JoE5b9DFo57xNvKgv76+rS5hm3SAf3oPYmKRFV3pZoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757597270; c=relaxed/simple;
	bh=EwotIpVlC6ECNCMsILiND7Y3tKYNvU2/tWXxb5t5F1I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UJ3iT/kkcQrPsqA3oQpVSn3gOEmzRjvX929k93BArmYBMy4UDmXRfvQ/JBubPefyXW7SIIBbjw83PfKX7kSfzSMK8FQDgb7NpAXS4QhFPKTa5UYGITJP6ENeU1xTb4Ro3ognGm8xQ3+hhDgNHw04wkT+R78+58lF3wfUtaNV85g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iLobDg2q; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58B9RjAx012298;
	Thu, 11 Sep 2025 13:27:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Wr4Rnb
	GUAOhPILyqaxPg7Z7uQb12r6knbcI6UlutP8o=; b=iLobDg2qOMfBmwux1ultJk
	VMEmj5TrrJXIi9uznUj7L0dKneHggmts7MIDA/g+jilPURp1ZvwNK9cQ79LRkWTo
	zD3eM6ofB3tcw9AhS58+7DCbiLLrPRENYupIF6Xy9C4cNuptKe4hZ4eOeGw9RU8l
	elkTVyHt3cXXwugNnvOh1pTBKsd6LKJExgQZzz9IgIhi3i1dMsDx1H+jWJQkZDG/
	M9wyfxKdUN/v4uycoYnwlfPXSDWEZE5RDQVPDmjeCQs80eBmxoCR3JvcgMQ14lBD
	5g/swqppgCGajXYuZjUz8icBH5apPPvV04/yWWfj+cvhuAIgPbl9G2Vd5Abtd9IQ
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490cffmx09-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 13:27:44 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58BB6gXd001198;
	Thu, 11 Sep 2025 13:27:44 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 491203nqrq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 13:27:43 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58BDReH353215608
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 13:27:40 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1F66520043;
	Thu, 11 Sep 2025 13:27:40 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 94BF920040;
	Thu, 11 Sep 2025 13:27:39 +0000 (GMT)
Received: from [9.87.150.119] (unknown [9.87.150.119])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Sep 2025 13:27:39 +0000 (GMT)
Message-ID: <9bff1dd8-d8f9-426b-83c4-0ac2d0cbd4f2@linux.ibm.com>
Date: Thu, 11 Sep 2025 15:27:39 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/20] KVM: s390: KVM page table management functions:
 clear and replace
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
 <20250910180746.125776-10-imbrenda@linux.ibm.com>
 <91f044a5-803f-4672-960b-cd83f725af44@linux.ibm.com>
 <20250911151932.2bce5e01@p-imbrenda>
Content-Language: en-US
From: Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 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
In-Reply-To: <20250911151932.2bce5e01@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5HvRxwBLTSx-ulqh07p57xdYonvRX6qr
X-Proofpoint-GUID: 5HvRxwBLTSx-ulqh07p57xdYonvRX6qr
X-Authority-Analysis: v=2.4 cv=EYDIQOmC c=1 sm=1 tr=0 ts=68c2ce51 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=POEqfEI2BOpVBW3EC-8A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAyMCBTYWx0ZWRfX23XDbKN/8sT8
 50gUPLp6Yd6E7WUqwm1jVLrCtVLrHm7HbG15Iz6nMB5Pr98u3ThxlIBom4fkCgGJYI8qBIuF858
 BpB8IH2ljTurwH6vyYRHnH5zNC0yTxqUySeViqj4T3rWX/raUzsOHQV+dVvIc3i6g0pJmD5hDQ4
 tqg7NGGd9/c7PbyYsnk2kKwRTCvik9fRX1xTLPc3lRLvOK2TTTAn/cB6ID0aIdAjYm+NIs8pv9i
 nO2Yr2GXceUb21x2fSxkNk/vac2mLqLFZbcuqyFm+TLfCRrdBNhfyt/G4OytGDXJkkhH7ED2n3B
 UpxUW4FS9mdBA9OXVBgAzwTr/6ZaSbAyb73ZtAdfGuuQ4vVcbWHdvLctoUoE9tquk9+Lz4FV8g9
 OW3UPNHf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_04,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 suspectscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060020

On 9/11/25 3:19 PM, Claudio Imbrenda wrote:
> On Thu, 11 Sep 2025 14:57:40 +0200
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> On 9/10/25 8:07 PM, Claudio Imbrenda wrote:
>>> Add page table management functions to be used for KVM guest (gmap)
>>> page tables.
>>>
>>> This patch adds functions to clear, replace or exchange DAT table
>>> entries.
>>>
>>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>> ---
>>>    arch/s390/kvm/dat.c | 120 ++++++++++++++++++++++++++++++++++++++++++++
>>>    arch/s390/kvm/dat.h |  40 +++++++++++++++
>>>    2 files changed, 160 insertions(+)
>>>
>>> diff --git a/arch/s390/kvm/dat.c b/arch/s390/kvm/dat.c
>>> index 326be78adcda..f26e3579bd77 100644
>>> --- a/arch/s390/kvm/dat.c
>>> +++ b/arch/s390/kvm/dat.c
>>> @@ -89,3 +89,123 @@ void dat_free_level(struct crst_table *table, bool owns_ptes)
>>>    	}
>>>    	dat_free_crst(table);
>>>    }
>>> +
>>> +/**
>>> + * dat_crstep_xchg - exchange a guest CRST with another
>>> + * @crstep: pointer to the CRST entry
>>> + * @new: replacement entry
>>> + * @gfn: the affected guest address
>>> + * @asce: the ASCE of the address space
>>> + *
>>> + * This function is assumed to be called with the guest_table_lock
>>> + * held.
>>> + */
>>> +void dat_crstep_xchg(union crste *crstep, union crste new, gfn_t gfn, union asce asce)
>>> +{
>>> +	if (crstep->h.i) {
>>> +		WRITE_ONCE(*crstep, new);
>>> +		return;
>>> +	} else if (cpu_has_edat2()) {
>>> +		crdte_crste(crstep, *crstep, new, gfn, asce);
>>> +		return;
>>> +	}
>>> +
>>> +	if (machine_has_tlb_guest())
>>> +		idte_crste(crstep, gfn, IDTE_GUEST_ASCE, asce, IDTE_GLOBAL);
>>> +	else if (cpu_has_idte())
>>> +		idte_crste(crstep, gfn, 0, NULL_ASCE, IDTE_GLOBAL);
>>> +	else
>>> +		csp_invalidate_crste(crstep);
>>
>> I'm wondering if we can make stfle 3 (DTE) a requirement for KVM or
>> Linux as a whole since it was introduced with z990 AFAIK.
> 
> AFAIK we don't support machines older than z10 anyway
> 
> but in that case we can only get rid of csp_invalidate_crste(), which
> is not much.
> 
> I can remove it, if you really think it's ugly

That was more of a general question, I think we have more of those 
checks in non-kvm code. Your code is fine as is.

> 
>>
>>> +	WRITE_ONCE(*crstep, new);
>>> +}
>>> +
>>> +/**
>>> + * dat_crstep_xchg_atomic - exchange a gmap pmd with another
>>> + * @crstep: pointer to the crste entry
>>> + * @old: expected old value
>>> + * @new: replacement entry
>>> + * @gfn: the affected guest address
>>> + * @asce: the asce of the address space
>>> + *
>>> + * This function should only be called on invalid crstes, or on crstes with
>>> + * FC = 1, as that guarantees the presence of CSPG.
>>> + *
>>> + * Return: true if the exchange was successful.
>>> + */
>>> +bool dat_crstep_xchg_atomic(union crste *crstep, union crste old, union crste new, gfn_t gfn,
>>> +			    union asce asce)
>>> +{
>>> +	if (old.h.i)
>>> +		return arch_try_cmpxchg((long *)crstep, &old.val, new.val);
>>> +	if (cpu_has_edat2())
>>> +		return crdte_crste(crstep, old, new, gfn, asce);
>>> +	if (cpu_has_idte())
>>> +		return cspg_crste(crstep, old, new);
>>> +
>>> +	WARN_ONCE(1, "Machine does not have CSPG and DAT table was not invalid.");
>>> +	return false;
>>> +}
> 


