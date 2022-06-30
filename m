Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 457C2561719
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 12:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234729AbiF3KEN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 06:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234249AbiF3KEM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 06:04:12 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 847E943AEF
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 03:04:07 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8093B1042;
        Thu, 30 Jun 2022 03:04:07 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 513873F5A1;
        Thu, 30 Jun 2022 03:04:06 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>, andrew.jones@linux.dev,
        pbonzini@redhat.com, jade.alglave@arm.com,
        alexandru.elisei@arm.com, ricarkol@google.com
Subject: [kvm-unit-tests PATCH v3 15/27] arm/arm64: mmu_disable: Clean and invalidate before disabling
Date:   Thu, 30 Jun 2022 11:03:12 +0100
Message-Id: <20220630100324.3153655-16-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Andrew Jones <drjones@redhat.com>

The commit message of commit 410b3bf09e76 ("arm/arm64: Perform dcache
clean + invalidate after turning MMU off") justifies cleaning and
invalidating the dcache after disabling the MMU by saying it's nice
not to rely on the current page tables and that it should still work
(per the spec), as long as there's an identity map in the current
tables. Doing the invalidation after also somewhat helped with
reenabling the MMU without seeing stale data, but the real problem
with reenabling was because the cache needs to be disabled with
the MMU, but it wasn't.

Since we have to trust/validate that the current page tables have an
identity map anyway, then there's no harm in doing the clean
and invalidate first (it feels a little better to do so, anyway,
considering the cache maintenance instructions take virtual
addresses). Then, also disable the cache with the MMU to avoid
problems when reenabling. We invalidate the Icache and disable
that too for good measure. And, a final TLB invalidation ensures
we're crystal clean when we return from asm_mmu_disable().

Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 arm/cstart.S   | 28 +++++++++++++++++++++-------
 arm/cstart64.S | 21 ++++++++++++++++-----
 2 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/arm/cstart.S b/arm/cstart.S
index 7036e67..dc324c5 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -179,6 +179,7 @@ halt:
 .globl asm_mmu_enable
 asm_mmu_enable:
 	/* TLBIALL */
+	mov	r2, #0
 	mcr	p15, 0, r2, c8, c7, 0
 	dsb	nsh
 
@@ -211,12 +212,7 @@ asm_mmu_enable:
 
 .globl asm_mmu_disable
 asm_mmu_disable:
-	/* SCTLR */
-	mrc	p15, 0, r0, c1, c0, 0
-	bic	r0, #CR_M
-	mcr	p15, 0, r0, c1, c0, 0
-	isb
-
+	/* Clean + invalidate the entire memory */
 	ldr	r0, =__phys_offset
 	ldr	r0, [r0]
 	ldr	r1, =__phys_end
@@ -224,7 +220,25 @@ asm_mmu_disable:
 	sub	r1, r1, r0
 	dcache_by_line_op dccimvac, sy, r0, r1, r2, r3
 
-	mov     pc, lr
+	/* Invalidate Icache */
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c5, 0
+	isb
+
+	/*  Disable cache, Icache and MMU */
+	mrc	p15, 0, r0, c1, c0, 0
+	bic	r0, #CR_C
+	bic	r0, #CR_I
+	bic	r0, #CR_M
+	mcr	p15, 0, r0, c1, c0, 0
+	isb
+
+	/* Invalidate TLB */
+	mov	r0, #0
+	mcr	p15, 0, r0, c8, c7, 0
+	dsb	nsh
+
+	mov	pc, lr
 
 /*
  * Vectors
diff --git a/arm/cstart64.S b/arm/cstart64.S
index e4ab7d0..390feb9 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -246,11 +246,6 @@ asm_mmu_enable:
 
 .globl asm_mmu_disable
 asm_mmu_disable:
-	mrs	x0, sctlr_el1
-	bic	x0, x0, SCTLR_EL1_M
-	msr	sctlr_el1, x0
-	isb
-
 	/* Clean + invalidate the entire memory */
 	adrp	x0, __phys_offset
 	ldr	x0, [x0, :lo12:__phys_offset]
@@ -259,6 +254,22 @@ asm_mmu_disable:
 	sub	x1, x1, x0
 	dcache_by_line_op civac, sy, x0, x1, x2, x3
 
+	/* Invalidate Icache */
+	ic	iallu
+	isb
+
+	/* Disable cache, Icache and MMU */
+	mrs	x0, sctlr_el1
+	bic	x0, x0, SCTLR_EL1_C
+	bic	x0, x0, SCTLR_EL1_I
+	bic	x0, x0, SCTLR_EL1_M
+	msr	sctlr_el1, x0
+	isb
+
+	/* Invalidate TLB */
+	tlbi	vmalle1
+	dsb	nsh
+
 	ret
 
 /*
-- 
2.25.1

