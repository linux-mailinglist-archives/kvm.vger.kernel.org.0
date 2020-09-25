Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE90279332
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 23:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729003AbgIYVXT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 17:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728964AbgIYVXR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 17:23:17 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2972C0613CE
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:17 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id s2so3259665pgm.18
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=67kS+AlksdlFy819QhjV7LatCvAcvKBj03i0x5Ti9mo=;
        b=nlElI6Hj4N5hLTPXKvZzwMiIkg/iRt2P6oTdO3b8Ss1Pa1sBWFjPH4djskRIS5JWWb
         eML9nWSg1QrczG72UnJWTJoevBH5ny1cQbsdfk/6WD3Y+DvKzo2jU9Ev4RI3DbzKyd5A
         NU/LM7iIeDC2W/HSX2c1xFAk6rcp7V3vDdiAhJ188M4kj2Qs3ZgeOWMLHapApPgXFisr
         UmhzyXtqUeieowGEMPdIWA2qg2y5hPMecb4bAWvnVmMzyl4p76B0UnJcndZvZBYZ/GXY
         OhK/CMGGuDNY2ruq3QgerYA0PFSKMcsma4N9bA9SLTm3Qacfo+wi8n6KlIMdngfjT017
         mEEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=67kS+AlksdlFy819QhjV7LatCvAcvKBj03i0x5Ti9mo=;
        b=bmwoKYE/vCHC26CfmDhm8M/oaRjV92UdD5JH2TAhAlmvV6SQakT5sjj1YeoAjcC3ho
         Au8S0CDYgquZDxIOq1Brh+JLXs57OKxom7JwRyDU+XwVbNdU0oQvt1AwQXH1EXhze8ue
         xTZnOB7LheteD23wqw8rR9tDLmIFje3QmACqH2YwPfzSwthFARx7SgrJizeTkFTqnRpg
         WFL64BOGoB8o9oN4h7FbhnONXDmPmAb7YwrBhT23O5+cXffAx5loOtZfO2SBAEf9a9LJ
         CuAAHYlghCt5b3h6HEPe26BNGkb9VY7COa4+daZgmaIjA7yLBpekvju1Lwtkpa28Q4Hv
         MGVQ==
X-Gm-Message-State: AOAM531SVIIZrRRCurqaEQhK92Dqq5/UU+Meh9rl7KT3kuGmZSOyF5JE
        TRi7TuI0sbdNLn2WpeMkeNJElJg0x/Hz
X-Google-Smtp-Source: ABdhPJyf4GQP24ATnh6pSZDVHP6P6VOxyd9ONqC7oO+l+0WZsjBFnLwudc+L/dBRONuzxJVfuStARy1Hz5ZZ
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a62:3786:0:b029:150:e5d9:1e51 with SMTP id
 e128-20020a6237860000b0290150e5d91e51mr1017187pfa.77.1601068997148; Fri, 25
 Sep 2020 14:23:17 -0700 (PDT)
Date:   Fri, 25 Sep 2020 14:22:45 -0700
In-Reply-To: <20200925212302.3979661-1-bgardon@google.com>
Message-Id: <20200925212302.3979661-6-bgardon@google.com>
Mime-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH 05/22] kvm: mmu: Add functions to handle changed TDP SPTEs
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
 arch/x86/kvm/mmu/mmu.c          |   6 +-
 arch/x86/kvm/mmu/mmu_internal.h |   3 +
 arch/x86/kvm/mmu/tdp_mmu.c      | 105 ++++++++++++++++++++++++++++++++
 3 files changed, 111 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0f871e36394da..f09081f9137b0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -310,8 +310,8 @@ static void kvm_flush_remote_tlbs_with_range(struct kvm *kvm,
 		kvm_flush_remote_tlbs(kvm);
 }
 
-static void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
-		u64 start_gfn, u64 pages)
+void kvm_flush_remote_tlbs_with_address(struct kvm *kvm, u64 start_gfn,
+					u64 pages)
 {
 	struct kvm_tlb_range range;
 
@@ -819,7 +819,7 @@ static bool is_accessed_spte(u64 spte)
 			     : !is_access_track_spte(spte);
 }
 
-static bool is_dirty_spte(u64 spte)
+bool is_dirty_spte(u64 spte)
 {
 	u64 dirty_mask = spte_shadow_dirty_mask(spte);
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 530b7d893c7b3..ff1fe0e04fba5 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -83,5 +83,8 @@ kvm_pfn_t spte_to_pfn(u64 pte);
 bool is_mmio_spte(u64 spte);
 int is_shadow_present_pte(u64 pte);
 int is_last_spte(u64 pte, int level);
+bool is_dirty_spte(u64 spte);
 
+void kvm_flush_remote_tlbs_with_address(struct kvm *kvm, u64 start_gfn,
+					u64 pages);
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index cdca829e42040..653507773b42c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -189,3 +189,108 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 
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
+static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
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
-- 
2.28.0.709.gb0816b6eb0-goog

