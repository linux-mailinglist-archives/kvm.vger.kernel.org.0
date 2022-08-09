Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B63258D623
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 11:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235399AbiHIJPi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 05:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235565AbiHIJPe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 05:15:34 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0EC0F1BE9C;
        Tue,  9 Aug 2022 02:15:33 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8CBE0ED1;
        Tue,  9 Aug 2022 02:15:33 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 683073F67D;
        Tue,  9 Aug 2022 02:15:31 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        nikos.nikoleris@arm.com
Cc:     Laurent Vivier <lvivier@redhat.com>, kvm-ppc@vger.kernel.org
Subject: [kvm-unit-tests RFC PATCH 04/19] powerpc: Use the page allocator
Date:   Tue,  9 Aug 2022 10:15:43 +0100
Message-Id: <20220809091558.14379-5-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809091558.14379-1-alexandru.elisei@arm.com>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The spapr_hcall test makes two page sized allocations using the physical
allocator. Initialize the page allocator and use alloc_page() directly.

CC: Laurent Vivier <lvivier@redhat.com>
CC: Thomas Huth <thuth@redhat.com>
CC: kvm-ppc@vger.kernel.org
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/powerpc/setup.c     | 8 ++++++++
 powerpc/Makefile.common | 1 +
 powerpc/spapr_hcall.c   | 5 +++--
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/lib/powerpc/setup.c b/lib/powerpc/setup.c
index 1be4c030012b..bb39711af31c 100644
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
@@ -149,6 +151,12 @@ static void mem_init(phys_addr_t freemem_start)
 	phys_alloc_init(freemem_start, primary.end - freemem_start);
 	phys_alloc_set_minimum_alignment(__icache_bytes > __dcache_bytes
 					 ? __icache_bytes : __dcache_bytes);
+
+	phys_alloc_get_unused(&base, &top);
+	base = PAGE_ALIGN(base);
+	top = top & PAGE_MASK;
+	page_alloc_init_area(0, base >> PAGE_SHIFT, top >> PAGE_SHIFT);
+	page_alloc_ops_enable();
 }
 
 void setup(const void *fdt)
diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index 12c280c15fff..260946844998 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -34,6 +34,7 @@ include $(SRCDIR)/scripts/asm-offsets.mak
 cflatobjs += lib/util.o
 cflatobjs += lib/getchar.o
 cflatobjs += lib/alloc_phys.o
+cflatobjs += lib/alloc_page.o
 cflatobjs += lib/alloc.o
 cflatobjs += lib/devicetree.o
 cflatobjs += lib/powerpc/io.o
diff --git a/powerpc/spapr_hcall.c b/powerpc/spapr_hcall.c
index 823a574a4724..1a2015474b1c 100644
--- a/powerpc/spapr_hcall.c
+++ b/powerpc/spapr_hcall.c
@@ -8,6 +8,7 @@
 #include <libcflat.h>
 #include <util.h>
 #include <alloc.h>
+#include <alloc_page.h>
 #include <asm/hcall.h>
 
 #define PAGE_SIZE 4096
@@ -65,8 +66,8 @@ static void test_h_page_init(int argc, char **argv)
 	if (argc > 1)
 		report_abort("Unsupported argument: '%s'", argv[1]);
 
-	dst = memalign(PAGE_SIZE, PAGE_SIZE);
-	src = memalign(PAGE_SIZE, PAGE_SIZE);
+	dst = alloc_page();
+	src = alloc_page();
 	if (!dst || !src)
 		report_abort("Failed to alloc memory");
 
-- 
2.37.1

