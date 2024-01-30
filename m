Return-Path: <kvm+bounces-7423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C8A8841A37
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 04:10:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF1CB1C22E9D
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 03:10:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3930159160;
	Tue, 30 Jan 2024 03:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="NQf9FRHE"
X-Original-To: kvm@vger.kernel.org
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FAB236B11;
	Tue, 30 Jan 2024 03:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706583997; cv=none; b=OdhADW65NoTCEjfo08EXD0me0W4mU8mRvtrXsLtlF6RuwLkSGtzBR+NBvoSf93IeZ/9YRr0Td31uXS29sHZFnr7yNctiSwU2o5ypEgujwNb9lXvfdPPuO/bR1eP+YE6oBSQMfDmvzvEyYT/bYSkSvAWK0Pr0si47QJSBDOYxz50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706583997; c=relaxed/simple;
	bh=AlSdtc7beZToOsVWR2g1ctsI2OR5sZGiz84rHZSuX+c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JOKdb8nFT1Oqtsyit7iwcaWSOTR8/7TrOhV+KR08yE1yTi7s2p/e55G3aMQ6bOeDQVCnExHuaMDA5Q02+TxOW1WNwDbm7aG0v89I63KeioYdt8ZSAX6kw+/B5tPxf2+nSORtVTQEnPxI9u0XFtIqPxBNuf9XyjUpDQf9rWfaYTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=NQf9FRHE; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1706583987; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=kSHh4YpKjoP6sPNLBvdLdn6B7QAgtZdbQF3H99FXUtU=;
	b=NQf9FRHE2ZL4CsHQtE2znGDoo4yUNqtycyU/Hrspxu08zPVYFO3Swz9wQsIXFkhuX63TXj9v7J7qoxX1nyGiuKr78S8n/5fo7az9o5wKxJDVL3LRr9yNozV1j9pLuGaq0bNe6/hDCFF/Jpr9wTKbX+hFuGdY1ho9mezZpY7f6s0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R831e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0W.eaYyC_1706583982;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W.eaYyC_1706583982)
          by smtp.aliyun-inc.com;
          Tue, 30 Jan 2024 11:06:23 +0800
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
Subject: [PATCH 11/14] virtio_ring: remove api of setting vq premapped
Date: Tue, 30 Jan 2024 11:06:01 +0800
Message-Id: <20240130030604.108463-12-xuanzhuo@linux.alibaba.com>
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

The virtio-net sets the premapped mode by find_vqs().

So the below API is not used by anyone, we remove it.

int virtqueue_set_dma_premapped(struct virtqueue *_vq);

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 56 ------------------------------------
 include/linux/virtio.h       |  2 --
 2 files changed, 58 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index c0d8522332b2..25ea35499af9 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2838,62 +2838,6 @@ int virtqueue_resize(struct virtqueue *_vq, u32 num,
 }
 EXPORT_SYMBOL_GPL(virtqueue_resize);
 
-/**
- * virtqueue_set_dma_premapped - set the vring premapped mode
- * @_vq: the struct virtqueue we're talking about.
- *
- * Enable the premapped mode of the vq.
- *
- * The vring in premapped mode does not do dma internally, so the driver must
- * do dma mapping in advance. The driver must pass the dma_address through
- * dma_address of scatterlist. When the driver got a used buffer from
- * the vring, it has to unmap the dma address.
- *
- * This function must be called immediately after creating the vq, or after vq
- * reset, and before adding any buffers to it.
- *
- * Caller must ensure we don't call this with other virtqueue operations
- * at the same time (except where noted).
- *
- * Returns zero or a negative error.
- * 0: success.
- * -EINVAL: vring does not use the dma api, so we can not enable premapped mode.
- */
-int virtqueue_set_dma_premapped(struct virtqueue *_vq)
-{
-	struct vring_virtqueue *vq = to_vvq(_vq);
-	u32 num;
-
-	START_USE(vq);
-
-	num = vq->packed_ring ? vq->packed.vring.num : vq->split.vring.num;
-
-	if (num != vq->vq.num_free) {
-		END_USE(vq);
-		return -EINVAL;
-	}
-
-	if (!vq->use_dma_api) {
-		END_USE(vq);
-		return -EINVAL;
-	}
-
-	vq->vq.premapped = true;
-
-	if (vq->packed_ring) {
-		kfree(vq->packed.desc_dma);
-		vq->packed.desc_dma = NULL;
-	} else {
-		kfree(vq->split.desc_dma);
-		vq->split.desc_dma = NULL;
-	}
-
-	END_USE(vq);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(virtqueue_set_dma_premapped);
-
 /**
  * virtqueue_reset - detach and recycle all unused buffers
  * @_vq: the struct virtqueue we're talking about.
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 2e279469277c..8a8d282982ad 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -82,8 +82,6 @@ bool virtqueue_enable_cb(struct virtqueue *vq);
 
 unsigned virtqueue_enable_cb_prepare(struct virtqueue *vq);
 
-int virtqueue_set_dma_premapped(struct virtqueue *_vq);
-
 bool virtqueue_poll(struct virtqueue *vq, unsigned);
 
 bool virtqueue_enable_cb_delayed(struct virtqueue *vq);
-- 
2.32.0.3.g01195cf9f


