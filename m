Return-Path: <kvm+bounces-17843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 305C38CB1C8
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 17:56:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA7BF280DB7
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 15:56:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 387E1147C9F;
	Tue, 21 May 2024 15:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kUNw1y+Z"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C030514291B;
	Tue, 21 May 2024 15:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716306949; cv=none; b=bRBIbZfnOoDMToMDMr6pUx9HmdAdgF/615KoWwAtmXXFPnU+v6tYRbNGL3Rnwju2kMDrzJFdZSzl/p6UiMV5QRbIeORn1dlaXQwc8wrZSKWZUYuNwkaL2tmzW+A6hzVflkCMHMwkk2QqRI+/m46m7LX15i13dRTXjmT5Ampwmoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716306949; c=relaxed/simple;
	bh=OUaWvetlbb5hIpc7GJrZ758EDNG8qb3Vdsoap3ZpPS4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cwEQTtq0RQnx2HlQreNt0ZydGsLmIdnrkSLwY3uwLRjs5GcMwWapGhIKMohpsHoW3ACqsI6n4f9+7F/E8zkS26K8v6ADV43mFuQ02GWdUdY7sDBoMCcRCd5y9AlHT2QiYUw0hA/aUgJgUcq19wYN207c6ZwcQzkfuNyfqh41lLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kUNw1y+Z; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44LFiBYk005760;
	Tue, 21 May 2024 15:55:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=lu3zYKW5oD150FP/gEbglG/yRWXtdiKEiJujEyAiIjw=;
 b=kUNw1y+ZVwwEU67RP49jhhS8hevjreE9COCtfaq2iG8fcnb6tdv+THOdL24DW/7r8ax1
 OqBCybR4/MkXY5y+6uSaZrozGGsY02gfNFO7zVpWuZrnYfjhni4yt0wUsMTvv+X4aemZ
 2Q024+8Yk4TteWNduAPfkbBOLoshCUfT3nf1xMSFw0rEVIeVUBDt1nnEec6cR0WQNkhR
 MSAssLGvn0A49glYrZUDmMiaXB5AIa9skSyZONfTQ9v+YcITKRA6G6Gij61CltcCRqnS
 eQHFqiKnElMqNtwx62hzQVWjonXLfSriiCq43g0FWvCvJT0yABJ3RadAJJiuFRKQLZuE vg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y8xgng10p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 May 2024 15:55:44 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44LFtiGa024347;
	Tue, 21 May 2024 15:55:44 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y8xgng10m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 May 2024 15:55:44 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44LDtjAo023460;
	Tue, 21 May 2024 15:50:43 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3y77np6j39-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 May 2024 15:50:43 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44LFobKV49479962
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 May 2024 15:50:39 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9FC7C2004D;
	Tue, 21 May 2024 15:50:37 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 05CD62004E;
	Tue, 21 May 2024 15:50:37 +0000 (GMT)
Received: from [9.179.20.140] (unknown [9.179.20.140])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 21 May 2024 15:50:36 +0000 (GMT)
Message-ID: <4927d83e4db0db6baa4b4d3214ca6e866402be1f.camel@linux.ibm.com>
Subject: Re: [PATCH v3 2/3] vfio/pci: Support 8-byte PCI loads and stores
From: Gerd Bayer <gbayer@linux.ibm.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Niklas Schnelle
 <schnelle@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Julian Ruess <julianr@linux.ibm.com>, Ben Segal <bpsegal@us.ibm.com>
Date: Tue, 21 May 2024 17:50:36 +0200
In-Reply-To: <20240429103156.50793b98.alex.williamson@redhat.com>
References: <20240425165604.899447-1-gbayer@linux.ibm.com>
	 <20240425165604.899447-3-gbayer@linux.ibm.com>
	 <20240429103156.50793b98.alex.williamson@redhat.com>
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
X-Proofpoint-GUID: R9Grp085szA0YsypU9_48Qy-ZuljKffY
X-Proofpoint-ORIG-GUID: 42zpjyuxVTy2qu15Ro0CdzYjmBY5KkH3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-21_09,2024-05-21_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 clxscore=1015 bulkscore=0 impostorscore=0 spamscore=0
 mlxscore=0 phishscore=0 adultscore=0 mlxlogscore=795 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405210119

On Mon, 2024-04-29 at 10:31 -0600, Alex Williamson wrote:
> On Thu, 25 Apr 2024 18:56:03 +0200
> Gerd Bayer <gbayer@linux.ibm.com> wrote:
>=20
> > From: Ben Segal <bpsegal@us.ibm.com>
> >=20
> > Many PCI adapters can benefit or even require full 64bit read
> > and write access to their registers. In order to enable work on
> > user-space drivers for these devices add two new variations
> > vfio_pci_core_io{read|write}64 of the existing access methods
> > when the architecture supports 64-bit ioreads and iowrites.
> >=20
> > Signed-off-by: Ben Segal <bpsegal@us.ibm.com>
> > Co-developed-by: Gerd Bayer <gbayer@linux.ibm.com>
> > Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
> > ---
> > =C2=A0drivers/vfio/pci/vfio_pci_rdwr.c | 16 ++++++++++++++++
> > =C2=A0include/linux/vfio_pci_core.h=C2=A0=C2=A0=C2=A0 |=C2=A0 3 +++
> > =C2=A02 files changed, 19 insertions(+)
> >=20
> > diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c
> > b/drivers/vfio/pci/vfio_pci_rdwr.c
> > index 3335f1b868b1..8ed06edaee23 100644
> > --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> > +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> > @@ -89,6 +89,9 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_ioread##size);
> > =C2=A0VFIO_IOREAD(8)
> > =C2=A0VFIO_IOREAD(16)
> > =C2=A0VFIO_IOREAD(32)
> > +#ifdef ioread64
> > +VFIO_IOREAD(64)
> > +#endif
> > =C2=A0
> > =C2=A0#define
> > VFIO_IORDWR(size)						\
> > =C2=A0static int vfio_pci_core_iordwr##size(struct vfio_pci_core_device
> > *vdev,\
> > @@ -124,6 +127,10 @@ static int vfio_pci_core_iordwr##size(struct
> > vfio_pci_core_device *vdev,\
> > =C2=A0VFIO_IORDWR(8)
> > =C2=A0VFIO_IORDWR(16)
> > =C2=A0VFIO_IORDWR(32)
> > +#if defined(ioread64) && defined(iowrite64)
> > +VFIO_IORDWR(64)
> > +#endif
> > +
> > =C2=A0/*
> > =C2=A0 * Read or write from an __iomem region (MMIO or I/O port) with a=
n
> > excluded
> > =C2=A0 * range which is inaccessible.=C2=A0 The excluded range drops wr=
ites
> > and fills
> > @@ -148,6 +155,15 @@ ssize_t vfio_pci_core_do_io_rw(struct
> > vfio_pci_core_device *vdev, bool test_mem,
> > =C2=A0		else
> > =C2=A0			fillable =3D 0;
> > =C2=A0
> > +#if defined(ioread64) && defined(iowrite64)
>=20
> Nit, #ifdef vfio_pci_core_iordwr64

I'm sorry, but I'm not sure how I should check for the expanded symbol
here. I think I'll have to stick to checking the same condition as for
whether VFIO_IORDWR(64) should be expanded.

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
>=20
> AFAIK, the comment appended to the #endif is really only suggested
> when the code block is too long to reasonable fit in a terminal.=C2=A0
> That's no longer the case with the new helper.

Yes, I'll change that.

> Thanks,
>=20
> Alex
>=20
>=20

Thanks, Gerd

