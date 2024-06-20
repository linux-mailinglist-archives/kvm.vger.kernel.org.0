Return-Path: <kvm+bounces-20147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 975D4910F6E
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 19:50:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43F5C1F23699
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 17:50:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 289201BD03A;
	Thu, 20 Jun 2024 17:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZnjvUQL/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D2B1B9AC7;
	Thu, 20 Jun 2024 17:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718905377; cv=none; b=Tgitpmbsg//r1ZD67MVl0gp0OLyqzsx4FaCCCmDZgQpzJvrLWGSxQ6P7mzg0Ppes5wO/rXWrZIIXQrRTsNigV6A8VhyHiRo28SqTyBiteDPO377QY+ODv3G8W2zjAQI0Mdy1GvwrDon4rtyG2Fa4hIqPtP1AqxyUPFKJ+hAg3Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718905377; c=relaxed/simple;
	bh=IMw4uEUs78fca1V0F7sVBeufLPAZ9Rl7A10jQDWMS80=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nNui/yF5j1EEM4n3a2+W0tRfuXYpCDORpZZ4KmxXOmUMJefmqlE10PlOKPvjQRF2dFvmudf3aWfzXGiOfzoVe4bCc9sacEjgu5oX+a/2Xpvnu1usg4I6hE4MToPuz+Ldy3Nu7toc1p8As+4FAM360YnKkjGL5P+kEwJNBCHXm90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZnjvUQL/; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45KHON7g023799;
	Thu, 20 Jun 2024 17:42:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:subject:from:to:cc:date:in-reply-to:references
	:content-type:content-transfer-encoding:mime-version; s=pp1; bh=
	v2jxXi5nNxLtjaGCoPX7/k9ctk5V0fG9/7Iw784Ku5A=; b=ZnjvUQL/3SInoUy1
	Yp25LQOdSyd2VrLPBdE2euiGlFysYDeBlglDd+S/tQuGZXnxXZSeLd6JShZNl9jc
	hu9EgZkz1sKu0yODC9+mou1C8CnVEIYqh/j8R7jvieqJ+aS0rprPcCWhqGvmZJZG
	XneNax/0oyCQnyCW3jb5JJ+bBHpGgf7DRJ7fHTX0tBvlt+t7gfBDw03ooeHdZ24E
	mtuC+QSSfz10zb7col0Hm59PC4NABbvbQGKuT5SuKEvp3z3Zo67zyx5wjzEcXpPu
	NOt2i5GlfNIoPao9Me3kaKJV0babaKPieG9+HwtSEdYH6ZGJHbO2p5Nn08MfjGkI
	4qIFfA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvrsrg1h3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 17:42:44 +0000 (GMT)
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45KHgihR020503;
	Thu, 20 Jun 2024 17:42:44 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvrsrg1h1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 17:42:44 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45KHNi1u007683;
	Thu, 20 Jun 2024 17:42:43 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yvrsp84r5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 17:42:43 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45KHgbx750790908
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 17:42:39 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4DA342004B;
	Thu, 20 Jun 2024 17:42:37 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2B51420040;
	Thu, 20 Jun 2024 17:42:37 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.boeblingen.de.ibm.com (unknown [9.152.224.238])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Jun 2024 17:42:37 +0000 (GMT)
Message-ID: <fba68cce31c20f636342a8e8ce6b3b517ce012ad.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 7/7] s390x: Add test for STFLE
 interpretive execution (format-0)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>,
        Nico =?ISO-8859-1?Q?B=F6hr?=
	 <nrb@linux.ibm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Thomas Huth
	 <thuth@redhat.com>, Nicholas Piggin <npiggin@gmail.com>,
        David Hildenbrand
	 <david@redhat.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Date: Thu, 20 Jun 2024 19:42:37 +0200
In-Reply-To: <20240620192534.292e51cb@p-imbrenda>
References: <20240620141700.4124157-1-nsg@linux.ibm.com>
	 <20240620141700.4124157-8-nsg@linux.ibm.com>
	 <20240620192534.292e51cb@p-imbrenda>
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
X-Proofpoint-GUID: 9sBYi3MMb8O_fFu__BtG0645xofQegkz
X-Proofpoint-ORIG-GUID: A7cFLtsrmoswPVWzCf4hrcHj2k-wwpAJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-20_08,2024-06-20_04,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 bulkscore=0 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 phishscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2406140001
 definitions=main-2406200126

On Thu, 2024-06-20 at 19:25 +0200, Claudio Imbrenda wrote:
> On Thu, 20 Jun 2024 16:17:00 +0200
> Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:
>=20
> > The STFLE instruction indicates installed facilities.
> > SIE can interpretively execute STFLE.
> > Use a snippet guest executing STFLE to get the result of
> > interpretive execution and check the result.
> >=20
> > Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>=20
>=20
> [...]
>=20
>=20
> > +struct guest_stfle_res {
> > +	uint16_t len;
> > +	uint64_t reg;
>=20
> you don't really use reg, do you?

No, and I don't think I will either, must be some vestige.

[...]
>=20
> > +int main(int argc, char **argv)
> > +{
> > +	struct args args =3D parse_args(argc, argv);
> > +
> > +	if (!sclp_facilities.has_sief2) {
> > +		report_skip("SIEF2 facility unavailable");
> > +		goto out;
> > +	}
> > +
> > +	report_info("PRNG seed: 0x%lx", args.seed);
> > +	prng_s =3D prng_init(args.seed);
> > +	setup_guest();
> > +	if (test_facility(7))
> > +		test_stfle_format_0();
>=20
> since STFLE is literally the feature you are testing, maybe you can
> just skip, like you did for SIEF2?

Yeah, that's better.
>=20
> > +out:
> > +	return report_summary();
> > +}
> > diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> > index 3a9decc9..f2203069 100644
> > --- a/s390x/unittests.cfg
> > +++ b/s390x/unittests.cfg
> > @@ -392,3 +392,6 @@ file =3D sie-dat.elf
> > =20
> >  [pv-attest]
> >  file =3D pv-attest.elf
> > +
> > +[stfle-sie]
> > +file =3D stfle-sie.elf
>=20


