Return-Path: <kvm+bounces-58424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 570DBB93779
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 00:19:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BE3B57AEB5A
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 22:17:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 897DF3203A1;
	Mon, 22 Sep 2025 22:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="P7Jj/jJe"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB7227A906;
	Mon, 22 Sep 2025 22:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758579433; cv=none; b=M8DjUKBR6kEdZBYZtPXhJH133PvU0SBHpcSn8+1pm9S4cxr9abSAmnh+f/9HFwu9+DprPbk+ddNSHvZd4yemPwJIM0UwYV2JqWM+YvleIvxkGTpxFMO7+gCvqaeTKb5L/fwgF4g2izRq+80mqHHJ/9UsNzUCkHvgxdM71EIeoc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758579433; c=relaxed/simple;
	bh=5PuVBkf+qGmZlYXb2NZVJTfDHMzFZGPoycz3QdxG9Cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+ErwhgMlq1R9zeuS37VA/wTGx3syLZ9R08KGIEmBwnl6k/4XGYA0BlO/+gZFFdZwDPpZYzLF3WoM01zYWmhyNqFytqXULNVADq3jhFDjTPHE77dXKPGl6YB6JBPeJdtRriQ/1r8RQJAz4eU8rk0bzMsDH7ZfuVGuZauDC7l+H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=P7Jj/jJe; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from simon-Latitude-5450.fritz.box (p5dc88066.dip0.t-ipconnect.de [93.200.128.102])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.10/8.18.1.10) with ESMTPSA id 58MMH4eh003919
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 23 Sep 2025 00:17:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1758579427;
	bh=5PuVBkf+qGmZlYXb2NZVJTfDHMzFZGPoycz3QdxG9Cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P7Jj/jJeG/6RXXDI8IKdmk9mUIroKPkjQ8DpWsA/hZK/+3SgUvGHbBHcFbFumLonG
	 A2C5s7LXaCfDDXzTmhDgGLzVWtZCm3Wto2yQkuyTatzkWHfS2wXY9XOaStXVBhXJNj
	 +T+zrR71NPIZW1jrMfpNX0U0SYD2dM01afJZvHKY=
From: Simon Schippers <simon.schippers@tu-dortmund.de>
To: willemdebruijn.kernel@gmail.com, jasowang@redhat.com, mst@redhat.com,
        eperezma@redhat.com, stephen@networkplumber.org, leiyang@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux.dev, kvm@vger.kernel.org
Cc: Simon Schippers <simon.schippers@tu-dortmund.de>,
        Tim Gebauer <tim.gebauer@tu-dortmund.de>
Subject: [PATCH net-next v5 5/8] TUN & TAP: Provide ptr_ring_consume_batched wrappers for vhost_net
Date: Tue, 23 Sep 2025 00:15:50 +0200
Message-ID: <20250922221553.47802-6-simon.schippers@tu-dortmund.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250922221553.47802-1-simon.schippers@tu-dortmund.de>
References: <20250922221553.47802-1-simon.schippers@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The wrappers tun_ring_consume_batched/tap_ring_consume_batched are similar
to the wrappers tun_ring_consume/tap_ring_consume. They deal with
consuming a batch of entries of the ptr_ring and then waking the
netdev queue whenever entries get invalidated to be used again by the
producer.
To avoid waking the netdev queue when the ptr_ring is full, it is checked
if the netdev queue is stopped before invalidating entries. Like that the
netdev queue can be safely woken after invalidating entries.

The READ_ONCE in __ptr_ring_peek, paired with the smp_wmb() in
__ptr_ring_produce within tun_net_xmit guarantees that the information
about the netdev queue being stopped is visible after __ptr_ring_peek is
called.

Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
---
 drivers/net/tap.c      | 52 ++++++++++++++++++++++++++++++++++++++++
 drivers/net/tun.c      | 54 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/if_tap.h |  6 +++++
 include/linux/if_tun.h |  7 ++++++
 4 files changed, 119 insertions(+)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index f8292721a9d6..651d48612329 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1216,6 +1216,58 @@ struct socket *tap_get_socket(struct file *file)
 }
 EXPORT_SYMBOL_GPL(tap_get_socket);
 
+int tap_ring_consume_batched(struct file *file,
+			     void **array, int n)
+{
+	struct tap_queue *q = file->private_data;
+	struct netdev_queue *txq;
+	struct net_device *dev;
+	bool will_invalidate;
+	bool stopped;
+	void *ptr;
+	int i;
+
+	spin_lock(&q->ring.consumer_lock);
+	ptr = __ptr_ring_peek(&q->ring);
+
+	if (!ptr) {
+		spin_unlock(&q->ring.consumer_lock);
+		return 0;
+	}
+
+	i = 0;
+	do {
+		/* Check if the queue stopped before zeroing out, so no
+		 * ptr get produced in the meantime, because this could
+		 * result in waking even though the ptr_ring is full.
+		 * The order of the operations is ensured by barrier().
+		 */
+		will_invalidate = __ptr_ring_will_invalidate(&q->ring);
+		if (unlikely(will_invalidate)) {
+			rcu_read_lock();
+			dev = rcu_dereference(q->tap)->dev;
+			txq = netdev_get_tx_queue(dev, q->queue_index);
+			stopped = netif_tx_queue_stopped(txq);
+		}
+		barrier();
+		__ptr_ring_discard_one(&q->ring, will_invalidate);
+
+		if (unlikely(will_invalidate)) {
+			if (stopped)
+				netif_tx_wake_queue(txq);
+			rcu_read_unlock();
+		}
+
+		array[i++] = ptr;
+		if (i >= n)
+			break;
+	} while ((ptr = __ptr_ring_peek(&q->ring)));
+	spin_unlock(&q->ring.consumer_lock);
+
+	return i;
+}
+EXPORT_SYMBOL_GPL(tap_ring_consume_batched);
+
 struct ptr_ring *tap_get_ptr_ring(struct file *file)
 {
 	struct tap_queue *q;
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 682df8157b55..7566b22780fb 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3759,6 +3759,60 @@ struct socket *tun_get_socket(struct file *file)
 }
 EXPORT_SYMBOL_GPL(tun_get_socket);
 
+int tun_ring_consume_batched(struct file *file,
+			     void **array, int n)
+{
+	struct tun_file *tfile = file->private_data;
+	struct netdev_queue *txq;
+	struct net_device *dev;
+	bool will_invalidate;
+	bool stopped;
+	void *ptr;
+	int i;
+
+	spin_lock(&tfile->tx_ring.consumer_lock);
+	ptr = __ptr_ring_peek(&tfile->tx_ring);
+
+	if (!ptr) {
+		spin_unlock(&tfile->tx_ring.consumer_lock);
+		return 0;
+	}
+
+	i = 0;
+	do {
+		/* Check if the queue stopped before zeroing out, so no
+		 * ptr get produced in the meantime, because this could
+		 * result in waking even though the ptr_ring is full.
+		 * The order of the operations is ensured by barrier().
+		 */
+		will_invalidate =
+			__ptr_ring_will_invalidate(&tfile->tx_ring);
+		if (unlikely(will_invalidate)) {
+			rcu_read_lock();
+			dev = rcu_dereference(tfile->tun)->dev;
+			txq = netdev_get_tx_queue(dev,
+						  tfile->queue_index);
+			stopped = netif_tx_queue_stopped(txq);
+		}
+		barrier();
+		__ptr_ring_discard_one(&tfile->tx_ring, will_invalidate);
+
+		if (unlikely(will_invalidate)) {
+			if (stopped)
+				netif_tx_wake_queue(txq);
+			rcu_read_unlock();
+		}
+
+		array[i++] = ptr;
+		if (i >= n)
+			break;
+	} while ((ptr = __ptr_ring_peek(&tfile->tx_ring)));
+	spin_unlock(&tfile->tx_ring.consumer_lock);
+
+	return i;
+}
+EXPORT_SYMBOL_GPL(tun_ring_consume_batched);
+
 struct ptr_ring *tun_get_tx_ring(struct file *file)
 {
 	struct tun_file *tfile;
diff --git a/include/linux/if_tap.h b/include/linux/if_tap.h
index 553552fa635c..2e5542d6aef4 100644
--- a/include/linux/if_tap.h
+++ b/include/linux/if_tap.h
@@ -11,6 +11,7 @@ struct socket;
 #if IS_ENABLED(CONFIG_TAP)
 struct socket *tap_get_socket(struct file *);
 struct ptr_ring *tap_get_ptr_ring(struct file *file);
+int tap_ring_consume_batched(struct file *file, void **array, int n);
 #else
 #include <linux/err.h>
 #include <linux/errno.h>
@@ -22,6 +23,11 @@ static inline struct ptr_ring *tap_get_ptr_ring(struct file *f)
 {
 	return ERR_PTR(-EINVAL);
 }
+static inline int tap_ring_consume_batched(struct file *f,
+						void **array, int n)
+{
+	return 0;
+}
 #endif /* CONFIG_TAP */
 
 /*
diff --git a/include/linux/if_tun.h b/include/linux/if_tun.h
index 80166eb62f41..5b41525ac007 100644
--- a/include/linux/if_tun.h
+++ b/include/linux/if_tun.h
@@ -22,6 +22,7 @@ struct tun_msg_ctl {
 #if defined(CONFIG_TUN) || defined(CONFIG_TUN_MODULE)
 struct socket *tun_get_socket(struct file *);
 struct ptr_ring *tun_get_tx_ring(struct file *file);
+int tun_ring_consume_batched(struct file *file, void **array, int n);
 
 static inline bool tun_is_xdp_frame(void *ptr)
 {
@@ -55,6 +56,12 @@ static inline struct ptr_ring *tun_get_tx_ring(struct file *f)
 	return ERR_PTR(-EINVAL);
 }
 
+static inline int tun_ring_consume_batched(struct file *file,
+						void **array, int n)
+{
+	return 0;
+}
+
 static inline bool tun_is_xdp_frame(void *ptr)
 {
 	return false;
-- 
2.43.0


