Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFC942156A
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 19:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236143AbhJDRvD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 13:51:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235315AbhJDRuv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 13:50:51 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CA6A61206;
        Mon,  4 Oct 2021 17:49:02 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mXS5E-00EhBv-FI; Mon, 04 Oct 2021 18:49:00 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     will@kernel.org, qperret@google.com, dbrazdil@google.com,
        Steven Price <steven.price@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v2 04/16] KVM: arm64: Add MMIO checking infrastructure
Date:   Mon,  4 Oct 2021 18:48:37 +0100
Message-Id: <20211004174849.2831548-5-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211004174849.2831548-1-maz@kernel.org>
References: <20211004174849.2831548-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, will@kernel.org, qperret@google.com, dbrazdil@google.com, steven.price@arm.com, drjones@redhat.com, tabba@google.com, vatsa@codeaurora.org, sdonthineni@nvidia.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce the infrastructure required to identify an IPA region
that is expected to be used as an MMIO window.

This include mapping, unmapping and checking the regions. Nothing
calls into it yet, so no expected functional change.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |   2 +
 arch/arm64/include/asm/kvm_mmu.h  |   5 ++
 arch/arm64/kvm/mmu.c              | 109 ++++++++++++++++++++++++++++++
 3 files changed, 116 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f63ca8fb4e58..ba9781eb84d6 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -125,6 +125,8 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER	0
 	/* Memory Tagging Extension enabled for the guest */
 #define KVM_ARCH_FLAG_MTE_ENABLED			1
+	/* Gues has bought into the MMIO guard extension */
+#define KVM_ARCH_FLAG_MMIO_GUARD			2
 	unsigned long flags;
 
 	/*
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 02d378887743..454a6265d45d 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -170,6 +170,11 @@ phys_addr_t kvm_mmu_get_httbr(void);
 phys_addr_t kvm_get_idmap_vector(void);
 int kvm_mmu_init(u32 *hyp_va_bits);
 
+/* MMIO guard */
+bool kvm_install_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa);
+bool kvm_remove_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa);
+bool kvm_check_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa);
+
 static inline void *__kvm_vector_slot2addr(void *base,
 					   enum arm64_hyp_spectre_vector slot)
 {
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1a94a7ca48f2..2470a55ca675 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1172,6 +1172,115 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 		kvm_set_pfn_accessed(pte_pfn(pte));
 }
 
+/* Replace this with something more structured once day */
+#define MMIO_NOTE	(('M' << 24 | 'M' << 16 | 'I' << 8 | 'O') << 1)
+
+bool kvm_install_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa)
+{
+	struct kvm_mmu_memory_cache *memcache;
+	struct kvm_memory_slot *memslot;
+	struct kvm *kvm = vcpu->kvm;
+	int ret, idx;
+
+	if (!test_bit(KVM_ARCH_FLAG_MMIO_GUARD, &kvm->arch.flags))
+		return false;
+
+	/* Must be page-aligned */
+	if (ipa & ~PAGE_MASK)
+		return false;
+
+	/*
+	 * The page cannot be in a memslot. At some point, this will
+	 * have to deal with device mappings though.
+	 */
+	idx = srcu_read_lock(&kvm->srcu);
+	mutex_lock(&kvm->slots_arch_lock);
+	memslot = gfn_to_memslot(kvm, ipa >> PAGE_SHIFT);
+	if (memslot) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* Guest has direct access to the GICv2 virtual CPU interface */
+	if (irqchip_in_kernel(kvm) &&
+	    kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2 &&
+	    ipa == kvm->arch.vgic.vgic_cpu_base) {
+		ret = 0;
+		goto out;
+	}
+
+	memcache = &vcpu->arch.mmu_page_cache;
+	if (kvm_mmu_topup_memory_cache(memcache,
+				       kvm_mmu_cache_min_pages(kvm))) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	spin_lock(&kvm->mmu_lock);
+	ret = kvm_pgtable_stage2_annotate(vcpu->arch.hw_mmu->pgt,
+					  ipa, PAGE_SIZE, memcache,
+					  MMIO_NOTE);
+	spin_unlock(&kvm->mmu_lock);
+
+out:
+	mutex_unlock(&kvm->slots_arch_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
+	return ret == 0;
+}
+
+static bool __check_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa)
+{
+	kvm_pte_t pte = 0;
+	u32 level = 0;
+	int ret;
+
+	lockdep_assert_held(&vcpu->kvm->mmu_lock);
+
+	ret = kvm_pgtable_get_leaf(vcpu->arch.hw_mmu->pgt, ipa, &pte, &level);
+	VM_BUG_ON(ret);
+	VM_BUG_ON(level >= KVM_PGTABLE_MAX_LEVELS);
+
+	/* Must be a PAGE_SIZE mapping with our annotation */
+	return (BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(level)) == PAGE_SIZE &&
+		pte == MMIO_NOTE);
+}
+
+bool kvm_remove_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa)
+{
+	bool ret;
+
+	if (!test_bit(KVM_ARCH_FLAG_MMIO_GUARD, &vcpu->kvm->arch.flags))
+		return false;
+
+	/* Keep the PT locked across the two walks */
+	spin_lock(&vcpu->kvm->mmu_lock);
+
+	ret = __check_ioguard_page(vcpu, ipa);
+	if (ret)		/* Drop the annotation */
+		kvm_pgtable_stage2_unmap(vcpu->arch.hw_mmu->pgt,
+					 ALIGN_DOWN(ipa, PAGE_SIZE), PAGE_SIZE);
+
+	spin_unlock(&vcpu->kvm->mmu_lock);
+	return ret;
+}
+
+bool kvm_check_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa)
+{
+	bool ret;
+
+	if (!test_bit(KVM_ARCH_FLAG_MMIO_GUARD, &vcpu->kvm->arch.flags))
+		return true;
+
+	spin_lock(&vcpu->kvm->mmu_lock);
+	ret = __check_ioguard_page(vcpu, ipa & PAGE_MASK);
+	spin_unlock(&vcpu->kvm->mmu_lock);
+
+	if (!ret)
+		kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
+
+	return ret;
+}
+
 /**
  * kvm_handle_guest_abort - handles all 2nd stage aborts
  * @vcpu:	the VCPU pointer
-- 
2.30.2

