Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B92B89B98
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2019 12:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbfHLKf2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Aug 2019 06:35:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47782 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727323AbfHLKf1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Aug 2019 06:35:27 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ECEA168829;
        Mon, 12 Aug 2019 10:35:26 +0000 (UTC)
Received: from gondolin (dhcp-192-181.str.redhat.com [10.33.192.181])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6DD5C19C4F;
        Mon, 12 Aug 2019 10:35:19 +0000 (UTC)
Date:   Mon, 12 Aug 2019 12:35:17 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, mjrosato@linux.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com
Subject: Re: [PATCH v5 6/7] s390: vfio-ap: add logging to vfio_ap driver
Message-ID: <20190812123517.059046b6.cohuck@redhat.com>
In-Reply-To: <1564612877-7598-7-git-send-email-akrowiak@linux.ibm.com>
References: <1564612877-7598-1-git-send-email-akrowiak@linux.ibm.com>
        <1564612877-7598-7-git-send-email-akrowiak@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Mon, 12 Aug 2019 10:35:27 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 31 Jul 2019 18:41:16 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> Added two DBF log files for logging events and errors; one for the vfio_ap
> driver, and one for each matrix mediated device.

While the s390dbf is useful (especially for accessing the information
in dumps), trace points are a more standard interface. Have you
evaluated that as well? (We probably should add something to the
vfio/mdev code as well; tracing there is a good complement to tracing
in vendor drivers.)

Also, isn't this independent of the rest of the series?

> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_drv.c     |  34 +++++++
>  drivers/s390/crypto/vfio_ap_ops.c     | 187 ++++++++++++++++++++++++++++++----
>  drivers/s390/crypto/vfio_ap_private.h |  20 ++++
>  3 files changed, 223 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
> index d8da520ae1fa..04a77246c22a 100644
> --- a/drivers/s390/crypto/vfio_ap_drv.c
> +++ b/drivers/s390/crypto/vfio_ap_drv.c
> @@ -22,6 +22,10 @@ MODULE_AUTHOR("IBM Corporation");
>  MODULE_DESCRIPTION("VFIO AP device driver, Copyright IBM Corp. 2018");
>  MODULE_LICENSE("GPL v2");
>  
> +uint dbglvl = 3;
> +module_param(dbglvl, uint, 0444);
> +MODULE_PARM_DESC(dbglvl, "VFIO_AP driver debug level.");

More the default debug level, isn't it? (IIRC, you can change the level
of the s390dbfs dynamically.)

> +
>  static struct ap_driver vfio_ap_drv;
>  
>  struct ap_matrix_dev *matrix_dev;
> @@ -158,6 +162,21 @@ static void vfio_ap_matrix_dev_destroy(void)
>  	root_device_unregister(root_device);
>  }
>  
> +static void vfio_ap_log_queues_in_use(struct ap_matrix_mdev *matrix_mdev,
> +				  unsigned long *apm, unsigned long *aqm)
> +{
> +	unsigned long apid, apqi;
> +
> +	for_each_set_bit_inv(apid, apm, AP_DEVICES) {
> +		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS) {
> +			VFIO_AP_DBF(matrix_dev, DBF_ERR,
> +				    "queue %02lx.%04lx in use by mdev %s\n",
> +				    apid, apqi,
> +				    dev_name(mdev_dev(matrix_mdev->mdev)));

I remember some issues wrt %s in s390dbfs (lifetime); will this dbf
potentially outlive the mdev? Or is the string copied? (Or has s390dbf
been changed to avoid that trap? If so, please disregard my comments.)

> +		}
> +	}
> +}
> +
>  static bool vfio_ap_resource_in_use(unsigned long *apm, unsigned long *aqm)
>  {
>  	bool in_use = false;
> @@ -179,6 +198,8 @@ static bool vfio_ap_resource_in_use(unsigned long *apm, unsigned long *aqm)
>  			continue;
>  
>  		in_use = true;
> +		vfio_ap_log_queues_in_use(matrix_mdev, apm_intrsctn,
> +					  aqm_intrsctn);
>  	}
>  
>  	mutex_unlock(&matrix_dev->lock);
> @@ -186,6 +207,16 @@ static bool vfio_ap_resource_in_use(unsigned long *apm, unsigned long *aqm)
>  	return in_use;
>  }
>  
> +static int __init vfio_ap_debug_init(void)
> +{
> +	matrix_dev->dbf = debug_register(VFIO_AP_DRV_NAME, 1, 1,
> +					 DBF_SPRINTF_MAX_ARGS * sizeof(long));

It seems that debug_register() can possibly fail? (Unlikely, but we
should check.)

> +	debug_register_view(matrix_dev->dbf, &debug_sprintf_view);
> +	debug_set_level(matrix_dev->dbf, dbglvl);
> +
> +	return 0;
> +}
> +
>  static int __init vfio_ap_init(void)
>  {
>  	int ret;
> @@ -219,6 +250,8 @@ static int __init vfio_ap_init(void)
>  		return ret;
>  	}
>  
> +	vfio_ap_debug_init();
> +
>  	return 0;
>  }
>  
> @@ -227,6 +260,7 @@ static void __exit vfio_ap_exit(void)
>  	vfio_ap_mdev_unregister();
>  	ap_driver_unregister(&vfio_ap_drv);
>  	vfio_ap_matrix_dev_destroy();
> +	debug_unregister(matrix_dev->dbf);
>  }
>  
>  module_init(vfio_ap_init);
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 0e748819abb6..1aa18eba43d0 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -167,17 +167,23 @@ static struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
>  		case AP_RESPONSE_INVALID_ADDRESS:
>  		default:
>  			/* All cases in default means AP not operational */
> -			WARN_ONCE(1, "%s: ap_aqic status %d\n", __func__,
> -				  status.response_code);
>  			goto end_free;
>  		}
>  	} while (retries--);
>  
> -	WARN_ONCE(1, "%s: ap_aqic status %d\n", __func__,
> -		  status.response_code);
>  end_free:
>  	vfio_ap_free_aqic_resources(q);
>  	q->matrix_mdev = NULL;
> +	if (status.response_code) {

If I read the code correctly, we consider AP_RESPONSE_OTHERWISE_CHANGED
a success as well, don't we? (Not sure what that means, though.)

> +		VFIO_AP_MDEV_DBF(q->matrix_mdev, DBF_WARN,
> +			 "IRQ disable failed for queue %02x.%04x: status response code=%u\n",
> +			 AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
> +			 status.response_code);
> +	} else {
> +		VFIO_AP_MDEV_DBF(q->matrix_mdev, DBF_INFO,
> +				 "IRQ disabled for queue %02x.%04x\n",
> +				 AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn));
> +	}
>  	return status;
>  }
>  

(...)

> @@ -321,8 +340,29 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
>  	matrix->adm_max = info->apxa ? info->Nd : 15;
>  }
>  
> +static int vfio_ap_mdev_debug_init(struct ap_matrix_mdev *matrix_mdev)
> +{
> +	int ret;
> +
> +	matrix_mdev->dbf = debug_register(dev_name(mdev_dev(matrix_mdev->mdev)),
> +					  1, 1,
> +					  DBF_SPRINTF_MAX_ARGS * sizeof(long));
> +
> +	if (!matrix_mdev->dbf)
> +		return -ENOMEM;

Ok, here we do check for the result of debug_register().

> +
> +	ret = debug_register_view(matrix_mdev->dbf, &debug_sprintf_view);
> +	if (ret)
> +		return ret;

Don't we need to clean up ->dbf in the failure case?

Also, we probably need to check this as well for the other dbf.

> +
> +	debug_set_level(matrix_mdev->dbf, dbglvl);
> +
> +	return 0;
> +}
> +
>  static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
>  {
> +	int ret;
>  	struct ap_matrix_mdev *matrix_mdev;
>  
>  	if ((atomic_dec_if_positive(&matrix_dev->available_instances) < 0))
> @@ -335,6 +375,13 @@ static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
>  	}
>  
>  	matrix_mdev->mdev = mdev;
> +
> +	ret = vfio_ap_mdev_debug_init(matrix_mdev);
> +	if (ret) {
> +		kfree(matrix_mdev);
> +		return ret;

You also should bump available_instances again in the failure case.

> +	}
> +
>  	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
>  	mdev_set_drvdata(mdev, matrix_mdev);
>  	matrix_mdev->pqap_hook.hook = handle_pqap;
> @@ -350,14 +397,19 @@ static int vfio_ap_mdev_remove(struct mdev_device *mdev)
>  {
>  	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>  
> -	if (matrix_mdev->kvm)
> +	if (matrix_mdev->kvm) {
> +		VFIO_AP_MDEV_DBF(matrix_mdev, DBF_ERR,
> +				 "remove rejected, mdev in use by %s",
> +				 matrix_mdev->kvm->debugfs_dentry->d_iname);

Can this be a problem when the kvm goes away (and the d_iname is gone)?

Regardless of s390dbf implementation details, is d_iname even valid in
all cases (no debugfs)?

>  		return -EBUSY;
> +	}
>  
>  	mutex_lock(&matrix_dev->lock);
>  	vfio_ap_mdev_reset_queues(mdev);
>  	list_del(&matrix_mdev->node);
>  	mutex_unlock(&matrix_dev->lock);
>  
> +	debug_unregister(matrix_mdev->dbf);
>  	kfree(matrix_mdev);
>  	mdev_set_drvdata(mdev, NULL);
>  	atomic_inc(&matrix_dev->available_instances);
> @@ -406,6 +458,22 @@ static struct attribute_group *vfio_ap_mdev_type_groups[] = {
>  	NULL,
>  };
>  
> +static void vfio_ap_mdev_log_sharing_error(struct ap_matrix_mdev *logdev,
> +					   const char *assigned_to,
> +					   unsigned long *apm,
> +					   unsigned long *aqm)
> +{
> +	unsigned long apid, apqi;
> +
> +	for_each_set_bit_inv(apid, apm, AP_DEVICES) {
> +		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS) {
> +			VFIO_AP_MDEV_DBF(logdev, DBF_ERR,
> +					 "queue %02lx.%04lx already assigned to %s\n",

I'm also not 100% sure about string lifetimes here.

> +					 apid, apqi, assigned_to);
> +		}
> +	}
> +}
> +
>  /**
>   * vfio_ap_mdev_verify_no_sharing
>   *
> @@ -448,22 +516,39 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev,
>  		if (!bitmap_and(aqm, mdev_aqm, lstdev->matrix.aqm, AP_DOMAINS))
>  			continue;
>  
> +		vfio_ap_mdev_log_sharing_error(matrix_mdev,
> +					       dev_name(mdev_dev(lstdev->mdev)),
> +					       apm, aqm);
> +
>  		return -EADDRINUSE;
>  	}
>  
>  	return 0;
>  }
>  
> -static int vfio_ap_mdev_validate_masks(struct ap_matrix_mdev *matrix_mdev,
> +static int vfio_ap_mdev_validate_masks(struct ap_matrix_mdev *logdev,
>  				       unsigned long *apm, unsigned long *aqm)
>  {
> -	int ret;
> +	int ret = 0;
> +	unsigned long apid, apqi;
> +
> +	for_each_set_bit_inv(apid, apm, AP_DEVICES) {
> +		for_each_set_bit_inv(apqi, aqm, AP_DEVICES) {
> +			if (!ap_owned_by_def_drv(apid, apqi))
> +				continue;
> +
> +			VFIO_AP_MDEV_DBF(logdev, DBF_ERR,
> +					 "queue %02lx.%04lx owned by zcrypt\n",

s/zcrypt/default driver/ ?

> +					 apid, apqi);
> +
> +			ret = -EADDRNOTAVAIL;
> +		}
> +	}
>  
> -	ret = ap_apqn_in_matrix_owned_by_def_drv(apm, aqm);
>  	if (ret)
> -		return (ret == 1) ? -EADDRNOTAVAIL : ret;
> +		return ret;
>  
> -	return vfio_ap_mdev_verify_no_sharing(matrix_mdev, apm, aqm);
> +	return vfio_ap_mdev_verify_no_sharing(logdev, apm, aqm);
>  }
>  
>  static void vfio_ap_mdev_update_crycb(struct ap_matrix_mdev *matrix_mdev)

(...)

> @@ -1013,9 +1132,10 @@ static void vfio_ap_mdev_wait_for_qempty(ap_qid_t qid)
>  			msleep(20);
>  			break;
>  		default:
> -			pr_warn("%s: tapq response %02x waiting for queue %04x.%02x empty\n",
> -				__func__, status.response_code,
> -				AP_QID_CARD(qid), AP_QID_QUEUE(qid));
> +			WARN_ONCE(1,
> +				  "%s: tapq response %02x waiting for queue %04x.%02x empty\n",
> +				  __func__, status.response_code,
> +				  AP_QID_CARD(qid), AP_QID_QUEUE(qid));

Why this change?

>  			return;
>  		}
>  	} while (--retry);

(...)

> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> index 5cc3c2ebf151..f717e43e10cf 100644
> --- a/drivers/s390/crypto/vfio_ap_private.h
> +++ b/drivers/s390/crypto/vfio_ap_private.h
> @@ -24,6 +24,21 @@
>  #define VFIO_AP_MODULE_NAME "vfio_ap"
>  #define VFIO_AP_DRV_NAME "vfio_ap"
>  
> +#define DBF_ERR		3	/* error conditions   */
> +#define DBF_WARN	4	/* warning conditions */
> +#define DBF_INFO	5	/* informational      */
> +#define DBF_DEBUG	6	/* for debugging only */

Can you reuse the LOGLEVEL_* constants instead of rolling your own?

> +
> +#define DBF_SPRINTF_MAX_ARGS 5
> +
> +#define VFIO_AP_DBF(d_matrix_dev, ...) \
> +	debug_sprintf_event(d_matrix_dev->dbf, ##__VA_ARGS__)
> +
> +#define VFIO_AP_MDEV_DBF(d_matrix_mdev, ...) \
> +	debug_sprintf_event(d_matrix_mdev->dbf, ##__VA_ARGS__)
> +
> +extern uint dbglvl;
> +
>  /**
>   * ap_matrix_dev - the AP matrix device structure
>   * @device:	generic device structure associated with the AP matrix device
> @@ -43,6 +58,7 @@ struct ap_matrix_dev {
>  	struct list_head mdev_list;
>  	struct mutex lock;
>  	struct ap_driver  *vfio_ap_drv;
> +	debug_info_t *dbf;
>  };
>  
>  extern struct ap_matrix_dev *matrix_dev;
> @@ -77,6 +93,9 @@ struct ap_matrix {
>   * @group_notifier: notifier block used for specifying callback function for
>   *		    handling the VFIO_GROUP_NOTIFY_SET_KVM event
>   * @kvm:	the struct holding guest's state
> + * @pqap_hook:	handler for PQAP instruction
> + * @mdev:	the matrix mediated device

Should updating the description for these two go into a trivial
separate patch?

> + * @dbf:	the debug info log
>   */
>  struct ap_matrix_mdev {
>  	struct list_head node;
> @@ -86,6 +105,7 @@ struct ap_matrix_mdev {
>  	struct kvm *kvm;
>  	struct kvm_s390_module_hook pqap_hook;
>  	struct mdev_device *mdev;
> +	debug_info_t *dbf;
>  };
>  
>  extern int vfio_ap_mdev_register(void);

