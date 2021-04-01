Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7909E352412
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 01:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236389AbhDAXiU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 19:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236321AbhDAXiQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 19:38:16 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A66C061797
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 16:38:11 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id j4so4070853pgs.18
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 16:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jyvW4LNHh147mdThm9gosLlXYiBlNPi18fgfUMETNdI=;
        b=Ls53YaRSYleBvtnGSnOtnGhpJ+KAGk+cAjcd6YVP/n1m+LchacpRgKeT3kK2zR8rfI
         w4ph7/7nn7Oo/slE/ICq8USQGPcNNLOWpHko7IsGkAwKaSE2fizCBw+EkZWa6STw6OeJ
         wDwd6hx59PKT0yqYjwxfm9TPEeDA582DN1F8kRcudjoqevO7NxCPcXN/Dytliaz8Z2tg
         U/24p0P6U+CiIvCzCBl8YWSgqkmvqo44c98AB1Niv9JraoS2SeB5peAUh2feiu8sm25X
         X24W/lgHQEqHVevHOMTc86AzOiqBHnZ0wsoRPaX9oWHgicSnZ/0HiZAJ+c1YQVUwlFvv
         0AQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jyvW4LNHh147mdThm9gosLlXYiBlNPi18fgfUMETNdI=;
        b=EXRezf2SZZiXFVbu5xb6D5UMKCjX25Eh6gSqr2iv9VXQcPUM2sPg9dql+rSu86rcjq
         nWzdfvyTXPitAP3qG1d0hEpxMzDKCxB4RQtx+nNilpN0+7Jzzbkwjbsf3kPgSrgsyptn
         MMvB5yafJ8K46xgiaasL4YENrnztT0FlGBl7OFA1pvTh1dAzxzbNfEEJLFlpbT6PZ3wn
         Kcwa74mTqzx26XZLrK0fcatL8BcccS9ZTIkp07tGLjbVQXsVukAJmKmtICTja+WPRoAJ
         SEUTDs3ykmnYPWtC1BaSpcVpvkSEIabsuZG/14VazCMp3JcgfIK0XbquGErgkgxSlW2+
         tu2Q==
X-Gm-Message-State: AOAM532nIh+w6rMmlTYj3XaVjDGpS9CVrvhNYUd3wjkyrZDMzrTdE7KS
        9+Sq+9uiMieu/lFxex0YIaaVKgLHluwk
X-Google-Smtp-Source: ABdhPJxQDpBYMeHhgFid5KdIpSvqSiyYK3tQXEPJMuHmLxfp8z14DglaxX1A9e7pcuiYwLUiiF4Od+d8RuU9
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:e088:88b8:ea4a:22b6])
 (user=bgardon job=sendgmr) by 2002:a17:902:d351:b029:e8:ba10:e6f5 with SMTP
 id l17-20020a170902d351b02900e8ba10e6f5mr1117239plk.82.1617320290640; Thu, 01
 Apr 2021 16:38:10 -0700 (PDT)
Date:   Thu,  1 Apr 2021 16:37:30 -0700
In-Reply-To: <20210401233736.638171-1-bgardon@google.com>
Message-Id: <20210401233736.638171-8-bgardon@google.com>
Mime-Version: 1.0
References: <20210401233736.638171-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 07/13] KVM: x86/mmu: handle cmpxchg failure in kvm_tdp_mmu_get_root
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

To reduce dependence on the MMU write lock, don't rely on the assumption
that the atomic operation in kvm_tdp_mmu_get_root will always succeed.
By not relying on that assumption, threads do not need to hold the MMU
lock in write mode in order to take a reference on a TDP MMU root.

In the root iterator, this change means that some roots might have to be
skipped if they are found to have a zero refcount. This will still never
happen as of this patch, but a future patch will need that flexibility to
make the root iterator safe under the MMU read lock.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 11 ++++++-----
 arch/x86/kvm/mmu/tdp_mmu.h | 13 +++----------
 2 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 697ea882a3e4..886bc170f2a5 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -88,10 +88,12 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 		next_root = list_first_entry(&kvm->arch.tdp_mmu_roots,
 					     typeof(*next_root), link);
 
+	while (!list_entry_is_head(next_root, &kvm->arch.tdp_mmu_roots, link) &&
+	       !kvm_tdp_mmu_get_root(kvm, next_root))
+		next_root = list_next_entry(next_root, link);
+
 	if (list_entry_is_head(next_root, &kvm->arch.tdp_mmu_roots, link))
 		next_root = NULL;
-	else
-		kvm_tdp_mmu_get_root(kvm, next_root);
 
 	if (prev_root)
 		kvm_tdp_mmu_put_root(kvm, prev_root);
@@ -161,10 +163,9 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 
 	/* Check for an existing root before allocating a new one. */
 	for_each_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
-		if (root->role.word == role.word) {
-			kvm_tdp_mmu_get_root(kvm, root);
+		if (root->role.word == role.word &&
+		    kvm_tdp_mmu_get_root(kvm, root))
 			goto out;
-		}
 	}
 
 	root = alloc_tdp_mmu_page(vcpu, 0, vcpu->arch.mmu->shadow_root_level);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 1ec7914ecff9..f0a26214e999 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -7,17 +7,10 @@
 
 hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
 
-static inline void kvm_tdp_mmu_get_root(struct kvm *kvm,
-					struct kvm_mmu_page *root)
+__must_check static inline bool kvm_tdp_mmu_get_root(struct kvm *kvm,
+						     struct kvm_mmu_page *root)
 {
-	lockdep_assert_held_write(&kvm->mmu_lock);
-
-	/*
-	 * This should never fail since roots are removed from the roots
-	 * list under the MMU write lock when their reference count falls
-	 * to zero.
-	 */
-	refcount_inc_not_zero(&root->tdp_mmu_root_count);
+	return refcount_inc_not_zero(&root->tdp_mmu_root_count);
 }
 
 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root);
-- 
2.31.0.208.g409f899ff0-goog

