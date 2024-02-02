Return-Path: <kvm+bounces-7830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 72797846C5A
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 10:40:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04F611F26D26
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 09:40:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0B537A72D;
	Fri,  2 Feb 2024 09:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="YcGIdsch"
X-Original-To: kvm@vger.kernel.org
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CB777F24;
	Fri,  2 Feb 2024 09:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706866798; cv=none; b=NOUWNXvS0/kXm5f4fmwhPxwgpPJj1Cg4yuqCiXjZqhLtkGh+LmcB3LveLMhliNojOMhikOpyvsGJBpbVCrbgQkHzqDEhZSYCbfB4HC5WUQLSqOOMlmEkWAwo36n0sDFGvQOmgvXg9jHsDjr+ioycO3FN/XN+RcveDXYoC2Kes3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706866798; c=relaxed/simple;
	bh=oNm9Qw7hwiq6aJIott3Cohv2DrbIJbpdeI2rTKx8nhQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SN3vBdrdXTWCJVOxDrSX/9ZgWcfST9x5Pa94d886CpImLs40pMMUhhXkeAHpAKJe/7cpcQuWqSTzdPAg8NOvW4A2JK+kucMVtB6EzCQig6QbnGKhl+9qABo2/mCNEjDspbDMXYentMfpppjLhnl2BlcAEek9pPbUFTxEazymvCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=YcGIdsch; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1706866794; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=peR8A4izAqgzsimxR/4ieXlIWtvCe7qrSUa+LFRRffU=;
	b=YcGIdschgRCM3PRajhnA5CwMhce1rXTi44w+vkk4EqXYOKrWCXadPvkHhlRgnGIDFSPqjIxRkrktIkmvdKUu2uvkVLmUKl2hqrn+PZ+aSamm8MyDg2ucJDn914ppPcHLw4qH5734cP8jIcqvY5lhb598FE10vTtcc2K4M9hvUhQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=36;SR=0;TI=SMTPD_---0W.wc6kr_1706866791;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W.wc6kr_1706866791)
          by smtp.aliyun-inc.com;
          Fri, 02 Feb 2024 17:39:52 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: virtualization@lists.linux.dev
Cc: Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
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
	linux-um@lists.infradead.org,
	netdev@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-remoteproc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	kvm@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [PATCH vhost v1 00/19] virtio: drivers maintain dma info for premapped vq
Date: Fri,  2 Feb 2024 17:39:32 +0800
Message-Id: <20240202093951.120283-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Git-Hash: 4c7bacd05cb8
Content-Transfer-Encoding: 8bit

As discussed:
http://lore.kernel.org/all/CACGkMEvq0No8QGC46U4mGsMtuD44fD_cfLcPaVmJ3rHYqRZxYg@mail.gmail.com

If the virtio is premapped mode, the driver should manage the dma info by self.
So the virtio core should not store the dma info.
So we can release the memory used to store the dma info.

But if the desc_extra has not dma info, we face a new question,
it is hard to get the dma info of the desc with indirect flag.
For split mode, that is easy from desc, but for the packed mode,
it is hard to get the dma info from the desc. And for hardening
the dma unmap is saft, we should store the dma info of indirect
descs.

So I introduce the "structure the indirect desc table" to
allocate space to store dma info with the desc table.

On the other side, we mix the descs with indirect flag
with other descs together to share the unmap api. That
is complex. I found if we we distinguish the descs with
VRING_DESC_F_INDIRECT before unmap, thing will be clearer.

Because of the dma array is allocated in the find_vqs(),
so I introduce a new parameter to find_vqs().

Please review.

Thanks

v1:
    1. rename transport_vq_config to vq_transport_config
    2. virtio-net set dma meta number to (ring-size + 1)(MAX_SKB_FRGAS +2)
    3. introduce virtqueue_dma_map_sg_attrs
    4. separate vring_create_virtqueue to an independent commit

Xuan Zhuo (19):
  virtio_ring: introduce vring_need_unmap_buffer
  virtio_ring: packed: remove double check of the unmap ops
  virtio_ring: packed: structure the indirect desc table
  virtio_ring: split: remove double check of the unmap ops
  virtio_ring: split: structure the indirect desc table
  virtio_ring: no store dma info when unmap is not needed
  virtio: find_vqs: pass struct instead of multi parameters
  virtio: vring_create_virtqueue: pass struct instead of multi
    parameters
  virtio: vring_new_virtqueue(): pass struct instead of multi parameters
  virtio_ring: reuse the parameter struct of find_vqs()
  virtio: find_vqs: add new parameter premapped
  virtio_ring: export premapped to driver by struct virtqueue
  virtio_net: set premapped mode by find_vqs()
  virtio_ring: remove api of setting vq premapped
  virtio_ring: introduce dma map api for page
  virtio_ring: introduce virtqueue_dma_map_sg_attrs
  virtio_net: unify the code for recycling the xmit ptr
  virtio_net: rename free_old_xmit_skbs to free_old_xmit
  virtio_net: sq support premapped mode

 arch/um/drivers/virtio_uml.c             |  31 +-
 drivers/net/virtio_net.c                 | 291 +++++++---
 drivers/platform/mellanox/mlxbf-tmfifo.c |  24 +-
 drivers/remoteproc/remoteproc_virtio.c   |  31 +-
 drivers/s390/virtio/virtio_ccw.c         |  33 +-
 drivers/virtio/virtio_mmio.c             |  30 +-
 drivers/virtio/virtio_pci_common.c       |  59 +-
 drivers/virtio/virtio_pci_common.h       |   9 +-
 drivers/virtio/virtio_pci_legacy.c       |  16 +-
 drivers/virtio/virtio_pci_modern.c       |  24 +-
 drivers/virtio/virtio_ring.c             | 698 ++++++++++++-----------
 drivers/virtio/virtio_vdpa.c             |  45 +-
 include/linux/virtio.h                   |  13 +-
 include/linux/virtio_config.h            |  48 +-
 include/linux/virtio_ring.h              |  82 +--
 tools/virtio/virtio_test.c               |   4 +-
 tools/virtio/vringh_test.c               |  28 +-
 17 files changed, 848 insertions(+), 618 deletions(-)

--
2.32.0.3.g01195cf9f


