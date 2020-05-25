Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E1F1E0CD0
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 13:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388753AbgEYLZX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 07:25:23 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:47114 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390173AbgEYLZR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 07:25:17 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9506F6CC1EAF105C267D;
        Mon, 25 May 2020 19:25:14 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.173.221.230) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Mon, 25 May 2020 19:25:07 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
CC:     Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <wanghaibin.wang@huawei.com>, <zhengxiang9@huawei.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: [RFC PATCH 6/7] kvm: arm64: Save stage2 PTE dirty info if it is coverred
Date:   Mon, 25 May 2020 19:24:05 +0800
Message-ID: <20200525112406.28224-7-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20200525112406.28224-1-zhukeqian1@huawei.com>
References: <20200525112406.28224-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.221.230]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_set_pte is called to replace a target PTE with a desired one.
We always replace it, but if hw DBM is enalbled and dirty info is
coverred, should let caller know it. Caller can decide to whether
save the dirty info.

kvm_set_pmd and kvm_set_pud is not modified, because we only use
DBM in PTEs for now.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 virt/kvm/arm/mmu.c | 39 +++++++++++++++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index e1d9e4b98cb6..43d89c6333f0 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -185,10 +185,34 @@ static void clear_stage2_pmd_entry(struct kvm *kvm, pmd_t *pmd, phys_addr_t addr
 	put_page(virt_to_page(pmd));
 }
 
-static inline void kvm_set_pte(pte_t *ptep, pte_t new_pte)
+/*
+ * @ret: true if dirty info is coverred.
+ */
+static inline bool kvm_set_pte(pte_t *ptep, pte_t new_pte)
 {
+#ifdef CONFIG_ARM64_HW_AFDBM
+	pteval_t old_pteval, new_pteval, pteval;
+
+	if (!kvm_hw_dbm_enabled() || pte_none(*ptep) ||
+	    !kvm_s2pte_readonly(&new_pte)) {
+		WRITE_ONCE(*ptep, new_pte);
+		dsb(ishst);
+		return false;
+	}
+
+	new_pteval = pte_val(new_pte);
+	pteval = READ_ONCE(pte_val(*ptep));
+	do {
+		old_pteval = pteval;
+		pteval = cmpxchg_relaxed(&pte_val(*ptep), old_pteval, new_pteval);
+	} while (pteval != old_pteval);
+
+	return !kvm_s2pte_readonly((pte_t *)&pteval);
+#else
 	WRITE_ONCE(*ptep, new_pte);
 	dsb(ishst);
+	return false;
+#endif
 }
 
 static inline void kvm_set_pmd(pmd_t *pmdp, pmd_t new_pmd)
@@ -249,7 +273,10 @@ static void unmap_stage2_ptes(struct kvm *kvm, pmd_t *pmd,
 		if (!pte_none(*pte)) {
 			pte_t old_pte = *pte;
 
-			kvm_set_pte(pte, __pte(0));
+			if (kvm_set_pte(pte, __pte(0))) {
+				mark_page_dirty(kvm, addr >> PAGE_SHIFT);
+			}
+
 			kvm_tlb_flush_vmid_ipa(kvm, addr);
 
 			/* No need to invalidate the cache for device mappings */
@@ -1291,13 +1318,17 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 		if (pte_val(old_pte) == pte_val(*new_pte))
 			return 0;
 
-		kvm_set_pte(pte, __pte(0));
+		if (kvm_set_pte(pte, __pte(0))) {
+			mark_page_dirty(kvm, addr >> PAGE_SHIFT);
+		}
 		kvm_tlb_flush_vmid_ipa(kvm, addr);
 	} else {
 		get_page(virt_to_page(pte));
 	}
 
-	kvm_set_pte(pte, *new_pte);
+	if (kvm_set_pte(pte, *new_pte)) {
+		mark_page_dirty(kvm, addr >> PAGE_SHIFT);
+	}
 	return 0;
 }
 
-- 
2.19.1

