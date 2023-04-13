Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 930736E0A6C
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 11:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjDMJnc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 05:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjDMJn3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 05:43:29 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6620B30DA;
        Thu, 13 Apr 2023 02:43:28 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33D9E2uM015435;
        Thu, 13 Apr 2023 09:43:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : from
 : to : subject : cc : message-id : date; s=pp1;
 bh=akCZEmm025jBIjxua2C579Ptn7oKzzbO62SQ/RA7FVE=;
 b=V1hAmvDucVa5ra1Rb41BTjGCtWC2Cs9rsOFOGKRFSD2hrKhEVa2k/QvqiIIkjSzoSQW9
 OckRf1rua3aycZ5NpacnMmQdDGVRLc2egvQqxY3r1Anr3euCd6bLU2gTP/auBjTOO8qd
 P0RPIwOvY6k2ZT/6Z0przsx2byiDh8/lAvNaAx8v232EMqyBk4LisMrZfm4iA6vmr63b
 G83o1+sGf1I87mjAZrk32oeG2Rpcdi1c/Je4EndAUedrn8ZSxMGEpSM2UqwF4jJRwGSu
 QgaO/tMdWeepbAuX5Y9fQ+6UdbN9KDpn2SKGMiFAgrqb7if/eU679wRbh9GcKBFCTRzW yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pxex1s0vx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Apr 2023 09:43:27 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33D9EZE1018219;
        Thu, 13 Apr 2023 09:43:27 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pxex1s0un-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Apr 2023 09:43:26 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33D3G6uh022165;
        Thu, 13 Apr 2023 09:43:25 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3pu0hdjx22-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Apr 2023 09:43:25 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33D9hLka26280608
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Apr 2023 09:43:21 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7662F20043;
        Thu, 13 Apr 2023 09:43:21 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4616820040;
        Thu, 13 Apr 2023 09:43:21 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.10.186])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 13 Apr 2023 09:43:21 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <cfd83c1d7a74e969e6e3c922bbe5650f8e9adadd.camel@linux.ibm.com>
References: <20230327082118.2177-1-nrb@linux.ibm.com> <20230327082118.2177-5-nrb@linux.ibm.com> <cfd83c1d7a74e969e6e3c922bbe5650f8e9adadd.camel@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 4/4] s390x: add a test for SIE without MSO/MSL
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Message-ID: <168137900094.42330.6464555141616427645@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 13 Apr 2023 11:43:20 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tuE6Mb5db4T2d6t64UA1DkPVP0rOMkcS
X-Proofpoint-ORIG-GUID: Py4W6bz4uaviUuqn1BiD2nPAnFnTr5yA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-13_06,2023-04-12_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 mlxscore=0 spamscore=0 mlxlogscore=889 phishscore=0
 suspectscore=0 bulkscore=0 impostorscore=0 adultscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304130087
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Nina Schoetterl-Glausch (2023-04-05 21:55:01)
> On Mon, 2023-03-27 at 10:21 +0200, Nico Boehr wrote:
> > Since we now have the ability to run guests without MSO/MSL, add a test
> > to make sure this doesn't break.
> >=20
> > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> > ---
> >  s390x/Makefile             |   2 +
> >  s390x/sie-dat.c            | 121 +++++++++++++++++++++++++++++++++++++
> >  s390x/snippets/c/sie-dat.c |  58 ++++++++++++++++++
> >  s390x/unittests.cfg        |   3 +
> >  4 files changed, 184 insertions(+)
> >  create mode 100644 s390x/sie-dat.c
> >  create mode 100644 s390x/snippets/c/sie-dat.c
> >=20
>=20
> Test looks good to me. Some comments below.
> [...]
>=20
> > diff --git a/s390x/sie-dat.c b/s390x/sie-dat.c
> > new file mode 100644
> > index 000000000000..37e46386181c
> > --- /dev/null
> > +++ b/s390x/sie-dat.c
> > @@ -0,0 +1,121 @@
> >=20
> [...]
> > +
> > +/* keep in sync with TOTAL_PAGE_COUNT in s390x/snippets/c/sie-dat.c */
> > +#define GUEST_TOTAL_PAGE_COUNT 256
>=20
> This (1M) is the maximum snippet size (see snippet_setup_guest), is this =
intentional?

It is by accident the maximum snippet size. It is completely fine to stay a=
t 256 pages when we increase the maximum snippet size.

> In that case the comment is inaccurate, since you'd want to sync it with =
the maximum snippet size.
> You also know the actual snippet size SNIPPET_LEN(c, sie_dat) so I don't =
see why you'd need a define
> at all.

The snippet size is not the same as the number of mapped pages in the guest=
, no?

[...]
> > +
> > +static void test_sie_dat(void)
> > +{
> >=20
> [...]
> > +
> > +     /* the guest will now write to an unmapped address and we check t=
hat this causes a segment translation */
>=20
> I'd prefer "causes a segment translation exception"

OK

[...]
> > diff --git a/s390x/snippets/c/sie-dat.c b/s390x/snippets/c/sie-dat.c
> > new file mode 100644
> > index 000000000000..c9f7af0f3a56
> > --- /dev/null
> > +++ b/s390x/snippets/c/sie-dat.c
[...]
> > +static inline void force_exit(void)
> > +{
> > +     asm volatile("  diag    0,0,0x44\n");
>=20
> Pretty sure the compiler will generate a leading tab, so this will be dou=
bly indented.

Copy-paste artifact, I can remove it.

[...]
> > +{
> > +     uint8_t *invalid_ptr;
> > +
> > +     memset(test_page, 0, sizeof(test_page));
> > +     /* tell the host the page's physical address (we're running DAT o=
ff) */
> > +     force_exit_value((uint64_t)test_page);
> > +
> > +     /* write some value to the page so the host can verify it */
> > +     for (size_t i =3D 0; i < TEST_PAGE_COUNT; i++)
> > +             test_page[i * PAGE_SIZE] =3D 42 + i;
> > +
> > +     /* indicate we've written all pages */
> > +     force_exit();
> > +
> > +     /* the first unmapped address */
> > +     invalid_ptr =3D (uint8_t *)(TOTAL_PAGE_COUNT * PAGE_SIZE);
>=20
> Why not just use an address high enough you know it will not be mapped?
> -1 should do just fine.

I wanted to make sure exactly the right amount of pages is mapped and no mo=
re.

-1 would defeat that purpose.
