Return-Path: <kvm+bounces-67278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A1FEDD00214
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 22:18:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A2CE23018403
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 21:18:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7937A33C50B;
	Wed,  7 Jan 2026 21:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="Zlxs0MP0"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44EA33AD89;
	Wed,  7 Jan 2026 21:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767819978; cv=none; b=pXoXvv00gn63sNnXIIRq/xYfdoFP45VU+0+Bb7VxEj0QWktctpgTeS3m9dFpmVMTilFRi/jfHTz+RbBkOb4ZmAdbr1Ifj5E3mCluzvkLkXKMgzeFzhLV2wAXdtodl9m8kidipbzgcjoAJGoBWcvlrwMOKWtdIfiR5+ArlhHO+ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767819978; c=relaxed/simple;
	bh=5XhV857b4Zt0CASKZBxygyRwR2i/i6QOZmWNbvIntIQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAX+2aFhkWg0/4RK0yWAwJdqAM4FZA1Ms1aXJ017a0G/JwsVzuJL/kcy0jGXQL1dSFqruZYQi+1AfRDLQUgqiyKHYf8zcbvh2RCczVK7dKOEwgNqKNg8SEaM1WBrYiROOku89Suvy7TyLEdHd/Q9HqhOxSnJ8cTzg/6YbVqEuCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=Zlxs0MP0; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from simon-Latitude-5450.fritz.box (p5dc880d2.dip0.t-ipconnect.de [93.200.128.210])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.16/8.18.1.16) with ESMTPSA id 607L5t9N026667
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 7 Jan 2026 22:06:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1767819961;
	bh=5XhV857b4Zt0CASKZBxygyRwR2i/i6QOZmWNbvIntIQ=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Zlxs0MP0MeZWEY5o8s83hir/dpKxKP6jSSDNvqfqUeCHyp9VE0USm3WYlne0P52OI
	 1Fl8Qk9hMaGSPB6PSpGTj3Tjv2gUNPzAdOdkQC9zuqAmPJtAvEnZTdlNJmR4kOiuc1
	 A2c8FMVix1qgvV8eCQfehr2KKWUgJf+gWcJQN6TQ=
From: Simon Schippers <simon.schippers@tu-dortmund.de>
To: willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
        andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mst@redhat.com,
        eperezma@redhat.com, leiyang@redhat.com, stephen@networkplumber.org,
        jon@nutanix.com, tim.gebauer@tu-dortmund.de,
        simon.schippers@tu-dortmund.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux.dev
Subject: [PATCH net-next v7 4/9] tun/tap: add batched ptr_ring consume functions with netdev queue wakeup
Date: Wed,  7 Jan 2026 22:04:43 +0100
Message-ID: <20260107210448.37851-5-simon.schippers@tu-dortmund.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260107210448.37851-1-simon.schippers@tu-dortmund.de>
References: <20260107210448.37851-1-simon.schippers@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add {tun,tap}_ring_consume_batched() that wrap
__ptr_ring_consume_batched() and wake the corresponding netdev subqueue
when consuming the entries frees space in the ptr_ring.

These wrappers are supposed to be used by vhost-net in an upcoming
commit.

Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
---
 drivers/net/tap.c      | 23 +++++++++++++++++++++++
 drivers/net/tun.c      | 23 +++++++++++++++++++++++
 include/linux/if_tap.h |  6 ++++++
 include/linux/if_tun.h |  7 +++++++
 4 files changed, 59 insertions(+)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 2442cf7ac385..7e3b4eed797c 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -774,6 +774,29 @@ static void *tap_ring_consume(struct tap_queue *q)
 	return ptr;
 }
 
+int tap_ring_consume_batched(struct file *file, void **array, int n)
+{
+	struct tap_queue *q = file->private_data;
+	struct ptr_ring *ring = &q->ring;
+	struct net_device *dev;
+	int i;
+
+	spin_lock(&ring->consumer_lock);
+
+	i = __ptr_ring_consume_batched(ring, array, n);
+	if (__ptr_ring_consume_created_space(ring, i)) {
+		rcu_read_lock();
+		dev = rcu_dereference(q->tap)->dev;
+		netif_wake_subqueue(dev, q->queue_index);
+		rcu_read_unlock();
+	}
+
+	spin_unlock(&ring->consumer_lock);
+
+	return i;
+}
+EXPORT_SYMBOL_GPL(tap_ring_consume_batched);
+
 static ssize_t tap_do_read(struct tap_queue *q,
 			   struct iov_iter *to,
 			   int noblock, struct sk_buff *skb)
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 7148f9a844a4..db3b72025cfb 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3736,6 +3736,29 @@ struct socket *tun_get_socket(struct file *file)
 }
 EXPORT_SYMBOL_GPL(tun_get_socket);
 
+int tun_ring_consume_batched(struct file *file, void **array, int n)
+{
+	struct tun_file *tfile = file->private_data;
+	struct ptr_ring *ring = &tfile->tx_ring;
+	struct net_device *dev;
+	int i;
+
+	spin_lock(&ring->consumer_lock);
+
+	i = __ptr_ring_consume_batched(ring, array, n);
+	if (__ptr_ring_consume_created_space(ring, i)) {
+		rcu_read_lock();
+		dev = rcu_dereference(tfile->tun)->dev;
+		netif_wake_subqueue(dev, tfile->queue_index);
+		rcu_read_unlock();
+	}
+
+	spin_unlock(&ring->consumer_lock);
+
+	return i;
+}
+EXPORT_SYMBOL_GPL(tun_ring_consume_batched);
+
 struct ptr_ring *tun_get_tx_ring(struct file *file)
 {
 	struct tun_file *tfile;
diff --git a/include/linux/if_tap.h b/include/linux/if_tap.h
index 553552fa635c..cf8b90320b8d 100644
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
+					   void **array, int n)
+{
+	return 0;
+}
 #endif /* CONFIG_TAP */
 
 /*
diff --git a/include/linux/if_tun.h b/include/linux/if_tun.h
index 80166eb62f41..444dda75a372 100644
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
+					   void **array, int n)
+{
+	return 0;
+}
+
 static inline bool tun_is_xdp_frame(void *ptr)
 {
 	return false;
-- 
2.43.0


