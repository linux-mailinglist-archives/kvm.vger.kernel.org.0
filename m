Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5402361B86
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 10:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240216AbhDPIZv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 04:25:51 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:17365 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239119AbhDPIZu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Apr 2021 04:25:50 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FM8P00bVXzlYCv;
        Fri, 16 Apr 2021 16:23:32 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.224) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Fri, 16 Apr 2021 16:25:14 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>
CC:     <wanghaibin.wang@huawei.com>
Subject: [RFC PATCH v2 1/2] KVM: x86: Support write protect gfn with min_level
Date:   Fri, 16 Apr 2021 16:25:10 +0800
Message-ID: <20210416082511.2856-2-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210416082511.2856-1-zhukeqian1@huawei.com>
References: <20210416082511.2856-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.224]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Under some circumstances, we just need to write protect large page
gfn. This gets prepared for write protecting large page lazily during
dirty log tracking.

None function and performance change expected.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 arch/x86/kvm/mmu/mmu.c          |  9 +++++----
 arch/x86/kvm/mmu/mmu_internal.h |  3 ++-
 arch/x86/kvm/mmu/page_track.c   |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c      | 16 ++++++++++++----
 arch/x86/kvm/mmu/tdp_mmu.h      |  3 ++-
 5 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 486aa94ecf1d..2ce5bc2ea46d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1265,20 +1265,21 @@ int kvm_cpu_dirty_log_size(void)
 }
 
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
-				    struct kvm_memory_slot *slot, u64 gfn)
+				    struct kvm_memory_slot *slot, u64 gfn,
+				    int min_level)
 {
 	struct kvm_rmap_head *rmap_head;
 	int i;
 	bool write_protected = false;
 
-	for (i = PG_LEVEL_4K; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
+	for (i = min_level; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
 		rmap_head = __gfn_to_rmap(gfn, i, slot);
 		write_protected |= __rmap_write_protect(kvm, rmap_head, true);
 	}
 
 	if (is_tdp_mmu_enabled(kvm))
 		write_protected |=
-			kvm_tdp_mmu_write_protect_gfn(kvm, slot, gfn);
+			kvm_tdp_mmu_write_protect_gfn(kvm, slot, gfn, min_level);
 
 	return write_protected;
 }
@@ -1288,7 +1289,7 @@ static bool rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
 	struct kvm_memory_slot *slot;
 
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-	return kvm_mmu_slot_gfn_write_protect(vcpu->kvm, slot, gfn);
+	return kvm_mmu_slot_gfn_write_protect(vcpu->kvm, slot, gfn, PG_LEVEL_4K);
 }
 
 static bool kvm_zap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 1f6f98c76bdf..4c7c42bb8cf8 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -104,7 +104,8 @@ bool mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 void kvm_mmu_gfn_disallow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_mmu_gfn_allow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
-				    struct kvm_memory_slot *slot, u64 gfn);
+				    struct kvm_memory_slot *slot, u64 gfn,
+				    int min_level);
 void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
 					u64 start_gfn, u64 pages);
 
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 34bb0ec69bd8..91a9f7e0fd91 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -100,7 +100,7 @@ void kvm_slot_page_track_add_page(struct kvm *kvm,
 	kvm_mmu_gfn_disallow_lpage(slot, gfn);
 
 	if (mode == KVM_PAGE_TRACK_WRITE)
-		if (kvm_mmu_slot_gfn_write_protect(kvm, slot, gfn))
+		if (kvm_mmu_slot_gfn_write_protect(kvm, slot, gfn, PG_LEVEL_4K))
 			kvm_flush_remote_tlbs(kvm);
 }
 EXPORT_SYMBOL_GPL(kvm_slot_page_track_add_page);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 018d82e73e31..6cf0284e2e6a 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1338,15 +1338,22 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
  * Returns true if an SPTE was set and a TLB flush is needed.
  */
 static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
-			      gfn_t gfn)
+			      gfn_t gfn, int min_level)
 {
 	struct tdp_iter iter;
 	u64 new_spte;
 	bool spte_set = false;
 
+	BUG_ON(min_level > KVM_MAX_HUGEPAGE_LEVEL);
+
 	rcu_read_lock();
 
-	tdp_root_for_each_leaf_pte(iter, root, gfn, gfn + 1) {
+	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
+				   min_level, gfn, gfn + 1) {
+		if (!is_shadow_present_pte(iter.old_spte) ||
+		    !is_last_spte(iter.old_spte, iter.level))
+			continue;
+
 		if (!is_writable_pte(iter.old_spte))
 			break;
 
@@ -1368,7 +1375,8 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
  * Returns true if an SPTE was set and a TLB flush is needed.
  */
 bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
-				   struct kvm_memory_slot *slot, gfn_t gfn)
+				   struct kvm_memory_slot *slot, gfn_t gfn,
+				   int min_level)
 {
 	struct kvm_mmu_page *root;
 	int root_as_id;
@@ -1380,7 +1388,7 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 		if (root_as_id != slot->as_id)
 			continue;
 
-		spte_set |= write_protect_gfn(kvm, root, gfn);
+		spte_set |= write_protect_gfn(kvm, root, gfn, min_level);
 	}
 	return spte_set;
 }
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 31096ece9b14..cea787469016 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -59,7 +59,8 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				       struct kvm_memory_slot *slot);
 
 bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
-				   struct kvm_memory_slot *slot, gfn_t gfn);
+				   struct kvm_memory_slot *slot, gfn_t gfn,
+				   int min_level);
 
 int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 			 int *root_level);
-- 
2.23.0

