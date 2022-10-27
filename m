Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 578DA60FCE8
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 18:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236716AbiJ0QTn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 12:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236594AbiJ0QTC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 12:19:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C4A196EDF
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 09:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666887538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pXzajH97NHl0gEvAvhaePvRNuVty75RFHBFDXcj4E30=;
        b=OHIQgdpHMvoJCKFfYrmBLvVagyMXcWC1NWQTpGNii9DCkcMI1MSK+xqJuZ4FGOP4gn5rkH
        whExC5LuO1ontxImG1JHf59ONQf3N8vMfTZt4+Q5qJUEwmRQD6kyK1BOD933s+6x3yNah3
        QFX2Hx7fMb8SeQEK51LaJ3xQZF2TyzY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-332-NzG0FtqCNMWX5O91G12vAA-1; Thu, 27 Oct 2022 12:18:53 -0400
X-MC-Unique: NzG0FtqCNMWX5O91G12vAA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B993D811E81;
        Thu, 27 Oct 2022 16:18:52 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 98CEE39DB3;
        Thu, 27 Oct 2022 16:18:52 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mhal@rbox.co, seanjc@google.com
Subject: [PATCH 13/16] KVM: Drop @gpa from exported gfn=>pfn cache check() and refresh() helpers
Date:   Thu, 27 Oct 2022 12:18:46 -0400
Message-Id: <20221027161849.2989332-14-pbonzini@redhat.com>
In-Reply-To: <20221027161849.2989332-1-pbonzini@redhat.com>
References: <20221027161849.2989332-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Drop the @gpa param from the exported check()+refresh() helpers and limit
changing the cache's GPA to the activate path.  All external users just
feed in gpc->gpa, i.e. this is a fancy nop.

Allowing users to change the GPA at check()+refresh() is dangerous as
those helpers explicitly allow concurrent calls, e.g. KVM could get into
a livelock scenario.  It's also unclear as to what the expected behavior
should be if multiple tasks attempt to refresh with different GPAs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20221013211234.1318131-14-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c       |  4 ++--
 arch/x86/kvm/xen.c       | 20 ++++++++++----------
 include/linux/kvm_host.h |  6 ++----
 virt/kvm/pfncache.c      | 11 ++++-------
 4 files changed, 18 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bdc3110650d3..f7ee5ee58990 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3034,10 +3034,10 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
 	WARN_ON_ONCE(gpc->len != offset + sizeof(*guest_hv_clock));
 
 	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gpc_check(gpc, gpc->gpa)) {
+	while (!kvm_gpc_check(gpc)) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
-		if (kvm_gpc_refresh(gpc, gpc->gpa))
+		if (kvm_gpc_refresh(gpc))
 			return;
 
 		read_lock_irqsave(&gpc->lock, flags);
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 545ecbd0ca36..7b7b1eb88a0b 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -241,14 +241,14 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 		return;
 
 	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gpc_check(gpc, gpc->gpa)) {
+	while (!kvm_gpc_check(gpc)) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
 		/* When invoked from kvm_sched_out() we cannot sleep */
 		if (state == RUNSTATE_runnable)
 			return;
 
-		if (kvm_gpc_refresh(gpc, gpc->gpa))
+		if (kvm_gpc_refresh(gpc))
 			return;
 
 		read_lock_irqsave(&gpc->lock, flags);
@@ -374,10 +374,10 @@ void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
 	 * little more honest about it.
 	 */
 	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gpc_check(gpc, gpc->gpa)) {
+	while (!kvm_gpc_check(gpc)) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
-		if (kvm_gpc_refresh(gpc, gpc->gpa))
+		if (kvm_gpc_refresh(gpc))
 			return;
 
 		read_lock_irqsave(&gpc->lock, flags);
@@ -437,7 +437,7 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 		     sizeof_field(struct compat_vcpu_info, evtchn_upcall_pending));
 
 	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gpc_check(gpc, gpc->gpa)) {
+	while (!kvm_gpc_check(gpc)) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
 		/*
@@ -451,7 +451,7 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 		if (in_atomic() || !task_is_running(current))
 			return 1;
 
-		if (kvm_gpc_refresh(gpc, gpc->gpa)) {
+		if (kvm_gpc_refresh(gpc)) {
 			/*
 			 * If this failed, userspace has screwed up the
 			 * vcpu_info mapping. No interrupts for you.
@@ -981,7 +981,7 @@ static bool wait_pending_event(struct kvm_vcpu *vcpu, int nr_ports,
 
 	read_lock_irqsave(&gpc->lock, flags);
 	idx = srcu_read_lock(&kvm->srcu);
-	if (!kvm_gpc_check(gpc, gpc->gpa))
+	if (!kvm_gpc_check(gpc))
 		goto out_rcu;
 
 	ret = false;
@@ -1372,7 +1372,7 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 	idx = srcu_read_lock(&kvm->srcu);
 
 	read_lock_irqsave(&gpc->lock, flags);
-	if (!kvm_gpc_check(gpc, gpc->gpa))
+	if (!kvm_gpc_check(gpc))
 		goto out_rcu;
 
 	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode) {
@@ -1406,7 +1406,7 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 		gpc = &vcpu->arch.xen.vcpu_info_cache;
 
 		read_lock_irqsave(&gpc->lock, flags);
-		if (!kvm_gpc_check(gpc, gpc->gpa)) {
+		if (!kvm_gpc_check(gpc)) {
 			/*
 			 * Could not access the vcpu_info. Set the bit in-kernel
 			 * and prod the vCPU to deliver it for itself.
@@ -1504,7 +1504,7 @@ static int kvm_xen_set_evtchn(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 			break;
 
 		idx = srcu_read_lock(&kvm->srcu);
-		rc = kvm_gpc_refresh(gpc, gpc->gpa);
+		rc = kvm_gpc_refresh(gpc);
 		srcu_read_unlock(&kvm->srcu, idx);
 	} while(!rc);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3847b721e753..fd6b58c870cf 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1282,7 +1282,6 @@ int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
  * kvm_gpc_check - check validity of a gfn_to_pfn_cache.
  *
  * @gpc:	   struct gfn_to_pfn_cache object.
- * @gpa:	   current guest physical address to map.
  *
  * @return:	   %true if the cache is still valid and the address matches.
  *		   %false if the cache is not valid.
@@ -1294,13 +1293,12 @@ int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
  * Callers in IN_GUEST_MODE may do so without locking, although they should
  * still hold a read lock on kvm->scru for the memslot checks.
  */
-bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, gpa_t gpa);
+bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc);
 
 /**
  * kvm_gpc_refresh - update a previously initialized cache.
  *
  * @gpc:	   struct gfn_to_pfn_cache object.
- * @gpa:	   updated guest physical address to map.
  *
  * @return:	   0 for success.
  *		   -EINVAL for a mapping which would cross a page boundary.
@@ -1312,7 +1310,7 @@ bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, gpa_t gpa);
  * still lock and check the cache status, as this function does not return
  * with the lock still held to permit access.
  */
-int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa);
+int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc);
 
 /**
  * kvm_gpc_deactivate - deactivate and unlink a gfn_to_pfn_cache.
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 06fcf03c2da6..68e2e53eac8a 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -76,17 +76,14 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long start,
 	}
 }
 
-bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, gpa_t gpa)
+bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc)
 {
 	struct kvm_memslots *slots = kvm_memslots(gpc->kvm);
 
 	if (!gpc->active)
 		return false;
 
-	if ((gpa & ~PAGE_MASK) + gpc->len > PAGE_SIZE)
-		return false;
-
-	if (gpc->gpa != gpa || gpc->generation != slots->generation ||
+	if (gpc->generation != slots->generation ||
 	    kvm_is_error_hva(gpc->uhva))
 		return false;
 
@@ -329,9 +326,9 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 	return ret;
 }
 
-int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa)
+int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc)
 {
-	return __kvm_gpc_refresh(gpc, gpa, gpc->len);
+	return __kvm_gpc_refresh(gpc, gpc->gpa, gpc->len);
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_refresh);
 
-- 
2.31.1


