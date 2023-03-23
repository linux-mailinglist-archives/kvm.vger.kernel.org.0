Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3D7E6C60A7
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 08:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjCWH00 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 03:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjCWH0Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 03:26:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE516166CF
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 00:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679556333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nVOJSpn17UvgMudR5BrB/uuZq4hiFxne2pnpscCg0V0=;
        b=JnIXcnk/hmKmfqjP2Jgv8WNBn8+v75P2lHBuOcO9cLt5iRlyPhKLn2n/Q2lYm3epdaKiqw
        F5SPebtO8//sjYfyPon6hasdsRfmkRhcCuFuKXw4OQeI5fTEx3gpyClKk7//Zkltk/g3Gp
        JWwc/Vwqt4f2UJW/ubzSunNvMW+0ZBE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-361-X15Rj0_vOca9paTkitcJZw-1; Thu, 23 Mar 2023 03:25:31 -0400
X-MC-Unique: X15Rj0_vOca9paTkitcJZw-1
Received: by mail-ed1-f72.google.com with SMTP id j21-20020a508a95000000b004fd82403c91so30581099edj.3
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 00:25:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679556330;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nVOJSpn17UvgMudR5BrB/uuZq4hiFxne2pnpscCg0V0=;
        b=sjE8D6oT/E6NfWJQx1cYwnky7ibKdiEqomrXhb7fsAfmN2MgJd7Ghaxk1Zbk6euWQA
         P5aIcL+GLPpzgNKe+4OjXUzWzX1n/pmzWepSAiJjrc2J4tsiJK+mSk+e4HIHfz2MDg77
         0LYnuK57SBlPZtqF/XinSYIF8iGF+AJjfe21V8MQqeRM8+JD6cL8qxDdgTbOCXNOh0B/
         Yl8L24s9uZsv9qCEW1qUDot8rocvJ+OnjYhGcoXp7y0t8mn/X8TYwHAtC+xp+dOY1YNv
         KJySPn1eQsecK/Qhm88ukJ34Jo4TVG+Jh8h00XEudq/fqF1CuExmHeILSQBZcdWtFaer
         QSiw==
X-Gm-Message-State: AO0yUKXcvJ+nLbTubasGXu5RkpV7iMwfy23A0HTKee/ByJnOvRiFkOUb
        ELOT44G9k0rCN43kw04ogvSvnAoQmRAiLqmaDMdU8+JlmeHkUlBOX/RMQaJfWurlbl2LT5M0Vhz
        l0L776+DSh4pZ
X-Received: by 2002:a17:906:1152:b0:930:c417:1ad2 with SMTP id i18-20020a170906115200b00930c4171ad2mr9659869eja.65.1679556330081;
        Thu, 23 Mar 2023 00:25:30 -0700 (PDT)
X-Google-Smtp-Source: AK7set8F9TR9wFkxKVmR5afLynPHNakPSfT26bokDRl8iVvvmwfFT5ib9PnJYZcLCkQxtkUgMKlnpQ==
X-Received: by 2002:a17:906:1152:b0:930:c417:1ad2 with SMTP id i18-20020a170906115200b00930c4171ad2mr9659851eja.65.1679556329755;
        Thu, 23 Mar 2023 00:25:29 -0700 (PDT)
Received: from redhat.com ([2.52.143.71])
        by smtp.gmail.com with ESMTPSA id a16-20020a170906245000b0093a6e9c2634sm2846119ejb.192.2023.03.23.00.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 00:25:29 -0700 (PDT)
Date:   Thu, 23 Mar 2023 03:25:25 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Viktor Prutyanov <viktor@daynix.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, cohuck@redhat.com,
        pasic@linux.ibm.com, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, yan@daynix.com, jasowang@redhat.com
Subject: Re: [PATCH v4] virtio: add VIRTIO_F_NOTIFICATION_DATA feature support
Message-ID: <20230323032320-mutt-send-email-mst@kernel.org>
References: <20230322141031.2211141-1-viktor@daynix.com>
 <1679534465.5760474-1-xuanzhuo@linux.alibaba.com>
 <CAPv0NP5gusfkyvX4qhMMiXsTZpckammmc5R7M=e9USi3C=1QAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPv0NP5gusfkyvX4qhMMiXsTZpckammmc5R7M=e9USi3C=1QAQ@mail.gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 23, 2023 at 10:18:56AM +0300, Viktor Prutyanov wrote:
> On Thu, Mar 23, 2023 at 4:22 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> >
> > On Wed, 22 Mar 2023 17:10:31 +0300, Viktor Prutyanov <viktor@daynix.com> wrote:
> > > According to VirtIO spec v1.2, VIRTIO_F_NOTIFICATION_DATA feature
> > > indicates that the driver passes extra data along with the queue
> > > notifications.
> > >
> > > In a split queue case, the extra data is 16-bit available index. In a
> > > packed queue case, the extra data is 1-bit wrap counter and 15-bit
> > > available index.
> > >
> > > Add support for this feature for MMIO, channel I/O and modern PCI
> > > transports.
> > >
> > > Signed-off-by: Viktor Prutyanov <viktor@daynix.com>
> > > ---
> > >  v4: remove VP_NOTIFY macro and legacy PCI support, add
> > >     virtio_ccw_kvm_notify_with_data to virtio_ccw
> > >  v3: support feature in virtio_ccw, remove VM_NOTIFY, use avail_idx_shadow,
> > >     remove byte swap, rename to vring_notification_data
> > >  v2: reject the feature in virtio_ccw, replace __le32 with u32
> > >
> > >  Tested with disabled VIRTIO_F_NOTIFICATION_DATA on qemu-system-s390x
> > >  (virtio-blk-ccw), qemu-system-riscv64 (virtio-blk-device,
> > >  virtio-rng-device), qemu-system-x86_64 (virtio-blk-pci, virtio-net-pci)
> > >  to make sure nothing is broken.
> > >  Tested with enabled VIRTIO_F_NOTIFICATION_DATA on 64-bit RISC-V Linux
> > >  and my hardware implementation of virtio-rng.
> > >
> > >  drivers/s390/virtio/virtio_ccw.c   | 19 ++++++++++++++++---
> > >  drivers/virtio/virtio_mmio.c       | 14 +++++++++++++-
> > >  drivers/virtio/virtio_pci_modern.c | 13 ++++++++++++-
> > >  drivers/virtio/virtio_ring.c       | 17 +++++++++++++++++
> > >  include/linux/virtio_ring.h        |  2 ++
> > >  include/uapi/linux/virtio_config.h |  6 ++++++
> > >  6 files changed, 66 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> > > index 954fc31b4bc7..3619676effb8 100644
> > > --- a/drivers/s390/virtio/virtio_ccw.c
> > > +++ b/drivers/s390/virtio/virtio_ccw.c
> > > @@ -391,7 +391,7 @@ static void virtio_ccw_drop_indicator(struct virtio_ccw_device *vcdev,
> > >       ccw_device_dma_free(vcdev->cdev, thinint_area, sizeof(*thinint_area));
> > >  }
> > >
> > > -static bool virtio_ccw_kvm_notify(struct virtqueue *vq)
> > > +static inline bool virtio_ccw_do_kvm_notify(struct virtqueue *vq, u32 data)
> > >  {
> > >       struct virtio_ccw_vq_info *info = vq->priv;
> > >       struct virtio_ccw_device *vcdev;
> > > @@ -402,12 +402,22 @@ static bool virtio_ccw_kvm_notify(struct virtqueue *vq)
> > >       BUILD_BUG_ON(sizeof(struct subchannel_id) != sizeof(unsigned int));
> > >       info->cookie = kvm_hypercall3(KVM_S390_VIRTIO_CCW_NOTIFY,
> > >                                     *((unsigned int *)&schid),
> > > -                                   vq->index, info->cookie);
> > > +                                   data, info->cookie);
> > >       if (info->cookie < 0)
> > >               return false;
> > >       return true;
> > >  }
> > >
> > > +static bool virtio_ccw_kvm_notify(struct virtqueue *vq)
> > > +{
> > > +     return virtio_ccw_do_kvm_notify(vq, vq->index);
> > > +}
> > > +
> > > +static bool virtio_ccw_kvm_notify_with_data(struct virtqueue *vq)
> > > +{
> > > +     return virtio_ccw_do_kvm_notify(vq, vring_notification_data(vq));
> > > +}
> > > +
> > >  static int virtio_ccw_read_vq_conf(struct virtio_ccw_device *vcdev,
> > >                                  struct ccw1 *ccw, int index)
> > >  {
> > > @@ -501,6 +511,9 @@ static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
> > >       u64 queue;
> > >       unsigned long flags;
> > >       bool may_reduce;
> > > +     bool (*notify)(struct virtqueue *vq) = __virtio_test_bit(vdev,
> > > +             VIRTIO_F_NOTIFICATION_DATA) ?
> > > +             virtio_ccw_kvm_notify_with_data : virtio_ccw_kvm_notify;
> > >
> > >       /* Allocate queue. */
> > >       info = kzalloc(sizeof(struct virtio_ccw_vq_info), GFP_KERNEL);
> > > @@ -524,7 +537,7 @@ static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
> > >       may_reduce = vcdev->revision > 0;
> > >       vq = vring_create_virtqueue(i, info->num, KVM_VIRTIO_CCW_RING_ALIGN,
> > >                                   vdev, true, may_reduce, ctx,
> > > -                                 virtio_ccw_kvm_notify, callback, name);
> > > +                                 notify, callback, name);
> > >
> > >       if (!vq) {
> > >               /* For now, we fail if we can't get the requested size. */
> > > diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> > > index 3ff746e3f24a..7c16e622c33d 100644
> > > --- a/drivers/virtio/virtio_mmio.c
> > > +++ b/drivers/virtio/virtio_mmio.cv
> > > @@ -285,6 +285,16 @@ static bool vm_notify(struct virtqueue *vq)
> > >       return true;
> > >  }
> > >
> > > +static bool vm_notify_with_data(struct virtqueue *vq)
> > > +{
> > > +     struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vq->vdev);
> > > +     u32 data = vring_notification_data(vq);
> > > +
> > > +     writel(data, vm_dev->base + VIRTIO_MMIO_QUEUE_NOTIFY);
> > > +
> > > +     return true;
> > > +}
> > > +
> > >  /* Notify all virtqueues on an interrupt. */
> > >  static irqreturn_t vm_interrupt(int irq, void *opaque)
> > >  {
> > > @@ -368,6 +378,8 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned int in
> > >       unsigned long flags;
> > >       unsigned int num;
> > >       int err;
> > > +     bool (*notify)(struct virtqueue *vq) = __virtio_test_bit(vdev,
> > > +             VIRTIO_F_NOTIFICATION_DATA) ? vm_notify_with_data : vm_notify;
> >
> >
> > Can we optimize this line?
> 
> What kind of optimization do you mean?

In fact speed does not matter here but it is not very readable.
Use of "?" was justified if you put this inside the call to vring_create_virtqueue
(which I still feel would be best).
But if you use a variable, just use plain if:

	bool (*notify)(struct virtqueue *vq);

	if (__virtio_test_bit(vdev,VIRTIO_F_NOTIFICATION_DATA))
			vq = vm_notify_with_data;
	else
			vq = vm_notify;


> >
> > Thanks.
> >
> > >
> > >       if (!name)
> > >               return NULL;
> > > @@ -397,7 +409,7 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned int in
> > >
> > >       /* Create the vring */
> > >       vq = vring_create_virtqueue(index, num, VIRTIO_MMIO_VRING_ALIGN, vdev,
> > > -                              true, true, ctx, vm_notify, callback, name);
> > > +                              true, true, ctx, notify, callback, name);
> > >       if (!vq) {
> > >               err = -ENOMEM;
> > >               goto error_new_virtqueue;
> > > diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
> > > index 9e496e288cfa..9cc56f463dba 100644
> > > --- a/drivers/virtio/virtio_pci_modern.c
> > > +++ b/drivers/virtio/virtio_pci_modern.c
> > > @@ -288,6 +288,15 @@ static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 vector)
> > >       return vp_modern_config_vector(&vp_dev->mdev, vector);
> > >  }
> > >
> > > +static bool vp_notify_with_data(struct virtqueue *vq)
> > > +{
> > > +     u32 data = vring_notification_data(vq);
> > > +
> > > +     iowrite32(data, (void __iomem *)vq->priv);
> > > +
> > > +     return true;
> > > +}
> > > +
> > >  static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
> > >                                 struct virtio_pci_vq_info *info,
> > >                                 unsigned int index,
> > > @@ -301,6 +310,8 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
> > >       struct virtqueue *vq;
> > >       u16 num;
> > >       int err;
> > > +     bool (*notify)(struct virtqueue *vq) = __virtio_test_bit(&vp_dev->vdev,
> > > +             VIRTIO_F_NOTIFICATION_DATA) ? vp_notify_with_data : vp_notify;
> > >
> > >       if (index >= vp_modern_get_num_queues(mdev))
> > >               return ERR_PTR(-EINVAL);
> > > @@ -321,7 +332,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
> > >       vq = vring_create_virtqueue(index, num,
> > >                                   SMP_CACHE_BYTES, &vp_dev->vdev,
> > >                                   true, true, ctx,
> > > -                                 vp_notify, callback, name);
> > > +                                 notify, callback, name);
> > >       if (!vq)
> > >               return ERR_PTR(-ENOMEM);
> > >
> > > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > > index 4c3bb0ddeb9b..837875cc3190 100644
> > > --- a/drivers/virtio/virtio_ring.c
> > > +++ b/drivers/virtio/virtio_ring.c
> > > @@ -2752,6 +2752,21 @@ void vring_del_virtqueue(struct virtqueue *_vq)
> > >  }
> > >  EXPORT_SYMBOL_GPL(vring_del_virtqueue);
> > >
> > > +u32 vring_notification_data(struct virtqueue *_vq)
> > > +{
> > > +     struct vring_virtqueue *vq = to_vvq(_vq);
> > > +     u16 next;
> > > +
> > > +     if (vq->packed_ring)
> > > +             next = (vq->packed.next_avail_idx & ~(1 << 15)) |
> > > +                     vq->packed.avail_wrap_counter << 15;
> > > +     else
> > > +             next = vq->split.avail_idx_shadow;
> > > +
> > > +     return next << 16 | _vq->index;
> > > +}
> > > +EXPORT_SYMBOL_GPL(vring_notification_data);
> > > +
> > >  /* Manipulates transport-specific feature bits. */
> > >  void vring_transport_features(struct virtio_device *vdev)
> > >  {
> > > @@ -2771,6 +2786,8 @@ void vring_transport_features(struct virtio_device *vdev)
> > >                       break;
> > >               case VIRTIO_F_ORDER_PLATFORM:
> > >                       break;
> > > +             case VIRTIO_F_NOTIFICATION_DATA:
> > > +                     break;
> > >               default:
> > >                       /* We don't understand this bit. */
> > >                       __virtio_clear_bit(vdev, i);
> > > diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
> > > index 8b95b69ef694..2550c9170f4f 100644
> > > --- a/include/linux/virtio_ring.h
> > > +++ b/include/linux/virtio_ring.h
> > > @@ -117,4 +117,6 @@ void vring_del_virtqueue(struct virtqueue *vq);
> > >  void vring_transport_features(struct virtio_device *vdev);
> > >
> > >  irqreturn_t vring_interrupt(int irq, void *_vq);
> > > +
> > > +u32 vring_notification_data(struct virtqueue *_vq);
> > >  #endif /* _LINUX_VIRTIO_RING_H */
> > > diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
> > > index 3c05162bc988..2c712c654165 100644
> > > --- a/include/uapi/linux/virtio_config.h
> > > +++ b/include/uapi/linux/virtio_config.h
> > > @@ -99,6 +99,12 @@
> > >   */
> > >  #define VIRTIO_F_SR_IOV                      37
> > >
> > > +/*
> > > + * This feature indicates that the driver passes extra data (besides
> > > + * identifying the virtqueue) in its device notifications.
> > > + */
> > > +#define VIRTIO_F_NOTIFICATION_DATA   38
> > > +
> > >  /*
> > >   * This feature indicates that the driver can reset a queue individually.
> > >   */
> > > --
> > > 2.35.1
> > >

