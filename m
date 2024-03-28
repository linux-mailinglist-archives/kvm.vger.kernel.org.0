Return-Path: <kvm+bounces-12970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3726688F7FC
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 07:35:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59FF01C23E76
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 06:35:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D936B2C853;
	Thu, 28 Mar 2024 06:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Gx6M8A98"
X-Original-To: kvm@vger.kernel.org
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F235221101;
	Thu, 28 Mar 2024 06:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711607710; cv=none; b=Jb9EtbitrRifwOLXhto6Y5EsCWZHYJpM8vRo2nwc0u+vTGmAXIurl7XfPFazW0Id3DrmresiCWntnLKDCmxH46Tuc5eC/IT/jM9Nh5x40o5fggyBNhSasnWQyJCMVW+asvNHFkVPsEFeO0vuLjg4dPGzHjoSfWfW+nITmEF8MIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711607710; c=relaxed/simple;
	bh=w8NumfAWHDquyftnrJyuTMMt07v/mX85Ax1aX+IiYxo=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To:
	 Content-Type; b=oSHBmtcApqoHyKccJlA7E09DQU656NyUsr96YSS94I/LGhIGCJ/PGbp5eA6bZisEt+9NgEtuwGu6lznn1D+rYCJjTA7GCUNjpiqlsLt3q8ezGH9YG5od8Zv6Vw6dnv/1NHXQ9jygfDv6LBdehlunxtvnqcZ7+N71SZ1KExsbmzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Gx6M8A98; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1711607701; h=Message-ID:Subject:Date:From:To:Content-Type;
	bh=AFuyXJD4EPP6A1C3zL28ndSw7/vrrrf8ABzYPUddxfw=;
	b=Gx6M8A98tpfzYouf79ZGtuSZK2BwC1w6uXREQR7Q8uiMfN7+rf4ky/tejvxxM/yxnMQ1wT4nCPS/2WUz/KD5ICH1fIrGSGpN/gUSAoOvflDR4VYJp9sp7/zLCF5Gyxa8tqXo17ByN9mIVDNXBzmuhfED4j1ssx+v8JhrEjbrq2E=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R221e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0W3RJooo_1711607699;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W3RJooo_1711607699)
          by smtp.aliyun-inc.com;
          Thu, 28 Mar 2024 14:34:59 +0800
Message-ID: <1711607685.4591289-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost v6 3/6] virtio: find_vqs: pass struct instead of multi parameters
Date: Thu, 28 Mar 2024 14:34:45 +0800
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
 <20240327095741.88135-4-xuanzhuo@linux.alibaba.com>
 <CACGkMEsjsSt1H0WqLzrwDt7d2kb4VGJMMw=KTF=RrR-FOa6YKQ@mail.gmail.com>
In-Reply-To: <CACGkMEsjsSt1H0WqLzrwDt7d2kb4VGJMMw=KTF=RrR-FOa6YKQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

On Thu, 28 Mar 2024 12:26:46 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Wed, Mar 27, 2024 at 5:57=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba=
.com> wrote:
> >
> > Now, we pass multi parameters to find_vqs. These parameters
> > may work for transport or work for vring.
> >
> > And find_vqs has multi implements in many places:
> >
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
> > Because the vp_modern_create_avq() use the "const char *names[]",
> > and the virtio_uml.c changes the name in the subsequent commit, so
> > change the "names" inside the virtio_vq_config from "const char *const
> > *names" to "const char **names".
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > Acked-by: Johannes Berg <johannes@sipsolutions.net>
> > Reviewed-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>
> > ---
> >  arch/um/drivers/virtio_uml.c             | 22 +++----
> >  drivers/platform/mellanox/mlxbf-tmfifo.c | 13 ++--
> >  drivers/remoteproc/remoteproc_virtio.c   | 25 ++++----
> >  drivers/s390/virtio/virtio_ccw.c         | 28 ++++-----
> >  drivers/virtio/virtio_mmio.c             | 26 ++++----
> >  drivers/virtio/virtio_pci_common.c       | 57 ++++++++----------
> >  drivers/virtio/virtio_pci_common.h       |  9 +--
> >  drivers/virtio/virtio_pci_legacy.c       | 11 ++--
> >  drivers/virtio/virtio_pci_modern.c       | 32 ++++++----
> >  drivers/virtio/virtio_vdpa.c             | 33 +++++-----
> >  include/linux/virtio_config.h            | 76 ++++++++++++++++++------
> >  11 files changed, 175 insertions(+), 157 deletions(-)
> >
> > diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
> > index 773f9fc4d582..adc619362cc0 100644
> > --- a/arch/um/drivers/virtio_uml.c
> > +++ b/arch/um/drivers/virtio_uml.c
> > @@ -937,8 +937,8 @@ static int vu_setup_vq_call_fd(struct virtio_uml_de=
vice *vu_dev,
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
> > @@ -953,10 +953,12 @@ static struct virtqueue *vu_setup_vq(struct virti=
o_device *vdev,
> >                 goto error_kzalloc;
> >         }
> >         snprintf(info->name, sizeof(info->name), "%s.%d-%s", pdev->name,
> > -                pdev->id, name);
> > +                pdev->id, cfg->names[index]);
> >
> >         vq =3D vring_create_virtqueue(index, num, PAGE_SIZE, vdev, true=
, true,
> > -                                   ctx, vu_notify, callback, info->nam=
e);
> > +                                   cfg->ctx ? cfg->ctx[index] : false,
> > +                                   vu_notify,
> > +                                   cfg->callbacks[index], info->name);
> >         if (!vq) {
> >                 rc =3D -ENOMEM;
> >                 goto error_create;
> > @@ -1013,12 +1015,11 @@ static struct virtqueue *vu_setup_vq(struct vir=
tio_device *vdev,
> >         return ERR_PTR(rc);
> >  }
> >
> > -static int vu_find_vqs(struct virtio_device *vdev, unsigned nvqs,
> > -                      struct virtqueue *vqs[], vq_callback_t *callback=
s[],
> > -                      const char * const names[], const bool *ctx,
> > -                      struct irq_affinity *desc)
> > +static int vu_find_vqs(struct virtio_device *vdev, struct virtio_vq_co=
nfig *cfg)
> >  {
> >         struct virtio_uml_device *vu_dev =3D to_virtio_uml_device(vdev);
> > +       struct virtqueue **vqs =3D cfg->vqs;
> > +       unsigned int nvqs =3D cfg->nvqs;
> >         struct virtqueue *vq;
> >         int i, rc;
> >
> > @@ -1031,13 +1032,12 @@ static int vu_find_vqs(struct virtio_device *vd=
ev, unsigned nvqs,
> >                 return rc;
> >
> >         for (i =3D 0; i < nvqs; ++i) {
> > -               if (!names[i]) {
> > +               if (!cfg->names[i]) {
> >                         rc =3D -EINVAL;
> >                         goto error_setup;
> >                 }
> >
> > -               vqs[i] =3D vu_setup_vq(vdev, i, callbacks[i], names[i],
> > -                                    ctx ? ctx[i] : false);
> > +               vqs[i] =3D vu_setup_vq(vdev, i, cfg);
> >                 if (IS_ERR(vqs[i])) {
> >                         rc =3D PTR_ERR(vqs[i]);
> >                         goto error_setup;
> > diff --git a/drivers/platform/mellanox/mlxbf-tmfifo.c b/drivers/platfor=
m/mellanox/mlxbf-tmfifo.c
> > index b8d1e32e97eb..4252388f52a2 100644
> > --- a/drivers/platform/mellanox/mlxbf-tmfifo.c
> > +++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
> > @@ -1056,15 +1056,12 @@ static void mlxbf_tmfifo_virtio_del_vqs(struct =
virtio_device *vdev)
> >
> >  /* Create and initialize the virtual queues. */
> >  static int mlxbf_tmfifo_virtio_find_vqs(struct virtio_device *vdev,
> > -                                       unsigned int nvqs,
> > -                                       struct virtqueue *vqs[],
> > -                                       vq_callback_t *callbacks[],
> > -                                       const char * const names[],
> > -                                       const bool *ctx,
> > -                                       struct irq_affinity *desc)
> > +                                       struct virtio_vq_config *cfg)
> >  {
> >         struct mlxbf_tmfifo_vdev *tm_vdev =3D mlxbf_vdev_to_tmfifo(vdev=
);
> > +       struct virtqueue **vqs =3D cfg->vqs;
> >         struct mlxbf_tmfifo_vring *vring;
> > +       unsigned int nvqs =3D cfg->nvqs;
> >         struct virtqueue *vq;
> >         int i, ret, size;
> >
> > @@ -1072,7 +1069,7 @@ static int mlxbf_tmfifo_virtio_find_vqs(struct vi=
rtio_device *vdev,
> >                 return -EINVAL;
> >
> >         for (i =3D 0; i < nvqs; ++i) {
> > -               if (!names[i]) {
> > +               if (!cfg->names[i]) {
> >                         ret =3D -EINVAL;
> >                         goto error;
> >                 }
> > @@ -1084,7 +1081,7 @@ static int mlxbf_tmfifo_virtio_find_vqs(struct vi=
rtio_device *vdev,
> >                 vq =3D vring_new_virtqueue(i, vring->num, vring->align,=
 vdev,
> >                                          false, false, vring->va,
> >                                          mlxbf_tmfifo_virtio_notify,
> > -                                        callbacks[i], names[i]);
> > +                                        cfg->callbacks[i], cfg->names[=
i]);
> >                 if (!vq) {
> >                         dev_err(&vdev->dev, "vring_new_virtqueue failed=
\n");
> >                         ret =3D -ENOMEM;
> > diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remotepro=
c/remoteproc_virtio.c
> > index 8fb5118b6953..489fea1d41c0 100644
> > --- a/drivers/remoteproc/remoteproc_virtio.c
> > +++ b/drivers/remoteproc/remoteproc_virtio.c
> > @@ -102,8 +102,7 @@ EXPORT_SYMBOL(rproc_vq_interrupt);
> >
> >  static struct virtqueue *rp_find_vq(struct virtio_device *vdev,
> >                                     unsigned int id,
> > -                                   void (*callback)(struct virtqueue *=
vq),
> > -                                   const char *name, bool ctx)
> > +                                   struct virtio_vq_config *cfg)
> >  {
> >         struct rproc_vdev *rvdev =3D vdev_to_rvdev(vdev);
> >         struct rproc *rproc =3D vdev_to_rproc(vdev);
> > @@ -140,10 +139,12 @@ static struct virtqueue *rp_find_vq(struct virtio=
_device *vdev,
> >          * Create the new vq, and tell virtio we're not interested in
> >          * the 'weak' smp barriers, since we're talking with a real dev=
ice.
> >          */
> > -       vq =3D vring_new_virtqueue(id, num, rvring->align, vdev, false,=
 ctx,
> > -                                addr, rproc_virtio_notify, callback, n=
ame);
> > +       vq =3D vring_new_virtqueue(id, num, rvring->align, vdev, false,
> > +                                cfg->ctx ? cfg->ctx[id] : false,
> > +                                addr, rproc_virtio_notify, cfg->callba=
cks[id],
> > +                                cfg->names[id]);
> >         if (!vq) {
> > -               dev_err(dev, "vring_new_virtqueue %s failed\n", name);
> > +               dev_err(dev, "vring_new_virtqueue %s failed\n", cfg->na=
mes[id]);
> >                 rproc_free_vring(rvring);
> >                 return ERR_PTR(-ENOMEM);
> >         }
> > @@ -177,23 +178,19 @@ static void rproc_virtio_del_vqs(struct virtio_de=
vice *vdev)
> >         __rproc_virtio_del_vqs(vdev);
> >  }
> >
> > -static int rproc_virtio_find_vqs(struct virtio_device *vdev, unsigned =
int nvqs,
> > -                                struct virtqueue *vqs[],
> > -                                vq_callback_t *callbacks[],
> > -                                const char * const names[],
> > -                                const bool * ctx,
> > -                                struct irq_affinity *desc)
> > +static int rproc_virtio_find_vqs(struct virtio_device *vdev, struct vi=
rtio_vq_config *cfg)
> >  {
> > +       struct virtqueue **vqs =3D cfg->vqs;
> > +       unsigned int nvqs =3D cfg->nvqs;
> >         int i, ret;
> >
> >         for (i =3D 0; i < nvqs; ++i) {
> > -               if (!names[i]) {
> > +               if (!cfg->names[i]) {
> >                         ret =3D -EINVAL;
> >                         goto error;
> >                 }
> >
> > -               vqs[i] =3D rp_find_vq(vdev, i, callbacks[i], names[i],
> > -                                   ctx ? ctx[i] : false);
> > +               vqs[i] =3D rp_find_vq(vdev, i, cfg);
> >                 if (IS_ERR(vqs[i])) {
> >                         ret =3D PTR_ERR(vqs[i]);
> >                         goto error;
> > diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/vir=
tio_ccw.c
> > index 508154705554..3c78122f00f5 100644
> > --- a/drivers/s390/virtio/virtio_ccw.c
> > +++ b/drivers/s390/virtio/virtio_ccw.c
> > @@ -499,9 +499,8 @@ static void virtio_ccw_del_vqs(struct virtio_device=
 *vdev)
> >  }
> >
> >  static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vde=
v,
> > -                                            int i, vq_callback_t *call=
back,
> > -                                            const char *name, bool ctx,
> > -                                            struct ccw1 *ccw)
> > +                                            int i, struct ccw1 *ccw,
> > +                                            struct virtio_vq_config *c=
fg)
> >  {
> >         struct virtio_ccw_device *vcdev =3D to_vc_device(vdev);
> >         bool (*notify)(struct virtqueue *vq);
> > @@ -538,8 +537,11 @@ static struct virtqueue *virtio_ccw_setup_vq(struc=
t virtio_device *vdev,
> >         }
> >         may_reduce =3D vcdev->revision > 0;
> >         vq =3D vring_create_virtqueue(i, info->num, KVM_VIRTIO_CCW_RING=
_ALIGN,
> > -                                   vdev, true, may_reduce, ctx,
> > -                                   notify, callback, name);
> > +                                   vdev, true, may_reduce,
> > +                                   cfg->ctx ? cfg->ctx[i] : false,
> > +                                   notify,
> > +                                   cfg->callbacks[i],
> > +                                   cfg->names[i]);
> >
> >         if (!vq) {
> >                 /* For now, we fail if we can't get the requested size.=
 */
> > @@ -650,15 +652,13 @@ static int virtio_ccw_register_adapter_ind(struct=
 virtio_ccw_device *vcdev,
> >         return ret;
> >  }
> >
> > -static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nv=
qs,
> > -                              struct virtqueue *vqs[],
> > -                              vq_callback_t *callbacks[],
> > -                              const char * const names[],
> > -                              const bool *ctx,
> > -                              struct irq_affinity *desc)
> > +static int virtio_ccw_find_vqs(struct virtio_device *vdev,
> > +                              struct virtio_vq_config *cfg)
> >  {
> >         struct virtio_ccw_device *vcdev =3D to_vc_device(vdev);
> > +       struct virtqueue **vqs =3D cfg->vqs;
> >         unsigned long *indicatorp =3D NULL;
> > +       unsigned int nvqs =3D cfg->nvqs;
> >         int ret, i;
> >         struct ccw1 *ccw;
> >
> > @@ -667,14 +667,12 @@ static int virtio_ccw_find_vqs(struct virtio_devi=
ce *vdev, unsigned nvqs,
> >                 return -ENOMEM;
> >
> >         for (i =3D 0; i < nvqs; ++i) {
> > -               if (!names[i]) {
> > +               if (!cfg->names[i]) {
> >                         ret =3D -EINVAL;
> >                         goto out;
> >                 }
> >
> > -               vqs[i] =3D virtio_ccw_setup_vq(vdev, i, callbacks[i],
> > -                                            names[i], ctx ? ctx[i] : f=
alse,
> > -                                            ccw);
> > +               vqs[i] =3D virtio_ccw_setup_vq(vdev, i, ccw, cfg);
> >                 if (IS_ERR(vqs[i])) {
> >                         ret =3D PTR_ERR(vqs[i]);
> >                         vqs[i] =3D NULL;
> > diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> > index 82ee4a288728..7f0fdc3f51cb 100644
> > --- a/drivers/virtio/virtio_mmio.c
> > +++ b/drivers/virtio/virtio_mmio.c
> > @@ -370,8 +370,7 @@ static void vm_synchronize_cbs(struct virtio_device=
 *vdev)
> >  }
> >
> >  static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsig=
ned int index,
> > -                                 void (*callback)(struct virtqueue *vq=
),
> > -                                 const char *name, bool ctx)
> > +                                    struct virtio_vq_config *cfg)
> >  {
> >         struct virtio_mmio_device *vm_dev =3D to_virtio_mmio_device(vde=
v);
> >         bool (*notify)(struct virtqueue *vq);
> > @@ -386,9 +385,6 @@ static struct virtqueue *vm_setup_vq(struct virtio_=
device *vdev, unsigned int in
> >         else
> >                 notify =3D vm_notify;
> >
> > -       if (!name)
> > -               return NULL;
>
> Nit: This seems to belong to patch 2.

YES.

Will fix in next version.

Thanks.


>
> Acked-by: Jason Wang <jasowang@redhat.com>
>
> Thanks
>

