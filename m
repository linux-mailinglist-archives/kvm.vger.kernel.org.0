Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3EE5352408
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 01:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236249AbhDAXhu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 19:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236174AbhDAXht (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 19:37:49 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA14AC0613E6
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 16:37:47 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id da16so4300564qvb.2
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 16:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8P7aZxCjuJ5mHZNN/fyn5NZd1hFw5LMjPE4YDmQpTUo=;
        b=PYqsGkQGYbLf03I6BWTIZpxaDBPOB+B3DpL44wRE2lLzOVdM4wycQA5qJM76xBSkUi
         4v7x2E0pjvyZ8USzcOI6q14z4JQDHi8mOsQSQcZKCoPsGRUH8PUz9Gu4l/lHX9/BXaln
         xdZtS/T57YDVGono5Xkosjp+4hqlIJQkyvAggic/ba4Vi+pmqjoi+5sxwABPt6NyjiOi
         7xGM4T0oFTeES2HVgaKRvVXYSYIinsanh5gUL2BDgmEVoeKhdM69kn3uiDucc8Hf+E5z
         Ou2iBBO/YebRVbOUkrNJ+fmxWmeK1rLnOnjFGpah7WpIMMeuFdnHz8Eo1hLFHsuCRLke
         ZIlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8P7aZxCjuJ5mHZNN/fyn5NZd1hFw5LMjPE4YDmQpTUo=;
        b=PW+nXHnYWn05ZruZYKP97RDHObPRxwzkc3iTPoomokqROo++GQCQmiguUVQRguu6jM
         HsJqPB/lkBB029aZVFZBUEWVyk9gXSjJ24aQy2oWbUMlESlXhCf+oXatQutgtezLlqS1
         /hDkfhvGC2ZpT12UggVqcpMlTBoUSAeyZ/Z/80xU5pS/H94IKAZWIFc9fqicZsvdaWr0
         DIpL1+uIUYu7NQZzzlXQLFpUb8a/qQTEs4WN/lNrDrYI/mdpULDcf3W5czFP4knsR8YZ
         2v2EUpnfWd1Jkgg6X7KfSddfAACoOUue3Zr8k/OV5wbO69ucniDiDFKcHYWHw+D805Os
         WHnA==
X-Gm-Message-State: AOAM5332qlBUc+gx98DsGO3B5mmVaQLHlMCRarkAIHzLOLPdfws8aBOa
        p07IygoABTe7/9gUXOVzWtGlJpz7QlIz
X-Google-Smtp-Source: ABdhPJyd2YyNHmeXkWiboT0mznkwOYNtUcmTYadnK3mM6TfYcShAQ40uIYxnwFladsk2J5eKZrfw0YdFGmth
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:e088:88b8:ea4a:22b6])
 (user=bgardon job=sendgmr) by 2002:a0c:bec3:: with SMTP id
 f3mr10596399qvj.49.1617320266944; Thu, 01 Apr 2021 16:37:46 -0700 (PDT)
Date:   Thu,  1 Apr 2021 16:37:25 -0700
In-Reply-To: <20210401233736.638171-1-bgardon@google.com>
Message-Id: <20210401233736.638171-3-bgardon@google.com>
Mime-Version: 1.0
References: <20210401233736.638171-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 02/13] KVM: x86/mmu: Move kvm_mmu_(get|put)_root to TDP MMU
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

The TDP MMU is almost the only user of kvm_mmu_get_root and
kvm_mmu_put_root. There is only one use of put_root in mmu.c for the
legacy / shadow MMU. Open code that one use and move the get / put
functions to the TDP MMU so they can be extended in future commits.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 10 ++++------
 arch/x86/kvm/mmu/mmu_internal.h | 16 ----------------
 arch/x86/kvm/mmu/tdp_mmu.c      |  6 +++---
 arch/x86/kvm/mmu/tdp_mmu.h      | 18 ++++++++++++++++++
 4 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 617809529987..9c7ef7ca8bf6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3153,12 +3153,10 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
 
 	sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
 
-	if (kvm_mmu_put_root(kvm, sp)) {
-		if (is_tdp_mmu_page(sp))
-			kvm_tdp_mmu_free_root(kvm, sp);
-		else if (sp->role.invalid)
-			kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
-	}
+	if (is_tdp_mmu_page(sp) && kvm_tdp_mmu_put_root(kvm, sp))
+		kvm_tdp_mmu_free_root(kvm, sp);
+	else if (!--sp->root_count && sp->role.invalid)
+		kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
 
 	*root_hpa = INVALID_PAGE;
 }
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index d44fe8a43a19..9347d73996b5 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -113,22 +113,6 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
 					u64 start_gfn, u64 pages);
 
-static inline void kvm_mmu_get_root(struct kvm *kvm, struct kvm_mmu_page *sp)
-{
-	BUG_ON(!sp->root_count);
-	lockdep_assert_held(&kvm->mmu_lock);
-
-	++sp->root_count;
-}
-
-static inline bool kvm_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *sp)
-{
-	lockdep_assert_held(&kvm->mmu_lock);
-	--sp->root_count;
-
-	return !sp->root_count;
-}
-
 static inline int kvm_mmu_role_as_id(union kvm_mmu_page_role role)
 {
 	return role.smm ? 1 : 0;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index d5210a212c59..6f612ac755a0 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -43,7 +43,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 
 static void tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
 {
-	if (kvm_mmu_put_root(kvm, root))
+	if (kvm_tdp_mmu_put_root(kvm, root))
 		kvm_tdp_mmu_free_root(kvm, root);
 }
 
@@ -55,7 +55,7 @@ static inline bool tdp_mmu_next_root_valid(struct kvm *kvm,
 	if (list_entry_is_head(root, &kvm->arch.tdp_mmu_roots, link))
 		return false;
 
-	kvm_mmu_get_root(kvm, root);
+	kvm_tdp_mmu_get_root(kvm, root);
 	return true;
 
 }
@@ -154,7 +154,7 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 	/* Check for an existing root before allocating a new one. */
 	for_each_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
 		if (root->role.word == role.word) {
-			kvm_mmu_get_root(kvm, root);
+			kvm_tdp_mmu_get_root(kvm, root);
 			goto out;
 		}
 	}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index d7007480b3d2..c9a081c786a5 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -8,6 +8,24 @@
 hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
 void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root);
 
+static inline void kvm_tdp_mmu_get_root(struct kvm *kvm,
+					struct kvm_mmu_page *root)
+{
+	BUG_ON(!root->root_count);
+	lockdep_assert_held(&kvm->mmu_lock);
+
+	++root->root_count;
+}
+
+static inline bool kvm_tdp_mmu_put_root(struct kvm *kvm,
+					struct kvm_mmu_page *root)
+{
+	lockdep_assert_held(&kvm->mmu_lock);
+	--root->root_count;
+
+	return !root->root_count;
+}
+
 bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
 				 gfn_t end, bool can_yield, bool flush);
 static inline bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id,
-- 
2.31.0.208.g409f899ff0-goog

