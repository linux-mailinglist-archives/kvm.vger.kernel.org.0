Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E21327EA9
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 13:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235219AbhCAMyC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 07:54:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235117AbhCAMx7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 07:53:59 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4A4C061756
        for <kvm@vger.kernel.org>; Mon,  1 Mar 2021 04:53:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=kB4eBgKzm+VYCFDlSKpKnNoVpsiLw0VMaIpB9qxVyCo=; b=RjLfyLuH4vM7OfiZV7HkccpxPt
        CJ6vs4NeMoRiINyUSqEAGFamNeVEHhQGzm0uf0wCRu6YIEPuJI013IvXjsKGGtlmlo2bK36get4ch
        VvPeIh4MwVut1uSy8HIAMv6okT00m/fGUWhHHu+YzS+gPUtFj5sVz4D6STQMNLnBDuKH+1S0rJ4az
        EYDpffWb0FbWycko6cYraVAr1KeTvrVG16lLNfnQXgTHz5JihSl2nfidXHa/2XoWTLhztZt95avDa
        ymAjmsl6jP0296hjnL7ndOKEm/jLDVs+IUn2iBBlQaNB6fWOPjSr2Nq9creqn1TKDwQm+v2oc9qeZ
        7RM+i4gA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1lGi2y-0006Hc-PB; Mon, 01 Mar 2021 12:53:13 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lGi2w-003fcw-1C; Mon, 01 Mar 2021 12:53:10 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
Subject: [PATCH 2/2] KVM: x86/xen: Add support for vCPU runstate information
Date:   Mon,  1 Mar 2021 12:53:09 +0000
Message-Id: <20210301125309.874953-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210301125309.874953-1-dwmw2@infradead.org>
References: <20210301125309.874953-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

This is how Xen guests do steal time accounting. The hypervisor records
the amount of time spent in each of running/runnable/blocked/offline
states.

In the Xen accounting, a vCPU is still in state RUNSTATE_running while
in Xen for a hypercall or I/O trap, etc. Only if Xen explicitly schedules
does the state become RUNSTATE_blocked. In KVM this means that even when
the vCPU exits the kvm_run loop, the state remains RUNSTATE_running.

The VMM can explicitly set the vCPU to RUNSTATE_blocked by using the
KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT attribute, and can also use
KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST to retrospectively add a given
amount of time to the blocked state and subtract it from the running
state.

The state_entry_time corresponds to get_kvmclock_ns() at the time the
vCPU entered the current state, and the total times of all four states
should always add up to state_entry_time.

Co-developed-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 Documentation/virt/kvm/api.rst                |  41 +++
 arch/x86/include/asm/kvm_host.h               |   6 +
 arch/x86/kvm/x86.c                            |  13 +-
 arch/x86/kvm/xen.c                            | 286 ++++++++++++++++++
 arch/x86/kvm/xen.h                            |  40 ++-
 include/uapi/linux/kvm.h                      |  13 +
 .../selftests/kvm/x86_64/xen_shinfo_test.c    | 159 +++++++++-
 7 files changed, 553 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 359435d4e417..1a2b5210cdbf 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4878,6 +4878,14 @@ see KVM_XEN_HVM_SET_ATTR above.
 	union {
 		__u64 gpa;
 		__u64 pad[4];
+		struct {
+			__u64 state;
+			__u64 state_entry_time;
+			__u64 time_running;
+			__u64 time_runnable;
+			__u64 time_blocked;
+			__u64 time_offline;
+		} runstate;
 	} u;
   };
 
@@ -4890,6 +4898,31 @@ KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO
   Sets the guest physical address of an additional pvclock structure
   for a given vCPU. This is typically used for guest vsyscall support.
 
+KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR
+  Sets the guest physical address of the vcpu_runstate_info for a given
+  vCPU. This is how a Xen guest tracks CPU state such as steal time.
+
+KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT
+  Sets the runstate (RUNSTATE_running/_runnable/_blocked/_offline) of
+  the given vCPU from the .u.runstate.state member of the structure.
+  KVM automatically accounts running and runnable time but blocked
+  and offline states are only entered explicitly.
+
+KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_DATA
+  Sets all fields of the vCPU runstate data from the .u.runstate member
+  of the structure, including the current runstate. The state_entry_time
+  must equal the sum of the other four times.
+
+KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST
+  This *adds* the contents of the .u.runstate members of the structure
+  to the corresponding members of the given vCPU's runstate data, thus
+  permitting atomic adjustments to the runstate times. The adjustment
+  to the state_entry_time must equal the sum of the adjustments to the
+  other four times. The state field must be set to -1, or to a valid
+  runstate value (RUNSTATE_running, RUNSTATE_runnable, RUNSTATE_blocked
+  or RUNSTATE_offline) to set the current accounted state as of the
+  adjusted state_entry_time.
+
 4.130 KVM_XEN_VCPU_GET_ATTR
 ---------------------------
 
@@ -4902,6 +4935,9 @@ KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO
 Allows Xen vCPU attributes to be read. For the structure and types,
 see KVM_XEN_VCPU_SET_ATTR above.
 
+The KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST type may not be used
+with the KVM_XEN_VCPU_GET_ATTR ioctl.
+
 5. The kvm_run structure
 ========================
 
@@ -6666,6 +6702,7 @@ PVHVM guests. Valid flags are::
   #define KVM_XEN_HVM_CONFIG_HYPERCALL_MSR	(1 << 0)
   #define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
   #define KVM_XEN_HVM_CONFIG_SHARED_INFO	(1 << 2)
+  #define KVM_XEN_HVM_CONFIG_RUNSTATE		(1 << 2)
 
 The KVM_XEN_HVM_CONFIG_HYPERCALL_MSR flag indicates that the KVM_XEN_HVM_CONFIG
 ioctl is available, for the guest to set its hypercall page.
@@ -6680,3 +6717,7 @@ KVM_XEN_HVM_SET_ATTR, KVM_XEN_HVM_GET_ATTR, KVM_XEN_VCPU_SET_ATTR and
 KVM_XEN_VCPU_GET_ATTR ioctls, as well as the delivery of exception vectors
 for event channel upcalls when the evtchn_upcall_pending field of a vcpu's
 vcpu_info is set.
+
+The KVM_XEN_HVM_CONFIG_RUNSTATE flag indicates that the runstate-related
+features KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR/_CURRENT/_DATA/_ADJUST are
+supported by the KVM_XEN_VCPU_SET_ATTR/KVM_XEN_VCPU_GET_ATTR ioctls.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6db60ea8ee5b..c9eee6629d6a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -535,10 +535,16 @@ struct kvm_vcpu_hv {
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
+	u64 runstate_entry_time;
+	u64 runstate_times[4];
 };
 
 struct kvm_vcpu_arch {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 828de7d65074..7b8a74ee6b44 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2992,6 +2992,11 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	struct kvm_host_map map;
 	struct kvm_steal_time *st;
 
+	if (kvm_xen_msr_enabled(vcpu->kvm)) {
+		kvm_xen_runstate_set_running(vcpu);
+		return;
+	}
+
 	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
 		return;
 
@@ -3796,6 +3801,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = KVM_XEN_HVM_CONFIG_HYPERCALL_MSR |
 		    KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL |
 		    KVM_XEN_HVM_CONFIG_SHARED_INFO;
+		if (sched_info_on())
+			r |= KVM_XEN_HVM_CONFIG_RUNSTATE;
 		break;
 #endif
 	case KVM_CAP_SYNC_REGS:
@@ -4075,7 +4082,11 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	if (vcpu->preempted && !vcpu->arch.guest_state_protected)
 		vcpu->arch.preempted_in_kernel = !static_call(kvm_x86_get_cpl)(vcpu);
 
-	kvm_steal_time_set_preempted(vcpu);
+	if (kvm_xen_msr_enabled(vcpu->kvm))
+		kvm_xen_runstate_set_preempted(vcpu);
+	else
+		kvm_steal_time_set_preempted(vcpu);
+
 	static_call(kvm_x86_vcpu_put)(vcpu);
 	vcpu->arch.last_host_tsc = rdtsc();
 	/*
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 77b20ff09078..ae17250e1efe 100644
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
 
@@ -61,6 +63,132 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
 	return ret;
 }
 
+static void kvm_xen_update_runstate(struct kvm_vcpu *v, int state)
+{
+	struct kvm_vcpu_xen *vx = &v->arch.xen;
+	u64 now = get_kvmclock_ns(v->kvm);
+	u64 delta_ns = now - vx->runstate_entry_time;
+	u64 run_delay = current->sched_info.run_delay;
+
+	if (unlikely(!vx->runstate_entry_time))
+		vx->current_runstate = RUNSTATE_offline;
+
+	/*
+	 * Time waiting for the scheduler isn't "stolen" if the
+	 * vCPU wasn't running anyway.
+	 */
+	if (vx->current_runstate == RUNSTATE_running) {
+		u64 steal_ns = run_delay - vx->last_steal;
+
+		delta_ns -= steal_ns;
+
+		vx->runstate_times[RUNSTATE_runnable] += steal_ns;
+	}
+	vx->last_steal = run_delay;
+
+	vx->runstate_times[vx->current_runstate] += delta_ns;
+	vx->current_runstate = state;
+	vx->runstate_entry_time = now;
+}
+
+void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
+{
+	struct kvm_vcpu_xen *vx = &v->arch.xen;
+	uint64_t state_entry_time;
+	unsigned int offset;
+
+	kvm_xen_update_runstate(v, state);
+
+	if (!vx->runstate_set)
+		return;
+
+	BUILD_BUG_ON(sizeof(struct compat_vcpu_runstate_info) != 0x2c);
+
+	offset = offsetof(struct compat_vcpu_runstate_info, state_entry_time);
+#ifdef CONFIG_X86_64
+	/*
+	 * The only difference is alignment of uint64_t in 32-bit.
+	 * So the first field 'state' is accessed directly using
+	 * offsetof() (where its offset happens to be zero), while the
+	 * remaining fields which are all uint64_t, start at 'offset'
+	 * which we tweak here by adding 4.
+	 */
+	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state_entry_time) !=
+		     offsetof(struct compat_vcpu_runstate_info, state_entry_time) + 4);
+	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, time) !=
+		     offsetof(struct compat_vcpu_runstate_info, time) + 4);
+
+	if (v->kvm->arch.xen.long_mode)
+		offset = offsetof(struct vcpu_runstate_info, state_entry_time);
+#endif
+	/*
+	 * First write the updated state_entry_time at the appropriate
+	 * location determined by 'offset'.
+	 */
+	state_entry_time = vx->runstate_entry_time;
+	state_entry_time |= XEN_RUNSTATE_UPDATE;
+
+	BUILD_BUG_ON(sizeof(((struct vcpu_runstate_info *)0)->state_entry_time) !=
+		     sizeof(state_entry_time));
+	BUILD_BUG_ON(sizeof(((struct compat_vcpu_runstate_info *)0)->state_entry_time) !=
+		     sizeof(state_entry_time));
+
+	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
+					  &state_entry_time, offset,
+					  sizeof(state_entry_time)))
+		return;
+	smp_wmb();
+
+	/*
+	 * Next, write the new runstate. This is in the *same* place
+	 * for 32-bit and 64-bit guests, asserted here for paranoia.
+	 */
+	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state) !=
+		     offsetof(struct compat_vcpu_runstate_info, state));
+	BUILD_BUG_ON(sizeof(((struct vcpu_runstate_info *)0)->state) !=
+		     sizeof(vx->current_runstate));
+	BUILD_BUG_ON(sizeof(((struct compat_vcpu_runstate_info *)0)->state) !=
+		     sizeof(vx->current_runstate));
+
+	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
+					  &vx->current_runstate,
+					  offsetof(struct vcpu_runstate_info, state),
+					  sizeof(vx->current_runstate)))
+		return;
+
+	/*
+	 * Write the actual runstate times immediately after the
+	 * runstate_entry_time.
+	 */
+	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state_entry_time) !=
+		     offsetof(struct vcpu_runstate_info, time) - sizeof(u64));
+	BUILD_BUG_ON(offsetof(struct compat_vcpu_runstate_info, state_entry_time) !=
+		     offsetof(struct compat_vcpu_runstate_info, time) - sizeof(u64));
+	BUILD_BUG_ON(sizeof(((struct vcpu_runstate_info *)0)->time) !=
+		     sizeof(((struct compat_vcpu_runstate_info *)0)->time));
+	BUILD_BUG_ON(sizeof(((struct vcpu_runstate_info *)0)->time) !=
+		     sizeof(vx->runstate_times));
+
+	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
+					  &vx->runstate_times[0],
+					  offset + sizeof(u64),
+					  sizeof(vx->runstate_times)))
+		return;
+
+	smp_wmb();
+
+	/*
+	 * Finally, clear the XEN_RUNSTATE_UPDATE bit in the guest's
+	 * runstate_entry_time field.
+	 */
+
+	state_entry_time &= ~XEN_RUNSTATE_UPDATE;
+	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
+					  &state_entry_time, offset,
+					  sizeof(state_entry_time)))
+		return;
+}
+
 int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 {
 	u8 rc = 0;
@@ -223,6 +351,121 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 		}
 		break;
 
+	case KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR:
+		if (!sched_info_on()) {
+			r = -EOPNOTSUPP;
+			break;
+		}
+		if (data->u.gpa == GPA_INVALID) {
+			vcpu->arch.xen.runstate_set = false;
+			r = 0;
+			break;
+		}
+
+		r = kvm_gfn_to_hva_cache_init(vcpu->kvm,
+					      &vcpu->arch.xen.runstate_cache,
+					      data->u.gpa,
+					      sizeof(struct vcpu_runstate_info));
+		if (!r) {
+			vcpu->arch.xen.runstate_set = true;
+		}
+		break;
+
+	case KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT:
+		if (!sched_info_on()) {
+			r = -EOPNOTSUPP;
+			break;
+		}
+		if (data->u.runstate.state > RUNSTATE_offline) {
+			r = -EINVAL;
+			break;
+		}
+
+		kvm_xen_update_runstate(vcpu, data->u.runstate.state);
+		r = 0;
+		break;
+
+	case KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_DATA:
+		if (!sched_info_on()) {
+			r = -EOPNOTSUPP;
+			break;
+		}
+		if (data->u.runstate.state > RUNSTATE_offline) {
+			r = -EINVAL;
+			break;
+		}
+		if (data->u.runstate.state_entry_time !=
+		    (data->u.runstate.time_running +
+		     data->u.runstate.time_runnable +
+		     data->u.runstate.time_blocked +
+		     data->u.runstate.time_offline)) {
+			r = -EINVAL;
+			break;
+		}
+		if (get_kvmclock_ns(vcpu->kvm) <
+		    data->u.runstate.state_entry_time) {
+			r = -EINVAL;
+			break;
+		}
+
+		vcpu->arch.xen.current_runstate = data->u.runstate.state;
+		vcpu->arch.xen.runstate_entry_time =
+			data->u.runstate.state_entry_time;
+		vcpu->arch.xen.runstate_times[RUNSTATE_running] =
+			data->u.runstate.time_running;
+		vcpu->arch.xen.runstate_times[RUNSTATE_runnable] =
+			data->u.runstate.time_runnable;
+		vcpu->arch.xen.runstate_times[RUNSTATE_blocked] =
+			data->u.runstate.time_blocked;
+		vcpu->arch.xen.runstate_times[RUNSTATE_offline] =
+			data->u.runstate.time_offline;
+		vcpu->arch.xen.last_steal = current->sched_info.run_delay;
+		r = 0;
+		break;
+
+	case KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST:
+		if (!sched_info_on()) {
+			r = -EOPNOTSUPP;
+			break;
+		}
+		if (data->u.runstate.state > RUNSTATE_offline &&
+		    data->u.runstate.state != (u64)-1) {
+			r = -EINVAL;
+			break;
+		}
+		/* The adjustment must add up */
+		if (data->u.runstate.state_entry_time !=
+		    (data->u.runstate.time_running +
+		     data->u.runstate.time_runnable +
+		     data->u.runstate.time_blocked +
+		     data->u.runstate.time_offline)) {
+			r = -EINVAL;
+			break;
+		}
+
+		if (get_kvmclock_ns(vcpu->kvm) <
+		    (vcpu->arch.xen.runstate_entry_time +
+		     data->u.runstate.state_entry_time)) {
+			r = -EINVAL;
+			break;
+		}
+
+		vcpu->arch.xen.runstate_entry_time +=
+			data->u.runstate.state_entry_time;
+		vcpu->arch.xen.runstate_times[RUNSTATE_running] +=
+			data->u.runstate.time_running;
+		vcpu->arch.xen.runstate_times[RUNSTATE_runnable] +=
+			data->u.runstate.time_runnable;
+		vcpu->arch.xen.runstate_times[RUNSTATE_blocked] +=
+			data->u.runstate.time_blocked;
+		vcpu->arch.xen.runstate_times[RUNSTATE_offline] +=
+			data->u.runstate.time_offline;
+
+		if (data->u.runstate.state <= RUNSTATE_offline)
+			kvm_xen_update_runstate(vcpu, data->u.runstate.state);
+		r = 0;
+		break;
+
 	default:
 		break;
 	}
@@ -255,6 +498,49 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 		r = 0;
 		break;
 
+	case KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR:
+		if (!sched_info_on()) {
+			r = -EOPNOTSUPP;
+			break;
+		}
+		if (vcpu->arch.xen.runstate_set) {
+			data->u.gpa = vcpu->arch.xen.runstate_cache.gpa;
+			r = 0;
+		}
+		break;
+
+	case KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT:
+		if (!sched_info_on()) {
+			r = -EOPNOTSUPP;
+			break;
+		}
+		data->u.runstate.state = vcpu->arch.xen.current_runstate;
+		r = 0;
+		break;
+
+	case KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_DATA:
+		if (!sched_info_on()) {
+			r = -EOPNOTSUPP;
+			break;
+		}
+		data->u.runstate.state = vcpu->arch.xen.current_runstate;
+		data->u.runstate.state_entry_time =
+			vcpu->arch.xen.runstate_entry_time;
+		data->u.runstate.time_running =
+			vcpu->arch.xen.runstate_times[RUNSTATE_running];
+		data->u.runstate.time_runnable =
+			vcpu->arch.xen.runstate_times[RUNSTATE_runnable];
+		data->u.runstate.time_blocked =
+			vcpu->arch.xen.runstate_times[RUNSTATE_blocked];
+		data->u.runstate.time_offline =
+			vcpu->arch.xen.runstate_times[RUNSTATE_offline];
+		r = 0;
+		break;
+
+	case KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST:
+		r = -EINVAL;
+		break;
+
 	default:
 		break;
 	}
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index 87eaf2be9549..463a7844a8ca 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -23,6 +23,12 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data);
 int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc);
 void kvm_xen_destroy_vm(struct kvm *kvm);
 
+static inline bool kvm_xen_msr_enabled(struct kvm *kvm)
+{
+	return static_branch_unlikely(&kvm_xen_enabled.key) &&
+		kvm->arch.xen_hvm_config.msr;
+}
+
 static inline bool kvm_xen_hypercall_enabled(struct kvm *kvm)
 {
 	return static_branch_unlikely(&kvm_xen_enabled.key) &&
@@ -48,6 +54,11 @@ static inline void kvm_xen_destroy_vm(struct kvm *kvm)
 {
 }
 
+static inline bool kvm_xen_msr_enabled(struct kvm *kvm)
+{
+	return false;
+}
+
 static inline bool kvm_xen_hypercall_enabled(struct kvm *kvm)
 {
 	return false;
@@ -61,10 +72,31 @@ static inline int kvm_xen_has_interrupt(struct kvm_vcpu *vcpu)
 
 int kvm_xen_hypercall(struct kvm_vcpu *vcpu);
 
-/* 32-bit compatibility definitions, also used natively in 32-bit build */
 #include <asm/pvclock-abi.h>
 #include <asm/xen/interface.h>
+#include <xen/interface/vcpu.h>
 
+void kvm_xen_update_runstate_guest(struct kvm_vcpu *vcpu, int state);
+
+static inline void kvm_xen_runstate_set_running(struct kvm_vcpu *vcpu)
+{
+	kvm_xen_update_runstate_guest(vcpu, RUNSTATE_running);
+}
+
+static inline void kvm_xen_runstate_set_preempted(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * If the vCPU wasn't preempted but took a normal exit for
+	 * some reason (hypercalls, I/O, etc.), that is accounted as
+	 * still RUNSTATE_running, as the VMM is still operating on
+	 * behalf of the vCPU. Only if the VMM does actually block
+	 * does it need to enter RUNSTATE_blocked.
+	 */
+	if (vcpu->preempted)
+		kvm_xen_update_runstate_guest(vcpu, RUNSTATE_runnable);
+}
+
+/* 32-bit compatibility definitions, also used natively in 32-bit build */
 struct compat_arch_vcpu_info {
 	unsigned int cr2;
 	unsigned int pad[5];
@@ -97,4 +129,10 @@ struct compat_shared_info {
 	struct compat_arch_shared_info arch;
 };
 
+struct compat_vcpu_runstate_info {
+    int state;
+    uint64_t state_entry_time;
+    uint64_t time[4];
+} __attribute__((packed));
+
 #endif /* __ARCH_X86_KVM_XEN_H__ */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 8b281f722e5b..f6afee209620 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1154,6 +1154,7 @@ struct kvm_x86_mce {
 #define KVM_XEN_HVM_CONFIG_HYPERCALL_MSR	(1 << 0)
 #define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
 #define KVM_XEN_HVM_CONFIG_SHARED_INFO		(1 << 2)
+#define KVM_XEN_HVM_CONFIG_RUNSTATE		(1 << 3)
 
 struct kvm_xen_hvm_config {
 	__u32 flags;
@@ -1621,12 +1622,24 @@ struct kvm_xen_vcpu_attr {
 	union {
 		__u64 gpa;
 		__u64 pad[8];
+		struct {
+			__u64 state;
+			__u64 state_entry_time;
+			__u64 time_running;
+			__u64 time_runnable;
+			__u64 time_blocked;
+			__u64 time_offline;
+		} runstate;
 	} u;
 };
 
 /* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO */
 #define KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO	0x0
 #define KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO	0x1
+#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR	0x2
+#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT	0x3
+#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_DATA	0x4
+#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST	0x5
 
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 9246ea310587..804ff5ff022d 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -13,19 +13,27 @@
 
 #include <stdint.h>
 #include <time.h>
+#include <sched.h>
+#include <sys/syscall.h>
 
 #define VCPU_ID		5
 
+#define SHINFO_REGION_GVA	0xc0000000ULL
 #define SHINFO_REGION_GPA	0xc0000000ULL
 #define SHINFO_REGION_SLOT	10
 #define PAGE_SIZE		4096
 
 #define PVTIME_ADDR	(SHINFO_REGION_GPA + PAGE_SIZE)
+#define RUNSTATE_ADDR	(SHINFO_REGION_GPA + PAGE_SIZE + 0x20)
+
+#define RUNSTATE_VADDR	(SHINFO_REGION_GVA + PAGE_SIZE + 0x20)
 
 static struct kvm_vm *vm;
 
 #define XEN_HYPERCALL_MSR	0x40000000
 
+#define MIN_STEAL_TIME		50000
+
 struct pvclock_vcpu_time_info {
         u32   version;
         u32   pad0;
@@ -43,11 +51,67 @@ struct pvclock_wall_clock {
         u32   nsec;
 } __attribute__((__packed__));
 
+struct vcpu_runstate_info {
+    uint32_t state;
+    uint64_t state_entry_time;
+    uint64_t time[4];
+};
+
+#define RUNSTATE_running  0
+#define RUNSTATE_runnable 1
+#define RUNSTATE_blocked  2
+#define RUNSTATE_offline  3
+
 static void guest_code(void)
 {
+	struct vcpu_runstate_info *rs = (void *)RUNSTATE_VADDR;
+
+	/* Test having the host set runstates manually */
+	GUEST_SYNC(RUNSTATE_runnable);
+	GUEST_ASSERT(rs->time[RUNSTATE_runnable] != 0);
+	GUEST_ASSERT(rs->state == 0);
+
+	GUEST_SYNC(RUNSTATE_blocked);
+	GUEST_ASSERT(rs->time[RUNSTATE_blocked] != 0);
+	GUEST_ASSERT(rs->state == 0);
+
+	GUEST_SYNC(RUNSTATE_offline);
+	GUEST_ASSERT(rs->time[RUNSTATE_offline] != 0);
+	GUEST_ASSERT(rs->state == 0);
+
+	/* Test runstate time adjust */
+	GUEST_SYNC(4);
+	GUEST_ASSERT(rs->time[RUNSTATE_blocked] == 0x5a);
+	GUEST_ASSERT(rs->time[RUNSTATE_offline] == 0x6b6b);
+
+	/* Test runstate time set */
+	GUEST_SYNC(5);
+	GUEST_ASSERT(rs->state_entry_time >= 0x8000);
+	GUEST_ASSERT(rs->time[RUNSTATE_runnable] == 0);
+	GUEST_ASSERT(rs->time[RUNSTATE_blocked] == 0x6b6b);
+	GUEST_ASSERT(rs->time[RUNSTATE_offline] == 0x5a);
+
+	/* sched_yield() should result in some 'runnable' time */
+	GUEST_SYNC(6);
+	GUEST_ASSERT(rs->time[RUNSTATE_runnable] >= MIN_STEAL_TIME);
+
 	GUEST_DONE();
 }
 
+static long get_run_delay(void)
+{
+        char path[64];
+        long val[2];
+        FILE *fp;
+
+        sprintf(path, "/proc/%ld/schedstat", syscall(SYS_gettid));
+        fp = fopen(path, "r");
+        fscanf(fp, "%ld %ld ", &val[0], &val[1]);
+        fclose(fp);
+
+        return val[1];
+}
+
 static int cmp_timespec(struct timespec *a, struct timespec *b)
 {
 	if (a->tv_sec > b->tv_sec)
@@ -66,12 +130,14 @@ int main(int argc, char *argv[])
 {
 	struct timespec min_ts, max_ts, vm_ts;
 
-	if (!(kvm_check_cap(KVM_CAP_XEN_HVM) &
-	      KVM_XEN_HVM_CONFIG_SHARED_INFO) ) {
+	int xen_caps = kvm_check_cap(KVM_CAP_XEN_HVM);
+	if (!(xen_caps & KVM_XEN_HVM_CONFIG_SHARED_INFO) ) {
 		print_skip("KVM_XEN_HVM_CONFIG_SHARED_INFO not available");
 		exit(KSFT_SKIP);
 	}
 
+	bool do_runstate_tests = !!(xen_caps & KVM_XEN_HVM_CONFIG_RUNSTATE);
+
 	clock_gettime(CLOCK_REALTIME, &min_ts);
 
 	vm = vm_create_default(VCPU_ID, 0, (void *) guest_code);
@@ -80,6 +146,7 @@ int main(int argc, char *argv[])
 	/* Map a region for the shared_info page */
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
 				    SHINFO_REGION_GPA, SHINFO_REGION_SLOT, 2, 0);
+	virt_map(vm, SHINFO_REGION_GVA, SHINFO_REGION_GPA, 2, 0);
 
 	struct kvm_xen_hvm_config hvmc = {
 		.flags = KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL,
@@ -111,6 +178,17 @@ int main(int argc, char *argv[])
 	};
 	vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &pvclock);
 
+	if (do_runstate_tests) {
+		struct kvm_xen_vcpu_attr st = {
+			.type = KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR,
+			.u.gpa = RUNSTATE_ADDR,
+		};
+		vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &st);
+	}
+
+	struct vcpu_runstate_info *rs = addr_gpa2hva(vm, RUNSTATE_ADDR);;
+	rs->state = 0x5a;
+
 	for (;;) {
 		volatile struct kvm_run *run = vcpu_state(vm, VCPU_ID);
 		struct ucall uc;
@@ -126,8 +204,56 @@ int main(int argc, char *argv[])
 		case UCALL_ABORT:
 			TEST_FAIL("%s", (const char *)uc.args[0]);
 			/* NOT REACHED */
-		case UCALL_SYNC:
+		case UCALL_SYNC: {
+			struct kvm_xen_vcpu_attr rst;
+			long rundelay;
+
+			/* If no runstate support, bail out early */
+			if (!do_runstate_tests)
+				goto done;
+
+			TEST_ASSERT(rs->state_entry_time == rs->time[0] +
+				    rs->time[1] + rs->time[2] + rs->time[3],
+				    "runstate times don't add up");
+
+			switch (uc.args[1]) {
+			case RUNSTATE_running...RUNSTATE_offline:
+				rst.type = KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT;
+				rst.u.runstate.state = uc.args[1];
+				vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &rst);
+				break;
+			case 4:
+				rst.type = KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST;
+				memset(&rst.u, 0, sizeof(rst.u));
+				rst.u.runstate.state = (uint64_t)-1;
+				rst.u.runstate.time_blocked =
+					0x5a - rs->time[RUNSTATE_blocked];
+				rst.u.runstate.time_offline =
+					0x6b6b - rs->time[RUNSTATE_offline];
+				rst.u.runstate.time_runnable = -rst.u.runstate.time_blocked -
+					rst.u.runstate.time_offline;
+				vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &rst);
+				break;
+
+			case 5:
+				rst.type = KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_DATA;
+				memset(&rst.u, 0, sizeof(rst.u));
+				rst.u.runstate.state = RUNSTATE_running;
+				rst.u.runstate.state_entry_time = 0x6b6b + 0x5a;
+				rst.u.runstate.time_blocked = 0x6b6b;
+				rst.u.runstate.time_offline = 0x5a;
+				vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &rst);
+				break;
+			case 6:
+				/* Yield until scheduler delay exceeds target */
+				rundelay = get_run_delay() + MIN_STEAL_TIME;
+				do {
+					sched_yield();
+				} while (get_run_delay() < rundelay);
+				break;
+			}
 			break;
+		}
 		case UCALL_DONE:
 			goto done;
 		default:
@@ -162,6 +288,33 @@ int main(int argc, char *argv[])
 	TEST_ASSERT(ti2->version && !(ti2->version & 1),
 		    "Bad time_info version %x", ti->version);
 
+	if (do_runstate_tests) {
+		/*
+		 * Fetch runstate and check sanity. Strictly speaking in the
+		 * general case we might not expect the numbers to be identical
+		 * but in this case we know we aren't running the vCPU any more.
+		 */
+		struct kvm_xen_vcpu_attr rst = {
+			.type = KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_DATA,
+		};
+		vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_GET_ATTR, &rst);
+
+		TEST_ASSERT(rs->state == rst.u.runstate.state, "Runstate mismatch");
+		TEST_ASSERT(rs->state_entry_time == rst.u.runstate.state_entry_time,
+			    "State entry time mismatch");
+		TEST_ASSERT(rs->time[RUNSTATE_running] == rst.u.runstate.time_running,
+			    "Running time mismatch");
+		TEST_ASSERT(rs->time[RUNSTATE_runnable] == rst.u.runstate.time_runnable,
+			    "Runnable time mismatch");
+		TEST_ASSERT(rs->time[RUNSTATE_blocked] == rst.u.runstate.time_blocked,
+			    "Blocked time mismatch");
+		TEST_ASSERT(rs->time[RUNSTATE_offline] == rst.u.runstate.time_offline,
+			    "Offline time mismatch");
+
+		TEST_ASSERT(rs->state_entry_time == rs->time[0] +
+			    rs->time[1] + rs->time[2] + rs->time[3],
+			    "runstate times don't add up");
+	}
 	kvm_vm_free(vm);
 	return 0;
 }
-- 
2.29.2

