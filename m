Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23CFE64BA89
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 18:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235748AbiLMRDb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 12:03:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236286AbiLMRDA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 12:03:00 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB68223BF4
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 09:00:59 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDGiDZ6029694
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 17:00:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=6OpXTB438SesaBDeg7v3029Zy20d+psI+cmRYPDRH7s=;
 b=P9Y1jDiVjlfQELfLLphsdairzKFdQ6yI6hz/XcE0Cp0Hqdd+tUCr4QenNxalMNGIKGtM
 scGzyjsI32SajZAKKzVN/QybX0gFm4gwBGHndbsYl4qyYpdTAsTIwc40vb14gj8j8f0t
 avyzIuV2/fC7zjCnabA39d4cPeudWRS7wLfjSMxIjBuAYlYwn1NIScbEMugCG8Q4Vq8D
 7JjXWH4fqlvMJrAL33O2MAN08lIPFY5z+76xnC0T+mI2p/G5a7+QXYWDO4E2o3s+Fywq
 SOpgZBMQLZ1WTkM+rKhsz1lI7bw+PXvxwVOprw0g7tOpvZO5M18IvNLBSc5sq0+CTU0V NQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mew61gdkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 17:00:58 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BDGiTEm030956
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 17:00:58 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mew61gdjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 17:00:58 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDGokjU030119;
        Tue, 13 Dec 2022 17:00:56 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3mchr5vfsw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 17:00:56 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BDH0r9744826882
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 17:00:53 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A7F62004B;
        Tue, 13 Dec 2022 17:00:53 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02A0B20049;
        Tue, 13 Dec 2022 17:00:53 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 13 Dec 2022 17:00:52 +0000 (GMT)
Date:   Tue, 13 Dec 2022 18:00:51 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>, kvm@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 1/1] s390x: add parallel skey
 migration test
Message-ID: <20221213180051.0b3a365b@p-imbrenda>
In-Reply-To: <167092140591.10919.7530526866489219030@t14-nrb.local>
References: <20221209102122.447324-1-nrb@linux.ibm.com>
        <20221209102122.447324-2-nrb@linux.ibm.com>
        <a54eb84516a5fcb1799ae864caff6aefc31b1896.camel@linux.ibm.com>
        <167092140591.10919.7530526866489219030@t14-nrb.local>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pvRSLwM10IGhqoSCY4BVbMwRiem18huS
X-Proofpoint-ORIG-GUID: jZQMbSHXNlXpnuW5oZLGpLfMT995ZMOz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 suspectscore=0 adultscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=999 mlxscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212130147
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Dec 2022 09:50:06 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> Quoting Nina Schoetterl-Glausch (2022-12-12 21:37:28)
> > On Fri, 2022-12-09 at 11:21 +0100, Nico Boehr wrote:  
> > > Right now, we have a test which sets storage keys, then migrates the VM
> > > and - after migration finished - verifies the skeys are still there.
> > > 
> > > Add a new version of the test which changes storage keys while the
> > > migration is in progress. This is achieved by adding a command line
> > > argument to the existing migration-skey test.
> > > 
> > > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> > > ---
> > >  s390x/migration-skey.c | 214 +++++++++++++++++++++++++++++++++++------
> > >  s390x/unittests.cfg    |  15 ++-
> > >  2 files changed, 198 insertions(+), 31 deletions(-)
> > > 
> > > diff --git a/s390x/migration-skey.c b/s390x/migration-skey.c
> > > index b7bd82581abe..9b9a45f4ad3b 100644
> > > --- a/s390x/migration-skey.c
> > > +++ b/s390x/migration-skey.c
> > >   
> > [...]
> >   
> > > +static void test_skey_migration_parallel(void)
> > > +{
> > > +     report_prefix_push("parallel");
> > > +
> > > +     if (smp_query_num_cpus() == 1) {
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
> > 
> > Are you doing it this way instead of while(!READ_ONCE(thread_exited)); so the mb() does double duty
> > and ensures "result" is also read from memory a couple of lines down?  
> 
> It is a good point, actually I just did what we already do in wait_for_flag in s390x/smp.c. :-)
> 
> > If so, I wonder if the compiler is allowed to arrange the control flow such that if the loop condition
> > is false on the first iteration it uses a cached value of "result" (I'd be guessing yes, but what do I know).  
> 
> I agree, but it does not matter, does it? At latest the second iteration will actually read from memory, no?
> 
> > In any case using a do while loop instead would eliminate the question.
> > A comment might be nice, too.  
> 
> How about I change to
>   while(!READ_ONCE(thread_exited)); 
> and add an explicit mb() below to ensure result is read from memory?

yes please

