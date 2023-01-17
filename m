Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E131166DC38
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 12:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236830AbjAQLWH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 06:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236181AbjAQLVo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 06:21:44 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBEAE3527E
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 03:21:16 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30H9FGJw002164
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 11:21:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=JMYtqCPYZcIOBS9ndj1ND4dhcDEpJWx8SlXZTfDZ+fg=;
 b=GjYIacS/R/+6BxgP6Arj9pEAJkqofNCmWIIuXup5ckuiM39XkMp0LKGgs9gwlm4wb9eV
 +bwi9ab8PW9xNQgEr5SdOGdxzW9GZqzJFSCDQXh3RFTtBoame2ulHdPy3wEq6FARIjSS
 NGRyuVWidg3KhKWkqySm9XHbg6ANowI/iCMsw2ghDiCD8BjvAJ9aI6BQzBRDI8pQPp6R
 pBWabv5oxiaRZVqAR2dRCOv6aYML6QrOW7ZWaz3lsXVDRqPQ6/I1SxUYqdGTXARg3X3O
 N/MEkidhsc9OKw2yST+xIP5GJLXu4sj30+K52SbStfCWDF576sE4d/Kp2Ru/COIJUjbC 2A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5hky3u18-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 11:21:15 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30HBAxWA009202
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 11:21:15 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5hky3u0k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 11:21:15 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30H2ifcH005026;
        Tue, 17 Jan 2023 11:21:13 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3n3knfaqu9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 11:21:13 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30HBL90p51380586
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Jan 2023 11:21:09 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 99A102004D;
        Tue, 17 Jan 2023 11:21:09 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F68920043;
        Tue, 17 Jan 2023 11:21:09 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 17 Jan 2023 11:21:09 +0000 (GMT)
Date:   Tue, 17 Jan 2023 12:21:07 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>
Cc:     kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 7/9] s390x: use C pre-processor for
 linker script generation
Message-ID: <20230117122107.32521862@p-imbrenda>
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
X-Proofpoint-ORIG-GUID: 8wVupiEArIDXKzXVF_aQJkzG20oV3Sfy
X-Proofpoint-GUID: QwbiM6wCpn7QcljlPqPIKQGb5P5sIBMn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-17_05,2023-01-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999 bulkscore=0
 spamscore=0 impostorscore=0 clxscore=1015 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301170089
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

ok so I thought ** was a typo and you meant either * or */*, but it
turns out ** is actual a special glob syntax in gitignore

ignore my comments regarding ** :)

