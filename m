Return-Path: <kvm+bounces-12969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F98A88F7F1
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 07:34:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 808071F26982
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 06:34:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FD323399C;
	Thu, 28 Mar 2024 06:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="X5refO/e"
X-Original-To: kvm@vger.kernel.org
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01506225A8;
	Thu, 28 Mar 2024 06:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711607662; cv=none; b=F5szEpayE2l+iU1BVExOiYJh6l4PwaW5o8gxSUOTBnBCSt0ean0NUObcs/CgusM6MkgCp7/b7mnMyy2zvG526jqNMhHhXmhwipiTf6n72sIf81Y91QMQibPvuK2ZohQmQTekAE5770JIasDwQr5q89Hj+xHKBQpwRblW7TYX3kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711607662; c=relaxed/simple;
	bh=AWSWe37tvUTJI8Kn/xZqWAmqOVT4q401ypC073MJEQ4=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To:
	 Content-Type; b=iIMb/DanfenZMLCFSFK5zBN9vmYLVdjehMsFKV/58oBZKmgDSOJbwdleY0RcJfarMEaR74CsjrjrajHqfonMm7UZEarRcYM5cmM9BZBpzhQKNa1qa0pVurGWAOQ8kW7oxH8glzmuflKLx6hL6o2OPUl2xidq8Qqb49hrgwrevHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=X5refO/e; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1711607653; h=Message-ID:Subject:Date:From:To:Content-Type;
	bh=IBtAlx6xKMHEbRBKxgn51ZjPfu2bAbCnF3S7grDjY3g=;
	b=X5refO/eYFS0UGp4/0+DOTyY1xcDxhBvpM7nQOPy5uDwDXcfoMF9rGkTjPol5v3yZMKEgWwllrF49yEMNMybmZesqjViba6h4BeLV9Xvo4v6Das2RyhM4v4/D3pv5frbR0MX1lERf6KWAsFcFVmmSKh1Byk0jNDHChQFhYmNx+w=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0W3QzI2o_1711607650;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W3QzI2o_1711607650)
          by smtp.aliyun-inc.com;
          Thu, 28 Mar 2024 14:34:11 +0800
Message-ID: <1711607635.4907694-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost v6 5/6] virtio: vring_new_virtqueue(): pass struct instead of multi parameters
Date: Thu, 28 Mar 2024 14:33:55 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: Jason Wang <jasowang@redhat.com>
Cc: virtualization@lists.linux.dev,
 Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Hans de Goede <hdegoede@redhat.com>,
 =?utf-8?q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Vadim Pasternak <vadimp@nvidia.com>,
 Bjorn Andersson <andersson@kernel.org>,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Cornelia Huck <cohuck@redhat.com>,
 Halil Pasic <pasic@linux.ibm.com>,
 Eric Farman <farman@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 David Hildenbrand <david@redhat.com>,
 linux-um@lists.infradead.org,
 platform-driver-x86@vger.kernel.org,
 linux-remoteproc@vger.kernel.org,
 linux-s390@vger.kernel.org,
 kvm@vger.kernel.org
References: <20240327095741.88135-1-xuanzhuo@linux.alibaba.com>
 <20240327095741.88135-6-xuanzhuo@linux.alibaba.com>
 <CACGkMEu4J0ZD26GjahKr6YysBrj==rgtiKcnpnuV7dC9Zj-+CQ@mail.gmail.com>
In-Reply-To: <CACGkMEu4J0ZD26GjahKr6YysBrj==rgtiKcnpnuV7dC9Zj-+CQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

On Thu, 28 Mar 2024 12:31:48 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Wed, Mar 27, 2024 at 5:58=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba=
.com> wrote:
> >
> > Now, we pass multi parameters to vring_new_virtqueue. These parameters
> > may from transport or from driver.
> >
> > vring_new_virtqueue is called by many places.
> > Every time, we try to add a new parameter, that is difficult.
> >
> > If parameters from the driver, that should directly be passed to vring.
> > Then the vring can access the config from driver directly.
> >
> > If parameters from the transport, we squish the parameters to a
> > structure. That will be helpful to add new parameter.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > Reviewed-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>
> > ---
> >  drivers/platform/mellanox/mlxbf-tmfifo.c | 12 ++++---
> >  drivers/remoteproc/remoteproc_virtio.c   | 11 ++++---
> >  drivers/virtio/virtio_ring.c             | 29 +++++++++++-----
> >  include/linux/virtio_ring.h              | 42 +++++++++++++++++++-----
> >  tools/virtio/virtio_test.c               |  4 +--
> >  tools/virtio/vringh_test.c               | 28 ++++++++--------
> >  6 files changed, 84 insertions(+), 42 deletions(-)
> >
> > diff --git a/drivers/platform/mellanox/mlxbf-tmfifo.c b/drivers/platfor=
m/mellanox/mlxbf-tmfifo.c
> > index 4252388f52a2..d2e871fad8b4 100644
> > --- a/drivers/platform/mellanox/mlxbf-tmfifo.c
> > +++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
> > @@ -1059,6 +1059,7 @@ static int mlxbf_tmfifo_virtio_find_vqs(struct vi=
rtio_device *vdev,
> >                                         struct virtio_vq_config *cfg)
> >  {
> >         struct mlxbf_tmfifo_vdev *tm_vdev =3D mlxbf_vdev_to_tmfifo(vdev=
);
> > +       struct vq_transport_config tp_cfg =3D {};
> >         struct virtqueue **vqs =3D cfg->vqs;
> >         struct mlxbf_tmfifo_vring *vring;
> >         unsigned int nvqs =3D cfg->nvqs;
> > @@ -1078,10 +1079,13 @@ static int mlxbf_tmfifo_virtio_find_vqs(struct =
virtio_device *vdev,
> >                 /* zero vring */
> >                 size =3D vring_size(vring->num, vring->align);
> >                 memset(vring->va, 0, size);
> > -               vq =3D vring_new_virtqueue(i, vring->num, vring->align,=
 vdev,
> > -                                        false, false, vring->va,
> > -                                        mlxbf_tmfifo_virtio_notify,
> > -                                        cfg->callbacks[i], cfg->names[=
i]);
> > +
> > +               tp_cfg.num =3D vring->num;
> > +               tp_cfg.vring_align =3D vring->align;
> > +               tp_cfg.weak_barriers =3D false;
> > +               tp_cfg.notify =3D mlxbf_tmfifo_virtio_notify;
> > +
> > +               vq =3D vring_new_virtqueue(vdev, i, vring->va, &tp_cfg,=
 cfg);
> >                 if (!vq) {
> >                         dev_err(&vdev->dev, "vring_new_virtqueue failed=
\n");
> >                         ret =3D -ENOMEM;
> > diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remotepro=
c/remoteproc_virtio.c
> > index 489fea1d41c0..2319c2007833 100644
> > --- a/drivers/remoteproc/remoteproc_virtio.c
> > +++ b/drivers/remoteproc/remoteproc_virtio.c
> > @@ -106,6 +106,7 @@ static struct virtqueue *rp_find_vq(struct virtio_d=
evice *vdev,
> >  {
> >         struct rproc_vdev *rvdev =3D vdev_to_rvdev(vdev);
> >         struct rproc *rproc =3D vdev_to_rproc(vdev);
> > +       struct vq_transport_config tp_cfg;
>
> Should we zero this structure?

YES.

Will fix in next version.

Thanks.


>
> Thanks
>

