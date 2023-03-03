Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 980626A95A1
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 11:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbjCCKyq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 05:54:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbjCCKyp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 05:54:45 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4511CAEF;
        Fri,  3 Mar 2023 02:54:44 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 323AfsJc004382;
        Fri, 3 Mar 2023 10:54:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=6cK9MpnF8a6bt85ADaPK86Tx2xWBKaHYSNQA+tVaEJE=;
 b=BgGi6oS8ZjyZQff1UdW36MQUW0rcAZXmGDw5mJkdXm5sEsKKWqFlzJ2qg/Z2vYCdThvZ
 nN97eAzNfYGdbJDXRuQB5YlxxYkp/VXh0VfbfmAwCHOFygb5C5Tu+/mEnR+R3hluXYhZ
 NUBqk47Fmdm7LYVH1YmRX/SL3ASMCnKmML6kBJsXiGieZ3SKXGL+mAE4F5LjwGFIF34P
 U3XEhgbhapKfN52UYGOH7WqykIKVQ0OMrXgTenr8ynKX9cXtgAq8oVPmb1j/jwiwFF8F
 F1RnDn4UDDsLtTTw3yrL0aH5d+Bl3oFQpOc+kjA1JVl1sOVRoc56/VBQVo9rPUsH6DS7 9g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p3fc889p0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Mar 2023 10:54:43 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 323AgE0s006694;
        Fri, 3 Mar 2023 10:54:43 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p3fc889n5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Mar 2023 10:54:43 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 322FPFAX024684;
        Fri, 3 Mar 2023 10:54:41 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3nybdfw8e8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Mar 2023 10:54:40 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 323AsaCr19857914
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Mar 2023 10:54:36 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B3CC20040;
        Fri,  3 Mar 2023 10:54:36 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B69C2004B;
        Fri,  3 Mar 2023 10:54:36 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.131.5])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  3 Mar 2023 10:54:36 +0000 (GMT)
Message-ID: <c38bfb32edd3962cf522609b27bc8e9475ba9d0f.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3] s390x: Add tests for execute-type
 instructions
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Fri, 03 Mar 2023 11:54:36 +0100
In-Reply-To: <4e64cb7a-8503-f242-fd49-10b821e85441@linux.ibm.com>
References: <20230228204403.460107-1-nsg@linux.ibm.com>
         <4e64cb7a-8503-f242-fd49-10b821e85441@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cBpFlUIJm1U1y-lNgCXDQ39FEudhebPI
X-Proofpoint-ORIG-GUID: TdYHyU7RaCz5Sb1S5uaC0EitgoQS3sqv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-03_01,2023-03-03_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303030093
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2023-03-03 at 11:11 +0100, Janosch Frank wrote:
> On 2/28/23 21:44, Nina Schoetterl-Glausch wrote:
> > Test the instruction address used by targets of an execute instruction.
> > When the target instruction calculates a relative address, the result i=
s
> > relative to the target instruction, not the execute instruction.
> >=20
> > Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>=20
> Some small nits below, I can fix that up when picking.
>=20
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

Thanks.

>=20
> > ---
> >=20
> >=20
> [...]
> >   s390x/Makefile      |   1 +
> >   s390x/ex.c          | 169 +++++++++++++++++++++++++++++++++++++++++++=
+
> >   s390x/unittests.cfg |   3 +
> >   .gitlab-ci.yml      |   1 +
> >   4 files changed, 174 insertions(+)
> >   create mode 100644 s390x/ex.c
> >=20
> > diff --git a/s390x/Makefile b/s390x/Makefile
> > index 97a61611..6cf8018b 100644
> > --- a/s390x/Makefile
> > +++ b/s390x/Makefile
> > @@ -39,6 +39,7 @@ tests +=3D $(TEST_DIR)/panic-loop-extint.elf
> >   tests +=3D $(TEST_DIR)/panic-loop-pgm.elf
> >   tests +=3D $(TEST_DIR)/migration-sck.elf
> >   tests +=3D $(TEST_DIR)/exittime.elf
> > +tests +=3D $(TEST_DIR)/ex.elf
> >  =20
> >   pv-tests +=3D $(TEST_DIR)/pv-diags.elf
> >  =20
> > diff --git a/s390x/ex.c b/s390x/ex.c
> > new file mode 100644
> > index 00000000..3a22e496
> > --- /dev/null
> > +++ b/s390x/ex.c
> > @@ -0,0 +1,169 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Copyright IBM Corp. 2023
> > + *
> > + * Test EXECUTE (RELATIVE LONG).
> > + * These instruction execute a target instruction. The target instruct=
ion is formed
>=20
> s/instruction/instructions/ ?

Yes.
>=20
> > + * by reading an instruction from memory and optionally modifying some=
 of its bits.
> > + * The execution of the target instruction is the same as if it was ex=
ecuted
> > + * normally as part of the instruction sequence, except for the instru=
ction
> > + * address and the instruction-length code.
> > + */
> > +
> > +#include <libcflat.h>
> > +
>=20
> [...]
>=20
> > +static void test_larl(void)
> > +{
> > +	uint64_t target, addr;
> > +
> > +	report_prefix_push("LARL");
> > +	asm volatile ( ".pushsection .rodata\n"
> > +		"0:	larl	%[addr],0\n"
> > +		"	.popsection\n"
> > +
> > +		"	larl	%[target],0b\n"
> > +		"	exrl	0,0b\n"
> > +		: [target] "=3Dd" (target),
> > +		  [addr] "=3Dd" (addr)
> > +	);
> > +
> > +	report(target =3D=3D addr, "address calculated relative to LARL");
> > +	report_prefix_pop();
> > +}
> > +
> > +/* LOAD LOGICAL RELATIVE LONG.
> > + * If it is the target of an execute-type instruction, the address is =
relative
> > + * to the LLGFRL.
> > + */
>=20
> This is the only instruction where there's no comment about the execute=
=20
> behavior but it would only make sense that it follows the same address=
=20
> generation rules.

I added CRL first because I overlooked that it *does* specify it's behavior=
 and
decided to keep it in, because why not.
Then checked all the other instructions.
It's a bit wonky, the PoP says:

Operand-Address Generation
...

The signed binary inte-
ger specifies the number of halfwords that is added
to the address of the current instruction (or the
address of the execute-type instruction if the instruc-
tion having the RI2 field is the target of an execute-
type instruction) to form the intermediate value.

So it says *address* not *target* of the execute-type insn.

then:

Branch-Address Generation
...
The branch address is the number of half-
words designated by the RI2 field added to the
address of the relative-branch instruction.
...
In all formats, the sec-
ond addend is the 64-bit address of the branch
instruction. The address of the branch instruction is
the instruction address in the PSW before that
address is updated to address the next sequential
instruction, or it is the address of the target of the
execute-type instruction (EXECUTE or EXECUTE
RELATIVE LONG) if an execute-type instruction is
used.

And everything but LLGFRL explicitly mentions that it is relative to the ta=
rget.
We could mention in the comment that the PoP doesn't explicitly state that,
but the realty is that that's what the machine does.
>=20
> > +static void test_llgfrl(void)
> > +{
> > +	uint64_t target, value;
> > +
> > +	report_prefix_push("LLGFRL");
> > +	asm volatile ( ".pushsection .rodata\n"
> > +		"	.balign	4\n"
> > +		"0:	llgfrl	%[value],0\n"
> > +		"	.popsection\n"
> > +
> > +		"	llgfrl	%[target],0b\n"
> > +		"	exrl	0,0b\n"
> > +		: [target] "=3Dd" (target),
> > +		  [value] "=3Dd" (value)
> > +	);
> > +
> > +	report(target =3D=3D value, "loaded correct value");
> > +	report_prefix_pop();
> > +}
> > +
> > +/*
> > + * COMPARE RELATIVE LONG
> > + * If it is the target of an execute-type instruction, the address is =
relative
> > + * to the CRL.
> > + */
> > +static void test_crl(void)
> > +{
> > +	uint32_t program_mask, cc, crl_word;
> > +
> > +	report_prefix_push("CRL");
> > +	asm volatile ( ".pushsection .rodata\n"
> > +		"	.balign	4\n" //operand of crl must be word aligned
>=20
> Just put it on a new line so we don't mix commenting stiles.
> Inline assembly is already hardly readable anyway.

Could also put it in the asm "#operand of crl must be word aligned" but I h=
aven't
seen that anywhere else, and the benefit is negligible.
>=20
> > +		"0:	crl	%[crl_word],0\n"
> > +		"	.popsection\n"
> > +
> > +		"	lrl	%[crl_word],0b\n"
> > +		//align (pad with nop), in case the wrong bad operand is used
> > +		"	.balignw 4,0x0707\n"
> > +		"	exrl	0,0b\n"
> > +		"	ipm	%[program_mask]\n"
> > +		: [program_mask] "=3Dd" (program_mask),
> > +		  [crl_word] "=3Dd" (crl_word)
> > +		:: "cc"
> > +	);
> > +
> > +	cc =3D program_mask >> 28;
> > +	report(!cc, "operand compared to is relative to CRL");
> > +	report_prefix_pop();
> > +}
> > +
> > +int main(int argc, char **argv)
> > +{
> > +	report_prefix_push("ex");
> > +	test_basr();
> > +	test_bras();
> > +	test_larl();
> > +	test_llgfrl();
> > +	test_crl();
> > +	report_prefix_pop();
> > +
> > +	return report_summary();
> > +}
> > diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> > index d97eb5e9..b61faf07 100644
> > --- a/s390x/unittests.cfg
> > +++ b/s390x/unittests.cfg
> > @@ -215,3 +215,6 @@ file =3D migration-skey.elf
> >   smp =3D 2
> >   groups =3D migration
> >   extra_params =3D -append '--parallel'
> > +
> > +[execute]
> > +file =3D ex.elf
> > diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> > index ad7949c9..a999f64a 100644
> > --- a/.gitlab-ci.yml
> > +++ b/.gitlab-ci.yml
> > @@ -275,6 +275,7 @@ s390x-kvm:
> >     - ACCEL=3Dkvm ./run_tests.sh
> >         selftest-setup intercept emulator sieve sthyi diag10 diag308 pf=
mf
> >         cmm vector gs iep cpumodel diag288 stsi sclp-1g sclp-3g css skr=
f sie
> > +      execute
> >         | tee results.txt
> >     - grep -q PASS results.txt && ! grep -q FAIL results.txt
> >    only:
> >=20
> > base-commit: e3c5c3ef2524c58023073c0fadde2e8ae3c04ec6
>=20

