Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044B133D51B
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 14:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235459AbhCPNoh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 09:44:37 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13547 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235446AbhCPNoM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 09:44:12 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F0DwQ47S1zNngp;
        Tue, 16 Mar 2021 21:41:42 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.184.42) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Tue, 16 Mar 2021 21:43:55 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, Will Deacon <will@kernel.org>,
        Marc Zyngier <maz@kernel.org>
CC:     Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>,
        <yuzenghui@huawei.com>, <lushenming@huawei.com>
Subject: [RFC PATCH v2 1/2] kvm/arm64: Remove the creation time's mapping of MMIO regions
Date:   Tue, 16 Mar 2021 21:43:37 +0800
Message-ID: <20210316134338.18052-2-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210316134338.18052-1-zhukeqian1@huawei.com>
References: <20210316134338.18052-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.184.42]
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
index 8711894db8c2..c59af5ca01b0 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1301,7 +1301,6 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 {
 	hva_t hva = mem->userspace_addr;
 	hva_t reg_end = hva + mem->memory_size;
-	bool writable = !(mem->flags & KVM_MEM_READONLY);
 	int ret = 0;
 
 	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
@@ -1318,8 +1317,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	mmap_read_lock(current->mm);
 	/*
 	 * A memory region could potentially cover multiple VMAs, and any holes
-	 * between them, so iterate over all of them to find out if we can map
-	 * any of them right now.
+	 * between them, so iterate over all of them.
 	 *
 	 *     +--------------------------------------------+
 	 * +---------------+----------------+   +----------------+
@@ -1330,50 +1328,20 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	 */
 	do {
 		struct vm_area_struct *vma = find_vma(current->mm, hva);
-		hva_t vm_start, vm_end;
 
 		if (!vma || vma->vm_start >= reg_end)
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

