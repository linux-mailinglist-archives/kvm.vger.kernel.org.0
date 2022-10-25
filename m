Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5545860CCEE
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 15:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbiJYNFu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 09:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbiJYNFS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 09:05:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD062018F
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 06:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666703099;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pDGUc/HDDwX9sWsay7uQR5f21ns74CYYDFwNTrQZFt4=;
        b=ev40Gz+MH89CFQ+1rvDcocdwRpG9bI1aS2MFdUqIEjcnAkI26MMTrGYAk6n16ThveJLsIX
        h8ya9GDt6tZF/ovarJlC0lgq5pyAfU/hFaIt6htRmt6hrrF4LADtNH35qM/WJbfL9oxoa3
        BKX0OVrRJyS83fuzosH3Mp64Qlvz7nM=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-392-t_AB4xZzPKm9QLUxp8n5KQ-1; Tue, 25 Oct 2022 09:04:09 -0400
X-MC-Unique: t_AB4xZzPKm9QLUxp8n5KQ-1
Received: by mail-io1-f72.google.com with SMTP id 23-20020a5d9c57000000b006bbd963e8adso8161578iof.19
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 06:04:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pDGUc/HDDwX9sWsay7uQR5f21ns74CYYDFwNTrQZFt4=;
        b=paZrTGc9yZa3EWJ7c3hgmepFUl6Tt0rS8M5k/YW8EQ3v0iba5FAra9UT2/eR4YZFoh
         WvBNDLulygVVEZh5ktpsbrqM+BOSkTQ5bsMsbLa/gr4id9p8xrJLeF3YYPPNg4tMngnT
         ESlJR5mxW9cwDiKvZ/jvYH0tY0j3RSQyIE9YCyswW2+FiT+59EhFROqKGd7VZm6IopCo
         e3sgTYow8gkmvkkflDkHJ9WGb77BKCFd4eJKLt/vgUKYPfX/Bu5oNTQz1297FI4FofvV
         e/0LsTe2LXyEqpS56qOh8SYycfStCKDy81NWWtklOjQpNKArx+xB9MsWVgtOd2OFXMj3
         rTmQ==
X-Gm-Message-State: ACrzQf1+sw3wy8WkNSXA4+txXVBYNt1NWd4dtaLHd2mkJ5BRDkyCXJJg
        ZpgGg2HLwIyitQ3kPHG+oDN+34OqQeHZOiunT2PqtGPbfjYhKwkZqYE7as36h3ATymPQC/Rb0eR
        x6AaFUH6pVmhm
X-Received: by 2002:a5d:9d9f:0:b0:6bc:6adf:aa1a with SMTP id ay31-20020a5d9d9f000000b006bc6adfaa1amr23383415iob.90.1666703042788;
        Tue, 25 Oct 2022 06:04:02 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4wnEz5R7gkf3jdd9KUOQLPRHqoW8VEew1OxUM1RZ5ynSZlF7fNN+y6BtNAukpivhO3F3ggyg==
X-Received: by 2002:a5d:9d9f:0:b0:6bc:6adf:aa1a with SMTP id ay31-20020a5d9d9f000000b006bc6adfaa1amr23383391iob.90.1666703042445;
        Tue, 25 Oct 2022 06:04:02 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id u15-20020a056e02170f00b002f52f029b4asm996620ill.32.2022.10.25.06.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 06:04:01 -0700 (PDT)
Date:   Tue, 25 Oct 2022 07:04:00 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <quintela@redhat.com>, <kvm@vger.kernel.org>,
        <liulongfang@huawei.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kuba@kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: Re: [PATCH] vfio: Add an option to get migration data size
Message-ID: <20221025070400.5ea5f7e0.alex.williamson@redhat.com>
In-Reply-To: <20221020132109.112708-1-yishaih@nvidia.com>
References: <20221020132109.112708-1-yishaih@nvidia.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 20 Oct 2022 16:21:09 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> Add an option to get migration data size by introducing a new migration
> feature named VFIO_DEVICE_FEATURE_MIG_DATA_SIZE.
> 
> Upon VFIO_DEVICE_FEATURE_GET the estimated data length that will be
> required to complete STOP_COPY is returned.
> 
> This option may better enable user space to consider before moving to
> STOP_COPY whether it can meet the downtime SLA based on the returned
> data.
> 
> The patch also includes the implementation for mlx5 and hisi for this
> new option to make it feature complete for the existing drivers in this
> area.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |  9 ++++++
>  drivers/vfio/pci/mlx5/main.c                  | 18 +++++++++++
>  drivers/vfio/vfio_main.c                      | 32 +++++++++++++++++++
>  include/linux/vfio.h                          |  5 +++
>  include/uapi/linux/vfio.h                     | 13 ++++++++
>  5 files changed, 77 insertions(+)
> 
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index 39eeca18a0f7..0c0c0c7f0521 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -957,6 +957,14 @@ hisi_acc_vfio_pci_set_device_state(struct vfio_device *vdev,
>  	return res;
>  }
>  
> +static int
> +hisi_acc_vfio_pci_get_data_size(struct vfio_device *vdev,
> +				unsigned long *stop_copy_length)
> +{
> +	*stop_copy_length = sizeof(struct acc_vf_data);
> +	return 0;
> +}
> +
>  static int
>  hisi_acc_vfio_pci_get_device_state(struct vfio_device *vdev,
>  				   enum vfio_device_mig_state *curr_state)
> @@ -1213,6 +1221,7 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
>  static const struct vfio_migration_ops hisi_acc_vfio_pci_migrn_state_ops = {
>  	.migration_set_state = hisi_acc_vfio_pci_set_device_state,
>  	.migration_get_state = hisi_acc_vfio_pci_get_device_state,
> +	.migration_get_data_size = hisi_acc_vfio_pci_get_data_size,
>  };
>  
>  static int hisi_acc_vfio_pci_migrn_init_dev(struct vfio_device *core_vdev)
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index fd6ccb8454a2..4c7a39ffd247 100644
> --- a/drivers/vfio/pci/mlx5/main.c
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -512,6 +512,23 @@ mlx5vf_pci_set_device_state(struct vfio_device *vdev,
>  	return res;
>  }
>  
> +static int mlx5vf_pci_get_data_size(struct vfio_device *vdev,
> +				    unsigned long *stop_copy_length)
> +{
> +	struct mlx5vf_pci_core_device *mvdev = container_of(
> +		vdev, struct mlx5vf_pci_core_device, core_device.vdev);
> +	size_t state_size;
> +	int ret;
> +
> +	mutex_lock(&mvdev->state_mutex);
> +	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev,
> +						    &state_size);
> +	if (!ret)
> +		*stop_copy_length = state_size;
> +	mlx5vf_state_mutex_unlock(mvdev);
> +	return ret;
> +}
> +
>  static int mlx5vf_pci_get_device_state(struct vfio_device *vdev,
>  				       enum vfio_device_mig_state *curr_state)
>  {
> @@ -577,6 +594,7 @@ static void mlx5vf_pci_close_device(struct vfio_device *core_vdev)
>  static const struct vfio_migration_ops mlx5vf_pci_mig_ops = {
>  	.migration_set_state = mlx5vf_pci_set_device_state,
>  	.migration_get_state = mlx5vf_pci_get_device_state,
> +	.migration_get_data_size = mlx5vf_pci_get_data_size,
>  };
>  
>  static const struct vfio_log_ops mlx5vf_pci_log_ops = {
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 2d168793d4e1..b118e7b1bc59 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1256,6 +1256,34 @@ vfio_ioctl_device_feature_mig_device_state(struct vfio_device *device,
>  	return 0;
>  }
>  
> +static int
> +vfio_ioctl_device_feature_migration_data_size(struct vfio_device *device,
> +					      u32 flags, void __user *arg,
> +					      size_t argsz)
> +{
> +	struct vfio_device_feature_mig_data_size data_size = {};
> +	unsigned long stop_copy_length;
> +	int ret;
> +
> +	if (!device->mig_ops)
> +		return -ENOTTY;
> +
> +	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_GET,
> +				 sizeof(data_size));
> +	if (ret != 1)
> +		return ret;
> +
> +	ret = device->mig_ops->migration_get_data_size(device, &stop_copy_length);
> +	if (ret)
> +		return ret;
> +
> +	data_size.stop_copy_length = stop_copy_length;
> +	if (copy_to_user(arg, &data_size, sizeof(data_size)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
>  static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
>  					       u32 flags, void __user *arg,
>  					       size_t argsz)
> @@ -1483,6 +1511,10 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
>  		return vfio_ioctl_device_feature_logging_report(
>  			device, feature.flags, arg->data,
>  			feature.argsz - minsz);
> +	case VFIO_DEVICE_FEATURE_MIG_DATA_SIZE:
> +		return vfio_ioctl_device_feature_migration_data_size(
> +			device, feature.flags, arg->data,
> +			feature.argsz - minsz);
>  	default:
>  		if (unlikely(!device->ops->device_feature))
>  			return -EINVAL;
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index e7cebeb875dd..5509451ae709 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -107,6 +107,9 @@ struct vfio_device_ops {
>   * @migration_get_state: Optional callback to get the migration state for
>   *         devices that support migration. It's mandatory for
>   *         VFIO_DEVICE_FEATURE_MIGRATION migration support.
> + * @migration_get_data_size: Optional callback to get the estimated data
> + *          length that will be required to complete stop copy. It's mandatory for
> + *          VFIO_DEVICE_FEATURE_MIGRATION migration support.
>   */

This is listed as an optional callback, but we call it
deterministically and there's no added check like there is for
set/get_state in vfio_pci_core_register_device().  Thanks,

Alex


>  struct vfio_migration_ops {
>  	struct file *(*migration_set_state)(
> @@ -114,6 +117,8 @@ struct vfio_migration_ops {
>  		enum vfio_device_mig_state new_state);
>  	int (*migration_get_state)(struct vfio_device *device,
>  				   enum vfio_device_mig_state *curr_state);
> +	int (*migration_get_data_size)(struct vfio_device *device,
> +				       unsigned long *stop_copy_length);
>  };
>  
>  /**
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index d7d8e0922376..3e45dbaf190e 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1128,6 +1128,19 @@ struct vfio_device_feature_dma_logging_report {
>  
>  #define VFIO_DEVICE_FEATURE_DMA_LOGGING_REPORT 8
>  
> +/*
> + * Upon VFIO_DEVICE_FEATURE_GET read back the estimated data length that will
> + * be required to complete stop copy.
> + *
> + * Note: Can be called on each device state.
> + */
> +
> +struct vfio_device_feature_mig_data_size {
> +	__aligned_u64 stop_copy_length;
> +};
> +
> +#define VFIO_DEVICE_FEATURE_MIG_DATA_SIZE 9
> +
>  /* -------- API for Type1 VFIO IOMMU -------- */
>  
>  /**

