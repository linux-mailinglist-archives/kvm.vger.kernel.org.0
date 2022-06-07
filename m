Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56A115401A0
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 16:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245726AbiFGOl2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 10:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245724AbiFGOlX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 10:41:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A84BE164;
        Tue,  7 Jun 2022 07:41:22 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 257EWGqO011449;
        Tue, 7 Jun 2022 14:41:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=RVKQrAcLKVgNmdn0jsaVzE1vIho4Lo1HnwaEBkWgLko=;
 b=oOQn4C12Fp5bAXXnmDkAre+lMypIdiKkW0rNJ9m/fOQkQo32uXWKHtqdUHCusS9ACiKj
 QM8zsG12FoIrrJlOxEjJN9U0HvjTqBhyigKLCPifQ4wTXKponq+p60Ykt1mUdenX1Vwt
 PL9FanfCozm5gxjOVGXACTswWiXZOknUjuHmjRHnOlAmU6u9wXJYkOYG0gpAzayZGEdB
 O3HCSm2bKWik8AXLG1IJxsC5mmzhdHGGP8oUfxH0gdvScOzA0zA+GYVSA7k1nm+3SfAd
 kwxN0tHjEYRUeXc6iVj/6Lz96egpSq0izCna2lE/F241zB5rC9Xrr+bs79SadfG7C7jx 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gj818h391-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jun 2022 14:41:22 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 257EWRA9012778;
        Tue, 7 Jun 2022 14:41:21 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gj818h389-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jun 2022 14:41:21 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 257EKr4h006833;
        Tue, 7 Jun 2022 14:41:19 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3gfy18u1uq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jun 2022 14:41:19 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 257EfFDY15860076
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Jun 2022 14:41:15 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B38EEA405B;
        Tue,  7 Jun 2022 14:41:15 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 779DFA4054;
        Tue,  7 Jun 2022 14:41:15 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.40])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  7 Jun 2022 14:41:15 +0000 (GMT)
Date:   Tue, 7 Jun 2022 16:41:13 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, scgl@linux.ibm.com, pmorel@linux.ibm.com,
        thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 2/2] lib: s390x: better smp interrupt
 checks
Message-ID: <20220607164113.5d51f37d@p-imbrenda>
In-Reply-To: <20220607162309.25e97913@li-ca45c2cc-336f-11b2-a85c-c6e71de567f1>
References: <20220603154037.103733-1-imbrenda@linux.ibm.com>
        <20220603154037.103733-3-imbrenda@linux.ibm.com>
        <20220607162309.25e97913@li-ca45c2cc-336f-11b2-a85c-c6e71de567f1>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XSk66zcLWIa2MZhCSw-7vS2OSr-HvBSR
X-Proofpoint-ORIG-GUID: O7ce2QGtr_Rb8xtcNe3fy-d8k9liRY3y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-07_06,2022-06-07_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 spamscore=0 mlxlogscore=813 malwarescore=0
 bulkscore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206070058
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 7 Jun 2022 16:23:09 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> On Fri,  3 Jun 2022 17:40:37 +0200
> Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:
> 
> > 0x1200 */ diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> > index 27d3b767..e57946f0 100644  
> [...]
> > @@ -30,7 +27,7 @@ void expect_pgm_int(void)
> >  
> >  void expect_ext_int(void)
> >  {
> > -	ext_int_expected = true;
> > +	lc->ext_int_expected = 1;  
> 
> External Interrupts can be floating; so if I am not mistaken it could be delivered to a different CPU which didn't expect it.

yes I have considered that (maybe I should add this in the patch
description)

for floating interrupts, the testcase should take care to mask the
interrupt on the CPUs where it should not be received.

by default all interrupts are masked anyway and CPUs should only enable
them on a case by case basis

> 
> [...]
> > @@ -237,17 +231,17 @@ void handle_io_int(void)
> >  
> >  int register_io_int_func(void (*f)(void))
> >  {
> > -	if (io_int_func)
> > +	if (lc->io_int_func)
> >  		return -1;  
> 
> IO interrupts also are floating. Same concern as for the external interrupts.

same here

the alternative is to have a separate handling of floating vs
non-floating interrupts, which maybe would get a little out of hand
