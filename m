Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8C475A3262
	for <lists+kvm@lfdr.de>; Sat, 27 Aug 2022 01:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345391AbiHZXMj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 19:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344648AbiHZXMg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 19:12:36 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50F7D1E03
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 16:12:35 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-335ff2ef600so47177627b3.18
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 16:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=fHjungy4u15lRS8NZRY6Zq3sztnluvfGPgQcjwd048A=;
        b=sVIcCkktaYvCRPRlJ6xckmzEOaOjThn2cF2TKu3NPH6aCalKIyDKjQ5GmOUMB7IUcj
         by2Zirm51QquyqqYkMEaTnS7izONlqB9hnaR601UcdrBd5oJOJqNbGBp4Jj3RwgB3jDM
         1B+oQWpseqOoRs51idQYBSjbY6xHrLp5mscUHSdFSa/srRoX2Rl7Wuqk9u2yDuo6Svue
         djRsQLSCgG8uxkf4ysqxYx53fERxcoxqIM84jHHo+YqKHPiegdfwLBtgOv7qvqigiyiB
         Qzlv4HXdppTcnY0eZidTgSL+kiS+IsLBaf4KD/9KOr3V26eYwzeMVJ7Gtb/exlVw/IDb
         d51A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=fHjungy4u15lRS8NZRY6Zq3sztnluvfGPgQcjwd048A=;
        b=X/QwXMjBTxPIj/Wye9tkd/z3nmSDSNe9bJ1GC3kVWaTpfMZgCWoybm2uPclOkdArxn
         bR9urXxtlPpDwjovVIS6dATVxhzreQ7LX1N2GRVXB3Ch9c2w0U2/Da/2lDg2MN/uu4OD
         NIJ2KWuEza/yjN6IkERO7Qg0S+WYhQZr6zqQ7m6eOcdh5HZaf+Z01hWDc2DvtgDkFWlf
         4g7q15D9iqJNlTEQD1dKQ9fE6pJfB5LALo/hbvvwD8rSdCOIcDRAgscp5qE3IO5JgI5G
         J3hTLYdRYaTf1o+1NUm0X2lCA9vPfZ2fKQf1XY/+xrZaYWQQWqL200fQXCAk9ITYEpl0
         F92g==
X-Gm-Message-State: ACgBeo3AxhvK2RjF90jznojaQxFUNssFs2LoUN6Pe1qGS7dxnznNf0WW
        cE0bFbEUtuW13LQyQtFbXBwDxhcAxJCibQ==
X-Google-Smtp-Source: AA6agR62Kgc0jBZIktM79tweuYKQtDzd05suXI9xlwRj4vbGV4C0XMflf6PKclJmDeemlqHNgN0Ghlzw+jrdaA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6902:1148:b0:695:a10d:15a7 with SMTP
 id p8-20020a056902114800b00695a10d15a7mr1709340ybu.582.1661555555052; Fri, 26
 Aug 2022 16:12:35 -0700 (PDT)
Date:   Fri, 26 Aug 2022 16:12:19 -0700
In-Reply-To: <20220826231227.4096391-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20220826231227.4096391-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220826231227.4096391-3-dmatlack@google.com>
Subject: [PATCH v2 02/10] KVM: x86/mmu: Move TDP MMU VM init/uninit behind tdp_mmu_enabled
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
index 7caf51023d47..ff428152abce 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5973,9 +5973,11 @@ int kvm_mmu_init_vm(struct kvm *kvm)
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
@@ -6005,7 +6007,8 @@ void kvm_mmu_uninit_vm(struct kvm *kvm)
 
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
2.37.2.672.g94769d06f0-goog

