Return-Path: <kvm+bounces-7672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E80BE845231
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 08:44:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 72A4D1F299B3
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 07:44:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12F32158D76;
	Thu,  1 Feb 2024 07:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BTi5Srt3"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506E085C7D
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 07:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706773455; cv=none; b=u6h3eXouS3R2oNpgT6W7fy9b2EUFqA8C7QXOLHnxh/QhkpcYFzV5JljKf4ZTRr6n4TdsC8j1/4ebXK7XqMtvr6iAXOqVDEQj+9YnqSV/az2lz+St1gjN5mPS+ZdMuUWpbSz7ENxVTluhGv65QGuBVb0w0WJ3yeR5InMLL+404Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706773455; c=relaxed/simple;
	bh=VUxkMaWDzVG8ks5grBa6GIO8EpjRdlccwEaXcMtktI4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hnDaQsMt5Pw1WvRjWemN2CYLc/azteMjYHgyymEW6W71SmzdmdcV2BXPxXnEzfTlmmida2Z/hdJQCfYTxGdpEQsO6pDwU+XO8rsTHxvtVH7wydfpZ6Jviy2nKKfAIVRHeaYLNd40yrth6HqkDf4ksoAwETxCNiO2Le9VXQW3FB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BTi5Srt3; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <fdc2da16-5680-44cf-bc18-b3e8c0f565fa@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706773449;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W+Ldjee8H+rdTycXwv7iNM7fs8dOnUOKfLYDOYFBKVs=;
	b=BTi5Srt3XKJ6GI3RHRfeEo1l/LIcvsed3vksfXGfzoNkv2bVp9RgtmgnorM1PflB601mio
	ZFYZWsWXuDV9CHI2hA0a6mHsCy0fjvtfbHXRWJUGYQG/TN+xsopEpfQy0//LmahUgBBaBR
	ctnB69aOTsyBQtqsU/VGoDWvQfeYCms=
Date: Thu, 1 Feb 2024 15:43:51 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH vhost 00/17] virtio: drivers maintain dma info for
 premapped vq
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>, virtualization@lists.linux.dev
Cc: Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Hans de Goede <hdegoede@redhat.com>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Vadim Pasternak <vadimp@nvidia.com>, Bjorn Andersson <andersson@kernel.org>,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Cornelia Huck <cohuck@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
 Eric Farman <farman@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 John Fastabend <john.fastabend@gmail.com>,
 Benjamin Berg <benjamin.berg@intel.com>, Yang Li
 <yang.lee@linux.alibaba.com>, linux-um@lists.infradead.org,
 netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
 kvm@vger.kernel.org, bpf@vger.kernel.org
References: <20240130114224.86536-1-xuanzhuo@linux.alibaba.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20240130114224.86536-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

在 2024/1/30 19:42, Xuan Zhuo 写道:
> As discussed:
> http://lore.kernel.org/all/CACGkMEvq0No8QGC46U4mGsMtuD44fD_cfLcPaVmJ3rHYqRZxYg@mail.gmail.com
> 
> If the virtio is premapped mode, the driver should manage the dma info by self.
> So the virtio core should not store the dma info.
> So we can release the memory used to store the dma info.
> 
> But if the desc_extra has not dma info, we face a new question,
> it is hard to get the dma info of the desc with indirect flag.
> For split mode, that is easy from desc, but for the packed mode,
> it is hard to get the dma info from the desc. And for hardening
> the dma unmap is saft, we should store the dma info of indirect
> descs.
> 
> So I introduce the "structure the indirect desc table" to
> allocate space to store dma info with the desc table.
> 
> On the other side, we mix the descs with indirect flag
> with other descs together to share the unmap api. That
> is complex. I found if we we distinguish the descs with
> VRING_DESC_F_INDIRECT before unmap, thing will be clearer.
> 
> Because of the dma array is allocated in the find_vqs(),
> so I introduce a new parameter to find_vqs().
> 
> Please review.
> 
> Thanks
> 
> Xuan Zhuo (17):
>    virtio_ring: introduce vring_need_unmap_buffer
>    virtio_ring: packed: remove double check of the unmap ops
>    virtio_ring: packed: structure the indirect desc table
>    virtio_ring: split: remove double check of the unmap ops
>    virtio_ring: split: structure the indirect desc table
>    virtio_ring: no store dma info when unmap is not needed
>    virtio: find_vqs: pass struct instead of multi parameters
>    virtio: vring_new_virtqueue(): pass struct instead of multi parameters
>    virtio_ring: reuse the parameter struct of find_vqs()
>    virtio: find_vqs: add new parameter premapped
>    virtio_ring: export premapped to driver by struct virtqueue
>    virtio_net: set premapped mode by find_vqs()
>    virtio_ring: remove api of setting vq premapped
>    virtio_ring: introduce dma map api for page
>    virtio_net: unify the code for recycling the xmit ptr
>    virtio_net: rename free_old_xmit_skbs to free_old_xmit
>    virtio_net: sq support premapped mode

The above can not be cleanly merged into kernel 6.8-rc2.

Perhaps a base-commit is needed. About base-commit, please see the link
https://people.kernel.org/monsieuricon/all-patches-must-include-base-commit-info

Zhu Yanjun

> 
>   arch/um/drivers/virtio_uml.c             |  29 +-
>   drivers/net/virtio_net.c                 | 298 +++++++---
>   drivers/platform/mellanox/mlxbf-tmfifo.c |  24 +-
>   drivers/remoteproc/remoteproc_virtio.c   |  31 +-
>   drivers/s390/virtio/virtio_ccw.c         |  33 +-
>   drivers/virtio/virtio_mmio.c             |  30 +-
>   drivers/virtio/virtio_pci_common.c       |  59 +-
>   drivers/virtio/virtio_pci_common.h       |   9 +-
>   drivers/virtio/virtio_pci_legacy.c       |  16 +-
>   drivers/virtio/virtio_pci_modern.c       |  24 +-
>   drivers/virtio/virtio_ring.c             | 660 ++++++++++++-----------
>   drivers/virtio/virtio_vdpa.c             |  33 +-
>   include/linux/virtio.h                   |  10 +-
>   include/linux/virtio_config.h            |  48 +-
>   include/linux/virtio_ring.h              |  82 +--
>   tools/virtio/virtio_test.c               |   4 +-
>   tools/virtio/vringh_test.c               |  32 +-
>   17 files changed, 812 insertions(+), 610 deletions(-)
> 
> --
> 2.32.0.3.g01195cf9f
> 


