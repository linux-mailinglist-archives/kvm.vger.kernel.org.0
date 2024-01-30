Return-Path: <kvm+bounces-7411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 268578419E8
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 04:06:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 598541C22665
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 03:06:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 441B137712;
	Tue, 30 Jan 2024 03:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="hjdEk9Jx"
X-Original-To: kvm@vger.kernel.org
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCB23715F;
	Tue, 30 Jan 2024 03:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706583978; cv=none; b=iwPvgY0ewWW22YJkmrVbVhHMaY00wIVLVYRZrh1UPcU5vnmuZxDP7bnGd/mGpls5XXiB2ejAeHe7CRzPRziXKISas2OeLDKZsz3dkTY7yto5xiSyDOqSYYyXIxV/oxK6JnFdIocckalcyHN7ItIVO9f36O2jb9bo6JS6TIclqDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706583978; c=relaxed/simple;
	bh=TpFGPtLON7jGs4kAqQFeETmjHlS5R4uqx/XXd34jKhs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=V81aXiZAHQNENMpF+K28K463SU6PqTFmdY16fJcTcTGW47gBpXznlqe8XiXLDnLal/WCzD9wdiXphzW+2aNYBUcM4o8O+L3mKhr8Jr2QXW1HBBSe3FHZ/xYvTXvYgGHPEeh3MbO/GFtvztAjBvKpyw6RDs1k6Y93D6GTYs23MZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=hjdEk9Jx; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1706583967; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=i7H1e1h0ThqkOkneFCDnfocnYVEAg1d5gx5A0zimKdU=;
	b=hjdEk9Jx8/j40QuY5kndoalZFDwtaL/Owqxr0X/LgAbAdg8EdbTXYwYk1qWlMWPQ5JwImuvlSsOs8tQZi5rAIEOteVnNHv98/+6s9RmflCi5RW6/OxaMpg4zi2AuDfksYHZ7lbMulsi56R0wAN9aaLljfIle86bIJ8bBneROQdg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0W.eZo9q_1706583965;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W.eZo9q_1706583965)
          by smtp.aliyun-inc.com;
          Tue, 30 Jan 2024 11:06:06 +0800
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
	Yang Li <yang.lee@linux.alibaba.com>,
	linux-um@lists.infradead.org,
	netdev@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-remoteproc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	kvm@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [PATCH vhost 00/14] virtio remove dma info for premapped mode
Date: Tue, 30 Jan 2024 11:05:50 +0800
Message-Id: <20240130030604.108463-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Git-Hash: ce068f9b825d
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

Xuan Zhuo (14):
  virtio_ring: introduce vring_need_unmap_buffer
  virtio_ring: packed: remove double check of the unmap ops
  virtio_ring: packed: structure the indirect desc table
  virtio_ring: split: remove double check of the unmap ops
  virtio_ring: split: structure the indirect desc table
  virtio_ring: no store dma info when unmap is not needed
  virtio_ring: introduce dma map api for page
  virtio: find_vqs introduce premapped parameter
  virtio_ring: export premapped to driver by struct virtqueue
  virtio_net: set premapped mode by find_vqs()
  virtio_ring: remove api of setting vq premapped
  virtio_net: unify the code for recycling the xmit ptr
  virtio_net: rename free_old_xmit_skbs to free_old_xmit
  virtio_net: sq support premapped mode

 arch/um/drivers/virtio_uml.c             |   5 +-
 drivers/net/virtio_net.c                 | 291 +++++++++----
 drivers/platform/mellanox/mlxbf-tmfifo.c |   3 +-
 drivers/remoteproc/remoteproc_virtio.c   |   9 +-
 drivers/s390/virtio/virtio_ccw.c         |   8 +-
 drivers/virtio/virtio_mmio.c             |   8 +-
 drivers/virtio/virtio_pci_common.c       |  15 +-
 drivers/virtio/virtio_pci_common.h       |   2 +
 drivers/virtio/virtio_pci_legacy.c       |   3 +-
 drivers/virtio/virtio_pci_modern.c       |   6 +-
 drivers/virtio/virtio_ring.c             | 511 +++++++++++++----------
 drivers/virtio/virtio_vdpa.c             |   6 +-
 include/linux/virtio.h                   |  10 +-
 include/linux/virtio_config.h            |  19 +-
 include/linux/virtio_ring.h              |   3 +
 tools/virtio/linux/virtio.h              |   1 +
 tools/virtio/virtio_test.c               |   2 +-
 tools/virtio/vringh_test.c               |  10 +-
 18 files changed, 585 insertions(+), 327 deletions(-)

--
2.32.0.3.g01195cf9f


