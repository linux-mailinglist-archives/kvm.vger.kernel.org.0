Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4E214CC639
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 20:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236087AbiCCTkX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 14:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236080AbiCCTj4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 14:39:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C799818F206
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 11:39:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646336341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sy+v4SkBwHawLiwYXtCKdY1Fyks8p2ZxQ8RL/396wcg=;
        b=LWBqOtsknxHtEXBSp31hkRwQyhGhJZZNABGoXo90x2hf3Pf0ovrBO+1i6Wz0c7WsfpDIHp
        Qu+S5zE6oLVxuCD9wc/uAyReRe5GryU2UeWl2KHQVi+Ed/krNlrg3ZNd6ibF6Ambf4qSo/
        oALD3vA3YbhL2I1jBy9/qB7ukMk5eTY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-eaDgom72Oy-4w5Mlkwn1sA-1; Thu, 03 Mar 2022 14:38:58 -0500
X-MC-Unique: eaDgom72Oy-4w5Mlkwn1sA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66EF7824FA8;
        Thu,  3 Mar 2022 19:38:57 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 54CDA5DF2E;
        Thu,  3 Mar 2022 19:38:56 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: [PATCH v4 13/30] KVM: x86/mmu: Refactor low-level TDP MMU set SPTE helper to take raw values
Date:   Thu,  3 Mar 2022 14:38:25 -0500
Message-Id: <20220303193842.370645-14-pbonzini@redhat.com>
In-Reply-To: <20220303193842.370645-1-pbonzini@redhat.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Refactor __tdp_mmu_set_spte() to work with raw values instead of a
tdp_iter objects so that a future patch can modify SPTEs without doing a
walk, and without having to synthesize a tdp_iter.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Message-Id: <20220226001546.360188-13-seanjc@google.com>
Reviewed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 51 +++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 41175ee7e111..0ffa62abde2d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -603,9 +603,13 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 
 /*
  * __tdp_mmu_set_spte - Set a TDP MMU SPTE and handle the associated bookkeeping
- * @kvm: kvm instance
- * @iter: a tdp_iter instance currently on the SPTE that should be set
- * @new_spte: The value the SPTE should be set to
+ * @kvm:	      KVM instance
+ * @as_id:	      Address space ID, i.e. regular vs. SMM
+ * @sptep:	      Pointer to the SPTE
+ * @old_spte:	      The current value of the SPTE
+ * @new_spte:	      The new value that will be set for the SPTE
+ * @gfn:	      The base GFN that was (or will be) mapped by the SPTE
+ * @level:	      The level _containing_ the SPTE (its parent PT's level)
  * @record_acc_track: Notify the MM subsystem of changes to the accessed state
  *		      of the page. Should be set unless handling an MMU
  *		      notifier for access tracking. Leaving record_acc_track
@@ -617,12 +621,10 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
  *		      Leaving record_dirty_log unset in that case prevents page
  *		      writes from being double counted.
  */
-static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
-				      u64 new_spte, bool record_acc_track,
-				      bool record_dirty_log)
+static void __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
+			       u64 old_spte, u64 new_spte, gfn_t gfn, int level,
+			       bool record_acc_track, bool record_dirty_log)
 {
-	WARN_ON_ONCE(iter->yielded);
-
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	/*
@@ -632,39 +634,48 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 	 * should be used. If operating under the MMU lock in write mode, the
 	 * use of the removed SPTE should not be necessary.
 	 */
-	WARN_ON(is_removed_spte(iter->old_spte) || is_removed_spte(new_spte));
+	WARN_ON(is_removed_spte(old_spte) || is_removed_spte(new_spte));
 
-	kvm_tdp_mmu_write_spte(iter->sptep, new_spte);
+	kvm_tdp_mmu_write_spte(sptep, new_spte);
+
+	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
 
-	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
-			      new_spte, iter->level, false);
 	if (record_acc_track)
-		handle_changed_spte_acc_track(iter->old_spte, new_spte,
-					      iter->level);
+		handle_changed_spte_acc_track(old_spte, new_spte, level);
 	if (record_dirty_log)
-		handle_changed_spte_dirty_log(kvm, iter->as_id, iter->gfn,
-					      iter->old_spte, new_spte,
-					      iter->level);
+		handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte,
+					      new_spte, level);
+}
+
+static inline void _tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
+				     u64 new_spte, bool record_acc_track,
+				     bool record_dirty_log)
+{
+	WARN_ON_ONCE(iter->yielded);
+
+	__tdp_mmu_set_spte(kvm, iter->as_id, iter->sptep, iter->old_spte,
+			   new_spte, iter->gfn, iter->level,
+			   record_acc_track, record_dirty_log);
 }
 
 static inline void tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 				    u64 new_spte)
 {
-	__tdp_mmu_set_spte(kvm, iter, new_spte, true, true);
+	_tdp_mmu_set_spte(kvm, iter, new_spte, true, true);
 }
 
 static inline void tdp_mmu_set_spte_no_acc_track(struct kvm *kvm,
 						 struct tdp_iter *iter,
 						 u64 new_spte)
 {
-	__tdp_mmu_set_spte(kvm, iter, new_spte, false, true);
+	_tdp_mmu_set_spte(kvm, iter, new_spte, false, true);
 }
 
 static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
 						 struct tdp_iter *iter,
 						 u64 new_spte)
 {
-	__tdp_mmu_set_spte(kvm, iter, new_spte, true, false);
+	_tdp_mmu_set_spte(kvm, iter, new_spte, true, false);
 }
 
 #define tdp_root_for_each_pte(_iter, _root, _start, _end) \
-- 
2.31.1


