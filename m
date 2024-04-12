Return-Path: <kvm+bounces-14498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B0738A2C6F
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 12:35:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 41A231F22C53
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:35:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86F1C55C22;
	Fri, 12 Apr 2024 10:34:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDBCC42AA2
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 10:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918085; cv=none; b=bG2Vfh5gXiWbu7DMLmsPNKcW0aKS+qcWhamnO0M7HV47GKqrMwq8FM6bdTzwunfVZywsoIw3k7/9gLqQmrP4lONqXwOtw1D5YavT/LD+H4T08nwGFvFMiV4W6owuB+p8Tu4Yv9WjzoUrCOp183RolcY66gZTbYU3a/6wdw30OWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918085; c=relaxed/simple;
	bh=ym9tyRc8+coM5vVVIInNC1J6oXuObJTYcdmaaptsEBE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AI8twH9z0Ut07Z+7HyyJ1dWoVfajG6p/+vH3eKF8bGcTw6GseuZOYuoMrGDeHIce6BAPL1tTgAmRkE5nmPPIwqzUsB5/rJ7I6TbF1sAQnz0a+tPlX+s6Y3XGHx6Pbniq5ywcRzwpo+Sd9nO65qLrynM5dTyFW3x/JJ1I1PE09FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 733281596;
	Fri, 12 Apr 2024 03:35:12 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6276C3F64C;
	Fri, 12 Apr 2024 03:34:41 -0700 (PDT)
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
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [kvm-unit-tests PATCH 12/33] arm: realm: Early memory setup
Date: Fri, 12 Apr 2024 11:33:47 +0100
Message-Id: <20240412103408.2706058-13-suzuki.poulose@arm.com>
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

A Realm must mark areas of memory as RIPAS_RAM before an access is made.

The binary image is loaded by the VMM and thus the area is converted.
However, the file image may not cover tail portion of the "memory" image (e.g,
BSS, stack etc.). Convert the area touched by the early boot code to RAM
before the access is made in early assembly code.

Once, we land in the C code, we take care of converting the entire RAM region
to RIPAS_RAM.

Please note that this operation doesn't require the host to commit memory to
the Realm.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Co-developed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Co-developed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/cstart64.S | 94 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 94 insertions(+)

diff --git a/arm/cstart64.S b/arm/cstart64.S
index 734b2286..92631349 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -14,6 +14,7 @@
 #include <asm/pgtable-hwdef.h>
 #include <asm/thread_info.h>
 #include <asm/sysreg.h>
+#include <asm/smc-rsi.h>
 
 #ifdef CONFIG_EFI
 #include "efi/crt0-efi-aarch64.S"
@@ -65,6 +66,11 @@ start:
 	b	1b
 
 1:
+	/*
+	 * For a Realm, before we touch any memory, we must
+	 * make sure it is in the RsiRipas == RSI_RAM state.
+	 */
+	bl	__early_mem_setup
 	/* zero BSS */
 	adrp	x4, bss
 	add	x4, x4, :lo12:bss
@@ -176,6 +182,94 @@ arm_smccc_hvc:
 arm_smccc_smc:
 	do_smccc_call smc
 
+__early_mem_setup:
+	/* Preserve x0 - x3 */
+	mov	x5, x0
+	mov	x6, x1
+	mov	x7, x2
+	mov	x8, x3
+
+	/*
+	 * Check for EL3, otherwise an SMC instruction
+	 * will cause an UNDEFINED exception.
+	 */
+	mrs	x9, ID_AA64PFR0_EL1
+	lsr	x9, x9, #12
+	and	x9, x9, 0b11
+	cbnz	x9, 1f
+	ret
+
+1:
+	/*
+	 * Are we a realm? Request the RSI ABI version.
+	 * If KVM is catching SMCs, it returns an error in x0 (~0UL)
+	 */
+	movz	x0, :abs_g2_s:SMC_RSI_ABI_VERSION
+	movk	x0, :abs_g1_nc:SMC_RSI_ABI_VERSION
+	movk	x0, :abs_g0_nc:SMC_RSI_ABI_VERSION
+	ldr	x1, =RSI_ABI_VERSION
+	smc	#0
+
+	/*
+	 * RMM if present, returns RSI_SUCCESS if the requested
+	 * version is compatible. Otherwise returns RSI_ERROR_INPUT,
+	 * which is fatal for the Realm.
+	 */
+	cmp	x0, #RSI_ERROR_INPUT
+	beq	halt
+
+	/*
+	 * Anything other than RSI_SUCCESS or RSI_ERROR_INPUT
+	 * indicates, RMM is not present.
+	 */
+	cmp	x0, #RSI_SUCCESS
+	bne	3f
+
+	/*
+	 * For realms, we must mark area from bss
+	 * to the end of stack as memory before it is
+	 * accessed, as they are not populated as part
+	 * of the initial image. As such we can run
+	 * this unconditionally irrespective of whether
+	 * we are a normal VM or Realm.
+	 */
+	/* x1 = bss */
+	adrp	x1, bss
+
+	/* x7 = SMC_RSI_IPA_STATE_SET */
+	movz	x7, :abs_g2_s:SMC_RSI_IPA_STATE_SET
+	movk	x7, :abs_g1_nc:SMC_RSI_IPA_STATE_SET
+	movk	x7, :abs_g0_nc:SMC_RSI_IPA_STATE_SET
+
+	/* x9 = (end of stack) */
+	adrp	x9, (stacktop + PAGE_SIZE)
+2:
+	/* x2 = (end of stack) */
+	mov	x2, x9
+
+	/* x3 = RIPAS_RAM */
+	mov	x3, #1
+	/* x4 = RSI_NO_CHANGE_DESTROYED */
+	mov	x4, #RSI_NO_CHANGE_DESTROYED
+
+	/* x0 = SMC_RSI_IPA_STATE_SET */
+	mov	x0, x7
+	/* Run the RSI request */
+	smc	#0
+
+	/* halt if there is an error */
+	cbnz x0, halt
+
+	/* Check if (next == end of stack) */
+	cmp x1, x9
+	bne 2b
+3:
+	mov	x3, x8
+	mov	x2, x7
+	mov	x1, x6
+	mov	x0, x5
+	ret
+
 get_mmu_off:
 	adrp	x0, auxinfo
 	ldr	x0, [x0, :lo12:auxinfo + 8]
-- 
2.34.1


