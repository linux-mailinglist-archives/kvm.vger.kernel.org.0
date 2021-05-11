Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 418EA37ACEB
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 19:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbhEKRRz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 13:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbhEKRRo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 13:17:44 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69FB0C061349
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 10:16:33 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id w4-20020aa79a040000b029028ed6d50d44so13181471pfj.20
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 10:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=TWWCfHtJ7dAMyS3acFddqhtxUhh+dvvTZddd2oq7ipY=;
        b=rTTAfkmvOv9y8Zg2CokZ0tnQalra/fAWBvyAQdf/UZFxn0yVOMbclF8uWJ/Cg0Ik6h
         ImOQMK2+QNShN4XVSugfliJc6NrKQKVyJNXuqDh0IH4fF3uCIEn7PjioROVkH1KHACCM
         c1a1CE+VWrkPYaJa8azgxz9+TBraum7kC7A1UCZbEAl23RlufXWObewGq7Z7wH8LniIT
         UD2Vy3wmQPCuKAG3yutVNUiOAJ0/zwZvXEoGfI/qzYgq3SCo41wEoyA4g3GgR4wGFFh9
         x4YCjPPZhKUwObl1qfgdv9NxG3YdpmUWOwU47ajWYk2EvVNxUvv1PHT8JEdcgh93gzQZ
         LFtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=TWWCfHtJ7dAMyS3acFddqhtxUhh+dvvTZddd2oq7ipY=;
        b=mnlt/8T94yaWZPMfga0v+O9suW1KA5p6eS9nEJdTFUYrGfNTHH64RZwD5yZosquNc1
         30nN/PZNXY/6AD4aNYTNV6ZY/dlRt4ZhlEfdIICD3xjJFlA+GVihkXK7HbTfNrDEDD5F
         wINBA4/XBSktNQYTfmaK6jaa4o5dm+dwM3oh4l+bfWVxmK3aabjq7mr5KGu3tL3GXVzV
         U1rCdwxMjCD4+ks7ma22vKhxEgPEf4EHd6QH7IF4ofItMSf4pzgpjMTxO36spuFuLMdZ
         q1EPSS+qNYJqDbjEdFzbxXtjDYmZ/Cy8bs8n9TEN1AAHP4YIh5qJ5h/z8VzfiUXZe2OG
         JcRQ==
X-Gm-Message-State: AOAM532LDNl18KkZy8vuRS7zW6MDdyVABqN7fEVL8A30qNdYgtwYJbk3
        F8ei0tGgeLYGueM2izf6yEnpU3X9BpNw
X-Google-Smtp-Source: ABdhPJxY6f2bkMBlWqTSNAB/QIrzqzDMTxJbmKRiRmgG/RLWZooxFyOTmEfAdP8wzCOOG+XgwjFtrBpn/CAr
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:e050:3342:9ea6:6859])
 (user=bgardon job=sendgmr) by 2002:a62:8744:0:b029:2cb:6fd1:b809 with SMTP id
 i65-20020a6287440000b02902cb6fd1b809mr2635500pfe.80.1620753393021; Tue, 11
 May 2021 10:16:33 -0700 (PDT)
Date:   Tue, 11 May 2021 10:16:10 -0700
In-Reply-To: <20210511171610.170160-1-bgardon@google.com>
Message-Id: <20210511171610.170160-8-bgardon@google.com>
Mime-Version: 1.0
References: <20210511171610.170160-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH v4 7/7] KVM: x86/mmu: Lazily allocate memslot rmaps
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the TDP MMU is in use, wait to allocate the rmaps until the shadow
MMU is actually used. (i.e. a nested VM is launched.) This saves memory
equal to 0.2% of guest memory in cases where the TDP MMU is used and
there are no nested guests involved.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/mmu/mmu.c          | 53 +++++++++++++++++++++++----------
 arch/x86/kvm/mmu/tdp_mmu.c      |  6 ++--
 arch/x86/kvm/mmu/tdp_mmu.h      |  4 +--
 arch/x86/kvm/x86.c              | 45 +++++++++++++++++++++++++++-
 5 files changed, 89 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index fc75ed49bfee..7b65f82ade1c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1868,4 +1868,6 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
 
 int kvm_cpu_dirty_log_size(void);
 
+int alloc_all_memslots_rmaps(struct kvm *kvm);
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b0bdb924d519..183afccd2944 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1190,7 +1190,8 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 		kvm_tdp_mmu_clear_dirty_pt_masked(kvm, slot,
 				slot->base_gfn + gfn_offset, mask, true);
 
-	if (!kvm->arch.memslots_have_rmaps)
+	/* Read memslots_have_rmaps before the rmaps themselves */
+	if (!smp_load_acquire(&kvm->arch.memslots_have_rmaps))
 		return;
 
 	while (mask) {
@@ -1223,7 +1224,8 @@ static void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 		kvm_tdp_mmu_clear_dirty_pt_masked(kvm, slot,
 				slot->base_gfn + gfn_offset, mask, false);
 
-	if (!kvm->arch.memslots_have_rmaps)
+	/* Read memslots_have_rmaps before the rmaps themselves */
+	if (!smp_load_acquire(&kvm->arch.memslots_have_rmaps))
 		return;
 
 	while (mask) {
@@ -1268,7 +1270,8 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 	int i;
 	bool write_protected = false;
 
-	if (kvm->arch.memslots_have_rmaps) {
+	/* Read memslots_have_rmaps before the rmaps themselves */
+	if (smp_load_acquire(&kvm->arch.memslots_have_rmaps)) {
 		for (i = PG_LEVEL_4K; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
 			rmap_head = __gfn_to_rmap(gfn, i, slot);
 			write_protected |= __rmap_write_protect(kvm, rmap_head,
@@ -1446,7 +1449,8 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool flush = false;
 
-	if (kvm->arch.memslots_have_rmaps)
+	/* Read memslots_have_rmaps before the rmaps themselves */
+	if (smp_load_acquire(&kvm->arch.memslots_have_rmaps))
 		flush = kvm_handle_gfn_range(kvm, range, kvm_unmap_rmapp);
 
 	if (is_tdp_mmu_enabled(kvm))
@@ -1459,7 +1463,8 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool flush = false;
 
-	if (kvm->arch.memslots_have_rmaps)
+	/* Read memslots_have_rmaps before the rmaps themselves */
+	if (smp_load_acquire(&kvm->arch.memslots_have_rmaps))
 		flush = kvm_handle_gfn_range(kvm, range, kvm_set_pte_rmapp);
 
 	if (is_tdp_mmu_enabled(kvm))
@@ -1515,7 +1520,8 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool young = false;
 
-	if (kvm->arch.memslots_have_rmaps)
+	/* Read memslots_have_rmaps before the rmaps themselves */
+	if (smp_load_acquire(&kvm->arch.memslots_have_rmaps))
 		young = kvm_handle_gfn_range(kvm, range, kvm_age_rmapp);
 
 	if (is_tdp_mmu_enabled(kvm))
@@ -1528,7 +1534,8 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool young = false;
 
-	if (kvm->arch.memslots_have_rmaps)
+	/* Read memslots_have_rmaps before the rmaps themselves */
+	if (smp_load_acquire(&kvm->arch.memslots_have_rmaps))
 		young = kvm_handle_gfn_range(kvm, range, kvm_test_age_rmapp);
 
 	if (is_tdp_mmu_enabled(kvm))
@@ -3295,6 +3302,10 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		}
 	}
 
+	r = alloc_all_memslots_rmaps(vcpu->kvm);
+	if (r)
+		return r;
+
 	write_lock(&vcpu->kvm->mmu_lock);
 	r = make_mmu_pages_available(vcpu);
 	if (r < 0)
@@ -5455,7 +5466,8 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	 */
 	kvm_reload_remote_mmus(kvm);
 
-	if (kvm->arch.memslots_have_rmaps)
+	/* Read memslots_have_rmaps before the rmaps themselves */
+	if (smp_load_acquire(&kvm->arch.memslots_have_rmaps))
 		kvm_zap_obsolete_pages(kvm);
 
 	write_unlock(&kvm->mmu_lock);
@@ -5483,9 +5495,13 @@ void kvm_mmu_init_vm(struct kvm *kvm)
 {
 	struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
 
-	kvm_mmu_init_tdp_mmu(kvm);
-
-	kvm->arch.memslots_have_rmaps = true;
+	if (!kvm_mmu_init_tdp_mmu(kvm))
+		/*
+		 * No smp_load/store wrappers needed here as we are in
+		 * VM init and there cannot be any memslots / other threads
+		 * accessing this struct kvm yet.
+		 */
+		kvm->arch.memslots_have_rmaps = true;
 
 	node->track_write = kvm_mmu_pte_write;
 	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
@@ -5508,7 +5524,8 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 	int i;
 	bool flush = false;
 
-	if (kvm->arch.memslots_have_rmaps) {
+	/* Read memslots_have_rmaps before the rmaps themselves */
+	if (smp_load_acquire(&kvm->arch.memslots_have_rmaps)) {
 		write_lock(&kvm->mmu_lock);
 		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
 			slots = __kvm_memslots(kvm, i);
@@ -5559,7 +5576,8 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 {
 	bool flush = false;
 
-	if (kvm->arch.memslots_have_rmaps) {
+	/* Read memslots_have_rmaps before the rmaps themselves */
+	if (smp_load_acquire(&kvm->arch.memslots_have_rmaps)) {
 		write_lock(&kvm->mmu_lock);
 		flush = slot_handle_level(kvm, memslot, slot_rmap_write_protect,
 					  start_level, KVM_MAX_HUGEPAGE_LEVEL,
@@ -5635,7 +5653,8 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 	struct kvm_memory_slot *slot = (struct kvm_memory_slot *)memslot;
 	bool flush;
 
-	if (kvm->arch.memslots_have_rmaps) {
+	/* Read memslots_have_rmaps before the rmaps themselves */
+	if (smp_load_acquire(&kvm->arch.memslots_have_rmaps)) {
 		write_lock(&kvm->mmu_lock);
 		flush = slot_handle_leaf(kvm, slot, kvm_mmu_zap_collapsible_spte, true);
 		if (flush)
@@ -5672,7 +5691,8 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 {
 	bool flush = false;
 
-	if (kvm->arch.memslots_have_rmaps) {
+	/* Read memslots_have_rmaps before the rmaps themselves */
+	if (smp_load_acquire(&kvm->arch.memslots_have_rmaps)) {
 		write_lock(&kvm->mmu_lock);
 		flush = slot_handle_leaf(kvm, memslot, __rmap_clear_dirty,
 					 false);
@@ -5705,7 +5725,8 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 	if (is_tdp_mmu_enabled(kvm))
 		kvm_tdp_mmu_zap_all(kvm);
 
-	if (!kvm->arch.memslots_have_rmaps) {
+	/* Read memslots_have_rmaps before the rmaps themselves */
+	if (!smp_load_acquire(&kvm->arch.memslots_have_rmaps)) {
 		write_unlock(&kvm->mmu_lock);
 		return;
 	}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 95eeb5ac6a8a..ea00c9502ba1 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -14,10 +14,10 @@ static bool __read_mostly tdp_mmu_enabled = false;
 module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0644);
 
 /* Initializes the TDP MMU for the VM, if enabled. */
-void kvm_mmu_init_tdp_mmu(struct kvm *kvm)
+bool kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 {
 	if (!tdp_enabled || !READ_ONCE(tdp_mmu_enabled))
-		return;
+		return false;
 
 	/* This should not be changed for the lifetime of the VM. */
 	kvm->arch.tdp_mmu_enabled = true;
@@ -25,6 +25,8 @@ void kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
 	spin_lock_init(&kvm->arch.tdp_mmu_pages_lock);
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_pages);
+
+	return true;
 }
 
 static __always_inline void kvm_lockdep_assert_mmu_lock_held(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 5fdf63090451..b046ab5137a1 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -80,12 +80,12 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 			 int *root_level);
 
 #ifdef CONFIG_X86_64
-void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
+bool kvm_mmu_init_tdp_mmu(struct kvm *kvm);
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
 static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return kvm->arch.tdp_mmu_enabled; }
 static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return sp->tdp_mmu_page; }
 #else
-static inline void kvm_mmu_init_tdp_mmu(struct kvm *kvm) {}
+static inline bool kvm_mmu_init_tdp_mmu(struct kvm *kvm) { return false; }
 static inline void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm) {}
 static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return false; }
 static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return false; }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 03b6bcff2a53..fdc1b2759771 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10920,6 +10920,8 @@ static int memslot_rmap_alloc(struct kvm_memory_slot *slot,
 		int lpages;
 		int level = i + 1;
 
+		WARN_ON(slot->arch.rmap[i]);
+
 		lpages = gfn_to_index(slot->base_gfn + npages - 1,
 				      slot->base_gfn, level) + 1;
 
@@ -10935,6 +10937,46 @@ static int memslot_rmap_alloc(struct kvm_memory_slot *slot,
 	return 0;
 }
 
+int alloc_all_memslots_rmaps(struct kvm *kvm)
+{
+	struct kvm_memslots *slots;
+	struct kvm_memory_slot *slot;
+	int r = 0;
+	int i;
+
+	/*
+	 * Check memslots_have_rmaps early before acquiring the
+	 * slots_arch_lock below.
+	 */
+	if (smp_load_acquire(&kvm->arch.memslots_have_rmaps))
+		return 0;
+
+	mutex_lock(&kvm->slots_arch_lock);
+
+	/*
+	 * Read memslots_have_rmaps again, under the slots arch lock,
+	 * before allocating the rmaps
+	 */
+	if (smp_load_acquire(&kvm->arch.memslots_have_rmaps))
+		return 0;
+
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		slots = __kvm_memslots(kvm, i);
+		kvm_for_each_memslot(slot, slots) {
+			r = memslot_rmap_alloc(slot, slot->npages);
+			if (r) {
+				mutex_unlock(&kvm->slots_arch_lock);
+				return r;
+			}
+		}
+	}
+
+	/* Write rmap pointers before memslots_have_rmaps */
+	smp_store_release(&kvm->arch.memslots_have_rmaps, true);
+	mutex_unlock(&kvm->slots_arch_lock);
+	return 0;
+}
+
 static int kvm_alloc_memslot_metadata(struct kvm *kvm,
 				      struct kvm_memory_slot *slot,
 				      unsigned long npages)
@@ -10949,7 +10991,8 @@ static int kvm_alloc_memslot_metadata(struct kvm *kvm,
 	 */
 	memset(&slot->arch, 0, sizeof(slot->arch));
 
-	if (kvm->arch.memslots_have_rmaps) {
+	/* Read memslots_have_rmaps before allocating the rmaps */
+	if (smp_load_acquire(&kvm->arch.memslots_have_rmaps)) {
 		r = memslot_rmap_alloc(slot, npages);
 		if (r)
 			return r;
-- 
2.31.1.607.g51e8a6a459-goog

