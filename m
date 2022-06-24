Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE495595C2
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 10:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbiFXItT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 04:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiFXItS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 04:49:18 -0400
Received: from out199-12.us.a.mail.aliyun.com (out199-12.us.a.mail.aliyun.com [47.90.199.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A304563AB;
        Fri, 24 Jun 2022 01:49:15 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R491e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VHGM-Tl_1656060550;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VHGM-Tl_1656060550)
          by smtp.aliyun-inc.com;
          Fri, 24 Jun 2022 16:49:11 +0800
Message-ID: <1656060115.233734-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH V3] virtio: disable notification hardening by default
Date:   Fri, 24 Jun 2022 16:41:55 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     ben@decadent.org.uk, cohuck@redhat.com, pasic@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com,
        agordeev@linux.ibm.com, mst@redhat.com, jasowang@redhat.com,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220622012940.21441-1-jasowang@redhat.com>
In-Reply-To: <20220622012940.21441-1-jasowang@redhat.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 22 Jun 2022 09:29:40 +0800, Jason Wang <jasowang@redhat.com> wrote:
> We try to harden virtio device notifications in 8b4ec69d7e09 ("virtio:
> harden vring IRQ"). It works with the assumption that the driver or
> core can properly call virtio_device_ready() at the right
> place. Unfortunately, this seems to be not true and uncover various
> bugs of the existing drivers, mainly the issue of using
> virtio_device_ready() incorrectly.
>
> So let's having a Kconfig option and disable it by default. It gives
> us a breath to fix the drivers and then we can consider to enable it
> by default.


hi, I have a question.

What should we do when the queue is reset and CONFIG_VIRTIO_HARDEN_NOTIFICATION
is off?

Since disable_irq() cannot be used, we should trust the device not to send irqs
again. So we don't have to do anything?

Thanks.

>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
> Changes since V2:
> - Tweak the Kconfig help
> - Add comment for the read_lock() pairing in virtio_ccw
> ---
>  drivers/s390/virtio/virtio_ccw.c |  9 ++++++++-
>  drivers/virtio/Kconfig           | 13 +++++++++++++
>  drivers/virtio/virtio.c          |  2 ++
>  drivers/virtio/virtio_ring.c     | 12 ++++++++++++
>  include/linux/virtio_config.h    |  2 ++
>  5 files changed, 37 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> index 97e51c34e6cf..1f6a358f65f0 100644
> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -1136,8 +1136,13 @@ static void virtio_ccw_int_handler(struct ccw_device *cdev,
>  			vcdev->err = -EIO;
>  	}
>  	virtio_ccw_check_activity(vcdev, activity);
> -	/* Interrupts are disabled here */
> +#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
> +	/*
> +	 * Paried with virtio_ccw_synchronize_cbs() and interrupts are
> +	 * disabled here.
> +	 */
>  	read_lock(&vcdev->irq_lock);
> +#endif
>  	for_each_set_bit(i, indicators(vcdev),
>  			 sizeof(*indicators(vcdev)) * BITS_PER_BYTE) {
>  		/* The bit clear must happen before the vring kick. */
> @@ -1146,7 +1151,9 @@ static void virtio_ccw_int_handler(struct ccw_device *cdev,
>  		vq = virtio_ccw_vq_by_ind(vcdev, i);
>  		vring_interrupt(0, vq);
>  	}
> +#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
>  	read_unlock(&vcdev->irq_lock);
> +#endif
>  	if (test_bit(0, indicators2(vcdev))) {
>  		virtio_config_changed(&vcdev->vdev);
>  		clear_bit(0, indicators2(vcdev));
> diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
> index b5adf6abd241..c04f370a1e5c 100644
> --- a/drivers/virtio/Kconfig
> +++ b/drivers/virtio/Kconfig
> @@ -35,6 +35,19 @@ menuconfig VIRTIO_MENU
>
>  if VIRTIO_MENU
>
> +config VIRTIO_HARDEN_NOTIFICATION
> +        bool "Harden virtio notification"
> +        help
> +          Enable this to harden the device notifications and suppress
> +          those that happen at a time where notifications are illegal.
> +
> +          Experimental: Note that several drivers still have bugs that
> +          may cause crashes or hangs when correct handling of
> +          notifications is enforced; depending on the subset of
> +          drivers and devices you use, this may or may not work.
> +
> +          If unsure, say N.
> +
>  config VIRTIO_PCI
>  	tristate "PCI driver for virtio devices"
>  	depends on PCI
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index ef04a96942bf..21dc08d2f32d 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -220,6 +220,7 @@ static int virtio_features_ok(struct virtio_device *dev)
>   * */
>  void virtio_reset_device(struct virtio_device *dev)
>  {
> +#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
>  	/*
>  	 * The below virtio_synchronize_cbs() guarantees that any
>  	 * interrupt for this line arriving after
> @@ -228,6 +229,7 @@ void virtio_reset_device(struct virtio_device *dev)
>  	 */
>  	virtio_break_device(dev);
>  	virtio_synchronize_cbs(dev);
> +#endif
>
>  	dev->config->reset(dev);
>  }
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 13a7348cedff..d9d3b6e201fb 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -1688,7 +1688,11 @@ static struct virtqueue *vring_create_virtqueue_packed(
>  	vq->we_own_ring = true;
>  	vq->notify = notify;
>  	vq->weak_barriers = weak_barriers;
> +#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
>  	vq->broken = true;
> +#else
> +	vq->broken = false;
> +#endif
>  	vq->last_used_idx = 0;
>  	vq->event_triggered = false;
>  	vq->num_added = 0;
> @@ -2135,9 +2139,13 @@ irqreturn_t vring_interrupt(int irq, void *_vq)
>  	}
>
>  	if (unlikely(vq->broken)) {
> +#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
>  		dev_warn_once(&vq->vq.vdev->dev,
>  			      "virtio vring IRQ raised before DRIVER_OK");
>  		return IRQ_NONE;
> +#else
> +		return IRQ_HANDLED;
> +#endif
>  	}
>
>  	/* Just a hint for performance: so it's ok that this can be racy! */
> @@ -2180,7 +2188,11 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
>  	vq->we_own_ring = false;
>  	vq->notify = notify;
>  	vq->weak_barriers = weak_barriers;
> +#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
>  	vq->broken = true;
> +#else
> +	vq->broken = false;
> +#endif
>  	vq->last_used_idx = 0;
>  	vq->event_triggered = false;
>  	vq->num_added = 0;
> diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
> index 9a36051ceb76..d15c3cdda2d2 100644
> --- a/include/linux/virtio_config.h
> +++ b/include/linux/virtio_config.h
> @@ -257,6 +257,7 @@ void virtio_device_ready(struct virtio_device *dev)
>
>  	WARN_ON(status & VIRTIO_CONFIG_S_DRIVER_OK);
>
> +#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
>  	/*
>  	 * The virtio_synchronize_cbs() makes sure vring_interrupt()
>  	 * will see the driver specific setup if it sees vq->broken
> @@ -264,6 +265,7 @@ void virtio_device_ready(struct virtio_device *dev)
>  	 */
>  	virtio_synchronize_cbs(dev);
>  	__virtio_unbreak_device(dev);
> +#endif
>  	/*
>  	 * The transport should ensure the visibility of vq->broken
>  	 * before setting DRIVER_OK. See the comments for the transport
> --
> 2.25.1
>
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
