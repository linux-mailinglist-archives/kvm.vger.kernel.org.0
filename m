Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4421C6868CD
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 15:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbjBAOrc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 09:47:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbjBAOra (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 09:47:30 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A7F2E80B
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 06:47:27 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 311EiESm006047
        for <kvm@vger.kernel.org>; Wed, 1 Feb 2023 14:47:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=N5THBC0eriXLWxca2L5wNC01N/0YRGK18f+GmwWL4HE=;
 b=gCgwmDI+X05RtvpJTSsTL+HbnF/C0DJUa6Ur9I8PRFU2PJtegPwDbduh+9+xaBtlj6jv
 Z+a4Ys7UxRhEIZs/XSazBWrCARV3wCEGhc95OAIE6wy3xWlGDIgd2VJbs0SmyK8ibtRa
 Hu2Gtfd98WP/Ce4OiLuykp71RYOQcUvF3bVtEwW9hVQfJFNWuxA43aFRulVGd5ZBMaD5
 xnaCBcRmWyGQEXNIL//vW6yfIGgamHLywkS/LV00RZGyQLc6xH7+QvWAb9Knzy8mLwOK
 G4eTsK0QFP7UGKKzAixpi/0Mrnkry9xgmhKEyBFZgZtg8+2jjMMfokXMrIigRPkVKiXQ lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nft3rg3wb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 14:47:26 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 311EigWq007561
        for <kvm@vger.kernel.org>; Wed, 1 Feb 2023 14:47:25 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nft3rg3vt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 14:47:25 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3116BqrW026906;
        Wed, 1 Feb 2023 14:47:23 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3ncvs7n175-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 14:47:23 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 311ElJe746858678
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Feb 2023 14:47:19 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B242B20043;
        Wed,  1 Feb 2023 14:47:18 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8400E20040;
        Wed,  1 Feb 2023 14:47:18 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.152.224.43])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed,  1 Feb 2023 14:47:18 +0000 (GMT)
From:   "Marc Hartmayer" <mhartmay@linux.ibm.com>
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>, kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 5/8] s390x: use C pre-processor for
 linker script generation
In-Reply-To: <dc9617483f2dbd36c64972bde068fcbb9cca10a3.camel@linux.ibm.com>
References: <20230119114045.34553-1-mhartmay@linux.ibm.com>
 <20230119114045.34553-6-mhartmay@linux.ibm.com>
 <dc9617483f2dbd36c64972bde068fcbb9cca10a3.camel@linux.ibm.com>
Date:   Wed, 01 Feb 2023 15:47:18 +0100
Message-ID: <87y1phe93d.fsf@li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com>
Content-Type: text/plain; charset=utf-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Nuvhq1U7-5Xk0pJSrzUbyE26SGlPbIBz
X-Proofpoint-ORIG-GUID: zOutHMfBTP5ZKrMOXbzR9Ghy5IQT4lZZ
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-01_04,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 mlxlogscore=789
 suspectscore=0 spamscore=0 malwarescore=0 clxscore=1015 phishscore=0
 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302010125
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nina Schoetterl-Glausch <nsg@linux.ibm.com> writes:

> On Thu, 2023-01-19 at 12:40 +0100, Marc Hartmayer wrote:
>> Use the C pre-processor for the linker script generation. For example,
>> this enables us the use of constants in the "linker scripts" `*.lds.S`.
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
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index 8719f0c837cf..44ccca8102d6 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -76,7 +76,7 @@ CFLAGS +=3D -fno-delete-null-pointer-checks
>>  LDFLAGS +=3D -nostdlib -Wl,--build-id=3Dnone
>>=20=20
>>  # We want to keep intermediate files
>> -.PRECIOUS: %.o
>> +.PRECIOUS: %.o %.lds
>>=20=20
>>  asm-offsets =3D lib/$(ARCH)/asm-offsets.h
>>  include $(SRCDIR)/scripts/asm-offsets.mak
>> @@ -159,6 +159,8 @@ $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snip=
pet_lib) $(FLATLIBS) $(SNIPP
>>  %.hdr.obj: %.hdr
>>  	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $< $@
>>=20=20
>> +%.lds: %.lds.S
>> +	$(CPP) $(autodepend-flags) $(CPPFLAGS) -P -C -o $@ $<
>
> Where is CPP defined?

Sry, I forgot to answer this question. For GNU Make, it=E2=80=99s defined
implicitly:

https://www.gnu.org/software/make/manual/html_node/Implicit-Variables.html

[=E2=80=A6snip]

--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen=20
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
