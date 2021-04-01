Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E0535240C
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 01:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236289AbhDAXiH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 19:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbhDAXiF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 19:38:05 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901F4C06178A
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 16:38:03 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id c70so4071087pga.1
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 16:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=iHsZD1Lw/LYYJ1Cq7wJwg1c9znwl+9Llm4slEnqhNMg=;
        b=TLLfxyHvRZMZRUdTOBH5X1eioAHEYmST6Z/ZP9D6zOmysFLlqLCwA/I7Ckd3N7U6Vf
         W76tfUFxKPjrO/RqVV7qcj/Q2peP2CFbp+TsX5dFdY+pv7/TFCr6F814tGix40vLDjyv
         UlnacuyvG0y4FjDcf6PP/2wnhcjIMAtGXo+IGsCIMntnyWEcLoM4OUgXQnU7UtFUZv8y
         XwXA2YOGCMt4vj0yBBbW+MO0toOTGJ2Vum344eri7se7uoQCo7cnWsBI8jqg/512jtJy
         Ufpk+Y1tUCqP3LJQJSHHb7utFAyu7F3w0saQZM05wwaOI2H+mBlbDRnAe+sLGPssyI4d
         n/4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=iHsZD1Lw/LYYJ1Cq7wJwg1c9znwl+9Llm4slEnqhNMg=;
        b=R/FdqfDUs5jyCTz0+uLdfyg2uq57FcqdFHACxXQWODG/7yTMO9UcUtM3W4tq2m2Gkn
         fGXFlQyZqR+qTeQwO02Numd3nKj3pZXfijlJrHZxKgDTohy6ZaPcNPXArPosbvt5BeGu
         5yj2sXUOwyxxF0dAuJMlC6V1enx9Q2cTRN2m7jwyXuZekEa1tUehVLXmGrnKqXSiKym0
         +dlHcACpECSBPq2yf2EfGjW06AtSYZoCdQT2TwEfp06o3pAHr2m/Fj+Uq5OVEqqkDCfo
         05yOMsZ3603zPHkeRinD48GyI/kOhtA99iWrPGmDvGAxK5pA3M5rploNlYjbv78nycf2
         Zqaw==
X-Gm-Message-State: AOAM531gtG2DTPQARYw5LiWoE1eli+J3U2eQR7r30SdrHkuZ/kTmpTCM
        Dq4wv8e1Y1Y4gGwLYcMtYO2IyZ5AauB+
X-Google-Smtp-Source: ABdhPJyWQYnn2lTNN6Z9lJ2FS4dT9s5uqzUqePGXz7SepbC16J49IowLYDblzKE6p8fyP6qs6e7EZN/VJOm3
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:e088:88b8:ea4a:22b6])
 (user=bgardon job=sendgmr) by 2002:a17:90b:fcb:: with SMTP id
 gd11mr586927pjb.0.1617320282777; Thu, 01 Apr 2021 16:38:02 -0700 (PDT)
Date:   Thu,  1 Apr 2021 16:37:27 -0700
In-Reply-To: <20210401233736.638171-1-bgardon@google.com>
Message-Id: <20210401233736.638171-5-bgardon@google.com>
Mime-Version: 1.0
References: <20210401233736.638171-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 04/13] KVM: x86/mmu: Merge TDP MMU put and free root
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_tdp_mmu_put_root and kvm_tdp_mmu_free_root are always called
together, so merge the functions to simplify TDP MMU root refcounting /
freeing.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c     |  4 +--
 arch/x86/kvm/mmu/tdp_mmu.c | 54 ++++++++++++++++++--------------------
 arch/x86/kvm/mmu/tdp_mmu.h | 10 +------
 3 files changed, 28 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9c7ef7ca8bf6..47d996a8074f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3153,8 +3153,8 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
 
 	sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
 
-	if (is_tdp_mmu_page(sp) && kvm_tdp_mmu_put_root(kvm, sp))
-		kvm_tdp_mmu_free_root(kvm, sp);
+	if (is_tdp_mmu_page(sp))
+		kvm_tdp_mmu_put_root(kvm, sp);
 	else if (!--sp->root_count && sp->role.invalid)
 		kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 320cc4454737..279a725061f7 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -41,10 +41,31 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 	rcu_barrier();
 }
 
-static void tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
+static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
+			  gfn_t start, gfn_t end, bool can_yield, bool flush);
+
+static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
 {
-	if (kvm_tdp_mmu_put_root(kvm, root))
-		kvm_tdp_mmu_free_root(kvm, root);
+	free_page((unsigned long)sp->spt);
+	kmem_cache_free(mmu_page_header_cache, sp);
+}
+
+void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
+{
+	gfn_t max_gfn = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	if (--root->root_count)
+		return;
+
+	WARN_ON(!root->tdp_mmu_page);
+
+	list_del(&root->link);
+
+	zap_gfn_range(kvm, root, 0, max_gfn, false, false);
+
+	tdp_mmu_free_sp(root);
 }
 
 static inline bool tdp_mmu_next_root_valid(struct kvm *kvm,
@@ -66,7 +87,7 @@ static inline struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 	struct kvm_mmu_page *next_root;
 
 	next_root = list_next_entry(root, link);
-	tdp_mmu_put_root(kvm, root);
+	kvm_tdp_mmu_put_root(kvm, root);
 	return next_root;
 }
 
@@ -89,31 +110,6 @@ static inline struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 		if (kvm_mmu_page_as_id(_root) != _as_id) {		\
 		} else
 
-static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
-			  gfn_t start, gfn_t end, bool can_yield, bool flush);
-
-static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
-{
-	free_page((unsigned long)sp->spt);
-	kmem_cache_free(mmu_page_header_cache, sp);
-}
-
-void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
-{
-	gfn_t max_gfn = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
-
-	lockdep_assert_held_write(&kvm->mmu_lock);
-
-	WARN_ON(root->root_count);
-	WARN_ON(!root->tdp_mmu_page);
-
-	list_del(&root->link);
-
-	zap_gfn_range(kvm, root, 0, max_gfn, false, false);
-
-	tdp_mmu_free_sp(root);
-}
-
 static union kvm_mmu_page_role page_role_for_level(struct kvm_vcpu *vcpu,
 						   int level)
 {
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index c9a081c786a5..d4e32ac5f4c9 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -6,7 +6,6 @@
 #include <linux/kvm_host.h>
 
 hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
-void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root);
 
 static inline void kvm_tdp_mmu_get_root(struct kvm *kvm,
 					struct kvm_mmu_page *root)
@@ -17,14 +16,7 @@ static inline void kvm_tdp_mmu_get_root(struct kvm *kvm,
 	++root->root_count;
 }
 
-static inline bool kvm_tdp_mmu_put_root(struct kvm *kvm,
-					struct kvm_mmu_page *root)
-{
-	lockdep_assert_held(&kvm->mmu_lock);
-	--root->root_count;
-
-	return !root->root_count;
-}
+void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root);
 
 bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
 				 gfn_t end, bool can_yield, bool flush);
-- 
2.31.0.208.g409f899ff0-goog

