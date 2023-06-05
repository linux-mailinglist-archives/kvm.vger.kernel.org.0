Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 711A87223CD
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 12:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbjFEKre (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 06:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbjFEKrd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 06:47:33 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5BFEC;
        Mon,  5 Jun 2023 03:47:31 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 355AL18k009101;
        Mon, 5 Jun 2023 10:47:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ezphDjJs3eLOt8llI6QjB07NRnlwNLDA0VEDs69Dpgo=;
 b=B6k73OcEL8igTdtRVLc7m3LXhPeXT3OAfOhIVY/YX+G+CyxtaulHV8uMzTSnvUwMNCHD
 lT+C0H8IH223toij2ht1ML9yXUVQgz5Ws6DGM+YB36hkrLKxwYvrf5X65vEqaV689rZX
 9Dainc/nEUChuJrDPm/2eumi0SJe4hxGd7oZ9e9P5kAUaJqhd49QXTCvq59nD75AzChr
 B3doeLkqJsGPyLDLMXrcKsEgY9yo0F7fuwmjpz+xkeNCd+sAPHfsT5jAB5fCyR+Pd+mZ
 4IjAD6Bw0FPJlI2gL+jpnRL1Q2AvBF8qG8ex2w9Dmo+zvQZTS4giyMiO0BEC0shU6O84 mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r1dvjrfnk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 10:47:30 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 355AbtRI032711;
        Mon, 5 Jun 2023 10:47:30 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r1dvjrfmn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 10:47:30 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 355ARLVK031076;
        Mon, 5 Jun 2023 10:47:28 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3qyxdfh11r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 10:47:28 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 355AlOiF45220374
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Jun 2023 10:47:24 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C381820043;
        Mon,  5 Jun 2023 10:47:24 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9AC4E20040;
        Mon,  5 Jun 2023 10:47:24 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  5 Jun 2023 10:47:24 +0000 (GMT)
Date:   Mon, 5 Jun 2023 12:44:19 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     Nico Boehr <nrb@linux.ibm.com>, thuth@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 5/6] s390x: lib: sie: don't reenter
 SIE on pgm int
Message-ID: <20230605124419.6966ee2d@p-imbrenda>
In-Reply-To: <baf4bb04-b258-f8b4-e49d-5d400e498bbf@linux.ibm.com>
References: <20230601070202.152094-1-nrb@linux.ibm.com>
        <20230601070202.152094-6-nrb@linux.ibm.com>
        <baf4bb04-b258-f8b4-e49d-5d400e498bbf@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6drzule2txb1lWiutcohfYV-soSlZlqo
X-Proofpoint-GUID: oRnBvfb5anlWXkCy7LQiXoWuYzGO75Zx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-03_08,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 clxscore=1015 suspectscore=0 spamscore=0 malwarescore=0
 bulkscore=0 impostorscore=0 mlxlogscore=818 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306050094
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 5 Jun 2023 11:30:36 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

[,,,]

> > + */
> > +static inline uint16_t read_pgm_int_code(void)
> > +{  
> 
> No mb()?

is one needed there?

> 
> > +	return lowcore.pgm_int_code;
> > +}
> > +
> >   #endif
> > diff --git a/lib/s390x/asm/mem.h b/lib/s390x/asm/mem.h
> > index 64ef59b546a4..94d58c34f53f 100644
> > --- a/lib/s390x/asm/mem.h
> > +++ b/lib/s390x/asm/mem.h
> > @@ -8,6 +8,7 @@
> >   #ifndef _ASMS390X_MEM_H_
> >   #define _ASMS390X_MEM_H_
> >   #include <asm/arch_def.h>
> > +#include <asm/facility.h>
> >   
> >   /* create pointer while avoiding compiler warnings */
> >   #define OPAQUE_PTR(x) ((void *)(((uint64_t)&lowcore) + (x)))
> > diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
> > index ffa8ec91a423..632740edd431 100644
> > --- a/lib/s390x/sie.c
> > +++ b/lib/s390x/sie.c
> > @@ -13,6 +13,7 @@
> >   #include <libcflat.h>
> >   #include <sie.h>
> >   #include <asm/page.h>
> > +#include <asm/interrupt.h>
> >   #include <libcflat.h>
> >   #include <alloc_page.h>
> >   
> > @@ -65,7 +66,8 @@ void sie(struct vm *vm)
> >   	/* also handle all interruptions in home space while in SIE */
> >   	irq_set_dat_mode(IRQ_DAT_ON, AS_HOME);
> >   
> > -	while (vm->sblk->icptcode == 0) {
> > +	/* leave SIE when we have an intercept or an interrupt so the test can react to it */
> > +	while (vm->sblk->icptcode == 0 && !read_pgm_int_code()) {
> >   		sie64a(vm->sblk, &vm->save_area);
> >   		sie_handle_validity(vm);
> >   	}  
> 

