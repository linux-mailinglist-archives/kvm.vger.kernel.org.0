Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E66C1068D
	for <lists+kvm@lfdr.de>; Wed,  1 May 2019 11:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbfEAJsX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 May 2019 05:48:23 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:37748 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726336AbfEAJsV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 May 2019 05:48:21 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C6025F73C997A760BED0;
        Wed,  1 May 2019 17:48:19 +0800 (CST)
Received: from HGHY2Y004646261.china.huawei.com (10.184.12.158) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Wed, 1 May 2019 17:48:10 +0800
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
Subject: [PATCH 5/5] KVM: arm/arm64: Add support for creating PMD contiguous hugepages at stage2
Date:   Wed, 1 May 2019 09:44:27 +0000
Message-ID: <1556703867-22396-6-git-send-email-yuzenghui@huawei.com>
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

With this patch, we now support PMD contiguous hugepages at stage2, with
following additional page size at stage2:

                CONT PMD
                --------
 4K granule:      32M
16K granule:       1G
64K granule:      16G

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 virt/kvm/arm/mmu.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index fdd6314..7173589 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1125,6 +1125,66 @@ static pte_t *stage2_get_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
 	return pte_offset_kernel(pmd, addr);
 }
 
+static inline pgprot_t pmd_pgprot(pmd_t pmd)
+{
+	unsigned long pfn = pmd_pfn(pmd);
+
+	return __pgprot(pmd_val(pfn_pmd(pfn, __pgprot(0))) ^ pmd_val(pmd));
+}
+
+static int stage2_set_cont_pmds(struct kvm *kvm, struct kvm_mmu_memory_cache
+				*cache, phys_addr_t addr, const pmd_t *new_pmd)
+{
+	pmd_t *pmd, old_pmd;
+	unsigned long pfn, dpfn;
+	int i;
+	pgprot_t hugeprot;
+	phys_addr_t baddr;
+
+	/* Start with the first pmd. */
+	addr &= CONT_PMD_MASK;
+	pfn = pmd_pfn(*new_pmd);
+	dpfn = PMD_SIZE >> PAGE_SHIFT;
+	hugeprot = pmd_pgprot(*new_pmd);
+
+retry:
+	pmd = stage2_get_pmd(kvm, cache, addr);
+	VM_BUG_ON(!pmd);
+
+	old_pmd = *pmd;
+
+	/* Skip page table update if there is no change */
+	if (pmd_val(old_pmd) == pmd_val(*new_pmd))
+		return 0;
+
+	/*
+	 * baddr and the following loop is for only one scenario:
+	 * logging cancel ... Can we do it better?
+	 */
+	baddr = addr;
+	for (i = 0; i < CONT_PMDS; i++, pmd++, baddr += PMD_SIZE) {
+		if (pmd_present(*pmd) && !pmd_thp_or_huge(*pmd)) {
+			unmap_stage2_range(kvm, baddr, S2_PMD_SIZE);
+			goto retry;
+		}
+	}
+
+	pmd = stage2_get_pmd(kvm, cache, addr);
+
+	for (i = 0; i < CONT_PMDS; i++, pmd++, addr += PMD_SIZE, pfn += dpfn) {
+		if (pmd_present(old_pmd)) {
+			pmd_clear(pmd);
+			kvm_tlb_flush_vmid_ipa(kvm, addr);
+		} else {
+			get_page(virt_to_page(pmd));
+		}
+
+		kvm_set_pmd(pmd, pfn_pmd(pfn, hugeprot));
+	}
+
+	return 0;
+}
+
 static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
 			       *cache, phys_addr_t addr, const pmd_t *new_pmd)
 {
@@ -1894,6 +1954,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * 3 levels, i.e, PMD is not folded.
 	 */
 	if (vma_pagesize == CONT_PTE_SIZE || vma_pagesize == PMD_SIZE ||
+	    vma_pagesize == CONT_PMD_SIZE ||
 	    (vma_pagesize == PUD_SIZE && kvm_stage2_has_pmd(kvm)))
 		gfn = (fault_ipa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
 	up_read(&current->mm->mmap_sem);
@@ -1982,6 +2043,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 						 needs_exec);
 
 		ret = stage2_set_pud_huge(kvm, memcache, fault_ipa, &new_pud);
+	} else if (vma_pagesize == CONT_PMD_SIZE) {
+		pmd_t new_pmd = stage2_build_pmd(pfn, mem_type, writable,
+						 needs_exec, true);
+
+		ret = stage2_set_cont_pmds(kvm, memcache, fault_ipa, &new_pmd);
 	} else if (vma_pagesize == PMD_SIZE) {
 		pmd_t new_pmd = stage2_build_pmd(pfn, mem_type, writable,
 						 needs_exec, false);
-- 
1.8.3.1


