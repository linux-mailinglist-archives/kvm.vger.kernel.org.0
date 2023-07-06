Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B4974935A
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 03:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbjGFB5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 21:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbjGFB5f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 21:57:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EBD61BDC
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 18:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688608603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EqDroqLviQEGeLkIXDsNROSinaXH/bWW7KlW3DhF9v0=;
        b=Jt2ps6exjoscpINfPClm4hVSFWi3hhUL6RzqHYdVsNulxEqOM6dJSorWEYs1tioCWAhowt
        8bxRClVxV/3hbKtX/2t250Dz6FddXjQjt/h7rKNHj47QphWZyhpqQhrFZAa5O+RljJEjzq
        Do1ypVIWR5p2UqRKJD/f7bwLQcNFSCA=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-21-JXTF0DdoPsGA9A4b6YwykA-1; Wed, 05 Jul 2023 21:56:42 -0400
X-MC-Unique: JXTF0DdoPsGA9A4b6YwykA-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2b707829eb9so2492341fa.3
        for <kvm@vger.kernel.org>; Wed, 05 Jul 2023 18:56:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688608601; x=1691200601;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EqDroqLviQEGeLkIXDsNROSinaXH/bWW7KlW3DhF9v0=;
        b=Toj2lDYdzyjwLTt09aUE2iyU2FDhoRaxZKDQQ1WXibWvQz9RR4CmIIqM86sW9iD2jM
         AZO9/dqaa8Sjwq2e7XOg9fNabM07vUlAgkY7PRJ+4qp7jWeZVXXhn8LeuqfNhpOCzU63
         M28kCYi7rWWo+MGZ9nuGpSwbqShiNET/4U9Nn7P9SCVkBT84X3MRxi+7/4S5zkzmFP7N
         huDeDH/Zta3BseVDnHrDdVLs92rF/H8BsTtE9+Bz3TA0oQw42GkM++IZpCjwuPfBV14Z
         I/Ofm/Ek+E9cZBzZm/1ARGzJh3P9hwbojo6hu8NwOu/5FKt0HJVvKEDnB2QM78QF7/Tt
         iklA==
X-Gm-Message-State: ABy/qLbI0P3Uxzh5BpB26WpGYjW3KDPLfsgIIV5Ey9fyNJliM1jCafeP
        wNhDjCSl0LbyfxaMg7Zz390MfYKAiN0pbK0jvQoULkVGYE20+VP4vhzkXGAskh986MZRWE3nHtf
        lFuiK1gjJhCFn0zKqP2yKtw9tOb06
X-Received: by 2002:a2e:9c82:0:b0:2b6:e9b9:4039 with SMTP id x2-20020a2e9c82000000b002b6e9b94039mr392894lji.35.1688608601006;
        Wed, 05 Jul 2023 18:56:41 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFKS2J0e7/UUx6A/PgS2Q4XzdnwRaHcbBSWnEqCy1k8PV6J3XtVhrGjzxXzvKhr5fpzP/pbECRCNoLCbPpI01g=
X-Received: by 2002:a2e:9c82:0:b0:2b6:e9b9:4039 with SMTP id
 x2-20020a2e9c82000000b002b6e9b94039mr392881lji.35.1688608600690; Wed, 05 Jul
 2023 18:56:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230703142218.362549-1-eperezma@redhat.com> <20230703105022-mutt-send-email-mst@kernel.org>
 <CAJaqyWf2F_yBLBjj1RiPeJ92_zfq8BSMz8Pak2Vg6QinN8jS1Q@mail.gmail.com>
 <20230704063646-mutt-send-email-mst@kernel.org> <CACGkMEvT4Y+-wfhyi324Y5hhAtn+ZF7cP9d=omdH-ZgdJ-4SOQ@mail.gmail.com>
 <20230705044151-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230705044151-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 6 Jul 2023 09:56:29 +0800
Message-ID: <CACGkMEu0MhQqNbrg9WkyGBboFU5RSqCs1W8LpksW4mO7hGxd7g@mail.gmail.com>
Subject: Re: [PATCH] vdpa: reject F_ENABLE_AFTER_DRIVER_OK if backend does not
 support it
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Eugenio Perez Martin <eperezma@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Shannon Nelson <shannon.nelson@amd.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 5, 2023 at 4:42=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com> =
wrote:
>
> On Wed, Jul 05, 2023 at 03:55:23PM +0800, Jason Wang wrote:
> > On Tue, Jul 4, 2023 at 6:38=E2=80=AFPM Michael S. Tsirkin <mst@redhat.c=
om> wrote:
> > >
> > > On Tue, Jul 04, 2023 at 12:25:32PM +0200, Eugenio Perez Martin wrote:
> > > > On Mon, Jul 3, 2023 at 4:52=E2=80=AFPM Michael S. Tsirkin <mst@redh=
at.com> wrote:
> > > > >
> > > > > On Mon, Jul 03, 2023 at 04:22:18PM +0200, Eugenio P=C3=A9rez wrot=
e:
> > > > > > With the current code it is accepted as long as userland send i=
t.
> > > > > >
> > > > > > Although userland should not set a feature flag that has not be=
en
> > > > > > offered to it with VHOST_GET_BACKEND_FEATURES, the current code=
 will not
> > > > > > complain for it.
> > > > > >
> > > > > > Since there is no specific reason for any parent to reject that=
 backend
> > > > > > feature bit when it has been proposed, let's control it at vdpa=
 frontend
> > > > > > level. Future patches may move this control to the parent drive=
r.
> > > > > >
> > > > > > Fixes: 967800d2d52e ("vdpa: accept VHOST_BACKEND_F_ENABLE_AFTER=
_DRIVER_OK backend feature")
> > > > > > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > > > >
> > > > > Please do send v3. And again, I don't want to send "after driver =
ok" hack
> > > > > upstream at all, I merged it in next just to give it some testing=
.
> > > > > We want RING_ACCESS_AFTER_KICK or some such.
> > > > >
> > > >
> > > > Current devices do not support that semantic.
> > >
> > > Which devices specifically access the ring after DRIVER_OK but before
> > > a kick?
> >
> > Vhost-net is one example at last. It polls a socket as well, so it
> > starts to access the ring immediately after DRIVER_OK.
> >
> > Thanks
>
>
> For sure but that is not vdpa.

Somehow via vp_vdpa that I'm usually testing vDPA patches.

The problem is that it's very hard to audit all vDPA devices now if it
is not defined in the spec before they are invented.

Thanks

>
> > >
> > > > My plan was to convert
> > > > it in vp_vdpa if needed, and reuse the current vdpa ops. Sorry if I
> > > > was not explicit enough.
> > > >
> > > > The only solution I can see to that is to trap & emulate in the vdp=
a
> > > > (parent?) driver, as talked in virtio-comment. But that complicates
> > > > the architecture:
> > > > * Offer VHOST_BACKEND_F_RING_ACCESS_AFTER_KICK
> > > > * Store vq enable state separately, at
> > > > vdpa->config->set_vq_ready(true), but not transmit that enable to h=
w
> > > > * Store the doorbell state separately, but do not configure it to t=
he
> > > > device directly.
> > > >
> > > > But how to recover if the device cannot configure them at kick time=
,
> > > > for example?
> > > >
> > > > Maybe we can just fail if the parent driver does not support enabli=
ng
> > > > the vq after DRIVER_OK? That way no new feature flag is needed.
> > > >
> > > > Thanks!
> > > >
> > > > >
> > > > > > ---
> > > > > > Sent with Fixes: tag pointing to git.kernel.org/pub/scm/linux/k=
ernel/git/mst
> > > > > > commit. Please let me know if I should send a v3 of [1] instead=
.
> > > > > >
> > > > > > [1] https://lore.kernel.org/lkml/20230609121244-mutt-send-email=
-mst@kernel.org/T/
> > > > > > ---
> > > > > >  drivers/vhost/vdpa.c | 7 +++++--
> > > > > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > > > > >
> > > > > > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > > > > > index e1abf29fed5b..a7e554352351 100644
> > > > > > --- a/drivers/vhost/vdpa.c
> > > > > > +++ b/drivers/vhost/vdpa.c
> > > > > > @@ -681,18 +681,21 @@ static long vhost_vdpa_unlocked_ioctl(str=
uct file *filep,
> > > > > >  {
> > > > > >       struct vhost_vdpa *v =3D filep->private_data;
> > > > > >       struct vhost_dev *d =3D &v->vdev;
> > > > > > +     const struct vdpa_config_ops *ops =3D v->vdpa->config;
> > > > > >       void __user *argp =3D (void __user *)arg;
> > > > > >       u64 __user *featurep =3D argp;
> > > > > > -     u64 features;
> > > > > > +     u64 features, parent_features =3D 0;
> > > > > >       long r =3D 0;
> > > > > >
> > > > > >       if (cmd =3D=3D VHOST_SET_BACKEND_FEATURES) {
> > > > > >               if (copy_from_user(&features, featurep, sizeof(fe=
atures)))
> > > > > >                       return -EFAULT;
> > > > > > +             if (ops->get_backend_features)
> > > > > > +                     parent_features =3D ops->get_backend_feat=
ures(v->vdpa);
> > > > > >               if (features & ~(VHOST_VDPA_BACKEND_FEATURES |
> > > > > >                                BIT_ULL(VHOST_BACKEND_F_SUSPEND)=
 |
> > > > > >                                BIT_ULL(VHOST_BACKEND_F_RESUME) =
|
> > > > > > -                              BIT_ULL(VHOST_BACKEND_F_ENABLE_A=
FTER_DRIVER_OK)))
> > > > > > +                              parent_features))
> > > > > >                       return -EOPNOTSUPP;
> > > > > >               if ((features & BIT_ULL(VHOST_BACKEND_F_SUSPEND))=
 &&
> > > > > >                    !vhost_vdpa_can_suspend(v))
> > > > > > --
> > > > > > 2.39.3
> > > > >
> > >
>

