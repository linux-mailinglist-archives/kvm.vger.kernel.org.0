Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADA516BB523
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 14:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbjCONtK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 09:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbjCONs5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 09:48:57 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FA79E530;
        Wed, 15 Mar 2023 06:48:30 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32FDkJsl015648;
        Wed, 15 Mar 2023 13:48:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=iCOz6Ar6Q3g92BPZSKv52XzR3iBWhzJQfPC5li74sKw=;
 b=p89XdMTJnHVSmtWC3HGb66hN07mNKwYIvbO7XTZkNzJ2QIgRGKic4KmXIg/LJw17zZAF
 eDOalYPYsUb7bvpz1OiS/vYpE4Nmp4XO8PmXUQ87EyueY8R1uUry42d3SBwNpc3XEjz6
 f9v0+O3ZyCXpXp7QnvY9SDmpm7B1H5P4rCNKAqJXSjxbKohHCTFQeh4wTXRCSs+rU/Ym
 0CBgpn7PFPQt6zqGcVwhRll9zz8l6S0uIeC38YA/b6lilfbhJ9G0D7zem+QnXAaqiyY4
 sg+8aabc000unV7AHybv2HljsD8K3fmzguk1OGiAzZBP/GoDPHZ3q7cIWiEUpljmHklc 3w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbbqnpbuv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 13:48:15 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32FDNTY6004923;
        Wed, 15 Mar 2023 13:48:15 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbbqnpbuc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 13:48:15 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32FDh8sY008598;
        Wed, 15 Mar 2023 13:48:13 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3pb29sguxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Mar 2023 13:48:13 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32FDmAkO18547432
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 13:48:10 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2FEA2004B;
        Wed, 15 Mar 2023 13:48:09 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B001920043;
        Wed, 15 Mar 2023 13:48:09 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.152.224.238])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 15 Mar 2023 13:48:09 +0000 (GMT)
Message-ID: <117150729a6e95bb5cd4e0aa91e276d426292b1f.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 2/3] s390x/spec_ex: Add test
 introducing odd address into PSW
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Wed, 15 Mar 2023 14:48:09 +0100
In-Reply-To: <20230314162155.45e8c6f1@p-imbrenda>
References: <20230221174822.1378667-1-nsg@linux.ibm.com>
         <20230221174822.1378667-3-nsg@linux.ibm.com>
         <20230314162155.45e8c6f1@p-imbrenda>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5bAHdCre3gcaCns4Nv5SAZfItvmJj_IU
X-Proofpoint-ORIG-GUID: KnZX8PJck1ZMQVahcrDKn-2vXFAhAyOk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-15_06,2023-03-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 adultscore=0 impostorscore=0 suspectscore=0 priorityscore=1501
 malwarescore=0 clxscore=1015 spamscore=0 mlxlogscore=999
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2302240000 definitions=main-2303150114
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2023-03-14 at 16:21 +0100, Claudio Imbrenda wrote:
> On Tue, 21 Feb 2023 18:48:21 +0100
> Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:
>=20
> > Instructions on s390 must be halfword aligned.
> > Introducing an odd instruction address into the PSW leads to a
> > specification exception when attempting to execute the instruction at
> > the odd address.
> > Add a test for this.
> >=20
> > Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> > ---
> >  s390x/spec_ex.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 49 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
> > index 2adc5996..a26c56aa 100644
> > --- a/s390x/spec_ex.c
> > +++ b/s390x/spec_ex.c
> > @@ -88,12 +88,23 @@ static void expect_invalid_psw(struct psw psw)
> >  	invalid_psw_expected =3D true;
> >  }
> > =20
> > +static void clear_invalid_psw(void)
> > +{
> > +	expected_psw =3D PSW(0, 0);
> > +	invalid_psw_expected =3D false;
> > +}
> > +
> >  static int check_invalid_psw(void)
> >  {
> >  	/* Since the fixup sets this to false we check for false here. */
> >  	if (!invalid_psw_expected) {
> > +		/*
> > +		 * Early exception recognition: pgm_int_id =3D=3D 0.
> > +		 * Late exception recognition: psw address has been
> > +		 *	incremented by pgm_int_id (unpredictable value)
> > +		 */
> >  		if (expected_psw.mask =3D=3D invalid_psw.mask &&
> > -		    expected_psw.addr =3D=3D invalid_psw.addr)
> > +		    expected_psw.addr =3D=3D invalid_psw.addr - lowcore.pgm_int_id)
> >  			return 0;
> >  		report_fail("Wrong invalid PSW");
> >  	} else {
> > @@ -112,6 +123,42 @@ static int psw_bit_12_is_1(void)
> >  	return check_invalid_psw();
> >  }
> > =20
> > +extern char misaligned_code[];
> > +asm (  ".balign	2\n"
>=20
> which section will this end up in?

.text
>=20
> > +"	. =3D . + 1\n"
> > +"misaligned_code:\n"
> > +"	larl	%r0,0\n"
> > +"	bcr	0xf,%r1\n"
>=20
> you should just use
>         br %r1
> it's shorter and easier to understand

Yes.
>=20
> > +);
> > +
> > +static int psw_odd_address(void)
> > +{
> > +	struct psw odd =3D PSW_WITH_CUR_MASK((uint64_t)&misaligned_code);
> > +	uint64_t executed_addr;
> > +
> > +	expect_invalid_psw(odd);
> > +	fixup_psw.mask =3D extract_psw_mask();
> > +	asm volatile ( "xr	%%r0,%%r0\n"
> > +		"	larl	%%r1,0f\n"
> > +		"	stg	%%r1,%[fixup_addr]\n"
> > +		"	lpswe	%[odd_psw]\n"
> > +		"0:	lr	%[executed_addr],%%r0\n"
> > +	: [fixup_addr] "=3D&T" (fixup_psw.addr),
> > +	  [executed_addr] "=3Dd" (executed_addr)
> > +	: [odd_psw] "Q" (odd)
> > +	: "cc", "%r0", "%r1"
> > +	);
> > +
> > +	if (!executed_addr) {
> > +		return check_invalid_psw();
> > +	} else {
> > +		assert(executed_addr =3D=3D odd.addr);
> > +		clear_invalid_psw();
> > +		report_fail("did not execute unaligned instructions");
> > +		return 1;
> > +	}
> > +}
> > +
> >  /* A short PSW needs to have bit 12 set to be valid. */
> >  static int short_psw_bit_12_is_0(void)
> >  {
> > @@ -170,6 +217,7 @@ struct spec_ex_trigger {
> >  static const struct spec_ex_trigger spec_ex_triggers[] =3D {
> >  	{ "psw_bit_12_is_1", &psw_bit_12_is_1, false, &fixup_invalid_psw },
> >  	{ "short_psw_bit_12_is_0", &short_psw_bit_12_is_0, false, &fixup_inva=
lid_psw },
> > +	{ "psw_odd_address", &psw_odd_address, false, &fixup_invalid_psw },
> >  	{ "bad_alignment", &bad_alignment, true, NULL },
> >  	{ "not_even", &not_even, true, NULL },
> >  	{ NULL, NULL, false, NULL },
>=20

