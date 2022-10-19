Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1935B604DE5
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 18:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbiJSQ42 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 12:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiJSQ41 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 12:56:27 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B17159A22
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 09:56:25 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id t7-20020a62ea07000000b005619a832f68so9797191pfh.11
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 09:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TXR9HXFQyDJjtsVPfzET1xdYLWGKMnKZJlUWyX6iwHs=;
        b=SJwwwXXBIGuVGPV/jum6SyIPLywygwRt5FoXEptXLPAxZajf3rfEyCDVAE1Tgi9uzv
         Kf+fW4BlEfSFT2zR+9ctkcm7CAJP4wAMJWVGLgFrgZV1pygEps77msyKXSAKEKjLNjiJ
         McfMo962RDjXJNmTH85yYsM74Ths2LTvn3U4jOCI0l+RyvfrVwwTNDfR8magvEybQoqc
         ZLkAwF1iJh3BoH7BGff++NZi4ezb4/S+NfLL7h/0ZD9iU9SFWHY6CJJUzV7WM+1sxPiM
         4Q7OA6xmcpgR4svF/NusZewd2Sx1Ylz29f6jhE3qYTJknQzmZRlO43BGS1VYho4nzCpB
         6Rlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TXR9HXFQyDJjtsVPfzET1xdYLWGKMnKZJlUWyX6iwHs=;
        b=vx79+JyRa98ePjBOdd1Z+Pv4lJczZvnhdVZp7LhYYLt6tGjyyYCmKjAOJZRcupd/qd
         HF202XCTfIUD31JmdsUgDoOgc814HNxxs7xCI2Ntmh0swoj2AxedAXcwTbTPUCG7/YqW
         yjMk2r0HNR8mliPKjR4hUqlNP8VqiORJ4sLvBldQ44+FixI+HSj/3PkmyRSINNS1fa23
         TOPW84Cq52DqR35EIpviOhMAar6aOAMpM7ofQ/a8ZSSnw9ti3V8Jd9FJ34cHiA+1+YNw
         7EmPgkGECkrairEycanl5hIrhgixRyfDoUwJEXpJbr9gJpDnA6g5OBCDlqEDGfZP5vEg
         0JqA==
X-Gm-Message-State: ACrzQf3eLB34RYO5JXOqByh+baQTBLJBnU8wiUbsZSIJLUFQC+V+eP2h
        pCDJiuXn4cIIJegaKX1gioWKszJuuao=
X-Google-Smtp-Source: AMsMyM6JFJf4m3D3wElerL9kisEj3wnmIEjWBktQRpvvC7QGPyxEEMk5QoJR5loTst3yST+fEIYc6biV3dw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:124b:b0:179:da2f:2457 with SMTP id
 u11-20020a170903124b00b00179da2f2457mr9373837plh.156.1666198585392; Wed, 19
 Oct 2022 09:56:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 19 Oct 2022 16:56:12 +0000
In-Reply-To: <20221019165618.927057-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221019165618.927057-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221019165618.927057-3-seanjc@google.com>
Subject: [PATCH v6 2/8] KVM: x86/mmu: Rename NX huge pages fields/functions
 for consistency
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
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

Rename most of the variables/functions involved in the NX huge page
mitigation to provide consistency, e.g. lpage vs huge page, and NX huge
vs huge NX, and also to provide clarity, e.g. to make it obvious the flag
applies only to the NX huge page mitigation, not to any condition that
prevents creating a huge page.

Add a comment explaining what the newly named "possible_nx_huge_pages"
tracks.

Leave the nx_lpage_splits stat alone as the name is ABI and thus set in
stone.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/include/asm/kvm_host.h | 19 +++++++--
 arch/x86/kvm/mmu/mmu.c          | 71 +++++++++++++++++----------------
 arch/x86/kvm/mmu/mmu_internal.h | 22 ++++++----
 arch/x86/kvm/mmu/paging_tmpl.h  |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c      |  8 ++--
 5 files changed, 71 insertions(+), 51 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7551b6f9c31c..0333dbb8ec85 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1151,7 +1151,18 @@ struct kvm_arch {
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
 	struct list_head active_mmu_pages;
 	struct list_head zapped_obsolete_pages;
-	struct list_head lpage_disallowed_mmu_pages;
+	/*
+	 * A list of kvm_mmu_page structs that, if zapped, could possibly be
+	 * replaced by an NX huge page.  A shadow page is on this list if its
+	 * existence disallows an NX huge page (nx_huge_page_disallowed is set)
+	 * and there are no other conditions that prevent a huge page, e.g.
+	 * the backing host page is huge, dirtly logging is not enabled for its
+	 * memslot, etc...  Note, zapping shadow pages on this list doesn't
+	 * guarantee an NX huge page will be created in its stead, e.g. if the
+	 * guest attempts to execute from the region then KVM obviously can't
+	 * create an NX huge page (without hanging the guest).
+	 */
+	struct list_head possible_nx_huge_pages;
 	struct kvm_page_track_notifier_node mmu_sp_tracker;
 	struct kvm_page_track_notifier_head track_notifier_head;
 	/*
@@ -1267,7 +1278,7 @@ struct kvm_arch {
 	bool sgx_provisioning_allowed;
 
 	struct kvm_pmu_event_filter __rcu *pmu_event_filter;
-	struct task_struct *nx_lpage_recovery_thread;
+	struct task_struct *nx_huge_page_recovery_thread;
 
 #ifdef CONFIG_X86_64
 	/*
@@ -1312,8 +1323,8 @@ struct kvm_arch {
 	 *  - tdp_mmu_roots (above)
 	 *  - tdp_mmu_pages (above)
 	 *  - the link field of kvm_mmu_page structs used by the TDP MMU
-	 *  - lpage_disallowed_mmu_pages
-	 *  - the lpage_disallowed_link field of kvm_mmu_page structs used
+	 *  - possible_nx_huge_pages;
+	 *  - the possible_nx_huge_page_link field of kvm_mmu_page structs used
 	 *    by the TDP MMU
 	 * It is acceptable, but not necessary, to acquire this lock when
 	 * the thread holds the MMU lock in write mode.
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f1e089dfdd22..5dd98cdc5283 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -802,10 +802,10 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
 }
 
-void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 			  bool nx_huge_page_possible)
 {
-	sp->lpage_disallowed = true;
+	sp->nx_huge_page_disallowed = true;
 
 	/*
 	 * If it's possible to replace the shadow page with an NX huge page,
@@ -815,12 +815,13 @@ void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 	 * on the list if KVM is reusing an existing shadow page, i.e. if KVM
 	 * links a shadow page at multiple points.
 	 */
-	if (!nx_huge_page_possible || !list_empty(&sp->lpage_disallowed_link))
+	if (!nx_huge_page_possible ||
+	    !list_empty(&sp->possible_nx_huge_page_link))
 		return;
 
 	++kvm->stat.nx_lpage_splits;
-	list_add_tail(&sp->lpage_disallowed_link,
-		      &kvm->arch.lpage_disallowed_mmu_pages);
+	list_add_tail(&sp->possible_nx_huge_page_link,
+		      &kvm->arch.possible_nx_huge_pages);
 }
 
 static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
@@ -840,15 +841,15 @@ static void unaccount_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
 	kvm_mmu_gfn_allow_lpage(slot, gfn);
 }
 
-void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
-	sp->lpage_disallowed = false;
+	sp->nx_huge_page_disallowed = false;
 
-	if (list_empty(&sp->lpage_disallowed_link))
+	if (list_empty(&sp->possible_nx_huge_page_link))
 		return;
 
 	--kvm->stat.nx_lpage_splits;
-	list_del_init(&sp->lpage_disallowed_link);
+	list_del_init(&sp->possible_nx_huge_page_link);
 }
 
 static struct kvm_memory_slot *
@@ -2143,7 +2144,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
 
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
-	INIT_LIST_HEAD(&sp->lpage_disallowed_link);
+	INIT_LIST_HEAD(&sp->possible_nx_huge_page_link);
 
 	/*
 	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
@@ -2502,8 +2503,8 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
 		zapped_root = !is_obsolete_sp(kvm, sp);
 	}
 
-	if (sp->lpage_disallowed)
-		unaccount_huge_nx_page(kvm, sp);
+	if (sp->nx_huge_page_disallowed)
+		unaccount_nx_huge_page(kvm, sp);
 
 	sp->role.invalid = 1;
 
@@ -3143,7 +3144,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 		link_shadow_page(vcpu, it.sptep, sp);
 		if (fault->is_tdp && fault->huge_page_disallowed)
-			account_huge_nx_page(vcpu->kvm, sp,
+			account_nx_huge_page(vcpu->kvm, sp,
 					     fault->req_level >= it.level);
 	}
 
@@ -5987,7 +5988,7 @@ int kvm_mmu_init_vm(struct kvm *kvm)
 
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
-	INIT_LIST_HEAD(&kvm->arch.lpage_disallowed_mmu_pages);
+	INIT_LIST_HEAD(&kvm->arch.possible_nx_huge_pages);
 	spin_lock_init(&kvm->arch.mmu_unsync_pages_lock);
 
 	r = kvm_mmu_init_tdp_mmu(kvm);
@@ -6672,7 +6673,7 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
 			kvm_mmu_zap_all_fast(kvm);
 			mutex_unlock(&kvm->slots_lock);
 
-			wake_up_process(kvm->arch.nx_lpage_recovery_thread);
+			wake_up_process(kvm->arch.nx_huge_page_recovery_thread);
 		}
 		mutex_unlock(&kvm_lock);
 	}
@@ -6804,7 +6805,7 @@ static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel
 		mutex_lock(&kvm_lock);
 
 		list_for_each_entry(kvm, &vm_list, vm_list)
-			wake_up_process(kvm->arch.nx_lpage_recovery_thread);
+			wake_up_process(kvm->arch.nx_huge_page_recovery_thread);
 
 		mutex_unlock(&kvm_lock);
 	}
@@ -6812,7 +6813,7 @@ static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel
 	return err;
 }
 
-static void kvm_recover_nx_lpages(struct kvm *kvm)
+static void kvm_recover_nx_huge_pages(struct kvm *kvm)
 {
 	unsigned long nx_lpage_splits = kvm->stat.nx_lpage_splits;
 	int rcu_idx;
@@ -6835,23 +6836,25 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 	ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
 	to_zap = ratio ? DIV_ROUND_UP(nx_lpage_splits, ratio) : 0;
 	for ( ; to_zap; --to_zap) {
-		if (list_empty(&kvm->arch.lpage_disallowed_mmu_pages))
+		if (list_empty(&kvm->arch.possible_nx_huge_pages))
 			break;
 
 		/*
 		 * We use a separate list instead of just using active_mmu_pages
-		 * because the number of lpage_disallowed pages is expected to
-		 * be relatively small compared to the total.
+		 * because the number of shadow pages that be replaced with an
+		 * NX huge page is expected to be relatively small compared to
+		 * the total number of shadow pages.  And because the TDP MMU
+		 * doesn't use active_mmu_pages.
 		 */
-		sp = list_first_entry(&kvm->arch.lpage_disallowed_mmu_pages,
+		sp = list_first_entry(&kvm->arch.possible_nx_huge_pages,
 				      struct kvm_mmu_page,
-				      lpage_disallowed_link);
-		WARN_ON_ONCE(!sp->lpage_disallowed);
+				      possible_nx_huge_page_link);
+		WARN_ON_ONCE(!sp->nx_huge_page_disallowed);
 		if (is_tdp_mmu_page(sp)) {
 			flush |= kvm_tdp_mmu_zap_sp(kvm, sp);
 		} else {
 			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
-			WARN_ON_ONCE(sp->lpage_disallowed);
+			WARN_ON_ONCE(sp->nx_huge_page_disallowed);
 		}
 
 		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
@@ -6872,7 +6875,7 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 	srcu_read_unlock(&kvm->srcu, rcu_idx);
 }
 
-static long get_nx_lpage_recovery_timeout(u64 start_time)
+static long get_nx_huge_page_recovery_timeout(u64 start_time)
 {
 	bool enabled;
 	uint period;
@@ -6883,19 +6886,19 @@ static long get_nx_lpage_recovery_timeout(u64 start_time)
 		       : MAX_SCHEDULE_TIMEOUT;
 }
 
-static int kvm_nx_lpage_recovery_worker(struct kvm *kvm, uintptr_t data)
+static int kvm_nx_huge_page_recovery_worker(struct kvm *kvm, uintptr_t data)
 {
 	u64 start_time;
 	long remaining_time;
 
 	while (true) {
 		start_time = get_jiffies_64();
-		remaining_time = get_nx_lpage_recovery_timeout(start_time);
+		remaining_time = get_nx_huge_page_recovery_timeout(start_time);
 
 		set_current_state(TASK_INTERRUPTIBLE);
 		while (!kthread_should_stop() && remaining_time > 0) {
 			schedule_timeout(remaining_time);
-			remaining_time = get_nx_lpage_recovery_timeout(start_time);
+			remaining_time = get_nx_huge_page_recovery_timeout(start_time);
 			set_current_state(TASK_INTERRUPTIBLE);
 		}
 
@@ -6904,7 +6907,7 @@ static int kvm_nx_lpage_recovery_worker(struct kvm *kvm, uintptr_t data)
 		if (kthread_should_stop())
 			return 0;
 
-		kvm_recover_nx_lpages(kvm);
+		kvm_recover_nx_huge_pages(kvm);
 	}
 }
 
@@ -6912,17 +6915,17 @@ int kvm_mmu_post_init_vm(struct kvm *kvm)
 {
 	int err;
 
-	err = kvm_vm_create_worker_thread(kvm, kvm_nx_lpage_recovery_worker, 0,
+	err = kvm_vm_create_worker_thread(kvm, kvm_nx_huge_page_recovery_worker, 0,
 					  "kvm-nx-lpage-recovery",
-					  &kvm->arch.nx_lpage_recovery_thread);
+					  &kvm->arch.nx_huge_page_recovery_thread);
 	if (!err)
-		kthread_unpark(kvm->arch.nx_lpage_recovery_thread);
+		kthread_unpark(kvm->arch.nx_huge_page_recovery_thread);
 
 	return err;
 }
 
 void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
 {
-	if (kvm->arch.nx_lpage_recovery_thread)
-		kthread_stop(kvm->arch.nx_lpage_recovery_thread);
+	if (kvm->arch.nx_huge_page_recovery_thread)
+		kthread_stop(kvm->arch.nx_huge_page_recovery_thread);
 }
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index cca1ad75d096..67879459a25c 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -57,7 +57,13 @@ struct kvm_mmu_page {
 	bool tdp_mmu_page;
 	bool unsync;
 	u8 mmu_valid_gen;
-	bool lpage_disallowed; /* Can't be replaced by an equiv large page */
+
+	 /*
+	  * The shadow page can't be replaced by an equivalent huge page
+	  * because it is being used to map an executable page in the guest
+	  * and the NX huge page mitigation is enabled.
+	  */
+	bool nx_huge_page_disallowed;
 
 	/*
 	 * The following two entries are used to key the shadow page in the
@@ -102,12 +108,12 @@ struct kvm_mmu_page {
 
 	/*
 	 * Tracks shadow pages that, if zapped, would allow KVM to create an NX
-	 * huge page.  A shadow page will have lpage_disallowed set but not be
-	 * on the list if a huge page is disallowed for other reasons, e.g.
-	 * because KVM is shadowing a PTE at the same gfn, the memslot isn't
-	 * properly aligned, etc...
+	 * huge page.  A shadow page will have nx_huge_page_disallowed set but
+	 * not be on the list if a huge page is disallowed for other reasons,
+	 * e.g. because KVM is shadowing a PTE at the same gfn, the memslot
+	 * isn't properly aligned, etc...
 	 */
-	struct list_head lpage_disallowed_link;
+	struct list_head possible_nx_huge_page_link;
 #ifdef CONFIG_X86_32
 	/*
 	 * Used out of the mmu-lock to avoid reading spte values while an
@@ -322,8 +328,8 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
 
 void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 
-void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp,
+void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 			  bool nx_huge_page_possible);
-void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
+void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 8fd0c4e1e575..0f6455072055 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -714,7 +714,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 
 		link_shadow_page(vcpu, it.sptep, sp);
 		if (fault->huge_page_disallowed)
-			account_huge_nx_page(vcpu->kvm, sp,
+			account_nx_huge_page(vcpu->kvm, sp,
 					     fault->req_level >= it.level);
 	}
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 80a4a1a09131..73eb28ed1f03 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -284,7 +284,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
 static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
 			    gfn_t gfn, union kvm_mmu_page_role role)
 {
-	INIT_LIST_HEAD(&sp->lpage_disallowed_link);
+	INIT_LIST_HEAD(&sp->possible_nx_huge_page_link);
 
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
@@ -403,8 +403,8 @@ static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
 		lockdep_assert_held_write(&kvm->mmu_lock);
 
 	list_del(&sp->link);
-	if (sp->lpage_disallowed)
-		unaccount_huge_nx_page(kvm, sp);
+	if (sp->nx_huge_page_disallowed)
+		unaccount_nx_huge_page(kvm, sp);
 
 	if (shared)
 		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
@@ -1143,7 +1143,7 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
 	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
 	if (account_nx)
-		account_huge_nx_page(kvm, sp, true);
+		account_nx_huge_page(kvm, sp, true);
 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 	tdp_account_mmu_page(kvm, sp);
 
-- 
2.38.0.413.g74048e4d9e-goog

