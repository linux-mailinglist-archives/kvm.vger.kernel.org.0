Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 517C35319B2
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 22:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242477AbiEWRxR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 13:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243767AbiEWRvr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 13:51:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 52F49663ED
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 10:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653327498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2S/y7oLujZy2fYu0uj/bFDnCD7vgK3d64EOELBdfuL0=;
        b=EO4ZbX06Aospup6dZoB+tabl8fB2DnQ+52Uj/1W8y0nsVYO1Bf8elGWAYi4l78JqJ4wAsR
        sL+u1QQhXzjZp3GROQ6KQMSekyOSDRjJcewd2kz3Xv8XWynZYv7dmsjjpsqZeT14riXnQd
        FjFiv7hLYw+JSnJxHuHYb6Rxtk5+B2I=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-qh2nQ4H9O4SthAd4YwIPEw-1; Mon, 23 May 2022 13:25:05 -0400
X-MC-Unique: qh2nQ4H9O4SthAd4YwIPEw-1
Received: by mail-il1-f200.google.com with SMTP id a3-20020a924443000000b002d1bc79da14so718753ilm.15
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 10:25:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2S/y7oLujZy2fYu0uj/bFDnCD7vgK3d64EOELBdfuL0=;
        b=rmzqZS9i79HzbIf5h2lKVB4kTf7MRpPVmnf51pQhstWKRPtVAw0kq80hK3bLUpYRCN
         2ERYcD/7cNt+y4D30D4Tb3C8W7aL4n0qny0Qk3tFYSGids5u6C7eYLHa3MbfWD+Ks9yx
         jPjTV9oK/ZpXQP2lGrnjj0JdjAirOUABTuzS392jm9ILTf202gq4BA+A0pa/c/lNbRXl
         c4qr8vvef1F1yhS2lYcYul3DG++VH4mqjP9KbD1OSPYTnScNnOxOTKaiYVqDwygHQcXy
         iuRR/Ypzxm3B3zWH3nXTz12ZxspziLgfADMO1mdWhSStsmB4Dyh2JVu9+kFn6mDssr87
         PjRA==
X-Gm-Message-State: AOAM531N9cKVCHE9p4xtdzCO167pKLzCiI/8+7OeJ0cbYGHsRzU0WNBe
        2Byl0uYpmfwUTvUV4XXdWFQwd+xhp30XkA5QAaXpzW0BsMiaCmAxdZUNettxlCD0xbvk73HUyw9
        7SGk+8sR6c/jH
X-Received: by 2002:a05:6e02:17cb:b0:2d1:20ea:52fb with SMTP id z11-20020a056e0217cb00b002d120ea52fbmr11581078ilu.297.1653326702943;
        Mon, 23 May 2022 10:25:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwKX5aZnXcj78I9K3woYKErtzruP94pTDlx4lr5PKGXeLyevofxNDCuXy5a68ttAa1VOGEDDg==
X-Received: by 2002:a05:6e02:17cb:b0:2d1:20ea:52fb with SMTP id z11-20020a056e0217cb00b002d120ea52fbmr11581065ilu.297.1653326702602;
        Mon, 23 May 2022 10:25:02 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id g13-20020a0566380c4d00b0032e332882e0sm2877993jal.75.2022.05.23.10.25.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 10:25:01 -0700 (PDT)
Date:   Mon, 23 May 2022 11:25:00 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <kvm@vger.kernel.org>, <maorg@nvidia.com>,
        <cohuck@redhat.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>, <liulongfang@huawei.com>
Subject: Re: [PATCH] vfio: Split migration ops from main device ops
Message-ID: <20220523112500.3a227814.alex.williamson@redhat.com>
In-Reply-To: <20220522094756.219881-1-yishaih@nvidia.com>
References: <20220522094756.219881-1-yishaih@nvidia.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 22 May 2022 12:47:56 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> vfio core checks whether the driver sets some migration op (e.g.
> set_state/get_state) and accordingly calls its op.
> 
> However, currently mlx5 driver sets the above ops without regards to its
> migration caps.
> 
> This might lead to unexpected usage/Oops if user space may call to the
> above ops even if the driver doesn't support migration. As for example,
> the migration state_mutex is not initialized in that case.
> 
> The cleanest way to manage that seems to split the migration ops from
> the main device ops, this will let the driver setting them separately
> from the main ops when it's applicable.
> 
> As part of that, cleaned-up HISI driver to match this scheme.
> 
> This scheme may enable down the road to come with some extra group of
> ops (e.g. DMA log) that can be set without regards to the other options
> based on driver caps.

It seems like the hisi-acc driver already manages this by registering
different structs based on the device migration capabilities, why is
that not the default solution here?  Or of course the mlx5 driver could
test the migration capabilities before running into the weeds.  We also
have vfio_device.migration_flags which could factor in here as well.
Thanks,

Alex

> Fixes: 6fadb021266d ("vfio/mlx5: Implement vfio_pci driver for mlx5 devices")
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 27 +++++--------------
>  drivers/vfio/pci/mlx5/cmd.c                   |  4 ++-
>  drivers/vfio/pci/mlx5/cmd.h                   |  3 ++-
>  drivers/vfio/pci/mlx5/main.c                  |  9 ++++---
>  drivers/vfio/vfio.c                           | 13 ++++-----
>  include/linux/vfio.h                          | 26 +++++++++++-------
>  6 files changed, 40 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index e92376837b29..cfe9c8925d68 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -1208,17 +1208,7 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
>  	vfio_pci_core_close_device(core_vdev);
>  }
>  
> -static const struct vfio_device_ops hisi_acc_vfio_pci_migrn_ops = {
> -	.name = "hisi-acc-vfio-pci-migration",
> -	.open_device = hisi_acc_vfio_pci_open_device,
> -	.close_device = hisi_acc_vfio_pci_close_device,
> -	.ioctl = hisi_acc_vfio_pci_ioctl,
> -	.device_feature = vfio_pci_core_ioctl_feature,
> -	.read = hisi_acc_vfio_pci_read,
> -	.write = hisi_acc_vfio_pci_write,
> -	.mmap = hisi_acc_vfio_pci_mmap,
> -	.request = vfio_pci_core_request,
> -	.match = vfio_pci_core_match,
> +static const struct vfio_migration_ops hisi_acc_vfio_pci_migrn_ops = {
>  	.migration_set_state = hisi_acc_vfio_pci_set_device_state,
>  	.migration_get_state = hisi_acc_vfio_pci_get_device_state,
>  };
> @@ -1266,20 +1256,15 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
>  	if (!hisi_acc_vdev)
>  		return -ENOMEM;
>  
> +	vfio_pci_core_init_device(&hisi_acc_vdev->core_device, pdev,
> +				  &hisi_acc_vfio_pci_ops);
>  	pf_qm = hisi_acc_get_pf_qm(pdev);
>  	if (pf_qm && pf_qm->ver >= QM_HW_V3) {
>  		ret = hisi_acc_vfio_pci_migrn_init(hisi_acc_vdev, pdev, pf_qm);
> -		if (!ret) {
> -			vfio_pci_core_init_device(&hisi_acc_vdev->core_device, pdev,
> -						  &hisi_acc_vfio_pci_migrn_ops);
> -		} else {
> +		if (!ret)
> +			hisi_acc_vdev->core_device.vdev.mig_ops = &hisi_acc_vfio_pci_migrn_ops;
> +		else
>  			pci_warn(pdev, "migration support failed, continue with generic interface\n");
> -			vfio_pci_core_init_device(&hisi_acc_vdev->core_device, pdev,
> -						  &hisi_acc_vfio_pci_ops);
> -		}
> -	} else {
> -		vfio_pci_core_init_device(&hisi_acc_vdev->core_device, pdev,
> -					  &hisi_acc_vfio_pci_ops);
>  	}
>  
>  	dev_set_drvdata(&pdev->dev, &hisi_acc_vdev->core_device);
> diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
> index 9b9f33ca270a..334806c024b1 100644
> --- a/drivers/vfio/pci/mlx5/cmd.c
> +++ b/drivers/vfio/pci/mlx5/cmd.c
> @@ -98,7 +98,8 @@ void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev)
>  	destroy_workqueue(mvdev->cb_wq);
>  }
>  
> -void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev)
> +void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
> +			       const struct vfio_migration_ops *mig_ops)
>  {
>  	struct pci_dev *pdev = mvdev->core_device.pdev;
>  	int ret;
> @@ -139,6 +140,7 @@ void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev)
>  	mvdev->core_device.vdev.migration_flags =
>  		VFIO_MIGRATION_STOP_COPY |
>  		VFIO_MIGRATION_P2P;
> +	mvdev->core_device.vdev.mig_ops = mig_ops;
>  
>  end:
>  	mlx5_vf_put_core_dev(mvdev->mdev);
> diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
> index 6c3112fdd8b1..7b9e3d56158e 100644
> --- a/drivers/vfio/pci/mlx5/cmd.h
> +++ b/drivers/vfio/pci/mlx5/cmd.h
> @@ -62,7 +62,8 @@ int mlx5vf_cmd_suspend_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod);
>  int mlx5vf_cmd_resume_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod);
>  int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
>  					  size_t *state_size);
> -void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev);
> +void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
> +			       const struct vfio_migration_ops *mig_ops);
>  void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev);
>  int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
>  			       struct mlx5_vf_migration_file *migf);
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index dd1009b5ff9c..73998e4778c8 100644
> --- a/drivers/vfio/pci/mlx5/main.c
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -574,6 +574,11 @@ static void mlx5vf_pci_close_device(struct vfio_device *core_vdev)
>  	vfio_pci_core_close_device(core_vdev);
>  }
>  
> +static const struct vfio_migration_ops mlx5vf_pci_mig_ops = {
> +	.migration_set_state = mlx5vf_pci_set_device_state,
> +	.migration_get_state = mlx5vf_pci_get_device_state,
> +};
> +
>  static const struct vfio_device_ops mlx5vf_pci_ops = {
>  	.name = "mlx5-vfio-pci",
>  	.open_device = mlx5vf_pci_open_device,
> @@ -585,8 +590,6 @@ static const struct vfio_device_ops mlx5vf_pci_ops = {
>  	.mmap = vfio_pci_core_mmap,
>  	.request = vfio_pci_core_request,
>  	.match = vfio_pci_core_match,
> -	.migration_set_state = mlx5vf_pci_set_device_state,
> -	.migration_get_state = mlx5vf_pci_get_device_state,
>  };
>  
>  static int mlx5vf_pci_probe(struct pci_dev *pdev,
> @@ -599,7 +602,7 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
>  	if (!mvdev)
>  		return -ENOMEM;
>  	vfio_pci_core_init_device(&mvdev->core_device, pdev, &mlx5vf_pci_ops);
> -	mlx5vf_cmd_set_migratable(mvdev);
> +	mlx5vf_cmd_set_migratable(mvdev, &mlx5vf_pci_mig_ops);
>  	dev_set_drvdata(&pdev->dev, &mvdev->core_device);
>  	ret = vfio_pci_core_register_device(&mvdev->core_device);
>  	if (ret)
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index cfcff7764403..5bc678547f1f 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1510,8 +1510,8 @@ vfio_ioctl_device_feature_mig_device_state(struct vfio_device *device,
>  	struct file *filp = NULL;
>  	int ret;
>  
> -	if (!device->ops->migration_set_state ||
> -	    !device->ops->migration_get_state)
> +	if (!device->mig_ops->migration_set_state ||
> +	    !device->mig_ops->migration_get_state)
>  		return -ENOTTY;
>  
>  	ret = vfio_check_feature(flags, argsz,
> @@ -1527,7 +1527,8 @@ vfio_ioctl_device_feature_mig_device_state(struct vfio_device *device,
>  	if (flags & VFIO_DEVICE_FEATURE_GET) {
>  		enum vfio_device_mig_state curr_state;
>  
> -		ret = device->ops->migration_get_state(device, &curr_state);
> +		ret = device->mig_ops->migration_get_state(device,
> +							   &curr_state);
>  		if (ret)
>  			return ret;
>  		mig.device_state = curr_state;
> @@ -1535,7 +1536,7 @@ vfio_ioctl_device_feature_mig_device_state(struct vfio_device *device,
>  	}
>  
>  	/* Handle the VFIO_DEVICE_FEATURE_SET */
> -	filp = device->ops->migration_set_state(device, mig.device_state);
> +	filp = device->mig_ops->migration_set_state(device, mig.device_state);
>  	if (IS_ERR(filp) || !filp)
>  		goto out_copy;
>  
> @@ -1558,8 +1559,8 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
>  	};
>  	int ret;
>  
> -	if (!device->ops->migration_set_state ||
> -	    !device->ops->migration_get_state)
> +	if (!device->mig_ops->migration_set_state ||
> +	    !device->mig_ops->migration_get_state)
>  		return -ENOTTY;
>  
>  	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_GET,
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 45b287826ce6..1a1f61803742 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -32,6 +32,7 @@ struct vfio_device_set {
>  struct vfio_device {
>  	struct device *dev;
>  	const struct vfio_device_ops *ops;
> +	const struct vfio_migration_ops *mig_ops;
>  	struct vfio_group *group;
>  	struct vfio_device_set *dev_set;
>  	struct list_head dev_set_list;
> @@ -59,16 +60,6 @@ struct vfio_device {
>   *         match, -errno for abort (ex. match with insufficient or incorrect
>   *         additional args)
>   * @device_feature: Optional, fill in the VFIO_DEVICE_FEATURE ioctl
> - * @migration_set_state: Optional callback to change the migration state for
> - *         devices that support migration. It's mandatory for
> - *         VFIO_DEVICE_FEATURE_MIGRATION migration support.
> - *         The returned FD is used for data transfer according to the FSM
> - *         definition. The driver is responsible to ensure that FD reaches end
> - *         of stream or error whenever the migration FSM leaves a data transfer
> - *         state or before close_device() returns.
> - * @migration_get_state: Optional callback to get the migration state for
> - *         devices that support migration. It's mandatory for
> - *         VFIO_DEVICE_FEATURE_MIGRATION migration support.
>   */
>  struct vfio_device_ops {
>  	char	*name;
> @@ -85,6 +76,21 @@ struct vfio_device_ops {
>  	int	(*match)(struct vfio_device *vdev, char *buf);
>  	int	(*device_feature)(struct vfio_device *device, u32 flags,
>  				  void __user *arg, size_t argsz);
> +};
> +
> +/**
> + * @migration_set_state: Optional callback to change the migration state for
> + *         devices that support migration. It's mandatory for
> + *         VFIO_DEVICE_FEATURE_MIGRATION migration support.
> + *         The returned FD is used for data transfer according to the FSM
> + *         definition. The driver is responsible to ensure that FD reaches end
> + *         of stream or error whenever the migration FSM leaves a data transfer
> + *         state or before close_device() returns.
> + * @migration_get_state: Optional callback to get the migration state for
> + *         devices that support migration. It's mandatory for
> + *         VFIO_DEVICE_FEATURE_MIGRATION migration support.
> + */
> +struct vfio_migration_ops {
>  	struct file *(*migration_set_state)(
>  		struct vfio_device *device,
>  		enum vfio_device_mig_state new_state);

