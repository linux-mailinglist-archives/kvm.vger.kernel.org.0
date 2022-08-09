Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEFAC58D639
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 11:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241356AbiHIJQX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 05:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241267AbiHIJPz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 05:15:55 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CFE4F22534
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 02:15:51 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D392623A;
        Tue,  9 Aug 2022 02:15:51 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F232E3F67D;
        Tue,  9 Aug 2022 02:15:49 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        nikos.nikoleris@arm.com
Subject: [kvm-unit-tests RFC PATCH 17/19] arm/arm64: Configure secondaries' stack before enabling the MMU
Date:   Tue,  9 Aug 2022 10:15:56 +0100
Message-Id: <20220809091558.14379-18-alexandru.elisei@arm.com>
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

Now that the secondaries' stack is linearly mapped, we can set it before
turning the MMU on. This makes the entry code for the secondaries
consistent with the entry code for the boot CPU.

To keep it simple, the struct secondary_data, which is now read with the
MMU off by the secondaries, is cleaned to PoC.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/cstart.S   | 20 ++++++++++----------
 arm/cstart64.S | 16 ++++++++--------
 lib/arm/smp.c  |  5 +++++
 3 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/arm/cstart.S b/arm/cstart.S
index 096a77c454f4..877559b367de 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -134,16 +134,6 @@ get_mmu_off:
 
 .global secondary_entry
 secondary_entry:
-	/* enable the MMU unless requested off */
-	bl	get_mmu_off
-	cmp	r0, #0
-	bne	1f
-	mov	r1, #0
-	ldr	r0, =mmu_idmap
-	ldr	r0, [r0]
-	bl	asm_mmu_enable
-
-1:
 	/*
 	 * Set the stack, and set up vector table
 	 * and exception stacks. Exception stacks
@@ -161,6 +151,16 @@ secondary_entry:
 	bl	exceptions_init
 	bl	enable_vfp
 
+	/* enable the MMU unless requested off */
+	bl	get_mmu_off
+	cmp	r0, #0
+	bne	1f
+	mov	r1, #0
+	ldr	r0, =mmu_idmap
+	ldr	r0, [r0]
+	bl	asm_mmu_enable
+
+1:
 	/* finish init in C code */
 	bl	secondary_cinit
 
diff --git a/arm/cstart64.S b/arm/cstart64.S
index 7cc90a9fa13f..face185a7781 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -138,6 +138,14 @@ get_mmu_off:
 
 .globl secondary_entry
 secondary_entry:
+	/* set the stack */
+	adrp	x0, secondary_data
+	ldr	x0, [x0, :lo12:secondary_data]
+	and	x1, x0, #THREAD_MASK
+	add	x2, x1, #THREAD_SIZE
+	zero_range x1, x2
+	mov	sp, x0
+
 	/* Enable FP/ASIMD */
 	mov	x0, #(3 << 20)
 	msr	cpacr_el1, x0
@@ -153,14 +161,6 @@ secondary_entry:
 	bl	asm_mmu_enable
 
 1:
-	/* set the stack */
-	adrp	x0, secondary_data
-	ldr	x0, [x0, :lo12:secondary_data]
-	and	x1, x0, #THREAD_MASK
-	add	x2, x1, #THREAD_SIZE
-	zero_range x1, x2
-	mov	sp, x0
-
 	/* finish init in C code */
 	bl	secondary_cinit
 
diff --git a/lib/arm/smp.c b/lib/arm/smp.c
index 89e44a172c15..9c49bc3dec61 100644
--- a/lib/arm/smp.c
+++ b/lib/arm/smp.c
@@ -7,6 +7,8 @@
  */
 #include <libcflat.h>
 #include <auxinfo.h>
+
+#include <asm/cacheflush.h>
 #include <asm/thread_info.h>
 #include <asm/spinlock.h>
 #include <asm/cpumask.h>
@@ -62,6 +64,9 @@ static void __smp_boot_secondary(int cpu, secondary_entry_fn entry)
 
 	secondary_data.stack = thread_stack_alloc();
 	secondary_data.entry = entry;
+	dcache_clean_poc((unsigned long)&secondary_data,
+			 (unsigned long)&secondary_data + sizeof(secondary_data));
+
 	mmu_mark_disabled(cpu);
 	ret = cpu_psci_cpu_boot(cpu);
 	assert(ret == 0);
-- 
2.37.1

