Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A608064C6EF
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 11:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237700AbiLNKRa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 05:17:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237276AbiLNKR2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 05:17:28 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC66A8
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 02:17:28 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEA8C6G030288
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 10:17:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : from : to : cc : message-id : date; s=pp1;
 bh=vaI7Xui/tVzvv/viRhmm2TxyjZUwCQkFwGED1sk1Ylc=;
 b=VdbLv9lzvE8YdcTI+mDXnHnSnOrh3Dv5PueFs2ncYCEVlzd6XIlcfVVrcDF3YDORoAdP
 r8p297x1BhomDxWKLO9SeGV7trGz0ZjO1bAxHO4dJofMmuZNaq6N1VHvLAwmgEcNs8FE
 zor93oK3ST9oYuxOi2ant1XaSoK9Mj+FZTBGD3BRbzjQHC3P9ZoHafvZtXU5aQDf4ckh
 IULwlqoAY2iA4EiJakJX7xwkFgAXz82rB49bqQpF+Nyr0daxa7amHTbILOnEF1eg61RQ
 EGtT/9GsWuWCoxJNb2ZG6lN6CsXSzLjaTxPsksNTM3LjszMxZ1mRhQT9OYpjj3qx7ZUi jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mfcc0g9h9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 10:17:27 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BEA9uu8007052
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 10:17:27 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mfcc0g9gk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Dec 2022 10:17:27 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDJscGd001043;
        Wed, 14 Dec 2022 10:17:24 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3meyyegvxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Dec 2022 10:17:24 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BEAHL3l52298160
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 10:17:21 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23FA220073;
        Wed, 14 Dec 2022 10:17:21 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D0DC20071;
        Wed, 14 Dec 2022 10:17:21 +0000 (GMT)
Received: from t14-nrb (unknown [9.152.224.44])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 14 Dec 2022 10:17:20 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <7d641501865efea9a31d90e6b8dc8712067c3a13.camel@linux.ibm.com>
References: <20221209102122.447324-1-nrb@linux.ibm.com> <20221209102122.447324-2-nrb@linux.ibm.com> <a54eb84516a5fcb1799ae864caff6aefc31b1896.camel@linux.ibm.com> <167092140591.10919.7530526866489219030@t14-nrb.local> <7d641501865efea9a31d90e6b8dc8712067c3a13.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/1] s390x: add parallel skey migration test
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Message-ID: <167101304052.9238.17477739896227641358@t14-nrb.local>
User-Agent: alot/0.8.1
Date:   Wed, 14 Dec 2022 11:17:20 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tbCRe7laHajj-hSweazmLiZ6sfHq1gpD
X-Proofpoint-GUID: 718kPkWae0LjGuB2G8GCDziRLHOwg-dE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_04,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 suspectscore=0 spamscore=0 lowpriorityscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212140080
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Nina Schoetterl-Glausch (2022-12-13 12:11:29)
> On Tue, 2022-12-13 at 09:50 +0100, Nico Boehr wrote:
> > Quoting Nina Schoetterl-Glausch (2022-12-12 21:37:28)
> > > On Fri, 2022-12-09 at 11:21 +0100, Nico Boehr wrote:
> > > > Right now, we have a test which sets storage keys, then migrates th=
e VM
> > > > and - after migration finished - verifies the skeys are still there.
> > > >=20
> > > > Add a new version of the test which changes storage keys while the
> > > > migration is in progress. This is achieved by adding a command line
> > > > argument to the existing migration-skey test.
> > > >=20
> > > > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> > > > ---
> > > >  s390x/migration-skey.c | 214 +++++++++++++++++++++++++++++++++++--=
----
> > > >  s390x/unittests.cfg    |  15 ++-
> > > >  2 files changed, 198 insertions(+), 31 deletions(-)
> > > >=20
> > > > diff --git a/s390x/migration-skey.c b/s390x/migration-skey.c
> > > > index b7bd82581abe..9b9a45f4ad3b 100644
> > > > --- a/s390x/migration-skey.c
> > > > +++ b/s390x/migration-skey.c
> > > >=20
> > > [...]
> > >=20
> > > > +static void test_skey_migration_parallel(void)
> > > > +{
> > > > +     report_prefix_push("parallel");
> > > > +
> > > > +     if (smp_query_num_cpus() =3D=3D 1) {
> > > > +             report_skip("need at least 2 cpus for this test");
> > > > +             goto error;
> > > > +     }
> > > > +
> > > > +     smp_cpu_setup(1, PSW_WITH_CUR_MASK(set_skeys_thread));
> > > > +
> > > > +     migrate_once();
> > > > +
> > > > +     WRITE_ONCE(thread_should_exit, 1);
> > > > +
> > > > +     while (!thread_exited)
> > > > +             mb();
> > >=20
> > > Are you doing it this way instead of while(!READ_ONCE(thread_exited))=
; so the mb() does double duty
> > > and ensures "result" is also read from memory a couple of lines down?
> >=20
> > It is a good point, actually I just did what we already do in wait_for_=
flag in s390x/smp.c. :-)
> >=20
> > > If so, I wonder if the compiler is allowed to arrange the control flo=
w such that if the loop condition
> > > is false on the first iteration it uses a cached value of "result" (I=
'd be guessing yes, but what do I know).
> >=20
> > I agree, but it does not matter, does it? At latest the second iteratio=
n will actually read from memory, no?
>=20
> Well, if the condition is false on the first iteration, there won't be a =
second one.

Yes, you are right. Thanks for pointing this out.
