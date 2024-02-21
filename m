Return-Path: <kvm+bounces-9290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C9B0885D1EE
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 08:57:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED33A1C22D7B
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 07:57:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEE093BB46;
	Wed, 21 Feb 2024 07:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rZqtaXPz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B852B3B1AB;
	Wed, 21 Feb 2024 07:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708502259; cv=none; b=HITb3t29VksFrZT9lnpfq6tJGSDHlrUTiog0KmOisJTJD7d34WsWHHsVRM9fE1rM9whsX+jyIV0jq66WpLO7zuKuJG/DwiUS1iMTOvVz8VkXB8tRwF4v0xwQI11YrDFJezxabVQE7TAWl/1ih+NGSv0NALb7LAX+xVxrxKWwB8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708502259; c=relaxed/simple;
	bh=pdIvFwT6ElHXEXaKjIJQ0cIfhRUQBgUVB+bNj6ghhH4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UONpyeb/yzWO9AbeaKDIXLua4DmtAsdHn1hSQsJ7MD5NoASglITAc6yo/oNAL1PtgQAXSwsD+2t7wLhBktBHcMlNfP09DucgEP0ug1+ADImkw/otRW7rCd6uUCDPXjcpHR3OR8AfTAq4NyshtmjSWiYgGwzOFRhGLjSgaatDgG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rZqtaXPz; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41L7tXQO001971;
	Wed, 21 Feb 2024 07:57:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=8GsfnWbJyjdtUyPK3VJ0a021A8Y3VbcpQLuqOk5/fhs=;
 b=rZqtaXPzw1GMdZJDigBk5C3A+jfcRUIr33/2sTji0ghE3Q0fT247kfUwQ2T2fdSLGbkU
 uURDy4NW/9DoHu9p1LzhZ1/QXXHoeLEyrKAMZloiXa+ESlQft9ya4HNs9aAtd26V6UlA
 vZxfV0FUW4SVWpGyGYon092lKnmxqnRlHYiZxJCpu50Qyw2cWZ2jx1qmyPhKnTFcRJMF
 26y3ksfxKbxL+UzB72KtzNjm3uQb5BrZb+oxI6uZZeCUxuBIeCzgXBB6SFKXzJcMLLX/
 WhIF0pPoHSgoujsKYIWPakh264R3+sIAQFegjTQV1q+BXwDEp7OEFwukfy0Vyrtsan7Z lA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wdcqp0pdr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Feb 2024 07:57:36 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41L7uO9B006397;
	Wed, 21 Feb 2024 07:57:36 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wdcqp0pd7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Feb 2024 07:57:36 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 41L5qfJb009551;
	Wed, 21 Feb 2024 07:57:34 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3wb84pdntd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Feb 2024 07:57:34 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 41L7vT2417302034
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Feb 2024 07:57:31 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 104572004E;
	Wed, 21 Feb 2024 07:57:29 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6A75F20043;
	Wed, 21 Feb 2024 07:57:28 +0000 (GMT)
Received: from [9.179.10.137] (unknown [9.179.10.137])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 21 Feb 2024 07:57:28 +0000 (GMT)
Message-ID: <e1d9aa94-c63b-4214-a091-b2aee0cd21f9@linux.ibm.com>
Date: Wed, 21 Feb 2024 08:57:28 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v4 2/7] s390x: Add guest 2 AP test
Content-Language: en-US
To: Anthony Krowiak <akrowiak@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        jjherne@linux.ibm.com
References: <20240202145913.34831-1-frankja@linux.ibm.com>
 <20240202145913.34831-3-frankja@linux.ibm.com>
 <f05c83a9-bcc6-4963-98f4-72159673ba3a@linux.ibm.com>
From: Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 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
In-Reply-To: <f05c83a9-bcc6-4963-98f4-72159673ba3a@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zULjXn72SBO_M9StKvZ8GvMBrYnT3N_v
X-Proofpoint-GUID: stL8Vw5xBwLumV7SsnIlfN2eSdklwD-i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-20_06,2024-02-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 phishscore=0 impostorscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 spamscore=0
 suspectscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311290000 definitions=main-2402210061

On 2/20/24 17:38, Anthony Krowiak wrote:
> I made a couple of function name change suggestions, but those are not
> critical:
> 
> Acked-by: Anthony Krowiak <akrowiak@linux.ibm.com>
> 
> On 2/2/24 9:59 AM, Janosch Frank wrote:
>> Add a test that checks the exceptions for the PQAP, NQAP and DQAP
>> adjunct processor (AP) crypto instructions.
>>
>> Since triggering the exceptions doesn't require actual AP hardware,
>> this test can run without complicated setup.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>    s390x/Makefile      |   1 +
>>    s390x/ap.c          | 309 ++++++++++++++++++++++++++++++++++++++++++++
>>    s390x/unittests.cfg |   3 +
>>    3 files changed, 313 insertions(+)
>>    create mode 100644 s390x/ap.c
>>
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index 4f6c627d..6d28a5bf 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -42,6 +42,7 @@ tests += $(TEST_DIR)/exittime.elf
>>    tests += $(TEST_DIR)/ex.elf
>>    tests += $(TEST_DIR)/topology.elf
>>    tests += $(TEST_DIR)/sie-dat.elf
>> +tests += $(TEST_DIR)/ap.elf
>>    
>>    pv-tests += $(TEST_DIR)/pv-diags.elf
>>    pv-tests += $(TEST_DIR)/pv-icptcode.elf
>> diff --git a/s390x/ap.c b/s390x/ap.c
>> new file mode 100644
>> index 00000000..b3cee37a
>> --- /dev/null
>> +++ b/s390x/ap.c
>> @@ -0,0 +1,309 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * AP instruction G2 tests
>> + *
>> + * Copyright (c) 2024 IBM Corp
>> + *
>> + * Authors:
>> + *  Janosch Frank <frankja@linux.ibm.com>
>> + */
>> +
>> +#include <libcflat.h>
>> +#include <interrupt.h>
>> +#include <bitops.h>
>> +#include <alloc_page.h>
>> +#include <asm/facility.h>
>> +#include <asm/time.h>
>> +#include <ap.h>
>> +
>> +/* For PQAP PGM checks where we need full control over the input */
>> +static void pqap(unsigned long grs[3])
>> +{
>> +	asm volatile(
>> +		"	lgr	0,%[r0]\n"
>> +		"	lgr	1,%[r1]\n"
>> +		"	lgr	2,%[r2]\n"
>> +		"	.insn	rre,0xb2af0000,0,0\n" /* PQAP */
>> +		::  [r0] "d" (grs[0]), [r1] "d" (grs[1]), [r2] "d" (grs[2])
>> +		: "cc", "memory", "0", "1", "2");
>> +}
>> +
>> +static void test_pgms_pqap(void)
> 
> 
> If I saw this function name without having read the patch description, I
> wouldn't have any idea what is being tested.
> 
> Maybe test_pqap_pgm_chk?

If I'm not mistaken, then it should be consistent with the pgm checks 
for other instructions but I don't mind renaming it.

> 
> 
>> +{
>> +	unsigned long grs[3] = {};
>> +	struct pqap_r0 *r0 = (struct pqap_r0 *)grs;
>> +	uint8_t *data = alloc_page();
>> +	uint16_t pgm;
>> +	int fails = 0;
>> +	int i;
>> +
>> +	report_prefix_push("pqap");
>> +
>> +	/* Wrong FC code */
>> +	report_prefix_push("invalid fc");
>> +	r0->fc = 42;
> 
> 
> Just out of curiosity, why 42? Why not some ridiculous number that will
> never be used for a function code, like 4294967295?

No particular reason.

Increasing the number would increase the buffer zone of invalid values 
but there's currently only a hand full of values defined anyway.
I might add a couple of 0s to this for the next version and call it a day.


