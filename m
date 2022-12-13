Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D739A64B4FB
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 13:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235543AbiLMMRD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 07:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235619AbiLMMQ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 07:16:26 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E034520199
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 04:14:25 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDBP3Dg029652
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 12:14:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=QM3miIJ6Fgi65kMCu5cgU7RpqEfcR5Trt8Z4MylwPz8=;
 b=lWvdIOrkNYjWALz4XRl2wkc7EBy0blZOwI3qjL/ngSrrBk/Isx9N5gkyGPMKGmN0A45f
 j0uFG68r3OykDVAr2sWtBlVJV9tqts+z7TiIwgpxM55hzzMp7mMQwZTfVcbQKxtuVoCK
 Cm92bJ5eJr3x2vR0ScNFHONpkDfemfyLEzL1DcJ7dInWe7HqEWR4+zlRaTMFHsAD2/gp
 RbsScUnUVW0IfuY0aVrfe89ZyhIB3zT5x9wEL1B7AlQnYe2b/JO8ggiLTLDRbJgODHFU
 4ERKGvtXR0+h0vNqRj0G4dHUDgG2b55jdMheOIqeCH4TJFONBof0cAVjcY90qKReeoqI gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mergk16ry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 12:14:24 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BDBlbtg028858
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 12:14:24 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mergk16qy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 12:14:24 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BD6w8xM029603;
        Tue, 13 Dec 2022 12:14:22 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3mchr62yxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 12:14:22 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BDCEIDb22544772
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 12:14:18 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6EBAE2004F;
        Tue, 13 Dec 2022 12:14:18 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38FE22004E;
        Tue, 13 Dec 2022 12:14:18 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 13 Dec 2022 12:14:18 +0000 (GMT)
Date:   Tue, 13 Dec 2022 13:14:16 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 1/1] s390x: add parallel skey
 migration test
Message-ID: <20221213131416.68e0cada@p-imbrenda>
In-Reply-To: <7d641501865efea9a31d90e6b8dc8712067c3a13.camel@linux.ibm.com>
References: <20221209102122.447324-1-nrb@linux.ibm.com>
        <20221209102122.447324-2-nrb@linux.ibm.com>
        <a54eb84516a5fcb1799ae864caff6aefc31b1896.camel@linux.ibm.com>
        <167092140591.10919.7530526866489219030@t14-nrb.local>
        <7d641501865efea9a31d90e6b8dc8712067c3a13.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pbGWZ7dY3tSs_zZ6bR-_lIibUD61JRTe
X-Proofpoint-GUID: iXV-shDyYhO1w_v6_KRUZPEuq25kMN7L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0
 impostorscore=0 adultscore=0 mlxscore=0 priorityscore=1501 bulkscore=0
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212130107
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Dec 2022 12:11:29 +0100
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

> On Tue, 2022-12-13 at 09:50 +0100, Nico Boehr wrote:
> > Quoting Nina Schoetterl-Glausch (2022-12-12 21:37:28)  
> > > On Fri, 2022-12-09 at 11:21 +0100, Nico Boehr wrote:  
> > > > Right now, we have a test which sets storage keys, then migrates the VM
> > > > and - after migration finished - verifies the skeys are still there.
> > > > 
> > > > Add a new version of the test which changes storage keys while the
> > > > migration is in progress. This is achieved by adding a command line
> > > > argument to the existing migration-skey test.
> > > > 
> > > > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> > > > ---
> > > >  s390x/migration-skey.c | 214 +++++++++++++++++++++++++++++++++++------
> > > >  s390x/unittests.cfg    |  15 ++-
> > > >  2 files changed, 198 insertions(+), 31 deletions(-)
> > > > 
> > > > diff --git a/s390x/migration-skey.c b/s390x/migration-skey.c
> > > > index b7bd82581abe..9b9a45f4ad3b 100644
> > > > --- a/s390x/migration-skey.c
> > > > +++ b/s390x/migration-skey.c
> > > >   
> > > [...]
> > >   
> > > > +static void test_skey_migration_parallel(void)
> > > > +{
> > > > +     report_prefix_push("parallel");
> > > > +
> > > > +     if (smp_query_num_cpus() == 1) {
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
> > > 
> > > Are you doing it this way instead of while(!READ_ONCE(thread_exited)); so the mb() does double duty
> > > and ensures "result" is also read from memory a couple of lines down?  
> > 
> > It is a good point, actually I just did what we already do in wait_for_flag in s390x/smp.c. :-)
> >   
> > > If so, I wonder if the compiler is allowed to arrange the control flow such that if the loop condition
> > > is false on the first iteration it uses a cached value of "result" (I'd be guessing yes, but what do I know).  
> > 
> > I agree, but it does not matter, does it? At latest the second iteration will actually read from memory, no?  
> 
> Well, if the condition is false on the first iteration, there won't be a second one.
> >   
> > > In any case using a do while loop instead would eliminate the question.
> > > A comment might be nice, too.  
> > 
> > How about I change to
> >   while(!READ_ONCE(thread_exited)); 
> > and add an explicit mb() below to ensure result is read from memory?  
> 
> Fine by me. Could also use READ_ONCE for result. You decide.
> Btw, doesn't checkpatch complain about mb() without comment?

there is no checkpatch for kvm unit tests :)

> Although I think I've ignored that before, too.
> 

