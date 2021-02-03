Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5078230DD87
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 16:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233638AbhBCPDk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 10:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233585AbhBCPDS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 10:03:18 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B606C061356
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 07:01:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=98kcbiTB3wp4KosWiD7isBwPWAUZ+yjUIH12/7dDKSQ=; b=QIvAytIKm14g5e2DrPdnEqqVpY
        NEpsHm2xr8f8QGFBmSm/upwVgUpfvNPWZby2KTBJe6s0anMVdCGx/5X/n/69ISypEKNK3GqBzAhAE
        44d66yIibvBJV+de5CeVzHU3d9hT7E1lKJYEWkt9oby/O1y7Yp9bSITMolFNrHpq4sdnTGm0q4A4a
        WD4nx0bC4ypoIfPC0r2kzVyWUMoPdr+wxjMPd67sbZhozDpFjCPncstupYpr4mJrAJ4APRd+f66n9
        8f0sMp26/QBzLZ7zfD9yPEfooc1UI9PeRzZKRGuWgVJYiE6E4YLsRz7TEUJvyWp85xM9M7cK9cQ7t
        r8SPXaPQ==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l7Jef-00H3zN-Tf; Wed, 03 Feb 2021 15:01:20 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l7Jef-003rex-G9; Wed, 03 Feb 2021 15:01:17 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
Subject: [PATCH v6 17/19] KVM: x86/xen: Add event channel interrupt vector upcall
Date:   Wed,  3 Feb 2021 15:01:12 +0000
Message-Id: <20210203150114.920335-18-dwmw2@infradead.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210203150114.920335-1-dwmw2@infradead.org>
References: <20210203150114.920335-1-dwmw2@infradead.org>
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

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/irq.c              |  7 +++++
 arch/x86/kvm/x86.c              |  3 +-
 arch/x86/kvm/xen.c              | 53 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/xen.h              |  9 ++++++
 include/uapi/linux/kvm.h        |  2 ++
 6 files changed, 74 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cd65bd43fc5f..9693ec3c2042 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -902,6 +902,7 @@ struct msr_bitmap_range {
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
index 8d849e8e9953..cdcc8abf2216 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8950,7 +8950,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_x86_ops.msr_filter_changed(vcpu);
 	}
 
-	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win) {
+	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
+	    kvm_xen_has_interrupt(vcpu)) {
 		++vcpu->stat.req_event;
 		kvm_apic_accept_events(vcpu);
 		if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED) {
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index bd343222e740..39a7ffcdcf22 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -61,6 +61,44 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
 	return ret;
 }
 
+int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
+{
+	u8 rc = 0;
+
+	/*
+	 * If the global upcall vector (HVMIRQ_callback_vector) is set and
+	 * the vCPU's evtchn_upcall_pending flag is set, the IRQ is pending.
+	 */
+	struct gfn_to_hva_cache *ghc = &v->arch.xen.vcpu_info_cache;
+	struct kvm_memslots *slots = kvm_memslots(v->kvm);
+	unsigned int offset = offsetof(struct vcpu_info, evtchn_upcall_pending);
+
+	/* No need for compat handling here */
+	BUILD_BUG_ON(offsetof(struct vcpu_info, evtchn_upcall_pending) !=
+		     offsetof(struct compat_vcpu_info, evtchn_upcall_pending));
+	BUILD_BUG_ON(sizeof(rc) !=
+		     sizeof(((struct vcpu_info *)0)->evtchn_upcall_pending));
+	BUILD_BUG_ON(sizeof(rc) !=
+		     sizeof(((struct compat_vcpu_info *)0)->evtchn_upcall_pending));
+
+	/*
+	 * For efficiency, this mirrors the checks for using the valid
+	 * cache in kvm_read_guest_offset_cached(), but just uses
+	 * __get_user() instead. And falls back to the slow path.
+	 */
+	if (likely(slots->generation == ghc->generation &&
+		   !kvm_is_error_hva(ghc->hva) && ghc->memslot)) {
+		/* Fast path */
+		__get_user(rc, (u8 __user *)ghc->hva + offset);
+	} else {
+		/* Slow path */
+		kvm_read_guest_offset_cached(v->kvm, ghc, &rc, offset,
+					     sizeof(rc));
+	}
+
+	return rc;
+}
+
 int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 {
 	int r = -ENOENT;
@@ -83,6 +121,16 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		r = kvm_xen_shared_info_init(kvm, data->u.shared_info.gfn);
 		break;
 
+
+	case KVM_XEN_ATTR_TYPE_UPCALL_VECTOR:
+		if (data->u.vector < 0x10)
+			r = -EINVAL;
+		else {
+			kvm->arch.xen.upcall_vector = data->u.vector;
+			r = 0;
+		}
+		break;
+
 	default:
 		break;
 	}
@@ -110,6 +158,11 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
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
index fb85377fdbdc..4b32489c0cec 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -13,6 +13,7 @@
 
 extern struct static_key_false_deferred kvm_xen_enabled;
 
+int __kvm_xen_has_interrupt(struct kvm_vcpu *vcpu);
 int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data);
 int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data);
 int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
@@ -29,6 +30,14 @@ static inline bool kvm_xen_hypercall_enabled(struct kvm *kvm)
 		 KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL);
 }
 
+static inline int kvm_xen_has_interrupt(struct kvm_vcpu *vcpu)
+{
+	if (static_branch_unlikely(&kvm_xen_enabled.key) &&
+	    vcpu->arch.xen.vcpu_info_set && vcpu->kvm->arch.xen.upcall_vector)
+		return __kvm_xen_has_interrupt(vcpu);
+
+	return 0;
+}
 
 /* 32-bit compatibility definitions, also used natively in 32-bit build */
 #include <asm/pvclock-abi.h>
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index e00b15ba7b7e..c828c94dbe8b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1594,6 +1594,7 @@ struct kvm_xen_hvm_attr {
 	__u16 pad[3];
 	union {
 		__u8 long_mode;
+		__u8 vector;
 		struct {
 			__u64 gfn;
 		} shared_info;
@@ -1603,6 +1604,7 @@ struct kvm_xen_hvm_attr {
 
 #define KVM_XEN_ATTR_TYPE_LONG_MODE		0x0
 #define KVM_XEN_ATTR_TYPE_SHARED_INFO		0x1
+#define KVM_XEN_ATTR_TYPE_UPCALL_VECTOR		0x2
 
 /* Per-vCPU Xen attributes */
 #define KVM_XEN_VCPU_GET_ATTR	_IOWR(KVMIO, 0xca, struct kvm_xen_vcpu_attr)
-- 
2.29.2

