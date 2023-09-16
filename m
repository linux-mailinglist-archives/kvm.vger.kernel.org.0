Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF8BD7A2CAE
	for <lists+kvm@lfdr.de>; Sat, 16 Sep 2023 02:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238461AbjIPAqo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 20:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238761AbjIPAqh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 20:46:37 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFC91BC
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 17:43:23 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-26d3d868529so2745476a91.2
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 17:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694824762; x=1695429562; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wv4J3NjpzA01KgOV3LplTe0R6P5qicH6Eu51IuLkMzI=;
        b=oKbvC4wv6JL7OXRLPqpVEciDDkj9kEqtFSERSsd3So8cKTT21k2VPJ5bvLboJm7PQt
         gTJhXN8edqZNhPuZ6qceg9MGcPcTgacvo34S5DL971kGPZTjzfE3S1wvMkXpYtwroJL5
         ksZuNs0nF5xqUz8vueJ89ztbEY1MenS1JCKIrMJStZhORyWhZjM3y8ZoJQ6HzMllMmLV
         ET+GNKizocLAU0mzK0bUSHPozsw/cled2EKvIlAAzvAaD+B7HNgzOj9mjL1tUZZwTC35
         z/IkpnxwGbHOwDDn3qHJ+mGCqFGTEmlqjHn2wlQyMsk1C0ghQ7D1b6uh/B5spTkT8s1T
         svoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694824762; x=1695429562;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wv4J3NjpzA01KgOV3LplTe0R6P5qicH6Eu51IuLkMzI=;
        b=PJQ9uhlPGFbx6QJSOXttnKN3QCnwr/ObwzRh9FrmJH6pE3IweF5CQ9wpxOtZ9FVhEV
         NTGL4fS5Sa+0kUpm1ILqkQ2G9RYzp1qWRx49sTRBfeG2qx3Y/vsXndnpNcy61+e7Um7u
         MKasp/HQaQ+YVNnylK+uJhB1VuYET590lhABxlasvGQ9u5Cb5w2XtldnCV73fD2719gq
         lVXBzfwJcWHOpvGprJSxuNqc89fKXFEzFzwZNukuow+OgCK3gBLxSMcpTLTuEd+1/3Eh
         UFe4iMRYDbXn4XzWO/ku+0GJGmPUKZPU/qTzA/EwbS5pOGw0unGJjpNsez7tEAU7XDlj
         IQIQ==
X-Gm-Message-State: AOJu0YxrwbXCPR/mT57ipfH/fBVUDv4HfaGRVErp6T9Atz2tZYdgu4fG
        B0vpCRxjCOUBKKFfHivDHAsjnfIFUjQ=
X-Google-Smtp-Source: AGHT+IFV7LBU2MjHfaO3j6WsFFUD+BLPEnJ2fwMM8AlTTakEc+8pry5OQhEbBHn2kiArPt2G4KXI9MedAwc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1044:b0:274:6af0:d75b with SMTP id
 gq4-20020a17090b104400b002746af0d75bmr77079pjb.7.1694824762252; Fri, 15 Sep
 2023 17:39:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Sep 2023 17:39:15 -0700
In-Reply-To: <20230916003916.2545000-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230916003916.2545000-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230916003916.2545000-3-seanjc@google.com>
Subject: [PATCH 2/3] KVM: x86/mmu: Take "shared" instead of "as_id" TDP MMU's
 yield-safe iterator
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pattara Teerapong <pteerapong@google.com>,
        David Stevens <stevensd@google.com>,
        Yiwei Zhang <zzyiwei@google.com>,
        Paul Hsia <paulhsia@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace the address space ID in for_each_tdp_mmu_root_yield_safe() with a
shared (vs. exclusive) param, and have the walker iterate over all address
spaces as all callers want to process all address spaces.  Drop the @as_id
param as well as the manual address space iteration in callers.

Add the @shared param even though the two current callers pass "false"
unconditionally, as the main reason for refactoring the walker is to
simplify using it to zap invalid TDP MMU roots, which is done with
mmu_lock held for read.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     |  8 ++------
 arch/x86/kvm/mmu/tdp_mmu.c | 20 ++++++++++----------
 arch/x86/kvm/mmu/tdp_mmu.h |  3 +--
 3 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 59f5e40b8f55..54f94f644b42 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6246,7 +6246,6 @@ static bool kvm_rmap_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_e
 void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 {
 	bool flush;
-	int i;
 
 	if (WARN_ON_ONCE(gfn_end <= gfn_start))
 		return;
@@ -6257,11 +6256,8 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 
 	flush = kvm_rmap_zap_gfn_range(kvm, gfn_start, gfn_end);
 
-	if (tdp_mmu_enabled) {
-		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-			flush = kvm_tdp_mmu_zap_leafs(kvm, i, gfn_start,
-						      gfn_end, flush);
-	}
+	if (tdp_mmu_enabled)
+		flush = kvm_tdp_mmu_zap_leafs(kvm, gfn_start, gfn_end, flush);
 
 	if (flush)
 		kvm_flush_remote_tlbs_range(kvm, gfn_start, gfn_end - gfn_start);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 89aaa2463373..7cb1902ae032 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -211,8 +211,12 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 #define for_each_valid_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared)	\
 	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, true)
 
-#define for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id)			\
-	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, false, false)
+#define for_each_tdp_mmu_root_yield_safe(_kvm, _root, _shared)			\
+	for (_root = tdp_mmu_next_root(_kvm, NULL, _shared, false);		\
+	     _root;								\
+	     _root = tdp_mmu_next_root(_kvm, _root, _shared, false))		\
+		if (!kvm_lockdep_assert_mmu_lock_held(_kvm, _shared)) {		\
+		} else
 
 /*
  * Iterate over all TDP MMU roots.  Requires that mmu_lock be held for write,
@@ -877,12 +881,11 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
  * true if a TLB flush is needed before releasing the MMU lock, i.e. if one or
  * more SPTEs were zapped since the MMU lock was last acquired.
  */
-bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
-			   bool flush)
+bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush)
 {
 	struct kvm_mmu_page *root;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id)
+	for_each_tdp_mmu_root_yield_safe(kvm, root, false)
 		flush = tdp_mmu_zap_leafs(kvm, root, start, end, true, flush);
 
 	return flush;
@@ -891,7 +894,6 @@ bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
 void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 {
 	struct kvm_mmu_page *root;
-	int i;
 
 	/*
 	 * Zap all roots, including invalid roots, as all SPTEs must be dropped
@@ -905,10 +907,8 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 	 * is being destroyed or the userspace VMM has exited.  In both cases,
 	 * KVM_RUN is unreachable, i.e. no vCPUs will ever service the request.
 	 */
-	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
-		for_each_tdp_mmu_root_yield_safe(kvm, root, i)
-			tdp_mmu_zap_root(kvm, root, false);
-	}
+	for_each_tdp_mmu_root_yield_safe(kvm, root, false)
+		tdp_mmu_zap_root(kvm, root, false);
 }
 
 /*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index eb4fa345d3a4..bc088953f929 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -20,8 +20,7 @@ __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			  bool shared);
 
-bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
-			   bool flush);
+bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush);
 bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
-- 
2.42.0.459.ge4e396fd5e-goog

