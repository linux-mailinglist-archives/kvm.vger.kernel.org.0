Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F409328E668
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 20:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388170AbgJNS2u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Oct 2020 14:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388378AbgJNS1O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Oct 2020 14:27:14 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED86DC0613D4
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 11:27:13 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id z68so374349ybh.22
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 11:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=LJccCj22FhIcLSjpiTZevAsK4N+j9vDaHHFlKDDiBnI=;
        b=ukZxyYwlOUoVwqospygztboy0EKBoV9iaHlOZ0mK5Obs8Fs0gB34h6mOzY1J1U+0wJ
         xtOwUmwc1waP5LOSfVR3XO1jQezkqWTCaQCXxWg2upRKWi4bFgJYQprMO/dpiX4GJK9g
         H4cjUuJK8PstICMl46JV+mCpkbFFwQRTtcHl5Wbm1cOBd7/HUOHVWVgwjjJex8wLwA0E
         58iJQW0D/xsaT1rOJCtLU+iHgdmTxFXPyRkbqE0X8VfQRP55JwX3mS+xaxAJPYKTrjen
         8EbWU8etK3+Kypa0lYZLNqA4DlPD7TRXgXuxS4wOPnUiQrF32x5ZMchHoNzaP1kU+yEG
         99pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LJccCj22FhIcLSjpiTZevAsK4N+j9vDaHHFlKDDiBnI=;
        b=K3qwHrNaHMB9spbJQY/OwFUmaeTgqKSHub2wc54Vhe2Z6uu+G/MVqrKKzPgcGloUJ+
         PysZJT5NEmZNYYJ725Yz3KiDshD7kPFMPIR9EulgvPrBHo1EV8JxlZj2jKDKhk1jZMY7
         3w1kKe8WiENDlbzoti2SRJWQIdl1zoeRhhhb05mKUaudEsbC/F2q5StotGXdtsw1+E+f
         4TCmErAOFs92DX6YhNBgrm9/T6DnPoHdmH9cTJWnhhjRIVh+6zCLHTqt1rwiTCc23DHm
         LwWFiVoPBMd9DqMkx/gSPZ23uPh3Oy7YpLWyUoS/sQLKoRRY6zp22ZdFeYfJFS/zgAT8
         8jBg==
X-Gm-Message-State: AOAM531q2gj8InKm6oXTY9XRoNmvkfC4+Qn87INKiZK3MYRFlow6qI02
        g1w5IR5CcTR9Zk22Ls2SyKDnfex63b2p
X-Google-Smtp-Source: ABdhPJxIxoh7GTshMJizIQPmBpFS9Q30EuEi84YWMrSvMc58df1Ux6Qcq1UISoiGUBxkzy1pBg7y8NsgpmUU
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a25:f84:: with SMTP id 126mr831740ybp.377.1602700033158;
 Wed, 14 Oct 2020 11:27:13 -0700 (PDT)
Date:   Wed, 14 Oct 2020 11:26:45 -0700
In-Reply-To: <20201014182700.2888246-1-bgardon@google.com>
Message-Id: <20201014182700.2888246-6-bgardon@google.com>
Mime-Version: 1.0
References: <20201014182700.2888246-1-bgardon@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v2 05/20] kvm: x86/mmu: Add functions to handle changed TDP SPTEs
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The existing bookkeeping done by KVM when a PTE is changed is spread
around several functions. This makes it difficult to remember all the
stats, bitmaps, and other subsystems that need to be updated whenever a
PTE is modified. When a non-leaf PTE is marked non-present or becomes a
leaf PTE, page table memory must also be freed. To simplify the MMU and
facilitate the use of atomic operations on SPTEs in future patches, create
functions to handle some of the bookkeeping required as a result of
a change.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c          |  39 +----------
 arch/x86/kvm/mmu/mmu_internal.h |  38 +++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c      | 112 ++++++++++++++++++++++++++++++++
 3 files changed, 152 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a3340ed59ad1d..8bf20723c6177 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -105,21 +105,6 @@ enum {
 	AUDIT_POST_SYNC
 };
 
-#undef MMU_DEBUG
-
-#ifdef MMU_DEBUG
-static bool dbg = 0;
-module_param(dbg, bool, 0644);
-
-#define pgprintk(x...) do { if (dbg) printk(x); } while (0)
-#define rmap_printk(x...) do { if (dbg) printk(x); } while (0)
-#define MMU_WARN_ON(x) WARN_ON(x)
-#else
-#define pgprintk(x...) do { } while (0)
-#define rmap_printk(x...) do { } while (0)
-#define MMU_WARN_ON(x) do { } while (0)
-#endif
-
 #define PTE_PREFETCH_NUM		8
 
 #define PT32_LEVEL_BITS 10
@@ -211,7 +196,6 @@ static u64 __read_mostly shadow_nx_mask;
 static u64 __read_mostly shadow_x_mask;	/* mutual exclusive with nx_mask */
 static u64 __read_mostly shadow_user_mask;
 static u64 __read_mostly shadow_accessed_mask;
-static u64 __read_mostly shadow_dirty_mask;
 static u64 __read_mostly shadow_mmio_value;
 static u64 __read_mostly shadow_mmio_access_mask;
 static u64 __read_mostly shadow_present_mask;
@@ -287,8 +271,8 @@ static void kvm_flush_remote_tlbs_with_range(struct kvm *kvm,
 		kvm_flush_remote_tlbs(kvm);
 }
 
-static void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
-		u64 start_gfn, u64 pages)
+void kvm_flush_remote_tlbs_with_address(struct kvm *kvm, u64 start_gfn,
+					u64 pages)
 {
 	struct kvm_tlb_range range;
 
@@ -324,12 +308,6 @@ static inline bool kvm_vcpu_ad_need_write_protect(struct kvm_vcpu *vcpu)
 	return vcpu->arch.mmu == &vcpu->arch.guest_mmu;
 }
 
-static inline bool spte_ad_enabled(u64 spte)
-{
-	MMU_WARN_ON(is_mmio_spte(spte));
-	return (spte & SPTE_SPECIAL_MASK) != SPTE_AD_DISABLED_MASK;
-}
-
 static inline bool spte_ad_need_write_protect(u64 spte)
 {
 	MMU_WARN_ON(is_mmio_spte(spte));
@@ -347,12 +325,6 @@ static inline u64 spte_shadow_accessed_mask(u64 spte)
 	return spte_ad_enabled(spte) ? shadow_accessed_mask : 0;
 }
 
-static inline u64 spte_shadow_dirty_mask(u64 spte)
-{
-	MMU_WARN_ON(is_mmio_spte(spte));
-	return spte_ad_enabled(spte) ? shadow_dirty_mask : 0;
-}
-
 static inline bool is_access_track_spte(u64 spte)
 {
 	return !spte_ad_enabled(spte) && (spte & shadow_acc_track_mask) == 0;
@@ -767,13 +739,6 @@ static bool is_accessed_spte(u64 spte)
 			     : !is_access_track_spte(spte);
 }
 
-static bool is_dirty_spte(u64 spte)
-{
-	u64 dirty_mask = spte_shadow_dirty_mask(spte);
-
-	return dirty_mask ? spte & dirty_mask : spte & PT_WRITABLE_MASK;
-}
-
 /* Rules for using mmu_spte_set:
  * Set the sptep from nonpresent to present.
  * Note: the sptep being assigned *must* be either not present
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 6cedf578c9a8d..c053a157e4d55 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -8,6 +8,21 @@
 
 #include <asm/kvm_host.h>
 
+#undef MMU_DEBUG
+
+#ifdef MMU_DEBUG
+static bool dbg = 0;
+module_param(dbg, bool, 0644);
+
+#define pgprintk(x...) do { if (dbg) printk(x); } while (0)
+#define rmap_printk(x...) do { if (dbg) printk(x); } while (0)
+#define MMU_WARN_ON(x) WARN_ON(x)
+#else
+#define pgprintk(x...) do { } while (0)
+#define rmap_printk(x...) do { } while (0)
+#define MMU_WARN_ON(x) do { } while (0)
+#endif
+
 struct kvm_mmu_page {
 	struct list_head link;
 	struct hlist_node hash_link;
@@ -105,6 +120,8 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 #define ACC_USER_MASK    PT_USER_MASK
 #define ACC_ALL          (ACC_EXEC_MASK | ACC_WRITE_MASK | ACC_USER_MASK)
 
+static u64 __read_mostly shadow_dirty_mask;
+
 /* Functions for interpreting SPTEs */
 static inline bool is_mmio_spte(u64 spte)
 {
@@ -150,4 +167,25 @@ static inline bool kvm_mmu_put_root(struct kvm_mmu_page *sp)
 }
 
 
+static inline bool spte_ad_enabled(u64 spte)
+{
+	MMU_WARN_ON(is_mmio_spte(spte));
+	return (spte & SPTE_SPECIAL_MASK) != SPTE_AD_DISABLED_MASK;
+}
+
+static inline u64 spte_shadow_dirty_mask(u64 spte)
+{
+	MMU_WARN_ON(is_mmio_spte(spte));
+	return spte_ad_enabled(spte) ? shadow_dirty_mask : 0;
+}
+
+static inline bool is_dirty_spte(u64 spte)
+{
+	u64 dirty_mask = spte_shadow_dirty_mask(spte);
+
+	return dirty_mask ? spte & dirty_mask : spte & PT_WRITABLE_MASK;
+}
+
+void kvm_flush_remote_tlbs_with_address(struct kvm *kvm, u64 start_gfn,
+					u64 pages);
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 09a84a6e157b6..f2bd3a6928ce9 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -2,6 +2,7 @@
 
 #include "mmu.h"
 #include "mmu_internal.h"
+#include "tdp_iter.h"
 #include "tdp_mmu.h"
 
 static bool __read_mostly tdp_mmu_enabled = false;
@@ -150,3 +151,114 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 
 	return __pa(root->spt);
 }
+
+static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
+				u64 old_spte, u64 new_spte, int level);
+
+/**
+ * handle_changed_spte - handle bookkeeping associated with an SPTE change
+ * @kvm: kvm instance
+ * @as_id: the address space of the paging structure the SPTE was a part of
+ * @gfn: the base GFN that was mapped by the SPTE
+ * @old_spte: The value of the SPTE before the change
+ * @new_spte: The value of the SPTE after the change
+ * @level: the level of the PT the SPTE is part of in the paging structure
+ *
+ * Handle bookkeeping that might result from the modification of a SPTE.
+ * This function must be called for all TDP SPTE modifications.
+ */
+static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
+				u64 old_spte, u64 new_spte, int level)
+{
+	bool was_present = is_shadow_present_pte(old_spte);
+	bool is_present = is_shadow_present_pte(new_spte);
+	bool was_leaf = was_present && is_last_spte(old_spte, level);
+	bool is_leaf = is_present && is_last_spte(new_spte, level);
+	bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
+	u64 *pt;
+	u64 old_child_spte;
+	int i;
+
+	WARN_ON(level > PT64_ROOT_MAX_LEVEL);
+	WARN_ON(level < PG_LEVEL_4K);
+	WARN_ON(gfn % KVM_PAGES_PER_HPAGE(level));
+
+	/*
+	 * If this warning were to trigger it would indicate that there was a
+	 * missing MMU notifier or a race with some notifier handler.
+	 * A present, leaf SPTE should never be directly replaced with another
+	 * present leaf SPTE pointing to a differnt PFN. A notifier handler
+	 * should be zapping the SPTE before the main MM's page table is
+	 * changed, or the SPTE should be zeroed, and the TLBs flushed by the
+	 * thread before replacement.
+	 */
+	if (was_leaf && is_leaf && pfn_changed) {
+		pr_err("Invalid SPTE change: cannot replace a present leaf\n"
+		       "SPTE with another present leaf SPTE mapping a\n"
+		       "different PFN!\n"
+		       "as_id: %d gfn: %llx old_spte: %llx new_spte: %llx level: %d",
+		       as_id, gfn, old_spte, new_spte, level);
+
+		/*
+		 * Crash the host to prevent error propagation and guest data
+		 * courruption.
+		 */
+		BUG();
+	}
+
+	if (old_spte == new_spte)
+		return;
+
+	/*
+	 * The only times a SPTE should be changed from a non-present to
+	 * non-present state is when an MMIO entry is installed/modified/
+	 * removed. In that case, there is nothing to do here.
+	 */
+	if (!was_present && !is_present) {
+		/*
+		 * If this change does not involve a MMIO SPTE, it is
+		 * unexpected. Log the change, though it should not impact the
+		 * guest since both the former and current SPTEs are nonpresent.
+		 */
+		if (WARN_ON(!is_mmio_spte(old_spte) && !is_mmio_spte(new_spte)))
+			pr_err("Unexpected SPTE change! Nonpresent SPTEs\n"
+			       "should not be replaced with another,\n"
+			       "different nonpresent SPTE, unless one or both\n"
+			       "are MMIO SPTEs.\n"
+			       "as_id: %d gfn: %llx old_spte: %llx new_spte: %llx level: %d",
+			       as_id, gfn, old_spte, new_spte, level);
+		return;
+	}
+
+
+	if (was_leaf && is_dirty_spte(old_spte) &&
+	    (!is_dirty_spte(new_spte) || pfn_changed))
+		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
+
+	/*
+	 * Recursively handle child PTs if the change removed a subtree from
+	 * the paging structure.
+	 */
+	if (was_present && !was_leaf && (pfn_changed || !is_present)) {
+		pt = spte_to_child_pt(old_spte, level);
+
+		for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
+			old_child_spte = *(pt + i);
+			*(pt + i) = 0;
+			handle_changed_spte(kvm, as_id,
+				gfn + (i * KVM_PAGES_PER_HPAGE(level - 1)),
+				old_child_spte, 0, level - 1);
+		}
+
+		kvm_flush_remote_tlbs_with_address(kvm, gfn,
+						   KVM_PAGES_PER_HPAGE(level));
+
+		free_page((unsigned long)pt);
+	}
+}
+
+static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
+				u64 old_spte, u64 new_spte, int level)
+{
+	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level);
+}
-- 
2.28.0.1011.ga647a8990f-goog

