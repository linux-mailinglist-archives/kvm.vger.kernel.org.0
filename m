Return-Path: <kvm+bounces-2867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DE0B57FEB74
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 10:09:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6C18FB2114D
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 09:08:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06C023B1BA;
	Thu, 30 Nov 2023 09:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OWAa6eKi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96F310D0
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 01:08:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701335280;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bvgu88wHNRNmzXXlloHzld1OKbfvO68yNFuJTGWQaN8=;
	b=OWAa6eKiQqub/tGbwyR2F1GFHPW/2IdrjEyuMUMDeVnmGu88Waj214nMLS+pZETXOBUldj
	haG17Uau00RATVl9vKGcjnNYhk1Oa/HS2Z5kPQPL2z3F4XQ7ZXepkQYyccUBgrRXpJfPEj
	OH3sFZ274NhHMXAmTP1wbbz+ds2EOi4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-607-_e_OvAAUO0qcHfnUhkCOaw-1; Thu,
 30 Nov 2023 04:07:56 -0500
X-MC-Unique: _e_OvAAUO0qcHfnUhkCOaw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 559943C1ACD7;
	Thu, 30 Nov 2023 09:07:56 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4E7131C060AE;
	Thu, 30 Nov 2023 09:07:56 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 05/18] lib/alloc_phys: Remove locking
Date: Thu, 30 Nov 2023 04:07:07 -0500
Message-Id: <20231130090722.2897974-6-shahuang@redhat.com>
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

powerpc and s390 do not use the physical allocator.

arm and arm64 initialize the physical allocator in the setup code, only to
drain it immediately afterwards to initialize the page allocator.

x86 calls setup_vm() before any test that allocates memory, which similarly
drains the physical allocator to initialize the page allocator.

The setup code runs on a single core, which means that there is no need to
protect the internal data structures of the physical allocator against
concurrent accesses. Simplify the allocator by removing the locking.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/alloc_phys.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/lib/alloc_phys.c b/lib/alloc_phys.c
index 65c860cb..064077f7 100644
--- a/lib/alloc_phys.c
+++ b/lib/alloc_phys.c
@@ -21,7 +21,6 @@ struct phys_alloc_region {
 static struct phys_alloc_region regions[PHYS_ALLOC_NR_REGIONS];
 static int nr_regions;
 
-static struct spinlock lock;
 static phys_addr_t base, top;
 
 #define DEFAULT_MINIMUM_ALIGNMENT	32
@@ -37,7 +36,6 @@ void phys_alloc_show(void)
 {
 	int i;
 
-	spin_lock(&lock);
 	printf("phys_alloc minimum alignment: %#" PRIx64 "\n", (u64)align_min);
 	for (i = 0; i < nr_regions; ++i)
 		printf("%016" PRIx64 "-%016" PRIx64 " [%s]\n",
@@ -46,24 +44,19 @@ void phys_alloc_show(void)
 			"USED");
 	printf("%016" PRIx64 "-%016" PRIx64 " [%s]\n",
 		(u64)base, (u64)(top - 1), "FREE");
-	spin_unlock(&lock);
 }
 
 void phys_alloc_init(phys_addr_t base_addr, phys_addr_t size)
 {
-	spin_lock(&lock);
 	base = base_addr;
 	top = base + size;
 	nr_regions = 0;
-	spin_unlock(&lock);
 }
 
 void phys_alloc_set_minimum_alignment(phys_addr_t align)
 {
 	assert(align && !(align & (align - 1)));
-	spin_lock(&lock);
 	align_min = align;
-	spin_unlock(&lock);
 }
 
 static void *memalign_early(size_t alignment, size_t sz)
@@ -76,8 +69,6 @@ static void *memalign_early(size_t alignment, size_t sz)
 
 	assert(align && !(align & (align - 1)));
 
-	spin_lock(&lock);
-
 	top_safe = top;
 
 	if (sizeof(long) == 4)
@@ -97,7 +88,6 @@ static void *memalign_early(size_t alignment, size_t sz)
 		       "top=%#" PRIx64 ", top_safe=%#" PRIx64 "\n",
 		       (u64)size_orig, (u64)align, (u64)size,
 		       (u64)(top_safe - base), (u64)top, (u64)top_safe);
-		spin_unlock(&lock);
 		return NULL;
 	}
 
@@ -113,8 +103,6 @@ static void *memalign_early(size_t alignment, size_t sz)
 		warned = true;
 	}
 
-	spin_unlock(&lock);
-
 	return phys_to_virt(addr);
 }
 
@@ -124,10 +112,8 @@ void phys_alloc_get_unused(phys_addr_t *p_base, phys_addr_t *p_top)
 	*p_top = top;
 	if (base == top)
 		return;
-	spin_lock(&lock);
 	regions[nr_regions].base = base;
 	regions[nr_regions].size = top - base;
 	++nr_regions;
 	base = top;
-	spin_unlock(&lock);
 }
-- 
2.40.1


