Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 790C535C067
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 11:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239612AbhDLJNK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 05:13:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31206 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239573AbhDLJHj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Apr 2021 05:07:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618218440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AiXpa0oASZwRhvw6y5GnL0ZgWv2QxGq5lcY8I/mGNHI=;
        b=PqskzrSaA2PYru9sHGbLAhMQxgy6GP0+/SGsKVwA2LUHQa374ipjUifyx5X0AaQnatMTb7
        4PVHi1E6kyEoBeiqxuoAGcfNGzA0i6UZU3NKECVq2w1sE706QaZHfpG/DJWJo401LGQu6a
        bfPiN3Srv7sbX6LAXKQoL4xmCeClniA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-R-_TUBXYOGKn8Q7a10mxsg-1; Mon, 12 Apr 2021 05:07:16 -0400
X-MC-Unique: R-_TUBXYOGKn8Q7a10mxsg-1
Received: by mail-wr1-f71.google.com with SMTP id j24so4143714wra.1
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 02:07:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=AiXpa0oASZwRhvw6y5GnL0ZgWv2QxGq5lcY8I/mGNHI=;
        b=TXIF1IUVEjfoZbtMcM6BoO3WJQ/zWWLpAsb1MqYevAWLRhCoE9wae9DHuFAfmYAu8z
         A5nl8Z+ZG1f05L7Rol8G2WIikTLbPHfd0WDaxQrJzhCmyqQJS8R6RhcJsKEfrfclygvW
         R1zfIlK61VxbcZK/WGFTMi909WBd2k2L3VoZVzXT5tTEq1c+8jUEd8YzIQ/+ZLgBEFPj
         PTWikpnb+MxSmg9dXo96xNzeDPag1+5c1mufqdDTWOc9prq9CveaXuUi+n6faNd66NfQ
         /YDJt0zcEey2OwuBS++5SA2QRc5gttP+7y+ihtCBUE2Nh1wLMC5r369gv4/nLusw5Pz2
         5AGA==
X-Gm-Message-State: AOAM531za+v9Kvt8uQlYmbB1v0ISgjvr02AYMVAFCwcdDmzeaICA6h47
        b1nZWIwVNaQFzttLA8ZaFCjLiPHHV9qXyhJPJ0GMLKuqOxFCY3vhcVAHftf8DX1+RJ0ulMLcAFi
        3Oo3uFvUfSFTn
X-Received: by 2002:adf:d1e8:: with SMTP id g8mr29764517wrd.175.1618218435363;
        Mon, 12 Apr 2021 02:07:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwEpjOFxkabsuoxqCs9minNXPd2aSkk1nHyc2ILc5/XTRsDFVaCB27nqKfVCJAx03XzFBYvwg==
X-Received: by 2002:adf:d1e8:: with SMTP id g8mr29764487wrd.175.1618218435059;
        Mon, 12 Apr 2021 02:07:15 -0700 (PDT)
Received: from redhat.com ([2a10:8006:2281:0:1994:c627:9eac:1825])
        by smtp.gmail.com with ESMTPSA id z15sm16504028wrw.38.2021.04.12.02.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 02:07:14 -0700 (PDT)
Date:   Mon, 12 Apr 2021 05:07:11 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, oren@nvidia.com,
        nitzanc@nvidia.com, cohuck@redhat.com
Subject: Re: [PATCH v2 1/3] virtio: update reset callback to return status
Message-ID: <20210412050311-mutt-send-email-mst@kernel.org>
References: <20210408081109.56537-1-mgurtovoy@nvidia.com>
 <16fa0e31-a305-3b41-b0d3-ad76aa00177b@redhat.com>
 <1f134102-4ccb-57e3-858d-3922d851ce8a@nvidia.com>
 <a46cef9b-b8da-b748-c332-a3a05bd9135f@redhat.com>
 <103ae6fe-1ffc-90a3-09cd-bcbbcbb8eee7@nvidia.com>
 <7d4599c5-348e-5ca1-8eb6-577d65dc4688@redhat.com>
 <96742dde-edba-0329-c9c2-b3ac3b28cf1d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <96742dde-edba-0329-c9c2-b3ac3b28cf1d@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Apr 11, 2021 at 12:50:22PM +0300, Max Gurtovoy wrote:
> 
> On 4/9/2021 8:22 AM, Jason Wang wrote:
> > 
> > 在 2021/4/8 下午10:24, Max Gurtovoy 写道:
> > > 
> > > On 4/8/2021 4:14 PM, Jason Wang wrote:
> > > > 
> > > > 在 2021/4/8 下午5:56, Max Gurtovoy 写道:
> > > > > 
> > > > > On 4/8/2021 11:58 AM, Jason Wang wrote:
> > > > > > 
> > > > > > 在 2021/4/8 下午4:11, Max Gurtovoy 写道:
> > > > > > > The reset device operation, usually is an operation
> > > > > > > that might fail from
> > > > > > > various reasons. For example, the controller might
> > > > > > > be in a bad state and
> > > > > > > can't answer to any request. Usually, the paravirt SW based virtio
> > > > > > > devices always succeed in reset operation but this
> > > > > > > is not the case for
> > > > > > > HW based virtio devices.
> > > > > > 
> > > > > > 
> > > > > > I would like to know under what condition that the reset
> > > > > > operation may fail (except for the case of a bugg
> > > > > > guest).
> > > > > 
> > > > > The controller might not be ready or stuck. This is a real
> > > > > use case for many PCI devices.
> > > > > 
> > > > > For real devices the FW might be in a bad state and it can
> > > > > happen also for paravirt device if you have a bug in the
> > > > > controller code or if you entered some error flow (Out of
> > > > > memory).
> > > > > 
> > > > > You don't want to be stuck because of one bad device.
> > > > 
> > > > 
> > > > So the buggy driver can damage the host through various ways,
> > > > I'm not sure doing such workaround is worthwhile.
> > > 
> > > do you mean device ?
> > 
> > 
> > Yes.
> > 
> > 
> > > 
> > > sometimes you need to replace device FW and it will work.
> > > 
> > > I don't think it's a workaround. Other protocols, such as NVMe,
> > > solved this in the specification.
> > > 
> > > PCI config space and PCI controller are sometimes 2 different
> > > components and sometimes the controller is not active, although the
> > > device is plugged and seen by the PCI subsystem.
> > 
> > 
> > So I think we need patch to spec to see if it works first.
> 
> We can't leave the driver to loop forever without allowing next "good"
> virtio devices to probe.
> 
> We can in parallel look for spec fixes but for now we must fix the driver.

I'd like to narrow the case though. the proper thing
would probably be for device to clear the status.
Provided it entered some state where it can not do it -
is there anything special about
the device state that *can* be detected?
If yes what is it?


> The fix can be using the mechanism introduced in this series or adding an
> async probing mechanism.

What would that be?

> In both solutions, we can't allow looping forever.

Multiple minute downtime isn't much better either. I'd like a
much shorter timer or even no timer at all, instead
verifying that device is alive every X iterations.

> > 
> > 
> > > 
> > > 
> > > > 
> > > > Note that this driver has been used for real hardware PCI
> > > > devices for many years. We don't receive any report of this
> > > > before.
> > > > 
> > > > 
> > > > > 
> > > > > 
> > > > > > 
> > > > > > 
> > > > > > > 
> > > > > > > This commit is also a preparation for adding a timeout mechanism for
> > > > > > > resetting virtio devices.
> > > > > > > 
> > > > > > > Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> > > > > > > ---
> > > > > > > 
> > > > > > > changes from v1:
> > > > > > >   - update virtio_ccw.c (Cornelia)
> > > > > > >   - update virtio_uml.c
> > > > > > >   - update mlxbf-tmfifo.c
> > > > > > 
> > > > > > 
> > > > > > Note that virtio driver may call reset, so you probably
> > > > > > need to convert them.
> > > > > 
> > > > > I'm sure I understand.
> > > > > 
> > > > > Convert to what ?
> > > > 
> > > > 
> > > > Convert to deal with the possible rest failure. E.g in
> > > > virtblk_freeze() we had:
> > > > 
> > > > static int virtblk_freeze(struct virtio_device *vdev)
> > > > {
> > > >         struct virtio_blk *vblk = vdev->priv;
> > > > 
> > > >         /* Ensure we don't receive any more interrupts */
> > > >         vdev->config->reset(vdev);
> > > > ...
> > > > 
> > > > We need fail the freeze here.
> > > 
> > > 
> > > Agree.
> > > 
> > > 
> > > > 
> > > > Another example is the driver remove which is not expected to be
> > > > fail. A lot of virtio drivers tries to call reset there. I'm not
> > > > sure how hard to deal with the failure in the path of remove
> > > > (e.g __device_release_driver tends to ignore the return value of
> > > > bus->remove().)
> > > 
> > > I think it can stay as-is and ignore the ->reset return value and
> > > continue free the other resources to avoid leakage.
> > 
> > 
> > The problem is that it's unclear that what kind of behaviour would the
> > device do, e.g can it still send interrupts?
> > 
> > That's why we need to formalize the bahviour first if necessary.
> > 
> > Thanks
> > 
> > 
> > > 
> > > 
> > > > 
> > > > Thanks
> > > > 
> > > > 
> > > > > 
> > > > > Thanks.
> > > > > 
> > > > > > 
> > > > > > Thanks
> > > > > > 
> > > > > > 
> > > > > > > 
> > > > > > > ---
> > > > > > >   arch/um/drivers/virtio_uml.c             |  4 +++-
> > > > > > >   drivers/platform/mellanox/mlxbf-tmfifo.c |  4 +++-
> > > > > > >   drivers/remoteproc/remoteproc_virtio.c   |  4 +++-
> > > > > > >   drivers/s390/virtio/virtio_ccw.c         |  9 ++++++---
> > > > > > >   drivers/virtio/virtio.c                  | 22
> > > > > > > +++++++++++++++-------
> > > > > > >   drivers/virtio/virtio_mmio.c             |  3 ++-
> > > > > > >   drivers/virtio/virtio_pci_legacy.c       |  4 +++-
> > > > > > >   drivers/virtio/virtio_pci_modern.c       |  3 ++-
> > > > > > >   drivers/virtio/virtio_vdpa.c             |  4 +++-
> > > > > > >   include/linux/virtio_config.h            |  5 +++--
> > > > > > >   10 files changed, 43 insertions(+), 19 deletions(-)
> > > > > > > 
> > > > > > > diff --git a/arch/um/drivers/virtio_uml.c
> > > > > > > b/arch/um/drivers/virtio_uml.c
> > > > > > > index 91ddf74ca888..b6e66265ed32 100644
> > > > > > > --- a/arch/um/drivers/virtio_uml.c
> > > > > > > +++ b/arch/um/drivers/virtio_uml.c
> > > > > > > @@ -827,11 +827,13 @@ static void
> > > > > > > vu_set_status(struct virtio_device *vdev, u8 status)
> > > > > > >       vu_dev->status = status;
> > > > > > >   }
> > > > > > >   -static void vu_reset(struct virtio_device *vdev)
> > > > > > > +static int vu_reset(struct virtio_device *vdev)
> > > > > > >   {
> > > > > > >       struct virtio_uml_device *vu_dev = to_virtio_uml_device(vdev);
> > > > > > >         vu_dev->status = 0;
> > > > > > > +
> > > > > > > +    return 0;
> > > > > > >   }
> > > > > > >     static void vu_del_vq(struct virtqueue *vq)
> > > > > > > diff --git
> > > > > > > a/drivers/platform/mellanox/mlxbf-tmfifo.c
> > > > > > > b/drivers/platform/mellanox/mlxbf-tmfifo.c
> > > > > > > index bbc4e71a16ff..c192b8ac5d9e 100644
> > > > > > > --- a/drivers/platform/mellanox/mlxbf-tmfifo.c
> > > > > > > +++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
> > > > > > > @@ -980,11 +980,13 @@ static void
> > > > > > > mlxbf_tmfifo_virtio_set_status(struct virtio_device
> > > > > > > *vdev,
> > > > > > >   }
> > > > > > >     /* Reset the device. Not much here for now. */
> > > > > > > -static void mlxbf_tmfifo_virtio_reset(struct virtio_device *vdev)
> > > > > > > +static int mlxbf_tmfifo_virtio_reset(struct virtio_device *vdev)
> > > > > > >   {
> > > > > > >       struct mlxbf_tmfifo_vdev *tm_vdev =
> > > > > > > mlxbf_vdev_to_tmfifo(vdev);
> > > > > > >         tm_vdev->status = 0;
> > > > > > > +
> > > > > > > +    return 0;
> > > > > > >   }
> > > > > > >     /* Read the value of a configuration field. */
> > > > > > > diff --git a/drivers/remoteproc/remoteproc_virtio.c
> > > > > > > b/drivers/remoteproc/remoteproc_virtio.c
> > > > > > > index 0cc617f76068..ca9573c62c3d 100644
> > > > > > > --- a/drivers/remoteproc/remoteproc_virtio.c
> > > > > > > +++ b/drivers/remoteproc/remoteproc_virtio.c
> > > > > > > @@ -191,7 +191,7 @@ static void
> > > > > > > rproc_virtio_set_status(struct virtio_device *vdev,
> > > > > > > u8 status)
> > > > > > >       dev_dbg(&vdev->dev, "status: %d\n", status);
> > > > > > >   }
> > > > > > >   -static void rproc_virtio_reset(struct virtio_device *vdev)
> > > > > > > +static int rproc_virtio_reset(struct virtio_device *vdev)
> > > > > > >   {
> > > > > > >       struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
> > > > > > >       struct fw_rsc_vdev *rsc;
> > > > > > > @@ -200,6 +200,8 @@ static void
> > > > > > > rproc_virtio_reset(struct virtio_device *vdev)
> > > > > > >         rsc->status = 0;
> > > > > > >       dev_dbg(&vdev->dev, "reset !\n");
> > > > > > > +
> > > > > > > +    return 0;
> > > > > > >   }
> > > > > > >     /* provide the vdev features as retrieved from the firmware */
> > > > > > > diff --git a/drivers/s390/virtio/virtio_ccw.c
> > > > > > > b/drivers/s390/virtio/virtio_ccw.c
> > > > > > > index 54e686dca6de..52b32555e746 100644
> > > > > > > --- a/drivers/s390/virtio/virtio_ccw.c
> > > > > > > +++ b/drivers/s390/virtio/virtio_ccw.c
> > > > > > > @@ -732,14 +732,15 @@ static int
> > > > > > > virtio_ccw_find_vqs(struct virtio_device *vdev,
> > > > > > > unsigned nvqs,
> > > > > > >       return ret;
> > > > > > >   }
> > > > > > >   -static void virtio_ccw_reset(struct virtio_device *vdev)
> > > > > > > +static int virtio_ccw_reset(struct virtio_device *vdev)
> > > > > > >   {
> > > > > > >       struct virtio_ccw_device *vcdev = to_vc_device(vdev);
> > > > > > >       struct ccw1 *ccw;
> > > > > > > +    int ret;
> > > > > > >         ccw = ccw_device_dma_zalloc(vcdev->cdev, sizeof(*ccw));
> > > > > > >       if (!ccw)
> > > > > > > -        return;
> > > > > > > +        return -ENOMEM;
> > > > > > >         /* Zero status bits. */
> > > > > > >       vcdev->dma_area->status = 0;
> > > > > > > @@ -749,8 +750,10 @@ static void
> > > > > > > virtio_ccw_reset(struct virtio_device *vdev)
> > > > > > >       ccw->flags = 0;
> > > > > > >       ccw->count = 0;
> > > > > > >       ccw->cda = 0;
> > > > > > > -    ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_RESET);
> > > > > > > +    ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_RESET);
> > > > > > >       ccw_device_dma_free(vcdev->cdev, ccw, sizeof(*ccw));
> > > > > > > +
> > > > > > > +    return ret;
> > > > > > >   }
> > > > > > >     static u64 virtio_ccw_get_features(struct virtio_device *vdev)
> > > > > > > diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> > > > > > > index 4b15c00c0a0a..ddbfd5b5f3bd 100644
> > > > > > > --- a/drivers/virtio/virtio.c
> > > > > > > +++ b/drivers/virtio/virtio.c
> > > > > > > @@ -338,7 +338,7 @@ int
> > > > > > > register_virtio_device(struct virtio_device *dev)
> > > > > > >       /* Assign a unique device index and hence name. */
> > > > > > >       err = ida_simple_get(&virtio_index_ida, 0, 0, GFP_KERNEL);
> > > > > > >       if (err < 0)
> > > > > > > -        goto out;
> > > > > > > +        goto out_err;
> > > > > > >         dev->index = err;
> > > > > > >       dev_set_name(&dev->dev, "virtio%u", dev->index);
> > > > > > > @@ -349,7 +349,9 @@ int
> > > > > > > register_virtio_device(struct virtio_device *dev)
> > > > > > >         /* We always start by resetting the device,
> > > > > > > in case a previous
> > > > > > >        * driver messed it up.  This also tests that
> > > > > > > code path a little. */
> > > > > > > -    dev->config->reset(dev);
> > > > > > > +    err = dev->config->reset(dev);
> > > > > > > +    if (err)
> > > > > > > +        goto out_ida;
> > > > > > >         /* Acknowledge that we've seen the device. */
> > > > > > >       virtio_add_status(dev, VIRTIO_CONFIG_S_ACKNOWLEDGE);
> > > > > > > @@ -362,10 +364,14 @@ int
> > > > > > > register_virtio_device(struct virtio_device *dev)
> > > > > > >        */
> > > > > > >       err = device_add(&dev->dev);
> > > > > > >       if (err)
> > > > > > > -        ida_simple_remove(&virtio_index_ida, dev->index);
> > > > > > > -out:
> > > > > > > -    if (err)
> > > > > > > -        virtio_add_status(dev, VIRTIO_CONFIG_S_FAILED);
> > > > > > > +        goto out_ida;
> > > > > > > +
> > > > > > > +    return 0;
> > > > > > > +
> > > > > > > +out_ida:
> > > > > > > +    ida_simple_remove(&virtio_index_ida, dev->index);
> > > > > > > +out_err:
> > > > > > > +    virtio_add_status(dev, VIRTIO_CONFIG_S_FAILED);
> > > > > > >       return err;
> > > > > > >   }
> > > > > > >   EXPORT_SYMBOL_GPL(register_virtio_device);
> > > > > > > @@ -408,7 +414,9 @@ int virtio_device_restore(struct
> > > > > > > virtio_device *dev)
> > > > > > >         /* We always start by resetting the device,
> > > > > > > in case a previous
> > > > > > >        * driver messed it up. */
> > > > > > > -    dev->config->reset(dev);
> > > > > > > +    ret = dev->config->reset(dev);
> > > > > > > +    if (ret)
> > > > > > > +        goto err;
> > > > > > >         /* Acknowledge that we've seen the device. */
> > > > > > >       virtio_add_status(dev, VIRTIO_CONFIG_S_ACKNOWLEDGE);
> > > > > > > diff --git a/drivers/virtio/virtio_mmio.c
> > > > > > > b/drivers/virtio/virtio_mmio.c
> > > > > > > index 56128b9c46eb..12b8f048c48d 100644
> > > > > > > --- a/drivers/virtio/virtio_mmio.c
> > > > > > > +++ b/drivers/virtio/virtio_mmio.c
> > > > > > > @@ -256,12 +256,13 @@ static void
> > > > > > > vm_set_status(struct virtio_device *vdev, u8 status)
> > > > > > >       writel(status, vm_dev->base + VIRTIO_MMIO_STATUS);
> > > > > > >   }
> > > > > > >   -static void vm_reset(struct virtio_device *vdev)
> > > > > > > +static int vm_reset(struct virtio_device *vdev)
> > > > > > >   {
> > > > > > >       struct virtio_mmio_device *vm_dev =
> > > > > > > to_virtio_mmio_device(vdev);
> > > > > > >         /* 0 status means a reset. */
> > > > > > >       writel(0, vm_dev->base + VIRTIO_MMIO_STATUS);
> > > > > > > +    return 0;
> > > > > > >   }
> > > > > > >     diff --git a/drivers/virtio/virtio_pci_legacy.c
> > > > > > > b/drivers/virtio/virtio_pci_legacy.c
> > > > > > > index d62e9835aeec..0b5d95e3efa1 100644
> > > > > > > --- a/drivers/virtio/virtio_pci_legacy.c
> > > > > > > +++ b/drivers/virtio/virtio_pci_legacy.c
> > > > > > > @@ -89,7 +89,7 @@ static void vp_set_status(struct
> > > > > > > virtio_device *vdev, u8 status)
> > > > > > >       iowrite8(status, vp_dev->ioaddr + VIRTIO_PCI_STATUS);
> > > > > > >   }
> > > > > > >   -static void vp_reset(struct virtio_device *vdev)
> > > > > > > +static int vp_reset(struct virtio_device *vdev)
> > > > > > >   {
> > > > > > >       struct virtio_pci_device *vp_dev = to_vp_device(vdev);
> > > > > > >       /* 0 status means a reset. */
> > > > > > > @@ -99,6 +99,8 @@ static void vp_reset(struct virtio_device *vdev)
> > > > > > >       ioread8(vp_dev->ioaddr + VIRTIO_PCI_STATUS);
> > > > > > >       /* Flush pending VQ/configuration callbacks. */
> > > > > > >       vp_synchronize_vectors(vdev);
> > > > > > > +
> > > > > > > +    return 0;
> > > > > > >   }
> > > > > > >     static u16 vp_config_vector(struct
> > > > > > > virtio_pci_device *vp_dev, u16 vector)
> > > > > > > diff --git a/drivers/virtio/virtio_pci_modern.c
> > > > > > > b/drivers/virtio/virtio_pci_modern.c
> > > > > > > index fbd4ebc00eb6..cc3412a96a17 100644
> > > > > > > --- a/drivers/virtio/virtio_pci_modern.c
> > > > > > > +++ b/drivers/virtio/virtio_pci_modern.c
> > > > > > > @@ -158,7 +158,7 @@ static void vp_set_status(struct
> > > > > > > virtio_device *vdev, u8 status)
> > > > > > >       vp_modern_set_status(&vp_dev->mdev, status);
> > > > > > >   }
> > > > > > >   -static void vp_reset(struct virtio_device *vdev)
> > > > > > > +static int vp_reset(struct virtio_device *vdev)
> > > > > > >   {
> > > > > > >       struct virtio_pci_device *vp_dev = to_vp_device(vdev);
> > > > > > >       struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
> > > > > > > @@ -174,6 +174,7 @@ static void vp_reset(struct virtio_device *vdev)
> > > > > > >           msleep(1);
> > > > > > >       /* Flush pending VQ/configuration callbacks. */
> > > > > > >       vp_synchronize_vectors(vdev);
> > > > > > > +    return 0;
> > > > > > >   }
> > > > > > >     static u16 vp_config_vector(struct
> > > > > > > virtio_pci_device *vp_dev, u16 vector)
> > > > > > > diff --git a/drivers/virtio/virtio_vdpa.c
> > > > > > > b/drivers/virtio/virtio_vdpa.c
> > > > > > > index e28acf482e0c..5fd4e627a9b0 100644
> > > > > > > --- a/drivers/virtio/virtio_vdpa.c
> > > > > > > +++ b/drivers/virtio/virtio_vdpa.c
> > > > > > > @@ -97,11 +97,13 @@ static void
> > > > > > > virtio_vdpa_set_status(struct virtio_device *vdev,
> > > > > > > u8 status)
> > > > > > >       return ops->set_status(vdpa, status);
> > > > > > >   }
> > > > > > >   -static void virtio_vdpa_reset(struct virtio_device *vdev)
> > > > > > > +static int virtio_vdpa_reset(struct virtio_device *vdev)
> > > > > > >   {
> > > > > > >       struct vdpa_device *vdpa = vd_get_vdpa(vdev);
> > > > > > >         vdpa_reset(vdpa);
> > > > > > > +
> > > > > > > +    return 0;
> > > > > > >   }
> > > > > > >     static bool virtio_vdpa_notify(struct virtqueue *vq)
> > > > > > > diff --git a/include/linux/virtio_config.h
> > > > > > > b/include/linux/virtio_config.h
> > > > > > > index 8519b3ae5d52..d2b0f1699a75 100644
> > > > > > > --- a/include/linux/virtio_config.h
> > > > > > > +++ b/include/linux/virtio_config.h
> > > > > > > @@ -44,9 +44,10 @@ struct virtio_shm_region {
> > > > > > >    *    status: the new status byte
> > > > > > >    * @reset: reset the device
> > > > > > >    *    vdev: the virtio device
> > > > > > > - *    After this, status and feature negotiation must be done again
> > > > > > > + *    Upon success, status and feature negotiation
> > > > > > > must be done again
> > > > > > >    *    Device must not be reset from its vq/config callbacks, or in
> > > > > > >    *    parallel with being added/removed.
> > > > > > > + *    Returns 0 on success or error status.
> > > > > > >    * @find_vqs: find virtqueues and instantiate them.
> > > > > > >    *    vdev: the virtio_device
> > > > > > >    *    nvqs: the number of virtqueues to find
> > > > > > > @@ -82,7 +83,7 @@ struct virtio_config_ops {
> > > > > > >       u32 (*generation)(struct virtio_device *vdev);
> > > > > > >       u8 (*get_status)(struct virtio_device *vdev);
> > > > > > >       void (*set_status)(struct virtio_device *vdev, u8 status);
> > > > > > > -    void (*reset)(struct virtio_device *vdev);
> > > > > > > +    int (*reset)(struct virtio_device *vdev);
> > > > > > >       int (*find_vqs)(struct virtio_device *, unsigned nvqs,
> > > > > > >               struct virtqueue *vqs[], vq_callback_t *callbacks[],
> > > > > > >               const char * const names[], const bool *ctx,
> > > > > > 
> > > > > 
> > > > 
> > > 
> > 

