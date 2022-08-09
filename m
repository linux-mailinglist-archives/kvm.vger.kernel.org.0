Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5627E58D632
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 11:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238712AbiHIJQL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 05:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238473AbiHIJPs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 05:15:48 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EF2CC1C920
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 02:15:42 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7684623A;
        Tue,  9 Aug 2022 02:15:43 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 95B303F67D;
        Tue,  9 Aug 2022 02:15:41 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        nikos.nikoleris@arm.com
Subject: [kvm-unit-tests RFC PATCH 11/19] arm/arm64: Map the UART when creating the translation tables
Date:   Tue,  9 Aug 2022 10:15:50 +0100
Message-Id: <20220809091558.14379-12-alexandru.elisei@arm.com>
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

The MMU is now enabled before the UART is probed, which leaves
kvm-unit-tests with a window where attempting to write to the console
results in an infinite data abort loop triggered by the exception
handlers themselves trying to use the console. Get around this by
mapping the UART early address when creating the translation tables.

Note that the address remains mapped even if the devicetree address is
different.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/io.c  | 5 +++++
 lib/arm/io.h  | 3 +++
 lib/arm/mmu.c | 8 ++++++++
 3 files changed, 16 insertions(+)

diff --git a/lib/arm/io.c b/lib/arm/io.c
index 343e10822263..c2c3edb563a0 100644
--- a/lib/arm/io.c
+++ b/lib/arm/io.c
@@ -73,6 +73,11 @@ static void uart0_init(void)
 	}
 }
 
+void __iomem *io_uart_early_base(void)
+{
+	return UART_EARLY_BASE;
+}
+
 void io_init(void)
 {
 	uart0_init();
diff --git a/lib/arm/io.h b/lib/arm/io.h
index 183479c899a9..24704d8fe0a4 100644
--- a/lib/arm/io.h
+++ b/lib/arm/io.h
@@ -7,6 +7,9 @@
 #ifndef _ARM_IO_H_
 #define _ARM_IO_H_
 
+#include <asm/io.h>
+
 extern void io_init(void);
+extern void __iomem *io_uart_early_base(void);
 
 #endif
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 7765d47dc27a..19c98a8a9640 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -15,6 +15,7 @@
 #include <asm/pgtable.h>
 #include <asm/pgtable-hwdef.h>
 
+#include "io.h"
 #include "vmalloc.h"
 
 #include <linux/compiler.h>
@@ -155,6 +156,8 @@ void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
 void mmu_setup_early(phys_addr_t unused0, void *unused1)
 {
 	struct mem_region *r;
+	pgprot_t uart_prot;
+	void *uart_base;
 
 	assert(!mmu_enabled() && !page_alloc_initialized());
 
@@ -178,6 +181,11 @@ void mmu_setup_early(phys_addr_t unused0, void *unused1)
 		}
 	}
 
+	uart_base = io_uart_early_base();
+	uart_prot = __pgprot(PTE_UNCACHED | PTE_USER | PTE_UXN | PTE_PXN);
+	install_page_prot(mmu_idmap, (phys_addr_t)(unsigned long)uart_base,
+			  (uintptr_t)uart_base, uart_prot);
+
 	asm_mmu_enable((phys_addr_t)(unsigned long)mmu_idmap);
 }
 
-- 
2.37.1

