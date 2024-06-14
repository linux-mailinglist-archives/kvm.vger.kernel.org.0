Return-Path: <kvm+bounces-19685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8700908DBF
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 16:46:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA2411C202DC
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 14:46:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAE3C3B7A8;
	Fri, 14 Jun 2024 14:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rg3EZ9Lj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27831DA2F;
	Fri, 14 Jun 2024 14:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718376377; cv=none; b=eDvk76kmqyxXSJvImaZIsqbZ8A5lVIi9I6SgPz4FDdVcb4G7J5bQrMMjGf0ttH0U1IzMKH/MTdkt03y0phtDQOvYBwbeiJOCkZuC5ExLfHoi2n5o1+xswPHovWhdDb7d3bqMzmiEi+dFecNxp9hnYDnhmfroSaRcsGxmX/R7b6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718376377; c=relaxed/simple;
	bh=eGezy6hc5/EzmmbNANefFkxJqbVtWCb/pfQGoRmfYj4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O7oFu5bf9vZbd9e2YXz3br99ysuUj+rBAS68xLPyYbU+TNsBMIM7NIRzJTUZq/dwlgdlZqh5u2eVCQVf50ntoyDBj9SR2d+dIYJ1HvqIf07S2znoDHEmSwAMgXivKrGubPQVKVieIhfvpfYLGek6fpvQR9b1TaBfbjB42XyFjXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rg3EZ9Lj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CED5C4AF4D;
	Fri, 14 Jun 2024 14:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718376376;
	bh=eGezy6hc5/EzmmbNANefFkxJqbVtWCb/pfQGoRmfYj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rg3EZ9LjTwM4PVrm65h1gdpiX49z/7bCCHj7StVRYnV3+gybZCINydwYix12t7Gub
	 4STpRmZ64WJXOvPahXaK/fDMq9XP8vFNkiyR80gb2P5KE3bQE4UgphRfW811Gcz3aA
	 Gkf0+v3g5sAgxzn/8BM0uRegQtJgpfcStMjgvsxZaODS13h4CiwPUg8e+NY2nNMpqh
	 3qk9su8h9qHCh9nt1Z7N/9mV5cammtOIB6bZSiMLThbmjpj8mF4H+9EnOVnj9GRfMU
	 62XYgAz2fOJHLxBp1/9qCJ7s9gRuIAx8Mw3emKD3nsKfdfkoVrX2M70AMVtZW3bsKf
	 MGtLhoTikFigQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sI8By-003wb4-HH;
	Fri, 14 Jun 2024 15:46:14 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v3 04/16] KVM: arm64: nv: Unmap/flush shadow stage 2 page tables
Date: Fri, 14 Jun 2024 15:45:40 +0100
Message-Id: <20240614144552.2773592-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240614144552.2773592-1-maz@kernel.org>
References: <20240614144552.2773592-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

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
 arch/arm64/include/asm/kvm_mmu.h    |  2 ++
 arch/arm64/include/asm/kvm_nested.h |  3 +++
 arch/arm64/kvm/mmu.c                | 28 +++++++++++++++----
 arch/arm64/kvm/nested.c             | 42 +++++++++++++++++++++++++++++
 4 files changed, 70 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 87cc941cfd15..216ca424bb16 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -167,6 +167,8 @@ int create_hyp_stack(phys_addr_t phys_addr, unsigned long *haddr);
 void __init free_hyp_pgds(void);
 
 void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size);
+void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end);
+void kvm_stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end);
 
 void stage2_unmap_vm(struct kvm *kvm);
 int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type);
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 82e0484ca26b..6f770405574f 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -113,6 +113,9 @@ extern int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 extern int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
 				    struct kvm_s2_trans *trans);
 extern int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2);
+extern void kvm_nested_s2_wp(struct kvm *kvm);
+extern void kvm_nested_s2_unmap(struct kvm *kvm);
+extern void kvm_nested_s2_flush(struct kvm *kvm);
 
 int kvm_init_nv_sysregs(struct kvm *kvm);
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 5aed2e9d380d..4ed93a384255 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -333,13 +333,18 @@ void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
 	__unmap_stage2_range(mmu, start, size, true);
 }
 
+void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
+{
+	stage2_apply_range_resched(mmu, addr, end, kvm_pgtable_stage2_flush);
+}
+
 static void stage2_flush_memslot(struct kvm *kvm,
 				 struct kvm_memory_slot *memslot)
 {
 	phys_addr_t addr = memslot->base_gfn << PAGE_SHIFT;
 	phys_addr_t end = addr + PAGE_SIZE * memslot->npages;
 
-	stage2_apply_range_resched(&kvm->arch.mmu, addr, end, kvm_pgtable_stage2_flush);
+	kvm_stage2_flush_range(&kvm->arch.mmu, addr, end);
 }
 
 /**
@@ -362,6 +367,8 @@ static void stage2_flush_vm(struct kvm *kvm)
 	kvm_for_each_memslot(memslot, bkt, slots)
 		stage2_flush_memslot(kvm, memslot);
 
+	kvm_nested_s2_flush(kvm);
+
 	write_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
@@ -1035,6 +1042,8 @@ void stage2_unmap_vm(struct kvm *kvm)
 	kvm_for_each_memslot(memslot, bkt, slots)
 		stage2_unmap_memslot(kvm, memslot);
 
+	kvm_nested_s2_unmap(kvm);
+
 	write_unlock(&kvm->mmu_lock);
 	mmap_read_unlock(current->mm);
 	srcu_read_unlock(&kvm->srcu, idx);
@@ -1134,12 +1143,12 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 }
 
 /**
- * stage2_wp_range() - write protect stage2 memory region range
+ * kvm_stage2_wp_range() - write protect stage2 memory region range
  * @mmu:        The KVM stage-2 MMU pointer
  * @addr:	Start address of range
  * @end:	End address of range
  */
-static void stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
+void kvm_stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
 {
 	stage2_apply_range_resched(mmu, addr, end, kvm_pgtable_stage2_wrprotect);
 }
@@ -1170,7 +1179,8 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 	end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
 
 	write_lock(&kvm->mmu_lock);
-	stage2_wp_range(&kvm->arch.mmu, start, end);
+	kvm_stage2_wp_range(&kvm->arch.mmu, start, end);
+	kvm_nested_s2_wp(kvm);
 	write_unlock(&kvm->mmu_lock);
 	kvm_flush_remote_tlbs_memslot(kvm, memslot);
 }
@@ -1224,7 +1234,7 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
-	stage2_wp_range(&kvm->arch.mmu, start, end);
+	kvm_stage2_wp_range(&kvm->arch.mmu, start, end);
 
 	/*
 	 * Eager-splitting is done when manual-protect is set.  We
@@ -1236,6 +1246,8 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	 */
 	if (kvm_dirty_log_manual_protect_and_init_set(kvm))
 		kvm_mmu_split_huge_pages(kvm, start, end);
+
+	kvm_nested_s2_wp(kvm);
 }
 
 static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
@@ -1878,6 +1890,7 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 			     (range->end - range->start) << PAGE_SHIFT,
 			     range->may_block);
 
+	kvm_nested_s2_unmap(kvm);
 	return false;
 }
 
@@ -1891,6 +1904,10 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	return kvm_pgtable_stage2_test_clear_young(kvm->arch.mmu.pgt,
 						   range->start << PAGE_SHIFT,
 						   size, true);
+	/*
+	 * TODO: Handle nested_mmu structures here using the reverse mapping in
+	 * a later version of patch series.
+	 */
 }
 
 bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
@@ -2141,6 +2158,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 
 	write_lock(&kvm->mmu_lock);
 	kvm_stage2_unmap_range(&kvm->arch.mmu, gpa, size);
+	kvm_nested_s2_unmap(kvm);
 	write_unlock(&kvm->mmu_lock);
 }
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 1883276167d0..134477dfe08d 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -527,6 +527,48 @@ int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2)
 	return kvm_inject_nested_sync(vcpu, esr_el2);
 }
 
+void kvm_nested_s2_wp(struct kvm *kvm)
+{
+	int i;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
+		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+
+		if (kvm_s2_mmu_valid(mmu))
+			kvm_stage2_wp_range(mmu, 0, kvm_phys_size(mmu));
+	}
+}
+
+void kvm_nested_s2_unmap(struct kvm *kvm)
+{
+	int i;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
+		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+
+		if (kvm_s2_mmu_valid(mmu))
+			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu));
+	}
+}
+
+void kvm_nested_s2_flush(struct kvm *kvm)
+{
+	int i;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
+		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+
+		if (kvm_s2_mmu_valid(mmu))
+			kvm_stage2_flush_range(mmu, 0, kvm_phys_size(mmu));
+	}
+}
+
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
 	int i;
-- 
2.39.2


