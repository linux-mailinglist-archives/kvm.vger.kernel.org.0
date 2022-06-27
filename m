Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4843F55B555
	for <lists+kvm@lfdr.de>; Mon, 27 Jun 2022 04:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbiF0Cuf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jun 2022 22:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiF0Cue (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jun 2022 22:50:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AE6D82DC9
        for <kvm@vger.kernel.org>; Sun, 26 Jun 2022 19:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656298231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=biN1ia1/BQslLYkymJMJ0pnjqHIpxR4UA9N5HO9QFXs=;
        b=bc29bj4+lRlw69HYtvBerE+LSoxL/mNjF794MJizom3IsjZodTNveO/mg3WhY3l9L6Xsgk
        ZxdWP72TpeYy5GpE80PuER6LEtISn8CncyPt3DgJSa6Lf9baCV4q3vIjFlzvVkuoVVSQZC
        Tr4GLRX0F80DTB3ulvP5PkYTqjHZatk=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-168-cu3M5D_5Pt2N1LKtEN9DnQ-1; Sun, 26 Jun 2022 22:50:30 -0400
X-MC-Unique: cu3M5D_5Pt2N1LKtEN9DnQ-1
Received: by mail-lf1-f72.google.com with SMTP id be18-20020a056512251200b0048120ff434dso206167lfb.19
        for <kvm@vger.kernel.org>; Sun, 26 Jun 2022 19:50:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=biN1ia1/BQslLYkymJMJ0pnjqHIpxR4UA9N5HO9QFXs=;
        b=kzC8JREh6Dr4ag4VPz0RVnJS3fpSxCTlTQVD2nDvjnDM3MKEWq/dIQVM6a3AYzBgsZ
         uTrXi6Qmu+U+bCo2QWdgtCo1mAajEHusi7SzgYnlZ+OYDS2lPoT2defMo+BFmdp7ViFf
         9SSOePjNkXn7vvQyQwEgxhki8GyxoqEYi9fONsaHaSV8NSSpGPghLIuy0DhbanTqi4ku
         Iff90DPVdNlIL9q8szKdp4hWbM0a7XlZam5Bey71MDT277toXWMytmWXAC9K1XaDOmuT
         NPXjOY5OyGgCahJ1DYdoFRKpQCYQrnv97f1RHgh9hbTyfsjxSYtvDextbWRiwTn+2/G5
         /xiQ==
X-Gm-Message-State: AJIora/+svQZEU0VtiVnwezvuZAeJWnDtuTnjWUvXM8dTc0aLAOhp0fD
        Z6riWTIrr8EW3WyfZmfP2vMuZAdnCpyft2I8J+eYUMrq7AmzIESsLEo7lAOuRyKIuNT6tOChg8U
        hDS4S0pItIqPTMC5iF/sVx3fsTOiR
X-Received: by 2002:a05:6512:158d:b0:47f:718c:28b5 with SMTP id bp13-20020a056512158d00b0047f718c28b5mr7251010lfb.397.1656298228870;
        Sun, 26 Jun 2022 19:50:28 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ulCpLKIjQVszdgxVzjALf9iZpks66eBcENKIOyoL8+jUQn7V87hzr7NV3Fmj3jrJlmXUV/mhE9ythg/IWkCgA=
X-Received: by 2002:a05:6512:158d:b0:47f:718c:28b5 with SMTP id
 bp13-20020a056512158d00b0047f718c28b5mr7250996lfb.397.1656298228615; Sun, 26
 Jun 2022 19:50:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220622012940.21441-1-jasowang@redhat.com> <20220622025047-mutt-send-email-mst@kernel.org>
 <CACGkMEtJY2ioD0L8ifTrCPatG6-NqQ01V=d2L1FeoweKV74LaA@mail.gmail.com> <20220624022622-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220624022622-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 27 Jun 2022 10:50:17 +0800
Message-ID: <CACGkMEuurobpUWmDL8zmZ6T6Ygc0OEMx6vx2EDCSoGNnZQ0r-w@mail.gmail.com>
Subject: Re: [PATCH V3] virtio: disable notification hardening by default
To:     "Michael S. Tsirkin" <mst@redhat.com>
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 24, 2022 at 2:31 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Jun 22, 2022 at 03:09:31PM +0800, Jason Wang wrote:
> > On Wed, Jun 22, 2022 at 3:03 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Wed, Jun 22, 2022 at 09:29:40AM +0800, Jason Wang wrote:
> > > > We try to harden virtio device notifications in 8b4ec69d7e09 ("virtio:
> > > > harden vring IRQ"). It works with the assumption that the driver or
> > > > core can properly call virtio_device_ready() at the right
> > > > place. Unfortunately, this seems to be not true and uncover various
> > > > bugs of the existing drivers, mainly the issue of using
> > > > virtio_device_ready() incorrectly.
> > > >
> > > > So let's having a Kconfig option and disable it by default. It gives
> > > > us a breath to fix the drivers and then we can consider to enable it
> > > > by default.
> > > >
> > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > >
> > >
> > > OK I will queue, but I think the problem is fundamental.
> >
> > If I understand correctly, you want some core IRQ work?
>
> Yes.
>
> > As discussed
> > before, it doesn't solve all the problems, we still need to do per
> > driver audit.
> >
> > Thanks
>
> Maybe, but we don't need to tie things to device_ready then.
> We can do
>
> - disable irqs
> - device ready
> - setup everything
> - enable irqs
>
>
> and this works for most things, the only issue is
> this deadlocks if "setup everything" waits for interrupts.
>
>
> With the current approach there's really no good time:
> 1.- setup everything
> - device ready
>
> can cause kicks before device is ready
>
> 2.- device ready
> - setup everything
>
> can cause callbacks before setup.
>
> So I prefer the 1. and fix the hardening in the core.

So my question is:

1) do similar hardening like config interrupt
or
2) per transport notification work (e.g for PCI core IRQ work)

1) seems easier and universal, but we pay little overhead which could
be eliminated by the config option.
2) seems require more work in the IRQ core and it can not work for all
transports (e.g vDPA would be kind of difficult)

Thanks

>
>
> > >
> > >
> > > > ---
> > > > Changes since V2:
> > > > - Tweak the Kconfig help
> > > > - Add comment for the read_lock() pairing in virtio_ccw
> > > > ---
> > > >  drivers/s390/virtio/virtio_ccw.c |  9 ++++++++-
> > > >  drivers/virtio/Kconfig           | 13 +++++++++++++
> > > >  drivers/virtio/virtio.c          |  2 ++
> > > >  drivers/virtio/virtio_ring.c     | 12 ++++++++++++
> > > >  include/linux/virtio_config.h    |  2 ++
> > > >  5 files changed, 37 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> > > > index 97e51c34e6cf..1f6a358f65f0 100644
> > > > --- a/drivers/s390/virtio/virtio_ccw.c
> > > > +++ b/drivers/s390/virtio/virtio_ccw.c
> > > > @@ -1136,8 +1136,13 @@ static void virtio_ccw_int_handler(struct ccw_device *cdev,
> > > >                       vcdev->err = -EIO;
> > > >       }
> > > >       virtio_ccw_check_activity(vcdev, activity);
> > > > -     /* Interrupts are disabled here */
> > > > +#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
> > > > +     /*
> > > > +      * Paried with virtio_ccw_synchronize_cbs() and interrupts are
> > > > +      * disabled here.
> > > > +      */
> > > >       read_lock(&vcdev->irq_lock);
> > > > +#endif
> > > >       for_each_set_bit(i, indicators(vcdev),
> > > >                        sizeof(*indicators(vcdev)) * BITS_PER_BYTE) {
> > > >               /* The bit clear must happen before the vring kick. */
> > > > @@ -1146,7 +1151,9 @@ static void virtio_ccw_int_handler(struct ccw_device *cdev,
> > > >               vq = virtio_ccw_vq_by_ind(vcdev, i);
> > > >               vring_interrupt(0, vq);
> > > >       }
> > > > +#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
> > > >       read_unlock(&vcdev->irq_lock);
> > > > +#endif
> > > >       if (test_bit(0, indicators2(vcdev))) {
> > > >               virtio_config_changed(&vcdev->vdev);
> > > >               clear_bit(0, indicators2(vcdev));
> > > > diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
> > > > index b5adf6abd241..c04f370a1e5c 100644
> > > > --- a/drivers/virtio/Kconfig
> > > > +++ b/drivers/virtio/Kconfig
> > > > @@ -35,6 +35,19 @@ menuconfig VIRTIO_MENU
> > > >
> > > >  if VIRTIO_MENU
> > > >
> > > > +config VIRTIO_HARDEN_NOTIFICATION
> > > > +        bool "Harden virtio notification"
> > > > +        help
> > > > +          Enable this to harden the device notifications and suppress
> > > > +          those that happen at a time where notifications are illegal.
> > > > +
> > > > +          Experimental: Note that several drivers still have bugs that
> > > > +          may cause crashes or hangs when correct handling of
> > > > +          notifications is enforced; depending on the subset of
> > > > +          drivers and devices you use, this may or may not work.
> > > > +
> > > > +          If unsure, say N.
> > > > +
> > > >  config VIRTIO_PCI
> > > >       tristate "PCI driver for virtio devices"
> > > >       depends on PCI
> > > > diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> > > > index ef04a96942bf..21dc08d2f32d 100644
> > > > --- a/drivers/virtio/virtio.c
> > > > +++ b/drivers/virtio/virtio.c
> > > > @@ -220,6 +220,7 @@ static int virtio_features_ok(struct virtio_device *dev)
> > > >   * */
> > > >  void virtio_reset_device(struct virtio_device *dev)
> > > >  {
> > > > +#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
> > > >       /*
> > > >        * The below virtio_synchronize_cbs() guarantees that any
> > > >        * interrupt for this line arriving after
> > > > @@ -228,6 +229,7 @@ void virtio_reset_device(struct virtio_device *dev)
> > > >        */
> > > >       virtio_break_device(dev);
> > > >       virtio_synchronize_cbs(dev);
> > > > +#endif
> > > >
> > > >       dev->config->reset(dev);
> > > >  }
> > > > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > > > index 13a7348cedff..d9d3b6e201fb 100644
> > > > --- a/drivers/virtio/virtio_ring.c
> > > > +++ b/drivers/virtio/virtio_ring.c
> > > > @@ -1688,7 +1688,11 @@ static struct virtqueue *vring_create_virtqueue_packed(
> > > >       vq->we_own_ring = true;
> > > >       vq->notify = notify;
> > > >       vq->weak_barriers = weak_barriers;
> > > > +#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
> > > >       vq->broken = true;
> > > > +#else
> > > > +     vq->broken = false;
> > > > +#endif
> > > >       vq->last_used_idx = 0;
> > > >       vq->event_triggered = false;
> > > >       vq->num_added = 0;
> > > > @@ -2135,9 +2139,13 @@ irqreturn_t vring_interrupt(int irq, void *_vq)
> > > >       }
> > > >
> > > >       if (unlikely(vq->broken)) {
> > > > +#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
> > > >               dev_warn_once(&vq->vq.vdev->dev,
> > > >                             "virtio vring IRQ raised before DRIVER_OK");
> > > >               return IRQ_NONE;
> > > > +#else
> > > > +             return IRQ_HANDLED;
> > > > +#endif
> > > >       }
> > > >
> > > >       /* Just a hint for performance: so it's ok that this can be racy! */
> > > > @@ -2180,7 +2188,11 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
> > > >       vq->we_own_ring = false;
> > > >       vq->notify = notify;
> > > >       vq->weak_barriers = weak_barriers;
> > > > +#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
> > > >       vq->broken = true;
> > > > +#else
> > > > +     vq->broken = false;
> > > > +#endif
> > > >       vq->last_used_idx = 0;
> > > >       vq->event_triggered = false;
> > > >       vq->num_added = 0;
> > > > diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
> > > > index 9a36051ceb76..d15c3cdda2d2 100644
> > > > --- a/include/linux/virtio_config.h
> > > > +++ b/include/linux/virtio_config.h
> > > > @@ -257,6 +257,7 @@ void virtio_device_ready(struct virtio_device *dev)
> > > >
> > > >       WARN_ON(status & VIRTIO_CONFIG_S_DRIVER_OK);
> > > >
> > > > +#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
> > > >       /*
> > > >        * The virtio_synchronize_cbs() makes sure vring_interrupt()
> > > >        * will see the driver specific setup if it sees vq->broken
> > > > @@ -264,6 +265,7 @@ void virtio_device_ready(struct virtio_device *dev)
> > > >        */
> > > >       virtio_synchronize_cbs(dev);
> > > >       __virtio_unbreak_device(dev);
> > > > +#endif
> > > >       /*
> > > >        * The transport should ensure the visibility of vq->broken
> > > >        * before setting DRIVER_OK. See the comments for the transport
> > > > --
> > > > 2.25.1
> > >
>

