Return-Path: <kvm+bounces-7421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F42E841A2A
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 04:09:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C24901F28FA8
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 03:09:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 344A758120;
	Tue, 30 Jan 2024 03:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="EpBPppam"
X-Original-To: kvm@vger.kernel.org
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5EB55E68;
	Tue, 30 Jan 2024 03:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706583993; cv=none; b=XShbmnq7zgUnxRsE26Ns7kTbxhYWhjGybnWFIwAnjcK2XjtAFi5KWvw6lZAxI4i7fjXA4qVCZXaLzrkGZHovw18CLYjkV9jW1klaGSh/cHvxml7jYn5POKTB5JhEdwM/pW6g0TYlSlTHmsVI60G50Xz2BO8U2dVYUaqGx7DSbW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706583993; c=relaxed/simple;
	bh=7d8yZ0XltJ9CN6IXq8sv7pKckuDmlQaD3bgvZ2VD1lQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J4Ot3TISCb4tK8JAWvKni0UDzvHHzfUjJ4RN0rc7/NrznREYwWSLisl2CI36YJjqATNl8rjegPJNK2YwAE/rNghQekaEseK56Jm1fa6yvAWEXHbZC/WpDb4JAupi0EvCpAtgiufwHBc1lWELUeZmVLUUFIriJzKgcAU8MERxreU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=EpBPppam; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1706583983; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=qt3C0IgNOS3wKLdgDjV5YUtjOHXeCb5dvcmcCFV4wb8=;
	b=EpBPppamsHt3nyv6oQa8GVkXZzHtJvZrZeyWBxLKpx4yXlUX0vQ/AlE8sOGxkZRfoDNNwn4P5MFDLcEacKVgqeOs8oPcX4sAYxd3FhYxzb7QqIK3E8OjhfF6LlN37YDrNTXZFp6Y6zk+IcHgOkZ6NKvpSuQ/BbBX/qHeVFKSeO0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0W.eeCDd_1706583979;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W.eeCDd_1706583979)
          by smtp.aliyun-inc.com;
          Tue, 30 Jan 2024 11:06:20 +0800
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
Subject: [PATCH 09/14] virtio_ring: export premapped to driver by struct virtqueue
Date: Tue, 30 Jan 2024 11:05:59 +0800
Message-Id: <20240130030604.108463-10-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20240130030604.108463-1-xuanzhuo@linux.alibaba.com>
References: <20240130030604.108463-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Git-Hash: ce068f9b825d
Content-Transfer-Encoding: 8bit

Export the premapped to drivers, then drivers can check
the vq premapped mode after the find_vqs().
Because the find_vqs() just try to enable the vq premapped mode,
the driver must check that after find_vqs().

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 17 +++++++----------
 include/linux/virtio.h       |  1 +
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 11a131c22f7e..c0d8522332b2 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -191,9 +191,6 @@ struct vring_virtqueue {
 	/* Host publishes avail event idx */
 	bool event;
 
-	/* Do DMA mapping by driver */
-	bool premapped;
-
 	/* Head of free buffer list. */
 	unsigned int free_head;
 	/* Number we've added since last sync. */
@@ -314,7 +311,7 @@ static bool vring_use_dma_api(const struct virtio_device *vdev)
 
 static bool vring_need_unmap_buffer(const struct vring_virtqueue *vring)
 {
-	return vring->use_dma_api && !vring->premapped;
+	return vring->use_dma_api && !vring->vq.premapped;
 }
 
 size_t virtio_max_dma_size(const struct virtio_device *vdev)
@@ -386,7 +383,7 @@ static struct device *vring_dma_dev(const struct vring_virtqueue *vq)
 static int vring_map_one_sg(const struct vring_virtqueue *vq, struct scatterlist *sg,
 			    enum dma_data_direction direction, dma_addr_t *addr)
 {
-	if (vq->premapped) {
+	if (vq->vq.premapped) {
 		*addr = sg_dma_address(sg);
 		return 0;
 	}
@@ -2158,9 +2155,9 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	vq->use_dma_api = vring_use_dma_api(vdev);
 
 	if (premapped && vq->use_dma_api)
-		vq->premapped = true;
+		vq->vq.premapped = true;
 	else
-		vq->premapped = false;
+		vq->vq.premapped = false;
 
 	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
 		!context;
@@ -2709,9 +2706,9 @@ static struct virtqueue *__vring_new_virtqueue(unsigned int index,
 	vq->use_dma_api = vring_use_dma_api(vdev);
 
 	if (premapped && vq->use_dma_api)
-		vq->premapped = true;
+		vq->vq.premapped = true;
 	else
-		vq->premapped = false;
+		vq->vq.premapped = false;
 
 	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
 		!context;
@@ -2881,7 +2878,7 @@ int virtqueue_set_dma_premapped(struct virtqueue *_vq)
 		return -EINVAL;
 	}
 
-	vq->premapped = true;
+	vq->vq.premapped = true;
 
 	if (vq->packed_ring) {
 		kfree(vq->packed.desc_dma);
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 856b9f16e47b..2e279469277c 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -36,6 +36,7 @@ struct virtqueue {
 	unsigned int num_free;
 	unsigned int num_max;
 	bool reset;
+	bool premapped;
 	void *priv;
 };
 
-- 
2.32.0.3.g01195cf9f


