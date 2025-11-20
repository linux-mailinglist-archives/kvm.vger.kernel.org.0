Return-Path: <kvm+bounces-63879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CC8C7C7519B
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 16:47:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 05CA7362EA5
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 15:38:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 386A63AA195;
	Thu, 20 Nov 2025 15:30:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD82436C0BF;
	Thu, 20 Nov 2025 15:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763652612; cv=none; b=OlmOAd+H021XsmuwzM/OQYvrndE8lexieojrEWxMUSIvTCa4Vns4BVMbVSBMIfkjaA4Cg5grod+XtrQ8UQnj0UXFtAXmC+uIQGjlhBUtstzKQOrC/nA5KGimo9d+Ymu+hYKj3si1OXv3gtKF/sq2o0wkxdq+qF32MICK0BMsJGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763652612; c=relaxed/simple;
	bh=6DGyWUwfWBo3+7vPw1G3Yayb2lMMOQLoHAP+Dn91EbI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MbN/FXoOKZILXqekMGwenBN1YhWTtRqCW762G7vaZwtoILZkdloLHZq9HAU0yGcaq/DPLNxpdXmGTTHhlK20lt7UdSiNf6JMETdP5zJVnfPavpeNiiKEBoN1oKdJAD753KSMlnjibXfdPonYl7g1vS87G7NiU1K4sXD1SJSYqNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from simon-Latitude-5450.cni.e-technik.tu-dortmund.de ([129.217.186.248])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.10/8.18.1.10) with ESMTPSA id 5AKFTu8G005406
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
Subject: [PATCH net-next v6 5/8] tun/tap: add uncomsume function for returning entries to ring
Date: Thu, 20 Nov 2025 16:29:10 +0100
Message-ID: <20251120152914.1127975-6-simon.schippers@tu-dortmund.de>
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

Add tun_ring_unconsume() and tap_ring_unconsume() wrappers to allow
external modules (e.g. vhost-net) to return previously consumed entries
back to the ring. This complements tun_ring_consume_batched() and
tap_ring_consume_batched() and enables proper error handling when
consumed packets need to be rolled back.

The functions delegate to ptr_ring_unconsume() and take a destroy
callback for entries that cannot be returned to the ring.

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
index 01717c8fd284..0069e2f177f4 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -837,6 +837,16 @@ int tap_ring_consume_batched(struct file *file, void **array, int n)
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
index 42df185341ad..bf109440d2c7 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3837,6 +3837,16 @@ int tun_ring_consume_batched(struct file *file, void **array, int n)
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


