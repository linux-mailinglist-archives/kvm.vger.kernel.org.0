Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D36364CD63B
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 15:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238138AbiCDOVX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 09:21:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbiCDOVT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 09:21:19 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 771761BA92A;
        Fri,  4 Mar 2022 06:20:31 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 224Dn6aK020754;
        Fri, 4 Mar 2022 14:20:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=2KeazUHr1d9Mpyu9z7Xn0YHMUff25x9RGM0AZPjL1zo=;
 b=Pd94WGscmoZ131Wm37CQ+7KD0eiqt+gzhCBrSVoqIjj0PSNFKJBMX7FDa+4WKAFMscp/
 Ceg0K3nPsR2wQA+lIPtAEvLhuvWVVpunuC8S4bu//YzWN5Ukv654VojfbNexssDg89I5
 a0QPm9j0lhmKUhpJfScJrhmJ0cIOsQOiYLa/W/qGZdt+tfqjqw8OJMO6NASZhi/SKf/r
 HPY+wpIw4eMHvZfZ4bACusJN4XpjPdf/xyeftOGZUwVK9YQHDP7UKtLaZb3AsZptkNYA
 uEAJQpcJPrLBlAtQQD1u8f8WZdTbxmiymuzsuHkI0puW0ywZvVlJzWYgoapNuVZh479b PA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ekm03rn6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 14:20:30 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 224DveIP015874;
        Fri, 4 Mar 2022 14:20:30 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ekm03rn6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 14:20:30 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 224EIiIl022505;
        Fri, 4 Mar 2022 14:20:29 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01dal.us.ibm.com with ESMTP id 3ek4jyxh8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 14:20:29 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 224EKRQk46137710
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Mar 2022 14:20:27 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5625DB2066;
        Fri,  4 Mar 2022 14:20:27 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75FD8B206A;
        Fri,  4 Mar 2022 14:20:25 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.148.123])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  4 Mar 2022 14:20:25 +0000 (GMT)
Message-ID: <2172fb34085c311e95c878457dbf55035efa9c78.camel@linux.ibm.com>
Subject: Re: [PATCH kvm-unit-tests v1 2/6] s390x: smp: Test SIGP RESTART
 against stopped CPU
From:   Eric Farman <farman@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Fri, 04 Mar 2022 09:20:24 -0500
In-Reply-To: <6f8205e1-7a79-77dc-12b6-30294398d29b@linux.ibm.com>
References: <20220303210425.1693486-1-farman@linux.ibm.com>
         <20220303210425.1693486-3-farman@linux.ibm.com>
         <6f8205e1-7a79-77dc-12b6-30294398d29b@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Xh26gD-tDL_S5MtqMTkZo9AwFXO3wo0U
X-Proofpoint-GUID: 4sSx7LUGZLax4geX4tSo5SFtCD0MFyaU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_06,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 phishscore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 impostorscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203040077
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-03-04 at 11:43 +0100, Janosch Frank wrote:
> On 3/3/22 22:04, Eric Farman wrote:
> > test_restart() makes two smp_cpu_restart() calls against CPU 1.
> > It claims to perform both of them against running (operating) CPUs,
> > but the first invocation tries to achieve this by calling
> > smp_cpu_stop() to CPU 0. This will be rejected by the library.
> 
> I played myself there :)

:)

> 
> > Let's fix this by making the first restart operate on a stopped
> > CPU,
> > to ensure it gets test coverage instead of relying on other
> > callers.
> > 
> > Fixes: 166da884d ("s390x: smp: Add restart when running test")
> > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> 
> If you want to you can add a report_pass() after the first wait flag.

I did in patch 5. I can move that here, but that patch has some
additional prefix changes for those reports, so didn't want to move TOO
much of that to this fix.

> 
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

Thank you!

> 
> > ---
> >   s390x/smp.c | 8 ++------
> >   1 file changed, 2 insertions(+), 6 deletions(-)
> > 
> > diff --git a/s390x/smp.c b/s390x/smp.c
> > index 068ac74d..2f4af820 100644
> > --- a/s390x/smp.c
> > +++ b/s390x/smp.c
> > @@ -50,10 +50,6 @@ static void test_start(void)
> >   	report_pass("start");
> >   }
> >   
> > -/*
> > - * Does only test restart when the target is running.
> > - * The other tests do restarts when stopped multiple times
> > already.
> > - */
> >   static void test_restart(void)
> >   {
> >   	struct cpu *cpu = smp_cpu_from_idx(1);
> > @@ -62,8 +58,8 @@ static void test_restart(void)
> >   	lc->restart_new_psw.mask = extract_psw_mask();
> >   	lc->restart_new_psw.addr = (unsigned long)test_func;
> >   
> > -	/* Make sure cpu is running */
> > -	smp_cpu_stop(0);
> > +	/* Make sure cpu is stopped */
> > +	smp_cpu_stop(1);
> >   	set_flag(0);
> >   	smp_cpu_restart(1);
> >   	wait_for_flag();

