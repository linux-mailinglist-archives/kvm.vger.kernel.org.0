Return-Path: <kvm+bounces-25376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4005A9649A1
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 17:16:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED42F281D8D
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 15:16:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAEC31B251F;
	Thu, 29 Aug 2024 15:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iu/Ja2m6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288541487F1
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 15:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724944556; cv=none; b=Q2QuY08jY/+hGiXys3Vakf2drK8PPW5UG9r2/AhtGSTjsgOFgeD9yo9Vbm0KGM5eU9se3HTlbVdyFMsLaTbdU+hNQnk980N5RytOqUjl7Q02/nvaiQKwhIrdtjuTlX4py3vMwn2oKLOyGVWu+naGKEsXlBGblHCma5B26zYv5LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724944556; c=relaxed/simple;
	bh=vdLEYwn3hyH0yYINE9e21Zqj01ES2SNI5IJDGg/dBag=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ziyw3yyDPAOoV0kDLA7V4fC9BIW8MrbQVqH67t4uiNSaTFSmF8VcrzXjYqtn10QKNHmgeuZUMNLjVDjNSsZsf5Y7uYquvs9qlizWdeqduy++hkbPS63KLzSbos0jqGCiCEDE7C0KTJH7cB796Nro3DhmSfhabcnFjB0sEu9Salc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iu/Ja2m6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724944553;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=emt4Aa5SKw7SFyxXUt2WM0K5CmZW1m3fJVEf3z1rDFo=;
	b=iu/Ja2m6VhNXPv7LM+oCIXYUx9U9x4BIrYLnc8f6PEbaoz8inqi74UV4ynQy/zxy0X+nXp
	269HPwOBJas17SQJ6PsEMaUGPDRNebUDYIwyfFDusMKC+GNcCYPXeGuh7C/bMJrHOD4GSy
	IcdyedjeYLvvlrglSl1AQBBgtGYC3gc=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-9Oy1IdjNNWWz40Cij45L1w-1; Thu, 29 Aug 2024 11:15:52 -0400
X-MC-Unique: 9Oy1IdjNNWWz40Cij45L1w-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2f3f1bbe2e2so7185121fa.0
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 08:15:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724944550; x=1725549350;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=emt4Aa5SKw7SFyxXUt2WM0K5CmZW1m3fJVEf3z1rDFo=;
        b=QO2h9zkN2aQbewIMDmdb7d0EdClWYXhQmXgnA4uv2XSqLLylWu7dj3E7Ic6rV+SDWd
         6E+Jo5sSld3kalkjognpHnSQ85H/T5qU9izM7NtT9YJtkHLSOqUP+g0rJmWyEDpXkAmo
         qQ+/TSQYzBeOFtxZ3KP1BVUDmAOfZu+jYUxNS/qZsCZ318E6au+MwSN9yXuzR2MiNn8T
         yTR6v1jKdeO5AIyVHRvHrU0COabRod4bLvuZvHTz2Ei8TaMnhZqj1mq3/ZalVNohCU4d
         I9cqw2AU+8vl6B5RvGGLkKD3fjQ1HRjolDivWVZPwTS8WHNMrRmebQ1wJLyMp8yFaVRZ
         nnzQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQS1M+30Th0I1C3vEGwyu110mFXAP720JbW/iMCAzOqZw/5E4t3daLn43Gw14k9uVgYoI=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywpo7/vePqsXw12GoLenyOMNAYHbeYUejyvEZb7rj4S5fbQIS6V
	P+8KKRy5sF1y3fyL/3fjN4UIm+yoLXWhGCw0Zaht83q/xbvafKh/xQ9gtx/PmieRbLUmg+0t2dE
	0C4WtZnb9uz36ou/YFc5UvCfIHdxsHGGJdeR5OQRdH9bRI93LzfNXRb6j6lmPmnin5JDfBnIonv
	KCtwJ3Z+1euMkO2NNNvNmHbDBXWTvhSkLeoPM=
X-Received: by 2002:a05:651c:511:b0:2ef:2555:e52f with SMTP id 38308e7fff4ca-2f61051494cmr20296681fa.35.1724944549657;
        Thu, 29 Aug 2024 08:15:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGF8w/FaX9C3ZPUAUun6keBH6CcxT9mb81J79vRsiAKre8bMCAbeIvA/LIXR16ficN/CS2MtvD/ssp4SVq+k7w=
X-Received: by 2002:a17:907:9688:b0:a86:b789:164b with SMTP id
 a640c23a62f3a-a897fad4543mr271625966b.58.1724944538225; Thu, 29 Aug 2024
 08:15:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240821114100.2261167-2-dtatulea@nvidia.com> <20240821114100.2261167-3-dtatulea@nvidia.com>
 <CAJaqyWcFVLXg=nUdOJOviWA+TDfbqBeEHrVROVC1nYrO8+ZmhA@mail.gmail.com> <6935f3aa-9de5-4781-b823-30c17817cc86@nvidia.com>
In-Reply-To: <6935f3aa-9de5-4781-b823-30c17817cc86@nvidia.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Thu, 29 Aug 2024 17:15:00 +0200
Message-ID: <CAJaqyWcW2r9bos3CPxE4yZfZDORzki1SKSyODSgJRLXocOam1w@mail.gmail.com>
Subject: Re: [PATCH vhost 1/7] vdpa/mlx5: Create direct MKEYs in parallel
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: Jason Wang <jasowang@redhat.com>, Si-Wei Liu <si-wei.liu@oracle.com>, 
	virtualization <virtualization@lists.linux-foundation.org>, Gal Pressman <gal@nvidia.com>, 
	kvm list <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Cosmin Ratiu <cratiu@nvidia.com>, Michael Tsirkin <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 29, 2024 at 3:54=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia.com=
> wrote:
>
>
>
> On 29.08.24 15:10, Eugenio Perez Martin wrote:
> > On Wed, Aug 21, 2024 at 1:41=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia=
.com> wrote:
> >>
> >> Use the async interface to issue MTT MKEY creation.
> >> Extra care is taken at the allocation of FW input commands
> >> due to the MTT tables having variable sizes depending on
> >> MR.
> >>
> >> The indirect MKEY is still created synchronously at the
> >> end as the direct MKEYs need to be filled in.
> >>
> >> This makes create_user_mr() 3-5x faster, depending on
> >> the size of the MR.
> >>
> >> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> >> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
> >> ---
> >>  drivers/vdpa/mlx5/core/mr.c | 118 +++++++++++++++++++++++++++++------=
-
> >>  1 file changed, 96 insertions(+), 22 deletions(-)
> >>
> >> diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
> >> index 4758914ccf86..66e6a15f823f 100644
> >> --- a/drivers/vdpa/mlx5/core/mr.c
> >> +++ b/drivers/vdpa/mlx5/core/mr.c
> >> @@ -49,17 +49,18 @@ static void populate_mtts(struct mlx5_vdpa_direct_=
mr *mr, __be64 *mtt)
> >>         }
> >>  }
> >>
> >> -static int create_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_=
vdpa_direct_mr *mr)
> >> +struct mlx5_create_mkey_mem {
> >> +       u8 out[MLX5_ST_SZ_BYTES(create_mkey_out)];
> >> +       u8 in[MLX5_ST_SZ_BYTES(create_mkey_in)];
> >> +       DECLARE_FLEX_ARRAY(__be64, mtt);
> >
> > I may be missing something obvious, but why do we need
> > DECLARE_FLEX_ARRAY here? My understanding is that it is only needed in
> > special cases like uapi headers and we can use "__be64 mtt[]" here.
> >
> checkpatch.pl was complaining about it because in my initial version I
> used the "[0]" version of zero length based arrays.
>
> My impression was that DECLARE_FLEX_ARRAY is preferred option because it
> triggers a compiler error if the zero lenth array is not at the end of
> the struct. But on closer inspection I see that using the right C99
> empty brackets notation is enough to trigger this error.
> DECLARE_FLEX_ARRAY seems to be useful for the union case.
>
> I will change it in a v2.
>
> >> +};
> >> +
> >> +static void fill_create_direct_mr(struct mlx5_vdpa_dev *mvdev,
> >> +                                 struct mlx5_vdpa_direct_mr *mr,
> >> +                                 struct mlx5_create_mkey_mem *mem)
> >>  {
> >> -       int inlen;
> >> +       void *in =3D &mem->in;
> >>         void *mkc;
> >> -       void *in;
> >> -       int err;
> >> -
> >> -       inlen =3D MLX5_ST_SZ_BYTES(create_mkey_in) + roundup(MLX5_ST_S=
Z_BYTES(mtt) * mr->nsg, 16);
> >> -       in =3D kvzalloc(inlen, GFP_KERNEL);
> >> -       if (!in)
> >> -               return -ENOMEM;
> >>
> >>         MLX5_SET(create_mkey_in, in, uid, mvdev->res.uid);
> >>         mkc =3D MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry=
);
> >> @@ -76,18 +77,25 @@ static int create_direct_mr(struct mlx5_vdpa_dev *=
mvdev, struct mlx5_vdpa_direct
> >>         MLX5_SET(create_mkey_in, in, translations_octword_actual_size,
> >>                  get_octo_len(mr->end - mr->start, mr->log_size));
> >>         populate_mtts(mr, MLX5_ADDR_OF(create_mkey_in, in, klm_pas_mtt=
));
> >> -       err =3D mlx5_vdpa_create_mkey(mvdev, &mr->mr, in, inlen);
> >> -       kvfree(in);
> >> -       if (err) {
> >> -               mlx5_vdpa_warn(mvdev, "Failed to create direct MR\n");
> >> -               return err;
> >> -       }
> >>
> >> -       return 0;
> >> +       MLX5_SET(create_mkey_in, in, opcode, MLX5_CMD_OP_CREATE_MKEY);
> >> +       MLX5_SET(create_mkey_in, in, uid, mvdev->res.uid);
> >> +}
> >> +
> >> +static void create_direct_mr_end(struct mlx5_vdpa_dev *mvdev,
> >> +                                struct mlx5_vdpa_direct_mr *mr,
> >> +                                struct mlx5_create_mkey_mem *mem)
> >> +{
> >> +       u32 mkey_index =3D MLX5_GET(create_mkey_out, mem->out, mkey_in=
dex);
> >> +
> >> +       mr->mr =3D mlx5_idx_to_mkey(mkey_index);
> >>  }
> >>
> >>  static void destroy_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx=
5_vdpa_direct_mr *mr)
> >>  {
> >> +       if (!mr->mr)
> >> +               return;
> >> +
> >>         mlx5_vdpa_destroy_mkey(mvdev, mr->mr);
> >>  }
> >>
> >> @@ -179,6 +187,74 @@ static int klm_byte_size(int nklms)
> >>         return 16 * ALIGN(nklms, 4);
> >>  }
> >>
> >> +static int create_direct_keys(struct mlx5_vdpa_dev *mvdev, struct mlx=
5_vdpa_mr *mr)
> >> +{
> >> +       struct mlx5_vdpa_async_cmd *cmds =3D NULL;
> >> +       struct mlx5_vdpa_direct_mr *dmr;
> >> +       int err =3D 0;
> >> +       int i =3D 0;
> >> +
> >> +       cmds =3D kvcalloc(mr->num_directs, sizeof(*cmds), GFP_KERNEL);
> >> +       if (!cmds)
> >> +               return -ENOMEM;
> >
> > Nit: this could benefit from Scope-based Cleanup Helpers [1], as it
> > would make clear that memory is always removed at the end of the
> > function & could prevent errors if the function is modified in the
> > future. I'm a big fan of them so my opinion may be biased though :).
> >
> > It would be great to be able to remove the array members with that
> > too, but I think the kernel doesn't have any facility for that.
> >
> I didn't know about those. It sounds like a good idea! I will try
> to use them in v2.
>
> >> +
> >> +       list_for_each_entry(dmr, &mr->head, list) {
> >> +               struct mlx5_create_mkey_mem *cmd_mem;
> >> +               int mttlen, mttcount;
> >> +
> >> +               mttlen =3D roundup(MLX5_ST_SZ_BYTES(mtt) * dmr->nsg, 1=
6);
> >
> > I don't get the roundup here, I guess it is so the driver does not
> > send potentially uninitialized memory to the device? Maybe the 16
> > should be a macro?
> >
> The roundup is a hw requirement. A define would be a good idea. Will add
> it.
>
> >> +               mttcount =3D mttlen / sizeof(cmd_mem->mtt[0]);
> >> +               cmd_mem =3D kvcalloc(1, struct_size(cmd_mem, mtt, mttc=
ount), GFP_KERNEL);
> >> +               if (!cmd_mem) {
> >> +                       err =3D -ENOMEM;
> >> +                       goto done;
> >> +               }
> >> +
> >> +               cmds[i].out =3D cmd_mem->out;
> >> +               cmds[i].outlen =3D sizeof(cmd_mem->out);
> >> +               cmds[i].in =3D cmd_mem->in;
> >> +               cmds[i].inlen =3D struct_size(cmd_mem, mtt, mttcount);
> >> +
> >> +               fill_create_direct_mr(mvdev, dmr, cmd_mem);
> >> +
> >> +               i++;
> >> +       }
> >> +
> >> +       err =3D mlx5_vdpa_exec_async_cmds(mvdev, cmds, mr->num_directs=
);
> >> +       if (err) {
> >> +
> >> +               mlx5_vdpa_err(mvdev, "error issuing MTT mkey creation =
for direct mrs: %d\n", err);
> >> +               goto done;
> >> +       }
> >> +
> >> +       i =3D 0;
> >> +       list_for_each_entry(dmr, &mr->head, list) {
> >> +               struct mlx5_vdpa_async_cmd *cmd =3D &cmds[i++];
> >> +               struct mlx5_create_mkey_mem *cmd_mem;
> >> +
> >> +               cmd_mem =3D container_of(cmd->out, struct mlx5_create_=
mkey_mem, out);
> >> +
> >> +               if (!cmd->err) {
> >> +                       create_direct_mr_end(mvdev, dmr, cmd_mem);
> >
> > The caller function doesn't trust the result if we return an error.
> > Why not use the previous loop to call create_direct_mr_end? Am I
> > missing any side effect?
> >
> Which previous loop? We have the mkey value only after the command has
> been executed.

Ok, now I see what I proposed didn't make sense, thanks!

> I added the if here (instead of always calling
> create_direct_mr_end()) just to make things more explicit for the
> reader.
>
> >> +               } else {
> >> +                       err =3D err ? err : cmd->err;
> >> +                       mlx5_vdpa_err(mvdev, "error creating MTT mkey =
[0x%llx, 0x%llx]: %d\n",
> >> +                               dmr->start, dmr->end, cmd->err);
> >> +               }
> >> +       }
> >> +
> >> +done:
> >> +       for (i =3D i-1; i >=3D 0; i--) {
> >> +               struct mlx5_create_mkey_mem *cmd_mem;
> >> +
> >> +               cmd_mem =3D container_of(cmds[i].out, struct mlx5_crea=
te_mkey_mem, out);
> >> +               kvfree(cmd_mem);
> >> +       }
> >> +
> >> +       kvfree(cmds);
> >> +       return err;
> >> +}
> >> +
> >>  static int create_indirect_key(struct mlx5_vdpa_dev *mvdev, struct ml=
x5_vdpa_mr *mr)
> >>  {
> >>         int inlen;
> >> @@ -279,14 +355,8 @@ static int map_direct_mr(struct mlx5_vdpa_dev *mv=
dev, struct mlx5_vdpa_direct_mr
> >>                 goto err_map;
> >>         }
> >>
> >> -       err =3D create_direct_mr(mvdev, mr);
> >> -       if (err)
> >> -               goto err_direct;
> >> -
> >>         return 0;
> >>
> >> -err_direct:
> >> -       dma_unmap_sg_attrs(dma, mr->sg_head.sgl, mr->nsg, DMA_BIDIRECT=
IONAL, 0);
> >>  err_map:
> >>         sg_free_table(&mr->sg_head);
> >>         return err;
> >> @@ -401,6 +471,10 @@ static int create_user_mr(struct mlx5_vdpa_dev *m=
vdev,
> >>         if (err)
> >>                 goto err_chain;
> >>
> >> +       err =3D create_direct_keys(mvdev, mr);
> >> +       if (err)
> >> +               goto err_chain;
> >> +
> >>         /* Create the memory key that defines the guests's address spa=
ce. This
> >>          * memory key refers to the direct keys that contain the MTT
> >>          * translations
> >> --
> >> 2.45.1
> >>
> >
>


