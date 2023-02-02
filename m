Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFDC68867B
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 19:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbjBBSaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 13:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbjBBS3p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 13:29:45 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C6D65ED1
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 10:28:48 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id l1-20020a17090270c100b00198be135a14so1296645plt.9
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 10:28:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hvqHXEXjWYHTPhQcpfchQJxtERd1tvsiHPz9/kGUDP4=;
        b=Ngf+eS881ONCbEyEVOMB8xVJqlLzJrgH97HgBnQSTrNlY2iSaBMTaZjWLKJhC/ZMi8
         f8E2E1Yo82GSOrHqqL/9T/2trk8ldfp0OvAzru9ofatoVZJ5++/ZkNAT107ZyLhJ9mj7
         0k4W5P7cDjIau9O0gNL76KPh0/FLqIx6PF++TzoEXG/T45kDNT4qJJvCWPG1Qw2neb45
         hEWu3gh2LYGWBwcM0jz5VHLI5ifRaTnzPFxYXtqkvfUPBx2jWnmrSak8mhhkqdXC9Ll1
         pNf4WNzVJIJa2VoHYHYvPp9Jb247Rog/b+/kFo7GwydGDFID/miKyzHVzW666Q6IU7aG
         vHbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hvqHXEXjWYHTPhQcpfchQJxtERd1tvsiHPz9/kGUDP4=;
        b=oKnId7LPx9axGnejhZ9v8+0K20P7ixeUfldDIjrMzfLEtKsN/YP1CWnezK9ApIkdfA
         TifoQK0Kr9WVE7Y1NVi3aETnwqovVBmvrshrldXu13bOAMH8fv2aIGTLd6aZMfHlODSf
         IgFzpcU0Apn7vrr2+G+YJO77MlXK6sBt93z/jHtQ6txlEgBjba2SKUdoxxd5S/aJFXui
         4mRW3dHARGOKjmTaGnhsIomQgsfG0/GLAl/BvlOXDxWNVSVCkDZTzXvopiCS8p7u1ndq
         /flpWtPMQK15Qo11NnxrvXt7jIm5kNbWSULGUv7anGGo+FzugKoRmeY34jeOQBbMITvJ
         MVTA==
X-Gm-Message-State: AO0yUKVZu6i45JRcPx4WoYElFewZ/+VLAf0lkf3eyArsiB6mHl6wesJ2
        PUjCePJVA0ge1q/J0t8yCWblIwW0BKR5
X-Google-Smtp-Source: AK7set/NtWwoOpeBa6Jg5pAf/klctbTD0WEdINlfN4mc5N8KnV+UdUemvQc8UD0hJmQyC7s1euBXbsS2iH9q
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a05:6a00:4208:b0:58e:2111:9c42 with SMTP
 id cd8-20020a056a00420800b0058e21119c42mr1702934pfb.22.1675362514256; Thu, 02
 Feb 2023 10:28:34 -0800 (PST)
Date:   Thu,  2 Feb 2023 18:28:02 +0000
In-Reply-To: <20230202182809.1929122-1-bgardon@google.com>
Mime-Version: 1.0
References: <20230202182809.1929122-1-bgardon@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230202182809.1929122-15-bgardon@google.com>
Subject: [PATCH 14/21] KVM: x86/MMU: Factor Shadow MMU wrprot / clear dirty
 ops out of mmu.c
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
index 9b217e04cab0e..44a00396284d5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -377,23 +377,13 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 				     struct kvm_memory_slot *slot,
 				     gfn_t gfn_offset, unsigned long mask)
 {
-	struct kvm_rmap_head *rmap_head;
-
 	if (tdp_mmu_enabled)
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
@@ -410,23 +400,13 @@ static void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 					 struct kvm_memory_slot *slot,
 					 gfn_t gfn_offset, unsigned long mask)
 {
-	struct kvm_rmap_head *rmap_head;
-
 	if (tdp_mmu_enabled)
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
@@ -484,16 +464,11 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
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
 
 	if (tdp_mmu_enabled)
 		write_protected |=
@@ -2915,8 +2890,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 {
 	if (kvm_memslots_have_rmaps(kvm)) {
 		write_lock(&kvm->mmu_lock);
-		walk_slot_rmaps(kvm, memslot, slot_rmap_write_protect,
-				start_level, KVM_MAX_HUGEPAGE_LEVEL, false);
+		kvm_shadow_mmu_wrprot_slot(kvm, memslot, start_level);
 		write_unlock(&kvm->mmu_lock);
 	}
 
@@ -3067,11 +3041,7 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 {
 	if (kvm_memslots_have_rmaps(kvm)) {
 		write_lock(&kvm->mmu_lock);
-		/*
-		 * Clear dirty bits only on 4k SPTEs since the legacy MMU only
-		 * support dirty logging at a 4k granularity.
-		 */
-		walk_slot_rmaps_4k(kvm, memslot, __rmap_clear_dirty, false);
+		kvm_shadow_mmu_clear_dirty_slot(kvm, memslot);
 		write_unlock(&kvm->mmu_lock);
 	}
 
diff --git a/arch/x86/kvm/mmu/shadow_mmu.c b/arch/x86/kvm/mmu/shadow_mmu.c
index 32a24530cf19a..b93a6174717d3 100644
--- a/arch/x86/kvm/mmu/shadow_mmu.c
+++ b/arch/x86/kvm/mmu/shadow_mmu.c
@@ -3453,3 +3453,67 @@ unsigned long kvm_shadow_mmu_shrink_scan(struct kvm *kvm, int pages_to_free)
 
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
+	walk_slot_rmaps_4k(kvm, memslot, __rmap_clear_dirty, false);
+}
+
+void kvm_shadow_mmu_wrprot_slot(struct kvm *kvm,
+				const struct kvm_memory_slot *memslot,
+				int start_level)
+{
+	walk_slot_rmaps(kvm, memslot, slot_rmap_write_protect,
+			start_level, KVM_MAX_HUGEPAGE_LEVEL, false);
+}
diff --git a/arch/x86/kvm/mmu/shadow_mmu.h b/arch/x86/kvm/mmu/shadow_mmu.h
index 82eed9bb9bc9a..58f48293b4773 100644
--- a/arch/x86/kvm/mmu/shadow_mmu.h
+++ b/arch/x86/kvm/mmu/shadow_mmu.h
@@ -117,6 +117,21 @@ void kvm_shadow_mmu_zap_collapsible_sptes(struct kvm *kvm,
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
2.39.1.519.gcb327c4b5f-goog

