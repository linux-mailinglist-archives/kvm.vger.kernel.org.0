Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B35E01B30D
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 11:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728640AbfEMJlp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 05:41:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54020 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726274AbfEMJlp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 05:41:45 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 64DBE81F07;
        Mon, 13 May 2019 09:41:44 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5C9641001DDE;
        Mon, 13 May 2019 09:41:39 +0000 (UTC)
Date:   Mon, 13 May 2019 11:41:36 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: Re: [PATCH 06/10] s390/cio: add basic protected virtualization
 support
Message-ID: <20190513114136.783c851c.cohuck@redhat.com>
In-Reply-To: <20190426183245.37939-7-pasic@linux.ibm.com>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
        <20190426183245.37939-7-pasic@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 13 May 2019 09:41:44 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 26 Apr 2019 20:32:41 +0200
Halil Pasic <pasic@linux.ibm.com> wrote:

> As virtio-ccw devices are channel devices, we need to use the dma area
> for any communication with the hypervisor.
> 
> This patch addresses the most basic stuff (mostly what is required for
> virtio-ccw), and does take care of QDIO or any devices.

"does not take care of QDIO", surely? (Also, what does "any devices"
mean? Do you mean "every arbitrary device", perhaps?)

> 
> An interesting side effect is that virtio structures are now going to
> get allocated in 31 bit addressable storage.

Hm...

> 
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> ---
>  arch/s390/include/asm/ccwdev.h   |  4 +++
>  drivers/s390/cio/ccwreq.c        |  8 ++---
>  drivers/s390/cio/device.c        | 65 +++++++++++++++++++++++++++++++++-------
>  drivers/s390/cio/device_fsm.c    | 40 ++++++++++++-------------
>  drivers/s390/cio/device_id.c     | 18 +++++------
>  drivers/s390/cio/device_ops.c    | 21 +++++++++++--
>  drivers/s390/cio/device_pgid.c   | 20 ++++++-------
>  drivers/s390/cio/device_status.c | 24 +++++++--------
>  drivers/s390/cio/io_sch.h        | 21 +++++++++----
>  drivers/s390/virtio/virtio_ccw.c | 10 -------
>  10 files changed, 148 insertions(+), 83 deletions(-)

(...)

> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> index 6d989c360f38..bb7a92316fc8 100644
> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -66,7 +66,6 @@ struct virtio_ccw_device {
>  	bool device_lost;
>  	unsigned int config_ready;
>  	void *airq_info;
> -	u64 dma_mask;
>  };
>  
>  struct vq_info_block_legacy {
> @@ -1255,16 +1254,7 @@ static int virtio_ccw_online(struct ccw_device *cdev)
>  		ret = -ENOMEM;
>  		goto out_free;
>  	}
> -
>  	vcdev->vdev.dev.parent = &cdev->dev;
> -	cdev->dev.dma_mask = &vcdev->dma_mask;
> -	/* we are fine with common virtio infrastructure using 64 bit DMA */
> -	ret = dma_set_mask_and_coherent(&cdev->dev, DMA_BIT_MASK(64));
> -	if (ret) {
> -		dev_warn(&cdev->dev, "Failed to enable 64-bit DMA.\n");
> -		goto out_free;
> -	}

This means that vring structures now need to fit into 31 bits as well,
I think? Is there any way to reserve the 31 bit restriction for channel
subsystem structures and keep vring in the full 64 bit range? (Or am I
fundamentally misunderstanding something?)

> -
>  	vcdev->config_block = kzalloc(sizeof(*vcdev->config_block),
>  				   GFP_DMA | GFP_KERNEL);
>  	if (!vcdev->config_block) {

