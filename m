Return-Path: <kvm+bounces-24498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01D0C956BB1
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 15:20:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 313F51C226C5
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 13:20:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29B2E16CD27;
	Mon, 19 Aug 2024 13:19:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 397D016B749;
	Mon, 19 Aug 2024 13:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724073592; cv=none; b=bm8v1BYoAOx8oGMjNiqCou0MoRLtko1YZmL6fSB3Q8JM/5/Mwg0hyZoVgTjIuoTJY2dDMGHvlHMraIKXUN3drhpS02t5BeGKriTarY7MJ3DQiF63n/HemcavQJbYwoid5JcRGw9MriJzsU4fDe0+0gKzyy0xIdHW85dl8BRAHuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724073592; c=relaxed/simple;
	bh=sjUJf8BQgocGkc1+uAdqLPxolc2B2H6WtIz9gFiTbXQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=izfxjFmmwZXuJ/fsLQnfh6olUtFrgD8GS1vnzjAXY3RkM7DCAZ5WqqjJufL/UChGuwkRd3PYwgY0QQvSjAow1F3RyGU64mpk/bPgKEStz8ZHvb2vXLaacAfVc/czCrxK5ZzQaD+EqOUNPUIIzkn5c7zaTtkmNJ0v5OIu6v2u9AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A8E5A113E;
	Mon, 19 Aug 2024 06:20:16 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.85.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 36DA83F73B;
	Mon, 19 Aug 2024 06:19:46 -0700 (PDT)
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
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>
Subject: [PATCH v5 02/19] arm64: mm: Add confidential computing hook to ioremap_prot()
Date: Mon, 19 Aug 2024 14:19:07 +0100
Message-Id: <20240819131924.372366-3-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240819131924.372366-1-steven.price@arm.com>
References: <20240819131924.372366-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Will Deacon <will@kernel.org>

Confidential Computing environments such as pKVM and Arm's CCA
distinguish between shared (i.e. emulated) and private (i.e. assigned)
MMIO regions.

Introduce a hook into our implementation of ioremap_prot() so that MMIO
regions can be shared if necessary.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Steven Price <steven.price@arm.com>
---
Patch 'borrowed' from Will's series for pKVM:
https://lore.kernel.org/r/20240730151113.1497-6-will%40kernel.org
---
 arch/arm64/include/asm/io.h |  4 ++++
 arch/arm64/mm/ioremap.c     | 23 ++++++++++++++++++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 41fd90895dfc..1ada23a6ec19 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -271,6 +271,10 @@ __iowrite64_copy(void __iomem *to, const void *from, size_t count)
  * I/O memory mapping functions.
  */
 
+typedef int (*ioremap_prot_hook_t)(phys_addr_t phys_addr, size_t size,
+				   pgprot_t *prot);
+int arm64_ioremap_prot_hook_register(const ioremap_prot_hook_t hook);
+
 #define ioremap_prot ioremap_prot
 
 #define _PAGE_IOREMAP PROT_DEVICE_nGnRE
diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
index 269f2f63ab7d..6cc0b7e7eb03 100644
--- a/arch/arm64/mm/ioremap.c
+++ b/arch/arm64/mm/ioremap.c
@@ -3,10 +3,22 @@
 #include <linux/mm.h>
 #include <linux/io.h>
 
+static ioremap_prot_hook_t ioremap_prot_hook;
+
+int arm64_ioremap_prot_hook_register(ioremap_prot_hook_t hook)
+{
+	if (WARN_ON(ioremap_prot_hook))
+		return -EBUSY;
+
+	ioremap_prot_hook = hook;
+	return 0;
+}
+
 void __iomem *ioremap_prot(phys_addr_t phys_addr, size_t size,
 			   unsigned long prot)
 {
 	unsigned long last_addr = phys_addr + size - 1;
+	pgprot_t pgprot = __pgprot(prot);
 
 	/* Don't allow outside PHYS_MASK */
 	if (last_addr & ~PHYS_MASK)
@@ -16,7 +28,16 @@ void __iomem *ioremap_prot(phys_addr_t phys_addr, size_t size,
 	if (WARN_ON(pfn_is_map_memory(__phys_to_pfn(phys_addr))))
 		return NULL;
 
-	return generic_ioremap_prot(phys_addr, size, __pgprot(prot));
+	/*
+	 * If a hook is registered (e.g. for confidential computing
+	 * purposes), call that now and barf if it fails.
+	 */
+	if (unlikely(ioremap_prot_hook) &&
+	    WARN_ON(ioremap_prot_hook(phys_addr, size, &pgprot))) {
+		return NULL;
+	}
+
+	return generic_ioremap_prot(phys_addr, size, pgprot);
 }
 EXPORT_SYMBOL(ioremap_prot);
 
-- 
2.34.1


