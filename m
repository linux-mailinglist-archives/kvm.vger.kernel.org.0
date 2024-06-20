Return-Path: <kvm+bounces-20044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BDE690FE34
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 10:03:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A9B6A1F24205
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 08:03:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 632AC54FA2;
	Thu, 20 Jun 2024 08:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bGhMIBXt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C623CF65
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 08:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718870586; cv=none; b=A//InX1J9RvLnwlpevJx6Zn/Sp94A0r7ecTlqXPfJynUWykY0aXN2fSBy9b+497InuJP44/BPTNkyB0WKSBq3k3+ZNa3Iw7R+xDN+7CKWBaIrn1v8KZgE/BbygcPWhhNY3LQY2QeXbi5Uk9KULsRT1NsBpN1qBBlHyl6T67S8ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718870586; c=relaxed/simple;
	bh=5JGgK9RJsMxmdaF4amiBI/lMLZeOJBUAjcDz68M9ic4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dnq7LA/XNns2KWaALdF2dVjjYr/UXeDh+aC9bY9VTt/BDTTZMajTrzie1JVnnHtcuZJWhkSRtCTNF83rVr5Pr4m2oYMt24cIxisLvNmDxffRuzZ2q2o3OBvwiPsd3mrdRpr36BKqQNxA31emDBR52sOqjMG0l1FwrxxGMvlUqKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bGhMIBXt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718870582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=remzfKALIBx8WbUVn8zbZbWs3ErhPtv468gpGY/OCSI=;
	b=bGhMIBXtEY6vvus6WpRqDstkd/NpvoytFFDtoxaP7/6weFT9QCPgzHE5RO659gO3QO3OPb
	1+MvTIDCn7cS+m3a/k+HEAlCLDDiG0pX5yc+tGbifiY2dXwHFk4dfveEJ7zQtAQs3lR8GM
	vwRC0wnBGYjwEAWSbvlMD3R4tVr/Wcg=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-259-N1KOJwRqOiGH7m0G4_MMPQ-1; Thu, 20 Jun 2024 04:03:00 -0400
X-MC-Unique: N1KOJwRqOiGH7m0G4_MMPQ-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-52c091e4413so462023e87.2
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 01:03:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718870579; x=1719475379;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=remzfKALIBx8WbUVn8zbZbWs3ErhPtv468gpGY/OCSI=;
        b=aa4LQeSzkEFqdMh/jH3kaHIl39T3SO/6OhJxVmzqSi3zroJpwDEO7w8QeEH2d7nyPH
         0L6f5AgD89Lapcp0edGWrAzaUB62u+VFgbSEJ2GCBXLjGOg/TmH4k3QzqUdRYAFwImkJ
         73O3GHptFrTNI7oo4qIU4OfN3M3JMOKDFQa9ibg/GL+cO27edZDhJqPOc4cZlwugCxMW
         hbZbnTCyQc1Ry7sCipViqQ5xWYmT7bdGhFzzeTaQACmVfrUzROSKev578X8jHLVMKy0z
         Iktewopw0R56TNKZY+/P44XlSC9LEeYqKjW+jbfGywshdYqBJVQsJzMfpb5orzr/PVVX
         9ehg==
X-Forwarded-Encrypted: i=1; AJvYcCXC2+tW2lJXHUtB4ZEFqLj+4focYrDYwTgEScIHsTwpzFEtdrqzUSTwzzAm3A9XA4P5gG34SGNcf9//V/2iFTXj1szy
X-Gm-Message-State: AOJu0YyzgG6ht+KCpI5QKjDX3mbFb0uBtW53iYpy65pmYBp5Ay6ErX3c
	4wQAUC2jqZo1kHlpZjWXoHxWZoWg2jKiTbhd86ed7/I60S0Hyl8rwyVaFOCd4Kh8tRfj9CQJvug
	Qhv722DZfA1ObWeOd+VapgL52pWvM0PJTw07xWxBSTHaoya8Q8g==
X-Received: by 2002:a05:6512:1312:b0:52c:a5cc:27e7 with SMTP id 2adb3069b0e04-52ccaa59b04mr3949484e87.66.1718870579103;
        Thu, 20 Jun 2024 01:02:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHDoCR/HTEHjED/w7lfJvcEM8fOMfkwQ0u79FVTro0pdwFIqmIQ3FQyMg9Q46IEH1FsRRufXw==
X-Received: by 2002:a05:6512:1312:b0:52c:a5cc:27e7 with SMTP id 2adb3069b0e04-52ccaa59b04mr3949448e87.66.1718870578531;
        Thu, 20 Jun 2024 01:02:58 -0700 (PDT)
Received: from redhat.com ([2.52.146.100])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f56ed3679sm738594466b.122.2024.06.20.01.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 01:02:57 -0700 (PDT)
Date: Thu, 20 Jun 2024 04:02:45 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: virtualization@lists.linux.dev, Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Hans de Goede <hdegoede@redhat.com>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
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
	Jason Wang <jasowang@redhat.com>, linux-um@lists.infradead.org,
	platform-driver-x86@vger.kernel.org,
	linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH vhost v9 2/6] virtio: remove support for names array
 entries being null.
Message-ID: <20240620035749-mutt-send-email-mst@kernel.org>
References: <20240424091533.86949-1-xuanzhuo@linux.alibaba.com>
 <20240424091533.86949-3-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240424091533.86949-3-xuanzhuo@linux.alibaba.com>

On Wed, Apr 24, 2024 at 05:15:29PM +0800, Xuan Zhuo wrote:
> commit 6457f126c888 ("virtio: support reserved vqs") introduced this
> support. Multiqueue virtio-net use 2N as ctrl vq finally, so the logic
> doesn't apply. And not one uses this.
> 
> On the other side, that makes some trouble for us to refactor the
> find_vqs() params.
> 
> So I remove this support.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Acked-by: Jason Wang <jasowang@redhat.com>
> Acked-by: Eric Farman <farman@linux.ibm.com> # s390
> Acked-by: Halil Pasic <pasic@linux.ibm.com>


I don't mind, but this patchset is too big already.
Why do we need to make this part of this patchset?


> ---
>  arch/um/drivers/virtio_uml.c           |  8 ++++----
>  drivers/remoteproc/remoteproc_virtio.c | 11 ++++-------
>  drivers/s390/virtio/virtio_ccw.c       |  8 ++++----
>  drivers/virtio/virtio_mmio.c           | 11 ++++-------
>  drivers/virtio/virtio_pci_common.c     | 18 +++++++++---------
>  drivers/virtio/virtio_vdpa.c           | 11 ++++-------
>  include/linux/virtio_config.h          |  2 +-
>  7 files changed, 30 insertions(+), 39 deletions(-)
> 
> diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
> index 8adca2000e51..773f9fc4d582 100644
> --- a/arch/um/drivers/virtio_uml.c
> +++ b/arch/um/drivers/virtio_uml.c
> @@ -1019,8 +1019,8 @@ static int vu_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>  		       struct irq_affinity *desc)
>  {
>  	struct virtio_uml_device *vu_dev = to_virtio_uml_device(vdev);
> -	int i, queue_idx = 0, rc;
>  	struct virtqueue *vq;
> +	int i, rc;
>  
>  	/* not supported for now */
>  	if (WARN_ON(nvqs > 64))
> @@ -1032,11 +1032,11 @@ static int vu_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>  
>  	for (i = 0; i < nvqs; ++i) {
>  		if (!names[i]) {
> -			vqs[i] = NULL;
> -			continue;
> +			rc = -EINVAL;
> +			goto error_setup;
>  		}
>  
> -		vqs[i] = vu_setup_vq(vdev, queue_idx++, callbacks[i], names[i],
> +		vqs[i] = vu_setup_vq(vdev, i, callbacks[i], names[i],
>  				     ctx ? ctx[i] : false);
>  		if (IS_ERR(vqs[i])) {
>  			rc = PTR_ERR(vqs[i]);
> diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
> index 25b66b113b69..7f58634fcc41 100644
> --- a/drivers/remoteproc/remoteproc_virtio.c
> +++ b/drivers/remoteproc/remoteproc_virtio.c
> @@ -119,9 +119,6 @@ static struct virtqueue *rp_find_vq(struct virtio_device *vdev,
>  	if (id >= ARRAY_SIZE(rvdev->vring))
>  		return ERR_PTR(-EINVAL);
>  
> -	if (!name)
> -		return NULL;
> -
>  	/* Search allocated memory region by name */
>  	mem = rproc_find_carveout_by_name(rproc, "vdev%dvring%d", rvdev->index,
>  					  id);
> @@ -187,15 +184,15 @@ static int rproc_virtio_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
>  				 const bool * ctx,
>  				 struct irq_affinity *desc)
>  {
> -	int i, ret, queue_idx = 0;
> +	int i, ret;
>  
>  	for (i = 0; i < nvqs; ++i) {
>  		if (!names[i]) {
> -			vqs[i] = NULL;
> -			continue;
> +			ret = -EINVAL;
> +			goto error;
>  		}
>  
> -		vqs[i] = rp_find_vq(vdev, queue_idx++, callbacks[i], names[i],
> +		vqs[i] = rp_find_vq(vdev, i, callbacks[i], names[i],
>  				    ctx ? ctx[i] : false);
>  		if (IS_ERR(vqs[i])) {
>  			ret = PTR_ERR(vqs[i]);
> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> index d7569f395559..6cdd29952bc0 100644
> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -696,7 +696,7 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>  {
>  	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
>  	dma64_t *indicatorp = NULL;
> -	int ret, i, queue_idx = 0;
> +	int ret, i;
>  	struct ccw1 *ccw;
>  
>  	ccw = ccw_device_dma_zalloc(vcdev->cdev, sizeof(*ccw), NULL);
> @@ -705,11 +705,11 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>  
>  	for (i = 0; i < nvqs; ++i) {
>  		if (!names[i]) {
> -			vqs[i] = NULL;
> -			continue;
> +			ret = -EINVAL;
> +			goto out;
>  		}
>  
> -		vqs[i] = virtio_ccw_setup_vq(vdev, queue_idx++, callbacks[i],
> +		vqs[i] = virtio_ccw_setup_vq(vdev, i, callbacks[i],
>  					     names[i], ctx ? ctx[i] : false,
>  					     ccw);
>  		if (IS_ERR(vqs[i])) {
> diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> index 173596589c71..c3c8dd282952 100644
> --- a/drivers/virtio/virtio_mmio.c
> +++ b/drivers/virtio/virtio_mmio.c
> @@ -386,9 +386,6 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned int in
>  	else
>  		notify = vm_notify;
>  
> -	if (!name)
> -		return NULL;
> -
>  	/* Select the queue we're interested in */
>  	writel(index, vm_dev->base + VIRTIO_MMIO_QUEUE_SEL);
>  
> @@ -496,7 +493,7 @@ static int vm_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
>  {
>  	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
>  	int irq = platform_get_irq(vm_dev->pdev, 0);
> -	int i, err, queue_idx = 0;
> +	int i, err;
>  
>  	if (irq < 0)
>  		return irq;
> @@ -511,11 +508,11 @@ static int vm_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
>  
>  	for (i = 0; i < nvqs; ++i) {
>  		if (!names[i]) {
> -			vqs[i] = NULL;
> -			continue;
> +			vm_del_vqs(vdev);
> +			return -EINVAL;
>  		}
>  
> -		vqs[i] = vm_setup_vq(vdev, queue_idx++, callbacks[i], names[i],
> +		vqs[i] = vm_setup_vq(vdev, i, callbacks[i], names[i],
>  				     ctx ? ctx[i] : false);
>  		if (IS_ERR(vqs[i])) {
>  			vm_del_vqs(vdev);
> diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
> index b655fccaf773..eda71c6e87ee 100644
> --- a/drivers/virtio/virtio_pci_common.c
> +++ b/drivers/virtio/virtio_pci_common.c
> @@ -292,7 +292,7 @@ static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned int nvqs,
>  {
>  	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>  	u16 msix_vec;
> -	int i, err, nvectors, allocated_vectors, queue_idx = 0;
> +	int i, err, nvectors, allocated_vectors;
>  
>  	vp_dev->vqs = kcalloc(nvqs, sizeof(*vp_dev->vqs), GFP_KERNEL);
>  	if (!vp_dev->vqs)
> @@ -302,7 +302,7 @@ static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned int nvqs,
>  		/* Best option: one for change interrupt, one per vq. */
>  		nvectors = 1;
>  		for (i = 0; i < nvqs; ++i)
> -			if (names[i] && callbacks[i])
> +			if (callbacks[i])
>  				++nvectors;
>  	} else {
>  		/* Second best: one for change, shared for all vqs. */
> @@ -318,8 +318,8 @@ static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned int nvqs,
>  	allocated_vectors = vp_dev->msix_used_vectors;
>  	for (i = 0; i < nvqs; ++i) {
>  		if (!names[i]) {
> -			vqs[i] = NULL;
> -			continue;
> +			err = -EINVAL;
> +			goto error_find;
>  		}
>  
>  		if (!callbacks[i])
> @@ -328,7 +328,7 @@ static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned int nvqs,
>  			msix_vec = allocated_vectors++;
>  		else
>  			msix_vec = VP_MSIX_VQ_VECTOR;
> -		vqs[i] = vp_setup_vq(vdev, queue_idx++, callbacks[i], names[i],
> +		vqs[i] = vp_setup_vq(vdev, i, callbacks[i], names[i],
>  				     ctx ? ctx[i] : false,
>  				     msix_vec);
>  		if (IS_ERR(vqs[i])) {
> @@ -363,7 +363,7 @@ static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned int nvqs,
>  		const char * const names[], const bool *ctx)
>  {
>  	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
> -	int i, err, queue_idx = 0;
> +	int i, err;
>  
>  	vp_dev->vqs = kcalloc(nvqs, sizeof(*vp_dev->vqs), GFP_KERNEL);
>  	if (!vp_dev->vqs)
> @@ -378,10 +378,10 @@ static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned int nvqs,
>  	vp_dev->per_vq_vectors = false;
>  	for (i = 0; i < nvqs; ++i) {
>  		if (!names[i]) {
> -			vqs[i] = NULL;
> -			continue;
> +			err = -EINVAL;
> +			goto out_del_vqs;
>  		}
> -		vqs[i] = vp_setup_vq(vdev, queue_idx++, callbacks[i], names[i],
> +		vqs[i] = vp_setup_vq(vdev, i, callbacks[i], names[i],
>  				     ctx ? ctx[i] : false,
>  				     VIRTIO_MSI_NO_VECTOR);
>  		if (IS_ERR(vqs[i])) {
> diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
> index e803db0da307..e82cca24d6e6 100644
> --- a/drivers/virtio/virtio_vdpa.c
> +++ b/drivers/virtio/virtio_vdpa.c
> @@ -161,9 +161,6 @@ virtio_vdpa_setup_vq(struct virtio_device *vdev, unsigned int index,
>  	bool may_reduce_num = true;
>  	int err;
>  
> -	if (!name)
> -		return NULL;
> -
>  	if (index >= vdpa->nvqs)
>  		return ERR_PTR(-ENOENT);
>  
> @@ -370,7 +367,7 @@ static int virtio_vdpa_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
>  	struct cpumask *masks;
>  	struct vdpa_callback cb;
>  	bool has_affinity = desc && ops->set_vq_affinity;
> -	int i, err, queue_idx = 0;
> +	int i, err;
>  
>  	if (has_affinity) {
>  		masks = create_affinity_masks(nvqs, desc ? desc : &default_affd);
> @@ -380,11 +377,11 @@ static int virtio_vdpa_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
>  
>  	for (i = 0; i < nvqs; ++i) {
>  		if (!names[i]) {
> -			vqs[i] = NULL;
> -			continue;
> +			err = -EINVAL;
> +			goto err_setup_vq;
>  		}
>  
> -		vqs[i] = virtio_vdpa_setup_vq(vdev, queue_idx++,
> +		vqs[i] = virtio_vdpa_setup_vq(vdev, i,
>  					      callbacks[i], names[i], ctx ?
>  					      ctx[i] : false);
>  		if (IS_ERR(vqs[i])) {
> diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
> index da9b271b54db..1c79cec258f4 100644
> --- a/include/linux/virtio_config.h
> +++ b/include/linux/virtio_config.h
> @@ -56,7 +56,7 @@ typedef void vq_callback_t(struct virtqueue *);
>   *	callbacks: array of callbacks, for each virtqueue
>   *		include a NULL entry for vqs that do not need a callback
>   *	names: array of virtqueue names (mainly for debugging)
> - *		include a NULL entry for vqs unused by driver
> + *		MUST NOT be NULL

Do not shout - just drop "include a NULL entry" text - not being NULL
is default assumption for pointers.

>   *	Returns 0 on success or error status
>   * @del_vqs: free virtqueues found by find_vqs().
>   * @synchronize_cbs: synchronize with the virtqueue callbacks (optional)
> -- 
> 2.32.0.3.g01195cf9f


