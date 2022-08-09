Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5390E58D634
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 11:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239370AbiHIJQN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 05:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239133AbiHIJPu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 05:15:50 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 69BC822BE6
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 02:15:44 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D8F431477;
        Tue,  9 Aug 2022 02:15:44 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 02C813F67D;
        Tue,  9 Aug 2022 02:15:42 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        nikos.nikoleris@arm.com
Subject: [kvm-unit-tests RFC PATCH 12/19] arm/arm64: assembler.h: Replace size with end address for dcache_by_line_op
Date:   Tue,  9 Aug 2022 10:15:51 +0100
Message-Id: <20220809091558.14379-13-alexandru.elisei@arm.com>
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

Commit b5f659be4775 ("arm/arm64: Remove dcache_line_size global
variable") moved the dcache_by_line_op macro to assembler.h and changed
it to take the size of the regions instead of the end address as
parameter. This was done to keep the file in sync with the upstream
Linux kernel implementation at the time.

But in both places where the macro is used, the code has the start and
end address of the region, and it has to compute the size to pass it to
dcache_by_line_op. Then the macro itsef computes the end by adding size
to start.

Get rid of this massaging of parameters and change the macro to the end
address as parameter directly.

Besides slightly simplyfing the code by remove two unneeded arithmetic
operations, this makes the macro compatible with the current upstream
version of Linux (which was similarly changed to take the end address in
commit 163d3f80695e ("arm64: dcache_by_line_op to take end parameter
instead of size")), which will allow us to reuse (part of) the Linux C
wrappers over the assembly macro.

The change has been tested with the same snippet of code used to test
commit 410b3bf09e76 ("arm/arm64: Perform dcache clean + invalidate after
turning MMU off").

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/cstart.S              |  1 -
 arm/cstart64.S            |  1 -
 lib/arm/asm/assembler.h   | 11 +++++------
 lib/arm64/asm/assembler.h | 11 +++++------
 4 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/arm/cstart.S b/arm/cstart.S
index 39e70f40986a..096a77c454f4 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -226,7 +226,6 @@ asm_mmu_disable:
 	ldr	r0, [r0]
 	ldr	r1, =__phys_end
 	ldr	r1, [r1]
-	sub	r1, r1, r0
 	dcache_by_line_op dccimvac, sy, r0, r1, r2, r3
 
 	mov     pc, lr
diff --git a/arm/cstart64.S b/arm/cstart64.S
index 54773676d1d5..7cc90a9fa13f 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -258,7 +258,6 @@ asm_mmu_disable:
 	ldr	x0, [x0, :lo12:__phys_offset]
 	adrp	x1, __phys_end
 	ldr	x1, [x1, :lo12:__phys_end]
-	sub	x1, x1, x0
 	dcache_by_line_op civac, sy, x0, x1, x2, x3
 
 	ret
diff --git a/lib/arm/asm/assembler.h b/lib/arm/asm/assembler.h
index 4200252dd14d..db5f0f55027c 100644
--- a/lib/arm/asm/assembler.h
+++ b/lib/arm/asm/assembler.h
@@ -25,17 +25,16 @@
 
 /*
  * Macro to perform a data cache maintenance for the interval
- * [addr, addr + size).
+ * [addr, end).
  *
  * 	op:		operation to execute
  * 	domain		domain used in the dsb instruction
  * 	addr:		starting virtual address of the region
- * 	size:		size of the region
- * 	Corrupts:	addr, size, tmp1, tmp2
+ * 	end:		the end of the region (non-inclusive)
+ * 	Corrupts:	addr, tmp1, tmp2
  */
-	.macro dcache_by_line_op op, domain, addr, size, tmp1, tmp2
+	.macro dcache_by_line_op op, domain, addr, end, tmp1, tmp2
 	dcache_line_size \tmp1, \tmp2
-	add	\size, \addr, \size
 	sub	\tmp2, \tmp1, #1
 	bic	\addr, \addr, \tmp2
 9998:
@@ -45,7 +44,7 @@
 	.err
 	.endif
 	add	\addr, \addr, \tmp1
-	cmp	\addr, \size
+	cmp	\addr, \end
 	blo	9998b
 	dsb	\domain
 	.endm
diff --git a/lib/arm64/asm/assembler.h b/lib/arm64/asm/assembler.h
index aa8c65a2bb4a..1e09d65af4a7 100644
--- a/lib/arm64/asm/assembler.h
+++ b/lib/arm64/asm/assembler.h
@@ -28,25 +28,24 @@
 
 /*
  * Macro to perform a data cache maintenance for the interval
- * [addr, addr + size). Use the raw value for the dcache line size because
+ * [addr, end). Use the raw value for the dcache line size because
  * kvm-unit-tests has no concept of scheduling.
  *
  * 	op:		operation passed to dc instruction
  * 	domain:		domain used in dsb instruction
  * 	addr:		starting virtual address of the region
- * 	size:		size of the region
- * 	Corrupts:	addr, size, tmp1, tmp2
+ * 	end:		the end of the region (non-inclusive)
+ * 	Corrupts:	addr, tmp1, tmp2
  */
 
-	.macro dcache_by_line_op op, domain, addr, size, tmp1, tmp2
+	.macro dcache_by_line_op op, domain, addr, end, tmp1, tmp2
 	raw_dcache_line_size \tmp1, \tmp2
-	add	\size, \addr, \size
 	sub	\tmp2, \tmp1, #1
 	bic	\addr, \addr, \tmp2
 9998:
 	dc	\op, \addr
 	add	\addr, \addr, \tmp1
-	cmp	\addr, \size
+	cmp	\addr, \end
 	b.lo	9998b
 	dsb	\domain
 	.endm
-- 
2.37.1

