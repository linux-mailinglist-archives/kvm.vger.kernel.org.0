Return-Path: <kvm+bounces-25361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86FCF9647DF
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 16:19:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18F2B281A2A
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 14:19:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB66A1AED57;
	Thu, 29 Aug 2024 14:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GFFno2/v"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B8A1AD418
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 14:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724941130; cv=none; b=ZbXtmw4GLvMxbYRPOmHSn+QsAP6TLwfT31s+IPlMuBoqXKXK1eZ3fd3AiS5P9zA4WP4MPOcY5EkrWp2q8aiLnPw+zogAfEoCDlesUIqE5lKJd7+TFIxnuhOspyf90bpPO/FXnY505pcQRbmqKJzbmSqAkJY1CUbaAUXzRSoAat8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724941130; c=relaxed/simple;
	bh=xJNP5vrR8GfpfLwJtjfUAKx5jsEgeVULY0gNeKS3n1o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rYWIwJs6a5FMewvrUhnO7+vhIfNNBalVV9lSb2sSbjDRchATGzOtFsoa9MqxKb6tJjBbMSw3upPWvGcQl8L2Q+/17C3ZoKxgZ3zKOigg1pzygeYIzYxEs07UuZWWNvj/bYMldTWYr7GR4J213gWJkXHm0N5IwBu2v+lcfgcvWgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GFFno2/v; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724941127;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jYrWURiNhNxaDhZpfvFbKbwERayt+0+/jmKfxf9PB4c=;
	b=GFFno2/vabzaocTG9t8bEpKZ0LF4oFN9x6I8M2DT6WWoKLrlW7xv9ZwSTLGp36V130Irqs
	j20XClI4DeH41a4CJ8aCrLB+WskwqvzWqmX4Ci2I5/06pNshdzTL7P6R2LZcnDlQaF4Ger
	IRF83OJhL6Qzv9FIK7tZ9gLng0xUykk=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-wRxLZttNPIOsiyzz9ovCxw-1; Thu, 29 Aug 2024 10:18:45 -0400
X-MC-Unique: wRxLZttNPIOsiyzz9ovCxw-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-6ad97b9a0fbso15269377b3.0
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 07:18:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724941124; x=1725545924;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jYrWURiNhNxaDhZpfvFbKbwERayt+0+/jmKfxf9PB4c=;
        b=P9UcjUGYLl2yodxJbqNa7rpAzCZReaxGjFINcuu7CuuP1D5LALrZ1lgEoQi0D5Dy84
         qwOdjbvs9QsEt6foc3iMWDLQlbouseOcWCXFQmLNsOxYfs74BgOGHtLAgyTfbb2myBI9
         BXGXY1Fo8ObTMOuTXYbwZtDfdo6ELr8fwllH9V0bQbWY8nUDYP6yq8/mICF+yC6zX8DT
         w5fxmvfnxMDfON6ziMnuLEnBGjUKR4BsXneDVocw/SGjVl/gSoCQf2iQKQMIpM4QZtCY
         8IU/0kwT1zajFCH2wcQP9ohsYXDrszB/pOvUQ+OuqrQCceVsjJ8COehs1vfZS0q8/Szl
         8I1A==
X-Forwarded-Encrypted: i=1; AJvYcCUDqUDK9+lxsosS8oo2dy0B3hOZcdFZe9lBGScxpzYZuRZ2mnb/j6oBG5DlWcnEVX2iXhA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYMN616D9s98Y8r+9sw4BsydU0k1M4YXmG7YsRcmq+sd8mFL+N
	VcHU1oONQBqzwF2ZjchH6cdZutEgEFDFBbznh1am2YVzkF/MeElzFlFIVT67KJEFqM2Z2jLU2Mn
	gGTec0tcKXDK4r+mGCVJkm9oFMHqaRUAK1QcuBLphJNWkyl8+5wAMdP1V+zJUN/HKP/AfCCGTC+
	9/Yq2rdvjEni3sdfHX+SaTDE+s
X-Received: by 2002:a05:6902:260b:b0:e0b:6bb1:fba with SMTP id 3f1490d57ef6-e1a5ac957efmr2795157276.30.1724941124214;
        Thu, 29 Aug 2024 07:18:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEpF1PqlLutsjoAOxniJsGr7lS0v1cnWucZnw8FQwcS+ipQsyyw6OmZ1K70s0kquo8STj73Yc8uL2QRZq4gFvo=
X-Received: by 2002:a05:6902:260b:b0:e0b:6bb1:fba with SMTP id
 3f1490d57ef6-e1a5ac957efmr2795125276.30.1724941123845; Thu, 29 Aug 2024
 07:18:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240821114100.2261167-2-dtatulea@nvidia.com> <20240821114100.2261167-7-dtatulea@nvidia.com>
In-Reply-To: <20240821114100.2261167-7-dtatulea@nvidia.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Thu, 29 Aug 2024 16:18:08 +0200
Message-ID: <CAJaqyWfCeAmx7cZ49PCxwRmCFnS7cXigO294rLG7OtJNaaGqnQ@mail.gmail.com>
Subject: Re: [PATCH vhost 5/7] vdpa/mlx5: Rename mr_mtx -> lock
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
> Now that the mr resources have their own namespace in the
> struct, give the lock a clearer name.
>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>

Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

> ---
>  drivers/vdpa/mlx5/core/mlx5_vdpa.h |  2 +-
>  drivers/vdpa/mlx5/core/mr.c        | 20 ++++++++++----------
>  drivers/vdpa/mlx5/core/resources.c |  6 +++---
>  drivers/vdpa/mlx5/net/mlx5_vnet.c  |  4 ++--
>  4 files changed, 16 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/=
mlx5_vdpa.h
> index 5ae6deea2a8a..89b564cecddf 100644
> --- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
> +++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
> @@ -87,7 +87,7 @@ struct mlx5_vdpa_mr_resources {
>         struct mlx5_vdpa_mr *mr[MLX5_VDPA_NUM_AS];
>         unsigned int group2asid[MLX5_VDPA_NUMVQ_GROUPS];
>         struct list_head mr_list_head;
> -       struct mutex mr_mtx;
> +       struct mutex lock;
>  };
>
>  struct mlx5_vdpa_dev {
> diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
> index 2c8660e5c0de..f20f2a8a701d 100644
> --- a/drivers/vdpa/mlx5/core/mr.c
> +++ b/drivers/vdpa/mlx5/core/mr.c
> @@ -666,9 +666,9 @@ static void _mlx5_vdpa_put_mr(struct mlx5_vdpa_dev *m=
vdev,
>  void mlx5_vdpa_put_mr(struct mlx5_vdpa_dev *mvdev,
>                       struct mlx5_vdpa_mr *mr)
>  {
> -       mutex_lock(&mvdev->mres.mr_mtx);
> +       mutex_lock(&mvdev->mres.lock);
>         _mlx5_vdpa_put_mr(mvdev, mr);
> -       mutex_unlock(&mvdev->mres.mr_mtx);
> +       mutex_unlock(&mvdev->mres.lock);
>  }
>
>  static void _mlx5_vdpa_get_mr(struct mlx5_vdpa_dev *mvdev,
> @@ -683,9 +683,9 @@ static void _mlx5_vdpa_get_mr(struct mlx5_vdpa_dev *m=
vdev,
>  void mlx5_vdpa_get_mr(struct mlx5_vdpa_dev *mvdev,
>                       struct mlx5_vdpa_mr *mr)
>  {
> -       mutex_lock(&mvdev->mres.mr_mtx);
> +       mutex_lock(&mvdev->mres.lock);
>         _mlx5_vdpa_get_mr(mvdev, mr);
> -       mutex_unlock(&mvdev->mres.mr_mtx);
> +       mutex_unlock(&mvdev->mres.lock);
>  }
>
>  void mlx5_vdpa_update_mr(struct mlx5_vdpa_dev *mvdev,
> @@ -694,19 +694,19 @@ void mlx5_vdpa_update_mr(struct mlx5_vdpa_dev *mvde=
v,
>  {
>         struct mlx5_vdpa_mr *old_mr =3D mvdev->mres.mr[asid];
>
> -       mutex_lock(&mvdev->mres.mr_mtx);
> +       mutex_lock(&mvdev->mres.lock);
>
>         _mlx5_vdpa_put_mr(mvdev, old_mr);
>         mvdev->mres.mr[asid] =3D new_mr;
>
> -       mutex_unlock(&mvdev->mres.mr_mtx);
> +       mutex_unlock(&mvdev->mres.lock);
>  }
>
>  static void mlx5_vdpa_show_mr_leaks(struct mlx5_vdpa_dev *mvdev)
>  {
>         struct mlx5_vdpa_mr *mr;
>
> -       mutex_lock(&mvdev->mres.mr_mtx);
> +       mutex_lock(&mvdev->mres.lock);
>
>         list_for_each_entry(mr, &mvdev->mres.mr_list_head, mr_list) {
>
> @@ -715,7 +715,7 @@ static void mlx5_vdpa_show_mr_leaks(struct mlx5_vdpa_=
dev *mvdev)
>                                        mr, mr->mkey, refcount_read(&mr->r=
efcount));
>         }
>
> -       mutex_unlock(&mvdev->mres.mr_mtx);
> +       mutex_unlock(&mvdev->mres.lock);
>
>  }
>
> @@ -779,9 +779,9 @@ struct mlx5_vdpa_mr *mlx5_vdpa_create_mr(struct mlx5_=
vdpa_dev *mvdev,
>         if (!mr)
>                 return ERR_PTR(-ENOMEM);
>
> -       mutex_lock(&mvdev->mres.mr_mtx);
> +       mutex_lock(&mvdev->mres.lock);
>         err =3D _mlx5_vdpa_create_mr(mvdev, mr, iotlb);
> -       mutex_unlock(&mvdev->mres.mr_mtx);
> +       mutex_unlock(&mvdev->mres.lock);
>
>         if (err)
>                 goto out_err;
> diff --git a/drivers/vdpa/mlx5/core/resources.c b/drivers/vdpa/mlx5/core/=
resources.c
> index 3e3b3049cb08..fe2ca3458f6c 100644
> --- a/drivers/vdpa/mlx5/core/resources.c
> +++ b/drivers/vdpa/mlx5/core/resources.c
> @@ -256,7 +256,7 @@ int mlx5_vdpa_alloc_resources(struct mlx5_vdpa_dev *m=
vdev)
>                 mlx5_vdpa_warn(mvdev, "resources already allocated\n");
>                 return -EINVAL;
>         }
> -       mutex_init(&mvdev->mres.mr_mtx);
> +       mutex_init(&mvdev->mres.lock);
>         res->uar =3D mlx5_get_uars_page(mdev);
>         if (IS_ERR(res->uar)) {
>                 err =3D PTR_ERR(res->uar);
> @@ -301,7 +301,7 @@ int mlx5_vdpa_alloc_resources(struct mlx5_vdpa_dev *m=
vdev)
>  err_uctx:
>         mlx5_put_uars_page(mdev, res->uar);
>  err_uars:
> -       mutex_destroy(&mvdev->mres.mr_mtx);
> +       mutex_destroy(&mvdev->mres.lock);
>         return err;
>  }
>
> @@ -318,7 +318,7 @@ void mlx5_vdpa_free_resources(struct mlx5_vdpa_dev *m=
vdev)
>         dealloc_pd(mvdev, res->pdn, res->uid);
>         destroy_uctx(mvdev, res->uid);
>         mlx5_put_uars_page(mvdev->mdev, res->uar);
> -       mutex_destroy(&mvdev->mres.mr_mtx);
> +       mutex_destroy(&mvdev->mres.lock);
>         res->valid =3D false;
>  }
>
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/ml=
x5_vnet.c
> index 3e55a7f1afcd..8a51c492a62a 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -3639,10 +3639,10 @@ static int mlx5_set_group_asid(struct vdpa_device=
 *vdev, u32 group,
>
>         mvdev->mres.group2asid[group] =3D asid;
>
> -       mutex_lock(&mvdev->mres.mr_mtx);
> +       mutex_lock(&mvdev->mres.lock);
>         if (group =3D=3D MLX5_VDPA_CVQ_GROUP && mvdev->mres.mr[asid])
>                 err =3D mlx5_vdpa_update_cvq_iotlb(mvdev, mvdev->mres.mr[=
asid]->iotlb, asid);
> -       mutex_unlock(&mvdev->mres.mr_mtx);
> +       mutex_unlock(&mvdev->mres.lock);
>
>         return err;
>  }
> --
> 2.45.1
>


