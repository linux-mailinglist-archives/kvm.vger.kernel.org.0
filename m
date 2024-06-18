Return-Path: <kvm+bounces-19884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BAD0D90DB40
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 20:04:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75F32282FAC
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 18:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CACA14D435;
	Tue, 18 Jun 2024 18:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="T/1Nj2pS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C67D13C8E5;
	Tue, 18 Jun 2024 18:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718733881; cv=none; b=QhxqY/eDv8EFsanrBmldcD3/rvH0PvfANCVKIygXPZJ/FLRDF12j3k3jfJi935zS7hRJwPI2ysK3+sQGxcO8rpVqJ7B+l8eATPAUcyuv0pkDobkJZaY+dDBwrdjgyjlc/BgeteV+RsoT3Cbf34jF9TTqs+uB4DAm6Z/VQX5bzvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718733881; c=relaxed/simple;
	bh=6DtmDRdJJAKZ7z/5L3K6xC8B1EsWEZGDn9BRDODin3A=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Yjh/EyrorsCyOMSamRzfbVd2Hc4KxnkavTFaSDPQV1f13YP1q+47uwdTbXEHjRNvwtW+cKMsR+/kjoUWwzpEGAfO4+09mqCqBVLj+8ja3qCaKCEaHqPHIaCEgmbU3NB7v0lZZFjqMl8VHrvNCEbDVXZcYepNefpGAUmTvu0fSrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=T/1Nj2pS; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45IHwf29005552;
	Tue, 18 Jun 2024 18:04:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:subject:from:to:cc:date:in-reply-to:references
	:content-type:content-transfer-encoding:mime-version; s=pp1; bh=
	qMxKKiK4D97uKRPteZPJ9ZrNdcxX0wgRivB63XFzTDc=; b=T/1Nj2pSnH1vKIRD
	2344/ZyJxb0QjYyQDyD4uxvQP8mHvDYyvoVRgj1QjnJXZHxhAQtKEd2fwwO4hsYB
	+aHT/9oMRhgfNIPlSmKziJQdP6aMpiL26XZ6zidnrVYaGsq5lLwcxDuMztvgqQWA
	rl70Ag64krRiuxFcClvXlgCDLU7mvo84TTHoG+5Jcch3p/9dWr02rgemqqFrGQPc
	qgNT5DOxNcmMIrHRsw5Wqm1lYXtNKwKG+W9AZyA+sD9ylYjMZhm8rdekzEkSd2Zj
	RO4V2v6ouPq00qEpfCGhiINb7vnfRSSqqrbox/hdvXABNYro169hXfukZ4fhTJoM
	n3pzQA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yuf3tg0b8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Jun 2024 18:04:34 +0000 (GMT)
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45II4XOv014012;
	Tue, 18 Jun 2024 18:04:33 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yuf3tg0b5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Jun 2024 18:04:33 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45II0off006226;
	Tue, 18 Jun 2024 18:04:32 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ysn9unyd8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Jun 2024 18:04:32 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45II4RFM48235006
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Jun 2024 18:04:29 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 02E7220067;
	Tue, 18 Jun 2024 18:04:27 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6660C20065;
	Tue, 18 Jun 2024 18:04:26 +0000 (GMT)
Received: from [9.171.6.168] (unknown [9.171.6.168])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 18 Jun 2024 18:04:26 +0000 (GMT)
Message-ID: <162e40498e962258e965661b7ad8457e2e97ecdf.camel@linux.ibm.com>
Subject: Re: [PATCH v5 3/3] vfio/pci: Fix typo in macro to declare accessors
From: Gerd Bayer <gbayer@linux.ibm.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Niklas Schnelle
 <schnelle@linux.ibm.com>,
        Ramesh Thomas <ramesh.thomas@intel.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Ankit Agrawal
 <ankita@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>, Halil Pasic
 <pasic@linux.ibm.com>,
        Ben Segal <bpsegal@us.ibm.com>, "Tian, Kevin"
 <kevin.tian@intel.com>,
        Julian Ruess <julianr@linux.ibm.com>
Date: Tue, 18 Jun 2024 20:04:26 +0200
In-Reply-To: <20240618112020.3e348767.alex.williamson@redhat.com>
References: <20240605160112.925957-1-gbayer@linux.ibm.com>
	 <20240605160112.925957-4-gbayer@linux.ibm.com>
	 <20240618112020.3e348767.alex.williamson@redhat.com>
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
X-Proofpoint-GUID: 816-ZCxtuN947kSqu0VSBLjCBzJMbgUO
X-Proofpoint-ORIG-GUID: KGu-WaRAEZzW0Bvp22JeF8-GJLtcN5FN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-18_02,2024-06-17_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 suspectscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406180132

On Tue, 2024-06-18 at 11:20 -0600, Alex Williamson wrote:
> On Wed,=C2=A0 5 Jun 2024 18:01:12 +0200
> Gerd Bayer <gbayer@linux.ibm.com> wrote:
>=20
> > Correct spelling of DECLA[RA]TION
>=20
> But why did we also transfer the semicolon from the body of the macro
> to the call site?=C2=A0 This doesn't match how we handle macros for
> VFIO_IOWRITE, VFIO_IOREAD, or the new VFIO_IORDWR added in this
> series.
> Thanks,
>=20
> Alex

Hi Alex,

I wanted to make it visible, already in the contracted form, that
VFIO_IO{READ|WRITE}_DECLARATION is in fact expanding to a function
prototype declaration, while the marco defines in
drivers/vfio/pci/vfio_pci_core.c expand to function implementations.

My quick searching for in-tree precedence was pretty inconclusive
though. So, I can revert that if you want.

Thank you,
Gerd


> > Suggested-by: Ramesh Thomas <ramesh.thomas@intel.com>
> > Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
> > ---
> > =C2=A0include/linux/vfio_pci_core.h | 24 ++++++++++++------------
> > =C2=A01 file changed, 12 insertions(+), 12 deletions(-)
> >=20
> > diff --git a/include/linux/vfio_pci_core.h
> > b/include/linux/vfio_pci_core.h
> > index f4cf5fd2350c..fa59d40573f1 100644
> > --- a/include/linux/vfio_pci_core.h
> > +++ b/include/linux/vfio_pci_core.h
> > @@ -139,26 +139,26 @@ bool
> > vfio_pci_core_range_intersect_range(loff_t buf_start, size_t
> > buf_cnt,
> > =C2=A0					 loff_t *buf_offset,
> > =C2=A0					 size_t *intersect_count,
> > =C2=A0					 size_t *register_offset);
> > -#define VFIO_IOWRITE_DECLATION(size) \
> > +#define VFIO_IOWRITE_DECLARATION(size) \
> > =C2=A0int vfio_pci_core_iowrite##size(struct vfio_pci_core_device
> > *vdev,	\
> > -			bool test_mem, u##size val, void __iomem
> > *io);
> > +			bool test_mem, u##size val, void __iomem
> > *io)
> > =C2=A0
> > -VFIO_IOWRITE_DECLATION(8)
> > -VFIO_IOWRITE_DECLATION(16)
> > -VFIO_IOWRITE_DECLATION(32)
> > +VFIO_IOWRITE_DECLARATION(8);
> > +VFIO_IOWRITE_DECLARATION(16);
> > +VFIO_IOWRITE_DECLARATION(32);
> > =C2=A0#ifdef iowrite64
> > -VFIO_IOWRITE_DECLATION(64)
> > +VFIO_IOWRITE_DECLARATION(64);
> > =C2=A0#endif
> > =C2=A0
> > -#define VFIO_IOREAD_DECLATION(size) \
> > +#define VFIO_IOREAD_DECLARATION(size) \
> > =C2=A0int vfio_pci_core_ioread##size(struct vfio_pci_core_device
> > *vdev,	\
> > -			bool test_mem, u##size *val, void __iomem
> > *io);
> > +			bool test_mem, u##size *val, void __iomem
> > *io)
> > =C2=A0
> > -VFIO_IOREAD_DECLATION(8)
> > -VFIO_IOREAD_DECLATION(16)
> > -VFIO_IOREAD_DECLATION(32)
> > +VFIO_IOREAD_DECLARATION(8);
> > +VFIO_IOREAD_DECLARATION(16);
> > +VFIO_IOREAD_DECLARATION(32);
> > =C2=A0#ifdef ioread64
> > -VFIO_IOREAD_DECLATION(64)
> > +VFIO_IOREAD_DECLARATION(64);
> > =C2=A0#endif
> > =C2=A0
> > =C2=A0#endif /* VFIO_PCI_CORE_H */
>=20
>=20


