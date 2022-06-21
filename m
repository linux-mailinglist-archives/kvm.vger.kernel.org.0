Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02ABE552E11
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 11:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348156AbiFUJQl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 05:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348055AbiFUJQj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 05:16:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A218212D05
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 02:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655802997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xE1eQ7rSn112nzVYfSbRI8lphkzHLYug/d5ePoCHz4Q=;
        b=L8EIsaXXy0GcVJkiihGfI7mLeFU7QIRQ/RXKFefjD0QE6ADT3Bv3pYj3IdBmDdXJCJmRyZ
        qSv3imLpqhKL9BqNhD2udd4MHXRMPLe2PRXa5Bbbv2rytYsW+9mZ/uRBKMSO2l/NBtdA6d
        N+kzfUNRy1x5MsLmYkiMaYtur718eFo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-73-ETFWK0YNNTm6xaO8-uYDiQ-1; Tue, 21 Jun 2022 05:16:34 -0400
X-MC-Unique: ETFWK0YNNTm6xaO8-uYDiQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ADBB8811E81;
        Tue, 21 Jun 2022 09:16:33 +0000 (UTC)
Received: from localhost (unknown [10.39.193.229])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5593C1121314;
        Tue, 21 Jun 2022 09:16:33 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Wang <jasowang@redhat.com>, pasic@linux.ibm.com,
        jasowang@redhat.com, mst@redhat.com
Cc:     gor@linux.ibm.com, borntraeger@de.ibm.com, agordeev@linux.ibm.com,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] virtio: disable notification hardening by default
In-Reply-To: <20220620024158.2505-1-jasowang@redhat.com>
Organization: Red Hat GmbH
References: <20220620024158.2505-1-jasowang@redhat.com>
User-Agent: Notmuch/0.36 (https://notmuchmail.org)
Date:   Tue, 21 Jun 2022 11:16:31 +0200
Message-ID: <87y1xq8jgw.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20 2022, Jason Wang <jasowang@redhat.com> wrote:

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
> ---
> Changes since V1:
> - tweak the Kconfig prompt
> - don't hold spinlock for IRQ path in s390
> ---
>  drivers/s390/virtio/virtio_ccw.c |  4 ++++
>  drivers/virtio/Kconfig           | 11 +++++++++++
>  drivers/virtio/virtio.c          |  2 ++
>  drivers/virtio/virtio_ring.c     | 12 ++++++++++++
>  include/linux/virtio_config.h    |  2 ++
>  5 files changed, 31 insertions(+)
>
> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> index 97e51c34e6cf..89bbf7ccfdd1 100644
> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -1136,8 +1136,10 @@ static void virtio_ccw_int_handler(struct ccw_device *cdev,
>  			vcdev->err = -EIO;
>  	}
>  	virtio_ccw_check_activity(vcdev, activity);
> +#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
>  	/* Interrupts are disabled here */
>  	read_lock(&vcdev->irq_lock);

Should we add a comment that this pairs with
virtio_ccw_synchronize_cbs()? Just to avoid future headscratching as to
why this lock is only needed when notification hardening is enabled.

> +#endif
>  	for_each_set_bit(i, indicators(vcdev),
>  			 sizeof(*indicators(vcdev)) * BITS_PER_BYTE) {
>  		/* The bit clear must happen before the vring kick. */
> @@ -1146,7 +1148,9 @@ static void virtio_ccw_int_handler(struct ccw_device *cdev,
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
> index b5adf6abd241..96ec56d44b91 100644
> --- a/drivers/virtio/Kconfig
> +++ b/drivers/virtio/Kconfig
> @@ -35,6 +35,17 @@ menuconfig VIRTIO_MENU
>  
>  if VIRTIO_MENU
>  
> +config VIRTIO_HARDEN_NOTIFICATION
> +        bool "Harden virtio notification"
> +        help
> +          Enable this to harden the device notifications and supress
> +          the ones that are illegal.

"...and suppress those that happen at a time where notifications are
illegal." ?

> +
> +          Experimental: not all drivers handle this correctly at this
> +          point.

"Note that several drivers still have bugs that may cause crashes or
hangs when correct handling of notifications is enforced; depending on
the subset of drivers and devices you use, this may or may not work."

Or is that too verbose?

> +
> +          If unsure, say N.
> +
>  config VIRTIO_PCI
>  	tristate "PCI driver for virtio devices"
>  	depends on PCI

The ifdeffery looks a big ugly, but I don't have a better idea.

