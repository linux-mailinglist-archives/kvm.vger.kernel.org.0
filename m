Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D79965FE3FF
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 23:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiJMVOH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 17:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiJMVNi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 17:13:38 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B83A192B9A
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 14:13:24 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id y15-20020aa78f2f000000b00562674456afso1769151pfr.9
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 14:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=a4H6RRJPk2dGB6P2HabFO7Il/OYENPrSGssdwi/forA=;
        b=LRQBSlnHAC2o/nLb76XOELDV+qRbsrKoolzLISt7bliPNp8atvRG/tV6G2jh+ZOuYk
         rGdCAqlfEn8SgSQFkFuAL0dc30DDRJ9sBTfCHqHbFhKD+n5Eyo1Eqp5CQqRgeBt6cTR1
         CN3oKcPX243/OalqKAhivmjnuP9NFm/LvneYDiCtPE5+jQc4o6eKMRt5PyQpjA3LAwUJ
         xiRkt1KBYlWm20pr87BVvORpQ89cJxKi3CdAEfWNTT3kQO3MrKJmCd7ueUYZM0d5LxDv
         ncyWZe/mFy5CmBu/xvyBvRZjy4XQfgfo5hj5z//KoeyYBIKhtiBa6rE3VkTuX6paHybY
         MYFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a4H6RRJPk2dGB6P2HabFO7Il/OYENPrSGssdwi/forA=;
        b=2NJ52tRC36NYotr6acgmVlsX1f7giXTLo8JWGabRbMRK6W3Js4750iJ+oAWP7QjD79
         U09T1iWuI147PrtcyDmSd+8FTVXJCLEnjSKijFJlUOcs1U6h34V7Zye3HHe1BlFwZp/k
         nDcj50JzaJrvVMbLroMPzmGpevEzqfT/ANBgibFMYw2cFQrUY+sQVOfcswaPpng2oydu
         PDDPnAdOtgqYbqfgGx3d+sdYadiH/BZl1KGZw+l9goh3wJSFcaP7IlhfzeShHqAEoc6C
         RavK+P2S3ykkvVpzrwmHXX1SkihE/qwCRzXp9+G9N+u+Z3xYp8RGG4OvJqcajYMAnv0z
         d2sQ==
X-Gm-Message-State: ACrzQf09L7/ZP3u1NjBL2E1TphN9ULJay/eZp1/ma5a/JfBqE8PL4G0J
        ugHfTtv71ORSmHzNKWNkkIJvPXq4qwA=
X-Google-Smtp-Source: AMsMyM4KejC+Gj7bPF0CxMXT+SZ8aB+MKLj2iqOhrP2GpdUTq8TyDneufYoKDsM04c96P4oCqzsfL064NfM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:86d4:0:b0:562:c5e2:a986 with SMTP id
 h20-20020aa786d4000000b00562c5e2a986mr1615268pfo.61.1665695570785; Thu, 13
 Oct 2022 14:12:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 13 Oct 2022 21:12:25 +0000
In-Reply-To: <20221013211234.1318131-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221013211234.1318131-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221013211234.1318131-8-seanjc@google.com>
Subject: [PATCH v2 07/16] KVM: Store gfn_to_pfn_cache length as an immutable property
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michal Luczaj <mhal@rbox.co>

Make the length of a gfn=>pfn cache an immutable property of the cache
to cleanup the APIs and avoid potential bugs, e.g calling check() with a
larger size than refresh() could put KVM into an infinite loop.

All current (and anticipated future) users access the cache with a
predetermined size, which isn't a coincidence as using a dedicated cache
really only make sense when the access pattern is "fixed".

Add a WARN in kvm_setup_guest_pvclock() to assert that the offset+size
matches the length of the cache, both to make it more obvious that the
length really is immutable in that case, and to detect future bugs.

No functional change intended.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c        | 14 ++++++------
 arch/x86/kvm/xen.c        | 46 ++++++++++++++++-----------------------
 include/linux/kvm_host.h  | 14 +++++-------
 include/linux/kvm_types.h |  1 +
 virt/kvm/pfncache.c       | 18 +++++++--------
 5 files changed, 42 insertions(+), 51 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9c68050672de..0b4fa3455f3a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2315,8 +2315,7 @@ static void kvm_write_system_time(struct kvm_vcpu *vcpu, gpa_t system_time,
 
 	/* we verify if the enable bit is set... */
 	if (system_time & 1)
-		kvm_gpc_activate(&vcpu->arch.pv_time, system_time & ~1ULL,
-				 sizeof(struct pvclock_vcpu_time_info));
+		kvm_gpc_activate(&vcpu->arch.pv_time, system_time & ~1ULL);
 	else
 		kvm_gpc_deactivate(&vcpu->arch.pv_time);
 
@@ -3031,13 +3030,13 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
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
@@ -11755,7 +11754,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.regs_avail = ~0;
 	vcpu->arch.regs_dirty = ~0;
 
-	kvm_gpc_init(&vcpu->arch.pv_time, vcpu->kvm, vcpu, KVM_HOST_USES_PFN);
+	kvm_gpc_init(&vcpu->arch.pv_time, vcpu->kvm, vcpu, KVM_HOST_USES_PFN,
+		     sizeof(struct pvclock_vcpu_time_info));
 
 	if (!irqchip_in_kernel(vcpu->kvm) || kvm_vcpu_is_reset_bsp(vcpu))
 		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 55b7195d69d6..6f5a5507392e 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -47,7 +47,7 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
 	}
 
 	do {
-		ret = kvm_gpc_activate(gpc, gpa, PAGE_SIZE);
+		ret = kvm_gpc_activate(gpc, gpa);
 		if (ret)
 			goto out;
 
@@ -203,7 +203,6 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 	struct gfn_to_pfn_cache *gpc = &vx->runstate_cache;
 	uint64_t *user_times;
 	unsigned long flags;
-	size_t user_len;
 	int *user_state;
 
 	kvm_xen_update_runstate(v, state);
@@ -211,17 +210,15 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 	if (!vx->runstate_cache.active)
 		return;
 
-	user_len = sizeof(struct vcpu_runstate_info);
-
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
@@ -347,12 +344,10 @@ void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
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
@@ -412,8 +407,7 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 		     sizeof_field(struct compat_vcpu_info, evtchn_upcall_pending));
 
 	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gpc_check(v->kvm, gpc, gpc->gpa,
-			      sizeof(struct vcpu_info))) {
+	while (!kvm_gpc_check(v->kvm, gpc, gpc->gpa)) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
 		/*
@@ -427,8 +421,7 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 		if (in_atomic() || !task_is_running(current))
 			return 1;
 
-		if (kvm_gpc_refresh(v->kvm, gpc, gpc->gpa,
-				    sizeof(struct vcpu_info))) {
+		if (kvm_gpc_refresh(v->kvm, gpc, gpc->gpa)) {
 			/*
 			 * If this failed, userspace has screwed up the
 			 * vcpu_info mapping. No interrupts for you.
@@ -555,7 +548,7 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 		}
 
 		r = kvm_gpc_activate(&vcpu->arch.xen.vcpu_info_cache,
-				     data->u.gpa, sizeof(struct vcpu_info));
+				     data->u.gpa);
 		if (!r)
 			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 
@@ -569,8 +562,7 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 		}
 
 		r = kvm_gpc_activate(&vcpu->arch.xen.vcpu_time_info_cache,
-				     data->u.gpa,
-				     sizeof(struct pvclock_vcpu_time_info));
+				     data->u.gpa);
 		if (!r)
 			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 		break;
@@ -587,8 +579,7 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 		}
 
 		r = kvm_gpc_activate(&vcpu->arch.xen.runstate_cache,
-				     data->u.gpa,
-				     sizeof(struct vcpu_runstate_info));
+				     data->u.gpa);
 		break;
 
 	case KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT:
@@ -956,7 +947,7 @@ static bool wait_pending_event(struct kvm_vcpu *vcpu, int nr_ports,
 
 	read_lock_irqsave(&gpc->lock, flags);
 	idx = srcu_read_lock(&kvm->srcu);
-	if (!kvm_gpc_check(kvm, gpc, gpc->gpa, PAGE_SIZE))
+	if (!kvm_gpc_check(kvm, gpc, gpc->gpa))
 		goto out_rcu;
 
 	ret = false;
@@ -1347,7 +1338,7 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 	idx = srcu_read_lock(&kvm->srcu);
 
 	read_lock_irqsave(&gpc->lock, flags);
-	if (!kvm_gpc_check(kvm, gpc, gpc->gpa, PAGE_SIZE))
+	if (!kvm_gpc_check(kvm, gpc, gpc->gpa))
 		goto out_rcu;
 
 	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode) {
@@ -1381,7 +1372,7 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 		gpc = &vcpu->arch.xen.vcpu_info_cache;
 
 		read_lock_irqsave(&gpc->lock, flags);
-		if (!kvm_gpc_check(kvm, gpc, gpc->gpa, sizeof(struct vcpu_info))) {
+		if (!kvm_gpc_check(kvm, gpc, gpc->gpa)) {
 			/*
 			 * Could not access the vcpu_info. Set the bit in-kernel
 			 * and prod the vCPU to deliver it for itself.
@@ -1479,7 +1470,7 @@ static int kvm_xen_set_evtchn(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 			break;
 
 		idx = srcu_read_lock(&kvm->srcu);
-		rc = kvm_gpc_refresh(kvm, gpc, gpc->gpa, PAGE_SIZE);
+		rc = kvm_gpc_refresh(kvm, gpc, gpc->gpa);
 		srcu_read_unlock(&kvm->srcu, idx);
 	} while(!rc);
 
@@ -1809,11 +1800,11 @@ void kvm_xen_init_vcpu(struct kvm_vcpu *vcpu)
 	timer_setup(&vcpu->arch.xen.poll_timer, cancel_evtchn_poll, 0);
 
 	kvm_gpc_init(&vcpu->arch.xen.runstate_cache, vcpu->kvm, NULL,
-		     KVM_HOST_USES_PFN);
+		     KVM_HOST_USES_PFN, sizeof(struct vcpu_runstate_info));
 	kvm_gpc_init(&vcpu->arch.xen.vcpu_info_cache, vcpu->kvm, NULL,
-		     KVM_HOST_USES_PFN);
+		     KVM_HOST_USES_PFN, sizeof(struct vcpu_info));
 	kvm_gpc_init(&vcpu->arch.xen.vcpu_time_info_cache, vcpu->kvm, NULL,
-		     KVM_HOST_USES_PFN);
+		     KVM_HOST_USES_PFN, sizeof(struct pvclock_vcpu_time_info));
 }
 
 void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
@@ -1831,7 +1822,8 @@ void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
 void kvm_xen_init_vm(struct kvm *kvm)
 {
 	idr_init(&kvm->arch.xen.evtchn_ports);
-	kvm_gpc_init(&kvm->arch.xen.shinfo_cache, kvm, NULL, KVM_HOST_USES_PFN);
+	kvm_gpc_init(&kvm->arch.xen.shinfo_cache, kvm, NULL, KVM_HOST_USES_PFN,
+		     PAGE_SIZE);
 }
 
 void kvm_xen_destroy_vm(struct kvm *kvm)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e5e70607a5ef..c79f2e122ac8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1252,13 +1252,15 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn);
  *		   changes!---will also force @vcpu to exit the guest and
  *		   refresh the cache); and/or if the PFN used directly
  *		   by KVM (and thus needs a kernel virtual mapping).
+ * @len:	   sanity check; the range being access must fit a single page.
  *
  * This sets up a gfn_to_pfn_cache by initializing locks and assigning the
  * immutable attributes.  Note, the cache must be zero-allocated (or zeroed by
  * the caller before init).
  */
 void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm,
-		  struct kvm_vcpu *vcpu, enum pfn_cache_usage usage);
+		  struct kvm_vcpu *vcpu, enum pfn_cache_usage usage,
+		  unsigned long len);
 
 /**
  * kvm_gpc_activate - prepare a cached kernel mapping and HPA for a given guest
@@ -1266,7 +1268,6 @@ void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm,
  *
  * @gpc:	   struct gfn_to_pfn_cache object.
  * @gpa:	   guest physical address to map.
- * @len:	   sanity check; the range being access must fit a single page.
  *
  * @return:	   0 for success.
  *		   -EINVAL for a mapping which would cross a page boundary.
@@ -1276,7 +1277,7 @@ void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm,
  * invalidations to be processed.  Callers are required to use kvm_gpc_check()
  * to ensure that the cache is valid before accessing the target page.
  */
-int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len);
+int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa);
 
 /**
  * kvm_gpc_check - check validity of a gfn_to_pfn_cache.
@@ -1284,7 +1285,6 @@ int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
  * @kvm:	   pointer to kvm instance.
  * @gpc:	   struct gfn_to_pfn_cache object.
  * @gpa:	   current guest physical address to map.
- * @len:	   sanity check; the range being access must fit a single page.
  *
  * @return:	   %true if the cache is still valid and the address matches.
  *		   %false if the cache is not valid.
@@ -1296,8 +1296,7 @@ int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
  * Callers in IN_GUEST_MODE may do so without locking, although they should
  * still hold a read lock on kvm->scru for the memslot checks.
  */
-bool kvm_gpc_check(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa,
-		   unsigned long len);
+bool kvm_gpc_check(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa);
 
 /**
  * kvm_gpc_refresh - update a previously initialized cache.
@@ -1317,8 +1316,7 @@ bool kvm_gpc_check(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa,
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
index 6756dfa60d5a..34883ad12536 100644
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
@@ -238,8 +237,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 	return -EFAULT;
 }
 
-int kvm_gpc_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa,
-		    unsigned long len)
+int kvm_gpc_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa)
 {
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 	unsigned long page_offset = gpa & ~PAGE_MASK;
@@ -253,7 +251,7 @@ int kvm_gpc_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa,
 	 * If must fit within a single page. The 'len' argument is
 	 * only to enforce that.
 	 */
-	if (page_offset + len > PAGE_SIZE)
+	if (page_offset + gpc->len > PAGE_SIZE)
 		return -EINVAL;
 
 	/*
@@ -358,7 +356,8 @@ void kvm_gpc_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 EXPORT_SYMBOL_GPL(kvm_gpc_unmap);
 
 void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm,
-		  struct kvm_vcpu *vcpu, enum pfn_cache_usage usage)
+		  struct kvm_vcpu *vcpu, enum pfn_cache_usage usage,
+		  unsigned long len)
 {
 	WARN_ON_ONCE(!usage || (usage & KVM_GUEST_AND_HOST_USE_PFN) != usage);
 	WARN_ON_ONCE((usage & KVM_GUEST_USES_PFN) && !vcpu);
@@ -369,10 +368,11 @@ void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm,
 	gpc->kvm = kvm;
 	gpc->vcpu = vcpu;
 	gpc->usage = usage;
+	gpc->len = len;
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_init);
 
-int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
+int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa)
 {
 	struct kvm *kvm = gpc->kvm;
 
@@ -395,7 +395,7 @@ int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
 		gpc->active = true;
 		write_unlock_irq(&gpc->lock);
 	}
-	return kvm_gpc_refresh(kvm, gpc, gpa, len);
+	return kvm_gpc_refresh(kvm, gpc, gpa);
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_activate);
 
-- 
2.38.0.413.g74048e4d9e-goog

