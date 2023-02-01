Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6836865D2
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 13:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbjBAMUG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 07:20:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbjBAMUB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 07:20:01 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F62742BF0
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 04:19:59 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 311BJoQO019339
        for <kvm@vger.kernel.org>; Wed, 1 Feb 2023 12:19:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=WefxmuZfZ6tf53Ndo+i1Zyo7ncmNywcdL7cCkIo5jK4=;
 b=SDaFonW02P0+eYlDUHhZD5yCowOJjrjycUP4WrDYm0pyPJpr9shosTac/OxPTLD7YVNX
 POcwSgdnAq+BADxOCj78qV/PQ/OgQbdLUnFXMQn2xJtw7NUbe6oN/Gq4JG6fnexWPZBA
 dbIo2JU+sEz0MguuoSqdE9gW3j0YUuwkxIa4+A6fisPiMCb+zecRofljk3Xoms7+q2lU
 KnmZVDHE5lpcQjfPhdUt2dIJPu+7f/jqzyGPQ+Yk+Wg9WFPb+LqHzEBQs6K9rGZLLEgS
 1S10f58S0fbbSBGZTD73ruHh+ctQm91Q/EQolP7r5U15BCw+InAu3aMGjFhKSaveR6Hy jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nfq451a8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 12:19:58 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 311BQRTx015087
        for <kvm@vger.kernel.org>; Wed, 1 Feb 2023 12:19:58 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nfq451a7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 12:19:58 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3117nKFK013445;
        Wed, 1 Feb 2023 12:19:56 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3ncvtyctmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 12:19:56 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 311CJrMI49348990
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Feb 2023 12:19:53 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 233A720043;
        Wed,  1 Feb 2023 12:19:53 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E90F920040;
        Wed,  1 Feb 2023 12:19:52 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.195.106])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  1 Feb 2023 12:19:52 +0000 (GMT)
Message-ID: <3b73658114b5423f0bc26b8dbe614abf2d0aabb4.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 5/8] s390x: use C pre-processor for
 linker script generation
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>, kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Date:   Wed, 01 Feb 2023 13:19:52 +0100
In-Reply-To: <87a61xg0xb.fsf@li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com>
References: <20230119114045.34553-1-mhartmay@linux.ibm.com>
         <20230119114045.34553-6-mhartmay@linux.ibm.com>
         <dc9617483f2dbd36c64972bde068fcbb9cca10a3.camel@linux.ibm.com>
         <87a61xg0xb.fsf@li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xBXvIXF1vS1_DKYqxphJ26fKtwiuAiC-
X-Proofpoint-ORIG-GUID: JsOGukqc4UOVeGNC-TsRtuMCx-vpoCLV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-01_04,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 spamscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302010104
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2023-02-01 at 11:00 +0100, Marc Hartmayer wrote:
> Nina Schoetterl-Glausch <nsg@linux.ibm.com> writes:
>=20
> > On Thu, 2023-01-19 at 12:40 +0100, Marc Hartmayer wrote:
> > > Use the C pre-processor for the linker script generation. For example=
,
> > > this enables us the use of constants in the "linker scripts" `*.lds.S=
`.
> > >=20
> > > Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> > > ---
> > >  .gitignore                                  | 1 +
> > >  s390x/Makefile                              | 6 ++++--
> > >  s390x/{flat.lds =3D> flat.lds.S}              | 0
> > >  s390x/snippets/asm/{flat.lds =3D> flat.lds.S} | 0
> > >  s390x/snippets/c/{flat.lds =3D> flat.lds.S}   | 0
> > >  5 files changed, 5 insertions(+), 2 deletions(-)
> > >  rename s390x/{flat.lds =3D> flat.lds.S} (100%)
> > >  rename s390x/snippets/asm/{flat.lds =3D> flat.lds.S} (100%)
> > >  rename s390x/snippets/c/{flat.lds =3D> flat.lds.S} (100%)
> > >=20
> > > diff --git a/.gitignore b/.gitignore
> > > index 601822d67325..29f352c5ceb6 100644
> > > --- a/.gitignore
> > > +++ b/.gitignore
> > > @@ -31,3 +31,4 @@ cscope.*
> > >  /s390x/comm.key
> > >  /s390x/snippets/*/*.hdr
> > >  /s390x/snippets/*/*.*obj
> > > +/s390x/**/*.lds
> > > diff --git a/s390x/Makefile b/s390x/Makefile
> > > index 8719f0c837cf..44ccca8102d6 100644
> > > --- a/s390x/Makefile
> > > +++ b/s390x/Makefile
> > > @@ -76,7 +76,7 @@ CFLAGS +=3D -fno-delete-null-pointer-checks
> > >  LDFLAGS +=3D -nostdlib -Wl,--build-id=3Dnone
> > > =20
> > >  # We want to keep intermediate files
> > > -.PRECIOUS: %.o
> > > +.PRECIOUS: %.o %.lds
> > > =20
> > >  asm-offsets =3D lib/$(ARCH)/asm-offsets.h
> > >  include $(SRCDIR)/scripts/asm-offsets.mak
> > > @@ -159,6 +159,8 @@ $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(s=
nippet_lib) $(FLATLIBS) $(SNIPP
> > >  %.hdr.obj: %.hdr
> > >  	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $< $@
> > > =20
> > > +%.lds: %.lds.S
> > > +	$(CPP) $(autodepend-flags) $(CPPFLAGS) -P -C -o $@ $<
> >=20
> > Where is CPP defined?
> > Do you need the $(autodepend-flags)? It generates a rule with target fl=
at.lds.o.
>                                                                        ^^=
^^^^^^^^
>=20
> Where does it generate a new Makefile rule? It generates the dependency
> file used for the dependency tracking with the name: .flat.lds.S.d (or
> similar)

Yes and that file contains the rule.
cat s390x/.flat.d
flat.lds.o: /foo/bar/s390x/flat.lds.S \
 /foo/bar/lib/asm/asm-offsets.h \
 /foo/bar/lib/generated/asm-offsets.h

>=20
> > I don't think that would be used anywhere.
>=20
> It=E2=80=99s used for the dependency tracking. See line
>=20
> $KUT/Makefile:122
>=20
> -include */.*.d */*/.*.d

Indeed, but the target flat.lds.o isn't used anywhere, is it?
So if flat.lds.S included some other header and that changed,
flat.lds wouldn't be rebuild.
So you would either need to generate a rule with flat.lds as target
or make it depend on flat.lds.o somehow.

>=20
> > In the next patch you add $(asm-offsets) as a prerequisite, if the gene=
rated rule would
> > be effective, you wouldn't need that, would you?
>=20
> I thought, $(asm-offsets) is used to make sure that the file
> <asm/asm-offsets.h> is generated.

I was asking if this is necessary, since s390x/.flat.d contains the asm-off=
set headers
as prerequisites. So if the dependency file is included, the headers will b=
e build,
but I guess that this is circular, in order to generate the dependencies,
the asm-offset headers must already have been built.
>=20
> [=E2=80=A6snip]
>=20

