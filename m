Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEEC74AC5F
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 09:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbjGGH6e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 03:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232698AbjGGH6b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 03:58:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 189261FE6
        for <kvm@vger.kernel.org>; Fri,  7 Jul 2023 00:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688716664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mEpZPyCmaGemnrfXXAJXbPLd9RqjcNfujXNkxU7uJgg=;
        b=Gl5TkiM/+Izmg0AgCUKtnpYWhIH8EEChGGzpzK+z9JdOdJ58SkehoTn/2kM5/fL84tn1WM
        VXjMIYJ7AioWWWwXxRnF5XE1e2Ws70jbaA6grwL6prbKB+vYJ/MLTz7RgJp/2lEddC+cj0
        pQ3nrekrqiHI4yS3E3nfeKEK28md5oA=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-jVd8cSPLOSu4ar-OU1RLsA-1; Fri, 07 Jul 2023 03:57:42 -0400
X-MC-Unique: jVd8cSPLOSu4ar-OU1RLsA-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2b70c44b5fdso6095621fa.1
        for <kvm@vger.kernel.org>; Fri, 07 Jul 2023 00:57:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688716660; x=1691308660;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mEpZPyCmaGemnrfXXAJXbPLd9RqjcNfujXNkxU7uJgg=;
        b=fqoSN6eEOEhhLq0e7hkL71K8GtNUHxt+kFg9t69Vkq9AAGM70NKuNS74d5NdiP+ZoN
         mZMzDC9FHr/fGHGwI7PoQvTui10cObLDfI294PgcYm5WFLUQQ90qD8Nr8mX0cIQEu6dM
         XQfcdr5rT5WJGpFzHAJ0ojnuVzbcJxookm5mMYzBKu+o21uh+xea9pk2PxE00Lr1GdGV
         Fetj0mXaubIRHD4OXQ+uWfx/5o/Q3CpwjqiMjXBjNNbIckJDcBd0KXrDK25f3anlqya/
         yHPVE4lgDeGYaiH8+L0gS2i3/I6WglKKa8hzwXSA2AGrLS7xJHgnyZ0xFM6tt5ZgpvBa
         q1+Q==
X-Gm-Message-State: ABy/qLbkMW79d7fv6zwlnrDay5cGMcB2Pkj3nL9w5CoErjAhqKfPqguM
        amKrIEYOibFTo1/dwOHhHgWTHkb0Q7DTHjlfbjx3ELWjiH7wtd895BqU1pNNPwfe/mR3LOfEoDb
        sPWlAwwGTRP4Vd3W5Lf5Okw8BX+9t
X-Received: by 2002:a2e:b44f:0:b0:2b6:f1ad:d535 with SMTP id o15-20020a2eb44f000000b002b6f1add535mr2897781ljm.14.1688716660601;
        Fri, 07 Jul 2023 00:57:40 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGG1fs3IIGzeB+qQfUMI3hhjxPEwbtguF4w2sYwc43PKBLjt1WFHJckiuIlLy+s/ff9+yqeexlrDuimTasM8Xc=
X-Received: by 2002:a2e:b44f:0:b0:2b6:f1ad:d535 with SMTP id
 o15-20020a2eb44f000000b002b6f1add535mr2897771ljm.14.1688716660214; Fri, 07
 Jul 2023 00:57:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230703142218.362549-1-eperezma@redhat.com> <20230703105022-mutt-send-email-mst@kernel.org>
 <CAJaqyWf2F_yBLBjj1RiPeJ92_zfq8BSMz8Pak2Vg6QinN8jS1Q@mail.gmail.com>
 <20230704063646-mutt-send-email-mst@kernel.org> <CAJaqyWfdPpkD5pY4tfzQdOscLBcrDBhBqzWjMbY_ZKsoyiqGdA@mail.gmail.com>
 <20230704114159-mutt-send-email-mst@kernel.org> <CACGkMEtWjOMtsbgQ2sx=e1BkuRSyDmVfXDccCm-QSiSbacQyCA@mail.gmail.com>
 <20230705043940-mutt-send-email-mst@kernel.org> <CACGkMEufNZGvWMN9Shh6NPOZOe-vf0RomfS1DX6DtxJjvO7fNA@mail.gmail.com>
 <CAJaqyWcqNkzJXxsoz_Lk_X0CvNW24Ay2Ki6q02EB8iR=qpwsfg@mail.gmail.com>
 <CACGkMEvDsZcyTDBhS8ekXHyv-kiipyHizewpM2+=0XgSYMsmbw@mail.gmail.com>
 <CACGkMEuKNXCSWWqDTZQpogHqT1K=rsQMFAYxL6OC8OL=XeU3-g@mail.gmail.com> <CAJaqyWdv_DFdxghHQPoUE4KZ7pqmaR__=JyHFONRuard3KBtSQ@mail.gmail.com>
In-Reply-To: <CAJaqyWdv_DFdxghHQPoUE4KZ7pqmaR__=JyHFONRuard3KBtSQ@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 7 Jul 2023 15:57:28 +0800
Message-ID: <CACGkMEsv3vyupAbmiq=MtQozq_7O=JKok9sB-Ka9A2PdEgNLag@mail.gmail.com>
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
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 6, 2023 at 5:39=E2=80=AFPM Eugenio Perez Martin <eperezma@redha=
t.com> wrote:
>
> On Thu, Jul 6, 2023 at 10:03=E2=80=AFAM Jason Wang <jasowang@redhat.com> =
wrote:
> >
> > On Thu, Jul 6, 2023 at 3:55=E2=80=AFPM Jason Wang <jasowang@redhat.com>=
 wrote:
> > >
> > > On Thu, Jul 6, 2023 at 3:06=E2=80=AFPM Eugenio Perez Martin <eperezma=
@redhat.com> wrote:
> > > >
> > > > On Thu, Jul 6, 2023 at 3:55=E2=80=AFAM Jason Wang <jasowang@redhat.=
com> wrote:
> > > > >
> > > > > On Wed, Jul 5, 2023 at 4:41=E2=80=AFPM Michael S. Tsirkin <mst@re=
dhat.com> wrote:
> > > > > >
> > > > > > On Wed, Jul 05, 2023 at 03:49:58PM +0800, Jason Wang wrote:
> > > > > > > On Tue, Jul 4, 2023 at 11:45=E2=80=AFPM Michael S. Tsirkin <m=
st@redhat.com> wrote:
> > > > > > > >
> > > > > > > > On Tue, Jul 04, 2023 at 01:36:11PM +0200, Eugenio Perez Mar=
tin wrote:
> > > > > > > > > On Tue, Jul 4, 2023 at 12:38=E2=80=AFPM Michael S. Tsirki=
n <mst@redhat.com> wrote:
> > > > > > > > > >
> > > > > > > > > > On Tue, Jul 04, 2023 at 12:25:32PM +0200, Eugenio Perez=
 Martin wrote:
> > > > > > > > > > > On Mon, Jul 3, 2023 at 4:52=E2=80=AFPM Michael S. Tsi=
rkin <mst@redhat.com> wrote:
> > > > > > > > > > > >
> > > > > > > > > > > > On Mon, Jul 03, 2023 at 04:22:18PM +0200, Eugenio P=
=C3=A9rez wrote:
> > > > > > > > > > > > > With the current code it is accepted as long as u=
serland send it.
> > > > > > > > > > > > >
> > > > > > > > > > > > > Although userland should not set a feature flag t=
hat has not been
> > > > > > > > > > > > > offered to it with VHOST_GET_BACKEND_FEATURES, th=
e current code will not
> > > > > > > > > > > > > complain for it.
> > > > > > > > > > > > >
> > > > > > > > > > > > > Since there is no specific reason for any parent =
to reject that backend
> > > > > > > > > > > > > feature bit when it has been proposed, let's cont=
rol it at vdpa frontend
> > > > > > > > > > > > > level. Future patches may move this control to th=
e parent driver.
> > > > > > > > > > > > >
> > > > > > > > > > > > > Fixes: 967800d2d52e ("vdpa: accept VHOST_BACKEND_=
F_ENABLE_AFTER_DRIVER_OK backend feature")
> > > > > > > > > > > > > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redha=
t.com>
> > > > > > > > > > > >
> > > > > > > > > > > > Please do send v3. And again, I don't want to send =
"after driver ok" hack
> > > > > > > > > > > > upstream at all, I merged it in next just to give i=
t some testing.
> > > > > > > > > > > > We want RING_ACCESS_AFTER_KICK or some such.
> > > > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > Current devices do not support that semantic.
> > > > > > > > > >
> > > > > > > > > > Which devices specifically access the ring after DRIVER=
_OK but before
> > > > > > > > > > a kick?
> > > > > > > > > >
> > > > > > > > >
> > > > > > > > > Previous versions of the QEMU LM series did a spurious ki=
ck to start
> > > > > > > > > traffic at the LM destination [1]. When it was proposed, =
that spurious
> > > > > > > > > kick was removed from the series because to check for des=
criptors
> > > > > > > > > after driver_ok, even without a kick, was considered work=
 of the
> > > > > > > > > parent driver.
> > > > > > > > >
> > > > > > > > > I'm ok to go back to this spurious kick, but I'm not sure=
 if the hw
> > > > > > > > > will read the ring before the kick actually. I can ask.
> > > > > > > > >
> > > > > > > > > Thanks!
> > > > > > > > >
> > > > > > > > > [1] https://lists.nongnu.org/archive/html/qemu-devel/2023=
-01/msg02775.html
> > > > > > > >
> > > > > > > > Let's find out. We need to check for ENABLE_AFTER_DRIVER_OK=
 too, no?
> > > > > > >
> > > > > > > My understanding is [1] assuming ACCESS_AFTER_KICK. This seem=
s
> > > > > > > sub-optimal than assuming ENABLE_AFTER_DRIVER_OK.
> > > > > > >
> > > > > > > But this reminds me one thing, as the thread is going too lon=
g, I
> > > > > > > wonder if we simply assume ENABLE_AFTER_DRIVER_OK if RING_RES=
ET is
> > > > > > > supported?
> > > > > > >
> > > > > > > Thanks
> > > > > >
> > > > > > I don't see what does one have to do with another ...
> > > > > >
> > > > > > I think with RING_RESET we had another solution, enable rings
> > > > > > mapping them to a zero page, then reset and re-enable later.
> > > > >
> > > > > As discussed before, this seems to have some problems:
> > > > >
> > > > > 1) The behaviour is not clarified in the document
> > > > > 2) zero is a valid IOVA
> > > > >
> > > >
> > > > I think we're not on the same page here.
> > > >
> > > > As I understood, rings mapped to a zero page means essentially an
> > > > avail ring whose avail_idx is always 0, offered to the device inste=
ad
> > > > of the guest's ring. Once all CVQ commands are processed, we use
> > > > RING_RESET to switch to the right ring, being guest's or SVQ vring.
> > >
> > > I get this. This seems more complicated in the destination: shadow vq=
 + ASID?
> >
> > So it's something like:
> >
> > 1) set all vq ASID to shadow virtqueue
> > 2) do not add any bufs to data qp (stick 0 as avail index)
> > 3) start to restore states via cvq
> > 4) ring_rest for dataqp
> > 5) set_vq_state for dataqp
> > 6) re-initialize dataqp address etc
> > 7) set data QP ASID to guest
> > 8) set queue_enable
> >
> > ?
> >
>
> I think the change of ASID is not needed, as the guest cannot access
> the device in that timeframe anyway.

Yes but after the restore, we still want to shadow cvq, so ASID is still ne=
eded?

Thanks

> Moreover, it may require HW
> support. So steps 1 and 7 are not needed.
>
> Apart from that, the process is right.
>
>
> > Thanks
> >
> > >
> > > Thanks
> > >
> > > >
> > > >
> > > >
> > > > > Thanks
> > > > >
> > > > > >
> > > > > > > >
> > > > > > > >
> > > > > > > >
> > > > > > > > > > > My plan was to convert
> > > > > > > > > > > it in vp_vdpa if needed, and reuse the current vdpa o=
ps. Sorry if I
> > > > > > > > > > > was not explicit enough.
> > > > > > > > > > >
> > > > > > > > > > > The only solution I can see to that is to trap & emul=
ate in the vdpa
> > > > > > > > > > > (parent?) driver, as talked in virtio-comment. But th=
at complicates
> > > > > > > > > > > the architecture:
> > > > > > > > > > > * Offer VHOST_BACKEND_F_RING_ACCESS_AFTER_KICK
> > > > > > > > > > > * Store vq enable state separately, at
> > > > > > > > > > > vdpa->config->set_vq_ready(true), but not transmit th=
at enable to hw
> > > > > > > > > > > * Store the doorbell state separately, but do not con=
figure it to the
> > > > > > > > > > > device directly.
> > > > > > > > > > >
> > > > > > > > > > > But how to recover if the device cannot configure the=
m at kick time,
> > > > > > > > > > > for example?
> > > > > > > > > > >
> > > > > > > > > > > Maybe we can just fail if the parent driver does not =
support enabling
> > > > > > > > > > > the vq after DRIVER_OK? That way no new feature flag =
is needed.
> > > > > > > > > > >
> > > > > > > > > > > Thanks!
> > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > > > ---
> > > > > > > > > > > > > Sent with Fixes: tag pointing to git.kernel.org/p=
ub/scm/linux/kernel/git/mst
> > > > > > > > > > > > > commit. Please let me know if I should send a v3 =
of [1] instead.
> > > > > > > > > > > > >
> > > > > > > > > > > > > [1] https://lore.kernel.org/lkml/20230609121244-m=
utt-send-email-mst@kernel.org/T/
> > > > > > > > > > > > > ---
> > > > > > > > > > > > >  drivers/vhost/vdpa.c | 7 +++++--
> > > > > > > > > > > > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > > > > > > > > > > > >
> > > > > > > > > > > > > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost=
/vdpa.c
> > > > > > > > > > > > > index e1abf29fed5b..a7e554352351 100644
> > > > > > > > > > > > > --- a/drivers/vhost/vdpa.c
> > > > > > > > > > > > > +++ b/drivers/vhost/vdpa.c
> > > > > > > > > > > > > @@ -681,18 +681,21 @@ static long vhost_vdpa_unlo=
cked_ioctl(struct file *filep,
> > > > > > > > > > > > >  {
> > > > > > > > > > > > >       struct vhost_vdpa *v =3D filep->private_dat=
a;
> > > > > > > > > > > > >       struct vhost_dev *d =3D &v->vdev;
> > > > > > > > > > > > > +     const struct vdpa_config_ops *ops =3D v->vd=
pa->config;
> > > > > > > > > > > > >       void __user *argp =3D (void __user *)arg;
> > > > > > > > > > > > >       u64 __user *featurep =3D argp;
> > > > > > > > > > > > > -     u64 features;
> > > > > > > > > > > > > +     u64 features, parent_features =3D 0;
> > > > > > > > > > > > >       long r =3D 0;
> > > > > > > > > > > > >
> > > > > > > > > > > > >       if (cmd =3D=3D VHOST_SET_BACKEND_FEATURES) =
{
> > > > > > > > > > > > >               if (copy_from_user(&features, featu=
rep, sizeof(features)))
> > > > > > > > > > > > >                       return -EFAULT;
> > > > > > > > > > > > > +             if (ops->get_backend_features)
> > > > > > > > > > > > > +                     parent_features =3D ops->ge=
t_backend_features(v->vdpa);
> > > > > > > > > > > > >               if (features & ~(VHOST_VDPA_BACKEND=
_FEATURES |
> > > > > > > > > > > > >                                BIT_ULL(VHOST_BACK=
END_F_SUSPEND) |
> > > > > > > > > > > > >                                BIT_ULL(VHOST_BACK=
END_F_RESUME) |
> > > > > > > > > > > > > -                              BIT_ULL(VHOST_BACK=
END_F_ENABLE_AFTER_DRIVER_OK)))
> > > > > > > > > > > > > +                              parent_features))
> > > > > > > > > > > > >                       return -EOPNOTSUPP;
> > > > > > > > > > > > >               if ((features & BIT_ULL(VHOST_BACKE=
ND_F_SUSPEND)) &&
> > > > > > > > > > > > >                    !vhost_vdpa_can_suspend(v))
> > > > > > > > > > > > > --
> > > > > > > > > > > > > 2.39.3
> > > > > > > > > > > >
> > > > > > > > > >
> > > > > > > >
> > > > > >
> > > > >
> > > >
> >
>

