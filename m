Return-Path: <kvm+bounces-25246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A41D962737
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 14:36:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A33A41C23258
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 12:36:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DCF517AE00;
	Wed, 28 Aug 2024 12:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="brtMl5L1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FCC179956
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 12:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724848565; cv=none; b=gQl4VotWifdSAzLBH24m/Oobqeq99XvGJV4glEAnyAGrYEuN2zvyyq3KemRZT5WPrCCjAaOTqynRNa4n+iQU3SONxfSAmxQwVAu0HzoZ2GplQGBRQ9WmSRg0ACARNMAWbr0/vK513IbXEJ7loDmaxiDAaQOxmezsgfdLDrla49A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724848565; c=relaxed/simple;
	bh=+UomTK557DPD8AX1QY29P5N7WimZVOOzrwBNUv5uSu8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z2E8CnaXUWoyU/wYARW/lrMmyhFGbDiPjG64h8qWSSy9zAfXuxsL6xz01auOnpKu+li+xxeN68XrdT1WFi3/r36jgZKuIcINEsOyiPo8LEpV723qRsCaC3H2k3db4uiH08Hwvwa1+aVjG+Gu6uiL2OjOMselKSHILD4A1bhwLxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=brtMl5L1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724848562;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k2CSk6AojrJs/vMi6/mcwjEASE9tCQG7G88lkG5zp+w=;
	b=brtMl5L16LdP4GhyoUCLsD/k1yxfo3OtxTsFFs5LeuaWsEuUuOVUaP8H89fHq8wPDrDi3d
	H/SwLbZtZULRon9dXMB9VOhTvMBQzVhCrJ8S/c2qZlIzEt/WwjkFD6WybgmlT0rBHyaTUG
	NchuEK5iJ7OiN7m8KJDyrb6rR5eO6YA=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-225-J28mssVxPbeM_1nXm-q6uw-1; Wed, 28 Aug 2024 08:36:01 -0400
X-MC-Unique: J28mssVxPbeM_1nXm-q6uw-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-6b4270bdea3so147880717b3.3
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 05:36:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724848561; x=1725453361;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k2CSk6AojrJs/vMi6/mcwjEASE9tCQG7G88lkG5zp+w=;
        b=QMXtnEfWicTTC5mkixWCRd+o8xsXVvM3WFnYxZwqfAxzK30/++z+kaZAdhTOEGjLI5
         QNmLBe/lC8UJau/pMWjNVPTgUruD8N5mOJcsA+ipFitrTMREU8LuUB1duvCFDQi3w407
         BCrbYjvOQq2INvPIWLHqyvsJW9sXKh621WvDNc42+QX4ugT4W0UfsmFe7liJVNeyFvFP
         UCoLw3WMT31/Mx+HEYIqyAswTRJAmhkBcHE1CltA6dg1oEjn92Xo9RJctYOjz1uaTQRT
         PUy+axXb6YZMGLiKlVRkeSVnd70cVkrxz3wXmaJz+lmAu3lAQOt1k9y7QKGx0BwwDS3Z
         ckFQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdKGPCbYgVpPzrHETjuGaoPgaInfXIGrqiLRu5evjEMKaLO6ZQg6Id8LJN6ArJWkKfYgs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsPRDNTznvDBV2Ic53Sq+ZcesePsL3SSkbMZvhxM/QjXT0iOU7
	Dzm4d2LIoX7vzM462COBPfCOqICUq/qOEUm7AlX5uGsq9cszvaLqtO5zYKuRhXiTH1YQFTHWvWn
	gsOiqbQpOKpJUND2i7wxnArUvV6DWo6QwSWf+b1y6rQx+KH/H/1LAgaxlZstmDcgvtSjuklr1kY
	c79XqBqN6RIVmhD48R/bhEKHV9
X-Received: by 2002:a05:690c:6603:b0:6b2:6cd4:7fa5 with SMTP id 00721157ae682-6d1713a364bmr16614487b3.32.1724848560999;
        Wed, 28 Aug 2024 05:36:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFX5cwZI6JxMxtVlTYixZ+nncqaWWDtCnWBtN5o4ulqMiBsr5fjSDUpmCWzDo540sJyv/gRJ9O1gveuHFkBcmE=
X-Received: by 2002:a05:690c:6603:b0:6b2:6cd4:7fa5 with SMTP id
 00721157ae682-6d1713a364bmr16614337b3.32.1724848560678; Wed, 28 Aug 2024
 05:36:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240816090159.1967650-1-dtatulea@nvidia.com> <20240816090159.1967650-6-dtatulea@nvidia.com>
In-Reply-To: <20240816090159.1967650-6-dtatulea@nvidia.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Wed, 28 Aug 2024 14:35:24 +0200
Message-ID: <CAJaqyWer71qofGfovd7f8BAoX0FjRdRx8UyKVMqANi4CnwCfyg@mail.gmail.com>
Subject: Re: [PATCH vhost v2 05/10] vdpa/mlx5: Use async API for vq modify commands
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
> Switch firmware vq modify command to be issued via the async API to
> allow future parallelization. The new refactored function applies the
> modify on a range of vqs and waits for their execution to complete.
>
> For now the command is still used in a serial fashion. A later patch
> will switch to modifying multiple vqs in parallel.
>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

> ---
>  drivers/vdpa/mlx5/net/mlx5_vnet.c | 154 ++++++++++++++++++++----------
>  1 file changed, 106 insertions(+), 48 deletions(-)
>
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/ml=
x5_vnet.c
> index 413b24398ef2..9be7a88d71a7 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1189,6 +1189,11 @@ struct mlx5_virtqueue_query_mem {
>         u8 out[MLX5_ST_SZ_BYTES(query_virtio_net_q_out)];
>  };
>
> +struct mlx5_virtqueue_modify_mem {
> +       u8 in[MLX5_ST_SZ_BYTES(modify_virtio_net_q_in)];
> +       u8 out[MLX5_ST_SZ_BYTES(modify_virtio_net_q_out)];
> +};
> +
>  static void fill_query_virtqueue_cmd(struct mlx5_vdpa_net *ndev,
>                                      struct mlx5_vdpa_virtqueue *mvq,
>                                      struct mlx5_virtqueue_query_mem *cmd=
)
> @@ -1298,51 +1303,30 @@ static bool modifiable_virtqueue_fields(struct ml=
x5_vdpa_virtqueue *mvq)
>         return true;
>  }
>
> -static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
> -                           struct mlx5_vdpa_virtqueue *mvq,
> -                           int state)
> +static void fill_modify_virtqueue_cmd(struct mlx5_vdpa_net *ndev,
> +                                     struct mlx5_vdpa_virtqueue *mvq,
> +                                     int state,
> +                                     struct mlx5_virtqueue_modify_mem *c=
md)
>  {
> -       int inlen =3D MLX5_ST_SZ_BYTES(modify_virtio_net_q_in);
> -       u32 out[MLX5_ST_SZ_DW(modify_virtio_net_q_out)] =3D {};
>         struct mlx5_vdpa_dev *mvdev =3D &ndev->mvdev;
>         struct mlx5_vdpa_mr *desc_mr =3D NULL;
>         struct mlx5_vdpa_mr *vq_mr =3D NULL;
> -       bool state_change =3D false;
>         void *obj_context;
>         void *cmd_hdr;
>         void *vq_ctx;
> -       void *in;
> -       int err;
> -
> -       if (mvq->fw_state =3D=3D MLX5_VIRTIO_NET_Q_OBJECT_NONE)
> -               return 0;
> -
> -       if (!modifiable_virtqueue_fields(mvq))
> -               return -EINVAL;
>
> -       in =3D kzalloc(inlen, GFP_KERNEL);
> -       if (!in)
> -               return -ENOMEM;
> -
> -       cmd_hdr =3D MLX5_ADDR_OF(modify_virtio_net_q_in, in, general_obj_=
in_cmd_hdr);
> +       cmd_hdr =3D MLX5_ADDR_OF(modify_virtio_net_q_in, cmd->in, general=
_obj_in_cmd_hdr);
>
>         MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, opcode, MLX5_CMD_OP_MOD=
IFY_GENERAL_OBJECT);
>         MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, obj_type, MLX5_OBJ_TYPE=
_VIRTIO_NET_Q);
>         MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, obj_id, mvq->virtq_id);
>         MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, uid, ndev->mvdev.res.ui=
d);
>
> -       obj_context =3D MLX5_ADDR_OF(modify_virtio_net_q_in, in, obj_cont=
ext);
> +       obj_context =3D MLX5_ADDR_OF(modify_virtio_net_q_in, cmd->in, obj=
_context);
>         vq_ctx =3D MLX5_ADDR_OF(virtio_net_q_object, obj_context, virtio_=
q_context);
>
> -       if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_STATE) {
> -               if (!is_valid_state_change(mvq->fw_state, state, is_resum=
able(ndev))) {
> -                       err =3D -EINVAL;
> -                       goto done;
> -               }
> -
> +       if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_STATE)
>                 MLX5_SET(virtio_net_q_object, obj_context, state, state);
> -               state_change =3D true;
> -       }
>
>         if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_ADDRS)=
 {
>                 MLX5_SET64(virtio_q, vq_ctx, desc_addr, mvq->desc_addr);
> @@ -1388,38 +1372,36 @@ static int modify_virtqueue(struct mlx5_vdpa_net =
*ndev,
>         }
>
>         MLX5_SET64(virtio_net_q_object, obj_context, modify_field_select,=
 mvq->modified_fields);
> -       err =3D mlx5_cmd_exec(ndev->mvdev.mdev, in, inlen, out, sizeof(ou=
t));
> -       if (err)
> -               goto done;
> +}
>
> -       if (state_change)
> -               mvq->fw_state =3D state;
> +static void modify_virtqueue_end(struct mlx5_vdpa_net *ndev,
> +                                struct mlx5_vdpa_virtqueue *mvq,
> +                                int state)
> +{
> +       struct mlx5_vdpa_dev *mvdev =3D &ndev->mvdev;
>
>         if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_MKEY) =
{
> +               unsigned int asid =3D mvdev->group2asid[MLX5_VDPA_DATAVQ_=
GROUP];
> +               struct mlx5_vdpa_mr *vq_mr =3D mvdev->mr[asid];
> +
>                 mlx5_vdpa_put_mr(mvdev, mvq->vq_mr);
>                 mlx5_vdpa_get_mr(mvdev, vq_mr);
>                 mvq->vq_mr =3D vq_mr;
>         }
>
>         if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_DESC_GROUP_MKEY=
) {
> +               unsigned int asid =3D mvdev->group2asid[MLX5_VDPA_DATAVQ_=
DESC_GROUP];
> +               struct mlx5_vdpa_mr *desc_mr =3D mvdev->mr[asid];
> +
>                 mlx5_vdpa_put_mr(mvdev, mvq->desc_mr);
>                 mlx5_vdpa_get_mr(mvdev, desc_mr);
>                 mvq->desc_mr =3D desc_mr;
>         }
>
> -       mvq->modified_fields =3D 0;
> -
> -done:
> -       kfree(in);
> -       return err;
> -}
> +       if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_STATE)
> +               mvq->fw_state =3D state;
>
> -static int modify_virtqueue_state(struct mlx5_vdpa_net *ndev,
> -                                 struct mlx5_vdpa_virtqueue *mvq,
> -                                 unsigned int state)
> -{
> -       mvq->modified_fields |=3D MLX5_VIRTQ_MODIFY_MASK_STATE;
> -       return modify_virtqueue(ndev, mvq, state);
> +       mvq->modified_fields =3D 0;
>  }
>
>  static int counter_set_alloc(struct mlx5_vdpa_net *ndev, struct mlx5_vdp=
a_virtqueue *mvq)
> @@ -1572,6 +1554,82 @@ static int setup_vq(struct mlx5_vdpa_net *ndev,
>         return err;
>  }
>
> +static int modify_virtqueues(struct mlx5_vdpa_net *ndev, int start_vq, i=
nt num_vqs, int state)
> +{
> +       struct mlx5_vdpa_dev *mvdev =3D &ndev->mvdev;
> +       struct mlx5_virtqueue_modify_mem *cmd_mem;
> +       struct mlx5_vdpa_async_cmd *cmds;
> +       int err =3D 0;
> +
> +       WARN(start_vq + num_vqs > mvdev->max_vqs, "modify vq range invali=
d [%d, %d), max_vqs: %u\n",
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
> +               struct mlx5_vdpa_async_cmd *cmd =3D &cmds[i];
> +               struct mlx5_vdpa_virtqueue *mvq;
> +               int vq_idx =3D start_vq + i;
> +
> +               mvq =3D &ndev->vqs[vq_idx];
> +
> +               if (!modifiable_virtqueue_fields(mvq)) {
> +                       err =3D -EINVAL;
> +                       goto done;
> +               }
> +
> +               if (mvq->fw_state !=3D state) {
> +                       if (!is_valid_state_change(mvq->fw_state, state, =
is_resumable(ndev))) {
> +                               err =3D -EINVAL;
> +                               goto done;
> +                       }
> +
> +                       mvq->modified_fields |=3D MLX5_VIRTQ_MODIFY_MASK_=
STATE;
> +               }
> +
> +               cmd->in =3D &cmd_mem[i].in;
> +               cmd->inlen =3D sizeof(cmd_mem[i].in);
> +               cmd->out =3D &cmd_mem[i].out;
> +               cmd->outlen =3D sizeof(cmd_mem[i].out);
> +               fill_modify_virtqueue_cmd(ndev, mvq, state, &cmd_mem[i]);
> +       }
> +
> +       err =3D mlx5_vdpa_exec_async_cmds(&ndev->mvdev, cmds, num_vqs);
> +       if (err) {
> +               mlx5_vdpa_err(mvdev, "error issuing modify cmd for vq ran=
ge [%d, %d)\n",
> +                             start_vq, start_vq + num_vqs);
> +               goto done;
> +       }
> +
> +       for (int i =3D 0; i < num_vqs; i++) {
> +               struct mlx5_vdpa_async_cmd *cmd =3D &cmds[i];
> +               struct mlx5_vdpa_virtqueue *mvq;
> +               int vq_idx =3D start_vq + i;
> +
> +               mvq =3D &ndev->vqs[vq_idx];
> +
> +               if (cmd->err) {
> +                       mlx5_vdpa_err(mvdev, "modify vq %d failed, state:=
 %d -> %d, err: %d\n",
> +                                     vq_idx, mvq->fw_state, state, err);
> +                       if (!err)
> +                               err =3D cmd->err;
> +                       continue;
> +               }
> +
> +               modify_virtqueue_end(ndev, mvq, state);
> +       }
> +
> +done:
> +       kvfree(cmd_mem);
> +       kvfree(cmds);
> +       return err;
> +}
> +
>  static int suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtq=
ueue *mvq)
>  {
>         struct mlx5_virtq_attr attr;
> @@ -1583,7 +1641,7 @@ static int suspend_vq(struct mlx5_vdpa_net *ndev, s=
truct mlx5_vdpa_virtqueue *mv
>         if (mvq->fw_state !=3D MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY)
>                 return 0;
>
> -       err =3D modify_virtqueue_state(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJEC=
T_STATE_SUSPEND);
> +       err =3D modify_virtqueues(ndev, mvq->index, 1, MLX5_VIRTIO_NET_Q_=
OBJECT_STATE_SUSPEND);
>         if (err) {
>                 mlx5_vdpa_err(&ndev->mvdev, "modify to suspend failed, er=
r: %d\n", err);
>                 return err;
> @@ -1630,7 +1688,7 @@ static int resume_vq(struct mlx5_vdpa_net *ndev, st=
ruct mlx5_vdpa_virtqueue *mvq
>                 /* Due to a FW quirk we need to modify the VQ fields firs=
t then change state.
>                  * This should be fixed soon. After that, a single comman=
d can be used.
>                  */
> -               err =3D modify_virtqueue(ndev, mvq, 0);
> +               err =3D modify_virtqueues(ndev, mvq->index, 1, mvq->fw_st=
ate);
>                 if (err) {
>                         mlx5_vdpa_err(&ndev->mvdev,
>                                 "modify vq properties failed for vq %u, e=
rr: %d\n",
> @@ -1652,7 +1710,7 @@ static int resume_vq(struct mlx5_vdpa_net *ndev, st=
ruct mlx5_vdpa_virtqueue *mvq
>                 return -EINVAL;
>         }
>
> -       err =3D modify_virtqueue_state(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJEC=
T_STATE_RDY);
> +       err =3D modify_virtqueues(ndev, mvq->index, 1, MLX5_VIRTIO_NET_Q_=
OBJECT_STATE_RDY);
>         if (err)
>                 mlx5_vdpa_err(&ndev->mvdev, "modify to resume failed for =
vq %u, err: %d\n",
>                               mvq->index, err);
> --
> 2.45.1
>


