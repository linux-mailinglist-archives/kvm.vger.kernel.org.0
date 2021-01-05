Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C962EB648
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 00:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbhAEXc2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 18:32:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727260AbhAEXcZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 18:32:25 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC368C06179A
        for <kvm@vger.kernel.org>; Tue,  5 Jan 2021 15:31:44 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id d187so1711978ybc.6
        for <kvm@vger.kernel.org>; Tue, 05 Jan 2021 15:31:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=yobAeCu9/CRaXkHztpEWt3T9SErbOcVCTVp7Taw/teg=;
        b=cotQWsaTZX+jEnA0InHChyabxaJcwvlomvHc+t1xyAQpFN/IzbqCnOE09XLB6oywJ2
         0Zva107ckeIsSzW1JWeN/dbCGs/L8J5bJt6T5Z3UcQiohXQv1Muvxxewl6KAW0DZD/FP
         5JE5cQpHxtLVZxIk2aHNfAHwa5QVgOFpYEmlSuWDMlK1bZCOP4klg9zlA3iI7mrkPzFe
         LqZHSQxKHG6+7vkDQ17S9tuaE5huJJkRKxvQ26VsSSEN/7IGRXWZq5wBnC/g64m3wxwa
         FPMQC+LIAq9IGUv2+Fs7FlpnVcbjOvujXz4zH5KSnFVz1iX/8IIxxC9J0qrDeYYPt1Ij
         RVdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=yobAeCu9/CRaXkHztpEWt3T9SErbOcVCTVp7Taw/teg=;
        b=dWzoNXzy1Q/9mlm2riEFSDiI2yVYwZ9VibBR1aluDdgdUkX4wZ8kEOFYChxiuLJ46n
         yqI/5f4RspCvPGNhRk6fk07V/lvpO2mk5dhRCMAX94eChIQUZfEr1Vl8uQcm42XS2963
         6E7krh1dr47rEOOXh8JhkLsJDzjskc7TGbRZVFSev3JeMiD2gQ9HPX9x/+aJ+brHMQfs
         zGW+X7ZXlqAyrc0UW+WGid27Exk/8k+bhVnVcmXJcgkODvZp2I0uQq+OpsMKYeFlk48w
         Vt24lAgSdfztCn7Q/2RsGcEy6b6xLFHVtV5O3DVgnBSJsbvcWYi9G4c4RlLOJA1RdTE9
         vrZA==
X-Gm-Message-State: AOAM532aCFePa/51t8EkuxvHwb01Ip22Q5WC7T3jsPKFqmtDKUTKw//I
        6hsFbZS4ql+zk5we2w9Emd9FHYQbaKWL
X-Google-Smtp-Source: ABdhPJyaQfETm9KfrxqQjPNIrSDFs9roAaP3NZN+uJeBKTPHCNqy4vd0T4gXoZMb6aDA8WNKjxRAD/vgjMvF
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a25:938a:: with SMTP id
 a10mr2386436ybm.49.1609889504006; Tue, 05 Jan 2021 15:31:44 -0800 (PST)
Date:   Tue,  5 Jan 2021 15:31:36 -0800
In-Reply-To: <20210105233136.2140335-1-bgardon@google.com>
Message-Id: <20210105233136.2140335-3-bgardon@google.com>
Mime-Version: 1.0
References: <20210105233136.2140335-1-bgardon@google.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH 3/3] kvm: x86/mmu: Get/put TDP MMU root refs in iterator
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Leo Hou <leohou1402@gmail.com>, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To simplify acquiring and releasing references on TDP MMU root pages,
move the get/put operations into the TDP MMU root iterator macro. Not
all functions which use the macro currently get and put a reference to
the root, but adding this behavior is harmless.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 100 +++++++++++++++----------------------
 1 file changed, 41 insertions(+), 59 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 5ec6fae36e33..fc69216839c6 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -44,8 +44,41 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
 }
 
-#define for_each_tdp_mmu_root(_kvm, _root)			    \
-	list_for_each_entry(_root, &_kvm->arch.tdp_mmu_roots, link)
+static void tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
+{
+	if (kvm_mmu_put_root(kvm, root))
+		kvm_tdp_mmu_free_root(kvm, root);
+}
+
+static inline bool tdp_mmu_next_root_valid(struct kvm *kvm,
+					   struct kvm_mmu_page *root)
+{
+	if (list_entry_is_head(root, &kvm->arch.tdp_mmu_roots, link))
+		return false;
+
+	kvm_mmu_get_root(kvm, root);
+	return true;
+
+}
+
+static inline struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
+						     struct kvm_mmu_page *root)
+{
+	tdp_mmu_put_root(kvm, root);
+	return list_next_entry(root, link);
+}
+
+/*
+ * Note: this iterator gets and puts references to the roots it iterates over.
+ * This makes it safe to release the MMU lock and yield within the loop, but
+ * if exiting the loop early, the caller must drop the reference to the most
+ * recent root. (Unless keeping a live reference is desirable.)
+ */
+#define for_each_tdp_mmu_root(_kvm, _root)				\
+	for (_root = list_first_entry(&_kvm->arch.tdp_mmu_roots,	\
+				      typeof(*_root), link);		\
+	     tdp_mmu_next_root_valid(_kvm, _root);			\
+	     _root = tdp_mmu_next_root(_kvm, _root))
 
 bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
 {
@@ -83,12 +116,6 @@ void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
 	kmem_cache_free(mmu_page_header_cache, root);
 }
 
-static void tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
-{
-	if (kvm_mmu_put_root(kvm, root))
-		kvm_tdp_mmu_free_root(kvm, root);
-}
-
 static union kvm_mmu_page_role page_role_for_level(struct kvm_vcpu *vcpu,
 						   int level)
 {
@@ -134,7 +161,11 @@ static struct kvm_mmu_page *get_tdp_mmu_vcpu_root(struct kvm_vcpu *vcpu)
 	/* Check for an existing root before allocating a new one. */
 	for_each_tdp_mmu_root(kvm, root) {
 		if (root->role.word == role.word) {
-			kvm_mmu_get_root(kvm, root);
+			/*
+			 * The iterator already acquired a reference to this
+			 * root, so simply return early without dropping the
+			 * reference.
+			 */
 			spin_unlock(&kvm->mmu_lock);
 			return root;
 		}
@@ -453,18 +484,9 @@ bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end)
 	struct kvm_mmu_page *root;
 	bool flush = false;
 
-	for_each_tdp_mmu_root(kvm, root) {
-		/*
-		 * Take a reference on the root so that it cannot be freed if
-		 * this thread releases the MMU lock and yields in this loop.
-		 */
-		kvm_mmu_get_root(kvm, root);
-
+	for_each_tdp_mmu_root(kvm, root)
 		flush |= zap_gfn_range(kvm, root, start, end, true);
 
-		tdp_mmu_put_root(kvm, root);
-	}
-
 	return flush;
 }
 
@@ -626,12 +648,6 @@ static int kvm_tdp_mmu_handle_hva_range(struct kvm *kvm, unsigned long start,
 	int as_id;
 
 	for_each_tdp_mmu_root(kvm, root) {
-		/*
-		 * Take a reference on the root so that it cannot be freed if
-		 * this thread releases the MMU lock and yields in this loop.
-		 */
-		kvm_mmu_get_root(kvm, root);
-
 		as_id = kvm_mmu_page_as_id(root);
 		slots = __kvm_memslots(kvm, as_id);
 		kvm_for_each_memslot(memslot, slots) {
@@ -653,8 +669,6 @@ static int kvm_tdp_mmu_handle_hva_range(struct kvm *kvm, unsigned long start,
 			ret |= handler(kvm, memslot, root, gfn_start,
 				       gfn_end, data);
 		}
-
-		tdp_mmu_put_root(kvm, root);
 	}
 
 	return ret;
@@ -849,16 +863,8 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
 		if (root_as_id != slot->as_id)
 			continue;
 
-		/*
-		 * Take a reference on the root so that it cannot be freed if
-		 * this thread releases the MMU lock and yields in this loop.
-		 */
-		kvm_mmu_get_root(kvm, root);
-
 		spte_set |= wrprot_gfn_range(kvm, root, slot->base_gfn,
 			     slot->base_gfn + slot->npages, min_level);
-
-		tdp_mmu_put_root(kvm, root);
 	}
 
 	return spte_set;
@@ -917,16 +923,8 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
 		if (root_as_id != slot->as_id)
 			continue;
 
-		/*
-		 * Take a reference on the root so that it cannot be freed if
-		 * this thread releases the MMU lock and yields in this loop.
-		 */
-		kvm_mmu_get_root(kvm, root);
-
 		spte_set |= clear_dirty_gfn_range(kvm, root, slot->base_gfn,
 				slot->base_gfn + slot->npages);
-
-		tdp_mmu_put_root(kvm, root);
 	}
 
 	return spte_set;
@@ -1040,16 +1038,8 @@ bool kvm_tdp_mmu_slot_set_dirty(struct kvm *kvm, struct kvm_memory_slot *slot)
 		if (root_as_id != slot->as_id)
 			continue;
 
-		/*
-		 * Take a reference on the root so that it cannot be freed if
-		 * this thread releases the MMU lock and yields in this loop.
-		 */
-		kvm_mmu_get_root(kvm, root);
-
 		spte_set |= set_dirty_gfn_range(kvm, root, slot->base_gfn,
 				slot->base_gfn + slot->npages);
-
-		tdp_mmu_put_root(kvm, root);
 	}
 	return spte_set;
 }
@@ -1100,16 +1090,8 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 		if (root_as_id != slot->as_id)
 			continue;
 
-		/*
-		 * Take a reference on the root so that it cannot be freed if
-		 * this thread releases the MMU lock and yields in this loop.
-		 */
-		kvm_mmu_get_root(kvm, root);
-
 		zap_collapsible_spte_range(kvm, root, slot->base_gfn,
 					   slot->base_gfn + slot->npages);
-
-		tdp_mmu_put_root(kvm, root);
 	}
 }
 
-- 
2.29.2.729.g45daf8777d-goog

