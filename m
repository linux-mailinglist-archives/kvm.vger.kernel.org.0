Return-Path: <kvm+bounces-7457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25F0F842381
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 12:43:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A9AD1C2484F
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 11:43:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5A026A34F;
	Tue, 30 Jan 2024 11:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="e5vUpNfi"
X-Original-To: kvm@vger.kernel.org
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562B467E6D;
	Tue, 30 Jan 2024 11:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706614952; cv=none; b=hF5WF3uJqj8de8vkt7q/HgSHxLSJVw2sTRp0dHew0llfFRfj6bF6goSFmvuCVhh4XBVypQ3JxOMWscHHPIYjK1nv4KM+E/gBj65Gnje3YV8+3O+MRBK5zmkVUEoV0MaRcl9IoCZVDsv6yB0DnGHS6/J/Iv/xrW7F2JlbIPzBbkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706614952; c=relaxed/simple;
	bh=QJHQ7cEEaXCBazhOzd1NoFD+b05wQr484Mn9CHClAwI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=P/4zr7oHae7zl7DIM74KnHjNmh8u7woUGTFZmdiHiKOoO3F6ntPTlFP47gSqCYRJJiJ5RpaGraTYYwxTZTQZEwQ0GCboNkQaxduVj2H4yCzdpP7pdm4m9GI40ucR6INvt5GlUgPjYCPIYDsbT5crH7alvsHNojWvQf+aly1rTac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=e5vUpNfi; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1706614947; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=xvo/NohFCvr1cLaN04Uc48tvSWy5BXAIcL5O2TECUPc=;
	b=e5vUpNfism1Uu57i2mN0SEtfLPPrgwzN4FDiK5DPxXBu4IOs5aFXHGalE3i6OgxMaoBCvl6dbweabnIiS1E5/tXHhnBvJepOGS2QtMUq8Xhawm9uCvt2m5WKHzbAuspruSnI/Tkqzb5SRaqb+NgAt2ExMjueAbBwvw2F9l/hws0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R651e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0W.g4wKb_1706614944;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W.g4wKb_1706614944)
          by smtp.aliyun-inc.com;
          Tue, 30 Jan 2024 19:42:25 +0800
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
Subject: [PATCH vhost 00/17] virtio: drivers maintain dma info for premapped vq
Date: Tue, 30 Jan 2024 19:42:07 +0800
Message-Id: <20240130114224.86536-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Git-Hash: 239d1d475be4
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

Xuan Zhuo (17):
  virtio_ring: introduce vring_need_unmap_buffer
  virtio_ring: packed: remove double check of the unmap ops
  virtio_ring: packed: structure the indirect desc table
  virtio_ring: split: remove double check of the unmap ops
  virtio_ring: split: structure the indirect desc table
  virtio_ring: no store dma info when unmap is not needed
  virtio: find_vqs: pass struct instead of multi parameters
  virtio: vring_new_virtqueue(): pass struct instead of multi parameters
  virtio_ring: reuse the parameter struct of find_vqs()
  virtio: find_vqs: add new parameter premapped
  virtio_ring: export premapped to driver by struct virtqueue
  virtio_net: set premapped mode by find_vqs()
  virtio_ring: remove api of setting vq premapped
  virtio_ring: introduce dma map api for page
  virtio_net: unify the code for recycling the xmit ptr
  virtio_net: rename free_old_xmit_skbs to free_old_xmit
  virtio_net: sq support premapped mode

 arch/um/drivers/virtio_uml.c             |  29 +-
 drivers/net/virtio_net.c                 | 298 +++++++---
 drivers/platform/mellanox/mlxbf-tmfifo.c |  24 +-
 drivers/remoteproc/remoteproc_virtio.c   |  31 +-
 drivers/s390/virtio/virtio_ccw.c         |  33 +-
 drivers/virtio/virtio_mmio.c             |  30 +-
 drivers/virtio/virtio_pci_common.c       |  59 +-
 drivers/virtio/virtio_pci_common.h       |   9 +-
 drivers/virtio/virtio_pci_legacy.c       |  16 +-
 drivers/virtio/virtio_pci_modern.c       |  24 +-
 drivers/virtio/virtio_ring.c             | 660 ++++++++++++-----------
 drivers/virtio/virtio_vdpa.c             |  33 +-
 include/linux/virtio.h                   |  10 +-
 include/linux/virtio_config.h            |  48 +-
 include/linux/virtio_ring.h              |  82 +--
 tools/virtio/virtio_test.c               |   4 +-
 tools/virtio/vringh_test.c               |  32 +-
 17 files changed, 812 insertions(+), 610 deletions(-)

--
2.32.0.3.g01195cf9f


