Return-Path: <kvm+bounces-14490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 375F78A2C67
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 12:34:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6881C1C21BA6
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:34:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6724143AD9;
	Fri, 12 Apr 2024 10:34:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A10944437A
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 10:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918068; cv=none; b=hZu6fdwdDzTkDVUgNeivoQ/JdmBvgEra6bOGOtIlfR9WBl2/N/vCa4lzd9YTvTTgHmJgs5bts5W75LgI6318oZEdYgthIaXB4cEZ41O3qLOOXG1GfTHeYXR1aFJQ01sdVoXCMLUI/JlApf+CuoiJ5ZGCrlJbywKP6aF57VM4F3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918068; c=relaxed/simple;
	bh=v2f/4Ra3o+dUV07YPLH2WcBmQZ5fwStfHRq17elLm/s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=K10VO+kTsjLaC6msKneLab5AR2c4tqyobojFM9UgnRYFPfOg1CIINJ2NCdEy6B3dXGqXZmI1oDf5/uQVASGfTVa+lHHBQDV3cXBqRV98QX7wB2tcJc1CeFOzQkehizlI2oXltE04a7JvsnVA39dLTiDpdZ1P9oGP79RLPxTU9Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 887DF113E;
	Fri, 12 Apr 2024 03:34:56 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 409A33F64C;
	Fri, 12 Apr 2024 03:34:25 -0700 (PDT)
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
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvm-unit-tests PATCH 04/33] arm: Make physical address mask dynamic
Date: Fri, 12 Apr 2024 11:33:39 +0100
Message-Id: <20240412103408.2706058-5-suzuki.poulose@arm.com>
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

From: Joey Gouly <joey.gouly@arm.com>

We are about to add Realm support where the physical address width may be known
via RSI. Make the Physical Address mask dynamic, so that it can be adjusted
to the limit for the realm. This will be required for making pages shared, as
we introduce the "sharing" attribute as the top bit of the IPA.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 lib/arm/mmu.c                 | 2 ++
 lib/arm/setup.c               | 1 +
 lib/arm64/asm/pgtable-hwdef.h | 6 ------
 lib/arm64/asm/pgtable.h       | 8 ++++++++
 4 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 9dce7da8..5bbd6d76 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -23,6 +23,8 @@
 
 pgd_t *mmu_idmap;
 
+unsigned long phys_mask_shift = 48;
+
 /* CPU 0 starts with disabled MMU */
 static cpumask_t mmu_enabled_cpumask;
 
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 462a1d51..34381218 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -23,6 +23,7 @@
 #include <asm/thread_info.h>
 #include <asm/setup.h>
 #include <asm/page.h>
+#include <asm/pgtable.h>
 #include <asm/processor.h>
 #include <asm/smp.h>
 #include <asm/timer.h>
diff --git a/lib/arm64/asm/pgtable-hwdef.h b/lib/arm64/asm/pgtable-hwdef.h
index 8c41fe12..ac95550b 100644
--- a/lib/arm64/asm/pgtable-hwdef.h
+++ b/lib/arm64/asm/pgtable-hwdef.h
@@ -115,12 +115,6 @@
 #define PTE_ATTRINDX(t)		(_AT(pteval_t, (t)) << 2)
 #define PTE_ATTRINDX_MASK	(_AT(pteval_t, 7) << 2)
 
-/*
- * Highest possible physical address supported.
- */
-#define PHYS_MASK_SHIFT		(48)
-#define PHYS_MASK		((UL(1) << PHYS_MASK_SHIFT) - 1)
-
 /*
  * TCR flags.
  */
diff --git a/lib/arm64/asm/pgtable.h b/lib/arm64/asm/pgtable.h
index bfb8a993..257fae76 100644
--- a/lib/arm64/asm/pgtable.h
+++ b/lib/arm64/asm/pgtable.h
@@ -21,6 +21,14 @@
 
 #include <linux/compiler.h>
 
+/*
+ * Highest possible physical address supported.
+ */
+extern unsigned long phys_mask_shift;
+#define PHYS_MASK_SHIFT		(phys_mask_shift)
+#define PHYS_MASK		((UL(1) << PHYS_MASK_SHIFT) - 1)
+
+
 /*
  * We can convert va <=> pa page table addresses with simple casts
  * because we always allocate their pages with alloc_page(), and
-- 
2.34.1


