Return-Path: <kvm+bounces-18056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABEF18CD6C1
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 17:10:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58073280EF6
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 15:10:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BEEED304;
	Thu, 23 May 2024 15:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BdsfBvpW"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB339B658;
	Thu, 23 May 2024 15:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716477033; cv=none; b=tV/CjJpjlBoTWE+pX0ou+UD2D+FdKIJdv6s6dlISv1M59H3kvibUWEKLGtbwxeN3rhBU4/Y9yTcTn8gIWO8vM7Jdb9KM8WazOyQsXfA9lIxTNLV4MVQYf1LbDb/TJcurDULuNQt6GITcPhCFNZ8sTRhIhbfvvspfYwMOsaUstqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716477033; c=relaxed/simple;
	bh=fq8dhUNMIf8vlfh+f6R2hq7BoAjqATtZsQpyQb5Zefc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Tyw5YuqRPEbyp69tyzj5671AXgQII48Lygykdsy1BeyL9ZYIdQ+xlkbobsfU3HT0HTbypuzgb988RbouREOeHu4vsFZkUifd/k1qYBbzIY6GeAKAxG+k+GANtze68llQUnaEHzH6ajA82pMc7t6aVDFUQxqoAvlInKgtojBuOus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BdsfBvpW; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44NF9f3w005118;
	Thu, 23 May 2024 15:10:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=borMt6WSxqGfNZttPq2bKyDDfRAZRPYShSv7zYm50q0=;
 b=BdsfBvpW73cLCNxYP4t2zSV7EONmoTLSkGljL7+MHYyB7KpNZMyyqfltghR8DDSUFk7R
 5ZV+/pjpjTN7n1TLZemUcOuy5uhkXq0YazgTwJCmCv9DZkeRsreK624px/D/D8X01RWW
 OfTjMLWvxZ12tDDgn16XnLURM/sGOyJEa/lpAYuChydwHTe33K7EekL+xCKQFYwUzfDi
 AXeVNIOPkwLGMmv4wssxe/offmBwlua4/hfGh+H31GBUHUZQPidErvRnAdCs1YUM79FE
 zCzRfl91BPZ4m8A8LlMimMkXy9l03XjgRu0N0cBRdXQBWiEX6AD1hani6ss0o7ZET9LZ Vg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ya86q002s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 May 2024 15:10:27 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44NFARHj008097;
	Thu, 23 May 2024 15:10:27 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ya86q002p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 May 2024 15:10:27 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44NEmTgw026474;
	Thu, 23 May 2024 15:10:26 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3y785mtkc9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 May 2024 15:10:26 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44NFAKMb46858552
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 May 2024 15:10:22 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 567952005A;
	Thu, 23 May 2024 15:10:20 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1C4482004B;
	Thu, 23 May 2024 15:10:20 +0000 (GMT)
Received: from [9.152.224.39] (unknown [9.152.224.39])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 May 2024 15:10:20 +0000 (GMT)
Message-ID: <7f3479f25842b443245c0f447e5ca3ecd950b0d5.camel@linux.ibm.com>
Subject: Re: [PATCH v4 2/3] vfio/pci: Support 8-byte PCI loads and stores
From: Gerd Bayer <gbayer@linux.ibm.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe
 <jgg@ziepe.ca>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Ramesh Thomas
 <ramesh.thomas@intel.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Ankit Agrawal
	 <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
        Halil Pasic
	 <pasic@linux.ibm.com>,
        Julian Ruess <julianr@linux.ibm.com>, Ben Segal
	 <bpsegal@us.ibm.com>
Date: Thu, 23 May 2024 17:10:16 +0200
In-Reply-To: <20240522150651.1999584-3-gbayer@linux.ibm.com>
References: <20240522150651.1999584-1-gbayer@linux.ibm.com>
	 <20240522150651.1999584-3-gbayer@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.1 (3.52.1-1.fc40app1) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: S1bqkX6Jz4K_dxWz5OgxPelXWJKHOTPb
X-Proofpoint-GUID: duJ9-ktRgMMv8R12NBUhwEaiKGCUVONj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-23_09,2024-05-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 malwarescore=0 phishscore=0 priorityscore=1501 bulkscore=0 adultscore=0
 clxscore=1015 mlxscore=0 mlxlogscore=718 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405230104

On Wed, 2024-05-22 at 17:06 +0200, Gerd Bayer wrote:
> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c
> b/drivers/vfio/pci/vfio_pci_rdwr.c
> index d07bfb0ab892..07351ea76604 100644
> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> @@ -124,6 +127,10 @@ static int vfio_pci_iordwr##size(struct
> vfio_pci_core_device *vdev,\
> =C2=A0VFIO_IORDWR(8)
> =C2=A0VFIO_IORDWR(16)
> =C2=A0VFIO_IORDWR(32)
> +#if CONFIG_64BIT

During my experimenations to reproduce Ramesh's complaint about
unresolved symbols, I found that this should have been #ifdef

> +VFIO_IORDWR(64)
> +#endif
> +
> =C2=A0/*
> =C2=A0 * Read or write from an __iomem region (MMIO or I/O port) with an
> excluded
> =C2=A0 * range which is inaccessible.=C2=A0 The excluded range drops writ=
es and
> fills
> @@ -148,6 +155,15 @@ ssize_t vfio_pci_core_do_io_rw(struct
> vfio_pci_core_device *vdev, bool test_mem,
> =C2=A0		else
> =C2=A0			fillable =3D 0;
> =C2=A0
> +#if CONFIG_64BIT

... as should this have been.

> +		if (fillable >=3D 8 && !(off % 8)) {
> +			ret =3D vfio_pci_iordwr64(vdev, iswrite,
> test_mem,
> +						io, buf, off,
> &filled);
> +			if (ret)
> +				return ret;
> +
> +		} else
> +#endif
> =C2=A0		if (fillable >=3D 4 && !(off % 4)) {
> =C2=A0			ret =3D vfio_pci_iordwr32(vdev, iswrite,
> test_mem,
> =C2=A0						io, buf, off,
> &filled);
> diff --git a/include/linux/vfio_pci_core.h
> b/include/linux/vfio_pci_core.h
> index a2c8b8bba711..5f9b02d4a3e9 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -146,7 +146,7 @@ int vfio_pci_core_iowrite##size(struct
> vfio_pci_core_device *vdev,	\
> =C2=A0VFIO_IOWRITE_DECLATION(8)
> =C2=A0VFIO_IOWRITE_DECLATION(16)
> =C2=A0VFIO_IOWRITE_DECLATION(32)
> -#ifdef iowrite64
> +#ifdef CONFIG_64BIT
> =C2=A0VFIO_IOWRITE_DECLATION(64)
> =C2=A0#endif
> =C2=A0
> @@ -157,5 +157,8 @@ int vfio_pci_core_ioread##size(struct
> vfio_pci_core_device *vdev,	\
> =C2=A0VFIO_IOREAD_DECLATION(8)
> =C2=A0VFIO_IOREAD_DECLATION(16)
> =C2=A0VFIO_IOREAD_DECLATION(32)
> +#ifdef CONFIG_64BIT
> +VFIO_IOREAD_DECLATION(64)
> +#endif
> =C2=A0
> =C2=A0#endif /* VFIO_PCI_CORE_H */

So there will be a v5.

Thanks,
Gerd

