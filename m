Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03840647FCF
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 10:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbiLIJD2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 04:03:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiLIJDG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 04:03:06 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E600511C5
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 01:03:05 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B980oah023166
        for <kvm@vger.kernel.org>; Fri, 9 Dec 2022 09:03:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 cc : from : subject : message-id : date; s=pp1;
 bh=iNAWAXXlC4Ruts1QQd67Hq2kk9eUFQPsg8vXJjNAaY0=;
 b=RzxgEg2fm9Kp/BnjnTWDTTYLjAlWTw69Xkoz1CAam1qk9zdMuc6kpqVwDTUZtE856XXy
 Y7pxuRd4PrN4aNtv874p5mRSs7QgLSqCf3/mZjpMPtrqWPZXODTBmDVfQIlVWbh+x8BU
 IHRK12+NaU3t6ROGdTfdJYNrgvcLHdJ36tp5nUn+NXEvTynEbQ7igKlneGO1+WXYMe4M
 jxBFDwCyVDpf2YIXgWWufpQDNUrCRgniQRRGCs4W8B/0YU6JcoBTANcSK6nFSOt/ABjU
 fbqg8NY2agbs17G9UGnWCZfx4+IbCytPTQJwDNClGkAXkW26bY/sFMnSmfMv/IZFE+Dz ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mbxfdcv6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 09 Dec 2022 09:03:04 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B98Sdxd035426
        for <kvm@vger.kernel.org>; Fri, 9 Dec 2022 09:03:04 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mbxfdcv6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Dec 2022 09:03:03 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2B8L36SF016327;
        Fri, 9 Dec 2022 09:03:02 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3m9m5y5q23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Dec 2022 09:03:02 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B992tCN19661474
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 9 Dec 2022 09:02:55 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ABC6C2004B;
        Fri,  9 Dec 2022 09:02:55 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80DEE2004F;
        Fri,  9 Dec 2022 09:02:55 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.83.208])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  9 Dec 2022 09:02:55 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20221202135647.46df1322@p-imbrenda>
References: <20221201084642.3747014-1-nrb@linux.ibm.com> <20221201084642.3747014-2-nrb@linux.ibm.com> <933616a6-0e1b-51e9-223e-0009d0b6b34b@linux.ibm.com> <7a05af7b-96e0-7914-1415-62443f6646dd@redhat.com> <166997789077.186408.11144216448246779334@t14-nrb.local> <49c289b2-c7d7-7aec-c975-e056cb42927e@redhat.com> <cab7aa32-0d97-abe1-47f2-4d08c7aec6f0@linux.ibm.com> <77870647-0fb6-a9f8-4408-dd76b5156462@redhat.com> <20221202135647.46df1322@p-imbrenda>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 1/3] s390x: add library for skey-related functions
Message-ID: <167057657387.12153.4904337393772127172@t14-nrb.local>
User-Agent: alot/0.8.1
Date:   Fri, 09 Dec 2022 10:02:55 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _-AwFaDJmJk25ixZt0RurrXuODwmVfyd
X-Proofpoint-ORIG-GUID: Vsz21s2YC65cFhNrPplXy5NI8GOF7tps
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_04,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 spamscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2022-12-02 13:56:47)
> On Fri, 2 Dec 2022 13:48:17 +0100
> Thomas Huth <thuth@redhat.com> wrote:
>=20
> > On 02/12/2022 12.56, Janosch Frank wrote:
> > > On 12/2/22 12:32, Thomas Huth wrote: =20
> > >> On 02/12/2022 11.44, Nico Boehr wrote: =20
> > >>> Quoting Thomas Huth (2022-12-02 10:09:03) =20
> > >>>> On 02/12/2022 10.03, Janosch Frank wrote: =20
> > >>>>> On 12/1/22 09:46, Nico Boehr wrote: =20
> > >>>>>> Upcoming changes will add a test which is very similar to the ex=
isting
> > >>>>>> skey migration test. To reduce code duplication, move the common
> > >>>>>> functions to a library which can be re-used by both tests.
> > >>>>>> =20
> > >>>>>
> > >>>>> NACK
> > >>>>>
> > >>>>> We're not putting test specific code into the library. =20
> > >>>>
> > >>>> Do we need a new file (in the third patch) for the new test at all=
, or=20
> > >>>> could
> > >>>> the new test simply be added to s390x/migration-skey.c instead? =20
> > >>>
> > >>> Mh, not quite. One test wants to change storage keys *before* migra=
ting,=20
> > >>> the other *while* migrating. Since we can only migrate once, it is =
not=20
> > >>> obvious to me how we could do that in one run.
> > >>>
> > >>> Speaking of one run, what we could do is add a command line argumen=
t=20
> > >>> which decides which test to run and then call the same test with=20
> > >>> different arguments in unittests.cfg. =20
> > >>
> > >> Yes, that's what I had in mind - use a command line argument to sele=
ct the
> > >> test ... should be OK as long as both variants are listed in unittes=
ts.cfg,
> > >> shouldn't it?
> > >>
> > >> =C2=A0=C2=A0 Thomas =20
> > >=20
> > > @Thomas @Claudio:
> > > I see two possible solutions if we want a "testlib" at some point (wh=
ich for=20
> > > the record I don't have anything against):
> > >=20
> > > Putting the files into lib/s390x/testlib/* which will then be part of=
 our=20
> > > normal lib.
> > > That's a minimal effort solution. It still puts those files into lib/=
* but=20
> > > they are at least contained in a directory.
> > >=20
> > > Putting the files into s390x/testlib/* and creating a proper new lib.
> > > Which means we'd need a few more lines of makefile changes. =20
> >=20
> > Though this is an excellent topic for a Friday afternoon bikeshedding .=
.. I=20
> > don't mind much either way. I maybe just got a small preference to not =
touch=20
> > the main lib/ folder here. I guess you could even call it=20
> > s390x/migration-skey-common.c and leave the lib logic out of the game .=
..=20
> > but I don't really mind. Up to you to decide ;-)
> >=20
>=20
> I really like the idea of having only one test and use a commandline
> parameter to decide which variant to run
>=20
> this way no need to put things in external files

OK, I also like this suggestion, then I'll refactor the tests.
