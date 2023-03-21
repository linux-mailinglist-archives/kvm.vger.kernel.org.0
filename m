Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C018D6C2B25
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 08:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbjCUHOu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 03:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbjCUHOq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 03:14:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4866DCC24
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 00:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679382835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nuTFG9ab3u7R1jpb31bRtm51snrAor/YhsIuMOJ3A2I=;
        b=LZ6B2ADLK8ZTGLVnohGRp8i2/LgVlupCvL7tmJ4j5dYYB9C8kj44cfLqrzu88LYwwABZ32
        +m4YYlan27J63LryuQn5KgW6wMXZBJxvrRvcZBPlfSH5ABq/AHqJY53x0pakBuOroe4h9P
        7qTuVD8RiYTKBwycqQopzSQumT4dDS8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-101-CWXPmzl2NUuSX6AOc1NsgA-1; Tue, 21 Mar 2023 03:13:54 -0400
X-MC-Unique: CWXPmzl2NUuSX6AOc1NsgA-1
Received: by mail-wm1-f70.google.com with SMTP id j13-20020a05600c190d00b003ed26189f44so9557683wmq.8
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 00:13:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679382833;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nuTFG9ab3u7R1jpb31bRtm51snrAor/YhsIuMOJ3A2I=;
        b=QzAhHR9l0lXEJgX0mSAfpsOHkT16XE11T8/u+bpPS8RHhpz1CjchS9LvS4w+TfpEbq
         9LnPez88ySqT3QIhk1A9CyIoRM0R43vwD02Yn65LjH6qm2LnNNEENLgd3H8n/zf9vG+4
         t8/bSmSZzv5HYJc6PvVWwKnuMiiNpxMg00FINPVv5fDa5KL4g++NZMxZQ6U6E+wzf8Mf
         td7uibsDo8zaJ28xf9DhcNJ286teKUUYPyNA4ZPgwEQLiaP8KJ92O0zRkmIUYp/oflGg
         fZVstncagh39m2zN9p+fEmxlXue4r5rvrYJ0YX1GCP2tVuQQk0+2umppkCk9O5mwW8PX
         8BXg==
X-Gm-Message-State: AO0yUKVuHMtkV0QRPIBepsJxsRolbV3UrdjLPUV5CZW22QkNqGm9u564
        HDt0Sw9IQDaSMTTOEfKmz4HCqIah3lJdK80hKFsABl63bJkhMN4H3JHQYZOJ4K8E8F+hWt/NWzv
        6IXNCoDV0bCLX
X-Received: by 2002:a5d:65c4:0:b0:2ce:a899:2293 with SMTP id e4-20020a5d65c4000000b002cea8992293mr1412888wrw.5.1679382833022;
        Tue, 21 Mar 2023 00:13:53 -0700 (PDT)
X-Google-Smtp-Source: AK7set8KbQmL98dbtoe1oAsaweQtFdB3Ts7JtWE2aDdoQilOLg6IOnVYsFOh/EJ1qessZOqW8oHHZA==
X-Received: by 2002:a5d:65c4:0:b0:2ce:a899:2293 with SMTP id e4-20020a5d65c4000000b002cea8992293mr1412874wrw.5.1679382832726;
        Tue, 21 Mar 2023 00:13:52 -0700 (PDT)
Received: from redhat.com ([2.52.1.105])
        by smtp.gmail.com with ESMTPSA id a10-20020a056000050a00b002d78a96cf5fsm3384706wrf.70.2023.03.21.00.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 00:13:52 -0700 (PDT)
Date:   Tue, 21 Mar 2023 03:13:48 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Viktor Prutyanov <viktor@daynix.com>, cohuck@redhat.com,
        pasic@linux.ibm.com, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, yan@daynix.com
Subject: Re: [PATCH v2] virtio: add VIRTIO_F_NOTIFICATION_DATA feature support
Message-ID: <20230321031310-mutt-send-email-mst@kernel.org>
References: <20230320232115.1940587-1-viktor@daynix.com>
 <CACGkMEu5qa2KUHti3w59DcXNxBdh8_ogZ9oW9bo1_PHwbNiCBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEu5qa2KUHti3w59DcXNxBdh8_ogZ9oW9bo1_PHwbNiCBg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023 at 10:29:11AM +0800, Jason Wang wrote:
> On Tue, Mar 21, 2023 at 7:21 AM Viktor Prutyanov <viktor@daynix.com> wrote:
> >
> > According to VirtIO spec v1.2, VIRTIO_F_NOTIFICATION_DATA feature
> > indicates that the driver passes extra data along with the queue
> > notifications.
> >
> > In a split queue case, the extra data is 16-bit available index. In a
> > packed queue case, the extra data is 1-bit wrap counter and 15-bit
> > available index.
> >
> > Add support for this feature for MMIO and PCI transports. Channel I/O
> > transport will not accept this feature.
> >
> > Signed-off-by: Viktor Prutyanov <viktor@daynix.com>
> > ---
> >
> >  v2: reject the feature in virtio_ccw, replace __le32 with u32
> >
> >  drivers/s390/virtio/virtio_ccw.c   |  4 +---
> >  drivers/virtio/virtio_mmio.c       | 15 ++++++++++++++-
> >  drivers/virtio/virtio_pci_common.c | 10 ++++++++++
> >  drivers/virtio/virtio_pci_common.h |  4 ++++
> >  drivers/virtio/virtio_pci_legacy.c |  2 +-
> >  drivers/virtio/virtio_pci_modern.c |  2 +-
> >  drivers/virtio/virtio_ring.c       | 17 +++++++++++++++++
> >  include/linux/virtio_ring.h        |  2 ++
> >  include/uapi/linux/virtio_config.h |  6 ++++++
> >  9 files changed, 56 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> > index a10dbe632ef9..d72a59415527 100644
> > --- a/drivers/s390/virtio/virtio_ccw.c
> > +++ b/drivers/s390/virtio/virtio_ccw.c
> > @@ -789,9 +789,7 @@ static u64 virtio_ccw_get_features(struct virtio_device *vdev)
> >
> >  static void ccw_transport_features(struct virtio_device *vdev)
> >  {
> > -       /*
> > -        * Currently nothing to do here.
> > -        */
> > +       __virtio_clear_bit(vdev, VIRTIO_F_NOTIFICATION_DATA);
> 
> Is there any restriction that prevents us from implementing
> VIRTIO_F_NOTIFICATION_DATA? (Spec seems doesn't limit us from this)

Right, spec actually tells you what to do.

> >  }
> >
> >  static int virtio_ccw_finalize_features(struct virtio_device *vdev)
> > diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> > index 3ff746e3f24a..0e13da17fe0a 100644
> > --- a/drivers/virtio/virtio_mmio.c
> > +++ b/drivers/virtio/virtio_mmio.c
> > @@ -285,6 +285,19 @@ static bool vm_notify(struct virtqueue *vq)
> >         return true;
> >  }
> >
> > +static bool vm_notify_with_data(struct virtqueue *vq)
> > +{
> > +       struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vq->vdev);
> > +       u32 data = vring_fill_notification_data(vq);
> 
> Can we move this to the initialization?
> 
> Thanks

