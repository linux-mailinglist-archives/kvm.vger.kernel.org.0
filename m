Return-Path: <kvm+bounces-20767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ED30E91D9B6
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 10:11:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8FDE281675
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 08:11:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A581823AF;
	Mon,  1 Jul 2024 08:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WiEgpdJ3"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122FE347B4;
	Mon,  1 Jul 2024 08:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719821474; cv=none; b=CYhaF9uOiJy1tMtPzoYQqLP+T7ZZbGda9mJb71XgKR/K+8iSdAdHg7ChmF86e5FtO+pv+pOPAd/Gv2g4UeL0kzKXPNGALhNSpoAurXemHWaZKUrRfvpzk/XOW8JnT9+TVzryJ4BiTh9EaRUOh8XSB8UN2giSYTVAjhWUpHQ0qI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719821474; c=relaxed/simple;
	bh=6kXUClkkz/GOM8XlLjvMyVd3pt0V09fYtGv43+wYVIs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=pH1fL8AR8/q1DEZqnjnNqtANf9rOB0UC9i0CV4PEMTq6sqUxhEt/D319Hwq5HMuA8htpiyyetCs9B1kOTzDHrVDxw+Sb3uid3n4ZF2bIyy9yNKEXtlYh20ODSd3ynva3qKTaa4Rm5ZT1UOc4rOX+WaETTeSvvh2hvmLIJcB+at0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WiEgpdJ3; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4617xWvF000458;
	Mon, 1 Jul 2024 08:11:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:in-reply-to:references:date:message-id
	:mime-version:content-type; s=pp1; bh=dM5P4PoDjd4JnNGpnMAsXRyk1r
	FAG/Cbpsg3ayh5hEQ=; b=WiEgpdJ3iety2nIn2sKoTbF1LrNBD3ZDMdghoYc4iq
	/D7iiaK4wZmjZfwIZgnRXL7Dyl9jGu7XZBA49/4aW7fijOpoETgH1lp3VfQLKARt
	h2+FWcUYq+2odRvyH6UYH9xxeDXGovZSji3IQ8rdizEmuR54w4JitKE4Mscr4vxT
	tbi6yTILtsk+SwcGUqTrCI/2EnSvTFTK53cUashcJw6CvJ1nOUQaZZeoeqFEUz74
	3UfTHJnDna7zXf8glNbLF5Simah1EChCtKHFzZpRVsw6Cgk4Ddc3RzlQs0y1R9wa
	uTDYOR6cLWaJm9UfpmZLYScMJLqtu2uB3hfy8wB4qegA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 403rhjr13h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jul 2024 08:11:11 +0000 (GMT)
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4618BAVT019087;
	Mon, 1 Jul 2024 08:11:10 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 403rhjr13a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jul 2024 08:11:10 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4616AaAv024071;
	Mon, 1 Jul 2024 08:11:09 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 402ya35se8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jul 2024 08:11:09 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4618B4gW50004468
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 1 Jul 2024 08:11:06 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 631752006A;
	Mon,  1 Jul 2024 08:11:04 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1ECBC2004F;
	Mon,  1 Jul 2024 08:11:04 +0000 (GMT)
Received: from tuxmaker.linux.ibm.com (unknown [9.152.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  1 Jul 2024 08:11:04 +0000 (GMT)
From: Sven Schnelle <svens@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390
 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio
 Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Subject: Re: [PATCH v2] KVM: s390: fix LPSWEY handling
In-Reply-To: <20240628163547.2314-1-borntraeger@linux.ibm.com> (Christian
	Borntraeger's message of "Fri, 28 Jun 2024 18:35:47 +0200")
References: <20240628163547.2314-1-borntraeger@linux.ibm.com>
Date: Mon, 01 Jul 2024 10:11:03 +0200
Message-ID: <yt9da5j17crs.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5Hx_Gk_VVPwomHKadAQOuaPD6lJq9-DH
X-Proofpoint-GUID: oZxGHpjjkfNS5mb5Rz0CXCrYGmqgMTDy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-01_06,2024-06-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 mlxscore=0 spamscore=0 malwarescore=0
 mlxlogscore=633 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2406140001 definitions=main-2407010060

Christian Borntraeger <borntraeger@linux.ibm.com> writes:

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
>  arch/s390/kvm/kvm-s390.h         | 15 +++++++++++++++
>  arch/s390/kvm/priv.c             | 32 ++++++++++++++++++++++++++++++++
>  4 files changed, 49 insertions(+)
>
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index 111eb5c74784..1b326f3c3383 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -138,6 +138,21 @@ static inline u64 kvm_s390_get_base_disp_s(struct kvm_vcpu *vcpu, u8 *ar)
>  	return (base2 ? vcpu->run->s.regs.gprs[base2] : 0) + disp2;
>  }
>  
> +static inline u64 kvm_s390_get_base_disp_siy(struct kvm_vcpu *vcpu, u8 *ar)
> +{
> +	u32 base1 = vcpu->arch.sie_block->ipb >> 28;
> +	s64 disp1;
> +       

Whitespace error. With that removed:

Reviewed-by: Sven Schnelle <svens@linux.ibm.com>

> +	/* The displacement is a 20bit _SIGNED_ value */
> +	disp1 = sign_extend64(((vcpu->arch.sie_block->ipb & 0x0fff0000) >> 16) +
> +			      ((vcpu->arch.sie_block->ipb & 0xff00) << 4), 19);
> +
> +	if (ar)
> +		*ar = base1;
> +
> +	return (base1 ? vcpu->run->s.regs.gprs[base1] : 0) + disp1;
> +}

