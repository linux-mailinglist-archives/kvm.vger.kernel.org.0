Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9E16A5796
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 12:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbjB1LPx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 06:15:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjB1LPv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 06:15:51 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A755A261;
        Tue, 28 Feb 2023 03:15:50 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31SBFldD003899;
        Tue, 28 Feb 2023 11:15:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=zpepEbiRj4d/L6MHp96Uk2OvaFfDpznnrofZZ99nkVo=;
 b=S4wvytwvHadKXgUNw7ZrQCiwdNrmXhCfooh0ljXnx6QBWIXgbS7gm0ZQJSHMSiX5JXEF
 SoifogffHgtp7qrOACWvrkwyJ4g8zJHQgMiT1+19UR4Mlekae7E5AQ/ym5hHTWeDzS4b
 qOcCU20ZRdrqjBXEcXt1kJYMbOXT6Ir0JjVXVxqxbjNWSr0BVEWm/7fz+53Lu5Db2JaB
 AEMluX8P7rY3e4OQcNnJFh1NI/BQcgiW8e86hMFO7vVeXXPAIbEvbs7Ge2wi8p/V+AgC
 V2sD5ruClol8nY1I1fiezj62vBlTa9RRjI77PCmGzbCRl3JkF3dID3nFE6DQpKWB8Xyy rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p1gk8002m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Feb 2023 11:15:49 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31SBFmCi003970;
        Tue, 28 Feb 2023 11:15:48 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p1gk8001c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Feb 2023 11:15:48 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31S5hcgi026495;
        Tue, 28 Feb 2023 11:15:46 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3nybb4k0b4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Feb 2023 11:15:46 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31SBFfcN64225718
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Feb 2023 11:15:41 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8EBC12004E;
        Tue, 28 Feb 2023 11:15:41 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CC6F2004B;
        Tue, 28 Feb 2023 11:15:41 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.150.216])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 28 Feb 2023 11:15:41 +0000 (GMT)
Message-ID: <b516b8779c9a5f7a98683eb6e56e79b5e32016e7.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2] s390x: Add tests for execute-type
 instructions
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Tue, 28 Feb 2023 12:15:41 +0100
In-Reply-To: <0d48cb35-738a-af5e-419a-5827dc6e3531@linux.ibm.com>
References: <20230224152015.2943564-1-nsg@linux.ibm.com>
         <0d48cb35-738a-af5e-419a-5827dc6e3531@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: h15lxRY5goY6BL0mx1gb-ZsR29yx_YBB
X-Proofpoint-ORIG-GUID: CMBtXN0MlNZ-AfOBU_0XaPfbkT9aLq7Z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-28_06,2023-02-28_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 mlxscore=0 clxscore=1015 impostorscore=0 adultscore=0 priorityscore=1501
 bulkscore=0 malwarescore=0 suspectscore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302280089
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2023-02-27 at 16:44 +0100, Janosch Frank wrote:
> On 2/24/23 16:20, Nina Schoetterl-Glausch wrote:
> > Test the instruction address used by targets of an execute instruction.
> > When the target instruction calculates a relative address, the result i=
s
> > relative to the target instruction, not the execute instruction.
>=20
> For instructions like execute where the details matter it's a great idea=
=20
> to have a lot of comments maybe even loose references to the PoP so=20
> people can read up on the issue more easily.
>=20
>=20
> >=20
> > Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> > Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
> > ---
> >=20
> >=20
> > v1 -> v2:
> >   * add test to unittests.cfg and .gitlab-ci.yml
> >   * pick up R-b (thanks Nico)
> >=20
> >=20
> > TCG does the address calculation relative to the execute instruction.
>=20
> Always?

AFAIK yes. Everything that has an operand that is relative to the instructi=
on
given by the immediate in the instruction and goes through in2_ri2 in TCG
will have this problem, because in2_ri2 does the calculation relative to pc=
_next
which is the address of the EX(RL).
That should make fixing it easier tho.

> I.e. what are you telling me here?
>=20
> >=20
> >=20
> >   s390x/Makefile      |  1 +
> >   s390x/ex.c          | 92 ++++++++++++++++++++++++++++++++++++++++++++=
+
> >   s390x/unittests.cfg |  3 ++
> >   .gitlab-ci.yml      |  1 +
> >   4 files changed, 97 insertions(+)
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
> > index 00000000..1bf4d8cd
> > --- /dev/null
> > +++ b/s390x/ex.c
> > @@ -0,0 +1,92 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Copyright IBM Corp. 2023
> > + *
> > + * Test EXECUTE (RELATIVE LONG).
> > + */
> > +
> > +#include <libcflat.h>
> > +
>=20
> Take my words with some salt, I never had a close look at the branch=20
> instructions other than brc.
>=20
> This is "branch and save" and the "r" in "basr" says that it's the RR=20
> variant. It's not relative the way that "bras" is, right?

Yes, it isn't. It's so there are tests for different address generations
that are a function of the current instruction address.

>=20
> Hence ret_addr and after_ex both point to 1f.
>=20
> I'd like to have a comment here that states that this is not a relative=
=20
> branch at all. The r specifies the instruction format.

Yeah, will do.
>=20
> > +static void test_basr(void)
> > +{
> > +	uint64_t ret_addr, after_ex;
> > +
> > +	report_prefix_push("BASR");
> > +	asm volatile ( ".pushsection .rodata\n"
> > +		"0:	basr	%[ret_addr],0\n"
> > +		"	.popsection\n"
> > +
> > +		"	larl	%[after_ex],1f\n"
> > +		"	exrl	0,0b\n"
> > +		"1:\n"
> > +		: [ret_addr] "=3Dd" (ret_addr),
> > +		  [after_ex] "=3Dd" (after_ex)
> > +	);
> > +
> > +	report(ret_addr =3D=3D after_ex, "return address after EX");
> > +	report_prefix_pop();
> > +}
> > +
> > +/*
> > + * According to PoP (Branch-Address Generation), the address is relati=
ve to
> > + * BRAS when it is the target of an execute-type instruction.
> > + */
>=20
> Is there any merit in testing the other br* instructions as well or are=
=20
> they running through the same TCG function?

Well, there is in the sense that it's better not to make assumptions about =
the
implementation, but given the above it shouldn't make a difference in pract=
ice,
unless my understanding is wrong or I'm missing some special case.

>=20
> > +static void test_bras(void)
> > +{
> > +	uint64_t after_target, ret_addr, after_ex, branch_addr;
> > +
> > +	report_prefix_push("BRAS");
> > +	asm volatile ( ".pushsection .text.ex_bras, \"x\"\n"
> > +		"0:	bras	%[ret_addr],1f\n"
> > +		"	nopr	%%r7\n"
> > +		"1:	larl	%[branch_addr],0\n"
> > +		"	j	4f\n"
> > +		"	.popsection\n"
> > +
> > +		"	larl	%[after_target],1b\n"
> > +		"	larl	%[after_ex],3f\n"
> > +		"2:	exrl	0,0b\n"
> > +		"3:	larl	%[branch_addr],0\n"
> > +		"4:\n"
> > +
> > +		"	.if (1b - 0b) !=3D (3b - 2b)\n"
> > +		"	.error	\"right and wrong target must have same offset\"\n"
> > +		"	.endif\n"
> > +		: [after_target] "=3Dd" (after_target),
> > +		  [ret_addr] "=3Dd" (ret_addr),
> > +		  [after_ex] "=3Dd" (after_ex),
> > +		  [branch_addr] "=3Dd" (branch_addr)
> > +	);
> > +
> > +	report(after_target =3D=3D branch_addr, "address calculated relative =
to BRAS");
> > +	report(ret_addr =3D=3D after_ex, "return address after EX");
> > +	report_prefix_pop();
> > +}
> > +
>=20
> Add:
> /* larl follows the address generation of relative branch instructions */

Yes, will also add another test for a relative immediate instruction that
doesn't explicitly state the same in the description.

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
> > +int main(int argc, char **argv)
> > +{
>=20
> We're missing push and pop around the test function block so that we=20
> know which file generated the output.
>=20
> report_prefix_push("execute");
>=20
> > +	test_basr();
> > +	test_bras();
> > +	test_larl();
>=20
> report_prefix_pop();
>=20
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

