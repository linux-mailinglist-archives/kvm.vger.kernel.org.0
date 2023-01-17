Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA5366DC2D
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 12:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236735AbjAQLUp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 06:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236845AbjAQLUK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 06:20:10 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1133231E0C
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 03:20:00 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30HBHhUN011535
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 11:20:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=S1Uzv4A+j0pZsS5SGJtURmTeUYZk3TRv9dbQECc2cHg=;
 b=dXtHsWP8z6+5EjWeE1um3MdQzBz4QSAyGNgHpgvjYRIqy9h+SjKDCVdSzcB03Igt8BSz
 X0BD3XTY6RFjJfcPvHtZGedhpo6Q/rWzZUfFjz5k22MEtz/hc6fdybiLgeBvcVX2VwEJ
 LgbVMnOpB27ZAB69kLyw7H3zcSudUIkABGGwLt4uhCjKQPhB7JuStcwqttU2JA94zEP4
 oHLiVLIVtCvhB2O5/E9YRO2Z8WLWX1VL5XUcIPcX5whDduwfddTdZhpPaonHQ4UvBVOB
 b08LPMq1q4ItkmpVegHzSihEKrToI7lERB5jJVkxlc18vNGLodp5jU7tDtzmUdtbF+TI qQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5jpy2hf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 11:19:59 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30HAfmDF026637
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 11:19:59 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5jpy2hem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 11:19:59 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30GK7ce5026787;
        Tue, 17 Jan 2023 11:19:57 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3n3m16jq8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 11:19:57 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30HBJsMc48038354
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Jan 2023 11:19:54 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C6662004E;
        Tue, 17 Jan 2023 11:19:54 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82FAB20043;
        Tue, 17 Jan 2023 11:19:53 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.171.42.101])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 17 Jan 2023 11:19:53 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 7/9] s390x: use C pre-processor for
 linker script generation
In-Reply-To: <20230117112444.63cb872b@p-imbrenda>
References: <20230116175757.71059-1-mhartmay@linux.ibm.com>
 <20230116175757.71059-8-mhartmay@linux.ibm.com>
 <20230116192210.7243c77f@p-imbrenda>
 <87o7qx4hui.fsf@li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com>
 <20230117112444.63cb872b@p-imbrenda>
Date:   Tue, 17 Jan 2023 12:19:52 +0100
Message-ID: <87k01l4dd3.fsf@li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com>
Content-Type: text/plain; charset=utf-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rI3F-apiHQK9Tgq_DnmjKv0PG9qD5Zli
X-Proofpoint-ORIG-GUID: pD-Q-S--pLRj2ELn_TnSLqBpIzn-ZP90
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-17_05,2023-01-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 spamscore=0 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301170093
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Claudio Imbrenda <imbrenda@linux.ibm.com> writes:

> On Tue, 17 Jan 2023 10:43:01 +0100
> Marc Hartmayer <mhartmay@linux.ibm.com> wrote:
>
>> Claudio Imbrenda <imbrenda@linux.ibm.com> writes:
>>=20
>> > On Mon, 16 Jan 2023 18:57:55 +0100
>> > Marc Hartmayer <mhartmay@linux.ibm.com> wrote:
>> >=20=20
>> >> Use the C pre-processor for the linker script generation. For example,
>> >> this enables us the use of constants in the "linker scripts" `*.lds.S=
`.=20=20
>> >
>> > please explain that the original .lds scripts are being renamed to
>> > .lds.S, and that the .lds are now generated.=20=20
>>=20
>> Okay.
>>=20
>> >=20=20
>> >>=20
>> >> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>> >> ---
>> >>  .gitignore                                  | 1 +
>> >>  s390x/Makefile                              | 6 ++++--
>> >>  s390x/{flat.lds =3D> flat.lds.S}              | 0
>> >>  s390x/snippets/asm/{flat.lds =3D> flat.lds.S} | 0
>> >>  s390x/snippets/c/{flat.lds =3D> flat.lds.S}   | 0
>> >>  5 files changed, 5 insertions(+), 2 deletions(-)
>> >>  rename s390x/{flat.lds =3D> flat.lds.S} (100%)
>> >>  rename s390x/snippets/asm/{flat.lds =3D> flat.lds.S} (100%)
>> >>  rename s390x/snippets/c/{flat.lds =3D> flat.lds.S} (100%)
>> >>=20
>> >> diff --git a/.gitignore b/.gitignore
>> >> index 601822d67325..29f352c5ceb6 100644
>> >> --- a/.gitignore
>> >> +++ b/.gitignore
>> >> @@ -31,3 +31,4 @@ cscope.*
>> >>  /s390x/comm.key
>> >>  /s390x/snippets/*/*.hdr
>> >>  /s390x/snippets/*/*.*obj
>> >> +/s390x/**/*.lds=20=20
>> >
>> > why ** ?=20=20
>>=20
>> Because all of our linker scripts are generated now:
>>=20
>> s390x/snippets/(c|asm)/*.lds
>>=20
>> and
>>=20
>> s390x/*.lds
>>=20
>> [=E2=80=A6snip]
>>=20
>
> I still don't understand why ** instead of just * ?

=E2=80=9CA slash followed by two consecutive asterisks then a slash matches=
 zero
or more directories. For example, "a/**/b" matches "a/b", "a/x/b",
"a/x/y/b" and so on.=E2=80=9D [1]

[1] https://git-scm.com/docs/gitignore

--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen=20
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
