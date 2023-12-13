Return-Path: <kvm+bounces-4374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EAAA4811B21
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 18:32:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 885621F219BA
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 17:32:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 816B457335;
	Wed, 13 Dec 2023 17:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cRYBECtL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA4DDB;
	Wed, 13 Dec 2023 09:32:02 -0800 (PST)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BDGwLvx006818;
	Wed, 13 Dec 2023 17:31:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=1KR3edTcL4jaQjRXzpWlk9xms+FnaIYvT1jy50Qd21Q=;
 b=cRYBECtL1NZjJ0It4UVtr8p87tmnAbsW6xE5zEI9ssTHUzvoNMvoBn/WP2XkXF0Etryp
 TVqKtqNH2Ex8oxFRNfRuEQlGc8wVX5XOiKLnr4ZXRLLs93AusCHzk7omX4UgSxoz3gUX
 svL4N8qDMTcZNfdQHLsp4YY71j65xLtLaAr7hngcGCpyv3GCqCOxE4GBVpvZExUislkS
 0v/MPuUHvnPfyp59PH/o9pTzCS2q+f38Kyjja1MMEYCGyN4ANr0s/RaeyZd/zcxIEEhs
 HFbbKRyMc7DLH1ePqXtvNJ08joz6rEe7nNMk0Vj63XsY5xajrMMt2hNm65GUommvBBO5 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uybw4t2aj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 17:31:59 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BDFmGgi023705;
	Wed, 13 Dec 2023 17:31:59 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uybw4t2a7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 17:31:59 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BDGMAO3008442;
	Wed, 13 Dec 2023 17:31:58 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3uw2jtjrug-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 17:31:58 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BDHVtNK17236534
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Dec 2023 17:31:55 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5C77E20043;
	Wed, 13 Dec 2023 17:31:55 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D9BCA20040;
	Wed, 13 Dec 2023 17:31:54 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.171.91.103])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Dec 2023 17:31:54 +0000 (GMT)
Message-ID: <2096291747c433d02cac794a9c85118b85199370.camel@linux.ibm.com>
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
Date: Wed, 13 Dec 2023 18:31:54 +0100
In-Reply-To: <20231213180033.54516bdd@p-imbrenda>
References: <20231213124942.604109-1-nsg@linux.ibm.com>
	 <20231213124942.604109-6-nsg@linux.ibm.com>
	 <20231213180033.54516bdd@p-imbrenda>
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
X-Proofpoint-GUID: rhbdAUlhJn2SbxofIEDWDVmhl4RLB3EE
X-Proofpoint-ORIG-GUID: 1ah1fPafAPTcoH7XKn_M40K36gvbOZ3m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-13_11,2023-12-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 phishscore=0 spamscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312130125

On Wed, 2023-12-13 at 18:00 +0100, Claudio Imbrenda wrote:
> On Wed, 13 Dec 2023 13:49:42 +0100
> Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:
>=20
> > The STFLE instruction indicates installed facilities.
> > SIE can interpretively execute STFLE.
> > Use a snippet guest executing STFLE to get the result of
> > interpretive execution and check the result.
> >=20
> > Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>=20
> [...]
>=20
> >  static inline void setup_facilities(void)
> > diff --git a/s390x/snippets/c/stfle.c b/s390x/snippets/c/stfle.c
> > new file mode 100644
> > index 00000000..eb024a6a
> > --- /dev/null
> > +++ b/s390x/snippets/c/stfle.c
> > @@ -0,0 +1,26 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * Copyright IBM Corp. 2023
> > + *
> > + * Snippet used by the STLFE interpretive execution facilities test.
> > + */
> > +#include <libcflat.h>
> > +#include <snippet-guest.h>
> > +
> > +int main(void)
> > +{
> > +	const unsigned int max_fac_len =3D 8;
>=20
> why 8?

8 is a somewhat arbitrary, large number :)
I suppose I could choose an even larger one, maybe even PAGE_SIZE/8.
That would guarantee that max_fac_len >=3D stfle_size() (8 is enough for th=
at today)
It's not necessary for max_fac_len >=3D stfle_size(), but probably good for
test coverage.
>=20
> > +	uint64_t res[max_fac_len + 1];
> > +
> > +	res[0] =3D max_fac_len - 1;
> > +	asm volatile ( "lg	0,%[len]\n"
> > +		"	stfle	%[fac]\n"
> > +		"	stg	0,%[len]\n"
> > +		: [fac] "=3DQS"(*(uint64_t(*)[max_fac_len])&res[1]),
> > +		  [len] "+RT"(res[0])
> > +		:
> > +		: "%r0", "cc"
> > +	);
> > +	force_exit_value((uint64_t)&res);
> > +	return 0;
> > +}
> > diff --git a/s390x/stfle-sie.c b/s390x/stfle-sie.c
> > new file mode 100644
> > index 00000000..574319ed
> > --- /dev/null
> > +++ b/s390x/stfle-sie.c
> > @@ -0,0 +1,132 @@

[...]
> > +
> > +static void test_stfle_format_0(void)
> > +{
> > +	struct guest_stfle_res res;
> > +
> > +	report_prefix_push("format-0");
> > +	for (int j =3D 0; j < stfle_size(); j++)
> > +		WRITE_ONCE((*fac)[j], rand64(&rand_s));
>=20
> do you really need random numbers? can't you use a static pattern?
> maybe something like 0x0001020304050607 etc...

Doesn't really need to be random, I need some arbitrary test pattern,
but I don't think some cumbersome constant literal improves anything.
The RNG is just initialized with the time, because why not.

>=20
> > +	vm.sblk->fac =3D (uint32_t)(uint64_t)fac;
> > +	res =3D run_guest();
> > +	report(res.len =3D=3D stfle_size(), "stfle len correct");

^ should be

+	report(res.len =3D=3D min(stfle_size(), 8), "stfle len correct");

For the case that the guest buffer was shorter.

> > +	report(!memcmp(*fac, res.mem, res.len * sizeof(uint64_t)),
> > +	       "Guest facility list as specified");
>=20
> it seems like you are comparing the full facility list (stfle_size
> doublewords long) with the result of STFLE in the guest, but the guest
> is limited to 8 double words?

Their prefixes must be the same. res.len is the guest length, so max 8 righ=
t now.
>=20
> > +	report_prefix_pop();
> > +}

