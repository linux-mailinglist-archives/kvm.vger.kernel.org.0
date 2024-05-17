Return-Path: <kvm+bounces-17606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 584F78C8805
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 16:25:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF7C21F2772E
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 14:25:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA0216996A;
	Fri, 17 May 2024 14:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Sdxyf3Yj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680CB69953;
	Fri, 17 May 2024 14:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715955781; cv=none; b=vBZsm+rd9M/UawG8jyKGyP1vr3CqsNeoHl5A6FKOYpMS4zaHgdLvOXSx4k44/d3+XILTCH3mvXawPBdChwf87BChdCOHKvDtNnZN5tkwdiDJmwZvQAR4/q9tFh4lbcvw7mEOtQitN3S6kJQEi2VVxw+pa1zDRD2SRxlaJqjVjaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715955781; c=relaxed/simple;
	bh=fH/KGkrc0dsj1Vc/YGO1Yt2Wo/M3TlIEocpfptJRk7A=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YGdqRTTsxvsU1pz2zXneJizKCS5nLm1cHcOMtNqEpndT35EKcPR39BP+j2eWzYKXiEuVTahXVmzLAMw6EOjb05KpFQpTDEyZNPu4xeS3/sa6MiTLS3lZKbbDC7kDidqwdsGlejEX1/Z66Ccd+FZHyjaP/JZYd/VoyIytmB8pAAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Sdxyf3Yj; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44HEM3eq013533;
	Fri, 17 May 2024 14:22:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=pbAD1NXnuhtQkUJcIlTRhLmz857Ne9f4FiwSCrzhGVw=;
 b=Sdxyf3Yjzmg2113szy/9IkU+38WRqpv4XctoJJgi41w9ImPZL0mzMLKWSRANnvp+A3j9
 tB0VuX/lcmgZGgqMfg+tYK7p3M+rqc0ErS0djehfdkPxq7pzpwIhDd9Kupn/YjRX2L2W
 7UAm/2dhUca/FAhzteHfgHLfZI6C0JW2zAgwVZ4bybaYGyj9eWSmZFl1c14Opaq0a83H
 k+h6KYivkXGhKAc91a6nqZ5J412mX2jHDAfZCqMZVZbVJkkafv3ol5yHxSsn558DOJoY
 NCk2c6bs44Drp4Pz1ht6lV3Ob4PC3s57CgOD8thWex1SxsrCeFAL40d5JRLybKAlOYrF 6g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y68xe003u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 May 2024 14:22:56 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44HEMuLc015909;
	Fri, 17 May 2024 14:22:56 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y68xe003n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 May 2024 14:22:56 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44HBg3iV005985;
	Fri, 17 May 2024 14:22:55 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3y2mgn0fmp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 May 2024 14:22:55 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44HEMn9Q50856416
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 May 2024 14:22:51 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 34B962004D;
	Fri, 17 May 2024 14:22:49 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A468720043;
	Fri, 17 May 2024 14:22:48 +0000 (GMT)
Received: from [9.171.10.151] (unknown [9.171.10.151])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 May 2024 14:22:48 +0000 (GMT)
Message-ID: <9e5fe06293c3fc1f4d7b22be9f18a80127569417.camel@linux.ibm.com>
Subject: Re: [PATCH v3 1/3] vfio/pci: Extract duplicated code into macro
From: Gerd Bayer <gbayer@linux.ibm.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Niklas Schnelle
 <schnelle@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Julian Ruess <julianr@linux.ibm.com>
Date: Fri, 17 May 2024 16:22:43 +0200
In-Reply-To: <20240429103135.56682371.alex.williamson@redhat.com>
References: <20240425165604.899447-1-gbayer@linux.ibm.com>
	 <20240425165604.899447-2-gbayer@linux.ibm.com>
	 <20240429103135.56682371.alex.williamson@redhat.com>
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
X-Proofpoint-GUID: qNrpjOjvItwvOiyeh_mMpL3iim4OVFMT
X-Proofpoint-ORIG-GUID: veh02OpFISLlq1gEsLYmjYa5EyrhQH0n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-17_05,2024-05-17_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 impostorscore=0 adultscore=0 clxscore=1011 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405170114

On Mon, 2024-04-29 at 10:31 -0600, Alex Williamson wrote:
> On Thu, 25 Apr 2024 18:56:02 +0200
> Gerd Bayer <gbayer@linux.ibm.com> wrote:
>=20
> > vfio_pci_core_do_io_rw() repeats the same code for multiple access
> > widths. Factor this out into a macro
> >=20
> > Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> > Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
> > ---
> > =C2=A0drivers/vfio/pci/vfio_pci_rdwr.c | 106 ++++++++++++++------------=
-
> > ----
> > =C2=A01 file changed, 46 insertions(+), 60 deletions(-)
> >=20
> > diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c
> > b/drivers/vfio/pci/vfio_pci_rdwr.c
> > index 03b8f7ada1ac..3335f1b868b1 100644
> > --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> > +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> > @@ -90,6 +90,40 @@ VFIO_IOREAD(8)
> > =C2=A0VFIO_IOREAD(16)
> > =C2=A0VFIO_IOREAD(32)
> > =C2=A0
> > +#define
> > VFIO_IORDWR(size)						\
> > +static int vfio_pci_core_iordwr##size(struct vfio_pci_core_device
> > *vdev,\
> > +				bool iswrite, bool
> > test_mem,		\
> > +				void __iomem *io, char __user
> > *buf,	\
> > +				loff_t off, size_t
> > *filled)		\
>=20
> I realized later after proposing this that we should drop 'core' from
> the name since the resulting functions are not currently exported.=C2=A0
> It also helps with the wordiness.=C2=A0 Thanks,
>=20
> Alex
>=20
>=20
Sure that's easy enough.

Thanks, Gerd

