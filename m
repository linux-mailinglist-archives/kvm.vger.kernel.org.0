Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F18326CC8
	for <lists+kvm@lfdr.de>; Sat, 27 Feb 2021 11:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhB0Kmq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Feb 2021 05:42:46 -0500
Received: from foss.arm.com ([217.140.110.172]:43006 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230095AbhB0Kmg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Feb 2021 05:42:36 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D981411B3;
        Sat, 27 Feb 2021 02:41:49 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 42D793F73B;
        Sat, 27 Feb 2021 02:41:49 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH 2/6] arm/arm64: Remove dcache_line_size global variable
Date:   Sat, 27 Feb 2021 10:41:57 +0000
Message-Id: <20210227104201.14403-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210227104201.14403-1-alexandru.elisei@arm.com>
References: <20210227104201.14403-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Compute the dcache line size when doing dcache maintenance instead of using
a global variable computed in setup(), which allows us to do dcache
maintenance at any point in the boot process. This will be useful for
running as an EFI app and it also aligns our implementation to that of the
Linux kernel.

For consistency, the arm code has been similary modified.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/asm/assembler.h   | 44 ++++++++++++++++++++++++++++++++
 lib/arm/asm/processor.h   |  7 ------
 lib/arm64/asm/assembler.h | 53 +++++++++++++++++++++++++++++++++++++++
 lib/arm64/asm/processor.h |  7 ------
 lib/arm/setup.c           |  7 ------
 arm/cstart.S              | 18 +++----------
 arm/cstart64.S            | 16 ++----------
 7 files changed, 102 insertions(+), 50 deletions(-)
 create mode 100644 lib/arm/asm/assembler.h
 create mode 100644 lib/arm64/asm/assembler.h

diff --git a/lib/arm/asm/assembler.h b/lib/arm/asm/assembler.h
new file mode 100644
index 000000000000..6b932df86204
--- /dev/null
+++ b/lib/arm/asm/assembler.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Based on several files from Linux version v5.10: arch/arm/mm/proc-macros.S,
+ * arch/arm/mm/proc-v7.S.
+ */
+
+/*
+ * dcache_line_size - get the minimum D-cache line size from the CTR register
+ * on ARMv7.
+ */
+	.macro	dcache_line_size, reg, tmp
+	mrc	p15, 0, \tmp, c0, c0, 1		// read ctr
+	lsr	\tmp, \tmp, #16
+	and	\tmp, \tmp, #0xf		// cache line size encoding
+	mov	\reg, #4			// bytes per word
+	mov	\reg, \reg, lsl \tmp		// actual cache line size
+	.endm
+
+/*
+ * Macro to perform a data cache maintenance for the interval
+ * [addr, addr + size).
+ *
+ * 	op:		operation to execute
+ * 	domain		domain used in the dsb instruction
+ * 	addr:		starting virtual address of the region
+ * 	size:		size of the region
+ * 	Corrupts:	addr, size, tmp1, tmp2
+ */
+	.macro dcache_by_line_op op, domain, addr, size, tmp1, tmp2
+	dcache_line_size \tmp1, \tmp2
+	add	\size, \addr, \size
+	sub	\tmp2, \tmp1, #1
+	bic	\addr, \addr, \tmp2
+9998:
+	.ifc	\op, dccimvac
+	mcr	p15, 0, \addr, c7, c14, 1
+	.else
+	.err
+	.endif
+	add	\addr, \addr, \tmp1
+	cmp	\addr, \size
+	blo	9998b
+	dsb	\domain
+	.endm
diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
index 273366d1fe1c..3c36eac903f0 100644
--- a/lib/arm/asm/processor.h
+++ b/lib/arm/asm/processor.h
@@ -9,11 +9,6 @@
 #include <asm/sysreg.h>
 #include <asm/barrier.h>
 
-#define CTR_DMINLINE_SHIFT	16
-#define CTR_DMINLINE_MASK	(0xf << 16)
-#define CTR_DMINLINE(x)	\
-	(((x) & CTR_DMINLINE_MASK) >> CTR_DMINLINE_SHIFT)
-
 enum vector {
 	EXCPTN_RST,
 	EXCPTN_UND,
@@ -89,6 +84,4 @@ static inline u32 get_ctr(void)
 	return read_sysreg(CTR);
 }
 
-extern unsigned long dcache_line_size;
-
 #endif /* _ASMARM_PROCESSOR_H_ */
diff --git a/lib/arm64/asm/assembler.h b/lib/arm64/asm/assembler.h
new file mode 100644
index 000000000000..f801c0c43d02
--- /dev/null
+++ b/lib/arm64/asm/assembler.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Based on the file arch/arm64/include/asm/assembled.h from Linux v5.10, which
+ * in turn is based on arch/arm/include/asm/assembler.h and
+ * arch/arm/mm/proc-macros.S
+ *
+ * Copyright (C) 1996-2000 Russell King
+ * Copyright (C) 2012 ARM Ltd.
+ */
+#ifndef __ASSEMBLY__
+#error "Only include this from assembly code"
+#endif
+
+#ifndef __ASM_ASSEMBLER_H
+#define __ASM_ASSEMBLER_H
+
+/*
+ * raw_dcache_line_size - get the minimum D-cache line size on this CPU
+ * from the CTR register.
+ */
+	.macro	raw_dcache_line_size, reg, tmp
+	mrs	\tmp, ctr_el0			// read CTR
+	ubfm	\tmp, \tmp, #16, #19		// cache line size encoding
+	mov	\reg, #4			// bytes per word
+	lsl	\reg, \reg, \tmp		// actual cache line size
+	.endm
+
+/*
+ * Macro to perform a data cache maintenance for the interval
+ * [addr, addr + size). Use the raw value for the dcache line size because
+ * kvm-unit-tests has no concept of scheduling.
+ *
+ * 	op:		operation passed to dc instruction
+ * 	domain:		domain used in dsb instruciton
+ * 	addr:		starting virtual address of the region
+ * 	size:		size of the region
+ * 	Corrupts:	addr, size, tmp1, tmp2
+ */
+
+	.macro dcache_by_line_op op, domain, addr, size, tmp1, tmp2
+	raw_dcache_line_size \tmp1, \tmp2
+	add	\size, \addr, \size
+	sub	\tmp2, \tmp1, #1
+	bic	\addr, \addr, \tmp2
+9998:
+	dc	\op, \addr
+	add	\addr, \addr, \tmp1
+	cmp	\addr, \size
+	b.lo	9998b
+	dsb	\domain
+	.endm
+
+#endif	/* __ASM_ASSEMBLER_H */
diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 771b2d1e0c94..cdc2463e1981 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -16,11 +16,6 @@
 #define SCTLR_EL1_A	(1 << 1)
 #define SCTLR_EL1_M	(1 << 0)
 
-#define CTR_DMINLINE_SHIFT	16
-#define CTR_DMINLINE_MASK	(0xf << 16)
-#define CTR_DMINLINE(x)	\
-	(((x) & CTR_DMINLINE_MASK) >> CTR_DMINLINE_SHIFT)
-
 #ifndef __ASSEMBLY__
 #include <asm/ptrace.h>
 #include <asm/esr.h>
@@ -115,8 +110,6 @@ static inline u64 get_ctr(void)
 	return read_sysreg(ctr_el0);
 }
 
-extern unsigned long dcache_line_size;
-
 static inline unsigned long get_id_aa64mmfr0_el1(void)
 {
 	return read_sysreg(id_aa64mmfr0_el1);
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 066524f8bf61..751ba980000a 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -42,8 +42,6 @@ static struct mem_region __initial_mem_regions[NR_INITIAL_MEM_REGIONS + 1];
 struct mem_region *mem_regions = __initial_mem_regions;
 phys_addr_t __phys_offset, __phys_end;
 
-unsigned long dcache_line_size;
-
 int mpidr_to_cpu(uint64_t mpidr)
 {
 	int i;
@@ -72,11 +70,6 @@ static void cpu_init(void)
 	ret = dt_for_each_cpu_node(cpu_set, NULL);
 	assert(ret == 0);
 	set_cpu_online(0, true);
-	/*
-	 * DminLine is log2 of the number of words in the smallest cache line; a
-	 * word is 4 bytes.
-	 */
-	dcache_line_size = 1 << (CTR_DMINLINE(get_ctr()) + 2);
 }
 
 unsigned int mem_region_get_flags(phys_addr_t paddr)
diff --git a/arm/cstart.S b/arm/cstart.S
index ef936ae2f874..954748b00f64 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -7,6 +7,7 @@
  */
 #define __ASSEMBLY__
 #include <auxinfo.h>
+#include <asm/assembler.h>
 #include <asm/thread_info.h>
 #include <asm/asm-offsets.h>
 #include <asm/pgtable-hwdef.h>
@@ -197,20 +198,6 @@ asm_mmu_enable:
 
 	mov     pc, lr
 
-.macro dcache_clean_inval domain, start, end, tmp1, tmp2
-	ldr	\tmp1, =dcache_line_size
-	ldr	\tmp1, [\tmp1]
-	sub	\tmp2, \tmp1, #1
-	bic	\start, \start, \tmp2
-9998:
-	/* DCCIMVAC */
-	mcr	p15, 0, \start, c7, c14, 1
-	add	\start, \start, \tmp1
-	cmp	\start, \end
-	blo	9998b
-	dsb	\domain
-.endm
-
 .globl asm_mmu_disable
 asm_mmu_disable:
 	/* SCTLR */
@@ -223,7 +210,8 @@ asm_mmu_disable:
 	ldr	r0, [r0]
 	ldr	r1, =__phys_end
 	ldr	r1, [r1]
-	dcache_clean_inval sy, r0, r1, r2, r3
+	sub	r1, r1, r0
+	dcache_by_line_op dccimvac, sy, r0, r1, r2, r3
 	isb
 
 	mov     pc, lr
diff --git a/arm/cstart64.S b/arm/cstart64.S
index fc1930bcdb53..046bd3914098 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -8,6 +8,7 @@
 #define __ASSEMBLY__
 #include <auxinfo.h>
 #include <asm/asm-offsets.h>
+#include <asm/assembler.h>
 #include <asm/ptrace.h>
 #include <asm/processor.h>
 #include <asm/page.h>
@@ -204,20 +205,6 @@ asm_mmu_enable:
 
 	ret
 
-/* Taken with small changes from arch/arm64/incluse/asm/assembler.h */
-.macro dcache_by_line_op op, domain, start, end, tmp1, tmp2
-	adrp	\tmp1, dcache_line_size
-	ldr	\tmp1, [\tmp1, :lo12:dcache_line_size]
-	sub	\tmp2, \tmp1, #1
-	bic	\start, \start, \tmp2
-9998:
-	dc	\op , \start
-	add	\start, \start, \tmp1
-	cmp	\start, \end
-	b.lo	9998b
-	dsb	\domain
-.endm
-
 .globl asm_mmu_disable
 asm_mmu_disable:
 	mrs	x0, sctlr_el1
@@ -230,6 +217,7 @@ asm_mmu_disable:
 	ldr	x0, [x0, :lo12:__phys_offset]
 	adrp	x1, __phys_end
 	ldr	x1, [x1, :lo12:__phys_end]
+	sub	x1, x1, x0
 	dcache_by_line_op civac, sy, x0, x1, x2, x3
 	isb
 
-- 
2.30.1

