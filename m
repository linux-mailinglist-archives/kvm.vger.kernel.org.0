Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE1F36849F
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 18:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236594AbhDVQQx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 12:16:53 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12252 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235232AbhDVQQx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 12:16:53 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13MG4CjX026679;
        Thu, 22 Apr 2021 12:16:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=ZIWXQPX90i80Lmle5fxjUFTlZhmILJEHM3oVIzOLnQE=;
 b=JtIN9KXy6dz4PzZULrRbjeHNQh9f2Tek5IWxUYph9GD45f4rtlFMP5sMPpZgU8K9yoSh
 LFb32nhazac6MYk5Nf1u6m1AGj6cRBRLRtMupKHS+ONKAGoDmuopbfX7c/Q5SPQfJI6c
 VkCyH843qJpdiDKdROH3WnNUqEbajVB33n6SM3njjszy3hd2ny7ClXH9hWUS8PS3tVpb
 b/4YnM3cF1/E+ZhaTcos0gNU+BAZpSLXaFV/bVmdJtJ7Ug/GWpGRAt2yjMQ0jhrcU4Vi
 BLtZLpWYDh1e/6GWB6huc5W3QkZboPECJ+TUla56zdGlbodZKYcb8agu06TO+B8+AA0p Vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3835faxwfq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Apr 2021 12:16:17 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13MG4Hjt027197;
        Thu, 22 Apr 2021 12:16:17 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3835faxwf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Apr 2021 12:16:17 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13MGCl0P007886;
        Thu, 22 Apr 2021 16:16:16 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04dal.us.ibm.com with ESMTP id 37yqaadwfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Apr 2021 16:16:16 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13MGGFeT26607960
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 16:16:15 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0744F6A047;
        Thu, 22 Apr 2021 16:16:15 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47A876A04D;
        Thu, 22 Apr 2021 16:16:14 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.160.17.178])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 22 Apr 2021 16:16:14 +0000 (GMT)
Message-ID: <2c1c1e73d488673ec39d7c085a343cbd6b50fb41.camel@linux.ibm.com>
Subject: Re: [RFC PATCH v4 4/4] vfio-ccw: Reset FSM state to IDLE before
 io_mutex
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Date:   Thu, 22 Apr 2021 12:16:13 -0400
In-Reply-To: <b1f3abf22a54430f5b332be46f7431a9deb061df.camel@linux.ibm.com>
References: <20210413182410.1396170-1-farman@linux.ibm.com>
         <20210413182410.1396170-5-farman@linux.ibm.com>
         <20210421122529.6e373a39.cohuck@redhat.com>
         <b1f3abf22a54430f5b332be46f7431a9deb061df.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-14.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zU91Dd6GbB3hzpadvrcLk2Z7DjRYVaFM
X-Proofpoint-GUID: XcmwMB9kQ9_Ln4gtSirzaOha227VrZan
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-22_11:2021-04-22,2021-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 suspectscore=0 mlxlogscore=734 clxscore=1015 bulkscore=0
 phishscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104220122
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-04-21 at 08:58 -0400, Eric Farman wrote:
> On Wed, 2021-04-21 at 12:25 +0200, Cornelia Huck wrote:
> > On Tue, 13 Apr 2021 20:24:10 +0200
> > Eric Farman <farman@linux.ibm.com> wrote:
> > 
> > > Today, the stacked call to vfio_ccw_sch_io_todo() does three
> > > things:
> > > 
> > > 1) Update a solicited IRB with CP information, and release the CP
> > > if the interrupt was the end of a START operation.
> > > 2) Copy the IRB data into the io_region, under the protection of
> > > the io_mutex
> > > 3) Reset the vfio-ccw FSM state to IDLE to acknowledge that
> > > vfio-ccw can accept more work.
> > > 
> > > The trouble is that step 3 is (A) invoked for both solicited and
> > > unsolicited interrupts, and (B) sitting after the mutex for step
> > > 2.
> > > This second piece becomes a problem if it processes an interrupt
> > > for a CLEAR SUBCHANNEL while another thread initiates a START,
> > > thus allowing the CP and FSM states to get out of sync. That is:
> > > 
> > > 	CPU 1				CPU 2
> > > 	fsm_do_clear()
> > > 	fsm_irq()
> > > 					fsm_io_request()
> > > 					fsm_io_helper()
> > > 	vfio_ccw_sch_io_todo()
> > > 					fsm_irq()
> > > 					vfio_ccw_sch_io_todo()
> > > 
> > > Let's move the reset of the FSM state to the point where the
> > > channel_program struct is cleaned up, which is only done for
> > > solicited interrupts anyway.
> > > 
> > > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > > ---
> > >  drivers/s390/cio/vfio_ccw_drv.c | 7 +++----
> > >  1 file changed, 3 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/s390/cio/vfio_ccw_drv.c
> > > b/drivers/s390/cio/vfio_ccw_drv.c
> > > index 8c625b530035..e51318f23ca8 100644
> > > --- a/drivers/s390/cio/vfio_ccw_drv.c
> > > +++ b/drivers/s390/cio/vfio_ccw_drv.c
> > > @@ -94,16 +94,15 @@ static void vfio_ccw_sch_io_todo(struct
> > > work_struct *work)
> > >  		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
> > >  	if (scsw_is_solicited(&irb->scsw)) {
> > >  		cp_update_scsw(&private->cp, &irb->scsw);
> > > -		if (is_final && private->state ==
> > > VFIO_CCW_STATE_CP_PENDING)
> > > +		if (is_final && private->state ==
> > > VFIO_CCW_STATE_CP_PENDING) {
> > >  			cp_free(&private->cp);
> > > +			private->state = VFIO_CCW_STATE_IDLE;
> > > +		}
> > >  	}
> > >  	mutex_lock(&private->io_mutex);
> > >  	memcpy(private->io_region->irb_area, irb, sizeof(*irb));
> > >  	mutex_unlock(&private->io_mutex);
> > >  
> > > -	if (private->mdev && is_final)
> > > -		private->state = VFIO_CCW_STATE_IDLE;
> > 
> > Isn't that re-allowing new I/O requests a bit too early?
> 
> Hrm... I guess I don't see what work vfio-ccw has left to do that is
> presenting it from carrying on. The copying of the IRB data back into
> the io_region seems like a flimsy gate to me. But...
> 
> It seems you're (rightly) concerned with userspace doing SSCH + SSCH,
> whereas I'v been focused on the CSCH + SSCH sequence. So with this
> change, we're inviting the possibility of a second SSCH being able to
> be submitted/started before the IRB data for the first SSCH is copied
> (and presumably before userspace is tapped to read that data back).
> 
> Sigh... I guess that's not the greatest behavior either. Gotta
> ruminate
> on this.
> 
> >  Maybe remember
> > that we had a final I/O interrupt for an I/O request and only
> > change
> > the state in this case?
> 
> As a local flag within this routine? Hrm... I have entirely too many
> "Let's try this" branches that didn't work, but I don't see that one
> jumping out at me. Will give it a try.

Still going strong, so that bodes really well (knock wood). I need to
spend a little time with patch 2 before I send the next version, but
that shouldn't be too long.

Eric

> 
> > 
> > > -
> > >  	if (private->io_trigger)
> > >  		eventfd_signal(private->io_trigger, 1);
> > >  }

