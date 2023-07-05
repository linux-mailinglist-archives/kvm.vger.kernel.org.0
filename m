Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E287747E92
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 09:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232282AbjGEHvA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 03:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231975AbjGEHu6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 03:50:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2AE170D
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 00:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688543413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y48ulS/+kKO7p+XK2cdnd8+mcOJFtW4xSVJ9cfRLRCc=;
        b=Dk1UZScpk7GtS8sD/qYXhdbRtqkYU700Sfo24LQxvNHFgKAbJH8JlgwhxpgXC5z9PrdO4D
        yjRwOzx6BimeXp3KP4t3APfAf7I0Wl3y8P7JsZDshRH0hKiPaKUqBXspPkhJOMcI6hwNIk
        seLwmfhGxg9UUa8lUbYfdQP85UHYlE8=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-329-EgwXKOw8NqSY4kXufz-_dA-1; Wed, 05 Jul 2023 03:50:12 -0400
X-MC-Unique: EgwXKOw8NqSY4kXufz-_dA-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7656a0f8565so23940785a.1
        for <kvm@vger.kernel.org>; Wed, 05 Jul 2023 00:50:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688543412; x=1691135412;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y48ulS/+kKO7p+XK2cdnd8+mcOJFtW4xSVJ9cfRLRCc=;
        b=bscy21xPE0JWJOaKgrVCEw6Ox+rLtWf0cGbgKBK6OmbOQH8Usl2C9Op7mE721XrH2G
         7PAqNo33xj+zshfqcrQAH6Twq//GYCp4WPwEZbm180MU3zKcOBElR15tdTYslSokrbn9
         ChPPMomDisOW7JYRerGRCIsZnkdFN5ONqDOjhkgeFbJWmkfo3dG6AmzwDxFpeOpMhtOl
         wyEbz8OYc5OMcZwawihnLLvwdJfTyXliY66slweWHaAsvQW4Qzwqjm+2Wcct+s53L/mH
         D8PRPXsd9RXXXwlJm1PHuoQiACTTn0aCxD7yfGdQjqGWtuDGt70dcefkE/YeXkzLzYje
         Hxjg==
X-Gm-Message-State: ABy/qLbit4Ti88zhoWW6M1NY23ZaUWU98eVJ/L+Pb45hsYSXHUy3kWd0
        7NMaJEToyEsC5oTn5GmRhM82RP7sR3yYn6DmdVqIn3DUmbqg4j8hGTAq0xW8I/JBGhwuEVo7I65
        o8P5zQK1OIdQbn7/PoXUND78AGFJE
X-Received: by 2002:a0c:f1ca:0:b0:630:14e0:982e with SMTP id u10-20020a0cf1ca000000b0063014e0982emr1588309qvl.22.1688543412148;
        Wed, 05 Jul 2023 00:50:12 -0700 (PDT)
X-Google-Smtp-Source: APBJJlECWIUnOY9XKAF+JGyO1WxxEdgi7O/d6naJ/xGAnoeQMVdDnnQISxcvMK2kW8kDBCOg+K1qYyW7lCoiy4kASbU=
X-Received: by 2002:a0c:f1ca:0:b0:630:14e0:982e with SMTP id
 u10-20020a0cf1ca000000b0063014e0982emr1588302qvl.22.1688543411888; Wed, 05
 Jul 2023 00:50:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230703142218.362549-1-eperezma@redhat.com> <20230703105022-mutt-send-email-mst@kernel.org>
 <CAJaqyWf2F_yBLBjj1RiPeJ92_zfq8BSMz8Pak2Vg6QinN8jS1Q@mail.gmail.com>
 <20230704063646-mutt-send-email-mst@kernel.org> <CAJaqyWfdPpkD5pY4tfzQdOscLBcrDBhBqzWjMbY_ZKsoyiqGdA@mail.gmail.com>
 <20230704114159-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230704114159-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 5 Jul 2023 15:49:58 +0800
Message-ID: <CACGkMEtWjOMtsbgQ2sx=e1BkuRSyDmVfXDccCm-QSiSbacQyCA@mail.gmail.com>
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
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 4, 2023 at 11:45=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Tue, Jul 04, 2023 at 01:36:11PM +0200, Eugenio Perez Martin wrote:
> > On Tue, Jul 4, 2023 at 12:38=E2=80=AFPM Michael S. Tsirkin <mst@redhat.=
com> wrote:
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
> > >
> >
> > Previous versions of the QEMU LM series did a spurious kick to start
> > traffic at the LM destination [1]. When it was proposed, that spurious
> > kick was removed from the series because to check for descriptors
> > after driver_ok, even without a kick, was considered work of the
> > parent driver.
> >
> > I'm ok to go back to this spurious kick, but I'm not sure if the hw
> > will read the ring before the kick actually. I can ask.
> >
> > Thanks!
> >
> > [1] https://lists.nongnu.org/archive/html/qemu-devel/2023-01/msg02775.h=
tml
>
> Let's find out. We need to check for ENABLE_AFTER_DRIVER_OK too, no?

My understanding is [1] assuming ACCESS_AFTER_KICK. This seems
sub-optimal than assuming ENABLE_AFTER_DRIVER_OK.

But this reminds me one thing, as the thread is going too long, I
wonder if we simply assume ENABLE_AFTER_DRIVER_OK if RING_RESET is
supported?

Thanks

>
>
>
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

