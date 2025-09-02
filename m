Return-Path: <kvm+bounces-56536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E85DB3F7E4
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 10:14:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7BCBB7B1675
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 08:11:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97B2A2E973C;
	Tue,  2 Sep 2025 08:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="gwWE3P+e"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53B52E6CBF;
	Tue,  2 Sep 2025 08:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756800621; cv=none; b=CkW7v3E9+MawOEdxSOSMtXU+QxUuGBvwooO1/D1AhEU1B0zqJO50Rn5KXPL1d1N3dGUL8Wgx4wEUEa83xbweMTAlXzjOGa/9AbFRfnli51lUCirH/+WM3aWumkWWc6vAM3P8kqzwxGMeNKZbaiejadM1V/pYY3VUL1W+NvD5VCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756800621; c=relaxed/simple;
	bh=DpASARpUZpf8wbH1Mg9rkEgTvOPc+bR0wuCWjvVMFAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KM9c31+/7DACqCtJCkhu7Lddgrq4oDfFFLS0D+JqGGWYBOrUQ7mxcv87CY3u6UUl2yh/DHDdPtkYqESBqq2gbchYDZfLFEsq+eYKizpaS77WT7iuWyIPncqDVmk/vjx8hc2qHMRwEFKByy9OuJTuPpu0V7Kr667UphyfF6OcAsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=gwWE3P+e; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from simon-Latitude-5450.tu-dortmund.de (rechenknecht2.kn.e-technik.tu-dortmund.de [129.217.186.41])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.9/8.18.1.10) with ESMTPSA id 58289x6T004012
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 2 Sep 2025 10:10:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1756800608;
	bh=DpASARpUZpf8wbH1Mg9rkEgTvOPc+bR0wuCWjvVMFAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gwWE3P+emkeYbl05g9UyV195MNP1AFg1B9w+jDvUt+fmmlS+GmQnfDr+knUVitQrC
	 gePlbGJ0RhITE/gauFH3b81e/rpEgjno9l41wYFuVtrCdFcbR4/5FMHo0iuqdNMcmf
	 S66HMVWQQ3Pd+qmRPOc90bndw7XyaCMx+Tm5E7no=
From: Simon Schippers <simon.schippers@tu-dortmund.de>
To: willemdebruijn.kernel@gmail.com, jasowang@redhat.com, mst@redhat.com,
        eperezma@redhat.com, stephen@networkplumber.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux.dev, kvm@vger.kernel.org
Cc: Simon Schippers <simon.schippers@tu-dortmund.de>,
        Tim Gebauer <tim.gebauer@tu-dortmund.de>
Subject: [PATCH 1/4] ptr_ring_spare: Helper to check if spare capacity of size cnt is available
Date: Tue,  2 Sep 2025 10:09:54 +0200
Message-ID: <20250902080957.47265-2-simon.schippers@tu-dortmund.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250902080957.47265-1-simon.schippers@tu-dortmund.de>
References: <20250902080957.47265-1-simon.schippers@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The implementation is inspired by ptr_ring_empty.

Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
---
 include/linux/ptr_ring.h | 71 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
index 551329220e4f..6b8cfaecf478 100644
--- a/include/linux/ptr_ring.h
+++ b/include/linux/ptr_ring.h
@@ -243,6 +243,77 @@ static inline bool ptr_ring_empty_bh(struct ptr_ring *r)
 	return ret;
 }
 
+/*
+ * Check if a spare capacity of cnt is available without taking any locks.
+ *
+ * If cnt==0 or cnt > r->size it acts the same as __ptr_ring_empty.
+ *
+ * The same requirements apply as described for __ptr_ring_empty.
+ */
+static inline bool __ptr_ring_spare(struct ptr_ring *r, int cnt)
+{
+	int size = r->size;
+	int to_check;
+
+	if (unlikely(!size || cnt < 0))
+		return true;
+
+	if (cnt > size)
+		cnt = 0;
+
+	to_check = READ_ONCE(r->consumer_head) - cnt;
+
+	if (to_check < 0)
+		to_check += size;
+
+	return !r->queue[to_check];
+}
+
+static inline bool ptr_ring_spare(struct ptr_ring *r, int cnt)
+{
+	bool ret;
+
+	spin_lock(&r->consumer_lock);
+	ret = __ptr_ring_spare(r, cnt);
+	spin_unlock(&r->consumer_lock);
+
+	return ret;
+}
+
+static inline bool ptr_ring_spare_irq(struct ptr_ring *r, int cnt)
+{
+	bool ret;
+
+	spin_lock_irq(&r->consumer_lock);
+	ret = __ptr_ring_spare(r, cnt);
+	spin_unlock_irq(&r->consumer_lock);
+
+	return ret;
+}
+
+static inline bool ptr_ring_spare_any(struct ptr_ring *r, int cnt)
+{
+	unsigned long flags;
+	bool ret;
+
+	spin_lock_irqsave(&r->consumer_lock, flags);
+	ret = __ptr_ring_spare(r, cnt);
+	spin_unlock_irqrestore(&r->consumer_lock, flags);
+
+	return ret;
+}
+
+static inline bool ptr_ring_spare_bh(struct ptr_ring *r, int cnt)
+{
+	bool ret;
+
+	spin_lock_bh(&r->consumer_lock);
+	ret = __ptr_ring_spare(r, cnt);
+	spin_unlock_bh(&r->consumer_lock);
+
+	return ret;
+}
+
 /* Must only be called after __ptr_ring_peek returned !NULL */
 static inline void __ptr_ring_discard_one(struct ptr_ring *r)
 {
-- 
2.43.0


