Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75F537AD8C
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 20:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbhEKSDp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 14:03:45 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61574 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231329AbhEKSDo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 14:03:44 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14BHXoQE079511;
        Tue, 11 May 2021 14:02:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=9gbc07MJ/oH+bKxAS4D6X/PLuaWOG2D3y1TpnCLzUWk=;
 b=g+yjzM1yp7MrJC4lSXY3u+QuEzyiE+Gzs+3INuyNZB7ady4a/uS+3DR+JI60tJwqv7Gw
 7Ls7AM7i990sUpyNqjwa0ho7GKdHR8bqyyP01rycdhmGTxhnLw0CzyzuiJXOutH6/9nF
 uMZhaD8LXKh/xDR8/A2qnjtNzEKljmTjdiIOINdfQaX+NBXRE/lOc/x7dXI4o+kwQ22D
 0yr4L2EFUTeFuqGHdljwOzKSnzGy3siUVDFcqcgOizY6glcxRwi7ilrJUC+kKrRnaZm9
 OcwbT0NN2ipuJeCn0AxJ+pht0h8cBhDbniwgNnmAYIYFujcaC2N1t3WCjDtXEt2HKsKD rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38fx5697ta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 14:02:36 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14BHYMct084707;
        Tue, 11 May 2021 14:02:36 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38fx5697t3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 14:02:36 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14BHwFcd002325;
        Tue, 11 May 2021 18:02:35 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04dal.us.ibm.com with ESMTP id 38dj99nj0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 18:02:35 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14BI2YuL14877170
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 18:02:35 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D907BAC05F;
        Tue, 11 May 2021 18:02:34 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48D1AAC066;
        Tue, 11 May 2021 18:02:34 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.160.49.189])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 11 May 2021 18:02:34 +0000 (GMT)
Message-ID: <e51bbfff52948c39ec6e8a24762ce98ffc922768.camel@linux.ibm.com>
Subject: Re: [RFC PATCH v5 3/3] vfio-ccw: Serialize FSM IDLE state with I/O
 completion
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Date:   Tue, 11 May 2021 14:02:33 -0400
In-Reply-To: <20210511133154.66440087.cohuck@redhat.com>
References: <20210510205646.1845844-1-farman@linux.ibm.com>
         <20210510205646.1845844-4-farman@linux.ibm.com>
         <20210511133154.66440087.cohuck@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-14.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Rx1yy8Ti_DkJi-kmFltUaRsBIz0hGoNH
X-Proofpoint-ORIG-GUID: uA-6bQZvHvknSt6vnkt8S19LNKCuuNSr
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-11_04:2021-05-11,2021-05-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 phishscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 mlxlogscore=956 clxscore=1015 suspectscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-05-11 at 13:31 +0200, Cornelia Huck wrote:
> On Mon, 10 May 2021 22:56:46 +0200
> Eric Farman <farman@linux.ibm.com> wrote:
> 
> > Today, the stacked call to vfio_ccw_sch_io_todo() does three
> > things:
> > 
> >   1) Update a solicited IRB with CP information, and release the CP
> >      if the interrupt was the end of a START operation.
> >   2) Copy the IRB data into the io_region, under the protection of
> >      the io_mutex
> >   3) Reset the vfio-ccw FSM state to IDLE to acknowledge that
> >      vfio-ccw can accept more work.
> > 
> > The trouble is that step 3 is (A) invoked for both solicited and
> > unsolicited interrupts, and (B) sitting after the mutex for step 2.
> > This second piece becomes a problem if it processes an interrupt
> > for a CLEAR SUBCHANNEL while another thread initiates a START,
> > thus allowing the CP and FSM states to get out of sync. That is:
> > 
> >     CPU 1                           CPU 2
> >     fsm_do_clear()
> >     fsm_irq()
> >                                     fsm_io_request()
> >     vfio_ccw_sch_io_todo()
> >                                     fsm_io_helper()
> > 
> > Since the FSM state and CP should be kept in sync, let's make a
> > note when the CP is released, and rely on that as an indication
> > that the FSM should also be reset at the end of this routine and
> > open up the device for more work.
> > 
> > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > ---
> >  drivers/s390/cio/vfio_ccw_drv.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/s390/cio/vfio_ccw_drv.c
> > b/drivers/s390/cio/vfio_ccw_drv.c
> > index 8c625b530035..ef39182edab5 100644
> > --- a/drivers/s390/cio/vfio_ccw_drv.c
> > +++ b/drivers/s390/cio/vfio_ccw_drv.c
> > @@ -85,7 +85,7 @@ static void vfio_ccw_sch_io_todo(struct
> > work_struct *work)
> >  {
> >  	struct vfio_ccw_private *private;
> >  	struct irb *irb;
> > -	bool is_final;
> > +	bool is_final, is_finished = false;
> 
> <bikeshed>
> "is_finished" does not really say what is finished; maybe call it
> "cp_is_finished"?
> </bikeshed>

Sure, that's a bit clearer.

> 
> >  
> >  	private = container_of(work, struct vfio_ccw_private, io_work);
> >  	irb = &private->irb;
> > @@ -94,14 +94,16 @@ static void vfio_ccw_sch_io_todo(struct
> > work_struct *work)
> >  		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
> >  	if (scsw_is_solicited(&irb->scsw)) {
> >  		cp_update_scsw(&private->cp, &irb->scsw);
> > -		if (is_final && private->state ==
> > VFIO_CCW_STATE_CP_PENDING)
> > +		if (is_final && private->state ==
> > VFIO_CCW_STATE_CP_PENDING) {
> >  			cp_free(&private->cp);
> > +			is_finished = true;
> > +		}
> >  	}
> >  	mutex_lock(&private->io_mutex);
> >  	memcpy(private->io_region->irb_area, irb, sizeof(*irb));
> >  	mutex_unlock(&private->io_mutex);
> >  
> > -	if (private->mdev && is_final)
> > +	if (private->mdev && is_finished)
> 
> Maybe add a comment?
> 
> /*
>  * Reset to idle if processing of a channel program
>  * has finished; but do not overwrite a possible
>  * processing state if we got a final interrupt for hsch
>  * or csch.
>  */
> 
> Otherwise, I see us scratching our heads again in a few months :)

Almost certainly. :)

> 
> >  		private->state = VFIO_CCW_STATE_IDLE;
> >  
> >  	if (private->io_trigger)
> 
> Patch looks good to me.
> 

Thanks. Will make the above improvements and send as non-RFC.


