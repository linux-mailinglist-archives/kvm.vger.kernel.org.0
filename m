Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE3E475066
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 02:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238811AbhLOBQK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 20:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235593AbhLOBQH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 20:16:07 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52D7C061574
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 17:16:06 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id 184-20020a6217c1000000b0049f9aad0040so12627850pfx.21
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 17:16:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=UZ+15oJmdjibeS/LqSfmbc4z9W6A6Fq/YCpfMYzK6Pc=;
        b=nBITaegwM6XU1MUrXN975MbS92biPy0aczHT4OisoI1XPyo/TdBL/jMDTmg7+WiyrB
         kR8yXkhMlvXlsxb2okrYmdLSN6IKvYBkZ8DDntbWfIQCme/EeQVm7fmHWTkBTrmWzy2F
         Idz73SMSrWCEs3jCU9QUxHDsw0kZiL/VqBh0A8ir2E5w487scdJoIes3WcPX6tQtI9+2
         BBbyAHheT92ORticthLWDyJpsE6TiS0S6QJTy7fke9X87aHPnq2FjM9L0JyjI0oEzrys
         t5+ca7pe5+wZrTGUj4BiBSeCEcyYJ7U3n8utoBpD6S7wVeohYMa1411rQRzKTye+Z0lH
         I7Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=UZ+15oJmdjibeS/LqSfmbc4z9W6A6Fq/YCpfMYzK6Pc=;
        b=HN9+g6p55MQwLeE1AxwOPcP+Di+720WHzt7IUzFnZq4Y+4yPeP9V88Hf+eqg/A0s3x
         N/kinB7mAnUE0CuX7Z+n4hMMmyjDDHN9pnuWEe5D5sCQ8c4lGNDQ6cY18XjbY2GJ/cGi
         wKTAAih9rPYqdIc5y6uQeWh7F65LESHuIbdpVTLFPTbATqjbdQaeMKVCfXxI0gPvL48B
         6Rxl6s71GM8x04l72tKIA+cYayKKnwdoJF3dub8dUuziehjKCGpjS4UKXO7imrj9v1VQ
         Wx8CmDSrBrprq07yJqveWNImPhoTNcfCZok9RyOdVv5FOKZY7PGPYsXLNuFR8w7PP0eF
         UO2g==
X-Gm-Message-State: AOAM532T++M7yeDzGRVJ6YJbJ9qhAUGrlMmov4Ddcnf/0htGYgywElpC
        gyjBioERI8DgDhPH01YuqEoEiMbDltA=
X-Google-Smtp-Source: ABdhPJw+AUfxjbDVFEpdrUOPYphZ3gJ393PRXkNdcigeg+9dXQ43jj1lgXGyzF5HZHsL2pOH7msOJxPUXsY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1a8b:: with SMTP id
 ng11mr9095066pjb.3.1639530966212; Tue, 14 Dec 2021 17:16:06 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 15 Dec 2021 01:15:57 +0000
In-Reply-To: <20211215011557.399940-1-seanjc@google.com>
Message-Id: <20211215011557.399940-5-seanjc@google.com>
Mime-Version: 1.0
References: <20211215011557.399940-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH 4/4] KVM: x86/mmu: Use common iterator for walking invalid TDP
 MMU roots
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that tdp_mmu_next_root() can process both valid and invalid roots,
extend it to be able to process _only_ invalid roots, add yet another
iterator macro for walking invalid roots, and use the new macro in
kvm_tdp_mmu_zap_invalidated_roots().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 76 ++++++++++++++------------------------
 1 file changed, 27 insertions(+), 49 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 577985fa001d..b6f7ba057f65 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -98,22 +98,34 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
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
  * @prev_root is released (the caller obviously must hold a reference to
  * @prev_root if it's non-NULL).
  *
- * If @only_valid is true, invalid roots are skipped.
+ * If @type is not ALL_ROOTS, (in)valid roots are skipped accordingly.
  *
  * Returns NULL if the end of tdp_mmu_roots was reached.
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
 		    kvm_tdp_mmu_get_root(kvm, next_root))
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
@@ -811,28 +826,6 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
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
@@ -843,36 +836,21 @@ static struct kvm_mmu_page *next_invalidated_root(struct kvm *kvm,
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
2.34.1.173.g76aa8bc2d0-goog

