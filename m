Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8CD42A84B
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 17:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237447AbhJLPdk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 11:33:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60534 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237446AbhJLPdj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Oct 2021 11:33:39 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CF6gVV026729;
        Tue, 12 Oct 2021 11:31:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=rIJHmneO6b8JEE5Jgan+CUYUF90aBeFzVWjaVg1ZZtA=;
 b=cvFHFtqY3VRYjl2Cxyjhsu7tDhGigJofQkSGi/0dwKvhsQAN8h0SY6JvmcYUiyBxg/x/
 JcpAnhoYYoYJkFhF2Nrl0yfLnN7CJfmwLZg95tBqMgeW6IaVUAFW2iyQBHw+Ry3UjbHR
 ABLbDEIgCURfoESQmtZ9YpLh/xpNfJmgdKbd4ZKX5ExnQnm+wJHjkWsh4aGnVZM+SvSM
 iKNSR+upwMz9rBzgWH29sfyLTq5dfIbjRSK+ZSCluR2tt/NumWRHBFF2/iNSGqzt0OGm
 yNe1pUeybmVEmXldV5/1rccVblLw1ItINgetHC/A7yR1qV6fFDwJkDyNeauyhzBJLC5l Sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bn998xnqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 11:31:36 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19CFUQZu011527;
        Tue, 12 Oct 2021 11:31:36 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bn998xnqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 11:31:36 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19CF7OY0030016;
        Tue, 12 Oct 2021 15:31:35 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma04dal.us.ibm.com with ESMTP id 3bkeq6ur8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 15:31:35 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19CFVX2G47251712
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 15:31:33 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA84BB2066;
        Tue, 12 Oct 2021 15:31:33 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24CDDB206E;
        Tue, 12 Oct 2021 15:31:31 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.134.52])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 12 Oct 2021 15:31:30 +0000 (GMT)
Message-ID: <0e4bb561170a287cea4124e9da56dfc4bd4a0eab.camel@linux.ibm.com>
Subject: Re: [RFC PATCH v1 3/6] KVM: s390: Simplify SIGP Restart
From:   Eric Farman <farman@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Date:   Tue, 12 Oct 2021 11:31:29 -0400
In-Reply-To: <518fea79-1579-ee4a-c09b-ae4e70e32d96@redhat.com>
References: <20211008203112.1979843-1-farman@linux.ibm.com>
         <20211008203112.1979843-4-farman@linux.ibm.com>
         <e3b874c1-e220-5e23-bd67-ed08c261e425@de.ibm.com>
         <518fea79-1579-ee4a-c09b-ae4e70e32d96@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QqozCKIKIr3vF-tcfMiDOhvYp6JGNzsz
X-Proofpoint-ORIG-GUID: 6948OurCYhaRDqlzz92a8B_9PDaXsTZM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-12_04,2021-10-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 clxscore=1015 bulkscore=0 lowpriorityscore=0 impostorscore=0 phishscore=0
 suspectscore=0 malwarescore=0 priorityscore=1501 spamscore=0
 mlxlogscore=894 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110120086
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-10-12 at 17:23 +0200, Thomas Huth wrote:
> On 11/10/2021 09.45, Christian Borntraeger wrote:
> > 
> > Am 08.10.21 um 22:31 schrieb Eric Farman:
> > > Now that we check for the STOP IRQ injection at the top of the
> > > SIGP
> > > handler (before the userspace/kernelspace check), we don't need
> > > to do
> > > it down here for the Restart order.
> > > 
> > > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > > ---
> > >   arch/s390/kvm/sigp.c | 11 +----------
> > >   1 file changed, 1 insertion(+), 10 deletions(-)
> > > 
> > > diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
> > > index 6ca01bbc72cf..0c08927ca7c9 100644
> > > --- a/arch/s390/kvm/sigp.c
> > > +++ b/arch/s390/kvm/sigp.c
> > > @@ -240,17 +240,8 @@ static int __sigp_sense_running(struct
> > > kvm_vcpu *vcpu,
> > >   static int __prepare_sigp_re_start(struct kvm_vcpu *vcpu,
> > >                      struct kvm_vcpu *dst_vcpu, u8 order_code)
> > >   {
> > > -    struct kvm_s390_local_interrupt *li = &dst_vcpu-
> > > >arch.local_int;
> > >       /* handle (RE)START in user space */
> > > -    int rc = -EOPNOTSUPP;
> > > -
> > > -    /* make sure we don't race with STOP irq injection */
> > > -    spin_lock(&li->lock);
> > > -    if (kvm_s390_is_stop_irq_pending(dst_vcpu))
> > > -        rc = SIGP_CC_BUSY;
> > > -    spin_unlock(&li->lock);
> > > -
> > > -    return rc;
> > > +    return -EOPNOTSUPP;
> > >   }
> > >   static int __prepare_sigp_cpu_reset(struct kvm_vcpu *vcpu,
> > > 
> > 
> > @thuth?
> > Question is, does it make sense to merge patch 2 and 3 to make
> > things more 
> > obvious?
> 
> Maybe.
> 
> Anyway: Would it make sense to remove __prepare_sigp_re_start()
> completely 
> now and let __prepare_sigp_unknown() set the return code in the
> "default:" case?

We could, but that would affect the SIGP START case which also uses the
re_start routine. And if we're going down that path, we could remove
(INITIAL) CPU RESET handled in __prepare_sigp_cpu_reset, which does the
same thing (nothing). Not sure it buys us much, other than losing the
details in the different counters of which SIGP orders are processed.

Eric

> 
>   Thomas
> 

