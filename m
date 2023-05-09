Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82616FCA11
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 17:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236094AbjEIPRt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 11:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235974AbjEIPRl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 11:17:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CDD55246;
        Tue,  9 May 2023 08:17:40 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 349FBqMH002486;
        Tue, 9 May 2023 15:17:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Af2VQI1T69tDDRRekZ/MH5dGctquO7a7wHILz5QViF4=;
 b=K1nwmdFmrOGS8hzRvfBwj4w8/bEcSLMUzojYWrsBtQ6UFd5m1kmpEy9H4pne7Wc00I7Q
 wAGIRA5HcP3lMr9xYfNg27F1fCgFxcpHWJth+rU1bz/aVSXy+T830IJVKGz8EYWxeMdP
 DWhzUfDwJUFgA5Qg3o16qpZOG/R1u7XRK9wZ4nDdG/55Mmg/hG9R3xltGVBCMvKxm2FC
 Fy/FdLgcPvqn901KkTgbzaekgy6Fx8Odoy1I5PrYSbJkXuTzNcbEbQjWi1jPAmsVNa9P
 Uv92P8u9RF7R6DqJBWAKtGrr6vhLyMScvoNbbcUYrZ0IrFzmA1hA+wSQgISRc6zJDoV4 fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qfrkv0b80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 15:17:38 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 349FBwsO003468;
        Tue, 9 May 2023 15:17:38 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qfrkv0b5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 15:17:38 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3493vjUX019814;
        Tue, 9 May 2023 15:17:35 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3qf896rh1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 15:17:35 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 349FHVVw36963068
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 May 2023 15:17:31 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E8B620040;
        Tue,  9 May 2023 15:17:31 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D9982004D;
        Tue,  9 May 2023 15:17:31 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  9 May 2023 15:17:31 +0000 (GMT)
Date:   Tue, 9 May 2023 17:17:29 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     borntraeger@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 2/3] KVM: s390: add stat counter for shadow gmap
 events
Message-ID: <20230509171729.1a69f89b@p-imbrenda>
In-Reply-To: <168364399371.331309.5908202452338432368@t14-nrb>
References: <20230509111202.333714-1-nrb@linux.ibm.com>
        <20230509111202.333714-3-nrb@linux.ibm.com>
        <20230509134351.1ac4ea63@p-imbrenda>
        <168364399371.331309.5908202452338432368@t14-nrb>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: syIqV5uYwwLm0wqJ4DKbwVZrPmeb6Mru
X-Proofpoint-ORIG-GUID: EQXUgesW4lqxJdEVLQsIMuq8tRvT3aD_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-09_08,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2304280000 definitions=main-2305090124
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 09 May 2023 16:53:13 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> Quoting Claudio Imbrenda (2023-05-09 13:43:51)
> [...]
> > > diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> > > index 3eb85f254881..8348a0095f3a 100644
> > > --- a/arch/s390/kvm/gaccess.c
> > > +++ b/arch/s390/kvm/gaccess.c
> > > @@ -1382,6 +1382,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
> > >                                 unsigned long *pgt, int *dat_protection,
> > >                                 int *fake)
> > >  {
> > > +     struct kvm *kvm;
> > >       struct gmap *parent;
> > >       union asce asce;
> > >       union vaddress vaddr;
> > > @@ -1390,6 +1391,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
> > >  
> > >       *fake = 0;
> > >       *dat_protection = 0;
> > > +     kvm = sg->private;
> > >       parent = sg->parent;
> > >       vaddr.addr = saddr;
> > >       asce.val = sg->orig_asce;
> > > @@ -1450,6 +1452,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
> > >               rc = gmap_shadow_r2t(sg, saddr, rfte.val, *fake);
> > >               if (rc)
> > >                       return rc;
> > > +             kvm->stat.gmap_shadow_r2++;
> > >       }
> > >               fallthrough;
> > >       case ASCE_TYPE_REGION2: {
> > > @@ -1478,6 +1481,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
> > >               rc = gmap_shadow_r3t(sg, saddr, rste.val, *fake);
> > >               if (rc)
> > >                       return rc;
> > > +             kvm->stat.gmap_shadow_r3++;
> > >       }
> > >               fallthrough;
> > >       case ASCE_TYPE_REGION3: {
> > > @@ -1515,6 +1519,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
> > >               rc = gmap_shadow_sgt(sg, saddr, rtte.val, *fake);
> > >               if (rc)
> > >                       return rc;
> > > +             kvm->stat.gmap_shadow_segment++;
> > >       }
> > >               fallthrough;
> > >       case ASCE_TYPE_SEGMENT: {
> > > @@ -1548,6 +1553,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
> > >               rc = gmap_shadow_pgt(sg, saddr, ste.val, *fake);
> > >               if (rc)
> > >                       return rc;
> > > +             kvm->stat.gmap_shadow_page++;  
> > 
> > do I understand correctly that, if several levels need to be shadowed
> > at the same time, you will increment every affected counter, and not
> > just the highest or lowest level?
> > 
> > if so, please add a brief explanation to the patch description  
> 
> Yes, that seemed like the simplest thing to do.
> 
> Will add a explanation.
> 
> Or should I add a flag and only increment the top level?

that's up to you, see what makes more sense
