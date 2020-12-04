Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62FC52CE4F5
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 02:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388590AbgLDBUv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 20:20:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388385AbgLDBUu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 20:20:50 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D00C094240
        for <kvm@vger.kernel.org>; Thu,  3 Dec 2020 17:18:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=LRgdafCXv8e6EaI4ODMc21mNJKXljBechI+X48MmckU=; b=akepFsPjIGCM588MA4Mc4zEwuy
        Kf7tFJZ4bdTMd0JIlS3supImZ+YTv+Yw20Gyq9b/067TMmIck7vEmvgLDUdyApaadQNBLGQfh+QLm
        jktH3p2rO+faFzXZrjLqJTH4+tai75yYXb57s4p0L6u0sPrDpn+10UowHgasmT0ppApOQjnzuKbbL
        a2cAGGDfJ61Z2bL8ArWLeHQ0W4R6AH72fTJm7M5TOaYSgn4ajrMthxrnnsOaFIP+zOkPxZQ1LSTXL
        cW+wfg21MxFt7h7R46ok+fFMhZSFysz3pQAAe7LnTdeeNQKN0fwtOG3yD/UBAPCKpFJ8CS7svIiWW
        9Io4v3KA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kkzkK-0004Kh-UH; Fri, 04 Dec 2020 01:18:55 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kkzkK-00CSAN-Ff; Fri, 04 Dec 2020 01:18:52 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 14/15] KVM: x86/xen: register runstate info
Date:   Fri,  4 Dec 2020 01:18:47 +0000
Message-Id: <20201204011848.2967588-15-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201204011848.2967588-1-dwmw2@infradead.org>
References: <20201204011848.2967588-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
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
 arch/x86/kvm/xen.c              | 123 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/xen.h              |   9 ++-
 include/uapi/linux/kvm.h        |   1 +
 5 files changed, 144 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ec9425289209..d8716ef27728 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -527,6 +527,11 @@ struct kvm_vcpu_xen {
 	struct vcpu_info *vcpu_info;
 	struct kvm_host_map pv_time_map;
 	struct pvclock_vcpu_time_info *pv_time;
+	struct kvm_host_map runstate_map;
+	void *runstate;
+	uint32_t current_runstate;
+	uint64_t last_steal;
+	uint64_t last_state_ns;
 };
 
 struct kvm_vcpu_arch {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0a15748e3aa8..17ae827ae8cc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2935,6 +2935,11 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	struct kvm_host_map map;
 	struct kvm_steal_time *st;
 
+	if (vcpu->arch.xen.runstate) {
+		kvm_xen_setup_runstate_page(vcpu);
+		return;
+	}
+
 	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
 		return;
 
@@ -3962,6 +3967,11 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	struct kvm_host_map map;
 	struct kvm_steal_time *st;
 
+	if (vcpu->arch.xen.runstate) {
+		kvm_xen_runstate_set_preempted(vcpu);
+		return;
+	}
+
 	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
 		return;
 
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 5c67d9038651..e49e59f93828 100644
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
 
@@ -131,6 +133,98 @@ static void kvm_xen_update_vcpu_time(struct kvm_vcpu *v,
 	guest_hv_clock->version = vcpu->hv_clock.version;
 }
 
+static void kvm_xen_update_runstate(struct kvm_vcpu *vcpu, int state, u64 steal_ns)
+{
+	struct kvm_vcpu_xen *vcpu_xen = vcpu_to_xen_vcpu(vcpu);
+	struct compat_vcpu_runstate_info *runstate;
+	u32 *runstate_state;
+	u64 now, delta;
+
+	BUILD_BUG_ON(sizeof(struct compat_vcpu_runstate_info) != 0x2c);
+	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state) !=
+		     offsetof(struct compat_vcpu_runstate_info, state));
+	BUILD_BUG_ON(sizeof(((struct vcpu_runstate_info *)0)->state) !=
+		     sizeof(((struct compat_vcpu_runstate_info *)0)->state));
+
+	runstate = vcpu_xen->runstate;
+	runstate_state = &runstate->state;
+
+#ifdef CONFIG_64BIT
+	/*
+	 * The only different is alignment of uint64_t in 32-bit.
+	 * So the first field 'state' is accessed via *runstate_state
+	 * which is unmodified, while the other fields are accessed
+	 * through 'runstate->' which we tweak here by adding 4.
+	 */
+	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state_entry_time) !=
+		     offsetof(struct compat_vcpu_runstate_info, state_entry_time) + 4);
+	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, time) !=
+		     offsetof(struct compat_vcpu_runstate_info, time) + 4);
+	if (vcpu->kvm->arch.xen.long_mode)
+		runstate = ((void *)runstate) + 4;
+#endif
+	/*
+	 * Although it's called "state_entry_time" and explicitly documented
+	 * as being "the system time at which the VCPU was last scheduled to
+	 * run", Xen just treats it as a counter for HVM domains too.
+	 */
+	runstate->state_entry_time = XEN_RUNSTATE_UPDATE |
+		(runstate->state_entry_time + 1);
+	smp_wmb();
+
+	now = ktime_get_ns();
+	delta = now - vcpu_xen->last_state_ns - steal_ns;
+
+	*runstate_state = state;
+	runstate->time[vcpu_xen->current_runstate] += delta;
+	if (steal_ns)
+		runstate->time[RUNSTATE_runnable] += steal_ns;
+	smp_wmb();
+	vcpu_xen->current_runstate = state;
+	vcpu_xen->last_state_ns = now;
+
+	runstate->state_entry_time &= ~XEN_RUNSTATE_UPDATE;
+	smp_wmb();
+}
+
+void kvm_xen_runstate_set_preempted(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_xen *vcpu_xen = vcpu_to_xen_vcpu(vcpu);
+	int new_state;
+
+	BUILD_BUG_ON(sizeof(struct compat_vcpu_runstate_info) != 0x2c);
+	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state) !=
+		     offsetof(struct compat_vcpu_runstate_info, state));
+	BUILD_BUG_ON(sizeof(((struct vcpu_runstate_info *)0)->state) !=
+		     sizeof(((struct compat_vcpu_runstate_info *)0)->state));
+
+	if (vcpu->preempted) {
+		new_state = RUNSTATE_runnable;
+	} else {
+		new_state = RUNSTATE_blocked;
+		vcpu_xen->last_steal = current->sched_info.run_delay;
+	}
+
+	kvm_xen_update_runstate(vcpu, new_state, 0);
+}
+
+void kvm_xen_setup_runstate_page(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_xen *vcpu_xen = vcpu_to_xen_vcpu(vcpu);
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
+	kvm_xen_update_runstate(vcpu, RUNSTATE_running, steal_time);
+}
+
 void kvm_xen_setup_pvclock_page(struct kvm_vcpu *v)
 {
 	struct kvm_vcpu_xen *vcpu_xen = vcpu_to_xen_vcpu(v);
@@ -167,6 +261,15 @@ static int vcpu_attr_loc(struct kvm_vcpu *vcpu, u16 type,
 		if (sz)
 			*sz = sizeof(struct pvclock_vcpu_time_info);
 		return 0;
+
+	case KVM_XEN_ATTR_TYPE_VCPU_RUNSTATE:
+		*map = &vcpu->arch.xen.runstate_map;
+		*hva = (void **)&vcpu->arch.xen.runstate;
+		if (sz)
+			*sz = vcpu->kvm->arch.xen.long_mode ?
+				sizeof(struct shared_info) :
+				sizeof(struct compat_shared_info);
+		return 0;
 	}
 	return -EINVAL;
 }
@@ -191,6 +294,10 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		break;
 	}
 
+	case KVM_XEN_ATTR_TYPE_VCPU_RUNSTATE:
+		if (unlikely(!sched_info_on()))
+			return -ENOTSUPP;
+	/* fallthrough */
 	case KVM_XEN_ATTR_TYPE_VCPU_TIME_INFO:
 	case KVM_XEN_ATTR_TYPE_VCPU_INFO: {
 		gpa_t gpa = data->u.vcpu_attr.gpa;
@@ -208,9 +315,13 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 			return r;
 
 		r = kvm_xen_map_guest_page(kvm, map, hva, gpa, sz);
-		if (!r)
-			kvm_xen_setup_pvclock_page(v);
-
+		if (!r) {
+			if (data->type == KVM_XEN_ATTR_TYPE_VCPU_RUNSTATE) {
+				v->arch.xen.current_runstate = RUNSTATE_runnable;
+				v->arch.xen.last_state_ns = ktime_get_ns();
+			} else
+				kvm_xen_setup_pvclock_page(v);
+		}
 		break;
 	}
 
@@ -239,6 +350,7 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		break;
 	}
 
+	case KVM_XEN_ATTR_TYPE_VCPU_RUNSTATE:
 	case KVM_XEN_ATTR_TYPE_VCPU_TIME_INFO:
 	case KVM_XEN_ATTR_TYPE_VCPU_INFO: {
 		struct kvm_host_map *map;
@@ -414,6 +526,11 @@ void kvm_xen_vcpu_uninit(struct kvm_vcpu *vcpu)
 			      NULL, true, false);
 		vcpu_xen->pv_time = NULL;
 	}
+	if (vcpu_xen->runstate) {
+		kvm_unmap_gfn(vcpu->kvm, &vcpu_xen->runstate_map,
+			      NULL, true, false);
+		vcpu_xen->runstate = NULL;
+	}
 }
 
 void kvm_xen_destroy_vm(struct kvm *kvm)
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index 6d09b46d3c2e..42a9cc9f49a4 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -23,6 +23,8 @@ static inline struct kvm_vcpu *xen_vcpu_to_vcpu(struct kvm_vcpu_xen *xen_vcpu)
 }
 
 void kvm_xen_setup_pvclock_page(struct kvm_vcpu *vcpu);
+void kvm_xen_setup_runstate_page(struct kvm_vcpu *vcpu);
+void kvm_xen_runstate_set_preempted(struct kvm_vcpu *vcpu);
 int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
 int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
 int kvm_xen_hypercall(struct kvm_vcpu *vcpu);
@@ -70,7 +72,12 @@ struct compat_shared_info {
 	uint32_t evtchn_mask[sizeof(compat_ulong_t) * 8];
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
index 8a1914a9e206..cb2777c37ae5 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1599,6 +1599,7 @@ struct kvm_xen_hvm_attr {
 #define KVM_XEN_ATTR_TYPE_SHARED_INFO		0x1
 #define KVM_XEN_ATTR_TYPE_VCPU_INFO		0x2
 #define KVM_XEN_ATTR_TYPE_VCPU_TIME_INFO	0x3
+#define KVM_XEN_ATTR_TYPE_VCPU_RUNSTATE		0x4
 
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
-- 
2.26.2

