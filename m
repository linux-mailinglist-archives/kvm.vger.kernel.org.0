Return-Path: <kvm+bounces-47372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D252AAC0D1E
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 15:44:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 936F84E5BC3
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 13:44:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABFE828BAAA;
	Thu, 22 May 2025 13:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TV8EoG7+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3703928BA8D;
	Thu, 22 May 2025 13:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747921482; cv=none; b=ShXMDPWURRhWHT4eZat4nU4HMc1YbRl4iuWvKuCMRFaRmUso4BACTBHRSxhoStIabPSEd8Mpqh/npkT1SclcqtzU3YSCr78IQnCtQCfsMdbufETEMPV2X/kiX6zi42UMwSwni7Z7d1wvCz0Y26fgyCeH00oPErrZDOzZBwDGQVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747921482; c=relaxed/simple;
	bh=sGaAzNtosYu1+y5c8uYiWuNxu7g2JDjaAFqAeeUrD0c=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Subject:From:Cc:
	 References:In-Reply-To; b=bcPAq92SwEUG3xQKPvA/HchmFt0tWVuc6rS3NfEovo5I2YUIrtauuH8jycCJGVrxh5EW/Ev91YR92i6lINybujFOUJZdu+BquL11ig/RRn5Vg015CgpfKGSchRgoqHo/HpRREUOtK5CyLQ/VCfZ4QoFh+LUYxXAu8YJidCfi7IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TV8EoG7+; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54M9F2VF021150;
	Thu, 22 May 2025 13:44:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=SkpCfB
	U6p+RUo164PGssAEN6Xki41f+Zl2DXP/T72XM=; b=TV8EoG7+ih2y25O+ZzVgYH
	yYnu45PT+0YoT8TtsjiGfCGV3XFj6QfDfAr3S7Shf92G+hVQBg2xhkIZQwzTb2n9
	kBGME8sdnDr05mjAfK3SqL9wQoyCE8ZMCJ1Ff/g9U3q6a35goUkPXzGUrbgceKk8
	rCFMj8clbslDFu7hplG4/NvcVYCMlP1kQcem45LCYvekf0XTmOrm2FCemrj9PkXI
	Xru6xkD7yfTXXqZON0Dnmof6IElfp++GTK6s2e4YiQNvpOYXKnle23XD/o2spkIa
	plAk1m77goEJiHU9nKg+En3FaMeYzI7HiCgQltnAR8ZV3UmWOyUZlZyHCnwVPBkA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46t14jh848-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 13:44:24 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54M9aAiK010640;
	Thu, 22 May 2025 13:44:23 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46rwnmhp24-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 13:44:23 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54MDiJmg49021272
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 May 2025 13:44:19 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4116F2004D;
	Thu, 22 May 2025 13:44:19 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2A1262004B;
	Thu, 22 May 2025 13:44:19 +0000 (GMT)
Received: from darkmoore (unknown [9.155.210.150])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 22 May 2025 13:44:19 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 22 May 2025 15:44:14 +0200
Message-Id: <DA2QFYNT6G6B.3JVSDMJGGBL7N@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/4] KVM: s390: remove unneeded srcu lock
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <frankja@linux.ibm.com>, <borntraeger@de.ibm.com>,
        <seiden@linux.ibm.com>, <nsg@linux.ibm.com>, <nrb@linux.ibm.com>,
        <david@redhat.com>, <hca@linux.ibm.com>, <agordeev@linux.ibm.com>,
        <svens@linux.ibm.com>, <gor@linux.ibm.com>
X-Mailer: aerc 0.20.1
References: <20250522132259.167708-1-imbrenda@linux.ibm.com>
 <20250522132259.167708-3-imbrenda@linux.ibm.com>
In-Reply-To: <20250522132259.167708-3-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rmttsTKAMX20cskLAMCScpqrJg2njPmX
X-Authority-Analysis: v=2.4 cv=XOkwSRhE c=1 sm=1 tr=0 ts=682f2a38 cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=oh86K7MTI85CMi4h8AQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDEzOCBTYWx0ZWRfX68y7E0ln9QHe LNkd2u3Siazl4PKgznjc/D1fVVUCPYaMevZBR/VSbCCm0MPfaofoos54aUkrvuAfLytuWxf/dgH 9Hq7SS7lBm0raGw4Y6S9ex11Pk6BdscO3z0osYIY+d/mghmGncPzqMIyDo5x6L6cCRyp6eoNO7g
 Avp0GixcrvJ/cgiXiCjTnAb+kYsoo+u+F2Fp8XwjRhBoQVqq+2XUV1sO0I0HpfJtnz535VI3pyv JtqGx0wC9yVrWf/K06cqkEavsFZnwUIJnXnjRyba8GAks/YwamfJjCGIxf2vz3HMye08GOCbgyl XJr0TFs3divthlYDmWRKGy6uTgJ6GaBHcGYOo0PRe32NrCLSzQ488xFALZY/VZj+7v3DB3RqLYg
 W0j0Zw6FG3YNS/CWZKs4B91x0mvav/FzaeGq2tLg8YkXToCkpizMOq7eBPHxT1sK6wWFfG26
X-Proofpoint-GUID: rmttsTKAMX20cskLAMCScpqrJg2njPmX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_06,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 mlxlogscore=806 bulkscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 suspectscore=0 priorityscore=1501 spamscore=0 phishscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505220138

On Thu May 22, 2025 at 3:22 PM CEST, Claudio Imbrenda wrote:
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


