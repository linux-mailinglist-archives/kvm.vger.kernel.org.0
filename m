Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBEDC7496DD
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 09:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbjGFH4u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 03:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbjGFH4t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 03:56:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4221A3
        for <kvm@vger.kernel.org>; Thu,  6 Jul 2023 00:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688630166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hySNpHyRfM9pyhg8/6aj+xHmN6E1rSwH8K6gl3I4pyE=;
        b=iBKhiAv2/EmLW4MU5uUlu0aZ1PPMYcHHX9ZNPt/Hy+cq5JJco+JiBBXnv10f0uk1NMT99m
        /+2FUqYYPN9mNTVlLUn8l9hA0fzgsoEDFmkCk/UnRY53lPh6ZADRHi+P3mRdtfsRQHWxl8
        7U6A1dzYMD+EJB0XzRsL29k3luTTqC0=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-354-iOLHbg8ZP7-XtzN36PbPhw-1; Thu, 06 Jul 2023 03:56:05 -0400
X-MC-Unique: iOLHbg8ZP7-XtzN36PbPhw-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2b6fdb7eeafso3729161fa.2
        for <kvm@vger.kernel.org>; Thu, 06 Jul 2023 00:56:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688630164; x=1691222164;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hySNpHyRfM9pyhg8/6aj+xHmN6E1rSwH8K6gl3I4pyE=;
        b=A7sW18cfkbewXsSvdQVrRrf71MVNMmoBFBM9Ya7QNvj7VD50UfWEce9+5n5cIym3P/
         mI3vd2c5T9+ROY8ScNjTFi01C7S9jmaq789ZlDRLEokTE66+QOLEfEhPBL/fzuCgNacH
         lSWCgYJ81QpteK4FLsOaPhWqvK5GvJlS7pvt9Gyh7xFSjK4p5mfkkiphAzAWZI8ptALW
         GOhgSjoxj+uahchf6tDHQReuJUv4lOgPspIzn+m2cV5eotgEZPLK+8Q80PyVlAMqYmpl
         bPiytYUmMVGhyKPq0SlU6HlLJyKuV6tjBQbDm98hDpC9rbZ74XdDoBXGO3DBYyK2+Q5h
         cTsw==
X-Gm-Message-State: ABy/qLbemR9k8z8L/HqfCGLwtCpp13tztFeETbuBT27T6GM503JFPkur
        YJl/h09820UYr7WpXCRukgBtJu5I6YIGcEyBuG7zKFcoUc8P6j7/9A4mwbNA2Sf34othvfgY35w
        JBHQUqIF7QSSVyuh/Rm9nrdBlbCN8
X-Received: by 2002:a2e:a3d2:0:b0:2b6:e7d6:714d with SMTP id w18-20020a2ea3d2000000b002b6e7d6714dmr785215lje.22.1688630163900;
        Thu, 06 Jul 2023 00:56:03 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEGqpBXE59HBwjbO7My8NVcvPAFY35DXSBKLlPiZZo3282vdH1Mirq6QjNHCyspslFcO8XqSvO+AtuZfIQIpDY=
X-Received: by 2002:a2e:a3d2:0:b0:2b6:e7d6:714d with SMTP id
 w18-20020a2ea3d2000000b002b6e7d6714dmr785203lje.22.1688630163562; Thu, 06 Jul
 2023 00:56:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230703142218.362549-1-eperezma@redhat.com> <20230703105022-mutt-send-email-mst@kernel.org>
 <CAJaqyWf2F_yBLBjj1RiPeJ92_zfq8BSMz8Pak2Vg6QinN8jS1Q@mail.gmail.com>
 <20230704063646-mutt-send-email-mst@kernel.org> <CAJaqyWfdPpkD5pY4tfzQdOscLBcrDBhBqzWjMbY_ZKsoyiqGdA@mail.gmail.com>
 <20230704114159-mutt-send-email-mst@kernel.org> <CACGkMEtWjOMtsbgQ2sx=e1BkuRSyDmVfXDccCm-QSiSbacQyCA@mail.gmail.com>
 <20230705043940-mutt-send-email-mst@kernel.org> <CACGkMEufNZGvWMN9Shh6NPOZOe-vf0RomfS1DX6DtxJjvO7fNA@mail.gmail.com>
 <CAJaqyWcqNkzJXxsoz_Lk_X0CvNW24Ay2Ki6q02EB8iR=qpwsfg@mail.gmail.com>
In-Reply-To: <CAJaqyWcqNkzJXxsoz_Lk_X0CvNW24Ay2Ki6q02EB8iR=qpwsfg@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 6 Jul 2023 15:55:51 +0800
Message-ID: <CACGkMEvDsZcyTDBhS8ekXHyv-kiipyHizewpM2+=0XgSYMsmbw@mail.gmail.com>
Subject: Re: [PATCH] vdpa: reject F_ENABLE_AFTER_DRIVER_OK if backend does not
 support it
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Shannon Nelson <shannon.nelson@amd.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 6, 2023 at 3:06=E2=80=AFPM Eugenio Perez Martin <eperezma@redha=
t.com> wrote:
>
> On Thu, Jul 6, 2023 at 3:55=E2=80=AFAM Jason Wang <jasowang@redhat.com> w=
rote:
> >
> > On Wed, Jul 5, 2023 at 4:41=E2=80=AFPM Michael S. Tsirkin <mst@redhat.c=
om> wrote:
> > >
> > > On Wed, Jul 05, 2023 at 03:49:58PM +0800, Jason Wang wrote:
> > > > On Tue, Jul 4, 2023 at 11:45=E2=80=AFPM Michael S. Tsirkin <mst@red=
hat.com> wrote:
> > > > >
> > > > > On Tue, Jul 04, 2023 at 01:36:11PM +0200, Eugenio Perez Martin wr=
ote:
> > > > > > On Tue, Jul 4, 2023 at 12:38=E2=80=AFPM Michael S. Tsirkin <mst=
@redhat.com> wrote:
> > > > > > >
> > > > > > > On Tue, Jul 04, 2023 at 12:25:32PM +0200, Eugenio Perez Marti=
n wrote:
> > > > > > > > On Mon, Jul 3, 2023 at 4:52=E2=80=AFPM Michael S. Tsirkin <=
mst@redhat.com> wrote:
> > > > > > > > >
> > > > > > > > > On Mon, Jul 03, 2023 at 04:22:18PM +0200, Eugenio P=C3=A9=
rez wrote:
> > > > > > > > > > With the current code it is accepted as long as userlan=
d send it.
> > > > > > > > > >
> > > > > > > > > > Although userland should not set a feature flag that ha=
s not been
> > > > > > > > > > offered to it with VHOST_GET_BACKEND_FEATURES, the curr=
ent code will not
> > > > > > > > > > complain for it.
> > > > > > > > > >
> > > > > > > > > > Since there is no specific reason for any parent to rej=
ect that backend
> > > > > > > > > > feature bit when it has been proposed, let's control it=
 at vdpa frontend
> > > > > > > > > > level. Future patches may move this control to the pare=
nt driver.
> > > > > > > > > >
> > > > > > > > > > Fixes: 967800d2d52e ("vdpa: accept VHOST_BACKEND_F_ENAB=
LE_AFTER_DRIVER_OK backend feature")
> > > > > > > > > > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > > > > > > > >
> > > > > > > > > Please do send v3. And again, I don't want to send "after=
 driver ok" hack
> > > > > > > > > upstream at all, I merged it in next just to give it some=
 testing.
> > > > > > > > > We want RING_ACCESS_AFTER_KICK or some such.
> > > > > > > > >
> > > > > > > >
> > > > > > > > Current devices do not support that semantic.
> > > > > > >
> > > > > > > Which devices specifically access the ring after DRIVER_OK bu=
t before
> > > > > > > a kick?
> > > > > > >
> > > > > >
> > > > > > Previous versions of the QEMU LM series did a spurious kick to =
start
> > > > > > traffic at the LM destination [1]. When it was proposed, that s=
purious
> > > > > > kick was removed from the series because to check for descripto=
rs
> > > > > > after driver_ok, even without a kick, was considered work of th=
e
> > > > > > parent driver.
> > > > > >
> > > > > > I'm ok to go back to this spurious kick, but I'm not sure if th=
e hw
> > > > > > will read the ring before the kick actually. I can ask.
> > > > > >
> > > > > > Thanks!
> > > > > >
> > > > > > [1] https://lists.nongnu.org/archive/html/qemu-devel/2023-01/ms=
g02775.html
> > > > >
> > > > > Let's find out. We need to check for ENABLE_AFTER_DRIVER_OK too, =
no?
> > > >
> > > > My understanding is [1] assuming ACCESS_AFTER_KICK. This seems
> > > > sub-optimal than assuming ENABLE_AFTER_DRIVER_OK.
> > > >
> > > > But this reminds me one thing, as the thread is going too long, I
> > > > wonder if we simply assume ENABLE_AFTER_DRIVER_OK if RING_RESET is
> > > > supported?
> > > >
> > > > Thanks
> > >
> > > I don't see what does one have to do with another ...
> > >
> > > I think with RING_RESET we had another solution, enable rings
> > > mapping them to a zero page, then reset and re-enable later.
> >
> > As discussed before, this seems to have some problems:
> >
> > 1) The behaviour is not clarified in the document
> > 2) zero is a valid IOVA
> >
>
> I think we're not on the same page here.
>
> As I understood, rings mapped to a zero page means essentially an
> avail ring whose avail_idx is always 0, offered to the device instead
> of the guest's ring. Once all CVQ commands are processed, we use
> RING_RESET to switch to the right ring, being guest's or SVQ vring.

I get this. This seems more complicated in the destination: shadow vq + ASI=
D?

Thanks

>
>
>
> > Thanks
> >
> > >
> > > > >
> > > > >
> > > > >
> > > > > > > > My plan was to convert
> > > > > > > > it in vp_vdpa if needed, and reuse the current vdpa ops. So=
rry if I
> > > > > > > > was not explicit enough.
> > > > > > > >
> > > > > > > > The only solution I can see to that is to trap & emulate in=
 the vdpa
> > > > > > > > (parent?) driver, as talked in virtio-comment. But that com=
plicates
> > > > > > > > the architecture:
> > > > > > > > * Offer VHOST_BACKEND_F_RING_ACCESS_AFTER_KICK
> > > > > > > > * Store vq enable state separately, at
> > > > > > > > vdpa->config->set_vq_ready(true), but not transmit that ena=
ble to hw
> > > > > > > > * Store the doorbell state separately, but do not configure=
 it to the
> > > > > > > > device directly.
> > > > > > > >
> > > > > > > > But how to recover if the device cannot configure them at k=
ick time,
> > > > > > > > for example?
> > > > > > > >
> > > > > > > > Maybe we can just fail if the parent driver does not suppor=
t enabling
> > > > > > > > the vq after DRIVER_OK? That way no new feature flag is nee=
ded.
> > > > > > > >
> > > > > > > > Thanks!
> > > > > > > >
> > > > > > > > >
> > > > > > > > > > ---
> > > > > > > > > > Sent with Fixes: tag pointing to git.kernel.org/pub/scm=
/linux/kernel/git/mst
> > > > > > > > > > commit. Please let me know if I should send a v3 of [1]=
 instead.
> > > > > > > > > >
> > > > > > > > > > [1] https://lore.kernel.org/lkml/20230609121244-mutt-se=
nd-email-mst@kernel.org/T/
> > > > > > > > > > ---
> > > > > > > > > >  drivers/vhost/vdpa.c | 7 +++++--
> > > > > > > > > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > > > > > > > > >
> > > > > > > > > > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.=
c
> > > > > > > > > > index e1abf29fed5b..a7e554352351 100644
> > > > > > > > > > --- a/drivers/vhost/vdpa.c
> > > > > > > > > > +++ b/drivers/vhost/vdpa.c
> > > > > > > > > > @@ -681,18 +681,21 @@ static long vhost_vdpa_unlocked_i=
octl(struct file *filep,
> > > > > > > > > >  {
> > > > > > > > > >       struct vhost_vdpa *v =3D filep->private_data;
> > > > > > > > > >       struct vhost_dev *d =3D &v->vdev;
> > > > > > > > > > +     const struct vdpa_config_ops *ops =3D v->vdpa->co=
nfig;
> > > > > > > > > >       void __user *argp =3D (void __user *)arg;
> > > > > > > > > >       u64 __user *featurep =3D argp;
> > > > > > > > > > -     u64 features;
> > > > > > > > > > +     u64 features, parent_features =3D 0;
> > > > > > > > > >       long r =3D 0;
> > > > > > > > > >
> > > > > > > > > >       if (cmd =3D=3D VHOST_SET_BACKEND_FEATURES) {
> > > > > > > > > >               if (copy_from_user(&features, featurep, s=
izeof(features)))
> > > > > > > > > >                       return -EFAULT;
> > > > > > > > > > +             if (ops->get_backend_features)
> > > > > > > > > > +                     parent_features =3D ops->get_back=
end_features(v->vdpa);
> > > > > > > > > >               if (features & ~(VHOST_VDPA_BACKEND_FEATU=
RES |
> > > > > > > > > >                                BIT_ULL(VHOST_BACKEND_F_=
SUSPEND) |
> > > > > > > > > >                                BIT_ULL(VHOST_BACKEND_F_=
RESUME) |
> > > > > > > > > > -                              BIT_ULL(VHOST_BACKEND_F_=
ENABLE_AFTER_DRIVER_OK)))
> > > > > > > > > > +                              parent_features))
> > > > > > > > > >                       return -EOPNOTSUPP;
> > > > > > > > > >               if ((features & BIT_ULL(VHOST_BACKEND_F_S=
USPEND)) &&
> > > > > > > > > >                    !vhost_vdpa_can_suspend(v))
> > > > > > > > > > --
> > > > > > > > > > 2.39.3
> > > > > > > > >
> > > > > > >
> > > > >
> > >
> >
>

