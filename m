Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24AF4215C0
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 19:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235823AbhJDR7K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 13:59:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235824AbhJDR7A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 13:59:00 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F44E6124D;
        Mon,  4 Oct 2021 17:57:11 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mXS5H-00EhBv-TR; Mon, 04 Oct 2021 18:49:04 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     will@kernel.org, qperret@google.com, dbrazdil@google.com,
        Steven Price <steven.price@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v2 13/16] arm64: Implement ioremap/iounmap hooks calling into KVM's MMIO guard
Date:   Mon,  4 Oct 2021 18:48:46 +0100
Message-Id: <20211004174849.2831548-14-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211004174849.2831548-1-maz@kernel.org>
References: <20211004174849.2831548-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, will@kernel.org, qperret@google.com, dbrazdil@google.com, steven.price@arm.com, drjones@redhat.com, tabba@google.com, vatsa@codeaurora.org, sdonthineni@nvidia.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement the previously defined ioremap/iounmap hooks for arm64,
calling into KVM's MMIO guard if available.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/mm/ioremap.c | 112 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 112 insertions(+)

diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
index b7c81dacabf0..5334cbdc9f64 100644
--- a/arch/arm64/mm/ioremap.c
+++ b/arch/arm64/mm/ioremap.c
@@ -9,13 +9,125 @@
  * Copyright (C) 2012 ARM Ltd.
  */
 
+#define pr_fmt(fmt)	"ioremap: " fmt
+
 #include <linux/export.h>
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
+#include <linux/slab.h>
 #include <linux/io.h>
+#include <linux/arm-smccc.h>
 
 #include <asm/fixmap.h>
 #include <asm/tlbflush.h>
+#include <asm/hypervisor.h>
+
+struct ioremap_guard_ref {
+	refcount_t	count;
+};
+
+static DEFINE_STATIC_KEY_FALSE(ioremap_guard_key);
+static DEFINE_XARRAY(ioremap_guard_array);
+static DEFINE_MUTEX(ioremap_guard_lock);
+
+void ioremap_phys_range_hook(phys_addr_t phys_addr, size_t size, pgprot_t prot)
+{
+	if (!static_branch_unlikely(&ioremap_guard_key))
+		return;
+
+	if (pfn_valid(__phys_to_pfn(phys_addr)))
+		return;
+
+	mutex_lock(&ioremap_guard_lock);
+
+	while (size) {
+		u64 pfn = phys_addr >> PAGE_SHIFT;
+		struct ioremap_guard_ref *ref;
+		struct arm_smccc_res res;
+
+		ref = xa_load(&ioremap_guard_array, pfn);
+		if (ref) {
+			refcount_inc(&ref->count);
+			goto next;
+		}
+
+		/*
+		 * It is acceptable for the allocation to fail, specially
+		 * if trying to ioremap something very early on, like with
+		 * earlycon, which happens long before kmem_cache_init.
+		 * This page will be permanently accessible, similar to a
+		 * saturated refcount.
+		 */
+		ref = kzalloc(sizeof(*ref), GFP_KERNEL);
+		if (ref) {
+			refcount_set(&ref->count, 1);
+			if (xa_err(xa_store(&ioremap_guard_array, pfn, ref,
+					    GFP_KERNEL))) {
+				kfree(ref);
+				ref = NULL;
+			}
+		}
+
+		arm_smccc_1_1_hvc(ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_MAP_FUNC_ID,
+				  phys_addr, prot, &res);
+		if (res.a0 != SMCCC_RET_SUCCESS) {
+			pr_warn_ratelimited("Failed to register %llx\n",
+					    phys_addr);
+			xa_erase(&ioremap_guard_array, pfn);
+			kfree(ref);
+			goto out;
+		}
+
+	next:
+		size -= PAGE_SIZE;
+		phys_addr += PAGE_SIZE;
+	}
+out:
+	mutex_unlock(&ioremap_guard_lock);
+}
+
+void iounmap_phys_range_hook(phys_addr_t phys_addr, size_t size)
+{
+	if (!static_branch_unlikely(&ioremap_guard_key))
+		return;
+
+	VM_BUG_ON(phys_addr & ~PAGE_MASK || size & ~PAGE_MASK);
+
+	mutex_lock(&ioremap_guard_lock);
+
+	while (size) {
+		u64 pfn = phys_addr >> PAGE_SHIFT;
+		struct ioremap_guard_ref *ref;
+		struct arm_smccc_res res;
+
+		ref = xa_load(&ioremap_guard_array, pfn);
+		if (!ref) {
+			pr_warn_ratelimited("%llx not tracked, left mapped\n",
+					    phys_addr);
+			goto next;
+		}
+
+		if (!refcount_dec_and_test(&ref->count))
+			goto next;
+
+		xa_erase(&ioremap_guard_array, pfn);
+		kfree(ref);
+
+		arm_smccc_1_1_hvc(ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_UNMAP_FUNC_ID,
+				  phys_addr, &res);
+		if (res.a0 != SMCCC_RET_SUCCESS) {
+			pr_warn_ratelimited("Failed to unregister %llx\n",
+					    phys_addr);
+			goto out;
+		}
+
+	next:
+		size -= PAGE_SIZE;
+		phys_addr += PAGE_SIZE;
+	}
+out:
+	mutex_unlock(&ioremap_guard_lock);
+}
 
 static void __iomem *__ioremap_caller(phys_addr_t phys_addr, size_t size,
 				      pgprot_t prot, void *caller)
-- 
2.30.2

