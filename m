Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 666695BF33B
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 04:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbiIUCCw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 22:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbiIUCCo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 22:02:44 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4227960C
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 19:02:41 -0700 (PDT)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1oap4S-00Eq8Y-5a
        for kvm@vger.kernel.org; Wed, 21 Sep 2022 04:02:40 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From;
        bh=c4Oh4PNbC7dzavuLM6JW/v54a4kNYZdNwYx1cx0CVJA=; b=bhBNXoK25x9y9XWIO5XUZo/Tn+
        2auMBRnFFucF4YvTIEnbclALE7v8+rCDt7zBTV5g36kbjYwZAdUfBphTfak7okE4fu1INApOp7dbP
        ysYj3r0T9F96ztQ0S683mcTCA+KJ9O5Fwp+Q91m+/jpCvep7jbuZAwUMrtd6PFCAsza9oztHHIBy1
        xFAjbNk6aA26PbBOvuD4/LB8qSbVkZ2kn7Yhi7OUIszc4IQtBFyMBpyOj87sG/08212fJX7Eswo4F
        2alFZDUHiDvxOwZLyLsq/1d6pc5rzqdOaQYbr7No3L/z5wRUb9sN3V877ofGT5i1ZeMndyDnqoLN4
        bypoPm6A==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1oap4R-0007C8-SW; Wed, 21 Sep 2022 04:02:40 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1oap3x-0006er-NJ; Wed, 21 Sep 2022 04:02:09 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 5/8] KVM: x86: Clean up kvm_gpc_check()
Date:   Wed, 21 Sep 2022 04:01:37 +0200
Message-Id: <20220921020140.3240092-6-mhal@rbox.co>
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

Make kvm_gpc_check() use kvm instance cached in gfn_to_pfn_cache.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 arch/x86/kvm/x86.c       |  2 +-
 arch/x86/kvm/xen.c       | 14 ++++++--------
 include/linux/kvm_host.h |  4 +---
 virt/kvm/pfncache.c      |  5 ++---
 4 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ed8e4f8c9cf0..273f1ed3b5ae 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3017,7 +3017,7 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
 	unsigned long flags;
 
 	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gpc_check(v->kvm, gpc, gpc->gpa,
+	while (!kvm_gpc_check(gpc, gpc->gpa,
 			      offset + sizeof(*guest_hv_clock))) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 9b4b0e6e66e5..84b95258773a 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -217,7 +217,7 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 		user_len = sizeof(struct compat_vcpu_runstate_info);
 
 	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gpc_check(v->kvm, gpc, gpc->gpa, user_len)) {
+	while (!kvm_gpc_check(gpc, gpc->gpa, user_len)) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
 		/* When invoked from kvm_sched_out() we cannot sleep */
@@ -350,8 +350,7 @@ void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
 	 * little more honest about it.
 	 */
 	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gpc_check(v->kvm, gpc, gpc->gpa,
-			      sizeof(struct vcpu_info))) {
+	while (!kvm_gpc_check(gpc, gpc->gpa, sizeof(struct vcpu_info))) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
 		if (kvm_gpc_refresh(v->kvm, gpc, gpc->gpa,
@@ -415,8 +414,7 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 		     sizeof_field(struct compat_vcpu_info, evtchn_upcall_pending));
 
 	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gpc_check(v->kvm, gpc, gpc->gpa,
-			      sizeof(struct vcpu_info))) {
+	while (!kvm_gpc_check(gpc, gpc->gpa, sizeof(struct vcpu_info))) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
 		/*
@@ -957,7 +955,7 @@ static bool wait_pending_event(struct kvm_vcpu *vcpu, int nr_ports,
 
 	read_lock_irqsave(&gpc->lock, flags);
 	idx = srcu_read_lock(&kvm->srcu);
-	if (!kvm_gpc_check(kvm, gpc, gpc->gpa, PAGE_SIZE))
+	if (!kvm_gpc_check(gpc, gpc->gpa, PAGE_SIZE))
 		goto out_rcu;
 
 	ret = false;
@@ -1349,7 +1347,7 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 	idx = srcu_read_lock(&kvm->srcu);
 
 	read_lock_irqsave(&gpc->lock, flags);
-	if (!kvm_gpc_check(kvm, gpc, gpc->gpa, PAGE_SIZE))
+	if (!kvm_gpc_check(gpc, gpc->gpa, PAGE_SIZE))
 		goto out_rcu;
 
 	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode) {
@@ -1383,7 +1381,7 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 		gpc = &vcpu->arch.xen.vcpu_info_cache;
 
 		read_lock_irqsave(&gpc->lock, flags);
-		if (!kvm_gpc_check(kvm, gpc, gpc->gpa, sizeof(struct vcpu_info))) {
+		if (!kvm_gpc_check(gpc, gpc->gpa, sizeof(struct vcpu_info))) {
 			/*
 			 * Could not access the vcpu_info. Set the bit in-kernel
 			 * and prod the vCPU to deliver it for itself.
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 024b8df5302c..0b66d4889ec3 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1282,7 +1282,6 @@ int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa);
 /**
  * kvm_gpc_check - check validity of a gfn_to_pfn_cache.
  *
- * @kvm:	   pointer to kvm instance.
  * @gpc:	   struct gfn_to_pfn_cache object.
  * @gpa:	   current guest physical address to map.
  * @len:	   sanity check; the range being access must fit a single page.
@@ -1297,8 +1296,7 @@ int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa);
  * Callers in IN_GUEST_MODE may do so without locking, although they should
  * still hold a read lock on kvm->scru for the memslot checks.
  */
-bool kvm_gpc_check(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa,
-		   unsigned long len);
+bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len);
 
 /**
  * kvm_gpc_refresh - update a previously initialized cache.
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 56ca0e9c6ed7..eb91025d7242 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -76,10 +76,9 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long start,
 	}
 }
 
-bool kvm_gpc_check(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa,
-		   unsigned long len)
+bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
 {
-	struct kvm_memslots *slots = kvm_memslots(kvm);
+	struct kvm_memslots *slots = kvm_memslots(gpc->kvm);
 
 	if ((gpa & ~PAGE_MASK) + len > PAGE_SIZE)
 		return false;
-- 
2.37.3

