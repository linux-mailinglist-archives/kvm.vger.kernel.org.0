Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA04F228AD1
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731333AbgGUVQJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:16:09 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37788 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731285AbgGUVQH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:07 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 6C151305D59B;
        Wed, 22 Jul 2020 00:09:27 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 4D55D304FA12;
        Wed, 22 Jul 2020 00:09:27 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 53/84] KVM: introspection: add KVMI_EVENT_PAUSE_VCPU
Date:   Wed, 22 Jul 2020 00:08:51 +0300
Message-Id: <20200721210922.7646-54-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This event is sent by the vCPU thread as a response to the KVMI_VCPU_PAUSE
command, but it has a lower priority, being sent after any other
introspection event and when no other introspection command is queued.

The number of KVMI_EVENT_PAUSE_VCPU will match the number of successful
KVMI_VCPU_PAUSE commands.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               |  22 ++-
 arch/x86/kvm/kvmi.c                           |  81 +++++++++
 include/linux/kvmi_host.h                     |  11 ++
 include/uapi/linux/kvmi.h                     |  13 ++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  |  46 ++++++
 virt/kvm/introspection/kvmi.c                 |  24 ++-
 virt/kvm/introspection/kvmi_int.h             |   3 +
 virt/kvm/introspection/kvmi_msg.c             | 155 +++++++++++++++++-
 8 files changed, 351 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 502ee06d5e77..06c1cb34209e 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -563,6 +563,25 @@ On x86 the structure looks like this::
 
 It contains information about the vCPU state at the time of the event.
 
+An event reply begins with two common structures::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_event_reply {
+		__u8 action;
+		__u8 event;
+		__u16 padding1;
+		__u32 padding2;
+	};
+
+All events accept the KVMI_EVENT_ACTION_CRASH action, which stops the
+guest ungracefully, but as soon as possible.
+
+Most of the events accept the KVMI_EVENT_ACTION_CONTINUE action, which
+lets the instruction that caused the event to continue.
+
+Some of the events accept the KVMI_EVENT_ACTION_RETRY action, to continue
+by re-entering in guest.
+
 Specific event data can follow these common structures.
 
 1. KVMI_EVENT_UNHOOK
@@ -604,7 +623,8 @@ operation can proceed).
 	struct kvmi_vcpu_hdr;
 	struct kvmi_event_reply;
 
-This event is sent in response to a *KVMI_VCPU_PAUSE* command.
+This event is sent in response to a *KVMI_VCPU_PAUSE* command and
+cannot be controlled with *KVMI_VCPU_CONTROL_EVENTS*.
 Because it has a low priority, it will be sent after any other vCPU
 introspection event and when no other vCPU introspection command is
 queued.
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index cf7bfff6c8c5..ce7e2d5f2ab4 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -5,8 +5,89 @@
  * Copyright (C) 2019-2020 Bitdefender S.R.L.
  */
 
+#include "linux/kvm_host.h"
+#include "x86.h"
 #include "../../../virt/kvm/introspection/kvmi_int.h"
 
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
+static void kvmi_get_msrs(struct kvm_vcpu *vcpu, struct kvmi_event_arch *event)
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
+void kvmi_arch_setup_event(struct kvm_vcpu *vcpu, struct kvmi_event *ev)
+{
+	struct kvmi_event_arch *event = &ev->arch;
+
+	kvm_arch_vcpu_get_regs(vcpu, &event->regs);
+	kvm_arch_vcpu_get_sregs(vcpu, &event->sregs);
+	ev->arch.mode = kvmi_vcpu_mode(vcpu, &event->sregs);
+	kvmi_get_msrs(vcpu, event);
+}
+
 int kvmi_arch_cmd_vcpu_get_info(struct kvm_vcpu *vcpu,
 				struct kvmi_vcpu_get_info_reply *rpl)
 {
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index fdb8ce6fe6a5..a87f0322c584 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -6,6 +6,14 @@
 
 #include <asm/kvmi_host.h>
 
+struct kvmi_vcpu_reply {
+	int error;
+	int action;
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
index 3ded22020bef..5a5b01df7e3e 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -38,6 +38,12 @@ enum {
 	KVMI_NUM_EVENTS
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
@@ -124,4 +130,11 @@ struct kvmi_event {
 	struct kvmi_event_arch arch;
 };
 
+struct kvmi_event_reply {
+	__u8 action;
+	__u8 event;
+	__u16 padding1;
+	__u32 padding2;
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 0df890b4b440..5c5c5018832d 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -34,6 +34,12 @@ static vm_paddr_t test_gpa;
 static uint8_t test_write_pattern;
 static int page_size;
 
+struct vcpu_reply {
+	struct kvmi_msg_hdr hdr;
+	struct kvmi_vcpu_hdr vcpu_hdr;
+	struct kvmi_event_reply reply;
+};
+
 struct vcpu_worker_data {
 	struct kvm_vm *vm;
 	int vcpu_id;
@@ -772,14 +778,54 @@ static void pause_vcpu(void)
 	cmd_vcpu_pause(1, 0, 0);
 }
 
+static void reply_to_event(struct kvmi_msg_hdr *ev_hdr, struct kvmi_event *ev,
+			   __u8 action, struct vcpu_reply *rpl, size_t rpl_size)
+{
+	ssize_t r;
+
+	rpl->hdr.id = ev_hdr->id;
+	rpl->hdr.seq = ev_hdr->seq;
+	rpl->hdr.size = rpl_size - sizeof(rpl->hdr);
+
+	rpl->vcpu_hdr.vcpu = ev->vcpu;
+
+	rpl->reply.action = action;
+	rpl->reply.event = ev->event;
+
+	r = send(Userspace_socket, rpl, rpl_size, 0);
+	TEST_ASSERT(r == rpl_size,
+		"send() failed, sending %zd, result %zd, errno %d (%s)\n",
+		rpl_size, r, errno, strerror(errno));
+}
+
+static void discard_pause_event(struct kvm_vm *vm)
+{
+	struct vcpu_worker_data data = {.vm = vm, .vcpu_id = VCPU_ID};
+	struct vcpu_reply rpl = {};
+	struct kvmi_msg_hdr hdr;
+	pthread_t vcpu_thread;
+	struct kvmi_event ev;
+
+	vcpu_thread = start_vcpu_worker(&data);
+
+	receive_event(&hdr, &ev, sizeof(ev), KVMI_EVENT_PAUSE_VCPU);
+
+	reply_to_event(&hdr, &ev, KVMI_EVENT_ACTION_CONTINUE,
+			&rpl, sizeof(rpl));
+
+	stop_vcpu_worker(vcpu_thread, &data);
+}
+
 static void test_pause(struct kvm_vm *vm)
 {
 	__u8 no_wait = 0, wait = 1, wait_inval = 2;
 	__u8 padding = 1, no_padding = 0;
 
 	pause_vcpu();
+	discard_pause_event(vm);
 
 	cmd_vcpu_pause(wait, no_padding, 0);
+	discard_pause_event(vm);
 	cmd_vcpu_pause(wait_inval, no_padding, -KVM_EINVAL);
 	cmd_vcpu_pause(no_wait, padding, -KVM_EINVAL);
 
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index a704e05b3184..02a866ca8d8c 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -358,6 +358,7 @@ static void kvmi_job_release_vcpu(struct kvm_vcpu *vcpu, void *ctx)
 	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
 
 	atomic_set(&vcpui->pause_requests, 0);
+	vcpui->waiting_for_reply = false;
 }
 
 static void kvmi_release_vcpus(struct kvm *kvm)
@@ -743,12 +744,33 @@ void kvmi_run_jobs(struct kvm_vcpu *vcpu)
 	}
 }
 
+static void kvmi_handle_unsupported_event_action(struct kvm *kvm)
+{
+	kvmi_sock_shutdown(KVMI(kvm));
+}
+
+void kvmi_handle_common_event_actions(struct kvm *kvm, u32 action)
+{
+	switch (action) {
+	default:
+		kvmi_handle_unsupported_event_action(kvm);
+	}
+}
+
 static void kvmi_vcpu_pause_event(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+	u32 action;
 
 	atomic_dec(&vcpui->pause_requests);
-	/* to be implemented */
+
+	action = kvmi_msg_send_vcpu_pause(vcpu);
+	switch (action) {
+	case KVMI_EVENT_ACTION_CONTINUE:
+		break;
+	default:
+		kvmi_handle_common_event_actions(vcpu->kvm, action);
+	}
 }
 
 void kvmi_handle_requests(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index cb99cb3db396..f73596032883 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -27,6 +27,7 @@ void kvmi_sock_shutdown(struct kvm_introspection *kvmi);
 void kvmi_sock_put(struct kvm_introspection *kvmi);
 bool kvmi_msg_process(struct kvm_introspection *kvmi);
 int kvmi_msg_send_unhook(struct kvm_introspection *kvmi);
+u32 kvmi_msg_send_vcpu_pause(struct kvm_vcpu *vcpu);
 
 /* kvmi.c */
 void *kvmi_msg_alloc(void);
@@ -37,6 +38,7 @@ bool kvmi_is_known_vm_event(u8 id);
 int kvmi_add_job(struct kvm_vcpu *vcpu,
 		 void (*fct)(struct kvm_vcpu *vcpu, void *ctx),
 		 void *ctx, void (*free_fct)(void *ctx));
+void kvmi_run_jobs(struct kvm_vcpu *vcpu);
 int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
 				unsigned int event_id, bool enable);
 int kvmi_cmd_read_physical(struct kvm *kvm, u64 gpa, size_t size,
@@ -51,5 +53,6 @@ int kvmi_cmd_vcpu_pause(struct kvm_vcpu *vcpu, bool wait);
 /* arch */
 int kvmi_arch_cmd_vcpu_get_info(struct kvm_vcpu *vcpu,
 				struct kvmi_vcpu_get_info_reply *rpl);
+void kvmi_arch_setup_event(struct kvm_vcpu *vcpu, struct kvmi_event *ev);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 1adec838cddd..1dcd3db75ff1 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -337,6 +337,66 @@ static int handle_vcpu_get_info(const struct kvmi_vcpu_msg_job *job,
 	return kvmi_msg_vcpu_reply(job, msg, 0, &rpl, sizeof(rpl));
 }
 
+static int check_event_reply(const struct kvmi_msg_hdr *msg,
+			     const struct kvmi_event_reply *reply,
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
+	const struct kvmi_event_reply *reply = rpl;
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
@@ -345,6 +405,7 @@ static int handle_vcpu_get_info(const struct kvmi_vcpu_msg_job *job,
  */
 static int(*const msg_vcpu[])(const struct kvmi_vcpu_msg_job *,
 			      const struct kvmi_msg_hdr *, const void *) = {
+	[KVMI_EVENT]         = handle_vcpu_event_reply,
 	[KVMI_VCPU_GET_INFO] = handle_vcpu_get_info,
 };
 
@@ -430,7 +491,7 @@ static int kvmi_msg_do_vm_cmd(struct kvm_introspection *kvmi,
 
 static bool is_message_allowed(struct kvm_introspection *kvmi, u16 id)
 {
-	return kvmi_is_command_allowed(kvmi, id);
+	return id == KVMI_EVENT || kvmi_is_command_allowed(kvmi, id);
 }
 
 static int kvmi_msg_vm_reply_ec(struct kvm_introspection *kvmi,
@@ -450,7 +511,8 @@ static int kvmi_msg_handle_vm_cmd(struct kvm_introspection *kvmi,
 
 static bool vcpu_can_handle_messages(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.mp_state != KVM_MP_STATE_UNINITIALIZED;
+	return VCPUI(vcpu)->waiting_for_reply
+		|| vcpu->arch.mp_state != KVM_MP_STATE_UNINITIALIZED;
 }
 
 static int kvmi_get_vcpu_if_ready(struct kvm_introspection *kvmi,
@@ -554,6 +616,13 @@ static void kvmi_setup_event_common(struct kvmi_event *ev, u32 ev_id,
 	ev->size = sizeof(*ev);
 }
 
+static void kvmi_setup_event(struct kvm_vcpu *vcpu, struct kvmi_event *ev,
+			     u32 ev_id)
+{
+	kvmi_setup_event_common(ev, ev_id, kvm_vcpu_get_idx(vcpu));
+	kvmi_arch_setup_event(vcpu, ev);
+}
+
 int kvmi_msg_send_unhook(struct kvm_introspection *kvmi)
 {
 	struct kvmi_msg_hdr hdr;
@@ -570,3 +639,85 @@ int kvmi_msg_send_unhook(struct kvm_introspection *kvmi)
 
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
+				  u32 event_seq, void *rpl, size_t rpl_size)
+{
+	memset(&vcpui->reply, 0, sizeof(vcpui->reply));
+
+	vcpui->reply.seq = event_seq;
+	vcpui->reply.data = rpl;
+	vcpui->reply.size = rpl_size;
+	vcpui->reply.error = -EINTR;
+	vcpui->waiting_for_reply = true;
+}
+
+static int kvmi_send_event(struct kvm_vcpu *vcpu, u32 ev_id,
+			   void *ev, size_t ev_size,
+			   void *rpl, size_t rpl_size, int *action)
+{
+	struct kvmi_msg_hdr hdr;
+	struct kvmi_event common;
+	struct kvec vec[] = {
+		{.iov_base = &hdr,	.iov_len = sizeof(hdr)	 },
+		{.iov_base = &common,	.iov_len = sizeof(common)},
+		{.iov_base = ev,	.iov_len = ev_size	 },
+	};
+	size_t msg_size = sizeof(hdr) + sizeof(common) + ev_size;
+	size_t n = ARRAY_SIZE(vec) - (ev_size == 0 ? 1 : 0);
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+	struct kvm_introspection *kvmi = KVMI(vcpu->kvm);
+	int err;
+
+	kvmi_setup_event_msg_hdr(kvmi, &hdr, msg_size);
+	kvmi_setup_event(vcpu, &common, ev_id);
+	kvmi_setup_vcpu_reply(vcpui, hdr.seq, rpl, rpl_size);
+
+	err = kvmi_sock_write(kvmi, vec, n, msg_size);
+	if (err)
+		goto out;
+
+	err = kvmi_wait_for_reply(vcpu);
+	if (err)
+		goto out;
+
+	err = vcpui->reply.error;
+
+	if (!err)
+		*action = vcpui->reply.action;
+
+out:
+	if (err)
+		kvmi_sock_shutdown(kvmi);
+	return err;
+}
+
+u32 kvmi_msg_send_vcpu_pause(struct kvm_vcpu *vcpu)
+{
+	int err, action;
+
+	err = kvmi_send_event(vcpu, KVMI_EVENT_PAUSE_VCPU, NULL, 0,
+			      NULL, 0, &action);
+	if (err)
+		return KVMI_EVENT_ACTION_CONTINUE;
+
+	return action;
+}
