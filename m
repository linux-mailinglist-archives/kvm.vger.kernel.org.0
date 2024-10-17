Return-Path: <kvm+bounces-29068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 69C859A2353
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 15:16:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E4B91F281A6
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 13:16:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C25E01D435F;
	Thu, 17 Oct 2024 13:15:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DF941DE89D;
	Thu, 17 Oct 2024 13:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729170911; cv=none; b=IU7nuU3ppQ/c0v5Q9AYTO4qQ0o4gu8wxHR+1gyjNykRqkqCQeLg3t0DZRHU7eUL0zGnxS+CtLsxsHiZGoGq+2VltGqE8+oxapz7qdp7ygK4UGT/4PWEaqYUEcRUmJ9yWEDtTPvM9i9Lku6pW8j/tDPYvOG2GKKMC00urVRbSbAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729170911; c=relaxed/simple;
	bh=kZLwVomqbK0hBV9ZamsUxiHnMd33ArnnjFoi6uwYL3k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XSu7zzC4G33jSALM6AXwix4O2f+HpjAsmFJUB2lsjpbgcziqNf3NObPUKW3v65c5MGH83y2ZI7YopWAo3P7SZkdk8GPG850y76Vz2avS9inbx9Ob5xv/xgGycwZjf24rT1YByj0xiZAlgPSRbQwfEPVQjjdtHWfhLDSjstCj2UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7050BDA7;
	Thu, 17 Oct 2024 06:15:37 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.35.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 34E923F71E;
	Thu, 17 Oct 2024 06:15:04 -0700 (PDT)
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
Subject: [PATCH v7 05/11] arm64: rsi: Map unprotected MMIO as decrypted
Date: Thu, 17 Oct 2024 14:14:28 +0100
Message-Id: <20241017131434.40935-6-steven.price@arm.com>
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

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Instead of marking every MMIO as shared, check if the given region is
"Protected" and apply the permissions accordingly.

Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
New patch for v5
---
 arch/arm64/kernel/rsi.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
index 7e7934c4fca0..3e0c83e2296f 100644
--- a/arch/arm64/kernel/rsi.c
+++ b/arch/arm64/kernel/rsi.c
@@ -6,6 +6,8 @@
 #include <linux/jump_label.h>
 #include <linux/memblock.h>
 #include <linux/psci.h>
+
+#include <asm/io.h>
 #include <asm/rsi.h>
 
 static struct realm_config config;
@@ -93,6 +95,16 @@ bool __arm64_is_protected_mmio(phys_addr_t base, size_t size)
 }
 EXPORT_SYMBOL(__arm64_is_protected_mmio);
 
+static int realm_ioremap_hook(phys_addr_t phys, size_t size, pgprot_t *prot)
+{
+	if (__arm64_is_protected_mmio(phys, size))
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
@@ -103,6 +115,9 @@ void __init arm64_rsi_init(void)
 		return;
 	prot_ns_shared = BIT(config.ipa_bits - 1);
 
+	if (arm64_ioremap_prot_hook_register(realm_ioremap_hook))
+		return;
+
 	arm64_rsi_setup_memory();
 
 	static_branch_enable(&rsi_present);
-- 
2.34.1


