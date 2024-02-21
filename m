Return-Path: <kvm+bounces-9235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AC45E85CDB3
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 03:05:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C8751F2587F
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 02:05:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CB1479E2;
	Wed, 21 Feb 2024 02:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="sbiMOEKn"
X-Original-To: kvm@vger.kernel.org
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3060C566A;
	Wed, 21 Feb 2024 02:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708481094; cv=none; b=VDY3JThvtujuGnnnhjDZKoebxQt907BsZZisx6U1NKYdL4/LFT7OMTyYO3npp1KwaggbgwcnhzPQCDV0SSUqgLp8VWF1sEkiD/ZwhF0C/uZNJ1vhJs5PUFenMzLzo15V/DMlQy/ZEMbd+jsP6lEefEAajyaS5/27MN3YbvDMzbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708481094; c=relaxed/simple;
	bh=ORbxc1aLPAjWIc3vkR5GtdqUtX005SNYWEsxv9OAOk8=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To; b=I2WwqGHMgkKBchRCY5FkxBw66RzZcOvvW/W3M0WOgz/17siDBvNFQbc2xYMdGuxoFxCw7O37+QufNbYFw9WFiiechoEIDYLdn/l2LlO66Njero0F/k1oSszpSFkICQ5e0abrynF9DX0qAXKvvlJgKhitUlhcYBelBHDT5tT0jgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=sbiMOEKn; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1708481089; h=Message-ID:Subject:Date:From:To;
	bh=ORbxc1aLPAjWIc3vkR5GtdqUtX005SNYWEsxv9OAOk8=;
	b=sbiMOEKn8YsHac7GFd2HpFkPp/HOfaG+QEE9BieQi/hhLVUhFJ7rmqrhU424MQvVrn0mxTjDTdk4MpsxcIzPFtU3cw3u/0GLit+rcLWYL1xhJZxH6osDXJHKl/q45G0sOC1B2Yb8vcCsOxJNeZQnoQCUxEIBetRhstw6k8N7NoE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=36;SR=0;TI=SMTPD_---0W0yFyS._1708481086;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W0yFyS._1708481086)
          by smtp.aliyun-inc.com;
          Wed, 21 Feb 2024 10:04:47 +0800
Message-ID: <1708481025.1893313-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost 07/17] virtio: find_vqs: pass struct instead of multi parameters
Date: Wed, 21 Feb 2024 10:03:45 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: Halil Pasic <pasic@linux.ibm.com>
Cc: Jason Wang <jasowang@redhat.com>,
 virtualization@lists.linux.dev,
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
 bpf@vger.kernel.org,
 Halil Pasic <pasic@linux.ibm.com>
References: <20240130114224.86536-1-xuanzhuo@linux.alibaba.com>
 <20240130114224.86536-8-xuanzhuo@linux.alibaba.com>
 <CACGkMEvb4N8kthr4qWXrLOh9v422OYhrYU6hQejusw-e5EacPw@mail.gmail.com>
 <1706756442.5524123-1-xuanzhuo@linux.alibaba.com>
 <20240220151815.5c867cce.pasic@linux.ibm.com>
In-Reply-To: <20240220151815.5c867cce.pasic@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

On Tue, 20 Feb 2024 15:18:15 +0100, Halil Pasic <pasic@linux.ibm.com> wrote:
> On Thu, 1 Feb 2024 11:00:42 +0800
> Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> > > > And squish the parameters from transport to a structure.
> > >
> > > The patch did more than what is described here, it also switch to use
> > > a structure for vring_create_virtqueue() etc.
> > >
> > > Is it better to split?
> >
> > Sure.
>
> I understand there will be a v2. From virtio-ccw perspective I have
> no objections.

The next version is v1.

That is posted.

http://lore.kernel.org/all/20240202093951.120283-8-xuanzhuo@linux.alibaba.com
http://lore.kernel.org/all/20240202093951.120283-9-xuanzhuo@linux.alibaba.com

Thanks.


>
> Regards,
> Halil

