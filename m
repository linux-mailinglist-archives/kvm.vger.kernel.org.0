Return-Path: <kvm+bounces-47364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 72051AC0C43
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 15:08:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A59A1BA3CF4
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 13:08:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECA9C28BAB4;
	Thu, 22 May 2025 13:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gSt6E3mI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6544928BA90;
	Thu, 22 May 2025 13:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747919291; cv=none; b=eG/8qENf1N+820eUIjqF29T0acmNv2EVJLZ3VFIcWczt4er2p9hv0Z2eNgJoERhInKHqLWHjruAMpqF9ThSITPlF+01d1vIn2Y8IZzVKUocTARg9aYuoyokF2YPyd5D6pJqvQpou4X5rAT1jjFkqeH6mzb7bQS0RUMnrEkkWpJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747919291; c=relaxed/simple;
	bh=l8HXL9p+A1M840vmWGJ1KJR/EkP2XHaRqGHpfbYpV4Q=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=PL2k7V4NqW+gaTp/tPWe2YTM9ln2cW2ixuKFslHMMUirMdCUohYMh+brRKyggP5VubjKfWnA39DDBo3Q5iyYEiYDfNihXiOVB087zGIu5DagSdZuStTSt8q7dAdzGM3yRoTjG8qiffkJ0lz+ks5iYRMssOo+vq+COZ2OzeF/fe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gSt6E3mI; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54M7LsMP002913;
	Thu, 22 May 2025 13:08:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Qc/XmQ
	KL5cf4nyq86sqlMA33WVDvG+VQcZjU7doInTg=; b=gSt6E3mIxCIqSy0aYey30T
	OOkLJswLLEK2ixZreov9IZeeDz/xdyP6pTeBMc/cT6Ib3lY/2FW7PE3sY4TK+PdT
	Qq5UieQgz+iTWvKBvLaOkBaOAhDTYmFbpblIL1efT9SSKSlRkvpagsoKSI3C1FHg
	xQ/8Aos4aF2oyb2f+9kGE4ESY0Z9oahTiO9KP8bI95KW/LhfLZWDk0erUv+AbqdJ
	p2SR0NpJe4zvFwtNnJfPNqJNih7kvxuAxbQElyZ3jy+teWyfL70fY57czIEyo71g
	4bZVlmOUu7qrH9KoaFpirdnhTf3/BiNnTzFluuyPRYZh495QM1phRBSf7vHfHIow
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46smh747m6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 13:08:06 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54M9xe8p032117;
	Thu, 22 May 2025 13:08:06 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 46rwnmhgrr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 13:08:06 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54MD828j51380570
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 May 2025 13:08:02 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4597F2004D;
	Thu, 22 May 2025 13:08:02 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2DC3B20040;
	Thu, 22 May 2025 13:08:02 +0000 (GMT)
Received: from darkmoore (unknown [9.155.210.150])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 22 May 2025 13:08:02 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 22 May 2025 15:07:57 +0200
Message-Id: <DA2PO6KCE168.39FQQB8HX0A5D@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <frankja@linux.ibm.com>, <borntraeger@de.ibm.com>,
        <seiden@linux.ibm.com>, <nsg@linux.ibm.com>, <nrb@linux.ibm.com>,
        <david@redhat.com>, <hca@linux.ibm.com>, <agordeev@linux.ibm.com>,
        <svens@linux.ibm.com>, <gor@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/5] KVM: s390: remove unneeded srcu lock
X-Mailer: aerc 0.20.1
References: <20250520182639.80013-1-imbrenda@linux.ibm.com>
 <20250520182639.80013-3-imbrenda@linux.ibm.com>
In-Reply-To: <20250520182639.80013-3-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDEzMyBTYWx0ZWRfX8RciIEJAVdcM jMk7926/rddypM652bWrONWZI05gd9FB/4UCm0TduLeA45f5noznWDxZ+0949iwyiEDq6R9n19P O3eXejr/SudPd6MBVUq/amFTGysmy/od4Azn1AES2l6VoLqyR9W4oLr03GpAhCH6XG/ECzTMZ0h
 i6Epqq702DMAi4gG3D9PwNJU9ilYk5F1CfhQRYAvdRzPyM+q6qKKsGTg6TC3GLeUJUxZPrsh34a jJLTqTTylvINkObYHl5kPmwb1bowu+LlLp4IduCjcsdKZ0FDRWfG/pozYmwq+EhNzCeWfJzOY7l 28vzKXX+9ztqkk9jLfDkgL6ysJGQCiYWf73EEMY6op/qw9CbbN4xUK5/JKLlfNem2x7QS4kvoUo
 Xya+zSRr/6RZ26oJiVxraf7JpNR2r330EBVOCUe1wU1uFfMNRENiuYP968tpCzTM1q3pqanw
X-Proofpoint-GUID: pl2oOFwhwFTXyeF_GMPGb6uNOm0t2Yk9
X-Proofpoint-ORIG-GUID: pl2oOFwhwFTXyeF_GMPGb6uNOm0t2Yk9
X-Authority-Analysis: v=2.4 cv=EdfIQOmC c=1 sm=1 tr=0 ts=682f21b6 cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=oh86K7MTI85CMi4h8AQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_06,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 malwarescore=0
 phishscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 mlxlogscore=806
 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505220133

On Tue May 20, 2025 at 8:26 PM CEST, Claudio Imbrenda wrote:
> All paths leading to handle_essa() already hold the kvm->srcu.
> Remove unneeded srcu locking from handle_essa().
> Add lockdep assertion to make sure we will always be holding kvm->srcu
> when entering handle_essa().
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

> ---
>  arch/s390/kvm/priv.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
> index 1a49b89706f8..9253c70897a8 100644
> --- a/arch/s390/kvm/priv.c
> +++ b/arch/s390/kvm/priv.c
> @@ -1248,6 +1248,8 @@ static inline int __do_essa(struct kvm_vcpu *vcpu, =
const int orc)
> =20
>  static int handle_essa(struct kvm_vcpu *vcpu)
>  {
> +	lockdep_assert_held(&vcpu->kvm->srcu);
> +
>  	/* entries expected to be 1FF */
>  	int entries =3D (vcpu->arch.sie_block->cbrlo & ~PAGE_MASK) >> 3;
>  	unsigned long *cbrlo;
> @@ -1297,12 +1299,8 @@ static int handle_essa(struct kvm_vcpu *vcpu)
>  		/* Retry the ESSA instruction */
>  		kvm_s390_retry_instr(vcpu);
>  	} else {
> -		int srcu_idx;
> -
>  		mmap_read_lock(vcpu->kvm->mm);
> -		srcu_idx =3D srcu_read_lock(&vcpu->kvm->srcu);
>  		i =3D __do_essa(vcpu, orc);
> -		srcu_read_unlock(&vcpu->kvm->srcu, srcu_idx);
>  		mmap_read_unlock(vcpu->kvm->mm);
>  		if (i < 0)
>  			return i;


