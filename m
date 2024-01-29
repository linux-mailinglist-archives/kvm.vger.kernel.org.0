Return-Path: <kvm+bounces-7301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 07F3883FC4B
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 03:37:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74CDB281AD3
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 02:37:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C952EEED7;
	Mon, 29 Jan 2024 02:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JSoQCUew"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876CCEEDA
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 02:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706495852; cv=none; b=I5VVBvN622JMVc7K4h2ak0n01drHnNCAUfh3Uf9VpBwVg4B/68bXVLPN037qzfzDI/ZKl3dhH33mt6Wl7g4K5UHHzJLuDMIqoN+tobHjCOR0aAsHSRaoBWctawrxQqQGDDcJG8rQooOTqCLqPCC+EKUdgXoYYgNGwvWm3VQ0lpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706495852; c=relaxed/simple;
	bh=CAWwSzCuBzJdr058/ylm6lEd55rfXQHXxKM1iD0BTXs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fFeP/YRWIUBHbiil//Ct7AiDN0/0QTVZ8csOm11DX2S2LuoTDuNQbyWlvamDD9uT2UUgasmL+iLfGqZUCbWIXyhaUUjq59PIwuuk1eGOomy6bElR5HdIATZq3R7Nj0XxtMqJlBrZHO6Ip0YXb6Y14pBCg+n5G61GS6jEu1uWsxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JSoQCUew; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706495848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wGgk+9hWDFF+qHIPCRgy4HE2ZOQkr1JKpCtykkITOz0=;
	b=JSoQCUewLO70jBzjI2MVU5RAue/P0c92+RzEXm8p964ipGeBkGV3z372wlifUDWyO79dys
	uKlWPs4l9cYMk8cOe4H/JGpwomkwHkrwBXQTH5e6F/FBFBplx/CjOi/XkQc6bn2lEsPhBo
	/n2425oOmAoHcF3rq6pAB47nJpD6a8A=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-519-J0EYZS9OOzCdkrHQAAlSRA-1; Sun, 28 Jan 2024 21:37:26 -0500
X-MC-Unique: J0EYZS9OOzCdkrHQAAlSRA-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-35fc6976630so13520075ab.0
        for <kvm@vger.kernel.org>; Sun, 28 Jan 2024 18:37:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706495845; x=1707100645;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wGgk+9hWDFF+qHIPCRgy4HE2ZOQkr1JKpCtykkITOz0=;
        b=p/kwv/uDFqlc5jofaXqFq66Gd2Re6gN8mcmLcHpzJTw7h5Yxw/msA0TCVOELYALC39
         +jEkR7+HJ+G1g5ES7sIhYTMPKtPTbmHTiNjcpAk1vrGNpA7wU2WkhME/4854LyxSYnRF
         I+Vw+Tchj1WDJg/wa+zAXtQHnOUfsfUsTWApkGWJGrhD0XjF84hdHrjZIXyNc+hotTpD
         c/fJJIZWz0agzfLEfe1jXyo5GWOCJWS5vGZsKxJbs/zZxAevNMbPEv2SdYOIktYCCFlJ
         PcwyocAmFVnUuWjwdFiET42o3d01ek0FUjaGJSkvvR/+zWRY3IyYTKXFDai+k+k6bwLW
         8jXw==
X-Gm-Message-State: AOJu0YyVKNAG201nxSAI6A8Eqja0MwlNe1aEuCeIBXcf7wae0/8PNU93
	SWztz4OEF7BRe1S7dZthW/QQulO9Kflksd5SJkkwHPrZx3YIQjV8aYN5r9O0hD/YqJsscWtCs1w
	1hCQWRmCpBOzjbDS6ARihYcuu/2IYieu6qM/GgHiWvWMbeUhacg==
X-Received: by 2002:a92:ce52:0:b0:363:7777:658f with SMTP id a18-20020a92ce52000000b003637777658fmr3539026ilr.11.1706495845485;
        Sun, 28 Jan 2024 18:37:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGL4U+CjALkUwgvEr0R2oxBdMRVvvqiairWp4q2asmJLUfMC7QmBMQd0rY+7cfLFiD2FCE7LA==
X-Received: by 2002:a92:ce52:0:b0:363:7777:658f with SMTP id a18-20020a92ce52000000b003637777658fmr3539021ilr.11.1706495845142;
        Sun, 28 Jan 2024 18:37:25 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id n12-20020a92d9cc000000b0036382484384sm275669ilq.17.2024.01.28.18.37.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jan 2024 18:37:24 -0800 (PST)
Date: Sun, 28 Jan 2024 19:37:23 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: liulongfang <liulongfang@huawei.com>
Cc: <jgg@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
 <jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: Re: [PATCH 2/3] hisi_acc_vfio_pci: register debugfs for hisilicon
 migration driver
Message-ID: <20240128193723.2f16c2fc.alex.williamson@redhat.com>
In-Reply-To: <ff787286-e3f6-1a32-2eb0-3d7976aeb34e@huawei.com>
References: <20240125081031.48707-1-liulongfang@huawei.com>
	<20240125081031.48707-3-liulongfang@huawei.com>
	<20240125153834.3f44bbad.alex.williamson@redhat.com>
	<ff787286-e3f6-1a32-2eb0-3d7976aeb34e@huawei.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 29 Jan 2024 10:24:00 +0800
liulongfang <liulongfang@huawei.com> wrote:

> On 2024/1/26 6:38, Alex Williamson wrote:
> > On Thu, 25 Jan 2024 16:10:30 +0800
> > Longfang Liu <liulongfang@huawei.com> wrote:
> >   
> >> On the debugfs framework of VFIO, if the CONFIG_VFIO_DEBUGFS macro is
> >> enabled, the debug function is registered for the live migration driver
> >> of the HiSilicon accelerator device.
> >>
> >> After registering the HiSilicon accelerator device on the debugfs
> >> framework of live migration of vfio, a directory file "hisi_acc"
> >> of debugfs is created, and then three debug function files are
> >> created in this directory:
> >>
> >>    vfio
> >>     |
> >>     +---<dev_name1>
> >>     |    +---migration
> >>     |        +--state
> >>     |        +--hisi_acc
> >>     |            +--attr
> >>     |            +--data
> >>     |            +--save
> >>     |            +--cmd_state
> >>     |
> >>     +---<dev_name2>
> >>          +---migration
> >>              +--state
> >>              +--hisi_acc
> >>                  +--attr
> >>                  +--data
> >>                  +--save
> >>                  +--cmd_state
> >>
> >> data file: used to get the migration data from the driver
> >> attr file: used to get device attributes parameters from the driver
> >> save file: used to read the data of the live migration device and save
> >> it to the driver.
> >> cmd_state: used to get the cmd channel state for the device.
> >>
> >> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> >> ---
> >>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 190 ++++++++++++++++++
> >>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |   5 +
> >>  2 files changed, 195 insertions(+)
> >>
> >> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> >> index 5f6e01571a7b..2cbbc52b7377 100644
> >> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> >> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> >> @@ -15,6 +15,7 @@
> >>  #include <linux/anon_inodes.h>
> >>  
> >>  #include "hisi_acc_vfio_pci.h"
> >> +#include "../../vfio.h"
> >>  
> >>  /* Return 0 on VM acc device ready, -ETIMEDOUT hardware timeout */
> >>  static int qm_wait_dev_not_ready(struct hisi_qm *qm)
> >> @@ -617,6 +618,18 @@ hisi_acc_check_int_state(struct hisi_acc_vf_core_device *hisi_acc_vdev)
> >>  	}
> >>  }
> >>  
> >> +static void hisi_acc_vf_migf_save(struct hisi_acc_vf_migration_file *dst_migf,
> >> +	struct hisi_acc_vf_migration_file *src_migf)
> >> +{
> >> +	if (!dst_migf)
> >> +		return;
> >> +
> >> +	dst_migf->disabled = false;
> >> +	dst_migf->total_length = src_migf->total_length;
> >> +	memcpy(&dst_migf->vf_data, &src_migf->vf_data,
> >> +		    sizeof(struct acc_vf_data));
> >> +}
> >> +
> >>  static void hisi_acc_vf_disable_fd(struct hisi_acc_vf_migration_file *migf)
> >>  {
> >>  	mutex_lock(&migf->lock);
> >> @@ -629,12 +642,16 @@ static void hisi_acc_vf_disable_fd(struct hisi_acc_vf_migration_file *migf)
> >>  static void hisi_acc_vf_disable_fds(struct hisi_acc_vf_core_device *hisi_acc_vdev)
> >>  {
> >>  	if (hisi_acc_vdev->resuming_migf) {
> >> +		hisi_acc_vf_migf_save(hisi_acc_vdev->debug_migf,
> >> +						hisi_acc_vdev->resuming_migf);
> >>  		hisi_acc_vf_disable_fd(hisi_acc_vdev->resuming_migf);
> >>  		fput(hisi_acc_vdev->resuming_migf->filp);
> >>  		hisi_acc_vdev->resuming_migf = NULL;
> >>  	}
> >>  
> >>  	if (hisi_acc_vdev->saving_migf) {
> >> +		hisi_acc_vf_migf_save(hisi_acc_vdev->debug_migf,
> >> +						hisi_acc_vdev->saving_migf);
> >>  		hisi_acc_vf_disable_fd(hisi_acc_vdev->saving_migf);
> >>  		fput(hisi_acc_vdev->saving_migf->filp);
> >>  		hisi_acc_vdev->saving_migf = NULL;
> >> @@ -1175,6 +1192,7 @@ static int hisi_acc_vf_qm_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
> >>  	if (!vf_qm->io_base)
> >>  		return -EIO;
> >>  
> >> +	mutex_init(&hisi_acc_vdev->enable_mutex);
> >>  	vf_qm->fun_type = QM_HW_VF;
> >>  	vf_qm->pdev = vf_dev;
> >>  	mutex_init(&vf_qm->mailbox_lock);
> >> @@ -1325,6 +1343,172 @@ static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int
> >>  	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
> >>  }
> >>  
> >> +static int hisi_acc_vf_debug_check(struct seq_file *seq, struct vfio_device *vdev)
> >> +{
> >> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
> >> +	struct hisi_acc_vf_migration_file *migf = hisi_acc_vdev->debug_migf;
> >> +
> >> +	if (!vdev->mig_ops || !migf) {
> >> +		seq_printf(seq, "%s\n", "device does not support live migration!");
> >> +		return -EINVAL;
> >> +	}
> >> +
> >> +	/**
> >> +	 * When the device is not opened, the io_base is not mapped.
> >> +	 * The driver cannot perform device read and write operations.
> >> +	 */
> >> +	if (!vdev->open_count) {
> >> +		seq_printf(seq, "%s\n", "device not opened!");
> >> +		return -EINVAL;
> >> +	}  
> > 
> > This is racy, this check could occur while the user is already closing
> > the device and vfio_df_device_last_close() may have already iounmap'd
> > the io_base.  Only after that is open_count decremented.  The debugfs
> > interfaces would then proceed to access the unmapped space.  The
> > enable_mutex is entirely ineffective (and also asymmetric, initialized
> > in the open_device path but never destroyed).
> > 
> > In fact, the enable_mutex really only seems to be trying to protect
> > io_base (which it doesn't do), meanwhile the core driver execution path
> > can run concurrently to debugfs operations with no serialization.  It
> > looks like these operations would step on each other.
> >  
> 
> Yes, this enable_mutex is used to protect io_base. It prevents debugfs
> from being used after executing iounmap in io_base.
> 
> > I think you might need an atomic to guard against io_base unmapping and
> > then maybe a mutex or semaphore to avoid debugfs accesses from
> > interfering with the actual core logic interacting with the device.
> > Thanks,
> >  
> 
> OK An atomic variable needs to be added to replace vdev->open_count to prevent
> competition. And use enable_mutex to prevent io_base from being released early.

That's not what I'm suggesting, open_count is safe in the core code, it
doesn't need to be an atomic.  Your use of it is unsafe.  enable_mutex
doesn't protect what it intends to protect.  Thanks,

Alex

> >> +	return 0;
> >> +}
> >> +
> >> +static int hisi_acc_vf_debug_cmd(struct seq_file *seq, void *data)
> >> +{
> >> +	struct device *vf_dev = seq->private;
> >> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
> >> +	struct vfio_device *vdev = &core_device->vdev;
> >> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
> >> +	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
> >> +	u64 value;
> >> +	int ret;
> >> +
> >> +	ret = hisi_acc_vf_debug_check(seq, vdev);
> >> +	if (ret)
> >> +		return 0;
> >> +
> >> +	mutex_lock(&hisi_acc_vdev->enable_mutex);
> >> +	ret = qm_wait_dev_not_ready(vf_qm);
> >> +	if (ret) {
> >> +		mutex_unlock(&hisi_acc_vdev->enable_mutex);
> >> +		seq_printf(seq, "%s\n", "VF device not ready!");
> >> +		return 0;
> >> +	}
> >> +
> >> +	value = readl(vf_qm->io_base + QM_MB_CMD_SEND_BASE);
> >> +	mutex_unlock(&hisi_acc_vdev->enable_mutex);
> >> +	seq_printf(seq, "%s:0x%llx\n", "mailbox cmd channel state is OK", value);
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int hisi_acc_vf_debug_save(struct seq_file *seq, void *data)
> >> +{
> >> +	struct device *vf_dev = seq->private;
> >> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
> >> +	struct vfio_device *vdev = &core_device->vdev;
> >> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
> >> +	struct hisi_acc_vf_migration_file *migf = hisi_acc_vdev->debug_migf;
> >> +	int ret;
> >> +
> >> +	ret = hisi_acc_vf_debug_check(seq, vdev);
> >> +	if (ret)
> >> +		return 0;
> >> +
> >> +	mutex_lock(&hisi_acc_vdev->enable_mutex);
> >> +	ret = vf_qm_state_save(hisi_acc_vdev, migf);
> >> +	if (ret) {
> >> +		mutex_unlock(&hisi_acc_vdev->enable_mutex);
> >> +		seq_printf(seq, "%s\n", "failed to save device data!");
> >> +		return 0;
> >> +	}
> >> +	mutex_unlock(&hisi_acc_vdev->enable_mutex);
> >> +	seq_printf(seq, "%s\n", "successful to save device data!");
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int hisi_acc_vf_data_read(struct seq_file *seq, void *data)
> >> +{
> >> +	struct device *vf_dev = seq->private;
> >> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
> >> +	struct vfio_device *vdev = &core_device->vdev;
> >> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
> >> +	struct hisi_acc_vf_migration_file *debug_migf = hisi_acc_vdev->debug_migf;
> >> +	size_t vf_data_sz = offsetofend(struct acc_vf_data, padding);
> >> +
> >> +	if (debug_migf && debug_migf->total_length)
> >> +		seq_hex_dump(seq, "Mig Data:", DUMP_PREFIX_OFFSET, 16, 1,
> >> +				(unsigned char *)&debug_migf->vf_data,
> >> +				vf_data_sz, false);
> >> +	else
> >> +		seq_printf(seq, "%s\n", "device not migrated!");
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int hisi_acc_vf_attr_read(struct seq_file *seq, void *data)
> >> +{
> >> +	struct device *vf_dev = seq->private;
> >> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
> >> +	struct vfio_device *vdev = &core_device->vdev;
> >> +	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
> >> +	struct hisi_acc_vf_migration_file *debug_migf = hisi_acc_vdev->debug_migf;
> >> +
> >> +	if (debug_migf && debug_migf->total_length) {
> >> +		seq_printf(seq,
> >> +			 "acc device:\n"
> >> +			 "device  state: %d\n"
> >> +			 "device  ready: %u\n"
> >> +			 "data    valid: %d\n"
> >> +			 "data     size: %lu\n",
> >> +			 hisi_acc_vdev->mig_state,
> >> +			 hisi_acc_vdev->vf_qm_state,
> >> +			 debug_migf->disabled,
> >> +			 debug_migf->total_length);
> >> +	} else {
> >> +		seq_printf(seq, "%s\n", "device not migrated!");
> >> +	}
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int hisi_acc_vfio_debug_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
> >> +{
> >> +	struct vfio_device *vdev = &hisi_acc_vdev->core_device.vdev;
> >> +	struct dentry *vfio_dev_migration = NULL;
> >> +	struct dentry *vfio_hisi_acc = NULL;
> >> +	struct device *dev = vdev->dev;
> >> +	void *migf = NULL;
> >> +
> >> +	if (!debugfs_initialized())
> >> +		return 0;
> >> +
> >> +	migf = kzalloc(sizeof(struct hisi_acc_vf_migration_file), GFP_KERNEL);
> >> +	if (!migf)
> >> +		return -ENOMEM;
> >> +	hisi_acc_vdev->debug_migf = migf;
> >> +
> >> +	vfio_dev_migration = debugfs_lookup("migration", vdev->debug_root);
> >> +	if (!vfio_dev_migration) {
> >> +		kfree(migf);
> >> +		dev_err(dev, "failed to lookup migration debugfs file!\n");
> >> +		return -ENODEV;
> >> +	}
> >> +
> >> +	vfio_hisi_acc = debugfs_create_dir("hisi_acc", vfio_dev_migration);
> >> +	debugfs_create_devm_seqfile(dev, "data", vfio_hisi_acc,
> >> +				  hisi_acc_vf_data_read);
> >> +	debugfs_create_devm_seqfile(dev, "attr", vfio_hisi_acc,
> >> +				  hisi_acc_vf_attr_read);
> >> +	debugfs_create_devm_seqfile(dev, "cmd_state", vfio_hisi_acc,
> >> +				  hisi_acc_vf_debug_cmd);
> >> +	debugfs_create_devm_seqfile(dev, "save", vfio_hisi_acc,
> >> +				  hisi_acc_vf_debug_save);
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static void hisi_acc_vf_debugfs_exit(struct hisi_acc_vf_core_device *hisi_acc_vdev)
> >> +{
> >> +	if (!debugfs_initialized())
> >> +		return;
> >> +
> >> +	kfree(hisi_acc_vdev->debug_migf);
> >> +}
> >> +
> >>  static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
> >>  {
> >>  	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(core_vdev);
> >> @@ -1353,7 +1537,9 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
> >>  	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(core_vdev);
> >>  	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
> >>  
> >> +	mutex_lock(&hisi_acc_vdev->enable_mutex);
> >>  	iounmap(vf_qm->io_base);
> >> +	mutex_unlock(&hisi_acc_vdev->enable_mutex);
> >>  	vfio_pci_core_close_device(core_vdev);
> >>  }
> >>  
> >> @@ -1444,6 +1630,9 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
> >>  	ret = vfio_pci_core_register_device(&hisi_acc_vdev->core_device);
> >>  	if (ret)
> >>  		goto out_put_vdev;
> >> +
> >> +	if (ops == &hisi_acc_vfio_pci_migrn_ops)
> >> +		hisi_acc_vfio_debug_init(hisi_acc_vdev);
> >>  	return 0;
> >>  
> >>  out_put_vdev:
> >> @@ -1456,6 +1645,7 @@ static void hisi_acc_vfio_pci_remove(struct pci_dev *pdev)
> >>  	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
> >>  
> >>  	vfio_pci_core_unregister_device(&hisi_acc_vdev->core_device);
> >> +	hisi_acc_vf_debugfs_exit(hisi_acc_vdev);
> >>  	vfio_put_device(&hisi_acc_vdev->core_device.vdev);
> >>  }
> >>  
> >> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> >> index c58fc5861492..38327b97d535 100644
> >> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> >> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> >> @@ -116,5 +116,10 @@ struct hisi_acc_vf_core_device {
> >>  	spinlock_t reset_lock;
> >>  	struct hisi_acc_vf_migration_file *resuming_migf;
> >>  	struct hisi_acc_vf_migration_file *saving_migf;
> >> +
> >> +	/* To make sure the device is enabled */
> >> +	struct mutex enable_mutex;
> >> +	/* For debugfs */
> >> +	struct hisi_acc_vf_migration_file *debug_migf;
> >>  };
> >>  #endif /* HISI_ACC_VFIO_PCI_H */  
> > 
> > .
> >   
> 


