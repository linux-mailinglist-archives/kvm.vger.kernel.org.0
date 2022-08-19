Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0CC159989B
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 11:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347999AbiHSJMW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 05:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348000AbiHSJMU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 05:12:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA3EF23C5
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 02:12:19 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27J92kcM007330
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 09:12:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=A01OxHIHKM/qy9OucOD4mrNV1qfAAkWu1HhAYb1aymA=;
 b=VjDKOIK2VTjJpuwlgHYOHlf3ni7ZiCFfAIEGMCtJq2HipGOykv3TNR2Ghx7MY3BtWa/m
 Kr6+Gbmp6HTNwetLyO1nK/Mg0cmsdaVcwbwAHqsT58aDizDTZy4cJVAyyQuhID7LBWF8
 vWorLHyGrCps4EYvbO87oRIAyZZQvGkZzdAqdR9fKPsVWlJsmO7UmS/QB44JaTYWPXHp
 CRTDP+a02gQQE9BCBGileyz/qNGOwIbFjlAHl5FsTC7R2AmQMIUYeVF5l1AdysNk9oyx
 wkrVxWAghWdx3il4UQk9T6dyMU4Wkxvpi4rj4amF8w59/jh4ggTO0CYsVjnEUgUBvqwJ kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j27hw06ae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 09:12:18 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27J94hWj013466
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 09:12:18 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3j27hw06a3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Aug 2022 09:12:17 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27J96Mqn022884;
        Fri, 19 Aug 2022 09:12:16 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3j0dc3aq30-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Aug 2022 09:12:16 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27J9CCCI30671336
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Aug 2022 09:12:12 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B53FBA4053;
        Fri, 19 Aug 2022 09:12:12 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6257FA404D;
        Fri, 19 Aug 2022 09:12:12 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.5.166])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Aug 2022 09:12:12 +0000 (GMT)
Date:   Fri, 19 Aug 2022 11:12:10 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, seiden@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v1 1/1] lib/s390x: fix SMP setup bug
Message-ID: <20220819111210.4b1e3fe6@p-imbrenda>
In-Reply-To: <d65e5beb-e417-b13d-f5f6-eb0e91ccc1f3@linux.ibm.com>
References: <20220818152114.213135-1-imbrenda@linux.ibm.com>
        <d65e5beb-e417-b13d-f5f6-eb0e91ccc1f3@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: j-Z15c7QWTLAaA7WtqY68-BmTrNNiMWq
X-Proofpoint-ORIG-GUID: 87ErDKvAYh1fO-Iik7o8WWgsxz5Yp27q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-19_04,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 mlxscore=0 clxscore=1015 spamscore=0 mlxlogscore=999 lowpriorityscore=0
 phishscore=0 priorityscore=1501 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208190036
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 19 Aug 2022 10:52:40 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 8/18/22 17:21, Claudio Imbrenda wrote:
> > The lowcore pointer pointing to the current CPU (THIS_CPU) was not
> > initialized for the boot CPU. The pointer is needed for correct
> > interrupt handling, which is needed in the setup process before the
> > struct cpu array is allocated.
> > 
> > The bug went unnoticed because some environments (like qemu/KVM) clear
> > all memory and don't write anything in the lowcore area before starting
> > the payload. The pointer thus pointed to 0, an area of memory also not
> > used. Other environments will write to memory before starting the
> > payload, causing the unit tests to crash at the first interrupt.
> > 
> > Fix by assigning a temporary struct cpu before the rest of the setup
> > process, and assigning the pointer to the correct allocated struct
> > during smp initialization.
> > 
> > Fixes: 4e5dd758 ("lib: s390x: better smp interrupt checks")
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>  
> 
> I've considered letting the IPL cpu have a static struct cpu and setting 
> it up in cstart64.S. But that would mean that we would need extra 
> handling when using smp functions and that'll look even worse.
> 
> Reported-by: Janosch Frank <frankja@linux.ibm.com>
> 
> > ---
> >   lib/s390x/io.c  | 9 +++++++++
> >   lib/s390x/smp.c | 1 +
> >   2 files changed, 10 insertions(+)
> > 
> > diff --git a/lib/s390x/io.c b/lib/s390x/io.c
> > index a4f1b113..fb7b7dda 100644
> > --- a/lib/s390x/io.c
> > +++ b/lib/s390x/io.c
> > @@ -33,6 +33,15 @@ void puts(const char *s)
> >   
> >   void setup(void)
> >   {
> > +	struct cpu this_cpu_tmp = { 0 };  
> 
> We can setup these struct members here and memcpy in smp_setup()
> .addr = stap();
> .stack = stackptr;

stackptr is accessible in io.c (I would need to add an extern
declaration)

> .lowcore = (void *)0;
> .active = true;

this temporary struct is then not accessible from smp_setup, so it
can't be memcpy-ed.

if you really want something meaningful in the temporary struct, it has
to be initialized in smp.c and called in io.c (something like
smp_boot_cpu_tmp_setup(&this_cpu_tmp) ), but then still no memcpy.

in the end the struct cpu is needed only to allow interrupts to happen
without crashes, I don't think we strictly need initialization

> 
> 
> > +
> > +	/*
> > +	 * Set a temporary empty struct cpu for the boot CPU, needed for
> > +	 * correct interrupt handling in the setup process.
> > +	 * smp_setup will allocate and set the permanent one.
> > +	 */
> > +	THIS_CPU = &this_cpu_tmp;
> > +
> >   	setup_args_progname(ipl_args);
> >   	setup_facilities();
> >   	sclp_read_info();
> > diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> > index 0d98c17d..03d6d2a4 100644
> > --- a/lib/s390x/smp.c
> > +++ b/lib/s390x/smp.c
> > @@ -353,6 +353,7 @@ void smp_setup(void)
> >   			cpus[0].stack = stackptr;
> >   			cpus[0].lowcore = (void *)0;
> >   			cpus[0].active = true;
> > +			THIS_CPU = &cpus[0];  
> 
> /* Override temporary struct cpu address with permanent one */

will be done

> 
> >   		}
> >   	}
> >   	spin_unlock(&lock);  
> 

