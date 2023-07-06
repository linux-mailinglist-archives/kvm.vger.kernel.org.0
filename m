Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96CD07495B2
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 08:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbjGFGg6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 02:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233477AbjGFGg5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 02:36:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C367E1997
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 23:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688625371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RW6sZxQEq7r6/MAdcOAFMIZmsNq8xRUmGtzjXz5LxLU=;
        b=bGvcYiDbq54JS7aCiraINrvgKXSE6agS4mm9zn4H7napBfD3jLuu9aKSfHF16Sed9WfXxt
        N7i09fDlfGTwV99eFkxZjRCZqq+xp43A1l8RMqC/EDz1jq2o4iNGXNy47CNYeDzEkpxZ5Y
        e/DWTf+6omALlFcM2ZCSa3CJD5SWN5g=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-184-_S1ygUI8Pi2FlYUiS0RvBA-1; Thu, 06 Jul 2023 02:36:07 -0400
X-MC-Unique: _S1ygUI8Pi2FlYUiS0RvBA-1
Received: by mail-yb1-f198.google.com with SMTP id 3f1490d57ef6-c386ccab562so327024276.3
        for <kvm@vger.kernel.org>; Wed, 05 Jul 2023 23:36:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688625367; x=1691217367;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RW6sZxQEq7r6/MAdcOAFMIZmsNq8xRUmGtzjXz5LxLU=;
        b=dqEwcpPWq8Csjnp9lEtY5VLHbxlNPXjoYizsBqaWBVuvCjUgojun3Dc8AIaFoEWAGV
         XtCGXWfChVVSYlhOIAgPz0a3XUuj8Hg9WtSv3eGKKQxTMTWXFUmJkQ6i98h/FdS301GZ
         hAAqOo6Qbd+LjN8FiMwze0WveJb5kt4DNFwADCmME2P67CuLUFVpWvA/atx6NJ2zw4P6
         Iyx+CQeilCf5P8ZdQpIm12XmDYhy9OI1GfZnoo+s6mVgEh+JG+1b7sKdAWSMIIe5+G43
         KLVLQkuZAGsGhFZQw1z1+VoXxwAr/SbHhTUYLjBq2ICULkNCjXa6NCyj5ter3BK02ns/
         cqcg==
X-Gm-Message-State: ABy/qLaTFONqq0wIqgpUfr7c1jhwokv9f5LqiskJ3E2xbQy8no+AS4ZP
        164GKX2vrS9QRp8XL1DwIc2mgerfegbDIFQZd8l/E44G553zrVCtnX7nPz7vx1nKdUtmQ+bBUYg
        eAsW3Yt+ufJ+u/S5RcWLN9wVa/4wK
X-Received: by 2002:a25:abe4:0:b0:c5c:616:39cb with SMTP id v91-20020a25abe4000000b00c5c061639cbmr975940ybi.14.1688625367163;
        Wed, 05 Jul 2023 23:36:07 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFECekMAxlWyeEFXBzoSN0G8Fu9nyn23my+I7VhTksunE0lAA3zV4rTA/m36+6QaByRCoLJWb4Cqj7AXCpHZng=
X-Received: by 2002:a25:abe4:0:b0:c5c:616:39cb with SMTP id
 v91-20020a25abe4000000b00c5c061639cbmr975933ybi.14.1688625366902; Wed, 05 Jul
 2023 23:36:06 -0700 (PDT)
MIME-Version: 1.0
References: <20230703142218.362549-1-eperezma@redhat.com> <20230703105022-mutt-send-email-mst@kernel.org>
 <CAJaqyWf2F_yBLBjj1RiPeJ92_zfq8BSMz8Pak2Vg6QinN8jS1Q@mail.gmail.com>
 <20230704063646-mutt-send-email-mst@kernel.org> <CAJaqyWfdPpkD5pY4tfzQdOscLBcrDBhBqzWjMbY_ZKsoyiqGdA@mail.gmail.com>
 <20230704114159-mutt-send-email-mst@kernel.org> <CACGkMEtWjOMtsbgQ2sx=e1BkuRSyDmVfXDccCm-QSiSbacQyCA@mail.gmail.com>
 <CAJaqyWd0QC6x9WHBT0x9beZyC8ZrF2y=d9HvmT0+05RtGc8_og@mail.gmail.com>
 <eff34828-545b-956b-f400-89b585706fe4@amd.com> <20230706020603-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230706020603-mutt-send-email-mst@kernel.org>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 6 Jul 2023 08:35:30 +0200
Message-ID: <CAJaqyWeCv6HhWni=c7xySTCyj9WAFfM3JhWL2e_mDKjHp3wPzQ@mail.gmail.com>
Subject: Re: [PATCH] vdpa: reject F_ENABLE_AFTER_DRIVER_OK if backend does not
 support it
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Shannon Nelson <shannon.nelson@amd.com>,
        Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
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

On Thu, Jul 6, 2023 at 8:07=E2=80=AFAM Michael S. Tsirkin <mst@redhat.com> =
wrote:
>
> On Wed, Jul 05, 2023 at 05:07:11PM -0700, Shannon Nelson wrote:
> > On 7/5/23 11:27 AM, Eugenio Perez Martin wrote:
> > >
> > > On Wed, Jul 5, 2023 at 9:50=E2=80=AFAM Jason Wang <jasowang@redhat.co=
m> wrote:
> > > >
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
> >
> > The PDS vdpa device can deal with a call to .set_vq_ready after DRIVER_=
OK is
> > set.  And I'm told that our VQ activity should start without a kick.
> >
> > Our vdpa device FW doesn't currently have support for VIRTIO_F_RING_RES=
ET,
> > but I believe it could be added without too much trouble.
> >
> > sln
> >
>
> OK it seems clear at least in the current version pds needs
> VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK.
> However can we also code up the RING_RESET path as the default?
> Then down the road vendors can choose what to do.
>

Yes, the RING_RESET path can be coded & tested for vp_vdpa, for
example. I'm ok with making it the default, and let
_F_ENABLE_AFTER_DRIVER_OK as a fallback.

>
>
>
>
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
> > >
> > > The problem with that is that the device needs to support all
> > > RING_RESET, like to be able to change vq address etc after DRIVER_OK.
> > > Not all HW support it.
> > >
> > > We just need the subset of having the dataplane freezed until all CVQ
> > > commands have been consumed. I'm sure current vDPA code already
> > > supports it in some devices, like MLX and PSD.
> > >
> > > Thanks!
> > >
> > > > Thanks
> > > >
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
> > > > > > > > > >   drivers/vhost/vdpa.c | 7 +++++--
> > > > > > > > > >   1 file changed, 5 insertions(+), 2 deletions(-)
> > > > > > > > > >
> > > > > > > > > > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.=
c
> > > > > > > > > > index e1abf29fed5b..a7e554352351 100644
> > > > > > > > > > --- a/drivers/vhost/vdpa.c
> > > > > > > > > > +++ b/drivers/vhost/vdpa.c
> > > > > > > > > > @@ -681,18 +681,21 @@ static long vhost_vdpa_unlocked_i=
octl(struct file *filep,
> > > > > > > > > >   {
> > > > > > > > > >        struct vhost_vdpa *v =3D filep->private_data;
> > > > > > > > > >        struct vhost_dev *d =3D &v->vdev;
> > > > > > > > > > +     const struct vdpa_config_ops *ops =3D v->vdpa->co=
nfig;
> > > > > > > > > >        void __user *argp =3D (void __user *)arg;
> > > > > > > > > >        u64 __user *featurep =3D argp;
> > > > > > > > > > -     u64 features;
> > > > > > > > > > +     u64 features, parent_features =3D 0;
> > > > > > > > > >        long r =3D 0;
> > > > > > > > > >
> > > > > > > > > >        if (cmd =3D=3D VHOST_SET_BACKEND_FEATURES) {
> > > > > > > > > >                if (copy_from_user(&features, featurep, =
sizeof(features)))
> > > > > > > > > >                        return -EFAULT;
> > > > > > > > > > +             if (ops->get_backend_features)
> > > > > > > > > > +                     parent_features =3D ops->get_back=
end_features(v->vdpa);
> > > > > > > > > >                if (features & ~(VHOST_VDPA_BACKEND_FEAT=
URES |
> > > > > > > > > >                                 BIT_ULL(VHOST_BACKEND_F=
_SUSPEND) |
> > > > > > > > > >                                 BIT_ULL(VHOST_BACKEND_F=
_RESUME) |
> > > > > > > > > > -                              BIT_ULL(VHOST_BACKEND_F_=
ENABLE_AFTER_DRIVER_OK)))
> > > > > > > > > > +                              parent_features))
> > > > > > > > > >                        return -EOPNOTSUPP;
> > > > > > > > > >                if ((features & BIT_ULL(VHOST_BACKEND_F_=
SUSPEND)) &&
> > > > > > > > > >                     !vhost_vdpa_can_suspend(v))
> > > > > > > > > > --
> > > > > > > > > > 2.39.3
> > > > > > > > >
> > > > > > >
> > > > >
> > > >
> > >
>

