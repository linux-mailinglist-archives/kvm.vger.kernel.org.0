Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 449E3688679
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 19:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbjBBSaN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 13:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbjBBS3Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 13:29:25 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB123F2B2
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 10:28:40 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 201-20020a6300d2000000b004ccf545f44fso1373310pga.12
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 10:28:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=F2DHKgw0dJCtwQxpbZaWFIOX07AJ3Q8QHUf3isrBY5Q=;
        b=hp3/EcJmYWEvxFjMK6a/uHpM1/syENeJe8Vvon0/F0y95LHB1UdDLRIDLy8N2fbnGz
         aLVOkNCYi1c49Z3AvQargVa8ZHbDsPSERWCFQbdrUusIodCCUkfqI0SNdPidsNnRfPm0
         JAZDm+rCgHNoBeAXuhhHiZy6TKc1Dou8DmV4tVp+bExmmdqerC28oE/BkhYDUMS+mfi6
         vtMcr/v80IWmTBj6AV/kY5Y7thWKzdPPsI5jxHsgvYNxug0EmP7ubS9aNVRGYj/m3k7j
         DTv45ZxkQ1pxSQwGY4zXeQgCvjHb46/SQTAemmsze3WrW0UbLW/5lV5NhGSw4dtjLLqz
         8PSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F2DHKgw0dJCtwQxpbZaWFIOX07AJ3Q8QHUf3isrBY5Q=;
        b=5BzGQ3HNkdpnNrc1CsJoVvDRf4UywlfsU2ovfXuCQ1tQBNmamem9g7nF+veh8ofrEU
         YQQRIEvfQogvNLBXawySSRyZNtC4cOaO/qLQknU/SbuohuaHQqz7yN4ORd4rPbsff1Tx
         yOuq8aSUgekMQWRXbYoojPc6+ggc0zL6zJ2MsyDAiQVLCN4wrWTe8zWMPDk8J17495Q4
         oupqc3+VkS+JNkMzL7HHb9OP2Uujmj1TczKMrv0UeS+N8hUn4I0f+lkE91L4clGvuKhq
         OXgntjPrJdHg12tZ4Nc51TGpP9qDA0a/EHOLzY2oZ8enjLg6uwyB4kKkRQeUr5NY047A
         i9Bw==
X-Gm-Message-State: AO0yUKWmZtS1/MUbtwAoX8yUGpRYLT0YBYMWO68/eX4kVMM5sIVa5fI2
        E7SldplZC+ycjYhnB+49bTCI47DPyhvB
X-Google-Smtp-Source: AK7set+1St8r3W5I1nEX/i8TVU1qDuow8994BZxFffesASfmjhN2QvIEIdFdhBsjnGpeO3g0yilg51yyg8NR
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:90a:6388:b0:225:eaa2:3f5d with SMTP id
 f8-20020a17090a638800b00225eaa23f5dmr105787pjj.2.1675362510924; Thu, 02 Feb
 2023 10:28:30 -0800 (PST)
Date:   Thu,  2 Feb 2023 18:28:00 +0000
In-Reply-To: <20230202182809.1929122-1-bgardon@google.com>
Mime-Version: 1.0
References: <20230202182809.1929122-1-bgardon@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230202182809.1929122-13-bgardon@google.com>
Subject: [PATCH 12/21] KVM: x86/MMU: Clean up naming of exported Shadow MMU functions
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Change the naming scheme on several functions exported from the shadow
MMU to match the naming scheme used by the TDP MMU: kvm_shadow_mmu_.
More cleanups will follow to convert the remaining functions to a similar
naming scheme, but for now, start with the trivial renames.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 19 ++++++++++---------
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 arch/x86/kvm/mmu/shadow_mmu.c  | 19 ++++++++++---------
 arch/x86/kvm/mmu/shadow_mmu.h  | 17 +++++++++--------
 4 files changed, 30 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3ea54b08239aa..9308ab8102f9b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1089,7 +1089,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	int r;
 
 	write_lock(&vcpu->kvm->mmu_lock);
-	r = make_mmu_pages_available(vcpu);
+	r = kvm_shadow_mmu_make_pages_available(vcpu);
 	if (r < 0)
 		goto out_unlock;
 
@@ -1164,7 +1164,7 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 	if (is_tdp_mmu_active(vcpu))
 		leaf = kvm_tdp_mmu_get_walk(vcpu, addr, sptes, &root);
 	else
-		leaf = get_walk(vcpu, addr, sptes, &root);
+		leaf = kvm_shadow_mmu_get_walk(vcpu, addr, sptes, &root);
 
 	walk_shadow_page_lockless_end(vcpu);
 
@@ -1432,11 +1432,11 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (is_page_fault_stale(vcpu, fault))
 		goto out_unlock;
 
-	r = make_mmu_pages_available(vcpu);
+	r = kvm_shadow_mmu_make_pages_available(vcpu);
 	if (r)
 		goto out_unlock;
 
-	r = direct_map(vcpu, fault);
+	r = kvm_shadow_mmu_direct_map(vcpu, fault);
 
 out_unlock:
 	write_unlock(&vcpu->kvm->mmu_lock);
@@ -1471,7 +1471,7 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 		trace_kvm_page_fault(vcpu, fault_address, error_code);
 
 		if (kvm_event_needs_reinjection(vcpu))
-			kvm_mmu_unprotect_page_virt(vcpu, fault_address);
+			kvm_shadow_mmu_unprotect_page_virt(vcpu, fault_address);
 		r = kvm_mmu_page_fault(vcpu, fault_address, error_code, insn,
 				insn_len);
 	} else if (flags & KVM_PV_REASON_PAGE_NOT_PRESENT) {
@@ -2786,7 +2786,8 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	 * In order to ensure all vCPUs drop their soon-to-be invalid roots,
 	 * invalidating TDP MMU roots must be done while holding mmu_lock for
 	 * write and in the same critical section as making the reload request,
-	 * e.g. before kvm_zap_obsolete_pages() could drop mmu_lock and yield.
+	 * e.g. before kvm_shadow_mmu_zap_obsolete_pages() could drop mmu_lock
+	 * and yield.
 	 */
 	if (tdp_mmu_enabled)
 		kvm_tdp_mmu_invalidate_all_roots(kvm);
@@ -2801,7 +2802,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	 */
 	kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_FREE_OBSOLETE_ROOTS);
 
-	kvm_zap_obsolete_pages(kvm);
+	kvm_shadow_mmu_zap_obsolete_pages(kvm);
 
 	write_unlock(&kvm->mmu_lock);
 
@@ -2890,7 +2891,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 
 	kvm_mmu_invalidate_begin(kvm, 0, -1ul);
 
-	flush = kvm_rmap_zap_gfn_range(kvm, gfn_start, gfn_end);
+	flush = kvm_shadow_mmu_zap_gfn_range(kvm, gfn_start, gfn_end);
 
 	if (tdp_mmu_enabled) {
 		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
@@ -3034,7 +3035,7 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 {
 	if (kvm_memslots_have_rmaps(kvm)) {
 		write_lock(&kvm->mmu_lock);
-		kvm_rmap_zap_collapsible_sptes(kvm, slot);
+		kvm_shadow_mmu_zap_collapsible_sptes(kvm, slot);
 		write_unlock(&kvm->mmu_lock);
 	}
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 1251357794538..14a8c8217c4cf 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -866,7 +866,7 @@ int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	if (is_page_fault_stale(vcpu, fault))
 		goto out_unlock;
 
-	r = make_mmu_pages_available(vcpu);
+	r = kvm_shadow_mmu_make_pages_available(vcpu);
 	if (r)
 		goto out_unlock;
 	r = FNAME(fetch)(vcpu, fault, &walker);
diff --git a/arch/x86/kvm/mmu/shadow_mmu.c b/arch/x86/kvm/mmu/shadow_mmu.c
index 76c50aca3c487..36b335d75aee2 100644
--- a/arch/x86/kvm/mmu/shadow_mmu.c
+++ b/arch/x86/kvm/mmu/shadow_mmu.c
@@ -1977,7 +1977,7 @@ static inline unsigned long kvm_mmu_available_pages(struct kvm *kvm)
 	return 0;
 }
 
-int make_mmu_pages_available(struct kvm_vcpu *vcpu)
+int kvm_shadow_mmu_make_pages_available(struct kvm_vcpu *vcpu)
 {
 	unsigned long avail = kvm_mmu_available_pages(vcpu->kvm);
 
@@ -2041,7 +2041,7 @@ int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 	return r;
 }
 
-int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
+int kvm_shadow_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
 {
 	gpa_t gpa;
 	int r;
@@ -2331,7 +2331,7 @@ static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
 	__direct_pte_prefetch(vcpu, sp, sptep);
 }
 
-int direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+int kvm_shadow_mmu_direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_shadow_walk_iterator it;
 	struct kvm_mmu_page *sp;
@@ -2549,7 +2549,7 @@ int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		return r;
 
 	write_lock(&vcpu->kvm->mmu_lock);
-	r = make_mmu_pages_available(vcpu);
+	r = kvm_shadow_mmu_make_pages_available(vcpu);
 	if (r < 0)
 		goto out_unlock;
 
@@ -2797,7 +2797,8 @@ void kvm_mmu_sync_prev_roots(struct kvm_vcpu *vcpu)
  *
  * Must be called between walk_shadow_page_lockless_{begin,end}.
  */
-int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes, int *root_level)
+int kvm_shadow_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
+			    int *root_level)
 {
 	struct kvm_shadow_walk_iterator iterator;
 	int leaf = -1;
@@ -3104,7 +3105,7 @@ __always_inline bool walk_slot_rmaps_4k(struct kvm *kvm,
 }
 
 #define BATCH_ZAP_PAGES	10
-void kvm_zap_obsolete_pages(struct kvm *kvm)
+void kvm_shadow_mmu_zap_obsolete_pages(struct kvm *kvm)
 {
 	struct kvm_mmu_page *sp, *node;
 	int nr_zapped, batch = 0;
@@ -3165,7 +3166,7 @@ bool kvm_shadow_mmu_has_zapped_obsolete_pages(struct kvm *kvm)
 	return unlikely(!list_empty_careful(&kvm->arch.zapped_obsolete_pages));
 }
 
-bool kvm_rmap_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
+bool kvm_shadow_mmu_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 {
 	const struct kvm_memory_slot *memslot;
 	struct kvm_memslots *slots;
@@ -3417,8 +3418,8 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 	return need_tlb_flush;
 }
 
-void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
-				    const struct kvm_memory_slot *slot)
+void kvm_shadow_mmu_zap_collapsible_sptes(struct kvm *kvm,
+					  const struct kvm_memory_slot *slot)
 {
 	/*
 	 * Note, use KVM_MAX_HUGEPAGE_LEVEL - 1 since there's no need to zap
diff --git a/arch/x86/kvm/mmu/shadow_mmu.h b/arch/x86/kvm/mmu/shadow_mmu.h
index 9e27d03fbe368..cc28895d2a24f 100644
--- a/arch/x86/kvm/mmu/shadow_mmu.h
+++ b/arch/x86/kvm/mmu/shadow_mmu.h
@@ -73,18 +73,19 @@ bool kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 			      struct list_head *invalid_list);
 void kvm_mmu_commit_zap_page(struct kvm *kvm, struct list_head *invalid_list);
 
-int make_mmu_pages_available(struct kvm_vcpu *vcpu);
+int kvm_shadow_mmu_make_pages_available(struct kvm_vcpu *vcpu);
 
-int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva);
+int kvm_shadow_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva);
 
-int direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
+int kvm_shadow_mmu_direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 u64 *fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gpa_t gpa, u64 *spte);
 
 hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant, u8 level);
 int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu);
 int mmu_alloc_special_roots(struct kvm_vcpu *vcpu);
 
-int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes, int *root_level);
+int kvm_shadow_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
+			    int *root_level);
 
 void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 		       int bytes, struct kvm_page_track_notifier_node *node);
@@ -99,8 +100,8 @@ bool walk_slot_rmaps(struct kvm *kvm, const struct kvm_memory_slot *slot,
 bool walk_slot_rmaps_4k(struct kvm *kvm, const struct kvm_memory_slot *slot,
 			slot_rmaps_handler fn, bool flush_on_yield);
 
-void kvm_zap_obsolete_pages(struct kvm *kvm);
-bool kvm_rmap_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
+void kvm_shadow_mmu_zap_obsolete_pages(struct kvm *kvm);
+bool kvm_shadow_mmu_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
 
 bool slot_rmap_write_protect(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 			     const struct kvm_memory_slot *slot);
@@ -109,8 +110,8 @@ void kvm_shadow_mmu_try_split_huge_pages(struct kvm *kvm,
 					 const struct kvm_memory_slot *slot,
 					 gfn_t start, gfn_t end,
 					 int target_level);
-void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
-				    const struct kvm_memory_slot *slot);
+void kvm_shadow_mmu_zap_collapsible_sptes(struct kvm *kvm,
+					  const struct kvm_memory_slot *slot);
 
 bool kvm_shadow_mmu_has_zapped_obsolete_pages(struct kvm *kvm);
 unsigned long kvm_shadow_mmu_shrink_scan(struct kvm *kvm, int pages_to_free);
-- 
2.39.1.519.gcb327c4b5f-goog

