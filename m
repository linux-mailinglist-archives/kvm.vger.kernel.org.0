Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCCA6C762A
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 04:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbjCXDKf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 23:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbjCXDKU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 23:10:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119D328E5F
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 20:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679627373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qtI2juFUeoRnDkwFmiyqwzGFUaIQAQe0cDkr2MscuyA=;
        b=Hmc4ttG0x0G/27ep6uiWya7IyZM2M6iZWaYB7ewBLGFh+dFYpXa/VwIAfgSlfti2cThZqS
        igScyRfTwHxCFGtS5leA79/1svta+XGClQOpomwjkycAa/qX1CqLuPhEnxmGgvVeE4Dp4W
        15l+9Tq86imSASjFFUATsYw0/kTcN0o=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-KnBVijNJMy6i8O0h25Iydg-1; Thu, 23 Mar 2023 23:09:31 -0400
X-MC-Unique: KnBVijNJMy6i8O0h25Iydg-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-17a03f26ff8so286593fac.8
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 20:09:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679627371;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qtI2juFUeoRnDkwFmiyqwzGFUaIQAQe0cDkr2MscuyA=;
        b=NszgelghiSiC+WqavgvUgEoWwkPM5mxCSoPaMvWxmRKYHGaMRwUbcAVGEsyM0SMKQ6
         CXnmIHShCJz9XA945tqAJntbAgz5Z5BVMC4aJawRhGBSjzgOfCtYLPO6EnNSUY0CioXW
         vcm4yB9fCp4A+nsGwlozcYVuF0MTe+t+sf+j5bj6+2oJuH8vThbeAPJ+We3RjzMS77Pn
         sCuBbWpKXRPR2/fEbv79n0ssoOJ3N1l+DQXJoxg+pE1+4F/rHk6jspO3rPlJ4DqhJC1x
         u9IzKtoPQ5YhIQ6Y0pQbmAAE8dKjFd9aKgXel+nEipEIqW7OYkQDjPbjhACPxVNP24Y1
         fSzQ==
X-Gm-Message-State: AAQBX9cmcNmqD8ddi222B9QBwwNi4yPgWdOlZktSjqBcefGvfJ63j+ey
        mSIszY3/Sz2/lVmE6uW4csizp7278N7cYY+3fAV+roIZr2Qm6JF7nfBmfPcbvPzgkNiQClXH83Y
        Tn/OfBdFK7P18B4Gq6vkp/NUP0x+B
X-Received: by 2002:a05:6870:10d4:b0:17e:255e:b1 with SMTP id 20-20020a05687010d400b0017e255e00b1mr502510oar.9.1679627370942;
        Thu, 23 Mar 2023 20:09:30 -0700 (PDT)
X-Google-Smtp-Source: AK7set+LnuKvSHKHAHgt2Eh7blZvjlwMurDf3B/v6VZFRw2wkwwsN54YFbLfhB516kRTf46wDFjWbQjLS5ngm+tAKvs=
X-Received: by 2002:a05:6870:10d4:b0:17e:255e:b1 with SMTP id
 20-20020a05687010d400b0017e255e00b1mr502500oar.9.1679627370630; Thu, 23 Mar
 2023 20:09:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230323085551.2346411-1-viktor@daynix.com>
In-Reply-To: <20230323085551.2346411-1-viktor@daynix.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 24 Mar 2023 11:09:19 +0800
Message-ID: <CACGkMEsTpdES6Gzsx7eobJsac8a1V0dqfRm3vExrd1e+TJ_bVg@mail.gmail.com>
Subject: Re: [PATCH v5] virtio: add VIRTIO_F_NOTIFICATION_DATA feature support
To:     Viktor Prutyanov <viktor@daynix.com>
Cc:     mst@redhat.com, cohuck@redhat.com, pasic@linux.ibm.com,
        farman@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, yan@daynix.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 23, 2023 at 4:56=E2=80=AFPM Viktor Prutyanov <viktor@daynix.com=
> wrote:
>
> According to VirtIO spec v1.2, VIRTIO_F_NOTIFICATION_DATA feature
> indicates that the driver passes extra data along with the queue
> notifications.
>
> In a split queue case, the extra data is 16-bit available index. In a
> packed queue case, the extra data is 1-bit wrap counter and 15-bit
> available index.
>
> Add support for this feature for MMIO, channel I/O and modern PCI
> transports.
>
> Signed-off-by: Viktor Prutyanov <viktor@daynix.com>
> ---
>  v5: replace ternary operator with if-else
>  v4: remove VP_NOTIFY macro and legacy PCI support, add
>     virtio_ccw_kvm_notify_with_data to virtio_ccw
>  v3: support feature in virtio_ccw, remove VM_NOTIFY, use avail_idx_shado=
w,
>     remove byte swap, rename to vring_notification_data
>  v2: reject the feature in virtio_ccw, replace __le32 with u32
>
>  Tested with disabled VIRTIO_F_NOTIFICATION_DATA on qemu-system-s390x
>  (virtio-blk-ccw), qemu-system-riscv64 (virtio-blk-device,
>  virtio-rng-device), qemu-system-x86_64 (virtio-blk-pci, virtio-net-pci)
>  to make sure nothing is broken.
>  Tested with enabled VIRTIO_F_NOTIFICATION_DATA on 64-bit RISC-V Linux
>  and my hardware implementation of virtio-rng with MMIO.
>
>  drivers/s390/virtio/virtio_ccw.c   | 22 +++++++++++++++++++---
>  drivers/virtio/virtio_mmio.c       | 18 +++++++++++++++++-
>  drivers/virtio/virtio_pci_modern.c | 17 ++++++++++++++++-
>  drivers/virtio/virtio_ring.c       | 17 +++++++++++++++++
>  include/linux/virtio_ring.h        |  2 ++
>  include/uapi/linux/virtio_config.h |  6 ++++++
>  6 files changed, 77 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virti=
o_ccw.c
> index 954fc31b4bc7..9a9c5d34454c 100644
> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -391,7 +391,7 @@ static void virtio_ccw_drop_indicator(struct virtio_c=
cw_device *vcdev,
>         ccw_device_dma_free(vcdev->cdev, thinint_area, sizeof(*thinint_ar=
ea));
>  }
>
> -static bool virtio_ccw_kvm_notify(struct virtqueue *vq)
> +static inline bool virtio_ccw_do_kvm_notify(struct virtqueue *vq, u32 da=
ta)
>  {
>         struct virtio_ccw_vq_info *info =3D vq->priv;
>         struct virtio_ccw_device *vcdev;
> @@ -402,12 +402,22 @@ static bool virtio_ccw_kvm_notify(struct virtqueue =
*vq)
>         BUILD_BUG_ON(sizeof(struct subchannel_id) !=3D sizeof(unsigned in=
t));
>         info->cookie =3D kvm_hypercall3(KVM_S390_VIRTIO_CCW_NOTIFY,
>                                       *((unsigned int *)&schid),
> -                                     vq->index, info->cookie);
> +                                     data, info->cookie);
>         if (info->cookie < 0)
>                 return false;
>         return true;
>  }
>
> +static bool virtio_ccw_kvm_notify(struct virtqueue *vq)
> +{
> +       return virtio_ccw_do_kvm_notify(vq, vq->index);
> +}
> +
> +static bool virtio_ccw_kvm_notify_with_data(struct virtqueue *vq)
> +{
> +       return virtio_ccw_do_kvm_notify(vq, vring_notification_data(vq));
> +}
> +
>  static int virtio_ccw_read_vq_conf(struct virtio_ccw_device *vcdev,
>                                    struct ccw1 *ccw, int index)
>  {
> @@ -501,6 +511,12 @@ static struct virtqueue *virtio_ccw_setup_vq(struct =
virtio_device *vdev,
>         u64 queue;
>         unsigned long flags;
>         bool may_reduce;
> +       bool (*notify)(struct virtqueue *vq);
> +
> +       if (__virtio_test_bit(vdev, VIRTIO_F_NOTIFICATION_DATA))
> +               notify =3D virtio_ccw_kvm_notify_with_data;
> +       else
> +               notify =3D virtio_ccw_kvm_notify;
>
>         /* Allocate queue. */
>         info =3D kzalloc(sizeof(struct virtio_ccw_vq_info), GFP_KERNEL);
> @@ -524,7 +540,7 @@ static struct virtqueue *virtio_ccw_setup_vq(struct v=
irtio_device *vdev,
>         may_reduce =3D vcdev->revision > 0;
>         vq =3D vring_create_virtqueue(i, info->num, KVM_VIRTIO_CCW_RING_A=
LIGN,
>                                     vdev, true, may_reduce, ctx,
> -                                   virtio_ccw_kvm_notify, callback, name=
);
> +                                   notify, callback, name);
>
>         if (!vq) {
>                 /* For now, we fail if we can't get the requested size. *=
/
> diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> index 3ff746e3f24a..7e87f745f68d 100644
> --- a/drivers/virtio/virtio_mmio.c
> +++ b/drivers/virtio/virtio_mmio.c
> @@ -285,6 +285,16 @@ static bool vm_notify(struct virtqueue *vq)
>         return true;
>  }
>
> +static bool vm_notify_with_data(struct virtqueue *vq)
> +{
> +       struct virtio_mmio_device *vm_dev =3D to_virtio_mmio_device(vq->v=
dev);
> +       u32 data =3D vring_notification_data(vq);
> +
> +       writel(data, vm_dev->base + VIRTIO_MMIO_QUEUE_NOTIFY);
> +
> +       return true;
> +}
> +
>  /* Notify all virtqueues on an interrupt. */
>  static irqreturn_t vm_interrupt(int irq, void *opaque)
>  {
> @@ -368,6 +378,12 @@ static struct virtqueue *vm_setup_vq(struct virtio_d=
evice *vdev, unsigned int in
>         unsigned long flags;
>         unsigned int num;
>         int err;
> +       bool (*notify)(struct virtqueue *vq);
> +
> +       if (__virtio_test_bit(vdev, VIRTIO_F_NOTIFICATION_DATA))
> +               notify =3D vm_notify_with_data;
> +       else
> +               notify =3D vm_notify;
>
>         if (!name)
>                 return NULL;
> @@ -397,7 +413,7 @@ static struct virtqueue *vm_setup_vq(struct virtio_de=
vice *vdev, unsigned int in
>
>         /* Create the vring */
>         vq =3D vring_create_virtqueue(index, num, VIRTIO_MMIO_VRING_ALIGN=
, vdev,
> -                                true, true, ctx, vm_notify, callback, na=
me);
> +                                true, true, ctx, notify, callback, name)=
;
>         if (!vq) {
>                 err =3D -ENOMEM;
>                 goto error_new_virtqueue;
> diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_p=
ci_modern.c
> index 9e496e288cfa..3bfc368b279e 100644
> --- a/drivers/virtio/virtio_pci_modern.c
> +++ b/drivers/virtio/virtio_pci_modern.c
> @@ -288,6 +288,15 @@ static u16 vp_config_vector(struct virtio_pci_device=
 *vp_dev, u16 vector)
>         return vp_modern_config_vector(&vp_dev->mdev, vector);
>  }
>
> +static bool vp_notify_with_data(struct virtqueue *vq)
> +{
> +       u32 data =3D vring_notification_data(vq);
> +
> +       iowrite32(data, (void __iomem *)vq->priv);
> +
> +       return true;
> +}
> +
>  static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
>                                   struct virtio_pci_vq_info *info,
>                                   unsigned int index,
> @@ -301,6 +310,12 @@ static struct virtqueue *setup_vq(struct virtio_pci_=
device *vp_dev,
>         struct virtqueue *vq;
>         u16 num;
>         int err;
> +       bool (*notify)(struct virtqueue *vq);
> +
> +       if (__virtio_test_bit(&vp_dev->vdev, VIRTIO_F_NOTIFICATION_DATA))
> +               notify =3D vp_notify_with_data;
> +       else
> +               notify =3D vp_notify;
>
>         if (index >=3D vp_modern_get_num_queues(mdev))
>                 return ERR_PTR(-EINVAL);
> @@ -321,7 +336,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_d=
evice *vp_dev,
>         vq =3D vring_create_virtqueue(index, num,
>                                     SMP_CACHE_BYTES, &vp_dev->vdev,
>                                     true, true, ctx,
> -                                   vp_notify, callback, name);
> +                                   notify, callback, name);
>         if (!vq)
>                 return ERR_PTR(-ENOMEM);
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
> +       struct vring_virtqueue *vq =3D to_vvq(_vq);
> +       u16 next;
> +
> +       if (vq->packed_ring)
> +               next =3D (vq->packed.next_avail_idx & ~(1 << 15)) |
> +                       vq->packed.avail_wrap_counter << 15;

Nit: We have VRING_PACKED_EVENT_F_WRAP_CTR which could be used for
replacing 15 here.

And we have many places for packing them into u16, it might be better
to introduce a helper.

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> +       else
> +               next =3D vq->split.avail_idx_shadow;
> +
> +       return next << 16 | _vq->index;
> +}
> +EXPORT_SYMBOL_GPL(vring_notification_data);
> +
>  /* Manipulates transport-specific feature bits. */
>  void vring_transport_features(struct virtio_device *vdev)
>  {
> @@ -2771,6 +2786,8 @@ void vring_transport_features(struct virtio_device =
*vdev)
>                         break;
>                 case VIRTIO_F_ORDER_PLATFORM:
>                         break;
> +               case VIRTIO_F_NOTIFICATION_DATA:
> +                       break;
>                 default:
>                         /* We don't understand this bit. */
>                         __virtio_clear_bit(vdev, i);
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
> diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virt=
io_config.h
> index 3c05162bc988..2c712c654165 100644
> --- a/include/uapi/linux/virtio_config.h
> +++ b/include/uapi/linux/virtio_config.h
> @@ -99,6 +99,12 @@
>   */
>  #define VIRTIO_F_SR_IOV                        37
>
> +/*
> + * This feature indicates that the driver passes extra data (besides
> + * identifying the virtqueue) in its device notifications.
> + */
> +#define VIRTIO_F_NOTIFICATION_DATA     38
> +
>  /*
>   * This feature indicates that the driver can reset a queue individually=
.
>   */
> --
> 2.35.1
>

