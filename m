Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3794CDDFC
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 21:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbiCDUJt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:09:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbiCDUHw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:07:52 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078A52036F0;
        Fri,  4 Mar 2022 12:02:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646424138; x=1677960138;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1RVb2YnUQFKFQsqCClaVBJvP7/e0tFbqIYsyc09sDEQ=;
  b=JYj+ls92w9TrIEeFjGd7EPnpQ/vjDUdVedyFaxWGzT+4GIY7Nj6dS9L5
   AS8wJNrdce2men97YpKSzzIsyK+hXQDqy3VHZH9ePE5Da2mmJWWgfNMmn
   rJ+eqZtqKSXntsO2zTOz8tNHhNpysC6O7Y0Ff2DnpfqK80kxzT2r64Q15
   lULNbUiwywwgk/AWr38z+1WgIDqKDzycN0rBb3o96KdaDnbuh6w4Mh05v
   iJ8FUH+WnK/yVkkZNI3ngjrrY2f6ewz6iYokRtussvZA85dttSG8XPmgZ
   NkrcFnsmc8CsVVuxqOv5q4teR+v8XA9NIvI9p7vPlS66sIO9ZSV0YHnUt
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253983484"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253983484"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:22 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344336"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:21 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 042/104] KVM: x86/mmu: Track shadow MMIO value/mask on a per-VM basis
Date:   Fri,  4 Mar 2022 11:48:58 -0800
Message-Id: <b494b94bf2d6a5d841cb76e63e255d4cff906d83.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Define the EPT Violation #VE control bit, #VE info VMCS fields, and the
suppress #VE bit for EPT entries.

TDX will use a different shadow PTE entry value for MMIO from VMX.  Add
members to kvm_arch and track value for MMIO per-VM.  By using per-VM EPT
entry value for MMIO, the existing VMX logic is kept working.

In the case of VMX VM case, the EPT entry for MMIO is non-present PTE
(present bit cleared) without backing guest physical address (on EPT
violation, KVM seaching backing guest memory and it finds there is no
backing guest page.) or the value to trigger EPT misconfiguration.  For
fast path. Once MMIO is triggered on the EPT entry, the EPT entry is
updated for the future MMIO.  It allows KVM to understand the memory access
is for MMIO without searching backing guest pages.). And then KVM parses
guest instruction to figure out address/value/width for MMIO.

In the case of the guest TD, the guest memory is protected so that VMM
can't parse guest instruction to trigger EPT violation.  Instead VMM sets
up (Shared) EPT to trigger #VE.  When the guest TD issues MMIO, #VE is
injected.  guest VE handler converts MMIO access into MMIO hypercall to
pass address/value/width for MMIO to VMM. (or directly paravirtualize MMIO
into hypercall.)  Then VMM can handle the MMIO hypercall without parsing
guest instruction.

When the guest accesses GPA if "the EPT Violation #VE" control bit is set
and EPT SUPPRESS VE bit in EPT entry is cleared, #VE, virtualization
exception, is injected into the guest.  Because the TDX guest vCPU state
and memory are protected, a VMM can't emulate MMIO by the TDX guest on EPT
violation by snooping vCPU state and parsing instruction to figure out MMIO
address and value.  Instead, PV MMIO (MMIO hypercall) is adapted.  On EPT
violation, CPU injects #VE to guest and the guest converts MMIO instruction
into PV MMIO.  Or guest directly issues MMIO hypercall.

The existing VMX code uses zero as an initial value for EPT entry.  TDX
will enable EPT-violation #VE VM-execution control and requires suppress VE
bit cleared in shared EPT entry to inject #VE into the TDX guest.  To keep
the same behavior for VMX, suppress VE bit needs to be set.  Allow to
specify an initial value for EPT entry and if TDX is enabled, set initial
EPT entry value to suppress VE bit set.  EPT-violation #VE VM-execution
control will be enabled, and For TDX shared EPT suppress VE bit will be
cleared for TDX shared EPT entry.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/include/asm/vmx.h      |  1 +
 arch/x86/kvm/mmu.h              |  6 ++++--
 arch/x86/kvm/mmu/mmu.c          | 19 +++++++++++------
 arch/x86/kvm/mmu/spte.c         | 38 ++++++++++++++++-----------------
 arch/x86/kvm/mmu/spte.h         |  9 ++++----
 arch/x86/kvm/mmu/tdp_mmu.c      |  6 +++---
 arch/x86/kvm/svm/svm.c          |  2 +-
 arch/x86/kvm/vmx/main.c         |  7 ++++--
 arch/x86/kvm/vmx/tdx.c          |  2 +-
 arch/x86/kvm/vmx/tdx.h          |  2 ++
 arch/x86/kvm/vmx/vmx.c          |  8 +++++++
 12 files changed, 63 insertions(+), 40 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d33d79f2af2d..fcab2337819c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1069,6 +1069,9 @@ struct kvm_arch {
 	 */
 	spinlock_t mmu_unsync_pages_lock;
 
+	u64 shadow_mmio_value;
+	u64 shadow_mmio_mask;
+
 	struct list_head assigned_dev_head;
 	struct iommu_domain *iommu_domain;
 	bool iommu_noncoherent;
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 0ffaa3156a4e..88d9b8cc7dde 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -498,6 +498,7 @@ enum vmcs_field {
 #define VMX_EPT_IPAT_BIT    			(1ull << 6)
 #define VMX_EPT_ACCESS_BIT			(1ull << 8)
 #define VMX_EPT_DIRTY_BIT			(1ull << 9)
+#define VMX_EPT_SUPPRESS_VE_BIT			(1ull << 63)
 #define VMX_EPT_RWX_MASK                        (VMX_EPT_READABLE_MASK |       \
 						 VMX_EPT_WRITABLE_MASK |       \
 						 VMX_EPT_EXECUTABLE_MASK)
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 650989c37f2e..b49841e4faaa 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -64,8 +64,10 @@ static __always_inline u64 rsvd_bits(int s, int e)
 	return ((2ULL << (e - s)) - 1) << s;
 }
 
-void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
-void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
+void kvm_mmu_set_mmio_spte_mask(struct kvm *kvm, u64 mmio_value, u64 mmio_mask,
+				u64 access_mask);
+void kvm_mmu_set_default_mmio_spte_mask(u64 mask);
+void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only, u64 init_value);
 void kvm_mmu_set_spte_init_value(u64 init_value);
 
 void kvm_init_mmu(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d8c1505155b0..6e9847b1124b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2336,7 +2336,7 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 				return kvm_mmu_prepare_zap_page(kvm, child,
 								invalid_list);
 		}
-	} else if (is_mmio_spte(pte)) {
+	} else if (is_mmio_spte(kvm, pte)) {
 		mmu_spte_clear_no_track(spte);
 	}
 	return 0;
@@ -3069,9 +3069,12 @@ static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fa
 		/*
 		 * If MMIO caching is disabled, emulate immediately without
 		 * touching the shadow page tables as attempting to install an
-		 * MMIO SPTE will just be an expensive nop.
+		 * MMIO SPTE will just be an expensive nop, but excludes the
+		 * INTEL TD guest due to it also uses shadow_mmio_value = 0
+		 * to emulating MMIO access.
 		 */
-		if (unlikely(!shadow_mmio_value)) {
+		if (unlikely(!vcpu->kvm->arch.shadow_mmio_value)
+		    && !kvm_gfn_stolen_mask(vcpu->kvm)) {
 			*ret_val = RET_PF_EMULATE;
 			return true;
 		}
@@ -3209,7 +3212,8 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			break;
 
 		sp = sptep_to_sp(sptep);
-		if (!is_last_spte(spte, sp->role.level) || is_mmio_spte(spte))
+		if (!is_last_spte(spte, sp->role.level) ||
+			is_mmio_spte(vcpu->kvm, spte))
 			break;
 
 		/*
@@ -3892,7 +3896,7 @@ static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr, bool direct)
 	if (WARN_ON(reserved))
 		return -EINVAL;
 
-	if (is_mmio_spte(spte)) {
+	if (is_mmio_spte(vcpu->kvm, spte)) {
 		gfn_t gfn = get_mmio_spte_gfn(spte);
 		unsigned int access = get_mmio_spte_access(spte);
 
@@ -4294,7 +4298,7 @@ static unsigned long get_cr3(struct kvm_vcpu *vcpu)
 static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
 			   unsigned int access)
 {
-	if (unlikely(is_mmio_spte(*sptep))) {
+	if (unlikely(is_mmio_spte(vcpu->kvm, *sptep))) {
 		if (gfn != get_mmio_spte_gfn(*sptep)) {
 			mmu_spte_clear_no_track(sptep);
 			return true;
@@ -5791,6 +5795,9 @@ void kvm_mmu_init_vm(struct kvm *kvm)
 	kvm_page_track_register_notifier(kvm, node);
 
 	kvm->arch.tdp_max_page_level = KVM_MAX_HUGEPAGE_LEVEL;
+	kvm_mmu_set_mmio_spte_mask(kvm, shadow_default_mmio_mask,
+				   shadow_default_mmio_mask,
+				   ACC_WRITE_MASK | ACC_USER_MASK);
 }
 
 void kvm_mmu_uninit_vm(struct kvm *kvm)
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 5071e8332db2..ea83927b9231 100644
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
 u64 __read_mostly shadow_me_mask;
@@ -59,10 +58,11 @@ u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access)
 	u64 spte = generation_mmio_spte_mask(gen);
 	u64 gpa = gfn << PAGE_SHIFT;
 
-	WARN_ON_ONCE(!shadow_mmio_value);
+	WARN_ON_ONCE(!vcpu->kvm->arch.shadow_mmio_value &&
+		     !kvm_gfn_stolen_mask(vcpu->kvm));
 
 	access &= shadow_mmio_access_mask;
-	spte |= shadow_mmio_value | access;
+	spte |= vcpu->kvm->arch.shadow_mmio_value | access;
 	spte |= gpa | shadow_nonpresent_or_rsvd_mask;
 	spte |= (gpa & shadow_nonpresent_or_rsvd_mask)
 		<< SHADOW_NONPRESENT_OR_RSVD_MASK_LEN;
@@ -279,7 +279,8 @@ u64 mark_spte_for_access_track(u64 spte)
 	return spte;
 }
 
-void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
+void kvm_mmu_set_mmio_spte_mask(struct kvm *kvm, u64 mmio_value, u64 mmio_mask,
+				u64 access_mask)
 {
 	BUG_ON((u64)(unsigned)access_mask != access_mask);
 	WARN_ON(mmio_value & shadow_nonpresent_or_rsvd_lower_gfn_mask);
@@ -308,39 +309,32 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
 	    WARN_ON(mmio_value && (REMOVED_SPTE & mmio_mask) == mmio_value))
 		mmio_value = 0;
 
-	shadow_mmio_value = mmio_value;
-	shadow_mmio_mask  = mmio_mask;
+	kvm->arch.shadow_mmio_value = mmio_value;
+	kvm->arch.shadow_mmio_mask = mmio_mask;
 	shadow_mmio_access_mask = access_mask;
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
 
-void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
+void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only, u64 init_value)
 {
 	shadow_user_mask	= VMX_EPT_READABLE_MASK;
 	shadow_accessed_mask	= has_ad_bits ? VMX_EPT_ACCESS_BIT : 0ull;
 	shadow_dirty_mask	= has_ad_bits ? VMX_EPT_DIRTY_BIT : 0ull;
 	shadow_nx_mask		= 0ull;
 	shadow_x_mask		= VMX_EPT_EXECUTABLE_MASK;
-	shadow_present_mask	= has_exec_only ? 0ull : VMX_EPT_READABLE_MASK;
+	shadow_present_mask	=
+		(has_exec_only ? 0ull : VMX_EPT_READABLE_MASK) | init_value;
 	shadow_acc_track_mask	= VMX_EPT_RWX_MASK;
 	shadow_me_mask		= 0ull;
 
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
 
@@ -389,9 +383,13 @@ void kvm_mmu_reset_all_pte_masks(void)
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
index 8e13a35ab8c9..bde843bce878 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -165,8 +165,7 @@ extern u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask */
 extern u64 __read_mostly shadow_user_mask;
 extern u64 __read_mostly shadow_accessed_mask;
 extern u64 __read_mostly shadow_dirty_mask;
-extern u64 __read_mostly shadow_mmio_value;
-extern u64 __read_mostly shadow_mmio_mask;
+extern u64 __read_mostly shadow_default_mmio_mask;
 extern u64 __read_mostly shadow_mmio_access_mask;
 extern u64 __read_mostly shadow_present_mask;
 extern u64 __read_mostly shadow_me_mask;
@@ -229,10 +228,10 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
  */
 extern u8 __read_mostly shadow_phys_bits;
 
-static inline bool is_mmio_spte(u64 spte)
+static inline bool is_mmio_spte(struct kvm *kvm, u64 spte)
 {
-	return (spte & shadow_mmio_mask) == shadow_mmio_value &&
-	       likely(shadow_mmio_value);
+	return (spte & kvm->arch.shadow_mmio_mask) == kvm->arch.shadow_mmio_value &&
+		likely(kvm->arch.shadow_mmio_value || kvm_gfn_stolen_mask(kvm));
 }
 
 static inline bool is_shadow_present_pte(u64 pte)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index bc9e3553fba2..ebd0a02620e8 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -447,8 +447,8 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
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
@@ -927,7 +927,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 	}
 
 	/* If a MMIO SPTE is installed, the MMIO will need to be emulated. */
-	if (unlikely(is_mmio_spte(new_spte))) {
+	if (unlikely(is_mmio_spte(vcpu->kvm, new_spte))) {
 		trace_mark_mmio_spte(rcu_dereference(iter->sptep), iter->gfn,
 				     new_spte);
 		ret = RET_PF_EMULATE;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 778075b71dc3..c7eec23e9ebe 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4704,7 +4704,7 @@ static __init void svm_adjust_mmio_mask(void)
 	 */
 	mask = (mask_bit < 52) ? rsvd_bits(mask_bit, 51) | PT_PRESENT_MASK : 0;
 
-	kvm_mmu_set_mmio_spte_mask(mask, mask, PT_WRITABLE_MASK | PT_USER_MASK);
+	kvm_mmu_set_default_mmio_spte_mask(mask);
 }
 
 static __init void svm_set_cpu_caps(void)
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 51aaafe6b432..b242a9dc9e29 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -23,9 +23,12 @@ static __init int vt_hardware_setup(void)
 
 	tdx_hardware_setup(&vt_x86_ops);
 
-	if (enable_ept)
+	if (enable_ept) {
+		const u64 init_value = enable_tdx ? VMX_EPT_SUPPRESS_VE_BIT : 0ull;
 		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
-				      cpu_has_vmx_ept_execute_only());
+				      cpu_has_vmx_ept_execute_only(), init_value);
+		kvm_mmu_set_spte_init_value(init_value);
+	}
 
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f86a257dd71b..c3434b33c452 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -11,7 +11,7 @@
 #undef pr_fmt
 #define pr_fmt(fmt) "tdx: " fmt
 
-static bool __read_mostly enable_tdx = true;
+bool __read_mostly enable_tdx = true;
 module_param_named(tdx, enable_tdx, bool, 0644);
 
 #define TDX_MAX_NR_CPUID_CONFIGS					\
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 4ce7fcab6f64..b32e068c51b4 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -6,6 +6,7 @@
 
 #include "tdx_ops.h"
 
+extern bool __read_mostly enable_tdx;
 int tdx_module_setup(void);
 
 struct tdx_td_page {
@@ -166,6 +167,7 @@ static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 fiel
 }
 
 #else
+#define enable_tdx false
 static inline int tdx_module_setup(void) { return -ENODEV; };
 
 struct kvm_tdx;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 07fd892768be..00f88aa25047 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7065,6 +7065,14 @@ int vmx_vm_init(struct kvm *kvm)
 	if (!ple_gap)
 		kvm->arch.pause_in_guest = true;
 
+	/*
+	 * EPT Misconfigurations can be generated if the value of bits 2:0
+	 * of an EPT paging-structure entry is 110b (write/execute).
+	 */
+	if (enable_ept)
+		kvm_mmu_set_mmio_spte_mask(kvm, VMX_EPT_MISCONFIG_WX_VALUE,
+					   VMX_EPT_MISCONFIG_WX_VALUE, 0);
+
 	if (boot_cpu_has(X86_BUG_L1TF) && enable_ept) {
 		switch (l1tf_mitigation) {
 		case L1TF_MITIGATION_OFF:
-- 
2.25.1

