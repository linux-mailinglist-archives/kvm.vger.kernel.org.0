Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C010F60FCD4
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 18:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236536AbiJ0QTK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 12:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236533AbiJ0QSz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 12:18:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77FFB18E715
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 09:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666887533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ucOT7iWRGadjrZPI9J/+ZpDTpnC7BK320XZ/Fl3Gc8o=;
        b=ZpYHee6Pf0+V+Bi+dYmSIB6YoUzLMu9MxrZSI1ZeEdnw6Bm+bnmUnr1V59tzstY45hgj2p
        AyYqvowlLkSrD8tKRMJ0q8b20csR4hTnRKEduBJrj+3/8b6FxYmYxFckw80XhWoIIhbvKJ
        hr/nbO73bD8yljV1DwVvAQJMB0iif70=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-7-4IOqO1-GN-ybaIeqSRHVQA-1; Thu, 27 Oct 2022 12:18:52 -0400
X-MC-Unique: 4IOqO1-GN-ybaIeqSRHVQA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 98AC5185A794;
        Thu, 27 Oct 2022 16:18:51 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 729051415117;
        Thu, 27 Oct 2022 16:18:51 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mhal@rbox.co, seanjc@google.com
Subject: [PATCH 07/16] KVM: Store gfn_to_pfn_cache length at activation time
Date:   Thu, 27 Oct 2022 12:18:40 -0400
Message-Id: <20221027161849.2989332-8-pbonzini@redhat.com>
In-Reply-To: <20221027161849.2989332-1-pbonzini@redhat.com>
References: <20221027161849.2989332-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make the length of a gfn=>pfn cache constant between activation and
deactivation to cleanup the APIs and avoid potential bugs, e.g calling
check() with a larger size than refresh() could put KVM into an infinite
loop.

All current (and anticipated future) users access the cache with a
predetermined size, which isn't a coincidence as using a dedicated cache
really only make sense when the access pattern is "fixed".  However,
the size can change from one activation to another, so pull that setup
outside the "if (!gpc->active)" conditional.

Add a WARN in kvm_setup_guest_pvclock() to assert that the offset+size
matches the length of the cache, both to make it more obvious that the
length really is immutable in that case, and to detect future bugs.

In kvm_xen_update_runstate_guest(), instead, the new field avoids guest
shenanigans involving the VM's long mode setting and makes sure that
the format of the data is consistent with the one that was used when
setting up the cache.

No functional change intended.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c        |  8 ++++----
 arch/x86/kvm/xen.c        | 28 +++++++++++-----------------
 include/linux/kvm_host.h  |  7 ++-----
 include/linux/kvm_types.h |  1 +
 virt/kvm/pfncache.c       | 18 ++++++++++++------
 5 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 44e1330c9dfd..9380fd9e1cf0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3031,13 +3031,13 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
 	struct pvclock_vcpu_time_info *guest_hv_clock;
 	unsigned long flags;
 
+	WARN_ON_ONCE(gpc->len != offset + sizeof(*guest_hv_clock));
+
 	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gpc_check(v->kvm, gpc, gpc->gpa,
-			      offset + sizeof(*guest_hv_clock))) {
+	while (!kvm_gpc_check(v->kvm, gpc, gpc->gpa)) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
-		if (kvm_gpc_refresh(v->kvm, gpc, gpc->gpa,
-				    offset + sizeof(*guest_hv_clock)))
+		if (kvm_gpc_refresh(v->kvm, gpc, gpc->gpa))
 			return;
 
 		read_lock_irqsave(&gpc->lock, flags);
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 2d597d47b817..26c8a8dc2737 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -233,7 +233,6 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 	struct gfn_to_pfn_cache *gpc = &vx->runstate_cache;
 	uint64_t *user_times;
 	unsigned long flags;
-	size_t user_len;
 	int *user_state;
 
 	kvm_xen_update_runstate(v, state);
@@ -241,16 +240,15 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 	if (!vx->runstate_cache.active)
 		return;
 
-	user_len = kvm_xen_runstate_info_size(v->kvm);
 	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gpc_check(v->kvm, gpc, gpc->gpa, user_len)) {
+	while (!kvm_gpc_check(v->kvm, gpc, gpc->gpa)) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
 		/* When invoked from kvm_sched_out() we cannot sleep */
 		if (state == RUNSTATE_runnable)
 			return;
 
-		if (kvm_gpc_refresh(v->kvm, gpc, gpc->gpa, user_len))
+		if (kvm_gpc_refresh(v->kvm, gpc, gpc->gpa))
 			return;
 
 		read_lock_irqsave(&gpc->lock, flags);
@@ -278,7 +276,7 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 
 	user_state = gpc->khva;
 
-	if (IS_ENABLED(CONFIG_64BIT) && v->kvm->arch.xen.long_mode)
+	if (gpc->len == sizeof(struct vcpu_runstate_info))
 		user_times = gpc->khva + offsetof(struct vcpu_runstate_info,
 						  state_entry_time);
 	else
@@ -376,12 +374,10 @@ void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
 	 * little more honest about it.
 	 */
 	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gpc_check(v->kvm, gpc, gpc->gpa,
-			      sizeof(struct vcpu_info))) {
+	while (!kvm_gpc_check(v->kvm, gpc, gpc->gpa)) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
-		if (kvm_gpc_refresh(v->kvm, gpc, gpc->gpa,
-				    sizeof(struct vcpu_info)))
+		if (kvm_gpc_refresh(v->kvm, gpc, gpc->gpa))
 			return;
 
 		read_lock_irqsave(&gpc->lock, flags);
@@ -441,8 +437,7 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 		     sizeof_field(struct compat_vcpu_info, evtchn_upcall_pending));
 
 	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gpc_check(v->kvm, gpc, gpc->gpa,
-			      sizeof(struct vcpu_info))) {
+	while (!kvm_gpc_check(v->kvm, gpc, gpc->gpa)) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
 		/*
@@ -456,8 +451,7 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 		if (in_atomic() || !task_is_running(current))
 			return 1;
 
-		if (kvm_gpc_refresh(v->kvm, gpc, gpc->gpa,
-				    sizeof(struct vcpu_info))) {
+		if (kvm_gpc_refresh(v->kvm, gpc, gpc->gpa)) {
 			/*
 			 * If this failed, userspace has screwed up the
 			 * vcpu_info mapping. No interrupts for you.
@@ -987,7 +981,7 @@ static bool wait_pending_event(struct kvm_vcpu *vcpu, int nr_ports,
 
 	read_lock_irqsave(&gpc->lock, flags);
 	idx = srcu_read_lock(&kvm->srcu);
-	if (!kvm_gpc_check(kvm, gpc, gpc->gpa, PAGE_SIZE))
+	if (!kvm_gpc_check(kvm, gpc, gpc->gpa))
 		goto out_rcu;
 
 	ret = false;
@@ -1378,7 +1372,7 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 	idx = srcu_read_lock(&kvm->srcu);
 
 	read_lock_irqsave(&gpc->lock, flags);
-	if (!kvm_gpc_check(kvm, gpc, gpc->gpa, PAGE_SIZE))
+	if (!kvm_gpc_check(kvm, gpc, gpc->gpa))
 		goto out_rcu;
 
 	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode) {
@@ -1412,7 +1406,7 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 		gpc = &vcpu->arch.xen.vcpu_info_cache;
 
 		read_lock_irqsave(&gpc->lock, flags);
-		if (!kvm_gpc_check(kvm, gpc, gpc->gpa, sizeof(struct vcpu_info))) {
+		if (!kvm_gpc_check(kvm, gpc, gpc->gpa)) {
 			/*
 			 * Could not access the vcpu_info. Set the bit in-kernel
 			 * and prod the vCPU to deliver it for itself.
@@ -1510,7 +1504,7 @@ static int kvm_xen_set_evtchn(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 			break;
 
 		idx = srcu_read_lock(&kvm->srcu);
-		rc = kvm_gpc_refresh(kvm, gpc, gpc->gpa, PAGE_SIZE);
+		rc = kvm_gpc_refresh(kvm, gpc, gpc->gpa);
 		srcu_read_unlock(&kvm->srcu, idx);
 	} while(!rc);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7a913818ba3c..931775e92f85 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1284,7 +1284,6 @@ int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
  * @kvm:	   pointer to kvm instance.
  * @gpc:	   struct gfn_to_pfn_cache object.
  * @gpa:	   current guest physical address to map.
- * @len:	   sanity check; the range being access must fit a single page.
  *
  * @return:	   %true if the cache is still valid and the address matches.
  *		   %false if the cache is not valid.
@@ -1296,8 +1295,7 @@ int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
  * Callers in IN_GUEST_MODE may do so without locking, although they should
  * still hold a read lock on kvm->scru for the memslot checks.
  */
-bool kvm_gpc_check(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa,
-		   unsigned long len);
+bool kvm_gpc_check(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa);
 
 /**
  * kvm_gpc_refresh - update a previously initialized cache.
@@ -1317,8 +1315,7 @@ bool kvm_gpc_check(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa,
  * still lock and check the cache status, as this function does not return
  * with the lock still held to permit access.
  */
-int kvm_gpc_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa,
-		    unsigned long len);
+int kvm_gpc_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa);
 
 /**
  * kvm_gpc_unmap - temporarily unmap a gfn_to_pfn_cache.
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 76de36e56cdf..d66b276d29e0 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -74,6 +74,7 @@ struct gfn_to_pfn_cache {
 	struct mutex refresh_lock;
 	void *khva;
 	kvm_pfn_t pfn;
+	unsigned long len;
 	enum pfn_cache_usage usage;
 	bool active;
 	bool valid;
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 6756dfa60d5a..96008b69d48c 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -76,15 +76,14 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long start,
 	}
 }
 
-bool kvm_gpc_check(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa,
-		   unsigned long len)
+bool kvm_gpc_check(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa)
 {
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 
 	if (!gpc->active)
 		return false;
 
-	if ((gpa & ~PAGE_MASK) + len > PAGE_SIZE)
+	if ((gpa & ~PAGE_MASK) + gpc->len > PAGE_SIZE)
 		return false;
 
 	if (gpc->gpa != gpa || gpc->generation != slots->generation ||
@@ -238,8 +237,8 @@ static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 	return -EFAULT;
 }
 
-int kvm_gpc_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa,
-		    unsigned long len)
+static int __kvm_gpc_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa,
+			     unsigned long len)
 {
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 	unsigned long page_offset = gpa & ~PAGE_MASK;
@@ -270,6 +269,8 @@ int kvm_gpc_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa,
 		goto out_unlock;
 	}
 
+	gpc->len = len;
+
 	old_pfn = gpc->pfn;
 	old_khva = gpc->khva - offset_in_page(gpc->khva);
 	old_uhva = gpc->uhva;
@@ -328,6 +329,11 @@ int kvm_gpc_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa,
 
 	return ret;
 }
+
+int kvm_gpc_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa)
+{
+	return __kvm_gpc_refresh(kvm, gpc, gpa, gpc->len);
+}
 EXPORT_SYMBOL_GPL(kvm_gpc_refresh);
 
 void kvm_gpc_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
@@ -395,7 +401,7 @@ int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
 		gpc->active = true;
 		write_unlock_irq(&gpc->lock);
 	}
-	return kvm_gpc_refresh(kvm, gpc, gpa, len);
+	return __kvm_gpc_refresh(kvm, gpc, gpa, len);
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_activate);
 
-- 
2.31.1


