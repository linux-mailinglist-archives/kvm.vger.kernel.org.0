Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4950660FCE3
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 18:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236702AbiJ0QTi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 12:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236586AbiJ0QTC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 12:19:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE71196ED2
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 09:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666887538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Z1kaLdFzke5U8bpkOkEt06MM3WX8Rjl7B7du7C4v3A=;
        b=B64OpTjadhe2jOUhMrlguiO5NgBLQY2TWFyBiSwei1KMhw+xtOETp0yiLYO6yNjzHQYOTD
        elwlNDbv7k88jBGz1/ZNenzuMEqEGnP2P/cAWu657sJ8/smwUY2J7ebkUXa5MXoKxt1mGe
        KF+c1jj18Tb3U4bDTPNPMk6+uBHco+o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-lTJ2-pLfMdGqfACIo29oWw-1; Thu, 27 Oct 2022 12:18:52 -0400
X-MC-Unique: lTJ2-pLfMdGqfACIo29oWw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3BC4529AA2EC;
        Thu, 27 Oct 2022 16:18:52 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 19C3917593;
        Thu, 27 Oct 2022 16:18:52 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mhal@rbox.co, seanjc@google.com
Subject: [PATCH 10/16] KVM: Use gfn_to_pfn_cache's immutable "kvm" in kvm_gpc_refresh()
Date:   Thu, 27 Oct 2022 12:18:43 -0400
Message-Id: <20221027161849.2989332-11-pbonzini@redhat.com>
In-Reply-To: <20221027161849.2989332-1-pbonzini@redhat.com>
References: <20221027161849.2989332-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michal Luczaj <mhal@rbox.co>

Make kvm_gpc_refresh() use kvm instance cached in gfn_to_pfn_cache.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
[sean: leave kvm_gpc_unmap() as-is]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20221013211234.1318131-11-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c       |  2 +-
 arch/x86/kvm/xen.c       |  8 ++++----
 include/linux/kvm_host.h |  8 +++-----
 virt/kvm/pfncache.c      | 11 +++++------
 4 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0e3546aa34dd..bdc3110650d3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3037,7 +3037,7 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
 	while (!kvm_gpc_check(gpc, gpc->gpa)) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
-		if (kvm_gpc_refresh(v->kvm, gpc, gpc->gpa))
+		if (kvm_gpc_refresh(gpc, gpc->gpa))
 			return;
 
 		read_lock_irqsave(&gpc->lock, flags);
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index d3cb28388e3c..545ecbd0ca36 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -248,7 +248,7 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 		if (state == RUNSTATE_runnable)
 			return;
 
-		if (kvm_gpc_refresh(v->kvm, gpc, gpc->gpa))
+		if (kvm_gpc_refresh(gpc, gpc->gpa))
 			return;
 
 		read_lock_irqsave(&gpc->lock, flags);
@@ -377,7 +377,7 @@ void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
 	while (!kvm_gpc_check(gpc, gpc->gpa)) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
-		if (kvm_gpc_refresh(v->kvm, gpc, gpc->gpa))
+		if (kvm_gpc_refresh(gpc, gpc->gpa))
 			return;
 
 		read_lock_irqsave(&gpc->lock, flags);
@@ -451,7 +451,7 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 		if (in_atomic() || !task_is_running(current))
 			return 1;
 
-		if (kvm_gpc_refresh(v->kvm, gpc, gpc->gpa)) {
+		if (kvm_gpc_refresh(gpc, gpc->gpa)) {
 			/*
 			 * If this failed, userspace has screwed up the
 			 * vcpu_info mapping. No interrupts for you.
@@ -1504,7 +1504,7 @@ static int kvm_xen_set_evtchn(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 			break;
 
 		idx = srcu_read_lock(&kvm->srcu);
-		rc = kvm_gpc_refresh(kvm, gpc, gpc->gpa);
+		rc = kvm_gpc_refresh(gpc, gpc->gpa);
 		srcu_read_unlock(&kvm->srcu, idx);
 	} while(!rc);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 466988b8b5f6..d4a49c89bc08 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1299,22 +1299,20 @@ bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, gpa_t gpa);
 /**
  * kvm_gpc_refresh - update a previously initialized cache.
  *
- * @kvm:	   pointer to kvm instance.
  * @gpc:	   struct gfn_to_pfn_cache object.
  * @gpa:	   updated guest physical address to map.
- * @len:	   sanity check; the range being access must fit a single page.
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
-int kvm_gpc_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa);
+int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa);
 
 /**
  * kvm_gpc_unmap - temporarily unmap a gfn_to_pfn_cache.
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 48f400819d1e..e4ebea75dca9 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -237,10 +237,9 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 	return -EFAULT;
 }
 
-static int __kvm_gpc_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa,
-			     unsigned long len)
+static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
 {
-	struct kvm_memslots *slots = kvm_memslots(kvm);
+	struct kvm_memslots *slots = kvm_memslots(gpc->kvm);
 	unsigned long page_offset = gpa & ~PAGE_MASK;
 	bool unmap_old = false;
 	unsigned long old_uhva;
@@ -330,9 +329,9 @@ static int __kvm_gpc_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_
 	return ret;
 }
 
-int kvm_gpc_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa)
+int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa)
 {
-	return __kvm_gpc_refresh(kvm, gpc, gpa, gpc->len);
+	return __kvm_gpc_refresh(gpc, gpa, gpc->len);
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_refresh);
 
@@ -401,7 +400,7 @@ int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
 		gpc->active = true;
 		write_unlock_irq(&gpc->lock);
 	}
-	return __kvm_gpc_refresh(kvm, gpc, gpa, len);
+	return __kvm_gpc_refresh(gpc, gpa, len);
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_activate);
 
-- 
2.31.1


