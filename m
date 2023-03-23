Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE67A6C6088
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 08:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbjCWHTg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 03:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbjCWHTL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 03:19:11 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE8025959
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 00:19:09 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id i13so10819828lfe.9
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 00:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112; t=1679555947;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ughe32gdwO8QA3jLlHEipYlezC7QccZnUu3C2UjJnik=;
        b=4OCO/8izV4KFj+PR7dqsIJjh8hAfhPbhMScOgB1NRV+FvjoNKvs4Mnwd011vw5zkhG
         X4S5GHblf7lBvYsSBmmDV+n9iL+PftWkH4hzTty0hMNVjbhiRx+5LOl9+MyWFfyYFHiL
         RSaODTA3WHz1I4E0ZFTAk++JdBBmwu9ZALFKdifp1tcgSjfJzRjxRJQOR0cAdso7E7lI
         Y0zYS6y3yqyti5tlfFJUVPsqCsfWjNzaKeZDsX2ySllFZFFGvdj+AXgL+LT8aOVgvphr
         tBaqxneNcjmjxhSzNpU+Q4V84/ttPSdMYJuzQlw39og1PLyyV2QEm3/PSWgRhiXGzDj5
         8bww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679555947;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ughe32gdwO8QA3jLlHEipYlezC7QccZnUu3C2UjJnik=;
        b=mXLe0u2Z/8UfjptKw3I4zboKw7AL7xRx9hFqMjS1Sj/o6+hcqduIPYW1tYwGqLsyx/
         8EEdhFvjLSMeiGnlwelV2lYoBLkrEU9Yn97kZ1TBaEC8Q/uula1Moo0WjiGWUnj860hm
         e6Tj41tiJEcHOfxp98AN91yVgB91bgcInc85amy32oVgTduxtaYi17BYfGFiP5+LoGBs
         YZEkOyhuU+lqP5l50NFG8spS63yiGENWA7wpaF6Bhwy710t1FbtdB5rhW8otZ7SgzEuH
         +DaaZjp+c89OiJMhWUVZYVHHcowqS7s5FMZd7/GGM7NP4uBhsvHNqXuwbz/ckT6obt19
         uraA==
X-Gm-Message-State: AO0yUKXUHmF/IduhMEPN2IuPRbPF9Uxme5tHcjHw/evh9ESzTkchIlDU
        9FTU97o7mRRmb0Ryj1vXoo6PlXO/UGuWnotISoYWGQ==
X-Google-Smtp-Source: AK7set9oftC7UKjRvHCiPemObEjB1PP66y3IfAxsPzCuTpGVzygdio9Wn73lWJdxYZlHqykdH12WveaVJbm4ALh0aFo=
X-Received: by 2002:a19:ee11:0:b0:4e8:569d:9f38 with SMTP id
 g17-20020a19ee11000000b004e8569d9f38mr2686218lfb.5.1679555947241; Thu, 23 Mar
 2023 00:19:07 -0700 (PDT)
MIME-Version: 1.0
References: <20230322141031.2211141-1-viktor@daynix.com> <1679534465.5760474-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1679534465.5760474-1-xuanzhuo@linux.alibaba.com>
From:   Viktor Prutyanov <viktor@daynix.com>
Date:   Thu, 23 Mar 2023 10:18:56 +0300
Message-ID: <CAPv0NP5gusfkyvX4qhMMiXsTZpckammmc5R7M=e9USi3C=1QAQ@mail.gmail.com>
Subject: Re: [PATCH v4] virtio: add VIRTIO_F_NOTIFICATION_DATA feature support
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     cohuck@redhat.com, pasic@linux.ibm.com, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, yan@daynix.com, mst@redhat.com,
        jasowang@redhat.com
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

On Thu, Mar 23, 2023 at 4:22=E2=80=AFAM Xuan Zhuo <xuanzhuo@linux.alibaba.c=
om> wrote:
>
> On Wed, 22 Mar 2023 17:10:31 +0300, Viktor Prutyanov <viktor@daynix.com> =
wrote:
> > According to VirtIO spec v1.2, VIRTIO_F_NOTIFICATION_DATA feature
> > indicates that the driver passes extra data along with the queue
> > notifications.
> >
> > In a split queue case, the extra data is 16-bit available index. In a
> > packed queue case, the extra data is 1-bit wrap counter and 15-bit
> > available index.
> >
> > Add support for this feature for MMIO, channel I/O and modern PCI
> > transports.
> >
> > Signed-off-by: Viktor Prutyanov <viktor@daynix.com>
> > ---
> >  v4: remove VP_NOTIFY macro and legacy PCI support, add
> >     virtio_ccw_kvm_notify_with_data to virtio_ccw
> >  v3: support feature in virtio_ccw, remove VM_NOTIFY, use avail_idx_sha=
dow,
> >     remove byte swap, rename to vring_notification_data
> >  v2: reject the feature in virtio_ccw, replace __le32 with u32
> >
> >  Tested with disabled VIRTIO_F_NOTIFICATION_DATA on qemu-system-s390x
> >  (virtio-blk-ccw), qemu-system-riscv64 (virtio-blk-device,
> >  virtio-rng-device), qemu-system-x86_64 (virtio-blk-pci, virtio-net-pci=
)
> >  to make sure nothing is broken.
> >  Tested with enabled VIRTIO_F_NOTIFICATION_DATA on 64-bit RISC-V Linux
> >  and my hardware implementation of virtio-rng.
> >
> >  drivers/s390/virtio/virtio_ccw.c   | 19 ++++++++++++++++---
> >  drivers/virtio/virtio_mmio.c       | 14 +++++++++++++-
> >  drivers/virtio/virtio_pci_modern.c | 13 ++++++++++++-
> >  drivers/virtio/virtio_ring.c       | 17 +++++++++++++++++
> >  include/linux/virtio_ring.h        |  2 ++
> >  include/uapi/linux/virtio_config.h |  6 ++++++
> >  6 files changed, 66 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/vir=
tio_ccw.c
> > index 954fc31b4bc7..3619676effb8 100644
> > --- a/drivers/s390/virtio/virtio_ccw.c
> > +++ b/drivers/s390/virtio/virtio_ccw.c
> > @@ -391,7 +391,7 @@ static void virtio_ccw_drop_indicator(struct virtio=
_ccw_device *vcdev,
> >       ccw_device_dma_free(vcdev->cdev, thinint_area, sizeof(*thinint_ar=
ea));
> >  }
> >
> > -static bool virtio_ccw_kvm_notify(struct virtqueue *vq)
> > +static inline bool virtio_ccw_do_kvm_notify(struct virtqueue *vq, u32 =
data)
> >  {
> >       struct virtio_ccw_vq_info *info =3D vq->priv;
> >       struct virtio_ccw_device *vcdev;
> > @@ -402,12 +402,22 @@ static bool virtio_ccw_kvm_notify(struct virtqueu=
e *vq)
> >       BUILD_BUG_ON(sizeof(struct subchannel_id) !=3D sizeof(unsigned in=
t));
> >       info->cookie =3D kvm_hypercall3(KVM_S390_VIRTIO_CCW_NOTIFY,
> >                                     *((unsigned int *)&schid),
> > -                                   vq->index, info->cookie);
> > +                                   data, info->cookie);
> >       if (info->cookie < 0)
> >               return false;
> >       return true;
> >  }
> >
> > +static bool virtio_ccw_kvm_notify(struct virtqueue *vq)
> > +{
> > +     return virtio_ccw_do_kvm_notify(vq, vq->index);
> > +}
> > +
> > +static bool virtio_ccw_kvm_notify_with_data(struct virtqueue *vq)
> > +{
> > +     return virtio_ccw_do_kvm_notify(vq, vring_notification_data(vq));
> > +}
> > +
> >  static int virtio_ccw_read_vq_conf(struct virtio_ccw_device *vcdev,
> >                                  struct ccw1 *ccw, int index)
> >  {
> > @@ -501,6 +511,9 @@ static struct virtqueue *virtio_ccw_setup_vq(struct=
 virtio_device *vdev,
> >       u64 queue;
> >       unsigned long flags;
> >       bool may_reduce;
> > +     bool (*notify)(struct virtqueue *vq) =3D __virtio_test_bit(vdev,
> > +             VIRTIO_F_NOTIFICATION_DATA) ?
> > +             virtio_ccw_kvm_notify_with_data : virtio_ccw_kvm_notify;
> >
> >       /* Allocate queue. */
> >       info =3D kzalloc(sizeof(struct virtio_ccw_vq_info), GFP_KERNEL);
> > @@ -524,7 +537,7 @@ static struct virtqueue *virtio_ccw_setup_vq(struct=
 virtio_device *vdev,
> >       may_reduce =3D vcdev->revision > 0;
> >       vq =3D vring_create_virtqueue(i, info->num, KVM_VIRTIO_CCW_RING_A=
LIGN,
> >                                   vdev, true, may_reduce, ctx,
> > -                                 virtio_ccw_kvm_notify, callback, name=
);
> > +                                 notify, callback, name);
> >
> >       if (!vq) {
> >               /* For now, we fail if we can't get the requested size. *=
/
> > diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.=
c
> > index 3ff746e3f24a..7c16e622c33d 100644
> > --- a/drivers/virtio/virtio_mmio.c
> > +++ b/drivers/virtio/virtio_mmio.cv
> > @@ -285,6 +285,16 @@ static bool vm_notify(struct virtqueue *vq)
> >       return true;
> >  }
> >
> > +static bool vm_notify_with_data(struct virtqueue *vq)
> > +{
> > +     struct virtio_mmio_device *vm_dev =3D to_virtio_mmio_device(vq->v=
dev);
> > +     u32 data =3D vring_notification_data(vq);
> > +
> > +     writel(data, vm_dev->base + VIRTIO_MMIO_QUEUE_NOTIFY);
> > +
> > +     return true;
> > +}
> > +
> >  /* Notify all virtqueues on an interrupt. */
> >  static irqreturn_t vm_interrupt(int irq, void *opaque)
> >  {
> > @@ -368,6 +378,8 @@ static struct virtqueue *vm_setup_vq(struct virtio_=
device *vdev, unsigned int in
> >       unsigned long flags;
> >       unsigned int num;
> >       int err;
> > +     bool (*notify)(struct virtqueue *vq) =3D __virtio_test_bit(vdev,
> > +             VIRTIO_F_NOTIFICATION_DATA) ? vm_notify_with_data : vm_no=
tify;
>
>
> Can we optimize this line?

What kind of optimization do you mean?

>
> Thanks.
>
> >
> >       if (!name)
> >               return NULL;
> > @@ -397,7 +409,7 @@ static struct virtqueue *vm_setup_vq(struct virtio_=
device *vdev, unsigned int in
> >
> >       /* Create the vring */
> >       vq =3D vring_create_virtqueue(index, num, VIRTIO_MMIO_VRING_ALIGN=
, vdev,
> > -                              true, true, ctx, vm_notify, callback, na=
me);
> > +                              true, true, ctx, notify, callback, name)=
;
> >       if (!vq) {
> >               err =3D -ENOMEM;
> >               goto error_new_virtqueue;
> > diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio=
_pci_modern.c
> > index 9e496e288cfa..9cc56f463dba 100644
> > --- a/drivers/virtio/virtio_pci_modern.c
> > +++ b/drivers/virtio/virtio_pci_modern.c
> > @@ -288,6 +288,15 @@ static u16 vp_config_vector(struct virtio_pci_devi=
ce *vp_dev, u16 vector)
> >       return vp_modern_config_vector(&vp_dev->mdev, vector);
> >  }
> >
> > +static bool vp_notify_with_data(struct virtqueue *vq)
> > +{
> > +     u32 data =3D vring_notification_data(vq);
> > +
> > +     iowrite32(data, (void __iomem *)vq->priv);
> > +
> > +     return true;
> > +}
> > +
> >  static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
> >                                 struct virtio_pci_vq_info *info,
> >                                 unsigned int index,
> > @@ -301,6 +310,8 @@ static struct virtqueue *setup_vq(struct virtio_pci=
_device *vp_dev,
> >       struct virtqueue *vq;
> >       u16 num;
> >       int err;
> > +     bool (*notify)(struct virtqueue *vq) =3D __virtio_test_bit(&vp_de=
v->vdev,
> > +             VIRTIO_F_NOTIFICATION_DATA) ? vp_notify_with_data : vp_no=
tify;
> >
> >       if (index >=3D vp_modern_get_num_queues(mdev))
> >               return ERR_PTR(-EINVAL);
> > @@ -321,7 +332,7 @@ static struct virtqueue *setup_vq(struct virtio_pci=
_device *vp_dev,
> >       vq =3D vring_create_virtqueue(index, num,
> >                                   SMP_CACHE_BYTES, &vp_dev->vdev,
> >                                   true, true, ctx,
> > -                                 vp_notify, callback, name);
> > +                                 notify, callback, name);
> >       if (!vq)
> >               return ERR_PTR(-ENOMEM);
> >
> > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.=
c
> > index 4c3bb0ddeb9b..837875cc3190 100644
> > --- a/drivers/virtio/virtio_ring.c
> > +++ b/drivers/virtio/virtio_ring.c
> > @@ -2752,6 +2752,21 @@ void vring_del_virtqueue(struct virtqueue *_vq)
> >  }
> >  EXPORT_SYMBOL_GPL(vring_del_virtqueue);
> >
> > +u32 vring_notification_data(struct virtqueue *_vq)
> > +{
> > +     struct vring_virtqueue *vq =3D to_vvq(_vq);
> > +     u16 next;
> > +
> > +     if (vq->packed_ring)
> > +             next =3D (vq->packed.next_avail_idx & ~(1 << 15)) |
> > +                     vq->packed.avail_wrap_counter << 15;
> > +     else
> > +             next =3D vq->split.avail_idx_shadow;
> > +
> > +     return next << 16 | _vq->index;
> > +}
> > +EXPORT_SYMBOL_GPL(vring_notification_data);
> > +
> >  /* Manipulates transport-specific feature bits. */
> >  void vring_transport_features(struct virtio_device *vdev)
> >  {
> > @@ -2771,6 +2786,8 @@ void vring_transport_features(struct virtio_devic=
e *vdev)
> >                       break;
> >               case VIRTIO_F_ORDER_PLATFORM:
> >                       break;
> > +             case VIRTIO_F_NOTIFICATION_DATA:
> > +                     break;
> >               default:
> >                       /* We don't understand this bit. */
> >                       __virtio_clear_bit(vdev, i);
> > diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
> > index 8b95b69ef694..2550c9170f4f 100644
> > --- a/include/linux/virtio_ring.h
> > +++ b/include/linux/virtio_ring.h
> > @@ -117,4 +117,6 @@ void vring_del_virtqueue(struct virtqueue *vq);
> >  void vring_transport_features(struct virtio_device *vdev);
> >
> >  irqreturn_t vring_interrupt(int irq, void *_vq);
> > +
> > +u32 vring_notification_data(struct virtqueue *_vq);
> >  #endif /* _LINUX_VIRTIO_RING_H */
> > diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/vi=
rtio_config.h
> > index 3c05162bc988..2c712c654165 100644
> > --- a/include/uapi/linux/virtio_config.h
> > +++ b/include/uapi/linux/virtio_config.h
> > @@ -99,6 +99,12 @@
> >   */
> >  #define VIRTIO_F_SR_IOV                      37
> >
> > +/*
> > + * This feature indicates that the driver passes extra data (besides
> > + * identifying the virtqueue) in its device notifications.
> > + */
> > +#define VIRTIO_F_NOTIFICATION_DATA   38
> > +
> >  /*
> >   * This feature indicates that the driver can reset a queue individual=
ly.
> >   */
> > --
> > 2.35.1
> >
