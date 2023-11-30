Return-Path: <kvm+bounces-2877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B2907FEB7E
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 10:09:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8ADA91C20EA8
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 09:09:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14E3B3C691;
	Thu, 30 Nov 2023 09:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wq9GzixL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB4D010F2
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 01:08:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701335282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QmLj4WrHra8uSCB8KBDHTivbNsWG14RE7daMxr/+zf0=;
	b=Wq9GzixLAnZO5SOEaDROxJxt+dzARsGskZOpC3cDcmilF2MoRbM7ynVnDXMIdvnXdRsETs
	wlEc4Fc+ERWbRc6ib2U6rE9Hcg73FUzSGht9MwB3p5kCWabXXQWwMyafh4IUFPswRyVacw
	+Wm9P7jkofOc5zWQ+cBaPE2pxwMeD08=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-252-TgODM4--P3mZ2i7TtC5QMA-1; Thu, 30 Nov 2023 04:07:56 -0500
X-MC-Unique: TgODM4--P3mZ2i7TtC5QMA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3631984ACA1;
	Thu, 30 Nov 2023 09:07:56 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2ED111C060AE;
	Thu, 30 Nov 2023 09:07:56 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 04/18] lib/alloc_phys: Consolidate allocate functions into memalign_early()
Date: Thu, 30 Nov 2023 04:07:06 -0500
Message-Id: <20231130090722.2897974-5-shahuang@redhat.com>
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

phys_alloc_aligned_safe() is called only by early_memalign() and the safe
parameter is always true. In the spirit of simplifying the code, merge the
two functions together. Rename it to memalign_early(), to match the naming
scheme used by the page allocator.

Change the type of top_safe to phys_addr_t, to match the type of the top
and base variables describing the available physical memory; this is a
cosmetic change only, since libcflat.h defines phys_addr_t as an alias
for u64.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/alloc_phys.c | 40 +++++++++++++++-------------------------
 1 file changed, 15 insertions(+), 25 deletions(-)

diff --git a/lib/alloc_phys.c b/lib/alloc_phys.c
index 3a78d0ac..65c860cb 100644
--- a/lib/alloc_phys.c
+++ b/lib/alloc_phys.c
@@ -27,9 +27,9 @@ static phys_addr_t base, top;
 #define DEFAULT_MINIMUM_ALIGNMENT	32
 static size_t align_min = DEFAULT_MINIMUM_ALIGNMENT;
 
-static void *early_memalign(size_t alignment, size_t size);
+static void *memalign_early(size_t alignment, size_t sz);
 static struct alloc_ops early_alloc_ops = {
-	.memalign = early_memalign,
+	.memalign = memalign_early,
 };
 struct alloc_ops *alloc_ops = &early_alloc_ops;
 
@@ -66,21 +66,24 @@ void phys_alloc_set_minimum_alignment(phys_addr_t align)
 	spin_unlock(&lock);
 }
 
-static phys_addr_t phys_alloc_aligned_safe(phys_addr_t size,
-					   phys_addr_t align, bool safe)
+static void *memalign_early(size_t alignment, size_t sz)
 {
 	static bool warned = false;
-	phys_addr_t addr, size_orig = size;
-	u64 top_safe;
+	phys_addr_t align = (phys_addr_t)alignment;
+	phys_addr_t size = (phys_addr_t)sz;
+	phys_addr_t size_orig = size;
+	phys_addr_t addr, top_safe;
+
+	assert(align && !(align & (align - 1)));
 
 	spin_lock(&lock);
 
 	top_safe = top;
 
-	if (safe && sizeof(long) == 4)
+	if (sizeof(long) == 4)
 		top_safe = MIN(top_safe, 1ULL << 32);
-
 	assert(base < top_safe);
+
 	if (align < align_min)
 		align = align_min;
 
@@ -92,10 +95,10 @@ static phys_addr_t phys_alloc_aligned_safe(phys_addr_t size,
 		       " (align=%#" PRIx64 "), "
 		       "need=%#" PRIx64 ", but free=%#" PRIx64 ". "
 		       "top=%#" PRIx64 ", top_safe=%#" PRIx64 "\n",
-		       (u64)size_orig, (u64)align, (u64)size, top_safe - base,
-		       (u64)top, top_safe);
+		       (u64)size_orig, (u64)align, (u64)size,
+		       (u64)(top_safe - base), (u64)top, (u64)top_safe);
 		spin_unlock(&lock);
-		return INVALID_PHYS_ADDR;
+		return NULL;
 	}
 
 	base += size;
@@ -112,7 +115,7 @@ static phys_addr_t phys_alloc_aligned_safe(phys_addr_t size,
 
 	spin_unlock(&lock);
 
-	return addr;
+	return phys_to_virt(addr);
 }
 
 void phys_alloc_get_unused(phys_addr_t *p_base, phys_addr_t *p_top)
@@ -128,16 +131,3 @@ void phys_alloc_get_unused(phys_addr_t *p_base, phys_addr_t *p_top)
 	base = top;
 	spin_unlock(&lock);
 }
-
-static void *early_memalign(size_t alignment, size_t size)
-{
-	phys_addr_t addr;
-
-	assert(alignment && !(alignment & (alignment - 1)));
-
-	addr = phys_alloc_aligned_safe(size, alignment, true);
-	if (addr == INVALID_PHYS_ADDR)
-		return NULL;
-
-	return phys_to_virt(addr);
-}
-- 
2.40.1


