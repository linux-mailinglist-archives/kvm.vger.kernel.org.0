Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF3D364AE38
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 04:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234284AbiLMDa4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 22:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234144AbiLMDax (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 22:30:53 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086851C412
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 19:30:42 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id l10-20020a170902f68a00b00189d1728848so11977930plg.2
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 19:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fGXZEHyqBBNocJxYYVo3uHcPnlIM/Akr56NebVZoj5U=;
        b=JfKNgB4TUBplhFHUAMfehRbe93HY5CVbJ6zjVogM3HDrERmm2XLfsW4IArihP7/yzm
         MPPL7MSClc1DfYygfZDbfH66WzrYwqvOvMS6fQ4Sc3JvdX+TDhRC6vsRjcUf6vS/fHqd
         On1T0IaHnMhYHhBer7cf8XEaeDK5w+1iZ+0+8TSPDwRohpjshU4tyeS2PmWvNAR6QRZl
         TIP+tN5G7RaIYP/9Omyet0xvZNz3HkOB/ncBNtIfXyPugSWUzFbE1pBAY64Xs1BksA9S
         bFfvU/VqjO3tN/pg3XjD+JIhxkM9aSasRY8lUKbPY+Ul0YE7nHlP08eX4dqe99z0m97U
         vU1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fGXZEHyqBBNocJxYYVo3uHcPnlIM/Akr56NebVZoj5U=;
        b=tZ00F2RUzvzNONoFNJ/hdUb9aSSey31ogBfKB16kuES3J5i+iz1glSFQ3xVpqDok/D
         F0VdhQNTMcxEC5HgLCTkjAlPQ7CC9jrzeKM+L90TI8cUB3nItd1LIgIfVIvi1ZPYkk9u
         numehvjmVcuGQSn5W5Ddhv+5sSF8aOUh5SylyXAyGCKVO7GzNvkOWN0hcpn4qDmH+yXY
         oPJprPaW4VXXetQf3/V2mB6wB7JQG+x1ehUzgyoveMejvEbrLWVsPIO95C3iOPcbrbf5
         RiD6V7bkf7b7wH8LcLanuChquCNTFvBUQynAAu+DCieuTJJxuxX6toTC0ageiHN2It1S
         QW0w==
X-Gm-Message-State: ANoB5pmErOEix35nmXkrUVWVrfPUvqTJTa07JaNv/LfFbAFNFapOsL80
        a5mK4gRkHBCPtp2iSoV24UiNzthBleE=
X-Google-Smtp-Source: AA0mqf7pUsjsgNZJaTxLh85HUsz3I7RgYo9dSo+MRtP7KfwoiFjNrOcRuu008onG+jiSu1SYc2xzYHOMXss=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d711:b0:188:c7b2:2dd with SMTP id
 w17-20020a170902d71100b00188c7b202ddmr79943918ply.88.1670902241759; Mon, 12
 Dec 2022 19:30:41 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Dec 2022 03:30:30 +0000
In-Reply-To: <20221213033030.83345-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221213033030.83345-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213033030.83345-6-seanjc@google.com>
Subject: [PATCH 5/5] KVM: x86/mmu: Move kvm_tdp_mmu_map()'s prolog and epilog
 to its caller
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Hoo <robert.hu@linux.intel.com>,
        Greg Thelen <gthelen@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
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

Move the hugepage adjust, tracepoint, and RCU (un)lock logic out of
kvm_tdp_mmu_map() and into its sole caller, kvm_tdp_mmu_page_fault(), to
eliminate the gotos used to bounce through rcu_read_unlock() when bailing
from the walk.

Opportunistically mark kvm_mmu_hugepage_adjust() as static as
kvm_tdp_mmu_map() was the only external user.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          |  9 ++++++++-
 arch/x86/kvm/mmu/mmu_internal.h |  1 -
 arch/x86/kvm/mmu/tdp_mmu.c      | 22 ++++------------------
 3 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 254bc46234e0..99c40617d325 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3085,7 +3085,8 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
 	return min(host_level, max_level);
 }
 
-void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+static void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu,
+				    struct kvm_page_fault *fault)
 {
 	struct kvm_memory_slot *slot = fault->slot;
 	kvm_pfn_t mask;
@@ -4405,7 +4406,13 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
 	if (is_page_fault_stale(vcpu, fault))
 		goto out_unlock;
 
+	kvm_mmu_hugepage_adjust(vcpu, fault);
+
+	trace_kvm_mmu_spte_requested(fault);
+
+	rcu_read_lock();
 	r = kvm_tdp_mmu_map(vcpu, fault);
+	rcu_read_unlock();
 
 out_unlock:
 	read_unlock(&vcpu->kvm->mmu_lock);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index ac00bfbf32f6..66c294d67641 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -317,7 +317,6 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 int kvm_mmu_max_mapping_level(struct kvm *kvm,
 			      const struct kvm_memory_slot *slot, gfn_t gfn,
 			      int max_level);
-void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_level);
 
 void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index cc1fb9a65620..78f47eb74544 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1150,13 +1150,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	struct kvm *kvm = vcpu->kvm;
 	struct tdp_iter iter;
 	struct kvm_mmu_page *sp;
-	int ret = RET_PF_RETRY;
-
-	kvm_mmu_hugepage_adjust(vcpu, fault);
-
-	trace_kvm_mmu_spte_requested(fault);
-
-	rcu_read_lock();
 
 	tdp_mmu_for_each_pte(iter, mmu, fault->gfn, fault->gfn + 1) {
 		int r;
@@ -1169,10 +1162,10 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 * retry, avoiding unnecessary page table allocation and free.
 		 */
 		if (is_removed_spte(iter.old_spte))
-			goto retry;
+			return RET_PF_RETRY;
 
 		if (iter.level == fault->goal_level)
-			goto map_target_level;
+			return tdp_mmu_map_handle_target_level(vcpu, fault, &iter);
 
 		/* Step down into the lower level page table if it exists. */
 		if (is_shadow_present_pte(iter.old_spte) &&
@@ -1199,7 +1192,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 */
 		if (r) {
 			tdp_mmu_free_sp(sp);
-			goto retry;
+			return RET_PF_RETRY;
 		}
 
 		if (fault->huge_page_disallowed &&
@@ -1216,14 +1209,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	 * iterator detected an upper level SPTE was frozen during traversal.
 	 */
 	WARN_ON_ONCE(iter.level == fault->goal_level);
-	goto retry;
-
-map_target_level:
-	ret = tdp_mmu_map_handle_target_level(vcpu, fault, &iter);
-
-retry:
-	rcu_read_unlock();
-	return ret;
+	return RET_PF_RETRY;
 }
 
 bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
-- 
2.39.0.rc1.256.g54fd8350bd-goog

