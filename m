Return-Path: <kvm+bounces-20148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 84CEF910F72
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 19:51:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0620A1F21E7B
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 17:51:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 935361B9AC1;
	Thu, 20 Jun 2024 17:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TXJHb9qS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939811B29C1;
	Thu, 20 Jun 2024 17:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718905575; cv=none; b=lGmJ+khvL0inn5R9Dyl9zE7l6GBy8kksNaEqpxlzACIS3CJxEmpuVS1P/KD0BxYIOUb9TQ0i4+nyfwSkv6gAVHNlNuRzHrpHHd+N2NyrMS7zdNeFUr5zo7G92Ol8eclCr3m7TY7tBfC8RHU2kTTOtuYI5SNxJ1N/OHBOBYgpk00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718905575; c=relaxed/simple;
	bh=ZssV0dt/KUH1ngSwAytmSikBkDaI0WVlHGyfxN5bujg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=n2iVOIgrLzJPy0HoBMIparBD2QjQ2zPJof3+kX/cF0NRhmaqP0OXqNRzViRwXE2w7adwjxmTLJWhF1BOCDmI1I37FNhoSAP7CQuTmoAl31RJCy9DHs5va2FRd8nXMVt2WRfBfZXh15TMNeLHOd2LgLauLSyWUdXs6vhi97DgO/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TXJHb9qS; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45KHOVBs015178;
	Thu, 20 Jun 2024 17:46:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:subject:from:to:cc:date:in-reply-to:references
	:content-type:content-transfer-encoding:mime-version; s=pp1; bh=
	aWzY6MS2pHvOMpOp6urkjMhNm8nZgt2O4d0liFzFZBM=; b=TXJHb9qSVDXRywsq
	uFMgXjAFGqJPwupDcmryYtNlLL6uiyNNKQUa8N/cW8SO4T9t0Hi3jN5k5H0tWLwM
	BlJHU8JXL9DvJ+LeCfGcAQQBBk4QiUU70+gkWM1l6avZXuBUcXj3Gj01nujV0j8y
	Rv7MIGMmlePMgw3R/wlRfBMOCWGRJJiTqHf7dMdAsTQQJTPff+geeQSepfktrVPy
	sbuxd6DGZyp0FO+q+ZmDl69MuBIgK4GqSw095R+vQBjs9DBqt0IJNvp3dO9NAEBA
	gEvf6mVbQXH8C8cFS+nHzqL5lhjdqzSzcr+Hq+v3xchXPecx4hx6chtTiY1xVmP1
	1BNHeg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvrsu01xt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 17:46:09 +0000 (GMT)
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45KHk8g6016878;
	Thu, 20 Jun 2024 17:46:08 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvrsu01xq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 17:46:08 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45KHNsNS032326;
	Thu, 20 Jun 2024 17:46:08 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yvrspg5hj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 17:46:07 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45KHk2gM54919594
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 17:46:04 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7CF702005A;
	Thu, 20 Jun 2024 17:46:00 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4A8FB2004E;
	Thu, 20 Jun 2024 17:46:00 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.boeblingen.de.ibm.com (unknown [9.152.224.238])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Jun 2024 17:46:00 +0000 (GMT)
Message-ID: <8879e438fd6d7a4f83eba752c8ef0cf28bb864b9.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 4/7] s390x: Add function for checking
 diagnose intercepts
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Nico =?ISO-8859-1?Q?B=F6hr?= <nrb@linux.ibm.com>,
        Janosch Frank
 <frankja@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>, Thomas Huth
 <thuth@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        David
 Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date: Thu, 20 Jun 2024 19:46:00 +0200
In-Reply-To: <20240620184711.50bd463c@p-imbrenda>
References: <20240620141700.4124157-1-nsg@linux.ibm.com>
	 <20240620141700.4124157-5-nsg@linux.ibm.com>
	 <20240620184711.50bd463c@p-imbrenda>
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
X-Proofpoint-GUID: ZT4dSh3Ap7PTFAyODXm6HRJ_p_Xzj0Rx
X-Proofpoint-ORIG-GUID: eu3n-A9jQe-9uB91fRISPClxTuC7solk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-20_07,2024-06-20_04,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 phishscore=0 impostorscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2406140001
 definitions=main-2406200126

On Thu, 2024-06-20 at 18:47 +0200, Claudio Imbrenda wrote:
> On Thu, 20 Jun 2024 16:16:57 +0200
> Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:
>=20
> > sie_is_diag_icpt() checks if the intercept is due to an expected
> > diagnose call and is valid.
> > It subsumes pv_icptdata_check_diag.
> >=20
> > Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>=20
>=20
> [...]
>=20
>=20
> > diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
> > index 0fa915cf..d4ba2a40 100644
> > --- a/lib/s390x/sie.c
> > +++ b/lib/s390x/sie.c
> > @@ -42,6 +42,59 @@ void sie_check_validity(struct vm *vm, uint16_t vir_=
exp)
> >  	report(vir_exp =3D=3D vir, "VALIDITY: %x", vir);
> >  }
> > =20
> > +bool sie_is_diag_icpt(struct vm *vm, unsigned int diag)
> > +{
> > +	union {
> > +		struct {
> > +			uint64_t     : 16;
> > +			uint64_t ipa : 16;
> > +			uint64_t ipb : 32;
> > +		};
> > +		struct {
> > +			uint64_t          : 16;
> > +			uint64_t opcode   :  8;
> > +			uint64_t r_1      :  4;
> > +			uint64_t r_2      :  4;
> > +			uint64_t r_base   :  4;
> > +			uint64_t displace : 12;
> > +			uint64_t zero     : 16;
> > +		};
> > +	} instr =3D { .ipa =3D vm->sblk->ipa, .ipb =3D vm->sblk->ipb };
> > +	uint8_t icptcode;
> > +	uint64_t code;
> > +
> > +	switch (diag) {
> > +	case 0x44:
> > +	case 0x9c:
> > +	case 0x288:
> > +	case 0x308:
> > +		icptcode =3D ICPT_PV_NOTIFY;
> > +		break;
> > +	case 0x500:
> > +		icptcode =3D ICPT_PV_INSTR;
> > +		break;
> > +	default:
> > +		/* If a new diag is introduced add it to the cases above! */
> > +		assert_msg(false, "unknown diag");
>=20
> just a nit, but would it be possible to also print the diag number that
> causes the error?

Yes and easy
		assert_msg(false, "unknown diag 0x%x", diag);
>=20
>=20
> otherwise looks good
>=20
>=20


