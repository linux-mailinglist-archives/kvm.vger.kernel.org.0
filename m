Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32A717498AB
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 11:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbjGFJkE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 05:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbjGFJkB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 05:40:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14514B4
        for <kvm@vger.kernel.org>; Thu,  6 Jul 2023 02:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688636353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j4dnnxZ1wSmFozKRBQ7ttfuc4yJgvWqhe2F7b5ZZXtc=;
        b=GuzFCH/VIzhpPOTyzq1KeOWf/Cdx+m/BBgNogDLToYxOZjahRT8qTTVA/y9/rEmLjjlqix
        iaBTGCdPtsUUB5OpJCf6jvIAbR7y90o/XCuXxlxNMFIEbuAo9Npy+0BAd5fdcFBU0yVP2m
        u6i69TKzP96If6aV6ux2durk6Jrq1+k=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-255-1AVQ4OUqPhiuKF__aOeW9w-1; Thu, 06 Jul 2023 05:39:12 -0400
X-MC-Unique: 1AVQ4OUqPhiuKF__aOeW9w-1
Received: by mail-yb1-f197.google.com with SMTP id 3f1490d57ef6-c5e3d2c339aso486288276.3
        for <kvm@vger.kernel.org>; Thu, 06 Jul 2023 02:39:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688636351; x=1691228351;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j4dnnxZ1wSmFozKRBQ7ttfuc4yJgvWqhe2F7b5ZZXtc=;
        b=NpdJ+ZaI5/Rn35oVDcbenV8OVVt67+e6vHTtE0g4CGm6l14uJ/8qd8yTMaBXwwzJJM
         DMUyzqswSKAJoDSzfjg3oFL+v05shNLUklqcYCGEOb2EAmraXbEILnceRXHURdnjXN5U
         SNTA2ORR4DQDE9UwFrGVtth+jGuQGpMt3XLnvvR5SSzq1hrl8kYvE466JnqdGxAvczNk
         wSHiYf9ITwc34oC1umbTzQHK2PpUkMJkTjvdw48Lk9y9ZeU8nLU2OSYjif7NTBz+QOVv
         WjLOnqzVqdI5mMz6suJnRPRi4fEqSkoC4QGHYuxLhLRrVbJCtLy7ZsO8tPx38Vqqlbow
         +rUQ==
X-Gm-Message-State: ABy/qLYpHQSghle75XU75jlBzBJvJSeIhEtAzsN9EmfhRvW9o/S51SD5
        APRGTO0PS+aIWhqqRvInLhoteYKeV+dEd/NURNQ2mhr5iVm2D119pDJeHmJdf/vAygbjXfNlbjT
        T06+xsFslsVxPOcegkLNuDboHKmFk
X-Received: by 2002:a25:188a:0:b0:c12:29ac:1d36 with SMTP id 132-20020a25188a000000b00c1229ac1d36mr1239711yby.7.1688636351760;
        Thu, 06 Jul 2023 02:39:11 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFLmSB+47+YgPFGZvl3utGSzBgIYnM3OoeQdVfI97xUZpVcffiQ8VZrTdjYJj0NYJSVjYHab0HWtwwnXx6rFx0=
X-Received: by 2002:a25:188a:0:b0:c12:29ac:1d36 with SMTP id
 132-20020a25188a000000b00c1229ac1d36mr1239701yby.7.1688636351465; Thu, 06 Jul
 2023 02:39:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230703142218.362549-1-eperezma@redhat.com> <20230703105022-mutt-send-email-mst@kernel.org>
 <CAJaqyWf2F_yBLBjj1RiPeJ92_zfq8BSMz8Pak2Vg6QinN8jS1Q@mail.gmail.com>
 <20230704063646-mutt-send-email-mst@kernel.org> <CAJaqyWfdPpkD5pY4tfzQdOscLBcrDBhBqzWjMbY_ZKsoyiqGdA@mail.gmail.com>
 <20230704114159-mutt-send-email-mst@kernel.org> <CACGkMEtWjOMtsbgQ2sx=e1BkuRSyDmVfXDccCm-QSiSbacQyCA@mail.gmail.com>
 <20230705043940-mutt-send-email-mst@kernel.org> <CACGkMEufNZGvWMN9Shh6NPOZOe-vf0RomfS1DX6DtxJjvO7fNA@mail.gmail.com>
 <CAJaqyWcqNkzJXxsoz_Lk_X0CvNW24Ay2Ki6q02EB8iR=qpwsfg@mail.gmail.com>
 <CACGkMEvDsZcyTDBhS8ekXHyv-kiipyHizewpM2+=0XgSYMsmbw@mail.gmail.com> <CACGkMEuKNXCSWWqDTZQpogHqT1K=rsQMFAYxL6OC8OL=XeU3-g@mail.gmail.com>
In-Reply-To: <CACGkMEuKNXCSWWqDTZQpogHqT1K=rsQMFAYxL6OC8OL=XeU3-g@mail.gmail.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 6 Jul 2023 11:38:35 +0200
Message-ID: <CAJaqyWdv_DFdxghHQPoUE4KZ7pqmaR__=JyHFONRuard3KBtSQ@mail.gmail.com>
Subject: Re: [PATCH] vdpa: reject F_ENABLE_AFTER_DRIVER_OK if backend does not
 support it
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
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

On Thu, Jul 6, 2023 at 10:03=E2=80=AFAM Jason Wang <jasowang@redhat.com> wr=
ote:
>
> On Thu, Jul 6, 2023 at 3:55=E2=80=AFPM Jason Wang <jasowang@redhat.com> w=
rote:
> >
> > On Thu, Jul 6, 2023 at 3:06=E2=80=AFPM Eugenio Perez Martin <eperezma@r=
edhat.com> wrote:
> > >
> > > On Thu, Jul 6, 2023 at 3:55=E2=80=AFAM Jason Wang <jasowang@redhat.co=
m> wrote:
> > > >
> > > > On Wed, Jul 5, 2023 at 4:41=E2=80=AFPM Michael S. Tsirkin <mst@redh=
at.com> wrote:
> > > > >
> > > > > On Wed, Jul 05, 2023 at 03:49:58PM +0800, Jason Wang wrote:
> > > > > > On Tue, Jul 4, 2023 at 11:45=E2=80=AFPM Michael S. Tsirkin <mst=
@redhat.com> wrote:
> > > > > > >
> > > > > > > On Tue, Jul 04, 2023 at 01:36:11PM +0200, Eugenio Perez Marti=
n wrote:
> > > > > > > > On Tue, Jul 4, 2023 at 12:38=E2=80=AFPM Michael S. Tsirkin =
<mst@redhat.com> wrote:
> > > > > > > > >
> > > > > > > > > On Tue, Jul 04, 2023 at 12:25:32PM +0200, Eugenio Perez M=
artin wrote:
> > > > > > > > > > On Mon, Jul 3, 2023 at 4:52=E2=80=AFPM Michael S. Tsirk=
in <mst@redhat.com> wrote:
> > > > > > > > > > >
> > > > > > > > > > > On Mon, Jul 03, 2023 at 04:22:18PM +0200, Eugenio P=
=C3=A9rez wrote:
> > > > > > > > > > > > With the current code it is accepted as long as use=
rland send it.
> > > > > > > > > > > >
> > > > > > > > > > > > Although userland should not set a feature flag tha=
t has not been
> > > > > > > > > > > > offered to it with VHOST_GET_BACKEND_FEATURES, the =
current code will not
> > > > > > > > > > > > complain for it.
> > > > > > > > > > > >
> > > > > > > > > > > > Since there is no specific reason for any parent to=
 reject that backend
> > > > > > > > > > > > feature bit when it has been proposed, let's contro=
l it at vdpa frontend
> > > > > > > > > > > > level. Future patches may move this control to the =
parent driver.
> > > > > > > > > > > >
> > > > > > > > > > > > Fixes: 967800d2d52e ("vdpa: accept VHOST_BACKEND_F_=
ENABLE_AFTER_DRIVER_OK backend feature")
> > > > > > > > > > > > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.=
com>
> > > > > > > > > > >
> > > > > > > > > > > Please do send v3. And again, I don't want to send "a=
fter driver ok" hack
> > > > > > > > > > > upstream at all, I merged it in next just to give it =
some testing.
> > > > > > > > > > > We want RING_ACCESS_AFTER_KICK or some such.
> > > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > Current devices do not support that semantic.
> > > > > > > > >
> > > > > > > > > Which devices specifically access the ring after DRIVER_O=
K but before
> > > > > > > > > a kick?
> > > > > > > > >
> > > > > > > >
> > > > > > > > Previous versions of the QEMU LM series did a spurious kick=
 to start
> > > > > > > > traffic at the LM destination [1]. When it was proposed, th=
at spurious
> > > > > > > > kick was removed from the series because to check for descr=
iptors
> > > > > > > > after driver_ok, even without a kick, was considered work o=
f the
> > > > > > > > parent driver.
> > > > > > > >
> > > > > > > > I'm ok to go back to this spurious kick, but I'm not sure i=
f the hw
> > > > > > > > will read the ring before the kick actually. I can ask.
> > > > > > > >
> > > > > > > > Thanks!
> > > > > > > >
> > > > > > > > [1] https://lists.nongnu.org/archive/html/qemu-devel/2023-0=
1/msg02775.html
> > > > > > >
> > > > > > > Let's find out. We need to check for ENABLE_AFTER_DRIVER_OK t=
oo, no?
> > > > > >
> > > > > > My understanding is [1] assuming ACCESS_AFTER_KICK. This seems
> > > > > > sub-optimal than assuming ENABLE_AFTER_DRIVER_OK.
> > > > > >
> > > > > > But this reminds me one thing, as the thread is going too long,=
 I
> > > > > > wonder if we simply assume ENABLE_AFTER_DRIVER_OK if RING_RESET=
 is
> > > > > > supported?
> > > > > >
> > > > > > Thanks
> > > > >
> > > > > I don't see what does one have to do with another ...
> > > > >
> > > > > I think with RING_RESET we had another solution, enable rings
> > > > > mapping them to a zero page, then reset and re-enable later.
> > > >
> > > > As discussed before, this seems to have some problems:
> > > >
> > > > 1) The behaviour is not clarified in the document
> > > > 2) zero is a valid IOVA
> > > >
> > >
> > > I think we're not on the same page here.
> > >
> > > As I understood, rings mapped to a zero page means essentially an
> > > avail ring whose avail_idx is always 0, offered to the device instead
> > > of the guest's ring. Once all CVQ commands are processed, we use
> > > RING_RESET to switch to the right ring, being guest's or SVQ vring.
> >
> > I get this. This seems more complicated in the destination: shadow vq +=
 ASID?
>
> So it's something like:
>
> 1) set all vq ASID to shadow virtqueue
> 2) do not add any bufs to data qp (stick 0 as avail index)
> 3) start to restore states via cvq
> 4) ring_rest for dataqp
> 5) set_vq_state for dataqp
> 6) re-initialize dataqp address etc
> 7) set data QP ASID to guest
> 8) set queue_enable
>
> ?
>

I think the change of ASID is not needed, as the guest cannot access
the device in that timeframe anyway. Moreover, it may require HW
support. So steps 1 and 7 are not needed.

Apart from that, the process is right.


> Thanks
>
> >
> > Thanks
> >
> > >
> > >
> > >
> > > > Thanks
> > > >
> > > > >
> > > > > > >
> > > > > > >
> > > > > > >
> > > > > > > > > > My plan was to convert
> > > > > > > > > > it in vp_vdpa if needed, and reuse the current vdpa ops=
. Sorry if I
> > > > > > > > > > was not explicit enough.
> > > > > > > > > >
> > > > > > > > > > The only solution I can see to that is to trap & emulat=
e in the vdpa
> > > > > > > > > > (parent?) driver, as talked in virtio-comment. But that=
 complicates
> > > > > > > > > > the architecture:
> > > > > > > > > > * Offer VHOST_BACKEND_F_RING_ACCESS_AFTER_KICK
> > > > > > > > > > * Store vq enable state separately, at
> > > > > > > > > > vdpa->config->set_vq_ready(true), but not transmit that=
 enable to hw
> > > > > > > > > > * Store the doorbell state separately, but do not confi=
gure it to the
> > > > > > > > > > device directly.
> > > > > > > > > >
> > > > > > > > > > But how to recover if the device cannot configure them =
at kick time,
> > > > > > > > > > for example?
> > > > > > > > > >
> > > > > > > > > > Maybe we can just fail if the parent driver does not su=
pport enabling
> > > > > > > > > > the vq after DRIVER_OK? That way no new feature flag is=
 needed.
> > > > > > > > > >
> > > > > > > > > > Thanks!
> > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > > ---
> > > > > > > > > > > > Sent with Fixes: tag pointing to git.kernel.org/pub=
/scm/linux/kernel/git/mst
> > > > > > > > > > > > commit. Please let me know if I should send a v3 of=
 [1] instead.
> > > > > > > > > > > >
> > > > > > > > > > > > [1] https://lore.kernel.org/lkml/20230609121244-mut=
t-send-email-mst@kernel.org/T/
> > > > > > > > > > > > ---
> > > > > > > > > > > >  drivers/vhost/vdpa.c | 7 +++++--
> > > > > > > > > > > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > > > > > > > > > > >
> > > > > > > > > > > > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/v=
dpa.c
> > > > > > > > > > > > index e1abf29fed5b..a7e554352351 100644
> > > > > > > > > > > > --- a/drivers/vhost/vdpa.c
> > > > > > > > > > > > +++ b/drivers/vhost/vdpa.c
> > > > > > > > > > > > @@ -681,18 +681,21 @@ static long vhost_vdpa_unlock=
ed_ioctl(struct file *filep,
> > > > > > > > > > > >  {
> > > > > > > > > > > >       struct vhost_vdpa *v =3D filep->private_data;
> > > > > > > > > > > >       struct vhost_dev *d =3D &v->vdev;
> > > > > > > > > > > > +     const struct vdpa_config_ops *ops =3D v->vdpa=
->config;
> > > > > > > > > > > >       void __user *argp =3D (void __user *)arg;
> > > > > > > > > > > >       u64 __user *featurep =3D argp;
> > > > > > > > > > > > -     u64 features;
> > > > > > > > > > > > +     u64 features, parent_features =3D 0;
> > > > > > > > > > > >       long r =3D 0;
> > > > > > > > > > > >
> > > > > > > > > > > >       if (cmd =3D=3D VHOST_SET_BACKEND_FEATURES) {
> > > > > > > > > > > >               if (copy_from_user(&features, feature=
p, sizeof(features)))
> > > > > > > > > > > >                       return -EFAULT;
> > > > > > > > > > > > +             if (ops->get_backend_features)
> > > > > > > > > > > > +                     parent_features =3D ops->get_=
backend_features(v->vdpa);
> > > > > > > > > > > >               if (features & ~(VHOST_VDPA_BACKEND_F=
EATURES |
> > > > > > > > > > > >                                BIT_ULL(VHOST_BACKEN=
D_F_SUSPEND) |
> > > > > > > > > > > >                                BIT_ULL(VHOST_BACKEN=
D_F_RESUME) |
> > > > > > > > > > > > -                              BIT_ULL(VHOST_BACKEN=
D_F_ENABLE_AFTER_DRIVER_OK)))
> > > > > > > > > > > > +                              parent_features))
> > > > > > > > > > > >                       return -EOPNOTSUPP;
> > > > > > > > > > > >               if ((features & BIT_ULL(VHOST_BACKEND=
_F_SUSPEND)) &&
> > > > > > > > > > > >                    !vhost_vdpa_can_suspend(v))
> > > > > > > > > > > > --
> > > > > > > > > > > > 2.39.3
> > > > > > > > > > >
> > > > > > > > >
> > > > > > >
> > > > >
> > > >
> > >
>

