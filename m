Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73B985F9EA2
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 14:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbiJJMU2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 08:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232073AbiJJMUK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 08:20:10 -0400
Received: from out0-150.mail.aliyun.com (out0-150.mail.aliyun.com [140.205.0.150])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D071BEAC;
        Mon, 10 Oct 2022 05:19:52 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047187;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---.PYG70qv_1665404358;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.PYG70qv_1665404358)
          by smtp.aliyun-inc.com;
          Mon, 10 Oct 2022 20:19:19 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/6] KVM: x86/mmu: Move round_gfn_for_level() helper into mmu_internal.h
Date:   Mon, 10 Oct 2022 20:19:12 +0800
Message-Id: <415c64782f27444898db650e21cf28eeb6441dfa.1665214747.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1665214747.git.houwenlong.hwl@antgroup.com>
References: <cover.1665214747.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rounding down the GFN to a huge page size is a common pattern throughout
KVM, so move round_gfn_for_level() helper in tdp_iter.c to
mmu_internal.h for common usage. Also rename it as gfn_round_for_level()
to use gfn_* prefix and clean up the other call sites.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c          |  5 +++--
 arch/x86/kvm/mmu/mmu_internal.h |  5 +++++
 arch/x86/kvm/mmu/paging_tmpl.h  |  2 +-
 arch/x86/kvm/mmu/tdp_iter.c     | 11 +++--------
 4 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6f81539061d6..7de3579d5a27 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3117,7 +3117,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		if (fault->nx_huge_page_workaround_enabled)
 			disallowed_hugepage_adjust(fault, *it.sptep, it.level);
 
-		base_gfn = fault->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
+		base_gfn = gfn_round_for_level(fault->gfn, it.level);
 		if (it.level == fault->goal_level)
 			break;
 
@@ -4340,7 +4340,8 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	if (shadow_memtype_mask && kvm_arch_has_noncoherent_dma(vcpu->kvm)) {
 		for ( ; fault->max_level > PG_LEVEL_4K; --fault->max_level) {
 			int page_num = KVM_PAGES_PER_HPAGE(fault->max_level);
-			gfn_t base = (fault->addr >> PAGE_SHIFT) & ~(page_num - 1);
+			gfn_t base = gfn_round_for_level(fault->addr >> PAGE_SHIFT,
+							 fault->max_level);
 
 			if (kvm_mtrr_check_gfn_range_consistency(vcpu, base, page_num))
 				break;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 582def531d4d..17488d70f7da 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -155,6 +155,11 @@ static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
 	return kvm_x86_ops.cpu_dirty_log_size && sp->role.guest_mode;
 }
 
+static inline gfn_t gfn_round_for_level(gfn_t gfn, int level)
+{
+	return gfn & -KVM_PAGES_PER_HPAGE(level);
+}
+
 int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
 			    gfn_t gfn, bool can_unsync, bool prefetch);
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 5ab5f94dcb6f..d23295c1d1ac 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -701,7 +701,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 		if (fault->nx_huge_page_workaround_enabled)
 			disallowed_hugepage_adjust(fault, *it.sptep, it.level);
 
-		base_gfn = fault->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
+		base_gfn = gfn_round_for_level(fault->gfn, it.level);
 		if (it.level == fault->goal_level)
 			break;
 
diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index 39b48e7d7d1a..c4bb4abed6d0 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -15,11 +15,6 @@ static void tdp_iter_refresh_sptep(struct tdp_iter *iter)
 	iter->old_spte = kvm_tdp_mmu_read_spte(iter->sptep);
 }
 
-static gfn_t round_gfn_for_level(gfn_t gfn, int level)
-{
-	return gfn & -KVM_PAGES_PER_HPAGE(level);
-}
-
 /*
  * Return the TDP iterator to the root PT and allow it to continue its
  * traversal over the paging structure from there.
@@ -30,7 +25,7 @@ void tdp_iter_restart(struct tdp_iter *iter)
 	iter->yielded_gfn = iter->next_last_level_gfn;
 	iter->level = iter->root_level;
 
-	iter->gfn = round_gfn_for_level(iter->next_last_level_gfn, iter->level);
+	iter->gfn = gfn_round_for_level(iter->next_last_level_gfn, iter->level);
 	tdp_iter_refresh_sptep(iter);
 
 	iter->valid = true;
@@ -97,7 +92,7 @@ static bool try_step_down(struct tdp_iter *iter)
 
 	iter->level--;
 	iter->pt_path[iter->level - 1] = child_pt;
-	iter->gfn = round_gfn_for_level(iter->next_last_level_gfn, iter->level);
+	iter->gfn = gfn_round_for_level(iter->next_last_level_gfn, iter->level);
 	tdp_iter_refresh_sptep(iter);
 
 	return true;
@@ -139,7 +134,7 @@ static bool try_step_up(struct tdp_iter *iter)
 		return false;
 
 	iter->level++;
-	iter->gfn = round_gfn_for_level(iter->gfn, iter->level);
+	iter->gfn = gfn_round_for_level(iter->gfn, iter->level);
 	tdp_iter_refresh_sptep(iter);
 
 	return true;
-- 
2.31.1

