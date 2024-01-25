Return-Path: <kvm+bounces-7031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C459883CF88
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 23:38:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72E062871C8
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 22:38:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41C12111A6;
	Thu, 25 Jan 2024 22:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SknHCqp0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F62611197
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 22:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706222323; cv=none; b=IFHJbBiYaicBAIrfvWAeroKkvFuofNJjfjCaQ0WFjttILDWxDs7+ks14rYXkXarmDnrqCqj3hucFEoVZ23ScmenzRWbxVOdMjsHIjzM9wS+8zRq23TJVYWtLgP7Pu4xJnaKt9Q0VQGl3d5GCbiNe21tfpz8hV25uqHplb8idhSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706222323; c=relaxed/simple;
	bh=hcbMm5RvNnGZCy97DAVnC/35RcWJHdvKEM8oSvYPXZw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n6XI6EU1KTZEpst8ra62goYQ1f+Crj5Fc8dTVE6E8SsjCFAnCy3w0KXwmykoI/icWhhOeoQo1W6duHNZKgzw4HqIJ/xxzfKGcOon3voP8lSwQQglrdyysaRjY3uT9bPawTvmdq4OELtiH5G5MTwVqmbFXbbcUEtGU9Wzx5YxBeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SknHCqp0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706222320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RGQb4L8KpW5EiamQAXLVpLHzgbujQtLCkeVqSde9RaQ=;
	b=SknHCqp0W34Rq1GUoR5Wll+xXk2mtAHWG0dFPVA63mAkK1lM2rrgu9fa8aiVmTOE8nFdeG
	MQXXzMNyjFgTRK8Nukx4l/pXWAMOT4EK10QPowzKfQLL2S0r4rwEXxKCkIBPxJNgy60D+H
	oGTG9oa4QL8SfjxauHtzcmtV01mQ8/A=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-482-2XvwN5HOO9uzkCpXrZeLZg-1; Thu, 25 Jan 2024 17:38:39 -0500
X-MC-Unique: 2XvwN5HOO9uzkCpXrZeLZg-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7bbb3de4dcbso1106498339f.1
        for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 14:38:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706222318; x=1706827118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RGQb4L8KpW5EiamQAXLVpLHzgbujQtLCkeVqSde9RaQ=;
        b=CYz9FIZ8A8LDauJQppqHz+KFu0/89um/0EVFt2WSNKaW51jghi5cc2FOV73QcZlGpU
         hbKnOfqtsNmreUhxZyVDfgWSUJJI7+bnl79sR1J5ZvH5+C+A9LrN5yTKRixd0bockO64
         LyN1U/DdeG/dbqptYPo3tNa7XGYCtTq7Tf7Gq8W8dYgCr+WngVDYBwKm/DcOjQGXBr5j
         XIdED1hNl8/i7TCN5gLNm9HbX/7sae/JT6Y0o4LVfuY3NbM6nhHnNZhrzo8S8HBUR0an
         0N8tCWk1Gcbl8vbmz9TLMtULzkH5KeqecVIG0aK9uoCz+UZoYXuouAZ3VIumYjY547P/
         Vycg==
X-Gm-Message-State: AOJu0YwujUf8q0wNxr/u2ysk8+4DgwyRZCDE1/FHpVYGpcDJYv1pDptR
	TCAS6gXUqRaFd1vRfBKIG50sxaPNG5T0v3oBkKjk2WSvxWXqLQYSoxWB4S/VRp8Sxq0l90yKnaq
	4nirEBL6B38pA001C9CbTLf1LhxOqyP0s5hUOEPEkGWcUb2LD3Q==
X-Received: by 2002:a05:6602:9a:b0:7bf:7a2f:e1b7 with SMTP id h26-20020a056602009a00b007bf7a2fe1b7mr394710iob.29.1706222318222;
        Thu, 25 Jan 2024 14:38:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG36TczQNkj5atMZ/iFym1C85HAUrVZkkTdh/CbSt1tIbs/OJCn5LAZk0dx8BfqcCWVdE1zfw==
X-Received: by 2002:a05:6602:9a:b0:7bf:7a2f:e1b7 with SMTP id h26-20020a056602009a00b007bf7a2fe1b7mr394704iob.29.1706222317910;
        Thu, 25 Jan 2024 14:38:37 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id cu1-20020a05663848c100b0046ec91c39bfsm3443831jab.53.2024.01.25.14.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jan 2024 14:38:37 -0800 (PST)
Date: Thu, 25 Jan 2024 15:38:34 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Longfang Liu <liulongfang@huawei.com>
Cc: <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
 <jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: Re: [PATCH 2/3] hisi_acc_vfio_pci: register debugfs for hisilicon
 migration driver
Message-ID: <20240125153834.3f44bbad.alex.williamson@redhat.com>
In-Reply-To: <20240125081031.48707-3-liulongfang@huawei.com>
References: <20240125081031.48707-1-liulongfang@huawei.com>
	<20240125081031.48707-3-liulongfang@huawei.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 25 Jan 2024 16:10:30 +0800
Longfang Liu <liulongfang@huawei.com> wrote:

> On the debugfs framework of VFIO, if the CONFIG_VFIO_DEBUGFS macro is
> enabled, the debug function is registered for the live migration driver
> of the HiSilicon accelerator device.
> 
> After registering the HiSilicon accelerator device on the debugfs
> framework of live migration of vfio, a directory file "hisi_acc"
> of debugfs is created, and then three debug function files are
> created in this directory:
> 
>    vfio
>     |
>     +---<dev_name1>
>     |    +---migration
>     |        +--state
>     |        +--hisi_acc
>     |            +--attr
>     |            +--data
>     |            +--save
>     |            +--cmd_state
>     |
>     +---<dev_name2>
>          +---migration
>              +--state
>              +--hisi_acc
>                  +--attr
>                  +--data
>                  +--save
>                  +--cmd_state
> 
> data file: used to get the migration data from the driver
> attr file: used to get device attributes parameters from the driver
> save file: used to read the data of the live migration device and save
> it to the driver.
> cmd_state: used to get the cmd channel state for the device.
> 
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 190 ++++++++++++++++++
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |   5 +
>  2 files changed, 195 insertions(+)
> 
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index 5f6e01571a7b..2cbbc52b7377 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -15,6 +15,7 @@
>  #include <linux/anon_inodes.h>
>  
>  #include "hisi_acc_vfio_pci.h"
> +#include "../../vfio.h"
>  
>  /* Return 0 on VM acc device ready, -ETIMEDOUT hardware timeout */
>  static int qm_wait_dev_not_ready(struct hisi_qm *qm)
> @@ -617,6 +618,18 @@ hisi_acc_check_int_state(struct hisi_acc_vf_core_device *hisi_acc_vdev)
>  	}
>  }
>  
> +static void hisi_acc_vf_migf_save(struct hisi_acc_vf_migration_file *dst_migf,
> +	struct hisi_acc_vf_migration_file *src_migf)
> +{
> +	if (!dst_migf)
> +		return;
> +
> +	dst_migf->disabled = false;
> +	dst_migf->total_length = src_migf->total_length;
> +	memcpy(&dst_migf->vf_data, &src_migf->vf_data,
> +		    sizeof(struct acc_vf_data));
> +}
> +
>  static void hisi_acc_vf_disable_fd(struct hisi_acc_vf_migration_file *migf)
>  {
>  	mutex_lock(&migf->lock);
> @@ -629,12 +642,16 @@ static void hisi_acc_vf_disable_fd(struct hisi_acc_vf_migration_file *migf)
>  static void hisi_acc_vf_disable_fds(struct hisi_acc_vf_core_device *hisi_acc_vdev)
>  {
>  	if (hisi_acc_vdev->resuming_migf) {
> +		hisi_acc_vf_migf_save(hisi_acc_vdev->debug_migf,
> +						hisi_acc_vdev->resuming_migf);
>  		hisi_acc_vf_disable_fd(hisi_acc_vdev->resuming_migf);
>  		fput(hisi_acc_vdev->resuming_migf->filp);
>  		hisi_acc_vdev->resuming_migf = NULL;
>  	}
>  
>  	if (hisi_acc_vdev->saving_migf) {
> +		hisi_acc_vf_migf_save(hisi_acc_vdev->debug_migf,
> +						hisi_acc_vdev->saving_migf);
>  		hisi_acc_vf_disable_fd(hisi_acc_vdev->saving_migf);
>  		fput(hisi_acc_vdev->saving_migf->filp);
>  		hisi_acc_vdev->saving_migf = NULL;
> @@ -1175,6 +1192,7 @@ static int hisi_acc_vf_qm_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
>  	if (!vf_qm->io_base)
>  		return -EIO;
>  
> +	mutex_init(&hisi_acc_vdev->enable_mutex);
>  	vf_qm->fun_type = QM_HW_VF;
>  	vf_qm->pdev = vf_dev;
>  	mutex_init(&vf_qm->mailbox_lock);
> @@ -1325,6 +1343,172 @@ static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int
>  	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
>  }
>  
> +static int hisi_acc_vf_debug_check(struct seq_file *seq, struct vfio_device *vdev)
> +{
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
> +	struct hisi_acc_vf_migration_file *migf = hisi_acc_vdev->debug_migf;
> +
> +	if (!vdev->mig_ops || !migf) {
> +		seq_printf(seq, "%s\n", "device does not support live migration!");
> +		return -EINVAL;
> +	}
> +
> +	/**
> +	 * When the device is not opened, the io_base is not mapped.
> +	 * The driver cannot perform device read and write operations.
> +	 */
> +	if (!vdev->open_count) {
> +		seq_printf(seq, "%s\n", "device not opened!");
> +		return -EINVAL;
> +	}

This is racy, this check could occur while the user is already closing
the device and vfio_df_device_last_close() may have already iounmap'd
the io_base.  Only after that is open_count decremented.  The debugfs
interfaces would then proceed to access the unmapped space.  The
enable_mutex is entirely ineffective (and also asymmetric, initialized
in the open_device path but never destroyed).

In fact, the enable_mutex really only seems to be trying to protect
io_base (which it doesn't do), meanwhile the core driver execution path
can run concurrently to debugfs operations with no serialization.  It
looks like these operations would step on each other.

I think you might need an atomic to guard against io_base unmapping and
then maybe a mutex or semaphore to avoid debugfs accesses from
interfering with the actual core logic interacting with the device.
Thanks,

Alex

> +
> +	return 0;
> +}
> +
> +static int hisi_acc_vf_debug_cmd(struct seq_file *seq, void *data)
> +{
> +	struct device *vf_dev = seq->private;
> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
> +	struct vfio_device *vdev = &core_device->vdev;
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
> +	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
> +	u64 value;
> +	int ret;
> +
> +	ret = hisi_acc_vf_debug_check(seq, vdev);
> +	if (ret)
> +		return 0;
> +
> +	mutex_lock(&hisi_acc_vdev->enable_mutex);
> +	ret = qm_wait_dev_not_ready(vf_qm);
> +	if (ret) {
> +		mutex_unlock(&hisi_acc_vdev->enable_mutex);
> +		seq_printf(seq, "%s\n", "VF device not ready!");
> +		return 0;
> +	}
> +
> +	value = readl(vf_qm->io_base + QM_MB_CMD_SEND_BASE);
> +	mutex_unlock(&hisi_acc_vdev->enable_mutex);
> +	seq_printf(seq, "%s:0x%llx\n", "mailbox cmd channel state is OK", value);
> +
> +	return 0;
> +}
> +
> +static int hisi_acc_vf_debug_save(struct seq_file *seq, void *data)
> +{
> +	struct device *vf_dev = seq->private;
> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
> +	struct vfio_device *vdev = &core_device->vdev;
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
> +	struct hisi_acc_vf_migration_file *migf = hisi_acc_vdev->debug_migf;
> +	int ret;
> +
> +	ret = hisi_acc_vf_debug_check(seq, vdev);
> +	if (ret)
> +		return 0;
> +
> +	mutex_lock(&hisi_acc_vdev->enable_mutex);
> +	ret = vf_qm_state_save(hisi_acc_vdev, migf);
> +	if (ret) {
> +		mutex_unlock(&hisi_acc_vdev->enable_mutex);
> +		seq_printf(seq, "%s\n", "failed to save device data!");
> +		return 0;
> +	}
> +	mutex_unlock(&hisi_acc_vdev->enable_mutex);
> +	seq_printf(seq, "%s\n", "successful to save device data!");
> +
> +	return 0;
> +}
> +
> +static int hisi_acc_vf_data_read(struct seq_file *seq, void *data)
> +{
> +	struct device *vf_dev = seq->private;
> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
> +	struct vfio_device *vdev = &core_device->vdev;
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
> +	struct hisi_acc_vf_migration_file *debug_migf = hisi_acc_vdev->debug_migf;
> +	size_t vf_data_sz = offsetofend(struct acc_vf_data, padding);
> +
> +	if (debug_migf && debug_migf->total_length)
> +		seq_hex_dump(seq, "Mig Data:", DUMP_PREFIX_OFFSET, 16, 1,
> +				(unsigned char *)&debug_migf->vf_data,
> +				vf_data_sz, false);
> +	else
> +		seq_printf(seq, "%s\n", "device not migrated!");
> +
> +	return 0;
> +}
> +
> +static int hisi_acc_vf_attr_read(struct seq_file *seq, void *data)
> +{
> +	struct device *vf_dev = seq->private;
> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
> +	struct vfio_device *vdev = &core_device->vdev;
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
> +	struct hisi_acc_vf_migration_file *debug_migf = hisi_acc_vdev->debug_migf;
> +
> +	if (debug_migf && debug_migf->total_length) {
> +		seq_printf(seq,
> +			 "acc device:\n"
> +			 "device  state: %d\n"
> +			 "device  ready: %u\n"
> +			 "data    valid: %d\n"
> +			 "data     size: %lu\n",
> +			 hisi_acc_vdev->mig_state,
> +			 hisi_acc_vdev->vf_qm_state,
> +			 debug_migf->disabled,
> +			 debug_migf->total_length);
> +	} else {
> +		seq_printf(seq, "%s\n", "device not migrated!");
> +	}
> +
> +	return 0;
> +}
> +
> +static int hisi_acc_vfio_debug_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
> +{
> +	struct vfio_device *vdev = &hisi_acc_vdev->core_device.vdev;
> +	struct dentry *vfio_dev_migration = NULL;
> +	struct dentry *vfio_hisi_acc = NULL;
> +	struct device *dev = vdev->dev;
> +	void *migf = NULL;
> +
> +	if (!debugfs_initialized())
> +		return 0;
> +
> +	migf = kzalloc(sizeof(struct hisi_acc_vf_migration_file), GFP_KERNEL);
> +	if (!migf)
> +		return -ENOMEM;
> +	hisi_acc_vdev->debug_migf = migf;
> +
> +	vfio_dev_migration = debugfs_lookup("migration", vdev->debug_root);
> +	if (!vfio_dev_migration) {
> +		kfree(migf);
> +		dev_err(dev, "failed to lookup migration debugfs file!\n");
> +		return -ENODEV;
> +	}
> +
> +	vfio_hisi_acc = debugfs_create_dir("hisi_acc", vfio_dev_migration);
> +	debugfs_create_devm_seqfile(dev, "data", vfio_hisi_acc,
> +				  hisi_acc_vf_data_read);
> +	debugfs_create_devm_seqfile(dev, "attr", vfio_hisi_acc,
> +				  hisi_acc_vf_attr_read);
> +	debugfs_create_devm_seqfile(dev, "cmd_state", vfio_hisi_acc,
> +				  hisi_acc_vf_debug_cmd);
> +	debugfs_create_devm_seqfile(dev, "save", vfio_hisi_acc,
> +				  hisi_acc_vf_debug_save);
> +
> +	return 0;
> +}
> +
> +static void hisi_acc_vf_debugfs_exit(struct hisi_acc_vf_core_device *hisi_acc_vdev)
> +{
> +	if (!debugfs_initialized())
> +		return;
> +
> +	kfree(hisi_acc_vdev->debug_migf);
> +}
> +
>  static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
>  {
>  	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(core_vdev);
> @@ -1353,7 +1537,9 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
>  	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(core_vdev);
>  	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
>  
> +	mutex_lock(&hisi_acc_vdev->enable_mutex);
>  	iounmap(vf_qm->io_base);
> +	mutex_unlock(&hisi_acc_vdev->enable_mutex);
>  	vfio_pci_core_close_device(core_vdev);
>  }
>  
> @@ -1444,6 +1630,9 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
>  	ret = vfio_pci_core_register_device(&hisi_acc_vdev->core_device);
>  	if (ret)
>  		goto out_put_vdev;
> +
> +	if (ops == &hisi_acc_vfio_pci_migrn_ops)
> +		hisi_acc_vfio_debug_init(hisi_acc_vdev);
>  	return 0;
>  
>  out_put_vdev:
> @@ -1456,6 +1645,7 @@ static void hisi_acc_vfio_pci_remove(struct pci_dev *pdev)
>  	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
>  
>  	vfio_pci_core_unregister_device(&hisi_acc_vdev->core_device);
> +	hisi_acc_vf_debugfs_exit(hisi_acc_vdev);
>  	vfio_put_device(&hisi_acc_vdev->core_device.vdev);
>  }
>  
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> index c58fc5861492..38327b97d535 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> @@ -116,5 +116,10 @@ struct hisi_acc_vf_core_device {
>  	spinlock_t reset_lock;
>  	struct hisi_acc_vf_migration_file *resuming_migf;
>  	struct hisi_acc_vf_migration_file *saving_migf;
> +
> +	/* To make sure the device is enabled */
> +	struct mutex enable_mutex;
> +	/* For debugfs */
> +	struct hisi_acc_vf_migration_file *debug_migf;
>  };
>  #endif /* HISI_ACC_VFIO_PCI_H */


