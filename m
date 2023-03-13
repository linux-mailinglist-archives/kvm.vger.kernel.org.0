Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D88676B856A
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 23:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjCMW4J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 18:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjCMWzv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 18:55:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22ED92BE1;
        Mon, 13 Mar 2023 15:55:14 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32DKV8pL004034;
        Mon, 13 Mar 2023 22:45:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=fbyf9OUU/YPPSXB9llJZh1EYAaEfBal+Tbf5i0+cBxk=;
 b=KhkzeGNS3NIE0OCGxned/cDMqYs1brpI8gioQHcBG6+ZlDgfoRdASgS2o/EZXpFwbuOF
 UuX8GAc07LRvnMp9Zw+FDO1rUl/sdH6z2scj8iHoXgCEc5T5CuTEHhCNelXiv4BvC9kZ
 JbcK/R0WTXWCFaHnlX4UHcwSSJTpbtk2J6TRE5S9oHsbjCKchEXRbmqKwo3VER8CX/o+
 aoyT/jPwn2MxpP0eFT5cC96KxdAw6f8HukZuZMRzamnSe/7G/GgLcuhu3xxYQa++U7IG
 YG/T41AbncShDBirnItfTr6GkjTfTxy8D6ksnTUVs8EQ3osKBSEx95w9pITFK82ER4nz dA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pa5ubkxa1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Mar 2023 22:45:39 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32DMhVLa030081;
        Mon, 13 Mar 2023 22:45:39 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pa5ubkx9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Mar 2023 22:45:39 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32DCvi5g015761;
        Mon, 13 Mar 2023 22:45:37 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3p8h96k320-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Mar 2023 22:45:37 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32DMjY1G47513942
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Mar 2023 22:45:34 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 054312005A;
        Mon, 13 Mar 2023 22:45:34 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C90A42004B;
        Mon, 13 Mar 2023 22:45:33 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.219.71])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 13 Mar 2023 22:45:33 +0000 (GMT)
Message-ID: <d6471b717f34b6ae664dc91331246e9676d8c879.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v5] s390x: Add tests for execute-type
 instructions
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Mon, 13 Mar 2023 23:45:33 +0100
In-Reply-To: <20230313191602.58b16c31@p-imbrenda>
References: <20230310181131.2138736-1-nsg@linux.ibm.com>
         <20230313191602.58b16c31@p-imbrenda>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tPjbXk4HNQy9GmnsITndE-e_7-hPSr9X
X-Proofpoint-ORIG-GUID: K4nwcn7ob-Xe5GkUMvsC7bQ3sSN_9Enx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-13_11,2023-03-13_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 phishscore=0 mlxscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303130177
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2023-03-13 at 19:16 +0100, Claudio Imbrenda wrote:
> On Fri, 10 Mar 2023 19:11:31 +0100
> Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:
>=20
> > Test the instruction address used by targets of an execute instruction.
> > When the target instruction calculates a relative address, the result i=
s
> > relative to the target instruction, not the execute instruction.
> >=20
> > Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> > Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> > ---
> >=20
> >=20
> > v4 -> v5:
> >  * word align the execute-type instruction, preventing a specification
> >    exception if the address calculation is wrong, since LLGFRL requires
> >    word alignment
> >  * change wording of comment
> >=20
> > v3 -> v4:
> >  * fix nits (thanks Janosch)
> >  * pickup R-b (thanks Janosch)
> >=20
> > v2 -> v3:
> >  * add some comments (thanks Janosch)
> >  * add two new tests (drop Nico's R-b)
> >  * push prefix
> >=20
> > v1 -> v2:
> >  * add test to unittests.cfg and .gitlab-ci.yml
> >  * pick up R-b (thanks Nico)
> >=20
> >=20
> > TCG does the address calculation relative to the execute instruction.
> > Everything that has an operand that is relative to the instruction give=
n by
> > the immediate in the instruction and goes through in2_ri2 in TCG has th=
is
> > problem, because in2_ri2 does the calculation relative to pc_next which=
 is the
> > address of the EX(RL).
> > That should make fixing it easier tho.
> >=20
> >=20
> > Range-diff against v4:
> > 1:  f29ef634 ! 1:  57f8f256 s390x: Add tests for execute-type instructi=
ons
> >     @@ s390x/ex.c (new)
> >      +		"	.popsection\n"
> >      +
> >      +		"	llgfrl	%[target],0b\n"
> >     ++		//align (pad with nop), in case the wrong operand is used
> >     ++		"	.balignw 4,0x0707\n"
> >      +		"	exrl	0,0b\n"
> >      +		: [target] "=3Dd" (target),
> >      +		  [value] "=3Dd" (value)
> >     @@ s390x/ex.c (new)
> >      +		"	.popsection\n"
> >      +
> >      +		"	lrl	%[crl_word],0b\n"
> >     -+		//align (pad with nop), in case the wrong bad operand is used
> >     ++		//align (pad with nop), in case the wrong operand is used
> >      +		"	.balignw 4,0x0707\n"
> >      +		"	exrl	0,0b\n"
> >      +		"	ipm	%[program_mask]\n"
> >=20
> >  s390x/Makefile      |   1 +
> >  s390x/ex.c          | 172 ++++++++++++++++++++++++++++++++++++++++++++
> >  s390x/unittests.cfg |   3 +
> >  .gitlab-ci.yml      |   1 +
> >  4 files changed, 177 insertions(+)
> >  create mode 100644 s390x/ex.c
> >=20
> > diff --git a/s390x/Makefile b/s390x/Makefile
> > index 97a61611..6cf8018b 100644
> > --- a/s390x/Makefile
> > +++ b/s390x/Makefile
> > @@ -39,6 +39,7 @@ tests +=3D $(TEST_DIR)/panic-loop-extint.elf
> >  tests +=3D $(TEST_DIR)/panic-loop-pgm.elf
> >  tests +=3D $(TEST_DIR)/migration-sck.elf
> >  tests +=3D $(TEST_DIR)/exittime.elf
> > +tests +=3D $(TEST_DIR)/ex.elf
> > =20
> >  pv-tests +=3D $(TEST_DIR)/pv-diags.elf
> > =20
> > diff --git a/s390x/ex.c b/s390x/ex.c
> > new file mode 100644
> > index 00000000..f05f8f90
> > --- /dev/null
> > +++ b/s390x/ex.c
> > @@ -0,0 +1,172 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Copyright IBM Corp. 2023
> > + *
> > + * Test EXECUTE (RELATIVE LONG).
> > + * These instructions execute a target instruction. The target instruc=
tion is formed
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
> > +/*
> > + * BRANCH AND SAVE, register register variant.
> > + * Saves the next instruction address (address from PSW + length of in=
struction)
> > + * to the first register. No branch is taken in this test, because 0 i=
s
> > + * specified as target.
> > + * BASR does *not* perform a relative address calculation with an inte=
rmediate.
> > + */
> > +static void test_basr(void)
> > +{
> > +	uint64_t ret_addr, after_ex;
> > +
> > +	report_prefix_push("BASR");
> > +	asm volatile ( ".pushsection .rodata\n"
>=20
> you use .text.ex_bras in the next test, why not something like that here
> (and everywhere else) too?

In the test below we branch to the code in .text.ex_bras.
In all other tests the instruction in .rodata is just an operand of the exe=
cute instruction,
and it doesn't get modified.
As for the bras test having a suffix, I guess it's pretty arbitrary, but si=
nce it's a handful
of instructions instead of just one, it felt substantial enough to warrant =
one.

>=20
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
> > + * BRANCH RELATIVE AND SAVE.
> > + * According to PoP (Branch-Address Generation), the address calculate=
d relative
> > + * to the instruction address is relative to BRAS when it is the targe=
t of an
> > + * execute-type instruction, not relative to the execute-type instruct=
ion.
> > + */
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
/*
 * In case the address calculation is correct, we jump by the relative offs=
et 1b-0b from 0b to 1b.
 * In case the address calculation is relative to the exrl (i.e. a test fai=
lure),
 * put a valid instruction at the same relative offset from the exrl, so th=
e test continues in a
 * controlled manner.
 */
> > +		"3:	larl	%[branch_addr],0\n"
> > +		"4:\n"
> > +
> > +		"	.if (1b - 0b) !=3D (3b - 2b)\n"
> > +		"	.error	\"right and wrong target must have same offset\"\n"
>=20
> please explain why briefly (i.e. if the wrong target is executed and
> the offset mismatches Bad Things=E2=84=A2 happen)

Ok, see above.

[...]


