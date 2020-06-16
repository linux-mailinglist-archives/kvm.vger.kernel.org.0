Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC0151FACB4
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 11:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgFPJgW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 05:36:22 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:6264 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728333AbgFPJgU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 05:36:20 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id D41EBD40471D8FD3AFBD;
        Tue, 16 Jun 2020 17:36:18 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.173.221.230) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Tue, 16 Jun 2020 17:36:12 +0800
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
        <liangpeng10@huawei.com>, <zhengxiang9@huawei.com>,
        <wanghaibin.wang@huawei.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH 10/12] KVM: arm64: Save stage2 PTE dirty status if it is coverred
Date:   Tue, 16 Jun 2020 17:35:51 +0800
Message-ID: <20200616093553.27512-11-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20200616093553.27512-1-zhukeqian1@huawei.com>
References: <20200616093553.27512-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.221.230]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are two types of operations will change PTE and may cover
dirty status set by hardware.

1. Stage2 PTE unmapping: Page table merging (revert of huge page
table dissolving), kvm_unmap_hva_range() and so on.

2. Stage2 PTE changing: including user_mem_abort(), kvm_mmu_notifier
_change_pte() and so on.

All operations above will invoke kvm_set_pte() finally. We should
save the dirty status into memslot bitmap.

Question: Should we acquire kvm_slots_lock when invoke mark_page_dirty?
It seems that user_mem_abort does not acquire this lock when invoke it.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 arch/arm64/kvm/mmu.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 898e272a2c07..a230fbcf3889 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -294,15 +294,23 @@ static void unmap_stage2_ptes(struct kvm *kvm, pmd_t *pmd,
 {
 	phys_addr_t start_addr = addr;
 	pte_t *pte, *start_pte;
+	bool dirty_coverred;
+	int idx;
 
 	start_pte = pte = pte_offset_kernel(pmd, addr);
 	do {
 		if (!pte_none(*pte)) {
 			pte_t old_pte = *pte;
 
-			kvm_set_pte(pte, __pte(0));
+			dirty_coverred = kvm_set_pte(pte, __pte(0));
 			kvm_tlb_flush_vmid_ipa(kvm, addr);
 
+			if (dirty_coverred) {
+				idx = srcu_read_lock(&kvm->srcu);
+				mark_page_dirty(kvm, addr >> PAGE_SHIFT);
+				srcu_read_unlock(&kvm->srcu, idx);
+			}
+
 			/* No need to invalidate the cache for device mappings */
 			if (!kvm_is_device_pfn(pte_pfn(old_pte)))
 				kvm_flush_dcache_pte(old_pte);
@@ -1388,6 +1396,8 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 	pte_t *pte, old_pte;
 	bool iomap = flags & KVM_S2PTE_FLAG_IS_IOMAP;
 	bool logging_active = flags & KVM_S2_FLAG_LOGGING_ACTIVE;
+	bool dirty_coverred;
+	int idx;
 
 	VM_BUG_ON(logging_active && !cache);
 
@@ -1453,8 +1463,14 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 		if (pte_val(old_pte) == pte_val(*new_pte))
 			return 0;
 
-		kvm_set_pte(pte, __pte(0));
+		dirty_coverred = kvm_set_pte(pte, __pte(0));
 		kvm_tlb_flush_vmid_ipa(kvm, addr);
+
+		if (dirty_coverred) {
+			idx = srcu_read_lock(&kvm->srcu);
+			mark_page_dirty(kvm, addr >> PAGE_SHIFT);
+			srcu_read_unlock(&kvm->srcu, idx);
+		}
 	} else {
 		get_page(virt_to_page(pte));
 	}
-- 
2.19.1

