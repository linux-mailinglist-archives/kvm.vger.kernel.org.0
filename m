Return-Path: <kvm+bounces-28901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D63FB99F096
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 17:03:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9551C2814A9
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 15:03:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 017D01CBA0C;
	Tue, 15 Oct 2024 15:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QfX0vw2R"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901B91CB9F5;
	Tue, 15 Oct 2024 15:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729004521; cv=none; b=PF6Cnu/DujnXg1PSCrQ5M5jpFu6ComzMzV/Ga1Cj1rXsOgEovffjF2p0N6118KeIzGzamedpxHg4x0gEW/OsjSYE9bUylynl6aa4XLwHXK4ZqEccQIZ5nZY6TtR4ybJ1yTJXeZQDvD4vtpdF7gEE0kSXXNjh1xg4eabYbWK/Ma8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729004521; c=relaxed/simple;
	bh=YGU+J1NkQ+h6jYecjiH9GTgc+nKSIsMGztz7yJvVgZc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UWPypOgSCz2KYPvINudqR98J4vFtfpisb2Yf+fvC4jXhtBTOIIrf+yXfj0ZOJMKyEX2JM5eW9lZwwqYiIUq1xZyyvIOnzdgQIfM5YU2zsGkP0YdsONWXdc1U4ZUbaxB43YX/F9zq0mi5x3Ui1eTqpbKx/7A97KDx2Ag0LTobgoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QfX0vw2R; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FEtfPS009449;
	Tue, 15 Oct 2024 15:01:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Sw+G2O
	/RrELhPikO7oYEY0X9vcv1HAK1MI8RNoTdpK0=; b=QfX0vw2R0JcukJBH8XOl4Q
	C/cFm/nvg8NerS5ren9vi7oHWhiOxxgGOSkUEhKIXfrkxEvYJ5cTG/UyaKzC/i1d
	IozoobDpdmXWHXQmS/3ou+RSR3NYTJ6V8WVC3brGi0F7S1sZoy1rHeLGtW8RD7kq
	d0rAykktgNEuOkIAMWAPP1upUMvy1UhKtsJrZUbbhTZccP01dTd8eQ+SPAMJiqXP
	EAT8C4QEI/ZZdh2h51KuO1b7AwVuMSuj4u4xg7qQGPROoHWR2Lm2WSgr5ocmB+TQ
	8+xn/s98biWQaWiodsEmoj6CZOQf6Elu2nxXchVvFcs87evddMQpU7PXQTuRHEVQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429tk781eq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 15:01:50 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49FEwHl3016212;
	Tue, 15 Oct 2024 15:01:50 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429tk781ej-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 15:01:49 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49FEGSbq027499;
	Tue, 15 Oct 2024 15:01:48 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4283txmjcp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 15:01:48 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49FF1lsZ27001358
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 15:01:47 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 22B9858051;
	Tue, 15 Oct 2024 15:01:47 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 376BD5805C;
	Tue, 15 Oct 2024 15:01:45 +0000 (GMT)
Received: from wecm-9-67-37-172.wecm.ibm.com (unknown [9.67.37.172])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 15 Oct 2024 15:01:45 +0000 (GMT)
Message-ID: <8131b905c61a7baf4bd09ec4a08e1ace84d36754.camel@linux.ibm.com>
Subject: Re: [PATCH v2 4/7] s390/physmem_info: query diag500(STORAGE LIMIT)
 to support QEMU/KVM memory devices
From: Eric Farman <farman@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>, David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        Vasily Gorbik
 <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian
 Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle
 <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Cornelia Huck
 <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio
 Imbrenda <imbrenda@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eugenio =?ISO-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Andrew Morton
 <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mario
 Casquero <mcasquer@redhat.com>
Date: Tue, 15 Oct 2024 11:01:44 -0400
In-Reply-To: <20241014184339.10447-E-hca@linux.ibm.com>
References: <20241014144622.876731-1-david@redhat.com>
	 <20241014144622.876731-5-david@redhat.com>
	 <20241014184339.10447-E-hca@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.52.4 (3.52.4-1.fc40) 
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: oiDcZvE5rWbNLUCRElJ1IfzPka5qxG8w
X-Proofpoint-GUID: flUxXiPfEXI7RXTEkEcHTYtcpZ7IpCgb
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 bulkscore=0
 clxscore=1011 malwarescore=0 phishscore=0 adultscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410150101

On Mon, 2024-10-14 at 20:43 +0200, Heiko Carstens wrote:
> On Mon, Oct 14, 2024 at 04:46:16PM +0200, David Hildenbrand wrote:
> > To support memory devices under QEMU/KVM, such as virtio-mem,
> > we have to prepare our kernel virtual address space accordingly and
> > have to know the highest possible physical memory address we might see
> > later: the storage limit. The good old SCLP interface is not suitable f=
or
> > this use case.
> >=20
> > In particular, memory owned by memory devices has no relationship to
> > storage increments, it is always detected using the device driver, and
> > unaware OSes (no driver) must never try making use of that memory.
> > Consequently this memory is located outside of the "maximum storage
> > increment"-indicated memory range.
> >=20
> > Let's use our new diag500 STORAGE_LIMIT subcode to query this storage
> > limit that can exceed the "maximum storage increment", and use the
> > existing interfaces (i.e., SCLP) to obtain information about the initial
> > memory that is not owned+managed by memory devices.

...snip...

> The patch below changes your code accordingly, but it is
> untested. Please verify that your code still works.

...snip...

> diff --git a/arch/s390/boot/physmem_info.c b/arch/s390/boot/physmem_info.c
> index fb4e66e80fd8..975fc478e0e3 100644
> --- a/arch/s390/boot/physmem_info.c
> +++ b/arch/s390/boot/physmem_info.c
> @@ -109,10 +109,11 @@ static int diag260(void)
>  	return 0;
>  }
> =20
> +#define DIAG500_SC_STOR_LIMIT 4
> +
>  static int diag500_storage_limit(unsigned long *max_physmem_end)
>  {
> -	register unsigned long __nr asm("1") =3D 0x4;
> -	register unsigned long __storage_limit asm("2") =3D 0;
> +	unsigned long storage_limit;
>  	unsigned long reg1, reg2;
>  	psw_t old;
> =20
> @@ -123,21 +124,24 @@ static int diag500_storage_limit(unsigned long *max=
_physmem_end)
>  		"	st	%[reg2],4(%[psw_pgm])\n"
>  		"	larl	%[reg1],1f\n"
>  		"	stg	%[reg1],8(%[psw_pgm])\n"
> +		"	lghi	1,%[subcode]\n"
> +		"	lghi	2,0\n"
>  		"	diag	2,4,0x500\n"
>  		"1:	mvc	0(16,%[psw_pgm]),0(%[psw_old])\n"
> +		"	lgr	%[slimit],2\n"
>  		: [reg1] "=3D&d" (reg1),
>  		  [reg2] "=3D&a" (reg2),
> -		  "+&d" (__storage_limit),
> +		  [slimit] "=3Dd" (storage_limit),
>  		  "=3DQ" (get_lowcore()->program_new_psw),
>  		  "=3DQ" (old)
>  		: [psw_old] "a" (&old),
>  		  [psw_pgm] "a" (&get_lowcore()->program_new_psw),
> -		  "d" (__nr)
> -		: "memory");
> -	if (!__storage_limit)
> -	        return -EINVAL;
> -	/* convert inclusive end to exclusive end. */
> -	*max_physmem_end =3D __storage_limit + 1;
> +		  [subcode] "i" (DIAG500_SC_STOR_LIMIT)
> +		: "memory", "1", "2");
> +	if (!storage_limit)
> +		return -EINVAL;
> +	/* Convert inclusive end to exclusive end */
> +	*max_physmem_end =3D storage_limit + 1;
>  	return 0;
>  }
> =20
>=20

I like the idea of a defined constant here instead of hardcoded, but maybe =
it should be placed
somewhere in include/uapi so that QEMU can pick it up with update-linux-hea=
ders.sh and be in sync
with the kernel, instead of just an equivalent definition in [1] ?

[1] https://lore.kernel.org/qemu-devel/20241008105455.2302628-8-david@redha=
t.com/


