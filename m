Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBAA31F5761
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 17:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730030AbgFJPNV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 11:13:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56718 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728178AbgFJPNT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 11:13:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591801997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3AdYr/U77mMkba00VNjxwsRChFi8mZOf+xIMqa5UEd8=;
        b=VAf8WwMdPYF0UqCwQtRRQ9OrKnIe8JW6E23tKoszhYcIIauVmY3lMSvRQA81v4cm4vNIGG
        DVDe/9ccqaosCpUkd7Ds8rL6QCiuZyKbzqGKEvmA87TCzMFpm6VHFd9Ra15J5aOv99W2VL
        qLO4as4etqhsq/7xjCU//WhXGP2w6Mk=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-rE6xDuZ4MjO9asg3OzAFCw-1; Wed, 10 Jun 2020 11:13:15 -0400
X-MC-Unique: rE6xDuZ4MjO9asg3OzAFCw-1
Received: by mail-qv1-f71.google.com with SMTP id a4so250454qvl.18
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 08:13:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3AdYr/U77mMkba00VNjxwsRChFi8mZOf+xIMqa5UEd8=;
        b=pfQhFKBoNQNBk0c9AQ+inA3S9WPwIChYOyFtMh+NfsliIRKybyKKk+Vx7g/jV5gAYO
         EDn5J5IjzM83FGhE2qFcO1+yPe6KYdpJP5wPRSZ9iKx9RyrkpjVcat8hz6hDYkcJUxYf
         jB438ybJir+vDIKEcO0fMp1rzDL8e8W6dg6RqnsjVzvAg4qtS1fONJ0GIzZGEsiSGOTh
         6hMAPnOoiQoE1lRXt0zJ2QeEWgU8OW35a6+zjeQMDJ4KtbMDmLV1OF6amOjXolOzosLy
         ARNz4XTVHlGLxakzhk5w2cjyKcyDvGXieybdEQ3KvOou79l9P/hqdW2AWxegBBV/JJEe
         q7iA==
X-Gm-Message-State: AOAM530s7RfnLBqpxxALrO3L2ZW7wBB2H5xqNYZp8VDLLxz3/VUDEaAj
        Bilo4oGZO2/+ID6jaN7ICLmsm+/oTLcGpGV5z6sFMEOpLE7VXYrOpVatd4Ojq43bw/SwcRAkR9P
        i/RNTouD7ygLolTV55uOzn7KXAOoQ
X-Received: by 2002:a37:64c6:: with SMTP id y189mr3551952qkb.353.1591801994699;
        Wed, 10 Jun 2020 08:13:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwovFovQktr5FDtnKmi/qfV9U/JIt3SgEZcGlhc24/Y8nyTtcbWFoPeeQWrV1AVZ8DuEyVDZI1fNaUzJ7c0Ego=
X-Received: by 2002:a37:64c6:: with SMTP id y189mr3551926qkb.353.1591801994393;
 Wed, 10 Jun 2020 08:13:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200610113515.1497099-1-mst@redhat.com> <20200610113515.1497099-4-mst@redhat.com>
 <035e82bcf4ade0017641c5b457d0c628c5915732.camel@redhat.com> <20200610105829-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200610105829-mutt-send-email-mst@kernel.org>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Wed, 10 Jun 2020 17:12:38 +0200
Message-ID: <CAJaqyWe=v=V9Okh8Fwmc2k8X5-X_wqH803+p1FnSB-LbD3LDpA@mail.gmail.com>
Subject: Re: [PATCH RFC v7 03/14] vhost: use batched get_vq_desc version
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 10, 2020 at 5:08 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Jun 10, 2020 at 04:29:29PM +0200, Eugenio P=C3=83=C2=A9rez wrote:
> > On Wed, 2020-06-10 at 07:36 -0400, Michael S. Tsirkin wrote:
> > > As testing shows no performance change, switch to that now.
> > >
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > Signed-off-by: Eugenio P=C3=83=C2=A9rez <eperezma@redhat.com>
> > > Link: https://lore.kernel.org/r/20200401183118.8334-3-eperezma@redhat=
.com
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > ---
> > >  drivers/vhost/test.c  |   2 +-
> > >  drivers/vhost/vhost.c | 318 ++++++++--------------------------------=
--
> > >  drivers/vhost/vhost.h |   7 +-
> > >  3 files changed, 65 insertions(+), 262 deletions(-)
> > >
> > > diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> > > index 0466921f4772..7d69778aaa26 100644
> > > --- a/drivers/vhost/test.c
> > > +++ b/drivers/vhost/test.c
> > > @@ -119,7 +119,7 @@ static int vhost_test_open(struct inode *inode, s=
truct file *f)
> > >     dev =3D &n->dev;
> > >     vqs[VHOST_TEST_VQ] =3D &n->vqs[VHOST_TEST_VQ];
> > >     n->vqs[VHOST_TEST_VQ].handle_kick =3D handle_vq_kick;
> > > -   vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV,
> > > +   vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV + 64,
> > >                    VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT, true, NU=
LL);
> > >
> > >     f->private_data =3D n;
> > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > index 11433d709651..28f324fd77df 100644
> > > --- a/drivers/vhost/vhost.c
> > > +++ b/drivers/vhost/vhost.c
> > > @@ -304,6 +304,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
> > >  {
> > >     vq->num =3D 1;
> > >     vq->ndescs =3D 0;
> > > +   vq->first_desc =3D 0;
> > >     vq->desc =3D NULL;
> > >     vq->avail =3D NULL;
> > >     vq->used =3D NULL;
> > > @@ -372,6 +373,11 @@ static int vhost_worker(void *data)
> > >     return 0;
> > >  }
> > >
> > > +static int vhost_vq_num_batch_descs(struct vhost_virtqueue *vq)
> > > +{
> > > +   return vq->max_descs - UIO_MAXIOV;
> > > +}
> > > +
> > >  static void vhost_vq_free_iovecs(struct vhost_virtqueue *vq)
> > >  {
> > >     kfree(vq->descs);
> > > @@ -394,6 +400,9 @@ static long vhost_dev_alloc_iovecs(struct vhost_d=
ev *dev)
> > >     for (i =3D 0; i < dev->nvqs; ++i) {
> > >             vq =3D dev->vqs[i];
> > >             vq->max_descs =3D dev->iov_limit;
> > > +           if (vhost_vq_num_batch_descs(vq) < 0) {
> > > +                   return -EINVAL;
> > > +           }
> > >             vq->descs =3D kmalloc_array(vq->max_descs,
> > >                                       sizeof(*vq->descs),
> > >                                       GFP_KERNEL);
> > > @@ -1610,6 +1619,7 @@ long vhost_vring_ioctl(struct vhost_dev *d, uns=
igned int ioctl, void __user *arg
> > >             vq->last_avail_idx =3D s.num;
> > >             /* Forget the cached index value. */
> > >             vq->avail_idx =3D vq->last_avail_idx;
> > > +           vq->ndescs =3D vq->first_desc =3D 0;
> >
> > This is not needed if it is done in vhost_vq_set_backend, as far as I c=
an tell.
> >
> > Actually, maybe it is even better to move `vq->avail_idx =3D vq->last_a=
vail_idx;` line to vhost_vq_set_backend, it is part
> > of the backend "set up" procedure, isn't it?
> >
> > I tested with virtio_test + batch tests sent in
> > https://lkml.kernel.org/lkml/20200418102217.32327-1-eperezma@redhat.com=
/T/.
>
> Ow did I forget to merge them for rc1?  Should I have? Maybe Linus won't
> yell to hard at me if I merge them after rc1.
>
>
> > I append here what I'm proposing in case it is clearer this way.
> >
> > Thanks!
> >
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index 4d198994e7be..809ad2cd2879 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -1617,9 +1617,6 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsig=
ned int ioctl, void __user *arg
> >                       break;
> >               }
> >               vq->last_avail_idx =3D s.num;
> > -             /* Forget the cached index value. */
> > -             vq->avail_idx =3D vq->last_avail_idx;
> > -             vq->ndescs =3D vq->first_desc =3D 0;
> >               break;
> >       case VHOST_GET_VRING_BASE:
> >               s.index =3D idx;
> > diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> > index fed36af5c444..f4902dc808e4 100644
> > --- a/drivers/vhost/vhost.h
> > +++ b/drivers/vhost/vhost.h
> > @@ -258,6 +258,7 @@ static inline void vhost_vq_set_backend(struct vhos=
t_virtqueue *vq,
> >                                       void *private_data)
> >  {
> >       vq->private_data =3D private_data;
> > +     vq->avail_idx =3D vq->last_avail_idx;
> >       vq->ndescs =3D 0;
> >       vq->first_desc =3D 0;
> >  }
> >
>
> Seems like a nice cleanup, though it's harmless right?
>

Fields ndescs and first_descs are supposed to be updated outside, that
was the intention but maybe I forgot to delete it here, not sure.

Regarding avail_idx, the whole change has been tested with vhost_test
and for vhost needs to have a backend to modify it already so it seems
safe to me.

