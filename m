Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D6A63ECE8
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 10:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbiLAJvJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 04:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiLAJvI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 04:51:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1597D2CB
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 01:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669888213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OV7cnfOFgW4HiYb63seIkcCxu9Eolfy+I3r06CYuB68=;
        b=WHSDDDQdCeQxUdLL+hhxHVHaDtA77v2aociIe43+uLiokUvgTvb5eu8ENUBgpkb2qjawRt
        HDp0M7aS6b8J/M4OTd7VzXRfFOqrkWkj9SReMUU3vty0aDiZy1ibM0Wkna77e3YqtOfRaR
        O3RY8+vYtFr5cg0U2etLhmL0gen9LHg=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-148-MFtcfZz1M0elZ-Ja1PePGw-1; Thu, 01 Dec 2022 04:50:12 -0500
X-MC-Unique: MFtcfZz1M0elZ-Ja1PePGw-1
Received: by mail-ed1-f70.google.com with SMTP id t4-20020a056402524400b004620845ba7bso588429edd.4
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 01:50:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OV7cnfOFgW4HiYb63seIkcCxu9Eolfy+I3r06CYuB68=;
        b=kDTrMgxFJU0+z+FE7jrI5t9yNef6QlK3S9twMO/dIVQuB34pK0V0F3Kp2ZfKR1/BJp
         cDBPFHU1P/6hRz3vbbdIQ3/s89DZ9YEYVPhKVPvqfIV7L+QqDXSgItJH1iX1a3OJ1Yk1
         eYv5zB91l8SSnmwyTO38Yzf5Fq909DW7Wwz0RGk7LsWbBiNvBbSYDxcj/Z0tKWLwu4HA
         V3f4NDhBSE0zPuLbCjQdAKE5FMtoSALnclw0WdN1pJaqiaNVPxhVK5ICvynEwprh/7F2
         onMtiS3hqOimChgdkVzuntjQ4xsxzmY3n4hb5JsbIskghL80h9+uijemyRllzq/LFWnm
         ejhw==
X-Gm-Message-State: ANoB5pnIVI6n7rkkgvUvcbK6k6HBfVKPip5CwGYPABjqVpU39etMHarG
        6rvofI90muRmA1Anwz7KtxrX9VfPZgZHDcY93WOnAkApG2SoK1DzNE6SvqwyrxGFOSeyVSAvEbe
        al9PJqtgy0DA/YRRBs+31GyAL0Z8v
X-Received: by 2002:a05:6402:248e:b0:461:e2ab:912d with SMTP id q14-20020a056402248e00b00461e2ab912dmr43595272eda.93.1669888210947;
        Thu, 01 Dec 2022 01:50:10 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4ROZS3y3GIsNFtexsmvUc5E9uQJkmmXEZu6ICco4tu5+mCsItfgftkN4PI2/0DjHiKJVw9DaF3gP+3EYWQpFc=
X-Received: by 2002:a05:6402:248e:b0:461:e2ab:912d with SMTP id
 q14-20020a056402248e00b00461e2ab912dmr43595253eda.93.1669888210713; Thu, 01
 Dec 2022 01:50:10 -0800 (PST)
MIME-Version: 1.0
References: <20221124155158.2109884-1-eperezma@redhat.com> <20221124155158.2109884-7-eperezma@redhat.com>
 <CACGkMEubBA9NYR5ynT_2C=iMEk3fph2GEOBvcw73BOuqiFKzJg@mail.gmail.com>
 <CAJaqyWcR_3vdXLJ4=z+_uaoVN47gEXr7KHx3w6z8HtmqquK7zA@mail.gmail.com> <CACGkMEs3xfGsptV9H+P+O1yjVzo_vugGnS72EwpE8FLECkccpQ@mail.gmail.com>
In-Reply-To: <CACGkMEs3xfGsptV9H+P+O1yjVzo_vugGnS72EwpE8FLECkccpQ@mail.gmail.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 1 Dec 2022 10:49:34 +0100
Message-ID: <CAJaqyWemta-dmaqaVphqn=riEiVrVsm5K5nSZYxBZVY6Zt8Eow@mail.gmail.com>
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

On Thu, Dec 1, 2022 at 9:45 AM Jason Wang <jasowang@redhat.com> wrote:
>
> On Wed, Nov 30, 2022 at 3:40 PM Eugenio Perez Martin
> <eperezma@redhat.com> wrote:
> >
> > On Wed, Nov 30, 2022 at 7:43 AM Jason Wang <jasowang@redhat.com> wrote:
> > >
> > > On Thu, Nov 24, 2022 at 11:52 PM Eugenio P=C3=A9rez <eperezma@redhat.=
com> wrote:
> > > >
> > > > It can be allocated either if all virtqueues must be shadowed or if
> > > > vdpa-net detects it can shadow only cvq.
> > > >
> > > > Extract in its own function so we can reuse it.
> > > >
> > > > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > > > ---
> > > >  net/vhost-vdpa.c | 29 +++++++++++++++++------------
> > > >  1 file changed, 17 insertions(+), 12 deletions(-)
> > > >
> > > > diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
> > > > index 88e0eec5fa..9ee3bc4cd3 100644
> > > > --- a/net/vhost-vdpa.c
> > > > +++ b/net/vhost-vdpa.c
> > > > @@ -240,6 +240,22 @@ static NetClientInfo net_vhost_vdpa_info =3D {
> > > >          .check_peer_type =3D vhost_vdpa_check_peer_type,
> > > >  };
> > > >
> > > > +static int vhost_vdpa_get_iova_range(int fd,
> > > > +                                     struct vhost_vdpa_iova_range =
*iova_range)
> > > > +{
> > > > +    int ret =3D ioctl(fd, VHOST_VDPA_GET_IOVA_RANGE, iova_range);
> > > > +
> > > > +    return ret < 0 ? -errno : 0;
> > > > +}
> > >
> > > I don't get why this needs to be moved to net specific code.
> > >
> >
> > It was already in net, this code just extracted it in its own function.
>
> Ok, there's similar function that in vhost-vdpa.c:
>
> static void vhost_vdpa_get_iova_range(struct vhost_vdpa *v)
> {
>     int ret =3D vhost_vdpa_call(v->dev, VHOST_VDPA_GET_IOVA_RANGE,
>                               &v->iova_range);
>     if (ret !=3D 0) {
>         v->iova_range.first =3D 0;
>         v->iova_range.last =3D UINT64_MAX;
>     }
>
>     trace_vhost_vdpa_get_iova_range(v->dev, v->iova_range.first,
>                                     v->iova_range.last);
> }
>
> I think we can reuse that.
>

That's right, but I'd do the reverse: I would store iova_min, iova_max
in VhostVDPAState and would set it to vhost_vdpa at
net_vhost_vdpa_init. That way, we only have one ioctl call at the
beginning instead of having (#vq pairs + cvq) calls each time the
device starts. I can send it in a new change if you see it ok.

There are a few functions like that we can reuse in net/. To get the
features and the backend features are two other examples. Even if we
don't cache them since device initialization mandates the read, we
could reduce code duplication that way.

However, they use vhost_dev or vhost_vdpa instead of directly the file
descriptor. Not a big deal but it's an extra step.

What do you think?

Thanks!

