Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C482154910
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 17:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727609AbgBFQZA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 11:25:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55828 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727556AbgBFQY7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 11:24:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581006298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fa3hMmMOW5FU9aFmVZeiIF+c6T94QcQm1rzYH9qBabg=;
        b=RSIprctD3+MYjEbotq1ZgjGeydY4nuSUXY8AS09cPVe8irKxp8pMw5p7cBxjq+K5R/1ZuE
        NfLnyn5eVjwykz4K5tWRd4C+nzk7Bwv6L7HWK/NnJeGhKFF/R1WkEilD8bwJciKEs+U7y1
        TaisHRfdWDQQVQKVm34MdC9Lezs/LyQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-8aWdNmKqM5279PQBF5KRRA-1; Thu, 06 Feb 2020 11:24:53 -0500
X-MC-Unique: 8aWdNmKqM5279PQBF5KRRA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6837994CDD;
        Thu,  6 Feb 2020 16:24:52 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 675C110027BE;
        Thu,  6 Feb 2020 16:24:51 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PULL kvm-unit-tests 10/10] arm/arm64: Perform dcache clean + invalidate after turning MMU off
Date:   Thu,  6 Feb 2020 17:24:34 +0100
Message-Id: <20200206162434.14624-11-drjones@redhat.com>
In-Reply-To: <20200206162434.14624-1-drjones@redhat.com>
References: <20200206162434.14624-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

When the MMU is off, data accesses are to Device nGnRnE memory on arm64 [=
1]
or to Strongly-Ordered memory on arm [2]. This means that the accesses ar=
e
non-cacheable.

Perform a dcache clean to PoC so we can read the newer values from the
cache after we turn the MMU off, instead of the stale values from memory.

Perform an invalidation so we can access the data written to memory after
we turn the MMU back on. This prevents reading back the stale values we
cleaned from the cache when we turned the MMU off.

Data caches are PIPT and the VAs are translated using the current
translation tables, or an identity mapping (what Arm calls a "flat
mapping") when the MMU is off [1, 2]. Do the clean + invalidate when the
MMU is off so we don't depend on the current translation tables and we ca=
n
make sure that the operation applies to the entire physical memory.

The patch was tested by hacking arm/selftest.c:

+#include <alloc_page.h>
+#include <asm/mmu.h>
 int main(int argc, char **argv)
 {
+	int *x =3D alloc_page();
+
 	report_prefix_push("selftest");

+	*x =3D 0x42;
+	mmu_disable();
+	report(*x =3D=3D 0x42, "read back value written with MMU on");
+	*x =3D 0x50;
+	mmu_enable(current_thread_info()->pgtable);
+	report(*x =3D=3D 0x50, "read back value written with MMU off");
+
 	if (argc < 2)
 		report_abort("no test specified");

Without the fix, the first report fails, and the test usually hangs befor=
e
the second report. This is because mmu_enable pushes the LR register on t=
he
stack when the MMU is off, which means that the value will be written to
memory.  However, after asm_mmu_enable, the MMU is enabled, and we read i=
t
back from the dcache, thus getting garbage.

With the fix, the two reports pass.

[1] ARM DDI 0487E.a, section D5.2.9
[2] ARM DDI 0406C.d, section B3.2.1

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/cstart.S              | 22 ++++++++++++++++++++++
 arm/cstart64.S            | 23 +++++++++++++++++++++++
 lib/arm/asm/processor.h   | 13 +++++++++++++
 lib/arm/setup.c           |  8 ++++++++
 lib/arm64/asm/processor.h | 12 ++++++++++++
 5 files changed, 78 insertions(+)

diff --git a/arm/cstart.S b/arm/cstart.S
index e54e380e0d53..ef936ae2f874 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -197,6 +197,20 @@ asm_mmu_enable:
=20
 	mov     pc, lr
=20
+.macro dcache_clean_inval domain, start, end, tmp1, tmp2
+	ldr	\tmp1, =3Ddcache_line_size
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
@@ -204,6 +218,14 @@ asm_mmu_disable:
 	bic	r0, #CR_M
 	mcr	p15, 0, r0, c1, c0, 0
 	isb
+
+	ldr	r0, =3D__phys_offset
+	ldr	r0, [r0]
+	ldr	r1, =3D__phys_end
+	ldr	r1, [r1]
+	dcache_clean_inval sy, r0, r1, r2, r3
+	isb
+
 	mov     pc, lr
=20
 /*
diff --git a/arm/cstart64.S b/arm/cstart64.S
index e5a561ea2e39..ffdd49f73ddd 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -193,12 +193,35 @@ asm_mmu_enable:
=20
 	ret
=20
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
=20
 /*
diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
index a8c4628da818..1e1132dafd2b 100644
--- a/lib/arm/asm/processor.h
+++ b/lib/arm/asm/processor.h
@@ -9,6 +9,11 @@
 #include <asm/sysreg.h>
 #include <asm/barrier.h>
=20
+#define CTR_DMINLINE_SHIFT	16
+#define CTR_DMINLINE_MASK	(0xf << 16)
+#define CTR_DMINLINE(x)	\
+	(((x) & CTR_DMINLINE_MASK) >> CTR_DMINLINE_SHIFT)
+
 enum vector {
 	EXCPTN_RST,
 	EXCPTN_UND,
@@ -64,6 +69,7 @@ extern bool is_user(void);
=20
 #define CNTVCT		__ACCESS_CP15_64(1, c14)
 #define CNTFRQ		__ACCESS_CP15(c14, 0, c0, 0)
+#define CTR		__ACCESS_CP15(c0, 0, c0, 1)
=20
 static inline u64 get_cntvct(void)
 {
@@ -76,4 +82,11 @@ static inline u32 get_cntfrq(void)
 	return read_sysreg(CNTFRQ);
 }
=20
+static inline u32 get_ctr(void)
+{
+	return read_sysreg(CTR);
+}
+
+extern u32 dcache_line_size;
+
 #endif /* _ASMARM_PROCESSOR_H_ */
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 385e135f4865..418b4e58a5f8 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -20,6 +20,7 @@
 #include <asm/thread_info.h>
 #include <asm/setup.h>
 #include <asm/page.h>
+#include <asm/processor.h>
 #include <asm/smp.h>
=20
 #include "io.h"
@@ -38,6 +39,8 @@ static struct mem_region __initial_mem_regions[NR_INITI=
AL_MEM_REGIONS + 1];
 struct mem_region *mem_regions =3D __initial_mem_regions;
 phys_addr_t __phys_offset, __phys_end;
=20
+u32 dcache_line_size;
+
 int mpidr_to_cpu(uint64_t mpidr)
 {
 	int i;
@@ -66,6 +69,11 @@ static void cpu_init(void)
 	ret =3D dt_for_each_cpu_node(cpu_set, NULL);
 	assert(ret =3D=3D 0);
 	set_cpu_online(0, true);
+	/*
+	 * DminLine is log2 of the number of words in the smallest cache line; =
a
+	 * word is 4 bytes.
+	 */
+	dcache_line_size =3D 1 << (CTR_DMINLINE(get_ctr()) + 2);
 }
=20
 unsigned int mem_region_get_flags(phys_addr_t paddr)
diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 1d9223f728a5..02665b84cc7e 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -16,6 +16,11 @@
 #define SCTLR_EL1_A	(1 << 1)
 #define SCTLR_EL1_M	(1 << 0)
=20
+#define CTR_DMINLINE_SHIFT	16
+#define CTR_DMINLINE_MASK	(0xf << 16)
+#define CTR_DMINLINE(x)	\
+	(((x) & CTR_DMINLINE_MASK) >> CTR_DMINLINE_SHIFT)
+
 #ifndef __ASSEMBLY__
 #include <asm/ptrace.h>
 #include <asm/esr.h>
@@ -105,5 +110,12 @@ static inline u32 get_cntfrq(void)
 	return read_sysreg(cntfrq_el0);
 }
=20
+static inline u64 get_ctr(void)
+{
+	return read_sysreg(ctr_el0);
+}
+
+extern u32 dcache_line_size;
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM64_PROCESSOR_H_ */
--=20
2.21.1

