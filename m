Return-Path: <kvm+bounces-58421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7771AB93767
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 00:18:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 334BD3AFCF2
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 22:18:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B083631DDBD;
	Mon, 22 Sep 2025 22:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="KLvgS0qH"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CD627CCC4;
	Mon, 22 Sep 2025 22:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758579432; cv=none; b=F8Js72J7/SX3cvmbuX1GAmWPH2n2guP2fZCnDBFlYbCRa9vzObHdQf8/BTWl0+gR5PuSwoTCJ38p8AONetgZBmk40uiENCL3RAtzkSeVN9PWdys8P+cWB02G6eMoHnSRQXSV7qnZWSTePnYm/8rx8dxgQU3fqmKskkDMg9sPvM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758579432; c=relaxed/simple;
	bh=FQr4aqspFo4pzDG4qZKffIA+U/BJaMqCuzjHpZXtlkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CwaJqoFX6yuXYhOUIBV7LCog6EOBzUxq3TOFljCpFA5oKO5YWCQysXgZtqpQWx73+PAelXTZV3U1vEQKzbQPtPrKvbAMRsmHGdZBsh3A4AiN27kl3kIu7dt7UAcBmIFesuX+8xtbXHYtA6rk92mb4JEut8TcLu+zgwiSaVEUk/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=KLvgS0qH; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from simon-Latitude-5450.fritz.box (p5dc88066.dip0.t-ipconnect.de [93.200.128.102])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.10/8.18.1.10) with ESMTPSA id 58MMH4ej003919
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 23 Sep 2025 00:17:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1758579427;
	bh=FQr4aqspFo4pzDG4qZKffIA+U/BJaMqCuzjHpZXtlkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KLvgS0qH1N3gQlDkECju6/5BCwkyyM9POm4wwTtVUgXvhUEsm7WSxXocUxzUJhiQZ
	 lpZ22VhN5NBWdZ4nXYpuGv+uacEw4h6x45mS0jtoqvzXeVIxRKVe6yuRCyzH5mz7ln
	 kek1ekbNnUC7RQEqlBUyBtnJ5Dckx/il8fV8GHkQ=
From: Simon Schippers <simon.schippers@tu-dortmund.de>
To: willemdebruijn.kernel@gmail.com, jasowang@redhat.com, mst@redhat.com,
        eperezma@redhat.com, stephen@networkplumber.org, leiyang@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux.dev, kvm@vger.kernel.org
Cc: Simon Schippers <simon.schippers@tu-dortmund.de>,
        Tim Gebauer <tim.gebauer@tu-dortmund.de>
Subject: [PATCH net-next v5 6/8] TUN & TAP: Provide ptr_ring_unconsume wrappers for vhost_net
Date: Tue, 23 Sep 2025 00:15:51 +0200
Message-ID: <20250922221553.47802-7-simon.schippers@tu-dortmund.de>
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

Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
---
 drivers/net/tap.c      | 9 +++++++++
 drivers/net/tun.c      | 9 +++++++++
 include/linux/if_tap.h | 4 ++++
 include/linux/if_tun.h | 5 +++++
 4 files changed, 27 insertions(+)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 651d48612329..9720481f6d41 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1268,6 +1268,15 @@ int tap_ring_consume_batched(struct file *file,
 }
 EXPORT_SYMBOL_GPL(tap_ring_consume_batched);
 
+void tap_ring_unconsume(struct file *file, void **batch, int n,
+			void (*destroy)(void *))
+{
+	struct tap_queue *q = file->private_data;
+
+	ptr_ring_unconsume(&q->ring, batch, n, destroy);
+}
+EXPORT_SYMBOL_GPL(tap_ring_unconsume);
+
 struct ptr_ring *tap_get_ptr_ring(struct file *file)
 {
 	struct tap_queue *q;
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 7566b22780fb..25b170e903e1 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3813,6 +3813,15 @@ int tun_ring_consume_batched(struct file *file,
 }
 EXPORT_SYMBOL_GPL(tun_ring_consume_batched);
 
+void tun_ring_unconsume(struct file *file, void **batch, int n,
+			void (*destroy)(void *))
+{
+	struct tun_file *tfile = file->private_data;
+
+	ptr_ring_unconsume(&tfile->tx_ring, batch, n, destroy);
+}
+EXPORT_SYMBOL_GPL(tun_ring_unconsume);
+
 struct ptr_ring *tun_get_tx_ring(struct file *file)
 {
 	struct tun_file *tfile;
diff --git a/include/linux/if_tap.h b/include/linux/if_tap.h
index 2e5542d6aef4..0cf8cf200d52 100644
--- a/include/linux/if_tap.h
+++ b/include/linux/if_tap.h
@@ -12,6 +12,8 @@ struct socket;
 struct socket *tap_get_socket(struct file *);
 struct ptr_ring *tap_get_ptr_ring(struct file *file);
 int tap_ring_consume_batched(struct file *file, void **array, int n);
+void tap_ring_unconsume(struct file *file, void **batch, int n,
+				void (*destroy)(void *));
 #else
 #include <linux/err.h>
 #include <linux/errno.h>
@@ -28,6 +30,8 @@ static inline int tap_ring_consume_batched(struct file *f,
 {
 	return 0;
 }
+static inline void tap_ring_unconsume(struct file *file, void **batch,
+					int n, void (*destroy)(void *)) {}
 #endif /* CONFIG_TAP */
 
 /*
diff --git a/include/linux/if_tun.h b/include/linux/if_tun.h
index 5b41525ac007..bd954bb117e8 100644
--- a/include/linux/if_tun.h
+++ b/include/linux/if_tun.h
@@ -23,6 +23,8 @@ struct tun_msg_ctl {
 struct socket *tun_get_socket(struct file *);
 struct ptr_ring *tun_get_tx_ring(struct file *file);
 int tun_ring_consume_batched(struct file *file, void **array, int n);
+void tun_ring_unconsume(struct file *file, void **batch, int n,
+				void (*destroy)(void *));
 
 static inline bool tun_is_xdp_frame(void *ptr)
 {
@@ -62,6 +64,9 @@ static inline int tun_ring_consume_batched(struct file *file,
 	return 0;
 }
 
+static inline void tun_ring_unconsume(struct file *file, void **batch,
+					int n, void (*destroy)(void *)) {}
+
 static inline bool tun_is_xdp_frame(void *ptr)
 {
 	return false;
-- 
2.43.0


