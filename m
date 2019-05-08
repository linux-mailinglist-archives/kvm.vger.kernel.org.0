Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D348A17578
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 11:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfEHJwK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 05:52:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35764 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbfEHJwK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 05:52:10 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BAAA659442;
        Wed,  8 May 2019 09:52:09 +0000 (UTC)
Received: from gondolin (ovpn-204-161.brq.redhat.com [10.40.204.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 00C7C410E;
        Wed,  8 May 2019 09:52:07 +0000 (UTC)
Date:   Wed, 8 May 2019 11:52:03 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Farhan Ali <alifm@linux.ibm.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, pasic@linux.vnet.ibm.com,
        farman@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v1 1/2] vfio-ccw: Set subchannel state STANDBY on open
Message-ID: <20190508115203.5596e207.cohuck@redhat.com>
In-Reply-To: <3a55983d-c304-ec7e-f53d-8380576b9a42@linux.ibm.com>
References: <1557148270-19901-1-git-send-email-pmorel@linux.ibm.com>
        <1557148270-19901-2-git-send-email-pmorel@linux.ibm.com>
        <3a55983d-c304-ec7e-f53d-8380576b9a42@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Wed, 08 May 2019 09:52:09 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 7 May 2019 15:44:54 -0400
Farhan Ali <alifm@linux.ibm.com> wrote:

> On 05/06/2019 09:11 AM, Pierre Morel wrote:
> > When no guest is associated with the mediated device,
> > i.e. the mediated device is not opened, the state of
> > the mediated device is VFIO_CCW_STATE_NOT_OPER.
> > 
> > The subchannel enablement and the according setting to the
> > VFIO_CCW_STATE_STANDBY state should only be done when all
> > parts of the VFIO mediated device have been initialized
> > i.e. after the mediated device has been successfully opened.
> > 
> > Let's stay in VFIO_CCW_STATE_NOT_OPER until the mediated
> > device has been opened.
> > 
> > When the mediated device is closed, disable the sub channel
> > by calling vfio_ccw_sch_quiesce() no reset needs to be done
> > the mediated devce will be enable on next open.  
> 
> s/devce/device
> 
> > 
> > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > ---
> >   drivers/s390/cio/vfio_ccw_drv.c | 10 +---------
> >   drivers/s390/cio/vfio_ccw_ops.c | 36 ++++++++++++++++++------------------
> >   2 files changed, 19 insertions(+), 27 deletions(-)
> > 
(...)
> > diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> > index 5eb6111..497419c 100644
> > --- a/drivers/s390/cio/vfio_ccw_ops.c
> > +++ b/drivers/s390/cio/vfio_ccw_ops.c
> > @@ -115,14 +115,10 @@ static int vfio_ccw_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
> >   	struct vfio_ccw_private *private =
> >   		dev_get_drvdata(mdev_parent_dev(mdev));
> >   
> > -	if (private->state == VFIO_CCW_STATE_NOT_OPER)
> > -		return -ENODEV;
> > -
> >   	if (atomic_dec_if_positive(&private->avail) < 0)
> >   		return -EPERM;
> >   
> >   	private->mdev = mdev;
> > -	private->state = VFIO_CCW_STATE_IDLE;
> >   
> >   	return 0;
> >   }
> > @@ -132,12 +128,7 @@ static int vfio_ccw_mdev_remove(struct mdev_device *mdev)
> >   	struct vfio_ccw_private *private =
> >   		dev_get_drvdata(mdev_parent_dev(mdev));
> >   
> > -	if ((private->state != VFIO_CCW_STATE_NOT_OPER) &&
> > -	    (private->state != VFIO_CCW_STATE_STANDBY)) {
> > -		if (!vfio_ccw_sch_quiesce(private->sch))
> > -			private->state = VFIO_CCW_STATE_STANDBY;
> > -		/* The state will be NOT_OPER on error. */
> > -	}
> > +	vfio_ccw_sch_quiesce(private->sch);
> >   
> >   	cp_free(&private->cp);
> >   	private->mdev = NULL;
> > @@ -151,6 +142,7 @@ static int vfio_ccw_mdev_open(struct mdev_device *mdev)
> >   	struct vfio_ccw_private *private =
> >   		dev_get_drvdata(mdev_parent_dev(mdev));
> >   	unsigned long events = VFIO_IOMMU_NOTIFY_DMA_UNMAP;
> > +	struct subchannel *sch = private->sch;
> >   	int ret;
> >   
> >   	private->nb.notifier_call = vfio_ccw_mdev_notifier;
> > @@ -165,6 +157,20 @@ static int vfio_ccw_mdev_open(struct mdev_device *mdev)
> >   		vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
> >   					 &private->nb);
> >   	return ret;

I think this "return ret;" needs to go into the if branch above it;
otherwise, the code below won't be reached :)

> > +
> > +	spin_lock_irq(private->sch->lock);
> > +	if (cio_enable_subchannel(sch, (u32)(unsigned long)sch))
> > +		goto error;
> > +
> > +	private->state = VFIO_CCW_STATE_STANDBY;  
> 
> I don't think we should set the state to STANDBY here, because with just 
> this patch applied, any VFIO_CCW_EVENT_IO_REQ will return an error (due 
> to fsm_io_error).
> 
> It might be safe to set it to IDLE in this patch.

Agreed, this should be IDLE; otherwise, I don't see how a device might
move into IDLE state?

(That change happens in the next patch anyway.)

> 
> 
> > +	spin_unlock_irq(sch->lock);
> > +	return 0;
> > +
> > +error:
> > +	spin_unlock_irq(sch->lock);
> > +	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
> > +				 &private->nb);
> > +	return -EFAULT;
> >   }
> >   
> >   static void vfio_ccw_mdev_release(struct mdev_device *mdev)
> > @@ -173,20 +179,14 @@ static void vfio_ccw_mdev_release(struct mdev_device *mdev)
> >   		dev_get_drvdata(mdev_parent_dev(mdev));
> >   	int i;
> >   
> > -	if ((private->state != VFIO_CCW_STATE_NOT_OPER) &&
> > -	    (private->state != VFIO_CCW_STATE_STANDBY)) {
> > -		if (!vfio_ccw_mdev_reset(mdev))
> > -			private->state = VFIO_CCW_STATE_STANDBY;
> > -		/* The state will be NOT_OPER on error. */
> > -	}
> > -
> > -	cp_free(&private->cp);
> > +	vfio_ccw_sch_quiesce(private->sch);
> >   	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
> >   				 &private->nb);
> >   
> >   	for (i = 0; i < private->num_regions; i++)
> >   		private->region[i].ops->release(private, &private->region[i]);
> >   
> > +	cp_free(&private->cp);

I'm wondering why this cp_free is moved -- there should not be any
activity related to it after quiesce, should there?

> >   	private->num_regions = 0;
> >   	kfree(private->region);
> >   	private->region = NULL;
> >   
> 

