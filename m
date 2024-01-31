Return-Path: <kvm+bounces-7549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 11EDD843ABA
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 10:16:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 283681C22287
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 09:16:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63AEF69D0D;
	Wed, 31 Jan 2024 09:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ka1+G3AH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C6369D11
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 09:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706692376; cv=none; b=CQMkP0QdErDhtqaHNNQBvyLG4AZbcP807VXvwGt7lvXseiERsom/NOARSkp1fnZmjA7Twe/JH1pB6aQo/xBwhigevQFZTesxJsOOybepSlCMz2gG23wHLMs2+K567enoWObuEZhqEVZ0w+2P1NUh8h1SFPAvrSUXT/hQjCim+Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706692376; c=relaxed/simple;
	bh=pmyJdW/3Z7RcZYx9FLKKoEZPHnG+irMxTbjMmTv2qIM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XB6b/wtsQ2ZjD1Dvnly+YSVEbFOtsLMIaHEcOACebW1NGLbaPY3i2jtEb2Iax1JHd4wlsLdNx8gGX53ZqVEWZVIU5F/2DFMGOBLtfuhJAsFohISEj1Dmn7lvODlPvbaHM9w8oi+sigwscpjFE123sN8ZM636W7CGoSGq0QKAHXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ka1+G3AH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706692373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mTDQEAtCJw8SjjLAHPKM3y2B7ETcsHUbUlWVfs7SX6o=;
	b=Ka1+G3AHMIFPOn2VCuJCPYD2IFe16BI3Fk1RLIB2H6c8HDaTqHIcPdZZWL5A6cfN7QYvqL
	6KeGTMChVlpxeI8FE1rWmb1hvyoyzmeqJA6c6PwXhNUgjrqy9gwKFeN1mLNA0splRXS8rR
	C212VikDVV4rNnCwyKORv/Y2mmA6gtU=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-413-Ywc0N4EGO1qy66R8rskCmw-1; Wed, 31 Jan 2024 04:12:51 -0500
X-MC-Unique: Ywc0N4EGO1qy66R8rskCmw-1
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-3be76c32883so2495001b6e.2
        for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 01:12:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706692368; x=1707297168;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mTDQEAtCJw8SjjLAHPKM3y2B7ETcsHUbUlWVfs7SX6o=;
        b=l9ha7FTCAWqrl2gU5cdwKt6x1foFO4W+QNGoRSEToQZLlbN0RfJD5ox5Wyyq9yvxNo
         CG9TORdSvEKX3RnjJ3w+OMrxYvndtOnY8Lkfcf3l38YDxDIm9uhhLjQpcMpgNv3ZlWNY
         yV3x2chmmNMNWqEUR8Ha8ZWZSvCwmOu5laTkEZ2+OXsSmFN94aSiZds212nBtNbZirOY
         vyuvyPzGFX/L+sd2TWQ7fgrxq9sbrbElnsZmbDtqQB8lnsX2Ve8DmMvZ46L9MuxAXK3N
         x1yr8Rc4MdqZvEP9jTwv06xo+fxFgVH/sE7sp1ufJuhGRqhsWUMgYH6l6LQktr3h2W+N
         HC/Q==
X-Gm-Message-State: AOJu0YyHslKMtyIE8N+6XgDmVQsQUz2F1pgzgPICUnDWjTtkjL5tHJh9
	kPxfx999LulSc/XTDfzrTteFbekYtS+yN8xJYABOaO6QHIvXEOafO8f+1GqQtTlCYhPk5d/Z8bf
	7D+jkk2n/EOlQ/B834twcR7QUXPcBnSB9Vhz3nn/qpK3UxHSKbvrNTJWPkIbtqsTs5c0zYD40Id
	sh4G3F9wzT+rHMlGUomNf5Pcw2
X-Received: by 2002:a05:6808:14cf:b0:3be:bc8e:31de with SMTP id f15-20020a05680814cf00b003bebc8e31demr1218937oiw.41.1706692367803;
        Wed, 31 Jan 2024 01:12:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFJuBmh1WvFFjPTM/4cg+C+iWgMUHwgyQMpYB0gMYeyd8tkmwS1V0FJdXluYWd+fqp4cw4FNMBM7IEA1mAE9LU=
X-Received: by 2002:a05:6808:14cf:b0:3be:bc8e:31de with SMTP id
 f15-20020a05680814cf00b003bebc8e31demr1218903oiw.41.1706692367222; Wed, 31
 Jan 2024 01:12:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240130114224.86536-1-xuanzhuo@linux.alibaba.com> <20240130114224.86536-8-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20240130114224.86536-8-xuanzhuo@linux.alibaba.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 31 Jan 2024 17:12:34 +0800
Message-ID: <CACGkMEvb4N8kthr4qWXrLOh9v422OYhrYU6hQejusw-e5EacPw@mail.gmail.com>
Subject: Re: [PATCH vhost 07/17] virtio: find_vqs: pass struct instead of
 multi parameters
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: virtualization@lists.linux.dev, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	"Michael S. Tsirkin" <mst@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Hans de Goede <hdegoede@redhat.com>, 
	=?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
	Vadim Pasternak <vadimp@nvidia.com>, Bjorn Andersson <andersson@kernel.org>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, Cornelia Huck <cohuck@redhat.com>, 
	Halil Pasic <pasic@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>, Benjamin Berg <benjamin.berg@intel.com>, 
	Yang Li <yang.lee@linux.alibaba.com>, linux-um@lists.infradead.org, 
	netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org, 
	linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org, 
	kvm@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 30, 2024 at 7:42=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba.c=
om> wrote:
>
> Now, we pass multi parameters to find_vqs. These parameters
> may work for transport or work for vring.
>
> And find_vqs has multi implements in many places:
>
> But every time,
>  arch/um/drivers/virtio_uml.c
>  drivers/platform/mellanox/mlxbf-tmfifo.c
>  drivers/remoteproc/remoteproc_virtio.c
>  drivers/s390/virtio/virtio_ccw.c
>  drivers/virtio/virtio_mmio.c
>  drivers/virtio/virtio_pci_legacy.c
>  drivers/virtio/virtio_pci_modern.c
>  drivers/virtio/virtio_vdpa.c
>
> Every time, we try to add a new parameter, that is difficult.
> We must change every find_vqs implement.
>
> One the other side, if we want to pass a parameter to vring,
> we must change the call path from transport to vring.
> Too many functions need to be changed.
>
> So it is time to refactor the find_vqs. We pass a structure
> cfg to find_vqs(), that will be passed to vring by transport.
>
> And squish the parameters from transport to a structure.

The patch did more than what is described here, it also switch to use
a structure for vring_create_virtqueue() etc.

Is it better to split?

>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  arch/um/drivers/virtio_uml.c             | 29 +++++++-----
>  drivers/platform/mellanox/mlxbf-tmfifo.c | 14 +++---
>  drivers/remoteproc/remoteproc_virtio.c   | 28 ++++++-----
>  drivers/s390/virtio/virtio_ccw.c         | 33 ++++++-------
>  drivers/virtio/virtio_mmio.c             | 30 ++++++------
>  drivers/virtio/virtio_pci_common.c       | 59 +++++++++++-------------
>  drivers/virtio/virtio_pci_common.h       |  9 +---
>  drivers/virtio/virtio_pci_legacy.c       | 16 ++++---
>  drivers/virtio/virtio_pci_modern.c       | 24 +++++-----
>  drivers/virtio/virtio_ring.c             | 59 ++++++++++--------------
>  drivers/virtio/virtio_vdpa.c             | 33 +++++++------
>  include/linux/virtio_config.h            | 51 ++++++++++++++++----
>  include/linux/virtio_ring.h              | 40 ++++++----------
>  13 files changed, 217 insertions(+), 208 deletions(-)
>
> diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
> index 8adca2000e51..161bac67e454 100644
> --- a/arch/um/drivers/virtio_uml.c
> +++ b/arch/um/drivers/virtio_uml.c
> @@ -937,11 +937,12 @@ static int vu_setup_vq_call_fd(struct virtio_uml_de=
vice *vu_dev,
>  }
>
>  static struct virtqueue *vu_setup_vq(struct virtio_device *vdev,
> -                                    unsigned index, vq_callback_t *callb=
ack,
> -                                    const char *name, bool ctx)
> +                                    unsigned index,
> +                                    struct virtio_vq_config *cfg)
>  {
>         struct virtio_uml_device *vu_dev =3D to_virtio_uml_device(vdev);
>         struct platform_device *pdev =3D vu_dev->pdev;
> +       struct transport_vq_config tp_cfg =3D {};

Nit: what did "tp" short for?

>         struct virtio_uml_vq_info *info;
>         struct virtqueue *vq;
>         int num =3D MAX_SUPPORTED_QUEUE_SIZE;
> @@ -953,10 +954,15 @@ static struct virtqueue *vu_setup_vq(struct virtio_=
device *vdev,
>                 goto error_kzalloc;
>         }
>         snprintf(info->name, sizeof(info->name), "%s.%d-%s", pdev->name,
> -                pdev->id, name);
> +                pdev->id, cfg->names[cfg->cfg_idx]);
>
> -       vq =3D vring_create_virtqueue(index, num, PAGE_SIZE, vdev, true, =
true,
> -                                   ctx, vu_notify, callback, info->name)=
;
> +       tp_cfg.num =3D num;
> +       tp_cfg.vring_align =3D PAGE_SIZE;
> +       tp_cfg.weak_barriers =3D true;
> +       tp_cfg.may_reduce_num =3D true;
> +       tp_cfg.notify =3D vu_notify;
> +
> +       vq =3D vring_create_virtqueue(vdev, index, &tp_cfg, cfg);
>         if (!vq) {
>                 rc =3D -ENOMEM;
>                 goto error_create;
> @@ -1013,12 +1019,11 @@ static struct virtqueue *vu_setup_vq(struct virti=
o_device *vdev,
>         return ERR_PTR(rc);
>  }
>
> -static int vu_find_vqs(struct virtio_device *vdev, unsigned nvqs,
> -                      struct virtqueue *vqs[], vq_callback_t *callbacks[=
],
> -                      const char * const names[], const bool *ctx,
> -                      struct irq_affinity *desc)
> +static int vu_find_vqs(struct virtio_device *vdev, struct virtio_vq_conf=
ig *cfg)
>  {
>         struct virtio_uml_device *vu_dev =3D to_virtio_uml_device(vdev);
> +       struct virtqueue **vqs =3D cfg->vqs;
> +       unsigned int nvqs =3D cfg->nvqs;
>         int i, queue_idx =3D 0, rc;
>         struct virtqueue *vq;
>
> @@ -1031,13 +1036,13 @@ static int vu_find_vqs(struct virtio_device *vdev=
, unsigned nvqs,
>                 return rc;
>
>         for (i =3D 0; i < nvqs; ++i) {
> -               if (!names[i]) {
> +               if (!cfg->names[i]) {
>                         vqs[i] =3D NULL;
>                         continue;
>                 }
>
> -               vqs[i] =3D vu_setup_vq(vdev, queue_idx++, callbacks[i], n=
ames[i],
> -                                    ctx ? ctx[i] : false);
> +               cfg->cfg_idx =3D i;
> +               vqs[i] =3D vu_setup_vq(vdev, queue_idx++, cfg);
>                 if (IS_ERR(vqs[i])) {
>                         rc =3D PTR_ERR(vqs[i]);
>                         goto error_setup;
> diff --git a/drivers/platform/mellanox/mlxbf-tmfifo.c b/drivers/platform/=
mellanox/mlxbf-tmfifo.c
> index 5c683b4eaf10..1b5593965068 100644
> --- a/drivers/platform/mellanox/mlxbf-tmfifo.c
> +++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
> @@ -989,15 +989,12 @@ static void mlxbf_tmfifo_virtio_del_vqs(struct virt=
io_device *vdev)
>
>  /* Create and initialize the virtual queues. */
>  static int mlxbf_tmfifo_virtio_find_vqs(struct virtio_device *vdev,
> -                                       unsigned int nvqs,
> -                                       struct virtqueue *vqs[],
> -                                       vq_callback_t *callbacks[],
> -                                       const char * const names[],
> -                                       const bool *ctx,
> -                                       struct irq_affinity *desc)
> +                                       struct virtio_vq_config *cfg)
>  {
>         struct mlxbf_tmfifo_vdev *tm_vdev =3D mlxbf_vdev_to_tmfifo(vdev);
> +       struct virtqueue **vqs =3D cfg->vqs;
>         struct mlxbf_tmfifo_vring *vring;
> +       unsigned int nvqs =3D cfg->nvqs;
>         struct virtqueue *vq;
>         int i, ret, size;
>
> @@ -1005,7 +1002,7 @@ static int mlxbf_tmfifo_virtio_find_vqs(struct virt=
io_device *vdev,
>                 return -EINVAL;
>
>         for (i =3D 0; i < nvqs; ++i) {
> -               if (!names[i]) {
> +               if (!cfg->names[i]) {
>                         ret =3D -EINVAL;
>                         goto error;
>                 }
> @@ -1014,10 +1011,11 @@ static int mlxbf_tmfifo_virtio_find_vqs(struct vi=
rtio_device *vdev,
>                 /* zero vring */
>                 size =3D vring_size(vring->num, vring->align);
>                 memset(vring->va, 0, size);
> +

Unnecessary changes.

>                 vq =3D vring_new_virtqueue(i, vring->num, vring->align, v=
dev,
>                                          false, false, vring->va,
>                                          mlxbf_tmfifo_virtio_notify,
> -                                        callbacks[i], names[i]);
> +                                        cfg->callbacks[i], cfg->names[i]=
);
>                 if (!vq) {
>                         dev_err(&vdev->dev, "vring_new_virtqueue failed\n=
");
>                         ret =3D -ENOMEM;
> diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/=
remoteproc_virtio.c
> index 83d76915a6ad..57d51c9c7b63 100644
> --- a/drivers/remoteproc/remoteproc_virtio.c
> +++ b/drivers/remoteproc/remoteproc_virtio.c
> @@ -102,8 +102,7 @@ EXPORT_SYMBOL(rproc_vq_interrupt);
>
>  static struct virtqueue *rp_find_vq(struct virtio_device *vdev,
>                                     unsigned int id,
> -                                   void (*callback)(struct virtqueue *vq=
),
> -                                   const char *name, bool ctx)
> +                                   struct virtio_vq_config *cfg)
>  {
>         struct rproc_vdev *rvdev =3D vdev_to_rvdev(vdev);
>         struct rproc *rproc =3D vdev_to_rproc(vdev);
> @@ -119,7 +118,7 @@ static struct virtqueue *rp_find_vq(struct virtio_dev=
ice *vdev,
>         if (id >=3D ARRAY_SIZE(rvdev->vring))
>                 return ERR_PTR(-EINVAL);
>
> -       if (!name)
> +       if (!cfg->names[cfg->cfg_idx])
>                 return NULL;
>
>         /* Search allocated memory region by name */
> @@ -143,10 +142,12 @@ static struct virtqueue *rp_find_vq(struct virtio_d=
evice *vdev,
>          * Create the new vq, and tell virtio we're not interested in
>          * the 'weak' smp barriers, since we're talking with a real devic=
e.
>          */
> -       vq =3D vring_new_virtqueue(id, num, rvring->align, vdev, false, c=
tx,
> -                                addr, rproc_virtio_notify, callback, nam=
e);
> +       vq =3D vring_new_virtqueue(id, num, rvring->align, vdev, false,
> +                                cfg->ctx ? cfg->ctx[cfg->cfg_idx] : fals=
e,
> +                                addr, rproc_virtio_notify, cfg->callback=
s[cfg->cfg_idx],
> +                                cfg->names[cfg->cfg_idx]);


Let's pass the structure to vring_new_virtqueue() as
vring_create_virtqueue() did?

>         if (!vq) {
> -               dev_err(dev, "vring_new_virtqueue %s failed\n", name);
> +               dev_err(dev, "vring_new_virtqueue %s failed\n", cfg->name=
s[cfg->cfg_idx]);
>                 rproc_free_vring(rvring);
>                 return ERR_PTR(-ENOMEM);
>         }
> @@ -180,23 +181,20 @@ static void rproc_virtio_del_vqs(struct virtio_devi=
ce *vdev)
>         __rproc_virtio_del_vqs(vdev);
>  }
>
> -static int rproc_virtio_find_vqs(struct virtio_device *vdev, unsigned in=
t nvqs,
> -                                struct virtqueue *vqs[],
> -                                vq_callback_t *callbacks[],
> -                                const char * const names[],
> -                                const bool * ctx,
> -                                struct irq_affinity *desc)
> +static int rproc_virtio_find_vqs(struct virtio_device *vdev, struct virt=
io_vq_config *cfg)
>  {
> +       struct virtqueue **vqs =3D cfg->vqs;
> +       unsigned int nvqs =3D cfg->nvqs;
>         int i, ret, queue_idx =3D 0;
>
>         for (i =3D 0; i < nvqs; ++i) {
> -               if (!names[i]) {
> +               if (!cfg->names[i]) {
>                         vqs[i] =3D NULL;
>                         continue;
>                 }
>
> -               vqs[i] =3D rp_find_vq(vdev, queue_idx++, callbacks[i], na=
mes[i],
> -                                   ctx ? ctx[i] : false);
> +               cfg->cfg_idx =3D i;
> +               vqs[i] =3D rp_find_vq(vdev, queue_idx++, cfg);
>                 if (IS_ERR(vqs[i])) {
>                         ret =3D PTR_ERR(vqs[i]);
>                         goto error;
> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virti=
o_ccw.c
> index ac67576301bf..c7734cd54187 100644
> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -499,11 +499,11 @@ static void virtio_ccw_del_vqs(struct virtio_device=
 *vdev)
>  }
>
>  static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
> -                                            int i, vq_callback_t *callba=
ck,
> -                                            const char *name, bool ctx,
> -                                            struct ccw1 *ccw)
> +                                            int i, struct ccw1 *ccw,
> +                                            struct virtio_vq_config *cfg=
)
>  {
>         struct virtio_ccw_device *vcdev =3D to_vc_device(vdev);
> +       struct transport_vq_config tp_cfg =3D {};
>         bool (*notify)(struct virtqueue *vq);
>         int err;
>         struct virtqueue *vq =3D NULL;
> @@ -537,10 +537,14 @@ static struct virtqueue *virtio_ccw_setup_vq(struct=
 virtio_device *vdev,
>                 goto out_err;
>         }
>         may_reduce =3D vcdev->revision > 0;
> -       vq =3D vring_create_virtqueue(i, info->num, KVM_VIRTIO_CCW_RING_A=
LIGN,
> -                                   vdev, true, may_reduce, ctx,
> -                                   notify, callback, name);
>
> +       tp_cfg.num =3D info->num;
> +       tp_cfg.vring_align =3D KVM_VIRTIO_CCW_RING_ALIGN;
> +       tp_cfg.weak_barriers =3D true;
> +       tp_cfg.may_reduce_num =3D may_reduce;
> +       tp_cfg.notify =3D notify;
> +
> +       vq =3D vring_create_virtqueue(vdev, i, &tp_cfg, cfg);
>         if (!vq) {
>                 /* For now, we fail if we can't get the requested size. *=
/
>                 dev_warn(&vcdev->cdev->dev, "no vq\n");
> @@ -650,15 +654,13 @@ static int virtio_ccw_register_adapter_ind(struct v=
irtio_ccw_device *vcdev,
>         return ret;
>  }
>
> -static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs=
,
> -                              struct virtqueue *vqs[],
> -                              vq_callback_t *callbacks[],
> -                              const char * const names[],
> -                              const bool *ctx,
> -                              struct irq_affinity *desc)
> +static int virtio_ccw_find_vqs(struct virtio_device *vdev,
> +                              struct virtio_vq_config *cfg)
>  {
>         struct virtio_ccw_device *vcdev =3D to_vc_device(vdev);
> +       struct virtqueue **vqs =3D cfg->vqs;
>         unsigned long *indicatorp =3D NULL;
> +       unsigned int nvqs =3D cfg->nvqs;
>         int ret, i, queue_idx =3D 0;
>         struct ccw1 *ccw;
>
> @@ -667,14 +669,13 @@ static int virtio_ccw_find_vqs(struct virtio_device=
 *vdev, unsigned nvqs,
>                 return -ENOMEM;
>
>         for (i =3D 0; i < nvqs; ++i) {
> -               if (!names[i]) {
> +               if (!cfg->names[i]) {
>                         vqs[i] =3D NULL;
>                         continue;
>                 }
>
> -               vqs[i] =3D virtio_ccw_setup_vq(vdev, queue_idx++, callbac=
ks[i],
> -                                            names[i], ctx ? ctx[i] : fal=
se,
> -                                            ccw);
> +               cfg->cfg_idx =3D i;
> +               vqs[i] =3D virtio_ccw_setup_vq(vdev, queue_idx++, ccw, cf=
g);
>                 if (IS_ERR(vqs[i])) {
>                         ret =3D PTR_ERR(vqs[i]);
>                         vqs[i] =3D NULL;
> diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> index 59892a31cf76..ceb7c312a616 100644
> --- a/drivers/virtio/virtio_mmio.c
> +++ b/drivers/virtio/virtio_mmio.c
> @@ -370,10 +370,10 @@ static void vm_synchronize_cbs(struct virtio_device=
 *vdev)
>  }
>
>  static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigne=
d int index,
> -                                 void (*callback)(struct virtqueue *vq),
> -                                 const char *name, bool ctx)
> +                                    struct virtio_vq_config *cfg)
>  {
>         struct virtio_mmio_device *vm_dev =3D to_virtio_mmio_device(vdev)=
;
> +       struct transport_vq_config tp_cfg =3D {};
>         bool (*notify)(struct virtqueue *vq);
>         struct virtio_mmio_vq_info *info;
>         struct virtqueue *vq;
> @@ -386,7 +386,7 @@ static struct virtqueue *vm_setup_vq(struct virtio_de=
vice *vdev, unsigned int in
>         else
>                 notify =3D vm_notify;
>
> -       if (!name)
> +       if (!cfg->names[index])
>                 return NULL;
>
>         /* Select the queue we're interested in */
> @@ -412,9 +412,14 @@ static struct virtqueue *vm_setup_vq(struct virtio_d=
evice *vdev, unsigned int in
>                 goto error_new_virtqueue;
>         }
>
> +       tp_cfg.num =3D num;
> +       tp_cfg.vring_align =3D VIRTIO_MMIO_VRING_ALIGN;
> +       tp_cfg.weak_barriers =3D true;
> +       tp_cfg.may_reduce_num =3D true;
> +       tp_cfg.notify =3D notify;
> +
>         /* Create the vring */
> -       vq =3D vring_create_virtqueue(index, num, VIRTIO_MMIO_VRING_ALIGN=
, vdev,
> -                                true, true, ctx, notify, callback, name)=
;
> +       vq =3D vring_create_virtqueue(vdev, index, &tp_cfg, cfg);
>         if (!vq) {
>                 err =3D -ENOMEM;
>                 goto error_new_virtqueue;
> @@ -487,15 +492,12 @@ static struct virtqueue *vm_setup_vq(struct virtio_=
device *vdev, unsigned int in
>         return ERR_PTR(err);
>  }
>
> -static int vm_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
> -                      struct virtqueue *vqs[],
> -                      vq_callback_t *callbacks[],
> -                      const char * const names[],
> -                      const bool *ctx,
> -                      struct irq_affinity *desc)
> +static int vm_find_vqs(struct virtio_device *vdev, struct virtio_vq_conf=
ig *cfg)
>  {
>         struct virtio_mmio_device *vm_dev =3D to_virtio_mmio_device(vdev)=
;
>         int irq =3D platform_get_irq(vm_dev->pdev, 0);
> +       struct virtqueue **vqs =3D cfg->vqs;
> +       unsigned int nvqs =3D cfg->nvqs;
>         int i, err, queue_idx =3D 0;
>
>         if (irq < 0)
> @@ -510,13 +512,13 @@ static int vm_find_vqs(struct virtio_device *vdev, =
unsigned int nvqs,
>                 enable_irq_wake(irq);
>
>         for (i =3D 0; i < nvqs; ++i) {
> -               if (!names[i]) {
> +               if (!cfg->names[i]) {
>                         vqs[i] =3D NULL;
>                         continue;
>                 }
>
> -               vqs[i] =3D vm_setup_vq(vdev, queue_idx++, callbacks[i], n=
ames[i],
> -                                    ctx ? ctx[i] : false);
> +               cfg->cfg_idx =3D i;
> +               vqs[i] =3D vm_setup_vq(vdev, queue_idx++, cfg);
>                 if (IS_ERR(vqs[i])) {
>                         vm_del_vqs(vdev);
>                         return PTR_ERR(vqs[i]);
> diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_p=
ci_common.c
> index 1d21d1a1b3f5..0ebee2b53eed 100644
> --- a/drivers/virtio/virtio_pci_common.c
> +++ b/drivers/virtio/virtio_pci_common.c
> @@ -172,9 +172,7 @@ static int vp_request_msix_vectors(struct virtio_devi=
ce *vdev, int nvectors,
>  }
>
>  static struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigne=
d int index,
> -                                    void (*callback)(struct virtqueue *v=
q),
> -                                    const char *name,
> -                                    bool ctx,
> +                                    struct virtio_vq_config *cfg,
>                                      u16 msix_vec)
>  {
>         struct virtio_pci_device *vp_dev =3D to_vp_device(vdev);
> @@ -186,13 +184,13 @@ static struct virtqueue *vp_setup_vq(struct virtio_=
device *vdev, unsigned int in
>         if (!info)
>                 return ERR_PTR(-ENOMEM);
>
> -       vq =3D vp_dev->setup_vq(vp_dev, info, index, callback, name, ctx,
> +       vq =3D vp_dev->setup_vq(vp_dev, info, index, cfg,
>                               msix_vec);
>         if (IS_ERR(vq))
>                 goto out_info;
>
>         info->vq =3D vq;
> -       if (callback) {
> +       if (cfg->callbacks[cfg->cfg_idx]) {
>                 spin_lock_irqsave(&vp_dev->lock, flags);
>                 list_add(&info->node, &vp_dev->virtqueues);
>                 spin_unlock_irqrestore(&vp_dev->lock, flags);
> @@ -281,15 +279,15 @@ void vp_del_vqs(struct virtio_device *vdev)
>         vp_dev->vqs =3D NULL;
>  }
>
> -static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned int nvq=
s,
> -               struct virtqueue *vqs[], vq_callback_t *callbacks[],
> -               const char * const names[], bool per_vq_vectors,
> -               const bool *ctx,
> -               struct irq_affinity *desc)
> +static int vp_find_vqs_msix(struct virtio_device *vdev,
> +                           struct virtio_vq_config *cfg,
> +                           bool per_vq_vectors)
>  {
>         struct virtio_pci_device *vp_dev =3D to_vp_device(vdev);
>         u16 msix_vec;
>         int i, err, nvectors, allocated_vectors, queue_idx =3D 0;
> +       struct virtqueue **vqs =3D cfg->vqs;
> +       unsigned int nvqs =3D cfg->nvqs;
>
>         vp_dev->vqs =3D kcalloc(nvqs, sizeof(*vp_dev->vqs), GFP_KERNEL);
>         if (!vp_dev->vqs)
> @@ -299,7 +297,7 @@ static int vp_find_vqs_msix(struct virtio_device *vde=
v, unsigned int nvqs,
>                 /* Best option: one for change interrupt, one per vq. */
>                 nvectors =3D 1;
>                 for (i =3D 0; i < nvqs; ++i)
> -                       if (names[i] && callbacks[i])
> +                       if (cfg->names[i] && cfg->callbacks[i])
>                                 ++nvectors;
>         } else {
>                 /* Second best: one for change, shared for all vqs. */
> @@ -307,27 +305,27 @@ static int vp_find_vqs_msix(struct virtio_device *v=
dev, unsigned int nvqs,
>         }
>
>         err =3D vp_request_msix_vectors(vdev, nvectors, per_vq_vectors,
> -                                     per_vq_vectors ? desc : NULL);
> +                                     per_vq_vectors ? cfg->desc : NULL);
>         if (err)
>                 goto error_find;
>
>         vp_dev->per_vq_vectors =3D per_vq_vectors;
>         allocated_vectors =3D vp_dev->msix_used_vectors;
>         for (i =3D 0; i < nvqs; ++i) {
> -               if (!names[i]) {
> +               if (!cfg->names[i]) {
>                         vqs[i] =3D NULL;
>                         continue;
>                 }
>
> -               if (!callbacks[i])
> +               if (!cfg->callbacks[i])
>                         msix_vec =3D VIRTIO_MSI_NO_VECTOR;
>                 else if (vp_dev->per_vq_vectors)
>                         msix_vec =3D allocated_vectors++;
>                 else
>                         msix_vec =3D VP_MSIX_VQ_VECTOR;
> -               vqs[i] =3D vp_setup_vq(vdev, queue_idx++, callbacks[i], n=
ames[i],
> -                                    ctx ? ctx[i] : false,
> -                                    msix_vec);
> +
> +               cfg->cfg_idx =3D i;
> +               vqs[i] =3D vp_setup_vq(vdev, queue_idx++, cfg, msix_vec);
>                 if (IS_ERR(vqs[i])) {
>                         err =3D PTR_ERR(vqs[i]);
>                         goto error_find;
> @@ -340,7 +338,7 @@ static int vp_find_vqs_msix(struct virtio_device *vde=
v, unsigned int nvqs,
>                 snprintf(vp_dev->msix_names[msix_vec],
>                          sizeof *vp_dev->msix_names,
>                          "%s-%s",
> -                        dev_name(&vp_dev->vdev.dev), names[i]);
> +                        dev_name(&vp_dev->vdev.dev), cfg->names[i]);
>                 err =3D request_irq(pci_irq_vector(vp_dev->pci_dev, msix_=
vec),
>                                   vring_interrupt, 0,
>                                   vp_dev->msix_names[msix_vec],
> @@ -355,11 +353,11 @@ static int vp_find_vqs_msix(struct virtio_device *v=
dev, unsigned int nvqs,
>         return err;
>  }
>
> -static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned int nvq=
s,
> -               struct virtqueue *vqs[], vq_callback_t *callbacks[],
> -               const char * const names[], const bool *ctx)
> +static int vp_find_vqs_intx(struct virtio_device *vdev, struct virtio_vq=
_config *cfg)
>  {
>         struct virtio_pci_device *vp_dev =3D to_vp_device(vdev);
> +       struct virtqueue **vqs =3D cfg->vqs;
> +       unsigned int nvqs =3D cfg->nvqs;
>         int i, err, queue_idx =3D 0;
>
>         vp_dev->vqs =3D kcalloc(nvqs, sizeof(*vp_dev->vqs), GFP_KERNEL);
> @@ -374,13 +372,13 @@ static int vp_find_vqs_intx(struct virtio_device *v=
dev, unsigned int nvqs,
>         vp_dev->intx_enabled =3D 1;
>         vp_dev->per_vq_vectors =3D false;
>         for (i =3D 0; i < nvqs; ++i) {
> -               if (!names[i]) {
> +               if (!cfg->names[i]) {
>                         vqs[i] =3D NULL;
>                         continue;
>                 }
> -               vqs[i] =3D vp_setup_vq(vdev, queue_idx++, callbacks[i], n=
ames[i],
> -                                    ctx ? ctx[i] : false,
> -                                    VIRTIO_MSI_NO_VECTOR);
> +
> +               cfg->cfg_idx =3D i;
> +               vqs[i] =3D vp_setup_vq(vdev, queue_idx++, cfg, VIRTIO_MSI=
_NO_VECTOR);
>                 if (IS_ERR(vqs[i])) {
>                         err =3D PTR_ERR(vqs[i]);
>                         goto out_del_vqs;
> @@ -394,26 +392,23 @@ static int vp_find_vqs_intx(struct virtio_device *v=
dev, unsigned int nvqs,
>  }
>
>  /* the config->find_vqs() implementation */
> -int vp_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
> -               struct virtqueue *vqs[], vq_callback_t *callbacks[],
> -               const char * const names[], const bool *ctx,
> -               struct irq_affinity *desc)
> +int vp_find_vqs(struct virtio_device *vdev, struct virtio_vq_config *cfg=
)
>  {
>         int err;
>
>         /* Try MSI-X with one vector per queue. */
> -       err =3D vp_find_vqs_msix(vdev, nvqs, vqs, callbacks, names, true,=
 ctx, desc);
> +       err =3D vp_find_vqs_msix(vdev, cfg, true);
>         if (!err)
>                 return 0;
>         /* Fallback: MSI-X with one vector for config, one shared for que=
ues. */
> -       err =3D vp_find_vqs_msix(vdev, nvqs, vqs, callbacks, names, false=
, ctx, desc);
> +       err =3D vp_find_vqs_msix(vdev, cfg, false);
>         if (!err)
>                 return 0;
>         /* Is there an interrupt? If not give up. */
>         if (!(to_vp_device(vdev)->pci_dev->irq))
>                 return err;
>         /* Finally fall back to regular interrupts. */
> -       return vp_find_vqs_intx(vdev, nvqs, vqs, callbacks, names, ctx);
> +       return vp_find_vqs_intx(vdev, cfg);
>  }
>
>  const char *vp_bus_name(struct virtio_device *vdev)
> diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_p=
ci_common.h
> index 4b773bd7c58c..12b171364e54 100644
> --- a/drivers/virtio/virtio_pci_common.h
> +++ b/drivers/virtio/virtio_pci_common.h
> @@ -79,9 +79,7 @@ struct virtio_pci_device {
>         struct virtqueue *(*setup_vq)(struct virtio_pci_device *vp_dev,
>                                       struct virtio_pci_vq_info *info,
>                                       unsigned int idx,
> -                                     void (*callback)(struct virtqueue *=
vq),
> -                                     const char *name,
> -                                     bool ctx,
> +                                     struct virtio_vq_config *vq_cfg,
>                                       u16 msix_vec);
>         void (*del_vq)(struct virtio_pci_vq_info *info);
>
> @@ -109,10 +107,7 @@ bool vp_notify(struct virtqueue *vq);
>  /* the config->del_vqs() implementation */
>  void vp_del_vqs(struct virtio_device *vdev);
>  /* the config->find_vqs() implementation */
> -int vp_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
> -               struct virtqueue *vqs[], vq_callback_t *callbacks[],
> -               const char * const names[], const bool *ctx,
> -               struct irq_affinity *desc);
> +int vp_find_vqs(struct virtio_device *vdev, struct virtio_vq_config *cfg=
);
>  const char *vp_bus_name(struct virtio_device *vdev);
>
>  /* Setup the affinity for a virtqueue:
> diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_p=
ci_legacy.c
> index d9cbb02b35a1..508a31a81499 100644
> --- a/drivers/virtio/virtio_pci_legacy.c
> +++ b/drivers/virtio/virtio_pci_legacy.c
> @@ -110,11 +110,10 @@ static u16 vp_config_vector(struct virtio_pci_devic=
e *vp_dev, u16 vector)
>  static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
>                                   struct virtio_pci_vq_info *info,
>                                   unsigned int index,
> -                                 void (*callback)(struct virtqueue *vq),
> -                                 const char *name,
> -                                 bool ctx,
> +                                 struct virtio_vq_config *cfg,
>                                   u16 msix_vec)
>  {
> +       struct transport_vq_config tp_cfg =3D {};
>         struct virtqueue *vq;
>         u16 num;
>         int err;
> @@ -127,11 +126,14 @@ static struct virtqueue *setup_vq(struct virtio_pci=
_device *vp_dev,
>
>         info->msix_vector =3D msix_vec;
>
> +       tp_cfg.num =3D num;
> +       tp_cfg.vring_align =3D VIRTIO_PCI_VRING_ALIGN;
> +       tp_cfg.weak_barriers =3D true;
> +       tp_cfg.may_reduce_num =3D false;
> +       tp_cfg.notify =3D vp_notify;
> +
>         /* create the vring */
> -       vq =3D vring_create_virtqueue(index, num,
> -                                   VIRTIO_PCI_VRING_ALIGN, &vp_dev->vdev=
,
> -                                   true, false, ctx,
> -                                   vp_notify, callback, name);
> +       vq =3D vring_create_virtqueue(&vp_dev->vdev, index, &tp_cfg, cfg)=
;
>         if (!vq)
>                 return ERR_PTR(-ENOMEM);
>
> diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_p=
ci_modern.c
> index ee6a386d250b..9caca1eeb726 100644
> --- a/drivers/virtio/virtio_pci_modern.c
> +++ b/drivers/virtio/virtio_pci_modern.c
> @@ -336,13 +336,12 @@ static bool vp_notify_with_data(struct virtqueue *v=
q)
>  static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
>                                   struct virtio_pci_vq_info *info,
>                                   unsigned int index,
> -                                 void (*callback)(struct virtqueue *vq),
> -                                 const char *name,
> -                                 bool ctx,
> +                                 struct virtio_vq_config *cfg,
>                                   u16 msix_vec)
>  {
>
>         struct virtio_pci_modern_device *mdev =3D &vp_dev->mdev;
> +       struct transport_vq_config tp_cfg =3D {};
>         bool (*notify)(struct virtqueue *vq);
>         struct virtqueue *vq;
>         u16 num;
> @@ -363,11 +362,14 @@ static struct virtqueue *setup_vq(struct virtio_pci=
_device *vp_dev,
>
>         info->msix_vector =3D msix_vec;
>
> +       tp_cfg.num =3D num;
> +       tp_cfg.vring_align =3D SMP_CACHE_BYTES;
> +       tp_cfg.weak_barriers =3D true;
> +       tp_cfg.may_reduce_num =3D true;
> +       tp_cfg.notify =3D notify;
> +
>         /* create the vring */
> -       vq =3D vring_create_virtqueue(index, num,
> -                                   SMP_CACHE_BYTES, &vp_dev->vdev,
> -                                   true, true, ctx,
> -                                   notify, callback, name);
> +       vq =3D vring_create_virtqueue(&vp_dev->vdev, index, &tp_cfg, cfg)=
;
>         if (!vq)
>                 return ERR_PTR(-ENOMEM);
>
> @@ -390,15 +392,11 @@ static struct virtqueue *setup_vq(struct virtio_pci=
_device *vp_dev,
>         return ERR_PTR(err);
>  }
>
> -static int vp_modern_find_vqs(struct virtio_device *vdev, unsigned int n=
vqs,
> -                             struct virtqueue *vqs[],
> -                             vq_callback_t *callbacks[],
> -                             const char * const names[], const bool *ctx=
,
> -                             struct irq_affinity *desc)
> +static int vp_modern_find_vqs(struct virtio_device *vdev, struct virtio_=
vq_config *cfg)
>  {
>         struct virtio_pci_device *vp_dev =3D to_vp_device(vdev);
>         struct virtqueue *vq;
> -       int rc =3D vp_find_vqs(vdev, nvqs, vqs, callbacks, names, ctx, de=
sc);
> +       int rc =3D vp_find_vqs(vdev, cfg);
>
>         if (rc)
>                 return rc;
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 5bea25167259..5652ff91c6f9 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -2726,43 +2726,34 @@ static struct virtqueue *__vring_new_virtqueue(un=
signed int index,
>         return &vq->vq;
>  }
>
> -struct virtqueue *vring_create_virtqueue(
> -       unsigned int index,
> -       unsigned int num,
> -       unsigned int vring_align,
> -       struct virtio_device *vdev,
> -       bool weak_barriers,
> -       bool may_reduce_num,
> -       bool context,
> -       bool (*notify)(struct virtqueue *),
> -       void (*callback)(struct virtqueue *),
> -       const char *name)
> +struct virtqueue *vring_create_virtqueue(struct virtio_device *vdev,
> +                                        unsigned int index,
> +                                        struct transport_vq_config *tp_c=
fg,
> +                                        struct virtio_vq_config *cfg)
>  {
> +       struct device *dma_dev;
> +       unsigned int num;
> +       unsigned int vring_align;
> +       bool weak_barriers;
> +       bool may_reduce_num;
> +       bool context;
> +       bool (*notify)(struct virtqueue *_);
> +       void (*callback)(struct virtqueue *_);
> +       const char *name;
>
> -       if (virtio_has_feature(vdev, VIRTIO_F_RING_PACKED))
> -               return vring_create_virtqueue_packed(index, num, vring_al=
ign,
> -                               vdev, weak_barriers, may_reduce_num,
> -                               context, notify, callback, name, vdev->de=
v.parent);
> +       dma_dev =3D tp_cfg->dma_dev;
> +       if (!dma_dev)
> +               dma_dev  =3D vdev->dev.parent;

Nit: This seems suboptimal than using "?:" ?

>
> -       return vring_create_virtqueue_split(index, num, vring_align,
> -                       vdev, weak_barriers, may_reduce_num,
> -                       context, notify, callback, name, vdev->dev.parent=
);
> -}
> -EXPORT_SYMBOL_GPL(vring_create_virtqueue);
> +       num            =3D tp_cfg->num;
> +       vring_align    =3D tp_cfg->vring_align;
> +       weak_barriers  =3D tp_cfg->weak_barriers;
> +       may_reduce_num =3D tp_cfg->may_reduce_num;
> +       notify         =3D tp_cfg->notify;
>
> -struct virtqueue *vring_create_virtqueue_dma(
> -       unsigned int index,
> -       unsigned int num,
> -       unsigned int vring_align,
> -       struct virtio_device *vdev,
> -       bool weak_barriers,
> -       bool may_reduce_num,
> -       bool context,
> -       bool (*notify)(struct virtqueue *),
> -       void (*callback)(struct virtqueue *),
> -       const char *name,
> -       struct device *dma_dev)
> -{
> +       name     =3D cfg->names[cfg->cfg_idx];
> +       callback =3D cfg->callbacks[cfg->cfg_idx];
> +       context  =3D cfg->ctx ? cfg->ctx[cfg->cfg_idx] : false;
>
>         if (virtio_has_feature(vdev, VIRTIO_F_RING_PACKED))
>                 return vring_create_virtqueue_packed(index, num, vring_al=
ign,
> @@ -2773,7 +2764,7 @@ struct virtqueue *vring_create_virtqueue_dma(
>                         vdev, weak_barriers, may_reduce_num,
>                         context, notify, callback, name, dma_dev);
>  }
> -EXPORT_SYMBOL_GPL(vring_create_virtqueue_dma);
> +EXPORT_SYMBOL_GPL(vring_create_virtqueue);
>
>  /**
>   * virtqueue_resize - resize the vring of vq
> diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
> index 8d63e5923d24..dd58d23f711e 100644
> --- a/drivers/virtio/virtio_vdpa.c
> +++ b/drivers/virtio/virtio_vdpa.c
> @@ -147,7 +147,7 @@ virtio_vdpa_setup_vq(struct virtio_device *vdev, unsi=
gned int index,
>  {
>         struct virtio_vdpa_device *vd_dev =3D to_virtio_vdpa_device(vdev)=
;
>         struct vdpa_device *vdpa =3D vd_get_vdpa(vdev);
> -       struct device *dma_dev;
> +       struct transport_vq_config tp_cfg =3D {};
>         const struct vdpa_config_ops *ops =3D vdpa->config;
>         struct virtio_vdpa_vq_info *info;
>         bool (*notify)(struct virtqueue *vq) =3D virtio_vdpa_notify;
> @@ -199,12 +199,17 @@ virtio_vdpa_setup_vq(struct virtio_device *vdev, un=
signed int index,
>         align =3D ops->get_vq_align(vdpa);
>
>         if (ops->get_vq_dma_dev)
> -               dma_dev =3D ops->get_vq_dma_dev(vdpa, index);
> +               tp_cfg.dma_dev =3D ops->get_vq_dma_dev(vdpa, index);
>         else
> -               dma_dev =3D vdpa_get_dma_dev(vdpa);
> -       vq =3D vring_create_virtqueue_dma(index, max_num, align, vdev,
> -                                       true, may_reduce_num, ctx,
> -                                       notify, callback, name, dma_dev);
> +               tp_cfg.dma_dev =3D vdpa_get_dma_dev(vdpa);
> +
> +       tp_cfg.num =3D max_num;
> +       tp_cfg.vring_align =3D align;
> +       tp_cfg.weak_barriers =3D true;
> +       tp_cfg.may_reduce_num =3D may_reduce_num;
> +       tp_cfg.notify =3D notify;
> +
> +       vq =3D vring_create_virtqueue(vdev, index, &tp_cfg, cfg);
>         if (!vq) {
>                 err =3D -ENOMEM;
>                 goto error_new_virtqueue;
> @@ -353,11 +358,8 @@ create_affinity_masks(unsigned int nvecs, struct irq=
_affinity *affd)
>         return masks;
>  }
>
> -static int virtio_vdpa_find_vqs(struct virtio_device *vdev, unsigned int=
 nvqs,
> -                               struct virtqueue *vqs[],
> -                               vq_callback_t *callbacks[],
> -                               const char * const names[],
> -                               const bool *ctx,
> +static int virtio_vdpa_find_vqs(struct virtio_device *vdev,
> +                               struct virtio_vq_config *cfg,
>                                 struct irq_affinity *desc)
>  {
>         struct virtio_vdpa_device *vd_dev =3D to_virtio_vdpa_device(vdev)=
;
> @@ -367,6 +369,8 @@ static int virtio_vdpa_find_vqs(struct virtio_device =
*vdev, unsigned int nvqs,
>         struct cpumask *masks;
>         struct vdpa_callback cb;
>         bool has_affinity =3D desc && ops->set_vq_affinity;
> +       struct virtqueue **vqs =3D cfg->vqs;
> +       unsigned int nvqs =3D cfg->nvqs;
>         int i, err, queue_idx =3D 0;
>
>         if (has_affinity) {
> @@ -376,14 +380,13 @@ static int virtio_vdpa_find_vqs(struct virtio_devic=
e *vdev, unsigned int nvqs,
>         }
>
>         for (i =3D 0; i < nvqs; ++i) {
> -               if (!names[i]) {
> +               if (!cfg->names[i]) {
>                         vqs[i] =3D NULL;
>                         continue;
>                 }
>
> -               vqs[i] =3D virtio_vdpa_setup_vq(vdev, queue_idx++,
> -                                             callbacks[i], names[i], ctx=
 ?
> -                                             ctx[i] : false);
> +               cfg->cfg_idx =3D i;
> +               vqs[i] =3D virtio_vdpa_setup_vq(vdev, queue_idx++, cfg);
>                 if (IS_ERR(vqs[i])) {
>                         err =3D PTR_ERR(vqs[i]);
>                         goto err_setup_vq;
> diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.=
h
> index 2b3438de2c4d..e2c72e125dae 100644
> --- a/include/linux/virtio_config.h
> +++ b/include/linux/virtio_config.h
> @@ -94,6 +94,20 @@ typedef void vq_callback_t(struct virtqueue *);
>   *     If disable_vq_and_reset is set, then enable_vq_after_reset must a=
lso be
>   *     set.
>   */
> +
> +struct virtio_vq_config {
> +       unsigned int nvqs;
> +
> +       /* the vq index may not eq to the cfg index of the other array it=
ems */

What does this mean?

> +       unsigned int cfg_idx;
> +
> +       struct virtqueue **vqs;
> +       vq_callback_t **callbacks;
> +       const char *const *names;
> +       const bool *ctx;
> +       struct irq_affinity *desc;
> +};
> +
>  struct virtio_config_ops {
>         void (*get)(struct virtio_device *vdev, unsigned offset,
>                     void *buf, unsigned len);
> @@ -103,10 +117,7 @@ struct virtio_config_ops {
>         u8 (*get_status)(struct virtio_device *vdev);
>         void (*set_status)(struct virtio_device *vdev, u8 status);
>         void (*reset)(struct virtio_device *vdev);
> -       int (*find_vqs)(struct virtio_device *, unsigned nvqs,
> -                       struct virtqueue *vqs[], vq_callback_t *callbacks=
[],
> -                       const char * const names[], const bool *ctx,
> -                       struct irq_affinity *desc);
> +       int (*find_vqs)(struct virtio_device *vdev, struct virtio_vq_conf=
ig *cfg);
>         void (*del_vqs)(struct virtio_device *);
>         void (*synchronize_cbs)(struct virtio_device *);
>         u64 (*get_features)(struct virtio_device *vdev);
> @@ -213,8 +224,14 @@ struct virtqueue *virtio_find_single_vq(struct virti=
o_device *vdev,
>         vq_callback_t *callbacks[] =3D { c };
>         const char *names[] =3D { n };
>         struct virtqueue *vq;
> -       int err =3D vdev->config->find_vqs(vdev, 1, &vq, callbacks, names=
, NULL,
> -                                        NULL);
> +       struct virtio_vq_config cfg =3D {};
> +
> +       cfg.nvqs =3D 1;
> +       cfg.vqs =3D &vq;
> +       cfg.callbacks =3D callbacks;
> +       cfg.names =3D names;
> +
> +       int err =3D vdev->config->find_vqs(vdev, &cfg);
>         if (err < 0)
>                 return ERR_PTR(err);
>         return vq;
> @@ -226,7 +243,15 @@ int virtio_find_vqs(struct virtio_device *vdev, unsi=
gned nvqs,
>                         const char * const names[],
>                         struct irq_affinity *desc)
>  {
> -       return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, =
NULL, desc);
> +       struct virtio_vq_config cfg =3D {};
> +
> +       cfg.nvqs =3D nvqs;
> +       cfg.vqs =3D vqs;
> +       cfg.callbacks =3D callbacks;
> +       cfg.names =3D names;
> +       cfg.desc =3D desc;
> +
> +       return vdev->config->find_vqs(vdev, &cfg);
>  }
>
>  static inline
> @@ -235,8 +260,16 @@ int virtio_find_vqs_ctx(struct virtio_device *vdev, =
unsigned nvqs,
>                         const char * const names[], const bool *ctx,
>                         struct irq_affinity *desc)
>  {
> -       return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, =
ctx,
> -                                     desc);
> +       struct virtio_vq_config cfg =3D {};
> +
> +       cfg.nvqs =3D nvqs;
> +       cfg.vqs =3D vqs;
> +       cfg.callbacks =3D callbacks;
> +       cfg.names =3D names;
> +       cfg.ctx =3D ctx;
> +       cfg.desc =3D desc;
> +
> +       return vdev->config->find_vqs(vdev, &cfg);
>  }
>
>  /**
> diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
> index 9b33df741b63..0de46ed17cc0 100644
> --- a/include/linux/virtio_ring.h
> +++ b/include/linux/virtio_ring.h
> @@ -5,6 +5,7 @@
>  #include <asm/barrier.h>
>  #include <linux/irqreturn.h>
>  #include <uapi/linux/virtio_ring.h>
> +#include <linux/virtio_config.h>
>
>  /*
>   * Barriers in virtio are tricky.  Non-SMP virtio guests can't assume
> @@ -60,38 +61,25 @@ struct virtio_device;
>  struct virtqueue;
>  struct device;
>
> +struct transport_vq_config {

To reduce the confusion, let's rename this as "vq_transport_config"

Thanks


