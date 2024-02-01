Return-Path: <kvm+bounces-7649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 24FCB844F23
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 03:25:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5FEB28C6AB
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 02:25:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5273F2C1AE;
	Thu,  1 Feb 2024 02:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="xzMyHymm"
X-Original-To: kvm@vger.kernel.org
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5168617554;
	Thu,  1 Feb 2024 02:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706754287; cv=none; b=VXX5Or6XmoeHCwcxzFxl9U6+TWoOKuBwoNYnwjPqQ8rQhuL+EBVT/ATH6tC5odcxOuQ5VmsLqnLrL0Hwt7+yHocEb2ze/4oV72NTGWMUbwUB28GkBG6EpjyH5PVbYT1g1uaZ+CL+15BVdzbiSeb0wwVTM2Y+u6UGr6Zh/H3Ings=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706754287; c=relaxed/simple;
	bh=JRicf2YLFT9kvYkR1O+/05/ONpzCairi+jAAGATbK2A=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To; b=nsf7rrYKKm8UhaibWH06wwzxO3aBXfPgTXVviSC0pPXxn1a1+bpHoYJ+kHvzkWo6EH8G9tYRKRedcEC2N8d6ynhYrQzt/BhA18gLip+fBVoeR4LmeYiNPABVrHGgxZ3YE7a1yDvtMZb2pYttT6xs4H0jqmfEiWjBgA80XTEw5AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=xzMyHymm; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1706754282; h=Message-ID:Subject:Date:From:To;
	bh=lp6gnz0UerLEf+61GoJAoC7KepGxnJDRWTzE7Fmg8w8=;
	b=xzMyHymmEOi178o4u16V0ldnZrIgb2AOsKvx+wOvAzmQp3tByVaA5TP6YS7KRDIsGO8nXMuWTSTmUjZbAfcHjDXvLAYu/wAgi7tc76O0T0rDqUGykPqeCo65k39dXs5OtxzA1kr383BplRSYfTyimv39C8/PxbFCjahm3bu7n6g=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=36;SR=0;TI=SMTPD_---0W.lS.oy_1706754279;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W.lS.oy_1706754279)
          by smtp.aliyun-inc.com;
          Thu, 01 Feb 2024 10:24:40 +0800
Message-ID: <1706754257.289654-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost 08/17] virtio: vring_new_virtqueue(): pass struct instead of multi parameters
Date: Thu, 1 Feb 2024 10:24:17 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: =?utf-8?q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: virtualization@lists.linux.dev,
 Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>,
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
 Netdev <netdev@vger.kernel.org>,
 platform-driver-x86@vger.kernel.org,
 linux-remoteproc@vger.kernel.org,
 linux-s390@vger.kernel.org,
 kvm@vger.kernel.org,
 bpf@vger.kernel.org
References: <20240130114224.86536-1-xuanzhuo@linux.alibaba.com>
 <20240130114224.86536-9-xuanzhuo@linux.alibaba.com>
 <bcd0e35e-e9a3-48b5-fc0a-117ba997439a@linux.intel.com>
In-Reply-To: <bcd0e35e-e9a3-48b5-fc0a-117ba997439a@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

On Wed, 31 Jan 2024 13:03:04 +0200 (EET), =?utf-8?q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com> wrote:
> On Tue, 30 Jan 2024, Xuan Zhuo wrote:
>
> > Just like find_vqs(), it is time to refactor the
> > vring_new_virtqueue(). We pass the similar struct to
> > vring_new_virtqueue.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
>
> > diff --git a/tools/virtio/vringh_test.c b/tools/virtio/vringh_test.c
> > index 98ff808d6f0c..37f8c5d34285 100644
> > --- a/tools/virtio/vringh_test.c
> > +++ b/tools/virtio/vringh_test.c
>
> > @@ -391,7 +391,7 @@ static int parallel_test(u64 features,
> >  				/* Swallow all notifies at once. */
> >  				if (read(to_guest[0], buf, sizeof(buf)) < 1)
> >  					break;
> > -
> > +
> >  				receives++;
> >  				virtqueue_disable_cb(vq);
> >  				continue;
> > @@ -424,7 +424,7 @@ static int parallel_test(u64 features,
> >  				continue;
> >  			if (read(to_guest[0], buf, sizeof(buf)) < 1)
> >  				break;
> > -
> > +
>
> Two unrelated space changes. Please remove them from this patch.


Will fix in next version.

Thanks.


>
>
> --
>  i.
>

