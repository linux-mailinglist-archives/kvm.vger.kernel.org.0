Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFFF35D293
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 23:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240582AbhDLVXo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 17:23:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59844 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240295AbhDLVXn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Apr 2021 17:23:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618262604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GvP/tErD9e1+fzMdeH0Z2ejVXmCsyTPxRm5Ef0II10o=;
        b=do5uu3jwWdnAW82MRQH2AezkJfrrbvfYyvMXuWzK50nfFysiUbMbNfMt6uUcyAIb1iE3mK
        G4l33Kgk7C91qDTxnTxSfgU82E+Ks5950/htstRWQ2I8TDTQizsxCLRWr/f39MAildktOf
        6D3p42QjpWjWewKjM8z/gD2cYZqKJR0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-GZ_rbUi2Pey6b6GKm3qhvw-1; Mon, 12 Apr 2021 17:23:22 -0400
X-MC-Unique: GZ_rbUi2Pey6b6GKm3qhvw-1
Received: by mail-wm1-f69.google.com with SMTP id o22-20020a1ca5160000b0290126af94672aso212452wme.2
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 14:23:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=GvP/tErD9e1+fzMdeH0Z2ejVXmCsyTPxRm5Ef0II10o=;
        b=j+nyc9nbP6OGhYcuLJpsQm0m0M21Pvrinb6FYstBQcy0/9EurmXk6XWxYZX4rhEgEe
         6abdXXxfnEFiMdh/qCTstT6dn9Rag5zFsJKg1pdFRPsPxZ9JTUJw0JhNby5nDBfCx/EQ
         TBktQfiNnj4MRy/QphlXaXyMFiSoSnhArQZlI5mhvRqK9uNmxmnmqir2K78OTcSTvUm3
         6tjaeAs6Pam6bPeuukBtjCYDx3nnujZn2JJgMpHJK7kMABL9XgSLxbMwBzmmzRgDx4kR
         vM7xQqe49rhqORetQOy2QuOIHNkaNL3VLjpA/sblsYTuGrv0LR5/z53a/xMIVa3R6W/0
         DiDg==
X-Gm-Message-State: AOAM5330Z1mP45ZDNHiclHe4VWA1lX5LhNox4VUDakmOB2c/H8HXOk/Q
        +2FKp+hmuduioVtrSXEIUzzOJg7iXzx3+Ubv8NjH8ey5rFv6uK2PmS3t9Jzf5MWF03FA/Lpavuq
        wd6koVFT4/eD7
X-Received: by 2002:adf:f403:: with SMTP id g3mr33018213wro.367.1618262601256;
        Mon, 12 Apr 2021 14:23:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxSAdtuHQ+Dn7LmIQl700F9pQ7SeQBzkb1U38t8iayK+tw/Ge8UZhrl+YyBMnG58bAK8jvmCA==
X-Received: by 2002:adf:f403:: with SMTP id g3mr33018199wro.367.1618262600958;
        Mon, 12 Apr 2021 14:23:20 -0700 (PDT)
Received: from redhat.com ([2a10:8006:2281:0:1994:c627:9eac:1825])
        by smtp.gmail.com with ESMTPSA id m15sm17095738wrp.96.2021.04.12.14.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 14:23:19 -0700 (PDT)
Date:   Mon, 12 Apr 2021 17:23:16 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, oren@nvidia.com,
        nitzanc@nvidia.com, cohuck@redhat.com
Subject: Re: [PATCH v2 1/3] virtio: update reset callback to return status
Message-ID: <20210412171858-mutt-send-email-mst@kernel.org>
References: <20210408081109.56537-1-mgurtovoy@nvidia.com>
 <16fa0e31-a305-3b41-b0d3-ad76aa00177b@redhat.com>
 <1f134102-4ccb-57e3-858d-3922d851ce8a@nvidia.com>
 <20210408115524-mutt-send-email-mst@kernel.org>
 <31fa92ca-bce5-b71f-406d-8f3951b2143c@nvidia.com>
 <20210412080051-mutt-send-email-mst@kernel.org>
 <b99e324b-3a78-b3ed-98a8-a3b88a271338@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b99e324b-3a78-b3ed-98a8-a3b88a271338@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 12, 2021 at 04:03:02PM +0300, Max Gurtovoy wrote:
> 
> On 4/12/2021 3:04 PM, Michael S. Tsirkin wrote:
> > On Mon, Apr 12, 2021 at 02:55:27PM +0300, Max Gurtovoy wrote:
> > > On 4/8/2021 6:56 PM, Michael S. Tsirkin wrote:
> > > > On Thu, Apr 08, 2021 at 12:56:52PM +0300, Max Gurtovoy wrote:
> > > > > On 4/8/2021 11:58 AM, Jason Wang wrote:
> > > > > > 在 2021/4/8 下午4:11, Max Gurtovoy 写道:
> > > > > > > The reset device operation, usually is an operation that might fail from
> > > > > > > various reasons. For example, the controller might be in a bad state and
> > > > > > > can't answer to any request. Usually, the paravirt SW based virtio
> > > > > > > devices always succeed in reset operation but this is not the case for
> > > > > > > HW based virtio devices.
> > > > > > I would like to know under what condition that the reset operation may
> > > > > > fail (except for the case of a bugg guest).
> > > > > The controller might not be ready or stuck. This is a real use case for many
> > > > > PCI devices.
> > > > > 
> > > > > For real devices the FW might be in a bad state and it can happen also for
> > > > > paravirt device if you have a bug in the controller code or if you entered
> > > > > some error flow (Out of memory).
> > > > > 
> > > > > You don't want to be stuck because of one bad device.
> > > > OK so maybe we can do more to detect the bad device.
> > > > Won't we get all 1's on a read in this case?
> > > No. how can we guarantee it ?
> > > 
> > Well this is what you tend to get if e.g. you disable device memory.
> > 
> > Anyway, you know about hardware, I don't ... It's not returning 0 after
> > reset as it should ... what does it return? Hopefully not random noise -
> > I don't think it's very practical to write a driver for a device that
> > starts doing that at random times ...
> 
> The device may return 0x40 (NEEDS_RESET). It doesn't have to return all 1's.
>
> For paravirt devices, think of a situation that you can't allocate some
> internal buffers (malloc failed) and you want to wait for few seconds until
> the system memory will free some pages.
> 
> So you may return NEEDS_RESET that indicates some error state of the device.
> Once the system memory freed by other application for example, your internal
> virtio device malloc succeeded and you may return 0.
> 
> In this case, you don't want to stall the other virtio devices to probe
> (they might be real HW devices that driven by the same driver), right ?

So the device is very busy then? Not sure it's smart to just assume
it's safe to free all memory allocated for it then ...

I guess the lesson is don't make device reset depend on malloc
of some memory?



> 
> > 
> > > > 
> > > > > > > This commit is also a preparation for adding a timeout mechanism for
> > > > > > > resetting virtio devices.
> > > > > > > 
> > > > > > > Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> > > > > > > ---
> > > > > > > 
> > > > > > > changes from v1:
> > > > > > >     - update virtio_ccw.c (Cornelia)
> > > > > > >     - update virtio_uml.c
> > > > > > >     - update mlxbf-tmfifo.c
> > > > > > Note that virtio driver may call reset, so you probably need to convert
> > > > > > them.
> > > > > I'm sure I understand.
> > > > > 
> > > > > Convert to what ?
> > > > > 
> > > > > Thanks.
> > > > > 
> > > > > > Thanks
> > > > > > 
> > > > > > 
> > > > > > > ---
> > > > > > >     arch/um/drivers/virtio_uml.c             |  4 +++-
> > > > > > >     drivers/platform/mellanox/mlxbf-tmfifo.c |  4 +++-
> > > > > > >     drivers/remoteproc/remoteproc_virtio.c   |  4 +++-
> > > > > > >     drivers/s390/virtio/virtio_ccw.c         |  9 ++++++---
> > > > > > >     drivers/virtio/virtio.c                  | 22 +++++++++++++++-------
> > > > > > >     drivers/virtio/virtio_mmio.c             |  3 ++-
> > > > > > >     drivers/virtio/virtio_pci_legacy.c       |  4 +++-
> > > > > > >     drivers/virtio/virtio_pci_modern.c       |  3 ++-
> > > > > > >     drivers/virtio/virtio_vdpa.c             |  4 +++-
> > > > > > >     include/linux/virtio_config.h            |  5 +++--
> > > > > > >     10 files changed, 43 insertions(+), 19 deletions(-)
> > > > > > > 
> > > > > > > diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
> > > > > > > index 91ddf74ca888..b6e66265ed32 100644
> > > > > > > --- a/arch/um/drivers/virtio_uml.c
> > > > > > > +++ b/arch/um/drivers/virtio_uml.c
> > > > > > > @@ -827,11 +827,13 @@ static void vu_set_status(struct virtio_device
> > > > > > > *vdev, u8 status)
> > > > > > >         vu_dev->status = status;
> > > > > > >     }
> > > > > > >     -static void vu_reset(struct virtio_device *vdev)
> > > > > > > +static int vu_reset(struct virtio_device *vdev)
> > > > > > >     {
> > > > > > >         struct virtio_uml_device *vu_dev = to_virtio_uml_device(vdev);
> > > > > > >           vu_dev->status = 0;
> > > > > > > +
> > > > > > > +    return 0;
> > > > > > >     }
> > > > > > >       static void vu_del_vq(struct virtqueue *vq)
> > > > > > > diff --git a/drivers/platform/mellanox/mlxbf-tmfifo.c
> > > > > > > b/drivers/platform/mellanox/mlxbf-tmfifo.c
> > > > > > > index bbc4e71a16ff..c192b8ac5d9e 100644
> > > > > > > --- a/drivers/platform/mellanox/mlxbf-tmfifo.c
> > > > > > > +++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
> > > > > > > @@ -980,11 +980,13 @@ static void
> > > > > > > mlxbf_tmfifo_virtio_set_status(struct virtio_device *vdev,
> > > > > > >     }
> > > > > > >       /* Reset the device. Not much here for now. */
> > > > > > > -static void mlxbf_tmfifo_virtio_reset(struct virtio_device *vdev)
> > > > > > > +static int mlxbf_tmfifo_virtio_reset(struct virtio_device *vdev)
> > > > > > >     {
> > > > > > >         struct mlxbf_tmfifo_vdev *tm_vdev = mlxbf_vdev_to_tmfifo(vdev);
> > > > > > >           tm_vdev->status = 0;
> > > > > > > +
> > > > > > > +    return 0;
> > > > > > >     }
> > > > > > >       /* Read the value of a configuration field. */
> > > > > > > diff --git a/drivers/remoteproc/remoteproc_virtio.c
> > > > > > > b/drivers/remoteproc/remoteproc_virtio.c
> > > > > > > index 0cc617f76068..ca9573c62c3d 100644
> > > > > > > --- a/drivers/remoteproc/remoteproc_virtio.c
> > > > > > > +++ b/drivers/remoteproc/remoteproc_virtio.c
> > > > > > > @@ -191,7 +191,7 @@ static void rproc_virtio_set_status(struct
> > > > > > > virtio_device *vdev, u8 status)
> > > > > > >         dev_dbg(&vdev->dev, "status: %d\n", status);
> > > > > > >     }
> > > > > > >     -static void rproc_virtio_reset(struct virtio_device *vdev)
> > > > > > > +static int rproc_virtio_reset(struct virtio_device *vdev)
> > > > > > >     {
> > > > > > >         struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
> > > > > > >         struct fw_rsc_vdev *rsc;
> > > > > > > @@ -200,6 +200,8 @@ static void rproc_virtio_reset(struct
> > > > > > > virtio_device *vdev)
> > > > > > >           rsc->status = 0;
> > > > > > >         dev_dbg(&vdev->dev, "reset !\n");
> > > > > > > +
> > > > > > > +    return 0;
> > > > > > >     }
> > > > > > >       /* provide the vdev features as retrieved from the firmware */
> > > > > > > diff --git a/drivers/s390/virtio/virtio_ccw.c
> > > > > > > b/drivers/s390/virtio/virtio_ccw.c
> > > > > > > index 54e686dca6de..52b32555e746 100644
> > > > > > > --- a/drivers/s390/virtio/virtio_ccw.c
> > > > > > > +++ b/drivers/s390/virtio/virtio_ccw.c
> > > > > > > @@ -732,14 +732,15 @@ static int virtio_ccw_find_vqs(struct
> > > > > > > virtio_device *vdev, unsigned nvqs,
> > > > > > >         return ret;
> > > > > > >     }
> > > > > > >     -static void virtio_ccw_reset(struct virtio_device *vdev)
> > > > > > > +static int virtio_ccw_reset(struct virtio_device *vdev)
> > > > > > >     {
> > > > > > >         struct virtio_ccw_device *vcdev = to_vc_device(vdev);
> > > > > > >         struct ccw1 *ccw;
> > > > > > > +    int ret;
> > > > > > >           ccw = ccw_device_dma_zalloc(vcdev->cdev, sizeof(*ccw));
> > > > > > >         if (!ccw)
> > > > > > > -        return;
> > > > > > > +        return -ENOMEM;
> > > > > > >           /* Zero status bits. */
> > > > > > >         vcdev->dma_area->status = 0;
> > > > > > > @@ -749,8 +750,10 @@ static void virtio_ccw_reset(struct
> > > > > > > virtio_device *vdev)
> > > > > > >         ccw->flags = 0;
> > > > > > >         ccw->count = 0;
> > > > > > >         ccw->cda = 0;
> > > > > > > -    ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_RESET);
> > > > > > > +    ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_RESET);
> > > > > > >         ccw_device_dma_free(vcdev->cdev, ccw, sizeof(*ccw));
> > > > > > > +
> > > > > > > +    return ret;
> > > > > > >     }
> > > > > > >       static u64 virtio_ccw_get_features(struct virtio_device *vdev)
> > > > > > > diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> > > > > > > index 4b15c00c0a0a..ddbfd5b5f3bd 100644
> > > > > > > --- a/drivers/virtio/virtio.c
> > > > > > > +++ b/drivers/virtio/virtio.c
> > > > > > > @@ -338,7 +338,7 @@ int register_virtio_device(struct virtio_device
> > > > > > > *dev)
> > > > > > >         /* Assign a unique device index and hence name. */
> > > > > > >         err = ida_simple_get(&virtio_index_ida, 0, 0, GFP_KERNEL);
> > > > > > >         if (err < 0)
> > > > > > > -        goto out;
> > > > > > > +        goto out_err;
> > > > > > >           dev->index = err;
> > > > > > >         dev_set_name(&dev->dev, "virtio%u", dev->index);
> > > > > > > @@ -349,7 +349,9 @@ int register_virtio_device(struct virtio_device
> > > > > > > *dev)
> > > > > > >           /* We always start by resetting the device, in case a previous
> > > > > > >          * driver messed it up.  This also tests that code path a
> > > > > > > little. */
> > > > > > > -    dev->config->reset(dev);
> > > > > > > +    err = dev->config->reset(dev);
> > > > > > > +    if (err)
> > > > > > > +        goto out_ida;
> > > > > > >           /* Acknowledge that we've seen the device. */
> > > > > > >         virtio_add_status(dev, VIRTIO_CONFIG_S_ACKNOWLEDGE);
> > > > > > > @@ -362,10 +364,14 @@ int register_virtio_device(struct
> > > > > > > virtio_device *dev)
> > > > > > >          */
> > > > > > >         err = device_add(&dev->dev);
> > > > > > >         if (err)
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
> > > > > > >         return err;
> > > > > > >     }
> > > > > > >     EXPORT_SYMBOL_GPL(register_virtio_device);
> > > > > > > @@ -408,7 +414,9 @@ int virtio_device_restore(struct virtio_device *dev)
> > > > > > >           /* We always start by resetting the device, in case a previous
> > > > > > >          * driver messed it up. */
> > > > > > > -    dev->config->reset(dev);
> > > > > > > +    ret = dev->config->reset(dev);
> > > > > > > +    if (ret)
> > > > > > > +        goto err;
> > > > > > >           /* Acknowledge that we've seen the device. */
> > > > > > >         virtio_add_status(dev, VIRTIO_CONFIG_S_ACKNOWLEDGE);
> > > > > > > diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> > > > > > > index 56128b9c46eb..12b8f048c48d 100644
> > > > > > > --- a/drivers/virtio/virtio_mmio.c
> > > > > > > +++ b/drivers/virtio/virtio_mmio.c
> > > > > > > @@ -256,12 +256,13 @@ static void vm_set_status(struct virtio_device
> > > > > > > *vdev, u8 status)
> > > > > > >         writel(status, vm_dev->base + VIRTIO_MMIO_STATUS);
> > > > > > >     }
> > > > > > >     -static void vm_reset(struct virtio_device *vdev)
> > > > > > > +static int vm_reset(struct virtio_device *vdev)
> > > > > > >     {
> > > > > > >         struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
> > > > > > >           /* 0 status means a reset. */
> > > > > > >         writel(0, vm_dev->base + VIRTIO_MMIO_STATUS);
> > > > > > > +    return 0;
> > > > > > >     }
> > > > > > >       diff --git a/drivers/virtio/virtio_pci_legacy.c
> > > > > > > b/drivers/virtio/virtio_pci_legacy.c
> > > > > > > index d62e9835aeec..0b5d95e3efa1 100644
> > > > > > > --- a/drivers/virtio/virtio_pci_legacy.c
> > > > > > > +++ b/drivers/virtio/virtio_pci_legacy.c
> > > > > > > @@ -89,7 +89,7 @@ static void vp_set_status(struct virtio_device
> > > > > > > *vdev, u8 status)
> > > > > > >         iowrite8(status, vp_dev->ioaddr + VIRTIO_PCI_STATUS);
> > > > > > >     }
> > > > > > >     -static void vp_reset(struct virtio_device *vdev)
> > > > > > > +static int vp_reset(struct virtio_device *vdev)
> > > > > > >     {
> > > > > > >         struct virtio_pci_device *vp_dev = to_vp_device(vdev);
> > > > > > >         /* 0 status means a reset. */
> > > > > > > @@ -99,6 +99,8 @@ static void vp_reset(struct virtio_device *vdev)
> > > > > > >         ioread8(vp_dev->ioaddr + VIRTIO_PCI_STATUS);
> > > > > > >         /* Flush pending VQ/configuration callbacks. */
> > > > > > >         vp_synchronize_vectors(vdev);
> > > > > > > +
> > > > > > > +    return 0;
> > > > > > >     }
> > > > > > >       static u16 vp_config_vector(struct virtio_pci_device *vp_dev,
> > > > > > > u16 vector)
> > > > > > > diff --git a/drivers/virtio/virtio_pci_modern.c
> > > > > > > b/drivers/virtio/virtio_pci_modern.c
> > > > > > > index fbd4ebc00eb6..cc3412a96a17 100644
> > > > > > > --- a/drivers/virtio/virtio_pci_modern.c
> > > > > > > +++ b/drivers/virtio/virtio_pci_modern.c
> > > > > > > @@ -158,7 +158,7 @@ static void vp_set_status(struct virtio_device
> > > > > > > *vdev, u8 status)
> > > > > > >         vp_modern_set_status(&vp_dev->mdev, status);
> > > > > > >     }
> > > > > > >     -static void vp_reset(struct virtio_device *vdev)
> > > > > > > +static int vp_reset(struct virtio_device *vdev)
> > > > > > >     {
> > > > > > >         struct virtio_pci_device *vp_dev = to_vp_device(vdev);
> > > > > > >         struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
> > > > > > > @@ -174,6 +174,7 @@ static void vp_reset(struct virtio_device *vdev)
> > > > > > >             msleep(1);
> > > > > > >         /* Flush pending VQ/configuration callbacks. */
> > > > > > >         vp_synchronize_vectors(vdev);
> > > > > > > +    return 0;
> > > > > > >     }
> > > > > > >       static u16 vp_config_vector(struct virtio_pci_device *vp_dev,
> > > > > > > u16 vector)
> > > > > > > diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
> > > > > > > index e28acf482e0c..5fd4e627a9b0 100644
> > > > > > > --- a/drivers/virtio/virtio_vdpa.c
> > > > > > > +++ b/drivers/virtio/virtio_vdpa.c
> > > > > > > @@ -97,11 +97,13 @@ static void virtio_vdpa_set_status(struct
> > > > > > > virtio_device *vdev, u8 status)
> > > > > > >         return ops->set_status(vdpa, status);
> > > > > > >     }
> > > > > > >     -static void virtio_vdpa_reset(struct virtio_device *vdev)
> > > > > > > +static int virtio_vdpa_reset(struct virtio_device *vdev)
> > > > > > >     {
> > > > > > >         struct vdpa_device *vdpa = vd_get_vdpa(vdev);
> > > > > > >           vdpa_reset(vdpa);
> > > > > > > +
> > > > > > > +    return 0;
> > > > > > >     }
> > > > > > >       static bool virtio_vdpa_notify(struct virtqueue *vq)
> > > > > > > diff --git a/include/linux/virtio_config.h
> > > > > > > b/include/linux/virtio_config.h
> > > > > > > index 8519b3ae5d52..d2b0f1699a75 100644
> > > > > > > --- a/include/linux/virtio_config.h
> > > > > > > +++ b/include/linux/virtio_config.h
> > > > > > > @@ -44,9 +44,10 @@ struct virtio_shm_region {
> > > > > > >      *    status: the new status byte
> > > > > > >      * @reset: reset the device
> > > > > > >      *    vdev: the virtio device
> > > > > > > - *    After this, status and feature negotiation must be done again
> > > > > > > + *    Upon success, status and feature negotiation must be done again
> > > > > > >      *    Device must not be reset from its vq/config callbacks, or in
> > > > > > >      *    parallel with being added/removed.
> > > > > > > + *    Returns 0 on success or error status.
> > > > > > >      * @find_vqs: find virtqueues and instantiate them.
> > > > > > >      *    vdev: the virtio_device
> > > > > > >      *    nvqs: the number of virtqueues to find
> > > > > > > @@ -82,7 +83,7 @@ struct virtio_config_ops {
> > > > > > >         u32 (*generation)(struct virtio_device *vdev);
> > > > > > >         u8 (*get_status)(struct virtio_device *vdev);
> > > > > > >         void (*set_status)(struct virtio_device *vdev, u8 status);
> > > > > > > -    void (*reset)(struct virtio_device *vdev);
> > > > > > > +    int (*reset)(struct virtio_device *vdev);
> > > > > > >         int (*find_vqs)(struct virtio_device *, unsigned nvqs,
> > > > > > >                 struct virtqueue *vqs[], vq_callback_t *callbacks[],
> > > > > > >                 const char * const names[], const bool *ctx,

