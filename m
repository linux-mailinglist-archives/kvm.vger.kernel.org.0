Return-Path: <kvm+bounces-24510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A71E1956BD9
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 15:25:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3B4F0B20DAF
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 13:25:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9185718785D;
	Mon, 19 Aug 2024 13:20:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C530616CD18;
	Mon, 19 Aug 2024 13:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724073643; cv=none; b=QCZ+8BFm2VE0Ej6rKF4G2Ac4ferhlWWvRpEIeV4INOHj+hROFT81+Ni+cg8AMBJQ0QKbaSLKXzvzx9jhMymkEqkF6n2U5bkNoDuH4NXBOohu8p9xucUb8r76YSbKfhCRDiihQpLPcxIdYzDBjDq2rdk5jnJWbY9KXZRKmHjzh9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724073643; c=relaxed/simple;
	bh=KaLWr6YZb+PWvDZSNXabheOdGWtip51iowgdcysufRw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YDkFVGJ26CN/kRkY/wIF9S7rwiB8Fiif6rwrqFwN9YbIZrIauNty2oosY9C1vCKBJvI1twKNZPwRNyhEE5vFaQKJ8QH6yzc2zoQUsjpHxMO22y6R6KX4r8tkLSdm+bR4NnD8iuOnLrL/ouWOY0WYYhfhniXZGYNW39QZZ6i3OT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3EE82339;
	Mon, 19 Aug 2024 06:21:07 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.85.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2AAAE3F73B;
	Mon, 19 Aug 2024 06:20:37 -0700 (PDT)
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
Subject: [PATCH v5 14/19] arm64: Enforce bounce buffers for realm DMA
Date: Mon, 19 Aug 2024 14:19:19 +0100
Message-Id: <20240819131924.372366-15-steven.price@arm.com>
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

Within a realm guest it's not possible for a device emulated by the VMM
to access arbitrary guest memory. So force the use of bounce buffers to
ensure that the memory the emulated devices are accessing is in memory
which is explicitly shared with the host.

This adds a call to swiotlb_update_mem_attributes() which calls
set_memory_decrypted() to ensure the bounce buffer memory is shared with
the host. For non-realm guests or hosts this is a no-op.

Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
v3: Simplify mem_init() by using a 'flags' variable.
---
 arch/arm64/kernel/rsi.c |  1 +
 arch/arm64/mm/init.c    | 10 +++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
index 5c2c977a50fb..69d8d9791c65 100644
--- a/arch/arm64/kernel/rsi.c
+++ b/arch/arm64/kernel/rsi.c
@@ -6,6 +6,7 @@
 #include <linux/jump_label.h>
 #include <linux/memblock.h>
 #include <linux/psci.h>
+#include <linux/swiotlb.h>
 
 #include <asm/io.h>
 #include <asm/rsi.h>
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 9b5ab6818f7f..1d595b63da71 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -41,6 +41,7 @@
 #include <asm/kvm_host.h>
 #include <asm/memory.h>
 #include <asm/numa.h>
+#include <asm/rsi.h>
 #include <asm/sections.h>
 #include <asm/setup.h>
 #include <linux/sizes.h>
@@ -369,8 +370,14 @@ void __init bootmem_init(void)
  */
 void __init mem_init(void)
 {
+	unsigned int flags = SWIOTLB_VERBOSE;
 	bool swiotlb = max_pfn > PFN_DOWN(arm64_dma_phys_limit);
 
+	if (is_realm_world()) {
+		swiotlb = true;
+		flags |= SWIOTLB_FORCE;
+	}
+
 	if (IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) && !swiotlb) {
 		/*
 		 * If no bouncing needed for ZONE_DMA, reduce the swiotlb
@@ -382,7 +389,8 @@ void __init mem_init(void)
 		swiotlb = true;
 	}
 
-	swiotlb_init(swiotlb, SWIOTLB_VERBOSE);
+	swiotlb_init(swiotlb, flags);
+	swiotlb_update_mem_attributes();
 
 	/* this will put all unused low memory onto the freelists */
 	memblock_free_all();
-- 
2.34.1


