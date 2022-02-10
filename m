Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD3864B030F
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 03:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbiBJCIw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 21:08:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbiBJCIq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 21:08:46 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF688262
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 18:08:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=eBT2CqKCMBC53Y0I7CjLXvjtNTKCe8D0c69/7Tbfma8=; b=XK1fXQ/lecZKAJxrn3izfv309f
        Z+jr5oEqAZbgORnHOG3rieSAv+/dd8rNAC3hVF8Rnzgt20DzFEXFUOS4Q0sldiGlWG35EO1k2MUYl
        GknTGtWmKUjqhvE+xNhFkXzytsJIeSR3/0ntt0FcWU3lnCw78n7olnc3gos0eloTpz4VIr0FNr7xT
        fBG7TdlKFgfSBmLZ3AVtx1qvZM7+Ak2YHSoev83wZG0S8plEghvHFtyAiiWzyro/IgElDVfxcqqqA
        WQnsA7VyLjbyPHAjN1fhAYc7hd5MA25B7O3CBqB/iDoSXEu+aAoxrCB0ZTFnQAOqn6lGsOlqXPt/T
        uV6MWqXw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nHxIy-008YWK-K2; Thu, 10 Feb 2022 00:27:24 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nHxIy-0019Dr-9c; Thu, 10 Feb 2022 00:27:24 +0000
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
Subject: [PATCH v0 15/15] KVM: x86/xen: handle PV spinlocks slowpath
Date:   Thu, 10 Feb 2022 00:27:21 +0000
Message-Id: <20220210002721.273608-16-dwmw2@infradead.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220210002721.273608-1-dwmw2@infradead.org>
References: <20220210002721.273608-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Boris Ostrovsky <boris.ostrovsky@oracle.com>

Add support for SCHEDOP_poll hypercall.

This implementation is optimized for polling for a single channel, which
is what Linux does. Polling for multiple channels is not especially
efficient (and has not been tested).

PV spinlocks slow path uses this hypercall, and explicitly crash if it's
not supported.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h               |   3 +
 arch/x86/kvm/x86.c                            |   2 +
 arch/x86/kvm/xen.c                            | 140 ++++++++++++++++++
 arch/x86/kvm/xen.h                            |   5 +
 .../selftests/kvm/x86_64/xen_shinfo_test.c    |   6 +
 5 files changed, 156 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 50cbea89739b..7aa46b906fdc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -613,6 +613,8 @@ struct kvm_vcpu_xen {
 	u32 timer_virq;
 	atomic_t timer_pending;
 	struct hrtimer timer;
+	int poll_evtchn;
+	struct timer_list poll_timer;
 };
 
 struct kvm_vcpu_arch {
@@ -1027,6 +1029,7 @@ struct kvm_xen {
 	u8 upcall_vector;
 	struct gfn_to_pfn_cache shinfo_cache;
 	struct idr evtchn_ports;
+	unsigned long poll_mask[BITS_TO_LONGS(KVM_MAX_VCPUS)];
 };
 
 enum kvm_irqchip_mode {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8ef276fed7fe..b43adb84d30b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11132,6 +11132,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.pending_external_vector = -1;
 	vcpu->arch.preempted_in_kernel = false;
 
+	kvm_xen_init_vcpu(vcpu);
+
 #if IS_ENABLED(CONFIG_HYPERV)
 	vcpu->arch.hv_root_tdp = INVALID_PAGE;
 #endif
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 87706bcecaef..49059ca085b1 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -10,6 +10,7 @@
 #include "xen.h"
 #include "lapic.h"
 #include "hyperv.h"
+#include "lapic.h"
 
 #include <linux/eventfd.h>
 #include <linux/kvm_host.h>
@@ -988,9 +989,133 @@ static int kvm_xen_hypercall_complete_userspace(struct kvm_vcpu *vcpu)
 	return kvm_xen_hypercall_set_result(vcpu, run->xen.u.hcall.result);
 }
 
+static bool wait_pending_event(struct kvm_vcpu *vcpu, int nr_ports,
+			       evtchn_port_t *ports)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct gfn_to_pfn_cache *gpc = &kvm->arch.xen.shinfo_cache;
+	unsigned long *pending_bits;
+	unsigned long flags;
+	bool ret = true;
+	int idx, i;
+
+	read_lock_irqsave(&gpc->lock, flags);
+	idx = srcu_read_lock(&kvm->srcu);
+	if (!kvm_gfn_to_pfn_cache_check(kvm, gpc, gpc->gpa, PAGE_SIZE))
+		goto out_rcu;
+
+	ret = false;
+	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode) {
+		struct shared_info *shinfo = gpc->khva;
+		pending_bits = (unsigned long *)&shinfo->evtchn_pending;
+	} else {
+		struct compat_shared_info *shinfo = gpc->khva;
+		pending_bits = (unsigned long *)&shinfo->evtchn_pending;
+	}
+
+	for (i = 0; i < nr_ports; i++) {
+		if (test_bit(ports[i], pending_bits)) {
+			ret = true;
+			break;
+		}
+	}
+
+ out_rcu:
+	srcu_read_unlock(&kvm->srcu, idx);
+	read_unlock_irqrestore(&gpc->lock, flags);
+
+	return ret;
+}
+
+static bool kvm_xen_schedop_poll(struct kvm_vcpu *vcpu, u64 param, u64 *r)
+{
+	int idx, i;
+	struct sched_poll sched_poll;
+	evtchn_port_t port, *ports;
+	int ret = 0;
+	gpa_t gpa;
+
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
+	gpa = kvm_mmu_gva_to_gpa_system(vcpu, param, NULL);
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+
+	if (!gpa || kvm_vcpu_read_guest(vcpu, gpa, &sched_poll,
+					sizeof(sched_poll))) {
+		*r = -EFAULT;
+		return true;
+	}
+
+	if (unlikely(sched_poll.nr_ports > 1)) {
+		/* Xen (unofficially) limits number of pollers to 128 */
+		if (sched_poll.nr_ports > 128)
+			return -EINVAL;
+
+		ports = kmalloc_array(sched_poll.nr_ports,
+				      sizeof(*ports), GFP_KERNEL);
+		if (!ports)
+			return -ENOMEM;
+	} else
+		ports = &port;
+
+	for (i = 0; i < sched_poll.nr_ports; i++) {
+		idx = srcu_read_lock(&vcpu->kvm->srcu);
+		gpa = kvm_mmu_gva_to_gpa_system(vcpu,
+						(gva_t)(sched_poll.ports + i),
+						NULL);
+		srcu_read_unlock(&vcpu->kvm->srcu, idx);
+
+		if (!gpa || kvm_vcpu_read_guest(vcpu, gpa,
+						&ports[i], sizeof(port))) {
+			ret = -EFAULT;
+			goto out;
+		}
+	}
+
+	if (sched_poll.nr_ports == 1)
+		vcpu->arch.xen.poll_evtchn = port;
+	else
+		vcpu->arch.xen.poll_evtchn = -1;
+
+	set_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.xen.poll_mask);
+
+	if (!wait_pending_event(vcpu, sched_poll.nr_ports, ports)) {
+		vcpu->arch.mp_state = KVM_MP_STATE_HALTED;
+
+		if (sched_poll.timeout)
+			mod_timer(&vcpu->arch.xen.poll_timer, jiffies + nsecs_to_jiffies(sched_poll.timeout));
+
+		kvm_vcpu_halt(vcpu);
+
+		if (sched_poll.timeout)
+			del_timer(&vcpu->arch.xen.poll_timer);
+	}
+
+	vcpu->arch.xen.poll_evtchn = 0;
+
+out:
+	/* Really, this is only needed in case of timeout */
+	clear_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.xen.poll_mask);
+
+	if (unlikely(sched_poll.nr_ports > 1))
+		kfree(ports);
+	return ret;
+}
+
+static void cancel_evtchn_poll(struct timer_list *t)
+{
+	struct kvm_vcpu *vcpu = from_timer(vcpu, t, arch.xen.poll_timer);
+
+	kvm_make_request(KVM_REQ_UNHALT, vcpu);
+}
+
 static bool kvm_xen_hcall_sched_op(struct kvm_vcpu *vcpu, int cmd, u64 param, u64 *r)
 {
 	switch (cmd) {
+	case SCHEDOP_poll:
+		if ((vcpu->kvm->arch.xen_hvm_config.flags &
+		     KVM_XEN_HVM_CONFIG_EVTCHN_SEND) && lapic_in_kernel(vcpu))
+			return kvm_xen_schedop_poll(vcpu, param, r);
+		fallthrough;
 	case SCHEDOP_yield:
 		kvm_vcpu_on_spin(vcpu, true);
 		*r = 0;
@@ -1152,6 +1277,17 @@ static inline int max_evtchn_port(struct kvm *kvm)
 		return COMPAT_EVTCHN_2L_NR_CHANNELS;
 }
 
+static void kvm_xen_check_poller(struct kvm_vcpu *vcpu, int port)
+{
+	int poll_evtchn = vcpu->arch.xen.poll_evtchn;
+
+	if ((poll_evtchn == port || poll_evtchn == -1) &&
+	    test_and_clear_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.xen.poll_mask)) {
+		kvm_make_request(KVM_REQ_UNBLOCK, vcpu);
+		kvm_vcpu_kick(vcpu);
+	}
+}
+
 /*
  * The return value from this function is propagated to kvm_set_irq() API,
  * so it returns:
@@ -1219,6 +1355,7 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 		rc = 0; /* It was already raised */
 	} else if (test_bit(xe->port, mask_bits)) {
 		rc = -ENOTCONN; /* Masked */
+		kvm_xen_check_poller(vcpu, xe->port);
 	} else {
 		rc = 1; /* Delivered to the bitmap in shared_info. */
 		/* Now switch to the vCPU's vcpu_info to set the index and pending_sel */
@@ -1628,6 +1765,8 @@ static bool kvm_xen_hcall_evtchn_send(struct kvm_vcpu *vcpu, u64 param, u64 *r)
 void kvm_xen_init_vcpu(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.xen.vcpu_id = vcpu->vcpu_idx;
+	vcpu->arch.xen.poll_evtchn = 0;
+	timer_setup(&vcpu->arch.xen.poll_timer, cancel_evtchn_poll, 0);
 }
 
 void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
@@ -1641,6 +1780,7 @@ void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
 				     &vcpu->arch.xen.vcpu_info_cache);
 	kvm_gfn_to_pfn_cache_destroy(vcpu->kvm,
 				     &vcpu->arch.xen.vcpu_time_info_cache);
+	del_timer_sync(&vcpu->arch.xen.poll_timer);
 }
 
 void kvm_xen_init_vm(struct kvm *kvm)
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index 616fe751c8fc..eaddbeb2f923 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -24,6 +24,7 @@ int kvm_xen_hvm_evtchn_send(struct kvm *kvm, struct kvm_irq_routing_xen_evtchn *
 int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data);
 int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc);
 void kvm_xen_init_vm(struct kvm *kvm);
+void kvm_xen_init_vcpu(struct kvm_vcpu *vcpu);
 void kvm_xen_destroy_vm(struct kvm *kvm);
 void kvm_xen_init_vcpu(struct kvm_vcpu *vcpu);
 void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu);
@@ -83,6 +84,10 @@ static inline int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
 	return 1;
 }
 
+static inline void kvm_xen_init_vcpu(struct kvm_vcpu *vcpu)
+{
+}
+
 static inline void kvm_xen_init_vm(struct kvm *kvm)
 {
 }
diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 865e17146815..376c611443cd 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -233,6 +233,12 @@ int main(int argc, char *argv[])
 		.flags = KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL,
 		.msr = XEN_HYPERCALL_MSR,
 	};
+
+	/* Let the kernel know that we *will* use it for sending all
+	 * event channels, which lets it intercept SCHEDOP_poll */
+	if (xen_caps & KVM_XEN_HVM_CONFIG_EVTCHN_SEND)
+		hvmc.flags |= KVM_XEN_HVM_CONFIG_EVTCHN_SEND;
+
 	vm_ioctl(vm, KVM_XEN_HVM_CONFIG, &hvmc);
 
 	struct kvm_xen_hvm_attr lm = {
-- 
2.33.1

