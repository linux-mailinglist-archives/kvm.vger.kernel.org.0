Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5183448BC
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 16:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbhCVPG5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 11:06:57 -0400
Received: from foss.arm.com ([217.140.110.172]:33504 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231641AbhCVPGX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 11:06:23 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 87DDB1396;
        Mon, 22 Mar 2021 08:06:22 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C952E3F719;
        Mon, 22 Mar 2021 08:06:21 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     andre.przywara@arm.com
Subject: [kvm-unit-tests PATCH v2 3/6] arm/arm64: Remove unnecessary ISB when doing dcache maintenance
Date:   Mon, 22 Mar 2021 15:06:38 +0000
Message-Id: <20210322150641.58878-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322150641.58878-1-alexandru.elisei@arm.com>
References: <20210322150641.58878-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The dcache_by_line_op macro executes a DSB to complete the cache
maintenance operations. According to ARM DDI 0487G.a, page B2-150:

"In addition, no instruction that appears in program order after the DSB
instruction can alter any state of the system or perform any part of its
functionality until the DSB completes other than:

- Being fetched from memory and decoded.
- Reading the general-purpose, SIMD and floating-point, Special-purpose, or
  System registers that are directly or indirectly read without causing
  side-effects."

Similar definition for ARM in ARM DDI 0406C.d, page A3-150:

"In addition, no instruction that appears in program order after the DSB
instruction can execute until the DSB completes."

This means that we don't need the ISB to prevent reordering of the cache
maintenance instructions.

We are also not doing icache maintenance, where an ISB would be required
for the PE to discard instructions speculated before the invalidation.

In conclusion, the ISB is unnecessary, so remove it.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/cstart.S   | 1 -
 arm/cstart64.S | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arm/cstart.S b/arm/cstart.S
index 954748b00f64..2d62c1e6d40d 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -212,7 +212,6 @@ asm_mmu_disable:
 	ldr	r1, [r1]
 	sub	r1, r1, r0
 	dcache_by_line_op dccimvac, sy, r0, r1, r2, r3
-	isb
 
 	mov     pc, lr
 
diff --git a/arm/cstart64.S b/arm/cstart64.S
index 046bd3914098..c1deff842f03 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -219,7 +219,6 @@ asm_mmu_disable:
 	ldr	x1, [x1, :lo12:__phys_end]
 	sub	x1, x1, x0
 	dcache_by_line_op civac, sy, x0, x1, x2, x3
-	isb
 
 	ret
 
-- 
2.31.0

