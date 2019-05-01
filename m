Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2D0010693
	for <lists+kvm@lfdr.de>; Wed,  1 May 2019 11:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfEAJsq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 May 2019 05:48:46 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:55026 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726224AbfEAJsR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 May 2019 05:48:17 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C4F005DC777B751C2BF8;
        Wed,  1 May 2019 17:48:14 +0800 (CST)
Received: from HGHY2Y004646261.china.huawei.com (10.184.12.158) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Wed, 1 May 2019 17:48:07 +0800
From:   Zenghui Yu <yuzenghui@huawei.com>
To:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
CC:     <marc.zyngier@arm.com>, <christoffer.dall@arm.com>,
        <linux@armlinux.org.uk>, <catalin.marinas@arm.com>,
        <will.deacon@arm.com>, <james.morse@arm.com>,
        <julien.thierry@arm.com>, <suzuki.poulose@arm.com>,
        <steve.capper@arm.com>, <wanghaibin.wang@huawei.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 1/5] KVM: arm/arm64: Introduce helpers for page table enties with contiguous bit
Date:   Wed, 1 May 2019 09:44:23 +0000
Message-ID: <1556703867-22396-2-git-send-email-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.6.4.windows.1
In-Reply-To: <1556703867-22396-1-git-send-email-yuzenghui@huawei.com>
References: <1556703867-22396-1-git-send-email-yuzenghui@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce helpers to manipulate stage2 page table entries - set contiguous
bit in the entry and say whether this entry points to a contiguous block.

The helpers are introduced in preparation for supporting contiguous
hugepages at stage2.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 arch/arm/include/asm/kvm_mmu.h   | 22 ++++++++++++++++++++++
 arch/arm64/include/asm/kvm_mmu.h | 20 ++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 31de4ab..80d73ae 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -143,6 +143,28 @@ static inline bool kvm_s2pud_young(pud_t pud)
 	return false;
 }
 
+static inline pte_t kvm_s2pte_mkcont(pte_t pte)
+{
+	BUG();
+	return pte;
+}
+
+static inline bool kvm_s2pte_cont(pte_t pte)
+{
+	return false;
+}
+
+static inline pmd_t kvm_s2pmd_mkcont(pmd_t pmd)
+{
+	BUG();
+	return pmd;
+}
+
+static inline bool kvm_s2pmd_cont(pmd_t pmd)
+{
+	return false;
+}
+
 static inline pte_t kvm_s2pte_mkwrite(pte_t pte)
 {
 	pte_val(pte) |= L_PTE_S2_RDWR;
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index ebeefcf..4afdad9 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -295,6 +295,26 @@ static inline bool kvm_s2pud_young(pud_t pud)
 	return pud_young(pud);
 }
 
+static inline pte_t kvm_s2pte_mkcont(pte_t pte)
+{
+	return pte_mkcont(pte);
+}
+
+static inline bool kvm_s2pte_cont(pte_t pte)
+{
+	return pte_cont(pte);
+}
+
+static inline pmd_t kvm_s2pmd_mkcont(pmd_t pmd)
+{
+	return pmd_mkcont(pmd);
+}
+
+static inline bool kvm_s2pmd_cont(pmd_t pmd)
+{
+	return !!(pmd_val(pmd) & PMD_SECT_CONT);
+}
+
 #define hyp_pte_table_empty(ptep) kvm_page_empty(ptep)
 
 #ifdef __PAGETABLE_PMD_FOLDED
-- 
1.8.3.1


