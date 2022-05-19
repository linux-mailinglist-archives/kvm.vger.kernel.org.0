Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 289E952D4B9
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbiESNqS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232298AbiESNo4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:44:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFBBD02AD
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:44:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D519B824AA
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA714C34116;
        Thu, 19 May 2022 13:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967856;
        bh=XiJyGdjmz/udxli+VDDlv2mvjpHlKF0LXKV580K0H/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o35ZVjNgcp6WbMMfwaQ8Z+yMSMZng8itxBUf8cnEvIIA2fC7eyymbhyw+YSWUV8Nk
         0DijcvQAsZQYX9Xqyo6Dlhht88ylyzMk3QxV+ulGlTOc6tmNKE+B5fUGMRTS7tGv/t
         9Pq4cQwSrRu6bJPX5nlRa+jXiXoHwqRDaa6xJGiAg+tyTpCgDZvuMNjp4PDLgibu6S
         sBjmLsA1KBbE9BHI3pg7IkPRXRfRGeo636pOYBlMfHF8drGbAS+vn2MvkLg79JArGy
         7pRQ3txaBlLLSK/KU4dOYkHV2+865VxTaBGfFVQoXUk9sFqz5xxtqs4MlXe+xcwbTC
         QpJtpd9xbkNIQ==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 28/89] KVM: arm64: Consolidate stage-2 init in one function
Date:   Thu, 19 May 2022 14:41:03 +0100
Message-Id: <20220519134204.5379-29-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Quentin Perret <qperret@google.com>

The initialization of stage-2 page-tables of guests is currently split
across two functions: kvm_init_stage2_mmu() and kvm_arm_setup_stage2().
That is presumably for historical reasons as kvm_arm_setup_stage2()
originates from the (now defunct) KVM port for 32bit Arm.

Simplify this code path by merging both functions into one, and while at
it make sure to map the kvm struct into the hypervisor stage-1 early on
to simplify the failure path.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_arm.h  |  2 +-
 arch/arm64/include/asm/kvm_host.h |  2 --
 arch/arm64/include/asm/kvm_mmu.h  |  2 +-
 arch/arm64/kvm/arm.c              | 27 +++++++++++++--------------
 arch/arm64/kvm/mmu.c              | 27 ++++++++++++++++++++++++++-
 arch/arm64/kvm/reset.c            | 29 -----------------------------
 6 files changed, 41 insertions(+), 48 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 1767ded83888..98b60fa86853 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -134,7 +134,7 @@
  * 40 bits wide (T0SZ = 24).  Systems with a PARange smaller than 40 bits are
  * not known to exist and will break with this configuration.
  *
- * The VTCR_EL2 is configured per VM and is initialised in kvm_arm_setup_stage2().
+ * The VTCR_EL2 is configured per VM and is initialised in kvm_init_stage2_mmu.
  *
  * Note that when using 4K pages, we concatenate two first level page tables
  * together. With 16K pages, we concatenate 16 first level page tables.
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 264b1d2c4eb6..3c6ed1f3887d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -865,8 +865,6 @@ int kvm_set_ipa_limit(void);
 #define __KVM_HAVE_ARCH_VM_ALLOC
 struct kvm *kvm_arch_alloc_vm(void);
 
-int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type);
-
 static inline bool kvm_vm_is_protected(struct kvm *kvm)
 {
 	return false;
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 74735a864eee..eaac8dec97de 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -162,7 +162,7 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
 void free_hyp_pgds(void);
 
 void stage2_unmap_vm(struct kvm *kvm);
-int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu);
+int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type);
 void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
 int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 			  phys_addr_t pa, unsigned long size, bool writable);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 6a32eaf768e5..694ba3792e9d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -135,28 +135,24 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	int ret;
 
-	ret = kvm_arm_setup_stage2(kvm, type);
-	if (ret)
-		return ret;
-
-	ret = kvm_init_stage2_mmu(kvm, &kvm->arch.mmu);
-	if (ret)
-		return ret;
-
 	ret = kvm_share_hyp(kvm, kvm + 1);
 	if (ret)
-		goto out_free_stage2_pgd;
+		return ret;
 
 	ret = kvm_init_pvm(kvm);
 	if (ret)
-		goto out_free_stage2_pgd;
+		goto err_unshare_kvm;
 
 	if (!zalloc_cpumask_var(&kvm->arch.supported_cpus, GFP_KERNEL)) {
 		ret = -ENOMEM;
-		goto out_free_stage2_pgd;
+		goto err_unshare_kvm;
 	}
 	cpumask_copy(kvm->arch.supported_cpus, cpu_possible_mask);
 
+	ret = kvm_init_stage2_mmu(kvm, &kvm->arch.mmu, type);
+	if (ret)
+		goto err_free_cpumask;
+
 	kvm_vgic_early_init(kvm);
 
 	/* The maximum number of VCPUs is limited by the host's GIC model */
@@ -164,9 +160,12 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	set_default_spectre(kvm);
 
-	return ret;
-out_free_stage2_pgd:
-	kvm_free_stage2_pgd(&kvm->arch.mmu);
+	return 0;
+
+err_free_cpumask:
+	free_cpumask_var(kvm->arch.supported_cpus);
+err_unshare_kvm:
+	kvm_unshare_hyp(kvm, kvm + 1);
 	return ret;
 }
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index e77686d54e9f..0071f035dde8 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -618,15 +618,40 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
  * kvm_init_stage2_mmu - Initialise a S2 MMU structure
  * @kvm:	The pointer to the KVM structure
  * @mmu:	The pointer to the s2 MMU structure
+ * @type:	The machine type of the virtual machine
  *
  * Allocates only the stage-2 HW PGD level table(s).
  * Note we don't need locking here as this is only called when the VM is
  * created, which can only be done once.
  */
-int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
+int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type)
 {
+	u32 kvm_ipa_limit = get_kvm_ipa_limit();
 	int cpu, err;
 	struct kvm_pgtable *pgt;
+	u64 mmfr0, mmfr1;
+	u32 phys_shift;
+
+	if (type & ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
+		return -EINVAL;
+
+	phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
+	if (phys_shift) {
+		if (phys_shift > kvm_ipa_limit ||
+		    phys_shift < ARM64_MIN_PARANGE_BITS)
+			return -EINVAL;
+	} else {
+		phys_shift = KVM_PHYS_SHIFT;
+		if (phys_shift > kvm_ipa_limit) {
+			pr_warn_once("%s using unsupported default IPA limit, upgrade your VMM\n",
+				     current->comm);
+			return -EINVAL;
+		}
+	}
+
+	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
+	mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+	kvm->arch.vtcr = kvm_get_vtcr(mmfr0, mmfr1, phys_shift);
 
 	if (mmu->pgt != NULL) {
 		kvm_err("kvm_arch already initialized?\n");
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index ecc40c8cd6f6..c07265ea72fd 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -370,32 +370,3 @@ int kvm_set_ipa_limit(void)
 
 	return 0;
 }
-
-int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type)
-{
-	u64 mmfr0, mmfr1;
-	u32 phys_shift;
-
-	if (type & ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
-		return -EINVAL;
-
-	phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
-	if (phys_shift) {
-		if (phys_shift > kvm_ipa_limit ||
-		    phys_shift < ARM64_MIN_PARANGE_BITS)
-			return -EINVAL;
-	} else {
-		phys_shift = KVM_PHYS_SHIFT;
-		if (phys_shift > kvm_ipa_limit) {
-			pr_warn_once("%s using unsupported default IPA limit, upgrade your VMM\n",
-				     current->comm);
-			return -EINVAL;
-		}
-	}
-
-	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
-	mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
-	kvm->arch.vtcr = kvm_get_vtcr(mmfr0, mmfr1, phys_shift);
-
-	return 0;
-}
-- 
2.36.1.124.g0e6072fb45-goog

