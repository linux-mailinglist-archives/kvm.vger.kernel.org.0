Return-Path: <kvm+bounces-8058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D139284AA5F
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 00:16:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77D6228B5A6
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 23:16:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B720487A0;
	Mon,  5 Feb 2024 23:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kj2jHshM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0590448793
	for <kvm@vger.kernel.org>; Mon,  5 Feb 2024 23:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707174954; cv=none; b=L2H8VU3xBSTU/D8cK5ioXw8mmDQoTBl/pJuxZFWWJ0bTrpbgk1nejzWwHeIQbNxrCjLJhbeYY26IBez2aoSsHk1rBe2ouByMmPta5HPMCODdqPOAjjVVYejMx2+vvN5pqJ57su2qYzwq1/aTsz8Ob4O4ryWG3wFGja9+ViYd1dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707174954; c=relaxed/simple;
	bh=2uYfnbcG1XE8pHyF7WkojCv2M0yZYBB1gWHx5jSs+NI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l6BrxWBEoedbl2mro4sthaQjNQg8mJpbGGxlvkZQ6mcjYpKrqNtDALeUFfNar2Io3m35QB5qZv9hPot4HpBqCwb3Ugnv28r6KEdwXJzp608cWH0WJwT+BPwKfuB0FmlR03YvhcSDLChVkAl64DR8pAM3ZZH6GwODAjTNSNA9Vcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kj2jHshM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707174949;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wYcqR8bDXaJmLgHii17C5F4adu5tp++UiKos61ER0jw=;
	b=Kj2jHshMyPeRb6s0GFJeqvU9xW2CzPdSfBShK/N2WCsXHqbLri+rXfjgET2kW2FGQ5gw/n
	b33ac+5W/pRUiGkHfcYU02SOCpP38kF1khoqrNlij9Ey50XGJo+AZhaT1opxvY2mHIVpAW
	eDldjkQFOMy1xHRIZHNz3JprVlHYoVE=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-284-iQxVpz79N4Op_0xtBisanQ-1; Mon, 05 Feb 2024 18:15:48 -0500
X-MC-Unique: iQxVpz79N4Op_0xtBisanQ-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7c000114536so366366339f.2
        for <kvm@vger.kernel.org>; Mon, 05 Feb 2024 15:15:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707174947; x=1707779747;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wYcqR8bDXaJmLgHii17C5F4adu5tp++UiKos61ER0jw=;
        b=aa5RicYizrRCbMD1L04ApUo5GPLu9jGBfb5ZhnUiaKOytKxzVJW2DycwyO8hMQscy4
         cuWveNjZ8ExsshcBVWtLJzu/hStT+sn5JY6FVfsJjv1TibDWH+EAsOWesACkYPBfExV5
         aTwYV6EgltDjRRhG2THRl3p+IultJFvjiZGxveDwO5DAJP6HBdzQiMTBw37r75YHIev8
         NzfNI14vcRdvPlXUA04/39QF58jjZ7ON0Fz3BLwRIrSXCir5vDPtWiwtRw/rYYAKJ2kj
         om6tontvU2457rFPZ6hJXdFg/GeXgI23/XWAYSlJyfU/BvPuD6hyXv2gFzJtrWiOUvYu
         22hw==
X-Gm-Message-State: AOJu0YwFQvX2io5FFQDaPkDAwrAKpFPagF+f/oX6Xqlc3XCT2Xjfa4MV
	zX8/tVeCzHP36ozbpMz3c5h6EMnwaWqZSiRC3VvGM9Zl8M22DS+DU/svhqVfEjmR/yt8axbMd8C
	Sd7XFbxlwvMwY1cB33/TBvcpsp6qRPDL+bv09EhdUQaINtgVmtw==
X-Received: by 2002:a6b:7f07:0:b0:7c0:2426:2702 with SMTP id l7-20020a6b7f07000000b007c024262702mr1297500ioq.18.1707174947137;
        Mon, 05 Feb 2024 15:15:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHq/lCmXdRXT8vbGsyE08xceFSSY1rPj5oI0rv9RSTFtVPc945GqY98zgA6SUcfHeh/De3ggQ==
X-Received: by 2002:a6b:7f07:0:b0:7c0:2426:2702 with SMTP id l7-20020a6b7f07000000b007c024262702mr1297486ioq.18.1707174946841;
        Mon, 05 Feb 2024 15:15:46 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXXv5GwHt0wAbp+tL2SwTqCXmT2BmfuTu7v4NPZTkxhlcs5E903mlH5OdgfPHNQPCdZaZf/sxa0+1yE9Mx8qYrzjNVs4tLJZ56ocD8L44ZBW5ibDHFtENKhe0VvCcN7Y3TWcVok/NZ/2ibGqDWxCpB25N+jizl2SccrsIsGi+Yyo+ehuqE2NJ5GJrzC6EIopSVC0V3CXuDGW2TBE6ipaTNDPP9oZdnY
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id y5-20020a02c005000000b004712c18c13asm212076jai.125.2024.02.05.15.15.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Feb 2024 15:15:46 -0800 (PST)
Date: Mon, 5 Feb 2024 16:15:45 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: liulongfang <liulongfang@huawei.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
 "Jonathan Cameron" <jonathan.cameron@huawei.com>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linuxarm@openeuler.org"
 <linuxarm@openeuler.org>
Subject: Re: [PATCH v2 2/3] hisi_acc_vfio_pci: register debugfs for
 hisilicon migration driver
Message-ID: <20240205161545.30c9b6fc.alex.williamson@redhat.com>
In-Reply-To: <0337a36286244e28b26895b24a7b36d3@huawei.com>
References: <20240204085610.17720-1-liulongfang@huawei.com>
	<20240204085610.17720-3-liulongfang@huawei.com>
	<0337a36286244e28b26895b24a7b36d3@huawei.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 5 Feb 2024 08:52:06 +0000
Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:

> > -----Original Message-----
> > From: liulongfang <liulongfang@huawei.com>
> > Sent: Sunday, February 4, 2024 8:56 AM
> > To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
> > Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> > <jonathan.cameron@huawei.com>
> > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
> > Subject: [PATCH v2 2/3] hisi_acc_vfio_pci: register debugfs for hisilicon
> > migration driver
> > 
> > On the debugfs framework of VFIO, if the CONFIG_VFIO_DEBUGFS macro is
> > enabled, the debug function is registered for the live migration driver
> > of the HiSilicon accelerator device.
> > 
> > After registering the HiSilicon accelerator device on the debugfs
> > framework of live migration of vfio, a directory file "hisi_acc"
> > of debugfs is created, and then three debug function files are
> > created in this directory:
> > 
> >    vfio
> >     |
> >     +---<dev_name1>
> >     |    +---migration
> >     |        +--state
> >     |        +--hisi_acc
> >     |            +--attr
> >     |            +--data
> >     |            +--save
> >     |            +--cmd_state
> >     |
> >     +---<dev_name2>
> >          +---migration
> >              +--state
> >              +--hisi_acc
> >                  +--attr
> >                  +--data
> >                  +--save
> >                  +--cmd_state
> > 
> > data file: used to get the migration data from the driver
> > attr file: used to get device attributes parameters from the driver
> > save file: used to read the data of the live migration device and save
> > it to the driver.
> > cmd_state: used to get the cmd channel state for the device.
> > 
> > Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> > ---
> >  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 197 ++++++++++++++++++
> >  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  11 +
> >  2 files changed, 208 insertions(+)
> > 
> > diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> > b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> > index 00a22a990eb8..e51bbb41c2b3 100644
> > --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> > +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> > @@ -15,6 +15,7 @@
> >  #include <linux/anon_inodes.h>
> > 
> >  #include "hisi_acc_vfio_pci.h"
> > +#include "../../vfio.h"
> > 
> >  /* Return 0 on VM acc device ready, -ETIMEDOUT hardware timeout */
> >  static int qm_wait_dev_not_ready(struct hisi_qm *qm)
> > @@ -606,6 +607,18 @@ hisi_acc_check_int_state(struct
> > hisi_acc_vf_core_device *hisi_acc_vdev)
> >  	}
> >  }
> > 
> > +static void hisi_acc_vf_migf_save(struct hisi_acc_vf_migration_file
> > *dst_migf,  
> 
> Can we please rename this to indicate the debug, similar to other debugfs support
> functions here, something like hisi_acc_vf_debug_migf_save()?
> 
> > +	struct hisi_acc_vf_migration_file *src_migf)
> > +{
> > +	if (!dst_migf)
> > +		return;
> > +
> > +	dst_migf->disabled = false;  
> 
> Is this set to true anywhere for debugfs migf ?
> 
> > +	dst_migf->total_length = src_migf->total_length;
> > +	memcpy(&dst_migf->vf_data, &src_migf->vf_data,
> > +		    sizeof(struct acc_vf_data));
> > +}
> > +
> >  static void hisi_acc_vf_disable_fd(struct hisi_acc_vf_migration_file *migf)
> >  {
> >  	mutex_lock(&migf->lock);
> > @@ -618,12 +631,16 @@ static void hisi_acc_vf_disable_fd(struct
> > hisi_acc_vf_migration_file *migf)
> >  static void hisi_acc_vf_disable_fds(struct hisi_acc_vf_core_device
> > *hisi_acc_vdev)
> >  {
> >  	if (hisi_acc_vdev->resuming_migf) {
> > +		hisi_acc_vf_migf_save(hisi_acc_vdev->debug_migf,
> > +						hisi_acc_vdev-  
> > >resuming_migf);  
> >  		hisi_acc_vf_disable_fd(hisi_acc_vdev->resuming_migf);
> >  		fput(hisi_acc_vdev->resuming_migf->filp);
> >  		hisi_acc_vdev->resuming_migf = NULL;
> >  	}
> > 
> >  	if (hisi_acc_vdev->saving_migf) {
> > +		hisi_acc_vf_migf_save(hisi_acc_vdev->debug_migf,
> > +						hisi_acc_vdev->saving_migf);
> >  		hisi_acc_vf_disable_fd(hisi_acc_vdev->saving_migf);
> >  		fput(hisi_acc_vdev->saving_migf->filp);
> >  		hisi_acc_vdev->saving_migf = NULL;
> > @@ -1156,6 +1173,7 @@ static int hisi_acc_vf_qm_init(struct
> > hisi_acc_vf_core_device *hisi_acc_vdev)
> >  	if (!vf_qm->io_base)
> >  		return -EIO;
> > 
> > +	mutex_init(&hisi_acc_vdev->enable_mutex);
> >  	vf_qm->fun_type = QM_HW_VF;
> >  	vf_qm->pdev = vf_dev;
> >  	mutex_init(&vf_qm->mailbox_lock);
> > @@ -1306,6 +1324,176 @@ static long hisi_acc_vfio_pci_ioctl(struct
> > vfio_device *core_vdev, unsigned int
> >  	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
> >  }
> > 
> > +static int hisi_acc_vf_debug_check(struct seq_file *seq, struct vfio_device
> > *vdev)
> > +{
> > +	struct hisi_acc_vf_core_device *hisi_acc_vdev =
> > hisi_acc_get_vf_dev(vdev);
> > +	struct hisi_acc_vf_migration_file *migf = hisi_acc_vdev->debug_migf;
> > +
> > +	if (!vdev->mig_ops || !migf) {
> > +		seq_printf(seq, "%s\n", "device does not support live
> > migration!");
> > +		return -EINVAL;
> > +	}
> > +
> > +	/**
> > +	 * When the device is not opened, the io_base is not mapped.
> > +	 * The driver cannot perform device read and write operations.
> > +	 */
> > +	if (atomic_read(&hisi_acc_vdev->dev_opened) != DEV_OPEN) {
> > +		seq_printf(seq, "%s\n", "device not opened!");
> > +		return -EINVAL;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int hisi_acc_vf_debug_cmd(struct seq_file *seq, void *data)
> > +{
> > +	struct device *vf_dev = seq->private;
> > +	struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
> > +	struct vfio_device *vdev = &core_device->vdev;
> > +	struct hisi_acc_vf_core_device *hisi_acc_vdev =
> > hisi_acc_get_vf_dev(vdev);
> > +	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
> > +	u64 value;
> > +	int ret;
> > +
> > +	mutex_lock(&hisi_acc_vdev->enable_mutex);
> > +	ret = hisi_acc_vf_debug_check(seq, vdev);
> > +	if (ret) {
> > +		mutex_unlock(&hisi_acc_vdev->enable_mutex);
> > +		return 0;
> > +	}
> > +
> > +	ret = qm_wait_dev_not_ready(vf_qm);
> > +	if (ret) {
> > +		mutex_unlock(&hisi_acc_vdev->enable_mutex);
> > +		seq_printf(seq, "%s\n", "VF device not ready!");
> > +		return 0;
> > +	}
> > +
> > +	value = readl(vf_qm->io_base + QM_MB_CMD_SEND_BASE);
> > +	mutex_unlock(&hisi_acc_vdev->enable_mutex);
> > +	seq_printf(seq, "%s:0x%llx\n", "mailbox cmd channel state is OK",
> > value);
> > +
> > +	return 0;
> > +}
> > +
> > +static int hisi_acc_vf_debug_save(struct seq_file *seq, void *data)
> > +{
> > +	struct device *vf_dev = seq->private;
> > +	struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
> > +	struct vfio_device *vdev = &core_device->vdev;
> > +	struct hisi_acc_vf_core_device *hisi_acc_vdev =
> > hisi_acc_get_vf_dev(vdev);
> > +	struct hisi_acc_vf_migration_file *migf = hisi_acc_vdev->debug_migf;
> > +	int ret;
> > +
> > +	mutex_lock(&hisi_acc_vdev->enable_mutex);
> > +	ret = hisi_acc_vf_debug_check(seq, vdev);
> > +	if (ret) {
> > +		mutex_unlock(&hisi_acc_vdev->enable_mutex);
> > +		return 0;
> > +	}
> > +
> > +	ret = vf_qm_state_save(hisi_acc_vdev, migf);  
> 
> Are you sure this will not interfere with the core migration APIs as we are not
> holding the state_mutex?. I think Alex also raised a similar concern previously. 
> Applies to other debugfs interfaces here as well. Please check.

And if it does not need to be serialized, why are we using a mutex
rather than a semaphore?  For example if it can run concurrently with
the core migration APIs, it should run concurrently with itself and
debugfs could take read-locks.  Also as implemented here the atomic is
not only uninitialized, but pretty pointless anyway.  dev_opened could
be a bool protected within the mutex/semaphore, which would at least
make it sane that the lock protects the bool since it clearly doesn't
protect io_base.  Thanks,

Alex

> > +	if (ret) {
> > +		mutex_unlock(&hisi_acc_vdev->enable_mutex);
> > +		seq_printf(seq, "%s\n", "failed to save device data!");
> > +		return 0;
> > +	}
> > +	mutex_unlock(&hisi_acc_vdev->enable_mutex);
> > +	seq_printf(seq, "%s\n", "successful to save device data!");
> > +
> > +	return 0;
> > +}
> > +
> > +static int hisi_acc_vf_data_read(struct seq_file *seq, void *data)
> > +{
> > +	struct device *vf_dev = seq->private;
> > +	struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
> > +	struct vfio_device *vdev = &core_device->vdev;
> > +	struct hisi_acc_vf_core_device *hisi_acc_vdev =
> > hisi_acc_get_vf_dev(vdev);
> > +	struct hisi_acc_vf_migration_file *debug_migf = hisi_acc_vdev-  
> > >debug_migf;  
> > +	size_t vf_data_sz = offsetofend(struct acc_vf_data, padding);
> > +
> > +	if (debug_migf && debug_migf->total_length)
> > +		seq_hex_dump(seq, "Mig Data:", DUMP_PREFIX_OFFSET, 16,
> > 1,
> > +				(unsigned char *)&debug_migf->vf_data,
> > +				vf_data_sz, false);
> > +	else
> > +		seq_printf(seq, "%s\n", "device not migrated!");
> > +
> > +	return 0;
> > +}
> > +
> > +static int hisi_acc_vf_attr_read(struct seq_file *seq, void *data)
> > +{
> > +	struct device *vf_dev = seq->private;
> > +	struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
> > +	struct vfio_device *vdev = &core_device->vdev;
> > +	struct hisi_acc_vf_core_device *hisi_acc_vdev =
> > hisi_acc_get_vf_dev(vdev);
> > +	struct hisi_acc_vf_migration_file *debug_migf = hisi_acc_vdev-  
> > >debug_migf;  
> > +
> > +	if (debug_migf && debug_migf->total_length) {
> > +		seq_printf(seq,
> > +			 "acc device:\n"
> > +			 "device  state: %d\n"
> > +			 "device  ready: %u\n"
> > +			 "data    valid: %d\n"
> > +			 "data     size: %lu\n",
> > +			 hisi_acc_vdev->mig_state,
> > +			 hisi_acc_vdev->vf_qm_state,
> > +			 debug_migf->disabled,
> > +			 debug_migf->total_length);
> > +	} else {
> > +		seq_printf(seq, "%s\n", "device not migrated!");
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int hisi_acc_vfio_debug_init(struct hisi_acc_vf_core_device
> > *hisi_acc_vdev)
> > +{
> > +	struct vfio_device *vdev = &hisi_acc_vdev->core_device.vdev;
> > +	struct dentry *vfio_dev_migration = NULL;
> > +	struct dentry *vfio_hisi_acc = NULL;
> > +	struct device *dev = vdev->dev;
> > +	void *migf = NULL;
> > +
> > +	if (!debugfs_initialized())
> > +		return 0;
> > +
> > +	migf = kzalloc(sizeof(struct hisi_acc_vf_migration_file), GFP_KERNEL);
> > +	if (!migf)
> > +		return -ENOMEM;
> > +	hisi_acc_vdev->debug_migf = migf;
> > +
> > +	vfio_dev_migration = debugfs_lookup("migration", vdev-  
> > >debug_root);  
> > +	if (!vfio_dev_migration) {
> > +		kfree(migf);
> > +		dev_err(dev, "failed to lookup migration debugfs file!\n");
> > +		return -ENODEV;
> > +	}
> > +
> > +	vfio_hisi_acc = debugfs_create_dir("hisi_acc", vfio_dev_migration);
> > +	debugfs_create_devm_seqfile(dev, "data", vfio_hisi_acc,
> > +				  hisi_acc_vf_data_read);
> > +	debugfs_create_devm_seqfile(dev, "attr", vfio_hisi_acc,
> > +				  hisi_acc_vf_attr_read);
> > +	debugfs_create_devm_seqfile(dev, "cmd_state", vfio_hisi_acc,
> > +				  hisi_acc_vf_debug_cmd);
> > +	debugfs_create_devm_seqfile(dev, "save", vfio_hisi_acc,
> > +				  hisi_acc_vf_debug_save);
> > +
> > +	return 0;
> > +}
> > +
> > +static void hisi_acc_vf_debugfs_exit(struct hisi_acc_vf_core_device
> > *hisi_acc_vdev)
> > +{
> > +	if (!debugfs_initialized())
> > +		return;
> > +
> > +	kfree(hisi_acc_vdev->debug_migf);
> > +}
> > +
> >  static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
> >  {
> >  	struct hisi_acc_vf_core_device *hisi_acc_vdev =
> > hisi_acc_get_vf_dev(core_vdev);
> > @@ -1323,9 +1511,11 @@ static int hisi_acc_vfio_pci_open_device(struct
> > vfio_device *core_vdev)
> >  			return ret;
> >  		}
> >  		hisi_acc_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
> > +		atomic_set(&hisi_acc_vdev->dev_opened, DEV_OPEN);
> >  	}
> > 
> >  	vfio_pci_core_finish_enable(vdev);
> > +
> >  	return 0;
> >  }
> > 
> > @@ -1334,7 +1524,10 @@ static void hisi_acc_vfio_pci_close_device(struct
> > vfio_device *core_vdev)
> >  	struct hisi_acc_vf_core_device *hisi_acc_vdev =
> > hisi_acc_get_vf_dev(core_vdev);
> >  	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
> > 
> > +	atomic_set(&hisi_acc_vdev->dev_opened, DEV_CLOSE);
> > +	mutex_lock(&hisi_acc_vdev->enable_mutex);
> >  	iounmap(vf_qm->io_base);
> > +	mutex_unlock(&hisi_acc_vdev->enable_mutex);
> >  	vfio_pci_core_close_device(core_vdev);
> >  }
> > 
> > @@ -1425,6 +1618,9 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev
> > *pdev, const struct pci_device
> >  	ret = vfio_pci_core_register_device(&hisi_acc_vdev->core_device);
> >  	if (ret)
> >  		goto out_put_vdev;
> > +
> > +	if (ops == &hisi_acc_vfio_pci_migrn_ops)
> > +		hisi_acc_vfio_debug_init(hisi_acc_vdev);
> >  	return 0;
> > 
> >  out_put_vdev:
> > @@ -1437,6 +1633,7 @@ static void hisi_acc_vfio_pci_remove(struct pci_dev
> > *pdev)
> >  	struct hisi_acc_vf_core_device *hisi_acc_vdev =
> > hisi_acc_drvdata(pdev);
> > 
> >  	vfio_pci_core_unregister_device(&hisi_acc_vdev->core_device);
> > +	hisi_acc_vf_debugfs_exit(hisi_acc_vdev);
> >  	vfio_put_device(&hisi_acc_vdev->core_device.vdev);
> >  }
> > 
> > diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> > b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> > index dcabfeec6ca1..283bd8acdc42 100644
> > --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> > +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> > @@ -49,6 +49,11 @@
> >  #define QM_EQC_DW0		0X8000
> >  #define QM_AEQC_DW0		0X8020
> > 
> > +enum acc_dev_state {
> > +	DEV_CLOSE = 0x0,
> > +	DEV_OPEN,
> > +};  
> 
> Do we really need this enum as you can directly use 0 or 1?
> 
> Thanks,
> Shameer
> 
> > +
> >  struct acc_vf_data {
> >  #define QM_MATCH_SIZE offsetofend(struct acc_vf_data, qm_rsv_state)
> >  	/* QM match information */
> > @@ -113,5 +118,11 @@ struct hisi_acc_vf_core_device {
> >  	spinlock_t reset_lock;
> >  	struct hisi_acc_vf_migration_file *resuming_migf;
> >  	struct hisi_acc_vf_migration_file *saving_migf;
> > +
> > +	/* To make sure the device is enabled */
> > +	struct mutex enable_mutex;
> > +	atomic_t dev_opened;
> > +	/* For debugfs */
> > +	struct hisi_acc_vf_migration_file *debug_migf;
> >  };
> >  #endif /* HISI_ACC_VFIO_PCI_H */
> > --
> > 2.24.0  
> 
> 


