Return-Path: <kvm+bounces-2875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A60497FEB7D
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 10:09:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C71A21C20E11
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 09:09:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68BF83C098;
	Thu, 30 Nov 2023 09:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fq9++lDk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D6F10F4
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 01:08:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701335282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XLttGJAnZv7uckwl333wdIlA+r+uqXCnxXO6kz34snI=;
	b=Fq9++lDkKoA3DRfiOvvoZqF2wE4pBuND6M2YtnGuAxKF74XdApVFObqdz+/PwOCBXp/8Lt
	CrJEUaIqyx2KYb4/j+p9YOddOUxm8thsZpumk47W165N4b2/x8aVISdYh946pkKwx5ccO0
	YOwZ02H6gjXOmkBQDb2ClBcAFstkNL8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-288--jRB9JGgMpuv9x4ZCvvPWg-1; Thu,
 30 Nov 2023 04:07:58 -0500
X-MC-Unique: -jRB9JGgMpuv9x4ZCvvPWg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 302861C382B2;
	Thu, 30 Nov 2023 09:07:58 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 238B21C060AE;
	Thu, 30 Nov 2023 09:07:58 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 16/18] arm/arm64: Map the UART when creating the translation tables
Date: Thu, 30 Nov 2023 04:07:18 -0500
Message-Id: <20231130090722.2897974-17-shahuang@redhat.com>
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

The MMU is now enabled before the UART is probed, which leaves
kvm-unit-tests with a window where attempting to write to the console
results in an infinite data abort loop triggered by the exception
handlers themselves trying to use the console. Get around this by
mapping the UART early address when creating the translation tables.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 lib/arm/io.c  | 31 +++++++++++++++++++++++++++++++
 lib/arm/io.h  |  3 +++
 lib/arm/mmu.c |  3 +++
 3 files changed, 37 insertions(+)

diff --git a/lib/arm/io.c b/lib/arm/io.c
index c15e57c4..becd52a5 100644
--- a/lib/arm/io.c
+++ b/lib/arm/io.c
@@ -15,6 +15,8 @@
 #include <asm/psci.h>
 #include <asm/spinlock.h>
 #include <asm/io.h>
+#include <asm/mmu.h>
+#include <asm/thread_info.h>
 
 #include "io.h"
 
@@ -29,6 +31,29 @@ static struct spinlock uart_lock;
 #define UART_EARLY_BASE (u8 *)(unsigned long)CONFIG_UART_EARLY_BASE
 static volatile u8 *uart0_base = UART_EARLY_BASE;
 
+static void uart_unmap_early_base(void)
+{
+	pteval_t *ptevalp;
+	pgd_t *pgtable;
+
+	if (mmu_enabled()) {
+		pgtable = current_thread_info()->pgtable;
+	} else {
+		pgtable = mmu_idmap;
+	}
+
+	/*
+	 * The UART has been mapped early in the boot process and the PTE has
+	 * been allocated using the physical allocator, which means it cannot be
+	 * freed.
+	 */
+	ptevalp = follow_pte(pgtable, (uintptr_t)UART_EARLY_BASE);
+	if (ptevalp) {
+		WRITE_ONCE(*ptevalp, 0);
+		flush_tlb_page((uintptr_t)UART_EARLY_BASE);
+	}
+}
+
 static void uart0_init_fdt(void)
 {
 	/*
@@ -98,11 +123,17 @@ void io_init(void)
 		printf("WARNING: early print support may not work. "
 		       "Found uart at %p, but early base is %p.\n",
 			uart0_base, UART_EARLY_BASE);
+		uart_unmap_early_base();
 	}
 
 	chr_testdev_init();
 }
 
+void __iomem *uart_early_base(void)
+{
+	return UART_EARLY_BASE;
+}
+
 void puts(const char *s)
 {
 	spin_lock(&uart_lock);
diff --git a/lib/arm/io.h b/lib/arm/io.h
index 183479c8..74b2850a 100644
--- a/lib/arm/io.h
+++ b/lib/arm/io.h
@@ -7,6 +7,9 @@
 #ifndef _ARM_IO_H_
 #define _ARM_IO_H_
 
+#include <asm/io.h>
+
 extern void io_init(void);
+extern void __iomem *uart_early_base(void);
 
 #endif
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index d23a12e8..0aec0bf9 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -15,6 +15,7 @@
 #include <asm/pgtable.h>
 #include <asm/pgtable-hwdef.h>
 
+#include "io.h"
 #include "vmalloc.h"
 
 #include <linux/compiler.h>
@@ -233,6 +234,8 @@ void mmu_setup_early(phys_addr_t phys_end)
 		}
 	}
 
+	ioremap((phys_addr_t)(unsigned long)uart_early_base(), PAGE_SIZE);
+
 	/*
 	 * Open-code part of mmu_enabled(), because at this point thread_info
 	 * hasn't been initialized. mmu_mark_enabled() cannot be called here
-- 
2.40.1


