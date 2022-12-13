Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4543864B185
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 09:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234968AbiLMIvH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 03:51:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234909AbiLMIui (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 03:50:38 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732F71658F
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 00:50:14 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BD87rsp026263
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 08:50:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : subject : to : message-id : date; s=pp1;
 bh=SRQ1rHXV3e5fFF2ss6mg2rh3GlVRhZHjOOh1NX18GM0=;
 b=qaNhwKaU7CfX4n3IIxoR+PKjSDVGz57itGAmMX+LGpPE7Fpf1lMvNJ8B6uQa+QdH1adG
 HFugHx4IGDq8RCne4bhmFBl159XTLvGbW887IQ5ytiCrIOEgiZCHxIWB2PRc2xpejOKM
 gBuel8YVXs2ml2CYrNY3ThMv1aDxVBsHrOmKo1S3+fRutUOPYb47Ldlfu0VIiGx6f7XV
 noB5Yq/w1fL8npmef79zw9QZQRrV6xGRgTF39eqhuSu45JHlYJ2pTwPkJ4SJ4gbeD3fi
 H3fNbZgyO1VKP7lVwSb9scYsNW/JnqLucTGbLnm14XYJnJiKfX1uuBd6o4tl+hkiNmk+ kQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3memtd9xau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 08:50:13 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BD886Ci029199
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 08:50:12 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3memtd9xa3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 08:50:12 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BD4WFXe028598;
        Tue, 13 Dec 2022 08:50:10 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3mchr63v5q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 08:50:10 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BD8o7Xa46137798
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 08:50:07 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EDA8E2004D;
        Tue, 13 Dec 2022 08:50:06 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BEAA72004B;
        Tue, 13 Dec 2022 08:50:06 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.6.155])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 13 Dec 2022 08:50:06 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <a54eb84516a5fcb1799ae864caff6aefc31b1896.camel@linux.ibm.com>
References: <20221209102122.447324-1-nrb@linux.ibm.com> <20221209102122.447324-2-nrb@linux.ibm.com> <a54eb84516a5fcb1799ae864caff6aefc31b1896.camel@linux.ibm.com>
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/1] s390x: add parallel skey migration test
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>, kvm@vger.kernel.org
Message-ID: <167092140591.10919.7530526866489219030@t14-nrb.local>
User-Agent: alot/0.8.1
Date:   Tue, 13 Dec 2022 09:50:06 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rUgPE0bti4d3pnlf7WtiA5O_0-TFWRog
X-Proofpoint-ORIG-GUID: E_8G-BH3eNyjpE4KdHjdfyS3oboEsBPp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-12_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 malwarescore=0 phishscore=0
 adultscore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212130076
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Nina Schoetterl-Glausch (2022-12-12 21:37:28)
> On Fri, 2022-12-09 at 11:21 +0100, Nico Boehr wrote:
> > Right now, we have a test which sets storage keys, then migrates the VM
> > and - after migration finished - verifies the skeys are still there.
> >=20
> > Add a new version of the test which changes storage keys while the
> > migration is in progress. This is achieved by adding a command line
> > argument to the existing migration-skey test.
> >=20
> > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> > ---
> >  s390x/migration-skey.c | 214 +++++++++++++++++++++++++++++++++++------
> >  s390x/unittests.cfg    |  15 ++-
> >  2 files changed, 198 insertions(+), 31 deletions(-)
> >=20
> > diff --git a/s390x/migration-skey.c b/s390x/migration-skey.c
> > index b7bd82581abe..9b9a45f4ad3b 100644
> > --- a/s390x/migration-skey.c
> > +++ b/s390x/migration-skey.c
> >=20
> [...]
>=20
> > +static void test_skey_migration_parallel(void)
> > +{
> > +     report_prefix_push("parallel");
> > +
> > +     if (smp_query_num_cpus() =3D=3D 1) {
> > +             report_skip("need at least 2 cpus for this test");
> > +             goto error;
> > +     }
> > +
> > +     smp_cpu_setup(1, PSW_WITH_CUR_MASK(set_skeys_thread));
> > +
> > +     migrate_once();
> > +
> > +     WRITE_ONCE(thread_should_exit, 1);
> > +
> > +     while (!thread_exited)
> > +             mb();
>=20
> Are you doing it this way instead of while(!READ_ONCE(thread_exited)); so=
 the mb() does double duty
> and ensures "result" is also read from memory a couple of lines down?

It is a good point, actually I just did what we already do in wait_for_flag=
 in s390x/smp.c. :-)

> If so, I wonder if the compiler is allowed to arrange the control flow su=
ch that if the loop condition
> is false on the first iteration it uses a cached value of "result" (I'd b=
e guessing yes, but what do I know).

I agree, but it does not matter, does it? At latest the second iteration wi=
ll actually read from memory, no?

> In any case using a do while loop instead would eliminate the question.
> A comment might be nice, too.

How about I change to
  while(!READ_ONCE(thread_exited));=20
and add an explicit mb() below to ensure result is read from memory?
