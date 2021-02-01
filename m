Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55AEE30A1B1
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 06:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbhBAFzp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 00:55:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36110 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231645AbhBAFwq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 00:52:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612158653;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PyRg2mb7fS8awqsRMxtK0XCpw5C/ARLH4lL9K+4Y9N4=;
        b=PZgEFjxrQwXyH8WZDsTqhXqhQMtnE/OxnS4JBFCfHw7MmdO83PJ3om6m0raXtNSsNqhpos
        v5g8OR+TqigC651VB4v22DcEQdAWpHgl7/sUNV/xtMgP6UqiqWO0qvg4EGkMOlNnhlh7U1
        Al892pUJSNavnQ6asmUd6fDCRPqQZGQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-ETTtlz1bMICSMOwMQFcTKg-1; Mon, 01 Feb 2021 00:50:49 -0500
X-MC-Unique: ETTtlz1bMICSMOwMQFcTKg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 182D35B36B;
        Mon,  1 Feb 2021 05:50:48 +0000 (UTC)
Received: from [10.72.13.120] (ovpn-13-120.pek2.redhat.com [10.72.13.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 31C4460C5F;
        Mon,  1 Feb 2021 05:50:37 +0000 (UTC)
Subject: Re: [PATCH RFC v2 08/10] vdpa: add vdpa simulator for block device
To:     Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        kvm@vger.kernel.org
References: <20210128144127.113245-1-sgarzare@redhat.com>
 <20210128144127.113245-9-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f799046b-6c8e-7665-40ef-64b93e44a34f@redhat.com>
Date:   Mon, 1 Feb 2021 13:50:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210128144127.113245-9-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/1/28 下午10:41, Stefano Garzarella wrote:
> From: Max Gurtovoy <mgurtovoy@nvidia.com>
>
> This will allow running vDPA for virtio block protocol.
>
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> [sgarzare: various cleanups/fixes]
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
> v2:
> - rebased on top of other changes (dev_attr, get_config(), notify(), etc.)
> - memset to 0 the config structure in vdpasim_blk_get_config()
> - used vdpasim pointer in vdpasim_blk_get_config()
>
> v1:
> - Removed unused headers
> - Used cpu_to_vdpasim*() to store config fields
> - Replaced 'select VDPA_SIM' with 'depends on VDPA_SIM' since selected
>    option can not depend on other [Jason]
> - Start with a single queue for now [Jason]
> - Add comments to memory barriers
> ---
>   drivers/vdpa/vdpa_sim/vdpa_sim_blk.c | 145 +++++++++++++++++++++++++++
>   drivers/vdpa/Kconfig                 |   7 ++
>   drivers/vdpa/vdpa_sim/Makefile       |   1 +
>   3 files changed, 153 insertions(+)
>   create mode 100644 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
>
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
> new file mode 100644
> index 000000000000..999f9ca0b628
> --- /dev/null
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
> @@ -0,0 +1,145 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * VDPA simulator for block device.
> + *
> + * Copyright (c) 2020, Mellanox Technologies. All rights reserved.
> + *
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/kernel.h>
> +#include <linux/sched.h>
> +#include <linux/vringh.h>
> +#include <linux/vdpa.h>
> +#include <uapi/linux/virtio_blk.h>
> +
> +#include "vdpa_sim.h"
> +
> +#define DRV_VERSION  "0.1"
> +#define DRV_AUTHOR   "Max Gurtovoy <mgurtovoy@nvidia.com>"
> +#define DRV_DESC     "vDPA Device Simulator for block device"
> +#define DRV_LICENSE  "GPL v2"
> +
> +#define VDPASIM_BLK_FEATURES	(VDPASIM_FEATURES | \
> +				 (1ULL << VIRTIO_BLK_F_SIZE_MAX) | \
> +				 (1ULL << VIRTIO_BLK_F_SEG_MAX)  | \
> +				 (1ULL << VIRTIO_BLK_F_BLK_SIZE) | \
> +				 (1ULL << VIRTIO_BLK_F_TOPOLOGY) | \
> +				 (1ULL << VIRTIO_BLK_F_MQ))
> +
> +#define VDPASIM_BLK_CAPACITY	0x40000
> +#define VDPASIM_BLK_SIZE_MAX	0x1000
> +#define VDPASIM_BLK_SEG_MAX	32
> +#define VDPASIM_BLK_VQ_NUM	1
> +
> +static struct vdpasim *vdpasim_blk_dev;
> +
> +static void vdpasim_blk_work(struct work_struct *work)
> +{
> +	struct vdpasim *vdpasim = container_of(work, struct vdpasim, work);
> +	u8 status = VIRTIO_BLK_S_OK;
> +	int i;
> +
> +	spin_lock(&vdpasim->lock);
> +
> +	if (!(vdpasim->status & VIRTIO_CONFIG_S_DRIVER_OK))
> +		goto out;
> +
> +	for (i = 0; i < VDPASIM_BLK_VQ_NUM; i++) {
> +		struct vdpasim_virtqueue *vq = &vdpasim->vqs[i];
> +
> +		if (!vq->ready)
> +			continue;
> +
> +		while (vringh_getdesc_iotlb(&vq->vring, &vq->out_iov,
> +					    &vq->in_iov, &vq->head,
> +					    GFP_ATOMIC) > 0) {
> +			int write;
> +
> +			vq->in_iov.i = vq->in_iov.used - 1;
> +			write = vringh_iov_push_iotlb(&vq->vring, &vq->in_iov,
> +						      &status, 1);
> +			if (write <= 0)
> +				break;
> +
> +			/* Make sure data is wrote before advancing index */
> +			smp_wmb();
> +
> +			vringh_complete_iotlb(&vq->vring, vq->head, write);
> +
> +			/* Make sure used is visible before rasing the interrupt. */
> +			smp_wmb();
> +
> +			local_bh_disable();
> +			if (vringh_need_notify_iotlb(&vq->vring) > 0)
> +				vringh_notify(&vq->vring);
> +			local_bh_enable();
> +		}
> +	}
> +out:
> +	spin_unlock(&vdpasim->lock);
> +}
> +
> +static void vdpasim_blk_get_config(struct vdpasim *vdpasim, void *config)
> +{
> +	struct virtio_blk_config *blk_config =
> +		(struct virtio_blk_config *)config;
> +
> +	memset(config, 0, sizeof(struct virtio_blk_config));
> +
> +	blk_config->capacity = cpu_to_vdpasim64(vdpasim, VDPASIM_BLK_CAPACITY);
> +	blk_config->size_max = cpu_to_vdpasim32(vdpasim, VDPASIM_BLK_SIZE_MAX);
> +	blk_config->seg_max = cpu_to_vdpasim32(vdpasim, VDPASIM_BLK_SEG_MAX);
> +	blk_config->num_queues = cpu_to_vdpasim16(vdpasim, VDPASIM_BLK_VQ_NUM);
> +	blk_config->min_io_size = cpu_to_vdpasim16(vdpasim, 1);
> +	blk_config->opt_io_size = cpu_to_vdpasim32(vdpasim, 1);
> +	blk_config->blk_size = cpu_to_vdpasim32(vdpasim, SECTOR_SIZE);
> +}
> +
> +static int __init vdpasim_blk_init(void)
> +{
> +	struct vdpasim_dev_attr dev_attr = {};
> +	int ret;
> +
> +	dev_attr.id = VIRTIO_ID_BLOCK;
> +	dev_attr.supported_features = VDPASIM_BLK_FEATURES;
> +	dev_attr.nvqs = VDPASIM_BLK_VQ_NUM;
> +	dev_attr.config_size = sizeof(struct virtio_blk_config);
> +	dev_attr.get_config = vdpasim_blk_get_config;
> +	dev_attr.work_fn = vdpasim_blk_work;
> +	dev_attr.buffer_size = PAGE_SIZE;
> +
> +	vdpasim_blk_dev = vdpasim_create(&dev_attr);
> +	if (IS_ERR(vdpasim_blk_dev)) {
> +		ret = PTR_ERR(vdpasim_blk_dev);
> +		goto out;
> +	}
> +
> +	ret = vdpa_register_device(&vdpasim_blk_dev->vdpa);
> +	if (ret)
> +		goto put_dev;
> +
> +	return 0;
> +
> +put_dev:
> +	put_device(&vdpasim_blk_dev->vdpa.dev);
> +out:
> +	return ret;
> +}
> +
> +static void __exit vdpasim_blk_exit(void)
> +{
> +	struct vdpa_device *vdpa = &vdpasim_blk_dev->vdpa;
> +
> +	vdpa_unregister_device(vdpa);
> +}
> +
> +module_init(vdpasim_blk_init)
> +module_exit(vdpasim_blk_exit)
> +
> +MODULE_VERSION(DRV_VERSION);
> +MODULE_LICENSE(DRV_LICENSE);
> +MODULE_AUTHOR(DRV_AUTHOR);
> +MODULE_DESCRIPTION(DRV_DESC);
> diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
> index 21a23500f430..b8bd92cf04f9 100644
> --- a/drivers/vdpa/Kconfig
> +++ b/drivers/vdpa/Kconfig
> @@ -26,6 +26,13 @@ config VDPA_SIM_NET
>   	help
>   	  vDPA networking device simulator which loops TX traffic back to RX.
>   
> +config VDPA_SIM_BLOCK
> +	tristate "vDPA simulator for block device"
> +	depends on VDPA_SIM
> +	help
> +	  vDPA block device simulator which terminates IO request in a
> +	  memory buffer.
> +
>   config IFCVF
>   	tristate "Intel IFC VF vDPA driver"
>   	depends on PCI_MSI
> diff --git a/drivers/vdpa/vdpa_sim/Makefile b/drivers/vdpa/vdpa_sim/Makefile
> index 79d4536d347e..d458103302f2 100644
> --- a/drivers/vdpa/vdpa_sim/Makefile
> +++ b/drivers/vdpa/vdpa_sim/Makefile
> @@ -1,3 +1,4 @@
>   # SPDX-License-Identifier: GPL-2.0
>   obj-$(CONFIG_VDPA_SIM) += vdpa_sim.o
>   obj-$(CONFIG_VDPA_SIM_NET) += vdpa_sim_net.o
> +obj-$(CONFIG_VDPA_SIM_BLOCK) += vdpa_sim_blk.o

