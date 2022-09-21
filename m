Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 067F15BF335
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 04:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbiIUCCm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 22:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiIUCCh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 22:02:37 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2008F792E7
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 19:02:36 -0700 (PDT)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1oap4M-00Eq83-Fm; Wed, 21 Sep 2022 04:02:34 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From;
        bh=B19aF5KTrekt1zLP5jhP2ZxEaVGl9MOYTy61Yranuvs=; b=oc0DKE9Th2p6JW4f9XpUaE4i81
        JwyCAUwSeO1ds3BpOJgPOsbQtazHCNMGjn2UP5BrcfJtR+fbuEgbyuCsYGR8b04a4q5N+xp0JtdIN
        sZjmYXTXwjx/bAtd0+ETPvnwkdgfLsE2QEBbNH1QPT8n5RfJBmnVIKMcgz4PbW3VS644P+raVwQBz
        hJ9li2OI7MwFJmzfivDSc0LVntzDiHLObsVo67W68yZBJ+0ffMEUcCoiVico66H9zqbIqJ+4GtoUw
        hWciMCZjDKbNVPm/U3x7l+b2oeaxI5rcAyje5S8bkSsRTxcomOYD8eQzH9qLV42BBpUznMzkTYTRr
        Sxd+xB6Q==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1oap4M-0007Bs-8J; Wed, 21 Sep 2022 04:02:34 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1oap3y-0006er-BN; Wed, 21 Sep 2022 04:02:10 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 7/8] KVM: x86: Clean up kvm_gpc_refresh(), kvm_gpc_unmap()
Date:   Wed, 21 Sep 2022 04:01:39 +0200
Message-Id: <20220921020140.3240092-8-mhal@rbox.co>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921020140.3240092-1-mhal@rbox.co>
References: <YySujDJN2Wm3ivi/@google.com>
 <20220921020140.3240092-1-mhal@rbox.co>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make kvm_gpc_refresh() use kvm instance cached in gfn_to_pfn_cache.

First argument of kvm_gpc_unmap() becomes unneeded; remove it from
function definition.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 arch/x86/kvm/x86.c       |  2 +-
 arch/x86/kvm/xen.c       | 10 ++++------
 include/linux/kvm_host.h | 10 ++++------
 virt/kvm/pfncache.c      | 11 +++++------
 4 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 273f1ed3b5ae..d24d1731d2bc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3021,7 +3021,7 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
 			      offset + sizeof(*guest_hv_clock))) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
-		if (kvm_gpc_refresh(v->kvm, gpc, gpc->gpa,
+		if (kvm_gpc_refresh(gpc, gpc->gpa,
 				    offset + sizeof(*guest_hv_clock)))
 			return;
 
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 84b95258773a..bcaaa83290fb 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -224,7 +224,7 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 		if (state == RUNSTATE_runnable)
 			return;
 
-		if (kvm_gpc_refresh(v->kvm, gpc, gpc->gpa, user_len))
+		if (kvm_gpc_refresh(gpc, gpc->gpa, user_len))
 			return;
 
 		read_lock_irqsave(&gpc->lock, flags);
@@ -353,8 +353,7 @@ void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
 	while (!kvm_gpc_check(gpc, gpc->gpa, sizeof(struct vcpu_info))) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
-		if (kvm_gpc_refresh(v->kvm, gpc, gpc->gpa,
-				    sizeof(struct vcpu_info)))
+		if (kvm_gpc_refresh(gpc, gpc->gpa, sizeof(struct vcpu_info)))
 			return;
 
 		read_lock_irqsave(&gpc->lock, flags);
@@ -428,8 +427,7 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 		if (in_atomic() || !task_is_running(current))
 			return 1;
 
-		if (kvm_gpc_refresh(v->kvm, gpc, gpc->gpa,
-				    sizeof(struct vcpu_info))) {
+		if (kvm_gpc_refresh(gpc, gpc->gpa, sizeof(struct vcpu_info))) {
 			/*
 			 * If this failed, userspace has screwed up the
 			 * vcpu_info mapping. No interrupts for you.
@@ -1479,7 +1477,7 @@ static int kvm_xen_set_evtchn(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 			break;
 
 		idx = srcu_read_lock(&kvm->srcu);
-		rc = kvm_gpc_refresh(kvm, gpc, gpc->gpa, PAGE_SIZE);
+		rc = kvm_gpc_refresh(gpc, gpc->gpa, PAGE_SIZE);
 		srcu_read_unlock(&kvm->srcu, idx);
 	} while(!rc);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0b66d4889ec3..efead11bec84 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1301,35 +1301,33 @@ bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len);
 /**
  * kvm_gpc_refresh - update a previously initialized cache.
  *
- * @kvm:	   pointer to kvm instance.
  * @gpc:	   struct gfn_to_pfn_cache object.
  * @gpa:	   updated guest physical address to map.
  * @len:	   sanity check; the range being access must fit a single page.
  *
  * @return:	   0 for success.
  *		   -EINVAL for a mapping which would cross a page boundary.
- *                 -EFAULT for an untranslatable guest physical address.
+ *		   -EFAULT for an untranslatable guest physical address.
  *
  * This will attempt to refresh a gfn_to_pfn_cache. Note that a successful
- * returm from this function does not mean the page can be immediately
+ * return from this function does not mean the page can be immediately
  * accessed because it may have raced with an invalidation. Callers must
  * still lock and check the cache status, as this function does not return
  * with the lock still held to permit access.
  */
-int kvm_gpc_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa,
+int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa,
 		    unsigned long len);
 
 /**
  * kvm_gpc_unmap - temporarily unmap a gfn_to_pfn_cache.
  *
- * @kvm:	   pointer to kvm instance.
  * @gpc:	   struct gfn_to_pfn_cache object.
  *
  * This unmaps the referenced page. The cache is left in the invalid state
  * but at least the mapping from GPA to userspace HVA will remain cached
  * and can be reused on a subsequent refresh.
  */
-void kvm_gpc_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc);
+void kvm_gpc_unmap(struct gfn_to_pfn_cache *gpc);
 
 /**
  * kvm_gpc_deactivate - deactivate and unlink a gfn_to_pfn_cache.
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index a2c95e393e34..45b9b96c0ea3 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -234,10 +234,9 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 	return -EFAULT;
 }
 
-int kvm_gpc_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa,
-		    unsigned long len)
+int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
 {
-	struct kvm_memslots *slots = kvm_memslots(kvm);
+	struct kvm_memslots *slots = kvm_memslots(gpc->kvm);
 	unsigned long page_offset = gpa & ~PAGE_MASK;
 	kvm_pfn_t old_pfn, new_pfn;
 	unsigned long old_uhva;
@@ -318,7 +317,7 @@ int kvm_gpc_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa,
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_refresh);
 
-void kvm_gpc_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
+void kvm_gpc_unmap(struct gfn_to_pfn_cache *gpc)
 {
 	void *old_khva;
 	kvm_pfn_t old_pfn;
@@ -375,7 +374,7 @@ int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa)
 		list_add(&gpc->list, &gpc->kvm->gpc_list);
 		spin_unlock(&gpc->kvm->gpc_lock);
 	}
-	return kvm_gpc_refresh(gpc->kvm, gpc, gpa, gpc->len);
+	return kvm_gpc_refresh(gpc, gpa, gpc->len);
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_activate);
 
@@ -386,7 +385,7 @@ void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc)
 		list_del(&gpc->list);
 		spin_unlock(&gpc->kvm->gpc_lock);
 
-		kvm_gpc_unmap(gpc->kvm, gpc);
+		kvm_gpc_unmap(gpc);
 		gpc->active = false;
 	}
 }
-- 
2.37.3

