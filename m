Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5AD1A3691
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 17:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgDIPGP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 11:06:15 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52371 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727327AbgDIPGP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Apr 2020 11:06:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586444774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W2Ev3/S1C/3a4puTtGn9OVdridbzmbjLhCuT5UsL+Ig=;
        b=CKdJb1t3LnnRPHDNTRBk4phS9C8GhmG9itnBMho8bIpggRYrevydxBG44mm9GtBnpA2m9Q
        p3RQnW9xiEBsnDDUsY9QC92WDjxMkZqdq6I2N+e4HHPMmc7I98JeibZt/RuHRh3K5XweQ8
        VYc994utB+QIhZBW0gwbheJyJwFjlNo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-VSi-y48XO9igghdtVzCRuw-1; Thu, 09 Apr 2020 11:06:12 -0400
X-MC-Unique: VSi-y48XO9igghdtVzCRuw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 490928017F5;
        Thu,  9 Apr 2020 15:06:10 +0000 (UTC)
Received: from gondolin (ovpn-112-54.ams2.redhat.com [10.36.112.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0246C19757;
        Thu,  9 Apr 2020 15:06:04 +0000 (UTC)
Date:   Thu, 9 Apr 2020 17:06:02 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com
Subject: Re: [PATCH v7 02/15] s390/vfio-ap: manage link between queue struct
 and matrix mdev
Message-ID: <20200409170602.4440be0f.cohuck@redhat.com>
In-Reply-To: <20200407192015.19887-3-akrowiak@linux.ibm.com>
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
        <20200407192015.19887-3-akrowiak@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Apr 2020 15:20:02 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> A vfio_ap_queue structure is created for each queue device probed. To
> ensure that the matrix mdev to which a queue's APQN is assigned is linked
> to the queue structure as long as the queue device is bound to the vfio_ap
> device driver, let's go ahead and manage these links when the queue device
> is probed and removed as well as whenever an adapter or domain is assigned
> to or unassigned from the matrix mdev.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 75 ++++++++++++++++++++++++++++---
>  1 file changed, 70 insertions(+), 5 deletions(-)

(...)

> @@ -536,6 +531,31 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
>  	return 0;
>  }
>  
> +/**
> + * vfio_ap_mdev_qlinks_for_apid

Hm... maybe the function name should express that there's some actual
(un)linking going on?

vfio_ap_mdev_link_by_apid?

Or make this vfio_ap_mdev_link_queues() and pass in an indicator whether
the passed value is an apid or an aqid? Both function names look so
very similar to be easily confused (at least to me).

> + *
> + * @matrix_mdev: a matrix mediated device
> + * @apqi:	 the APID of one or more APQNs assigned to @matrix_mdev
> + *
> + * Set the link to @matrix_mdev for each queue device bound to the vfio_ap
> + * device driver with an APQN assigned to @matrix_mdev with the specified @apid.
> + *
> + * Note: If @matrix_mdev is NULL, the link to @matrix_mdev will be severed.
> + */
> +static void vfio_ap_mdev_qlinks_for_apid(struct ap_matrix_mdev *matrix_mdev,
> +					 unsigned long apid)
> +{
> +	unsigned long apqi;
> +	struct vfio_ap_queue *q;
> +
> +	for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm,
> +			     matrix_mdev->matrix.aqm_max + 1) {
> +		q = vfio_ap_get_queue(AP_MKQID(apid, apqi));
> +		if (q)
> +			q->matrix_mdev = matrix_mdev;
> +	}
> +}
> +
>  /**
>   * assign_adapter_store
>   *

(...)

> @@ -682,6 +704,31 @@ vfio_ap_mdev_verify_queues_reserved_for_apqi(struct ap_matrix_mdev *matrix_mdev,
>  	return 0;
>  }
>  
> +/**
> + * vfio_ap_mdev_qlinks_for_apqi

See my comment above.

> + *
> + * @matrix_mdev: a matrix mediated device
> + * @apqi:	 the APQI of one or more APQNs assigned to @matrix_mdev
> + *
> + * Set the link to @matrix_mdev for each queue device bound to the vfio_ap
> + * device driver with an APQN assigned to @matrix_mdev with the specified @apqi.
> + *
> + * Note: If @matrix_mdev is NULL, the link to @matrix_mdev will be severed.
> + */
> +static void vfio_ap_mdev_qlinks_for_apqi(struct ap_matrix_mdev *matrix_mdev,
> +					 unsigned long apqi)
> +{
> +	unsigned long apid;
> +	struct vfio_ap_queue *q;
> +
> +	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm,
> +			     matrix_mdev->matrix.apm_max + 1) {
> +		q = vfio_ap_get_queue(AP_MKQID(apid, apqi));
> +		if (q)
> +			q->matrix_mdev = matrix_mdev;
> +	}
> +}
> +
>  /**
>   * assign_domain_store
>   *

(...)

> @@ -1270,6 +1319,21 @@ void vfio_ap_mdev_unregister(void)
>  	mdev_unregister_device(&matrix_dev->device);
>  }
>  
> +static void vfio_ap_mdev_for_queue(struct vfio_ap_queue *q)

vfio_ap_queue_link_mdev()? It is the other direction from the linking
above.

> +{
> +	unsigned long apid = AP_QID_CARD(q->apqn);
> +	unsigned long apqi = AP_QID_QUEUE(q->apqn);
> +	struct ap_matrix_mdev *matrix_mdev;
> +
> +	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
> +		if (test_bit_inv(apid, matrix_mdev->matrix.apm) &&
> +		    test_bit_inv(apqi, matrix_mdev->matrix.aqm)) {
> +			q->matrix_mdev = matrix_mdev;
> +			break;
> +		}
> +	}
> +}
> +
>  int vfio_ap_mdev_probe_queue(struct ap_queue *queue)
>  {
>  	struct vfio_ap_queue *q;
> @@ -1282,6 +1346,7 @@ int vfio_ap_mdev_probe_queue(struct ap_queue *queue)
>  	dev_set_drvdata(&queue->ap_dev.device, q);
>  	q->apqn = queue->qid;
>  	q->saved_isc = VFIO_AP_ISC_INVALID;
> +	vfio_ap_mdev_for_queue(q);
>  	hash_add(matrix_dev->qtable, &q->qnode, q->apqn);
>  	mutex_unlock(&matrix_dev->lock);
>  

In general, looks sane.

