Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E23E87068F8
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 15:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbjEQNLb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 09:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjEQNLa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 09:11:30 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4CCF1BC;
        Wed, 17 May 2023 06:11:29 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34HD9EPF026823;
        Wed, 17 May 2023 13:11:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=NkmU0qs0hWZqcsf/4uq6Vfvy/kpFAruMFUGfbC8SrnI=;
 b=Js0Dm64rPAXLc+f9314uD61D+HKbYf6QSchY+jGaXir+DLQl/z2JgVa7MF9w63FZuq4/
 INEzt3j9fJsrpKtsnc+IHr2kP9cJBxLNksLfZUYz9cf4pFS3begLDdc+/v+P53KItLuS
 Hmqx9knNLf1h/WRp49gJGcH/Rtmil7FvRcmia+ARsDT5ani5zy9vo8PRnPnlf4Xddl/Y
 ktJ1Th5U3hhKChTJ/KWQPPx96nSvNKCmri89r6gYoOpk/Ct5ekKc9m1S8oDposvTQjle
 TUCaiaxiXjt4wKFOF5TUwu0OSbsgyjlZRYia5Lao5pIinLjVlv/E1GtwTb/yxDnaMZae JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qmxuthufq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 May 2023 13:11:27 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34HDAUkQ005082;
        Wed, 17 May 2023 13:10:33 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qmxuthppe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 May 2023 13:10:17 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34HC6Ic3029373;
        Wed, 17 May 2023 13:04:30 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3qj264sted-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 May 2023 13:04:30 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34HD4QTl55509410
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 May 2023 13:04:26 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81B8D20043;
        Wed, 17 May 2023 13:04:26 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5858120040;
        Wed, 17 May 2023 13:04:26 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 17 May 2023 13:04:26 +0000 (GMT)
Date:   Wed, 17 May 2023 15:04:25 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 1/6] s390x: add function to set DAT
 mode for all interrupts
Message-ID: <20230517150425.19c4a7da@p-imbrenda>
In-Reply-To: <168432630149.12463.14017444493360473166@t14-nrb>
References: <20230516130456.256205-1-nrb@linux.ibm.com>
        <20230516130456.256205-2-nrb@linux.ibm.com>
        <20230516191724.0b9809ac@p-imbrenda>
        <168432630149.12463.14017444493360473166@t14-nrb>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qGYXCPwpaD_OQYqr0R2q791BH0HtzONq
X-Proofpoint-ORIG-GUID: dowI-1jmd9AEbQk-RMJLWcbtkQzWccT-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-17_02,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 phishscore=0 impostorscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 mlxlogscore=921
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305170106
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 17 May 2023 14:25:01 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> Quoting Claudio Imbrenda (2023-05-16 19:17:24)
> [...]
> > > diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> > > index 3f993a363ae2..1180ec44d72f 100644
> > > --- a/lib/s390x/interrupt.c
> > > +++ b/lib/s390x/interrupt.c  
> [...]
> > > +void irq_set_dat_mode(bool dat, uint64_t as)
> > > +{  
> [...]
> > > +     for (struct psw *irq_psw = irq_psws[0]; irq_psw != NULL; irq_psw++) {  
> > 
> > just call it psw, or cur_psw, it's a little confusing otherwise  
> 
> will do. 
> 
> [...]
> > alternatively, you can redefine psw with a bitfield (as you mentioned
> > offline):
> > 
> > cur_psw->mask.dat = dat;
> > if (dat)
> >         cur_psw->mask.as = as;  
> 
> Yep, I'll go with that.
> 
> >   
> > > +             else
> > > +                     irq_psw->mask |= PSW_MASK_DAT | as << (63 - 16);  
> > 
> > otherwise here you're ORing stuff to other stuff, if you had 3 and you
> > OR 0 you get 3, but you actually want 0  
> 
> And that's the advantage of the bitfield. :)
> 
> >   
> > > +     }
> > > +
> > > +     mb();  
> > 
> > what's the purpose of this?  
> 
> Make sure that the lowcore really has been written, but I think it's quite
> useless, since a function is a sequence point, right?

yes
