Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F33012D943A
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 09:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439343AbgLNIkT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 03:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439324AbgLNIjx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 03:39:53 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B978EC0613D6
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 00:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=DVuchc0wovglNBlK0pAkz7Qkk8ALoX0wH/2YatUIn2o=; b=AR9uTfog5G9oSk8brRr0yOp76f
        hhSda/S42xyAImPYw51WgEOCnX1RMn0Rmn/nWmQkaXga0EPXkq4xI+GyBaNoHXNB3XADqT4/Sn9tZ
        c5d3lGbZ/OnpDJgf30wx8jCFEEyeykP7banB0/Q0IErCMgkMZflx3OhEmALFYGPnPkLl2tLQoFEPI
        eePXoaths1nKKe5btMSukoQuXvszNQtpIW5X51KopNiAQ+a0mGBvpq13XZLAjnNtC6eUamOCNfhCB
        8K7fAd3KVoAq6VWxCwjnHgBaP3w8itbpZkQPk7AyrjobxWdViZgYtZMTFRLtdc9w4/5ApAshFToaJ
        aUMkjvsA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kojNs-00028g-Aw; Mon, 14 Dec 2020 08:39:08 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kojNr-008SyI-Sy; Mon, 14 Dec 2020 08:39:07 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com
Subject: [PATCH v3 17/17] KVM: x86/xen: Add event channel interrupt vector upcall
Date:   Mon, 14 Dec 2020 08:39:05 +0000
Message-Id: <20201214083905.2017260-18-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201214083905.2017260-1-dwmw2@infradead.org>
References: <20201214083905.2017260-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

It turns out that we can't handle event channels *entirely* in userspace
by delivering them as ExtINT, because KVM is a bit picky about when it
accepts ExtINT interrupts from a legacy PIC. The in-kernel local APIC
has to have LVT0 configured in APIC_MODE_EXTINT and unmasked, which
isn't necessarily the case for Xen guests especially on secondary CPUs.

To cope with this, add kvm_xen_get_interrupt() which checks the
evtchn_pending_upcall field in the Xen vcpu_info, and delivers the Xen
upcall vector (configured by KVM_XEN_ATTR_TYPE_UPCALL_VECTOR) if it's
set regardless of LAPIC LVT0 configuration. This gives us the minimum
support we need for completely userspace-based implementation of event
channels.

This does mean that vcpu_enter_guest() needs to check for the
evtchn_pending_upcall flag being set, because it can't rely on someone
having set KVM_REQ_EVENT unless we were to add some way for userspace to
do so manually.

But actually, I don't quite see how that works reliably for interrupts
injected with KVM_INTERRUPT either. In kvm_vcpu_ioctl_interrupt() the
KVM_REQ_EVENT request is set once, but that'll get cleared the first time
through vcpu_enter_guest(). So if the first exit is for something *else*
without interrupts being enabled yet, won't the KVM_REQ_EVENT request
have been consumed already and just be lost?

I wonder if my addition of '|| kvm_xen_has_interrupt(vcpu)' should
actually be '|| kvm_has_injectable_intr(vcpu)' to fix that pre-existing
bug?

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/irq.c              |  7 +++++
 arch/x86/kvm/x86.c              |  3 +-
 arch/x86/kvm/xen.c              | 52 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/xen.h              |  1 +
 include/uapi/linux/kvm.h        |  2 ++
 6 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4b345a8945ea..68a66b98fd5f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -903,6 +903,7 @@ struct msr_bitmap_range {
 struct kvm_xen {
 	bool long_mode;
 	bool shinfo_set;
+	u8 upcall_vector;
 	struct gfn_to_hva_cache shinfo_cache;
 };
 
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 814698e5b152..24668b51b5c8 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -14,6 +14,7 @@
 #include "irq.h"
 #include "i8254.h"
 #include "x86.h"
+#include "xen.h"
 
 /*
  * check if there are pending timer events
@@ -56,6 +57,9 @@ int kvm_cpu_has_extint(struct kvm_vcpu *v)
 	if (!lapic_in_kernel(v))
 		return v->arch.interrupt.injected;
 
+	if (kvm_xen_has_interrupt(v))
+		return 1;
+
 	if (!kvm_apic_accept_pic_intr(v))
 		return 0;
 
@@ -110,6 +114,9 @@ static int kvm_cpu_get_extint(struct kvm_vcpu *v)
 	if (!lapic_in_kernel(v))
 		return v->arch.interrupt.nr;
 
+	if (kvm_xen_has_interrupt(v))
+		return v->kvm->arch.xen.upcall_vector;
+
 	if (irqchip_split(v->kvm)) {
 		int vector = v->arch.pending_external_vector;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index df44d9e50adc..e627139cf8cd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8896,7 +8896,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_x86_ops.msr_filter_changed(vcpu);
 	}
 
-	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win) {
+	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
+	    kvm_xen_has_interrupt(vcpu)) {
 		++vcpu->stat.req_event;
 		kvm_apic_accept_events(vcpu);
 		if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED) {
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 17cbb4462b7e..4bc9da9fcfb8 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -176,6 +176,45 @@ void kvm_xen_setup_runstate_page(struct kvm_vcpu *v)
 	kvm_xen_update_runstate(v, RUNSTATE_running, steal_time);
 }
 
+int kvm_xen_has_interrupt(struct kvm_vcpu *v)
+{
+	u8 rc = 0;
+
+	/*
+	 * If the global upcall vector (HVMIRQ_callback_vector) is set and
+	 * the vCPU's evtchn_upcall_pending flag is set, the IRQ is pending.
+	 */
+	if (v->arch.xen.vcpu_info_set && v->kvm->arch.xen.upcall_vector) {
+		struct gfn_to_hva_cache *ghc = &v->arch.xen.vcpu_info_cache;
+		struct kvm_memslots *slots = kvm_memslots(v->kvm);
+		unsigned int offset = offsetof(struct vcpu_info, evtchn_upcall_pending);
+
+		/* No need for compat handling here */
+		BUILD_BUG_ON(offsetof(struct vcpu_info, evtchn_upcall_pending) !=
+			     offsetof(struct compat_vcpu_info, evtchn_upcall_pending));
+		BUILD_BUG_ON(sizeof(rc) !=
+			     sizeof(((struct vcpu_info *)0)->evtchn_upcall_pending));
+		BUILD_BUG_ON(sizeof(rc) !=
+			     sizeof(((struct compat_vcpu_info *)0)->evtchn_upcall_pending));
+
+		/*
+		 * For efficiency, this mirrors the checks for using the valid
+		 * cache in kvm_read_guest_offset_cached(), but just uses
+		 * __get_user() instead. And falls back to the slow path.
+		 */
+		if (likely(slots->generation == ghc->generation &&
+			   !kvm_is_error_hva(ghc->hva) && ghc->memslot)) {
+			/* Fast path */
+			__get_user(rc, (u8 __user *)ghc->hva + offset);
+		} else {
+			/* Slow path */
+			kvm_read_guest_offset_cached(v->kvm, ghc, &rc, offset,
+						      sizeof(rc));
+		}
+	}
+	return rc;
+}
+
 int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 {
 	struct kvm_vcpu *v;
@@ -245,6 +284,14 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		v->arch.xen.last_state_ns = ktime_get_ns();
 		break;
 
+	case KVM_XEN_ATTR_TYPE_UPCALL_VECTOR:
+		if (data->u.vector < 0x10)
+			return -EINVAL;
+
+		kvm->arch.xen.upcall_vector = data->u.vector;
+		r = 0;
+		break;
+
 	default:
 		break;
 	}
@@ -303,6 +350,11 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		}
 		break;
 
+	case KVM_XEN_ATTR_TYPE_UPCALL_VECTOR:
+		data->u.vector = kvm->arch.xen.upcall_vector;
+		r = 0;
+		break;
+
 	default:
 		break;
 	}
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index 407e717476d6..d64916ac4a12 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -11,6 +11,7 @@
 
 void kvm_xen_setup_runstate_page(struct kvm_vcpu *vcpu);
 void kvm_xen_runstate_set_preempted(struct kvm_vcpu *vcpu);
+int kvm_xen_has_interrupt(struct kvm_vcpu *vcpu);
 int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
 int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
 int kvm_xen_hypercall(struct kvm_vcpu *vcpu);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 749a7112df99..33609bc25021 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1587,6 +1587,7 @@ struct kvm_xen_hvm_attr {
 
 	union {
 		__u8 long_mode;
+		__u8 vector;
 		struct {
 			__u64 gfn;
 		} shared_info;
@@ -1604,6 +1605,7 @@ struct kvm_xen_hvm_attr {
 #define KVM_XEN_ATTR_TYPE_VCPU_INFO		0x2
 #define KVM_XEN_ATTR_TYPE_VCPU_TIME_INFO	0x3
 #define KVM_XEN_ATTR_TYPE_VCPU_RUNSTATE		0x4
+#define KVM_XEN_ATTR_TYPE_UPCALL_VECTOR		0x5
 
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
-- 
2.26.2

