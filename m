Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E5F2D61F5
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 17:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391380AbgLJQcm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 11:32:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:33844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391312AbgLJQE6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 11:04:58 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E943F22DA9;
        Thu, 10 Dec 2020 16:03:47 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1knONR-0008Di-Hf; Thu, 10 Dec 2020 16:01:09 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Jintack Lim <jintack.lim@linaro.org>
Subject: [PATCH v3 37/66] KVM: arm64: nv: Unmap/flush shadow stage 2 page tables
Date:   Thu, 10 Dec 2020 15:59:33 +0000
Message-Id: <20201210160002.1407373-38-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210160002.1407373-1-maz@kernel.org>
References: <20201210160002.1407373-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com, christoffer.dall@linaro.org, jintack.lim@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
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
 arch/arm64/include/asm/kvm_mmu.h    |  3 +++
 arch/arm64/include/asm/kvm_nested.h |  3 +++
 arch/arm64/kvm/mmu.c                | 34 ++++++++++++++++++++++---
 arch/arm64/kvm/nested.c             | 39 +++++++++++++++++++++++++++++
 4 files changed, 75 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index ec39015bb2a6..e2c58ad46bd1 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -183,6 +183,8 @@ int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
 			   void __iomem **haddr);
 int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
 			     void **haddr);
+void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu,
+			    phys_addr_t addr, phys_addr_t end);
 void free_hyp_pgds(void);
 
 void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size);
@@ -191,6 +193,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu);
 void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
 int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 			  phys_addr_t pa, unsigned long size, bool writable);
+void kvm_stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end);
 
 int kvm_handle_guest_abort(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 3f3d8e10bd99..2987806850f0 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -114,6 +114,9 @@ extern int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 extern int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
 				    struct kvm_s2_trans *trans);
 extern int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2);
+extern void kvm_nested_s2_wp(struct kvm *kvm);
+extern void kvm_nested_s2_clear(struct kvm *kvm);
+extern void kvm_nested_s2_flush(struct kvm *kvm);
 int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe);
 extern bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg,
 			    u64 control_bit);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6f973efb2cc3..36cb9fa22153 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -141,13 +141,20 @@ void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
 	__unmap_stage2_range(mmu, start, size, true);
 }
 
+void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu,
+			    phys_addr_t addr, phys_addr_t end)
+{
+	stage2_apply_range_resched(mmu->kvm, addr, end, kvm_pgtable_stage2_flush);
+}
+
 static void stage2_flush_memslot(struct kvm *kvm,
 				 struct kvm_memory_slot *memslot)
 {
 	phys_addr_t addr = memslot->base_gfn << PAGE_SHIFT;
 	phys_addr_t end = addr + PAGE_SIZE * memslot->npages;
+	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
 
-	stage2_apply_range_resched(kvm, addr, end, kvm_pgtable_stage2_flush);
+	kvm_stage2_flush_range(mmu, addr, end);
 }
 
 /**
@@ -170,6 +177,8 @@ static void stage2_flush_vm(struct kvm *kvm)
 	kvm_for_each_memslot(memslot, slots)
 		stage2_flush_memslot(kvm, memslot);
 
+	kvm_nested_s2_flush(kvm);
+
 	spin_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
@@ -465,6 +474,8 @@ void stage2_unmap_vm(struct kvm *kvm)
 	kvm_for_each_memslot(memslot, slots)
 		stage2_unmap_memslot(kvm, memslot);
 
+	kvm_nested_s2_clear(kvm);
+
 	spin_unlock(&kvm->mmu_lock);
 	mmap_read_unlock(current->mm);
 	srcu_read_unlock(&kvm->srcu, idx);
@@ -539,7 +550,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
  * @addr:	Start address of range
  * @end:	End address of range
  */
-static void stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
+void kvm_stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
 {
 	struct kvm *kvm = mmu->kvm;
 	stage2_apply_range_resched(kvm, addr, end, kvm_pgtable_stage2_wrprotect);
@@ -571,7 +582,8 @@ void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 	end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
 
 	spin_lock(&kvm->mmu_lock);
-	stage2_wp_range(&kvm->arch.mmu, start, end);
+	kvm_stage2_wp_range(&kvm->arch.mmu, start, end);
+	kvm_nested_s2_wp(kvm);
 	spin_unlock(&kvm->mmu_lock);
 	kvm_flush_remote_tlbs(kvm);
 }
@@ -595,7 +607,7 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
 	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
 
-	stage2_wp_range(&kvm->arch.mmu, start, end);
+	kvm_stage2_wp_range(&kvm->arch.mmu, start, end);
 }
 
 /*
@@ -610,6 +622,7 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 		gfn_t gfn_offset, unsigned long mask)
 {
 	kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
+	kvm_nested_s2_wp(kvm);
 }
 
 static void clean_dcache_guest_page(kvm_pfn_t pfn, unsigned long size)
@@ -1164,6 +1177,7 @@ static int kvm_unmap_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *dat
 	bool may_block = flags & MMU_NOTIFIER_RANGE_BLOCKABLE;
 
 	__unmap_stage2_range(&kvm->arch.mmu, gpa, size, may_block);
+	kvm_nested_s2_clear(kvm);
 	return 0;
 }
 
@@ -1192,6 +1206,7 @@ static int kvm_set_spte_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data
 	 */
 	kvm_pgtable_stage2_map(kvm->arch.mmu.pgt, gpa, PAGE_SIZE,
 			       __pfn_to_phys(*pfn), KVM_PGTABLE_PROT_R, NULL);
+	kvm_nested_s2_clear(kvm);
 	return 0;
 }
 
@@ -1223,12 +1238,22 @@ static int kvm_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
 	kpte = kvm_pgtable_stage2_mkold(kvm->arch.mmu.pgt, gpa);
 	pte = __pte(kpte);
 	return pte_valid(pte) && pte_young(pte);
+
+	/*
+	 * TODO: Handle nested_mmu structures here using the reverse mapping in
+	 * a later version of patch series.
+	 */
 }
 
 static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
 {
 	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
 	return kvm_pgtable_stage2_is_young(kvm->arch.mmu.pgt, gpa);
+
+	/*
+	 * TODO: Handle nested_mmu structures here using the reverse mapping in
+	 * a later version of patch series.
+	 */
 }
 
 int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
@@ -1457,6 +1482,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 
 	spin_lock(&kvm->mmu_lock);
 	kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, size);
+	kvm_nested_s2_clear(kvm);
 	spin_unlock(&kvm->mmu_lock);
 }
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 551aee363cc3..e78c6c093afc 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -505,6 +505,45 @@ int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2)
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
-- 
2.29.2

