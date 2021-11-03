Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC15B443DD2
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 08:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbhKCHvx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 03:51:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52988 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230025AbhKCHvw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 03:51:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635925754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lqgSFRKURbgASgWddL5XIQlSIfLH4x2twZXfMZ8afvA=;
        b=DzlQ4iQCNHRULKFFpdeVwqGrclNnKvTVJGmCTe+wRqQz4zCvnFtdXeDkszIFEyxinz62h9
        Z6paEX2koL43UY4RIva9DJTxlPj2+IbsItMZRLUpUfNTYa1WjXQIJYIFyVmFwtrR718k0Y
        APHD+0c2+MW6t5dhVmf498rjf615vF4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-597-NgU_SNjMNGyfR4GGjUs2hA-1; Wed, 03 Nov 2021 03:49:13 -0400
X-MC-Unique: NgU_SNjMNGyfR4GGjUs2hA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DDC61923761;
        Wed,  3 Nov 2021 07:49:12 +0000 (UTC)
Received: from [10.39.192.84] (unknown [10.39.192.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE6E85D6B1;
        Wed,  3 Nov 2021 07:49:07 +0000 (UTC)
Message-ID: <74901bd1-e69f-99d3-b11e-e0b541226d20@redhat.com>
Date:   Wed, 3 Nov 2021 08:49:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com, drjones@redhat.com
References: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
 <1630059440-15586-4-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 3/7] s390x: virtio: CCW transport
 implementation
In-Reply-To: <1630059440-15586-4-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/08/2021 12.17, Pierre Morel wrote:
> This is the implementation of the virtio-ccw transport level.
> 
> We only support VIRTIO revision 0.

That means only legacy virtio? Wouldn't it be better to shoot for modern 
virtio instead?

> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   lib/s390x/virtio-ccw.c | 374 +++++++++++++++++++++++++++++++++++++++++
>   lib/s390x/virtio-ccw.h | 111 ++++++++++++
>   lib/virtio-config.h    |  30 ++++
>   s390x/Makefile         |   2 +
>   4 files changed, 517 insertions(+)
>   create mode 100644 lib/s390x/virtio-ccw.c
>   create mode 100644 lib/s390x/virtio-ccw.h
>   create mode 100644 lib/virtio-config.h
> 
> diff --git a/lib/s390x/virtio-ccw.c b/lib/s390x/virtio-ccw.c
> new file mode 100644
> index 00000000..cf447de6
> --- /dev/null
> +++ b/lib/s390x/virtio-ccw.c
> @@ -0,0 +1,374 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Virtio CCW Library
> + *
> + * Copyright (c) 2021 IBM Corp
> + *
> + * Authors:
> + *  Pierre Morel <pmorel@linux.ibm.com>
> + *
> + */
> +
> +#include <libcflat.h>
> +#include <alloc_page.h>
> +#include <asm/page.h>
> +#include <string.h>
> +#include <interrupt.h>
> +#include <asm/arch_def.h>
> +#include <asm/facility.h>
> +#include <asm/uv.h>
> +
> +#include <css.h>
> +#include <virtio.h>
> +#include <virtio-config.h>
> +#include <virtio-ccw.h>
> +#include <malloc_io.h>
> +
> +static struct linked_list vcdev_list = {
> +	.prev = &vcdev_list,
> +	.next = &vcdev_list
> +};
> +
> +static inline uint32_t swap16(uint32_t b)
> +{
> +		return (((b & 0xff00U) <<  8) |
> +		((b & 0x00ff) >>  8));
> +}
> +
> +static inline uint32_t swap32(uint32_t b)
> +{
> +	return (((b & 0x000000ffU) << 24) |
> +		((b & 0x0000ff00U) <<  8) |
> +		((b & 0x00ff0000U) >>  8) |
> +		((b & 0xff000000U) >> 24));
> +}
> +
> +static inline uint64_t swap64(uint64_t x)
> +{
> +	return (((x & 0x00000000000000ffULL) << 56) |
> +		((x & 0x000000000000ff00ULL) << 40) |
> +		((x & 0x0000000000ff0000ULL) << 24) |
> +		((x & 0x00000000ff000000ULL) <<  8) |
> +		((x & 0x000000ff00000000ULL) >>  8) |
> +		((x & 0x0000ff0000000000ULL) >> 24) |
> +		((x & 0x00ff000000000000ULL) >> 40) |
> +		((x & 0xff00000000000000ULL) >> 56));
> +}

We already have macros for swapping in lib/asm-generic/io.h ... could you 
use those instead?

> +/*
> + * flags: flags for CCW
> + * Returns !0 on failure
> + * Returns 0 on success
> + */
> +int ccw_send(struct virtio_ccw_device *vcdev, int code, void *data, int count,
> +	     unsigned char flags)
> +{
> +	struct ccw1 *ccw;
> +	int ret = -1;
> +
> +	ccw = alloc_io_mem(sizeof(*ccw), 0);
> +	if (!ccw)
> +		return ret;
> +
> +	/* Build the CCW chain with a single CCW */
> +	ccw->code = code;
> +	ccw->flags = flags;
> +	ccw->count = count;
> +	ccw->data_address = (unsigned long)data;
> +
> +	ret = start_ccw1_chain(vcdev->schid, ccw);
> +	if (!ret)
> +		ret = wait_and_check_io_completion(vcdev->schid);
> +
> +	free_io_mem(ccw, sizeof(*ccw));
> +	return ret;
> +}
> +
> +int virtio_ccw_set_revision(struct virtio_ccw_device *vcdev)
> +{
> +	struct virtio_rev_info *rev_info;
> +	int ret = -1;
> +
> +	rev_info = alloc_io_mem(sizeof(*rev_info), 0);
> +	if (!rev_info)
> +		return ret;
> +
> +	rev_info->revision = VIRTIO_CCW_REV_MAX;
> +	rev_info->revision = 0;

Either VIRTIO_CCW_REV_MAX or 0, but not both?

> +	do {
> +		ret = ccw_send(vcdev, CCW_CMD_SET_VIRTIO_REV, rev_info,
> +			       sizeof(*rev_info), 0);
> +	} while (ret && rev_info->revision--);
> +
> +	free_io_mem(rev_info, sizeof(*rev_info));
> +
> +	return ret ? -1 : rev_info->revision;
> +}
> +
> +int virtio_ccw_reset(struct virtio_ccw_device *vcdev)
> +{
> +	return ccw_send(vcdev, CCW_CMD_VDEV_RESET, 0, 0, 0);
> +}
> +
> +int virtio_ccw_read_status(struct virtio_ccw_device *vcdev)
> +{
> +	return ccw_send(vcdev, CCW_CMD_READ_STATUS, &vcdev->status,
> +			sizeof(vcdev->status), 0);
> +}
> +
> +int virtio_ccw_write_status(struct virtio_ccw_device *vcdev)
> +{
> +	return ccw_send(vcdev, CCW_CMD_WRITE_STATUS, &vcdev->status,
> +			sizeof(vcdev->status), 0);
> +}
> +
> +int virtio_ccw_read_features(struct virtio_ccw_device *vcdev, uint64_t *features)
> +{
> +	struct virtio_feature_desc *f_desc = &vcdev->f_desc;
> +
> +	f_desc->index = 0;
> +	if (ccw_send(vcdev, CCW_CMD_READ_FEAT, f_desc, sizeof(*f_desc), 0))
> +		return -1;
> +	*features = swap32(f_desc->features);
> +
> +	f_desc->index = 1;
> +	if (ccw_send(vcdev, CCW_CMD_READ_FEAT, f_desc, sizeof(*f_desc), 0))
> +		return -1;
> +	*features |= (uint64_t)swap32(f_desc->features) << 32;

Weren't the upper feature bits only available for modern virtio anyway?

> +	return 0;
> +}
> +
> +int virtio_ccw_write_features(struct virtio_ccw_device *vcdev, uint64_t features)
> +{
> +	struct virtio_feature_desc *f_desc = &vcdev->f_desc;
> +
> +	f_desc->index = 0;
> +	f_desc->features = swap32((uint32_t)features & 0xffffffff);
> +	if (ccw_send(vcdev, CCW_CMD_WRITE_FEAT, &f_desc, sizeof(*f_desc), 0))
> +		return -1;
> +
> +	f_desc->index = 1;
> +	f_desc->features = swap32((uint32_t)(features >> 32) & 0xffffffff);
> +	if (ccw_send(vcdev, CCW_CMD_WRITE_FEAT, &f_desc, sizeof(*f_desc), 0))
> +		return -1;
> +
> +	return 0;
> +}
> +
> +int virtio_ccw_read_config(struct virtio_ccw_device *vcdev)
> +{
> +	return ccw_send(vcdev, CCW_CMD_READ_CONF, &vcdev->config,
> +			sizeof(vcdev->config), 0);
> +}
> +
> +int virtio_ccw_write_config(struct virtio_ccw_device *vcdev)
> +{
> +	return ccw_send(vcdev, CCW_CMD_WRITE_CONF, &vcdev->config,
> +			sizeof(vcdev->config), 0);
> +}
> +
> +int virtio_ccw_setup_indicators(struct virtio_ccw_device *vcdev)
> +{
> +	vcdev->ind = alloc_io_mem(sizeof(PAGE_SIZE), 0);
> +	if (ccw_send(vcdev, CCW_CMD_SET_IND, &vcdev->ind,
> +		     sizeof(vcdev->ind), 0))
> +		return -1;
> +
> +	vcdev->conf_ind = alloc_io_mem(PAGE_SIZE, 0);
> +	if (ccw_send(vcdev, CCW_CMD_SET_CONF_IND, &vcdev->conf_ind,
> +		     sizeof(vcdev->conf_ind), 0))
> +		return -1;
> +
> +	return 0;
> +}
> +
> +static uint64_t virtio_ccw_notify_host(int schid, int queue, uint64_t cookie)
> +{
> +	register unsigned long nr asm("1") = 0x03;
> +	register unsigned long s asm("2") = schid;
> +	register unsigned long q asm("3") = queue;
> +	register long rc asm("2");

Using asm("2") for two variables looks somewhat weird ... but ok, as long as 
it works... (otherwise you could also use only one variable and mark it as 
input + output parameter below).

> +	register long c asm("4") = cookie;
> +
> +	asm volatile ("diag 2,4,0x500\n"
> +			: "=d" (rc)
> +			: "d" (nr), "d" (s), "d" (q), "d"(c)
> +			: "memory", "cc");
> +	return rc;
> +}
> +
> +static bool virtio_ccw_notify(struct virtqueue *vq)
> +{
> +	struct virtio_ccw_device *vcdev = to_vc_device(vq->vdev);
> +	struct virtio_ccw_vq_info *info = vq->priv;
> +
> +	info->cookie = virtio_ccw_notify_host(vcdev->schid, vq->index,
> +					      info->cookie);
> +	if (info->cookie < 0)
> +		return false;
> +	return true;
> +}
> +
> +/* allocates a vring_virtqueue but returns a pointer to the
> + * virtqueue inside of it or NULL on error.
> + */
> +static struct virtqueue *setup_vq(struct virtio_device *vdev, int index,
> +				  void (*callback)(struct virtqueue *vq),
> +				  const char *name)
> +{
> +	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
> +	struct virtio_ccw_vq_info *info;
> +	struct vring_virtqueue *vq;
> +	struct vring *vr;
> +	void *queue;
> +
> +	vq = alloc_io_mem(sizeof(*vq), 0);
> +	info = alloc_io_mem(sizeof(*info), 0);
> +	queue = alloc_io_mem(4 * PAGE_SIZE, 0);
> +	assert(vq && queue && info);
> +
> +	info->info_block = alloc_io_mem(sizeof(*info->info_block), 0);
> +	assert(info->info_block);
> +
> +	vcdev->vq_conf.index = index;
> +	if (ccw_send(vcdev, CCW_CMD_READ_VQ_CONF, &vcdev->vq_conf,
> +		     sizeof(vcdev->vq_conf), 0))
> +		return NULL;
> +
> +	vring_init_virtqueue(vq, index, vcdev->vq_conf.max_num, PAGE_SIZE, vdev,
> +			     queue, virtio_ccw_notify, callback, name);
> +
> +	vr = &vq->vring;
> +	info->info_block->s.desc = vr->desc;
> +	info->info_block->s.index = index;
> +	info->info_block->s.num = vr->num;
> +	info->info_block->s.avail = vr->avail;
> +	info->info_block->s.used = vr->used;
> +
> +	info->info_block->l.desc = vr->desc;
> +	info->info_block->l.index = index;
> +	info->info_block->l.num = vr->num;
> +	info->info_block->l.align = PAGE_SIZE;
> +
> +	if (ccw_send(vcdev, CCW_CMD_SET_VQ, info->info_block,
> +		     sizeof(info->info_block->l), 0))
> +		return NULL;
> +
> +	info->vq = &vq->vq;
> +	vq->vq.priv = info;
> +
> +	return &vq->vq;
> +}
> +
> +static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
> +			       struct virtqueue *vqs[], vq_callback_t *callbacks[],
> +			       const char *names[])
> +{
> +	int i;
> +
> +	for (i = 0; i < nvqs; ++i) {
> +		vqs[i] = setup_vq(vdev, i,
> +				  callbacks ? callbacks[i] : NULL,
> +				  names ? names[i] : "");
> +		if (!vqs[i])
> +			return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +static void virtio_ccw_config_get(struct virtio_device *vdev,
> +				  unsigned int offset, void *buf,
> +				  unsigned int len)
> +{
> +	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
> +
> +	if (virtio_ccw_read_config(vcdev))
> +		return;
> +	memcpy(buf, vcdev->config, len);
> +}
> +
> +static void virtio_ccw_config_set(struct virtio_device *vdev,
> +				  unsigned int offset, const void *buf,
> +				  unsigned int len)
> +{
> +	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
> +
> +	memcpy(vcdev->config, buf, len);
> +	virtio_ccw_write_config(vcdev);
> +}
> +
> +static const struct virtio_config_ops virtio_ccw_ops = {
> +	.get = virtio_ccw_config_get,
> +	.set = virtio_ccw_config_set,
> +	.find_vqs = virtio_ccw_find_vqs,
> +};
> +
> +const struct virtio_config_ops *virtio_ccw_register(void)
> +{
> +	return &virtio_ccw_ops;
> +}
> +
> +static int sense(struct virtio_ccw_device *vcdev)
> +{
> +	struct senseid *senseid;
> +
> +	senseid = alloc_io_mem(sizeof(*senseid), 0);
> +	assert(senseid);
> +
> +	assert(!ccw_send(vcdev, CCW_CMD_SENSE_ID, senseid, sizeof(*senseid), 0));
> +
> +	assert(senseid->reserved == 0xff);
> +
> +	vcdev->cu_type = senseid->cu_type;
> +	vcdev->cu_model = senseid->cu_model;
> +	vcdev->dev_type = senseid->dev_type;
> +	vcdev->dev_model = senseid->dev_model;
> +
> +	return 0;
> +}
> +
> +static struct virtio_ccw_device *find_vcdev_by_devid(int devid)
> +{
> +	struct virtio_ccw_device *dev;
> +	struct linked_list *l;
> +
> +	for (l = vcdev_list.next; l != &vcdev_list; l = l->next) {
> +		dev = container_of(l, struct virtio_ccw_device, list);
> +		if (dev->cu_model == devid)
> +			return dev;
> +	}
> +	return NULL;
> +}
> +
> +struct virtio_device *virtio_bind(u32 devid)
> +{
> +	struct virtio_ccw_device *vcdev;
> +
> +	vcdev = find_vcdev_by_devid(devid);
> +
> +	return &vcdev->vdev;
> +}
> +
> +static int virtio_enumerate(int schid)
> +{
> +	struct virtio_ccw_device *vcdev;
> +
> +	vcdev = alloc_io_mem(sizeof(*vcdev), 0);
> +	assert(vcdev);
> +	vcdev->schid = schid;
> +
> +	list_add(&vcdev_list, &vcdev->list);
> +
> +	assert(css_enable(schid, IO_SCH_ISC) == 0);
> +	sense(vcdev);
> +
> +	return 0;
> +}
> +
> +/* Must get a param */

I don't understand that comment, could you elaborate?

> +bool virtio_ccw_init(void)
> +{
> +	return css_enumerate(virtio_enumerate) != 0;
> +}

  Thomas

