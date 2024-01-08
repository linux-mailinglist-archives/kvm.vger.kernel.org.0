Return-Path: <kvm+bounces-5825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C115826FED
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 14:33:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9441C1C22878
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 13:33:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A6A644C83;
	Mon,  8 Jan 2024 13:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="U6+1fdBa"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A150944C86;
	Mon,  8 Jan 2024 13:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 408BkQLU019128;
	Mon, 8 Jan 2024 13:33:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1FIsb05A/7CV5T0Bv1gII4COOTZLFXVTCftK299PoHU=;
 b=U6+1fdBa1jxlcnRqBt+QJhMsCBOI0wbLNBD6O3TolJg5BUmkvfTdg+50Q+2PP25+2gFY
 g3I9iJZVUSdHc9/jDZ0+umbq7PkYJFIdwSYzwYfQq+n3iLd3K8yvSk4L4+qbrLPWLqp6
 ax/fQdWFpTA6mFlAWkhkXE+cIl6lNmdV5sh6VIkCB5fABufhpid6IWAapf1NqGURhLo4
 mHuQVZls8cSADK3wulWeQQlNSdlvFnqALFFqcCJCrz8LPDdCs8tpgmkgmzRpjlxMsR2C
 Z+Ou5fhXEBn04qhvNObDhhNGpG6nS1n4CerbRpW6BptD65vEf3zQXDc0w55wLbFStjNI ig== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vf5xbu09a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Jan 2024 13:33:34 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 408Cp0p1024499;
	Mon, 8 Jan 2024 13:33:34 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vf5xbu08g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Jan 2024 13:33:34 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 408D0FY6022859;
	Mon, 8 Jan 2024 13:33:33 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vfj6n83f5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Jan 2024 13:33:33 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 408DXU2G59507022
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 8 Jan 2024 13:33:30 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 36A232004D;
	Mon,  8 Jan 2024 13:33:30 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B567520043;
	Mon,  8 Jan 2024 13:33:29 +0000 (GMT)
Received: from [9.171.48.50] (unknown [9.171.48.50])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  8 Jan 2024 13:33:29 +0000 (GMT)
Message-ID: <1f818fb8-9d69-43ba-9270-d4f387e7acf4@linux.ibm.com>
Date: Mon, 8 Jan 2024 14:33:29 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 3/5] s390x: Add library functions for
 exiting from snippet
Content-Language: en-US
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, Nico Boehr <nrb@linux.ibm.com>
Cc: Andrew Jones <andrew.jones@linux.dev>, linux-s390@vger.kernel.org,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
References: <20240105225419.2841310-1-nsg@linux.ibm.com>
 <20240105225419.2841310-4-nsg@linux.ibm.com>
 <1f78218f-f67b-4d99-83d7-2b18455b2519@linux.ibm.com>
 <00dc269c9a487b4601fc27c97771240e0b407ff6.camel@linux.ibm.com>
From: Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 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
In-Reply-To: <00dc269c9a487b4601fc27c97771240e0b407ff6.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3ZV9a-zbYYRkgnuUniRgPO2g06YnAx2V
X-Proofpoint-ORIG-GUID: N9maeJjNLscQuwZXhlYnug_844Xektdz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-08_04,2024-01-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 mlxlogscore=711 suspectscore=0 malwarescore=0 impostorscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401080116

On 1/8/24 13:58, Nina Schoetterl-Glausch wrote:
> On Mon, 2024-01-08 at 13:47 +0100, Janosch Frank wrote:
>> On 1/5/24 23:54, Nina Schoetterl-Glausch wrote:
>>> It is useful to be able to force an exit to the host from the snippet,
>>> as well as do so while returning a value.
>>> Add this functionality, also add helper functions for the host to check
>>> for an exit and get or check the value.
>>> Use diag 0x44 and 0x9c for this.
>>> Add a guest specific snippet header file and rename snippet.h to reflect
>>> that it is host specific.
>>>
>>> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>>> ---
>>>    s390x/Makefile                          |  1 +
>>>    lib/s390x/asm/arch_def.h                | 13 ++++++++
>>>    lib/s390x/sie.h                         |  1 +
>>>    lib/s390x/snippet-guest.h               | 26 +++++++++++++++
>>>    lib/s390x/{snippet.h => snippet-host.h} | 10 ++++--
>>>    lib/s390x/sie.c                         | 31 ++++++++++++++++++
>>>    lib/s390x/snippet-host.c                | 42 +++++++++++++++++++++++++
>>>    lib/s390x/uv.c                          |  2 +-
>>>    s390x/mvpg-sie.c                        |  2 +-
>>>    s390x/pv-diags.c                        |  2 +-
>>>    s390x/pv-icptcode.c                     |  2 +-
>>>    s390x/pv-ipl.c                          |  2 +-
>>>    s390x/sie-dat.c                         |  2 +-
>>>    s390x/spec_ex-sie.c                     |  2 +-
>>>    s390x/uv-host.c                         |  2 +-
>>>    15 files changed, 129 insertions(+), 11 deletions(-)
>>>    create mode 100644 lib/s390x/snippet-guest.h
>>>    rename lib/s390x/{snippet.h => snippet-host.h} (92%)
>>>    create mode 100644 lib/s390x/snippet-host.c
> 
> [..]
>   
>>> +bool sie_is_diag_icpt(struct vm *vm, unsigned int diag)
>>> +{
>>> +	union {
>>> +		struct {
>>> +			uint64_t     : 16;
>>> +			uint64_t ipa : 16;
>>> +			uint64_t ipb : 32;
>>> +		};
>>> +		struct {
>>> +			uint64_t          : 16;
>>> +			uint64_t opcode   :  8;
>>> +			uint64_t r_1      :  4;
>>> +			uint64_t r_2      :  4;
>>> +			uint64_t r_base   :  4;
>>> +			uint64_t displace : 12;
>>> +			uint64_t zero     : 16;
>>> +		};
>>> +	} instr = { .ipa = vm->sblk->ipa, .ipb = vm->sblk->ipb };
>>> +	uint64_t code;
>>> +
>>> +	assert(diag == 0x44 || diag == 0x9c);
>>
>> You're calling it is_diag_icpt and only allow two.
>> Do you have a reason for clamping this down?
> 
> I should have left the comment.
> They're just "not implemented".
> The PoP doesn't specify how diags are generally interpreted,
> so I intended that if any other diags are needed whoever needs them
> just checks if the existing logic works or if changes are required.
>>

Right, but 288, 308 and 500 are being used in the PV sie tests and could 
be integrated.

