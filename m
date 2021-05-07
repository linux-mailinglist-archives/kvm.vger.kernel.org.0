Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFDB376437
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 13:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234416AbhEGLFt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 07:05:49 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:18790 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232796AbhEGLFq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 May 2021 07:05:46 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Fc6wJ5cqlzCqry;
        Fri,  7 May 2021 19:02:08 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.224) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Fri, 7 May 2021 19:04:38 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <maz@kernel.org>
CC:     <wanghaibin.wang@huawei.com>
Subject: [PATCH v5 1/2] kvm/arm64: Remove the creation time's mapping of MMIO regions
Date:   Fri, 7 May 2021 19:03:21 +0800
Message-ID: <20210507110322.23348-2-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210507110322.23348-1-zhukeqian1@huawei.com>
References: <20210507110322.23348-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.224]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The MMIO regions may be unmapped for many reasons and can be remapped
by stage2 fault path. Map MMIO regions at creation time becomes a
minor optimization and makes these two mapping path hard to sync.

Remove the mapping code while keep the useful sanity check.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 arch/arm64/kvm/mmu.c | 38 +++-----------------------------------
 1 file changed, 3 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c5d1f3c87dbd..16efd47439a6 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1346,7 +1346,6 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 {
 	hva_t hva = mem->userspace_addr;
 	hva_t reg_end = hva + mem->memory_size;
-	bool writable = !(mem->flags & KVM_MEM_READONLY);
 	int ret = 0;
 
 	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
@@ -1363,8 +1362,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	mmap_read_lock(current->mm);
 	/*
 	 * A memory region could potentially cover multiple VMAs, and any holes
-	 * between them, so iterate over all of them to find out if we can map
-	 * any of them right now.
+	 * between them, so iterate over all of them.
 	 *
 	 *     +--------------------------------------------+
 	 * +---------------+----------------+   +----------------+
@@ -1375,51 +1373,21 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	 */
 	do {
 		struct vm_area_struct *vma;
-		hva_t vm_start, vm_end;
 
 		vma = find_vma_intersection(current->mm, hva, reg_end);
 		if (!vma)
 			break;
 
-		/*
-		 * Take the intersection of this VMA with the memory region
-		 */
-		vm_start = max(hva, vma->vm_start);
-		vm_end = min(reg_end, vma->vm_end);
-
 		if (vma->vm_flags & VM_PFNMAP) {
-			gpa_t gpa = mem->guest_phys_addr +
-				    (vm_start - mem->userspace_addr);
-			phys_addr_t pa;
-
-			pa = (phys_addr_t)vma->vm_pgoff << PAGE_SHIFT;
-			pa += vm_start - vma->vm_start;
-
 			/* IO region dirty page logging not allowed */
 			if (memslot->flags & KVM_MEM_LOG_DIRTY_PAGES) {
 				ret = -EINVAL;
-				goto out;
-			}
-
-			ret = kvm_phys_addr_ioremap(kvm, gpa, pa,
-						    vm_end - vm_start,
-						    writable);
-			if (ret)
 				break;
+			}
 		}
-		hva = vm_end;
+		hva = min(reg_end, vma->vm_end);
 	} while (hva < reg_end);
 
-	if (change == KVM_MR_FLAGS_ONLY)
-		goto out;
-
-	spin_lock(&kvm->mmu_lock);
-	if (ret)
-		unmap_stage2_range(&kvm->arch.mmu, mem->guest_phys_addr, mem->memory_size);
-	else if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
-		stage2_flush_memslot(kvm, memslot);
-	spin_unlock(&kvm->mmu_lock);
-out:
 	mmap_read_unlock(current->mm);
 	return ret;
 }
-- 
2.19.1

