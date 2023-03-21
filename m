Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01B886C33D7
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 15:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbjCUOOz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 10:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbjCUOOq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 10:14:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A70FB447
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 07:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679408045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1ha6mdJ8kwP6Mmb6+n42QvpdTa0nloM3chi8NPku41M=;
        b=NxaoNYB71WAkOwvd2xXN3i7d0WlIBk89bQSFGe5QFn/74ZGqAa3VXRXWLNyxUcnIIr+Ktk
        KVuz60uxyUU91vL1Lq/IX6dD8hYCOpXmbAl+kzJelRf/kwPmxpaNxNGDfnw96qfGnEOL9u
        X3S5GzW+Acq1BWR3UF5ZA/iAdeHBAsQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-TgG8MHHZMPOl9ni-BuX8Ig-1; Tue, 21 Mar 2023 10:14:02 -0400
X-MC-Unique: TgG8MHHZMPOl9ni-BuX8Ig-1
Received: by mail-wr1-f70.google.com with SMTP id y4-20020adfc7c4000000b002d633dc129aso676953wrg.0
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 07:14:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679408041;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1ha6mdJ8kwP6Mmb6+n42QvpdTa0nloM3chi8NPku41M=;
        b=xHq++Dqs2dwsyVx0x6cjegvc2IhGlFoGf/Qh2Bb42O+uz7sSc71sFlC92pjeKB2X0o
         ZrlfAZS9e/fELQ+s9Q39viSpGMXRkNIpl7RFPGisOSGLcTBFiASjk9QfrJYDxlBjkxrb
         smSbO8fPrjyOYdxJzPmtGRf6l54B3EB85i++DO+2U++uUoCaLqC8aebX/uWOKdDpibg3
         8Jej+HzWHnKNPNukCWv7jLvP77ojP12YO15pP9ZFbkFXftdkyBDJz1ZNP7HEqknR7URQ
         dUZf928kJLwvU7X8e/OHRVSQWW7uWck6GsLPdLVDt5gERy52Vl4lNkYnyDZAQUs75Vnd
         CwVA==
X-Gm-Message-State: AO0yUKVaowb6qCYXtF5aRUlKQRybGaOyKS6HpSgOlFdu86/KKY5tv7cU
        fZit4EGNRZTF+E9soOntyhwwgPLMUXFFNZ8PA9dw4LBxL6eFRh1zmg3Up/kwXtAICgYUx/n6T7D
        QhxqtvUva4V3u
X-Received: by 2002:a5d:54c1:0:b0:2ce:9da7:6d42 with SMTP id x1-20020a5d54c1000000b002ce9da76d42mr2642869wrv.38.1679408041502;
        Tue, 21 Mar 2023 07:14:01 -0700 (PDT)
X-Google-Smtp-Source: AK7set8WXuQo6sf33U7+/K7vBlfSQMrOpoCadhe8y9SxfB4CdbhqKnFr4BEjKt7qbf0JBXC870morA==
X-Received: by 2002:a5d:54c1:0:b0:2ce:9da7:6d42 with SMTP id x1-20020a5d54c1000000b002ce9da76d42mr2642849wrv.38.1679408041114;
        Tue, 21 Mar 2023 07:14:01 -0700 (PDT)
Received: from redhat.com ([2.52.1.105])
        by smtp.gmail.com with ESMTPSA id c9-20020a5d4cc9000000b002d21379bcabsm11408596wrt.110.2023.03.21.07.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 07:14:00 -0700 (PDT)
Date:   Tue, 21 Mar 2023 10:13:57 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Viktor Prutyanov <viktor@daynix.com>
Cc:     jasowang@redhat.com, cohuck@redhat.com, pasic@linux.ibm.com,
        farman@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, yan@daynix.com
Subject: Re: [PATCH v3] virtio: add VIRTIO_F_NOTIFICATION_DATA feature support
Message-ID: <20230321100956-mutt-send-email-mst@kernel.org>
References: <20230321134410.2097163-1-viktor@daynix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321134410.2097163-1-viktor@daynix.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023 at 04:44:10PM +0300, Viktor Prutyanov wrote:
> According to VirtIO spec v1.2, VIRTIO_F_NOTIFICATION_DATA feature
> indicates that the driver passes extra data along with the queue
> notifications.
> 
> In a split queue case, the extra data is 16-bit available index. In a
> packed queue case, the extra data is 1-bit wrap counter and 15-bit
> available index.
> 
> Add support for this feature for MMIO, PCI and channel I/O transports.
> 
> Signed-off-by: Viktor Prutyanov <viktor@daynix.com>

Can you pls report what was tested and how? Thanks!

> ---
>  v3: support feature in virtio_ccw, remove VM_NOTIFY, use avail_idx_shadow,
>     remove byte swap, rename to vring_notification_data
>  v2: reject the feature in virtio_ccw, replace __le32 with u32
> 
>  drivers/s390/virtio/virtio_ccw.c   |  4 +++-
>  drivers/virtio/virtio_mmio.c       | 14 +++++++++++++-
>  drivers/virtio/virtio_pci_common.c | 10 ++++++++++
>  drivers/virtio/virtio_pci_common.h |  4 ++++
>  drivers/virtio/virtio_pci_legacy.c |  2 +-
>  drivers/virtio/virtio_pci_modern.c |  2 +-
>  drivers/virtio/virtio_ring.c       | 17 +++++++++++++++++
>  include/linux/virtio_ring.h        |  2 ++
>  include/uapi/linux/virtio_config.h |  6 ++++++
>  9 files changed, 57 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> index 954fc31b4bc7..c33172c5b8d5 100644
> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -396,13 +396,15 @@ static bool virtio_ccw_kvm_notify(struct virtqueue *vq)
>  	struct virtio_ccw_vq_info *info = vq->priv;
>  	struct virtio_ccw_device *vcdev;
>  	struct subchannel_id schid;
> +	u32 data = __virtio_test_bit(vq->vdev, VIRTIO_F_NOTIFICATION_DATA) ?
> +			vring_notification_data(vq) : vq->index;
>  
>  	vcdev = to_vc_device(info->vq->vdev);
>  	ccw_device_get_schid(vcdev->cdev, &schid);
>  	BUILD_BUG_ON(sizeof(struct subchannel_id) != sizeof(unsigned int));
>  	info->cookie = kvm_hypercall3(KVM_S390_VIRTIO_CCW_NOTIFY,
>  				      *((unsigned int *)&schid),
> -				      vq->index, info->cookie);
> +				      data, info->cookie);
>  	if (info->cookie < 0)
>  		return false;
>  	return true;
> diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> index 3ff746e3f24a..7c16e622c33d 100644
> --- a/drivers/virtio/virtio_mmio.c
> +++ b/drivers/virtio/virtio_mmio.c
> @@ -285,6 +285,16 @@ static bool vm_notify(struct virtqueue *vq)
>  	return true;
>  }
>  
> +static bool vm_notify_with_data(struct virtqueue *vq)
> +{
> +	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vq->vdev);
> +	u32 data = vring_notification_data(vq);
> +
> +	writel(data, vm_dev->base + VIRTIO_MMIO_QUEUE_NOTIFY);
> +
> +	return true;
> +}
> +
>  /* Notify all virtqueues on an interrupt. */
>  static irqreturn_t vm_interrupt(int irq, void *opaque)
>  {
> @@ -368,6 +378,8 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned int in
>  	unsigned long flags;
>  	unsigned int num;
>  	int err;
> +	bool (*notify)(struct virtqueue *vq) = __virtio_test_bit(vdev,
> +		VIRTIO_F_NOTIFICATION_DATA) ? vm_notify_with_data : vm_notify;
>  
>  	if (!name)
>  		return NULL;
> @@ -397,7 +409,7 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned int in
>  
>  	/* Create the vring */
>  	vq = vring_create_virtqueue(index, num, VIRTIO_MMIO_VRING_ALIGN, vdev,
> -				 true, true, ctx, vm_notify, callback, name);
> +				 true, true, ctx, notify, callback, name);
>  	if (!vq) {
>  		err = -ENOMEM;
>  		goto error_new_virtqueue;
> diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
> index a6c86f916dbd..e915c22f2384 100644
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
> +	u32 data = vring_notification_data(vq);
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

I still think this macro is pointless.

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

And this is completely poinless because legacy can never
enable VIRTIO_F_NOTIFICATION_DATA.

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
> index 4c3bb0ddeb9b..837875cc3190 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -2752,6 +2752,21 @@ void vring_del_virtqueue(struct virtqueue *_vq)
>  }
>  EXPORT_SYMBOL_GPL(vring_del_virtqueue);
>  
> +u32 vring_notification_data(struct virtqueue *_vq)
> +{
> +	struct vring_virtqueue *vq = to_vvq(_vq);
> +	u16 next;
> +
> +	if (vq->packed_ring)
> +		next = (vq->packed.next_avail_idx & ~(1 << 15)) |
> +			vq->packed.avail_wrap_counter << 15;
> +	else
> +		next = vq->split.avail_idx_shadow;
> +
> +	return next << 16 | _vq->index;
> +}
> +EXPORT_SYMBOL_GPL(vring_notification_data);
> +
>  /* Manipulates transport-specific feature bits. */
>  void vring_transport_features(struct virtio_device *vdev)
>  {
> @@ -2771,6 +2786,8 @@ void vring_transport_features(struct virtio_device *vdev)
>  			break;
>  		case VIRTIO_F_ORDER_PLATFORM:
>  			break;
> +		case VIRTIO_F_NOTIFICATION_DATA:
> +			break;
>  		default:
>  			/* We don't understand this bit. */
>  			__virtio_clear_bit(vdev, i);
> diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
> index 8b95b69ef694..2550c9170f4f 100644
> --- a/include/linux/virtio_ring.h
> +++ b/include/linux/virtio_ring.h
> @@ -117,4 +117,6 @@ void vring_del_virtqueue(struct virtqueue *vq);
>  void vring_transport_features(struct virtio_device *vdev);
>  
>  irqreturn_t vring_interrupt(int irq, void *_vq);
> +
> +u32 vring_notification_data(struct virtqueue *_vq);
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

