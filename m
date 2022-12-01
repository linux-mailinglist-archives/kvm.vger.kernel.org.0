Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2C063EB84
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 09:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiLAIsA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 03:48:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiLAIr2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 03:47:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC8461A07E
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 00:45:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669884319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W30ub+31ugHFrai3M+pIk2IMe4pwCCCPHsxniWlqoNA=;
        b=HeAlwpV7++11vs9eWOZQ1I5lWkCo7wGN1W0SOU2yMnGgbGLptQWUYLwP1n0YY3EtaQtrsR
        Emo8VEvrC48IUkGVc4wcK/5blzJcg0FHWRTDotMrJl+GoAboBd6bL8Wq1I3u6SWg65bi5E
        VfZr3kw0MaGNs0DU5zNWmttP5/nqaDY=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-594-crNGBmYSOpePyhH3fa7LJg-1; Thu, 01 Dec 2022 03:45:18 -0500
X-MC-Unique: crNGBmYSOpePyhH3fa7LJg-1
Received: by mail-oi1-f199.google.com with SMTP id p133-20020acaf18b000000b0035b236c8554so780706oih.15
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 00:45:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W30ub+31ugHFrai3M+pIk2IMe4pwCCCPHsxniWlqoNA=;
        b=7puovtHu9jDzeT8+XjHCwXCutb/xjrRsYErxmfS0jWC6nYUHBol8EMz82Gw21nOYYE
         yRhxVINLBFHuH1GQPIPRv/PBDzqPmrEnTh3PDo0EKrLB82vZn0kDEYKVoDpV19SplSvF
         JvoiNwRUCpUArLIfmgoFyZp4So6oLCdaIE7/3weegtyWVDz2YvxgQwiW2MB0VlIOwMy7
         dX4RLjjJF24HOT5Z0KnbDoyaFJCukjf9Le70y/YtaEE5oiplLcdoq2PG7ZCVjWp+7t8/
         ruy5DGYpk9UC4WZhxAlQ1z4lBeNznQeJQit9WEk0zKH40K1a3mbi0QmBrnd42cZiJZOu
         jdVQ==
X-Gm-Message-State: ANoB5pl9zoo+Ym0PnQsXb7WpnNYOI/RGvooHDj5vuKhStgqT8crLKvWg
        L0edyqLaMtPP9+93EdHDwsiVHSVLN7SzKQunlZ46F7jFY4L5L5fRD3Orv+RZVbQ0/Ui+GsoBirR
        bNFK7niGeK2V82eD1LqXLyr+fNMGy
X-Received: by 2002:a9d:61ca:0:b0:66e:6d59:b2df with SMTP id h10-20020a9d61ca000000b0066e6d59b2dfmr2780190otk.201.1669884317495;
        Thu, 01 Dec 2022 00:45:17 -0800 (PST)
X-Google-Smtp-Source: AA0mqf72xmd65QOUsfdxu+pwjZ4+Fr/69ptUR/h6mPkJMTebq5U3v8/IId5vnkEpyOCm6nZ0bdiixncWk1CeQpooN1c=
X-Received: by 2002:a9d:61ca:0:b0:66e:6d59:b2df with SMTP id
 h10-20020a9d61ca000000b0066e6d59b2dfmr2780180otk.201.1669884317289; Thu, 01
 Dec 2022 00:45:17 -0800 (PST)
MIME-Version: 1.0
References: <20221124155158.2109884-1-eperezma@redhat.com> <20221124155158.2109884-7-eperezma@redhat.com>
 <CACGkMEubBA9NYR5ynT_2C=iMEk3fph2GEOBvcw73BOuqiFKzJg@mail.gmail.com> <CAJaqyWcR_3vdXLJ4=z+_uaoVN47gEXr7KHx3w6z8HtmqquK7zA@mail.gmail.com>
In-Reply-To: <CAJaqyWcR_3vdXLJ4=z+_uaoVN47gEXr7KHx3w6z8HtmqquK7zA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 1 Dec 2022 16:45:06 +0800
Message-ID: <CACGkMEs3xfGsptV9H+P+O1yjVzo_vugGnS72EwpE8FLECkccpQ@mail.gmail.com>
Subject: Re: [PATCH for 8.0 v8 06/12] vdpa: extract vhost_vdpa_svq_allocate_iova_tree
To:     Eugenio Perez Martin <eperezma@redhat.com>
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

On Wed, Nov 30, 2022 at 3:40 PM Eugenio Perez Martin
<eperezma@redhat.com> wrote:
>
> On Wed, Nov 30, 2022 at 7:43 AM Jason Wang <jasowang@redhat.com> wrote:
> >
> > On Thu, Nov 24, 2022 at 11:52 PM Eugenio P=C3=A9rez <eperezma@redhat.co=
m> wrote:
> > >
> > > It can be allocated either if all virtqueues must be shadowed or if
> > > vdpa-net detects it can shadow only cvq.
> > >
> > > Extract in its own function so we can reuse it.
> > >
> > > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > > ---
> > >  net/vhost-vdpa.c | 29 +++++++++++++++++------------
> > >  1 file changed, 17 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
> > > index 88e0eec5fa..9ee3bc4cd3 100644
> > > --- a/net/vhost-vdpa.c
> > > +++ b/net/vhost-vdpa.c
> > > @@ -240,6 +240,22 @@ static NetClientInfo net_vhost_vdpa_info =3D {
> > >          .check_peer_type =3D vhost_vdpa_check_peer_type,
> > >  };
> > >
> > > +static int vhost_vdpa_get_iova_range(int fd,
> > > +                                     struct vhost_vdpa_iova_range *i=
ova_range)
> > > +{
> > > +    int ret =3D ioctl(fd, VHOST_VDPA_GET_IOVA_RANGE, iova_range);
> > > +
> > > +    return ret < 0 ? -errno : 0;
> > > +}
> >
> > I don't get why this needs to be moved to net specific code.
> >
>
> It was already in net, this code just extracted it in its own function.

Ok, there's similar function that in vhost-vdpa.c:

static void vhost_vdpa_get_iova_range(struct vhost_vdpa *v)
{
    int ret =3D vhost_vdpa_call(v->dev, VHOST_VDPA_GET_IOVA_RANGE,
                              &v->iova_range);
    if (ret !=3D 0) {
        v->iova_range.first =3D 0;
        v->iova_range.last =3D UINT64_MAX;
    }

    trace_vhost_vdpa_get_iova_range(v->dev, v->iova_range.first,
                                    v->iova_range.last);
}

I think we can reuse that.

Thanks

>
> It's done in net because iova_tree must be the same for all queuepair
> vhost, so we need to allocate before them.
>
> Thanks!
>
> > Thanks
> >
> > > +
> > > +static VhostIOVATree *vhost_vdpa_svq_allocate_iova_tree(int vdpa_dev=
ice_fd)
> > > +{
> > > +    struct vhost_vdpa_iova_range iova_range;
> > > +
> > > +    vhost_vdpa_get_iova_range(vdpa_device_fd, &iova_range);
> > > +    return vhost_iova_tree_new(iova_range.first, iova_range.last);
> > > +}
> > > +
> > >  static void vhost_vdpa_cvq_unmap_buf(struct vhost_vdpa *v, void *add=
r)
> > >  {
> > >      VhostIOVATree *tree =3D v->iova_tree;
> > > @@ -587,14 +603,6 @@ static NetClientState *net_vhost_vdpa_init(NetCl=
ientState *peer,
> > >      return nc;
> > >  }
> > >
> > > -static int vhost_vdpa_get_iova_range(int fd,
> > > -                                     struct vhost_vdpa_iova_range *i=
ova_range)
> > > -{
> > > -    int ret =3D ioctl(fd, VHOST_VDPA_GET_IOVA_RANGE, iova_range);
> > > -
> > > -    return ret < 0 ? -errno : 0;
> > > -}
> > > -
> > >  static int vhost_vdpa_get_features(int fd, uint64_t *features, Error=
 **errp)
> > >  {
> > >      int ret =3D ioctl(fd, VHOST_GET_FEATURES, features);
> > > @@ -690,14 +698,11 @@ int net_init_vhost_vdpa(const Netdev *netdev, c=
onst char *name,
> > >      }
> > >
> > >      if (opts->x_svq) {
> > > -        struct vhost_vdpa_iova_range iova_range;
> > > -
> > >          if (!vhost_vdpa_net_valid_svq_features(features, errp)) {
> > >              goto err_svq;
> > >          }
> > >
> > > -        vhost_vdpa_get_iova_range(vdpa_device_fd, &iova_range);
> > > -        iova_tree =3D vhost_iova_tree_new(iova_range.first, iova_ran=
ge.last);
> > > +        iova_tree =3D vhost_vdpa_svq_allocate_iova_tree(vdpa_device_=
fd);
> > >      }
> > >
> > >      ncs =3D g_malloc0(sizeof(*ncs) * queue_pairs);
> > > --
> > > 2.31.1
> > >
> >
>

