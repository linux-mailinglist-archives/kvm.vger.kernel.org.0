Return-Path: <kvm+bounces-67277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 652EBD002DD
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 22:34:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 52A593028FF2
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 21:30:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86A4B33C51B;
	Wed,  7 Jan 2026 21:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="lTDO/r9U"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA753A0B33;
	Wed,  7 Jan 2026 21:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767819978; cv=none; b=r11U4dauRE04ejvZzo35KaN6AvQt9KELkU0+bNJE6jZTQcn8UY1f1i6uQvFGdGvu4Nla3NRA6OxHQT/oTOQiXml6v0fDA7NpvYpzsC12TbLUFpr3n4b6aayu0/1xvX07C46/xibi3JjZU55DvdxxEVomIxN+uCyGY98enyn9XQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767819978; c=relaxed/simple;
	bh=i6EXM/dz88Cyoq8LtFGDSx5xkGpNbJe1oE+QY2KW7uQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKTV/gpk6n17oC04T781pji2k2OOEPtMCznJPuu7zHw1sOfnKB3gdsJ5FZZyv9Unw75xoINPncV35cgqZ6Ur5cQ1BJQJx3HdQa8Htsl5bW6OchTSr1PXupMOnhLPKA+KKt6TQeqS4gVRG+4EDrr/NtIo0iPiKXe7fgwK0JYhpxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=lTDO/r9U; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from simon-Latitude-5450.fritz.box (p5dc880d2.dip0.t-ipconnect.de [93.200.128.210])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.16/8.18.1.16) with ESMTPSA id 607L5t9H026667
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 7 Jan 2026 22:05:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1767819960;
	bh=i6EXM/dz88Cyoq8LtFGDSx5xkGpNbJe1oE+QY2KW7uQ=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=lTDO/r9UTXkuMXbSINWBD7E+CPaAPkqmT7IPIn58KsophOcArTZxKHTU3djCpgFqq
	 TdYgigqJn0aNSEmP5iFl+5fl1j5LKHt4H93NTZNuoBCUN4WrYK6rpmvqr04Lj4bs3S
	 IDJenQI6/2eFYftf8bS1pWX5Gs6mYRK21n9566BY=
From: Simon Schippers <simon.schippers@tu-dortmund.de>
To: willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
        andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mst@redhat.com,
        eperezma@redhat.com, leiyang@redhat.com, stephen@networkplumber.org,
        jon@nutanix.com, tim.gebauer@tu-dortmund.de,
        simon.schippers@tu-dortmund.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux.dev
Subject: [PATCH net-next v7 1/9] ptr_ring: move free-space check into separate helper
Date: Wed,  7 Jan 2026 22:04:40 +0100
Message-ID: <20260107210448.37851-2-simon.schippers@tu-dortmund.de>
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

This patch moves the check for available free space for a new entry into
a separate function. As a result, __ptr_ring_produce() remains logically
unchanged, while the new helper allows callers to determine in advance
whether subsequent __ptr_ring_produce() calls will succeed. This
information can, for example, be used to temporarily stop producing until
__ptr_ring_peek() indicates that space is available again.

Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
---
 include/linux/ptr_ring.h | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
index 534531807d95..a5a3fa4916d3 100644
--- a/include/linux/ptr_ring.h
+++ b/include/linux/ptr_ring.h
@@ -96,6 +96,14 @@ static inline bool ptr_ring_full_bh(struct ptr_ring *r)
 	return ret;
 }
 
+static inline int __ptr_ring_produce_peek(struct ptr_ring *r)
+{
+	if (unlikely(!r->size) || r->queue[r->producer])
+		return -ENOSPC;
+
+	return 0;
+}
+
 /* Note: callers invoking this in a loop must use a compiler barrier,
  * for example cpu_relax(). Callers must hold producer_lock.
  * Callers are responsible for making sure pointer that is being queued
@@ -103,8 +111,10 @@ static inline bool ptr_ring_full_bh(struct ptr_ring *r)
  */
 static inline int __ptr_ring_produce(struct ptr_ring *r, void *ptr)
 {
-	if (unlikely(!r->size) || r->queue[r->producer])
-		return -ENOSPC;
+	int p = __ptr_ring_produce_peek(r);
+
+	if (p)
+		return p;
 
 	/* Make sure the pointer we are storing points to a valid data. */
 	/* Pairs with the dependency ordering in __ptr_ring_consume. */
-- 
2.43.0


