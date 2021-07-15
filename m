Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDF03CA353
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 18:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236242AbhGOQ4w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 12:56:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236183AbhGOQ4w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jul 2021 12:56:52 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84887613E9;
        Thu, 15 Jul 2021 16:53:58 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1m44Hb-00DYjr-4J; Thu, 15 Jul 2021 17:32:19 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     will@kernel.org, qperret@google.com, dbrazdil@google.com,
        Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH 13/16] arm64: Implement ioremap/iounmap hooks calling into KVM's MMIO guard
Date:   Thu, 15 Jul 2021 17:31:56 +0100
Message-Id: <20210715163159.1480168-14-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210715163159.1480168-1-maz@kernel.org>
References: <20210715163159.1480168-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, will@kernel.org, qperret@google.com, dbrazdil@google.com, vatsa@codeaurora.org, sdonthineni@nvidia.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement the previously defined ioremap/iounmap hooks for arm64,
calling into KVM's MMIO guard if available.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/mm/ioremap.c | 56 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
index b7c81dacabf0..0801fd92f0e3 100644
--- a/arch/arm64/mm/ioremap.c
+++ b/arch/arm64/mm/ioremap.c
@@ -9,13 +9,69 @@
  * Copyright (C) 2012 ARM Ltd.
  */
 
+#define pr_fmt(fmt)	"ioremap: " fmt
+
 #include <linux/export.h>
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/io.h>
+#include <linux/arm-smccc.h>
 
 #include <asm/fixmap.h>
 #include <asm/tlbflush.h>
+#include <asm/hypervisor.h>
+
+static DEFINE_STATIC_KEY_FALSE(ioremap_guard_key);
+
+void ioremap_page_range_hook(unsigned long addr, unsigned long end,
+			     phys_addr_t phys_addr, pgprot_t prot)
+{
+	size_t size = end - addr;
+
+	if (!static_branch_unlikely(&ioremap_guard_key))
+		return;
+
+	if (pfn_valid(__phys_to_pfn(phys_addr)))
+		return;
+
+	while (size) {
+		struct arm_smccc_res res;
+
+		arm_smccc_1_1_hvc(ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_MAP_FUNC_ID,
+				  phys_addr, prot, &res);
+		if (res.a0 != SMCCC_RET_SUCCESS) {
+			pr_warn_ratelimited("Failed to register %llx\n",
+					    phys_addr);
+			return;
+		}
+
+		size -= PAGE_SIZE;
+		phys_addr += PAGE_SIZE;
+	}
+}
+
+void iounmap_page_range_hook(phys_addr_t phys_addr, size_t size)
+{
+	if (!static_branch_unlikely(&ioremap_guard_key))
+		return;
+
+	VM_BUG_ON(phys_addr & ~PAGE_MASK || size & ~PAGE_MASK);
+
+	while (size) {
+		struct arm_smccc_res res;
+
+		arm_smccc_1_1_hvc(ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_UNMAP_FUNC_ID,
+				  phys_addr, &res);
+		if (res.a0 != SMCCC_RET_SUCCESS) {
+			pr_warn_ratelimited("Failed to unregister %llx\n",
+					    phys_addr);
+			return;
+		}
+
+		size -= PAGE_SIZE;
+		phys_addr += PAGE_SIZE;
+	}
+}
 
 static void __iomem *__ioremap_caller(phys_addr_t phys_addr, size_t size,
 				      pgprot_t prot, void *caller)
-- 
2.30.2

