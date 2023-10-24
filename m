Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8F47D5CDA
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 23:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344313AbjJXVCg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 17:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbjJXVCe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 17:02:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57F010D4
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 14:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698181310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=msH1BFGDXU4Ck//kTMZ4kAjtkY8sp3CpLRtM1t2O4Bo=;
        b=FARR26z7iBd1uMEmG8C/2nlcrsAKohqy+4zfygudhwj2JvuzxjqqXoqyyUkVbOBgECO4WW
        g5VyXhRGFyf0MoW8Cm2PFwrNfCSiaw1kPlpvgQ5HcfvL0KBOD9asjfzhxVqASeJvu3+pbh
        KWJd9RUKbgd+UcBcGRcgaLtWzIvZ3u0=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-150-uwmiYCoYOVW01BxdsERuxw-1; Tue, 24 Oct 2023 17:01:48 -0400
X-MC-Unique: uwmiYCoYOVW01BxdsERuxw-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-507c4c57567so4977391e87.0
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 14:01:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698181307; x=1698786107;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=msH1BFGDXU4Ck//kTMZ4kAjtkY8sp3CpLRtM1t2O4Bo=;
        b=azeGds2KzX6aqdBpTEFA4ijnxcxQJdZGU7HdC+PSlkKparO6naXXNByF4/S3F+7/rf
         qnsI+g9+TWH4Am4KapgywSZH9mkhAMY+fhOSRp7V3seO3LnCGPwdrlvlePP3j2zksqbt
         syOo9/NRV20ePKihyX93waSk5bNJIYtuP9GOvC+S6gTTO/sxLxgzkBsWQd1wOzZXiF7f
         fmoBsYUiseBKfv8LQ2GZGWw1kFSRB3txMUk/DXMhShryPfx7sozy/CicMCOwVV5p/943
         v5+JSjq56xwdNR3hW16PJveGITJNqFZdYqPcGHDXCon+J0RhZ/qu56KrBJIXgkaOKdqs
         QvvQ==
X-Gm-Message-State: AOJu0YxGffXNsMbWNr/LjL+UWcUHfUlqQmmaaOuL4aNqUmOUvzbnGDgf
        7zJc8GiFN4zEObpA0bXf4RcOiJ0jdrqjASGsP8w7QwzstWFi8yXS12Y512mOv8MfI52il9fQeXu
        /rSYftbmaF/B5
X-Received: by 2002:a19:5004:0:b0:4ff:a04c:8a5b with SMTP id e4-20020a195004000000b004ffa04c8a5bmr8803174lfb.47.1698181307195;
        Tue, 24 Oct 2023 14:01:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHfYUjUKsW+pSOx7M8EZ3JWU1rj1JFpl73sVMDGoIAkc023GFWRa4uRR88z4fXgSvptmqyfbA==
X-Received: by 2002:a19:5004:0:b0:4ff:a04c:8a5b with SMTP id e4-20020a195004000000b004ffa04c8a5bmr8803157lfb.47.1698181306803;
        Tue, 24 Oct 2023 14:01:46 -0700 (PDT)
Received: from redhat.com ([176.12.184.108])
        by smtp.gmail.com with ESMTPSA id dj18-20020a0560000b1200b0032d96dd703bsm10700966wrb.70.2023.10.24.14.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 14:01:45 -0700 (PDT)
Date:   Tue, 24 Oct 2023 17:01:40 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     alex.williamson@redhat.com, jasowang@redhat.com, jgg@nvidia.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com,
        si-wei.liu@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V1 vfio 6/9] virtio-pci: Introduce APIs to execute legacy
 IO admin commands
Message-ID: <20231024165210-mutt-send-email-mst@kernel.org>
References: <20231017134217.82497-1-yishaih@nvidia.com>
 <20231017134217.82497-7-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231017134217.82497-7-yishaih@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 17, 2023 at 04:42:14PM +0300, Yishai Hadas wrote:
> Introduce APIs to execute legacy IO admin commands.
> 
> It includes: list_query/use, io_legacy_read/write,
> io_legacy_notify_info.
> 
> Those APIs will be used by the next patches from this series.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/virtio/virtio_pci_common.c |  11 ++
>  drivers/virtio/virtio_pci_common.h |   2 +
>  drivers/virtio/virtio_pci_modern.c | 206 +++++++++++++++++++++++++++++
>  include/linux/virtio_pci_admin.h   |  18 +++
>  4 files changed, 237 insertions(+)
>  create mode 100644 include/linux/virtio_pci_admin.h
> 
> diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
> index 6b4766d5abe6..212d68401d2c 100644
> --- a/drivers/virtio/virtio_pci_common.c
> +++ b/drivers/virtio/virtio_pci_common.c
> @@ -645,6 +645,17 @@ static struct pci_driver virtio_pci_driver = {
>  	.sriov_configure = virtio_pci_sriov_configure,
>  };
>  
> +struct virtio_device *virtio_pci_vf_get_pf_dev(struct pci_dev *pdev)
> +{
> +	struct virtio_pci_device *pf_vp_dev;
> +
> +	pf_vp_dev = pci_iov_get_pf_drvdata(pdev, &virtio_pci_driver);
> +	if (IS_ERR(pf_vp_dev))
> +		return NULL;
> +
> +	return &pf_vp_dev->vdev;
> +}
> +
>  module_pci_driver(virtio_pci_driver);
>  
>  MODULE_AUTHOR("Anthony Liguori <aliguori@us.ibm.com>");
> diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
> index a21b9ba01a60..2785e61ed668 100644
> --- a/drivers/virtio/virtio_pci_common.h
> +++ b/drivers/virtio/virtio_pci_common.h
> @@ -155,4 +155,6 @@ static inline void virtio_pci_legacy_remove(struct virtio_pci_device *vp_dev)
>  int virtio_pci_modern_probe(struct virtio_pci_device *);
>  void virtio_pci_modern_remove(struct virtio_pci_device *);
>  
> +struct virtio_device *virtio_pci_vf_get_pf_dev(struct pci_dev *pdev);
> +
>  #endif
> diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
> index cc159a8e6c70..00b65e20b2f5 100644
> --- a/drivers/virtio/virtio_pci_modern.c
> +++ b/drivers/virtio/virtio_pci_modern.c
> @@ -719,6 +719,212 @@ static void vp_modern_destroy_avq(struct virtio_device *vdev)
>  	vp_dev->del_vq(&vp_dev->admin_vq.info);
>  }
>  
> +/*
> + * virtio_pci_admin_list_query - Provides to driver list of commands
> + * supported for the PCI VF.
> + * @dev: VF pci_dev
> + * @buf: buffer to hold the returned list
> + * @buf_size: size of the given buffer
> + *
> + * Returns 0 on success, or negative on failure.
> + */
> +int virtio_pci_admin_list_query(struct pci_dev *pdev, u8 *buf, int buf_size)
> +{
> +	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
> +	struct virtio_admin_cmd cmd = {};
> +	struct scatterlist result_sg;
> +
> +	if (!virtio_dev)
> +		return -ENODEV;
> +
> +	sg_init_one(&result_sg, buf, buf_size);
> +	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LIST_QUERY);
> +	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
> +	cmd.result_sg = &result_sg;
> +
> +	return vp_modern_admin_cmd_exec(virtio_dev, &cmd);
> +}
> +EXPORT_SYMBOL_GPL(virtio_pci_admin_list_query);
> +
> +/*
> + * virtio_pci_admin_list_use - Provides to device list of commands
> + * used for the PCI VF.
> + * @dev: VF pci_dev
> + * @buf: buffer which holds the list
> + * @buf_size: size of the given buffer
> + *
> + * Returns 0 on success, or negative on failure.
> + */
> +int virtio_pci_admin_list_use(struct pci_dev *pdev, u8 *buf, int buf_size)
> +{
> +	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
> +	struct virtio_admin_cmd cmd = {};
> +	struct scatterlist data_sg;
> +
> +	if (!virtio_dev)
> +		return -ENODEV;
> +
> +	sg_init_one(&data_sg, buf, buf_size);
> +	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LIST_USE);
> +	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
> +	cmd.data_sg = &data_sg;
> +
> +	return vp_modern_admin_cmd_exec(virtio_dev, &cmd);
> +}
> +EXPORT_SYMBOL_GPL(virtio_pci_admin_list_use);

list commands are actually for a group, not for the VF.

> +
> +/*
> + * virtio_pci_admin_legacy_io_write - Write legacy registers of a member device
> + * @dev: VF pci_dev
> + * @opcode: op code of the io write command

opcode is actually either VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE
or VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE correct?

So please just add 2 APIs for this so users don't need to care.
Could be wrappers around these two things.




> + * @offset: starting byte offset within the registers to write to
> + * @size: size of the data to write
> + * @buf: buffer which holds the data
> + *
> + * Returns 0 on success, or negative on failure.
> + */
> +int virtio_pci_admin_legacy_io_write(struct pci_dev *pdev, u16 opcode,
> +				     u8 offset, u8 size, u8 *buf)
> +{
> +	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
> +	struct virtio_admin_cmd_legacy_wr_data *data;
> +	struct virtio_admin_cmd cmd = {};
> +	struct scatterlist data_sg;
> +	int vf_id;
> +	int ret;
> +
> +	if (!virtio_dev)
> +		return -ENODEV;
> +
> +	vf_id = pci_iov_vf_id(pdev);
> +	if (vf_id < 0)
> +		return vf_id;
> +
> +	data = kzalloc(sizeof(*data) + size, GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	data->offset = offset;
> +	memcpy(data->registers, buf, size);
> +	sg_init_one(&data_sg, data, sizeof(*data) + size);
> +	cmd.opcode = cpu_to_le16(opcode);
> +	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
> +	cmd.group_member_id = cpu_to_le64(vf_id + 1);
> +	cmd.data_sg = &data_sg;
> +	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
> +
> +	kfree(data);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_io_write);
> +
> +/*
> + * virtio_pci_admin_legacy_io_read - Read legacy registers of a member device
> + * @dev: VF pci_dev
> + * @opcode: op code of the io read command
> + * @offset: starting byte offset within the registers to read from
> + * @size: size of the data to be read
> + * @buf: buffer to hold the returned data
> + *
> + * Returns 0 on success, or negative on failure.
> + */
> +int virtio_pci_admin_legacy_io_read(struct pci_dev *pdev, u16 opcode,
> +				    u8 offset, u8 size, u8 *buf)
> +{
> +	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
> +	struct virtio_admin_cmd_legacy_rd_data *data;
> +	struct scatterlist data_sg, result_sg;
> +	struct virtio_admin_cmd cmd = {};
> +	int vf_id;
> +	int ret;
> +
> +	if (!virtio_dev)
> +		return -ENODEV;
> +
> +	vf_id = pci_iov_vf_id(pdev);
> +	if (vf_id < 0)
> +		return vf_id;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	data->offset = offset;
> +	sg_init_one(&data_sg, data, sizeof(*data));
> +	sg_init_one(&result_sg, buf, size);
> +	cmd.opcode = cpu_to_le16(opcode);
> +	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
> +	cmd.group_member_id = cpu_to_le64(vf_id + 1);
> +	cmd.data_sg = &data_sg;
> +	cmd.result_sg = &result_sg;
> +	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
> +
> +	kfree(data);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_io_read);
> +
> +/*
> + * virtio_pci_admin_legacy_io_notify_info - Read the queue notification
> + * information for legacy interface
> + * @dev: VF pci_dev
> + * @req_bar_flags: requested bar flags
> + * @bar: on output the BAR number of the member device
> + * @bar_offset: on output the offset within bar
> + *
> + * Returns 0 on success, or negative on failure.
> + */
> +int virtio_pci_admin_legacy_io_notify_info(struct pci_dev *pdev,
> +					   u8 req_bar_flags, u8 *bar,
> +					   u64 *bar_offset)
> +{
> +	struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
> +	struct virtio_admin_cmd_notify_info_result *result;
> +	struct virtio_admin_cmd cmd = {};
> +	struct scatterlist result_sg;
> +	int vf_id;
> +	int ret;
> +
> +	if (!virtio_dev)
> +		return -ENODEV;
> +
> +	vf_id = pci_iov_vf_id(pdev);
> +	if (vf_id < 0)
> +		return vf_id;
> +
> +	result = kzalloc(sizeof(*result), GFP_KERNEL);
> +	if (!result)
> +		return -ENOMEM;
> +
> +	sg_init_one(&result_sg, result, sizeof(*result));
> +	cmd.opcode = cpu_to_le16(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO);
> +	cmd.group_type = cpu_to_le16(VIRTIO_ADMIN_GROUP_TYPE_SRIOV);
> +	cmd.group_member_id = cpu_to_le64(vf_id + 1);
> +	cmd.result_sg = &result_sg;
> +	ret = vp_modern_admin_cmd_exec(virtio_dev, &cmd);
> +	if (!ret) {
> +		struct virtio_admin_cmd_notify_info_data *entry;
> +		int i;
> +
> +		ret = -ENOENT;
> +		for (i = 0; i < VIRTIO_ADMIN_CMD_MAX_NOTIFY_INFO; i++) {
> +			entry = &result->entries[i];
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
> +	kfree(result);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(virtio_pci_admin_legacy_io_notify_info);
> +
>  static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
>  	.get		= NULL,
>  	.set		= NULL,
> diff --git a/include/linux/virtio_pci_admin.h b/include/linux/virtio_pci_admin.h
> new file mode 100644
> index 000000000000..cb916a4bc1b1
> --- /dev/null
> +++ b/include/linux/virtio_pci_admin.h
> @@ -0,0 +1,18 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_VIRTIO_PCI_ADMIN_H
> +#define _LINUX_VIRTIO_PCI_ADMIN_H
> +
> +#include <linux/types.h>
> +#include <linux/pci.h>
> +
> +int virtio_pci_admin_list_use(struct pci_dev *pdev, u8 *buf, int buf_size);
> +int virtio_pci_admin_list_query(struct pci_dev *pdev, u8 *buf, int buf_size);
> +int virtio_pci_admin_legacy_io_write(struct pci_dev *pdev, u16 opcode,
> +				     u8 offset, u8 size, u8 *buf);
> +int virtio_pci_admin_legacy_io_read(struct pci_dev *pdev, u16 opcode,
> +				    u8 offset, u8 size, u8 *buf);
> +int virtio_pci_admin_legacy_io_notify_info(struct pci_dev *pdev,
> +					   u8 req_bar_flags, u8 *bar,
> +					   u64 *bar_offset);
> +
> +#endif /* _LINUX_VIRTIO_PCI_ADMIN_H */
> -- 
> 2.27.0

