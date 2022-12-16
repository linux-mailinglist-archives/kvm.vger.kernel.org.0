Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3C064E7BF
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 08:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiLPHaO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 02:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiLPHaM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 02:30:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E3D3F054
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 23:29:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671175758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TW+sv5mYhRvxJF0GOvtPqOs7Ygs+0slBtBfj7fBSikk=;
        b=gJ4ApR3vcDcZZZBilDz4cqJ3bpaU+P7IR8qZYJZ+8YBjpCpsj9TiVk5V8jfRwxECEwqdND
        PtNUy3rJn2xNeYEDuoUiEwGscwuhzaN2BoDkV0ANhLHC9tJwCPMU2og6WEahNiDSAqzSow
        jpO6BmxlOKECZmunHLaaVRBTBuTO5iM=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-48-F1yylQF8PNmzu4H2fnP3BQ-1; Fri, 16 Dec 2022 02:29:16 -0500
X-MC-Unique: F1yylQF8PNmzu4H2fnP3BQ-1
Received: by mail-ot1-f72.google.com with SMTP id x26-20020a9d6d9a000000b00672c2f06716so912049otp.21
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 23:29:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TW+sv5mYhRvxJF0GOvtPqOs7Ygs+0slBtBfj7fBSikk=;
        b=Df/4cRIgzHi1yJdMjMuO1cSnFIaZoCeA/DJGN3h41YZZkSoQ2fiJppfNeMiiVy7TQE
         ogFIEM/b1vpn6LwwIu2mjRDXR2jGcBjP7T6oDhyZVRIjoXL8YKhQHWfyr0GxBw12DiQM
         rIxQv4SPdQ3kbbKIX7pshQRcog4ylk3yb57ndzhT0Xtfg2tu712rcAaXqyZ5hFGe3FX/
         0qr0Qmng5tz7Cvj2T3LKbfOoXnBXPWVPPuVkdBpL9uAxNsHcpAU4C7E9AnmkQYmF5bcd
         1SggWSNO5vihLVgFwaAkZTMwIITOX5RhDzvuTo2xJ96t3qtBlWzUDK0lqoGBNWYKj+ie
         UByA==
X-Gm-Message-State: AFqh2krITkDF5EJFAQMgoro0p6mMpK56l0yzfg0zJ+jeOG733DhU5Px2
        U8Rb7hlKp7WXt5rc6gan6OQ/NgYOkRsbnbfvbe5wq4mdReQC7BCdwwK3Duf1eUQDq6sFNdAqc1j
        F4m2UQpggryncOSYZapxYR1ZTDe96
X-Received: by 2002:a05:6870:bb1a:b0:144:b22a:38d3 with SMTP id nw26-20020a056870bb1a00b00144b22a38d3mr872723oab.280.1671175755889;
        Thu, 15 Dec 2022 23:29:15 -0800 (PST)
X-Google-Smtp-Source: AMrXdXusEFPcQUgv8vWQpDBGlYmgo/nVhMOtk5zg4py81ZTLkbfbNHejRxyk1WzIGWqY0Or4Lgg2VyCQoA1j+incrFU=
X-Received: by 2002:a05:6870:bb1a:b0:144:b22a:38d3 with SMTP id
 nw26-20020a056870bb1a00b00144b22a38d3mr872708oab.280.1671175755609; Thu, 15
 Dec 2022 23:29:15 -0800 (PST)
MIME-Version: 1.0
References: <20221215113144.322011-1-eperezma@redhat.com> <20221215113144.322011-7-eperezma@redhat.com>
In-Reply-To: <20221215113144.322011-7-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 16 Dec 2022 15:29:04 +0800
Message-ID: <CACGkMEtE_6nci5zwQZbOMbu3e9gh4aa_88WjTgkWkjKqQBB3Zw@mail.gmail.com>
Subject: Re: [PATCH v9 06/12] vdpa: request iova_range only once
To:     =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>
Cc:     qemu-devel@nongnu.org, Liuxiangdong <liuxiangdong5@huawei.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Laurent Vivier <lvivier@redhat.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Cindy Lu <lulu@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>, Eli Cohen <eli@mellanox.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Longpeng <longpeng2@huawei.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Parav Pandit <parav@mellanox.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 15, 2022 at 7:32 PM Eugenio P=C3=A9rez <eperezma@redhat.com> wr=
ote:
>
> Currently iova range is requested once per queue pair in the case of
> net. Reduce the number of ioctls asking it once at initialization and
> reusing that value for each vhost_vdpa.
>
> Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> ---
>  hw/virtio/vhost-vdpa.c | 15 ---------------
>  net/vhost-vdpa.c       | 27 ++++++++++++++-------------
>  2 files changed, 14 insertions(+), 28 deletions(-)
>
> diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> index 691bcc811a..9b7f4ef083 100644
> --- a/hw/virtio/vhost-vdpa.c
> +++ b/hw/virtio/vhost-vdpa.c
> @@ -365,19 +365,6 @@ static int vhost_vdpa_add_status(struct vhost_dev *d=
ev, uint8_t status)
>      return 0;
>  }
>
> -static void vhost_vdpa_get_iova_range(struct vhost_vdpa *v)
> -{
> -    int ret =3D vhost_vdpa_call(v->dev, VHOST_VDPA_GET_IOVA_RANGE,
> -                              &v->iova_range);
> -    if (ret !=3D 0) {
> -        v->iova_range.first =3D 0;
> -        v->iova_range.last =3D UINT64_MAX;
> -    }
> -
> -    trace_vhost_vdpa_get_iova_range(v->dev, v->iova_range.first,
> -                                    v->iova_range.last);
> -}
> -
>  /*
>   * The use of this function is for requests that only need to be
>   * applied once. Typically such request occurs at the beginning
> @@ -465,8 +452,6 @@ static int vhost_vdpa_init(struct vhost_dev *dev, voi=
d *opaque, Error **errp)
>          goto err;
>      }
>
> -    vhost_vdpa_get_iova_range(v);
> -
>      if (!vhost_vdpa_first_dev(dev)) {
>          return 0;
>      }
> diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
> index 2c0ff6d7b0..b6462f0192 100644
> --- a/net/vhost-vdpa.c
> +++ b/net/vhost-vdpa.c
> @@ -541,14 +541,15 @@ static const VhostShadowVirtqueueOps vhost_vdpa_net=
_svq_ops =3D {
>  };
>
>  static NetClientState *net_vhost_vdpa_init(NetClientState *peer,
> -                                           const char *device,
> -                                           const char *name,
> -                                           int vdpa_device_fd,
> -                                           int queue_pair_index,
> -                                           int nvqs,
> -                                           bool is_datapath,
> -                                           bool svq,
> -                                           VhostIOVATree *iova_tree)
> +                                       const char *device,
> +                                       const char *name,
> +                                       int vdpa_device_fd,
> +                                       int queue_pair_index,
> +                                       int nvqs,
> +                                       bool is_datapath,
> +                                       bool svq,
> +                                       struct vhost_vdpa_iova_range iova=
_range,
> +                                       VhostIOVATree *iova_tree)

Nit: it's better not mix style changes.

Other than this:

Acked-by: Jason Wang <jasonwang@redhat.com>

Thanks

>  {
>      NetClientState *nc =3D NULL;
>      VhostVDPAState *s;
> @@ -567,6 +568,7 @@ static NetClientState *net_vhost_vdpa_init(NetClientS=
tate *peer,
>      s->vhost_vdpa.device_fd =3D vdpa_device_fd;
>      s->vhost_vdpa.index =3D queue_pair_index;
>      s->vhost_vdpa.shadow_vqs_enabled =3D svq;
> +    s->vhost_vdpa.iova_range =3D iova_range;
>      s->vhost_vdpa.iova_tree =3D iova_tree;
>      if (!is_datapath) {
>          s->cvq_cmd_out_buffer =3D qemu_memalign(qemu_real_host_page_size=
(),
> @@ -646,6 +648,7 @@ int net_init_vhost_vdpa(const Netdev *netdev, const c=
har *name,
>      int vdpa_device_fd;
>      g_autofree NetClientState **ncs =3D NULL;
>      g_autoptr(VhostIOVATree) iova_tree =3D NULL;
> +    struct vhost_vdpa_iova_range iova_range;
>      NetClientState *nc;
>      int queue_pairs, r, i =3D 0, has_cvq =3D 0;
>
> @@ -689,14 +692,12 @@ int net_init_vhost_vdpa(const Netdev *netdev, const=
 char *name,
>          return queue_pairs;
>      }
>
> +    vhost_vdpa_get_iova_range(vdpa_device_fd, &iova_range);
>      if (opts->x_svq) {
> -        struct vhost_vdpa_iova_range iova_range;
> -
>          if (!vhost_vdpa_net_valid_svq_features(features, errp)) {
>              goto err_svq;
>          }
>
> -        vhost_vdpa_get_iova_range(vdpa_device_fd, &iova_range);
>          iova_tree =3D vhost_iova_tree_new(iova_range.first, iova_range.l=
ast);
>      }
>
> @@ -705,7 +706,7 @@ int net_init_vhost_vdpa(const Netdev *netdev, const c=
har *name,
>      for (i =3D 0; i < queue_pairs; i++) {
>          ncs[i] =3D net_vhost_vdpa_init(peer, TYPE_VHOST_VDPA, name,
>                                       vdpa_device_fd, i, 2, true, opts->x=
_svq,
> -                                     iova_tree);
> +                                     iova_range, iova_tree);
>          if (!ncs[i])
>              goto err;
>      }
> @@ -713,7 +714,7 @@ int net_init_vhost_vdpa(const Netdev *netdev, const c=
har *name,
>      if (has_cvq) {
>          nc =3D net_vhost_vdpa_init(peer, TYPE_VHOST_VDPA, name,
>                                   vdpa_device_fd, i, 1, false,
> -                                 opts->x_svq, iova_tree);
> +                                 opts->x_svq, iova_range, iova_tree);
>          if (!nc)
>              goto err;
>      }
> --
> 2.31.1
>

