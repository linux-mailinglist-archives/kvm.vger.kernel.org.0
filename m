Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB9AB1978FF
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729873AbgC3KUs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:20:48 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43778 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729568AbgC3KUF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:20:05 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 75ADB305FFAB;
        Mon, 30 Mar 2020 13:12:57 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 504E9305B7A1;
        Mon, 30 Mar 2020 13:12:57 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 54/81] KVM: introspection: add KVMI_EVENT_PAUSE_VCPU
Date:   Mon, 30 Mar 2020 13:12:41 +0300
Message-Id: <20200330101308.21702-55-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This event is send by the vCPU thread and has a low priority.
It will be sent after any other introspection event
and when no introspection command is queued.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               |  22 ++-
 arch/x86/kvm/kvmi.c                           |  81 +++++++++
 include/linux/kvmi_host.h                     |  11 ++
 include/uapi/linux/kvmi.h                     |  13 ++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  |  42 +++++
 virt/kvm/introspection/kvmi.c                 |  21 ++-
 virt/kvm/introspection/kvmi_int.h             |   3 +
 virt/kvm/introspection/kvmi_msg.c             | 164 +++++++++++++++++-
 8 files changed, 353 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 642e2f10adfd..d841d266b1a9 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -560,6 +560,25 @@ On x86 the structure looks like this::
 
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
+by re-entering the guest.
+
 Specific data can follow these common structures.
 
 1. KVMI_EVENT_UNHOOK
@@ -601,6 +620,7 @@ operation can proceed).
 	struct kvmi_vcpu_hdr;
 	struct kvmi_event_reply;
 
-This event is sent in response to a *KVMI_VCPU_PAUSE* command.
+This event is sent in response to a *KVMI_VCPU_PAUSE* command and
+cannot be disabled via *KVMI_VCPU_CONTROL_EVENTS*.
 Because it has a low priority, it will be sent after any other vCPU
 introspection event and when no vCPU introspection command is queued.
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 2afb3abc97fa..21ff48cfdb89 100644
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
+	kvm_x86_ops->get_msr(vcpu, &msr);
+	event->msrs.sysenter_cs = msr.data;
+
+	msr.index = MSR_IA32_SYSENTER_ESP;
+	kvm_x86_ops->get_msr(vcpu, &msr);
+	event->msrs.sysenter_esp = msr.data;
+
+	msr.index = MSR_IA32_SYSENTER_EIP;
+	kvm_x86_ops->get_msr(vcpu, &msr);
+	event->msrs.sysenter_eip = msr.data;
+
+	msr.index = MSR_EFER;
+	kvm_x86_ops->get_msr(vcpu, &msr);
+	event->msrs.efer = msr.data;
+
+	msr.index = MSR_STAR;
+	kvm_x86_ops->get_msr(vcpu, &msr);
+	event->msrs.star = msr.data;
+
+	msr.index = MSR_LSTAR;
+	kvm_x86_ops->get_msr(vcpu, &msr);
+	event->msrs.lstar = msr.data;
+
+	msr.index = MSR_CSTAR;
+	kvm_x86_ops->get_msr(vcpu, &msr);
+	event->msrs.cstar = msr.data;
+
+	msr.index = MSR_IA32_CR_PAT;
+	kvm_x86_ops->get_msr(vcpu, &msr);
+	event->msrs.pat = msr.data;
+
+	msr.index = MSR_KERNEL_GS_BASE;
+	kvm_x86_ops->get_msr(vcpu, &msr);
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
index 988927c29bf5..49e68777a390 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -11,6 +11,14 @@ struct kvm_vcpu;
 
 #define KVMI_NUM_COMMANDS KVMI_NUM_MESSAGES
 
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
@@ -25,6 +33,9 @@ struct kvm_vcpu_introspection {
 	spinlock_t job_lock;
 
 	atomic_t pause_requests;
+
+	struct kvmi_vcpu_reply reply;
+	bool waiting_for_reply;
 };
 
 struct kvm_introspection {
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 38954a5297da..e6a4667546b5 100644
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
@@ -125,4 +131,11 @@ struct kvmi_event {
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
index bc84d478ff6b..990c78a7af0a 100644
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
@@ -680,9 +686,45 @@ static void pause_vcpu(struct kvm_vm *vm)
 		-r, kvm_strerror(-r));
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
+		"send() failed, sending %d, result %d, errno %d (%s)\n",
+		rpl_size, r, errno, strerror(errno));
+}
+
 static void test_pause(struct kvm_vm *vm)
 {
+	struct vcpu_worker_data data = {.vm = vm, .vcpu_id = VCPU_ID};
+	__u16 event_id = KVMI_EVENT_PAUSE_VCPU;
+	struct vcpu_reply rpl = {};
+	struct kvmi_msg_hdr hdr;
+	pthread_t vcpu_thread;
+	struct kvmi_event ev;
+
 	pause_vcpu(vm);
+
+	vcpu_thread = start_vcpu_worker(&data);
+
+	receive_event(&hdr, &ev, sizeof(ev), event_id);
+
+	reply_to_event(&hdr, &ev, KVMI_EVENT_ACTION_CONTINUE,
+			&rpl, sizeof(rpl));
+
+	stop_vcpu_worker(vcpu_thread, &data);
 }
 
 static void test_introspection(struct kvm_vm *vm)
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index c4da264ad5a6..2b8e6910e57b 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -316,6 +316,7 @@ static void kvmi_job_release_vcpu(struct kvm_vcpu *vcpu, void *ctx)
 	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
 
 	atomic_set(&vcpui->pause_requests, 0);
+	vcpui->waiting_for_reply = false;
 }
 
 static void kvmi_release_vcpus(struct kvm *kvm)
@@ -706,12 +707,30 @@ void kvmi_run_jobs(struct kvm_vcpu *vcpu)
 	}
 }
 
+void kvmi_handle_common_event_actions(struct kvm *kvm,
+				      u32 action, const char *str)
+{
+	switch (action) {
+	default:
+		kvmi_err(KVMI(kvm), "Unsupported action %d for event %s\n",
+			 action, str);
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
+		kvmi_handle_common_event_actions(vcpu->kvm, action, "PAUSE");
+	}
 }
 
 void kvmi_handle_requests(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index bd968e837a54..8fe74b32a5f6 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -28,6 +28,7 @@ void kvmi_sock_shutdown(struct kvm_introspection *kvmi);
 void kvmi_sock_put(struct kvm_introspection *kvmi);
 bool kvmi_msg_process(struct kvm_introspection *kvmi);
 int kvmi_msg_send_unhook(struct kvm_introspection *kvmi);
+u32 kvmi_msg_send_vcpu_pause(struct kvm_vcpu *vcpu);
 
 /* kvmi.c */
 void *kvmi_msg_alloc(void);
@@ -35,6 +36,7 @@ void kvmi_msg_free(void *addr);
 int kvmi_add_job(struct kvm_vcpu *vcpu,
 		 void (*fct)(struct kvm_vcpu *vcpu, void *ctx),
 		 void *ctx, void (*free_fct)(void *ctx));
+void kvmi_run_jobs(struct kvm_vcpu *vcpu);
 int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
 				unsigned int event_id, bool enable);
 int kvmi_cmd_read_physical(struct kvm *kvm, u64 gpa, size_t size,
@@ -49,5 +51,6 @@ int kvmi_cmd_vcpu_pause(struct kvm_vcpu *vcpu, bool wait);
 /* arch */
 int kvmi_arch_cmd_vcpu_get_info(struct kvm_vcpu *vcpu,
 				struct kvmi_vcpu_get_info_reply *rpl);
+void kvmi_arch_setup_event(struct kvm_vcpu *vcpu, struct kvmi_event *ev);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 772ba1d7d9df..a56926f22bc6 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -20,6 +20,7 @@ struct kvmi_vcpu_cmd_job {
 };
 
 static const char *const msg_IDs[] = {
+	[KVMI_EVENT]             = "KVMI_EVENT",
 	[KVMI_GET_VERSION]       = "KVMI_GET_VERSION",
 	[KVMI_VM_CHECK_COMMAND]  = "KVMI_VM_CHECK_COMMAND",
 	[KVMI_VM_CHECK_EVENT]    = "KVMI_VM_CHECK_EVENT",
@@ -373,6 +374,74 @@ static int handle_get_vcpu_info(const struct kvmi_vcpu_cmd_job *job,
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
+static int handle_event_reply(const struct kvmi_vcpu_cmd_job *job,
+			      const struct kvmi_msg_hdr *msg, const void *rpl)
+{
+	struct kvm_vcpu_introspection *vcpui = VCPUI(job->vcpu);
+	struct kvmi_vcpu_reply *expected = &vcpui->reply;
+	const struct kvmi_event_reply *reply = rpl;
+	const void *reply_data = reply + 1;
+	size_t useful, received;
+	u8 action;
+
+	if (unlikely(!vcpui->waiting_for_reply)) {
+		expected->error = -EINTR;
+		goto out;
+	}
+
+	expected->error = check_event_reply(msg, reply, expected, &action,
+					    &received);
+	if (unlikely(expected->error)) {
+		kvmi_err(KVMI(job->vcpu->kvm),
+			 "Invalid event reply %d seq %x\n",
+			 reply->event, msg->seq);
+		goto out;
+	}
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
  * These commands are executed from the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_cmd_job'
@@ -381,6 +450,7 @@ static int handle_get_vcpu_info(const struct kvmi_vcpu_cmd_job *job,
  */
 static int(*const msg_vcpu[])(const struct kvmi_vcpu_cmd_job *,
 			      const struct kvmi_msg_hdr *, const void *) = {
+	[KVMI_EVENT]         = handle_event_reply,
 	[KVMI_VCPU_GET_INFO] = handle_get_vcpu_info,
 };
 
@@ -466,7 +536,7 @@ static int kvmi_msg_dispatch_vm_cmd(struct kvm_introspection *kvmi,
 
 static bool is_message_allowed(struct kvm_introspection *kvmi, u16 id)
 {
-	return is_command_allowed(kvmi, id);
+	return id == KVMI_EVENT || is_command_allowed(kvmi, id);
 }
 
 static int kvmi_msg_vm_reply_ec(struct kvm_introspection *kvmi,
@@ -477,7 +547,8 @@ static int kvmi_msg_vm_reply_ec(struct kvm_introspection *kvmi,
 
 static bool vcpu_can_handle_commands(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.mp_state != KVM_MP_STATE_UNINITIALIZED;
+	return VCPUI(vcpu)->waiting_for_reply
+		|| vcpu->arch.mp_state != KVM_MP_STATE_UNINITIALIZED;
 }
 
 static bool kvmi_get_vcpu_if_ready(struct kvm_introspection *kvmi,
@@ -584,6 +655,13 @@ static void kvmi_setup_event_common(struct kvmi_event *ev, u32 ev_id,
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
@@ -600,3 +678,85 @@ int kvmi_msg_send_unhook(struct kvm_introspection *kvmi)
 
 	return kvmi_sock_write(kvmi, vec, n, msg_size);
 }
+
+static int kvmi_wait_for_reply(struct kvm_vcpu *vcpu)
+{
+	struct swait_queue_head *wq = kvm_arch_vcpu_wq(vcpu);
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+	int err = 0;
+
+	while (vcpui->waiting_for_reply && !err) {
+		kvmi_run_jobs(vcpu);
+
+		err = swait_event_killable_exclusive(*wq,
+			!vcpui->waiting_for_reply ||
+			!list_empty(&vcpui->job_list));
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
+	size_t n = ev_size ? ARRAY_SIZE(vec) : ARRAY_SIZE(vec)-1;
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
+	if (err)
+		goto out;
+
+	*action = vcpui->reply.action;
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
