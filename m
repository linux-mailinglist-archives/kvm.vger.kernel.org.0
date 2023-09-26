Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1C97AEBA0
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 13:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbjIZLmq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 07:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbjIZLmp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 07:42:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B66EDE
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 04:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695728512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W5uVRN9fbL8/Flok1FuoN0J/7W7m6F3z9a1UNNRaQbI=;
        b=FELqfdton6VRbH56JScv0kodPXT/Bqp+W3h9o9IMl8CEnd5BBJxlRECH2083xvLsRpu2TG
        2CeCwtXcuTE3V49iqXQKfVohi9v68TrjZFE+jEQy7zq5za8N/uubFHOW8ihtZe7LGBpNS8
        I58Wr2sva3q7cYMYmZUaChjC9tCMisc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-a7ygPMa-NWWfU8ppYkDrlg-1; Tue, 26 Sep 2023 07:41:50 -0400
X-MC-Unique: a7ygPMa-NWWfU8ppYkDrlg-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5334392eb67so17022862a12.1
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 04:41:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695728509; x=1696333309;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W5uVRN9fbL8/Flok1FuoN0J/7W7m6F3z9a1UNNRaQbI=;
        b=YqRvGBfHSx1yfJ4saryXDsan3sRA1q8iWCHuksPFVVpXxpOys8PWN1YWraOp4VqSb4
         uRnhYYJjvr/W3OFJIQFa2ss6q4ZF+5ZrOY3P+dlWQUiDk6Rq4myax1RAAM3ERJ/DoxHg
         WgyQoZxE9/DM2wozxwCr7a2EIs18EBBKuO7TDeknFxYSf3gHPjc4JZpBjVuSkgWbVBMv
         xHL3CK0tRQsvOFB37VTDyl2GSJm3h1yMvBXeo+BD53wf4vxspR6voPSZp6OulQkDJnoB
         mM8jeAnF0ofR/uOEocfUhAw8KASDOLb7ybDglwJv5IuueeM+/lKL1JHcAzwy9i8hL+YJ
         CmQw==
X-Gm-Message-State: AOJu0YwzivlZjYJckH2cAKBCfi2y/gtp0Oth3QNxnkHYkDhZUBegATpz
        EZQdVHNsGVCT3q/Y2Y8Wtbs0NH3QYQzN0hH8jq+kJxkC8aEvnnzM3wymOcISjTTg3evO68Ct45B
        Ad++QORQjOaC7
X-Received: by 2002:a05:6402:f20:b0:533:dcb1:5ab4 with SMTP id i32-20020a0564020f2000b00533dcb15ab4mr4532296eda.18.1695728509414;
        Tue, 26 Sep 2023 04:41:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJCHvtseDaon1zR6tOHK16yWriGxj8hEFZiYSeh+knAYyLm/Z9bPDsztUhZ7ji1Boy38jZyg==
X-Received: by 2002:a05:6402:f20:b0:533:dcb1:5ab4 with SMTP id i32-20020a0564020f2000b00533dcb15ab4mr4532260eda.18.1695728508973;
        Tue, 26 Sep 2023 04:41:48 -0700 (PDT)
Received: from redhat.com ([2.52.31.177])
        by smtp.gmail.com with ESMTPSA id c2-20020aa7c982000000b0053132e5ea61sm6647832edt.30.2023.09.26.04.41.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 04:41:48 -0700 (PDT)
Date:   Tue, 26 Sep 2023 07:41:44 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     alex.williamson@redhat.com, jasowang@redhat.com, jgg@nvidia.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20230926072538-mutt-send-email-mst@kernel.org>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-11-yishaih@nvidia.com>
 <20230922055336-mutt-send-email-mst@kernel.org>
 <c3724e2f-7938-abf7-6aea-02bfb3881151@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c3724e2f-7938-abf7-6aea-02bfb3881151@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 26, 2023 at 02:14:01PM +0300, Yishai Hadas wrote:
> On 22/09/2023 12:54, Michael S. Tsirkin wrote:
> > On Thu, Sep 21, 2023 at 03:40:39PM +0300, Yishai Hadas wrote:
> > > Expose admin commands over the virtio device, to be used by the
> > > vfio-virtio driver in the next patches.
> > > 
> > > It includes: list query/use, legacy write/read, read notify_info.
> > > 
> > > Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> > 
> > This stuff is pure virtio spec. I think it should live under
> > drivers/virtio, too.
> 
> The motivation to put it in the vfio layer was from the below main reasons:
> 
> 1) Having it inside virtio may require to export a symbol/function per
> command.
> 
>    This will end up today by 5 and in the future (e.g. live migration) with
> much more exported symbols.
>
>    With current code we export only 2 generic symbols
> virtio_pci_vf_get_pf_dev(), virtio_admin_cmd_exec() which may fit for any
> further extension.

Except, there's no reasonable way for virtio to know what is done with
the device then. You are not using just 2 symbols at all, instead you
are using the rich vq API which was explicitly designed for the driver
running the device being responsible for serializing accesses. Which is
actually loaded and running. And I *think* your use won't conflict ATM
mostly by luck. Witness the hack in patch 01 as exhibit 1 - nothing
at all even hints at the fact that the reason for the complicated
dance is because another driver pokes at some of the vqs.


> 2) For now there is no logic in this vfio layer, however, in the future we
> may have some DMA/other logic that should better fit to the caller/client
> layer (i.e. vfio).

You are poking at the device without any locks etc. Maybe it looks like
no logic to you but it does not look like that from where I stand.

> By the way, this follows what was done already between vfio/mlx5 to
> mlx5_core modules where mlx5_core exposes generic APIs to execute a command
> and to get the a PF from a given mlx5 VF.

This is up to mlx5 maintainers. In particular they only need to worry
that their patches work with specific hardware which they likely have.
virtio has to work with multiple vendors - hardware and software -
and exposing a low level API that I can't test on my laptop
is not at all my ideal.

> This way, we can enable further commands to be added/extended
> easily/cleanly.

Something for vfio maintainer to consider in case it was
assumed that it's just this one weird thing
but otherwise it's all generic vfio. It's not going to stop there,
will it? The duplication of functionality with vdpa will continue :(


I am much more interested in adding reusable functionality that
everyone benefits from than in vfio poking at the device in its
own weird ways that only benefit specific hardware.


> See for example here [1, 2].
> 
> [1] https://elixir.bootlin.com/linux/v6.6-rc3/source/drivers/vfio/pci/mlx5/cmd.c#L210
> 
> [2] https://elixir.bootlin.com/linux/v6.6-rc3/source/drivers/vfio/pci/mlx5/cmd.c#L683
> 
> Yishai



> > 
> > > ---
> > >   drivers/vfio/pci/virtio/cmd.c | 146 ++++++++++++++++++++++++++++++++++
> > >   drivers/vfio/pci/virtio/cmd.h |  27 +++++++
> > >   2 files changed, 173 insertions(+)
> > >   create mode 100644 drivers/vfio/pci/virtio/cmd.c
> > >   create mode 100644 drivers/vfio/pci/virtio/cmd.h
> > > 
> > > diff --git a/drivers/vfio/pci/virtio/cmd.c b/drivers/vfio/pci/virtio/cmd.c
> > > new file mode 100644
> > > index 000000000000..f068239cdbb0
> > > --- /dev/null
> > > +++ b/drivers/vfio/pci/virtio/cmd.c
> > > @@ -0,0 +1,146 @@
> > > +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> > > +/*
> > > + * Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved
> > > + */
> > > +
> > > +#include "cmd.h"
> > > +
> > > +int virtiovf_cmd_list_query(struct pci_dev *pdev, u8 *buf, int buf_size)
> > > +{
> > > +	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
> > > +	struct scatterlist out_sg;
> > > +	struct virtio_admin_cmd cmd = {};
> > > +
> > > +	if (!virtio_dev)
> > > +		return -ENOTCONN;
> > > +
> > > +	sg_init_one(&out_sg, buf, buf_size);
> > > +	cmd.opcode = VIRTIO_ADMIN_CMD_LIST_QUERY;
> > > +	cmd.group_type = VIRTIO_ADMIN_GROUP_TYPE_SRIOV;
> > > +	cmd.result_sg = &out_sg;
> > > +
> > > +	return virtio_admin_cmd_exec(virtio_dev, &cmd);
> > > +}
> > > +
> > > +int virtiovf_cmd_list_use(struct pci_dev *pdev, u8 *buf, int buf_size)
> > > +{
> > > +	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
> > > +	struct scatterlist in_sg;
> > > +	struct virtio_admin_cmd cmd = {};
> > > +
> > > +	if (!virtio_dev)
> > > +		return -ENOTCONN;
> > > +
> > > +	sg_init_one(&in_sg, buf, buf_size);
> > > +	cmd.opcode = VIRTIO_ADMIN_CMD_LIST_USE;
> > > +	cmd.group_type = VIRTIO_ADMIN_GROUP_TYPE_SRIOV;
> > > +	cmd.data_sg = &in_sg;
> > > +
> > > +	return virtio_admin_cmd_exec(virtio_dev, &cmd);
> > > +}
> > > +
> > > +int virtiovf_cmd_lr_write(struct virtiovf_pci_core_device *virtvdev, u16 opcode,
> > > +			  u8 offset, u8 size, u8 *buf)
> > > +{
> > > +	struct virtio_device *virtio_dev =
> > > +		virtio_pci_vf_get_pf_dev(virtvdev->core_device.pdev);
> > > +	struct virtio_admin_cmd_data_lr_write *in;
> > > +	struct scatterlist in_sg;
> > > +	struct virtio_admin_cmd cmd = {};
> > > +	int ret;
> > > +
> > > +	if (!virtio_dev)
> > > +		return -ENOTCONN;
> > > +
> > > +	in = kzalloc(sizeof(*in) + size, GFP_KERNEL);
> > > +	if (!in)
> > > +		return -ENOMEM;
> > > +
> > > +	in->offset = offset;
> > > +	memcpy(in->registers, buf, size);
> > > +	sg_init_one(&in_sg, in, sizeof(*in) + size);
> > > +	cmd.opcode = opcode;
> > > +	cmd.group_type = VIRTIO_ADMIN_GROUP_TYPE_SRIOV;
> > > +	cmd.group_member_id = virtvdev->vf_id + 1;
> > > +	cmd.data_sg = &in_sg;
> > > +	ret = virtio_admin_cmd_exec(virtio_dev, &cmd);
> > > +
> > > +	kfree(in);
> > > +	return ret;
> > > +}
> > > +
> > > +int virtiovf_cmd_lr_read(struct virtiovf_pci_core_device *virtvdev, u16 opcode,
> > > +			 u8 offset, u8 size, u8 *buf)
> > > +{
> > > +	struct virtio_device *virtio_dev =
> > > +		virtio_pci_vf_get_pf_dev(virtvdev->core_device.pdev);
> > > +	struct virtio_admin_cmd_data_lr_read *in;
> > > +	struct scatterlist in_sg, out_sg;
> > > +	struct virtio_admin_cmd cmd = {};
> > > +	int ret;
> > > +
> > > +	if (!virtio_dev)
> > > +		return -ENOTCONN;
> > > +
> > > +	in = kzalloc(sizeof(*in), GFP_KERNEL);
> > > +	if (!in)
> > > +		return -ENOMEM;
> > > +
> > > +	in->offset = offset;
> > > +	sg_init_one(&in_sg, in, sizeof(*in));
> > > +	sg_init_one(&out_sg, buf, size);
> > > +	cmd.opcode = opcode;
> > > +	cmd.group_type = VIRTIO_ADMIN_GROUP_TYPE_SRIOV;
> > > +	cmd.data_sg = &in_sg;
> > > +	cmd.result_sg = &out_sg;
> > > +	cmd.group_member_id = virtvdev->vf_id + 1;
> > > +	ret = virtio_admin_cmd_exec(virtio_dev, &cmd);
> > > +
> > > +	kfree(in);
> > > +	return ret;
> > > +}
> > > +
> > > +int virtiovf_cmd_lq_read_notify(struct virtiovf_pci_core_device *virtvdev,
> > > +				u8 req_bar_flags, u8 *bar, u64 *bar_offset)
> > > +{
> > > +	struct virtio_device *virtio_dev =
> > > +		virtio_pci_vf_get_pf_dev(virtvdev->core_device.pdev);
> > > +	struct virtio_admin_cmd_notify_info_result *out;
> > > +	struct scatterlist out_sg;
> > > +	struct virtio_admin_cmd cmd = {};
> > > +	int ret;
> > > +
> > > +	if (!virtio_dev)
> > > +		return -ENOTCONN;
> > > +
> > > +	out = kzalloc(sizeof(*out), GFP_KERNEL);
> > > +	if (!out)
> > > +		return -ENOMEM;
> > > +
> > > +	sg_init_one(&out_sg, out, sizeof(*out));
> > > +	cmd.opcode = VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO;
> > > +	cmd.group_type = VIRTIO_ADMIN_GROUP_TYPE_SRIOV;
> > > +	cmd.result_sg = &out_sg;
> > > +	cmd.group_member_id = virtvdev->vf_id + 1;
> > > +	ret = virtio_admin_cmd_exec(virtio_dev, &cmd);
> > > +	if (!ret) {
> > > +		struct virtio_admin_cmd_notify_info_data *entry;
> > > +		int i;
> > > +
> > > +		ret = -ENOENT;
> > > +		for (i = 0; i < VIRTIO_ADMIN_CMD_MAX_NOTIFY_INFO; i++) {
> > > +			entry = &out->entries[i];
> > > +			if (entry->flags == VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_END)
> > > +				break;
> > > +			if (entry->flags != req_bar_flags)
> > > +				continue;
> > > +			*bar = entry->bar;
> > > +			*bar_offset = le64_to_cpu(entry->offset);
> > > +			ret = 0;
> > > +			break;
> > > +		}
> > > +	}
> > > +
> > > +	kfree(out);
> > > +	return ret;
> > > +}
> > > diff --git a/drivers/vfio/pci/virtio/cmd.h b/drivers/vfio/pci/virtio/cmd.h
> > > new file mode 100644
> > > index 000000000000..c2a3645f4b90
> > > --- /dev/null
> > > +++ b/drivers/vfio/pci/virtio/cmd.h
> > > @@ -0,0 +1,27 @@
> > > +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> > > +/*
> > > + * Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
> > > + */
> > > +
> > > +#ifndef VIRTIO_VFIO_CMD_H
> > > +#define VIRTIO_VFIO_CMD_H
> > > +
> > > +#include <linux/kernel.h>
> > > +#include <linux/virtio.h>
> > > +#include <linux/vfio_pci_core.h>
> > > +#include <linux/virtio_pci.h>
> > > +
> > > +struct virtiovf_pci_core_device {
> > > +	struct vfio_pci_core_device core_device;
> > > +	int vf_id;
> > > +};
> > > +
> > > +int virtiovf_cmd_list_query(struct pci_dev *pdev, u8 *buf, int buf_size);
> > > +int virtiovf_cmd_list_use(struct pci_dev *pdev, u8 *buf, int buf_size);
> > > +int virtiovf_cmd_lr_write(struct virtiovf_pci_core_device *virtvdev, u16 opcode,
> > > +			  u8 offset, u8 size, u8 *buf);
> > > +int virtiovf_cmd_lr_read(struct virtiovf_pci_core_device *virtvdev, u16 opcode,
> > > +			 u8 offset, u8 size, u8 *buf);
> > > +int virtiovf_cmd_lq_read_notify(struct virtiovf_pci_core_device *virtvdev,
> > > +				u8 req_bar_flags, u8 *bar, u64 *bar_offset);
> > > +#endif /* VIRTIO_VFIO_CMD_H */
> > > -- 
> > > 2.27.0
> 

