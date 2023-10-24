Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1B0A7D545C
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 16:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343664AbjJXOvq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 10:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234591AbjJXOvo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 10:51:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E23111
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 07:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698159060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9Xiik0NE4szN4ijrGto693xxU2iK32XszRvGW7POOdw=;
        b=AGiMhusdF+LERjw60lMx7vC6VUXYW37TKTs8LLCRUTAY1ysLJS9IAE7gfjsnCzShAOtpHf
        Ot79yRFsD8knl1TLqiAYNfoaAYR5zvte4SC/s3rwMFFYqUoPTg8jD3c4Q7lfSqqXiUDVGz
        IuKGbdzbiuEZbl77O1lVEctjTxqJhpQ=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-191-4XkSwBDONLau7SNo_ThyBA-1; Tue, 24 Oct 2023 10:50:58 -0400
X-MC-Unique: 4XkSwBDONLau7SNo_ThyBA-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-5a81a80097fso60564427b3.3
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 07:50:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698159058; x=1698763858;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Xiik0NE4szN4ijrGto693xxU2iK32XszRvGW7POOdw=;
        b=L0Li53f113LcV583bmseDjvRFwqi6XW5UynCMp/V8Jhq/Jzn27jIjZpaWSXWF2/C+P
         yy0erBW5eVpSsp11rcRnS8q7HsXC7uiYHY/RuJC2G81GxD9FAz2heOL6E8rUZHmrSDsM
         I8O0ckWGMZ7f7kEY/MH4L6tCTP9/IZHgwDf8vLdqjQp5Am+iLCs0Zm+RaoxKhRPGXqt8
         8bUtminmE3k4HP3bggBPPxkXKWahAtq7TJLeDu5szVtksTDbcI0M3Gpcmv0KN4jzF0+q
         sSJLH1gzABQH26KFD+Oxe/OM63ILhvuLcfm/PrVCV03k7p98QtCYmqfhHDuxfjzN0hJS
         ye5Q==
X-Gm-Message-State: AOJu0Yz33p8MzWThLqto/DtGzc0g7IOICiXgWk6QMQyQEtMgRZOK+fFj
        GZXmcLuwC5llnBzZTVDqrshXZ5pR3u3n8n8BsIXxAOzZS5So/ftxM5K3ENHDlxf2pGRGjv7n/1z
        vSWsJk15VC10yC94SaDsOmrS6e3Un
X-Received: by 2002:a0d:e684:0:b0:5a8:bbeb:38a5 with SMTP id p126-20020a0de684000000b005a8bbeb38a5mr12688392ywe.42.1698159058047;
        Tue, 24 Oct 2023 07:50:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH1ZFBA8Sp56G+nijEW83iu8Q5TJ7Ju6egy5eDF4N3d10AQufDYx3bCVO9iNtIJgcvMxLVDOEkVk8BzlvqIuIc=
X-Received: by 2002:a0d:e684:0:b0:5a8:bbeb:38a5 with SMTP id
 p126-20020a0de684000000b005a8bbeb38a5mr12688373ywe.42.1698159057736; Tue, 24
 Oct 2023 07:50:57 -0700 (PDT)
MIME-Version: 1.0
References: <20231018171456.1624030-2-dtatulea@nvidia.com> <20231018171456.1624030-14-dtatulea@nvidia.com>
 <a164fb3975cf9f574314fffba0f2e67bec7e2851.camel@nvidia.com>
 <CAJaqyWfuVV57syaUWkh7-QJ_rKHCPpKbHLv7LdN6j_KeGez2VQ@mail.gmail.com> <63f678675497539fc695f9de38550170aa45382a.camel@nvidia.com>
In-Reply-To: <63f678675497539fc695f9de38550170aa45382a.camel@nvidia.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Tue, 24 Oct 2023 16:50:21 +0200
Message-ID: <CAJaqyWfa1=OSypE7L=F-U1EXFSm2HeNKamOo--WsGtmRAwegyw@mail.gmail.com>
Subject: Re: [PATCH vhost v4 12/16] vdpa/mlx5: Improve mr update flow
To:     Dragos Tatulea <dtatulea@nvidia.com>
Cc:     "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>,
        Parav Pandit <parav@nvidia.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "si-wei.liu@oracle.com" <si-wei.liu@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023 at 10:07=E2=80=AFAM Dragos Tatulea <dtatulea@nvidia.co=
m> wrote:
>
> On Fri, 2023-10-20 at 18:01 +0200, Eugenio Perez Martin wrote:
> > On Wed, Oct 18, 2023 at 7:21=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia=
.com> wrote:
> > >
> > > On Wed, 2023-10-18 at 20:14 +0300, Dragos Tatulea wrote:
> > > > The current flow for updating an mr works directly on mvdev->mr whi=
ch
> > > > makes it cumbersome to handle multiple new mr structs.
> > > >
> > > > This patch makes the flow more straightforward by having
> > > > mlx5_vdpa_create_mr return a new mr which will update the old mr (i=
f
> > > > any). The old mr will be deleted and unlinked from mvdev. For the c=
ase
> > > > when the iotlb is empty (not NULL), the old mr will be cleared.
> > > >
> > > > This change paves the way for adding mrs for different ASIDs.
> > > >
> > > > The initialized bool is no longer needed as mr is now a pointer in =
the
> > > > mlx5_vdpa_dev struct which will be NULL when not initialized.
> > > >
> > > > Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > > > Acked-by: Jason Wang <jasowang@redhat.com>
> > > > Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> > > > ---
> > > >  drivers/vdpa/mlx5/core/mlx5_vdpa.h | 14 +++--
> > > >  drivers/vdpa/mlx5/core/mr.c        | 87 ++++++++++++++++----------=
----
> > > >  drivers/vdpa/mlx5/net/mlx5_vnet.c  | 53 +++++++++---------
> > > >  3 files changed, 82 insertions(+), 72 deletions(-)
> > > >
> > > > diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
> > > > b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
> > > > index 9c6ac42c21e1..bbe4335106bd 100644
> > > > --- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
> > > > +++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
> > > > @@ -31,8 +31,6 @@ struct mlx5_vdpa_mr {
> > > >         struct list_head head;
> > > >         unsigned long num_directs;
> > > >         unsigned long num_klms;
> > > > -       /* state of dvq mr */
> > > > -       bool initialized;
> > > >
> > > >         bool user_mr;
> > > >  };
> > > > @@ -91,7 +89,7 @@ struct mlx5_vdpa_dev {
> > > >         u16 max_idx;
> > > >         u32 generation;
> > > >
> > > > -       struct mlx5_vdpa_mr mr;
> > > > +       struct mlx5_vdpa_mr *mr;
> > > >         /* serialize mr access */
> > > >         struct mutex mr_mtx;
> > > >         struct mlx5_control_vq cvq;
> > > > @@ -114,14 +112,14 @@ void mlx5_vdpa_free_resources(struct mlx5_vdp=
a_dev
> > > > *mvdev);
> > > >  int mlx5_vdpa_create_mkey(struct mlx5_vdpa_dev *mvdev, u32 *mkey, =
u32
> > > > *in,
> > > >                           int inlen);
> > > >  int mlx5_vdpa_destroy_mkey(struct mlx5_vdpa_dev *mvdev, u32 mkey);
> > > > -int mlx5_vdpa_handle_set_map(struct mlx5_vdpa_dev *mvdev, struct
> > > > vhost_iotlb
> > > > *iotlb,
> > > > -                            bool *change_map, unsigned int asid);
> > > > -int mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
> > > > -                       struct mlx5_vdpa_mr *mr,
> > > > -                       struct vhost_iotlb *iotlb);
> > > > +struct mlx5_vdpa_mr *mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvd=
ev,
> > > > +                                        struct vhost_iotlb *iotlb)=
;
> > > >  void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev);
> > > >  void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev,
> > > >                           struct mlx5_vdpa_mr *mr);
> > > > +void mlx5_vdpa_update_mr(struct mlx5_vdpa_dev *mvdev,
> > > > +                        struct mlx5_vdpa_mr *mr,
> > > > +                        unsigned int asid);
> > > >  int mlx5_vdpa_update_cvq_iotlb(struct mlx5_vdpa_dev *mvdev,
> > > >                                 struct vhost_iotlb *iotlb,
> > > >                                 unsigned int asid);
> > > > diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/m=
r.c
> > > > index abd6a6fb122f..00eff5a07152 100644
> > > > --- a/drivers/vdpa/mlx5/core/mr.c
> > > > +++ b/drivers/vdpa/mlx5/core/mr.c
> > > > @@ -495,30 +495,51 @@ static void destroy_user_mr(struct mlx5_vdpa_=
dev
> > > > *mvdev,
> > > > struct mlx5_vdpa_mr *mr
> > > >
> > > >  static void _mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev, str=
uct
> > > > mlx5_vdpa_mr *mr)
> > > >  {
> > > > -       if (!mr->initialized)
> > > > -               return;
> > > > -
> > > >         if (mr->user_mr)
> > > >                 destroy_user_mr(mvdev, mr);
> > > >         else
> > > >                 destroy_dma_mr(mvdev, mr);
> > > > -
> > > > -       mr->initialized =3D false;
> > > >  }
> > > >
> > > >  void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev,
> > > >                           struct mlx5_vdpa_mr *mr)
> > > >  {
> > > > +       if (!mr)
> > > > +               return;
> > > > +
> > > >         mutex_lock(&mvdev->mr_mtx);
> > > >
> > > >         _mlx5_vdpa_destroy_mr(mvdev, mr);
> > > >
> > > > +       if (mvdev->mr =3D=3D mr)
> > > > +               mvdev->mr =3D NULL;
> > > > +
> > > > +       mutex_unlock(&mvdev->mr_mtx);
> > > > +
> > > > +       kfree(mr);
> > > > +}
> > > > +
> > > > +void mlx5_vdpa_update_mr(struct mlx5_vdpa_dev *mvdev,
> > > > +                        struct mlx5_vdpa_mr *new_mr,
> > > > +                        unsigned int asid)
> > > > +{
> > > > +       struct mlx5_vdpa_mr *old_mr =3D mvdev->mr;
> > > > +
> > > > +       mutex_lock(&mvdev->mr_mtx);
> > > > +
> > > > +       mvdev->mr =3D new_mr;
> > > > +       if (old_mr) {
> > > > +               _mlx5_vdpa_destroy_mr(mvdev, old_mr);
> > > > +               kfree(old_mr);
> > > > +       }
> > > > +
> > > >         mutex_unlock(&mvdev->mr_mtx);
> > > > +
> > > >  }
> > > >
> > > >  void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev)
> > > >  {
> > > > -       mlx5_vdpa_destroy_mr(mvdev, &mvdev->mr);
> > > > +       mlx5_vdpa_destroy_mr(mvdev, mvdev->mr);
> > > >         prune_iotlb(mvdev);
> > > >  }
> > > >
> > > > @@ -528,52 +549,36 @@ static int _mlx5_vdpa_create_mr(struct mlx5_v=
dpa_dev
> > > > *mvdev,
> > > >  {
> > > >         int err;
> > > >
> > > > -       if (mr->initialized)
> > > > -               return 0;
> > > > -
> > > >         if (iotlb)
> > > >                 err =3D create_user_mr(mvdev, mr, iotlb);
> > > >         else
> > > >                 err =3D create_dma_mr(mvdev, mr);
> > > >
> > > > -       if (err)
> > > > -               return err;
> > > > -
> > > > -       mr->initialized =3D true;
> > > > -
> > > > -       return 0;
> > > > +       return err;
> > > >  }
> > > >
> > > > -int mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvdev,
> > > > -                       struct mlx5_vdpa_mr *mr,
> > > > -                       struct vhost_iotlb *iotlb)
> > > > +struct mlx5_vdpa_mr *mlx5_vdpa_create_mr(struct mlx5_vdpa_dev *mvd=
ev,
> > > > +                                        struct vhost_iotlb *iotlb)
> > > >  {
> > > > +       struct mlx5_vdpa_mr *mr;
> > > >         int err;
> > > >
> > > > +       mr =3D kzalloc(sizeof(*mr), GFP_KERNEL);
> > > > +       if (!mr)
> > > > +               return ERR_PTR(-ENOMEM);
> > > > +
> > > >         mutex_lock(&mvdev->mr_mtx);
> > > >         err =3D _mlx5_vdpa_create_mr(mvdev, mr, iotlb);
> > > >         mutex_unlock(&mvdev->mr_mtx);
> > > >
> > > > -       return err;
> > > > -}
> > > > -
> > > > -int mlx5_vdpa_handle_set_map(struct mlx5_vdpa_dev *mvdev, struct
> > > > vhost_iotlb
> > > > *iotlb,
> > > > -                            bool *change_map, unsigned int asid)
> > > > -{
> > > > -       struct mlx5_vdpa_mr *mr =3D &mvdev->mr;
> > > > -       int err =3D 0;
> > > > +       if (err)
> > > > +               goto out_err;
> > > >
> > > > -       *change_map =3D false;
> > > > -       mutex_lock(&mvdev->mr_mtx);
> > > > -       if (mr->initialized) {
> > > > -               mlx5_vdpa_info(mvdev, "memory map update\n");
> > > > -               *change_map =3D true;
> > > > -       }
> > > > -       if (!*change_map)
> > > > -               err =3D _mlx5_vdpa_create_mr(mvdev, mr, iotlb);
> > > > -       mutex_unlock(&mvdev->mr_mtx);
> > > > +       return mr;
> > > >
> > > > -       return err;
> > > > +out_err:
> > > > +       kfree(mr);
> > > > +       return ERR_PTR(err);
> > > >  }
> > > >
> > > >  int mlx5_vdpa_update_cvq_iotlb(struct mlx5_vdpa_dev *mvdev,
> > > > @@ -597,11 +602,13 @@ int mlx5_vdpa_update_cvq_iotlb(struct mlx5_vd=
pa_dev
> > > > *mvdev,
> > > >
> > > >  int mlx5_vdpa_create_dma_mr(struct mlx5_vdpa_dev *mvdev)
> > > >  {
> > > > -       int err;
> > > > +       struct mlx5_vdpa_mr *mr;
> > > >
> > > > -       err =3D mlx5_vdpa_create_mr(mvdev, &mvdev->mr, NULL);
> > > > -       if (err)
> > > > -               return err;
> > > > +       mr =3D mlx5_vdpa_create_mr(mvdev, NULL);
> > > > +       if (IS_ERR(mr))
> > > > +               return PTR_ERR(mr);
> > > > +
> > > > +       mlx5_vdpa_update_mr(mvdev, mr, 0);
> > > >
> > > >         return mlx5_vdpa_update_cvq_iotlb(mvdev, NULL, 0);
> > > >  }
> > > > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > index 256fdd80c321..7b878995b6aa 100644
> > > > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > > @@ -873,7 +873,7 @@ static int create_virtqueue(struct mlx5_vdpa_ne=
t
> > > > *ndev,
> > > > struct mlx5_vdpa_virtque
> > > >         MLX5_SET64(virtio_q, vq_ctx, desc_addr, mvq->desc_addr);
> > > >         MLX5_SET64(virtio_q, vq_ctx, used_addr, mvq->device_addr);
> > > >         MLX5_SET64(virtio_q, vq_ctx, available_addr, mvq->driver_ad=
dr);
> > > > -       MLX5_SET(virtio_q, vq_ctx, virtio_q_mkey, ndev->mvdev.mr.mk=
ey);
> > > > +       MLX5_SET(virtio_q, vq_ctx, virtio_q_mkey, ndev->mvdev.mr->m=
key);
> > > >         MLX5_SET(virtio_q, vq_ctx, umem_1_id, mvq->umem1.id);
> > > >         MLX5_SET(virtio_q, vq_ctx, umem_1_size, mvq->umem1.size);
> > > >         MLX5_SET(virtio_q, vq_ctx, umem_2_id, mvq->umem2.id);
> > > > @@ -2633,7 +2633,7 @@ static void restore_channels_info(struct
> > > > mlx5_vdpa_net
> > > > *ndev)
> > > >  }
> > > >
> > > >  static int mlx5_vdpa_change_map(struct mlx5_vdpa_dev *mvdev,
> > > > -                               struct vhost_iotlb *iotlb, unsigned=
 int
> > > > asid)
> > > > +                               struct mlx5_vdpa_mr *new_mr, unsign=
ed int
> > > > asid)
> > > >  {
> > > >         struct mlx5_vdpa_net *ndev =3D to_mlx5_vdpa_ndev(mvdev);
> > > >         int err;
> > > > @@ -2641,27 +2641,18 @@ static int mlx5_vdpa_change_map(struct
> > > > mlx5_vdpa_dev
> > > > *mvdev,
> > > >         suspend_vqs(ndev);
> > > >         err =3D save_channels_info(ndev);
> > > >         if (err)
> > > > -               goto err_mr;
> > > > +               return err;
> > > >
> > > >         teardown_driver(ndev);
> > > > -       mlx5_vdpa_destroy_mr(mvdev, &mvdev->mr);
> > > > -       err =3D mlx5_vdpa_create_mr(mvdev, &mvdev->mr, iotlb);
> > > > -       if (err)
> > > > -               goto err_mr;
> > > > +
> > > > +       mlx5_vdpa_update_mr(mvdev, new_mr, asid);
> > > >
> > > >         if (!(mvdev->status & VIRTIO_CONFIG_S_DRIVER_OK) || mvdev-
> > > > >suspended)
> > > > -               goto err_mr;
> > > > +               return 0;
> > > >
> > > >         restore_channels_info(ndev);
> > > >         err =3D setup_driver(mvdev);
> > > > -       if (err)
> > > > -               goto err_setup;
> > > > -
> > > > -       return 0;
> > > >
> > > > -err_setup:
> > > > -       mlx5_vdpa_destroy_mr(mvdev, &mvdev->mr);
> > > > -err_mr:
> > > >         return err;
> > > >  }
> > > >
> > > > @@ -2875,26 +2866,40 @@ static u32 mlx5_vdpa_get_generation(struct
> > > > vdpa_device
> > > > *vdev)
> > > >  static int set_map_data(struct mlx5_vdpa_dev *mvdev, struct vhost_=
iotlb
> > > > *iotlb,
> > > >                         unsigned int asid)
> > > >  {
> > > > -       bool change_map;
> > > > +       struct mlx5_vdpa_mr *new_mr;
> > > >         int err;
> > > >
> > > >         if (mvdev->group2asid[MLX5_VDPA_DATAVQ_GROUP] !=3D asid)
> > > >                 goto end;
> > > >
> > > > -       err =3D mlx5_vdpa_handle_set_map(mvdev, iotlb, &change_map,=
 asid);
> > > > -       if (err) {
> > > > -               mlx5_vdpa_warn(mvdev, "set map failed(%d)\n", err);
> > > > -               return err;
> > > > +       if (vhost_iotlb_itree_first(iotlb, 0, U64_MAX)) {
> > > > +               new_mr =3D mlx5_vdpa_create_mr(mvdev, iotlb);
> > > > +               if (IS_ERR(new_mr)) {
> > > > +                       err =3D PTR_ERR(new_mr);
> > > > +                       mlx5_vdpa_warn(mvdev, "create map failed(%d=
)\n",
> > > > err);
> > > > +                       return err;
> > > > +               }
> > > > +       } else {
> > > > +               /* Empty iotlbs don't have an mr but will clear the
> > > > previous
> > > > mr. */
> > > > +               new_mr =3D NULL;
> > > >         }
> > > Hi Jason and/or Eugenio, could you have a quick look at this part of =
the
> > > patch
> > > that changed please?
> > >
> > > Thanks,
> > > Dragos
> > > >
> > > > -       if (change_map) {
> > > > -               err =3D mlx5_vdpa_change_map(mvdev, iotlb, asid);
> > > > -               if (err)
> > > > -                       return err;
> > > > +       if (!mvdev->mr) {
> > > > +               mlx5_vdpa_update_mr(mvdev, new_mr, asid);
> > > > +       } else {
> > > > +               err =3D mlx5_vdpa_change_map(mvdev, new_mr, asid);
> > > > +               if (err) {
> > > > +                       mlx5_vdpa_warn(mvdev, "change map failed(%d=
)\n",
> > > > err);
> > > > +                       goto out_err;
> > > > +               }
> > > >         }
> > > >
> > > >  end:
> > > >         return mlx5_vdpa_update_cvq_iotlb(mvdev, iotlb, asid);
> > > > +
> > > > +out_err:
> > > > +       mlx5_vdpa_destroy_mr(mvdev, new_mr);
> >
> > Is it possible to reach this mlx5_vdpa_destroy_mr call with new_mr =3D=
=3D
> > NULL? Like:
> > * iotlb does not have any entries
> > * mdev already has a mr
> > * mlx5_vdpa_change_map fails
> >
> It could happen.
>
> > If I'm not wrong, mlx5_vdpa_destroy_mr may dereference new_mr through
> > _mlx5_vdpa_destroy_mr -> vhost_iotlb_free(mr->iotlb).
> >
> mlx5_vdpa_destroy_mr checks for mr being NULL first.
>
> The other place where _mlx5_vdpa_destroy_mr gets called is from
> mlx5_vdpa_update_mr on the old mr IF it exists (it is not NULL).
>
> This looks safe to me.
>

Right, I don't know how I missed that, sorry for the noise! Already
acked in the patch message, but just in case:

Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

Thanks!

> Thanks,
> Dragos
>
> > Am I missing something?
> >
> > Thanks!
> >
> >
> >
> >
> > > > +       return err;
> > > >  }
> > > >
> > > >  static int mlx5_vdpa_set_map(struct vdpa_device *vdev, unsigned in=
t asid,
> > >
> >
>

