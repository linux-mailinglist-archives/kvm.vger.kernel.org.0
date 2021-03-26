Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45BAF349F88
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 03:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhCZCUz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 22:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbhCZCUZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 22:20:25 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7352BC0613D7
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 19:20:25 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id x10so8361471ybr.11
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 19:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=3AgZ1tXB5fsmC9BqolsIozmnqnoXMTYWhC7BKZkiX/k=;
        b=OyvJj/iJwjaokx6AiNv8/+wi/SJujMbURg54zi2DAFVIy7RKNlyW1Ofw2aezhxPHQP
         xy8/NNmr7u1tpPIuhP6uc9BgCnU8BrSugIoZdqtBW73/dOdNpPLV9QXmd6E9y0pPi/tn
         PCSaNnznpyI2+X88wTtVN5vrzM+ZHqRtvIeF5pxspwDgffYRwR2IPJYKwyvCuji2P9FJ
         yVnWJ6dzjggzHLNmbV74iPSF1hkAWyqcacOxwSTrmuYjqCoAtbev52lw+POPWqErwIq/
         DA3F9HAvpKzO+Nct8+cNLyAVcxRoCK6T7PHyd6ree/SliuWUS+uXs36MmQ6wMIEOrOCx
         P5pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=3AgZ1tXB5fsmC9BqolsIozmnqnoXMTYWhC7BKZkiX/k=;
        b=dgWCB+893HI2YZ7W95hcaIa8OrfLMmu0xZkXbS0k86NPlBY3lX5Vh2l8L5MHMydxaG
         TTAOmsNk7i9p8Rx+1rNiEF8PpvX2N5KRxnOW1cqPpccd22HSFnPWUbaZRhIVDzjxXECs
         ZFc7SDVg1lVXxxfeH323cguPS3NJaWEz2KV7WvndPcqeDGowScEHzEYzlq3i0gRJwPa5
         kauEfoJKrpn4JvWZbmmcm7UJlZtXssuJZxSlS+Nu5UG7Et/VuVYDG0lFAM2yHQln/guA
         v78h3uTNgvYEbL2zmZXz5HMm0jjc1LkdbNVas2m6f1oc5hUUJIf8bELczOAYDItFOBEk
         Zxig==
X-Gm-Message-State: AOAM532yPNJXiWX5lhzJZG4HZC0yczyEaEuMLwnGrAWZFFuQKxZE4Rrl
        2RVKa5xOL/Ss4eKniqEFUe2upDdJ604=
X-Google-Smtp-Source: ABdhPJz4J4AlDNUuHmarx4p63A7F1ftWtx7VoOUQI0sOGW99e4CpULlCgcHiaKNZ+licKK4wHDqKcNjBUg8=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b1bb:fab2:7ef5:fc7d])
 (user=seanjc job=sendgmr) by 2002:a25:655:: with SMTP id 82mr14774831ybg.168.1616725224644;
 Thu, 25 Mar 2021 19:20:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Mar 2021 19:19:45 -0700
In-Reply-To: <20210326021957.1424875-1-seanjc@google.com>
Message-Id: <20210326021957.1424875-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210326021957.1424875-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 06/18] KVM: x86/mmu: Pass address space ID to TDP MMU root walkers
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the address space ID check that is performed when iterating over
roots into the macro helpers to consolidate code.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu_internal.h |  7 ++-
 arch/x86/kvm/mmu/tdp_mmu.c      | 99 ++++++++++++---------------------
 2 files changed, 42 insertions(+), 64 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index db2faa806ab7..cead1d81e663 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -129,9 +129,14 @@ static inline bool kvm_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *sp)
 	return !sp->root_count;
 }
 
+static inline int kvm_mmu_role_as_id(union kvm_mmu_page_role role)
+{
+	return role.smm ? 1 : 0;
+}
+
 static inline int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
 {
-	return sp->role.smm ? 1 : 0;
+	return kvm_mmu_role_as_id(sp->role);
 }
 
 /*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index bf279fff70ea..7fe5004b1565 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -76,14 +76,18 @@ static inline struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
  * if exiting the loop early, the caller must drop the reference to the most
  * recent root. (Unless keeping a live reference is desirable.)
  */
-#define for_each_tdp_mmu_root_yield_safe(_kvm, _root)				\
+#define for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id)		\
 	for (_root = list_first_entry(&_kvm->arch.tdp_mmu_roots,	\
 				      typeof(*_root), link);		\
 	     tdp_mmu_next_root_valid(_kvm, _root);			\
-	     _root = tdp_mmu_next_root(_kvm, _root))
+	     _root = tdp_mmu_next_root(_kvm, _root))			\
+		if (kvm_mmu_page_as_id(_root) != _as_id) {		\
+		} else
 
-#define for_each_tdp_mmu_root(_kvm, _root)				\
-	list_for_each_entry(_root, &_kvm->arch.tdp_mmu_roots, link)
+#define for_each_tdp_mmu_root(_kvm, _root, _as_id)			\
+	list_for_each_entry(_root, &_kvm->arch.tdp_mmu_roots, link)	\
+		if (kvm_mmu_page_as_id(_root) != _as_id) {		\
+		} else
 
 static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			  gfn_t start, gfn_t end, bool can_yield, bool flush);
@@ -148,7 +152,7 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 	role = page_role_for_level(vcpu, vcpu->arch.mmu->shadow_root_level);
 
 	/* Check for an existing root before allocating a new one. */
-	for_each_tdp_mmu_root(kvm, root) {
+	for_each_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
 		if (root->role.word == role.word) {
 			kvm_mmu_get_root(kvm, root);
 			goto out;
@@ -709,11 +713,8 @@ bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
 {
 	struct kvm_mmu_page *root;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root) {
-		if (kvm_mmu_page_as_id(root) != as_id)
-			continue;
+	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id)
 		flush = zap_gfn_range(kvm, root, start, end, can_yield, flush);
-	}
 
 	return flush;
 }
@@ -893,27 +894,28 @@ static __always_inline int kvm_tdp_mmu_handle_hva_range(struct kvm *kvm,
 	int ret = 0;
 	int as_id;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root) {
-		as_id = kvm_mmu_page_as_id(root);
-		slots = __kvm_memslots(kvm, as_id);
-		kvm_for_each_memslot(memslot, slots) {
-			unsigned long hva_start, hva_end;
-			gfn_t gfn_start, gfn_end;
+	for (as_id = 0; as_id < KVM_ADDRESS_SPACE_NUM; as_id++) {
+		for_each_tdp_mmu_root_yield_safe(kvm, root, as_id) {
+			slots = __kvm_memslots(kvm, as_id);
+			kvm_for_each_memslot(memslot, slots) {
+				unsigned long hva_start, hva_end;
+				gfn_t gfn_start, gfn_end;
 
-			hva_start = max(start, memslot->userspace_addr);
-			hva_end = min(end, memslot->userspace_addr +
-				      (memslot->npages << PAGE_SHIFT));
-			if (hva_start >= hva_end)
-				continue;
-			/*
-			 * {gfn(page) | page intersects with [hva_start, hva_end)} =
-			 * {gfn_start, gfn_start+1, ..., gfn_end-1}.
-			 */
-			gfn_start = hva_to_gfn_memslot(hva_start, memslot);
-			gfn_end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, memslot);
+				hva_start = max(start, memslot->userspace_addr);
+				hva_end = min(end, memslot->userspace_addr +
+					(memslot->npages << PAGE_SHIFT));
+				if (hva_start >= hva_end)
+					continue;
+				/*
+				 * {gfn(page) | page intersects with [hva_start, hva_end)} =
+				 * {gfn_start, gfn_start+1, ..., gfn_end-1}.
+				 */
+				gfn_start = hva_to_gfn_memslot(hva_start, memslot);
+				gfn_end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, memslot);
 
-			ret |= handler(kvm, memslot, root, gfn_start,
-				       gfn_end, data);
+				ret |= handler(kvm, memslot, root, gfn_start,
+					gfn_end, data);
+			}
 		}
 	}
 
@@ -1125,17 +1127,11 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
 			     int min_level)
 {
 	struct kvm_mmu_page *root;
-	int root_as_id;
 	bool spte_set = false;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root) {
-		root_as_id = kvm_mmu_page_as_id(root);
-		if (root_as_id != slot->as_id)
-			continue;
-
+	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id)
 		spte_set |= wrprot_gfn_range(kvm, root, slot->base_gfn,
 			     slot->base_gfn + slot->npages, min_level);
-	}
 
 	return spte_set;
 }
@@ -1190,17 +1186,11 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
 	struct kvm_mmu_page *root;
-	int root_as_id;
 	bool spte_set = false;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root) {
-		root_as_id = kvm_mmu_page_as_id(root);
-		if (root_as_id != slot->as_id)
-			continue;
-
+	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id)
 		spte_set |= clear_dirty_gfn_range(kvm, root, slot->base_gfn,
 				slot->base_gfn + slot->npages);
-	}
 
 	return spte_set;
 }
@@ -1262,16 +1252,10 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 				       bool wrprot)
 {
 	struct kvm_mmu_page *root;
-	int root_as_id;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
-	for_each_tdp_mmu_root(kvm, root) {
-		root_as_id = kvm_mmu_page_as_id(root);
-		if (root_as_id != slot->as_id)
-			continue;
-
+	for_each_tdp_mmu_root(kvm, root, slot->as_id)
 		clear_dirty_pt_masked(kvm, root, gfn, mask, wrprot);
-	}
 }
 
 /*
@@ -1324,15 +1308,9 @@ bool kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				       struct kvm_memory_slot *slot, bool flush)
 {
 	struct kvm_mmu_page *root;
-	int root_as_id;
-
-	for_each_tdp_mmu_root_yield_safe(kvm, root) {
-		root_as_id = kvm_mmu_page_as_id(root);
-		if (root_as_id != slot->as_id)
-			continue;
 
+	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id)
 		flush = zap_collapsible_spte_range(kvm, root, slot, flush);
-	}
 
 	return flush;
 }
@@ -1376,17 +1354,12 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn)
 {
 	struct kvm_mmu_page *root;
-	int root_as_id;
 	bool spte_set = false;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
-	for_each_tdp_mmu_root(kvm, root) {
-		root_as_id = kvm_mmu_page_as_id(root);
-		if (root_as_id != slot->as_id)
-			continue;
-
+	for_each_tdp_mmu_root(kvm, root, slot->as_id)
 		spte_set |= write_protect_gfn(kvm, root, gfn);
-	}
+
 	return spte_set;
 }
 
-- 
2.31.0.291.g576ba9dcdaf-goog

