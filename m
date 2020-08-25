Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D4F25169B
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 12:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729710AbgHYKZ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Aug 2020 06:25:26 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:41939 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729746AbgHYKZU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Aug 2020 06:25:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598351118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TQO2UOBn1MOgRwNvmVPJopGiZ9cQGSGDLytuuuQO4uY=;
        b=aUyypsbIhKih0uTusA7/7Ws72wgFbHriGf7Ibweun7P94d1D/6qvQzC/iJtQRTiL3XHxap
        IgoOdgTR8wgXN/aBG4gFHqKB0VXNfE+bUan7IBZqbMWsI0eX5GAa4ah+ETpOnHjbcLLsdB
        hTV/rLMlObmMXpEcs3VYRYfOO4BlBJk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-jCTQBosbMsSI6ipAkSitDQ-1; Tue, 25 Aug 2020 06:25:14 -0400
X-MC-Unique: jCTQBosbMsSI6ipAkSitDQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 02B8381F01D;
        Tue, 25 Aug 2020 10:25:13 +0000 (UTC)
Received: from gondolin (ovpn-112-248.ams2.redhat.com [10.36.112.248])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD36419144;
        Tue, 25 Aug 2020 10:25:03 +0000 (UTC)
Date:   Tue, 25 Aug 2020 12:25:01 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v10 03/16] s390/vfio-ap: manage link between queue
 struct and matrix mdev
Message-ID: <20200825122501.624474df.cohuck@redhat.com>
In-Reply-To: <20200821195616.13554-4-akrowiak@linux.ibm.com>
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
        <20200821195616.13554-4-akrowiak@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Aug 2020 15:56:03 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> Let's create links between each queue device bound to the vfio_ap device
> driver and the matrix mdev to which the queue is assigned. The idea is to
> facilitate efficient retrieval of the objects representing the queue
> devices and matrix mdevs as well as to verify that a queue assigned to
> a matrix mdev is bound to the driver.
> 
> The links will be created as follows:
> 
>    * When the queue device is probed, if its APQN is assigned to a matrix
>      mdev, the structures representing the queue device and the matrix mdev
>      will be linked.
> 
>    * When an adapter or domain is assigned to a matrix mdev, for each new
>      APQN assigned that references a queue device bound to the vfio_ap
>      device driver, the structures representing the queue device and the
>      matrix mdev will be linked.
> 
> The links will be removed as follows:
> 
>    * When the queue device is removed, if its APQN is assigned to a matrix
>      mdev, the structures representing the queue device and the matrix mdev
>      will be unlinked.
> 
>    * When an adapter or domain is unassigned from a matrix mdev, for each
>      APQN unassigned that references a queue device bound to the vfio_ap
>      device driver, the structures representing the queue device and the
>      matrix mdev will be unlinked.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c     | 132 +++++++++++++++++++++++++-
>  drivers/s390/crypto/vfio_ap_private.h |   2 +
>  2 files changed, 129 insertions(+), 5 deletions(-)
> 

(...)

> @@ -548,6 +557,87 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
>  	return 0;
>  }
>  
> +enum qlink_type {

<bikeshed>I think this is less of a type, and more of an action, so
maybe call this 'qlink_action' (and the function parameter below
'action'?)</bikeshed>

> +	LINK_APID,
> +	LINK_APQI,
> +	UNLINK_APID,
> +	UNLINK_APQI,
> +};
> +
> +static void vfio_ap_mdev_link_queue(struct ap_matrix_mdev *matrix_mdev,
> +				    unsigned long apid, unsigned long apqi)
> +{
> +	struct vfio_ap_queue *q;
> +
> +	q = vfio_ap_get_queue(AP_MKQID(apid, apqi));
> +	if (q) {
> +		q->matrix_mdev = matrix_mdev;
> +		hash_add(matrix_mdev->qtable,
> +			 &q->mdev_qnode, q->apqn);
> +	}
> +}
> +
> +static void vfio_ap_mdev_unlink_queue(unsigned long apid, unsigned long apqi)
> +{
> +	struct vfio_ap_queue *q;
> +
> +	q = vfio_ap_get_queue(AP_MKQID(apid, apqi));
> +	if (q) {
> +		q->matrix_mdev = NULL;
> +		hash_del(&q->mdev_qnode);
> +	}
> +}
> +
> +/**
> + * vfio_ap_mdev_link_queues
> + *
> + * @matrix_mdev: The matrix mdev to link.
> + * @type:	 The type of @qlink_id.
> + * @qlink_id:	 The APID or APQI of the queues to link.
> + *
> + * Sets or clears the links between the queues with the specified @qlink_id
> + * and the @matrix_mdev:
> + *     @type == LINK_APID: Set the links between the @matrix_mdev and the
> + *                         queues with the specified @qlink_id (APID)
> + *     @type == LINK_APQI: Set the links between the @matrix_mdev and the
> + *                         queues with the specified @qlink_id (APQI)
> + *     @type == UNLINK_APID: Clear the links between the @matrix_mdev and the
> + *                           queues with the specified @qlink_id (APID)
> + *     @type == UNLINK_APQI: Clear the links between the @matrix_mdev and the
> + *                           queues with the specified @qlink_id (APQI)
> + */
> +static void vfio_ap_mdev_link_queues(struct ap_matrix_mdev *matrix_mdev,
> +				     enum qlink_type type,
> +				     unsigned long qlink_id)
> +{
> +	unsigned long id;
> +
> +	switch (type) {
> +	case LINK_APID:
> +		for_each_set_bit_inv(id, matrix_mdev->matrix.aqm,
> +				     matrix_mdev->matrix.aqm_max + 1)
> +			vfio_ap_mdev_link_queue(matrix_mdev, qlink_id, id);
> +		break;
> +	case UNLINK_APID:
> +		for_each_set_bit_inv(id, matrix_mdev->matrix.aqm,
> +				     matrix_mdev->matrix.aqm_max + 1)
> +			vfio_ap_mdev_unlink_queue(qlink_id, id);
> +		break;
> +	case LINK_APQI:
> +		for_each_set_bit_inv(id, matrix_mdev->matrix.apm,
> +				     matrix_mdev->matrix.apm_max + 1)
> +			vfio_ap_mdev_link_queue(matrix_mdev, id, qlink_id);
> +		break;
> +	case UNLINK_APQI:
> +		for_each_set_bit_inv(id, matrix_mdev->matrix.apm,
> +				     matrix_mdev->matrix.apm_max + 1)
> +			vfio_ap_mdev_link_queue(matrix_mdev, id, qlink_id);
> +		break;
> +	default:
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +

(...)

I have not reviewed this deeply, but at a glance, it seems fine.

