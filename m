Return-Path: <kvm+bounces-25364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BA6D9648B2
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 16:39:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 17B59B26BDE
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 14:38:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AC831B1405;
	Thu, 29 Aug 2024 14:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c5q0uDkz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E898C19049D
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 14:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724942301; cv=none; b=ZXbY/qedlV5wwT9vOUpaWzEiFUbc6CmwyEQ+0Cmk5dHoMRhhsvUoK6GmdvCquih0HeVSPFvK1Kg8Z1AzFldRWqqaALAnWDzpFGJHeQNBpDgPYUwOISCyDhsBK+8rSio78Kj8iJOGWYJy3bJwwtnW6u0soiWLZ72Ldii8Zz1GRKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724942301; c=relaxed/simple;
	bh=dQT+LA/IzZSB8C3sdyssDAKv/Xg3VRBV4cRfN3pDZrk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j6ld7FKgwrYfTjnLs5iLh5MkABvitf1R+KRa9F5kFe37q23ROvwyoV8m8sxQKYDyH/DaEmcx7L5nHDtyAyKXZmp75Ld9OAjJfKDa/hoWFreHB4RKpbtEtDYP950Yvdk/Mp3W9wy/2rxVbI1J/2fhFQfwZposk9iRKjSnn1ngHXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c5q0uDkz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724942298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a5UccTC0S6V3eGjBBJPNDrYhEx7B8yw4mGjSWxQn/Mg=;
	b=c5q0uDkzwp2Sw32J2CFXqqVSa5So9lc+h6NOAr6XTx2ZvLKZ2kyWhpo/uj7yAzOMTt6so7
	zeAb4yMMMaoACS8o3iq+jRREV1mquC5hSznrJKjEZpMSwWOCE6zhlucPYOs6iAewQY10ir
	6bm3fbuG7cIptgtURv4TR7PgjUM4C/U=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-412-DhHEpfgDOqmpa7gQywlRPA-1; Thu, 29 Aug 2024 10:38:16 -0400
X-MC-Unique: DhHEpfgDOqmpa7gQywlRPA-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a86824d2d12so70335766b.2
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 07:38:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724942295; x=1725547095;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a5UccTC0S6V3eGjBBJPNDrYhEx7B8yw4mGjSWxQn/Mg=;
        b=YGdluKSlpaAhGMX7wm8ZucT/Admn77j0R+B8YLo+z/sipFpCkKIbqGEuVHQ3YdUpdU
         RXrZbDNeZ1KZFsI1/sCVaIKHrMdRhWq+R4tfyoxZLDK2Vey83IFSh/aVncXuDHK3SoTQ
         V4dlMYbi7FuF6HgklCJHWw3SsldBnDUDAEr2oB7gV3jua5jxSLvFeDfYxjlD9Er6dd22
         kWHGKcW/shrGRXmFO9EXUuuEVLU1dX8WAaXCjcPnA7Kj2DBfARMg1z42osZzHVjHu8dR
         OmA3oUqmXSGiGLd2OveEYOFfRkbd9i9EaBebalpGbAA9NF+/u+3oBlA4EoxrJSl2oGAa
         h/yg==
X-Forwarded-Encrypted: i=1; AJvYcCU5tgmJyqOnNfsusghzr97Md2AjBBLS0f/3i6lIE1/vGfh4ymJctlCb/ynhj+sGZK01pmw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4Dt9TTQNFflXBK7BS31Dyms0fxW0f3fK81+1gxxA4TYPO5qWA
	fgPAxdqAJneM1wCwvRNkX+wJ8OXw2CbW96Gvc/RaZHYzoqD7auORTJrHHcFcTPaepKznjVpwYZA
	/15UUd0kFob7e7etNO8y6sfnnwek+Wbm9tQIn1OZjTk0ZrMNA9Zmpr+y2ykQsgJxbTgGX54tljE
	exSCuEblBLQWWEnT6ScO0POBp8
X-Received: by 2002:a17:907:6d03:b0:a86:84b8:1797 with SMTP id a640c23a62f3a-a897fad6213mr257355366b.67.1724942295422;
        Thu, 29 Aug 2024 07:38:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGsvC4E6UsmVy/Ze5IGvygaFHFdEutsQpGstF70/D4htNreS9do5qHupMeEjRpKTrCSdG9K4ofLbVE6EHTsEbU=
X-Received: by 2002:a17:907:6d03:b0:a86:84b8:1797 with SMTP id
 a640c23a62f3a-a897fad6213mr257349266b.67.1724942294844; Thu, 29 Aug 2024
 07:38:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240821114100.2261167-2-dtatulea@nvidia.com> <20240821114100.2261167-8-dtatulea@nvidia.com>
In-Reply-To: <20240821114100.2261167-8-dtatulea@nvidia.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Thu, 29 Aug 2024 16:37:37 +0200
Message-ID: <CAJaqyWe29MmDZgUkrOKibWN4MGjt+sWvsNfk6SeRHhEHPJYC5g@mail.gmail.com>
Subject: Re: [PATCH vhost 6/7] vdpa/mlx5: Introduce init/destroy for MR resources
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Si-Wei Liu <si-wei.liu@oracle.com>, virtualization@lists.linux-foundation.org, 
	Gal Pressman <gal@nvidia.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Parav Pandit <parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Cosmin Ratiu <cratiu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 21, 2024 at 1:42=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia.com=
> wrote:
>
> There's currently not a lot of action happening during
> the init/destroy of MR resources. But more will be added
> in the upcoming patches.

If the series doesn't receive new patches, it is just the next patch :).

>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
> ---
>  drivers/vdpa/mlx5/core/mlx5_vdpa.h |  2 ++
>  drivers/vdpa/mlx5/core/mr.c        | 17 +++++++++++++++++
>  drivers/vdpa/mlx5/core/resources.c |  3 ---
>  drivers/vdpa/mlx5/net/mlx5_vnet.c  | 10 ++++++++--
>  4 files changed, 27 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/=
mlx5_vdpa.h
> index 89b564cecddf..c3e17bc888e8 100644
> --- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
> +++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
> @@ -138,6 +138,8 @@ int mlx5_vdpa_create_mkey(struct mlx5_vdpa_dev *mvdev=
, u32 *mkey, u32 *in,
>  int mlx5_vdpa_destroy_mkey(struct mlx5_vdpa_dev *mvdev, u32 mkey);
>  struct mlx5_vdpa_mr *mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
>                                          struct vhost_iotlb *iotlb);
> +int mlx5_vdpa_init_mr_resources(struct mlx5_vdpa_dev *mvdev);
> +void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev);
>  void mlx5_vdpa_clean_mrs(struct mlx5_vdpa_dev *mvdev);
>  void mlx5_vdpa_get_mr(struct mlx5_vdpa_dev *mvdev,
>                       struct mlx5_vdpa_mr *mr);
> diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
> index f20f2a8a701d..ec75f165f832 100644
> --- a/drivers/vdpa/mlx5/core/mr.c
> +++ b/drivers/vdpa/mlx5/core/mr.c
> @@ -843,3 +843,20 @@ int mlx5_vdpa_reset_mr(struct mlx5_vdpa_dev *mvdev, =
unsigned int asid)
>
>         return 0;
>  }
> +
> +int mlx5_vdpa_init_mr_resources(struct mlx5_vdpa_dev *mvdev)
> +{
> +       struct mlx5_vdpa_mr_resources *mres =3D &mvdev->mres;
> +
> +       INIT_LIST_HEAD(&mres->mr_list_head);
> +       mutex_init(&mres->lock);
> +
> +       return 0;

I'd leave this function return void here and remove the caller error
control path.

> +}
> +
> +void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev)
> +{
> +       struct mlx5_vdpa_mr_resources *mres =3D &mvdev->mres;
> +
> +       mutex_destroy(&mres->lock);
> +}
> diff --git a/drivers/vdpa/mlx5/core/resources.c b/drivers/vdpa/mlx5/core/=
resources.c
> index fe2ca3458f6c..aeae31d0cefa 100644
> --- a/drivers/vdpa/mlx5/core/resources.c
> +++ b/drivers/vdpa/mlx5/core/resources.c
> @@ -256,7 +256,6 @@ int mlx5_vdpa_alloc_resources(struct mlx5_vdpa_dev *m=
vdev)
>                 mlx5_vdpa_warn(mvdev, "resources already allocated\n");
>                 return -EINVAL;
>         }
> -       mutex_init(&mvdev->mres.lock);
>         res->uar =3D mlx5_get_uars_page(mdev);
>         if (IS_ERR(res->uar)) {
>                 err =3D PTR_ERR(res->uar);
> @@ -301,7 +300,6 @@ int mlx5_vdpa_alloc_resources(struct mlx5_vdpa_dev *m=
vdev)
>  err_uctx:
>         mlx5_put_uars_page(mdev, res->uar);
>  err_uars:
> -       mutex_destroy(&mvdev->mres.lock);

Maybe it is just me, but this patch is also moving the lock lifetime
from mlx5_vdpa_alloc_resources / mlx5_vdpa_free_resources to
mlx5_vdpa_dev_add / mlx5_vdpa_free. I guess it has a justification we
can either clarify in the patch message or split in its own patch.

>         return err;
>  }
>
> @@ -318,7 +316,6 @@ void mlx5_vdpa_free_resources(struct mlx5_vdpa_dev *m=
vdev)
>         dealloc_pd(mvdev, res->pdn, res->uid);
>         destroy_uctx(mvdev, res->uid);
>         mlx5_put_uars_page(mvdev->mdev, res->uar);
> -       mutex_destroy(&mvdev->mres.lock);
>         res->valid =3D false;
>  }
>
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/ml=
x5_vnet.c
> index 8a51c492a62a..1cadcb05a5c7 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -3434,6 +3434,7 @@ static void mlx5_vdpa_free(struct vdpa_device *vdev=
)
>
>         free_fixed_resources(ndev);
>         mlx5_vdpa_clean_mrs(mvdev);
> +       mlx5_vdpa_destroy_mr_resources(&ndev->mvdev);
>         if (!is_zero_ether_addr(ndev->config.mac)) {
>                 pfmdev =3D pci_get_drvdata(pci_physfn(mvdev->mdev->pdev))=
;
>                 mlx5_mpfs_del_mac(pfmdev, ndev->config.mac);
> @@ -3962,12 +3963,15 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev=
 *v_mdev, const char *name,
>         if (err)
>                 goto err_mpfs;
>
> -       INIT_LIST_HEAD(&mvdev->mres.mr_list_head);
> +       err =3D mlx5_vdpa_init_mr_resources(mvdev);
> +       if (err)
> +               goto err_res;
> +

Extra newline here.

>
>         if (MLX5_CAP_GEN(mvdev->mdev, umem_uid_0)) {
>                 err =3D mlx5_vdpa_create_dma_mr(mvdev);
>                 if (err)
> -                       goto err_res;
> +                       goto err_mr_res;
>         }
>
>         err =3D alloc_fixed_resources(ndev);
> @@ -4009,6 +4013,8 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *=
v_mdev, const char *name,
>         free_fixed_resources(ndev);
>  err_mr:
>         mlx5_vdpa_clean_mrs(mvdev);
> +err_mr_res:
> +       mlx5_vdpa_destroy_mr_resources(mvdev);
>  err_res:
>         mlx5_vdpa_free_resources(&ndev->mvdev);
>  err_mpfs:
> --
> 2.45.1
>


