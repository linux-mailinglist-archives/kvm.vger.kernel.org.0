Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE60F32F2E
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 14:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbfFCMHB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 08:07:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54392 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbfFCMHB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 08:07:01 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9C5FDC058CBA;
        Mon,  3 Jun 2019 12:07:00 +0000 (UTC)
Received: from gondolin (ovpn-204-96.brq.redhat.com [10.40.204.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A42761991;
        Mon,  3 Jun 2019 12:06:52 +0000 (UTC)
Date:   Mon, 3 Jun 2019 14:06:49 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Michael Mueller <mimu@linux.ibm.com>
Cc:     KVM Mailing List <kvm@vger.kernel.org>,
        Linux-S390 Mailing List <linux-s390@vger.kernel.org>,
        Sebastian Ott <sebott@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Subject: Re: [PATCH v3 3/8] s390/cio: add basic protected virtualization
 support
Message-ID: <20190603140649.7d5ebc3e.cohuck@redhat.com>
In-Reply-To: <20190529122657.166148-4-mimu@linux.ibm.com>
References: <20190529122657.166148-1-mimu@linux.ibm.com>
        <20190529122657.166148-4-mimu@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Mon, 03 Jun 2019 12:07:00 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 29 May 2019 14:26:52 +0200
Michael Mueller <mimu@linux.ibm.com> wrote:

> From: Halil Pasic <pasic@linux.ibm.com>
> 
> As virtio-ccw devices are channel devices, we need to use the dma area
> for any communication with the hypervisor.

"we need to use the dma area within the common I/O layer for any
communication with the hypervisor. Note that we do not need to use that
area for control blocks directly referenced by instructions, e.g. the
orb."

...although I'm still not particularly confident about the actual
distinction here? I'm trusting you that you actually have tested it,
though :)

> 
> It handles neither QDIO in the common code, nor any device type specific
> stuff (like channel programs constructed by the DASD driver).
> 
> An interesting side effect is that virtio structures are now going to
> get allocated in 31 bit addressable storage.
> 
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> Reviewed-by: Sebastian Ott <sebott@linux.ibm.com>
> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
> ---
>  arch/s390/include/asm/ccwdev.h   |  4 +++
>  drivers/s390/cio/ccwreq.c        |  9 +++---
>  drivers/s390/cio/device.c        | 67 +++++++++++++++++++++++++++++++++-------
>  drivers/s390/cio/device_fsm.c    | 49 +++++++++++++++++------------
>  drivers/s390/cio/device_id.c     | 20 ++++++------
>  drivers/s390/cio/device_ops.c    | 21 +++++++++++--
>  drivers/s390/cio/device_pgid.c   | 22 +++++++------
>  drivers/s390/cio/device_status.c | 24 +++++++-------
>  drivers/s390/cio/io_sch.h        | 20 +++++++++---
>  drivers/s390/virtio/virtio_ccw.c | 10 ------
>  10 files changed, 163 insertions(+), 83 deletions(-)

(...)

> @@ -1593,20 +1625,31 @@ struct ccw_device * __init ccw_device_create_console(struct ccw_driver *drv)
>  		return ERR_CAST(sch);
>  
>  	io_priv = kzalloc(sizeof(*io_priv), GFP_KERNEL | GFP_DMA);
> -	if (!io_priv) {
> -		put_device(&sch->dev);
> -		return ERR_PTR(-ENOMEM);
> -	}
> +	if (!io_priv)
> +		goto err_priv;
> +	io_priv->dma_area = dma_alloc_coherent(&sch->dev,
> +				sizeof(*io_priv->dma_area),
> +				&io_priv->dma_area_dma, GFP_KERNEL);
> +	if (!io_priv->dma_area)
> +		goto err_dma_area;
>  	set_io_private(sch, io_priv);
>  	cdev = io_subchannel_create_ccwdev(sch);
>  	if (IS_ERR(cdev)) {
>  		put_device(&sch->dev);
> +		dma_free_coherent(&sch->dev, sizeof(*io_priv->dma_area),
> +				  io_priv->dma_area, io_priv->dma_area_dma);
>  		kfree(io_priv);

<pre-existing, not introduced by this patch>
Shouldn't that branch do set_io_private(sch, NULL)? Not sure if any
code would make use of it, but it's probably better to clean out
references to freed objects.
</pre-existing, not introduced by this patch>

>  		return cdev;
>  	}
>  	cdev->drv = drv;
>  	ccw_device_set_int_class(cdev);
>  	return cdev;
> +
> +err_dma_area:
> +	kfree(io_priv);
> +err_priv:
> +	put_device(&sch->dev);
> +	return ERR_PTR(-ENOMEM);
>  }
>  
>  void __init ccw_device_destroy_console(struct ccw_device *cdev)

With the reservations above,
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
