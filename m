Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2F6554335
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 09:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350705AbiFVHDH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 03:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbiFVHDF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 03:03:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EB32062C9
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 00:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655881383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GCD3psuHX6jJIpbPfzjKGeJSzZy7gODh0AJkTB5GqSc=;
        b=icmrmA60y5uat5YG+qsAIAO+z1z3duy1YU/OAz2HELnhsf/lsTEm4Y0Jr0sF3KAIamv/hG
        8PmtaBp1adQQwSyYUqovsi5ja+aOj9DvYWDvhIFGi7DfIRbpL3Aq1tZMuHqNtq6fuTJqiL
        4kT5RF4ICmgynnABNF7b0nH4B6IhGDc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-1-EGMFiDB8M2ahhTG2Y_vAnA-1; Wed, 22 Jun 2022 03:03:00 -0400
X-MC-Unique: EGMFiDB8M2ahhTG2Y_vAnA-1
Received: by mail-wm1-f71.google.com with SMTP id o2-20020a05600c510200b0039747b0216fso9668418wms.0
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 00:03:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GCD3psuHX6jJIpbPfzjKGeJSzZy7gODh0AJkTB5GqSc=;
        b=JmHIHJjVa8neZfXyB/4xShqxUeGiwdLFh02Jisr3nspIqaAi84RvOa+W/KWLvFoosQ
         haUaKpgqrH2KyGE4UbLL4n2J9i+cihm+/8nNNQWyymrwRFq7jkf3Wq3fz193iDQhlJKM
         Tb04A12NwvD+QlqbA3y1SGkRe3DapCK6irw++lLkSMiWQ/4+67RSz37c4DPvjH4skvEQ
         Dy7+mSYPrIaPbfpWI+83V/9oeyaCP5YHCs9oqZiIpboYB/M/2dyyddvpljtQTMjBDx0m
         zq5/PAYO/kc9aznRMENTc1la3+X3FVDNb3b6n+dEzN+HKxKDD4GTS84abwdHfgQmz4+S
         zJng==
X-Gm-Message-State: AJIora/TTDlfCD0Imd8EqQ+L+mE51AJM/g0Tb2MOyGgXStIar9pK7xjB
        2QOStkesIMiJrHFX2CajvznIRAk6jsLEubn0+HHiH4qL1qO9i3agUTA2xsMs3p6LgBlAnDb2A3a
        4fBBv7VOg6k6a
X-Received: by 2002:adf:ed8f:0:b0:21b:8971:9304 with SMTP id c15-20020adfed8f000000b0021b89719304mr1649851wro.536.1655881379438;
        Wed, 22 Jun 2022 00:02:59 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uryMOcT1NY6x+FLBk6Nz8z1y2JB+/0KSGhZjK/7vhZfJJj5KkS7UpQ/PUN9+a61CmnIh/qIw==
X-Received: by 2002:adf:ed8f:0:b0:21b:8971:9304 with SMTP id c15-20020adfed8f000000b0021b89719304mr1649822wro.536.1655881379115;
        Wed, 22 Jun 2022 00:02:59 -0700 (PDT)
Received: from redhat.com ([147.235.217.93])
        by smtp.gmail.com with ESMTPSA id bg26-20020a05600c3c9a00b0039c45fc58c4sm21098184wmb.21.2022.06.22.00.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 00:02:58 -0700 (PDT)
Date:   Wed, 22 Jun 2022 03:02:55 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     cohuck@redhat.com, pasic@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com, agordeev@linux.ibm.com,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, ben@decadent.org.uk, david@redhat.com
Subject: Re: [PATCH V3] virtio: disable notification hardening by default
Message-ID: <20220622025047-mutt-send-email-mst@kernel.org>
References: <20220622012940.21441-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622012940.21441-1-jasowang@redhat.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 22, 2022 at 09:29:40AM +0800, Jason Wang wrote:
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
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>


OK I will queue, but I think the problem is fundamental.


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

