Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99EFA688682
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 19:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232926AbjBBSah (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 13:30:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232836AbjBBS3x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 13:29:53 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA047BBE5
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 10:28:56 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id a27-20020aa78e9b000000b00593f636220cso1361527pfr.11
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 10:28:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hIkQB5ezFR1E5ltI975hig3hYSC7kHPqCc3qy20DN/I=;
        b=Nah7cPJKZohGO4FLqLOCT6KxuTNsfV+DRfD03Pfh3QmDkv+5covs2CWSHe2yIVwXfy
         nzsvQ21unrgkeewgaki5RAYrp+L/N+1is0nm9d2enSCBuIHvCXgDGxzz9HNmPbxn8Dve
         Ry+C8Z0SasVDvtXWpPp+/1ju59GA4D2DoNm0HVzRzymsI9kvfweHQBu3f77CwZ8IKG9x
         xSji2nCTLE5LYWL/t3vN1QZeUARql/yPqoZFaiUjxJ+fI9HQwJhbcuMcQxe3VIjX4xL9
         JJHmZtsIale/8f3UdcBBR1n9edoP1NwTFR4num2+Uw9mrZyvFKNaMm6crnIqltr3EDFG
         7x8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hIkQB5ezFR1E5ltI975hig3hYSC7kHPqCc3qy20DN/I=;
        b=LZ/XOXL8YeGk4i7ltCjXmk8bdcQ34L3FIJx7zq6mPPNKrdxK8F86mH3Sgj5ZmzBKdt
         WbLcQt0gN1n0bA04PsxzNK8Dcp1K6vRFO4NFsMamOsxWyz4CUUp8bVchM9F9KbB+Yz2L
         JRXJsrpPSMVS2LjmCi+zMmNaBbIFrq/hnjXp2Wz+W1SQm/U1UbHboC0H/ux+IxMix8gm
         rPM0FovjpYB0gG2RhIDCgyJzl3FngxJIuCCOprW12qldsRxXFN7o58Bvg5zQV6dZAyWi
         sPGjgm9fzFnyhkddADoTWvkbuTzmc8eYQA86X3yvMTjXO7xB1lbHU2InfWEEZXKIhmmv
         TNbQ==
X-Gm-Message-State: AO0yUKWIY4nyouNM+LiL4o6QTJHXf+t427NJhgakL+qGeUOjkFAmTfnu
        +xkO3axgD9S3zeiNVJ9jEmi0tq8mrE1a
X-Google-Smtp-Source: AK7set9rUxrnwX68NLHOBt9ONbj6he5gP3Iq4Df2SQ0wvJ9q5evj9wM+nC8+0K/V54Fi9dmZ0IzTMHWOFK0U
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:902:f68e:b0:198:d453:68ef with SMTP id
 l14-20020a170902f68e00b00198d45368efmr213738plg.0.1675362521139; Thu, 02 Feb
 2023 10:28:41 -0800 (PST)
Date:   Thu,  2 Feb 2023 18:28:06 +0000
In-Reply-To: <20230202182809.1929122-1-bgardon@google.com>
Mime-Version: 1.0
References: <20230202182809.1929122-1-bgardon@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230202182809.1929122-19-bgardon@google.com>
Subject: [PATCH 18/21] KVM: x86/mmu: Move split cache topup functions to shadow_mmu.c
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

The split cache topup functions are only used by the Shadow MMU and were
left behind in mmu.c when splitting the Shadow MMU out to a separate
file. Move them over as well.

No functional change intended.

Suggested-by: David Matlack <dmatlack@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 53 ---------------------------------
 arch/x86/kvm/mmu/mmu_internal.h |  2 --
 arch/x86/kvm/mmu/shadow_mmu.c   | 53 +++++++++++++++++++++++++++++++++
 3 files changed, 53 insertions(+), 55 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f5b9db00eff99..8514e998e2127 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2902,59 +2902,6 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 	}
 }
 
-static inline bool need_topup(struct kvm_mmu_memory_cache *cache, int min)
-{
-	return kvm_mmu_memory_cache_nr_free_objects(cache) < min;
-}
-
-bool need_topup_split_caches_or_resched(struct kvm *kvm)
-{
-	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
-		return true;
-
-	/*
-	 * In the worst case, SPLIT_DESC_CACHE_MIN_NR_OBJECTS descriptors are needed
-	 * to split a single huge page. Calculating how many are actually needed
-	 * is possible but not worth the complexity.
-	 */
-	return need_topup(&kvm->arch.split_desc_cache, SPLIT_DESC_CACHE_MIN_NR_OBJECTS) ||
-	       need_topup(&kvm->arch.split_page_header_cache, 1) ||
-	       need_topup(&kvm->arch.split_shadow_page_cache, 1);
-}
-
-int topup_split_caches(struct kvm *kvm)
-{
-	/*
-	 * Allocating rmap list entries when splitting huge pages for nested
-	 * MMUs is uncommon as KVM needs to use a list if and only if there is
-	 * more than one rmap entry for a gfn, i.e. requires an L1 gfn to be
-	 * aliased by multiple L2 gfns and/or from multiple nested roots with
-	 * different roles.  Aliasing gfns when using TDP is atypical for VMMs;
-	 * a few gfns are often aliased during boot, e.g. when remapping BIOS,
-	 * but aliasing rarely occurs post-boot or for many gfns.  If there is
-	 * only one rmap entry, rmap->val points directly at that one entry and
-	 * doesn't need to allocate a list.  Buffer the cache by the default
-	 * capacity so that KVM doesn't have to drop mmu_lock to topup if KVM
-	 * encounters an aliased gfn or two.
-	 */
-	const int capacity = SPLIT_DESC_CACHE_MIN_NR_OBJECTS +
-			     KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;
-	int r;
-
-	lockdep_assert_held(&kvm->slots_lock);
-
-	r = __kvm_mmu_topup_memory_cache(&kvm->arch.split_desc_cache, capacity,
-					 SPLIT_DESC_CACHE_MIN_NR_OBJECTS);
-	if (r)
-		return r;
-
-	r = kvm_mmu_topup_memory_cache(&kvm->arch.split_page_header_cache, 1);
-	if (r)
-		return r;
-
-	return kvm_mmu_topup_memory_cache(&kvm->arch.split_shadow_page_cache, 1);
-}
-
 /* Must be called with the mmu_lock held in write-mode. */
 void kvm_mmu_try_split_huge_pages(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot,
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 349d4a300ad34..2273c6263faf0 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -348,8 +348,6 @@ void walk_shadow_page_lockless_begin(struct kvm_vcpu *vcpu);
 void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu);
 
 int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect);
-bool need_topup_split_caches_or_resched(struct kvm *kvm);
-int topup_split_caches(struct kvm *kvm);
 
 bool is_page_fault_stale(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 bool page_fault_handle_page_track(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/mmu/shadow_mmu.c b/arch/x86/kvm/mmu/shadow_mmu.c
index eb4424fedd73a..bb23692d34a73 100644
--- a/arch/x86/kvm/mmu/shadow_mmu.c
+++ b/arch/x86/kvm/mmu/shadow_mmu.c
@@ -3219,6 +3219,59 @@ bool slot_rmap_write_protect(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 	return rmap_write_protect(rmap_head, false);
 }
 
+static inline bool need_topup(struct kvm_mmu_memory_cache *cache, int min)
+{
+	return kvm_mmu_memory_cache_nr_free_objects(cache) < min;
+}
+
+static bool need_topup_split_caches_or_resched(struct kvm *kvm)
+{
+	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
+		return true;
+
+	/*
+	 * In the worst case, SPLIT_DESC_CACHE_MIN_NR_OBJECTS descriptors are needed
+	 * to split a single huge page. Calculating how many are actually needed
+	 * is possible but not worth the complexity.
+	 */
+	return need_topup(&kvm->arch.split_desc_cache, SPLIT_DESC_CACHE_MIN_NR_OBJECTS) ||
+	       need_topup(&kvm->arch.split_page_header_cache, 1) ||
+	       need_topup(&kvm->arch.split_shadow_page_cache, 1);
+}
+
+static int topup_split_caches(struct kvm *kvm)
+{
+	/*
+	 * Allocating rmap list entries when splitting huge pages for nested
+	 * MMUs is uncommon as KVM needs to use a list if and only if there is
+	 * more than one rmap entry for a gfn, i.e. requires an L1 gfn to be
+	 * aliased by multiple L2 gfns and/or from multiple nested roots with
+	 * different roles.  Aliasing gfns when using TDP is atypical for VMMs;
+	 * a few gfns are often aliased during boot, e.g. when remapping BIOS,
+	 * but aliasing rarely occurs post-boot or for many gfns.  If there is
+	 * only one rmap entry, rmap->val points directly at that one entry and
+	 * doesn't need to allocate a list.  Buffer the cache by the default
+	 * capacity so that KVM doesn't have to drop mmu_lock to topup if KVM
+	 * encounters an aliased gfn or two.
+	 */
+	const int capacity = SPLIT_DESC_CACHE_MIN_NR_OBJECTS +
+			     KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;
+	int r;
+
+	lockdep_assert_held(&kvm->slots_lock);
+
+	r = __kvm_mmu_topup_memory_cache(&kvm->arch.split_desc_cache, capacity,
+					 SPLIT_DESC_CACHE_MIN_NR_OBJECTS);
+	if (r)
+		return r;
+
+	r = kvm_mmu_topup_memory_cache(&kvm->arch.split_page_header_cache, 1);
+	if (r)
+		return r;
+
+	return kvm_mmu_topup_memory_cache(&kvm->arch.split_shadow_page_cache, 1);
+}
+
 static struct kvm_mmu_page *shadow_mmu_get_sp_for_split(struct kvm *kvm, u64 *huge_sptep)
 {
 	struct kvm_mmu_page *huge_sp = sptep_to_sp(huge_sptep);
-- 
2.39.1.519.gcb327c4b5f-goog

