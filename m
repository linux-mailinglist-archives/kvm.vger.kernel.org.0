Return-Path: <kvm+bounces-11489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74A3B8779D2
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 03:25:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A61321C20AD4
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 02:25:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C8DA1388;
	Mon, 11 Mar 2024 02:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="q2zi/Tbv"
X-Original-To: kvm@vger.kernel.org
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C1BA3F;
	Mon, 11 Mar 2024 02:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710123910; cv=none; b=qMZzR9jJ5O1vmSdKo09URe4U6sgw3+6vEMrU+JYHFYTqwk7kuHlIRKsJXSpi/PIPMbBdJCOVR8j6U3bE++EqdAeeF3dWCvIMTyhQMKtPsWbT2x8y0b9X/D7B9dydMPokNlfnG7SbQ0RFfz+2UORP3vyhCAZ7fJ1zfjQuelCv3Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710123910; c=relaxed/simple;
	bh=Q+YAp+SydATt35XhZXtZHP2qTDIuk+FIlk46vKpyMsQ=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To; b=GW5P/6Jmgk1URESFjZwq772q3BnK2SZaBMdW4eYcXj+Z21nheOQHvHF6aKMhu0ISOlHlnq4luHncGhvhCAXrdyNC8ZivQY9Wv9norz8Xn1nYhprFyCEdE+J5Q8/lHomS2l72c1V9SgICphEkVCyo2HMpIRz6rHEZqi8OYDxA6gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=q2zi/Tbv; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1710123899; h=Message-ID:Subject:Date:From:To;
	bh=IjggKy7HR74Lw2lFaJO8aNhkimYBeigCUfT94zbJh7Y=;
	b=q2zi/TbvUh9q3Dd8UbHqccp4DN68oKlJAuIpovRZU+H8eLAfrC+xYEFsjlZdIUhKvk8V4GCD1++D51bzfm464v2Rq+R3bPJc9OMDMr4ebjaqAEcVZHtRRh3yRw9vSET8T0HWPr0/p2o569UvXFs2B2rpTl5JuEAsbdh0NNzMZRQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=24;SR=0;TI=SMTPD_---0W29MS6c_1710123896;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W29MS6c_1710123896)
          by smtp.aliyun-inc.com;
          Mon, 11 Mar 2024 10:24:57 +0800
Message-ID: <1710123875.2753754-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost v1 2/4] virtio: vring_create_virtqueue: pass struct instead of multi parameters
Date: Mon, 11 Mar 2024 10:24:35 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: =?utf-8?q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: virtualization@lists.linux.dev,
 Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Hans de Goede <hdegoede@redhat.com>,
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
 Jason Wang <jasowang@redhat.com>,
 linux-um@lists.infradead.org,
 platform-driver-x86@vger.kernel.org,
 linux-remoteproc@vger.kernel.org,
 linux-s390@vger.kernel.org,
 kvm@vger.kernel.org
References: <20240306114615.88770-1-xuanzhuo@linux.alibaba.com>
 <20240306114615.88770-3-xuanzhuo@linux.alibaba.com>
 <8f77a787-0bb7-96ad-0dac-f8ef36879ae3@linux.intel.com>
In-Reply-To: <8f77a787-0bb7-96ad-0dac-f8ef36879ae3@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

On Fri, 8 Mar 2024 12:19:21 +0200 (EET), =?utf-8?q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com> wrote:
> On Wed, 6 Mar 2024, Xuan Zhuo wrote:
>
> > Now, we pass multi parameters to vring_create_virtqueue. These parameters
> > may from transport or from driver.
> >
> > vring_create_virtqueue is called by many places.
> > Every time, we try to add a new parameter, that is difficult.
> >
> > If parameters from the driver, that should directly be passed to vring.
> > Then the vring can access the config from driver directly.
> >
> > If parameters from the transport, we squish the parameters to a
> > structure. That will be helpful to add new parameter.
> >
> > Because the virtio_uml.c changes the name, so change the "names" inside
> > the virtio_vq_config from "const char *const *names" to
> > "const char **names".
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > Acked-by: Johannes Berg <johannes@sipsolutions.net>
>
> > @@ -60,38 +61,25 @@ struct virtio_device;
> >  struct virtqueue;
> >  struct device;
> >
> > +struct vq_transport_config {
> > +	unsigned int num;
> > +	unsigned int vring_align;
> > +	bool weak_barriers;
> > +	bool may_reduce_num;
> > +	bool (*notify)(struct virtqueue *vq);
> > +	struct device *dma_dev;
> > +};
>
> kerneldoc is missing from this struct too.
>
> It would be generally helpful if you are proactive when somebody comments
> your series by checking if there are similar cases within your series,
> instead of waiting them to be pointed out for you specificly.

Sorry. I missed it.

Will fix in next version.

Thanks


>
> --
>  i.
>

