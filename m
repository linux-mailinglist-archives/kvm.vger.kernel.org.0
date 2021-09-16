Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D55240D532
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 10:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235239AbhIPJAp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 05:00:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50462 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234462AbhIPJAn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Sep 2021 05:00:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631782763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t2Z/Tfws0/ZPIkBTJwi6vBLPKuMktwH7w8C6L94eoVM=;
        b=G37tWJXZgJiTawDu+EWUQkxqQIqtNGr2OS2sboJ68TjLxP1BJ2HCchOBNR1RUpPpyE36Ra
        QFaEI7NxT9wzJIsXKdl/5Bfc+qjMBk/6JTZ0L6D9jxbVSYzK3SmwaWeAhouOhYyNzYymio
        sr8our5csTOncndMxOOJ0q5V+Q6PMbU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-54-GlU6ZhEVPs-lOiN55UKk5A-1; Thu, 16 Sep 2021 04:59:19 -0400
X-MC-Unique: GlU6ZhEVPs-lOiN55UKk5A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 24861100CCC1;
        Thu, 16 Sep 2021 08:59:18 +0000 (UTC)
Received: from localhost (unknown [10.39.192.155])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B554960FDD;
        Thu, 16 Sep 2021 08:59:17 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     bfu@redhat.com, Vineeth Vijayan <vneethv@linux.ibm.com>
Subject: Re: [PATCH 1/1] virtio/s390: fix vritio-ccw device teardown
In-Reply-To: <20210915215742.1793314-1-pasic@linux.ibm.com>
Organization: Red Hat GmbH
References: <20210915215742.1793314-1-pasic@linux.ibm.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Thu, 16 Sep 2021 10:59:15 +0200
Message-ID: <87pmt8hp5o.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 15 2021, Halil Pasic <pasic@linux.ibm.com> wrote:

> Since commit 48720ba56891 ("virtio/s390: use DMA memory for ccw I/O and
> classic notifiers") we were supposed to make sure that
> virtio_ccw_release_dev() completes before the ccw device, and the
> attached dma pool are torn down, but unfortunately we did not.
> Before that commit it used to be OK to delay cleaning up the memory
> allocated by virtio-ccw indefinitely (which isn't really intuitive for
> guys used to destruction happens in reverse construction order).
>
> To accomplish this let us take a reference on the ccw device before we
> allocate the dma_area and give it up after dma_area was freed.
>
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> Fixes: 48720ba56891 ("virtio/s390: use DMA memory for ccw I/O and
> classic notifiers")
> Reported-by: bfu@redhat.com
> ---
>
> I'm not certain this is the only hot-unplug and teardonw related problem
> with virtio-ccw.
>
> Some things that are not perfectly clear to me:
> * What would happen if we observed an hot-unplug while we are doing
>   wait_event() in ccw_io_helper()? Do we get stuck? I don't thin we
>   are guaranteed to receive an irq for a subchannel that is gone.

Hm. I think we may need to do a wake_up during remove handling.

> * cdev->online seems to be manipulated under cdev->ccwlock, but
>   in virtio_ccw_remove() we look at it to decide should we clean up
>   or not. What is the idea there? I guess we want to avoid doing
>   if nothing is there or twice. But I don't understand how stuff
>   interlocks.

We only created the virtio device when we onlined the ccw device. Do you
have a better idea how to check for that? (And yes, I'm not sure the
locking is correct.)

> * Can virtio_ccw_remove() get called while !cdev->online and 
>   virtio_ccw_online() is running on a different cpu? If yes, what would
>   happen then?

All of the remove/online/... etc. callbacks are invoked via the ccw bus
code. We have to trust that it gets it correct :) (Or have the common
I/O layer maintainers double-check it.)

>  
> The main addresse of these questions is Conny ;).
>
> An alternative to this approach would be to inc and dec the refcount
> in ccw_device_dma_zalloc() and ccw_device_dma_free() respectively.

Yeah, I also thought about that. This would give us more get/put
operations, but might be the safer option.

>
> ---
>  drivers/s390/virtio/virtio_ccw.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> index d35e7a3f7067..99141df3259b 100644
> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -1006,10 +1006,12 @@ static void virtio_ccw_release_dev(struct device *_d)
>  {
>  	struct virtio_device *dev = dev_to_virtio(_d);
>  	struct virtio_ccw_device *vcdev = to_vc_device(dev);
> +	struct ccw_device *cdev = READ_ONCE(vcdev->cdev);
>  
>  	ccw_device_dma_free(vcdev->cdev, vcdev->dma_area,
>  			    sizeof(*vcdev->dma_area));
>  	kfree(vcdev);
> +	put_device(&cdev->dev);
>  }
>  
>  static int irb_is_error(struct irb *irb)
> @@ -1262,6 +1264,7 @@ static int virtio_ccw_online(struct ccw_device *cdev)
>  	struct virtio_ccw_device *vcdev;
>  	unsigned long flags;
>  
> +	get_device(&cdev->dev);
>  	vcdev = kzalloc(sizeof(*vcdev), GFP_KERNEL);
>  	if (!vcdev) {
>  		dev_warn(&cdev->dev, "Could not get memory for virtio\n");
> @@ -1315,6 +1318,7 @@ static int virtio_ccw_online(struct ccw_device *cdev)
>  				    sizeof(*vcdev->dma_area));
>  	}
>  	kfree(vcdev);
> +	put_device(&cdev->dev);
>  	return ret;
>  }
>  
>
> base-commit: 3ca706c189db861b2ca2019a0901b94050ca49d8
> -- 
> 2.25.1

