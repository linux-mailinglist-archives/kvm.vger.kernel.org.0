Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D90DA1C8B12
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 14:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgEGMgk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 08:36:40 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:48598 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725953AbgEGMgi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 08:36:38 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 98BE86ECF0636A7CEB95;
        Thu,  7 May 2020 20:36:31 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.173.222.27) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Thu, 7 May 2020 20:36:24 +0800
From:   Zenghui Yu <yuzenghui@huawei.com>
To:     <kvmarm@lists.cs.columbia.edu>, <suzuki.poulose@arm.com>
CC:     <maz@kernel.org>, <christoffer.dall@arm.com>,
        <james.morse@arm.com>, <julien.thierry.kdev@gmail.com>,
        <kvm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <wanghaibin.wang@huawei.com>,
        <zhengxiang9@huawei.com>, <amurray@thegoodpenguin.co.uk>,
        <eric.auger@redhat.com>, Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH resend 2/2] KVM: arm64: Unify handling THP backed host memory
Date:   Thu, 7 May 2020 20:35:46 +0800
Message-ID: <20200507123546.1875-3-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
In-Reply-To: <20200507123546.1875-1-yuzenghui@huawei.com>
References: <20200507123546.1875-1-yuzenghui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

We support mapping host memory backed by PMD transparent hugepages
at stage2 as huge pages. However the checks are now spread across
two different places. Let us unify the handling of the THPs to
keep the code cleaner (and future proof for PUD THP support).
This patch moves transparent_hugepage_adjust() closer to the caller
to avoid a forward declaration for fault_supports_stage2_huge_mappings().

Also, since we already handle the case where the host VA and the guest
PA may not be aligned, the explicit VM_BUG_ON() is not required.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 virt/kvm/arm/mmu.c | 115 +++++++++++++++++++++++----------------------
 1 file changed, 60 insertions(+), 55 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 557f36866d1c..93a770fd2b5e 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1372,47 +1372,6 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 	return ret;
 }
 
-static bool transparent_hugepage_adjust(kvm_pfn_t *pfnp, phys_addr_t *ipap)
-{
-	kvm_pfn_t pfn = *pfnp;
-	gfn_t gfn = *ipap >> PAGE_SHIFT;
-
-	if (kvm_is_transparent_hugepage(pfn)) {
-		unsigned long mask;
-		/*
-		 * The address we faulted on is backed by a transparent huge
-		 * page.  However, because we map the compound huge page and
-		 * not the individual tail page, we need to transfer the
-		 * refcount to the head page.  We have to be careful that the
-		 * THP doesn't start to split while we are adjusting the
-		 * refcounts.
-		 *
-		 * We are sure this doesn't happen, because mmu_notifier_retry
-		 * was successful and we are holding the mmu_lock, so if this
-		 * THP is trying to split, it will be blocked in the mmu
-		 * notifier before touching any of the pages, specifically
-		 * before being able to call __split_huge_page_refcount().
-		 *
-		 * We can therefore safely transfer the refcount from PG_tail
-		 * to PG_head and switch the pfn from a tail page to the head
-		 * page accordingly.
-		 */
-		mask = PTRS_PER_PMD - 1;
-		VM_BUG_ON((gfn & mask) != (pfn & mask));
-		if (pfn & mask) {
-			*ipap &= PMD_MASK;
-			kvm_release_pfn_clean(pfn);
-			pfn &= ~mask;
-			kvm_get_pfn(pfn);
-			*pfnp = pfn;
-		}
-
-		return true;
-	}
-
-	return false;
-}
-
 /**
  * stage2_wp_ptes - write protect PMD range
  * @pmd:	pointer to pmd entry
@@ -1660,6 +1619,59 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
 	       (hva & ~(map_size - 1)) + map_size <= uaddr_end;
 }
 
+/*
+ * Check if the given hva is backed by a transparent huge page (THP) and
+ * whether it can be mapped using block mapping in stage2. If so, adjust
+ * the stage2 PFN and IPA accordingly. Only PMD_SIZE THPs are currently
+ * supported. This will need to be updated to support other THP sizes.
+ *
+ * Returns the size of the mapping.
+ */
+static unsigned long
+transparent_hugepage_adjust(struct kvm_memory_slot *memslot,
+			    unsigned long hva, kvm_pfn_t *pfnp,
+			    phys_addr_t *ipap)
+{
+	kvm_pfn_t pfn = *pfnp;
+
+	/*
+	 * Make sure the adjustment is done only for THP pages. Also make
+	 * sure that the HVA and IPA are sufficiently aligned and that the
+	 * block map is contained within the memslot.
+	 */
+	if (kvm_is_transparent_hugepage(pfn) &&
+	    fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
+		/*
+		 * The address we faulted on is backed by a transparent huge
+		 * page.  However, because we map the compound huge page and
+		 * not the individual tail page, we need to transfer the
+		 * refcount to the head page.  We have to be careful that the
+		 * THP doesn't start to split while we are adjusting the
+		 * refcounts.
+		 *
+		 * We are sure this doesn't happen, because mmu_notifier_retry
+		 * was successful and we are holding the mmu_lock, so if this
+		 * THP is trying to split, it will be blocked in the mmu
+		 * notifier before touching any of the pages, specifically
+		 * before being able to call __split_huge_page_refcount().
+		 *
+		 * We can therefore safely transfer the refcount from PG_tail
+		 * to PG_head and switch the pfn from a tail page to the head
+		 * page accordingly.
+		 */
+		*ipap &= PMD_MASK;
+		kvm_release_pfn_clean(pfn);
+		pfn &= ~(PTRS_PER_PMD - 1);
+		kvm_get_pfn(pfn);
+		*pfnp = pfn;
+
+		return PMD_SIZE;
+	}
+
+	/* Use page mapping if we cannot use block mapping. */
+	return PAGE_SIZE;
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
 			  unsigned long fault_status)
@@ -1773,20 +1785,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (mmu_notifier_retry(kvm, mmu_seq))
 		goto out_unlock;
 
-	if (vma_pagesize == PAGE_SIZE && !force_pte) {
-		/*
-		 * Only PMD_SIZE transparent hugepages(THP) are
-		 * currently supported. This code will need to be
-		 * updated to support other THP sizes.
-		 *
-		 * Make sure the host VA and the guest IPA are sufficiently
-		 * aligned and that the block is contained within the memslot.
-		 */
-		if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE) &&
-		    transparent_hugepage_adjust(&pfn, &fault_ipa))
-			vma_pagesize = PMD_SIZE;
-	}
-
+	/*
+	 * If we are not forced to use page mapping, check if we are
+	 * backed by a THP and thus use block mapping if possible.
+	 */
+	if (vma_pagesize == PAGE_SIZE && !force_pte)
+		vma_pagesize = transparent_hugepage_adjust(memslot, hva,
+							   &pfn, &fault_ipa);
 	if (writable)
 		kvm_set_pfn_dirty(pfn);
 
-- 
2.19.1


