Return-Path: <kvm+bounces-63880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EB13C75204
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 16:50:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F22624E83C2
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 15:38:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B1D53AA197;
	Thu, 20 Nov 2025 15:30:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD42E362142;
	Thu, 20 Nov 2025 15:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763652612; cv=none; b=QTpbSfS8b179I3rd06TOxktDQe5uGQL20oGIWHin+KD+fbOeLyZji0644tkN80E9Y9DyN9OLgw6SD1Ws8czAVpIKD0Z8PafWN451N1uMswgmeFD1IOQ0Ze9c5aNHYDpAPx5WRlfuEA75h0X5OPBoH8MV4Kykb2rRkLQB8pE/xp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763652612; c=relaxed/simple;
	bh=U9t5oLzGz4iUlyCzXw9AamE2kTpysWzst4o/hBapGvU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWJiJuRc/7sxzgKcyxlYdi9R8eE5/lFn9ssLGUqTNxM291UTy+RRpxUvaRJaI8IFdSR8NqSmsKTbrygbE5bbKFAbcdQnCK2Ysau10G/1KWiOzV2ZK52PRdJHKCut+oTm3g8Kh/4E/uir56Mp8ktOqe4IP5M44sEpQSjiOY5n+Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from simon-Latitude-5450.cni.e-technik.tu-dortmund.de ([129.217.186.248])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.10/8.18.1.10) with ESMTPSA id 5AKFTu88005406
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
Subject: [PATCH net-next v6 1/8] ptr_ring: add __ptr_ring_full_next() to predict imminent fullness
Date: Thu, 20 Nov 2025 16:29:06 +0100
Message-ID: <20251120152914.1127975-2-simon.schippers@tu-dortmund.de>
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

Introduce the __ptr_ring_full_next() helper, which lets callers check
if the ptr_ring will become full after the next insertion. This is useful
for proactively managing capacity before the ring is actually full.
Callers must ensure the ring is not already full before using this
helper. This is because __ptr_ring_discard_one() may zero entries in
reverse order, the slot after the current producer position may be
cleared before the current one. This must be considered when using this
check.

Note: This function is especially relevant when paired with the memory
ordering guarantees of __ptr_ring_produce() (smp_wmb()), allowing for
safe producer/consumer coordination.

Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Co-developed-by: Jon Kohler <jon@nutanix.com>
Signed-off-by: Jon Kohler <jon@nutanix.com>
Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
---
 include/linux/ptr_ring.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
index 534531807d95..da141cc8b075 100644
--- a/include/linux/ptr_ring.h
+++ b/include/linux/ptr_ring.h
@@ -96,6 +96,31 @@ static inline bool ptr_ring_full_bh(struct ptr_ring *r)
 	return ret;
 }
 
+/*
+ * Checks if the ptr_ring will become full after the next insertion.
+ *
+ * Note: Callers must ensure that the ptr_ring is not full before calling
+ * this function, as __ptr_ring_discard_one invalidates entries in
+ * reverse order. Because the next entry (rather than the current one)
+ * may be zeroed after an insertion, failing to account for this can
+ * cause false negatives when checking whether the ring will become full
+ * on the next insertion.
+ */
+static inline bool __ptr_ring_full_next(struct ptr_ring *r)
+{
+	int p;
+
+	if (unlikely(r->size <= 1))
+		return true;
+
+	p = r->producer + 1;
+
+	if (unlikely(p >= r->size))
+		p = 0;
+
+	return r->queue[p];
+}
+
 /* Note: callers invoking this in a loop must use a compiler barrier,
  * for example cpu_relax(). Callers must hold producer_lock.
  * Callers are responsible for making sure pointer that is being queued
-- 
2.43.0


