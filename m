Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCC44A65F
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 18:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729849AbfFRQPM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 12:15:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36040 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729835AbfFRQPM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 12:15:12 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EAF6F30C1AE7;
        Tue, 18 Jun 2019 16:15:11 +0000 (UTC)
Received: from gondolin (dhcp-192-192.str.redhat.com [10.33.192.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 13E425C225;
        Tue, 18 Jun 2019 16:14:58 +0000 (UTC)
Date:   Tue, 18 Jun 2019 18:14:56 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, mjrosato@linux.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com
Subject: Re: [PATCH v4 1/7] s390: vfio-ap: Refactor vfio_ap driver probe and
 remove callbacks
Message-ID: <20190618181456.0252227b.cohuck@redhat.com>
In-Reply-To: <1560454780-20359-2-git-send-email-akrowiak@linux.ibm.com>
References: <1560454780-20359-1-git-send-email-akrowiak@linux.ibm.com>
        <1560454780-20359-2-git-send-email-akrowiak@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Tue, 18 Jun 2019 16:15:12 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 13 Jun 2019 15:39:34 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> In order to limit the number of private mdev functions called from the
> vfio_ap device driver as well as to provide a landing spot for dynamic
> configuration code related to binding/unbinding AP queue devices to/from
> the vfio_ap driver, the following changes are being introduced:
> 
> * Move code from the vfio_ap driver's probe callback into a function
>   defined in the mdev private operations file.
> 
> * Move code from the vfio_ap driver's remove callback into a function
>   defined in the mdev private operations file.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_drv.c     | 27 ++++++++++-----------------
>  drivers/s390/crypto/vfio_ap_ops.c     | 28 ++++++++++++++++++++++++++++
>  drivers/s390/crypto/vfio_ap_private.h |  6 +++---
>  3 files changed, 41 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
> index 003662aa8060..3c60df70891b 100644
> --- a/drivers/s390/crypto/vfio_ap_drv.c
> +++ b/drivers/s390/crypto/vfio_ap_drv.c
> @@ -49,15 +49,15 @@ MODULE_DEVICE_TABLE(vfio_ap, ap_queue_ids);
>   */
>  static int vfio_ap_queue_dev_probe(struct ap_device *apdev)
>  {
> -	struct vfio_ap_queue *q;
> -
> -	q = kzalloc(sizeof(*q), GFP_KERNEL);
> -	if (!q)
> -		return -ENOMEM;
> -	dev_set_drvdata(&apdev->device, q);
> -	q->apqn = to_ap_queue(&apdev->device)->qid;
> -	q->saved_isc = VFIO_AP_ISC_INVALID;
> +	int ret;
> +	struct ap_queue *queue = to_ap_queue(&apdev->device);
> +
> +	ret = vfio_ap_mdev_probe_queue(queue);
> +	if (ret)
> +		return ret;
> +
>  	return 0;
> +

Maybe you could even condense this into a simple

return vfio_ap_mdev_probe_queue(to_ap_queue(&apdev->device));

(Unless you plan to do more things with queue in a future patch, of
course.)

>  }
>  
>  /**

(...)

> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> index f46dde56b464..5cc3c2ebf151 100644
> --- a/drivers/s390/crypto/vfio_ap_private.h
> +++ b/drivers/s390/crypto/vfio_ap_private.h
> @@ -90,8 +90,6 @@ struct ap_matrix_mdev {
>  
>  extern int vfio_ap_mdev_register(void);
>  extern void vfio_ap_mdev_unregister(void);
> -int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
> -			     unsigned int retry);

If you don't need that function across files anymore, you probably want
to make it static.

>  
>  struct vfio_ap_queue {
>  	struct ap_matrix_mdev *matrix_mdev;
> @@ -100,5 +98,7 @@ struct vfio_ap_queue {
>  #define VFIO_AP_ISC_INVALID 0xff
>  	unsigned char saved_isc;
>  };
> -struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q);

Same here.

> +int vfio_ap_mdev_probe_queue(struct ap_queue *queue);
> +void vfio_ap_mdev_remove_queue(struct ap_queue *queue);
> +
>  #endif /* _VFIO_AP_PRIVATE_H_ */

