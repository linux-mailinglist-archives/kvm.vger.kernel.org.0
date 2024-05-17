Return-Path: <kvm+bounces-17563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 34D5E8C7F8F
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 03:31:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A0B82B222AD
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 01:31:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FFF61854;
	Fri, 17 May 2024 01:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="n3O8ywTo"
X-Original-To: kvm@vger.kernel.org
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E628BEE;
	Fri, 17 May 2024 01:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715909460; cv=none; b=gZL/9sbE+CLLl2NRjjfeVp/z1fs7idOWJaUjvwrHKfwg6r6/qEuCblh6xql5U7P5BXA9GEYLCCEbNJtx9XLqErn41+CITR773/lPsDUnJTd0HrWN6PaTKRa+jTaN2FkmW6VovEdEw9epb10BkP3j1eze9EAEFY9Lu6O7XeDKQow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715909460; c=relaxed/simple;
	bh=aHQtSq3DOcQQu9w62vM/PGD8H1BowW3iosax14z4l7Q=;
	h=Message-ID:Subject:Date:From:To:Cc:References:In-Reply-To; b=eTUfVUhEevAEWgDHa5NYLXX4pbQhPfOK8ongB6ztKxLzs6jtm9EZk3uRvOZuG/dJIFUy+Ls9yQm0t4PzHWHjNc0ojIz5b9S+tCPjtbrMoocrLOGWvQ2jDvhq6OkcZ92eR7lts16iA3kEGCy6/o3PUhZuzgc3nQiI1PEjHiug51I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=n3O8ywTo; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1715909449; h=Message-ID:Subject:Date:From:To;
	bh=KrEPs691Td3NZbxOFWTzxJL2b3bXbcRVeAlZkrnOcRA=;
	b=n3O8ywTorffYP9O84pRwyDfc/Ey4mGW1ZhRnPY32EMomgg0Eo3qRq+/a7TYCDtacbOIwW9opTn1ihzSERvgVNcLjF6ws6fc7sz14mVTBfFJj9GV1M0JBSu4M4l1YI0OBW9O5TG283dqi5FQooW65l+K4A2WGXlePA/FFySrqzU0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033022160150;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=26;SR=0;TI=SMTPD_---0W6cslx7_1715909446;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W6cslx7_1715909446)
          by smtp.aliyun-inc.com;
          Fri, 17 May 2024 09:30:47 +0800
Message-ID: <1715909158.0435698-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost v9 0/6] refactor the params of find_vqs()
Date: Fri, 17 May 2024 09:25:58 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: Richard Weinberger <richard@nod.at>,
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
 Jason Wang <jasowang@redhat.com>,
 linux-um@lists.infradead.org,
 platform-driver-x86@vger.kernel.org,
 linux-remoteproc@vger.kernel.org,
 linux-s390@vger.kernel.org,
 kvm@vger.kernel.org,
 virtualization@lists.linux.dev
References: <20240424091533.86949-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20240424091533.86949-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Hi, Michael

I hope this in your for_linus branch to merge to Linux 6.9.

	https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/log/?h=linux-next

And some commits from me in your branch are changed after you picked them.
And there are merged by net-next.

virtio_net: remove the misleading comment
virtio_net: rx remove premapped failover code
virtio_net: enable premapped by default
virtio_net: big mode support premapped
virtio_net: replace private by pp struct inside page
virtio_ring: enable premapped mode whatever use_dma_api
virtio_ring: introduce dma map api for page

Thanks.



On Wed, 24 Apr 2024 17:15:27 +0800, Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> This pathset is splited from the
>
>      http://lore.kernel.org/all/20240229072044.77388-1-xuanzhuo@linux.alibaba.com
>
> That may needs some cycles to discuss. But that notifies too many people.
>
> But just the four commits need to notify so many people.
> And four commits are independent. So I split that patch set,
> let us review these first.
>
> The patch set try to  refactor the params of find_vqs().
> Then we can just change the structure, when introducing new
> features.
>
> Thanks.
>
> v8:
>   1. rebase the vhost branch
>
> v7:
>   1. fix two bugs. @Jason
>
> v6:
>   1. virtio_balloon: a single variable for both purposes.
>   2. if names[i] is null, return error
>
> v5:
>   1. virtio_balloon: follow David Hildenbrand's suggest
>     http://lore.kernel.org/all/3620be9c-e288-4ff2-a7be-1fcf806e6e6e@redhat.com
>   2. fix bug of the reference of "cfg_idx"
>     http://lore.kernel.org/all/202403222227.Sdp23Lcb-lkp@intel.com
>
> v4:
>   1. remove support for names array entries being null
>   2. remove cfg_idx from virtio_vq_config
>
> v3:
>   1. fix the bug: "assignment of read-only location '*cfg.names'"
>
> v2:
>   1. add kerneldoc for "struct vq_transport_config" @ilpo.jarvinen
>
> v1:
>   1. fix some comments from ilpo.jarvinen@linux.intel.com
>
>
>
>
>
>
>
>
>
> Xuan Zhuo (6):
>   virtio_balloon: remove the dependence where names[] is null
>   virtio: remove support for names array entries being null.
>   virtio: find_vqs: pass struct instead of multi parameters
>   virtio: vring_create_virtqueue: pass struct instead of multi
>     parameters
>   virtio: vring_new_virtqueue(): pass struct instead of multi parameters
>   virtio_ring: simplify the parameters of the funcs related to
>     vring_create/new_virtqueue()
>
>  arch/um/drivers/virtio_uml.c             |  36 +++--
>  drivers/platform/mellanox/mlxbf-tmfifo.c |  23 +--
>  drivers/remoteproc/remoteproc_virtio.c   |  37 +++--
>  drivers/s390/virtio/virtio_ccw.c         |  38 ++---
>  drivers/virtio/virtio_balloon.c          |  48 +++---
>  drivers/virtio/virtio_mmio.c             |  36 +++--
>  drivers/virtio/virtio_pci_common.c       |  69 ++++-----
>  drivers/virtio/virtio_pci_common.h       |   9 +-
>  drivers/virtio/virtio_pci_legacy.c       |  16 +-
>  drivers/virtio/virtio_pci_modern.c       |  37 +++--
>  drivers/virtio/virtio_ring.c             | 177 ++++++++---------------
>  drivers/virtio/virtio_vdpa.c             |  51 +++----
>  include/linux/virtio_config.h            |  76 +++++++---
>  include/linux/virtio_ring.h              |  93 +++++++-----
>  tools/virtio/virtio_test.c               |   4 +-
>  tools/virtio/vringh_test.c               |  28 ++--
>  16 files changed, 384 insertions(+), 394 deletions(-)
>
> --
> 2.32.0.3.g01195cf9f
>

