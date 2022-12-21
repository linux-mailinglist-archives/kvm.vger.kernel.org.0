Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A378653881
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 23:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234942AbiLUWY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 17:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiLUWY0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 17:24:26 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE102715A
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 14:24:25 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id l7-20020a170902f68700b00192495b1f10so153147plg.2
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 14:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mr/upkq9nUstxPAXFOYz+TIWTjnNhJ7646Ga8zDx7MA=;
        b=jcxCfXrS0rhqjdrrTg9RFmHommcZLL9JJIOJmSEjlqGB6hsqaBvlotnqSYyzuM2o1r
         oyxgX7LusyGPkW4t09A2Ps3Tbd/T0zkw/iHV6uV3gwWeBDbz3xZpksS8uIEZQReN8k4D
         gTZ/kgRejuP4J7gYltEmSRz4GYSehjtuE/FLqamWE/P7u15/c9ZToC0iogQQIP8Pejds
         ii5k/zaJDE/8yX30EqZr7Fdi6ezF9uKNfAO4Wkpzv0osK8ojhKjyjCCtLfLzO/HKX78u
         wOc1P5laTqWlvK39uvp0tnnasQLlOXiwegfhLRQh58XXgN51EcR94i5Ib2o2lx+A3Bi6
         sIuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mr/upkq9nUstxPAXFOYz+TIWTjnNhJ7646Ga8zDx7MA=;
        b=UmmHhhsYnuM1beYVIJfYBNsGIC9ycCQTEyRvYYlhfytcvXfK4HYP8Kx+ZrZ8DiaG3R
         MWMK+oTKlKC/Nbi0933h5Fp1W6l7Ilca/u8OXN6Kkvy7U9VBIjSbRgXrwG8IpA7HGYoq
         gfhOp0mpBVd5dhsIwOmtv4Ot0kodF/zVSOWGzYrefktQARSTDtR//hWyTQUEi2VGcNrW
         Vw+Ps7gnRavD2RzEC2cONfUS6BOVFFHYuIb1v/ocveKqjwMhSym72K3NcCg6AokSfzOw
         PadOPEKpqI6lFZhZ0stjARHZ+kQ3pqadAOzTPSSMBIvyFWFDAf2Rhz6RxoOWtITvM+nF
         4XxA==
X-Gm-Message-State: AFqh2krOU6xDrPMzKAeioFVL4GuRjl+XWtzKpa1XVelaq8Qx8Vyg1Jwe
        Jl5J+M5rn0N7iX9SKrcYLgsFLAkV0GyG
X-Google-Smtp-Source: AMrXdXtD9skHtEgX98zo+vsV8XbpbOjpDWDpMzej9vuGx7SmxRfWxOXIU8CMO9TrBWF83dJViVPY5tL4GZ10
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a62:2781:0:b0:57a:6e2a:c236 with SMTP id
 n123-20020a622781000000b0057a6e2ac236mr218098pfn.82.1671661465306; Wed, 21
 Dec 2022 14:24:25 -0800 (PST)
Date:   Wed, 21 Dec 2022 22:24:06 +0000
In-Reply-To: <20221221222418.3307832-1-bgardon@google.com>
Mime-Version: 1.0
References: <20221221222418.3307832-1-bgardon@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221221222418.3307832-3-bgardon@google.com>
Subject: [RFC 02/14] KVM: x86/MMU: Expose functions for the Shadow MMU
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Nagareddy Reddy <nspreddy@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Expose various common MMU functions which the Shadow MMU will need via
mmu_internal.h. This just slightly reduces the work needed to move the
shadow MMU code out of mmu.c, which will already be a massive change.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 41 ++++++++++++++-------------------
 arch/x86/kvm/mmu/mmu_internal.h | 24 +++++++++++++++++++
 2 files changed, 41 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 07b99a7ce830..729a2799d4d7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -156,9 +156,9 @@ struct kvm_shadow_walk_iterator {
 		({ spte = mmu_spte_get_lockless(_walker.sptep); 1; });	\
 	     __shadow_walk_next(&(_walker), spte))
 
-static struct kmem_cache *pte_list_desc_cache;
+struct kmem_cache *pte_list_desc_cache;
 struct kmem_cache *mmu_page_header_cache;
-static struct percpu_counter kvm_total_used_mmu_pages;
+struct percpu_counter kvm_total_used_mmu_pages;
 
 static void mmu_spte_set(u64 *sptep, u64 spte);
 
@@ -234,11 +234,6 @@ static struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
 	return regs;
 }
 
-static inline bool kvm_available_flush_tlb_with_range(void)
-{
-	return kvm_x86_ops.tlb_remote_flush_with_range;
-}
-
 static void kvm_flush_remote_tlbs_with_range(struct kvm *kvm,
 		struct kvm_tlb_range *range)
 {
@@ -262,8 +257,8 @@ void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
 	kvm_flush_remote_tlbs_with_range(kvm, &range);
 }
 
-static void mark_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 gfn,
-			   unsigned int access)
+void mark_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 gfn,
+		    unsigned int access)
 {
 	u64 spte = make_mmio_spte(vcpu, gfn, access);
 
@@ -610,7 +605,7 @@ static bool mmu_spte_age(u64 *sptep)
 	return true;
 }
 
-static void walk_shadow_page_lockless_begin(struct kvm_vcpu *vcpu)
+void walk_shadow_page_lockless_begin(struct kvm_vcpu *vcpu)
 {
 	if (is_tdp_mmu(vcpu->arch.mmu)) {
 		kvm_tdp_mmu_walk_lockless_begin();
@@ -629,7 +624,7 @@ static void walk_shadow_page_lockless_begin(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
+void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
 {
 	if (is_tdp_mmu(vcpu->arch.mmu)) {
 		kvm_tdp_mmu_walk_lockless_end();
@@ -822,8 +817,8 @@ void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 		      &kvm->arch.possible_nx_huge_pages);
 }
 
-static void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
-				 bool nx_huge_page_possible)
+void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+			  bool nx_huge_page_possible)
 {
 	sp->nx_huge_page_disallowed = true;
 
@@ -857,16 +852,15 @@ void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 	list_del_init(&sp->possible_nx_huge_page_link);
 }
 
-static void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	sp->nx_huge_page_disallowed = false;
 
 	untrack_possible_nx_huge_page(kvm, sp);
 }
 
-static struct kvm_memory_slot *
-gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t gfn,
-			    bool no_dirty_log)
+struct kvm_memory_slot *gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu,
+						    gfn_t gfn, bool no_dirty_log)
 {
 	struct kvm_memory_slot *slot;
 
@@ -1403,7 +1397,7 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 	return write_protected;
 }
 
-static bool kvm_vcpu_write_protect_gfn(struct kvm_vcpu *vcpu, u64 gfn)
+bool kvm_vcpu_write_protect_gfn(struct kvm_vcpu *vcpu, u64 gfn)
 {
 	struct kvm_memory_slot *slot;
 
@@ -1902,9 +1896,8 @@ static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	return ret;
 }
 
-static bool kvm_mmu_remote_flush_or_zap(struct kvm *kvm,
-					struct list_head *invalid_list,
-					bool remote_flush)
+bool kvm_mmu_remote_flush_or_zap(struct kvm *kvm, struct list_head *invalid_list,
+				 bool remote_flush)
 {
 	if (!remote_flush && list_empty(invalid_list))
 		return false;
@@ -1916,7 +1909,7 @@ static bool kvm_mmu_remote_flush_or_zap(struct kvm *kvm,
 	return true;
 }
 
-static bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
+bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	if (sp->role.invalid)
 		return true;
@@ -6148,7 +6141,7 @@ static inline bool need_topup(struct kvm_mmu_memory_cache *cache, int min)
 	return kvm_mmu_memory_cache_nr_free_objects(cache) < min;
 }
 
-static bool need_topup_split_caches_or_resched(struct kvm *kvm)
+bool need_topup_split_caches_or_resched(struct kvm *kvm)
 {
 	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
 		return true;
@@ -6163,7 +6156,7 @@ static bool need_topup_split_caches_or_resched(struct kvm *kvm)
 	       need_topup(&kvm->arch.split_shadow_page_cache, 1);
 }
 
-static int topup_split_caches(struct kvm *kvm)
+int topup_split_caches(struct kvm *kvm)
 {
 	/*
 	 * Allocating rmap list entries when splitting huge pages for nested
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index dbaf6755c5a7..856e2e0a8420 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -131,7 +131,9 @@ struct kvm_mmu_page {
 #endif
 };
 
+extern struct kmem_cache *pte_list_desc_cache;
 extern struct kmem_cache *mmu_page_header_cache;
+extern struct percpu_counter kvm_total_used_mmu_pages;
 
 static inline int kvm_mmu_role_as_id(union kvm_mmu_page_role role)
 {
@@ -317,6 +319,28 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
 void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 
 void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
+void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+			  bool nx_huge_page_possible);
 void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
+void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
+static inline bool kvm_available_flush_tlb_with_range(void)
+{
+	return kvm_x86_ops.tlb_remote_flush_with_range;
+}
+
+void mark_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 gfn,
+		    unsigned int access);
+struct kvm_memory_slot *gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu,
+						    gfn_t gfn, bool no_dirty_log);
+bool kvm_vcpu_write_protect_gfn(struct kvm_vcpu *vcpu, u64 gfn);
+bool kvm_mmu_remote_flush_or_zap(struct kvm *kvm, struct list_head *invalid_list,
+				 bool remote_flush);
+bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
+
+void walk_shadow_page_lockless_begin(struct kvm_vcpu *vcpu);
+void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu);
+
+bool need_topup_split_caches_or_resched(struct kvm *kvm);
+int topup_split_caches(struct kvm *kvm);
 #endif /* __KVM_X86_MMU_INTERNAL_H */
-- 
2.39.0.314.g84b9a713c41-goog

