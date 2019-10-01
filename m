Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB56AC3137
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 12:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730469AbfJAKXy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 06:23:54 -0400
Received: from foss.arm.com ([217.140.110.172]:45962 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730442AbfJAKXx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 06:23:53 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B555C1570;
        Tue,  1 Oct 2019 03:23:52 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 779F73F739;
        Tue,  1 Oct 2019 03:23:51 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        maz@kernel.org, vladimir.murzin@arm.com, andre.przywara@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests RFC PATCH v2 10/19] arm/arm64: Perform dcache clean + invalidate after turning MMU off
Date:   Tue,  1 Oct 2019 11:23:14 +0100
Message-Id: <20191001102323.27628-11-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001102323.27628-1-alexandru.elisei@arm.com>
References: <20191001102323.27628-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the MMU is off, data accesses are to Device nGnRnE memory on arm64 [1]
or to Strongly-Ordered memory on arm [2]. This means that the accesses are
non-cacheable.

Perform a dcache clean to PoC so we can read the newer values from the
cache, instead of the stale values from memory.

Perform an invalidation so when we turn the MMU on, we can access the
data written to memory while the MMU was off, instead of potentially
stale values from the cache.

Data caches are PIPT and the VAs are translated using the current
translation tables, or an identity mapping (what Arm calls a "flat
mapping") when the MMU is off [1][2]. Do the clean + invalidate when the
MMU is off so we don't depend on the current translation tables and we can
make sure that the operation applies to the entire physical memory.

[1] ARM DDI 0487E.a, section D5.2.9
[2] ARM DDI 0406C.d, section B3.2.1

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/asm/processor.h   |  6 ++++++
 lib/arm64/asm/processor.h |  6 ++++++
 lib/arm/processor.c       | 10 ++++++++++
 lib/arm/setup.c           |  2 ++
 lib/arm64/processor.c     | 11 +++++++++++
 arm/cstart.S              | 22 ++++++++++++++++++++++
 arm/cstart64.S            | 23 +++++++++++++++++++++++
 7 files changed, 80 insertions(+)

diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
index a8c4628da818..4684fb4755b3 100644
--- a/lib/arm/asm/processor.h
+++ b/lib/arm/asm/processor.h
@@ -9,6 +9,11 @@
 #include <asm/sysreg.h>
 #include <asm/barrier.h>
 
+#define CTR_DMINLINE_SHIFT	16
+#define CTR_DMINLINE_MASK	(0xf << 16)
+#define CTR_DMINLINE(x)	\
+	(((x) & CTR_DMINLINE_MASK) >> CTR_DMINLINE_SHIFT)
+
 enum vector {
 	EXCPTN_RST,
 	EXCPTN_UND,
@@ -25,6 +30,7 @@ typedef void (*exception_fn)(struct pt_regs *);
 extern void install_exception_handler(enum vector v, exception_fn fn);
 
 extern void show_regs(struct pt_regs *regs);
+extern void init_dcache_line_size(void);
 
 static inline unsigned long current_cpsr(void)
 {
diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 1d9223f728a5..fd508c02f30d 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -16,6 +16,11 @@
 #define SCTLR_EL1_A	(1 << 1)
 #define SCTLR_EL1_M	(1 << 0)
 
+#define CTR_EL0_DMINLINE_SHIFT	16
+#define CTR_EL0_DMINLINE_MASK	(0xf << 16)
+#define CTR_EL0_DMINLINE(x)	\
+	(((x) & CTR_EL0_DMINLINE_MASK) >> CTR_EL0_DMINLINE_SHIFT)
+
 #ifndef __ASSEMBLY__
 #include <asm/ptrace.h>
 #include <asm/esr.h>
@@ -60,6 +65,7 @@ extern void vector_handlers_default_init(vector_fn *handlers);
 
 extern void show_regs(struct pt_regs *regs);
 extern bool get_far(unsigned int esr, unsigned long *far);
+extern void init_dcache_line_size(void);
 
 static inline unsigned long current_level(void)
 {
diff --git a/lib/arm/processor.c b/lib/arm/processor.c
index 773337e6d3b7..c57657c5ea53 100644
--- a/lib/arm/processor.c
+++ b/lib/arm/processor.c
@@ -25,6 +25,8 @@ static const char *vector_names[] = {
 	"rst", "und", "svc", "pabt", "dabt", "addrexcptn", "irq", "fiq"
 };
 
+unsigned int dcache_line_size;
+
 void show_regs(struct pt_regs *regs)
 {
 	unsigned long flags;
@@ -145,3 +147,11 @@ bool is_user(void)
 {
 	return current_thread_info()->flags & TIF_USER_MODE;
 }
+void init_dcache_line_size(void)
+{
+	u32 ctr;
+
+	asm volatile("mrc p15, 0, %0, c0, c0, 1" : "=r" (ctr));
+	/* DminLine is log2 of the number of words in the smallest cache line */
+	dcache_line_size = 1 << (CTR_DMINLINE(ctr) + 2);
+}
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 4f02fca85607..54fc19a20942 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -20,6 +20,7 @@
 #include <asm/thread_info.h>
 #include <asm/setup.h>
 #include <asm/page.h>
+#include <asm/processor.h>
 #include <asm/smp.h>
 
 #include "io.h"
@@ -63,6 +64,7 @@ static void cpu_init(void)
 	ret = dt_for_each_cpu_node(cpu_set, NULL);
 	assert(ret == 0);
 	set_cpu_online(0, true);
+	init_dcache_line_size();
 }
 
 static void mem_init(phys_addr_t freemem_start)
diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
index 2a024e3f4e9d..f28066d40145 100644
--- a/lib/arm64/processor.c
+++ b/lib/arm64/processor.c
@@ -62,6 +62,8 @@ static const char *ec_names[EC_MAX] = {
 	[ESR_EL1_EC_BRK64]		= "BRK64",
 };
 
+unsigned int dcache_line_size;
+
 void show_regs(struct pt_regs *regs)
 {
 	int i;
@@ -257,3 +259,12 @@ bool is_user(void)
 {
 	return current_thread_info()->flags & TIF_USER_MODE;
 }
+
+void init_dcache_line_size(void)
+{
+	u64 ctr;
+
+	ctr = read_sysreg(ctr_el0);
+	/* DminLine is log2 of the number of words in the smallest cache line */
+	dcache_line_size = 1 << (CTR_EL0_DMINLINE(ctr) + 2);
+}
diff --git a/arm/cstart.S b/arm/cstart.S
index 112124f222cb..c8bbb4f0a2a2 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -185,6 +185,20 @@ asm_mmu_enable:
 
 	mov     pc, lr
 
+.macro dcache_clean_inval domain, start, end, tmp1, tmp2
+	ldr	\tmp1, =dcache_line_size
+	ldr	\tmp1, [\tmp1]
+	sub	\tmp2, \tmp1, #1
+	bic	\start, \start, \tmp2
+9998:
+	/* DCCIMVAC */
+	mcr	p15, 0, \start, c7, c14, 1
+	add	\start, \start, \tmp1
+	cmp	\start, \end
+	blo	9998b
+	dsb	\domain
+.endm
+
 .globl asm_mmu_disable
 asm_mmu_disable:
 	/* SCTLR */
@@ -192,6 +206,14 @@ asm_mmu_disable:
 	bic	r0, #CR_M
 	mcr	p15, 0, r0, c1, c0, 0
 	isb
+
+	ldr	r0, =__phys_offset
+	ldr	r0, [r0]
+	ldr	r1, =__phys_end
+	ldr	r1, [r1]
+	dcache_clean_inval sy, r0, r1, r2, r3
+	isb
+
 	mov     pc, lr
 
 /*
diff --git a/arm/cstart64.S b/arm/cstart64.S
index c98842f11e90..f41ffa3bc6c2 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -201,12 +201,35 @@ asm_mmu_enable:
 
 	ret
 
+/* Taken with small changes from arch/arm64/incluse/asm/assembler.h */
+.macro dcache_by_line_op op, domain, start, end, tmp1, tmp2
+	adrp	\tmp1, dcache_line_size
+	ldr	\tmp1, [\tmp1, :lo12:dcache_line_size]
+	sub	\tmp2, \tmp1, #1
+	bic	\start, \start, \tmp2
+9998:
+	dc	\op , \start
+	add	\start, \start, \tmp1
+	cmp	\start, \end
+	b.lo	9998b
+	dsb	\domain
+.endm
+
 .globl asm_mmu_disable
 asm_mmu_disable:
 	mrs	x0, sctlr_el1
 	bic	x0, x0, SCTLR_EL1_M
 	msr	sctlr_el1, x0
 	isb
+
+	/* Clean + invalidate the entire memory */
+	adrp	x0, __phys_offset
+	ldr	x0, [x0, :lo12:__phys_offset]
+	adrp	x1, __phys_end
+	ldr	x1, [x1, :lo12:__phys_end]
+	dcache_by_line_op civac, sy, x0, x1, x2, x3
+	isb
+
 	ret
 
 /*
-- 
2.20.1

