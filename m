Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81674763FD9
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 21:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbjGZTi3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 15:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjGZTiT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 15:38:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DFF1BE3
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 12:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690400250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xCZ4b6Vub8LugWoFvo9pw2CaH7zo38gmItiKMFWRby4=;
        b=e1wamuN/3lQIVudOaG7y8ogf1ZA4vN2kOaZpi9GnwsalWviTAXnpeaUkNG5uqqxi/2PwV7
        uT2Z/FFm7+mA9054rUT+s/GPd/k94TNvKeXf2P+7ILEu8gIlMqLJiBG9T4RidsgDBoeQij
        EgfZix7dlvzkjGSA3oL4R2v4lhlBpiw=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-eC7cKLjnO4-tu0J7IogtaQ-1; Wed, 26 Jul 2023 15:37:29 -0400
X-MC-Unique: eC7cKLjnO4-tu0J7IogtaQ-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3463fbf2ffeso541095ab.2
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 12:37:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690400248; x=1691005048;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xCZ4b6Vub8LugWoFvo9pw2CaH7zo38gmItiKMFWRby4=;
        b=lsB/9pjsHP7m2eBMUI/tPu3ZB59huCNu52WYrynXRiQHcaYVW4o5e27lLUOryMDHPx
         ZXZ5iqmLnn44gIaMpCfbYyWqv/UgKdvAmrAeIHBr2VWsVA6ugefTw52AH38wxYai5ApT
         rwsQlZ9WRvNBCK1Olt1EsTxFzFP7y4+GSZW7qNJQqt5gC2KDc7pcww5O3fTOwL+OS5L0
         Z7n+13F0s5YsX+UH8Ro+95t2eMNF5dyylndU3OezGa5zQE3+UVb/wESsUXbnrPrywFSy
         hqi8p+3/Hu570mk2qC+33si3DJY+/BogKrqoEwP3KuKZwuD3z2aD9aqa2AgJz8GoJGVF
         /qWA==
X-Gm-Message-State: ABy/qLbYRQKYPhT0zsbItV1XINIpvoB525MOZgfzpRqqY2Bh/gIgF3jn
        UCdHQfDE9iaEuClz60ocKBzNHQfOL2pxjpR96Tel92h9pqxe7wRKDVWfLCBMcfFyg8qgfEYRACj
        xN5m3Zoqbolu3
X-Received: by 2002:a05:6e02:1aa7:b0:348:d52a:8f8 with SMTP id l7-20020a056e021aa700b00348d52a08f8mr3542230ilv.25.1690400248190;
        Wed, 26 Jul 2023 12:37:28 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGOLQoFCf3j2FW671lUu5W13tiiWmuRE4IYy/RuwNInzW2K82wOSzmZiJnff0g6ntEcMcyKgw==
X-Received: by 2002:a05:6e02:1aa7:b0:348:d52a:8f8 with SMTP id l7-20020a056e021aa700b00348d52a08f8mr3542217ilv.25.1690400247885;
        Wed, 26 Jul 2023 12:37:27 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id a3-20020a92c703000000b00348c6dc6d87sm3077124ilp.73.2023.07.26.12.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 12:37:27 -0700 (PDT)
Date:   Wed, 26 Jul 2023 13:37:26 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Xin Zeng <xin.zeng@intel.com>
Cc:     linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        giovanni.cabiddu@intel.com, andriy.shevchenko@linux.intel.com,
        Yahui Cao <yahui.cao@intel.com>, jgg@nvidia.com,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        kevin.tian@intel.com
Subject: Re: [RFC 5/5] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Message-ID: <20230726133726.7e2cf1e8.alex.williamson@redhat.com>
In-Reply-To: <20230630131304.64243-6-xin.zeng@intel.com>
References: <20230630131304.64243-1-xin.zeng@intel.com>
        <20230630131304.64243-6-xin.zeng@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Please Cc the vfio-pci variant driver reviewers listed in MAINTAINERS.
Also useful to put the subsystem maintainer on the cc rather than just
the list.

On Fri, 30 Jun 2023 21:13:04 +0800
Xin Zeng <xin.zeng@intel.com> wrote:

> Add vfio pci driver for Intel QAT VF devices.
> 
> This driver uses vfio_pci_core to register to the VFIO subsystem. It
> acts as a vfio agent and interacts with the QAT PF driver to implement
> VF live migration.
> 
> Co-developed-by: Yahui Cao <yahui.cao@intel.com>
> Signed-off-by: Yahui Cao <yahui.cao@intel.com>
> Signed-off-by: Xin Zeng <xin.zeng@intel.com>
> ---
>  drivers/vfio/pci/Kconfig                 |   2 +
>  drivers/vfio/pci/Makefile                |   1 +
>  drivers/vfio/pci/qat/Kconfig             |  13 +
>  drivers/vfio/pci/qat/Makefile            |   4 +
>  drivers/vfio/pci/qat/qat_vfio_pci_main.c | 518 +++++++++++++++++++++++

Rename to main.c.

>  5 files changed, 538 insertions(+)
>  create mode 100644 drivers/vfio/pci/qat/Kconfig
>  create mode 100644 drivers/vfio/pci/qat/Makefile
>  create mode 100644 drivers/vfio/pci/qat/qat_vfio_pci_main.c
> 
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index f9d0c908e738..47c9773cf0c7 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -59,4 +59,6 @@ source "drivers/vfio/pci/mlx5/Kconfig"
>  
>  source "drivers/vfio/pci/hisilicon/Kconfig"
>  
> +source "drivers/vfio/pci/qat/Kconfig"
> +
>  endif
> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> index 24c524224da5..dcc6366df8fa 100644
> --- a/drivers/vfio/pci/Makefile
> +++ b/drivers/vfio/pci/Makefile
> @@ -11,3 +11,4 @@ obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
>  obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
>  
>  obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
> +obj-$(CONFIG_QAT_VFIO_PCI) += qat/
> diff --git a/drivers/vfio/pci/qat/Kconfig b/drivers/vfio/pci/qat/Kconfig
> new file mode 100644
> index 000000000000..38e5b4a0ca9c
> --- /dev/null
> +++ b/drivers/vfio/pci/qat/Kconfig
> @@ -0,0 +1,13 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +config QAT_VFIO_PCI
> +	tristate "VFIO support for QAT VF PCI devices"
> +	depends on X86

What specific X86 dependency exists here?  CRYPTO_DEV_QAT and the
various versions of the QAT driver don't seem to have an explicit arch
dependency, therefore this shouldn't either.

> +	depends on VFIO_PCI_CORE

select VFIO_PCI_CORE, this was updated for all vfio-pci variant drivers
for v6.5.

> +	depends on CRYPTO_DEV_QAT
> +	help
> +	  This provides migration support for Intel(R) QAT Virtual Function
> +	  using the VFIO framework.
> +
> +	  To compile this as a module, choose M here: the module
> +	  will be called qat_vfio_pci. If you don't know what to do here,
> +	  say N.
> diff --git a/drivers/vfio/pci/qat/Makefile b/drivers/vfio/pci/qat/Makefile
> new file mode 100644
> index 000000000000..106791887b91
> --- /dev/null
> +++ b/drivers/vfio/pci/qat/Makefile
> @@ -0,0 +1,4 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +obj-$(CONFIG_QAT_VFIO_PCI) += qat_vfio_pci.o
> +qat_vfio_pci-y := qat_vfio_pci_main.o
> +
> diff --git a/drivers/vfio/pci/qat/qat_vfio_pci_main.c b/drivers/vfio/pci/qat/qat_vfio_pci_main.c
> new file mode 100644
> index 000000000000..af971fd05fd2
> --- /dev/null
> +++ b/drivers/vfio/pci/qat/qat_vfio_pci_main.c
> @@ -0,0 +1,518 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright(c) 2023 Intel Corporation */
> +#include <linux/anon_inodes.h>
> +#include <linux/container_of.h>
> +#include <linux/device.h>
> +#include <linux/file.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/pci.h>
> +#include <linux/sizes.h>
> +#include <linux/types.h>
> +#include <linux/uaccess.h>
> +#include <linux/vfio_pci_core.h>
> +#include <linux/qat/qat_vf_mig.h>
> +
> +struct qat_vf_mig_data {
> +	u8 state[SZ_4K];
> +};
> +
> +struct qat_vf_migration_file {
> +	struct file *filp;
> +	struct mutex lock; /* protect migration region context */
> +	bool disabled;
> +
> +	size_t total_length;
> +	struct qat_vf_mig_data mig_data;
> +};
> +
> +struct qat_vf_core_device {
> +	struct vfio_pci_core_device core_device;
> +	struct pci_dev *parent;
> +	int vf_id;
> +
> +	struct mutex state_mutex; /* protect migration state */
> +	enum vfio_device_mig_state mig_state;
> +	struct qat_vf_migration_file *resuming_migf;
> +	struct qat_vf_migration_file *saving_migf;
> +};
> +
> +static int qat_vf_init(struct qat_vf_core_device *qat_vdev)
> +{
> +	return qat_vfmig_init_device(qat_vdev->parent, qat_vdev->vf_id);
> +}
> +
> +static void qat_vf_cleanup(struct qat_vf_core_device *qat_vdev)
> +{
> +	qat_vfmig_shutdown_device(qat_vdev->parent, qat_vdev->vf_id);
> +}
> +
> +static int qat_vf_pci_open_device(struct vfio_device *core_vdev)
> +{
> +	int ret;
> +	struct qat_vf_core_device *qat_vdev =
> +		container_of(core_vdev, struct qat_vf_core_device,
> +			     core_device.vdev);
> +	struct vfio_pci_core_device *vdev = &qat_vdev->core_device;
> +
> +	ret = vfio_pci_core_enable(vdev);
> +	if (ret)
> +		return ret;
> +
> +	ret = qat_vf_init(qat_vdev);
> +	if (ret) {
> +		vfio_pci_core_disable(vdev);
> +		return ret;
> +	}
> +	qat_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
> +
> +	vfio_pci_core_finish_enable(vdev);
> +
> +	return 0;
> +}
> +
> +static void qat_vf_disable_fd(struct qat_vf_migration_file *migf)
> +{
> +	mutex_lock(&migf->lock);
> +	migf->disabled = true;
> +	migf->total_length = 0;
> +	migf->filp->f_pos = 0;
> +	mutex_unlock(&migf->lock);
> +}
> +
> +static void qat_vf_disable_fds(struct qat_vf_core_device *qat_vdev)
> +{
> +	if (qat_vdev->resuming_migf) {
> +		qat_vf_disable_fd(qat_vdev->resuming_migf);
> +		fput(qat_vdev->resuming_migf->filp);
> +		qat_vdev->resuming_migf = NULL;
> +	}
> +
> +	if (qat_vdev->saving_migf) {
> +		qat_vf_disable_fd(qat_vdev->saving_migf);
> +		fput(qat_vdev->saving_migf->filp);
> +		qat_vdev->saving_migf = NULL;
> +	}
> +}
> +
> +static void qat_vf_pci_close_device(struct vfio_device *core_vdev)
> +{
> +	struct qat_vf_core_device *qat_vdev = container_of(core_vdev,
> +			struct qat_vf_core_device, core_device.vdev);
> +
> +	qat_vf_cleanup(qat_vdev);
> +	qat_vf_disable_fds(qat_vdev);
> +	vfio_pci_core_close_device(core_vdev);
> +}
> +
> +static int qat_vf_stop_device(struct qat_vf_core_device *qat_vdev)
> +{
> +	return qat_vfmig_suspend_device(qat_vdev->parent, qat_vdev->vf_id);
> +}
> +
> +static ssize_t qat_vf_save_read(struct file *filp, char __user *buf,
> +				size_t len, loff_t *pos)
> +{
> +	struct qat_vf_migration_file *migf = filp->private_data;
> +	ssize_t done = 0;
> +	loff_t *offs;
> +	int ret;
> +
> +	if (pos)
> +		return -ESPIPE;
> +	offs = &filp->f_pos;
> +
> +	mutex_lock(&migf->lock);
> +	if (*offs > migf->total_length || *offs < 0) {
> +		done = -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	if (migf->disabled) {
> +		done = -ENODEV;
> +		goto out_unlock;
> +	}
> +
> +	len = min_t(size_t, migf->total_length - *offs, len);
> +	if (len) {
> +		ret = copy_to_user(buf, &migf->mig_data + *offs, len);
> +		if (ret) {
> +			done = -EFAULT;
> +			goto out_unlock;
> +		}
> +		*offs += len;
> +		done = len;
> +	}
> +
> +out_unlock:
> +	mutex_unlock(&migf->lock);
> +	return done;
> +}
> +
> +static int qat_vf_release_file(struct inode *inode, struct file *filp)
> +{
> +	struct qat_vf_migration_file *migf = filp->private_data;
> +
> +	qat_vf_disable_fd(migf);
> +	mutex_destroy(&migf->lock);
> +	kfree(migf);
> +
> +	return 0;
> +}
> +
> +static const struct file_operations qat_vf_save_fops = {
> +	.owner = THIS_MODULE,
> +	.read = qat_vf_save_read,
> +	.release = qat_vf_release_file,
> +	.llseek = no_llseek,
> +};
> +
> +static int qat_vf_save_state(struct qat_vf_core_device *qat_vdev,
> +			     struct qat_vf_migration_file *migf)
> +{
> +	struct qat_vf_mig_data *mig_data = &migf->mig_data;
> +	int ret;
> +
> +	ret = qat_vfmig_save_state(qat_vdev->parent, qat_vdev->vf_id,
> +				   mig_data->state,
> +				   sizeof(mig_data->state));
> +	if (ret)
> +		return ret;
> +
> +	migf->total_length = sizeof(struct qat_vf_mig_data);
> +
> +	return 0;
> +}
> +
> +static struct qat_vf_migration_file *
> +qat_vf_save_device_data(struct qat_vf_core_device *qat_vdev)
> +{
> +	struct qat_vf_migration_file *migf;
> +	int ret;
> +
> +	migf = kzalloc(sizeof(*migf), GFP_KERNEL);
> +	if (!migf)
> +		return ERR_PTR(-ENOMEM);
> +
> +	migf->filp = anon_inode_getfile("qat_vf_mig", &qat_vf_save_fops,
> +					migf, O_RDONLY);
> +	ret = PTR_ERR_OR_ZERO(migf->filp);
> +	if (ret) {
> +		kfree(migf);
> +		return ERR_PTR(ret);
> +	}
> +
> +	stream_open(migf->filp->f_inode, migf->filp);
> +	mutex_init(&migf->lock);
> +
> +	ret = qat_vf_save_state(qat_vdev, migf);
> +	if (ret) {
> +		fput(migf->filp);
> +		kfree(migf);
> +		return ERR_PTR(ret);
> +	}
> +
> +	return migf;
> +}
> +
> +static ssize_t qat_vf_resume_write(struct file *filp, const char __user *buf,
> +				   size_t len, loff_t *pos)
> +{
> +	struct qat_vf_migration_file *migf = filp->private_data;
> +	loff_t requested_length;
> +	ssize_t done = 0;
> +	loff_t *offs;
> +	int ret;
> +
> +	if (pos)
> +		return -ESPIPE;
> +	offs = &filp->f_pos;
> +
> +	if (*offs < 0 ||
> +	    check_add_overflow((loff_t)len, *offs, &requested_length))
> +		return -EOVERFLOW;
> +
> +	if (requested_length > sizeof(struct qat_vf_mig_data))
> +		return -ENOMEM;
> +
> +	mutex_lock(&migf->lock);
> +	if (migf->disabled) {
> +		done = -ENODEV;
> +		goto out_unlock;
> +	}
> +
> +	ret = copy_from_user(&migf->mig_data + *offs, buf, len);
> +	if (ret) {
> +		done = -EFAULT;
> +		goto out_unlock;
> +	}
> +	*offs += len;
> +	done = len;
> +	migf->total_length += len;
> +
> +out_unlock:
> +	mutex_unlock(&migf->lock);
> +	return done;
> +}
> +
> +static const struct file_operations qat_vf_resume_fops = {
> +	.owner = THIS_MODULE,
> +	.write = qat_vf_resume_write,
> +	.release = qat_vf_release_file,
> +	.llseek = no_llseek,
> +};
> +
> +static struct qat_vf_migration_file *
> +qat_vf_resume_device_data(struct qat_vf_core_device *qat_vdev)
> +{
> +	struct qat_vf_migration_file *migf;
> +	int ret;
> +
> +	migf = kzalloc(sizeof(*migf), GFP_KERNEL);
> +	if (!migf)
> +		return ERR_PTR(-ENOMEM);
> +
> +	migf->filp = anon_inode_getfile("qat_vf_mig", &qat_vf_resume_fops,
> +					migf, O_WRONLY);
> +	ret = PTR_ERR_OR_ZERO(migf->filp);
> +	if (ret) {
> +		kfree(migf);
> +		return ERR_PTR(ret);
> +	}
> +	stream_open(migf->filp->f_inode, migf->filp);
> +	mutex_init(&migf->lock);
> +
> +	return migf;
> +}
> +
> +static int qat_vf_load_state(struct qat_vf_core_device *qat_vdev,
> +			     struct qat_vf_migration_file *migf)
> +{
> +	struct qat_vf_mig_data *mig_data = &migf->mig_data;
> +
> +	return qat_vfmig_load_state(qat_vdev->parent, qat_vdev->vf_id,
> +				    mig_data->state,
> +				    sizeof(mig_data->state));
> +}
> +
> +static int qat_vf_load_device_data(struct qat_vf_core_device *qat_vdev)
> +{
> +	return qat_vf_load_state(qat_vdev, qat_vdev->resuming_migf);
> +}
> +
> +static int qat_vf_start_device(struct qat_vf_core_device *qat_vdev)
> +{
> +	return qat_vfmig_resume_device(qat_vdev->parent, qat_vdev->vf_id);
> +}
> +
> +static struct file *qat_vf_pci_step_device_state(struct qat_vf_core_device *qat_vdev, u32 new)
> +{
> +	u32 cur = qat_vdev->mig_state;
> +	int ret;
> +
> +	if (cur == VFIO_DEVICE_STATE_RUNNING  && new == VFIO_DEVICE_STATE_STOP) {
> +		ret = qat_vf_stop_device(qat_vdev);
> +		if (ret)
> +			return ERR_PTR(ret);
> +		return NULL;
> +	}
> +
> +	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_STOP_COPY) {
> +		struct qat_vf_migration_file *migf;
> +
> +		migf = qat_vf_save_device_data(qat_vdev);
> +		if (IS_ERR(migf))
> +			return ERR_CAST(migf);
> +		get_file(migf->filp);
> +		qat_vdev->saving_migf = migf;
> +		return migf->filp;
> +	}
> +
> +	if (cur == VFIO_DEVICE_STATE_STOP_COPY && new == VFIO_DEVICE_STATE_STOP) {
> +		qat_vf_disable_fds(qat_vdev);
> +		return NULL;
> +	}
> +
> +	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_RESUMING) {
> +		struct qat_vf_migration_file *migf;
> +
> +		migf = qat_vf_resume_device_data(qat_vdev);
> +		if (IS_ERR(migf))
> +			return ERR_CAST(migf);
> +		get_file(migf->filp);
> +		qat_vdev->resuming_migf = migf;
> +		return migf->filp;
> +	}
> +
> +	if (cur == VFIO_DEVICE_STATE_RESUMING && new == VFIO_DEVICE_STATE_STOP) {
> +		ret = qat_vf_load_device_data(qat_vdev);
> +		if (ret)
> +			return ERR_PTR(ret);
> +
> +		qat_vf_disable_fds(qat_vdev);
> +		return NULL;
> +	}
> +
> +	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_RUNNING) {
> +		qat_vf_start_device(qat_vdev);
> +		return NULL;
> +	}
> +
> +	/* vfio_mig_get_next_state() does not use arcs other than the above */
> +	WARN_ON(true);
> +	return ERR_PTR(-EINVAL);
> +}
> +
> +static struct file *qat_vf_pci_set_device_state(struct vfio_device *vdev,
> +						enum vfio_device_mig_state new_state)
> +{
> +	struct qat_vf_core_device *qat_vdev = container_of(vdev,
> +			struct qat_vf_core_device, core_device.vdev);
> +	enum vfio_device_mig_state next_state;
> +	struct file *res = NULL;
> +	int ret;
> +
> +	mutex_lock(&qat_vdev->state_mutex);
> +	while (new_state != qat_vdev->mig_state) {
> +		ret = vfio_mig_get_next_state(vdev, qat_vdev->mig_state,
> +					      new_state, &next_state);
> +		if (ret) {
> +			res = ERR_PTR(-EINVAL);
> +			break;
> +		}
> +
> +		res = qat_vf_pci_step_device_state(qat_vdev, next_state);
> +		if (IS_ERR(res))
> +			break;
> +		qat_vdev->mig_state = next_state;
> +		if (WARN_ON(res && new_state != qat_vdev->mig_state)) {
> +			fput(res);
> +			res = ERR_PTR(-EINVAL);
> +			break;
> +		}
> +	}
> +	mutex_unlock(&qat_vdev->state_mutex);
> +
> +	return res;
> +}
> +
> +static int qat_vf_pci_get_device_state(struct vfio_device *vdev,
> +				       enum vfio_device_mig_state *curr_state)
> +{
> +	struct qat_vf_core_device *qat_vdev = container_of(vdev,
> +			struct qat_vf_core_device, core_device.vdev);
> +
> +	mutex_lock(&qat_vdev->state_mutex);
> +	*curr_state = qat_vdev->mig_state;
> +	mutex_unlock(&qat_vdev->state_mutex);
> +
> +	return 0;
> +}
> +
> +static int qat_vf_pci_get_data_size(struct vfio_device *vdev,
> +				    unsigned long *stop_copy_length)
> +{
> +	*stop_copy_length = sizeof(struct qat_vf_mig_data);
> +	return 0;
> +}
> +
> +static const struct vfio_migration_ops qat_vf_pci_mig_ops = {
> +	.migration_set_state = qat_vf_pci_set_device_state,
> +	.migration_get_state = qat_vf_pci_get_device_state,
> +	.migration_get_data_size = qat_vf_pci_get_data_size,
> +};
> +
> +static int qat_vf_pci_init_dev(struct vfio_device *core_vdev)
> +{
> +	struct qat_vf_core_device *qat_vdev = container_of(core_vdev,
> +			struct qat_vf_core_device, core_device.vdev);
> +
> +	mutex_init(&qat_vdev->state_mutex);
> +
> +	core_vdev->migration_flags = VFIO_MIGRATION_STOP_COPY;
> +	core_vdev->mig_ops = &qat_vf_pci_mig_ops;
> +
> +	return vfio_pci_core_init_dev(core_vdev);
> +}
> +
> +static const struct vfio_device_ops qat_vf_pci_ops = {
> +	.name = "qat-vf-vfio-pci",
> +	.init = qat_vf_pci_init_dev,
> +	.release = vfio_pci_core_release_dev,
> +	.open_device = qat_vf_pci_open_device,
> +	.close_device = qat_vf_pci_close_device,
> +	.ioctl = vfio_pci_core_ioctl,
> +	.read = vfio_pci_core_read,
> +	.write = vfio_pci_core_write,
> +	.mmap = vfio_pci_core_mmap,
> +	.request = vfio_pci_core_request,
> +	.match = vfio_pci_core_match,
> +	.bind_iommufd = vfio_iommufd_physical_bind,
> +	.unbind_iommufd = vfio_iommufd_physical_unbind,
> +	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> +};
> +
> +static int
> +qat_vf_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct qat_vf_core_device *qat_vdev;
> +	int ret;
> +
> +	qat_vdev = vfio_alloc_device(qat_vf_core_device, core_device.vdev, dev, &qat_vf_pci_ops);
> +	if (IS_ERR(qat_vdev))
> +		return PTR_ERR(qat_vdev);
> +
> +	qat_vdev->vf_id = pci_iov_vf_id(pdev);
> +	qat_vdev->parent = pdev->physfn;
> +	if (!qat_vdev->parent || qat_vdev->vf_id < 0)
> +		return -EINVAL;
> +
> +	pci_set_drvdata(pdev, &qat_vdev->core_device);
> +	ret = vfio_pci_core_register_device(&qat_vdev->core_device);
> +	if (ret)
> +		goto out_put_device;
> +
> +	return 0;
> +
> +out_put_device:
> +	vfio_put_device(&qat_vdev->core_device.vdev);
> +	return ret;
> +}
> +
> +static struct qat_vf_core_device *qat_vf_drvdata(struct pci_dev *pdev)
> +{
> +	struct vfio_pci_core_device *core_device = pci_get_drvdata(pdev);
> +
> +	return container_of(core_device, struct qat_vf_core_device, core_device);
> +}
> +
> +static void qat_vf_vfio_pci_remove(struct pci_dev *pdev)
> +{
> +	struct qat_vf_core_device *qat_vdev = qat_vf_drvdata(pdev);
> +
> +	vfio_pci_core_unregister_device(&qat_vdev->core_device);
> +	vfio_put_device(&qat_vdev->core_device.vdev);
> +}
> +
> +static const struct pci_device_id qat_vf_vfio_pci_table[] = {
> +	/* Intel QAT GEN4 4xxx VF device */
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_INTEL, 0x4941) },

Should this driver depend on CRYPTO_DEV_QAT_4XXX if that's the only
supported PF driver?

> +	{}
> +};
> +MODULE_DEVICE_TABLE(pci, qat_vf_vfio_pci_table);
> +
> +static struct pci_driver qat_vf_vfio_pci_driver = {
> +	.name = "qat_vfio_pci",
> +	.id_table = qat_vf_vfio_pci_table,
> +	.probe = qat_vf_vfio_pci_probe,
> +	.remove = qat_vf_vfio_pci_remove,
> +	.driver_managed_dma = true,
> +};
> +module_pci_driver(qat_vf_vfio_pci_driver)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Intel Corporation");
> +MODULE_DESCRIPTION("QAT VFIO PCI - VFIO PCI driver with live migration support for Intel(R) QAT device family");

Or at least one version of the QAT device family ;)  Thanks,

Alex

