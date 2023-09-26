Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4DF7AEB72
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 13:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbjIZL0Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 07:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjIZL0O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 07:26:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5527101
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 04:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695727526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rkvKpRNFb5MSdbKhJllaoFWTbeB2crbS+rAr6CEJ+5c=;
        b=I47quK6wsf6tFvW1iOr4Wcf1ReC+sXCdcwzFOcQoIm1cczGJSwEiQDyPvng8e63KJm2hoE
        LlOjdV9i5c/sLOnhsAwX6rLZ4z3dqFEYEL0atE0RNUsAdd1Hqof+fw1aRyUU9VJg9Co7Hg
        Yq7geKs1uG209bI0uKtVwLejUsGSST8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-SaOaxSl7OAe-u7dpLBDYWg-1; Tue, 26 Sep 2023 07:25:23 -0400
X-MC-Unique: SaOaxSl7OAe-u7dpLBDYWg-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-51bee352ffcso6503787a12.1
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 04:25:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695727522; x=1696332322;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rkvKpRNFb5MSdbKhJllaoFWTbeB2crbS+rAr6CEJ+5c=;
        b=GjngZLwwjRyZCzgCQid4GT3lAliMVN5y1L0gvsEJOj8n3lM5kVL+Kjh/A2p1g0BHMi
         mdTw463xNWaTjBDtbzgivwprrzCSkkufMgEvMnu84QE4+ob8RGaBPGq5n8oEXjFHrEmf
         XV9YGGWY42CfYoXNus3YWI9zXoRiefj7X2XKiRSsOVGC1IA6VJRBOvQDIjuFUifRdGSl
         /pGlzJuiut1WfeFbxjUQMOVTBLtmwsKp1q1/ooLsaRWPCa7GhfQbkDHX+U+5ZbbmJqJ8
         lhQY4KvOJTrBdwgoHczlUNbrRqcqHx2s6g7NaxC0FIYCasTZGFjUZwdD3C6tsfYNROUT
         m6nA==
X-Gm-Message-State: AOJu0Yzd1Uta4ZhguTVaEsywU7r/X7e5DoWTHE8UVWq90dWfALV0t2R9
        ActckWqg3p5D7JBwQ68q1Q7GevHZig0kDLjR661EXQ/ahF20BYdAENWZW3CMNyadN6xryexQ5q/
        oki/12Jq9IkoT
X-Received: by 2002:aa7:c318:0:b0:525:442b:6068 with SMTP id l24-20020aa7c318000000b00525442b6068mr8634581edq.13.1695727522385;
        Tue, 26 Sep 2023 04:25:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IErvxkNDMNbAqiOng2Q8bY58/9dyu2SOFFD+IouyH79BUcSfofinAcZozjpsSx40Ysi+rMqZA==
X-Received: by 2002:aa7:c318:0:b0:525:442b:6068 with SMTP id l24-20020aa7c318000000b00525442b6068mr8634570edq.13.1695727522001;
        Tue, 26 Sep 2023 04:25:22 -0700 (PDT)
Received: from redhat.com ([2.52.31.177])
        by smtp.gmail.com with ESMTPSA id h9-20020aa7c609000000b00532c1dfe8ecsm6559167edq.66.2023.09.26.04.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 04:25:21 -0700 (PDT)
Date:   Tue, 26 Sep 2023 07:25:17 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     alex.williamson@redhat.com, jasowang@redhat.com, jgg@nvidia.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20230926071350-mutt-send-email-mst@kernel.org>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-11-yishaih@nvidia.com>
 <20230921162621-mutt-send-email-mst@kernel.org>
 <cf657792-c21a-4ef7-737d-402239ce557d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cf657792-c21a-4ef7-737d-402239ce557d@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 26, 2023 at 01:51:13PM +0300, Yishai Hadas wrote:
> On 21/09/2023 23:34, Michael S. Tsirkin wrote:
> > On Thu, Sep 21, 2023 at 03:40:39PM +0300, Yishai Hadas wrote:
> > > Expose admin commands over the virtio device, to be used by the
> > > vfio-virtio driver in the next patches.
> > > 
> > > It includes: list query/use, legacy write/read, read notify_info.
> > > 
> > > Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
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
> > in/out seem all wrong here. In virtio terminology, in means from
> > device to driver, out means from driver to device.
> I referred here to in/out from vfio POV who prepares the command.
> 
> However, I can replace it to follow the virtio terminology as you suggested
> if this more makes sense.
> 
> Please see also my coming answer on your suggestion to put all of this in
> the virtio layer.
> 
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
> > 
> > what is _lr short for?
> 
> This was an acronym to legacy_read.
> 
> The actual command is according to the given opcode which can be one among
> LEGACY_COMMON_CFG_READ, LEGACY_DEV_CFG_READ.
> 
> I can rename it to '_legacy_read' (i.e. virtiovf_issue_legacy_read_cmd) to
> be clearer.
> 
> > 
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
> > weird. why + 1?
> 
> This follows the virtio spec in that area.
> 
> "When sending commands with the SR-IOV group type, the driver specify a
> value for group_member_id
> between 1 and NumVFs inclusive."

Ah, I get it. Pls add a comment.

> The 'virtvdev->vf_id' was set upon vfio/virtio driver initialization by
> pci_iov_vf_id() which its first index is 0.
> 
> > > +	cmd.data_sg = &in_sg;
> > > +	ret = virtio_admin_cmd_exec(virtio_dev, &cmd);
> > > +
> > > +	kfree(in);
> > > +	return ret;
> > > +}
> > How do you know it's safe to send this command, in particular at
> > this time? This seems to be doing zero checks, and zero synchronization
> > with the PF driver.
> > 
> The virtiovf_cmd_lr_read()/other gets a virtio VF and it gets its PF by
> calling virtio_pci_vf_get_pf_dev().
> 
> The VF can't gone by 'disable sriov' as it's owned/used by vfio.
> 
> The PF can't gone by rmmod/modprobe -r of virtio, as of the 'module in
> use'/dependencies between VFIO to VIRTIO.
> 
> The below check [1] was done only from a clean code perspective, which might
> theoretically fail in case the given VF doesn't use a virtio driver.
> 
> [1] if (!virtio_dev)
>         return -ENOTCONN;
> 
> So, it looks safe as is.

Can the device can be unbound from module right after you did the check?
What about suspend - can this be called while suspend is in progress?


More importantly, virtio can decide to reset the device for its
own internal reasons (e.g. to recover from an error).
We used to do it when attaching XDP, and we can start doing it again.
That's one of the reasons why I want all this code under virtio, so we'll remember.


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
> > and what is lq short for?
> 
> To be more explicit, I may replace to virtiovf_cmd_legacy_notify_info() to
> follow the spec opcode.
> 
> Yishai
> 
> > 
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

