Return-Path: <kvm+bounces-19888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0687690DD18
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 22:12:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CCF711C2281F
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 20:11:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0660C1741CE;
	Tue, 18 Jun 2024 20:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Waw78Y+8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591FE16EB6F;
	Tue, 18 Jun 2024 20:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718741506; cv=none; b=gNgQNtJckGjGcrScsMnoInA1bYs324rV/ZIRA+D8hKuUiJGSIXzY02Gn6rqC61NfecFYR1FQ3QOlduu1kkAg/4/Gj5RlOQ/R46irz9qkv2DMEwoCGPZHUo7gI2ZwbmwPbNEgcQqIEPoEXR9zEKqu3J1ftug4z7qmnCtqwQk5hVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718741506; c=relaxed/simple;
	bh=LoDJfcelb8+JPwTKhWfI9cXj/7IC6x6MSaQ5wxjUmq4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aZmU5O0hWCuaGf55w/fnkEVBGq/cvGDpywhTHtIgiwsq6CeJfjiB9oHdU/svwBDrLN7/3A68oAWYkiefupRyYrygFFsICZYsqADE4F0XCV/oe5HhJjjIeFuLYyQJrronYTyPpQqIqmFv93NcgTlwJdpM82w1kmq/lVjfNneSgtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Waw78Y+8; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45IJMXrP015380;
	Tue, 18 Jun 2024 20:11:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:subject:from:to:cc:date:in-reply-to:references
	:content-type:content-transfer-encoding:mime-version; s=pp1; bh=
	B1aYHtHzZ0hgavG7eIPLadDJjD+OVR88SJoRoSOySUE=; b=Waw78Y+8A0oWEXMq
	RSlfh8VNjE3KvX7b3cw0tLRslLn8O52Ub1UIW37pdat8GK4zXXJMrVm6JYxeI/Pm
	JDgvZE8C+Oq/IgjQSTntJY1TR7p7ML5R6fRJkGnol2I1nCq8vkfBDO7KeJx7eRq3
	6iGo2ZJo/AeVT/i4QxlamZP7XaaHCACY727n7tjp/xA1UjTb9MVU1sICTqkBrf7q
	t7pGXTFmw8WTJc6DUBHN3Gp1nHVDwwrXqiVtU0JXJUyEp4nXoVorDlzB+r+cvCJ4
	T+1YUj03H4L2TCcJGgjgKcg9RWdnDmmi78V+wHyt2a47cDfBCfgVVssKYTnFxcFm
	vHvxMA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yuensr9u7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Jun 2024 20:11:39 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45II0oZh006226;
	Tue, 18 Jun 2024 20:11:39 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ysn9ups02-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Jun 2024 20:11:39 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45IKBawd60424538
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Jun 2024 20:11:38 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 26DD858054;
	Tue, 18 Jun 2024 20:11:36 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8370D5805D;
	Tue, 18 Jun 2024 20:11:34 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.38.197])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 18 Jun 2024 20:11:34 +0000 (GMT)
Message-ID: <afdde0842680698276df0856dd8b896dac692b56.camel@linux.ibm.com>
Subject: Re: [PATCH] s390/cio: add missing MODULE_DESCRIPTION() macros
From: Eric Farman <farman@linux.ibm.com>
To: Vineeth Vijayan <vneethv@linux.ibm.com>,
        Jeff Johnson
 <quic_jjohnson@quicinc.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Matthew
 Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Tue, 18 Jun 2024 16:11:33 -0400
In-Reply-To: <064eb313-2f38-479d-80bd-14777f7d3d62@linux.ibm.com>
References: 
	<20240615-md-s390-drivers-s390-cio-v1-1-8fc9584e8595@quicinc.com>
	 <064eb313-2f38-479d-80bd-14777f7d3d62@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 (3.52.2-1.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ctXsMAfDexexCEZupfWrPXRfSw0nU0Vv
X-Proofpoint-GUID: ctXsMAfDexexCEZupfWrPXRfSw0nU0Vv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-18_03,2024-06-17_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 clxscore=1011
 adultscore=0 spamscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406180146

On Tue, 2024-06-18 at 14:52 +0200, Vineeth Vijayan wrote:
>=20
>=20
> On 6/16/24 05:56, Jeff Johnson wrote:
> > With ARCH=3Ds390, make allmodconfig && make W=3D1 C=3D1 reports:
> > WARNING: modpost: missing MODULE_DESCRIPTION() in
> > drivers/s390/cio/ccwgroup.o
> > WARNING: modpost: missing MODULE_DESCRIPTION() in
> > drivers/s390/cio/vfio_ccw.o
> >=20
> > Add the missing invocations of the MODULE_DESCRIPTION() macro.
> >=20
> > Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> > ---
> > =C2=A0 drivers/s390/cio/ccwgroup.c=C2=A0=C2=A0=C2=A0=C2=A0 | 1 +
> > =C2=A0 drivers/s390/cio/vfio_ccw_drv.c | 1 +
> > =C2=A0 2 files changed, 2 insertions(+)
> >=20
> > diff --git a/drivers/s390/cio/ccwgroup.c
> > b/drivers/s390/cio/ccwgroup.c
> > index b72f672a7720..a741e5012fce 100644
> > --- a/drivers/s390/cio/ccwgroup.c
> > +++ b/drivers/s390/cio/ccwgroup.c
> > @@ -550,4 +550,5 @@ void ccwgroup_remove_ccwdev(struct ccw_device
> > *cdev)
> > =C2=A0=C2=A0	put_device(&gdev->dev);
> > =C2=A0 }
> > =C2=A0 EXPORT_SYMBOL(ccwgroup_remove_ccwdev);
> > +MODULE_DESCRIPTION("CCW group bus driver");
>=20
> the name of the bus here is "ccwgroup" bus without a space.
> Otherwise this change in ccwgroup.c looks good to me.
> Thank you for the patch.
>=20
> With the correction mentioned above,
> Reviewed-by: Vineeth Vijayan <vneethv@linux.ibm.com>
>=20
>=20
> > =C2=A0 MODULE_LICENSE("GPL");
> > diff --git a/drivers/s390/cio/vfio_ccw_drv.c
> > b/drivers/s390/cio/vfio_ccw_drv.c
> > index 8ad49030a7bf..49da348355b4 100644
> > --- a/drivers/s390/cio/vfio_ccw_drv.c
> > +++ b/drivers/s390/cio/vfio_ccw_drv.c
> > @@ -488,4 +488,5 @@ static void __exit vfio_ccw_sch_exit(void)
> > =C2=A0 module_init(vfio_ccw_sch_init);
> > =C2=A0 module_exit(vfio_ccw_sch_exit);
> > =C2=A0=20
> > +MODULE_DESCRIPTION("VFIO based Physical Subchannel device
> > driver");
>=20
> Halil/Mathew/Eric,
> Could you please comment on this ?

That's what is in the prologue, and is fine.

Reviewed-by: Eric Farman <farman@linux.ibm.com>

>=20
> > =C2=A0 MODULE_LICENSE("GPL v2");
> >=20
> > ---
> > base-commit: 83a7eefedc9b56fe7bfeff13b6c7356688ffa670
> > change-id: 20240615-md-s390-drivers-s390-cio-3598abb802ad
> >=20


