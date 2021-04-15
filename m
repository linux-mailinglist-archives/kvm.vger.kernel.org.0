Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6AE360AFD
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 15:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbhDONtO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 09:49:14 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26510 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233144AbhDONtF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Apr 2021 09:49:05 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13FDY7Yd109158;
        Thu, 15 Apr 2021 09:48:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=4XUs2J5nxDFQAhXE28DZqgVklwaSKIa5W7nAxd0tXK0=;
 b=ItC9XpqaYNjD6X5yPmx11rgO9b7B2GIMzWInYM/7PP5D27sRPDnfRoZqCMMK/Ui5SZfX
 5TF0dzAVh3zoZsTv9wZ9US1TCpAAgIkdsAQPcrb3UJyvknx6ByvUDjDa4haT6c3ZKgwe
 Ja4wuvYDR2hnns1nwui6SqCdiGjzF1tLhN7MnfgeuM2Y0NPTQrDJfd2BPgL5q8jbLhOm
 X1Aat5x8NdeiAu+H2MRzuxYoIJvczibvZFERRqXNrtV86wPorgyPV8gfW5HZzQSmZyWz
 9NICPnNyowkzL1JsnJj03oBlfTwetykho77XY8SUyltSqROtc9DG2jcC6BlDWFmuneSU Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37xbqb9c43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Apr 2021 09:48:41 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13FDYbj6110972;
        Thu, 15 Apr 2021 09:48:41 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37xbqb9c32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Apr 2021 09:48:41 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13FDgCAD026940;
        Thu, 15 Apr 2021 13:48:40 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma04wdc.us.ibm.com with ESMTP id 37wv832b39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Apr 2021 13:48:40 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13FDmduS32899420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Apr 2021 13:48:39 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87ED878060;
        Thu, 15 Apr 2021 13:48:39 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7176278067;
        Thu, 15 Apr 2021 13:48:38 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.160.103.97])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 15 Apr 2021 13:48:38 +0000 (GMT)
Message-ID: <ac08eb1143b5d354b8bcaf9117178fbd91bc2af2.camel@linux.ibm.com>
Subject: Re: [RFC PATCH v4 2/4] vfio-ccw: Check workqueue before doing START
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Date:   Thu, 15 Apr 2021 09:48:37 -0400
In-Reply-To: <20210415125131.33065221.cohuck@redhat.com>
References: <20210413182410.1396170-1-farman@linux.ibm.com>
         <20210413182410.1396170-3-farman@linux.ibm.com>
         <20210415125131.33065221.cohuck@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-14.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Kaj60_tReuVZla-QN9SLTmiQ2-QubT1D
X-Proofpoint-ORIG-GUID: wUoGZZct7YKNSE-y4SSY2vco3eBEclED
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-15_05:2021-04-15,2021-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 mlxscore=0 clxscore=1015 spamscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104150090
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-04-15 at 12:51 +0200, Cornelia Huck wrote:
> On Tue, 13 Apr 2021 20:24:08 +0200
> Eric Farman <farman@linux.ibm.com> wrote:
> 
> > When an interrupt is received via the IRQ, the bulk of the work
> > is stacked on a workqueue for later processing. Which means that
> > a concurrent START or HALT/CLEAR operation (via the async_region)
> > will race with this process and require some serialization.
> > 
> > Once we have all our locks acquired, let's just look to see if
> > we're
> > in a window where the process has been started from the IRQ, but
> > not
> > yet picked up by vfio-ccw to clean up an I/O. If there is, mark the
> > request as BUSY so it can be redriven.
> > 
> > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > ---
> >  drivers/s390/cio/vfio_ccw_fsm.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/drivers/s390/cio/vfio_ccw_fsm.c
> > b/drivers/s390/cio/vfio_ccw_fsm.c
> > index 23e61aa638e4..92d638f10b27 100644
> > --- a/drivers/s390/cio/vfio_ccw_fsm.c
> > +++ b/drivers/s390/cio/vfio_ccw_fsm.c
> > @@ -28,6 +28,11 @@ static int fsm_io_helper(struct vfio_ccw_private
> > *private)
> >  
> >  	spin_lock_irqsave(sch->lock, flags);
> >  
> > +	if (work_pending(&private->io_work)) {
> > +		ret = -EBUSY;
> > +		goto out;
> > +	}
> > +
> >  	orb = cp_get_orb(&private->cp, (u32)(addr_t)sch, sch->lpm);
> >  	if (!orb) {
> >  		ret = -EIO;
> 
> I'm wondering what condition we can consider this situation
> equivalent
> to. I'd say that the virtual version of the subchannel is basically
> status pending already, even though userspace may not have retrieved
> that information yet; so probably cc 1?

Yes, I guess cc1 is a more natural fit, since there is status pending
rather than an active start/halt/clear that would expect get the cc2.

> 
> Following the code path further along, it seems we return -EBUSY both
> for cc 1 and cc 2 conditions we receive from the device (i.e. they
> are
> not distinguishable from userspace). 

Yeah. :/

> I don't think we can change that,
> as it is an existing API (QEMU maps -EBUSY to cc 2.) So this change
> looks fine so far.
> 
> I'm wondering what we should do for hsch. We probably want to return
> -EBUSY for a pending condition as well, if I read the PoP
> correctly...

Ah, yes...  I agree that to maintain parity with ssch and pops, the
same cc1/-EBUSY would be applicable here. Will make that change in next
version.

> the only problem is that QEMU seems to match everything to 0; but
> that
> is arguably not the kernel's problem.
> 
> For clear, we obviously don't have busy conditions. Should we clean
> up
> any pending conditions?

By doing anything other than issuing the csch to the subchannel?  I
don't think so, that should be more than enough to get the css and
vfio-ccw in sync with each other.

> 
> [It feels like we have discussed this before, but any information has
> vanished from my cache :/]
> 

It has vanished from mine too, and looking over the old threads and
notes doesn't page anything useful in, so here we are. Sorry. :(

Eric


