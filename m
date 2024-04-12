Return-Path: <kvm+bounces-14419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 827798A298B
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:43:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 03F35B25773
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:43:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DF575337C;
	Fri, 12 Apr 2024 08:42:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C74A481C2;
	Fri, 12 Apr 2024 08:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712911350; cv=none; b=DxfhaoXwLpXP4GuwdmB7IOx9a/r/bP3JZsQWptZJBjvrZxZU4D5sy7FDWVEkPflbg/MwdEb7MllVxGKKDw8pCTKwdmimtJs8H/YrCow89NI8SaCuZ5CMlBb75jkg6Hvd/7iFi0RoarkAkDn32sfJdAM+SUP5f4m+ifY3XyPJoW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712911350; c=relaxed/simple;
	bh=ljVVIaZArN/KM8bOfapl64lZF2OQzxkvoi0541n+v0w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W/tW6lENETJQZetvHc5FNXedcL38zjHtsGe+/Zv/TjgFyioRbFJHOk2YeEFANs72vv0MLnhdflOS9XIkP/LQ0L6Nw2+ZR6AohRragP5nXCPSaAJNKUQKOzuFpMHUE3n6Jvk6xbdPpNH5HFne/egY8fgXDA8CBwW/z7yMm8nvTFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1D779339;
	Fri, 12 Apr 2024 01:42:58 -0700 (PDT)
Received: from e112269-lin.cambridge.arm.com (e112269-lin.cambridge.arm.com [10.1.194.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BA4E83F6C4;
	Fri, 12 Apr 2024 01:42:26 -0700 (PDT)
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
Subject: [PATCH v2 03/14] arm64: realm: Query IPA size from the RMM
Date: Fri, 12 Apr 2024 09:42:02 +0100
Message-Id: <20240412084213.1733764-4-steven.price@arm.com>
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

The top bit of the configured IPA size is used as an attribute to
control whether the address is protected or shared. Query the
configuration from the RMM to assertain which bit this is.

Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/pgtable-prot.h | 3 +++
 arch/arm64/kernel/rsi.c               | 8 ++++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
index dd9ee67d1d87..15d8f0133af8 100644
--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -63,6 +63,9 @@
 #include <asm/pgtable-types.h>
 
 extern bool arm64_use_ng_mappings;
+extern unsigned long prot_ns_shared;
+
+#define PROT_NS_SHARED		((prot_ns_shared))
 
 #define PTE_MAYBE_NG		(arm64_use_ng_mappings ? PTE_NG : 0)
 #define PMD_MAYBE_NG		(arm64_use_ng_mappings ? PMD_SECT_NG : 0)
diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
index 1076649ac082..b93252ed6fc5 100644
--- a/arch/arm64/kernel/rsi.c
+++ b/arch/arm64/kernel/rsi.c
@@ -7,6 +7,11 @@
 #include <linux/memblock.h>
 #include <asm/rsi.h>
 
+struct realm_config __attribute((aligned(PAGE_SIZE))) config;
+
+unsigned long prot_ns_shared;
+EXPORT_SYMBOL(prot_ns_shared);
+
 DEFINE_STATIC_KEY_FALSE_RO(rsi_present);
 EXPORT_SYMBOL(rsi_present);
 
@@ -53,6 +58,9 @@ void __init arm64_rsi_init(void)
 {
 	if (!rsi_version_matches())
 		return;
+	if (rsi_get_realm_config(&config))
+		return;
+	prot_ns_shared = BIT(config.ipa_bits - 1);
 
 	static_branch_enable(&rsi_present);
 }
-- 
2.34.1


