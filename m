Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59419653893
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 23:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235113AbiLUWZo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 17:25:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235042AbiLUWZM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 17:25:12 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76D82790D
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 14:24:41 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id g1-20020a636b01000000b00479222d9875so102332pgc.12
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 14:24:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=G8yCm8/A9muZfDD3Vt2EwogqpDhIyDMvg2eScRp1Hns=;
        b=RZtEbegJX7+lnjjBMFgZ9yF+y8dpXdZXUnYPKvKz5AnEC3U28/Sy5KCutLHCHP9qii
         KFytERkZFCHgqDPy7+veHu2TMRasyzT+t0xfCh1UPiqN16FymNAzzxa9XHMJQqDLLKKp
         3/i9EgNeEXg34KUtXzZGsmODzlMYPaFeGTQ552wdnUk2RqqvGPcmMEDbt0xbfEhgtDHY
         s9ncMZW7Lx8E9FfxdqlSAEhyEFNFZhS+Swfg9V0tQRaF2yuhmHLZFhYEJNCMf3OQH8tp
         LU9mFt24OB62q0EKzcPAS4NYVShoOWZexvsM428AQaFopIGAMH8lOwOOoXMkVOrXXsV8
         9SYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G8yCm8/A9muZfDD3Vt2EwogqpDhIyDMvg2eScRp1Hns=;
        b=LQy/YPq+7+1rAUiV/iBN6qFihJ3LnvdKLH3IcaFyh7ue721xGXpJyITyAZNHWqlvS0
         UyFfKYm/XmJfetso+NRjAUd0QL3fpEYAzZ4roj/SH9skYVtmZuzeXVCow7g/JPFNdwxC
         9ltBWImsgF6arOWpxTelJ/jpNPOKwML2J38t+6TMEHlQ4R58ISW38EUQRJOMXzTpbfRm
         +y4Lv1K7T+cqHVYLxWJdGl5CgQlW4qvDRpTfDoOvCwukIZYYVMOV14JykvfWxTXav0/4
         aCsPe66lQX6YwFuhYt5AhYJ2c29Y2WpumCgl6FXhL7L/5EAaxp8JEwXRJYMFe6pSwCrq
         XQgw==
X-Gm-Message-State: AFqh2kpJyXE3iGZKGzVaY17xDQ+hq9ce5UNc+sM3uHYjrGUbDzWv7FZQ
        SAMeR5QuvASGFncr8Wu5aAUb1qdpU6x2
X-Google-Smtp-Source: AMrXdXs312qIWY+dZtObZ6u1B9Ff0KtgXEvz31qgLoC/IptoeHSVZDxiHLVxBuFUD5n2iAI2eXbWE4zug7Py
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:aa7:9f4c:0:b0:56d:8d19:f331 with SMTP id
 h12-20020aa79f4c000000b0056d8d19f331mr259462pfr.7.1671661480589; Wed, 21 Dec
 2022 14:24:40 -0800 (PST)
Date:   Wed, 21 Dec 2022 22:24:15 +0000
In-Reply-To: <20221221222418.3307832-1-bgardon@google.com>
Mime-Version: 1.0
References: <20221221222418.3307832-1-bgardon@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221221222418.3307832-12-bgardon@google.com>
Subject: [RFC 11/14] KVM: x86/MMU: Factor Shadow MMU wrprot / clear dirty ops
 out of mmu.c
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

There are several functions in mmu.c which bifrucate to the Shadow
and/or TDP MMU implementations. In most of these, the Shadow MMU
implementation is open-coded. Wrap these instances in a nice function
which just needs kvm and slot arguments or similar. This matches the TDP
MMU interface and will allow for some nice cleanups in a following
commit.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c        | 52 ++++++----------------------
 arch/x86/kvm/mmu/shadow_mmu.c | 64 +++++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/shadow_mmu.h | 15 ++++++++
 3 files changed, 90 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 160dd143a814..ce2a6dd38c67 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -417,23 +417,13 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 				     struct kvm_memory_slot *slot,
 				     gfn_t gfn_offset, unsigned long mask)
 {
-	struct kvm_rmap_head *rmap_head;
-
 	if (is_tdp_mmu_enabled(kvm))
 		kvm_tdp_mmu_clear_dirty_pt_masked(kvm, slot,
 				slot->base_gfn + gfn_offset, mask, true);
 
-	if (!kvm_memslots_have_rmaps(kvm))
-		return;
-
-	while (mask) {
-		rmap_head = gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
-					PG_LEVEL_4K, slot);
-		rmap_write_protect(rmap_head, false);
-
-		/* clear the first set bit */
-		mask &= mask - 1;
-	}
+	if (kvm_memslots_have_rmaps(kvm))
+		kvm_shadow_mmu_write_protect_pt_masked(kvm, slot, gfn_offset,
+						       mask);
 }
 
 /**
@@ -450,23 +440,13 @@ static void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 					 struct kvm_memory_slot *slot,
 					 gfn_t gfn_offset, unsigned long mask)
 {
-	struct kvm_rmap_head *rmap_head;
-
 	if (is_tdp_mmu_enabled(kvm))
 		kvm_tdp_mmu_clear_dirty_pt_masked(kvm, slot,
 				slot->base_gfn + gfn_offset, mask, false);
 
-	if (!kvm_memslots_have_rmaps(kvm))
-		return;
-
-	while (mask) {
-		rmap_head = gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
-					PG_LEVEL_4K, slot);
-		__rmap_clear_dirty(kvm, rmap_head, slot);
-
-		/* clear the first set bit */
-		mask &= mask - 1;
-	}
+	if (kvm_memslots_have_rmaps(kvm))
+		kvm_shadow_mmu_clear_dirty_pt_masked(kvm, slot, gfn_offset,
+						     mask);
 }
 
 /**
@@ -524,16 +504,11 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 				    struct kvm_memory_slot *slot, u64 gfn,
 				    int min_level)
 {
-	struct kvm_rmap_head *rmap_head;
-	int i;
 	bool write_protected = false;
 
-	if (kvm_memslots_have_rmaps(kvm)) {
-		for (i = min_level; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
-			rmap_head = gfn_to_rmap(gfn, i, slot);
-			write_protected |= rmap_write_protect(rmap_head, true);
-		}
-	}
+	if (kvm_memslots_have_rmaps(kvm))
+		write_protected |=
+			kvm_shadow_mmu_write_protect_gfn(kvm, slot, gfn, min_level);
 
 	if (is_tdp_mmu_enabled(kvm))
 		write_protected |=
@@ -2917,8 +2892,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 {
 	if (kvm_memslots_have_rmaps(kvm)) {
 		write_lock(&kvm->mmu_lock);
-		slot_handle_level(kvm, memslot, slot_rmap_write_protect,
-				  start_level, KVM_MAX_HUGEPAGE_LEVEL, false);
+		kvm_shadow_mmu_wrprot_slot(kvm, memslot, start_level);
 		write_unlock(&kvm->mmu_lock);
 	}
 
@@ -3069,11 +3043,7 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 {
 	if (kvm_memslots_have_rmaps(kvm)) {
 		write_lock(&kvm->mmu_lock);
-		/*
-		 * Clear dirty bits only on 4k SPTEs since the legacy MMU only
-		 * support dirty logging at a 4k granularity.
-		 */
-		slot_handle_level_4k(kvm, memslot, __rmap_clear_dirty, false);
+		kvm_shadow_mmu_clear_dirty_slot(kvm, memslot);
 		write_unlock(&kvm->mmu_lock);
 	}
 
diff --git a/arch/x86/kvm/mmu/shadow_mmu.c b/arch/x86/kvm/mmu/shadow_mmu.c
index 2d1a4026cf00..80b8c78daaeb 100644
--- a/arch/x86/kvm/mmu/shadow_mmu.c
+++ b/arch/x86/kvm/mmu/shadow_mmu.c
@@ -3440,3 +3440,67 @@ unsigned long kvm_shadow_mmu_shrink_scan(struct kvm *kvm, int pages_to_free)
 
 	return freed;
 }
+
+void kvm_shadow_mmu_write_protect_pt_masked(struct kvm *kvm,
+					    struct kvm_memory_slot *slot,
+					    gfn_t gfn_offset, unsigned long mask)
+{
+	struct kvm_rmap_head *rmap_head;
+
+	while (mask) {
+		rmap_head = gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
+					PG_LEVEL_4K, slot);
+		rmap_write_protect(rmap_head, false);
+
+		/* clear the first set bit */
+		mask &= mask - 1;
+	}
+}
+
+void kvm_shadow_mmu_clear_dirty_pt_masked(struct kvm *kvm,
+					  struct kvm_memory_slot *slot,
+					  gfn_t gfn_offset, unsigned long mask)
+{
+	struct kvm_rmap_head *rmap_head;
+
+	while (mask) {
+		rmap_head = gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
+					PG_LEVEL_4K, slot);
+		__rmap_clear_dirty(kvm, rmap_head, slot);
+
+		/* clear the first set bit */
+		mask &= mask - 1;
+	}
+}
+
+bool kvm_shadow_mmu_write_protect_gfn(struct kvm *kvm,
+				      struct kvm_memory_slot *slot,
+				      u64 gfn, int min_level)
+{
+	struct kvm_rmap_head *rmap_head;
+	int i;
+	bool write_protected = false;
+
+	if (kvm_memslots_have_rmaps(kvm)) {
+		for (i = min_level; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
+			rmap_head = gfn_to_rmap(gfn, i, slot);
+			write_protected |= rmap_write_protect(rmap_head, true);
+		}
+	}
+
+	return write_protected;
+}
+
+void kvm_shadow_mmu_clear_dirty_slot(struct kvm *kvm,
+				     const struct kvm_memory_slot *memslot)
+{
+	slot_handle_level_4k(kvm, memslot, __rmap_clear_dirty, false);
+}
+
+void kvm_shadow_mmu_wrprot_slot(struct kvm *kvm,
+				const struct kvm_memory_slot *memslot,
+				int start_level)
+{
+	slot_handle_level(kvm, memslot, slot_rmap_write_protect,
+			  start_level, KVM_MAX_HUGEPAGE_LEVEL, false);
+}
diff --git a/arch/x86/kvm/mmu/shadow_mmu.h b/arch/x86/kvm/mmu/shadow_mmu.h
index af201d34d0b2..c322eeaa0688 100644
--- a/arch/x86/kvm/mmu/shadow_mmu.h
+++ b/arch/x86/kvm/mmu/shadow_mmu.h
@@ -104,6 +104,21 @@ void kvm_shadow_mmu_zap_collapsible_sptes(struct kvm *kvm,
 bool kvm_shadow_mmu_has_zapped_obsolete_pages(struct kvm *kvm);
 unsigned long kvm_shadow_mmu_shrink_scan(struct kvm *kvm, int pages_to_free);
 
+void kvm_shadow_mmu_write_protect_pt_masked(struct kvm *kvm,
+					    struct kvm_memory_slot *slot,
+					    gfn_t gfn_offset, unsigned long mask);
+void kvm_shadow_mmu_clear_dirty_pt_masked(struct kvm *kvm,
+					  struct kvm_memory_slot *slot,
+					  gfn_t gfn_offset, unsigned long mask);
+bool kvm_shadow_mmu_write_protect_gfn(struct kvm *kvm,
+				      struct kvm_memory_slot *slot,
+				      u64 gfn, int min_level);
+void kvm_shadow_mmu_clear_dirty_slot(struct kvm *kvm,
+				     const struct kvm_memory_slot *memslot);
+void kvm_shadow_mmu_wrprot_slot(struct kvm *kvm,
+				const struct kvm_memory_slot *memslot,
+				int start_level);
+
 /* Exports from paging_tmpl.h */
 gpa_t paging32_gva_to_gpa(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			  gpa_t vaddr, u64 access,
-- 
2.39.0.314.g84b9a713c41-goog

