Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B6F387E7B
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 19:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351179AbhERRfu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 13:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351180AbhERRfs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 13:35:48 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D76C061573
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 10:34:29 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id t19-20020a170902d293b02900f0c90dc011so4063557plc.21
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 10:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=d6OxCNrxfeQwEZOuDEC39WPTJNnJyBLd23f380XRAVY=;
        b=RtoAhn803nKovIcjqxLqb79ei6jnW/SHmHEz6m9VBvHEnpWAfyH5AVNxSCJltDwAXQ
         mwDZ0C8DxsmFLCThjdJ+coQNocB7vLPBA4yA/SsFOArxteLHvKPewdpbgYhmC20OJiYm
         KWIJNfUjIp6e4czt9DU0FwyK/JW/JlyuxAztKypr5wlX7XlvnpwDay4MsjO2tMo1Pnu9
         7+mRcFPcQbjkpLnS3SxdGdZrIQS24mrKYuWTtdlLck42M1rS802u8TWWx3jk0SXb7Vyt
         IZ6hTg0Ldb7tTcy3KbJ142BpnkpW9KXPlNQ8HUdUM7kHQis0CJrrsuZoMWNenb4vk7QC
         qDqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=d6OxCNrxfeQwEZOuDEC39WPTJNnJyBLd23f380XRAVY=;
        b=bglMhNR4/TeG2icrmERvfrxNBRbsamFaaOMQe9/apSiKLxCQHLFsbxnK+s+Ez2TGPs
         UEfal5aj6hlnEpcdvYIzSG6T/oVP3EuJIlgxSXVgyZs5+79J56xKbu/mLiPUIDlDnJS0
         VP8sdWwHOEFmk4tyFH5xsXYpSY/WdS4ifd1XzJYQuga601XSPst/m/kaA+NzwclsL1YY
         BrNZWYrr1nxxUIoz+CTm8CFjpBjtrD4V8WC8rrg1wKgqmr0jMOX5PrC64ZChH3MNfU0r
         XCvbDAA4IzTQsDhnxo42epthB0wnl2YCXkwNA7lr0NX+cgMq1VP2UWwQGgw1ZTQIWEqG
         6OuA==
X-Gm-Message-State: AOAM530+0WZpT5JPt/2CNs4uTmFDK2uP3tEw0qi3PyDUkfgZPm26iuoD
        4WyMj270tbAD03j0p5qy8Vo6fIwTPkP0
X-Google-Smtp-Source: ABdhPJyWo3R76Fa8ZV64A8jqJmBWilVrF8XHEKWDc/351gvlFDDuCgqQnleefv3iKOZUPFq5owSeGR7ayYYN
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:2715:2de:868e:9db7])
 (user=bgardon job=sendgmr) by 2002:a17:90a:9202:: with SMTP id
 m2mr6546028pjo.180.1621359269297; Tue, 18 May 2021 10:34:29 -0700 (PDT)
Date:   Tue, 18 May 2021 10:34:13 -0700
In-Reply-To: <20210518173414.450044-1-bgardon@google.com>
Message-Id: <20210518173414.450044-7-bgardon@google.com>
Mime-Version: 1.0
References: <20210518173414.450044-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH v5 6/7] KVM: x86/mmu: Skip rmap operations if rmaps not allocated
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
 arch/x86/kvm/mmu.h     |   5 ++
 arch/x86/kvm/mmu/mmu.c | 113 ++++++++++++++++++++++++-----------------
 arch/x86/kvm/x86.c     |   2 +-
 3 files changed, 72 insertions(+), 48 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 88d0ed5225a4..af09c47b1aa2 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -232,4 +232,9 @@ int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
 int kvm_mmu_post_init_vm(struct kvm *kvm);
 void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
 
+static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
+{
+	return kvm->arch.memslots_have_rmaps;
+}
+
 #endif
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f059f2e8c6fe..1e0daabc83ca 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1189,6 +1189,10 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 	if (is_tdp_mmu_enabled(kvm))
 		kvm_tdp_mmu_clear_dirty_pt_masked(kvm, slot,
 				slot->base_gfn + gfn_offset, mask, true);
+
+	if (!kvm_memslots_have_rmaps(kvm))
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
+	if (!kvm_memslots_have_rmaps(kvm))
+		return;
+
 	while (mask) {
 		rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
 					  PG_LEVEL_4K, slot);
@@ -1260,9 +1268,11 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 	int i;
 	bool write_protected = false;
 
-	for (i = PG_LEVEL_4K; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
-		rmap_head = __gfn_to_rmap(gfn, i, slot);
-		write_protected |= __rmap_write_protect(kvm, rmap_head, true);
+	if (kvm_memslots_have_rmaps(kvm)) {
+		for (i = PG_LEVEL_4K; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
+			rmap_head = __gfn_to_rmap(gfn, i, slot);
+			write_protected |= __rmap_write_protect(kvm, rmap_head, true);
+		}
 	}
 
 	if (is_tdp_mmu_enabled(kvm))
@@ -1433,9 +1443,10 @@ static __always_inline bool kvm_handle_gfn_range(struct kvm *kvm,
 
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	bool flush;
+	bool flush = false;
 
-	flush = kvm_handle_gfn_range(kvm, range, kvm_unmap_rmapp);
+	if (kvm_memslots_have_rmaps(kvm))
+		flush = kvm_handle_gfn_range(kvm, range, kvm_unmap_rmapp);
 
 	if (is_tdp_mmu_enabled(kvm))
 		flush |= kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
@@ -1445,9 +1456,10 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 
 bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	bool flush;
+	bool flush = false;
 
-	flush = kvm_handle_gfn_range(kvm, range, kvm_set_pte_rmapp);
+	if (kvm_memslots_have_rmaps(kvm))
+		flush = kvm_handle_gfn_range(kvm, range, kvm_set_pte_rmapp);
 
 	if (is_tdp_mmu_enabled(kvm))
 		flush |= kvm_tdp_mmu_set_spte_gfn(kvm, range);
@@ -1500,9 +1512,10 @@ static void rmap_recycle(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	bool young;
+	bool young = false;
 
-	young = kvm_handle_gfn_range(kvm, range, kvm_age_rmapp);
+	if (kvm_memslots_have_rmaps(kvm))
+		young = kvm_handle_gfn_range(kvm, range, kvm_age_rmapp);
 
 	if (is_tdp_mmu_enabled(kvm))
 		young |= kvm_tdp_mmu_age_gfn_range(kvm, range);
@@ -1512,9 +1525,10 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 
 bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	bool young;
+	bool young = false;
 
-	young = kvm_handle_gfn_range(kvm, range, kvm_test_age_rmapp);
+	if (kvm_memslots_have_rmaps(kvm))
+		young = kvm_handle_gfn_range(kvm, range, kvm_test_age_rmapp);
 
 	if (is_tdp_mmu_enabled(kvm))
 		young |= kvm_tdp_mmu_test_age_gfn(kvm, range);
@@ -5492,29 +5506,29 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
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
+	if (kvm_memslots_have_rmaps(kvm)) {
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
 
@@ -5541,12 +5555,15 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 				      struct kvm_memory_slot *memslot,
 				      int start_level)
 {
-	bool flush;
+	bool flush = false;
 
-	write_lock(&kvm->mmu_lock);
-	flush = slot_handle_level(kvm, memslot, slot_rmap_write_protect,
-				start_level, KVM_MAX_HUGEPAGE_LEVEL, false);
-	write_unlock(&kvm->mmu_lock);
+	if (kvm_memslots_have_rmaps(kvm)) {
+		write_lock(&kvm->mmu_lock);
+		flush = slot_handle_level(kvm, memslot, slot_rmap_write_protect,
+					  start_level, KVM_MAX_HUGEPAGE_LEVEL,
+					  false);
+		write_unlock(&kvm->mmu_lock);
+	}
 
 	if (is_tdp_mmu_enabled(kvm)) {
 		read_lock(&kvm->mmu_lock);
@@ -5616,16 +5633,15 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 	struct kvm_memory_slot *slot = (struct kvm_memory_slot *)memslot;
 	bool flush;
 
-	write_lock(&kvm->mmu_lock);
-	flush = slot_handle_leaf(kvm, slot, kvm_mmu_zap_collapsible_spte, true);
-
-	if (flush)
-		kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
-	write_unlock(&kvm->mmu_lock);
+	if (kvm_memslots_have_rmaps(kvm)) {
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
@@ -5652,11 +5668,14 @@ void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
 void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 				   struct kvm_memory_slot *memslot)
 {
-	bool flush;
+	bool flush = false;
 
-	write_lock(&kvm->mmu_lock);
-	flush = slot_handle_leaf(kvm, memslot, __rmap_clear_dirty, false);
-	write_unlock(&kvm->mmu_lock);
+	if (kvm_memslots_have_rmaps(kvm)) {
+		write_lock(&kvm->mmu_lock);
+		flush = slot_handle_leaf(kvm, memslot, __rmap_clear_dirty,
+					 false);
+		write_unlock(&kvm->mmu_lock);
+	}
 
 	if (is_tdp_mmu_enabled(kvm)) {
 		read_lock(&kvm->mmu_lock);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ae8e3179d483..7cbaa92687f7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10954,7 +10954,7 @@ static int kvm_alloc_memslot_metadata(struct kvm *kvm,
 	 */
 	memset(&slot->arch, 0, sizeof(slot->arch));
 
-	if (kvm->arch.memslots_have_rmaps) {
+	if (kvm_memslots_have_rmaps(kvm)) {
 		r = memslot_rmap_alloc(slot, npages);
 		if (r)
 			return r;
-- 
2.31.1.751.gd2f1c929bd-goog

