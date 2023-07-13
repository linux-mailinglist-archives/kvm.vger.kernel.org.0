Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A920F751B95
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 10:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbjGMIcm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 04:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233286AbjGMIcS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 04:32:18 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 595EA9003;
        Thu, 13 Jul 2023 01:23:23 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36D8E4K0022419;
        Thu, 13 Jul 2023 08:23:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=hRQ4ihNRpv4cKdYmLYsMuBZVBs+grD1x6Y3JmezI26c=;
 b=kBnJUUqSKwC2kY08wnEzPFrK26Tha/KBTwZwW2AFlHmeyaHmXwh5JladAcMXdC7+cyhv
 eCxMHs4BW/7Fy8uKBVyjXdJsK33MCleZvuSGwc8vDzOHV/pDEUNY7T1FWOPulAvS9nVV
 hSKF2XZkWbGg5O8K2no51tNAsoCGAM6pywQzGjvw9H8WC9m4n4nLCP48LHKyI7AR3YIS
 dMtvxJibVy2Kx8lRmgsQKGWPYSehG4ThKgD+ccuvj5i/RDItp5G5o8oJ5eKgCSwQItcQ
 DyaaW4fmBD/b7yAI2NtkzTjFaZR8saH9aCl3kFeFnTppVtNdPApYGwX0WwESkmGCxJ8O 5w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rtdjyg7wg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jul 2023 08:23:10 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36D8LufR018682;
        Thu, 13 Jul 2023 08:23:09 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rtdjyg7w9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jul 2023 08:23:09 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36D76WGk018476;
        Thu, 13 Jul 2023 08:23:09 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3rqmu0un1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jul 2023 08:23:09 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36D8N6g045547776
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 08:23:06 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E6FF2004B;
        Thu, 13 Jul 2023 08:23:06 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0ABF020040;
        Thu, 13 Jul 2023 08:23:06 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 13 Jul 2023 08:23:05 +0000 (GMT)
Date:   Thu, 13 Jul 2023 10:23:04 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v5 2/6] s390x: add function to set DAT
 mode for all interrupts
Message-ID: <20230713102304.376b7ed2@p-imbrenda>
In-Reply-To: <9b2cdc37-0b93-ff00-d077-397b8c0c2950@redhat.com>
References: <20230712114149.1291580-1-nrb@linux.ibm.com>
        <20230712114149.1291580-3-nrb@linux.ibm.com>
        <9b2cdc37-0b93-ff00-d077-397b8c0c2950@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Xy6z8tkw2Nj4Rop6QYZeRuJbcs8DfV0-
X-Proofpoint-ORIG-GUID: dVdkqLILes2n1-n056dqgGRR8Wxn5FA3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-13_04,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 adultscore=0
 clxscore=1015 bulkscore=0 suspectscore=0 impostorscore=0 mlxscore=0
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307130069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 13 Jul 2023 09:17:28 +0200
Thomas Huth <thuth@redhat.com> wrote:

> On 12/07/2023 13.41, Nico Boehr wrote:
> > When toggling DAT or switch address space modes, it is likely that
> > interrupts should be handled in the same DAT or address space mode.
> >=20
> > Add a function which toggles DAT and address space mode for all
> > interruptions, except restart interrupts.
> >=20
> > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> > ---
> >   lib/s390x/asm/interrupt.h |  4 ++++
> >   lib/s390x/interrupt.c     | 36 ++++++++++++++++++++++++++++++++++++
> >   lib/s390x/mmu.c           |  5 +++--
> >   3 files changed, 43 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
> > index 35c1145f0349..55759002dce2 100644
> > --- a/lib/s390x/asm/interrupt.h
> > +++ b/lib/s390x/asm/interrupt.h
> > @@ -83,6 +83,10 @@ void expect_ext_int(void);
> >   uint16_t clear_pgm_int(void);
> >   void check_pgm_int_code(uint16_t code);
> >  =20
> > +#define IRQ_DAT_ON	true
> > +#define IRQ_DAT_OFF	false =20
>=20
> Just a matter of taste, but IMHO having defines like this for just using=
=20
> them as boolean parameter to one function is a little bit overkill alread=
y.=20
> I'd rather rename the "bool dat" below into "bool use_dat" and then use=20
> "true" and "false" directly as a parameter for that function instead.=20
> Anyway, just my 0.02 =E2=82=AC.

+1

(or an enum, but I think a bool would be better, since it's a boolean
value)

[...]

> > + * and egg situation.
> > + *
> > + * @dat specifies whether to use DAT or not
> > + * @as specifies the address space mode to use - one of AS_PRIM, AS_AC=
CR,
> > + * AS_SECN or AS_HOME.
> > + */
> > +void irq_set_dat_mode(bool dat, uint64_t as) =20
>=20
> why uint64_t for "as" ? "int" should be enough?

or even a char ;)

>=20
> (alternatively, you could turn the AS_* defines into a properly named enu=
m=20
> and use that type here instead)

I like this more ^

>=20
>   Thomas
>=20
> > +{
> > +	struct psw* irq_psws[] =3D {
> > +		OPAQUE_PTR(GEN_LC_EXT_NEW_PSW),
> > +		OPAQUE_PTR(GEN_LC_SVC_NEW_PSW),
> > +		OPAQUE_PTR(GEN_LC_PGM_NEW_PSW),
> > +		OPAQUE_PTR(GEN_LC_MCCK_NEW_PSW),
> > +		OPAQUE_PTR(GEN_LC_IO_NEW_PSW),
> > +	};
> > +	struct psw *psw;
> > +
> > +	assert(as =3D=3D AS_PRIM || as =3D=3D AS_ACCR || as =3D=3D AS_SECN ||=
 as =3D=3D AS_HOME);
> > +
> > +	for (size_t i =3D 0; i < ARRAY_SIZE(irq_psws); i++) {
> > +		psw =3D irq_psws[i];
> > +		psw->dat =3D dat;
> > +		if (dat)
> > +			psw->as =3D as;
> > +	}
> > +}
> > +
> >   static void fixup_pgm_int(struct stack_frame_int *stack)
> >   {
> >   	/* If we have an error on SIE we directly move to sie_exit */
> > diff --git a/lib/s390x/mmu.c b/lib/s390x/mmu.c
> > index b474d7021d3f..199bd3fbc9c8 100644
> > --- a/lib/s390x/mmu.c
> > +++ b/lib/s390x/mmu.c
> > @@ -12,6 +12,7 @@
> >   #include <asm/pgtable.h>
> >   #include <asm/arch_def.h>
> >   #include <asm/barrier.h>
> > +#include <asm/interrupt.h>
> >   #include <vmalloc.h>
> >   #include "mmu.h"
> >  =20
> > @@ -41,8 +42,8 @@ static void mmu_enable(pgd_t *pgtable)
> >   	/* enable dat (primary =3D=3D 0 set as default) */
> >   	enable_dat();
> >  =20
> > -	/* we can now also use DAT unconditionally in our PGM handler */
> > -	lowcore.pgm_new_psw.mask |=3D PSW_MASK_DAT;
> > +	/* we can now also use DAT in all interrupt handlers */
> > +	irq_set_dat_mode(IRQ_DAT_ON, AS_PRIM);
> >   }
> >  =20
> >   /* =20
>=20

