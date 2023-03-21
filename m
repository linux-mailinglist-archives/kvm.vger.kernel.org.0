Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D78786C2DD5
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 10:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbjCUJ23 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 05:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjCUJ21 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 05:28:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3C62BEC4
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 02:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679390865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LA+RXUqkYMz8XHraazbxDwAoyRZ6mtYEiWEaraKXgsw=;
        b=bVWOz5P9M85nczh0838yoJOSzSLWF67JGpSjQa/SmrXjfY4oKJxD3mnLzBj5pUwEKPV+F2
        lAEnE1TJl2Y5qwWImZUnWsJ7K5gk5GZ48Mk7XJv6HrP8tVkrFefaZ6n9NtOq4497dN9W2A
        H4GWYCwIdvOIZ3QPuwXFoZ+4YEa3RM8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-279-1ZD0-7NlPTCX4NXkWhWBrw-1; Tue, 21 Mar 2023 05:27:40 -0400
X-MC-Unique: 1ZD0-7NlPTCX4NXkWhWBrw-1
Received: by mail-wm1-f71.google.com with SMTP id j27-20020a05600c1c1b00b003edd2023418so3797631wms.4
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 02:27:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679390860;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LA+RXUqkYMz8XHraazbxDwAoyRZ6mtYEiWEaraKXgsw=;
        b=ox3TVOGoL7okx4vr2wu6dQQt/fYA2xnM5sWty85lUPA25xxnHTeP1c9vu+ZDZVPAss
         vZwC3dq4oaREKB803UfiMNvtBpGsQlS562riGw8TohYeHGk3fHpEiEpV5L4EHXCtr6/n
         jd4GN8nkFNEgnDVrbHKDKNW6OjRyrC/+L8DuKi0cLbJBHeMKmwhGOCruqDAS6OHgKShy
         A5N/buFNLAYtGWtmeg/Whxb7ERy4gh31ycknyAtdTSHawfup9M5TGb66wYnYnftXr204
         m4bmC+QmIngILPdQdjs1/SBd5Bvn/o76TuJUAc/Ex66G1rFid366vovS+mlJ9+kGgYk5
         /DLg==
X-Gm-Message-State: AO0yUKVYSXfO68uuLDsMo/5/FbDHUF1DvpuovR1ISofpoMrzdUJT766k
        sJrY2YpPHXcMJ2vOjhiMPGHM5JbHaN0bO21OrRCPeFBVr1x975QHWhMS9Ds895V3faQAOL+gF1d
        VaJH0S4r2xMae
X-Received: by 2002:a1c:7915:0:b0:3ed:3993:6aa2 with SMTP id l21-20020a1c7915000000b003ed39936aa2mr1859033wme.11.1679390859815;
        Tue, 21 Mar 2023 02:27:39 -0700 (PDT)
X-Google-Smtp-Source: AK7set+zdomxqmeYP5mRC/r2MmjfSKc6viUTnX8ys2OMP5VJHTZHJ5/PmqhW2iDdydInHE6oIrLGWA==
X-Received: by 2002:a1c:7915:0:b0:3ed:3993:6aa2 with SMTP id l21-20020a1c7915000000b003ed39936aa2mr1859021wme.11.1679390859486;
        Tue, 21 Mar 2023 02:27:39 -0700 (PDT)
Received: from redhat.com ([2.52.1.105])
        by smtp.gmail.com with ESMTPSA id t20-20020a1c7714000000b003ee10fb56ebsm3670868wmi.9.2023.03.21.02.27.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 02:27:38 -0700 (PDT)
Date:   Tue, 21 Mar 2023 05:27:35 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Viktor Prutyanov <viktor@daynix.com>
Cc:     jasowang@redhat.com, cohuck@redhat.com, pasic@linux.ibm.com,
        farman@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, yan@daynix.com
Subject: Re: [PATCH v2] virtio: add VIRTIO_F_NOTIFICATION_DATA feature support
Message-ID: <20230321052407-mutt-send-email-mst@kernel.org>
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

btw what does "fill" mean here? why not just vring_notification_data?

> +{
> +	struct vring_virtqueue *vq = to_vvq(_vq);
> +	u16 next;
> +
> +	if (vq->packed_ring)
> +		next = (vq->packed.next_avail_idx & ~(1 << 15)) |
> +			((u16)vq->packed.avail_wrap_counter << 15);
> +	else
> +		next = virtio16_to_cpu(_vq->vdev, vq->split.vring.avail->idx);

BTW it's annoying to poke at avail->idx here - will cause a bunch of
cache misses. And the byte-swap is a waste.

Isn't this why we have avail_idx_shadow?

> +
> +	return ((u32)next << 16) | _vq->index;
> +}
> +EXPORT_SYMBOL_GPL(vring_fill_notification_data);
> +
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

