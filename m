Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA4737ACEA
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 19:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbhEKRRw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 13:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231917AbhEKRRm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 13:17:42 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E78C061763
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 10:16:31 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id o186-20020a2528c30000b02904f824478356so24303351ybo.4
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 10:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3SOM6IY5GwQokx4OjnUyYojfbGYTl1YKZ6S3GRlXvGY=;
        b=BR77rWkAyQd3DrcASp/9VOrqotwlKor+XuPXnPhAXYjZvQo0xRNneYyXox57+aWk4j
         62Wv1QmgQ75YxKVTwEkgdVp7hmF/wJZlDDMJNzQzEqdEWHuUzzWEcl2X0h8XnlthXfw7
         E9aN6AV12PK9BPlrSyyV/Gcr3+N1dND9MrElkA0IyppSQdRG+eI/y5xWvlMK/V9sojcg
         fy0CfO1/qpZ9sSA+TOSo6qaOe6ZiqfbFJbsbZqCiM/NC816ug22Qyqd0PJ7CMvCf7Ut2
         rrHO9HopQNJYfUSWhgdCsUKHL7Cymq9qti9+oSW4XeALDRVzXSaabp3ukk+Gy/57yWU2
         skkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3SOM6IY5GwQokx4OjnUyYojfbGYTl1YKZ6S3GRlXvGY=;
        b=KSXnhJOPMy6+8e1+IS9bKU94sYlzhKnekLPNp4cPcKENzJbYgFQVAfBWT8Jj6dZGyH
         dsJEAroujZMk5NhiQLnV9IBhvfNKuEbRJG7iarkm5b717KJMSWJJb9EDL0ZAkWhVw+yL
         fnrGb6eSal5ub9K4K+OER7CoNIJOMi40yv4xUAaXyQZnuUQjgixo3SPvNrypi5i6ltzg
         Mwyr5BtOM/fyitYovkfplcG5sfzha/InoJrOdLBD3twvPa3Ipf4A8ltDMg1HpDLXqcwd
         65ybZZfb+gF7zZsYwBjVt5iW7rUkIOQkjeYizD2ToCzmy03KVXTD0Cb/DKAfbuS+cWtI
         /bsQ==
X-Gm-Message-State: AOAM532gDDGiEfAEOhOct5vDEHSZfWav70hBgEVLDeuZZEf0D9jf/+DE
        4vgUhxmvSXjWBsuCqYzsNWVZSYyU8G8j
X-Google-Smtp-Source: ABdhPJyWCT2Z3/v9A8saqn3GC2DLQROIZWyzs2bKDMoDY1L2O2esjxaDk+EWjHki6ELVT/iOMHnoDSxaG3Ct
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:e050:3342:9ea6:6859])
 (user=bgardon job=sendgmr) by 2002:a25:830f:: with SMTP id
 s15mr44494156ybk.50.1620753390597; Tue, 11 May 2021 10:16:30 -0700 (PDT)
Date:   Tue, 11 May 2021 10:16:09 -0700
In-Reply-To: <20210511171610.170160-1-bgardon@google.com>
Message-Id: <20210511171610.170160-7-bgardon@google.com>
Mime-Version: 1.0
References: <20210511171610.170160-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH v4 6/7] KVM: x86/mmu: Skip rmap operations if rmaps not allocated
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

If only the TDP MMU is being used to manage the memory mappings for a VM,
then many rmap operations can be skipped as they are guaranteed to be
no-ops. This saves some time which would be spent on the rmap operation.
It also avoids acquiring the MMU lock in write mode for many operations.

This makes it safe to run the VM without rmaps allocated, when only
using the TDP MMU and sets the stage for waiting to allocate the rmaps
until they're needed.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 128 +++++++++++++++++++++++++----------------
 1 file changed, 77 insertions(+), 51 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f059f2e8c6fe..b0bdb924d519 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1189,6 +1189,10 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 	if (is_tdp_mmu_enabled(kvm))
 		kvm_tdp_mmu_clear_dirty_pt_masked(kvm, slot,
 				slot->base_gfn + gfn_offset, mask, true);
+
+	if (!kvm->arch.memslots_have_rmaps)
+		return;
+
 	while (mask) {
 		rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
 					  PG_LEVEL_4K, slot);
@@ -1218,6 +1222,10 @@ static void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 	if (is_tdp_mmu_enabled(kvm))
 		kvm_tdp_mmu_clear_dirty_pt_masked(kvm, slot,
 				slot->base_gfn + gfn_offset, mask, false);
+
+	if (!kvm->arch.memslots_have_rmaps)
+		return;
+
 	while (mask) {
 		rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
 					  PG_LEVEL_4K, slot);
@@ -1260,9 +1268,12 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 	int i;
 	bool write_protected = false;
 
-	for (i = PG_LEVEL_4K; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
-		rmap_head = __gfn_to_rmap(gfn, i, slot);
-		write_protected |= __rmap_write_protect(kvm, rmap_head, true);
+	if (kvm->arch.memslots_have_rmaps) {
+		for (i = PG_LEVEL_4K; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
+			rmap_head = __gfn_to_rmap(gfn, i, slot);
+			write_protected |= __rmap_write_protect(kvm, rmap_head,
+								true);
+		}
 	}
 
 	if (is_tdp_mmu_enabled(kvm))
@@ -1433,9 +1444,10 @@ static __always_inline bool kvm_handle_gfn_range(struct kvm *kvm,
 
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	bool flush;
+	bool flush = false;
 
-	flush = kvm_handle_gfn_range(kvm, range, kvm_unmap_rmapp);
+	if (kvm->arch.memslots_have_rmaps)
+		flush = kvm_handle_gfn_range(kvm, range, kvm_unmap_rmapp);
 
 	if (is_tdp_mmu_enabled(kvm))
 		flush |= kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
@@ -1445,9 +1457,10 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 
 bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	bool flush;
+	bool flush = false;
 
-	flush = kvm_handle_gfn_range(kvm, range, kvm_set_pte_rmapp);
+	if (kvm->arch.memslots_have_rmaps)
+		flush = kvm_handle_gfn_range(kvm, range, kvm_set_pte_rmapp);
 
 	if (is_tdp_mmu_enabled(kvm))
 		flush |= kvm_tdp_mmu_set_spte_gfn(kvm, range);
@@ -1500,9 +1513,10 @@ static void rmap_recycle(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	bool young;
+	bool young = false;
 
-	young = kvm_handle_gfn_range(kvm, range, kvm_age_rmapp);
+	if (kvm->arch.memslots_have_rmaps)
+		young = kvm_handle_gfn_range(kvm, range, kvm_age_rmapp);
 
 	if (is_tdp_mmu_enabled(kvm))
 		young |= kvm_tdp_mmu_age_gfn_range(kvm, range);
@@ -1512,9 +1526,10 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 
 bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	bool young;
+	bool young = false;
 
-	young = kvm_handle_gfn_range(kvm, range, kvm_test_age_rmapp);
+	if (kvm->arch.memslots_have_rmaps)
+		young = kvm_handle_gfn_range(kvm, range, kvm_test_age_rmapp);
 
 	if (is_tdp_mmu_enabled(kvm))
 		young |= kvm_tdp_mmu_test_age_gfn(kvm, range);
@@ -5440,7 +5455,8 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	 */
 	kvm_reload_remote_mmus(kvm);
 
-	kvm_zap_obsolete_pages(kvm);
+	if (kvm->arch.memslots_have_rmaps)
+		kvm_zap_obsolete_pages(kvm);
 
 	write_unlock(&kvm->mmu_lock);
 
@@ -5492,29 +5508,29 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 	int i;
 	bool flush = false;
 
-	write_lock(&kvm->mmu_lock);
-	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
-		slots = __kvm_memslots(kvm, i);
-		kvm_for_each_memslot(memslot, slots) {
-			gfn_t start, end;
-
-			start = max(gfn_start, memslot->base_gfn);
-			end = min(gfn_end, memslot->base_gfn + memslot->npages);
-			if (start >= end)
-				continue;
+	if (kvm->arch.memslots_have_rmaps) {
+		write_lock(&kvm->mmu_lock);
+		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+			slots = __kvm_memslots(kvm, i);
+			kvm_for_each_memslot(memslot, slots) {
+				gfn_t start, end;
+
+				start = max(gfn_start, memslot->base_gfn);
+				end = min(gfn_end, memslot->base_gfn + memslot->npages);
+				if (start >= end)
+					continue;
 
-			flush = slot_handle_level_range(kvm, memslot, kvm_zap_rmapp,
-							PG_LEVEL_4K,
-							KVM_MAX_HUGEPAGE_LEVEL,
-							start, end - 1, true, flush);
+				flush = slot_handle_level_range(kvm, memslot,
+						kvm_zap_rmapp, PG_LEVEL_4K,
+						KVM_MAX_HUGEPAGE_LEVEL, start,
+						end - 1, true, flush);
+			}
 		}
+		if (flush)
+			kvm_flush_remote_tlbs_with_address(kvm, gfn_start, gfn_end);
+		write_unlock(&kvm->mmu_lock);
 	}
 
-	if (flush)
-		kvm_flush_remote_tlbs_with_address(kvm, gfn_start, gfn_end);
-
-	write_unlock(&kvm->mmu_lock);
-
 	if (is_tdp_mmu_enabled(kvm)) {
 		flush = false;
 
@@ -5541,12 +5557,15 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 				      struct kvm_memory_slot *memslot,
 				      int start_level)
 {
-	bool flush;
+	bool flush = false;
 
-	write_lock(&kvm->mmu_lock);
-	flush = slot_handle_level(kvm, memslot, slot_rmap_write_protect,
-				start_level, KVM_MAX_HUGEPAGE_LEVEL, false);
-	write_unlock(&kvm->mmu_lock);
+	if (kvm->arch.memslots_have_rmaps) {
+		write_lock(&kvm->mmu_lock);
+		flush = slot_handle_level(kvm, memslot, slot_rmap_write_protect,
+					  start_level, KVM_MAX_HUGEPAGE_LEVEL,
+					  false);
+		write_unlock(&kvm->mmu_lock);
+	}
 
 	if (is_tdp_mmu_enabled(kvm)) {
 		read_lock(&kvm->mmu_lock);
@@ -5616,16 +5635,15 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 	struct kvm_memory_slot *slot = (struct kvm_memory_slot *)memslot;
 	bool flush;
 
-	write_lock(&kvm->mmu_lock);
-	flush = slot_handle_leaf(kvm, slot, kvm_mmu_zap_collapsible_spte, true);
-
-	if (flush)
-		kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
-	write_unlock(&kvm->mmu_lock);
+	if (kvm->arch.memslots_have_rmaps) {
+		write_lock(&kvm->mmu_lock);
+		flush = slot_handle_leaf(kvm, slot, kvm_mmu_zap_collapsible_spte, true);
+		if (flush)
+			kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
+		write_unlock(&kvm->mmu_lock);
+	}
 
 	if (is_tdp_mmu_enabled(kvm)) {
-		flush = false;
-
 		read_lock(&kvm->mmu_lock);
 		flush = kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot, flush);
 		if (flush)
@@ -5652,11 +5670,14 @@ void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
 void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 				   struct kvm_memory_slot *memslot)
 {
-	bool flush;
+	bool flush = false;
 
-	write_lock(&kvm->mmu_lock);
-	flush = slot_handle_leaf(kvm, memslot, __rmap_clear_dirty, false);
-	write_unlock(&kvm->mmu_lock);
+	if (kvm->arch.memslots_have_rmaps) {
+		write_lock(&kvm->mmu_lock);
+		flush = slot_handle_leaf(kvm, memslot, __rmap_clear_dirty,
+					 false);
+		write_unlock(&kvm->mmu_lock);
+	}
 
 	if (is_tdp_mmu_enabled(kvm)) {
 		read_lock(&kvm->mmu_lock);
@@ -5681,6 +5702,14 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 	int ign;
 
 	write_lock(&kvm->mmu_lock);
+	if (is_tdp_mmu_enabled(kvm))
+		kvm_tdp_mmu_zap_all(kvm);
+
+	if (!kvm->arch.memslots_have_rmaps) {
+		write_unlock(&kvm->mmu_lock);
+		return;
+	}
+
 restart:
 	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link) {
 		if (WARN_ON(sp->role.invalid))
@@ -5693,9 +5722,6 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 
-	if (is_tdp_mmu_enabled(kvm))
-		kvm_tdp_mmu_zap_all(kvm);
-
 	write_unlock(&kvm->mmu_lock);
 }
 
-- 
2.31.1.607.g51e8a6a459-goog

