Return-Path: <kvm+bounces-15567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C2E6E8AD58B
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 22:03:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F8241F212B8
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 20:03:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 188DD156C61;
	Mon, 22 Apr 2024 20:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eqU31WZL"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDC915698B
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 20:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713816159; cv=none; b=oqNnA6RAaMIetYMutBrhuKiu9sXuafMwozxjvRQtc/O3VUdRk9JEbVcsBZ3fcd9OWyjxJyZF1Agrwu6wmw+LDbymy685ZkU54chspWcEbm+8CrOL+FTF3Wd5vxsm9AIW+dLPiRKUFTPvY2K1J2HKMsNNCkNUiitZML2zMW7pKoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713816159; c=relaxed/simple;
	bh=YGijPQzVK3mS9LD5dBnAZK9mnli2DUeo9jxW9f8Mw3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFouFRfoiH7xaI9C5QJfpZ6K5zai8Gb0u1ng73xEFoonVP4AUc4dRaJF9dytn5u7hCHlILJXgTPqIukPg7NovWYbwc8WUZSJTnuDXHwB2MrFrSws6htqB+xlo1k9VKMc/lMpdrYffanGEVLpKIvbVDn8H75XRnSSfRIZoaJlork=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eqU31WZL; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713816155;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=olab6xyeUudQfcYdylH2Po9o9wW7zeRPbhjQ4OApY9Y=;
	b=eqU31WZLhh4hKgUOJf8yzKfpE29fegdz+0xqDeb2emzH7MLJXS/p150yfW+cO7bj3J2mi4
	ZyJWgHLG9zcYgryq8/Uwwzdjy0CyR+lwAOe37EAr0IJtmpBOZnpjYH3r4Sqizd53pyu0lX
	TLxhePrSXYKz7PvF9FW9HDCj8ChoXmE=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 13/19] KVM: selftests: Align with kernel's GIC definitions
Date: Mon, 22 Apr 2024 20:01:52 +0000
Message-ID: <20240422200158.2606761-14-oliver.upton@linux.dev>
In-Reply-To: <20240422200158.2606761-1-oliver.upton@linux.dev>
References: <20240422200158.2606761-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

There are a few subtle incongruencies between the GIC definitions used
by the kernel and selftests. Furthermore, the selftests header blends
implementation detail (e.g. default priority) with the architectural
definitions.

This is all rather annoying, since bulk imports of the kernel header
is not possible. Move selftests-specific definitions out of the
offending header and realign tests on the canonical definitions for
things like sysregs. Finally, haul in a fresh copy of the gicv3 header
to enable a forthcoming ITS selftest.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 .../testing/selftests/kvm/aarch64/vgic_irq.c  |   4 +-
 .../selftests/kvm/include/aarch64/gic_v3.h    | 586 +++++++++++++++++-
 .../selftests/kvm/lib/aarch64/gic_v3.c        |  13 +-
 3 files changed, 568 insertions(+), 35 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index 2e64b4856e38..d61a6302f467 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -152,7 +152,7 @@ static void reset_stats(void)
 
 static uint64_t gic_read_ap1r0(void)
 {
-	uint64_t reg = read_sysreg_s(SYS_ICV_AP1R0_EL1);
+	uint64_t reg = read_sysreg_s(SYS_ICC_AP1R0_EL1);
 
 	dsb(sy);
 	return reg;
@@ -160,7 +160,7 @@ static uint64_t gic_read_ap1r0(void)
 
 static void gic_write_ap1r0(uint64_t val)
 {
-	write_sysreg_s(val, SYS_ICV_AP1R0_EL1);
+	write_sysreg_s(val, SYS_ICC_AP1R0_EL1);
 	isb();
 }
 
diff --git a/tools/testing/selftests/kvm/include/aarch64/gic_v3.h b/tools/testing/selftests/kvm/include/aarch64/gic_v3.h
index ba0886e8a2bb..a76615fa39a1 100644
--- a/tools/testing/selftests/kvm/include/aarch64/gic_v3.h
+++ b/tools/testing/selftests/kvm/include/aarch64/gic_v3.h
@@ -1,82 +1,604 @@
-/* SPDX-License-Identifier: GPL-2.0 */
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * ARM Generic Interrupt Controller (GIC) v3 specific defines
+ * Copyright (C) 2013, 2014 ARM Limited, All Rights Reserved.
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
  */
-
-#ifndef SELFTEST_KVM_GICV3_H
-#define SELFTEST_KVM_GICV3_H
-
-#include <asm/sysreg.h>
+#ifndef __SELFTESTS_GIC_V3_H
+#define __SELFTESTS_GIC_V3_H
 
 /*
- * Distributor registers
+ * Distributor registers. We assume we're running non-secure, with ARE
+ * being set. Secure-only and non-ARE registers are not described.
  */
 #define GICD_CTLR			0x0000
 #define GICD_TYPER			0x0004
+#define GICD_IIDR			0x0008
+#define GICD_TYPER2			0x000C
+#define GICD_STATUSR			0x0010
+#define GICD_SETSPI_NSR			0x0040
+#define GICD_CLRSPI_NSR			0x0048
+#define GICD_SETSPI_SR			0x0050
+#define GICD_CLRSPI_SR			0x0058
 #define GICD_IGROUPR			0x0080
 #define GICD_ISENABLER			0x0100
 #define GICD_ICENABLER			0x0180
 #define GICD_ISPENDR			0x0200
 #define GICD_ICPENDR			0x0280
-#define GICD_ICACTIVER			0x0380
 #define GICD_ISACTIVER			0x0300
+#define GICD_ICACTIVER			0x0380
 #define GICD_IPRIORITYR			0x0400
 #define GICD_ICFGR			0x0C00
+#define GICD_IGRPMODR			0x0D00
+#define GICD_NSACR			0x0E00
+#define GICD_IGROUPRnE			0x1000
+#define GICD_ISENABLERnE		0x1200
+#define GICD_ICENABLERnE		0x1400
+#define GICD_ISPENDRnE			0x1600
+#define GICD_ICPENDRnE			0x1800
+#define GICD_ISACTIVERnE		0x1A00
+#define GICD_ICACTIVERnE		0x1C00
+#define GICD_IPRIORITYRnE		0x2000
+#define GICD_ICFGRnE			0x3000
+#define GICD_IROUTER			0x6000
+#define GICD_IROUTERnE			0x8000
+#define GICD_IDREGS			0xFFD0
+#define GICD_PIDR2			0xFFE8
+
+#define ESPI_BASE_INTID			4096
 
 /*
- * The assumption is that the guest runs in a non-secure mode.
- * The following bits of GICD_CTLR are defined accordingly.
+ * Those registers are actually from GICv2, but the spec demands that they
+ * are implemented as RES0 if ARE is 1 (which we do in KVM's emulated GICv3).
  */
+#define GICD_ITARGETSR			0x0800
+#define GICD_SGIR			0x0F00
+#define GICD_CPENDSGIR			0x0F10
+#define GICD_SPENDSGIR			0x0F20
+
 #define GICD_CTLR_RWP			(1U << 31)
 #define GICD_CTLR_nASSGIreq		(1U << 8)
+#define GICD_CTLR_DS			(1U << 6)
 #define GICD_CTLR_ARE_NS		(1U << 4)
 #define GICD_CTLR_ENABLE_G1A		(1U << 1)
 #define GICD_CTLR_ENABLE_G1		(1U << 0)
 
+#define GICD_IIDR_IMPLEMENTER_SHIFT	0
+#define GICD_IIDR_IMPLEMENTER_MASK	(0xfff << GICD_IIDR_IMPLEMENTER_SHIFT)
+#define GICD_IIDR_REVISION_SHIFT	12
+#define GICD_IIDR_REVISION_MASK		(0xf << GICD_IIDR_REVISION_SHIFT)
+#define GICD_IIDR_VARIANT_SHIFT		16
+#define GICD_IIDR_VARIANT_MASK		(0xf << GICD_IIDR_VARIANT_SHIFT)
+#define GICD_IIDR_PRODUCT_ID_SHIFT	24
+#define GICD_IIDR_PRODUCT_ID_MASK	(0xff << GICD_IIDR_PRODUCT_ID_SHIFT)
+
+
+/*
+ * In systems with a single security state (what we emulate in KVM)
+ * the meaning of the interrupt group enable bits is slightly different
+ */
+#define GICD_CTLR_ENABLE_SS_G1		(1U << 1)
+#define GICD_CTLR_ENABLE_SS_G0		(1U << 0)
+
+#define GICD_TYPER_RSS			(1U << 26)
+#define GICD_TYPER_LPIS			(1U << 17)
+#define GICD_TYPER_MBIS			(1U << 16)
+#define GICD_TYPER_ESPI			(1U << 8)
+
+#define GICD_TYPER_ID_BITS(typer)	((((typer) >> 19) & 0x1f) + 1)
+#define GICD_TYPER_NUM_LPIS(typer)	((((typer) >> 11) & 0x1f) + 1)
 #define GICD_TYPER_SPIS(typer)		((((typer) & 0x1f) + 1) * 32)
-#define GICD_INT_DEF_PRI_X4		0xa0a0a0a0
+#define GICD_TYPER_ESPIS(typer)						\
+	(((typer) & GICD_TYPER_ESPI) ? GICD_TYPER_SPIS((typer) >> 27) : 0)
+
+#define GICD_TYPER2_nASSGIcap		(1U << 8)
+#define GICD_TYPER2_VIL			(1U << 7)
+#define GICD_TYPER2_VID			GENMASK(4, 0)
+
+#define GICD_IROUTER_SPI_MODE_ONE	(0U << 31)
+#define GICD_IROUTER_SPI_MODE_ANY	(1U << 31)
+
+#define GIC_PIDR2_ARCH_MASK		0xf0
+#define GIC_PIDR2_ARCH_GICv3		0x30
+#define GIC_PIDR2_ARCH_GICv4		0x40
+
+#define GIC_V3_DIST_SIZE		0x10000
+
+#define GIC_PAGE_SIZE_4K		0ULL
+#define GIC_PAGE_SIZE_16K		1ULL
+#define GIC_PAGE_SIZE_64K		2ULL
+#define GIC_PAGE_SIZE_MASK		3ULL
 
 /*
- * Redistributor registers
+ * Re-Distributor registers, offsets from RD_base
  */
-#define GICR_CTLR			0x000
-#define GICR_WAKER			0x014
+#define GICR_CTLR			GICD_CTLR
+#define GICR_IIDR			0x0004
+#define GICR_TYPER			0x0008
+#define GICR_STATUSR			GICD_STATUSR
+#define GICR_WAKER			0x0014
+#define GICR_SETLPIR			0x0040
+#define GICR_CLRLPIR			0x0048
+#define GICR_PROPBASER			0x0070
+#define GICR_PENDBASER			0x0078
+#define GICR_INVLPIR			0x00A0
+#define GICR_INVALLR			0x00B0
+#define GICR_SYNCR			0x00C0
+#define GICR_IDREGS			GICD_IDREGS
+#define GICR_PIDR2			GICD_PIDR2
+
+#define GICR_CTLR_ENABLE_LPIS		(1UL << 0)
+#define GICR_CTLR_CES			(1UL << 1)
+#define GICR_CTLR_IR			(1UL << 2)
+#define GICR_CTLR_RWP			(1UL << 3)
 
-#define GICR_CTLR_RWP			(1U << 3)
+#define GICR_TYPER_CPU_NUMBER(r)	(((r) >> 8) & 0xffff)
+
+#define EPPI_BASE_INTID			1056
+
+#define GICR_TYPER_NR_PPIS(r)						\
+	({								\
+		unsigned int __ppinum = ((r) >> 27) & 0x1f;		\
+		unsigned int __nr_ppis = 16;				\
+		if (__ppinum == 1 || __ppinum == 2)			\
+			__nr_ppis +=  __ppinum * 32;			\
+									\
+		__nr_ppis;						\
+	 })
 
 #define GICR_WAKER_ProcessorSleep	(1U << 1)
 #define GICR_WAKER_ChildrenAsleep	(1U << 2)
 
+#define GIC_BASER_CACHE_nCnB		0ULL
+#define GIC_BASER_CACHE_SameAsInner	0ULL
+#define GIC_BASER_CACHE_nC		1ULL
+#define GIC_BASER_CACHE_RaWt		2ULL
+#define GIC_BASER_CACHE_RaWb		3ULL
+#define GIC_BASER_CACHE_WaWt		4ULL
+#define GIC_BASER_CACHE_WaWb		5ULL
+#define GIC_BASER_CACHE_RaWaWt		6ULL
+#define GIC_BASER_CACHE_RaWaWb		7ULL
+#define GIC_BASER_CACHE_MASK		7ULL
+#define GIC_BASER_NonShareable		0ULL
+#define GIC_BASER_InnerShareable	1ULL
+#define GIC_BASER_OuterShareable	2ULL
+#define GIC_BASER_SHAREABILITY_MASK	3ULL
+
+#define GIC_BASER_CACHEABILITY(reg, inner_outer, type)			\
+	(GIC_BASER_CACHE_##type << reg##_##inner_outer##_CACHEABILITY_SHIFT)
+
+#define GIC_BASER_SHAREABILITY(reg, type)				\
+	(GIC_BASER_##type << reg##_SHAREABILITY_SHIFT)
+
+/* encode a size field of width @w containing @n - 1 units */
+#define GIC_ENCODE_SZ(n, w) (((unsigned long)(n) - 1) & GENMASK_ULL(((w) - 1), 0))
+
+#define GICR_PROPBASER_SHAREABILITY_SHIFT		(10)
+#define GICR_PROPBASER_INNER_CACHEABILITY_SHIFT		(7)
+#define GICR_PROPBASER_OUTER_CACHEABILITY_SHIFT		(56)
+#define GICR_PROPBASER_SHAREABILITY_MASK				\
+	GIC_BASER_SHAREABILITY(GICR_PROPBASER, SHAREABILITY_MASK)
+#define GICR_PROPBASER_INNER_CACHEABILITY_MASK				\
+	GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, MASK)
+#define GICR_PROPBASER_OUTER_CACHEABILITY_MASK				\
+	GIC_BASER_CACHEABILITY(GICR_PROPBASER, OUTER, MASK)
+#define GICR_PROPBASER_CACHEABILITY_MASK GICR_PROPBASER_INNER_CACHEABILITY_MASK
+
+#define GICR_PROPBASER_InnerShareable					\
+	GIC_BASER_SHAREABILITY(GICR_PROPBASER, InnerShareable)
+
+#define GICR_PROPBASER_nCnB	GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, nCnB)
+#define GICR_PROPBASER_nC 	GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, nC)
+#define GICR_PROPBASER_RaWt	GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, RaWt)
+#define GICR_PROPBASER_RaWb	GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, RaWb)
+#define GICR_PROPBASER_WaWt	GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, WaWt)
+#define GICR_PROPBASER_WaWb	GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, WaWb)
+#define GICR_PROPBASER_RaWaWt	GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, RaWaWt)
+#define GICR_PROPBASER_RaWaWb	GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, RaWaWb)
+
+#define GICR_PROPBASER_IDBITS_MASK			(0x1f)
+#define GICR_PROPBASER_ADDRESS(x)	((x) & GENMASK_ULL(51, 12))
+#define GICR_PENDBASER_ADDRESS(x)	((x) & GENMASK_ULL(51, 16))
+
+#define GICR_PENDBASER_SHAREABILITY_SHIFT		(10)
+#define GICR_PENDBASER_INNER_CACHEABILITY_SHIFT		(7)
+#define GICR_PENDBASER_OUTER_CACHEABILITY_SHIFT		(56)
+#define GICR_PENDBASER_SHAREABILITY_MASK				\
+	GIC_BASER_SHAREABILITY(GICR_PENDBASER, SHAREABILITY_MASK)
+#define GICR_PENDBASER_INNER_CACHEABILITY_MASK				\
+	GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, MASK)
+#define GICR_PENDBASER_OUTER_CACHEABILITY_MASK				\
+	GIC_BASER_CACHEABILITY(GICR_PENDBASER, OUTER, MASK)
+#define GICR_PENDBASER_CACHEABILITY_MASK GICR_PENDBASER_INNER_CACHEABILITY_MASK
+
+#define GICR_PENDBASER_InnerShareable					\
+	GIC_BASER_SHAREABILITY(GICR_PENDBASER, InnerShareable)
+
+#define GICR_PENDBASER_nCnB	GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, nCnB)
+#define GICR_PENDBASER_nC 	GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, nC)
+#define GICR_PENDBASER_RaWt	GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, RaWt)
+#define GICR_PENDBASER_RaWb	GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, RaWb)
+#define GICR_PENDBASER_WaWt	GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, WaWt)
+#define GICR_PENDBASER_WaWb	GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, WaWb)
+#define GICR_PENDBASER_RaWaWt	GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, RaWaWt)
+#define GICR_PENDBASER_RaWaWb	GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, RaWaWb)
+
+#define GICR_PENDBASER_PTZ				BIT_ULL(62)
+
 /*
- * Redistributor registers, offsets from SGI base
+ * Re-Distributor registers, offsets from SGI_base
  */
 #define GICR_IGROUPR0			GICD_IGROUPR
 #define GICR_ISENABLER0			GICD_ISENABLER
 #define GICR_ICENABLER0			GICD_ICENABLER
 #define GICR_ISPENDR0			GICD_ISPENDR
+#define GICR_ICPENDR0			GICD_ICPENDR
 #define GICR_ISACTIVER0			GICD_ISACTIVER
 #define GICR_ICACTIVER0			GICD_ICACTIVER
-#define GICR_ICENABLER			GICD_ICENABLER
-#define GICR_ICACTIVER			GICD_ICACTIVER
 #define GICR_IPRIORITYR0		GICD_IPRIORITYR
+#define GICR_ICFGR0			GICD_ICFGR
+#define GICR_IGRPMODR0			GICD_IGRPMODR
+#define GICR_NSACR			GICD_NSACR
+
+#define GICR_TYPER_PLPIS		(1U << 0)
+#define GICR_TYPER_VLPIS		(1U << 1)
+#define GICR_TYPER_DIRTY		(1U << 2)
+#define GICR_TYPER_DirectLPIS		(1U << 3)
+#define GICR_TYPER_LAST			(1U << 4)
+#define GICR_TYPER_RVPEID		(1U << 7)
+#define GICR_TYPER_COMMON_LPI_AFF	GENMASK_ULL(25, 24)
+#define GICR_TYPER_AFFINITY		GENMASK_ULL(63, 32)
+
+#define GICR_INVLPIR_INTID		GENMASK_ULL(31, 0)
+#define GICR_INVLPIR_VPEID		GENMASK_ULL(47, 32)
+#define GICR_INVLPIR_V			GENMASK_ULL(63, 63)
+
+#define GICR_INVALLR_VPEID		GICR_INVLPIR_VPEID
+#define GICR_INVALLR_V			GICR_INVLPIR_V
+
+#define GIC_V3_REDIST_SIZE		0x20000
+
+#define LPI_PROP_GROUP1			(1 << 1)
+#define LPI_PROP_ENABLED		(1 << 0)
+
+/*
+ * Re-Distributor registers, offsets from VLPI_base
+ */
+#define GICR_VPROPBASER			0x0070
+
+#define GICR_VPROPBASER_IDBITS_MASK	0x1f
+
+#define GICR_VPROPBASER_SHAREABILITY_SHIFT		(10)
+#define GICR_VPROPBASER_INNER_CACHEABILITY_SHIFT	(7)
+#define GICR_VPROPBASER_OUTER_CACHEABILITY_SHIFT	(56)
+
+#define GICR_VPROPBASER_SHAREABILITY_MASK				\
+	GIC_BASER_SHAREABILITY(GICR_VPROPBASER, SHAREABILITY_MASK)
+#define GICR_VPROPBASER_INNER_CACHEABILITY_MASK				\
+	GIC_BASER_CACHEABILITY(GICR_VPROPBASER, INNER, MASK)
+#define GICR_VPROPBASER_OUTER_CACHEABILITY_MASK				\
+	GIC_BASER_CACHEABILITY(GICR_VPROPBASER, OUTER, MASK)
+#define GICR_VPROPBASER_CACHEABILITY_MASK				\
+	GICR_VPROPBASER_INNER_CACHEABILITY_MASK
+
+#define GICR_VPROPBASER_InnerShareable					\
+	GIC_BASER_SHAREABILITY(GICR_VPROPBASER, InnerShareable)
+
+#define GICR_VPROPBASER_nCnB	GIC_BASER_CACHEABILITY(GICR_VPROPBASER, INNER, nCnB)
+#define GICR_VPROPBASER_nC 	GIC_BASER_CACHEABILITY(GICR_VPROPBASER, INNER, nC)
+#define GICR_VPROPBASER_RaWt	GIC_BASER_CACHEABILITY(GICR_VPROPBASER, INNER, RaWt)
+#define GICR_VPROPBASER_RaWb	GIC_BASER_CACHEABILITY(GICR_VPROPBASER, INNER, RaWb)
+#define GICR_VPROPBASER_WaWt	GIC_BASER_CACHEABILITY(GICR_VPROPBASER, INNER, WaWt)
+#define GICR_VPROPBASER_WaWb	GIC_BASER_CACHEABILITY(GICR_VPROPBASER, INNER, WaWb)
+#define GICR_VPROPBASER_RaWaWt	GIC_BASER_CACHEABILITY(GICR_VPROPBASER, INNER, RaWaWt)
+#define GICR_VPROPBASER_RaWaWb	GIC_BASER_CACHEABILITY(GICR_VPROPBASER, INNER, RaWaWb)
+
+/*
+ * GICv4.1 VPROPBASER reinvention. A subtle mix between the old
+ * VPROPBASER and ITS_BASER. Just not quite any of the two.
+ */
+#define GICR_VPROPBASER_4_1_VALID	(1ULL << 63)
+#define GICR_VPROPBASER_4_1_ENTRY_SIZE	GENMASK_ULL(61, 59)
+#define GICR_VPROPBASER_4_1_INDIRECT	(1ULL << 55)
+#define GICR_VPROPBASER_4_1_PAGE_SIZE	GENMASK_ULL(54, 53)
+#define GICR_VPROPBASER_4_1_Z		(1ULL << 52)
+#define GICR_VPROPBASER_4_1_ADDR	GENMASK_ULL(51, 12)
+#define GICR_VPROPBASER_4_1_SIZE	GENMASK_ULL(6, 0)
+
+#define GICR_VPENDBASER			0x0078
+
+#define GICR_VPENDBASER_SHAREABILITY_SHIFT		(10)
+#define GICR_VPENDBASER_INNER_CACHEABILITY_SHIFT	(7)
+#define GICR_VPENDBASER_OUTER_CACHEABILITY_SHIFT	(56)
+#define GICR_VPENDBASER_SHAREABILITY_MASK				\
+	GIC_BASER_SHAREABILITY(GICR_VPENDBASER, SHAREABILITY_MASK)
+#define GICR_VPENDBASER_INNER_CACHEABILITY_MASK				\
+	GIC_BASER_CACHEABILITY(GICR_VPENDBASER, INNER, MASK)
+#define GICR_VPENDBASER_OUTER_CACHEABILITY_MASK				\
+	GIC_BASER_CACHEABILITY(GICR_VPENDBASER, OUTER, MASK)
+#define GICR_VPENDBASER_CACHEABILITY_MASK				\
+	GICR_VPENDBASER_INNER_CACHEABILITY_MASK
+
+#define GICR_VPENDBASER_NonShareable					\
+	GIC_BASER_SHAREABILITY(GICR_VPENDBASER, NonShareable)
+
+#define GICR_VPENDBASER_InnerShareable					\
+	GIC_BASER_SHAREABILITY(GICR_VPENDBASER, InnerShareable)
+
+#define GICR_VPENDBASER_nCnB	GIC_BASER_CACHEABILITY(GICR_VPENDBASER, INNER, nCnB)
+#define GICR_VPENDBASER_nC 	GIC_BASER_CACHEABILITY(GICR_VPENDBASER, INNER, nC)
+#define GICR_VPENDBASER_RaWt	GIC_BASER_CACHEABILITY(GICR_VPENDBASER, INNER, RaWt)
+#define GICR_VPENDBASER_RaWb	GIC_BASER_CACHEABILITY(GICR_VPENDBASER, INNER, RaWb)
+#define GICR_VPENDBASER_WaWt	GIC_BASER_CACHEABILITY(GICR_VPENDBASER, INNER, WaWt)
+#define GICR_VPENDBASER_WaWb	GIC_BASER_CACHEABILITY(GICR_VPENDBASER, INNER, WaWb)
+#define GICR_VPENDBASER_RaWaWt	GIC_BASER_CACHEABILITY(GICR_VPENDBASER, INNER, RaWaWt)
+#define GICR_VPENDBASER_RaWaWb	GIC_BASER_CACHEABILITY(GICR_VPENDBASER, INNER, RaWaWb)
+
+#define GICR_VPENDBASER_Dirty		(1ULL << 60)
+#define GICR_VPENDBASER_PendingLast	(1ULL << 61)
+#define GICR_VPENDBASER_IDAI		(1ULL << 62)
+#define GICR_VPENDBASER_Valid		(1ULL << 63)
+
+/*
+ * GICv4.1 VPENDBASER, used for VPE residency. On top of these fields,
+ * also use the above Valid, PendingLast and Dirty.
+ */
+#define GICR_VPENDBASER_4_1_DB		(1ULL << 62)
+#define GICR_VPENDBASER_4_1_VGRP0EN	(1ULL << 59)
+#define GICR_VPENDBASER_4_1_VGRP1EN	(1ULL << 58)
+#define GICR_VPENDBASER_4_1_VPEID	GENMASK_ULL(15, 0)
+
+#define GICR_VSGIR			0x0080
+
+#define GICR_VSGIR_VPEID		GENMASK(15, 0)
+
+#define GICR_VSGIPENDR			0x0088
+
+#define GICR_VSGIPENDR_BUSY		(1U << 31)
+#define GICR_VSGIPENDR_PENDING		GENMASK(15, 0)
+
+/*
+ * ITS registers, offsets from ITS_base
+ */
+#define GITS_CTLR			0x0000
+#define GITS_IIDR			0x0004
+#define GITS_TYPER			0x0008
+#define GITS_MPIDR			0x0018
+#define GITS_CBASER			0x0080
+#define GITS_CWRITER			0x0088
+#define GITS_CREADR			0x0090
+#define GITS_BASER			0x0100
+#define GITS_IDREGS_BASE		0xffd0
+#define GITS_PIDR0			0xffe0
+#define GITS_PIDR1			0xffe4
+#define GITS_PIDR2			GICR_PIDR2
+#define GITS_PIDR4			0xffd0
+#define GITS_CIDR0			0xfff0
+#define GITS_CIDR1			0xfff4
+#define GITS_CIDR2			0xfff8
+#define GITS_CIDR3			0xfffc
+
+#define GITS_TRANSLATER			0x10040
+
+#define GITS_SGIR			0x20020
+
+#define GITS_SGIR_VPEID			GENMASK_ULL(47, 32)
+#define GITS_SGIR_VINTID		GENMASK_ULL(3, 0)
+
+#define GITS_CTLR_ENABLE		(1U << 0)
+#define GITS_CTLR_ImDe			(1U << 1)
+#define	GITS_CTLR_ITS_NUMBER_SHIFT	4
+#define	GITS_CTLR_ITS_NUMBER		(0xFU << GITS_CTLR_ITS_NUMBER_SHIFT)
+#define GITS_CTLR_QUIESCENT		(1U << 31)
+
+#define GITS_TYPER_PLPIS		(1UL << 0)
+#define GITS_TYPER_VLPIS		(1UL << 1)
+#define GITS_TYPER_ITT_ENTRY_SIZE_SHIFT	4
+#define GITS_TYPER_ITT_ENTRY_SIZE	GENMASK_ULL(7, 4)
+#define GITS_TYPER_IDBITS_SHIFT		8
+#define GITS_TYPER_DEVBITS_SHIFT	13
+#define GITS_TYPER_DEVBITS		GENMASK_ULL(17, 13)
+#define GITS_TYPER_PTA			(1UL << 19)
+#define GITS_TYPER_HCC_SHIFT		24
+#define GITS_TYPER_HCC(r)		(((r) >> GITS_TYPER_HCC_SHIFT) & 0xff)
+#define GITS_TYPER_VMOVP		(1ULL << 37)
+#define GITS_TYPER_VMAPP		(1ULL << 40)
+#define GITS_TYPER_SVPET		GENMASK_ULL(42, 41)
 
-/* CPU interface registers */
-#define SYS_ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
-#define SYS_ICC_IAR1_EL1		sys_reg(3, 0, 12, 12, 0)
-#define SYS_ICC_EOIR1_EL1		sys_reg(3, 0, 12, 12, 1)
-#define SYS_ICC_DIR_EL1			sys_reg(3, 0, 12, 11, 1)
-#define SYS_ICC_CTLR_EL1		sys_reg(3, 0, 12, 12, 4)
-#define SYS_ICC_SRE_EL1			sys_reg(3, 0, 12, 12, 5)
-#define SYS_ICC_GRPEN1_EL1		sys_reg(3, 0, 12, 12, 7)
+#define GITS_IIDR_REV_SHIFT		12
+#define GITS_IIDR_REV_MASK		(0xf << GITS_IIDR_REV_SHIFT)
+#define GITS_IIDR_REV(r)		(((r) >> GITS_IIDR_REV_SHIFT) & 0xf)
+#define GITS_IIDR_PRODUCTID_SHIFT	24
 
-#define SYS_ICV_AP1R0_EL1		sys_reg(3, 0, 12, 9, 0)
+#define GITS_CBASER_VALID			(1ULL << 63)
+#define GITS_CBASER_SHAREABILITY_SHIFT		(10)
+#define GITS_CBASER_INNER_CACHEABILITY_SHIFT	(59)
+#define GITS_CBASER_OUTER_CACHEABILITY_SHIFT	(53)
+#define GITS_CBASER_SHAREABILITY_MASK					\
+	GIC_BASER_SHAREABILITY(GITS_CBASER, SHAREABILITY_MASK)
+#define GITS_CBASER_INNER_CACHEABILITY_MASK				\
+	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, MASK)
+#define GITS_CBASER_OUTER_CACHEABILITY_MASK				\
+	GIC_BASER_CACHEABILITY(GITS_CBASER, OUTER, MASK)
+#define GITS_CBASER_CACHEABILITY_MASK GITS_CBASER_INNER_CACHEABILITY_MASK
 
-#define ICC_PMR_DEF_PRIO		0xf0
+#define GITS_CBASER_InnerShareable					\
+	GIC_BASER_SHAREABILITY(GITS_CBASER, InnerShareable)
 
+#define GITS_CBASER_nCnB	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, nCnB)
+#define GITS_CBASER_nC		GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, nC)
+#define GITS_CBASER_RaWt	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, RaWt)
+#define GITS_CBASER_RaWb	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, RaWb)
+#define GITS_CBASER_WaWt	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, WaWt)
+#define GITS_CBASER_WaWb	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, WaWb)
+#define GITS_CBASER_RaWaWt	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, RaWaWt)
+#define GITS_CBASER_RaWaWb	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, RaWaWb)
+
+#define GITS_CBASER_ADDRESS(cbaser)	((cbaser) & GENMASK_ULL(51, 12))
+
+#define GITS_BASER_NR_REGS		8
+
+#define GITS_BASER_VALID			(1ULL << 63)
+#define GITS_BASER_INDIRECT			(1ULL << 62)
+
+#define GITS_BASER_INNER_CACHEABILITY_SHIFT	(59)
+#define GITS_BASER_OUTER_CACHEABILITY_SHIFT	(53)
+#define GITS_BASER_INNER_CACHEABILITY_MASK				\
+	GIC_BASER_CACHEABILITY(GITS_BASER, INNER, MASK)
+#define GITS_BASER_CACHEABILITY_MASK		GITS_BASER_INNER_CACHEABILITY_MASK
+#define GITS_BASER_OUTER_CACHEABILITY_MASK				\
+	GIC_BASER_CACHEABILITY(GITS_BASER, OUTER, MASK)
+#define GITS_BASER_SHAREABILITY_MASK					\
+	GIC_BASER_SHAREABILITY(GITS_BASER, SHAREABILITY_MASK)
+
+#define GITS_BASER_nCnB		GIC_BASER_CACHEABILITY(GITS_BASER, INNER, nCnB)
+#define GITS_BASER_nC		GIC_BASER_CACHEABILITY(GITS_BASER, INNER, nC)
+#define GITS_BASER_RaWt		GIC_BASER_CACHEABILITY(GITS_BASER, INNER, RaWt)
+#define GITS_BASER_RaWb		GIC_BASER_CACHEABILITY(GITS_BASER, INNER, RaWb)
+#define GITS_BASER_WaWt		GIC_BASER_CACHEABILITY(GITS_BASER, INNER, WaWt)
+#define GITS_BASER_WaWb		GIC_BASER_CACHEABILITY(GITS_BASER, INNER, WaWb)
+#define GITS_BASER_RaWaWt	GIC_BASER_CACHEABILITY(GITS_BASER, INNER, RaWaWt)
+#define GITS_BASER_RaWaWb	GIC_BASER_CACHEABILITY(GITS_BASER, INNER, RaWaWb)
+
+#define GITS_BASER_TYPE_SHIFT			(56)
+#define GITS_BASER_TYPE(r)		(((r) >> GITS_BASER_TYPE_SHIFT) & 7)
+#define GITS_BASER_ENTRY_SIZE_SHIFT		(48)
+#define GITS_BASER_ENTRY_SIZE(r)	((((r) >> GITS_BASER_ENTRY_SIZE_SHIFT) & 0x1f) + 1)
+#define GITS_BASER_ENTRY_SIZE_MASK	GENMASK_ULL(52, 48)
+#define GITS_BASER_PHYS_52_to_48(phys)					\
+	(((phys) & GENMASK_ULL(47, 16)) | (((phys) >> 48) & 0xf) << 12)
+#define GITS_BASER_ADDR_48_to_52(baser)					\
+	(((baser) & GENMASK_ULL(47, 16)) | (((baser) >> 12) & 0xf) << 48)
+
+#define GITS_BASER_SHAREABILITY_SHIFT	(10)
+#define GITS_BASER_InnerShareable					\
+	GIC_BASER_SHAREABILITY(GITS_BASER, InnerShareable)
+#define GITS_BASER_PAGE_SIZE_SHIFT	(8)
+#define __GITS_BASER_PSZ(sz)		(GIC_PAGE_SIZE_ ## sz << GITS_BASER_PAGE_SIZE_SHIFT)
+#define GITS_BASER_PAGE_SIZE_4K		__GITS_BASER_PSZ(4K)
+#define GITS_BASER_PAGE_SIZE_16K	__GITS_BASER_PSZ(16K)
+#define GITS_BASER_PAGE_SIZE_64K	__GITS_BASER_PSZ(64K)
+#define GITS_BASER_PAGE_SIZE_MASK	__GITS_BASER_PSZ(MASK)
+#define GITS_BASER_PAGES_MAX		256
+#define GITS_BASER_PAGES_SHIFT		(0)
+#define GITS_BASER_NR_PAGES(r)		(((r) & 0xff) + 1)
+
+#define GITS_BASER_TYPE_NONE		0
+#define GITS_BASER_TYPE_DEVICE		1
+#define GITS_BASER_TYPE_VCPU		2
+#define GITS_BASER_TYPE_RESERVED3	3
+#define GITS_BASER_TYPE_COLLECTION	4
+#define GITS_BASER_TYPE_RESERVED5	5
+#define GITS_BASER_TYPE_RESERVED6	6
+#define GITS_BASER_TYPE_RESERVED7	7
+
+#define GITS_LVL1_ENTRY_SIZE           (8UL)
+
+/*
+ * ITS commands
+ */
+#define GITS_CMD_MAPD			0x08
+#define GITS_CMD_MAPC			0x09
+#define GITS_CMD_MAPTI			0x0a
+#define GITS_CMD_MAPI			0x0b
+#define GITS_CMD_MOVI			0x01
+#define GITS_CMD_DISCARD		0x0f
+#define GITS_CMD_INV			0x0c
+#define GITS_CMD_MOVALL			0x0e
+#define GITS_CMD_INVALL			0x0d
+#define GITS_CMD_INT			0x03
+#define GITS_CMD_CLEAR			0x04
+#define GITS_CMD_SYNC			0x05
+
+/*
+ * GICv4 ITS specific commands
+ */
+#define GITS_CMD_GICv4(x)		((x) | 0x20)
+#define GITS_CMD_VINVALL		GITS_CMD_GICv4(GITS_CMD_INVALL)
+#define GITS_CMD_VMAPP			GITS_CMD_GICv4(GITS_CMD_MAPC)
+#define GITS_CMD_VMAPTI			GITS_CMD_GICv4(GITS_CMD_MAPTI)
+#define GITS_CMD_VMOVI			GITS_CMD_GICv4(GITS_CMD_MOVI)
+#define GITS_CMD_VSYNC			GITS_CMD_GICv4(GITS_CMD_SYNC)
+/* VMOVP, VSGI and INVDB are the odd ones, as they dont have a physical counterpart */
+#define GITS_CMD_VMOVP			GITS_CMD_GICv4(2)
+#define GITS_CMD_VSGI			GITS_CMD_GICv4(3)
+#define GITS_CMD_INVDB			GITS_CMD_GICv4(0xe)
+
+/*
+ * ITS error numbers
+ */
+#define E_ITS_MOVI_UNMAPPED_INTERRUPT		0x010107
+#define E_ITS_MOVI_UNMAPPED_COLLECTION		0x010109
+#define E_ITS_INT_UNMAPPED_INTERRUPT		0x010307
+#define E_ITS_CLEAR_UNMAPPED_INTERRUPT		0x010507
+#define E_ITS_MAPD_DEVICE_OOR			0x010801
+#define E_ITS_MAPD_ITTSIZE_OOR			0x010802
+#define E_ITS_MAPC_PROCNUM_OOR			0x010902
+#define E_ITS_MAPC_COLLECTION_OOR		0x010903
+#define E_ITS_MAPTI_UNMAPPED_DEVICE		0x010a04
+#define E_ITS_MAPTI_ID_OOR			0x010a05
+#define E_ITS_MAPTI_PHYSICALID_OOR		0x010a06
+#define E_ITS_INV_UNMAPPED_INTERRUPT		0x010c07
+#define E_ITS_INVALL_UNMAPPED_COLLECTION	0x010d09
+#define E_ITS_MOVALL_PROCNUM_OOR		0x010e01
+#define E_ITS_DISCARD_UNMAPPED_INTERRUPT	0x010f07
+
+/*
+ * CPU interface registers
+ */
+#define ICC_CTLR_EL1_EOImode_SHIFT	(1)
+#define ICC_CTLR_EL1_EOImode_drop_dir	(0U << ICC_CTLR_EL1_EOImode_SHIFT)
+#define ICC_CTLR_EL1_EOImode_drop	(1U << ICC_CTLR_EL1_EOImode_SHIFT)
+#define ICC_CTLR_EL1_EOImode_MASK	(1 << ICC_CTLR_EL1_EOImode_SHIFT)
+#define ICC_CTLR_EL1_CBPR_SHIFT		0
+#define ICC_CTLR_EL1_CBPR_MASK		(1 << ICC_CTLR_EL1_CBPR_SHIFT)
+#define ICC_CTLR_EL1_PMHE_SHIFT		6
+#define ICC_CTLR_EL1_PMHE_MASK		(1 << ICC_CTLR_EL1_PMHE_SHIFT)
+#define ICC_CTLR_EL1_PRI_BITS_SHIFT	8
+#define ICC_CTLR_EL1_PRI_BITS_MASK	(0x7 << ICC_CTLR_EL1_PRI_BITS_SHIFT)
+#define ICC_CTLR_EL1_ID_BITS_SHIFT	11
+#define ICC_CTLR_EL1_ID_BITS_MASK	(0x7 << ICC_CTLR_EL1_ID_BITS_SHIFT)
+#define ICC_CTLR_EL1_SEIS_SHIFT		14
+#define ICC_CTLR_EL1_SEIS_MASK		(0x1 << ICC_CTLR_EL1_SEIS_SHIFT)
+#define ICC_CTLR_EL1_A3V_SHIFT		15
+#define ICC_CTLR_EL1_A3V_MASK		(0x1 << ICC_CTLR_EL1_A3V_SHIFT)
+#define ICC_CTLR_EL1_RSS		(0x1 << 18)
+#define ICC_CTLR_EL1_ExtRange		(0x1 << 19)
+#define ICC_PMR_EL1_SHIFT		0
+#define ICC_PMR_EL1_MASK		(0xff << ICC_PMR_EL1_SHIFT)
+#define ICC_BPR0_EL1_SHIFT		0
+#define ICC_BPR0_EL1_MASK		(0x7 << ICC_BPR0_EL1_SHIFT)
+#define ICC_BPR1_EL1_SHIFT		0
+#define ICC_BPR1_EL1_MASK		(0x7 << ICC_BPR1_EL1_SHIFT)
+#define ICC_IGRPEN0_EL1_SHIFT		0
+#define ICC_IGRPEN0_EL1_MASK		(1 << ICC_IGRPEN0_EL1_SHIFT)
+#define ICC_IGRPEN1_EL1_SHIFT		0
+#define ICC_IGRPEN1_EL1_MASK		(1 << ICC_IGRPEN1_EL1_SHIFT)
+#define ICC_SRE_EL1_DIB			(1U << 2)
+#define ICC_SRE_EL1_DFB			(1U << 1)
 #define ICC_SRE_EL1_SRE			(1U << 0)
 
-#define ICC_IGRPEN1_EL1_ENABLE		(1U << 0)
+/* These are for GICv2 emulation only */
+#define GICH_LR_VIRTUALID		(0x3ffUL << 0)
+#define GICH_LR_PHYSID_CPUID_SHIFT	(10)
+#define GICH_LR_PHYSID_CPUID		(7UL << GICH_LR_PHYSID_CPUID_SHIFT)
+
+#define ICC_IAR1_EL1_SPURIOUS		0x3ff
+
+#define ICC_SRE_EL2_SRE			(1 << 0)
+#define ICC_SRE_EL2_ENABLE		(1 << 3)
 
-#define GICV3_MAX_CPUS			512
+#define ICC_SGI1R_TARGET_LIST_SHIFT	0
+#define ICC_SGI1R_TARGET_LIST_MASK	(0xffff << ICC_SGI1R_TARGET_LIST_SHIFT)
+#define ICC_SGI1R_AFFINITY_1_SHIFT	16
+#define ICC_SGI1R_AFFINITY_1_MASK	(0xff << ICC_SGI1R_AFFINITY_1_SHIFT)
+#define ICC_SGI1R_SGI_ID_SHIFT		24
+#define ICC_SGI1R_SGI_ID_MASK		(0xfULL << ICC_SGI1R_SGI_ID_SHIFT)
+#define ICC_SGI1R_AFFINITY_2_SHIFT	32
+#define ICC_SGI1R_AFFINITY_2_MASK	(0xffULL << ICC_SGI1R_AFFINITY_2_SHIFT)
+#define ICC_SGI1R_IRQ_ROUTING_MODE_BIT	40
+#define ICC_SGI1R_RS_SHIFT		44
+#define ICC_SGI1R_RS_MASK		(0xfULL << ICC_SGI1R_RS_SHIFT)
+#define ICC_SGI1R_AFFINITY_3_SHIFT	48
+#define ICC_SGI1R_AFFINITY_3_MASK	(0xffULL << ICC_SGI1R_AFFINITY_3_SHIFT)
 
-#endif /* SELFTEST_KVM_GICV3_H */
+#endif
diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
index 263bf3ed8fd5..cd8f0e209599 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
@@ -9,9 +9,20 @@
 #include "processor.h"
 #include "delay.h"
 
+#include "gic.h"
 #include "gic_v3.h"
 #include "gic_private.h"
 
+#define GICV3_MAX_CPUS			512
+
+#define GICD_INT_DEF_PRI		0xa0
+#define GICD_INT_DEF_PRI_X4		((GICD_INT_DEF_PRI << 24) |\
+					(GICD_INT_DEF_PRI << 16) |\
+					(GICD_INT_DEF_PRI << 8) |\
+					GICD_INT_DEF_PRI)
+
+#define ICC_PMR_DEF_PRIO		0xf0
+
 struct gicv3_data {
 	void *dist_base;
 	void *redist_base[GICV3_MAX_CPUS];
@@ -320,7 +331,7 @@ static void gicv3_cpu_init(unsigned int cpu, void *redist_base)
 	write_sysreg_s(ICC_PMR_DEF_PRIO, SYS_ICC_PMR_EL1);
 
 	/* Enable non-secure Group-1 interrupts */
-	write_sysreg_s(ICC_IGRPEN1_EL1_ENABLE, SYS_ICC_GRPEN1_EL1);
+	write_sysreg_s(ICC_IGRPEN1_EL1_MASK, SYS_ICC_IGRPEN1_EL1);
 
 	gicv3_data.redist_base[cpu] = redist_base_cpu;
 }
-- 
2.44.0.769.g3c40516874-goog


