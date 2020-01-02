Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8450B12E6E3
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2020 14:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728393AbgABNrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jan 2020 08:47:07 -0500
Received: from foss.arm.com ([217.140.110.172]:47280 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728342AbgABNrH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jan 2020 08:47:07 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 94E911FB;
        Thu,  2 Jan 2020 05:47:06 -0800 (PST)
Received: from e121566-lin.arm.com,emea.arm.com,asiapac.arm.com,usa.arm.com (unknown [10.37.9.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5B4263F68F;
        Thu,  2 Jan 2020 05:47:04 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, maz@kernel.org,
        andre.przywara@arm.com, Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests RFC PATCH v3 1/7] lib: Add _UL and _ULL definitions to linux/const.h
Date:   Thu,  2 Jan 2020 13:46:40 +0000
Message-Id: <1577972806-16184-2-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1577972806-16184-1-git-send-email-alexandru.elisei@arm.com>
References: <1577972806-16184-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is an UL macro defined in lib/arm64/asm/pgtable-hwdef.h.  Replace
it with the _UL macro and put it in lib/linux/const.h, where it can be
used in other files. To keep things consistent with Linux's
include/uapi/linux/const.h file, also add an _ULL macro.

Cc: Drew Jones <drjones@redhat.com>
Cc: Laurent Vivier <lvivier@redhat.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/linux/const.h             |  7 ++++--
 lib/asm-generic/page.h        |  2 +-
 lib/arm/asm/page.h            |  2 +-
 lib/arm/asm/pgtable-hwdef.h   | 22 ++++++++++---------
 lib/arm/asm/thread_info.h     |  3 ++-
 lib/arm64/asm/page.h          |  2 +-
 lib/arm64/asm/pgtable-hwdef.h | 50 +++++++++++++++++++++----------------------
 lib/x86/asm/page.h            |  2 +-
 8 files changed, 48 insertions(+), 42 deletions(-)

diff --git a/lib/linux/const.h b/lib/linux/const.h
index c872bfd25e13..1453a886d041 100644
--- a/lib/linux/const.h
+++ b/lib/linux/const.h
@@ -21,7 +21,10 @@
 #define _AT(T,X)	((T)(X))
 #endif
 
-#define _BITUL(x)	(_AC(1,UL) << (x))
-#define _BITULL(x)	(_AC(1,ULL) << (x))
+#define _UL(x) 		_AC(x, UL)
+#define _ULL(x)		_AC(x, ULL)
+
+#define _BITUL(x)	(_UL(1) << (x))
+#define _BITULL(x)	(_ULL(1) << (x))
 
 #endif /* !(_LINUX_CONST_H) */
diff --git a/lib/asm-generic/page.h b/lib/asm-generic/page.h
index 5ed086129657..0b495ad090b7 100644
--- a/lib/asm-generic/page.h
+++ b/lib/asm-generic/page.h
@@ -12,7 +12,7 @@
 #include <linux/const.h>
 
 #define PAGE_SHIFT		12
-#define PAGE_SIZE		(_AC(1,UL) << PAGE_SHIFT)
+#define PAGE_SIZE		(_UL(1) << PAGE_SHIFT)
 #define PAGE_MASK		(~(PAGE_SIZE-1))
 
 #ifndef __ASSEMBLY__
diff --git a/lib/arm/asm/page.h b/lib/arm/asm/page.h
index 039c9f7b3d49..37c9f2f12eb0 100644
--- a/lib/arm/asm/page.h
+++ b/lib/arm/asm/page.h
@@ -9,7 +9,7 @@
 #include <linux/const.h>
 
 #define PAGE_SHIFT		12
-#define PAGE_SIZE		(_AC(1,UL) << PAGE_SHIFT)
+#define PAGE_SIZE		(_UL(1) << PAGE_SHIFT)
 #define PAGE_MASK		(~(PAGE_SIZE-1))
 
 #ifndef __ASSEMBLY__
diff --git a/lib/arm/asm/pgtable-hwdef.h b/lib/arm/asm/pgtable-hwdef.h
index 4107e188014a..66288ebb717c 100644
--- a/lib/arm/asm/pgtable-hwdef.h
+++ b/lib/arm/asm/pgtable-hwdef.h
@@ -9,9 +9,11 @@
  * This work is licensed under the terms of the GNU GPL, version 2.
  */
 
+#include <linux/const.h>
+
 #define PTRS_PER_PGD		4
 #define PGDIR_SHIFT		30
-#define PGDIR_SIZE		(_AC(1,UL) << PGDIR_SHIFT)
+#define PGDIR_SIZE		(_UL(1) << PGDIR_SHIFT)
 #define PGDIR_MASK		(~((1 << PGDIR_SHIFT) - 1))
 
 #define PGD_VALID		(_AT(pgdval_t, 1) << 0)
@@ -20,7 +22,7 @@
 #define PTRS_PER_PMD		512
 
 #define PMD_SHIFT		21
-#define PMD_SIZE		(_AC(1,UL) << PMD_SHIFT)
+#define PMD_SIZE		(_UL(1) << PMD_SHIFT)
 #define PMD_MASK		(~((1 << PMD_SHIFT) - 1))
 
 #define L_PMD_SECT_VALID	(_AT(pmdval_t, 1) << 0)
@@ -109,14 +111,14 @@
  * 40-bit physical address supported.
  */
 #define PHYS_MASK_SHIFT		(40)
-#define PHYS_MASK		((_AC(1, ULL) << PHYS_MASK_SHIFT) - 1)
+#define PHYS_MASK		((_ULL(1) << PHYS_MASK_SHIFT) - 1)
 
-#define TTBCR_IRGN0_WBWA	(_AC(1, UL) << 8)
-#define TTBCR_ORGN0_WBWA	(_AC(1, UL) << 10)
-#define TTBCR_SH0_SHARED	(_AC(3, UL) << 12)
-#define TTBCR_IRGN1_WBWA	(_AC(1, UL) << 24)
-#define TTBCR_ORGN1_WBWA	(_AC(1, UL) << 26)
-#define TTBCR_SH1_SHARED	(_AC(3, UL) << 28)
-#define TTBCR_EAE		(_AC(1, UL) << 31)
+#define TTBCR_IRGN0_WBWA	(_UL(1) << 8)
+#define TTBCR_ORGN0_WBWA	(_UL(1) << 10)
+#define TTBCR_SH0_SHARED	(_UL(3) << 12)
+#define TTBCR_IRGN1_WBWA	(_UL(1) << 24)
+#define TTBCR_ORGN1_WBWA	(_UL(1) << 26)
+#define TTBCR_SH1_SHARED	(_UL(3) << 28)
+#define TTBCR_EAE		(_UL(1) << 31)
 
 #endif /* _ASMARM_PGTABLE_HWDEF_H_ */
diff --git a/lib/arm/asm/thread_info.h b/lib/arm/asm/thread_info.h
index 80ab3954a6b0..7ff1570e1381 100644
--- a/lib/arm/asm/thread_info.h
+++ b/lib/arm/asm/thread_info.h
@@ -7,6 +7,7 @@
  *
  * This work is licensed under the terms of the GNU GPL, version 2.
  */
+#include <linux/const.h>
 #include <asm/page.h>
 
 #define MIN_THREAD_SHIFT	14	/* THREAD_SIZE == 16K */
@@ -16,7 +17,7 @@
 #define THREAD_MASK		PAGE_MASK
 #else
 #define THREAD_SHIFT		MIN_THREAD_SHIFT
-#define THREAD_SIZE		(_AC(1,UL) << THREAD_SHIFT)
+#define THREAD_SIZE		(_UL(1) << THREAD_SHIFT)
 #define THREAD_MASK		(~(THREAD_SIZE-1))
 #endif
 
diff --git a/lib/arm64/asm/page.h b/lib/arm64/asm/page.h
index 46af552b91c7..07b3b61c2474 100644
--- a/lib/arm64/asm/page.h
+++ b/lib/arm64/asm/page.h
@@ -16,7 +16,7 @@
 #define VA_BITS			42
 
 #define PAGE_SHIFT		16
-#define PAGE_SIZE		(_AC(1,UL) << PAGE_SHIFT)
+#define PAGE_SIZE		(_UL(1) << PAGE_SHIFT)
 #define PAGE_MASK		(~(PAGE_SIZE-1))
 
 #ifndef __ASSEMBLY__
diff --git a/lib/arm64/asm/pgtable-hwdef.h b/lib/arm64/asm/pgtable-hwdef.h
index 33524899e5fa..a434a01b24fc 100644
--- a/lib/arm64/asm/pgtable-hwdef.h
+++ b/lib/arm64/asm/pgtable-hwdef.h
@@ -9,7 +9,7 @@
  * This work is licensed under the terms of the GNU GPL, version 2.
  */
 
-#define UL(x) _AC(x, UL)
+#include <linux/const.h>
 
 #define PTRS_PER_PTE		(1 << (PAGE_SHIFT - 3))
 
@@ -18,7 +18,7 @@
  * (depending on the configuration, this level can be 0, 1 or 2).
  */
 #define PGDIR_SHIFT		((PAGE_SHIFT - 3) * PGTABLE_LEVELS + 3)
-#define PGDIR_SIZE		(_AC(1, UL) << PGDIR_SHIFT)
+#define PGDIR_SIZE		(_UL(1) << PGDIR_SHIFT)
 #define PGDIR_MASK		(~(PGDIR_SIZE-1))
 #define PTRS_PER_PGD		(1 << (VA_BITS - PGDIR_SHIFT))
 
@@ -27,14 +27,14 @@
 /* From include/asm-generic/pgtable-nopmd.h */
 #define PMD_SHIFT		PGDIR_SHIFT
 #define PTRS_PER_PMD		1
-#define PMD_SIZE		(UL(1) << PMD_SHIFT)
+#define PMD_SIZE		(_UL(1) << PMD_SHIFT)
 #define PMD_MASK		(~(PMD_SIZE-1))
 
 /*
  * Section address mask and size definitions.
  */
 #define SECTION_SHIFT		PMD_SHIFT
-#define SECTION_SIZE		(_AC(1, UL) << SECTION_SHIFT)
+#define SECTION_SIZE		(_UL(1) << SECTION_SHIFT)
 #define SECTION_MASK		(~(SECTION_SIZE-1))
 
 /*
@@ -93,31 +93,31 @@
  * Highest possible physical address supported.
  */
 #define PHYS_MASK_SHIFT		(48)
-#define PHYS_MASK		((UL(1) << PHYS_MASK_SHIFT) - 1)
+#define PHYS_MASK		((_UL(1) << PHYS_MASK_SHIFT) - 1)
 
 /*
  * TCR flags.
  */
-#define TCR_TxSZ(x)		(((UL(64) - (x)) << 16) | ((UL(64) - (x)) << 0))
-#define TCR_IRGN_NC		((UL(0) << 8) | (UL(0) << 24))
-#define TCR_IRGN_WBWA		((UL(1) << 8) | (UL(1) << 24))
-#define TCR_IRGN_WT		((UL(2) << 8) | (UL(2) << 24))
-#define TCR_IRGN_WBnWA		((UL(3) << 8) | (UL(3) << 24))
-#define TCR_IRGN_MASK		((UL(3) << 8) | (UL(3) << 24))
-#define TCR_ORGN_NC		((UL(0) << 10) | (UL(0) << 26))
-#define TCR_ORGN_WBWA		((UL(1) << 10) | (UL(1) << 26))
-#define TCR_ORGN_WT		((UL(2) << 10) | (UL(2) << 26))
-#define TCR_ORGN_WBnWA		((UL(3) << 10) | (UL(3) << 26))
-#define TCR_ORGN_MASK		((UL(3) << 10) | (UL(3) << 26))
-#define TCR_SHARED		((UL(3) << 12) | (UL(3) << 28))
-#define TCR_TG0_4K		(UL(0) << 14)
-#define TCR_TG0_64K		(UL(1) << 14)
-#define TCR_TG0_16K		(UL(2) << 14)
-#define TCR_TG1_16K		(UL(1) << 30)
-#define TCR_TG1_4K		(UL(2) << 30)
-#define TCR_TG1_64K		(UL(3) << 30)
-#define TCR_ASID16		(UL(1) << 36)
-#define TCR_TBI0		(UL(1) << 37)
+#define TCR_TxSZ(x)		(((_UL(64) - (x)) << 16) | ((_UL(64) - (x)) << 0))
+#define TCR_IRGN_NC		((_UL(0) << 8) | (_UL(0) << 24))
+#define TCR_IRGN_WBWA		((_UL(1) << 8) | (_UL(1) << 24))
+#define TCR_IRGN_WT		((_UL(2) << 8) | (_UL(2) << 24))
+#define TCR_IRGN_WBnWA		((_UL(3) << 8) | (_UL(3) << 24))
+#define TCR_IRGN_MASK		((_UL(3) << 8) | (_UL(3) << 24))
+#define TCR_ORGN_NC		((_UL(0) << 10) | (_UL(0) << 26))
+#define TCR_ORGN_WBWA		((_UL(1) << 10) | (_UL(1) << 26))
+#define TCR_ORGN_WT		((_UL(2) << 10) | (_UL(2) << 26))
+#define TCR_ORGN_WBnWA		((_UL(3) << 10) | (_UL(3) << 26))
+#define TCR_ORGN_MASK		((_UL(3) << 10) | (_UL(3) << 26))
+#define TCR_SHARED		((_UL(3) << 12) | (_UL(3) << 28))
+#define TCR_TG0_4K		(_UL(0) << 14)
+#define TCR_TG0_64K		(_UL(1) << 14)
+#define TCR_TG0_16K		(_UL(2) << 14)
+#define TCR_TG1_16K		(_UL(1) << 30)
+#define TCR_TG1_4K		(_UL(2) << 30)
+#define TCR_TG1_64K		(_UL(3) << 30)
+#define TCR_ASID16		(_UL(1) << 36)
+#define TCR_TBI0		(_UL(1) << 37)
 
 /*
  * Memory types available.
diff --git a/lib/x86/asm/page.h b/lib/x86/asm/page.h
index 073580a80f0c..5d3af06d14b4 100644
--- a/lib/x86/asm/page.h
+++ b/lib/x86/asm/page.h
@@ -14,7 +14,7 @@ typedef unsigned long pteval_t;
 typedef unsigned long pgd_t;
 
 #define PAGE_SHIFT	12
-#define PAGE_SIZE	(_AC(1,UL) << PAGE_SHIFT)
+#define PAGE_SIZE	(_UL(1) << PAGE_SHIFT)
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 
 #ifndef __ASSEMBLY__
-- 
2.7.4

