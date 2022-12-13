Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB0864B3E9
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 12:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235321AbiLMLMv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 06:12:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235385AbiLMLLp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 06:11:45 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61DC31D0C0
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 03:11:37 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BD8tSCO019079
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 11:11:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=G8TGR0HDBiQu0AjYMswrrT/DxjZWUh6ghQZ12ROHoGA=;
 b=Cg7g75GJvA7oz7eyjy6Fv/dQX4wOQnbxPrF+BiX8MWjSpAEs+PuifyVtAhKiU1wKQtzT
 UI2pkWK0T2Xa1sOGYDa02QYd0w8G1J6GA7MZ9mwxp7LcUjQF6Qkw03XzYFujOsUylbQx
 p1eszSNnO2X8TSnwO+Al+urhnz8LIF1rMmCGR1zu6V3qyYxtBRXpD2QQ929uRYkZLXr/
 k085HfRrcykrxcPT4tBL6VriLlZfhECCjjjB0Sw5S/bDgYMaBugLUmu3wOodVmJ8VuGB
 Z82or2G4DwKsS7dtRNGgWIrlBoyomycgQD3QElelQYZo9eF2wmnqBOD34VbFqZ31KVX9 5w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mepafk4da-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 11:11:36 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BDBBaLk017643
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 11:11:36 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mepafk4ca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 11:11:36 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BD4pNuV030148;
        Tue, 13 Dec 2022 11:11:34 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3mchr5v20n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 11:11:34 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BDBBUB441812470
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 11:11:30 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 876AC20043;
        Tue, 13 Dec 2022 11:11:30 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 28FF020040;
        Tue, 13 Dec 2022 11:11:30 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.59.159])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 13 Dec 2022 11:11:30 +0000 (GMT)
Message-ID: <7d641501865efea9a31d90e6b8dc8712067c3a13.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/1] s390x: add parallel skey
 migration test
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Date:   Tue, 13 Dec 2022 12:11:29 +0100
In-Reply-To: <167092140591.10919.7530526866489219030@t14-nrb.local>
References: <20221209102122.447324-1-nrb@linux.ibm.com>
         <20221209102122.447324-2-nrb@linux.ibm.com>
         <a54eb84516a5fcb1799ae864caff6aefc31b1896.camel@linux.ibm.com>
         <167092140591.10919.7530526866489219030@t14-nrb.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.1 (3.46.1-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: t915wclYLOOnhU5Gtsib0p-HUyvCvc6M
X-Proofpoint-ORIG-GUID: lS1Gd5E3UJSKlGQEtxQEhVt_2dO4adyK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 malwarescore=0 bulkscore=0 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 mlxscore=0 suspectscore=0
 adultscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2212130098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-12-13 at 09:50 +0100, Nico Boehr wrote:
> Quoting Nina Schoetterl-Glausch (2022-12-12 21:37:28)
> > On Fri, 2022-12-09 at 11:21 +0100, Nico Boehr wrote:
> > > Right now, we have a test which sets storage keys, then migrates the =
VM
> > > and - after migration finished - verifies the skeys are still there.
> > >=20
> > > Add a new version of the test which changes storage keys while the
> > > migration is in progress. This is achieved by adding a command line
> > > argument to the existing migration-skey test.
> > >=20
> > > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> > > ---
> > >  s390x/migration-skey.c | 214 +++++++++++++++++++++++++++++++++++----=
--
> > >  s390x/unittests.cfg    |  15 ++-
> > >  2 files changed, 198 insertions(+), 31 deletions(-)
> > >=20
> > > diff --git a/s390x/migration-skey.c b/s390x/migration-skey.c
> > > index b7bd82581abe..9b9a45f4ad3b 100644
> > > --- a/s390x/migration-skey.c
> > > +++ b/s390x/migration-skey.c
> > >=20
> > [...]
> >=20
> > > +static void test_skey_migration_parallel(void)
> > > +{
> > > +     report_prefix_push("parallel");
> > > +
> > > +     if (smp_query_num_cpus() =3D=3D 1) {
> > > +             report_skip("need at least 2 cpus for this test");
> > > +             goto error;
> > > +     }
> > > +
> > > +     smp_cpu_setup(1, PSW_WITH_CUR_MASK(set_skeys_thread));
> > > +
> > > +     migrate_once();
> > > +
> > > +     WRITE_ONCE(thread_should_exit, 1);
> > > +
> > > +     while (!thread_exited)
> > > +             mb();
> >=20
> > Are you doing it this way instead of while(!READ_ONCE(thread_exited)); =
so the mb() does double duty
> > and ensures "result" is also read from memory a couple of lines down?
>=20
> It is a good point, actually I just did what we already do in wait_for_fl=
ag in s390x/smp.c. :-)
>=20
> > If so, I wonder if the compiler is allowed to arrange the control flow =
such that if the loop condition
> > is false on the first iteration it uses a cached value of "result" (I'd=
 be guessing yes, but what do I know).
>=20
> I agree, but it does not matter, does it? At latest the second iteration =
will actually read from memory, no?

Well, if the condition is false on the first iteration, there won't be a se=
cond one.
>=20
> > In any case using a do while loop instead would eliminate the question.
> > A comment might be nice, too.
>=20
> How about I change to
>   while(!READ_ONCE(thread_exited));=20
> and add an explicit mb() below to ensure result is read from memory?

Fine by me. Could also use READ_ONCE for result. You decide.
Btw, doesn't checkpatch complain about mb() without comment?
Although I think I've ignored that before, too.

