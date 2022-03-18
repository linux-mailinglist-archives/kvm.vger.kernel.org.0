Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEA14DDF47
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 17:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239325AbiCRQsV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 12:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239211AbiCRQsV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 12:48:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 179F22B04F5
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 09:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647622021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zJxxfiqWeV928wIFzDvUgwTHej56l1Ux3PCeiMRY0A4=;
        b=MUvOZHJ4JVK6EtjN6pKJOMQDKWAiIECC9unEHJgoNmKMUa6SWPlalTmwS5AwbuOFouNp36
        TfW9uVp2P/QY3chWcwd6Hhkroa8A4H/Q5A5rth7vEfthVHo52fHN0DhuXUWMXHN3gkgzTf
        iRxVWw8y2Hj++9jTsZ2I41VGoJgW7og=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-511-f2MXQznNPpaAp2Uiry8KxA-1; Fri, 18 Mar 2022 12:46:58 -0400
X-MC-Unique: f2MXQznNPpaAp2Uiry8KxA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C090985A5BC;
        Fri, 18 Mar 2022 16:46:57 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A3E354292CB;
        Fri, 18 Mar 2022 16:46:57 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH] Revert "KVM: x86/mmu: Zap only TDP MMU leafs in kvm_zap_gfn_range()"
Date:   Fri, 18 Mar 2022 12:46:57 -0400
Message-Id: <20220318164657.2743860-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This reverts commit cf3e26427c08ad9015956293ab389004ac6a338e.

Multi-vCPU Hyper-V guests started crashing randomly on boot with the
latest kvm/queue and the problem can be bisected the problem to this
particular patch. Basically, I'm not able to boot e.g. 16-vCPU guest
successfully anymore. Both Intel and AMD seem to be affected. Reverting
the commit saves the day.

Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c     |  4 ++--
 arch/x86/kvm/mmu/tdp_mmu.c | 41 ++++++++++++++++++++++++++++----------
 arch/x86/kvm/mmu/tdp_mmu.h |  8 +++++++-
 3 files changed, 39 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3b8da8b0745e..51671cb34fb6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5842,8 +5842,8 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 
 	if (is_tdp_mmu_enabled(kvm)) {
 		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-			flush = kvm_tdp_mmu_zap_leafs(kvm, i, gfn_start,
-						      gfn_end, true, flush);
+			flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, gfn_start,
+							  gfn_end, flush);
 	}
 
 	if (flush)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index af60922906ef..87d8910c9ac2 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -906,8 +906,10 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 }
 
 /*
- * Zap leafs SPTEs for the range of gfns, [start, end). Returns true if SPTEs
- * have been cleared and a TLB flush is needed before releasing the MMU lock.
+ * Tears down the mappings for the range of gfns, [start, end), and frees the
+ * non-root pages mapping GFNs strictly within that range. Returns true if
+ * SPTEs have been cleared and a TLB flush is needed before releasing the
+ * MMU lock.
  *
  * If can_yield is true, will release the MMU lock and reschedule if the
  * scheduler needs the CPU or there is contention on the MMU lock. If this
@@ -915,25 +917,42 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
  * the caller must ensure it does not supply too large a GFN range, or the
  * operation can cause a soft lockup.
  */
-static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
-			      gfn_t start, gfn_t end, bool can_yield, bool flush)
+static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
+			  gfn_t start, gfn_t end, bool can_yield, bool flush)
 {
+	bool zap_all = (start == 0 && end >= tdp_mmu_max_gfn_host());
 	struct tdp_iter iter;
 
+	/*
+	 * No need to try to step down in the iterator when zapping all SPTEs,
+	 * zapping the top-level non-leaf SPTEs will recurse on their children.
+	 */
+	int min_level = zap_all ? root->role.level : PG_LEVEL_4K;
+
 	end = min(end, tdp_mmu_max_gfn_host());
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	rcu_read_lock();
 
-	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end) {
+	for_each_tdp_pte_min_level(iter, root, min_level, start, end) {
 		if (can_yield &&
 		    tdp_mmu_iter_cond_resched(kvm, &iter, flush, false)) {
 			flush = false;
 			continue;
 		}
 
-		if (!is_shadow_present_pte(iter.old_spte) ||
+		if (!is_shadow_present_pte(iter.old_spte))
+			continue;
+
+		/*
+		 * If this is a non-last-level SPTE that covers a larger range
+		 * than should be zapped, continue, and zap the mappings at a
+		 * lower level, except when zapping all SPTEs.
+		 */
+		if (!zap_all &&
+		    (iter.gfn < start ||
+		     iter.gfn + KVM_PAGES_PER_HPAGE(iter.level) > end) &&
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
 
@@ -956,13 +975,13 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
  * SPTEs have been cleared and a TLB flush is needed before releasing the
  * MMU lock.
  */
-bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
-			   bool can_yield, bool flush)
+bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
+				 gfn_t end, bool can_yield, bool flush)
 {
 	struct kvm_mmu_page *root;
 
 	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id)
-		flush = tdp_mmu_zap_leafs(kvm, root, start, end, can_yield, false);
+		flush = zap_gfn_range(kvm, root, start, end, can_yield, flush);
 
 	return flush;
 }
@@ -1210,8 +1229,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 				 bool flush)
 {
-	return kvm_tdp_mmu_zap_leafs(kvm, range->slot->as_id, range->start,
-				     range->end, range->may_block, flush);
+	return __kvm_tdp_mmu_zap_gfn_range(kvm, range->slot->as_id, range->start,
+					   range->end, range->may_block, flush);
 }
 
 typedef bool (*tdp_handler_t)(struct kvm *kvm, struct tdp_iter *iter,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 54bc8118c40a..5e5ef2576c81 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -15,8 +15,14 @@ __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			  bool shared);
 
-bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start,
+bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
 				 gfn_t end, bool can_yield, bool flush);
+static inline bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id,
+					     gfn_t start, gfn_t end, bool flush)
+{
+	return __kvm_tdp_mmu_zap_gfn_range(kvm, as_id, start, end, true, flush);
+}
+
 bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
-- 
2.31.1

