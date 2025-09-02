Return-Path: <kvm+bounces-56540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 34D72B3F7EA
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 10:14:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 759B1168DFD
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 08:13:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02B102EB5A1;
	Tue,  2 Sep 2025 08:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="jZOJHZzI"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302672EAB84;
	Tue,  2 Sep 2025 08:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756800626; cv=none; b=hBGaX9fI1ga3K1Lw7Q519Z6CaKe4JMD9VYGpurMlUCOASu2tIcMadVjaWSvgyIpuEnW2KQx2xfhVR+NydOEeSL36MMySqigQ5goYxS+HUMANyhgEt8++HtIl3hcuuEUwLGDnjgi6RChV1Q2Evdf0NO2HuJl6AOTy3AyP7nYUx4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756800626; c=relaxed/simple;
	bh=PwRCoKvnKUcaF9XJd+7L46ezwLV5dAqjhUK2h2k/uog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nEGfX25QBQjwf2uW8eBhKTOjCOgiEoMVQnsSZo7qsgPJB3T25Tddijux2rnkfBW4HEi2zbDhbJhBoO+QUvtBnOYDIdJtBLELvlImreuDCNLiciJe4kANkpf/t0MPRGYkRrdl5jkf0VyQOb+Y+7VcpXzlV6xKih3SmYhP8rATmf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=jZOJHZzI; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from simon-Latitude-5450.tu-dortmund.de (rechenknecht2.kn.e-technik.tu-dortmund.de [129.217.186.41])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.9/8.18.1.10) with ESMTPSA id 58289x6Z004012
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 2 Sep 2025 10:10:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1756800612;
	bh=PwRCoKvnKUcaF9XJd+7L46ezwLV5dAqjhUK2h2k/uog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jZOJHZzIQ9/CCVHUhlb+0zGeyZuYR13vZcTmAx3gkROU/2MefiSm1gPb4WysBWrbl
	 eBsDI4jP+kfnPOiDQDBYKQSxjhPGUbV2ittAzazS401S1+P5s00SJtbBR6owGebLFT
	 HR44w28paWJ1/WeiSdeCojDG8tPI4F2hBJDhnCZY=
From: Simon Schippers <simon.schippers@tu-dortmund.de>
To: willemdebruijn.kernel@gmail.com, jasowang@redhat.com, mst@redhat.com,
        eperezma@redhat.com, stephen@networkplumber.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux.dev, kvm@vger.kernel.org
Cc: Simon Schippers <simon.schippers@tu-dortmund.de>,
        Tim Gebauer <tim.gebauer@tu-dortmund.de>
Subject: [PATCH 4/4] netdev queue flow control for vhost_net
Date: Tue,  2 Sep 2025 10:09:57 +0200
Message-ID: <20250902080957.47265-5-simon.schippers@tu-dortmund.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250902080957.47265-1-simon.schippers@tu-dortmund.de>
References: <20250902080957.47265-1-simon.schippers@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Stopping the queue is done in tun_net_xmit.

Waking the queue is done by calling one of the helpers,
tun_wake_netdev_queue and tap_wake_netdev_queue. For that, in
get_wake_netdev_queue, the correct method is determined and saved in the
function pointer wake_netdev_queue of the vhost_net_virtqueue. Then, each
time after consuming a batch in vhost_net_buf_produce, wake_netdev_queue
is called.

Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
---
 drivers/net/tap.c      |  6 ++++++
 drivers/net/tun.c      |  6 ++++++
 drivers/vhost/net.c    | 34 ++++++++++++++++++++++++++++------
 include/linux/if_tap.h |  2 ++
 include/linux/if_tun.h |  3 +++
 5 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 4d874672bcd7..0bad9e3d59af 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1198,6 +1198,12 @@ struct socket *tap_get_socket(struct file *file)
 }
 EXPORT_SYMBOL_GPL(tap_get_socket);
 
+void tap_wake_netdev_queue(struct file *file)
+{
+	wake_netdev_queue(file->private_data);
+}
+EXPORT_SYMBOL_GPL(tap_wake_netdev_queue);
+
 struct ptr_ring *tap_get_ptr_ring(struct file *file)
 {
 	struct tap_queue *q;
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 735498e221d8..e85589b596ac 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3739,6 +3739,12 @@ struct socket *tun_get_socket(struct file *file)
 }
 EXPORT_SYMBOL_GPL(tun_get_socket);
 
+void tun_wake_netdev_queue(struct file *file)
+{
+	wake_netdev_queue(file->private_data);
+}
+EXPORT_SYMBOL_GPL(tun_wake_netdev_queue);
+
 struct ptr_ring *tun_get_tx_ring(struct file *file)
 {
 	struct tun_file *tfile;
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 6edac0c1ba9b..e837d3a334f1 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -130,6 +130,7 @@ struct vhost_net_virtqueue {
 	struct vhost_net_buf rxq;
 	/* Batched XDP buffs */
 	struct xdp_buff *xdp;
+	void (*wake_netdev_queue)(struct file *f);
 };
 
 struct vhost_net {
@@ -175,13 +176,16 @@ static void *vhost_net_buf_consume(struct vhost_net_buf *rxq)
 	return ret;
 }
 
-static int vhost_net_buf_produce(struct vhost_net_virtqueue *nvq)
+static int vhost_net_buf_produce(struct vhost_net_virtqueue *nvq,
+								 struct sock *sk)
 {
+	struct file *file = sk->sk_socket->file;
 	struct vhost_net_buf *rxq = &nvq->rxq;
 
 	rxq->head = 0;
 	rxq->tail = ptr_ring_consume_batched(nvq->rx_ring, rxq->queue,
 					      VHOST_NET_BATCH);
+	nvq->wake_netdev_queue(file);
 	return rxq->tail;
 }
 
@@ -208,14 +212,15 @@ static int vhost_net_buf_peek_len(void *ptr)
 	return __skb_array_len_with_tag(ptr);
 }
 
-static int vhost_net_buf_peek(struct vhost_net_virtqueue *nvq)
+static int vhost_net_buf_peek(struct vhost_net_virtqueue *nvq,
+							  struct sock *sk)
 {
 	struct vhost_net_buf *rxq = &nvq->rxq;
 
 	if (!vhost_net_buf_is_empty(rxq))
 		goto out;
 
-	if (!vhost_net_buf_produce(nvq))
+	if (!vhost_net_buf_produce(nvq, sk))
 		return 0;
 
 out:
@@ -994,7 +999,7 @@ static int peek_head_len(struct vhost_net_virtqueue *rvq, struct sock *sk)
 	unsigned long flags;
 
 	if (rvq->rx_ring)
-		return vhost_net_buf_peek(rvq);
+		return vhost_net_buf_peek(rvq, sk);
 
 	spin_lock_irqsave(&sk->sk_receive_queue.lock, flags);
 	head = skb_peek(&sk->sk_receive_queue);
@@ -1499,6 +1504,19 @@ static struct socket *get_tap_socket(int fd)
 	return sock;
 }
 
+static void (*get_wake_netdev_queue(struct file *file))(struct file *file)
+{
+	struct ptr_ring *ring;
+
+	ring = tun_get_tx_ring(file);
+	if (!IS_ERR(ring))
+		return tun_wake_netdev_queue;
+	ring = tap_get_ptr_ring(file);
+	if (!IS_ERR(ring))
+		return tap_wake_netdev_queue;
+	return NULL;
+}
+
 static struct socket *get_socket(int fd)
 {
 	struct socket *sock;
@@ -1570,10 +1588,14 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 		if (r)
 			goto err_used;
 		if (index == VHOST_NET_VQ_RX) {
-			if (sock)
+			if (sock) {
 				nvq->rx_ring = get_tap_ptr_ring(sock->file);
-			else
+				nvq->wake_netdev_queue =
+					get_wake_netdev_queue(sock->file);
+			} else {
 				nvq->rx_ring = NULL;
+				nvq->wake_netdev_queue = NULL;
+			}
 		}
 
 		oldubufs = nvq->ubufs;
diff --git a/include/linux/if_tap.h b/include/linux/if_tap.h
index 553552fa635c..02b2809784b5 100644
--- a/include/linux/if_tap.h
+++ b/include/linux/if_tap.h
@@ -10,6 +10,7 @@ struct socket;
 
 #if IS_ENABLED(CONFIG_TAP)
 struct socket *tap_get_socket(struct file *);
+void tap_wake_netdev_queue(struct file *file);
 struct ptr_ring *tap_get_ptr_ring(struct file *file);
 #else
 #include <linux/err.h>
@@ -18,6 +19,7 @@ static inline struct socket *tap_get_socket(struct file *f)
 {
 	return ERR_PTR(-EINVAL);
 }
+static inline void tap_wake_netdev_queue(struct file *f) {}
 static inline struct ptr_ring *tap_get_ptr_ring(struct file *f)
 {
 	return ERR_PTR(-EINVAL);
diff --git a/include/linux/if_tun.h b/include/linux/if_tun.h
index 80166eb62f41..04c504bb1954 100644
--- a/include/linux/if_tun.h
+++ b/include/linux/if_tun.h
@@ -21,6 +21,7 @@ struct tun_msg_ctl {
 
 #if defined(CONFIG_TUN) || defined(CONFIG_TUN_MODULE)
 struct socket *tun_get_socket(struct file *);
+void tun_wake_netdev_queue(struct file *file);
 struct ptr_ring *tun_get_tx_ring(struct file *file);
 
 static inline bool tun_is_xdp_frame(void *ptr)
@@ -50,6 +51,8 @@ static inline struct socket *tun_get_socket(struct file *f)
 	return ERR_PTR(-EINVAL);
 }
 
+static inline void tun_wake_netdev_queue(struct file *f) {}
+
 static inline struct ptr_ring *tun_get_tx_ring(struct file *f)
 {
 	return ERR_PTR(-EINVAL);
-- 
2.43.0


