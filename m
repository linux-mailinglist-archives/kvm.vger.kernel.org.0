Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F43C64E8F2
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 10:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbiLPJy6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 04:54:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbiLPJy2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 04:54:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1884AF13
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 01:53:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671184415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iQ5juvDY8QXoveNQB37fh+xpnmsAzjIphC/Nhq8m/tY=;
        b=Jps1/27tf+HDGRl1pU+DnZR211DOJ2gcZMM1y1Q1uLc5bCM1JbIf3VNaps7uKb5UNJ28Kl
        EcFHg55PSWSkRj18SWTXMTOxg5sQ4WEIpeVh0yX+Y3UEnHjPdpEfs7M7Gqq+PkUhy2k9u5
        30CtkmcQOFjo8W1qNnB9HYSBq2QGVg8=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-628-4nOjohw1M3OV-_76LkUqkg-1; Fri, 16 Dec 2022 04:53:34 -0500
X-MC-Unique: 4nOjohw1M3OV-_76LkUqkg-1
Received: by mail-ej1-f72.google.com with SMTP id qa18-20020a170907869200b007df87611618so1218972ejc.1
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 01:53:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iQ5juvDY8QXoveNQB37fh+xpnmsAzjIphC/Nhq8m/tY=;
        b=lwksluRUL+1Pb0QsyAVWd/knxni11q0Dzg9r3gH3B47pEI3UBIZzHay0IpOIJP87Nk
         fdbvzogOJ0sO08tv2UPcrtIhr3BB/4LybbFhSYUoWXmxO7g2Cui1SETcyMJ9e2NZdA//
         68M/7InRE8LHfGZWp2dxyTPzDPjodKp45nwMH8ppHdJdDqNwf1coTBV2ZPN76DH4oOgz
         yiB+N7gyRD/+t7JhZhwE2uz32Ko1QxVpA18Vtj2NUC9WmWncnC7hqXMehTpGB4Bun9ZL
         FdZ+cxZKnEdskOCMt/e96Zv9H9S5tkyjIPRS4wXdXJ6ygJNABr4P5Z5Rv7acZisV6l8q
         H2ug==
X-Gm-Message-State: ANoB5plwXTjhe/AtQrknfZVR6kjXd8M25HHHejxMJw/XxlM3+QxNZ0cu
        d3OMpeALuIEHFh0icNgzEvDQsfMTfpqK4h8H6n2GdXfI8PE1x7L3Q+nHz13qJqj5mUUhzMEqDvx
        vmDYMrSbFYJYxdBn/YUdmB9w7NblM
X-Received: by 2002:a17:906:af8c:b0:7c1:e7b:1a6e with SMTP id mj12-20020a170906af8c00b007c10e7b1a6emr12038576ejb.185.1671184413083;
        Fri, 16 Dec 2022 01:53:33 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6y/nef04FmmgCgBHGvnFaTH+nqZnj06eyixWmoZu6VVou6+oD6qrr476NRN1W/Q5fpd4Vq/VmOtLE2Z0fTAes=
X-Received: by 2002:a17:906:af8c:b0:7c1:e7b:1a6e with SMTP id
 mj12-20020a170906af8c00b007c10e7b1a6emr12038574ejb.185.1671184412795; Fri, 16
 Dec 2022 01:53:32 -0800 (PST)
MIME-Version: 1.0
References: <20221215113144.322011-1-eperezma@redhat.com> <20221215113144.322011-7-eperezma@redhat.com>
 <CACGkMEtE_6nci5zwQZbOMbu3e9gh4aa_88WjTgkWkjKqQBB3Zw@mail.gmail.com>
In-Reply-To: <CACGkMEtE_6nci5zwQZbOMbu3e9gh4aa_88WjTgkWkjKqQBB3Zw@mail.gmail.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 16 Dec 2022 10:52:56 +0100
Message-ID: <CAJaqyWcxeuOiHYBb_ftedSrJpNpN9vQJ2sZZ_5cZh4RsQSdgVQ@mail.gmail.com>
Subject: Re: [PATCH v9 06/12] vdpa: request iova_range only once
To:     Jason Wang <jasowang@redhat.com>
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

On Fri, Dec 16, 2022 at 8:29 AM Jason Wang <jasowang@redhat.com> wrote:
>
> On Thu, Dec 15, 2022 at 7:32 PM Eugenio P=C3=A9rez <eperezma@redhat.com> =
wrote:
> >
> > Currently iova range is requested once per queue pair in the case of
> > net. Reduce the number of ioctls asking it once at initialization and
> > reusing that value for each vhost_vdpa.
> >
> > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > ---
> >  hw/virtio/vhost-vdpa.c | 15 ---------------
> >  net/vhost-vdpa.c       | 27 ++++++++++++++-------------
> >  2 files changed, 14 insertions(+), 28 deletions(-)
> >
> > diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
> > index 691bcc811a..9b7f4ef083 100644
> > --- a/hw/virtio/vhost-vdpa.c
> > +++ b/hw/virtio/vhost-vdpa.c
> > @@ -365,19 +365,6 @@ static int vhost_vdpa_add_status(struct vhost_dev =
*dev, uint8_t status)
> >      return 0;
> >  }
> >
> > -static void vhost_vdpa_get_iova_range(struct vhost_vdpa *v)
> > -{
> > -    int ret =3D vhost_vdpa_call(v->dev, VHOST_VDPA_GET_IOVA_RANGE,
> > -                              &v->iova_range);
> > -    if (ret !=3D 0) {
> > -        v->iova_range.first =3D 0;
> > -        v->iova_range.last =3D UINT64_MAX;
> > -    }
> > -
> > -    trace_vhost_vdpa_get_iova_range(v->dev, v->iova_range.first,
> > -                                    v->iova_range.last);
> > -}
> > -
> >  /*
> >   * The use of this function is for requests that only need to be
> >   * applied once. Typically such request occurs at the beginning
> > @@ -465,8 +452,6 @@ static int vhost_vdpa_init(struct vhost_dev *dev, v=
oid *opaque, Error **errp)
> >          goto err;
> >      }
> >
> > -    vhost_vdpa_get_iova_range(v);
> > -
> >      if (!vhost_vdpa_first_dev(dev)) {
> >          return 0;
> >      }
> > diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
> > index 2c0ff6d7b0..b6462f0192 100644
> > --- a/net/vhost-vdpa.c
> > +++ b/net/vhost-vdpa.c
> > @@ -541,14 +541,15 @@ static const VhostShadowVirtqueueOps vhost_vdpa_n=
et_svq_ops =3D {
> >  };
> >
> >  static NetClientState *net_vhost_vdpa_init(NetClientState *peer,
> > -                                           const char *device,
> > -                                           const char *name,
> > -                                           int vdpa_device_fd,
> > -                                           int queue_pair_index,
> > -                                           int nvqs,
> > -                                           bool is_datapath,
> > -                                           bool svq,
> > -                                           VhostIOVATree *iova_tree)
> > +                                       const char *device,
> > +                                       const char *name,
> > +                                       int vdpa_device_fd,
> > +                                       int queue_pair_index,
> > +                                       int nvqs,
> > +                                       bool is_datapath,
> > +                                       bool svq,
> > +                                       struct vhost_vdpa_iova_range io=
va_range,
> > +                                       VhostIOVATree *iova_tree)
>
> Nit: it's better not mix style changes.
>

The style changes are because the new parameter is longer than 80
characters, do you prefer me to send a previous patch reducing
indentation?

Thanks!

> Other than this:
>
> Acked-by: Jason Wang <jasonwang@redhat.com>
>
> Thanks
>
> >  {
> >      NetClientState *nc =3D NULL;
> >      VhostVDPAState *s;
> > @@ -567,6 +568,7 @@ static NetClientState *net_vhost_vdpa_init(NetClien=
tState *peer,
> >      s->vhost_vdpa.device_fd =3D vdpa_device_fd;
> >      s->vhost_vdpa.index =3D queue_pair_index;
> >      s->vhost_vdpa.shadow_vqs_enabled =3D svq;
> > +    s->vhost_vdpa.iova_range =3D iova_range;
> >      s->vhost_vdpa.iova_tree =3D iova_tree;
> >      if (!is_datapath) {
> >          s->cvq_cmd_out_buffer =3D qemu_memalign(qemu_real_host_page_si=
ze(),
> > @@ -646,6 +648,7 @@ int net_init_vhost_vdpa(const Netdev *netdev, const=
 char *name,
> >      int vdpa_device_fd;
> >      g_autofree NetClientState **ncs =3D NULL;
> >      g_autoptr(VhostIOVATree) iova_tree =3D NULL;
> > +    struct vhost_vdpa_iova_range iova_range;
> >      NetClientState *nc;
> >      int queue_pairs, r, i =3D 0, has_cvq =3D 0;
> >
> > @@ -689,14 +692,12 @@ int net_init_vhost_vdpa(const Netdev *netdev, con=
st char *name,
> >          return queue_pairs;
> >      }
> >
> > +    vhost_vdpa_get_iova_range(vdpa_device_fd, &iova_range);
> >      if (opts->x_svq) {
> > -        struct vhost_vdpa_iova_range iova_range;
> > -
> >          if (!vhost_vdpa_net_valid_svq_features(features, errp)) {
> >              goto err_svq;
> >          }
> >
> > -        vhost_vdpa_get_iova_range(vdpa_device_fd, &iova_range);
> >          iova_tree =3D vhost_iova_tree_new(iova_range.first, iova_range=
.last);
> >      }
> >
> > @@ -705,7 +706,7 @@ int net_init_vhost_vdpa(const Netdev *netdev, const=
 char *name,
> >      for (i =3D 0; i < queue_pairs; i++) {
> >          ncs[i] =3D net_vhost_vdpa_init(peer, TYPE_VHOST_VDPA, name,
> >                                       vdpa_device_fd, i, 2, true, opts-=
>x_svq,
> > -                                     iova_tree);
> > +                                     iova_range, iova_tree);
> >          if (!ncs[i])
> >              goto err;
> >      }
> > @@ -713,7 +714,7 @@ int net_init_vhost_vdpa(const Netdev *netdev, const=
 char *name,
> >      if (has_cvq) {
> >          nc =3D net_vhost_vdpa_init(peer, TYPE_VHOST_VDPA, name,
> >                                   vdpa_device_fd, i, 1, false,
> > -                                 opts->x_svq, iova_tree);
> > +                                 opts->x_svq, iova_range, iova_tree);
> >          if (!nc)
> >              goto err;
> >      }
> > --
> > 2.31.1
> >
>

