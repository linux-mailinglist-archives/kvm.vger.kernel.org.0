Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B080C6C3691
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 17:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjCUQFm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 12:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbjCUQFk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 12:05:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1967430E9A
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 09:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679414686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lvuo6+gbLS66U9JgpxqS8Rw/48nBbSnJ5zKf6oE7jWc=;
        b=PzVRwKOt8msBlVhJZdjZODQw/OokHVqNd0jmd2eLpvS57vxNq4WqNqyYSZdspwR50T00Zb
        KwalmZQqDMyUpbg9/pp0a0cATA5ftDA9XuZe5X/2NuSGcaObDby0i7gLAB1fI/YrBTNOGL
        0XzU0mlLBXBcQdU4Vw0RF1TVtZnT+xA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-256-dKTYrvk5MGWVJXwU5GhG4w-1; Tue, 21 Mar 2023 12:04:45 -0400
X-MC-Unique: dKTYrvk5MGWVJXwU5GhG4w-1
Received: by mail-wr1-f72.google.com with SMTP id v30-20020adfa1de000000b002d557ec6d15so816064wrv.18
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 09:04:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679414684;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lvuo6+gbLS66U9JgpxqS8Rw/48nBbSnJ5zKf6oE7jWc=;
        b=8ABO94EOVfVyVwKSpj8q/2EYulyBYmOUztBOCQo+hdf8HQNxgKAgROqV0fqukvEm4Z
         IdT9HHymbosT6JpfeE7EU33Rk2dfdU/6EKQp42SgfoIrmNnkg4Tk3UEFleTxTgv4eojo
         5EMwdo+T/37Gfdgv1VSiTKVFPJbZBpTCSJ2HtV07KEC7v12mRZY5EGSnxcUFM+tC9WsY
         bO3k/+RQKUFOhd7zRCAMjOfQv6xsmGHSTdbxc66xG1vegAnnNobev5HZKIZCYnBBxLRq
         k5qrtZD8wK+tI3MDHyZwWO3pH2p51F/idn4h2IowTkYPUb/NjzwOMz9N+R5UpgIvLdpd
         90bQ==
X-Gm-Message-State: AO0yUKW/Q+1AG5DxsJAwDeeTRr/myUorcGBEPAUfdSM6lrJuksNMb/Xh
        UijMJFUaaby7X+Y9DT+XHqKujbioRE2LTOP8BpeGxt4vidN5u812BKdpO74kaaLCdZFgFFO9j7B
        llMarihrycQNJ
X-Received: by 2002:adf:ec44:0:b0:2c6:85ef:4086 with SMTP id w4-20020adfec44000000b002c685ef4086mr2641062wrn.32.1679414684065;
        Tue, 21 Mar 2023 09:04:44 -0700 (PDT)
X-Google-Smtp-Source: AK7set/qpBy5hLFiDKHRejykyhei5GGgmayXQki0xtcMTXtMaW6+qKHkyL/mZoulIXdg9Sh2mNKc+w==
X-Received: by 2002:adf:ec44:0:b0:2c6:85ef:4086 with SMTP id w4-20020adfec44000000b002c685ef4086mr2641036wrn.32.1679414683733;
        Tue, 21 Mar 2023 09:04:43 -0700 (PDT)
Received: from redhat.com ([2.52.1.105])
        by smtp.gmail.com with ESMTPSA id j10-20020a5d464a000000b002cea8f07813sm11737981wrs.81.2023.03.21.09.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 09:04:43 -0700 (PDT)
Date:   Tue, 21 Mar 2023 12:04:39 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Viktor Prutyanov <viktor@daynix.com>, jasowang@redhat.com,
        pasic@linux.ibm.com, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, yan@daynix.com
Subject: Re: [PATCH v3] virtio: add VIRTIO_F_NOTIFICATION_DATA feature support
Message-ID: <20230321115854-mutt-send-email-mst@kernel.org>
References: <20230321134410.2097163-1-viktor@daynix.com>
 <87h6uem9qc.fsf@redhat.com>
 <CAPv0NP6Ep4-B7cMc285E3d3vYjgwO7O1pq5sG3OYYAoZd3EAYQ@mail.gmail.com>
 <87bkkmm89a.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87bkkmm89a.fsf@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023 at 04:30:57PM +0100, Cornelia Huck wrote:
> On Tue, Mar 21 2023, Viktor Prutyanov <viktor@daynix.com> wrote:
> 
> > On Tue, Mar 21, 2023 at 5:59 PM Cornelia Huck <cohuck@redhat.com> wrote:
> >>
> >> On Tue, Mar 21 2023, Viktor Prutyanov <viktor@daynix.com> wrote:
> >>
> >> > According to VirtIO spec v1.2, VIRTIO_F_NOTIFICATION_DATA feature
> >> > indicates that the driver passes extra data along with the queue
> >> > notifications.
> >> >
> >> > In a split queue case, the extra data is 16-bit available index. In a
> >> > packed queue case, the extra data is 1-bit wrap counter and 15-bit
> >> > available index.
> >> >
> >> > Add support for this feature for MMIO, PCI and channel I/O transports.
> >> >
> >> > Signed-off-by: Viktor Prutyanov <viktor@daynix.com>
> >> > ---
> >> >  v3: support feature in virtio_ccw, remove VM_NOTIFY, use avail_idx_shadow,
> >> >     remove byte swap, rename to vring_notification_data
> >> >  v2: reject the feature in virtio_ccw, replace __le32 with u32
> >> >
> >> >  drivers/s390/virtio/virtio_ccw.c   |  4 +++-
> >> >  drivers/virtio/virtio_mmio.c       | 14 +++++++++++++-
> >> >  drivers/virtio/virtio_pci_common.c | 10 ++++++++++
> >> >  drivers/virtio/virtio_pci_common.h |  4 ++++
> >> >  drivers/virtio/virtio_pci_legacy.c |  2 +-
> >> >  drivers/virtio/virtio_pci_modern.c |  2 +-
> >> >  drivers/virtio/virtio_ring.c       | 17 +++++++++++++++++
> >> >  include/linux/virtio_ring.h        |  2 ++
> >> >  include/uapi/linux/virtio_config.h |  6 ++++++
> >> >  9 files changed, 57 insertions(+), 4 deletions(-)
> >> >
> >> > diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> >> > index 954fc31b4bc7..c33172c5b8d5 100644
> >> > --- a/drivers/s390/virtio/virtio_ccw.c
> >> > +++ b/drivers/s390/virtio/virtio_ccw.c
> >> > @@ -396,13 +396,15 @@ static bool virtio_ccw_kvm_notify(struct virtqueue *vq)
> >> >       struct virtio_ccw_vq_info *info = vq->priv;
> >> >       struct virtio_ccw_device *vcdev;
> >> >       struct subchannel_id schid;
> >> > +     u32 data = __virtio_test_bit(vq->vdev, VIRTIO_F_NOTIFICATION_DATA) ?
> >> > +                     vring_notification_data(vq) : vq->index;
> >> >
> >> >       vcdev = to_vc_device(info->vq->vdev);
> >> >       ccw_device_get_schid(vcdev->cdev, &schid);
> >> >       BUILD_BUG_ON(sizeof(struct subchannel_id) != sizeof(unsigned int));
> >> >       info->cookie = kvm_hypercall3(KVM_S390_VIRTIO_CCW_NOTIFY,
> >> >                                     *((unsigned int *)&schid),
> >> > -                                   vq->index, info->cookie);
> >> > +                                   data, info->cookie);
> >> >       if (info->cookie < 0)
> >> >               return false;
> >> >       return true;
> >> > diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> >> > index 3ff746e3f24a..7c16e622c33d 100644
> >> > --- a/drivers/virtio/virtio_mmio.c
> >> > +++ b/drivers/virtio/virtio_mmio.c
> >> > @@ -285,6 +285,16 @@ static bool vm_notify(struct virtqueue *vq)
> >> >       return true;
> >> >  }
> >> >
> >> > +static bool vm_notify_with_data(struct virtqueue *vq)
> >> > +{
> >> > +     struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vq->vdev);
> >> > +     u32 data = vring_notification_data(vq);
> >> > +
> >> > +     writel(data, vm_dev->base + VIRTIO_MMIO_QUEUE_NOTIFY);
> >>
> >> Can't you simply use the same method as for ccw, i.e. use one callback
> >> function that simply writes one value or the other?
> >
> > The idea is to eliminate the conditional branch induced by feature bit
> > testing from the notification function. Probably, this can be done in
> > the same way in ccw.
> 
> Hm, how noticable is that branch? IOW, is it worth making the code less
> readable for this?

I'm not sure but these things add up. I'm with Viktor here let's just
avoid the branch and not worry about whether it's important or not.
So let's use the same thing here then? And we can use a subfunction
to avoid code duplication.

> (In any case, all transports probably should use the same method.)

