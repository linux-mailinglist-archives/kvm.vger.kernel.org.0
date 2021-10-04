Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62BE94215BC
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 19:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235573AbhJDR7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 13:59:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:36444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235294AbhJDR64 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 13:58:56 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9125D61216;
        Mon,  4 Oct 2021 17:57:07 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mXS5I-00EhBv-9N; Mon, 04 Oct 2021 18:49:04 +0100
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
Subject: [PATCH v2 14/16] arm64: Enroll into KVM's MMIO guard if required
Date:   Mon,  4 Oct 2021 18:48:47 +0100
Message-Id: <20211004174849.2831548-15-maz@kernel.org>
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

Should a guest desire to enroll into the MMIO guard, allow it to
do so with a command-line option.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         |  3 ++
 arch/arm64/Kconfig                            |  1 +
 arch/arm64/include/asm/hypervisor.h           |  1 +
 arch/arm64/kernel/setup.c                     |  6 +++
 arch/arm64/mm/ioremap.c                       | 38 +++++++++++++++++++
 5 files changed, 49 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 91ba391f9b32..62bb25b412a7 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2076,6 +2076,9 @@
 			1 - Bypass the IOMMU for DMA.
 			unset - Use value of CONFIG_IOMMU_DEFAULT_PASSTHROUGH.
 
+	ioremap_guard	[ARM64] enable the KVM MMIO guard functionality
+			if available.
+
 	io7=		[HW] IO7 for Marvel-based Alpha systems
 			See comment before marvel_specify_io7 in
 			arch/alpha/kernel/core_marvel.c.
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 5c7ae4c3954b..4982d21d3c47 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -25,6 +25,7 @@ config ARM64
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_GIGANTIC_PAGE
+	select ARCH_HAS_IOREMAP_PHYS_HOOKS
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_KEEPINITRD
 	select ARCH_HAS_MEMBARRIER_SYNC_CORE
diff --git a/arch/arm64/include/asm/hypervisor.h b/arch/arm64/include/asm/hypervisor.h
index 8e77f411903f..b130c7b82eaa 100644
--- a/arch/arm64/include/asm/hypervisor.h
+++ b/arch/arm64/include/asm/hypervisor.h
@@ -7,5 +7,6 @@
 void kvm_init_hyp_services(void);
 bool kvm_arm_hyp_service_available(u32 func_id);
 void kvm_arm_init_hyp_services(void);
+void kvm_init_ioremap_services(void);
 
 #endif
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index be5f85b0a24d..c325647f675f 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -49,6 +49,7 @@
 #include <asm/tlbflush.h>
 #include <asm/traps.h>
 #include <asm/efi.h>
+#include <asm/hypervisor.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/mmu_context.h>
 
@@ -445,3 +446,8 @@ static int __init register_arm64_panic_block(void)
 	return 0;
 }
 device_initcall(register_arm64_panic_block);
+
+void kvm_arm_init_hyp_services(void)
+{
+	kvm_init_ioremap_services();
+}
diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
index 5334cbdc9f64..62b715ea31e5 100644
--- a/arch/arm64/mm/ioremap.c
+++ b/arch/arm64/mm/ioremap.c
@@ -30,6 +30,44 @@ static DEFINE_STATIC_KEY_FALSE(ioremap_guard_key);
 static DEFINE_XARRAY(ioremap_guard_array);
 static DEFINE_MUTEX(ioremap_guard_lock);
 
+static bool ioremap_guard;
+static int __init ioremap_guard_setup(char *str)
+{
+	ioremap_guard = true;
+
+	return 0;
+}
+early_param("ioremap_guard", ioremap_guard_setup);
+
+void kvm_init_ioremap_services(void)
+{
+	struct arm_smccc_res res;
+
+	if (!ioremap_guard)
+		return;
+
+	/* We need all the functions to be implemented */
+	if (!kvm_arm_hyp_service_available(ARM_SMCCC_KVM_FUNC_MMIO_GUARD_INFO) ||
+	    !kvm_arm_hyp_service_available(ARM_SMCCC_KVM_FUNC_MMIO_GUARD_ENROLL) ||
+	    !kvm_arm_hyp_service_available(ARM_SMCCC_KVM_FUNC_MMIO_GUARD_MAP) ||
+	    !kvm_arm_hyp_service_available(ARM_SMCCC_KVM_FUNC_MMIO_GUARD_UNMAP))
+		return;
+
+	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_INFO_FUNC_ID,
+			     &res);
+	if (res.a0 != PAGE_SIZE)
+		return;
+
+	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_ENROLL_FUNC_ID,
+			     &res);
+	if (res.a0 == SMCCC_RET_SUCCESS) {
+		static_branch_enable(&ioremap_guard_key);
+		pr_info("Using KVM MMIO guard for ioremap\n");
+	} else {
+		pr_warn("KVM MMIO guard registration failed (%ld)\n", res.a0);
+	}
+}
+
 void ioremap_phys_range_hook(phys_addr_t phys_addr, size_t size, pgprot_t prot)
 {
 	if (!static_branch_unlikely(&ioremap_guard_key))
-- 
2.30.2

