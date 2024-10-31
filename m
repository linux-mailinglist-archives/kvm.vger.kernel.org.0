Return-Path: <kvm+bounces-30260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AD979B85E1
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 23:04:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5AF781C23003
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 22:04:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5A361CEE8F;
	Thu, 31 Oct 2024 22:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XQRvEoEP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92701BF311
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 22:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730412285; cv=none; b=EUg9hJKX89v/bHymo6b6zFEGhX9X+6/XBoUQHA7J3GO3S54HIXGdb+rLd/e0q3AKWXINVW15NyK95C1oERu52oMxRHhWQeNJE6yFTWJowwToBHTumxqfIFLjAwBAxohusdeIfPqbK2a+Lrmm2q5y269xE7Hff0LZD/Dbeb08I0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730412285; c=relaxed/simple;
	bh=95TLSC2NULDFPCcmvtR1QvQEJT+Jdz88PfjckImFeq4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bEUxPtdapwKLHN6Ww51hUJFIwi7FopgkUHQkCxXxdumwkrrQmF9yNnDRBphE6qUsI86vd8RaH3qqLNnBUS/ThyEao+DDIl6ogPdQIqG16iN45vegJzhXN5VNRnkbiCBISA+n1Y48jSmkCU1T7GUnzeRfRrZKtXO9f6kmjzpi3Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XQRvEoEP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730412275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fUr5NcQnN0e68bzOiy3518BoI5deAKd2mJQBfeQ23HU=;
	b=XQRvEoEPIV2zzmEa2EznbLv7rgPqK4Gb2sMQEQgZRDKqFmpBnCOtHqIhopR07Ek+NzKzrY
	wMAL6hHwcla4E4fvcRmkKghDLdypoI6ox0KeE/Oup/GVTQLU2xvBZWBPqM2iuAM6gOcLtE
	6wwG0fziNBZBHnPKp5qkWBcKrZzanr4=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-692-TCbMmGBEOLWRuiVkBuibCQ-1; Thu, 31 Oct 2024 18:04:34 -0400
X-MC-Unique: TCbMmGBEOLWRuiVkBuibCQ-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a4dad0a63bso1105785ab.0
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 15:04:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730412274; x=1731017074;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fUr5NcQnN0e68bzOiy3518BoI5deAKd2mJQBfeQ23HU=;
        b=UgPZZ5y3y2lHtJgBqFikPWFmLJ57WCnkrUpm/5YWolxqypNVi5zXBzrFZZpWFF5psj
         g1pI+IPavDGD+lybeVwRmYnXMfNr2NahxqSuULITM1T9n3wpCjxPjOdplduMPsHovmTY
         3AGeDoKwMVAIIc2HDdwSt74Mz1t1x8Rert8eVIgg5k8tST1b1LmPvircOzUFqBMqqSPN
         AbBcm9Odyv6XWlZUKZMCMPk5IZ+LIzy5REF0eV5sizKNxb08peMQxqAfW46J7Va+TonH
         gTpkzh4w+tFuO2MWi6zsVcNaOAqtTAuQbO8Nj4ad1jmQ0wVnMEzQqPp7O7gbK6bedsCt
         f/lA==
X-Forwarded-Encrypted: i=1; AJvYcCXXqckKWecb1w7KFPvJuGg/0ooyS7w2F3f5F4KBmkZA0B/8/ty/SAo0yKnCH9FhOz1JgSc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZc9QeL1eAPaYZhBmz0eWCjL1/y8IpTVApUJBryXz66iQtXFWd
	wVd4bNIJUWnoPj1ivhks/t4HcOcFsG5feg6+lwGT9RvHtYquAw70rLelNa+BdMlJM0ThMbunEqE
	kPFVu7O93Hs64u9xt4NB7kGJENG/MCDI2QVeF63n/kbSPzEqSoA==
X-Received: by 2002:a6b:6b0e:0:b0:83a:9350:68b with SMTP id ca18e2360f4ac-83b1bcfc472mr511200739f.0.1730412273686;
        Thu, 31 Oct 2024 15:04:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHr4KIy8TEe6KKUGjWt076/fcZDFhEUYmcZrvP7ttrn576x3wiVOfQGdasUHAGVFQHdA9U90A==
X-Received: by 2002:a6b:6b0e:0:b0:83a:9350:68b with SMTP id ca18e2360f4ac-83b1bcfc472mr511200139f.0.1730412273117;
        Thu, 31 Oct 2024 15:04:33 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4de049a4767sm461330173.138.2024.10.31.15.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2024 15:04:32 -0700 (PDT)
Date: Thu, 31 Oct 2024 16:04:30 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Longfang Liu <liulongfang@huawei.com>
Cc: <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
 <jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: Re: [PATCH v11 3/4] hisi_acc_vfio_pci: register debugfs for
 hisilicon migration driver
Message-ID: <20241031160430.59f4b944.alex.williamson@redhat.com>
In-Reply-To: <20241025090143.64472-4-liulongfang@huawei.com>
References: <20241025090143.64472-1-liulongfang@huawei.com>
	<20241025090143.64472-4-liulongfang@huawei.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 25 Oct 2024 17:01:42 +0800
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
>         |                 |  saving_migf |       | resuming_migf |
>   read  |                 |     file     |       |     file      |
>         |                 +------+-------+       +-------+-------+
>         |                        |          copy         |
>         |                        +------------+----------+
>         |                                     |
> +-------v--------+                    +-------v--------+
> |   data buffer  |                    |   debug_migf   |
> +-------+--------+                    +-------+--------+
>         |                                     |
>    cat  |                                 cat |
> +-------v--------+                    +-------v--------+
> |   dev_data     |                    |   migf_data    |
> +----------------+                    +----------------+
> 
> When accessing debugfs, user can obtain the most recent status data
> of the device through the "dev_data" file. It can read recent
> complete status data of the device. If the current device is being
> migrated, it will wait for it to complete.
> The data for the last completed migration function will be stored
> in debug_migf. Users can read it via "migf_data".
> 
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 204 ++++++++++++++++++
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |   7 +
>  2 files changed, 211 insertions(+)
> 
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index a8c53952d82e..0577d4ddfb34 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -627,15 +627,30 @@ static void hisi_acc_vf_disable_fd(struct hisi_acc_vf_migration_file *migf)
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
> +	dst_migf->total_length = src_migf->total_length;
> +	memcpy(&dst_migf->vf_data, &src_migf->vf_data,
> +		sizeof(struct acc_vf_data));
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
> @@ -1294,6 +1309,140 @@ static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int
>  	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
>  }
>  
> +static int hisi_acc_vf_debug_check(struct seq_file *seq, struct vfio_device *vdev)
> +{
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
> +	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
> +	int ret;
> +
> +	lockdep_assert_held(&hisi_acc_vdev->open_mutex);
> +	/*
> +	 * When the device is not opened, the io_base is not mapped.
> +	 * The driver cannot perform device read and write operations.
> +	 */
> +	if (!hisi_acc_vdev->dev_opened) {
> +		seq_printf(seq, "device not opened!\n");
> +		return -EINVAL;
> +	}
> +
> +	ret = qm_wait_dev_not_ready(vf_qm);
> +	if (ret) {
> +		seq_printf(seq, "VF device not ready!\n");
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
> +	mutex_lock(&hisi_acc_vdev->open_mutex);
> +	ret = hisi_acc_vf_debug_check(seq, vdev);
> +	if (ret) {
> +		mutex_unlock(&hisi_acc_vdev->open_mutex);
> +		return ret;
> +	}
> +
> +	value = readl(vf_qm->io_base + QM_MB_CMD_SEND_BASE);
> +	if (value == QM_MB_CMD_NOT_READY) {
> +		mutex_unlock(&hisi_acc_vdev->open_mutex);
> +		seq_printf(seq, "mailbox cmd channel not ready!\n");
> +		return -EINVAL;
> +	}
> +	mutex_unlock(&hisi_acc_vdev->open_mutex);
> +	seq_printf(seq, "mailbox cmd channel ready!\n");
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
> +	struct acc_vf_data *vf_data = NULL;

Nit, this initialization is unnecessary.

> +	int ret;
> +
> +	mutex_lock(&hisi_acc_vdev->open_mutex);
> +	ret = hisi_acc_vf_debug_check(seq, vdev);
> +	if (ret) {
> +		mutex_unlock(&hisi_acc_vdev->open_mutex);
> +		return ret;
> +	}
> +
> +	mutex_lock(&hisi_acc_vdev->state_mutex);
> +	vf_data = kzalloc(sizeof(struct acc_vf_data), GFP_KERNEL);
> +	if (!vf_data) {
> +		ret = -ENOMEM;
> +		goto mutex_release;
> +	}
> +
> +	vf_data->vf_qm_state = hisi_acc_vdev->vf_qm_state;
> +	ret = vf_qm_read_data(&hisi_acc_vdev->vf_qm, vf_data);
> +	if (ret)
> +		goto migf_err;
> +
> +	seq_hex_dump(seq, "Dev Data:", DUMP_PREFIX_OFFSET, 16, 1,
> +			(unsigned char *)vf_data,

Casting to (const void *) would match the prototype.  This line should
also wrap to just inside the opening parenthesis of the previous line, 2
tabs, 5 spaces.

> +			vf_data_sz, false);
> +
> +	seq_printf(seq,
> +		 "acc device:\n"
> +		 "guest driver load: %u\n"
> +		 "data size: %lu\n",
> +		 hisi_acc_vdev->vf_qm_state,
> +		 sizeof(struct acc_vf_data));

Same here and throughout, wrap aligned to the relevant parenthesis.

I know you've described vf_qm_state as indicating whether or not the
guest driver is loaded, but I still can't figure out how to discern
that from the code.  It's largely only set based on the return value of
qm_wait_dev_not_ready(), which tests QM_VF_STATE, and describes the
function as testing if the device is ready.  Improved comments would
help future reviews.

What's the purpose of the "acc device:" prefix?

> +
> +migf_err:
> +	kfree(vf_data);
> +mutex_release:
> +	mutex_unlock(&hisi_acc_vdev->open_mutex);
> +	mutex_unlock(&hisi_acc_vdev->state_mutex);

Locks should be released in the reverse order they were acquired.

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
> +	if (debug_migf->total_length < QM_MATCH_SIZE) {
> +		seq_printf(seq, "device not migrated!\n");
> +		return -EAGAIN;
> +	}
> +
> +	seq_hex_dump(seq, "Mig Data:", DUMP_PREFIX_OFFSET, 16, 1,
> +			(unsigned char *)&debug_migf->vf_data,
> +			vf_data_sz, false);
> +
> +	seq_printf(seq,
> +		 "acc device:\n"
> +		 "guest driver load: %u\n"
> +		 "device opened: %d\n"
> +		 "migrate data length: %lu\n",
> +		 hisi_acc_vdev->vf_qm_state,
> +		 hisi_acc_vdev->dev_opened,
> +		 debug_migf->total_length);

This debugfs entry is described as returning the data from the last
migration, but vf_qm_state and dev_opened are relative to the current
device/guest driver state.  Both seem to have no relevance to the data
in debug_migf.

> +
> +	return 0;
> +}
> +
>  static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
>  {
>  	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(core_vdev);
> @@ -1305,12 +1454,16 @@ static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
>  		return ret;
>  
>  	if (core_vdev->mig_ops) {
> +		mutex_lock(&hisi_acc_vdev->open_mutex);
>  		ret = hisi_acc_vf_qm_init(hisi_acc_vdev);
>  		if (ret) {
> +			mutex_unlock(&hisi_acc_vdev->open_mutex);
>  			vfio_pci_core_disable(vdev);
>  			return ret;
>  		}
>  		hisi_acc_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
> +		hisi_acc_vdev->dev_opened = true;
> +		mutex_unlock(&hisi_acc_vdev->open_mutex);
>  	}
>  
>  	vfio_pci_core_finish_enable(vdev);
> @@ -1322,7 +1475,10 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
>  	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(core_vdev);
>  	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
>  
> +	mutex_lock(&hisi_acc_vdev->open_mutex);
> +	hisi_acc_vdev->dev_opened = false;
>  	iounmap(vf_qm->io_base);
> +	mutex_unlock(&hisi_acc_vdev->open_mutex);
>  	vfio_pci_core_close_device(core_vdev);
>  }
>  
> @@ -1342,6 +1498,7 @@ static int hisi_acc_vfio_pci_migrn_init_dev(struct vfio_device *core_vdev)
>  	hisi_acc_vdev->pf_qm = pf_qm;
>  	hisi_acc_vdev->vf_dev = pdev;
>  	mutex_init(&hisi_acc_vdev->state_mutex);
> +	mutex_init(&hisi_acc_vdev->open_mutex);
>  
>  	core_vdev->migration_flags = VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_PRE_COPY;
>  	core_vdev->mig_ops = &hisi_acc_vfio_pci_migrn_state_ops;
> @@ -1387,6 +1544,50 @@ static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
>  	.detach_ioas = vfio_iommufd_physical_detach_ioas,
>  };
>  
> +static void hisi_acc_vfio_debug_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
> +{
> +	struct vfio_device *vdev = &hisi_acc_vdev->core_device.vdev;
> +	struct dentry *vfio_dev_migration = NULL;
> +	struct dentry *vfio_hisi_acc = NULL;
> +	struct device *dev = vdev->dev;
> +	void *migf = NULL;
> +
> +	if (!debugfs_initialized() ||
> +	    !IS_ENABLED(CONFIG_VFIO_DEBUGFS))
> +		return;
> +
> +	if (vdev->ops != &hisi_acc_vfio_pci_migrn_ops)
> +		return;
> +
> +	vfio_dev_migration = debugfs_lookup("migration", vdev->debug_root);
> +	if (!vfio_dev_migration) {
> +		dev_err(dev, "failed to lookup migration debugfs file!\n");
> +		return;
> +	}
> +
> +	migf = kzalloc(sizeof(struct hisi_acc_vf_migration_file), GFP_KERNEL);
> +	if (!migf)
> +		return;
> +	hisi_acc_vdev->debug_migf = migf;
> +
> +	vfio_hisi_acc = debugfs_create_dir("hisi_acc", vfio_dev_migration);
> +	debugfs_create_devm_seqfile(dev, "dev_data", vfio_hisi_acc,
> +				  hisi_acc_vf_dev_read);
> +	debugfs_create_devm_seqfile(dev, "migf_data", vfio_hisi_acc,
> +				  hisi_acc_vf_migf_read);
> +	debugfs_create_devm_seqfile(dev, "cmd_state", vfio_hisi_acc,
> +				  hisi_acc_vf_debug_cmd);
> +}
> +
> +static void hisi_acc_vf_debugfs_exit(struct hisi_acc_vf_core_device *hisi_acc_vdev)
> +{
> +	/* If migrn_ops is not used, debug_migf is NULL */
> +	if (hisi_acc_vdev->debug_migf) {

This test is unnecessary, kfree(NULL) is valid.

> +		kfree(hisi_acc_vdev->debug_migf);
> +		hisi_acc_vdev->debug_migf = NULL;
> +	}
> +}
> +
>  static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  {
>  	struct hisi_acc_vf_core_device *hisi_acc_vdev;
> @@ -1413,6 +1614,8 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
>  	ret = vfio_pci_core_register_device(&hisi_acc_vdev->core_device);
>  	if (ret)
>  		goto out_put_vdev;
> +
> +	hisi_acc_vfio_debug_init(hisi_acc_vdev);
>  	return 0;
>  
>  out_put_vdev:
> @@ -1425,6 +1628,7 @@ static void hisi_acc_vfio_pci_remove(struct pci_dev *pdev)
>  	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
>  
>  	vfio_pci_core_unregister_device(&hisi_acc_vdev->core_device);
> +	hisi_acc_vf_debugfs_exit(hisi_acc_vdev);
>  	vfio_put_device(&hisi_acc_vdev->core_device.vdev);
>  }
>  
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> index 5bab46602fad..2a78ffd060c3 100644
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
> @@ -99,6 +100,8 @@ struct hisi_acc_vf_migration_file {
>  struct hisi_acc_vf_core_device {
>  	struct vfio_pci_core_device core_device;
>  	u8 match_done;
> +	/* To make sure the device is opened */

We can infer that from the field name, it would be more useful to
comment that io_base is only valid when dev_opened, which is protected
by open_mutex.

> +	bool dev_opened;

Seems like open_mutex would fit just as well here and have better
proximity to the data it protects.

>  
>  	/* For migration state */
>  	struct mutex state_mutex;
> @@ -111,5 +114,9 @@ struct hisi_acc_vf_core_device {
>  	int vf_id;
>  	struct hisi_acc_vf_migration_file *resuming_migf;
>  	struct hisi_acc_vf_migration_file *saving_migf;
> +
> +	/* To save migration data */

Clearly.  Describing it as an extra buffer for reporting migration data
through debugfs might be more useful.  Thanks,

Alex

> +	struct hisi_acc_vf_migration_file *debug_migf;
> +	struct mutex open_mutex;
>  };
>  #endif /* HISI_ACC_VFIO_PCI_H */


