Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3B8276C57
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 10:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbgIXIuE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 04:50:04 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14227 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726786AbgIXIuE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Sep 2020 04:50:04 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E1988906A3711F42ACCA;
        Thu, 24 Sep 2020 16:49:59 +0800 (CST)
Received: from [10.174.185.226] (10.174.185.226) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Thu, 24 Sep 2020 16:49:53 +0800
Subject: Re: [PATCH v10 05/11] vfio/pci: Register an iommu fault handler
To:     Eric Auger <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <joro@8bytes.org>, <alex.williamson@redhat.com>,
        <jacob.jun.pan@linux.intel.com>, <yi.l.liu@intel.com>,
        <robin.murphy@arm.com>
References: <20200320161911.27494-1-eric.auger@redhat.com>
 <20200320161911.27494-6-eric.auger@redhat.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <571978ff-ee8a-6e9f-6755-519d0871646f@huawei.com>
Date:   Thu, 24 Sep 2020 16:49:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200320161911.27494-6-eric.auger@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.226]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 2020/3/21 0:19, Eric Auger wrote:
> Register an IOMMU fault handler which records faults in
> the DMA FAULT region ring buffer. In a subsequent patch, we
> will add the signaling of a specific eventfd to allow the
> userspace to be notified whenever a new fault as shown up.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

[...]

> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 586b89debed5..69595c240baf 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -27,6 +27,7 @@
>   #include <linux/vfio.h>
>   #include <linux/vgaarb.h>
>   #include <linux/nospec.h>
> +#include <linux/circ_buf.h>
>   
>   #include "vfio_pci_private.h"
>   
> @@ -283,6 +284,38 @@ static const struct vfio_pci_regops vfio_pci_dma_fault_regops = {
>   	.add_capability = vfio_pci_dma_fault_add_capability,
>   };
>   
> +int vfio_pci_iommu_dev_fault_handler(struct iommu_fault *fault, void *data)
> +{
> +	struct vfio_pci_device *vdev = (struct vfio_pci_device *)data;
> +	struct vfio_region_dma_fault *reg =
> +		(struct vfio_region_dma_fault *)vdev->fault_pages;
> +	struct iommu_fault *new =
> +		(struct iommu_fault *)(vdev->fault_pages + reg->offset +
> +			reg->head * reg->entry_size);

Shouldn't 'reg->head' be protected under the fault_queue_lock? Otherwise
things may change behind our backs...

We shouldn't take any assumption about how IOMMU driver would report the
fault (serially or in parallel), I think.

> +	int head, tail, size;
> +	int ret = 0;
> +
> +	if (fault->type != IOMMU_FAULT_DMA_UNRECOV)
> +		return -ENOENT;
> +
> +	mutex_lock(&vdev->fault_queue_lock);
> +
> +	head = reg->head;
> +	tail = reg->tail;
> +	size = reg->nb_entries;
> +
> +	if (CIRC_SPACE(head, tail, size) < 1) {
> +		ret = -ENOSPC;
> +		goto unlock;
> +	}
> +
> +	*new = *fault;
> +	reg->head = (head + 1) % size;
> +unlock:
> +	mutex_unlock(&vdev->fault_queue_lock);
> +	return ret;
> +}
> +
>   #define DMA_FAULT_RING_LENGTH 512
>   
>   static int vfio_pci_init_dma_fault_region(struct vfio_pci_device *vdev)
> @@ -317,6 +350,13 @@ static int vfio_pci_init_dma_fault_region(struct vfio_pci_device *vdev)
>   	header->entry_size = sizeof(struct iommu_fault);
>   	header->nb_entries = DMA_FAULT_RING_LENGTH;
>   	header->offset = sizeof(struct vfio_region_dma_fault);
> +
> +	ret = iommu_register_device_fault_handler(&vdev->pdev->dev,
> +					vfio_pci_iommu_dev_fault_handler,
> +					vdev);
> +	if (ret)
> +		goto out;
> +
>   	return 0;
>   out:
>   	kfree(vdev->fault_pages);


Thanks,
Zenghui
