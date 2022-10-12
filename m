Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA315FCA5C
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 20:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiJLSRV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 14:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJLSRT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 14:17:19 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08FB929816
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 11:17:11 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 204-20020a2510d5000000b006be7970889cso16868076ybq.21
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 11:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zOGoGGvgl+iojtStzq1iqrGDT0sLlPiSgwzzw0iw8d4=;
        b=SDGsBWQ+VnMwWTiurbtMOyBGOjPdO71ubMbkCsOoMcTO3hz0dW+s2peDJ6ke3VqM5c
         OVV/yvP/9wPg6tNAbb1tgzmKALjx5+o7+TYaqthPPbtOEVOFz4q+PCGS8s1SCMk18dJl
         wRyMuYno1IjJnt10UhmE41OOJyhhpcALq+HkAtrgUXpzNwZh9Mz9OO6UPg5cA6+eaUsl
         LEnf8w0xNG9gmSvjed/gDPyM1zWLjtbzOVuS/4BzdzrLLVxUVkQ9ZXH3vs5/MD4YkK1c
         kcIQ4wHo/qEAZR+W2MvcTF0qcjuGVM07nFEJHpU0wU4p3tqABqi+jwC9zh7mvIXQn+jL
         zzqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zOGoGGvgl+iojtStzq1iqrGDT0sLlPiSgwzzw0iw8d4=;
        b=ZFmv3TFuZP+HNLSFr0fYOjxrdEYMbPrQhruky+rDvaxn9bNzLgo6v1c+q3qUe+xZQw
         oqq7azVmlCS8LHg//sHmOFSi2y/UqhDz7dGfo0BXWiTTU7IYGKmfA0FJ2AVRfKJmfsfL
         TXG9VihwYsQmKjen/uDk8cRIfjC4WGUPY5jlNkw6DJMyvx2iZ5nk5gDnYQqCk85rLqJs
         oQoQHe9xbLaO1+3/qhPOxBjjITRZ/pWkstOs3DPR3o0ujbknaSnbLGZ/HIN3y4DN9Tyj
         3VDtHAPo8lIFrUjB4+YoSy2lUZ/iZOsQ0kJb5guQelwPZZwpD6Ek/Ale9EQUwF+nyxCm
         0N7A==
X-Gm-Message-State: ACrzQf3ivM+GxqIRlHnmEepOBp43Qpi03zqw2+ahXsRZGxVcOvRJq+te
        tGtaktJ2lE6wHYUmA7lIHyM6IbitQ54=
X-Google-Smtp-Source: AMsMyM54rFJLdHQ9SY3H00lxfxo5SIzV1Qc8HPFItTmI+lRcEsO5uTDCC7PDTqgyuRQUiwc6sWiuFVsChNM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:5bc6:0:b0:351:17e1:6297 with SMTP id
 p189-20020a815bc6000000b0035117e16297mr28457434ywb.433.1665598630936; Wed, 12
 Oct 2022 11:17:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 12 Oct 2022 18:16:53 +0000
In-Reply-To: <20221012181702.3663607-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221012181702.3663607-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221012181702.3663607-3-seanjc@google.com>
Subject: [PATCH v4 02/11] KVM: x86/mmu: Move TDP MMU VM init/uninit behind tdp_mmu_enabled
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

Move kvm_mmu_{init,uninit}_tdp_mmu() behind tdp_mmu_enabled. This makes
these functions consistent with the rest of the calls into the TDP MMU
from mmu.c, and which is now possible since tdp_mmu_enabled is only
modified when the x86 vendor module is loaded. i.e. It will never change
during the lifetime of a VM.

This change also enabled removing the stub definitions for 32-bit KVM,
as the compiler will just optimize the calls out like it does for all
the other TDP MMU functions.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 11 +++++++----
 arch/x86/kvm/mmu/tdp_mmu.c |  6 ------
 arch/x86/kvm/mmu/tdp_mmu.h |  7 +++----
 3 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3a370f575808..b2b970e9fa8d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5984,9 +5984,11 @@ int kvm_mmu_init_vm(struct kvm *kvm)
 	INIT_LIST_HEAD(&kvm->arch.lpage_disallowed_mmu_pages);
 	spin_lock_init(&kvm->arch.mmu_unsync_pages_lock);
 
-	r = kvm_mmu_init_tdp_mmu(kvm);
-	if (r < 0)
-		return r;
+	if (is_tdp_mmu_enabled()) {
+		r = kvm_mmu_init_tdp_mmu(kvm);
+		if (r < 0)
+			return r;
+	}
 
 	node->track_write = kvm_mmu_pte_write;
 	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
@@ -6016,7 +6018,8 @@ void kvm_mmu_uninit_vm(struct kvm *kvm)
 
 	kvm_page_track_unregister_notifier(kvm, node);
 
-	kvm_mmu_uninit_tdp_mmu(kvm);
+	if (is_tdp_mmu_enabled())
+		kvm_mmu_uninit_tdp_mmu(kvm);
 
 	mmu_free_vm_memory_caches(kvm);
 }
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index cc2a3a511994..f7c4555d5d36 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -15,9 +15,6 @@ int kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 {
 	struct workqueue_struct *wq;
 
-	if (!is_tdp_mmu_enabled())
-		return 0;
-
 	wq = alloc_workqueue("kvm", WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_CPU_INTENSIVE, 0);
 	if (!wq)
 		return -ENOMEM;
@@ -43,9 +40,6 @@ static __always_inline bool kvm_lockdep_assert_mmu_lock_held(struct kvm *kvm,
 
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 {
-	if (!is_tdp_mmu_enabled())
-		return;
-
 	/* Also waits for any queued work items.  */
 	destroy_workqueue(kvm->arch.tdp_mmu_zap_wq);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index c163f7cc23ca..9d086a103f77 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -5,6 +5,9 @@
 
 #include <linux/kvm_host.h>
 
+int kvm_mmu_init_tdp_mmu(struct kvm *kvm);
+void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
+
 hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
 
 __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
@@ -66,8 +69,6 @@ u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, u64 addr,
 					u64 *spte);
 
 #ifdef CONFIG_X86_64
-int kvm_mmu_init_tdp_mmu(struct kvm *kvm);
-void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
 static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return sp->tdp_mmu_page; }
 
 static inline bool is_tdp_mmu(struct kvm_mmu *mmu)
@@ -87,8 +88,6 @@ static inline bool is_tdp_mmu(struct kvm_mmu *mmu)
 	return sp && is_tdp_mmu_page(sp) && sp->root_count;
 }
 #else
-static inline int kvm_mmu_init_tdp_mmu(struct kvm *kvm) { return 0; }
-static inline void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm) {}
 static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return false; }
 static inline bool is_tdp_mmu(struct kvm_mmu *mmu) { return false; }
 #endif
-- 
2.38.0.rc1.362.ged0d419d3c-goog

