Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3942C4236C7
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 05:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhJFEAW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 00:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234456AbhJFEAO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Oct 2021 00:00:14 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81793C06139F
        for <kvm@vger.kernel.org>; Tue,  5 Oct 2021 20:56:26 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id x8so774558plv.8
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 20:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xEEq18N4tbmHHiPOreOKrkhVv7EyZKQxX4/Igzk9o1M=;
        b=T+LuFvBS+jnh7NfKRPZLIDNT8MKAAq7x3sbGhehZQRF8rCLoz/7WvUAqzI67b9WBHs
         IM4OSurLhnaEBz81pei7ELG5hXRq6XBmyVYxzCq9aw4x29TPJaI7sQBtAaF4gU8AUpi/
         23r3XP5vdHkccUhmIMlG9/HErPiOTphMSgElc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xEEq18N4tbmHHiPOreOKrkhVv7EyZKQxX4/Igzk9o1M=;
        b=5HCOSG8/dBvvkfQ6R9ZlS3emwVOnOhZ8AZUw7tHA8u4UN9H2wbzoi7EIQexTxyaojf
         qMHh8NJ5rW/W2gguTNHDwbeL6YX4j/3GPP0yE87nAoKS321ZzMjy6VBf9yZpUaIUbtN/
         u5Z2gD//9ktA1nArC8gyXzv2sgshmVAd0SnTKmibORKSeG+X8WxaWgcKs8xUj8/Vi8M7
         yWT2lYF1jxGXwANumvIp0ITvWR2TZvHp+uU7fzEj/S1Ei5ZcQdiKJtLrSJOJxdwCQrbA
         6lneUvfytHmEWKPJ+72cilHeFaQahWq/i1aY+HDYIkht0ijAXM6bXCkwtjRPwbhNG3wr
         O2sA==
X-Gm-Message-State: AOAM533egwxLMkq+BPoxwDoo9k+nDLoXnCFWOH3VopywRV8z90xXo6Nz
        5e9fRDfqxAzx9Ng+Ojl+fhSuYQ==
X-Google-Smtp-Source: ABdhPJx0vD0Zwyapz52DM7xxtHmHZ44EDzocRoZ3/KsLAlB5XKu8m3kBaTqjmm3lUHBbeY9DshL2aQ==
X-Received: by 2002:a17:902:6bc6:b0:13b:8622:93ed with SMTP id m6-20020a1709026bc600b0013b862293edmr8798900plt.87.1633492585970;
        Tue, 05 Oct 2021 20:56:25 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:3a36:864f:37ec:81e4])
        by smtp.gmail.com with UTF8SMTPSA id u2sm13498080pfi.120.2021.10.05.20.56.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 20:56:25 -0700 (PDT)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Colin Ian King <colin.king@canonical.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        David Stevens <stevensd@chromium.org>
Subject: [PATCH v3] KVM: x86: only allocate gfn_track when necessary
Date:   Wed,  6 Oct 2021 12:56:17 +0900
Message-Id: <20211006035617.1400875-1-stevensd@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

Avoid allocating the gfn_track arrays if nothing needs them. If there
are no external to KVM users of the API (i.e. no GVT-g), then page
tracking is only needed for shadow page tables. This means that when tdp
is enabled and there are no external users, then the gfn_track arrays
can be lazily allocated when the shadow MMU is actually used. This avoid
allocations equal to .05% of guest memory when nested virtualization is
not used, if the kernel is compiled without GVT-g.

This change also tangentially fixes a potential leak that could have
occurred if userspace repeatedly invoked KVM_RUN after -ENOMEM was
returned by memslot_rmap_alloc.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
Previous version [1] was merged, but a bug and some comments on the
design were raised after the fact. This is a retry of the second patch
based on the feedback, assuming that it's not too late to just drop the
previous version. If fixing forward is preferable, let me know. But it's
probably at least easier to review this way.

[1] https://lore.kernel.org/all/20210922045859.2011227-3-stevensd@google.com/

v2 -> v3:
 - reuse logic for lazily allocating rmap
 - fix allocation sizeof argument
 - fix potential leak in lazy rmap failure case
v1 -> v2:
 - lazily allocate gfn_track when shadow MMU is initialized, instead
   of looking at cpuid

 arch/x86/include/asm/kvm_host.h       |  9 ++--
 arch/x86/include/asm/kvm_page_track.h |  6 ++-
 arch/x86/kvm/mmu.h                    | 16 ++++---
 arch/x86/kvm/mmu/mmu.c                | 61 +++++++++++++++++++++++----
 arch/x86/kvm/mmu/page_track.c         | 43 ++++++++++++++++++-
 arch/x86/kvm/x86.c                    | 52 ++---------------------
 6 files changed, 119 insertions(+), 68 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f8f48a7ec577..b883c863490e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1207,10 +1207,11 @@ struct kvm_arch {
 #endif /* CONFIG_X86_64 */
 
 	/*
-	 * If set, rmaps have been allocated for all memslots and should be
-	 * allocated for any newly created or modified memslots.
+	 * If set, at least one shadow root has been allocated. This flag
+	 * is used as one input when determining whether certain memslot
+	 * related allocations are necessary.
 	 */
-	bool memslots_have_rmaps;
+	bool shadow_root_alloced;
 
 #if IS_ENABLED(CONFIG_HYPERV)
 	hpa_t	hv_root_tdp;
@@ -1935,6 +1936,6 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
 
 int kvm_cpu_dirty_log_size(void);
 
-int alloc_all_memslots_rmaps(struct kvm *kvm);
+int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
 
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 87bd6025d91d..56bf01c6fc8e 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -49,8 +49,12 @@ struct kvm_page_track_notifier_node {
 void kvm_page_track_init(struct kvm *kvm);
 void kvm_page_track_cleanup(struct kvm *kvm);
 
+bool kvm_page_track_write_tracking_enabled(struct kvm *kvm);
+int kvm_page_track_write_tracking_alloc(struct kvm_memory_slot *slot);
+
 void kvm_page_track_free_memslot(struct kvm_memory_slot *slot);
-int kvm_page_track_create_memslot(struct kvm_memory_slot *slot,
+int kvm_page_track_create_memslot(struct kvm *kvm,
+				  struct kvm_memory_slot *slot,
 				  unsigned long npages);
 
 void kvm_slot_page_track_add_page(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index e9688a9f7b57..e36c883c907b 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -230,14 +230,20 @@ int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
 int kvm_mmu_post_init_vm(struct kvm *kvm);
 void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
 
-static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
+static inline bool kvm_shadow_root_alloced(struct kvm *kvm)
 {
 	/*
-	 * Read memslot_have_rmaps before rmap pointers.  Hence, threads reading
-	 * memslots_have_rmaps in any lock context are guaranteed to see the
-	 * pointers.  Pairs with smp_store_release in alloc_all_memslots_rmaps.
+	 * Read shadow_root_alloced before related pointers. Hence, threads
+	 * reading shadow_root_alloced in any lock context are guaranteed to
+	 * see the pointers. Pairs with smp_store_release in
+	 * mmu_first_shadow_root_alloc.
 	 */
-	return smp_load_acquire(&kvm->arch.memslots_have_rmaps);
+	return smp_load_acquire(&kvm->arch.shadow_root_alloced);
+}
+
+static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
+{
+	return !kvm->arch.tdp_mmu_enabled || kvm_shadow_root_alloced(kvm);
 }
 
 static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2d7e61122af8..479f0f5213a6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3469,6 +3469,57 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	return r;
 }
 
+static int mmu_first_shadow_root_alloc(struct kvm *kvm)
+{
+	struct kvm_memslots *slots;
+	struct kvm_memory_slot *slot;
+	int r = 0, i;
+
+	/*
+	 * Check if this is the first shadow root being allocated before
+	 * taking the lock.
+	 */
+	if (kvm_shadow_root_alloced(kvm))
+		return 0;
+
+	mutex_lock(&kvm->slots_arch_lock);
+
+	/*
+	 * Check if anything actually needs to be allocated. This also
+	 * rechecks whether this is the first shadow root under the lock.
+	 */
+	if (kvm_memslots_have_rmaps(kvm) &&
+	    kvm_page_track_write_tracking_enabled(kvm))
+		goto out_unlock;
+
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		slots = __kvm_memslots(kvm, i);
+		kvm_for_each_memslot(slot, slots) {
+			/*
+			 * Both of these functions are no-ops if the target
+			 * is already allocated, so unconditionally calling
+			 * both is safe.
+			 */
+			r = memslot_rmap_alloc(slot, slot->npages);
+			if (r)
+				goto out_unlock;
+			r = kvm_page_track_write_tracking_alloc(slot);
+			if (r)
+				goto out_unlock;
+		}
+	}
+
+	/*
+	 * Ensure that shadow_root_alloced becomes true strictly after
+	 * all the related pointers are set.
+	 */
+	smp_store_release(&kvm->arch.shadow_root_alloced, true);
+
+out_unlock:
+	mutex_unlock(&kvm->slots_arch_lock);
+	return r;
+}
+
 static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
@@ -3499,7 +3550,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	r = alloc_all_memslots_rmaps(vcpu->kvm);
+	r = mmu_first_shadow_root_alloc(vcpu->kvm);
 	if (r)
 		return r;
 
@@ -5691,13 +5742,7 @@ void kvm_mmu_init_vm(struct kvm *kvm)
 
 	spin_lock_init(&kvm->arch.mmu_unsync_pages_lock);
 
-	if (!kvm_mmu_init_tdp_mmu(kvm))
-		/*
-		 * No smp_load/store wrappers needed here as we are in
-		 * VM init and there cannot be any memslots / other threads
-		 * accessing this struct kvm yet.
-		 */
-		kvm->arch.memslots_have_rmaps = true;
+	kvm_mmu_init_tdp_mmu(kvm);
 
 	node->track_write = kvm_mmu_pte_write;
 	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 269f11f92fd0..bcb28d55074d 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -19,6 +19,12 @@
 #include "mmu.h"
 #include "mmu_internal.h"
 
+bool kvm_page_track_write_tracking_enabled(struct kvm *kvm)
+{
+	return IS_ENABLED(CONFIG_KVM_EXTERNAL_WRITE_TRACKING) ||
+	       !tdp_enabled || kvm_shadow_root_alloced(kvm);
+}
+
 void kvm_page_track_free_memslot(struct kvm_memory_slot *slot)
 {
 	int i;
@@ -29,12 +35,17 @@ void kvm_page_track_free_memslot(struct kvm_memory_slot *slot)
 	}
 }
 
-int kvm_page_track_create_memslot(struct kvm_memory_slot *slot,
+int kvm_page_track_create_memslot(struct kvm *kvm,
+				  struct kvm_memory_slot *slot,
 				  unsigned long npages)
 {
-	int  i;
+	int i;
 
 	for (i = 0; i < KVM_PAGE_TRACK_MAX; i++) {
+		if (i == KVM_PAGE_TRACK_WRITE &&
+		    !kvm_page_track_write_tracking_enabled(kvm))
+			continue;
+
 		slot->arch.gfn_track[i] =
 			kvcalloc(npages, sizeof(*slot->arch.gfn_track[i]),
 				 GFP_KERNEL_ACCOUNT);
@@ -57,6 +68,22 @@ static inline bool page_track_mode_is_valid(enum kvm_page_track_mode mode)
 	return true;
 }
 
+int kvm_page_track_write_tracking_alloc(struct kvm_memory_slot *slot)
+{
+	unsigned short *gfn_track;
+
+	if (slot->arch.gfn_track[KVM_PAGE_TRACK_WRITE])
+		return 0;
+
+	gfn_track = kvcalloc(slot->npages, sizeof(*gfn_track),
+			     GFP_KERNEL_ACCOUNT);
+	if (gfn_track == NULL)
+		return -ENOMEM;
+
+	slot->arch.gfn_track[KVM_PAGE_TRACK_WRITE] = gfn_track;
+	return 0;
+}
+
 static void update_gfn_track(struct kvm_memory_slot *slot, gfn_t gfn,
 			     enum kvm_page_track_mode mode, short count)
 {
@@ -92,6 +119,10 @@ void kvm_slot_page_track_add_page(struct kvm *kvm,
 	if (WARN_ON(!page_track_mode_is_valid(mode)))
 		return;
 
+	if (WARN_ON(mode == KVM_PAGE_TRACK_WRITE &&
+		    !kvm_page_track_write_tracking_enabled(kvm)))
+		return;
+
 	update_gfn_track(slot, gfn, mode, 1);
 
 	/*
@@ -126,6 +157,10 @@ void kvm_slot_page_track_remove_page(struct kvm *kvm,
 	if (WARN_ON(!page_track_mode_is_valid(mode)))
 		return;
 
+	if (WARN_ON(mode == KVM_PAGE_TRACK_WRITE &&
+		    !kvm_page_track_write_tracking_enabled(kvm)))
+		return;
+
 	update_gfn_track(slot, gfn, mode, -1);
 
 	/*
@@ -148,6 +183,10 @@ bool kvm_page_track_is_active(struct kvm_vcpu *vcpu, gfn_t gfn,
 	if (WARN_ON(!page_track_mode_is_valid(mode)))
 		return false;
 
+	if (mode == KVM_PAGE_TRACK_WRITE &&
+	    !kvm_page_track_write_tracking_enabled(vcpu->kvm))
+		return false;
+
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	if (!slot)
 		return false;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 28ef14155726..cfcd12e07576 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11358,8 +11358,7 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 	kvm_page_track_free_memslot(slot);
 }
 
-static int memslot_rmap_alloc(struct kvm_memory_slot *slot,
-			      unsigned long npages)
+int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages)
 {
 	const int sz = sizeof(*slot->arch.rmap[0]);
 	int i;
@@ -11368,7 +11367,8 @@ static int memslot_rmap_alloc(struct kvm_memory_slot *slot,
 		int level = i + 1;
 		int lpages = __kvm_mmu_slot_lpages(slot, npages, level);
 
-		WARN_ON(slot->arch.rmap[i]);
+		if (slot->arch.rmap[i])
+			continue;
 
 		slot->arch.rmap[i] = kvcalloc(lpages, sz, GFP_KERNEL_ACCOUNT);
 		if (!slot->arch.rmap[i]) {
@@ -11380,50 +11380,6 @@ static int memslot_rmap_alloc(struct kvm_memory_slot *slot,
 	return 0;
 }
 
-int alloc_all_memslots_rmaps(struct kvm *kvm)
-{
-	struct kvm_memslots *slots;
-	struct kvm_memory_slot *slot;
-	int r, i;
-
-	/*
-	 * Check if memslots alreday have rmaps early before acquiring
-	 * the slots_arch_lock below.
-	 */
-	if (kvm_memslots_have_rmaps(kvm))
-		return 0;
-
-	mutex_lock(&kvm->slots_arch_lock);
-
-	/*
-	 * Read memslots_have_rmaps again, under the slots arch lock,
-	 * before allocating the rmaps
-	 */
-	if (kvm_memslots_have_rmaps(kvm)) {
-		mutex_unlock(&kvm->slots_arch_lock);
-		return 0;
-	}
-
-	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
-		slots = __kvm_memslots(kvm, i);
-		kvm_for_each_memslot(slot, slots) {
-			r = memslot_rmap_alloc(slot, slot->npages);
-			if (r) {
-				mutex_unlock(&kvm->slots_arch_lock);
-				return r;
-			}
-		}
-	}
-
-	/*
-	 * Ensure that memslots_have_rmaps becomes true strictly after
-	 * all the rmap pointers are set.
-	 */
-	smp_store_release(&kvm->arch.memslots_have_rmaps, true);
-	mutex_unlock(&kvm->slots_arch_lock);
-	return 0;
-}
-
 static int kvm_alloc_memslot_metadata(struct kvm *kvm,
 				      struct kvm_memory_slot *slot,
 				      unsigned long npages)
@@ -11474,7 +11430,7 @@ static int kvm_alloc_memslot_metadata(struct kvm *kvm,
 		}
 	}
 
-	if (kvm_page_track_create_memslot(slot, npages))
+	if (kvm_page_track_create_memslot(kvm, slot, npages))
 		goto out_free;
 
 	return 0;
-- 
2.33.0.800.g4c38ced690-goog

