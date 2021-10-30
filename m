Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57EBE440B8A
	for <lists+kvm@lfdr.de>; Sat, 30 Oct 2021 21:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbhJ3TtF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Oct 2021 15:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbhJ3TtD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Oct 2021 15:49:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0DEC061714
        for <kvm@vger.kernel.org>; Sat, 30 Oct 2021 12:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=CTipiThJwKeDuNSL4zHzz6Nb4U8vVqXf8zUfZyma/GM=; b=c04s4OWl07HaEGk5fJb1Ws670j
        J8gxfpPRK+VnFMqgbJt5560TILD5byYfbLxf5+EITREEMOsKdQLL0EjwesXuS2h3SHGm19fR9Ydek
        Cw+l+em4RvAqb3flRoYDh1trFvQUGSgvka45oKgyVQSqrRK58gtzEQTj5yFRb3C49LdIDVAF0XRVZ
        BIBlK2s/SkO9scYzqgMLxvvFgJ5y98eWMuuY+qj4G2g54RB/zHh+QK5+rOp6SDtdVevu2++ndKxIq
        FtM3Xqc2qMGHJRIFg8RRiN63ELH8IknPB9PAHFWNYJCW0DM7mLEGmnYF3D2P8abZHRQw0MNMQNO1J
        PrFO3kpA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mguHF-002cmP-F8; Sat, 30 Oct 2021 19:45:12 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mguHE-00066M-Up; Sat, 30 Oct 2021 20:44:29 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     "kvm @ vger . kernel . org" <kvm@vger.kernel.org>
Cc:     "jmattson @ google . com" <jmattson@google.com>,
        "pbonzini @ redhat . com" <pbonzini@redhat.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "seanjc @ google . com" <seanjc@google.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>, karahmed@amazon.com
Subject: [PATCH 5/5] KVM: x86/xen: Add KVM_IRQ_ROUTING_XEN_EVTCHN and event channel delivery
Date:   Sat, 30 Oct 2021 20:44:28 +0100
Message-Id: <20211030194428.23395-5-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211030194428.23395-1-dwmw2@infradead.org>
References: <20211030194428.23395-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

This adds basic support for delivering 2 level event channels to a guest.

Initially, it only supports delivery via the IRQ routing table, triggered
by an eventfd. In order to do so, it has a kvm_xen_set_evtchn_fast()
function which will use the pre-mapped shared_info page if it already
exists and is still valid, while the slow path through the irqfd_inject
workqueue will remap the shared_info page if necessary.

It sets the bits in the shared_info page but not the vcpu_info; that is
deferred to __kvm_xen_has_interrupt() which raises the vector to the
appropriate vCPU.

The slow path takes into account the fact that the shared_info may be
invalidated asynchronously (from an MMU notifier) even though that isn't
yet actually implemented.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 Documentation/virt/kvm/api.rst                |  21 ++
 arch/x86/include/asm/kvm_host.h               |   1 +
 arch/x86/kvm/irq_comm.c                       |  12 +
 arch/x86/kvm/x86.c                            |   3 +-
 arch/x86/kvm/xen.c                            | 272 +++++++++++++++++-
 arch/x86/kvm/xen.h                            |   6 +
 include/linux/kvm_host.h                      |   7 +
 include/uapi/linux/kvm.h                      |  11 +
 .../selftests/kvm/x86_64/xen_shinfo_test.c    |  99 ++++++-
 9 files changed, 425 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a6729c8cf063..e11f9eb7f06e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1748,6 +1748,7 @@ No flags are specified so far, the corresponding field must be set to zero.
 		struct kvm_irq_routing_msi msi;
 		struct kvm_irq_routing_s390_adapter adapter;
 		struct kvm_irq_routing_hv_sint hv_sint;
+		struct kvm_irq_routing_xen_evtchn xen_evtchn;
 		__u32 pad[8];
 	} u;
   };
@@ -1757,6 +1758,7 @@ No flags are specified so far, the corresponding field must be set to zero.
   #define KVM_IRQ_ROUTING_MSI 2
   #define KVM_IRQ_ROUTING_S390_ADAPTER 3
   #define KVM_IRQ_ROUTING_HV_SINT 4
+  #define KVM_IRQ_ROUTING_XEN_EVTCHN 5
 
 flags:
 
@@ -1808,6 +1810,20 @@ address_hi must be zero.
 	__u32 sint;
   };
 
+  struct kvm_xen_evtchn {
+	__u32 port;
+	__u32 vcpu;
+	__u32 priority;
+  };
+
+
+When KVM_CAP_XEN_HVM includes the KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL bit
+in its indication of supported features, routing to Xen event channels
+is supported. Although the priority field is present, only the value
+KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL is supported, which means delivery by
+2 level event channels. FIFO event channel support may be added in
+the future.
+
 
 4.55 KVM_SET_TSC_KHZ
 --------------------
@@ -7182,6 +7198,7 @@ PVHVM guests. Valid flags are::
   #define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
   #define KVM_XEN_HVM_CONFIG_SHARED_INFO	(1 << 2)
   #define KVM_XEN_HVM_CONFIG_RUNSTATE		(1 << 2)
+  #define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL	(1 << 3)
 
 The KVM_XEN_HVM_CONFIG_HYPERCALL_MSR flag indicates that the KVM_XEN_HVM_CONFIG
 ioctl is available, for the guest to set its hypercall page.
@@ -7201,6 +7218,10 @@ The KVM_XEN_HVM_CONFIG_RUNSTATE flag indicates that the runstate-related
 features KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR/_CURRENT/_DATA/_ADJUST are
 supported by the KVM_XEN_VCPU_SET_ATTR/KVM_XEN_VCPU_GET_ATTR ioctls.
 
+The KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL flag indicates that IRQ routing entries
+of the type KVM_IRQ_ROUTING_XEN_EVTCHN are supported, with the priority
+field set to indicate 2 level event channel delivery.
+
 8.31 KVM_CAP_PPC_MULTITCE
 -------------------------
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e264301f71d7..61f402924ed9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -606,6 +606,7 @@ struct kvm_vcpu_xen {
 	u64 last_steal;
 	u64 runstate_entry_time;
 	u64 runstate_times[4];
+	unsigned long evtchn_pending_sel;
 };
 
 struct kvm_vcpu_arch {
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index d5b72a08e566..afd2de84be60 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -24,6 +24,7 @@
 
 #include "hyperv.h"
 #include "x86.h"
+#include "xen.h"
 
 static int kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
 			   struct kvm *kvm, int irq_source_id, int level,
@@ -175,6 +176,13 @@ int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
 			return r;
 		break;
 
+#ifdef CONFIG_KVM_XEN
+	case KVM_IRQ_ROUTING_XEN_EVTCHN:
+		if (!level)
+			return -1;
+
+		return kvm_xen_set_evtchn_fast(e, kvm);
+#endif
 	default:
 		break;
 	}
@@ -310,6 +318,10 @@ int kvm_set_routing_entry(struct kvm *kvm,
 		e->hv_sint.vcpu = ue->u.hv_sint.vcpu;
 		e->hv_sint.sint = ue->u.hv_sint.sint;
 		break;
+#ifdef CONFIG_KVM_XEN
+	case KVM_IRQ_ROUTING_XEN_EVTCHN:
+		return kvm_xen_setup_evtchn(kvm, e, ue);
+#endif
 	default:
 		return -EINVAL;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8e9b850d967b..0c6fd42b0506 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4039,7 +4039,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_XEN_HVM:
 		r = KVM_XEN_HVM_CONFIG_HYPERCALL_MSR |
 		    KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL |
-		    KVM_XEN_HVM_CONFIG_SHARED_INFO;
+		    KVM_XEN_HVM_CONFIG_SHARED_INFO |
+		    KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL;
 		if (sched_info_on())
 			r |= KVM_XEN_HVM_CONFIG_RUNSTATE;
 		break;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 75bb033c9613..33b647c110ec 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -233,6 +233,8 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
 
 int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 {
+	unsigned long evtchn_pending_sel = READ_ONCE(v->arch.xen.evtchn_pending_sel);
+	bool atomic = in_atomic() || !task_is_running(current);
 	int err;
 	u8 rc = 0;
 
@@ -242,6 +244,9 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 	 */
 	struct gfn_to_hva_cache *ghc = &v->arch.xen.vcpu_info_cache;
 	struct kvm_memslots *slots = kvm_memslots(v->kvm);
+	bool ghc_valid = slots->generation == ghc->generation &&
+		!kvm_is_error_hva(ghc->hva) && ghc->memslot;
+
 	unsigned int offset = offsetof(struct vcpu_info, evtchn_upcall_pending);
 
 	/* No need for compat handling here */
@@ -257,8 +262,7 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 	 * cache in kvm_read_guest_offset_cached(), but just uses
 	 * __get_user() instead. And falls back to the slow path.
 	 */
-	if (likely(slots->generation == ghc->generation &&
-		   !kvm_is_error_hva(ghc->hva) && ghc->memslot)) {
+	if (!evtchn_pending_sel && ghc_valid) {
 		/* Fast path */
 		pagefault_disable();
 		err = __get_user(rc, (u8 __user *)ghc->hva + offset);
@@ -277,11 +281,80 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 	 * and we'll end up getting called again from a context where we *can*
 	 * fault in the page and wait for it.
 	 */
-	if (in_atomic() || !task_is_running(current))
+	if (atomic)
 		return 1;
 
-	kvm_read_guest_offset_cached(v->kvm, ghc, &rc, offset,
-				     sizeof(rc));
+	if (!ghc_valid) {
+		err = kvm_gfn_to_hva_cache_init(v->kvm, ghc, ghc->gpa, ghc->len);
+		if (err && !ghc->memslot) {
+			/*
+			 * If this failed, userspace has screwed up the
+			 * vcpu_info mapping. No interrupts for you.
+			 */
+			return 0;
+		}
+	}
+
+	/*
+	 * Now we have a valid (protected by srcu) userspace HVA in
+	 * ghc->hva which points to the struct vcpu_info. If there
+	 * are any bits in the in-kernel evtchn_pending_sel then
+	 * we need to write those to the guest vcpu_info and set
+	 * its evtchn_upcall_pending flag. If there aren't any bits
+	 * to add, we only want to *check* evtchn_upcall_pending.
+	 */
+	if (evtchn_pending_sel) {
+		if (!user_access_begin((void *)ghc->hva, sizeof(struct vcpu_info)))
+			return 0;
+
+		if (IS_ENABLED(CONFIG_64BIT) && v->kvm->arch.xen.long_mode) {
+			struct vcpu_info __user *vi = (void *)ghc->hva;
+
+			/* Attempt to set the evtchn_pending_sel bits in the
+			 * guest, and if that succeeds then clear the same
+			 * bits in the in-kernel version. */
+			asm volatile("1:\t" LOCK_PREFIX "orq %0, %1\n"
+				     "\tnotq %0\n"
+				     "\t" LOCK_PREFIX "andq %0, %2\n"
+				     "2:\n"
+				     "\t.section .fixup,\"ax\"\n"
+				     "3:\tjmp\t2b\n"
+				     "\t.previous\n"
+				     _ASM_EXTABLE_UA(1b, 3b)
+				     : "=r" (evtchn_pending_sel)
+				     : "m" (vi->evtchn_pending_sel),
+				       "m" (v->arch.xen.evtchn_pending_sel),
+				       "0" (evtchn_pending_sel));
+		} else {
+			struct compat_vcpu_info __user *vi = (void *)ghc->hva;
+			u32 evtchn_pending_sel32 = evtchn_pending_sel;
+
+			/* Attempt to set the evtchn_pending_sel bits in the
+			 * guest, and if that succeeds then clear the same
+			 * bits in the in-kernel version. */
+			asm volatile("1:\t" LOCK_PREFIX "orl %0, %1\n"
+				     "\tnotl %0\n"
+				     "\t" LOCK_PREFIX "andl %0, %2\n"
+				     "2:\n"
+				     "\t.section .fixup,\"ax\"\n"
+				     "3:\tjmp\t2b\n"
+				     "\t.previous\n"
+				     _ASM_EXTABLE_UA(1b, 3b)
+				     : "=r" (evtchn_pending_sel32)
+				     : "m" (vi->evtchn_pending_sel),
+				       "m" (v->arch.xen.evtchn_pending_sel),
+				       "0" (evtchn_pending_sel32));
+		}
+		rc = 1;
+		unsafe_put_user(rc, (u8 __user *)ghc->hva + offset, err);
+
+	err:
+		user_access_end();
+
+		mark_page_dirty_in_slot(v->kvm, ghc->memslot, ghc->gpa >> PAGE_SHIFT);
+	} else {
+		__get_user(rc, (u8 __user *)ghc->hva + offset);
+	}
 
 	return rc;
 }
@@ -801,3 +874,192 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
 
 	return 0;
 }
+
+static inline int max_evtchn_port(struct kvm *kvm)
+{
+	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode)
+		return 4096;
+	else
+		return 1024;
+}
+
+int kvm_xen_set_evtchn_fast(struct kvm_kernel_irq_routing_entry *e,
+			    struct kvm *kvm)
+{
+	struct gfn_to_pfn_cache *gpc = &kvm->arch.xen.shinfo_cache;
+	struct kvm_memslots *slots;
+	struct kvm_vcpu *vcpu;
+	unsigned long *pending_bits, *mask_bits;
+	int port_word_bit;
+	bool kick_vcpu = false;
+	int idx;
+	int rc;
+
+	vcpu = kvm_get_vcpu_by_id(kvm, e->xen_evtchn.vcpu);
+	if (!vcpu)
+		return -EINVAL;
+
+	if (!vcpu->arch.xen.vcpu_info_set)
+		return -EINVAL;
+
+	if (e->xen_evtchn.port >= max_evtchn_port(kvm))
+		return -EINVAL;
+
+	rc = -EWOULDBLOCK;
+	read_lock(&kvm->arch.xen.shinfo_lock);
+	if (!kvm->arch.xen.shared_info)
+		goto out_unlock;
+
+	idx = srcu_read_lock(&kvm->srcu);
+	slots = kvm_memslots(kvm);
+
+	/* The cache may only change while the shared_info pointer is NULL */
+	if (gpc->generation != slots->generation)
+		goto out_rcu;
+
+	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode) {
+		struct shared_info *shinfo = kvm->arch.xen.shared_info;
+		pending_bits = (unsigned long *)&shinfo->evtchn_pending;
+		mask_bits = (unsigned long *)&shinfo->evtchn_mask;
+		port_word_bit = e->xen_evtchn.port / 64;
+	} else {
+		struct compat_shared_info *shinfo = kvm->arch.xen.shared_info;
+		pending_bits = (unsigned long *)&shinfo->evtchn_pending;
+		mask_bits = (unsigned long *)&shinfo->evtchn_mask;
+		port_word_bit = e->xen_evtchn.port / 32;
+	}
+
+	/*
+	 * If this port wasn't already set, and if it isn't masked, then
+	 * we try to set the corresponding bit in the in-kernel shadow of
+	 * evtchn_pending_sel for the target vCPU. And if *that* wasn't
+	 * already set, then we kick the vCPU in question to write to the
+	 * *real* evtchn_pending_sel in its own guest vcpu_info struct.
+	 */
+	if (!test_and_set_bit(e->xen_evtchn.port, pending_bits) &&
+	    !test_bit(e->xen_evtchn.port, mask_bits) &&
+	    !test_and_set_bit(port_word_bit, &vcpu->arch.xen.evtchn_pending_sel))
+		kick_vcpu = true;
+
+	rc = 0;
+
+ out_rcu:
+	srcu_read_unlock(&kvm->srcu, idx);
+ out_unlock:
+	read_unlock(&kvm->arch.xen.shinfo_lock);
+
+	if (kick_vcpu) {
+		kvm_make_request(KVM_REQ_EVENT, vcpu);
+		kvm_vcpu_kick(vcpu);
+	}
+
+	return rc;
+}
+
+/* This is the version called from kvm_set_irq() as the .set function */
+static int evtchn_set_fn(struct kvm_kernel_irq_routing_entry *e, struct kvm *kvm,
+			 int irq_source_id, int level, bool line_status)
+{
+	bool mm_borrowed = false;
+	int rc;
+
+	if (!level)
+		return -1;
+
+	rc = kvm_xen_set_evtchn_fast(e, kvm);
+	if (rc != -EWOULDBLOCK)
+		return rc;
+
+	if (current->mm != kvm->mm) {
+		/* We'd better be in the irqfd workqueue */
+		if (WARN_ON_ONCE(current->mm))
+			return -EINVAL;
+
+		kthread_use_mm(kvm->mm);
+		mm_borrowed = true;
+	}
+
+	/*
+	 * We are invoked from kvm_set_irq() with no locks held, no srcu.
+	 * Taking the overall kvm->lock should be fine; otherwise we might
+	 * need to create a mutex just for the shared_info mapping.
+	 */
+	mutex_lock(&kvm->lock);
+
+	do {
+		rc = kvm_xen_shared_info_init(kvm,
+					      kvm->arch.xen.shinfo_cache.gfn,
+					      false);
+		if (rc)
+			break;
+
+		/*
+		 * At the time of writing, I believe the gfn_to_pfn_cache
+		 * is buggy because it *ought* to be invalidated when the
+		 * MMU notifier informs KVM that the HVA in question is
+		 * unmapped or remapped to a different PFN. Right now, it
+		 * only gets invalidated if the memslots change (which
+		 * can't happen here since this holds the kvm->scru read
+		 * lock). Once that's fixed, however...
+		 *
+		 * It is theoretically possible for the page to be unmapped
+		 * and the MMU notifier to invalidate the shared_info before
+		 * we even get to use it. In that case, this looks like an
+		 * infinite loop. It was tempting to do it via the userspace
+		 * HVA instead... but that just *hides* the fact that it's
+		 * an infinite loop, because if a fault occurs and it waits
+		 * for the page to come back, it can *still* immediately
+		 * fault and have to wait again, repeatedly.
+		 */
+		rc = kvm_xen_set_evtchn_fast(e, kvm);
+
+	} while (rc == -EWOULDBLOCK);
+
+	mutex_unlock(&kvm->lock);
+
+	if (mm_borrowed)
+		kthread_unuse_mm(kvm->mm);
+
+	return rc;
+}
+
+int kvm_xen_setup_evtchn(struct kvm *kvm,
+			 struct kvm_kernel_irq_routing_entry *e,
+			 const struct kvm_irq_routing_entry *ue)
+
+{
+	struct kvm_vcpu *vcpu;
+
+	if (!kvm->arch.xen.shinfo_set)
+		return -EINVAL;
+
+	if (ue->u.xen_evtchn.vcpu >= KVM_MAX_VCPUS)
+		return -EINVAL;
+
+	vcpu = kvm_get_vcpu_by_id(kvm, ue->u.xen_evtchn.vcpu);
+	if (!vcpu)
+		return -EINVAL;
+
+	if (!vcpu->arch.xen.vcpu_info_set)
+		return -EINVAL;
+
+	if (!kvm->arch.xen.upcall_vector)
+		return -EINVAL;
+
+	/* Once we support the per-vCPU LAPIC based vector we will permit
+	 * that here instead of the per-KVM upcall vector */
+
+	if (ue->u.xen_evtchn.port >= max_evtchn_port(kvm))
+		return -EINVAL;
+
+	/* We only support 2 level event channels for now */
+	if (ue->u.xen_evtchn.priority != KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL)
+		return -EINVAL;
+
+	e->xen_evtchn.port = ue->u.xen_evtchn.port;
+	e->xen_evtchn.vcpu = ue->u.xen_evtchn.vcpu;
+	e->xen_evtchn.priority = ue->u.xen_evtchn.priority;
+	e->set = evtchn_set_fn;
+
+	return 0;
+}
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index cc0cf5f37450..5dfb2e1fa2f9 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -24,6 +24,12 @@ int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc);
 void kvm_xen_init_vm(struct kvm *kvm);
 void kvm_xen_destroy_vm(struct kvm *kvm);
 
+int kvm_xen_set_evtchn_fast(struct kvm_kernel_irq_routing_entry *e,
+			    struct kvm *kvm);
+int kvm_xen_setup_evtchn(struct kvm *kvm,
+			 struct kvm_kernel_irq_routing_entry *e,
+			 const struct kvm_irq_routing_entry *ue);
+
 static inline bool kvm_xen_msr_enabled(struct kvm *kvm)
 {
 	return static_branch_unlikely(&kvm_xen_enabled.key) &&
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9dab85a55e19..0ee4a3c842c5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -471,6 +471,12 @@ struct kvm_hv_sint {
 	u32 sint;
 };
 
+struct kvm_xen_evtchn {
+	u32 port;
+	u32 vcpu;
+	u32 priority;
+};
+
 struct kvm_kernel_irq_routing_entry {
 	u32 gsi;
 	u32 type;
@@ -491,6 +497,7 @@ struct kvm_kernel_irq_routing_entry {
 		} msi;
 		struct kvm_s390_adapter_int adapter;
 		struct kvm_hv_sint hv_sint;
+		struct kvm_xen_evtchn xen_evtchn;
 	};
 	struct hlist_node link;
 };
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a067410ebea5..52ee8edfdbc3 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1143,11 +1143,20 @@ struct kvm_irq_routing_hv_sint {
 	__u32 sint;
 };
 
+struct kvm_irq_routing_xen_evtchn {
+	__u32 port;
+	__u32 vcpu;
+	__u32 priority;
+};
+
+#define KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL ((__u32)(-1))
+
 /* gsi routing entry types */
 #define KVM_IRQ_ROUTING_IRQCHIP 1
 #define KVM_IRQ_ROUTING_MSI 2
 #define KVM_IRQ_ROUTING_S390_ADAPTER 3
 #define KVM_IRQ_ROUTING_HV_SINT 4
+#define KVM_IRQ_ROUTING_XEN_EVTCHN 5
 
 struct kvm_irq_routing_entry {
 	__u32 gsi;
@@ -1159,6 +1168,7 @@ struct kvm_irq_routing_entry {
 		struct kvm_irq_routing_msi msi;
 		struct kvm_irq_routing_s390_adapter adapter;
 		struct kvm_irq_routing_hv_sint hv_sint;
+		struct kvm_irq_routing_xen_evtchn xen_evtchn;
 		__u32 pad[8];
 	} u;
 };
@@ -1189,6 +1199,7 @@ struct kvm_x86_mce {
 #define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
 #define KVM_XEN_HVM_CONFIG_SHARED_INFO		(1 << 2)
 #define KVM_XEN_HVM_CONFIG_RUNSTATE		(1 << 3)
+#define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL	(1 << 4)
 
 struct kvm_xen_hvm_config {
 	__u32 flags;
diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index a0699f00b3d6..c0a3b9cc2a86 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -14,6 +14,9 @@
 #include <stdint.h>
 #include <time.h>
 #include <sched.h>
+#include <signal.h>
+
+#include <sys/eventfd.h>
 
 #define VCPU_ID		5
 
@@ -22,10 +25,12 @@
 #define SHINFO_REGION_SLOT	10
 #define PAGE_SIZE		4096
 
+#define SHINFO_ADDR	(SHINFO_REGION_GPA)
 #define PVTIME_ADDR	(SHINFO_REGION_GPA + PAGE_SIZE)
 #define RUNSTATE_ADDR	(SHINFO_REGION_GPA + PAGE_SIZE + 0x20)
 #define VCPU_INFO_ADDR	(SHINFO_REGION_GPA + 0x40)
 
+#define SHINFO_VADDR	(SHINFO_REGION_GVA)
 #define RUNSTATE_VADDR	(SHINFO_REGION_GVA + PAGE_SIZE + 0x20)
 #define VCPU_INFO_VADDR	(SHINFO_REGION_GVA + 0x40)
 
@@ -73,15 +78,30 @@ struct vcpu_info {
         struct pvclock_vcpu_time_info time;
 }; /* 64 bytes (x86) */
 
+struct shared_info {
+	struct vcpu_info vcpu_info[32];
+	unsigned long evtchn_pending[64];
+	unsigned long evtchn_mask[64];
+	struct pvclock_wall_clock wc;
+	uint32_t wc_sec_hi;
+	/* arch_shared_info here */
+};
+
 #define RUNSTATE_running  0
 #define RUNSTATE_runnable 1
 #define RUNSTATE_blocked  2
 #define RUNSTATE_offline  3
 
+struct {
+	struct kvm_irq_routing info;
+	struct kvm_irq_routing_entry entries[2];
+} irq_routes;
+
 static void evtchn_handler(struct ex_regs *regs)
 {
 	struct vcpu_info *vi = (void *)VCPU_INFO_VADDR;
 	vi->evtchn_upcall_pending = 0;
+	vi->evtchn_pending_sel = 0;
 
 	GUEST_SYNC(0x20);
 }
@@ -127,7 +147,19 @@ static void guest_code(void)
 	GUEST_SYNC(6);
 	GUEST_ASSERT(rs->time[RUNSTATE_runnable] >= MIN_STEAL_TIME);
 
-	GUEST_DONE();
+	/* Attempt to deliver a *masked* interrupt */
+	GUEST_SYNC(7);
+
+	/* Wait until we see the bit set */
+	struct shared_info *si = (void *)SHINFO_VADDR;
+	while (!si->evtchn_pending[0])
+		__asm__ __volatile__ ("rep nop" : : : "memory");
+
+	/* Now deliver an *unmasked* interrupt */
+	GUEST_SYNC(8);
+
+	for (;;)
+		__asm__ __volatile__ ("rep nop" : : : "memory");
 }
 
 static int cmp_timespec(struct timespec *a, struct timespec *b)
@@ -144,6 +176,11 @@ static int cmp_timespec(struct timespec *a, struct timespec *b)
 		return 0;
 }
 
+static void handle_alrm(int sig)
+{
+	TEST_FAIL("IRQ delivery timed out");
+}
+
 int main(int argc, char *argv[])
 {
 	struct timespec min_ts, max_ts, vm_ts;
@@ -155,6 +192,7 @@ int main(int argc, char *argv[])
 	}
 
 	bool do_runstate_tests = !!(xen_caps & KVM_XEN_HVM_CONFIG_RUNSTATE);
+	bool do_eventfd_tests = !!(xen_caps & KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL);
 
 	clock_gettime(CLOCK_REALTIME, &min_ts);
 
@@ -214,6 +252,51 @@ int main(int argc, char *argv[])
 		vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &st);
 	}
 
+	int irq_fd[2] = { -1, -1 };
+
+	if (do_eventfd_tests) {
+		irq_fd[0] = eventfd(0, 0);
+		irq_fd[1] = eventfd(0, 0);
+
+		/* Unexpected, but not a KVM failure */
+		if (irq_fd[0] == -1 || irq_fd[1] == -1)
+			do_eventfd_tests = false;
+	}
+
+	if (do_eventfd_tests) {
+		irq_routes.info.nr = 2;
+
+		irq_routes.entries[0].gsi = 32;
+		irq_routes.entries[0].type = KVM_IRQ_ROUTING_XEN_EVTCHN;
+		irq_routes.entries[0].u.xen_evtchn.port = 15;
+		irq_routes.entries[0].u.xen_evtchn.vcpu = VCPU_ID;
+		irq_routes.entries[0].u.xen_evtchn.priority = KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL;
+
+		irq_routes.entries[1].gsi = 33;
+		irq_routes.entries[1].type = KVM_IRQ_ROUTING_XEN_EVTCHN;
+		irq_routes.entries[1].u.xen_evtchn.port = 66;
+		irq_routes.entries[1].u.xen_evtchn.vcpu = VCPU_ID;
+		irq_routes.entries[1].u.xen_evtchn.priority = KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL;
+
+		vm_ioctl(vm, KVM_SET_GSI_ROUTING, &irq_routes);
+
+		struct kvm_irqfd ifd = { };
+
+		ifd.fd = irq_fd[0];
+		ifd.gsi = 32;
+		vm_ioctl(vm, KVM_IRQFD, &ifd);
+
+		ifd.fd = irq_fd[1];
+		ifd.gsi = 33;
+		vm_ioctl(vm, KVM_IRQFD, &ifd);
+
+		struct sigaction sa = { };
+		sa.sa_handler = handle_alrm;
+		sigaction(SIGALRM, &sa, NULL);
+	}
+
+	struct shared_info *shinfo = addr_gpa2hva(vm, SHINFO_VADDR);
+
 	struct vcpu_info *vinfo = addr_gpa2hva(vm, VCPU_INFO_VADDR);
 	vinfo->evtchn_upcall_pending = 0;
 
@@ -289,9 +372,23 @@ int main(int argc, char *argv[])
 					sched_yield();
 				} while (get_run_delay() < rundelay);
 				break;
+			case 7:
+				if (!do_eventfd_tests)
+					goto done;
+				shinfo->evtchn_mask[0] = 0x8000;
+				eventfd_write(irq_fd[0], 1UL);
+				alarm(1);
+				break;
+			case 8:
+				eventfd_write(irq_fd[1], 1UL);
+				evtchn_irq_expected = true;
+				break;
+
 			case 0x20:
 				TEST_ASSERT(evtchn_irq_expected, "Unexpected event channel IRQ");
 				evtchn_irq_expected = false;
+				if (shinfo->evtchn_pending[1])
+					goto done;
 				break;
 			}
 			break;
-- 
2.31.1

