Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6B36D65E3
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 16:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232889AbjDDOy7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 10:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232257AbjDDOy4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 10:54:56 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DAFB422A
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 07:54:30 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 334EnxEx008457;
        Tue, 4 Apr 2023 14:54:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=jZR1C+xcWrB4cUwK/C74u+WITYwiks+wSfYSKPQChEI=;
 b=pLsviuMIeRcjkbMPIZFDLwZ4BSUZr08xrb6ZqBvXGBNPMLXfOb/GsrHOvhm/7ri1uHcp
 +GJTHb0/hYc+++euxhOH8KUyyo77qPt4OgfgCPKpULYD7Kt/FmbpnFq+i91mxxER3Yn3
 fL+mwQQKJMG1WNxRo16cJSXKGB1tb06/DtSuInQNoEoVvAYvVabTITiWwxAZ7sEFXhfk
 546HlHmXobQnEXz/2m2v3zXuxpfsZg8ZVMNzO5r+dFHk2oJFLa7fp5u/eErANqdvBcEQ
 6DTELGXVWo3FaIlLsr2+2rlW1OVPw2gTLfqnn4dxzHOoXiv5jG9tg8dtE18Piqxca8Oy iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prp0cr69y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 14:54:23 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 334EpLCp013977;
        Tue, 4 Apr 2023 14:54:23 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prp0cr695-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 14:54:23 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3341scfZ001763;
        Tue, 4 Apr 2023 14:54:21 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3ppbvfsym5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 14:54:21 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 334EsI5w47645148
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 14:54:18 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EDBEC20043;
        Tue,  4 Apr 2023 14:54:17 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDC5C2004B;
        Tue,  4 Apr 2023 14:54:17 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.129.1])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  4 Apr 2023 14:54:17 +0000 (GMT)
Message-ID: <06fd3ebc7770d1327be90cee10d12251cca76dd3.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests GIT PULL v2 11/14] s390x: Add tests for
 execute-type instructions
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>, Nico Boehr <nrb@linux.ibm.com>,
        pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Date:   Tue, 04 Apr 2023 16:54:17 +0200
In-Reply-To: <65075e9f-0d32-fc63-0200-3a3ec0c9bf63@redhat.com>
References: <20230404113639.37544-1-nrb@linux.ibm.com>
         <20230404113639.37544-12-nrb@linux.ibm.com>
         <65075e9f-0d32-fc63-0200-3a3ec0c9bf63@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LPz6n-UEQ25MLzzo0ZSFrFcrVsYqjJKk
X-Proofpoint-ORIG-GUID: GSmXU9wt3OLHLQV55aTsu9S2qTHOqUlV
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_06,2023-04-04_04,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 bulkscore=0 priorityscore=1501 suspectscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040135
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2023-04-04 at 16:15 +0200, Thomas Huth wrote:
> On 04/04/2023 13.36, Nico Boehr wrote:
> > From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> >=20
> > Test the instruction address used by targets of an execute instruction.
> > When the target instruction calculates a relative address, the result is
> > relative to the target instruction, not the execute instruction.
> >=20
> > Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> > Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> > Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Link: https://lore.kernel.org/r/20230317112339.774659-1-nsg@linux.ibm.c=
om
> > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> > ---
> >   s390x/Makefile      |   1 +
> >   s390x/ex.c          | 188 ++++++++++++++++++++++++++++++++++++++++++++
> >   s390x/unittests.cfg |   3 +
> >   .gitlab-ci.yml      |   1 +
> >   4 files changed, 193 insertions(+)
> >   create mode 100644 s390x/ex.c
> >=20
> > diff --git a/s390x/Makefile b/s390x/Makefile
> > index ab146eb..a80db53 100644
> > --- a/s390x/Makefile
> > +++ b/s390x/Makefile
> > @@ -39,6 +39,7 @@ tests +=3D $(TEST_DIR)/panic-loop-extint.elf
> >   tests +=3D $(TEST_DIR)/panic-loop-pgm.elf
> >   tests +=3D $(TEST_DIR)/migration-sck.elf
> >   tests +=3D $(TEST_DIR)/exittime.elf
> > +tests +=3D $(TEST_DIR)/ex.elf
> >=20=20=20
> >   pv-tests +=3D $(TEST_DIR)/pv-diags.elf
> >=20=20=20
> > diff --git a/s390x/ex.c b/s390x/ex.c
> > new file mode 100644
> > index 0000000..dbd8030
> > --- /dev/null
> > +++ b/s390x/ex.c
> > @@ -0,0 +1,188 @@
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
> > + * Accesses to the operand of execute-type instructions are instructio=
n fetches.
> > + * Minimum alignment is two, since the relative offset is specified by=
 number of halfwords.
> > + */
> > +asm (  ".pushsection .text.exrl_targets,\"x\"\n"
> > +"	.balign	2\n"
> > +"	.popsection\n"
> > +);
> > +
> > +/*
> > + * BRANCH AND SAVE, register register variant.
> > + * Saves the next instruction address (address from PSW + length of in=
struction)
> > + * to the first register. No branch is taken in this test, because 0 is
> > + * specified as target.
> > + * BASR does *not* perform a relative address calculation with an inte=
rmediate.
> > + */
> > +static void test_basr(void)
> > +{
> > +	uint64_t ret_addr, after_ex;
> > +
> > +	report_prefix_push("BASR");
> > +	asm volatile ( ".pushsection .text.exrl_targets\n"
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
> > +	asm volatile ( ".pushsection .text.exrl_targets\n"
> > +		"0:	bras	%[ret_addr],1f\n"
> > +		"	nopr	%%r7\n"
> > +		"1:	larl	%[branch_addr],0\n"
> > +		"	j	4f\n"
> > +		"	.popsection\n"
> > +
> > +		"	larl	%[after_target],1b\n"
> > +		"	larl	%[after_ex],3f\n"
> > +		"2:	exrl	0,0b\n"
> > +/*
> > + * In case the address calculation is correct, we jump by the relative=
 offset 1b-0b from 0b to 1b.
> > + * In case the address calculation is relative to the exrl (i.e. a tes=
t failure),
> > + * put a valid instruction at the same relative offset from the exrl, =
so the test continues in a
> > + * controlled manner.
> > + */
> > +		"3:	larl	%[branch_addr],0\n"
> > +		"4:\n"
> > +
> > +		"	.if (1b - 0b) !=3D (3b - 2b)\n"
> > +		"	.error	\"right and wrong target must have same offset\"\n"
> > +		"	.endif\n"
>=20
> FWIW, this is failing with Clang 15 for me:
>=20
> s390x/ex.c:81:4: error: expected absolute expression
>                  "       .if (1b - 0b) !=3D (3b - 2b)\n"
>                   ^
> <inline asm>:12:6: note: instantiated into assembly here
>          .if (1b - 0b) !=3D (3b - 2b)

Seems gcc is smarter here than clang.

>              ^
> s390x/ex.c:82:4: error: right and wrong target must have same offset
>                  "       .error  \"right and wrong target must have same=
=20
> offset\"\n"
>                   ^
> <inline asm>:13:2: note: instantiated into assembly here
>          .error  "right and wrong target must have same offset"
>          ^
> 2 errors generated.
>=20
> Any easy ways to fix this?

Just deleting that .if block would work, it's basically only a static asser=
t.
What do you think?
Other than that I can't think of anything.

>=20
>   Thomas
>=20

