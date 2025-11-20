Return-Path: <kvm+bounces-63872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 08B7BC75030
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 16:37:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id B78292B458
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 15:36:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95B9F36C5AE;
	Thu, 20 Nov 2025 15:30:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD34535BDB1;
	Thu, 20 Nov 2025 15:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763652610; cv=none; b=AmBAx1xf0mubQREYXsgyCXuYy5iM/SXIG8su2bb40229G1/vIe4CurpuspGZA9U6zbWPhqAKH9yI63S1lsFdeaXCJA6YST1Gt7AseRxaRwqjqH2o1wgtHQoQ+dO1f22idgywxOAsN9LPU3uiNl1VYl+7kj87ri3YouCR7LnH7B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763652610; c=relaxed/simple;
	bh=WkaXo1wPGJMqku7JwsQP7qM8kSbPqip6CKc1p/DS4WQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IpoT+I1z8u1mlq/Do5YXNsi90T5907KTVN1+ij573roSo7QSaaEoYy1ajWTjq6yG8EaS7OQsgt6oO8G38aYR58QRgoGAuEtURRt7j3t/OWQPCGPkWdY/6rj9ctQgmKlQwlgnegkAirFbAv2osBE/03VTo8nrtOE1UZJODGqXdtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from simon-Latitude-5450.cni.e-technik.tu-dortmund.de ([129.217.186.248])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.10/8.18.1.10) with ESMTPSA id 5AKFTu8O005406
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
Subject: [PATCH net-next v6 8/8] tun/tap: drop get ring exports
Date: Thu, 20 Nov 2025 16:29:14 +0100
Message-ID: <20251120152914.1127975-10-simon.schippers@tu-dortmund.de>
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
index 2847db4e3cc7..fd87db829913 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1270,19 +1270,6 @@ struct socket *tap_get_socket(struct file *file)
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
index 9da6e794a80f..32f53e31a5a7 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3843,19 +3843,6 @@ void tun_ring_unconsume(struct file *file, void **batch, int n,
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


