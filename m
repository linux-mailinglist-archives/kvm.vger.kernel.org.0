Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2649A55937D
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 08:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbiFXGb7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 02:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbiFXGb5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 02:31:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 23A4A5DF20
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 23:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656052315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fkwre6WoTaZ3HcBGKyAfeqBPtQ+kpW2QzG2weDAdapc=;
        b=WMmdrzyqOioWiaDMYT8iKfePxi292ECdFvbhi3SNvlzh1xkL4FySZBFTerRFwPmTJrGemv
        S2nVT7lvzMOc6S7HStxtUDZM6grbBpC9uPhrsPTZLoz62aFeGmJHhOIMYt9bzuKS9hsZ3R
        C60mRM7edCq1STsxhTHqVWFrhOqIiX0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-59-sFWmGrO3MimBe_cD6nBgeA-1; Fri, 24 Jun 2022 02:31:53 -0400
X-MC-Unique: sFWmGrO3MimBe_cD6nBgeA-1
Received: by mail-wm1-f70.google.com with SMTP id h125-20020a1c2183000000b003a0374f1eb8so1489953wmh.8
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 23:31:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fkwre6WoTaZ3HcBGKyAfeqBPtQ+kpW2QzG2weDAdapc=;
        b=MmBJfn3BC0uPgAKr5NVLXJF9vyUZ2mSyhTX71JzEqVBthsbAeMveyFnRCKHzIjLVEC
         GhF+MAAzc9h0FbDCBi/CAvrbDUTz2MnWlad7UF2IR/b0lTGJRq+CJW3/6XAANYM2Hxpt
         JPcB9dKrmSkPH82kc2LJIWREAra1MHrhL/kejpcFZLwrQy9TsUFGNcjvjdfFEbAa0vVB
         ISEaCC/6mIgP0t4ZZESS8C33DWY4xB4mj/MtfhWr1S0IXEZ+B8luhhyn79z3hDE20A/k
         XSgMJhk1RVqMgVI1fFQGgKvrVO/V94/9hPQY0Wea0rr8s/UZ9o5SREBUsbBJlvycyDga
         0QfQ==
X-Gm-Message-State: AJIora9NCTD5ZabpNzE6LSVaCEsxAoMKjbuQytNUmxGOjLgUGTwzbv4K
        ZVY0cPksYOdKMXO+LvuLaYywnFAaDbTaJT7giJAI6Phkn5+N99BFCE5/kCPs5Hd83ELRkgmDE3e
        wtiZ6bSSJ14dx
X-Received: by 2002:a5d:6481:0:b0:219:8930:6e48 with SMTP id o1-20020a5d6481000000b0021989306e48mr11516416wri.574.1656052312300;
        Thu, 23 Jun 2022 23:31:52 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vRwBTxtgCODqWGWtTx/7SSJNNx7vYLqsQ5RQvPSrwfQn6gMWJQbS/U+j9i6mC+QbxjMDDN1g==
X-Received: by 2002:a5d:6481:0:b0:219:8930:6e48 with SMTP id o1-20020a5d6481000000b0021989306e48mr11516397wri.574.1656052311996;
        Thu, 23 Jun 2022 23:31:51 -0700 (PDT)
Received: from redhat.com ([2.55.188.216])
        by smtp.gmail.com with ESMTPSA id r21-20020a05600c35d500b003a02f957245sm5754978wmq.26.2022.06.23.23.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 23:31:51 -0700 (PDT)
Date:   Fri, 24 Jun 2022 02:31:46 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-s390@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH V3] virtio: disable notification hardening by default
Message-ID: <20220624022622-mutt-send-email-mst@kernel.org>
References: <20220622012940.21441-1-jasowang@redhat.com>
 <20220622025047-mutt-send-email-mst@kernel.org>
 <CACGkMEtJY2ioD0L8ifTrCPatG6-NqQ01V=d2L1FeoweKV74LaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEtJY2ioD0L8ifTrCPatG6-NqQ01V=d2L1FeoweKV74LaA@mail.gmail.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 22, 2022 at 03:09:31PM +0800, Jason Wang wrote:
> On Wed, Jun 22, 2022 at 3:03 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Wed, Jun 22, 2022 at 09:29:40AM +0800, Jason Wang wrote:
> > > We try to harden virtio device notifications in 8b4ec69d7e09 ("virtio:
> > > harden vring IRQ"). It works with the assumption that the driver or
> > > core can properly call virtio_device_ready() at the right
> > > place. Unfortunately, this seems to be not true and uncover various
> > > bugs of the existing drivers, mainly the issue of using
> > > virtio_device_ready() incorrectly.
> > >
> > > So let's having a Kconfig option and disable it by default. It gives
> > > us a breath to fix the drivers and then we can consider to enable it
> > > by default.
> > >
> > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> >
> >
> > OK I will queue, but I think the problem is fundamental.
> 
> If I understand correctly, you want some core IRQ work?

Yes.

> As discussed
> before, it doesn't solve all the problems, we still need to do per
> driver audit.
> 
> Thanks

Maybe, but we don't need to tie things to device_ready then.
We can do

- disable irqs
- device ready
- setup everything
- enable irqs


and this works for most things, the only issue is
this deadlocks if "setup everything" waits for interrupts.


With the current approach there's really no good time:
1.- setup everything
- device ready

can cause kicks before device is ready

2.- device ready
- setup everything

can cause callbacks before setup.

So I prefer the 1. and fix the hardening in the core.


> >
> >
> > > ---
> > > Changes since V2:
> > > - Tweak the Kconfig help
> > > - Add comment for the read_lock() pairing in virtio_ccw
> > > ---
> > >  drivers/s390/virtio/virtio_ccw.c |  9 ++++++++-
> > >  drivers/virtio/Kconfig           | 13 +++++++++++++
> > >  drivers/virtio/virtio.c          |  2 ++
> > >  drivers/virtio/virtio_ring.c     | 12 ++++++++++++
> > >  include/linux/virtio_config.h    |  2 ++
> > >  5 files changed, 37 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> > > index 97e51c34e6cf..1f6a358f65f0 100644
> > > --- a/drivers/s390/virtio/virtio_ccw.c
> > > +++ b/drivers/s390/virtio/virtio_ccw.c
> > > @@ -1136,8 +1136,13 @@ static void virtio_ccw_int_handler(struct ccw_device *cdev,
> > >                       vcdev->err = -EIO;
> > >       }
> > >       virtio_ccw_check_activity(vcdev, activity);
> > > -     /* Interrupts are disabled here */
> > > +#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
> > > +     /*
> > > +      * Paried with virtio_ccw_synchronize_cbs() and interrupts are
> > > +      * disabled here.
> > > +      */
> > >       read_lock(&vcdev->irq_lock);
> > > +#endif
> > >       for_each_set_bit(i, indicators(vcdev),
> > >                        sizeof(*indicators(vcdev)) * BITS_PER_BYTE) {
> > >               /* The bit clear must happen before the vring kick. */
> > > @@ -1146,7 +1151,9 @@ static void virtio_ccw_int_handler(struct ccw_device *cdev,
> > >               vq = virtio_ccw_vq_by_ind(vcdev, i);
> > >               vring_interrupt(0, vq);
> > >       }
> > > +#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
> > >       read_unlock(&vcdev->irq_lock);
> > > +#endif
> > >       if (test_bit(0, indicators2(vcdev))) {
> > >               virtio_config_changed(&vcdev->vdev);
> > >               clear_bit(0, indicators2(vcdev));
> > > diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
> > > index b5adf6abd241..c04f370a1e5c 100644
> > > --- a/drivers/virtio/Kconfig
> > > +++ b/drivers/virtio/Kconfig
> > > @@ -35,6 +35,19 @@ menuconfig VIRTIO_MENU
> > >
> > >  if VIRTIO_MENU
> > >
> > > +config VIRTIO_HARDEN_NOTIFICATION
> > > +        bool "Harden virtio notification"
> > > +        help
> > > +          Enable this to harden the device notifications and suppress
> > > +          those that happen at a time where notifications are illegal.
> > > +
> > > +          Experimental: Note that several drivers still have bugs that
> > > +          may cause crashes or hangs when correct handling of
> > > +          notifications is enforced; depending on the subset of
> > > +          drivers and devices you use, this may or may not work.
> > > +
> > > +          If unsure, say N.
> > > +
> > >  config VIRTIO_PCI
> > >       tristate "PCI driver for virtio devices"
> > >       depends on PCI
> > > diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> > > index ef04a96942bf..21dc08d2f32d 100644
> > > --- a/drivers/virtio/virtio.c
> > > +++ b/drivers/virtio/virtio.c
> > > @@ -220,6 +220,7 @@ static int virtio_features_ok(struct virtio_device *dev)
> > >   * */
> > >  void virtio_reset_device(struct virtio_device *dev)
> > >  {
> > > +#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
> > >       /*
> > >        * The below virtio_synchronize_cbs() guarantees that any
> > >        * interrupt for this line arriving after
> > > @@ -228,6 +229,7 @@ void virtio_reset_device(struct virtio_device *dev)
> > >        */
> > >       virtio_break_device(dev);
> > >       virtio_synchronize_cbs(dev);
> > > +#endif
> > >
> > >       dev->config->reset(dev);
> > >  }
> > > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > > index 13a7348cedff..d9d3b6e201fb 100644
> > > --- a/drivers/virtio/virtio_ring.c
> > > +++ b/drivers/virtio/virtio_ring.c
> > > @@ -1688,7 +1688,11 @@ static struct virtqueue *vring_create_virtqueue_packed(
> > >       vq->we_own_ring = true;
> > >       vq->notify = notify;
> > >       vq->weak_barriers = weak_barriers;
> > > +#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
> > >       vq->broken = true;
> > > +#else
> > > +     vq->broken = false;
> > > +#endif
> > >       vq->last_used_idx = 0;
> > >       vq->event_triggered = false;
> > >       vq->num_added = 0;
> > > @@ -2135,9 +2139,13 @@ irqreturn_t vring_interrupt(int irq, void *_vq)
> > >       }
> > >
> > >       if (unlikely(vq->broken)) {
> > > +#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
> > >               dev_warn_once(&vq->vq.vdev->dev,
> > >                             "virtio vring IRQ raised before DRIVER_OK");
> > >               return IRQ_NONE;
> > > +#else
> > > +             return IRQ_HANDLED;
> > > +#endif
> > >       }
> > >
> > >       /* Just a hint for performance: so it's ok that this can be racy! */
> > > @@ -2180,7 +2188,11 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
> > >       vq->we_own_ring = false;
> > >       vq->notify = notify;
> > >       vq->weak_barriers = weak_barriers;
> > > +#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
> > >       vq->broken = true;
> > > +#else
> > > +     vq->broken = false;
> > > +#endif
> > >       vq->last_used_idx = 0;
> > >       vq->event_triggered = false;
> > >       vq->num_added = 0;
> > > diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
> > > index 9a36051ceb76..d15c3cdda2d2 100644
> > > --- a/include/linux/virtio_config.h
> > > +++ b/include/linux/virtio_config.h
> > > @@ -257,6 +257,7 @@ void virtio_device_ready(struct virtio_device *dev)
> > >
> > >       WARN_ON(status & VIRTIO_CONFIG_S_DRIVER_OK);
> > >
> > > +#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
> > >       /*
> > >        * The virtio_synchronize_cbs() makes sure vring_interrupt()
> > >        * will see the driver specific setup if it sees vq->broken
> > > @@ -264,6 +265,7 @@ void virtio_device_ready(struct virtio_device *dev)
> > >        */
> > >       virtio_synchronize_cbs(dev);
> > >       __virtio_unbreak_device(dev);
> > > +#endif
> > >       /*
> > >        * The transport should ensure the visibility of vq->broken
> > >        * before setting DRIVER_OK. See the comments for the transport
> > > --
> > > 2.25.1
> >

