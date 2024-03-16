Return-Path: <kvm+bounces-11953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6894787D790
	for <lists+kvm@lfdr.de>; Sat, 16 Mar 2024 01:25:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B1FD1B2135D
	for <lists+kvm@lfdr.de>; Sat, 16 Mar 2024 00:25:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C093800;
	Sat, 16 Mar 2024 00:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="K4Sjn2ip"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4241D37E
	for <kvm@vger.kernel.org>; Sat, 16 Mar 2024 00:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710548715; cv=none; b=qTMl+dBfac726so+L+fCmg/lC2B7bLu0lEE1jv97aRQDcINdKL8n9WGR84f624fz2VkkHxnCsVTGdJKn6uKQsXbQk8tzugdgMy65QKChTpEIvK+ekPMIxOM8K+lvDQS2MdYfOboOFJ1hH7tvXh0vZCFc/kDa1AL6Sd/ewjlg4Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710548715; c=relaxed/simple;
	bh=nvkb0nJYfnboMjaj3vhD7XClN0dbH8h/0TpD6qkFGRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ojPwT4IsiEIBdBvSy/x2RnGz2yhAxlv//EBaXF8qHcN7Bj/pajCU2qdIbZOvuaKvAwcSbbWWOA5O/7/T4n2t68nnKlsdAQTP8FQWX20+6NlHsrwCQuY/K9Yxn7Uo1CMlppg5AEPz9r9xJ5JzPuONzRgr+TnFBnGbsODMltx3Sx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=K4Sjn2ip; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1710548710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sPnnyEo95xt0JAPxsFCKGxl0/IetI9+J6kh5T3jJu94=;
	b=K4Sjn2ip2jvTUcOAfYXBs2omBFrnKfkOfP3qLsW+Hk8iIIwbGscu6IsceiahLhLlhHOuw/
	jYfWjtwc4MOGCJdeGUlrIuaIyf/2kuO5mUy04EkDj8Qg8jSsUQYPcJAjv4uMqC9fni1VgQ
	28hv+AGw+g+gF30PDivenigYqwznLFQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] Revert "KVM: arm64: Snapshot all non-zero RES0/RES1 sysreg fields for later checking"
Date: Sat, 16 Mar 2024 00:24:57 +0000
Message-ID: <20240316002457.3568887-1-oliver.upton@linux.dev>
In-Reply-To: <CAHk-=whCvkhc8BbFOUf1ddOsgSGgEjwoKv77=HEY1UiVCydGqw@mail.gmail.com>
References: <CAHk-=whCvkhc8BbFOUf1ddOsgSGgEjwoKv77=HEY1UiVCydGqw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This reverts commits 99101dda29e3186b1356b0dc4dbb835c02c71ac9 and
b80b701d5a67d07f4df4a21e09cb31f6bc1feeca.

Linus reports that the sysreg reserved bit checks in KVM have led to
build failures, arising from commit fdd867fe9b32 ("arm64/sysreg: Add
register fields for ID_AA64DFR1_EL1") giving meaning to fields that were
previously RES0.

Of course, this is a genuine issue, since KVM's sysreg emulation depends
heavily on the definition of reserved fields. But at this point the
build breakage is far more offensive, and the right course of action is
to revert and retry later.

All of these build-time assertions were on by default before
commit 99101dda29e3 ("KVM: arm64: Make build-time check of RES0/RES1
bits optional"), so deliberately revert it all atomically to avoid
introducing further breakage of bisection.

Link: https://lore.kernel.org/all/CAHk-=whCvkhc8BbFOUf1ddOsgSGgEjwoKv77=HEY1UiVCydGqw@mail.gmail.com/
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---

Marc is traveling now, but he asked to add his Ack over text.

 arch/arm64/kvm/Kconfig          |  11 ---
 arch/arm64/kvm/check-res-bits.h | 125 --------------------------------
 arch/arm64/kvm/sys_regs.c       |   3 -
 3 files changed, 139 deletions(-)
 delete mode 100644 arch/arm64/kvm/check-res-bits.h

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 937f15b7d8c3..58f09370d17e 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -65,15 +65,4 @@ config PROTECTED_NVHE_STACKTRACE
 
 	  If unsure, or not using protected nVHE (pKVM), say N.
 
-config KVM_ARM64_RES_BITS_PARANOIA
-	bool "Build-time check of RES0/RES1 bits"
-	depends on KVM
-	default n
-	help
-	  Say Y here to validate that KVM's knowledge of most system
-	  registers' RES0/RES1 bits matches when the rest of the kernel
-	  defines. Expect the build to fail badly if you enable this.
-
-	  Just say N.
-
 endif # VIRTUALIZATION
diff --git a/arch/arm64/kvm/check-res-bits.h b/arch/arm64/kvm/check-res-bits.h
deleted file mode 100644
index 2d98e60efc3c..000000000000
--- a/arch/arm64/kvm/check-res-bits.h
+++ /dev/null
@@ -1,125 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Copyright (C) 2024 - Google LLC
- * Author: Marc Zyngier <maz@kernel.org>
- */
-
-#include <asm/sysreg-defs.h>
-
-/*
- * WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING
- *
- * If any of these BUILD_BUG_ON() fails, that's because some bits that
- * were reserved have gained some other meaning, and KVM needs to know
- * about those.
- *
- * In such case, do *NOT* blindly change the assertion so that it
- * passes, but also teach the rest of the code about the actual
- * change.
- *
- * WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING
- */
-static inline void check_res_bits(void)
-{
-#ifdef CONFIG_KVM_ARM64_RES_BITS_PARANOIA
-
-	BUILD_BUG_ON(OSDTRRX_EL1_RES0		!= (GENMASK_ULL(63, 32)));
-	BUILD_BUG_ON(MDCCINT_EL1_RES0		!= (GENMASK_ULL(63, 31) | GENMASK_ULL(28, 0)));
-	BUILD_BUG_ON(MDSCR_EL1_RES0		!= (GENMASK_ULL(63, 36) | GENMASK_ULL(28, 28) | GENMASK_ULL(25, 24) | GENMASK_ULL(20, 20) | GENMASK_ULL(18, 16) | GENMASK_ULL(11, 7) | GENMASK_ULL(5, 1)));
-	BUILD_BUG_ON(OSDTRTX_EL1_RES0		!= (GENMASK_ULL(63, 32)));
-	BUILD_BUG_ON(OSECCR_EL1_RES0		!= (GENMASK_ULL(63, 32)));
-	BUILD_BUG_ON(OSLAR_EL1_RES0		!= (GENMASK_ULL(63, 1)));
-	BUILD_BUG_ON(ID_PFR0_EL1_RES0		!= (GENMASK_ULL(63, 32)));
-	BUILD_BUG_ON(ID_PFR1_EL1_RES0		!= (GENMASK_ULL(63, 32)));
-	BUILD_BUG_ON(ID_DFR0_EL1_RES0		!= (GENMASK_ULL(63, 32)));
-	BUILD_BUG_ON(ID_AFR0_EL1_RES0		!= (GENMASK_ULL(63, 16)));
-	BUILD_BUG_ON(ID_MMFR0_EL1_RES0		!= (GENMASK_ULL(63, 32)));
-	BUILD_BUG_ON(ID_MMFR1_EL1_RES0		!= (GENMASK_ULL(63, 32)));
-	BUILD_BUG_ON(ID_MMFR2_EL1_RES0		!= (GENMASK_ULL(63, 32)));
-	BUILD_BUG_ON(ID_MMFR3_EL1_RES0		!= (GENMASK_ULL(63, 32)));
-	BUILD_BUG_ON(ID_ISAR0_EL1_RES0		!= (GENMASK_ULL(63, 28)));
-	BUILD_BUG_ON(ID_ISAR1_EL1_RES0		!= (GENMASK_ULL(63, 32)));
-	BUILD_BUG_ON(ID_ISAR2_EL1_RES0		!= (GENMASK_ULL(63, 32)));
-	BUILD_BUG_ON(ID_ISAR3_EL1_RES0		!= (GENMASK_ULL(63, 32)));
-	BUILD_BUG_ON(ID_ISAR4_EL1_RES0		!= (GENMASK_ULL(63, 32)));
-	BUILD_BUG_ON(ID_ISAR5_EL1_RES0		!= (GENMASK_ULL(63, 32) | GENMASK_ULL(23, 20)));
-	BUILD_BUG_ON(ID_ISAR6_EL1_RES0		!= (GENMASK_ULL(63, 28)));
-	BUILD_BUG_ON(ID_MMFR4_EL1_RES0		!= (GENMASK_ULL(63, 32)));
-	BUILD_BUG_ON(MVFR0_EL1_RES0		!= (GENMASK_ULL(63, 32)));
-	BUILD_BUG_ON(MVFR1_EL1_RES0		!= (GENMASK_ULL(63, 32)));
-	BUILD_BUG_ON(MVFR2_EL1_RES0		!= (GENMASK_ULL(63, 8)));
-	BUILD_BUG_ON(ID_PFR2_EL1_RES0		!= (GENMASK_ULL(63, 12)));
-	BUILD_BUG_ON(ID_DFR1_EL1_RES0		!= (GENMASK_ULL(63, 8)));
-	BUILD_BUG_ON(ID_MMFR5_EL1_RES0		!= (GENMASK_ULL(63, 8)));
-	BUILD_BUG_ON(ID_AA64PFR1_EL1_RES0	!= (GENMASK_ULL(23, 20)));
-	BUILD_BUG_ON(ID_AA64PFR2_EL1_RES0	!= (GENMASK_ULL(63, 36) | GENMASK_ULL(31, 12)));
-	BUILD_BUG_ON(ID_AA64ZFR0_EL1_RES0	!= (GENMASK_ULL(63, 60) | GENMASK_ULL(51, 48) | GENMASK_ULL(39, 36) | GENMASK_ULL(31, 28) | GENMASK_ULL(15, 8)));
-	BUILD_BUG_ON(ID_AA64SMFR0_EL1_RES0	!= (GENMASK_ULL(62, 61) | GENMASK_ULL(51, 49) | GENMASK_ULL(31, 31) | GENMASK_ULL(27, 0)));
-	BUILD_BUG_ON(ID_AA64FPFR0_EL1_RES0	!= (GENMASK_ULL(63, 32) | GENMASK_ULL(27, 2)));
-	BUILD_BUG_ON(ID_AA64DFR0_EL1_RES0	!= (GENMASK_ULL(27, 24) | GENMASK_ULL(19, 16)));
-	BUILD_BUG_ON(ID_AA64DFR1_EL1_RES0	!= (GENMASK_ULL(63, 0)));
-	BUILD_BUG_ON(ID_AA64AFR0_EL1_RES0	!= (GENMASK_ULL(63, 32)));
-	BUILD_BUG_ON(ID_AA64AFR1_EL1_RES0	!= (GENMASK_ULL(63, 0)));
-	BUILD_BUG_ON(ID_AA64ISAR0_EL1_RES0	!= (GENMASK_ULL(3, 0)));
-	BUILD_BUG_ON(ID_AA64ISAR2_EL1_RES0	!= (GENMASK_ULL(47, 44)));
-	BUILD_BUG_ON(ID_AA64ISAR3_EL1_RES0	!= (GENMASK_ULL(63, 16)));
-	BUILD_BUG_ON(ID_AA64MMFR0_EL1_RES0	!= (GENMASK_ULL(55, 48)));
-	BUILD_BUG_ON(ID_AA64MMFR2_EL1_RES0	!= (GENMASK_ULL(47, 44)));
-	BUILD_BUG_ON(ID_AA64MMFR3_EL1_RES0	!= (GENMASK_ULL(51, 48)));
-	BUILD_BUG_ON(ID_AA64MMFR4_EL1_RES0	!= (GENMASK_ULL(63, 40) | GENMASK_ULL(35, 28) | GENMASK_ULL(3, 0)));
-	BUILD_BUG_ON(SCTLR_EL1_RES0		!= (GENMASK_ULL(17, 17)));
-	BUILD_BUG_ON(CPACR_ELx_RES0		!= (GENMASK_ULL(63, 30) | GENMASK_ULL(27, 26) | GENMASK_ULL(23, 22) | GENMASK_ULL(19, 18) | GENMASK_ULL(15, 0)));
-	BUILD_BUG_ON(SMPRI_EL1_RES0		!= (GENMASK_ULL(63, 4)));
-	BUILD_BUG_ON(ZCR_ELx_RES0		!= (GENMASK_ULL(63, 9)));
-	BUILD_BUG_ON(SMCR_ELx_RES0		!= (GENMASK_ULL(63, 32) | GENMASK_ULL(29, 9)));
-	BUILD_BUG_ON(GCSCR_ELx_RES0		!= (GENMASK_ULL(63, 10) | GENMASK_ULL(7, 7) | GENMASK_ULL(4, 1)));
-	BUILD_BUG_ON(GCSPR_ELx_RES0		!= (GENMASK_ULL(2, 0)));
-	BUILD_BUG_ON(GCSCRE0_EL1_RES0		!= (GENMASK_ULL(63, 11) | GENMASK_ULL(7, 6) | GENMASK_ULL(4, 1)));
-	BUILD_BUG_ON(ALLINT_RES0		!= (GENMASK_ULL(63, 14) | GENMASK_ULL(12, 0)));
-	BUILD_BUG_ON(PMSCR_EL1_RES0		!= (GENMASK_ULL(63, 8) | GENMASK_ULL(2, 2)));
-	BUILD_BUG_ON(PMSICR_EL1_RES0		!= (GENMASK_ULL(55, 32)));
-	BUILD_BUG_ON(PMSIRR_EL1_RES0		!= (GENMASK_ULL(63, 32) | GENMASK_ULL(7, 1)));
-	BUILD_BUG_ON(PMSFCR_EL1_RES0		!= (GENMASK_ULL(63, 19) | GENMASK_ULL(15, 4)));
-	BUILD_BUG_ON(PMSLATFR_EL1_RES0		!= (GENMASK_ULL(63, 16)));
-	BUILD_BUG_ON(PMSIDR_EL1_RES0		!= (GENMASK_ULL(63, 25) | GENMASK_ULL(7, 7)));
-	BUILD_BUG_ON(PMBLIMITR_EL1_RES0		!= (GENMASK_ULL(11, 6) | GENMASK_ULL(4, 3)));
-	BUILD_BUG_ON(PMBSR_EL1_RES0		!= (GENMASK_ULL(63, 32) | GENMASK_ULL(25, 20)));
-	BUILD_BUG_ON(PMBIDR_EL1_RES0		!= (GENMASK_ULL(63, 12) | GENMASK_ULL(7, 6)));
-	BUILD_BUG_ON(CONTEXTIDR_ELx_RES0	!= (GENMASK_ULL(63, 32)));
-	BUILD_BUG_ON(CCSIDR_EL1_RES0		!= (GENMASK_ULL(63, 32)));
-	BUILD_BUG_ON(CLIDR_EL1_RES0		!= (GENMASK_ULL(63, 47)));
-	BUILD_BUG_ON(CCSIDR2_EL1_RES0		!= (GENMASK_ULL(63, 24)));
-	BUILD_BUG_ON(GMID_EL1_RES0		!= (GENMASK_ULL(63, 4)));
-	BUILD_BUG_ON(SMIDR_EL1_RES0		!= (GENMASK_ULL(63, 32) | GENMASK_ULL(14, 12)));
-	BUILD_BUG_ON(CSSELR_EL1_RES0		!= (GENMASK_ULL(63, 5)));
-	BUILD_BUG_ON(CTR_EL0_RES0		!= (GENMASK_ULL(63, 38) | GENMASK_ULL(30, 30) | GENMASK_ULL(13, 4)));
-	BUILD_BUG_ON(CTR_EL0_RES1       	!= (GENMASK_ULL(31, 31)));
-	BUILD_BUG_ON(DCZID_EL0_RES0		!= (GENMASK_ULL(63, 5)));
-	BUILD_BUG_ON(SVCR_RES0			!= (GENMASK_ULL(63, 2)));
-	BUILD_BUG_ON(FPMR_RES0			!= (GENMASK_ULL(63, 38) | GENMASK_ULL(23, 23) | GENMASK_ULL(13, 9)));
-	BUILD_BUG_ON(HFGxTR_EL2_RES0		!= (GENMASK_ULL(51, 51)));
-	BUILD_BUG_ON(HFGITR_EL2_RES0		!= (GENMASK_ULL(63, 63) | GENMASK_ULL(61, 61)));
-	BUILD_BUG_ON(HDFGRTR_EL2_RES0		!= (GENMASK_ULL(49, 49) | GENMASK_ULL(42, 42) | GENMASK_ULL(39, 38) | GENMASK_ULL(21, 20) | GENMASK_ULL(8, 8)));
-	BUILD_BUG_ON(HDFGWTR_EL2_RES0		!= (GENMASK_ULL(63, 63) | GENMASK_ULL(59, 58) | GENMASK_ULL(51, 51) | GENMASK_ULL(47, 47) | GENMASK_ULL(43, 43) | GENMASK_ULL(40, 38) | GENMASK_ULL(34, 34) | GENMASK_ULL(30, 30) | GENMASK_ULL(22, 22) | GENMASK_ULL(9, 9) | GENMASK_ULL(6, 6)));
-	BUILD_BUG_ON(HAFGRTR_EL2_RES0		!= (GENMASK_ULL(63, 50) | GENMASK_ULL(16, 5)));
-	BUILD_BUG_ON(HCRX_EL2_RES0		!= (GENMASK_ULL(63, 25) | GENMASK_ULL(13, 12)));
-	BUILD_BUG_ON(DACR32_EL2_RES0		!= (GENMASK_ULL(63, 32)));
-	BUILD_BUG_ON(PMSCR_EL2_RES0		!= (GENMASK_ULL(63, 8) | GENMASK_ULL(2, 2)));
-	BUILD_BUG_ON(TCR2_EL1x_RES0		!= (GENMASK_ULL(63, 16) | GENMASK_ULL(13, 12) | GENMASK_ULL(9, 6)));
-	BUILD_BUG_ON(TCR2_EL2_RES0		!= (GENMASK_ULL(63, 16)));
-	BUILD_BUG_ON(LORSA_EL1_RES0		!= (GENMASK_ULL(63, 52) | GENMASK_ULL(15, 1)));
-	BUILD_BUG_ON(LOREA_EL1_RES0		!= (GENMASK_ULL(63, 52) | GENMASK_ULL(15, 0)));
-	BUILD_BUG_ON(LORN_EL1_RES0		!= (GENMASK_ULL(63, 8)));
-	BUILD_BUG_ON(LORC_EL1_RES0		!= (GENMASK_ULL(63, 10) | GENMASK_ULL(1, 1)));
-	BUILD_BUG_ON(LORID_EL1_RES0		!= (GENMASK_ULL(63, 24) | GENMASK_ULL(15, 8)));
-	BUILD_BUG_ON(ISR_EL1_RES0		!= (GENMASK_ULL(63, 11) | GENMASK_ULL(5, 0)));
-	BUILD_BUG_ON(ICC_NMIAR1_EL1_RES0	!= (GENMASK_ULL(63, 24)));
-	BUILD_BUG_ON(TRBLIMITR_EL1_RES0		!= (GENMASK_ULL(11, 7)));
-	BUILD_BUG_ON(TRBBASER_EL1_RES0		!= (GENMASK_ULL(11, 0)));
-	BUILD_BUG_ON(TRBSR_EL1_RES0		!= (GENMASK_ULL(63, 56) | GENMASK_ULL(25, 24) | GENMASK_ULL(19, 19) | GENMASK_ULL(16, 16)));
-	BUILD_BUG_ON(TRBMAR_EL1_RES0		!= (GENMASK_ULL(63, 12)));
-	BUILD_BUG_ON(TRBTRG_EL1_RES0		!= (GENMASK_ULL(63, 32)));
-	BUILD_BUG_ON(TRBIDR_EL1_RES0		!= (GENMASK_ULL(63, 12) | GENMASK_ULL(7, 6)));
-
-#endif
-}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 8e60aa4a8dfb..c9f4f387155f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -32,7 +32,6 @@
 
 #include <trace/events/kvm.h>
 
-#include "check-res-bits.h"
 #include "sys_regs.h"
 
 #include "trace.h"
@@ -4110,8 +4109,6 @@ int __init kvm_sys_reg_table_init(void)
 	unsigned int i;
 	int ret = 0;
 
-	check_res_bits();
-
 	/* Make sure tables are unique and in order. */
 	valid &= check_sysreg_table(sys_reg_descs, ARRAY_SIZE(sys_reg_descs), false);
 	valid &= check_sysreg_table(cp14_regs, ARRAY_SIZE(cp14_regs), true);

base-commit: 277100b3d5fefacba4f5ff18e2e52a9553eb6e3f
-- 
2.44.0.291.gc1ea87d7ee-goog


