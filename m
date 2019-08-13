Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC2E8B6D4
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 13:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbfHMLaM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 07:30:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60400 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726650AbfHMLaM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 07:30:12 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 17BC98535C;
        Tue, 13 Aug 2019 11:30:12 +0000 (UTC)
Received: from gondolin (dhcp-192-232.str.redhat.com [10.33.192.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 82C315799C;
        Tue, 13 Aug 2019 11:29:59 +0000 (UTC)
Date:   Tue, 13 Aug 2019 13:29:57 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, mjrosato@linux.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com
Subject: Re: [PATCH] s390: vfio-ap: remove unnecessary calls to disable
 queue interrupts
Message-ID: <20190813132957.7fafad2d.cohuck@redhat.com>
In-Reply-To: <1565642829-20157-1-git-send-email-akrowiak@linux.ibm.com>
References: <1565642829-20157-1-git-send-email-akrowiak@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 13 Aug 2019 11:30:12 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 12 Aug 2019 16:47:09 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> When an AP queue is reset (zeroized), interrupts are disabled. The queue
> reset function currently tries to disable interrupts unnecessarily. This patch
> removes the unnecessary calls to disable interrupts after queue reset.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 0604b49a4d32..407c2f0f25f9 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1114,18 +1114,19 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>  	return NOTIFY_OK;
>  }
>  
> -static void vfio_ap_irq_disable_apqn(int apqn)
> +static struct vfio_ap_queue *vfio_ap_find_qdev(int apqn)
>  {
>  	struct device *dev;
> -	struct vfio_ap_queue *q;
> +	struct vfio_ap_queue *q = NULL;
>  
>  	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
>  				 &apqn, match_apqn);
>  	if (dev) {
>  		q = dev_get_drvdata(dev);
> -		vfio_ap_irq_disable(q);
>  		put_device(dev);
>  	}
> +
> +	return q;
>  }
>  
>  int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
> @@ -1164,6 +1165,7 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
>  	int rc = 0;
>  	unsigned long apid, apqi;
>  	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
> +	struct vfio_ap_queue *q;
>  
>  	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm,
>  			     matrix_mdev->matrix.apm_max + 1) {
> @@ -1177,7 +1179,10 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
>  			 */
>  			if (ret)
>  				rc = ret;
> -			vfio_ap_irq_disable_apqn(AP_MKQID(apid, apqi));

Might be useful to stick a comment in this function that resetting the
queue has also disabled the interrupts, as the architecture
documentation for that is not publicly available.

> +
> +			q = vfio_ap_find_qdev(AP_MKQID(apid, apqi));
> +			if (q)
> +				vfio_ap_free_aqic_resources(q);
>  		}
>  	}
>  

Trusting your reading of the architecture,
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
