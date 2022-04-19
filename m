Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0B9506990
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 13:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350978AbiDSLUP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 07:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350951AbiDSLUK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 07:20:10 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E022C1F622;
        Tue, 19 Apr 2022 04:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650367047; x=1681903047;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kWejiPF82YrH+Ty7R0Fkl07BkhwqHcnwr3vq1zjTRTA=;
  b=kqnboPV1GyLfUiuZpyPlEGY1AH+L6U2OOXYRx9J5yY79XUmYEChEOt7s
   XextP0iuQiVh050e/6zY0CpFykego4hyrHIOhXI54fA2XPEkb4HTdCS83
   kbY90qufC7T8BDh37pXSl96PS5RdcznVqK/fixYMvVOmIAsxtCFpd4gom
   q2ODnTed63mRUdNdej12ubQ805HlYlO45UbXlpA3cpcmQC1XhoZ7NaTfh
   IWpwkBHw5OH+xof5kICiiB7rfj5SQTC21fcYMWQfubWp31XKw+kJQNowO
   5uaMO6OSupuZu/ILQYK/ScqA5a2qRAhximb4klm/9YRWL2JRuQ3gWyh7z
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10321"; a="350189761"
X-IronPort-AV: E=Sophos;i="5.90,272,1643702400"; 
   d="scan'208";a="350189761"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 04:17:18 -0700
X-IronPort-AV: E=Sophos;i="5.90,272,1643702400"; 
   d="scan'208";a="554683751"
Received: from csambran-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.58.20])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 04:17:16 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com, jmattson@google.com,
        joro@8bytes.org, wanpengli@tencent.com
Subject: [PATCH 2/3] KVM: x86/mmu: Add shadow_me_value and repurpose shadow_me_mask
Date:   Tue, 19 Apr 2022 23:17:03 +1200
Message-Id: <f90964b93a3398b1cf1c56f510f3281e0709e2ab.1650363789.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1650363789.git.kai.huang@intel.com>
References: <cover.1650363789.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel Multi-Key Total Memory Encryption (MKTME) repurposes couple of
high bits of physical address bits as 'KeyID' bits.  Intel Trust Domain
Extentions (TDX) further steals part of MKTME KeyID bits as TDX private
KeyID bits.  TDX private KeyID bits cannot be set in any mapping in the
host kernel since they can only be accessed by software running inside a
new CPU isolated mode.  And unlike to AMD's SME, host kernel doesn't set
any legacy MKTME KeyID bits to any mapping either.  Therefore, it's not
legitimate for KVM to set any KeyID bits in SPTE which maps guest
memory.

KVM maintains shadow_zero_check bits to represent which bits must be
zero for SPTE which maps guest memory.  MKTME KeyID bits should be set
to shadow_zero_check.  Currently, shadow_me_mask is used by AMD to set
the sme_me_mask to SPTE, and shadow_me_shadow is excluded from
shadow_zero_check.  So initializing shadow_me_mask to represent all
MKTME keyID bits doesn't work for VMX (as oppositely, they must be set
to shadow_zero_check).

Introduce a new 'shadow_me_value' to replace existing shadow_me_mask,
and repurpose shadow_me_mask as 'all possible memory encryption bits'.
The new schematic of them will be:

 - shadow_me_value: the memory encryption bit(s) that will be set to the
   SPTE (the original shadow_me_mask).
 - shadow_me_mask: all possible memory encryption bits (which is a super
   set of shadow_me_value).
 - For now, shadow_me_value is supposed to be set by SVM and VMX
   respectively, and it is a constant during KVM's life time.  This
   perhaps doesn't fit MKTME but for now host kernel doesn't support it
   (and perhaps will never do).
 - Bits in shadow_me_mask are set to shadow_zero_check, except the bits
   in shadow_me_value.

Introduce a new helper kvm_mmu_set_me_spte_mask() to initialize them.
Replace shadow_me_mask with shadow_me_value in almost all code paths,
except the one in PT64_PERM_MASK, which is used by need_remote_flush()
to determine whether remote TLB flush is needed.  This should still use
shadow_me_mask as any encryption bit change should need a TLB flush.
And for AMD, move initializing shadow_me_value/shadow_me_mask from
kvm_mmu_reset_all_pte_masks() to svm_hardware_setup().

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/mmu.h      |  1 +
 arch/x86/kvm/mmu/mmu.c  | 16 ++++++++++++----
 arch/x86/kvm/mmu/spte.c | 21 ++++++++++++++++-----
 arch/x86/kvm/mmu/spte.h |  1 +
 arch/x86/kvm/svm/svm.c  |  3 +++
 5 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 671cfeccf04e..60c669494c4c 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -66,6 +66,7 @@ static __always_inline u64 rsvd_bits(int s, int e)
 }
 
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
+void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask);
 void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
 
 void kvm_init_mmu(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2931785f1e73..410bce591c59 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3489,7 +3489,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 * or a PAE 3-level page table. In either case we need to be aware that
 	 * the shadow page table may be a PAE or a long mode page table.
 	 */
-	pm_mask = PT_PRESENT_MASK | shadow_me_mask;
+	pm_mask = PT_PRESENT_MASK | shadow_me_value;
 	if (mmu->root_role.level >= PT64_ROOT_4LEVEL) {
 		pm_mask |= PT_ACCESSED_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
 
@@ -4458,8 +4458,16 @@ static void reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
 		return;
 
 	for (i = context->root_role.level; --i >= 0;) {
-		shadow_zero_check->rsvd_bits_mask[0][i] &= ~shadow_me_mask;
-		shadow_zero_check->rsvd_bits_mask[1][i] &= ~shadow_me_mask;
+		/*
+		 * So far shadow_me_value is a constant during KVM's life
+		 * time.  Bits in shadow_me_value are allowed to be set.
+		 * Bits in shadow_me_mask but not in shadow_me_value are
+		 * not allowed to be set.
+		 */
+		shadow_zero_check->rsvd_bits_mask[0][i] |= shadow_me_mask;
+		shadow_zero_check->rsvd_bits_mask[1][i] |= shadow_me_mask;
+		shadow_zero_check->rsvd_bits_mask[0][i] &= ~shadow_me_value;
+		shadow_zero_check->rsvd_bits_mask[1][i] &= ~shadow_me_value;
 	}
 
 }
@@ -5546,7 +5554,7 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 	if (!tdp_enabled)
 		set_memory_decrypted((unsigned long)mmu->pae_root, 1);
 	else
-		WARN_ON_ONCE(shadow_me_mask);
+		WARN_ON_ONCE(shadow_me_value);
 
 	for (i = 0; i < 4; ++i)
 		mmu->pae_root[i] = INVALID_PAE_ROOT;
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 4739b53c9734..a6da94f441c4 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -33,6 +33,7 @@ u64 __read_mostly shadow_mmio_value;
 u64 __read_mostly shadow_mmio_mask;
 u64 __read_mostly shadow_mmio_access_mask;
 u64 __read_mostly shadow_present_mask;
+u64 __read_mostly shadow_me_value;
 u64 __read_mostly shadow_me_mask;
 u64 __read_mostly shadow_acc_track_mask;
 
@@ -140,7 +141,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		pte_access &= ~ACC_WRITE_MASK;
 
 	if (!kvm_is_mmio_pfn(pfn))
-		spte |= shadow_me_mask;
+		spte |= shadow_me_value;
 
 	spte |= (u64)pfn << PAGE_SHIFT;
 
@@ -256,7 +257,7 @@ u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled)
 	u64 spte = SPTE_MMU_PRESENT_MASK;
 
 	spte |= __pa(child_pt) | shadow_present_mask | PT_WRITABLE_MASK |
-		shadow_user_mask | shadow_x_mask | shadow_me_mask;
+		shadow_user_mask | shadow_x_mask | shadow_me_value;
 
 	if (ad_disabled)
 		spte |= SPTE_TDP_AD_DISABLED_MASK;
@@ -357,6 +358,17 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
 
+void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask)
+{
+	/* shadow_me_value must be a subset of shadow_me_mask */
+	if (WARN_ON(me_value & ~me_mask))
+		me_value = me_mask = 0;
+
+	shadow_me_value = me_value;
+	shadow_me_mask = me_mask;
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_set_me_spte_mask);
+
 void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
 {
 	shadow_user_mask	= VMX_EPT_READABLE_MASK;
@@ -366,8 +378,6 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
 	shadow_x_mask		= VMX_EPT_EXECUTABLE_MASK;
 	shadow_present_mask	= has_exec_only ? 0ull : VMX_EPT_READABLE_MASK;
 	shadow_acc_track_mask	= VMX_EPT_RWX_MASK;
-	shadow_me_mask		= 0ull;
-
 	shadow_host_writable_mask = EPT_SPTE_HOST_WRITABLE;
 	shadow_mmu_writable_mask  = EPT_SPTE_MMU_WRITABLE;
 
@@ -418,7 +428,8 @@ void kvm_mmu_reset_all_pte_masks(void)
 	shadow_x_mask		= 0;
 	shadow_present_mask	= PT_PRESENT_MASK;
 	shadow_acc_track_mask	= 0;
-	shadow_me_mask		= sme_me_mask;
+	shadow_me_mask		= 0;
+	shadow_me_value		= 0;
 
 	shadow_host_writable_mask = DEFAULT_SPTE_HOST_WRITABLE;
 	shadow_mmu_writable_mask  = DEFAULT_SPTE_MMU_WRITABLE;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 73f12615416f..c45fb1cd2644 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -149,6 +149,7 @@ extern u64 __read_mostly shadow_mmio_value;
 extern u64 __read_mostly shadow_mmio_mask;
 extern u64 __read_mostly shadow_mmio_access_mask;
 extern u64 __read_mostly shadow_present_mask;
+extern u64 __read_mostly shadow_me_value;
 extern u64 __read_mostly shadow_me_mask;
 
 /*
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index fc1725b7d05f..c9485b5bd1dd 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4891,6 +4891,9 @@ static __init int svm_hardware_setup(void)
 			  get_npt_level(), PG_LEVEL_1G);
 	pr_info("kvm: Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
 
+	/* Setup shadow_me_value and shadow_me_mask */
+	kvm_mmu_set_me_spte_mask(sme_me_mask, sme_me_mask);
+
 	/* Note, SEV setup consumes npt_enabled. */
 	sev_hardware_setup();
 
-- 
2.35.1

