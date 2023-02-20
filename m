Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBE869CF0C
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 15:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbjBTOKc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 09:10:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232738AbjBTOK2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 09:10:28 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25EA1E9FB;
        Mon, 20 Feb 2023 06:10:01 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31KDBiQn031207;
        Mon, 20 Feb 2023 14:09:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=SOFbZWyQDMdRQYS7rUHiG1DGhTtaXwwy2EaC2nW7s9k=;
 b=D5/JrAvL7Lgkqt+BXzdYqcEQ46sbekLES5oVbPKiIjFYWp8U3sXJURx86ypAskSqKvIi
 6XY4a3AcQ6qfTw0Ryi3m5x1mmc9+HGAjWmLWhvURTenUnjxRmEuppPOtYHaqiQSgIzO5
 fe2mrOkj01bP1f/ExLsk3iK5y3yLe4DxUcVcVDWxVF+KgbWQWmNUXnfJ7SVhgsNEZ0kF
 HMdUZ/0ge+H2f2PIFTS88n3JYSIzxHFuUEf01IOYyjmPqgzYDEJ4XLh+HJH81zBExwqZ
 LMfB6oorDMZ9gI7qydwyK3kmUKt5zd9BCyfFjH9n533I6bnRaGeEc4t0KvWXf7huVTRT uA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nv9hghcf4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Feb 2023 14:09:36 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31KDD70P001689;
        Mon, 20 Feb 2023 14:09:36 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nv9hghce0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Feb 2023 14:09:36 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31K6s2vT018299;
        Mon, 20 Feb 2023 14:09:34 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3ntpa62356-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Feb 2023 14:09:33 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31KE9U1936700620
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Feb 2023 14:09:30 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D2D020043;
        Mon, 20 Feb 2023 14:09:30 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0856420040;
        Mon, 20 Feb 2023 14:09:30 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.134.87])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 20 Feb 2023 14:09:29 +0000 (GMT)
Message-ID: <f290bd18f33203def9da4f76082b0cc4dcaa1eed.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 1/2] s390x/spec_ex: Add test
 introducing odd address into PSW
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Mon, 20 Feb 2023 15:09:29 +0100
In-Reply-To: <20230217120516.13db2aa2@p-imbrenda>
References: <20230215171852.1935156-1-nsg@linux.ibm.com>
         <20230215171852.1935156-2-nsg@linux.ibm.com>
         <20230217120516.13db2aa2@p-imbrenda>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RKGEdOfWVLK62W0t0Sl3XsmQ9F6Yw_ZJ
X-Proofpoint-GUID: WM3s4Iz8Po7MGefgpMQPmlpJhO53iwEZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-20_12,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 mlxscore=0 suspectscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0
 clxscore=1015 priorityscore=1501 spamscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302200128
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2023-02-17 at 12:05 +0100, Claudio Imbrenda wrote:
> On Wed, 15 Feb 2023 18:18:51 +0100
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
> >  s390x/spec_ex.c | 73 ++++++++++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 69 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
> > index 42ecaed3..b6764677 100644
> > --- a/s390x/spec_ex.c
> > +++ b/s390x/spec_ex.c
> > @@ -44,9 +44,10 @@ static void fixup_invalid_psw(struct stack_frame_int=
 *stack)
> >  /*
> >   * Load possibly invalid psw, but setup fixup_psw before,
> >   * so that fixup_invalid_psw() can bring us back onto the right track.
> > + * The provided argument is loaded into register 1.
> >   * Also acts as compiler barrier, -> none required in expect/check_inv=
alid_psw
> >   */
> > -static void load_psw(struct psw psw)
> > +static void load_psw_with_arg(struct psw psw, uint64_t arg)
> >  {
> >  	uint64_t scratch;
> > =20
> > @@ -57,15 +58,22 @@ static void load_psw(struct psw psw)
> >  	fixup_psw.mask =3D extract_psw_mask();
> >  	asm volatile ( "larl	%[scratch],0f\n"
> >  		"	stg	%[scratch],%[fixup_addr]\n"
> > +		"	lgr	%%r1,%[arg]\n"
> >  		"	lpswe	%[psw]\n"
> >  		"0:	nop\n"
> >  		: [scratch] "=3D&d" (scratch),
> >  		  [fixup_addr] "=3D&T" (fixup_psw.addr)
> > -		: [psw] "Q" (psw)
> > -		: "cc", "memory"
> > +		: [psw] "Q" (psw),
> > +		  [arg] "d" (arg)
> > +		: "cc", "memory", "%r1"
> >  	);
> >  }
> > =20
> > +static void load_psw(struct psw psw)
> > +{
> > +	load_psw_with_arg(psw, 0);
> > +}
> > +
> >  static void load_short_psw(struct short_psw psw)
> >  {
> >  	uint64_t scratch;
> > @@ -88,12 +96,18 @@ static void expect_invalid_psw(struct psw psw)
> >  	invalid_psw_expected =3D true;
> >  }
> > =20
> > +static void clear_invalid_psw(void)
> > +{
> > +	expected_psw =3D (struct psw){0};
>=20
> as of today, you can use PSW(0, 0)  :)
>=20
> > +	invalid_psw_expected =3D false;
> > +}
> > +
> >  static int check_invalid_psw(void)
> >  {
> >  	/* Since the fixup sets this to false we check for false here. */
> >  	if (!invalid_psw_expected) {
> >  		if (expected_psw.mask =3D=3D invalid_psw.mask &&
> > -		    expected_psw.addr =3D=3D invalid_psw.addr)
> > +		    expected_psw.addr =3D=3D invalid_psw.addr - lowcore.pgm_int_id)
>=20
> can you explain this change?

In the existing invalid PSW tests, the instruction length code is 0, so no
change there. In case of an odd address being introduced into the PSW, the
address is incremented by an unpredictable amount, the subtraction removes =
that.
>=20
> >  			return 0;
> >  		report_fail("Wrong invalid PSW");
> >  	} else {
> > @@ -115,6 +129,56 @@ static int psw_bit_12_is_1(void)
> >  	return check_invalid_psw();
> >  }
> > =20
> > +static int psw_odd_address(void)
> > +{
> > +	struct psw odd =3D {
>=20
> now you can use PSW_WITH_CUR_MASK(0) here
>=20
> > +		.mask =3D extract_psw_mask(),
> > +	};
> > +	uint64_t regs[16];
> > +	int r;
> > +
> > +	/*
> > +	 * This asm is reentered at an odd address, which should cause a spec=
ification
> > +	 * exception before the first unaligned instruction is executed.
> > +	 * In this case, the interrupt handler fixes the address and the test=
 succeeds.
> > +	 * If, however, unaligned instructions *are* executed, they are jumpe=
d to
> > +	 * from somewhere, with unknown registers, so save and restore those =
before.
> > +	 */
>=20
> I wonder if this could be simplified
>=20
> > +	asm volatile ( "stmg	%%r0,%%r15,%[regs]\n"
> > +		//can only offset by even number when using larl -> increment by one
> > +		"	larl	%[r],0f\n"
> > +		"	aghi	%[r],1\n"
> > +		"	stg	%[r],%[addr]\n"
>=20
> the above is ok (set up illegal PSW)
>=20
> (maybe call expect_invalid_psw here, see comments below)
>=20
> put the address of the exit label in a register
>=20
> then do a lpswe here to jump to the invalid PSW
>=20
> > +		"	xr	%[r],%[r]\n"
> > +		"	brc	0xf,1f\n"
>=20
> then do the above. that will only happen if the PSW was not loaded.
>=20
> > +		"0:	. =3D . + 1\n"
>=20
> if we are here, things went wrong.
> write something in r, jump to the exit label (using the address in the
> register that we saved earlier)
>=20
> > +		"	lmg	%%r0,%%r15,0(%%r1)\n"
> > +		//address of the instruction itself, should be odd, store for assert
> > +		"	larl	%[r],0\n"
> > +		"	stg	%[r],%[addr]\n"
> > +		"	larl	%[r],0f\n"
> > +		"	aghi	%[r],1\n"
> > +		"	bcr	0xf,%[r]\n"
> > +		"0:	. =3D . + 1\n"
> > +		"1:\n"
> > +	: [addr] "=3DT" (odd.addr),
> > +	  [regs] "=3DQ" (regs),
> > +	  [r] "=3Dd" (r)
> > +	: : "cc", "memory"
> > +	);
> > +
>=20
> if we come out here and r is 0, then things went well, otherwise we
> fail.
>=20
> > +	if (!r) {
> > +		expect_invalid_psw(odd);
>=20
> that ^ should probably go before the asm (or _in_ the asm, maybe you
> can call the C function from asm)
>=20
> > +		load_psw_with_arg(odd, (uint64_t)&regs);
>=20
> this would not be needed anymore ^
>=20
>=20
> this way you don't need to save registers or do crazy things where you
> jump back in the middle of the asm from C code. and then you don't even
> need load_psw_with_arg
>=20
I'll see what I can do.
>=20
> > +		return check_invalid_psw();
> > +	} else {
> > +		assert(odd.addr & 1);
> > +		clear_invalid_psw();
> > +		report_fail("executed unaligned instructions");
> > +		return 1;
> > +	}
> > +}
> > +
> >  /* A short PSW needs to have bit 12 set to be valid. */
> >  static int short_psw_bit_12_is_0(void)
> >  {
> > @@ -176,6 +240,7 @@ struct spec_ex_trigger {
> >  static const struct spec_ex_trigger spec_ex_triggers[] =3D {
> >  	{ "psw_bit_12_is_1", &psw_bit_12_is_1, false, &fixup_invalid_psw },
> >  	{ "short_psw_bit_12_is_0", &short_psw_bit_12_is_0, false, &fixup_inva=
lid_psw },
> > +	{ "psw_odd_address", &psw_odd_address, false, &fixup_invalid_psw },
> >  	{ "bad_alignment", &bad_alignment, true, NULL },
> >  	{ "not_even", &not_even, true, NULL },
> >  	{ NULL, NULL, false, NULL },
>=20

