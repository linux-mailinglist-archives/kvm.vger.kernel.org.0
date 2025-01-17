Return-Path: <kvm+bounces-35724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27487A148BA
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 05:12:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6DF1D3A98A7
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 04:11:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1D151F6673;
	Fri, 17 Jan 2025 04:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="j2d3vCfz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A5625765
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 04:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737087117; cv=none; b=a/rm9pw5Kb84C4SVXVog8HllC6lLgrDEbPaWynykWJQNzBHFpx8ka1XgMI7u/5EUWEo1kMg7pgDLvYOhV1Ic13jdX7oaeK2bEkzYeuZlqmcFo2f+DcYbnrY0T8htVPpvCV27mk+keY1Gog6g6SScXqLxN/8ZrXOI4GsR9tKoPTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737087117; c=relaxed/simple;
	bh=vqNV32umy43STBMmOAo8COODkI6bSRTE6nzZpKA3m8Y=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=rM/TP3+xMHHzxpyN26ClNfteX27fWkcb3GOveOjW24XeEALnnj050oi+u7pqwlmyF7oK98QusCmauILalUE9Vb6ekdK/d1Yc6z44t9qEhG0+x1W8uiBsNO5TB508O06ZKvopuCHBxWGv8VByRmLe8BnOJ3HCYY6FN3XzYtJ+lkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=j2d3vCfz; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50GNwF8P008981;
	Fri, 17 Jan 2025 04:11:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ar9Vgz
	6woiYDq7yaClNFIq5QaUmXn8hWum8FMgg5iIg=; b=j2d3vCfz0iTmfSuCVPZQRF
	3I1VwKVvhBg9s163QfKxoNHiO807xIb3MjL8M2YhzVNskVRfBw6t35ZWfAfiCX5+
	JUjHex4RXKONKfJE0/bnODStQ77xn5W+0JoIeQ8EEHkEuKIf/cfpj2yR9rn3n1um
	LGW5mq2cohxtmv/CXIIdEvErUEQBGtwpuv4Qce98pbcv0gen5TV8viVcLZhDgNAf
	Lh0T9Sqoc8COGMs0cC64kN0Se8hyGFeEZsDdFVg9qo1aPB4yNecdmjdQ4ofF1bnC
	uKCL09C4R8bwp/JS9Oj7rookXUKmRvoY6q2wn2J2lfLJAKf1nqCA9dNvlSGK+cjg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447c8j8tb9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 04:11:30 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50H48cEf000409;
	Fri, 17 Jan 2025 04:11:30 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447c8j8tb6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 04:11:30 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50H2xMWv000827;
	Fri, 17 Jan 2025 04:11:29 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44456k8x6t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 04:11:29 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50H4BRLk32834060
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jan 2025 04:11:27 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 678E320040;
	Fri, 17 Jan 2025 04:11:27 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B283320043;
	Fri, 17 Jan 2025 04:11:24 +0000 (GMT)
Received: from [9.39.26.84] (unknown [9.39.26.84])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Jan 2025 04:11:24 +0000 (GMT)
Message-ID: <bdb1a54c-712e-4cb6-98b0-42419d5a5ed4@linux.ibm.com>
Date: Fri, 17 Jan 2025 09:41:23 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Subject: Re: [PATCH v8 2/2] ppc: spapr: Enable 2nd DAWR on Power10 pSeries
 machine
To: David Gibson <david@gibson.dropbear.id.au>,
        Nicholas Piggin <npiggin@gmail.com>
Cc: danielhb413@gmail.com, qemu-ppc@nongnu.org, harshpb@linux.ibm.com,
        clg@kaod.org, groug@kaod.org, pbonzini@redhat.com, kvm@vger.kernel.org,
        qemu-devel@nongnu.org
References: <170679876639.188422.11634974895844092362.stgit@ltc-boston1.aus.stglabs.ibm.com>
 <170679878985.188422.6745903342602285494.stgit@ltc-boston1.aus.stglabs.ibm.com>
 <CZFUVDPGK7OU.1CBJ2TIMJ719P@wheely> <Zd5LpH-pPOT-MHiu@zatzit>
Content-Language: en-US
In-Reply-To: <Zd5LpH-pPOT-MHiu@zatzit>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IJpc4f7ABEFIhemKAC2MdakTJuQn9vrW
X-Proofpoint-ORIG-GUID: T4ydShuNrgAZ4IPrOF37poCC8YF2zR-k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-17_01,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 suspectscore=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 adultscore=0
 phishscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501170028

Hi David, Nick,

Sorry about not getting back on this for long!

On 2/28/24 2:22 AM, David Gibson wrote:
> On Tue, Feb 27, 2024 at 10:21:23PM +1000, Nicholas Piggin wrote:
>> On Fri Feb 2, 2024 at 12:46 AM AEST, Shivaprasad G Bhat wrote:
>>> As per the PAPR, bit 0 of byte 64 in pa-features property
>>> indicates availability of 2nd DAWR registers. i.e. If this bit is set, 2nd
>>> DAWR is present, otherwise not. Use KVM_CAP_PPC_DAWR1 capability to find
>>> whether kvm supports 2nd DAWR or not. If it's supported, allow user to set
>>> the pa-feature bit in guest DT using cap-dawr1 machine capability.
>>>
>>> Signed-off-by: Ravi Bangoria<ravi.bangoria@linux.ibm.com>
>>> Signed-off-by: Shivaprasad G Bhat<sbhat@linux.ibm.com>
>>> ---
>>>   hw/ppc/spapr.c         |    7 ++++++-
>>>   hw/ppc/spapr_caps.c    |   36 ++++++++++++++++++++++++++++++++++++
>>>   hw/ppc/spapr_hcall.c   |   25 ++++++++++++++++---------
>>>   include/hw/ppc/spapr.h |    6 +++++-
>>>   target/ppc/kvm.c       |   12 ++++++++++++
>>>   target/ppc/kvm_ppc.h   |   12 ++++++++++++
>>>   6 files changed, 87 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
>>> index e8dabc8614..91a97d72e7 100644
>>> --- a/hw/ppc/spapr.c
>>> +++ b/hw/ppc/spapr.c
>>> @@ -262,7 +262,7 @@ static void spapr_dt_pa_features(SpaprMachineState *spapr,
>>>           0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 48 - 53 */
>>>           /* 54: DecFP, 56: DecI, 58: SHA */
>>>           0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 54 - 59 */
>>> -        /* 60: NM atomic, 62: RNG */
>>> +        /* 60: NM atomic, 62: RNG, 64: DAWR1 (ISA 3.1) */
>>>           0x80, 0x00, 0x80, 0x00, 0x00, 0x00, /* 60 - 65 */
>>>       };
>>>       uint8_t *pa_features = NULL;
>>> @@ -303,6 +303,9 @@ static void spapr_dt_pa_features(SpaprMachineState *spapr,
>>>            * in pa-features. So hide it from them. */
>>>           pa_features[40 + 2] &= ~0x80; /* Radix MMU */
>>>       }
>>> +    if (spapr_get_cap(spapr, SPAPR_CAP_DAWR1)) {
>>> +        pa_features[66] |= 0x80;
>>> +    }
>>>   
>>>       _FDT((fdt_setprop(fdt, offset, "ibm,pa-features", pa_features, pa_size)));
>>>   }
>>> @@ -2138,6 +2141,7 @@ static const VMStateDescription vmstate_spapr = {
>>>           &vmstate_spapr_cap_fwnmi,
>>>           &vmstate_spapr_fwnmi,
>>>           &vmstate_spapr_cap_rpt_invalidate,
>>> +        &vmstate_spapr_cap_dawr1,
>>>           NULL
>>>       }
>>>   };
>>> @@ -4717,6 +4721,7 @@ static void spapr_machine_class_init(ObjectClass *oc, void *data)
>>>       smc->default_caps.caps[SPAPR_CAP_CCF_ASSIST] = SPAPR_CAP_ON;
>>>       smc->default_caps.caps[SPAPR_CAP_FWNMI] = SPAPR_CAP_ON;
>>>       smc->default_caps.caps[SPAPR_CAP_RPT_INVALIDATE] = SPAPR_CAP_OFF;
>>> +    smc->default_caps.caps[SPAPR_CAP_DAWR1] = SPAPR_CAP_OFF;
>>>   
>>>       /*
>>>        * This cap specifies whether the AIL 3 mode for
>>> diff --git a/hw/ppc/spapr_caps.c b/hw/ppc/spapr_caps.c
>>> index e889244e52..677f17cea6 100644
>>> --- a/hw/ppc/spapr_caps.c
>>> +++ b/hw/ppc/spapr_caps.c
>>> @@ -655,6 +655,32 @@ static void cap_ail_mode_3_apply(SpaprMachineState *spapr,
>>>       }
>>>   }
>>>   
>>> +static void cap_dawr1_apply(SpaprMachineState *spapr, uint8_t val,
>>> +                               Error **errp)
>>> +{
>>> +    ERRP_GUARD();
>>> +
>>> +    if (!val) {
>>> +        return; /* Disable by default */
>>> +    }
>>> +
>>> +    if (!ppc_type_check_compat(MACHINE(spapr)->cpu_type,
>>> +                               CPU_POWERPC_LOGICAL_3_10, 0,
>>> +                               spapr->max_compat_pvr)) {
>>> +        warn_report("DAWR1 supported only on POWER10 and later CPUs");
>>> +    }
>> Should this be an error?

Changing this to error_report().

> Yes, it should.  If you can't supply the cap requested, you *must*
> fail to start.  Near enough is not good enough when it comes to the
> guest visible properties of the virtual machine, or you'll end up with
> no end of migration headaches.
This was made to warn_report() as suggested[1] by Greg to avoid "make test"

failures once we enable dawr1 caps ON by default with POWER9 being the 
default

cpu then.


However, now that we have moved to P10 as the default CPU, I tested with 
default

ON on P10, and OFF otherwise, "make test" passes. The problem was only 
applicable

before as the default cpu was P9 back then.

>> Should the dawr1 cap be enabled by default for POWER10 machines?

Yes. Made it default enabled on Power10 cpu, and disable for Power9 and 
below.

>>> +
>>> +    if (kvm_enabled()) {
>>> +        if (!kvmppc_has_cap_dawr1()) {
>>> +            error_setg(errp, "DAWR1 not supported by KVM.");
>>> +            error_append_hint(errp, "Try appending -machine cap-dawr1=off");
>>> +        } else if (kvmppc_set_cap_dawr1(val) < 0) {
>>> +            error_setg(errp, "Error enabling cap-dawr1 with KVM.");
>>> +            error_append_hint(errp, "Try appending -machine cap-dawr1=off");
>>> +        }
>>> +    }
>>> +}
>>> +
<snip>
>>> diff --git a/hw/ppc/spapr_hcall.c b/hw/ppc/spapr_hcall.c
>>> index fcefd1d1c7..34c1c77c95 100644
>>> --- a/hw/ppc/spapr_hcall.c
>>> +++ b/hw/ppc/spapr_hcall.c
>>> @@ -814,11 +814,12 @@ static target_ulong h_set_mode_resource_set_ciabr(PowerPCCPU *cpu,
>>>       return H_SUCCESS;
>>>   }
>>>   
>>> -static target_ulong h_set_mode_resource_set_dawr0(PowerPCCPU *cpu,
>>> -                                                  SpaprMachineState *spapr,
>>> -                                                  target_ulong mflags,
>>> -                                                  target_ulong value1,
>>> -                                                  target_ulong value2)
>>> +static target_ulong h_set_mode_resource_set_dawr(PowerPCCPU *cpu,
>>> +                                                     SpaprMachineState *spapr,
>>> +                                                     target_ulong mflags,
>>> +                                                     target_ulong resource,
>>> +                                                     target_ulong value1,
>>> +                                                     target_ulong value2)
>> Did the text alignment go wrong here?
Yes. Fixed that.
>> Aside from those things,
>>
>> Reviewed-by: Nicholas Piggin<npiggin@gmail.com>

Since its been a while, I am not sure if the Reviewed-by is valid anymore.


I am keeping it anyway, please let me know if you have any further

comments in the v9 posted here [2]


I have addressed the comments from Harsh as well in the v9.


References:

[1] - https://lore.kernel.org/qemu-devel/20230708082536.73a2bfd8@bahia/

[2] - 
https://lore.kernel.org/all/173708679976.1678.10844458987521427074.stgit@linux.ibm.com/

Thanks,

Shiva


