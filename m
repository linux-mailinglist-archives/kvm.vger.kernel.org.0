Return-Path: <kvm+bounces-14494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E5E478A2C6B
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 12:35:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9BFFB1F234F6
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:35:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B6AD54BDB;
	Fri, 12 Apr 2024 10:34:38 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D94E54909
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 10:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918077; cv=none; b=q5u6PbBPphYpxcN3Rp3xnA0MakuQAlEr7rfOLS6QyhyDzHiPybsDv+D63V8liR9f07HmhBTeeRceqinMHlCW5mx5qElOVuOKcg7qKjyORdA/lhEbu+ToUdR5ufSPHcufExHofBvwLCZZ4JQ0otnen5bTyPCQ61CVegB9DE8ujfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918077; c=relaxed/simple;
	bh=QHnnLLALddLjwkDjwh1cAf6QizCjWxbFAQO5zDIHGFk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M2qbPsMqZGIDGGblzkWqzaE4ZUHRUJLMm4fPp9Emxx7FiTOGR4GmqP//A4x+gXKL0n8GIp+77dlAUr7WKRwLwMgFVz2QEjyZ68dvKwt3L2LcFzfeXDE4p6rBFRjG8tYjDW0eJVv4q6h7WGzvcTqHIEMjQsnstUdZPkBojrbS5oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7BCF8339;
	Fri, 12 Apr 2024 03:35:04 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 85ABE3F64C;
	Fri, 12 Apr 2024 03:34:33 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org,
	alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	steven.price@arm.com,
	james.morse@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvm-unit-tests PATCH 08/33] arm: realm: Make uart available before MMU is enabled
Date: Fri, 12 Apr 2024 11:33:43 +0100
Message-Id: <20240412103408.2706058-9-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240412103408.2706058-1-suzuki.poulose@arm.com>
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Joey Gouly <joey.gouly@arm.com>

A Realm must access any emulated I/O mappings with the PTE_NS_SHARED bit set.
This is modelled as a PTE attribute, but is actually part of the address.

So, when MMU is disabled, the "physical address" must reflect this bit set. We
access the UART early before the MMU is enabled. So, make sure the UART is
accessed always with the bit set.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 lib/arm/asm/pgtable.h   |  5 +++++
 lib/arm/io.c            | 24 +++++++++++++++++++++++-
 lib/arm64/asm/pgtable.h |  5 +++++
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/lib/arm/asm/pgtable.h b/lib/arm/asm/pgtable.h
index 350039ff..7e85e7c6 100644
--- a/lib/arm/asm/pgtable.h
+++ b/lib/arm/asm/pgtable.h
@@ -112,4 +112,9 @@ static inline pte_t *pte_alloc(pmd_t *pmd, unsigned long addr)
 	return pte_offset(pmd, addr);
 }
 
+static inline unsigned long arm_shared_phys_alias(void *x)
+{
+	return ((unsigned long)(x) | PTE_NS_SHARED);
+}
+
 #endif /* _ASMARM_PGTABLE_H_ */
diff --git a/lib/arm/io.c b/lib/arm/io.c
index 836fa854..127727e4 100644
--- a/lib/arm/io.c
+++ b/lib/arm/io.c
@@ -15,6 +15,8 @@
 #include <asm/psci.h>
 #include <asm/spinlock.h>
 #include <asm/io.h>
+#include <asm/mmu-api.h>
+#include <asm/pgtable.h>
 
 #include "io.h"
 
@@ -30,6 +32,24 @@ static struct spinlock uart_lock;
 static volatile u8 *uart0_base = UART_EARLY_BASE;
 bool is_pl011_uart;
 
+static inline volatile u8 *get_uart_base(void)
+{
+	/*
+	 * The address of the UART base may be different
+	 * based on whether we are running with/without
+	 * MMU enabled.
+	 *
+	 * For realms, we must force to use the shared physical
+	 * alias with MMU disabled, to make sure the I/O can
+	 * be emulated.
+	 * When the MMU is turned ON, the mappings are created
+	 * appropriately.
+	 */
+	if (mmu_enabled())
+		return uart0_base;
+	return (u8 *)arm_shared_phys_alias((void *)uart0_base);
+}
+
 static void uart0_init_fdt(void)
 {
 	/*
@@ -109,9 +129,11 @@ void io_init(void)
 
 void puts(const char *s)
 {
+	volatile u8 *uart_base = get_uart_base();
+
 	spin_lock(&uart_lock);
 	while (*s)
-		writeb(*s++, uart0_base);
+		writeb(*s++, uart_base);
 	spin_unlock(&uart_lock);
 }
 
diff --git a/lib/arm64/asm/pgtable.h b/lib/arm64/asm/pgtable.h
index 5b9f40b0..871c03e9 100644
--- a/lib/arm64/asm/pgtable.h
+++ b/lib/arm64/asm/pgtable.h
@@ -28,6 +28,11 @@ extern unsigned long prot_ns_shared;
 */
 #define PTE_NS_SHARED		(prot_ns_shared)
 
+static inline unsigned long arm_shared_phys_alias(void *addr)
+{
+	return ((unsigned long)addr | PTE_NS_SHARED);
+}
+
 /*
  * Highest possible physical address supported.
  */
-- 
2.34.1


