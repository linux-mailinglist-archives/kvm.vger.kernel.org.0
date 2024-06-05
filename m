Return-Path: <kvm+bounces-18867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 937028FC7EF
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 11:36:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 36D95B2933C
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 09:34:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACFD019415E;
	Wed,  5 Jun 2024 09:30:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E88DA194148;
	Wed,  5 Jun 2024 09:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717579853; cv=none; b=STKRiIYqv9BI3gphmj6nrkCDF2x0SccmnBGby2iy6prhECaQ7pwT+/Ht7JOwKNORL4+Pv6DxIBOzRb2kqzPba/G2O5/5AgY8vQEICJG7SUhxsbDDc8c0XKWU0gIihLASxPdc7mBZeQSFceHDkI7+lC7C9Wl2504BVkiZAbkuILQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717579853; c=relaxed/simple;
	bh=EIPGuKk7VNK7SQGYIGM4uDAI+WparEyuijxc1pMH28A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FedoIlr1wRLKq0Tu5AX7Byk+hGNhnZ4AGtHLLZOYk5Lf8eladnZUkej55iF72wpMbcym+nY0dwxmv9EueNj3apW4up0/BsOS04tnU4NQ6EStuY6lUKX63yLzk0MEOGv5i0o95q5F1WktijDmZAGiFPcQ6nrK4r2VN5ik7rmJkwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B8D00DA7;
	Wed,  5 Jun 2024 02:31:15 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.39.129])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DEEA03F792;
	Wed,  5 Jun 2024 02:30:47 -0700 (PDT)
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
Subject: [PATCH v3 08/14] arm64: Enforce bounce buffers for realm DMA
Date: Wed,  5 Jun 2024 10:30:00 +0100
Message-Id: <20240605093006.145492-9-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240605093006.145492-1-steven.price@arm.com>
References: <20240605093006.145492-1-steven.price@arm.com>
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
v3: Simplify mem_init() by using a 'flags' variable.
---
 arch/arm64/kernel/rsi.c | 2 ++
 arch/arm64/mm/init.c    | 9 ++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
index c5c03e8e341a..5cb42609219f 100644
--- a/arch/arm64/kernel/rsi.c
+++ b/arch/arm64/kernel/rsi.c
@@ -5,6 +5,8 @@
 
 #include <linux/jump_label.h>
 #include <linux/memblock.h>
+#include <linux/swiotlb.h>
+
 #include <asm/rsi.h>
 
 struct realm_config config;
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 9d8d38e3bee2..1d595b63da71 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -370,8 +370,14 @@ void __init bootmem_init(void)
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
@@ -383,7 +389,8 @@ void __init mem_init(void)
 		swiotlb = true;
 	}
 
-	swiotlb_init(swiotlb, SWIOTLB_VERBOSE);
+	swiotlb_init(swiotlb, flags);
+	swiotlb_update_mem_attributes();
 
 	/* this will put all unused low memory onto the freelists */
 	memblock_free_all();
-- 
2.34.1


