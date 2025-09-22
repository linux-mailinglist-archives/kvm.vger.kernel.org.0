Return-Path: <kvm+bounces-58416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 719F1B93731
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 00:17:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C73E3A9A24
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 22:17:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9D2D314B66;
	Mon, 22 Sep 2025 22:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="fEAeba1t"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744B62C187;
	Mon, 22 Sep 2025 22:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758579430; cv=none; b=tliK7nPTInjmVDUKcBfiq1rdHrOGVqGbf2lP83M3u91oYiBCs+XiUTmM9KUksQ9zYrSvcRSWz8rU7wYd/W0Va3cswk1PTddcB0ab9sWiY5u9SuAzYzLq/DXI8fSFVJE9LZQ8+bHh4PaTq2VtYjhfiEwGCiU+YoeYT64NN6NFdBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758579430; c=relaxed/simple;
	bh=b4kaadpAcdfkSSYI/s+61GIJ+vRzjMb2Vl3FcGUWroQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HN97pk0GECf5mUW6esFQh5ZvRhYS69CkpnQZu+mqwx4neOJdZp0ZYW9WBuS0zDW/TZhRQp8XbedJKu6fm1szuX1anYE7iWKweFzl9JLVpCJ9e0SlqCl7UQxSUVzhQZ9Er5f0JMWC+rEw3HUPzukp4rIUqeo/hj4hQJ11Vx1OYoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=fEAeba1t; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from simon-Latitude-5450.fritz.box (p5dc88066.dip0.t-ipconnect.de [93.200.128.102])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.10/8.18.1.10) with ESMTPSA id 58MMH4eZ003919
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 23 Sep 2025 00:17:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1758579425;
	bh=b4kaadpAcdfkSSYI/s+61GIJ+vRzjMb2Vl3FcGUWroQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fEAeba1tfJ56369/2xqYr4I37/XwVEmIsC864tDkXcruGMD141FvjKMPB5mxl3nAe
	 btqT3dYpMARuaWFhGbG5fSqeB4ZXIziIkqCITsO5TOHP+Bx7C6+PmQ2k+1JpOyp+5j
	 B5ZMIGiq5rFZHRT7xjhJ2pD2QS0e1zbnuXuylv4g=
From: Simon Schippers <simon.schippers@tu-dortmund.de>
To: willemdebruijn.kernel@gmail.com, jasowang@redhat.com, mst@redhat.com,
        eperezma@redhat.com, stephen@networkplumber.org, leiyang@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux.dev, kvm@vger.kernel.org
Cc: Simon Schippers <simon.schippers@tu-dortmund.de>,
        Tim Gebauer <tim.gebauer@tu-dortmund.de>
Subject: [PATCH net-next v5 1/8] __ptr_ring_full_next: Returns if ring will be full after next insertion
Date: Tue, 23 Sep 2025 00:15:46 +0200
Message-ID: <20250922221553.47802-2-simon.schippers@tu-dortmund.de>
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

Useful if the caller would like to act before the ptr_ring gets full after
the next __ptr_ring_produce call. Because __ptr_ring_produce has a
smp_wmb(), taking action before ensures memory ordering.

Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
---
 include/linux/ptr_ring.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
index 551329220e4f..c45e95071d7e 100644
--- a/include/linux/ptr_ring.h
+++ b/include/linux/ptr_ring.h
@@ -96,6 +96,28 @@ static inline bool ptr_ring_full_bh(struct ptr_ring *r)
 	return ret;
 }
 
+/* Returns if the ptr_ring will be full after inserting the next ptr.
+ */
+static inline bool __ptr_ring_full_next(struct ptr_ring *r)
+{
+	int p;
+
+	/* Since __ptr_ring_discard_one invalidates in reverse order, the
+	 * next producer entry might be NULL even though the current one
+	 * is not. Therefore, also check the current producer entry with
+	 * __ptr_ring_full.
+	 */
+	if (unlikely(r->size <= 1 || __ptr_ring_full(r)))
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


