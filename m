Return-Path: <kvm+bounces-2865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C92927FEB70
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 10:08:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EA91282464
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 09:08:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71BF93A280;
	Thu, 30 Nov 2023 09:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gYzq1k2X"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD207D6C
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 01:08:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701335280;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aR2UOTcIpvJ2dosuB8CbR0gpTR1MsMOjPFBhRNndxSc=;
	b=gYzq1k2XgwaEHPaZ4RcMqESspN60wtLkf729ilNfEIvxVczIFrw1RHmGHNQFaRuvTwrk6/
	UB/yszGlFE2JitHF095HLMSpkekLLaOwhgKPKSpc+1OsgIdJ/hHTWDnPk7Fj52fmIexgpg
	+e9zOx4GwsINFPPfoYWK+4X8u593vpU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-93-4jc3NBIsO-6_5e6MXde5_g-1; Thu, 30 Nov 2023 04:07:58 -0500
X-MC-Unique: 4jc3NBIsO-6_5e6MXde5_g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D111A811E97;
	Thu, 30 Nov 2023 09:07:57 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C2BEF1C060AE;
	Thu, 30 Nov 2023 09:07:57 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 14/18] arm/arm64: Use pgd_alloc() to allocate mmu_idmap
Date: Thu, 30 Nov 2023 04:07:16 -0500
Message-Id: <20231130090722.2897974-15-shahuang@redhat.com>
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

Until commit 031755dbfefb ("arm: enable vmalloc"), the idmap was allocated
using pgd_alloc(). After that commit, all the page table allocator
functions were switched to using the page allocator, but pgd_alloc() was
left unchanged and became unused, with the idmap now being allocated with
alloc_page().

For arm64, the pgd table size varies based on the page size, which is
configured by the user. For arm, it will always contain 4 entries (it
translates bits 31:30 of the input address). To keep things simple and
consistent with the other functions and across both architectures, modify
pgd_alloc() to use alloc_page() instead of memalign like the rest of the
page table allocator functions and use it to allocate the idmap.

Note that when the idmap is created, alloc_ops->memalign is
memalign_pages(), which allocates memory with page granularity. Which means
that the existing code also allocated a full page, so the total memory used
is not increased by using alloc_page().

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/asm/pgtable.h   | 4 ++--
 lib/arm/mmu.c           | 4 ++--
 lib/arm64/asm/pgtable.h | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/lib/arm/asm/pgtable.h b/lib/arm/asm/pgtable.h
index d7c73906..a35f4296 100644
--- a/lib/arm/asm/pgtable.h
+++ b/lib/arm/asm/pgtable.h
@@ -43,8 +43,8 @@
 #define pgd_free(pgd) free(pgd)
 static inline pgd_t *pgd_alloc(void)
 {
-	pgd_t *pgd = memalign(L1_CACHE_BYTES, PTRS_PER_PGD * sizeof(pgd_t));
-	memset(pgd, 0, PTRS_PER_PGD * sizeof(pgd_t));
+	assert(PTRS_PER_PGD * sizeof(pgd_t) <= PAGE_SIZE);
+	pgd_t *pgd = alloc_page();
 	return pgd;
 }
 
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 2f4ec815..70c5333c 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -217,7 +217,7 @@ void *setup_mmu(phys_addr_t phys_end, void *unused)
 #endif
 
 	if (!mmu_idmap)
-		mmu_idmap = alloc_page();
+		mmu_idmap = pgd_alloc();
 
 	for (r = mem_regions; r->end; ++r) {
 		if (r->flags & MR_F_IO) {
@@ -253,7 +253,7 @@ void __iomem *__ioremap(phys_addr_t phys_addr, size_t size)
 		pgtable = current_thread_info()->pgtable;
 	} else {
 		if (!mmu_idmap)
-			mmu_idmap = alloc_page();
+			mmu_idmap = pgd_alloc();
 		pgtable = mmu_idmap;
 	}
 
diff --git a/lib/arm64/asm/pgtable.h b/lib/arm64/asm/pgtable.h
index bfb8a993..06357920 100644
--- a/lib/arm64/asm/pgtable.h
+++ b/lib/arm64/asm/pgtable.h
@@ -49,8 +49,8 @@
 #define pgd_free(pgd) free(pgd)
 static inline pgd_t *pgd_alloc(void)
 {
-	pgd_t *pgd = memalign(PAGE_SIZE, PTRS_PER_PGD * sizeof(pgd_t));
-	memset(pgd, 0, PTRS_PER_PGD * sizeof(pgd_t));
+	assert(PTRS_PER_PGD * sizeof(pgd_t) <= PAGE_SIZE);
+	pgd_t *pgd = alloc_page();
 	return pgd;
 }
 
-- 
2.40.1


