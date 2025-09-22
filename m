Return-Path: <kvm+bounces-58417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AB3C5B93740
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 00:17:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E2562E101A
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 22:17:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 594BD31A7EB;
	Mon, 22 Sep 2025 22:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="suuYwj43"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0D6255222;
	Mon, 22 Sep 2025 22:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758579431; cv=none; b=ks65gAj/TD9X8vdSm8a0Izo10DCGCrNoJG4bQOe8jXFsr3txfgrJqq4McETgOa0lf5vtaq3JJ9DMc7oAl48PKJmeGVwgP6rT16G533sOAtZywU3GWkLP/9RkCrejTZ3uCW8qn0tgtz9+entQarbBjnjUFozlMD5/rj3A/1/nCPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758579431; c=relaxed/simple;
	bh=QoqqyIDfhdjjDER70xfzGzFdU7AlvujyerC0bCmeXjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZW4A5OPs/zbvy2Tzp/af5HSvXfCp6UQ03Vxdr8RepxX8nfQ1p37DEQLpcVoOg5HKAz+Wf6QKMGR/WBPhCiauW+b5es9j5n8hXBEJ7dIchLdJ865L0KKNp7kCp7GWf3ku+empkkDlApwTewiMkYFj6GK+6F9b9YWq/yBlF/5vqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=suuYwj43; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from simon-Latitude-5450.fritz.box (p5dc88066.dip0.t-ipconnect.de [93.200.128.102])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.10/8.18.1.10) with ESMTPSA id 58MMH4eb003919
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 23 Sep 2025 00:17:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1758579426;
	bh=QoqqyIDfhdjjDER70xfzGzFdU7AlvujyerC0bCmeXjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=suuYwj43EAFxjzMLFJkrca9BflhoZwAiR77pUapz/qtLEdGQXBo/bRZrtFj/TzzfM
	 Y4lh+FRTEGqg6cGM1T2d7PZQ0myO3BH1j5J6kHcxYkUp1pYeEXtCh3nzB2ht6SGMpW
	 t4k9Wx+Ac+fGfNqTZJMjTH/1a2C4UUt1ONesWRxw=
From: Simon Schippers <simon.schippers@tu-dortmund.de>
To: willemdebruijn.kernel@gmail.com, jasowang@redhat.com, mst@redhat.com,
        eperezma@redhat.com, stephen@networkplumber.org, leiyang@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux.dev, kvm@vger.kernel.org
Cc: Simon Schippers <simon.schippers@tu-dortmund.de>,
        Tim Gebauer <tim.gebauer@tu-dortmund.de>
Subject: [PATCH net-next v5 2/8] Move the decision of invalidation out of __ptr_ring_discard_one
Date: Tue, 23 Sep 2025 00:15:47 +0200
Message-ID: <20250922221553.47802-3-simon.schippers@tu-dortmund.de>
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

__ptr_ring_will_invalidate is useful if the caller would like to act
before entries of the ptr_ring get invalidated by __ptr_ring_discard_one.

__ptr_ring_consume calls the new method and passes the result to
__ptr_ring_discard_one, preserving the pre-patch logic.

Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
---
 include/linux/ptr_ring.h | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
index c45e95071d7e..78fb3efedc7a 100644
--- a/include/linux/ptr_ring.h
+++ b/include/linux/ptr_ring.h
@@ -266,7 +266,22 @@ static inline bool ptr_ring_empty_bh(struct ptr_ring *r)
 }
 
 /* Must only be called after __ptr_ring_peek returned !NULL */
-static inline void __ptr_ring_discard_one(struct ptr_ring *r)
+static inline bool __ptr_ring_will_invalidate(struct ptr_ring *r)
+{
+	/* Once we have processed enough entries invalidate them in
+	 * the ring all at once so producer can reuse their space in the ring.
+	 * We also do this when we reach end of the ring - not mandatory
+	 * but helps keep the implementation simple.
+	 */
+	int consumer_head = r->consumer_head + 1;
+
+	return consumer_head - r->consumer_tail >= r->batch ||
+		consumer_head >= r->size;
+}
+
+/* Must only be called after __ptr_ring_peek returned !NULL */
+static inline void __ptr_ring_discard_one(struct ptr_ring *r,
+					  bool invalidate)
 {
 	/* Fundamentally, what we want to do is update consumer
 	 * index and zero out the entry so producer can reuse it.
@@ -286,13 +301,7 @@ static inline void __ptr_ring_discard_one(struct ptr_ring *r)
 	int consumer_head = r->consumer_head;
 	int head = consumer_head++;
 
-	/* Once we have processed enough entries invalidate them in
-	 * the ring all at once so producer can reuse their space in the ring.
-	 * We also do this when we reach end of the ring - not mandatory
-	 * but helps keep the implementation simple.
-	 */
-	if (unlikely(consumer_head - r->consumer_tail >= r->batch ||
-		     consumer_head >= r->size)) {
+	if (unlikely(invalidate)) {
 		/* Zero out entries in the reverse order: this way we touch the
 		 * cache line that producer might currently be reading the last;
 		 * producer won't make progress and touch other cache lines
@@ -312,6 +321,7 @@ static inline void __ptr_ring_discard_one(struct ptr_ring *r)
 
 static inline void *__ptr_ring_consume(struct ptr_ring *r)
 {
+	bool invalidate;
 	void *ptr;
 
 	/* The READ_ONCE in __ptr_ring_peek guarantees that anyone
@@ -319,8 +329,10 @@ static inline void *__ptr_ring_consume(struct ptr_ring *r)
 	 * with smp_wmb in __ptr_ring_produce.
 	 */
 	ptr = __ptr_ring_peek(r);
-	if (ptr)
-		__ptr_ring_discard_one(r);
+	if (ptr) {
+		invalidate = __ptr_ring_will_invalidate(r);
+		__ptr_ring_discard_one(r, invalidate);
+	}
 
 	return ptr;
 }
-- 
2.43.0


