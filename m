Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E86E4703A1F
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 19:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244783AbjEORtK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 13:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244671AbjEORsg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 13:48:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A83E4C9ED
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 10:46:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C307962F07
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 17:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A85C4339B;
        Mon, 15 May 2023 17:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684172816;
        bh=ScDz2gjeo40fRTAN1Llgyh+nLXTAgcd4o7hohxfmSCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FuiZJNh5eBqZqXGwM6+PrMxXvqLh4aJFu1gnw2hDhcuFJajUesscP6awuMpCQf6sh
         jvJSQSeBHmZ3v4NlbX/Hc7wdvdITZlSTLeQSIc9HxX5K31OjRVJUeRMwWZ2YGzr5yR
         geAlLa/oVdrzwkFysPIrncf37rN55hnXo7DoJgPPN17XdAUq9qlPbRZuJqPrqYoa4e
         7fWJTLOR5+9DImwy7JhmUUQkYqls7QN7kyKbJxLNWWlb1SwP0dsYaZA+2Whl5rDZWk
         54vQpcYrEa4Ab+rRDzUTbz6/NRAhHT8x/o7Bc3MLr8OXTVouyMMkLWdZDPCJLGcX4x
         Ub3Y2nZpNGnmw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pyc2k-00FJAF-Gx;
        Mon, 15 May 2023 18:31:30 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v10 27/59] KVM: arm64: nv: Handle shadow stage 2 page faults
Date:   Mon, 15 May 2023 18:30:31 +0100
Message-Id: <20230515173103.1017669-28-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230515173103.1017669-1-maz@kernel.org>
References: <20230515173103.1017669-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If we are faulting on a shadow stage 2 translation, we first walk the
guest hypervisor's stage 2 page table to see if it has a mapping. If
not, we inject a stage 2 page fault to the virtual EL2. Otherwise, we
create a mapping in the shadow stage 2 page table.

Note that we have to deal with two IPAs when we got a shadow stage 2
page fault. One is the address we faulted on, and is in the L2 guest
phys space. The other is from the guest stage-2 page table walk, and is
in the L1 guest phys space.  To differentiate them, we rename variables
so that fault_ipa is used for the former and ipa is used for the latter.

Co-developed-by: Christoffer Dall <christoffer.dall@linaro.org>
Co-developed-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
[maz: rewrote this multiple times...]
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h |  6 ++
 arch/arm64/include/asm/kvm_nested.h  | 19 ++++++
 arch/arm64/kvm/mmu.c                 | 89 ++++++++++++++++++++++++----
 arch/arm64/kvm/nested.c              | 48 +++++++++++++++
 4 files changed, 152 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index c64980d33c8b..f4ae0c61fa1c 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -652,4 +652,10 @@ static inline bool vcpu_has_feature(struct kvm_vcpu *vcpu, int feature)
 	return test_bit(feature, vcpu->arch.features);
 }
 
+static inline bool kvm_is_shadow_s2_fault(struct kvm_vcpu *vcpu)
+{
+	return (vcpu->arch.hw_mmu != &vcpu->kvm->arch.mmu &&
+		vcpu->arch.hw_mmu->nested_stage2_enabled);
+}
+
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 5306f7ca5e07..d2cee4faa387 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -76,8 +76,27 @@ struct kvm_s2_trans {
 	u64 upper_attr;
 };
 
+static inline phys_addr_t kvm_s2_trans_output(struct kvm_s2_trans *trans)
+{
+	return trans->output;
+}
+
+static inline unsigned long kvm_s2_trans_size(struct kvm_s2_trans *trans)
+{
+	return trans->block_size;
+}
+
+static inline u32 kvm_s2_trans_esr(struct kvm_s2_trans *trans)
+{
+	return trans->esr;
+}
+
 extern int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 			      struct kvm_s2_trans *result);
+extern int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
+				    struct kvm_s2_trans *trans);
+extern int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2);
+int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe);
 
 extern bool forward_smc_trap(struct kvm_vcpu *vcpu);
 extern bool __check_nv_sr_forward(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 3268936eec40..bc6f004d4ffb 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1253,14 +1253,16 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
 }
 
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
-			  struct kvm_memory_slot *memslot, unsigned long hva,
-			  unsigned long fault_status)
+			  struct kvm_s2_trans *nested,
+			  struct kvm_memory_slot *memslot,
+			  unsigned long hva, unsigned long fault_status)
 {
 	int ret = 0;
 	bool write_fault, writable, force_pte = false;
 	bool exec_fault, mte_allowed;
 	bool device = false;
 	unsigned long mmu_seq;
+	phys_addr_t ipa = fault_ipa;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
 	struct vm_area_struct *vma;
@@ -1345,10 +1347,38 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 	vma_pagesize = 1UL << vma_shift;
+
+	if (nested) {
+		unsigned long max_map_size;
+
+		max_map_size = force_pte ? PUD_SIZE : PAGE_SIZE;
+
+		ipa = kvm_s2_trans_output(nested);
+
+		/*
+		 * If we're about to create a shadow stage 2 entry, then we
+		 * can only create a block mapping if the guest stage 2 page
+		 * table uses at least as big a mapping.
+		 */
+		max_map_size = min(kvm_s2_trans_size(nested), max_map_size);
+
+		/*
+		 * Be careful that if the mapping size falls between
+		 * two host sizes, take the smallest of the two.
+		 */
+		if (max_map_size >= PMD_SIZE && max_map_size < PUD_SIZE)
+			max_map_size = PMD_SIZE;
+		else if (max_map_size >= PAGE_SIZE && max_map_size < PMD_SIZE)
+			max_map_size = PAGE_SIZE;
+
+		force_pte = (max_map_size == PAGE_SIZE);
+		vma_pagesize = min(vma_pagesize, (long)max_map_size);
+	}
+
 	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
 		fault_ipa &= ~(vma_pagesize - 1);
 
-	gfn = fault_ipa >> PAGE_SHIFT;
+	gfn = ipa >> PAGE_SHIFT;
 	mte_allowed = kvm_vma_mte_allowed(vma);
 
 	/* Don't use the VMA after the unlock -- it may have vanished */
@@ -1499,8 +1529,10 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
  */
 int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 {
+	struct kvm_s2_trans nested_trans, *nested = NULL;
 	unsigned long fault_status;
-	phys_addr_t fault_ipa;
+	phys_addr_t fault_ipa; /* The address we faulted on */
+	phys_addr_t ipa; /* Always the IPA in the L1 guest phys space */
 	struct kvm_memory_slot *memslot;
 	unsigned long hva;
 	bool is_iabt, write_fault, writable;
@@ -1509,7 +1541,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 
 	fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
 
-	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
+	ipa = fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
 	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
 
 	if (fault_status == ESR_ELx_FSC_FAULT) {
@@ -1550,6 +1582,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	if (fault_status != ESR_ELx_FSC_FAULT &&
 	    fault_status != ESR_ELx_FSC_PERM &&
 	    fault_status != ESR_ELx_FSC_ACCESS) {
+		/*
+		 * We must never see an address size fault on shadow stage 2
+		 * page table walk, because we would have injected an addr
+		 * size fault when we walked the nested s2 page and not
+		 * create the shadow entry.
+		 */
 		kvm_err("Unsupported FSC: EC=%#x xFSC=%#lx ESR_EL2=%#lx\n",
 			kvm_vcpu_trap_get_class(vcpu),
 			(unsigned long)kvm_vcpu_trap_get_fault(vcpu),
@@ -1559,7 +1597,37 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
 
-	gfn = fault_ipa >> PAGE_SHIFT;
+	/*
+	 * We may have faulted on a shadow stage 2 page table if we are
+	 * running a nested guest.  In this case, we have to resolve the L2
+	 * IPA to the L1 IPA first, before knowing what kind of memory should
+	 * back the L1 IPA.
+	 *
+	 * If the shadow stage 2 page table walk faults, then we simply inject
+	 * this to the guest and carry on.
+	 */
+	if (kvm_is_shadow_s2_fault(vcpu)) {
+		u32 esr;
+
+		ret = kvm_walk_nested_s2(vcpu, fault_ipa, &nested_trans);
+		if (ret) {
+			esr = kvm_s2_trans_esr(&nested_trans);
+			kvm_inject_s2_fault(vcpu, esr);
+			goto out_unlock;
+		}
+
+		ret = kvm_s2_handle_perm_fault(vcpu, &nested_trans);
+		if (ret) {
+			esr = kvm_s2_trans_esr(&nested_trans);
+			kvm_inject_s2_fault(vcpu, esr);
+			goto out_unlock;
+		}
+
+		ipa = kvm_s2_trans_output(&nested_trans);
+		nested = &nested_trans;
+	}
+
+	gfn = ipa >> PAGE_SHIFT;
 	memslot = gfn_to_memslot(vcpu->kvm, gfn);
 	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
 	write_fault = kvm_is_write_fault(vcpu);
@@ -1603,13 +1671,13 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		 * faulting VA. This is always 12 bits, irrespective
 		 * of the page size.
 		 */
-		fault_ipa |= kvm_vcpu_get_hfar(vcpu) & ((1 << 12) - 1);
-		ret = io_mem_abort(vcpu, fault_ipa);
+		ipa |= kvm_vcpu_get_hfar(vcpu) & ((1 << 12) - 1);
+		ret = io_mem_abort(vcpu, ipa);
 		goto out_unlock;
 	}
 
 	/* Userspace should not be able to register out-of-bounds IPAs */
-	VM_BUG_ON(fault_ipa >= kvm_phys_size(vcpu->arch.hw_mmu));
+	VM_BUG_ON(ipa >= kvm_phys_size(vcpu->arch.hw_mmu));
 
 	if (fault_status == ESR_ELx_FSC_ACCESS) {
 		handle_access_fault(vcpu, fault_ipa);
@@ -1617,7 +1685,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		goto out_unlock;
 	}
 
-	ret = user_mem_abort(vcpu, fault_ipa, memslot, hva, fault_status);
+	ret = user_mem_abort(vcpu, fault_ipa, nested,
+			     memslot, hva, fault_status);
 	if (ret == 0)
 		ret = 1;
 out:
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 9ab06055cd35..2538e0c632f2 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -111,6 +111,15 @@ static u32 compute_fsc(int level, u32 fsc)
 	return fsc | (level & 0x3);
 }
 
+static int esr_s2_fault(struct kvm_vcpu *vcpu, int level, u32 fsc)
+{
+	u32 esr;
+
+	esr = kvm_vcpu_get_esr(vcpu) & ~ESR_ELx_FSC;
+	esr |= compute_fsc(level, fsc);
+	return esr;
+}
+
 static int check_base_s2_limits(struct s2_walk_info *wi,
 				int level, int input_size, int stride)
 {
@@ -475,6 +484,45 @@ void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu)
 	}
 }
 
+/*
+ * Returns non-zero if permission fault is handled by injecting it to the next
+ * level hypervisor.
+ */
+int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu, struct kvm_s2_trans *trans)
+{
+	unsigned long fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
+	bool forward_fault = false;
+
+	trans->esr = 0;
+
+	if (fault_status != ESR_ELx_FSC_PERM)
+		return 0;
+
+	if (kvm_vcpu_trap_is_iabt(vcpu)) {
+		forward_fault = (trans->upper_attr & BIT(54));
+	} else {
+		bool write_fault = kvm_is_write_fault(vcpu);
+
+		forward_fault = ((write_fault && !trans->writable) ||
+				 (!write_fault && !trans->readable));
+	}
+
+	if (forward_fault) {
+		trans->esr = esr_s2_fault(vcpu, trans->level, ESR_ELx_FSC_PERM);
+		return 1;
+	}
+
+	return 0;
+}
+
+int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2)
+{
+	vcpu_write_sys_reg(vcpu, vcpu->arch.fault.far_el2, FAR_EL2);
+	vcpu_write_sys_reg(vcpu, vcpu->arch.fault.hpfar_el2, HPFAR_EL2);
+
+	return kvm_inject_nested_sync(vcpu, esr_el2);
+}
+
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
 	int i;
-- 
2.34.1

