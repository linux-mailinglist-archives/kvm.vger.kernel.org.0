Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9BF55E098
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241663AbiF0V4O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240188AbiF0VzK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:55:10 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B10643F;
        Mon, 27 Jun 2022 14:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366897; x=1687902897;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x5IX4OKgEXKPzhHuBaZiAa+9tg/l0DFutLT+RjxDKOU=;
  b=IRKzlZ0kTDpnTVgQ0an4V77dQPMHZqIZCohhb6W5C94m4o3caK8fYBl8
   1sMJ30nShU3UsV7ustY+bun3ncOOnqi2gZKDDHq2ADORBt3iWrusQU77f
   wjEYgokitnFps6806JpRe99N7wCI2kksZav8eci+tuomErVCn3lHe3mJY
   QInc/DWkZngwF1p6i7v22JCOZkncO2HqJvJztJyhBIg/Gxq+2xAqKELLn
   x1564BMC/JjEfzEWdlpymkDQc3kdUdTjFlvFp1+jHXzvqHTYs6JzgpWSW
   NEIKbddeI9GKXvWQYbPUWpm0fIyRSRfvvbRn6vG7jzI1SIcvJW2bZpEK1
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="281609547"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="281609547"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:52 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863554"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:52 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v7 037/102] KVM: x86/mmu: Track shadow MMIO value/mask on a per-VM basis
Date:   Mon, 27 Jun 2022 14:53:29 -0700
Message-Id: <242df8a7164b593d3702b9ba94889acd11f43cbb.1656366338.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656366337.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

TDX will use a different shadow PTE entry value for MMIO from VMX.  Add
members to kvm_arch and track value for MMIO per-VM instead of global
variables.  By using the per-VM EPT entry value for MMIO, the existing VMX
logic is kept working.

In the case of VMX VM case, the EPT entry for MMIO is non-present PTE
(present bit cleared) without backing guest physical address (on EPT
violation, KVM searches backing guest memory and it finds there is no
backing guest page.) or the value to trigger EPT misconfiguration.  Once
MMIO is triggered on the EPT entry, the EPT entry is updated to trigger EPT
misconfiguration for the future MMIO on the same GPA.  It allows KVM to
understand the memory access is for MMIO without searching backing guest
pages.). And then KVM parses guest instruction to figure out
address/value/width for MMIO.

In the case of the guest TD, the guest memory is protected so that VMM
can't parse guest instruction to understand the value and access width for
MMIO.  Instead, VMM sets up (Shared) EPT to trigger #VE by clearing
the VE-suppress bit.  When the guest TD issues MMIO, #VE is injected.  Guest VE
handler converts MMIO access into MMIO hypercall to pass
address/value/width for MMIO to VMM. (or directly paravirtualize MMIO into
hypercall.)  Then VMM can handle the MMIO hypercall without parsing guest
instructions.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++++
 arch/x86/include/asm/vmx.h      |  1 +
 arch/x86/kvm/mmu.h              |  4 +++-
 arch/x86/kvm/mmu/mmu.c          | 20 ++++++++++++----
 arch/x86/kvm/mmu/paging_tmpl.h  |  2 +-
 arch/x86/kvm/mmu/spte.c         | 41 +++++++++++++++------------------
 arch/x86/kvm/mmu/spte.h         | 11 ++++-----
 arch/x86/kvm/mmu/tdp_mmu.c      |  6 ++---
 arch/x86/kvm/svm/svm.c          |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  8 +++++++
 10 files changed, 59 insertions(+), 40 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2c47aab72a1b..39215daa8576 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1161,6 +1161,10 @@ struct kvm_arch {
 	 */
 	spinlock_t mmu_unsync_pages_lock;
 
+	bool enable_mmio_caching;
+	u64 shadow_mmio_value;
+	u64 shadow_mmio_mask;
+
 	struct list_head assigned_dev_head;
 	struct iommu_domain *iommu_domain;
 	bool iommu_noncoherent;
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index c371ef695fcc..6231ef005a50 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -511,6 +511,7 @@ enum vmcs_field {
 #define VMX_EPT_IPAT_BIT    			(1ull << 6)
 #define VMX_EPT_ACCESS_BIT			(1ull << 8)
 #define VMX_EPT_DIRTY_BIT			(1ull << 9)
+#define VMX_EPT_SUPPRESS_VE_BIT			(1ull << 63)
 #define VMX_EPT_RWX_MASK                        (VMX_EPT_READABLE_MASK |       \
 						 VMX_EPT_WRITABLE_MASK |       \
 						 VMX_EPT_EXECUTABLE_MASK)
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index ccf0ba7a6387..9ba60fd79d33 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -108,7 +108,9 @@ static inline u8 kvm_get_shadow_phys_bits(void)
 	return boot_cpu_data.x86_phys_bits;
 }
 
-void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
+void kvm_mmu_set_mmio_spte_mask(struct kvm *kvm, u64 mmio_value, u64 mmio_mask,
+				u64 access_mask);
+void kvm_mmu_set_default_mmio_spte_mask(u64 mask);
 void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask);
 void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f239b6cb5d53..496d0d30839b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2287,7 +2287,7 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 				return kvm_mmu_prepare_zap_page(kvm, child,
 								invalid_list);
 		}
-	} else if (is_mmio_spte(pte)) {
+	} else if (is_mmio_spte(kvm, pte)) {
 		mmu_spte_clear_no_track(spte);
 	}
 	return 0;
@@ -3067,8 +3067,13 @@ static int handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fau
 		 * by L0 userspace (you can observe gfn > L1.MAXPHYADDR if
 		 * and only if L1's MAXPHYADDR is inaccurate with respect to
 		 * the hardware's).
+		 *
+		 * Excludes the INTEL TD guest.  Because TD memory is
+		 * protected, the instruction can't be emulated.  Instead, use
+		 * SPTE value without #VE suppress bit cleared
+		 * (kvm->arch.shadow_mmio_value = 0).
 		 */
-		if (unlikely(!enable_mmio_caching) ||
+		if (unlikely(!vcpu->kvm->arch.enable_mmio_caching) ||
 		    unlikely(fault->gfn > kvm_mmu_max_gfn()))
 			return RET_PF_EMULATE;
 	}
@@ -3200,7 +3205,8 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		else
 			sptep = fast_pf_get_last_sptep(vcpu, fault->addr, &spte);
 
-		if (!is_shadow_present_pte(spte) || is_mmio_spte(spte))
+		if (!is_shadow_present_pte(spte) ||
+		    is_mmio_spte(vcpu->kvm, spte))
 			break;
 
 		sp = sptep_to_sp(sptep);
@@ -3907,7 +3913,7 @@ static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr, bool direct)
 	if (WARN_ON(reserved))
 		return -EINVAL;
 
-	if (is_mmio_spte(spte)) {
+	if (is_mmio_spte(vcpu->kvm, spte)) {
 		gfn_t gfn = get_mmio_spte_gfn(spte);
 		unsigned int access = get_mmio_spte_access(spte);
 
@@ -4350,7 +4356,7 @@ static unsigned long get_cr3(struct kvm_vcpu *vcpu)
 static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
 			   unsigned int access)
 {
-	if (unlikely(is_mmio_spte(*sptep))) {
+	if (unlikely(is_mmio_spte(vcpu->kvm, *sptep))) {
 		if (gfn != get_mmio_spte_gfn(*sptep)) {
 			mmu_spte_clear_no_track(sptep);
 			return true;
@@ -5864,6 +5870,10 @@ int kvm_mmu_init_vm(struct kvm *kvm)
 	node->track_write = kvm_mmu_pte_write;
 	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
 	kvm_page_track_register_notifier(kvm, node);
+	kvm_mmu_set_mmio_spte_mask(kvm, shadow_default_mmio_mask,
+				   shadow_default_mmio_mask,
+				   ACC_WRITE_MASK | ACC_USER_MASK);
+
 	return 0;
 }
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index ee2fb0c073f3..62ae590d4e5b 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1032,7 +1032,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		gfn_t gfn;
 
 		if (!is_shadow_present_pte(sp->spt[i]) &&
-		    !is_mmio_spte(sp->spt[i]))
+		    !is_mmio_spte(vcpu->kvm, sp->spt[i]))
 			continue;
 
 		pte_gpa = first_pte_gpa + i * sizeof(pt_element_t);
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index bd441458153f..5194aef60c1f 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -29,8 +29,7 @@ u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask */
 u64 __read_mostly shadow_user_mask;
 u64 __read_mostly shadow_accessed_mask;
 u64 __read_mostly shadow_dirty_mask;
-u64 __read_mostly shadow_mmio_value;
-u64 __read_mostly shadow_mmio_mask;
+u64 __read_mostly shadow_default_mmio_mask;
 u64 __read_mostly shadow_mmio_access_mask;
 u64 __read_mostly shadow_present_mask;
 u64 __read_mostly shadow_me_value;
@@ -62,10 +61,11 @@ u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access)
 	u64 spte = generation_mmio_spte_mask(gen);
 	u64 gpa = gfn << PAGE_SHIFT;
 
-	WARN_ON_ONCE(!shadow_mmio_value);
+	WARN_ON_ONCE(!vcpu->kvm->arch.shadow_mmio_value &&
+		     !kvm_gfn_shared_mask(vcpu->kvm));
 
 	access &= shadow_mmio_access_mask;
-	spte |= shadow_mmio_value | access;
+	spte |= vcpu->kvm->arch.shadow_mmio_value | access;
 	spte |= gpa | shadow_nonpresent_or_rsvd_mask;
 	spte |= (gpa & shadow_nonpresent_or_rsvd_mask)
 		<< SHADOW_NONPRESENT_OR_RSVD_MASK_LEN;
@@ -337,7 +337,8 @@ u64 mark_spte_for_access_track(u64 spte)
 	return spte;
 }
 
-void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
+void kvm_mmu_set_mmio_spte_mask(struct kvm *kvm, u64 mmio_value, u64 mmio_mask,
+				u64 access_mask)
 {
 	BUG_ON((u64)(unsigned)access_mask != access_mask);
 	WARN_ON(mmio_value & shadow_nonpresent_or_rsvd_lower_gfn_mask);
@@ -366,11 +367,9 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
 	    WARN_ON(mmio_value && (__REMOVED_SPTE & mmio_mask) == mmio_value))
 		mmio_value = 0;
 
-	if (!mmio_value)
-		enable_mmio_caching = false;
-
-	shadow_mmio_value = mmio_value;
-	shadow_mmio_mask  = mmio_mask;
+	kvm->arch.enable_mmio_caching = !!mmio_value;
+	kvm->arch.shadow_mmio_value = mmio_value;
+	kvm->arch.shadow_mmio_mask = mmio_mask;
 	shadow_mmio_access_mask = access_mask;
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
@@ -393,24 +392,18 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
 	shadow_dirty_mask	= has_ad_bits ? VMX_EPT_DIRTY_BIT : 0ull;
 	shadow_nx_mask		= 0ull;
 	shadow_x_mask		= VMX_EPT_EXECUTABLE_MASK;
-	shadow_present_mask	= has_exec_only ? 0ull : VMX_EPT_READABLE_MASK;
+	/* VMX_EPT_SUPPRESS_VE_BIT is needed for W or X violation. */
+	shadow_present_mask	=
+		(has_exec_only ? 0ull : VMX_EPT_READABLE_MASK) | VMX_EPT_SUPPRESS_VE_BIT;
 	shadow_acc_track_mask	= VMX_EPT_RWX_MASK;
 	shadow_host_writable_mask = EPT_SPTE_HOST_WRITABLE;
 	shadow_mmu_writable_mask  = EPT_SPTE_MMU_WRITABLE;
-
-	/*
-	 * EPT Misconfigurations are generated if the value of bits 2:0
-	 * of an EPT paging-structure entry is 110b (write/execute).
-	 */
-	kvm_mmu_set_mmio_spte_mask(VMX_EPT_MISCONFIG_WX_VALUE,
-				   VMX_EPT_RWX_MASK, 0);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_ept_masks);
 
 void kvm_mmu_reset_all_pte_masks(void)
 {
 	u8 low_phys_bits;
-	u64 mask;
 
 	shadow_phys_bits = kvm_get_shadow_phys_bits();
 
@@ -459,9 +452,13 @@ void kvm_mmu_reset_all_pte_masks(void)
 	 * PTEs and so the reserved PA approach must be disabled.
 	 */
 	if (shadow_phys_bits < 52)
-		mask = BIT_ULL(51) | PT_PRESENT_MASK;
+		shadow_default_mmio_mask = BIT_ULL(51) | PT_PRESENT_MASK;
 	else
-		mask = 0;
+		shadow_default_mmio_mask = 0;
+}
 
-	kvm_mmu_set_mmio_spte_mask(mask, mask, ACC_WRITE_MASK | ACC_USER_MASK);
+void kvm_mmu_set_default_mmio_spte_mask(u64 mask)
+{
+	shadow_default_mmio_mask = mask;
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_set_default_mmio_spte_mask);
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 1bfedbe0585f..96312ab4fffb 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -5,8 +5,6 @@
 
 #include "mmu_internal.h"
 
-extern bool __read_mostly enable_mmio_caching;
-
 /*
  * A MMU present SPTE is backed by actual memory and may or may not be present
  * in hardware.  E.g. MMIO SPTEs are not considered present.  Use bit 11, as it
@@ -160,8 +158,7 @@ extern u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask */
 extern u64 __read_mostly shadow_user_mask;
 extern u64 __read_mostly shadow_accessed_mask;
 extern u64 __read_mostly shadow_dirty_mask;
-extern u64 __read_mostly shadow_mmio_value;
-extern u64 __read_mostly shadow_mmio_mask;
+extern u64 __read_mostly shadow_default_mmio_mask;
 extern u64 __read_mostly shadow_mmio_access_mask;
 extern u64 __read_mostly shadow_present_mask;
 extern u64 __read_mostly shadow_me_value;
@@ -233,10 +230,10 @@ static inline bool is_removed_spte(u64 spte)
  */
 extern u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
 
-static inline bool is_mmio_spte(u64 spte)
+static inline bool is_mmio_spte(struct kvm *kvm, u64 spte)
 {
-	return (spte & shadow_mmio_mask) == shadow_mmio_value &&
-	       likely(enable_mmio_caching);
+	return (spte & kvm->arch.shadow_mmio_mask) == kvm->arch.shadow_mmio_value &&
+		likely(kvm->arch.enable_mmio_caching || kvm_gfn_shared_mask(kvm));
 }
 
 static inline bool is_shadow_present_pte(u64 pte)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 2ca03ec3bf52..82f1bfac7ee6 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -569,8 +569,8 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 		 * impact the guest since both the former and current SPTEs
 		 * are nonpresent.
 		 */
-		if (WARN_ON(!is_mmio_spte(old_spte) &&
-			    !is_mmio_spte(new_spte) &&
+		if (WARN_ON(!is_mmio_spte(kvm, old_spte) &&
+			    !is_mmio_spte(kvm, new_spte) &&
 			    !is_removed_spte(new_spte)))
 			pr_err("Unexpected SPTE change! Nonpresent SPTEs\n"
 			       "should not be replaced with another,\n"
@@ -1108,7 +1108,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 	}
 
 	/* If a MMIO SPTE is installed, the MMIO will need to be emulated. */
-	if (unlikely(is_mmio_spte(new_spte))) {
+	if (unlikely(is_mmio_spte(vcpu->kvm, new_spte))) {
 		vcpu->stat.pf_mmio_spte_created++;
 		trace_mark_mmio_spte(rcu_dereference(iter->sptep), iter->gfn,
 				     new_spte);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 815a07c594f1..0abc43d6a115 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4870,7 +4870,7 @@ static __init void svm_adjust_mmio_mask(void)
 	 */
 	mask = (mask_bit < 52) ? rsvd_bits(mask_bit, 51) | PT_PRESENT_MASK : 0;
 
-	kvm_mmu_set_mmio_spte_mask(mask, mask, PT_WRITABLE_MASK | PT_USER_MASK);
+	kvm_mmu_set_default_mmio_spte_mask(mask);
 }
 
 static __init void svm_set_cpu_caps(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1d87885245cc..e2415ac55317 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7289,6 +7289,14 @@ int vmx_vm_init(struct kvm *kvm)
 	if (!ple_gap)
 		kvm->arch.pause_in_guest = true;
 
+	/*
+	 * EPT Misconfigurations can be generated if the value of bits 2:0
+	 * of an EPT paging-structure entry is 110b (write/execute).
+	 */
+	if (enable_ept)
+		kvm_mmu_set_mmio_spte_mask(kvm, VMX_EPT_MISCONFIG_WX_VALUE,
+					   VMX_EPT_RWX_MASK, 0);
+
 	if (boot_cpu_has(X86_BUG_L1TF) && enable_ept) {
 		switch (l1tf_mitigation) {
 		case L1TF_MITIGATION_OFF:
-- 
2.25.1

