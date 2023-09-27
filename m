Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86C607B0E06
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 23:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjI0V2n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 17:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjI0V2m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 17:28:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10FA3D6
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 14:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695850074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NVhXHBHOJiNE7AFztQWpCxUca0e80DXZadzWQuxdrFs=;
        b=YY0aW4tukM9aIk6bYnDcp/3xhw0i6AMh3UllRxilCwizAtZczvjHp/jfoQ4tSVlRx1TKF9
        Td20JZqU0JSaAT+48oQRYr2tFNL0qHwl9QDguk9xI/fsVpoHmHlAN74UvXOrMvfI13Agsi
        BMdgWDYu6ttP+u/caRgzcnjfjm9cIYw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-372-4EZbUO5xNBacD4nMFaOOwA-1; Wed, 27 Sep 2023 17:27:52 -0400
X-MC-Unique: 4EZbUO5xNBacD4nMFaOOwA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-40590e6bd67so71481825e9.2
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 14:27:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695850071; x=1696454871;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NVhXHBHOJiNE7AFztQWpCxUca0e80DXZadzWQuxdrFs=;
        b=vdEPHBIlpnU3pT6jyaN7Jv3NoIiPVQEq9rw4ocSqnpzI94sm7f1WB/J0UxquravlfQ
         jG9IpqtAPrnfgpxtdU+i9aQxYCABGYA6GezQlsuacwBsxNB/syQZjWmL/zYEdRzohB0A
         S8o8iKt5WiGwWrF+LkpYSYzB5LfBczlq1afnl98fR4J2nvibCDPkATwvK5WOrGAQndVj
         VDN5sCI960ixktLM3E+6nQa5F6oqdl91STGq2VAd7PUeS4D3D6E59202yl9boRjogyoe
         31bp+pMlR6kWDZ6tQoBnXn1drvXk1Qlx60uAwKv2d2rKJHrN9LkPvuqo8cxuhmlFZcyA
         JTcw==
X-Gm-Message-State: AOJu0YxKO3uIqByYUATIxkO2QnOOKIic1CUk8m2ERUnRER9NNQpkKc4y
        1oU/zO4dImK5NSQiI0w+C+P4lZmUpZgphdrc+pGNmQDlEtZp9yYYAFHIc0hFYR1kB3iK9nmNfjK
        9dlkJFEvA541Q
X-Received: by 2002:a05:600c:d5:b0:404:f9c1:d5d7 with SMTP id u21-20020a05600c00d500b00404f9c1d5d7mr2989073wmm.25.1695850071732;
        Wed, 27 Sep 2023 14:27:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFIcUJn90U5HWXMApV7/w5orCfurEE6KfmvMEkl/mryjB+2TvyKWxY5JcqbSZmIYrL/4XWi2g==
X-Received: by 2002:a05:600c:d5:b0:404:f9c1:d5d7 with SMTP id u21-20020a05600c00d500b00404f9c1d5d7mr2989057wmm.25.1695850071378;
        Wed, 27 Sep 2023 14:27:51 -0700 (PDT)
Received: from redhat.com ([2.52.19.249])
        by smtp.gmail.com with ESMTPSA id q12-20020a05600c040c00b0040586360a36sm10244285wmb.17.2023.09.27.14.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Sep 2023 14:27:50 -0700 (PDT)
Date:   Wed, 27 Sep 2023 17:27:47 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Feng Liu <feliu@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, kvm@vger.kernel.org,
        maorg@nvidia.com, virtualization@lists.linux-foundation.org,
        jgg@nvidia.com, jiri@nvidia.com, leonro@nvidia.com
Subject: Re: [PATCH vfio 03/11] virtio-pci: Introduce admin virtqueue
Message-ID: <20230927172553-mutt-send-email-mst@kernel.org>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-4-yishaih@nvidia.com>
 <20230921095216-mutt-send-email-mst@kernel.org>
 <62df07ea-ddb6-f4ee-f7c3-1400dbe3f0a9@nvidia.com>
 <40f53b6f-f220-af35-0797-e3c60c8c1294@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <40f53b6f-f220-af35-0797-e3c60c8c1294@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 27, 2023 at 02:12:24PM -0400, Feng Liu wrote:
> 
> 
> On 2023-09-26 p.m.3:23, Feng Liu via Virtualization wrote:
> > External email: Use caution opening links or attachments
> > 
> > 
> > On 2023-09-21 a.m.9:57, Michael S. Tsirkin wrote:
> > > External email: Use caution opening links or attachments
> > > 
> > > 
> > > On Thu, Sep 21, 2023 at 03:40:32PM +0300, Yishai Hadas wrote:
> > > > From: Feng Liu <feliu@nvidia.com>
> 
> 
> > > >   drivers/virtio/virtio_pci_modern_avq.c | 65 ++++++++++++++++++++++++++
> > > 
> > > if you have a .c file without a .h file you know there's something
> > > fishy. Just add this inside drivers/virtio/virtio_pci_modern.c ?
> > > 
> > Will do.
> > 
> 
> > > > +struct virtio_avq {
> > > 
> > > admin_vq would be better. and this is pci specific yes? so virtio_pci_
> > > 
> > 
> > Will do.
> > 
> 
> > > > 
> > > > +     struct virtio_avq *admin;
> > > 
> > > and this could be thinkably admin_vq.
> > > 
> > Will do.
> > 
> 
> > > > 
> > > >   /* If driver didn't advertise the feature, it will never appear. */
> > > > diff --git a/include/linux/virtio_pci_modern.h
> > > > b/include/linux/virtio_pci_modern.h
> > > > index 067ac1d789bc..f6cb13d858fd 100644
> > > > --- a/include/linux/virtio_pci_modern.h
> > > > +++ b/include/linux/virtio_pci_modern.h
> > > > @@ -10,6 +10,9 @@ struct virtio_pci_modern_common_cfg {
> > > > 
> > > >        __le16 queue_notify_data;       /* read-write */
> > > >        __le16 queue_reset;             /* read-write */
> > > > +
> > > > +     __le16 admin_queue_index;       /* read-only */
> > > > +     __le16 admin_queue_num;         /* read-only */
> > > >   };
> > > 
> > > 
> > > ouch.
> > > actually there's a problem
> > > 
> > >          mdev->common = vp_modern_map_capability(mdev, common,
> > >                                        sizeof(struct
> > > virtio_pci_common_cfg), 4,
> > >                                        0, sizeof(struct
> > > virtio_pci_common_cfg),
> > >                                        NULL, NULL);
> > > 
> > > extending this structure means some calls will start failing on
> > > existing devices.
> > > 
> > > even more of an ouch, when we added queue_notify_data and queue_reset we
> > > also possibly broke some devices. well hopefully not since no one
> > > reported failures but we really need to fix that.
> > > 
> > > 
> > Hi Michael
> > 
> > I didn’t see the fail in vp_modern_map_capability(), and
> > vp_modern_map_capability() only read and map pci memory. The length of
> > the memory mapping will increase as the struct virtio_pci_common_cfg
> > increases. No errors are seen.
> > 
> > And according to the existing code, new pci configuration space members
> > can only be added in struct virtio_pci_modern_common_cfg.
> > 
> > Every single entry added here is protected by feature bit, there is no
> > bug AFAIK.
> > 
> > Could you help to explain it more detail?  Where and why it will fall if
> > we add new member in struct virtio_pci_modern_common_cfg.
> > 
> > 
> Hi, Michael
> 	Any comments about this?
> Thanks
> Feng

If an existing device exposes a small
capability matching old size, then you change size then
the check will fail on the existing device and driver won't load.

All this happens way before feature bit checks.


> > > > 
> > > >   struct virtio_pci_modern_device {
> > > > -- 
> > > > 2.27.0
> > > 
> > _______________________________________________
> > Virtualization mailing list
> > Virtualization@lists.linux-foundation.org
> > https://lists.linuxfoundation.org/mailman/listinfo/virtualization

