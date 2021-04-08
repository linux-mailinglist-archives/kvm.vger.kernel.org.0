Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9490735845B
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 15:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbhDHNPL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 09:15:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50732 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229751AbhDHNPL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Apr 2021 09:15:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617887699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fN1qc7MCiKiWpPQpSySyrT0QSnGe8GWASP5SuBzWIUE=;
        b=EbNKuOXVVvP10lvwqN/3Wg+Yk4IPu3Q+4T1GqwmJ1BS2hw+6Fitqzu0+RrDOEHX5U5DaE/
        b3eHz8UFTjO74pkmHiyvbbr+E05bQ0Ml+Hd5geZ5WyHKj0X2fnw6RYILRAJ95U2qdBpms3
        rUPtyuDUcyZd3SLMgNlFLi6PzNjv4aA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-hPZNfZbXPlmsWdZ8aqcBBQ-1; Thu, 08 Apr 2021 09:14:57 -0400
X-MC-Unique: hPZNfZbXPlmsWdZ8aqcBBQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48CF6193578C;
        Thu,  8 Apr 2021 13:14:56 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-93.pek2.redhat.com [10.72.12.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4134E10013D7;
        Thu,  8 Apr 2021 13:14:49 +0000 (UTC)
Subject: Re: [PATCH v2 1/3] virtio: update reset callback to return status
To:     Max Gurtovoy <mgurtovoy@nvidia.com>, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Cc:     oren@nvidia.com, nitzanc@nvidia.com, cohuck@redhat.com
References: <20210408081109.56537-1-mgurtovoy@nvidia.com>
 <16fa0e31-a305-3b41-b0d3-ad76aa00177b@redhat.com>
 <1f134102-4ccb-57e3-858d-3922d851ce8a@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a46cef9b-b8da-b748-c332-a3a05bd9135f@redhat.com>
Date:   Thu, 8 Apr 2021 21:14:47 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <1f134102-4ccb-57e3-858d-3922d851ce8a@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2021/4/8 下午5:56, Max Gurtovoy 写道:
>
> On 4/8/2021 11:58 AM, Jason Wang wrote:
>>
>> 在 2021/4/8 下午4:11, Max Gurtovoy 写道:
>>> The reset device operation, usually is an operation that might fail 
>>> from
>>> various reasons. For example, the controller might be in a bad state 
>>> and
>>> can't answer to any request. Usually, the paravirt SW based virtio
>>> devices always succeed in reset operation but this is not the case for
>>> HW based virtio devices.
>>
>>
>> I would like to know under what condition that the reset operation 
>> may fail (except for the case of a bugg guest).
>
> The controller might not be ready or stuck. This is a real use case 
> for many PCI devices.
>
> For real devices the FW might be in a bad state and it can happen also 
> for paravirt device if you have a bug in the controller code or if you 
> entered some error flow (Out of memory).
>
> You don't want to be stuck because of one bad device.


So the buggy driver can damage the host through various ways, I'm not 
sure doing such workaround is worthwhile.

Note that this driver has been used for real hardware PCI devices for 
many years. We don't receive any report of this before.


>
>
>>
>>
>>>
>>> This commit is also a preparation for adding a timeout mechanism for
>>> resetting virtio devices.
>>>
>>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>>> ---
>>>
>>> changes from v1:
>>>   - update virtio_ccw.c (Cornelia)
>>>   - update virtio_uml.c
>>>   - update mlxbf-tmfifo.c
>>
>>
>> Note that virtio driver may call reset, so you probably need to 
>> convert them.
>
> I'm sure I understand.
>
> Convert to what ?


Convert to deal with the possible rest failure. E.g in virtblk_freeze() 
we had:

static int virtblk_freeze(struct virtio_device *vdev)
{
         struct virtio_blk *vblk = vdev->priv;

         /* Ensure we don't receive any more interrupts */
         vdev->config->reset(vdev);
...

We need fail the freeze here.

Another example is the driver remove which is not expected to be fail. A 
lot of virtio drivers tries to call reset there. I'm not sure how hard 
to deal with the failure in the path of remove (e.g 
__device_release_driver tends to ignore the return value of bus->remove().)

Thanks


>
> Thanks.
>
>>
>> Thanks
>>
>>
>>>
>>> ---
>>>   arch/um/drivers/virtio_uml.c             |  4 +++-
>>>   drivers/platform/mellanox/mlxbf-tmfifo.c |  4 +++-
>>>   drivers/remoteproc/remoteproc_virtio.c   |  4 +++-
>>>   drivers/s390/virtio/virtio_ccw.c         |  9 ++++++---
>>>   drivers/virtio/virtio.c                  | 22 +++++++++++++++-------
>>>   drivers/virtio/virtio_mmio.c             |  3 ++-
>>>   drivers/virtio/virtio_pci_legacy.c       |  4 +++-
>>>   drivers/virtio/virtio_pci_modern.c       |  3 ++-
>>>   drivers/virtio/virtio_vdpa.c             |  4 +++-
>>>   include/linux/virtio_config.h            |  5 +++--
>>>   10 files changed, 43 insertions(+), 19 deletions(-)
>>>
>>> diff --git a/arch/um/drivers/virtio_uml.c 
>>> b/arch/um/drivers/virtio_uml.c
>>> index 91ddf74ca888..b6e66265ed32 100644
>>> --- a/arch/um/drivers/virtio_uml.c
>>> +++ b/arch/um/drivers/virtio_uml.c
>>> @@ -827,11 +827,13 @@ static void vu_set_status(struct virtio_device 
>>> *vdev, u8 status)
>>>       vu_dev->status = status;
>>>   }
>>>   -static void vu_reset(struct virtio_device *vdev)
>>> +static int vu_reset(struct virtio_device *vdev)
>>>   {
>>>       struct virtio_uml_device *vu_dev = to_virtio_uml_device(vdev);
>>>         vu_dev->status = 0;
>>> +
>>> +    return 0;
>>>   }
>>>     static void vu_del_vq(struct virtqueue *vq)
>>> diff --git a/drivers/platform/mellanox/mlxbf-tmfifo.c 
>>> b/drivers/platform/mellanox/mlxbf-tmfifo.c
>>> index bbc4e71a16ff..c192b8ac5d9e 100644
>>> --- a/drivers/platform/mellanox/mlxbf-tmfifo.c
>>> +++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
>>> @@ -980,11 +980,13 @@ static void 
>>> mlxbf_tmfifo_virtio_set_status(struct virtio_device *vdev,
>>>   }
>>>     /* Reset the device. Not much here for now. */
>>> -static void mlxbf_tmfifo_virtio_reset(struct virtio_device *vdev)
>>> +static int mlxbf_tmfifo_virtio_reset(struct virtio_device *vdev)
>>>   {
>>>       struct mlxbf_tmfifo_vdev *tm_vdev = mlxbf_vdev_to_tmfifo(vdev);
>>>         tm_vdev->status = 0;
>>> +
>>> +    return 0;
>>>   }
>>>     /* Read the value of a configuration field. */
>>> diff --git a/drivers/remoteproc/remoteproc_virtio.c 
>>> b/drivers/remoteproc/remoteproc_virtio.c
>>> index 0cc617f76068..ca9573c62c3d 100644
>>> --- a/drivers/remoteproc/remoteproc_virtio.c
>>> +++ b/drivers/remoteproc/remoteproc_virtio.c
>>> @@ -191,7 +191,7 @@ static void rproc_virtio_set_status(struct 
>>> virtio_device *vdev, u8 status)
>>>       dev_dbg(&vdev->dev, "status: %d\n", status);
>>>   }
>>>   -static void rproc_virtio_reset(struct virtio_device *vdev)
>>> +static int rproc_virtio_reset(struct virtio_device *vdev)
>>>   {
>>>       struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
>>>       struct fw_rsc_vdev *rsc;
>>> @@ -200,6 +200,8 @@ static void rproc_virtio_reset(struct 
>>> virtio_device *vdev)
>>>         rsc->status = 0;
>>>       dev_dbg(&vdev->dev, "reset !\n");
>>> +
>>> +    return 0;
>>>   }
>>>     /* provide the vdev features as retrieved from the firmware */
>>> diff --git a/drivers/s390/virtio/virtio_ccw.c 
>>> b/drivers/s390/virtio/virtio_ccw.c
>>> index 54e686dca6de..52b32555e746 100644
>>> --- a/drivers/s390/virtio/virtio_ccw.c
>>> +++ b/drivers/s390/virtio/virtio_ccw.c
>>> @@ -732,14 +732,15 @@ static int virtio_ccw_find_vqs(struct 
>>> virtio_device *vdev, unsigned nvqs,
>>>       return ret;
>>>   }
>>>   -static void virtio_ccw_reset(struct virtio_device *vdev)
>>> +static int virtio_ccw_reset(struct virtio_device *vdev)
>>>   {
>>>       struct virtio_ccw_device *vcdev = to_vc_device(vdev);
>>>       struct ccw1 *ccw;
>>> +    int ret;
>>>         ccw = ccw_device_dma_zalloc(vcdev->cdev, sizeof(*ccw));
>>>       if (!ccw)
>>> -        return;
>>> +        return -ENOMEM;
>>>         /* Zero status bits. */
>>>       vcdev->dma_area->status = 0;
>>> @@ -749,8 +750,10 @@ static void virtio_ccw_reset(struct 
>>> virtio_device *vdev)
>>>       ccw->flags = 0;
>>>       ccw->count = 0;
>>>       ccw->cda = 0;
>>> -    ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_RESET);
>>> +    ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_RESET);
>>>       ccw_device_dma_free(vcdev->cdev, ccw, sizeof(*ccw));
>>> +
>>> +    return ret;
>>>   }
>>>     static u64 virtio_ccw_get_features(struct virtio_device *vdev)
>>> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
>>> index 4b15c00c0a0a..ddbfd5b5f3bd 100644
>>> --- a/drivers/virtio/virtio.c
>>> +++ b/drivers/virtio/virtio.c
>>> @@ -338,7 +338,7 @@ int register_virtio_device(struct virtio_device 
>>> *dev)
>>>       /* Assign a unique device index and hence name. */
>>>       err = ida_simple_get(&virtio_index_ida, 0, 0, GFP_KERNEL);
>>>       if (err < 0)
>>> -        goto out;
>>> +        goto out_err;
>>>         dev->index = err;
>>>       dev_set_name(&dev->dev, "virtio%u", dev->index);
>>> @@ -349,7 +349,9 @@ int register_virtio_device(struct virtio_device 
>>> *dev)
>>>         /* We always start by resetting the device, in case a previous
>>>        * driver messed it up.  This also tests that code path a 
>>> little. */
>>> -    dev->config->reset(dev);
>>> +    err = dev->config->reset(dev);
>>> +    if (err)
>>> +        goto out_ida;
>>>         /* Acknowledge that we've seen the device. */
>>>       virtio_add_status(dev, VIRTIO_CONFIG_S_ACKNOWLEDGE);
>>> @@ -362,10 +364,14 @@ int register_virtio_device(struct 
>>> virtio_device *dev)
>>>        */
>>>       err = device_add(&dev->dev);
>>>       if (err)
>>> -        ida_simple_remove(&virtio_index_ida, dev->index);
>>> -out:
>>> -    if (err)
>>> -        virtio_add_status(dev, VIRTIO_CONFIG_S_FAILED);
>>> +        goto out_ida;
>>> +
>>> +    return 0;
>>> +
>>> +out_ida:
>>> +    ida_simple_remove(&virtio_index_ida, dev->index);
>>> +out_err:
>>> +    virtio_add_status(dev, VIRTIO_CONFIG_S_FAILED);
>>>       return err;
>>>   }
>>>   EXPORT_SYMBOL_GPL(register_virtio_device);
>>> @@ -408,7 +414,9 @@ int virtio_device_restore(struct virtio_device 
>>> *dev)
>>>         /* We always start by resetting the device, in case a previous
>>>        * driver messed it up. */
>>> -    dev->config->reset(dev);
>>> +    ret = dev->config->reset(dev);
>>> +    if (ret)
>>> +        goto err;
>>>         /* Acknowledge that we've seen the device. */
>>>       virtio_add_status(dev, VIRTIO_CONFIG_S_ACKNOWLEDGE);
>>> diff --git a/drivers/virtio/virtio_mmio.c 
>>> b/drivers/virtio/virtio_mmio.c
>>> index 56128b9c46eb..12b8f048c48d 100644
>>> --- a/drivers/virtio/virtio_mmio.c
>>> +++ b/drivers/virtio/virtio_mmio.c
>>> @@ -256,12 +256,13 @@ static void vm_set_status(struct virtio_device 
>>> *vdev, u8 status)
>>>       writel(status, vm_dev->base + VIRTIO_MMIO_STATUS);
>>>   }
>>>   -static void vm_reset(struct virtio_device *vdev)
>>> +static int vm_reset(struct virtio_device *vdev)
>>>   {
>>>       struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
>>>         /* 0 status means a reset. */
>>>       writel(0, vm_dev->base + VIRTIO_MMIO_STATUS);
>>> +    return 0;
>>>   }
>>>     diff --git a/drivers/virtio/virtio_pci_legacy.c 
>>> b/drivers/virtio/virtio_pci_legacy.c
>>> index d62e9835aeec..0b5d95e3efa1 100644
>>> --- a/drivers/virtio/virtio_pci_legacy.c
>>> +++ b/drivers/virtio/virtio_pci_legacy.c
>>> @@ -89,7 +89,7 @@ static void vp_set_status(struct virtio_device 
>>> *vdev, u8 status)
>>>       iowrite8(status, vp_dev->ioaddr + VIRTIO_PCI_STATUS);
>>>   }
>>>   -static void vp_reset(struct virtio_device *vdev)
>>> +static int vp_reset(struct virtio_device *vdev)
>>>   {
>>>       struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>>>       /* 0 status means a reset. */
>>> @@ -99,6 +99,8 @@ static void vp_reset(struct virtio_device *vdev)
>>>       ioread8(vp_dev->ioaddr + VIRTIO_PCI_STATUS);
>>>       /* Flush pending VQ/configuration callbacks. */
>>>       vp_synchronize_vectors(vdev);
>>> +
>>> +    return 0;
>>>   }
>>>     static u16 vp_config_vector(struct virtio_pci_device *vp_dev, 
>>> u16 vector)
>>> diff --git a/drivers/virtio/virtio_pci_modern.c 
>>> b/drivers/virtio/virtio_pci_modern.c
>>> index fbd4ebc00eb6..cc3412a96a17 100644
>>> --- a/drivers/virtio/virtio_pci_modern.c
>>> +++ b/drivers/virtio/virtio_pci_modern.c
>>> @@ -158,7 +158,7 @@ static void vp_set_status(struct virtio_device 
>>> *vdev, u8 status)
>>>       vp_modern_set_status(&vp_dev->mdev, status);
>>>   }
>>>   -static void vp_reset(struct virtio_device *vdev)
>>> +static int vp_reset(struct virtio_device *vdev)
>>>   {
>>>       struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>>>       struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
>>> @@ -174,6 +174,7 @@ static void vp_reset(struct virtio_device *vdev)
>>>           msleep(1);
>>>       /* Flush pending VQ/configuration callbacks. */
>>>       vp_synchronize_vectors(vdev);
>>> +    return 0;
>>>   }
>>>     static u16 vp_config_vector(struct virtio_pci_device *vp_dev, 
>>> u16 vector)
>>> diff --git a/drivers/virtio/virtio_vdpa.c 
>>> b/drivers/virtio/virtio_vdpa.c
>>> index e28acf482e0c..5fd4e627a9b0 100644
>>> --- a/drivers/virtio/virtio_vdpa.c
>>> +++ b/drivers/virtio/virtio_vdpa.c
>>> @@ -97,11 +97,13 @@ static void virtio_vdpa_set_status(struct 
>>> virtio_device *vdev, u8 status)
>>>       return ops->set_status(vdpa, status);
>>>   }
>>>   -static void virtio_vdpa_reset(struct virtio_device *vdev)
>>> +static int virtio_vdpa_reset(struct virtio_device *vdev)
>>>   {
>>>       struct vdpa_device *vdpa = vd_get_vdpa(vdev);
>>>         vdpa_reset(vdpa);
>>> +
>>> +    return 0;
>>>   }
>>>     static bool virtio_vdpa_notify(struct virtqueue *vq)
>>> diff --git a/include/linux/virtio_config.h 
>>> b/include/linux/virtio_config.h
>>> index 8519b3ae5d52..d2b0f1699a75 100644
>>> --- a/include/linux/virtio_config.h
>>> +++ b/include/linux/virtio_config.h
>>> @@ -44,9 +44,10 @@ struct virtio_shm_region {
>>>    *    status: the new status byte
>>>    * @reset: reset the device
>>>    *    vdev: the virtio device
>>> - *    After this, status and feature negotiation must be done again
>>> + *    Upon success, status and feature negotiation must be done again
>>>    *    Device must not be reset from its vq/config callbacks, or in
>>>    *    parallel with being added/removed.
>>> + *    Returns 0 on success or error status.
>>>    * @find_vqs: find virtqueues and instantiate them.
>>>    *    vdev: the virtio_device
>>>    *    nvqs: the number of virtqueues to find
>>> @@ -82,7 +83,7 @@ struct virtio_config_ops {
>>>       u32 (*generation)(struct virtio_device *vdev);
>>>       u8 (*get_status)(struct virtio_device *vdev);
>>>       void (*set_status)(struct virtio_device *vdev, u8 status);
>>> -    void (*reset)(struct virtio_device *vdev);
>>> +    int (*reset)(struct virtio_device *vdev);
>>>       int (*find_vqs)(struct virtio_device *, unsigned nvqs,
>>>               struct virtqueue *vqs[], vq_callback_t *callbacks[],
>>>               const char * const names[], const bool *ctx,
>>
>

