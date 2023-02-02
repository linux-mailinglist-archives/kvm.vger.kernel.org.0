Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AED0C68867F
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 19:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbjBBSae (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 13:30:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232827AbjBBS3x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 13:29:53 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4088979215
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 10:28:56 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id l1-20020a17090270c100b00198be135a14so1296721plt.9
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 10:28:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5z7kzwo6bFhkuATdWJN+pGPJy4Fvw6TYtZKMARZWD4Y=;
        b=Jwl4LCtLIKrw/7ynBH+9YL/WMWqT6AlooFuOZxazMcXaLj1RrSAmieHktrDNixNcRq
         p5sK/BuD90GIPzj+YyWjSfUISO3nKtg3o49YEClAeBNE/U/34GSLVTC/HsUqm/mE0p2y
         DBJ9axV9yeTzNTWFYUQ/3arBLPp8VjZMSBxGhZk7rAUlEqBFFXBQXlrl5kSjQIGFKvMP
         mrhGWST7M1Ei6QNaH6tH8oBeNL/odNyFxAwzEKtmbHyNBogtFLU5EG+Tbbus3rcMY4lv
         OcuaeHkg2EvXvlyC7TaHOOUvDjq2wdnUMd7li9iWRxLLFFxYKaQ6roy341k4aQW/36Ag
         KSYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5z7kzwo6bFhkuATdWJN+pGPJy4Fvw6TYtZKMARZWD4Y=;
        b=fb1LYLKj/ae4DIXbD1vIkISCHT12MTX6uvUDAxdEbq+ZepIWxdiMhCitr1Ear3vXDp
         Jx/waUZQYaeL9Em9dW1VvX8VPyFKW0K215sbJGT3SCYrnme+2VddQ3jn23r5Ou8CPEEp
         /oPoAMNRVYrYroMFQOaxSl9L271smPTph9cR3bwueIy8Yx53/apo45uHQBAUzBj5npLL
         tqA8T7I368lIoRd+ZaPfX6Z/GiXJ9qqZ5uaIt2lAuKftIKd1ZMv+insV8nFpqM5WZHAB
         WVXxyUYwzXrG7SbDd2ieRDGU4WwMdFhlPJYYRonRb4bGdQ+HPEFVFJzVb/md28CzrS5x
         oC2A==
X-Gm-Message-State: AO0yUKXvEVPJZJNWhBVqD/1MpCMn/5dQouS3L9WWbe/dnMa9z3WfvMwo
        XENBNPyhEY3/tEBcmRlragraRMGbCczl
X-Google-Smtp-Source: AK7set8L663E44RkcZEK40xBBSKHCCxNWKcUVyYKO0oPaNoCTycxxUG0cQWh8wBHV3CNc1K1IjDYfaCWbHz/
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:902:7608:b0:196:7555:f810 with SMTP id
 k8-20020a170902760800b001967555f810mr1769024pll.7.1675362517803; Thu, 02 Feb
 2023 10:28:37 -0800 (PST)
Date:   Thu,  2 Feb 2023 18:28:04 +0000
In-Reply-To: <20230202182809.1929122-1-bgardon@google.com>
Mime-Version: 1.0
References: <20230202182809.1929122-1-bgardon@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230202182809.1929122-17-bgardon@google.com>
Subject: [PATCH 16/21] KVM: x86/MMU: Wrap uses of kvm_handle_gfn_range in mmu.c
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

handle_gfn_range + callback is not a bad interface, but it requires
exporting the whole callback scheme to mmu.c. Simplify the interface
with some basic wrapper functions, making the callback scheme internal
to shadow_mmu.c.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c        |  8 +++---
 arch/x86/kvm/mmu/shadow_mmu.c | 54 +++++++++++++++++++++++++----------
 arch/x86/kvm/mmu/shadow_mmu.h | 25 ++++------------
 3 files changed, 48 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 44a00396284d5..156ab2e4cd811 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -490,7 +490,7 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	bool flush = false;
 
 	if (kvm_memslots_have_rmaps(kvm))
-		flush = kvm_handle_gfn_range(kvm, range, kvm_zap_rmap);
+		flush = kvm_shadow_mmu_unmap_gfn_range(kvm, range);
 
 	if (tdp_mmu_enabled)
 		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
@@ -503,7 +503,7 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	bool flush = false;
 
 	if (kvm_memslots_have_rmaps(kvm))
-		flush = kvm_handle_gfn_range(kvm, range, kvm_set_pte_rmap);
+		flush = kvm_shadow_mmu_set_spte_gfn(kvm, range);
 
 	if (tdp_mmu_enabled)
 		flush |= kvm_tdp_mmu_set_spte_gfn(kvm, range);
@@ -516,7 +516,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	bool young = false;
 
 	if (kvm_memslots_have_rmaps(kvm))
-		young = kvm_handle_gfn_range(kvm, range, kvm_age_rmap);
+		young = kvm_shadow_mmu_age_gfn_range(kvm, range);
 
 	if (tdp_mmu_enabled)
 		young |= kvm_tdp_mmu_age_gfn_range(kvm, range);
@@ -529,7 +529,7 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	bool young = false;
 
 	if (kvm_memslots_have_rmaps(kvm))
-		young = kvm_handle_gfn_range(kvm, range, kvm_test_age_rmap);
+		young = kvm_shadow_mmu_test_age_gfn(kvm, range);
 
 	if (tdp_mmu_enabled)
 		young |= kvm_tdp_mmu_test_age_gfn(kvm, range);
diff --git a/arch/x86/kvm/mmu/shadow_mmu.c b/arch/x86/kvm/mmu/shadow_mmu.c
index dc5c4b9899cc6..dfff65db97c3b 100644
--- a/arch/x86/kvm/mmu/shadow_mmu.c
+++ b/arch/x86/kvm/mmu/shadow_mmu.c
@@ -864,16 +864,16 @@ static bool __kvm_zap_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 	return kvm_zap_all_rmap_sptes(kvm, rmap_head);
 }
 
-bool kvm_zap_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-		  struct kvm_memory_slot *slot, gfn_t gfn, int level,
-		  pte_t unused)
+static bool kvm_zap_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
+			 struct kvm_memory_slot *slot, gfn_t gfn, int level,
+			 pte_t unused)
 {
 	return __kvm_zap_rmap(kvm, rmap_head, slot);
 }
 
-bool kvm_set_pte_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-		      struct kvm_memory_slot *slot, gfn_t gfn, int level,
-		      pte_t pte)
+static bool kvm_set_pte_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
+			     struct kvm_memory_slot *slot, gfn_t gfn, int level,
+			     pte_t pte)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
@@ -980,9 +980,13 @@ static void slot_rmap_walk_next(struct slot_rmap_walk_iterator *iterator)
 	     slot_rmap_walk_okay(_iter_);				\
 	     slot_rmap_walk_next(_iter_))
 
-__always_inline bool kvm_handle_gfn_range(struct kvm *kvm,
-					  struct kvm_gfn_range *range,
-					  rmap_handler_t handler)
+typedef bool (*rmap_handler_t)(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
+			       struct kvm_memory_slot *slot, gfn_t gfn,
+			       int level, pte_t pte);
+
+static __always_inline bool
+kvm_handle_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
+		     rmap_handler_t handler)
 {
 	struct slot_rmap_walk_iterator iterator;
 	bool ret = false;
@@ -995,9 +999,9 @@ __always_inline bool kvm_handle_gfn_range(struct kvm *kvm,
 	return ret;
 }
 
-bool kvm_age_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-		  struct kvm_memory_slot *slot, gfn_t gfn, int level,
-		  pte_t unused)
+static bool kvm_age_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
+			 struct kvm_memory_slot *slot, gfn_t gfn, int level,
+			 pte_t unused)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
@@ -1009,9 +1013,9 @@ bool kvm_age_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 	return young;
 }
 
-bool kvm_test_age_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-		       struct kvm_memory_slot *slot, gfn_t gfn,
-		       int level, pte_t unused)
+static bool kvm_test_age_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
+			      struct kvm_memory_slot *slot, gfn_t gfn,
+			      int level, pte_t unused)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
@@ -3523,3 +3527,23 @@ void kvm_shadow_mmu_wrprot_slot(struct kvm *kvm,
 	walk_slot_rmaps(kvm, memslot, slot_rmap_write_protect,
 			start_level, KVM_MAX_HUGEPAGE_LEVEL, false);
 }
+
+bool kvm_shadow_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	return kvm_handle_gfn_range(kvm, range, kvm_zap_rmap);
+}
+
+bool kvm_shadow_mmu_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	return kvm_handle_gfn_range(kvm, range, kvm_set_pte_rmap);
+}
+
+bool kvm_shadow_mmu_age_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	return kvm_handle_gfn_range(kvm, range, kvm_age_rmap);
+}
+
+bool kvm_shadow_mmu_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	return kvm_handle_gfn_range(kvm, range, kvm_test_age_rmap);
+}
diff --git a/arch/x86/kvm/mmu/shadow_mmu.h b/arch/x86/kvm/mmu/shadow_mmu.h
index 36fe8013931d2..e4fbc842f524e 100644
--- a/arch/x86/kvm/mmu/shadow_mmu.h
+++ b/arch/x86/kvm/mmu/shadow_mmu.h
@@ -39,26 +39,6 @@ struct pte_list_desc {
 /* Only exported for debugfs.c. */
 unsigned int pte_list_count(struct kvm_rmap_head *rmap_head);
 
-bool kvm_zap_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-		  struct kvm_memory_slot *slot, gfn_t gfn, int level,
-		  pte_t unused);
-bool kvm_set_pte_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-		      struct kvm_memory_slot *slot, gfn_t gfn, int level,
-		      pte_t pte);
-
-typedef bool (*rmap_handler_t)(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-			       struct kvm_memory_slot *slot, gfn_t gfn,
-			       int level, pte_t pte);
-bool kvm_handle_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
-			  rmap_handler_t handler);
-
-bool kvm_age_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-		  struct kvm_memory_slot *slot, gfn_t gfn, int level,
-		  pte_t unused);
-bool kvm_test_age_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-		       struct kvm_memory_slot *slot, gfn_t gfn,
-		       int level, pte_t unused);
-
 void __clear_sp_write_flooding_count(struct kvm_mmu_page *sp);
 
 bool __kvm_shadow_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
@@ -114,6 +94,11 @@ void kvm_shadow_mmu_wrprot_slot(struct kvm *kvm,
 				const struct kvm_memory_slot *memslot,
 				int start_level);
 
+bool kvm_shadow_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
+bool kvm_shadow_mmu_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
+bool kvm_shadow_mmu_age_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
+bool kvm_shadow_mmu_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
+
 /* Exports from paging_tmpl.h */
 gpa_t paging32_gva_to_gpa(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			  gpa_t vaddr, u64 access,
-- 
2.39.1.519.gcb327c4b5f-goog

