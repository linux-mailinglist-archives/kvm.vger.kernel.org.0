Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F37E07AAED8
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 11:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbjIVJzM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 05:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjIVJzK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 05:55:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794A991
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 02:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695376457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BpZ0VDVX8FfkTwiKE9CFWlDT7155hAKls4F27QxTh5s=;
        b=YhGHROxtVGB96ZyD1tt8IcwSaNoeaxGWxQ0EntG0b+f061xrVozVr5cPoKYsZ22l3FTM6c
        XxMi/7X4SnqxGHIvqFp+3a+0YBpR+oM+ylZvXsHYLmT5E9lVibkuCxNW8NUfslQt0TFo4w
        5+V8aaZgcX8eFC+wxTXsvXV9UCaw0ps=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-383-P1O6z6XFNjuLEEw9eMykYQ-1; Fri, 22 Sep 2023 05:54:16 -0400
X-MC-Unique: P1O6z6XFNjuLEEw9eMykYQ-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-9a9e12a3093so406950566b.0
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 02:54:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695376455; x=1695981255;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BpZ0VDVX8FfkTwiKE9CFWlDT7155hAKls4F27QxTh5s=;
        b=GIwxTWbXRN8nT/akEXaujreoGbm67WWqf2Qs6QgFHGmgGABYPBkj7l1Y20ERWveL2h
         Fq14hsyYdtOTYUscTOxMODCofy68TqAzXfgIPOVt8Q3KIz+VtOPSArQocWu1DG2Sk/o7
         1JBIJa/O11zOSngqNcBWKoNCT6oyO4bWMZn2chw29BXd7rozAlLDlGlD+SoiESAd0OlQ
         ULvkWvGg9QJpfJsKfDnZD1fRYxw87hsD2uTeO3vQqv7N2QhObZ9ibLORWC7qR6RTsW8E
         jhOOShs2sG5UrgXHw5YeQzqtcUore5aSAYpzLAUHDQux0q0sL4UUqBU1ePNb+nLhCN//
         Z3hQ==
X-Gm-Message-State: AOJu0YwouBFtv9lyghi9JEMhmSbv3Av2miHJdXF91dKZ/iQLDlpAXJ/W
        vtA3Tp/04L1sOtYo0QhvHM3czvsm1z9avlh4nNXDKd8+vBKoL44jYuikQM1GZzv4ebkSUWZ3vTc
        tBcjJG8kl73m5
X-Received: by 2002:a17:906:196:b0:9a9:f0e6:904e with SMTP id 22-20020a170906019600b009a9f0e6904emr3048736ejb.16.1695376455012;
        Fri, 22 Sep 2023 02:54:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFVHfC2HFYx5GwpdE1rySKJGd3+e5S+4vaM1psBbm3sEb5xfC+PJmOl+blfgC8wN0uphFnAWQ==
X-Received: by 2002:a17:906:196:b0:9a9:f0e6:904e with SMTP id 22-20020a170906019600b009a9f0e6904emr3048718ejb.16.1695376454618;
        Fri, 22 Sep 2023 02:54:14 -0700 (PDT)
Received: from redhat.com ([2.52.150.187])
        by smtp.gmail.com with ESMTPSA id bg1-20020a170906a04100b009adce1c97ccsm2479373ejb.53.2023.09.22.02.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Sep 2023 02:54:13 -0700 (PDT)
Date:   Fri, 22 Sep 2023 05:54:09 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     alex.williamson@redhat.com, jasowang@redhat.com, jgg@nvidia.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20230922055336-mutt-send-email-mst@kernel.org>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-11-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921124040.145386-11-yishaih@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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


This stuff is pure virtio spec. I think it should live under
drivers/virtio, too.

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

