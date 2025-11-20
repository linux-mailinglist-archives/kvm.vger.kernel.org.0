Return-Path: <kvm+bounces-63875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 27ABFC75106
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 16:43:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 632DC357F2E
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 15:37:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A16EE393DC3;
	Thu, 20 Nov 2025 15:30:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5B8369977;
	Thu, 20 Nov 2025 15:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763652611; cv=none; b=GSDc1zSFGh55mtymqD3/ygGPFxjlDgukKBF4ZwY4+oH/5OJMJ9aevmDSnJPvYqWz9P7TBQHzrCIQ+Kk64DOIBcYShv7rEdV6O2Wr/XmQNPu1PKfWAMx1+JQK/f/BETxhczf8eaR8f0GSnDVYPL7tot2ye+EuM90bX3aQusqjbiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763652611; c=relaxed/simple;
	bh=JdRG8nMWKHO3vzTj8WqOLNaAJBRrg6gdl6hHU6etSSQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8aSyB1syrTSUCSyaCS3rQou5EOvIKYWltDVBL3921pmPQmXMYySaZOV593VQZxsc20tOnJU9g7VN4UDR5R39Zal495GsJxRCoXXv5hKS7IW4sJ0liTe9DK3CtyU8pzAiLVXJFPtvL4zCrMd/unZB9BFovb5Xco/rXv3AN+hTB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from simon-Latitude-5450.cni.e-technik.tu-dortmund.de ([129.217.186.248])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.10/8.18.1.10) with ESMTPSA id 5AKFTu8E005406
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 20 Nov 2025 16:29:58 +0100 (CET)
From: Simon Schippers <simon.schippers@tu-dortmund.de>
To: willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
        andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mst@redhat.com,
        eperezma@redhat.com, jon@nutanix.com, tim.gebauer@tu-dortmund.de,
        simon.schippers@tu-dortmund.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux.dev
Subject: [PATCH net-next v6 4/8] tun/tap: add batched ring consume function
Date: Thu, 20 Nov 2025 16:29:09 +0100
Message-ID: <20251120152914.1127975-5-simon.schippers@tu-dortmund.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251120152914.1127975-1-simon.schippers@tu-dortmund.de>
References: <20251120152914.1127975-1-simon.schippers@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add tun_ring_consume_batched() and tap_ring_consume_batched() to allow
consuming multiple items from the respective ring buffer in a single lock
acquisition. Heavily inspired by ptr_ring_consume_batched() and will be
used for bulk dequeue operations (e.g. vhost-net).

Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Co-developed by: Jon Kohler <jon@nutanix.com>
Signed-off-by: Jon Kohler <jon@nutanix.com>
Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
---
 drivers/net/tap.c      | 21 +++++++++++++++++++++
 drivers/net/tun.c      | 21 +++++++++++++++++++++
 include/linux/if_tap.h |  6 ++++++
 include/linux/if_tun.h |  7 +++++++
 4 files changed, 55 insertions(+)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index c370a02789eb..01717c8fd284 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -816,6 +816,27 @@ static __always_unused void *tap_ring_consume(struct tap_queue *q)
 	return ptr;
 }
 
+int tap_ring_consume_batched(struct file *file, void **array, int n)
+{
+	struct tap_queue *q = file->private_data;
+	void *ptr;
+	int i;
+
+	spin_lock(&q->ring.consumer_lock);
+
+	for (i = 0; i < n; i++) {
+		ptr = __tap_ring_consume(q);
+		if (!ptr)
+			break;
+		array[i] = ptr;
+	}
+
+	spin_unlock(&q->ring.consumer_lock);
+
+	return i;
+}
+EXPORT_SYMBOL_GPL(tap_ring_consume_batched);
+
 static ssize_t tap_do_read(struct tap_queue *q,
 			   struct iov_iter *to,
 			   int noblock, struct sk_buff *skb)
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 3b9d8d406ff5..42df185341ad 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3816,6 +3816,27 @@ struct socket *tun_get_socket(struct file *file)
 }
 EXPORT_SYMBOL_GPL(tun_get_socket);
 
+int tun_ring_consume_batched(struct file *file, void **array, int n)
+{
+	struct tun_file *tfile = file->private_data;
+	void *ptr;
+	int i;
+
+	spin_lock(&tfile->tx_ring.consumer_lock);
+
+	for (i = 0; i < n; i++) {
+		ptr = __tun_ring_consume(tfile);
+		if (!ptr)
+			break;
+		array[i] = ptr;
+	}
+
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


