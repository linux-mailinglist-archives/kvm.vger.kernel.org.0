Return-Path: <kvm+bounces-67282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FD0ED002EC
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 22:36:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C697330B65D6
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 21:31:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E837341AB6;
	Wed,  7 Jan 2026 21:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="JYyCYhjB"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3FD333AD95;
	Wed,  7 Jan 2026 21:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767819980; cv=none; b=P8ZP3WWO7X5lOLQAgkBEmn3eB9o5vtbdEYGUZQL0m68sWbg+3R2zMqacbtIqKSvVeg3+dMKcRODsRwkN+ExDe/kK0PMm+MkYG2UAgOEDhtfbf8mu22duJuLI0POtszIJFaKaAfg6WntC4W8DqPI6j0J3olewI5d5hg5niDRoEos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767819980; c=relaxed/simple;
	bh=KiuMB2Wyf6BiXs5XrrnUBgf1JzoWq8Vm5fO1hFPgi80=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DSizL2bgDK+cHgXnyHCpvW/ITKHTPG6TKd49CLDcg5/qOvHLtQCmZJaOVlXtoMD4sGd6ZVMh3rXhbB/8F/81WUj3GX4oVmtoyOUYAVz0nuE7k2tP0fsm+Ni/Na3oqSviP40g8PY/S8rbUHl9P4YG5PoWpQvb9YAGTt5Vnx/RZkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=JYyCYhjB; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from simon-Latitude-5450.fritz.box (p5dc880d2.dip0.t-ipconnect.de [93.200.128.210])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.16/8.18.1.16) with ESMTPSA id 607L5t9R026667
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 7 Jan 2026 22:06:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1767819963;
	bh=KiuMB2Wyf6BiXs5XrrnUBgf1JzoWq8Vm5fO1hFPgi80=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=JYyCYhjBhv2Gq6QHhleTfJlkZetlTFZT0fXfgujH+tsJqKII7pxujQw0IlbM0qacm
	 qoRF68BcXbYkKt8uapq6eX4cfRSb+VFwHtBNJb9q6JqvgHCjXUciv/oJ2SSpif+UGr
	 1yqkScOSPJ04xcng4DLlsuLnx8ohG+MCAjLWjAFQ=
From: Simon Schippers <simon.schippers@tu-dortmund.de>
To: willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
        andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mst@redhat.com,
        eperezma@redhat.com, leiyang@redhat.com, stephen@networkplumber.org,
        jon@nutanix.com, tim.gebauer@tu-dortmund.de,
        simon.schippers@tu-dortmund.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux.dev
Subject: [PATCH net-next v7 6/9] tun/tap: add helper functions to check file type
Date: Wed,  7 Jan 2026 22:04:45 +0100
Message-ID: <20260107210448.37851-7-simon.schippers@tu-dortmund.de>
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
index 4ffe4e95b5a6..cf19d7181c2f 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1243,6 +1243,19 @@ struct ptr_ring *tap_get_ptr_ring(struct file *file)
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
index d44d206c65e8..9d6f98e00661 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3782,6 +3782,19 @@ struct ptr_ring *tun_get_tx_ring(struct file *file)
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


