Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4ED2D9447
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 09:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439445AbgLNIky (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 03:40:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439411AbgLNIkx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 03:40:53 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101C7C0611CC
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 00:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=J/dLur8MvF7TQmXYQ8rYJGliAmbx7KknzXGBTSiNT4I=; b=w3ZOxVQJe1cB9eG9hX/Vt5K/Wh
        2gsemHM0ChA1BBBx3lcNTY7DMZe3ZYCLOarf1mclzmNZw75VWboDgzGuWCtSeGUJ76VebG+c9fBgF
        8N7LVrIx9j1RfEyjPIzKqtsq4a5yt+fow/lGUWrsSEPRvk1kQ7Pc6seRDZe8t3rbVAlqp1CxkK8Yi
        /jPpw3u8pCa7Uga9zJHZzKGRe9wJtDISfyAnIlRQUvdb1l42McITHzifzlD4lMKcC5bB4YHPmg3NC
        9sRMhcyl6Rs84+VWBhiCiTbwwQL2IbYqtdbniVP7LwdKFGQSxewyb3a2HQT/RoBDtkkA09vjXBDDM
        45TWAXzQ==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kojNs-0006lW-TH; Mon, 14 Dec 2020 08:39:09 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kojNr-008Sy9-Qv; Mon, 14 Dec 2020 08:39:07 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com
Subject: [PATCH v3 14/17] KVM: x86/xen: register runstate info
Date:   Mon, 14 Dec 2020 08:39:02 +0000
Message-Id: <20201214083905.2017260-15-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201214083905.2017260-1-dwmw2@infradead.org>
References: <20201214083905.2017260-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>

Allow emulator to register vcpu runstates which allow Xen guests
to use that for steal clock. The 'preempted' state of KVM steal clock
equates to 'runnable' state, 'running' has similar meanings for both and
'offline' is used when system admin needs to bring vcpu offline or
hotplug.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |   5 ++
 arch/x86/kvm/x86.c              |  10 +++
 arch/x86/kvm/xen.c              | 148 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/xen.h              |   9 +-
 include/uapi/linux/kvm.h        |   1 +
 5 files changed, 171 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b7dfcb4de92a..4b345a8945ea 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -523,10 +523,15 @@ struct kvm_vcpu_hv {
 /* Xen HVM per vcpu emulation context */
 struct kvm_vcpu_xen {
 	u64 hypercall_rip;
+	u32 current_runstate;
 	bool vcpu_info_set;
 	bool vcpu_time_info_set;
+	bool runstate_set;
 	struct gfn_to_hva_cache vcpu_info_cache;
 	struct gfn_to_hva_cache vcpu_time_info_cache;
+	struct gfn_to_hva_cache runstate_cache;
+	u64 last_steal;
+	u64 last_state_ns;
 };
 
 struct kvm_vcpu_arch {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2234fdf49d82..bd4bd9a818d8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2940,6 +2940,11 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	struct kvm_host_map map;
 	struct kvm_steal_time *st;
 
+	if (vcpu->arch.xen.runstate_set) {
+		kvm_xen_setup_runstate_page(vcpu);
+		return;
+	}
+
 	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
 		return;
 
@@ -3968,6 +3973,11 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	struct kvm_host_map map;
 	struct kvm_steal_time *st;
 
+	if (vcpu->arch.xen.runstate_set) {
+		kvm_xen_runstate_set_preempted(vcpu);
+		return;
+	}
+
 	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
 		return;
 
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 1cca46effec8..17cbb4462b7e 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -11,9 +11,11 @@
 #include "hyperv.h"
 
 #include <linux/kvm_host.h>
+#include <linux/sched/stat.h>
 
 #include <trace/events/kvm.h>
 #include <xen/interface/xen.h>
+#include <xen/interface/vcpu.h>
 
 #include "trace.h"
 
@@ -56,6 +58,124 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
 	return 0;
 }
 
+static void kvm_xen_update_runstate(struct kvm_vcpu *v, int state, u64 steal_ns)
+{
+	struct kvm_vcpu_xen *vcpu_xen = &v->arch.xen;
+	struct vcpu_runstate_info runstate;
+	unsigned int offset = offsetof(struct compat_vcpu_runstate_info, state_entry_time);
+	u64 now, delta;
+
+	BUILD_BUG_ON(sizeof(struct compat_vcpu_runstate_info) != 0x2c);
+
+#ifdef CONFIG_X86_64
+	/*
+	 * The only difference is alignment of uint64_t in 32-bit.
+	 * So the first field 'state' is accessed via *runstate_state
+	 * which is unmodified, while the other fields are accessed
+	 * through 'runstate->' which we tweak here by adding 4.
+	 */
+	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state_entry_time) !=
+		     offsetof(struct compat_vcpu_runstate_info, state_entry_time) + 4);
+	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, time) !=
+		     offsetof(struct compat_vcpu_runstate_info, time) + 4);
+
+	offset = offsetof(struct vcpu_runstate_info, state_entry_time);
+#endif
+	/*
+	 * Although it's called "state_entry_time" and explicitly documented
+	 * as being "the system time at which the VCPU was last scheduled to
+	 * run", Xen just treats it as a counter for HVM domains too.
+	 */
+	if (kvm_read_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
+					 &runstate.state_entry_time, offset,
+					 sizeof(u64) * 5))
+		return;
+
+	runstate.state_entry_time = XEN_RUNSTATE_UPDATE |
+		(runstate.state_entry_time + 1);
+
+	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
+					  &runstate.state_entry_time, offset,
+					  sizeof(u64)))
+		return;
+	smp_wmb();
+
+	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state) !=
+		     offsetof(struct compat_vcpu_runstate_info, state));
+	BUILD_BUG_ON(sizeof(((struct vcpu_runstate_info *)0)->state) !=
+		     sizeof(((struct compat_vcpu_runstate_info *)0)->state));
+	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
+					  &state,
+					  offsetof(struct vcpu_runstate_info, state),
+					  sizeof(runstate.state)))
+		return;
+
+	now = ktime_get_ns();
+	delta = now - vcpu_xen->last_state_ns - steal_ns;
+	runstate.time[vcpu_xen->current_runstate] += delta;
+	if (steal_ns)
+		runstate.time[RUNSTATE_runnable] += steal_ns;
+
+	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state_entry_time) !=
+		     offsetof(struct vcpu_runstate_info, time) - sizeof(u64));
+	BUILD_BUG_ON(offsetof(struct compat_vcpu_runstate_info, state_entry_time) !=
+		     offsetof(struct compat_vcpu_runstate_info, time) - sizeof(u64));
+	BUILD_BUG_ON(sizeof(((struct vcpu_runstate_info *)0)->time) !=
+		     sizeof(((struct compat_vcpu_runstate_info *)0)->time));
+	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
+					  &runstate.time[0],
+					  offset + sizeof(u64),
+					  sizeof(runstate.time)))
+		return;
+	smp_wmb();
+	vcpu_xen->current_runstate = state;
+	vcpu_xen->last_state_ns = now;
+
+	runstate.state_entry_time &= ~XEN_RUNSTATE_UPDATE;
+	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
+					  &runstate.state_entry_time, offset,
+					  sizeof(u64)))
+		return;
+}
+
+void kvm_xen_runstate_set_preempted(struct kvm_vcpu *v)
+{
+	struct kvm_vcpu_xen *vcpu_xen = &v->arch.xen;
+	int new_state;
+
+	BUILD_BUG_ON(sizeof(struct compat_vcpu_runstate_info) != 0x2c);
+	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state) !=
+		     offsetof(struct compat_vcpu_runstate_info, state));
+	BUILD_BUG_ON(sizeof(((struct vcpu_runstate_info *)0)->state) !=
+		     sizeof(((struct compat_vcpu_runstate_info *)0)->state));
+
+	if (v->preempted) {
+		new_state = RUNSTATE_runnable;
+	} else {
+		new_state = RUNSTATE_blocked;
+		vcpu_xen->last_steal = current->sched_info.run_delay;
+	}
+
+	kvm_xen_update_runstate(v, new_state, 0);
+}
+
+void kvm_xen_setup_runstate_page(struct kvm_vcpu *v)
+{
+	struct kvm_vcpu_xen *vcpu_xen = &v->arch.xen;
+	u64 steal_time = 0;
+
+	/*
+	 * If the CPU was blocked when it last stopped, presumably
+	 * it became unblocked at some point because it's being run
+	 * again now. The scheduler run_delay is the runnable time,
+	 * to be subtracted from the blocked time.
+	 */
+	if (vcpu_xen->current_runstate == RUNSTATE_blocked)
+		steal_time = current->sched_info.run_delay - vcpu_xen->last_steal;
+
+	kvm_xen_update_runstate(v, RUNSTATE_running, steal_time);
+}
+
 int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 {
 	struct kvm_vcpu *v;
@@ -78,7 +198,6 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		v = kvm_get_vcpu_by_id(kvm, data->u.vcpu_attr.vcpu_id);
 		if (!v)
 			return -EINVAL;
-
 		/* No compat necessary here. */
 		BUILD_BUG_ON(sizeof(struct vcpu_info) !=
 			     sizeof(struct compat_vcpu_info));
@@ -110,6 +229,22 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
 		break;
 
+	case KVM_XEN_ATTR_TYPE_VCPU_RUNSTATE:
+		v = kvm_get_vcpu_by_id(kvm, data->u.vcpu_attr.vcpu_id);
+		if (!v)
+			return -EINVAL;
+
+		r = kvm_gfn_to_hva_cache_init(kvm, &v->arch.xen.runstate_cache,
+					      data->u.vcpu_attr.gpa,
+					      sizeof(struct vcpu_runstate_info));
+		if (r)
+			return r;
+
+		v->arch.xen.runstate_set = true;
+		v->arch.xen.current_runstate = RUNSTATE_blocked;
+		v->arch.xen.last_state_ns = ktime_get_ns();
+		break;
+
 	default:
 		break;
 	}
@@ -157,6 +292,17 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		}
 		break;
 
+	case KVM_XEN_ATTR_TYPE_VCPU_RUNSTATE:
+		v = kvm_get_vcpu_by_id(kvm, data->u.vcpu_attr.vcpu_id);
+		if (!v)
+			return -EINVAL;
+
+		if (v->arch.xen.runstate_set) {
+			data->u.vcpu_attr.gpa = v->arch.xen.runstate_cache.gpa;
+			r = 0;
+		}
+		break;
+
 	default:
 		break;
 	}
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index 120b7450252a..407e717476d6 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -9,6 +9,8 @@
 #ifndef __ARCH_X86_KVM_XEN_H__
 #define __ARCH_X86_KVM_XEN_H__
 
+void kvm_xen_setup_runstate_page(struct kvm_vcpu *vcpu);
+void kvm_xen_runstate_set_preempted(struct kvm_vcpu *vcpu);
 int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
 int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
 int kvm_xen_hypercall(struct kvm_vcpu *vcpu);
@@ -54,7 +56,12 @@ struct compat_shared_info {
 	uint32_t evtchn_mask[32];
 	struct pvclock_wall_clock wc;
 	struct compat_arch_shared_info arch;
-
 };
 
+struct compat_vcpu_runstate_info {
+    int state;
+    uint64_t state_entry_time;
+    uint64_t time[4];
+} __attribute__((packed));
+
 #endif /* __ARCH_X86_KVM_XEN_H__ */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f60c5c61761c..ab83f3588719 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1600,6 +1600,7 @@ struct kvm_xen_hvm_attr {
 #define KVM_XEN_ATTR_TYPE_SHARED_INFO		0x1
 #define KVM_XEN_ATTR_TYPE_VCPU_INFO		0x2
 #define KVM_XEN_ATTR_TYPE_VCPU_TIME_INFO	0x3
+#define KVM_XEN_ATTR_TYPE_VCPU_RUNSTATE		0x4
 
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
-- 
2.26.2

