Return-Path: <kvm+bounces-10452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA6D786C258
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 08:26:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 83140B275CB
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:26:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBBFF5786D;
	Thu, 29 Feb 2024 07:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="RaA8AsD4"
X-Original-To: kvm@vger.kernel.org
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1804156B72;
	Thu, 29 Feb 2024 07:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709191280; cv=none; b=nRNutN3QXZ1ZVCqjTuMuweSZnbImPexTRuHZn+Wrijk41EMGrc3bGpRs6UGKT9QUtRFodNFhMe0qol2LgA7rHakYYxzatmK+yCHPwbe9Dd8cAHTCxSrnf4mqWQadMoExMc1lzFYc14AHZCQSKXPzT0HPRzJHgGtUUMKftDPzEOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709191280; c=relaxed/simple;
	bh=nufMRbXLj+YSuSWmljSpMKFk1LTW93GH2wujXElJyos=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cWWOXQ0F8ekx62nygxp5E4lTkEQF3wf4w7oQxFtnelhcbQX8QXj1Q2Zt+MlaveWC/TVH2x2Y5OxQ/yzYNVWYX9FgLB2a1tIiKvJcRpxjTpDrjwx1uKP8O16LrIG+XrjLLRkXsRn4adnpTXMzgV7dy0WR7f0HON67bRI5hs6NP48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=RaA8AsD4; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1709191275; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=d8VgurjiHoufBNHjBHr2ztXStBXU+RItFeIKBycQigI=;
	b=RaA8AsD4XFUI3H1+kM//zJQd124GKDGOJ6u0o79ljEJ3RAxx3KthiDlqnBkXp473svyns+/d/HzTEalaTSviTWSMbiUqJi5We9T7G9y7Hprj/eD6gjXoeQp5Ains/8SCgkiMuAqEBOSBlzYYAyxOPGSCWMYWt/pZ1OaJfvq+yP8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R661e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=35;SR=0;TI=SMTPD_---0W1SBcCO_1709191270;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W1SBcCO_1709191270)
          by smtp.aliyun-inc.com;
          Thu, 29 Feb 2024 15:21:11 +0800
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
Subject: [PATCH vhost v3 16/19] virtio_ring: introduce virtqueue_dma_map_sg_attrs
Date: Thu, 29 Feb 2024 15:20:41 +0800
Message-Id: <20240229072044.77388-17-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20240229072044.77388-1-xuanzhuo@linux.alibaba.com>
References: <20240229072044.77388-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Git-Hash: e3a3e51d6b70
Content-Transfer-Encoding: 8bit

Introduce a helper to do dma map for scatterlist.
That can be used by other drivers.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 32 ++++++++++++++++++++++++++++++++
 include/linux/virtio.h       |  3 +++
 2 files changed, 35 insertions(+)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index df7633155558..3f790fa3d56a 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -3187,6 +3187,38 @@ int virtqueue_dma_mapping_error(struct virtqueue *_vq, dma_addr_t addr)
 }
 EXPORT_SYMBOL_GPL(virtqueue_dma_mapping_error);
 
+/**
+ * virtqueue_dma_map_sg_attrs - map scatterlist addr DMA for _vq
+ * @_vq: the struct virtqueue we're talking about.
+ * @sg: the scatterlist to do dma
+ * @dir: DMA direction
+ * @attrs: DMA Attrs
+ *
+ * The caller calls this to do dma mapping in advance. The sg can be
+ * passed to this _vq when it is in pre-mapped mode.
+ *
+ * Returns zero or a negative error.
+ *   0: success
+ *   -ENOMEM: dma map error
+ */
+int virtqueue_dma_map_sg_attrs(struct virtqueue *_vq, struct scatterlist *sg,
+			       enum dma_data_direction dir, unsigned long attrs)
+{
+	dma_addr_t addr;
+	int err;
+
+	addr = virtqueue_dma_map_page_attrs(_vq, sg_page(sg), sg->offset,
+					    sg->length, dir, attrs);
+	err = virtqueue_dma_mapping_error(_vq, addr);
+	if (err)
+		return err;
+
+	sg->dma_address = addr;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(virtqueue_dma_map_sg_attrs);
+
 /**
  * virtqueue_dma_need_sync - check a dma address needs sync
  * @_vq: the struct virtqueue we're talking about.
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index b81b93b3eb27..5027eba82fda 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -233,6 +233,9 @@ void virtqueue_dma_unmap_page_attrs(struct virtqueue *_vq, dma_addr_t addr,
 				    unsigned long attrs);
 int virtqueue_dma_mapping_error(struct virtqueue *_vq, dma_addr_t addr);
 
+int virtqueue_dma_map_sg_attrs(struct virtqueue *_vq, struct scatterlist *sg,
+			       enum dma_data_direction dir, unsigned long attrs);
+
 bool virtqueue_dma_need_sync(struct virtqueue *_vq, dma_addr_t addr);
 void virtqueue_dma_sync_single_range_for_cpu(struct virtqueue *_vq, dma_addr_t addr,
 					     unsigned long offset, size_t size,
-- 
2.32.0.3.g01195cf9f


