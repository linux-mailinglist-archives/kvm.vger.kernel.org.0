Return-Path: <kvm+bounces-20677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFFD991C1B4
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 16:53:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D8B9A1C2029A
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 14:53:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 881311C0DC2;
	Fri, 28 Jun 2024 14:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JAvDTHVG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C651BF31A;
	Fri, 28 Jun 2024 14:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719586412; cv=none; b=r/Y23nrJQ32s6rqDmljPfkKy7l5Vg93WL8kTrS40Z26psQx29tgmgpSEy2ZRI9tqVU7mXGDUmNW7M/dq+xXj94k7QbHady1jgBheVguz4mObDi+ZO8305Hlh9nWDYEBEdLJka0vx62TozrjfJcjbGMIWxJMxsFU4z2jB5JKnQ+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719586412; c=relaxed/simple;
	bh=2erkd6pZSQNGxfwFE08K3kc5HUHx/Q1NGS+jzHs4YAs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OyH5HanUcoIddyi573fsKS5OXb05pYRzOp6ID0jTuNlUWEMLZX/lMTzruoGlOAJ991SXMbXc0rho8oh3LQWCQHVKAJAVxH/AXy88nACZ1LgeWJ837A5dWbclJ2rBTO+1Ruk7TRdP2bXjXHgEFpHm2mImXpbje1IlcLfFXWmb9D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JAvDTHVG; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45SDaCEV019270;
	Fri, 28 Jun 2024 14:53:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=pp1; bh=k
	y5ti0R1Uu6HTbyICH6c9d41oPHX7cr20xhGcaVe158=; b=JAvDTHVGUzQ1jxZHS
	lQ5Yf8GmCd85wTiW7OCmOcFUhKVOYLV1yBeX8PE7A4ibXG6wfIuwtrOHxh89M5js
	Vc85GAwTDn+WyuKjq+YujYleRV5fn52IysicU0fyZbhQ9xMrJGGYycuAUX+WbsCI
	pr6Ruf6O0cDjjfvnSAkm1Yu0W2E2DjCJXkF47kjA9pFgmmMC4hEcrrlG3spPSRO6
	F03FFMY/jU5oveRUQJL4kgFO3mKPjkHa7sYq91r4zrW7Z/In8FVG9QFR0jdgibnm
	S1c5k7qU4NcORO/xiaJS0Pcinf6/DZa4FAUdWr3oGajvLX3I75BgjaqPlUdTZiJf
	ubJnQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 401wn7gakx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Jun 2024 14:53:28 +0000 (GMT)
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45SErSUF014177;
	Fri, 28 Jun 2024 14:53:28 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 401wn7gaks-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Jun 2024 14:53:28 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45SDsBa5019672;
	Fri, 28 Jun 2024 14:53:27 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yx9xqgw8g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Jun 2024 14:53:27 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45SErLXu55378204
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Jun 2024 14:53:23 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 613BF2004B;
	Fri, 28 Jun 2024 14:53:21 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1CE122004E;
	Fri, 28 Jun 2024 14:53:21 +0000 (GMT)
Received: from [9.152.224.222] (unknown [9.152.224.222])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 28 Jun 2024 14:53:21 +0000 (GMT)
Message-ID: <23e861e2-d184-4367-acc9-3e72c48c3282@linux.ibm.com>
Date: Fri, 28 Jun 2024 16:53:20 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] KVM: s390: fix LPSWEY handling
To: Heiko Carstens <hca@linux.ibm.com>
Cc: KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390
 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vasily Gorbik
 <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
References: <20240627090520.4667-1-borntraeger@linux.ibm.com>
 <20240627095720.8660-D-hca@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20240627095720.8660-D-hca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dU61rfqx3SfECLit2Hy3HbwbC6l2RizS
X-Proofpoint-ORIG-GUID: HE6SQZmg7-lYzWt7-ZPApv3AYpY_mDwp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-28_10,2024-06-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 clxscore=1015
 suspectscore=0 bulkscore=0 malwarescore=0 mlxlogscore=758
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2406140001 definitions=main-2406280111



Am 27.06.24 um 11:57 schrieb Heiko Carstens:
> On Thu, Jun 27, 2024 at 11:05:20AM +0200, Christian Borntraeger wrote:
>> in rare cases, e.g. for injecting a machine check we do intercept all
>> load PSW instructions via ICTL_LPSW. With facility 193 a new variant
>> LPSWEY was added. KVM needs to handle that as well.
>>
>> Fixes: a3efa8429266 ("KVM: s390: gen_facilities: allow facilities 165, 193, 194 and 196")
>> Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>> Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/kvm_host.h |  1 +
>>   arch/s390/kvm/kvm-s390.c         |  1 +
>>   arch/s390/kvm/kvm-s390.h         | 16 ++++++++++++++++
>>   arch/s390/kvm/priv.c             | 32 ++++++++++++++++++++++++++++++++
>>   4 files changed, 50 insertions(+)
> 
> ...
> 
>> +static inline u64 kvm_s390_get_base_disp_siy(struct kvm_vcpu *vcpu, u8 *ar)
>> +{
>> +	u32 base1 = vcpu->arch.sie_block->ipb >> 28;
>> +	u32 disp1 = ((vcpu->arch.sie_block->ipb & 0x0fff0000) >> 16) +
>> +			((vcpu->arch.sie_block->ipb & 0xff00) << 4);
>> +
>> +	/* The displacement is a 20bit _SIGNED_ value */
>> +	if (disp1 & 0x80000)
>> +		disp1+=0xfff00000;
>> +
>> +	if (ar)
>> +		*ar = base1;
>> +
>> +	return (base1 ? vcpu->run->s.regs.gprs[base1] : 0) + (long)(int)disp1;
>> +}
> 
> You may want to use sign_extend32() or sign_extend64() instead of open-coding.

Something like sign_extend64(disp1, 31)
I actually find that harder to read, but I am open for other opinions.





