Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9052D4C5271
	for <lists+kvm@lfdr.de>; Sat, 26 Feb 2022 01:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240090AbiBZAQh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 19:16:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240067AbiBZAQg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 19:16:36 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638842118F9
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:03 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id g19-20020a17090a579300b001b9d80f3714so4104179pji.7
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ZZBR7JFqEgpZm8jnS4/juRTRiIa97p0dVPrcdd7xFkE=;
        b=mUvLUVTIJXmMVDDZlI7ha2WbQOI90g3pkRHk/HCDPswvyM6eoRW7bWE8/cjKeH5LTQ
         8crsCHf5SZ9IVsljfPwQRCzOgmPq0QxaeQUmE0CwVLjfgFoq6lmV8CWUYDBIInO6YmRY
         U99LRb+0Ju9wDjYyV8Pu5p/N6ItE+U07M8Qma1L5UexQ7dn+BfqlYHP0ObcgZvMiDnr5
         6C/oDYC8QGiHdjvp8URsrDQYR1XoAxjg1xUu9h835fwzi5DWg4Z4lz2z+M/oxpGWvhuD
         tnfV0wpbU5JDuphYCRQwGDW9KCCQXUVj0mjOfihWKQc3is3uUFawDsvAb0rAn2YE64bK
         QS7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ZZBR7JFqEgpZm8jnS4/juRTRiIa97p0dVPrcdd7xFkE=;
        b=R36idkjzLjPmcF5Qp++28J+V7w37O/hCiGBWDBh09NhI2ENKh1udgVTGfmKtJ/g3Bk
         SlPGD/t3RNEQDAkkHp11k+BFC/1yIMzt02EiIt+6pvjSRCQpVjERAJfyH+97uAeKo5Vb
         tWmBWjRPaiRTx3WgAtaxXwAZQmNX6uf2qJ3ScP1iXlBMtZZDqG2HztJTZFkKh5gJw+hh
         X3i1qyBC8tq+nSiCL+eZ3h9E3ju0y9HJQ5Sno2IqWhu4QefKWC0Xb8IYxgdfStVtrHb/
         sKQpvJhrOjgPTOy5phInFP1XdiQIxqUaQg/ZuqTuXJ7HSfD1WoLA4u8fm1sgvzRN5jb2
         oHBw==
X-Gm-Message-State: AOAM533X173mkFvOdX/3GjXlhCk8nYU5WcJq9kifyh/PN0bHu7yxRnwO
        2Ak7Khxm8WuhxhsAo0qGkUYDwoHGUcs=
X-Google-Smtp-Source: ABdhPJz9WJWelElLxPoSbSX0aEe4XxeFTg2wwVfmdEUYCN4ODT/RvQ3HZRw9l9bEfE7UbG6g/T3mTDbOp1M=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:e317:0:b0:4ca:25ee:d633 with SMTP id
 g23-20020a62e317000000b004ca25eed633mr10229857pfh.23.1645834562766; Fri, 25
 Feb 2022 16:16:02 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 26 Feb 2022 00:15:19 +0000
In-Reply-To: <20220226001546.360188-1-seanjc@google.com>
Message-Id: <20220226001546.360188-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220226001546.360188-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v3 01/28] KVM: x86/mmu: Use common iterator for walking
 invalid TDP MMU roots
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
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

Now that tdp_mmu_next_root() can process both valid and invalid roots,
extend it to be able to process _only_ invalid roots, add yet another
iterator macro for walking invalid roots, and use the new macro in
kvm_tdp_mmu_zap_invalidated_roots().

No functional change intended.

Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 74 ++++++++++++++------------------------
 1 file changed, 26 insertions(+), 48 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index debf08212f12..25148e8b711d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -98,6 +98,12 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
 
+enum tdp_mmu_roots_iter_type {
+	ALL_ROOTS = -1,
+	VALID_ROOTS = 0,
+	INVALID_ROOTS = 1,
+};
+
 /*
  * Returns the next root after @prev_root (or the first root if @prev_root is
  * NULL).  A reference to the returned root is acquired, and the reference to
@@ -110,10 +116,16 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
  */
 static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 					      struct kvm_mmu_page *prev_root,
-					      bool shared, bool only_valid)
+					      bool shared,
+					      enum tdp_mmu_roots_iter_type type)
 {
 	struct kvm_mmu_page *next_root;
 
+	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
+
+	/* Ensure correctness for the below comparison against role.invalid. */
+	BUILD_BUG_ON(!!VALID_ROOTS || !INVALID_ROOTS);
+
 	rcu_read_lock();
 
 	if (prev_root)
@@ -125,7 +137,7 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 						   typeof(*next_root), link);
 
 	while (next_root) {
-		if ((!only_valid || !next_root->role.invalid) &&
+		if ((type == ALL_ROOTS || (type == !!next_root->role.invalid)) &&
 		    kvm_tdp_mmu_get_root(next_root))
 			break;
 
@@ -151,18 +163,21 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
  * mode. In the unlikely event that this thread must free a root, the lock
  * will be temporarily dropped and reacquired in write mode.
  */
-#define __for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, _only_valid)\
-	for (_root = tdp_mmu_next_root(_kvm, NULL, _shared, _only_valid);	\
+#define __for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, _type) \
+	for (_root = tdp_mmu_next_root(_kvm, NULL, _shared, _type);		\
 	     _root;								\
-	     _root = tdp_mmu_next_root(_kvm, _root, _shared, _only_valid))	\
-		if (kvm_mmu_page_as_id(_root) != _as_id) {			\
+	     _root = tdp_mmu_next_root(_kvm, _root, _shared, _type))		\
+		if (_as_id > 0 && kvm_mmu_page_as_id(_root) != _as_id) {	\
 		} else
 
+#define for_each_invalid_tdp_mmu_root_yield_safe(_kvm, _root)			\
+	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, -1, true, INVALID_ROOTS)
+
 #define for_each_valid_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared)	\
-	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, true)
+	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, VALID_ROOTS)
 
 #define for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared)		\
-	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, false)
+	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, ALL_ROOTS)
 
 #define for_each_tdp_mmu_root(_kvm, _root, _as_id)				\
 	list_for_each_entry_rcu(_root, &_kvm->arch.tdp_mmu_roots, link,		\
@@ -810,28 +825,6 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 		kvm_flush_remote_tlbs(kvm);
 }
 
-static struct kvm_mmu_page *next_invalidated_root(struct kvm *kvm,
-						  struct kvm_mmu_page *prev_root)
-{
-	struct kvm_mmu_page *next_root;
-
-	if (prev_root)
-		next_root = list_next_or_null_rcu(&kvm->arch.tdp_mmu_roots,
-						  &prev_root->link,
-						  typeof(*prev_root), link);
-	else
-		next_root = list_first_or_null_rcu(&kvm->arch.tdp_mmu_roots,
-						   typeof(*next_root), link);
-
-	while (next_root && !(next_root->role.invalid &&
-			      refcount_read(&next_root->tdp_mmu_root_count)))
-		next_root = list_next_or_null_rcu(&kvm->arch.tdp_mmu_roots,
-						  &next_root->link,
-						  typeof(*next_root), link);
-
-	return next_root;
-}
-
 /*
  * Since kvm_tdp_mmu_zap_all_fast has acquired a reference to each
  * invalidated root, they will not be freed until this function drops the
@@ -842,36 +835,21 @@ static struct kvm_mmu_page *next_invalidated_root(struct kvm *kvm,
  */
 void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 {
-	struct kvm_mmu_page *next_root;
 	struct kvm_mmu_page *root;
 	bool flush = false;
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
-	rcu_read_lock();
-
-	root = next_invalidated_root(kvm, NULL);
-
-	while (root) {
-		next_root = next_invalidated_root(kvm, root);
-
-		rcu_read_unlock();
-
+	for_each_invalid_tdp_mmu_root_yield_safe(kvm, root) {
 		flush = zap_gfn_range(kvm, root, 0, -1ull, true, flush, true);
 
 		/*
-		 * Put the reference acquired in
-		 * kvm_tdp_mmu_invalidate_roots
+		 * Put the reference acquired in kvm_tdp_mmu_invalidate_roots().
+		 * Note, the iterator holds its own reference.
 		 */
 		kvm_tdp_mmu_put_root(kvm, root, true);
-
-		root = next_root;
-
-		rcu_read_lock();
 	}
 
-	rcu_read_unlock();
-
 	if (flush)
 		kvm_flush_remote_tlbs(kvm);
 }
-- 
2.35.1.574.g5d30c73bfb-goog

