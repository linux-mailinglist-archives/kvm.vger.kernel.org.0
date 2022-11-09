Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6DAA6224CC
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 08:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbiKIHmS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 02:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiKIHmR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 02:42:17 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 783741DDE4
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 23:42:15 -0800 (PST)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N6cNq6r4bzHvKK;
        Wed,  9 Nov 2022 15:41:47 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (7.193.23.191) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 15:42:12 +0800
Received: from [10.67.103.158] (10.67.103.158) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 15:42:11 +0800
Subject: Re: [PATCH vfio 01/13] vfio: Add an option to get migration data size
To:     Yishai Hadas <yishaih@nvidia.com>, <alex.williamson@redhat.com>,
        <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <maorg@nvidia.com>, <avihaih@nvidia.com>,
        <cohuck@redhat.com>
References: <20221106174630.25909-1-yishaih@nvidia.com>
 <20221106174630.25909-2-yishaih@nvidia.com>
From:   liulongfang <liulongfang@huawei.com>
Message-ID: <ea4bc132-0520-f156-3fca-ec0a89e09a3d@huawei.com>
Date:   Wed, 9 Nov 2022 15:42:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20221106174630.25909-2-yishaih@nvidia.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.158]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600005.china.huawei.com (7.193.23.191)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/11/7 1:46, Yishai Hadas Wrote:
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
>  drivers/vfio/pci/vfio_pci_core.c              |  3 +-
>  drivers/vfio/vfio_main.c                      | 32 +++++++++++++++++++
>  include/linux/vfio.h                          |  5 +++
>  include/uapi/linux/vfio.h                     | 13 ++++++++
>  6 files changed, 79 insertions(+), 1 deletion(-)
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

Reviewed-by: Longfang Liu <liulongfang@huawei.com>

Thanks.

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
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index badc9d828cac..4d97ca66ba6c 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -2128,7 +2128,8 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
>  
>  	if (vdev->vdev.mig_ops) {
>  		if (!(vdev->vdev.mig_ops->migration_get_state &&
> -		      vdev->vdev.mig_ops->migration_set_state) ||
> +		      vdev->vdev.mig_ops->migration_set_state &&
> +		      vdev->vdev.mig_ops->migration_get_data_size) ||
>  		    !(vdev->vdev.migration_flags & VFIO_MIGRATION_STOP_COPY))
>  			return -EINVAL;
>  	}
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
> 
