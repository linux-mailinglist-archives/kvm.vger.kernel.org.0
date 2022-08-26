Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 854445A3264
	for <lists+kvm@lfdr.de>; Sat, 27 Aug 2022 01:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345025AbiHZXMh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 19:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbiHZXMf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 19:12:35 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84DAD2B39
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 16:12:33 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-31f5960500bso47248417b3.14
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 16:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=v49+Ew3JSEV6ef3u7Q+7Y6Bw3gM4Kp077dWyGP4Qfok=;
        b=beMNrWBN3751tPSOvF4/C3JERxvYq21//op0ecif3fc/OiWipKnQ4Y8Nv0m/xrK57k
         GalJT65inmjaREO8hfWU0Fb9cMSt0qas7h1DkjiQpIyC2SXo1ljM0opnw1kV+3N0I/pJ
         57K2jPAdm6hsT0FAiRapgZBE/hVawF2mQBc8GXiuWUnc3tFFhDJ5ho4ZyneMCAIF3nSS
         b/rmXy8RES9EjJy4vVqShVq+1EroTBz4YIasIr44dvHZJSA9gZln27aMjYGn1r4YL5iR
         cfvHZPGwY4xuv8Vml+qLmT3SCpe58bzk1kj/n79XxM8zSTx/cTD25aLxCSeOswfw5iAp
         /fZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=v49+Ew3JSEV6ef3u7Q+7Y6Bw3gM4Kp077dWyGP4Qfok=;
        b=1Ehv/rgDkqInVjmvlUCqfp9HMeIl43PZqyJjTP0Jv3/2yo/W84hGwfWaTOaEcs7Nc6
         IeNm+aqWvZcCFTObxEUYLZaHCwTZuYSEY1L/Bh7Ppf/4AhU/Zp0y/thgYSDOREnZJNaI
         i/6eC/E6tPO7hPGiG4P2uLA7wxiCtbBrZh6aAVCrAP/hbAaMwtXqvDBZTS7W0FfhABnC
         F/Sbxx2kF22KsvQGtMFgIzetsKj4sTezLlSCy05GJYziCSKC0Rz7oL+xAWxaVrC8GkK0
         2R6rw17ZIyWMJk5L+Fj1VBGGeobAGjvRKZ07ELas9vww0ryxvvlfUUuhULa9Rl0+Ar3V
         be0Q==
X-Gm-Message-State: ACgBeo3pHmnAGq5Dx4MKVOyk05W6VDECFL6fGzAG7e4iLITD1L2pYJWt
        1p7uyMf8uFSHYRcsYvMYyv8VdZehToM/NQ==
X-Google-Smtp-Source: AA6agR7blLmnV/PbC5r4Jxv+U/4MWWBLmG3ssFufIVQfkJOKXzhLoB4sJWTEovaxsx4J2UuZIWH310POMWVZzQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:b8c6:0:b0:692:af14:6f99 with SMTP id
 g6-20020a25b8c6000000b00692af146f99mr1848698ybm.197.1661555552995; Fri, 26
 Aug 2022 16:12:32 -0700 (PDT)
Date:   Fri, 26 Aug 2022 16:12:18 -0700
In-Reply-To: <20220826231227.4096391-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20220826231227.4096391-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220826231227.4096391-2-dmatlack@google.com>
Subject: [PATCH v2 01/10] KVM: x86/mmu: Change tdp_mmu to a read-only parameter
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>, Peter Xu <peterx@redhat.com>
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

Change tdp_mmu to a read-only parameter and drop the per-vm
tdp_mmu_enabled. For 32-bit KVM, make tdp_mmu_enabled a const bool so
that the compiler can continue omitting calls to the TDP MMU.

The TDP MMU was introduced in 5.10 and has been enabled by default since
5.15. At this point there are no known functionality gaps between the
TDP MMU and the shadow MMU, and the TDP MMU uses less memory and scales
better with the number of vCPUs. In other words, there is no good reason
to disable the TDP MMU on a live system.

Do not drop tdp_mmu=N support (i.e. do not force 64-bit KVM to always
use the TDP MMU) since tdp_mmu=N is still used to get test coverage of
KVM's shadow MMU TDP support, which is used in 32-bit KVM.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm_host.h |  9 ------
 arch/x86/kvm/mmu.h              | 11 +++----
 arch/x86/kvm/mmu/mmu.c          | 54 ++++++++++++++++++++++-----------
 arch/x86/kvm/mmu/tdp_mmu.c      |  9 ++----
 4 files changed, 44 insertions(+), 39 deletions(-)

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
index 6bdaacb6faa0..dd014bece7f0 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -230,15 +230,14 @@ static inline bool kvm_shadow_root_allocated(struct kvm *kvm)
 }
 
 #ifdef CONFIG_X86_64
-static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return kvm->arch.tdp_mmu_enabled; }
-#else
-static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return false; }
-#endif
-
+extern bool tdp_mmu_enabled;
 static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
 {
-	return !is_tdp_mmu_enabled(kvm) || kvm_shadow_root_allocated(kvm);
+	return !tdp_mmu_enabled || kvm_shadow_root_allocated(kvm);
 }
+#else
+static inline bool kvm_memslots_have_rmaps(struct kvm *kvm) { return true; }
+#endif
 
 static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
 {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e418ef3ecfcb..7caf51023d47 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -98,6 +98,16 @@ module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
  */
 bool tdp_enabled = false;
 
+bool __read_mostly tdp_mmu_allowed;
+
+#ifdef CONFIG_X86_64
+bool __read_mostly tdp_mmu_enabled = true;
+module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0444);
+#else
+/* TDP MMU is not supported on 32-bit KVM. */
+const bool tdp_mmu_enabled;
+#endif
+
 static int max_huge_page_level __read_mostly;
 static int tdp_root_level __read_mostly;
 static int max_tdp_level __read_mostly;
@@ -1253,7 +1263,7 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 {
 	struct kvm_rmap_head *rmap_head;
 
-	if (is_tdp_mmu_enabled(kvm))
+	if (tdp_mmu_enabled)
 		kvm_tdp_mmu_clear_dirty_pt_masked(kvm, slot,
 				slot->base_gfn + gfn_offset, mask, true);
 
@@ -1286,7 +1296,7 @@ static void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 {
 	struct kvm_rmap_head *rmap_head;
 
-	if (is_tdp_mmu_enabled(kvm))
+	if (tdp_mmu_enabled)
 		kvm_tdp_mmu_clear_dirty_pt_masked(kvm, slot,
 				slot->base_gfn + gfn_offset, mask, false);
 
@@ -1369,7 +1379,7 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 		}
 	}
 
-	if (is_tdp_mmu_enabled(kvm))
+	if (tdp_mmu_enabled)
 		write_protected |=
 			kvm_tdp_mmu_write_protect_gfn(kvm, slot, gfn, min_level);
 
@@ -1532,7 +1542,7 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (kvm_memslots_have_rmaps(kvm))
 		flush = kvm_handle_gfn_range(kvm, range, kvm_zap_rmap);
 
-	if (is_tdp_mmu_enabled(kvm))
+	if (tdp_mmu_enabled)
 		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
 
 	return flush;
@@ -1545,7 +1555,7 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (kvm_memslots_have_rmaps(kvm))
 		flush = kvm_handle_gfn_range(kvm, range, kvm_set_pte_rmap);
 
-	if (is_tdp_mmu_enabled(kvm))
+	if (tdp_mmu_enabled)
 		flush |= kvm_tdp_mmu_set_spte_gfn(kvm, range);
 
 	return flush;
@@ -1618,7 +1628,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (kvm_memslots_have_rmaps(kvm))
 		young = kvm_handle_gfn_range(kvm, range, kvm_age_rmap);
 
-	if (is_tdp_mmu_enabled(kvm))
+	if (tdp_mmu_enabled)
 		young |= kvm_tdp_mmu_age_gfn_range(kvm, range);
 
 	return young;
@@ -1631,7 +1641,7 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (kvm_memslots_have_rmaps(kvm))
 		young = kvm_handle_gfn_range(kvm, range, kvm_test_age_rmap);
 
-	if (is_tdp_mmu_enabled(kvm))
+	if (tdp_mmu_enabled)
 		young |= kvm_tdp_mmu_test_age_gfn(kvm, range);
 
 	return young;
@@ -3543,7 +3553,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	if (r < 0)
 		goto out_unlock;
 
-	if (is_tdp_mmu_enabled(vcpu->kvm)) {
+	if (tdp_mmu_enabled) {
 		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
 		mmu->root.hpa = root;
 	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
@@ -5662,6 +5672,9 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 	tdp_root_level = tdp_forced_root_level;
 	max_tdp_level = tdp_max_root_level;
 
+#ifdef CONFIG_X86_64
+	tdp_mmu_enabled = tdp_mmu_allowed && tdp_enabled;
+#endif
 	/*
 	 * max_huge_page_level reflects KVM's MMU capabilities irrespective
 	 * of kernel support, e.g. KVM may be capable of using 1GB pages when
@@ -5909,7 +5922,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	 * write and in the same critical section as making the reload request,
 	 * e.g. before kvm_zap_obsolete_pages() could drop mmu_lock and yield.
 	 */
-	if (is_tdp_mmu_enabled(kvm))
+	if (tdp_mmu_enabled)
 		kvm_tdp_mmu_invalidate_all_roots(kvm);
 
 	/*
@@ -5934,7 +5947,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	 * Deferring the zap until the final reference to the root is put would
 	 * lead to use-after-free.
 	 */
-	if (is_tdp_mmu_enabled(kvm))
+	if (tdp_mmu_enabled)
 		kvm_tdp_mmu_zap_invalidated_roots(kvm);
 }
 
@@ -6046,7 +6059,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 
 	flush = kvm_rmap_zap_gfn_range(kvm, gfn_start, gfn_end);
 
-	if (is_tdp_mmu_enabled(kvm)) {
+	if (tdp_mmu_enabled) {
 		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
 			flush = kvm_tdp_mmu_zap_leafs(kvm, i, gfn_start,
 						      gfn_end, true, flush);
@@ -6079,7 +6092,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 		write_unlock(&kvm->mmu_lock);
 	}
 
-	if (is_tdp_mmu_enabled(kvm)) {
+	if (tdp_mmu_enabled) {
 		read_lock(&kvm->mmu_lock);
 		kvm_tdp_mmu_wrprot_slot(kvm, memslot, start_level);
 		read_unlock(&kvm->mmu_lock);
@@ -6322,7 +6335,7 @@ void kvm_mmu_try_split_huge_pages(struct kvm *kvm,
 				   u64 start, u64 end,
 				   int target_level)
 {
-	if (!is_tdp_mmu_enabled(kvm))
+	if (!tdp_mmu_enabled)
 		return;
 
 	if (kvm_memslots_have_rmaps(kvm))
@@ -6343,7 +6356,7 @@ void kvm_mmu_slot_try_split_huge_pages(struct kvm *kvm,
 	u64 start = memslot->base_gfn;
 	u64 end = start + memslot->npages;
 
-	if (!is_tdp_mmu_enabled(kvm))
+	if (!tdp_mmu_enabled)
 		return;
 
 	if (kvm_memslots_have_rmaps(kvm)) {
@@ -6426,7 +6439,7 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 		write_unlock(&kvm->mmu_lock);
 	}
 
-	if (is_tdp_mmu_enabled(kvm)) {
+	if (tdp_mmu_enabled) {
 		read_lock(&kvm->mmu_lock);
 		kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot);
 		read_unlock(&kvm->mmu_lock);
@@ -6461,7 +6474,7 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 		write_unlock(&kvm->mmu_lock);
 	}
 
-	if (is_tdp_mmu_enabled(kvm)) {
+	if (tdp_mmu_enabled) {
 		read_lock(&kvm->mmu_lock);
 		kvm_tdp_mmu_clear_dirty_slot(kvm, memslot);
 		read_unlock(&kvm->mmu_lock);
@@ -6496,7 +6509,7 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 
-	if (is_tdp_mmu_enabled(kvm))
+	if (tdp_mmu_enabled)
 		kvm_tdp_mmu_zap_all(kvm);
 
 	write_unlock(&kvm->mmu_lock);
@@ -6661,6 +6674,13 @@ void __init kvm_mmu_x86_module_init(void)
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

base-commit: 372d07084593dc7a399bf9bee815711b1fb1bcf2
prerequisite-patch-id: 2e3661ba8856c29b769499bac525b6943d9284b8
-- 
2.37.2.672.g94769d06f0-goog

