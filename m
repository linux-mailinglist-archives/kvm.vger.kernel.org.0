Return-Path: <kvm+bounces-53990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BD199B1B415
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 15:07:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6052D18A18FA
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 13:08:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 878D327381B;
	Tue,  5 Aug 2025 13:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qEVkKDC5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6574F24886C;
	Tue,  5 Aug 2025 13:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399253; cv=none; b=VqCp5v5mbaWTl5P5WUchXK4oTNSafZ2WLshvu/qzRYszyDv7Ceiik85fKa5aTgYF6N4m0MVLp1oMHF4tCI6hGYAaKbV6TMpbV44t0xh9TXv43kAuvKur53PkmkPIDr+KGKMyYUyk3HWkdt4ayKc8Ojbx1eNDLVsVcDQeh9cZp5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399253; c=relaxed/simple;
	bh=g9lEhynWs3Kft8CeOKPMqaDwpeulVBVMQJFB+D0Cy0M=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=o0MzP5mkPB1S4Q/R4DjXScNthlT4Uz4UIjMjkPLL80fDmjDBFT7uZWm9Gw3Por/0TEV637XuKpsLd3/LMdmNCLhUCZ0sWuka23RRO/2acL6Pcwz8syBQkMoPeJ2BOMjbreFyJ2cmizJyfRWuUY3F9y0bPOP0qNh1gGuoqpWT1+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qEVkKDC5; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5758b8mx004052;
	Tue, 5 Aug 2025 13:07:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=VzV7PF
	zFIbOHkPjW4qrXM1SSsNIh/hPzq8XrRB+YyeM=; b=qEVkKDC5se9HYhraZtG2/o
	VZaOfu9zBDqekNINzCYqKBNcxO4uJOXuPYkv6o8VBRerJgaQ+unowR3Vpt5nm4Yo
	M7pd3vz4hx8q1+eO76sstMhL+x6NotnTZ/qBS8MsEIJ4EJyVg+p6Xp6m9JC515gv
	cYrQPyeZ3x4OwEr6QnttZo28E9pOrM/q4ryKz4I2401petnffevTFr1C85fbCXY5
	SEFebnPWG3sg4BO3IAS4OjbAsHx/B+YtwexAEHxsWfDzvYZ09r8iZyVmgBMAPf31
	ybVMLRGoi+S1ktGm/Q2KXEoT364lLKgJc7bN3tJG4xtzsUgrbT1NJuc4RkKpIeNw
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 489ac0xhh2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Aug 2025 13:07:29 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5759xO94001597;
	Tue, 5 Aug 2025 13:07:28 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 489y7ktanr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Aug 2025 13:07:28 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 575D7OFC20447636
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 Aug 2025 13:07:25 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DE18220040;
	Tue,  5 Aug 2025 13:07:24 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B482620043;
	Tue,  5 Aug 2025 13:07:24 +0000 (GMT)
Received: from darkmoore (unknown [9.111.40.254])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 Aug 2025 13:07:24 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 05 Aug 2025 15:07:19 +0200
Message-Id: <DBUIMK7LQF7U.22WPRO70LOFHA@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <linux-s390@vger.kernel.org>, <kvm@vger.kernel.org>, <david@redhat.com>,
        <frankja@linux.ibm.com>, <seiden@linux.ibm.com>, <nsg@linux.ibm.com>,
        <nrb@linux.ibm.com>, <hca@linux.ibm.com>, <mhartmay@linux.ibm.com>,
        <borntraeger@de.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/2] KVM: s390: Fix incorrect usage of
 mmu_notifier_register()
X-Mailer: aerc 0.20.1
References: <20250805111446.40937-1-imbrenda@linux.ibm.com>
 <20250805111446.40937-2-imbrenda@linux.ibm.com>
In-Reply-To: <20250805111446.40937-2-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oRDV_gnKbE7mZw3vqezJdXxrhp2thNv6
X-Proofpoint-ORIG-GUID: oRDV_gnKbE7mZw3vqezJdXxrhp2thNv6
X-Authority-Analysis: v=2.4 cv=GNoIEvNK c=1 sm=1 tr=0 ts=68920211 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=h5QcjqOEMrQRjDIlvBAA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA1MDA5NCBTYWx0ZWRfX684ZI69VsQ9H
 1pptpTbs9yjrlLCGJUxnv6z92JtQc4FEWwKGJXjEnyleDH7KfAmEVEvh7TtL+DV6mRRjz9hWc3P
 4Y+QEqc9LcvDq9Z8OI84U+mpMFTcKgmWzx+HL1VC3p8RFRULbHTS1jrJb4gYj8j/lA1JieNX2WS
 BKM2AsthvvEO7959oTZs5zAPrsiH81xfGOj8WchxV4YRQ5pfNMfEfarYnJiHQXOXJJJypbqwYYn
 lUfOnTwbyoYTgCDmgiL8bXOmpeM7PLfQD7oBWFhLmruAmmwlgiSDYjw3TdgnGvcpangAwxdCNkS
 op79w646B5dWkeOENgdZR7E03jq88vll1WGZh5QQjTodBRlsXQdX/k4obVr1pe2cEqEAb1PXStX
 R/sWIScR67H7fJgeaTt9Lhf61lDtQl+mWtG44IUnf8QPU7wPjoZTR7nXZhP1B/1QGLbgNXDf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-05_03,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 adultscore=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 clxscore=1011 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2508050094

On Tue Aug 5, 2025 at 1:14 PM CEST, Claudio Imbrenda wrote:
> If mmu_notifier_register() fails, for example because a signal was
> pending, the mmu_notifier will not be registered. But when the VM gets
> destroyed, it will get unregistered anyway and that will cause one
> extra mmdrop(), which will eventually cause the mm of the process to
> be freed too early, and cause a use-after free.
>
> This bug happens rarely, and only when secure guests are involved.
>
> The solution is to check the return value of mmu_notifier_register()
> and return it to the caller (ultimately it will be propagated all the
> way to userspace). In case of -EINTR, userspace will try again.
>
> Fixes: ca2fd0609b5d ("KVM: s390: pv: add mmu_notifier")
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

> ---
>  arch/s390/kvm/pv.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index 14c330ec8ceb..e85fb3247b0e 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -622,6 +622,15 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u1=
6 *rrc)
>  	int cc, ret;
>  	u16 dummy;
> =20
> +	/* Add the notifier only once. No races because we hold kvm->lock */
> +	if (kvm->arch.pv.mmu_notifier.ops !=3D &kvm_s390_pv_mmu_notifier_ops) {
> +		ret =3D mmu_notifier_register(&kvm->arch.pv.mmu_notifier, kvm->mm);
> +		if (ret)
> +			return ret;
> +		/* The notifier will be unregistered when the VM is destroyed */
> +		kvm->arch.pv.mmu_notifier.ops =3D &kvm_s390_pv_mmu_notifier_ops;
> +	}
> +
>  	ret =3D kvm_s390_pv_alloc_vm(kvm);
>  	if (ret)
>  		return ret;
> @@ -657,11 +666,6 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u1=
6 *rrc)
>  		return -EIO;
>  	}
>  	kvm->arch.gmap->guest_handle =3D uvcb.guest_handle;
> -	/* Add the notifier only once. No races because we hold kvm->lock */
> -	if (kvm->arch.pv.mmu_notifier.ops !=3D &kvm_s390_pv_mmu_notifier_ops) {
> -		kvm->arch.pv.mmu_notifier.ops =3D &kvm_s390_pv_mmu_notifier_ops;
> -		mmu_notifier_register(&kvm->arch.pv.mmu_notifier, kvm->mm);
> -	}
>  	return 0;
>  }
> =20


