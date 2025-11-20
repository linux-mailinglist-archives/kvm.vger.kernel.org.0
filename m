Return-Path: <kvm+bounces-63874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id D4E76C751C8
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 16:49:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4EB074F0F3D
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 15:37:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB316393DCA;
	Thu, 20 Nov 2025 15:30:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0550435FF72;
	Thu, 20 Nov 2025 15:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763652611; cv=none; b=Mb6KAe66AlknyA0AJdzIYhJZdQhRkPTiUVEJaJQZnxsOTlV1H/00OzaX4HlEwSZVrsUlugKw20GG/kgTQVGkPQiBfw7UBLShZSXuttzlL1fd+fEADhOyQmGuzQtfjR0x2ZTYrmW7C8zisohUrNRKF7hAGcbohP7HaV3QS0NUBVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763652611; c=relaxed/simple;
	bh=M9BqjS78vJlMtvWvaK6+E01V48j5liMIIf/uZ5gvlXQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mlzt08wyV26GN8TWSGHd19pbCi7y4zmKqtOxjgkpyVprgt7pNl73Q9Pg8OAsCxvbuhO1fOhML3IChBKvOn8HQ5IZhTX4rsG72lpQhLMrrPrbgOejWSxwK2Kj2fjPkf8DtCyPytyQlXxx0rGXO5XwPj99pp0+E/mGN0JQ4q0vPdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from simon-Latitude-5450.cni.e-technik.tu-dortmund.de ([129.217.186.248])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.10/8.18.1.10) with ESMTPSA id 5AKFTu8I005406
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
Subject: [PATCH net-next v6 6/8] tun/tap: add helper functions to check file type
Date: Thu, 20 Nov 2025 16:29:11 +0100
Message-ID: <20251120152914.1127975-7-simon.schippers@tu-dortmund.de>
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

Add tun_is_tun_file() and tap_is_tap_file() helper functions to check if
a file is a TUN or TAP file, which will be utilized by vhost-net.

Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Co-developed by: Jon Kohler <jon@nutanix.com>
Signed-off-by: Jon Kohler <jon@nutanix.com>
Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
---
 drivers/net/tap.c      | 13 +++++++++++++
 drivers/net/tun.c      | 13 +++++++++++++
 include/linux/if_tap.h |  5 +++++
 include/linux/if_tun.h |  6 ++++++
 4 files changed, 37 insertions(+)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 0069e2f177f4..56b8fe376e4a 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1283,6 +1283,19 @@ struct ptr_ring *tap_get_ptr_ring(struct file *file)
 }
 EXPORT_SYMBOL_GPL(tap_get_ptr_ring);
 
+bool tap_is_tap_file(struct file *file)
+{
+	struct tap_queue *q;
+
+	if (file->f_op != &tap_fops)
+		return false;
+	q = file->private_data;
+	if (!q)
+		return false;
+	return true;
+}
+EXPORT_SYMBOL_GPL(tap_is_tap_file);
+
 int tap_queue_resize(struct tap_dev *tap)
 {
 	struct net_device *dev = tap->dev;
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index bf109440d2c7..dc2d267d30d7 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3860,6 +3860,19 @@ struct ptr_ring *tun_get_tx_ring(struct file *file)
 }
 EXPORT_SYMBOL_GPL(tun_get_tx_ring);
 
+bool tun_is_tun_file(struct file *file)
+{
+	struct tun_file *tfile;
+
+	if (file->f_op != &tun_fops)
+		return false;
+	tfile = file->private_data;
+	if (!tfile)
+		return false;
+	return true;
+}
+EXPORT_SYMBOL_GPL(tun_is_tun_file);
+
 module_init(tun_init);
 module_exit(tun_cleanup);
 MODULE_DESCRIPTION(DRV_DESCRIPTION);
diff --git a/include/linux/if_tap.h b/include/linux/if_tap.h
index 28326a69745a..14194342b784 100644
--- a/include/linux/if_tap.h
+++ b/include/linux/if_tap.h
@@ -14,6 +14,7 @@ struct ptr_ring *tap_get_ptr_ring(struct file *file);
 int tap_ring_consume_batched(struct file *file, void **array, int n);
 void tap_ring_unconsume(struct file *file, void **batch, int n,
 			void (*destroy)(void *));
+bool tap_is_tap_file(struct file *file);
 #else
 #include <linux/err.h>
 #include <linux/errno.h>
@@ -32,6 +33,10 @@ static inline int tap_ring_consume_batched(struct file *f,
 }
 static inline void tap_ring_unconsume(struct file *file, void **batch,
 				      int n, void (*destroy)(void *)) {}
+static inline bool tap_is_tap_file(struct file *f)
+{
+	return false;
+}
 #endif /* CONFIG_TAP */
 
 /*
diff --git a/include/linux/if_tun.h b/include/linux/if_tun.h
index 1274c6b34eb6..0910c6dbac20 100644
--- a/include/linux/if_tun.h
+++ b/include/linux/if_tun.h
@@ -25,6 +25,7 @@ struct ptr_ring *tun_get_tx_ring(struct file *file);
 int tun_ring_consume_batched(struct file *file, void **array, int n);
 void tun_ring_unconsume(struct file *file, void **batch, int n,
 			void (*destroy)(void *));
+bool tun_is_tun_file(struct file *file);
 
 static inline bool tun_is_xdp_frame(void *ptr)
 {
@@ -67,6 +68,11 @@ static inline int tun_ring_consume_batched(struct file *file,
 static inline void tun_ring_unconsume(struct file *file, void **batch,
 				      int n, void (*destroy)(void *)) {}
 
+static inline bool tun_is_tun_file(struct file *f)
+{
+	return false;
+}
+
 static inline bool tun_is_xdp_frame(void *ptr)
 {
 	return false;
-- 
2.43.0


