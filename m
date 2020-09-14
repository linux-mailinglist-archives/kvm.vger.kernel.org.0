Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D52269020
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 17:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgINPcS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 11:32:18 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46932 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726020AbgINPcL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Sep 2020 11:32:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600097529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hYwIPUBVeru2C0Pit6Q9ISN4S7/HsDvY1EPeSpcccVM=;
        b=LQuQpX9f9EWiy3Ak6ldiEouM4QEucsMgFjX2FhtMadDtr9Ykjcfdv8pCHIFCX/VI0O7YZc
        PvkZGtVSzS2QAcKsPtIhbcQwEV9jxr+m32RzguoUrYVCttw7u0+o2o4uf/Wo+ceCTAsdlH
        Ja3YwoiQdVjynt1msgIq7/FJ4wsCOWs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-3FfxvtFdMpeMPgPdPi2dfQ-1; Mon, 14 Sep 2020 11:32:05 -0400
X-MC-Unique: 3FfxvtFdMpeMPgPdPi2dfQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D008E800C60;
        Mon, 14 Sep 2020 15:32:02 +0000 (UTC)
Received: from gondolin (ovpn-112-214.ams2.redhat.com [10.36.112.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D8ECD7A1FC;
        Mon, 14 Sep 2020 15:31:52 +0000 (UTC)
Date:   Mon, 14 Sep 2020 17:31:49 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v10 05/16] s390/vfio-ap: implement in-use callback for
 vfio_ap driver
Message-ID: <20200914173149.70fa59d9.cohuck@redhat.com>
In-Reply-To: <20200821195616.13554-6-akrowiak@linux.ibm.com>
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
        <20200821195616.13554-6-akrowiak@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Aug 2020 15:56:05 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> Let's implement the callback to indicate when an APQN
> is in use by the vfio_ap device driver. The callback is
> invoked whenever a change to the apmask or aqmask would
> result in one or more queue devices being removed from the driver. The
> vfio_ap device driver will indicate a resource is in use
> if the APQN of any of the queue devices to be removed are assigned to
> any of the matrix mdevs under the driver's control.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_drv.c     |  1 +
>  drivers/s390/crypto/vfio_ap_ops.c     | 68 ++++++++++++++++++++-------
>  drivers/s390/crypto/vfio_ap_private.h |  2 +
>  3 files changed, 53 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
> index 24cdef60039a..aae5b3d8e3fa 100644
> --- a/drivers/s390/crypto/vfio_ap_drv.c
> +++ b/drivers/s390/crypto/vfio_ap_drv.c
> @@ -175,6 +175,7 @@ static int __init vfio_ap_init(void)
>  	memset(&vfio_ap_drv, 0, sizeof(vfio_ap_drv));
>  	vfio_ap_drv.probe = vfio_ap_queue_dev_probe;
>  	vfio_ap_drv.remove = vfio_ap_queue_dev_remove;
> +	vfio_ap_drv.in_use = vfio_ap_mdev_resource_in_use;
>  	vfio_ap_drv.ids = ap_queue_ids;
>  
>  	ret = ap_driver_register(&vfio_ap_drv, THIS_MODULE, VFIO_AP_DRV_NAME);
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 2e37ee82e422..fc1aa6f947eb 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -515,18 +515,36 @@ vfio_ap_mdev_verify_queues_reserved_for_apid(struct ap_matrix_mdev *matrix_mdev,
>  	return 0;
>  }
>  
> +#define MDEV_SHARING_ERR "Userspace may not re-assign queue %02lx.%04lx " \
> +			 "already assigned to %s"

Ah, I spoke too soon; this is what I had been looking for :)

