Return-Path: <kvm+bounces-27928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90A6A990685
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 16:46:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E6705B24A5A
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 14:46:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 156732207E1;
	Fri,  4 Oct 2024 14:43:51 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03B0821F431;
	Fri,  4 Oct 2024 14:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728053030; cv=none; b=hciszmcLs9X+aXl1OCdJ9doVuAjqQzJ1poFzDSk1gY1/55cWqzf/PhCypM2rnPLYnPVBbPH+f3ha4tx/bmRtkYsZLqMY2Igfm70M04PYlIYIeuotYAX7nl8w59ZrHS62ZdntwjKPoFV7J8GyzgQc611oDqoEk7yEb5fRGRh7xQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728053030; c=relaxed/simple;
	bh=ODJvRYmJGJNMTpJGPR+NNS8Px3aQ57wX3mDurAsVaaA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Z0oNw4K83dllxGQq20bGYUGgYYhx372ivmR3oeB793oJ3tDEHXAAKDHjvj0llWQOMShemA5PPbIaSpeM1mDqEnu0XR0BxFcFWfJAs1C7ejB649y7HFC9w6Bs5gkseBnytLmBb+wJjz5vXAlgGMkQIido7S949kAezzQzk0JqiK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F100C339;
	Fri,  4 Oct 2024 07:44:17 -0700 (PDT)
Received: from e122027.cambridge.arm.com (unknown [10.1.25.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ED6403F58B;
	Fri,  4 Oct 2024 07:43:44 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
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
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH v6 05/11] arm64: rsi: Map unprotected MMIO as decrypted
Date: Fri,  4 Oct 2024 15:43:00 +0100
Message-Id: <20241004144307.66199-6-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241004144307.66199-1-steven.price@arm.com>
References: <20241004144307.66199-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Instead of marking every MMIO as shared, check if the given region is
"Protected" and apply the permissions accordingly.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
New patch for v5
---
 arch/arm64/kernel/rsi.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
index d7bba4cee627..f1add76f89ce 100644
--- a/arch/arm64/kernel/rsi.c
+++ b/arch/arm64/kernel/rsi.c
@@ -6,6 +6,8 @@
 #include <linux/jump_label.h>
 #include <linux/memblock.h>
 #include <linux/psci.h>
+
+#include <asm/io.h>
 #include <asm/rsi.h>
 
 struct realm_config config;
@@ -92,6 +94,16 @@ bool arm64_is_protected_mmio(phys_addr_t base, size_t size)
 }
 EXPORT_SYMBOL(arm64_is_protected_mmio);
 
+static int realm_ioremap_hook(phys_addr_t phys, size_t size, pgprot_t *prot)
+{
+	if (arm64_is_protected_mmio(phys, size))
+		*prot = pgprot_encrypted(*prot);
+	else
+		*prot = pgprot_decrypted(*prot);
+
+	return 0;
+}
+
 void __init arm64_rsi_init(void)
 {
 	if (arm_smccc_1_1_get_conduit() != SMCCC_CONDUIT_SMC)
@@ -102,6 +114,9 @@ void __init arm64_rsi_init(void)
 		return;
 	prot_ns_shared = BIT(config.ipa_bits - 1);
 
+	if (arm64_ioremap_prot_hook_register(realm_ioremap_hook))
+		return;
+
 	arm64_rsi_setup_memory();
 
 	static_branch_enable(&rsi_present);
-- 
2.34.1


