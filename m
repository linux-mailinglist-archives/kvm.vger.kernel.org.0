Return-Path: <kvm+bounces-58775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DAD93B9FFE4
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 16:28:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D32A4C6E04
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 14:26:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE0472D2382;
	Thu, 25 Sep 2025 14:25:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0C492D0601
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 14:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758810323; cv=none; b=dhhn2uUmru+yn9qaz26ngW9/qHeuGtYiSSajXd22srHZ4Egj96u5T8Evw8n0DJxrkts3s0wWCSxNhnhIhKm4RfFNidLaCxK3ZaN0FjMZN2LOqVmPhDinXdbi4XElzMDkl1lWYsTbkQVOtkw8Dj1BmMUAkkelo6SPmxe6SnqCHM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758810323; c=relaxed/simple;
	bh=vTP31bU0bPLbbiW8AcLdowom+UvYABpY5+NzS2CHCoQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Y8+sAEkelM4x7gorCAnG2z7znNJ01wYV250P0H3wedi/5rktQk0LeaZDN++gpyHYrD7TdXAbL8hiZygqVUTCQKpPS5Z3UTKCjX9h+kb0Ti0azB88ki4r8f3vgE2B6pVmOfA4PWorNfV+gvgj1XEkD57evq2pmkisK1YGkmq/xlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A7A341E5E;
	Thu, 25 Sep 2025 07:25:13 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7A0933F694;
	Thu, 25 Sep 2025 07:25:20 -0700 (PDT)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	andrew.jones@linux.dev,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v3 09/10] arm64: run at EL2 if supported
Date: Thu, 25 Sep 2025 15:19:57 +0100
Message-Id: <20250925141958.468311-10-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250925141958.468311-1-joey.gouly@arm.com>
References: <20250925141958.468311-1-joey.gouly@arm.com>
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
---
 arm/cstart64.S         | 17 +++++++++++++----
 lib/arm64/asm/sysreg.h |  5 +++++
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arm/cstart64.S b/arm/cstart64.S
index 79b93dd4..af7c81c1 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -18,7 +18,7 @@
 .macro init_el, tmp
 	mrs	\tmp, CurrentEL
 	cmp	\tmp, CurrentEL_EL2
-	b.ne	1f
+	b.ne	2f
 	/* EL2 setup */
 	mrs	\tmp, mpidr_el1
 	msr	vmpidr_el2, \tmp
@@ -41,17 +41,26 @@
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


