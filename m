Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC15331F2D9
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 00:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbhBRXQW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 18:16:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhBRXQV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Feb 2021 18:16:21 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90EE2C061756
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 15:15:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Mime-Version:Content-Type:Date:Cc:To:
        From:Subject:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=1Be2OzYRrkywtYCJqK8QLh5Hp8puKVNYn0l6yjWD/Fk=; b=WDy8WrsGIFjuE5d8+ul8uHSddT
        7LaY8eO/dg/fTz8bTaDJVYsRBYUQRzVfoqPxchsOqMY5RAVijb2LXGSW1otgGHHtH4ly19qkiGTAq
        p1daXMgu/eYoKV+bdK5oXgQoIy48uk7Jnc1X+Z/WmgXV6WHx2m5ZJ8CgH4hBbHSwjQs+yCVuMag2l
        ZJHdx1+ArBKDyCmVAP+1ykpFI96acA/1LbgnKFX2hYrkjatV2Uv7IxFEawIP6nD9v9v6mGSUur70R
        G28A3hPVdAQas0twgqHj49ZL3CrO81Rf1Xb9/EMOeAer63duHbSll2dG4VHbaTyBd4evts7fji8iw
        221TA5qQ==;
Received: from 54-240-197-226.amazon.com ([54.240.197.226] helo=freeip.amazon.com)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1lCsWE-0007qb-3q; Thu, 18 Feb 2021 23:15:34 +0000
Message-ID: <bcb49b8c51576aa3373004612d9a410df1160bb6.camel@infradead.org>
Subject: [RFC] KVM: x86/xen: Add support for vCPU runstate information
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org, peterz@infradead.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
Date:   Thu, 18 Feb 2021 23:15:31 +0000
Content-Type: multipart/signed; micalg="sha-256";
        protocol="application/x-pkcs7-signature";
        boundary="=-kUf5zhF3wCZRCOfRawY3"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-kUf5zhF3wCZRCOfRawY3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: David Woodhouse <dwmw@amazon.co.uk>

This is how Xen guests do steal time accounting. The hypervisor records
the amount of time spent in each of running/runnable/blocked/offline
states.

In the Xen accounting, a vCPU is still in state RUNSTATE_running while
in Xen for a hypercall or I/O trap, etc. Only if Xen explicitly schedules
does the state become RUNSTATE_blocked. In KVM this means that even when
the vCPU exits the kvm_run loop, the state remains RUNSTATE_running.

The VMM can explicitly set the vCPU to RUNSTATE_blocked by using the
KVM_XEN_VCPU_ATTR_TYPE_VCPU_RUNSTATE_CURRENT attribute, and can also
use KVM_XEN_VCPU_ATTR_TYPE_VCPU_RUNSTATE_ADJUST to retrospectively
add a given amount of time to the blocked state and subtract it from
the running state.

Co-developed-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---

This reinstates the runstate support I dropped from the 5.12 merge
because I said it needed more thought.

It now maintains the runstate info for a Xen-enabled guest at all
times, keeping track of it on the kernel side and no longer only in the
guest's memory.

This means the VMM can support the VCPUOP_get_runstate_info hypercall
which just returns the data, even when not automatically updating it in
guest memory.

As in Joao's original version, it doesn't ever automatically set the
RUNSTATE_blocked state; it leaves that for the VMM to do explicitly
(and I suppose we'll do it in-kernel when we support SCHEDOP_poll and
event channel acceleration, although the original patches didn't).

However, my version does leave the vCPU in RUNSTATE_running when
exiting to the VMM, to match Xen's behaviour.

I wonder if there's a way to use current->se.sum_exec_runtime to infer
the time spent in RUNSTATE_blocked? Given a wall clock delta T, a
se.sum_exec_time delta R and a sched_info.run_delta S, the runstate
accounting ought to be something like
   times[RUNSTATE_running] +=3D R;
   times[RUNSTATE_runnable] +=3D S;
   times[RUNSTATE_blocked] +=3D T - R - S;
... or something like that? Should that relatively sanely capture the
time spent even when the VMM is sleeping in TASK_{UN,}INTERRUPTIBLE as
RUNSTATE_blocked? Let's add PeterZ to Cc so he can shout at me for
being stupid...

The other thing I'm not quite sure about: In Xen there is an alleged
guarantee that the total time spent in the four runstates shall add up
to the same as the lifetime of the domain. I haven't actually worked
out where the latter total is exposed to the guest, and how to ensure
we meet that guarantee.

 Documentation/virt/kvm/api.rst                |  35 +++
 arch/x86/include/asm/kvm_host.h               |   7 +
 arch/x86/kvm/x86.c                            |  13 +-
 arch/x86/kvm/xen.c                            | 254 ++++++++++++++++++
 arch/x86/kvm/xen.h                            |  35 ++-
 include/uapi/linux/kvm.h                      |  17 +-
 .../selftests/kvm/x86_64/xen_shinfo_test.c    | 150 ++++++++++-
 7 files changed, 504 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rs=
t
index 45fd862ac128..02b40a3e4fb8 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4913,6 +4913,14 @@ see KVM_XEN_HVM_SET_ATTR above.
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
=20
@@ -4925,6 +4933,25 @@ KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO
   Sets the guest physical address of an additional pvclock structure
   for a given vCPU. This is typically used for guest vsyscall support.
=20
+KVM_XEN_VCPU_ATTR_TYPE_VCPU_RUNSTATE_ADDR
+  Sets the guest physical address of the vcpu_runstate_info for a given
+  vCPU. This is how a Xen guest tracks CPU state such as steal time.
+
+KVM_XEN_VCPU_ATTR_TYPE_VCPU_RUNSTATE_CURRENT
+  Sets the runstate (RUNSTATE_running/_runnable/_blocked/_offline) of
+  the given vCPU from the .u.runstate.state member of the structure.
+  KVM automatically accounts running and runnable time but blocked
+  and offline states are only entered explicitly.
+
+KVM_XEN_VCPU_ATTR_TYPE_VCPU_RUNSTATE_DATA
+  Sets all fields of the vCPU runstate data from the .u.runstate member
+  of the structure, including the current runstate.
+
+KVM_XEN_VCPU_ATTR_TYPE_VCPU_RUNSTATE_ADJUST
+  This *adds* the contents of the .u.runstate members of the structure
+  to the corresponding members of the given vCPU's runstate data, thus
+  permitting atomic adjustments to the runstate times.
+
 4.130 KVM_XEN_VCPU_GET_ATTR
 ---------------------------
=20
@@ -4937,6 +4964,9 @@ KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO
 Allows Xen vCPU attributes to be read. For the structure and types,
 see KVM_XEN_VCPU_SET_ATTR above.
=20
+The KVM_XEN_VCPU_ATTR_TYPE_VCPU_RUNSTATE_ADJUST type may not be used
+with the KVM_XEN_VCPU_GET_ATTR ioctl.
+
 5. The kvm_run structure
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
@@ -6700,6 +6730,7 @@ PVHVM guests. Valid flags are::
   #define KVM_XEN_HVM_CONFIG_HYPERCALL_MSR	(1 << 0)
   #define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
   #define KVM_XEN_HVM_CONFIG_SHARED_INFO	(1 << 2)
+  #define KVM_XEN_HVM_CONFIG_RUNSTATE		(1 << 2)
=20
 The KVM_XEN_HVM_CONFIG_HYPERCALL_MSR flag indicates that the KVM_XEN_HVM_C=
ONFIG
 ioctl is available, for the guest to set its hypercall page.
@@ -6714,3 +6745,7 @@ KVM_XEN_HVM_SET_ATTR, KVM_XEN_HVM_GET_ATTR, KVM_XEN_V=
CPU_SET_ATTR and
 KVM_XEN_VCPU_GET_ATTR ioctls, as well as the delivery of exception vectors
 for event channel upcalls when the evtchn_upcall_pending field of a vcpu's
 vcpu_info is set.
+
+The KVM_XEN_HVM_CONFIG_RUNSTATE flag indicates that the runstate-related
+features KVM_XEN_VCPU_ATTR_TYPE_VCPU_RUNSTATE_ADDR/_CURRENT/_DATA/_ADJUST
+are supported by the KVM_XEN_VCPU_SET_ATTR/KVM_XEN_VCPU_GET_ATTR ioctls.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 84499aad01a4..2f69e90a5493 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -533,10 +533,17 @@ struct kvm_vcpu_hv {
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
+	u64 runstate_entry_time;
+	u64 runstate_times[4];
 };
=20
 struct kvm_vcpu_arch {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3fa140383f5d..f5826dd074dd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2956,6 +2956,11 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	struct kvm_host_map map;
 	struct kvm_steal_time *st;
=20
+	if (kvm_xen_msr_enabled(vcpu->kvm)) {
+		kvm_xen_runstate_set_running(vcpu);
+		return;
+	}
+
 	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
 		return;
=20
@@ -3759,6 +3764,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, lon=
g ext)
 		r =3D KVM_XEN_HVM_CONFIG_HYPERCALL_MSR |
 		    KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL |
 		    KVM_XEN_HVM_CONFIG_SHARED_INFO;
+		if (sched_info_on())
+			r |=3D KVM_XEN_HVM_CONFIG_RUNSTATE;
 		break;
 	case KVM_CAP_SYNC_REGS:
 		r =3D KVM_SYNC_X86_VALID_FIELDS;
@@ -4037,7 +4044,11 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	if (vcpu->preempted && !vcpu->arch.guest_state_protected)
 		vcpu->arch.preempted_in_kernel =3D !static_call(kvm_x86_get_cpl)(vcpu);
=20
-	kvm_steal_time_set_preempted(vcpu);
+	if (kvm_xen_msr_enabled(vcpu->kvm))
+		kvm_xen_runstate_set_preempted(vcpu);
+	else
+		kvm_steal_time_set_preempted(vcpu);
+
 	static_call(kvm_x86_vcpu_put)(vcpu);
 	vcpu->arch.last_host_tsc =3D rdtsc();
 	/*
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index af8f6562fce4..96e7cacd0cc9 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -11,9 +11,11 @@
 #include "hyperv.h"
=20
 #include <linux/kvm_host.h>
+#include <linux/sched/stat.h>
=20
 #include <trace/events/kvm.h>
 #include <xen/interface/xen.h>
+#include <xen/interface/vcpu.h>
=20
 #include "trace.h"
=20
@@ -61,6 +63,137 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gf=
n_t gfn)
 	return ret;
 }
=20
+static void kvm_xen_update_runstate(struct kvm_vcpu *v, int state)
+{
+	struct kvm_vcpu_xen *vx =3D &v->arch.xen;
+	u64 now =3D ktime_get_ns();
+	u64 delta_ns =3D now - vx->last_state_ns;
+	u64 run_delay =3D current->sched_info.run_delay;
+
+	if (unlikely(!vx->last_state_ns)) {
+		vx->current_runstate =3D RUNSTATE_offline;
+		delta_ns =3D 0;
+	}
+
+	/*
+	 * Time waiting for the scheduler isn't "stolen" if the
+	 * vCPU wasn't running anyway.
+	 */
+	if (vx->current_runstate =3D=3D RUNSTATE_running) {
+		u64 steal_ns =3D run_delay - vx->last_steal;
+
+		delta_ns -=3D steal_ns;
+
+		vx->runstate_times[RUNSTATE_runnable] +=3D steal_ns;
+	}
+	vx->last_steal =3D run_delay;
+
+	vx->runstate_times[vx->current_runstate] +=3D delta_ns;
+	vx->current_runstate =3D state;
+	vx->last_state_ns =3D now;
+}
+
+void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
+{
+	struct kvm_vcpu_xen *vx =3D &v->arch.xen;
+	uint64_t state_entry_time;
+	unsigned int offset;
+
+	kvm_xen_update_runstate(v, state);
+
+	if (!vx->runstate_set)
+		return;
+
+	BUILD_BUG_ON(sizeof(struct compat_vcpu_runstate_info) !=3D 0x2c);
+
+	offset =3D offsetof(struct compat_vcpu_runstate_info, state_entry_time);
+#ifdef CONFIG_X86_64
+	/*
+	 * The only difference is alignment of uint64_t in 32-bit.
+	 * So the first field 'state' is accessed via *runstate_state
+	 * which is unmodified, while the other fields are accessed
+	 * through 'runstate->' which we tweak here by adding 4.
+	 */
+	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state_entry_time) !=3D
+		     offsetof(struct compat_vcpu_runstate_info, state_entry_time) + 4);
+	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, time) !=3D
+		     offsetof(struct compat_vcpu_runstate_info, time) + 4);
+
+	if (v->kvm->arch.xen.long_mode)
+		offset =3D offsetof(struct vcpu_runstate_info, state_entry_time);
+#endif
+	/*
+	 * First write the updated state_entry_time at the appropriate
+	 * location determined by 'offset'.
+	 *
+	 * Although it's called "state_entry_time" and explicitly documented
+	 * as being "the system time at which the VCPU was last scheduled to
+	 * run", Xen just treats it as a counter for HVM domains, like this.
+	 */
+	state_entry_time =3D ++vx->runstate_entry_time;
+	state_entry_time |=3D XEN_RUNSTATE_UPDATE;
+
+	BUILD_BUG_ON(sizeof(((struct vcpu_runstate_info *)0)->state_entry_time) !=
=3D
+		     sizeof(state_entry_time));
+	BUILD_BUG_ON(sizeof(((struct compat_vcpu_runstate_info *)0)->state_entry_=
time) !=3D
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
+	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state) !=3D
+		     offsetof(struct compat_vcpu_runstate_info, state));
+	BUILD_BUG_ON(sizeof(((struct vcpu_runstate_info *)0)->state) !=3D
+		     sizeof(vx->current_runstate));
+	BUILD_BUG_ON(sizeof(((struct compat_vcpu_runstate_info *)0)->state) !=3D
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
+	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state_entry_time) !=3D
+		     offsetof(struct vcpu_runstate_info, time) - sizeof(u64));
+	BUILD_BUG_ON(offsetof(struct compat_vcpu_runstate_info, state_entry_time)=
 !=3D
+		     offsetof(struct compat_vcpu_runstate_info, time) - sizeof(u64));
+	BUILD_BUG_ON(sizeof(((struct vcpu_runstate_info *)0)->time) !=3D
+		     sizeof(((struct compat_vcpu_runstate_info *)0)->time));
+	BUILD_BUG_ON(sizeof(((struct vcpu_runstate_info *)0)->time) !=3D
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
+	state_entry_time &=3D ~XEN_RUNSTATE_UPDATE;
+	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
+					  &state_entry_time, offset,
+					  sizeof(state_entry_time)))
+		return;
+}
+
 int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 {
 	u8 rc =3D 0;
@@ -219,6 +352,84 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struc=
t kvm_xen_vcpu_attr *data)
 		}
 		break;
=20
+	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_RUNSTATE_ADDR:
+		if (!sched_info_on()) {
+			r =3D -EOPNOTSUPP;
+			break;
+		}
+		r =3D kvm_gfn_to_hva_cache_init(vcpu->kvm,
+					      &vcpu->arch.xen.runstate_cache,
+					      data->u.gpa,
+					      sizeof(struct vcpu_runstate_info));
+		if (!r) {
+			vcpu->arch.xen.runstate_set =3D true;
+		}
+		break;
+
+	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_RUNSTATE_CURRENT:
+		if (!sched_info_on()) {
+			r =3D -EOPNOTSUPP;
+			break;
+		}
+		if (data->u.runstate.state > RUNSTATE_offline) {
+			r =3D -EINVAL;
+			break;
+		}
+		kvm_xen_update_runstate(vcpu, data->u.runstate.state);
+		r =3D 0;
+		break;
+
+	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_RUNSTATE_DATA:
+		if (!sched_info_on()) {
+			r =3D -EOPNOTSUPP;
+			break;
+		}
+		if (data->u.runstate.state > RUNSTATE_offline) {
+			r =3D -EINVAL;
+			break;
+		}
+		vcpu->arch.xen.current_runstate =3D data->u.runstate.state;
+		vcpu->arch.xen.runstate_entry_time =3D
+			data->u.runstate.state_entry_time;
+		vcpu->arch.xen.runstate_times[RUNSTATE_running] =3D
+			data->u.runstate.time_running;
+		vcpu->arch.xen.runstate_times[RUNSTATE_runnable] =3D
+			data->u.runstate.time_runnable;
+		vcpu->arch.xen.runstate_times[RUNSTATE_blocked] =3D
+			data->u.runstate.time_blocked;
+		vcpu->arch.xen.runstate_times[RUNSTATE_offline] =3D
+			data->u.runstate.time_offline;
+		vcpu->arch.xen.last_state_ns =3D ktime_get_ns();
+		vcpu->arch.xen.last_steal =3D current->sched_info.run_delay;
+		r =3D 0;
+		break;
+
+	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_RUNSTATE_ADJUST:
+		if (!sched_info_on()) {
+			r =3D -EOPNOTSUPP;
+			break;
+		}
+		if (data->u.runstate.state > RUNSTATE_offline &&
+		    data->u.runstate.state !=3D (u64)-1) {
+			r =3D -EINVAL;
+			break;
+		}
+		vcpu->arch.xen.runstate_entry_time +=3D
+			data->u.runstate.state_entry_time;
+		vcpu->arch.xen.runstate_times[RUNSTATE_running] +=3D
+			data->u.runstate.time_running;
+		vcpu->arch.xen.runstate_times[RUNSTATE_runnable] +=3D
+			data->u.runstate.time_runnable;
+		vcpu->arch.xen.runstate_times[RUNSTATE_blocked] +=3D
+			data->u.runstate.time_blocked;
+		vcpu->arch.xen.runstate_times[RUNSTATE_offline] +=3D
+			data->u.runstate.time_offline;
+
+		if (data->u.runstate.state <=3D RUNSTATE_offline)
+			kvm_xen_update_runstate(vcpu, data->u.runstate.state);
+		r =3D 0;
+		break;
+
 	default:
 		break;
 	}
@@ -251,6 +462,49 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struc=
t kvm_xen_vcpu_attr *data)
 		r =3D 0;
 		break;
=20
+	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_RUNSTATE_ADDR:
+		if (!sched_info_on()) {
+			r =3D -EOPNOTSUPP;
+			break;
+		}
+		if (vcpu->arch.xen.runstate_set) {
+			data->u.gpa =3D vcpu->arch.xen.runstate_cache.gpa;
+			r =3D 0;
+		}
+		break;
+
+	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_RUNSTATE_CURRENT:
+		if (!sched_info_on()) {
+			r =3D -EOPNOTSUPP;
+			break;
+		}
+		data->u.runstate.state =3D vcpu->arch.xen.current_runstate;
+		r =3D 0;
+		break;
+
+	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_RUNSTATE_DATA:
+		if (!sched_info_on()) {
+			r =3D -EOPNOTSUPP;
+			break;
+		}
+		data->u.runstate.state =3D vcpu->arch.xen.current_runstate;
+		data->u.runstate.state_entry_time =3D
+			vcpu->arch.xen.runstate_entry_time;
+		data->u.runstate.time_running =3D
+			vcpu->arch.xen.runstate_times[RUNSTATE_running];
+		data->u.runstate.time_runnable =3D
+			vcpu->arch.xen.runstate_times[RUNSTATE_runnable];
+		data->u.runstate.time_blocked =3D
+			vcpu->arch.xen.runstate_times[RUNSTATE_blocked];
+		data->u.runstate.time_offline =3D
+			vcpu->arch.xen.runstate_times[RUNSTATE_offline];
+		r =3D 0;
+		break;
+
+	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_RUNSTATE_ADJUST:
+		r =3D -EINVAL;
+		break;
+
 	default:
 		break;
 	}
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index b66a921776f4..a60b14024a4f 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -23,6 +23,12 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, =
u64 data);
 int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc);
 void kvm_xen_destroy_vm(struct kvm *kvm);
=20
+static inline bool kvm_xen_msr_enabled(struct kvm *kvm)
+{
+	return static_branch_unlikely(&kvm_xen_enabled.key) &&
+		kvm->arch.xen_hvm_config.msr;
+}
+
 static inline bool kvm_xen_hypercall_enabled(struct kvm *kvm)
 {
 	return static_branch_unlikely(&kvm_xen_enabled.key) &&
@@ -39,10 +45,31 @@ static inline int kvm_xen_has_interrupt(struct kvm_vcpu=
 *vcpu)
 	return 0;
 }
=20
-/* 32-bit compatibility definitions, also used natively in 32-bit build */
 #include <asm/pvclock-abi.h>
 #include <asm/xen/interface.h>
+#include <xen/interface/vcpu.h>
+
+void kvm_xen_update_runstate_guest(struct kvm_vcpu *vcpu, int state);
+
+static inline void kvm_xen_runstate_set_running(struct kvm_vcpu *vcpu)
+{
+	kvm_xen_update_runstate_guest(vcpu, RUNSTATE_running);
+}
=20
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
@@ -75,4 +102,10 @@ struct compat_shared_info {
 	struct compat_arch_shared_info arch;
 };
=20
+struct compat_vcpu_runstate_info {
+    int state;
+    uint64_t state_entry_time;
+    uint64_t time[4];
+} __attribute__((packed));
+
 #endif /* __ARCH_X86_KVM_XEN_H__ */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 8b281f722e5b..af8a158466b3 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1154,6 +1154,7 @@ struct kvm_x86_mce {
 #define KVM_XEN_HVM_CONFIG_HYPERCALL_MSR	(1 << 0)
 #define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
 #define KVM_XEN_HVM_CONFIG_SHARED_INFO		(1 << 2)
+#define KVM_XEN_HVM_CONFIG_RUNSTATE		(1 << 3)
=20
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
=20
 /* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO */
-#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO	0x0
-#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO	0x1
+#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO		0x0
+#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO		0x1
+#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_RUNSTATE_ADDR	0x2
+#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_RUNSTATE_CURRENT	0x3
+#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_RUNSTATE_DATA	0x4
+#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_RUNSTATE_ADJUST	0x5
=20
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/t=
esting/selftests/kvm/x86_64/xen_shinfo_test.c
index 9246ea310587..a6160347136d 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -13,19 +13,27 @@
=20
 #include <stdint.h>
 #include <time.h>
+#include <sched.h>
+#include <sys/syscall.h>
=20
 #define VCPU_ID		5
=20
+#define SHINFO_REGION_GVA	0xc0000000ULL
 #define SHINFO_REGION_GPA	0xc0000000ULL
 #define SHINFO_REGION_SLOT	10
 #define PAGE_SIZE		4096
=20
 #define PVTIME_ADDR	(SHINFO_REGION_GPA + PAGE_SIZE)
+#define RUNSTATE_ADDR	(SHINFO_REGION_GPA + PAGE_SIZE + 0x20)
+
+#define RUNSTATE_VADDR	(SHINFO_REGION_GVA + PAGE_SIZE + 0x20)
=20
 static struct kvm_vm *vm;
=20
 #define XEN_HYPERCALL_MSR	0x40000000
=20
+#define MIN_STEAL_TIME		50000
+
 struct pvclock_vcpu_time_info {
         u32   version;
         u32   pad0;
@@ -43,11 +51,69 @@ struct pvclock_wall_clock {
         u32   nsec;
 } __attribute__((__packed__));
=20
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
+	struct vcpu_runstate_info *rs =3D (void *)RUNSTATE_VADDR;
+
+	rs->state =3D 0x5a;
+
+	/* Test having the host set runstates manually */
+	GUEST_SYNC(RUNSTATE_runnable);
+	GUEST_ASSERT(rs->time[RUNSTATE_runnable] !=3D 0);
+	GUEST_ASSERT(rs->state =3D=3D 0);
+
+	GUEST_SYNC(RUNSTATE_blocked);
+	GUEST_ASSERT(rs->time[RUNSTATE_blocked] !=3D 0);
+	GUEST_ASSERT(rs->state =3D=3D 0);
+
+	GUEST_SYNC(RUNSTATE_offline);
+	GUEST_ASSERT(rs->time[RUNSTATE_offline] !=3D 0);
+	GUEST_ASSERT(rs->state =3D=3D 0);
+
+	/* Test runstate time adjust */
+	GUEST_SYNC(4);
+	GUEST_ASSERT(rs->time[RUNSTATE_blocked] =3D=3D 0x5a);
+	GUEST_ASSERT(rs->time[RUNSTATE_offline] =3D=3D 0x6b6b);
+
+	/* Test runstate time set */
+	GUEST_SYNC(5);
+	GUEST_ASSERT(rs->state_entry_time >=3D 0x8000);
+	GUEST_ASSERT(rs->time[RUNSTATE_runnable] =3D=3D 0);
+	GUEST_ASSERT(rs->time[RUNSTATE_blocked] =3D=3D 0xdeadbeef);
+	GUEST_ASSERT(rs->time[RUNSTATE_offline] =3D=3D 0xcafebabe);
+
+	/* sched_yield() should result in some 'runnable' time */
+	GUEST_SYNC(6);
+	GUEST_ASSERT(rs->time[RUNSTATE_runnable] >=3D MIN_STEAL_TIME);
+
 	GUEST_DONE();
 }
=20
+static long get_run_delay(void)
+{
+        char path[64];
+        long val[2];
+        FILE *fp;
+
+        sprintf(path, "/proc/%ld/schedstat", syscall(SYS_gettid));
+        fp =3D fopen(path, "r");
+        fscanf(fp, "%ld %ld ", &val[0], &val[1]);
+        fclose(fp);
+
+        return val[1];
+}
+
 static int cmp_timespec(struct timespec *a, struct timespec *b)
 {
 	if (a->tv_sec > b->tv_sec)
@@ -66,12 +132,14 @@ int main(int argc, char *argv[])
 {
 	struct timespec min_ts, max_ts, vm_ts;
=20
-	if (!(kvm_check_cap(KVM_CAP_XEN_HVM) &
-	      KVM_XEN_HVM_CONFIG_SHARED_INFO) ) {
+	int xen_caps =3D kvm_check_cap(KVM_CAP_XEN_HVM);
+	if (!(xen_caps & KVM_XEN_HVM_CONFIG_SHARED_INFO) ) {
 		print_skip("KVM_XEN_HVM_CONFIG_SHARED_INFO not available");
 		exit(KSFT_SKIP);
 	}
=20
+	bool do_runstate_tests =3D !!(xen_caps & KVM_XEN_HVM_CONFIG_RUNSTATE);
+
 	clock_gettime(CLOCK_REALTIME, &min_ts);
=20
 	vm =3D vm_create_default(VCPU_ID, 0, (void *) guest_code);
@@ -80,6 +148,7 @@ int main(int argc, char *argv[])
 	/* Map a region for the shared_info page */
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
 				    SHINFO_REGION_GPA, SHINFO_REGION_SLOT, 2, 0);
+	virt_map(vm, SHINFO_REGION_GVA, SHINFO_REGION_GPA, 2, 0);
=20
 	struct kvm_xen_hvm_config hvmc =3D {
 		.flags =3D KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL,
@@ -111,6 +180,16 @@ int main(int argc, char *argv[])
 	};
 	vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &pvclock);
=20
+	if (do_runstate_tests) {
+		struct kvm_xen_vcpu_attr st =3D {
+			.type =3D KVM_XEN_VCPU_ATTR_TYPE_VCPU_RUNSTATE_ADDR,
+			.u.gpa =3D RUNSTATE_ADDR,
+		};
+		vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &st);
+	}
+
+	struct vcpu_runstate_info *rs =3D addr_gpa2hva(vm, RUNSTATE_ADDR);;
+
 	for (;;) {
 		volatile struct kvm_run *run =3D vcpu_state(vm, VCPU_ID);
 		struct ucall uc;
@@ -126,8 +205,50 @@ int main(int argc, char *argv[])
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
+			switch (uc.args[1]) {
+			case RUNSTATE_running...RUNSTATE_offline:
+				rst.type =3D KVM_XEN_VCPU_ATTR_TYPE_VCPU_RUNSTATE_CURRENT;
+				rst.u.runstate.state =3D uc.args[1];
+				vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &rst);
+				break;
+			case 4:
+				rst.type =3D KVM_XEN_VCPU_ATTR_TYPE_VCPU_RUNSTATE_ADJUST;
+				memset(&rst.u, 0, sizeof(rst.u));
+				rst.u.runstate.state =3D (uint64_t)-1;
+				rst.u.runstate.time_blocked =3D
+					0x5a - rs->time[RUNSTATE_blocked];
+				rst.u.runstate.time_offline =3D
+					0x6b6b - rs->time[RUNSTATE_offline];
+				vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &rst);
+				break;
+
+			case 5:
+				rst.type =3D KVM_XEN_VCPU_ATTR_TYPE_VCPU_RUNSTATE_DATA;
+				memset(&rst.u, 0, sizeof(rst.u));
+				rst.u.runstate.state =3D RUNSTATE_running;
+				rst.u.runstate.state_entry_time =3D 0x8000;
+				rst.u.runstate.time_blocked =3D 0xdeadbeef;
+				rst.u.runstate.time_offline =3D 0xcafebabe;
+				vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &rst);
+				break;
+			case 6:
+				/* Yield until scheduler delay exceeds target */
+				rundelay =3D get_run_delay() + MIN_STEAL_TIME;
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
@@ -162,6 +283,29 @@ int main(int argc, char *argv[])
 	TEST_ASSERT(ti2->version && !(ti2->version & 1),
 		    "Bad time_info version %x", ti->version);
=20
+	if (do_runstate_tests) {
+		/*
+		 * Fetch runstate and check sanity. Strictly speaking in the
+		 * general case we might not expect the numbers to be identical
+		 * but in this case we know we aren't running the vCPU any more.
+		 */
+		struct kvm_xen_vcpu_attr rst =3D {
+			.type =3D KVM_XEN_VCPU_ATTR_TYPE_VCPU_RUNSTATE_DATA,
+		};
+		vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_GET_ATTR, &rst);
+
+		TEST_ASSERT(rs->state =3D=3D rst.u.runstate.state, "Runstate mismatch");
+		TEST_ASSERT(rs->state_entry_time =3D=3D rst.u.runstate.state_entry_time,
+			    "State entry time mismatch");
+		TEST_ASSERT(rs->time[RUNSTATE_running] =3D=3D rst.u.runstate.time_runnin=
g,
+			    "Running time mismatch");
+		TEST_ASSERT(rs->time[RUNSTATE_runnable] =3D=3D rst.u.runstate.time_runna=
ble,
+			    "Runnable time mismatch");
+		TEST_ASSERT(rs->time[RUNSTATE_blocked] =3D=3D rst.u.runstate.time_blocke=
d,
+			    "Blocked time mismatch");
+		TEST_ASSERT(rs->time[RUNSTATE_offline] =3D=3D rst.u.runstate.time_offlin=
e,
+			    "Offline time mismatch");
+	}
 	kvm_vm_free(vm);
 	return 0;
 }
--=20
2.17.1


--=-kUf5zhF3wCZRCOfRawY3
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCECow
ggUcMIIEBKADAgECAhEA4rtJSHkq7AnpxKUY8ZlYZjANBgkqhkiG9w0BAQsFADCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EwHhcNMTkwMTAyMDAwMDAwWhcNMjIwMTAxMjM1
OTU5WjAkMSIwIAYJKoZIhvcNAQkBFhNkd213MkBpbmZyYWRlYWQub3JnMIIBIjANBgkqhkiG9w0B
AQEFAAOCAQ8AMIIBCgKCAQEAsv3wObLTCbUA7GJqKj9vHGf+Fa+tpkO+ZRVve9EpNsMsfXhvFpb8
RgL8vD+L133wK6csYoDU7zKiAo92FMUWaY1Hy6HqvVr9oevfTV3xhB5rQO1RHJoAfkvhy+wpjo7Q
cXuzkOpibq2YurVStHAiGqAOMGMXhcVGqPuGhcVcVzVUjsvEzAV9Po9K2rpZ52FE4rDkpDK1pBK+
uOAyOkgIg/cD8Kugav5tyapydeWMZRJQH1vMQ6OVT24CyAn2yXm2NgTQMS1mpzStP2ioPtTnszIQ
Ih7ASVzhV6csHb8Yrkx8mgllOyrt9Y2kWRRJFm/FPRNEurOeNV6lnYAXOymVJwIDAQABo4IB0zCC
Ac8wHwYDVR0jBBgwFoAUgq9sjPjF/pZhfOgfPStxSF7Ei8AwHQYDVR0OBBYEFLfuNf820LvaT4AK
xrGK3EKx1DE7MA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMB0GA1UdJQQWMBQGCCsGAQUF
BwMEBggrBgEFBQcDAjBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEDBTArMCkGCCsGAQUFBwIBFh1o
dHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3Js
LmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWls
Q0EuY3JsMIGLBggrBgEFBQcBAQR/MH0wVQYIKwYBBQUHMAKGSWh0dHA6Ly9jcnQuY29tb2RvY2Eu
Y29tL0NPTU9ET1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcnQwJAYI
KwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTAeBgNVHREEFzAVgRNkd213MkBpbmZy
YWRlYWQub3JnMA0GCSqGSIb3DQEBCwUAA4IBAQALbSykFusvvVkSIWttcEeifOGGKs7Wx2f5f45b
nv2ghcxK5URjUvCnJhg+soxOMoQLG6+nbhzzb2rLTdRVGbvjZH0fOOzq0LShq0EXsqnJbbuwJhK+
PnBtqX5O23PMHutP1l88AtVN+Rb72oSvnD+dK6708JqqUx2MAFLMevrhJRXLjKb2Mm+/8XBpEw+B
7DisN4TMlLB/d55WnT9UPNHmQ+3KFL7QrTO8hYExkU849g58Dn3Nw3oCbMUgny81ocrLlB2Z5fFG
Qu1AdNiBA+kg/UxzyJZpFbKfCITd5yX49bOriL692aMVDyqUvh8fP+T99PqorH4cIJP6OxSTdxKM
MIIFHDCCBASgAwIBAgIRAOK7SUh5KuwJ6cSlGPGZWGYwDQYJKoZIhvcNAQELBQAwgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTE5MDEwMjAwMDAwMFoXDTIyMDEwMTIz
NTk1OVowJDEiMCAGCSqGSIb3DQEJARYTZHdtdzJAaW5mcmFkZWFkLm9yZzCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBALL98Dmy0wm1AOxiaio/bxxn/hWvraZDvmUVb3vRKTbDLH14bxaW
/EYC/Lw/i9d98CunLGKA1O8yogKPdhTFFmmNR8uh6r1a/aHr301d8YQea0DtURyaAH5L4cvsKY6O
0HF7s5DqYm6tmLq1UrRwIhqgDjBjF4XFRqj7hoXFXFc1VI7LxMwFfT6PStq6WedhROKw5KQytaQS
vrjgMjpICIP3A/CroGr+bcmqcnXljGUSUB9bzEOjlU9uAsgJ9sl5tjYE0DEtZqc0rT9oqD7U57My
ECIewElc4VenLB2/GK5MfJoJZTsq7fWNpFkUSRZvxT0TRLqznjVepZ2AFzsplScCAwEAAaOCAdMw
ggHPMB8GA1UdIwQYMBaAFIKvbIz4xf6WYXzoHz0rcUhexIvAMB0GA1UdDgQWBBS37jX/NtC72k+A
CsaxitxCsdQxOzAOBgNVHQ8BAf8EBAMCBaAwDAYDVR0TAQH/BAIwADAdBgNVHSUEFjAUBggrBgEF
BQcDBAYIKwYBBQUHAwIwRgYDVR0gBD8wPTA7BgwrBgEEAbIxAQIBAwUwKzApBggrBgEFBQcCARYd
aHR0cHM6Ly9zZWN1cmUuY29tb2RvLm5ldC9DUFMwWgYDVR0fBFMwUTBPoE2gS4ZJaHR0cDovL2Ny
bC5jb21vZG9jYS5jb20vQ09NT0RPUlNBQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFp
bENBLmNybDCBiwYIKwYBBQUHAQEEfzB9MFUGCCsGAQUFBzAChklodHRwOi8vY3J0LmNvbW9kb2Nh
LmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWlsQ0EuY3J0MCQG
CCsGAQUFBzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5m
cmFkZWFkLm9yZzANBgkqhkiG9w0BAQsFAAOCAQEAC20spBbrL71ZEiFrbXBHonzhhirO1sdn+X+O
W579oIXMSuVEY1LwpyYYPrKMTjKECxuvp24c829qy03UVRm742R9Hzjs6tC0oatBF7KpyW27sCYS
vj5wbal+TttzzB7rT9ZfPALVTfkW+9qEr5w/nSuu9PCaqlMdjABSzHr64SUVy4ym9jJvv/FwaRMP
gew4rDeEzJSwf3eeVp0/VDzR5kPtyhS+0K0zvIWBMZFPOPYOfA59zcN6AmzFIJ8vNaHKy5QdmeXx
RkLtQHTYgQPpIP1Mc8iWaRWynwiE3ecl+PWzq4i+vdmjFQ8qlL4fHz/k/fT6qKx+HCCT+jsUk3cS
jDCCBeYwggPOoAMCAQICEGqb4Tg7/ytrnwHV2binUlYwDQYJKoZIhvcNAQEMBQAwgYUxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMSswKQYDVQQDEyJDT01PRE8gUlNBIENlcnRpZmljYXRp
b24gQXV0aG9yaXR5MB4XDTEzMDExMDAwMDAwMFoXDTI4MDEwOTIzNTk1OVowgZcxCzAJBgNVBAYT
AkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNV
BAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRoZW50
aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAvrOeV6wodnVAFsc4A5jTxhh2IVDzJXkLTLWg0X06WD6cpzEup/Y0dtmEatrQPTRI5Or1u6zf
+bGBSyD9aH95dDSmeny1nxdlYCeXIoymMv6pQHJGNcIDpFDIMypVpVSRsivlJTRENf+RKwrB6vcf
WlP8dSsE3Rfywq09N0ZfxcBa39V0wsGtkGWC+eQKiz4pBZYKjrc5NOpG9qrxpZxyb4o4yNNwTqza
aPpGRqXB7IMjtf7tTmU2jqPMLxFNe1VXj9XB1rHvbRikw8lBoNoSWY66nJN/VCJv5ym6Q0mdCbDK
CMPybTjoNCQuelc0IAaO4nLUXk0BOSxSxt8kCvsUtQIDAQABo4IBPDCCATgwHwYDVR0jBBgwFoAU
u69+Aj36pvE8hI6t7jiY7NkyMtQwHQYDVR0OBBYEFIKvbIz4xf6WYXzoHz0rcUhexIvAMA4GA1Ud
DwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMBEGA1UdIAQKMAgwBgYEVR0gADBMBgNVHR8E
RTBDMEGgP6A9hjtodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDZXJ0aWZpY2F0aW9u
QXV0aG9yaXR5LmNybDBxBggrBgEFBQcBAQRlMGMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9jcnQuY29t
b2RvY2EuY29tL0NPTU9ET1JTQUFkZFRydXN0Q0EuY3J0MCQGCCsGAQUFBzABhhhodHRwOi8vb2Nz
cC5jb21vZG9jYS5jb20wDQYJKoZIhvcNAQEMBQADggIBAHhcsoEoNE887l9Wzp+XVuyPomsX9vP2
SQgG1NgvNc3fQP7TcePo7EIMERoh42awGGsma65u/ITse2hKZHzT0CBxhuhb6txM1n/y78e/4ZOs
0j8CGpfb+SJA3GaBQ+394k+z3ZByWPQedXLL1OdK8aRINTsjk/H5Ns77zwbjOKkDamxlpZ4TKSDM
KVmU/PUWNMKSTvtlenlxBhh7ETrN543j/Q6qqgCWgWuMAXijnRglp9fyadqGOncjZjaaSOGTTFB+
E2pvOUtY+hPebuPtTbq7vODqzCM6ryEhNhzf+enm0zlpXK7q332nXttNtjv7VFNYG+I31gnMrwfH
M5tdhYF/8v5UY5g2xANPECTQdu9vWPoqNSGDt87b3gXb1AiGGaI06vzgkejL580ul+9hz9D0S0U4
jkhJiA7EuTecP/CFtR72uYRBcunwwH3fciPjviDDAI9SnC/2aPY8ydehzuZutLbZdRJ5PDEJM/1t
yZR2niOYihZ+FCbtf3D9mB12D4ln9icgc7CwaxpNSCPt8i/GqK2HsOgkL3VYnwtx7cJUmpvVdZ4o
gnzgXtgtdk3ShrtOS1iAN2ZBXFiRmjVzmehoMof06r1xub+85hFQzVxZx5/bRaTKTlL8YXLI8nAb
R9HWdFqzcOoB/hxfEyIQpx9/s81rgzdEZOofSlZHynoSMYIDyjCCA8YCAQEwga0wgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEA4rtJSHkq7AnpxKUY8ZlYZjANBglghkgB
ZQMEAgEFAKCCAe0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjEw
MjE4MjMxNTMxWjAvBgkqhkiG9w0BCQQxIgQgezmmCbR+AjHgWaxpybVNjCdFE3++pXg+TY1ul0dp
P1Mwgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAAowmSojhxAoX224aB6QOxFfRPdcvmkS6dDur1ezQgJNtGpKkKiAPvIXCvNSlTFD
8rJNWns7nVFEdlzPkPHz+FtVYAZOzIPOxYJ1l1+OPzJ1xxPeV/8SVwWkQb5g8F2IFy6FnJ2IIqnC
l+pqy70yIaCI2eFZbqrbFmzdbyvqZrNomTreOc58u2712P9s3aBiiQpdq22GXW3eGtLMi1p1tYzW
dc+SWl6LliEnBuXGuxybPgyC6+mVx4BxAUF29jRiCsi9V3kOsLZIRElu95y6GcnnW5vBskQ2j0OC
DQgdNIFtcfnhVnmo6IrampQ7xO7h5Xn0m8kh8kNWo3zajZycMXEAAAAAAAA=


--=-kUf5zhF3wCZRCOfRawY3--

