Return-Path: <kvm+bounces-9483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E4ADA860C4D
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 09:27:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5A5AD1F26E9A
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 08:27:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 357FF18E17;
	Fri, 23 Feb 2024 08:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="GBM3BbD9"
X-Original-To: kvm@vger.kernel.org
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9DB17BCA;
	Fri, 23 Feb 2024 08:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708676854; cv=none; b=sn0kivRAg9juT+ohk/puGMjc8JtmAFrlPv7y5bCIg/yYsWsFXN1xK0XBHu5n2T9LYh1CQVosdNuC3+HBx8hDW/4O9yTzTyY/bmxroFcdGn8ReFvfeP8pssl0oPwoz5pj4l315K12kucKaIyOXpjMwN5FrChtJneBGLnmk+Ixdkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708676854; c=relaxed/simple;
	bh=w3BsJ+f3eZKtx/7tMyq5btu/xQSNKLUSLFPhco7OJNI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iAVNUeyOzk991b+k7fxO9aU9hoIfrHx1A6xXJPgBJCd3xbuRtSsteQekr3QSimUNQeqcWaDqwnU7MuHUpLWiKnLNiLu9CSlgJ/m8Ndr7wL3QxNKgg2UVI+Fl0J0XZsuUlQa3Wj0pU0u5UjI7guxj6bvKhMrxkZrfEgwpP/vQTa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=GBM3BbD9; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1708676848; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=QYXOQ6Cn7P8NNIEh4wiuPCzjHwvOSRqXsUiYMGC89fw=;
	b=GBM3BbD9AXBV4HdmOomJT79WhPgvOr2caQBRcvjmxogzMihVUtV2yCq/Efnm9FPS194bB/Ww/GWvAfswRgi8Ssl9Z/1Z2pj8sR9CN4rrL5ADRx0N5L5kLRO2mlTrAFcmiWKJWId7ekPmNMUkw7byeyBOuKE0Dfd4czinK10F/h0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R401e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=35;SR=0;TI=SMTPD_---0W13mUuX_1708676846;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W13mUuX_1708676846)
          by smtp.aliyun-inc.com;
          Fri, 23 Feb 2024 16:27:27 +0800
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
	linux-um@lists.infradead.org,
	netdev@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-remoteproc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	kvm@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [PATCH vhost v2 00/19] virtio: drivers maintain dma info for premapped vq
Date: Fri, 23 Feb 2024 16:27:07 +0800
Message-Id: <20240223082726.52915-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Git-Hash: 510995f33855
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

Note:
    this is on the top of
        [PATCH vhost v1] virtio: packed: fix unmap leak for indirect desc table
        http://lore.kernel.org/all/20240223071833.26095-1-xuanzhuo@linux.alibaba.com

Please review.

Thanks

v2:
    1. change the dma item of virtio-net, every item have MAX_SKB_FRAGS + 2
        addr + len pairs.
    2. introduce virtnet_sq_free_stats for __free_old_xmit

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
  virtio_ring: simplify the parameters of the funcs related to
    vring_create/new_virtqueue()
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
 drivers/net/virtio_net.c                 | 283 ++++++---
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
 17 files changed, 835 insertions(+), 623 deletions(-)

--
2.32.0.3.g01195cf9f


