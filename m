Return-Path: <kvm+bounces-67284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DD611D00202
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 22:17:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E0F063055709
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 21:15:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52F18341ACB;
	Wed,  7 Jan 2026 21:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="d8Qok6D1"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43EE32939F;
	Wed,  7 Jan 2026 21:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767819979; cv=none; b=UiM/3ncAF2AkrknXJOe0HqCWQnSDE1snAOc4oNTgRHyGAnwMdIKnPwiB90pVWQ5cF3VhZLosjC/OU+esFsAB/70cofC+Y3Fn4z/yY93wQMzBhg/k93ITMffODvlUtksPLgjM0g9fykQ2NUBxaTq0QopEnCB61SMRd93ZMtj8PrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767819979; c=relaxed/simple;
	bh=mE6aOBUjGg0nHy0ZV8Lx2Ex+VEWWhdSTTr16919jAIw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XGq1Zab/QnHwNSmRfJFgCvkoSf2FDcMf5bxrizWbG38OhwhT7JlTn2Y8njtlMb+eEbJjnbn9jeA1AYHWJBpLPr+iROUdVevJBhStZJJxp+z0/jZ+63LZCCZt/HGhZB7x9MlSNOw1zm5Q8ZQ5xeUlrUkZ7WJAu+101RFxzFV1tmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=d8Qok6D1; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from simon-Latitude-5450.fritz.box (p5dc880d2.dip0.t-ipconnect.de [93.200.128.210])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.16/8.18.1.16) with ESMTPSA id 607L5t9P026667
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 7 Jan 2026 22:06:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1767819962;
	bh=mE6aOBUjGg0nHy0ZV8Lx2Ex+VEWWhdSTTr16919jAIw=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=d8Qok6D18JHIjXiEFrGaKUbFJt8b7jFKiJPWsGKLQ23xREaFtZFgQnZvjQOnhVcU9
	 fD7uegoWms5iUXzyySKj4PJqVLJnXYL/6jCyBmcZcoQaZdZqPxZ1ESDfgLkL1VXZ4i
	 dBrx4/cOQ/7VWbJoTRyXlZ2nM5dXdSCUkE9K+V84=
From: Simon Schippers <simon.schippers@tu-dortmund.de>
To: willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
        andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mst@redhat.com,
        eperezma@redhat.com, leiyang@redhat.com, stephen@networkplumber.org,
        jon@nutanix.com, tim.gebauer@tu-dortmund.de,
        simon.schippers@tu-dortmund.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux.dev
Subject: [PATCH net-next v7 5/9] tun/tap: add unconsume function for returning entries to ptr_ring
Date: Wed,  7 Jan 2026 22:04:44 +0100
Message-ID: <20260107210448.37851-6-simon.schippers@tu-dortmund.de>
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

Add {tun,tap}_ring_unconsume() wrappers to allow external modules
(e.g. vhost-net) to return previously consumed entries back to the
ptr_ring. The functions delegate to ptr_ring_unconsume() and take a
destroy callback for entries that cannot be returned to the ring.

Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Co-developed by: Jon Kohler <jon@nutanix.com>
Signed-off-by: Jon Kohler <jon@nutanix.com>
Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
---
 drivers/net/tap.c      | 10 ++++++++++
 drivers/net/tun.c      | 10 ++++++++++
 include/linux/if_tap.h |  4 ++++
 include/linux/if_tun.h |  5 +++++
 4 files changed, 29 insertions(+)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 7e3b4eed797c..4ffe4e95b5a6 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -797,6 +797,16 @@ int tap_ring_consume_batched(struct file *file, void **array, int n)
 }
 EXPORT_SYMBOL_GPL(tap_ring_consume_batched);
 
+void tap_ring_unconsume(struct file *file, void **batch, int n,
+			void (*destroy)(void *))
+{
+	struct tap_queue *q = file->private_data;
+	struct ptr_ring *ring = &q->ring;
+
+	ptr_ring_unconsume(ring, batch, n, destroy);
+}
+EXPORT_SYMBOL_GPL(tap_ring_unconsume);
+
 static ssize_t tap_do_read(struct tap_queue *q,
 			   struct iov_iter *to,
 			   int noblock, struct sk_buff *skb)
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index db3b72025cfb..d44d206c65e8 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3759,6 +3759,16 @@ int tun_ring_consume_batched(struct file *file, void **array, int n)
 }
 EXPORT_SYMBOL_GPL(tun_ring_consume_batched);
 
+void tun_ring_unconsume(struct file *file, void **batch, int n,
+			void (*destroy)(void *))
+{
+	struct tun_file *tfile = file->private_data;
+	struct ptr_ring *ring = &tfile->tx_ring;
+
+	ptr_ring_unconsume(ring, batch, n, destroy);
+}
+EXPORT_SYMBOL_GPL(tun_ring_unconsume);
+
 struct ptr_ring *tun_get_tx_ring(struct file *file)
 {
 	struct tun_file *tfile;
diff --git a/include/linux/if_tap.h b/include/linux/if_tap.h
index cf8b90320b8d..28326a69745a 100644
--- a/include/linux/if_tap.h
+++ b/include/linux/if_tap.h
@@ -12,6 +12,8 @@ struct socket;
 struct socket *tap_get_socket(struct file *);
 struct ptr_ring *tap_get_ptr_ring(struct file *file);
 int tap_ring_consume_batched(struct file *file, void **array, int n);
+void tap_ring_unconsume(struct file *file, void **batch, int n,
+			void (*destroy)(void *));
 #else
 #include <linux/err.h>
 #include <linux/errno.h>
@@ -28,6 +30,8 @@ static inline int tap_ring_consume_batched(struct file *f,
 {
 	return 0;
 }
+static inline void tap_ring_unconsume(struct file *file, void **batch,
+				      int n, void (*destroy)(void *)) {}
 #endif /* CONFIG_TAP */
 
 /*
diff --git a/include/linux/if_tun.h b/include/linux/if_tun.h
index 444dda75a372..1274c6b34eb6 100644
--- a/include/linux/if_tun.h
+++ b/include/linux/if_tun.h
@@ -23,6 +23,8 @@ struct tun_msg_ctl {
 struct socket *tun_get_socket(struct file *);
 struct ptr_ring *tun_get_tx_ring(struct file *file);
 int tun_ring_consume_batched(struct file *file, void **array, int n);
+void tun_ring_unconsume(struct file *file, void **batch, int n,
+			void (*destroy)(void *));
 
 static inline bool tun_is_xdp_frame(void *ptr)
 {
@@ -62,6 +64,9 @@ static inline int tun_ring_consume_batched(struct file *file,
 	return 0;
 }
 
+static inline void tun_ring_unconsume(struct file *file, void **batch,
+				      int n, void (*destroy)(void *)) {}
+
 static inline bool tun_is_xdp_frame(void *ptr)
 {
 	return false;
-- 
2.43.0


