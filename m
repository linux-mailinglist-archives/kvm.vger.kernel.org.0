Return-Path: <kvm+bounces-24503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76F6B956BBC
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 15:22:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34205284082
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 13:22:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2EB916C869;
	Mon, 19 Aug 2024 13:20:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC73C16C865;
	Mon, 19 Aug 2024 13:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724073614; cv=none; b=eFBRCkpiVwxKFJdyum0ZOBCMLryVPxGvyn2yrozgvDgdr0cgODt+asbaow4LPpU7Oa4HsEYl7AxuM5QPKQA2RYF+ni6iO7XMuNKyBkAP1+gH1GEzLowUpZfzIdNXQbMSiof4Fqh3zPrQmfH8W/y7SWD7FhxR0cuR/d/OQYEhyBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724073614; c=relaxed/simple;
	bh=H4ZI12wh5KC8ZiyjSPbUMmWL1N8wmgFC/Kz4zTDDNGg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BIbLBadxG8UpkrIIisgji/WC+fu+stHtyAJnNNKgBpt3g1yJCJebhkJqLGHhe3bcmU3zv/pSxDRxT6+owNutE3XDfE+curB0VZ2eUCPLD6BLMKzeNWzOZdJr2X+zXav/yamiJLR165imlU43TgJGgtb4VUkmFAfw1+qsO8mDs6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 19A051063;
	Mon, 19 Aug 2024 06:20:38 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.85.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5EDD83F73B;
	Mon, 19 Aug 2024 06:20:08 -0700 (PDT)
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
Subject: [PATCH v5 07/19] arm64: rsi: Add support for checking whether an MMIO is protected
Date: Mon, 19 Aug 2024 14:19:12 +0100
Message-Id: <20240819131924.372366-8-steven.price@arm.com>
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

From: Suzuki K Poulose <suzuki.poulose@arm.com>

On Arm CCA, with RMM-v1.0, all MMIO regions are shared. However, in
the future, an Arm CCA-v1.0 compliant guest may be run in a lesser
privileged partition in the Realm World (with Arm CCA-v1.1 Planes
feature). In this case, some of the MMIO regions may be emulated
by a higher privileged component in the Realm world, i.e, protected.

Thus the guest must decide today, whether a given MMIO region is shared
vs Protected and create the stage1 mapping accordingly. On Arm CCA, this
detection is based on the "IPA State" (RIPAS == RIPAS_IO). Provide a
helper to run this check on a given range of MMIO.

Also, provide a arm64 helper which may be hooked in by other solutions.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
New patch for v5
---
 arch/arm64/include/asm/io.h       |  8 ++++++++
 arch/arm64/include/asm/rsi.h      |  3 +++
 arch/arm64/include/asm/rsi_cmds.h | 21 +++++++++++++++++++++
 arch/arm64/kernel/rsi.c           | 26 ++++++++++++++++++++++++++
 4 files changed, 58 insertions(+)

diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 1ada23a6ec19..a6c551c5e44e 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -17,6 +17,7 @@
 #include <asm/early_ioremap.h>
 #include <asm/alternative.h>
 #include <asm/cpufeature.h>
+#include <asm/rsi.h>
 
 /*
  * Generic IO read/write.  These perform native-endian accesses.
@@ -318,4 +319,11 @@ extern bool arch_memremap_can_ram_remap(resource_size_t offset, size_t size,
 					unsigned long flags);
 #define arch_memremap_can_ram_remap arch_memremap_can_ram_remap
 
+static inline bool arm64_is_iomem_private(phys_addr_t phys_addr, size_t size)
+{
+	if (unlikely(is_realm_world()))
+		return arm64_rsi_is_protected_mmio(phys_addr, size);
+	return false;
+}
+
 #endif	/* __ASM_IO_H */
diff --git a/arch/arm64/include/asm/rsi.h b/arch/arm64/include/asm/rsi.h
index 2bc013badbc3..e31231b50b6a 100644
--- a/arch/arm64/include/asm/rsi.h
+++ b/arch/arm64/include/asm/rsi.h
@@ -13,6 +13,9 @@ DECLARE_STATIC_KEY_FALSE(rsi_present);
 
 void __init arm64_rsi_init(void);
 void __init arm64_rsi_setup_memory(void);
+
+bool arm64_rsi_is_protected_mmio(phys_addr_t base, size_t size);
+
 static inline bool is_realm_world(void)
 {
 	return static_branch_unlikely(&rsi_present);
diff --git a/arch/arm64/include/asm/rsi_cmds.h b/arch/arm64/include/asm/rsi_cmds.h
index 968b03f4e703..c2363f36d167 100644
--- a/arch/arm64/include/asm/rsi_cmds.h
+++ b/arch/arm64/include/asm/rsi_cmds.h
@@ -45,6 +45,27 @@ static inline unsigned long rsi_get_realm_config(struct realm_config *cfg)
 	return res.a0;
 }
 
+static inline unsigned long rsi_ipa_state_get(phys_addr_t start,
+					      phys_addr_t end,
+					      enum ripas *state,
+					      phys_addr_t *top)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_smc(SMC_RSI_IPA_STATE_GET,
+		      start, end, 0, 0, 0, 0, 0,
+		      &res);
+
+	if (res.a0 == RSI_SUCCESS) {
+		if (top)
+			*top = res.a1;
+		if (state)
+			*state = res.a2;
+	}
+
+	return res.a0;
+}
+
 static inline unsigned long rsi_set_addr_range_state(phys_addr_t start,
 						     phys_addr_t end,
 						     enum ripas state,
diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
index e968a5c9929e..381a5b9a5333 100644
--- a/arch/arm64/kernel/rsi.c
+++ b/arch/arm64/kernel/rsi.c
@@ -67,6 +67,32 @@ void __init arm64_rsi_setup_memory(void)
 	}
 }
 
+bool arm64_rsi_is_protected_mmio(phys_addr_t base, size_t size)
+{
+	enum ripas ripas;
+	phys_addr_t end, top;
+
+	/* Overflow ? */
+	if (WARN_ON(base + size < base))
+		return false;
+
+	end = ALIGN(base + size, RSI_GRANULE_SIZE);
+	base = ALIGN_DOWN(base, RSI_GRANULE_SIZE);
+
+	while (base < end) {
+		if (WARN_ON(rsi_ipa_state_get(base, end, &ripas, &top)))
+			break;
+		if (WARN_ON(top <= base))
+			break;
+		if (ripas != RSI_RIPAS_IO)
+			break;
+		base = top;
+	}
+
+	return (size && base >= end);
+}
+EXPORT_SYMBOL(arm64_rsi_is_protected_mmio);
+
 void __init arm64_rsi_init(void)
 {
 	/*
-- 
2.34.1


