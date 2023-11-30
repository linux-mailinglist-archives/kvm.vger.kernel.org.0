Return-Path: <kvm+bounces-2866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 653497FEB73
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 10:08:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 00C0DB20E70
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 09:08:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6333374D1;
	Thu, 30 Nov 2023 09:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PKns8Blj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B382A10C2
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 01:08:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701335279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VCYXs7UB826Rm6Vi+S+LrP8zq1r68p6FkKq2ErN2au4=;
	b=PKns8BljKYazfosyfrMvhyCiIwnkqQ4A4wqH0m43gwrWTe87BW0CQCmzq1/uaAuMsKVuIG
	v3XlLPzJYsIiJ1jDjIoi0SG/R71rqR6KTNLgc65vYBng+Q4BqBhEzwCumYijBa2t4MWCM/
	ilp1xwnNrnoNuZTtWCED5MpoTY2cte8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-101-1X-oQLimP5qYoreV94DJ6g-1; Thu,
 30 Nov 2023 04:07:56 -0500
X-MC-Unique: 1X-oQLimP5qYoreV94DJ6g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E4DC51C382AF;
	Thu, 30 Nov 2023 09:07:55 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DB5DB1C060AE;
	Thu, 30 Nov 2023 09:07:55 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	kvm-ppc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 02/18] powerpc: Replace the physical allocator with the page allocator
Date: Thu, 30 Nov 2023 04:07:04 -0500
Message-Id: <20231130090722.2897974-3-shahuang@redhat.com>
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

The spapr_hcall test makes two page sized allocations using the physical
allocator. Replace the physical allocator with the page allocator, which
has has more features (like support for freeing allocations), and would
allow for further simplification of the physical allocator.

CC: Laurent Vivier <lvivier@redhat.com>
CC: Thomas Huth <thuth@redhat.com>
CC: kvm-ppc@vger.kernel.org
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/powerpc/setup.c     | 9 ++++++---
 powerpc/Makefile.common | 1 +
 powerpc/spapr_hcall.c   | 5 +++--
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/lib/powerpc/setup.c b/lib/powerpc/setup.c
index 1be4c030..80fd38ae 100644
--- a/lib/powerpc/setup.c
+++ b/lib/powerpc/setup.c
@@ -15,6 +15,7 @@
 #include <devicetree.h>
 #include <alloc.h>
 #include <alloc_phys.h>
+#include <alloc_page.h>
 #include <argv.h>
 #include <asm/setup.h>
 #include <asm/page.h>
@@ -111,6 +112,7 @@ static void mem_init(phys_addr_t freemem_start)
 	struct mem_region primary, mem = {
 		.start = (phys_addr_t)-1,
 	};
+	phys_addr_t base, top;
 	int nr_regs, i;
 
 	nr_regs = dt_get_memory_params(regs, NR_MEM_REGIONS);
@@ -146,9 +148,10 @@ static void mem_init(phys_addr_t freemem_start)
 	__physical_start = mem.start;	/* PHYSICAL_START */
 	__physical_end = mem.end;	/* PHYSICAL_END */
 
-	phys_alloc_init(freemem_start, primary.end - freemem_start);
-	phys_alloc_set_minimum_alignment(__icache_bytes > __dcache_bytes
-					 ? __icache_bytes : __dcache_bytes);
+	base = PAGE_ALIGN(freemem_start) >> PAGE_SHIFT;
+	top = primary.end >> PAGE_SHIFT;
+	page_alloc_init_area(0, base, top);
+	page_alloc_ops_enable();
 }
 
 void setup(const void *fdt)
diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index f8f47490..ae70443a 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -34,6 +34,7 @@ include $(SRCDIR)/scripts/asm-offsets.mak
 cflatobjs += lib/util.o
 cflatobjs += lib/getchar.o
 cflatobjs += lib/alloc_phys.o
+cflatobjs += lib/alloc_page.o
 cflatobjs += lib/alloc.o
 cflatobjs += lib/devicetree.o
 cflatobjs += lib/migrate.o
diff --git a/powerpc/spapr_hcall.c b/powerpc/spapr_hcall.c
index e9b5300a..77ab4187 100644
--- a/powerpc/spapr_hcall.c
+++ b/powerpc/spapr_hcall.c
@@ -8,6 +8,7 @@
 #include <libcflat.h>
 #include <util.h>
 #include <alloc.h>
+#include <alloc_page.h>
 #include <asm/hcall.h>
 #include <asm/processor.h>
 
@@ -58,8 +59,8 @@ static void test_h_page_init(int argc, char **argv)
 	if (argc > 1)
 		report_abort("Unsupported argument: '%s'", argv[1]);
 
-	dst = memalign(PAGE_SIZE, PAGE_SIZE);
-	src = memalign(PAGE_SIZE, PAGE_SIZE);
+	dst = alloc_page();
+	src = alloc_page();
 	if (!dst || !src)
 		report_abort("Failed to alloc memory");
 
-- 
2.40.1


