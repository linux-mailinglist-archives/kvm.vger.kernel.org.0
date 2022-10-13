Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8190C5FE404
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 23:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbiJMVOV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 17:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiJMVNn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 17:13:43 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4D4193758
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 14:13:32 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id h1-20020a62b401000000b0056161cd284fso1756210pfn.16
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 14:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/Wux4Tvws0B1FY5Eqq8RnVGyJRYrHhxjDEQpTU2vx4E=;
        b=lm3T1cwJ15k+6/uBB8xtPltALi9r5i87D/2rmZNqKvEmPelSkNSVueJFvJOSUtkNpM
         D7ZfmZNjpy4c2mZbl1sAAEncd8rYyd5w5o6W6U1UvsAZsQ/7hTAvprmfQgyGtXVWYTzv
         ygawkMCI0oYRuFo2rXYPgmV7BQDQCvYM1UvwpCtMyZgPmb4mPFWlR7yWzNAVC3N74OeB
         rM31Pta/FvF5UQqjop91PRPVIzY3Pp0P2btkR9lYSrKuXe00bYiV5g/o5j4F1TRwAr5m
         xh7rXOzlwDSDW/avVQ3BVGG3L+u9t8b5D0ckbMv5ss/mpe0/2MlRozQhIsSCSQ5dx6YF
         bnMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/Wux4Tvws0B1FY5Eqq8RnVGyJRYrHhxjDEQpTU2vx4E=;
        b=Z/XVSS2thBPfO23z93QfwFONCAlOtzs9mX0wAH7uTMKEWJ0xa+c803WuuiWnvdDyk/
         WCq06N5MoMH6SbAKhmigt12afRlZbgxcozb3W595L2H/3Rn+JQDEka9eYI0dvTZqkvq9
         OTCnM4/Buu1kwkjqxFgvMifpa/D3yxHibS05TnqFzBIWHK1TFPXjiwVCo2I8ZF3hEmEn
         HSUTHATekcx6YcUt+VtoJnd5YkCZGSxvc21jYWD7S3c6vqJAp42olVyvQX+uruh1az3B
         y6/AxqELKHozZ4EgrVXHsWLCVC+oU1bnvpdEkdZeRT0UBzA0OZmQIl18LbemhmK5hNOk
         w9CA==
X-Gm-Message-State: ACrzQf2NHGay0qphlC1xhAxyLlVLkBVjpfWA58/n50OADfJkRQlUAifM
        5Cv7XY5UFYYHDAgFYEmG4u1BfSm2Ctc=
X-Google-Smtp-Source: AMsMyM6qr+GDBp8mpP+eAPS6Nay8vdzEveP9Wti1HT2bjY8hLoFWIbhsGKadzgEIyDTHNX012UthqhLTldQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c984:b0:20a:eab5:cf39 with SMTP id
 w4-20020a17090ac98400b0020aeab5cf39mr114805pjt.1.1665695575531; Thu, 13 Oct
 2022 14:12:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 13 Oct 2022 21:12:28 +0000
In-Reply-To: <20221013211234.1318131-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221013211234.1318131-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221013211234.1318131-11-seanjc@google.com>
Subject: [PATCH v2 10/16] KVM: Use gfn_to_pfn_cache's immutable "kvm" in kvm_gpc_refresh()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
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
---
 arch/x86/kvm/x86.c       | 2 +-
 arch/x86/kvm/xen.c       | 8 ++++----
 include/linux/kvm_host.h | 8 +++-----
 virt/kvm/pfncache.c      | 6 +++---
 4 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b357a84f8c49..d370d06bb07a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3036,7 +3036,7 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
 	while (!kvm_gpc_check(gpc, gpc->gpa)) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
-		if (kvm_gpc_refresh(v->kvm, gpc, gpc->gpa))
+		if (kvm_gpc_refresh(gpc, gpc->gpa))
 			return;
 
 		read_lock_irqsave(&gpc->lock, flags);
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index c7304f37c438..920ba5ca3016 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -218,7 +218,7 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 		if (state == RUNSTATE_runnable)
 			return;
 
-		if (kvm_gpc_refresh(v->kvm, gpc, gpc->gpa))
+		if (kvm_gpc_refresh(gpc, gpc->gpa))
 			return;
 
 		read_lock_irqsave(&gpc->lock, flags);
@@ -347,7 +347,7 @@ void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
 	while (!kvm_gpc_check(gpc, gpc->gpa)) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
-		if (kvm_gpc_refresh(v->kvm, gpc, gpc->gpa))
+		if (kvm_gpc_refresh(gpc, gpc->gpa))
 			return;
 
 		read_lock_irqsave(&gpc->lock, flags);
@@ -421,7 +421,7 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 		if (in_atomic() || !task_is_running(current))
 			return 1;
 
-		if (kvm_gpc_refresh(v->kvm, gpc, gpc->gpa)) {
+		if (kvm_gpc_refresh(gpc, gpc->gpa)) {
 			/*
 			 * If this failed, userspace has screwed up the
 			 * vcpu_info mapping. No interrupts for you.
@@ -1470,7 +1470,7 @@ static int kvm_xen_set_evtchn(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 			break;
 
 		idx = srcu_read_lock(&kvm->srcu);
-		rc = kvm_gpc_refresh(kvm, gpc, gpc->gpa);
+		rc = kvm_gpc_refresh(gpc, gpc->gpa);
 		srcu_read_unlock(&kvm->srcu, idx);
 	} while(!rc);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ad8ef7f2d705..b63d2abbef56 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1300,22 +1300,20 @@ bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, gpa_t gpa);
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
index ef7ac1666847..432b150bd9f1 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -237,9 +237,9 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 	return -EFAULT;
 }
 
-int kvm_gpc_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa)
+int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa)
 {
-	struct kvm_memslots *slots = kvm_memslots(kvm);
+	struct kvm_memslots *slots = kvm_memslots(gpc->kvm);
 	unsigned long page_offset = gpa & ~PAGE_MASK;
 	bool unmap_old = false;
 	unsigned long old_uhva;
@@ -395,7 +395,7 @@ int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa)
 		gpc->active = true;
 		write_unlock_irq(&gpc->lock);
 	}
-	return kvm_gpc_refresh(kvm, gpc, gpa);
+	return kvm_gpc_refresh(gpc, gpa);
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_activate);
 
-- 
2.38.0.413.g74048e4d9e-goog

