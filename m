Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAA6F6A3C94
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbjB0IZp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:25:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbjB0IY5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:24:57 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B4301C7F2;
        Mon, 27 Feb 2023 00:24:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486256; x=1709022256;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WqnskFIQm98MygHS3gDq/PQGttioEKm5ixTtOo1X8Eg=;
  b=jmQkASTdIGI594CW6iIEmlcCQBMVlLc2wdRAnfc9GRJcjYL8uBt9B9wo
   u0OocMDQCYoSSodudWmNf5scb8EiHXkBQZqx//fo7osy1LOMqMzlhUfST
   KKTsL2oorhN5AYXsT5iVS1hTkX8ejdChA5ukTz3ilCA76Ne16nyXL4ooT
   s8HC2xMu/6UGfUMRwI7Q/mWIfjxlNgVV+jKB21eW6XA/gNhUx9G36MQTw
   v2IstUgofysbZjpcGeysnLFXcix91Q+wWsYyKbu4xequYKuHaogZLhNZz
   ySHIQnQOvAZoKQ9BAqFABkr7AQE8n8ZC2w1jCe7Nv2rQdjvdhDSjj0jeb
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317608784"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317608784"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:06 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242145"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242145"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:05 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v12 028/106] KVM: x86/mmu: Track shadow MMIO value on a per-VM basis
Date:   Mon, 27 Feb 2023 00:22:27 -0800
Message-Id: <feea31f8b6101435d62586b9286e9ddbb73ac373.1677484918.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1677484918.git.isaku.yamahata@intel.com>
References: <cover.1677484918.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX will use a different shadow PTE entry value for MMIO from VMX.  Add
members to kvm_arch and track value for MMIO per-VM instead of global
variables.  By using the per-VM EPT entry value for MMIO, the existing VMX
logic is kept working.  Introduce a separate setter function so that guest
TD can override later.

Also require mmio spte cachcing for TDX.  Actually this is true case
because TDX require EPT and KVM EPT allows mmio spte caching.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/mmu.h              |  1 +
 arch/x86/kvm/mmu/mmu.c          |  7 ++++---
 arch/x86/kvm/mmu/spte.c         | 10 ++++++++--
 arch/x86/kvm/mmu/spte.h         |  4 ++--
 arch/x86/kvm/mmu/tdp_mmu.c      |  6 +++---
 6 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e8506b48b97c..f120c4484316 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1260,6 +1260,8 @@ struct kvm_arch {
 	 */
 	spinlock_t mmu_unsync_pages_lock;
 
+	u64 shadow_mmio_value;
+
 	struct list_head assigned_dev_head;
 	struct iommu_domain *iommu_domain;
 	bool iommu_noncoherent;
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 951b14079602..0234201d5e63 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -101,6 +101,7 @@ static inline u8 kvm_get_shadow_phys_bits(void)
 }
 
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
+void kvm_mmu_set_mmio_spte_value(struct kvm *kvm, u64 mmio_value);
 void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask);
 void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5ce591bb6c19..8955d893d173 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2445,7 +2445,7 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 				return kvm_mmu_prepare_zap_page(kvm, child,
 								invalid_list);
 		}
-	} else if (is_mmio_spte(pte)) {
+	} else if (is_mmio_spte(kvm, pte)) {
 		mmu_spte_clear_no_track(spte);
 	}
 	return 0;
@@ -4126,7 +4126,7 @@ static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr, bool direct)
 	if (WARN_ON(reserved))
 		return -EINVAL;
 
-	if (is_mmio_spte(spte)) {
+	if (is_mmio_spte(vcpu->kvm, spte)) {
 		gfn_t gfn = get_mmio_spte_gfn(spte);
 		unsigned int access = get_mmio_spte_access(spte);
 
@@ -4674,7 +4674,7 @@ static unsigned long get_cr3(struct kvm_vcpu *vcpu)
 static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
 			   unsigned int access)
 {
-	if (unlikely(is_mmio_spte(*sptep))) {
+	if (unlikely(is_mmio_spte(vcpu->kvm, *sptep))) {
 		if (gfn != get_mmio_spte_gfn(*sptep)) {
 			mmu_spte_clear_no_track(sptep);
 			return true;
@@ -6163,6 +6163,7 @@ int kvm_mmu_init_vm(struct kvm *kvm)
 	struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
 	int r;
 
+	kvm->arch.shadow_mmio_value = shadow_mmio_value;
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
 	INIT_LIST_HEAD(&kvm->arch.possible_nx_huge_pages);
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index cc0bc058fb25..a23e9205fc42 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -74,10 +74,10 @@ u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access)
 	u64 spte = generation_mmio_spte_mask(gen);
 	u64 gpa = gfn << PAGE_SHIFT;
 
-	WARN_ON_ONCE(!shadow_mmio_value);
+	WARN_ON_ONCE(!vcpu->kvm->arch.shadow_mmio_value);
 
 	access &= shadow_mmio_access_mask;
-	spte |= shadow_mmio_value | access;
+	spte |= vcpu->kvm->arch.shadow_mmio_value | access;
 	spte |= gpa | shadow_nonpresent_or_rsvd_mask;
 	spte |= (gpa & shadow_nonpresent_or_rsvd_mask)
 		<< SHADOW_NONPRESENT_OR_RSVD_MASK_LEN;
@@ -413,6 +413,12 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
 
+void kvm_mmu_set_mmio_spte_value(struct kvm *kvm, u64 mmio_value)
+{
+	kvm->arch.shadow_mmio_value = mmio_value;
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_value);
+
 void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask)
 {
 	/* shadow_me_value must be a subset of shadow_me_mask */
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 471378ee9071..256395eb593f 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -251,9 +251,9 @@ static inline struct kvm_mmu_page *sptep_to_sp(u64 *sptep)
 	return to_shadow_page(__pa(sptep));
 }
 
-static inline bool is_mmio_spte(u64 spte)
+static inline bool is_mmio_spte(struct kvm *kvm, u64 spte)
 {
-	return (spte & shadow_mmio_mask) == shadow_mmio_value &&
+	return (spte & shadow_mmio_mask) == kvm->arch.shadow_mmio_value &&
 	       likely(enable_mmio_caching);
 }
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 380bd0cea939..2619e20c4dfa 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -576,8 +576,8 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
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
@@ -1095,7 +1095,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 	}
 
 	/* If a MMIO SPTE is installed, the MMIO will need to be emulated. */
-	if (unlikely(is_mmio_spte(new_spte))) {
+	if (unlikely(is_mmio_spte(vcpu->kvm, new_spte))) {
 		vcpu->stat.pf_mmio_spte_created++;
 		trace_mark_mmio_spte(rcu_dereference(iter->sptep), iter->gfn,
 				     new_spte);
-- 
2.25.1

