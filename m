Return-Path: <kvm+bounces-3883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15C39809587
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 23:43:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0ED26B20DBE
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 22:43:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A25BB5733A;
	Thu,  7 Dec 2023 22:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hJdmGsxW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39441710
	for <kvm@vger.kernel.org>; Thu,  7 Dec 2023 14:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701989020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fHfMQMKeCWBCdfme5l3eiXOD3BMHusayk9aiRBJhkOY=;
	b=hJdmGsxWHTUe/IbDMnUQEvFFeu5+2/zh4BybrRDxP7SGZ1qyiIkXyoOlySU+Wg+8LLt0Bd
	TL73NOW/eBWZ9S2FBfB8/ZPFGON3BzQ1pphHhiX7NCwPbnS+u/QdTXyAfjfB9lnO6mtS5f
	u+NYv05mA3oBQSZ3v4N5sGOmHGuqvrY=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-546-DmCaKgdGPe-qWVlgqtrhAg-1; Thu, 07 Dec 2023 17:43:38 -0500
X-MC-Unique: DmCaKgdGPe-qWVlgqtrhAg-1
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-46484027000so408236137.0
        for <kvm@vger.kernel.org>; Thu, 07 Dec 2023 14:43:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701989013; x=1702593813;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fHfMQMKeCWBCdfme5l3eiXOD3BMHusayk9aiRBJhkOY=;
        b=Qf/CcYFd9ojdFJvLDDf099581i+B8acoU+fZ2/0FBX6tEC6sTzDxS4A7eCNcaVBFWP
         90QsLtRxYReU3IoVjcnDww2JP4k3qWmHx7XiW6HxoKp+vaY77lpm5qOfGa/jbple7vbf
         JaoEG0yLy+dk/Fnwmmj6egUhes5IynJzgueXrsvI39SjWw8n9dES01RRH9P5AVYtdSar
         Qz3LruyZp1nlrj0rZfqZORUczOzZtXzJJ5/F1oLZuUlhXGYbmRomwBDwDbOAKPjPARnX
         gNdC3xjlcVO5OrE1UEWU9tWbwmAtiyeGSX4Mrnpy3ul/ZI3ruNzvcQv1iqHxIxdtn7mB
         hfnQ==
X-Gm-Message-State: AOJu0YyZdLnSDvdjCOsSgEFPOTVbeEQexJqYW8vqN1ZI+K1nvTGnmdHI
	9KlHztIDb+tCMp8nTLiCpHOqulnOHqkmsTaeQC5nhuBMsOU9Ek6tZDDE6unRXyb+pvu2osfN7Vx
	upFB91WRDl9gk
X-Received: by 2002:a05:6102:b08:b0:464:784f:8e3d with SMTP id b8-20020a0561020b0800b00464784f8e3dmr3464701vst.31.1701989013241;
        Thu, 07 Dec 2023 14:43:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHFm/g7cFWI2g19CP8mj7v5DfMDRON9ucN6ra+CPKR92LNi49FjrKwxTrgdXAxpxrOsOfY8bQ==
X-Received: by 2002:a05:6102:b08:b0:464:784f:8e3d with SMTP id b8-20020a0561020b0800b00464784f8e3dmr3464683vst.31.1701989012870;
        Thu, 07 Dec 2023 14:43:32 -0800 (PST)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id h17-20020a0cf211000000b0067ab79c539asm262630qvk.111.2023.12.07.14.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Dec 2023 14:43:31 -0800 (PST)
Date: Thu, 7 Dec 2023 15:43:27 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yahui Cao <yahui.cao@intel.com>
Cc: intel-wired-lan@lists.osuosl.org, kvm@vger.kernel.org,
 netdev@vger.kernel.org, lingyu.liu@intel.com, kevin.tian@intel.com,
 madhu.chittim@intel.com, sridhar.samudrala@intel.com, jgg@nvidia.com,
 yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
 brett.creeley@amd.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH iwl-next v4 12/12] vfio/ice: Implement vfio_pci driver
 for E800 devices
Message-ID: <20231207154327.4bd74c98.alex.williamson@redhat.com>
In-Reply-To: <20231121025111.257597-13-yahui.cao@intel.com>
References: <20231121025111.257597-1-yahui.cao@intel.com>
	<20231121025111.257597-13-yahui.cao@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 21 Nov 2023 02:51:11 +0000
Yahui Cao <yahui.cao@intel.com> wrote:

> From: Lingyu Liu <lingyu.liu@intel.com>
> 
> Add a vendor-specific vfio_pci driver for E800 devices.
> 
> It uses vfio_pci_core to register to the VFIO subsystem and then
> implements the E800 specific logic to support VF live migration.
> 
> It implements the device state transition flow for live
> migration.
> 
> Signed-off-by: Lingyu Liu <lingyu.liu@intel.com>
> Signed-off-by: Yahui Cao <yahui.cao@intel.com>
> ---
>  MAINTAINERS                         |   7 +
>  drivers/vfio/pci/Kconfig            |   2 +
>  drivers/vfio/pci/Makefile           |   2 +
>  drivers/vfio/pci/ice/Kconfig        |  10 +
>  drivers/vfio/pci/ice/Makefile       |   4 +
>  drivers/vfio/pci/ice/ice_vfio_pci.c | 707 ++++++++++++++++++++++++++++
>  6 files changed, 732 insertions(+)
>  create mode 100644 drivers/vfio/pci/ice/Kconfig
>  create mode 100644 drivers/vfio/pci/ice/Makefile
>  create mode 100644 drivers/vfio/pci/ice/ice_vfio_pci.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 97f51d5ec1cf..c8faf7fe1bd1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22860,6 +22860,13 @@ L:	kvm@vger.kernel.org
>  S:	Maintained
>  F:	drivers/vfio/pci/mlx5/
>  
> +VFIO ICE PCI DRIVER
> +M:	Yahui Cao <yahui.cao@intel.com>
> +M:	Lingyu Liu <lingyu.liu@intel.com>
> +L:	kvm@vger.kernel.org
> +S:	Maintained
> +F:	drivers/vfio/pci/ice/
> +
>  VFIO PCI DEVICE SPECIFIC DRIVERS
>  R:	Jason Gunthorpe <jgg@nvidia.com>
>  R:	Yishai Hadas <yishaih@nvidia.com>
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index 8125e5f37832..6618208947af 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -65,4 +65,6 @@ source "drivers/vfio/pci/hisilicon/Kconfig"
>  
>  source "drivers/vfio/pci/pds/Kconfig"
>  
> +source "drivers/vfio/pci/ice/Kconfig"
> +
>  endmenu
> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> index 45167be462d8..fc1df82df3ac 100644
> --- a/drivers/vfio/pci/Makefile
> +++ b/drivers/vfio/pci/Makefile
> @@ -13,3 +13,5 @@ obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
>  obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
>  
>  obj-$(CONFIG_PDS_VFIO_PCI) += pds/
> +
> +obj-$(CONFIG_ICE_VFIO_PCI) += ice/
> diff --git a/drivers/vfio/pci/ice/Kconfig b/drivers/vfio/pci/ice/Kconfig
> new file mode 100644
> index 000000000000..0b8cd1489073
> --- /dev/null
> +++ b/drivers/vfio/pci/ice/Kconfig
> @@ -0,0 +1,10 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +config ICE_VFIO_PCI
> +	tristate "VFIO support for Intel(R) Ethernet Connection E800 Series"
> +	depends on ICE
> +	select VFIO_PCI_CORE
> +	help
> +	  This provides migration support for Intel(R) Ethernet connection E800
> +	  series devices using the VFIO framework.
> +
> +	  If you don't know what to do here, say N.
> diff --git a/drivers/vfio/pci/ice/Makefile b/drivers/vfio/pci/ice/Makefile
> new file mode 100644
> index 000000000000..259d4ab89105
> --- /dev/null
> +++ b/drivers/vfio/pci/ice/Makefile
> @@ -0,0 +1,4 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +obj-$(CONFIG_ICE_VFIO_PCI) += ice-vfio-pci.o
> +ice-vfio-pci-y := ice_vfio_pci.o
> +
> diff --git a/drivers/vfio/pci/ice/ice_vfio_pci.c b/drivers/vfio/pci/ice/ice_vfio_pci.c
> new file mode 100644
> index 000000000000..28a181aa2f3f
> --- /dev/null
> +++ b/drivers/vfio/pci/ice/ice_vfio_pci.c
> @@ -0,0 +1,707 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (C) 2018-2023 Intel Corporation */
> +
> +#include <linux/device.h>
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <linux/file.h>
> +#include <linux/pci.h>
> +#include <linux/vfio_pci_core.h>
> +#include <linux/net/intel/ice_migration.h>
> +#include <linux/anon_inodes.h>
> +
> +#define DRIVER_DESC     "ICE VFIO PCI - User Level meta-driver for Intel E800 device family"
> +
> +struct ice_vfio_pci_migration_file {
> +	struct file *filp;
> +	struct mutex lock; /* protect migration file access */
> +	bool disabled;
> +
> +	u8 mig_data[SZ_128K];
> +	size_t total_length;
> +};
> +
> +struct ice_vfio_pci_core_device {
> +	struct vfio_pci_core_device core_device;
> +	u8 deferred_reset:1;

Move vf_id here to use some of the hole this leaves.

> +	struct mutex state_mutex; /* protect migration state */
> +	enum vfio_device_mig_state mig_state;
> +	/* protect the reset_done flow */
> +	spinlock_t reset_lock;
> +	struct ice_vfio_pci_migration_file *resuming_migf;
> +	struct ice_vfio_pci_migration_file *saving_migf;
> +	struct vfio_device_migration_info mig_info;
> +	u8 *mig_data;
> +	struct ice_pf *pf;
> +	int vf_id;
> +};
> +
> +/**
> + * ice_vfio_pci_load_state - VFIO device state reloading
> + * @ice_vdev: pointer to ice vfio pci core device structure
> + *
> + * Load device state. This function is called when the userspace VFIO uAPI
> + * consumer wants to load the device state info from VFIO migration region and
> + * load them into the device. This function should make sure all the device
> + * state info is loaded successfully. As a result, return value is mandatory
> + * to be checked.
> + *
> + * Return 0 for success, negative value for failure.
> + */
> +static int __must_check
> +ice_vfio_pci_load_state(struct ice_vfio_pci_core_device *ice_vdev)
> +{
> +	struct ice_vfio_pci_migration_file *migf = ice_vdev->resuming_migf;
> +
> +	return ice_migration_load_devstate(ice_vdev->pf,
> +					   ice_vdev->vf_id,
> +					   migf->mig_data,
> +					   migf->total_length);
> +}
> +
> +/**
> + * ice_vfio_pci_save_state - VFIO device state saving
> + * @ice_vdev: pointer to ice vfio pci core device structure
> + * @migf: pointer to migration file
> + *
> + * Snapshot the device state and save it. This function is called when the
> + * VFIO uAPI consumer wants to snapshot the current device state and saves
> + * it into the VFIO migration region. This function should make sure all
> + * of the device state info is collectted and saved successfully. As a
> + * result, return value is mandatory to be checked.
> + *
> + * Return 0 for success, negative value for failure.
> + */
> +static int __must_check
> +ice_vfio_pci_save_state(struct ice_vfio_pci_core_device *ice_vdev,
> +			struct ice_vfio_pci_migration_file *migf)
> +{
> +	migf->total_length = SZ_128K;
> +
> +	return ice_migration_save_devstate(ice_vdev->pf,
> +					   ice_vdev->vf_id,
> +					   migf->mig_data,
> +					   migf->total_length);
> +}
> +
> +/**
> + * ice_vfio_migration_init - Initialization for live migration function
> + * @ice_vdev: pointer to ice vfio pci core device structure
> + *
> + * Returns 0 on success, negative value on error
> + */
> +static int ice_vfio_migration_init(struct ice_vfio_pci_core_device *ice_vdev)
> +{
> +	struct pci_dev *pdev = ice_vdev->core_device.pdev;
> +
> +	ice_vdev->pf = ice_migration_get_pf(pdev);
> +	if (!ice_vdev->pf)
> +		return -EFAULT;
> +
> +	ice_vdev->vf_id = pci_iov_vf_id(pdev);
> +	if (ice_vdev->vf_id < 0)
> +		return -EINVAL;
> +
> +	return ice_migration_init_dev(ice_vdev->pf, ice_vdev->vf_id);
> +}
> +
> +/**
> + * ice_vfio_migration_uninit - Cleanup for live migration function
> + * @ice_vdev: pointer to ice vfio pci core device structure
> + */
> +static void ice_vfio_migration_uninit(struct ice_vfio_pci_core_device *ice_vdev)
> +{
> +	ice_migration_uninit_dev(ice_vdev->pf, ice_vdev->vf_id);
> +}
> +
> +/**
> + * ice_vfio_pci_disable_fd - Close migration file
> + * @migf: pointer to ice vfio pci migration file
> + */
> +static void ice_vfio_pci_disable_fd(struct ice_vfio_pci_migration_file *migf)
> +{
> +	mutex_lock(&migf->lock);
> +	migf->disabled = true;
> +	migf->total_length = 0;
> +	migf->filp->f_pos = 0;
> +	mutex_unlock(&migf->lock);
> +}
> +
> +/**
> + * ice_vfio_pci_disable_fds - Close migration files of ice vfio pci device
> + * @ice_vdev: pointer to ice vfio pci core device structure
> + */
> +static void ice_vfio_pci_disable_fds(struct ice_vfio_pci_core_device *ice_vdev)
> +{
> +	if (ice_vdev->resuming_migf) {
> +		ice_vfio_pci_disable_fd(ice_vdev->resuming_migf);
> +		fput(ice_vdev->resuming_migf->filp);
> +		ice_vdev->resuming_migf = NULL;
> +	}
> +	if (ice_vdev->saving_migf) {
> +		ice_vfio_pci_disable_fd(ice_vdev->saving_migf);
> +		fput(ice_vdev->saving_migf->filp);
> +		ice_vdev->saving_migf = NULL;
> +	}
> +}
> +
> +/*
> + * This function is called in all state_mutex unlock cases to
> + * handle a 'deferred_reset' if exists.
> + * @ice_vdev: pointer to ice vfio pci core device structure
> + */
> +static void
> +ice_vfio_pci_state_mutex_unlock(struct ice_vfio_pci_core_device *ice_vdev)
> +{
> +again:
> +	spin_lock(&ice_vdev->reset_lock);
> +	if (ice_vdev->deferred_reset) {
> +		ice_vdev->deferred_reset = false;
> +		spin_unlock(&ice_vdev->reset_lock);
> +		ice_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
> +		ice_vfio_pci_disable_fds(ice_vdev);
> +		goto again;
> +	}
> +	mutex_unlock(&ice_vdev->state_mutex);
> +	spin_unlock(&ice_vdev->reset_lock);
> +}
> +
> +static void ice_vfio_pci_reset_done(struct pci_dev *pdev)
> +{
> +	struct ice_vfio_pci_core_device *ice_vdev =
> +		(struct ice_vfio_pci_core_device *)dev_get_drvdata(&pdev->dev);
> +
> +	/*
> +	 * As the higher VFIO layers are holding locks across reset and using
> +	 * those same locks with the mm_lock we need to prevent ABBA deadlock
> +	 * with the state_mutex and mm_lock.
> +	 * In case the state_mutex was taken already we defer the cleanup work
> +	 * to the unlock flow of the other running context.
> +	 */
> +	spin_lock(&ice_vdev->reset_lock);
> +	ice_vdev->deferred_reset = true;
> +	if (!mutex_trylock(&ice_vdev->state_mutex)) {
> +		spin_unlock(&ice_vdev->reset_lock);
> +		return;
> +	}
> +	spin_unlock(&ice_vdev->reset_lock);
> +	ice_vfio_pci_state_mutex_unlock(ice_vdev);
> +}
> +
> +/**
> + * ice_vfio_pci_open_device - Called when a vfio device is probed by VFIO UAPI
> + * @core_vdev: the vfio device to open
> + *
> + * Initialization of the vfio device
> + *
> + * Returns 0 on success, negative value on error
> + */
> +static int ice_vfio_pci_open_device(struct vfio_device *core_vdev)
> +{
> +	struct ice_vfio_pci_core_device *ice_vdev = container_of(core_vdev,
> +			struct ice_vfio_pci_core_device, core_device.vdev);
> +	struct vfio_pci_core_device *vdev = &ice_vdev->core_device;
> +	int ret;
> +
> +	ret = vfio_pci_core_enable(vdev);
> +	if (ret)
> +		return ret;
> +
> +	ret = ice_vfio_migration_init(ice_vdev);
> +	if (ret) {
> +		vfio_pci_core_disable(vdev);
> +		return ret;
> +	}
> +	ice_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
> +	vfio_pci_core_finish_enable(vdev);
> +
> +	return 0;
> +}
> +
> +/**
> + * ice_vfio_pci_close_device - Called when a vfio device fd is closed
> + * @core_vdev: the vfio device to close
> + */
> +static void ice_vfio_pci_close_device(struct vfio_device *core_vdev)
> +{
> +	struct ice_vfio_pci_core_device *ice_vdev = container_of(core_vdev,
> +			struct ice_vfio_pci_core_device, core_device.vdev);
> +
> +	ice_vfio_pci_disable_fds(ice_vdev);
> +	vfio_pci_core_close_device(core_vdev);
> +	ice_vfio_migration_uninit(ice_vdev);
> +}
> +
> +/**
> + * ice_vfio_pci_release_file - release ice vfio pci migration file
> + * @inode: pointer to inode
> + * @filp: pointer to the file to release
> + *
> + * Return 0 for success, negative for error
> + */
> +static int ice_vfio_pci_release_file(struct inode *inode, struct file *filp)
> +{
> +	struct ice_vfio_pci_migration_file *migf = filp->private_data;
> +
> +	ice_vfio_pci_disable_fd(migf);
> +	mutex_destroy(&migf->lock);
> +	kfree(migf);
> +	return 0;
> +}
> +
> +/**
> + * ice_vfio_pci_save_read - save migration file data to user space
> + * @filp: pointer to migration file
> + * @buf: pointer to user space buffer
> + * @len: data length to be saved
> + * @pos: should be 0
> + *
> + * Return len of saved data, negative for error
> + */
> +static ssize_t ice_vfio_pci_save_read(struct file *filp, char __user *buf,
> +				      size_t len, loff_t *pos)
> +{
> +	struct ice_vfio_pci_migration_file *migf = filp->private_data;
> +	loff_t *off = &filp->f_pos;
> +	ssize_t done = 0;
> +	int ret;
> +
> +	if (pos)
> +		return -ESPIPE;
> +
> +	mutex_lock(&migf->lock);
> +	if (*off > migf->total_length) {
> +		done = -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	if (migf->disabled) {
> +		done = -ENODEV;
> +		goto out_unlock;
> +	}
> +
> +	len = min_t(size_t, migf->total_length - *off, len);
> +	if (len) {
> +		ret = copy_to_user(buf, migf->mig_data + *off, len);
> +		if (ret) {
> +			done = -EFAULT;
> +			goto out_unlock;
> +		}
> +		*off += len;
> +		done = len;
> +	}
> +out_unlock:
> +	mutex_unlock(&migf->lock);
> +	return done;
> +}
> +
> +static const struct file_operations ice_vfio_pci_save_fops = {
> +	.owner = THIS_MODULE,
> +	.read = ice_vfio_pci_save_read,
> +	.release = ice_vfio_pci_release_file,
> +	.llseek = no_llseek,
> +};
> +
> +/**
> + * ice_vfio_pci_stop_copy - create migration file and save migration state to it
> + * @ice_vdev: pointer to ice vfio pci core device structure
> + *
> + * Return migration file handler
> + */
> +static struct ice_vfio_pci_migration_file *
> +ice_vfio_pci_stop_copy(struct ice_vfio_pci_core_device *ice_vdev)
> +{
> +	struct ice_vfio_pci_migration_file *migf;
> +	int ret;
> +
> +	migf = kzalloc(sizeof(*migf), GFP_KERNEL);
> +	if (!migf)
> +		return ERR_PTR(-ENOMEM);
> +
> +	migf->filp = anon_inode_getfile("ice_vfio_pci_mig",
> +					&ice_vfio_pci_save_fops, migf,
> +					O_RDONLY);
> +	if (IS_ERR(migf->filp)) {
> +		int err = PTR_ERR(migf->filp);
> +
> +		kfree(migf);
> +		return ERR_PTR(err);
> +	}
> +
> +	stream_open(migf->filp->f_inode, migf->filp);
> +	mutex_init(&migf->lock);
> +
> +	ret = ice_vfio_pci_save_state(ice_vdev, migf);
> +	if (ret) {
> +		fput(migf->filp);
> +		kfree(migf);
> +		return ERR_PTR(ret);
> +	}
> +
> +	return migf;
> +}
> +
> +/**
> + * ice_vfio_pci_resume_write- copy migration file data from user space
> + * @filp: pointer to migration file
> + * @buf: pointer to user space buffer
> + * @len: data length to be copied
> + * @pos: should be 0
> + *
> + * Return len of saved data, negative for error
> + */
> +static ssize_t
> +ice_vfio_pci_resume_write(struct file *filp, const char __user *buf,
> +			  size_t len, loff_t *pos)
> +{
> +	struct ice_vfio_pci_migration_file *migf = filp->private_data;
> +	loff_t *off = &filp->f_pos;
> +	loff_t requested_length;
> +	ssize_t done = 0;
> +	int ret;
> +
> +	if (pos)
> +		return -ESPIPE;
> +
> +	if (*off < 0 ||
> +	    check_add_overflow((loff_t)len, *off, &requested_length))
> +		return -EINVAL;
> +
> +	if (requested_length > sizeof(migf->mig_data))
> +		return -ENOMEM;
> +
> +	mutex_lock(&migf->lock);
> +	if (migf->disabled) {
> +		done = -ENODEV;
> +		goto out_unlock;
> +	}
> +
> +	ret = copy_from_user(migf->mig_data + *off, buf, len);
> +	if (ret) {
> +		done = -EFAULT;
> +		goto out_unlock;
> +	}
> +	*off += len;
> +	done = len;
> +	migf->total_length += len;
> +out_unlock:
> +	mutex_unlock(&migf->lock);
> +	return done;
> +}
> +
> +static const struct file_operations ice_vfio_pci_resume_fops = {
> +	.owner = THIS_MODULE,
> +	.write = ice_vfio_pci_resume_write,
> +	.release = ice_vfio_pci_release_file,
> +	.llseek = no_llseek,
> +};
> +
> +/**
> + * ice_vfio_pci_resume - create resuming migration file
> + * @ice_vdev: pointer to ice vfio pci core device structure
> + *
> + * Return migration file handler, negative value for failure
> + */
> +static struct ice_vfio_pci_migration_file *
> +ice_vfio_pci_resume(struct ice_vfio_pci_core_device *ice_vdev)
> +{
> +	struct ice_vfio_pci_migration_file *migf;
> +
> +	migf = kzalloc(sizeof(*migf), GFP_KERNEL);
> +	if (!migf)
> +		return ERR_PTR(-ENOMEM);
> +
> +	migf->filp = anon_inode_getfile("ice_vfio_pci_mig",
> +					&ice_vfio_pci_resume_fops, migf,
> +					O_WRONLY);
> +	if (IS_ERR(migf->filp)) {
> +		int err = PTR_ERR(migf->filp);
> +
> +		kfree(migf);
> +		return ERR_PTR(err);
> +	}
> +
> +	stream_open(migf->filp->f_inode, migf->filp);
> +	mutex_init(&migf->lock);
> +	return migf;
> +}
> +
> +/**
> + * ice_vfio_pci_step_device_state_locked - process device state change
> + * @ice_vdev: pointer to ice vfio pci core device structure
> + * @new: new device state
> + * @final: final device state
> + *
> + * Return migration file handler or NULL for success, negative value for failure
> + */
> +static struct file *
> +ice_vfio_pci_step_device_state_locked(struct ice_vfio_pci_core_device *ice_vdev,
> +				      u32 new, u32 final)
> +{
> +	u32 cur = ice_vdev->mig_state;
> +	int ret;
> +
> +	if (cur == VFIO_DEVICE_STATE_RUNNING &&
> +	    new == VFIO_DEVICE_STATE_RUNNING_P2P) {
> +		ice_migration_suspend_dev(ice_vdev->pf, ice_vdev->vf_id);
> +		return NULL;
> +	}
> +
> +	if (cur == VFIO_DEVICE_STATE_RUNNING_P2P &&
> +	    new == VFIO_DEVICE_STATE_STOP)
> +		return NULL;

This looks suspicious, are we actually able to freeze the internal
device state?  It should happen here.

 * RUNNING_P2P -> STOP
 * STOP_COPY -> STOP
 *   While in STOP the device must stop the operation of the device. The device
 *   must not generate interrupts, DMA, or any other change to external state.
 *   It must not change its internal state. When stopped the device and kernel
 *   migration driver must accept and respond to interaction to support external
 *   subsystems in the STOP state, for example PCI MSI-X and PCI config space.
 *   Failure by the user to restrict device access while in STOP must not result
 *   in error conditions outside the user context (ex. host system faults).
 *
 *   The STOP_COPY arc will terminate a data transfer session.

> +
> +	if (cur == VFIO_DEVICE_STATE_STOP &&
> +	    new == VFIO_DEVICE_STATE_STOP_COPY) {
> +		struct ice_vfio_pci_migration_file *migf;
> +
> +		migf = ice_vfio_pci_stop_copy(ice_vdev);
> +		if (IS_ERR(migf))
> +			return ERR_CAST(migf);
> +		get_file(migf->filp);
> +		ice_vdev->saving_migf = migf;
> +		return migf->filp;
> +	}
> +
> +	if (cur == VFIO_DEVICE_STATE_STOP_COPY &&
> +	    new == VFIO_DEVICE_STATE_STOP) {
> +		ice_vfio_pci_disable_fds(ice_vdev);
> +		return NULL;
> +	}
> +
> +	if (cur == VFIO_DEVICE_STATE_STOP &&
> +	    new == VFIO_DEVICE_STATE_RESUMING) {
> +		struct ice_vfio_pci_migration_file *migf;
> +
> +		migf = ice_vfio_pci_resume(ice_vdev);
> +		if (IS_ERR(migf))
> +			return ERR_CAST(migf);
> +		get_file(migf->filp);
> +		ice_vdev->resuming_migf = migf;
> +		return migf->filp;
> +	}
> +
> +	if (cur == VFIO_DEVICE_STATE_RESUMING && new == VFIO_DEVICE_STATE_STOP)
> +		return NULL;

 * RESUMING -> STOP
 *   Leaving RESUMING terminates a data transfer session and indicates the
 *   device should complete processing of the data delivered by write(). The
 *   kernel migration driver should complete the incorporation of data written
 *   to the data transfer FD into the device internal state and perform
 *   final validity and consistency checking of the new device state. If the
 *   user provided data is found to be incomplete, inconsistent, or otherwise
 *   invalid, the migration driver must fail the SET_STATE ioctl and
 *   optionally go to the ERROR state as described below.

> +
> +	if (cur == VFIO_DEVICE_STATE_STOP &&
> +	    new == VFIO_DEVICE_STATE_RUNNING_P2P) {
> +		ret = ice_vfio_pci_load_state(ice_vdev);
> +		if (ret)
> +			return ERR_PTR(ret);
> +		ice_vfio_pci_disable_fds(ice_vdev);

STOP is not a state that should have active migration fds, RESUMING ->
STOP above is, which is also where we'd expect to see the state loaded.
This again makes it suspicious whether the device actually supports
stopping and resuming internal state changes.

> +		return NULL;
> +	}
> +
> +	if (cur == VFIO_DEVICE_STATE_RUNNING_P2P &&
> +	    new == VFIO_DEVICE_STATE_RUNNING)
> +		return NULL;
> +
> +	/*
> +	 * vfio_mig_get_next_state() does not use arcs other than the above
> +	 */
> +	WARN_ON(true);
> +	return ERR_PTR(-EINVAL);
> +}
> +
> +/**
> + * ice_vfio_pci_set_device_state - Config device state
> + * @vdev: pointer to vfio pci device
> + * @new_state: device state
> + *
> + * Return 0 for success, negative value for failure.

Inaccurate description of return value.

> + */
> +static struct file *
> +ice_vfio_pci_set_device_state(struct vfio_device *vdev,
> +			      enum vfio_device_mig_state new_state)
> +{
> +	struct ice_vfio_pci_core_device *ice_vdev =
> +			container_of(vdev,
> +				     struct ice_vfio_pci_core_device,
> +				     core_device.vdev);
> +	enum vfio_device_mig_state next_state;
> +	struct file *res = NULL;
> +	int ret;
> +
> +	mutex_lock(&ice_vdev->state_mutex);
> +	while (new_state != ice_vdev->mig_state) {
> +		ret = vfio_mig_get_next_state(vdev, ice_vdev->mig_state,
> +					      new_state, &next_state);
> +		if (ret) {
> +			res = ERR_PTR(ret);
> +			break;
> +		}
> +		res = ice_vfio_pci_step_device_state_locked(ice_vdev,
> +							    next_state,
> +							    new_state);
> +		if (IS_ERR(res))
> +			break;
> +		ice_vdev->mig_state = next_state;
> +		if (WARN_ON(res && new_state != ice_vdev->mig_state)) {
> +			fput(res);
> +			res = ERR_PTR(-EINVAL);
> +			break;
> +		}
> +	}
> +	ice_vfio_pci_state_mutex_unlock(ice_vdev);
> +	return res;
> +}
> +
> +/**
> + * ice_vfio_pci_get_device_state - get device state
> + * @vdev: pointer to vfio pci device
> + * @curr_state: device state
> + *
> + * Return 0 for success
> + */
> +static int ice_vfio_pci_get_device_state(struct vfio_device *vdev,
> +					 enum vfio_device_mig_state *curr_state)
> +{
> +	struct ice_vfio_pci_core_device *ice_vdev =
> +			container_of(vdev,
> +				     struct ice_vfio_pci_core_device,
> +				     core_device.vdev);

Blank line after variable declaration.

> +	mutex_lock(&ice_vdev->state_mutex);
> +	*curr_state = ice_vdev->mig_state;
> +	ice_vfio_pci_state_mutex_unlock(ice_vdev);
> +	return 0;
> +}
> +
> +/**
> + * ice_vfio_pci_get_data_size - get migration data size
> + * @vdev: pointer to vfio pci device
> + * @stop_copy_length: migration data size
> + *
> + * Return 0 for success
> + */
> +static int
> +ice_vfio_pci_get_data_size(struct vfio_device *vdev,
> +			   unsigned long *stop_copy_length)
> +{
> +	*stop_copy_length = SZ_128K;
> +	return 0;
> +}
> +
> +static const struct vfio_migration_ops ice_vfio_pci_migrn_state_ops = {
> +	.migration_set_state = ice_vfio_pci_set_device_state,
> +	.migration_get_state = ice_vfio_pci_get_device_state,
> +	.migration_get_data_size = ice_vfio_pci_get_data_size,
> +};
> +
> +/**
> + * ice_vfio_pci_core_init_dev - initialize vfio device
> + * @core_vdev: pointer to vfio device
> + *
> + * Return 0 for success
> + */
> +static int ice_vfio_pci_core_init_dev(struct vfio_device *core_vdev)
> +{
> +	struct ice_vfio_pci_core_device *ice_vdev = container_of(core_vdev,
> +			struct ice_vfio_pci_core_device, core_device.vdev);
> +
> +	mutex_init(&ice_vdev->state_mutex);
> +	spin_lock_init(&ice_vdev->reset_lock);
> +
> +	core_vdev->migration_flags =
> +		VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P;
> +	core_vdev->mig_ops = &ice_vfio_pci_migrn_state_ops;
> +
> +	return vfio_pci_core_init_dev(core_vdev);
> +}
> +
> +static const struct vfio_device_ops ice_vfio_pci_ops = {
> +	.name		= "ice-vfio-pci",
> +	.init		= ice_vfio_pci_core_init_dev,
> +	.release	= vfio_pci_core_release_dev,

Looks like the release callback should at least cleanup the locks for
lockdep rather than use the core function directly.

> +	.open_device	= ice_vfio_pci_open_device,
> +	.close_device	= ice_vfio_pci_close_device,
> +	.device_feature = vfio_pci_core_ioctl_feature,
> +	.read		= vfio_pci_core_read,
> +	.write		= vfio_pci_core_write,
> +	.ioctl		= vfio_pci_core_ioctl,
> +	.mmap		= vfio_pci_core_mmap,
> +	.request	= vfio_pci_core_request,
> +	.match		= vfio_pci_core_match,
> +	.bind_iommufd	= vfio_iommufd_physical_bind,
> +	.unbind_iommufd	= vfio_iommufd_physical_unbind,
> +	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
> +	.detach_ioas	= vfio_iommufd_physical_detach_ioas,
> +};
> +
> +/**
> + * ice_vfio_pci_probe - Device initialization routine
> + * @pdev: PCI device information struct
> + * @id: entry in ice_vfio_pci_table
> + *
> + * Returns 0 on success, negative on failure
> + */
> +static int
> +ice_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> +{
> +	struct ice_vfio_pci_core_device *ice_vdev;
> +	int ret;
> +
> +	ice_vdev = vfio_alloc_device(ice_vfio_pci_core_device, core_device.vdev,
> +				     &pdev->dev, &ice_vfio_pci_ops);
> +	if (!ice_vdev)

Needs to test IS_ERR(ice_vdev).  Thanks,

Alex

> +		return -ENOMEM;
> +
> +	dev_set_drvdata(&pdev->dev, &ice_vdev->core_device);
> +
> +	ret = vfio_pci_core_register_device(&ice_vdev->core_device);
> +	if (ret)
> +		goto out_free;
> +
> +	return 0;
> +
> +out_free:
> +	vfio_put_device(&ice_vdev->core_device.vdev);
> +	return ret;
> +}
> +
> +/**
> + * ice_vfio_pci_remove - Device removal routine
> + * @pdev: PCI device information struct
> + */
> +static void ice_vfio_pci_remove(struct pci_dev *pdev)
> +{
> +	struct ice_vfio_pci_core_device *ice_vdev =
> +		(struct ice_vfio_pci_core_device *)dev_get_drvdata(&pdev->dev);
> +
> +	vfio_pci_core_unregister_device(&ice_vdev->core_device);
> +	vfio_put_device(&ice_vdev->core_device.vdev);
> +}
> +
> +/* ice_pci_tbl - PCI Device ID Table
> + *
> + * Wildcard entries (PCI_ANY_ID) should come last
> + * Last entry must be all 0s
> + *
> + * { Vendor ID, Device ID, SubVendor ID, SubDevice ID,
> + *   Class, Class Mask, private data (not used) }
> + */
> +static const struct pci_device_id ice_vfio_pci_table[] = {
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_INTEL, 0x1889) },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(pci, ice_vfio_pci_table);
> +
> +static const struct pci_error_handlers ice_vfio_pci_core_err_handlers = {
> +	.reset_done = ice_vfio_pci_reset_done,
> +	.error_detected = vfio_pci_core_aer_err_detected,
> +};
> +
> +static struct pci_driver ice_vfio_pci_driver = {
> +	.name			= "ice-vfio-pci",
> +	.id_table		= ice_vfio_pci_table,
> +	.probe			= ice_vfio_pci_probe,
> +	.remove			= ice_vfio_pci_remove,
> +	.err_handler            = &ice_vfio_pci_core_err_handlers,
> +	.driver_managed_dma	= true,
> +};
> +
> +module_pci_driver(ice_vfio_pci_driver);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Intel Corporation, <linux.nics@intel.com>");
> +MODULE_DESCRIPTION(DRIVER_DESC);


