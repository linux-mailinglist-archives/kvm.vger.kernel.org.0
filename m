Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131592C3C83
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728399AbgKYJmB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:42:01 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57094 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727669AbgKYJl7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:41:59 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id C3453305D498;
        Wed, 25 Nov 2020 11:35:50 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 9E5283072785;
        Wed, 25 Nov 2020 11:35:50 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v10 49/81] KVM: introspection: add support for vCPU events
Date:   Wed, 25 Nov 2020 11:35:28 +0200
Message-Id: <20201125093600.2766-50-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the common code used by vCPU threads to send events and wait for
replies (received and dispatched by the receiving thread). While waiting
for an event reply, the vCPU thread will handle any introspection command
already queued or received during this period.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst   |  56 ++++++++++-
 arch/x86/include/uapi/asm/kvmi.h  |  20 ++++
 arch/x86/kvm/kvmi.c               |  85 ++++++++++++++++
 include/linux/kvmi_host.h         |  11 +++
 include/uapi/linux/kvmi.h         |  23 +++++
 virt/kvm/introspection/kvmi.c     |   1 +
 virt/kvm/introspection/kvmi_int.h |   6 ++
 virt/kvm/introspection/kvmi_msg.c | 156 +++++++++++++++++++++++++++++-
 8 files changed, 354 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index a71fb78d546e..5e99baf7e2f3 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -521,7 +521,61 @@ The message data begins with a common structure having the event id::
 		__u16 padding[3];
 	};
 
-Specific event data can follow this common structure.
+The vCPU introspection events are sent using the KVMI_VCPU_EVENT message id.
+No event is sent unless it is explicitly enabled or requested
+(e.g. *KVMI_VCPU_EVENT_PAUSE*).
+A vCPU event begins with a common structure having the size of the
+structure and the vCPU index::
+
+	struct kvmi_vcpu_event {
+		__u16 size;
+		__u16 vcpu;
+		__u32 padding;
+		struct kvmi_vcpu_event_arch arch;
+	};
+
+On x86::
+
+	struct kvmi_vcpu_event_arch {
+		__u8 mode;
+		__u8 padding[7];
+		struct kvm_regs regs;
+		struct kvm_sregs sregs;
+		struct {
+			__u64 sysenter_cs;
+			__u64 sysenter_esp;
+			__u64 sysenter_eip;
+			__u64 efer;
+			__u64 star;
+			__u64 lstar;
+			__u64 cstar;
+			__u64 pat;
+			__u64 shadow_gs;
+		} msrs;
+	};
+
+It contains information about the vCPU state at the time of the event.
+
+A vCPU event reply begins with two common structures::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_vcpu_event_reply {
+		__u8 action;
+		__u8 event;
+		__u16 padding1;
+		__u32 padding2;
+	};
+
+All events accept the KVMI_EVENT_ACTION_CRASH action, which stops the
+guest ungracefully, but as soon as possible.
+
+Most events accept the KVMI_EVENT_ACTION_CONTINUE action, which
+means that KVM will continue handling the event.
+
+Some events accept the KVMI_EVENT_ACTION_RETRY action, which means that
+KVM will stop handling the event and re-enter in guest.
+
+Specific event data can follow these common structures.
 
 1. KVMI_VM_EVENT_UNHOOK
 -----------------------
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index 2b6192e1a9a4..9d9df09d381a 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -6,8 +6,28 @@
  * KVM introspection - x86 specific structures and definitions
  */
 
+#include <asm/kvm.h>
+
 struct kvmi_vcpu_get_info_reply {
 	__u64 tsc_speed;
 };
 
+struct kvmi_vcpu_event_arch {
+	__u8 mode;		/* 2, 4 or 8 */
+	__u8 padding[7];
+	struct kvm_regs regs;
+	struct kvm_sregs sregs;
+	struct {
+		__u64 sysenter_cs;
+		__u64 sysenter_esp;
+		__u64 sysenter_eip;
+		__u64 efer;
+		__u64 star;
+		__u64 lstar;
+		__u64 cstar;
+		__u64 pat;
+		__u64 shadow_gs;
+	} msrs;
+};
+
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 35742d927be5..383b19dcf054 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -5,6 +5,91 @@
  * Copyright (C) 2019-2020 Bitdefender S.R.L.
  */
 
+#include "linux/kvm_host.h"
+#include "x86.h"
+#include "../../../virt/kvm/introspection/kvmi_int.h"
+
 void kvmi_arch_init_vcpu_events_mask(unsigned long *supported)
 {
 }
+
+static unsigned int kvmi_vcpu_mode(const struct kvm_vcpu *vcpu,
+				   const struct kvm_sregs *sregs)
+{
+	unsigned int mode = 0;
+
+	if (is_long_mode((struct kvm_vcpu *) vcpu)) {
+		if (sregs->cs.l)
+			mode = 8;
+		else if (!sregs->cs.db)
+			mode = 2;
+		else
+			mode = 4;
+	} else if (sregs->cr0 & X86_CR0_PE) {
+		if (!sregs->cs.db)
+			mode = 2;
+		else
+			mode = 4;
+	} else if (!sregs->cs.db) {
+		mode = 2;
+	} else {
+		mode = 4;
+	}
+
+	return mode;
+}
+
+static void kvmi_get_msrs(struct kvm_vcpu *vcpu,
+			  struct kvmi_vcpu_event_arch *event)
+{
+	struct msr_data msr;
+
+	msr.host_initiated = true;
+
+	msr.index = MSR_IA32_SYSENTER_CS;
+	kvm_x86_ops.get_msr(vcpu, &msr);
+	event->msrs.sysenter_cs = msr.data;
+
+	msr.index = MSR_IA32_SYSENTER_ESP;
+	kvm_x86_ops.get_msr(vcpu, &msr);
+	event->msrs.sysenter_esp = msr.data;
+
+	msr.index = MSR_IA32_SYSENTER_EIP;
+	kvm_x86_ops.get_msr(vcpu, &msr);
+	event->msrs.sysenter_eip = msr.data;
+
+	msr.index = MSR_EFER;
+	kvm_x86_ops.get_msr(vcpu, &msr);
+	event->msrs.efer = msr.data;
+
+	msr.index = MSR_STAR;
+	kvm_x86_ops.get_msr(vcpu, &msr);
+	event->msrs.star = msr.data;
+
+	msr.index = MSR_LSTAR;
+	kvm_x86_ops.get_msr(vcpu, &msr);
+	event->msrs.lstar = msr.data;
+
+	msr.index = MSR_CSTAR;
+	kvm_x86_ops.get_msr(vcpu, &msr);
+	event->msrs.cstar = msr.data;
+
+	msr.index = MSR_IA32_CR_PAT;
+	kvm_x86_ops.get_msr(vcpu, &msr);
+	event->msrs.pat = msr.data;
+
+	msr.index = MSR_KERNEL_GS_BASE;
+	kvm_x86_ops.get_msr(vcpu, &msr);
+	event->msrs.shadow_gs = msr.data;
+}
+
+void kvmi_arch_setup_vcpu_event(struct kvm_vcpu *vcpu,
+				struct kvmi_vcpu_event *ev)
+{
+	struct kvmi_vcpu_event_arch *event = &ev->arch;
+
+	kvm_arch_vcpu_get_regs(vcpu, &event->regs);
+	kvm_arch_vcpu_get_sregs(vcpu, &event->sregs);
+	ev->arch.mode = kvmi_vcpu_mode(vcpu, &event->sregs);
+	kvmi_get_msrs(vcpu, event);
+}
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index 59e645d9ea34..4a43e51a44c9 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -6,6 +6,14 @@
 
 #include <asm/kvmi_host.h>
 
+struct kvmi_vcpu_reply {
+	int error;
+	u32 action;
+	u32 seq;
+	void *data;
+	size_t size;
+};
+
 struct kvmi_job {
 	struct list_head link;
 	void *ctx;
@@ -20,6 +28,9 @@ struct kvm_vcpu_introspection {
 	spinlock_t job_lock;
 
 	atomic_t pause_requests;
+
+	struct kvmi_vcpu_reply reply;
+	bool waiting_for_reply;
 };
 
 struct kvm_introspection {
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index bb90d03f059b..6a57efb5664d 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -8,6 +8,7 @@
 
 #include <linux/kernel.h>
 #include <linux/types.h>
+#include <asm/kvmi.h>
 
 enum {
 	KVMI_VERSION = 0x00000001
@@ -32,6 +33,8 @@ enum {
 };
 
 enum {
+	KVMI_VCPU_EVENT = KVMI_VCPU_MESSAGE_ID(0),
+
 	KVMI_VCPU_GET_INFO = KVMI_VCPU_MESSAGE_ID(1),
 
 	KVMI_NEXT_VCPU_MESSAGE
@@ -50,6 +53,12 @@ enum {
 	KVMI_NEXT_VCPU_EVENT
 };
 
+enum {
+	KVMI_EVENT_ACTION_CONTINUE = 0,
+	KVMI_EVENT_ACTION_RETRY    = 1,
+	KVMI_EVENT_ACTION_CRASH    = 2,
+};
+
 struct kvmi_msg_hdr {
 	__u16 id;
 	__u16 size;
@@ -123,4 +132,18 @@ struct kvmi_vm_pause_vcpu {
 	__u32 padding2;
 };
 
+struct kvmi_vcpu_event {
+	__u16 size;
+	__u16 vcpu;
+	__u32 padding;
+	struct kvmi_vcpu_event_arch arch;
+};
+
+struct kvmi_vcpu_event_reply {
+	__u8 action;
+	__u8 event;
+	__u16 padding1;
+	__u32 padding2;
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 4999132a65bc..771e6b545698 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -368,6 +368,7 @@ static void kvmi_job_release_vcpu(struct kvm_vcpu *vcpu, void *ctx)
 	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
 
 	atomic_set(&vcpui->pause_requests, 0);
+	vcpui->waiting_for_reply = false;
 }
 
 static void kvmi_release_vcpus(struct kvm *kvm)
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index f1caa67dbdc3..65d8c1c37796 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -32,6 +32,9 @@ void kvmi_sock_shutdown(struct kvm_introspection *kvmi);
 void kvmi_sock_put(struct kvm_introspection *kvmi);
 bool kvmi_msg_process(struct kvm_introspection *kvmi);
 int kvmi_msg_send_unhook(struct kvm_introspection *kvmi);
+int kvmi_send_vcpu_event(struct kvm_vcpu *vcpu, u32 ev_id,
+			 void *ev, size_t ev_size,
+			 void *rpl, size_t rpl_size, u32 *action);
 int kvmi_msg_vcpu_reply(const struct kvmi_vcpu_msg_job *job,
 			const struct kvmi_msg_hdr *msg, int err,
 			const void *rpl, size_t rpl_size);
@@ -46,6 +49,7 @@ bool kvmi_is_known_vm_event(u16 id);
 int kvmi_add_job(struct kvm_vcpu *vcpu,
 		 void (*fct)(struct kvm_vcpu *vcpu, void *ctx),
 		 void *ctx, void (*free_fct)(void *ctx));
+void kvmi_run_jobs(struct kvm_vcpu *vcpu);
 int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
 			       u16 event_id, bool enable);
 int kvmi_cmd_read_physical(struct kvm *kvm, u64 gpa, size_t size,
@@ -60,5 +64,7 @@ int kvmi_cmd_vcpu_pause(struct kvm_vcpu *vcpu, bool wait);
 /* arch */
 void kvmi_arch_init_vcpu_events_mask(unsigned long *supported);
 kvmi_vcpu_msg_job_fct kvmi_arch_vcpu_msg_handler(u16 id);
+void kvmi_arch_setup_vcpu_event(struct kvm_vcpu *vcpu,
+				struct kvmi_vcpu_event *ev);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 02bdec5bfbe7..467c88185be1 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -299,6 +299,66 @@ static bool is_vm_command(u16 id)
 	return is_vm_message(id) && id != KVMI_VM_EVENT;
 }
 
+static int check_event_reply(const struct kvmi_msg_hdr *msg,
+			     const struct kvmi_vcpu_event_reply *reply,
+			     const struct kvmi_vcpu_reply *expected,
+			     u8 *action, size_t *received)
+{
+	size_t msg_size, common, event_size;
+	int err = -EINVAL;
+
+	if (unlikely(msg->seq != expected->seq))
+		return err;
+
+	msg_size = msg->size;
+	common = sizeof(struct kvmi_vcpu_hdr) + sizeof(*reply);
+
+	if (check_sub_overflow(msg_size, common, &event_size))
+		return err;
+
+	if (unlikely(event_size > expected->size))
+		return err;
+
+	if (unlikely(reply->padding1 || reply->padding2))
+		return err;
+
+	*received = event_size;
+	*action = reply->action;
+	return 0;
+}
+
+static int handle_vcpu_event_reply(const struct kvmi_vcpu_msg_job *job,
+				   const struct kvmi_msg_hdr *msg,
+				   const void *rpl)
+{
+	struct kvm_vcpu_introspection *vcpui = VCPUI(job->vcpu);
+	struct kvmi_vcpu_reply *expected = &vcpui->reply;
+	const struct kvmi_vcpu_event_reply *reply = rpl;
+	const void *reply_data = reply + 1;
+	size_t useful, received;
+	u8 action;
+
+	expected->error = check_event_reply(msg, reply, expected, &action,
+					    &received);
+	if (unlikely(expected->error))
+		goto out;
+
+	useful = min(received, expected->size);
+	if (useful)
+		memcpy(expected->data, reply_data, useful);
+
+	if (expected->size > useful)
+		memset((char *)expected->data + useful, 0,
+			expected->size - useful);
+
+	expected->action = action;
+	expected->error = 0;
+
+out:
+	vcpui->waiting_for_reply = false;
+	return expected->error;
+}
+
 /*
  * These functions are executed from the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_msg_job'
@@ -306,6 +366,7 @@ static bool is_vm_command(u16 id)
  * sending back the reply).
  */
 static kvmi_vcpu_msg_job_fct const msg_vcpu[] = {
+	[KVMI_VCPU_EVENT] = handle_vcpu_event_reply,
 };
 
 static kvmi_vcpu_msg_job_fct get_vcpu_msg_handler(u16 id)
@@ -329,7 +390,7 @@ static bool is_vcpu_message(u16 id)
 
 static bool is_vcpu_command(u16 id)
 {
-	return is_vcpu_message(id);
+	return is_vcpu_message(id) && id != KVMI_VCPU_EVENT;
 }
 
 static void kvmi_job_vcpu_msg(struct kvm_vcpu *vcpu, void *ctx)
@@ -422,7 +483,8 @@ static int kvmi_msg_handle_vm_cmd(struct kvm_introspection *kvmi,
 
 static bool vcpu_can_handle_messages(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.mp_state != KVM_MP_STATE_UNINITIALIZED;
+	return VCPUI(vcpu)->waiting_for_reply
+		|| vcpu->arch.mp_state != KVM_MP_STATE_UNINITIALIZED;
 }
 
 static int kvmi_get_vcpu_if_ready(struct kvm_introspection *kvmi,
@@ -467,7 +529,8 @@ static int kvmi_msg_handle_vcpu_msg(struct kvm_introspection *kvmi,
 	struct kvm_vcpu *vcpu = NULL;
 	int err, ec;
 
-	if (!kvmi_is_command_allowed(kvmi, msg->id))
+	if (msg->id != KVMI_VCPU_EVENT &&
+	    !kvmi_is_command_allowed(kvmi, msg->id))
 		return kvmi_msg_vm_reply_ec(kvmi, msg, -KVM_EPERM);
 
 	if (vcpu_hdr->padding1 || vcpu_hdr->padding2)
@@ -547,3 +610,90 @@ int kvmi_msg_send_unhook(struct kvm_introspection *kvmi)
 
 	return kvmi_sock_write(kvmi, vec, n, msg_size);
 }
+
+static int kvmi_wait_for_reply(struct kvm_vcpu *vcpu)
+{
+	struct rcuwait *waitp = kvm_arch_vcpu_get_wait(vcpu);
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+	int err = 0;
+
+	while (vcpui->waiting_for_reply && !err) {
+		kvmi_run_jobs(vcpu);
+
+		err = rcuwait_wait_event(waitp,
+			!vcpui->waiting_for_reply ||
+			!list_empty(&vcpui->job_list),
+			TASK_KILLABLE);
+	}
+
+	return err;
+}
+
+static void kvmi_setup_vcpu_reply(struct kvm_vcpu_introspection *vcpui,
+				  u32 msg_seq, void *rpl, size_t rpl_size)
+{
+	memset(&vcpui->reply, 0, sizeof(vcpui->reply));
+
+	vcpui->reply.seq = msg_seq;
+	vcpui->reply.data = rpl;
+	vcpui->reply.size = rpl_size;
+	vcpui->reply.error = -EINTR;
+	vcpui->waiting_for_reply = true;
+}
+
+static int kvmi_fill_and_sent_vcpu_event(struct kvm_vcpu *vcpu,
+					 u32 ev_id, void *ev,
+					 size_t ev_size, u32 msg_seq)
+{
+	struct kvmi_msg_hdr msg_hdr;
+	struct kvmi_event_hdr ev_hdr;
+	struct kvmi_vcpu_event common;
+	struct kvec vec[] = {
+		{.iov_base = &msg_hdr, .iov_len = sizeof(msg_hdr)},
+		{.iov_base = &ev_hdr,  .iov_len = sizeof(ev_hdr) },
+		{.iov_base = &common,  .iov_len = sizeof(common) },
+		{.iov_base = ev,       .iov_len = ev_size        },
+	};
+	size_t msg_size = sizeof(msg_hdr) + sizeof(ev_hdr)
+			+ sizeof(common) + ev_size;
+	size_t n = ARRAY_SIZE(vec) - (ev_size == 0 ? 1 : 0);
+	struct kvm_introspection *kvmi = KVMI(vcpu->kvm);
+
+	kvmi_fill_ev_msg_hdr(kvmi, &msg_hdr, &ev_hdr, KVMI_VCPU_EVENT,
+			     msg_seq, msg_size, ev_id);
+
+	common.size = sizeof(common);
+	common.vcpu = kvm_vcpu_get_idx(vcpu);
+
+	kvmi_arch_setup_vcpu_event(vcpu, &common);
+
+	return kvmi_sock_write(kvmi, vec, n, msg_size);
+}
+
+int kvmi_send_vcpu_event(struct kvm_vcpu *vcpu, u32 ev_id,
+			 void *ev, size_t ev_size,
+			 void *rpl, size_t rpl_size, u32 *action)
+{
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+	struct kvm_introspection *kvmi = KVMI(vcpu->kvm);
+	u32 msg_seq = atomic_inc_return(&kvmi->ev_seq);
+	int err;
+
+	kvmi_setup_vcpu_reply(vcpui, msg_seq, rpl, rpl_size);
+
+	err = kvmi_fill_and_sent_vcpu_event(vcpu, ev_id, ev, ev_size, msg_seq);
+	if (err)
+		goto out;
+
+	err = kvmi_wait_for_reply(vcpu);
+	if (!err)
+		err = vcpui->reply.error;
+
+out:
+	if (err)
+		kvmi_sock_shutdown(kvmi);
+	else
+		*action = vcpui->reply.action;
+
+	return err;
+}
