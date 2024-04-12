Return-Path: <kvm+bounces-14532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 95D398A306D
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 16:22:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4AEC61F21A4A
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 14:22:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF01612A158;
	Fri, 12 Apr 2024 14:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ri4z0q5c"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BA786120
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 14:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712931721; cv=none; b=MSr68FS2Mv0oaluyR+14x0kFUgvbT5NE2oaoqwI1T61HC+U2FnfFGC5PYo8p/gMn2fO0Ms9ITq1Okba8qV0xtQCxZVSkC3etHZdjY1WY7wq2l5AsqSf763Z0nNJZBYBbfKfaUzkG4RZQkMCYRe0gp0J5dGJ21yDkz5LyzSrMnSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712931721; c=relaxed/simple;
	bh=gys6Zge317eX8qBO/ELZYmqSCqhQRVq9GVGChtZKn9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPJn9FOZG2iM638Iyg90au1ks0Ual6x6NvZcYBLSYkWUoM9AYI5niDN6spnphAY6vw7SVEH5MpIqJEoVY4nVm3kkRKOnbbvxCA+LqkfMrc3KxIDq5hT72XFKC6prbQA7jOkjSZ0cAKvTlyjChXUwrPT8vqiyLB0P+pg9rlfMElM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ri4z0q5c; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712931718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fF1JT3Ro4zg1bI3TxDVBJ5avgRwDbgOZB+fig1j1Nw8=;
	b=Ri4z0q5ctzaFoC5A1xvl9SWICb6j2f9z05ZpRr9Ap4NR1GNQrxf7rCSGkSSJieCMSOIcPh
	upvHlR2PCgjKi95nlw0O5KvoXLuaeRaFGBhohmesriwM+/ezLY3yucBklnTftjmWKnCDR9
	2+W0xzlICJ/EquWXrO44tx1uYw72fms=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-152-c5-IRZKjOwKMWQetYrG22Q-1; Fri, 12 Apr 2024 10:21:52 -0400
X-MC-Unique: c5-IRZKjOwKMWQetYrG22Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41D7D881E63;
	Fri, 12 Apr 2024 14:21:52 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.39.193.165])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D44E440C6DAE;
	Fri, 12 Apr 2024 14:21:48 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org,
	linux-s390@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Matthew Wilcox <willy@infradead.org>,
	Thomas Huth <thuth@redhat.com>
Subject: [PATCH v2 02/10] s390/uv: gmap_make_secure() cleanups for further changes
Date: Fri, 12 Apr 2024 16:21:12 +0200
Message-ID: <20240412142120.220087-3-david@redhat.com>
In-Reply-To: <20240412142120.220087-1-david@redhat.com>
References: <20240412142120.220087-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

Let's factor out handling of LRU cache draining and convert the if-else
chain to a switch-case.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/kernel/uv.c | 66 ++++++++++++++++++++++++++-----------------
 1 file changed, 40 insertions(+), 26 deletions(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 016993e9eb72..25fe28d189df 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -266,6 +266,36 @@ static bool should_export_before_import(struct uv_cb_header *uvcb, struct mm_str
 	return atomic_read(&mm->context.protected_count) > 1;
 }
 
+/*
+ * Drain LRU caches: the local one on first invocation and the ones of all
+ * CPUs on successive invocations. Returns "true" on the first invocation.
+ */
+static bool drain_lru(bool *drain_lru_called)
+{
+	/*
+	 * If we have tried a local drain and the folio refcount
+	 * still does not match our expected safe value, try with a
+	 * system wide drain. This is needed if the pagevecs holding
+	 * the page are on a different CPU.
+	 */
+	if (*drain_lru_called) {
+		lru_add_drain_all();
+		/* We give up here, don't retry immediately. */
+		return false;
+	}
+	/*
+	 * We are here if the folio refcount does not match the
+	 * expected safe value. The main culprits are usually
+	 * pagevecs. With lru_add_drain() we drain the pagevecs
+	 * on the local CPU so that hopefully the refcount will
+	 * reach the expected safe value.
+	 */
+	lru_add_drain();
+	*drain_lru_called = true;
+	/* The caller should try again immediately */
+	return true;
+}
+
 /*
  * Requests the Ultravisor to make a page accessible to a guest.
  * If it's brought in the first time, it will be cleared. If
@@ -275,7 +305,7 @@ static bool should_export_before_import(struct uv_cb_header *uvcb, struct mm_str
 int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
 {
 	struct vm_area_struct *vma;
-	bool local_drain = false;
+	bool drain_lru_called = false;
 	spinlock_t *ptelock;
 	unsigned long uaddr;
 	struct folio *folio;
@@ -331,37 +361,21 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
 out:
 	mmap_read_unlock(gmap->mm);
 
-	if (rc == -EAGAIN) {
+	switch (rc) {
+	case -EAGAIN:
 		/*
 		 * If we are here because the UVC returned busy or partial
 		 * completion, this is just a useless check, but it is safe.
 		 */
 		folio_wait_writeback(folio);
 		folio_put(folio);
-	} else if (rc == -EBUSY) {
-		/*
-		 * If we have tried a local drain and the folio refcount
-		 * still does not match our expected safe value, try with a
-		 * system wide drain. This is needed if the pagevecs holding
-		 * the page are on a different CPU.
-		 */
-		if (local_drain) {
-			lru_add_drain_all();
-			/* We give up here, and let the caller try again */
-			return -EAGAIN;
-		}
-		/*
-		 * We are here if the folio refcount does not match the
-		 * expected safe value. The main culprits are usually
-		 * pagevecs. With lru_add_drain() we drain the pagevecs
-		 * on the local CPU so that hopefully the refcount will
-		 * reach the expected safe value.
-		 */
-		lru_add_drain();
-		local_drain = true;
-		/* And now we try again immediately after draining */
-		goto again;
-	} else if (rc == -ENXIO) {
+		return -EAGAIN;
+	case -EBUSY:
+		/* Additional folio references. */
+		if (drain_lru(&drain_lru_called))
+			goto again;
+		return -EAGAIN;
+	case -ENXIO:
 		if (gmap_fault(gmap, gaddr, FAULT_FLAG_WRITE))
 			return -EFAULT;
 		return -EAGAIN;
-- 
2.44.0


