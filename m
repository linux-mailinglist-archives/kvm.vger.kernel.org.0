Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7E286BE748
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 11:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbjCQKvz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 06:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCQKvx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 06:51:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FA9D5896;
        Fri, 17 Mar 2023 03:51:50 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32HAjK4x004320;
        Fri, 17 Mar 2023 10:51:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=8ge7y/Zs6h9bw2sCZ4qgnnVqfhXx6jQkn1MdSknpzrU=;
 b=WppX9TBHrlmPWfiROod0fE7gLRwxn0CkI0ltPBx1KWj3vaYTiVRoCLS2ZAj+4LPUjbpN
 y2KQJx1hJqNxKno3TJttbTT6ZUH0iTlQOoZk3eSyAfg7ebUPNI4dodD3zrvfPKw0O/+M
 0zE9UFSQB+vw0GTIshvUSxzm/TnS44Dxcp1Qb0zO01B7uYxTLugy2+1J17hPHCI/XEdr
 5Z1J28pXsjSC339829yZmFO4Co1i1hTzpxGq9n9nfJetK0L9Xt8RabDW1CXeumv4xDtc
 KGvFopsHeFGw+RpovorrMKGbpeeLNAMuLs0pS8WCpvQv/f2NqvqVjj8irlWEyQdG+FhT 4A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pcpqnr3ph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Mar 2023 10:51:50 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32HAk4er007125;
        Fri, 17 Mar 2023 10:51:49 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pcpqnr3nu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Mar 2023 10:51:49 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32GI9XYH008209;
        Fri, 17 Mar 2023 10:51:47 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3pbsu7hnax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Mar 2023 10:51:47 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32HAphjD11338472
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 10:51:44 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA7E12004D;
        Fri, 17 Mar 2023 10:51:43 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA00320043;
        Fri, 17 Mar 2023 10:51:43 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.183.28])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 17 Mar 2023 10:51:43 +0000 (GMT)
Message-ID: <fb8fa41ddef9aff66c2ea0facf5bc2a6315e2c0e.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 2/3] s390x/spec_ex: Add test
 introducing odd address into PSW
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Fri, 17 Mar 2023 11:51:43 +0100
In-Reply-To: <b6705072-de79-614d-d5fc-c78f1b65196f@linux.ibm.com>
References: <20230315155445.1688249-1-nsg@linux.ibm.com>
         <20230315155445.1688249-3-nsg@linux.ibm.com>
         <b6705072-de79-614d-d5fc-c78f1b65196f@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PDjqclGrGZpbKdeV27t_PaNezPVNR05p
X-Proofpoint-ORIG-GUID: LPpzUaSWSW-hCel-GLHjAvk6Lq-mtmVS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-17_06,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 mlxscore=0 spamscore=0 suspectscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303170071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2023-03-17 at 10:26 +0100, Janosch Frank wrote:
> On 3/15/23 16:54, Nina Schoetterl-Glausch wrote:
> > Instructions on s390 must be halfword aligned.
> > Introducing an odd instruction address into the PSW leads to a
> > specification exception when attempting to execute the instruction at
> > the odd address.
> > Add a test for this.
> >=20
> > Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>=20
> Acked-by: Janosch Frank <frankja@linux.ibm.com>
>=20
> Some nits below.
>=20
> > ---
> >   s390x/spec_ex.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++++=
-
> >   1 file changed, 49 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
> > index 2adc5996..83b8c58e 100644
> > --- a/s390x/spec_ex.c
> > +++ b/s390x/spec_ex.c
> > @@ -88,12 +88,23 @@ static void expect_invalid_psw(struct psw psw)
> >   	invalid_psw_expected =3D true;
> >   }
> >  =20
> > +static void clear_invalid_psw(void)
> > +{
> > +	expected_psw =3D PSW(0, 0);
> > +	invalid_psw_expected =3D false;
> > +}
> > +
> >   static int check_invalid_psw(void)
> >   {
> >   	/* Since the fixup sets this to false we check for false here. */
> >   	if (!invalid_psw_expected) {
> > +		/*
> > +		 * Early exception recognition: pgm_int_id =3D=3D 0.
> > +		 * Late exception recognition: psw address has been
> > +		 *	incremented by pgm_int_id (unpredictable value)
> > +		 */
> >   		if (expected_psw.mask =3D=3D invalid_psw.mask &&
> > -		    expected_psw.addr =3D=3D invalid_psw.addr)
> > +		    expected_psw.addr =3D=3D invalid_psw.addr - lowcore.pgm_int_id)
> >   			return 0;
> >   		report_fail("Wrong invalid PSW");
> >   	} else {
> > @@ -112,6 +123,42 @@ static int psw_bit_12_is_1(void)
> >   	return check_invalid_psw();
> >   }
> >  =20
> > +extern char misaligned_code[];
> > +asm (  ".balign	2\n"
>=20
> Is the double space intended?

Yes, so stuff lines up.
> Looking at the file itself some asm blocks have no space before the "("=
=20
> and some have one.

In spec_ex.c? Where?

>=20
> > +"	. =3D . + 1\n"
> > +"misaligned_code:\n"
> > +"	larl	%r0,0\n"
> > +"	br	%r1\n"
> > +);
>=20
> Any reason this is not indented?

You mean the whole asm block, so it looks more like a function body to the =
misaligned_code symbol?
I'm indifferent about it, can do that if you think it's nicer.

>=20
> > +
> > +static int psw_odd_address(void)
> > +{
> > +	struct psw odd =3D PSW_WITH_CUR_MASK((uint64_t)&misaligned_code);
> > +	uint64_t executed_addr;
> > +
> > +	expect_invalid_psw(odd);
> > +	fixup_psw.mask =3D extract_psw_mask();
> > +	asm volatile ( "xr	%%r0,%%r0\n"
>=20
> While it will likely never make a difference I'd still use xgr here=20
> instead of xr.

Yes, needs xgr.
>=20
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
> >   /* A short PSW needs to have bit 12 set to be valid. */
> >   static int short_psw_bit_12_is_0(void)
> >   {
> > @@ -170,6 +217,7 @@ struct spec_ex_trigger {
> >   static const struct spec_ex_trigger spec_ex_triggers[] =3D {
> >   	{ "psw_bit_12_is_1", &psw_bit_12_is_1, false, &fixup_invalid_psw },
> >   	{ "short_psw_bit_12_is_0", &short_psw_bit_12_is_0, false, &fixup_inv=
alid_psw },
> > +	{ "psw_odd_address", &psw_odd_address, false, &fixup_invalid_psw },
> >   	{ "bad_alignment", &bad_alignment, true, NULL },
> >   	{ "not_even", &not_even, true, NULL },
> >   	{ NULL, NULL, false, NULL },
>=20

