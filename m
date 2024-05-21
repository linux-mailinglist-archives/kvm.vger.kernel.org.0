Return-Path: <kvm+bounces-17851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 97C928CB256
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 18:40:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 123EE1F22A0C
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 16:40:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E993B14430B;
	Tue, 21 May 2024 16:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pdNw1mWX"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C94143C58;
	Tue, 21 May 2024 16:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716309627; cv=none; b=fbcOOUT8DqeHEjjEKIWsvYDTfUyIs4YNxSESVyJZvHH+DiqsmDoQx+TTMJzTJ4/QuM7yOCk9ToyzeovCweGjT7iyqhBk9QfVhdiuKLjIt7k4hINKRXFlF0kF0wvOxQlEnJr+nsFWcdXCvj/8t3x/xZ1KSbxuPkg5ESWP3/tOyNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716309627; c=relaxed/simple;
	bh=mk4nsDZY8ZZYEOJuEr5g7Z+d911qpUYeHzggyjwUWaU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dHmC/Jd8iRPr7xM5quYuiBZqhlimuDFiJ00nK+knjXt6KMgjEZTez+WkGexQCwNUlWodpxzrUZow7n9bDECWFC3CDcAOHrrLoUpqnmoaEEXyL/MFU31VqqHjTxDTqsTKILOygH/42zJw/Ixgn2FjXbclPAalNaMjTxureGy7YXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pdNw1mWX; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44LFi4kh005285;
	Tue, 21 May 2024 16:40:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=fSo5Vs3veXKCI+EFSvasmdyGy3tRTKxSGux7dqnL5eA=;
 b=pdNw1mWXG5jYl3WSXQMMA4ikrxnzfP8DW5GTvobWep/ZZXVZ3M9I0L+Nb/BVX6Ow2lWW
 1lEJTeos80T6efdPNZtYXf0QHqhsJ5H18kPU9pSbyMgDO9+/ddk2v+6js1Q0jCTxHVuS
 cED2fX+QZhLBxmFGjckWkH3Fon5Mvc7pGvKnnlNH62Hxuq1QsSucTHrPXZZt3xDDLteA
 LfTUla/gNufDqgLu4TArj7a2SnqcZCOB0VH2HUGDSjAAk43apRH4GDq7NjOmjA6f06/T
 7YCp6MY1YSKI0cX/7xDc39FvhLzWr7HAZqvVPuuycfMKQZbPEswgiukrUl1aAZcOWYg0 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y8xgng52w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 May 2024 16:40:21 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44LGeKcO032546;
	Tue, 21 May 2024 16:40:20 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y8xgng52t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 May 2024 16:40:20 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44LDdwCQ000878;
	Tue, 21 May 2024 16:40:20 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3y77206xfe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 May 2024 16:40:19 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44LGeEfF19071264
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 May 2024 16:40:16 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F0BA620071;
	Tue, 21 May 2024 16:40:13 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 80F6520043;
	Tue, 21 May 2024 16:40:13 +0000 (GMT)
Received: from [9.179.20.140] (unknown [9.179.20.140])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 21 May 2024 16:40:13 +0000 (GMT)
Message-ID: <72da2e56f6e71be4f485245688c8b935d9c3fa18.camel@linux.ibm.com>
Subject: Re: [PATCH v3 2/3] vfio/pci: Support 8-byte PCI loads and stores
From: Gerd Bayer <gbayer@linux.ibm.com>
To: Ramesh Thomas <ramesh.thomas@intel.com>,
        Alex Williamson
 <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Niklas
 Schnelle <schnelle@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Ankit Agrawal
	 <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
        Halil Pasic
	 <pasic@linux.ibm.com>,
        Julian Ruess <julianr@linux.ibm.com>, Ben Segal
	 <bpsegal@us.ibm.com>
Date: Tue, 21 May 2024 18:40:13 +0200
In-Reply-To: <d29a8b0d-37e6-4d87-9993-f195a5b7666c@intel.com>
References: <20240425165604.899447-1-gbayer@linux.ibm.com>
	 <20240425165604.899447-3-gbayer@linux.ibm.com>
	 <d29a8b0d-37e6-4d87-9993-f195a5b7666c@intel.com>
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
X-Proofpoint-GUID: xSfOT7YKKs6I8852yOrQ1awNbS3oRR1I
X-Proofpoint-ORIG-GUID: e1p3UByPIdh7FCyiMNVxVfxabyQxBINA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-21_10,2024-05-21_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 clxscore=1011 bulkscore=0 impostorscore=0 spamscore=0
 mlxscore=0 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405210126

On Fri, 2024-05-17 at 03:29 -0700, Ramesh Thomas wrote:
> On 4/25/2024 9:56 AM, Gerd Bayer wrote:
> > From: Ben Segal <bpsegal@us.ibm.com>
> >=20
> > Many PCI adapters can benefit or even require full 64bit read
> > and write access to their registers. In order to enable work on
> > user-space drivers for these devices add two new variations
> > vfio_pci_core_io{read|write}64 of the existing access methods
> > when the architecture supports 64-bit ioreads and iowrites.
>=20
> This is indeed necessary as back to back 32 bit may not be optimal in
> some devices.
>=20
> >=20
> > Signed-off-by: Ben Segal <bpsegal@us.ibm.com>
> > Co-developed-by: Gerd Bayer <gbayer@linux.ibm.com>
> > Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
> > ---
> > =C2=A0 drivers/vfio/pci/vfio_pci_rdwr.c | 16 ++++++++++++++++
> > =C2=A0 include/linux/vfio_pci_core.h=C2=A0=C2=A0=C2=A0 |=C2=A0 3 +++
> > =C2=A0 2 files changed, 19 insertions(+)
> >=20
> > diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c
> > b/drivers/vfio/pci/vfio_pci_rdwr.c
> > index 3335f1b868b1..8ed06edaee23 100644
> > --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> > +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> > @@ -89,6 +89,9 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_ioread##size);
> > =C2=A0 VFIO_IOREAD(8)
> > =C2=A0 VFIO_IOREAD(16)
> > =C2=A0 VFIO_IOREAD(32)
> > +#ifdef ioread64
> > +VFIO_IOREAD(64)
> > +#endif
> > =C2=A0=20
> > =C2=A0 #define
> > VFIO_IORDWR(size)						\
> > =C2=A0 static int vfio_pci_core_iordwr##size(struct vfio_pci_core_devic=
e
> > *vdev,\
> > @@ -124,6 +127,10 @@ static int vfio_pci_core_iordwr##size(struct
> > vfio_pci_core_device *vdev,\
> > =C2=A0 VFIO_IORDWR(8)
> > =C2=A0 VFIO_IORDWR(16)
> > =C2=A0 VFIO_IORDWR(32)
> > +#if defined(ioread64) && defined(iowrite64)
> > +VFIO_IORDWR(64)
> > +#endif
> > +
> > =C2=A0 /*
> > =C2=A0=C2=A0 * Read or write from an __iomem region (MMIO or I/O port) =
with
> > an excluded
> > =C2=A0=C2=A0 * range which is inaccessible.=C2=A0 The excluded range dr=
ops writes
> > and fills
> > @@ -148,6 +155,15 @@ ssize_t vfio_pci_core_do_io_rw(struct
> > vfio_pci_core_device *vdev, bool test_mem,
> > =C2=A0=C2=A0		else
> > =C2=A0=C2=A0			fillable =3D 0;
> > =C2=A0=20
> > +#if defined(ioread64) && defined(iowrite64)
>=20
> Can we check for #ifdef CONFIG_64BIT instead? In x86, ioread64 and=20
> iowrite64 get declared as extern functions if CONFIG_GENERIC_IOMAP is
> defined and this check always fails. In include/asm-generic/io.h,=20
> asm-generic/iomap.h gets included which declares them as extern
> functions.

I thinks that should be possible - since ioread64/iowrite64 depend on
CONFIG_64BIT themselves.

> One more thing to consider io-64-nonatomic-hi-lo.h and=20
> io-64-nonatomic-lo-hi.h, if included would define it as a macro that=20
> calls a function that rw 32 bits back to back.

Even today, vfio_pci_core_do_io_rw() makes no guarantees to its users
that register accesses will be done in the granularity they've thought
to use. The vfs layer may coalesce the accesses and this code will then
read/write the largest naturally aligned chunks. I've witnessed in my
testing that one device driver was doing 8-byte writes through the 8-
byte capable vfio layer all of a sudden when run in a KVM guest.

So higher-level code needs to consider how to split register accesses
appropriately to get the intended side-effects. Thus, I'd rather stay
away from splitting 64bit accesses into two 32bit accesses - and decide
if high or low order values should be written first.


> > +		if (fillable >=3D 8 && !(off % 8)) {
> > +			ret =3D vfio_pci_core_iordwr64(vdev,
> > iswrite, test_mem,
> > +						=C2=A0=C2=A0=C2=A0=C2=A0 io, buf, off,
> > &filled);
> > +			if (ret)
> > +				return ret;
> > +
> > +		} else
> > +#endif /* defined(ioread64) && defined(iowrite64) */
> > =C2=A0=C2=A0		if (fillable >=3D 4 && !(off % 4)) {
> > =C2=A0=C2=A0			ret =3D vfio_pci_core_iordwr32(vdev,
> > iswrite, test_mem,
> > =C2=A0=C2=A0						=C2=A0=C2=A0=C2=A0=C2=A0 io, buf, off,
> > &filled);
> > diff --git a/include/linux/vfio_pci_core.h
> > b/include/linux/vfio_pci_core.h
> > index a2c8b8bba711..f4cf5fd2350c 100644
> > --- a/include/linux/vfio_pci_core.h
> > +++ b/include/linux/vfio_pci_core.h
> > @@ -157,5 +157,8 @@ int vfio_pci_core_ioread##size(struct
> > vfio_pci_core_device *vdev,	\
> > =C2=A0 VFIO_IOREAD_DECLATION(8)
> > =C2=A0 VFIO_IOREAD_DECLATION(16)
> > =C2=A0 VFIO_IOREAD_DECLATION(32)
> > +#ifdef ioread64
> > +VFIO_IOREAD_DECLATION(64)
> nit: This macro is referenced only in this file. Can the typo be=20
> corrected (_DECLARATION)?

Sure thanks for pointing this out!
I'll single this editorial change out into a separate patch of the
series, though.

>=20
> > +#endif
> > =C2=A0=20
> > =C2=A0 #endif /* VFIO_PCI_CORE_H */
>=20
>=20

Thanks, Gerd

