Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE2466DA36
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 10:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236251AbjAQJpW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 04:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236204AbjAQJox (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 04:44:53 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A499431E2C
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 01:43:09 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30H84Xjf032475
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 09:43:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=v/FhSTKdcQFXJeA+QNmXGVCjGrhGnf9RItFMkaG8Ntw=;
 b=LWBnejyXUkkdd1wJe4m984Z8mRjkR21ZqwBXUJv/EadyAcJ3H2m87p6r+arSu6NOGS7P
 oyXBYwjXRR88Oj4dpOKpd2BHMJfHp1goM1UXhhrb83vMP7dz1N2yEnaM6oES6CTfzAVJ
 LW/JW4xnXnyOt7aSP95JojjUVLysNu3JmUlGc56N+cy1Is5Fo0CpFPJSN3pokVNagmxX
 Yel8iHj3vsei3bJf0z59FhtjBR/naAFXtjVyjN+GjZL2z/196+7wgmJGjylHlRlz0g5g
 K1hMS5SKVEzE4tjXMQr5xDvLoFEuyl49ehsBbk1b3rwWpIPxIQMCbkiDzuGaaQ67RK7s Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5nb8ndrb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 09:43:08 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30H9UMqr026170
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 09:43:08 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5nb8ndqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 09:43:07 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30GK7cXj026787;
        Tue, 17 Jan 2023 09:43:06 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3n3m16jm8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 09:43:06 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30H9h25d20971934
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Jan 2023 09:43:02 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4464C2004D;
        Tue, 17 Jan 2023 09:43:02 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF77520043;
        Tue, 17 Jan 2023 09:43:01 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.171.42.101])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 17 Jan 2023 09:43:01 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 7/9] s390x: use C pre-processor for
 linker script generation
In-Reply-To: <20230116192210.7243c77f@p-imbrenda>
References: <20230116175757.71059-1-mhartmay@linux.ibm.com>
 <20230116175757.71059-8-mhartmay@linux.ibm.com>
 <20230116192210.7243c77f@p-imbrenda>
Date:   Tue, 17 Jan 2023 10:43:01 +0100
Message-ID: <87o7qx4hui.fsf@li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: P6BhbfEUwj1aSgTPslWF0E7yjmmeFYQ4
X-Proofpoint-ORIG-GUID: 7lrS0XVARuIU0KD263hEw1i83hwiNYuu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-17_04,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 clxscore=1015 impostorscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301170080
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Claudio Imbrenda <imbrenda@linux.ibm.com> writes:

> On Mon, 16 Jan 2023 18:57:55 +0100
> Marc Hartmayer <mhartmay@linux.ibm.com> wrote:
>
>> Use the C pre-processor for the linker script generation. For example,
>> this enables us the use of constants in the "linker scripts" `*.lds.S`.
>
> please explain that the original .lds scripts are being renamed to
> .lds.S, and that the .lds are now generated.

Okay.

>
>>=20
>> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>> ---
>>  .gitignore                                  | 1 +
>>  s390x/Makefile                              | 6 ++++--
>>  s390x/{flat.lds =3D> flat.lds.S}              | 0
>>  s390x/snippets/asm/{flat.lds =3D> flat.lds.S} | 0
>>  s390x/snippets/c/{flat.lds =3D> flat.lds.S}   | 0
>>  5 files changed, 5 insertions(+), 2 deletions(-)
>>  rename s390x/{flat.lds =3D> flat.lds.S} (100%)
>>  rename s390x/snippets/asm/{flat.lds =3D> flat.lds.S} (100%)
>>  rename s390x/snippets/c/{flat.lds =3D> flat.lds.S} (100%)
>>=20
>> diff --git a/.gitignore b/.gitignore
>> index 601822d67325..29f352c5ceb6 100644
>> --- a/.gitignore
>> +++ b/.gitignore
>> @@ -31,3 +31,4 @@ cscope.*
>>  /s390x/comm.key
>>  /s390x/snippets/*/*.hdr
>>  /s390x/snippets/*/*.*obj
>> +/s390x/**/*.lds
>
> why ** ?

Because all of our linker scripts are generated now:

s390x/snippets/(c|asm)/*.lds

and

s390x/*.lds

[=E2=80=A6snip]

--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen=20
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
