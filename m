Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE924E3301
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 23:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiCUWtN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 18:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiCUWtD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 18:49:03 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F5555BF8
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 15:44:25 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id 16-20020a621910000000b004f783aad863so10406261pfz.15
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 15:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uCzuyzAeivg9rQW1tF47OPLIGzwSsZl5WKJom2K5UFo=;
        b=FUDtiOGTljaKLXmMd+WjpcA4qQiPozroTXy+12tMQNQeBynzAQlWEhBHea7Z6YUYfy
         F6eoo8Wzhk4F4yw6xXKagVR79ivkLNhDaiLZnHQWF9iPRGa9diKwHaC5r+1EhDOuMZNo
         RRgL5eMAaL+ppbPzfxwlRn/mxprXf4AQzvdEWN9a8jCSO/WjVhzouewDi3fjh0sWsaO3
         eGVdUvyYiwMeHANsAT1Od8JsF5htVoijWzAVuj8jyzvihrQ4B6TOEaszsYSxWMDnpcNS
         IJCkwTNkwjA5RV0fEKq9rSwQgYZ/U2GKk0XSm5eCcXmsroJKk8hhhO+XonzxBtVS9kIh
         Wlvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uCzuyzAeivg9rQW1tF47OPLIGzwSsZl5WKJom2K5UFo=;
        b=27HnescDWPdVImzNwLAjuc6IpfG/wH3GGBVOiVXdrRZ7wDyzkz3dv1F6ezAk7h0Ly4
         KG9X0lrBHs1htno5ntnDpGbIGrcUykzFHeIssjTdsCbCcJDjaTfeJihrgYXn6Ywfmkzw
         mISsk4q/dg6fk05wwoI01d+rcyXuHlm1CwGyTQoGnesaQIoLueOnojbIek1SOMM/PoWP
         ByqUMOMwTWbZynTEzO4JuFDEIOQkhAyU7cU71UrzpZzE/P7I74RIVEomyCFW6b2DJbxD
         4+V0BJvBAckzH9bOcXouXjBDLYWkxpmbTXVIPjwrKF5GRjh0MGuHd3VLQXVk4CD2ZmCW
         0NaQ==
X-Gm-Message-State: AOAM532LHbSZ97OcgJZSF3M8YW3+a3tx1Aq4Uzf6vSZyTGWKthJw7tN5
        NLt7pA3PciI/k4Pai//C4HHXYCxViBZO
X-Google-Smtp-Source: ABdhPJzuK9aAeqw10fWLswjFrzy+1wQuny8/nM8UoMiivEPlbzYZ/OsJI1KZlbWt71dulve1DsCnOzXFmJ/A
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:b76a:f152:cb5e:5cd2])
 (user=bgardon job=sendgmr) by 2002:a17:90b:e81:b0:1c6:5a9c:5afa with SMTP id
 fv1-20020a17090b0e8100b001c65a9c5afamr188347pjb.1.1647902664757; Mon, 21 Mar
 2022 15:44:24 -0700 (PDT)
Date:   Mon, 21 Mar 2022 15:43:58 -0700
In-Reply-To: <20220321224358.1305530-1-bgardon@google.com>
Message-Id: <20220321224358.1305530-10-bgardon@google.com>
Mime-Version: 1.0
References: <20220321224358.1305530-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 9/9] KVM: x86/mmu: Promote pages in-place when disabling
 dirty logging
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When disabling dirty logging, the TDP MMU currently zaps each leaf entry
mapping memory in the relevant memslot. This is very slow. Doing the zaps
under the mmu read lock requires a TLB flush for every zap and the
zapping causes a storm of ETP/NPT violations.

Instead of zapping, replace the split large pages with large page
mappings directly. While this sort of operation has historically only
been done in the vCPU page fault handler context, refactorings earlier
in this series and the relative simplicity of the TDP MMU make it
possible here as well.

Running the dirty_log_perf_test on an Intel Skylake with 96 vCPUs and 1G
of memory per vCPU, this reduces the time required to disable dirty
logging from over 45 seconds to just over 1 second. It also avoids
provoking page faults, improving vCPU performance while disabling
dirty logging.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c          |  4 +-
 arch/x86/kvm/mmu/mmu_internal.h |  6 +++
 arch/x86/kvm/mmu/tdp_mmu.c      | 73 ++++++++++++++++++++++++++++++++-
 3 files changed, 79 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6f98111f8f8b..a99c23ef90b6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -100,7 +100,7 @@ module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
  */
 bool tdp_enabled = false;
 
-static int max_huge_page_level __read_mostly;
+int max_huge_page_level;
 static int tdp_root_level __read_mostly;
 static int max_tdp_level __read_mostly;
 
@@ -4486,7 +4486,7 @@ static inline bool boot_cpu_is_amd(void)
  * the direct page table on host, use as much mmu features as
  * possible, however, kvm currently does not do execution-protection.
  */
-static void
+void
 build_tdp_shadow_zero_bits_mask(struct rsvd_bits_validate *shadow_zero_check,
 				int shadow_root_level)
 {
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 1bff453f7cbe..6c08a5731fcb 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -171,4 +171,10 @@ void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
+void
+build_tdp_shadow_zero_bits_mask(struct rsvd_bits_validate *shadow_zero_check,
+				int shadow_root_level);
+
+extern int max_huge_page_level __read_mostly;
+
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index af60922906ef..eb8929e394ec 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1709,6 +1709,66 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 		clear_dirty_pt_masked(kvm, root, gfn, mask, wrprot);
 }
 
+static bool try_promote_lpage(struct kvm *kvm,
+			      const struct kvm_memory_slot *slot,
+			      struct tdp_iter *iter)
+{
+	struct kvm_mmu_page *sp = sptep_to_sp(iter->sptep);
+	struct rsvd_bits_validate shadow_zero_check;
+	bool map_writable;
+	kvm_pfn_t pfn;
+	u64 new_spte;
+	u64 mt_mask;
+
+	/*
+	 * If addresses are being invalidated, don't do in-place promotion to
+	 * avoid accidentally mapping an invalidated address.
+	 */
+	if (unlikely(kvm->mmu_notifier_count))
+		return false;
+
+	if (iter->level > max_huge_page_level || iter->gfn < slot->base_gfn ||
+	    iter->gfn >= slot->base_gfn + slot->npages)
+		return false;
+
+	pfn = __gfn_to_pfn_memslot(slot, iter->gfn, true, NULL, true,
+				   &map_writable, NULL);
+	if (is_error_noslot_pfn(pfn))
+		return false;
+
+	/*
+	 * Can't reconstitute an lpage if the consituent pages can't be
+	 * mapped higher.
+	 */
+	if (iter->level > kvm_mmu_max_mapping_level(kvm, slot, iter->gfn,
+						    pfn, PG_LEVEL_NUM))
+		return false;
+
+	build_tdp_shadow_zero_bits_mask(&shadow_zero_check, iter->root_level);
+
+	/*
+	 * In some cases, a vCPU pointer is required to get the MT mask,
+	 * however in most cases it can be generated without one. If a
+	 * vCPU pointer is needed kvm_x86_try_get_mt_mask will fail.
+	 * In that case, bail on in-place promotion.
+	 */
+	if (unlikely(!static_call(kvm_x86_try_get_mt_mask)(kvm, iter->gfn,
+							   kvm_is_mmio_pfn(pfn),
+							   &mt_mask)))
+		return false;
+
+	__make_spte(kvm, sp, slot, ACC_ALL, iter->gfn, pfn, 0, false, true,
+		  map_writable, mt_mask, &shadow_zero_check, &new_spte);
+
+	if (tdp_mmu_set_spte_atomic(kvm, iter, new_spte))
+		return true;
+
+	/* Re-read the SPTE as it must have been changed by another thread. */
+	iter->old_spte = READ_ONCE(*rcu_dereference(iter->sptep));
+
+	return false;
+}
+
 /*
  * Clear leaf entries which could be replaced by large mappings, for
  * GFNs within the slot.
@@ -1729,8 +1789,17 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
 
-		if (!is_shadow_present_pte(iter.old_spte) ||
-		    !is_last_spte(iter.old_spte, iter.level))
+		if (iter.level > max_huge_page_level ||
+		    iter.gfn < slot->base_gfn ||
+		    iter.gfn >= slot->base_gfn + slot->npages)
+			continue;
+
+		if (!is_shadow_present_pte(iter.old_spte))
+			continue;
+
+		/* Try to promote the constitutent pages to an lpage. */
+		if (!is_last_spte(iter.old_spte, iter.level) &&
+		    try_promote_lpage(kvm, slot, &iter))
 			continue;
 
 		pfn = spte_to_pfn(iter.old_spte);
-- 
2.35.1.894.gb6a874cedc-goog

