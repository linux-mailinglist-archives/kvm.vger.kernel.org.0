Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA6C68B5B0
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 12:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbfHMKec (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 06:34:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35394 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727520AbfHMKec (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 06:34:32 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4132830BA07B;
        Tue, 13 Aug 2019 10:34:32 +0000 (UTC)
Received: from gondolin (dhcp-192-232.str.redhat.com [10.33.192.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D8A9794C4;
        Tue, 13 Aug 2019 10:34:19 +0000 (UTC)
Date:   Tue, 13 Aug 2019 12:34:16 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, mjrosato@linux.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com
Subject: Re: [PATCH v5 6/7] s390: vfio-ap: add logging to vfio_ap driver
Message-ID: <20190813123416.0b039f54.cohuck@redhat.com>
In-Reply-To: <5b75a327-baac-7011-4a74-1174c7ba3ef6@linux.ibm.com>
References: <1564612877-7598-1-git-send-email-akrowiak@linux.ibm.com>
        <1564612877-7598-7-git-send-email-akrowiak@linux.ibm.com>
        <20190812123517.059046b6.cohuck@redhat.com>
        <5b75a327-baac-7011-4a74-1174c7ba3ef6@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 13 Aug 2019 10:34:32 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 12 Aug 2019 16:34:10 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 8/12/19 6:35 AM, Cornelia Huck wrote:
> > On Wed, 31 Jul 2019 18:41:16 -0400
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >   
> >> Added two DBF log files for logging events and errors; one for the vfio_ap
> >> driver, and one for each matrix mediated device.  
> > 
> > While the s390dbf is useful (especially for accessing the information
> > in dumps), trace points are a more standard interface. Have you
> > evaluated that as well? (We probably should add something to the
> > vfio/mdev code as well; tracing there is a good complement to tracing
> > in vendor drivers.)  
> 
> I assume you are talking about the TRACE() macro here? I have not

TRACE_EVENT() and friends (Documentation/trace/tracepoints.rst).

> evaluated that. I chose s390dbf for the sole reason that the
> AP bus (drivers/s390/crypto/ap_bus.c) uses s390dbf. I can look into
> using trace points. The genesis of this patch was in response to
> comments you made in the previous series (v4). Recall that assignment
> of an adapter or domain to a matrix mdev will fail if the APQN(s)
> resulting from the assignment are either owned by zcrypt or another
> matrix mdev. I said I'd provide a means for the admin to determine
> why the assignment failed.

Yes, providing a way to find out what happened is definitely a good
idea.

> 
> I will look into using trace points, but before I expend the effort
> to make such a change, what would be the advantage of trace points
> over s390dbf?

The question of what system to use is not a new one :)

I think it boils down to who will use it, and what other drivers you
want to correlate with. If it's zcrypt, s390dbf is the more obvious
choice; if vfio/mdev (which currently does not have real tracing), it
would be trace points. Doing both might be overkill... your call, as you
probably know better who the consumers are.

> 
> > 
> > Also, isn't this independent of the rest of the series?  
> 
> I guess that depends upon your definition of independent. Yes, this
> patch could be posted as an entity unto itself, but then the rest of
> the series would have to pre-req it given much of the logging is
> done in code that has been modified by the series. Is there a
> good reason to make this independent?

Tracing would be nice regardless of this series; but reworking it to
separate out this patch does not really make sense.

> 
> >   
> >>
> >> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> >> ---
> >>   drivers/s390/crypto/vfio_ap_drv.c     |  34 +++++++
> >>   drivers/s390/crypto/vfio_ap_ops.c     | 187 ++++++++++++++++++++++++++++++----
> >>   drivers/s390/crypto/vfio_ap_private.h |  20 ++++
> >>   3 files changed, 223 insertions(+), 18 deletions(-)
> >>
> >> diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
> >> index d8da520ae1fa..04a77246c22a 100644
> >> --- a/drivers/s390/crypto/vfio_ap_drv.c
> >> +++ b/drivers/s390/crypto/vfio_ap_drv.c
> >> @@ -22,6 +22,10 @@ MODULE_AUTHOR("IBM Corporation");
> >>   MODULE_DESCRIPTION("VFIO AP device driver, Copyright IBM Corp. 2018");
> >>   MODULE_LICENSE("GPL v2");
> >>   
> >> +uint dbglvl = 3;
> >> +module_param(dbglvl, uint, 0444);
> >> +MODULE_PARM_DESC(dbglvl, "VFIO_AP driver debug level.");  
> > 
> > More the default debug level, isn't it? (IIRC, you can change the level
> > of the s390dbfs dynamically.)  
> 
> The default debug level is 3. This allows the admin to change the debug
> level at boot time so as not to miss trace events that might occur prior
> to using the sysfs 'level' file to change the debug level.

What I meant is that the description should probably use the term
"default debug level".

> 
> For the record, I had a suggestion from Harald to change the name to
> vfio_dbglvl or something of that nature to avoid namespace collisions.
> 
> >   
> >> +
> >>   static struct ap_driver vfio_ap_drv;
> >>   
> >>   struct ap_matrix_dev *matrix_dev;
> >> @@ -158,6 +162,21 @@ static void vfio_ap_matrix_dev_destroy(void)
> >>   	root_device_unregister(root_device);
> >>   }
> >>   
> >> +static void vfio_ap_log_queues_in_use(struct ap_matrix_mdev *matrix_mdev,
> >> +				  unsigned long *apm, unsigned long *aqm)
> >> +{
> >> +	unsigned long apid, apqi;
> >> +
> >> +	for_each_set_bit_inv(apid, apm, AP_DEVICES) {
> >> +		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS) {
> >> +			VFIO_AP_DBF(matrix_dev, DBF_ERR,
> >> +				    "queue %02lx.%04lx in use by mdev %s\n",
> >> +				    apid, apqi,
> >> +				    dev_name(mdev_dev(matrix_mdev->mdev)));  
> > 
> > I remember some issues wrt %s in s390dbfs (lifetime); will this dbf
> > potentially outlive the mdev? Or is the string copied? (Or has s390dbf
> > been changed to avoid that trap? If so, please disregard my comments.)  
> 
> If I understand your question, then this should not be a problem. The
> lifespan of the mdev dbf files coincides with the lifespan of the mdev.
> The dbf for the matrix mdev is registered when the mdev is created
> and unregistered when the mdev is removed. Likewise, the vfio_ap dbf
> is created when the module is initialized and unregistered when the
> module is exited.

FTR, I was referring to the following from s390dbf.rst:

"IMPORTANT:                                                                      
  Using "%s" in sprintf event functions is dangerous. You can only              
  use "%s" in the sprintf event functions, if the memory for the passed string  
  is available as long as the debug feature exists. The reason behind this is   
  that due to performance considerations only a pointer to the string is stored 
  in  the debug feature. If you log a string that is freed afterwards, you will 
  get an OOPS when inspecting the debug feature, because then the debug feature 
  will access the already freed memory."

But it isn't a problem in this case.

(...)

> >> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> >> index 0e748819abb6..1aa18eba43d0 100644
> >> --- a/drivers/s390/crypto/vfio_ap_ops.c
> >> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> >> @@ -167,17 +167,23 @@ static struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
> >>   		case AP_RESPONSE_INVALID_ADDRESS:
> >>   		default:
> >>   			/* All cases in default means AP not operational */
> >> -			WARN_ONCE(1, "%s: ap_aqic status %d\n", __func__,
> >> -				  status.response_code);
> >>   			goto end_free;
> >>   		}
> >>   	} while (retries--);
> >>   
> >> -	WARN_ONCE(1, "%s: ap_aqic status %d\n", __func__,
> >> -		  status.response_code);
> >>   end_free:
> >>   	vfio_ap_free_aqic_resources(q);
> >>   	q->matrix_mdev = NULL;
> >> +	if (status.response_code) {  
> > 
> > If I read the code correctly, we consider AP_RESPONSE_OTHERWISE_CHANGED
> > a success as well, don't we? (Not sure what that means, though.)  
> 
> It indicates that IRQ enable/disable has already been set as requested,
> or a the async portion of a previous PQAP(AQIC) has not yet completed.
> This just a warning, not an error.

Ok.

> 
> >   
> >> +		VFIO_AP_MDEV_DBF(q->matrix_mdev, DBF_WARN,
> >> +			 "IRQ disable failed for queue %02x.%04x: status response code=%u\n",
> >> +			 AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
> >> +			 status.response_code);
> >> +	} else {
> >> +		VFIO_AP_MDEV_DBF(q->matrix_mdev, DBF_INFO,
> >> +				 "IRQ disabled for queue %02x.%04x\n",
> >> +				 AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn));
> >> +	}
> >>   	return status;
> >>   }
> >>     
> > 
> > (...)
> >   
> >> @@ -321,8 +340,29 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
> >>   	matrix->adm_max = info->apxa ? info->Nd : 15;
> >>   }
> >>   
> >> +static int vfio_ap_mdev_debug_init(struct ap_matrix_mdev *matrix_mdev)
> >> +{
> >> +	int ret;
> >> +
> >> +	matrix_mdev->dbf = debug_register(dev_name(mdev_dev(matrix_mdev->mdev)),
> >> +					  1, 1,
> >> +					  DBF_SPRINTF_MAX_ARGS * sizeof(long));
> >> +
> >> +	if (!matrix_mdev->dbf)
> >> +		return -ENOMEM;  
> > 
> > Ok, here we do check for the result of debug_register().  
> 
> Of course:)
> 
> >   
> >> +
> >> +	ret = debug_register_view(matrix_mdev->dbf, &debug_sprintf_view);
> >> +	if (ret)
> >> +		return ret;  
> > 
> > Don't we need to clean up ->dbf in the failure case?  
> 
> What's to clean up if it failed?

debug_register() has allocated some memory, don't we need to free it?

(...)

> >> @@ -350,14 +397,19 @@ static int vfio_ap_mdev_remove(struct mdev_device *mdev)
> >>   {
> >>   	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
> >>   
> >> -	if (matrix_mdev->kvm)
> >> +	if (matrix_mdev->kvm) {
> >> +		VFIO_AP_MDEV_DBF(matrix_mdev, DBF_ERR,
> >> +				 "remove rejected, mdev in use by %s",
> >> +				 matrix_mdev->kvm->debugfs_dentry->d_iname);  
> > 
> > Can this be a problem when the kvm goes away (and the d_iname is gone)?
> > 
> > Regardless of s390dbf implementation details, is d_iname even valid in
> > all cases (no debugfs)?  
> 
> I don't know the answer to that. Can you point me to a way to get the
> name of the guest?

I just checked, and this will break if debugfs is not configured.

Unfortunately, I don't have a good idea for an alternative way to
identify the owning machine :/

> 
> >   
> >>   		return -EBUSY;
> >> +	}
> >>   
> >>   	mutex_lock(&matrix_dev->lock);
> >>   	vfio_ap_mdev_reset_queues(mdev);
> >>   	list_del(&matrix_mdev->node);
> >>   	mutex_unlock(&matrix_dev->lock);
> >>   
> >> +	debug_unregister(matrix_mdev->dbf);
> >>   	kfree(matrix_mdev);
> >>   	mdev_set_drvdata(mdev, NULL);
> >>   	atomic_inc(&matrix_dev->available_instances);
> >> @@ -406,6 +458,22 @@ static struct attribute_group *vfio_ap_mdev_type_groups[] = {
> >>   	NULL,
> >>   };
> >>   
> >> +static void vfio_ap_mdev_log_sharing_error(struct ap_matrix_mdev *logdev,
> >> +					   const char *assigned_to,
> >> +					   unsigned long *apm,
> >> +					   unsigned long *aqm)
> >> +{
> >> +	unsigned long apid, apqi;
> >> +
> >> +	for_each_set_bit_inv(apid, apm, AP_DEVICES) {
> >> +		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS) {
> >> +			VFIO_AP_MDEV_DBF(logdev, DBF_ERR,
> >> +					 "queue %02lx.%04lx already assigned to %s\n",  
> > 
> > I'm also not 100% sure about string lifetimes here.  
> 
> I don't understand your concern here, can you elaborate?

See the excerpt from the documentation for s390dbf I cited above. Are
we sure that assigned_to will stay around at least as long as the debug
feature does?

> 
> >   
> >> +					 apid, apqi, assigned_to);
> >> +		}
> >> +	}
> >> +}
> >> +
> >>   /**
> >>    * vfio_ap_mdev_verify_no_sharing
> >>    *
> >> @@ -448,22 +516,39 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev,
> >>   		if (!bitmap_and(aqm, mdev_aqm, lstdev->matrix.aqm, AP_DOMAINS))
> >>   			continue;
> >>   
> >> +		vfio_ap_mdev_log_sharing_error(matrix_mdev,
> >> +					       dev_name(mdev_dev(lstdev->mdev)),
> >> +					       apm, aqm);
> >> +
> >>   		return -EADDRINUSE;
> >>   	}
> >>   
> >>   	return 0;
> >>   }
> >>   
> >> -static int vfio_ap_mdev_validate_masks(struct ap_matrix_mdev *matrix_mdev,
> >> +static int vfio_ap_mdev_validate_masks(struct ap_matrix_mdev *logdev,
> >>   				       unsigned long *apm, unsigned long *aqm)
> >>   {
> >> -	int ret;
> >> +	int ret = 0;
> >> +	unsigned long apid, apqi;
> >> +
> >> +	for_each_set_bit_inv(apid, apm, AP_DEVICES) {
> >> +		for_each_set_bit_inv(apqi, aqm, AP_DEVICES) {
> >> +			if (!ap_owned_by_def_drv(apid, apqi))
> >> +				continue;
> >> +
> >> +			VFIO_AP_MDEV_DBF(logdev, DBF_ERR,
> >> +					 "queue %02lx.%04lx owned by zcrypt\n",  
> > 
> > s/zcrypt/default driver/ ?  
> 
> I don't like default driver because IMHO default driver implies that if
> no driver passes the bus match - which matches based on device type -
> then it is bound to some default driver. How about:
> 
> s/zcrypt/default zcrypt driver/?

Yes, makes sense to me.

(...)

> >> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> >> index 5cc3c2ebf151..f717e43e10cf 100644
> >> --- a/drivers/s390/crypto/vfio_ap_private.h
> >> +++ b/drivers/s390/crypto/vfio_ap_private.h
> >> @@ -24,6 +24,21 @@
> >>   #define VFIO_AP_MODULE_NAME "vfio_ap"
> >>   #define VFIO_AP_DRV_NAME "vfio_ap"
> >>   
> >> +#define DBF_ERR		3	/* error conditions   */
> >> +#define DBF_WARN	4	/* warning conditions */
> >> +#define DBF_INFO	5	/* informational      */
> >> +#define DBF_DEBUG	6	/* for debugging only */  
> > 
> > Can you reuse the LOGLEVEL_* constants instead of rolling your own?  
> 
> I assume you are talking about the log levels in linux/kern_levels.h?
> Those levels range from -2 to 7. The dbf log levels range from 0 to 6.
> It looks like most other drivers that use dbf hard code the levels.
> I can do that if you prefer.

If the other users of the s390dbf use hard-coded values, it's probably
ok to do so here as well. (But that sounds like s390dbf should provide
some definitions for levels... in a separate series.)

> 
> >   
> >> +
> >> +#define DBF_SPRINTF_MAX_ARGS 5
> >> +
> >> +#define VFIO_AP_DBF(d_matrix_dev, ...) \
> >> +	debug_sprintf_event(d_matrix_dev->dbf, ##__VA_ARGS__)
> >> +
> >> +#define VFIO_AP_MDEV_DBF(d_matrix_mdev, ...) \
> >> +	debug_sprintf_event(d_matrix_mdev->dbf, ##__VA_ARGS__)
> >> +
> >> +extern uint dbglvl;
> >> +
> >>   /**
> >>    * ap_matrix_dev - the AP matrix device structure
> >>    * @device:	generic device structure associated with the AP matrix device
> >> @@ -43,6 +58,7 @@ struct ap_matrix_dev {
> >>   	struct list_head mdev_list;
> >>   	struct mutex lock;
> >>   	struct ap_driver  *vfio_ap_drv;
> >> +	debug_info_t *dbf;
> >>   };
> >>   
> >>   extern struct ap_matrix_dev *matrix_dev;
> >> @@ -77,6 +93,9 @@ struct ap_matrix {
> >>    * @group_notifier: notifier block used for specifying callback function for
> >>    *		    handling the VFIO_GROUP_NOTIFY_SET_KVM event
> >>    * @kvm:	the struct holding guest's state
> >> + * @pqap_hook:	handler for PQAP instruction
> >> + * @mdev:	the matrix mediated device  
> > 
> > Should updating the description for these two go into a trivial
> > separate patch?  
> 
> I will if you insist, but what is gained by that?

I had to look twice to see that those two fields have not been
introduced by this patch :)

If this series will make the next merge window anyway, no need to spend
effort to split this out, though.

> 
> >   
> >> + * @dbf:	the debug info log
> >>    */
> >>   struct ap_matrix_mdev {
> >>   	struct list_head node;
> >> @@ -86,6 +105,7 @@ struct ap_matrix_mdev {
> >>   	struct kvm *kvm;
> >>   	struct kvm_s390_module_hook pqap_hook;
> >>   	struct mdev_device *mdev;
> >> +	debug_info_t *dbf;
> >>   };
> >>   
> >>   extern int vfio_ap_mdev_register(void);  
> >   
> 

