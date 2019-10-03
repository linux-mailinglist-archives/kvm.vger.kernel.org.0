Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 509DFC9D56
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 13:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730131AbfJCLch (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 07:32:37 -0400
Received: from foss.arm.com ([217.140.110.172]:42382 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729942AbfJCLch (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 07:32:37 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F1397337;
        Thu,  3 Oct 2019 04:32:36 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EBC503F706;
        Thu,  3 Oct 2019 04:32:35 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, pbonzini@redhat.com, maz@kernel.org,
        mark.rutland@arm.com, andre.przywara@arm.com
Subject: [kvm-unit-tests PATCH v2 2/3] lib: arm/arm64: Add function to clear the PTE_USER bit
Date:   Thu,  3 Oct 2019 12:32:16 +0100
Message-Id: <20191003113217.25464-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191003113217.25464-1-alexandru.elisei@arm.com>
References: <20191003113217.25464-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PTE_USER bit (AP[1]) in a page entry means that lower privilege levels
(EL0, on arm64, or PL0, on arm) can read and write from that memory
location [1][2]. On arm64, it also implies PXN (Privileged execute-never)
when is set [3]. Add a function to clear the bit which we can use when we
want to execute code from that page or the prevent access from lower
exception levels.

Make it available to arm too, in case someone needs it at some point.

[1] ARM DDI 0406C.d, Table B3-6
[2] ARM DDI 0487E.a, table D5-28
[3] ARM DDI 0487E.a, table D5-33

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/asm/mmu-api.h |  1 +
 lib/arm/mmu.c         | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
index df3ccf7bc7e0..8fe85ba31ec9 100644
--- a/lib/arm/asm/mmu-api.h
+++ b/lib/arm/asm/mmu-api.h
@@ -22,4 +22,5 @@ extern void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
 extern void mmu_set_range_ptes(pgd_t *pgtable, uintptr_t virt_offset,
 			       phys_addr_t phys_start, phys_addr_t phys_end,
 			       pgprot_t prot);
+extern void mmu_clear_user(unsigned long vaddr);
 #endif
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 3d38c8397f5a..78db22e6af14 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -217,3 +217,18 @@ unsigned long __phys_to_virt(phys_addr_t addr)
 	assert(!mmu_enabled() || __virt_to_phys(addr) == addr);
 	return addr;
 }
+
+void mmu_clear_user(unsigned long vaddr)
+{
+	pgd_t *pgtable;
+	pteval_t *pte;
+
+	if (!mmu_enabled())
+		return;
+
+	pgtable = current_thread_info()->pgtable;
+	pte = get_pte(pgtable, vaddr);
+
+	*pte &= ~PTE_USER;
+	flush_tlb_page(vaddr);
+}
-- 
2.20.1

