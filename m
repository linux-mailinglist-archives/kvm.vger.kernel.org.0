Return-Path: <kvm+bounces-8223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 11F6384CCCD
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 15:33:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C7481F227BC
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 14:33:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D19B7A73C;
	Wed,  7 Feb 2024 14:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LJjpIB4o"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0538433B4;
	Wed,  7 Feb 2024 14:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707316381; cv=none; b=Qm/9hUZC2z+Skz231SKIL5UOVA6toPNrBz/gZwEMORY27oQBTsyAQC4/VG6NVK/dtC5e36AJQ4l0Iuhbgx7RfMRe6NwBCgkhvk+cp1UZ98eQ2zweDCYLJL158r5tvjuEK8hgGpGEkFjeTOk9MfzE7WHz6Y551jWryjNAi0hC1c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707316381; c=relaxed/simple;
	bh=UCge+c0TFrDoK5AJ0mcaIV6lh+tUbjQqw7blgbGviIU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZlmcrfoPOuyGP0BCZtEa7VoURN7hwIWw/C4pn4OuY1jJF9XQY5CDz1d+6xH5FNO6RmH5vZWs42/itmmHpSstkFjsgsnm4HgOJ8sY9slfG8rcHMfyGUoQ9WiZDZE1QFeH0FUZfxYjjzeWVBbv3mqJvZ1b2ZY+oVIvxagH1cH0YZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LJjpIB4o; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 417EWWiM002283;
	Wed, 7 Feb 2024 14:32:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=LyhAL8tiD1gnqOsSceh0fq2xd5s9zZ4/vt2raEcM+YY=;
 b=LJjpIB4oGfLDucQecs9Ghw8DvY7xeM7OQqa1G7Tqdy/Gr38auDKY+Lgch18PAfHbwoSH
 pavC0TCLQKEPvOQpDnvfQv5FVgSWrVB5nVIwp2f1jge1enNxgD0+ZBY0VN+7ugY9bCzd
 5+mnurMn+NZK0IuZWzUOfSVGGY2IUUtUz2g7w4FaJhuwnd59OZFA/Xk31Vjm99+hakfG
 EZ50Bk9gpCYdVSLu9Vo1BLGp8b3pOE0bgETokGN5of2cWrXinkj11eXPOII6RMmmMx0c
 nTTrPAl8mKMTWb4oORWZ4IMXk8Xiz2axeGl7udGFOba33i2bvmoqeFzOSGyfknfJ+hc0 pg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w4ahr2bkt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Feb 2024 14:32:57 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 417EEcKh010473;
	Wed, 7 Feb 2024 14:32:37 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w4ahr2a09-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Feb 2024 14:32:36 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 417DsGNR008971;
	Wed, 7 Feb 2024 14:30:40 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3w206ypbn9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Feb 2024 14:30:40 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 417EUc4b53019214
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 7 Feb 2024 14:30:39 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ABBF758052;
	Wed,  7 Feb 2024 14:30:38 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9450658050;
	Wed,  7 Feb 2024 14:30:37 +0000 (GMT)
Received: from [9.61.84.204] (unknown [9.61.84.204])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  7 Feb 2024 14:30:37 +0000 (GMT)
Message-ID: <76616f7c-30fa-41d2-b7b3-a87cb2e7f9f1@linux.ibm.com>
Date: Wed, 7 Feb 2024 09:30:37 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v4 1/7] lib: s390x: Add ap library
Content-Language: en-US
To: freude@linux.ibm.com
Cc: Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        jjherne@linux.ibm.com
References: <20240202145913.34831-1-frankja@linux.ibm.com>
 <20240202145913.34831-2-frankja@linux.ibm.com>
 <b1bb6df4-dea3-414d-9f53-dfd76571fbb7@linux.ibm.com>
 <a289a445-7665-4013-adfe-dd95ac3558c0@linux.ibm.com>
 <e7a10411-ce12-4e44-8320-50ecea342059@linux.ibm.com>
 <f340dad2cca9fe47737a8742ecd7554e@linux.ibm.com>
From: Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <f340dad2cca9fe47737a8742ecd7554e@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qTcLVek8Iqox5fe_8TKfTOt6DBi0cQ6e
X-Proofpoint-ORIG-GUID: gbsaujuA-PEayRAD-HodXVZVK1C1-cm0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-07_05,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 mlxscore=0 spamscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402070108


On 2/7/24 3:06 AM, Harald Freudenberger wrote:
> On 2024-02-06 16:55, Anthony Krowiak wrote:
>> On 2/6/24 8:42 AM, Janosch Frank wrote:
>>> On 2/5/24 19:15, Anthony Krowiak wrote:
>>>> I made a few comments and suggestions. I am not very well-versed in 
>>>> the
>>>> inline assembly code, so I'll leave that up to someone who is more
>>>> knowledgeable. I copied @Harald since I believe it was him who 
>>>> wrote it.
>>>>
>>>> On 2/2/24 9:59 AM, Janosch Frank wrote:
>>>>> Add functions and definitions needed to test the Adjunct
>>>>> Processor (AP) crypto interface.
>>>>>
>>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>
>>> [...]
>>>
>>>>> +/* Will later be extended to a proper setup function */
>>>>> +bool ap_setup(void)
>>>>> +{
>>>>> +    /*
>>>>> +     * Base AP support has no STFLE or SCLP feature bit but the
>>>>> +     * PQAP QCI support is indicated via stfle bit 12. As this
>>>>> +     * library relies on QCI we bail out if it's not available.
>>>>> +     */
>>>>> +    if (!test_facility(12))
>>>>> +        return false;
>>>>
>>>>
>>>> The STFLE.12 can be turned off when starting the guest, so this may 
>>>> not
>>>> be a valid test.
>>>>
>>>> We use the ap_instructions_available function (in ap.h) which executes
>>>> the TAPQ command to verify whether the AP instructions are 
>>>> installed or
>>>> not. Maybe you can do something similar here:
>>>
>>> This library relies on QCI, hence we only check for stfle.
>>> I see no sense in manually probing the whole APQN space.
>>
>>
>> Makes sense. I was thrown off by the PQAP_FC enumeration which
>> includes all of the AP function codes.
>>
>>
>>>
>>>
>>> If stfle 12 is indicated I'd expect AP instructions to not generate 
>>> exceptions or do they in a sane CPU model?
>>
>>
>> No, I would not expect PQAP(QCI) to generate an exception if STFLE 12
>> is indicated.
>>
>
> Hm, I am not sure if you can rely just on checking stfle bit 12 and if 
> that's available assume
> you have AP instructions. I never tried this. But as far as I know the 
> KVM guys there is a chance
> that you see a stfle bit 12 but get an illegal instruction exception 
> the moment you call
> an AP instruction... Maybe check this before relying on such a thing.


In order to set stfle bit 12 in the CPU model for a guest (apqci=on), 
you first have to set ap=on in the CPU model indicating that you want AP 
installed on the guest; so I don't think you would ever see stfle 12 
without having AP instructions. You can, however, have AP instructions 
without stfle 12 (apqci=off) in the CPU model.


>
>>>
>>>
>>>>> +
>>>>> +    return true;
>>>>> +}
>>>>> diff --git a/lib/s390x/ap.h b/lib/s390x/ap.h
>>>>> new file mode 100644
>>>>> index 00000000..b806513f
>>>>> --- /dev/null
>>>>> +++ b/lib/s390x/ap.h
>>>>> @@ -0,0 +1,88 @@
>>>>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>>>> +/*
>>>>> + * AP definitions
>>>>> + *
>>>>> + * Some parts taken from the Linux AP driver.
>>>>> + *
>>>>> + * Copyright IBM Corp. 2024
>>>>> + * Author: Janosch Frank <frankja@linux.ibm.com>
>>>>> + *       Tony Krowiak <akrowia@linux.ibm.com>
>>>>> + *       Martin Schwidefsky <schwidefsky@de.ibm.com>
>>>>> + *       Harald Freudenberger <freude@de.ibm.com>
>>>>> + */
>>>>> +
>>>>> +#ifndef _S390X_AP_H_
>>>>> +#define _S390X_AP_H_
>>>>> +
>>>>> +enum PQAP_FC {
>>>>> +    PQAP_TEST_APQ,
>>>>> +    PQAP_RESET_APQ,
>>>>> +    PQAP_ZEROIZE_APQ,
>>>>> +    PQAP_QUEUE_INT_CONTRL,
>>>>> +    PQAP_QUERY_AP_CONF_INFO,
>>>>> +    PQAP_QUERY_AP_COMP_TYPE,
>>>>> +    PQAP_BEST_AP,
>>>>
>>>>
>>>> Maybe use abbreviations like your function names above?
>>>>
>>>>     PQAP_TAPQ,
>>>>     PQAP_RAPQ,
>>>>     PQAP_ZAPQ,
>>>>     PQAP_AQIC,
>>>>     PQAP_QCI,
>>>>     PQAP_QACT,
>>>>     PQAP_QBAP
>>>>
>>>
>>> Hmmmmmmm(TM)
>>> My guess is that I tried making these constants readable without 
>>> consulting architecture documents. But another option is using the 
>>> constants that you suggested and adding comments with a long version.
>>
>>
>> I think that works out better; you won't have to abbreviate the longer
>> version which will make it easier to understand.
>>
>>
>>>
>>> Will do
>>>
>>> [...]
>>>
>>>>> +struct pqap_r0 {
>>>>> +    uint32_t pad0;
>>>>> +    uint8_t fc;
>>>>> +    uint8_t t : 1;        /* Test facilities (TAPQ)*/
>>>>> +    uint8_t pad1 : 7;
>>>>> +    uint8_t ap;
>>>>
>>>>
>>>> This is the APID part of an APQN, so how about renaming to 'apid'
>>>>
>>>>
>>>>> +    uint8_t qn;
>>>>
>>>>
>>>> This is the APQI  part of an APQN, so how about renaming to 'apqi'
>>>
>>> Hmm Linux uses qid
>>> I'll change it to the Linux naming convention, might take me a while 
>>> though
>>
>>
>> Well, the AP bus uses qid, but the vfio_ap module and the architecture
>> doc uses APQN. In any case, it's a nit and I'm not terribly concerned
>> about it.
>>
>>
>>>
>>>>
>>>>
>>>>> +} __attribute__((packed)) __attribute__((aligned(8)));
>>>>> +
>>>>> +struct pqap_r2 {
>>>>> +    uint8_t s : 1;        /* Special Command facility */
>>>>> +    uint8_t m : 1;        /* AP4KM */
>>>>> +    uint8_t c : 1;        /* AP4KC */
>>>>> +    uint8_t cop : 1;    /* AP is in coprocessor mode */
>>>>> +    uint8_t acc : 1;    /* AP is in accelerator mode */
>>>>> +    uint8_t xcp : 1;    /* AP is in XCP-mode */
>>>>> +    uint8_t n : 1;        /* AP extended addressing facility */
>>>>> +    uint8_t pad_0 : 1;
>>>>> +    uint8_t pad_1[3];
>>>>
>>>>
>>>> Is there a reason why the 'Classification'  field is left out?
>>>>
>>>
>>> It's not used in this library and therefore I chose to not name it 
>>> to make structs a bit more readable.
>>
>>
>> Okay, not a problem.
>>
>>
>>>
>>>>
>>>>> +    uint8_t at;
>>>>> +    uint8_t nd;
>>>>> +    uint8_t pad_6;
>>>>> +    uint8_t pad_7 : 4;
>>>>> +    uint8_t qd : 4;
>>>>> +} __attribute__((packed))  __attribute__((aligned(8)));
>>>>> +_Static_assert(sizeof(struct pqap_r2) == sizeof(uint64_t), 
>>>>> "pqap_r2 size");
>>>>> +
>>>>> +bool ap_setup(void);
>>>>> +int ap_pqap_tapq(uint8_t ap, uint8_t qn, struct ap_queue_status 
>>>>> *apqsw,
>>>>> +         struct pqap_r2 *r2);
>>>>> +int ap_pqap_qci(struct ap_config_info *info);
>>>>> +#endif
>>>>> diff --git a/s390x/Makefile b/s390x/Makefile
>>>>> index 7fce9f9d..4f6c627d 100644
>>>>> --- a/s390x/Makefile
>>>>> +++ b/s390x/Makefile
>>>>> @@ -110,6 +110,7 @@ cflatobjs += lib/s390x/malloc_io.o
>>>>>    cflatobjs += lib/s390x/uv.o
>>>>>    cflatobjs += lib/s390x/sie.o
>>>>>    cflatobjs += lib/s390x/fault.o
>>>>> +cflatobjs += lib/s390x/ap.o
>>>>>       OBJDIRS += lib/s390x
>>>
>

