Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE556B5697
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 01:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbjCKAYU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 19:24:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbjCKAXo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 19:23:44 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 872BB6EB90
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:23:28 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id b8-20020aa78708000000b005eaa50faa35so3670856pfo.20
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:23:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678494205;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=C7JjSI0pT7joQ/rLMM2i7GRIoYFbucT/e+mgN6frquk=;
        b=HO/j4jZxJTPnNlCvqNIr5Y5KBfdMA+RArZQ6E8B+5VeFfzVshQ9PBvi1r5s9Vp2/Sj
         Pt7JTJKOBCqoqv8n4jxdK+8vBvs0GXZc7nW8k5IsbdneX9q7CcOtXcr5R6UJ39ls0eYZ
         6Y7j9wTPtbZQ7b17m/bJYsT/8NjZnITyKuhsNfYb/UMAULXoEo4a2UglV221BRnLFrcy
         aZ8NirUFSobSolD6VpCWTPhefI1g6HcHwKuU3rrdgwuk0hOYJvzaVFIs94wOvTXe0KLT
         3uHSd1BR6WrVPUWLMgcw8g7jirMBfMd7+Gjd/TGzPOcG5bhLVf8y0szkKmKHbV/rX64c
         Tdyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678494205;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C7JjSI0pT7joQ/rLMM2i7GRIoYFbucT/e+mgN6frquk=;
        b=GGzdbYNnaSRosFUsjR+jW/yqkfFkVgqVuF6OD4e4AnOXl4xuYupdrS7GtopkXA2RUn
         nyHXeFb7IR4UHpPmByJedbJLufDRLVawzUULbEhOqqag3VPINCXxe3iUdnDymlpttORQ
         YFogFWNKQwwQGeWUaquxAZjWj6TzyYZSUZ1KBKMjGa+yCFKR54xpKxNSbymEVbAvdKev
         XPZug7+RSHAIY/977aGoDkOQy1fIpPfMp6vrxVOPDs0O3OJuR5mqkcFDkJG21OXFvZwL
         F9H0+g15y1N4PLJsguaifwObKqTHtsyXViocmSRZaP5AtWgdE4Blr1ghSllULow1rkYZ
         VDzg==
X-Gm-Message-State: AO0yUKWifPNMwp1i5j/glrXqfw7kAJHxORCX9yaEQy5flPXBKaLOYtY+
        BfluMmDjQ00OdcwwWKsleZ1Q0abAd7Q=
X-Google-Smtp-Source: AK7set+nvDi5+cfWY/68g3W32qPSKJ/xJIPlveVHG2ouIZzDbXvK/x4F5YpX9LRpx9zUK3oD6Jj2WQlm1j0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:420b:b0:237:29b1:188f with SMTP id
 o11-20020a17090a420b00b0023729b1188fmr10180694pjg.8.1678494205065; Fri, 10
 Mar 2023 16:23:25 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 16:22:41 -0800
In-Reply-To: <20230311002258.852397-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230311002258.852397-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230311002258.852397-11-seanjc@google.com>
Subject: [PATCH v2 10/27] drm/i915/gvt: Protect gfn hash table with vgpu_lock
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     kvm@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
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

Use vgpu_lock instead of KVM's mmu_lock to protect accesses to the hash
table used to track which gfns are write-protected when shadowing the
guest's GTT, and hoist the acquisition of vgpu_lock from
intel_vgpu_page_track_handler() out to its sole caller,
kvmgt_page_track_write().

This fixes a bug where kvmgt_page_track_write(), which doesn't hold
kvm->mmu_lock, could race with intel_gvt_page_track_remove() and trigger
a use-after-free.

Fixing kvmgt_page_track_write() by taking kvm->mmu_lock is not an option
as mmu_lock is a r/w spinlock, and intel_vgpu_page_track_handler() might
sleep when acquiring vgpu->cache_lock deep down the callstack:

  intel_vgpu_page_track_handler()
  |
  |->  page_track->handler / ppgtt_write_protection_handler()
       |
       |-> ppgtt_handle_guest_write_page_table_bytes()
           |
           |->  ppgtt_handle_guest_write_page_table()
                |
                |-> ppgtt_handle_guest_entry_removal()
                    |
                    |-> ppgtt_invalidate_pte()
                        |
                        |-> intel_gvt_dma_unmap_guest_page()
                            |
                            |-> mutex_lock(&vgpu->cache_lock);

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/gpu/drm/i915/gvt/kvmgt.c      | 55 +++++++++++++++------------
 drivers/gpu/drm/i915/gvt/page_track.c | 10 +----
 2 files changed, 33 insertions(+), 32 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 68be66395598..9824d075562e 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -366,6 +366,8 @@ __kvmgt_protect_table_find(struct intel_vgpu *info, gfn_t gfn)
 {
 	struct kvmgt_pgfn *p, *res = NULL;
 
+	lockdep_assert_held(&info->vgpu_lock);
+
 	hash_for_each_possible(info->ptable, p, hnode, gfn) {
 		if (gfn == p->gfn) {
 			res = p;
@@ -1567,6 +1569,9 @@ int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn)
 	if (!test_bit(INTEL_VGPU_STATUS_ATTACHED, info->status))
 		return -ESRCH;
 
+	if (kvmgt_gfn_is_write_protected(info, gfn))
+		return 0;
+
 	idx = srcu_read_lock(&kvm->srcu);
 	slot = gfn_to_memslot(kvm, gfn);
 	if (!slot) {
@@ -1575,16 +1580,12 @@ int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn)
 	}
 
 	write_lock(&kvm->mmu_lock);
-
-	if (kvmgt_gfn_is_write_protected(info, gfn))
-		goto out;
-
 	kvm_slot_page_track_add_page(kvm, slot, gfn, KVM_PAGE_TRACK_WRITE);
+	write_unlock(&kvm->mmu_lock);
+
+	srcu_read_unlock(&kvm->srcu, idx);
+
 	kvmgt_protect_table_add(info, gfn);
-
-out:
-	write_unlock(&kvm->mmu_lock);
-	srcu_read_unlock(&kvm->srcu, idx);
 	return 0;
 }
 
@@ -1597,24 +1598,22 @@ int intel_gvt_page_track_remove(struct intel_vgpu *info, u64 gfn)
 	if (!test_bit(INTEL_VGPU_STATUS_ATTACHED, info->status))
 		return -ESRCH;
 
-	idx = srcu_read_lock(&kvm->srcu);
-	slot = gfn_to_memslot(kvm, gfn);
-	if (!slot) {
-		srcu_read_unlock(&kvm->srcu, idx);
-		return -EINVAL;
-	}
-
-	write_lock(&kvm->mmu_lock);
-
 	if (!kvmgt_gfn_is_write_protected(info, gfn))
-		goto out;
+		return 0;
 
+	idx = srcu_read_lock(&kvm->srcu);
+	slot = gfn_to_memslot(kvm, gfn);
+	if (!slot) {
+		srcu_read_unlock(&kvm->srcu, idx);
+		return -EINVAL;
+	}
+
+	write_lock(&kvm->mmu_lock);
 	kvm_slot_page_track_remove_page(kvm, slot, gfn, KVM_PAGE_TRACK_WRITE);
+	write_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
+
 	kvmgt_protect_table_del(info, gfn);
-
-out:
-	write_unlock(&kvm->mmu_lock);
-	srcu_read_unlock(&kvm->srcu, idx);
 	return 0;
 }
 
@@ -1625,9 +1624,13 @@ static void kvmgt_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	struct intel_vgpu *info =
 		container_of(node, struct intel_vgpu, track_node);
 
+	mutex_lock(&info->vgpu_lock);
+
 	if (kvmgt_gfn_is_write_protected(info, gpa_to_gfn(gpa)))
 		intel_vgpu_page_track_handler(info, gpa,
 						     (void *)val, len);
+
+	mutex_unlock(&info->vgpu_lock);
 }
 
 static void kvmgt_page_track_flush_slot(struct kvm *kvm,
@@ -1639,16 +1642,20 @@ static void kvmgt_page_track_flush_slot(struct kvm *kvm,
 	struct intel_vgpu *info =
 		container_of(node, struct intel_vgpu, track_node);
 
-	write_lock(&kvm->mmu_lock);
+	mutex_lock(&info->vgpu_lock);
+
 	for (i = 0; i < slot->npages; i++) {
 		gfn = slot->base_gfn + i;
 		if (kvmgt_gfn_is_write_protected(info, gfn)) {
+			write_lock(&kvm->mmu_lock);
 			kvm_slot_page_track_remove_page(kvm, slot, gfn,
 						KVM_PAGE_TRACK_WRITE);
+			write_unlock(&kvm->mmu_lock);
+
 			kvmgt_protect_table_del(info, gfn);
 		}
 	}
-	write_unlock(&kvm->mmu_lock);
+	mutex_unlock(&info->vgpu_lock);
 }
 
 void intel_vgpu_detach_regions(struct intel_vgpu *vgpu)
diff --git a/drivers/gpu/drm/i915/gvt/page_track.c b/drivers/gpu/drm/i915/gvt/page_track.c
index df34e73cba41..60a65435556d 100644
--- a/drivers/gpu/drm/i915/gvt/page_track.c
+++ b/drivers/gpu/drm/i915/gvt/page_track.c
@@ -162,13 +162,9 @@ int intel_vgpu_page_track_handler(struct intel_vgpu *vgpu, u64 gpa,
 	struct intel_vgpu_page_track *page_track;
 	int ret = 0;
 
-	mutex_lock(&vgpu->vgpu_lock);
-
 	page_track = intel_vgpu_find_page_track(vgpu, gpa >> PAGE_SHIFT);
-	if (!page_track) {
-		ret = -ENXIO;
-		goto out;
-	}
+	if (!page_track)
+		return -ENXIO;
 
 	if (unlikely(vgpu->failsafe)) {
 		/* Remove write protection to prevent furture traps. */
@@ -179,7 +175,5 @@ int intel_vgpu_page_track_handler(struct intel_vgpu *vgpu, u64 gpa,
 			gvt_err("guest page write error, gpa %llx\n", gpa);
 	}
 
-out:
-	mutex_unlock(&vgpu->vgpu_lock);
 	return ret;
 }
-- 
2.40.0.rc1.284.g88254d51c5-goog

