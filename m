Return-Path: <kvm+bounces-20670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1505D91BF91
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 15:32:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 812E21F2394B
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 13:32:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F3761E529;
	Fri, 28 Jun 2024 13:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lXFJd1Kr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED81567F;
	Fri, 28 Jun 2024 13:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719581526; cv=none; b=knyKCKJd2gjhUizDCTiBSSgUeVTq0B27edI94UTnSPpbG3gVK4mvN6OInO+JY2A+1IC8m+3LTU/WV1ukpnmVGZ9u/E+ycIvBBDOnN8WJbcrg3Sc238ORDUk7e7I9iDFSg7s5i7L0hUNwPTZDpClJQ882tfNErFIV42+EOzVes28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719581526; c=relaxed/simple;
	bh=Ru27iE2fNFl+ii9aGtfcOZPb8k8pqMIJc4PzwoOdz6c=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=U+mbKGq8cJY0N4zOiSid9y8mp8vxG0EPASWKY6J3g24gjBhPZxugnuU6b0EOijXDxJ0F+gjM4QHmv9J3cS3mfjp5GMYhdOis9nl0iPfZH9za/5wB/nWDQglVeVSPodWpHBdLv0AYHwmQzjMDGh60fNA4M6w1AufMgPdgxc1UXpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lXFJd1Kr; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45SDRB1B024649;
	Fri, 28 Jun 2024 13:32:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:subject:from:to:cc:date:in-reply-to:references
	:content-type:content-transfer-encoding:mime-version; s=pp1; bh=
	UFhsv1aOjs3BwSjy/ZEiGTGkebNnnP0bknEjRDNWOVs=; b=lXFJd1KrmHotWW88
	pkZixM6a51LI0/i4qx4DQaLnhNfUu2CMYDgJau4EWWzG5/DRcBWChaTizT798jyU
	5GB8NObrUutUEOOwxXmZfk7+m0hEjfNKbTzXULjMOFlwPifhJwaCyiyWQ79YV4AE
	H8oMG4way62LYRdiOlcwsjR/0VsgH0tuN/gk4oeZhS+Fso++zlM5IbEc85tki+IW
	4GDqO5IrIMcCU+c7hpRwIvtsAKBkentf9UrDuEpvQEGXWCq7cwxCz5QzNEC3k4Qh
	jQZN3OX7X6VkhaXB5A62qoT2dLNehS01gCDiw+UP7K+6PDVpwukc+BBzzU5wtXBV
	T4TRhQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 401qgbh0d8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Jun 2024 13:32:02 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45SDCIHD000564;
	Fri, 28 Jun 2024 13:32:01 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yxaengfyv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Jun 2024 13:32:01 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45SDVw2G38339160
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Jun 2024 13:32:00 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4891358054;
	Fri, 28 Jun 2024 13:31:58 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 214B95805F;
	Fri, 28 Jun 2024 13:31:57 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.140.200])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 28 Jun 2024 13:31:57 +0000 (GMT)
Message-ID: <0f7db180c7f3ece66685c50df7ef38ab81cac03b.camel@linux.ibm.com>
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
Date: Fri, 28 Jun 2024 09:31:56 -0400
In-Reply-To: <20240628121709.14360-B-hca@linux.ibm.com>
References: <20240627200740.373192-1-farman@linux.ibm.com>
	 <20240628121709.14360-B-hca@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: ec1fylTgo-_502wIzP3KhIA4ftJiU5Vk
X-Proofpoint-GUID: ec1fylTgo-_502wIzP3KhIA4ftJiU5Vk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-28_09,2024-06-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 suspectscore=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 impostorscore=0 lowpriorityscore=0
 clxscore=1015 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2406140001 definitions=main-2406280100

On Fri, 2024-06-28 at 14:17 +0200, Heiko Carstens wrote:
> On Thu, Jun 27, 2024 at 10:07:40PM +0200, Eric Farman wrote:
> > The processing of a Transfer-In-Channel (TIC) CCW requires locating
> > the target of the CCW in the channel program, and updating the
> > address to reflect what will actually be sent to hardware.
> >=20
> > An error exists where the 64-bit virtual address is truncated to
> > 32-bits (variable "cda") when performing this math. Since s390
>=20
> ...
>=20
> > Fix the calculation of the TIC CCW's data address such that it
> > points
> > to a valid 31-bit address regardless of the input address.
> >=20
> > Fixes: bd36cfbbb9e1 ("s390/vfio_ccw_cp: use new address translation
> > helpers")
> > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > ---
> > =C2=A0drivers/s390/cio/vfio_ccw_cp.c | 5 +++--
> > =C2=A01 file changed, 3 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/drivers/s390/cio/vfio_ccw_cp.c
> > b/drivers/s390/cio/vfio_ccw_cp.c
> > index 6e5c508b1e07..fd8cb052f096 100644
> > --- a/drivers/s390/cio/vfio_ccw_cp.c
> > +++ b/drivers/s390/cio/vfio_ccw_cp.c
> > @@ -495,8 +495,9 @@ static int ccwchain_fetch_tic(struct ccw1 *ccw,
> > =C2=A0	list_for_each_entry(iter, &cp->ccwchain_list, next) {
> > =C2=A0		ccw_head =3D iter->ch_iova;
> > =C2=A0		if (is_cpa_within_range(ccw->cda, ccw_head, iter-
> > >ch_len)) {
> > -			cda =3D (u64)iter->ch_ccw +
> > dma32_to_u32(ccw->cda) - ccw_head;
> > -			ccw->cda =3D u32_to_dma32(cda);
> > +			/* Calculate offset of TIC target */
> > +			cda =3D dma32_to_u32(ccw->cda) - ccw_head;
> > +			ccw->cda =3D virt_to_dma32(iter->ch_ccw) +
> > cda;
>=20
> I would suggest to rename cda to "offset", since that reflects what
> it is
> now. Also this code needs to take care of type checking, which will
> fail now
> due to dma32_t type (try "make C=3D1 drivers/s390/cio/vfio_ccw_cp.o).

Argh, I missed that. Sorry.

>=20
> You could write the above as:
>=20
> 			ccw->cda =3D virt_to_dma32((void *)iter-
> >ch_ccw + cda);
>=20
> Note that somebody :) introduced a similar bug in cp_update_scsw().=C2=A0

:)

I was poking at that code yesterday because it seemed suspect, but as I
wasn't getting an explicit failure (versus the CPC generated by hw), I
opted to leave it for now. I agree they should both be fixed up.

> I guess
> you could add this hunk to your patch:
>=20
> @@ -915,7 +915,7 @@ void cp_update_scsw(struct channel_program *cp,
> union scsw *scsw)
> =C2=A0	 * in the ioctl directly. Path status changes etc.
> =C2=A0	 */
> =C2=A0	list_for_each_entry(chain, &cp->ccwchain_list, next) {
> -		ccw_head =3D (u32)(u64)chain->ch_ccw;
> +		ccw_head =3D (__force u32)virt_to_dma32(chain-
> >ch_ccw);
> =C2=A0		/*
> =C2=A0		 * On successful execution, cpa points just beyond
> the end
> =C2=A0		 * of the chain.
>=20
> Furthermore it looks to me like the ch_iova member of struct ccwchain
> should
> get a dma32_t type instead of u64. The same applies to quite a few
> variables
> to the code.=C2=A0

Agreed. I started this some time back after the IDAW code got reworked,
but have been sidetracked. The problem with ch_iova is more apparent
after the dma32 stuff.

> I could give this a try, but I think it would be better if
> somebody who knows what he is doing would address this :)

I'll finish them up. But v2 will have to wait until after my holiday.
Thanks for reminding me of the typechecking!

