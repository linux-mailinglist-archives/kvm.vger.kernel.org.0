Return-Path: <kvm+bounces-16527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 284B08BB1C2
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 19:23:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 96CDA1F2506E
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 17:23:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3747B158213;
	Fri,  3 May 2024 17:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eIqVOkTT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22377157E9E
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 17:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714756890; cv=none; b=TQxPwC3c9TCLoMNQnz7AnM+K9lM0JSWJ/isUq81Y5tE6H8VSJpdw7jKPO2Mdl7CtAHgweDKGJM8U6EQGjyOP9bOUVI44LZAgCg53CWbu3OSzDniX4AN8RXpwvspBRE4TN+046yYULIcgsYYQANU1MB6SfnGK+XMMAZ37widPPj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714756890; c=relaxed/simple;
	bh=YmgCTy98MWBMo45+ZA0QcBZPnzevO17EjRl+kiTMpek=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dsF9TeAYcxVDy6E9SfLuNtCFTbaY0Ud+O8ujsm9VYfYjJgWS1HWdWw3SjPApcVvWUI5Cx8L0WXSJ/4MnPz6+vU6LFLPAZi4L7vlpbvwu5MUtOR4eUEDM+TJi6R6XPcPsXcfRd3RpmAxsiVLyPPeDnTgl+E+Dxy5K6VP5JoHqYpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eIqVOkTT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714756886;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V3OrTUI28CNlZu9KmOJDYU9bB/HyQeSnOjtAeaHpXL4=;
	b=eIqVOkTTDzecR7HuDpuB+uzJQj0qaedJSk021aC0FQcT3RYzUpJIAA42wMF/4Dh0dX/AvN
	UEnpc2H8f3sdclnyu0wldGNsAdZ2laFmXHbbScfjShjSyFMSg0kxROSv4Z1pFFTAR8847h
	vkBtSlJWewur7zYswun1kDz6t6wM298=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-bdeVS98RNSeNzy0zLx8LDA-1; Fri, 03 May 2024 13:21:24 -0400
X-MC-Unique: bdeVS98RNSeNzy0zLx8LDA-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7dea5889eb7so817872039f.1
        for <kvm@vger.kernel.org>; Fri, 03 May 2024 10:21:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714756884; x=1715361684;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V3OrTUI28CNlZu9KmOJDYU9bB/HyQeSnOjtAeaHpXL4=;
        b=B0Ihpe7oY3TdUkKB4mYnGpNeTDKdFBQbza2Pr6ZQtPrdc2N73kT791BuHnEjn2dp1N
         2vBzv6f+1ZVyx+lHcBoN4Z4JQFdAq6leW6BxHJPgPWOCzB3zzz142DiIZryRTRxunDYJ
         PYPhBrDFAhLs8PLhQfMqGpKIuErwM8x9JqiD1Ro5PlHU85snVnNEytyROLh5MahKXHhz
         hJTr2gpCoRgMfk+18KAjLI54TsXGrMF1cNOh2YqEYmUtog+iJK2pfFVBhfJTM/yYVN0Q
         mY7RSUN+bPDBx0fZx95m5JQytUGZhAu606KFRRcCgyCwVZR5WOe/6GoP5JFmkz6t8rIb
         JBDg==
X-Forwarded-Encrypted: i=1; AJvYcCXVinOtP7kvm4uMCFadJ3Zl/38EKJKlLro5A7NaVJqlXQnc+MyhiwVSURPP4QeFtM0sYPX1rOTBH8735ykL+O7C2/LT
X-Gm-Message-State: AOJu0YwMWoCFPivDFA39hAIJ/TxXe7lA3/1B3ZJSJoQ3EFnQ1MYXQnEB
	w9+NGBj0kvKDAMvSNe0HhsqAjJDV7YW9NureyUAes2eARpiCW5EoKsnxFvMcMWpDx6YsR9YyFCJ
	qrh7UfVE74WJw2RKRoCzJmBxNNoOp9gmD9DDi7oxBh8i7vSN3SQ==
X-Received: by 2002:a05:6602:2dc9:b0:7de:e432:fd27 with SMTP id l9-20020a0566022dc900b007dee432fd27mr3677490iow.13.1714756883570;
        Fri, 03 May 2024 10:21:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEP/UZceemS/fN2WelOAfDGSUMcohqqI2Ml/K1fYPNm7ZKXcwIbkXx2ddOsJtIq5yed0tR6Aw==
X-Received: by 2002:a05:6602:2dc9:b0:7de:e432:fd27 with SMTP id l9-20020a0566022dc900b007dee432fd27mr3677447iow.13.1714756883060;
        Fri, 03 May 2024 10:21:23 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id z2-20020a056638318200b0048764f010c0sm896839jak.46.2024.05.03.10.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 May 2024 10:21:22 -0700 (PDT)
Date: Fri, 3 May 2024 11:21:20 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Longfang Liu <liulongfang@huawei.com>
Cc: <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
 <jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: Re: [PATCH v6 4/5] hisi_acc_vfio_pci: register debugfs for
 hisilicon migration driver
Message-ID: <20240503112120.3740da24.alex.williamson@redhat.com>
In-Reply-To: <20240425132322.12041-5-liulongfang@huawei.com>
References: <20240425132322.12041-1-liulongfang@huawei.com>
	<20240425132322.12041-5-liulongfang@huawei.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 25 Apr 2024 21:23:21 +0800
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
>     |            +--dev_data
>     |            +--migf_data
>     |            +--cmd_state
>     |
>     +---<dev_name2>
>          +---migration
>              +--state
>              +--hisi_acc
>                  +--dev_data
>                  +--migf_data
>                  +--cmd_state
> 
> dev_data file: read device data that needs to be migrated from the
> current device in real time
> migf_data file: read the migration data of the last live migration
> from the current driver.
> cmd_state: used to get the cmd channel state for the device.
> 
> +----------------+        +--------------+       +---------------+
> | migration dev  |        |   src  dev   |       |   dst  dev    |
> +-------+--------+        +------+-------+       +-------+-------+
>         |                        |                       |
>         |                 +------v-------+       +-------v-------+
>         |                 |  saving_mif  |       | resuming_migf |
>   read  |                 |     file     |       |     file      |
>         |                 +------+-------+       +-------+-------+
>         |                        |          copy         |
>         |                        +------------+----------+
>         |                                     |
> +-------v---------+                   +-------v--------+
> |   data buffer   |                   |   debug_migf   |
> +-------+---------+                   +-------+--------+
>         |                                     |
>    cat  |                                 cat |
> +-------v--------+                    +-------v--------+
> |   dev_data     |                    |   migf_data    |
> +----------------+                    +----------------+
> 
> When accessing debugfs, user can obtain the real-time status data
> of the device through the "dev_data" file. It will directly read
> the device status data and will not affect the live migration
> function. Its data is stored in the allocated memory buffer,
> and the memory is released after data returning to user mode.
> 
> To obtain the data of the last complete migration, user need to
> obtain it through the "migf_data" file. Since the live migration
> data only exists during the migration process, it is destroyed
> after the migration is completed.
> In order to save this data, a debug_migf file is created in the
> driver. At the end of the live migration process, copy the data
> to debug_migf.
> 
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 225 ++++++++++++++++++
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |   7 +
>  2 files changed, 232 insertions(+)
> 
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index bf358ba94b5d..656b3d975940 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -627,15 +627,33 @@ static void hisi_acc_vf_disable_fd(struct hisi_acc_vf_migration_file *migf)
>  	mutex_unlock(&migf->lock);
>  }
>  
> +static void hisi_acc_debug_migf_copy(struct hisi_acc_vf_core_device *hisi_acc_vdev,
> +	struct hisi_acc_vf_migration_file *src_migf)
> +{
> +	struct hisi_acc_vf_migration_file *dst_migf = hisi_acc_vdev->debug_migf;
> +
> +	if (!dst_migf)
> +		return;
> +
> +	mutex_lock(&hisi_acc_vdev->enable_mutex);
> +	dst_migf->disabled = src_migf->disabled;
> +	dst_migf->total_length = src_migf->total_length;
> +	memcpy(&dst_migf->vf_data, &src_migf->vf_data,
> +		sizeof(struct acc_vf_data));
> +	mutex_unlock(&hisi_acc_vdev->enable_mutex);
> +}
> +
>  static void hisi_acc_vf_disable_fds(struct hisi_acc_vf_core_device *hisi_acc_vdev)
>  {
>  	if (hisi_acc_vdev->resuming_migf) {
> +		hisi_acc_debug_migf_copy(hisi_acc_vdev, hisi_acc_vdev->resuming_migf);
>  		hisi_acc_vf_disable_fd(hisi_acc_vdev->resuming_migf);
>  		fput(hisi_acc_vdev->resuming_migf->filp);
>  		hisi_acc_vdev->resuming_migf = NULL;
>  	}
>  
>  	if (hisi_acc_vdev->saving_migf) {
> +		hisi_acc_debug_migf_copy(hisi_acc_vdev, hisi_acc_vdev->saving_migf);
>  		hisi_acc_vf_disable_fd(hisi_acc_vdev->saving_migf);
>  		fput(hisi_acc_vdev->saving_migf->filp);
>  		hisi_acc_vdev->saving_migf = NULL;
> @@ -1144,6 +1162,7 @@ static int hisi_acc_vf_qm_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
>  	if (!vf_qm->io_base)
>  		return -EIO;
>  
> +	mutex_init(&hisi_acc_vdev->enable_mutex);
>  	vf_qm->fun_type = QM_HW_VF;
>  	vf_qm->pdev = vf_dev;
>  	mutex_init(&vf_qm->mailbox_lock);
> @@ -1294,6 +1313,203 @@ static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int
>  	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
>  }
>  
> +static int hisi_acc_vf_debug_check(struct seq_file *seq, struct vfio_device *vdev)
> +{
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
> +	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
> +	struct device *dev = vdev->dev;
> +	int ret;
> +
> +	if (!vdev->mig_ops) {
> +		dev_err(dev, "device does not support live migration!\n");

Sorry, every error path should not spam dmesg with dev_err().  I'm
going to wait until your co-maintainer approves this before looking at
any further iterations of this series.  Thanks,

Alex

> +		return -EINVAL;
> +	}
> +
> +	/**
> +	 * When the device is not opened, the io_base is not mapped.
> +	 * The driver cannot perform device read and write operations.
> +	 */
> +	if (!hisi_acc_vdev->dev_opened) {
> +		dev_err(dev, "device not opened!\n");
> +		return -EINVAL;
> +	}
> +
> +	ret = qm_wait_dev_not_ready(vf_qm);
> +	if (ret) {
> +		dev_err(dev, "VF device not ready!\n");
> +		return -EBUSY;
> +	}
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
> +	mutex_lock(&hisi_acc_vdev->enable_mutex);
> +	ret = hisi_acc_vf_debug_check(seq, vdev);
> +	if (ret) {
> +		mutex_unlock(&hisi_acc_vdev->enable_mutex);
> +		return ret;
> +	}
> +
> +	value = readl(vf_qm->io_base + QM_MB_CMD_SEND_BASE);
> +	if (value == QM_MB_CMD_NOT_READY) {
> +		mutex_unlock(&hisi_acc_vdev->enable_mutex);
> +		dev_err(vf_dev, "mailbox cmd channel not ready!\n");
> +		return -EINVAL;
> +	}
> +	mutex_unlock(&hisi_acc_vdev->enable_mutex);
> +	dev_err(vf_dev, "mailbox cmd channel state is OK!\n");
> +
> +	return 0;
> +}
> +
> +static int hisi_acc_vf_dev_read(struct seq_file *seq, void *data)
> +{
> +	struct device *vf_dev = seq->private;
> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
> +	struct vfio_device *vdev = &core_device->vdev;
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
> +	size_t vf_data_sz = offsetofend(struct acc_vf_data, padding);
> +	struct hisi_acc_vf_migration_file *migf = NULL;
> +	int ret;
> +
> +	migf = kzalloc(sizeof(struct hisi_acc_vf_migration_file), GFP_KERNEL);
> +	if (!migf)
> +		return -ENOMEM;
> +
> +	mutex_lock(&hisi_acc_vdev->enable_mutex);
> +	ret = hisi_acc_vf_debug_check(seq, vdev);
> +	if (ret) {
> +		mutex_unlock(&hisi_acc_vdev->enable_mutex);
> +		goto migf_err;
> +	}
> +
> +	migf->vf_data.vf_qm_state = hisi_acc_vdev->vf_qm_state;
> +	ret = vf_qm_read_data(&hisi_acc_vdev->vf_qm, &migf->vf_data);
> +	if (ret) {
> +		mutex_unlock(&hisi_acc_vdev->enable_mutex);
> +		dev_err(vf_dev, "failed to read device data!\n");
> +		goto migf_err;
> +	}
> +	mutex_unlock(&hisi_acc_vdev->enable_mutex);
> +
> +	if (hisi_acc_vdev->resuming_migf)
> +		migf->disabled = hisi_acc_vdev->resuming_migf->disabled;
> +	else if (hisi_acc_vdev->saving_migf)
> +		migf->disabled = hisi_acc_vdev->saving_migf->disabled;
> +	else
> +		migf->disabled = true;
> +	migf->total_length = sizeof(struct acc_vf_data);
> +
> +	seq_hex_dump(seq, "Dev Data:", DUMP_PREFIX_OFFSET, 16, 1,
> +			(unsigned char *)&migf->vf_data,
> +			vf_data_sz, false);
> +
> +	seq_printf(seq,
> +		 "acc device:\n"
> +		 "device  ready: %u\n"
> +		 "device  opened: %d\n"
> +		 "data    valid: %d\n"
> +		 "data     size: %lu\n",
> +		 hisi_acc_vdev->vf_qm_state,
> +		 hisi_acc_vdev->dev_opened,
> +		 migf->disabled,
> +		 migf->total_length);
> +
> +migf_err:
> +	kfree(migf);
> +
> +	return ret;
> +}
> +
> +static int hisi_acc_vf_migf_read(struct seq_file *seq, void *data)
> +{
> +	struct device *vf_dev = seq->private;
> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
> +	struct vfio_device *vdev = &core_device->vdev;
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
> +	size_t vf_data_sz = offsetofend(struct acc_vf_data, padding);
> +	struct hisi_acc_vf_migration_file *debug_migf = hisi_acc_vdev->debug_migf;
> +
> +	/* Check whether the live migration operation has been performed */
> +	if (debug_migf->total_length < vf_data_sz) {
> +		dev_err(vf_dev, "device not migrated!\n");
> +		return -EAGAIN;
> +	}
> +
> +	seq_hex_dump(seq, "Mig Data:", DUMP_PREFIX_OFFSET, 16, 1,
> +			(unsigned char *)&debug_migf->vf_data,
> +			vf_data_sz, false);
> +
> +	seq_printf(seq,
> +		 "acc device:\n"
> +		 "device  ready: %u\n"
> +		 "device  opened: %d\n"
> +		 "data    valid: %d\n"
> +		 "data     size: %lu\n",
> +		 hisi_acc_vdev->vf_qm_state,
> +		 hisi_acc_vdev->dev_opened,
> +		 debug_migf->disabled,
> +		 debug_migf->total_length);
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
> +	if (!debugfs_initialized() ||
> +	    !IS_ENABLED(CONFIG_VFIO_DEBUGFS))
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
> +		hisi_acc_vdev->debug_migf = NULL;
> +		dev_err(dev, "failed to lookup migration debugfs file!\n");
> +		return -ENODEV;
> +	}
> +
> +	vfio_hisi_acc = debugfs_create_dir("hisi_acc", vfio_dev_migration);
> +	debugfs_create_devm_seqfile(dev, "dev_data", vfio_hisi_acc,
> +				  hisi_acc_vf_dev_read);
> +	debugfs_create_devm_seqfile(dev, "migf_data", vfio_hisi_acc,
> +				  hisi_acc_vf_migf_read);
> +	debugfs_create_devm_seqfile(dev, "cmd_state", vfio_hisi_acc,
> +				  hisi_acc_vf_debug_cmd);
> +
> +	return 0;
> +}
> +
> +static void hisi_acc_vf_debugfs_exit(struct hisi_acc_vf_core_device *hisi_acc_vdev)
> +{
> +	if (!debugfs_initialized() ||
> +	    !IS_ENABLED(CONFIG_VFIO_DEBUGFS))
> +		return;
> +
> +	if (hisi_acc_vdev->debug_migf)
> +		kfree(hisi_acc_vdev->debug_migf);
> +}
> +
>  static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
>  {
>  	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(core_vdev);
> @@ -1311,9 +1527,11 @@ static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
>  			return ret;
>  		}
>  		hisi_acc_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
> +		hisi_acc_vdev->dev_opened = true;
>  	}
>  
>  	vfio_pci_core_finish_enable(vdev);
> +
>  	return 0;
>  }
>  
> @@ -1322,7 +1540,10 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
>  	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(core_vdev);
>  	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
>  
> +	hisi_acc_vdev->dev_opened = false;
> +	mutex_lock(&hisi_acc_vdev->enable_mutex);
>  	iounmap(vf_qm->io_base);
> +	mutex_unlock(&hisi_acc_vdev->enable_mutex);
>  	vfio_pci_core_close_device(core_vdev);
>  }
>  
> @@ -1413,6 +1634,9 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
>  	ret = vfio_pci_core_register_device(&hisi_acc_vdev->core_device);
>  	if (ret)
>  		goto out_put_vdev;
> +
> +	if (ops == &hisi_acc_vfio_pci_migrn_ops)
> +		hisi_acc_vfio_debug_init(hisi_acc_vdev);
>  	return 0;
>  
>  out_put_vdev:
> @@ -1425,6 +1649,7 @@ static void hisi_acc_vfio_pci_remove(struct pci_dev *pdev)
>  	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
>  
>  	vfio_pci_core_unregister_device(&hisi_acc_vdev->core_device);
> +	hisi_acc_vf_debugfs_exit(hisi_acc_vdev);
>  	vfio_put_device(&hisi_acc_vdev->core_device.vdev);
>  }
>  
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> index f887ab98581c..93ee8bef32a1 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> @@ -32,6 +32,7 @@
>  #define QM_SQC_VFT_BASE_MASK_V2		GENMASK(15, 0)
>  #define QM_SQC_VFT_NUM_SHIFT_V2		45
>  #define QM_SQC_VFT_NUM_MASK_V2		GENMASK(9, 0)
> +#define QM_MB_CMD_NOT_READY	0xffffffff
>  
>  /* RW regs */
>  #define QM_REGS_MAX_LEN		7
> @@ -114,5 +115,11 @@ struct hisi_acc_vf_core_device {
>  	int vf_id;
>  	struct hisi_acc_vf_migration_file *resuming_migf;
>  	struct hisi_acc_vf_migration_file *saving_migf;
> +
> +	/* To make sure the device is enabled */
> +	struct mutex enable_mutex;
> +	bool dev_opened;
> +	/* To save migration data */
> +	struct hisi_acc_vf_migration_file *debug_migf;
>  };
>  #endif /* HISI_ACC_VFIO_PCI_H */


