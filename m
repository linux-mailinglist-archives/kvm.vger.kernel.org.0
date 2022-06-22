Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83693554661
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 14:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353919AbiFVIcp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 04:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351464AbiFVIco (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 04:32:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 04A7E10BB
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 01:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655886763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kbGRJbqhqaDpYURUd1iIYFpog7R3QIPoGbLyON7y9kw=;
        b=NxbF1xGA74jrkn6kNR3sV3M8u+EmpVZUrKaIxrXs8tDpmNdGwq+legna7k6HhnNyrATm9Z
        H/mVEujZxp9k49ZW9SdKU12+BLMD76CjS5b/V/SlhMJSYjGF3Zo+iZYRTr3+4MTWnXxQzr
        Qw3gKRoc2yviJgDE47aRNgcLObYEXts=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-iNEYmxvyPGeSc7eIoTibxA-1; Wed, 22 Jun 2022 04:32:29 -0400
X-MC-Unique: iNEYmxvyPGeSc7eIoTibxA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54B5F1C04B49;
        Wed, 22 Jun 2022 08:32:28 +0000 (UTC)
Received: from localhost (unknown [10.39.192.153])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DC7EA40C5BF;
        Wed, 22 Jun 2022 08:32:27 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Wang <jasowang@redhat.com>, pasic@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com,
        agordeev@linux.ibm.com, mst@redhat.com, jasowang@redhat.com,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     ben@decadent.org.uk, david@redhat.com
Subject: Re: [PATCH V3] virtio: disable notification hardening by default
In-Reply-To: <20220622012940.21441-1-jasowang@redhat.com>
Organization: Red Hat GmbH
References: <20220622012940.21441-1-jasowang@redhat.com>
User-Agent: Notmuch/0.36 (https://notmuchmail.org)
Date:   Wed, 22 Jun 2022 10:32:26 +0200
Message-ID: <87h74d85et.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 22 2022, Jason Wang <jasowang@redhat.com> wrote:

> We try to harden virtio device notifications in 8b4ec69d7e09 ("virtio:
> harden vring IRQ"). It works with the assumption that the driver or
> core can properly call virtio_device_ready() at the right
> place. Unfortunately, this seems to be not true and uncover various
> bugs of the existing drivers, mainly the issue of using
> virtio_device_ready() incorrectly.
>
> So let's having a Kconfig option and disable it by default. It gives

s/having/have/

> us a breath to fix the drivers and then we can consider to enable it
> by default.
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

s/Paried/Paired/

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


Reviewed-by: Cornelia Huck <cohuck@redhat.com>

