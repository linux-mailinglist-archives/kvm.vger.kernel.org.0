Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32C527B0E04
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 23:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjI0VZx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 17:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjI0VZw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 17:25:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FBC11D
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 14:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695849905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VmntjQFEBP4zxkSKza823gqYagc7cqE2Mw3qK1poHGA=;
        b=EYUSoADqjfs6Do1kcNdeuMa/cUjWYKYc6hPJXMxJIJi1GN++iIBNTQ4go/b+AoXTNGsQZs
        xHuq33UgmXVWkUErlyT+iHZOzFXEchZtFO8f22WmoUF/RY4V0J2LUlXv7QKcwIV+bTsLb2
        QGoEbYqOaaCGZdDKZxnHXvF20YND2+M=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-267-iP7XbKaaOGiOKK3QI9MEgw-1; Wed, 27 Sep 2023 17:25:03 -0400
X-MC-Unique: iP7XbKaaOGiOKK3QI9MEgw-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4059475c174so71780995e9.0
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 14:25:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695849902; x=1696454702;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VmntjQFEBP4zxkSKza823gqYagc7cqE2Mw3qK1poHGA=;
        b=JfokRq3ZnXP+W9tLxkJXyRkXos0oudnlE5qruhUMygwCG/AVxMMZUFDP9chGwMVHHW
         UzbWPdQf4VcngP4yTwIBobK+SKCtHjNcl3elznC0J0Q10irjJAJsrIpLR7PmKKNWbTHY
         c83BJPkvKKyjyqUXBOBlkeWe1tUjv07tvKd9z7prR/5l+U1ApWyXX4Fkl1r/KBaCdUeU
         s7UsN0tXZ/XkOq+evJC8QKI9v+j7nxQztV9wdAasCeG7RIwDCbeb99o744RVIO5wAW/t
         k80E1dTj+Km5qTFK3BMIMQ53wf7wf9aQF7NIHmZegWMax8ze+sLcK62Badaj+x+hPIt/
         F8HQ==
X-Gm-Message-State: AOJu0YzWFh8wfCXv5l0OYh+JtOaijJLIq/kGGjcZynq6FWkoRR279Y/4
        wSd8JYWoO/IQJ7tIuAzHG0K2pU9Rxo7dhH8DDPHDOPag4ZNXcSapAjRoU5Lrf4K0co7Rf91HhjL
        bmyY0gfkJqG3f
X-Received: by 2002:a7b:c4cb:0:b0:405:40c6:2b96 with SMTP id g11-20020a7bc4cb000000b0040540c62b96mr3252748wmk.3.1695849902520;
        Wed, 27 Sep 2023 14:25:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGoSKe8qGtIAhaENH1IBp/4qm/cttWihUV2n1Xw4IXG2ADxskYunHMDBRVoizr7wIOq+D70bQ==
X-Received: by 2002:a7b:c4cb:0:b0:405:40c6:2b96 with SMTP id g11-20020a7bc4cb000000b0040540c62b96mr3252738wmk.3.1695849902136;
        Wed, 27 Sep 2023 14:25:02 -0700 (PDT)
Received: from redhat.com ([2.52.19.249])
        by smtp.gmail.com with ESMTPSA id f2-20020a7bc8c2000000b003fefaf299b6sm7026620wml.38.2023.09.27.14.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Sep 2023 14:25:01 -0700 (PDT)
Date:   Wed, 27 Sep 2023 17:24:57 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Feng Liu <feliu@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, kvm@vger.kernel.org,
        maorg@nvidia.com, virtualization@lists.linux-foundation.org,
        jgg@nvidia.com, jiri@nvidia.com, leonro@nvidia.com
Subject: Re: [PATCH vfio 01/11] virtio-pci: Use virtio pci device layer vq
 info instead of generic one
Message-ID: <20230927171859-mutt-send-email-mst@kernel.org>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-2-yishaih@nvidia.com>
 <20230921093540-mutt-send-email-mst@kernel.org>
 <6eb92b47-cefe-8b00-d3d2-f15ce4aa9959@nvidia.com>
 <39d8a0a5-4365-4ced-cac1-bef2bc8d6367@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <39d8a0a5-4365-4ced-cac1-bef2bc8d6367@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 27, 2023 at 02:09:43PM -0400, Feng Liu wrote:
> 
> 
> On 2023-09-26 p.m.3:13, Feng Liu via Virtualization wrote:
> > External email: Use caution opening links or attachments
> > 
> > 
> > On 2023-09-21 a.m.9:46, Michael S. Tsirkin wrote:
> > > External email: Use caution opening links or attachments
> > > 
> > > 
> > > On Thu, Sep 21, 2023 at 03:40:30PM +0300, Yishai Hadas wrote:
> > > > From: Feng Liu <feliu@nvidia.com>
> > > > 
> 
> > > > pci_irq_vector(vp_dev->pci_dev, v);
> > > > @@ -294,6 +298,7 @@ static int vp_find_vqs_msix(struct
> > > > virtio_device *vdev, unsigned int nvqs,
> > > >        vp_dev->vqs = kcalloc(nvqs, sizeof(*vp_dev->vqs), GFP_KERNEL);
> > > >        if (!vp_dev->vqs)
> > > >                return -ENOMEM;
> > > > +     vp_dev->nvqs = nvqs;
> > > > 
> > > >        if (per_vq_vectors) {
> > > >                /* Best option: one for change interrupt, one per vq. */
> > > > @@ -365,6 +370,7 @@ static int vp_find_vqs_intx(struct
> > > > virtio_device *vdev, unsigned int nvqs,
> > > >        vp_dev->vqs = kcalloc(nvqs, sizeof(*vp_dev->vqs), GFP_KERNEL);
> > > >        if (!vp_dev->vqs)
> > > >                return -ENOMEM;
> > > > +     vp_dev->nvqs = nvqs;
> > > > 
> > > >        err = request_irq(vp_dev->pci_dev->irq, vp_interrupt,
> > > > IRQF_SHARED,
> > > >                        dev_name(&vdev->dev), vp_dev);
> > > > diff --git a/drivers/virtio/virtio_pci_common.h
> > > > b/drivers/virtio/virtio_pci_common.h
> > > > index 4b773bd7c58c..602021967aaa 100644
> > > > --- a/drivers/virtio/virtio_pci_common.h
> > > > +++ b/drivers/virtio/virtio_pci_common.h
> > > > @@ -60,6 +60,7 @@ struct virtio_pci_device {
> > > > 
> > > >        /* array of all queues for house-keeping */
> > > >        struct virtio_pci_vq_info **vqs;
> > > > +     u32 nvqs;
> > > 
> > > I don't much like it that we are adding more duplicated info here.
> > > In fact, we tried removing the vqs array in
> > > 5c34d002dcc7a6dd665a19d098b4f4cd5501ba1a - there was some bug in that
> > > patch and the author didn't have the time to debug
> > > so I reverted but I don't really think we need to add to that.
> > > 
> > 
> > Hi Michael
> > 
> > As explained in commit message, this patch is mainly to prepare for the
> > subsequent admin vq patches.
> > 
> > The admin vq is also established using the common mechanism of vring,
> > and is added to vdev->vqs in __vring_new_virtqueue(). So vdev->vqs
> > contains all virtqueues, including rxq, txq, ctrlvq and admin vq.
> > 
> > admin vq should be managed by the virito_pci layer and should not be
> > created or deleted by upper driver (net, blk);
> > When the upper driver was unloaded, it will call del_vqs() interface,
> > which wll call vp_del_vqs(), and vp_del_vqs() should not delete the
> > admin vq, but only delete the virtqueues created by the upper driver
> > such as rxq, txq, and ctrlq.
> > 
> > 
> > vp_dev->vqs[] array only contains virtqueues created by upper driver
> > such as rxq, txq, ctrlq. Traversing vp_dev->vqs array can only delete
> > the upper virtqueues, without the admin vq. Use the vdev->vqs linked
> > list cannot meet the needs.
> > 
> > 
> > Can such an explanation be explained clearly? Or do you have any other
> > alternative methods?
> > 
> 
> Hi, Michael
> 	Is the above explanations OK to you?
> 
> Thanks
> Feng

First, the patch only addresses pci. Second, yes driver unload calls
del_vqs but doesn't it also reset the device? If this happens while
vfio tries to send commands to it then you have other problems.
And, for the baroque need of admin vq which
most devices don't have you are duplicating logic and wasting memory for
everyone.

What is a sane solution? virtio core was never designed to
allow two drivers accessing the same device. So don't try, add the logic
of device access in virtio core.  I feel the problem won't even exist if
instead of just exposing the device pointer you expose a sane interface.


> > > > 
> > > >        /* MSI-X support */
> > > >        int msix_enabled;
> > > > -- 
> > > > 2.27.0
> > > 
> > _______________________________________________
> > Virtualization mailing list
> > Virtualization@lists.linux-foundation.org
> > https://lists.linuxfoundation.org/mailman/listinfo/virtualization

