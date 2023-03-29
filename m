Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13C196CF697
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 00:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjC2Wtj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 18:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbjC2Wti (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 18:49:38 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7931995
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 15:49:36 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id c9so11783210lfb.1
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 15:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112; t=1680130174;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J06uBsi/+Fvfc7uTUxZGZgiPQUb5pmFJ33RlLVNqpts=;
        b=u0UqyaoZzvEJcp7Pg19FlcE3UzcvMfUs93zSs3jZYvTcpVauR6liOQyUqEWBU64DHb
         7ygwwX3Jt14Q17QSeQiaZoHjXKS4SplTSFs05a93bYZ/0DKBkC3t1T5U4P8EHCZM9Qng
         hqTnTubyA01CWqwhGZgXtpPS1/GjPUR03ZQKCnikSX1/JYoBiUqdfsjpjxBQ+3tStp/s
         eqRyZOnZ6rjfghfwvgKUJelajOvAstngbYIMTrSh9/Q+77hWvt6Tjzq7B/Nd36M33ocn
         Aiheid07rjXc5zl+S7EiZ0jQdmay316aqRbf5yPg98tT52CFruCG8gFl7SvewT7m2LWf
         Swgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680130174;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J06uBsi/+Fvfc7uTUxZGZgiPQUb5pmFJ33RlLVNqpts=;
        b=yjXg3q0MuwJtC6qiWmVV4YPuIfSYIFrhNvJjllZzYNGwmZw7isFEBtHQGhrLbTsGuL
         86Xic27roL8sDbSuDDGpKl7fUy3XVLq1auVyl+mMUyUciToaeTuDbvRfQvP1oPRsMYeZ
         y/S93/3HrWCtz9rq6jcYhAou+/Q2mRQ8LwCo2AfBXXk+KBDt5ZTcoEdvBVupgtI9vrIg
         vxs81ppidbHclSn91aZg1y8UwPQFuQoAh3KBiEJ12UTb/aYA5C14/YwgPk9KumiYUVYR
         DD+9oMxTjUmy5VlpHGDgjzxyIhP3PsKrIfDwbNcy72UkKwtmLp+BpKurTYr6cx8hohmX
         d2Ew==
X-Gm-Message-State: AAQBX9exefMA9inFVnaFkGSEe1DgnYSllyDMAr/8vmRCSrTjVmhqN0pT
        +7SSM5sBh0m2KgWBtEVVqVx+1Plj4j1myUv2xoFglg==
X-Google-Smtp-Source: AKy350Y2/4FKrRZGJa8ucFdhyGUZzXRFKHzqPr7E8OvxIVcnDHIqAEIGAT8hKUJqTVnF8sjVIhNB1uDJNh24LU8FlQE=
X-Received: by 2002:ac2:4844:0:b0:4db:1ae1:318b with SMTP id
 4-20020ac24844000000b004db1ae1318bmr6192153lfy.5.1680130174245; Wed, 29 Mar
 2023 15:49:34 -0700 (PDT)
MIME-Version: 1.0
References: <20230324195029.2410503-1-viktor@daynix.com>
In-Reply-To: <20230324195029.2410503-1-viktor@daynix.com>
From:   Viktor Prutyanov <viktor@daynix.com>
Date:   Thu, 30 Mar 2023 01:49:23 +0300
Message-ID: <CAPv0NP7e95ZYk1-XdQitGwiqRNUQFx=a_2s7ivD4y-PzGRdhsw@mail.gmail.com>
Subject: Re: [PATCH v6] virtio: add VIRTIO_F_NOTIFICATION_DATA feature support
To:     mst@redhat.com, jasowang@redhat.com
Cc:     cohuck@redhat.com, pasic@linux.ibm.com, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, yan@daynix.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 24, 2023 at 10:50=E2=80=AFPM Viktor Prutyanov <viktor@daynix.co=
m> wrote:
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
> Acked-by: Jason Wang <jasowang@redhat.com>
> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  v6: use VRING_PACKED_EVENT_F_WRAP_CTR
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
>  drivers/virtio/virtio_ring.c       | 19 +++++++++++++++++++
>  include/linux/virtio_ring.h        |  2 ++
>  include/uapi/linux/virtio_config.h |  6 ++++++
>  6 files changed, 79 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virti=
o_ccw.c
> index 954fc31b4bc7..02922768b129 100644
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
> @@ -495,6 +505,7 @@ static struct virtqueue *virtio_ccw_setup_vq(struct v=
irtio_device *vdev,
>                                              struct ccw1 *ccw)
>  {
>         struct virtio_ccw_device *vcdev =3D to_vc_device(vdev);
> +       bool (*notify)(struct virtqueue *vq);
>         int err;
>         struct virtqueue *vq =3D NULL;
>         struct virtio_ccw_vq_info *info;
> @@ -502,6 +513,11 @@ static struct virtqueue *virtio_ccw_setup_vq(struct =
virtio_device *vdev,
>         unsigned long flags;
>         bool may_reduce;
>
> +       if (__virtio_test_bit(vdev, VIRTIO_F_NOTIFICATION_DATA))
> +               notify =3D virtio_ccw_kvm_notify_with_data;
> +       else
> +               notify =3D virtio_ccw_kvm_notify;
> +
>         /* Allocate queue. */
>         info =3D kzalloc(sizeof(struct virtio_ccw_vq_info), GFP_KERNEL);
>         if (!info) {
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
> index 3ff746e3f24a..dd4424c14233 100644
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
> @@ -363,12 +373,18 @@ static struct virtqueue *vm_setup_vq(struct virtio_=
device *vdev, unsigned int in
>                                   const char *name, bool ctx)
>  {
>         struct virtio_mmio_device *vm_dev =3D to_virtio_mmio_device(vdev)=
;
> +       bool (*notify)(struct virtqueue *vq);
>         struct virtio_mmio_vq_info *info;
>         struct virtqueue *vq;
>         unsigned long flags;
>         unsigned int num;
>         int err;
>
> +       if (__virtio_test_bit(vdev, VIRTIO_F_NOTIFICATION_DATA))
> +               notify =3D vm_notify_with_data;
> +       else
> +               notify =3D vm_notify;
> +
>         if (!name)
>                 return NULL;
>
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
> index 9e496e288cfa..05deba5153bd 100644
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
> @@ -298,10 +307,16 @@ static struct virtqueue *setup_vq(struct virtio_pci=
_device *vp_dev,
>  {
>
>         struct virtio_pci_modern_device *mdev =3D &vp_dev->mdev;
> +       bool (*notify)(struct virtqueue *vq);
>         struct virtqueue *vq;
>         u16 num;
>         int err;
>
> +       if (__virtio_test_bit(&vp_dev->vdev, VIRTIO_F_NOTIFICATION_DATA))
> +               notify =3D vp_notify_with_data;
> +       else
> +               notify =3D vp_notify;
> +
>         if (index >=3D vp_modern_get_num_queues(mdev))
>                 return ERR_PTR(-EINVAL);
>
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
> index 4c3bb0ddeb9b..f9c6604352b4 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -2752,6 +2752,23 @@ void vring_del_virtqueue(struct virtqueue *_vq)
>  }
>  EXPORT_SYMBOL_GPL(vring_del_virtqueue);
>
> +u32 vring_notification_data(struct virtqueue *_vq)
> +{
> +       struct vring_virtqueue *vq =3D to_vvq(_vq);
> +       u16 next;
> +
> +       if (vq->packed_ring)
> +               next =3D (vq->packed.next_avail_idx &
> +                               ~(-(1 << VRING_PACKED_EVENT_F_WRAP_CTR)))=
 |
> +                       vq->packed.avail_wrap_counter <<
> +                               VRING_PACKED_EVENT_F_WRAP_CTR;
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
> @@ -2771,6 +2788,8 @@ void vring_transport_features(struct virtio_device =
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

ping
