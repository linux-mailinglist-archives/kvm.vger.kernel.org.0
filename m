Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB7C75C0556
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 19:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbiIURf6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 13:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbiIURf4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 13:35:56 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C74A2624
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 10:35:55 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id z24-20020a056a001d9800b0054667d493bdso3908312pfw.0
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 10:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=eEEdCkVgaopvOjSWP9sao5eDbk8at0E8Hhz1QfDH+j4=;
        b=BibxYKmIFixzbvqnID3Cidj2r4T0Dc3Rh/Eimp6aQvMs6yq2YzaR8eVvrGNkXg16Aw
         kFdHPxfXHva/6Tma/1dLCzPfrEyk6oTUlqWAU69WJYLrSGAaBOtEr3ngOIWQ9EsmjZly
         LAe3336Fpgx+NI2W2cn/KVu8ncJwHixM4LvARXc8DHxK/HycMUgbQWdkZzHnBhRrdHS/
         VtwbS5fjX9RfipACimHLiojeVEprqe7xyw3SPfLnFpjDHjBoV3Gt/8p7MTt7IoDYfd9z
         gu8S0jCRxA14DspbpCzvM9GIMHMLb/Vj1rB4t/BLt4s4/xOiD2nsc1dBQu2d83trbbzd
         9+Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=eEEdCkVgaopvOjSWP9sao5eDbk8at0E8Hhz1QfDH+j4=;
        b=tga/n9vKhAojg1O2Sx5PCE3qjRRM+rXev/K+6nwwcA2oMAchavFuUGbq+5hTfkJ4dj
         3HWYQ5ghon6jvR6AuX5tlzLadnRevSUe+Qp5LMRSSmd7uAbTh9tGOdXbVvmOAACW6pTg
         Kg6aFzNCe1eCIxFlpAuys7y+a6xYgOvv7+u7LVGQR6QkJtWN/OJtxen6MeKi6Y2VSE+K
         qgOm43DCELXrVD5mFagsIJNwd6UynyG9sBu6UHW2tdfLvjZujcsH9BwylSPhC8WmxvKB
         eeHu3DPfu0HVuFnuC4CpXV+f2TQKWGZRGDYKMnM7ZyDvAzIsD7PCUCpUqKZR8Gt0EzcX
         DQqQ==
X-Gm-Message-State: ACrzQf2FMKCQFp/tWygKO/x0l9HU1R7qXBWBTSQvpITNq37QEpuk5KOY
        WJyx78vFDrPAtglmn/fjay/orFtgVqX3Mg==
X-Google-Smtp-Source: AMsMyM6gfUnrUU7Ss75/qLpfeXzxZ4mjMu5F9A2GIRzdniakTvplBjh+wVl/jwJVxmZw7omh8zt6wfnbD083Kg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a62:84c6:0:b0:538:3c39:5819 with SMTP id
 k189-20020a6284c6000000b005383c395819mr30542193pfd.4.1663781754770; Wed, 21
 Sep 2022 10:35:54 -0700 (PDT)
Date:   Wed, 21 Sep 2022 10:35:38 -0700
In-Reply-To: <20220921173546.2674386-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20220921173546.2674386-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220921173546.2674386-3-dmatlack@google.com>
Subject: [PATCH v3 02/10] KVM: x86/mmu: Move TDP MMU VM init/uninit behind tdp_mmu_enabled
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
---
 arch/x86/kvm/mmu/mmu.c     | 11 +++++++----
 arch/x86/kvm/mmu/tdp_mmu.c |  6 ------
 arch/x86/kvm/mmu/tdp_mmu.h |  7 +++----
 3 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ccb0b18fd194..dd261cd2ad4e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5970,9 +5970,11 @@ int kvm_mmu_init_vm(struct kvm *kvm)
 	INIT_LIST_HEAD(&kvm->arch.lpage_disallowed_mmu_pages);
 	spin_lock_init(&kvm->arch.mmu_unsync_pages_lock);
 
-	r = kvm_mmu_init_tdp_mmu(kvm);
-	if (r < 0)
-		return r;
+	if (tdp_mmu_enabled) {
+		r = kvm_mmu_init_tdp_mmu(kvm);
+		if (r < 0)
+			return r;
+	}
 
 	node->track_write = kvm_mmu_pte_write;
 	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
@@ -6002,7 +6004,8 @@ void kvm_mmu_uninit_vm(struct kvm *kvm)
 
 	kvm_page_track_unregister_notifier(kvm, node);
 
-	kvm_mmu_uninit_tdp_mmu(kvm);
+	if (tdp_mmu_enabled)
+		kvm_mmu_uninit_tdp_mmu(kvm);
 
 	mmu_free_vm_memory_caches(kvm);
 }
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index e7d0f21fbbe8..08ab3596dfaa 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -15,9 +15,6 @@ int kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 {
 	struct workqueue_struct *wq;
 
-	if (!tdp_mmu_enabled)
-		return 0;
-
 	wq = alloc_workqueue("kvm", WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_CPU_INTENSIVE, 0);
 	if (!wq)
 		return -ENOMEM;
@@ -43,9 +40,6 @@ static __always_inline bool kvm_lockdep_assert_mmu_lock_held(struct kvm *kvm,
 
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 {
-	if (!tdp_mmu_enabled)
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
2.37.3.998.g577e59143f-goog

