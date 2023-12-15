Return-Path: <kvm+bounces-4559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AA6FE81474C
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 12:51:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 215481F226F7
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 11:51:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E00C25546;
	Fri, 15 Dec 2023 11:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IHQJTnvP"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C79C2DB6B;
	Fri, 15 Dec 2023 11:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BFBnDtv014930;
	Fri, 15 Dec 2023 11:50:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=NzN+GCW5KQwgiuHI9+BMK3ecTXMHwlCUDpb+pY+hlSM=;
 b=IHQJTnvP2mFVsQXAI9Zwy4nrYNMZ44/2J1WQL4QGy3+gYNK0NZB+i97nPMvY5ABDEN9B
 wC9/o7bXhVZy6HdqTRk9ytGWVaRVLB6wDDfWQa5Y/uZXUEfxSIYduQotC/y2g13g9XXk
 skRumyHTsysM4CYe4tpbtsW+A4S49akjyiGtdqDVgyo7dTWdTwOF78ceD1jVPOTG4C3M
 1UnCDFmvAPVCr0lwryv5a4Q4qO0yfG0SKBwK5rtRHuIKRsyfeQv1O1i8XHjMWD1W7+ci
 KhjM1rTz1C8QPfUJX3gA2Kczy3Cq9VuVsktX5dqk9327RcBsQTAbn+9KNzvu8aoIxnkA /g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3v0jk8dtmu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Dec 2023 11:50:30 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BFBBP2o019789;
	Fri, 15 Dec 2023 11:50:30 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3v0jk8dtm6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Dec 2023 11:50:30 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BF9mKW9008442;
	Fri, 15 Dec 2023 11:50:29 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3uw2jtyyn1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Dec 2023 11:50:29 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BFBoQdv60948842
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Dec 2023 11:50:26 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1A8D420043;
	Fri, 15 Dec 2023 11:50:26 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B7CCC20040;
	Fri, 15 Dec 2023 11:50:25 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.179.19.93])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 15 Dec 2023 11:50:25 +0000 (GMT)
Message-ID: <5996caa1ea76bec45b446fc641237676d9534b3e.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 4/5] s390x: Use library functions for
 snippet exit
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Nico =?ISO-8859-1?Q?B=F6hr?= <nrb@linux.ibm.com>,
        Thomas Huth
	 <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, linux-s390@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>,
        David
	Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Date: Fri, 15 Dec 2023 12:50:15 +0100
In-Reply-To: <20231213174500.77f3d26f@p-imbrenda>
References: <20231213124942.604109-1-nsg@linux.ibm.com>
	 <20231213124942.604109-5-nsg@linux.ibm.com>
	 <20231213174500.77f3d26f@p-imbrenda>
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
X-Proofpoint-GUID: 2cER7YlHs2St3erVOaJXC0uovEcCP46_
X-Proofpoint-ORIG-GUID: gdD6Q1wiOPd_ozgGLzonh2M4rGQtVwC_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-15_06,2023-12-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 suspectscore=0 spamscore=0 impostorscore=0 adultscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312150078

On Wed, 2023-12-13 at 17:45 +0100, Claudio Imbrenda wrote:
> On Wed, 13 Dec 2023 13:49:41 +0100
> Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:
>=20
> > Replace the existing code for exiting from snippets with the newly
> > introduced library functionality.
> > This causes additional report()s, otherwise no change in functionality
> > intended.
> >=20
> > Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> > ---
> >  s390x/sie-dat.c            | 10 ++--------
> >  s390x/snippets/c/sie-dat.c | 19 +------------------
> >  2 files changed, 3 insertions(+), 26 deletions(-)
> >=20
> > diff --git a/s390x/sie-dat.c b/s390x/sie-dat.c
> > index 9e60f26e..6b6e6868 100644
> > --- a/s390x/sie-dat.c
> > +++ b/s390x/sie-dat.c
> > @@ -27,23 +27,17 @@ static void test_sie_dat(void)
> >  	uint64_t test_page_gpa, test_page_hpa;
> >  	uint8_t *test_page_hva, expected_val;
> >  	bool contents_match;
> > -	uint8_t r1;
> > =20
> >  	/* guest will tell us the guest physical address of the test buffer *=
/
> >  	sie(&vm);
> > -	assert(vm.sblk->icptcode =3D=3D ICPT_INST &&
> > -	       (vm.sblk->ipa & 0xff00) =3D=3D 0x8300 && vm.sblk->ipb =3D=3D 0=
x9c0000);
> > -
> > -	r1 =3D (vm.sblk->ipa & 0xf0) >> 4;
> > -	test_page_gpa =3D vm.save_area.guest.grs[r1];
> > +	assert(snippet_get_force_exit_value(&vm, &test_page_gpa));
>=20
> but the function inside the assert will already report a failure, right?
> then why the assert? (the point I'm trying to make is that the function

The assert makes sense, if it fails something has gone
completely off the rails. The question is indeed rather if to report.
There is no harm in it, but I'm thinking now that there should be
_get_ functions that don't report and optionally also _check_ functions tha=
t do.

So:
snippet_get_force_exit
snippet_check_force_exit (exists, but only the _get_ variant is currently r=
equired)
snippet_get_force_exit_value (exists, required)
snippet_check_force_exit_value (exists, but unused)

So minimally, we could do:
snippet_get_force_exit
snippet_get_force_exit_value

I'm thinking we should go for the following:
bool snippet_has_force_exit(...)
bool snippet_has_force_exit_value(...)
uint64_t snippet_get_force_exit_value(...) (internally does assert(snippet_=
has_forced_exit_value))
void snippet_check_force_exit_value(...) (or whoever needs this in the futu=
re adds it)
(Naming open to suggestions)

Then this becomes:
 	/* guest will tell us the guest physical address of the test buffer */
 	sie(&vm);
-	assert(vm.sblk->icptcode =3D=3D ICPT_INST &&
-	       (vm.sblk->ipa & 0xff00) =3D=3D 0x8300 && vm.sblk->ipb =3D=3D 0x9c0=
000);
-
+	assert(snippet_has_force_exit_value(&vm);
-	r1 =3D (vm.sblk->ipa & 0xf0) >> 4;
-	test_page_gpa =3D vm.save_area.guest.grs[r1];
+	test_page_gpa =3D snippet_get_force_exit_value(&vm);

> should not report stuff, see my comments in the previous patch)
>=20
> >  	test_page_hpa =3D virt_to_pte_phys(guest_root, (void*)test_page_gpa);
> >  	test_page_hva =3D __va(test_page_hpa);
> >  	report_info("test buffer gpa=3D0x%lx hva=3D%p", test_page_gpa, test_p=
age_hva);
> > =20
> >  	/* guest will now write to the test buffer and we verify the contents=
 */
> >  	sie(&vm);
> > -	assert(vm.sblk->icptcode =3D=3D ICPT_INST &&
> > -	       vm.sblk->ipa =3D=3D 0x8300 && vm.sblk->ipb =3D=3D 0x440000);
> > +	assert(snippet_check_force_exit(&vm));
> > =20
> >  	contents_match =3D true;
> >  	for (unsigned int i =3D 0; i < GUEST_TEST_PAGE_COUNT; i++) {

[...]

