Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 102704A8348
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 12:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350231AbiBCLlo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 06:41:44 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59488 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239934AbiBCLln (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Feb 2022 06:41:43 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 213AlE0n009668
        for <kvm@vger.kernel.org>; Thu, 3 Feb 2022 11:41:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=1GkuaDNVp4DMN+GC3uMKOTCXdU+J28y7Ne/8A7YGWPY=;
 b=sLouC4Fegn+I8JKQLrm2Jf99DJJX1R/0YeRKvbjAKqWhnX6N+jRhWQW9zpoXxYPBxzLo
 gJ0WXTgj97OrHGIWUQ+2AdfZP+AzXgWhxocfxU55KauxRvaeatnPTHwYBGw50PwRdj+l
 gTdRIXlY4XTzQqbfMIkDdxqsl1BSo0ZKiqWcoyLAE4E/SB8ayEzy4wxUZa9T46b0/c3x
 Z2yYOBgjTFrQLQHJFRsf/xGvJK485AtbiJ3g1/9EJ/sy7/nsEQ6v+xHTMEmFRxpH4QEE
 xomATI95zNlelZVbQe/2fzMz8FaTRE/RehnUDxKGb+RHeijQQxJem3ngs3HKbc/4DnJh Qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e03fn455w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 03 Feb 2022 11:41:43 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 213BTUML004187
        for <kvm@vger.kernel.org>; Thu, 3 Feb 2022 11:41:42 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e03fn455a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 11:41:42 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 213BX1p3024531;
        Thu, 3 Feb 2022 11:41:40 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3dyaetne6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 11:41:40 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 213Bfbe933227110
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Feb 2022 11:41:37 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D12F11C052;
        Thu,  3 Feb 2022 11:41:37 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B924511C064;
        Thu,  3 Feb 2022 11:41:36 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.135])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Feb 2022 11:41:36 +0000 (GMT)
Date:   Thu, 3 Feb 2022 12:41:34 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com, seiden@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v1 2/5] lib: s390x: smp: guarantee that
 boot CPU has index 0
Message-ID: <20220203124134.61547e2a@p-imbrenda>
In-Reply-To: <f99fc058-03fa-3bb7-7520-4cea7fd9a004@redhat.com>
References: <20220128185449.64936-1-imbrenda@linux.ibm.com>
        <20220128185449.64936-3-imbrenda@linux.ibm.com>
        <f99fc058-03fa-3bb7-7520-4cea7fd9a004@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NGPBsRoHlSNOc4nOLEVuwkLjA4vBsC0i
X-Proofpoint-ORIG-GUID: dCqi826dinTe01Sbb6ftsRdurHQeFzgD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-03_03,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 suspectscore=0 clxscore=1015 phishscore=0 adultscore=0 malwarescore=0
 bulkscore=0 priorityscore=1501 mlxlogscore=999 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202030072
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 31 Jan 2022 14:55:09 +0100
David Hildenbrand <david@redhat.com> wrote:

> On 28.01.22 19:54, Claudio Imbrenda wrote:
> > Guarantee that the boot CPU has index 0. This simplifies the
> > implementation of tests that require multiple CPUs.
> >=20
> > Also fix a small bug in the allocation of the cpus array.
> >=20
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Fixes: f77c0515 ("s390x: Add initial smp code")
> > Fixes: 52076a63 ("s390x: Consolidate sclp read info")
> > ---
> >  lib/s390x/smp.c | 16 ++++++++--------
> >  1 file changed, 8 insertions(+), 8 deletions(-)
> >=20
> > diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> > index 64c647ec..01f513f0 100644
> > --- a/lib/s390x/smp.c
> > +++ b/lib/s390x/smp.c
> > @@ -25,7 +25,6 @@
> >  #include "sclp.h"
> > =20
> >  static struct cpu *cpus;
> > -static struct cpu *cpu0;
> >  static struct spinlock lock;
> > =20
> >  extern void smp_cpu_setup_state(void);
> > @@ -81,7 +80,7 @@ static int smp_cpu_stop_nolock(uint16_t addr, bool st=
ore)
> >  	uint8_t order =3D store ? SIGP_STOP_AND_STORE_STATUS : SIGP_STOP;
> > =20
> >  	cpu =3D smp_cpu_from_addr(addr);
> > -	if (!cpu || cpu =3D=3D cpu0)
> > +	if (!cpu || addr =3D=3D cpus[0].addr)
> >  		return -1;
> > =20
> >  	if (sigp_retry(addr, order, 0, NULL))
> > @@ -205,7 +204,7 @@ int smp_cpu_setup(uint16_t addr, struct psw psw)
> >  	sigp_retry(cpu->addr, SIGP_SET_PREFIX, (unsigned long )lc, NULL);
> > =20
> >  	/* Copy all exception psws. */
> > -	memcpy(lc, cpu0->lowcore, 512);
> > +	memcpy(lc, cpus[0].lowcore, 512);
> > =20
> >  	/* Setup stack */
> >  	cpu->stack =3D (uint64_t *)alloc_pages(2);
> > @@ -263,15 +262,16 @@ void smp_setup(void)
> >  	if (num > 1)
> >  		printf("SMP: Initializing, found %d cpus\n", num);
> > =20
> > -	cpus =3D calloc(num, sizeof(cpus));
> > +	cpus =3D calloc(num, sizeof(*cpus));
> >  	for (i =3D 0; i < num; i++) {
> >  		cpus[i].addr =3D entry[i].address;
> >  		cpus[i].active =3D false;
> >  		if (entry[i].address =3D=3D cpu0_addr) {
> > -			cpu0 =3D &cpus[i];
> > -			cpu0->stack =3D stackptr;
> > -			cpu0->lowcore =3D (void *)0;
> > -			cpu0->active =3D true;
> > +			cpus[i].addr =3D cpus[0].addr; =20
>=20
> Might deserve a comment that we'll move the the boot CPU to index 0.

fair enough.

>=20
> What's the expected behavior if i =3D=3D 0?
>=20

in that case, the boot CPU was already the one with index 0. The code
will do a few extra useless steps, but in the end everything should Just
Work=E2=84=A2
