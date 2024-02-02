Return-Path: <kvm+bounces-7845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CEC6846CB9
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 10:44:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D77B28FF62
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 09:44:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F43981AA0;
	Fri,  2 Feb 2024 09:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="GmGKGy2r"
X-Original-To: kvm@vger.kernel.org
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD667E769;
	Fri,  2 Feb 2024 09:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706866825; cv=none; b=tIQrpXg67ph9RAGgQ0+N6YBbKA00pfb0zrm9cae66ZIwzP2zP11dkX9MzWiO5qD6Ci52T7e7OAH2ydH2YaIWFfTqS41JkwH4KXYyfe9ueEQFFfEXBeZ9WHAF4wZqLBfBpjtsc6/y20KjB28CleEtKmytLmk8xpYASmk0XVH0Jgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706866825; c=relaxed/simple;
	bh=NNM9tWQnMQInuiN94nJotBSG7mda/K1Qh7QCalmDDpE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BIBTxTS2VLjZ6pPzLIoP/gi8IxK1VXOm3JnER/EDsMwNkuv7V82PgJjfmHOwF5cM+zbXhN2z+BT2x96lQTwzuKXzu6a62AFKVPCxDZ8wnPFjQt8N6IU1xokPL+LYY0uOFZQNmPtLuGHa6OxXVN9jpeGHpHqgx00OUmvsBcAflTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=GmGKGy2r; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1706866820; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=szqnWCRY+3t7jHL1CQv9OY3Vs1PE98SAQIcyewZeW44=;
	b=GmGKGy2rNGNmJp1Y6WVGjBxmTW78AbCxSAQCnuf/GuQ0U1EUr0ufhj7OQHzGTRLvHKyAuwrfIm3KrpdDCdkGTW4tx+j5txFYpgAS8aJ2zrT7XC+LtEgdQaxRBgCyMyP3LgefqmsIEZ5gEyOqPDR5sbS0NzKYGk/OyynHiHhepRI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=36;SR=0;TI=SMTPD_---0W.wiMVl_1706866816;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W.wiMVl_1706866816)
          by smtp.aliyun-inc.com;
          Fri, 02 Feb 2024 17:40:17 +0800
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
Subject: [PATCH vhost v1 15/19] virtio_ring: introduce dma map api for page
Date: Fri,  2 Feb 2024 17:39:47 +0800
Message-Id: <20240202093951.120283-16-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20240202093951.120283-1-xuanzhuo@linux.alibaba.com>
References: <20240202093951.120283-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Git-Hash: 4c7bacd05cb8
Content-Transfer-Encoding: 8bit

The virtio-net sq will use these APIs to map the scatterlist.
For scatterlist, the page dma APIs are more appropriate.

dma_addr_t virtqueue_dma_map_page_attrs(struct virtqueue *_vq, struct page *page,
                                       size_t offset, size_t size,
                                       enum dma_data_direction dir,
                                       unsigned long attrs);
void virtqueue_dma_unmap_page_attrs(struct virtqueue *_vq, dma_addr_t addr,
                                   size_t size, enum dma_data_direction dir,
                                   unsigned long attrs);

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 52 ++++++++++++++++++++++++++++++++++++
 include/linux/virtio.h       |  7 +++++
 2 files changed, 59 insertions(+)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 57b669180e6e..79868967a676 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -3117,6 +3117,58 @@ void virtqueue_dma_unmap_single_attrs(struct virtqueue *_vq, dma_addr_t addr,
 }
 EXPORT_SYMBOL_GPL(virtqueue_dma_unmap_single_attrs);
 
+/**
+ * virtqueue_dma_map_page_attrs - map DMA for _vq
+ * @_vq: the struct virtqueue we're talking about.
+ * @page: the page to do dma
+ * @offset: the offset inside the page
+ * @size: the size of the page to do dma
+ * @dir: DMA direction
+ * @attrs: DMA Attrs
+ *
+ * The caller calls this to do dma mapping in advance. The DMA address can be
+ * passed to this _vq when it is in pre-mapped mode.
+ *
+ * return DMA address. Caller should check that by virtqueue_dma_mapping_error().
+ */
+dma_addr_t virtqueue_dma_map_page_attrs(struct virtqueue *_vq, struct page *page,
+					size_t offset, size_t size,
+					enum dma_data_direction dir,
+					unsigned long attrs)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+
+	if (!vq->use_dma_api)
+		return page_to_phys(page) + offset;
+
+	return dma_map_page_attrs(vring_dma_dev(vq), page, offset, size, dir, attrs);
+}
+EXPORT_SYMBOL_GPL(virtqueue_dma_map_page_attrs);
+
+/**
+ * virtqueue_dma_unmap_page_attrs - unmap DMA for _vq
+ * @_vq: the struct virtqueue we're talking about.
+ * @addr: the dma address to unmap
+ * @size: the size of the buffer
+ * @dir: DMA direction
+ * @attrs: DMA Attrs
+ *
+ * Unmap the address that is mapped by the virtqueue_dma_map_* APIs.
+ *
+ */
+void virtqueue_dma_unmap_page_attrs(struct virtqueue *_vq, dma_addr_t addr,
+				    size_t size, enum dma_data_direction dir,
+				    unsigned long attrs)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+
+	if (!vq->use_dma_api)
+		return;
+
+	dma_unmap_page_attrs(vring_dma_dev(vq), addr, size, dir, attrs);
+}
+EXPORT_SYMBOL_GPL(virtqueue_dma_unmap_page_attrs);
+
 /**
  * virtqueue_dma_mapping_error - check dma address
  * @_vq: the struct virtqueue we're talking about.
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 7f16bacc6c49..8a8d282982ad 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -216,6 +216,13 @@ dma_addr_t virtqueue_dma_map_single_attrs(struct virtqueue *_vq, void *ptr, size
 void virtqueue_dma_unmap_single_attrs(struct virtqueue *_vq, dma_addr_t addr,
 				      size_t size, enum dma_data_direction dir,
 				      unsigned long attrs);
+dma_addr_t virtqueue_dma_map_page_attrs(struct virtqueue *_vq, struct page *page,
+					size_t offset, size_t size,
+					enum dma_data_direction dir,
+					unsigned long attrs);
+void virtqueue_dma_unmap_page_attrs(struct virtqueue *_vq, dma_addr_t addr,
+				    size_t size, enum dma_data_direction dir,
+				    unsigned long attrs);
 int virtqueue_dma_mapping_error(struct virtqueue *_vq, dma_addr_t addr);
 
 bool virtqueue_dma_need_sync(struct virtqueue *_vq, dma_addr_t addr);
-- 
2.32.0.3.g01195cf9f


