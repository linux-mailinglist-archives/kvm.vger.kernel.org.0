Return-Path: <kvm+bounces-4463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F662812CC3
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 11:19:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF51B282985
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 10:19:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 559F43BB26;
	Thu, 14 Dec 2023 10:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="s21e8J/F"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D4A106;
	Thu, 14 Dec 2023 02:18:49 -0800 (PST)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BEA8i5l029803;
	Thu, 14 Dec 2023 10:18:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=7sbqsZI/dIh7/sQIt7TDuIeiF4sOnSbRyAmeSQz0zu0=;
 b=s21e8J/FoK7QGJ+5lb9TPT6gNh/B9HeNspwnolY4mt0qkVZzUBzKmrtLPhFTOSB4nrCk
 wILfVEPVB/u+k7GQsU04wkIbwRx2+Y93xM6TsPoT73e+4rojLM5bkYmSZgsnUEg3a8G8
 Si0rkxfNIU7XwDzq1U+C36Y2WTbLPmjwVIdsds3SDyRrOpvzi+W4gxBCLt4gB2I65lNN
 rFVEiq9SUi/hHHcEkJYCZgdv1kCCgeoOUNbOBimoNcxLVvhzoCFsRcxd2fdx2JToWpHI
 h/K+GH0LKpytSo4+0IDIOYqiO4O9d20IcmLB2IdSvpj+pk7/LVVgJUCmSepALzOT7F3E VQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uyxbvj91x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 14 Dec 2023 10:18:46 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BE9CvqM020754;
	Thu, 14 Dec 2023 10:18:46 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uyxbvj91j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 14 Dec 2023 10:18:46 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BE9T3Ld028201;
	Thu, 14 Dec 2023 10:18:45 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3uw2xyyupd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 14 Dec 2023 10:18:45 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BEAIfgm65863960
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Dec 2023 10:18:41 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A569820070;
	Thu, 14 Dec 2023 10:18:41 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7EB582006E;
	Thu, 14 Dec 2023 10:18:41 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.152.224.238])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 14 Dec 2023 10:18:41 +0000 (GMT)
Message-ID: <05d13c9ffc4876602044311d737e3074dd81894a.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 5/5] s390x: Add test for STFLE
 interpretive execution (format-0)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Nico =?ISO-8859-1?Q?B=F6hr?= <nrb@linux.ibm.com>,
        Janosch Frank
	 <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, linux-s390@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
        Thomas Huth <thuth@redhat.com>
Date: Thu, 14 Dec 2023 11:18:41 +0100
In-Reply-To: <2096291747c433d02cac794a9c85118b85199370.camel@linux.ibm.com>
References: <20231213124942.604109-1-nsg@linux.ibm.com>
	 <20231213124942.604109-6-nsg@linux.ibm.com>
	 <20231213180033.54516bdd@p-imbrenda>
	 <2096291747c433d02cac794a9c85118b85199370.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rfPjk788Q4mJJvFJxBx86wL4WJ2hffLM
X-Proofpoint-ORIG-GUID: wonD1QMixsCob4D44TNf64cQUuJBwMBU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-14_06,2023-12-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 mlxscore=0 mlxlogscore=999 priorityscore=1501 adultscore=0 phishscore=0
 clxscore=1015 malwarescore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312140067

On Wed, 2023-12-13 at 18:31 +0100, Nina Schoetterl-Glausch wrote:
> On Wed, 2023-12-13 at 18:00 +0100, Claudio Imbrenda wrote:
> > On Wed, 13 Dec 2023 13:49:42 +0100
> > Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:
> >=20
> > > The STFLE instruction indicates installed facilities.
> > > SIE can interpretively execute STFLE.
> > > Use a snippet guest executing STFLE to get the result of
> > > interpretive execution and check the result.
> > >=20
> > > Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> >=20
> > [...]
> >=20
> > >  static inline void setup_facilities(void)
> > > diff --git a/s390x/snippets/c/stfle.c b/s390x/snippets/c/stfle.c
> > > new file mode 100644
> > > index 00000000..eb024a6a
> > > --- /dev/null
> > > +++ b/s390x/snippets/c/stfle.c
> > > @@ -0,0 +1,26 @@
> > > +/* SPDX-License-Identifier: GPL-2.0-only */
> > > +/*
> > > + * Copyright IBM Corp. 2023
> > > + *
> > > + * Snippet used by the STLFE interpretive execution facilities test.
> > > + */
> > > +#include <libcflat.h>
> > > +#include <snippet-guest.h>
> > > +
> > > +int main(void)
> > > +{
> > > +	const unsigned int max_fac_len =3D 8;
> >=20
> > why 8?
>=20
> 8 is a somewhat arbitrary, large number :)
> I suppose I could choose an even larger one, maybe even PAGE_SIZE/8.
> That would guarantee that max_fac_len >=3D stfle_size() (8 is enough for =
that today)
> It's not necessary for max_fac_len >=3D stfle_size(), but probably good f=
or
> test coverage.
> >=20
> > > +	uint64_t res[max_fac_len + 1];
> > > +
> > > +	res[0] =3D max_fac_len - 1;
> > > +	asm volatile ( "lg	0,%[len]\n"
> > > +		"	stfle	%[fac]\n"
> > > +		"	stg	0,%[len]\n"
> > > +		: [fac] "=3DQS"(*(uint64_t(*)[max_fac_len])&res[1]),
> > > +		  [len] "+RT"(res[0])
> > > +		:
> > > +		: "%r0", "cc"
> > > +	);
> > > +	force_exit_value((uint64_t)&res);
> > > +	return 0;
> > > +}
> > > diff --git a/s390x/stfle-sie.c b/s390x/stfle-sie.c
> > > new file mode 100644
> > > index 00000000..574319ed
> > > --- /dev/null
> > > +++ b/s390x/stfle-sie.c
> > > @@ -0,0 +1,132 @@

[...]

> > > +	vm.sblk->fac =3D (uint32_t)(uint64_t)fac;
> > > +	res =3D run_guest();
> > > +	report(res.len =3D=3D stfle_size(), "stfle len correct");

You're right, disregard everything below.
>=20
> ^ should be
>=20
> +	report(res.len =3D=3D min(stfle_size(), 8), "stfle len correct");
>=20
> For the case that the guest buffer was shorter.
>=20
> > > +	report(!memcmp(*fac, res.mem, res.len * sizeof(uint64_t)),
> > > +	       "Guest facility list as specified");
> >=20
> > it seems like you are comparing the full facility list (stfle_size
> > doublewords long) with the result of STFLE in the guest, but the guest
> > is limited to 8 double words?
>=20
> Their prefixes must be the same. res.len is the guest length, so max 8 ri=
ght now.
> >=20
> > > +	report_prefix_pop();
> > > +}


