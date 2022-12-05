Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 144B864223E
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 05:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbiLEEZq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Dec 2022 23:25:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbiLEEZn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Dec 2022 23:25:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EAF912D19
        for <kvm@vger.kernel.org>; Sun,  4 Dec 2022 20:24:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670214288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R8n5fxGwWYcu15nmomTbV4cNBstkBFYb9k2K8ul1sbM=;
        b=duOeEt6b936P0n626cjpa659D3JlghNwJhSR/byU+0sob7dts6k9kfpdSCngysaCvYuIDy
        i3sa/2i7p3Tnd9wNL9jUhkwBZI7ufukoHUK3cFooCvYgQlHy9Wogyw/rfDZM7d9xzzCy8A
        Y+GkygyGZ0nM/Sl8KzADkFiMceiYKfI=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-232-FKwysVEpNzixdjC2vnMD6g-1; Sun, 04 Dec 2022 23:24:25 -0500
X-MC-Unique: FKwysVEpNzixdjC2vnMD6g-1
Received: by mail-ot1-f71.google.com with SMTP id t14-20020a9d7f8e000000b0066c61f96c54so6215399otp.21
        for <kvm@vger.kernel.org>; Sun, 04 Dec 2022 20:24:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R8n5fxGwWYcu15nmomTbV4cNBstkBFYb9k2K8ul1sbM=;
        b=HTGV76/De2RV54Lv1fYndimDk2pf/2w2oBEtiNYjDjUIXtAldnSNeP5rrr9Vjw6jQp
         mex0bGmEY2A+n56H2QVBujQsMJbt9yj+4NzXG/uiskiSglutCYH5SrJw+J8B+1peeAlE
         DnSc8ECwTEyhDc9fl/9gxNecDaPW3nX+lIxERkwBNTCNvjUlUPbQnSpYJnqnCsnXXUje
         6QkG/u9zSQQIUWtJG1syGUTWy6AgBwXmC4MOoOQMub5m7LyTrrSP5vRG0KhPu2IUyK62
         N242ASYo7fLOfBQlr6l0FhB04HaLmRXp6g5gVK72IljL4GcClIEGs8WYHkQj+ojT1vM+
         PGPw==
X-Gm-Message-State: ANoB5ple4paHpfC3xnIs4/hYI6PH1o80oa/8vaUuMMI31GX0J9qfLZ8k
        wsye+VyH6IAsfqhn4FjrxB8ARO9P+SYHFUKwyaZlGNJUHdZJvic8Reo7u1CMedkpW+XypFOYdk3
        7VAsgaoH7PlH8jgsMPGhAdz7VZghV
X-Received: by 2002:a9d:61ca:0:b0:66e:6d59:b2df with SMTP id h10-20020a9d61ca000000b0066e6d59b2dfmr10522445otk.201.1670214264938;
        Sun, 04 Dec 2022 20:24:24 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4RmLbd7rUQksRMHkj9ik2O62qZVkkYm6Hly+Fv/Xv8q2NeYMX08gt01mq3ZbeT9soaY3c9pKmYRi9xo7xo4Uo=
X-Received: by 2002:a9d:61ca:0:b0:66e:6d59:b2df with SMTP id
 h10-20020a9d61ca000000b0066e6d59b2dfmr10522436otk.201.1670214264729; Sun, 04
 Dec 2022 20:24:24 -0800 (PST)
MIME-Version: 1.0
References: <20221124155158.2109884-1-eperezma@redhat.com> <20221124155158.2109884-7-eperezma@redhat.com>
 <CACGkMEubBA9NYR5ynT_2C=iMEk3fph2GEOBvcw73BOuqiFKzJg@mail.gmail.com>
 <CAJaqyWcR_3vdXLJ4=z+_uaoVN47gEXr7KHx3w6z8HtmqquK7zA@mail.gmail.com>
 <CACGkMEs3xfGsptV9H+P+O1yjVzo_vugGnS72EwpE8FLECkccpQ@mail.gmail.com> <CAJaqyWemta-dmaqaVphqn=riEiVrVsm5K5nSZYxBZVY6Zt8Eow@mail.gmail.com>
In-Reply-To: <CAJaqyWemta-dmaqaVphqn=riEiVrVsm5K5nSZYxBZVY6Zt8Eow@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 5 Dec 2022 12:24:13 +0800
Message-ID: <CACGkMEs=6fv-DG_bvbMpu2xwj9s_neBcm=CqKnOArVE4_z-yHA@mail.gmail.com>
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

On Thu, Dec 1, 2022 at 5:50 PM Eugenio Perez Martin <eperezma@redhat.com> w=
rote:
>
> On Thu, Dec 1, 2022 at 9:45 AM Jason Wang <jasowang@redhat.com> wrote:
> >
> > On Wed, Nov 30, 2022 at 3:40 PM Eugenio Perez Martin
> > <eperezma@redhat.com> wrote:
> > >
> > > On Wed, Nov 30, 2022 at 7:43 AM Jason Wang <jasowang@redhat.com> wrot=
e:
> > > >
> > > > On Thu, Nov 24, 2022 at 11:52 PM Eugenio P=C3=A9rez <eperezma@redha=
t.com> wrote:
> > > > >
> > > > > It can be allocated either if all virtqueues must be shadowed or =
if
> > > > > vdpa-net detects it can shadow only cvq.
> > > > >
> > > > > Extract in its own function so we can reuse it.
> > > > >
> > > > > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > > > > ---
> > > > >  net/vhost-vdpa.c | 29 +++++++++++++++++------------
> > > > >  1 file changed, 17 insertions(+), 12 deletions(-)
> > > > >
> > > > > diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
> > > > > index 88e0eec5fa..9ee3bc4cd3 100644
> > > > > --- a/net/vhost-vdpa.c
> > > > > +++ b/net/vhost-vdpa.c
> > > > > @@ -240,6 +240,22 @@ static NetClientInfo net_vhost_vdpa_info =3D=
 {
> > > > >          .check_peer_type =3D vhost_vdpa_check_peer_type,
> > > > >  };
> > > > >
> > > > > +static int vhost_vdpa_get_iova_range(int fd,
> > > > > +                                     struct vhost_vdpa_iova_rang=
e *iova_range)
> > > > > +{
> > > > > +    int ret =3D ioctl(fd, VHOST_VDPA_GET_IOVA_RANGE, iova_range)=
;
> > > > > +
> > > > > +    return ret < 0 ? -errno : 0;
> > > > > +}
> > > >
> > > > I don't get why this needs to be moved to net specific code.
> > > >
> > >
> > > It was already in net, this code just extracted it in its own functio=
n.
> >
> > Ok, there's similar function that in vhost-vdpa.c:
> >
> > static void vhost_vdpa_get_iova_range(struct vhost_vdpa *v)
> > {
> >     int ret =3D vhost_vdpa_call(v->dev, VHOST_VDPA_GET_IOVA_RANGE,
> >                               &v->iova_range);
> >     if (ret !=3D 0) {
> >         v->iova_range.first =3D 0;
> >         v->iova_range.last =3D UINT64_MAX;
> >     }
> >
> >     trace_vhost_vdpa_get_iova_range(v->dev, v->iova_range.first,
> >                                     v->iova_range.last);
> > }
> >
> > I think we can reuse that.
> >
>
> That's right, but I'd do the reverse: I would store iova_min, iova_max
> in VhostVDPAState and would set it to vhost_vdpa at
> net_vhost_vdpa_init. That way, we only have one ioctl call at the
> beginning instead of having (#vq pairs + cvq) calls each time the
> device starts. I can send it in a new change if you see it ok.
>
> There are a few functions like that we can reuse in net/. To get the
> features and the backend features are two other examples. Even if we
> don't cache them since device initialization mandates the read, we
> could reduce code duplication that way.
>
> However, they use vhost_dev or vhost_vdpa instead of directly the file
> descriptor. Not a big deal but it's an extra step.
>
> What do you think?

I'm fine with this.

Thanks

>
> Thanks!
>

