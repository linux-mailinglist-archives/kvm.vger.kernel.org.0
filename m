Return-Path: <kvm+bounces-20774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D8D6891DBCE
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 11:56:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 781781F23597
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 09:56:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CEFC147C79;
	Mon,  1 Jul 2024 09:55:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CF1C1448E1;
	Mon,  1 Jul 2024 09:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719827734; cv=none; b=rp6VAp7KyRWDbwKweQEK89UJp7e9P9F7DUyEMyayLHB3hFVxutfU0MjeqS3S9FUIRMaCs+CEH6MIshm05QphMEn6BpZz2u7yTMDvQOp2qT06U6VaVQTwsoGQsaNNS3am4Fgu9DtbXgCt+OsvpAGoGvRLdi39YT78b0UDx62+eB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719827734; c=relaxed/simple;
	bh=qDdEwFYZEnS4OuyvwmRD/Bk40RHQhIMxPRWL03n70D4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iMJvant/ZAk31oVRoduppjw5Q4XYWrZHG77qL/W7OJiOlXIDgnf6g7prPYkUkap3PexazMXoPg7nokhdt5lN4gyY1IUSW+O9YBDJBjBZzYNHARZECsB3SXY90b9iRk9CAi7oS7J/xZHA/1Zh43R4XfOlHWMGZnrVMZ0EsRUwdxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D67E2367;
	Mon,  1 Jul 2024 02:55:56 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.44.170])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 90FA73F762;
	Mon,  1 Jul 2024 02:55:28 -0700 (PDT)
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
Subject: [PATCH v4 04/15] arm64: realm: Query IPA size from the RMM
Date: Mon,  1 Jul 2024 10:54:54 +0100
Message-Id: <20240701095505.165383-5-steven.price@arm.com>
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

The top bit of the configured IPA size is used as an attribute to
control whether the address is protected or shared. Query the
configuration from the RMM to assertain which bit this is.

Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v2:
 * Drop unneeded extra brackets from PROT_NS_SHARED.
 * Drop the explicit alignment from 'config' as struct realm_config now
   specifies the alignment.
---
 arch/arm64/include/asm/pgtable-prot.h | 3 +++
 arch/arm64/kernel/rsi.c               | 8 ++++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
index b11cfb9fdd37..6c29f3b32eba 100644
--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -70,6 +70,9 @@
 #include <asm/pgtable-types.h>
 
 extern bool arm64_use_ng_mappings;
+extern unsigned long prot_ns_shared;
+
+#define PROT_NS_SHARED		(prot_ns_shared)
 
 #define PTE_MAYBE_NG		(arm64_use_ng_mappings ? PTE_NG : 0)
 #define PMD_MAYBE_NG		(arm64_use_ng_mappings ? PMD_SECT_NG : 0)
diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
index f01bff9dab04..231c1a3ecdeb 100644
--- a/arch/arm64/kernel/rsi.c
+++ b/arch/arm64/kernel/rsi.c
@@ -8,6 +8,11 @@
 #include <linux/psci.h>
 #include <asm/rsi.h>
 
+struct realm_config config;
+
+unsigned long prot_ns_shared;
+EXPORT_SYMBOL(prot_ns_shared);
+
 DEFINE_STATIC_KEY_FALSE_RO(rsi_present);
 EXPORT_SYMBOL(rsi_present);
 
@@ -71,6 +76,9 @@ void __init arm64_rsi_init(void)
 		return;
 	if (!rsi_version_matches())
 		return;
+	if (rsi_get_realm_config(&config))
+		return;
+	prot_ns_shared = BIT(config.ipa_bits - 1);
 
 	static_branch_enable(&rsi_present);
 }
-- 
2.34.1


