Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC9C4C2C12
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 13:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234494AbiBXMtY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 07:49:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234503AbiBXMtO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 07:49:14 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03111D8AA7
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 04:48:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=T8JqoFzERiiU7rJ0zqZH/xSk69jUKSfVven3jJkGKQ4=; b=evNlasHy+3FzxA1QkSlWnMR/gG
        p+r50Owxkg2pOPqG4l4uOtrWWViAADvtIVmzegXUWFm7E5sBdO2GEWBbgxD2z9bMFUqMyN8hSO2Vt
        zuYiswAkSZEuMsEqZ86HDUaCGeFhSmKLb6fwX8ymwRBv+WoKZ50EcysNNsvN/jXLW37U3zxnZnCSV
        RPgSRWJ1e6fotv3wIqGfwyuOo3KfYz0rnb46jeEmtyIJax0JS6cWy3wJugxl6zqeGyEj89r9nxUmo
        s57hntfamUZ7nCfQbCDhLAPR3nXPXRs8ntCE001QVGVSCG3xwbGw/qO3vjOHnitTBVGQeEe+PTQbG
        M8zFnEnQ==;
Received: from [2001:8b0:10b:1:85c4:81a:fb42:714d] (helo=i7.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nNDXl-004lng-Un; Thu, 24 Feb 2022 12:48:26 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nNDXj-0000ui-LP; Thu, 24 Feb 2022 12:48:23 +0000
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
Subject: [PATCH v1 11/16] KVM: x86/xen: handle PV timers oneshot mode
Date:   Thu, 24 Feb 2022 12:48:14 +0000
Message-Id: <20220224124819.3315-12-dwmw2@infradead.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220224124819.3315-1-dwmw2@infradead.org>
References: <20220224124819.3315-1-dwmw2@infradead.org>
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

From: Joao Martins <joao.m.martins@oracle.com>

If the guest has offloaded the timer virq, handle the following
hypercalls for programming the timer:

    VCPUOP_set_singleshot_timer
    VCPUOP_stop_singleshot_timer
    set_timer_op(timestamp_ns)

The event channel corresponding to the timer virq is then used to inject
events once timer deadlines are met. For now we back the PV timer with
hrtimer.

[ dwmw2: Add save/restore, 32-bit compat mode. ]
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |   4 +
 arch/x86/kvm/irq.c              |  11 +-
 arch/x86/kvm/x86.c              |   3 +
 arch/x86/kvm/xen.c              | 229 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/xen.h              |  30 +++++
 include/uapi/linux/kvm.h        |   6 +
 6 files changed, 281 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index dc0d76d21f7f..b0caf02d12fe 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -608,6 +608,10 @@ struct kvm_vcpu_xen {
 	u64 runstate_times[4];
 	unsigned long evtchn_pending_sel;
 	u32 vcpu_id; /* The Xen / ACPI vCPU ID */
+	u32 timer_virq;
+	u64 timer_expires; /* In guest epoch */
+	atomic_t timer_pending;
+	struct hrtimer timer;
 };
 
 struct kvm_vcpu_arch {
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 172b05343cfd..af2d26fc5458 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -22,10 +22,14 @@
  */
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
+	int r = 0;
+
 	if (lapic_in_kernel(vcpu))
-		return apic_has_pending_timer(vcpu);
+		r = apic_has_pending_timer(vcpu);
+	if (kvm_xen_timer_enabled(vcpu))
+		r += kvm_xen_has_pending_timer(vcpu);
 
-	return 0;
+	return r;
 }
 EXPORT_SYMBOL(kvm_cpu_has_pending_timer);
 
@@ -143,6 +147,8 @@ void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu)
 {
 	if (lapic_in_kernel(vcpu))
 		kvm_inject_apic_timer_irqs(vcpu);
+	if (kvm_xen_timer_enabled(vcpu))
+		kvm_xen_inject_timer_irqs(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_inject_pending_timer_irqs);
 
@@ -150,6 +156,7 @@ void __kvm_migrate_timers(struct kvm_vcpu *vcpu)
 {
 	__kvm_migrate_apic_timer(vcpu);
 	__kvm_migrate_pit_timer(vcpu);
+	__kvm_migrate_xen_timer(vcpu);
 	static_call_cond(kvm_x86_migrate_timers)(vcpu);
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 70e58fce1e29..a683a126a437 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12085,6 +12085,9 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 	    kvm_x86_ops.nested_ops->hv_timer_pending(vcpu))
 		return true;
 
+	if (kvm_xen_has_pending_timer(vcpu))
+		return true;
+
 	return false;
 }
 
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 3663bb2caa2b..cc172ca83bbb 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -23,6 +23,7 @@
 
 #include "trace.h"
 
+static int kvm_xen_set_evtchn(struct kvm_xen_evtchn *xe, struct kvm *kvm);
 static int kvm_xen_setattr_evtchn(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
 static bool kvm_xen_hcall_evtchn_send(struct kvm_vcpu *vcpu, u64 param, u64 *r);
 
@@ -108,6 +109,84 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
 	return ret;
 }
 
+void kvm_xen_inject_timer_irqs(struct kvm_vcpu *vcpu)
+{
+	if (atomic_read(&vcpu->arch.xen.timer_pending) > 0) {
+		struct kvm_xen_evtchn e;
+
+		e.vcpu_id = vcpu->vcpu_id;
+		e.vcpu_idx = vcpu->vcpu_idx;
+		e.port = vcpu->arch.xen.timer_virq;
+		e.priority = KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL;
+
+		kvm_xen_set_evtchn(&e, vcpu->kvm);
+		atomic_set(&vcpu->arch.xen.timer_pending, 0);
+	}
+}
+
+static enum hrtimer_restart xen_timer_callback(struct hrtimer *timer)
+{
+	struct kvm_vcpu *vcpu = container_of(timer, struct kvm_vcpu,
+					     arch.xen.timer);
+	struct kvm_xen_evtchn e;
+
+	if (atomic_read(&vcpu->arch.xen.timer_pending))
+		return HRTIMER_NORESTART;
+
+	e.vcpu_id = vcpu->vcpu_id;
+	e.vcpu_idx = vcpu->vcpu_idx;
+	e.port = vcpu->arch.xen.timer_virq;
+	e.priority = KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL;
+
+	if (kvm_xen_set_evtchn_fast(&e, vcpu->kvm) != -EWOULDBLOCK)
+		return HRTIMER_NORESTART;
+
+	atomic_inc(&vcpu->arch.xen.timer_pending);
+	kvm_make_request(KVM_REQ_UNBLOCK, vcpu);
+	kvm_vcpu_kick(vcpu);
+
+	return HRTIMER_NORESTART;
+}
+
+void __kvm_migrate_xen_timer(struct kvm_vcpu *vcpu)
+{
+	struct hrtimer *timer;
+
+	if (!kvm_xen_timer_enabled(vcpu))
+		return;
+
+	timer = &vcpu->arch.xen.timer;
+	if (hrtimer_cancel(timer))
+		hrtimer_start_expires(timer, HRTIMER_MODE_ABS_PINNED);
+}
+
+static void kvm_xen_start_timer(struct kvm_vcpu *vcpu, u64 guest_abs, u64 delta_ns)
+{
+	ktime_t ktime_now;
+
+	atomic_set(&vcpu->arch.xen.timer_pending, 0);
+	vcpu->arch.xen.timer_expires = guest_abs;
+
+	ktime_now = ktime_get();
+	hrtimer_start(&vcpu->arch.xen.timer,
+		      ktime_add_ns(ktime_now, delta_ns),
+		      HRTIMER_MODE_ABS_PINNED);
+}
+
+static void kvm_xen_stop_timer(struct kvm_vcpu *vcpu)
+{
+	hrtimer_cancel(&vcpu->arch.xen.timer);
+	vcpu->arch.xen.timer_expires = 0;
+	atomic_set(&vcpu->arch.xen.timer_pending, 0);
+}
+
+void kvm_xen_init_timer(struct kvm_vcpu *vcpu)
+{
+	hrtimer_init(&vcpu->arch.xen.timer, CLOCK_MONOTONIC,
+		     HRTIMER_MODE_ABS_PINNED);
+	vcpu->arch.xen.timer.function = xen_timer_callback;
+}
+
 static void kvm_xen_update_runstate(struct kvm_vcpu *v, int state)
 {
 	struct kvm_vcpu_xen *vx = &v->arch.xen;
@@ -617,6 +696,28 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 		}
 		break;
 
+	case KVM_XEN_VCPU_ATTR_TYPE_TIMER:
+		if (data->u.timer.port) {
+			if (data->u.timer.priority != KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL) {
+				r = -EINVAL;
+				break;
+			}
+			vcpu->arch.xen.timer_virq = data->u.timer.port;
+			kvm_xen_init_timer(vcpu);
+
+			/* Restart the timer if it's set */
+			if (data->u.timer.expires_ns)
+				kvm_xen_start_timer(vcpu, data->u.timer.expires_ns,
+						    data->u.timer.expires_ns -
+						    get_kvmclock_ns(vcpu->kvm));
+		} else if (kvm_xen_timer_enabled(vcpu)) {
+			kvm_xen_stop_timer(vcpu);
+			vcpu->arch.xen.timer_virq = 0;
+		}
+
+		r = 0;
+		break;
+
 	default:
 		break;
 	}
@@ -697,6 +798,13 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 		r = 0;
 		break;
 
+	case KVM_XEN_VCPU_ATTR_TYPE_TIMER:
+		data->u.timer.port = vcpu->arch.xen.timer_virq;
+		data->u.timer.priority = KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL;
+		data->u.timer.expires_ns = vcpu->arch.xen.timer_expires;
+		r = 0;
+		break;
+
 	default:
 		break;
 	}
@@ -832,6 +940,112 @@ static bool kvm_xen_hcall_sched_op(struct kvm_vcpu *vcpu, int cmd, u64 param, u6
 	return false;
 }
 
+struct compat_vcpu_set_singleshot_timer {
+    uint64_t timeout_abs_ns;
+    uint32_t flags;
+} __attribute__((packed));
+
+static bool kvm_xen_hcall_vcpu_op(struct kvm_vcpu *vcpu, bool longmode, int cmd,
+				  int vcpu_id, u64 param, u64 *r)
+{
+	struct vcpu_set_singleshot_timer oneshot;
+	long delta;
+	gpa_t gpa;
+	int idx;
+
+	if (!kvm_xen_timer_enabled(vcpu))
+		return false;
+
+	switch (cmd) {
+	case VCPUOP_set_singleshot_timer:
+		if (vcpu->arch.xen.vcpu_id != vcpu_id) {
+			*r = -EINVAL;
+			return true;
+		}
+		idx = srcu_read_lock(&vcpu->kvm->srcu);
+		gpa = kvm_mmu_gva_to_gpa_system(vcpu, param, NULL);
+		srcu_read_unlock(&vcpu->kvm->srcu, idx);
+
+		/*
+		 * The only difference for 32-bit compat is the 4 bytes of
+		 * padding after the interesting part of the structure. So
+		 * for a faithful emulation of Xen we have to *try* to copy
+		 * the padding and return -EFAULT if we can't. Otherwise we
+		 * might as well just have copied the 12-byte 32-bit struct.
+		 */
+		BUILD_BUG_ON(offsetof(struct compat_vcpu_set_singleshot_timer, timeout_abs_ns) !=
+			     offsetof(struct vcpu_set_singleshot_timer, timeout_abs_ns));
+		BUILD_BUG_ON(sizeof_field(struct compat_vcpu_set_singleshot_timer, timeout_abs_ns) !=
+			     sizeof_field(struct vcpu_set_singleshot_timer, timeout_abs_ns));
+		BUILD_BUG_ON(offsetof(struct compat_vcpu_set_singleshot_timer, flags) !=
+			     offsetof(struct vcpu_set_singleshot_timer, flags));
+		BUILD_BUG_ON(sizeof_field(struct compat_vcpu_set_singleshot_timer, flags) !=
+			     sizeof_field(struct vcpu_set_singleshot_timer, flags));
+
+		if (!gpa ||
+		    kvm_vcpu_read_guest(vcpu, gpa, &oneshot, longmode ? sizeof(oneshot) :
+					sizeof(struct compat_vcpu_set_singleshot_timer))) {
+			*r = -EFAULT;
+			return true;
+		}
+
+		delta = oneshot.timeout_abs_ns - get_kvmclock_ns(vcpu->kvm);
+		if ((oneshot.flags & VCPU_SSHOTTMR_future) && delta < 0) {
+			*r = -ETIME;
+			return true;
+		}
+
+		kvm_xen_start_timer(vcpu, oneshot.timeout_abs_ns, delta);
+		*r = 0;
+		return true;
+
+	case VCPUOP_stop_singleshot_timer:
+		if (vcpu->arch.xen.vcpu_id != vcpu_id) {
+			*r = -EINVAL;
+			return true;
+		}
+		kvm_xen_stop_timer(vcpu);
+		*r = 0;
+		return true;
+	}
+
+	return false;
+}
+
+static bool kvm_xen_hcall_set_timer_op(struct kvm_vcpu *vcpu, uint64_t timeout,
+				       u64 *r)
+{
+	if (!kvm_xen_timer_enabled(vcpu))
+		return false;
+
+	if (timeout) {
+		uint64_t guest_now = get_kvmclock_ns(vcpu->kvm);
+		long delta = timeout - guest_now;
+
+		/* Xen has a 'Linux workaround' in do_set_timer_op() which
+		 * checks for negative absolute timeout values (caused by
+		 * integer overflow), and for values about 13 days in the
+		 * future (2^50ns) which would be caused by jiffies
+		 * overflow. For those cases, it sets the timeout 100ms in
+		 * the future (not *too* soon, since if a guest really did
+		 * set a long timeout on purpose we don't want to keep
+		 * churning CPU time by waking it up).
+		 */
+		if (unlikely((int64_t)timeout < 0 ||
+			     (delta > 0 && (uint32_t) (delta >> 50) != 0))) {
+			delta = 100 * NSEC_PER_MSEC;
+			timeout = guest_now + delta;
+		}
+
+		kvm_xen_start_timer(vcpu, timeout, delta);
+	} else {
+		kvm_xen_stop_timer(vcpu);
+	}
+
+	*r = 0;
+	return true;
+}
+
 int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
 {
 	bool longmode;
@@ -875,6 +1089,18 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
 	case __HYPERVISOR_sched_op:
 		handled = kvm_xen_hcall_sched_op(vcpu, params[0], params[1], &r);
 		break;
+	case __HYPERVISOR_vcpu_op:
+		handled = kvm_xen_hcall_vcpu_op(vcpu, longmode, params[0], params[1],
+						params[2], &r);
+		break;
+	case __HYPERVISOR_set_timer_op: {
+		u64 timeout = params[0];
+		/* In 32-bit mode, the 64-bit timeout is in two 32-bit params. */
+		if (!longmode)
+			timeout |= params[1] << 32;
+		handled = kvm_xen_hcall_set_timer_op(vcpu, timeout, &r);
+		break;
+	}
 	default:
 		break;
 	}
@@ -1383,6 +1609,9 @@ void kvm_xen_init_vcpu(struct kvm_vcpu *vcpu)
 
 void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
 {
+	if (kvm_xen_timer_enabled(vcpu))
+		kvm_xen_stop_timer(vcpu);
+
 	kvm_gfn_to_pfn_cache_destroy(vcpu->kvm,
 				     &vcpu->arch.xen.runstate_cache);
 	vcpu->arch.xen.vcpu_info_cache.dirty = false;
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index 54d587aae85b..616fe751c8fc 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -62,6 +62,21 @@ static inline bool kvm_xen_has_pending_events(struct kvm_vcpu *vcpu)
 		vcpu->arch.xen.evtchn_pending_sel;
 }
 
+static inline bool kvm_xen_timer_enabled(struct kvm_vcpu *vcpu)
+{
+	return !!vcpu->arch.xen.timer_virq;
+}
+
+static inline int kvm_xen_has_pending_timer(struct kvm_vcpu *vcpu)
+{
+	if (kvm_xen_hypercall_enabled(vcpu->kvm) && kvm_xen_timer_enabled(vcpu))
+		return atomic_read(&vcpu->arch.xen.timer_pending);
+
+	return 0;
+}
+
+void __kvm_migrate_xen_timer(struct kvm_vcpu *vcpu);
+void kvm_xen_inject_timer_irqs(struct kvm_vcpu *vcpu);
 #else
 static inline int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
 {
@@ -104,6 +119,21 @@ static inline void kvm_xen_inject_pending_events(struct kvm_vcpu *vcpu)
 }
 
 static inline bool kvm_xen_has_pending_events(struct kvm_vcpu *vcpu)
+
+static inline void __kvm_migrate_xen_timer(struct kvm_vcpu *vcpu)
+{
+}
+
+static inline int kvm_xen_has_pending_timer(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+
+static inline void kvm_xen_inject_timer_irqs(struct kvm_vcpu *vcpu)
+{
+}
+
+static inline bool kvm_xen_timer_enabled(struct kvm_vcpu *vcpu)
 {
 	return false;
 }
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2b01e026f06c..47d6b0f6d5ab 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1737,6 +1737,11 @@ struct kvm_xen_vcpu_attr {
 			__u64 time_offline;
 		} runstate;
 		__u32 vcpu_id;
+		struct {
+			__u32 port;
+			__u32 priority;
+			__u64 expires_ns;
+		} timer;
 	} u;
 };
 
@@ -1749,6 +1754,7 @@ struct kvm_xen_vcpu_attr {
 #define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST	0x5
 /* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_EVTCHN_SEND */
 #define KVM_XEN_VCPU_ATTR_TYPE_VCPU_ID		0x6
+#define KVM_XEN_VCPU_ATTR_TYPE_TIMER		0x7
 
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
-- 
2.33.1

