Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF76747EAF
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 09:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbjGEH4b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 03:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjGEH4a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 03:56:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4978D10F7
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 00:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688543737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JchDhPT3KR3iSA029I0+obQ1cLL2Ob33e0q6YR+m51M=;
        b=KVFtlfKyzJ8BK1tFY9Qr16Ohv1eJmgceI8JOMgPXYpM2mTwE27y2wiHFizeonqCy7EtpK1
        x475V/nW/k+cEya98XMeVdiL2I4l0Cg7KH0Y4GghMdlrgCmxlfP3bPVBzuZ2hGIsfbK6u5
        4RQeMXRN1LRNI2wJdjWSU7ob/PEr1do=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-33-DwfHBPTxOe281bqVDQaLRQ-1; Wed, 05 Jul 2023 03:55:36 -0400
X-MC-Unique: DwfHBPTxOe281bqVDQaLRQ-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-635e6c83cf0so64711786d6.3
        for <kvm@vger.kernel.org>; Wed, 05 Jul 2023 00:55:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688543736; x=1691135736;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JchDhPT3KR3iSA029I0+obQ1cLL2Ob33e0q6YR+m51M=;
        b=WgimPYO08mwPbhpmLBlWIotC+U/uUaQLfS8INB5xmxeXLRoa1QvoSsc4dS8v6Gry1z
         WNYe3K6RH7o94LYyBnr1wJGTOhfleTB6+Qt4W+qxvi8Cxb9mwqg+/q3K/lKVABWkIH4C
         nOPPwHxqhfpOnzKbvMYyaP31FlI/Vh/uy6vidNajxWUnvwiCjwpOnukAYfTJkMbw10eZ
         4FgjsqH5dT89OxNLj+h6gyWL8CyVY2HgYbrigs7hezHOqHxvsUgz6PoerYyz9XEFPg/B
         keO5+5VhH7rDvSBD4cTZ2sVKmLR6w+5brDeqi11zIg2lkRa7BRwEVj1aBSpeVkV1KYBt
         Rueg==
X-Gm-Message-State: ABy/qLZ/K51Z/rnkys3AL1AB3I6YYhQrIMRKFTIaORdUjhQpXVgBUHoH
        3AkC7w5gbpRVpg/7n0dceMcsISMKWB+oQhJUHOYup/vY0LKaRYgQqNlXT4UR7VkXxAJFINbUV9I
        sGJUwbe6NTxL1qXhfikZKSX5xojCa
X-Received: by 2002:a0c:e9c7:0:b0:632:301e:62fc with SMTP id q7-20020a0ce9c7000000b00632301e62fcmr14553358qvo.35.1688543736083;
        Wed, 05 Jul 2023 00:55:36 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFqduiWcmunoNBMAdWzr6PpWjNwv7fXWO8C6/ME3RHNm2xO9+3sdoOnnjp1VMMQRCem4bpXAtZUe/vemaJ32+g=
X-Received: by 2002:a0c:e9c7:0:b0:632:301e:62fc with SMTP id
 q7-20020a0ce9c7000000b00632301e62fcmr14553352qvo.35.1688543735859; Wed, 05
 Jul 2023 00:55:35 -0700 (PDT)
MIME-Version: 1.0
References: <20230703142218.362549-1-eperezma@redhat.com> <20230703105022-mutt-send-email-mst@kernel.org>
 <CAJaqyWf2F_yBLBjj1RiPeJ92_zfq8BSMz8Pak2Vg6QinN8jS1Q@mail.gmail.com> <20230704063646-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230704063646-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 5 Jul 2023 15:55:23 +0800
Message-ID: <CACGkMEvT4Y+-wfhyi324Y5hhAtn+ZF7cP9d=omdH-ZgdJ-4SOQ@mail.gmail.com>
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

On Tue, Jul 4, 2023 at 6:38=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com> =
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

Vhost-net is one example at last. It polls a socket as well, so it
starts to access the ring immediately after DRIVER_OK.

Thanks

>
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

