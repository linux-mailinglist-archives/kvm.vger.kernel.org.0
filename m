Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1161A6C2DBF
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 10:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjCUJYM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 05:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjCUJYL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 05:24:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548A016335
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 02:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679390607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Pn5brbGgNvIiwAbTr396tg4MWSNJ8Oc96gtsZGXUcYM=;
        b=RKRLqMSuajkRqFX0I6kRJGREVuD7eXz7eFofrpi7BH5IyfG91bH3XuR2ZCunlF/EzjFp1P
        n41LBO2tehKJz5tPqepydvs8imtaHsD7i95WD/q/IjcjOIa8PsinNWP3kgReJu22j4hwDM
        YaXLZaQ5NPtG0KSPDJ6YfOjJ3yV8V1s=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-IFERgDogO0mwFZ4iGzR-xQ-1; Tue, 21 Mar 2023 05:23:25 -0400
X-MC-Unique: IFERgDogO0mwFZ4iGzR-xQ-1
Received: by mail-wm1-f71.google.com with SMTP id l18-20020a05600c4f1200b003ed35ab903aso9294202wmq.6
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 02:23:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679390604;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pn5brbGgNvIiwAbTr396tg4MWSNJ8Oc96gtsZGXUcYM=;
        b=NLKDserlG5qBVVlyU44zDOaFNnFUQTlJjdt7YVsgyxczRnGC2u9Y4sjwmdFNHxep6n
         rYwd9SloRJZH46YkBPzcgHxbTEJmK4AZ/ilUG2RYgu7HovowB++zsNfb+Dv30UpI6hcx
         H+W1ceq50ZOckBeI0LSh1erY/nM682o7wMN5Msy15UYdN6uRojqBJbFnLidt4YitPUpV
         DAcAtTbrJGc3swMzyhI0xQerDIwkpKXJJQ4D7Qv6sjaj7x8yxDPYho+VeH0vr0m3h0Sn
         XXeNuk4Te8ocYizqrFnhsqfLfORsf/boLOD2iA5I/mtuOfGp0nf0ox8QJJdI25k13nY4
         c94Q==
X-Gm-Message-State: AO0yUKXtUsIsU/Bmgl4RpJzj/bsmELdBcjzkdgN4MwKy58yRgLk5Ie93
        K4OqFtH2jFpNHTA4OcW6iCKToXKyJ8L82M1ZyMtA2zwmtUzjtOokYjMWlKOiQ/2KmdSq96NKinB
        1bJvZTUN5urm5
X-Received: by 2002:a1c:6a08:0:b0:3ea:ed4d:38eb with SMTP id f8-20020a1c6a08000000b003eaed4d38ebmr1871983wmc.24.1679390604692;
        Tue, 21 Mar 2023 02:23:24 -0700 (PDT)
X-Google-Smtp-Source: AK7set/5Sl5sP+nX8YGttWKA3yT06XBaU7ihGH43O5M3uoUtpcc9jFKpSMids9Me1PPqfY0eMN3yJA==
X-Received: by 2002:a1c:6a08:0:b0:3ea:ed4d:38eb with SMTP id f8-20020a1c6a08000000b003eaed4d38ebmr1871973wmc.24.1679390604390;
        Tue, 21 Mar 2023 02:23:24 -0700 (PDT)
Received: from redhat.com ([2.52.1.105])
        by smtp.gmail.com with ESMTPSA id n1-20020a7bc5c1000000b003db03725e86sm13222630wmk.8.2023.03.21.02.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 02:23:24 -0700 (PDT)
Date:   Tue, 21 Mar 2023 05:23:20 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Viktor Prutyanov <viktor@daynix.com>
Cc:     jasowang@redhat.com, cohuck@redhat.com, pasic@linux.ibm.com,
        farman@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, yan@daynix.com
Subject: Re: [PATCH v2] virtio: add VIRTIO_F_NOTIFICATION_DATA feature support
Message-ID: <20230321050747-mutt-send-email-mst@kernel.org>
References: <20230320232115.1940587-1-viktor@daynix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320232115.1940587-1-viktor@daynix.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023 at 02:21:15AM +0300, Viktor Prutyanov wrote:
> According to VirtIO spec v1.2, VIRTIO_F_NOTIFICATION_DATA feature
> indicates that the driver passes extra data along with the queue
> notifications.
> 
> In a split queue case, the extra data is 16-bit available index. In a
> packed queue case, the extra data is 1-bit wrap counter and 15-bit
> available index.
> 
> Add support for this feature for MMIO and PCI transports. Channel I/O
> transport will not accept this feature.
> 
> Signed-off-by: Viktor Prutyanov <viktor@daynix.com>
> ---
> 
>  v2: reject the feature in virtio_ccw, replace __le32 with u32
> 
>  drivers/s390/virtio/virtio_ccw.c   |  4 +---
>  drivers/virtio/virtio_mmio.c       | 15 ++++++++++++++-
>  drivers/virtio/virtio_pci_common.c | 10 ++++++++++
>  drivers/virtio/virtio_pci_common.h |  4 ++++
>  drivers/virtio/virtio_pci_legacy.c |  2 +-
>  drivers/virtio/virtio_pci_modern.c |  2 +-
>  drivers/virtio/virtio_ring.c       | 17 +++++++++++++++++
>  include/linux/virtio_ring.h        |  2 ++
>  include/uapi/linux/virtio_config.h |  6 ++++++
>  9 files changed, 56 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> index a10dbe632ef9..d72a59415527 100644
> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -789,9 +789,7 @@ static u64 virtio_ccw_get_features(struct virtio_device *vdev)
>  
>  static void ccw_transport_features(struct virtio_device *vdev)
>  {
> -	/*
> -	 * Currently nothing to do here.
> -	 */
> +	__virtio_clear_bit(vdev, VIRTIO_F_NOTIFICATION_DATA);
>  }
>  
>  static int virtio_ccw_finalize_features(struct virtio_device *vdev)
> diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> index 3ff746e3f24a..0e13da17fe0a 100644
> --- a/drivers/virtio/virtio_mmio.c
> +++ b/drivers/virtio/virtio_mmio.c
> @@ -285,6 +285,19 @@ static bool vm_notify(struct virtqueue *vq)
>  	return true;
>  }
>  
> +static bool vm_notify_with_data(struct virtqueue *vq)
> +{
> +	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vq->vdev);
> +	u32 data = vring_fill_notification_data(vq);
> +
> +	writel(data, vm_dev->base + VIRTIO_MMIO_QUEUE_NOTIFY);
> +
> +	return true;
> +}
> +
> +#define VM_NOTIFY(vdev) (__virtio_test_bit((vdev), VIRTIO_F_NOTIFICATION_DATA) \
> +	? vm_notify_with_data : vm_notify)
> +
>  /* Notify all virtqueues on an interrupt. */
>  static irqreturn_t vm_interrupt(int irq, void *opaque)
>  {
> @@ -397,7 +410,7 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned int in
>  
>  	/* Create the vring */
>  	vq = vring_create_virtqueue(index, num, VIRTIO_MMIO_VRING_ALIGN, vdev,
> -				 true, true, ctx, vm_notify, callback, name);
> +			true, true, ctx, VM_NOTIFY(vdev), callback, name);

I don't see why is this macro useful.



>  	if (!vq) {
>  		err = -ENOMEM;
>  		goto error_new_virtqueue;
> diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
> index a6c86f916dbd..535263abc2bd 100644
> --- a/drivers/virtio/virtio_pci_common.c
> +++ b/drivers/virtio/virtio_pci_common.c
> @@ -43,6 +43,16 @@ bool vp_notify(struct virtqueue *vq)
>  	/* we write the queue's selector into the notification register to
>  	 * signal the other end */
>  	iowrite16(vq->index, (void __iomem *)vq->priv);
> +
> +	return true;
> +}
> +
> +bool vp_notify_with_data(struct virtqueue *vq)
> +{
> +	u32 data = vring_fill_notification_data(vq);
> +
> +	iowrite32(data, (void __iomem *)vq->priv);
> +
>  	return true;
>  }
>  
> diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
> index 23112d84218f..9a7212dcbb32 100644
> --- a/drivers/virtio/virtio_pci_common.h
> +++ b/drivers/virtio/virtio_pci_common.h
> @@ -105,6 +105,7 @@ static struct virtio_pci_device *to_vp_device(struct virtio_device *vdev)
>  void vp_synchronize_vectors(struct virtio_device *vdev);
>  /* the notify function used when creating a virt queue */
>  bool vp_notify(struct virtqueue *vq);
> +bool vp_notify_with_data(struct virtqueue *vq);
>  /* the config->del_vqs() implementation */
>  void vp_del_vqs(struct virtio_device *vdev);
>  /* the config->find_vqs() implementation */
> @@ -114,6 +115,9 @@ int vp_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
>  		struct irq_affinity *desc);
>  const char *vp_bus_name(struct virtio_device *vdev);
>  
> +#define VP_NOTIFY(vdev) (__virtio_test_bit((vdev), VIRTIO_F_NOTIFICATION_DATA) \
> +	? vp_notify : vp_notify_with_data)
> +
>  /* Setup the affinity for a virtqueue:
>   * - force the affinity for per vq vector
>   * - OR over all affinities for shared MSI
> diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
> index 2257f1b3d8ae..b98e994cae48 100644
> --- a/drivers/virtio/virtio_pci_legacy.c
> +++ b/drivers/virtio/virtio_pci_legacy.c
> @@ -131,7 +131,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
>  	vq = vring_create_virtqueue(index, num,
>  				    VIRTIO_PCI_VRING_ALIGN, &vp_dev->vdev,
>  				    true, false, ctx,
> -				    vp_notify, callback, name);
> +				    VP_NOTIFY(&vp_dev->vdev), callback, name);
>  	if (!vq)
>  		return ERR_PTR(-ENOMEM);
>  
> diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
> index 9e496e288cfa..7fcd8af5af7e 100644
> --- a/drivers/virtio/virtio_pci_modern.c
> +++ b/drivers/virtio/virtio_pci_modern.c
> @@ -321,7 +321,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
>  	vq = vring_create_virtqueue(index, num,
>  				    SMP_CACHE_BYTES, &vp_dev->vdev,
>  				    true, true, ctx,
> -				    vp_notify, callback, name);
> +				    VP_NOTIFY(&vp_dev->vdev), callback, name);
>  	if (!vq)
>  		return ERR_PTR(-ENOMEM);
>  
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 723c4e29e1d3..5e9e1800bb6e 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -2699,6 +2699,21 @@ void vring_del_virtqueue(struct virtqueue *_vq)
>  }
>  EXPORT_SYMBOL_GPL(vring_del_virtqueue);
>  
> +u32 vring_fill_notification_data(struct virtqueue *_vq)
> +{
> +	struct vring_virtqueue *vq = to_vvq(_vq);
> +	u16 next;
> +
> +	if (vq->packed_ring)
> +		next = (vq->packed.next_avail_idx & ~(1 << 15)) |
> +			((u16)vq->packed.avail_wrap_counter << 15);

I don't think the cast is needed. Neither is () around << the second <<
here (first is needed because gcc chooses to complain: apparently it
considers bitwise and a math operation for some obscure reason).

> +	else
> +		next = virtio16_to_cpu(_vq->vdev, vq->split.vring.avail->idx);
> +
> +	return ((u32)next << 16) | _vq->index;

I don't think the cast is needed. Neither is () around << needed.

> +}
> +EXPORT_SYMBOL_GPL(vring_fill_notification_data);
> +

I'd inline this - it's on data path ...

>  /* Manipulates transport-specific feature bits. */
>  void vring_transport_features(struct virtio_device *vdev)
>  {

> @@ -2718,6 +2733,8 @@ void vring_transport_features(struct virtio_device *vdev)
>  			break;
>  		case VIRTIO_F_ORDER_PLATFORM:
>  			break;
> +		case VIRTIO_F_NOTIFICATION_DATA:
> +			break;
>  		default:
>  			/* We don't understand this bit. */
>  			__virtio_clear_bit(vdev, i);
> diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
> index 8b8af1a38991..1f65d2f77012 100644
> --- a/include/linux/virtio_ring.h
> +++ b/include/linux/virtio_ring.h
> @@ -101,4 +101,6 @@ void vring_del_virtqueue(struct virtqueue *vq);
>  void vring_transport_features(struct virtio_device *vdev);
>  
>  irqreturn_t vring_interrupt(int irq, void *_vq);
> +
> +u32 vring_fill_notification_data(struct virtqueue *_vq);
>  #endif /* _LINUX_VIRTIO_RING_H */
> diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
> index 3c05162bc988..2c712c654165 100644
> --- a/include/uapi/linux/virtio_config.h
> +++ b/include/uapi/linux/virtio_config.h
> @@ -99,6 +99,12 @@
>   */
>  #define VIRTIO_F_SR_IOV			37
>  
> +/*
> + * This feature indicates that the driver passes extra data (besides
> + * identifying the virtqueue) in its device notifications.
> + */
> +#define VIRTIO_F_NOTIFICATION_DATA	38
> +
>  /*
>   * This feature indicates that the driver can reset a queue individually.
>   */
> -- 
> 2.35.1

