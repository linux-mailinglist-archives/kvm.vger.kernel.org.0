Return-Path: <kvm+bounces-29066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 90CC99A234D
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 15:15:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3C57C1F27CF9
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 13:15:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82C7E1DE4E2;
	Thu, 17 Oct 2024 13:15:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BE041DE2DE;
	Thu, 17 Oct 2024 13:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729170904; cv=none; b=MLgcYxTrqZFixDxp/K8f2VIgWlMVAe4ObNs2DjCmtaq2GanPWOXxuyO484+UeWTWKu7GguzllIh9Oj+CMC1/YfAMYMDivC49JOh1mdvpDuEoGWLeKJL2c2wd/yjKAaQbCVbyvH26ZqayoGFs4cPGtZY117CQqToHAeafOTtAdSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729170904; c=relaxed/simple;
	bh=msPZYsi5mxXMGzWpfy36InsrdSsbA9DEMybUvjzkcpY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lxRjm9LIGECRrNpaHg9hxemicEXhOe+E3WQKdJEJ0tpE6eqHs2NtSiDP9fGUoBRBBDEBEAn8GyirVZpQy1dNsRbsPkIj/p1mrxdPw0Qa2W8Z5DV6SKECRS6+OBxBRK5V8BGKD5a9tSUdrwfUCfgJwfFCCf+rkS9CKPXWZYqgquY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 62CC4FEC;
	Thu, 17 Oct 2024 06:15:29 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.35.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A96893F71E;
	Thu, 17 Oct 2024 06:14:55 -0700 (PDT)
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
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: [PATCH v7 03/11] arm64: realm: Query IPA size from the RMM
Date: Thu, 17 Oct 2024 14:14:26 +0100
Message-Id: <20241017131434.40935-4-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241017131434.40935-1-steven.price@arm.com>
References: <20241017131434.40935-1-steven.price@arm.com>
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

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v4:
 * Make PROT_NS_SHARED check is_realm_world() to reduce impact on
   non-CCA systems.
Changes since v2:
 * Drop unneeded extra brackets from PROT_NS_SHARED.
 * Drop the explicit alignment from 'config' as struct realm_config now
   specifies the alignment.
---
 arch/arm64/include/asm/pgtable-prot.h | 4 ++++
 arch/arm64/kernel/rsi.c               | 8 ++++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
index 2a11d0c10760..820a3b06f08c 100644
--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -68,8 +68,12 @@
 
 #include <asm/cpufeature.h>
 #include <asm/pgtable-types.h>
+#include <asm/rsi.h>
 
 extern bool arm64_use_ng_mappings;
+extern unsigned long prot_ns_shared;
+
+#define PROT_NS_SHARED		(is_realm_world() ? prot_ns_shared : 0)
 
 #define PTE_MAYBE_NG		(arm64_use_ng_mappings ? PTE_NG : 0)
 #define PMD_MAYBE_NG		(arm64_use_ng_mappings ? PMD_SECT_NG : 0)
diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
index c5758317dfed..cea8f0d39591 100644
--- a/arch/arm64/kernel/rsi.c
+++ b/arch/arm64/kernel/rsi.c
@@ -8,6 +8,11 @@
 #include <linux/psci.h>
 #include <asm/rsi.h>
 
+static struct realm_config config;
+
+unsigned long prot_ns_shared;
+EXPORT_SYMBOL(prot_ns_shared);
+
 DEFINE_STATIC_KEY_FALSE_RO(rsi_present);
 EXPORT_SYMBOL(rsi_present);
 
@@ -68,6 +73,9 @@ void __init arm64_rsi_init(void)
 		return;
 	if (!rsi_version_matches())
 		return;
+	if (WARN_ON(rsi_get_realm_config(&config)))
+		return;
+	prot_ns_shared = BIT(config.ipa_bits - 1);
 
 	arm64_rsi_setup_memory();
 
-- 
2.34.1


