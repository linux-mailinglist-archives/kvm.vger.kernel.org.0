Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C52C51AED8
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 22:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235219AbiEDUQr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 16:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243849AbiEDUQp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 16:16:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 23D234F442
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 13:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651695188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Scbt27CDn1t3cwkb6QMEFLIVuj/YfehjTe+BXLevHu0=;
        b=AXJBkMzNAsmEgBIKSKSFfM0LZlmucS3y4Qe7OGDvNyq+QoFB8y9xgqren4xLcc0LB7CUpV
        NjIz/XolY5+xpGaxJkQACNOLP9DloIYoW7bn54g4OPotiPVvGK8C3OHsC/ekJuCDCteUgf
        pZmqsGMXPfVRnloeGuA7KllerXmbVxw=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-104-PK4K1QHIOYiL0-wr2j6Ynw-1; Wed, 04 May 2022 16:13:07 -0400
X-MC-Unique: PK4K1QHIOYiL0-wr2j6Ynw-1
Received: by mail-io1-f69.google.com with SMTP id b1-20020a05660214c100b006572ddc92f7so1688083iow.2
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 13:13:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Scbt27CDn1t3cwkb6QMEFLIVuj/YfehjTe+BXLevHu0=;
        b=RP7/0svvdcEZwZlYynSg/387b4fy6N1ZRilTC1jOYIcKyyeY0jerIaH69mtt1M57hX
         avq11+u/VRKXo0oHvyz8uqLQn7DFE+jhzlzdAutYVNOvDCxfbko6ZdNnHRfOsDdiqOWN
         0Mb4DI8gkQ0lgXdx4R2/6SVkSy33C5UBl01BfDkUCW3GBZ7R8vh1DE8EeXzS5E27mJG8
         NvRiexbFRYJIs06zPbBe9NDpB0COOjg8WQUoR8QAfbyPTOGHupU+Nu1aAwMHLpe+FKm6
         uXxTtc6d5i3Mq3mjdBsuni4EYF86Gkr+uem+Xn3hLQ+JjlNzSMBriJ4fvBFnPDGpYg7h
         MiAA==
X-Gm-Message-State: AOAM5314sJKfxI/n4xmQ1pm7uDSWylOn/ADix479Wwn1k846VhOwmEpI
        Gp9z8JkS/NVQLhEzw43eB0UPl+Ll68I0DJHFKL1UHBVc3FOS+s50nQiv0eVqakviQHW/35qA6ds
        +ropxKEF2Ta6u
X-Received: by 2002:a05:6638:130e:b0:32b:940e:61e8 with SMTP id r14-20020a056638130e00b0032b940e61e8mr1609736jad.141.1651695186125;
        Wed, 04 May 2022 13:13:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwcYCHdtHeG14BSoNyv0XREM8vpmuJ6C/2KvX0qp2+nzoXjWgcdFceaes2dIkBYViYuRLRtsQ==
X-Received: by 2002:a05:6638:130e:b0:32b:940e:61e8 with SMTP id r14-20020a056638130e00b0032b940e61e8mr1609724jad.141.1651695185918;
        Wed, 04 May 2022 13:13:05 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id g20-20020a0566380c5400b0032b3a7817d3sm4951955jal.151.2022.05.04.13.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 13:13:05 -0700 (PDT)
Date:   Wed, 4 May 2022 14:13:04 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <maorg@nvidia.com>, <cohuck@redhat.com>
Subject: Re: [PATCH mlx5-next 1/5] vfio/mlx5: Reorganize the VF is
 migratable code
Message-ID: <20220504141304.7c511e57.alex.williamson@redhat.com>
In-Reply-To: <20220427093120.161402-2-yishaih@nvidia.com>
References: <20220427093120.161402-1-yishaih@nvidia.com>
        <20220427093120.161402-2-yishaih@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 27 Apr 2022 12:31:16 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> Reorganize the VF is migratable code to be in a separate function, next
> patches from the series may use this.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/vfio/pci/mlx5/cmd.c  | 18 ++++++++++++++++++
>  drivers/vfio/pci/mlx5/cmd.h  |  1 +
>  drivers/vfio/pci/mlx5/main.c | 22 +++++++---------------
>  3 files changed, 26 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
> index 5c9f9218cc1d..d608b8167f58 100644
> --- a/drivers/vfio/pci/mlx5/cmd.c
> +++ b/drivers/vfio/pci/mlx5/cmd.c
> @@ -71,6 +71,24 @@ int mlx5vf_cmd_query_vhca_migration_state(struct pci_dev *pdev, u16 vhca_id,
>  	return ret;
>  }
>  
> +bool mlx5vf_cmd_is_migratable(struct pci_dev *pdev)
> +{
> +	struct mlx5_core_dev *mdev = mlx5_vf_get_core_dev(pdev);
> +	bool migratable = false;
> +
> +	if (!mdev)
> +		return false;
> +
> +	if (!MLX5_CAP_GEN(mdev, migration))
> +		goto end;
> +
> +	migratable = true;
> +
> +end:
> +	mlx5_vf_put_core_dev(mdev);
> +	return migratable;
> +}

This goto seems unnecessary, couldn't it instead be written:

{
	struct mlx5_core_dev *mdev = mlx5_vf_get_core_dev(pdev);
	boot migratable = true;

	if (!mdev)
		return false;

	if (!MLX5_CAP_GEN(mdev, migration))
		migratable = false;

	mlx5_vf_put_core_mdev(mdev);
	return migratable;
}

Thanks,
Alex

> +
>  int mlx5vf_cmd_get_vhca_id(struct pci_dev *pdev, u16 function_id, u16 *vhca_id)
>  {
>  	struct mlx5_core_dev *mdev = mlx5_vf_get_core_dev(pdev);
> diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
> index 1392a11a9cc0..2da6a1c0ec5c 100644
> --- a/drivers/vfio/pci/mlx5/cmd.h
> +++ b/drivers/vfio/pci/mlx5/cmd.h
> @@ -29,6 +29,7 @@ int mlx5vf_cmd_resume_vhca(struct pci_dev *pdev, u16 vhca_id, u16 op_mod);
>  int mlx5vf_cmd_query_vhca_migration_state(struct pci_dev *pdev, u16 vhca_id,
>  					  size_t *state_size);
>  int mlx5vf_cmd_get_vhca_id(struct pci_dev *pdev, u16 function_id, u16 *vhca_id);
> +bool mlx5vf_cmd_is_migratable(struct pci_dev *pdev);
>  int mlx5vf_cmd_save_vhca_state(struct pci_dev *pdev, u16 vhca_id,
>  			       struct mlx5_vf_migration_file *migf);
>  int mlx5vf_cmd_load_vhca_state(struct pci_dev *pdev, u16 vhca_id,
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index bbec5d288fee..2578f61eaeae 100644
> --- a/drivers/vfio/pci/mlx5/main.c
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -597,21 +597,13 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
>  		return -ENOMEM;
>  	vfio_pci_core_init_device(&mvdev->core_device, pdev, &mlx5vf_pci_ops);
>  
> -	if (pdev->is_virtfn) {
> -		struct mlx5_core_dev *mdev =
> -			mlx5_vf_get_core_dev(pdev);
> -
> -		if (mdev) {
> -			if (MLX5_CAP_GEN(mdev, migration)) {
> -				mvdev->migrate_cap = 1;
> -				mvdev->core_device.vdev.migration_flags =
> -					VFIO_MIGRATION_STOP_COPY |
> -					VFIO_MIGRATION_P2P;
> -				mutex_init(&mvdev->state_mutex);
> -				spin_lock_init(&mvdev->reset_lock);
> -			}
> -			mlx5_vf_put_core_dev(mdev);
> -		}
> +	if (pdev->is_virtfn && mlx5vf_cmd_is_migratable(pdev)) {
> +		mvdev->migrate_cap = 1;
> +		mvdev->core_device.vdev.migration_flags =
> +			VFIO_MIGRATION_STOP_COPY |
> +			VFIO_MIGRATION_P2P;
> +		mutex_init(&mvdev->state_mutex);
> +		spin_lock_init(&mvdev->reset_lock);
>  	}
>  
>  	ret = vfio_pci_core_register_device(&mvdev->core_device);

