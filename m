Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 733387AE43B
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 05:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233356AbjIZDf1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 23:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232349AbjIZDfY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 23:35:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24334C9
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 20:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695699273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RLZ2Sm0jXt4JgiR3KwyVKPulSJY09nranm6CqIMSjuQ=;
        b=QMFIavHGIlU3dx2UPOtjmOwwS4qxb4ytlEuR9hC9EyzCJDNUaG4lWEGtckZlQhIkjtvE55
        TIc69d+LDiyFxMhw9Wys1o1kmyKdUekVYGNuj4UUEgO859rzi0g50RnU+3OJ0PwPWVCuAx
        7vwwDw4U5z1iSHMrSX7wJxU5gwa7DD4=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-204-2P30v0azPACA--5wHk9LKQ-1; Mon, 25 Sep 2023 23:34:31 -0400
X-MC-Unique: 2P30v0azPACA--5wHk9LKQ-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-50433ca6d81so9679276e87.3
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 20:34:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695699269; x=1696304069;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RLZ2Sm0jXt4JgiR3KwyVKPulSJY09nranm6CqIMSjuQ=;
        b=LkljdI6aRTRhRsLSUcmznC/Whr1wPDMwyQv8C1bjySZlgcRI5kD1E6E4IlKXRXjsns
         RFX+qLtSlh2AMoPdkr3E0ytiu3h6P1/yHMq3LRUiRErA1LGYnoZtgKzozIy85Sexk+UM
         2ZrL/+tFNFFJytuMf+hzcsIVAqL5l1Dz5A19y/tRYm4PysqKDcezB/kLNJf5GJBFldaS
         X7tSWYKivlFJ1hRi8VS3lluC731mcaYXEfB4VIR6iq5n1cRAhvdW2YYe9WE1oohDgefF
         5Ew+lGLRcSFZIIWrr3S5tI7qNjb+95tid56N6MHUOQm+eGXTeZ5875u6ZA1veuFShsSl
         S7Vg==
X-Gm-Message-State: AOJu0YxVKj5PQkorTjLTR2QafdcYvu1IHTsHHQabm2LJK/qXBSU6A7Fu
        czcg/dO8UKgsoc2szBuHJSM9XDpxyKjJjfKNgEmK37hDh5jsoXx3rUj7ca4TCt3pdFYiRvJr+8q
        Q5yaSpLo0kTiHZPthAlveWa3iZWM+
X-Received: by 2002:a19:2d56:0:b0:500:9ab8:b790 with SMTP id t22-20020a192d56000000b005009ab8b790mr5797360lft.60.1695699269581;
        Mon, 25 Sep 2023 20:34:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHqiM7aXmdkd2xeWF1oHQRrgm7Uv/ibMILXTfqsfhbYcfRo+PtW2EkI9b5YBS6E53q1EhEpn7fGVgQida+c7dg=
X-Received: by 2002:a19:2d56:0:b0:500:9ab8:b790 with SMTP id
 t22-20020a192d56000000b005009ab8b790mr5797349lft.60.1695699269194; Mon, 25
 Sep 2023 20:34:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230912130132.561193-1-dtatulea@nvidia.com> <20230912130132.561193-9-dtatulea@nvidia.com>
In-Reply-To: <20230912130132.561193-9-dtatulea@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 26 Sep 2023 11:34:18 +0800
Message-ID: <CACGkMEu9axhdajJ2qsjHqrYBX2L7HUqXEXAk3f3X9hv93+iq=w@mail.gmail.com>
Subject: Re: [PATCH 08/16] vdpa/mlx5: Rename mr destroy functions
To:     Dragos Tatulea <dtatulea@nvidia.com>
Cc:     =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 12, 2023 at 9:02=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia.com=
> wrote:
>
> Make mlx5_destroy_mr symmetric to mlx5_create_mr.
>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  drivers/vdpa/mlx5/core/mlx5_vdpa.h |  4 ++--
>  drivers/vdpa/mlx5/core/mr.c        |  6 +++---
>  drivers/vdpa/mlx5/net/mlx5_vnet.c  | 12 ++++++------
>  3 files changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/=
mlx5_vdpa.h
> index 554899a80241..e1e6e7aba50e 100644
> --- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
> +++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
> @@ -118,8 +118,8 @@ int mlx5_vdpa_handle_set_map(struct mlx5_vdpa_dev *mv=
dev, struct vhost_iotlb *io
>                              bool *change_map, unsigned int asid);
>  int mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb =
*iotlb,
>                         unsigned int asid);
> -void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev);
> -void mlx5_vdpa_destroy_mr_asid(struct mlx5_vdpa_dev *mvdev, unsigned int=
 asid);
> +void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev);
> +void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev, unsigned int asid=
);
>  int mlx5_vdpa_update_cvq_iotlb(struct mlx5_vdpa_dev *mvdev,
>                                 struct vhost_iotlb *iotlb,
>                                 unsigned int asid);
> diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
> index fde00497f4ad..00dcce190a1f 100644
> --- a/drivers/vdpa/mlx5/core/mr.c
> +++ b/drivers/vdpa/mlx5/core/mr.c
> @@ -507,7 +507,7 @@ static void _mlx5_vdpa_destroy_mr(struct mlx5_vdpa_de=
v *mvdev, unsigned int asid
>         mr->initialized =3D false;
>  }
>
> -void mlx5_vdpa_destroy_mr_asid(struct mlx5_vdpa_dev *mvdev, unsigned int=
 asid)
> +void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev, unsigned int asid=
)
>  {
>         struct mlx5_vdpa_mr *mr =3D &mvdev->mr;
>
> @@ -518,9 +518,9 @@ void mlx5_vdpa_destroy_mr_asid(struct mlx5_vdpa_dev *=
mvdev, unsigned int asid)
>         mutex_unlock(&mr->mkey_mtx);
>  }
>
> -void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev)
> +void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev)
>  {
> -       mlx5_vdpa_destroy_mr_asid(mvdev, mvdev->group2asid[MLX5_VDPA_DATA=
VQ_GROUP]);
> +       mlx5_vdpa_destroy_mr(mvdev, mvdev->group2asid[MLX5_VDPA_DATAVQ_GR=
OUP]);
>         prune_iotlb(mvdev);
>  }
>
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/ml=
x5_vnet.c
> index 061d8f7a661a..4d759ab96319 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -2644,7 +2644,7 @@ static int mlx5_vdpa_change_map(struct mlx5_vdpa_de=
v *mvdev,
>                 goto err_mr;
>
>         teardown_driver(ndev);
> -       mlx5_vdpa_destroy_mr_asid(mvdev, asid);
> +       mlx5_vdpa_destroy_mr(mvdev, asid);
>         err =3D mlx5_vdpa_create_mr(mvdev, iotlb, asid);
>         if (err)
>                 goto err_mr;
> @@ -2660,7 +2660,7 @@ static int mlx5_vdpa_change_map(struct mlx5_vdpa_de=
v *mvdev,
>         return 0;
>
>  err_setup:
> -       mlx5_vdpa_destroy_mr_asid(mvdev, asid);
> +       mlx5_vdpa_destroy_mr(mvdev, asid);
>  err_mr:
>         return err;
>  }
> @@ -2797,7 +2797,7 @@ static void mlx5_vdpa_set_status(struct vdpa_device=
 *vdev, u8 status)
>  err_driver:
>         unregister_link_notifier(ndev);
>  err_setup:
> -       mlx5_vdpa_destroy_mr(&ndev->mvdev);
> +       mlx5_vdpa_destroy_mr_resources(&ndev->mvdev);
>         ndev->mvdev.status |=3D VIRTIO_CONFIG_S_FAILED;
>  err_clear:
>         up_write(&ndev->reslock);
> @@ -2824,7 +2824,7 @@ static int mlx5_vdpa_reset(struct vdpa_device *vdev=
)
>         unregister_link_notifier(ndev);
>         teardown_driver(ndev);
>         clear_vqs_ready(ndev);
> -       mlx5_vdpa_destroy_mr(&ndev->mvdev);
> +       mlx5_vdpa_destroy_mr_resources(&ndev->mvdev);
>         ndev->mvdev.status =3D 0;
>         ndev->mvdev.suspended =3D false;
>         ndev->cur_num_vqs =3D 0;
> @@ -2944,7 +2944,7 @@ static void mlx5_vdpa_free(struct vdpa_device *vdev=
)
>         ndev =3D to_mlx5_vdpa_ndev(mvdev);
>
>         free_resources(ndev);
> -       mlx5_vdpa_destroy_mr(mvdev);
> +       mlx5_vdpa_destroy_mr_resources(mvdev);
>         if (!is_zero_ether_addr(ndev->config.mac)) {
>                 pfmdev =3D pci_get_drvdata(pci_physfn(mvdev->mdev->pdev))=
;
>                 mlx5_mpfs_del_mac(pfmdev, ndev->config.mac);
> @@ -3474,7 +3474,7 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *=
v_mdev, const char *name,
>  err_res2:
>         free_resources(ndev);
>  err_mr:
> -       mlx5_vdpa_destroy_mr(mvdev);
> +       mlx5_vdpa_destroy_mr_resources(mvdev);
>  err_res:
>         mlx5_vdpa_free_resources(&ndev->mvdev);
>  err_mpfs:
> --
> 2.41.0
>

