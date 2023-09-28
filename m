Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 019907B2260
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 18:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbjI1QbF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 12:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231397AbjI1Qa7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 12:30:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237A41A5
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 09:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695918611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D9/RV6Hb0/JilJv3mz6TN4Le2K6hQ3WCfVt/3YM6beE=;
        b=EjJ2//4XeALfT8yYhuRvZ6/iRb1ceW9m41qG9AboM0W4i9eHbwZl0WNr5go8bzidp6/FBo
        2TzN5iRlAiq3jOzF+/khXardaNSk+ceysj3JkEkUtwZx+Ck8DdvrqTig891/jCDJYh0nO9
        wA+swCte6+QdCQ/VWVWnFp1iGOpQrMM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-204-jWNZzshsOFiCkpO4G53Aiw-1; Thu, 28 Sep 2023 12:30:02 -0400
X-MC-Unique: jWNZzshsOFiCkpO4G53Aiw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F17B858293;
        Thu, 28 Sep 2023 16:30:00 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26BEE140E969;
        Thu, 28 Sep 2023 16:30:00 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 1/3] KVM: x86/mmu: remove unnecessary "bool shared" argument from functions
Date:   Thu, 28 Sep 2023 12:29:57 -0400
Message-Id: <20230928162959.1514661-2-pbonzini@redhat.com>
In-Reply-To: <20230928162959.1514661-1-pbonzini@redhat.com>
References: <20230928162959.1514661-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Neither tdp_mmu_next_root nor kvm_tdp_mmu_put_root need to know
if the lock is taken for read or write.  Either way, protection
is achieved via RCU and tdp_mmu_pages_lock.  Remove the argument
and just assert that the lock is taken.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c     |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c | 34 +++++++++++++++++++++-------------
 arch/x86/kvm/mmu/tdp_mmu.h |  3 +--
 3 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f7901cb4d2fa..64b1bdba943e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3548,7 +3548,7 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
 		return;
 
 	if (is_tdp_mmu_page(sp))
-		kvm_tdp_mmu_put_root(kvm, sp, false);
+		kvm_tdp_mmu_put_root(kvm, sp);
 	else if (!--sp->root_count && sp->role.invalid)
 		kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6cd4dd631a2f..ab0876015be7 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -73,10 +73,13 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
 	tdp_mmu_free_sp(sp);
 }
 
-void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
-			  bool shared)
+void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
 {
-	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
+	/*
+	 * Either read or write is okay, but the lock is needed because
+	 * writers might not take tdp_mmu_pages_lock.
+	 */
+	lockdep_assert_held(&kvm->mmu_lock);
 
 	if (!refcount_dec_and_test(&root->tdp_mmu_root_count))
 		return;
@@ -106,10 +109,16 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
  */
 static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 					      struct kvm_mmu_page *prev_root,
-					      bool shared, bool only_valid)
+					      bool only_valid)
 {
 	struct kvm_mmu_page *next_root;
 
+	/*
+	 * While the roots themselves are RCU-protected, fields such as
+	 * role.invalid are protected by mmu_lock.
+	 */
+	lockdep_assert_held(&kvm->mmu_lock);
+
 	rcu_read_lock();
 
 	if (prev_root)
@@ -132,7 +141,7 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 	rcu_read_unlock();
 
 	if (prev_root)
-		kvm_tdp_mmu_put_root(kvm, prev_root, shared);
+		kvm_tdp_mmu_put_root(kvm, prev_root);
 
 	return next_root;
 }
@@ -144,13 +153,12 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
  * recent root. (Unless keeping a live reference is desirable.)
  *
  * If shared is set, this function is operating under the MMU lock in read
- * mode. In the unlikely event that this thread must free a root, the lock
- * will be temporarily dropped and reacquired in write mode.
+ * mode.
  */
 #define __for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, _only_valid)\
-	for (_root = tdp_mmu_next_root(_kvm, NULL, _shared, _only_valid);	\
-	     _root;								\
-	     _root = tdp_mmu_next_root(_kvm, _root, _shared, _only_valid))	\
+	for (_root = tdp_mmu_next_root(_kvm, NULL, _only_valid);	\
+	     _root;							\
+	     _root = tdp_mmu_next_root(_kvm, _root, _only_valid))	\
 		if (kvm_lockdep_assert_mmu_lock_held(_kvm, _shared) &&		\
 		    kvm_mmu_page_as_id(_root) != _as_id) {			\
 		} else
@@ -159,9 +167,9 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, true)
 
 #define for_each_tdp_mmu_root_yield_safe(_kvm, _root, _shared)			\
-	for (_root = tdp_mmu_next_root(_kvm, NULL, _shared, false);		\
-	     _root;								\
-	     _root = tdp_mmu_next_root(_kvm, _root, _shared, false))		\
+	for (_root = tdp_mmu_next_root(_kvm, NULL, false);		\
+	     _root;							\
+	     _root = tdp_mmu_next_root(_kvm, _root, false))
 		if (!kvm_lockdep_assert_mmu_lock_held(_kvm, _shared)) {		\
 		} else
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 733a3aef3a96..20d97aa46c49 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -17,8 +17,7 @@ __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
 	return refcount_inc_not_zero(&root->tdp_mmu_root_count);
 }
 
-void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
-			  bool shared);
+void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root);
 
 bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush);
 bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
-- 
2.39.1


