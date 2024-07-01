Return-Path: <kvm+bounces-20755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CA8A91D7E4
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 08:08:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC6DE1F221E5
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 06:08:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 940AA42056;
	Mon,  1 Jul 2024 06:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bSbac3AS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4794EB45;
	Mon,  1 Jul 2024 06:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719814109; cv=none; b=cGi1xHQToQBrvSM2Htz2K30WTWYoVt7G/4t7REvIVZQS3EVmcGxO3n2IkO+6l1oNDzr/sfA6gX/a0XlcK47E7t2VjsBEHvre71h0zjXFjyXvBS0VgZlb21LBkZEWsWjvuSY0w6cGMFdAzZYFka4qjMmHvVWmQLV8tatQzASUINk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719814109; c=relaxed/simple;
	bh=pqPbTpR/aSldUdairdkUnhR9r4brOpF4s7psy7F8HpE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=IZ+3tOeBzf38oziMmArvHRgwIGJjRkJuh1n1rgDewHmmLezYn4tbE7seouNJvD2n8obX4Mt0F32MKc9ISq4pwiW69+jwfYia1iNQG9XglV7P3OuG46lyPLbOI2hAQOVfbdFzlFRaXYPRr0Nr4oItMSnq0CXwHf4xWzwteor3ccc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bSbac3AS; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4615Qg3S019483;
	Mon, 1 Jul 2024 06:08:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:in-reply-to:references:date:message-id
	:mime-version:content-type; s=pp1; bh=6N0xXgkUPB0Hv1CY14p/XSJx18
	plOvhkxLdrv2fR8LM=; b=bSbac3ASVe2L9S2LGJbr5L/0W9YrIf4SpPwQ+owHfU
	arigSjt1490gGqEtE5DbbEg0JXMysamJcR57K6NatumupkMl+8JgwV+tRQPbKwS6
	is9OuFJ7EubzJ5e4hA6Tr2iiQop+dQo3O9lPXgOEYXOpx5qTXGwuG9S9rjj+kI78
	hGYKWzyQijgGIKTLsIIsRobYL0ZIdP2jtIeGxXunpu1JNUdNRIvRNyKqI/jc2l/o
	uXbNwkNpnn3x76O2FJC4jrWrJT3n2D18bUxRWEfwNRvuZB4iT8I0eFMueFRsKGev
	1V8MOn3jVESMvNECRq25tkFgc+KXONPOYQ9LFWlYNe7A==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 403nwf84jc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jul 2024 06:08:24 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 46168O2Z017808;
	Mon, 1 Jul 2024 06:08:24 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 403nwf84ja-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jul 2024 06:08:24 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4613SlEr009150;
	Mon, 1 Jul 2024 06:08:23 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 402w00du3b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jul 2024 06:08:23 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 46168HPh34538094
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 1 Jul 2024 06:08:19 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AF9B620213;
	Mon,  1 Jul 2024 06:08:17 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 745D42020F;
	Mon,  1 Jul 2024 06:08:17 +0000 (GMT)
Received: from tuxmaker.linux.ibm.com (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  1 Jul 2024 06:08:17 +0000 (GMT)
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
Date: Mon, 01 Jul 2024 08:08:17 +0200
Message-ID: <yt9do77h7ige.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GXLcfo-FKGAPgT9ElLMxG2qMxVd_YtdY
X-Proofpoint-ORIG-GUID: h20TbR6gD5fjDVQ9KByhBVM-kUaTItmB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-01_04,2024-06-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 impostorscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=849 clxscore=1011 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2406140001
 definitions=main-2407010043

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
> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
> index 1be19cc9d73c..1a49b89706f8 100644
> --- a/arch/s390/kvm/priv.c
> +++ b/arch/s390/kvm/priv.c
> @@ -797,6 +797,36 @@ static int handle_lpswe(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> +static int handle_lpswey(struct kvm_vcpu *vcpu)
> +{
> +	psw_t new_psw;
> +	u64 addr;
> +	int rc;
> +	u8 ar;
> +
> +	vcpu->stat.instruction_lpswey++;
> +
> +	if (!test_kvm_facility(vcpu->kvm, 193))
> +		return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);
> +
> +	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
> +		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
> +
> +	addr = kvm_s390_get_base_disp_siy(vcpu, &ar);
> +	if (addr & 7)
> +		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
> +
> +	rc = read_guest(vcpu, addr, ar, &new_psw, sizeof(new_psw));
> +	if (rc)
> +		return kvm_s390_inject_prog_cond(vcpu, rc);
> +
> +	vcpu->arch.sie_block->gpsw = new_psw;
> +	if (!is_valid_psw(&vcpu->arch.sie_block->gpsw))
> +		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);

Shouldn't the gpsw get updated with new_psw after the check? POP says "The operation
is suppressed on all addressing and protection exceptions."

> +
> +	return 0;
> +}

