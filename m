Return-Path: <kvm+bounces-15773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45DD58B05BB
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 11:16:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 695B31C23BB5
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 09:16:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E7D6158DC9;
	Wed, 24 Apr 2024 09:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="p8Wtd7t/"
X-Original-To: kvm@vger.kernel.org
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C79D158D88;
	Wed, 24 Apr 2024 09:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713950142; cv=none; b=cm/rikoZC+ybIzpJUsj/NSM/xSmq4F+EJPWUdn+ZPz2ODrfI6zD/Va3eM/0fUoN7UDs6PHXpqLmfZ3b+o0osODFr0ASbT3totZ1S/+EPj07ZZmxRqHrwSGQIQvMuyFfbup2AuKWleOQJscaBkY3dLXS2DlSyeD+kfrnWFx9nuIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713950142; c=relaxed/simple;
	bh=J2kTNhRF0qBZSU5QLEkSSjtErM2pH/gaTZdtARf2+y4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AK0RL6beBb8fcJ503vsdHGVSRpkEHHnJYi9zt0fU76mWv8pO/gDp0eDN9Pva7u+Joq35viU0+XiAZY7mv5tMrnGzPQVZ2c3fTjLkSufLLVk/slNG2j5jM2rkTc4UdaUXaD0ksgqfOwfZOPZDpI/Hz1rRyvqsx/Js/7PuHX75Iso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=p8Wtd7t/; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1713950138; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=uFRHL08YisCGy8GeaiyxV8AxhBzMdE8E0bvCSQlulIE=;
	b=p8Wtd7t/fiFfJW3/r1rGvewytfET6d8FnC+JwjVLLejdOQjJx+EkmCKSaIyqWn2LZ0rFv4zjYyNqmYToVkEBRstuVzOcm8o4ZRylOinOyoLGwRp9r9lxAOEogGLuB9a9gyXNf5RNXNKcAvJBk7++ImK8Sr/7yz8LSHO+t90fYOQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R891e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045046011;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=26;SR=0;TI=SMTPD_---0W5BsEmw_1713950135;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W5BsEmw_1713950135)
          by smtp.aliyun-inc.com;
          Wed, 24 Apr 2024 17:15:36 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: virtualization@lists.linux.dev
Cc: Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
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
	"Michael S. Tsirkin" <mst@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	linux-um@lists.infradead.org,
	platform-driver-x86@vger.kernel.org,
	linux-remoteproc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH vhost v9 1/6] virtio_balloon: remove the dependence where names[] is null
Date: Wed, 24 Apr 2024 17:15:28 +0800
Message-Id: <20240424091533.86949-2-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20240424091533.86949-1-xuanzhuo@linux.alibaba.com>
References: <20240424091533.86949-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Git-Hash: bdb00f35db89
Content-Transfer-Encoding: 8bit

Currently, the init_vqs function within the virtio_balloon driver relies
on the condition that certain names array entries are null in order to
skip the initialization of some virtual queues (vqs). This behavior is
unique to this part of the codebase. In an upcoming commit, we plan to
eliminate this dependency by removing the function entirely. Therefore,
with this change, we are ensuring that the virtio_balloon no longer
depends on the aforementioned function.

As specification 1.0-1.2, vq indexes should not be contiguous if some
vq does not exist. But currently the virtqueue index is contiguous for
all existing devices. The Linux kernel does not implement functionality
to allow vq indexes to be discontinuous. So the current behavior of the
virtio-balloon device is different for the spec. But this commit has no
functional changes.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/virtio/virtio_balloon.c | 48 ++++++++++++++-------------------
 1 file changed, 20 insertions(+), 28 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index c0a63638f95e..ccda6d08493f 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -548,49 +548,41 @@ static int init_vqs(struct virtio_balloon *vb)
 	struct virtqueue *vqs[VIRTIO_BALLOON_VQ_MAX];
 	vq_callback_t *callbacks[VIRTIO_BALLOON_VQ_MAX];
 	const char *names[VIRTIO_BALLOON_VQ_MAX];
-	int err;
+	int err, idx = 0;
 
-	/*
-	 * Inflateq and deflateq are used unconditionally. The names[]
-	 * will be NULL if the related feature is not enabled, which will
-	 * cause no allocation for the corresponding virtqueue in find_vqs.
-	 */
-	callbacks[VIRTIO_BALLOON_VQ_INFLATE] = balloon_ack;
-	names[VIRTIO_BALLOON_VQ_INFLATE] = "inflate";
-	callbacks[VIRTIO_BALLOON_VQ_DEFLATE] = balloon_ack;
-	names[VIRTIO_BALLOON_VQ_DEFLATE] = "deflate";
-	callbacks[VIRTIO_BALLOON_VQ_STATS] = NULL;
-	names[VIRTIO_BALLOON_VQ_STATS] = NULL;
-	callbacks[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
-	names[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
-	names[VIRTIO_BALLOON_VQ_REPORTING] = NULL;
+	callbacks[idx] = balloon_ack;
+	names[idx++] = "inflate";
+	callbacks[idx] = balloon_ack;
+	names[idx++] = "deflate";
 
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
-		names[VIRTIO_BALLOON_VQ_STATS] = "stats";
-		callbacks[VIRTIO_BALLOON_VQ_STATS] = stats_request;
+		names[idx] = "stats";
+		callbacks[idx++] = stats_request;
 	}
 
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT)) {
-		names[VIRTIO_BALLOON_VQ_FREE_PAGE] = "free_page_vq";
-		callbacks[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
+		names[idx] = "free_page_vq";
+		callbacks[idx++] = NULL;
 	}
 
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
-		names[VIRTIO_BALLOON_VQ_REPORTING] = "reporting_vq";
-		callbacks[VIRTIO_BALLOON_VQ_REPORTING] = balloon_ack;
+		names[idx] = "reporting_vq";
+		callbacks[idx++] = balloon_ack;
 	}
 
-	err = virtio_find_vqs(vb->vdev, VIRTIO_BALLOON_VQ_MAX, vqs,
-			      callbacks, names, NULL);
+	err = virtio_find_vqs(vb->vdev, idx, vqs, callbacks, names, NULL);
 	if (err)
 		return err;
 
-	vb->inflate_vq = vqs[VIRTIO_BALLOON_VQ_INFLATE];
-	vb->deflate_vq = vqs[VIRTIO_BALLOON_VQ_DEFLATE];
+	idx = 0;
+
+	vb->inflate_vq = vqs[idx++];
+	vb->deflate_vq = vqs[idx++];
+
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
 		struct scatterlist sg;
 		unsigned int num_stats;
-		vb->stats_vq = vqs[VIRTIO_BALLOON_VQ_STATS];
+		vb->stats_vq = vqs[idx++];
 
 		/*
 		 * Prime this virtqueue with one buffer so the hypervisor can
@@ -610,10 +602,10 @@ static int init_vqs(struct virtio_balloon *vb)
 	}
 
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
-		vb->free_page_vq = vqs[VIRTIO_BALLOON_VQ_FREE_PAGE];
+		vb->free_page_vq = vqs[idx++];
 
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
-		vb->reporting_vq = vqs[VIRTIO_BALLOON_VQ_REPORTING];
+		vb->reporting_vq = vqs[idx++];
 
 	return 0;
 }
-- 
2.32.0.3.g01195cf9f


