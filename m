Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212E7229C85
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 18:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730589AbgGVQBl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 12:01:41 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37958 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728780AbgGVQBj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jul 2020 12:01:39 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 33F84305D7F3;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.6])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 291933073698;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v1 10/34] KVM: x86: page track: allow page tracking for different EPT views
Date:   Wed, 22 Jul 2020 19:00:57 +0300
Message-Id: <20200722160121.9601-11-alazar@bitdefender.com>
In-Reply-To: <20200722160121.9601-1-alazar@bitdefender.com>
References: <20200722160121.9601-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ștefan Șicleru <ssicleru@bitdefender.com>

The introspection tool uses this to set distinct access rights on
different EPT views.

Signed-off-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h       |  2 +-
 arch/x86/include/asm/kvm_page_track.h |  4 +-
 arch/x86/kvm/kvmi.c                   |  6 ++-
 arch/x86/kvm/mmu.h                    |  9 ++--
 arch/x86/kvm/mmu/mmu.c                | 60 +++++++++++++++++----------
 arch/x86/kvm/mmu/page_track.c         | 56 +++++++++++++------------
 drivers/gpu/drm/i915/gvt/kvmgt.c      |  8 ++--
 7 files changed, 86 insertions(+), 59 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5e241863153f..2fbb26b54cf1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -860,7 +860,7 @@ struct kvm_lpage_info {
 struct kvm_arch_memory_slot {
 	struct kvm_rmap_head *rmap[KVM_NR_PAGE_SIZES];
 	struct kvm_lpage_info *lpage_info[KVM_NR_PAGE_SIZES - 1];
-	unsigned short *gfn_track[KVM_PAGE_TRACK_MAX];
+	unsigned short *gfn_track[KVM_MAX_EPT_VIEWS][KVM_PAGE_TRACK_MAX];
 };
 
 /*
diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index c10f0f65c77a..96d2ab7da4a7 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -109,10 +109,10 @@ int kvm_page_track_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 void kvm_slot_page_track_add_page(struct kvm *kvm,
 				  struct kvm_memory_slot *slot, gfn_t gfn,
-				  enum kvm_page_track_mode mode);
+				  enum kvm_page_track_mode mode, u16 view);
 void kvm_slot_page_track_remove_page(struct kvm *kvm,
 				     struct kvm_memory_slot *slot, gfn_t gfn,
-				     enum kvm_page_track_mode mode);
+				     enum kvm_page_track_mode mode, u16 view);
 bool kvm_page_track_is_active(struct kvm_vcpu *vcpu, gfn_t gfn,
 			      enum kvm_page_track_mode mode);
 
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 4e75858c03b4..7b3b64d27d18 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -1215,11 +1215,13 @@ void kvmi_arch_update_page_tracking(struct kvm *kvm,
 		if (m->access & allow_bit) {
 			if (slot_tracked) {
 				kvm_slot_page_track_remove_page(kvm, slot,
-								m->gfn, mode);
+								m->gfn, mode,
+								0);
 				clear_bit(slot->id, arch->active[mode]);
 			}
 		} else if (!slot_tracked) {
-			kvm_slot_page_track_add_page(kvm, slot, m->gfn, mode);
+			kvm_slot_page_track_add_page(kvm, slot, m->gfn, mode,
+						     0);
 			set_bit(slot->id, arch->active[mode]);
 		}
 	}
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index e2c0518af750..2692b14fb605 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -221,11 +221,14 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
 void kvm_mmu_gfn_disallow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_mmu_gfn_allow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
-				    struct kvm_memory_slot *slot, u64 gfn);
+				    struct kvm_memory_slot *slot, u64 gfn,
+				    u16 view);
 bool kvm_mmu_slot_gfn_read_protect(struct kvm *kvm,
-				   struct kvm_memory_slot *slot, u64 gfn);
+				   struct kvm_memory_slot *slot, u64 gfn,
+				   u16 view);
 bool kvm_mmu_slot_gfn_exec_protect(struct kvm *kvm,
-				   struct kvm_memory_slot *slot, u64 gfn);
+				   struct kvm_memory_slot *slot, u64 gfn,
+				   u16 view);
 int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu, gpa_t l2_gpa);
 
 int kvm_mmu_post_init_vm(struct kvm *kvm);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 70461c7ef58c..cca12982b795 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1231,9 +1231,9 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 	/* the non-leaf shadow pages are keeping readonly. */
 	if (sp->role.level > PG_LEVEL_4K) {
 		kvm_slot_page_track_add_page(kvm, slot, gfn,
-					     KVM_PAGE_TRACK_PREWRITE);
+					     KVM_PAGE_TRACK_PREWRITE, 0);
 		kvm_slot_page_track_add_page(kvm, slot, gfn,
-					     KVM_PAGE_TRACK_WRITE);
+					     KVM_PAGE_TRACK_WRITE, 0);
 		return;
 	}
 
@@ -1263,9 +1263,9 @@ static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 	slot = __gfn_to_memslot(slots, gfn);
 	if (sp->role.level > PG_LEVEL_4K) {
 		kvm_slot_page_track_remove_page(kvm, slot, gfn,
-						KVM_PAGE_TRACK_PREWRITE);
+						KVM_PAGE_TRACK_PREWRITE, 0);
 		kvm_slot_page_track_remove_page(kvm, slot, gfn,
-						KVM_PAGE_TRACK_WRITE);
+						KVM_PAGE_TRACK_WRITE, 0);
 		return;
 	}
 
@@ -1617,40 +1617,52 @@ static bool spte_exec_protect(u64 *sptep)
 
 static bool __rmap_write_protect(struct kvm *kvm,
 				 struct kvm_rmap_head *rmap_head,
-				 bool pt_protect)
+				 bool pt_protect, u16 view)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
 	bool flush = false;
+	struct kvm_mmu_page *sp;
 
-	for_each_rmap_spte(rmap_head, &iter, sptep)
-		flush |= spte_write_protect(sptep, pt_protect);
+	for_each_rmap_spte(rmap_head, &iter, sptep) {
+		sp = page_header(__pa(sptep));
+		if (view == 0 || (view > 0 && sp->view == view))
+			flush |= spte_write_protect(sptep, pt_protect);
+	}
 
 	return flush;
 }
 
 static bool __rmap_read_protect(struct kvm *kvm,
-				struct kvm_rmap_head *rmap_head)
+				struct kvm_rmap_head *rmap_head, u16 view)
 {
 	struct rmap_iterator iter;
+	struct kvm_mmu_page *sp;
 	bool flush = false;
 	u64 *sptep;
 
-	for_each_rmap_spte(rmap_head, &iter, sptep)
-		flush |= spte_read_protect(sptep);
+	for_each_rmap_spte(rmap_head, &iter, sptep) {
+		sp = page_header(__pa(sptep));
+		if (view == 0 || (view > 0 && sp->view == view))
+			flush |= spte_read_protect(sptep);
+	}
 
 	return flush;
 }
 
 static bool __rmap_exec_protect(struct kvm *kvm,
-				struct kvm_rmap_head *rmap_head)
+				struct kvm_rmap_head *rmap_head, u16 view)
 {
 	struct rmap_iterator iter;
+	struct kvm_mmu_page *sp;
 	bool flush = false;
 	u64 *sptep;
 
-	for_each_rmap_spte(rmap_head, &iter, sptep)
-		flush |= spte_exec_protect(sptep);
+	for_each_rmap_spte(rmap_head, &iter, sptep) {
+		sp = page_header(__pa(sptep));
+		if (view == 0 || (view > 0 && sp->view == view))
+			flush |= spte_exec_protect(sptep);
+	}
 
 	return flush;
 }
@@ -1745,7 +1757,7 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 	while (mask) {
 		rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
 					  PG_LEVEL_4K, slot);
-		__rmap_write_protect(kvm, rmap_head, false);
+		__rmap_write_protect(kvm, rmap_head, false, 0);
 
 		/* clear the first set bit */
 		mask &= mask - 1;
@@ -1816,7 +1828,8 @@ int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu, gpa_t l2_gpa)
 }
 
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
-				    struct kvm_memory_slot *slot, u64 gfn)
+				    struct kvm_memory_slot *slot, u64 gfn,
+				    u16 view)
 {
 	struct kvm_rmap_head *rmap_head;
 	int i;
@@ -1824,14 +1837,16 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 
 	for (i = PG_LEVEL_4K; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
 		rmap_head = __gfn_to_rmap(gfn, i, slot);
-		write_protected |= __rmap_write_protect(kvm, rmap_head, true);
+		write_protected |= __rmap_write_protect(kvm, rmap_head, true,
+							view);
 	}
 
 	return write_protected;
 }
 
 bool kvm_mmu_slot_gfn_read_protect(struct kvm *kvm,
-				   struct kvm_memory_slot *slot, u64 gfn)
+				   struct kvm_memory_slot *slot, u64 gfn,
+				   u16 view)
 {
 	struct kvm_rmap_head *rmap_head;
 	bool read_protected = false;
@@ -1839,14 +1854,15 @@ bool kvm_mmu_slot_gfn_read_protect(struct kvm *kvm,
 
 	for (i = PG_LEVEL_4K; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
 		rmap_head = __gfn_to_rmap(gfn, i, slot);
-		read_protected |= __rmap_read_protect(kvm, rmap_head);
+		read_protected |= __rmap_read_protect(kvm, rmap_head, view);
 	}
 
 	return read_protected;
 }
 
 bool kvm_mmu_slot_gfn_exec_protect(struct kvm *kvm,
-				   struct kvm_memory_slot *slot, u64 gfn)
+				   struct kvm_memory_slot *slot, u64 gfn,
+				   u16 view)
 {
 	struct kvm_rmap_head *rmap_head;
 	bool exec_protected = false;
@@ -1854,7 +1870,7 @@ bool kvm_mmu_slot_gfn_exec_protect(struct kvm *kvm,
 
 	for (i = PG_LEVEL_4K; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
 		rmap_head = __gfn_to_rmap(gfn, i, slot);
-		exec_protected |= __rmap_exec_protect(kvm, rmap_head);
+		exec_protected |= __rmap_exec_protect(kvm, rmap_head, view);
 	}
 
 	return exec_protected;
@@ -1865,7 +1881,7 @@ static bool rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
 	struct kvm_memory_slot *slot;
 
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-	return kvm_mmu_slot_gfn_write_protect(vcpu->kvm, slot, gfn);
+	return kvm_mmu_slot_gfn_write_protect(vcpu->kvm, slot, gfn, 0);
 }
 
 static bool kvm_zap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head)
@@ -6008,7 +6024,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 static bool slot_rmap_write_protect(struct kvm *kvm,
 				    struct kvm_rmap_head *rmap_head)
 {
-	return __rmap_write_protect(kvm, rmap_head, false);
+	return __rmap_write_protect(kvm, rmap_head, false, 0);
 }
 
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index b593bcf80be0..bf26b21cfeb8 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -20,12 +20,13 @@
 
 void kvm_page_track_free_memslot(struct kvm_memory_slot *slot)
 {
-	int i;
+	int i, view;
 
-	for (i = 0; i < KVM_PAGE_TRACK_MAX; i++) {
-		kvfree(slot->arch.gfn_track[i]);
-		slot->arch.gfn_track[i] = NULL;
-	}
+	for (view = 0; view < KVM_MAX_EPT_VIEWS; view++)
+		for (i = 0; i < KVM_PAGE_TRACK_MAX; i++) {
+			kvfree(slot->arch.gfn_track[view][i]);
+			slot->arch.gfn_track[view][i] = NULL;
+		}
 }
 
 int kvm_page_track_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
@@ -33,16 +34,17 @@ int kvm_page_track_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
 {
 	struct kvm_page_track_notifier_head *head;
 	struct kvm_page_track_notifier_node *n;
-	int idx;
-	int  i;
+	int view, idx, i;
 
-	for (i = 0; i < KVM_PAGE_TRACK_MAX; i++) {
-		slot->arch.gfn_track[i] =
-			kvcalloc(npages, sizeof(*slot->arch.gfn_track[i]),
-				 GFP_KERNEL_ACCOUNT);
-		if (!slot->arch.gfn_track[i])
-			goto track_free;
-	}
+	for (view = 0; view < KVM_MAX_EPT_VIEWS; view++)
+		for (i = 0; i < KVM_PAGE_TRACK_MAX; i++) {
+			slot->arch.gfn_track[view][i] =
+				kvcalloc(npages,
+					 sizeof(*slot->arch.gfn_track[view][i]),
+					 GFP_KERNEL_ACCOUNT);
+			if (!slot->arch.gfn_track[view][i])
+				goto track_free;
+		}
 
 	head = &kvm->arch.track_notifier_head;
 
@@ -71,18 +73,19 @@ static inline bool page_track_mode_is_valid(enum kvm_page_track_mode mode)
 }
 
 static void update_gfn_track(struct kvm_memory_slot *slot, gfn_t gfn,
-			     enum kvm_page_track_mode mode, short count)
+			     enum kvm_page_track_mode mode, short count,
+			     u16 view)
 {
 	int index, val;
 
 	index = gfn_to_index(gfn, slot->base_gfn, PG_LEVEL_4K);
 
-	val = slot->arch.gfn_track[mode][index];
+	val = slot->arch.gfn_track[view][mode][index];
 
 	if (WARN_ON(val + count < 0 || val + count > USHRT_MAX))
 		return;
 
-	slot->arch.gfn_track[mode][index] += count;
+	slot->arch.gfn_track[view][mode][index] += count;
 }
 
 /*
@@ -99,13 +102,13 @@ static void update_gfn_track(struct kvm_memory_slot *slot, gfn_t gfn,
  */
 void kvm_slot_page_track_add_page(struct kvm *kvm,
 				  struct kvm_memory_slot *slot, gfn_t gfn,
-				  enum kvm_page_track_mode mode)
+				  enum kvm_page_track_mode mode, u16 view)
 {
 
 	if (WARN_ON(!page_track_mode_is_valid(mode)))
 		return;
 
-	update_gfn_track(slot, gfn, mode, 1);
+	update_gfn_track(slot, gfn, mode, 1, view);
 
 	/*
 	 * new track stops large page mapping for the
@@ -114,13 +117,13 @@ void kvm_slot_page_track_add_page(struct kvm *kvm,
 	kvm_mmu_gfn_disallow_lpage(slot, gfn);
 
 	if (mode == KVM_PAGE_TRACK_PREWRITE || mode == KVM_PAGE_TRACK_WRITE) {
-		if (kvm_mmu_slot_gfn_write_protect(kvm, slot, gfn))
+		if (kvm_mmu_slot_gfn_write_protect(kvm, slot, gfn, view))
 			kvm_flush_remote_tlbs(kvm);
 	} else if (mode == KVM_PAGE_TRACK_PREREAD) {
-		if (kvm_mmu_slot_gfn_read_protect(kvm, slot, gfn))
+		if (kvm_mmu_slot_gfn_read_protect(kvm, slot, gfn, view))
 			kvm_flush_remote_tlbs(kvm);
 	} else if (mode == KVM_PAGE_TRACK_PREEXEC) {
-		if (kvm_mmu_slot_gfn_exec_protect(kvm, slot, gfn))
+		if (kvm_mmu_slot_gfn_exec_protect(kvm, slot, gfn, view))
 			kvm_flush_remote_tlbs(kvm);
 	}
 }
@@ -141,12 +144,12 @@ EXPORT_SYMBOL_GPL(kvm_slot_page_track_add_page);
  */
 void kvm_slot_page_track_remove_page(struct kvm *kvm,
 				     struct kvm_memory_slot *slot, gfn_t gfn,
-				     enum kvm_page_track_mode mode)
+				     enum kvm_page_track_mode mode, u16 view)
 {
 	if (WARN_ON(!page_track_mode_is_valid(mode)))
 		return;
 
-	update_gfn_track(slot, gfn, mode, -1);
+	update_gfn_track(slot, gfn, mode, -1, view);
 
 	/*
 	 * allow large page mapping for the tracked page
@@ -163,7 +166,7 @@ bool kvm_page_track_is_active(struct kvm_vcpu *vcpu, gfn_t gfn,
 			      enum kvm_page_track_mode mode)
 {
 	struct kvm_memory_slot *slot;
-	int index;
+	int index, view;
 
 	if (WARN_ON(!page_track_mode_is_valid(mode)))
 		return false;
@@ -173,7 +176,8 @@ bool kvm_page_track_is_active(struct kvm_vcpu *vcpu, gfn_t gfn,
 		return false;
 
 	index = gfn_to_index(gfn, slot->base_gfn, PG_LEVEL_4K);
-	return !!READ_ONCE(slot->arch.gfn_track[mode][index]);
+	view = kvm_get_ept_view(vcpu);
+	return !!READ_ONCE(slot->arch.gfn_track[view][mode][index]);
 }
 
 void kvm_page_track_cleanup(struct kvm *kvm)
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 4e370b216365..98e2e75c0d22 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1706,7 +1706,8 @@ static int kvmgt_page_track_add(unsigned long handle, u64 gfn)
 	if (kvmgt_gfn_is_write_protected(info, gfn))
 		goto out;
 
-	kvm_slot_page_track_add_page(kvm, slot, gfn, KVM_PAGE_TRACK_WRITE);
+	kvm_slot_page_track_add_page(kvm, slot, gfn,
+				     KVM_PAGE_TRACK_WRITE, 0);
 	kvmgt_protect_table_add(info, gfn);
 
 out:
@@ -1740,7 +1741,8 @@ static int kvmgt_page_track_remove(unsigned long handle, u64 gfn)
 	if (!kvmgt_gfn_is_write_protected(info, gfn))
 		goto out;
 
-	kvm_slot_page_track_remove_page(kvm, slot, gfn, KVM_PAGE_TRACK_WRITE);
+	kvm_slot_page_track_remove_page(kvm, slot, gfn,
+					KVM_PAGE_TRACK_WRITE, 0);
 	kvmgt_protect_table_del(info, gfn);
 
 out:
@@ -1775,7 +1777,7 @@ static void kvmgt_page_track_flush_slot(struct kvm *kvm,
 		gfn = slot->base_gfn + i;
 		if (kvmgt_gfn_is_write_protected(info, gfn)) {
 			kvm_slot_page_track_remove_page(kvm, slot, gfn,
-						KVM_PAGE_TRACK_WRITE);
+						KVM_PAGE_TRACK_WRITE, 0);
 			kvmgt_protect_table_del(info, gfn);
 		}
 	}
