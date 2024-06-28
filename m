Return-Path: <kvm+bounces-20674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 23EBD91C02C
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 16:01:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3EF8284D09
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 14:01:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C3BF1BE845;
	Fri, 28 Jun 2024 14:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WVmxTSuw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1461A1422C5;
	Fri, 28 Jun 2024 14:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719583273; cv=none; b=be6YT6lCTWQqQRtqXM5u3DSYdIKNPvvhgP59HMsbbU7RDbjGtlRwQ8+ik1+YNuCRUT2m4E1nsNKYUEE4vMOHYuSMSbuDk6Mq/1CShNLpcJRgi2wtEuca7MB3UEPM7dDgvXar38fdVebwkC4t5lylhQO0As1fYiqRAZhGTLsKW7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719583273; c=relaxed/simple;
	bh=d0rwe+OmBo+p2vOpAmYUqGYZhF4Hs7xlhu5I3tWMQY4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tif3BFrspqGfbCubjXJIHDzVMdyVKIcM2daGREW1HEY7NyFJ0WfWV+uIZ/sdBzNxx909nSkxe3MPk8mCSy3Hci353J5Pabtq0z7ogOVrDnq6dwV0cjjYGO/H6YOqCnYLVboW5ACVR+qNB4won2CNgQiy4kvGodK8lJ4Ufpz8GEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WVmxTSuw; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45SDukUu026927;
	Fri, 28 Jun 2024 14:01:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:subject:from:to:cc:date:in-reply-to:references
	:content-type:content-transfer-encoding:mime-version; s=pp1; bh=
	r13813M341o1NEWkU/PWkbjRxQH3kZHydYecB+djrfE=; b=WVmxTSuwcnQHGoi/
	nZBm7rRurMYHjehkRB/fU3DRiyqsAq8lmPtmZtxfH/cHm/NWz0QqEuAE04lx8IsB
	OszNVhr9T9g7hWq4ZHwW9yg5yfBZnnT24ZtLDTNa5zOEU5Fqevd38vlhZDBZfp/I
	3hO+rOq9MvEybpawTXxlbMj89IspugypBP2Ck59yt+h6EYXYaa85BfWUdTjHuIrZ
	pti8/sLhtPsKm0E6NdGHc3WVZcUtz+NDjob2sWXE2+CW2sYO0fHTNp9yiNbzmAYN
	/IsRd3oLO+ihVgEaFmq11KiDnH0kdZsaStcHEv6GFIDyur3w46ltoWj9eDV8FIqf
	bkQvVQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 401wn985fc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Jun 2024 14:01:09 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45SBJYws032606;
	Fri, 28 Jun 2024 14:01:08 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yxbn3r9eh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Jun 2024 14:01:08 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45SE15aC36962794
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Jun 2024 14:01:07 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 35AF05807C;
	Fri, 28 Jun 2024 14:01:05 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7C40D58063;
	Fri, 28 Jun 2024 14:01:04 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.140.200])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 28 Jun 2024 14:01:04 +0000 (GMT)
Message-ID: <ec54a7715380f09bec96c41dea4c942df292de18.camel@linux.ibm.com>
Subject: Re: [PATCH] s390/vfio_ccw: Fix target addresses of TIC CCWs
From: Eric Farman <farman@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic
 <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter
 Oberparleiter <oberpar@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Date: Fri, 28 Jun 2024 10:01:04 -0400
In-Reply-To: <20240628134008.14360-G-hca@linux.ibm.com>
References: <20240627200740.373192-1-farman@linux.ibm.com>
	 <20240628121709.14360-B-hca@linux.ibm.com>
	 <0f7db180c7f3ece66685c50df7ef38ab81cac03b.camel@linux.ibm.com>
	 <20240628134008.14360-G-hca@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: NavTHPwgFRn5oXL8VKbOe1E-We7S2g3J
X-Proofpoint-GUID: NavTHPwgFRn5oXL8VKbOe1E-We7S2g3J
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-28_09,2024-06-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=779 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2406140001
 definitions=main-2406280104

On Fri, 2024-06-28 at 15:40 +0200, Heiko Carstens wrote:
> On Fri, Jun 28, 2024 at 09:31:56AM -0400, Eric Farman wrote:
> > > > dma32_to_u32(ccw->cda) - ccw_head;
> > > > -			ccw->cda =3D u32_to_dma32(cda);
> > > > +			/* Calculate offset of TIC target */
> > > > +			cda =3D dma32_to_u32(ccw->cda) - ccw_head;
> > > > +			ccw->cda =3D virt_to_dma32(iter->ch_ccw) +
> > > > cda;
> > >=20
> > > I would suggest to rename cda to "offset", since that reflects what
> > > it is
> > > now. Also this code needs to take care of type checking, which will
> > > fail now
> > > due to dma32_t type (try "make C=3D1 drivers/s390/cio/vfio_ccw_cp.o).
>=20
> ...
>=20
> > I was poking at that code yesterday because it seemed suspect, but as I
> > wasn't getting an explicit failure (versus the CPC generated by hw), I
> > opted to leave it for now. I agree they should both be fixed up.
>=20
> ...
>=20
> > > I guess
> > > you could add this hunk to your patch:
> > >=20
> > > @@ -915,7 +915,7 @@ void cp_update_scsw(struct channel_program *cp,
> > > union scsw *scsw)
> > > =C2=A0	 * in the ioctl directly. Path status changes etc.
> > > =C2=A0	 */
> > > =C2=A0	list_for_each_entry(chain, &cp->ccwchain_list, next) {
> > > -		ccw_head =3D (u32)(u64)chain->ch_ccw;
> > > +		ccw_head =3D (__force u32)virt_to_dma32(chain-
> > > > ch_ccw);
> > > =C2=A0		/*
> > > =C2=A0		 * On successful execution, cpa points just beyond
> > > the end
> > > =C2=A0		 * of the chain.
>=20
> ...
>=20
> > > Furthermore it looks to me like the ch_iova member of struct ccwchain
> > > should
> > > get a dma32_t type instead of u64. The same applies to quite a few
> > > variables
> > > to the code.=C2=A0
> >=20
> > Agreed. I started this some time back after the IDAW code got reworked,
> > but have been sidetracked. The problem with ch_iova is more apparent
> > after the dma32 stuff.
> >=20
> > > I could give this a try, but I think it would be better if
> > > somebody who knows what he is doing would address this :)
> >=20
> > I'll finish them up. But v2 will have to wait until after my holiday.
> > Thanks for reminding me of the typechecking!
>=20
> I hope you didn't get me wrong: from my point of view we want one or
> two small patches (the above hunks), which fix the bugs, if you
> agree.
>=20
> And then address the type checking stuff at a later point in time.

-ENOCOFFEE. Sorry, I did misunderstand. I'll send the small patches
later this morning.

>=20
> (btw: your mailer adds lot's of extra line wraps)
>=20

Ugh. Thanks for the heads up.

