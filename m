Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 491545FCA66
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 20:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiJLSRs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 14:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbiJLSRg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 14:17:36 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364916E2F0
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 11:17:21 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id u5-20020a170902e80500b00178944c46aaso12238864plg.4
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 11:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SClUoUjsSG24cCzWoSTFyKRO7uQFbeIEmHbnw8Ok9hs=;
        b=gEUoDeRhQYPbmMicSrz0De2ej23Pwhyq7nPmr9ZFO8aNgSMbS64GeskgoqklSm2w4M
         GlVL7IRag6zZS9cZ7WrzwFOfS6TRQ8SY3Jnr5C07tyx3th49dzGrZGezGRL3rvKDTjSP
         d90usPiNYTxQUnaqzSAuSpY8iXq61iOD8OFMuQYjavEm9Uw6p6rY4VtizScjJxQe8q6l
         5J+cG1oGLIBIqWVwg/cwbVFXv6njro+zJ8UqKePg/DqhDxbHZcv2/V94/B7i0TMhOG05
         pp9EMQoAYQOwFabWebaOji6F4fFr2X9OtpXSWYicshv7l96GQiHCgEB4t28Uqpcl4LeS
         MKkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SClUoUjsSG24cCzWoSTFyKRO7uQFbeIEmHbnw8Ok9hs=;
        b=EoVjhxfc9rsyS0pVu66k3WJdm5nx/6zNvH5PmK+QuQ2ps/KmdNt0PN9+WCYcR5TOWV
         oYVjgpc2UBWoAc+DZJcMVzSJqVHJEId4jy9HYEbIzULJVjSeYE7sSvkhUSgHW3vxR+/b
         avlfYP/YghZfFj+iS70ep4Oz2sZwfEf4fIRNFsv65xt1eBS0bYD9Ce5peUKQknxz7Z81
         usjo7O2Fn05ybqWGmsUQwb7pSXPJIknvYGxACS9gNp3gE4uS++2urq+tL8TEZBam16M9
         vZKN7rgYqiUxDPcbxaFIuOsaT0cq+GUef/2ONGzh1X6Yi+0lg98WHwJfxFaIc8Hm/aWR
         x7lw==
X-Gm-Message-State: ACrzQf28XzrcDHhvJeJ1aeRHKIF1nDuTatAtTcvZmDNehjz3B1Nyn6kB
        zMrm0aetp0uM6HiB1bo7L+cR9qxCtdY=
X-Google-Smtp-Source: AMsMyM7xGyJXZk6ox9gNSOVejNjZxJtiQbex1Vsue8vyd94BAvpE4TwUqhe/7QyraogcYwMQdNmVM3J9vPU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e74f:b0:179:fdfd:2c84 with SMTP id
 p15-20020a170902e74f00b00179fdfd2c84mr30739521plf.41.1665598629402; Wed, 12
 Oct 2022 11:17:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 12 Oct 2022 18:16:52 +0000
In-Reply-To: <20221012181702.3663607-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221012181702.3663607-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221012181702.3663607-2-seanjc@google.com>
Subject: [PATCH v4 01/11] KVM: x86/mmu: Change tdp_mmu to a read-only parameter
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>
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

From: David Matlack <dmatlack@google.com>

Change tdp_mmu to a read-only parameter and drop the per-vm
tdp_mmu_enabled.  Keep the is_tdp_mmu_enabled() helper instead of
referencing tdp_mmu_enabled directly to allow for future optimizations
without needing to churn a lot of code, e.g. KVM can use a static key
for now that the knob is read-only after the vendor module is loaded.

The TDP MMU was introduced in 5.10 and has been enabled by default since
5.15. At this point there are no known functionality gaps between the
TDP MMU and the shadow MMU, and the TDP MMU uses less memory and scales
better with the number of vCPUs. In other words, there is no good reason
to disable the TDP MMU on a live system.

Purposely do not drop tdp_mmu=N support (i.e. do not force 64-bit KVM to
always use the TDP MMU) since tdp_mmu=N is still used to get test
coverage of KVM's shadow MMU TDP support, which is used in 32-bit KVM.

Signed-off-by: David Matlack <dmatlack@google.com>
[sean: keep is_tdp_mmu_enabled()]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  9 ------
 arch/x86/kvm/mmu.h              | 13 ++++++--
 arch/x86/kvm/mmu/mmu.c          | 53 ++++++++++++++++++++++-----------
 arch/x86/kvm/mmu/tdp_mmu.c      |  9 ++----
 4 files changed, 48 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7551b6f9c31c..6e89e7522903 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1270,15 +1270,6 @@ struct kvm_arch {
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
 	 * List of kvm_mmu_page structs being used as roots.
 	 * All kvm_mmu_page structs in the list should have
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 6bdaacb6faa0..1ad6d02e103f 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -230,14 +230,21 @@ static inline bool kvm_shadow_root_allocated(struct kvm *kvm)
 }
 
 #ifdef CONFIG_X86_64
-static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return kvm->arch.tdp_mmu_enabled; }
+extern bool tdp_mmu_enabled;
+#endif
+
+static inline bool is_tdp_mmu_enabled(void)
+{
+#ifdef CONFIG_X86_64
+	return tdp_mmu_enabled;
 #else
-static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return false; }
+	return false;
 #endif
+}
 
 static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
 {
-	return !is_tdp_mmu_enabled(kvm) || kvm_shadow_root_allocated(kvm);
+	return !is_tdp_mmu_enabled() || kvm_shadow_root_allocated(kvm);
 }
 
 static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6f81539061d6..3a370f575808 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -98,6 +98,13 @@ module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
  */
 bool tdp_enabled = false;
 
+#ifdef CONFIG_X86_64
+static bool __ro_after_init tdp_mmu_allowed;
+
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
+	if (is_tdp_mmu_enabled())
 		kvm_tdp_mmu_clear_dirty_pt_masked(kvm, slot,
 				slot->base_gfn + gfn_offset, mask, true);
 
@@ -1286,7 +1293,7 @@ static void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 {
 	struct kvm_rmap_head *rmap_head;
 
-	if (is_tdp_mmu_enabled(kvm))
+	if (is_tdp_mmu_enabled())
 		kvm_tdp_mmu_clear_dirty_pt_masked(kvm, slot,
 				slot->base_gfn + gfn_offset, mask, false);
 
@@ -1369,7 +1376,7 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 		}
 	}
 
-	if (is_tdp_mmu_enabled(kvm))
+	if (is_tdp_mmu_enabled())
 		write_protected |=
 			kvm_tdp_mmu_write_protect_gfn(kvm, slot, gfn, min_level);
 
@@ -1532,7 +1539,7 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (kvm_memslots_have_rmaps(kvm))
 		flush = kvm_handle_gfn_range(kvm, range, kvm_zap_rmap);
 
-	if (is_tdp_mmu_enabled(kvm))
+	if (is_tdp_mmu_enabled())
 		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
 
 	return flush;
@@ -1545,7 +1552,7 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (kvm_memslots_have_rmaps(kvm))
 		flush = kvm_handle_gfn_range(kvm, range, kvm_set_pte_rmap);
 
-	if (is_tdp_mmu_enabled(kvm))
+	if (is_tdp_mmu_enabled())
 		flush |= kvm_tdp_mmu_set_spte_gfn(kvm, range);
 
 	return flush;
@@ -1620,7 +1627,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (kvm_memslots_have_rmaps(kvm))
 		young = kvm_handle_gfn_range(kvm, range, kvm_age_rmap);
 
-	if (is_tdp_mmu_enabled(kvm))
+	if (is_tdp_mmu_enabled())
 		young |= kvm_tdp_mmu_age_gfn_range(kvm, range);
 
 	return young;
@@ -1633,7 +1640,7 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	if (kvm_memslots_have_rmaps(kvm))
 		young = kvm_handle_gfn_range(kvm, range, kvm_test_age_rmap);
 
-	if (is_tdp_mmu_enabled(kvm))
+	if (is_tdp_mmu_enabled())
 		young |= kvm_tdp_mmu_test_age_gfn(kvm, range);
 
 	return young;
@@ -3557,7 +3564,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	if (r < 0)
 		goto out_unlock;
 
-	if (is_tdp_mmu_enabled(vcpu->kvm)) {
+	if (is_tdp_mmu_enabled()) {
 		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
 		mmu->root.hpa = root;
 	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
@@ -5676,6 +5683,9 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 	tdp_root_level = tdp_forced_root_level;
 	max_tdp_level = tdp_max_root_level;
 
+#ifdef CONFIG_X86_64
+	tdp_mmu_enabled = tdp_mmu_allowed && tdp_enabled;
+#endif
 	/*
 	 * max_huge_page_level reflects KVM's MMU capabilities irrespective
 	 * of kernel support, e.g. KVM may be capable of using 1GB pages when
@@ -5923,7 +5933,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	 * write and in the same critical section as making the reload request,
 	 * e.g. before kvm_zap_obsolete_pages() could drop mmu_lock and yield.
 	 */
-	if (is_tdp_mmu_enabled(kvm))
+	if (is_tdp_mmu_enabled())
 		kvm_tdp_mmu_invalidate_all_roots(kvm);
 
 	/*
@@ -5948,7 +5958,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	 * Deferring the zap until the final reference to the root is put would
 	 * lead to use-after-free.
 	 */
-	if (is_tdp_mmu_enabled(kvm))
+	if (is_tdp_mmu_enabled())
 		kvm_tdp_mmu_zap_invalidated_roots(kvm);
 }
 
@@ -6060,7 +6070,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 
 	flush = kvm_rmap_zap_gfn_range(kvm, gfn_start, gfn_end);
 
-	if (is_tdp_mmu_enabled(kvm)) {
+	if (is_tdp_mmu_enabled()) {
 		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
 			flush = kvm_tdp_mmu_zap_leafs(kvm, i, gfn_start,
 						      gfn_end, true, flush);
@@ -6093,7 +6103,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 		write_unlock(&kvm->mmu_lock);
 	}
 
-	if (is_tdp_mmu_enabled(kvm)) {
+	if (is_tdp_mmu_enabled()) {
 		read_lock(&kvm->mmu_lock);
 		kvm_tdp_mmu_wrprot_slot(kvm, memslot, start_level);
 		read_unlock(&kvm->mmu_lock);
@@ -6336,7 +6346,7 @@ void kvm_mmu_try_split_huge_pages(struct kvm *kvm,
 				   u64 start, u64 end,
 				   int target_level)
 {
-	if (!is_tdp_mmu_enabled(kvm))
+	if (!is_tdp_mmu_enabled())
 		return;
 
 	if (kvm_memslots_have_rmaps(kvm))
@@ -6357,7 +6367,7 @@ void kvm_mmu_slot_try_split_huge_pages(struct kvm *kvm,
 	u64 start = memslot->base_gfn;
 	u64 end = start + memslot->npages;
 
-	if (!is_tdp_mmu_enabled(kvm))
+	if (!is_tdp_mmu_enabled())
 		return;
 
 	if (kvm_memslots_have_rmaps(kvm)) {
@@ -6440,7 +6450,7 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 		write_unlock(&kvm->mmu_lock);
 	}
 
-	if (is_tdp_mmu_enabled(kvm)) {
+	if (is_tdp_mmu_enabled()) {
 		read_lock(&kvm->mmu_lock);
 		kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot);
 		read_unlock(&kvm->mmu_lock);
@@ -6475,7 +6485,7 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 		write_unlock(&kvm->mmu_lock);
 	}
 
-	if (is_tdp_mmu_enabled(kvm)) {
+	if (is_tdp_mmu_enabled()) {
 		read_lock(&kvm->mmu_lock);
 		kvm_tdp_mmu_clear_dirty_slot(kvm, memslot);
 		read_unlock(&kvm->mmu_lock);
@@ -6510,7 +6520,7 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 
-	if (is_tdp_mmu_enabled(kvm))
+	if (is_tdp_mmu_enabled())
 		kvm_tdp_mmu_zap_all(kvm);
 
 	write_unlock(&kvm->mmu_lock);
@@ -6675,6 +6685,15 @@ void __init kvm_mmu_x86_module_init(void)
 	if (nx_huge_pages == -1)
 		__set_nx_huge_pages(get_nx_auto_mode());
 
+#ifdef CONFIG_X86_64
+	/*
+	 * Snapshot userspace's desire to enable the TDP MMU. Whether or not the
+	 * TDP MMU is actually enabled is determined in kvm_configure_mmu()
+	 * when the vendor module is loaded.
+	 */
+	tdp_mmu_allowed = tdp_mmu_enabled;
+#endif
+
 	kvm_mmu_spte_module_init();
 }
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 672f0432d777..cc2a3a511994 100644
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
+	if (!is_tdp_mmu_enabled())
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
+	if (!is_tdp_mmu_enabled())
 		return;
 
 	/* Also waits for any queued work items.  */
-- 
2.38.0.rc1.362.ged0d419d3c-goog

