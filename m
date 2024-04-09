Return-Path: <kvm+bounces-14014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B04F489E1EA
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 19:56:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D33A21C21FA0
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 17:56:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CA0E156F44;
	Tue,  9 Apr 2024 17:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kanJgX5P"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D9215697A;
	Tue,  9 Apr 2024 17:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712685322; cv=none; b=qIC+A4BeNf6Hj1dvquyY/OTzos3aBjtiRvuAiMwezQKBd5d5NuR35dK8afTjKeogw9IGo+ANPGb1bqJVrIZy4PG/CuacmwoY2TfREG4OjhttHOnD2D8yPEbbw5DAMvvZs7M5VMrRVb7VCe/t6HS4/iIZTjXeCk7TGKzUIbv03YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712685322; c=relaxed/simple;
	bh=MQIfGMklPnqtMkp3WrYstF+W/WTMooeX0moX8QX9bdo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XQUZeC1Uzcj7eR5Jq2I3D9bbuuZDiJuUu6AO0jstAGLwKF7weRLP1jjcIus513HoqvGuP/Mi9JEH9vOjCWJoVIvXRgs91/jpVgWUDlmwmlmf1xSeAV9jKnkkkb6S+J8NJGFg5jfDejgDmgl9W95frcC0c1Alu2n8ivFgOipqdZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kanJgX5P; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9614FC433C7;
	Tue,  9 Apr 2024 17:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712685322;
	bh=MQIfGMklPnqtMkp3WrYstF+W/WTMooeX0moX8QX9bdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kanJgX5PlF93Ec1/4aIEmbcVh7wWPyVrATPnGEJlY6TpnDqqxsqUu3ESmNWXZZsU9
	 E5pvLdb9wrk22ePj+x4SZxCLyTXf5Iwki1oxS1Cvarn7kFqUvf2N0dLWkCvAsV8afE
	 I+5G/qJzl1bRlm5gGa07x27A/bmrGCla4C+zFcL3HRNN4mlWguxUeVgfxYAB1UUA/Q
	 dai3BDB0hMWEAuMqM8tKB37P4XfDnjTVlP9SGBXzplEb447sRkTJvx90hcCh7XsYPD
	 w+Vrix70uMD1VxkEWbxnfvQz62Dc2ZVsSkf0c32VXohj5VVUxyabB+NNAxDVDhNbFV
	 K1lyQ4pfDu2yA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ruFgm-002szC-Gd;
	Tue, 09 Apr 2024 18:55:20 +0100
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
	Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 04/16] KVM: arm64: nv: Unmap/flush shadow stage 2 page tables
Date: Tue,  9 Apr 2024 18:54:36 +0100
Message-Id: <20240409175448.3507472-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240409175448.3507472-1-maz@kernel.org>
References: <20240409175448.3507472-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, christoffer.dall@arm.com
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
 arch/arm64/include/asm/kvm_mmu.h    |  3 +++
 arch/arm64/include/asm/kvm_nested.h |  3 +++
 arch/arm64/kvm/mmu.c                | 30 +++++++++++++++++----
 arch/arm64/kvm/nested.c             | 42 +++++++++++++++++++++++++++++
 4 files changed, 73 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index b48c9e12e7ff..6975e47f9d4c 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -164,6 +164,8 @@ int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
 int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
 			     void **haddr);
 int create_hyp_stack(phys_addr_t phys_addr, unsigned long *haddr);
+void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu,
+			    phys_addr_t addr, phys_addr_t end);
 void __init free_hyp_pgds(void);
 
 void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size);
@@ -173,6 +175,7 @@ void kvm_uninit_stage2_mmu(struct kvm *kvm);
 void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
 int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 			  phys_addr_t pa, unsigned long size, bool writable);
+void kvm_stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end);
 
 int kvm_handle_guest_abort(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 35044a5dce3f..afb3d0689e17 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -112,6 +112,9 @@ extern int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 extern int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
 				    struct kvm_s2_trans *trans);
 extern int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2);
+extern void kvm_nested_s2_wp(struct kvm *kvm);
+extern void kvm_nested_s2_unmap(struct kvm *kvm);
+extern void kvm_nested_s2_flush(struct kvm *kvm);
 
 int kvm_init_nv_sysregs(struct kvm *kvm);
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index fe2b403e9a14..cf31da306622 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -333,13 +333,19 @@ void kvm_unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
 	__unmap_stage2_range(mmu, start, size, true);
 }
 
+void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu,
+			    phys_addr_t addr, phys_addr_t end)
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
@@ -362,6 +368,8 @@ static void stage2_flush_vm(struct kvm *kvm)
 	kvm_for_each_memslot(memslot, bkt, slots)
 		stage2_flush_memslot(kvm, memslot);
 
+	kvm_nested_s2_flush(kvm);
+
 	write_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
@@ -1042,6 +1050,8 @@ void stage2_unmap_vm(struct kvm *kvm)
 	kvm_for_each_memslot(memslot, bkt, slots)
 		stage2_unmap_memslot(kvm, memslot);
 
+	kvm_nested_s2_unmap(kvm);
+
 	write_unlock(&kvm->mmu_lock);
 	mmap_read_unlock(current->mm);
 	srcu_read_unlock(&kvm->srcu, idx);
@@ -1141,12 +1151,12 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
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
@@ -1177,7 +1187,8 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 	end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
 
 	write_lock(&kvm->mmu_lock);
-	stage2_wp_range(&kvm->arch.mmu, start, end);
+	kvm_stage2_wp_range(&kvm->arch.mmu, start, end);
+	kvm_nested_s2_wp(kvm);
 	write_unlock(&kvm->mmu_lock);
 	kvm_flush_remote_tlbs_memslot(kvm, memslot);
 }
@@ -1231,7 +1242,7 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
-	stage2_wp_range(&kvm->arch.mmu, start, end);
+	kvm_stage2_wp_range(&kvm->arch.mmu, start, end);
 
 	/*
 	 * Eager-splitting is done when manual-protect is set.  We
@@ -1243,6 +1254,8 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	 */
 	if (kvm_dirty_log_manual_protect_and_init_set(kvm))
 		kvm_mmu_split_huge_pages(kvm, start, end);
+
+	kvm_nested_s2_wp(kvm);
 }
 
 static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
@@ -1883,6 +1896,7 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 			     (range->end - range->start) << PAGE_SHIFT,
 			     range->may_block);
 
+	kvm_nested_s2_unmap(kvm);
 	return false;
 }
 
@@ -1917,6 +1931,7 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 			       PAGE_SIZE, __pfn_to_phys(pfn),
 			       KVM_PGTABLE_PROT_R, NULL, 0);
 
+	kvm_nested_s2_unmap(kvm);
 	return false;
 }
 
@@ -1930,6 +1945,10 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	return kvm_pgtable_stage2_test_clear_young(kvm->arch.mmu.pgt,
 						   range->start << PAGE_SHIFT,
 						   size, true);
+	/*
+	 * TODO: Handle nested_mmu structures here using the reverse mapping in
+	 * a later version of patch series.
+	 */
 }
 
 bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
@@ -2180,6 +2199,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 
 	write_lock(&kvm->mmu_lock);
 	kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, size);
+	kvm_nested_s2_unmap(kvm);
 	write_unlock(&kvm->mmu_lock);
 }
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index c2297e696910..3e95f815ad17 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -515,6 +515,48 @@ int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2)
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
+			kvm_unmap_stage2_range(mmu, 0, kvm_phys_size(mmu));
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


