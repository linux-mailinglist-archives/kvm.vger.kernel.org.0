Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA5A36CE9E
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 00:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238310AbhD0Wha (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 18:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237413AbhD0Wh3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 18:37:29 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4DAC061574
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 15:36:43 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id i8-20020a6548480000b02901fb8ebd5714so20394722pgs.12
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 15:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wDjj6OoSlDxcamVwTg37UVTpl6UOTvKdh3EJPSCL4Fg=;
        b=YFzhThULnb0ghZbr7kuUJlhyEFbhYULuVkGjxgUE1ufPyAvKVbUcGetANYy6Fk3EOH
         Bfyk9Mf9wRWmQu1/ukG01uBgJytGTtr3SPXoHK2SG0Fq/9UrEbBzWEOaJ6k1J4r/mq6B
         Hbm2T7ipziR6BmrUAQPvm6ZFn9FIn5P4CWR5cUf1Rm5mF0OvAmi2kiYm65C2UTdYIJ8I
         VOK8Sag7BDA2J7iOjpXDDRpnCmVYbU04BPIi/FtU9w8yL1V/MUC9nneulr9wvUC5//wW
         fU1T1GvJRdJyKjxzefNQmpYLMQZg/ZtZHTd6DOsXFjcHbZ9i0LAEmhU8+5yVu19V8suw
         E8sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wDjj6OoSlDxcamVwTg37UVTpl6UOTvKdh3EJPSCL4Fg=;
        b=fpcYC4WH3g0qy21Ek3StBSCz3vptHMOE2aAYRxqKHA9zKnI1gi4oilMRxeElfRj4td
         dN9eAG95Lwm9PZXV7UmW/o9K9AzDHnt4/DEbH/XKNaDT7svzDD6HLtI+pAllyWazUsqm
         cTY0aZCFyAICq0tRR/AD0muiPt3OQ0W+yE8nkkkSo19VLXDAx4nRmf9HpTQ2GnQd46/T
         XNuTOOVg9lgnEVfQZh6jhyhZqxRQgwNLwW6wWTCI4zFEhwO9voQ+1XFSs/wZXo43k6Fb
         w3UI1DW+L/Z3cMAfHN5tlbv51pma7DewuZ3BvSG8THven7bVNVTPGQIoCCP+REmi75c4
         kGbQ==
X-Gm-Message-State: AOAM531n+O/RyXoKYS2UG/j+QznIXFsfQskfxv8o0G/JZGuXBGVBQFsO
        ye7iJprohACeeIQgEtnFJeTcwxWeLSfR
X-Google-Smtp-Source: ABdhPJyoIIqazE2aoqCHCprwrvkKIG8hFOdYzQs8Oxz3JcFehdsJDIrwHP7nlXhdkIvQyPpjYZTrYd+XonY3
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:d0b5:c590:c6b:bd9c])
 (user=bgardon job=sendgmr) by 2002:aa7:8198:0:b029:274:8a92:51b5 with SMTP id
 g24-20020aa781980000b02902748a9251b5mr15991800pfi.5.1619563003367; Tue, 27
 Apr 2021 15:36:43 -0700 (PDT)
Date:   Tue, 27 Apr 2021 15:36:31 -0700
In-Reply-To: <20210427223635.2711774-1-bgardon@google.com>
Message-Id: <20210427223635.2711774-3-bgardon@google.com>
Mime-Version: 1.0
References: <20210427223635.2711774-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 2/6] KVM: x86/mmu: Skip rmap operations if shadow MMU inactive
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
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

If the shadow MMU is not in use, and only the TDP MMU is being used to
manage the memory mappings for a VM, then many rmap operations can be
skipped as they are guaranteed to be no-ops. This saves some time which
would be spent on the rmap operation. It also avoids acquiring the MMU
lock in write mode for many operations.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 128 +++++++++++++++++++++++++----------------
 1 file changed, 77 insertions(+), 51 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3975272321d0..e252af46f205 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1189,6 +1189,10 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 	if (is_tdp_mmu_enabled(kvm))
 		kvm_tdp_mmu_clear_dirty_pt_masked(kvm, slot,
 				slot->base_gfn + gfn_offset, mask, true);
+
+	if (!kvm->arch.shadow_mmu_active)
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
+	if (!kvm->arch.shadow_mmu_active)
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
+	if (kvm->arch.shadow_mmu_active) {
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
+	if (kvm->arch.shadow_mmu_active)
+		flush = kvm_handle_gfn_range(kvm, range, kvm_unmap_rmapp);
 
 	if (is_tdp_mmu_enabled(kvm))
 		flush |= kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
@@ -1445,9 +1457,10 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 
 bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	bool flush;
+	bool flush = false;
 
-	flush = kvm_handle_gfn_range(kvm, range, kvm_set_pte_rmapp);
+	if (kvm->arch.shadow_mmu_active)
+		flush = kvm_handle_gfn_range(kvm, range, kvm_set_pte_rmapp);
 
 	if (is_tdp_mmu_enabled(kvm))
 		flush |= kvm_tdp_mmu_set_spte_gfn(kvm, range);
@@ -1500,9 +1513,10 @@ static void rmap_recycle(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	bool young;
+	bool young = false;
 
-	young = kvm_handle_gfn_range(kvm, range, kvm_age_rmapp);
+	if (kvm->arch.shadow_mmu_active)
+		young = kvm_handle_gfn_range(kvm, range, kvm_age_rmapp);
 
 	if (is_tdp_mmu_enabled(kvm))
 		young |= kvm_tdp_mmu_age_gfn_range(kvm, range);
@@ -1512,9 +1526,10 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 
 bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	bool young;
+	bool young = false;
 
-	young = kvm_handle_gfn_range(kvm, range, kvm_test_age_rmapp);
+	if (kvm->arch.shadow_mmu_active)
+		young = kvm_handle_gfn_range(kvm, range, kvm_test_age_rmapp);
 
 	if (is_tdp_mmu_enabled(kvm))
 		young |= kvm_tdp_mmu_test_age_gfn(kvm, range);
@@ -5447,7 +5462,8 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	 */
 	kvm_reload_remote_mmus(kvm);
 
-	kvm_zap_obsolete_pages(kvm);
+	if (kvm->arch.shadow_mmu_active)
+		kvm_zap_obsolete_pages(kvm);
 
 	write_unlock(&kvm->mmu_lock);
 
@@ -5498,29 +5514,29 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
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
+	if (kvm->arch.shadow_mmu_active) {
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
 
@@ -5547,12 +5563,15 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 				      struct kvm_memory_slot *memslot,
 				      int start_level)
 {
-	bool flush;
+	bool flush = false;
 
-	write_lock(&kvm->mmu_lock);
-	flush = slot_handle_level(kvm, memslot, slot_rmap_write_protect,
-				start_level, KVM_MAX_HUGEPAGE_LEVEL, false);
-	write_unlock(&kvm->mmu_lock);
+	if (kvm->arch.shadow_mmu_active) {
+		write_lock(&kvm->mmu_lock);
+		flush = slot_handle_level(kvm, memslot, slot_rmap_write_protect,
+					  start_level, KVM_MAX_HUGEPAGE_LEVEL,
+					  false);
+		write_unlock(&kvm->mmu_lock);
+	}
 
 	if (is_tdp_mmu_enabled(kvm)) {
 		read_lock(&kvm->mmu_lock);
@@ -5622,16 +5641,15 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 	struct kvm_memory_slot *slot = (struct kvm_memory_slot *)memslot;
 	bool flush;
 
-	write_lock(&kvm->mmu_lock);
-	flush = slot_handle_leaf(kvm, slot, kvm_mmu_zap_collapsible_spte, true);
-
-	if (flush)
-		kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
-	write_unlock(&kvm->mmu_lock);
+	if (kvm->arch.shadow_mmu_active) {
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
@@ -5658,11 +5676,14 @@ void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
 void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 				   struct kvm_memory_slot *memslot)
 {
-	bool flush;
+	bool flush = false;
 
-	write_lock(&kvm->mmu_lock);
-	flush = slot_handle_leaf(kvm, memslot, __rmap_clear_dirty, false);
-	write_unlock(&kvm->mmu_lock);
+	if (kvm->arch.shadow_mmu_active) {
+		write_lock(&kvm->mmu_lock);
+		flush = slot_handle_leaf(kvm, memslot, __rmap_clear_dirty,
+					 false);
+		write_unlock(&kvm->mmu_lock);
+	}
 
 	if (is_tdp_mmu_enabled(kvm)) {
 		read_lock(&kvm->mmu_lock);
@@ -5687,6 +5708,14 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 	int ign;
 
 	write_lock(&kvm->mmu_lock);
+	if (is_tdp_mmu_enabled(kvm))
+		kvm_tdp_mmu_zap_all(kvm);
+
+	if (!kvm->arch.shadow_mmu_active) {
+		write_unlock(&kvm->mmu_lock);
+		return;
+	}
+
 restart:
 	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link) {
 		if (WARN_ON(sp->role.invalid))
@@ -5699,9 +5728,6 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 
-	if (is_tdp_mmu_enabled(kvm))
-		kvm_tdp_mmu_zap_all(kvm);
-
 	write_unlock(&kvm->mmu_lock);
 }
 
-- 
2.31.1.498.g6c1eba8ee3d-goog

