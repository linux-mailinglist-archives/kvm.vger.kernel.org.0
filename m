Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1484D4B025F
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 02:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233015AbiBJBcW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 20:32:22 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:40094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233075AbiBJBcO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 20:32:14 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D9A22539
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 17:32:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=HALpeGgwypjw8MPeLKmaRZHjwCcQf1V3jfzDjp9cnpY=; b=BiwDSeCRV8kkY4kv8LLUvBlEHF
        s5Phbg6paTRSL19uIwZeVf05nTTgIDx7qdnTtS5obPsIvh9ecTf+LiH30j1HroDnL5YUtTvYQIzkR
        0qtXaGR2QlyoVUNx3eqtiZv6mxBeGDF4DykCxCl+xdn+PK3Qys6VxwMfXkdchOfc0zCQVG0Mp9jjq
        6Ao+Vr1sgFOxonbUEArytPegTQaBjBUnM70Jbdt1Hq0VT8NGylQEFxN3MjJeOsQg2mvdI3FVFZLvF
        TKrcbmc5rzYSGLre9euXIuasQyaCmSNKYlusY5skA7TOP94mJFPtsLIpGf3Iy/cCaiOdBJjY1S/F5
        yP03wlQA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nHxIy-008xl3-Go; Thu, 10 Feb 2022 00:27:24 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nHxIy-0019Cy-16; Thu, 10 Feb 2022 00:27:24 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Metin Kaya <metikaya@amazon.co.uk>,
        Paul Durrant <pdurrant@amazon.co.uk>
Subject: [PATCH v0 04/15] KVM: x86/xen: Use gfn_to_pfn_cache for vcpu_info
Date:   Thu, 10 Feb 2022 00:27:10 +0000
Message-Id: <20220210002721.273608-5-dwmw2@infradead.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220210002721.273608-1-dwmw2@infradead.org>
References: <20220210002721.273608-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Currently, the fast path of kvm_xen_set_evtchn_fast() doesn't set the
index bits in the target vCPU's evtchn_pending_sel, because it only has
a userspace virtual address with which to do so. It just sets them in
the kernel, and kvm_xen_has_interrupt() then completes the delivery to
the actual vcpu_info structure when the vCPU runs.

Using a gfn_to_pfn_cache allows kvm_xen_set_evtchn_fast() to do the full
delivery in the common case.

Clean up the fallback case too, by moving the deferred delivery out into
a separate kvm_xen_inject_pending_events() function which isn't ever
called in atomic contexts as __kvm_xen_has_interrupt() is.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |   3 +-
 arch/x86/kvm/x86.c              |   9 +-
 arch/x86/kvm/xen.c              | 246 +++++++++++++++++---------------
 arch/x86/kvm/xen.h              |  20 ++-
 4 files changed, 157 insertions(+), 121 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c64b80c07fdd..118c9ce8e821 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -601,9 +601,8 @@ struct kvm_vcpu_hv {
 struct kvm_vcpu_xen {
 	u64 hypercall_rip;
 	u32 current_runstate;
-	bool vcpu_info_set;
 	bool vcpu_time_info_set;
-	struct gfn_to_hva_cache vcpu_info_cache;
+	struct gfn_to_pfn_cache vcpu_info_cache;
 	struct gfn_to_hva_cache vcpu_time_info_cache;
 	struct gfn_to_pfn_cache runstate_cache;
 	u64 last_steal;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 992baebf0a58..268f64b70768 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3116,9 +3116,9 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 
 	if (vcpu->pv_time.active)
 		kvm_setup_guest_pvclock(v, &vcpu->pv_time, 0);
-	if (vcpu->xen.vcpu_info_set)
-		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_info_cache,
-				       offsetof(struct compat_vcpu_info, time));
+	if (vcpu->xen.vcpu_info_cache.active)
+		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_info_cache,
+					offsetof(struct compat_vcpu_info, time));
 	if (vcpu->xen.vcpu_time_info_set)
 		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_time_info_cache, 0);
 	if (!v->vcpu_idx)
@@ -10295,6 +10295,9 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 			break;
 
 		kvm_clear_request(KVM_REQ_UNBLOCK, vcpu);
+		if (kvm_xen_has_pending_events(vcpu))
+			kvm_xen_inject_pending_events(vcpu);
+
 		if (kvm_cpu_has_pending_timer(vcpu))
 			kvm_inject_pending_timer_irqs(vcpu);
 
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 5d40d6521440..545c1d5c070e 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -8,6 +8,7 @@
 
 #include "x86.h"
 #include "xen.h"
+#include "lapic.h"
 #include "hyperv.h"
 
 #include <linux/kvm_host.h>
@@ -244,23 +245,80 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 	mark_page_dirty_in_slot(v->kvm, gpc->memslot, gpc->gpa >> PAGE_SHIFT);
 }
 
-int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
+/*
+ * On event channel delivery, the vcpu_info may not have been accessible.
+ * In that case, there are bits in vcpu->arch.xen.evtchn_pending_sel which
+ * need to be marked into the vcpu_info (and evtchn_upcall_pending set).
+ * Do so now that we can sleep in the context of the vCPU to bring the
+ * page in, and refresh the pfn cache for it.
+ */
+void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
 {
 	unsigned long evtchn_pending_sel = READ_ONCE(v->arch.xen.evtchn_pending_sel);
-	bool atomic = in_atomic() || !task_is_running(current);
-	int err;
+	struct gfn_to_pfn_cache *gpc = &v->arch.xen.vcpu_info_cache;
+	unsigned long flags;
+
+	if (!evtchn_pending_sel)
+		return;
+
+	/*
+	 * Yes, this is an open-coded loop. But that's just what put_user()
+	 * does anyway. Page it in and retry the instruction. We're just a
+	 * little more honest about it.
+	 */
+	read_lock_irqsave(&gpc->lock, flags);
+	while (!kvm_gfn_to_pfn_cache_check(v->kvm, gpc, gpc->gpa,
+					   sizeof(struct vcpu_info))) {
+		read_unlock_irqrestore(&gpc->lock, flags);
+
+		if (kvm_gfn_to_pfn_cache_refresh(v->kvm, gpc, gpc->gpa,
+						 sizeof(struct vcpu_info),
+						 false))
+			return;
+
+		read_lock_irqsave(&gpc->lock, flags);
+	}
+
+	/* Now gpc->khva is a valid kernel address for the vcpu_info */
+	if (IS_ENABLED(CONFIG_64BIT) && v->kvm->arch.xen.long_mode) {
+		struct vcpu_info *vi = gpc->khva;
+
+		asm volatile(LOCK_PREFIX "orq %0, %1\n"
+			     "notq %0\n"
+			     LOCK_PREFIX "andq %0, %2\n"
+			     : "=r" (evtchn_pending_sel),
+			       "+m" (vi->evtchn_pending_sel),
+			       "+m" (v->arch.xen.evtchn_pending_sel)
+			     : "0" (evtchn_pending_sel));
+		WRITE_ONCE(vi->evtchn_upcall_pending, 1);
+	} else {
+		u32 evtchn_pending_sel32 = evtchn_pending_sel;
+		struct compat_vcpu_info *vi = gpc->khva;
+
+		asm volatile(LOCK_PREFIX "orl %0, %1\n"
+			     "notl %0\n"
+			     LOCK_PREFIX "andl %0, %2\n"
+			     : "=r" (evtchn_pending_sel32),
+			       "+m" (vi->evtchn_pending_sel),
+			       "+m" (v->arch.xen.evtchn_pending_sel)
+			     : "0" (evtchn_pending_sel32));
+		WRITE_ONCE(vi->evtchn_upcall_pending, 1);
+	}
+	read_unlock_irqrestore(&gpc->lock, flags);
+
+	mark_page_dirty_in_slot(v->kvm, gpc->memslot, gpc->gpa >> PAGE_SHIFT);
+}
+
+int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
+{
+	struct gfn_to_pfn_cache *gpc = &v->arch.xen.vcpu_info_cache;
+	unsigned long flags;
 	u8 rc = 0;
 
 	/*
 	 * If the global upcall vector (HVMIRQ_callback_vector) is set and
 	 * the vCPU's evtchn_upcall_pending flag is set, the IRQ is pending.
 	 */
-	struct gfn_to_hva_cache *ghc = &v->arch.xen.vcpu_info_cache;
-	struct kvm_memslots *slots = kvm_memslots(v->kvm);
-	bool ghc_valid = slots->generation == ghc->generation &&
-		!kvm_is_error_hva(ghc->hva) && ghc->memslot;
-
-	unsigned int offset = offsetof(struct vcpu_info, evtchn_upcall_pending);
 
 	/* No need for compat handling here */
 	BUILD_BUG_ON(offsetof(struct vcpu_info, evtchn_upcall_pending) !=
@@ -270,101 +328,36 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 	BUILD_BUG_ON(sizeof(rc) !=
 		     sizeof_field(struct compat_vcpu_info, evtchn_upcall_pending));
 
-	/*
-	 * For efficiency, this mirrors the checks for using the valid
-	 * cache in kvm_read_guest_offset_cached(), but just uses
-	 * __get_user() instead. And falls back to the slow path.
-	 */
-	if (!evtchn_pending_sel && ghc_valid) {
-		/* Fast path */
-		pagefault_disable();
-		err = __get_user(rc, (u8 __user *)ghc->hva + offset);
-		pagefault_enable();
-		if (!err)
-			return rc;
-	}
-
-	/* Slow path */
+	read_lock_irqsave(&gpc->lock, flags);
+	while (!kvm_gfn_to_pfn_cache_check(v->kvm, gpc, gpc->gpa,
+					   sizeof(struct vcpu_info))) {
+		read_unlock_irqrestore(&gpc->lock, flags);
 
-	/*
-	 * This function gets called from kvm_vcpu_block() after setting the
-	 * task to TASK_INTERRUPTIBLE, to see if it needs to wake immediately
-	 * from a HLT. So we really mustn't sleep. If the page ended up absent
-	 * at that point, just return 1 in order to trigger an immediate wake,
-	 * and we'll end up getting called again from a context where we *can*
-	 * fault in the page and wait for it.
-	 */
-	if (atomic)
-		return 1;
+		/*
+		 * This function gets called from kvm_vcpu_block() after setting the
+		 * task to TASK_INTERRUPTIBLE, to see if it needs to wake immediately
+		 * from a HLT. So we really mustn't sleep. If the page ended up absent
+		 * at that point, just return 1 in order to trigger an immediate wake,
+		 * and we'll end up getting called again from a context where we *can*
+		 * fault in the page and wait for it.
+		 */
+		if (in_atomic() || !task_is_running(current))
+			return 1;
 
-	if (!ghc_valid) {
-		err = kvm_gfn_to_hva_cache_init(v->kvm, ghc, ghc->gpa, ghc->len);
-		if (err || !ghc->memslot) {
+		if (kvm_gfn_to_pfn_cache_refresh(v->kvm, gpc, gpc->gpa,
+						 sizeof(struct vcpu_info),
+						 false)) {
 			/*
 			 * If this failed, userspace has screwed up the
 			 * vcpu_info mapping. No interrupts for you.
 			 */
 			return 0;
 		}
+		read_lock_irqsave(&gpc->lock, flags);
 	}
 
-	/*
-	 * Now we have a valid (protected by srcu) userspace HVA in
-	 * ghc->hva which points to the struct vcpu_info. If there
-	 * are any bits in the in-kernel evtchn_pending_sel then
-	 * we need to write those to the guest vcpu_info and set
-	 * its evtchn_upcall_pending flag. If there aren't any bits
-	 * to add, we only want to *check* evtchn_upcall_pending.
-	 */
-	if (evtchn_pending_sel) {
-		bool long_mode = v->kvm->arch.xen.long_mode;
-
-		if (!user_access_begin((void __user *)ghc->hva, sizeof(struct vcpu_info)))
-			return 0;
-
-		if (IS_ENABLED(CONFIG_64BIT) && long_mode) {
-			struct vcpu_info __user *vi = (void __user *)ghc->hva;
-
-			/* Attempt to set the evtchn_pending_sel bits in the
-			 * guest, and if that succeeds then clear the same
-			 * bits in the in-kernel version. */
-			asm volatile("1:\t" LOCK_PREFIX "orq %0, %1\n"
-				     "\tnotq %0\n"
-				     "\t" LOCK_PREFIX "andq %0, %2\n"
-				     "2:\n"
-				     _ASM_EXTABLE_UA(1b, 2b)
-				     : "=r" (evtchn_pending_sel),
-				       "+m" (vi->evtchn_pending_sel),
-				       "+m" (v->arch.xen.evtchn_pending_sel)
-				     : "0" (evtchn_pending_sel));
-		} else {
-			struct compat_vcpu_info __user *vi = (void __user *)ghc->hva;
-			u32 evtchn_pending_sel32 = evtchn_pending_sel;
-
-			/* Attempt to set the evtchn_pending_sel bits in the
-			 * guest, and if that succeeds then clear the same
-			 * bits in the in-kernel version. */
-			asm volatile("1:\t" LOCK_PREFIX "orl %0, %1\n"
-				     "\tnotl %0\n"
-				     "\t" LOCK_PREFIX "andl %0, %2\n"
-				     "2:\n"
-				     _ASM_EXTABLE_UA(1b, 2b)
-				     : "=r" (evtchn_pending_sel32),
-				       "+m" (vi->evtchn_pending_sel),
-				       "+m" (v->arch.xen.evtchn_pending_sel)
-				     : "0" (evtchn_pending_sel32));
-		}
-		rc = 1;
-		unsafe_put_user(rc, (u8 __user *)ghc->hva + offset, err);
-
-	err:
-		user_access_end();
-
-		mark_page_dirty_in_slot(v->kvm, ghc->memslot, ghc->gpa >> PAGE_SHIFT);
-	} else {
-		__get_user(rc, (u8 __user *)ghc->hva + offset);
-	}
-
+	rc = ((struct vcpu_info *)gpc->khva)->evtchn_upcall_pending;
+	read_unlock_irqrestore(&gpc->lock, flags);
 	return rc;
 }
 
@@ -454,25 +447,18 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 			     offsetof(struct compat_vcpu_info, time));
 
 		if (data->u.gpa == GPA_INVALID) {
-			vcpu->arch.xen.vcpu_info_set = false;
+			kvm_gfn_to_pfn_cache_destroy(vcpu->kvm, &vcpu->arch.xen.vcpu_info_cache);
 			r = 0;
 			break;
 		}
 
-		/* It must fit within a single page */
-		if ((data->u.gpa & ~PAGE_MASK) + sizeof(struct vcpu_info) > PAGE_SIZE) {
-			r = -EINVAL;
-			break;
-		}
-
-		r = kvm_gfn_to_hva_cache_init(vcpu->kvm,
+		r = kvm_gfn_to_pfn_cache_init(vcpu->kvm,
 					      &vcpu->arch.xen.vcpu_info_cache,
-					      data->u.gpa,
-					      sizeof(struct vcpu_info));
-		if (!r) {
-			vcpu->arch.xen.vcpu_info_set = true;
+					      NULL, false, true, data->u.gpa,
+					      sizeof(struct vcpu_info), false);
+		if (!r)
 			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
-		}
+
 		break;
 
 	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO:
@@ -629,7 +615,7 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 
 	switch (data->type) {
 	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO:
-		if (vcpu->arch.xen.vcpu_info_set)
+		if (vcpu->arch.xen.vcpu_info_cache.active)
 			data->u.gpa = vcpu->arch.xen.vcpu_info_cache.gpa;
 		else
 			data->u.gpa = GPA_INVALID;
@@ -902,16 +888,17 @@ int kvm_xen_set_evtchn_fast(struct kvm_kernel_irq_routing_entry *e,
 	if (!vcpu)
 		return -1;
 
-	if (!vcpu->arch.xen.vcpu_info_set)
+	if (!vcpu->arch.xen.vcpu_info_cache.active)
 		return -1;
 
 	if (e->xen_evtchn.port >= max_evtchn_port(kvm))
 		return -1;
 
 	rc = -EWOULDBLOCK;
-	read_lock_irqsave(&gpc->lock, flags);
 
 	idx = srcu_read_lock(&kvm->srcu);
+
+	read_lock_irqsave(&gpc->lock, flags);
 	if (!kvm_gfn_to_pfn_cache_check(kvm, gpc, gpc->gpa, PAGE_SIZE))
 		goto out_rcu;
 
@@ -939,17 +926,44 @@ int kvm_xen_set_evtchn_fast(struct kvm_kernel_irq_routing_entry *e,
 	} else if (test_bit(e->xen_evtchn.port, mask_bits)) {
 		rc = -1; /* Masked */
 	} else {
-		rc = 1; /* Delivered. But was the vCPU waking already? */
-		if (!test_and_set_bit(port_word_bit, &vcpu->arch.xen.evtchn_pending_sel))
-			kick_vcpu = true;
+		rc = 1; /* Delivered to the bitmap in shared_info. */
+		/* Now switch to the vCPU's vcpu_info to set the index and pending_sel */
+		read_unlock_irqrestore(&gpc->lock, flags);
+		gpc = &vcpu->arch.xen.vcpu_info_cache;
+
+		read_lock_irqsave(&gpc->lock, flags);
+		if (!kvm_gfn_to_pfn_cache_check(kvm, gpc, gpc->gpa, sizeof(struct vcpu_info))) {
+			/*
+			 * Could not access the vcpu_info. Set the bit in-kernel
+			 * and prod the vCPU to deliver it for itself.
+			 */
+			if (!test_and_set_bit(port_word_bit, &vcpu->arch.xen.evtchn_pending_sel))
+				kick_vcpu = true;
+			goto out_rcu;
+		}
+
+		if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode) {
+			struct vcpu_info *vcpu_info = gpc->khva;
+			if (!test_and_set_bit(port_word_bit, &vcpu_info->evtchn_pending_sel)) {
+				WRITE_ONCE(vcpu_info->evtchn_upcall_pending, 1);
+				kick_vcpu = true;
+			}
+		} else {
+			struct compat_vcpu_info *vcpu_info = gpc->khva;
+			if (!test_and_set_bit(port_word_bit,
+					      (unsigned long *)&vcpu_info->evtchn_pending_sel)) {
+				WRITE_ONCE(vcpu_info->evtchn_upcall_pending, 1);
+				kick_vcpu = true;
+			}
+		}
 	}
 
  out_rcu:
-	srcu_read_unlock(&kvm->srcu, idx);
 	read_unlock_irqrestore(&gpc->lock, flags);
+	srcu_read_unlock(&kvm->srcu, idx);
 
 	if (kick_vcpu) {
-		kvm_make_request(KVM_REQ_EVENT, vcpu);
+		kvm_make_request(KVM_REQ_UNBLOCK, vcpu);
 		kvm_vcpu_kick(vcpu);
 	}
 
@@ -1052,4 +1066,6 @@ void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
 {
 	kvm_gfn_to_pfn_cache_destroy(vcpu->kvm,
 				     &vcpu->arch.xen.runstate_cache);
+	kvm_gfn_to_pfn_cache_destroy(vcpu->kvm,
+				     &vcpu->arch.xen.vcpu_info_cache);
 }
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index 54b2bf4c3001..7dd0590f93e1 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -15,6 +15,7 @@
 extern struct static_key_false_deferred kvm_xen_enabled;
 
 int __kvm_xen_has_interrupt(struct kvm_vcpu *vcpu);
+void kvm_xen_inject_pending_events(struct kvm_vcpu *vcpu);
 int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data);
 int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data);
 int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
@@ -46,11 +47,19 @@ static inline bool kvm_xen_hypercall_enabled(struct kvm *kvm)
 static inline int kvm_xen_has_interrupt(struct kvm_vcpu *vcpu)
 {
 	if (static_branch_unlikely(&kvm_xen_enabled.key) &&
-	    vcpu->arch.xen.vcpu_info_set && vcpu->kvm->arch.xen.upcall_vector)
+	    vcpu->arch.xen.vcpu_info_cache.active &&
+	    vcpu->kvm->arch.xen.upcall_vector)
 		return __kvm_xen_has_interrupt(vcpu);
 
 	return 0;
 }
+
+static inline bool kvm_xen_has_pending_events(struct kvm_vcpu *vcpu)
+{
+	return static_branch_unlikely(&kvm_xen_enabled.key) &&
+		vcpu->arch.xen.evtchn_pending_sel;
+}
+
 #else
 static inline int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
 {
@@ -83,6 +92,15 @@ static inline int kvm_xen_has_interrupt(struct kvm_vcpu *vcpu)
 {
 	return 0;
 }
+
+static inline void kvm_xen_inject_pending_events(struct kvm_vcpu *vcpu)
+{
+}
+
+static inline bool kvm_xen_has_pending_events(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
 #endif
 
 int kvm_xen_hypercall(struct kvm_vcpu *vcpu);
-- 
2.33.1

