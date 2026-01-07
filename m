Return-Path: <kvm+bounces-67285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 57C81D00247
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 22:20:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E93CD30456AC
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 21:18:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77386342513;
	Wed,  7 Jan 2026 21:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="rhWxugf0"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D422833AD9E;
	Wed,  7 Jan 2026 21:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767819980; cv=none; b=J2354vCq5WCYgt7PVLKCwkzEh1dTQMK9MXPWjmF9oA7+TXoJWcj/tauE3f+hBDaxppPFwzqmIXBQye8LCp97m4r8/GzoKPVGevtlAeUP/JZ/OaSNctTnrQliLd8V8uUnjXkYIZcwGORhe2B4sA9p3WM+lphrOxs3yQAxwB5l/Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767819980; c=relaxed/simple;
	bh=uzllYQOl4EpJPNyCjjkXSvTvdwq8YWcwQkZuwDteH4A=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mYzs3unnpea41tX1bKJoZaszAl8DNYS5bVl9RS4D5K2Q/cQ8qZVqZ6JpmBkZFUq6+mB1gNJ+ErfMrprulOaRyanGgDBKcaa+jVMvRAlK627B3aF6Gy4pOPVN0P7oPbKkytxEDtB5SOlJuzaakD+ABaUruaw3KgAroFwjFLc4OVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=rhWxugf0; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from simon-Latitude-5450.fritz.box (p5dc880d2.dip0.t-ipconnect.de [93.200.128.210])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.16/8.18.1.16) with ESMTPSA id 607L5t9V026667
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 7 Jan 2026 22:06:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1767819964;
	bh=uzllYQOl4EpJPNyCjjkXSvTvdwq8YWcwQkZuwDteH4A=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=rhWxugf0Qdwjzfh69CGytGHf0e5aioOwvsXeHk9GSeA8O/XJY77wa07PMHsxiX0AB
	 cB8bb907oB4dWUMx7E1LR/GMCsw7rQYvwIUjHrTzK/p5qWZ8GVeh4Txfc9rh0jYKvs
	 YXX2+t7Jgjcvrp+kiDkuLFu7qxQxDSrTFj0go3ic=
From: Simon Schippers <simon.schippers@tu-dortmund.de>
To: willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
        andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mst@redhat.com,
        eperezma@redhat.com, leiyang@redhat.com, stephen@networkplumber.org,
        jon@nutanix.com, tim.gebauer@tu-dortmund.de,
        simon.schippers@tu-dortmund.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux.dev
Subject: [PATCH net-next v7 8/9] tun/tap: drop get ring exports
Date: Wed,  7 Jan 2026 22:04:47 +0100
Message-ID: <20260107210448.37851-9-simon.schippers@tu-dortmund.de>
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

tun_get_tx_ring and tap_get_ptr_ring no longer have in-tree consumers and
can be dropped.

Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Co-developed by: Jon Kohler <jon@nutanix.com>
Signed-off-by: Jon Kohler <jon@nutanix.com>
Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
---
 drivers/net/tap.c      | 13 -------------
 drivers/net/tun.c      | 13 -------------
 include/linux/if_tap.h |  5 -----
 include/linux/if_tun.h |  6 ------
 4 files changed, 37 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index cf19d7181c2f..8821f26d0baa 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1230,19 +1230,6 @@ struct socket *tap_get_socket(struct file *file)
 }
 EXPORT_SYMBOL_GPL(tap_get_socket);
 
-struct ptr_ring *tap_get_ptr_ring(struct file *file)
-{
-	struct tap_queue *q;
-
-	if (file->f_op != &tap_fops)
-		return ERR_PTR(-EINVAL);
-	q = file->private_data;
-	if (!q)
-		return ERR_PTR(-EBADFD);
-	return &q->ring;
-}
-EXPORT_SYMBOL_GPL(tap_get_ptr_ring);
-
 bool tap_is_tap_file(struct file *file)
 {
 	struct tap_queue *q;
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 9d6f98e00661..71b6981d07d7 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3769,19 +3769,6 @@ void tun_ring_unconsume(struct file *file, void **batch, int n,
 }
 EXPORT_SYMBOL_GPL(tun_ring_unconsume);
 
-struct ptr_ring *tun_get_tx_ring(struct file *file)
-{
-	struct tun_file *tfile;
-
-	if (file->f_op != &tun_fops)
-		return ERR_PTR(-EINVAL);
-	tfile = file->private_data;
-	if (!tfile)
-		return ERR_PTR(-EBADFD);
-	return &tfile->tx_ring;
-}
-EXPORT_SYMBOL_GPL(tun_get_tx_ring);
-
 bool tun_is_tun_file(struct file *file)
 {
 	struct tun_file *tfile;
diff --git a/include/linux/if_tap.h b/include/linux/if_tap.h
index 14194342b784..0e427b979c11 100644
--- a/include/linux/if_tap.h
+++ b/include/linux/if_tap.h
@@ -10,7 +10,6 @@ struct socket;
 
 #if IS_ENABLED(CONFIG_TAP)
 struct socket *tap_get_socket(struct file *);
-struct ptr_ring *tap_get_ptr_ring(struct file *file);
 int tap_ring_consume_batched(struct file *file, void **array, int n);
 void tap_ring_unconsume(struct file *file, void **batch, int n,
 			void (*destroy)(void *));
@@ -22,10 +21,6 @@ static inline struct socket *tap_get_socket(struct file *f)
 {
 	return ERR_PTR(-EINVAL);
 }
-static inline struct ptr_ring *tap_get_ptr_ring(struct file *f)
-{
-	return ERR_PTR(-EINVAL);
-}
 static inline int tap_ring_consume_batched(struct file *f,
 					   void **array, int n)
 {
diff --git a/include/linux/if_tun.h b/include/linux/if_tun.h
index 0910c6dbac20..80b734173a80 100644
--- a/include/linux/if_tun.h
+++ b/include/linux/if_tun.h
@@ -21,7 +21,6 @@ struct tun_msg_ctl {
 
 #if defined(CONFIG_TUN) || defined(CONFIG_TUN_MODULE)
 struct socket *tun_get_socket(struct file *);
-struct ptr_ring *tun_get_tx_ring(struct file *file);
 int tun_ring_consume_batched(struct file *file, void **array, int n);
 void tun_ring_unconsume(struct file *file, void **batch, int n,
 			void (*destroy)(void *));
@@ -54,11 +53,6 @@ static inline struct socket *tun_get_socket(struct file *f)
 	return ERR_PTR(-EINVAL);
 }
 
-static inline struct ptr_ring *tun_get_tx_ring(struct file *f)
-{
-	return ERR_PTR(-EINVAL);
-}
-
 static inline int tun_ring_consume_batched(struct file *file,
 					   void **array, int n)
 {
-- 
2.43.0


