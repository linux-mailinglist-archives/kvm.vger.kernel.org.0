Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A66DE7B73E8
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 00:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232460AbjJCWFi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 18:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232380AbjJCWFg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 18:05:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20BEA1
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 15:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696370687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YG0Ff209K8tBezsmGVW7mmQW2vYaTZoJEwZtTz6xHu8=;
        b=ExJ/bO4C5qpWCRtP8Ib3EXQVNgwUWUrmOJaGJ0pZwE4hhFT6d7H5wZRyCE8HTj6NpKPVvE
        S92Vw2AWx4vAxCTJS2Z0qKi89pjF5KtmpgyRjm/N4TghwW6bb1e6zjH/jbwC7itRvOmkjZ
        MM6FqvjiF9/QeanUz+LB4EyqD9tFfpo=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-372-Lg35o3XiMzigs0XGOPzGDQ-1; Tue, 03 Oct 2023 18:04:30 -0400
X-MC-Unique: Lg35o3XiMzigs0XGOPzGDQ-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-79fb08d781fso94201939f.0
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 15:04:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696370665; x=1696975465;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YG0Ff209K8tBezsmGVW7mmQW2vYaTZoJEwZtTz6xHu8=;
        b=jALNe4h/lUx9PgEa3pca5mCWLhB3IWqFjczsgjefCqGwvQMf+gxNr8lBjSCnjzWngc
         BEQ2PSvsLLvFXMef2ot6EW17yVoMw19HfkT0Xgqjq3qdWeqLasPVhgrNYttGjBuqw26k
         ztojw3bdhRv0JEsTvQBWaPuVEE5l3JGlC/f1ktMBrwzhbowYJDdIR/SkvwubSwc6L1YJ
         m1uutSrry934hAhRpKrqonOzjQz7eotKN1VXxcte9WeueGfrly0aKViGCSRCBN42ajGo
         LjT3bjOqjV3LAmqi4VsAaH0SxTtoBvnDwoJpPK+g5plg96Zd/xSQq1EG9fL3Fk84VSou
         ytHA==
X-Gm-Message-State: AOJu0YyJqrWhpg8UQiDo+8ySN+QVU5YEEgHqXd1I9awFA0GJfoIc2BFu
        jjAHyfTSNnjBLO88nkSgt8NdNNf5ZbWF/VtBq8M9klWlI/hTppjRikZey/IjzrmtkZVv/F+klCX
        TUsJzo7ZKm33m
X-Received: by 2002:a5e:924d:0:b0:79f:a0e9:b8c3 with SMTP id z13-20020a5e924d000000b0079fa0e9b8c3mr705450iop.20.1696370664898;
        Tue, 03 Oct 2023 15:04:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHMyGWxWy7hDsKIDQQS+hKLO2UtobZ7xePKcVvyIyYIJhrZakEEp9EZVTfTIEo2Ro1GtFcmKg==
X-Received: by 2002:a5e:924d:0:b0:79f:a0e9:b8c3 with SMTP id z13-20020a5e924d000000b0079fa0e9b8c3mr705434iop.20.1696370664556;
        Tue, 03 Oct 2023 15:04:24 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id x7-20020a02ac87000000b0042b2f0b77aasm591115jan.95.2023.10.03.15.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 15:04:23 -0700 (PDT)
Date:   Tue, 3 Oct 2023 16:04:21 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yahui Cao <yahui.cao@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, lingyu.liu@intel.com, kevin.tian@intel.com,
        madhu.chittim@intel.com, sridhar.samudrala@intel.com,
        jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, brett.creeley@amd.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com
Subject: Re: [PATCH iwl-next v3 13/13] vfio/ice: Implement vfio_pci driver
 for E800 devices
Message-ID: <20231003160421.54c57ceb.alex.williamson@redhat.com>
In-Reply-To: <20230918062546.40419-14-yahui.cao@intel.com>
References: <20230918062546.40419-1-yahui.cao@intel.com>
        <20230918062546.40419-14-yahui.cao@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 18 Sep 2023 06:25:46 +0000
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

The prerequisite ice core driver support (ie. patches 1-12) should be
supplied as a branch to allow this variant driver to be merged through
the vfio tree.


> diff --git a/MAINTAINERS b/MAINTAINERS
> index 389fe9e38884..09ea8454219a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22608,6 +22608,13 @@ L:	kvm@vger.kernel.org
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
> index 000000000000..4c6f348d3062
> --- /dev/null
> +++ b/drivers/vfio/pci/ice/Kconfig
> @@ -0,0 +1,10 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +config ICE_VFIO_PCI
> +	tristate "VFIO support for Intel(R) Ethernet Connection E800 Series"
> +	depends on ICE
> +	depends on VFIO_PCI_CORE

s/depends on/select/

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
> index 000000000000..60a0582d7932
> --- /dev/null
> +++ b/drivers/vfio/pci/ice/ice_vfio_pci.c

Suggest renaming this to main.c

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
> +	struct mutex state_mutex; /* protect migration state */
> +	enum vfio_device_mig_state mig_state;
> +	/* protect the reset_done flow */
> +	spinlock_t reset_lock;
> +	struct ice_vfio_pci_migration_file *resuming_migf;
> +	struct ice_vfio_pci_migration_file *saving_migf;
> +	struct vfio_device_migration_info mig_info;
> +	u8 *mig_data;
> +	u8 __iomem *io_base;
> +	struct ice_pf *pf;
> +	int vf_id;
> +};
> +
> +/**
> + * ice_vfio_pci_load_state - VFIO device state reloading
> + * @ice_vdev: pointer to ice vfio pci core device structure
> + *
> + * Load device state and restore it. This function is called when the VFIO uAPI
> + * consumer wants to load the device state info from VFIO migration region and
> + * restore them into the device. This function should make sure all the device
> + * state info is loaded and restored successfully. As a result, return value is
> + * mandatory to be checked.
> + *
> + * Return 0 for success, negative value for failure.
> + */

Kudos on the kernel-doc comments throughout, nice!

This appears to be a substantial improvement from the comments I see
on v2, I'm curious where Kevin and Jason stand on this now.  Thanks,

Alex

> +static int __must_check
> +ice_vfio_pci_load_state(struct ice_vfio_pci_core_device *ice_vdev)
> +{
> +	struct ice_vfio_pci_migration_file *migf = ice_vdev->resuming_migf;
> +
> +	return ice_migration_restore_devstate(ice_vdev->pf,
> +					      ice_vdev->vf_id,
> +					      migf->mig_data,
> +					      SZ_128K);
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
> +					   SZ_128K);
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
> +	int ret = 0;
> +
> +	ice_vdev->pf = ice_migration_get_pf(pdev);
> +	if (!ice_vdev->pf)
> +		return -EFAULT;
> +
> +	ice_vdev->vf_id = pci_iov_vf_id(pdev);
> +	if (ice_vdev->vf_id < 0)
> +		return -EINVAL;
> +
> +	ret = ice_migration_init_dev(ice_vdev->pf, ice_vdev->vf_id);
> +	if (ret)
> +		return ret;
> +
> +	ice_vdev->io_base = (u8 __iomem *)pci_iomap(pdev, 0, 0);
> +	if (!ice_vdev->io_base)
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +/**
> + * ice_vfio_migration_uninit - Cleanup for live migration function
> + * @ice_vdev: pointer to ice vfio pci core device structure
> + */
> +static void ice_vfio_migration_uninit(struct ice_vfio_pci_core_device *ice_vdev)
> +{
> +	pci_iounmap(ice_vdev->core_device.pdev, ice_vdev->io_base);
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
> +	if (cur == VFIO_DEVICE_STATE_RUNNING && new == VFIO_DEVICE_STATE_RUNNING_P2P) {
> +		ice_migration_suspend_dev(ice_vdev->pf, ice_vdev->vf_id);
> +		return NULL;
> +	}
> +
> +	if (cur == VFIO_DEVICE_STATE_RUNNING_P2P && new == VFIO_DEVICE_STATE_STOP)
> +		return NULL;
> +
> +	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_STOP_COPY) {
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
> +	if (cur == VFIO_DEVICE_STATE_STOP_COPY && new == VFIO_DEVICE_STATE_STOP) {
> +		ice_vfio_pci_disable_fds(ice_vdev);
> +		return NULL;
> +	}
> +
> +	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_RESUMING) {
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
> +
> +	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_RUNNING_P2P) {
> +		ret = ice_vfio_pci_load_state(ice_vdev);
> +		if (ret)
> +			return ERR_PTR(ret);
> +		ice_vfio_pci_disable_fds(ice_vdev);
> +		return NULL;
> +	}
> +
> +	if (cur == VFIO_DEVICE_STATE_RUNNING_P2P && new == VFIO_DEVICE_STATE_RUNNING)
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
> + */
> +static struct file *
> +ice_vfio_pci_set_device_state(struct vfio_device *vdev,
> +			      enum vfio_device_mig_state new_state)
> +{
> +	struct ice_vfio_pci_core_device *ice_vdev = container_of(vdev,
> +								 struct ice_vfio_pci_core_device,
> +								 core_device.vdev);
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
> +		res = ice_vfio_pci_step_device_state_locked(ice_vdev, next_state,
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
> +		container_of(vdev, struct ice_vfio_pci_core_device, core_device.vdev);
> +
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
> +	core_vdev->migration_flags = VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P;
> +	core_vdev->mig_ops = &ice_vfio_pci_migrn_state_ops;
> +
> +	return vfio_pci_core_init_dev(core_vdev);
> +}
> +
> +static const struct vfio_device_ops ice_vfio_pci_ops = {
> +	.name		= "ice-vfio-pci",
> +	.init		= ice_vfio_pci_core_init_dev,
> +	.release	= vfio_pci_core_release_dev,
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

