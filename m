Return-Path: <kvm+bounces-14424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 353F78A2998
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:45:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6694F1C23022
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:45:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C88B256B62;
	Fri, 12 Apr 2024 08:42:42 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CEFD4A99C;
	Fri, 12 Apr 2024 08:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712911362; cv=none; b=BxaDZPakbY3GQ0LmLXYgYzm0lgjP5gwnfgfdn1E3MjgIul0+eZOhu/su/gkR6+Li4O1eZ3QzvqSH8SY4OHNU+wZfNyObm7LLJtKyim1jTETGE94sTMf5C6GdHFsLtACI1WrAoSU/2nvjiVussoR2DYwZses1jBLE1FCPwhPULs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712911362; c=relaxed/simple;
	bh=vusBqg8J9e2zgFoPLiI0Ud8E+avtD985TjvvarLHPgI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Qz9m1Oo5JjXfBuwpixU0R1MWlEA+yCg4Bpwrp+Ji7w5ikvVxky84kJ/LtHvjtD/PL95L+NNlcbaKhcq2gLFkT2Gxh+Mg0L6WTiBm3E2qw87d9mDd+I5PgYEE7w65EfU2N52MtZlMO9ktIXkT7yIK1EFhCr1z3l5tOmjh2PlNpzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C66C3113E;
	Fri, 12 Apr 2024 01:43:09 -0700 (PDT)
Received: from e112269-lin.cambridge.arm.com (e112269-lin.cambridge.arm.com [10.1.194.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6F1AE3F6C4;
	Fri, 12 Apr 2024 01:42:38 -0700 (PDT)
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
Subject: [PATCH v2 08/14] arm64: Enforce bounce buffers for realm DMA
Date: Fri, 12 Apr 2024 09:42:07 +0100
Message-Id: <20240412084213.1733764-9-steven.price@arm.com>
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

Within a realm guest it's not possible for a device emulated by the VMM
to access arbitrary guest memory. So force the use of bounce buffers to
ensure that the memory the emulated devices are accessing is in memory
which is explicitly shared with the host.

Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kernel/rsi.c |  2 ++
 arch/arm64/mm/init.c    | 11 +++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
index 159bc428c77b..5c8ed3aaa35f 100644
--- a/arch/arm64/kernel/rsi.c
+++ b/arch/arm64/kernel/rsi.c
@@ -5,6 +5,8 @@
 
 #include <linux/jump_label.h>
 #include <linux/memblock.h>
+#include <linux/swiotlb.h>
+
 #include <asm/rsi.h>
 
 struct realm_config __attribute((aligned(PAGE_SIZE))) config;
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 786fd6ce5f17..01a2e3ce6921 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -370,7 +370,9 @@ void __init bootmem_init(void)
  */
 void __init mem_init(void)
 {
-	bool swiotlb = max_pfn > PFN_DOWN(arm64_dma_phys_limit);
+	bool swiotlb = (max_pfn > PFN_DOWN(arm64_dma_phys_limit));
+
+	swiotlb |= is_realm_world();
 
 	if (IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) && !swiotlb) {
 		/*
@@ -383,7 +385,12 @@ void __init mem_init(void)
 		swiotlb = true;
 	}
 
-	swiotlb_init(swiotlb, SWIOTLB_VERBOSE);
+	if (is_realm_world()) {
+		swiotlb_init(swiotlb, SWIOTLB_VERBOSE | SWIOTLB_FORCE);
+		swiotlb_update_mem_attributes();
+	} else {
+		swiotlb_init(swiotlb, SWIOTLB_VERBOSE);
+	}
 
 	/* this will put all unused low memory onto the freelists */
 	memblock_free_all();
-- 
2.34.1


