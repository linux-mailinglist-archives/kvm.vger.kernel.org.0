Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C43A05F0886
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbiI3KUu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbiI3KTE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:19:04 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38855166F3C;
        Fri, 30 Sep 2022 03:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533142; x=1696069142;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ReTvh59xSNWb7+bHPDJ2zE4tCXa/zPkwj0z2c8vZTnk=;
  b=JSY9bj8q8eDp0eyh1IC1cAua6kvoRFI963X+C8TSTasHhxzSqdDAejMK
   TlRspiOr6criNlCeqKs0gYfVPsr8RGl0gBhI/FB02d4ESL8uNWw+TelgF
   1n4st8vMxnZGicpuA3kaExh0NIs8A/ckmi0SjVwS7xg9+boPI3V0wl6Az
   VC+1eNTAuqcXrozX5vZQKU7KXXbUjKsv4utYHw/5MkBZeRyRnHeIZChJu
   4r6A6WE4v4SPYW0uZFIUZmBSNaQRTnsAdK2styFPigtFalied8cTSRlF2
   yBN8eKxj1ISiL1hNp4RMxURayk8pQfPHrZ1SJcpHelzDwL3nWr50gR90n
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="281870090"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="281870090"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:57 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807613"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807613"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:57 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v9 034/105] KVM: x86/mmu: Track shadow MMIO value on a per-VM basis
Date:   Fri, 30 Sep 2022 03:17:28 -0700
Message-Id: <733b346ad4772d0dd7e64ccb451a1f57b8a2ce80.1664530907.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX will use a different shadow PTE entry value for MMIO from VMX.  Add
members to kvm_arch and track value for MMIO per-VM instead of global
variables.  By using the per-VM EPT entry value for MMIO, the existing VMX
logic is kept working.  To untangle the logic to initialize
shadow_mmio_access_mask, introduce a separate setter function.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/mmu.h              |  1 +
 arch/x86/kvm/mmu/mmu.c          |  7 ++++---
 arch/x86/kvm/mmu/spte.c         | 11 +++++++++--
 arch/x86/kvm/mmu/spte.h         |  4 ++--
 arch/x86/kvm/mmu/tdp_mmu.c      |  6 +++---
 6 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index fc28bf9c0552..4d4794789c42 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1165,6 +1165,8 @@ struct kvm_arch {
 	 */
 	spinlock_t mmu_unsync_pages_lock;
 
+	u64 shadow_mmio_value;
+
 	struct list_head assigned_dev_head;
 	struct iommu_domain *iommu_domain;
 	bool iommu_noncoherent;
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 000a0a6ac815..f86fb04fb7d7 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -101,6 +101,7 @@ static inline u8 kvm_get_shadow_phys_bits(void)
 }
 
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
+void kvm_mmu_set_mmio_spte_value(struct kvm *kvm, u64 mmio_value);
 void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask);
 void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ff8de361067c..fdd773ef9400 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2409,7 +2409,7 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 				return kvm_mmu_prepare_zap_page(kvm, child,
 								invalid_list);
 		}
-	} else if (is_mmio_spte(pte)) {
+	} else if (is_mmio_spte(kvm, pte)) {
 		mmu_spte_clear_no_track(spte);
 	}
 	return 0;
@@ -4068,7 +4068,7 @@ static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr, bool direct)
 	if (WARN_ON(reserved))
 		return -EINVAL;
 
-	if (is_mmio_spte(spte)) {
+	if (is_mmio_spte(vcpu->kvm, spte)) {
 		gfn_t gfn = get_mmio_spte_gfn(spte);
 		unsigned int access = get_mmio_spte_access(spte);
 
@@ -4569,7 +4569,7 @@ static unsigned long get_cr3(struct kvm_vcpu *vcpu)
 static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
 			   unsigned int access)
 {
-	if (unlikely(is_mmio_spte(*sptep))) {
+	if (unlikely(is_mmio_spte(vcpu->kvm, *sptep))) {
 		if (gfn != get_mmio_spte_gfn(*sptep)) {
 			mmu_spte_clear_no_track(sptep);
 			return true;
@@ -6052,6 +6052,7 @@ int kvm_mmu_init_vm(struct kvm *kvm)
 	struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
 	int r;
 
+	kvm->arch.shadow_mmio_value = shadow_mmio_value;
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
 	INIT_LIST_HEAD(&kvm->arch.lpage_disallowed_mmu_pages);
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 5d5c06d4fd89..8f468ee2b985 100644
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
@@ -352,6 +352,7 @@ u64 mark_spte_for_access_track(u64 spte)
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
 {
 	BUG_ON((u64)(unsigned)access_mask != access_mask);
+
 	WARN_ON(mmio_value & shadow_nonpresent_or_rsvd_lower_gfn_mask);
 
 	/*
@@ -401,6 +402,12 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
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
index 7e0f79e8f45b..82f0d5c08b77 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -241,9 +241,9 @@ static inline int spte_index(u64 *sptep)
  */
 extern u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
 
-static inline bool is_mmio_spte(u64 spte)
+static inline bool is_mmio_spte(struct kvm *kvm, u64 spte)
 {
-	return (spte & shadow_mmio_mask) == shadow_mmio_value &&
+	return (spte & shadow_mmio_mask) == kvm->arch.shadow_mmio_value &&
 	       likely(enable_mmio_caching);
 }
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index af510dd31ebc..b80422ea798d 100644
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
@@ -1094,7 +1094,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 	}
 
 	/* If a MMIO SPTE is installed, the MMIO will need to be emulated. */
-	if (unlikely(is_mmio_spte(new_spte))) {
+	if (unlikely(is_mmio_spte(vcpu->kvm, new_spte))) {
 		vcpu->stat.pf_mmio_spte_created++;
 		trace_mark_mmio_spte(rcu_dereference(iter->sptep), iter->gfn,
 				     new_spte);
-- 
2.25.1

