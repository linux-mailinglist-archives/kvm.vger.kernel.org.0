Return-Path: <kvm+bounces-20598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 052DD91A33D
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 11:57:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28B2B1C210DA
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 09:57:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79E3813BC1B;
	Thu, 27 Jun 2024 09:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qAoMQRCc"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4603013AD38;
	Thu, 27 Jun 2024 09:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719482251; cv=none; b=KHePnwuO7s+/7vTfyvkkIBKfJqkCwBvfnx4aM+dKs4qMXK6b4WaiCdDq+dTlULmYWt7cGO7OCvuJwMlaxdSd1LGxDjfIx2AvJR/x7Vp+vwIHr89tjyOc8N4llyb5wYNkx6LQwNBsQ4gse5kKTGOjx/WS51Qp0sVXWeNzlqkQuHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719482251; c=relaxed/simple;
	bh=UqOwbqkMNXTT4ULqP3dfsZPDLFa+BpBNEosWDJszsCQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N/ZyJVylFpQRCtAovnUFE8PUfQuqDOLMrMBYZ3CXmpn8lb5wlvmo1L4PaVQpm4sh3QyX+mbn9NZ09mEYQXFBKZ/III1BRIcSaJipirp9U82k/Y+HnFgHhV0DXjYphZhOzCAYoP2HLFENDOvkJlgXOA7MRF2lWemuvH/WSVmWhTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qAoMQRCc; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45R9QYv2012401;
	Thu, 27 Jun 2024 09:57:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=Rf6GOJ2fyjDALxBduqpDoo0AhqQ
	6IPPt7JWd/CKLPOo=; b=qAoMQRCcuoRKg+qmai/Gr9yo5cwqaK/ZIqyfI/w5imX
	El+WhZ8m4qJs40GGUt7Vj1ExlH8046LFJQHRpbw0Iyhwqdafhlw9mwrrI0NY9ZD6
	4Is2gSufxeIG0ju8ew/3/+cmAHGup2jBAP745mQIwVV/WEkO3ung6ohpeiMd4rce
	Ef/y2gPE/v1v1pVzNRjrj9Xcg2/QRxPIy9bWuvu+5swLB9sbS7T+nZxgiJo8AMJd
	CXSlbfXWxM8NEHkQoW8aTJw5RFSrVw6sUMGwmB/oIv48SzqwE/Aa0r1/vVX1c5FX
	dEb9K+J808YhQJJn4L1LZ1PgXNzJIq7bDvxhkpY/Z1A==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4014kmg727-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 09:57:28 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45R9vRWt005311;
	Thu, 27 Jun 2024 09:57:27 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4014kmg723-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 09:57:27 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45R7KAOY018156;
	Thu, 27 Jun 2024 09:57:26 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yx8xujahg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 09:57:26 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45R9vLM857868696
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Jun 2024 09:57:23 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4BE4D2004F;
	Thu, 27 Jun 2024 09:57:21 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 05EF42004B;
	Thu, 27 Jun 2024 09:57:21 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 27 Jun 2024 09:57:20 +0000 (GMT)
Date: Thu, 27 Jun 2024 11:57:20 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Subject: Re: [PATCH 1/1] KVM: s390: fix LPSWEY handling
Message-ID: <20240627095720.8660-D-hca@linux.ibm.com>
References: <20240627090520.4667-1-borntraeger@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240627090520.4667-1-borntraeger@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AqUqA01LRqMmyEZ_IqU8o5UO3cxIZB9j
X-Proofpoint-GUID: IOGk9w10CP-LEvgigN9vgGkgHtBoq4Hg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-27_06,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 suspectscore=0 malwarescore=0 mlxlogscore=558 mlxscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2406270074

On Thu, Jun 27, 2024 at 11:05:20AM +0200, Christian Borntraeger wrote:
> in rare cases, e.g. for injecting a machine check we do intercept all
> load PSW instructions via ICTL_LPSW. With facility 193 a new variant
> LPSWEY was added. KVM needs to handle that as well.
> 
> Fixes: a3efa8429266 ("KVM: s390: gen_facilities: allow facilities 165, 193, 194 and 196")
> Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h |  1 +
>  arch/s390/kvm/kvm-s390.c         |  1 +
>  arch/s390/kvm/kvm-s390.h         | 16 ++++++++++++++++
>  arch/s390/kvm/priv.c             | 32 ++++++++++++++++++++++++++++++++
>  4 files changed, 50 insertions(+)

...

> +static inline u64 kvm_s390_get_base_disp_siy(struct kvm_vcpu *vcpu, u8 *ar)
> +{
> +	u32 base1 = vcpu->arch.sie_block->ipb >> 28;
> +	u32 disp1 = ((vcpu->arch.sie_block->ipb & 0x0fff0000) >> 16) +
> +			((vcpu->arch.sie_block->ipb & 0xff00) << 4);
> +
> +	/* The displacement is a 20bit _SIGNED_ value */
> +	if (disp1 & 0x80000)
> +		disp1+=0xfff00000;
> +
> +	if (ar)
> +		*ar = base1;
> +
> +	return (base1 ? vcpu->run->s.regs.gprs[base1] : 0) + (long)(int)disp1;
> +}

You may want to use sign_extend32() or sign_extend64() instead of open-coding.

