Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67E5F686342
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 11:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbjBAKBE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 05:01:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbjBAKA6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 05:00:58 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42A532517
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 02:00:57 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3119wCH1026150
        for <kvm@vger.kernel.org>; Wed, 1 Feb 2023 10:00:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=XzL3SZACVvK0ATD6unZZ2hvUPBJKrG+S891jyrezwC4=;
 b=MepxP/AeYHwfkohVRx3+ABXkdGl0TLfrkbIz5YwMOmxSRnMXuOAYoippod03VdmqHc5Q
 JET4kq5H7qQo4YDYGdfyr031Uhb22ZdZRcf4tgdvStNWEBbZHCffl+Z9hc4q2cooc3l6
 lkTCZsGC2T83aueOL9AZuEXEAJN17LmgSOWZhVlJ0T0gkbFqhWEdejiKMExJzWKD8ESA
 HxDJkPmXnXcizUbPbZpTXIXHuZTVwwQ8QpE4hpVnmRV5WcBQlXHsr7z2X1TalzZI+2dM
 eERrsJAVL00WJCW6RTFbc1svaLA6tWL+8APo906NPh0HpnEjEgFspb5cvLmmcJd+0pIL 6g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nfmsx1ug9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 10:00:56 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3119ej68014374
        for <kvm@vger.kernel.org>; Wed, 1 Feb 2023 10:00:56 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nfmsx1uem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 10:00:56 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3110YtoX001953;
        Wed, 1 Feb 2023 10:00:53 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3ncvt7kbp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 10:00:53 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 311A0n4c44696044
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Feb 2023 10:00:50 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0DEF2004B;
        Wed,  1 Feb 2023 10:00:49 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8EDD92004D;
        Wed,  1 Feb 2023 10:00:49 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.152.224.43])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed,  1 Feb 2023 10:00:49 +0000 (GMT)
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
Date:   Wed, 01 Feb 2023 11:00:48 +0100
Message-ID: <87a61xg0xb.fsf@li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: t_lmG-l9MNi51hI41GQcM_bNkR6wjEmB
X-Proofpoint-ORIG-GUID: s8dxUfskVL-hrfCjAW_Dt5qsN4U5-gyl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-01_03,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 spamscore=0 malwarescore=0
 mlxscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302010083
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
> Do you need the $(autodepend-flags)? It generates a rule with target flat=
.lds.o.
                                                                       ^^^^=
^^^^^^

Where does it generate a new Makefile rule? It generates the dependency
file used for the dependency tracking with the name: .flat.lds.S.d (or
similar)

> I don't think that would be used anywhere.

It=E2=80=99s used for the dependency tracking. See line

$KUT/Makefile:122

-include */.*.d */*/.*.d

> In the next patch you add $(asm-offsets) as a prerequisite, if the genera=
ted rule would
> be effective, you wouldn't need that, would you?

I thought, $(asm-offsets) is used to make sure that the file
<asm/asm-offsets.h> is generated.

[=E2=80=A6snip]

--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen=20
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
