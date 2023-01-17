Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAEEF66DAE1
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 11:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236610AbjAQKY6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 05:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236556AbjAQKY4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 05:24:56 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A68298FE
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 02:24:55 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30H9QZWc009700
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 10:24:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=nyE+QoblyGIEb2rl8GXSuFO7xmeXNEWdTkKkBZx6wQ8=;
 b=tCsAS8WXiinjKaBXm6LFdtq83fiNquqARfBi/NkrF9c3CexrxA6z58YgweV62X+mEFK9
 fXUhdW8LKeuGNjRGUiBPtzRvljpaN0m2IWuiPAIhdI+b2oXBI1lm1HUOVbltaJxhCjNV
 d7ofZiRJg13ioDXdBNdCIjqbvXOXw6C4IcsIWLgmEMzq/nARy5zJwwMCrQtS87VGGTcJ
 9xnbzoSkgYNyG43e4rBbFYZsKceH2wNKvfWbJHmn0hlr0eSOcaMAW8I434ROqgRK5Wbz
 6UPwebxWvduoAtBCUrMoI7N4DDZc+27/mC4HDJxT0eJuZajcxyKKhyTHL9OIKfskf//X NQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5m197v66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 10:24:54 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30H8wNQx026444
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 10:24:54 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5m197v5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 10:24:53 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30H9HsVl010590;
        Tue, 17 Jan 2023 10:24:52 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3n3knfap4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 10:24:52 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30HAOkeV18153750
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Jan 2023 10:24:47 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D397A20063;
        Tue, 17 Jan 2023 10:24:46 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A9402004E;
        Tue, 17 Jan 2023 10:24:46 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 17 Jan 2023 10:24:46 +0000 (GMT)
Date:   Tue, 17 Jan 2023 11:24:44 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>
Cc:     kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 7/9] s390x: use C pre-processor for
 linker script generation
Message-ID: <20230117112444.63cb872b@p-imbrenda>
In-Reply-To: <87o7qx4hui.fsf@li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com>
References: <20230116175757.71059-1-mhartmay@linux.ibm.com>
        <20230116175757.71059-8-mhartmay@linux.ibm.com>
        <20230116192210.7243c77f@p-imbrenda>
        <87o7qx4hui.fsf@li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vjHuTKxgaQw5WuG7WbtCbKHHnH474s1_
X-Proofpoint-GUID: 989htRLW66-AeZJGZMpi2ZBwvy-B2z_D
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-17_04,2023-01-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0
 impostorscore=0 mlxscore=0 clxscore=1015 adultscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301170080
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 Jan 2023 10:43:01 +0100
Marc Hartmayer <mhartmay@linux.ibm.com> wrote:

> Claudio Imbrenda <imbrenda@linux.ibm.com> writes:
>=20
> > On Mon, 16 Jan 2023 18:57:55 +0100
> > Marc Hartmayer <mhartmay@linux.ibm.com> wrote:
> > =20
> >> Use the C pre-processor for the linker script generation. For example,
> >> this enables us the use of constants in the "linker scripts" `*.lds.S`=
. =20
> >
> > please explain that the original .lds scripts are being renamed to
> > .lds.S, and that the .lds are now generated. =20
>=20
> Okay.
>=20
> > =20
> >>=20
> >> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> >> ---
> >>  .gitignore                                  | 1 +
> >>  s390x/Makefile                              | 6 ++++--
> >>  s390x/{flat.lds =3D> flat.lds.S}              | 0
> >>  s390x/snippets/asm/{flat.lds =3D> flat.lds.S} | 0
> >>  s390x/snippets/c/{flat.lds =3D> flat.lds.S}   | 0
> >>  5 files changed, 5 insertions(+), 2 deletions(-)
> >>  rename s390x/{flat.lds =3D> flat.lds.S} (100%)
> >>  rename s390x/snippets/asm/{flat.lds =3D> flat.lds.S} (100%)
> >>  rename s390x/snippets/c/{flat.lds =3D> flat.lds.S} (100%)
> >>=20
> >> diff --git a/.gitignore b/.gitignore
> >> index 601822d67325..29f352c5ceb6 100644
> >> --- a/.gitignore
> >> +++ b/.gitignore
> >> @@ -31,3 +31,4 @@ cscope.*
> >>  /s390x/comm.key
> >>  /s390x/snippets/*/*.hdr
> >>  /s390x/snippets/*/*.*obj
> >> +/s390x/**/*.lds =20
> >
> > why ** ? =20
>=20
> Because all of our linker scripts are generated now:
>=20
> s390x/snippets/(c|asm)/*.lds
>=20
> and
>=20
> s390x/*.lds
>=20
> [=E2=80=A6snip]
>=20

I still don't understand why ** instead of just * ?
