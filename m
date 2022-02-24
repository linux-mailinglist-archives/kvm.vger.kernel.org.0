Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74B354C2C0F
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 13:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234503AbiBXMtZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 07:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234504AbiBXMtO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 07:49:14 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16CC1D8AA9
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 04:48:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=uPqbzz8wTMK2PBGYRYAgfdpNXIHCOp0daYoKwQGZqjk=; b=XR+oj/mK7wPPgZhJ6BEBSFy0t0
        VapT2OEatE+ukFvV9RkwZDw1cn1I2/ad7gsK7JzEFHXyRT0++YLL6DFXlxEYx5X21CTnrjDPJ2M8K
        QsbreZSL7UoveAQe+sdiyjTqjf5CpqTWDaq9uHwKekkpFRreYRqMhZiyggcJoqh/UeFpppej1aaj6
        86Cxaec+8vmZhIunK5DWwAdfzjSZxnVgR6Vng/9OgSoeLebfoY6hmjks8VQAjdhIxQ866BVpCi4d7
        DfeU6xOv017eko/aOyrWSeCMyF57joZQD+Ein+CXAuq6bvntZKJjLqXqs6fsiOw2o/1mx7gyMYFwf
        7QQwMC3A==;
Received: from [2001:8b0:10b:1:85c4:81a:fb42:714d] (helo=i7.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nNDXk-004lnW-91; Thu, 24 Feb 2022 12:48:24 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nNDXj-0000uM-JA; Thu, 24 Feb 2022 12:48:23 +0000
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
Subject: [PATCH v1 08/16] KVM: x86/xen: intercept EVTCHNOP_send from guests
Date:   Thu, 24 Feb 2022 12:48:11 +0000
Message-Id: <20220224124819.3315-9-dwmw2@infradead.org>
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

Userspace registers a sending @port to either deliver to an @eventfd
or directly back to a local event channel port.

After binding events the guest or host may wish to bind those
events to a particular vcpu. This is usually done for unbound
and and interdomain events. Update requests are handled via the
KVM_XEN_EVTCHN_UPDATE flag.

Unregistered ports are handled by the emulator.

Co-developed-by: Ankur Arora <ankur.a.arora@oracle.com>
Co-developed-By: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/kvm/xen.c              | 274 ++++++++++++++++++++++++++++++--
 include/uapi/linux/kvm.h        |  27 ++++
 3 files changed, 287 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0361e6f3dac0..2068ee84f196 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1019,6 +1019,7 @@ struct kvm_xen {
 	bool long_mode;
 	u8 upcall_vector;
 	struct gfn_to_pfn_cache shinfo_cache;
+	struct idr evtchn_ports;
 };
 
 enum kvm_irqchip_mode {
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 15ae237131d5..0cc9f6a4f10f 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -11,6 +11,7 @@
 #include "lapic.h"
 #include "hyperv.h"
 
+#include <linux/eventfd.h>
 #include <linux/kvm_host.h>
 #include <linux/sched/stat.h>
 
@@ -21,6 +22,9 @@
 
 #include "trace.h"
 
+static int kvm_xen_setattr_evtchn(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
+static bool kvm_xen_hcall_evtchn_send(struct kvm_vcpu *vcpu, u64 param, u64 *r);
+
 DEFINE_STATIC_KEY_DEFERRED_FALSE(kvm_xen_enabled, HZ);
 
 static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
@@ -368,36 +372,44 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 {
 	int r = -ENOENT;
 
-	mutex_lock(&kvm->lock);
 
 	switch (data->type) {
 	case KVM_XEN_ATTR_TYPE_LONG_MODE:
 		if (!IS_ENABLED(CONFIG_64BIT) && data->u.long_mode) {
 			r = -EINVAL;
 		} else {
+			mutex_lock(&kvm->lock);
 			kvm->arch.xen.long_mode = !!data->u.long_mode;
+			mutex_unlock(&kvm->lock);
 			r = 0;
 		}
 		break;
 
 	case KVM_XEN_ATTR_TYPE_SHARED_INFO:
+		mutex_lock(&kvm->lock);
 		r = kvm_xen_shared_info_init(kvm, data->u.shared_info.gfn);
+		mutex_unlock(&kvm->lock);
 		break;
 
 	case KVM_XEN_ATTR_TYPE_UPCALL_VECTOR:
 		if (data->u.vector && data->u.vector < 0x10)
 			r = -EINVAL;
 		else {
+			mutex_lock(&kvm->lock);
 			kvm->arch.xen.upcall_vector = data->u.vector;
+			mutex_unlock(&kvm->lock);
 			r = 0;
 		}
 		break;
 
+	case KVM_XEN_ATTR_TYPE_EVTCHN:
+		r = kvm_xen_setattr_evtchn(kvm, data);
+		break;
+
 	default:
 		break;
 	}
 
-	mutex_unlock(&kvm->lock);
 	return r;
 }
 
@@ -775,18 +787,6 @@ int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc)
 	return 0;
 }
 
-void kvm_xen_init_vm(struct kvm *kvm)
-{
-}
-
-void kvm_xen_destroy_vm(struct kvm *kvm)
-{
-	kvm_gfn_to_pfn_cache_destroy(kvm, &kvm->arch.xen.shinfo_cache);
-
-	if (kvm->arch.xen_hvm_config.msr)
-		static_branch_slow_dec_deferred(&kvm_xen_enabled);
-}
-
 static int kvm_xen_hypercall_set_result(struct kvm_vcpu *vcpu, u64 result)
 {
 	kvm_rax_write(vcpu, result);
@@ -806,7 +806,8 @@ static int kvm_xen_hypercall_complete_userspace(struct kvm_vcpu *vcpu)
 int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
 {
 	bool longmode;
-	u64 input, params[6];
+	u64 input, params[6], r = -ENOSYS;
+	bool handled = false;
 
 	input = (u64)kvm_register_read(vcpu, VCPU_REGS_RAX);
 
@@ -837,6 +838,19 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
 	trace_kvm_xen_hypercall(input, params[0], params[1], params[2],
 				params[3], params[4], params[5]);
 
+	switch (input) {
+	case __HYPERVISOR_event_channel_op:
+		if (params[0] == EVTCHNOP_send)
+			handled = kvm_xen_hcall_evtchn_send(vcpu, params[1], &r);
+		break;
+
+	default:
+		break;
+	}
+
+	if (handled)
+		return kvm_xen_hypercall_set_result(vcpu, r);
+
 	vcpu->run->exit_reason = KVM_EXIT_XEN;
 	vcpu->run->xen.type = KVM_EXIT_XEN_HCALL;
 	vcpu->run->xen.u.hcall.longmode = longmode;
@@ -1124,6 +1138,213 @@ int kvm_xen_hvm_evtchn_send(struct kvm *kvm, struct kvm_irq_routing_xen_evtchn *
 	return ret;
 }
 
+/*
+ * Support for *outbound* event channel events via the EVTCHNOP_send hypercall.
+ */
+struct evtchnfd {
+	u32 send_port;
+	u32 type;
+	union {
+		struct kvm_xen_evtchn port;
+		struct {
+			u32 port; /* zero */
+			struct eventfd_ctx *ctx;
+		} eventfd;
+	} deliver;
+};
+
+/*
+ * Update target vCPU or priority for a registered sending channel.
+ */
+static int kvm_xen_eventfd_update(struct kvm *kvm,
+				  struct kvm_xen_hvm_attr *data)
+{
+	u32 port = data->u.evtchn.send_port;
+	struct evtchnfd *evtchnfd;
+
+	if (!port || port >= max_evtchn_port(kvm))
+		return -EINVAL;
+
+	mutex_lock(&kvm->lock);
+	evtchnfd = idr_find(&kvm->arch.xen.evtchn_ports, port);
+	mutex_unlock(&kvm->lock);
+
+	if (!evtchnfd)
+		return -ENOENT;
+
+	/* For an UPDATE, nothing may change except the priority/vcpu */
+	if (evtchnfd->type != data->u.evtchn.type)
+		return -EINVAL;
+
+	/*
+	 * Port cannot change, and if it's zero that was an eventfd
+	 * which can't be changed either.
+	 */
+	if (!evtchnfd->deliver.port.port ||
+	    evtchnfd->deliver.port.port != data->u.evtchn.deliver.port.port)
+		return -EINVAL;
+
+	/* We only support 2 level event channels for now */
+	if (data->u.evtchn.deliver.port.priority != KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL)
+		return -EINVAL;
+
+	mutex_lock(&kvm->lock);
+	evtchnfd->deliver.port.priority = data->u.evtchn.deliver.port.priority;
+	if (evtchnfd->deliver.port.vcpu_id != data->u.evtchn.deliver.port.vcpu) {
+		evtchnfd->deliver.port.vcpu_id = data->u.evtchn.deliver.port.vcpu;
+		evtchnfd->deliver.port.vcpu_idx = -1;
+	}
+	mutex_unlock(&kvm->lock);
+	return 0;
+}
+
+/*
+ * Configure the target (eventfd or local port delivery) for sending on
+ * a given event channel.
+ */
+static int kvm_xen_eventfd_assign(struct kvm *kvm,
+				  struct kvm_xen_hvm_attr *data)
+{
+	u32 port = data->u.evtchn.send_port;
+	struct eventfd_ctx *eventfd = NULL;
+	struct evtchnfd *evtchnfd = NULL;
+	int ret = -EINVAL;
+
+	if (!port || port >= max_evtchn_port(kvm))
+		return -EINVAL;
+
+	evtchnfd = kzalloc(sizeof(struct evtchnfd), GFP_KERNEL);
+	if (!evtchnfd)
+		return -ENOMEM;
+
+	switch(data->u.evtchn.type) {
+	case EVTCHNSTAT_ipi:
+		/* IPI  must map back to the same port# */
+		if (data->u.evtchn.deliver.port.port != data->u.evtchn.send_port)
+			goto out; /* -EINVAL */
+		break;
+
+	case EVTCHNSTAT_interdomain:
+		if (data->u.evtchn.deliver.port.port) {
+			if (data->u.evtchn.deliver.port.port >= max_evtchn_port(kvm))
+				goto out; /* -EINVAL */
+		} else {
+			eventfd = eventfd_ctx_fdget(data->u.evtchn.deliver.eventfd.fd);
+			if (IS_ERR(eventfd)) {
+				ret = PTR_ERR(eventfd);
+				goto out;
+			}
+		}
+		break;
+
+	case EVTCHNSTAT_virq:
+	case EVTCHNSTAT_closed:
+	case EVTCHNSTAT_unbound:
+	case EVTCHNSTAT_pirq:
+	default: /* Unknown event channel type */
+		goto out; /* -EINVAL */
+	}
+
+	evtchnfd->type = data->u.evtchn.type;
+	if (eventfd) {
+		evtchnfd->deliver.eventfd.ctx = eventfd;
+	} else {
+		/* We only support 2 level event channels for now */
+		if (data->u.evtchn.deliver.port.priority != KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL)
+			goto out; /* -EINVAL; */
+
+		evtchnfd->deliver.port.port = data->u.evtchn.deliver.port.port;
+		evtchnfd->deliver.port.vcpu_id = data->u.evtchn.deliver.port.vcpu;
+		evtchnfd->deliver.port.vcpu_idx = -1;
+		evtchnfd->deliver.port.priority = data->u.evtchn.deliver.port.priority;
+	}
+
+	mutex_lock(&kvm->lock);
+	ret = idr_alloc(&kvm->arch.xen.evtchn_ports, evtchnfd, port, port + 1,
+			GFP_KERNEL);
+	mutex_unlock(&kvm->lock);
+
+	if (ret >= 0)
+		return 0;
+
+	if (ret == -ENOSPC)
+		ret = -EEXIST;
+out:
+	if (eventfd)
+		eventfd_ctx_put(eventfd);
+	kfree(evtchnfd);
+	return ret;
+}
+
+static int kvm_xen_eventfd_deassign(struct kvm *kvm, u32 port)
+{
+	struct evtchnfd *evtchnfd;
+
+	mutex_lock(&kvm->lock);
+	evtchnfd = idr_remove(&kvm->arch.xen.evtchn_ports, port);
+	mutex_unlock(&kvm->lock);
+
+	if (!evtchnfd)
+		return -ENOENT;
+
+	if (kvm)
+		synchronize_srcu(&kvm->srcu);
+	if (!evtchnfd->deliver.port.port)
+		eventfd_ctx_put(evtchnfd->deliver.eventfd.ctx);
+	kfree(evtchnfd);
+	return 0;
+}
+
+static int kvm_xen_setattr_evtchn(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
+{
+	u32 port = data->u.evtchn.send_port;
+
+	if (!port || port >= max_evtchn_port(kvm))
+		return -EINVAL;
+
+	if (data->u.evtchn.flags == KVM_XEN_EVTCHN_DEASSIGN)
+		return kvm_xen_eventfd_deassign(kvm, port);
+	if (data->u.evtchn.flags == KVM_XEN_EVTCHN_UPDATE)
+		return kvm_xen_eventfd_update(kvm, data);
+	if (data->u.evtchn.flags)
+		return -EINVAL;
+
+	return kvm_xen_eventfd_assign(kvm, data);
+}
+
+static bool kvm_xen_hcall_evtchn_send(struct kvm_vcpu *vcpu, u64 param, u64 *r)
+{
+	struct evtchnfd *evtchnfd;
+	struct evtchn_send send;
+	gpa_t gpa;
+	int idx;
+
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
+	gpa = kvm_mmu_gva_to_gpa_system(vcpu, param, NULL);
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+
+	if (!gpa || kvm_vcpu_read_guest(vcpu, gpa, &send, sizeof(send))) {
+		*r = -EFAULT;
+		return true;
+	}
+
+	/* The evtchn_ports idr is protected by vcpu->kvm->srcu */
+	evtchnfd = idr_find(&vcpu->kvm->arch.xen.evtchn_ports, send.port);
+	if (!evtchnfd)
+		return false;
+
+	if (evtchnfd->deliver.port.port) {
+		int ret = kvm_xen_set_evtchn(&evtchnfd->deliver.port, vcpu->kvm);
+		if (ret < 0 && ret != -ENOTCONN)
+			return false;
+	} else {
+		eventfd_signal(evtchnfd->deliver.eventfd.ctx, 1);
+	}
+
+	*r = 0;
+	return true;
+}
+
 void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
 {
 	kvm_gfn_to_pfn_cache_destroy(vcpu->kvm,
@@ -1135,3 +1356,26 @@ void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
 	kvm_gfn_to_pfn_cache_destroy(vcpu->kvm,
 				     &vcpu->arch.xen.vcpu_time_info_cache);
 }
+
+void kvm_xen_init_vm(struct kvm *kvm)
+{
+	idr_init(&kvm->arch.xen.evtchn_ports);
+}
+
+void kvm_xen_destroy_vm(struct kvm *kvm)
+{
+	struct evtchnfd *evtchnfd;
+	int i;
+
+	kvm_gfn_to_pfn_cache_destroy(kvm, &kvm->arch.xen.shinfo_cache);
+
+	idr_for_each_entry(&kvm->arch.xen.evtchn_ports, evtchnfd, i) {
+		if (!evtchnfd->deliver.port.port)
+			eventfd_ctx_put(evtchnfd->deliver.eventfd.ctx);
+		kfree(evtchnfd);
+	}
+	idr_destroy(&kvm->arch.xen.evtchn_ports);
+
+	if (kvm->arch.xen_hvm_config.msr)
+		static_branch_slow_dec_deferred(&kvm_xen_enabled);
+}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5b10e43e294c..9f4150d857e0 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1676,6 +1676,31 @@ struct kvm_xen_hvm_attr {
 		struct {
 			__u64 gfn;
 		} shared_info;
+		struct {
+			__u32 send_port;
+			__u32 type; /* EVTCHNSTAT_ipi / EVTCHNSTAT_interdomain */
+			__u32 flags;
+#define KVM_XEN_EVTCHN_DEASSIGN		(1 << 0)
+#define KVM_XEN_EVTCHN_UPDATE		(1 << 1)
+			/*
+			 * Events sent by the guest are either looped back to
+			 * the guest itself (potentially on a different port#)
+			 * or signalled via an eventfd.
+			 */
+			union {
+				struct {
+					__u32 port;
+					__u32 vcpu;
+					__u32 priority;
+				} port;
+				struct {
+					__u32 port; /* Zero for eventfd */
+					__s32 fd;
+				} eventfd;
+				__u32 padding[4];
+			} deliver;
+		} evtchn;
+
 		__u64 pad[8];
 	} u;
 };
@@ -1684,6 +1709,8 @@ struct kvm_xen_hvm_attr {
 #define KVM_XEN_ATTR_TYPE_LONG_MODE		0x0
 #define KVM_XEN_ATTR_TYPE_SHARED_INFO		0x1
 #define KVM_XEN_ATTR_TYPE_UPCALL_VECTOR		0x2
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_EVTCHN_SEND */
+#define KVM_XEN_ATTR_TYPE_EVTCHN		0x3
 
 /* Per-vCPU Xen attributes */
 #define KVM_XEN_VCPU_GET_ATTR	_IOWR(KVMIO, 0xca, struct kvm_xen_vcpu_attr)
-- 
2.33.1

