Return-Path: <kvm+bounces-58423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7838FB93776
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 00:19:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22E801907E03
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 22:19:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48BC931FEED;
	Mon, 22 Sep 2025 22:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="AJhE/F+s"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2AF3285058;
	Mon, 22 Sep 2025 22:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758579433; cv=none; b=EWUr6sLHFOTb8d4PAuOJKSwyGCGOmKwIvvi5o6TuDT9aSosnPn3RxJIr7261WQM23w7kDJxcgt7c5mu9XMi/w3ZhhpW+C0mZLU7eNiIXGN4edoL6GZJTA374tbPTd8x4/je/ORxGRA4M2Ld2tdqB7ea1gxdM34rE/4IcLJflKYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758579433; c=relaxed/simple;
	bh=Afxt95rlvAp2SeBhWrokAWqs1WgjIzNOiYGHEG2MVqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8Ql6a5V0z+05dgeJO2l4TFc1dnrlqPtBX2AG7Qk5W9N8wBodXGBEpSpDLVIVjdYUlajkzKZrkZL1974k+KW65qZgWt4PfoTtHugCDlpKxSLg1rvS9M2LbAtqfm3PFhkL97dFSYlwh7JPChFv70LVlbb8AHgKZqR/xzC7ZutqYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=AJhE/F+s; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from simon-Latitude-5450.fritz.box (p5dc88066.dip0.t-ipconnect.de [93.200.128.102])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.10/8.18.1.10) with ESMTPSA id 58MMH4el003919
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 23 Sep 2025 00:17:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1758579427;
	bh=Afxt95rlvAp2SeBhWrokAWqs1WgjIzNOiYGHEG2MVqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AJhE/F+sA9PKME6F+dmp1BbEb9uAFG/REWZLE5qWkGkMJmrIWVY0Zmg9cvHQxdvND
	 lUliusnBa7TOy+2LUcnp66LFfCIBphQQt9Q/C9rAA6Ou3CqhP1n86RTfSTUR8ZdeaD
	 LBKwGVIIVk/wgpEP52sq6XyNDASu5forIDtSjJZQ=
From: Simon Schippers <simon.schippers@tu-dortmund.de>
To: willemdebruijn.kernel@gmail.com, jasowang@redhat.com, mst@redhat.com,
        eperezma@redhat.com, stephen@networkplumber.org, leiyang@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux.dev, kvm@vger.kernel.org
Cc: Simon Schippers <simon.schippers@tu-dortmund.de>,
        Tim Gebauer <tim.gebauer@tu-dortmund.de>
Subject: [PATCH net-next v5 7/8] TUN & TAP: Methods to determine whether file is TUN/TAP for vhost_net
Date: Tue, 23 Sep 2025 00:15:52 +0200
Message-ID: <20250922221553.47802-8-simon.schippers@tu-dortmund.de>
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

Those wrappers are inspired by tun_get_tx_ring/tap_get_tx_ring and replace
those methods.

Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
---
 drivers/net/tap.c      | 10 +++++-----
 drivers/net/tun.c      | 10 +++++-----
 include/linux/if_tap.h |  5 +++++
 include/linux/if_tun.h |  6 ++++++
 4 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 9720481f6d41..8d3e74330309 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1277,18 +1277,18 @@ void tap_ring_unconsume(struct file *file, void **batch, int n,
 }
 EXPORT_SYMBOL_GPL(tap_ring_unconsume);
 
-struct ptr_ring *tap_get_ptr_ring(struct file *file)
+bool is_tap_file(struct file *file)
 {
 	struct tap_queue *q;
 
 	if (file->f_op != &tap_fops)
-		return ERR_PTR(-EINVAL);
+		return false;
 	q = file->private_data;
 	if (!q)
-		return ERR_PTR(-EBADFD);
-	return &q->ring;
+		return false;
+	return true;
 }
-EXPORT_SYMBOL_GPL(tap_get_ptr_ring);
+EXPORT_SYMBOL_GPL(is_tap_file);
 
 int tap_queue_resize(struct tap_dev *tap)
 {
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 25b170e903e1..b0193b06fedc 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3822,18 +3822,18 @@ void tun_ring_unconsume(struct file *file, void **batch, int n,
 }
 EXPORT_SYMBOL_GPL(tun_ring_unconsume);
 
-struct ptr_ring *tun_get_tx_ring(struct file *file)
+bool is_tun_file(struct file *file)
 {
 	struct tun_file *tfile;
 
 	if (file->f_op != &tun_fops)
-		return ERR_PTR(-EINVAL);
+		return false;
 	tfile = file->private_data;
 	if (!tfile)
-		return ERR_PTR(-EBADFD);
-	return &tfile->tx_ring;
+		return false;
+	return true;
 }
-EXPORT_SYMBOL_GPL(tun_get_tx_ring);
+EXPORT_SYMBOL_GPL(is_tun_file);
 
 module_init(tun_init);
 module_exit(tun_cleanup);
diff --git a/include/linux/if_tap.h b/include/linux/if_tap.h
index 0cf8cf200d52..5bbcc8611bf5 100644
--- a/include/linux/if_tap.h
+++ b/include/linux/if_tap.h
@@ -14,6 +14,7 @@ struct ptr_ring *tap_get_ptr_ring(struct file *file);
 int tap_ring_consume_batched(struct file *file, void **array, int n);
 void tap_ring_unconsume(struct file *file, void **batch, int n,
 				void (*destroy)(void *));
+bool is_tap_file(struct file *file);
 #else
 #include <linux/err.h>
 #include <linux/errno.h>
@@ -32,6 +33,10 @@ static inline int tap_ring_consume_batched(struct file *f,
 }
 static inline void tap_ring_unconsume(struct file *file, void **batch,
 					int n, void (*destroy)(void *)) {}
+static inline bool is_tap_file(struct file *f)
+{
+	return false;
+}
 #endif /* CONFIG_TAP */
 
 /*
diff --git a/include/linux/if_tun.h b/include/linux/if_tun.h
index bd954bb117e8..869d61898e60 100644
--- a/include/linux/if_tun.h
+++ b/include/linux/if_tun.h
@@ -25,6 +25,7 @@ struct ptr_ring *tun_get_tx_ring(struct file *file);
 int tun_ring_consume_batched(struct file *file, void **array, int n);
 void tun_ring_unconsume(struct file *file, void **batch, int n,
 				void (*destroy)(void *));
+bool is_tun_file(struct file *file);
 
 static inline bool tun_is_xdp_frame(void *ptr)
 {
@@ -67,6 +68,11 @@ static inline int tun_ring_consume_batched(struct file *file,
 static inline void tun_ring_unconsume(struct file *file, void **batch,
 					int n, void (*destroy)(void *)) {}
 
+static inline bool is_tun_file(struct file *f)
+{
+	return false;
+}
+
 static inline bool tun_is_xdp_frame(void *ptr)
 {
 	return false;
-- 
2.43.0


