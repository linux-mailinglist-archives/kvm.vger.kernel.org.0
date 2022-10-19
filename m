Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01E2B6043E8
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 13:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbiJSLxb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 07:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231805AbiJSLxC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 07:53:02 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA37FF229
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 04:32:13 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29J9odjV004502
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 09:51:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=OJBfIUDwhmcQsuz0BmWey3sVlm0yrTl1GvmoK8JthFw=;
 b=ZDFUWdraDTubvYzij6EYT7QhGynITB5/uihYW61CmsqC7+Y1X+Aj6NV6zuTp/S1Rb2Hk
 vIEaCUZKTKr+zQtcetv4pzQHNZwvjQYY0l1+mwGHUsFF0AuR3aGp6qf+oy5y8aO/j6Br
 u1LD3lP1SxNwnPEZiTkoSEPuPzlTkevu7Hc7VXLyaKEVkJX5FoVerCw+kdoPOgOkHi78
 fXPvybg7Yg2gOHDHe9EVSjMjzv2tDixEgZ52OhsF4phiybmhootXY0LRCcf2/dvOfGev
 rqQA6Y0gM7tf5juiZqbDpNLL5281JreQCp0Bm/b+5I76zqh9oe7Cnz0lCfP6WjiKI+cu tA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kaeyb80n9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 09:51:36 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29J9pZiF007105
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 09:51:35 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kaeyb80ms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 09:51:35 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29J9oxrR003684;
        Wed, 19 Oct 2022 09:51:34 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3k7m4jpubx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 09:51:33 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29J9q3N350921776
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Oct 2022 09:52:03 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2908A4057;
        Wed, 19 Oct 2022 09:51:30 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8333BA404D;
        Wed, 19 Oct 2022 09:51:30 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.239])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 Oct 2022 09:51:30 +0000 (GMT)
Date:   Wed, 19 Oct 2022 11:51:28 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, seiden@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 1/2] lib: s390x: terminate if PGM
 interrupt in interrupt handler
Message-ID: <20221019115128.2a8cbf13@p-imbrenda>
In-Reply-To: <166616486603.37435.2225106614844458657@t14-nrb>
References: <20221018140951.127093-1-imbrenda@linux.ibm.com>
        <20221018140951.127093-2-imbrenda@linux.ibm.com>
        <166616486603.37435.2225106614844458657@t14-nrb>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ThriRgjP_SziwogJgWA_yBAzjq5md5qV
X-Proofpoint-ORIG-GUID: BeIIcMm92QCKYHgTPuhAK0zhPqwpUuE3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_06,2022-10-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 spamscore=0 mlxscore=0 bulkscore=0 phishscore=0 mlxlogscore=782
 clxscore=1015 lowpriorityscore=0 impostorscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210190052
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 19 Oct 2022 09:34:26 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> Quoting Claudio Imbrenda (2022-10-18 16:09:50)
> [...]
> > diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> > index 7cc2c5fb..22bf443b 100644
> > --- a/lib/s390x/interrupt.c
> > +++ b/lib/s390x/interrupt.c  
> [...]
> >  void handle_pgm_int(struct stack_frame_int *stack)
> >  {
> > +       if (THIS_CPU->in_interrupt_handler) {
> > +               /* Something went very wrong, stop everything now without printing anything */
> > +               smp_teardown();
> > +               disabled_wait(0xfa12edbad21);
> > +       }  
> 
> Maybe I am missing something, but is there a particular reson why you don't do
>  THIS_CPU->in_interrupt_handler = true;
> here as well?

I was thinking that we set pgm_int_expected = false so we would catch a
wild program interrupt there, but in hindsight maybe it's better to set
in_interrupt_handler = true there so we can abort immediately
