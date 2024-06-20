Return-Path: <kvm+bounces-20054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 21C5E90FFD6
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 11:02:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 731BBB2371D
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 09:02:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82C3519AD75;
	Thu, 20 Jun 2024 09:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="mLv+FsMj"
X-Original-To: kvm@vger.kernel.org
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74EBB46426;
	Thu, 20 Jun 2024 09:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718874108; cv=none; b=XyUasdmS3Zc+KKZv0hFHUQW/0fayWO1uxpcLSWRR3HpukukYiABEA2p281iP5Yj+FGuoCVulhiBilI68Z2i482E6exMPGtgJw6Xg8ONxHOROykFq7+Wl5rsk7XqrN5TTLi2wFbXNMCFpyhuWbkBiQGK31u34ox7KgUjh/qqz8Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718874108; c=relaxed/simple;
	bh=uR0v8bOgR8kkooU9mIklBzXFmpY/u4HyXGds+tN1lg0=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To:
	 Content-Type; b=Kzk7BSoArIT9FGarazVNMCBMjP9Vl71RKErUjBCRFY7g84zWWVe7ZRpPGr95sScr/fLtrglJ8BGoRLj6t9/dh/VBXoRKch2R/wXYWtGhTa6/Sevq7ihkWN0uDWj+31oN52K+OdRktNZffXijbTS1wAAxjXuUNGXwq5lUhvLUlg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=mLv+FsMj; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1718874102; h=Message-ID:Subject:Date:From:To:Content-Type;
	bh=xzt0uApgMzPjrmok63Y5cryMlzTfX937U/FbuXovYno=;
	b=mLv+FsMjRm1rU96Wq6IKvmi5fa+Q6RWhwsNlG1wWTu16Fkl5GOr1Hu+qalegwl0Vh//BVArOvb8zpqtHvvJHe8gszwsnuO0tqEGvcOSkNHf8y0EGApjjD65fNgyip7F8/40ZC9V629Wqyqoc+7bIt6aburFLJnNfr+/+guSc8Gs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R511e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037067109;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0W8rH.QZ_1718874100;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W8rH.QZ_1718874100)
          by smtp.aliyun-inc.com;
          Thu, 20 Jun 2024 17:01:40 +0800
Message-ID: <1718874049.457552-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost v9 3/6] virtio: find_vqs: pass struct instead of multi parameters
Date: Thu, 20 Jun 2024 17:00:49 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
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
 David Hildenbrand <david@redhat.com>,
 Jason Wang <jasowang@redhat.com>,
 linux-um@lists.infradead.org,
 platform-driver-x86@vger.kernel.org,
 linux-remoteproc@vger.kernel.org,
 linux-s390@vger.kernel.org,
 kvm@vger.kernel.org
References: <20240424091533.86949-1-xuanzhuo@linux.alibaba.com>
 <20240424091533.86949-4-xuanzhuo@linux.alibaba.com>
 <20240620034823-mutt-send-email-mst@kernel.org>
In-Reply-To: <20240620034823-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

On Thu, 20 Jun 2024 03:56:34 -0400, "Michael S. Tsirkin" <mst@redhat.com> w=
rote:
> On Wed, Apr 24, 2024 at 05:15:30PM +0800, Xuan Zhuo wrote:
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
> > Reviewed-by: Ilpo J=E9=8B=9Cvinen <ilpo.jarvinen@linux.intel.com>
> > Acked-by: Jason Wang <jasowang@redhat.com>
> > Acked-by: Eric Farman <farman@linux.ibm.com> # s390
> > Acked-by: Halil Pasic <pasic@linux.ibm.com>
> > ---
> >  arch/um/drivers/virtio_uml.c             | 22 +++----
> >  drivers/platform/mellanox/mlxbf-tmfifo.c | 13 ++--
> >  drivers/remoteproc/remoteproc_virtio.c   | 25 ++++----
> >  drivers/s390/virtio/virtio_ccw.c         | 28 ++++-----
> >  drivers/virtio/virtio_mmio.c             | 23 ++++---
> >  drivers/virtio/virtio_pci_common.c       | 57 ++++++++----------
> >  drivers/virtio/virtio_pci_common.h       |  9 +--
> >  drivers/virtio/virtio_pci_legacy.c       | 11 ++--
> >  drivers/virtio/virtio_pci_modern.c       | 32 ++++++----
> >  drivers/virtio/virtio_vdpa.c             | 33 +++++-----
> >  include/linux/virtio_config.h            | 76 ++++++++++++++++++------
> >  11 files changed, 175 insertions(+), 154 deletions(-)
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
> > -				     unsigned index, vq_callback_t *callback,
> > -				     const char *name, bool ctx)
> > +				     unsigned index,
> > +				     struct virtio_vq_config *cfg)
> >  {
> >  	struct virtio_uml_device *vu_dev =3D to_virtio_uml_device(vdev);
> >  	struct platform_device *pdev =3D vu_dev->pdev;
> > @@ -953,10 +953,12 @@ static struct virtqueue *vu_setup_vq(struct virti=
o_device *vdev,
> >  		goto error_kzalloc;
> >  	}
> >  	snprintf(info->name, sizeof(info->name), "%s.%d-%s", pdev->name,
> > -		 pdev->id, name);
> > +		 pdev->id, cfg->names[index]);
> >
> >  	vq =3D vring_create_virtqueue(index, num, PAGE_SIZE, vdev, true, true,
> > -				    ctx, vu_notify, callback, info->name);
> > +				    cfg->ctx ? cfg->ctx[index] : false,
> > +				    vu_notify,
> > +				    cfg->callbacks[index], info->name);
> >  	if (!vq) {
> >  		rc =3D -ENOMEM;
> >  		goto error_create;
> > @@ -1013,12 +1015,11 @@ static struct virtqueue *vu_setup_vq(struct vir=
tio_device *vdev,
> >  	return ERR_PTR(rc);
> >  }
> >
> > -static int vu_find_vqs(struct virtio_device *vdev, unsigned nvqs,
> > -		       struct virtqueue *vqs[], vq_callback_t *callbacks[],
> > -		       const char * const names[], const bool *ctx,
> > -		       struct irq_affinity *desc)
> > +static int vu_find_vqs(struct virtio_device *vdev, struct virtio_vq_co=
nfig *cfg)
> >  {
> >  	struct virtio_uml_device *vu_dev =3D to_virtio_uml_device(vdev);
> > +	struct virtqueue **vqs =3D cfg->vqs;
> > +	unsigned int nvqs =3D cfg->nvqs;
> >  	struct virtqueue *vq;
> >  	int i, rc;
> >
> > @@ -1031,13 +1032,12 @@ static int vu_find_vqs(struct virtio_device *vd=
ev, unsigned nvqs,
> >  		return rc;
> >
> >  	for (i =3D 0; i < nvqs; ++i) {
> > -		if (!names[i]) {
> > +		if (!cfg->names[i]) {
> >  			rc =3D -EINVAL;
> >  			goto error_setup;
> >  		}
> >
> > -		vqs[i] =3D vu_setup_vq(vdev, i, callbacks[i], names[i],
> > -				     ctx ? ctx[i] : false);
> > +		vqs[i] =3D vu_setup_vq(vdev, i, cfg);
> >  		if (IS_ERR(vqs[i])) {
> >  			rc =3D PTR_ERR(vqs[i]);
> >  			goto error_setup;
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
> > -					unsigned int nvqs,
> > -					struct virtqueue *vqs[],
> > -					vq_callback_t *callbacks[],
> > -					const char * const names[],
> > -					const bool *ctx,
> > -					struct irq_affinity *desc)
> > +					struct virtio_vq_config *cfg)
> >  {
> >  	struct mlxbf_tmfifo_vdev *tm_vdev =3D mlxbf_vdev_to_tmfifo(vdev);
> > +	struct virtqueue **vqs =3D cfg->vqs;
> >  	struct mlxbf_tmfifo_vring *vring;
> > +	unsigned int nvqs =3D cfg->nvqs;
> >  	struct virtqueue *vq;
> >  	int i, ret, size;
> >
> > @@ -1072,7 +1069,7 @@ static int mlxbf_tmfifo_virtio_find_vqs(struct vi=
rtio_device *vdev,
> >  		return -EINVAL;
> >
> >  	for (i =3D 0; i < nvqs; ++i) {
> > -		if (!names[i]) {
> > +		if (!cfg->names[i]) {
> >  			ret =3D -EINVAL;
> >  			goto error;
> >  		}
> > @@ -1084,7 +1081,7 @@ static int mlxbf_tmfifo_virtio_find_vqs(struct vi=
rtio_device *vdev,
> >  		vq =3D vring_new_virtqueue(i, vring->num, vring->align, vdev,
> >  					 false, false, vring->va,
> >  					 mlxbf_tmfifo_virtio_notify,
> > -					 callbacks[i], names[i]);
> > +					 cfg->callbacks[i], cfg->names[i]);
> >  		if (!vq) {
> >  			dev_err(&vdev->dev, "vring_new_virtqueue failed\n");
> >  			ret =3D -ENOMEM;
> > diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remotepro=
c/remoteproc_virtio.c
> > index 7f58634fcc41..bbde11287f8a 100644
> > --- a/drivers/remoteproc/remoteproc_virtio.c
> > +++ b/drivers/remoteproc/remoteproc_virtio.c
> > @@ -102,8 +102,7 @@ EXPORT_SYMBOL(rproc_vq_interrupt);
> >
> >  static struct virtqueue *rp_find_vq(struct virtio_device *vdev,
> >  				    unsigned int id,
> > -				    void (*callback)(struct virtqueue *vq),
> > -				    const char *name, bool ctx)
> > +				    struct virtio_vq_config *cfg)
> >  {
> >  	struct rproc_vdev *rvdev =3D vdev_to_rvdev(vdev);
> >  	struct rproc *rproc =3D vdev_to_rproc(vdev);
> > @@ -140,10 +139,12 @@ static struct virtqueue *rp_find_vq(struct virtio=
_device *vdev,
> >  	 * Create the new vq, and tell virtio we're not interested in
> >  	 * the 'weak' smp barriers, since we're talking with a real device.
> >  	 */
> > -	vq =3D vring_new_virtqueue(id, num, rvring->align, vdev, false, ctx,
> > -				 addr, rproc_virtio_notify, callback, name);
> > +	vq =3D vring_new_virtqueue(id, num, rvring->align, vdev, false,
> > +				 cfg->ctx ? cfg->ctx[id] : false,
> > +				 addr, rproc_virtio_notify, cfg->callbacks[id],
> > +				 cfg->names[id]);
> >  	if (!vq) {
> > -		dev_err(dev, "vring_new_virtqueue %s failed\n", name);
> > +		dev_err(dev, "vring_new_virtqueue %s failed\n", cfg->names[id]);
> >  		rproc_free_vring(rvring);
> >  		return ERR_PTR(-ENOMEM);
> >  	}
> > @@ -177,23 +178,19 @@ static void rproc_virtio_del_vqs(struct virtio_de=
vice *vdev)
> >  	__rproc_virtio_del_vqs(vdev);
> >  }
> >
> > -static int rproc_virtio_find_vqs(struct virtio_device *vdev, unsigned =
int nvqs,
> > -				 struct virtqueue *vqs[],
> > -				 vq_callback_t *callbacks[],
> > -				 const char * const names[],
> > -				 const bool * ctx,
> > -				 struct irq_affinity *desc)
> > +static int rproc_virtio_find_vqs(struct virtio_device *vdev, struct vi=
rtio_vq_config *cfg)
> >  {
> > +	struct virtqueue **vqs =3D cfg->vqs;
> > +	unsigned int nvqs =3D cfg->nvqs;
> >  	int i, ret;
> >
> >  	for (i =3D 0; i < nvqs; ++i) {
> > -		if (!names[i]) {
> > +		if (!cfg->names[i]) {
> >  			ret =3D -EINVAL;
> >  			goto error;
> >  		}
> >
> > -		vqs[i] =3D rp_find_vq(vdev, i, callbacks[i], names[i],
> > -				    ctx ? ctx[i] : false);
> > +		vqs[i] =3D rp_find_vq(vdev, i, cfg);
> >  		if (IS_ERR(vqs[i])) {
> >  			ret =3D PTR_ERR(vqs[i]);
> >  			goto error;
> > diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/vir=
tio_ccw.c
> > index 6cdd29952bc0..4d94d20b253a 100644
> > --- a/drivers/s390/virtio/virtio_ccw.c
> > +++ b/drivers/s390/virtio/virtio_ccw.c
> > @@ -536,9 +536,8 @@ static void virtio_ccw_del_vqs(struct virtio_device=
 *vdev)
> >  }
> >
> >  static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vde=
v,
> > -					     int i, vq_callback_t *callback,
> > -					     const char *name, bool ctx,
> > -					     struct ccw1 *ccw)
> > +					     int i, struct ccw1 *ccw,
> > +					     struct virtio_vq_config *cfg)
> >  {
> >  	struct virtio_ccw_device *vcdev =3D to_vc_device(vdev);
> >  	bool (*notify)(struct virtqueue *vq);
> > @@ -576,8 +575,11 @@ static struct virtqueue *virtio_ccw_setup_vq(struc=
t virtio_device *vdev,
> >  	}
> >  	may_reduce =3D vcdev->revision > 0;
> >  	vq =3D vring_create_virtqueue(i, info->num, KVM_VIRTIO_CCW_RING_ALIGN,
> > -				    vdev, true, may_reduce, ctx,
> > -				    notify, callback, name);
> > +				    vdev, true, may_reduce,
> > +				    cfg->ctx ? cfg->ctx[i] : false,
> > +				    notify,
> > +				    cfg->callbacks[i],
> > +				    cfg->names[i]);
> >
> >  	if (!vq) {
> >  		/* For now, we fail if we can't get the requested size. */
> > @@ -687,14 +689,12 @@ static int virtio_ccw_register_adapter_ind(struct=
 virtio_ccw_device *vcdev,
> >  	return ret;
> >  }
> >
> > -static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nv=
qs,
> > -			       struct virtqueue *vqs[],
> > -			       vq_callback_t *callbacks[],
> > -			       const char * const names[],
> > -			       const bool *ctx,
> > -			       struct irq_affinity *desc)
> > +static int virtio_ccw_find_vqs(struct virtio_device *vdev,
> > +			       struct virtio_vq_config *cfg)
> >  {
> >  	struct virtio_ccw_device *vcdev =3D to_vc_device(vdev);
> > +	struct virtqueue **vqs =3D cfg->vqs;
> > +	unsigned int nvqs =3D cfg->nvqs;
> >  	dma64_t *indicatorp =3D NULL;
> >  	int ret, i;
> >  	struct ccw1 *ccw;
> > @@ -704,14 +704,12 @@ static int virtio_ccw_find_vqs(struct virtio_devi=
ce *vdev, unsigned nvqs,
> >  		return -ENOMEM;
> >
> >  	for (i =3D 0; i < nvqs; ++i) {
> > -		if (!names[i]) {
> > +		if (!cfg->names[i]) {
> >  			ret =3D -EINVAL;
> >  			goto out;
> >  		}
> >
> > -		vqs[i] =3D virtio_ccw_setup_vq(vdev, i, callbacks[i],
> > -					     names[i], ctx ? ctx[i] : false,
> > -					     ccw);
> > +		vqs[i] =3D virtio_ccw_setup_vq(vdev, i, ccw, cfg);
> >  		if (IS_ERR(vqs[i])) {
> >  			ret =3D PTR_ERR(vqs[i]);
> >  			vqs[i] =3D NULL;
> > diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> > index c3c8dd282952..4ebb28b6b0ec 100644
> > --- a/drivers/virtio/virtio_mmio.c
> > +++ b/drivers/virtio/virtio_mmio.c
> > @@ -370,8 +370,7 @@ static void vm_synchronize_cbs(struct virtio_device=
 *vdev)
> >  }
> >
> >  static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsig=
ned int index,
> > -				  void (*callback)(struct virtqueue *vq),
> > -				  const char *name, bool ctx)
> > +				     struct virtio_vq_config *cfg)
> >  {
> >  	struct virtio_mmio_device *vm_dev =3D to_virtio_mmio_device(vdev);
> >  	bool (*notify)(struct virtqueue *vq);
> > @@ -411,7 +410,11 @@ static struct virtqueue *vm_setup_vq(struct virtio=
_device *vdev, unsigned int in
> >
> >  	/* Create the vring */
> >  	vq =3D vring_create_virtqueue(index, num, VIRTIO_MMIO_VRING_ALIGN, vd=
ev,
> > -				 true, true, ctx, notify, callback, name);
> > +				    true, true,
> > +				    cfg->ctx ? cfg->ctx[index] : false,
> > +				    notify,
> > +				    cfg->callbacks[index],
> > +				    cfg->names[index]);
> >  	if (!vq) {
> >  		err =3D -ENOMEM;
> >  		goto error_new_virtqueue;
> > @@ -484,15 +487,12 @@ static struct virtqueue *vm_setup_vq(struct virti=
o_device *vdev, unsigned int in
> >  	return ERR_PTR(err);
> >  }
> >
> > -static int vm_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
> > -		       struct virtqueue *vqs[],
> > -		       vq_callback_t *callbacks[],
> > -		       const char * const names[],
> > -		       const bool *ctx,
> > -		       struct irq_affinity *desc)
> > +static int vm_find_vqs(struct virtio_device *vdev, struct virtio_vq_co=
nfig *cfg)
> >  {
> >  	struct virtio_mmio_device *vm_dev =3D to_virtio_mmio_device(vdev);
> >  	int irq =3D platform_get_irq(vm_dev->pdev, 0);
> > +	struct virtqueue **vqs =3D cfg->vqs;
> > +	unsigned int nvqs =3D cfg->nvqs;
> >  	int i, err;
> >
> >  	if (irq < 0)
> > @@ -507,13 +507,12 @@ static int vm_find_vqs(struct virtio_device *vdev=
, unsigned int nvqs,
> >  		enable_irq_wake(irq);
> >
> >  	for (i =3D 0; i < nvqs; ++i) {
> > -		if (!names[i]) {
> > +		if (!cfg->names[i]) {
> >  			vm_del_vqs(vdev);
> >  			return -EINVAL;
> >  		}
> >
> > -		vqs[i] =3D vm_setup_vq(vdev, i, callbacks[i], names[i],
> > -				     ctx ? ctx[i] : false);
> > +		vqs[i] =3D vm_setup_vq(vdev, i, cfg);
> >  		if (IS_ERR(vqs[i])) {
> >  			vm_del_vqs(vdev);
> >  			return PTR_ERR(vqs[i]);
> > diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio=
_pci_common.c
> > index eda71c6e87ee..cb2776e3d0e1 100644
> > --- a/drivers/virtio/virtio_pci_common.c
> > +++ b/drivers/virtio/virtio_pci_common.c
> > @@ -172,9 +172,7 @@ static int vp_request_msix_vectors(struct virtio_de=
vice *vdev, int nvectors,
> >  }
> >
> >  static struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsig=
ned int index,
> > -				     void (*callback)(struct virtqueue *vq),
> > -				     const char *name,
> > -				     bool ctx,
> > +				     struct virtio_vq_config *cfg,
> >  				     u16 msix_vec)
> >  {
> >  	struct virtio_pci_device *vp_dev =3D to_vp_device(vdev);
> > @@ -186,13 +184,12 @@ static struct virtqueue *vp_setup_vq(struct virti=
o_device *vdev, unsigned int in
> >  	if (!info)
> >  		return ERR_PTR(-ENOMEM);
> >
> > -	vq =3D vp_dev->setup_vq(vp_dev, info, index, callback, name, ctx,
> > -			      msix_vec);
> > +	vq =3D vp_dev->setup_vq(vp_dev, info, index, cfg, msix_vec);
> >  	if (IS_ERR(vq))
> >  		goto out_info;
> >
> >  	info->vq =3D vq;
> > -	if (callback) {
> > +	if (cfg->callbacks[index]) {
> >  		spin_lock_irqsave(&vp_dev->lock, flags);
> >  		list_add(&info->node, &vp_dev->virtqueues);
> >  		spin_unlock_irqrestore(&vp_dev->lock, flags);
> > @@ -284,15 +281,15 @@ void vp_del_vqs(struct virtio_device *vdev)
> >  	vp_dev->vqs =3D NULL;
> >  }
> >
> > -static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned int n=
vqs,
> > -		struct virtqueue *vqs[], vq_callback_t *callbacks[],
> > -		const char * const names[], bool per_vq_vectors,
> > -		const bool *ctx,
> > -		struct irq_affinity *desc)
> > +static int vp_find_vqs_msix(struct virtio_device *vdev,
> > +			    struct virtio_vq_config *cfg,
> > +			    bool per_vq_vectors)
> >  {
> >  	struct virtio_pci_device *vp_dev =3D to_vp_device(vdev);
> >  	u16 msix_vec;
> >  	int i, err, nvectors, allocated_vectors;
> > +	struct virtqueue **vqs =3D cfg->vqs;
> > +	unsigned int nvqs =3D cfg->nvqs;
> >
> >  	vp_dev->vqs =3D kcalloc(nvqs, sizeof(*vp_dev->vqs), GFP_KERNEL);
> >  	if (!vp_dev->vqs)
> > @@ -302,7 +299,7 @@ static int vp_find_vqs_msix(struct virtio_device *v=
dev, unsigned int nvqs,
> >  		/* Best option: one for change interrupt, one per vq. */
> >  		nvectors =3D 1;
> >  		for (i =3D 0; i < nvqs; ++i)
> > -			if (callbacks[i])
> > +			if (cfg->callbacks[i])
> >  				++nvectors;
> >  	} else {
> >  		/* Second best: one for change, shared for all vqs. */
> > @@ -310,27 +307,26 @@ static int vp_find_vqs_msix(struct virtio_device =
*vdev, unsigned int nvqs,
> >  	}
> >
> >  	err =3D vp_request_msix_vectors(vdev, nvectors, per_vq_vectors,
> > -				      per_vq_vectors ? desc : NULL);
> > +				      per_vq_vectors ? cfg->desc : NULL);
> >  	if (err)
> >  		goto error_find;
> >
> >  	vp_dev->per_vq_vectors =3D per_vq_vectors;
> >  	allocated_vectors =3D vp_dev->msix_used_vectors;
> >  	for (i =3D 0; i < nvqs; ++i) {
> > -		if (!names[i]) {
> > +		if (!cfg->names[i]) {
> >  			err =3D -EINVAL;
> >  			goto error_find;
> >  		}
> >
> > -		if (!callbacks[i])
> > +		if (!cfg->callbacks[i])
> >  			msix_vec =3D VIRTIO_MSI_NO_VECTOR;
> >  		else if (vp_dev->per_vq_vectors)
> >  			msix_vec =3D allocated_vectors++;
> >  		else
> >  			msix_vec =3D VP_MSIX_VQ_VECTOR;
> > -		vqs[i] =3D vp_setup_vq(vdev, i, callbacks[i], names[i],
> > -				     ctx ? ctx[i] : false,
> > -				     msix_vec);
> > +
> > +		vqs[i] =3D vp_setup_vq(vdev, i, cfg, msix_vec);
> >  		if (IS_ERR(vqs[i])) {
> >  			err =3D PTR_ERR(vqs[i]);
> >  			goto error_find;
> > @@ -343,7 +339,7 @@ static int vp_find_vqs_msix(struct virtio_device *v=
dev, unsigned int nvqs,
> >  		snprintf(vp_dev->msix_names[msix_vec],
> >  			 sizeof *vp_dev->msix_names,
> >  			 "%s-%s",
> > -			 dev_name(&vp_dev->vdev.dev), names[i]);
> > +			 dev_name(&vp_dev->vdev.dev), cfg->names[i]);
> >  		err =3D request_irq(pci_irq_vector(vp_dev->pci_dev, msix_vec),
> >  				  vring_interrupt, 0,
> >  				  vp_dev->msix_names[msix_vec],
> > @@ -358,11 +354,11 @@ static int vp_find_vqs_msix(struct virtio_device =
*vdev, unsigned int nvqs,
> >  	return err;
> >  }
> >
> > -static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned int n=
vqs,
> > -		struct virtqueue *vqs[], vq_callback_t *callbacks[],
> > -		const char * const names[], const bool *ctx)
> > +static int vp_find_vqs_intx(struct virtio_device *vdev, struct virtio_=
vq_config *cfg)
> >  {
> >  	struct virtio_pci_device *vp_dev =3D to_vp_device(vdev);
> > +	struct virtqueue **vqs =3D cfg->vqs;
> > +	unsigned int nvqs =3D cfg->nvqs;
> >  	int i, err;
> >
> >  	vp_dev->vqs =3D kcalloc(nvqs, sizeof(*vp_dev->vqs), GFP_KERNEL);
> > @@ -377,13 +373,11 @@ static int vp_find_vqs_intx(struct virtio_device =
*vdev, unsigned int nvqs,
> >  	vp_dev->intx_enabled =3D 1;
> >  	vp_dev->per_vq_vectors =3D false;
> >  	for (i =3D 0; i < nvqs; ++i) {
> > -		if (!names[i]) {
> > +		if (!cfg->names[i]) {
> >  			err =3D -EINVAL;
> >  			goto out_del_vqs;
> >  		}
> > -		vqs[i] =3D vp_setup_vq(vdev, i, callbacks[i], names[i],
> > -				     ctx ? ctx[i] : false,
> > -				     VIRTIO_MSI_NO_VECTOR);
> > +		vqs[i] =3D vp_setup_vq(vdev, i, cfg, VIRTIO_MSI_NO_VECTOR);
> >  		if (IS_ERR(vqs[i])) {
> >  			err =3D PTR_ERR(vqs[i]);
> >  			goto out_del_vqs;
> > @@ -397,26 +391,23 @@ static int vp_find_vqs_intx(struct virtio_device =
*vdev, unsigned int nvqs,
> >  }
> >
> >  /* the config->find_vqs() implementation */
> > -int vp_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
> > -		struct virtqueue *vqs[], vq_callback_t *callbacks[],
> > -		const char * const names[], const bool *ctx,
> > -		struct irq_affinity *desc)
> > +int vp_find_vqs(struct virtio_device *vdev, struct virtio_vq_config *c=
fg)
> >  {
> >  	int err;
> >
> >  	/* Try MSI-X with one vector per queue. */
> > -	err =3D vp_find_vqs_msix(vdev, nvqs, vqs, callbacks, names, true, ctx=
, desc);
> > +	err =3D vp_find_vqs_msix(vdev, cfg, true);
> >  	if (!err)
> >  		return 0;
> >  	/* Fallback: MSI-X with one vector for config, one shared for queues.=
 */
> > -	err =3D vp_find_vqs_msix(vdev, nvqs, vqs, callbacks, names, false, ct=
x, desc);
> > +	err =3D vp_find_vqs_msix(vdev, cfg, false);
> >  	if (!err)
> >  		return 0;
> >  	/* Is there an interrupt? If not give up. */
> >  	if (!(to_vp_device(vdev)->pci_dev->irq))
> >  		return err;
> >  	/* Finally fall back to regular interrupts. */
> > -	return vp_find_vqs_intx(vdev, nvqs, vqs, callbacks, names, ctx);
> > +	return vp_find_vqs_intx(vdev, cfg);
> >  }
> >
> >  const char *vp_bus_name(struct virtio_device *vdev)
> > diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio=
_pci_common.h
> > index 7fef52bee455..5ba8b82fb765 100644
> > --- a/drivers/virtio/virtio_pci_common.h
> > +++ b/drivers/virtio/virtio_pci_common.h
> > @@ -95,9 +95,7 @@ struct virtio_pci_device {
> >  	struct virtqueue *(*setup_vq)(struct virtio_pci_device *vp_dev,
> >  				      struct virtio_pci_vq_info *info,
> >  				      unsigned int idx,
> > -				      void (*callback)(struct virtqueue *vq),
> > -				      const char *name,
> > -				      bool ctx,
> > +				      struct virtio_vq_config *vq_cfg,
> >  				      u16 msix_vec);
> >  	void (*del_vq)(struct virtio_pci_vq_info *info);
> >
> > @@ -126,10 +124,7 @@ bool vp_notify(struct virtqueue *vq);
> >  /* the config->del_vqs() implementation */
> >  void vp_del_vqs(struct virtio_device *vdev);
> >  /* the config->find_vqs() implementation */
> > -int vp_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
> > -		struct virtqueue *vqs[], vq_callback_t *callbacks[],
> > -		const char * const names[], const bool *ctx,
> > -		struct irq_affinity *desc);
> > +int vp_find_vqs(struct virtio_device *vdev, struct virtio_vq_config *c=
fg);
> >  const char *vp_bus_name(struct virtio_device *vdev);
> >
> >  /* Setup the affinity for a virtqueue:
> > diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio=
_pci_legacy.c
> > index d9cbb02b35a1..a8de653dd7a7 100644
> > --- a/drivers/virtio/virtio_pci_legacy.c
> > +++ b/drivers/virtio/virtio_pci_legacy.c
> > @@ -110,9 +110,7 @@ static u16 vp_config_vector(struct virtio_pci_devic=
e *vp_dev, u16 vector)
> >  static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
> >  				  struct virtio_pci_vq_info *info,
> >  				  unsigned int index,
> > -				  void (*callback)(struct virtqueue *vq),
> > -				  const char *name,
> > -				  bool ctx,
> > +				  struct virtio_vq_config *cfg,
> >  				  u16 msix_vec)
> >  {
> >  	struct virtqueue *vq;
> > @@ -130,8 +128,11 @@ static struct virtqueue *setup_vq(struct virtio_pc=
i_device *vp_dev,
> >  	/* create the vring */
> >  	vq =3D vring_create_virtqueue(index, num,
> >  				    VIRTIO_PCI_VRING_ALIGN, &vp_dev->vdev,
> > -				    true, false, ctx,
> > -				    vp_notify, callback, name);
> > +				    true, false,
> > +				    cfg->ctx ? cfg->ctx[index] : false,
> > +				    vp_notify,
> > +				    cfg->callbacks[index],
> > +				    cfg->names[index]);
> >  	if (!vq)
> >  		return ERR_PTR(-ENOMEM);
> >
> > diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio=
_pci_modern.c
> > index f62b530aa3b5..bcb829ffec64 100644
> > --- a/drivers/virtio/virtio_pci_modern.c
> > +++ b/drivers/virtio/virtio_pci_modern.c
> > @@ -530,9 +530,7 @@ static bool vp_notify_with_data(struct virtqueue *v=
q)
> >  static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
> >  				  struct virtio_pci_vq_info *info,
> >  				  unsigned int index,
> > -				  void (*callback)(struct virtqueue *vq),
> > -				  const char *name,
> > -				  bool ctx,
> > +				  struct virtio_vq_config *cfg,
> >  				  u16 msix_vec)
> >  {
> >
> > @@ -563,8 +561,11 @@ static struct virtqueue *setup_vq(struct virtio_pc=
i_device *vp_dev,
> >  	/* create the vring */
> >  	vq =3D vring_create_virtqueue(index, num,
> >  				    SMP_CACHE_BYTES, &vp_dev->vdev,
> > -				    true, true, ctx,
> > -				    notify, callback, name);
> > +				    true, true,
> > +				    cfg->ctx ? cfg->ctx[index] : false,
> > +				    notify,
> > +				    cfg->callbacks[index],
> > +				    cfg->names[index]);
> >  	if (!vq)
> >  		return ERR_PTR(-ENOMEM);
> >
> > @@ -593,15 +594,11 @@ static struct virtqueue *setup_vq(struct virtio_p=
ci_device *vp_dev,
> >  	return ERR_PTR(err);
> >  }
> >
> > -static int vp_modern_find_vqs(struct virtio_device *vdev, unsigned int=
 nvqs,
> > -			      struct virtqueue *vqs[],
> > -			      vq_callback_t *callbacks[],
> > -			      const char * const names[], const bool *ctx,
> > -			      struct irq_affinity *desc)
> > +static int vp_modern_find_vqs(struct virtio_device *vdev, struct virti=
o_vq_config *cfg)
> >  {
> >  	struct virtio_pci_device *vp_dev =3D to_vp_device(vdev);
> >  	struct virtqueue *vq;
> > -	int rc =3D vp_find_vqs(vdev, nvqs, vqs, callbacks, names, ctx, desc);
> > +	int rc =3D vp_find_vqs(vdev, cfg);
> >
> >  	if (rc)
> >  		return rc;
> > @@ -739,10 +736,17 @@ static bool vp_get_shm_region(struct virtio_devic=
e *vdev,
> >  static int vp_modern_create_avq(struct virtio_device *vdev)
> >  {
> >  	struct virtio_pci_device *vp_dev =3D to_vp_device(vdev);
> > +	vq_callback_t *callbacks[] =3D { NULL };
> > +	struct virtio_vq_config cfg =3D {};
> >  	struct virtio_pci_admin_vq *avq;
> >  	struct virtqueue *vq;
> > +	const char *names[1];
> >  	u16 admin_q_num;
> >
> > +	cfg.nvqs =3D 1;
> > +	cfg.callbacks =3D callbacks;
> > +	cfg.names =3D names;
> > +
> >  	if (!virtio_has_feature(vdev, VIRTIO_F_ADMIN_VQ))
> >  		return 0;
> >
>
> init things where you declare them. Named initializers are a thing, too.
>
>
> > @@ -753,8 +757,10 @@ static int vp_modern_create_avq(struct virtio_devi=
ce *vdev)
> >  	avq =3D &vp_dev->admin_vq;
> >  	avq->vq_index =3D vp_modern_avq_index(&vp_dev->mdev);
> >  	sprintf(avq->name, "avq.%u", avq->vq_index);
> > -	vq =3D vp_dev->setup_vq(vp_dev, &vp_dev->admin_vq.info, avq->vq_index=
, NULL,
> > -			      avq->name, NULL, VIRTIO_MSI_NO_VECTOR);
> > +
> > +	cfg.names[0] =3D avq->name;
> > +	vq =3D vp_dev->setup_vq(vp_dev, &vp_dev->admin_vq.info, avq->vq_index,
> > +			      &cfg, VIRTIO_MSI_NO_VECTOR);
> >  	if (IS_ERR(vq)) {
> >  		dev_err(&vdev->dev, "failed to setup admin virtqueue, err=3D%ld",
> >  			PTR_ERR(vq));
> > diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
> > index e82cca24d6e6..6e7aafb42100 100644
> > --- a/drivers/virtio/virtio_vdpa.c
> > +++ b/drivers/virtio/virtio_vdpa.c
> > @@ -142,8 +142,7 @@ static irqreturn_t virtio_vdpa_virtqueue_cb(void *p=
rivate)
> >
> >  static struct virtqueue *
> >  virtio_vdpa_setup_vq(struct virtio_device *vdev, unsigned int index,
> > -		     void (*callback)(struct virtqueue *vq),
> > -		     const char *name, bool ctx)
> > +		     struct virtio_vq_config *cfg)
> >  {
> >  	struct virtio_vdpa_device *vd_dev =3D to_virtio_vdpa_device(vdev);
> >  	struct vdpa_device *vdpa =3D vd_get_vdpa(vdev);
> > @@ -203,8 +202,12 @@ virtio_vdpa_setup_vq(struct virtio_device *vdev, u=
nsigned int index,
> >  	else
> >  		dma_dev =3D vdpa_get_dma_dev(vdpa);
> >  	vq =3D vring_create_virtqueue_dma(index, max_num, align, vdev,
> > -					true, may_reduce_num, ctx,
> > -					notify, callback, name, dma_dev);
> > +					true, may_reduce_num,
> > +					cfg->ctx ? cfg->ctx[index] : false,
> > +					notify,
> > +					cfg->callbacks[index],
> > +					cfg->names[index],
> > +					dma_dev);
> >  	if (!vq) {
> >  		err =3D -ENOMEM;
> >  		goto error_new_virtqueue;
> > @@ -213,7 +216,7 @@ virtio_vdpa_setup_vq(struct virtio_device *vdev, un=
signed int index,
> >  	vq->num_max =3D max_num;
> >
> >  	/* Setup virtqueue callback */
> > -	cb.callback =3D callback ? virtio_vdpa_virtqueue_cb : NULL;
> > +	cb.callback =3D cfg->callbacks[index] ? virtio_vdpa_virtqueue_cb : NU=
LL;
> >  	cb.private =3D info;
> >  	cb.trigger =3D NULL;
> >  	ops->set_vq_cb(vdpa, index, &cb);
> > @@ -353,12 +356,8 @@ create_affinity_masks(unsigned int nvecs, struct i=
rq_affinity *affd)
> >  	return masks;
> >  }
> >
> > -static int virtio_vdpa_find_vqs(struct virtio_device *vdev, unsigned i=
nt nvqs,
> > -				struct virtqueue *vqs[],
> > -				vq_callback_t *callbacks[],
> > -				const char * const names[],
> > -				const bool *ctx,
> > -				struct irq_affinity *desc)
> > +static int virtio_vdpa_find_vqs(struct virtio_device *vdev,
> > +				struct virtio_vq_config *cfg)
> >  {
> >  	struct virtio_vdpa_device *vd_dev =3D to_virtio_vdpa_device(vdev);
> >  	struct vdpa_device *vdpa =3D vd_get_vdpa(vdev);
> > @@ -366,24 +365,24 @@ static int virtio_vdpa_find_vqs(struct virtio_dev=
ice *vdev, unsigned int nvqs,
> >  	struct irq_affinity default_affd =3D { 0 };
> >  	struct cpumask *masks;
> >  	struct vdpa_callback cb;
> > -	bool has_affinity =3D desc && ops->set_vq_affinity;
> > +	bool has_affinity =3D cfg->desc && ops->set_vq_affinity;
> > +	struct virtqueue **vqs =3D cfg->vqs;
> > +	unsigned int nvqs =3D cfg->nvqs;
> >  	int i, err;
> >
> >  	if (has_affinity) {
> > -		masks =3D create_affinity_masks(nvqs, desc ? desc : &default_affd);
> > +		masks =3D create_affinity_masks(nvqs, cfg->desc ? cfg->desc : &defau=
lt_affd);
> >  		if (!masks)
> >  			return -ENOMEM;
> >  	}
> >
> >  	for (i =3D 0; i < nvqs; ++i) {
> > -		if (!names[i]) {
> > +		if (!cfg->names[i]) {
> >  			err =3D -EINVAL;
> >  			goto err_setup_vq;
> >  		}
> >
> > -		vqs[i] =3D virtio_vdpa_setup_vq(vdev, i,
> > -					      callbacks[i], names[i], ctx ?
> > -					      ctx[i] : false);
> > +		vqs[i] =3D virtio_vdpa_setup_vq(vdev, i, cfg);
> >  		if (IS_ERR(vqs[i])) {
> >  			err =3D PTR_ERR(vqs[i]);
> >  			goto err_setup_vq;
> > diff --git a/include/linux/virtio_config.h b/include/linux/virtio_confi=
g.h
> > index 1c79cec258f4..370e79df50c4 100644
> > --- a/include/linux/virtio_config.h
> > +++ b/include/linux/virtio_config.h
> > @@ -18,6 +18,29 @@ struct virtio_shm_region {
> >
> >  typedef void vq_callback_t(struct virtqueue *);
> >
> > +/**
> > + * struct virtio_vq_config - configure for find_vqs()
>
> configure -> configuration
>
>
> > + * @nvqs: the number of virtqueues to find
> > + * @vqs: on success, includes new virtqueues
> > + * @callbacks: array of callbacks, for each virtqueue
> > + *	include a NULL entry for vqs that do not need a callback
> > + * @names: array of virtqueue names (mainly for debugging)
> > + *		MUST NOT be NULL
> > + * @ctx: (optional) array of context.
>
> must be a plural. E.g.
>
> 	of context pointers
>
> > If the value of the vq in the array
> > + *	is true, the driver can pass ctx to virtio core when adding bufs to
> > + *	virtqueue.
> > + * @desc: desc for interrupts
>
> does not really describe it.
>
> > + */
> > +struct virtio_vq_config {
> > +	unsigned int nvqs;
> > +
> > +	struct virtqueue   **vqs;
> > +	vq_callback_t      **callbacks;
> > +	const char         **names;
> > +	const bool          *ctx;
> > +	struct irq_affinity *desc;
> > +};
> > +
> >  /**
> >   * struct virtio_config_ops - operations for configuring a virtio devi=
ce
> >   * Note: Do not assume that a transport implements all of the operatio=
ns
> > @@ -51,12 +74,7 @@ typedef void vq_callback_t(struct virtqueue *);
> >   *	parallel with being added/removed.
> >   * @find_vqs: find virtqueues and instantiate them.
> >   *	vdev: the virtio_device
> > - *	nvqs: the number of virtqueues to find
> > - *	vqs: on success, includes new virtqueues
> > - *	callbacks: array of callbacks, for each virtqueue
> > - *		include a NULL entry for vqs that do not need a callback
> > - *	names: array of virtqueue names (mainly for debugging)
> > - *		MUST NOT be NULL
> > + *	cfg: the config from the driver
> >   *	Returns 0 on success or error status
> >   * @del_vqs: free virtqueues found by find_vqs().
> >   * @synchronize_cbs: synchronize with the virtqueue callbacks (optiona=
l)
> > @@ -96,6 +114,7 @@ typedef void vq_callback_t(struct virtqueue *);
> >   * @create_avq: create admin virtqueue resource.
> >   * @destroy_avq: destroy admin virtqueue resource.
> >   */
> > +
> >  struct virtio_config_ops {
> >  	void (*get)(struct virtio_device *vdev, unsigned offset,
> >  		    void *buf, unsigned len);
> > @@ -105,10 +124,7 @@ struct virtio_config_ops {
> >  	u8 (*get_status)(struct virtio_device *vdev);
> >  	void (*set_status)(struct virtio_device *vdev, u8 status);
> >  	void (*reset)(struct virtio_device *vdev);
> > -	int (*find_vqs)(struct virtio_device *, unsigned nvqs,
> > -			struct virtqueue *vqs[], vq_callback_t *callbacks[],
> > -			const char * const names[], const bool *ctx,
> > -			struct irq_affinity *desc);
> > +	int (*find_vqs)(struct virtio_device *vdev, struct virtio_vq_config *=
cfg);
> >  	void (*del_vqs)(struct virtio_device *);
> >  	void (*synchronize_cbs)(struct virtio_device *);
> >  	u64 (*get_features)(struct virtio_device *vdev);
> > @@ -217,8 +233,14 @@ struct virtqueue *virtio_find_single_vq(struct vir=
tio_device *vdev,
> >  	vq_callback_t *callbacks[] =3D { c };
> >  	const char *names[] =3D { n };
> >  	struct virtqueue *vq;
> > -	int err =3D vdev->config->find_vqs(vdev, 1, &vq, callbacks, names, NU=
LL,
> > -					 NULL);
> > +	struct virtio_vq_config cfg =3D {};
> > +
> > +	cfg.nvqs =3D 1;
> > +	cfg.vqs =3D &vq;
> > +	cfg.callbacks =3D callbacks;
> > +	cfg.names =3D names;
> > +
> > +	int err =3D vdev->config->find_vqs(vdev, &cfg);
> >  	if (err < 0)
> >  		return ERR_PTR(err);
> >  	return vq;
> > @@ -226,21 +248,37 @@ struct virtqueue *virtio_find_single_vq(struct vi=
rtio_device *vdev,
> >
> >  static inline
> >  int virtio_find_vqs(struct virtio_device *vdev, unsigned nvqs,
> > -			struct virtqueue *vqs[], vq_callback_t *callbacks[],
> > -			const char * const names[],
> > -			struct irq_affinity *desc)
> > +		    struct virtqueue *vqs[], vq_callback_t *callbacks[],
> > +		    const char * const names[],
> > +		    struct irq_affinity *desc)
> >  {
> > -	return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, NULL=
, desc);
> > +	struct virtio_vq_config cfg =3D {};
> > +
> > +	cfg.nvqs =3D nvqs;
> > +	cfg.vqs =3D vqs;
> > +	cfg.callbacks =3D callbacks;
> > +	cfg.names =3D (const char **)names;
>
>
> Casting const away? Not safe.



Because the vp_modern_create_avq() use the "const char *names[]",
and the virtio_uml.c changes the name in the subsequent commit, so
change the "names" inside the virtio_vq_config from "const char *const
*names" to "const char **names".


Other comments will be fix in next version.

Thanks.


>
> > +	cfg.desc =3D desc;
> > +
> > +	return vdev->config->find_vqs(vdev, &cfg);
> >  }
> >
> >  static inline
> >  int virtio_find_vqs_ctx(struct virtio_device *vdev, unsigned nvqs,
> >  			struct virtqueue *vqs[], vq_callback_t *callbacks[],
> > -			const char * const names[], const bool *ctx,
> > +			const char *names[], const bool *ctx,
> >  			struct irq_affinity *desc)
> >  {
> > -	return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, ctx,
> > -				      desc);
> > +	struct virtio_vq_config cfg =3D {};
> > +
> > +	cfg.nvqs =3D nvqs;
> > +	cfg.vqs =3D vqs;
> > +	cfg.callbacks =3D callbacks;
> > +	cfg.names =3D names;
> > +	cfg.ctx =3D ctx;
> > +	cfg.desc =3D desc;
> > +
>
> The fields should be set up with named initializers, insidef {}
>
> > +	return vdev->config->find_vqs(vdev, &cfg);
> >  }
> >
> >  /**
> > --
> > 2.32.0.3.g01195cf9f
>

