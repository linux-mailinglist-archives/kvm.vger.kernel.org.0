Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81F7B7AE430
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 05:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233563AbjIZD34 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 23:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232661AbjIZD3w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 23:29:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C58193
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 20:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695698940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PZAhx7MFdkeBmGFe31AVlV3iO2EqSJG4TtChPwC6CuI=;
        b=fjvsoa+Ml4dQ2qD5gm5vNJh4QTZwkottC8QT0OqUOWq7CjMUDkmizKLRSg0s2b3RdpdRYw
        Kgvj/ynQabRYCs87LoeqwphVAg/IkW8n68LhgYjloYlidLUnV2OYxy0diDHoJ1nWV2op26
        sK8L+FEGvfE7lnqH01DPSIGwUJnsp1A=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-190-fDIZTLZSPseso5lKUPcPYQ-1; Mon, 25 Sep 2023 23:28:58 -0400
X-MC-Unique: fDIZTLZSPseso5lKUPcPYQ-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5041ae34ce4so10612509e87.0
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 20:28:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695698937; x=1696303737;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PZAhx7MFdkeBmGFe31AVlV3iO2EqSJG4TtChPwC6CuI=;
        b=VfbfOWTBliMSGUPLB1jWtjOGKQJr4zFm/sSKuc0D5wu+tfnYfv5lnFORgqY50IMgVv
         l0uNhsBZWQ2rOAFn63fzmR1aLAXn7WXYBreKRFTU9FvVFFfw8OsK56uZ3NF4U0CfGhvK
         feydreXhj+rSwKC7cxLXooc+wUSZGWrJYxuOqqaEIUIOIXQM5uAxNNYFst+GWx4xOwUQ
         C/wfK9Ph4CwBH8LKvyIzC5blmTJ30hyt+2lpJcjGuD++VlF3wboMQGm7n0gxdLisx7UH
         Vl4xFqiQsRWheiVf78UwsDcAKZ1j5/5RpJ6+mEtKaa8WhgvLn+iVFwntl2LopffJ314s
         +NSw==
X-Gm-Message-State: AOJu0Ywk1BQYBTZYanNoadAGN1iwvoDs/pwXk8kKB6uFOhlTRIRP6EQN
        6ZYkW1uQLaOnuvOuP1KpLZJbTBgwqpagINXa3kN+GPZ17DR7z4rhlHEtcmAy9vaDbxBZYIfH25g
        h2NvN6CRJS+onydkWNlm33VjapdGM
X-Received: by 2002:a05:6512:401a:b0:503:2e6:685e with SMTP id br26-20020a056512401a00b0050302e6685emr9229183lfb.14.1695698937285;
        Mon, 25 Sep 2023 20:28:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEWGjNYL9Nj97phWZA57NV0UhAnICMO0Ky6EU5to4ByQxb437UN1JumpShCANeB1L+1wbau4bm3GnFKZtgx7X8=
X-Received: by 2002:a05:6512:401a:b0:503:2e6:685e with SMTP id
 br26-20020a056512401a00b0050302e6685emr9229170lfb.14.1695698936966; Mon, 25
 Sep 2023 20:28:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230912130132.561193-1-dtatulea@nvidia.com> <20230912130132.561193-6-dtatulea@nvidia.com>
In-Reply-To: <20230912130132.561193-6-dtatulea@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 26 Sep 2023 11:28:45 +0800
Message-ID: <CACGkMEuB93-gmyCrfeubT5p-i-4M96UmkDJbuDMCAu5LXSyitA@mail.gmail.com>
Subject: Re: [PATCH 05/16] vdpa/mlx5: Decouple cvq iotlb handling from hw
 mapping code
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 12, 2023 at 9:02=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia.com=
> wrote:
>
> The handling of the cvq iotlb is currently coupled with the creation
> and destruction of the hardware mkeys (mr).
>
> This patch moves cvq iotlb handling into its own function and shifts it
> to a scope that is not related to mr handling. As cvq handling is just a
> prune_iotlb + dup_iotlb cycle, put it all in the same "update" function.
> Finally, the destruction path is handled by directly pruning the iotlb.
>
> After this move is done the ASID mr code can be collapsed into a single
> function.
>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> ---
>  drivers/vdpa/mlx5/core/mlx5_vdpa.h |  3 ++
>  drivers/vdpa/mlx5/core/mr.c        | 57 +++++++++++-------------------
>  drivers/vdpa/mlx5/net/mlx5_vnet.c  |  7 ++--
>  3 files changed, 28 insertions(+), 39 deletions(-)
>
> diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/=
mlx5_vdpa.h
> index 3748f027cfe9..554899a80241 100644
> --- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
> +++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
> @@ -120,6 +120,9 @@ int mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev, =
struct vhost_iotlb *iotlb,
>                         unsigned int asid);
>  void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev);
>  void mlx5_vdpa_destroy_mr_asid(struct mlx5_vdpa_dev *mvdev, unsigned int=
 asid);
> +int mlx5_vdpa_update_cvq_iotlb(struct mlx5_vdpa_dev *mvdev,
> +                               struct vhost_iotlb *iotlb,
> +                               unsigned int asid);
>  int mlx5_vdpa_create_dma_mr(struct mlx5_vdpa_dev *mvdev);
>
>  #define mlx5_vdpa_warn(__dev, format, ...)                              =
                           \
> diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
> index 7bd0883b8b25..fcb6ae32e9ed 100644
> --- a/drivers/vdpa/mlx5/core/mr.c
> +++ b/drivers/vdpa/mlx5/core/mr.c
> @@ -489,14 +489,6 @@ static void destroy_user_mr(struct mlx5_vdpa_dev *mv=
dev, struct mlx5_vdpa_mr *mr
>         }
>  }
>
> -static void _mlx5_vdpa_destroy_cvq_mr(struct mlx5_vdpa_dev *mvdev, unsig=
ned int asid)
> -{
> -       if (mvdev->group2asid[MLX5_VDPA_CVQ_GROUP] !=3D asid)
> -               return;
> -
> -       prune_iotlb(mvdev);
> -}
> -
>  static void _mlx5_vdpa_destroy_dvq_mr(struct mlx5_vdpa_dev *mvdev, unsig=
ned int asid)
>  {
>         struct mlx5_vdpa_mr *mr =3D &mvdev->mr;
> @@ -522,25 +514,14 @@ void mlx5_vdpa_destroy_mr_asid(struct mlx5_vdpa_dev=
 *mvdev, unsigned int asid)
>         mutex_lock(&mr->mkey_mtx);
>
>         _mlx5_vdpa_destroy_dvq_mr(mvdev, asid);
> -       _mlx5_vdpa_destroy_cvq_mr(mvdev, asid);
>
>         mutex_unlock(&mr->mkey_mtx);
>  }
>
>  void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev)
>  {
> -       mlx5_vdpa_destroy_mr_asid(mvdev, mvdev->group2asid[MLX5_VDPA_CVQ_=
GROUP]);
>         mlx5_vdpa_destroy_mr_asid(mvdev, mvdev->group2asid[MLX5_VDPA_DATA=
VQ_GROUP]);
> -}
> -
> -static int _mlx5_vdpa_create_cvq_mr(struct mlx5_vdpa_dev *mvdev,
> -                                   struct vhost_iotlb *iotlb,
> -                                   unsigned int asid)
> -{
> -       if (mvdev->group2asid[MLX5_VDPA_CVQ_GROUP] !=3D asid)
> -               return 0;
> -
> -       return dup_iotlb(mvdev, iotlb);
> +       prune_iotlb(mvdev);
>  }
>
>  static int _mlx5_vdpa_create_dvq_mr(struct mlx5_vdpa_dev *mvdev,
> @@ -572,22 +553,7 @@ static int _mlx5_vdpa_create_dvq_mr(struct mlx5_vdpa=
_dev *mvdev,
>  static int _mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
>                                 struct vhost_iotlb *iotlb, unsigned int a=
sid)
>  {
> -       int err;
> -
> -       err =3D _mlx5_vdpa_create_dvq_mr(mvdev, iotlb, asid);
> -       if (err)
> -               return err;
> -
> -       err =3D _mlx5_vdpa_create_cvq_mr(mvdev, iotlb, asid);
> -       if (err)
> -               goto out_err;
> -
> -       return 0;
> -
> -out_err:
> -       _mlx5_vdpa_destroy_dvq_mr(mvdev, asid);
> -
> -       return err;
> +       return _mlx5_vdpa_create_dvq_mr(mvdev, iotlb, asid);
>  }
>
>  int mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb =
*iotlb,
> @@ -620,7 +586,24 @@ int mlx5_vdpa_handle_set_map(struct mlx5_vdpa_dev *m=
vdev, struct vhost_iotlb *io
>         return err;
>  }
>
> +int mlx5_vdpa_update_cvq_iotlb(struct mlx5_vdpa_dev *mvdev,
> +                               struct vhost_iotlb *iotlb,
> +                               unsigned int asid)
> +{
> +       if (mvdev->group2asid[MLX5_VDPA_CVQ_GROUP] !=3D asid)
> +               return 0;
> +
> +       prune_iotlb(mvdev);
> +       return dup_iotlb(mvdev, iotlb);
> +}
> +
>  int mlx5_vdpa_create_dma_mr(struct mlx5_vdpa_dev *mvdev)
>  {
> -       return mlx5_vdpa_create_mr(mvdev, NULL, 0);
> +       int err;
> +
> +       err =3D mlx5_vdpa_create_mr(mvdev, NULL, 0);
> +       if (err)
> +               return err;
> +
> +       return mlx5_vdpa_update_cvq_iotlb(mvdev, NULL, 0);
>  }

Nit: Still a little bit coupling but anyhow:

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/ml=
x5_vnet.c
> index d34c19b4e139..061d8f7a661a 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -2884,10 +2884,13 @@ static int set_map_data(struct mlx5_vdpa_dev *mvd=
ev, struct vhost_iotlb *iotlb,
>                 return err;
>         }
>
> -       if (change_map)
> +       if (change_map) {
>                 err =3D mlx5_vdpa_change_map(mvdev, iotlb, asid);
> +               if (err)
> +                       return err;
> +       }
>
> -       return err;
> +       return mlx5_vdpa_update_cvq_iotlb(mvdev, iotlb, asid);
>  }
>
>  static int mlx5_vdpa_set_map(struct vdpa_device *vdev, unsigned int asid=
,
> --
> 2.41.0
>

