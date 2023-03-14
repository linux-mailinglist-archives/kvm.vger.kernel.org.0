Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F55D6B925F
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 12:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjCNL5p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 07:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjCNL5n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 07:57:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09FD69CBD4;
        Tue, 14 Mar 2023 04:56:59 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32EAWXX6010453;
        Tue, 14 Mar 2023 11:56:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=sjRjoVyN4hmqa3UgKM3i+zcwVYtKhiHXvv25pR/1sXo=;
 b=GXoY/mcTITaDlpFuXa2KeJxq/rPofxOpAFHrgVfpO+IIXcsDz54dWUDPLTkkWlw6GLhZ
 KsF6VOITSLsu7vsMcv1acEAa3xM+w7ztajj0tseTB8HTFVqxZCNUweDapy83ueZnmxHk
 GEd6R4DdvITvfkSyNjmYxvHn3f5osIrsZTLEOMzZoyzchg/ky80pF7AXa3CR5RIvYkuV
 CP7MSFkNi9sg3YPIQoJIz2JLQPFEscX1+G6P2Pul9ovApUx2pmUsRrYxtaT/fRXicQJJ
 UwMe7MtpJYEGyZoTOsfoZ6Naoyusrazm2iHK4MSA8E0fnLGlqz4BbsZ8XnAWRCphxlCm mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3paq8y9yap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Mar 2023 11:56:19 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32EAWbmR010607;
        Tue, 14 Mar 2023 11:56:18 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3paq8y9ya6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Mar 2023 11:56:18 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32E6XRQ4029999;
        Tue, 14 Mar 2023 11:56:16 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3p8gwfcsmg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Mar 2023 11:56:16 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32EBuDG746727560
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Mar 2023 11:56:13 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BD4D2004E;
        Tue, 14 Mar 2023 11:56:13 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD44720043;
        Tue, 14 Mar 2023 11:56:12 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 14 Mar 2023 11:56:12 +0000 (GMT)
Date:   Tue, 14 Mar 2023 12:56:11 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v5] s390x: Add tests for execute-type
 instructions
Message-ID: <20230314125611.6135af7a@p-imbrenda>
In-Reply-To: <d6471b717f34b6ae664dc91331246e9676d8c879.camel@linux.ibm.com>
References: <20230310181131.2138736-1-nsg@linux.ibm.com>
        <20230313191602.58b16c31@p-imbrenda>
        <d6471b717f34b6ae664dc91331246e9676d8c879.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OyoDqQVTiAPXmTz4WLspEF9GpTfSVsWH
X-Proofpoint-ORIG-GUID: UKSYRxWaZfjqhvMfa8c-xwnYJvk_3csZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-14_04,2023-03-14_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 clxscore=1015 suspectscore=0 adultscore=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 impostorscore=0
 mlxscore=0 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2303140098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 13 Mar 2023 23:45:33 +0100
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:


[...]

> > > +/*
> > > + * BRANCH AND SAVE, register register variant.
> > > + * Saves the next instruction address (address from PSW + length of =
instruction)
> > > + * to the first register. No branch is taken in this test, because 0=
 is
> > > + * specified as target.
> > > + * BASR does *not* perform a relative address calculation with an in=
termediate.
> > > + */
> > > +static void test_basr(void)
> > > +{
> > > +	uint64_t ret_addr, after_ex;
> > > +
> > > +	report_prefix_push("BASR");
> > > +	asm volatile ( ".pushsection .rodata\n" =20
> >=20
> > you use .text.ex_bras in the next test, why not something like that here
> > (and everywhere else) too? =20
>=20
> In the test below we branch to the code in .text.ex_bras.
> In all other tests the instruction in .rodata is just an operand of the e=
xecute instruction,
> and it doesn't get modified.
> As for the bras test having a suffix, I guess it's pretty arbitrary, but =
since it's a handful
> of instructions instead of just one, it felt substantial enough to warran=
t one.
>=20

we discussed this offline :)

> >  =20
> > > +		"0:	basr	%[ret_addr],0\n"
> > > +		"	.popsection\n"
> > > +
> > > +		"	larl	%[after_ex],1f\n"
> > > +		"	exrl	0,0b\n"
> > > +		"1:\n"
> > > +		: [ret_addr] "=3Dd" (ret_addr),
> > > +		  [after_ex] "=3Dd" (after_ex)
> > > +	);
> > > +
> > > +	report(ret_addr =3D=3D after_ex, "return address after EX");
> > > +	report_prefix_pop();
> > > +}
> > > +
> > > +/*
> > > + * BRANCH RELATIVE AND SAVE.
> > > + * According to PoP (Branch-Address Generation), the address calcula=
ted relative
> > > + * to the instruction address is relative to BRAS when it is the tar=
get of an
> > > + * execute-type instruction, not relative to the execute-type instru=
ction.
> > > + */
> > > +static void test_bras(void)
> > > +{
> > > +	uint64_t after_target, ret_addr, after_ex, branch_addr;
> > > +
> > > +	report_prefix_push("BRAS");
> > > +	asm volatile ( ".pushsection .text.ex_bras, \"x\"\n"
> > > +		"0:	bras	%[ret_addr],1f\n"
> > > +		"	nopr	%%r7\n"
> > > +		"1:	larl	%[branch_addr],0\n"
> > > +		"	j	4f\n"
> > > +		"	.popsection\n"
> > > +
> > > +		"	larl	%[after_target],1b\n"
> > > +		"	larl	%[after_ex],3f\n"
> > > +		"2:	exrl	0,0b\n" =20
> /*
>  * In case the address calculation is correct, we jump by the relative of=
fset 1b-0b from 0b to 1b.
>  * In case the address calculation is relative to the exrl (i.e. a test f=
ailure),
>  * put a valid instruction at the same relative offset from the exrl, so =
the test continues in a
>  * controlled manner.
>  */

looks good

> > > +		"3:	larl	%[branch_addr],0\n"
> > > +		"4:\n"
> > > +
> > > +		"	.if (1b - 0b) !=3D (3b - 2b)\n"
> > > +		"	.error	\"right and wrong target must have same offset\"\n" =20
> >=20
> > please explain why briefly (i.e. if the wrong target is executed and
> > the offset mismatches Bad Things=E2=84=A2 happen) =20
>=20
> Ok, see above.
>=20
> [...]
>=20
>=20

