Return-Path: <kvm+bounces-25351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2F719645DA
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 15:10:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A7AA282419
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 13:10:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 378401A4B81;
	Thu, 29 Aug 2024 13:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SN/g0ixq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86802446D1
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 13:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724937045; cv=none; b=osvfD5eeyH+fIEwR/Mma6ULKPHwJ//N1I8jav8ck/ER400szbhAKWutYHcxHHjnWu3b1cR200h7DUCQMa4Oyx74xHaTi+TthRin21v3QBTPZk7jfxjqaqMuUAgUcIbqxPsJ9kfq20VUkXzQN3KeS3naCF27WyjYCagX5rhlunDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724937045; c=relaxed/simple;
	bh=d0CBz2/CMekLs/MiaCWxTano/uPg70or9OrRr5u1HXE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dbjGfLrOevj/GJdc7gUHpejUn0xydHbzEh4iCCDTXm4UjjjiGjFZRYMj1YeSf3SvZhNRA/IFsx/hSYvl5CYk+1XzOPuoyjaQUr4lDI1SDGDyq46DfBH+GnpKYvIbbxdCVz69RLi6MIUajCVwwuK5vtZXKp6t5tXiTU4Qo/mNUEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SN/g0ixq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724937042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zC8/Iin5jByWnaQ3zVHoR4GF2O68JTxKriuHnXWQluc=;
	b=SN/g0ixqFKLLIhzPWA4WdrK1Jq1xw8FLrkb/sbC3+vrFjeO/QgszAlvXCoHdcpiOLXOT/N
	SRzSlfqsARe+5LnciN/LNvUDvYmvjBV15PW83WtDCMeB5MOHYhyFLGfD0AGq7cf98A0S1N
	ixsArEJfKYggRCaLsbKeted0XWT5nhw=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-lvvvFZeVOkSQDrXTk1tNuQ-1; Thu, 29 Aug 2024 09:10:41 -0400
X-MC-Unique: lvvvFZeVOkSQDrXTk1tNuQ-1
Received: by mail-yb1-f198.google.com with SMTP id 3f1490d57ef6-e117634c516so1141732276.0
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 06:10:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724937041; x=1725541841;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zC8/Iin5jByWnaQ3zVHoR4GF2O68JTxKriuHnXWQluc=;
        b=wqfsLCx3Ix2nF6c2PXEJT1t1PiUJciT8oQmnexNV8mA0bqRYHyhvy0zzu7bwek8u4r
         ZjA/J5uB8gEXPy91cwaI1+XdLAlE9Mn9K6EXIMH3VTilI6C5v4UscNkOtGzMUPGoN+fd
         9zTiSfGN3biXBr/PhLfayk5sGLLZiYWY7/6qCFTJhsfZRjYHke30RmCwMAC8PHrUOAAm
         vR7J1hTRqt59fg0RSXBxUM3Mh80ZW52u1qdIYxiDa9a76EHmK9jF+gXhWHCsIF1cm3Nz
         LUTdOe+tN4dvaLURUt/SRPZJ3b2VR2xvi0aEw13F8jArYGEvZpzdSeNSOese9aXgjNLY
         JB4g==
X-Forwarded-Encrypted: i=1; AJvYcCXGlLP7Jw/iolanONvu8us1FO+9Ve0R0nupgLV8mXzJsGsnrkyz9st5PV1DGtyC5PIatR4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwijHGa4xwN9TFdA+28KZWjEnVpNLE0iiGVd7N5uheP3Tqre9rZ
	skUoptJHBtxiRJYG84p8F39GgEF1Z51V5CRIzq9sRUg4rpQ+o9BWaDY94aTqm6thL9IgeJ5YH/E
	FegJ5J73pmpm7jxE3T/+648MUfWHxYaWZbOcuWaT4S+7tKOd2qqkSBRtT6kgf+ZpdUMH/p94qfB
	hkKYk0++42Qc/FqTcXTheiQQFS
X-Received: by 2002:a05:6902:e0b:b0:e16:69b5:ef66 with SMTP id 3f1490d57ef6-e1a5af17657mr2875235276.54.1724937040662;
        Thu, 29 Aug 2024 06:10:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG1EKlldA1iqYUNyHISgw7bsNGWhmnDWo+D7H7j//+YtsZz+zCQ3i+3uYrIQkF1hrQjOhnGW6achMSx1MPph64=
X-Received: by 2002:a05:6902:e0b:b0:e16:69b5:ef66 with SMTP id
 3f1490d57ef6-e1a5af17657mr2875187276.54.1724937040249; Thu, 29 Aug 2024
 06:10:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240821114100.2261167-2-dtatulea@nvidia.com> <20240821114100.2261167-3-dtatulea@nvidia.com>
In-Reply-To: <20240821114100.2261167-3-dtatulea@nvidia.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Thu, 29 Aug 2024 15:10:03 +0200
Message-ID: <CAJaqyWcFVLXg=nUdOJOviWA+TDfbqBeEHrVROVC1nYrO8+ZmhA@mail.gmail.com>
Subject: Re: [PATCH vhost 1/7] vdpa/mlx5: Create direct MKEYs in parallel
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Si-Wei Liu <si-wei.liu@oracle.com>, virtualization@lists.linux-foundation.org, 
	Gal Pressman <gal@nvidia.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Parav Pandit <parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Cosmin Ratiu <cratiu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 21, 2024 at 1:41=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia.com=
> wrote:
>
> Use the async interface to issue MTT MKEY creation.
> Extra care is taken at the allocation of FW input commands
> due to the MTT tables having variable sizes depending on
> MR.
>
> The indirect MKEY is still created synchronously at the
> end as the direct MKEYs need to be filled in.
>
> This makes create_user_mr() 3-5x faster, depending on
> the size of the MR.
>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
> ---
>  drivers/vdpa/mlx5/core/mr.c | 118 +++++++++++++++++++++++++++++-------
>  1 file changed, 96 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
> index 4758914ccf86..66e6a15f823f 100644
> --- a/drivers/vdpa/mlx5/core/mr.c
> +++ b/drivers/vdpa/mlx5/core/mr.c
> @@ -49,17 +49,18 @@ static void populate_mtts(struct mlx5_vdpa_direct_mr =
*mr, __be64 *mtt)
>         }
>  }
>
> -static int create_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdp=
a_direct_mr *mr)
> +struct mlx5_create_mkey_mem {
> +       u8 out[MLX5_ST_SZ_BYTES(create_mkey_out)];
> +       u8 in[MLX5_ST_SZ_BYTES(create_mkey_in)];
> +       DECLARE_FLEX_ARRAY(__be64, mtt);

I may be missing something obvious, but why do we need
DECLARE_FLEX_ARRAY here? My understanding is that it is only needed in
special cases like uapi headers and we can use "__be64 mtt[]" here.

> +};
> +
> +static void fill_create_direct_mr(struct mlx5_vdpa_dev *mvdev,
> +                                 struct mlx5_vdpa_direct_mr *mr,
> +                                 struct mlx5_create_mkey_mem *mem)
>  {
> -       int inlen;
> +       void *in =3D &mem->in;
>         void *mkc;
> -       void *in;
> -       int err;
> -
> -       inlen =3D MLX5_ST_SZ_BYTES(create_mkey_in) + roundup(MLX5_ST_SZ_B=
YTES(mtt) * mr->nsg, 16);
> -       in =3D kvzalloc(inlen, GFP_KERNEL);
> -       if (!in)
> -               return -ENOMEM;
>
>         MLX5_SET(create_mkey_in, in, uid, mvdev->res.uid);
>         mkc =3D MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
> @@ -76,18 +77,25 @@ static int create_direct_mr(struct mlx5_vdpa_dev *mvd=
ev, struct mlx5_vdpa_direct
>         MLX5_SET(create_mkey_in, in, translations_octword_actual_size,
>                  get_octo_len(mr->end - mr->start, mr->log_size));
>         populate_mtts(mr, MLX5_ADDR_OF(create_mkey_in, in, klm_pas_mtt));
> -       err =3D mlx5_vdpa_create_mkey(mvdev, &mr->mr, in, inlen);
> -       kvfree(in);
> -       if (err) {
> -               mlx5_vdpa_warn(mvdev, "Failed to create direct MR\n");
> -               return err;
> -       }
>
> -       return 0;
> +       MLX5_SET(create_mkey_in, in, opcode, MLX5_CMD_OP_CREATE_MKEY);
> +       MLX5_SET(create_mkey_in, in, uid, mvdev->res.uid);
> +}
> +
> +static void create_direct_mr_end(struct mlx5_vdpa_dev *mvdev,
> +                                struct mlx5_vdpa_direct_mr *mr,
> +                                struct mlx5_create_mkey_mem *mem)
> +{
> +       u32 mkey_index =3D MLX5_GET(create_mkey_out, mem->out, mkey_index=
);
> +
> +       mr->mr =3D mlx5_idx_to_mkey(mkey_index);
>  }
>
>  static void destroy_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_v=
dpa_direct_mr *mr)
>  {
> +       if (!mr->mr)
> +               return;
> +
>         mlx5_vdpa_destroy_mkey(mvdev, mr->mr);
>  }
>
> @@ -179,6 +187,74 @@ static int klm_byte_size(int nklms)
>         return 16 * ALIGN(nklms, 4);
>  }
>
> +static int create_direct_keys(struct mlx5_vdpa_dev *mvdev, struct mlx5_v=
dpa_mr *mr)
> +{
> +       struct mlx5_vdpa_async_cmd *cmds =3D NULL;
> +       struct mlx5_vdpa_direct_mr *dmr;
> +       int err =3D 0;
> +       int i =3D 0;
> +
> +       cmds =3D kvcalloc(mr->num_directs, sizeof(*cmds), GFP_KERNEL);
> +       if (!cmds)
> +               return -ENOMEM;

Nit: this could benefit from Scope-based Cleanup Helpers [1], as it
would make clear that memory is always removed at the end of the
function & could prevent errors if the function is modified in the
future. I'm a big fan of them so my opinion may be biased though :).

It would be great to be able to remove the array members with that
too, but I think the kernel doesn't have any facility for that.

> +
> +       list_for_each_entry(dmr, &mr->head, list) {
> +               struct mlx5_create_mkey_mem *cmd_mem;
> +               int mttlen, mttcount;
> +
> +               mttlen =3D roundup(MLX5_ST_SZ_BYTES(mtt) * dmr->nsg, 16);

I don't get the roundup here, I guess it is so the driver does not
send potentially uninitialized memory to the device? Maybe the 16
should be a macro?

> +               mttcount =3D mttlen / sizeof(cmd_mem->mtt[0]);
> +               cmd_mem =3D kvcalloc(1, struct_size(cmd_mem, mtt, mttcoun=
t), GFP_KERNEL);
> +               if (!cmd_mem) {
> +                       err =3D -ENOMEM;
> +                       goto done;
> +               }
> +
> +               cmds[i].out =3D cmd_mem->out;
> +               cmds[i].outlen =3D sizeof(cmd_mem->out);
> +               cmds[i].in =3D cmd_mem->in;
> +               cmds[i].inlen =3D struct_size(cmd_mem, mtt, mttcount);
> +
> +               fill_create_direct_mr(mvdev, dmr, cmd_mem);
> +
> +               i++;
> +       }
> +
> +       err =3D mlx5_vdpa_exec_async_cmds(mvdev, cmds, mr->num_directs);
> +       if (err) {
> +
> +               mlx5_vdpa_err(mvdev, "error issuing MTT mkey creation for=
 direct mrs: %d\n", err);
> +               goto done;
> +       }
> +
> +       i =3D 0;
> +       list_for_each_entry(dmr, &mr->head, list) {
> +               struct mlx5_vdpa_async_cmd *cmd =3D &cmds[i++];
> +               struct mlx5_create_mkey_mem *cmd_mem;
> +
> +               cmd_mem =3D container_of(cmd->out, struct mlx5_create_mke=
y_mem, out);
> +
> +               if (!cmd->err) {
> +                       create_direct_mr_end(mvdev, dmr, cmd_mem);

The caller function doesn't trust the result if we return an error.
Why not use the previous loop to call create_direct_mr_end? Am I
missing any side effect?

> +               } else {
> +                       err =3D err ? err : cmd->err;
> +                       mlx5_vdpa_err(mvdev, "error creating MTT mkey [0x=
%llx, 0x%llx]: %d\n",
> +                               dmr->start, dmr->end, cmd->err);
> +               }
> +       }
> +
> +done:
> +       for (i =3D i-1; i >=3D 0; i--) {
> +               struct mlx5_create_mkey_mem *cmd_mem;
> +
> +               cmd_mem =3D container_of(cmds[i].out, struct mlx5_create_=
mkey_mem, out);
> +               kvfree(cmd_mem);
> +       }
> +
> +       kvfree(cmds);
> +       return err;
> +}
> +
>  static int create_indirect_key(struct mlx5_vdpa_dev *mvdev, struct mlx5_=
vdpa_mr *mr)
>  {
>         int inlen;
> @@ -279,14 +355,8 @@ static int map_direct_mr(struct mlx5_vdpa_dev *mvdev=
, struct mlx5_vdpa_direct_mr
>                 goto err_map;
>         }
>
> -       err =3D create_direct_mr(mvdev, mr);
> -       if (err)
> -               goto err_direct;
> -
>         return 0;
>
> -err_direct:
> -       dma_unmap_sg_attrs(dma, mr->sg_head.sgl, mr->nsg, DMA_BIDIRECTION=
AL, 0);
>  err_map:
>         sg_free_table(&mr->sg_head);
>         return err;
> @@ -401,6 +471,10 @@ static int create_user_mr(struct mlx5_vdpa_dev *mvde=
v,
>         if (err)
>                 goto err_chain;
>
> +       err =3D create_direct_keys(mvdev, mr);
> +       if (err)
> +               goto err_chain;
> +
>         /* Create the memory key that defines the guests's address space.=
 This
>          * memory key refers to the direct keys that contain the MTT
>          * translations
> --
> 2.45.1
>


