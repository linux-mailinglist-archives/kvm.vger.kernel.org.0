Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53AE8594EC5
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 04:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbiHPCjG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 22:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233712AbiHPCir (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 22:38:47 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 308AF5D121
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 16:01:18 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3328a211611so28490557b3.5
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 16:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=0LjX2Gqu4N30zInKEoipkmbpT0g9ArLsgYxbfru5CIQ=;
        b=GYLvriG3Vd3Ii/ZhPqXAX1NTFZ/N7x1KXNuOW0dKYqtf4rAIAUsvRQJQmGQNIUaIfQ
         SfuSTItn4n/j02jK1VQ2LROqV17ipO16VCR0BqwYznWfWQmam8g51IYGdsGvu6RACUr9
         zD4Sh9EpHsrNdzURUvW8W9nLyjmFFH8m2J4oJU84W3CFD32bCMMYfyOxFrX8m4AfnND6
         fVJl8M5tf/Rd6x6bzE+kdv0TNe3S2qacijFk89aZODE4KAI3qzfkM5jzd+r5uqIvNMmL
         yMQBFz43XvxO24LS41XONLDDPQBaMPtylZvB9C+eAdvGqvhWUePGvi9fC2Cyb88F1PlN
         CI0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=0LjX2Gqu4N30zInKEoipkmbpT0g9ArLsgYxbfru5CIQ=;
        b=U7tmiir8QDZSkENB4WP9TtLDj3a2c0vOuaKicN8fGSZocF+xsc3KqjkmoEqIxbr4N7
         wIp34/VorqaY4FAVOgmu1F5e5ivNap9fTvFJDu3fT0EqmUOOZ3+qEsy65BWXBVzIfAlo
         JW81qw/IDUJCFqWgfj5py4iMj1Ulco/d6vaR/82qZhS9zwRcZnoL1OSgdpCc6E2P2PrS
         Fp+4b7j7JHevFkduudPeZ9YsvxBYJp8EcAPJRdF8kjVAMeWdMzF85SwvJG4GS42etwxb
         R/G4y1B27NZyjDdVwLPWZEGoGzR7d/pndasWvl+SX761kMC+kia9NfgsyZ700tYwQzkM
         VnXw==
X-Gm-Message-State: ACgBeo3ObAnGg6ivGPtAL+72WcbrRoYT/OI3BJJkLTz91v0uq2ww6khD
        sJ6Y4SRcJ38cMK/zsm8lzgwWlGjIGHNOiQ==
X-Google-Smtp-Source: AA6agR4tVnsp2lbp7lzQFas+YNElWM8B7nBHyS+/aC4QSa+euZmNU9kQW/a2OXD5lD6TyZSUZ+olH8XwppgEBA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6902:154f:b0:67a:8059:a65 with SMTP
 id r15-20020a056902154f00b0067a80590a65mr13087096ybu.385.1660604477790; Mon,
 15 Aug 2022 16:01:17 -0700 (PDT)
Date:   Mon, 15 Aug 2022 16:01:03 -0700
In-Reply-To: <20220815230110.2266741-1-dmatlack@google.com>
Message-Id: <20220815230110.2266741-3-dmatlack@google.com>
Mime-Version: 1.0
References: <20220815230110.2266741-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 2/9] KVM: x86/mmu: Drop kvm->arch.tdp_mmu_enabled
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@suse.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
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

Drop kvm->arch.tdp_mmu_enabled and replace it with checks for
tdp_enabled. The TDP MMU is unconditionally enabled when TDP hardware
support is enabled, so these checks are identical.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm_host.h |  9 ---------
 arch/x86/kvm/mmu.h              |  8 +-------
 arch/x86/kvm/mmu/mmu.c          | 34 ++++++++++++++++-----------------
 arch/x86/kvm/mmu/tdp_mmu.c      |  4 +---
 4 files changed, 19 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e8281d64a431..5243db32f954 100644
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
index a99acec925eb..ee3102a424aa 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -227,15 +227,9 @@ static inline bool kvm_shadow_root_allocated(struct kvm *kvm)
 	return smp_load_acquire(&kvm->arch.shadow_root_allocated);
 }
 
-#ifdef CONFIG_X86_64
-static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return kvm->arch.tdp_mmu_enabled; }
-#else
-static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return false; }
-#endif
-
 static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
 {
-	return !is_tdp_mmu_enabled(kvm) || kvm_shadow_root_allocated(kvm);
+	return !tdp_enabled || kvm_shadow_root_allocated(kvm);
 }
 
 static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3e1317325e1f..8c293a88d923 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1253,7 +1253,7 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 {
 	struct kvm_rmap_head *rmap_head;
 
-	if (is_tdp_mmu_enabled(kvm))
+	if (tdp_enabled)
 		kvm_tdp_mmu_clear_dirty_pt_masked(kvm, slot,
 				slot->base_gfn + gfn_offset, mask, true);
 
@@ -1286,7 +1286,7 @@ static void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 {
 	struct kvm_rmap_head *rmap_head;
 
-	if (is_tdp_mmu_enabled(kvm))
+	if (tdp_enabled)
 		kvm_tdp_mmu_clear_dirty_pt_masked(kvm, slot,
 				slot->base_gfn + gfn_offset, mask, false);
 
@@ -1369,7 +1369,7 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 		}
 	}
 
-	if (is_tdp_mmu_enabled(kvm))
+	if (tdp_enabled)
 		write_protected |=
 			kvm_tdp_mmu_write_protect_gfn(kvm, slot, gfn, min_level);
 
@@ -1532,7 +1532,7 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (kvm_memslots_have_rmaps(kvm))
 		flush = kvm_handle_gfn_range(kvm, range, kvm_zap_rmap);
 
-	if (is_tdp_mmu_enabled(kvm))
+	if (tdp_enabled)
 		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
 
 	return flush;
@@ -1545,7 +1545,7 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (kvm_memslots_have_rmaps(kvm))
 		flush = kvm_handle_gfn_range(kvm, range, kvm_set_pte_rmap);
 
-	if (is_tdp_mmu_enabled(kvm))
+	if (tdp_enabled)
 		flush |= kvm_tdp_mmu_set_spte_gfn(kvm, range);
 
 	return flush;
@@ -1618,7 +1618,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (kvm_memslots_have_rmaps(kvm))
 		young = kvm_handle_gfn_range(kvm, range, kvm_age_rmap);
 
-	if (is_tdp_mmu_enabled(kvm))
+	if (tdp_enabled)
 		young |= kvm_tdp_mmu_age_gfn_range(kvm, range);
 
 	return young;
@@ -1631,7 +1631,7 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (kvm_memslots_have_rmaps(kvm))
 		young = kvm_handle_gfn_range(kvm, range, kvm_test_age_rmap);
 
-	if (is_tdp_mmu_enabled(kvm))
+	if (tdp_enabled)
 		young |= kvm_tdp_mmu_test_age_gfn(kvm, range);
 
 	return young;
@@ -3543,7 +3543,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	if (r < 0)
 		goto out_unlock;
 
-	if (is_tdp_mmu_enabled(vcpu->kvm)) {
+	if (tdp_enabled) {
 		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
 		mmu->root.hpa = root;
 	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
@@ -5922,7 +5922,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	 * write and in the same critical section as making the reload request,
 	 * e.g. before kvm_zap_obsolete_pages() could drop mmu_lock and yield.
 	 */
-	if (is_tdp_mmu_enabled(kvm))
+	if (tdp_enabled)
 		kvm_tdp_mmu_invalidate_all_roots(kvm);
 
 	/*
@@ -5947,7 +5947,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	 * Deferring the zap until the final reference to the root is put would
 	 * lead to use-after-free.
 	 */
-	if (is_tdp_mmu_enabled(kvm))
+	if (tdp_enabled)
 		kvm_tdp_mmu_zap_invalidated_roots(kvm);
 }
 
@@ -6059,7 +6059,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 
 	flush = kvm_rmap_zap_gfn_range(kvm, gfn_start, gfn_end);
 
-	if (is_tdp_mmu_enabled(kvm)) {
+	if (tdp_enabled) {
 		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
 			flush = kvm_tdp_mmu_zap_leafs(kvm, i, gfn_start,
 						      gfn_end, true, flush);
@@ -6095,7 +6095,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 		write_unlock(&kvm->mmu_lock);
 	}
 
-	if (is_tdp_mmu_enabled(kvm)) {
+	if (tdp_enabled) {
 		read_lock(&kvm->mmu_lock);
 		flush |= kvm_tdp_mmu_wrprot_slot(kvm, memslot, start_level);
 		read_unlock(&kvm->mmu_lock);
@@ -6364,7 +6364,7 @@ void kvm_mmu_try_split_huge_pages(struct kvm *kvm,
 				   u64 start, u64 end,
 				   int target_level)
 {
-	if (!is_tdp_mmu_enabled(kvm))
+	if (!tdp_enabled)
 		return;
 
 	if (kvm_memslots_have_rmaps(kvm))
@@ -6385,7 +6385,7 @@ void kvm_mmu_slot_try_split_huge_pages(struct kvm *kvm,
 	u64 start = memslot->base_gfn;
 	u64 end = start + memslot->npages;
 
-	if (!is_tdp_mmu_enabled(kvm))
+	if (!tdp_enabled)
 		return;
 
 	if (kvm_memslots_have_rmaps(kvm)) {
@@ -6470,7 +6470,7 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 		write_unlock(&kvm->mmu_lock);
 	}
 
-	if (is_tdp_mmu_enabled(kvm)) {
+	if (tdp_enabled) {
 		read_lock(&kvm->mmu_lock);
 		kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot);
 		read_unlock(&kvm->mmu_lock);
@@ -6507,7 +6507,7 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 		write_unlock(&kvm->mmu_lock);
 	}
 
-	if (is_tdp_mmu_enabled(kvm)) {
+	if (tdp_enabled) {
 		read_lock(&kvm->mmu_lock);
 		flush |= kvm_tdp_mmu_clear_dirty_slot(kvm, memslot);
 		read_unlock(&kvm->mmu_lock);
@@ -6542,7 +6542,7 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 
-	if (is_tdp_mmu_enabled(kvm))
+	if (tdp_enabled)
 		kvm_tdp_mmu_zap_all(kvm);
 
 	write_unlock(&kvm->mmu_lock);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index d6c30a648d8d..383162989645 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -22,8 +22,6 @@ int kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 	if (!wq)
 		return -ENOMEM;
 
-	/* This should not be changed for the lifetime of the VM. */
-	kvm->arch.tdp_mmu_enabled = true;
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
 	spin_lock_init(&kvm->arch.tdp_mmu_pages_lock);
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_pages);
@@ -45,7 +43,7 @@ static __always_inline bool kvm_lockdep_assert_mmu_lock_held(struct kvm *kvm,
 
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 {
-	if (!kvm->arch.tdp_mmu_enabled)
+	if (!tdp_enabled)
 		return;
 
 	/* Also waits for any queued work items.  */
-- 
2.37.1.595.g718a3a8f04-goog

