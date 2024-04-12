Return-Path: <kvm+bounces-14423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D825B8A2996
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:45:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8D5C71F23062
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:45:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAB2C56440;
	Fri, 12 Apr 2024 08:42:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C90155C3B;
	Fri, 12 Apr 2024 08:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712911361; cv=none; b=UOWYIwu52C0/UiXYmhf2w/qmM/41Bt7tpWmQxADjtyWp5oMsxvReZd49MeM5+Wv9GokAgntAh9g40GDFKtag6pvCYxvntwt9GlwcCDXdh5b7YaWUThtnIda2+w80xdX2fy52O3xft+SRMf8VZ/K8tM2tlDLcXnt/buqHeE1gJ1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712911361; c=relaxed/simple;
	bh=agngeU8huUmhG9g9+C9VjdJl0iGtBw5GtJfVp2YcLdU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f5qnJllfBTpMpZTTOqH6tkchtKzV/rs+MwYww/xPOD8UgFhYj5tawdR3tbFnzdyB0GN0zmb0nHP/vdOM6HC7t3pCyZ+9cnJcYVLhagftPe3imDiNyT1pSn2ANI6zCbMj18d/c2e35vOrWlImullIaMRMEpGh+To3ePfZ+FNy1Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 74209339;
	Fri, 12 Apr 2024 01:43:07 -0700 (PDT)
Received: from e112269-lin.cambridge.arm.com (e112269-lin.cambridge.arm.com [10.1.194.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1CDD63F6C4;
	Fri, 12 Apr 2024 01:42:36 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v2 07/14] arm64: Make the PHYS_MASK_SHIFT dynamic
Date: Fri, 12 Apr 2024 09:42:06 +0100
Message-Id: <20240412084213.1733764-8-steven.price@arm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240412084213.1733764-1-steven.price@arm.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084213.1733764-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make the PHYS_MASK_SHIFT dynamic for Realms. This is only is required
for masking the PFN from a pte entry. Elsewhere, we could still use the
PA bits configured by the kernel. So, this patch:

 -> renames PHYS_MASK_SHIFT -> MAX_PHYS_SHIFT as supported by the kernel
 -> Makes PHYS_MASK_SHIFT -> Dynamic value of the (I)PA bit width
 -> For a realm: reduces phys_mask_shift if the RMM reports a smaller
    configured size for the guest.

Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h       | 2 +-
 arch/arm64/include/asm/pgtable-hwdef.h | 4 ++--
 arch/arm64/include/asm/pgtable.h       | 5 +++++
 arch/arm64/kernel/rsi.c                | 5 +++++
 4 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index e01bb5ca13b7..9944aca348bd 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -398,7 +398,7 @@
  * bits in PAR are res0.
  */
 #define PAR_TO_HPFAR(par)		\
-	(((par) & GENMASK_ULL(52 - 1, 12)) >> 8)
+	(((par) & GENMASK_ULL(MAX_PHYS_MASK_SHIFT - 1, 12)) >> 8)
 
 #define ECN(x) { ESR_ELx_EC_##x, #x }
 
diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
index ef207a0d4f0d..90dc292bed5f 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -206,8 +206,8 @@
 /*
  * Highest possible physical address supported.
  */
-#define PHYS_MASK_SHIFT		(CONFIG_ARM64_PA_BITS)
-#define PHYS_MASK		((UL(1) << PHYS_MASK_SHIFT) - 1)
+#define MAX_PHYS_MASK_SHIFT	(CONFIG_ARM64_PA_BITS)
+#define MAX_PHYS_MASK		((UL(1) << PHYS_MASK_SHIFT) - 1)
 
 #define TTBR_CNP_BIT		(UL(1) << 0)
 
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index afdd56d26ad7..f5376bd567a1 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -39,6 +39,11 @@
 #include <linux/sched.h>
 #include <linux/page_table_check.h>
 
+extern unsigned int phys_mask_shift;
+
+#define PHYS_MASK_SHIFT		(phys_mask_shift)
+#define PHYS_MASK		((1UL << PHYS_MASK_SHIFT) - 1)
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
 
diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
index b93252ed6fc5..159bc428c77b 100644
--- a/arch/arm64/kernel/rsi.c
+++ b/arch/arm64/kernel/rsi.c
@@ -12,6 +12,8 @@ struct realm_config __attribute((aligned(PAGE_SIZE))) config;
 unsigned long prot_ns_shared;
 EXPORT_SYMBOL(prot_ns_shared);
 
+unsigned int phys_mask_shift = CONFIG_ARM64_PA_BITS;
+
 DEFINE_STATIC_KEY_FALSE_RO(rsi_present);
 EXPORT_SYMBOL(rsi_present);
 
@@ -62,5 +64,8 @@ void __init arm64_rsi_init(void)
 		return;
 	prot_ns_shared = BIT(config.ipa_bits - 1);
 
+	if (config.ipa_bits - 1 < phys_mask_shift)
+		phys_mask_shift = config.ipa_bits - 1;
+
 	static_branch_enable(&rsi_present);
 }
-- 
2.34.1


