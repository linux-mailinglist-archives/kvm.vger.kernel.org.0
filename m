Return-Path: <kvm+bounces-10456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C48A986C35A
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 09:21:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7AE05282861
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 08:21:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E41D5025E;
	Thu, 29 Feb 2024 08:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UkqZuhdJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DAE34B5DA
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 08:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709194892; cv=none; b=ccf3dzav5i1O1yaCg/qXS1b15iHUkUggchKENlzugx1oXpIzq9icOA3hvqKbeIABTcQyx4YjEYs7LVGHTb4TUOnzggabEBc82wBCV/WpfWorAUul5Osf4AFVhp9sxqRgpU5w0lRZMkPfqV7ibrTrtRTYj1yF94lKLE792X/E1hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709194892; c=relaxed/simple;
	bh=WU7ffeSphhs/r9s6sbUYBG4gjwSJ/QhbvB2NXAEgqLU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=InzRJ0kjJuqch8ctBMTvwCJ/nuMSDlcP6k7ZJTkvDUI6XL+0eBYg9H7c93/GGR3olHbigMwIh38q9jWyBgtavhOD5ky9B3xs4SudFyMuOF0eGveZwAQHYMJh+0j1+uZvxE/Q+ttq/IBtx80LtDLrPsrzhLLq/YvaisI45ONbtyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UkqZuhdJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709194889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yYWjbn49/FOaKnxv8tY8E/wAWpBZLZbrgSR43I6LPzc=;
	b=UkqZuhdJCRQ92srziGQ6PSpCoIlkdZdv7SiBfTeqI6BQpQ0xOpzKQGPRYcdZlDM/In61vh
	TFg6xaSOZzwGJ8e41dHHu5sX3Lv9HUJAMu413NbZa/9VNVtvhlmVaGS6/Y3Upz/XjYivgy
	m/A2Uzw7CLoEVfUVj6vz9LJ7j8HUCYE=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-8XNULMxTMC21RQN0o0vRSg-1; Thu, 29 Feb 2024 03:21:24 -0500
X-MC-Unique: 8XNULMxTMC21RQN0o0vRSg-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-512aacf66d1so388040e87.3
        for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 00:21:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709194883; x=1709799683;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yYWjbn49/FOaKnxv8tY8E/wAWpBZLZbrgSR43I6LPzc=;
        b=Xy8++7VV9PeBeHYb8dWk1YLSu2rIXdVWtVVQkwXca1+q+oXtVkd1BwbHNfTwJPgjlZ
         VHdOffRQ56/bguqXUXflebD2LFGo6FUXUDFefVWcXIzxrpyhDbV6VvmO92n2CXZypCJl
         3mHbO2UC6lASx1lk6MU1zzh0GWIEYxj6g2Uez5Re0ITa27sdWImvN7xU9N1EYp8g2AVL
         ZmEXPie+lelOP3Vq6Bot36zx57aWepVdk0W64X0JOnT/HdN0K6PVAhn3d8N8GghHFRPs
         7icECzeZBMXIXKK0CBfbkPKRsprziUOHOpuNZHkSELffi0k6BU/V6I7/er5Ha7QaTgF5
         +dRg==
X-Forwarded-Encrypted: i=1; AJvYcCXuEM4MVV/dUormYWZ2yOUlWkyqoG+CI9H4n+6SF3SBOs9hwITabO2wz9ZYyqHFE3QN3vw3U2Y/w1pe+negjOPkp5ZG
X-Gm-Message-State: AOJu0YyLX4F6tUJ9EeTAMSSJDrLBGpP6zDyFeNc4rgtZ1pNLUpBvia8e
	Q1rNSHbrtnxeyWYMhVhnP1rLIK6hFUwj7kRM/PtAVtTdYamBNXnQ07tskJU1QdpbtkNqx+9E0Lj
	1WHqzfd2txyHDpQu7forIw25EH9VWZZ5988AcerMq5LUWgrCXbg==
X-Received: by 2002:a05:6512:2388:b0:513:26e7:440c with SMTP id c8-20020a056512238800b0051326e7440cmr679720lfv.61.1709194883523;
        Thu, 29 Feb 2024 00:21:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHnM+zAIJHxVsYzJ0TLR9J0gKcOujhg4JzZrjGf+sjNfANqyY2DOR0YHjNv8O6HjvN3PHqhFQ==
X-Received: by 2002:a05:6512:2388:b0:513:26e7:440c with SMTP id c8-20020a056512238800b0051326e7440cmr679694lfv.61.1709194883093;
        Thu, 29 Feb 2024 00:21:23 -0800 (PST)
Received: from redhat.com ([2a02:14f:178:d6b0:a21c:61c4:2098:5db])
        by smtp.gmail.com with ESMTPSA id bt6-20020a056000080600b0033db9383e70sm1078294wrb.81.2024.02.29.00.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Feb 2024 00:21:22 -0800 (PST)
Date: Thu, 29 Feb 2024 03:21:14 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: virtualization@lists.linux.dev, Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
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
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	linux-um@lists.infradead.org, netdev@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
	kvm@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH vhost v3 00/19] virtio: drivers maintain dma info for
 premapped vq
Message-ID: <20240229031755-mutt-send-email-mst@kernel.org>
References: <20240229072044.77388-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240229072044.77388-1-xuanzhuo@linux.alibaba.com>

On Thu, Feb 29, 2024 at 03:20:25PM +0800, Xuan Zhuo wrote:
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
> Note:
>     this is on the top of
>         [PATCH vhost v1] virtio: packed: fix unmap leak for indirect desc table
>         http://lore.kernel.org/all/20240223071833.26095-1-xuanzhuo@linux.alibaba.com
> 
> Please review.
> 
> Thanks
> 
> v3:
>     1. fix the conflict with the vp_modern_create_avq().

Okay but are you going to address huge memory waste all this is causing for
- people who never do zero copy
- systems where dma unmap is a nop

?

You should address all comments when you post a new version, not just
what was expedient, or alternatively tag patch as RFC and explain
in commit log that you plan to do it later.

> v2:
>     1. change the dma item of virtio-net, every item have MAX_SKB_FRAGS + 2
>         addr + len pairs.
>     2. introduce virtnet_sq_free_stats for __free_old_xmit
> 
> v1:
>     1. rename transport_vq_config to vq_transport_config
>     2. virtio-net set dma meta number to (ring-size + 1)(MAX_SKB_FRGAS +2)
>     3. introduce virtqueue_dma_map_sg_attrs
>     4. separate vring_create_virtqueue to an independent commit
> 
> 
> 
> Xuan Zhuo (19):
>   virtio_ring: introduce vring_need_unmap_buffer
>   virtio_ring: packed: remove double check of the unmap ops
>   virtio_ring: packed: structure the indirect desc table
>   virtio_ring: split: remove double check of the unmap ops
>   virtio_ring: split: structure the indirect desc table
>   virtio_ring: no store dma info when unmap is not needed
>   virtio: find_vqs: pass struct instead of multi parameters
>   virtio: vring_create_virtqueue: pass struct instead of multi
>     parameters
>   virtio: vring_new_virtqueue(): pass struct instead of multi parameters
>   virtio_ring: simplify the parameters of the funcs related to
>     vring_create/new_virtqueue()
>   virtio: find_vqs: add new parameter premapped
>   virtio_ring: export premapped to driver by struct virtqueue
>   virtio_net: set premapped mode by find_vqs()
>   virtio_ring: remove api of setting vq premapped
>   virtio_ring: introduce dma map api for page
>   virtio_ring: introduce virtqueue_dma_map_sg_attrs
>   virtio_net: unify the code for recycling the xmit ptr
>   virtio_net: rename free_old_xmit_skbs to free_old_xmit
>   virtio_net: sq support premapped mode
> 
>  arch/um/drivers/virtio_uml.c             |  31 +-
>  drivers/net/virtio_net.c                 | 283 ++++++---
>  drivers/platform/mellanox/mlxbf-tmfifo.c |  24 +-
>  drivers/remoteproc/remoteproc_virtio.c   |  31 +-
>  drivers/s390/virtio/virtio_ccw.c         |  33 +-
>  drivers/virtio/virtio_mmio.c             |  30 +-
>  drivers/virtio/virtio_pci_common.c       |  59 +-
>  drivers/virtio/virtio_pci_common.h       |   9 +-
>  drivers/virtio/virtio_pci_legacy.c       |  16 +-
>  drivers/virtio/virtio_pci_modern.c       |  38 +-
>  drivers/virtio/virtio_ring.c             | 698 ++++++++++++-----------
>  drivers/virtio/virtio_vdpa.c             |  45 +-
>  include/linux/virtio.h                   |  13 +-
>  include/linux/virtio_config.h            |  48 +-
>  include/linux/virtio_ring.h              |  82 +--
>  tools/virtio/virtio_test.c               |   4 +-
>  tools/virtio/vringh_test.c               |  28 +-
>  17 files changed, 847 insertions(+), 625 deletions(-)
> 
> --
> 2.32.0.3.g01195cf9f


