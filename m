Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2E47452859
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 04:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238574AbhKPDSo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 22:18:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238487AbhKPDR7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 22:17:59 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC71C043197
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 15:46:09 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id k8-20020a6555c8000000b002e32ed2a021so6143230pgs.1
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 15:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=nyFgzVEyCb72eNk2VPGomrdPJdYxRfeEzI0NSb6F/8s=;
        b=FhwSo+AeArEwiboUCjKrKMx7ZmN/9qUIupIm2aZQAugw8dJDwnhnLiP3VJTF8bT1AK
         jayIojnrkZaa7jiUDGHwFP7G3QBGerYyLehza9KYtn8XtebTX01R5RVExHPxf9O3VPcS
         1Awn5+p8ZnWwEfsh4oDQWZV7LTQGB/cEkZ2Gk1na4VJavTk+NtbQTNu8HhfgMEkQi+wc
         1prwoPhZvdYbcDDATxT5EL6XEMkTG2w+aS0u+jtU8+uBwLBVMtxgzO37bzqj5A/g9lgl
         kerfqBf+QDMqIvG+mMaXL01J3WBJy1tC9gZzHhi7Sy5SXotbfNiC2tIU1O9NgYsxdMLM
         HDag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nyFgzVEyCb72eNk2VPGomrdPJdYxRfeEzI0NSb6F/8s=;
        b=aT/14r7gRcC3QuxLR3qFSYGR6X3ZJD7fER8rfqF6jNohoLql1k+BUpVveKh9X1zM0q
         08ISMhFu2hue9XH52HHRRsYezgFxh0S0RfsUd1XZ47MD7lKYRGUeNKo0iV1c7Dd/NK+U
         dDONk5mewMeOko4RiW0csKz5YKnKpBONYHNr6hOjsmyk7T4e7PuaUax/Ynd2ZUXUYwuc
         qiXrD9/Qj6EBMCNRlgl2NST7qWpcZ9jYJHsKPlQjZSj/CAWQMEw/wB7gRp9mtfB4bBZa
         T4qAETJSDUMv9MbwnimM0Fr1KGpAtefF6fT6R3v6r4hO4xD0nXEImYLP3Dtag+WIn+xf
         u94A==
X-Gm-Message-State: AOAM533UejZq1EcjO7JZAqEcVaLsO9yEERU0vCP+JqYAF2/X+QsazWr/
        xZIlSMnshtw9oGPxjXbatieR5NAKKRde
X-Google-Smtp-Source: ABdhPJyUpLKPY0hJHdO9XvEjt/lnw3HVEnRL357TT0PU6WuDTHxaiDtzi5W6QrLBfSrYf6aop5hTIjuD5YGG
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:916d:2253:5849:9965])
 (user=bgardon job=sendgmr) by 2002:a17:902:6a8a:b0:143:905f:aec7 with SMTP id
 n10-20020a1709026a8a00b00143905faec7mr40786543plk.8.1637019968545; Mon, 15
 Nov 2021 15:46:08 -0800 (PST)
Date:   Mon, 15 Nov 2021 15:45:49 -0800
In-Reply-To: <20211115234603.2908381-1-bgardon@google.com>
Message-Id: <20211115234603.2908381-2-bgardon@google.com>
Mime-Version: 1.0
References: <20211115234603.2908381-1-bgardon@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH 01/15] KVM: x86/mmu: Remove redundant flushes when disabling
 dirty logging
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tdp_mmu_zap_spte_atomic flushes on every zap already, so no need to
flush again after it's done.

Reviewed-by: David Matlack <dmatlack@google.com>

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c     |  4 +---
 arch/x86/kvm/mmu/tdp_mmu.c | 21 ++++++---------------
 arch/x86/kvm/mmu/tdp_mmu.h |  5 ++---
 3 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 354d2ca92df4..baa94acab516 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5870,9 +5870,7 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 
 	if (is_tdp_mmu_enabled(kvm)) {
 		read_lock(&kvm->mmu_lock);
-		flush = kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot, flush);
-		if (flush)
-			kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
+		kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot);
 		read_unlock(&kvm->mmu_lock);
 	}
 }
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7c5dd83e52de..b3c78568ae60 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1364,10 +1364,9 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
  * Clear leaf entries which could be replaced by large mappings, for
  * GFNs within the slot.
  */
-static bool zap_collapsible_spte_range(struct kvm *kvm,
+static void zap_collapsible_spte_range(struct kvm *kvm,
 				       struct kvm_mmu_page *root,
-				       const struct kvm_memory_slot *slot,
-				       bool flush)
+				       const struct kvm_memory_slot *slot)
 {
 	gfn_t start = slot->base_gfn;
 	gfn_t end = start + slot->npages;
@@ -1378,10 +1377,8 @@ static bool zap_collapsible_spte_range(struct kvm *kvm,
 
 	tdp_root_for_each_pte(iter, root, start, end) {
 retry:
-		if (tdp_mmu_iter_cond_resched(kvm, &iter, flush, true)) {
-			flush = false;
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
-		}
 
 		if (!is_shadow_present_pte(iter.old_spte) ||
 		    !is_last_spte(iter.old_spte, iter.level))
@@ -1401,30 +1398,24 @@ static bool zap_collapsible_spte_range(struct kvm *kvm,
 			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
 			goto retry;
 		}
-		flush = true;
 	}
 
 	rcu_read_unlock();
-
-	return flush;
 }
 
 /*
  * Clear non-leaf entries (and free associated page tables) which could
  * be replaced by large mappings, for GFNs within the slot.
  */
-bool kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
-				       const struct kvm_memory_slot *slot,
-				       bool flush)
+void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
+				       const struct kvm_memory_slot *slot)
 {
 	struct kvm_mmu_page *root;
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
 	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
-		flush = zap_collapsible_spte_range(kvm, root, slot, flush);
-
-	return flush;
+		zap_collapsible_spte_range(kvm, root, slot);
 }
 
 /*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 476b133544dd..3899004a5d91 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -64,9 +64,8 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 				       struct kvm_memory_slot *slot,
 				       gfn_t gfn, unsigned long mask,
 				       bool wrprot);
-bool kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
-				       const struct kvm_memory_slot *slot,
-				       bool flush);
+void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
+				       const struct kvm_memory_slot *slot);
 
 bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
-- 
2.34.0.rc1.387.gb447b232ab-goog

