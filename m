Return-Path: <kvm+bounces-48515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F4162ACED75
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 12:22:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D0A4189666E
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 10:22:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 848C2213E9C;
	Thu,  5 Jun 2025 10:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GnCEwQQ7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163EC136348;
	Thu,  5 Jun 2025 10:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749118923; cv=none; b=bhVH0feFc2dQPWhLf4G/e0X8bZGZn8uvTjww/KvNmCF25gA911dN8GCDwjkGt6qiF2l/wNCv96e3uOX9prQba+CA1IvUkiGWecaSOiImRc7s/eKbIzEv8Yjgd3VDKpLvE6pg51M/WNvZjUIiIlEn2F9LUA99wVKvBKk1jEbSM00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749118923; c=relaxed/simple;
	bh=A1EqnlT1sXl2/LPtDKcZk2fyhqrswKxri+pwgrd6I3A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fXrSeN0Siyfuqp3VPpTcynU2TeyZaSnOvbiiXvv8YdgnO1GL5vJHDHwmWhjSAgO5qzcSL6KovkKnDduhb/e4p5FKwpklO9RfszR3MW6X5E+qdaZo9iTzbPM3ZSzefpsa3tT03QcTCDRBjqbWKyapBVlMPNClnSLpP+z/Ldx+neA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GnCEwQQ7; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5559fWZB023453;
	Thu, 5 Jun 2025 10:21:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=j1x6xf
	2O+oUdbGJDyYVUyubk5Mp+x6kFlU2Gr3J0gZI=; b=GnCEwQQ7+2zzZ4T4cK/n26
	HMcuQO9aPMM2dDo9ZDrKyqXzuARII3tS+wOsXHu4mBVCRnvWhmTodOxQw8KTqBoC
	lbhYFEjHBzug/OPKdGYVg/AN4Uq3UX4kZA0gLM7Ec4jp3y6A8XHB/W8wpSNv/NV3
	otMO7XTkcp/G+YZpRiN+pNTzmDQv4GpPHEFzNzNlHrAGeDU1E8x74XwDN/XfgFn6
	FBym9FFdFAWO9eeAJ0yKc3PLWu6N4O5rjagi9Cr/e1FUea14wP8lSSO9cvyui1Sp
	Yd48leDN0eLs45awLJBTIlkHedHdYcZRdnR+7gXn2CS1IsXBLCupdpcMPOg3RwRQ
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 471gf003w2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Jun 2025 10:21:59 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5558sBSo012549;
	Thu, 5 Jun 2025 10:21:58 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 470et2kx0b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Jun 2025 10:21:58 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 555ALsgn49217868
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 5 Jun 2025 10:21:54 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ED56820067;
	Thu,  5 Jun 2025 10:21:53 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9D17B20065;
	Thu,  5 Jun 2025 10:21:53 +0000 (GMT)
Received: from [9.152.224.132] (unknown [9.152.224.132])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  5 Jun 2025 10:21:53 +0000 (GMT)
Message-ID: <2dfdc293-beef-4a67-8173-00697d1fcc8c@linux.ibm.com>
Date: Thu, 5 Jun 2025 12:21:53 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] s390/mm: Fix in_atomic() handling in
 do_secure_storage_access()
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20250603134936.1314139-1-hca@linux.ibm.com>
 <aEB0BfLG9yM3Gb4u@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <20250604184855.44793208@p-imbrenda>
 <aECCe9bIZORv+yef@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <20250604194043.0ab9535e@p-imbrenda>
 <aEFdoYSKqvqK572c@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <408922a2-ec1a-4e60-841a-90714a3310de@linux.ibm.com>
 <20250605100743.7808A03-hca@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20250605100743.7808A03-hca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Pq2TbxM3 c=1 sm=1 tr=0 ts=68416fc7 cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=EelIrjACvyVQsPZcEQcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA1MDA4OCBTYWx0ZWRfX271KAbKZwllO N5Sbm5P3FGIqcnRhBJMdG69KMqOsG8XvA+DBldvCusvy7AdjumNIN1tG8Oe2m1qln1KdmoyErzp wljFy5RxnicyGHRpfuLimBPOoZrq24Ub+gOwSqrzQps0ubzDvIlQ3Vav0zXTT5hvPbU2Z40QI0f
 LtKOjdQCx4X53JqRRLvE0x6bJjkK403oBKp2vuXAK1MTEUn85+MFi7FLaYAinwL0bsiuHq0BhmI 9LUu/zmbyVozJP/1S7zMlfGjy1sUneV+9Mh1dOaVhO6M5yEcMfdXeWxQ9Wh4ShRV5+yujCCnW/n ULDYjt7Y30H3Y/Nf0oJkbbQMyJWu2rCIjwDQEAz5PGlIMStD3FG5H9h41wVuEWWzWz8NpAC4yE7
 xjvH1HKNy13YP4qTtk3SoduxPg763cXmSrwUQTkZ8MQtitqXkvMY4r8MCUT/lfs94gMdU469
X-Proofpoint-GUID: QBZUv65jLo5T9ek5Hw6khQFVufRkancR
X-Proofpoint-ORIG-GUID: QBZUv65jLo5T9ek5Hw6khQFVufRkancR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-05_02,2025-06-03_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 mlxlogscore=675
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 mlxscore=0 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506050088



Am 05.06.25 um 12:07 schrieb Heiko Carstens:
> On Thu, Jun 05, 2025 at 11:06:29AM +0200, Christian Borntraeger wrote:
>> Am 05.06.25 um 11:04 schrieb Alexander Gordeev:
>>> On Wed, Jun 04, 2025 at 07:40:43PM +0200, Claudio Imbrenda wrote:
>>>>>>> This could trigger WARN_ON_ONCE() in handle_fault_error_nolock():
>>>>>>>
>>>>>>> 		if (WARN_ON_ONCE(!si_code))
>>>>>>> 			si_code = SEGV_MAPERR;
>>>>>>>
>>>>>>> Would this warning be justified in this case (aka user_mode(regs) ==
>>>>>>> true)?
>>>>>>
>>>>>> I think so, because if we are in usermode, we should never trigger
>>>>>> faulthandler_disabled()
>>>>>
>>>>> I think I do not get you. We are in a system call and also in_atomic(),
>>>>> so faulthandler_disabled() is true and handle_fault_error_nolock(regs, 0)
>>>>> is called (above).
>>>>
>>>> what is the psw in regs?
>>>> is it not the one that was being used when the exception was triggered?
>>>
>>> Hmm, right. I assume is_kernel_fault() returns false not because
>>> user_mode(regs) is true, but because we access the secondary AS.
>>>
>>> Still, to me it feels wrong to trigger that warning due to a user
>>> process activity. But anyway:
>>>
>>> Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
>>
>> Can we trigger a WARN from userspace?
> 
> No. If the warning triggers, then this indicates a bug in the kernel (exit to
> user with faulthandler_disabled() == true). I managed to screw up the kernel
> exactly with such a bug. See commit 588a9836a4ef ("s390/stacktrace: Use break
> instead of return statement"), which lead to random unexplainable user space
> crashes.

Ok, then this makes a lot of sense to WARN.

Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>

