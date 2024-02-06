Return-Path: <kvm+bounces-8093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47B4B84B04C
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 09:48:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C8401C24616
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 08:48:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0184712BE94;
	Tue,  6 Feb 2024 08:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RYbmsDZH"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5245A2E3F0;
	Tue,  6 Feb 2024 08:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707209301; cv=none; b=SPH8/0mB4T78ogxGpaHtBgmOB3/BNZUdvAQmLceYl+vRJHMEmrqYzSAItP+NkCq7aZCVY6pN5HEZ1pXwUw99/m9lxW1u8SjerSrzAc8/uW2HdAGVNhIJSWiHHm1xK5iqGjQlLe4W50t9SgTngvcXrE5vPPH+pcUl0pcnyiiLx48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707209301; c=relaxed/simple;
	bh=l1u39sRapU3K2QUr4wOuTdYHQl5MA9TtZJfkMdFxFe4=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=hdiWJQptr6eUxTm0c3HzJ2gYYZIrafB6xMruwE5lUFLVnjPFbbV21BkggDN6KN9/w4hj7SFa3cKM8Uk89nI64+icCjb7ezvvGzwxwtWIALgg+bTnvjfcAn3/Je7qP52jw3dhAuF4gu9/MLTf81NWn1PRk5Imi4H58b0EyqQXxLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RYbmsDZH; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4168gDh0008297;
	Tue, 6 Feb 2024 08:48:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : reply-to : in-reply-to : references :
 message-id : content-type : content-transfer-encoding; s=pp1;
 bh=beExTQZLWV6H6HmbDDx9BAQMTcTobwpaHUpdIM3+lO4=;
 b=RYbmsDZHFzjjmGqvDCj2lQhDE1h0jp07SU4uZUsDlla+OdAJ9nnGhQGM5wY8+HsHLubo
 x8dF49SjTQNxK01hoJIxmTYYnMk36XwyHKGXYD0Fsm7LMmebLcMY+j8lSBWoppV78UMX
 T+youwPLuuNBC1F3mMnYqdQ58mjcPpOSKeAEUE/Ffppkufb9OFl9J0OMbYjWc2Lsp0Cy
 UjCPZCJ+8DEz8C9RTQ0B/gDBkwUPIT1MnhElwLfcrzqbldAyPlEIi5R35kz0D3rfpnl6
 fK2bX6Izw7N08jRm0I9Lf4on94RRskzalHl3P/W5u7j4/U/uVjybC2SuGXpT82gN4hw1 hg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w3hg6g61k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Feb 2024 08:48:18 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4168gMWl008618;
	Tue, 6 Feb 2024 08:48:17 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w3hg6g60g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Feb 2024 08:48:17 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4167j1wT008539;
	Tue, 6 Feb 2024 08:48:16 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3w221jwhkw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Feb 2024 08:48:16 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4168mGED5112640
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 6 Feb 2024 08:48:16 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 28AB558057;
	Tue,  6 Feb 2024 08:48:16 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BA22558058;
	Tue,  6 Feb 2024 08:48:15 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  6 Feb 2024 08:48:15 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 06 Feb 2024 09:48:15 +0100
From: Harald Freudenberger <freude@linux.ibm.com>
To: Anthony Krowiak <akrowiak@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        jjherne@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v4 1/7] lib: s390x: Add ap library
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <b1bb6df4-dea3-414d-9f53-dfd76571fbb7@linux.ibm.com>
References: <20240202145913.34831-1-frankja@linux.ibm.com>
 <20240202145913.34831-2-frankja@linux.ibm.com>
 <b1bb6df4-dea3-414d-9f53-dfd76571fbb7@linux.ibm.com>
Message-ID: <371c501723c32160a755ca62442a7fc5@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Iutp2d8VsCHEYyD4Z5eR_p_FaEzx-SoD
X-Proofpoint-ORIG-GUID: 7J76QZzgiKkc9pcclG1ocwSryf5SeJhI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-06_02,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 priorityscore=1501 clxscore=1011 impostorscore=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402060061

On 2024-02-05 19:15, Anthony Krowiak wrote:
> I made a few comments and suggestions. I am not very well-versed in
> the inline assembly code, so I'll leave that up to someone who is more
> knowledgeable. I copied @Harald since I believe it was him who wrote
> it.
> 
> On 2/2/24 9:59 AM, Janosch Frank wrote:
>> Add functions and definitions needed to test the Adjunct
>> Processor (AP) crypto interface.
>> 
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   lib/s390x/ap.c | 97 
>> ++++++++++++++++++++++++++++++++++++++++++++++++++
>>   lib/s390x/ap.h | 88 +++++++++++++++++++++++++++++++++++++++++++++
>>   s390x/Makefile |  1 +
>>   3 files changed, 186 insertions(+)
>>   create mode 100644 lib/s390x/ap.c
>>   create mode 100644 lib/s390x/ap.h
>> 
>> diff --git a/lib/s390x/ap.c b/lib/s390x/ap.c
>> new file mode 100644
>> index 00000000..9560ff64
>> --- /dev/null
>> +++ b/lib/s390x/ap.c
>> @@ -0,0 +1,97 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * AP crypto functions
>> + *
>> + * Some parts taken from the Linux AP driver.
>> + *
>> + * Copyright IBM Corp. 2024
>> + * Author: Janosch Frank <frankja@linux.ibm.com>
>> + *	   Tony Krowiak <akrowia@linux.ibm.com>
>> + *	   Martin Schwidefsky <schwidefsky@de.ibm.com>
>> + *	   Harald Freudenberger <freude@de.ibm.com>
>> + */
>> +
>> +#include <libcflat.h>
>> +#include <interrupt.h>
>> +#include <ap.h>
>> +#include <asm/time.h>
>> +#include <asm/facility.h>
>> +
>> +int ap_pqap_tapq(uint8_t ap, uint8_t qn, struct ap_queue_status 
>> *apqsw,
>> +		 struct pqap_r2 *r2)
>> +{
>> +	struct pqap_r0 r0 = {
>> +		.ap = ap,
>> +		.qn = qn,
>> +		.fc = PQAP_TEST_APQ
>> +	};
>> +	uint64_t bogus_cc = 2;
>> +	int cc;
>> +
>> +	/*
>> +	 * Test AP Queue
>> +	 *
>> +	 * Writes AP configuration information to the memory pointed
>> +	 * at by GR2.
>> +	 *
>> +	 * Inputs: GR0
>> +	 * Outputs: GR1 (APQSW), GR2 (tapq data)
>> +	 * Synchronous
>> +	 */
>> +	asm volatile(
>> +		"       tmll	%[bogus_cc],3\n"
>> +		"	lgr	0,%[r0]\n"
>> +		"	.insn	rre,0xb2af0000,0,0\n" /* PQAP */
>> +		"	stg	1,%[apqsw]\n"
>> +		"	stg	2,%[r2]\n"
>> +		"	ipm	%[cc]\n"
>> +		"	srl	%[cc],28\n"
>> +		: [apqsw] "=&T" (*apqsw), [r2] "=&T" (*r2), [cc] "=&d" (cc)
>> +		: [r0] "d" (r0), [bogus_cc] "d" (bogus_cc));
>> +
>> +	return cc;
>> +}
>> +
>> +int ap_pqap_qci(struct ap_config_info *info)
>> +{
>> +	struct pqap_r0 r0 = { .fc = PQAP_QUERY_AP_CONF_INFO };
>> +	uint64_t bogus_cc = 2;
>> +	int cc;
>> +
>> +	/*
>> +	 * Query AP Configuration Information
>> +	 *
>> +	 * Writes AP configuration information to the memory pointed
>> +	 * at by GR2.
>> +	 *
>> +	 * Inputs: GR0, GR2 (QCI block address)
>> +	 * Outputs: memory at GR2 address
>> +	 * Synchronous
>> +	 */
>> +	asm volatile(
>> +		"       tmll	%[bogus_cc],3\n"
>> +		"	lgr	0,%[r0]\n"
>> +		"	lgr	2,%[info]\n"
>> +		"	.insn	rre,0xb2af0000,0,0\n" /* PQAP */
>> +		"	ipm	%[cc]\n"
>> +		"	srl	%[cc],28\n"
>> +		: [cc] "=&d" (cc)
>> +		: [r0] "d" (r0), [info] "d" (info), [bogus_cc] "d" (bogus_cc)
>> +		: "cc", "memory", "0", "2");
>> +
>> +	return cc;
>> +}
>> +
>> +/* Will later be extended to a proper setup function */
>> +bool ap_setup(void)
>> +{
>> +	/*
>> +	 * Base AP support has no STFLE or SCLP feature bit but the
>> +	 * PQAP QCI support is indicated via stfle bit 12. As this
>> +	 * library relies on QCI we bail out if it's not available.
>> +	 */
>> +	if (!test_facility(12))
>> +		return false;
> 
> 
> The STFLE.12 can be turned off when starting the guest, so this may
> not be a valid test.
> 
> We use the ap_instructions_available function (in ap.h) which executes
> the TAPQ command to verify whether the AP instructions are installed
> or not. Maybe you can do something similar here:
> 
> 
> static inline bool ap_instructions_available(void)
> 
> {
>     unsigned long reg0 = 0x0000;
>     unsigned long reg1 = 0;
> 
>     asm volatile(
>         "    lgr    0,%[reg0]\n"        /* qid into gr0 */
>         "    lghi    1,0\n"            /* 0 into gr1 */
>         "    lghi    2,0\n"            /* 0 into gr2 */
>         "    .insn    rre,0xb2af0000,0,0\n"    /* PQAP(TAPQ) */
>         "0:    la    %[reg1],1\n"        /* 1 into reg1 */
>         "1:\n"
>         EX_TABLE(0b, 1b)
>         : [reg1] "+&d" (reg1)
>         : [reg0] "d" (reg0)
>         : "cc", "0", "1", "2");
>     return reg1 != 0;
> }

Well, as Janos wrote - this lib functions rely on having QCI available.
However, be carefully using the above function as it is setting up
an exception table entry which is to catch the illegal instruction
which will arise when no AP bus support is available.

>> +
>> +	return true;
>> +}
>> diff --git a/lib/s390x/ap.h b/lib/s390x/ap.h
>> new file mode 100644
>> index 00000000..b806513f
>> --- /dev/null
>> +++ b/lib/s390x/ap.h
>> @@ -0,0 +1,88 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * AP definitions
>> + *
>> + * Some parts taken from the Linux AP driver.
>> + *
>> + * Copyright IBM Corp. 2024
>> + * Author: Janosch Frank <frankja@linux.ibm.com>
>> + *	   Tony Krowiak <akrowia@linux.ibm.com>
>> + *	   Martin Schwidefsky <schwidefsky@de.ibm.com>
>> + *	   Harald Freudenberger <freude@de.ibm.com>
>> + */
>> +
>> +#ifndef _S390X_AP_H_
>> +#define _S390X_AP_H_
>> +
>> +enum PQAP_FC {
>> +	PQAP_TEST_APQ,
>> +	PQAP_RESET_APQ,
>> +	PQAP_ZEROIZE_APQ,
>> +	PQAP_QUEUE_INT_CONTRL,
>> +	PQAP_QUERY_AP_CONF_INFO,
>> +	PQAP_QUERY_AP_COMP_TYPE,

What is that       ^^^^^^^^^^^^^ ?
The QACT ? But that's only one PQAP subfuntion.

>> +	PQAP_BEST_AP,

And this ^^^^^^^^^^^^ ? Never heard about.

> 
> 
> Maybe use abbreviations like your function names above?
> 
> 	PQAP_TAPQ,
> 	PQAP_RAPQ,
> 	PQAP_ZAPQ,
> 	PQAP_AQIC,
> 	PQAP_QCI,
> 	PQAP_QACT,
> 	PQAP_QBAP
> 
> 
>> +};
>> +
>> +struct ap_queue_status {
>> +	uint32_t pad0;			/* Ignored padding for zArch  */
> 
> 
> Bit 0 is the E (queue empty) bit.
> 
> 
>> +	uint32_t empty		: 1;
>> +	uint32_t replies_waiting: 1;
>> +	uint32_t full		: 1;
>> +	uint32_t pad1		: 4;
>> +	uint32_t irq_enabled	: 1;
>> +	uint32_t rc		: 8;
>> +	uint32_t pad2		: 16;
>> +} __attribute__((packed))  __attribute__((aligned(8)));
>> +_Static_assert(sizeof(struct ap_queue_status) == sizeof(uint64_t), 
>> "APQSW size");
>> +
>> +struct ap_config_info {
>> +	uint8_t apsc	 : 1;	/* S bit */
>> +	uint8_t apxa	 : 1;	/* N bit */
>> +	uint8_t qact	 : 1;	/* C bit */
>> +	uint8_t rc8a	 : 1;	/* R bit */
>> +	uint8_t l	 : 1;	/* L bit */
>> +	uint8_t lext	 : 3;	/* Lext bits */
>> +	uint8_t reserved2[3];
>> +	uint8_t Na;		/* max # of APs - 1 */
>> +	uint8_t Nd;		/* max # of Domains - 1 */
>> +	uint8_t reserved6[10];
>> +	uint32_t apm[8];	/* AP ID mask */
>> +	uint32_t aqm[8];	/* AP (usage) queue mask */
>> +	uint32_t adm[8];	/* AP (control) domain mask */
>> +	uint8_t _reserved4[16];
>> +} __attribute__((aligned(8))) __attribute__ ((__packed__));
>> +_Static_assert(sizeof(struct ap_config_info) == 128, "PQAP QCI 
>> size");
>> +
>> +struct pqap_r0 {
>> +	uint32_t pad0;
>> +	uint8_t fc;
>> +	uint8_t t : 1;		/* Test facilities (TAPQ)*/
>> +	uint8_t pad1 : 7;
>> +	uint8_t ap;
> 
> 
> This is the APID part of an APQN, so how about renaming to 'apid'
> 
> 
>> +	uint8_t qn;
> 
> 
> This is the APQI  part of an APQN, so how about renaming to 'apqi'
> 
> 
>> +} __attribute__((packed))  __attribute__((aligned(8)));
>> +
>> +struct pqap_r2 {
>> +	uint8_t s : 1;		/* Special Command facility */
>> +	uint8_t m : 1;		/* AP4KM */
>> +	uint8_t c : 1;		/* AP4KC */
>> +	uint8_t cop : 1;	/* AP is in coprocessor mode */
>> +	uint8_t acc : 1;	/* AP is in accelerator mode */
>> +	uint8_t xcp : 1;	/* AP is in XCP-mode */
>> +	uint8_t n : 1;		/* AP extended addressing facility */
>> +	uint8_t pad_0 : 1;
>> +	uint8_t pad_1[3];
> 
> 
> Is there a reason why the 'Classification'  field is left out?
> 
> 
>> +	uint8_t at;
>> +	uint8_t nd;
>> +	uint8_t pad_6;
>> +	uint8_t pad_7 : 4;
>> +	uint8_t qd : 4;
>> +} __attribute__((packed))  __attribute__((aligned(8)));
>> +_Static_assert(sizeof(struct pqap_r2) == sizeof(uint64_t), "pqap_r2 
>> size");
>> +

Isn't this all going into the kernel? So consider using the
arch/s390/include/asm/ap.h header file instead of re-defining the 
structs.
Feel free to improve this file with reworked structs and field names if
that's required.

>> +bool ap_setup(void);
>> +int ap_pqap_tapq(uint8_t ap, uint8_t qn, struct ap_queue_status 
>> *apqsw,
>> +		 struct pqap_r2 *r2);
>> +int ap_pqap_qci(struct ap_config_info *info);
>> +#endif
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index 7fce9f9d..4f6c627d 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -110,6 +110,7 @@ cflatobjs += lib/s390x/malloc_io.o
>>   cflatobjs += lib/s390x/uv.o
>>   cflatobjs += lib/s390x/sie.o
>>   cflatobjs += lib/s390x/fault.o
>> +cflatobjs += lib/s390x/ap.o
>>     OBJDIRS += lib/s390x
>> 

