Return-Path: <kvm+bounces-64535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 853D7C86804
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 19:11:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B773D4E8A79
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 18:11:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53EF732D0CF;
	Tue, 25 Nov 2025 18:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tQjBB42c"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FBE32C939;
	Tue, 25 Nov 2025 18:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094254; cv=none; b=H/AiW2uOtH4GKsgc4nAxibVrtg1Z36d+GQrDyHkq9GtzDNLmgUm+l5+wwlNO2feHkfGqhQzTWr0w8FB74riPQHdq303zMtwUCarL9HsPWnoFrqUtPnXwLsVjBmZPYpywK+WDn8M/cglNmkQ/JoYi+ab+RHj7ySU4yhAefu2ergI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094254; c=relaxed/simple;
	bh=G4Yxen9Y970IoJc7ogmo+GXjakvIB6kNGtXDMPWxpJ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bRqbO2YYdmVEawyeCqcq/WVrLoEplOQb5p0F11VuVn9KnFtZYHlM+++6p0w5v3vrGEk9PrffpCmwqZEA8/52qlTfYTXrP2ggYBWKzdTnFDX4ybJG5ZmahBf6Q6XCngevxZP+dkPzkLbiyxkiH8x+/uWvuf0r3PLEyAkIagpxOhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tQjBB42c; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AP9o1jG005649;
	Tue, 25 Nov 2025 18:10:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=FxP4vs
	tR6tYCZLyTX/O+dvm0zLxGZTOrH10okDomhmU=; b=tQjBB42cPQ2NFM/HupaA+8
	mui/YWQVtYewZq01jZX0IA53z1oywouLSQ1GjVwOaX9l4J/iURadabr84A4L4Rnm
	LiUqqDBkB+OCm74m2bSJ1A4ii5ubzQDooqvjKvjeXp3Y24yjIp5G4QLCOF0uhE0v
	GRu1kFE3NWN1iF702u42DOev9dWJk04YIvyNmuStXhU59YKbm2SVhFAteyu+0f/p
	EQoC8NkdjYZXLu01GkZVKJ7dlOEkVYjW2WRz9EK+oR44KfohQ/3Fcp8puQRRC1f+
	mQ0rdwq4WJ2ufqS+qUVg3xV0f8d2JwaboJot6kiurwG5i0bMISyPliOC/pE9R+Yg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4phyces-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Nov 2025 18:10:48 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5APG8EF0019023;
	Tue, 25 Nov 2025 18:10:47 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4aksqjnaqf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Nov 2025 18:10:47 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5APIAi6016581106
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Nov 2025 18:10:44 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0720120043;
	Tue, 25 Nov 2025 18:10:44 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8E3C920040;
	Tue, 25 Nov 2025 18:10:43 +0000 (GMT)
Received: from [9.87.153.97] (unknown [9.87.153.97])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 25 Nov 2025 18:10:43 +0000 (GMT)
Message-ID: <fd5ad2be-f15f-425f-b8ef-087dc639024d@linux.ibm.com>
Date: Tue, 25 Nov 2025 19:10:43 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: s390: Implement CHECK_STOP support and fix
 GET_MP_STATE
To: Josephine Pfeiffer <hi@josie.lol>, borntraeger@linux.ibm.com
Cc: imbrenda@linux.ibm.com, david@kernel.org, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <3e4020ae-9fdb-46be-8f18-4319fc09c5cc@linux.ibm.com>
 <20251120182849.1109773-1-hi@josie.lol>
Content-Language: en-US
From: Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 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
In-Reply-To: <20251120182849.1109773-1-hi@josie.lol>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAxNiBTYWx0ZWRfX54MIGVwR6Owq
 SszphyOi6RWPpI55rJ/ZdzBNa+4Ym2UJqD6gyBwhqP+gUS7d1NOVpbeDFMdbisBocOjPmrY5YMP
 HuU34W+2hEKC5pOeliYmG8nW3JWPbdFGKnc+C/gUtyhpJCKkjtF2m44FZ0H1mmsEMecGeda3etn
 dy/rcpern/+SbnuW7vFF3vA+b5Qr3c6RK4MERpy01vBTtsLV1TICQg/vtG3wV/pLhTgp5SVzGr7
 aNiA7ieY+BW/bnYRZaxh8aZH4w4wMX7SEu18JMgoExasRt7CX/a18OkY7i1Jnt8zNBl382uZrlY
 VXkCEko+CQj848c4dKVlA/cRcJstRlLqqWVcs4mnfTkAhCdATiFtMuZFIiTzmYesTjgi/j0Zq9k
 shcuU0N64xT8pxg/mOP+tqjvLre9VA==
X-Proofpoint-ORIG-GUID: pwQjP5gJ0lhrk07cwHJBiV4rm18GTO90
X-Authority-Analysis: v=2.4 cv=CcYFJbrl c=1 sm=1 tr=0 ts=6925f128 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7yJLPMNZ0KZShS_iNwgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: pwQjP5gJ0lhrk07cwHJBiV4rm18GTO90
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 clxscore=1011 adultscore=0 spamscore=0
 phishscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511220016

On 11/20/25 19:28, Josephine Pfeiffer wrote:
> On Mon, 17 Nov 2025 19:14:57 +0100, Christian Borntraeger wrote:
>> Am 17.11.25 um 16:18 schrieb Josephine Pfeiffer:
>>> Add support for KVM_MP_STATE_CHECK_STOP to enable proper VM migration
>>> and error handling for s390 guests. The CHECK_STOP state represents a
>>> CPU that encountered a severe machine check and is halted in an error
>>> state.
>>
>> I think the patch description is misleading. We do have proper VM
>> migration and we also have error handling in the kvm module. The host
>> machine check handler will forward guest machine checks to the guest.
>> This logic  is certainly not perfect but kind of good enough for most
>> cases.
> 
> First of all, thank you for taking the time to look at my patch, and sorry
> for taking so long to write up the reply.
> 
> You're right, QEMU migrates cpu_state via vmstate [1] and only uses
> KVM_SET_MP_STATE to restore the state after migration [2], never calling
> KVM_GET_MP_STATE. So I misunderstood something there.
> 
> What prompted me to look into this was that the KVM API has advertised
> CHECK_STOP support without implementing it.
> Looking at commit 6352e4d2dd9a [3] from 2014: "KVM: s390: implement
> KVM_(S|G)ET_MP_STATE for user space state control"
> 
> This commit added KVM_MP_STATE_CHECK_STOP to include/uapi/linux/kvm.h [4] and
> documented it in Documentation/virtual/kvm/api.txt with:
> 
>    "KVM_MP_STATE_CHECK_STOP: the vcpu is in a special error state [s390]"
> 
> But the implementation was explicitly deferred with a fallthrough comment [3]:
> 
>    case KVM_MP_STATE_LOAD:
>    case KVM_MP_STATE_CHECK_STOP:
>        /* fall through - CHECK_STOP and LOAD are not supported yet */
>    default:
>        rc = -ENXIO;
> 
> This created a bit of an API asymmetry where:
> - Documentation/virt/kvm/api.rst:1546 [5] advertises CHECK_STOP as valid
> - KVM_SET_MP_STATE rejects it with -ENXIO
> - KVM_GET_MP_STATE never returns it (always returns STOPPED or OPERATING) [6]
> 
>> Now: The architecture defines that state and the interface is certainly
>> there. So implementing it will allow userspace to put a CPU into checkstop
>> state if you ever need that. We also have a checkstop state that you
>> can put a secure CPU in.
>>
>> The usecase is dubious though. The only case of the options from POP
>> chapter11 that makes sense to me in a virtualized environment is an exigent
>> machine check but a problem to actually deliver that (multiple reasons,
>> like the OS has machine checks disabled in PSW, or the prefix register
>> is broken).
>>
>> So I am curious, do you have any specific usecase in mind?
>> I assume you have a related QEMU patch somewhere?
> 
> The use cases I see are:
> 
> 1. API completeness: The state was added to the UAPI 11 years ago but never
>     implemented. Userspace cannot use a documented API feature.

I'd rather have stubs which properly fence than code that's never tested 
since we don't use it.

Since this never worked it might make sense to remove it since future 
users will need to check for this "feature" anyway before using it.

> 
> 2. Fault injection testing: Administrators testing failover/monitoring for
>     hardware failures could programmatically put a CPU into CHECK_STOP to
>     verify their procedures work.

How would that work?
What can we gain from putting a CPU into checkstop?
How would QEMU use this?


Checkstop is not an error communication medium, that's the machine check 
interrupt. If you want to inject faults then use the machine check 
interface.

If you want to crash the guest, then panic it or just stop cpus.

