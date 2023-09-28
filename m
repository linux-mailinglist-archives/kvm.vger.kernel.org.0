Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC2EF7B2258
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 18:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbjI1Qay (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 12:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbjI1Qat (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 12:30:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6733F199
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 09:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695918602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UdQ8vFIkrjKHPjmY3S0MSAG68uzsObzQSGb5suxbmVU=;
        b=evfgmgJMDgk4owxFK1fg0k09RmLCWR6RNrnqtS63T715lfy/HzomjiOB5Dj/6v+jZQ2/7G
        OYjlpimna0RgSMsbirXWRDPvOt6NkUWTGCmdU8cpNMKv7PKDQ6SqIVwaZ5nq0KHNKKkfMF
        P6mJPxYAPR8EfDjqsye3Gh+JpB79SyM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-rVPCVgeKMlSnVbd3S2fAzQ-1; Thu, 28 Sep 2023 12:30:00 -0400
X-MC-Unique: rVPCVgeKMlSnVbd3S2fAzQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F475185A78E;
        Thu, 28 Sep 2023 16:30:00 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 466F9140E969;
        Thu, 28 Sep 2023 16:30:00 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 2/3] KVM: x86/mmu: remove unnecessary "bool shared" argument from iterators
Date:   Thu, 28 Sep 2023 12:29:58 -0400
Message-Id: <20230928162959.1514661-3-pbonzini@redhat.com>
In-Reply-To: <20230928162959.1514661-1-pbonzini@redhat.com>
References: <20230928162959.1514661-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The "bool shared" argument is more or less unnecessary in the
for_each_*_tdp_mmu_root_yield_safe() macros.  Many users check for
the lock before calling it; all of them either call small functions
that do the check, or end up calling tdp_mmu_set_spte_atomic() and
tdp_mmu_iter_set_spte().  Add a few assertions to make up for the
lost check in for_each_*_tdp_mmu_root_yield_safe(), but even this
is probably overkill and mostly for documentation reasons.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 42 +++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index ab0876015be7..b9abfa78808a 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -155,23 +155,20 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
  * If shared is set, this function is operating under the MMU lock in read
  * mode.
  */
-#define __for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, _only_valid)\
+#define __for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _only_valid)\
 	for (_root = tdp_mmu_next_root(_kvm, NULL, _only_valid);	\
 	     _root;							\
 	     _root = tdp_mmu_next_root(_kvm, _root, _only_valid))	\
-		if (kvm_lockdep_assert_mmu_lock_held(_kvm, _shared) &&		\
-		    kvm_mmu_page_as_id(_root) != _as_id) {			\
+		if (kvm_mmu_page_as_id(_root) != _as_id) {		\
 		} else
 
-#define for_each_valid_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared)	\
-	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, true)
+#define for_each_valid_tdp_mmu_root_yield_safe(_kvm, _root, _as_id)	\
+	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, true)
 
-#define for_each_tdp_mmu_root_yield_safe(_kvm, _root, _shared)			\
+#define for_each_tdp_mmu_root_yield_safe(_kvm, _root)			\
 	for (_root = tdp_mmu_next_root(_kvm, NULL, false);		\
 	     _root;							\
 	     _root = tdp_mmu_next_root(_kvm, _root, false))
-		if (!kvm_lockdep_assert_mmu_lock_held(_kvm, _shared)) {		\
-		} else
 
 /*
  * Iterate over all TDP MMU roots.  Requires that mmu_lock be held for write,
@@ -840,7 +837,8 @@ bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush)
 {
 	struct kvm_mmu_page *root;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root, false)
+	lockdep_assert_held_write(&kvm->mmu_lock);
+	for_each_tdp_mmu_root_yield_safe(kvm, root)
 		flush = tdp_mmu_zap_leafs(kvm, root, start, end, true, flush);
 
 	return flush;
@@ -862,7 +860,8 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 	 * is being destroyed or the userspace VMM has exited.  In both cases,
 	 * KVM_RUN is unreachable, i.e. no vCPUs will ever service the request.
 	 */
-	for_each_tdp_mmu_root_yield_safe(kvm, root, false)
+	lockdep_assert_held_write(&kvm->mmu_lock);
+	for_each_tdp_mmu_root_yield_safe(kvm, root)
 		tdp_mmu_zap_root(kvm, root, false);
 }
 
@@ -876,7 +875,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 
 	read_lock(&kvm->mmu_lock);
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root, true) {
+	for_each_tdp_mmu_root_yield_safe(kvm, root) {
 		if (!root->tdp_mmu_scheduled_root_to_zap)
 			continue;
 
@@ -899,7 +898,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 		 * the root must be reachable by mmu_notifiers while it's being
 		 * zapped
 		 */
-		kvm_tdp_mmu_put_root(kvm, root, true);
+		kvm_tdp_mmu_put_root(kvm, root);
 	}
 
 	read_unlock(&kvm->mmu_lock);
@@ -1133,7 +1132,9 @@ bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 {
 	struct kvm_mmu_page *root;
 
-	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, false, false)
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, false)
 		flush = tdp_mmu_zap_leafs(kvm, root, range->start, range->end,
 					  range->may_block, flush);
 
@@ -1322,7 +1323,7 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
-	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
+	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id)
 		spte_set |= wrprot_gfn_range(kvm, root, slot->base_gfn,
 			     slot->base_gfn + slot->npages, min_level);
 
@@ -1354,6 +1355,8 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 {
 	struct kvm_mmu_page *sp;
 
+	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
+
 	/*
 	 * Since we are allocating while under the MMU lock we have to be
 	 * careful about GFP flags. Use GFP_NOWAIT to avoid blocking on direct
@@ -1504,11 +1507,10 @@ void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
 	int r = 0;
 
 	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
-
-	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, shared) {
+	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id) {
 		r = tdp_mmu_split_huge_pages_root(kvm, root, start, end, target_level, shared);
 		if (r) {
-			kvm_tdp_mmu_put_root(kvm, root, shared);
+			kvm_tdp_mmu_put_root(kvm, root);
 			break;
 		}
 	}
@@ -1568,8 +1570,7 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm,
 	bool spte_set = false;
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
-
-	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
+	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id)
 		spte_set |= clear_dirty_gfn_range(kvm, root, slot->base_gfn,
 				slot->base_gfn + slot->npages);
 
@@ -1703,8 +1704,7 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 	struct kvm_mmu_page *root;
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
-
-	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
+	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id)
 		zap_collapsible_spte_range(kvm, root, slot);
 }
 
-- 
2.39.1


