Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 543C76ABE31
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 12:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjCFLcH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 06:32:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjCFLcF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 06:32:05 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB3E2823D;
        Mon,  6 Mar 2023 03:31:58 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3269e7gH004554;
        Mon, 6 Mar 2023 11:31:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=a7oZJm4ovOWBneq0xw38a7EoV1aW5HEIK7tFzEvYOVY=;
 b=n0KGz95wM91mCN6EKPT4dVYglTKOkfUyQypLwZYHguY2IrC+YQu8ftZXoHiYrLwoisho
 jiBsk/3t0A4rvGdYX/a8LuHMbV8oSlCIG9P0U/FDHizlJM+SCcU/+eVBO9CATDoZhbsw
 ADjJKOSvVB4iGVr/t/1r6io3pnAGIFeQfG2EuoJTlnU6WwpIgzyEVXp5zAHr8H2DEab0
 W6y9QOCXDGEbt6tdIp/LOboFybg2JUR9lQGlgcO3pOS78w8OEUzKf9c4ybNY/B5uC/cO
 xXHeTw4pythNJJiK0IIWARFja6g91Ey2LuW445tD480JOKORoXnzxEP1TJzgZLH10P1C CA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3p4wsw3tgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Mar 2023 11:31:57 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 326BLMV3002041;
        Mon, 6 Mar 2023 11:31:57 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3p4wsw3tgk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Mar 2023 11:31:57 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3266D2mA008169;
        Mon, 6 Mar 2023 11:31:55 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3p419ka3ev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Mar 2023 11:31:55 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 326BVqk119333770
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Mar 2023 11:31:52 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E81D62004F;
        Mon,  6 Mar 2023 11:31:51 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B6F0D2004E;
        Mon,  6 Mar 2023 11:31:51 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.178.131])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  6 Mar 2023 11:31:51 +0000 (GMT)
Message-ID: <808cb39b3f1b283ca1bc2856e2500e990dc15888.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1] s390x: spec_ex: Add test for
 misaligned load
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Mon, 06 Mar 2023 12:31:51 +0100
In-Reply-To: <20230306115921.520ed44c@p-imbrenda>
References: <20230301132638.3336040-1-nsg@linux.ibm.com>
         <20230306115921.520ed44c@p-imbrenda>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7iowT7OpeiefwhBlVxZNcdKH15V8SMQ2
X-Proofpoint-GUID: UeBTPbXSIvTF-_t_MdHAQRlf7BdlXA5y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_03,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 priorityscore=1501 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303060096
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2023-03-06 at 11:59 +0100, Claudio Imbrenda wrote:
> On Wed,  1 Mar 2023 14:26:38 +0100
> Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:
>=20
> > The operand of LOAD RELATIVE LONG must be word aligned, otherwise a
> > specification exception occurs. Test that this exception occurs.
>=20
> you're only testing halfword misalignment; would it make sense to test
> all possible misalignments? (it's only 3 of them after all)

No, that's not possible, the address calculation is:
insn_addr + immediate * 2

So for LRL there is only one possible misalignment.
For LGRL there are multiple, tho.

>=20
> >=20
> > Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> > ---
> >=20
> >=20
> > Noticed while writing another test that TCG fails this requirement,
> > so thought it best do document this in the form of a test.
> >=20
> >=20
> >  s390x/spec_ex.c | 21 +++++++++++++++++++--
> >  1 file changed, 19 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
> > index 42ecaed3..42e86070 100644
> > --- a/s390x/spec_ex.c
> > +++ b/s390x/spec_ex.c
> > @@ -136,7 +136,7 @@ static int short_psw_bit_12_is_0(void)
> >  	return 0;
> >  }
> > =20
> > -static int bad_alignment(void)
> > +static int bad_alignment_lqp(void)
> >  {
> >  	uint32_t words[5] __attribute__((aligned(16)));
> >  	uint32_t (*bad_aligned)[4] =3D (uint32_t (*)[4])&words[1];
> > @@ -149,6 +149,22 @@ static int bad_alignment(void)
> >  	return 0;
> >  }
> > =20
> > +static int bad_alignment_lrl(void)
> > +{
> > +	uint64_t r;
> > +
> > +	asm volatile ( ".pushsection .rodata\n"
>=20
> why not declare this as a local array?

I cannot put it on the stack, since I need a relative offset.
I guess I could use a global symbol, but that also makes the
test less self-contained.

>=20
> uint8_t stuff[8] __attribute__((aligned(8)));
>=20
> > +		"	.balign	4\n"
> > +		"	. =3D . + 2\n"
> > +		"0:	.fill	4\n"
> > +		"	.popsection\n"
> > +
> > +		"	lrl	%0,0b\n"
> > +		: "=3Dd" (r)
>=20
> and here pass stuff + 1 or something like that?
>=20
> less asm =3D more readable
>=20
> > +	);
> > +	return 0;
> > +}
> > +
> >  static int not_even(void)
> >  {
> >  	uint64_t quad[2] __attribute__((aligned(16))) =3D {0};
> > @@ -176,7 +192,8 @@ struct spec_ex_trigger {
> >  static const struct spec_ex_trigger spec_ex_triggers[] =3D {
> >  	{ "psw_bit_12_is_1", &psw_bit_12_is_1, false, &fixup_invalid_psw },
> >  	{ "short_psw_bit_12_is_0", &short_psw_bit_12_is_0, false, &fixup_inva=
lid_psw },
> > -	{ "bad_alignment", &bad_alignment, true, NULL },
> > +	{ "bad_alignment_lqp", &bad_alignment_lqp, true, NULL },
> > +	{ "bad_alignment_lrl", &bad_alignment_lrl, true, NULL },
> >  	{ "not_even", &not_even, true, NULL },
> >  	{ NULL, NULL, false, NULL },
> >  };
> >=20
> > base-commit: e3c5c3ef2524c58023073c0fadde2e8ae3c04ec6
>=20

