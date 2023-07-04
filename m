Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F366974700F
	for <lists+kvm@lfdr.de>; Tue,  4 Jul 2023 13:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbjGDLhh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 07:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbjGDLhg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 07:37:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E398C113
        for <kvm@vger.kernel.org>; Tue,  4 Jul 2023 04:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688470610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KtFnjmuWq7lD4JMUFOEU267nnBV7z7Sf7mPzW1iJGx4=;
        b=SLQC6G2PsRf6x+ZIeQVCxKQ6O/cAVefzXIAYA9AByiSNO4KS8PTtqfMtHpOu1g+ZB4OONL
        7J5NyrZl4SvNP8TLGAfNz4LGu+PcSOh24XRvWYNeS7zf7GcnP91HVwjtOOrnNKaxgRFUdO
        b07lAemrr3yAZMvcKL7EmapJuMq6dJ4=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-512-VDtWC6k_OnSWlpCWCwKeRA-1; Tue, 04 Jul 2023 07:36:49 -0400
X-MC-Unique: VDtWC6k_OnSWlpCWCwKeRA-1
Received: by mail-yb1-f198.google.com with SMTP id 3f1490d57ef6-bacfa4ef059so5413867276.2
        for <kvm@vger.kernel.org>; Tue, 04 Jul 2023 04:36:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688470608; x=1691062608;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KtFnjmuWq7lD4JMUFOEU267nnBV7z7Sf7mPzW1iJGx4=;
        b=AMH9SwnQfLAMUrZsqZYvkPJO3vr7s6BmXYO2UAEuyPV3w9ZgWaHaiXOeA1p18u/gHF
         ElkChA1Rekf3/s68WW+ev4lCfcqtRfXX1txHtN+zkLUkmPAo+OrheGz3wEKhTkz/rYW9
         Vpi56uKv5MIjbZX1K3iZ60p3WC7BvKPZucMw2zBkG9B3ddRg1Ys+zob61NUUFmYDnX1t
         UIL3mEDmoy6IwTAba0gkxSZXK4Xa88MHR6Xys1U8NVxnvp+btKIVz7ELwblw9+/jkno9
         RzzRW1BO9dbfN1Kdi2MZzTzxhi091BdqeztDBB0tpDOE7/2A93tYgFAq5ia5IXxdUUXt
         +PdA==
X-Gm-Message-State: ABy/qLZ6PIYb3rgKLlkmjIWQevOdbC3f7w9xbeGLAHE9vkrSXPCvSAq2
        Vrp0RkRlsID0/Z9NQLRHuFgJZQoLer+RoamUBUAAuCWlbncrm6GK9RuJJVtrD5CrNA15SsDsc4T
        jLCzKbGxT40vwvNlGBx278h/ltHF8
X-Received: by 2002:a25:f905:0:b0:c1d:5719:7c74 with SMTP id q5-20020a25f905000000b00c1d57197c74mr9848266ybe.31.1688470608469;
        Tue, 04 Jul 2023 04:36:48 -0700 (PDT)
X-Google-Smtp-Source: APBJJlE0GeHI0oE5VWaeeOE5i2+pOcmY7sHETJ8vNEmvfk1t1ZjTnn4TiKn1zHACyvstI2CA/uy7oIOga14/UUYRRDU=
X-Received: by 2002:a25:f905:0:b0:c1d:5719:7c74 with SMTP id
 q5-20020a25f905000000b00c1d57197c74mr9848260ybe.31.1688470608126; Tue, 04 Jul
 2023 04:36:48 -0700 (PDT)
MIME-Version: 1.0
References: <20230703142218.362549-1-eperezma@redhat.com> <20230703105022-mutt-send-email-mst@kernel.org>
 <CAJaqyWf2F_yBLBjj1RiPeJ92_zfq8BSMz8Pak2Vg6QinN8jS1Q@mail.gmail.com> <20230704063646-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230704063646-mutt-send-email-mst@kernel.org>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Tue, 4 Jul 2023 13:36:11 +0200
Message-ID: <CAJaqyWfdPpkD5pY4tfzQdOscLBcrDBhBqzWjMbY_ZKsoyiqGdA@mail.gmail.com>
Subject: Re: [PATCH] vdpa: reject F_ENABLE_AFTER_DRIVER_OK if backend does not
 support it
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
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

On Tue, Jul 4, 2023 at 12:38=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Tue, Jul 04, 2023 at 12:25:32PM +0200, Eugenio Perez Martin wrote:
> > On Mon, Jul 3, 2023 at 4:52=E2=80=AFPM Michael S. Tsirkin <mst@redhat.c=
om> wrote:
> > >
> > > On Mon, Jul 03, 2023 at 04:22:18PM +0200, Eugenio P=C3=A9rez wrote:
> > > > With the current code it is accepted as long as userland send it.
> > > >
> > > > Although userland should not set a feature flag that has not been
> > > > offered to it with VHOST_GET_BACKEND_FEATURES, the current code wil=
l not
> > > > complain for it.
> > > >
> > > > Since there is no specific reason for any parent to reject that bac=
kend
> > > > feature bit when it has been proposed, let's control it at vdpa fro=
ntend
> > > > level. Future patches may move this control to the parent driver.
> > > >
> > > > Fixes: 967800d2d52e ("vdpa: accept VHOST_BACKEND_F_ENABLE_AFTER_DRI=
VER_OK backend feature")
> > > > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > >
> > > Please do send v3. And again, I don't want to send "after driver ok" =
hack
> > > upstream at all, I merged it in next just to give it some testing.
> > > We want RING_ACCESS_AFTER_KICK or some such.
> > >
> >
> > Current devices do not support that semantic.
>
> Which devices specifically access the ring after DRIVER_OK but before
> a kick?
>

Previous versions of the QEMU LM series did a spurious kick to start
traffic at the LM destination [1]. When it was proposed, that spurious
kick was removed from the series because to check for descriptors
after driver_ok, even without a kick, was considered work of the
parent driver.

I'm ok to go back to this spurious kick, but I'm not sure if the hw
will read the ring before the kick actually. I can ask.

Thanks!

[1] https://lists.nongnu.org/archive/html/qemu-devel/2023-01/msg02775.html

> > My plan was to convert
> > it in vp_vdpa if needed, and reuse the current vdpa ops. Sorry if I
> > was not explicit enough.
> >
> > The only solution I can see to that is to trap & emulate in the vdpa
> > (parent?) driver, as talked in virtio-comment. But that complicates
> > the architecture:
> > * Offer VHOST_BACKEND_F_RING_ACCESS_AFTER_KICK
> > * Store vq enable state separately, at
> > vdpa->config->set_vq_ready(true), but not transmit that enable to hw
> > * Store the doorbell state separately, but do not configure it to the
> > device directly.
> >
> > But how to recover if the device cannot configure them at kick time,
> > for example?
> >
> > Maybe we can just fail if the parent driver does not support enabling
> > the vq after DRIVER_OK? That way no new feature flag is needed.
> >
> > Thanks!
> >
> > >
> > > > ---
> > > > Sent with Fixes: tag pointing to git.kernel.org/pub/scm/linux/kerne=
l/git/mst
> > > > commit. Please let me know if I should send a v3 of [1] instead.
> > > >
> > > > [1] https://lore.kernel.org/lkml/20230609121244-mutt-send-email-mst=
@kernel.org/T/
> > > > ---
> > > >  drivers/vhost/vdpa.c | 7 +++++--
> > > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > > > index e1abf29fed5b..a7e554352351 100644
> > > > --- a/drivers/vhost/vdpa.c
> > > > +++ b/drivers/vhost/vdpa.c
> > > > @@ -681,18 +681,21 @@ static long vhost_vdpa_unlocked_ioctl(struct =
file *filep,
> > > >  {
> > > >       struct vhost_vdpa *v =3D filep->private_data;
> > > >       struct vhost_dev *d =3D &v->vdev;
> > > > +     const struct vdpa_config_ops *ops =3D v->vdpa->config;
> > > >       void __user *argp =3D (void __user *)arg;
> > > >       u64 __user *featurep =3D argp;
> > > > -     u64 features;
> > > > +     u64 features, parent_features =3D 0;
> > > >       long r =3D 0;
> > > >
> > > >       if (cmd =3D=3D VHOST_SET_BACKEND_FEATURES) {
> > > >               if (copy_from_user(&features, featurep, sizeof(featur=
es)))
> > > >                       return -EFAULT;
> > > > +             if (ops->get_backend_features)
> > > > +                     parent_features =3D ops->get_backend_features=
(v->vdpa);
> > > >               if (features & ~(VHOST_VDPA_BACKEND_FEATURES |
> > > >                                BIT_ULL(VHOST_BACKEND_F_SUSPEND) |
> > > >                                BIT_ULL(VHOST_BACKEND_F_RESUME) |
> > > > -                              BIT_ULL(VHOST_BACKEND_F_ENABLE_AFTER=
_DRIVER_OK)))
> > > > +                              parent_features))
> > > >                       return -EOPNOTSUPP;
> > > >               if ((features & BIT_ULL(VHOST_BACKEND_F_SUSPEND)) &&
> > > >                    !vhost_vdpa_can_suspend(v))
> > > > --
> > > > 2.39.3
> > >
>

