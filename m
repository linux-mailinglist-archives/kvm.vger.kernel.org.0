Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5394D4F97
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 17:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240521AbiCJQs0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 11:48:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244053AbiCJQr2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 11:47:28 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5C2197B5F
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 08:46:11 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id i7-20020a170902cf0700b0015163eb319eso2960373plg.18
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 08:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=QUlArJveCRgrV8yQIechzTfu/4iHpeBxIkK2uo+sZuA=;
        b=LnOeHbKi0cb+Q3VGsrUfjLvwZt9hNNVe3BYX7LnL3PXDAKopUVn2ntP7bztEjzlvMN
         /DqhECIU4G/aJ0fkpTz1aVwF4oNbO47Q2i02K+o3m9n0N+/xc8rkYV7yqYZFaSr1XGw5
         H8ZFMdchzFyir7AyO0/5ybRuZyV+nE4C0IY1rX4dRfbXfRO0fvH2YwwGHLYYYw3WVDzg
         GsA2pMe4pGD9lTskpj9HhFFvUsQCaLnTobWShglV+Qie0wjwgiEpXCpwkqdYSuPH+eFL
         2RfM3sXE17QNFEhKdLyZ8+7A2xFH+BD/hoxGIifu0BWy/OiKnUEnEz8b6qTb1B94tuFm
         pgzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QUlArJveCRgrV8yQIechzTfu/4iHpeBxIkK2uo+sZuA=;
        b=44eGpybti/QfLuJJqnZS83FNGofBHdomZawgYkY3X5ot1ReUOrz3CoBO5l2S9bM1hr
         FT38mb7UOrTApJ1skTxsVi7z9FWZO5t59WkPmSOx4ycAXkM7SzyiYOM3w+8+eduq0Tdg
         3naCvCLNAeU7ovGvOhNRZzV5mE2A3XGbAoptFPO46Tk5wZrNP08a0vy/J+9qzjsc9CKm
         tChLlpvZ1aUNMJ+SKmr+RGapYX40Nrr/SmrO9JFkjABbsqqXj821OViAQPqlvVuYUs+9
         wwUNWQPybJhHEvQPHRHKWNGVLA8OHw4eFjHMdas4H4GKXaTyuKZ3KMlx4oblOy7oI0bL
         Arsw==
X-Gm-Message-State: AOAM532xHQJsakWcpzGUNdcRtCcRHHa+BACMHeHiK0sKFqK0ZOrvthET
        wZab+qneyK538MizEcV3R9Ba0c47sQr4
X-Google-Smtp-Source: ABdhPJya/MbhjU7kkc4U4AzUZqb+wY7M98VWg+zaBj67qP3YcZqCOUfiRO7bFu/IGapzwCP0yufBJPO6cmsF
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:2d58:733f:1853:8e86])
 (user=bgardon job=sendgmr) by 2002:a17:903:1d1:b0:151:9e73:61b1 with SMTP id
 e17-20020a17090301d100b001519e7361b1mr5839088plh.84.1646930771200; Thu, 10
 Mar 2022 08:46:11 -0800 (PST)
Date:   Thu, 10 Mar 2022 08:45:28 -0800
In-Reply-To: <20220310164532.1821490-1-bgardon@google.com>
Message-Id: <20220310164532.1821490-10-bgardon@google.com>
Mime-Version: 1.0
References: <20220310164532.1821490-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH 09/13] KVM: x86/MMU: Track NX hugepages on a per-VM basis
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

Track whether NX hugepages are enabled on a per-VM basis instead of as a
host-wide setting. With this commit, the per-VM state will always be the
same as the host-wide setting, but in future commits, it will be allowed
to differ.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/mmu.h              | 8 ++++----
 arch/x86/kvm/mmu/mmu.c          | 7 +++++--
 arch/x86/kvm/mmu/spte.c         | 7 ++++---
 arch/x86/kvm/mmu/spte.h         | 3 ++-
 arch/x86/kvm/mmu/tdp_mmu.c      | 3 ++-
 6 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f72e80178ffc..0a0c54639dd8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1240,6 +1240,8 @@ struct kvm_arch {
 	hpa_t	hv_root_tdp;
 	spinlock_t hv_root_tdp_lock;
 #endif
+
+	bool nx_huge_pages;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index bf8dbc4bb12a..dd28fe8d13ae 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -173,9 +173,9 @@ struct kvm_page_fault {
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 
 extern int nx_huge_pages;
-static inline bool is_nx_huge_page_enabled(void)
+static inline bool is_nx_huge_page_enabled(struct kvm *kvm)
 {
-	return READ_ONCE(nx_huge_pages);
+	return READ_ONCE(kvm->arch.nx_huge_pages);
 }
 
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
@@ -191,8 +191,8 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		.user = err & PFERR_USER_MASK,
 		.prefetch = prefetch,
 		.is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault),
-		.nx_huge_page_workaround_enabled = is_nx_huge_page_enabled(),
-
+		.nx_huge_page_workaround_enabled =
+			is_nx_huge_page_enabled(vcpu->kvm),
 		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
 		.req_level = PG_LEVEL_4K,
 		.goal_level = PG_LEVEL_4K,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1b59b56642f1..dc9672f70468 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6195,8 +6195,10 @@ static void __set_nx_huge_pages(bool val)
 	nx_huge_pages = itlb_multihit_kvm_mitigation = val;
 }
 
-static int kvm_update_nx_huge_pages(struct kvm *kvm)
+static void kvm_update_nx_huge_pages(struct kvm *kvm)
 {
+	kvm->arch.nx_huge_pages = nx_huge_pages;
+
 	mutex_lock(&kvm->slots_lock);
 	kvm_mmu_zap_all_fast(kvm);
 	mutex_unlock(&kvm->slots_lock);
@@ -6227,7 +6229,7 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
 		mutex_lock(&kvm_lock);
 
 		list_for_each_entry(kvm, &vm_list, vm_list)
-			kvm_set_nx_huge_pages(kvm);
+			kvm_update_nx_huge_pages(kvm);
 		mutex_unlock(&kvm_lock);
 	}
 
@@ -6448,6 +6450,7 @@ int kvm_mmu_post_init_vm(struct kvm *kvm)
 {
 	int err;
 
+	kvm->arch.nx_huge_pages = READ_ONCE(nx_huge_pages);
 	err = kvm_vm_create_worker_thread(kvm, kvm_nx_lpage_recovery_worker, 0,
 					  "kvm-nx-lpage-recovery",
 					  &kvm->arch.nx_lpage_recovery_thread);
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 4739b53c9734..877ad30bc7ad 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -116,7 +116,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		spte |= spte_shadow_accessed_mask(spte);
 
 	if (level > PG_LEVEL_4K && (pte_access & ACC_EXEC_MASK) &&
-	    is_nx_huge_page_enabled()) {
+	    is_nx_huge_page_enabled(vcpu->kvm)) {
 		pte_access &= ~ACC_EXEC_MASK;
 	}
 
@@ -215,7 +215,8 @@ static u64 make_spte_executable(u64 spte)
  * This is used during huge page splitting to build the SPTEs that make up the
  * new page table.
  */
-u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
+u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte, int huge_level,
+			      int index)
 {
 	u64 child_spte;
 	int child_level;
@@ -243,7 +244,7 @@ u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
 		 * When splitting to a 4K page, mark the page executable as the
 		 * NX hugepage mitigation no longer applies.
 		 */
-		if (is_nx_huge_page_enabled())
+		if (is_nx_huge_page_enabled(kvm))
 			child_spte = make_spte_executable(child_spte);
 	}
 
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 73f12615416f..e4142caff4b1 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -415,7 +415,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
 	       u64 old_spte, bool prefetch, bool can_unsync,
 	       bool host_writable, u64 *new_spte);
-u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index);
+u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte, int huge_level,
+			      int index);
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
 u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
 u64 mark_spte_for_access_track(u64 spte);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index af60922906ef..98a45a87f0b2 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1466,7 +1466,8 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	 * not been linked in yet and thus is not reachable from any other CPU.
 	 */
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++)
-		sp->spt[i] = make_huge_page_split_spte(huge_spte, level, i);
+		sp->spt[i] = make_huge_page_split_spte(kvm, huge_spte,
+						       level, i);
 
 	/*
 	 * Replace the huge spte with a pointer to the populated lower level
-- 
2.35.1.616.g0bdcbb4464-goog

