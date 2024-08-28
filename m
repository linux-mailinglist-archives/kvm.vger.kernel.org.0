Return-Path: <kvm+bounces-25244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0853C962727
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 14:35:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2DA0C1C23003
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 12:35:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B18A176AB9;
	Wed, 28 Aug 2024 12:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OwG1NdzH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C05416C6AD
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 12:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724848500; cv=none; b=K8/d+F4qj9g0vYgCspBe1I+ndpeOXlRUQDg7BVxyyoiNyAAxAEWZWXumCaRHaGz7vSNVxlIACBPeIMxCXssYrinqym15wrdhYKfKo0dyPdfS4comwhB+tti6BCtU8Tk97mhvYssotIWKXU+HDOQOMe1NzKjAb7Y0VFqnfQtORFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724848500; c=relaxed/simple;
	bh=xr9rCmalwTDHQASNbbRaXPrtw5doK9XNIb6YW2DH0Qg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZwoIv1UfB33tKzLSdIWkjdAWpk1VxDFdPUrxj7ks0ca4D/C1/EiQ+9VWERb3xHOWDrJiB7gqfkv+zPHSAFxC1aELumrHk+7uXNglAM+KDwTE1zSCPm8v6NseiPmDFDddcX7MV0j4HLXEfNtvqL41nxd8WzqgriGtq1xiiT+VhpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OwG1NdzH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724848497;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bKgQdLYmvUO4rlMn7GgO0+K/4t1iYIvHSsifkH21neI=;
	b=OwG1NdzH3oLUnQkNtSxDnjKlXxt1MmuY8zbaR0qmER1q6HxfFoUlg0z134tVWXKKIH5OdG
	CamiNXjVfZ4/51QS4DoTRXrOau9p4Sv7keErs9ZdxEbadEypDAaMSlsCB4GQoeF7uD25Jp
	rrmln7LKi2zgXdXn3nJryVkjh92oyKc=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-358-wKZfrkQjOuePb00Lr67KIQ-1; Wed, 28 Aug 2024 08:34:56 -0400
X-MC-Unique: wKZfrkQjOuePb00Lr67KIQ-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-6b2822668c2so128751647b3.1
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 05:34:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724848496; x=1725453296;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bKgQdLYmvUO4rlMn7GgO0+K/4t1iYIvHSsifkH21neI=;
        b=QeNed+dyMbATYM/z+rxBj7Yh2FOhVonQEXz3GPorpR+r4W+CgJFSauEZv1rBHbO5mV
         5U3JHOOvNPZPvt81mRURknxh6THZMmPedefjRC4glmHPuT/QuUM8nwIN7XQP9jN9mm6h
         8wUhhhohf2J/eoC81PYqrSZWhZ5CQYg1aEzvcczauSkIRF4mgPcr8YyzOlFFzBrRhSsD
         7k9h+s8VuyhywrRxOTyMzEuAPYTLjws65R0MvgHhfptruEOFiHGzjLyiRyWs2TkwG1zd
         Fcm+J2+IHSPKhZs/7/v5ODg32LjEsRLlreKnOUTLH4exP9Dfi8FV635pOfCg7yvmhcU7
         xY9Q==
X-Forwarded-Encrypted: i=1; AJvYcCXEpq0mHTWaIhV3vopxm2pxUZnKZzQ8TFAT19+j5VStV7aeONwZuu4KAKHYUddrKtJvKPE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyz7Mp+rM1jLrtjChL23VW2ViFTFq6hYNoJ6c1OKVQJ4MuEiVL2
	skeGoT+3fPRoKCDZOTmfLIepEy2joAF25RDaNtDur1yh7KS464sy0n0oNDT3m0JCi/tYsD0tr6h
	2cS7uYCAHHQ8DAqXp/lWKhfsbP6yN+ViSr8q48KtkHcV2Jj/kVVjWgk70viZ1jMZ2JUQI+VyqLO
	B35miYzRWKAKJIg5p1cpMTrK1m
X-Received: by 2002:a05:690c:2e05:b0:6b1:a965:4ddf with SMTP id 00721157ae682-6d1706f1265mr15266617b3.27.1724848495902;
        Wed, 28 Aug 2024 05:34:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IErDi/VtEGwo7N8x5mgE4Nl+/vuGpwZNUQLTxIhjgArE0tBJVoTCPNR1B97kg1Gan26xVVCBRWytq5JidxUZyQ=
X-Received: by 2002:a05:690c:2e05:b0:6b1:a965:4ddf with SMTP id
 00721157ae682-6d1706f1265mr15266457b3.27.1724848495614; Wed, 28 Aug 2024
 05:34:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240816090159.1967650-1-dtatulea@nvidia.com> <20240816090159.1967650-4-dtatulea@nvidia.com>
In-Reply-To: <20240816090159.1967650-4-dtatulea@nvidia.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Wed, 28 Aug 2024 14:34:19 +0200
Message-ID: <CAJaqyWd=Nhd5e=0VTb+HQJdCS1QW+XPih2UeACDXhAf+pyo20A@mail.gmail.com>
Subject: Re: [PATCH vhost v2 03/10] vdpa/mlx5: Introduce async fw command wrapper
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	virtualization@lists.linux-foundation.org, Si-Wei Liu <si-wei.liu@oracle.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Gal Pressman <gal@nvidia.com>, 
	Parav Pandit <parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Tariq Toukan <tariqt@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 16, 2024 at 11:02=E2=80=AFAM Dragos Tatulea <dtatulea@nvidia.co=
m> wrote:
>
> Introduce a new function mlx5_vdpa_exec_async_cmds() which
> wraps the mlx5_core async firmware command API in a way
> that will be used to parallelize certain operation in this
> driver.
>
> The wrapper deals with the case when mlx5_cmd_exec_cb() returns
> EBUSY due to the command being throttled.
>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

> ---
>  drivers/vdpa/mlx5/core/mlx5_vdpa.h | 15 ++++++
>  drivers/vdpa/mlx5/core/resources.c | 73 ++++++++++++++++++++++++++++++
>  2 files changed, 88 insertions(+)
>
> diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/=
mlx5_vdpa.h
> index 424d445ebee4..b34e9b93d56e 100644
> --- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
> +++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
> @@ -105,6 +105,18 @@ struct mlx5_vdpa_dev {
>         bool suspended;
>  };
>
> +struct mlx5_vdpa_async_cmd {
> +       int err;
> +       struct mlx5_async_work cb_work;
> +       struct completion cmd_done;
> +
> +       void *in;
> +       size_t inlen;
> +
> +       void *out;
> +       size_t outlen;
> +};
> +
>  int mlx5_vdpa_create_tis(struct mlx5_vdpa_dev *mvdev, void *in, u32 *tis=
n);
>  void mlx5_vdpa_destroy_tis(struct mlx5_vdpa_dev *mvdev, u32 tisn);
>  int mlx5_vdpa_create_rqt(struct mlx5_vdpa_dev *mvdev, void *in, int inle=
n, u32 *rqtn);
> @@ -134,6 +146,9 @@ int mlx5_vdpa_update_cvq_iotlb(struct mlx5_vdpa_dev *=
mvdev,
>                                 unsigned int asid);
>  int mlx5_vdpa_create_dma_mr(struct mlx5_vdpa_dev *mvdev);
>  int mlx5_vdpa_reset_mr(struct mlx5_vdpa_dev *mvdev, unsigned int asid);
> +int mlx5_vdpa_exec_async_cmds(struct mlx5_vdpa_dev *mvdev,
> +                             struct mlx5_vdpa_async_cmd *cmds,
> +                             int num_cmds);
>
>  #define mlx5_vdpa_err(__dev, format, ...)                               =
                           \
>         dev_err((__dev)->mdev->device, "%s:%d:(pid %d) error: " format, _=
_func__, __LINE__,        \
> diff --git a/drivers/vdpa/mlx5/core/resources.c b/drivers/vdpa/mlx5/core/=
resources.c
> index 5c5a41b64bfc..22ea32fe007b 100644
> --- a/drivers/vdpa/mlx5/core/resources.c
> +++ b/drivers/vdpa/mlx5/core/resources.c
> @@ -321,3 +321,76 @@ void mlx5_vdpa_free_resources(struct mlx5_vdpa_dev *=
mvdev)
>         mutex_destroy(&mvdev->mr_mtx);
>         res->valid =3D false;
>  }
> +
> +static void virtqueue_cmd_callback(int status, struct mlx5_async_work *c=
ontext)
> +{
> +       struct mlx5_vdpa_async_cmd *cmd =3D
> +               container_of(context, struct mlx5_vdpa_async_cmd, cb_work=
);
> +
> +       cmd->err =3D mlx5_cmd_check(context->ctx->dev, status, cmd->in, c=
md->out);
> +       complete(&cmd->cmd_done);
> +}
> +
> +static int issue_async_cmd(struct mlx5_vdpa_dev *mvdev,
> +                          struct mlx5_vdpa_async_cmd *cmds,
> +                          int issued,
> +                          int *completed)
> +
> +{
> +       struct mlx5_vdpa_async_cmd *cmd =3D &cmds[issued];
> +       int err;
> +
> +retry:
> +       err =3D mlx5_cmd_exec_cb(&mvdev->async_ctx,
> +                              cmd->in, cmd->inlen,
> +                              cmd->out, cmd->outlen,
> +                              virtqueue_cmd_callback,
> +                              &cmd->cb_work);
> +       if (err =3D=3D -EBUSY) {
> +               if (*completed < issued) {
> +                       /* Throttled by own commands: wait for oldest com=
pletion. */
> +                       wait_for_completion(&cmds[*completed].cmd_done);
> +                       (*completed)++;
> +
> +                       goto retry;
> +               } else {
> +                       /* Throttled by external commands: switch to sync=
 api. */
> +                       err =3D mlx5_cmd_exec(mvdev->mdev,
> +                                           cmd->in, cmd->inlen,
> +                                           cmd->out, cmd->outlen);
> +                       if (!err)
> +                               (*completed)++;
> +               }
> +       }
> +
> +       return err;
> +}
> +
> +int mlx5_vdpa_exec_async_cmds(struct mlx5_vdpa_dev *mvdev,
> +                             struct mlx5_vdpa_async_cmd *cmds,
> +                             int num_cmds)
> +{
> +       int completed =3D 0;
> +       int issued =3D 0;
> +       int err =3D 0;
> +
> +       for (int i =3D 0; i < num_cmds; i++)
> +               init_completion(&cmds[i].cmd_done);
> +
> +       while (issued < num_cmds) {
> +
> +               err =3D issue_async_cmd(mvdev, cmds, issued, &completed);
> +               if (err) {
> +                       mlx5_vdpa_err(mvdev, "error issuing command %d of=
 %d: %d\n",
> +                                     issued, num_cmds, err);
> +                       break;
> +               }
> +
> +               issued++;
> +       }
> +
> +       while (completed < issued)
> +               wait_for_completion(&cmds[completed++].cmd_done);
> +
> +       return err;
> +}
> --
> 2.45.1
>


