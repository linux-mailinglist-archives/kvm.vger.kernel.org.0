Return-Path: <kvm+bounces-3128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D7C4800DAB
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 15:48:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 38B75B213AF
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 14:48:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 323853E46E;
	Fri,  1 Dec 2023 14:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c+LkHCZV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361CA129
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 06:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701442075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o0DKYjK3dHbWdZnT5RD7tpOx0HUXsQyGhREUzJYhZ0I=;
	b=c+LkHCZVbrmD+xZFzTUtlpM41Zrv/gBzoLKyygco7gQkQ4VduBw1EqKbL8VXDxbXCtGmKN
	D4UwHOi+iy+vOdebw2UIIExE7UdqlOXOGPBCDD807UW/Jcf51B6Bfbr35bjwc0Hidz0WEv
	4IVZ6x5mtLcKdfa/vJPeJfMnUj0ak1I=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-294-VgiyMg9tPiOkEO17l2cGkQ-1; Fri, 01 Dec 2023 09:47:53 -0500
X-MC-Unique: VgiyMg9tPiOkEO17l2cGkQ-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-5d42c43d8daso4679617b3.0
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 06:47:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701442072; x=1702046872;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o0DKYjK3dHbWdZnT5RD7tpOx0HUXsQyGhREUzJYhZ0I=;
        b=B00e2/EmrYl67gaVS7vGj11TlmvDshJ75IYWhXcuzOEayTmgD/oMRbNJ1kZ2lcnmmc
         ndQ+lJDOPhgPyKI28IFMoaZ2WPivZiy6oVjq4icr9B5iIHjFBgvTXI46Lxk52Ts4FkLK
         /gnbYCUhnDSM8kgUNYjraAXZmkDpjIurtLIut79Iur8HwUY8vgXPW/SZ9OpH6E2oBhNR
         u3PUMGXFBgrXsgA1YQoT0DEkonTiCHHdGjXsKqrOpicZbR6ZGgiAAxvinLpsUMaiIwQx
         CCotLKYfrGS570gzM9Lt6y+1JKEviwp0psVQYDwaX6F0owQMu6KgB+4ExplpPFf+SsE4
         qnVQ==
X-Gm-Message-State: AOJu0YybcUWxotKAvoN/4ifjW7f6a/+go4GW7O3vT9khSuZFz138Akvl
	eTH9fx60F7usFDVu1wN8aN56o/nMKGXd6YmzzEVEGb+td7mfTL6R0D93y3+8jAFZjWlRuoHZsLS
	3FTGlSBygJEc5jT4oyjXqciCu/U+Z
X-Received: by 2002:a05:690c:2e07:b0:5ce:723:ae79 with SMTP id et7-20020a05690c2e0700b005ce0723ae79mr18248089ywb.15.1701442072634;
        Fri, 01 Dec 2023 06:47:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE6DQyuGDAakubhth8noPl0UkdPsVbsGwXorIpn7CGnUTxYiRgTbbU+n27HzNui0D93AvLxUvxPpOLJR7x6Jy0=
X-Received: by 2002:a05:690c:2e07:b0:5ce:723:ae79 with SMTP id
 et7-20020a05690c2e0700b005ce0723ae79mr18248067ywb.15.1701442072363; Fri, 01
 Dec 2023 06:47:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231201104857.665737-1-dtatulea@nvidia.com> <20231201104857.665737-4-dtatulea@nvidia.com>
In-Reply-To: <20231201104857.665737-4-dtatulea@nvidia.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Fri, 1 Dec 2023 15:47:16 +0100
Message-ID: <CAJaqyWe_VZ8CsG5j75oAD1FdNi7dc4rLJwjm5AoQNBm4ABfAZA@mail.gmail.com>
Subject: Re: [PATCH vhost 3/7] vdpa/mlx5: Allow modifying multiple vq fields
 in one modify command
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Si-Wei Liu <si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Leon Romanovsky <leon@kernel.org>, virtualization@lists.linux-foundation.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Gal Pressman <galp@nvidia.com>, Parav Pandit <parav@nvidia.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 1, 2023 at 11:49=E2=80=AFAM Dragos Tatulea <dtatulea@nvidia.com=
> wrote:
>
> Add a bitmask variable that tracks hw vq field changes that
> are supposed to be modified on next hw vq change command.
>
> This will be useful to set multiple vq fields when resuming the vq.
>
> The state needs to remain as a parameter as it doesn't make sense to
> make it part of the vq struct: fw_state is updated only after a
> successful command.
>

I don't get this paragraph, "modified_fields" is a member of
"mlx5_vdpa_virtqueue". Am I missing something?


> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> ---
>  drivers/vdpa/mlx5/net/mlx5_vnet.c | 48 +++++++++++++++++++++++++------
>  1 file changed, 40 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/ml=
x5_vnet.c
> index 12ac3397f39b..d06285e46fe2 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -120,6 +120,9 @@ struct mlx5_vdpa_virtqueue {
>         u16 avail_idx;
>         u16 used_idx;
>         int fw_state;
> +
> +       u64 modified_fields;
> +
>         struct msi_map map;
>
>         /* keep last in the struct */
> @@ -1181,7 +1184,19 @@ static bool is_valid_state_change(int oldstate, in=
t newstate)
>         }
>  }
>
> -static int modify_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa=
_virtqueue *mvq, int state)
> +static bool modifiable_virtqueue_fields(struct mlx5_vdpa_virtqueue *mvq)
> +{
> +       /* Only state is always modifiable */
> +       if (mvq->modified_fields & ~MLX5_VIRTQ_MODIFY_MASK_STATE)
> +               return mvq->fw_state =3D=3D MLX5_VIRTIO_NET_Q_OBJECT_STAT=
E_INIT ||
> +                      mvq->fw_state =3D=3D MLX5_VIRTIO_NET_Q_OBJECT_STAT=
E_SUSPEND;
> +
> +       return true;
> +}
> +
> +static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
> +                           struct mlx5_vdpa_virtqueue *mvq,
> +                           int state)
>  {
>         int inlen =3D MLX5_ST_SZ_BYTES(modify_virtio_net_q_in);
>         u32 out[MLX5_ST_SZ_DW(modify_virtio_net_q_out)] =3D {};
> @@ -1193,6 +1208,9 @@ static int modify_virtqueue(struct mlx5_vdpa_net *n=
dev, struct mlx5_vdpa_virtque
>         if (mvq->fw_state =3D=3D MLX5_VIRTIO_NET_Q_OBJECT_NONE)
>                 return 0;
>
> +       if (!modifiable_virtqueue_fields(mvq))
> +               return -EINVAL;
> +

I'm ok with this change, but since modified_fields is (or will be) a
bitmap tracking changes to state, addresses, mkey, etc, doesn't have
more sense to check it like:

if (modified_fields & 1<<change_1_flag)
  // perform change 1
if (modified_fields & 1<<change_2_flag)
  // perform change 2
if (modified_fields & 1<<change_3_flag)
  // perform change 13
---

Instead of:
if (!modified_fields)
  return

if (modified_fields & 1<<change_1_flag)
  // perform change 1
if (modified_fields & 1<<change_2_flag)
  // perform change 2

// perform change 3, no checking, as it is the only possible value of
modified_fields
---

Or am I missing something?

The rest looks good to me.

>         if (!is_valid_state_change(mvq->fw_state, state))
>                 return -EINVAL;
>
> @@ -1208,17 +1226,28 @@ static int modify_virtqueue(struct mlx5_vdpa_net =
*ndev, struct mlx5_vdpa_virtque
>         MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, uid, ndev->mvdev.res.ui=
d);
>
>         obj_context =3D MLX5_ADDR_OF(modify_virtio_net_q_in, in, obj_cont=
ext);
> -       MLX5_SET64(virtio_net_q_object, obj_context, modify_field_select,
> -                  MLX5_VIRTQ_MODIFY_MASK_STATE);
> -       MLX5_SET(virtio_net_q_object, obj_context, state, state);
> +       if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_STATE)
> +               MLX5_SET(virtio_net_q_object, obj_context, state, state);
> +
> +       MLX5_SET64(virtio_net_q_object, obj_context, modify_field_select,=
 mvq->modified_fields);
>         err =3D mlx5_cmd_exec(ndev->mvdev.mdev, in, inlen, out, sizeof(ou=
t));
>         kfree(in);
>         if (!err)
>                 mvq->fw_state =3D state;
>
> +       mvq->modified_fields =3D 0;
> +
>         return err;
>  }
>
> +static int modify_virtqueue_state(struct mlx5_vdpa_net *ndev,
> +                                 struct mlx5_vdpa_virtqueue *mvq,
> +                                 unsigned int state)
> +{
> +       mvq->modified_fields |=3D MLX5_VIRTQ_MODIFY_MASK_STATE;
> +       return modify_virtqueue(ndev, mvq, state);
> +}
> +
>  static int counter_set_alloc(struct mlx5_vdpa_net *ndev, struct mlx5_vdp=
a_virtqueue *mvq)
>  {
>         u32 in[MLX5_ST_SZ_DW(create_virtio_q_counters_in)] =3D {};
> @@ -1347,7 +1376,7 @@ static int setup_vq(struct mlx5_vdpa_net *ndev, str=
uct mlx5_vdpa_virtqueue *mvq)
>                 goto err_vq;
>
>         if (mvq->ready) {
> -               err =3D modify_virtqueue(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJ=
ECT_STATE_RDY);
> +               err =3D modify_virtqueue_state(ndev, mvq, MLX5_VIRTIO_NET=
_Q_OBJECT_STATE_RDY);
>                 if (err) {
>                         mlx5_vdpa_warn(&ndev->mvdev, "failed to modify to=
 ready vq idx %d(%d)\n",
>                                        idx, err);
> @@ -1382,7 +1411,7 @@ static void suspend_vq(struct mlx5_vdpa_net *ndev, =
struct mlx5_vdpa_virtqueue *m
>         if (mvq->fw_state !=3D MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY)
>                 return;
>
> -       if (modify_virtqueue(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_STATE_SU=
SPEND))
> +       if (modify_virtqueue_state(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_ST=
ATE_SUSPEND))
>                 mlx5_vdpa_warn(&ndev->mvdev, "modify to suspend failed\n"=
);
>
>         if (query_virtqueue(ndev, mvq, &attr)) {
> @@ -1407,6 +1436,7 @@ static void teardown_vq(struct mlx5_vdpa_net *ndev,=
 struct mlx5_vdpa_virtqueue *
>                 return;
>
>         suspend_vq(ndev, mvq);
> +       mvq->modified_fields =3D 0;
>         destroy_virtqueue(ndev, mvq);
>         dealloc_vector(ndev, mvq);
>         counter_set_dealloc(ndev, mvq);
> @@ -2207,7 +2237,7 @@ static void mlx5_vdpa_set_vq_ready(struct vdpa_devi=
ce *vdev, u16 idx, bool ready
>         if (!ready) {
>                 suspend_vq(ndev, mvq);
>         } else {
> -               err =3D modify_virtqueue(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJ=
ECT_STATE_RDY);
> +               err =3D modify_virtqueue_state(ndev, mvq, MLX5_VIRTIO_NET=
_Q_OBJECT_STATE_RDY);
>                 if (err) {
>                         mlx5_vdpa_warn(mvdev, "modify VQ %d to ready fail=
ed (%d)\n", idx, err);
>                         ready =3D false;
> @@ -2804,8 +2834,10 @@ static void clear_vqs_ready(struct mlx5_vdpa_net *=
ndev)
>  {
>         int i;
>
> -       for (i =3D 0; i < ndev->mvdev.max_vqs; i++)
> +       for (i =3D 0; i < ndev->mvdev.max_vqs; i++) {
>                 ndev->vqs[i].ready =3D false;
> +               ndev->vqs[i].modified_fields =3D 0;
> +       }
>
>         ndev->mvdev.cvq.ready =3D false;
>  }
> --
> 2.42.0
>


