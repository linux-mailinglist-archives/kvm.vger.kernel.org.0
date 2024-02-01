Return-Path: <kvm+bounces-7651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09E5A844F56
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 04:07:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B62D8292A85
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 03:07:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11F363A8C9;
	Thu,  1 Feb 2024 03:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Q8SQApPZ"
X-Original-To: kvm@vger.kernel.org
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADE3101D2;
	Thu,  1 Feb 2024 03:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706756818; cv=none; b=IWDN5v9xL5eo3MCB6tiXHsWFNNti7U65wTBPNVgAT50YDjQ4oJcRFETg84rIxli/qEvzCqVp0kkhhtw5rz+D/nEoLbeT+giVAHD9W2gcKKaDisVxsB5iUJNTb9d58fDhCawsZo8GR3G6Y6Sn6S9bR73HQhDROgIW903BQBqeaT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706756818; c=relaxed/simple;
	bh=Mo3mQIa4FnyVO3DqyF4rmJLSmQ9+LmwDbRfw3hP+Ij4=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To:
	 Content-Type; b=NdW2fjAgiL2DXE0l5C7pMRbQUyWac5I9SyUeQ5Dv1h2nAaVbrQWgOAB4joQgUUDh7pp5K+4PCUzjEfrEOVJc9RvR1gZsWBSDRVjcDok0nfiMO15sePUMaMbf909jFY+e00tz9CVoTUcYaJPnWc3KA9c6CMJjYm9hh7BJ3PtcFos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Q8SQApPZ; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1706756812; h=Message-ID:Subject:Date:From:To:Content-Type;
	bh=OIzQSRKNh1ZV+Nnz1+bU4a7ItleWsZPQWVeR5Bih22A=;
	b=Q8SQApPZUV0QhWOS7bGJ+5rqJw3Jyxd8vCspg+dQMy12/pFhH/c2HmASkRi8264i1fqDOIFhYrtvjTUjnFSwD8vUvhVl23xNKNNXvfiytPzZV5wBfsfmTKvk0NbvwcKu/0CrYmEt8ck6mJqSnLQrjGP+ZoKcDHpBf0mNi7+qO2M=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=36;SR=0;TI=SMTPD_---0W.mW2hm_1706756809;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W.mW2hm_1706756809)
          by smtp.aliyun-inc.com;
          Thu, 01 Feb 2024 11:06:50 +0800
Message-ID: <1706756442.5524123-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost 07/17] virtio: find_vqs: pass struct instead of multi parameters
Date: Thu, 1 Feb 2024 11:00:42 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: Jason Wang <jasowang@redhat.com>
Cc: virtualization@lists.linux.dev,
 Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,
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
 Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 John Fastabend <john.fastabend@gmail.com>,
 Benjamin Berg <benjamin.berg@intel.com>,
 Yang Li <yang.lee@linux.alibaba.com>,
 linux-um@lists.infradead.org,
 netdev@vger.kernel.org,
 platform-driver-x86@vger.kernel.org,
 linux-remoteproc@vger.kernel.org,
 linux-s390@vger.kernel.org,
 kvm@vger.kernel.org,
 bpf@vger.kernel.org
References: <20240130114224.86536-1-xuanzhuo@linux.alibaba.com>
 <20240130114224.86536-8-xuanzhuo@linux.alibaba.com>
 <CACGkMEvb4N8kthr4qWXrLOh9v422OYhrYU6hQejusw-e5EacPw@mail.gmail.com>
In-Reply-To: <CACGkMEvb4N8kthr4qWXrLOh9v422OYhrYU6hQejusw-e5EacPw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

On Wed, 31 Jan 2024 17:12:34 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Tue, Jan 30, 2024 at 7:42=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba=
.com> wrote:
> >
> > Now, we pass multi parameters to find_vqs. These parameters
> > may work for transport or work for vring.
> >
> > And find_vqs has multi implements in many places:
> >
> > But every time,
> >  arch/um/drivers/virtio_uml.c
> >  drivers/platform/mellanox/mlxbf-tmfifo.c
> >  drivers/remoteproc/remoteproc_virtio.c
> >  drivers/s390/virtio/virtio_ccw.c
> >  drivers/virtio/virtio_mmio.c
> >  drivers/virtio/virtio_pci_legacy.c
> >  drivers/virtio/virtio_pci_modern.c
> >  drivers/virtio/virtio_vdpa.c
> >
> > Every time, we try to add a new parameter, that is difficult.
> > We must change every find_vqs implement.
> >
> > One the other side, if we want to pass a parameter to vring,
> > we must change the call path from transport to vring.
> > Too many functions need to be changed.
> >
> > So it is time to refactor the find_vqs. We pass a structure
> > cfg to find_vqs(), that will be passed to vring by transport.
> >
> > And squish the parameters from transport to a structure.
>=20
> The patch did more than what is described here, it also switch to use
> a structure for vring_create_virtqueue() etc.
>=20
> Is it better to split?

Sure.

>=20
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >  arch/um/drivers/virtio_uml.c             | 29 +++++++-----
> >  drivers/platform/mellanox/mlxbf-tmfifo.c | 14 +++---
> >  drivers/remoteproc/remoteproc_virtio.c   | 28 ++++++-----
> >  drivers/s390/virtio/virtio_ccw.c         | 33 ++++++-------
> >  drivers/virtio/virtio_mmio.c             | 30 ++++++------
> >  drivers/virtio/virtio_pci_common.c       | 59 +++++++++++-------------
> >  drivers/virtio/virtio_pci_common.h       |  9 +---
> >  drivers/virtio/virtio_pci_legacy.c       | 16 ++++---
> >  drivers/virtio/virtio_pci_modern.c       | 24 +++++-----
> >  drivers/virtio/virtio_ring.c             | 59 ++++++++++--------------
> >  drivers/virtio/virtio_vdpa.c             | 33 +++++++------
> >  include/linux/virtio_config.h            | 51 ++++++++++++++++----
> >  include/linux/virtio_ring.h              | 40 ++++++----------
> >  13 files changed, 217 insertions(+), 208 deletions(-)
> >
> > diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
> > index 8adca2000e51..161bac67e454 100644
> > --- a/arch/um/drivers/virtio_uml.c
> > +++ b/arch/um/drivers/virtio_uml.c
> > @@ -937,11 +937,12 @@ static int vu_setup_vq_call_fd(struct virtio_uml_=
device *vu_dev,
> >  }
> >
> >  static struct virtqueue *vu_setup_vq(struct virtio_device *vdev,
> > -                                    unsigned index, vq_callback_t *cal=
lback,
> > -                                    const char *name, bool ctx)
> > +                                    unsigned index,
> > +                                    struct virtio_vq_config *cfg)
> >  {
> >         struct virtio_uml_device *vu_dev =3D to_virtio_uml_device(vdev);
> >         struct platform_device *pdev =3D vu_dev->pdev;
> > +       struct transport_vq_config tp_cfg =3D {};
>=20
> Nit: what did "tp" short for?

tp: transport

Any better?


>=20
> >         struct virtio_uml_vq_info *info;
> >         struct virtqueue *vq;
> >         int num =3D MAX_SUPPORTED_QUEUE_SIZE;
> > @@ -953,10 +954,15 @@ static struct virtqueue *vu_setup_vq(struct virti=
o_device *vdev,
> >                 goto error_kzalloc;
> >         }
> >         snprintf(info->name, sizeof(info->name), "%s.%d-%s", pdev->name,
> > -                pdev->id, name);
> > +                pdev->id, cfg->names[cfg->cfg_idx]);
> >
> > -               dev_err(dev, "vring_new_virtqueue %s failed\n", name);

[...]


> > -       if (virtio_has_feature(vdev, VIRTIO_F_RING_PACKED))
> > -               return vring_create_virtqueue_packed(index, num, vring_=
align,
> > -                               vdev, weak_barriers, may_reduce_num,
> > -                               context, notify, callback, name, vdev->=
dev.parent);
> > +       dma_dev =3D tp_cfg->dma_dev;
> > +       if (!dma_dev)
> > +               dma_dev  =3D vdev->dev.parent;
>=20
> Nit: This seems suboptimal than using "?:" ?

YES


>=20
> >
> > -       return vring_create_virtqueue_split(index, num, vring_align,
> > -                       vdev, weak_barriers, may_reduce_num,
> > -                       context, notify, callback, name, vdev->dev.pare=
nt);
> > -}

[...]

> >                         err =3D PTR_ERR(vqs[i]);
> >                         goto err_setup_vq;
> > diff --git a/include/linux/virtio_config.h b/include/linux/virtio_confi=
g.h
> > index 2b3438de2c4d..e2c72e125dae 100644
> > --- a/include/linux/virtio_config.h
> > +++ b/include/linux/virtio_config.h
> > @@ -94,6 +94,20 @@ typedef void vq_callback_t(struct virtqueue *);
> >   *     If disable_vq_and_reset is set, then enable_vq_after_reset must=
 also be
> >   *     set.
> >   */
> > +
> > +struct virtio_vq_config {
> > +       unsigned int nvqs;
> > +
> > +       /* the vq index may not eq to the cfg index of the other array =
items */
>=20
> What does this mean?


When we read from the names/ctx/callbacks array, we can use the vq index,
because some names maybe null, the vq index may not equal to the array inde=
x.
We must save a cfg idx for the names/ctx/callbacks array.



	for (i =3D 0; i < nvqs; ++i) {
		if (!cfg->names[i]) {
			vqs[i] =3D NULL;
			continue;
		}

		cfg->cfg_idx =3D i;
		vqs[i] =3D vp_setup_vq(vdev, queue_idx++, cfg, VIRTIO_MSI_NO_VECTOR);
		if (IS_ERR(vqs[i])) {
			err =3D PTR_ERR(vqs[i]);
			goto out_del_vqs;
		}
	}

notice "i" and "queue_idx"

Thanks.


>=20
> > +       unsigned int cfg_idx;
> > +
> > +       struct virtqueue **vqs;
> > +       vq_callback_t **callbacks;
> > +       const char *const *names;
> > +       const bool *ctx;
> > +       struct irq_affinity *desc;
> > +};
> > +
> >  struct virtio_config_ops {
> >         void (*get)(struct virtio_device *vdev, unsigned offset,
> >                     void *buf, unsigned len);

[...]

> > diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
> > index 9b33df741b63..0de46ed17cc0 100644
> > --- a/include/linux/virtio_ring.h
> > +++ b/include/linux/virtio_ring.h
> > @@ -5,6 +5,7 @@
> >  #include <asm/barrier.h>
> >  #include <linux/irqreturn.h>
> >  #include <uapi/linux/virtio_ring.h>
> > +#include <linux/virtio_config.h>
> >
> >  /*
> >   * Barriers in virtio are tricky.  Non-SMP virtio guests can't assume
> > @@ -60,38 +61,25 @@ struct virtio_device;
> >  struct virtqueue;
> >  struct device;
> >
> > +struct transport_vq_config {
>=20
> To reduce the confusion, let's rename this as "vq_transport_config"

OK

Thanks.


>=20
> Thanks
>=20

