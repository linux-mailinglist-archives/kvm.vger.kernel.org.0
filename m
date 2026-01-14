Return-Path: <kvm+bounces-68027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 89FB1D1E9B5
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 13:00:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 263EC3078944
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 11:59:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA674396B86;
	Wed, 14 Jan 2026 11:59:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A5A2389E1A
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 11:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768391943; cv=none; b=Ai3gL2wptZEgW3vqRyCnd7nmkayjZ03BnV7BUmryJVHf4DiFvR9CCW2ezEDxJlxo5xX142nUcZj70Sd76IE1YCbH6f5wwA5M8gSnsQfDH+uUpdsKY0a2qL2zIRC2dBOSGE6G+pJWHu1nmPKT1giZaEqP9X+1d7T7pfWY4V6axlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768391943; c=relaxed/simple;
	bh=s0M/sSyTqAkSyLV5sUqkTDP/QBn2D28VCgAkL5NG6Lg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZpBLmJD+yxQJzGkGnBUrizYdmCVADbxHbwiicWOyM2hjHUnwPhZrDgrr6SCeDQeJWfhnYlSoVvtC31L/HOLKQv76CNomcm1OmuXaVK3ld8nOO5GPPehmumOUrDfax6cfDJDGJMzYeshiZV6xV2BuwxSzC21F3P2ruXZQJPd54vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 437CA1424;
	Wed, 14 Jan 2026 03:58:53 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B95203F632;
	Wed, 14 Jan 2026 03:58:58 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	joey.gouly@arm.com,
	maz@kernel.org,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v5 10/11] arm64: run at EL2 if supported
Date: Wed, 14 Jan 2026 11:57:02 +0000
Message-Id: <20260114115703.926685-11-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260114115703.926685-1-joey.gouly@arm.com>
References: <20260114115703.926685-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If VHE is supported, continue booting at EL2, otherwise continue booting at
EL1.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 arm/cstart64.S         | 21 +++++++++++++++++----
 lib/arm64/asm/sysreg.h |  5 +++++
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/arm/cstart64.S b/arm/cstart64.S
index 2b93f234..49cf8ed6 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -15,10 +15,14 @@
 #include <asm/thread_info.h>
 #include <asm/sysreg.h>
 
+/*
+ * Initialise the EL used for running the tests.
+ * If started at EL2 and VHE is supported, EL2 is used, otherwise EL1 is used.
+ */
 .macro init_el, tmp
 	mrs	\tmp, CurrentEL
 	cmp	\tmp, CurrentEL_EL2
-	b.ne	1f
+	b.ne	2f
 	/* EL2 setup */
 	mrs	\tmp, mpidr_el1
 	msr	vmpidr_el2, \tmp
@@ -41,17 +45,26 @@
 	msr_s	SYS_HFGWTR2_EL2, \tmp
 	msr_s	SYS_HFGITR2_EL2, \tmp
 .Lskip_fgt_\@:
+	/* check VHE is supported */
+	mrs	\tmp, ID_AA64MMFR1_EL1
+	ubfx	\tmp, \tmp, ID_AA64MMFR1_EL1_VH_SHIFT, #4
+	cbz	\tmp, 1f
+	ldr	\tmp, =(INIT_HCR_EL2)
+	msr	hcr_el2, \tmp
+	isb
+	b	2f
+1:
 	mov	\tmp, #0
 	msr	cptr_el2, \tmp
 	ldr	\tmp, =(INIT_HCR_EL2_EL1_ONLY)
 	msr	hcr_el2, \tmp
 	mov	\tmp, PSR_MODE_EL1t
 	msr	spsr_el2, \tmp
-	adrp	\tmp, 1f
-	add	\tmp, \tmp, :lo12:1f
+	adrp	\tmp, 2f
+	add	\tmp, \tmp, :lo12:2f
 	msr	elr_el2, \tmp
 	eret
-1:
+2:
 .endm
 
 
diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
index ed776716..f2d05018 100644
--- a/lib/arm64/asm/sysreg.h
+++ b/lib/arm64/asm/sysreg.h
@@ -80,6 +80,8 @@ asm(
 #define ID_AA64MMFR0_EL1_FGT_SHIFT	56
 #define ID_AA64MMFR0_EL1_FGT_FGT2	0x2
 
+#define ID_AA64MMFR1_EL1_VH_SHIFT	8
+
 #define ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
 #define ICC_SGI1R_EL1			sys_reg(3, 0, 12, 11, 5)
 #define ICC_IAR1_EL1			sys_reg(3, 0, 12, 12, 0)
@@ -116,9 +118,12 @@ asm(
 #define SCTLR_EL1_TCF0_SHIFT	38
 #define SCTLR_EL1_TCF0_MASK	GENMASK_ULL(39, 38)
 
+#define HCR_EL2_TGE		_BITULL(27)
 #define HCR_EL2_RW		_BITULL(31)
+#define HCR_EL2_E2H		_BITULL(34)
 
 #define INIT_HCR_EL2_EL1_ONLY	(HCR_EL2_RW)
+#define INIT_HCR_EL2		(HCR_EL2_TGE | HCR_EL2_E2H | HCR_EL2_RW)
 
 #define SYS_HFGRTR_EL2		sys_reg(3, 4, 1, 1, 4)
 #define SYS_HFGWTR_EL2		sys_reg(3, 4, 1, 1, 5)
-- 
2.25.1


