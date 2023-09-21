Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14F057A9830
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 19:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbjIURc0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 13:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbjIURcE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 13:32:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8397D4A30C
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695317196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xXZMggqs59z4fDzDQEy0mBNN19gcJsNuYATbYPTfKbg=;
        b=YrqH0x9K6YbO5Cqian+YIKiPPGnse8U8dCF94kl1TrMllBQqH8BJymwm0gOrooitZZmh2S
        RqWhMXNebn0HugYe2dLRzElAP+dAW6kx91Cx3dsimwI+VBfu0f+Z0GkfduZvBvA89q3SYq
        TOcGvNPmqT3bB3b5aS7QPLZEY7Qni58=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-344-rVEuZYnbPquZNpzwl1X6Iw-1; Thu, 21 Sep 2023 09:08:42 -0400
X-MC-Unique: rVEuZYnbPquZNpzwl1X6Iw-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-530cfb598c5so625588a12.1
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 06:08:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695301721; x=1695906521;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xXZMggqs59z4fDzDQEy0mBNN19gcJsNuYATbYPTfKbg=;
        b=dF2TlPPbx254sHvMbDDfDUdwAG/voL6AdfY5Jq7Nx6jg8kO45LmEkHaEBsrkxuWkg6
         MoIhdQXKGis89UBJSquV0285oaHwWQf8W/8BnpC7+GnL/fXksnXaM/QydoVYH9QTan3q
         +SgC3i5JqjIBlL6Mdc8P+e6kPQQ0HuqO5S0Tu1OC0b2GhYZGUMn5hRJGcacPG4VG6ifh
         f4G743owiyCT8R8Jhq8gH5nkIFD8D70RjyB+5Xoxt+6Vd3BFYpH+E7saYDS6wiOwSA0X
         wWQkwLLkB/xIvEcWHiVV3Nkrz5dRdSKMiMbVRl0czbXqsa9quDTmmRC0BzoNxnLseixG
         JZ0g==
X-Gm-Message-State: AOJu0YwgrpXWItm04tX0nlhFPpB6NkD1Bm6lUOn/1LzKzTbY1iEVfpoU
        kiC+uNxeZ6+Cx41OhYXOPo0gA8kP3VO61+1g130jS5g/kokXFUDoM8eeJkvgXxT/snMriCnFLP8
        0UcGrp+jnIPay
X-Received: by 2002:a05:6402:88f:b0:522:1d23:a1f8 with SMTP id e15-20020a056402088f00b005221d23a1f8mr4184848edy.26.1695301721313;
        Thu, 21 Sep 2023 06:08:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE5BehkElhUZwzt/pCYYxfas98l47+eljO8dQrZQePi2g5dU8RGzroT9XW+g1N1dFH8FOdivg==
X-Received: by 2002:a05:6402:88f:b0:522:1d23:a1f8 with SMTP id e15-20020a056402088f00b005221d23a1f8mr4184828edy.26.1695301720957;
        Thu, 21 Sep 2023 06:08:40 -0700 (PDT)
Received: from redhat.com ([2.52.150.187])
        by smtp.gmail.com with ESMTPSA id j7-20020a50ed07000000b00527e7087d5dsm806498eds.15.2023.09.21.06.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 06:08:38 -0700 (PDT)
Date:   Thu, 21 Sep 2023 09:08:33 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     alex.williamson@redhat.com, jasowang@redhat.com, jgg@nvidia.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20230921090536-mutt-send-email-mst@kernel.org>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-11-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921124040.145386-11-yishaih@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 03:40:39PM +0300, Yishai Hadas wrote:
> Expose admin commands over the virtio device, to be used by the
> vfio-virtio driver in the next patches.
> 
> It includes: list query/use, legacy write/read, read notify_info.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>


I don't get the motivation for this and the next patch.
We already have vdpa that seems to do exactly this:
drive virtio from userspace. Why do we need these extra 1000
lines of code in vfio - just because we can?
Not to talk about user confusion all this will cause.


> ---
>  drivers/vfio/pci/virtio/cmd.c | 146 ++++++++++++++++++++++++++++++++++
>  drivers/vfio/pci/virtio/cmd.h |  27 +++++++
>  2 files changed, 173 insertions(+)
>  create mode 100644 drivers/vfio/pci/virtio/cmd.c
>  create mode 100644 drivers/vfio/pci/virtio/cmd.h
> 
> diff --git a/drivers/vfio/pci/virtio/cmd.c b/drivers/vfio/pci/virtio/cmd.c
> new file mode 100644
> index 000000000000..f068239cdbb0
> --- /dev/null
> +++ b/drivers/vfio/pci/virtio/cmd.c
> @@ -0,0 +1,146 @@
> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> +/*
> + * Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved
> + */
> +
> +#include "cmd.h"
> +
> +int virtiovf_cmd_list_query(struct pci_dev *pdev, u8 *buf, int buf_size)
> +{
> +	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
> +	struct scatterlist out_sg;
> +	struct virtio_admin_cmd cmd = {};
> +
> +	if (!virtio_dev)
> +		return -ENOTCONN;
> +
> +	sg_init_one(&out_sg, buf, buf_size);
> +	cmd.opcode = VIRTIO_ADMIN_CMD_LIST_QUERY;
> +	cmd.group_type = VIRTIO_ADMIN_GROUP_TYPE_SRIOV;
> +	cmd.result_sg = &out_sg;
> +
> +	return virtio_admin_cmd_exec(virtio_dev, &cmd);
> +}
> +
> +int virtiovf_cmd_list_use(struct pci_dev *pdev, u8 *buf, int buf_size)
> +{
> +	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
> +	struct scatterlist in_sg;
> +	struct virtio_admin_cmd cmd = {};
> +
> +	if (!virtio_dev)
> +		return -ENOTCONN;
> +
> +	sg_init_one(&in_sg, buf, buf_size);
> +	cmd.opcode = VIRTIO_ADMIN_CMD_LIST_USE;
> +	cmd.group_type = VIRTIO_ADMIN_GROUP_TYPE_SRIOV;
> +	cmd.data_sg = &in_sg;
> +
> +	return virtio_admin_cmd_exec(virtio_dev, &cmd);
> +}
> +
> +int virtiovf_cmd_lr_write(struct virtiovf_pci_core_device *virtvdev, u16 opcode,
> +			  u8 offset, u8 size, u8 *buf)
> +{
> +	struct virtio_device *virtio_dev =
> +		virtio_pci_vf_get_pf_dev(virtvdev->core_device.pdev);
> +	struct virtio_admin_cmd_data_lr_write *in;
> +	struct scatterlist in_sg;
> +	struct virtio_admin_cmd cmd = {};
> +	int ret;
> +
> +	if (!virtio_dev)
> +		return -ENOTCONN;
> +
> +	in = kzalloc(sizeof(*in) + size, GFP_KERNEL);
> +	if (!in)
> +		return -ENOMEM;
> +
> +	in->offset = offset;
> +	memcpy(in->registers, buf, size);
> +	sg_init_one(&in_sg, in, sizeof(*in) + size);
> +	cmd.opcode = opcode;
> +	cmd.group_type = VIRTIO_ADMIN_GROUP_TYPE_SRIOV;
> +	cmd.group_member_id = virtvdev->vf_id + 1;
> +	cmd.data_sg = &in_sg;
> +	ret = virtio_admin_cmd_exec(virtio_dev, &cmd);
> +
> +	kfree(in);
> +	return ret;
> +}
> +
> +int virtiovf_cmd_lr_read(struct virtiovf_pci_core_device *virtvdev, u16 opcode,
> +			 u8 offset, u8 size, u8 *buf)
> +{
> +	struct virtio_device *virtio_dev =
> +		virtio_pci_vf_get_pf_dev(virtvdev->core_device.pdev);
> +	struct virtio_admin_cmd_data_lr_read *in;
> +	struct scatterlist in_sg, out_sg;
> +	struct virtio_admin_cmd cmd = {};
> +	int ret;
> +
> +	if (!virtio_dev)
> +		return -ENOTCONN;
> +
> +	in = kzalloc(sizeof(*in), GFP_KERNEL);
> +	if (!in)
> +		return -ENOMEM;
> +
> +	in->offset = offset;
> +	sg_init_one(&in_sg, in, sizeof(*in));
> +	sg_init_one(&out_sg, buf, size);
> +	cmd.opcode = opcode;
> +	cmd.group_type = VIRTIO_ADMIN_GROUP_TYPE_SRIOV;
> +	cmd.data_sg = &in_sg;
> +	cmd.result_sg = &out_sg;
> +	cmd.group_member_id = virtvdev->vf_id + 1;
> +	ret = virtio_admin_cmd_exec(virtio_dev, &cmd);
> +
> +	kfree(in);
> +	return ret;
> +}
> +
> +int virtiovf_cmd_lq_read_notify(struct virtiovf_pci_core_device *virtvdev,
> +				u8 req_bar_flags, u8 *bar, u64 *bar_offset)
> +{
> +	struct virtio_device *virtio_dev =
> +		virtio_pci_vf_get_pf_dev(virtvdev->core_device.pdev);
> +	struct virtio_admin_cmd_notify_info_result *out;
> +	struct scatterlist out_sg;
> +	struct virtio_admin_cmd cmd = {};
> +	int ret;
> +
> +	if (!virtio_dev)
> +		return -ENOTCONN;
> +
> +	out = kzalloc(sizeof(*out), GFP_KERNEL);
> +	if (!out)
> +		return -ENOMEM;
> +
> +	sg_init_one(&out_sg, out, sizeof(*out));
> +	cmd.opcode = VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO;
> +	cmd.group_type = VIRTIO_ADMIN_GROUP_TYPE_SRIOV;
> +	cmd.result_sg = &out_sg;
> +	cmd.group_member_id = virtvdev->vf_id + 1;
> +	ret = virtio_admin_cmd_exec(virtio_dev, &cmd);
> +	if (!ret) {
> +		struct virtio_admin_cmd_notify_info_data *entry;
> +		int i;
> +
> +		ret = -ENOENT;
> +		for (i = 0; i < VIRTIO_ADMIN_CMD_MAX_NOTIFY_INFO; i++) {
> +			entry = &out->entries[i];
> +			if (entry->flags == VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_END)
> +				break;
> +			if (entry->flags != req_bar_flags)
> +				continue;
> +			*bar = entry->bar;
> +			*bar_offset = le64_to_cpu(entry->offset);
> +			ret = 0;
> +			break;
> +		}
> +	}
> +
> +	kfree(out);
> +	return ret;
> +}
> diff --git a/drivers/vfio/pci/virtio/cmd.h b/drivers/vfio/pci/virtio/cmd.h
> new file mode 100644
> index 000000000000..c2a3645f4b90
> --- /dev/null
> +++ b/drivers/vfio/pci/virtio/cmd.h
> @@ -0,0 +1,27 @@
> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> +/*
> + * Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
> + */
> +
> +#ifndef VIRTIO_VFIO_CMD_H
> +#define VIRTIO_VFIO_CMD_H
> +
> +#include <linux/kernel.h>
> +#include <linux/virtio.h>
> +#include <linux/vfio_pci_core.h>
> +#include <linux/virtio_pci.h>
> +
> +struct virtiovf_pci_core_device {
> +	struct vfio_pci_core_device core_device;
> +	int vf_id;
> +};
> +
> +int virtiovf_cmd_list_query(struct pci_dev *pdev, u8 *buf, int buf_size);
> +int virtiovf_cmd_list_use(struct pci_dev *pdev, u8 *buf, int buf_size);
> +int virtiovf_cmd_lr_write(struct virtiovf_pci_core_device *virtvdev, u16 opcode,
> +			  u8 offset, u8 size, u8 *buf);
> +int virtiovf_cmd_lr_read(struct virtiovf_pci_core_device *virtvdev, u16 opcode,
> +			 u8 offset, u8 size, u8 *buf);
> +int virtiovf_cmd_lq_read_notify(struct virtiovf_pci_core_device *virtvdev,
> +				u8 req_bar_flags, u8 *bar, u64 *bar_offset);
> +#endif /* VIRTIO_VFIO_CMD_H */
> -- 
> 2.27.0

