Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E85F64073F
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 13:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233647AbiLBM5A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 07:57:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233643AbiLBM47 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 07:56:59 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44440CD79A
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 04:56:58 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B2CbDih010167
        for <kvm@vger.kernel.org>; Fri, 2 Dec 2022 12:56:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=cxsrYxfl9XI15fZjFezyYKF4raoe1ElVwWJAE4EmEsE=;
 b=daMrizxJhGu+0mvWz/Bmu50hC5k3rgnKoY7keywpdML6G2gSFEeiprtmi6c5TKX9Dy6o
 Pw5nj8ImhjKw7t4M5URLaAGrojt3Th+1IazErkcXw5L+v1gfzxcyI+5PEqdLO5jObpps
 UWLPc4+o61H7nC2J32eyQwaWlBVTBeqRo6bnMYa35/NE7YvvprCJZXodkUTd1O8tW2fG
 pAjhxjVomQupiEpxSwkpwZ1B6vYbN47FQN+qJCD8YPkDHOYbSdpr8FZhf6rdusLV/G9/
 BTj29uPjcz541/F/oXwVX0/uiF8NFtvU9uKW+1iEa+G701lDZxBOKQydPJBXWWrX20sl wQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m7f1gc0kn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 12:56:57 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B2Crjlc013639
        for <kvm@vger.kernel.org>; Fri, 2 Dec 2022 12:56:56 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m7f1gc0k8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Dec 2022 12:56:56 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2B2Cpk4O010964;
        Fri, 2 Dec 2022 12:56:54 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3m3ae9h7a9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Dec 2022 12:56:54 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B2Cup6t24773224
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Dec 2022 12:56:51 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 147FEAE04D;
        Fri,  2 Dec 2022 12:56:51 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68468AE045;
        Fri,  2 Dec 2022 12:56:50 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.31.115])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Fri,  2 Dec 2022 12:56:50 +0000 (GMT)
Date:   Fri, 2 Dec 2022 13:56:47 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 1/3] s390x: add library for
 skey-related functions
Message-ID: <20221202135647.46df1322@p-imbrenda>
In-Reply-To: <77870647-0fb6-a9f8-4408-dd76b5156462@redhat.com>
References: <20221201084642.3747014-1-nrb@linux.ibm.com>
        <20221201084642.3747014-2-nrb@linux.ibm.com>
        <933616a6-0e1b-51e9-223e-0009d0b6b34b@linux.ibm.com>
        <7a05af7b-96e0-7914-1415-62443f6646dd@redhat.com>
        <166997789077.186408.11144216448246779334@t14-nrb.local>
        <49c289b2-c7d7-7aec-c975-e056cb42927e@redhat.com>
        <cab7aa32-0d97-abe1-47f2-4d08c7aec6f0@linux.ibm.com>
        <77870647-0fb6-a9f8-4408-dd76b5156462@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9-4qJCbp_otQRId3UuGeSC1XF9Y7K7vB
X-Proofpoint-GUID: n6zj2kT9tboSn5TguA3iz0Akaa59K3uD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-02_06,2022-12-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 mlxlogscore=999
 phishscore=0 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2212020098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2 Dec 2022 13:48:17 +0100
Thomas Huth <thuth@redhat.com> wrote:

> On 02/12/2022 12.56, Janosch Frank wrote:
> > On 12/2/22 12:32, Thomas Huth wrote: =20
> >> On 02/12/2022 11.44, Nico Boehr wrote: =20
> >>> Quoting Thomas Huth (2022-12-02 10:09:03) =20
> >>>> On 02/12/2022 10.03, Janosch Frank wrote: =20
> >>>>> On 12/1/22 09:46, Nico Boehr wrote: =20
> >>>>>> Upcoming changes will add a test which is very similar to the exis=
ting
> >>>>>> skey migration test. To reduce code duplication, move the common
> >>>>>> functions to a library which can be re-used by both tests.
> >>>>>> =20
> >>>>>
> >>>>> NACK
> >>>>>
> >>>>> We're not putting test specific code into the library. =20
> >>>>
> >>>> Do we need a new file (in the third patch) for the new test at all, =
or=20
> >>>> could
> >>>> the new test simply be added to s390x/migration-skey.c instead? =20
> >>>
> >>> Mh, not quite. One test wants to change storage keys *before* migrati=
ng,=20
> >>> the other *while* migrating. Since we can only migrate once, it is no=
t=20
> >>> obvious to me how we could do that in one run.
> >>>
> >>> Speaking of one run, what we could do is add a command line argument=
=20
> >>> which decides which test to run and then call the same test with=20
> >>> different arguments in unittests.cfg. =20
> >>
> >> Yes, that's what I had in mind - use a command line argument to select=
 the
> >> test ... should be OK as long as both variants are listed in unittests=
.cfg,
> >> shouldn't it?
> >>
> >> =C2=A0=C2=A0 Thomas =20
> >=20
> > @Thomas @Claudio:
> > I see two possible solutions if we want a "testlib" at some point (whic=
h for=20
> > the record I don't have anything against):
> >=20
> > Putting the files into lib/s390x/testlib/* which will then be part of o=
ur=20
> > normal lib.
> > That's a minimal effort solution. It still puts those files into lib/* =
but=20
> > they are at least contained in a directory.
> >=20
> > Putting the files into s390x/testlib/* and creating a proper new lib.
> > Which means we'd need a few more lines of makefile changes. =20
>=20
> Though this is an excellent topic for a Friday afternoon bikeshedding ...=
 I=20
> don't mind much either way. I maybe just got a small preference to not to=
uch=20
> the main lib/ folder here. I guess you could even call it=20
> s390x/migration-skey-common.c and leave the lib logic out of the game ...=
=20
> but I don't really mind. Up to you to decide ;-)
>=20

I really like the idea of having only one test and use a commandline
parameter to decide which variant to run

this way no need to put things in external files

>   Thomas
>=20

