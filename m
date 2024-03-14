Return-Path: <kvm+bounces-11781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 72F1887B7CC
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 07:10:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DCB42B22576
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 06:10:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CB3C17BAE;
	Thu, 14 Mar 2024 06:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="X7xOAyTz"
X-Original-To: kvm@vger.kernel.org
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B72FD535;
	Thu, 14 Mar 2024 06:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710396042; cv=none; b=KfKkBOV9PWnfG9r30GxLHN5mFfxbdUPWkxSpuB0zVSBQU4kLqt895KJdj5y3zFJmH80HHravWrQH8lzusm7zNevYaQ1mWE83bN0taInWCSTGGXiQayRGwRHjBp7+HnZu8f+B3/oN3wYcm1bDK3sXFBj+rC8UEguWHToFEKtnrMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710396042; c=relaxed/simple;
	bh=4sZqY6J/YMhF2k8mvjAMYsqm1g9w7kkJUFdg7aHeAcU=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To:
	 Content-Type; b=jwiRey/Lcb1LWb7g0PkZp6OizifurU8LeXpaDJiJtQeceFXyxx7eALS597a5Bf0dbyrjv17PuWoG05vfSVY/Qc5sER3P99ECGJ81XjSMNucN7jxTpfK+VLNAMtcq/HBbHeg/hWsp7Nl5Zc4/5q7kfDEVnvON71DDQFYKQACvD7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=X7xOAyTz; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1710396031; h=Message-ID:Subject:Date:From:To:Content-Type;
	bh=/3auDq21P+3VIk5KDxp7XywdJJcGN1ChRwn63QuP8Pg=;
	b=X7xOAyTzRU0zpryR83xAF8mV/cAk9wXeopwhTqHAt9t2ZsYcLM0nkGdosmTRIPvjAnoPJhhWQ75EZisafsDRMNYhXiuLZLAweUPheS6Ytiu+iN/agij3j+0iUXfpgjLjqFWjACUQg0R/hwmgyQfpqf9+/0200CIRYl7tJ3SSzWM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=24;SR=0;TI=SMTPD_---0W2RGslY_1710396029;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W2RGslY_1710396029)
          by smtp.aliyun-inc.com;
          Thu, 14 Mar 2024 14:00:29 +0800
Message-ID: <1710395908.7915084-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost v3 1/4] virtio: find_vqs: pass struct instead of multi parameters
Date: Thu, 14 Mar 2024 13:58:28 +0800
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
 linux-um@lists.infradead.org,
 platform-driver-x86@vger.kernel.org,
 linux-remoteproc@vger.kernel.org,
 linux-s390@vger.kernel.org,
 kvm@vger.kernel.org
References: <20240312021013.88656-1-xuanzhuo@linux.alibaba.com>
 <20240312021013.88656-2-xuanzhuo@linux.alibaba.com>
 <CACGkMEvVgfgAxLoKeFTgy-1GR0W07ciPYFuqs6PiWtKCnXuWTw@mail.gmail.com>
In-Reply-To: <CACGkMEvVgfgAxLoKeFTgy-1GR0W07ciPYFuqs6PiWtKCnXuWTw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

On Thu, 14 Mar 2024 11:12:24 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Tue, Mar 12, 2024 at 10:10=E2=80=AFAM Xuan Zhuo <xuanzhuo@linux.alibab=
a.com> wrote:
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
> > Reviewed-by: Ilpo J=3DE4rvinen <ilpo.jarvinen@linux.intel.com>
>
> The name seems broken here.

Email APP bug.

I will fix.


>
> [...]
>
> >
> >  typedef void vq_callback_t(struct virtqueue *);
> >
> > +/**
> > + * struct virtio_vq_config - configure for find_vqs()
> > + * @cfg_idx: Used by virtio core. The drivers should set this to 0.
> > + *     During the initialization of each vq(vring setup), we need to k=
now which
> > + *     item in the array should be used at that time. But since the it=
em in
> > + *     names can be null, which causes some item of array to be skippe=
d, we
> > + *     cannot use vq.index as the current id. So add a cfg_idx to let =
vring
> > + *     know how to get the current configuration from the array when
> > + *     initializing vq.
>
> So this design is not good. If it is not something that the driver
> needs to care about, the core needs to hide it from the API.

The driver just ignore it. That will be beneficial to the virtio core.
Otherwise, we must pass one more parameter everywhere.

Thanks.

>
> Thanks
>

