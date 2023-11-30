Return-Path: <kvm+bounces-2861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 85BF17FEB6C
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 10:08:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C3267B20E4A
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 09:08:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7810E38F9C;
	Thu, 30 Nov 2023 09:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DOOr0b+i"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA214B9
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 01:07:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701335278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3NVP4k3DW8b+TT7nW3nBKoNYoxz8meflEmGy5APB9fM=;
	b=DOOr0b+iHZUjwx6Tr4RLj7v3P6lUtCUe7hmBNVgu0s8EL8E2rRebfAgqv+5dF+mxlYFNr7
	GkTzYKR0H91nXpuusqtx5uvSkn5SUzScg9tDFYL1mVsBON+Lc7pFMJLzCkdPOjvJeShHv0
	4/BCjUaT63JZLoXJ2o/sRfJSQ6Cp8+8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-60-oc5npyueMwqcjqg5hfodpA-1; Thu, 30 Nov 2023 04:07:57 -0500
X-MC-Unique: oc5npyueMwqcjqg5hfodpA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9EE6B101A52D;
	Thu, 30 Nov 2023 09:07:56 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 986011C060AE;
	Thu, 30 Nov 2023 09:07:56 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 07/18] lib/alloc_phys: Add callback to perform cache maintenance
Date: Thu, 30 Nov 2023 04:07:09 -0500
Message-Id: <20231130090722.2897974-8-shahuang@redhat.com>
In-Reply-To: <20231130090722.2897974-1-shahuang@redhat.com>
References: <20231130090722.2897974-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

From: Alexandru Elisei <alexandru.elisei@arm.com>

Some architectures, like arm and arm64, require explicit cache maintenance
to maintain the caches in sync with memory when toggling the caches. Add
the function to do the required maintenance on the internal structures that
the allocator maintains.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/alloc_phys.c | 8 ++++++++
 lib/alloc_phys.h | 8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/lib/alloc_phys.c b/lib/alloc_phys.c
index c96bcb48..5d5487f2 100644
--- a/lib/alloc_phys.c
+++ b/lib/alloc_phys.c
@@ -45,6 +45,14 @@ void phys_alloc_set_minimum_alignment(phys_addr_t align)
 	align_min = align;
 }
 
+void phys_alloc_perform_cache_maintenance(cache_maint_fn maint_fn)
+{
+	maint_fn((unsigned long)&base);
+	maint_fn((unsigned long)&used);
+	maint_fn((unsigned long)&top);
+	maint_fn((unsigned long)&align_min);
+}
+
 static void *memalign_early(size_t alignment, size_t sz)
 {
 	phys_addr_t align = (phys_addr_t)alignment;
diff --git a/lib/alloc_phys.h b/lib/alloc_phys.h
index 4d350f01..86b3d021 100644
--- a/lib/alloc_phys.h
+++ b/lib/alloc_phys.h
@@ -15,6 +15,8 @@
  */
 #include "libcflat.h"
 
+typedef void (*cache_maint_fn)(unsigned long addr);
+
 /*
  * phys_alloc_init creates the initial free memory region of size @size
  * at @base. The minimum alignment is set to DEFAULT_MINIMUM_ALIGNMENT.
@@ -27,6 +29,12 @@ extern void phys_alloc_init(phys_addr_t base, phys_addr_t size);
  */
 extern void phys_alloc_set_minimum_alignment(phys_addr_t align);
 
+/*
+ * Perform cache maintenance on the internal structures that the physical
+ * allocator maintains.
+ */
+extern void phys_alloc_perform_cache_maintenance(cache_maint_fn maint_fn);
+
 /*
  * phys_alloc_show outputs all currently allocated regions with the
  * following format, where <end_addr> is non-inclusive:
-- 
2.40.1


