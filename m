Return-Path: <kvm+bounces-25245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 07E9896272F
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 14:35:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8CD081F244E4
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 12:35:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 990A8179953;
	Wed, 28 Aug 2024 12:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ByoKAi9l"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8C9176248
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 12:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724848528; cv=none; b=Rg+4OGx2xqfN1z4f6pV6iwz7C3bT6E4qzqEH8dUQWzEuENG8Xf4uxPvnUmLd3aS5HUj4tsaZxgy1Q8Tia4NLkmNueDeOtGON7zvA6pbShO/FNFTH2G6SFdgpDMhKvX+VNuhU1QvblmM5OPdhPauu6f4kUebTIkI6u89y3v0u8Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724848528; c=relaxed/simple;
	bh=pkTUWmRQFLa9m8fyfX7M5w8U5oFylxXjc19HSUHTMZE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MUPDHc1d33++5ESBk24DopOVq2WsVj5CtLur4wl3tQcuwkoBeGi/afaoU1D0TbweFFYrwQFdDRtSdaTFQZUgPlF8TZ+YOndudXmDCfBAOLxBo1A8cQR9TcLWGJFMH7KjbP2kCStcpvhiFTnRc+yKGqtBsiUWpCQL3Nmmv2Zsk7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ByoKAi9l; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724848526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=448jSBQY1QAGqG/ajBiJUNEEbDhOpCTA4koFc5yudJE=;
	b=ByoKAi9lzMqEa6xCwm3mkP6H+hkNP/WHfJ/WeTB6FMMtL3tY/3zl038sIbpdc0lVpgiyng
	v675T9LPlem+D8SSwAdG1DMpNgGAcfLtKeGablXMMuP8W3OXSqZqmp0cgFKmVSCrD/f6yo
	b6qjclc9g9RErVxDxVDdovas82HWGZ8=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-367-XIurOURoPQuy5o_wyGLvPw-1; Wed, 28 Aug 2024 08:35:23 -0400
X-MC-Unique: XIurOURoPQuy5o_wyGLvPw-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-6b8f13f2965so142260897b3.1
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 05:35:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724848523; x=1725453323;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=448jSBQY1QAGqG/ajBiJUNEEbDhOpCTA4koFc5yudJE=;
        b=NraRAgoR3Cf8zfAkeqHCSVfnbskk2MmIEzvlljZjH6P2BBHx3jm80LtJJGq586kyFy
         OhtOfznfgr9NqtCkt0aBSdXTdUiL9CRmEi8ZpwFMJz25iPcyR/cfQhHgUSd212N7LdKr
         ETWzrNTbYOoPcNg0KIFbMgFa/mc2wn+gMjdsOVvpR/EBkSs9tx15Rm8vu8rxbg9Y2O8M
         Wi9egzIiuBBIBze6aKe+FeXBP/To0Yayt2xbRqXiilQYnzMeUJSsghDmAkfSR9DxaUFE
         lHJOB5mcTBgYha2aswGceXITyvAQrLfshQzr3EJTxxJ3Fi04anklcNCDGgJ7/LIeMKyX
         5b9Q==
X-Forwarded-Encrypted: i=1; AJvYcCXAdmkzg/iAPhKtOZj/BjaBi+bvcnphNOLAgQSv60ub8/dEwTYcYyJdrwVweRDrP1wkKQg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbsLQtKNKn6R5mJ6U4WqaZvQy6SsQOOTyl3GvT86mjyaltS2dT
	DuliXNrkimqVPBh/hoGEFK+i0qCFIEmwAOc7q9ZQ4mN3BeqKJFG2sztCTJ25VtcB13P13iRKPX9
	J2nJw31NGdiHN2AoEM294bhGMzjnTptYyTGF1BwMft6p+Rz3r94TN2R6QhxAmdA3Ydianfmzrh3
	vqjHIe6Jh/+VisnwnXhwrEdauQ
X-Received: by 2002:a05:690c:39b:b0:6c7:7585:8ff5 with SMTP id 00721157ae682-6c775859402mr193979957b3.25.1724848522790;
        Wed, 28 Aug 2024 05:35:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFm1ORVz+U6MI7poaMV2InuFgCPre541FhUIbC0ptWZTNlU6fujUvtySh/Lz22CIHrRkYeHEQFQPDDrKYWe5qQ=
X-Received: by 2002:a05:690c:39b:b0:6c7:7585:8ff5 with SMTP id
 00721157ae682-6c775859402mr193979647b3.25.1724848522373; Wed, 28 Aug 2024
 05:35:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240816090159.1967650-1-dtatulea@nvidia.com> <20240816090159.1967650-5-dtatulea@nvidia.com>
In-Reply-To: <20240816090159.1967650-5-dtatulea@nvidia.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Wed, 28 Aug 2024 14:34:46 +0200
Message-ID: <CAJaqyWfc9iq7UvDGr5BgpUSGHGL4geQxuka1CstvSxQXiaoeEA@mail.gmail.com>
Subject: Re: [PATCH vhost v2 04/10] vdpa/mlx5: Use async API for vq query command
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
> Switch firmware vq query command to be issued via the async API to
> allow future parallelization.
>
> For now the command is still serial but the infrastructure is there
> to issue commands in parallel, including ratelimiting the number
> of issued async commands to firmware.
>
> A later patch will switch to issuing more commands at a time.
>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

> ---
>  drivers/vdpa/mlx5/core/mlx5_vdpa.h |   2 +
>  drivers/vdpa/mlx5/net/mlx5_vnet.c  | 101 ++++++++++++++++++++++-------
>  2 files changed, 78 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/=
mlx5_vdpa.h
> index b34e9b93d56e..24fa00afb24f 100644
> --- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
> +++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
> @@ -103,6 +103,8 @@ struct mlx5_vdpa_dev {
>         struct workqueue_struct *wq;
>         unsigned int group2asid[MLX5_VDPA_NUMVQ_GROUPS];
>         bool suspended;
> +
> +       struct mlx5_async_ctx async_ctx;
>  };
>
>  struct mlx5_vdpa_async_cmd {
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/ml=
x5_vnet.c
> index 12133e5d1285..413b24398ef2 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1184,40 +1184,87 @@ struct mlx5_virtq_attr {
>         u16 used_index;
>  };
>
> -static int query_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_=
virtqueue *mvq,
> -                          struct mlx5_virtq_attr *attr)
> -{
> -       int outlen =3D MLX5_ST_SZ_BYTES(query_virtio_net_q_out);
> -       u32 in[MLX5_ST_SZ_DW(query_virtio_net_q_in)] =3D {};
> -       void *out;
> -       void *obj_context;
> -       void *cmd_hdr;
> -       int err;
> -
> -       out =3D kzalloc(outlen, GFP_KERNEL);
> -       if (!out)
> -               return -ENOMEM;
> +struct mlx5_virtqueue_query_mem {
> +       u8 in[MLX5_ST_SZ_BYTES(query_virtio_net_q_in)];
> +       u8 out[MLX5_ST_SZ_BYTES(query_virtio_net_q_out)];
> +};
>
> -       cmd_hdr =3D MLX5_ADDR_OF(query_virtio_net_q_in, in, general_obj_i=
n_cmd_hdr);
> +static void fill_query_virtqueue_cmd(struct mlx5_vdpa_net *ndev,
> +                                    struct mlx5_vdpa_virtqueue *mvq,
> +                                    struct mlx5_virtqueue_query_mem *cmd=
)
> +{
> +       void *cmd_hdr =3D MLX5_ADDR_OF(query_virtio_net_q_in, cmd->in, ge=
neral_obj_in_cmd_hdr);
>
>         MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, opcode, MLX5_CMD_OP_QUE=
RY_GENERAL_OBJECT);
>         MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, obj_type, MLX5_OBJ_TYPE=
_VIRTIO_NET_Q);
>         MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, obj_id, mvq->virtq_id);
>         MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, uid, ndev->mvdev.res.ui=
d);
> -       err =3D mlx5_cmd_exec(ndev->mvdev.mdev, in, sizeof(in), out, outl=
en);
> -       if (err)
> -               goto err_cmd;
> +}
> +
> +static void query_virtqueue_end(struct mlx5_vdpa_net *ndev,
> +                               struct mlx5_virtqueue_query_mem *cmd,
> +                               struct mlx5_virtq_attr *attr)
> +{
> +       void *obj_context =3D MLX5_ADDR_OF(query_virtio_net_q_out, cmd->o=
ut, obj_context);
>
> -       obj_context =3D MLX5_ADDR_OF(query_virtio_net_q_out, out, obj_con=
text);
>         memset(attr, 0, sizeof(*attr));
>         attr->state =3D MLX5_GET(virtio_net_q_object, obj_context, state)=
;
>         attr->available_index =3D MLX5_GET(virtio_net_q_object, obj_conte=
xt, hw_available_index);
>         attr->used_index =3D MLX5_GET(virtio_net_q_object, obj_context, h=
w_used_index);
> -       kfree(out);
> -       return 0;
> +}
>
> -err_cmd:
> -       kfree(out);
> +static int query_virtqueues(struct mlx5_vdpa_net *ndev,
> +                           int start_vq,
> +                           int num_vqs,
> +                           struct mlx5_virtq_attr *attrs)
> +{
> +       struct mlx5_vdpa_dev *mvdev =3D &ndev->mvdev;
> +       struct mlx5_virtqueue_query_mem *cmd_mem;
> +       struct mlx5_vdpa_async_cmd *cmds;
> +       int err =3D 0;
> +
> +       WARN(start_vq + num_vqs > mvdev->max_vqs, "query vq range invalid=
 [%d, %d), max_vqs: %u\n",
> +            start_vq, start_vq + num_vqs, mvdev->max_vqs);
> +
> +       cmds =3D kvcalloc(num_vqs, sizeof(*cmds), GFP_KERNEL);
> +       cmd_mem =3D kvcalloc(num_vqs, sizeof(*cmd_mem), GFP_KERNEL);
> +       if (!cmds || !cmd_mem) {
> +               err =3D -ENOMEM;
> +               goto done;
> +       }
> +
> +       for (int i =3D 0; i < num_vqs; i++) {
> +               cmds[i].in =3D &cmd_mem[i].in;
> +               cmds[i].inlen =3D sizeof(cmd_mem[i].in);
> +               cmds[i].out =3D &cmd_mem[i].out;
> +               cmds[i].outlen =3D sizeof(cmd_mem[i].out);
> +               fill_query_virtqueue_cmd(ndev, &ndev->vqs[start_vq + i], =
&cmd_mem[i]);
> +       }
> +
> +       err =3D mlx5_vdpa_exec_async_cmds(&ndev->mvdev, cmds, num_vqs);
> +       if (err) {
> +               mlx5_vdpa_err(mvdev, "error issuing query cmd for vq rang=
e [%d, %d): %d\n",
> +                             start_vq, start_vq + num_vqs, err);
> +               goto done;
> +       }
> +
> +       for (int i =3D 0; i < num_vqs; i++) {
> +               struct mlx5_vdpa_async_cmd *cmd =3D &cmds[i];
> +               int vq_idx =3D start_vq + i;
> +
> +               if (cmd->err) {
> +                       mlx5_vdpa_err(mvdev, "query vq %d failed, err: %d=
\n", vq_idx, err);
> +                       if (!err)
> +                               err =3D cmd->err;
> +                       continue;
> +               }
> +
> +               query_virtqueue_end(ndev, &cmd_mem[i], &attrs[i]);
> +       }
> +
> +done:
> +       kvfree(cmd_mem);
> +       kvfree(cmds);
>         return err;
>  }
>
> @@ -1542,7 +1589,7 @@ static int suspend_vq(struct mlx5_vdpa_net *ndev, s=
truct mlx5_vdpa_virtqueue *mv
>                 return err;
>         }
>
> -       err =3D query_virtqueue(ndev, mvq, &attr);
> +       err =3D query_virtqueues(ndev, mvq->index, 1, &attr);
>         if (err) {
>                 mlx5_vdpa_err(&ndev->mvdev, "failed to query virtqueue, e=
rr: %d\n", err);
>                 return err;
> @@ -2528,7 +2575,7 @@ static int mlx5_vdpa_get_vq_state(struct vdpa_devic=
e *vdev, u16 idx, struct vdpa
>                 return 0;
>         }
>
> -       err =3D query_virtqueue(ndev, mvq, &attr);
> +       err =3D query_virtqueues(ndev, mvq->index, 1, &attr);
>         if (err) {
>                 mlx5_vdpa_err(mvdev, "failed to query virtqueue\n");
>                 return err;
> @@ -2879,7 +2926,7 @@ static int save_channel_info(struct mlx5_vdpa_net *=
ndev, struct mlx5_vdpa_virtqu
>         int err;
>
>         if (mvq->initialized) {
> -               err =3D query_virtqueue(ndev, mvq, &attr);
> +               err =3D query_virtqueues(ndev, mvq->index, 1, &attr);
>                 if (err)
>                         return err;
>         }
> @@ -3854,6 +3901,8 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *=
v_mdev, const char *name,
>                 ndev->rqt_size =3D 1;
>         }
>
> +       mlx5_cmd_init_async_ctx(mdev, &mvdev->async_ctx);
> +
>         ndev->mvdev.mlx_features =3D device_features;
>         mvdev->vdev.dma_dev =3D &mdev->pdev->dev;
>         err =3D mlx5_vdpa_alloc_resources(&ndev->mvdev);
> @@ -3935,6 +3984,8 @@ static void mlx5_vdpa_dev_del(struct vdpa_mgmt_dev =
*v_mdev, struct vdpa_device *
>         mvdev->wq =3D NULL;
>         destroy_workqueue(wq);
>         mgtdev->ndev =3D NULL;
> +
> +       mlx5_cmd_cleanup_async_ctx(&mvdev->async_ctx);
>  }
>
>  static const struct vdpa_mgmtdev_ops mdev_ops =3D {
> --
> 2.45.1
>


