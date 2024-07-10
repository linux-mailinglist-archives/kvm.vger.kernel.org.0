Return-Path: <kvm+bounces-21313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 32CCD92D4F4
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 17:29:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC2A6280FD3
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 15:29:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A589D194A43;
	Wed, 10 Jul 2024 15:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="f54uXUuH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F185E194156
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 15:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720625331; cv=none; b=V+tGJ1oKBGZlFuCGEHwAK1IpBX867uasR7u8DjhxHF32FYcaVBDzz8Pd/md6Hbp5DzVQdwreyqZT/5yhGabDXAIsNCM+dCfGXh80GKQ8fB1i6Z3I/BNmNfecHexufL3uPVCBllUxllATDoUaJKN/9qZGFeU0TspsxIzXAM2FcFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720625331; c=relaxed/simple;
	bh=0lWURBss3nBOg5NlkB2tEwctfOSX76EvuB40iqcOCUM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GHoTzqxJJaPSCHyLcNuG4HJG6SPikz8Dz15Dl94w21wVGbz+AEtv96lquZkTDWbJICuh5/5Oc8piRXG0jsFAYnacYJsFSAQlwjuMjf5ZfAH4Xa7QnVlqBvu0Hs5a+zG5FlZlAO8XM7bd0f+dAWG/LC3E5UJ8QHdpXtKH1Jc54pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=f54uXUuH; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-52ea0f18500so6152427e87.3
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 08:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720625328; x=1721230128; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BZ/UGiqczEfNWeKnxq+ScYWf6jHGQxfDprcFSlNwXPQ=;
        b=f54uXUuHxSsvHXlzowlUBk+wqFMgry4IMtaaCDxWrsQAdhC3vF/xc16hfpdeImFqXs
         d9UCWTq6vBQO/14G8a8Ol5ZOukaZ3oO5hKVhS/Ku65SIrEzpmiURHdHsVavkEUoCQj19
         IljLmcdjujsq5V7lwhGk7AUakvbHmpV01wT6bRbD8m3sducFGbNgh6ZhP7RCpAYqpGdP
         j71Xr+xr3du8qC8oPNvfS3yfY8BOexqM/LqBb9TfmYmZqkXO0bQCoPumGfc15Xavd1Ym
         WbWMMali1ICllOXmNbMxMJ0wVy32cEd1wG7A/EBbakuMNmlAKAKo2ow7/a/y2YH0Wecx
         HfQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720625328; x=1721230128;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BZ/UGiqczEfNWeKnxq+ScYWf6jHGQxfDprcFSlNwXPQ=;
        b=qdaNidxIRDy46Izd/AZm/bDpgElastZjz+Y8rAwyaJlgw2Gprnb2imLS0g5E65o3Hm
         Z5O0gz3ym6DDjwovJ+LHRuhXNB9RAoOB1EZeNmi0C4Sp0UbBJv7wOS8VQjmp/Hdqe+uG
         PxGcrnxFD2SuuLi4wPIGY3arToupqYkLhKY6NAgI4bh2AJm2M0lidNYn+8QgU7bEB0ag
         a/9gO0Dk4I/YTpc/MT5HEHGPWYenYplQNxH4mHdmAu33ouh6a/ujvtNCiZ8rh9UK1K5g
         qRFvJDmPK8HT0GZyLJjTejDQChWKcA4EuV7P6LaWX9WVDaCxQjA4QS4PBh7Cq4NLgowK
         rDTg==
X-Forwarded-Encrypted: i=1; AJvYcCXXcNAPd+xpsMAUxOJ8UmODgvhZ3QXTB9IZc/gRGXoe0q4XrI2oAVWigcUHpftKDJF8HM1ddwTVfNlk6a+v9zjtECHy
X-Gm-Message-State: AOJu0YxxFDjahF/DuX9L5PPtX+s4YPka+5NNg5cPxX+sldSBTFPVsnFg
	UDaVAemoNOmV6t2zyOrSg6rA7mFAaYF8wYRuOjqEmSQ4w/VGjn5GKISY/XT58aPpodXq8PH8mqk
	YLRz1vrBhQ6M5WZU6fnmroo/xBoKJi/RAy6Ykvg==
X-Google-Smtp-Source: AGHT+IFva/aOSUrC0d2gfrJaELKiBejlXq7juoOS4NWsej9fRXJn2qGo6TDgD4S8OrEaTK71/Fglkt59vHORRLv93uk=
X-Received: by 2002:a05:6512:1189:b0:52c:d8e9:5d8b with SMTP id
 2adb3069b0e04-52eb999446emr3966106e87.25.1720625328028; Wed, 10 Jul 2024
 08:28:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1720611677.git.mst@redhat.com> <3d655be73ce220f176b2c163839d83699f8faf43.1720611677.git.mst@redhat.com>
In-Reply-To: <3d655be73ce220f176b2c163839d83699f8faf43.1720611677.git.mst@redhat.com>
From: Mathieu Poirier <mathieu.poirier@linaro.org>
Date: Wed, 10 Jul 2024 09:28:36 -0600
Message-ID: <CANLsYkyqhdmOWtHbNi5npOFXtMKrs7s21j+axW_4N=yQh=eHbw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] virtio: fix vq # for balloon
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, 
	Alexander Duyck <alexander.h.duyck@linux.intel.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Bjorn Andersson <andersson@kernel.org>, 
	Cornelia Huck <cohuck@redhat.com>, Halil Pasic <pasic@linux.ibm.com>, 
	Eric Farman <farman@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Jason Wang <jasowang@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	linux-um@lists.infradead.org, linux-remoteproc@vger.kernel.org, 
	linux-s390@vger.kernel.org, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 10 Jul 2024 at 05:43, Michael S. Tsirkin <mst@redhat.com> wrote:
>
> virtio balloon communicates to the core that in some
> configurations vq #s are non-contiguous by setting name
> pointer to NULL.
>
> Unfortunately, core then turned around and just made them
> contiguous again. Result is that driver is out of spec.
>
> Implement what the API was supposed to do
> in the 1st place. Compatibility with buggy hypervisors
> is handled inside virtio-balloon, which is the only driver
> making use of this facility, so far.
>
> Message-ID: <cover.1720173841.git.mst@redhat.com>
> Fixes: b0c504f15471 ("virtio-balloon: add support for providing free page reports to host")
> Cc: "Alexander Duyck" <alexander.h.duyck@linux.intel.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  arch/um/drivers/virtio_uml.c           |  4 ++--
>  drivers/remoteproc/remoteproc_virtio.c |  4 ++--

Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>

>  drivers/s390/virtio/virtio_ccw.c       |  4 ++--
>  drivers/virtio/virtio_mmio.c           |  4 ++--
>  drivers/virtio/virtio_pci_common.c     | 11 ++++++++---
>  drivers/virtio/virtio_vdpa.c           |  4 ++--
>  6 files changed, 18 insertions(+), 13 deletions(-)
>
> diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
> index 2b6e701776b6..c903e4959f51 100644
> --- a/arch/um/drivers/virtio_uml.c
> +++ b/arch/um/drivers/virtio_uml.c
> @@ -1019,7 +1019,7 @@ static int vu_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>                        struct irq_affinity *desc)
>  {
>         struct virtio_uml_device *vu_dev = to_virtio_uml_device(vdev);
> -       int i, queue_idx = 0, rc;
> +       int i, rc;
>         struct virtqueue *vq;
>
>         /* not supported for now */
> @@ -1038,7 +1038,7 @@ static int vu_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>                         continue;
>                 }
>
> -               vqs[i] = vu_setup_vq(vdev, queue_idx++, vqi->callback,
> +               vqs[i] = vu_setup_vq(vdev, i, vqi->callback,
>                                      vqi->name, vqi->ctx);
>                 if (IS_ERR(vqs[i])) {
>                         rc = PTR_ERR(vqs[i]);
> diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
> index d3f39009b28e..1019b2825c26 100644
> --- a/drivers/remoteproc/remoteproc_virtio.c
> +++ b/drivers/remoteproc/remoteproc_virtio.c
> @@ -185,7 +185,7 @@ static int rproc_virtio_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
>                                  struct virtqueue_info vqs_info[],
>                                  struct irq_affinity *desc)
>  {
> -       int i, ret, queue_idx = 0;
> +       int i, ret;
>
>         for (i = 0; i < nvqs; ++i) {
>                 struct virtqueue_info *vqi = &vqs_info[i];
> @@ -195,7 +195,7 @@ static int rproc_virtio_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
>                         continue;
>                 }
>
> -               vqs[i] = rp_find_vq(vdev, queue_idx++, vqi->callback,
> +               vqs[i] = rp_find_vq(vdev, i, vqi->callback,
>                                     vqi->name, vqi->ctx);
>                 if (IS_ERR(vqs[i])) {
>                         ret = PTR_ERR(vqs[i]);
> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> index 62eca9419ad7..82a3440bbabb 100644
> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -694,7 +694,7 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>  {
>         struct virtio_ccw_device *vcdev = to_vc_device(vdev);
>         dma64_t *indicatorp = NULL;
> -       int ret, i, queue_idx = 0;
> +       int ret, i;
>         struct ccw1 *ccw;
>         dma32_t indicatorp_dma = 0;
>
> @@ -710,7 +710,7 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>                         continue;
>                 }
>
> -               vqs[i] = virtio_ccw_setup_vq(vdev, queue_idx++, vqi->callback,
> +               vqs[i] = virtio_ccw_setup_vq(vdev, i, vqi->callback,
>                                              vqi->name, vqi->ctx, ccw);
>                 if (IS_ERR(vqs[i])) {
>                         ret = PTR_ERR(vqs[i]);
> diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> index 90e784e7b721..db6a0366f082 100644
> --- a/drivers/virtio/virtio_mmio.c
> +++ b/drivers/virtio/virtio_mmio.c
> @@ -494,7 +494,7 @@ static int vm_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
>  {
>         struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
>         int irq = platform_get_irq(vm_dev->pdev, 0);
> -       int i, err, queue_idx = 0;
> +       int i, err;
>
>         if (irq < 0)
>                 return irq;
> @@ -515,7 +515,7 @@ static int vm_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
>                         continue;
>                 }
>
> -               vqs[i] = vm_setup_vq(vdev, queue_idx++, vqi->callback,
> +               vqs[i] = vm_setup_vq(vdev, i, vqi->callback,
>                                      vqi->name, vqi->ctx);
>                 if (IS_ERR(vqs[i])) {
>                         vm_del_vqs(vdev);
> diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
> index 7d82facafd75..fa606e7321ad 100644
> --- a/drivers/virtio/virtio_pci_common.c
> +++ b/drivers/virtio/virtio_pci_common.c
> @@ -293,7 +293,7 @@ static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned int nvqs,
>         struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>         struct virtqueue_info *vqi;
>         u16 msix_vec;
> -       int i, err, nvectors, allocated_vectors, queue_idx = 0;
> +       int i, err, nvectors, allocated_vectors;
>
>         vp_dev->vqs = kcalloc(nvqs, sizeof(*vp_dev->vqs), GFP_KERNEL);
>         if (!vp_dev->vqs)
> @@ -332,7 +332,7 @@ static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned int nvqs,
>                         msix_vec = allocated_vectors++;
>                 else
>                         msix_vec = VP_MSIX_VQ_VECTOR;
> -               vqs[i] = vp_setup_vq(vdev, queue_idx++, vqi->callback,
> +               vqs[i] = vp_setup_vq(vdev, i, vqi->callback,
>                                      vqi->name, vqi->ctx, msix_vec);
>                 if (IS_ERR(vqs[i])) {
>                         err = PTR_ERR(vqs[i]);
> @@ -368,7 +368,7 @@ static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned int nvqs,
>                             struct virtqueue_info vqs_info[])
>  {
>         struct virtio_pci_device *vp_dev = to_vp_device(vdev);
> -       int i, err, queue_idx = 0;
> +       int i, err;
>
>         vp_dev->vqs = kcalloc(nvqs, sizeof(*vp_dev->vqs), GFP_KERNEL);
>         if (!vp_dev->vqs)
> @@ -388,8 +388,13 @@ static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned int nvqs,
>                         vqs[i] = NULL;
>                         continue;
>                 }
> +<<<<<<< HEAD
>                 vqs[i] = vp_setup_vq(vdev, queue_idx++, vqi->callback,
>                                      vqi->name, vqi->ctx,
> +=======
> +               vqs[i] = vp_setup_vq(vdev, i, callbacks[i], names[i],
> +                                    ctx ? ctx[i] : false,
> +>>>>>>> f814759f80b7... virtio: fix vq # for balloon
>                                      VIRTIO_MSI_NO_VECTOR);
>                 if (IS_ERR(vqs[i])) {
>                         err = PTR_ERR(vqs[i]);
> diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
> index 7364bd53e38d..149e893583e9 100644
> --- a/drivers/virtio/virtio_vdpa.c
> +++ b/drivers/virtio/virtio_vdpa.c
> @@ -368,7 +368,7 @@ static int virtio_vdpa_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
>         struct cpumask *masks;
>         struct vdpa_callback cb;
>         bool has_affinity = desc && ops->set_vq_affinity;
> -       int i, err, queue_idx = 0;
> +       int i, err;
>
>         if (has_affinity) {
>                 masks = create_affinity_masks(nvqs, desc ? desc : &default_affd);
> @@ -384,7 +384,7 @@ static int virtio_vdpa_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
>                         continue;
>                 }
>
> -               vqs[i] = virtio_vdpa_setup_vq(vdev, queue_idx++, vqi->callback,
> +               vqs[i] = virtio_vdpa_setup_vq(vdev, i, vqi->callback,
>                                               vqi->name, vqi->ctx);
>                 if (IS_ERR(vqs[i])) {
>                         err = PTR_ERR(vqs[i]);
> --
> MST
>

