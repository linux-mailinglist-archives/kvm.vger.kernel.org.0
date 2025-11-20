Return-Path: <kvm+bounces-63877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 46EE9C75189
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 16:47:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 7594C35A70E
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 15:38:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9283F3A9BF9;
	Thu, 20 Nov 2025 15:30:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6A136C0B8;
	Thu, 20 Nov 2025 15:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763652611; cv=none; b=uqiO2T0yfrbXfmO1OhknLkK5HnVVyua9+x81OZvD7cQTrX8uWpf20PvYWVdzN+ozcmITRi+dA9olaKiKHQzmgVCt5AX3KPxdon4Rp9n4n8TB9vcTdb6KBJGNOr9YF1ftPyLaoSy2pnv6xTPSF66EW6rK3ivXJpOugmRDe0rZX/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763652611; c=relaxed/simple;
	bh=o11qLwNcBKRq43vXL1knObjQnbaEiUOeKPlAag70zJQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=El6zeRBekIPGpiDtLxwV6Ay5/CV3HgW9leONqvgi6Br0zMRj+MMh7cwt8UYb8ElpaN0FoPyLt2ShtBOY0dbkr1kgt6AfJe1Dt7ub24KhtxK5Ad+S3Bh7t5VocJMp4Zu53VsnpJGimuG6gF1z6Oh8d/yB4BUdDPNdumfdqJ3yAcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from simon-Latitude-5450.cni.e-technik.tu-dortmund.de ([129.217.186.248])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.10/8.18.1.10) with ESMTPSA id 5AKFTu8A005406
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
Subject: [PATCH net-next v6 2/8] ptr_ring: add helper to check if consume created space
Date: Thu, 20 Nov 2025 16:29:07 +0100
Message-ID: <20251120152914.1127975-3-simon.schippers@tu-dortmund.de>
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

Add __ptr_ring_consume_created_space() to check whether the previous
__ptr_ring_consume() call successfully consumed an element and created
space in the ring buffer. This enables callers to conditionally notify
producers when space becomes available.

The function is only valid immediately after a single consume operation
and should not be used after calling __ptr_ring_consume_batched().

Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Co-developed by: Jon Kohler <jon@nutanix.com>
Signed-off-by: Jon Kohler <jon@nutanix.com>
Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
---
 include/linux/ptr_ring.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
index da141cc8b075..76d6840b45a3 100644
--- a/include/linux/ptr_ring.h
+++ b/include/linux/ptr_ring.h
@@ -453,6 +453,23 @@ static inline int ptr_ring_consume_batched_bh(struct ptr_ring *r,
 	return ret;
 }
 
+/*
+ * Check if the previous consume operation created space
+ *
+ * Returns true if the last call to __ptr_ring_consume() has created
+ * space in the ring buffer (i.e., an element was consumed).
+ *
+ * Note: This function is only valid immediately after a single call to
+ * __ptr_ring_consume(). If multiple calls to ptr_ring_consume*() have
+ * been made, this check must be performed after each call individually.
+ * Likewise, do not use this function after calling
+ * __ptr_ring_consume_batched().
+ */
+static inline bool __ptr_ring_consume_created_space(struct ptr_ring *r)
+{
+	return r->consumer_tail >= r->consumer_head;
+}
+
 /* Cast to structure type and call a function without discarding from FIFO.
  * Function must return a value.
  * Callers must take consumer_lock.
-- 
2.43.0


