Return-Path: <kvm+bounces-4231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A9BC480F683
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 20:22:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB2F71C20DEA
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 19:22:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9CC681E47;
	Tue, 12 Dec 2023 19:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UFY8cfr1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D815DC
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 11:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702408913;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HurXK5gBPsoHICW5D8Za3/oNGdjuLwbQTQMZFCsDbks=;
	b=UFY8cfr1DQA0cUEXvKUfgLheO4CN+B6g5JFagY/p3pWYie3tb6pyRRI025S8SzqnalRGUx
	N7KvwszVnVXFYu5oT+DorGlkA5Y/OuKb7Bxcyc3/3NlTSgEmIAjQceoKUuZnWEa8oIiCzU
	bZU1xOeYrGuDtou9xvITpvwsy3CF/20=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-507-8OwGpZUTO1mSJT0Bh8ceUg-1; Tue, 12 Dec 2023 14:21:51 -0500
X-MC-Unique: 8OwGpZUTO1mSJT0Bh8ceUg-1
Received: by mail-yb1-f197.google.com with SMTP id 3f1490d57ef6-dbcb6645f85so1565165276.2
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 11:21:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702408911; x=1703013711;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HurXK5gBPsoHICW5D8Za3/oNGdjuLwbQTQMZFCsDbks=;
        b=bpFrbiWbXVqza+PGcVfNVti/4qUcC3+MHc88G39tqw8o1xWiJrCyhTWRkMEdJoCbit
         J8CRavZhu8BTjYMsIOoK7zUSO0cRNPtANGavjVkNWwtaNsNcC+3SbMnDGcNYr72zj5YN
         mp0J7mjrvmMzSz91O8iddTVT1IKouf0fprhTUszLoI43lZoExFc+8yNENhdPTfhLRP7X
         Y9XGY2ckeF/Wc/DQXqio/zCoMdTW4+O/r/kyLgoGx7cj8yAvKT/QkIKR2jJP3eoZdImg
         pFMDxntQdQZTJDeNB97XRz1Y4lXnKtYVI62fcFzOfK8Awul+nnTwsmoND1NRsVwn8/c/
         ksTw==
X-Gm-Message-State: AOJu0YxhoCptvc3YQYV9vMgC5rLV3R4JbUBIvMK/7vefZ8lpx9D4KLPt
	4B1Rk4DevRd4ktyeqx8pD97c8rcvzlBdjWDHWtz1dfxl9ygoIjCY3n3JzzCox6itbFk9YgUXQPU
	nNR4ynbQxlIpuHyLt9Goc1eidofUL
X-Received: by 2002:a25:6084:0:b0:dbc:cbb7:1396 with SMTP id u126-20020a256084000000b00dbccbb71396mr42497ybb.79.1702408911405;
        Tue, 12 Dec 2023 11:21:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFwE2PBBX/zi/0sI1dUGV/OYZrCz+Jc8U/PqiB/t32suOa+Cugn7mXgjVi34mzvQKsQy4dZIOiVC3cueoVPamw=
X-Received: by 2002:a25:6084:0:b0:dbc:cbb7:1396 with SMTP id
 u126-20020a256084000000b00dbccbb71396mr42489ybb.79.1702408911135; Tue, 12 Dec
 2023 11:21:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231205104609.876194-1-dtatulea@nvidia.com> <20231205104609.876194-5-dtatulea@nvidia.com>
In-Reply-To: <20231205104609.876194-5-dtatulea@nvidia.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Tue, 12 Dec 2023 20:21:14 +0100
Message-ID: <CAJaqyWeEY9LNTE8QEnJgLhgS7HiXr5gJEwwPBrC3RRBsAE4_7Q@mail.gmail.com>
Subject: Re: [PATCH vhost v2 4/8] vdpa/mlx5: Mark vq addrs for modification in
 hw vq
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Si-Wei Liu <si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Leon Romanovsky <leon@kernel.org>, virtualization@lists.linux-foundation.org, 
	Gal Pressman <gal@nvidia.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Parav Pandit <parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 5, 2023 at 11:46=E2=80=AFAM Dragos Tatulea <dtatulea@nvidia.com=
> wrote:
>
> Addresses get set by .set_vq_address. hw vq addresses will be updated on
> next modify_virtqueue.
>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Reviewed-by: Gal Pressman <gal@nvidia.com>
> Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

I'm kind of ok with this patch and the next one about state, but I
didn't ack them in the previous series.

My main concern is that it is not valid to change the vq address after
DRIVER_OK in VirtIO, which vDPA follows. Only memory maps are ok to
change at this moment. I'm not sure about vq state in vDPA, but vhost
forbids changing it with an active backend.

Suspend is not defined in VirtIO at this moment though, so maybe it is
ok to decide that all of these parameters may change during suspend.
Maybe the best thing is to protect this with a vDPA feature flag.

Jason, what do you think?

Thanks!

> ---
>  drivers/vdpa/mlx5/net/mlx5_vnet.c  | 9 +++++++++
>  include/linux/mlx5/mlx5_ifc_vdpa.h | 1 +
>  2 files changed, 10 insertions(+)
>
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/ml=
x5_vnet.c
> index f8f088cced50..80e066de0866 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1209,6 +1209,7 @@ static int modify_virtqueue(struct mlx5_vdpa_net *n=
dev,
>         bool state_change =3D false;
>         void *obj_context;
>         void *cmd_hdr;
> +       void *vq_ctx;
>         void *in;
>         int err;
>
> @@ -1230,6 +1231,7 @@ static int modify_virtqueue(struct mlx5_vdpa_net *n=
dev,
>         MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, uid, ndev->mvdev.res.ui=
d);
>
>         obj_context =3D MLX5_ADDR_OF(modify_virtio_net_q_in, in, obj_cont=
ext);
> +       vq_ctx =3D MLX5_ADDR_OF(virtio_net_q_object, obj_context, virtio_=
q_context);
>
>         if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_STATE) {
>                 if (!is_valid_state_change(mvq->fw_state, state, is_resum=
able(ndev))) {
> @@ -1241,6 +1243,12 @@ static int modify_virtqueue(struct mlx5_vdpa_net *=
ndev,
>                 state_change =3D true;
>         }
>
> +       if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_ADDRS)=
 {
> +               MLX5_SET64(virtio_q, vq_ctx, desc_addr, mvq->desc_addr);
> +               MLX5_SET64(virtio_q, vq_ctx, used_addr, mvq->device_addr)=
;
> +               MLX5_SET64(virtio_q, vq_ctx, available_addr, mvq->driver_=
addr);
> +       }
> +
>         MLX5_SET64(virtio_net_q_object, obj_context, modify_field_select,=
 mvq->modified_fields);
>         err =3D mlx5_cmd_exec(ndev->mvdev.mdev, in, inlen, out, sizeof(ou=
t));
>         if (err)
> @@ -2202,6 +2210,7 @@ static int mlx5_vdpa_set_vq_address(struct vdpa_dev=
ice *vdev, u16 idx, u64 desc_
>         mvq->desc_addr =3D desc_area;
>         mvq->device_addr =3D device_area;
>         mvq->driver_addr =3D driver_area;
> +       mvq->modified_fields |=3D MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_ADDRS;
>         return 0;
>  }
>
> diff --git a/include/linux/mlx5/mlx5_ifc_vdpa.h b/include/linux/mlx5/mlx5=
_ifc_vdpa.h
> index b86d51a855f6..9594ac405740 100644
> --- a/include/linux/mlx5/mlx5_ifc_vdpa.h
> +++ b/include/linux/mlx5/mlx5_ifc_vdpa.h
> @@ -145,6 +145,7 @@ enum {
>         MLX5_VIRTQ_MODIFY_MASK_STATE                    =3D (u64)1 << 0,
>         MLX5_VIRTQ_MODIFY_MASK_DIRTY_BITMAP_PARAMS      =3D (u64)1 << 3,
>         MLX5_VIRTQ_MODIFY_MASK_DIRTY_BITMAP_DUMP_ENABLE =3D (u64)1 << 4,
> +       MLX5_VIRTQ_MODIFY_MASK_VIRTIO_Q_ADDRS           =3D (u64)1 << 6,
>         MLX5_VIRTQ_MODIFY_MASK_DESC_GROUP_MKEY          =3D (u64)1 << 14,
>  };
>
> --
> 2.42.0
>


