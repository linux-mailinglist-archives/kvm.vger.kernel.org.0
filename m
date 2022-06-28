Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7536555EF2B
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 22:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbiF1UUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 16:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbiF1UUC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 16:20:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E02EA313B9
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 13:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656447386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s/euQJRjcoUB87zdWTaJhBi0+rSzJy1YEv6acVZ1CNs=;
        b=JsgKKqkytosSaYI9lTyLI6w6RNHEpWJuzZY+L04Cl/dldxcvUjIvFBkaC94ylj0ySDJWr0
        eB5BAV4ZBgQEIpg8wn9WXlf/O7xGGzTysFu5fJ/lWEZ5dWsGu/pzgff9fnnSpfyhZlKc8R
        QIT+ou0FdSUsoj7cjqOLEqwzgLATQRM=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-373-WxfDWjyOPC6gMLaRmeijFw-1; Tue, 28 Jun 2022 16:16:24 -0400
X-MC-Unique: WxfDWjyOPC6gMLaRmeijFw-1
Received: by mail-il1-f199.google.com with SMTP id z18-20020a056e02089200b002dab7cef3d2so991263ils.16
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 13:16:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=s/euQJRjcoUB87zdWTaJhBi0+rSzJy1YEv6acVZ1CNs=;
        b=s1Mbxu5UyZALXcWH0yDdYrPKXGB+klPh2fEPDfwEhoGI5SkH+x3pHX/oiVjyiDjiVm
         YbPhXkLxBqdfmeN1MQzlF9TRaSFA1Cu9ZwF3zMOHmp6aE0ynF+MO4b9WpNKw9wZwbyAI
         onJZs1SAkLqGrd60dTcP3yjMw52BziuXMiwq7jiP9vm7jPAI8qIzxtZ8cFCPRgPJT7wg
         kYvAnLbQSgCtu04Yxtn4A0vPw4ckZ+EGnG6E8Vb+B8/Vlc9NYVivyxyAbtQRW3SR+Rwa
         T2uT3XvpllQ6O0RNy4uFzV/OXrFSV6IVEKfzyRzOigHBBqHplI36NOOX5xFWktofls/r
         xK7w==
X-Gm-Message-State: AJIora+IUhTm5/FdVyeiWIkOsYxdBuNOSCpwt51/o3wzYF3EEkdTI8w8
        IVkTS7TJMaSCtpNSQkmuun3xMxzXoLIbHO++c1ggi8pPb7xPlaWQXYVdw8pREjwMGJRhiUwnOQY
        pL5GxhUI1vv1f
X-Received: by 2002:a05:6638:2586:b0:331:bbbe:4f63 with SMTP id s6-20020a056638258600b00331bbbe4f63mr12352888jat.255.1656447383742;
        Tue, 28 Jun 2022 13:16:23 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uwij6FyLC15VAaRREFRvc1SVhKWHdoyHF2hIpcPObzodJNuC4wuPaMT5RLQWB8vNXQfv2xOQ==
X-Received: by 2002:a05:6638:2586:b0:331:bbbe:4f63 with SMTP id s6-20020a056638258600b00331bbbe4f63mr12352871jat.255.1656447383422;
        Tue, 28 Jun 2022 13:16:23 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id m15-20020a02c88f000000b00339e669df91sm6295736jao.153.2022.06.28.13.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 13:16:22 -0700 (PDT)
Date:   Tue, 28 Jun 2022 14:16:21 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <kvm@vger.kernel.org>, <maorg@nvidia.com>,
        <cohuck@redhat.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>, <liulongfang@huawei.com>
Subject: Re: [PATCH V3 vfio 2/2] vfio: Split migration ops from main device
 ops
Message-ID: <20220628141621.54ef59f8.alex.williamson@redhat.com>
In-Reply-To: <20220628155910.171454-3-yishaih@nvidia.com>
References: <20220628155910.171454-1-yishaih@nvidia.com>
        <20220628155910.171454-3-yishaih@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 28 Jun 2022 18:59:10 +0300
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
> As part of that, validate ops construction on registration and include a
> check for VFIO_MIGRATION_STOP_COPY since the uAPI claims it must be set
> in migration_flags.
> 
> HISI driver was changed as well to match this scheme.
> 
> This scheme may enable down the road to come with some extra group of
> ops (e.g. DMA log) that can be set without regards to the other options
> based on driver caps.
> 
> Fixes: 6fadb021266d ("vfio/mlx5: Implement vfio_pci driver for mlx5 devices")
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 11 +++++--
>  drivers/vfio/pci/mlx5/cmd.c                   |  4 ++-
>  drivers/vfio/pci/mlx5/cmd.h                   |  3 +-
>  drivers/vfio/pci/mlx5/main.c                  |  9 ++++--
>  drivers/vfio/pci/vfio_pci_core.c              |  7 +++++
>  drivers/vfio/vfio.c                           | 11 ++++---
>  include/linux/vfio.h                          | 30 ++++++++++++-------
>  7 files changed, 51 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index 4def43f5f7b6..ea762e28c1cc 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -1185,7 +1185,7 @@ static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
>  	if (ret)
>  		return ret;
>  
> -	if (core_vdev->ops->migration_set_state) {
> +	if (core_vdev->mig_ops) {
>  		ret = hisi_acc_vf_qm_init(hisi_acc_vdev);
>  		if (ret) {
>  			vfio_pci_core_disable(vdev);
> @@ -1208,6 +1208,11 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
>  	vfio_pci_core_close_device(core_vdev);
>  }
>  
> +static const struct vfio_migration_ops hisi_acc_vfio_pci_migrn_state_ops = {
> +	.migration_set_state = hisi_acc_vfio_pci_set_device_state,
> +	.migration_get_state = hisi_acc_vfio_pci_get_device_state,
> +};
> +
>  static const struct vfio_device_ops hisi_acc_vfio_pci_migrn_ops = {
>  	.name = "hisi-acc-vfio-pci-migration",
>  	.open_device = hisi_acc_vfio_pci_open_device,
> @@ -1219,8 +1224,6 @@ static const struct vfio_device_ops hisi_acc_vfio_pci_migrn_ops = {
>  	.mmap = hisi_acc_vfio_pci_mmap,
>  	.request = vfio_pci_core_request,
>  	.match = vfio_pci_core_match,
> -	.migration_set_state = hisi_acc_vfio_pci_set_device_state,
> -	.migration_get_state = hisi_acc_vfio_pci_get_device_state,
>  };
>  
>  static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
> @@ -1272,6 +1275,8 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
>  		if (!ret) {
>  			vfio_pci_core_init_device(&hisi_acc_vdev->core_device, pdev,
>  						  &hisi_acc_vfio_pci_migrn_ops);
> +			hisi_acc_vdev->core_device.vdev.mig_ops =
> +					&hisi_acc_vfio_pci_migrn_state_ops;
>  		} else {
>  			pci_warn(pdev, "migration support failed, continue with generic interface\n");
>  			vfio_pci_core_init_device(&hisi_acc_vdev->core_device, pdev,
> diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
> index cdd0c667dc77..dd5d7bfe0a49 100644
> --- a/drivers/vfio/pci/mlx5/cmd.c
> +++ b/drivers/vfio/pci/mlx5/cmd.c
> @@ -108,7 +108,8 @@ void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev)
>  	destroy_workqueue(mvdev->cb_wq);
>  }
>  
> -void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev)
> +void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
> +			       const struct vfio_migration_ops *mig_ops)
>  {
>  	struct pci_dev *pdev = mvdev->core_device.pdev;
>  	int ret;
> @@ -149,6 +150,7 @@ void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev)
>  	mvdev->core_device.vdev.migration_flags =
>  		VFIO_MIGRATION_STOP_COPY |
>  		VFIO_MIGRATION_P2P;
> +	mvdev->core_device.vdev.mig_ops = mig_ops;
>  
>  end:
>  	mlx5_vf_put_core_dev(mvdev->mdev);
> diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
> index aa692d9ce656..8208f4701a90 100644
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
>  void mlx5vf_cmd_close_migratable(struct mlx5vf_pci_core_device *mvdev);
>  int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index d754990f0662..a9b63d15c5d3 100644
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
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index a0d69ddaf90d..cf875309dac0 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1855,6 +1855,13 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
>  	if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
>  		return -EINVAL;
>  
> +	if (vdev->vdev.mig_ops) {
> +		if ((!(vdev->vdev.mig_ops->migration_get_state &&
> +		       vdev->vdev.mig_ops->migration_set_state)) ||
> +		    (!(vdev->vdev.migration_flags & VFIO_MIGRATION_STOP_COPY)))
> +			return -EINVAL;

A bit excessive on the parenthesis, a logical NOT is just below parens
and well above a logical OR on order of operations, so it should be
fine as:

	if (!(vdev->vdev.mig_ops->migration_get_state &&
	      vdev->vdev.mig_ops->migration_set_state) ||
	    !(vdev->vdev.migration_flags & VFIO_MIGRATION_STOP_COPY))
		return -EINVAL;

Looks ok to me otherwise, so if there are no other changes maybe I can
roll that in on commit.  Thanks,

Alex

> +	}
> +
>  	/*
>  	 * Prevent binding to PFs with VFs enabled, the VFs might be in use
>  	 * by the host or other users.  We cannot capture the VFs if they
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index e22be13e6771..ccbd106b95d8 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1534,8 +1534,7 @@ vfio_ioctl_device_feature_mig_device_state(struct vfio_device *device,
>  	struct file *filp = NULL;
>  	int ret;
>  
> -	if (!device->ops->migration_set_state ||
> -	    !device->ops->migration_get_state)
> +	if (!device->mig_ops)
>  		return -ENOTTY;
>  
>  	ret = vfio_check_feature(flags, argsz,
> @@ -1551,7 +1550,8 @@ vfio_ioctl_device_feature_mig_device_state(struct vfio_device *device,
>  	if (flags & VFIO_DEVICE_FEATURE_GET) {
>  		enum vfio_device_mig_state curr_state;
>  
> -		ret = device->ops->migration_get_state(device, &curr_state);
> +		ret = device->mig_ops->migration_get_state(device,
> +							   &curr_state);
>  		if (ret)
>  			return ret;
>  		mig.device_state = curr_state;
> @@ -1559,7 +1559,7 @@ vfio_ioctl_device_feature_mig_device_state(struct vfio_device *device,
>  	}
>  
>  	/* Handle the VFIO_DEVICE_FEATURE_SET */
> -	filp = device->ops->migration_set_state(device, mig.device_state);
> +	filp = device->mig_ops->migration_set_state(device, mig.device_state);
>  	if (IS_ERR(filp) || !filp)
>  		goto out_copy;
>  
> @@ -1582,8 +1582,7 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
>  	};
>  	int ret;
>  
> -	if (!device->ops->migration_set_state ||
> -	    !device->ops->migration_get_state)
> +	if (!device->mig_ops)
>  		return -ENOTTY;
>  
>  	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_GET,
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index aa888cc51757..d6c592565be7 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -32,6 +32,11 @@ struct vfio_device_set {
>  struct vfio_device {
>  	struct device *dev;
>  	const struct vfio_device_ops *ops;
> +	/*
> +	 * mig_ops is a static property of the vfio_device which must be set
> +	 * prior to registering the vfio_device.
> +	 */
> +	const struct vfio_migration_ops *mig_ops;
>  	struct vfio_group *group;
>  	struct vfio_device_set *dev_set;
>  	struct list_head dev_set_list;
> @@ -61,16 +66,6 @@ struct vfio_device {
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
> @@ -87,6 +82,21 @@ struct vfio_device_ops {
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

