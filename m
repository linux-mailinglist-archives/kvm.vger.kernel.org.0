Return-Path: <kvm+bounces-67283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FE14D001E3
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 22:15:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5CFA330090F1
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 21:15:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5369B341AD8;
	Wed,  7 Jan 2026 21:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="m+0kD3JN"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4337321428;
	Wed,  7 Jan 2026 21:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767819979; cv=none; b=BFwdzF9zA7hKYC2LL+GAtwC5amDQb/DrewHjwEJDxpJ8SIE4205S/bHraiNkbG44tHsmvh2gRwo97gW2mUSd5nhXonqtHdjMbSGbzAY+Kg6kNfnqHrBVaIGiabNswGQJQevYUyRLILjLGHEgFnam0UhbC+cI+diP8kH89Yzjsdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767819979; c=relaxed/simple;
	bh=jJEomV68RwsvP53WBudoctRPvBFglCe7Oe95ccXv+98=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lRIj7Qd6uoV/kiBTR4KoZa1uEfY7+fLkCb5uO/FGHpxkxzYTh2818+4tOfApL3su31bO6STMVjjHdzA5W9hvpADG1qd+9C1WGcP82lwopn2VUY7kUgVuoPlJU459SEaLiXWnLffVkL0+4OUPY92Z65BF+iv5chN5FLZJDFAQRr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=m+0kD3JN; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from simon-Latitude-5450.fritz.box (p5dc880d2.dip0.t-ipconnect.de [93.200.128.210])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.16/8.18.1.16) with ESMTPSA id 607L5t9J026667
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 7 Jan 2026 22:06:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1767819960;
	bh=jJEomV68RwsvP53WBudoctRPvBFglCe7Oe95ccXv+98=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=m+0kD3JNyvTIIinmt68ZFElyRLtdu4hok1yqyuwxcl3jtM52HmJ81rhSB5Kz3jgNV
	 /Q8UxAF9sb7vw1mCNjK8U+yg6en23U9ctS4WZx8y+bsAvDd92/rTiM8msXyasyBeNM
	 E1PiTD0RoCz9VF6WGqpN2jRppraZx9YX5bLYlp5o=
From: Simon Schippers <simon.schippers@tu-dortmund.de>
To: willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
        andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mst@redhat.com,
        eperezma@redhat.com, leiyang@redhat.com, stephen@networkplumber.org,
        jon@nutanix.com, tim.gebauer@tu-dortmund.de,
        simon.schippers@tu-dortmund.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux.dev
Subject: [PATCH net-next v7 2/9] ptr_ring: add helper to detect newly freed space on consume
Date: Wed,  7 Jan 2026 22:04:41 +0100
Message-ID: <20260107210448.37851-3-simon.schippers@tu-dortmund.de>
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

This proposed function checks whether __ptr_ring_zero_tail() was invoked
within the last n calls to __ptr_ring_consume(), which indicates that new
free space was created. Since __ptr_ring_zero_tail() moves the tail to
the head - and no other function modifies either the head or the tail,
aside from the wrap-around case described below - detecting such a
movement is sufficient to detect the invocation of
__ptr_ring_zero_tail().

The implementation detects this movement by checking whether the tail is
at most n positions behind the head. If this condition holds, the shift
of the tail to its current position must have occurred within the last n
calls to __ptr_ring_consume(), indicating that __ptr_ring_zero_tail() was
invoked and that new free space was created.

This logic also correctly handles the wrap-around case in which
__ptr_ring_zero_tail() is invoked and the head and the tail are reset
to 0. Since this reset likewise moves the tail to the head, the same
detection logic applies.

Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
---
 include/linux/ptr_ring.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
index a5a3fa4916d3..7cdae6d1d400 100644
--- a/include/linux/ptr_ring.h
+++ b/include/linux/ptr_ring.h
@@ -438,6 +438,19 @@ static inline int ptr_ring_consume_batched_bh(struct ptr_ring *r,
 	return ret;
 }
 
+/* Returns true if the consume of the last n elements has created space
+ * in the ring buffer (i.e., a new element can be produced).
+ *
+ * Note: Because of batching, a successful call to __ptr_ring_consume() /
+ * __ptr_ring_consume_batched() does not guarantee that the next call to
+ * __ptr_ring_produce() will succeed.
+ */
+static inline bool __ptr_ring_consume_created_space(struct ptr_ring *r,
+						    int n)
+{
+	return r->consumer_head - r->consumer_tail < n;
+}
+
 /* Cast to structure type and call a function without discarding from FIFO.
  * Function must return a value.
  * Callers must take consumer_lock.
-- 
2.43.0


