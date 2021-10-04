Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C304215B3
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 19:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235743AbhJDR64 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 13:58:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:36360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235763AbhJDR6x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 13:58:53 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3409461207;
        Mon,  4 Oct 2021 17:57:04 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mXS5I-00EhBv-M7; Mon, 04 Oct 2021 18:49:04 +0100
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
Subject: [PATCH v2 15/16] arm64: Add a helper to retrieve the PTE of a fixmap
Date:   Mon,  4 Oct 2021 18:48:48 +0100
Message-Id: <20211004174849.2831548-16-maz@kernel.org>
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

In order to transfer the early mapping state into KVM's MMIO
guard infrastucture, provide a small helper that will retrieve
the associated PTE.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/fixmap.h |  2 ++
 arch/arm64/mm/mmu.c             | 15 +++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
index 4335800201c9..1aae625b944f 100644
--- a/arch/arm64/include/asm/fixmap.h
+++ b/arch/arm64/include/asm/fixmap.h
@@ -105,6 +105,8 @@ void __init early_fixmap_init(void);
 
 extern void __set_fixmap(enum fixed_addresses idx, phys_addr_t phys, pgprot_t prot);
 
+extern pte_t *__get_fixmap_pte(enum fixed_addresses idx);
+
 #include <asm-generic/fixmap.h>
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index cfd9deb347c3..e7029db5b540 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1286,6 +1286,21 @@ void __set_fixmap(enum fixed_addresses idx,
 	}
 }
 
+pte_t *__get_fixmap_pte(enum fixed_addresses idx)
+{
+	unsigned long addr = __fix_to_virt(idx);
+	pte_t *ptep;
+
+	BUG_ON(idx <= FIX_HOLE || idx >= __end_of_fixed_addresses);
+
+	ptep = fixmap_pte(addr);
+
+	if (!pte_valid(*ptep))
+		return NULL;
+
+	return ptep;
+}
+
 void *__init fixmap_remap_fdt(phys_addr_t dt_phys, int *size, pgprot_t prot)
 {
 	const u64 dt_virt_base = __fix_to_virt(FIX_FDT);
-- 
2.30.2

