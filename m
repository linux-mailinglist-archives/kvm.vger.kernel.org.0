Return-Path: <kvm+bounces-7470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 880B68423E4
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 12:47:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B687C1C25200
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 11:47:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0E5086AD8;
	Tue, 30 Jan 2024 11:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="c/NwOmRY"
X-Original-To: kvm@vger.kernel.org
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDBC67E8D;
	Tue, 30 Jan 2024 11:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706614974; cv=none; b=NilF4segIKstwsH+Ed7rROyx+sYtGoCwfLSuZMdN4OaFtbEeyldpxqwdlp2R71b1R9uz9DhcjSD4c03RiSRuIUjl/BZT2Vbslzl1lkcpCNMqC6lPHVKWeE/fDmuxv4tH5b87ht3ZpB7w0AFIj9A2RGQoev/uyic3TKNnVlCFCQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706614974; c=relaxed/simple;
	bh=oC0A2iqTgzltxNX7HZCNhxU/K71nLhzjfobA+3jDzcI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mgLfMI27fkv7/LpXxEwNc1km7kAHBZDzTlhlR70CFT3ywnWPbbHzudrPNThypOa0who6ygOVd/TbPlky2QWZAAqq1W3PyK4Ronj8ip03umkdn6I5/DzdMa0ylQ+0p+NIbw1Xja/ascuNGt+fj1JOonQHusxcdtwYmUfb732BS8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=c/NwOmRY; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1706614964; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=Dgn6m2tLOO6WFRL4YWGeqj72OqIhjZpHBxeWCefu0YE=;
	b=c/NwOmRYcGH7zZNPG26b2iPGT+oo9sDt7Wn2ZGnjK6cvIMUI9CF4kZu4LIP2bNVrCYzUv9s2DGv3QAVYTpyUa8ppiiT5Ihm2BGIxrjfwvkP5Zu/yUAHHoqzZIkN2YHq/RyrIKUrHbLgTUio1ro/dxNTcQss2jS2IQC2k+cFzzo0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0W.g78-7_1706614961;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W.g78-7_1706614961)
          by smtp.aliyun-inc.com;
          Tue, 30 Jan 2024 19:42:42 +0800
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
Subject: [PATCH vhost 10/17] virtio: find_vqs: add new parameter premapped
Date: Tue, 30 Jan 2024 19:42:17 +0800
Message-Id: <20240130114224.86536-11-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20240130114224.86536-1-xuanzhuo@linux.alibaba.com>
References: <20240130114224.86536-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Git-Hash: 239d1d475be4
Content-Transfer-Encoding: 8bit

If the premapped mode is enabled, the dma array(struct vring_desc_dma) of
virtio core will not be allocated. That is judged when find_vqs() is
called. To avoid allocating dma array in find_vqs() and releasing it
immediately by virtqueue_set_dma_premapped(). This patch introduces a
new parameter to find_vqs(). Then we can judge should we allocate the
dma array(struct vring_desc_dma) or not inside find_vqs().

The driver must check the premapped mode of every vq after find_vqs().

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c  | 4 ++--
 include/linux/virtio_config.h | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 769ec6360d7f..e5e9672b4ab2 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2145,7 +2145,7 @@ static struct virtqueue *vring_create_virtqueue_packed(struct virtio_device *vde
 	vq->packed_ring = true;
 	vq->dma_dev = dma_dev;
 	vq->use_dma_api = vring_use_dma_api(vdev);
-	vq->premapped = false;
+	vq->premapped = vq->use_dma_api && cfg_vq_get(cfg, premapped);
 
 	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
 		!cfg_vq_get(cfg, ctx);
@@ -2687,7 +2687,7 @@ static struct virtqueue *__vring_new_virtqueue(struct virtio_device *vdev,
 #endif
 	vq->dma_dev = tp_cfg->dma_dev;
 	vq->use_dma_api = vring_use_dma_api(vdev);
-	vq->premapped = false;
+	vq->premapped = vq->use_dma_api && cfg_vq_get(cfg, premapped);
 
 	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
 		!cfg_vq_get(cfg, ctx);
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index e2c72e125dae..f462c3f1691c 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -105,6 +105,7 @@ struct virtio_vq_config {
 	vq_callback_t **callbacks;
 	const char *const *names;
 	const bool *ctx;
+	const bool *premapped;
 	struct irq_affinity *desc;
 };
 
-- 
2.32.0.3.g01195cf9f


