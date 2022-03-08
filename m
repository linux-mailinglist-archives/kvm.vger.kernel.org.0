Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF8764D14D2
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 11:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbiCHKdJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 05:33:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345901AbiCHKdA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 05:33:00 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D422A42EF5;
        Tue,  8 Mar 2022 02:32:04 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2287Q4pV013390;
        Tue, 8 Mar 2022 10:32:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=+Rkqa/FeIGw5LwvCZhlrJeoyRXSJ+gn4GGc1oqUoRQ4=;
 b=JcYT+DCIS4pjxDiBQ4BtXA+4d7dXp8ki8fKTtY98dK6k0b/7eSDuWrklyk/EI8wWcoU3
 2vMDWJ1IufNLUnUxKGR+BIPuidIpqJvwR/QOZGUAslgjzvQ3xJy0R5GunGANx7QOo5km
 lDsaJ60q7A9F6uE0EJej9x9IZzxNYTUPv5HqIvr7NuLMfwTPJMWyIC3RwDmLtw2fZ0Qr
 UZvdMEHLisqN32CrldeaP0q/m7/4vlbrg4GAWbj1I0N+8o4Dy476LD3mLV63b2fI45FW
 glleZvUYFqGJ8kjjf3yR3CM943Kzc2qK1BsV5DCc8M6J6tKWgijGSztewOxQntAl39Vq mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3envcut5fw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Mar 2022 10:32:03 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 228AFa3h015136;
        Tue, 8 Mar 2022 10:32:03 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3envcut5fm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Mar 2022 10:32:03 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 228ABxZf007690;
        Tue, 8 Mar 2022 10:32:01 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3ekyg8y5rb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Mar 2022 10:32:01 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 228AVwZO31523092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Mar 2022 10:31:58 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80E4F5206D;
        Tue,  8 Mar 2022 10:31:58 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.10.106])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2964C52074;
        Tue,  8 Mar 2022 10:31:58 +0000 (GMT)
Date:   Tue, 8 Mar 2022 11:31:55 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH kvm-unit-tests v1 4/6] s390x: smp: Create and use a
 non-waiting CPU stop
Message-ID: <20220308113155.24c7a5f4@p-imbrenda>
In-Reply-To: <2066eb382d42a27db9417ea47d79f2fbee0a2af0.camel@linux.ibm.com>
References: <20220303210425.1693486-1-farman@linux.ibm.com>
        <20220303210425.1693486-5-farman@linux.ibm.com>
        <20220307163007.0213714e@p-imbrenda>
        <2066eb382d42a27db9417ea47d79f2fbee0a2af0.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SR-FzUN75TiuDLJNii78-Con3oAxkCzT
X-Proofpoint-ORIG-GUID: yGmHTdDCHf02sDw26lOYjcUrGa_bbUe5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-08_03,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 malwarescore=0 clxscore=1015 phishscore=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203080055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 07 Mar 2022 14:03:45 -0500
Eric Farman <farman@linux.ibm.com> wrote:

> On Mon, 2022-03-07 at 16:30 +0100, Claudio Imbrenda wrote:
> > On Thu,  3 Mar 2022 22:04:23 +0100
> > Eric Farman <farman@linux.ibm.com> wrote:
> >   
> > > When stopping a CPU, kvm-unit-tests serializes/waits for everything
> > > to finish, in order to get a consistent result whenever those
> > > functions are used.
> > > 
> > > But to test the SIGP STOP itself, these additional measures could
> > > mask other problems. For example, did the STOP work, or is the CPU
> > > still operating?
> > > 
> > > Let's create a non-waiting SIGP STOP and use it here, to ensure
> > > that
> > > the CPU is correctly stopped. A smp_cpu_stopped() call will still
> > > be used to see that the SIGP STOP has been processed, and the state
> > > of the CPU can be used to determine whether the test passes/fails.
> > > 
> > > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > > ---
> > >  lib/s390x/smp.c | 25 +++++++++++++++++++++++++
> > >  lib/s390x/smp.h |  1 +
> > >  s390x/smp.c     | 10 ++--------
> > >  3 files changed, 28 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> > > index 368d6add..84e536e8 100644
> > > --- a/lib/s390x/smp.c
> > > +++ b/lib/s390x/smp.c
> > > @@ -119,6 +119,31 @@ int smp_cpu_stop(uint16_t idx)
> > >  	return rc;
> > >  }
> > >  
> > > +/*
> > > + * Functionally equivalent to smp_cpu_stop(), but without the
> > > + * elements that wait/serialize matters itself.
> > > + * Used to see if KVM itself is serialized correctly.
> > > + */
> > > +int smp_cpu_stop_nowait(uint16_t idx)
> > > +{
> > > +	/* refuse to work on the boot CPU */
> > > +	if (idx == 0)
> > > +		return -1;
> > > +
> > > +	spin_lock(&lock);
> > > +
> > > +	/* Don't suppress a CC2 with sigp_retry() */
> > > +	if (smp_sigp(idx, SIGP_STOP, 0, NULL)) {
> > > +		spin_unlock(&lock);
> > > +		return -1;
> > > +	}
> > > +
> > > +	cpus[idx].active = false;
> > > +	spin_unlock(&lock);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > >  int smp_cpu_stop_store_status(uint16_t idx)
> > >  {
> > >  	int rc;
> > > diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
> > > index 1e69a7de..bae03dfd 100644
> > > --- a/lib/s390x/smp.h
> > > +++ b/lib/s390x/smp.h
> > > @@ -44,6 +44,7 @@ bool smp_sense_running_status(uint16_t idx);
> > >  int smp_cpu_restart(uint16_t idx);
> > >  int smp_cpu_start(uint16_t idx, struct psw psw);
> > >  int smp_cpu_stop(uint16_t idx);
> > > +int smp_cpu_stop_nowait(uint16_t idx);
> > >  int smp_cpu_stop_store_status(uint16_t idx);
> > >  int smp_cpu_destroy(uint16_t idx);
> > >  int smp_cpu_setup(uint16_t idx, struct psw psw);
> > > diff --git a/s390x/smp.c b/s390x/smp.c
> > > index 50811bd0..11c2c673 100644
> > > --- a/s390x/smp.c
> > > +++ b/s390x/smp.c
> > > @@ -76,14 +76,8 @@ static void test_restart(void)
> > >  
> > >  static void test_stop(void)
> > >  {
> > > -	smp_cpu_stop(1);
> > > -	/*
> > > -	 * The smp library waits for the CPU to shut down, but let's
> > > -	 * also do it here, so we don't rely on the library
> > > -	 * implementation
> > > -	 */
> > > -	while (!smp_cpu_stopped(1)) {}
> > > -	report_pass("stop");
> > > +	smp_cpu_stop_nowait(1);  
> > 
> > can it happen that the SIGP STOP order is accepted, but the target
> > CPU
> > is still running (and not even busy)?  
> 
> Of course. A SIGP that's processed by userspace (which is many of them)
> injects a STOP IRQ back to the kernel, which means the CPU might not be
> stopped for some time. But...
> 
> >   
> > > +	report(smp_cpu_stopped(1), "stop");  
> > 
> > e.g. can this ^ check race with the actual stopping of the CPU?  
> 
> ...the smp_cpu_stopped() routine now loops on the CC2 that SIGP SENSE
> returns because of that pending IRQ. If SIGP SENSE returns CC0/1, then
> the CPU can correctly be identified stopped/operating, and the test can
> correctly pass/fail.

my question was: is it possible architecturally that there is a window
where the STOP order is accepted, but a SENSE on the target CPU still
successfully returns that the CPU is running?

in other words: is it specified architecturally that, once an order is
accepted for a target CPU, that CPU can't accept any other order (and
will return CC2), including SENSE, until the order has been completed
successfully?

> 
> >   
> > >  }
> > >  
> > >  static void test_stop_store_status(void)  
> 

