Return-Path: <kvm+bounces-19931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 743FB90E500
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 09:58:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F215A2846AA
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 07:58:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F0977711E;
	Wed, 19 Jun 2024 07:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XtKed89K"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD017182DB;
	Wed, 19 Jun 2024 07:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718783901; cv=none; b=EB/XzYSZaemdJXoDEnG2ZeAM422208g/Jo3xyxNzF0pav8px9rjNbTwBtyx3svaWkhGeF/cTnZpKeqwoHOhrFUuYRZajMAeZRFi444R6+NKg7i6nC9aIbBeHYwKzlPgYHqvoKcI6B7WmyuC4aZFY3VOIGflj89clqbvABo7UvaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718783901; c=relaxed/simple;
	bh=3y04PSzzJCRmY6wcoiM5IRT2MjToAqdIOI9MOjquXOU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WXhOLXgJmZLfTKVzlURIxlk5yNOpvmzLMWfWLL6GcAjkDF2XNcemKhghFNaExHS0SoInkY0IIwGDZ2KazOfIgalwXWky0azpGiYNmN6U1k0nWZHilT8MslvLFrtiZfSU+v8uRz09ffg96RBja7MnDsMaLK2M3pBcUPXIf+bbL90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XtKed89K; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45J5Te2Y026885;
	Wed, 19 Jun 2024 07:58:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:subject:from:to:cc:date:in-reply-to:references
	:content-type:content-transfer-encoding:mime-version; s=pp1; bh=
	8a/SLO6aVtdJdd976EB8YiIEXy8Hf7q0hZUKLqgzT5E=; b=XtKed89K/9l2pOk/
	FDqoWgrA71Ukb7KZxykYZ3Q0eiPzBB/4+8ermLoHzflpQkfP1A0piTrtjEnDRz/j
	91CjbikWyGBUABO5gZGivGXI4/9PLGhBCvJeLW785v/qrSzBoyZVp+pErAnVqm92
	X757X9C5ue4Q9bTuzQviH0cvW8fIE05jinvQ9sbR3pmh/pOMfyMDGY2kIJrYN3lw
	+hXF9QBY+OPw/Xb0KrPOuOu1anf5KZ4HDrLSE6hvAJ4EDEfgs7kmtZLDK2cntak7
	IF4GCCdfQzdctQ2sUPxy9OTT8seuPkdsUqgq/Sur8ovCbrXykak8SGMMPjfI11TC
	13JiAQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yus7j8cge-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Jun 2024 07:58:15 +0000 (GMT)
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45J7wEtD012344;
	Wed, 19 Jun 2024 07:58:14 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yus7j8cga-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Jun 2024 07:58:14 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45J6J8ld011355;
	Wed, 19 Jun 2024 07:58:13 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yspsna6h1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Jun 2024 07:58:13 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45J7w4xj56033668
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Jun 2024 07:58:06 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BAA872006B;
	Wed, 19 Jun 2024 07:58:04 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0AB792004E;
	Wed, 19 Jun 2024 07:58:04 +0000 (GMT)
Received: from [9.171.6.168] (unknown [9.171.6.168])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 19 Jun 2024 07:58:03 +0000 (GMT)
Message-ID: <3dbae0f8f2011e2e7bf9589e95b3325217045311.camel@linux.ibm.com>
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
Date: Wed, 19 Jun 2024 09:58:03 +0200
In-Reply-To: <20240618130100.4d7a901f.alex.williamson@redhat.com>
References: <20240605160112.925957-1-gbayer@linux.ibm.com>
	 <20240605160112.925957-4-gbayer@linux.ibm.com>
	 <20240618112020.3e348767.alex.williamson@redhat.com>
	 <162e40498e962258e965661b7ad8457e2e97ecdf.camel@linux.ibm.com>
	 <20240618130100.4d7a901f.alex.williamson@redhat.com>
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
X-Proofpoint-GUID: 3VrW87-6HByZ18hz81LBJT7xgtu3gNVp
X-Proofpoint-ORIG-GUID: jBJCyPW0jVeyAWwKugJabLvUpfNSmWzt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-19_02,2024-06-17_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 mlxscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 malwarescore=0 suspectscore=0 impostorscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406190053

On Tue, 2024-06-18 at 13:01 -0600, Alex Williamson wrote:
> On Tue, 18 Jun 2024 20:04:26 +0200
> Gerd Bayer <gbayer@linux.ibm.com> wrote:
>=20
> > On Tue, 2024-06-18 at 11:20 -0600, Alex Williamson wrote:
> > > On Wed,=C2=A0 5 Jun 2024 18:01:12 +0200
> > > Gerd Bayer <gbayer@linux.ibm.com> wrote:
> > > =C2=A0=20
> > > > Correct spelling of DECLA[RA]TION=C2=A0=20
> > >=20
> > > But why did we also transfer the semicolon from the body of the
> > > macro
> > > to the call site?=C2=A0 This doesn't match how we handle macros for
> > > VFIO_IOWRITE, VFIO_IOREAD, or the new VFIO_IORDWR added in this
> > > series.
> > > Thanks,
> > >=20
> > > Alex=C2=A0=20
> >=20
> > Hi Alex,
> >=20
> > I wanted to make it visible, already in the contracted form, that
> > VFIO_IO{READ|WRITE}_DECLARATION is in fact expanding to a function
> > prototype declaration, while the marco defines in
> > drivers/vfio/pci/vfio_pci_core.c expand to function
> > implementations.
> >=20
> > My quick searching for in-tree precedence was pretty inconclusive
> > though. So, I can revert that if you want.
>=20
> Hi Gerd,

Hi Alex,

> I'd tend to keep them as is since both are declaring something, a
> prototype or a function, rather than a macro intended to be used
> inline.=C2=A0 Ideally one macro could handle both declarations now that w=
e
> sort of have symmetry but we'd currently still need a #ifdef in the
> macro which doesn't trivially work.=C2=A0 If we were to do something like
> that though, relocating the semicolon doesn't make sense.
>=20
> In any case, this proposal is stated as just a typo fix, but it's
> more.

I have no hard feelings about the place of the semicolon - I'll be
sending out a v6 with just the typo fix in patch 3/3.

> Thanks,
>=20
> Alex

Thanks,
Gerd

>=20
> > > > Suggested-by: Ramesh Thomas <ramesh.thomas@intel.com>
> > > > Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
> > > > ---
> > > > =C2=A0include/linux/vfio_pci_core.h | 24 ++++++++++++------------
> > > > =C2=A01 file changed, 12 insertions(+), 12 deletions(-)
> > > >=20
> > > > diff --git a/include/linux/vfio_pci_core.h
> > > > b/include/linux/vfio_pci_core.h
> > > > index f4cf5fd2350c..fa59d40573f1 100644
> > > > --- a/include/linux/vfio_pci_core.h
> > > > +++ b/include/linux/vfio_pci_core.h
> > > > @@ -139,26 +139,26 @@ bool
> > > > vfio_pci_core_range_intersect_range(loff_t buf_start, size_t
> > > > buf_cnt,
> > > > =C2=A0					 loff_t *buf_offset,
> > > > =C2=A0					 size_t
> > > > *intersect_count,
> > > > =C2=A0					 size_t
> > > > *register_offset);
> > > > -#define VFIO_IOWRITE_DECLATION(size) \
> > > > +#define VFIO_IOWRITE_DECLARATION(size) \
> > > > =C2=A0int vfio_pci_core_iowrite##size(struct vfio_pci_core_device
> > > > *vdev,	\
> > > > -			bool test_mem, u##size val, void
> > > > __iomem
> > > > *io);
> > > > +			bool test_mem, u##size val, void
> > > > __iomem
> > > > *io)
> > > > =C2=A0


