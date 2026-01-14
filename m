Return-Path: <kvm+bounces-68009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id ECA57D1D902
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 10:34:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7687C3019BD0
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 09:33:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7541B389451;
	Wed, 14 Jan 2026 09:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OH3Y+rho"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617433557E3;
	Wed, 14 Jan 2026 09:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768383218; cv=none; b=Ub81EL8GGAgQBSJegXyRBYUUmXRlh0ZiX/hpdmaVVNk7BeeaWErof4Wb+uZBOfxBmGPlvAl90djMBJZV7tW0qSS9zyWiy1UMPQm6Eec5J+y1697n5B7GH5WvOFOg1aZuUiiLgX/nBin7XJPV3JRjkh/YLakLzVnNItDPg4642ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768383218; c=relaxed/simple;
	bh=Jyovhn7yxmYFuVvriTfpome5NbhRP9E921PTw+JVtBg=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=RiIxMYt8K/LIfDg9y0KmwfMVzDkMcASfBmriZ9VvQ7P5VVCszA8HtdBQVVNbovmJRyJkF8vg7luydSuRkpzsfuW0dttVHPxeCdnuioiKoX1LO/2tpDT1by34newNWBDKrSK5MwbyJ3LPSxtj4es1RkjzPdAgf47O374YlBTHPuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OH3Y+rho; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60E8YR7w009533;
	Wed, 14 Jan 2026 09:33:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=qM2vlz
	smLjnVZTawf17xyY7zcmp3H6gVf4xMVxjEa4w=; b=OH3Y+rhouBP0N+6boTRnew
	voRnFIwnfpcMFu3IvN+hrFi9ycHeKyb+IIcxE5v5V5Kwm87oVg0LE2DmBArzTTMr
	d9AxQHKb8sC4PIKkQNaFRSdBHEHfrrn+S0aeWttioiJgMbkZk2zspfxGc6mxbpJC
	3El/wEW4m8bghZCByR9WiAfgCeDj6Pfgj3WCPIfquU3BjmzWc4Wis8Mm2r0jYw5o
	QzuUXppPiTNoUZCk7Ok3E+2TG1ika8XYOsJS6zsKDqo5QKf3752BEbjI3H2rdE4c
	+VkWt+2/u8tENlWqCoK7LndPnY7UoKllGxauh5d/0ib/AwdeJkPXfESNdXKRU5cA
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bkeg4gm60-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 Jan 2026 09:33:32 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60E7jcY5030146;
	Wed, 14 Jan 2026 09:33:31 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4bm3ajs3jd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 Jan 2026 09:33:31 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60E9XSXk53674458
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 09:33:28 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E550120043;
	Wed, 14 Jan 2026 09:33:27 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CDF4920040;
	Wed, 14 Jan 2026 09:33:27 +0000 (GMT)
Received: from darkmoore (unknown [9.52.198.246])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 14 Jan 2026 09:33:27 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 14 Jan 2026 10:33:22 +0100
Message-Id: <DFO7J08IZ4HZ.3O6LSE6J09CD3@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <borntraeger@de.ibm.com>, <frankja@linux.ibm.com>, <nsg@linux.ibm.com>,
        <nrb@linux.ibm.com>, <seiden@linux.ibm.com>, <gra@linux.ibm.com>,
        <schlameuss@linux.ibm.com>, <hca@linux.ibm.com>, <svens@linux.ibm.com>,
        <agordeev@linux.ibm.com>, <gor@linux.ibm.com>, <david@redhat.com>,
        <gerald.schaefer@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 28/28] KVM: s390: Storage key manipulation IOCTL
X-Mailer: aerc 0.21.0
References: <20251222165033.162329-1-imbrenda@linux.ibm.com>
 <20251222165033.162329-29-imbrenda@linux.ibm.com>
In-Reply-To: <20251222165033.162329-29-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDA3MCBTYWx0ZWRfX+SP4IZ1X6BdT
 iP+muSFSxeU5vL+v86JhPbk98MCGFCA1dC6gPWEOHY6OkOmYEox3TVxDP4fkuaYEULhzvKipqeh
 XKookPVNIpaM3LN4gX+1SeGZ+0BXW56n7mxnznSIAIXQ1jaAi9iWctgim8aoUjopjjTaGStONBM
 g03Bn21PrFzR42gTHC2TI5ZrAVQ/YLLn1D/MzBdujt3VYT6OZ8Mu7MJStHCzc7E3OLuWq7Yb5Cc
 2rPWdMPb6x7KlaSpfJJRbJzobA/mhiruJ2uUejgElCgj+P96i4SDObFp32Jevqwx/eW+QLFnpya
 cP82k+cauUxRS47ECtuuhRhCl6SfGgodmALb3cQ9S1eG6jdNyo4d8mkP0b1KKvQo8BopOSGoeJP
 I3zRnaSE4Gu3FqIPTZnsAek0hrGQXBS9kg7PPVtQ4eEfRU7yPTM4ZlmbjB6Irn/NzH89OdmwUTV
 Ifq+CShpljYlBR1gr5w==
X-Proofpoint-ORIG-GUID: IL4fVZOSfDiMgkpCafyo9AbXxoKu2K-k
X-Authority-Analysis: v=2.4 cv=B/60EetM c=1 sm=1 tr=0 ts=696762ec cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=nq-VQYysc4rh_9LpSKcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: IL4fVZOSfDiMgkpCafyo9AbXxoKu2K-k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_02,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 bulkscore=0 spamscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601140070

On Mon Dec 22, 2025 at 5:50 PM CET, Claudio Imbrenda wrote:
> Add a new IOCTL to allow userspace to manipulate storage keys directly.
>
> This will make it easier to write selftests related to storage keys.
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Please add some user documentation for the new IOCTL.

[...]

> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index dddb781b0507..845417e56778 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1219,6 +1219,15 @@ struct kvm_vfio_spapr_tce {
>  	__s32	tablefd;
>  };
> =20
> +#define KVM_S390_KEYOP_SSKE 0x01
> +#define KVM_S390_KEYOP_ISKE 0x02
> +#define KVM_S390_KEYOP_RRBE 0x03

Just a nitpik, but why this order? In the arch the order is ISKE, SSKE, RRB=
E.
Would it not be more logical to keep that order?

> +struct kvm_s390_keyop {
> +	__u64 user_addr;
> +	__u8  key;
> +	__u8  operation;
> +};
> +
>  /*
>   * KVM_CREATE_VCPU receives as a parameter the vcpu slot, and returns
>   * a vcpu fd.
> @@ -1238,6 +1247,7 @@ struct kvm_vfio_spapr_tce {
>  #define KVM_S390_UCAS_MAP        _IOW(KVMIO, 0x50, struct kvm_s390_ucas_=
mapping)
>  #define KVM_S390_UCAS_UNMAP      _IOW(KVMIO, 0x51, struct kvm_s390_ucas_=
mapping)
>  #define KVM_S390_VCPU_FAULT	 _IOW(KVMIO, 0x52, unsigned long)
> +#define KVM_S390_KEYOP           _IOWR(KVMIO, 0x53, struct kvm_s390_keyo=
p)
> =20
>  /* Device model IOC */
>  #define KVM_CREATE_IRQCHIP        _IO(KVMIO,   0x60)


