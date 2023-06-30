Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B79B6743F38
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 17:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbjF3PyJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 11:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbjF3PyI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 11:54:08 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6943C00;
        Fri, 30 Jun 2023 08:54:07 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35UFlFkZ031586;
        Fri, 30 Jun 2023 15:54:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=FlFG3G4de/Le0/i/PtCvmY9M+3Ow1K98Zmm4qHFn4o8=;
 b=czetGp0xRUCQ4dJZD3647kYwxmllJ4lq1EJdxF8x0V7cx7KqNpm/4fySyx3DkE16QQuJ
 3Isa9DIE04xfYeeepXrrS7asiWFqc8FxbFAmXJZWpXvOtfOeVnOmj7uwccWa94+pC3e4
 4ubmmCxY7kAaXuQ7pfwrdSEjpJSy8Ivd11bn5jkU/rJuf/9yxwtsUHAkfvyNLJNbw5Zz
 RkBJPDedaqD3s56qhX90vnPb2hwvs7vG4KCdtue43iC9e9dBzi34gckXSmp8sqkIDykH
 p//Jyrwc9gaEcLmglCE08ZxHtOFGJdiIDn0p8FiadanVgwZL9FLPxtfuTb/G9mp5Jab8 Zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rj20e843d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 15:54:06 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35UFljVJ032346;
        Fri, 30 Jun 2023 15:54:06 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rj20e842d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 15:54:06 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35U1kGhT019237;
        Fri, 30 Jun 2023 15:54:03 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3rdr4547td-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 15:54:03 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35UFs0eV18088690
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Jun 2023 15:54:00 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B44620043;
        Fri, 30 Jun 2023 15:54:00 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 098AC2004D;
        Fri, 30 Jun 2023 15:54:00 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 30 Jun 2023 15:53:59 +0000 (GMT)
Date:   Fri, 30 Jun 2023 17:53:58 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, thuth@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 5/6] s390x: lib: sie: don't reenter
 SIE on pgm int
Message-ID: <20230630175358.5e3b290e@p-imbrenda>
In-Reply-To: <168813714644.32198.9739825161407676099@t14-nrb>
References: <20230601070202.152094-1-nrb@linux.ibm.com>
        <20230601070202.152094-6-nrb@linux.ibm.com>
        <baf4bb04-b258-f8b4-e49d-5d400e498bbf@linux.ibm.com>
        <168813714644.32198.9739825161407676099@t14-nrb>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0BdMR49osBuKU6P7-0KuVEcEBNyUxCvd
X-Proofpoint-ORIG-GUID: Lblogd3B1Ylx_oGj4Igrqr5Zh6OiGmUN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-30_08,2023-06-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=876 suspectscore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 bulkscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306300132
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 30 Jun 2023 16:59:06 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> [...]
> > > diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
> > > index 55759002dce2..fb4283a40a1b 100644
> > > --- a/lib/s390x/asm/interrupt.h
> > > +++ b/lib/s390x/asm/interrupt.h
> > > @@ -99,4 +99,18 @@ static inline void low_prot_disable(void)
> > >       ctl_clear_bit(0, CTL0_LOW_ADDR_PROT);
> > >   }
> > >   
> > > +/**
> > > + * read_pgm_int_code - Get the program interruption code of the last pgm int
> > > + * on the current CPU.  
> > 
> > All of the other functions are in the c file.  
> 
> Claudio requested this to be in the C file, I really don't mind much. Claudio,

you meant header

> maybe you can elaborate why you wanted it in the header.

so it can be inlined it's literally just a read... you can put it in
the C file if you want, but it seems a waste to me tbh 

> 
> > > + *
> > > + * This is similar to clear_pgm_int(), except that it doesn't clear the
> > > + * interruption information from lowcore.
> > > + *
> > > + * Returns 0 when none occured.  
> > 
> > s/r/rr/  
> 
> Fixed.
> 
> > > + */
> > > +static inline uint16_t read_pgm_int_code(void)
> > > +{  
> > 
> > No mb()?  
> 
> This is a function call, so none should be needed, no?

