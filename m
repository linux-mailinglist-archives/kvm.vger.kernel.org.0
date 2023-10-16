Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E64147CAF83
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234213AbjJPQeZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbjJPQdu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:33:50 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466207EC0;
        Mon, 16 Oct 2023 09:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473386; x=1729009386;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=a2VO/S63rbaRbyuvQtRL+31/YdK9/3uMWuFTx1wDI5g=;
  b=Ngn7PIMAOLDEvG6KuN8XAUleGGhauBmmfnaZkDiPkGvzCRcWojgaLPM+
   jX4zJcIS+8j35SSEiey9R8cU4x8bUd/KYEQvfzBTuz79uFgCOJej6xtb/
   fCkYZ//b0/YY0vE3XEq6aqUNjqSz0kT0+pucxy9p6QmsMKpPEZtffplSF
   meXzZBFJ3B07cVxJtAy7KPm2JsQ8LNyYPoe3XfPBFeb2GfJjLIIpd44+l
   iPdkv9fW2AcaaVlqwgjXmSI4FVLFr8m8fojHrTglIeLMo5mGXUwsPNpRo
   3zIBEf6SY6+Q8z+Tc72bdu5XB4g2Jhwcg7GNNpb9Nr6Vy9cObixcDw/wQ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="365826065"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="365826065"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="1087126116"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="1087126116"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:37 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v16 035/116] KVM: x86/mmu: Track shadow MMIO value on a per-VM basis
Date:   Mon, 16 Oct 2023 09:13:47 -0700
Message-Id: <eea658589ac41e49a4f6064ef9fd84b5b6d5247d.1697471314.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697471314.git.isaku.yamahata@intel.com>
References: <cover.1697471314.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 742e97f23573..a2fd25fb2f9c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1280,6 +1280,8 @@ struct kvm_arch {
 	 */
 	spinlock_t mmu_unsync_pages_lock;
 
+	u64 shadow_mmio_value;
+
 	struct list_head assigned_dev_head;
 	struct iommu_domain *iommu_domain;
 	bool iommu_noncoherent;
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index f5ba6cf589aa..c30fefa39bb4 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -101,6 +101,7 @@ static inline u8 kvm_get_shadow_phys_bits(void)
 }
 
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
+void kvm_mmu_set_mmio_spte_value(struct kvm *kvm, u64 mmio_value);
 void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask);
 void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8cf3ac95bb30..469e73283824 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2519,7 +2519,7 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 				return kvm_mmu_prepare_zap_page(kvm, child,
 								invalid_list);
 		}
-	} else if (is_mmio_spte(pte)) {
+	} else if (is_mmio_spte(kvm, pte)) {
 		mmu_spte_clear_no_track(spte);
 	}
 	return 0;
@@ -4180,7 +4180,7 @@ static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr, bool direct)
 	if (WARN_ON_ONCE(reserved))
 		return -EINVAL;
 
-	if (is_mmio_spte(spte)) {
+	if (is_mmio_spte(vcpu->kvm, spte)) {
 		gfn_t gfn = get_mmio_spte_gfn(spte);
 		unsigned int access = get_mmio_spte_access(spte);
 
@@ -4751,7 +4751,7 @@ EXPORT_SYMBOL_GPL(kvm_mmu_new_pgd);
 static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
 			   unsigned int access)
 {
-	if (unlikely(is_mmio_spte(*sptep))) {
+	if (unlikely(is_mmio_spte(vcpu->kvm, *sptep))) {
 		if (gfn != get_mmio_spte_gfn(*sptep)) {
 			mmu_spte_clear_no_track(sptep);
 			return true;
@@ -6273,6 +6273,7 @@ int kvm_mmu_init_vm(struct kvm *kvm)
 {
 	int r;
 
+	kvm->arch.shadow_mmio_value = shadow_mmio_value;
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
 	INIT_LIST_HEAD(&kvm->arch.possible_nx_huge_pages);
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 02a466de2991..318135daf685 100644
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
@@ -411,6 +411,12 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
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
index 26bc95bbc962..1a163aee9ec6 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -264,9 +264,9 @@ static inline struct kvm_mmu_page *root_to_sp(hpa_t root)
 	return spte_to_child_sp(root);
 }
 
-static inline bool is_mmio_spte(u64 spte)
+static inline bool is_mmio_spte(struct kvm *kvm, u64 spte)
 {
-	return (spte & shadow_mmio_mask) == shadow_mmio_value &&
+	return (spte & shadow_mmio_mask) == kvm->arch.shadow_mmio_value &&
 	       likely(enable_mmio_caching);
 }
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 4f6f782d9e02..7712b1b86bd2 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -522,8 +522,8 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 		 * impact the guest since both the former and current SPTEs
 		 * are nonpresent.
 		 */
-		if (WARN_ON_ONCE(!is_mmio_spte(old_spte) &&
-				 !is_mmio_spte(new_spte) &&
+		if (WARN_ON_ONCE(!is_mmio_spte(kvm, old_spte) &&
+				 !is_mmio_spte(kvm, new_spte) &&
 				 !is_removed_spte(new_spte)))
 			pr_err("Unexpected SPTE change! Nonpresent SPTEs\n"
 			       "should not be replaced with another,\n"
@@ -1010,7 +1010,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 	}
 
 	/* If a MMIO SPTE is installed, the MMIO will need to be emulated. */
-	if (unlikely(is_mmio_spte(new_spte))) {
+	if (unlikely(is_mmio_spte(vcpu->kvm, new_spte))) {
 		vcpu->stat.pf_mmio_spte_created++;
 		trace_mark_mmio_spte(rcu_dereference(iter->sptep), iter->gfn,
 				     new_spte);
-- 
2.25.1

