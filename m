Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF93F6061F4
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 15:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiJTNkW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 09:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbiJTNkM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 09:40:12 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B64F4E185
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 06:39:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 08C0DCE25A7
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 13:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC09FC433B5;
        Thu, 20 Oct 2022 13:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666273184;
        bh=I4JnPEgM6Z5muSVsmE5FVgTsNTXZZrCk61q/wCYpqVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SqAhlh45oo3H35LWV8WldVgZT9wP1HVclMsfInmh6nNbHs1Ij0a+JGM/byxnfMKE4
         +H/ShOSfbyVW+Vzw7O+6Zfa6pKX7U3XOqrU7Fh/MSPbGLft/ECV5M07ezJttd+5EK4
         KFAivzqKOfzz6CFTWnk+Pnir7MEmmY5MI3Huojyoa4dEPtOShI15ZBK6h84X2sS4nj
         VBK0SVNJXQO3JmFBHJyVHaaoRHrUwZ0f+3LLhcq2Kd422IHlJ8VltKQ4vsDKni4557
         u1f0rNBHSiAW+AqMdSdyQCxjeUsUsYoZkyN/bQA6At0OKiinS8uZKoeLYu3i/MQRbG
         +IRSSDsUkh0Kw==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.linux.dev
Cc:     Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v5 18/25] KVM: arm64: Consolidate stage-2 initialisation into a single function
Date:   Thu, 20 Oct 2022 14:38:20 +0100
Message-Id: <20221020133827.5541-19-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221020133827.5541-1-will@kernel.org>
References: <20221020133827.5541-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Quentin Perret <qperret@google.com>

The initialisation of guest stage-2 page-tables is currently split
across two functions: kvm_init_stage2_mmu() and kvm_arm_setup_stage2().
That is presumably for historical reasons as kvm_arm_setup_stage2()
originates from the (now defunct) KVM port for 32-bit Arm.

Simplify this code path by merging both functions into one, taking care
to map the 'struct kvm' into the hypervisor stage-1 early on in order to
simplify the failure path.

Tested-by: Vincent Donnefort <vdonnefort@google.com>
Co-developed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h  |  2 +-
 arch/arm64/include/asm/kvm_host.h |  2 --
 arch/arm64/include/asm/kvm_mmu.h  |  2 +-
 arch/arm64/kvm/arm.c              | 27 +++++++++++++--------------
 arch/arm64/kvm/mmu.c              | 27 ++++++++++++++++++++++++++-
 arch/arm64/kvm/reset.c            | 29 -----------------------------
 6 files changed, 41 insertions(+), 48 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 8aa8492dafc0..89e63585dae4 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -135,7 +135,7 @@
  * 40 bits wide (T0SZ = 24).  Systems with a PARange smaller than 40 bits are
  * not known to exist and will break with this configuration.
  *
- * The VTCR_EL2 is configured per VM and is initialised in kvm_arm_setup_stage2().
+ * The VTCR_EL2 is configured per VM and is initialised in kvm_init_stage2_mmu.
  *
  * Note that when using 4K pages, we concatenate two first level page tables
  * together. With 16K pages, we concatenate 16 first level page tables.
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 835987e0f868..57218f0c449e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -990,8 +990,6 @@ int kvm_set_ipa_limit(void);
 #define __KVM_HAVE_ARCH_VM_ALLOC
 struct kvm *kvm_arch_alloc_vm(void);
 
-int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type);
-
 static inline bool kvm_vm_is_protected(struct kvm *kvm)
 {
 	return false;
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 7784081088e7..e4a7e6369499 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -166,7 +166,7 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
 void free_hyp_pgds(void);
 
 void stage2_unmap_vm(struct kvm *kvm);
-int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu);
+int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type);
 void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
 int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 			  phys_addr_t pa, unsigned long size, bool writable);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index d99e93e6ddf7..f78eefa02f6b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -139,28 +139,24 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
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
 
 	ret = pkvm_init_host_vm(kvm);
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
@@ -169,9 +165,12 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	set_default_spectre(kvm);
 	kvm_arm_init_hypercalls(kvm);
 
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
index 8b52566d1cb9..43761d31f763 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -668,15 +668,40 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
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
index 5ae18472205a..e0267f672b8a 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -395,32 +395,3 @@ int kvm_set_ipa_limit(void)
 
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
2.38.0.413.g74048e4d9e-goog

