Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 586365C0555
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 19:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiIURf5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 13:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiIURfz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 13:35:55 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B19A2605
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 10:35:53 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-34d188806a8so57429147b3.19
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 10:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=fBSjtPz2LhA6G6iQtemxQX3qx5EX47fVB+7c0Daoag8=;
        b=C6m5qh/OeKq6tFfxY9JBwjeCK96ZsyfT2LZwhhn21WuHPk5vM6hg7VxpLPv8abxBb4
         fvoLS2WS1WhHna60cZyL/Gczk4X16WVAwJU3CdlZwUnDOLBaNU/kJxK334pzBtyXiHUk
         yrloA3TtuEhLsdQdDcgPp5CNELkllPWxcBcq9C1uPGVCg+nTuEsrCxtrdkFxQdP51OIh
         mrTywO6KIeFhcVuRJg0RFYnsj6AWhcXkS7z6Js9MRbc0aNRRE+CJps0symAJZ/BR2FRh
         wR7JIx2nlGvD9Sg/0qrQ2vxBlUbiHHt9mLKX9odZ1eQcmrfUnenuwjT/WgYp10XVuycZ
         3G6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=fBSjtPz2LhA6G6iQtemxQX3qx5EX47fVB+7c0Daoag8=;
        b=yj5sUMGy2Nvc2ch8KTSSWhW4QSXRdJAL0WuI0ojhr8/JxZoAVUP9RyZRQjaASZve7H
         ouv0FaSiHoXJsRA+TLSJjG0b7kDSJlCiL+kwhJFgii7dSa7q3QECKpQRYWLMGhWQwUP+
         RHN5df+4v2BMElNcUbeEmIUZR2uKGLb/3vFh689sxgDbx/F3B2J1vmFc/EKMkEmH/zzp
         iBIoPdP9tFTrWHpD6FKR3XjJdTAX2xsA5G4rFTE5hPBHxP3DjTcu2wF3A4ieBBBUr8ji
         udaVPnjt6c4aY4l4hFl/81sb6In5DQzmFjwMRZtG07Nf1vlTaDMhoTfR43WsrZI8pTMk
         6Scg==
X-Gm-Message-State: ACrzQf1BBSChqi+t8QDBsh2SMdDQlnudl6s6t4FHVdCpZ82hGC+TDy8C
        3pyP3laRAbPHHVSzD98dsyVVLirxWh+lTw==
X-Google-Smtp-Source: AMsMyM68TSTWHC5mo6YHIY739ChaVvZF8n378uIjyIerQAUS6MUXL1IN2xTx/j25/Hv9UEPcb7c/x50Ckq3X+w==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:4941:0:b0:6b3:b7ca:67de with SMTP id
 w62-20020a254941000000b006b3b7ca67demr17815118yba.347.1663781753017; Wed, 21
 Sep 2022 10:35:53 -0700 (PDT)
Date:   Wed, 21 Sep 2022 10:35:37 -0700
In-Reply-To: <20220921173546.2674386-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20220921173546.2674386-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220921173546.2674386-2-dmatlack@google.com>
Subject: [PATCH v3 01/10] KVM: x86/mmu: Change tdp_mmu to a read-only parameter
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Peter Xu <peterx@redhat.com>
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

Change tdp_mmu to a read-only parameter and drop the per-vm
tdp_mmu_enabled. For 32-bit KVM, make tdp_mmu_enabled a macro that is
always false so that the compiler can continue omitting cals to the TDP
MMU.

The TDP MMU was introduced in 5.10 and has been enabled by default since
5.15. At this point there are no known functionality gaps between the
TDP MMU and the shadow MMU, and the TDP MMU uses less memory and scales
better with the number of vCPUs. In other words, there is no good reason
to disable the TDP MMU on a live system.

Purposely do not drop tdp_mmu=N support (i.e. do not force 64-bit KVM to
always use the TDP MMU) since tdp_mmu=N is still used to get test
coverage of KVM's shadow MMU TDP support, which is used in 32-bit KVM.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm_host.h |  9 ------
 arch/x86/kvm/mmu.h              |  6 ++--
 arch/x86/kvm/mmu/mmu.c          | 51 ++++++++++++++++++++++-----------
 arch/x86/kvm/mmu/tdp_mmu.c      |  9 ++----
 4 files changed, 39 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2c96c43c313a..d76059270a43 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1262,15 +1262,6 @@ struct kvm_arch {
 	struct task_struct *nx_lpage_recovery_thread;
 
 #ifdef CONFIG_X86_64
-	/*
-	 * Whether the TDP MMU is enabled for this VM. This contains a
-	 * snapshot of the TDP MMU module parameter from when the VM was
-	 * created and remains unchanged for the life of the VM. If this is
-	 * true, TDP MMU handler functions will run for various MMU
-	 * operations.
-	 */
-	bool tdp_mmu_enabled;
-
 	/*
 	 * List of struct kvm_mmu_pages being used as roots.
 	 * All struct kvm_mmu_pages in the list should have
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 6bdaacb6faa0..168c46fd8dd1 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -230,14 +230,14 @@ static inline bool kvm_shadow_root_allocated(struct kvm *kvm)
 }
 
 #ifdef CONFIG_X86_64
-static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return kvm->arch.tdp_mmu_enabled; }
+extern bool tdp_mmu_enabled;
 #else
-static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return false; }
+#define tdp_mmu_enabled false
 #endif
 
 static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
 {
-	return !is_tdp_mmu_enabled(kvm) || kvm_shadow_root_allocated(kvm);
+	return !tdp_mmu_enabled || kvm_shadow_root_allocated(kvm);
 }
 
 static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e418ef3ecfcb..ccb0b18fd194 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -98,6 +98,13 @@ module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
  */
 bool tdp_enabled = false;
 
+bool __ro_after_init tdp_mmu_allowed;
+
+#ifdef CONFIG_X86_64
+bool __read_mostly tdp_mmu_enabled = true;
+module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0444);
+#endif
+
 static int max_huge_page_level __read_mostly;
 static int tdp_root_level __read_mostly;
 static int max_tdp_level __read_mostly;
@@ -1253,7 +1260,7 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 {
 	struct kvm_rmap_head *rmap_head;
 
-	if (is_tdp_mmu_enabled(kvm))
+	if (tdp_mmu_enabled)
 		kvm_tdp_mmu_clear_dirty_pt_masked(kvm, slot,
 				slot->base_gfn + gfn_offset, mask, true);
 
@@ -1286,7 +1293,7 @@ static void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 {
 	struct kvm_rmap_head *rmap_head;
 
-	if (is_tdp_mmu_enabled(kvm))
+	if (tdp_mmu_enabled)
 		kvm_tdp_mmu_clear_dirty_pt_masked(kvm, slot,
 				slot->base_gfn + gfn_offset, mask, false);
 
@@ -1369,7 +1376,7 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 		}
 	}
 
-	if (is_tdp_mmu_enabled(kvm))
+	if (tdp_mmu_enabled)
 		write_protected |=
 			kvm_tdp_mmu_write_protect_gfn(kvm, slot, gfn, min_level);
 
@@ -1532,7 +1539,7 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (kvm_memslots_have_rmaps(kvm))
 		flush = kvm_handle_gfn_range(kvm, range, kvm_zap_rmap);
 
-	if (is_tdp_mmu_enabled(kvm))
+	if (tdp_mmu_enabled)
 		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
 
 	return flush;
@@ -1545,7 +1552,7 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (kvm_memslots_have_rmaps(kvm))
 		flush = kvm_handle_gfn_range(kvm, range, kvm_set_pte_rmap);
 
-	if (is_tdp_mmu_enabled(kvm))
+	if (tdp_mmu_enabled)
 		flush |= kvm_tdp_mmu_set_spte_gfn(kvm, range);
 
 	return flush;
@@ -1618,7 +1625,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (kvm_memslots_have_rmaps(kvm))
 		young = kvm_handle_gfn_range(kvm, range, kvm_age_rmap);
 
-	if (is_tdp_mmu_enabled(kvm))
+	if (tdp_mmu_enabled)
 		young |= kvm_tdp_mmu_age_gfn_range(kvm, range);
 
 	return young;
@@ -1631,7 +1638,7 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (kvm_memslots_have_rmaps(kvm))
 		young = kvm_handle_gfn_range(kvm, range, kvm_test_age_rmap);
 
-	if (is_tdp_mmu_enabled(kvm))
+	if (tdp_mmu_enabled)
 		young |= kvm_tdp_mmu_test_age_gfn(kvm, range);
 
 	return young;
@@ -3543,7 +3550,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	if (r < 0)
 		goto out_unlock;
 
-	if (is_tdp_mmu_enabled(vcpu->kvm)) {
+	if (tdp_mmu_enabled) {
 		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
 		mmu->root.hpa = root;
 	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
@@ -5662,6 +5669,9 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 	tdp_root_level = tdp_forced_root_level;
 	max_tdp_level = tdp_max_root_level;
 
+#ifdef CONFIG_X86_64
+	tdp_mmu_enabled = tdp_mmu_allowed && tdp_enabled;
+#endif
 	/*
 	 * max_huge_page_level reflects KVM's MMU capabilities irrespective
 	 * of kernel support, e.g. KVM may be capable of using 1GB pages when
@@ -5909,7 +5919,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	 * write and in the same critical section as making the reload request,
 	 * e.g. before kvm_zap_obsolete_pages() could drop mmu_lock and yield.
 	 */
-	if (is_tdp_mmu_enabled(kvm))
+	if (tdp_mmu_enabled)
 		kvm_tdp_mmu_invalidate_all_roots(kvm);
 
 	/*
@@ -5934,7 +5944,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	 * Deferring the zap until the final reference to the root is put would
 	 * lead to use-after-free.
 	 */
-	if (is_tdp_mmu_enabled(kvm))
+	if (tdp_mmu_enabled)
 		kvm_tdp_mmu_zap_invalidated_roots(kvm);
 }
 
@@ -6046,7 +6056,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 
 	flush = kvm_rmap_zap_gfn_range(kvm, gfn_start, gfn_end);
 
-	if (is_tdp_mmu_enabled(kvm)) {
+	if (tdp_mmu_enabled) {
 		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
 			flush = kvm_tdp_mmu_zap_leafs(kvm, i, gfn_start,
 						      gfn_end, true, flush);
@@ -6079,7 +6089,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 		write_unlock(&kvm->mmu_lock);
 	}
 
-	if (is_tdp_mmu_enabled(kvm)) {
+	if (tdp_mmu_enabled) {
 		read_lock(&kvm->mmu_lock);
 		kvm_tdp_mmu_wrprot_slot(kvm, memslot, start_level);
 		read_unlock(&kvm->mmu_lock);
@@ -6322,7 +6332,7 @@ void kvm_mmu_try_split_huge_pages(struct kvm *kvm,
 				   u64 start, u64 end,
 				   int target_level)
 {
-	if (!is_tdp_mmu_enabled(kvm))
+	if (!tdp_mmu_enabled)
 		return;
 
 	if (kvm_memslots_have_rmaps(kvm))
@@ -6343,7 +6353,7 @@ void kvm_mmu_slot_try_split_huge_pages(struct kvm *kvm,
 	u64 start = memslot->base_gfn;
 	u64 end = start + memslot->npages;
 
-	if (!is_tdp_mmu_enabled(kvm))
+	if (!tdp_mmu_enabled)
 		return;
 
 	if (kvm_memslots_have_rmaps(kvm)) {
@@ -6426,7 +6436,7 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 		write_unlock(&kvm->mmu_lock);
 	}
 
-	if (is_tdp_mmu_enabled(kvm)) {
+	if (tdp_mmu_enabled) {
 		read_lock(&kvm->mmu_lock);
 		kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot);
 		read_unlock(&kvm->mmu_lock);
@@ -6461,7 +6471,7 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 		write_unlock(&kvm->mmu_lock);
 	}
 
-	if (is_tdp_mmu_enabled(kvm)) {
+	if (tdp_mmu_enabled) {
 		read_lock(&kvm->mmu_lock);
 		kvm_tdp_mmu_clear_dirty_slot(kvm, memslot);
 		read_unlock(&kvm->mmu_lock);
@@ -6496,7 +6506,7 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 
-	if (is_tdp_mmu_enabled(kvm))
+	if (tdp_mmu_enabled)
 		kvm_tdp_mmu_zap_all(kvm);
 
 	write_unlock(&kvm->mmu_lock);
@@ -6661,6 +6671,13 @@ void __init kvm_mmu_x86_module_init(void)
 	if (nx_huge_pages == -1)
 		__set_nx_huge_pages(get_nx_auto_mode());
 
+	/*
+	 * Snapshot userspace's desire to enable the TDP MMU. Whether or not the
+	 * TDP MMU is actually enabled is determined in kvm_configure_mmu()
+	 * when the vendor module is loaded.
+	 */
+	tdp_mmu_allowed = tdp_mmu_enabled;
+
 	kvm_mmu_spte_module_init();
 }
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index bf2ccf9debca..e7d0f21fbbe8 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -10,23 +10,18 @@
 #include <asm/cmpxchg.h>
 #include <trace/events/kvm.h>
 
-static bool __read_mostly tdp_mmu_enabled = true;
-module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0644);
-
 /* Initializes the TDP MMU for the VM, if enabled. */
 int kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 {
 	struct workqueue_struct *wq;
 
-	if (!tdp_enabled || !READ_ONCE(tdp_mmu_enabled))
+	if (!tdp_mmu_enabled)
 		return 0;
 
 	wq = alloc_workqueue("kvm", WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_CPU_INTENSIVE, 0);
 	if (!wq)
 		return -ENOMEM;
 
-	/* This should not be changed for the lifetime of the VM. */
-	kvm->arch.tdp_mmu_enabled = true;
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
 	spin_lock_init(&kvm->arch.tdp_mmu_pages_lock);
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_pages);
@@ -48,7 +43,7 @@ static __always_inline bool kvm_lockdep_assert_mmu_lock_held(struct kvm *kvm,
 
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 {
-	if (!kvm->arch.tdp_mmu_enabled)
+	if (!tdp_mmu_enabled)
 		return;
 
 	/* Also waits for any queued work items.  */
-- 
2.37.3.998.g577e59143f-goog

