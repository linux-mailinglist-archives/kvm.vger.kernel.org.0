Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E04B3CA356
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 18:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236360AbhGOQ4z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 12:56:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:48488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236183AbhGOQ4y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jul 2021 12:56:54 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A312F6128D;
        Thu, 15 Jul 2021 16:54:01 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1m44Hc-00DYjr-3c; Thu, 15 Jul 2021 17:32:20 +0100
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
Subject: [PATCH 16/16] arm64: Register earlycon fixmap with the MMIO guard
Date:   Thu, 15 Jul 2021 17:31:59 +0100
Message-Id: <20210715163159.1480168-17-maz@kernel.org>
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

On initialising the MMIO guard infrastructure, register the
earlycon mapping if present.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/mm/ioremap.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
index d82b63bcc554..a27b58e03c93 100644
--- a/arch/arm64/mm/ioremap.c
+++ b/arch/arm64/mm/ioremap.c
@@ -32,6 +32,18 @@ static int __init ioremap_guard_setup(char *str)
 }
 early_param("ioremap_guard", ioremap_guard_setup);
 
+static void fixup_fixmap(void)
+{
+	unsigned long addr = __fix_to_virt(FIX_EARLYCON_MEM_BASE);
+	pte_t *ptep = __get_fixmap_pte(FIX_EARLYCON_MEM_BASE);
+
+	if (!ptep)
+		return;
+
+	ioremap_page_range_hook(addr, addr + PAGE_SIZE, __pte_to_phys(*ptep),
+				__pgprot(pte_val(*ptep) & PTE_ATTRINDX_MASK));
+}
+
 void kvm_init_ioremap_services(void)
 {
 	struct arm_smccc_res res;
@@ -55,6 +67,7 @@ void kvm_init_ioremap_services(void)
 			     &res);
 	if (res.a0 == SMCCC_RET_SUCCESS) {
 		static_branch_enable(&ioremap_guard_key);
+		fixup_fixmap();
 		pr_info("Using KVM MMIO guard for ioremap\n");
 	} else {
 		pr_warn("KVM MMIO guard registration failed (%ld)\n", res.a0);
-- 
2.30.2

