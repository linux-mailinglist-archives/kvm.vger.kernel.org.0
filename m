Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEF231596AC
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 18:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730327AbgBKRvS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 12:51:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:53522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730316AbgBKRvS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 12:51:18 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3D2120661;
        Tue, 11 Feb 2020 17:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581443476;
        bh=FZe+9NMjAl8Y/akILNFyMXdbM0h07wMHLLUthV7+Lks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kKmW+N/fVhbrnplOWXR+Yzu8VjuHuhGfCRNBryqjOjlACIbsStWTfR3r2e5HEP3Yk
         8d1MJyXbU+phaFoKXozf16fa3/vHEGn/5/JZh0QAyQq/uaEGjefz+yY9ubHZG1c914
         0YO5ndjhAsRjhqkfvbkPwj0OhHZgJPsxP2J+qrvg=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j1Zfs-004O7k-TE; Tue, 11 Feb 2020 17:50:16 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 40/94] KVM: arm64: nv: Unmap/flush shadow stage 2 page tables
Date:   Tue, 11 Feb 2020 17:48:44 +0000
Message-Id: <20200211174938.27809-41-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200211174938.27809-1-maz@kernel.org>
References: <20200211174938.27809-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Christoffer Dall <christoffer.dall@linaro.org>

Unmap/flush shadow stage 2 page tables for the nested VMs as well as the
stage 2 page table for the guest hypervisor.

Note: A bunch of the code in mmu.c relating to MMU notifiers is
currently dealt with in an extremely abrupt way, for example by clearing
out an entire shadow stage-2 table. This will be handled in a more
efficient way using the reverse mapping feature in a later version of
the patch series.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_mmu.h    |  3 ++
 arch/arm64/include/asm/kvm_nested.h |  3 ++
 arch/arm64/kvm/nested.c             | 39 +++++++++++++++++++++++++
 virt/kvm/arm/mmu.c                  | 44 +++++++++++++++++++++++------
 4 files changed, 81 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 868e3386452f..41ff6aa728e3 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -153,6 +153,8 @@ int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
 			   void __iomem **haddr);
 int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
 			     void **haddr);
+void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu,
+			    phys_addr_t addr, phys_addr_t end);
 void free_hyp_pgds(void);
 
 void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size);
@@ -161,6 +163,7 @@ int kvm_alloc_stage2_pgd(struct kvm_s2_mmu *mmu);
 void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
 int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 			  phys_addr_t pa, unsigned long size, bool writable);
+void kvm_stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end);
 
 int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run);
 
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index b2bf82461fa6..20c7c18e99ac 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -48,6 +48,9 @@ extern int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 extern int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
 				    struct kvm_s2_trans *trans);
 extern int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2);
+extern void kvm_nested_s2_wp(struct kvm *kvm);
+extern void kvm_nested_s2_clear(struct kvm *kvm);
+extern void kvm_nested_s2_flush(struct kvm *kvm);
 int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe);
 extern bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg,
 			    u64 control_bit);
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 361c3eb2032c..d7b2e17b54c3 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -510,6 +510,45 @@ int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2)
 	return kvm_inject_nested_sync(vcpu, esr_el2);
 }
 
+/* expects kvm->mmu_lock to be held */
+void kvm_nested_s2_wp(struct kvm *kvm)
+{
+	int i;
+
+	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
+		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+
+		if (kvm_s2_mmu_valid(mmu))
+			kvm_stage2_wp_range(mmu, 0, kvm_phys_size(kvm));
+	}
+}
+
+/* expects kvm->mmu_lock to be held */
+void kvm_nested_s2_clear(struct kvm *kvm)
+{
+	int i;
+
+	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
+		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+
+		if (kvm_s2_mmu_valid(mmu))
+			kvm_unmap_stage2_range(mmu, 0, kvm_phys_size(kvm));
+	}
+}
+
+/* expects kvm->mmu_lock to be held */
+void kvm_nested_s2_flush(struct kvm *kvm)
+{
+	int i;
+
+	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
+		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+
+		if (kvm_s2_mmu_valid(mmu))
+			kvm_stage2_flush_range(mmu, 0, kvm_phys_size(kvm));
+	}
+}
+
 /*
  * Inject wfx to the virtual EL2 if this is not from the virtual EL2 and
  * the virtual HCR_EL2.TWX is set. Otherwise, let the host hypervisor
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index c6db597b925c..054946566dc0 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -420,12 +420,10 @@ static void stage2_flush_puds(struct kvm_s2_mmu *mmu, pgd_t *pgd,
 	} while (pud++, addr = next, addr != end);
 }
 
-static void stage2_flush_memslot(struct kvm_s2_mmu *mmu,
-				 struct kvm_memory_slot *memslot)
+void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu,
+			    phys_addr_t addr, phys_addr_t end)
 {
 	struct kvm *kvm = mmu->kvm;
-	phys_addr_t addr = memslot->base_gfn << PAGE_SHIFT;
-	phys_addr_t end = addr + PAGE_SIZE * memslot->npages;
 	phys_addr_t next;
 	pgd_t *pgd;
 
@@ -437,6 +435,15 @@ static void stage2_flush_memslot(struct kvm_s2_mmu *mmu,
 	} while (pgd++, addr = next, addr != end);
 }
 
+static void stage2_flush_memslot(struct kvm_s2_mmu *mmu,
+				 struct kvm_memory_slot *memslot)
+{
+	phys_addr_t addr = memslot->base_gfn << PAGE_SHIFT;
+	phys_addr_t end = addr + PAGE_SIZE * memslot->npages;
+
+	kvm_stage2_flush_range(mmu, addr, end);
+}
+
 /**
  * stage2_flush_vm - Invalidate cache for pages mapped in stage 2
  * @kvm: The struct kvm pointer
@@ -457,6 +464,8 @@ static void stage2_flush_vm(struct kvm *kvm)
 	kvm_for_each_memslot(memslot, slots)
 		stage2_flush_memslot(&kvm->arch.mmu, memslot);
 
+	kvm_nested_s2_flush(kvm);
+
 	spin_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
@@ -997,6 +1006,8 @@ void stage2_unmap_vm(struct kvm *kvm)
 	kvm_for_each_memslot(memslot, slots)
 		stage2_unmap_memslot(kvm, memslot);
 
+	kvm_nested_s2_clear(kvm);
+
 	spin_unlock(&kvm->mmu_lock);
 	up_read(&current->mm->mmap_sem);
 	srcu_read_unlock(&kvm->srcu, idx);
@@ -1507,12 +1518,12 @@ static void  stage2_wp_puds(struct kvm_s2_mmu *mmu, pgd_t *pgd,
 }
 
 /**
- * stage2_wp_range() - write protect stage2 memory region range
+ * kvm_stage2_wp_range() - write protect stage2 memory region range
  * @kvm:	The KVM pointer
  * @addr:	Start address of range
  * @end:	End address of range
  */
-static void stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
+void kvm_stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
 {
 	struct kvm *kvm = mmu->kvm;
 	pgd_t *pgd;
@@ -1559,7 +1570,8 @@ void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 	phys_addr_t end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
 
 	spin_lock(&kvm->mmu_lock);
-	stage2_wp_range(&kvm->arch.mmu, start, end);
+	kvm_stage2_wp_range(&kvm->arch.mmu, start, end);
+	kvm_nested_s2_wp(kvm);
 	spin_unlock(&kvm->mmu_lock);
 	kvm_flush_remote_tlbs(kvm);
 }
@@ -1583,7 +1595,7 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
 	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
 
-	stage2_wp_range(&kvm->arch.mmu, start, end);
+	kvm_stage2_wp_range(&kvm->arch.mmu, start, end);
 }
 
 /*
@@ -1598,6 +1610,7 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 		gfn_t gfn_offset, unsigned long mask)
 {
 	kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
+	kvm_nested_s2_wp(kvm);
 }
 
 static void clean_dcache_guest_page(kvm_pfn_t pfn, unsigned long size)
@@ -2112,6 +2125,7 @@ static int handle_hva_to_gpa(struct kvm *kvm,
 static int kvm_unmap_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
 {
 	kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, size);
+	kvm_nested_s2_clear(kvm);
 	return 0;
 }
 
@@ -2139,6 +2153,7 @@ static int kvm_set_spte_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data
 	 * through this calling path.
 	 */
 	stage2_set_pte(&kvm->arch.mmu, NULL, gpa, pte, 0);
+	kvm_nested_s2_clear(kvm);
 	return 0;
 }
 
@@ -2181,6 +2196,13 @@ static int kvm_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
 		return stage2_pmdp_test_and_clear_young(pmd);
 	else
 		return stage2_ptep_test_and_clear_young(pte);
+
+	/*
+	 * TODO: Handle nested_mmu structures here using the reverse mapping in
+	 * a later version of patch series.
+	 */
+
+	return stage2_ptep_test_and_clear_young(pte);
 }
 
 static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
@@ -2199,6 +2221,11 @@ static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *
 		return pmd_young(*pmd);
 	else
 		return pte_young(*pte);
+
+	/*
+	 * TODO: Handle nested_mmu structures here using the reverse mapping in
+	 * a later version of patch series.
+	 */
 }
 
 int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
@@ -2453,6 +2480,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 
 	spin_lock(&kvm->mmu_lock);
 	kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, size);
+	kvm_nested_s2_clear(kvm);
 	spin_unlock(&kvm->mmu_lock);
 }
 
-- 
2.20.1

