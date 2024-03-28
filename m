Return-Path: <kvm+bounces-12958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17EDD88F655
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 05:27:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0EAA29A08B
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 04:27:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A78228DD1;
	Thu, 28 Mar 2024 04:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RTsUdyMs"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0FBF513
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 04:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711600024; cv=none; b=rhRa/nqLVol1gTFsmB9xMdpPkr8fMsV09+i7SczhY+Cso7PKLLP5Smj9zs4RNzDM2dLo8K7bhIYgtwfPIN1TWTlCi8fZEVw+eVV+5WTGnTpYIB8xkJ03VGHhdCv2j8+jK18SSJrxXmPyNO+d2XHe3bpfkcbAqbSH0xVyOhbqR1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711600024; c=relaxed/simple;
	bh=V1TeWDPOVbi8XNG7BBlZBYnqezU/wbyVcdrwXTWRhZM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BDWrXVVq0cPxTczq/5jjwA+0uLUxtfubjMC/irCYbcZ3NUKdho6dXMUcJcZCErOTjrQfU1CEWt9UTpRVm0VycnvXKleKG/bew07RSYKvkXtXY7P/xP+9K2l8x6SXXkSco74glHpq7pM16OTcGYpwxtK13gE5g4qRXAeEIpB2hQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RTsUdyMs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711600021;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3SfgLisNStUkpL4/V6qUfqYcUK7r3WF6z2nhXinKyAE=;
	b=RTsUdyMsCs68DUC2IoWX9Qm2Wrel5MvFp1n77UmUZAuxe2xOAdhqOItVa2dNQ7JI5JJ542
	FL9BRO6hmfBcjsKzWSxLwkrdrV2qloWX4mP6ZGqAbkvMtLslplqD1pBoGcKj2dP/fPeM02
	ZgPE/mNJBwLJZLxf1o3UCrexiux17w0=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-Ejd3RyuKPKm6CuymbfVeqQ-1; Thu, 28 Mar 2024 00:26:59 -0400
X-MC-Unique: Ejd3RyuKPKm6CuymbfVeqQ-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-29f96135606so519792a91.1
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 21:26:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711600018; x=1712204818;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3SfgLisNStUkpL4/V6qUfqYcUK7r3WF6z2nhXinKyAE=;
        b=reKvK//746d4jDUiyB8rWJIfIX6t8JUtjYOj6ghUYH/JM+8U3tJFpv5AexLtDh0w2Z
         J1d4zUyJEW8Z80jtkBqhEYXnLsGIgR6MX7UZzPd7oAdZaHtflyqutBrX5uKWgBC48TyQ
         movWLxDToAZraGB1poWIrVzdYSgNa+2HBiNBS9z2+wmLJLWU0wWr+IOpfiyUh9osmdCU
         jwcke3W1grmAk1yiMU+n1aOZswCoavo+59i3fb2yaxUIgxcQ64QbGhi17qLSH524TsjY
         twk1F5JCqra3coyjyKUyP9rV+CcVukLkH1YT5NoXNWp+kG2bhhAFqWphKZmXq5IHjeU0
         voFg==
X-Forwarded-Encrypted: i=1; AJvYcCUNgmAT6el79J5lVyRz2yWbK5Ln8i5x1hpJNq6tAsB9lu7SvVUhM8MnI2OmHFbNTbJJFTkCqxc72o+BneykY5c81X8z
X-Gm-Message-State: AOJu0YyfCA/vgqtBsUPhWXMrpYxBg7YN5DG67DsVmToJTjfuooPKrwrX
	kqFWyG6bg+vcvnxrV8Vj/7F1fFduXafeTIDLanMzPsg1QTTl1RnGrMeAF/r3YiNNv3v3F7jdngg
	lvtzlwJR59o2mVdPiQDGW7M4iKWcRMmTsZYyQs1XelJjDBHC/IPSQ9QJa7HVGPgHHxDVaTov0J6
	Fl1FV0E8thaaptmDRKvmdL3f8p
X-Received: by 2002:a17:90b:4d83:b0:29f:7fad:ba50 with SMTP id oj3-20020a17090b4d8300b0029f7fadba50mr1630086pjb.8.1711600018366;
        Wed, 27 Mar 2024 21:26:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGLTQfG299/HqpEtGrNTw08EIXybr7q+G4vYYS+05a+GZRb6/LrSoP/PYCD7ozfs32X4g9+jl1RSeS++34vS+Q=
X-Received: by 2002:a17:90b:4d83:b0:29f:7fad:ba50 with SMTP id
 oj3-20020a17090b4d8300b0029f7fadba50mr1630066pjb.8.1711600017946; Wed, 27 Mar
 2024 21:26:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240327095741.88135-1-xuanzhuo@linux.alibaba.com> <20240327095741.88135-4-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20240327095741.88135-4-xuanzhuo@linux.alibaba.com>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 28 Mar 2024 12:26:46 +0800
Message-ID: <CACGkMEsjsSt1H0WqLzrwDt7d2kb4VGJMMw=KTF=RrR-FOa6YKQ@mail.gmail.com>
Subject: Re: [PATCH vhost v6 3/6] virtio: find_vqs: pass struct instead of
 multi parameters
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: virtualization@lists.linux.dev, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Hans de Goede <hdegoede@redhat.com>, =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
	Vadim Pasternak <vadimp@nvidia.com>, Bjorn Andersson <andersson@kernel.org>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, Cornelia Huck <cohuck@redhat.com>, 
	Halil Pasic <pasic@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	David Hildenbrand <david@redhat.com>, linux-um@lists.infradead.org, 
	platform-driver-x86@vger.kernel.org, linux-remoteproc@vger.kernel.org, 
	linux-s390@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 27, 2024 at 5:57=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba.c=
om> wrote:
>
> Now, we pass multi parameters to find_vqs. These parameters
> may work for transport or work for vring.
>
> And find_vqs has multi implements in many places:
>
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
> Because the vp_modern_create_avq() use the "const char *names[]",
> and the virtio_uml.c changes the name in the subsequent commit, so
> change the "names" inside the virtio_vq_config from "const char *const
> *names" to "const char **names".
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
> Reviewed-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>
> ---
>  arch/um/drivers/virtio_uml.c             | 22 +++----
>  drivers/platform/mellanox/mlxbf-tmfifo.c | 13 ++--
>  drivers/remoteproc/remoteproc_virtio.c   | 25 ++++----
>  drivers/s390/virtio/virtio_ccw.c         | 28 ++++-----
>  drivers/virtio/virtio_mmio.c             | 26 ++++----
>  drivers/virtio/virtio_pci_common.c       | 57 ++++++++----------
>  drivers/virtio/virtio_pci_common.h       |  9 +--
>  drivers/virtio/virtio_pci_legacy.c       | 11 ++--
>  drivers/virtio/virtio_pci_modern.c       | 32 ++++++----
>  drivers/virtio/virtio_vdpa.c             | 33 +++++-----
>  include/linux/virtio_config.h            | 76 ++++++++++++++++++------
>  11 files changed, 175 insertions(+), 157 deletions(-)
>
> diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
> index 773f9fc4d582..adc619362cc0 100644
> --- a/arch/um/drivers/virtio_uml.c
> +++ b/arch/um/drivers/virtio_uml.c
> @@ -937,8 +937,8 @@ static int vu_setup_vq_call_fd(struct virtio_uml_devi=
ce *vu_dev,
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
> @@ -953,10 +953,12 @@ static struct virtqueue *vu_setup_vq(struct virtio_=
device *vdev,
>                 goto error_kzalloc;
>         }
>         snprintf(info->name, sizeof(info->name), "%s.%d-%s", pdev->name,
> -                pdev->id, name);
> +                pdev->id, cfg->names[index]);
>
>         vq =3D vring_create_virtqueue(index, num, PAGE_SIZE, vdev, true, =
true,
> -                                   ctx, vu_notify, callback, info->name)=
;
> +                                   cfg->ctx ? cfg->ctx[index] : false,
> +                                   vu_notify,
> +                                   cfg->callbacks[index], info->name);
>         if (!vq) {
>                 rc =3D -ENOMEM;
>                 goto error_create;
> @@ -1013,12 +1015,11 @@ static struct virtqueue *vu_setup_vq(struct virti=
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
>         struct virtqueue *vq;
>         int i, rc;
>
> @@ -1031,13 +1032,12 @@ static int vu_find_vqs(struct virtio_device *vdev=
, unsigned nvqs,
>                 return rc;
>
>         for (i =3D 0; i < nvqs; ++i) {
> -               if (!names[i]) {
> +               if (!cfg->names[i]) {
>                         rc =3D -EINVAL;
>                         goto error_setup;
>                 }
>
> -               vqs[i] =3D vu_setup_vq(vdev, i, callbacks[i], names[i],
> -                                    ctx ? ctx[i] : false);
> +               vqs[i] =3D vu_setup_vq(vdev, i, cfg);
>                 if (IS_ERR(vqs[i])) {
>                         rc =3D PTR_ERR(vqs[i]);
>                         goto error_setup;
> diff --git a/drivers/platform/mellanox/mlxbf-tmfifo.c b/drivers/platform/=
mellanox/mlxbf-tmfifo.c
> index b8d1e32e97eb..4252388f52a2 100644
> --- a/drivers/platform/mellanox/mlxbf-tmfifo.c
> +++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
> @@ -1056,15 +1056,12 @@ static void mlxbf_tmfifo_virtio_del_vqs(struct vi=
rtio_device *vdev)
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
> @@ -1072,7 +1069,7 @@ static int mlxbf_tmfifo_virtio_find_vqs(struct virt=
io_device *vdev,
>                 return -EINVAL;
>
>         for (i =3D 0; i < nvqs; ++i) {
> -               if (!names[i]) {
> +               if (!cfg->names[i]) {
>                         ret =3D -EINVAL;
>                         goto error;
>                 }
> @@ -1084,7 +1081,7 @@ static int mlxbf_tmfifo_virtio_find_vqs(struct virt=
io_device *vdev,
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
> index 8fb5118b6953..489fea1d41c0 100644
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
> @@ -140,10 +139,12 @@ static struct virtqueue *rp_find_vq(struct virtio_d=
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
> +                                cfg->ctx ? cfg->ctx[id] : false,
> +                                addr, rproc_virtio_notify, cfg->callback=
s[id],
> +                                cfg->names[id]);
>         if (!vq) {
> -               dev_err(dev, "vring_new_virtqueue %s failed\n", name);
> +               dev_err(dev, "vring_new_virtqueue %s failed\n", cfg->name=
s[id]);
>                 rproc_free_vring(rvring);
>                 return ERR_PTR(-ENOMEM);
>         }
> @@ -177,23 +178,19 @@ static void rproc_virtio_del_vqs(struct virtio_devi=
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
>         int i, ret;
>
>         for (i =3D 0; i < nvqs; ++i) {
> -               if (!names[i]) {
> +               if (!cfg->names[i]) {
>                         ret =3D -EINVAL;
>                         goto error;
>                 }
>
> -               vqs[i] =3D rp_find_vq(vdev, i, callbacks[i], names[i],
> -                                   ctx ? ctx[i] : false);
> +               vqs[i] =3D rp_find_vq(vdev, i, cfg);
>                 if (IS_ERR(vqs[i])) {
>                         ret =3D PTR_ERR(vqs[i]);
>                         goto error;
> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virti=
o_ccw.c
> index 508154705554..3c78122f00f5 100644
> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -499,9 +499,8 @@ static void virtio_ccw_del_vqs(struct virtio_device *=
vdev)
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
>         bool (*notify)(struct virtqueue *vq);
> @@ -538,8 +537,11 @@ static struct virtqueue *virtio_ccw_setup_vq(struct =
virtio_device *vdev,
>         }
>         may_reduce =3D vcdev->revision > 0;
>         vq =3D vring_create_virtqueue(i, info->num, KVM_VIRTIO_CCW_RING_A=
LIGN,
> -                                   vdev, true, may_reduce, ctx,
> -                                   notify, callback, name);
> +                                   vdev, true, may_reduce,
> +                                   cfg->ctx ? cfg->ctx[i] : false,
> +                                   notify,
> +                                   cfg->callbacks[i],
> +                                   cfg->names[i]);
>
>         if (!vq) {
>                 /* For now, we fail if we can't get the requested size. *=
/
> @@ -650,15 +652,13 @@ static int virtio_ccw_register_adapter_ind(struct v=
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
>         int ret, i;
>         struct ccw1 *ccw;
>
> @@ -667,14 +667,12 @@ static int virtio_ccw_find_vqs(struct virtio_device=
 *vdev, unsigned nvqs,
>                 return -ENOMEM;
>
>         for (i =3D 0; i < nvqs; ++i) {
> -               if (!names[i]) {
> +               if (!cfg->names[i]) {
>                         ret =3D -EINVAL;
>                         goto out;
>                 }
>
> -               vqs[i] =3D virtio_ccw_setup_vq(vdev, i, callbacks[i],
> -                                            names[i], ctx ? ctx[i] : fal=
se,
> -                                            ccw);
> +               vqs[i] =3D virtio_ccw_setup_vq(vdev, i, ccw, cfg);
>                 if (IS_ERR(vqs[i])) {
>                         ret =3D PTR_ERR(vqs[i]);
>                         vqs[i] =3D NULL;
> diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> index 82ee4a288728..7f0fdc3f51cb 100644
> --- a/drivers/virtio/virtio_mmio.c
> +++ b/drivers/virtio/virtio_mmio.c
> @@ -370,8 +370,7 @@ static void vm_synchronize_cbs(struct virtio_device *=
vdev)
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
>         bool (*notify)(struct virtqueue *vq);
> @@ -386,9 +385,6 @@ static struct virtqueue *vm_setup_vq(struct virtio_de=
vice *vdev, unsigned int in
>         else
>                 notify =3D vm_notify;
>
> -       if (!name)
> -               return NULL;

Nit: This seems to belong to patch 2.

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


