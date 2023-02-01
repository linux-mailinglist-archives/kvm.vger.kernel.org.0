Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE468686812
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 15:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbjBAOTG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 09:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232304AbjBAOTE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 09:19:04 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 120B8457D4
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 06:19:03 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 311EEpg6031224
        for <kvm@vger.kernel.org>; Wed, 1 Feb 2023 14:19:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=LH0+Sde8S3wJZ2Jj/YFJDzlasHpkRqxoSwaWIVVsBko=;
 b=HW4cpgisqz3Rk5twjWdnpqi2F+qGirP6wIYsI17ZXBAekh6FJLNyvtSPXFy98uGlp6yv
 LYXyVGAsggoY+t6k2Xp3Z9dbJfv5ZsC9EdRaTaqHje781N64jl2AdEZhEDCW6tRWKu16
 J5nUhzwWjI5EHq8QDUcktusmmSppb4pqJSpU7pbtrP5fjlVKAAELW2h+z/Rhb2j5a2KX
 WjPYBRj0DvLRbwjVLBCf0zVYyS4LadZgQt98neJUaMFLCX5j33j5LUXVSqgO7PYj0sr5
 Lxjg5oihmFRW6HZ5ocl02YhSx3XQ/B1JzpW0Lvoi8wq2d0U5+JBJB2FZiQAFeFLEhiUt sA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nfsp604a9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 14:19:02 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 311EGi0Z009627
        for <kvm@vger.kernel.org>; Wed, 1 Feb 2023 14:19:01 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nfsp6049r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 14:19:01 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3116oTaV013332;
        Wed, 1 Feb 2023 14:18:59 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3ncvtycyeu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 14:18:59 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 311EIuVc46334428
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Feb 2023 14:18:56 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 16EBB20043;
        Wed,  1 Feb 2023 14:18:56 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BEB442004B;
        Wed,  1 Feb 2023 14:18:55 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.152.224.43])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed,  1 Feb 2023 14:18:55 +0000 (GMT)
From:   "Marc Hartmayer" <mhartmay@linux.ibm.com>
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>, kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 5/8] s390x: use C pre-processor for
 linker script generation
In-Reply-To: <3b73658114b5423f0bc26b8dbe614abf2d0aabb4.camel@linux.ibm.com>
References: <20230119114045.34553-1-mhartmay@linux.ibm.com>
 <20230119114045.34553-6-mhartmay@linux.ibm.com>
 <dc9617483f2dbd36c64972bde068fcbb9cca10a3.camel@linux.ibm.com>
 <87a61xg0xb.fsf@li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com>
 <3b73658114b5423f0bc26b8dbe614abf2d0aabb4.camel@linux.ibm.com>
Date:   Wed, 01 Feb 2023 15:18:55 +0100
Message-ID: <871qn9foz4.fsf@li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9bKA1xLaJeTVZqlA2fERTlkwxaJiz1f5
X-Proofpoint-ORIG-GUID: mjFfXoHCV-eTWn0ho9PG8fc9pj9zTq_B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-01_04,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 spamscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 phishscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302010120
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nina Schoetterl-Glausch <nsg@linux.ibm.com> writes:

> On Wed, 2023-02-01 at 11:00 +0100, Marc Hartmayer wrote:
>> Nina Schoetterl-Glausch <nsg@linux.ibm.com> writes:
>>=20
>> > On Thu, 2023-01-19 at 12:40 +0100, Marc Hartmayer wrote:
>> > > Use the C pre-processor for the linker script generation. For exampl=
e,
>> > > this enables us the use of constants in the "linker scripts" `*.lds.=
S`.
>> > >=20
>> > > Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>> > > ---
>> > >  .gitignore                                  | 1 +
>> > >  s390x/Makefile                              | 6 ++++--
>> > >  s390x/{flat.lds =3D> flat.lds.S}              | 0
>> > >  s390x/snippets/asm/{flat.lds =3D> flat.lds.S} | 0
>> > >  s390x/snippets/c/{flat.lds =3D> flat.lds.S}   | 0
>> > >  5 files changed, 5 insertions(+), 2 deletions(-)
>> > >  rename s390x/{flat.lds =3D> flat.lds.S} (100%)
>> > >  rename s390x/snippets/asm/{flat.lds =3D> flat.lds.S} (100%)
>> > >  rename s390x/snippets/c/{flat.lds =3D> flat.lds.S} (100%)
>> > >=20
>> > > diff --git a/.gitignore b/.gitignore
>> > > index 601822d67325..29f352c5ceb6 100644
>> > > --- a/.gitignore
>> > > +++ b/.gitignore
>> > > @@ -31,3 +31,4 @@ cscope.*
>> > >  /s390x/comm.key
>> > >  /s390x/snippets/*/*.hdr
>> > >  /s390x/snippets/*/*.*obj
>> > > +/s390x/**/*.lds
>> > > diff --git a/s390x/Makefile b/s390x/Makefile
>> > > index 8719f0c837cf..44ccca8102d6 100644
>> > > --- a/s390x/Makefile
>> > > +++ b/s390x/Makefile
>> > > @@ -76,7 +76,7 @@ CFLAGS +=3D -fno-delete-null-pointer-checks
>> > >  LDFLAGS +=3D -nostdlib -Wl,--build-id=3Dnone
>> > >=20=20
>> > >  # We want to keep intermediate files
>> > > -.PRECIOUS: %.o
>> > > +.PRECIOUS: %.o %.lds
>> > >=20=20
>> > >  asm-offsets =3D lib/$(ARCH)/asm-offsets.h
>> > >  include $(SRCDIR)/scripts/asm-offsets.mak
>> > > @@ -159,6 +159,8 @@ $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(=
snippet_lib) $(FLATLIBS) $(SNIPP
>> > >  %.hdr.obj: %.hdr
>> > >  	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $< $@
>> > >=20=20
>> > > +%.lds: %.lds.S
>> > > +	$(CPP) $(autodepend-flags) $(CPPFLAGS) -P -C -o $@ $<
>> >=20
>> > Where is CPP defined?
>> > Do you need the $(autodepend-flags)? It generates a rule with target f=
lat.lds.o.
>>                                                                        ^=
^^^^^^^^^
>>=20
>> Where does it generate a new Makefile rule? It generates the dependency
>> file used for the dependency tracking with the name: .flat.lds.S.d (or
>> similar)
>
> Yes and that file contains the rule.
> cat s390x/.flat.d
> flat.lds.o: /foo/bar/s390x/flat.lds.S \
>  /foo/bar/lib/asm/asm-offsets.h \
>  /foo/bar/lib/generated/asm-offsets.h
>
>>=20
>> > I don't think that would be used anywhere.
>>=20
>> It=E2=80=99s used for the dependency tracking. See line
>>=20
>> $KUT/Makefile:122
>>=20
>> -include */.*.d */*/.*.d
>
> Indeed, but the target flat.lds.o isn't used anywhere, is it?
> So if flat.lds.S included some other header and that changed,
> flat.lds wouldn't be rebuild.
> So you would either need to generate a rule with flat.lds as target
> or make it depend on flat.lds.o somehow.
>
>>=20
>> > In the next patch you add $(asm-offsets) as a prerequisite, if the gen=
erated rule would
>> > be effective, you wouldn't need that, would you?
>>=20
>> I thought, $(asm-offsets) is used to make sure that the file
>> <asm/asm-offsets.h> is generated.
>
> I was asking if this is necessary, since s390x/.flat.d contains the asm-o=
ffset headers
> as prerequisites. So if the dependency file is included, the headers will=
 be build,
> but I guess that this is circular, in order to generate the dependencies,
> the asm-offset headers must already have been built.

Hmm, no, this won=E2=80=99t work unless the dependency file was already cre=
ated
(chicken-egg problem). That=E2=80=99s probably the reason for this Makefile
rule:

generated-files =3D $(asm-offsets)
$(tests:.elf=3D.o) $(asmlib) $(cflatobjs): $(generated-files)

>>=20
>> [=E2=80=A6snip]
>>=20
>
--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen=20
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
