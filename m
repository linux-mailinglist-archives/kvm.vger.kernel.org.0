Return-Path: <kvm+bounces-20777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 40E6391DBD4
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 11:57:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7156A1C22531
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 09:57:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2946314D299;
	Mon,  1 Jul 2024 09:55:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5109E14BF97;
	Mon,  1 Jul 2024 09:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719827742; cv=none; b=V+xghUIGzBycY/teTSW8XI/tZd+YtkRIz3HmtgLJos3Vat00kSDC6Zhk2y5GZZjSe3PAlPIsONW/PUAASUq2NLtSrVH2Pn6qBt5FUl2wWIw103pcIoLl00aso9OOLscxSlQKoyRF7rvCbbsu2U32u1rlGBT9OY2EqGAsTyABanM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719827742; c=relaxed/simple;
	bh=cVh1MxUOGv76W88LdDecLvgPg8RG2FpI/Xa6L4O/K4k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UUAXxQ4vCHHQ6v3GWnc3EBNzZMeYBI6Fz/yE+mJP6NochKLM558X1HTTJO1+sKz7A0mL8rDE6vBtuxypztcCU+wAb+T3Hd7iyOKGv1MGR2Au1JToUjCihLZyrQRz16C3Dk2/DS4e0g8Uu/SJF688Eob2T8gkOTnTpCkKrGX13XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F24A6339;
	Mon,  1 Jul 2024 02:56:05 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.44.170])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6BD143F762;
	Mon,  1 Jul 2024 02:55:38 -0700 (PDT)
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
Subject: [PATCH v4 07/15] arm64: Enforce bounce buffers for realm DMA
Date: Mon,  1 Jul 2024 10:54:57 +0100
Message-Id: <20240701095505.165383-8-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240701095505.165383-1-steven.price@arm.com>
References: <20240701095505.165383-1-steven.price@arm.com>
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
 arch/arm64/kernel/rsi.c |  2 ++
 arch/arm64/mm/init.c    | 10 +++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
index 7ac5fc4a27d0..918db258cd4a 100644
--- a/arch/arm64/kernel/rsi.c
+++ b/arch/arm64/kernel/rsi.c
@@ -6,6 +6,8 @@
 #include <linux/jump_label.h>
 #include <linux/memblock.h>
 #include <linux/psci.h>
+#include <linux/swiotlb.h>
+
 #include <asm/rsi.h>
 
 struct realm_config config;
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


