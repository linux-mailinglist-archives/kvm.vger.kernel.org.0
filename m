Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 152374140E9
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 06:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbhIVFAv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 01:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbhIVFAn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 01:00:43 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC36C061574
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 21:59:13 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id on12-20020a17090b1d0c00b001997c60aa29so3134109pjb.1
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 21:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EhW8JHfVSeNsubCvclhE/fFBfEzTqgJlO96fvDjW7JA=;
        b=UN3CrFurns1PrMJ8AFiXd/HGtd3XqCcbmL2UoLU3Gh71I1l4+zdeeMD49b3g2QWIJY
         2kwbXOBQhQLQTuYj821s+pTdTPG+2QFwNfeZ/u7Xt7fh+/Wb9irvJq5nY662NXJ1JreC
         tqJtoi5lkXX8qxZcMw+SSIwmOV6vzWO7mWb9A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EhW8JHfVSeNsubCvclhE/fFBfEzTqgJlO96fvDjW7JA=;
        b=uWVbydQwRxG8cROTrhPkpEdSp40Sa+eX0CuDCaZqK8eVLNyVbrTUTv7/DUQkTiH+ON
         H0KDqLAGtnhe+jBmODE3fXzTLe2TV6DYMmn3nqZ4eBOV6CWaJNVKi0Ia3aT3MMI6LBM0
         kHTrwMCBGL97PprDTapPqkfJck8e6Mj2jHfTJlHVhFRsQ9CfF6c7bq4JWykWSOcBrTM8
         lBNTEzgyWamS09RCfiM+hRNNaDKB5ujjNpgf7Kts8edD3Ln0nEFrt62nwJlw9Bb43IiV
         TCqbSZbHURtbXSMU+XPmvmUfm1Eyr3JizIrXqTvxJ+FTXKB3kMMs8JQBNl0kND3vQavr
         P2Eg==
X-Gm-Message-State: AOAM532w33+J1yQ2jnrC/zoWAs+7Tzj4XMVGMNhaKa2iZ/+9JfHjn4Au
        BDDubbgC9GlsQms2WC+wpfd+4A==
X-Google-Smtp-Source: ABdhPJy018eCm6iyUbn3AZcChn81TEim2rEVHKQlnQq0+GEWylKF2L81+zFGE9CSEq8MPNIuKcpfww==
X-Received: by 2002:a17:90b:4a0d:: with SMTP id kk13mr9213234pjb.215.1632286752654;
        Tue, 21 Sep 2021 21:59:12 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:9a20:20f1:af4d:610c])
        by smtp.gmail.com with UTF8SMTPSA id e7sm715697pfv.158.2021.09.21.21.59.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 21:59:12 -0700 (PDT)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        David Stevens <stevensd@chromium.org>
Subject: [PATCH v2 2/2] KVM: x86: only allocate gfn_track when necessary
Date:   Wed, 22 Sep 2021 13:58:59 +0900
Message-Id: <20210922045859.2011227-3-stevensd@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210922045859.2011227-1-stevensd@google.com>
References: <20210922045859.2011227-1-stevensd@google.com>
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

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 arch/x86/include/asm/kvm_host.h       |  8 ++++
 arch/x86/include/asm/kvm_page_track.h |  5 +-
 arch/x86/kvm/mmu/mmu.c                |  7 +++
 arch/x86/kvm/mmu/page_track.c         | 69 ++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c                    |  2 +-
 5 files changed, 87 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f8f48a7ec577..3e8c952e512c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1212,6 +1212,14 @@ struct kvm_arch {
 	 */
 	bool memslots_have_rmaps;
 
+	/*
+	 * Set when the KVM mmu needs guest write access page tracking. If
+	 * set, the necessary gfn_track arrays have been allocated for
+	 * all memslots and should be allocated for any newly created or
+	 * modified memslots.
+	 */
+	bool memslots_mmu_write_tracking;
+
 #if IS_ENABLED(CONFIG_HYPERV)
 	hpa_t	hv_root_tdp;
 	spinlock_t hv_root_tdp_lock;
diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 87bd6025d91d..677f1eda9934 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -49,8 +49,11 @@ struct kvm_page_track_notifier_node {
 void kvm_page_track_init(struct kvm *kvm);
 void kvm_page_track_cleanup(struct kvm *kvm);
 
+int kvm_page_track_enable_mmu_write_tracking(struct kvm *kvm);
+
 void kvm_page_track_free_memslot(struct kvm_memory_slot *slot);
-int kvm_page_track_create_memslot(struct kvm_memory_slot *slot,
+int kvm_page_track_create_memslot(struct kvm *kvm,
+				  struct kvm_memory_slot *slot,
 				  unsigned long npages);
 
 void kvm_slot_page_track_add_page(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2d7e61122af8..c8fda983c6a5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3503,6 +3503,10 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	if (r)
 		return r;
 
+	r = kvm_page_track_enable_mmu_write_tracking(vcpu->kvm);
+	if (r)
+		return r;
+
 	write_lock(&vcpu->kvm->mmu_lock);
 	r = make_mmu_pages_available(vcpu);
 	if (r < 0)
@@ -5699,6 +5703,9 @@ void kvm_mmu_init_vm(struct kvm *kvm)
 		 */
 		kvm->arch.memslots_have_rmaps = true;
 
+	if (!tdp_enabled)
+		kvm->arch.memslots_mmu_write_tracking = true;
+
 	node->track_write = kvm_mmu_pte_write;
 	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
 	kvm_page_track_register_notifier(kvm, node);
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 269f11f92fd0..d5a9e7d18105 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -19,6 +19,16 @@
 #include "mmu.h"
 #include "mmu_internal.h"
 
+static bool write_tracking_enabled(struct kvm *kvm)
+{
+	/*
+	 * Read memslots_mmu_write_tracking before gfn_track pointers. Pairs
+	 * with smp_store_release in kvm_page_track_enable_mmu_write_tracking.
+	 */
+	return IS_ENABLED(CONFIG_KVM_EXTERNAL_WRITE_TRACKING) ||
+	       smp_load_acquire(&kvm->arch.memslots_mmu_write_tracking);
+}
+
 void kvm_page_track_free_memslot(struct kvm_memory_slot *slot)
 {
 	int i;
@@ -29,12 +39,16 @@ void kvm_page_track_free_memslot(struct kvm_memory_slot *slot)
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
+		if (i == KVM_PAGE_TRACK_WRITE && !write_tracking_enabled(kvm))
+			continue;
+
 		slot->arch.gfn_track[i] =
 			kvcalloc(npages, sizeof(*slot->arch.gfn_track[i]),
 				 GFP_KERNEL_ACCOUNT);
@@ -57,6 +71,46 @@ static inline bool page_track_mode_is_valid(enum kvm_page_track_mode mode)
 	return true;
 }
 
+int kvm_page_track_enable_mmu_write_tracking(struct kvm *kvm)
+{
+	struct kvm_memslots *slots;
+	struct kvm_memory_slot *slot;
+	unsigned short **gfn_track;
+	int i;
+
+	if (write_tracking_enabled(kvm))
+		return 0;
+
+	mutex_lock(&kvm->slots_arch_lock);
+
+	if (write_tracking_enabled(kvm)) {
+		mutex_unlock(&kvm->slots_arch_lock);
+		return 0;
+	}
+
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		slots = __kvm_memslots(kvm, i);
+		kvm_for_each_memslot(slot, slots) {
+			gfn_track = slot->arch.gfn_track + KVM_PAGE_TRACK_WRITE;
+			*gfn_track = kvcalloc(slot->npages, sizeof(*gfn_track),
+					      GFP_KERNEL_ACCOUNT);
+			if (*gfn_track == NULL) {
+				mutex_unlock(&kvm->slots_arch_lock);
+				return -ENOMEM;
+			}
+		}
+	}
+
+	/*
+	 * Ensure that memslots_mmu_write_tracking becomes true strictly
+	 * after all the pointers are set.
+	 */
+	smp_store_release(&kvm->arch.memslots_mmu_write_tracking, true);
+	mutex_unlock(&kvm->slots_arch_lock);
+
+	return 0;
+}
+
 static void update_gfn_track(struct kvm_memory_slot *slot, gfn_t gfn,
 			     enum kvm_page_track_mode mode, short count)
 {
@@ -92,6 +146,10 @@ void kvm_slot_page_track_add_page(struct kvm *kvm,
 	if (WARN_ON(!page_track_mode_is_valid(mode)))
 		return;
 
+	if (WARN_ON(mode == KVM_PAGE_TRACK_WRITE &&
+		    !write_tracking_enabled(kvm)))
+		return;
+
 	update_gfn_track(slot, gfn, mode, 1);
 
 	/*
@@ -126,6 +184,10 @@ void kvm_slot_page_track_remove_page(struct kvm *kvm,
 	if (WARN_ON(!page_track_mode_is_valid(mode)))
 		return;
 
+	if (WARN_ON(mode == KVM_PAGE_TRACK_WRITE &&
+		    !write_tracking_enabled(kvm)))
+		return;
+
 	update_gfn_track(slot, gfn, mode, -1);
 
 	/*
@@ -148,6 +210,9 @@ bool kvm_page_track_is_active(struct kvm_vcpu *vcpu, gfn_t gfn,
 	if (WARN_ON(!page_track_mode_is_valid(mode)))
 		return false;
 
+	if (mode == KVM_PAGE_TRACK_WRITE && !write_tracking_enabled(vcpu->kvm))
+		return false;
+
 	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	if (!slot)
 		return false;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 28ef14155726..169e2359a32e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11474,7 +11474,7 @@ static int kvm_alloc_memslot_metadata(struct kvm *kvm,
 		}
 	}
 
-	if (kvm_page_track_create_memslot(slot, npages))
+	if (kvm_page_track_create_memslot(kvm, slot, npages))
 		goto out_free;
 
 	return 0;
-- 
2.33.0.464.g1972c5931b-goog

