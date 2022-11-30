Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1AD63CFC8
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 08:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234138AbiK3Hls (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 02:41:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234098AbiK3Hln (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 02:41:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0176D4387F
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 23:40:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669794048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fqsdq4+gbDbt6QLOdb+PUFxkECVhWTcDal9kfMorJH0=;
        b=hVi4MMefJ0q+8DSOvMx822AtMTDnHuRYGSrD3TYs2hrUsCBQtyZ5x1BiLAVCe/4GoO39WO
        h6Mt3zsjwhNur39vCgW1j5nyqEA6ipiurWWcHxzCMonro0N9TboLBYrRIB7VhdWovvRmUz
        Dks1Nr+noH/ICGSOmW7Pr+zX54Oge5M=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-512-LnMO-jRhMOKdoyeau6RLfg-1; Wed, 30 Nov 2022 02:40:46 -0500
X-MC-Unique: LnMO-jRhMOKdoyeau6RLfg-1
Received: by mail-ed1-f69.google.com with SMTP id z3-20020a056402274300b0046b14f99390so4928871edd.9
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 23:40:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fqsdq4+gbDbt6QLOdb+PUFxkECVhWTcDal9kfMorJH0=;
        b=Yrxo2zwuqcLYuSkHis19rk4y1P+DM5dv0CfGnn8F58NXNtJ/AZDIjLRMo8RRQdB1c7
         jVC0v98k6eLNpJUPCUXw9rDx8IraziNiNMxZOJ9pAtH3l13v0QpN/boqKzHUu+IKQjxe
         FXH4IKi13VURLoPPySxsF2fgzrEEqdyMfg20fUy9EZmm5Arh4UsMOmTPvcTSR0EGopAv
         a95wcK2WB+5EOZJW2RLFd2LwlfVuA6HbNeMZzX7DcJHKL/FKNPnm7X/gDW3k9c+9aJIi
         wSqOaQUuOFny/d0VQx71rkhe5D3Bn3hj7L6lb5VsGSX6s4eFKKcyPqXpYnDeSDfUe7Sf
         WMfg==
X-Gm-Message-State: ANoB5pk1CEg8DSs74gHFEweu1GAtW/OWnYCd/BvaH+J3mx0DZ/aZX7WU
        RYaiGu3xLe2XbX3O1eImWFj4fEDsO68RCZGYWFkVl2s+Qy0v7MTavLsfWMZhfxSFKhxvFTduCDe
        HV74vSjWS8xa5ReJQe+/JAFidSLZ/
X-Received: by 2002:a05:6402:4284:b0:461:8156:e0ca with SMTP id g4-20020a056402428400b004618156e0camr357785edc.271.1669794045634;
        Tue, 29 Nov 2022 23:40:45 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4Ax4pmTEP78aJ8j098xQBZ+I5N2Zza6C/OzSIo5c7paoOyBpi09BnoxT9VtU6GsL1yqGy5ri/VBFxje8vwiRA=
X-Received: by 2002:a05:6402:4284:b0:461:8156:e0ca with SMTP id
 g4-20020a056402428400b004618156e0camr357776edc.271.1669794045408; Tue, 29 Nov
 2022 23:40:45 -0800 (PST)
MIME-Version: 1.0
References: <20221124155158.2109884-1-eperezma@redhat.com> <20221124155158.2109884-7-eperezma@redhat.com>
 <CACGkMEubBA9NYR5ynT_2C=iMEk3fph2GEOBvcw73BOuqiFKzJg@mail.gmail.com>
In-Reply-To: <CACGkMEubBA9NYR5ynT_2C=iMEk3fph2GEOBvcw73BOuqiFKzJg@mail.gmail.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Wed, 30 Nov 2022 08:40:07 +0100
Message-ID: <CAJaqyWcR_3vdXLJ4=z+_uaoVN47gEXr7KHx3w6z8HtmqquK7zA@mail.gmail.com>
Subject: Re: [PATCH for 8.0 v8 06/12] vdpa: extract vhost_vdpa_svq_allocate_iova_tree
To:     Jason Wang <jasowang@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        Eli Cohen <eli@mellanox.com>, Cindy Lu <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>
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

On Wed, Nov 30, 2022 at 7:43 AM Jason Wang <jasowang@redhat.com> wrote:
>
> On Thu, Nov 24, 2022 at 11:52 PM Eugenio P=C3=A9rez <eperezma@redhat.com>=
 wrote:
> >
> > It can be allocated either if all virtqueues must be shadowed or if
> > vdpa-net detects it can shadow only cvq.
> >
> > Extract in its own function so we can reuse it.
> >
> > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > ---
> >  net/vhost-vdpa.c | 29 +++++++++++++++++------------
> >  1 file changed, 17 insertions(+), 12 deletions(-)
> >
> > diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
> > index 88e0eec5fa..9ee3bc4cd3 100644
> > --- a/net/vhost-vdpa.c
> > +++ b/net/vhost-vdpa.c
> > @@ -240,6 +240,22 @@ static NetClientInfo net_vhost_vdpa_info =3D {
> >          .check_peer_type =3D vhost_vdpa_check_peer_type,
> >  };
> >
> > +static int vhost_vdpa_get_iova_range(int fd,
> > +                                     struct vhost_vdpa_iova_range *iov=
a_range)
> > +{
> > +    int ret =3D ioctl(fd, VHOST_VDPA_GET_IOVA_RANGE, iova_range);
> > +
> > +    return ret < 0 ? -errno : 0;
> > +}
>
> I don't get why this needs to be moved to net specific code.
>

It was already in net, this code just extracted it in its own function.

It's done in net because iova_tree must be the same for all queuepair
vhost, so we need to allocate before them.

Thanks!

> Thanks
>
> > +
> > +static VhostIOVATree *vhost_vdpa_svq_allocate_iova_tree(int vdpa_devic=
e_fd)
> > +{
> > +    struct vhost_vdpa_iova_range iova_range;
> > +
> > +    vhost_vdpa_get_iova_range(vdpa_device_fd, &iova_range);
> > +    return vhost_iova_tree_new(iova_range.first, iova_range.last);
> > +}
> > +
> >  static void vhost_vdpa_cvq_unmap_buf(struct vhost_vdpa *v, void *addr)
> >  {
> >      VhostIOVATree *tree =3D v->iova_tree;
> > @@ -587,14 +603,6 @@ static NetClientState *net_vhost_vdpa_init(NetClie=
ntState *peer,
> >      return nc;
> >  }
> >
> > -static int vhost_vdpa_get_iova_range(int fd,
> > -                                     struct vhost_vdpa_iova_range *iov=
a_range)
> > -{
> > -    int ret =3D ioctl(fd, VHOST_VDPA_GET_IOVA_RANGE, iova_range);
> > -
> > -    return ret < 0 ? -errno : 0;
> > -}
> > -
> >  static int vhost_vdpa_get_features(int fd, uint64_t *features, Error *=
*errp)
> >  {
> >      int ret =3D ioctl(fd, VHOST_GET_FEATURES, features);
> > @@ -690,14 +698,11 @@ int net_init_vhost_vdpa(const Netdev *netdev, con=
st char *name,
> >      }
> >
> >      if (opts->x_svq) {
> > -        struct vhost_vdpa_iova_range iova_range;
> > -
> >          if (!vhost_vdpa_net_valid_svq_features(features, errp)) {
> >              goto err_svq;
> >          }
> >
> > -        vhost_vdpa_get_iova_range(vdpa_device_fd, &iova_range);
> > -        iova_tree =3D vhost_iova_tree_new(iova_range.first, iova_range=
.last);
> > +        iova_tree =3D vhost_vdpa_svq_allocate_iova_tree(vdpa_device_fd=
);
> >      }
> >
> >      ncs =3D g_malloc0(sizeof(*ncs) * queue_pairs);
> > --
> > 2.31.1
> >
>

