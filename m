Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4DB30A1EE
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 07:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbhBAG1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 01:27:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23753 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231775AbhBAGFV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 01:05:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612159434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d640g0AhW4H0p1MPXlNtTw79RpilHCze4Mi87EihdeA=;
        b=JQ30XCia6RQN8/WsIBXUO/KhL39MLQQ+fWEwQZwFM2EUrivKnHS+Z9FY1cqN+yhc6hiljk
        4JgI6RqVF+Io6TiLuXSve8XtBQgPWkzunihs8grI4RQFgRmDKi7ncrDr+C4PByjnL4t5M8
        KqsGwhwCBL+2iRNw67bZZm9Tl90GIO0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-ic3WixtZMn-kEXpG8WCikA-1; Mon, 01 Feb 2021 01:03:52 -0500
X-MC-Unique: ic3WixtZMn-kEXpG8WCikA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E5C8801817;
        Mon,  1 Feb 2021 06:03:50 +0000 (UTC)
Received: from [10.72.13.120] (ovpn-13-120.pek2.redhat.com [10.72.13.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1C775D9DC;
        Mon,  1 Feb 2021 06:03:40 +0000 (UTC)
Subject: Re: [PATCH RFC v2 09/10] vdpa_sim_blk: implement ramdisk behaviour
To:     Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        kvm@vger.kernel.org
References: <20210128144127.113245-1-sgarzare@redhat.com>
 <20210128144127.113245-10-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <7084ff0d-6dd3-66bc-1c34-4f9f99970d97@redhat.com>
Date:   Mon, 1 Feb 2021 14:03:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210128144127.113245-10-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/1/28 下午10:41, Stefano Garzarella wrote:
> The previous implementation wrote only the status of each request.
> This patch implements a more accurate block device simulator,
> providing a ramdisk-like behavior.
>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
> v2:
> - used %zd %zx to print size_t and ssize_t variables in dev_err()
> - removed unnecessary new line [Jason]
> - moved VIRTIO_BLK_T_GET_ID in another patch [Jason]
> - used push/pull instead of write/read terminology
> - added vdpasim_blk_check_range() to avoid overflows [Stefan]
> - use vdpasim*_to_cpu instead of le*_to_cpu
> - used vringh_kiov_length() helper [Jason]


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vdpa/vdpa_sim/vdpa_sim_blk.c | 164 ++++++++++++++++++++++++---
>   1 file changed, 146 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
> index 999f9ca0b628..fc47e8320358 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
> @@ -3,6 +3,7 @@
>    * VDPA simulator for block device.
>    *
>    * Copyright (c) 2020, Mellanox Technologies. All rights reserved.
> + * Copyright (c) 2021, Red Hat Inc. All rights reserved.
>    *
>    */
>   
> @@ -13,6 +14,7 @@
>   #include <linux/sched.h>
>   #include <linux/vringh.h>
>   #include <linux/vdpa.h>
> +#include <linux/blkdev.h>
>   #include <uapi/linux/virtio_blk.h>
>   
>   #include "vdpa_sim.h"
> @@ -36,10 +38,151 @@
>   
>   static struct vdpasim *vdpasim_blk_dev;
>   
> +static bool vdpasim_blk_check_range(u64 start_sector, size_t range_size)
> +{
> +	u64 range_sectors = range_size >> SECTOR_SHIFT;
> +
> +	if (range_size > VDPASIM_BLK_SIZE_MAX * VDPASIM_BLK_SEG_MAX)
> +		return false;
> +
> +	if (start_sector > VDPASIM_BLK_CAPACITY)
> +		return false;
> +
> +	if (range_sectors > VDPASIM_BLK_CAPACITY - start_sector)
> +		return false;
> +
> +	return true;
> +}
> +
> +/* Returns 'true' if the request is handled (with or without an I/O error)
> + * and the status is correctly written in the last byte of the 'in iov',
> + * 'false' otherwise.
> + */
> +static bool vdpasim_blk_handle_req(struct vdpasim *vdpasim,
> +				   struct vdpasim_virtqueue *vq)
> +{
> +	size_t pushed = 0, to_pull, to_push;
> +	struct virtio_blk_outhdr hdr;
> +	ssize_t bytes;
> +	loff_t offset;
> +	u64 sector;
> +	u8 status;
> +	u32 type;
> +	int ret;
> +
> +	ret = vringh_getdesc_iotlb(&vq->vring, &vq->out_iov, &vq->in_iov,
> +				   &vq->head, GFP_ATOMIC);
> +	if (ret != 1)
> +		return false;
> +
> +	if (vq->out_iov.used < 1 || vq->in_iov.used < 1) {
> +		dev_err(&vdpasim->vdpa.dev, "missing headers - out_iov: %u in_iov %u\n",
> +			vq->out_iov.used, vq->in_iov.used);
> +		return false;
> +	}
> +
> +	if (vq->in_iov.iov[vq->in_iov.used - 1].iov_len < 1) {
> +		dev_err(&vdpasim->vdpa.dev, "request in header too short\n");
> +		return false;
> +	}
> +
> +	/* The last byte is the status and we checked if the last iov has
> +	 * enough room for it.
> +	 */
> +	to_push = vringh_kiov_length(&vq->in_iov) - 1;
> +
> +	to_pull = vringh_kiov_length(&vq->out_iov);
> +
> +	bytes = vringh_iov_pull_iotlb(&vq->vring, &vq->out_iov, &hdr,
> +				      sizeof(hdr));
> +	if (bytes != sizeof(hdr)) {
> +		dev_err(&vdpasim->vdpa.dev, "request out header too short\n");
> +		return false;
> +	}
> +
> +	to_pull -= bytes;
> +
> +	type = vdpasim32_to_cpu(vdpasim, hdr.type);
> +	sector = vdpasim64_to_cpu(vdpasim, hdr.sector);
> +	offset = sector << SECTOR_SHIFT;
> +	status = VIRTIO_BLK_S_OK;
> +
> +	switch (type) {
> +	case VIRTIO_BLK_T_IN:
> +		if (!vdpasim_blk_check_range(sector, to_push)) {
> +			dev_err(&vdpasim->vdpa.dev,
> +				"reading over the capacity - offset: 0x%llx len: 0x%zx\n",
> +				offset, to_push);
> +			status = VIRTIO_BLK_S_IOERR;
> +			break;
> +		}
> +
> +		bytes = vringh_iov_push_iotlb(&vq->vring, &vq->in_iov,
> +					      vdpasim->buffer + offset,
> +					      to_push);
> +		if (bytes < 0) {
> +			dev_err(&vdpasim->vdpa.dev,
> +				"vringh_iov_push_iotlb() error: %zd offset: 0x%llx len: 0x%zx\n",
> +				bytes, offset, to_push);
> +			status = VIRTIO_BLK_S_IOERR;
> +			break;
> +		}
> +
> +		pushed += bytes;
> +		break;
> +
> +	case VIRTIO_BLK_T_OUT:
> +		if (!vdpasim_blk_check_range(sector, to_pull)) {
> +			dev_err(&vdpasim->vdpa.dev,
> +				"writing over the capacity - offset: 0x%llx len: 0x%zx\n",
> +				offset, to_pull);
> +			status = VIRTIO_BLK_S_IOERR;
> +			break;
> +		}
> +
> +		bytes = vringh_iov_pull_iotlb(&vq->vring, &vq->out_iov,
> +					      vdpasim->buffer + offset,
> +					      to_pull);
> +		if (bytes < 0) {
> +			dev_err(&vdpasim->vdpa.dev,
> +				"vringh_iov_pull_iotlb() error: %zd offset: 0x%llx len: 0x%zx\n",
> +				bytes, offset, to_pull);
> +			status = VIRTIO_BLK_S_IOERR;
> +			break;
> +		}
> +		break;
> +
> +	default:
> +		dev_warn(&vdpasim->vdpa.dev,
> +			 "Unsupported request type %d\n", type);
> +		status = VIRTIO_BLK_S_IOERR;
> +		break;
> +	}
> +
> +	/* If some operations fail, we need to skip the remaining bytes
> +	 * to put the status in the last byte
> +	 */
> +	if (to_push - pushed > 0)
> +		vringh_kiov_advance(&vq->in_iov, to_push - pushed);
> +
> +	/* Last byte is the status */
> +	bytes = vringh_iov_push_iotlb(&vq->vring, &vq->in_iov, &status, 1);
> +	if (bytes != 1)
> +		return false;
> +
> +	pushed += bytes;
> +
> +	/* Make sure data is wrote before advancing index */
> +	smp_wmb();
> +
> +	vringh_complete_iotlb(&vq->vring, vq->head, pushed);
> +
> +	return true;
> +}
> +
>   static void vdpasim_blk_work(struct work_struct *work)
>   {
>   	struct vdpasim *vdpasim = container_of(work, struct vdpasim, work);
> -	u8 status = VIRTIO_BLK_S_OK;
>   	int i;
>   
>   	spin_lock(&vdpasim->lock);
> @@ -53,22 +196,7 @@ static void vdpasim_blk_work(struct work_struct *work)
>   		if (!vq->ready)
>   			continue;
>   
> -		while (vringh_getdesc_iotlb(&vq->vring, &vq->out_iov,
> -					    &vq->in_iov, &vq->head,
> -					    GFP_ATOMIC) > 0) {
> -			int write;
> -
> -			vq->in_iov.i = vq->in_iov.used - 1;
> -			write = vringh_iov_push_iotlb(&vq->vring, &vq->in_iov,
> -						      &status, 1);
> -			if (write <= 0)
> -				break;
> -
> -			/* Make sure data is wrote before advancing index */
> -			smp_wmb();
> -
> -			vringh_complete_iotlb(&vq->vring, vq->head, write);
> -
> +		while (vdpasim_blk_handle_req(vdpasim, vq)) {
>   			/* Make sure used is visible before rasing the interrupt. */
>   			smp_wmb();
>   
> @@ -109,7 +237,7 @@ static int __init vdpasim_blk_init(void)
>   	dev_attr.config_size = sizeof(struct virtio_blk_config);
>   	dev_attr.get_config = vdpasim_blk_get_config;
>   	dev_attr.work_fn = vdpasim_blk_work;
> -	dev_attr.buffer_size = PAGE_SIZE;
> +	dev_attr.buffer_size = VDPASIM_BLK_CAPACITY << SECTOR_SHIFT;
>   
>   	vdpasim_blk_dev = vdpasim_create(&dev_attr);
>   	if (IS_ERR(vdpasim_blk_dev)) {

