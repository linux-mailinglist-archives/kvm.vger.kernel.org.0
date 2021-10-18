Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6888E43259E
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 19:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbhJRRzv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 13:55:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22991 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231739AbhJRRzu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 13:55:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634579618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Yk5KC7cabGB5ioBT5grOhTqLbo3haSFS+hGcgczdb/w=;
        b=PCazmjp7QvpjN3tFcybdxFrgFkcP0pxYNS7y0Wu7zhUFDT9Ck01NY6wGR/JmMMaWxACnaN
        IhFcP5iWjsGsgVUOQgWy0dw8hX5NrfMajzwcp4TdF4xuVQNhNll4NmgYxGLaPcSoTbmgr1
        VemWteRhGRp3q1mPlyaNF2rr26tQtPs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-604-mJKa_UYrPr-mtKzXQyLL9Q-1; Mon, 18 Oct 2021 13:53:35 -0400
X-MC-Unique: mJKa_UYrPr-mtKzXQyLL9Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00E391006AB7;
        Mon, 18 Oct 2021 17:53:34 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D854E706;
        Mon, 18 Oct 2021 17:53:33 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, David Stevens <stevensd@chromium.org>
Subject: [PATCH] KVM: cleanup allocation of rmaps and page tracking data
Date:   Mon, 18 Oct 2021 13:53:33 -0400
Message-Id: <20211018175333.582417-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

Unify the flags for rmaps and page tracking data, using a
single flag in struct kvm_arch and a single loop to go
over all the address spaces and memslots.  This avoids
code duplication between alloc_all_memslots_rmaps and
kvm_page_track_enable_mmu_write_tracking.

Signed-off-by: David Stevens <stevensd@chromium.org>
[This patch is the delta between David's v2 and v3, with conflicts
 fixed and my own commit message. - Paolo]
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h       | 17 ++----
 arch/x86/include/asm/kvm_page_track.h |  3 +-
 arch/x86/kvm/mmu.h                    | 16 ++++--
 arch/x86/kvm/mmu/mmu.c                | 78 +++++++++++++++++++++------
 arch/x86/kvm/mmu/page_track.c         | 59 ++++++--------------
 arch/x86/kvm/x86.c                    | 47 +---------------
 6 files changed, 97 insertions(+), 123 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 88f0326c184a..80f4b8a9233c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1212,18 +1212,11 @@ struct kvm_arch {
 #endif /* CONFIG_X86_64 */
 
 	/*
-	 * If set, rmaps have been allocated for all memslots and should be
-	 * allocated for any newly created or modified memslots.
+	 * If set, at least one shadow root has been allocated. This flag
+	 * is used as one input when determining whether certain memslot
+	 * related allocations are necessary.
 	 */
-	bool memslots_have_rmaps;
-
-	/*
-	 * Set when the KVM mmu needs guest write access page tracking. If
-	 * set, the necessary gfn_track arrays have been allocated for
-	 * all memslots and should be allocated for any newly created or
-	 * modified memslots.
-	 */
-	bool memslots_mmu_write_tracking;
+	bool shadow_root_alloced;
 
 #if IS_ENABLED(CONFIG_HYPERV)
 	hpa_t	hv_root_tdp;
@@ -1946,7 +1939,7 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
 
 int kvm_cpu_dirty_log_size(void);
 
-int alloc_all_memslots_rmaps(struct kvm *kvm);
+int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
 
 #define KVM_CLOCK_VALID_FLAGS						\
 	(KVM_CLOCK_TSC_STABLE | KVM_CLOCK_REALTIME | KVM_CLOCK_HOST_TSC)
diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 79d84a94f8eb..9d4a3b1b25b9 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -49,7 +49,8 @@ struct kvm_page_track_notifier_node {
 int kvm_page_track_init(struct kvm *kvm);
 void kvm_page_track_cleanup(struct kvm *kvm);
 
-int kvm_page_track_enable_mmu_write_tracking(struct kvm *kvm);
+bool kvm_page_track_write_tracking_enabled(struct kvm *kvm);
+int kvm_page_track_write_tracking_alloc(struct kvm_memory_slot *slot);
 
 void kvm_page_track_free_memslot(struct kvm_memory_slot *slot);
 int kvm_page_track_create_memslot(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index e53ef2ae958f..1ae70efedcf4 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -303,14 +303,20 @@ int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
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
index 29e7a4bb26e9..757e2a1ed149 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3397,6 +3397,67 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
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
+	/* Recheck, under the lock, whether this is the first shadow root. */
+	if (kvm_shadow_root_alloced(kvm))
+		goto out_unlock;
+
+	/*
+	 * Check if anything actually needs to be allocated, e.g. all metadata
+	 * will be allocated upfront if TDP is disabled.
+	 */
+	if (kvm_memslots_have_rmaps(kvm) &&
+	    kvm_page_track_write_tracking_enabled(kvm))
+		goto out_success;
+
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		slots = __kvm_memslots(kvm, i);
+		kvm_for_each_memslot(slot, slots) {
+			/*
+			 * Both of these functions are no-ops if the target is
+			 * already allocated, so unconditionally calling both
+			 * is safe.  Intentionally do NOT free allocations on
+			 * failure to avoid having to track which allocations
+			 * were made now versus when the memslot was created.
+			 * The metadata is guaranteed to be freed when the slot
+			 * is freed, and will be kept/used if userspace retries
+			 * KVM_RUN instead of killing the VM.
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
+out_success:
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
@@ -3427,11 +3488,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	r = alloc_all_memslots_rmaps(vcpu->kvm);
-	if (r)
-		return r;
-
-	r = kvm_page_track_enable_mmu_write_tracking(vcpu->kvm);
+	r = mmu_first_shadow_root_alloc(vcpu->kvm);
 	if (r)
 		return r;
 
@@ -5604,16 +5661,7 @@ void kvm_mmu_init_vm(struct kvm *kvm)
 
 	spin_lock_init(&kvm->arch.mmu_unsync_pages_lock);
 
-	if (!kvm_mmu_init_tdp_mmu(kvm))
-		/*
-		 * No smp_load/store wrappers needed here as we are in
-		 * VM init and there cannot be any memslots / other threads
-		 * accessing this struct kvm yet.
-		 */
-		kvm->arch.memslots_have_rmaps = true;
-
-	if (!tdp_enabled)
-		kvm->arch.memslots_mmu_write_tracking = true;
+	kvm_mmu_init_tdp_mmu(kvm);
 
 	node->track_write = kvm_mmu_pte_write;
 	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 357605809825..5e0684460930 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -19,14 +19,10 @@
 #include "mmu.h"
 #include "mmu_internal.h"
 
-static bool write_tracking_enabled(struct kvm *kvm)
+bool kvm_page_track_write_tracking_enabled(struct kvm *kvm)
 {
-	/*
-	 * Read memslots_mmu_write_tracking before gfn_track pointers. Pairs
-	 * with smp_store_release in kvm_page_track_enable_mmu_write_tracking.
-	 */
 	return IS_ENABLED(CONFIG_KVM_EXTERNAL_WRITE_TRACKING) ||
-	       smp_load_acquire(&kvm->arch.memslots_mmu_write_tracking);
+	       !tdp_enabled || kvm_shadow_root_alloced(kvm);
 }
 
 void kvm_page_track_free_memslot(struct kvm_memory_slot *slot)
@@ -46,7 +42,8 @@ int kvm_page_track_create_memslot(struct kvm *kvm,
 	int i;
 
 	for (i = 0; i < KVM_PAGE_TRACK_MAX; i++) {
-		if (i == KVM_PAGE_TRACK_WRITE && !write_tracking_enabled(kvm))
+		if (i == KVM_PAGE_TRACK_WRITE &&
+		    !kvm_page_track_write_tracking_enabled(kvm))
 			continue;
 
 		slot->arch.gfn_track[i] =
@@ -70,45 +67,18 @@ static inline bool page_track_mode_is_valid(enum kvm_page_track_mode mode)
 	return true;
 }
 
-int kvm_page_track_enable_mmu_write_tracking(struct kvm *kvm)
+int kvm_page_track_write_tracking_alloc(struct kvm_memory_slot *slot)
 {
-	struct kvm_memslots *slots;
-	struct kvm_memory_slot *slot;
-	unsigned short **gfn_track;
-	int i;
+	unsigned short *gfn_track;
 
-	if (write_tracking_enabled(kvm))
+	if (slot->arch.gfn_track[KVM_PAGE_TRACK_WRITE])
 		return 0;
 
-	mutex_lock(&kvm->slots_arch_lock);
-
-	if (write_tracking_enabled(kvm)) {
-		mutex_unlock(&kvm->slots_arch_lock);
-		return 0;
-	}
-
-	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
-		slots = __kvm_memslots(kvm, i);
-		kvm_for_each_memslot(slot, slots) {
-			gfn_track = slot->arch.gfn_track + KVM_PAGE_TRACK_WRITE;
-			if (*gfn_track)
-				continue;
-
-			*gfn_track = vcalloc(slot->npages, sizeof(**gfn_track));
-			if (*gfn_track == NULL) {
-				mutex_unlock(&kvm->slots_arch_lock);
-				return -ENOMEM;
-			}
-		}
-	}
-
-	/*
-	 * Ensure that memslots_mmu_write_tracking becomes true strictly
-	 * after all the pointers are set.
-	 */
-	smp_store_release(&kvm->arch.memslots_mmu_write_tracking, true);
-	mutex_unlock(&kvm->slots_arch_lock);
+	gfn_track = vcalloc(slot->npages, sizeof(*gfn_track));
+	if (gfn_track == NULL)
+		return -ENOMEM;
 
+	slot->arch.gfn_track[KVM_PAGE_TRACK_WRITE] = gfn_track;
 	return 0;
 }
 
@@ -148,7 +118,7 @@ void kvm_slot_page_track_add_page(struct kvm *kvm,
 		return;
 
 	if (WARN_ON(mode == KVM_PAGE_TRACK_WRITE &&
-		    !write_tracking_enabled(kvm)))
+		    !kvm_page_track_write_tracking_enabled(kvm)))
 		return;
 
 	update_gfn_track(slot, gfn, mode, 1);
@@ -186,7 +156,7 @@ void kvm_slot_page_track_remove_page(struct kvm *kvm,
 		return;
 
 	if (WARN_ON(mode == KVM_PAGE_TRACK_WRITE &&
-		    !write_tracking_enabled(kvm)))
+		    !kvm_page_track_write_tracking_enabled(kvm)))
 		return;
 
 	update_gfn_track(slot, gfn, mode, -1);
@@ -214,7 +184,8 @@ bool kvm_slot_page_track_is_active(struct kvm_vcpu *vcpu,
 	if (!slot)
 		return false;
 
-	if (mode == KVM_PAGE_TRACK_WRITE && !write_tracking_enabled(vcpu->kvm))
+	if (mode == KVM_PAGE_TRACK_WRITE &&
+	    !kvm_page_track_write_tracking_enabled(vcpu->kvm))
 		return false;
 
 	index = gfn_to_index(gfn, slot->base_gfn, PG_LEVEL_4K);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fce4d2eb69e6..b515a3d85a46 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11516,8 +11516,7 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 	kvm_page_track_free_memslot(slot);
 }
 
-static int memslot_rmap_alloc(struct kvm_memory_slot *slot,
-			      unsigned long npages)
+int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages)
 {
 	const int sz = sizeof(*slot->arch.rmap[0]);
 	int i;
@@ -11539,50 +11538,6 @@ static int memslot_rmap_alloc(struct kvm_memory_slot *slot,
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
-- 
2.27.0

