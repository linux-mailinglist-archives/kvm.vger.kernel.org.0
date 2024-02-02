Return-Path: <kvm+bounces-7846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 044C5846CC1
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 10:45:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 296B51C26C77
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 09:45:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DC3A22067;
	Fri,  2 Feb 2024 09:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="fxd4Q1ia"
X-Original-To: kvm@vger.kernel.org
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58E68005C;
	Fri,  2 Feb 2024 09:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706866826; cv=none; b=TSBcbBF41QWUZBaFI2qkRNgbDB3Uyl/vDmpOMMaXLck57EIDhNvl2656vjKcyQ/P6wbcT1Ug+O10cT+dJashLRdjqgRBUZDRO5zYf7KY8IIiCCpIPjcNDVp5zau/IdOkAyKwIkE8aI4SsUuY68z3bXfXLqbLMvUOOl3v3r8yNQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706866826; c=relaxed/simple;
	bh=P1EuAKIYKR8oUbIq4ooX+jiHttt0zxADPIYwqeGcDq8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YfyafNcpWiqqvhfskxt4lpb6r2pkBkxJPzwU32Qq8j760ifppwsGJoed7jwbWJkRMOZ44COyXY4/ukfKlCXMIhSCiAXsxCMRpqRYsXxPPgMu2QJoEChmx66hfplWFcAGQhQ/yUqNJT9/VzIyR6faFSCzgsy046XqXfWq+gxuvvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=fxd4Q1ia; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1706866822; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=MJPPX0Mbe/Fi3ODIrg/IdS8p5bwqdjZiSVg8RtlcgFY=;
	b=fxd4Q1iaDrcRzFsqfSODHnRRqAkSys19TtDUvoeLix/fixsSVfoGBxZaO4gJrVca14NPGZacharMS355DMHUGH2zlSz/Ti8o9jZOZLez1r6p2FsAilQNDJI4Kxz2n+icIV7I9s/INlnHjEAZ2GxzCh7DSIPevHQEP/Kh6+t3hsY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=36;SR=0;TI=SMTPD_---0W.wdbmJ_1706866819;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0W.wdbmJ_1706866819)
          by smtp.aliyun-inc.com;
          Fri, 02 Feb 2024 17:40:20 +0800
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
Subject: [PATCH vhost v1 17/19] virtio_net: unify the code for recycling the xmit ptr
Date: Fri,  2 Feb 2024 17:39:49 +0800
Message-Id: <20240202093951.120283-18-xuanzhuo@linux.alibaba.com>
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

There are two completely similar and independent implementations. This
is inconvenient for the subsequent addition of new types. So extract a
function from this piece of code and call this function uniformly to
recover old xmit ptr.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 66 +++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 38 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 12961fc0879e..c7409344dda1 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -348,6 +348,30 @@ static struct xdp_frame *ptr_to_xdp(void *ptr)
 	return (struct xdp_frame *)((unsigned long)ptr & ~VIRTIO_XDP_FLAG);
 }
 
+static void __free_old_xmit(struct send_queue *sq, bool in_napi,
+			    u64 *bytes, u64 *packets)
+{
+	unsigned int len;
+	void *ptr;
+
+	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
+		if (!is_xdp_frame(ptr)) {
+			struct sk_buff *skb = ptr;
+
+			pr_debug("Sent skb %p\n", skb);
+
+			*bytes += skb->len;
+			napi_consume_skb(skb, in_napi);
+		} else {
+			struct xdp_frame *frame = ptr_to_xdp(ptr);
+
+			*bytes += xdp_get_frame_len(frame);
+			xdp_return_frame(frame);
+		}
+		(*packets)++;
+	}
+}
+
 /* Converting between virtqueue no. and kernel tx/rx queue no.
  * 0:rx0 1:tx0 2:rx1 3:tx1 ... 2N:rxN 2N+1:txN 2N+2:cvq
  */
@@ -740,27 +764,9 @@ static void virtnet_rq_unmap_free_buf(struct virtqueue *vq, void *buf)
 
 static void free_old_xmit_skbs(struct send_queue *sq, bool in_napi)
 {
-	unsigned int len;
-	unsigned int packets = 0;
-	unsigned int bytes = 0;
-	void *ptr;
-
-	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
-		if (likely(!is_xdp_frame(ptr))) {
-			struct sk_buff *skb = ptr;
-
-			pr_debug("Sent skb %p\n", skb);
+	u64 bytes = 0, packets = 0;
 
-			bytes += skb->len;
-			napi_consume_skb(skb, in_napi);
-		} else {
-			struct xdp_frame *frame = ptr_to_xdp(ptr);
-
-			bytes += xdp_get_frame_len(frame);
-			xdp_return_frame(frame);
-		}
-		packets++;
-	}
+	__free_old_xmit(sq, in_napi, &bytes, &packets);
 
 	/* Avoid overhead when no packets have been processed
 	 * happens when called speculatively from start_xmit.
@@ -910,14 +916,11 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 {
 	struct virtnet_info *vi = netdev_priv(dev);
 	struct receive_queue *rq = vi->rq;
+	u64 bytes = 0, packets = 0;
 	struct bpf_prog *xdp_prog;
 	struct send_queue *sq;
-	unsigned int len;
-	int packets = 0;
-	int bytes = 0;
 	int nxmit = 0;
 	int kicks = 0;
-	void *ptr;
 	int ret;
 	int i;
 
@@ -936,20 +939,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 	}
 
 	/* Free up any pending old buffers before queueing new ones. */
-	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
-		if (likely(is_xdp_frame(ptr))) {
-			struct xdp_frame *frame = ptr_to_xdp(ptr);
-
-			bytes += xdp_get_frame_len(frame);
-			xdp_return_frame(frame);
-		} else {
-			struct sk_buff *skb = ptr;
-
-			bytes += skb->len;
-			napi_consume_skb(skb, false);
-		}
-		packets++;
-	}
+	__free_old_xmit(sq, false, &bytes, &packets);
 
 	for (i = 0; i < n; i++) {
 		struct xdp_frame *xdpf = frames[i];
-- 
2.32.0.3.g01195cf9f


